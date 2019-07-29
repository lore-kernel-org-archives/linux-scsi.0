From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
Date: Mon, 29 Jul 2019 17:25:35 +0530
Message-ID: <CAK=zhgrWW_vOkXKRYRbiMdHgiT7u=Ra_pCkO_HkmQrCdVXfJBQ@mail.gmail.com>
References: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20190726142706.GA1734@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190726142706.GA1734@infradead.org>
Sender: stable-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Suganath Prabu <suganath-prabu.subramani@broadcom.com>, linux-scsi <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 26, 2019 at 7:57 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Jul 26, 2019 at 06:00:57AM -0400, Suganath Prabu wrote:
> > Although SAS3 & SAS3.5 IT HBA controllers support
> > 64-bit DMA addressing, as per hardware design,
> > DMA address with all 64-bits set (0xFFFFFFFF-FFFFFFFF)
> > results in a firmware fault.
>
> Linux will never send a dma address with all bits set anyway, as that
> is our magic escape for the dma_addr_t error value.  Additionally to
> generate that address you'd need a 1-byte sized, 1-byte aligned buffer,
> which we never use.

I agree with your above statement. But it is also possible that
0xFFFFFFFF-FFFFFFFF falls under the DMA able range, e.g. SGE's start
address is 0xFFFFFFFF-FFFF000 and data length is 0x1000 bytes. So when
HBA tries to DMA the data at 0xFFFFFFFF-FFFFFFFF location then it will
faults the firmware due to it's hardware design.

We have observed above example's SGE address and length on AMD systems
with SME & IOMMU enabled.

Thanks,
Sreekanth
