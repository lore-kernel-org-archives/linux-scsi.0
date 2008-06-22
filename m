From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] libata support for rotation speed
Date: Sun, 22 Jun 2008 07:31:06 -0600
Message-ID: <20080622133105.GY4392@parisc-linux.org>
References: <20080619160216.GH4392@parisc-linux.org> <20080619175904.GK4392@parisc-linux.org> <1213899895.3501.45.camel@localhost.localdomain> <20080619183113.GM4392@parisc-linux.org> <485AAD0D.9000205@garzik.org> <20080619191337.GO4392@parisc-linux.org> <485E4894.7000508@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <485E4894.7000508@panasas.com>
Sender: linux-ide-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Jun 22, 2008 at 03:41:56PM +0300, Boaz Harrosh wrote:
> > +		rbuf[4] = args->id[217] >> 8;
> > +		rbuf[5] = args->id[217];
> 
> args->id of struct ata_scsi_args are defined as u16.
> Are they actually SWABed at this point? Are they LE? BE?

They're cpu-endian at this point, I believe.  See ata_dev_read_id() in
libata-core.c where it calls swap_buf_le16().

> if args->id are actually __be16 then above should be
>  +		put_unaligned(args->id[217], &rbuf[4]);
> else
>  +		put_unaligned_be16(args->id[217], &rbuf[4]);

But the buf isn't unaligned, nor the offset within it.  And I
get confused by all these macros anyway.  If we had something like
store_scsi_u16(unsigned char *, u16), I'd use that, but put_unaligned_be16
just doesn't make sense.

I actually wrote my own accessors for scsi_ram.  If they were to be more
generic, they ought to be renamed, but this is what I found useful:

/*
 * SCSI requires quantities to be written MSB.  They're frequently misaligned,
 * so don't mess about with cpu_to_beN, just access it byte-wise
 */
static void scsi_ram_put_u32(unsigned char *addr, unsigned int data)
{
        addr[0] = data >> 24;
        addr[1] = data >> 16;
        addr[2] = data >> 8;
        addr[3] = data;
}

static unsigned int scsi_ram_get_u16(unsigned char *addr)
{
        unsigned int data;
        data = addr[0] << 8;
        data |= addr[1];

        return data;
}

static unsigned int scsi_ram_get_u24(unsigned char *addr)
{
        unsigned int data;
        data = addr[0] << 16;
        data |= addr[1] << 8;
        data |= addr[2];

        return data;
}

static unsigned int scsi_ram_get_u32(unsigned char *addr)
{
        unsigned int data;
        data = addr[0] << 24;
        data |= addr[1] << 16;
        data |= addr[2] << 8;
        data |= addr[3];

        return data;
}

I'm sure a more fully-featured set would include put_u24 and put_u16 too.
For the curious, u24 is useful for implementing read6/write6.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
