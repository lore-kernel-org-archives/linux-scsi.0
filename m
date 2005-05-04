From: James.Smart@Emulex.Com
Subject: RE: LPFC issue with 2.6.12-rc3-git
Date: Wed, 4 May 2005 09:40:52 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20629C9@xbl3.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:38314 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261820AbVEDNk6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2005 09:40:58 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anton@samba.org
Cc: linux-scsi@vger.kernel.org

Anton,

Thanks. Interesting traces.  We'll take a look at it.

-- james s


> -----Original Message-----
> From: Anton Blanchard [mailto:anton@samba.org]
> Sent: Wednesday, May 04, 2005 2:00 AM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: LPFC issue with 2.6.12-rc3-git
> 
> 
> 
> Hi James,
> 
> I tried a latest git build and managed to wedge lpfc. This is 
> a ppc64 box,
> and the cable was unplugged and replugged. Looks like we are 
> stuck waiting
> for a scsi timeout and the other two threads are blocking on 
> it. I waited
> 15 minutes to make sure it wouldnt clear itself.
> 
> Anton
> 
> scsi_wq_3     D 0000000000000000 11984   866      6           
> 878   864 (L-TLB)
> Call Trace:
> [c0000000000120f0] .__switch_to+0xd0/0x160
> [c00000000043a6a8] .schedule+0x488/0xe50
> [c00000000043b638] .wait_for_completion+0xc8/0x150
> [c0000000002efd60] .scsi_wait_req+0x90/0x100
> [c0000000002f2ddc] .scsi_probe_and_add_lun+0x23c/0xa50
> [c0000000002f3d04] .scsi_scan_target+0x164/0x540
> [c0000000002fb5fc] .fc_scsi_scan_rport+0x2c/0x40
> [c00000000006d354] .worker_thread+0x224/0x320
> [c000000000074588] .kthread+0x178/0x190
> [c000000000014988] .kernel_thread+0x4c/0x6c
> 
> lpfc_worker_1 D 0000000000000000 11552   864      6           
> 866   705 (L-TLB)
> Call Trace:
> [c0000000000120f0] .__switch_to+0xd0/0x160
> [c00000000043a6a8] .schedule+0x488/0xe50
> [c00000000006db84] .flush_cpu_workqueue+0xc4/0x2a0
> [c0000000002ea91c] .scsi_flush_work+0x2c/0x80
> [c0000000002fd458] .fc_rport_tgt_remove+0xd8/0x110
> [c0000000002fd4e0] .fc_rport_terminate+0x50/0xf0
> [d00000000008673c] .lpfc_nlp_remove+0x40c/0x450 [lpfc]
> [d000000000090050] .lpfc_disc_state_machine+0x1c0/0x1d0 [lpfc]
> [d000000000089710] .lpfc_do_work+0x620/0xc00 [lpfc]
> [c000000000074588] .kthread+0x178/0x190
> [c000000000014988] .kernel_thread+0x4c/0x6c
> 
> rmmod         D 000000000ff50640 10368  4127   4071           
>           (NOTLB)
> Call Trace:
> [c0000000000120f0] .__switch_to+0xd0/0x160
> [c00000000043a6a8] .schedule+0x488/0xe50
> [c00000000006db84] .flush_cpu_workqueue+0xc4/0x2a0
> [c0000000002ea91c] .scsi_flush_work+0x2c/0x80
> [c0000000002fd458] .fc_rport_tgt_remove+0xd8/0x110
> [c0000000002fd4e0] .fc_rport_terminate+0x50/0xf0
> [c0000000002fd5c4] .fc_remove_host+0x44/0xd0
> [d00000000008a650] .lpfc_pci_remove_one+0x90/0x2e0 [lpfc]
> [c0000000001e87f0] .pci_device_remove+0x50/0x80
> [c00000000025c194] .device_release_driver+0xa4/0xd0
> [c00000000025c53c] .bus_remove_driver+0xcc/0x180
> [c00000000025d038] .driver_unregister+0x18/0x40
> [c0000000001e8620] .pci_unregister_driver+0x30/0xd0
> [d0000000000968ec] .lpfc_exit+0x1c/0x2450 [lpfc]
> [c00000000007e1c0] .sys_delete_module+0x240/0x330
> [c00000000000d800] syscall_exit+0x0/0x18
> 
