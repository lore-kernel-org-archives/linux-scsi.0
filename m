From: Rob Landley <rob@landley.net>
Subject: Re: Questions about scsi.c
Date: Tue, 30 Oct 2007 17:23:25 -0500
Message-ID: <200710301723.25767.rob@landley.net>
References: <200710250606.03301.rob@landley.net> <472724EA.3050502@pobox.com> <1193755409.3321.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:33028
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758583AbXJ3WXc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Oct 2007 18:23:32 -0400
In-Reply-To: <1193755409.3321.19.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Randy Dunlap <rdunlap@xenotime.net>, linux-scsi@vger.kernel.org

On Tuesday 30 October 2007 9:43:29 am James Bottomley wrote:
> On Tue, 2007-10-30 at 08:34 -0400, Jeff Garzik wrote:
> > Randy Dunlap wrote:
> > > On Thu, 25 Oct 2007 16:40:35 -0500 Rob Landley wrote:
> > >> On Thursday 25 October 2007 12:32:41 pm Randy Dunlap wrote:
> > >>> !E is for exported symbols and that file has none.
> > >>> USe !I instead.
> > >>
> > >> So how do I handle a case like drivers/ata/libata-core.c which has
> > >> EXPORT_SYMBOL() calls for functions that live in (and are documented
> > >> in) other files, such as ata_scsi_ioctl() in
> > >> drivers/ata/libata-scsi.c?
...
> > Yeah I tended to prefer that all exports be in one place, rather than
> > scattered around and difficult to evaluate en masse :)
>
> My personal preference (and how I code) is export at the bottom of the
> function.  However, it's one of those stylistic things that I'm happy to
> have people code however they want (either everything at the bottom of
> the file or all exports at the bottom of the exported function) as long
> as they follow the current style of whatever file they're patching.

Actually, this one is written up in CodingStyle:

> In source files, separate functions with one blank line.  If the function
> is exported, the EXPORT* macro for it should follow immediately after the
> closing function brace line.  E.g.:
>
> int system_is_up(void)
> {
>         return system_state == SYSTEM_RUNNING;
> }
> EXPORT_SYMBOL(system_is_up);

The functional problem is that when the EXPORT_SYMBOL() is in a different file 
entirely, the documentation infrastructure doesn't pick up that it's an 
exported function.

> James

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
