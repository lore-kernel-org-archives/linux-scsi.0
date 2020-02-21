Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF200C3565B
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 18:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2D0F222C4
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 18:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="No/AA7vX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgBUSTJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 13:19:09 -0500
Received: from mail27.static.mailgun.info ([104.130.122.27]:64180 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729410AbgBUSTH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 13:19:07 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582309147; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=1LAjcim7ITTYZkiICdA+c+8u6gqIyGvjMVWgH5zcZCE=; b=No/AA7vXPxRfm3o3O7mR3pauBOcKbQC30NS53rAJuDuJtVP0Of62T38JRFwD1aDeKZx3vn4p
 VQUrmj/9aObZSle6FMWRJwNAKp0W7dCPq06QAFi49O4mh1LJ9Ev2CvQH5e4DYitXJPtunRbS
 0ISVvmapz4uhN2G2iKDXWwwbAVs=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e501f10.7f4ac4e2aa78-smtp-out-n01;
 Fri, 21 Feb 2020 18:18:56 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 31CEEC4479F; Fri, 21 Feb 2020 18:18:56 +0000 (UTC)
Received: from [10.71.154.194] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3A7B1C433A2;
        Fri, 21 Feb 2020 18:18:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3A7B1C433A2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH 2/2] ufshcd: use an enum for quirks
To:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20200221140812.476338-1-hch@lst.de>
 <20200221140812.476338-3-hch@lst.de>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <7f2394fb-d1fc-830b-eab7-30650c92e87f@codeaurora.org>
Date:   Fri, 21 Feb 2020 10:18:55 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200221140812.476338-3-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph

On 2/21/2020 6:08 AM, Christoph Hellwig wrote:
> Use an enum to specify the various quirks instead of #defines inside
> the structure definition.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/ufs/ufshcd.h | 82 ++++++++++++++++++++-------------------
>   1 file changed, 42 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 9c2b80f87b9f..f68b3cd2e465 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -469,6 +469,48 @@ struct ufs_stats {
>   	struct ufs_err_reg_hist task_abort;
>   };
>   
> +enum ufshcd_quirks {
> +	/* Interrupt aggregation support is broken */
> +	UFSHCD_QUIRK_BROKEN_INTR_AGGR			= 1 << 0,
> +

How about using BIT() here?
> +	/*
> +	 * delay before each dme command is required as the unipro
> +	 * layer has shown instabilities
> +	 */
> +	UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		= 1 << 1,
> +
> +	/*
> +	 * If UFS host controller is having issue in processing LCC (Line
> +	 * Control Command) coming from device then enable this quirk.
> +	 * When this quirk is enabled, host controller driver should disable
> +	 * the LCC transmission on UFS device (by clearing TX_LCC_ENABLE
> +	 * attribute of device to 0).
> +	 */
> +	UFSHCD_QUIRK_BROKEN_LCC				= 1 << 2,
> +
> +	/*
> +	 * The attribute PA_RXHSUNTERMCAP specifies whether or not the
> +	 * inbound Link supports unterminated line in HS mode. Setting this
> +	 * attribute to 1 fixes moving to HS gear.
> +	 */
> +	UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		= 1 << 3,
> +
> +	/*
> +	 * This quirk needs to be enabled if the host contoller only allows
> +	 * accessing the peer dme attributes in AUTO mode (FAST AUTO or
> +	 * SLOW AUTO).
> +	 */
> +	UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		= 1 << 4,
> +
> +	/*
> +	 * This quirk needs to be enabled if the host contoller doesn't
> +	 * advertise the correct version in UFS_VER register. If this quirk
> +	 * is enabled, standard UFS host driver will call the vendor specific
> +	 * ops (get_ufs_hci_version) to get the correct version.
> +	 */
> +	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
> +};
> +
>   /**
>    * struct ufs_hba - per adapter private structure
>    * @mmio_base: UFSHCI base register address
> @@ -572,46 +614,6 @@ struct ufs_hba {
>   	bool is_irq_enabled;
>   	enum ufs_ref_clk_freq dev_ref_clk_freq;
>   
> -	/* Interrupt aggregation support is broken */
> -	#define UFSHCD_QUIRK_BROKEN_INTR_AGGR			0x1
> -
> -	/*
> -	 * delay before each dme command is required as the unipro
> -	 * layer has shown instabilities
> -	 */
> -	#define UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS		0x2
> -
> -	/*
> -	 * If UFS host controller is having issue in processing LCC (Line
> -	 * Control Command) coming from device then enable this quirk.
> -	 * When this quirk is enabled, host controller driver should disable
> -	 * the LCC transmission on UFS device (by clearing TX_LCC_ENABLE
> -	 * attribute of device to 0).
> -	 */
> -	#define UFSHCD_QUIRK_BROKEN_LCC				0x4
> -
> -	/*
> -	 * The attribute PA_RXHSUNTERMCAP specifies whether or not the
> -	 * inbound Link supports unterminated line in HS mode. Setting this
> -	 * attribute to 1 fixes moving to HS gear.
> -	 */
> -	#define UFSHCD_QUIRK_BROKEN_PA_RXHSUNTERMCAP		0x8
> -
> -	/*
> -	 * This quirk needs to be enabled if the host contoller only allows
> -	 * accessing the peer dme attributes in AUTO mode (FAST AUTO or
> -	 * SLOW AUTO).
> -	 */
> -	#define UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		0x10
> -
> -	/*
> -	 * This quirk needs to be enabled if the host contoller doesn't
> -	 * advertise the correct version in UFS_VER register. If this quirk
> -	 * is enabled, standard UFS host driver will call the vendor specific
> -	 * ops (get_ufs_hci_version) to get the correct version.
> -	 */
> -	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		0x20
> -
>   	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
>   
>   	/* Device deviations from standard UFS device spec. */
> 

-asd

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
