From: "Hironobu Ishii" <ishii.hironobu@jp.fujitsu.com>
Subject: Re: [PATCH] remove scsi_cmnd->owner
Date: Mon, 20 Jun 2005 11:52:02 +0900
Message-ID: <019901c57543$0b8d37b0$ce677c0a@soft.fujitsu.com>
References: <20050619114052.GD18801@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56537 "EHLO
	fgwmail7.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S261404AbVFTCwi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 22:52:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Hi Christoph,


> never checked anywhere
> 
> Index: linux-2.6/drivers/scsi/scsi.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/scsi.c 2005-06-19 12:03:42.000000000 +0200
> +++ linux-2.6/drivers/scsi/scsi.c 2005-06-19 12:27:27.000000000 +0200
> @@ -258,7 +258,6 @@
>  memset(cmd, 0, sizeof(*cmd));
>  cmd->device = dev;
>  cmd->state = SCSI_STATE_UNUSED;
> - cmd->owner = SCSI_OWNER_NOBODY;
>  init_timer(&cmd->eh_timeout);
>  INIT_LIST_HEAD(&cmd->list);
>  spin_lock_irqsave(&dev->list_lock, flags);
> @@ -610,7 +609,6 @@
>  */
> 

I think these field(owner & state) are usefull to analyze 
the SCSI trouble with kernel memory dump.
Do we have another way to identify which layer 
is processing the scsi_cmnd?


Hironobu Ishii
