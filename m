From: Omar Sandoval <osandov@osandov.com>
Subject: mpt3sas sleep from atomic context on v4.10
Date: Tue, 28 Feb 2017 16:25:33 -0800
Message-ID: <20170301002533.GA12292@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:33663 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751542AbdCAB1j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Feb 2017 20:27:39 -0500
Received: by mail-pg0-f47.google.com with SMTP id 25so13535710pgy.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2017 17:27:13 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-scsi@vger.kernel.org
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, kernel-team@fb.com

I'm seeing this while testing on Linus' current master:

[  427.814466] WARNING: CPU: 0 PID: 0 at kernel/irq/handle.c:149 __handle_irq_event_percpu+0x187/0x190
[  427.832552] irq 116 handler _base_interrupt+0x0/0x9e0 [mpt3sas] enabled interrupts

I tracked it down to commit 669f044170d8 ("scsi: srp_transport: Move
queuecommand() wait code to SCSI core"). That commit made it so
scsi_internal_device_block() can sleep, but mpt3sas calls this from an
interrupt handler:

_base_interrupt
-> _base_async_event
   -> mpt3sas_scsih_event_callback
      -> _scsih_check_topo_delete_events
         -> _scsih_block_io_to_children_attached_directly
	    -> _scsih_block_io_device
	       -> _scsih_internal_device_block
	          -> scsi_internal_device_block

This change was made in 4.10. Bart, can you take a look?

Thanks.
