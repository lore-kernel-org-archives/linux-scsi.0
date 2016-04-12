From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/2] IB/iser: set max_segment_size
Date: Tue, 12 Apr 2016 08:34:03 -0700
Message-ID: <570D156B.7010206@sandisk.com>
References: <1460470405-11673-1-git-send-email-hch@lst.de>
 <1460470405-11673-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0067.outbound.protection.outlook.com ([65.55.169.67]:52871
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965045AbcDLPeK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 11:34:10 -0400
In-Reply-To: <1460470405-11673-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org

On 04/12/2016 07:13 AM, Christoph Hellwig wrote:
> So that we don't overflow the number of MR segments allocated because
> we have to split on SGL segment into multiple MR segments.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 80b6bed..dc55950 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -623,6 +623,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   	shost->max_id = 0;
>   	shost->max_channel = 0;
>   	shost->max_cmd_len = 16;
> +	shost->max_segment_size = SIZE_4K;
>
>   	/*
>   	 * older userspace tools (before 2.0-870) did not pass us

Hello Christoph,

ib_sg_to_pages() can handle segments that are larger than mr->page_size. 
Have you considered to set queue_limits.max_hw_sectors instead of 
max_segment_size?

Thanks,

Bart.
