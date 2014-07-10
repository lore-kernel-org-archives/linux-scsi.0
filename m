From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: scsi-mq V2
Date: Thu, 10 Jul 2014 18:49:55 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
 <20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
 <53BD9A24.7010203@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
 <20140710062040.GB20146@infradead.org>
 <94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
 <20140710160422.GA13728@infradead.org> <20140710161438.GA30792@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140710161438.GA30792@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Benjamin LaHaise <bcrl@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Thursday, 10 July, 2014 11:15 AM
> To: Elliott, Robert (Server Storage)
> Cc: Jens Axboe; dgilbert@interlog.com; James Bottomley; Bart Van Assche;
> Benjamin LaHaise; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: scsi-mq V2
> 
> On Thu, Jul 10, 2014 at 09:04:22AM -0700, Christoph Hellwig wrote:
> > It's starting to look weird.  I'll prepare another two bisect branches
> > around some MM changes, which seems the only other possible candidate.
> 
> I've pushed out scsi-mq.3-bisect-3 

Good.

> and scsi-mq.3-bisect-4 for you.

Bad.

Note: I had to apply the vdso2c.h patch to build this -rc3 based kernel:
diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
index df95a2f..11b65d4 100644
--- a/arch/x86/vdso/vdso2c.h
+++ b/arch/x86/vdso/vdso2c.h
@@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
	uint64_t flags = GET_LE(&in->sh_flags);

	bool copy = flags & SHF_ALLOC &&
+		(GET_LE(&in->sh_size) ||
+		(GET_LE(&in->sh_type) != SHT_RELA &&
+		GET_LE(&in->sh_type) != SHT_REL)) &&
		strcmp(name, ".altinstructions") &&
		strcmp(name, ".altinstr_replacement");

Results: fio started OK, getting 900K IOPS, but ^C led to 0 IOPS and
an fio hang, with one CPU (CPU 0) stuck in io_submit loops.

perf top shows lookup_ioctx function alongside io_submit and
do_io_submit this time:
 14.96%  [kernel]             [k] lookup_ioctx
 14.71%  libaio.so.1.0.1      [.] io_submit
 13.78%  [kernel]             [k] system_call
 10.79%  [kernel]             [k] system_call_after_swapgs
 10.17%  [kernel]             [k] do_io_submit
  8.91%  [kernel]             [k] copy_user_generic_string
  4.24%  [kernel]             [k] io_submit_one
  3.93%  [kernel]             [k] blk_flush_plug_list
  3.32%  fio                  [.] fio_libaio_commit
  2.84%  [kernel]             [k] sysret_check
  2.06%  [kernel]             [k] blk_finish_plug
  1.89%  [kernel]             [k] SyS_io_submit
  1.48%  [kernel]             [k] blk_start_plug
  1.04%  fio                  [.] io_submit@plt
  0.84%  [kernel]             [k] __get_user_4
  0.74%  [kernel]             [k] system_call_fastpath
  0.60%  [kernel]             [k] _copy_from_user
  0.51%  diff                 [.] 0x0000000000007abb

ftrace on CPU 0 shows similar repetition to before:
             fio-4107  [000] ....   389.992300: lookup_ioctx <-do_io_submit
             fio-4107  [000] ....   389.992300: blk_start_plug <-do_io_submit
             fio-4107  [000] ....   389.992300: io_submit_one <-do_io_submit
             fio-4107  [000] ....   389.992300: blk_finish_plug <-do_io_submit
             fio-4107  [000] ....   389.992300: blk_flush_plug_list <-blk_finish_plug
             fio-4107  [000] ....   389.992301: SyS_io_submit <-system_call_fastpath
             fio-4107  [000] ....   389.992301: do_io_submit <-SyS_io_submit
             fio-4107  [000] ....   389.992301: lookup_ioctx <-do_io_submit
             fio-4107  [000] ....   389.992301: blk_start_plug <-do_io_submit
             fio-4107  [000] ....   389.992301: io_submit_one <-do_io_submit
             fio-4107  [000] ....   389.992301: blk_finish_plug <-do_io_submit
             fio-4107  [000] ....   389.992301: blk_flush_plug_list <-blk_finish_plug
             fio-4107  [000] ....   389.992301: SyS_io_submit <-system_call_fastpath
             fio-4107  [000] ....   389.992302: do_io_submit <-SyS_io_submit
             fio-4107  [000] ....   389.992302: lookup_ioctx <-do_io_submit
             fio-4107  [000] ....   389.992302: blk_start_plug <-do_io_submit
             fio-4107  [000] ....   389.992302: io_submit_one <-do_io_submit
             fio-4107  [000] ....   389.992302: blk_finish_plug <-do_io_submit
             fio-4107  [000] ....   389.992302: blk_flush_plug_list <-blk_finish_plug
