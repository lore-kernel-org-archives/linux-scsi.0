From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 13:48:14 +0300
Message-ID: <570CD26E.70502@grimberg.me>
References: <1460414846-29540-1-git-send-email-hch@lst.de>
 <1460414846-29540-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35472 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966AbcDLKsS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 06:48:18 -0400
In-Reply-To: <1460414846-29540-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org


> So that we don't overflow the number of MR segments allocated because
> we have to split on SGL segment into multiple MR segments.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 80b6bed..784504a 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -623,6 +623,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   	shost->max_id = 0;
>   	shost->max_channel = 0;
>   	shost->max_cmd_len = 16;
> +	shost->max_segment_size = PAGE_SIZE;

In iser we sorta rely on 4k pages so we avoid
PAGE_SIZE but rather set SIZE_4K for these sort
of things (like we did in the virt_boundary).
