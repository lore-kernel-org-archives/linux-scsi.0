From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Mon, 17 Nov 2003 23:42:59 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311172331410.2258-100000@poirot.grange>
References: <20031117134140.169587af.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:56246 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261784AbTKQWoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 17:44:16 -0500
In-Reply-To: <20031117134140.169587af.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, hch@infradead.org, linux-scsi@vger.kernel.org, garloff@suse.de, gl@dsa-ac.de

On Mon, 17 Nov 2003, Randy.Dunlap wrote:

> On Mon, 17 Nov 2003 01:03:17 +0100 (CET) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>
> | sd_revalidate_disk() sr_data_direction is initialised by
> | scsi_allocate_request() to DMA_BIDIRECTIONAL:
> |                 sreq->sr_data_direction = DMA_BIDIRECTIONAL;
> | , but already in sd_spinup_disk() it is reset to DMA_NONE:
> |                         SRpnt->sr_data_direction = DMA_NONE;
>
> Doing a TEST_UNIT_READY doesn't require any DMA transfers, in the
> sense of buffers (i.e., buffer length is 0), so DMA_NONE makes sense,
> doesn't it?

Ok, thanks, so, that case (bufflen == 0) should be handled properly, will
double-check. But the problem seems to be occurring much earlier - see
below.

> | I haven't found yet how sr_data_direction gets copied to sc_data_direction
> | (so far it only looks like struct scsi_cmnd is just overlayd on struct
> | scsi_request, but I may be wrong there... Or is it really so?
>
> scsi.c::scsi_init_cmd_from_req(), line 504 in 2.6.0-test9 (?),
> although I haven't followed the code flow all the way from tmscsim
> to that function.

Yep, found that one already, thanks. Also found where scsi_request is
replaced with scsi_cmnd in request->special - in scsi_prep_fn() in
scsi_lib.c.

> PS:  I prefer this on linux-scsi instead of linux-kernel.

Well, if you're referring to my last post... - ok, will keep it at
linux-scsi.

So, already the very first command produces a wrong (or no) result:

DC390(0): IO_PORT=7100,IRQ=b
DC390_init: No EEPROM found! Trying default settings ...
DC390: Used defaults: AdaptID=7, SpeedIdx=0 (10.0 MHz), DevMode=0x1f,
AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
Wake up parent of scsi_eh_0
Error handler scsi_eh_0 sleeping
DC390: pSH = c14ec000, Index 00
DC390: Adapter index 0, ID 7, IO 0x00007100, IRQ 0x0b
DC390: pACB = c14ec204, pDCBmap = c14ec240, pSRB_array = c14ec2ec
DC390: ACB size= 1088, DCB size=   30, SRB size=   50
DC390: 1 adapters found
scsi0 : Tekram DC390/AM53C974 V2.0f 2000-12-20
scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
DC390: Queue Cmd=12,Tgt=0,LUN=0 (pid=0), direction=2
DC390: Get Free SRB c14ec2ec
DC390: Free SRB w/o Waiting
DC390: We were just reset and don't accept commands yet!
DC390: Insert pSRB c14ec2ec cmd 0 to Waiting
DC390: Debug: Waiting queue woken up by timer!
DC390: Remove SRB c14ec2ec from head of Waiting
DC390: Append SRB c14ec2ec to Going
DISC, SRBdone (00,00000000), SRB c14ec2ec, pid 0
DC390: INQUIRY: result: 00000000
DC390: Remove SRB c14ec2ec from Going
DC390: Free SRB c14ec2ec
scsi_delete_timer: scmd: c14c8ea8, rtn: 1
  Vendor:           Model:                   Rev:
  Type:   Direct-Access                      ANSI SCSI revision: 00

Whereas the 2.4 version fills in correct data for the drive. Any ideas
would be appreciated.

Thanks
Guennadi
---
Guennadi Liakhovetski


