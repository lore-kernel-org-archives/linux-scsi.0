From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: regression w/ qla2300 - oopses..
Date: Fri, 26 Aug 2005 16:44:07 -0500
Message-ID: <1125092648.5079.110.camel@mulgrave>
References: <20050826212934.GO22165@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15337 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965172AbVHZVoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 17:44:12 -0400
In-Reply-To: <20050826212934.GO22165@mea-ext.zmailer.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Greg KH <greg@kroah.com>

On Sat, 2005-08-27 at 00:29 +0300, Matti Aarnio wrote:
> Well, not in normal operation, but when I do "rmmod qla2300",
> I do get most impressive oops backtrace.  (With Amd64 machine.)
[...]
> Aug 26 10:40:14 sisakko kernel: general protection fault: 0000 [1] SMP 
> Aug 26 10:40:14 sisakko kernel: CPU 0 
> Aug 26 10:40:14 sisakko kernel: Modules linked in: lp w83627hf i2c_sensor i2c_isa sunrpc ipv6 ipt_conntrack ip_conntrack_ftp ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables xfs exportfs dm_mod video button battery ac uhci_hcd ehci_hcd sata_via libata parport_pc parport shpchp i2c_viapro i2c_core snd_via82xx gameport snd_ac97_codec snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore e100 mii skge floppy ext3 jbd raid1 qla2300 qla2xxx scsi_transport_fc sd_mod scsi_mod
> Aug 26 10:40:14 sisakko kernel: Pid: 19819, comm: rmmod Not tainted 2.6.12-1.1509_FC5
> Aug 26 10:40:14 sisakko kernel: RIP: 0010:[<ffffffff8020034b>] <ffffffff8020034b>{kref_get+4}
> Aug 26 10:40:14 sisakko kernel: RSP: 0018:ffff810031459d28  EFLAGS: 00010203
> Aug 26 10:40:14 sisakko kernel: RAX: ffff81003f5d35d0 RBX: 6b6b6b6b6b6b6b7b RCX: 0000000000000000
> Aug 26 10:40:14 sisakko kernel: RDX: 0000000000000007 RSI: ffffffff8034b06d RDI: 6b6b6b6b6b6b6b7b
> Aug 26 10:40:14 sisakko kernel: RBP: ffff810031459d58 R08: 0000000000000000 R09: ffff81003f5d3160
> Aug 26 10:40:14 sisakko kernel: R10: 0000000000000000 R11: ffffffff88009ed6 R12: 6b6b6b6b6b6b6b63
> Aug 26 10:40:14 sisakko kernel: R13: 0000000000000000 R14: ffffffff88060a78 R15: ffffffff88060a80
> Aug 26 10:40:14 sisakko kernel: FS:  00002aaaaadfe6d0(0000) GS:ffffffff80529800(0000) knlGS:00000000f7ea2ba0
> Aug 26 10:40:14 sisakko kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> Aug 26 10:40:14 sisakko kernel: CR2: 0000555555661200 CR3: 0000000034e55000 CR4: 00000000000006e0
> Aug 26 10:40:14 sisakko kernel: Process rmmod (pid: 19819, threadinfo ffff810031458000, task ffff8100330ca030)
> Aug 26 10:40:14 sisakko kernel: Stack: 6b6b6b6b6b6b6b6b ffffffff8034b1c4 0000000000000000 ffff81003f5d35c8 
> Aug 26 10:40:14 sisakko kernel:        ffffffff8800b631 ffffffff8026bae1 ffff81003f5d35c8 ffff81003f5d35d0 
> Aug 26 10:40:14 sisakko kernel:        ffff81003f5d31a0 ffff81003f5d35c8 
> Aug 26 10:40:14 sisakko kernel: Call Trace:<ffffffff8034b1c4>{klist_next+69} <ffffffff8800b631>{:scsi_mod:__remove_child+0}
> Aug 26 10:40:14 sisakko kernel:        <ffffffff8026bae1>{device_for_each_child+44} <ffffffff8800b688>{:scsi_mod:scsi_remove_target+61}
> Aug 26 10:40:14 sisakko kernel:        <ffffffff8803498b>{:scsi_transport_fc:fc_rport_terminate+63}
> Aug 26 10:40:14 sisakko kernel:        <ffffffff88034a51>{:scsi_transport_fc:fc_remove_host+52}

This is known and fixed here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=112485448830217

Andrew and Greg, could we look at actually getting this fix in too,
please?

Thanks,

James


