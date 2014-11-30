From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH] iscsi-target: fix error path in iscsi_target_init_module()
Date: Sun, 30 Nov 2014 18:30:51 +0200
Message-ID: <547B463B.6060001@dev.mellanox.co.il>
References: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1417345211-5583-1-git-send-email-LinoSanfilippo@gmx.de>
Sender: target-devel-owner@vger.kernel.org
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>, nab@linux-iscsi.org
Cc: sagig@mellanox.com, cvubrugier@yahoo.fr, joern@logfs.org, steven.allen@purestorage.com, arshad.hussain@calsoftinc.com, agrover@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/30/2014 1:00 PM, Lino Sanfilippo wrote:
> In iscsi_target_init_module() unwind transport protocol registration in case
> that iscsit_load_discovery_tpg() failed.
>
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>   drivers/target/iscsi/iscsi_target.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 73e58d2..f8ec322 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -609,6 +609,7 @@ static int __init iscsi_target_init_module(void)
>
>   	return ret;
>   r2t_out:
> +	iscsit_unregister_transport(&iscsi_target_transport);
>   	kmem_cache_destroy(lio_r2t_cache);
>   ooo_out:
>   	kmem_cache_destroy(lio_ooo_cache);
>

Yep, Looks good.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
