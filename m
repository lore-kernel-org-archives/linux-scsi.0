From: Doug Maxey <dwm@austin.ibm.com>
Subject: Re: [PATCH 1/1] build modular usb isd200 with modular ide
Date: Tue, 26 Oct 2004 13:05:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200410261805.i9QI5CKM029850@falcon10.austin.ibm.com>
References: <16765.45289.684525.732044@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pixpat.austin.ibm.com ([192.35.232.241]:54511 "EHLO
	falcon10.austin.ibm.com") by vger.kernel.org with ESMTP
	id S261392AbUJZSF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 14:05:28 -0400
In-reply-to: <16765.45289.684525.732044@cargo.ozlabs.ibm.com> 
List-Id: linux-scsi@vger.kernel.org
To: Paul Mackerras <paulus@samba.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <greg@kroah.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux IDE Mailing List <linux-ide@vger.kernel.org>, linuxppc64-dev@ozlabs.org

On Tue, 26 Oct 2004 12:05:29 +1000, Paul Mackerras wrote:
>For Linux or some other OS?

Linux for little over a year, 2.6 for about 3 months, some _other_ OS for
several years.

>
>> device vs BE host.  The transfers are done as a 16 bit quantity, PIO.
>> And yes, I understand, "we have always done it this way".  Works well
>> when you only have to deal with single arch.
>
>No, we haven't always done it this way on PPC. :)  Various different
>ways have been tried over the years and this is the only way that
>doesn't suck.
>
>> Possibly I am not making point very well, that one is preserving the
>> correct byte order and let the structures reflect to native location.
>
>I can't parse that sentence unambiguously...

s/to native location/the normalized (for the host) layout/

>
>> Strings get swapped, 16, 32, and 64 bit fields likewise.  I just missed the 
>> LE order that is is being preserved for *some* few fields only.
>
>Strings shouldn't get swapped, or at least, strings should only need
>to be swapped on a BE platform if they also need to be swapped on an
>LE platform.
>
>> There is not a single reference to byte field in the ATA spec for
>> IDENTIFY DEVICE.  It just happens that some of the fields are 8 bits long. Or 
>> 32 or 64.
>
>And your point is...  ?

To me, and I do seem to be in the minority, it seems that normalizing the 
entire bytestream is the right thing (tm).  But I can see the point that 
leaving certain parts non-normalized is cheaper.

It was my mistake missing the use of the char fields.  GIITD.  In any
event, with 2.6.10-rc1 the problem seems to be solved in spite of my
meddling. :-)

++doug



