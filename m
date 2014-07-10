From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq V2
Date: Thu, 10 Jul 2014 21:10:57 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B9742E@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
	<53BD9A24.7010203@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
	<20140710062040.GB20146@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
	<20140710160422.GA13728@infradead.org>
	<20140710161438.GA30792@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
 <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:12323 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGJVMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2014 17:12:10 -0400
In-Reply-To: <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Benjamin LaHaise <bcrl@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>



> -----Original Message-----
> From: Jeff Moyer [mailto:jmoyer@redhat.com]
> Sent: Thursday, 10 July, 2014 2:14 PM
> To: Elliott, Robert (Server Storage)
> Cc: Christoph Hellwig; Jens Axboe; dgilbert@interlog.com; James Bottomley;
> Bart Van Assche; Benjamin LaHaise; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
> 
> "Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:
> 
> >> -----Original Message-----
> >> From: Christoph Hellwig [mailto:hch@infradead.org]
> >> Sent: Thursday, 10 July, 2014 11:15 AM
> >> To: Elliott, Robert (Server Storage)
> >> Cc: Jens Axboe; dgilbert@interlog.com; James Bottomley; Bart Van Assche;
> >> Benjamin LaHaise; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> >> Subject: Re: scsi-mq V2
> >>
> >> On Thu, Jul 10, 2014 at 09:04:22AM -0700, Christoph Hellwig wrote:
> >> > It's starting to look weird.  I'll prepare another two bisect branches
> >> > around some MM changes, which seems the only other possible candidate.
> >>
> >> I've pushed out scsi-mq.3-bisect-3
> >
> > Good.
> >
> >> and scsi-mq.3-bisect-4 for you.
> >
> > Bad.
> >
> > Note: I had to apply the vdso2c.h patch to build this -rc3 based kernel:
> > diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
> > index df95a2f..11b65d4 100644
> > --- a/arch/x86/vdso/vdso2c.h
> > +++ b/arch/x86/vdso/vdso2c.h
> > @@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struct
> BITSFUNC(fake_sections) *out,
> > 	uint64_t flags = GET_LE(&in->sh_flags);
> >
> > 	bool copy = flags & SHF_ALLOC &&
> > +		(GET_LE(&in->sh_size) ||
> > +		(GET_LE(&in->sh_type) != SHT_RELA &&
> > +		GET_LE(&in->sh_type) != SHT_REL)) &&
> > 		strcmp(name, ".altinstructions") &&
> > 		strcmp(name, ".altinstr_replacement");
> >
> > Results: fio started OK, getting 900K IOPS, but ^C led to 0 IOPS and
> > an fio hang, with one CPU (CPU 0) stuck in io_submit loops.
> 

I added some prints in aio_setup_ring and  ioctx_alloc and
rebooted.  This time it took much longer to hit the problem.  It 
survived dozens of ^Cs.  Running a few minutes, though, IOPS 
eventually dropped.  So, sometimes it happens immediately,
sometimes it takes time to develop.

I will rerun bisect-1 -2 and -3 for longer times to increase
confidence that they didn't just appear good.

On this bisect-4 run, as IOPS started to drop from 900K to 40K, 
I ran perf top when it was at 700K.  You can see io_submit times
creeping up.

  4.30%  [kernel]            [k] do_io_submit
  4.29%  [kernel]            [k] _raw_spin_lock_irqsave
  3.88%  libaio.so.1.0.1     [.] io_submit
  3.55%  [kernel]            [k] system_call
  3.34%  [kernel]            [k] put_compound_page
  3.11%  [kernel]            [k] io_submit_one
  3.06%  [kernel]            [k] system_call_after_swapgs
  2.89%  [kernel]            [k] copy_user_generic_string
  2.45%  [kernel]            [k] lookup_ioctx
  2.16%  [kernel]            [k] apic_timer_interrupt
  2.00%  [kernel]            [k] _raw_spin_lock
  1.97%  [scsi_debug]        [k] sdebug_q_cmd_hrt_complete
  1.84%  [kernel]            [k] __get_page_tail
  1.74%  [kernel]            [k] do_blockdev_direct_IO
  1.68%  [kernel]            [k] blk_flush_plug_list
  1.41%  [kernel]            [k] _raw_spin_unlock_irqrestore
  1.24%  [scsi_debug]        [k] schedule_resp

finally settling like before:
 14.15%  [kernel]                    [k] do_io_submit
 13.61%  libaio.so.1.0.1             [.] io_submit
 11.81%  [kernel]                    [k] system_call
 10.11%  [kernel]                    [k] system_call_after_swapgs
  8.59%  [kernel]                    [k] io_submit_one
  8.56%  [kernel]                    [k] copy_user_generic_string
  7.96%  [kernel]                    [k] lookup_ioctx
  5.33%  [kernel]                    [k] blk_flush_plug_list
  3.11%  [kernel]                    [k] blk_finish_plug
  2.84%  [kernel]                    [k] sysret_check
  2.63%  fio                         [.] fio_libaio_commit
  2.27%  [kernel]                    [k] blk_start_plug
  1.17%  [kernel]                    [k] SyS_io_submit

