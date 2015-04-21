From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 18/18] megaraid_sas : swap whole register in megasas_register_aen
Date: Tue, 21 Apr 2015 18:12:01 +0530
Message-ID: <17496cfabed5e1d59145d3f120fcff30@mail.gmail.com>
References: <201504201237.t3KCbWt3016906@palmhbs0.lsi.com> <55364388.6040403@redhat.com>
 <20150421123719.GA7205@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:33978 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbbDUMmC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 08:42:02 -0400
Received: by qgfi89 with SMTP id i89so67364241qgf.1
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2015 05:42:02 -0700 (PDT)
In-Reply-To: <20150421123719.GA7205@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Tuesday, April 21, 2015 6:07 PM
>To: Tomas Henzl
>Cc: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org;
>martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH RESEND 18/18] megaraid_sas : swap whole register in
>megasas_register_aen
>
>On Tue, Apr 21, 2015 at 02:33:12PM +0200, Tomas Henzl wrote:
>> On 04/20/2015 02:35 PM, Sumit.Saxena@avagotech.com wrote:
>> > Swap the whole 32 bits we read from the hardware instead of swapping
>> > just the 16bits we care about in place later.
>> >
>> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>> > ---
>> >  drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
>> >  1 files changed, 3 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>> > b/drivers/scsi/megaraid/megaraid_sas_base.c
>> > index e863701..fa6c3c9 100644
>> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>> > @@ -4923,8 +4923,9 @@ megasas_register_aen(struct megasas_instance
>> > *instance, u32 seq_num,
>> >
>> >  	if (instance->aen_cmd) {
>> >
>> > -		prev_aen.word = instance->aen_cmd->frame-
>>dcmd.mbox.w[1];
>> > -		prev_aen.members.locale =
>le16_to_cpu(prev_aen.members.locale);
>> > +		prev_aen.word =
>> > +			le32_to_cpu(instance->aen_cmd->frame-
>>dcmd.mbox.w[1]);
>> > +		prev_aen.members.locale = prev_aen.members.locale;
>>
>> This^ looks odd, do we need the last assignment?
>
>Obviously not, I was just in mechnical mode when doing this.
>
>It can be dropped for the repost.

Will drop it in resubmission of the patch.
