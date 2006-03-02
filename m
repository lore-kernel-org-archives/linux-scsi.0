From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 02 Mar 2006 11:22:12 -0600
Message-ID: <1141320132.3238.20.camel@mulgrave.il.steeleye.com>
References: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
	 <20060302170915.GA31316@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:35249 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751593AbWCBRWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 12:22:21 -0500
In-Reply-To: <20060302170915.GA31316@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Ju, Seokmann" <Seokmann.Ju@lsil.com>, "Ju, Seokmann" <Seokmann.Ju@engenio.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 2006-03-02 at 17:09 +0000, Christoph Hellwig wrote:
> For each sg list entry do something like:
> 
> 	buffer = kmap_atomic(sg->page, KM_USER0) + sg->offset;
> 	<access buffer>
> 	kunmap_atomic(buffer - sg->offset, KM_USER0);

Remember too that the data might not necessarily be valid without a
flush depending on where it has come from (or where it is going).  See
the dma_sync_sg_for_device/cpu.

James


