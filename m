From: The Lee-Man <leeman.duncan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: iscsi: make mutex for target scanning and unbinding per-session
Date: Thu, 10 Nov 2016 10:00:54 -0800 (PST)
Message-ID: <d2f94e55-6a17-434f-8be0-e899ffe4802e@googlegroups.com>
References: <1478542920-24460-1-git-send-email-cleech@redhat.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_856_1249682685.1478800854717"
Return-path: <open-iscsi+bncBC755V5RXMKBBV7LSLAQKGQEX7VZTKI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1478542920-24460-1-git-send-email-cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lduncan-IBi9RG/b67k@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

------=_Part_856_1249682685.1478800854717
Content-Type: multipart/alternative;
	boundary="----=_Part_857_995132725.1478800854718"

------=_Part_857_995132725.1478800854718
Content-Type: text/plain; charset=UTF-8

On Monday, November 7, 2016 at 11:22:23 AM UTC-7, Chris Leech wrote:
>
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

I understood the reason for this mutex was to protect against the case
where there are multiple paths to a target. In such cases, you can get
simultaneous access to sysfs attributes (files), which can cause errors,
i.e. two threads trying to write an attribute at the same time, or one
changing an attribute while another reads or removes it.

I worry that changing it will not address those issues.

[Side note: we *really* need a test suite that somehow includes
 cases like this.]

