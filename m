From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.25-rc1
Date: Wed, 13 Feb 2008 19:34:03 -0800
Message-ID: <20080213193403.c0dde7f8.akpm@linux-foundation.org>
References: <1202947364.3109.96.camel@localhost.localdomain>
	<20080213161643.65a5a779.akpm@linux-foundation.org>
	<1202951513.3109.101.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764652AbYBNDea@vger.kernel.org>
In-Reply-To: <1202951513.3109.101.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 13 Feb 2008 19:11:53 -0600 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> > mptbase-reset-ioc-initiator-during-pci-resume.patch
> > 
> >   Fixes suspend/resume on all of Darrick's MPT cards.  I first merged it
> >   in September 2007.
> 
> Patch presented by LSI but has gone back with comments

Five months is too long to fix a bug when someone has already sent us a
patch.  If they insist on being this sluggish I'd suggest that you review
the patch yourself then just merge it.  That will get their attention. 
Maybe.

> > dell-cerc-support-for-megaraid_mbox.patch
> 
> I need megaraid to sign off (and test) this one.

Two months, same story.

> > scsi-qlogicptic-section-fixes.patch
> > 
> >   Fixes a reference from .text into .init.text and hence might fix a
> >   machine crash when this driver is build into vmlinux.  Merged a week ago.
> 
> This was the one we had the alternative fix for, wasn't it ... ?

In current mainline, __devinit qpti_sbus_probe() still is calling __init
qpti_chain_add() (for example).  So in a CONFIG_HOTPLUG kernel, hotplugging
a new device (on sbus, ok, bad example ;)) will crash.

But Adrian has fixed six such bugs in there, maybe one of them can hit.  I
don't think we've fixed these by alternative means, unless we've disabled
__devinit?


Still, we can discuss specific patches all day.  I think there is a
_general_ problem getting bugfixes, warning fixes and cleanups into scsi
drivers within reasonable amounts of time?
