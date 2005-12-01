From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Thu, 1 Dec 2005 23:17:09 +0200 (EET)
Message-ID: <Pine.LNX.4.63.0512012304240.5777@kai.makisara.local>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <1133468882.5232.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932483AbVLAVQ6@vger.kernel.org>
In-Reply-To: <1133468882.5232.14.camel@mulgrave>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Ryan Richter <ryan@tau.solarneutrino.net>, Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 1 Dec 2005, James Bottomley wrote:

> On Thu, 2005-12-01 at 11:38 -0800, Linus Torvalds wrote:
> > Ryan, can you test 2.6.15-rc4 and report what it does?
> > 
> > The "Bad page state" messages may (should) remain, but the crashes should 
> > be gone and the machine should hopefully continue functioning fine. And, 
> > perhaps more importantly, you should hopefully have a _new_ message about 
> > incomplete pfn mappings that should help pinpoint which driver causes 
> > this..
> 
> On a side note, I have Kai's patch in the scsi-rc-fixes tree which I'm
> getting ready to push.  Can we get a consensus on whether it should be
> removed before I merge upwards?
> 
I think it should be removed because it is based partly on a wrong 
assumption: asynchronous writes are _not_ done together with direct i/o. 
(I have also experimentally verified that this does not happen.)

The patch includes the patch I sent sent to linux-scsi on Nov 21. Nobody 
has commented it and I don't know if the user pages have to be explicitly 
marked dirty after the HBA has read data there. If they have to, then this 
earlier patch is valid. If not, I will send a patch for 2.6.16 to remove 
the latent code.

-- 
Kai
