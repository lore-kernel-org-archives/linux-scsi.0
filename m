From: The Lee-Man <leeman.duncan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] scsi: libiscsi: use kvzalloc for iscsi_pool_init
Date: Thu, 18 May 2017 09:49:15 -0700 (PDT)
Message-ID: <68027ed0-9bca-4d45-b1ef-17d5b3ac6cb7@googlegroups.com>
References: <1495052514-3327-1-git-send-email-kyle.fortin@oracle.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_504_40137999.1495126155935"
Return-path: <open-iscsi+bncBC755V5RXMKBBDFB67EAKGQEYXG6SKQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <1495052514-3327-1-git-send-email-kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: lduncan-IBi9RG/b67k@public.gmane.org, cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, joe.slember-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lance.hartmann-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

------=_Part_504_40137999.1495126155935
Content-Type: multipart/alternative;
	boundary="----=_Part_505_1028619624.1495126155935"

------=_Part_505_1028619624.1495126155935
Content-Type: text/plain; charset="UTF-8"

On Wednesday, May 17, 2017 at 2:38:56 PM UTC-7, Kyle Fortin wrote:
>
> iscsiadm session login can fail with the following error: 
>
> iscsiadm: Could not login to [iface: default, target: iqn.1986-03.com... 
> iscsiadm: initiator reported error (9 - internal error) 
>
> When /etc/iscsi/iscsid.conf sets node.session.cmds_max = 4096, it results 
> in 64K-sized kmallocs per session.  A system under fragmented slab 
> pressure may not have any 64K objects available and fail iscsiadm session 
> login. Even though memory objects of a smaller size are available, the 
> large order allocation ends up failing. 
>
> The kernel prints a warning and does dump_stack, like below: 
>
> iscsid: page allocation failure: order:4, mode:0xc0d0 
> CPU: 0 PID: 2456 Comm: iscsid Not tainted 4.1.12-61.1.28.el6uek.x86_64 #2 
> Call Trace: 
>  [<ffffffff816c6e40>] dump_stack+0x63/0x83 
>  [<ffffffff8118e58a>] warn_alloc_failed+0xea/0x140 
>  [<ffffffff81191df9>] __alloc_pages_slowpath+0x409/0x760 
>  [<ffffffff81192401>] __alloc_pages_nodemask+0x2b1/0x2d0 
>  [<ffffffffa048f6c0>] ? dev_attr_host_ipaddress+0x20/0xffffffffffffc722 
>  [<ffffffff811dc38f>] alloc_pages_current+0xaf/0x170 
>  [<ffffffff81192581>] alloc_kmem_pages+0x31/0xd0 
>  [<ffffffffa048f600>] ? iscsi_transport_group+0x20/0xffffffffffffc7e2 
>  [<ffffffff811ad738>] kmalloc_order+0x18/0x50 
>  [<ffffffff811ad7a4>] kmalloc_order_trace+0x34/0xe0 
>  [<ffffffff8146ee30>] ? transport_remove_classdev+0x70/0x70 
>  [<ffffffff811e843d>] __kmalloc+0x27d/0x2a0 
>  [<ffffffff810c8cbd>] ? complete_all+0x4d/0x60 
>  [<ffffffffa04af299>] iscsi_pool_init+0x69/0x160 [libiscsi] 
>  [<ffffffff81465d90>] ? device_initialize+0xb0/0xd0 
>  [<ffffffffa04af510>] iscsi_session_setup+0x180/0x2f4 [libiscsi] 
>  [<ffffffffa04c5a60>] ? iscsi_max_lun+0x20/0xfffffffffffffa9e [iscsi_tcp] 
>  [<ffffffffa04c531f>] iscsi_sw_tcp_session_create+0xcf/0x150 [iscsi_tcp] 
>  [<ffffffffa04c5a60>] ? iscsi_max_lun+0x20/0xfffffffffffffa9e [iscsi_tcp] 
>  [<ffffffffa048a633>] iscsi_if_create_session+0x33/0xd0 
>  [<ffffffffa04c5a60>] ? iscsi_max_lun+0x20/0xfffffffffffffa9e [iscsi_tcp] 
>  [<ffffffffa048abd8>] iscsi_if_recv_msg+0x508/0x8c0 [scsi_transport_iscsi] 
>  [<ffffffff811922eb>] ? __alloc_pages_nodemask+0x19b/0x2d0 
>  [<ffffffff811e6d69>] ? __kmalloc_node_track_caller+0x209/0x2c0 
>  [<ffffffffa048b00c>] iscsi_if_rx+0x7c/0x200 [scsi_transport_iscsi] 
>  [<ffffffff81623dc6>] netlink_unicast+0x126/0x1c0 
>  [<ffffffff8162468c>] netlink_sendmsg+0x36c/0x400 
>  [<ffffffff815d2fed>] sock_sendmsg+0x4d/0x60 
>  [<ffffffff815d596a>] ___sys_sendmsg+0x30a/0x330 
>  [<ffffffff811bc72c>] ? handle_pte_fault+0x20c/0x230 
>  [<ffffffff811bc90c>] ? __handle_mm_fault+0x1bc/0x330 
>  [<ffffffff811bcb32>] ? handle_mm_fault+0xb2/0x1a0 
>  [<ffffffff815d5b99>] __sys_sendmsg+0x49/0x90 
>  [<ffffffff815d5bf9>] SyS_sendmsg+0x19/0x20 
>  [<ffffffff816cbb2e>] system_call_fastpath+0x12/0x71 
>
> Use kvzalloc for iscsi_pool in iscsi_pool_init. 
>
> Signed-off-by: Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> 
> Tested-by: Kyle Fortin <kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> 
> Reviewed-by: Joseph Slember <joe.slember-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> 
> Reviewed-by: Lance Hartmann <lance.hartmann-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> 
> --- 
>  drivers/scsi/libiscsi.c |    4 ++-- 
>  1 files changed, 2 insertions(+), 2 deletions(-) 
>
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c 
> index dd6828f..42381ad 100644 
> --- a/drivers/scsi/libiscsi.c 
> +++ b/drivers/scsi/libiscsi.c 
> @@ -2556,7 +2556,7 @@ int iscsi_eh_recover_target(struct scsi_cmnd *sc) 
>           * the array. */ 
>          if (items) 
>                  num_arrays++; 
> -        q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL); 
> +        q->pool = kvzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL); 
>          if (q->pool == NULL) 
>                  return -ENOMEM; 
>   
> @@ -2590,7 +2590,7 @@ void iscsi_pool_free(struct iscsi_pool *q) 
>   
>          for (i = 0; i < q->max; i++) 
>                  kfree(q->pool[i]); 
> -        kfree(q->pool); 
> +        kvfree(q->pool); 
>  } 
>  EXPORT_SYMBOL_GPL(iscsi_pool_free); 
>   
> -- 
> 1.7.1


