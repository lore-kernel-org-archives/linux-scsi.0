From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date: Fri, 26 Jul 2019 07:27:06 -0700
Message-ID: <20190726142706.GA1734@infradead.org>
References: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 26, 2019 at 06:00:57AM -0400, Suganath Prabu wrote:
> Although SAS3 & SAS3.5 IT HBA controllers support
> 64-bit DMA addressing, as per hardware design,
> DMA address with all 64-bits set (0xFFFFFFFF-FFFFFFFF)
> results in a firmware fault.

Linux will never send a dma address with all bits set anyway, as that
is our magic escape for the dma_addr_t error value.  Additionally to
generate that address you'd need a 1-byte sized, 1-byte aligned buffer,
which we never use.
