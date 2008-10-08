From: Marcel Holtmann <holtmann@linux.intel.com>
Subject: Re: [RFC] Normalizing byteorder/unaligned access API
Date: Wed, 08 Oct 2008 09:31:24 +0200
Message-ID: <1223451084.11272.250.camel@violet.holtmann.net>
References: <1223416391.8195.22.camel@brick>
	 <20081007232807.GL25780@parisc-linux.org> <1223422542.8195.42.camel@brick>
	 <20081007235533.GN25780@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <20081007235533.GN25780@parisc-linux.org>
Sender: linux-arch-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

Hi Matthew,

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

nice idea, but in the real world some stacks mix big and little endian
in their protocols. Take Bluetooth as an example ;)

Regards

Marcel
