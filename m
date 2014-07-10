From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: scsi-mq V2
Date: Thu, 10 Jul 2014 15:14:29 -0400
Message-ID: <x497g3l10x6.fsf@segfault.boston.devel.redhat.com>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
	<20140708144829.GA5539@infradead.org> <53BD7041.5010300@interlog.com>
	<53BD9A24.7010203@kernel.dk>
	<94D0CD8314A33A4D9D801C0FE68B402958B9628B@G9W0745.americas.hpqcorp.net>
	<20140710062040.GB20146@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B96E3B@G9W0745.americas.hpqcorp.net>
	<20140710160422.GA13728@infradead.org>
	<20140710161438.GA30792@infradead.org>
	<94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B971BB@G9W0745.americas.hpqcorp.net>
	(Robert Elliott's message of "Thu, 10 Jul 2014 18:49:55 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, "dgilbert@interlog.com" <dgilbert@interlog.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Bart Van Assche <bvanassche@fusionio.com>, Benjamin LaHaise <bcrl@kvack.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

"Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:

>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch@infradead.org]
>> Sent: Thursday, 10 July, 2014 11:15 AM
>> To: Elliott, Robert (Server Storage)
>> Cc: Jens Axboe; dgilbert@interlog.com; James Bottomley; Bart Van Assche;
>> Benjamin LaHaise; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: scsi-mq V2
>> 
>> On Thu, Jul 10, 2014 at 09:04:22AM -0700, Christoph Hellwig wrote:
>> > It's starting to look weird.  I'll prepare another two bisect branches
>> > around some MM changes, which seems the only other possible candidate.
>> 
>> I've pushed out scsi-mq.3-bisect-3 
>
> Good.
>
>> and scsi-mq.3-bisect-4 for you.
>
> Bad.
>
> Note: I had to apply the vdso2c.h patch to build this -rc3 based kernel:
> diff --git a/arch/x86/vdso/vdso2c.h b/arch/x86/vdso/vdso2c.h
> index df95a2f..11b65d4 100644
> --- a/arch/x86/vdso/vdso2c.h
> +++ b/arch/x86/vdso/vdso2c.h
> @@ -93,6 +93,9 @@ static void BITSFUNC(copy_section)(struct BITSFUNC(fake_sections) *out,
> 	uint64_t flags = GET_LE(&in->sh_flags);
>
> 	bool copy = flags & SHF_ALLOC &&
> +		(GET_LE(&in->sh_size) ||
> +		(GET_LE(&in->sh_type) != SHT_RELA &&
> +		GET_LE(&in->sh_type) != SHT_REL)) &&
> 		strcmp(name, ".altinstructions") &&
> 		strcmp(name, ".altinstr_replacement");
>
> Results: fio started OK, getting 900K IOPS, but ^C led to 0 IOPS and
> an fio hang, with one CPU (CPU 0) stuck in io_submit loops.

Hi, Rob,

Can you get sysrq-t output for me?  I don't know how/why we'd continue
to get io_submits for an exiting process.

Thanks,
Jeff
