From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch 01/10] scsi: make __scsi_alloc_queue numa-aware
Date: Fri, 02 Nov 2012 12:31:37 +0100
Message-ID: <5093AF19.5040707@acm.org>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com> <1351628084-29358-4-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351628084-29358-4-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/30/12 21:14, Jeff Moyer wrote:
> Pass the numa node id set in the Scsi_Host on to blk_init_queue_node
> in order to keep all allocations local to the numa node the device is
> closest to.
>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>   drivers/scsi/scsi_lib.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index da36a3a..8662a09 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1664,7 +1664,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
>   	struct request_queue *q;
>   	struct device *dev = shost->dma_dev;
>
> -	q = blk_init_queue(request_fn, NULL);
> +	q = blk_init_queue_node(request_fn, NULL, shost->numa_node);
>   	if (!q)
>   		return NULL;

Hello Jeff,

I haven't seen the patch that introduces numa_node in struct Scsi_Host 
nor the cover letter of this patch series ? Have these been posted on 
the linux-scsi mailing list ?

Bart.
