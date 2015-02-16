From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: scsi: Implement per-cpu logging buffer
Date: Sun, 15 Feb 2015 18:36:50 -0800
Message-ID: <20150216023650.GA23633@thin>
References: <20150211191614.349AF660DDA@gitolite.kernel.org>
 <CAMuHMdUKH1yuLZ9zLAK2STekLFXBufR9PM2_S11xExCtEc9dWg@mail.gmail.com>
 <54DCAABF.20606@suse.de>
 <20150212171826.GA31750@thin>
 <54DDBA64.4060600@suse.de>
 <20150213154519.GA8527@thin>
 <54DF5BD1.5000906@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <54DF5BD1.5000906@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Christoph Hellwig <hch@lst.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 14, 2015 at 03:29:37PM +0100, Hannes Reinecke wrote:
> On 02/13/2015 04:45 PM, Josh Triplett wrote:
> > On Fri, Feb 13, 2015 at 09:48:36AM +0100, Hannes Reinecke wrote:
> >> On 02/12/2015 06:18 PM, Josh Triplett wrote:
> >>> On Thu, Feb 12, 2015 at 02:29:35PM +0100, Hannes Reinecke wrote:
> >>>> On 02/12/2015 01:36 PM, Geert Uytterhoeven wrote:
> >>>>> On Wed, Feb 11, 2015 at 8:16 PM, Linux Kernel Mailing List
> >>>>> <linux-kernel@vger.kernel.org> wrote:
> >>>>>> Gitweb:     http://git.kernel.org/linus/;a=commit;h=ded85c193a391a84076d5c6a7a5668fe164a490e
> >>>>>> Commit:     ded85c193a391a84076d5c6a7a5668fe164a490e
> >>>>>> Parent:     b0a93d96b2814c725161f91a4e35d0c29ec0f95b
> >>>>>> Refname:    refs/heads/master
> >>>>>> Author:     Hannes Reinecke <hare@suse.de>
> >>>>>> AuthorDate: Thu Jan 8 07:43:42 2015 +0100
> >>>>>> Committer:  Christoph Hellwig <hch@lst.de>
> >>>>>> CommitDate: Fri Jan 9 15:44:28 2015 +0100
> >>>>>>
> >>>>>>     scsi: Implement per-cpu logging buffer
> >>>>>>
> >>>>>>     Implement a per-cpu buffer for formatting messages to avoid line breaks
> >>>>>>     up under high load.  This patch implements scmd_printk() and
> >>>>>>     sdev_prefix_printk() using the per-cpu buffer and makes sdev_printk() a
> >>>>>>     wrapper for sdev_prefix_printk().
> >>>>>>
> >>>>>>     Tested-by: Robert Elliott <elliott@hp.com>
> >>>>>>     Reviewed-by: Robert Elliott <elliott@hp.com>
> >>>>>>     Signed-off-by: Hannes Reinecke <hare@suse.de>
> >>>>>>     Signed-off-by: Christoph Hellwig <hch@lst.de>
> >>>>>
> >>>>>> --- /dev/null
> >>>>>> +++ b/drivers/scsi/scsi_logging.c
> >>>>>
> >>>>>> +#define SCSI_LOG_SPOOLSIZE 4096
> >>>>>> +#define SCSI_LOG_BUFSIZE 128
> >>>>>> +
> >>>>>> +#if (SCSI_LOG_SPOOLSIZE / SCSI_LOG_BUFSIZE) > BITS_PER_LONG
> >>>>>> +#warning SCSI logging bitmask too large
> >>>>>> +#endif
> >>>>>> +
> >>>>>> +struct scsi_log_buf {
> >>>>>> +       char buffer[SCSI_LOG_SPOOLSIZE];
> >>>>>> +       unsigned long map;
> >>>>>> +};
> >>>>>> +
> >>>>>> +static DEFINE_PER_CPU(struct scsi_log_buf, scsi_format_log);
> >>>>>
> >>>>> Do we really need a static 4 KiB per-CPU buffer?
> >>>>>
> >>>>> bloat-o-meter:
> >>>>>
> >>>>> add/remove: 183/94 grow/shrink: 314/211 up/down: 33467/-21291 (12176)
> >>>>> function                                     old     new   delta
> >>>>> scsi_format_log                                -    4100   +4100
> >>>>> handle_mm_fault                             1794    2750    +956
> >>>>> scsi_log_print_sense_hdr                       -     774    +774
> >>>>> proc_keys_show                                 -     770    +770
> >>>>>
> >>>> Define 'need'.
> >>>> We don't absolutely 'need' it. (Configure it out and it's gone).
> >>>>
> >>>> But when we want to avoid several logging messages coming in from
> >>>> various CPUs overwriting each other and _not_ introduce additional
> >>>> latency by locking a single buffer, then yes.
> >>>>
> >>>> We can possibly reduce it to, say, 1KiB or even lower by imposing
> >>>> stricter rules on the logging functions.
> >>>> But I don't see a way around the per-CPU buffer.
> >>>
> >>> It seems very odd to introduce a mechanism like this specifically for
> >>> SCSI, rather than introducing a generic per-CPU buffered-print mechanism
> >>> in printk, controlled by a config option.  That option could then
> >>> automatically go away when !SMP, or !PRINTK, or if users don't actually
> >>> care about message ordering.
> >>>
> >> But then we ran afoul with the printk purists.
> >>
> >> Thing is, if we were to use per-CPU buffers for printk() out of
> >> necessity we have to queue these buffers for writing out.
> >> So there is a time window during which the message already is in the
> >> per-CPU buffer but still not printed out as printk() is currently
> >> writing out one of the other per-CPU buffers.
> >>
> >> If there is a consensus that such a delayed printk() is useful and a
> >> valid use case then yes, sure I can give it a go.
> >>
> >> Personally I think printk() currently has an unfortunate double
> >> purpose: on the one hand it should print out emergency messages
> >> immediate so that they'll be visible if the system crashes. On the
> >> other hand it is used as a general logging facility, where frankly
> >> most of the subsystems simple do not care at all if and when the
> >> message are printed.
> >> Splitting that off would indeed be a good idea, as then we can have
> >> the ultra-fast, go to console now printk() thingie, and another 'hey
> >> I don't care, just wanted to let you know something happened'
> >> delayed logging output.
> >>
> >> But I certainly will not attempt to implement this without a broader
> >> consensus. Typically patching printk is a good way of getting flamed.
> > 
> > I'm not suggesting that you change printk(); I'm just suggesting that
> > you drop the scsi_* prefixes from the buffered logging mechanism you've
> > already created, and make it a generic buffered logging mechanism that
> > other subsystems can use if desired.  More importantly, though, whether
> > you keep it SCSI-specific or not, please consider making it
> > configurable, dependent on SMP and PRINTK, and fall through to just
> > printk if configured out.
> > 
> Ah, right. _that_ is easy to accomplish.
> And sounds even as it would have a chance of succeeding.
> 
> I'll be updating the patch.

Thank you, that's *greatly* appreciated.

- Josh Triplett
