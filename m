From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Mon, 25 Oct 2004 18:55:47 -0500
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <200410252355.i9PNtlSp025091@falcon10.austin.ibm.com>
References: <16765.34908.93713.977225@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-reply-to: <16765.34908.93713.977225@cargo.ozlabs.ibm.com> 
To: Paul Mackerras <paulus@samba.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org
List-Id: linux-scsi@vger.kernel.org


On Tue, 26 Oct 2004 09:12:28 +1000, Paul Mackerras wrote:
>Doug Maxey writes:
>
>> Ok, lets look at those vars.  Both are defined in hdreg.h as bytes.
>> No fields in the data from the device are bytes, but are 16 bit.  On big
>> endian, the relative positions for an LE u16 are swapped.  If the swap is
>> not done on those, then one replaces the other when read.  Probably not
>> what was intended.  It appears that another bug is being fixed here.
>
>No.  The only sane way to do things is to transfer data from the
>device to memory as a byte stream, in other words, preserving the
>ordering of the individual bytes.  That is what we do on PPC and PPC64
>platforms.  That ordering is preserved (and must be preserved)
>irrespective of whether the transfer is actually done in 8, 16 or 32
>bit chunks.

Oh yes, I am aware.  Just happen to be working on PPC64.  Have been
writing drivers for this base for several years.  It's the olde LE
device vs BE host.  The transfers are done as a 16 bit quantity, PIO.
And yes, I understand, "we have always done it this way".  Works well
when you only have to deal with single arch.

Possibly I am not making point very well, that one is preserving the
correct byte order and let the structures reflect to native location.
Strings get swapped, 16, 32, and 64 bit fields likewise.  I just missed the 
LE order that is is being preserved for *some* few fields only.


>
>That means that 16-bit quantities might need to be byte-swapped to be
>interpreted in host byte order, but single-byte fields should always
>be in their correct sequence.

There is not a single reference to byte field in the ATA spec for
IDENTIFY DEVICE.  It just happens that some of the fields are 8 bits long. Or 
32 or 64.


>
>Paul.
>

++doug


