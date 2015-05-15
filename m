From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH] megaraid_sas : Modify return value of megasas_issue_blocked_cmd()
 and wait_and_poll() to consider command status returned by firmware
Date: Fri, 15 May 2015 15:14:36 +0530
Message-ID: <42c4a6dc48b0f8334f8b32e5f95c70ac@mail.gmail.com>
References: <201505061333.t46DXdcM032441@palmhbs0.lsi.com> <5555BD8E.1@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:32899 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922AbbEOJoi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 05:44:38 -0400
Received: by qkp63 with SMTP id 63so29255870qkp.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 02:44:37 -0700 (PDT)
In-Reply-To: <5555BD8E.1@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, thenzl@redhat.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Friday, May 15, 2015 3:04 PM
>To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
>Cc: stable@vger.kernel.org; martin.petersen@oracle.com;
>hch@infradead.org; jbottomley@parallels.com; thenzl@redhat.com;
>kashyap.desai@avagotech.com
>Subject: Re: [PATCH] megaraid_sas : Modify return value of
>megasas_issue_blocked_cmd() and wait_and_poll() to consider command
>status returned by firmware
>
>On 05/06/2015 03:31 PM, Sumit.Saxena@avagotech.com wrote:
>> This patch is rebased on top of recently sent 18 patches(submitted b=
y
me)
>for megaraid_sas driver.
>>
>> Change the return value of wait_and_poll() and
>> megsas_issue_blocked_cmd() based on MFI_STAT returned by firmware fo=
r
>> that command. Earlier driver always send return type based on comman=
d
>> completion (but never check MFI_STAT_OK for that command), so even i=
f
>> command is failed by firmware still driver will return SUCCESS statu=
s
from
>these functions wait_and_poll() and megsas_issue_blocked_cmd() and if
>caller of these functions does not check command status (MFI_STAT), th=
en
it
>may endup using invalid data returned in DMA buffers(one of the exampl=
e
is
>megasas_ld_list_query DCMD). Best thing to avoid this type of issue is=
 do
>error handling and set proper return type from caller function
wait_and_poll()
>and megsas_issue_blocked_cmd().
>>
>> The change proposed in this patch will fix the regression introduced
>> in patch- "90dc9d9 megaraid_sas : MFI MPT linked list corruption fix=
"
inside
>function megasas_ld_list_query().
>> Prior to this MFI MPT linked list corruption fix patch,
>> megasas_ld_list_query() function used to check DCMD status(returned =
by
>> firmware) but with this linked list corruption fix patch, DCMD statu=
s
will not
>be checked inside function megasas_ld_list_query() and introduced this
issue
>of wrong data being used by function megasas_ld_list_query().
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>> ---
>>  drivers/scsi/megaraid/megaraid_sas.h        |    2 +-
>>  drivers/scsi/megaraid/megaraid_sas_base.c   |   67
+++++++++++------------
>----
>>  drivers/scsi/megaraid/megaraid_sas_fusion.c |    3 +-
>>  3 files changed, 30 insertions(+), 42 deletions(-)
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>> b/drivers/scsi/megaraid/megaraid_sas.h
>> index 53a3c3f..20c3754 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>> @@ -1894,7 +1894,7 @@ struct megasas_cmd {
>>
>>  	u32 index;
>>  	u8 sync_cmd;
>> -	u8 cmd_status;
>> +	u8 cmd_status_drv;
>>  	u8 abort_aen;
>>  	u8 retry_for_fw_reset;
>>
>Can you please avoid the renaming here?
>It doesn't serve any purpose, and keeping it will make the diff smalle=
r.

=46or readability we make this "cmd_status_drv", since this is driver's
internal structure(so drv suffix). Same name "cmd_status "is used in
multiple structs(megasas_hdr, megasas_init_frame, megasas_io_frame) whi=
ch
are shared across driver and other components(firmware and applications=
).
Also, keeping it "cmd_status" will not make patch smaller since "ENODAT=
A"
is also replaced by "MFI_STAT_INVALID_STATUS" in most of lines, where
"cmd_status_drv" is referenced.

Thanks,
Sumit
>
>Cheers,
>
>Hannes
>--
>Dr. Hannes Reinecke		               zSeries & Storage
>hare@suse.de			               +49 911 74053 688
>SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
>GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton =
HRB
21284
>(AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
