From: Christoph Hellwig <hch@infradead.org>
Subject: Re: iomapping a big endian area
Date: Tue, 5 Apr 2005 08:21:04 +0100
Message-ID: <20050405072104.GA26208@infradead.org>
References: <1112475134.5786.29.camel@mulgrave> <20050403013757.GB24234@parcelfarce.linux.theplanet.co.uk> <1112649465.5813.106.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261592AbVDEHZ0@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1112649465.5813.106.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 04, 2005 at 04:17:45PM -0500, James Bottomley wrote:
> OK, I sent the patch off to Andrew.  To complete the original problem,
> the attached is the patch that uses it in the parisc lasi driver
> (although, actually, it sets up 53c700 to work everywhere including BE
> on a LE system).
> 
> I changed some of the flags around to reflect the fact that we now have
> generic BE support in the driver (rather than the more limited
> force_le_on_be flag).

What I really don't like is that you still need ifdefs and wrappers to
support BE and LE wired chips in the same driver.  Shouldn't you set the
BE or LE flag at iomap() time and always use the same accessors?
