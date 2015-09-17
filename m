From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH] iscsi: make mutex for target scanning and unbinding per-session
Date: Thu, 17 Sep 2015 14:11:39 -0500
Message-ID: <55FB106B.2000204@cs.wisc.edu>
References: <1442513809-11467-1-git-send-email-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Return-path: <open-iscsi+bncBCZ4TFNN2YMRB45A5SXQKGQENXLXKRQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1442513809-11467-1-git-send-email-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/open-iscsi/subscribe>
To: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 9/17/15, 1:16 PM, Chris Leech wrote:
> Currently the iSCSI transport class synchronises target scanning and
> unbinding with a host level mutex.  For multi-session hosts (offloading
> iSCSI HBAs) connecting to storage arrays that may implement one
> target-per-lun, this can result in the target scan work for hundreds of
> sessions being serialized behind a single mutex.  With slow enough
> response times, this can cause scan requests initiated from userspace to
> block on the mutex long enough to trigger 120 sec hung task warnings.
>
> I can't see any reason not to move this to a session level mutex and let
> the target scans run in parallel, speeding up connecting to a large
> number of targets.  Note that as iscsi_tcp creates a virtual host for
> each session, software iSCSI is effectively doing this already.
>
> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   drivers/scsi/scsi_transport_iscsi.c | 19 ++++++-------------
>   include/scsi/scsi_transport_iscsi.h |  2 +-
>   2 files changed, 7 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index e4b3d8f..9daeb7f 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1569,7 +1569,6 @@ static int iscsi_setup_host(struct transport_container *tc, struct device *dev,
>
>   	memset(ihost, 0, sizeof(*ihost));
>   	atomic_set(&ihost->nr_scans, 0);
> -	mutex_init(&ihost->mutex);
>
>   	iscsi_bsg_host_add(shost, ihost);
>   	/* ignore any bsg add error - we just can't do sgio */
> @@ -1789,8 +1788,6 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
>   {
>   	struct iscsi_scan_data *scan_data = data;
>   	struct iscsi_cls_session *session;
> -	struct Scsi_Host *shost;
> -	struct iscsi_cls_host *ihost;
>   	unsigned long flags;
>   	unsigned int id;
>
> @@ -1801,10 +1798,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
>
>   	ISCSI_DBG_TRANS_SESSION(session, "Scanning session\n");
>
> -	shost = iscsi_session_to_shost(session);
> -	ihost = shost->shost_data;
> -
> -	mutex_lock(&ihost->mutex);
> +	mutex_lock(&session->mutex);
>   	spin_lock_irqsave(&session->lock, flags);
>   	if (session->state != ISCSI_SESSION_LOGGED_IN) {
>   		spin_unlock_irqrestore(&session->lock, flags);
> @@ -1823,7 +1817,7 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
>   	}
>
>   user_scan_exit:
> -	mutex_unlock(&ihost->mutex);
> +	mutex_unlock(&session->mutex);
>   	ISCSI_DBG_TRANS_SESSION(session, "Completed session scan\n");
>   	return 0;
>   }
> @@ -1999,26 +1993,24 @@ static void __iscsi_unbind_session(struct work_struct *work)
>   	struct iscsi_cls_session *session =
>   			container_of(work, struct iscsi_cls_session,
>   				     unbind_work);
> -	struct Scsi_Host *shost = iscsi_session_to_shost(session);
> -	struct iscsi_cls_host *ihost = shost->shost_data;
>   	unsigned long flags;
>   	unsigned int target_id;
>
>   	ISCSI_DBG_TRANS_SESSION(session, "Unbinding session\n");
>
>   	/* Prevent new scans and make sure scanning is not in progress */
> -	mutex_lock(&ihost->mutex);
> +	mutex_lock(&session->mutex);
>   	spin_lock_irqsave(&session->lock, flags);
>   	if (session->target_id == ISCSI_MAX_TARGET) {
>   		spin_unlock_irqrestore(&session->lock, flags);
> -		mutex_unlock(&ihost->mutex);
> +		mutex_unlock(&session->mutex);
>   		return;
>   	}
>
>   	target_id = session->target_id;
>   	session->target_id = ISCSI_MAX_TARGET;
>   	spin_unlock_irqrestore(&session->lock, flags);
> -	mutex_unlock(&ihost->mutex);
> +	mutex_unlock(&session->mutex);
>
>   	if (session->ida_used)
>   		ida_simple_remove(&iscsi_sess_ida, target_id);
> @@ -2051,6 +2043,7 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
>   	INIT_WORK(&session->unbind_work, __iscsi_unbind_session);
>   	INIT_WORK(&session->scan_work, iscsi_scan_session);
>   	spin_lock_init(&session->lock);
> +	mutex_init(&session->mutex);
>
>   	/* this is released in the dev's release function */
>   	scsi_host_get(shost);
> diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> index 6183d20..acf9d9d 100644
> --- a/include/scsi/scsi_transport_iscsi.h
> +++ b/include/scsi/scsi_transport_iscsi.h
> @@ -238,6 +238,7 @@ struct iscsi_cls_session {
>   	struct work_struct unblock_work;
>   	struct work_struct scan_work;
>   	struct work_struct unbind_work;
> +	struct mutex mutex;
>
>   	/* recovery fields */
>   	int recovery_tmo;
> @@ -272,7 +273,6 @@ struct iscsi_cls_session {
>
>   struct iscsi_cls_host {
>   	atomic_t nr_scans;
> -	struct mutex mutex;
>   	struct request_queue *bsg_q;
>   	uint32_t port_speed;
>   	uint32_t port_state;


Reviewed-by: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at http://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
