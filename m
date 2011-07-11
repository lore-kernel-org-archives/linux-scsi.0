From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] BNX2I: Fixed kernel panic due to illegal usage of sc->request->cpu
Date: Mon, 11 Jul 2011 15:02:59 -0500
Message-ID: <4E1B56F3.20507@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1310408095-11882-1-git-send-email-eddie.wai@broadcom.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCLPJla3WGRDlrO3wBBoEskHwrQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1310408095-11882-1-git-send-email-eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Eddie Wai <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Ben Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 07/11/2011 01:14 PM, Eddie Wai wrote:
> A kernel panic was observed when passing the sc->request->cpu = -1 to
> retrieve the per_cpu variable pointer:
>  #0 [ffff880011203960] machine_kexec at ffffffff81022bc3
>  #1 [ffff8800112039b0] crash_kexec at ffffffff81088630
>  #2 [ffff880011203a80] __die at ffffffff8139ea20
>  #3 [ffff880011203aa0] no_context at ffffffff8102f3a7
>  #4 [ffff880011203ae0] __bad_area_nosemaphore at ffffffff8102f665
>  #5 [ffff880011203ba0] retint_signal at ffffffff8139dd1f
>  #6 [ffff880011203cc8] bnx2i_indicate_kcqe at ffffffffa03dc4f2
>  #7 [ffff880011203da8] service_kcqes at ffffffffa03cb04f
>  #8 [ffff880011203e68] cnic_service_bnx2x_kcq at ffffffffa03cb14a
>  #9 [ffff880011203e88] cnic_service_bnx2x_bh at ffffffffa03cb1b3
> 
> The problem lies in the sg_io (and perhaps sg_scsi_ioctl) call to
> blk_get_request->get_request/wait->blk_alloc_request->blk_rq_init which
> re-initializes the request->cpu to -1.  There is no assignment for cpu from
> that to the request_fn call to low level drivers.
> 
> When this happens, the sc->request->cpu will be using the init value of
> -1.  This will create a kernel panic when it hits bnx2i because the code
> refers it to get the per_cpu variables ptr.
> 
> This change is to put in a guard against that and also for cases when
> CONFIG_SMP/BIO_CPU_AFFINE is not enabled.  In those cases, the cpu
> affinitization code would not get run in __make_request either; hence
> the request->cpu will remain a -1 also.
> 


> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 5c55a75..622383d 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1225,6 +1225,10 @@ static int bnx2i_task_xmit(struct iscsi_task *task)
>  	if (!sc)
>  		return bnx2i_mtask_xmit(conn, task);
>  
> +	if (!blk_rq_cpu_valid(sc->request)) {
> +		sc->request->cpu = get_cpu();
> +		put_cpu();
> +	}


If I understand you right, then I think this needs to get fixed in the
block or scsi layer instead of each LLD.

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
