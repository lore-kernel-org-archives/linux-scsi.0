From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: aacraid: Add a small delay after IOP reset
Date: Tue, 19 Sep 2017 08:37:12 -0700
Message-ID: <20170919153712.GA15496@infradead.org>
References: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:43523 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751425AbdISPhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 11:37:14 -0400
Content-Disposition: inline
In-Reply-To: <20170919151156.29412-1-gpiccoli@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: aacraid@microsemi.com, linux-scsi@vger.kernel.org, RaghavaAditya.Renukunta@microsemi.com, david.carroll@microsemi.com, brking@linux.vnet.ibm.com, dougmill@linux.vnet.ibm.com, stable@vger.kernel.org

On Tue, Sep 19, 2017 at 12:11:55PM -0300, Guilherme G. Piccoli wrote:
>  	src_writel(dev, MUnit.IDR, IOP_SRC_RESET_MASK);
> +
> +	msleep(5000);

src_writel is a writel, and thus a posted MMIO write.  You'll need
to have to a read first to make it a reliable timing base.
