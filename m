From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 14/20] [SCSI] mpt3sas: Complete the SCSI command with
 DID_RESET status for log_info value 0x0x32010081
Date: Mon, 15 Jun 2015 16:31:02 +0530
Message-ID: <CAK=zhgr9qEG1n=w6gncrhJVhQ4=RxoCONqYREh4BLCvWZS2EHg@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-15-git-send-email-Sreekanth.Reddy@avagotech.com>
	<20150615100156.GL5660@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:36611 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080AbbFOLBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jun 2015 07:01:04 -0400
Received: by wgzl5 with SMTP id l5so40743912wgz.3
        for <linux-scsi@vger.kernel.org>; Mon, 15 Jun 2015 04:01:03 -0700 (PDT)
In-Reply-To: <20150615100156.GL5660@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Mon, Jun 15, 2015 at 3:31 PM, Johannes Thumshirn <jthumshirn@suse.de=
> wrote:
> On Fri, Jun 12, 2015 at 03:12:26PM +0530, Sreekanth Reddy wrote:
>> For any SCSI command, if the driver receives
>> IOC status =3D SCSI_IOC_TERMINATED and log info =3D 0x32010081 then
>> that command will be completed with DID_RESET host status.
>>
>> The definition of this log info value is
>> "Virtual IO has failed and has to be retried".
>>
>> Firmware will provide this log info value with IOC Status
>> "SCSI_IOC_TERMINATED", whenever a drive (with is a part of a volume)
>> is pulled and pushed back within some minimal delay.
>> With this log info value, firmware informs the driver to retry the
>> failed IO command infinite times, so to provide some time for the
>> firmware to discover the reinserted drive successfully instated of
>> just retrying failed command for five times(doesn't giving enough
>> time for firmware to complete the drive discovery) and failing the
>> IO permanently even though drive came back successfully.
>>
>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt=
3sas/mpt3sas_scsih.c
>> index 64dd90b..837c22a 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -4241,6 +4241,9 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u1=
6 smid, u8 msix_index, u32 reply)
>>                               scmd->device->expecting_cc_ua =3D 1;
>>                       }
>>                       break;
>> +             } else if (log_info =3D=3D 0x32010081) {
>> +                     scmd->result =3D DID_RESET << 16;
>> +                     break;
>
> Could you make that a #define instead of some magic vlaue, so everyon=
e can see
> what is happening when reading the source?

Sure, I will define a macro for this log_info value.

Thanks,
Sreekanth
>
>>               }
>>               scmd->result =3D DID_SOFT_ERROR << 16;
>>               break;
>> --
>> 2.0.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> Johannes Thumshirn                                       Storage
> jthumshirn@suse.de                             +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)



--=20

Regards,
Sreekanth
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
