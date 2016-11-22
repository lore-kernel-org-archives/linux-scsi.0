From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: hpsa: fix uninitialized variable access
Date: Tue, 22 Nov 2016 15:49:50 +0100
Message-ID: <3179555.Y0kaXrZstW@wuerfel>
References: <20161122143303.1871678-1-arnd@arndb.de> <04f7cd82-8979-0f08-8b16-3cf863795ccf@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:58008 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933484AbcKVOuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 09:50:24 -0500
In-Reply-To: <04f7cd82-8979-0f08-8b16-3cf863795ccf@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Don Brace <don.brace@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Kevin Barnett <kevin.barnett@microsemi.com>, Scott Teel <scott.teel@microsemi.com>, Justin Lindley <justin.lindley@microsemi.com>, esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tuesday, November 22, 2016 3:47:09 PM CET Hannes Reinecke wrote:
> index 05f7782..ee6f852 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -2031,7 +2031,7 @@ static struct hpsa_scsi_dev_t
> *lookup_hpsa_scsi_dev(struct ctlr_info *h,
> 
>  static int hpsa_slave_alloc(struct scsi_device *sdev)
>  {
> -       struct hpsa_scsi_dev_t *sd;
> +       struct hpsa_scsi_dev_t *sd = NULL;
>         unsigned long flags;
>         struct ctlr_info *h;
> 
> 

I try not to add initializations like this in general, since they
prevent us from finding the bug, but here that seems fine too
as we immediately test it for NULL anyway.

Can you follow up with a patch to do that?

	Arnd

