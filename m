From: "Alexandru N. Barloiu" <slak@dale.ro>
Subject: Re: Unknown problem with Adaptec Raid 2400A card
Date: 26 Jul 2003 14:20:56 +0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059218456.27155.49.camel@hammer.dale.ro>
References: <1059177564.7003.214.camel@hammer.dale.ro>
	 <1059177627.1206.19.camel@dhcp22.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from light.kappa.ro ([194.102.254.118]:52946 "EHLO mx.dale.ro")
	by vger.kernel.org with ESMTP id S272457AbTGZLGF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jul 2003 07:06:05 -0400
In-Reply-To: <1059177627.1206.19.camel@dhcp22.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-scsi@vger.kernel.org

So I tryed to recompile the same kernel, this time using modules. After
16 hours it happend again. here is the dump from kern.log.

Jul 26 14:07:44 orphan kernel: dpti0: Trying to Abort cmd=37640
Jul 26 14:07:44 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:07:44 orphan kernel: dpti0: Trying to Abort cmd=37643
Jul 26 14:07:44 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:07:44 orphan kernel: dpti0: Trying to Abort cmd=37644
Jul 26 14:07:44 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:07:44 orphan kernel: dpti0: Trying to Abort cmd=37659
Jul 26 14:07:44 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:07:44 orphan kernel: dpti0: Trying to Abort cmd=37739
Jul 26 14:07:44 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:07:44 orphan kernel: dpti0: Trying to reset device
Jul 26 14:07:44 orphan kernel: dpti0: Device reset not supported
Jul 26 14:07:44 orphan kernel: dpti0: Bus reset: SCSI Bus 0: tid: 11
Jul 26 14:07:44 orphan kernel: dpti0: Bus reset success.
Jul 26 14:07:59 orphan kernel: dpti0: Trying to Abort cmd=37640
Jul 26 14:07:59 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:07:59 orphan kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 1 channel 0 id 0 lun 0
Jul 26 14:08:09 orphan kernel: dpti0: Trying to Abort cmd=37643
Jul 26 14:08:09 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:08:09 orphan kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 1 channel 0 id 0 lun 0
Jul 26 14:08:19 orphan kernel: dpti0: Trying to Abort cmd=37644
Jul 26 14:08:19 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:08:19 orphan kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 1 channel 0 id 0 lun 0
Jul 26 14:08:29 orphan kernel: dpti0: Trying to Abort cmd=37659
Jul 26 14:08:30 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:08:30 orphan kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 1 channel 0 id 0 lun 0
Jul 26 14:08:40 orphan kernel: dpti0: Trying to Abort cmd=37739
Jul 26 14:08:40 orphan kernel: dpti0: Abort cmd not supported
Jul 26 14:08:40 orphan kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 1 channel 0 id 0 lun 0
Jul 26 14:08:40 orphan kernel:  I/O error: dev 08:00, sector 1523424808
Jul 26 14:08:40 orphan kernel: 0x0: f6 2e 03 40 06 2f 03 40 16 2f 03 40
26 2f 03 40 
Jul 26 14:08:40 orphan kernel: Filesystem "sd(8,0)": XFS internal error
xfs_da_do_buf(2) at line 2248 of file xfs_da_btree.c.  Caller 0xc026dbd7
Jul 26 14:08:40 orphan kernel: d7915ce4 c026d759 c0405bfa 00000001
dc629800 c0405b01 000008c8 c026dbd7 
Jul 26 14:08:40 orphan kernel:        c026dbd7 d7915d4c c029dcf5
dc762e40 0ba5f040 00000000 d8157ad8 d8157b00 
Jul 26 14:08:40 orphan kernel:        00000018 00000000 00000000
00000001 00000000 dc629800 d7915d68 00000001 
Jul 26 14:08:40 orphan kernel: Call Trace: [<c026d759>]  [<c026dbd7>] 
[<c026dbd7>]  [<c029dcf5>]  [<c026dbd7>]  [<c027196d>]  [<c027196d>] 
[<c03211af>]  [<c025f91f>]  [<c0270bf0>]  [<c0270b12>]  [<c0270bf0>] 
[<c0270351>]  [<c0270bf0>]  [<c02a6245>]  [<c02af370>]  [<c0225be0>] 
[<c0220b14>]  [<c0221340>]  [<c022150d>]  [<c0221340>]  [<c021fe32>] 
[<c022004d>]  [<c01d550f>] 
Jul 26 14:08:41 orphan kernel:  I/O error: dev 08:00, sector 1501503848
Jul 26 14:08:41 orphan kernel:  I/O error: dev 08:00, sector 1501504096

I guess that the xfs panic is normal considering that the device went
offline. What i am concerned about is hw falling. especially drives. i
should specify that i didn't use the default chunk size (128k) when i
made the array and used a much smaller size (32k) for improved speed.
Any other thoughts ? should i use v2.6 ? 2.4.21 ? could be hardware
related ?

On Sat, 2003-07-26 at 03:00, Alan Cox wrote:
> On Sad, 2003-07-26 at 00:59, Alexandru N. Barloiu wrote:
> > Here is the dump from kern.log about the disconect:
> > Jul 25 02:09:23 orphan kernel: dpti0: SCSI Timeout-Device (0,0,0) hba
> > status=0xa, dev status=0x0, cmd=0x28
> > Jul 25 02:09:52 orphan last message repeated 3 times
> 
> The card stopped responding
> 
> > Jul 25 02:10:32 orphan kernel: dpti0: Trying to reset device
> > Jul 25 02:10:32 orphan kernel: dpti0: Device reset not supported
> > Jul 25 02:10:32 orphan kernel: dpti0: Bus reset: SCSI Bus 0: tid: 11
> > Jul 25 02:10:32 orphan kernel: dpti0: Bus reset success.
> > Jul 25 02:10:47 orphan kernel: scsi: device set offline - not ready or
> > command retry failed after bus reset: host 0 channel 0 id 0 lun 0
> > Jul 25 02:11:17 orphan last message repeated 3 times
> 
> And has no reset method so we gave up. You could try using the core i2o
> code with it as that does support reset, but I'm not sure what to make
> of the fact it is timing out since its a smart controller
> 

