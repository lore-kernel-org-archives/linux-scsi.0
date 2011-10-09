From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] target: unlock on error in pscsi_create_virtdevice()
Date: Sat, 08 Oct 2011 18:06:41 -0700
Message-ID: <1318122401.4978.55.camel@haakon2.linux-iscsi.org>
References: <20111001225913.GA15072@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20111001225913.GA15072@elgon.mountain>
Sender: target-devel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2011-10-02 at 01:59 +0300, Dan Carpenter wrote:
> This function should take the lock on success but on the error cases
> it doesn't.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 

Hi Dan,

> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index ba9e94d..b619596 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -567,7 +567,7 @@ static struct se_device *pscsi_create_virtdevice(
>  			if (IS_ERR(sh)) {
>  				pr_err("pSCSI: Unable to locate"
>  					" pdv_host_id: %d\n", pdv->pdv_host_id);
> -				return (struct se_device *) sh;
> +				return ERR_CAST(sh);
>  			}
>  		}
>  	} else {
> @@ -609,6 +609,7 @@ static struct se_device *pscsi_create_virtdevice(
>  				hba->hba_flags &= ~HBA_FLAGS_PSCSI_MODE;
>  			}
>  			pdv->pdv_sd = NULL;
> +			spin_unlock_irq(sh->host_lock);
>  			return ERR_PTR(-ENODEV);
>  		}
>  		return dev;
> --

So the additional of an unlock in the failure path above is actually a
duplicate.  pscsi_create_type_*() will already do the unlocking before
returning back into pscsi_create_virtdevice()..  I know this is slightly
confusing, but we need to keep host_lock held before calling into
scsi_device_get() for type_disk and type_rom.

So that said, i'm commiting a following revised version of your patch to
add the correct ERR_CAST usage above.

Thanks,

--nab

commit 8c206dce8ccf83e2b3e121e89074d841edd43536
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Sun Oct 2 01:59:13 2011 +0300

    target: Make pscsi_create_virtdevice use ERR_CAST
    
    This patch changes pscsi_create_virtdevice() to properly return ERR_CAST
    instead of a raw pointer upon scsi_host_lookup() failure.
    
    Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
    Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c4509e3..e72a638 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -567,7 +567,7 @@ static struct se_device *pscsi_create_virtdevice(
                        if (IS_ERR(sh)) {
                                pr_err("pSCSI: Unable to locate"
                                        " pdv_host_id: %d\n", pdv->pdv_host_id);
-                               return (struct se_device *) sh;
+                               return ERR_CAST(sh);
                        }
                }
        } else {
