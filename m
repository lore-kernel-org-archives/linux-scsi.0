From: Zwane Mwaikambo <zwane@arm.linux.org.uk>
Subject: final scsi_host_put in ->remove()?
Date: Mon, 29 Sep 2003 07:48:48 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.53.0309290733480.1740@montezuma.fsmlabs.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [66.212.224.118] ([66.212.224.118]:27155 "EHLO
	hemi.commfireservices.com") by vger.kernel.org with ESMTP
	id S263172AbTI2Lsv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 07:48:51 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: zwane@arm.linux.org.uk

Hi,
	Considering an updated scsi driver, where is the final 
scsi_host_put which eventually frees the Scsi_Host done?

An updated driver such as NCR_D700 has the following in it's ->remove() 
path. Whilst sym53c8xx_2 doesn't have any scsi_remove_host at all, dc395x.c does

static void NCR_D700_remove_one(struct Scsi_Host *host)
{
	scsi_remove_host(host);
	NCR_700_release(host);
	kfree((struct NCR_700_Host_Parameters *)host->hostdata[0]);
	free_irq(host->irq, host);
	release_region(host->base, 64);
}

Is it possible that scsi_remove_host does the final put? In which case 
using the host pointer afterwards wouldn't be safe. Otherwise wouldn't a 
scsi_host_put be required in that function? The scsi_remove_host section 
in Documentation/scsi/scsi_mid_low_api.txt appears to suggest the latter.

Thanks in advance for any clarification.

	Zwane
