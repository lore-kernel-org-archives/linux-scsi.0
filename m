From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Areca driver recap + status
Date: Tue, 27 Jun 2006 10:27:54 -0500
Message-ID: <1151422074.3340.25.camel@mulgrave.il.steeleye.com>
References: <09be01c695b3$2ed8c2c0$c100a8c0@robm>
	 <20060621222826.ff080422.akpm@osdl.org>
	 <1151333338.2673.4.camel@mulgrave.il.steeleye.com>
	 <057801c69970$70b45090$0e00cb0a@robm>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161101AbWF0P2X@vger.kernel.org>
In-Reply-To: <057801c69970$70b45090$0e00cb0a@robm>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Mueller <robm@fastmail.fm>
Cc: Andrew Morton <akpm@osdl.org>, rdunlap@xenotime.net, hch@infradead.org, erich@areca.com.tw, brong@fastmail.fm, dax@gurulabs.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2006-06-27 at 08:32 +1000, Robert Mueller wrote:
> > - PAE (cast of dma_addr_t to unsigned long) issues.
> 
> Can you explain a bit what this is about and what the effect is? It's just 
> that we've been using the driver (older version from the areca website) in a 
> PAE kernel on machines with 8G of memory and haven't had a problem yet 
> (running high IO load for several weeks) but this sounds like it 
> might/should cause corruption or crashing in this situation?

It's these pieces:

+		pcmd->SCp.ptr = (char *)(unsigned long) dma_addr;


+	else if (pcmd->request_bufflen != 0)
+		pci_unmap_single(acb->pdev,
+			(dma_addr_t)(unsigned long)pcmd->SCp.ptr,
+			pcmd->request_bufflen, pcmd->sc_data_direction);

On a PAE platform, dma_addr_t is u64 and unsigned long is u32, so any
address > 4GB will be truncated by these operations.

I think all this does is cause a slow leak of dma mappings, and on any
kernel > 2.6.16 the leak should be even smaller, since we've severely
restricted the use_sg == 0 case.  It probably is only significant on
x86_64 with the gart iommu enabled.

James
