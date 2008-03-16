From: Giuseppe Sacco <giuseppe@eppesuigoccas.homedns.org>
Subject: Re: new kernel oops in recent kernels
Date: Sun, 16 Mar 2008 19:29:07 +0100
Message-ID: <1205692147.5470.3.camel@localhost>
References: <1205680748.3050.29.camel@localhost>
	 <20080316164223.GA26285@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host194-211-dynamic.20-79-r.retail.telecomitalia.it ([79.20.211.194]:57598
	"EHLO eppesuigoccas.homedns.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbYCPSeO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Mar 2008 14:34:14 -0400
Received: from router-wag54gp2 ([192.168.1.33] helo=[192.168.2.7])
	by eppesuigoccas.homedns.org with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <giuseppe@eppesuigoccas.homedns.org>)
	id 1JaxgO-0000gc-UG
	for linux-scsi@vger.kernel.org; Sun, 16 Mar 2008 19:34:11 +0100
In-Reply-To: <20080316164223.GA26285@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi all,

Il giorno dom, 16/03/2008 alle 10.42 -0600, Matthew Wilcox ha scritto:
> On Sun, Mar 16, 2008 at 04:19:08PM +0100, Giuseppe Sacco wrote:
[...]
> > Call Trace:
> > [<ffffffff802460b0>] sr_drive_status+0x50/0xe8
> > [<ffffffff8024bb84>] cdrom_ioctl+0x5f4/0x1208
> > [<ffffffff80245c6c>] sr_block_ioctl+0x64/0xe8
> 
> It would be interesting to see a disassembly (objdump -dr
> drivers/scsi/sr_ioctl.o) of sr_drive_status from say 0x40 to 0x60.

here it is:

(gdb) disassemble sr_drive_status+0x50
Dump of assembler code for function sr_drive_status:
0xffffffff80246060 <sr_drive_status+0>:	daddiu	sp,sp,-32
0xffffffff80246064 <sr_drive_status+4>:	lui	v0,0x7fff
0xffffffff80246068 <sr_drive_status+8>:	sd	s0,16(sp)
0xffffffff8024606c <sr_drive_status+12>:	sd	ra,24(sp)
0xffffffff80246070 <sr_drive_status+16>:	ori	v0,v0,0xffff
0xffffffff80246074 <sr_drive_status+20>:	move	s0,a0
0xffffffff80246078 <sr_drive_status+24>:	bne	a1,v0,0xffffffff802460e8 <sr_drive_status+136>
0xffffffff8024607c <sr_drive_status+28>:	ld	v1,24(a0)
0xffffffff80246080 <sr_drive_status+32>:	ld	a0,16(v1)
0xffffffff80246084 <sr_drive_status+36>:	jal	0xffffffff80244c70 <sr_test_unit_ready>
0xffffffff80246088 <sr_drive_status+40>:	daddiu	a1,sp,4
0xffffffff8024608c <sr_drive_status+44>:	bnez	v0,0xffffffff802460a8 <sr_drive_status+72>
0xffffffff80246090 <sr_drive_status+48>:	move	a0,s0
0xffffffff80246094 <sr_drive_status+52>:	li	v0,4
0xffffffff80246098 <sr_drive_status+56>:	ld	ra,24(sp)
0xffffffff8024609c <sr_drive_status+60>:	ld	s0,16(sp)
0xffffffff802460a0 <sr_drive_status+64>:	jr	ra
0xffffffff802460a4 <sr_drive_status+68>:	daddiu	sp,sp,32
0xffffffff802460a8 <sr_drive_status+72>:	jal	0xffffffff8024c838 <cdrom_get_media_event>
0xffffffff802460ac <sr_drive_status+76>:	move	a1,sp
0xffffffff802460b0 <sr_drive_status+80>:	bnez	v0,0xffffffff802460fc <sr_drive_status+156>
0xffffffff802460b4 <sr_drive_status+84>:	lhu	v0,0(sp)
0xffffffff802460b8 <sr_drive_status+88>:	sll	v0,v0,0x0
0xffffffff802460bc <sr_drive_status+92>:	andi	v0,v0,0xff
0xffffffff802460c0 <sr_drive_status+96>:	andi	v1,v0,0x2
0xffffffff802460c4 <sr_drive_status+100>:	bnez	v1,0xffffffff80246094 <sr_drive_status+52>
0xffffffff802460c8 <sr_drive_status+104>:	andi	v0,v0,0x1
0xffffffff802460cc <sr_drive_status+108>:	beqz	v0,0xffffffff80246098 <sr_drive_status+56>
0xffffffff802460d0 <sr_drive_status+112>:	li	v0,1
0xffffffff802460d4 <sr_drive_status+116>:	ld	ra,24(sp)

> And if that calls a function, it would be interesting to put in printks
> to figure out where we're dereferencing a null pointer.
> 

