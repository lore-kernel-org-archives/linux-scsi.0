From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 13:38:05 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119133805.A12398@infradead.org>
References: <20031027153932.A16679@infradead.org> <03111117263601.01918@naveenb-lnx.cisco.com> <20031111173622.A12435@infradead.org> <200311191810.30135.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:46087 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S264076AbTKSNiH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 08:38:07 -0500
Content-Disposition: inline
In-Reply-To: <200311191810.30135.krmurthy@cisco.com>; from krmurthy@cisco.com on Wed, Nov 19, 2003 at 06:10:30PM +0530
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

Yes.

> Regarding usage of sendpage and avoiding kmapping altogether, 
> we need to access the data, to calculate data digest.  If we do  not use kmap
> how else do we achieve it?

Well, with software crypto someone will have to do the kmap (or
kmap_atomic), but I'd rather leave that as an implementation detail to
the crypto API as I already suggested earlier.

