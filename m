From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] instrument ide-scsi in 2.5.68
Date: Tue, 6 May 2003 07:39:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030506073923.210a82ff.rddunlap@osdl.org>
References: <3EB11AD3.2070503@torque.net>
	<3EB22F09.7060906@torque.net>
	<20030502095536.76dba4dd.rddunlap@osdl.org>
	<3EB385F3.6010708@torque.net>
	<20030505095715.6d96e703.rddunlap@osdl.org>
	<3EB7748F.2030702@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from air-2.osdl.org ([65.172.181.6]:42905 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261279AbTEFO3x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 May 2003 10:29:53 -0400
In-Reply-To: <3EB7748F.2030702@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, alan@lxorguk.ukuu.org.uk

On Tue, 06 May 2003 18:38:39 +1000 Douglas Gilbert <dougg@torque.net> wrote:

| > New kernel log file is now at
| >   http://www.xenotime.net/linux/capture2.txt
| > 
| > Are there any docs on SCSI logging?
| 
| Randy,
| The failure looks very similar. This time it timed
| out and corrupted on a Mode Sense (10) for page 5
| (alloc length=2) while last time its failed on a
| Mode Sense (10) for page 0x2a (alloc length=2).
| The Mode Sense is not translated (i.e. the app sent a
| 10 byte Mode Sense). Perhaps there is a weakness
| when the allocation length is that short.
| 
| This time 141 commands where sent (last time 91)
| with lots of Test Unit Readys. Without timestamps
| it is hard to say whether a "magicdev" type program
| is at work or libscg (cdrecord transport layer) is
| solely responsible for that sequence of SCSI commands.
| [cdrecord may be accessing the cdwriter via the cdrom
| driver and the sg driver.]

Well, I saw no scsi logging messages except when I ran
cdrecord.  Does that help any?

| Here is the point of failure from Randy's log:
| 
| ide-scsi: hdd: que 141, cmd = [ 5a 0 5 0 0 0 0 0 2 0 ]
| hdd: lost interrupt
| ide-scsi: Reached idescsi_pc_intr interrupt handler
| ide-scsi: hdd: DMA complete
| ide-scsi: CoD != 0 in idescsi_pc_intr
| hdd: DMA disabled
| Error handler scsi_eh_2 waking up
| scsi_eh_<pr4>t_hfdadi: lA_TstAaPIts r: e2se:t0: 0co:m0 plcmetdse
| failiedde:- sc0s,i :c anRecaeclh: ed1
| idTeosctsali_ pofc_ 1in ctro mminantdersr oupnt 1  hdanedvliceres
|   rePaqcuikrete  ceho mmwoanrdk
| ....
| 
| Ouch, after the error handler starts the dump looks like it
| is in Klingon :-) Lots of data but no information. It could
| be a result of the corruption or another problem.

I think (but I'm not sure) that this is because it's a dual-proc
system and both procs are garbling the message log.  Later on during
a panic(), all procs except the current one are disabled, but for
early messages, all procs can lead to this.  I've seen this on 2
other occasions (non-scsi).

--
~Randy
