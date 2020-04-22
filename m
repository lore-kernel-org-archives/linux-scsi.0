Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B58F3C5518B
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:54:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 928E620747
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:54:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uA+B5OdC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgDVGyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbgDVGyP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:54:15 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C985C03C1A6;
        Tue, 21 Apr 2020 23:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PPZ4h2g1T5oHvKPAYnNLCJiwA+6mBi/YDgQyauKaszE=; b=uA+B5OdCZI47BRrAhfT/13mIKQ
        tcepQX5mWIn1Y1cEAeGW+MeiXS3dc/+mQmnvDGpF3/MtB7lTDahF03J4+v1e9QCo5UVk+EVRbTw3S
        xsQkC2wUOAwqKEQn+LF3rYpjdi8CqpQ22CdGp28zJGe3BfiCAisIDCL9+eVulZmyXhH7ffc+xRREo
        wBdn5UWxKVS3lxdoTU+ggRZWXetaZZVUUBDGgOVan9WZ9hAR3GAk6Q+3PI275OtXqRSZJgbfUy2Q4
        RhwdqKFLaI7rXULSE49yznfQH6iMjawCrlWwO3LHXhh+V9ln/XQyWZ6FLmViomNojEt+YuDPJUfDq
        cLPnmVfw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR9Gw-0004PS-1b; Wed, 22 Apr 2020 06:54:14 +0000
Date:   Tue, 21 Apr 2020 23:54:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 04/10] scsi: ufs: introduce
 UFSHCD_QUIRK_PRDT_BYTE_GRAN quirk
Message-ID: <20200422065414.GK20318@infradead.org>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
 <CGME20200417181014epcas5p1343bc81fb246133cc332d3fc7a394c15@epcas5p1.samsung.com>
 <20200417175944.47189-5-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417175944.47189-5-alim.akhtar@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 17, 2020 at 11:29:38PM +0530, Alim Akhtar wrote:
> Some UFS host controllers may think granularities of PRDT length and
> offset as bytes, not double words.
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 30 +++++++++++++++++++++++-------
>  drivers/scsi/ufs/ufshcd.h |  6 ++++++
>  2 files changed, 29 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ee30ed6cc805..b32fcedcdcb9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2151,8 +2151,14 @@ static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>  		return sg_segments;
>  
>  	if (sg_segments) {
> -		lrbp->utr_descriptor_ptr->prd_table_length =
> -			cpu_to_le16((u16)sg_segments);
> +
> +		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
> +			lrbp->utr_descriptor_ptr->prd_table_length =
> +				cpu_to_le16((u16)(sg_segments *
> +					sizeof(struct ufshcd_sg_entry)));
> +		else
> +			lrbp->utr_descriptor_ptr->prd_table_length =
> +				cpu_to_le16((u16) (sg_segments));

No double words here.  "Normal" UFS uses the actual segment count,
while Samsumg uses bytes.  Also no need fo the u16 count in
either the old or new version.
