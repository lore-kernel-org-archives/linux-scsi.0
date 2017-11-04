From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2] scsi: require CAP_SYS_ADMIN to write to procfs
 interface
Date: Sat, 4 Nov 2017 13:50:22 -0700
Message-ID: <f9280a88-31de-5f98-1435-b07b7cca59f4@infradead.org>
References: <20171104202624.6605-1-asarai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171104202624.6605-1-asarai@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Aleksa Sarai <asarai@suse.de>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, Valentin Rothberg <vrothberg@suse.com>, cyphar@cyphar.com, stable@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-scsi@vger.kernel.org

On 11/04/2017 01:26 PM, Aleksa Sarai wrote:
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

There should be an
#include <linux/capability.h>
somewhere... even if some other header file is dragging it in (which
it must be), the preferred style is to always explicitly #include
header files that are used.

> ---
>  drivers/scsi/scsi_proc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
> index 480a597b3877..8c891ab16b11 100644
> --- a/drivers/scsi/scsi_proc.c
> +++ b/drivers/scsi/scsi_proc.c
> @@ -51,7 +51,10 @@ static ssize_t proc_scsi_host_write(struct file *file, const char __user *buf,
>  	struct Scsi_Host *shost = PDE_DATA(file_inode(file));
>  	ssize_t ret = -ENOMEM;
>  	char *page;
> -    
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
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