>
> Signed-off-by: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> 
> --- 
>  drivers/scsi/scsi_transport_iscsi.c | 19 ++++++------------- 
>  include/scsi/scsi_transport_iscsi.h |  2 +- 
>  2 files changed, 7 insertions(+), 14 deletions(-) 
>
> diff --git a/drivers/scsi/scsi_transport_iscsi.c 
> b/drivers/scsi/scsi_transport_iscsi.c 
> index 42bca61..83c90fa 100644 
> --- a/drivers/scsi/scsi_transport_iscsi.c 
> +++ b/drivers/scsi/scsi_transport_iscsi.c 
> @@ -1568,7 +1568,6 @@ static int iscsi_setup_host(struct 
> transport_container *tc, struct device *dev, 
>   
>          memset(ihost, 0, sizeof(*ihost)); 
>          atomic_set(&ihost->nr_scans, 0); 
> -        mutex_init(&ihost->mutex); 
>   
>          iscsi_bsg_host_add(shost, ihost); 
>          /* ignore any bsg add error - we just can't do sgio */ 
> @@ -1789,8 +1788,6 @@ static int iscsi_user_scan_session(struct device 
> *dev, void *data) 
>  { 
>          struct iscsi_scan_data *scan_data = data; 
>          struct iscsi_cls_session *session; 
> -        struct Scsi_Host *shost; 
> -        struct iscsi_cls_host *ihost; 
>          unsigned long flags; 
>          unsigned int id; 
>   
> @@ -1801,10 +1798,7 @@ static int iscsi_user_scan_session(struct device 
> *dev, void *data) 
>   
>          ISCSI_DBG_TRANS_SESSION(session, "Scanning session\n"); 
>   
> -        shost = iscsi_session_to_shost(session); 
> -        ihost = shost->shost_data; 
> - 
> -        mutex_lock(&ihost->mutex); 
> +        mutex_lock(&session->mutex); 
>          spin_lock_irqsave(&session->lock, flags); 
>          if (session->state != ISCSI_SESSION_LOGGED_IN) { 
>                  spin_unlock_irqrestore(&session->lock, flags); 
> @@ -1823,7 +1817,7 @@ static int iscsi_user_scan_session(struct device 
> *dev, void *data) 
>          } 
>   
>  user_scan_exit: 
> -        mutex_unlock(&ihost->mutex); 
> +        mutex_unlock(&session->mutex); 
>          ISCSI_DBG_TRANS_SESSION(session, "Completed session scan\n"); 
>          return 0; 
>  } 
> @@ -2001,26 +1995,24 @@ static void __iscsi_unbind_session(struct 
> work_struct *work) 
>          struct iscsi_cls_session *session = 
>                          container_of(work, struct iscsi_cls_session, 
>                                       unbind_work); 
> -        struct Scsi_Host *shost = iscsi_session_to_shost(session); 
> -        struct iscsi_cls_host *ihost = shost->shost_data; 
>          unsigned long flags; 
>          unsigned int target_id; 
>   
>          ISCSI_DBG_TRANS_SESSION(session, "Unbinding session\n"); 
>   
>          /* Prevent new scans and make sure scanning is not in progress */ 
> -        mutex_lock(&ihost->mutex); 
> +        mutex_lock(&session->mutex); 
>          spin_lock_irqsave(&session->lock, flags); 
>          if (session->target_id == ISCSI_MAX_TARGET) { 
>                  spin_unlock_irqrestore(&session->lock, flags); 
> -                mutex_unlock(&ihost->mutex); 
> +                mutex_unlock(&session->mutex); 
>                  return; 
>          } 
>   
>          target_id = session->target_id; 
>          session->target_id = ISCSI_MAX_TARGET; 
>          spin_unlock_irqrestore(&session->lock, flags); 
> -        mutex_unlock(&ihost->mutex); 
> +        mutex_unlock(&session->mutex); 
>   
>          if (session->ida_used) 
>                  ida_simple_remove(&iscsi_sess_ida, target_id); 
> @@ -2053,6 +2045,7 @@ iscsi_alloc_session(struct Scsi_Host *shost, struct 
> iscsi_transport *transport, 
>          INIT_WORK(&session->unbind_work, __iscsi_unbind_session); 
>          INIT_WORK(&session->scan_work, iscsi_scan_session); 
>          spin_lock_init(&session->lock); 
> +        mutex_init(&session->mutex); 
>   
>          /* this is released in the dev's release function */ 
>          scsi_host_get(shost); 
> diff --git a/include/scsi/scsi_transport_iscsi.h 
> b/include/scsi/scsi_transport_iscsi.h 
> index 6183d20..acf9d9d 100644 
> --- a/include/scsi/scsi_transport_iscsi.h 
> +++ b/include/scsi/scsi_transport_iscsi.h 
> @@ -238,6 +238,7 @@ struct iscsi_cls_session { 
>          struct work_struct unblock_work; 
>          struct work_struct scan_work; 
>          struct work_struct unbind_work; 
> +        struct mutex mutex; 
>   
>          /* recovery fields */ 
>          int recovery_tmo; 
> @@ -272,7 +273,6 @@ struct iscsi_cls_session { 
>   
>  struct iscsi_cls_host { 
>          atomic_t nr_scans; 
> -        struct mutex mutex; 
>          struct request_queue *bsg_q; 
>          uint32_t port_speed; 
>          uint32_t port_state; 
> -- 
> 2.7.4 
>
>

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

------=_Part_857_995132725.1478800854718
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Monday, November 7, 2016 at 11:22:23 AM UTC-7, Chris Le=
ech wrote:<blockquote class=3D"gmail_quote" style=3D"margin: 0;margin-left:=
 0.8ex;border-left: 1px #ccc solid;padding-left: 1ex;">Currently the iSCSI =
transport class synchronises target scanning and
<br>unbinding with a host level mutex. =C2=A0For multi-session hosts (offlo=
ading
<br>iSCSI HBAs) connecting to storage arrays that may implement one
<br>target-per-lun, this can result in the target scan work for hundreds of
<br>sessions being serialized behind a single mutex. =C2=A0With slow enough
<br>response times, this can cause scan requests initiated from userspace t=
o
<br>block on the mutex long enough to trigger 120 sec hung task warnings.
<br>
<br>I can&#39;t see any reason not to move this to a session level mutex an=
d let
<br>the target scans run in parallel, speeding up connecting to a large
<br>number of targets. =C2=A0Note that as iscsi_tcp creates a virtual host =
for
<br>each session, software iSCSI is effectively doing this already.
<br></blockquote><div><br>I understood the reason for this mutex was to pro=
tect against the case<br>where there are multiple paths to a target. In suc=
h cases, you can get<br>simultaneous access to sysfs attributes (files), wh=
ich can cause errors,<br>i.e. two threads trying to write an attribute at t=
he same time, or one<br>changing an attribute while another reads or remove=
s it.<br><br>I worry that changing it will not address those issues.<br><br=
>[Side note: we *really* need a test suite that somehow includes<br>=C2=A0c=
ases like this.]<br></div><blockquote class=3D"gmail_quote" style=3D"margin=
: 0;margin-left: 0.8ex;border-left: 1px #ccc solid;padding-left: 1ex;">
<br>Signed-off-by: Chris Leech &lt;<a href=3D"mailto:cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" tar=
get=3D"_blank" rel=3D"nofollow" onmousedown=3D"this.href=3D&#39;mailto:clee=
ch-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org&#39;;return true;" onclick=3D"this.href=3D&#39;mailto:cleech@=
redhat.com&#39;;return true;">cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org</a>&gt;
<br>---
<br>=C2=A0drivers/scsi/scsi_transport_<wbr>iscsi.c | 19 ++++++-------------
<br>=C2=A0include/scsi/scsi_transport_<wbr>iscsi.h | =C2=A02 +-
<br>=C2=A02 files changed, 7 insertions(+), 14 deletions(-)
<br>
<br>diff --git a/drivers/scsi/scsi_transport_<wbr>iscsi.c b/drivers/scsi/sc=
si_transport_<wbr>iscsi.c
<br>index 42bca61..83c90fa 100644
<br>--- a/drivers/scsi/scsi_transport_<wbr>iscsi.c
<br>+++ b/drivers/scsi/scsi_transport_<wbr>iscsi.c
<br>@@ -1568,7 +1568,6 @@ static int iscsi_setup_host(struct transport_cont=
ainer *tc, struct device *dev,
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0memset(ihost, 0, =
sizeof(*ihost));
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_set(&amp;i=
host-&gt;<wbr>nr_scans, 0);
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_init(&amp;ihost-=
&gt;<wbr>mutex);
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0iscsi_bsg_host_ad=
d(<wbr>shost, ihost);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* ignore any bsg=
 add error - we just can&#39;t do sgio */
<br>@@ -1789,8 +1788,6 @@ static int iscsi_user_scan_session(struct device =
*dev, void *data)
<br>=C2=A0{
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct iscsi_scan=
_data *scan_data =3D data;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct iscsi_cls_=
session *session;
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct Scsi_Host *shos=
t;
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct iscsi_cls_host =
*ihost;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long fla=
gs;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int id;
<br>=C2=A0
<br>@@ -1801,10 +1798,7 @@ static int iscsi_user_scan_session(struct device=
 *dev, void *data)
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ISCSI_DBG_TRANS_<=
wbr>SESSION(session, &quot;Scanning session\n&quot;);
<br>=C2=A0
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0shost =3D iscsi_sessio=
n_to_shost(<wbr>session);
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ihost =3D shost-&gt;sh=
ost_data;
<br>-
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&amp;ihost-=
&gt;<wbr>mutex);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&amp;sessio=
n-&gt;<wbr>mutex);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_irqsave=
(&amp;<wbr>session-&gt;lock, flags);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (session-&gt;s=
tate !=3D ISCSI_SESSION_LOGGED_IN) {
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock_<wbr>irqrestore(&amp;session-&=
gt;lock, flags);
<br>@@ -1823,7 +1817,7 @@ static int iscsi_user_scan_session(struct device =
*dev, void *data)
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
<br>=C2=A0
<br>=C2=A0user_scan_exit:
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&amp;ihos=
t-&gt;<wbr>mutex);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&amp;<wbr=
>session-&gt;mutex);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ISCSI_DBG_TRANS_<=
wbr>SESSION(session, &quot;Completed session scan\n&quot;);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
<br>=C2=A0}
<br>@@ -2001,26 +1995,24 @@ static void __iscsi_unbind_session(struct work_=
struct *work)
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct iscsi_cls_=
session *session =3D
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0<wbr>container_of(work, struct iscsi_cls_session,
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0<wbr>=C2=A0=C2=A0=C2=A0 =C2=A0 =C2=A0 u=
nbind_work);
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct Scsi_Host *shos=
t =3D iscsi_session_to_shost(<wbr>session);
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct iscsi_cls_host =
*ihost =3D shost-&gt;shost_data;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned long fla=
gs;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0unsigned int targ=
et_id;
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ISCSI_DBG_TRANS_<=
wbr>SESSION(session, &quot;Unbinding session\n&quot;);
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* Prevent new sc=
ans and make sure scanning is not in progress */
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&amp;ihost-=
&gt;<wbr>mutex);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_lock(&amp;sessio=
n-&gt;<wbr>mutex);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_irqsave=
(&amp;<wbr>session-&gt;lock, flags);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (session-&gt;t=
arget_id =3D=3D ISCSI_MAX_TARGET) {
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock_<wbr>irqrestore(&amp;session-&=
gt;lock, flags);
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(<wbr>&amp;ihost-&gt;mutex);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(<wbr>&amp;session-&gt;mutex);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0}
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0target_id =3D ses=
sion-&gt;target_id;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0session-&gt;targe=
t_id =3D ISCSI_MAX_TARGET;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_unlock_<wbr>=
irqrestore(&amp;session-&gt;lock, flags);
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&amp;ihos=
t-&gt;<wbr>mutex);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_unlock(&amp;<wbr=
>session-&gt;mutex);
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (session-&gt;i=
da_used)
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ida_simple_<wbr>remove(&amp;iscsi_sess_ida=
, target_id);
<br>@@ -2053,6 +2045,7 @@ iscsi_alloc_session(struct Scsi_Host *shost, stru=
ct iscsi_transport *transport,
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_WORK(&amp;se=
ssion-&gt;<wbr>unbind_work, __iscsi_unbind_session);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0INIT_WORK(&amp;se=
ssion-&gt;<wbr>scan_work, iscsi_scan_session);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0spin_lock_init(&a=
mp;<wbr>session-&gt;lock);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mutex_init(&amp;sessio=
n-&gt;<wbr>mutex);
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* this is releas=
ed in the dev&#39;s release function */
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0scsi_host_get(sho=
st);
<br>diff --git a/include/scsi/scsi_transport_<wbr>iscsi.h b/include/scsi/sc=
si_transport_<wbr>iscsi.h
<br>index 6183d20..acf9d9d 100644
<br>--- a/include/scsi/scsi_transport_<wbr>iscsi.h
<br>+++ b/include/scsi/scsi_transport_<wbr>iscsi.h
<br>@@ -238,6 +238,7 @@ struct iscsi_cls_session {
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct work_struc=
t unblock_work;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct work_struc=
t scan_work;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct work_struc=
t unbind_work;
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mutex mutex;
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/* recovery field=
s */
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0int recovery_tmo;
<br>@@ -272,7 +273,6 @@ struct iscsi_cls_session {
<br>=C2=A0
<br>=C2=A0struct iscsi_cls_host {
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0atomic_t nr_scans=
;
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct mutex mutex;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct request_qu=
eue *bsg_q;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint32_t port_spe=
ed;
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0uint32_t port_sta=
te;
<br>--=20
<br>2.7.4
<br>
<br></blockquote></div>

<p></p>

-- <br />
You received this message because you are subscribed to the Google Groups &=
quot;open-iscsi&quot; group.<br />
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to <a href=3D"mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org">open-isc=
si+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
To post to this group, send email to <a href=3D"mailto:open-iscsi@googlegro=
ups.com">open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org</a>.<br />
Visit this group at <a href=3D"https://groups.google.com/group/open-iscsi">=
https://groups.google.com/group/open-iscsi</a>.<br />
For more options, visit <a href=3D"https://groups.google.com/d/optout">http=
s://groups.google.com/d/optout</a>.<br />

------=_Part_857_995132725.1478800854718--

------=_Part_856_1249682685.1478800854717--
