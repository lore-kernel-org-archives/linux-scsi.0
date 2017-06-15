From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH] tcmu: Fix module removal due to stuck unmap_thread thread
 again
Date: Thu, 15 Jun 2017 14:00:17 -0500
Message-ID: <5942D941.6010709@redhat.com>
References: <1497510331-17918-1-git-send-email-lixiubo@cmss.chinamobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1497510331-17918-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: lixiubo@cmss.chinamobile.com, nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/15/2017 02:05 AM, lixiubo@cmss.chinamobile.com wrote:
> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
> 
> Because the unmap code just after the schdule() returned may take
> a long time and if the kthread_stop() is fired just when in this
> routine, the module removal maybe stuck too.
> 
> Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
> ---
>  drivers/target/target_core_user.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index beb5f09..203bff1 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1573,7 +1573,7 @@ static int unmap_thread_fn(void *data)
>  	struct page *page;
>  	int i;
>  
> -	while (1) {
> +	while (!kthread_should_stop()) {
>  		DEFINE_WAIT(__wait);
>  
>  		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
> 

Looks ok to me

Reviewed-by: Mike Christie <mchristi@redhat.com>
