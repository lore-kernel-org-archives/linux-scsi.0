From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] scsi: storvsc: avoid usage of WRITE_SAME
Date: Mon, 11 Feb 2013 17:06:38 +0100
Message-ID: <20130211160638.GB15243@aepfle.de>
References: <1359557094-13625-1-git-send-email-olaf@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:14846 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab3BKQGm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2013 11:06:42 -0500
Content-Disposition: inline
In-Reply-To: <1359557094-13625-1-git-send-email-olaf@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: KY Srinivasan <kys@microsoft.com>

James,

this patch fixes a regression in 3.8. Please try to include it in final 3.8.
There is also another outstanding fix regarding sglist init from KY.

Olaf

On Wed, Jan 30, Olaf Hering wrote:

> Set scsi_device->no_write_same because the host does not support it.
> Also blacklist WRITE_SAME to avoid (and log) accident usage.
> 
> If the guest uses the ext4 filesystem, storvsc hangs while it prints
> these messages in an endless loop:


>  drivers/scsi/storvsc_drv.c | 4 ++++
>  1 file changed, 4 insertions(+)

> +	sdevice->no_write_same = 1;

