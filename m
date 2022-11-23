Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81623C43217
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 17:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbiKWRK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239120AbiKWRKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 12:10:48 -0500
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.165])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E1EA1A7;
        Wed, 23 Nov 2022 09:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1669223444;
    s=strato-dkim-0002; d=iokpp.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=rAeJ0mNLA1M808k59HqXpV7NVyn7t1Z67neJ6CI5ivk=;
    b=V34Tz24QgTa8KNLKKk6j+/J4Hq+xd1nNPA+FYjGagkP06636BDL9sQTCdpxN3upkt+
    QuOtEeYKNbctjKrVOlWg9dxbulYLGIQQ5+kIq/FNAUOi7QyxTHyUHXfSePdROlChEnNK
    6WjTgmS/HEqYh/GOgA/Zl5QMq022m+hvPNXfRwteNav0eckNTQPJJd8f55woBF3Nsh2r
    9mwQIJb+VdMK+YRo5Fsc66GIT25mKkbCdaNDS2Qza0TPBPy4caOZGaGDCzmSRh4kYsGF
    g8SjniJ2K3tF2B61fDTQfCT5j4JQCigmTA7iQijWTevTy4jkHaE2vaO3BtkKduX5SCul
    //8w==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":LmkFe0i9dN8c2t4QQyGBB/NDXvjDB6pBSeBwhhSxarlUcu05JCAPyj3VPAceccYJs0uz"
X-RZG-CLASS-ID: mo00
Received: from blinux
    by smtp.strato.de (RZmta 48.2.1 AUTH)
    with ESMTPSA id z9cfbfyANHAhnIP
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 23 Nov 2022 18:10:43 +0100 (CET)
Message-ID: <9b83887215e8f80626b9424c50d60306a1cc24aa.camel@iokpp.de>
Subject: Re: [PATCH v3 2/4] ufs: core: Remove redundant desc_size variable
 from hba
From:   Bean Huo <beanhuo@iokpp.de>
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        martin.petersen@oracle.com
Cc:     beanhuo@micron.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 23 Nov 2022 18:10:42 +0100
In-Reply-To: <1669045590-26101-3-git-send-email-Arthur.Simchaev@wdc.com>
References: <1669045590-26101-1-git-send-email-Arthur.Simchaev@wdc.com>
         <1669045590-26101-3-git-send-email-Arthur.Simchaev@wdc.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2022-11-21 at 17:46 +0200, Arthur Simchaev wrote:
> @ -7945,18 +7926,16 @@ static void ufshcd_clear_dbg_ufs_stats(struct
> ufs_hba *hba)
> 
>  static int ufshcd_device_geo_params_init(struct ufs_hba *hba)
> 
>  {
> 
>         int err;
> 
> -       size_t buff_len;
> 
>         u8 *desc_buf;
> 
>  
> 
> -       buff_len = hba->desc_size[QUERY_DESC_IDN_GEOMETRY];
> 
> -       desc_buf = kmalloc(buff_len, GFP_KERNEL);
> 
> +       desc_buf = kmalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
here also should be kzalloc?

Reviewed-by: Bean Huo <beanhuo@micron.com>

