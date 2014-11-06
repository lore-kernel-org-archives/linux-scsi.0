From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 6/6] scsi: return EAGAIN when resetting a device under
 EH
Date: Thu, 06 Nov 2014 17:55:36 -0500
Message-ID: <545BFC68.2080705@interlog.com>
References: <1414661229-15199-1-git-send-email-hch@lst.de> <1414661229-15199-7-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402959377FC3@G4W3202.americas.hpqcorp.net>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46256 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaKFWzq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 17:55:46 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402959377FC3@G4W3202.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 14-11-06 04:46 PM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch@lst.de]
>> Sent: Thursday, 30 October, 2014 4:27 AM
>> To: linux-scsi@vger.kernel.org
>> Cc: Douglas Gilbert; Elliott, Robert (Server Storage)
>> Subject: [PATCH 6/6] scsi: return EAGAIN when resetting a device
>> under EH
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>   drivers/scsi/scsi_ioctl.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
>> index 712f159..c4f7b56 100644
>> --- a/drivers/scsi/scsi_ioctl.c
>> +++ b/drivers/scsi/scsi_ioctl.c
>> @@ -278,7 +278,7 @@ int
>> scsi_ioctl_block_when_processing_errors(struct scsi_device *sdev, int
>> cmd,
>>   {
>>   	if (cmd == SG_SCSI_RESET && ndelay) {
>>   		if (scsi_host_in_recovery(sdev->host))
>> -			return -ENODEV;
>> +			return -EAGAIN;
>>   	} else {
>>   		if (!scsi_block_when_processing_errors(sdev))
>>   			return -ENODEV;
>> --
>> 1.9.1
>
> This is how sg_reset responds to -EAGAIN, which seems reasonable:
> 	sg_reset: starting device reset
> 	sg_reset: SG_SCSI_RESET failed: Resource temporarily unavailable

That message has been tweaked so in sg3_utils version 1.40
that will read:
    sg_reset: try again later, may be resetting now

> That is easy to trigger when running sg_reset in parallel to
> multiple devices presented by the same controller.  In one
> example to 16 devices, 10 got that result while 6 succeeded.
>
> Tested-by: Robert Elliott <elliott@hp.com>
> Reviewed-by: Robert Elliott <elliott@hp.com>

