Return-Path: <SRS0=Tsb4=6F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8080C54FC9
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 05:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8949E214AF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Apr 2020 05:52:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="JmrQ1nc/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgDUFwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Apr 2020 01:52:32 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:28100 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgDUFwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Apr 2020 01:52:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1587448351; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=1Jww1SPgDxhs8SrKwoOjrf0hHGMsbbkuAez4BNaNiOk=;
 b=JmrQ1nc//mJys38lSbOVlNozleIUxObLKg1yOQaat7DntfrKn5n/h1DDSXOqcyT9zt6LyVCY
 cZcX/TL8Q/G6OWtGMLf+NaxI6SdCwWf6hGwZ2VL0Ruy5ZJLOOXDe59pSoB9mbSgNb0dtWRkL
 WRDC/JnE9wzcRdZWM6b8rjVjBPA=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e9e8a17.7f7ecd7a95e0-smtp-out-n01;
 Tue, 21 Apr 2020 05:52:23 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8943AC432C2; Tue, 21 Apr 2020 05:52:22 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A85C2C433CB;
        Tue, 21 Apr 2020 05:52:21 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 21 Apr 2020 13:52:21 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
In-Reply-To: <20200417175944.47189-2-alim.akhtar@samsung.com>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
 <CGME20200417181008epcas5p460840c01c2c09ce1a69e83005b4bddbe@epcas5p4.samsung.com>
 <20200417175944.47189-2-alim.akhtar@samsung.com>
Message-ID: <a5410ec9a1f72c01f738bbcb911cc7b8@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-18 01:59, Alim Akhtar wrote:
> In the right behavior, setting the bit to '0' indicates clear and '1'
> indicates no change. If host controller handles this the other way,
> UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.
> 
> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
>  drivers/scsi/ufs/ufshcd.h |  5 +++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 698e8d20b4ba..3655b88fc862 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -645,7 +645,11 @@ static inline int ufshcd_get_tr_ocs(struct
> ufshcd_lrb *lrbp)
>   */
>  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>  {
> -	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> +		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> +	else
> +		ufshcd_writel(hba, ~(1 << pos),
> +				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
>  }
> 
>  /**
> @@ -655,7 +659,10 @@ static inline void ufshcd_utrl_clear(struct
> ufs_hba *hba, u32 pos)
>   */
>  static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
>  {
> -	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
> +	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> +		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
> +	else
> +		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
>  }
> 
>  /**
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 6ffc08ad85f6..071f0edf3f64 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -518,6 +518,11 @@ enum ufshcd_quirks {
>  	 * ops (get_ufs_hci_version) to get the correct version.
>  	 */
>  	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
> +
> +	/*
> +	 * Clear handling for transfer/task request list is just opposite.
> +	 */
> +	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
>  };
> 
>  enum ufshcd_caps {
> 
> base-commit: 8f3d9f354286745c751374f5f1fcafee6b3f3136
