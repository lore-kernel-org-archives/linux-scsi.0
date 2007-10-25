From: Rob Landley <rob@landley.net>
Subject: Re: Questions about scsi.c
Date: Thu, 25 Oct 2007 18:13:21 -0500
Message-ID: <200710251813.21575.rob@landley.net>
References: <200710250606.03301.rob@landley.net> <200710251640.35758.rob@landley.net> <20071025134926.4d209584.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:44095
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752826AbXJYWNh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 18:13:37 -0400
In-Reply-To: <20071025134926.4d209584.rdunlap@xenotime.net>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-scsi@vger.kernel.org, jgarzik <jgarzik@pobox.com>

On Thursday 25 October 2007 3:49:26 pm Randy Dunlap wrote:
> On Thu, 25 Oct 2007 16:40:35 -0500 Rob Landley wrote:
> > On Thursday 25 October 2007 12:32:41 pm Randy Dunlap wrote:
> > > > Entirely possible I'm doing something wrong:
> > > >
> > > >    <sect1 id="scsi_device.h">
> > > >       <title>include/scsi/scsi_device.h</title>
> > > >       <para>
> > > >       </para>
> > > > !Einclude/scsi/scsi_device.h
> > > >     </sect1>
> > >
> > > !E is for exported symbols and that file has none.
> > > USe !I instead.
> >
> > So how do I handle a case like drivers/ata/libata-core.c which has
> > EXPORT_SYMBOL() calls for functions that live in (and are documented in)
> > other files, such as ata_scsi_ioctl() in drivers/ata/libata-scsi.c?
>
> I don't see ata_scsi_ioctl() documented at all.  Are you looking at
> a newer tree than I am?  (i'm using 2.6.24-rc1)

No, I mean I was thinking of adding a kerneldoc comment and noticed the 
discrepancy.

As for already checked-in stuff, substitute ata_std_bios_param, 
ata_scsi_slave_config, and ata_scsi_slave_destroy.  Each of those functions 
has a kerneldoc comment in libata-scsi.c, but the export statement for that 
function is in libata-core.c.

> Long-term answer is that we prefer EXPORT_SYMBOL() to be used
> just under the function that is being exported.  In this case,
> the maintainer may be disagreeing with that.  [cc-ed]

Moving the EXPORT_SYMBOL()s would be nice.  The documentation tools don't 
preserve context outside of a single file, and I'd like to get full coverage 
documenting exported symbols before worrying much about internal ones...

> Short-term answer is to use !Isource_filename_where_kernel_doc_is
> as though it's not EXPORTed.  I think.

Except if the EXPORTs got moved/fixed it would then hide them from !I without 
generating any kind of warning.

Actually, for the really short term I can go "see the existing libata book in 
this directory" and foist this problem off on Jeff Garzik. :) (Friday 
deadline.)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
