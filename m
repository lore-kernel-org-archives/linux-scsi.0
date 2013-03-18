From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] scsi: Use W_LUN for scanning
Date: Mon, 18 Mar 2013 16:25:00 +0100
Message-ID: <514731CC.5020609@suse.de>
References: <1363340771-46925-1-git-send-email-hare@suse.de> <51434435.2060900@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49549 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab3CRPZC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Mar 2013 11:25:02 -0400
In-Reply-To: <51434435.2060900@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, George Martin <marting@netapp.com>, Mike Christie <michaelc@cs.wisc.edu>

On 03/15/2013 04:54 PM, Steffen Maier wrote:
> While we're at it: I recently figured that there are targets
> responding to inquiry with PQ=3D1 && PDT=3D31 for LUN0 if LUN0 has no
> backing device (e.g. no disk mapped for the initiator host). While
> this is likely to work with in-kernel lun scanning, the kernel does
> not even allocate an sg dev in this case.
Yes.

> If the target (such do exist) now also does not support report_luns
> on WLUN, this effectively prevents any user space lun discovery.
> E.g. non-NPIV zfcp-attached LUNs cannot be discovered, because we
> cannot do in-kernel scanning due to the lack of initiator lun masking=
=2E
>
Yes, I know; the NetApp case.
But you can always initiate a user-space discovery by

echo '- - -' > /sys/class/scsi_host/hostX/scan

> The reason for Linux ignoring LUNs with PDT=3D31 and PQ=3D1 is:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D84961f28e9d13a4b193d0c8545f3c060c1890ff3
>
> [SCSI] Don't add scsi_device for devices that return PQ=3D1, PDT=3D0x=
1f
> from kernel 2.6.19.
> Since Linux on System z could no longer perform report luns with IBM
> DS8000, the following workaround was implemented:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D01b291bd66564b4bd826326af6bd0b6d17e99439
>
> [SCSI] fix check of PQ and PDT bits for WLUNs
> in kernel 2.6.27.
> However, this only works for WLUNs reporting PDT=3D31 and PQ=3D1 but =
not
> for LUN0.
> What made it worse is that, the attached LUN looks perfect from a
> zfcp status point of view but is still missing any user visible
> handle for the scsi midlayer, so I was puzzled as a user despite the
> otherwise clear scsi log message:
> "scsi scan: peripheral device type of 31, ***no device added***".
>

Hmm. You sure this is still valid today?
Assuming the device supports REPORT LUNS we're having this:

	res =3D scsi_probe_and_add_lun(starget, 0, &bflags, NULL, rescan, NULL=
);
	if (res =3D=3D SCSI_SCAN_LUN_PRESENT || res =3D=3D SCSI_SCAN_TARGET_PR=
ESENT) {
		if (scsi_report_lun_scan(starget, bflags, rescan) !=3D 0)
			/*
			 * The REPORT LUN did not scan the target,
			 * do a sequential scan.
			 */
			scsi_sequential_lun_scan(starget, bflags,
						 starget->scsi_level, rescan);
	}

  out_reap:
	scsi_autopm_put_target(starget);
	/* now determine if the target has any children at all
	 * and if not, nuke it */
	scsi_target_reap(starget);

So we don't actually need an sdev to invoke a report lun scan;
all we require is a correct return code from scsi_probe_and_add_lun().
Which we'll get irrespective of the PQ setting.
So from what I'm seeing this case should be covered.
Unless I'm missing something ...

