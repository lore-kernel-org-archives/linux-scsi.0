Return-Path: <SRS0=uVXb=YR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F149CA9EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 02:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1552020684
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Oct 2019 02:24:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HbQ4E4Ny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408220AbfJXCYG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 22:24:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406400AbfJXCYG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Oct 2019 22:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=jqaSnMivMbTcu9ltBfVGub27KNjYSIvA9j9EeZ25Gtg=; b=HbQ4E4NyaoU4b4xncTnHvaoM7
        dD9y4Rv90jjsduTfR5TIPaHkB1q1bvoTtoI+JOhZX2sRvtxUlf6wo/r+yhOU2mcIpfG6YAbBRIgsw
        4SxXGr42k+1CZV0K8jNKrOEuOH4gfoSKrhXB+uQSTZwCOoON9nY8483Mj0w98gsJl9neXq2S/Xqpf
        2tg8f5H65x/ExvuTcZmniU+dD6t6rtUoH6W/PyXFt854zeDeei8tP3PHjQrkiW6AJORaSusgwHosq
        a2mPgpjRABGj5PriHE3PonP73iPD1cssVaSZZEIOJ4nAYd5T2cIDRuYJyx3FY80qNFnqw61Mr5ETl
        jZnmC9/OQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNSnG-0004h2-AQ; Thu, 24 Oct 2019 02:24:06 +0000
Date:   Wed, 23 Oct 2019 19:24:06 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] scsi: sr: wait for the medium to become ready
Message-ID: <20191024022406.GD11485@infradead.org>
References: <cover.1571834862.git.msuchanek@suse.de>
 <94dc98dc67b1d183d04c338c7978efa0556db6ac.1571834862.git.msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94dc98dc67b1d183d04c338c7978efa0556db6ac.1571834862.git.msuchanek@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 23, 2019 at 02:52:47PM +0200, Michal Suchanek wrote:
> +static int sr_block_open_finish(struct block_device *bdev, fmode_t mode,
> +				int ret)
> +{
> +	struct scsi_cd *cd = scsi_cd(bdev->bd_disk);
> +
> +	/* wait for drive to get ready */
> +	if ((ret == -ENOMEDIUM) && !(mode & FMODE_NDELAY)) {
> +		struct scsi_device *sdev = cd->device;
> +		/*
> +		 * Cannot use sr_block_ioctl because it locks sr_mutex blocking
> +		 * out any processes trying to access the drive
> +		 */
> +		scsi_autopm_get_device(sdev);
> +		cdrom_ioctl(&cd->cdi, bdev, mode, CDROM_AUTOCLOSE, 0);
> +		ret = __sr_block_open(bdev, mode);
> +		scsi_autopm_put_device(sdev);

Ioctls should never be used from kernel space.  We have a few leftovers,
but we need to get rid of that and not add more.
