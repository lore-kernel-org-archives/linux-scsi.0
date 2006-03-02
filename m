From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Question: how to map SCSI data DMA address to virtual address?
Date: Thu, 2 Mar 2006 17:09:15 +0000
Message-ID: <20060302170915.GA31316@infradead.org>
References: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752020AbWCBRJU@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C2651420C1@NAMAIL1.ad.lsil.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: "Ju, Seokmann" <Seokmann.Ju@engenio.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 02, 2006 at 09:53:06AM -0700, Ju, Seokmann wrote:
> Hi,
> 
> In the 'scsi_cmnd' structure, there are two entries holding address
> information for data to be transferred. One is 'request_buffer' and the
> other one is 'buffer'.
> In case of 'use_sg' is non-zero, those entries indicates the address of
> the scatter-gather table.
> 
> Is there way to get virtual address (so that the data could be accessed
> by the driver) of the actual data in the case of 'use_sg' is non-zero?

For each sg list entry do something like:

	buffer = kmap_atomic(sg->page, KM_USER0) + sg->offset;
	<access buffer>
	kunmap_atomic(buffer - sg->offset, KM_USER0);
