From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: Multiple invocations of scsi_scan_host() on a given host...
Date: Fri, 16 Apr 2004 14:44:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060EE65@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:50858 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S263811AbUDPVpK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 17:45:10 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI <linux-scsi@vger.kernel.org>


All,

Mid-last year, scsi_scan_host() was stripped from scsi_add_host() to
allow LLDs to decide whether or not to initiate a scan.  I recently
ran into a slight snag while attempting to call scsi_scan_host() more
than once for a given host, i.e. 1st invocation during initial probe
of hba0 (scsi_scan_host(hba0->host)), then a 2nd call
(scsi_scan_host(hba0->host)) during the probe function of a second
controller, hba1.

Looking through the code in scsi_scan.c, scsi_scan_host() calls
scsi_scan_host_selected() with the 'rescan' flag cleared (0).  With
the flag cleared, the check in scsi_probe_and_add_lun() to check for a
previously allocated device (via scsi_device_lookup()) is skipped, and
we run the risk of allocating duplicate devices (scsi_alloc_sdev())
hanging off a scsi_host during the 2nd invocation of scsi_scan_host().
Basically, scsi_sysfs_add_sdev() errors out:

	scsi: unknown device type 12
	   Vendor: COMPAQ    Model: MSA1000           Rev: 4.24
	   Type:   RAID                               ANSI SCSI revision: 04
	qla2300 0000:01:01.0: scsi(2:0:0:0): Enabled tagged queuing, queue depth 32.
	error 1

and during module unload, we get a panic:

	Unable to handle kernel NULL pointer dereference at virtual address 0000000c
	 printing eip:
	c01a114c
	*pde = 00000000
	Oops: 0000 [#1]
	SMP 
	CPU:    3
	EIP:    0060:[<c01a114c>]    Tainted: GF 
	EFLAGS: 00010282   (2.6.5-6-smp) 
	EIP is at sysfs_hash_and_remove+0xc/0x80
	eax: 00000000   ebx: f7e9be44   ecx: f9190000   edx: c0357d26
	esi: 00000000   edi: f91575e0   ebp: f9157644   esp: f44b9ec4
	ds: 007b   es: 007b   ss: 0068
	Process modprobe (pid: 7176, threadinfo=f44b8000 task=f7b9f8f0)
	Stack: f7e9be44 f7e9be3c c024730d f915762c f7e9be3c 00000246 f544fc00 00000000 
	       c0247338 f7e9bc00 f914474c f53dc000 00000246 f9142c30 f53dc000 f7fb4c44 
	       f906d724 f913d888 f53dc1e0 f903f168 f7fb4c00 f906d724 c0206718 f7fb4c44 
	Call Trace:
	 [<c024730d>] class_device_del+0xad/0xd0
	 [<c0247338>] class_device_unregister+0x8/0x10
	 [<f914474c>] scsi_remove_device+0x3c/0xa0 [scsi_mod]
	 [<f9142c30>] scsi_forget_host+0x40/0x70 [scsi_mod]
	 [<f913d888>] scsi_remove_host+0x18/0x40 [scsi_mod]
	 [<f903f168>] qla2x00_remove_one+0x68/0x90 [qla2xxx]
	 [<c0206718>] pci_device_remove+0x28/0x30
	 [<c0246856>] device_release_driver+0x56/0x60
	 [<c02468a8>] bus_remove_driver+0x48/0xa0
	 [<c0246c98>] driver_unregister+0x8/0x30
	 [<c02068bd>] pci_unregister_driver+0xd/0x70
	 [<c013e452>] sys_delete_module+0x132/0x1d0
	 [<c01091c9>] sysenter_past_esp+0x52/0x79

	Code: 8b 40 0c 8d 48 6c f0 ff 48 6c 0f 88 af 01 00 00 89 f0 e8 6d 
 
So, my questions are:

1) Is this simply a violation by the LLD of the calling requirement
for scsi_scan_host() -- given the function should *only* be called
once.  If that's the case, could we have that defined in
scsi_mid_low_api.txt (seems the latest doesn't mention the function).

2) If multiple invocations of scsi_scan_host() are allowed for a given
host, would a satisfactory fix be:

	@@ -1248,7 +1248,7 @@
	 void scsi_scan_host(struct Scsi_Host *shost)
	 {
		scsi_scan_host_selected(shost, SCAN_WILD_CARD, SCAN_WILD_CARD,
	-                               SCAN_WILD_CARD, 0);
	+                               SCAN_WILD_CARD, 1);
	 }
	 
	 void scsi_forget_host(struct Scsi_Host *shost)

(or better yet, removing the rescan flag and performing the duplicate
check all the time) which mimics the behaviour of the user-space
initiated wildcard device-scan via the sysfs 'scan' mechanism:

	# echo "- - -" > /sys/class/scsi_host/host2/scan

Thanks,
Andrew Vasquez
