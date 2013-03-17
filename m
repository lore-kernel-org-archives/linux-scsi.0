From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH][RFC] scsi: Use W_LUN for scanning
Date: Sun, 17 Mar 2013 22:50:26 +0100
Message-ID: <51463AA2.4090901@linux.vnet.ibm.com>
References: <1363340771-46925-1-git-send-email-hare@suse.de> <51434435.2060900@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:44096 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756517Ab3CQVud convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Mar 2013 17:50:33 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Sun, 17 Mar 2013 21:47:48 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
	by d06dlp02.portsmouth.uk.ibm.com (Postfix) with ESMTP id 84BBD219005A
	for <linux-scsi@vger.kernel.org>; Sun, 17 Mar 2013 21:52:09 +0000 (GMT)
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by b06cxnps3074.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r2HLoJcZ47906870
	for <linux-scsi@vger.kernel.org>; Sun, 17 Mar 2013 21:50:19 GMT
Received: from d06av06.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r2HLoSLS019114
	for <linux-scsi@vger.kernel.org>; Sun, 17 Mar 2013 15:50:28 -0600
In-Reply-To: <51434435.2060900@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, George Martin <marting@netapp.com>, Mike Christie <michaelc@cs.wisc.edu>

just a small addendum regarding the naming of the w_lun variable

On 03/15/2013 04:54 PM, Steffen Maier wrote:
> While we're at it: I recently figured that there are targets respondi=
ng
> to inquiry with PQ=3D1 && PDT=3D31 for LUN0 if LUN0 has no backing de=
vice
> (e.g. no disk mapped for the initiator host). While this is likely to
> work with in-kernel lun scanning, the kernel does not even allocate a=
n
> sg dev in this case.
> If the target (such do exist) now also does not support report_luns o=
n
> WLUN, this effectively prevents any user space lun discovery.
> E.g. non-NPIV zfcp-attached LUNs cannot be discovered, because we can=
not
> do in-kernel scanning due to the lack of initiator lun masking.
>
> The reason for Linux ignoring LUNs with PDT=3D31 and PQ=3D1 is:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D84961f28e9d13a4b193d0c8545f3c060c1890ff3
> [SCSI] Don't add scsi_device for devices that return PQ=3D1, PDT=3D0x=
1f
> from kernel 2.6.19.
> Since Linux on System z could no longer perform report luns with IBM
> DS8000, the following workaround was implemented:
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit=
/?id=3D01b291bd66564b4bd826326af6bd0b6d17e99439
> [SCSI] fix check of PQ and PDT bits for WLUNs
> in kernel 2.6.27.
> However, this only works for WLUNs reporting PDT=3D31 and PQ=3D1 but =
not for
> LUN0.
> What made it worse is that, the attached LUN looks perfect from a zfc=
p
> status point of view but is still missing any user visible handle for
> the scsi midlayer, so I was puzzled as a user despite the otherwise
> clear scsi log message:
> "scsi scan: peripheral device type of 31, ***no device added***".
>
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

Meanwhile I realized why I sometimes had to think twice to understand=20
below code: The naming of the identifier "w_lun" is misleading to me=20
because it seems to imply that the variable (always) contains the value=
=20
of the WLUN while in fact it could also contain LUN0. Maybe the variabl=
e=20
should just be called "lun"?

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
> check is on its own inside the outer if statement with exactly the sa=
me
> boolean expression.
>
>
>> +        }
>>           if (scsi_device_get(sdev)) {
>>               __scsi_remove_device(sdev);
>>               return 0;
>
> Now that we not only use LUN0, it would be nice to reflect the curren=
tly
> used LUN in the corresponding scsi logging statements for debugging a=
nd
> problem determination purposes.
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
>>         SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan: REPORT LU=
NS"
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
> Did you mean _!_scsi_device_created(sdev), i.e. we tried WLUN but cou=
ld
> not attach it?
>
>> +            /*
>> +             * W_LUN probably not supported, try with LUN 0
>> +             */
>
> Does this only check for an sg dev having been created or does it che=
ck
> for the response to the report_luns cmnd? It should be the latter sin=
ce
> there are targets allowing attachment of WLUN (with PQ=3D1 && PDT=3D3=
1) but
> refuse to answer report_luns, e.g. IBM SVC / Storwize V7000.
> Remember your changes to zfcp_san_disc reacting on sg_luns return cod=
e?
> [Novell bug 742352]
> It would be nice if we could avoid start using BLIST_NO_WLUN right aw=
ay.
> ;-)
>
>> +            SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "scsi scan:"
>> +                    "W_LUN not supported, try LUN 0\n"));
>> +            kfree(lun_data);
>> +            scsi_device_put(sdev);
>> +            __scsi_remove_device(sdev);
>> +            w_lun =3D 0;
>> +            goto retry_report_lun_scan;
>> +        }
>>           /*
>>            * The device probably does not support a REPORT LUN comma=
nd
>>            */
>> diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo=
=2Eh
>> index cc1f3e7..ffb42b1 100644
>> --- a/include/scsi/scsi_devinfo.h
>> +++ b/include/scsi/scsi_devinfo.h
>> @@ -31,4 +31,5 @@
>>   #define BLIST_MAX_512        0x800000 /* maximum 512 sector cdb
>> length */
>>   #define BLIST_ATTACH_PQ3    0x1000000 /* Scan: Attach to PQ3 devic=
es */
>>   #define BLIST_NO_DIF        0x2000000 /* Disable T10 PI (DIF) */
>> +#define BLIST_NO_WLUN        0x4000000 /* Disable W_LUN scanning */
>>   #endif
>>
>
> The overall idea seems reasonable to me.

Steffen

Linux on System z Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Gesch=E4ftsf=FChrung: Dirk Wittkopp
Sitz der Gesellschaft: B=F6blingen
Registergericht: Amtsgericht Stuttgart, HRB 243294

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
