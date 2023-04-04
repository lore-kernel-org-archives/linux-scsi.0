Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8014FC76188
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 23:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbjDDXfy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 19:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbjDDXfv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 19:35:51 -0400
Received: from wnew2-smtp.messagingengine.com (wnew2-smtp.messagingengine.com [64.147.123.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB5140E1;
        Tue,  4 Apr 2023 16:35:49 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id DC6982B0675A;
        Tue,  4 Apr 2023 19:27:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 04 Apr 2023 19:28:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1680650879; x=1680654479; bh=YxkAmxK1zswz2lqPujpek6f+bsZQ/uTM/0p
        JBTFY+0s=; b=RgOQ3BV9MkeDaJGyQVpF773aPQ5apHHPTMX6jTVl1BYSaa17lTe
        LyfsXpauMNWehrmtzPpgvI+dHFIrtvPuqvI8ElUdY7bGIoxck9cp85iaREFZIVZR
        1PGZ2IivbTc4AP3uUcev9Ol4C2W+v8+uwTdGlDQQDK6j/Jlp6cKKexT+wkqMqUHt
        5U047/HW9BwidRlxkLqg6arPL5sOpTRRwk1BJ+dHSgIHC4uALKsspnn0AvtH4Hf0
        ddV1lJsr2gR5wZQUAGW/SE4U+9OfHL7Vc/LnC3rFQMKFnsHKRxXBjWXz9QxCPEzq
        78/DRqZGNyW9OmBs4tEuLvO1vrMpjcbMcbQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=i3db14652.fm2;
         t=1680650879; x=1680654479; bh=YxkAmxK1zswz2lqPujpek6f+bsZQ/uTM
        /0pJBTFY+0s=; b=ifxEfUgNbkbRIQw7Q6H53FbkRjk1McGtSPGMp324n248Camb
        hdzMwjA1M4+wmgnXKf1PmSMn8A0kGKQ8rd8L9+BuYjUj0wpSmKhDB2CuRx1RpZhT
        CG0Xo4W46ztqT0pO91UTylrV6V07hZkUfLW5VJEshCjvksB5sn65LrR1TdAmBO0n
        QbPMHIypR8DA9r7c/ZQfxnFOV78IIHDWTAM7uzZbD2sylawun33Qt55evCb+mbN3
        IKJDpmraRJxLhObX7cbsP0cgMFSqwVBAK6kNhXVox+2FYcN3EVzt1ZHSeH8mg83q
        OSo1Iq8HYmc0ri804mbXAi6ZY23bj3iRQN8geQ==
X-ME-Sender: <xms:frIsZFUXtZst1_dXKP4DaVYZ-GsPMSQtNDchXQSjyFOFb0S4Qu1Cmw>
    <xme:frIsZFlpY3-AWjgNsaIHDrpUDnog8AwpxhHTar7TN12YDnzCA5tsTjKYJQUAIOfAR
    lFyMD6Od03G67G-Kmg>
X-ME-Received: <xmr:frIsZBYpZtEprw4C0EKNGrkLxqgqgY4XhiSkVRhV4aYSR1EbMRn9QssaaDv5r1tWRILay_W2e5XzQrDMt3ETxrOFYBeEB5CZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdejtddgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffvvehfhfgjtgfgsehtjeertddtfeejnecuhfhrohhmpeffrghm
    ihgvnhcunfgvucfoohgrlhcuoegulhgvmhhorghlsehfrghsthhmrghilhdrtghomheqne
    cuggftrfgrthhtvghrnhepteefiefhieetgfevhfegfeehffetteduieetudfgleetvdff
    udelveejfefhfeejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepughlvghmohgrlhesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:frIsZIWulCr_LtPKiTuMbdwiMsmzmtpqFOeP9Q7UPvsXSHVfALm9bA>
    <xmx:frIsZPmQ-SqBrMQ6OoOosCElUB1r3MJdclxXZYh5pcrkvlq-b_08JA>
    <xmx:frIsZFcM9ZjtYJzr35R244tlu0xHNzFswFpBXd1paTWpsE_FlFfC1A>
    <xmx:f7IsZIdTun2yBpoj4aDuGlfK4M6fS8PiPXxf9FRRB-yB4jOsGrQzcCJtn6E>
Feedback-ID: i3db14652:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 4 Apr 2023 19:27:55 -0400 (EDT)
Message-ID: <d25d8427-1313-5696-8e23-87eadc4e6d6b@fastmail.com>
Date:   Wed, 5 Apr 2023 08:27:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH v5 08/19] scsi: detect support for command duration limits
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Niklas Cassel <nks@flawful.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
References: <20230404182428.715140-1-nks@flawful.org>
 <20230404182428.715140-9-nks@flawful.org>
 <d55ac074-73df-eab3-f0b8-c70d8efb4b72@suse.de>
From:   Damien Le Moal <dlemoal@fastmail.com>
In-Reply-To: <d55ac074-73df-eab3-f0b8-c70d8efb4b72@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/23 03:48, Hannes Reinecke wrote:
> On 4/4/23 20:24, Niklas Cassel wrote:
>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>
>> Introduce the function scsi_cdl_check() to detect if a device supports
>> command duration limits (CDL). Support for the READ 16, WRITE 16,
>> READ 32 and WRITE 32 commands are checked using the function
>> scsi_report_opcode() to probe the rwcdlp and cdlp bits as they indicate
>> the mode page defining the command duration limits descriptors that
>> apply to the command being tested.
>>
>> If any of these commands support CDL, the field cdl_supported of
>> struct scsi_device is set to 1 to indicate that the device supports CDL.
>>
>> Support for CDL for a device is advertizes through sysfs using the new
>> cdl_supported device attribute. This attribute value is 1 for a device
>> supporting CDL and 0 otherwise.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>> ---
>>   Documentation/ABI/testing/sysfs-block-device |  9 +++
>>   drivers/scsi/scsi.c                          | 81 ++++++++++++++++++++
>>   drivers/scsi/scsi_scan.c                     |  3 +
>>   drivers/scsi/scsi_sysfs.c                    |  2 +
>>   include/scsi/scsi_device.h                   |  3 +
>>   5 files changed, 98 insertions(+)
>>
>> diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
>> index 7ac7b19b2f72..ee3610a25845 100644
>> --- a/Documentation/ABI/testing/sysfs-block-device
>> +++ b/Documentation/ABI/testing/sysfs-block-device
>> @@ -95,3 +95,12 @@ Description:
>>   		This file does not exist if the HBA driver does not implement
>>   		support for the SATA NCQ priority feature, regardless of the
>>   		device support for this feature.
>> +
>> +
>> +What:		/sys/block/*/device/cdl_supported
>> +Date:		Mar, 2023
>> +KernelVersion:	v6.4
>> +Contact:	linux-scsi@vger.kernel.org
>> +Description:
>> +		(RO) Indicates if the device supports the command duration
>> +		limits feature found in some ATA and SCSI devices.
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index 62d9472e08e9..c03814ce23ca 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -570,6 +570,87 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
>>   }
>>   EXPORT_SYMBOL(scsi_report_opcode);
>>   
>> +#define SCSI_CDL_CHECK_BUF_LEN	64
>> +
>> +static bool scsi_cdl_check_cmd(struct scsi_device *sdev, u8 opcode, u16 sa,
>> +			       unsigned char *buf)
>> +{
>> +	int ret;
>> +	u8 cdlp;
>> +
>> +	/* Check operation code */
>> +	ret = scsi_report_opcode(sdev, buf, SCSI_CDL_CHECK_BUF_LEN, opcode, sa);
>> +	if (ret <= 0)
>> +		return false;
>> +
>> +	if ((buf[1] & 0x03) != 0x03)
>> +		return false;
>> +
>> +	/* See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES */
>> +	cdlp = (buf[1] & 0x18) >> 3;
>> +	if (buf[0] & 0x01) {
>> +		/* rwcdlp == 1 */
>> +		switch (cdlp) {
>> +		case 0x01:
>> +			/* T2A page */
>> +			return true;
>> +		case 0x02:
>> +			/* T2B page */
>> +			return true;
>> +		}
>> +	} else {
>> +		/* rwcdlp == 0 */
>> +		switch (cdlp) {
>> +		case 0x01:
>> +			/* A page */
>> +			return true;
>> +		case 0x02:
>> +			/* B page */
>> +			return true;
>> +		}
>> +	}
>> +
>> +	return false;
>> +}
>> +
> Why do we need to check this when writing to sysfs? Shouldn't we detect 
> this during startup / revalidate?

