From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: fix error path in
 iscsi_target_init_module()
Date: Mon, 01 Dec 2014 22:11:56 -0800
Message-ID: <1417500716.11477.1.camel@haakon3.risingtidesystems.com>
References: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: sagig@mellanox.com, cvubrugier@yahoo.fr, joern@logfs.org, steven.allen@purestorage.com, arshad.hussain@calsoftinc.com, agrover@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2014-11-30 at 12:00 +0100, Lino Sanfilippo wrote:
> In iscsi_target_init_module() unwind transport protocol registration in case
> that iscsit_load_discovery_tpg() failed.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  drivers/target/iscsi/iscsi_target.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 73e58d2..f8ec322 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -609,6 +609,7 @@ static int __init iscsi_target_init_module(void)
>  
>  	return ret;
>  r2t_out:
> +	iscsit_unregister_transport(&iscsi_target_transport);
>  	kmem_cache_destroy(lio_r2t_cache);
>  ooo_out:
>  	kmem_cache_destroy(lio_ooo_cache);

Nice catch.  Applied to target-pending/for-next.

Thanks Lino!

--nab
