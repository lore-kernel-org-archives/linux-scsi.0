From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 02/15] be2iscsi: Fix mbox synchronization replacing spinlock
 with mutex
Date: Sun, 20 Dec 2015 01:35:05 -0600
Message-ID: <56765A29.2010409@cs.wisc.edu>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com> <1450194906-12925-3-git-send-email-jitendra.bhivare@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42046 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbbLTHfN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Dec 2015 02:35:13 -0500
In-Reply-To: <1450194906-12925-3-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@avagotech.com>, linux-scsi@vger.kernel.org

On 12/15/2015 09:54 AM, Jitendra Bhivare wrote:
> From: Jitendra <jitendra.bhivare@avagotech.com>
> 
> This is second part of actual fix for soft lockup.
> 
> All mbox cmds issued using BMBX and MCC are synchronized using mutex
> mbox_lock instead of spin_lock. Used mutex_lock_interruptible where
> ever possible.
> 
> Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
> ---
>  drivers/scsi/be2iscsi/be.h      |    2 +-
>  drivers/scsi/be2iscsi/be_cmds.c |   73 ++++++++++++++-------------
>  drivers/scsi/be2iscsi/be_main.c |    2 +-
>  drivers/scsi/be2iscsi/be_mgmt.c |  105 ++++++++++++++++++++------------------
>  4 files changed, 94 insertions(+), 88 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be.h b/drivers/scsi/be2iscsi/be.h
> index 77f992e..cf19bce 100644
> --- a/drivers/scsi/be2iscsi/be.h
> +++ b/drivers/scsi/be2iscsi/be.h
> @@ -124,7 +124,7 @@ struct be_ctrl_info {
>  	struct pci_dev *pdev;
>  
>  	/* Mbox used for cmd request/response */
> -	spinlock_t mbox_lock;	/* For serializing mbox cmds to BE card */
> +	struct mutex mbox_lock;	/* For serializing mbox cmds to BE card */

You need to update free_mcc_tag. It still does spin_lock calls on the
mbox_lock.

