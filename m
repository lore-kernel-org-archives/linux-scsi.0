Return-Path: <SRS0=0MZD=6J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 244F4C55191
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 11:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D2E206A2
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Apr 2020 11:11:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="O5u+4P5u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgDYLLC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Apr 2020 07:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726059AbgDYLLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Apr 2020 07:11:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD12C09B04B;
        Sat, 25 Apr 2020 04:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XhkPbtyaqmMBG6aICROLPcfy5U+xk0OZN/pBlUuLuHY=; b=O5u+4P5udjw0lHyGwAIHIyJA8q
        ytjTlNMbMxF4ZNJwIqFOEoSBxnGwcYFU6GjUmAAKDJ+si7gTkCax+kFnS/rp0flqBfaSkGJxXDGzN
        UKAbF9lVnztuR3ea3DbP3qH+3Dj49pOJZgHSACe+4HJrA0+LnFE9bTtMAnogLiV1+IY0b2/J4MLtt
        mpQB59fVaoUCLRdZ0BxOo2Bc75V/ApvwggSB79/NE/xE5CICVh1ZFhYhfuHsoegxQVdqszx9b9Fpf
        Ijr3RBDx/DQrCBgpGOclmEmrTKgtgPqIcd90LHorb9f5dfzudxyFa/b5/3/6u9gE6xhSmkeNFLhIO
        Ng05eJtg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jSIi0-0003jb-Ig; Sat, 25 Apr 2020 11:10:56 +0000
Date:   Sat, 25 Apr 2020 04:10:56 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Message-ID: <20200425111056.GA3384@infradead.org>
References: <cover.1587727756.git.Jose.Abreu@synopsys.com>
 <5c4281080538b74ca39cedb9112ffe71bf7a80b5.1587727756.git.Jose.Abreu@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5c4281080538b74ca39cedb9112ffe71bf7a80b5.1587727756.git.Jose.Abreu@synopsys.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 24, 2020 at 01:36:56PM +0200, Jose Abreu wrote:
> Add a define for UFS version 3.0 and do not print an error message upon
> probe when using this version.

This doesn't really scale.  Version checks only make sense for a minimum
supported version.  Rejecting newer versions is just a bad idea.

> @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>  	if ((hba->ufs_version != UFSHCI_VERSION_10) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_11) &&
>  	    (hba->ufs_version != UFSHCI_VERSION_20) &&
> -	    (hba->ufs_version != UFSHCI_VERSION_21))
> +	    (hba->ufs_version != UFSHCI_VERSION_21) &&
> +	    (hba->ufs_version != UFSHCI_VERSION_30))

i.e. this should become

	if (hba->ufs_version < UFSHCI_VERSION_10)

as an additional cleanup I think it makes more sense t use a UFSHCI_VER()
macro similar to KERNEL_VERSION() or NVME_VS() instead of adding a new
define for every version.
