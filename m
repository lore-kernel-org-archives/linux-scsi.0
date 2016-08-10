From: Tejun Heo <tj@kernel.org>
Subject: Re: Regarding AHCI_MAX_SG and (ATA_HORKAGE_MAX_SEC_1024)
Date: Wed, 10 Aug 2016 11:14:47 -0400
Message-ID: <20160810151447.GI25053@mtj.duckdns.org>
References: <CAGnHSEnsfmO8ydLZGBmEXgRCYTZfy+sR3knCWfBhCz6_vLZMEw@mail.gmail.com>
 <20160810032613.GA25053@mtj.duckdns.org>
 <CAGnHSEkp8EyCU+roKgwzVo2HcpQEGdrLv65h3Z+uD=4YTUn9qQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGnHSEkp8EyCU+roKgwzVo2HcpQEGdrLv65h3Z+uD=4YTUn9qQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: linux-ide@vger.kernel.org, dmilburn@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello, Tom.

On Wed, Aug 10, 2016 at 06:04:10PM +0800, Tom Yan wrote:
> On 10 August 2016 at 11:26, Tejun Heo <tj@kernel.org> wrote:
> > Hmmm.. why not?  The hardware limit is 64k and the driver is using a
> 
> Is that referring to the maximum number of entries allowed in the
> PRDT, Physical Region Descriptor Table (which is, more precisely,
> 65535)?

Yeap.

> > Not necessarily.  A single sg entry can point to an area larger than
> > PAGE_SIZE.
> 
> You mean the 4MB limit of "Data Byte Count" in "DW3: Description
> Information" of the PRDT? Is that what max_segment_size (which is set
> to a general fallback of 65536:
> http://lxr.free-electrons.com/ident?i=dma_get_max_seg_size) is about
> in this case?

Ah, ahci isn't setting the hardware limit properly but yeah that's the
maximum segment size.

> And my point was, it will be a multiple of 168 anyway, if 1344 is just
> an example.
> 
> > As written above, that probably makes the ahci command table size
> > nicely aligned.
> 
> I think that's what bothers me ultimately, cause I don't see how 168
> makes it (more) nicely aligned (or even, aligned to what?).

Hmmm... Looked at the sizes and they don't seem to align to anything
meaningful.  No idea.

Thanks.

-- 
tejun
