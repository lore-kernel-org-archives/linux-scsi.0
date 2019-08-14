Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55F64C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 07:17:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F6C32054F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 07:17:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=bfs.de header.i=@bfs.de header.b="dXqiGs94"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfHNHRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 03:17:23 -0400
Received: from mx01-fr.bfs.de ([193.174.231.67]:55417 "EHLO mx01-fr.bfs.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727411AbfHNHRW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 03:17:22 -0400
Received: from mail-fr.bfs.de (mail-fr.bfs.de [10.177.18.200])
        by mx01-fr.bfs.de (Postfix) with ESMTPS id 32B4520312;
        Wed, 14 Aug 2019 09:17:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bfs.de; s=dkim201901;
        t=1565767036; h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d9f3IQNuntXUeBa86V9VEU7wfXhvezEJu6Lae7htCko=;
        b=dXqiGs9486bwMh1fs9txCTkgc44sKj2bU9b6y/sKB5+jJjve1jX5HXdpwq8PlF4MnsrJnn
        p5wvNgz8a1guRtA2pKjbG5p1FLZof/N/YwxGd0fXoyRZtjtg+j9BZGhFl9z7BohLxPe3qe
        Q0WNMeolwm2Y0qYxMHiKONMOdxXf5b7KychsLtTGKTwv5Ic+XSVqUMb9/Zga8KlQSv4CRL
        84/Qbi8cdHW2b9vgSl/3uDPgwcQgLJQl5ZMqA/jch4vkzoMAVM/ukpPGF4VbugTRBtvnVy
        oHFrObczs1suGAOY+X+PP6HAusS+o9jmfernWXFySNbzZnzOQnZ0qQ68OjOBlw==
Received: from [134.92.181.33] (unknown [134.92.181.33])
        by mail-fr.bfs.de (Postfix) with ESMTPS id D3442BEEBD;
        Wed, 14 Aug 2019 09:17:15 +0200 (CEST)
Message-ID: <5D53B57B.3000905@bfs.de>
Date:   Wed, 14 Aug 2019 09:17:15 +0200
From:   walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To:     Colin King <colin.king@canonical.com>
CC:     Jianyun Li <jyli@marvell.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: mvumi: fix 32 bit shift of a u32 value
References: <20190813180113.14245-1-colin.king@canonical.com>
In-Reply-To: <20190813180113.14245-1-colin.king@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Authentication-Results: mx01-fr.bfs.de
X-Spamd-Result: default: False [-3.10 / 7.00];
         ARC_NA(0.00)[];
         HAS_REPLYTO(0.00)[wharms@bfs.de];
         BAYES_HAM(-3.00)[100.00%];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         REPLYTO_ADDR_EQ_FROM(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         NEURAL_HAM(-0.00)[-0.999,0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         RCVD_TLS_ALL(0.00)[]
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Am 13.08.2019 20:01, schrieb Colin King:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the top 32 bits of a 64 bit address is being calculated
> by shifting a u32 twice by 16 bits and then being cast into a 64
> bit address.  Shifting a u32 twice by 16 bits always ends up with
> a zero.  Fix this by casting the u32 to a 64 bit address first
> and then shifting it 32 bits.
> 
> Addresses-Coverity: ("Operands don't affect result")
> Fixes: f0c568a478f0 ("[SCSI] mvumi: Add Marvell UMI driver")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/mvumi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
> index 8906aceda4c4..62df69f1e71e 100644
> --- a/drivers/scsi/mvumi.c
> +++ b/drivers/scsi/mvumi.c
> @@ -296,7 +296,7 @@ static void mvumi_delete_internal_cmd(struct mvumi_hba *mhba,
>  			sgd_getsz(mhba, m_sg, size);
>  
>  			phy_addr = (dma_addr_t) m_sg->baseaddr_l |
> -				(dma_addr_t) ((m_sg->baseaddr_h << 16) << 16);
> +				   (dma_addr_t) m_sg->baseaddr_h << 32;
>  

All the casts make it hard to read, i would propose an alternativ version:
phy_addr = m_sg->baseaddr_h;
phy_addr <<= 32;
phy_addr |= m_sg->baseaddr_l;

JM2C and totaly untested.

re,
 wh

>  			dma_free_coherent(&mhba->pdev->dev, size, cmd->data_buf,
>  								phy_addr);
