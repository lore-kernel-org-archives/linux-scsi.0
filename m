From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: PATCH: Further aacraid work
Date: Mon, 28 Jun 2004 09:17:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FF1D56C@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:9138 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S264936AbUF1NRN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jun 2004 09:17:13 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, William Lee Irwin III <wli@holomorphy.com>
Cc: Alan Cox <alan@redhat.com>, Arjan van de Ven <arjanv@redhat.com>, Clay Haapala <chaapala@cisco.com>, Christoph Hellwig <hch@infradead.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

Wow!

& Thanks!

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Sunday, June 27, 2004 1:33 PM
To: William Lee Irwin III
Cc: Alan Cox; Salyzyn, Mark; Arjan van de Ven; Clay Haapala; Christoph
Hellwig; Linux Kernel; SCSI Mailing List; Andrew Morton
Subject: Re: PATCH: Further aacraid work

On Fri, 2004-06-18 at 15:32, William Lee Irwin III wrote:
> On Fri, Jun 18, 2004 at 08:05:18AM -0700, William Lee Irwin III wrote:
> > Proper changelog this time, and comments, too. Adaptec et al, please
> > verify this resolves the issues you've been having.
> > Someone say _something_.
> 
> jejb's seeing such improved results that I don't believe we need to
> wait for Adaptec's ack to merge this.
> 
> akpm, please apply.

The patch is already in mainline, but here's my final set of statistics
on it.  I traced the effectiveness over a full day's operations on a
scsi build and test machine (I don't get uptime much over a day on these
machines since they're usually being rebooted to test new patches).

The machine is an 8-way p66 voyager with 256k of memory.

I did notice the mergers start off high (at around 50%) after first boot
and then decline.  The asymptote of the decline appears to be around 26%
which is still a respectable merge rate for a non-iommu machine.  I was
impressed to see that even at the end of the day I was still getting
multi-page merges (still up to 128 pages).

The instrumentation counts the total number of pages in merged segments
and the total number of segments through the machine.  The final figures
for the day were

Total pages merged:	192682
Total segments:		549497

So the amount of I/O through the system is 2.2-2.9GB or more than ten
times the machine's actual memory capacity (hopefully this puts me well
up into the usual operating region for physical page fragmentation).

James


