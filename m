Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF57C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 06:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbjAQGNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 01:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234606AbjAQGNH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 01:13:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D8186A5;
        Mon, 16 Jan 2023 22:13:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=+RjhkaVGbYrBWT358b32HpTaJK3Df3ISnmFndlzSZWI=; b=lUNrzc/nIOR2JpN2NgV8e3fZd+
        bW2j5XQ1QSidm8LTBuuepnfmEJK0U0Doo/DZDy06XO9rD9y7iYSoXWXzKUQABbbEp3/56EaPgQAC6
        XFm15FMDk5YtunKc7CCWZliPecGNw/4O+XFE7kXBZbd7qVenexD9KslIekNYz6x/spon2/zW2hqmc
        oAJEGgONkgBljROjb5XqJjIBXnjF3ZiEo18YGE2J0HgqKgzCouJg/ldjceQLtr2MMiv0izmWzwPio
        H+dN0W8iBB9oH7EHzt5GYYbz5dOj5z7pbNrokF6zHm2gP4M95CtFgzi9h6kKapfS0Gh0j+wCJU4i2
        FchLBUlg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pHfDT-00D2fp-ML; Tue, 17 Jan 2023 06:13:03 +0000
Date:   Mon, 16 Jan 2023 22:13:03 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2 05/18] scsi: support retrieving sub-pages of mode pages
Message-ID: <Y8Y8b9F/lP7G4yui@infradead.org>
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-6-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112140412.667308-6-niklas.cassel@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>  extern int scsi_mode_sense(struct scsi_device *sdev, int dbd, int modepage,
> -			   unsigned char *buffer, int len, int timeout,
> -			   int retries, struct scsi_mode_data *data,
> +			   int subpage, unsigned char *buffer, int len,
> +			   int timeout, int retries,
> +			   struct scsi_mode_data *data,

Please drop the extern while you're at it.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
