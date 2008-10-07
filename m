From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Tue, 7 Oct 2008 17:55:34 -0600
Message-ID: <20081007235533.GN25780@parisc-linux.org>
References: <1223416391.8195.22.camel@brick> <20081007232807.GL25780@parisc-linux.org> <1223422542.8195.42.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:39120 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbYJGXzf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 19:55:35 -0400
Content-Disposition: inline
In-Reply-To: <1223422542.8195.42.camel@brick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Tue, Oct 07, 2008 at 04:35:42PM -0700, Harvey Harrison wrote:
> On Tue, 2008-10-07 at 17:28 -0600, Matthew Wilcox wrote:
> > On Tue, Oct 07, 2008 at 02:53:11PM -0700, Harvey Harrison wrote:
> > > In addition, there are some subsystems (scsi) that are looking into some
> > > differently sized endian helpers (be24) and it may be worthwhile to have
> > > some agreement whether it is worth making them common infrastructure and
> > > whether they should present a similar API to the common byteorder/unaligned
> > > API.
> > 
> > I still think SCSI should have its own accessors, even if they're
> > just wrappers around the common BE code.
> > 
> 
> I thought it was generally discouraged that subsystems have trivial
> wrappers like that, otherwise you wind up with:
> 
> scsi_get_u32
> usb_get_u32
> v4l_get_u32
> 
> ... and so on, where as if they all used the common names, people more
> used to other areas of the kernel can still recognize what the code
> is doing without having the lookup another define.

My point is that they don't have to recognise what the code is doing.
They don't have to know if the protocol is BE or LE, only that USB code
is accessing the data in the appropriate way for USB.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
