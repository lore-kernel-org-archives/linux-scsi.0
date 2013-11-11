From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 4/6] libata: resume in the background
Date: Mon, 11 Nov 2013 17:10:31 +0400
Message-ID: <5280D747.8090204@cogentembedded.com>
References: <cover.1384030893.git.psusi@ubuntu.com> <6fca4cfe76c75939ec952c6a80c003e09d6f954c.1384030893.git.psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <6fca4cfe76c75939ec952c6a80c003e09d6f954c.1384030893.git.psusi@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10-11-2013 1:03, Phillip Susi wrote:

> Don't block the resume path waiting for the disk to
> spin up.
> ---
>   drivers/ata/libata-core.c | 10 ++++------
>   1 file changed, 4 insertions(+), 6 deletions(-)

> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 686c441..128ce0d 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5421,20 +5421,18 @@ static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
>   static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
>   {
>   	struct ata_port *ap = to_ata_port(dev);
> +	static int dontcare;
>
> -	return __ata_port_resume_common(ap, mesg, NULL);
> +	return __ata_port_resume_common(ap, mesg, &dontcare);
>   }
>
>   static int ata_port_resume(struct device *dev)
>   {
>   	int rc;
>
> +	if (pm_runtime_suspended(dev))
> +		return 0;
>   	rc = ata_port_resume_common(dev, PMSG_RESUME);
> -	if (!rc) {
> -		pm_runtime_disable(dev);
> -		pm_runtime_set_active(dev);
> -		pm_runtime_enable(dev);
> -	}

     With this modification, you don't need 'rc' anymore.

>   	return rc;
>   }
>

MBR, Sergei

