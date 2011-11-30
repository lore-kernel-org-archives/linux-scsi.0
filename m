From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_ibft: Display iBFT signature in sysfs
Date: Wed, 30 Nov 2011 13:41:47 -0600
Message-ID: <4ED686FB.6060308@cs.wisc.edu>
References: <1322662228-51255-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60396 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876Ab1K3Tl7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2011 14:41:59 -0500
In-Reply-To: <1322662228-51255-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On 11/30/2011 08:10 AM, Hannes Reinecke wrote:
> Broadcom iSCSI offload cards use the signature 'BIFT' to signal
> that iSCSI offload is in use. This patch exports the iBFT signature
> to sysfs so that userspace can enable iSCSI offloading here.

Seems useful and ok to export.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>


Note that you should not need this for the iscsi tools though. The iscsi
tools in git already figure this out for all drivers if you compile with
OFFLOAD_BOOT_SUPPORTED set. Basically, if the MAC address in the
firmware ibft/iscsi_boot dirs/info is the same as one in the
/sys/class/iscsi_host dir then it is offload. For broadcom when you
enable hba mode it puts the offloaded MAC address in ibft. If hba mode
is not enabled then the MAC is the normal networking card port's MAC (in
this case iscsi tools will just do iscsi_tcp over bnx2x/bnx2).
