From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] Avoid that SCSI device removal through sysfs triggers a
 deadlock
Date: Thu, 27 Oct 2016 11:46:34 +0200
Message-ID: <20161027094634.fifk7wd43vyu64bd@linux-x5ow.site>
References: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942687AbcJ0OXv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Oct 2016 10:23:51 -0400
Content-Disposition: inline
In-Reply-To: <14379fd1-c9bd-ad75-ca7c-0632f3e3c5d1@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,

On Wed, Oct 26, 2016 at 11:44:51AM -0700, Bart Van Assche wrote:
> The solution I prefer is to modify the SCSI scanning code such that
> the scan_mutex is only held while performing the actual LUN scanning
> and while ensuring that no SCSI device has been created yet for a
> certain LUN number but not while the Linux device and its sysfs
> attributes are created. Since that approach would require extensive
> changes in the SCSI scanning code, another approach has been chosen,
> namely to make self-removal asynchronous. This patch avoids that
> self-removal triggers the following deadlock:

I'm not sure I like yet another asynchronity in the scsi code, but your
reason is very much understandable and I agree that this is the faster way.

[...]

> 
> References: http://www.spinics.net/lists/linux-scsi/msg86551.html
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: <stable@vger.kernel.org>
> ---

[...]

>  
> +static void scsi_remove_device_async(struct scsi_device *sdev)
> +{
> +	if (scsi_device_get(sdev) < 0)

Nit: the < 0 could be dropped, scsi_device_get returns either -ENXIO or
0. But no reason to respin.

Anyways,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
