From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH 15/15] Add Documentation/DocBook/scsi_midlayer.tmpl and add to Makefile.
Date: Sat, 27 Oct 2007 18:53:50 -0500
Message-ID: <200710271853.51187.rob@landley.net>
References: <200710262318.01021.rob@landley.net> <20071026230557.2ac5f9c8.rdunlap@xenotime.net> <1193491464.15612.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39018
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750861AbXJ0WyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Oct 2007 18:54:10 -0400
In-Reply-To: <1193491464.15612.6.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org

On Saturday 27 October 2007 8:24:24 am James Bottomley wrote:
> On Fri, 2007-10-26 at 23:05 -0700, Randy Dunlap wrote:
> > On Fri, 26 Oct 2007 23:18:00 -0500 Rob Landley wrote:
> > > From: Rob Landley <rob@landley.net>
> > >
> > > Add Documentation/DocBook/scsi_midlayer.tmpl and add to Makefile.
> >
> > I have comments for all 15 patches here.
> >
> > a.  You should cc: the maintainer who you want/expect to apply the
> > 	patches.  Always.  Andrew Morton is the only person who
> > 	trolls for patches on a mailing list.  :)
>
> Realistically too, for this first batch that covers mostly the mid-layer
> and the transport classes, a single patch like you originally submitted
> was just fine.  One patch per file isn't.  Patches should be split
> across functional areas (in this case the function is simply adding the
> SCSI mid layer to the docbook build, so they can all go together).

Ooh, that makes things much easier on me.  Thanks. :)

> > b.  The function "Description:" section header is not strictly
> > 	required by scripts/kernel-doc.  It will assume that the
> > 	first text section after parameters is the Description:
> > 	section.  FYI.
> >
> > c.  Extraneous whitespace.  Git or quilt check for this.
> > 	I don't know about hg...
>
> Actually, the checkpatch.pl script in the scripts directory of the
> kernel is very good for this (I ran it on the original monolithic
> patch):

Ok.  I'll add that to my ~/cannon.sh to put a patch in cannonical format.

> In addition, there seem to be a few functions that you added kerneldoc
> for which don't show up in the doc output.  The one that caught my eye
> was scsi_cmd_get_serial(), but I think there are others.

I'm replying to Randy's message in another window as I deal with the issues he 
raised, but I'll cut and paste that chunk over here:

These comments could use a lot more work in general.  Several exported 
functions aren't commented at all, and several files have both internal 
functions and external functions with kerneldoc comments (which I'm currently 
grabbing only one or the other of, because the build has !I and !E which grab 
one of the other, and both complain and insert junk into the output if the 
file hasn't got any of the type it's looking for).

Ideally I'd like to grab them all in one pass and annotate each function name 
with the export type (if any).  Not just "is it exported" but is it 
EXPORT_SYMBOL or EXPORT_SYMBOL_GPL or whatever those EXPORT_PER_CPU_SYMBOL 
things are I haven't had time to look into yet.  But this requires a change 
to the kernel build infrastructure.  (I hope it can be done in docproc.c, I 
really don't like trying to modify other people's perl code.  Anyway, todo 
item.  Probably a new include type !B for both.  Possibly I could currently 
combine !I and !D now, but then I wouldn't get the annotations about export 
type...)

> James

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
