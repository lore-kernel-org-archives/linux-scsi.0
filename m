From: Alan Stern <stern@rowland.harvard.edu>
Subject: aic7xxx driver schedules() while holding spinlock
Date: Thu, 3 Jul 2003 15:55:58 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0307031539500.647-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:2052 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S265291AbTGCTlb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2003 15:41:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

To the aic7xxx maintainers:

Just in case you aren't already aware, the aic7xxx driver calls routines
that can block while it holds a spinlock.  Here are a couple of call
trees:

	ahc_linux_exit();   [acquires ahc_list_lock] 
	 ahc_linux_kill_dv_thread(ahc);
	  down(&ahc->platform_data->eh_sem);


	ahc_linux_exit();
	 ahc_linux_pci_exit();
	  pci_unregister_driver(&aic7xxx_pci_driver);
	   ahc_linux_pci_dev_remove(struct pci_dev *pdev);
			[acquires ahc_list_lock]
	    ahc_free(ahc);
	     ahc_platform_free(ahc);
	      scsi_remove_host(ahc->platform_data->host);
which calls sysfs routines that sleep in several places.

Alan Stern

