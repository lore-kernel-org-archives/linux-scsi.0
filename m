From: "Elliott, Robert (Server Storage)" <Elliott-VXdhtT5mjnY@public.gmane.org>
Subject: RE: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Wed, 5 Nov 2014 04:57:43 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295937104F@G4W3202.americas.hpqcorp.net>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org>
 <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org>
 <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il>
 <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il>
 <54524D08.4040203@acm.org> <545253E3.7000009@dev.mellanox.co.il>
 <545256E5.9010501@acm.org> <5452765E.1040604@dev.mellanox.co.il>
 <5453541D.7040206@acm.org> <54562B9C.3040004@dev.mellanox.co.il>
 <94D0CD8314A33A4D9D801C0FE68B402959354E19@G9W0745.americas.hpqcorp.net>
 <5458BC8B.40202@acm.org> <5458C344.2040109@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5458C344.2040109-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]
> Sent: Tuesday, November 04, 2014 6:15 AM
> To: Bart Van Assche; Elliott, Robert (Server Storage); Christoph Hellwig
> Cc: Jens Axboe; Sagi Grimberg; Sebastian Parschauer; Ming Lei; linux-
> scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma
> Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
> 
...
> I think that Rob and I are not talking about the same issue. In
> case only a single core is servicing interrupts it is indeed expected
> that it will spend 100% in hard-irq, that's acceptable since it is
> pounded with completions all the time.
> 
> However, I'm referring to a condition where SRP will spend infinite
> time servicing a single interrupt (while loop on ib_poll_cq that never
> drains) which will lead to a hard lockup.
> 
> This *can* happen, and I do believe that with an optimized IO path
> it is even more likely to.

If the IB completions/interrupts are only for IOs submitted on this
CPU, then the CQ will eventually drain, because this CPU is not 
submitting anything new while stuck in the loop.

This can become bursty, though - submit a lot of IOs, then be busy
completing all of them and not submitting more, resulting in the 
queue depth bouncing from 0 to high to 0 to high.  I've seen
that with both hpsa and mpt3sas drivers.  The fio options
iodepth_batch, iodepth_batch_complete, and iodepth_low
can amplify and reduce that effect (using libaio).

I haven't found a good way for the LLD ISRs and the block
layer completion code to decide to yield the CPU based on how
much time they are taking - that would almost qualify as
a realtime kernel feature.  If you compile with
CONFIG_IRQ_TIME_ACCOUNTING, the kernel does keep track
of that information; perhaps that could be exported so
modules can use it?

---
Rob Elliott, HP Server Storage

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
