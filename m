From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Mon, 17 Nov 2003 15:14:31 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117151431.76083f58.rddunlap@osdl.org>
References: <20031117134140.169587af.rddunlap@osdl.org>
	<Pine.LNX.4.44.0311172331410.2258-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:31127 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262052AbTKQXUM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 18:20:12 -0500
In-Reply-To: <Pine.LNX.4.44.0311172331410.2258-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, garloff@suse.de, gl@dsa-ac.de

On Mon, 17 Nov 2003 23:42:59 +0100 (CET) Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:

| Ok, thanks, so, that case (bufflen == 0) should be handled properly, will
| double-check. But the problem seems to be occurring much earlier - see
| below.
| 
...
| 
| > PS:  I prefer this on linux-scsi instead of linux-kernel.
| 
| Well, if you're referring to my last post... - ok, will keep it at
| linux-scsi.
| 
| So, already the very first command produces a wrong (or no) result:
| 
| DC390(0): IO_PORT=7100,IRQ=b
| DC390_init: No EEPROM found! Trying default settings ...
| DC390: Used defaults: AdaptID=7, SpeedIdx=0 (10.0 MHz), DevMode=0x1f,
| AdaptMode=0x0f, TaggedCmnds=3 (16), DelayReset=1s
| Wake up parent of scsi_eh_0
| Error handler scsi_eh_0 sleeping
| DC390: pSH = c14ec000, Index 00
| DC390: Adapter index 0, ID 7, IO 0x00007100, IRQ 0x0b
| DC390: pACB = c14ec204, pDCBmap = c14ec240, pSRB_array = c14ec2ec
| DC390: ACB size= 1088, DCB size=   30, SRB size=   50
| DC390: 1 adapters found
| scsi0 : Tekram DC390/AM53C974 V2.0f 2000-12-20
| scsi_add_timer: scmd: c14c8ea8, time: 6000, (c02421c8)
| DC390: Queue Cmd=12,Tgt=0,LUN=0 (pid=0), direction=2
| DC390: Get Free SRB c14ec2ec
| DC390: Free SRB w/o Waiting
| DC390: We were just reset and don't accept commands yet!
| DC390: Insert pSRB c14ec2ec cmd 0 to Waiting
| DC390: Debug: Waiting queue woken up by timer!

Does this say that the IO timed out (timer expired)?
I.e., the IO isn't happening?

Have you posted your current patches?  Maybe someone could see
what needs to be changed...

| DC390: Remove SRB c14ec2ec from head of Waiting
| DC390: Append SRB c14ec2ec to Going
| DISC, SRBdone (00,00000000), SRB c14ec2ec, pid 0
| DC390: INQUIRY: result: 00000000
| DC390: Remove SRB c14ec2ec from Going
| DC390: Free SRB c14ec2ec
| scsi_delete_timer: scmd: c14c8ea8, rtn: 1
|   Vendor:           Model:                   Rev:
|   Type:   Direct-Access                      ANSI SCSI revision: 00
| 
| Whereas the 2.4 version fills in correct data for the drive. Any ideas
| would be appreciated.


--
~Randy
MOTD:  Always include version info.