> On 03/15/2013 10:46 AM, Hannes Reinecke wrote:
>> SAM advertises the use of a Well-known LUN (W_LUN) for scanning.
>> As this avoids exposing LUN 0 (which might be a valid LUN) for
>> all initiators it is the preferred method for LUN scanning on
>> some arrays.
>> So we should be using W_LUN for scanning, too. If the W_LUN is
>> not supported we'll fall back to use LUN 0.
>> For broken W_LUN implementations a new blacklist flag
>> 'BLIST_NO_WLUN' is added.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 3e58b22..f4ccdea 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1312,6 +1312,7 @@ static int scsi_report_lun_scan(struct
>> scsi_target *starget, int bflags,
>>       unsigned int num_luns;
>>       unsigned int retries;
>>       int result;
>> +    int w_lun =3D SCSI_W_LUN_REPORT_LUNS;
>>       struct scsi_lun *lunp, *lun_data;
>>       u8 *data;
>>       struct scsi_sense_hdr sshdr;
>> @@ -1337,11 +1338,20 @@ static int scsi_report_lun_scan(struct
>> scsi_target *starget, int bflags,
>>           return 0;
>>       if (starget->no_report_luns)
>>           return 1;
>> +    if (bflags & BLIST_NO_WLUN)
>> +        w_lun =3D 0;
>>
>> +retry_report_lun_scan:
>>       if (!(sdev =3D scsi_device_lookup_by_target(starget, 0))) {
>> -        sdev =3D scsi_alloc_sdev(starget, 0, NULL);
>> -        if (!sdev)
>> -            return 0;
>> +        sdev =3D scsi_alloc_sdev(starget, w_lun, NULL);
>> +        if (!sdev) {
>> +            if (w_lun !=3D 0) {
>> +                w_lun =3D 0;
>> +                sdev =3D scsi_alloc_sdev(starget, w_lun, NULL);
>> +            }
>
>> +            if (!sdev)
>> +                return 0;
>
> Semantically this belongs to the 2nd scsi_alloc_sdev(starget, w_lun,
> NULL) i.e. inside (at the end of) the body of if (w_lun !=3D 0).
> Then you can even merge the outer and inner if statement to
> if (!sdev && wlun !=3D 0)
> Semantics: WLUN did not work and we haven't already tried LUN0.
> Maybe it's just me but I found it more difficult to read if the 2nd
> check is on its own inside the outer if statement with exactly the
> same boolean expression.
>
>
>> +        }
>>           if (scsi_device_get(sdev)) {
>>               __scsi_remove_device(sdev);
>>               return 0;
>
> Now that we not only use LUN0, it would be nice to reflect the
> currently used LUN in the corresponding scsi logging statements for
> debugging and problem determination purposes.
> It seems as if devname only contains HCT but not L, which can now be
> either WLUN or LUN0, e.g. here:
>
>>     for (retries =3D 0; retries < 3; retries++) {
>>         SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: Sending"
>>                 " REPORT LUNS to %s (try %d)\n", devname,
>>                 retries));
>>
>>         result =3D scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
>>                       lun_data, length, &sshdr,
>>                       SCSI_TIMEOUT + 4 * HZ, 3, NULL);
>>
>>         SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT
>> LUNS"
>>                 " %s (try %d) result 0x%x\n", result
>>                 ?  "failed" : "successful", retries, result));
>
>> @@ -1418,6 +1428,18 @@ static int scsi_report_lun_scan(struct
>> scsi_target *starget, int bflags,
>>       }
>>
>>       if (result) {
>> +        if (w_lun !=3D 0 && scsi_device_created(sdev)) {
>
> Did you mean _!_scsi_device_created(sdev), i.e. we tried WLUN but
> could not attach it?
>
>> +            /*
>> +             * W_LUN probably not supported, try with LUN 0
>> +             */
>
> Does this only check for an sg dev having been created or does it
> check for the response to the report_luns cmnd? It should be the
> latter since there are targets allowing attachment of WLUN (with
> PQ=3D1 && PDT=3D31) but refuse to answer report_luns, e.g. IBM SVC /
> Storwize V7000.

Hmm?
Targets supporting WLUN but refuse to answer report_luns on them?
This is the 'REPORT_LUNs WLUN' we're talking to.
The _sole_ purpose of which is to _answer_ to REPORT_LUNS.

Not answering to REPORT LUNS seems to be a violation of
SPC, where support for REPORT LUNs is mandatory.

But in either case, that's why I did the blacklist flag.
We would need to add those devices to it.

Anyway, you are correct in that we need to check the response
from report_luns. I'll cross check here.

> Remember your changes to zfcp_san_disc reacting on sg_luns return
> code? [Novell bug 742352]
> It would be nice if we could avoid start using BLIST_NO_WLUN right
> away. ;-)
>
Oh, that was the idea.

>> +            SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan:"
>> +                    "W_LUN not supported, try LUN 0\n"));
>> +            kfree(lun_data);
>> +            scsi_device_put(sdev);
>> +            __scsi_remove_device(sdev);
>> +            w_lun =3D 0;
>> +            goto retry_report_lun_scan;
>> +        }
>>           /*
>>            * The device probably does not support a REPORT LUN
>> command
>>            */
>> diff --git a/include/scsi/scsi_devinfo.h
>> b/include/scsi/scsi_devinfo.h
>> index cc1f3e7..ffb42b1 100644
>> --- a/include/scsi/scsi_devinfo.h
>> +++ b/include/scsi/scsi_devinfo.h
>> @@ -31,4 +31,5 @@
>>   #define BLIST_MAX_512        0x800000 /* maximum 512 sector cdb
>> length */
>>   #define BLIST_ATTACH_PQ3    0x1000000 /* Scan: Attach to PQ3
>> devices */
>>   #define BLIST_NO_DIF        0x2000000 /* Disable T10 PI (DIF) */
>> +#define BLIST_NO_WLUN        0x4000000 /* Disable W_LUN scanning */
>>   #endif
>>
>
> The overall idea seems reasonable to me.
>
See?

I'll be updating the patch.

Cheers,

Hannes]
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
