Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55495C7619A
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Apr 2023 06:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbjDEG0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Apr 2023 02:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbjDEG0G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Apr 2023 02:26:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D267730D4;
        Tue,  4 Apr 2023 23:26:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 514691FDCF;
        Wed,  5 Apr 2023 06:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680675962; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fPklOGrK0wvx9foU45fbSO1T7AAWrRW0ezTW2IuveIs=;
        b=W1BxH9INLTbRXuhqHrkuflqGKzVtAQKZPVfONL9HDieGVaM8S2yyIY/uYwDRh/dfj3cvxT
        bQxtl1Saj3DwErlTC+PM5Le7yyqvuS3c1Wzf8MY1/Dm9H57L6OXR1S6EBL1Z63f0Yerkg/
        q0T/BIzLomrr8RrLEvm4w/f6WuP17i0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680675962;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fPklOGrK0wvx9foU45fbSO1T7AAWrRW0ezTW2IuveIs=;
        b=/uwtE0c0WiNQgRjZo0OuSEpwoVWPzoUvm+zeb2gkLi0Ueun+GkD2WH+PW2OoIrJPJoQGun
        EdX2SnYJ6N3d7MAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6855113A10;
        Wed,  5 Apr 2023 06:26:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id CH8TFnkULWRMfwAAMHmgww
        (envelope-from <hare@suse.de>); Wed, 05 Apr 2023 06:26:01 +0000
Message-ID: <c94c94f7-1a22-72b0-bcf6-a6de6c61a3ec@suse.de>
Date:   Wed, 5 Apr 2023 08:26:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 08/19] scsi: detect support for command duration limits
Content-Language: en-US
To:     Damien Le Moal <dlemoal@fastmail.com>,
        Niklas Cassel <nks@flawful.org>, Jens Axboe <axboe@kernel.dk>,
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
 <d25d8427-1313-5696-8e23-87eadc4e6d6b@fastmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <d25d8427-1313-5696-8e23-87eadc4e6d6b@fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/23 01:27, Damien Le Moal wrote:
> On 4/5/23 03:48, Hannes Reinecke wrote:
>> On 4/4/23 20:24, Niklas Cassel wrote:
>>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>>
>>> Introduce the function scsi_cdl_check() to detect if a device supports
>>> command duration limits (CDL). Support for the READ 16, WRITE 16,
>>> READ 32 and WRITE 32 commands are checked using the function
>>> scsi_report_opcode() to probe the rwcdlp and cdlp bits as they indicate
>>> the mode page defining the command duration limits descriptors that
>>> apply to the command being tested.
>>>
>>> If any of these commands support CDL, the field cdl_supported of
>>> struct scsi_device is set to 1 to indicate that the device supports CDL.
>>>
>>> Support for CDL for a device is advertizes through sysfs using the new
>>> cdl_supported device attribute. This attribute value is 1 for a device
>>> supporting CDL and 0 otherwise.
>>>
>>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>> Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
>>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
>>> ---
>>>    Documentation/ABI/testing/sysfs-block-device |  9 +++
>>>    drivers/scsi/scsi.c                          | 81 ++++++++++++++++++++
>>>    drivers/scsi/scsi_scan.c                     |  3 +
>>>    drivers/scsi/scsi_sysfs.c                    |  2 +
>>>    include/scsi/scsi_device.h                   |  3 +
>>>    5 files changed, 98 insertions(+)
>>>
>>> diff --git a/Documentation/ABI/testing/sysfs-block-device b/Documentation/ABI/testing/sysfs-block-device
>>> index 7ac7b19b2f72..ee3610a25845 100644
>>> --- a/Documentation/ABI/testing/sysfs-block-device
>>> +++ b/Documentation/ABI/testing/sysfs-block-device
>>> @@ -95,3 +95,12 @@ Description:
>>>    		This file does not exist if the HBA driver does not implement
>>>    		support for the SATA NCQ priority feature, regardless of the
>>>    		device support for this feature.
>>> +
>>> +
>>> +What:		/sys/block/*/device/cdl_supported
>>> +Date:		Mar, 2023
>>> +KernelVersion:	v6.4
>>> +Contact:	linux-scsi@vger.kernel.org
>>> +Description:
>>> +		(RO) Indicates if the device supports the command duration
>>> +		limits feature found in some ATA and SCSI devices.
>>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>>> index 62d9472e08e9..c03814ce23ca 100644
>>> --- a/drivers/scsi/scsi.c
>>> +++ b/drivers/scsi/scsi.c
>>> @@ -570,6 +570,87 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
>>>    }
>>>    EXPORT_SYMBOL(scsi_report_opcode);
>>>    
>>> +#define SCSI_CDL_CHECK_BUF_LEN	64
>>> +
>>> +static bool scsi_cdl_check_cmd(struct scsi_device *sdev, u8 opcode, u16 sa,
>>> +			       unsigned char *buf)
>>> +{
>>> +	int ret;
>>> +	u8 cdlp;
>>> +
>>> +	/* Check operation code */
>>> +	ret = scsi_report_opcode(sdev, buf, SCSI_CDL_CHECK_BUF_LEN, opcode, sa);
>>> +	if (ret <= 0)
>>> +		return false;
>>> +
>>> +	if ((buf[1] & 0x03) != 0x03)
>>> +		return false;
>>> +
>>> +	/* See SPC-6, one command format of REPORT SUPPORTED OPERATION CODES */
>>> +	cdlp = (buf[1] & 0x18) >> 3;
>>> +	if (buf[0] & 0x01) {
>>> +		/* rwcdlp == 1 */
>>> +		switch (cdlp) {
>>> +		case 0x01:
>>> +			/* T2A page */
>>> +			return true;
>>> +		case 0x02:
>>> +			/* T2B page */
>>> +			return true;
>>> +		}
>>> +	} else {
>>> +		/* rwcdlp == 0 */
>>> +		switch (cdlp) {
>>> +		case 0x01:
>>> +			/* A page */
>>> +			return true;
>>> +		case 0x02:
>>> +			/* B page */
>>> +			return true;
>>> +		}
>>> +	}
>>> +
>>> +	return false;
>>> +}
>>> +
>> Why do we need to check this when writing to sysfs? Shouldn't we detect
>> this during startup / revalidate?
> 
> Hmm, I think you missed the call chain on this one (the patch starting with the
> sys attribute doc changes is a little confusing).
> 
> scsi_cdl_check_cmd() is called from scsi_cdl_check(), which is itself called
> from scsi_add_lun() (for initial device scan) and scsi_rescan_device() for
> revalidate. scsi_cdl_check() will set sdev->cdl_supported to 1 for devices
> supporting CDL, which is what sysfs cdl_supported show method uses, and later,
> the cdl_enable attribute show/store method use that too. That function is not
> called from sysfs attributes methods.
> 
> Note that this function was moved from sd.c to scsi.c as CDL is defined is SPC,
> not SBC.
> 
Indeed, you are right.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Ivo Totev, Andrew
Myers, Andrew McDonald, Martje Boudien Moerman