Hmm, I think you missed the call chain on this one (the patch starting with the
sys attribute doc changes is a little confusing).

scsi_cdl_check_cmd() is called from scsi_cdl_check(), which is itself called
from scsi_add_lun() (for initial device scan) and scsi_rescan_device() for
revalidate. scsi_cdl_check() will set sdev->cdl_supported to 1 for devices
supporting CDL, which is what sysfs cdl_supported show method uses, and later,
the cdl_enable attribute show/store method use that too. That function is not
called from sysfs attributes methods.

Note that this function was moved from sd.c to scsi.c as CDL is defined is SPC,
not SBC.

> 
>> +/**
>> + * scsi_cdl_check - Check if a SCSI device supports Command Duration Limits
>> + * @sdev: The device to check
>> + */
>> +void scsi_cdl_check(struct scsi_device *sdev)
>> +{
>> +	bool cdl_supported;
>> +	unsigned char *buf;
>> +
>> +	buf = kmalloc(SCSI_CDL_CHECK_BUF_LEN, GFP_KERNEL);
>> +	if (!buf) {
>> +		sdev->cdl_supported = 0;
>> +		return;
>> +	}
>> +
>> +	/* Check support for READ_16, WRITE_16, READ_32 and WRITE_32 commands */
>> +	cdl_supported =
>> +		scsi_cdl_check_cmd(sdev, READ_16, 0, buf) ||
>> +		scsi_cdl_check_cmd(sdev, WRITE_16, 0, buf) ||
>> +		scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, READ_32, buf) ||
>> +		scsi_cdl_check_cmd(sdev, VARIABLE_LENGTH_CMD, WRITE_32, buf);
>> +	if (cdl_supported) {
>> +		/*
>> +		 * We have CDL support: force the use of READ16/WRITE16.
>> +		 * READ32 and WRITE32 will be used for devices that support
>> +		 * the T10_PI_TYPE2_PROTECTION protection type.
>> +		 */
>> +		sdev->use_16_for_rw = 1;
>> +		sdev->use_10_for_rw = 0;
>> +
>> +		sdev->cdl_supported = 1;
>> +	} else {
>> +		sdev->cdl_supported = 0;
>> +	}
>> +
>> +	kfree(buf);
>> +}
>> +
>>   /**
>>    * scsi_device_get  -  get an additional reference to a scsi_device
>>    * @sdev:	device to get a reference to
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index d217be323cc6..aa13feb17c62 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1087,6 +1087,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
>>   	if (sdev->scsi_level >= SCSI_3)
>>   		scsi_attach_vpd(sdev);
>>   
>> +	scsi_cdl_check(sdev);
>> +
>>   	sdev->max_queue_depth = sdev->queue_depth;
>>   	WARN_ON_ONCE(sdev->max_queue_depth > sdev->budget_map.depth);
>>   	sdev->sdev_bflags = *bflags;
>> @@ -1624,6 +1626,7 @@ void scsi_rescan_device(struct device *dev)
>>   	device_lock(dev);
>>   
>>   	scsi_attach_vpd(sdev);
>> +	scsi_cdl_check(sdev);
>>   
>>   	if (sdev->handler && sdev->handler->rescan)
>>   		sdev->handler->rescan(sdev);
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index ee28f73af4d4..4994148e685b 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -670,6 +670,7 @@ sdev_rd_attr (scsi_level, "%d\n");
>>   sdev_rd_attr (vendor, "%.8s\n");
>>   sdev_rd_attr (model, "%.16s\n");
>>   sdev_rd_attr (rev, "%.4s\n");
>> +sdev_rd_attr (cdl_supported, "%d\n");
>>   
>>   static ssize_t
>>   sdev_show_device_busy(struct device *dev, struct device_attribute *attr,
>> @@ -1300,6 +1301,7 @@ static struct attribute *scsi_sdev_attrs[] = {
>>   	&dev_attr_preferred_path.attr,
>>   #endif
>>   	&dev_attr_queue_ramp_up_period.attr,
>> +	&dev_attr_cdl_supported.attr,
>>   	REF_EVT(media_change),
>>   	REF_EVT(inquiry_change_reported),
>>   	REF_EVT(capacity_change_reported),
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index c93c5aaf637e..6b8df9e253a0 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -218,6 +218,8 @@ struct scsi_device {
>>   	unsigned silence_suspend:1;	/* Do not print runtime PM related messages */
>>   	unsigned no_vpd_size:1;		/* No VPD size reported in header */
>>   
>> +	unsigned cdl_supported:1;	/* Command duration limits supported */
>> +
>>   	unsigned int queue_stopped;	/* request queue is quiesced */
>>   	bool offline_already;		/* Device offline message logged */
>>   
>> @@ -364,6 +366,7 @@ extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
>>   extern void scsi_remove_device(struct scsi_device *);
>>   extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
>>   void scsi_attach_vpd(struct scsi_device *sdev);
>> +void scsi_cdl_check(struct scsi_device *sdev);
>>   
>>   extern struct scsi_device *scsi_device_from_queue(struct request_queue *q);
>>   extern int __must_check scsi_device_get(struct scsi_device *);
> 
> Cheers,
> 
> Hannes
> 

