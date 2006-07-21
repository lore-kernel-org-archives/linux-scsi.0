From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Asynchronous target discovery, version 10
Date: Fri, 21 Jul 2006 10:43:35 -0600
Message-ID: <20060721164335.GC9214@parisc-linux.org>
References: <20060721155710.GB9214@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:21144 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1751081AbWGUQng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Jul 2006 12:43:36 -0400
Content-Disposition: inline
In-Reply-To: <20060721155710.GB9214@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jack Steiner <steiner@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Anton Blanchard <anton@samba.org>, Justin Chen <justin.chen@hp.com>

On Fri, Jul 21, 2006 at 09:57:10AM -0600, Matthew Wilcox wrote:
>  - qla2xxx and lpfc drivers converted to use above interface.

... brown paper bag time ...

diff -u drivers/scsi/lpfc/lpfc_init.c drivers/scsi/lpfc/lpfc_init.c
--- drivers/scsi/lpfc/lpfc_init.c	21 Jul 2006 15:20:45 -0000
+++ drivers/scsi/lpfc/lpfc_init.c	21 Jul 2006 16:34:15 -0000
@@ -1612,6 +1612,7 @@
 	if (error)
 		goto out_kthread_stop;
 
+	scsi_target_discovery(host, 30, lpfc_finished_discovery);
 	error = lpfc_alloc_sysfs_attr(phba);
 	if (error)
 		goto out_remove_host;
