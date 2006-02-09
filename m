From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: 2.6.16-rc2 OOPS in scsi_device_get() via scsi_error_handler() during boot
Date: Thu, 9 Feb 2006 08:50:35 -0800
Message-ID: <20060209165035.GE446@andrew-vasquezs-powerbook-g4-15.local>
References: <43E8E020.6070700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:64307 "EHLO avexch02.qlogic.com")
	by vger.kernel.org with ESMTP id S1422883AbWBIQul (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2006 11:50:41 -0500
Content-Disposition: inline
In-Reply-To: <43E8E020.6070700@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Michael Reed <mdr@sgi.com>


I am also seeing what appears to be double-removal of scsi-devices
during rport tear-down after TMO.  Configuration is 4 initiator ports
connected to a 15 disc JBOD via a switch.

<start I/O>
<disable switch>
	[ 1683.833707] scsi(6): Asynchronous LOOP DOWN (2).
	[ 1683.838369] scsi(6:0:0): status_entry: Port Down pid=4794, compl status=0x28, port state=0x3
	...

<drop rport references>
	...

<TMO expires>
	[ 1718.769498]  rport-6:0-0: blocked FC remote port time out: removing target and saving binding
	[ 1718.778020]  rport-6:0-1: blocked FC remote port time out: removing target and saving binding
	[ 1718.786537]  rport-6:0-2: blocked FC remote port time out: removing target and saving binding
	[ 1718.786551]  rport-6:0-3: blocked FC remote port time out: removing target and saving binding
	[ 1718.786558]rror: return code = 0x10000
	[ 1718.811619] end_request: I/O error, dev sdb, sector 13544
	...

<streams of expected I/O failures>
	[ 1722.144641] end_request: I/O error, dev sdk, sector 16384
	[ 1722.144655] sd 6:0:9:0: rejecting I/O to device being removed
	[ 1722.144679] end_request: I/O error, dev sdk, sector 16384
	[ 1722.144691] sd 6:0:9:0: rejecting I/O to device being removed
	[ 1722.144717] end_request: I/O error, dev sdk, sector 18432
	[ 1722.144730] sd 6:0:9:0: rejecting I/O to device being removed
	...

<some badness>
	[ 1722.145924] sd 6:0:9:0: rejecting I/O to device being removed
	[ 1722.388418] VFS: brelse: Trying to free free buffer
	[ 1722.388430] Badness in __brelse at fs/buffer.c:1275
	[ 1722.388534]  [<c014fb04>] invalidate_bh_lru+0x27/0x38
	[ 1722.388551]  [<c014fadd>] invalidate_bh_lru+0x0/0x38
	[ 1722.388558]  [<c010c5c4>] smp_call_function_interrupt+0x39/0x55
	[ 1722.388570]  [<c01031a0>] call_function_interrupt+0x1c/0x24
	[ 1722.388578]  [<c014f7bc>] __brelse+0xf/0x3d
	[ 1722.388585]  [<c014fb04>] invalidate_bh_lru+0x27/0x38
	[ 1722.388591]  [<c014fb2f>] invalidate_bh_lrus+0x1a/0x1c
	[ 1722.388597]  [<c014eddc>] invalidate_bdev+0xa/0x1d
	[ 1722.388603]  [<c0162de4>] __invalidate_device+0x35/0x3d
	[ 1722.388613]  [<c01d3e5f>] invalidate_partition+0x2d/0x3d
	[ 1722.388623]  [<c017a7f5>] del_gendisk+0x15/0xe0
	[ 1722.388630]  [<c0284f67>] sd_remove+0x17/0x4f
	[ 1722.388639]  [<c0224c39>] __device_release_driver+0x6c/0x87
	[ 1722.388648]  [<c0224c7a>] device_release_driver+0x26/0x36
	[ 1722.388654]  [<c0224497>] bus_remove_device+0x55/0x68
	[ 1722.388659]  [<c02236a2>] device_del+0x3c/0x6b
	[ 1722.388666]  [<c0259cbd>] __scsi_remove_device+0x32/0x65
	[ 1722.388675]  [<c0259d08>] scsi_remove_device+0x18/0x22
	[ 1722.388681]  [<c0259db6>] __scsi_remove_target+0xa4/0xb1
	[ 1722.388691]  [<c0259dc3>] __remove_child+0x0/0x1e
	[ 1722.388697]  [<c0259ddc>] __remove_child+0x19/0x1e
	[ 1722.388703]  [<c0223721>] device_for_each_child+0x23/0x4a
	[ 1722.388709]  [<c0259e15>] scsi_remove_target+0x34/0x42
	[ 1722.388715]  [<c0259dc3>] __remove_child+0x0/0x1e
	[ 1722.388721]  [<f8835883>] fc_shost_remove_rports+0x68/0xa9 [scsi_transport_fc]
	[ 1722.388735]  [<c0126d1c>] run_workqueue+0x83/0xc1
	[ 1722.388742]  [<f883581b>] fc_shost_remove_rports+0x0/0xa9 [scsi_transport_fc]
	[ 1722.388752]  [<c0126ea3>] flush_cpu_workqueue+0x1f/0xb2
	[ 1722.388758]  [<c0126f2e>] flush_cpu_workqueue+0xaa/0xb2
	[ 1722.388764]  [<c0129f4a>] autoremove_wake_function+0x0/0x3a
	[ 1722.388773]  [<c02e8feb>] _spin_lock_irqsave+0xa/0xf
	[ 1722.388780]  [<c0129f4a>] autoremove_wake_function+0x0/0x3a
	[ 1722.388787]  [<c02e909c>] _spin_unlock_irqrestore+0x9/0xe
	[ 1722.388793]  [<c0126f65>] flush_workqueue+0x2f/0x8b
	[ 1722.388799]  [<f8834e49>] fc_rport_tgt_remove+0x60/0x6d [scsi_transport_fc]
	[ 1722.388810]  [<f8835883>] fc_shost_remove_rports+0x68/0xa9 [scsi_transport_fc]
	[ 1722.388820]  [<c0126d1c>] run_workqueue+0x83/0xc1
	[ 1722.388825]  [<f883581b>] fc_shost_remove_rports+0x0/0xa9 [scsi_transport_fc]
	[ 1722.388835]  [<c0126e51>] worker_thread+0xf7/0x12a
	[ 1722.388841]  [<c0114922>] default_wake_function+0x0/0x12
	[ 1722.388851]  [<c0114922>] default_wake_function+0x0/0x12
	[ 1722.388858]  [<c0126d5a>] worker_thread+0x0/0x12a
	[ 1722.388863]  [<c0129ad3>] kthread+0x7c/0xa6
	[ 1722.388869]  [<c0129a57>] kthread+0x0/0xa6
	[ 1722.388875]  [<c0100ed1>] kernel_thread_helper+0x5/0xb
	[ 1722.430316] sd 6:0:9:0: rejecting I/O to device being removed
	[ 1722.461495] sd 6:0:9:0: rejecting I/O to device being removed

This is with the latest linux-2.6.git tree and scsi-rc-fixes-2.6.git
tree merged.


--
av
