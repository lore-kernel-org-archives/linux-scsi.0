From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 04/12] sas_ata: ata_post_internal should abort the sas_task
Date: Tue, 06 Feb 2007 23:47:45 -0800
Message-ID: <45C98421.7020907@gmail.com>
References: <20070130091814.31530.23152.stgit@elm3a70.beaverton.ibm.com> <20070130091841.31530.81645.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:37109 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030641AbXBGRzg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 12:55:36 -0500
Received: by ug-out-1314.google.com with SMTP id 44so248874uga
        for <linux-scsi@vger.kernel.org>; Wed, 07 Feb 2007 09:55:35 -0800 (PST)
In-Reply-To: <20070130091841.31530.81645.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, alexisb@us.ibm.com

Darrick J. Wong wrote:
> This patch adds a new field, lldd_task, to ata_queued_cmd so that libata
> users such as libsas can associate some data with a qc.  The particular
> ambition with this patch is to associate a sas_task with a qc; that way,
> if libata decides to timeout a command, we can come back (in
> sas_ata_post_internal) and abort the sas task.

Can you rename ->lldd_task to something more generic, say, 
->low/driver_private_data and add a comment to explain who owns it?

> One question remains: Is it necessary to reset the phy on error, or will
> the libata error handler take care of it?  (Assuming that one is written,
> of course.)  This patch, as it is today, works well enough to clean
> things up when an ATA device probe attempt fails halfway through the probe,
> though I'm not sure this is always the right thing to do.

->post_internal_cmd is only responsible for putting the controller into 
a sane state and perform minimal diagnosis of the error if command has 
failed (setting AC_ERR_*).  Sane states are...

1. the controller is ready for further commands, if possible.

2. the controller is not processing the failed command, if #1 is not 
possible.  IOW, DMA engine is stopped (or any other activity which pokes 
memory) and the port is frozen (IRQ muted).

libata EH will take care of resetting, revalidating / reconfiguring 
attached ATA device using the provided reset methods, so no need for 
phy_reset in post_internal_cmd.

-- 
tejun