Signed-off-by: Lee Duncan <lduncan-IBi9RG/b67k@public.gmane.org> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.

------=_Part_505_1028619624.1495126155935
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Wednesday, May 17, 2017 at 2:38:56 PM UTC-7, Kyle Forti=
n wrote:<blockquote class=3D"gmail_quote" style=3D"margin: 0;margin-left: 0=
.8ex;border-left: 1px #ccc solid;padding-left: 1ex;">iscsiadm session login=
 can fail with the following error:
<br>
<br>iscsiadm: Could not login to [iface: default, target: iqn.1986-03.com..=
.
<br>iscsiadm: initiator reported error (9 - internal error)
<br>
<br>When /etc/iscsi/iscsid.conf sets node.session.cmds_max =3D 4096, it res=
ults
<br>in 64K-sized kmallocs per session. =C2=A0A system under fragmented slab
<br>pressure may not have any 64K objects available and fail iscsiadm sessi=
on
<br>login. Even though memory objects of a smaller size are available, the
<br>large order allocation ends up failing.
<br>
<br>The kernel prints a warning and does dump_stack, like below:
<br>
<br>iscsid: page allocation failure: order:4, mode:0xc0d0
<br>CPU: 0 PID: 2456 Comm: iscsid Not tainted 4.1.12-61.1.28.el6uek.x86_64 =
#2
<br>Call Trace:
<br>=C2=A0[&lt;ffffffff816c6e40&gt;] dump_stack+0x63/0x83
<br>=C2=A0[&lt;ffffffff8118e58a&gt;] warn_alloc_failed+0xea/0x140
<br>=C2=A0[&lt;ffffffff81191df9&gt;] __alloc_pages_slowpath+0x409/<wbr>0x76=
0
<br>=C2=A0[&lt;ffffffff81192401&gt;] __alloc_pages_nodemask+0x2b1/<wbr>0x2d=
0
<br>=C2=A0[&lt;ffffffffa048f6c0&gt;] ? dev_attr_host_ipaddress+0x20/<wbr>0x=
ffffffffffffc722
<br>=C2=A0[&lt;ffffffff811dc38f&gt;] alloc_pages_current+0xaf/0x170
<br>=C2=A0[&lt;ffffffff81192581&gt;] alloc_kmem_pages+0x31/0xd0
<br>=C2=A0[&lt;ffffffffa048f600&gt;] ? iscsi_transport_group+0x20/<wbr>0xff=
ffffffffffc7e2
<br>=C2=A0[&lt;ffffffff811ad738&gt;] kmalloc_order+0x18/0x50
<br>=C2=A0[&lt;ffffffff811ad7a4&gt;] kmalloc_order_trace+0x34/0xe0
<br>=C2=A0[&lt;ffffffff8146ee30&gt;] ? transport_remove_classdev+<wbr>0x70/=
0x70
<br>=C2=A0[&lt;ffffffff811e843d&gt;] __kmalloc+0x27d/0x2a0
<br>=C2=A0[&lt;ffffffff810c8cbd&gt;] ? complete_all+0x4d/0x60
<br>=C2=A0[&lt;ffffffffa04af299&gt;] iscsi_pool_init+0x69/0x160 [libiscsi]
<br>=C2=A0[&lt;ffffffff81465d90&gt;] ? device_initialize+0xb0/0xd0
<br>=C2=A0[&lt;ffffffffa04af510&gt;] iscsi_session_setup+0x180/<wbr>0x2f4 [=
libiscsi]
<br>=C2=A0[&lt;ffffffffa04c5a60&gt;] ? iscsi_max_lun+0x20/<wbr>0xffffffffff=
fffa9e [iscsi_tcp]
<br>=C2=A0[&lt;ffffffffa04c531f&gt;] iscsi_sw_tcp_session_create+<wbr>0xcf/=
0x150 [iscsi_tcp]
<br>=C2=A0[&lt;ffffffffa04c5a60&gt;] ? iscsi_max_lun+0x20/<wbr>0xffffffffff=
fffa9e [iscsi_tcp]
<br>=C2=A0[&lt;ffffffffa048a633&gt;] iscsi_if_create_session+0x33/<wbr>0xd0
<br>=C2=A0[&lt;ffffffffa04c5a60&gt;] ? iscsi_max_lun+0x20/<wbr>0xffffffffff=
fffa9e [iscsi_tcp]
<br>=C2=A0[&lt;ffffffffa048abd8&gt;] iscsi_if_recv_msg+0x508/0x8c0 [scsi_tr=
ansport_iscsi]
<br>=C2=A0[&lt;ffffffff811922eb&gt;] ? __alloc_pages_nodemask+0x19b/<wbr>0x=
2d0
<br>=C2=A0[&lt;ffffffff811e6d69&gt;] ? __kmalloc_node_track_caller+<wbr>0x2=
09/0x2c0
<br>=C2=A0[&lt;ffffffffa048b00c&gt;] iscsi_if_rx+0x7c/0x200 [scsi_transport=
_iscsi]
<br>=C2=A0[&lt;ffffffff81623dc6&gt;] netlink_unicast+0x126/0x1c0
<br>=C2=A0[&lt;ffffffff8162468c&gt;] netlink_sendmsg+0x36c/0x400
<br>=C2=A0[&lt;ffffffff815d2fed&gt;] sock_sendmsg+0x4d/0x60
<br>=C2=A0[&lt;ffffffff815d596a&gt;] ___sys_sendmsg+0x30a/0x330
<br>=C2=A0[&lt;ffffffff811bc72c&gt;] ? handle_pte_fault+0x20c/0x230
<br>=C2=A0[&lt;ffffffff811bc90c&gt;] ? __handle_mm_fault+0x1bc/0x330
<br>=C2=A0[&lt;ffffffff811bcb32&gt;] ? handle_mm_fault+0xb2/0x1a0
<br>=C2=A0[&lt;ffffffff815d5b99&gt;] __sys_sendmsg+0x49/0x90
<br>=C2=A0[&lt;ffffffff815d5bf9&gt;] SyS_sendmsg+0x19/0x20
<br>=C2=A0[&lt;ffffffff816cbb2e&gt;] system_call_fastpath+0x12/0x71
<br>
<br>Use kvzalloc for iscsi_pool in iscsi_pool_init.
<br>
<br>Signed-off-by: Kyle Fortin &lt;<a href=3D"mailto:kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org=
" target=3D"_blank" rel=3D"nofollow" onmousedown=3D"this.href=3D&#39;mailto=
:kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;" onclick=3D"this.href=3D&#39;mail=
to:kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;">kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org</a>&gt;
<br>Tested-by: Kyle Fortin &lt;<a href=3D"mailto:kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" ta=
rget=3D"_blank" rel=3D"nofollow" onmousedown=3D"this.href=3D&#39;mailto:kyl=
e.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;" onclick=3D"this.href=3D&#39;mailto:k=
yle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;">kyle.fortin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org</a>&gt;
<br>Reviewed-by: Joseph Slember &lt;<a href=3D"mailto:joe.slember-QHcLZuEGTsthl2p70BpVqQ@public.gmane.org=
m" target=3D"_blank" rel=3D"nofollow" onmousedown=3D"this.href=3D&#39;mailt=
o:joe.slember-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;" onclick=3D"this.href=3D&#39;mai=
lto:joe.slember-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;">joe.slember-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org</a>&gt=
;
<br>Reviewed-by: Lance Hartmann &lt;<a href=3D"mailto:lance.hartmann@oracle=
.com" target=3D"_blank" rel=3D"nofollow" onmousedown=3D"this.href=3D&#39;ma=
ilto:lance.hartmann-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;" onclick=3D"this.href=3D&#=
39;mailto:lance.hartmann-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org&#39;;return true;">lance.hartmann@oracl=
e.com</a>&gt;
<br>---
<br>=C2=A0drivers/scsi/libiscsi.c | =C2=A0 =C2=A04 ++--
<br>=C2=A01 files changed, 2 insertions(+), 2 deletions(-)
<br>
<br>diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
<br>index dd6828f..42381ad 100644
<br>--- a/drivers/scsi/libiscsi.c
<br>+++ b/drivers/scsi/libiscsi.c
<br>@@ -2556,7 +2556,7 @@ int iscsi_eh_recover_target(struct scsi_cmnd *sc)
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * the array. */
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (items)
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0num_arrays++;
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0q-&gt;pool =3D kzalloc=
(num_arrays * max * sizeof(void*), GFP_KERNEL);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0q-&gt;pool =3D kvzallo=
c(num_arrays * max * sizeof(void*), GFP_KERNEL);
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (q-&gt;pool =
=3D=3D NULL)
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return -ENOMEM;
<br>=C2=A0
<br>@@ -2590,7 +2590,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
<br>=C2=A0
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i &=
lt; q-&gt;max; i++)
<br>=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(q-&gt;<wbr>pool[i]);
<br>-=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kfree(q-&gt;pool);
<br>+=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0kvfree(q-&gt;pool);
<br>=C2=A0}
<br>=C2=A0EXPORT_SYMBOL_GPL(iscsi_pool_<wbr>free);
<br>=C2=A0
<br>--=20
<br>1.7.1</blockquote><div><br>Signed-off-by: Lee Duncan &lt;lduncan@suse.c=
om&gt; <br></div></div>

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

------=_Part_505_1028619624.1495126155935--

------=_Part_504_40137999.1495126155935--
