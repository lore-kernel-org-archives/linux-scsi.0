From: Michael Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] libiscsi: avoid unnecessary multiple NULL assignments
Date: Sun, 12 Aug 2012 20:30:01 -0500
Message-ID: <697C8ADD-803B-4225-825E-F2C027D0C6C3@cs.wisc.edu>
References: <1344780951-5011-1-git-send-email-yamato@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCLPJla3WGRCdsaGBBRoEazCKsw-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1344780951-5011-1-git-send-email-yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Masatake YAMATO <yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Replacing linux-scsi list with linux-kernel.

On Aug 12, 2012, at 9:15 AM, Masatake YAMATO <yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> In iscsi_free_task, NULL is assigned to task->sc twice: before and
> after kfifo_in invocatoin. Allocating and freeing iscsi_task are guarded
> with session->lock, so multiple NULL assignments cause no trouble. But
> people reading the source code may be confused.
> 
> The second NULL assignment comes from commit:
> 
>    3e5c28ad0391389959ccae81c938c7533efb3490
> 
> It seems that the line after kfifo_in invocation was introduced
> accidentally.
> 
> Signed-off-by: Masatake YAMATO <yamato-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> drivers/scsi/libiscsi.c | 1 -
> 1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 82c3fd4..7aacf3a 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -500,21 +500,20 @@ static void iscsi_free_task(struct iscsi_task *task)
> 	task->sc = NULL;
> 	/*
> 	 * login task is preallocated so do not free
> 	 */
> 	if (conn->login_task == task)
> 		return;
> 
> 	kfifo_in(&session->cmdpool.queue, (void*)&task, sizeof(void*));
> 
> 	if (sc) {
> -		task->sc = NULL;
> 		/* SCSI eh reuses commands to verify us */
> 		sc->SCp.ptr = NULL;
> 		/*
> 		 * queue command may call this to free the task, so
> 		 * it will decide how to return sc to scsi-ml.
> 		 */
> 		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
> 			sc->scsi_done(sc);
> 	}

Looks ok to me.

Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
