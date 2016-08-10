From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: Regarding AHCI_MAX_SG and (ATA_HORKAGE_MAX_SEC_1024)
Date: Wed, 10 Aug 2016 18:04:10 +0800
Message-ID: <CAGnHSEkp8EyCU+roKgwzVo2HcpQEGdrLv65h3Z+uD=4YTUn9qQ@mail.gmail.com>
References: <CAGnHSEnsfmO8ydLZGBmEXgRCYTZfy+sR3knCWfBhCz6_vLZMEw@mail.gmail.com>
 <20160810032613.GA25053@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160810032613.GA25053@mtj.duckdns.org>
Sender: linux-block-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, dmilburn@redhat.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10 August 2016 at 11:26, Tejun Heo <tj@kernel.org> wrote:
> Hmmm.. why not?  The hardware limit is 64k and the driver is using a

Is that referring to the maximum number of entries allowed in the
PRDT, Physical Region Descriptor Table (which is, more precisely,
65535)?

> lower limit of 168 most likely because it doesn't make noticeable
> difference beyond certain point and it determines the size of
> contiguous memory which has to be allocated for the command table.
> Each sg entry is 16 bytes.  Pushing it to the hardware limit would
> require an order 9 allocation for each port.

That makes sense to me, and I didn't have the intention to push it to
the limit anyway.

> Not necessarily.  A single sg entry can point to an area larger than
> PAGE_SIZE.

You mean the 4MB limit of "Data Byte Count" in "DW3: Description
Information" of the PRDT? Is that what max_segment_size (which is set
to a general fallback of 65536:
http://lxr.free-electrons.com/ident?i=dma_get_max_seg_size) is about
in this case?

And my point was, it will be a multiple of 168 anyway, if 1344 is just
an example.

> As written above, that probably makes the ahci command table size
> nicely aligned.

I think that's what bothers me ultimately, cause I don't see how 168
makes it (more) nicely aligned (or even, aligned to what?).

I even checked out the AHCI driver of FreeBSD
(https://github.com/freebsd/freebsd/blob/master/sys/dev/ahci/ahci.h):

...
#define MAXPHYS 512 * 1024
...
#define AHCI_SG_ENTRIES (roundup(btoc(MAXPHYS) + 1, 8))
...
#define AHCI_CT_SIZE (128 + AHCI_SG_ENTRIES * 16)
...

Couldn't get the sense out of the `+ 1` and round up to 8 thing either.
