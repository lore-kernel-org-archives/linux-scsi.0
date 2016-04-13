From: Xinwei Kong <kong.kongxinwei@hisilicon.com>
Subject: Re: [PATCH 1/1] scsi: usb: fix bug which some usb isn't used
Date: Wed, 13 Apr 2016 10:16:14 +0800
Message-ID: <570DABEE.3000308@hisilicon.com>
References: <1460464554-14116-1-git-send-email-kong.kongxinwei@hisilicon.com>
 <570CEDCF.8010505@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:24467 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932848AbcDMCSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 22:18:49 -0400
In-Reply-To: <570CEDCF.8010505@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linuxraid@lsi.com, James.Bottomley@HansenPartnership.com, hch@lst.de, snitzer@redhat.com
Cc: martin.petersen@oracle.com, JBottomley@Odin.com, linux-scsi@vger.kernel.org, "liguozhu@hisilicon.com" <liguozhu@hisilicon.com>



On 2016/4/12 20:45, Hannes Reinecke wrote:
> On 04/12/2016 02:35 PM, Xinwei Kong wrote:
>> some usb disk such as Manufacturer Lenovo will have some problem in
>> init process.
>>
>> when it run "scsi_dh_find_driver" function, because this parameter of
>> "sdev->inquiry[5]" is 115, it will return "alua" in "scsi_dh_find_driver"
>> function and will have some error log (alua: Attach failed (-22)). some
>> usb init will fail and isn't used.
>>
>> Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
>> ---
>>  drivers/scsi/scsi_dh.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
>> index 54d446c..36b3f354e 100644
>> --- a/drivers/scsi/scsi_dh.c
>> +++ b/drivers/scsi/scsi_dh.c
>> @@ -77,9 +77,6 @@ scsi_dh_find_driver(struct scsi_device *sdev)
>>  {
>>  	const struct scsi_dh_blist *b;
>>  
>> -	if (scsi_device_tpgs(sdev))
>> -		return "alua";
>> -
>>  	for (b = scsi_dh_blist; b->vendor; b++) {
>>  		if (!strncmp(sdev->vendor, b->vendor, strlen(b->vendor)) &&
>>  		    !strncmp(sdev->model, b->model, strlen(b->model))) {
>>
> Nack.
> That will completely disable ALUA support for everybody.
> 
> And should've been fixed with commit
> 221255aee67ec1c752001080aafec0c4e9390d95
> ("scsi: ignore errors from scsi_dh_add_device()").
> 
> Please validate.
> 
ok, I slove this bug for using this patch.

thank you
xinwei
> Cheers,
> 
> Hannes
> 

