From: Matthew Wilcox <willy@debian.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 12:49:44 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119124944.GS30485@parcelfarce.linux.theplanet.co.uk>
References: <20031027153932.A16679@infradead.org> <03111117263601.01918@naveenb-lnx.cisco.com> <20031111173622.A12435@infradead.org> <200311191810.30135.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:3527 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264034AbTKSMtp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 07:49:45 -0500
Content-Disposition: inline
In-Reply-To: <200311191810.30135.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wed, Nov 19, 2003 at 06:10:30PM +0530, Krishna Murthy wrote:
> Hi ,
> 	The following was one of your comments on the iSCSI driver:
> 
> "having multiple  kmap() in the same process at the same time can kmap(),
> you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_data not to do that.
> for the tx path use ->sendpage to avoid a data copy and kmapping altogether"
> 
> 
> In the first line did you intend to say having multiple kmap() can deadlock?

Yes, he did.

> Regarding usage of sendpage and avoiding kmapping altogether, 
> we need to access the data, to calculate data digest.  If we do  not use kmap
> how else do we achieve it?

Use the digest API.  See include/linux/crypto.h.  For example,
crypto_digest_update() takes a scatterlist.  Scatterlists include
a page/offset, so your code doesn't need to kmap() at all.

-- 
"It's not Hollywood.  War is real, war is primarily not about defeat or
victory, it is about death.  I've seen thousands and thousands of dead bodies.
Do you think I want to have an academic debate on this subject?" -- Robert Fisk
