From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Tue, 07 Oct 2008 17:02:18 -0700
Message-ID: <1223424138.8195.47.camel@brick>
References: <1223416391.8195.22.camel@brick>
	 <20081007232807.GL25780@parisc-linux.org> <1223422542.8195.42.camel@brick>
	 <20081007235533.GN25780@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:29202 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758744AbYJHACW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 20:02:22 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3708529wfd.4
        for <linux-scsi@vger.kernel.org>; Tue, 07 Oct 2008 17:02:21 -0700 (PDT)
In-Reply-To: <20081007235533.GN25780@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Tue, 2008-10-07 at 17:55 -0600, Matthew Wilcox wrote:
> On Tue, Oct 07, 2008 at 04:35:42PM -0700, Harvey Harrison wrote:
> > On Tue, 2008-10-07 at 17:28 -0600, Matthew Wilcox wrote:
> > > On Tue, Oct 07, 2008 at 02:53:11PM -0700, Harvey Harrison wrote:
> > > > In addition, there are some subsystems (scsi) that are looking into some
> > > > differently sized endian helpers (be24) and it may be worthwhile to have
> > > > some agreement whether it is worth making them common infrastructure and
> > > > whether they should present a similar API to the common byteorder/unaligned
> > > > API.
> > > 
> > > I still think SCSI should have its own accessors, even if they're
> > > just wrappers around the common BE code.
> > > 
> > 
> > I thought it was generally discouraged that subsystems have trivial
> > wrappers like that, otherwise you wind up with:
> > 
> > scsi_get_u32
> > usb_get_u32
> > v4l_get_u32
> > 
> > ... and so on, where as if they all used the common names, people more
> > used to other areas of the kernel can still recognize what the code
> > is doing without having the lookup another define.
> 
> My point is that they don't have to recognise what the code is doing.
> They don't have to know if the protocol is BE or LE, only that USB code
> is accessing the data in the appropriate way for USB.
> 

Or you go the packed-struct route and use the common helpers, and sparse tells
you if you use the wrong endianness.  Even better, the structs act as decent
documentation of the data being worked on.

YMMV,

Harvey

