From: Randy Dunlap <rdunlap@xenotime.net>
Subject: aha152x_cs: non-functional + locking error
Date: Fri, 26 Jun 2009 12:27:34 -0700
Message-ID: <4A452126.7040003@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:44945 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751944AbZFZT1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jun 2009 15:27:36 -0400
Received: from ::ffff:98.108.130.97 ([98.108.130.97]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 26 Jun 2009 12:27:34 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: fischer@norbit.de

When I try to use aha152x_cs on any recent kernel, I get messages like

(scsi2:4:0) cannot abort running or disconnected command
(scsi2:4:0) cannot reset current device


so I enabled lots of debugging (in 2.6.30) and get (end of message log):

busy: unknown(seldo) SCSISEQ( ); SCSISIG(MESSAGE OUT); INTSTAT (lo); SSTAT( SELDO ); SSTAT( ); SXFRCTL0( CH1 ); SIGNAL( ATNI BSYI ); SELID (e7), STCNT (0), SSTAT2( SEMPTY ); SFCNT (0); SCSICNT (0), OFFCNT(0), SSTAT4( ); DMACNTRL0( 16BIT PIO READ INTEN ); DMASTAT( DFIFOEMP )
enabled interrupts ( ENPHASEMIS ENBUSFREE ENSCSIPERR )
(scsi2:4:0) (aha152x_abort:1111) locking
(scsi2:4:0) (aha152x_abort:1111) locked
(scsi2:4:0) (aha152x_abort:1129) unlocking (locked at aha152x_abort:1111)
(scsi2:4:0) (aha152x_abort:1129) unlocked
(scsi2:4:0) cannot abort running or disconnected command
(scsi2:4:0) aha152x_device_reset(dfa82a40)<7>(scsi2:4:0) (show_queues:2952) locking
(scsi2:4:0) (show_queues:2952) locked

queue status:
issue_SC:
(scsi2:4:0) (show_queues:2956) unlocking (locked at show_queues:2952)
(scsi2:4:0) (show_queues:2956) unlocked
current_SC:
scsi 2:0:4:0: dfa82a40: cmnd=(cdb[0]=0x12 12 00 00 00 24 00
); request_bufflen=36; resid=36; phase |syncneg|; next=0x(null)
disconnected_SC:

busy: unknown(seldo) SCSISEQ( ); SCSISIG(MESSAGE OUT); INTSTAT (lo); SSTAT( SELDO ); SSTAT( ); SXFRCTL0( CH1 ); SIGNAL( ATNI BSYI ); SELID (e7), STCNT (0), SSTAT2( SEMPTY ); SFCNT (0); SCSICNT (0), OFFCNT(0), SSTAT4( ); DMACNTRL0( 16BIT PIO READ INTEN ); DMASTAT( DFIFOEMP )
enabled interrupts ( ENPHASEMIS ENBUSFREE ENSCSIPERR )
(scsi2:4:0) cannot reset current device
(scsi2:4:0) (aha152x_bus_reset_host:1247) locking
(scsi2:4:0) (aha152x_bus_reset_host:1247) locked
scsi2: bus reset<7>(scsi2:4:0) (show_queues:2952) locking
BUG: spinlock trylock failure on UP on CPU#0, scsi_eh_2/7012
 lock: d6d97b94, .magic: dead4ead, .owner: scsi_eh_2/7012, .owner_cpu: 0
Pid: 7012, comm: scsi_eh_2 Not tainted 2.6.30 #7
Call Trace:
 [<c0439076>] ? printk+0xf/0x11
 [<c0210f02>] spin_bug+0x75/0x80
 [<c0210fad>] _raw_spin_trylock+0x36/0x3b
 [<c043b7b2>] _spin_lock_irqsave+0x29/0x55
 [<e1acfc7a>] ? show_queues+0xbe/0x35b [aha152x_cs]
 [<e1acfc7a>] show_queues+0xbe/0x35b [aha152x_cs]
 [<e1ad02ba>] aha152x_bus_reset_host+0x136/0x295 [aha152x_cs]
 [<e1ad048a>] aha152x_bus_reset+0xc/0xe [aha152x_cs]
 [<c02ba6cc>] scsi_try_bus_reset+0x25/0xa0
 [<c02bb251>] scsi_eh_ready_devs+0x2fa/0x4ad
 [<c02bb66a>] scsi_error_handler+0x1a7/0x32e
 [<c02bb4c3>] ? scsi_error_handler+0x0/0x32e
 [<c012c8a0>] kthread+0x42/0x67
 [<c012c85e>] ? kthread+0x0/0x67
 [<c0103053>] kernel_thread_helper+0x7/0x10
BUG: spinlock lockup on CPU#0, scsi_eh_2/7012, d6d97b94
Pid: 7012, comm: scsi_eh_2 Not tainted 2.6.30 #7
Call Trace:
 [<c0439076>] ? printk+0xf/0x11
 [<c0211073>] _raw_spin_lock+0xc1/0xe4
 [<c043b7ca>] _spin_lock_irqsave+0x41/0x55
 [<e1acfc7a>] show_queues+0xbe/0x35b [aha152x_cs]
 [<e1ad02ba>] aha152x_bus_reset_host+0x136/0x295 [aha152x_cs]
 [<e1ad048a>] aha152x_bus_reset+0xc/0xe [aha152x_cs]
 [<c02ba6cc>] scsi_try_bus_reset+0x25/0xa0
 [<c02bb251>] scsi_eh_ready_devs+0x2fa/0x4ad
 [<c02bb66a>] scsi_error_handler+0x1a7/0x32e
 [<c02bb4c3>] ? scsi_error_handler+0x0/0x32e
 [<c012c8a0>] kthread+0x42/0x67
 [<c012c85e>] ? kthread+0x0/0x67
 [<c0103053>] kernel_thread_helper+0x7/0x10




Does anyone successfully use aha152x_cs now?
If not, maybe it should just be removed from the kernel tree.

-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
