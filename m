From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [patch,v2 05/10] sd: use alloc_disk_node
Date: Sat, 03 Nov 2012 17:37:38 +0100
Message-ID: <50954852.5050209@acm.org>
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <1351892763-21325-6-git-send-email-jmoyer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351892763-21325-6-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

On 11/02/12 22:45, Jeff Moyer wrote:
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>   drivers/scsi/sd.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 12f6fdf..8deb915 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
>   	if (!sdkp)
>   		goto out;
>
> -	gd = alloc_disk(SD_MINORS);
> +	gd = alloc_disk_node(SD_MINORS, dev_to_node(dev));
>   	if (!gd)
>   		goto out_free;

shost->numa_node can be another NUMA node than dev_to_node(dev). Have 
you considered using shost->numa_node here ?

Bart.
