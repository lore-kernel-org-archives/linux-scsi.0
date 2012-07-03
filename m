From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
Date: Tue, 3 Jul 2012 16:25:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1207031618450.29825-100000@netrider.rowland.org>
References: <1341346072.3076.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341346072.3076.6.camel@dabdike>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Linus Torvalds <torvalds@linux-foundation.org>, Hans de Goede <hdegoede@redhat.com>, Ben Hutchings <ben@decadent.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 4 Jul 2012, James Bottomley wrote:

> > The reason for the try_rc_10_first flag is that some devices return
> > bogus data in response to RC16.  Like, an 800 GB device claiming to
> > have 3 exabytes.
> 
> So we could easily send both and only believe RC10 if the device is
> under 2TB.

More precisely, if RC10 indicates the device is under 2 TB then ignore 
the RC16 capacity.  Or maybe issue a warning if it disagrees with the 
RC10 capacity.

>  However, what about all the extra flags we read out of RC16,
> like trim, large sector size and DIF capability?  If the device lies
> about its capacity, won't we get bogus values for those as well, which
> is going to cause other screw ups?

That seems quite likely.  I don't know the answer for any individual 
cases, however.

For the greatest safety, I suppose we could disbelieve all the fields 
in the RC16 response if the RC16 capacity disagrees with the RC10 
capacity and the RC10 capacity is under 2 TB.

Alan Stern
