Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0263EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 05:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243870AbiF1FEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 01:04:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiF1FEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 01:04:49 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A901712ACA;
        Mon, 27 Jun 2022 22:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iOOZVy162qgT0FLXRI5V47PK1xRasOf+N94y5B+NJxA=; b=n1u2ocqT0uzJwWQwDNeaIbJ581
        AD5TrBFtZkNdVXSSotnLWJVQbm8wzjKjyfXdSmbh0OFwuoKoYQ24pASZKnNXsvSt36i1cNUJ/yzOF
        V8UEPnwWIHSltxDw+CuW8BLZjZ3R56l/RsMBEvMTI4QJzCBCQd7pyxD8ka/vhX4EBxXFHzkR/Irop
        Mh1r0vM2whCIvde/OhMMsOeJNEtNgqcdk+3q8xlc4fnzgkYqiFTlw/64+13Vzkg9jhiRE0ALX36i3
        wO1rlX9HszH2XzOrlgju92u6ezxPYIJoalkQRmz2MxD3UFtsGOo+nNdyZrK9l0BRT3Iiq8D1DwEXg
        LvrCmIZg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o63P5-004JJn-La; Tue, 28 Jun 2022 05:04:47 +0000
Date:   Mon, 27 Jun 2022 22:04:47 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 4/5] scsi: target: Add file configure_unmap callout
Message-ID: <YrqL77/5rcB/Xzi6@infradead.org>
References: <20220628022953.20948-1-michael.christie@oracle.com>
 <20220628022953.20948-5-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628022953.20948-5-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 27, 2022 at 09:29:52PM -0500, Mike Christie wrote:
> +static bool fd_configure_unmap(struct se_device *dev)
> +{
> +	struct file *file = FD_DEV(dev)->fd_file;
> +	struct inode *inode = file->f_mapping->host;
> +
> +	if (S_ISBLK(inode->i_mode)) {
> +		return target_configure_unmap_from_queue(&dev->dev_attrib,
> +							 I_BDEV(inode));
> +	} else {

No need for the else here.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
