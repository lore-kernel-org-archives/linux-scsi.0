From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: scsi: Implement per-cpu logging buffer
Date: Thu, 12 Feb 2015 09:18:26 -0800
Message-ID: <20150212171826.GA31750@thin>
References: <20150211191614.349AF660DDA@gitolite.kernel.org>
 <CAMuHMdUKH1yuLZ9zLAK2STekLFXBufR9PM2_S11xExCtEc9dWg@mail.gmail.com>
 <54DCAABF.20606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35480 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbbBLRSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Feb 2015 12:18:37 -0500
Content-Disposition: inline
In-Reply-To: <54DCAABF.20606@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>

On Thu, Feb 12, 2015 at 02:29:35PM +0100, Hannes Reinecke wrote:
> On 02/12/2015 01:36 PM, Geert Uytterhoeven wrote:
> > On Wed, Feb 11, 2015 at 8:16 PM, Linux Kernel Mailing List
> > <linux-kernel@vger.kernel.org> wrote:
> >> Gitweb:     http://git.kernel.org/linus/;a=commit;h=ded85c193a391a84076d5c6a7a5668fe164a490e
> >> Commit:     ded85c193a391a84076d5c6a7a5668fe164a490e
> >> Parent:     b0a93d96b2814c725161f91a4e35d0c29ec0f95b
> >> Refname:    refs/heads/master
> >> Author:     Hannes Reinecke <hare@suse.de>
> >> AuthorDate: Thu Jan 8 07:43:42 2015 +0100
> >> Committer:  Christoph Hellwig <hch@lst.de>
> >> CommitDate: Fri Jan 9 15:44:28 2015 +0100
> >>
> >>     scsi: Implement per-cpu logging buffer
> >>
> >>     Implement a per-cpu buffer for formatting messages to avoid line breaks
> >>     up under high load.  This patch implements scmd_printk() and
> >>     sdev_prefix_printk() using the per-cpu buffer and makes sdev_printk() a
> >>     wrapper for sdev_prefix_printk().
> >>
> >>     Tested-by: Robert Elliott <elliott@hp.com>
> >>     Reviewed-by: Robert Elliott <elliott@hp.com>
> >>     Signed-off-by: Hannes Reinecke <hare@suse.de>
> >>     Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> >> --- /dev/null
> >> +++ b/drivers/scsi/scsi_logging.c
> > 
> >> +#define SCSI_LOG_SPOOLSIZE 4096
> >> +#define SCSI_LOG_BUFSIZE 128
> >> +
> >> +#if (SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE) > BITS_PER_LONG
> >> +#warning SCSI logging bitmask too large
> >> +#endif
> >> +
> >> +struct scsi_log_buf {
> >> +       char buffer[SCSI_LOG_SPOOLSIZE];
> >> +       unsigned long map;
> >> +};
> >> +
> >> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
> > 
> > Do we really need a static 4 KiB per-CPU buffer?
> > 
> > bloat-o-meter:
> > 
> > add/remove: 183/94 grow/shrink: 314/211 up/down: 33467/-21291 (12176)
> > function                                     old     new   delta
> > scsi_format_log                                -    4100   +4100
> > handle_mm_fault                             1794    2750    +956
> > scsi_log_print_sense_hdr                       -     774    +774
> > proc_keys_show                                 -     770    +770
> > 
> Define 'need'.
> We don't absolutely 'need' it. (Configure it out and it's gone).
> 
> But when we want to avoid several logging messages coming in from
> various CPUs overwriting each other and _not_ introduce additional
> latency by locking a single buffer, then yes.
> 
> We can possibly reduce it to, say, 1KiB or even lower by imposing
> stricter rules on the logging functions.
> But I don't see a way around the per-CPU buffer.

It seems very odd to introduce a mechanism like this specifically for
SCSI, rather than introducing a generic per-CPU buffered-print mechanism
in printk, controlled by a config option.  That option could then
automatically go away when !SMP, or !PRINTK, or if users don't actually
care about message ordering.

Also, this doesn't seem to be configurable at all.

- Josh Triplett
