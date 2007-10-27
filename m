From: Rob Landley <rob@landley.net>
Subject: Re: Questions about proc_scsi_write() in scsi_proc.c
Date: Fri, 26 Oct 2007 23:16:12 -0500
Message-ID: <200710262316.12716.rob@landley.net>
References: <200710261507.49284.rob@landley.net> <200710261729.53400.rob@landley.net> <1193438877.3293.84.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41813
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751056AbXJ0DQ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:16:27 -0400
In-Reply-To: <1193438877.3293.84.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Friday 26 October 2007 5:47:57 pm James Bottomley wrote:
> > > http://www.t10.org/ftp/t10/drafts/sam3/sam3r14.pdf
> > > http://www.t10.org/ftp/t10/drafts/sam4/sam4r13.pdf
> >
> > Unfortunately those two documents are 127 pages and 148 pages,
> > respectively, and I haven't had a chance to make any headway in them yet.
> >
> > Every device I have that shows up as SCSI has shown up with a LUN of 0,
> > which is target-wide unique because none of those targets have
> > sub-functions that need to be independently addressed as devices.
> >
> > Is there an easy way to distinguish between "target-wide unique lun" and
> > this Logical Unit Number device attribute that's either 8 bytes or 2
> > bytes wide? (Capitalization?)
>
> They both have a section called " Definitions, symbols, abbreviations,
> and conventions"; you'll find LUN (and LU) defined in there.

Page 23 of the PDF:

  3.1.64 Logical Unit Number (LUN): A 64-bit or 16-bit identifier for a 
logical unit.  See 4.9



> > > > 2) How do you trigger this?  /proc/scsi/scsi is read only even for
> > > > root.
> > >
> > > root can still write to it.
> >
> > Wow.  (Is this an idiosyncrasy of /proc, or a capability of root I've
> > been unaware of all this time?)
> >
> > > > 3) This bit is repeated in both the add and remove logic:
> > > >                 p = buffer + 23;
> > > >
> > > >                 host = simple_strtoul(p, &p, 0);
> > > >                 channel = simple_strtoul(p + 1, &p, 0);
> > > >                 id = simple_strtoul(p + 1, &p, 0);
> > > >                 lun = simple_strtoul(p + 1, &p, 0);
> > > >
> > > > So what happens if you echo "scsi add-single-device 0" >
> > > > /proc/scsi/scsi (or wherever file would trigger this function) so the
> > > > read for channel skips over the null terminator (I'm assuming there
> > > > is one) and reads who knows what?  Or what if instead of ending that
> > > > with one 0, you end it with enough zeroes to pad right up to
> > > > PAGE_SIZE, so it reads the next page?  (I don't even know what the
> > > > page protections are on that, depends how
> > > > __get_free_page(GFP_KERNEL) works...)
> > > >
> > > > Confused,
> > >
> > > It's relying on the user buffer being zero padded, but even if it
> > > isn't, there's not much that can go wrong.  It's also a deprecated
> > > interface.
> >
> > Where do I find out what interfaces are deprecated?  (Is this written
> > down somewhere?  Or do you just mean that the whole of /proc is moving to
> > /sys where possible?)
>
> It's part of the general deprecating proc except for process files
> edict.
>
> James



-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
