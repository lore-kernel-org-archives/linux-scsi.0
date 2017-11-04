From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] scsi: require CAP_SYS_ADMIN to write to procfs interface
Date: Sat, 4 Nov 2017 13:20:43 -0700
Message-ID: <7595538b-c203-0af4-810e-e3f97334a314@infradead.org>
References: <20171104185913.10658-1-asarai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171104185913.10658-1-asarai@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, Valentin Rothberg <vrothberg@suse.com>, cyphar@cyphar.com, stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-scsi@vger.kernel.org

On 11/04/2017 11:59 AM, Aleksa Sarai wrote:
> Previously, the only capability effectively required to operate on the
> /proc/scsi interface was CAP_DAC_OVERRIDE (or for some other files,
> having an fsuid of GLOBAL_ROOT_UID was enough). This means that
> semi-privileged processes could interfere with core components of a
> system (such as causing a DoS by removing the underlying SCSI device of
> the host's / mount).
> 
> Cc: <stable@vger.kernel.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Aleksa Sarai <asarai@suse.de>
> ---
>  drivers/scsi/scsi_proc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 480a597b3877..486aedce2f05 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -51,7 +51,10 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
>  	struct Scsi_Host *shost = PDE_DATA(file_inode(file));
>  	ssize_t ret = -ENOMEM;
>  	char *page;
> -    
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM

did that build without a trailing ';' ?

> +
>  	if (count > PROC_BLOCK_SIZE)
>  		return -EOVERFLOW;
>  
> @@ -313,6 +316,9 @@ static ssize_t proc_scsi_write(struct file *file, const char __user *buf,
>  	char *buffer, *p;
>  	int err;
>  
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
>  	if (!buf || length > PAGE_SIZE)
>  		return -EINVAL;
>  
> 


-- 
~Randy
