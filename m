From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] iscsi: Fix iscsi endpoints leak
Date: Tue, 02 Jun 2015 18:21:54 +0300
Message-ID: <556DCA12.3070903@dev.mellanox.co.il>
References: <1432114738-967-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35088 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbbFBPV7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2015 11:21:59 -0400
Received: by wgme6 with SMTP id e6so142974698wgm.2
        for <linux-scsi@vger.kernel.org>; Tue, 02 Jun 2015 08:21:58 -0700 (PDT)
In-Reply-To: <1432114738-967-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>

On 5/20/2015 12:38 PM, Sagi Grimberg wrote:
> When creating a new endpoint, we look for a free id
> for the new endpoint. We baisically loop on possible ids
> and use the first id that class_find_device() returns NULL.
> However, we are missing a reference put when class_find_device()
> does find an existing device for a given id.
>
> Reported-by: Alex Lyakas <alex@zadarastorage.com>
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 67d43e3..55647aa 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -204,6 +204,8 @@ iscsi_create_endpoint(int dd_size)
>   					iscsi_match_epid);
>   		if (!dev)
>   			break;
> +		else
> +			put_device(dev);
>   	}
>   	if (id == ISCSI_MAX_EPID) {
>   		printk(KERN_ERR "Too many connections. Max supported %u\n",
>

ping?

Mike, can I get a review on this one?

I think this leak existed since this code was introduced
in 2.6.37, but I've only tested back to 3.10.

So I think this deserves a CC to stable 3.10+
