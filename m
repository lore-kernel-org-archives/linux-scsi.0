From: Eric Northup <digitaleric@google.com>
Subject: Re: [RFC-v5] tcm_vhost: Initial merge for vhost level
	target fabric driver
Date: Tue, 31 Jul 2012 13:52:12 -0700
Message-ID: <CAG7+5M35QAK=ggAJRZtga0PWw5VZFi-mraKEAkWiq16U3ysxjg@mail.gmail.com>
References: <1343346200-19850-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary=20cf307c9b8c4d757e04c6265aca
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <1343346200-19850-1-git-send-email-nab@linux-iscsi.org>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Anthony Liguori <aliguori@us.ibm.com>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, qemu-devel <qemu-devel@nongnu.org>, lf-virt <virtualization@lists.linux-foundation.org>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

--20cf307c9b8c4d757e04c6265aca
Content-Type: text/plain; charset=ISO-8859-1

On Thu, Jul 26, 2012 at 4:43 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org>wrote:

> [...]
> +static void vhost_scsi_handle_vq(struct vhost_scsi *vs)
> +{
> +       struct vhost_virtqueue *vq = &vs->vqs[2];
> +       struct virtio_scsi_cmd_req v_req;
> +       struct tcm_vhost_tpg *tv_tpg;
> +       struct tcm_vhost_cmd *tv_cmd;
> +       u32 exp_data_len, data_first, data_num, data_direction;
> +       unsigned out, in, i;
> +       int head, ret;
> +
> +       /* Must use ioctl VHOST_SCSI_SET_ENDPOINT */
> +       tv_tpg = vs->vs_tpg;
> +       if (unlikely(!tv_tpg)) {
> +               pr_err("%s endpoint not set\n", __func__);
> +               return;
> +       }
> +
> +       mutex_lock(&vq->mutex);
> +       vhost_disable_notify(&vs->dev, vq);
> +
> +       for (;;) {
> +               head = vhost_get_vq_desc(&vs->dev, vq, vq->iov,
> +                                       ARRAY_SIZE(vq->iov), &out, &in,
> +                                       NULL, NULL);
> +               pr_debug("vhost_get_vq_desc: head: %d, out: %u in: %u\n",
> +                                       head, out, in);
> +               /* On error, stop handling until the next kick. */
> +               if (unlikely(head < 0))
> +                       break;
> +               /* Nothing new?  Wait for eventfd to tell us they
> refilled. */
> +               if (head == vq->num) {
> +                       if (unlikely(vhost_enable_notify(&vs->dev, vq))) {
> +                               vhost_disable_notify(&vs->dev, vq);
> +                               continue;
> +                       }
> +                       break;
> +               }
> +
> +/* FIXME: BIDI operation */
> +               if (out == 1 && in == 1) {
>

It seems to me like this is not the way that virtio devices are supposed to
behave - if a guest splits a virtio_scsi_cmd_req or _resp across a page
boundary, then this code won't work.

Quoting the 'Message Framing' part of the virtio spec:

"In particular, no implementation should use the descriptor boundaries to
determine the size of any header in a request. "


+                       data_direction = DMA_NONE;
> +                       data_first = 0;
> +                       data_num = 0;
> +               } else if (out == 1 && in > 1) {
> +                       data_direction = DMA_FROM_DEVICE;
> +                       data_first = out + 1;
> +                       data_num = in - 1;
> +               } else if (out > 1 && in == 1) {
> +                       data_direction = DMA_TO_DEVICE;
> +                       data_first = 1;
> +                       data_num = out - 1;
> +               } else {
> +                       vq_err(vq, "Invalid buffer layout out: %u in:
> %u\n",
> +                                       out, in);
> +                       break;
> +               }
> +
> +               /*
> +                * Check for a sane resp buffer so we can report errors to
> +                * the guest.
> +                */
> +               if (unlikely(vq->iov[out].iov_len !=
> +                                       sizeof(struct
> virtio_scsi_cmd_resp))) {
> +                       vq_err(vq, "Expecting virtio_scsi_cmd_resp, got
> %zu"
> +                               " bytes\n", vq->iov[out].iov_len);
> +                       break;
> +               }
> +
> +               if (unlikely(vq->iov[0].iov_len != sizeof(v_req))) {
> +                       vq_err(vq, "Expecting virtio_scsi_cmd_req, got %zu"
> +                               " bytes\n", vq->iov[0].iov_len);
> +                       break;
> +               }
> +               pr_debug("Calling __copy_from_user: vq->iov[0].iov_base:
> %p,"
> +                       " len: %zu\n", vq->iov[0].iov_base, sizeof(v_req));
> +               ret = __copy_from_user(&v_req, vq->iov[0].iov_base,
> +                               sizeof(v_req));
> +               if (unlikely(ret)) {
> +                       vq_err(vq, "Faulted on virtio_scsi_cmd_req\n");
> +                       break;
> +               }
> +
> +               exp_data_len = 0;
> +               for (i = 0; i < data_num; i++)
> +                       exp_data_len += vq->iov[data_first + i].iov_len;
> +
> +               tv_cmd = vhost_scsi_allocate_cmd(tv_tpg, &v_req,
> +                                       exp_data_len, data_direction);
> +               if (IS_ERR(tv_cmd)) {
> +                       vq_err(vq, "vhost_scsi_allocate_cmd failed %ld\n",
> +                                       PTR_ERR(tv_cmd));
> +                       break;
> +               }
> +               pr_debug("Allocated tv_cmd: %p exp_data_len: %d,
> data_direction"
> +                       ": %d\n", tv_cmd, exp_data_len, data_direction);
> +
> +               tv_cmd->tvc_vhost = vs;
> +
> +               if (unlikely(vq->iov[out].iov_len !=
> +                               sizeof(struct virtio_scsi_cmd_resp))) {
> +                       vq_err(vq, "Expecting virtio_scsi_cmd_resp, got
> %zu"
> +                               " bytes, out: %d, in: %d\n",
> +                               vq->iov[out].iov_len, out, in);
> +                       break;
> +               }
> +
> +               tv_cmd->tvc_resp = vq->iov[out].iov_base;
> +
> +               /*
> +                * Copy in the recieved CDB descriptor into tv_cmd->tvc_cdb
> +                * that will be used by tcm_vhost_new_cmd_map() and down
> into
> +                * target_setup_cmd_from_cdb()
> +                */
> +               memcpy(tv_cmd->tvc_cdb, v_req.cdb, TCM_VHOST_MAX_CDB_SIZE);
> +               /*
> +                * Check that the recieved CDB size does not exceeded our
> +                * hardcoded max for tcm_vhost
> +                */
> +               /* TODO what if cdb was too small for varlen cdb header? */
> +               if (unlikely(scsi_command_size(tv_cmd->tvc_cdb) >
> +                                       TCM_VHOST_MAX_CDB_SIZE)) {
> +                       vq_err(vq, "Received SCSI CDB with command_size:
> %d that"
> +                               " exceeds SCSI_MAX_VARLEN_CDB_SIZE: %d\n",
> +                               scsi_command_size(tv_cmd->tvc_cdb),
> +                               TCM_VHOST_MAX_CDB_SIZE);
> +                       break; /* TODO */
> +               }
> +               tv_cmd->tvc_lun = ((v_req.lun[2] << 8) | v_req.lun[3]) &
> 0x3FFF;
> +
> +               pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
> +                       tv_cmd->tvc_cdb[0], tv_cmd->tvc_lun);
> +
> +               if (data_direction != DMA_NONE) {
> +                       ret = vhost_scsi_map_iov_to_sgl(tv_cmd,
> +                                       &vq->iov[data_first], data_num,
> +                                       data_direction == DMA_TO_DEVICE);
> +                       if (unlikely(ret)) {
> +                               vq_err(vq, "Failed to map iov to sgl\n");
> +                               break; /* TODO */
> +                       }
> +               }
> +
> +               /*
> +                * Save the descriptor from vhost_get_vq_desc() to be used
> to
> +                * complete the virtio-scsi request in TCM callback
> context via
> +                * tcm_vhost_queue_data_in() and tcm_vhost_queue_status()
> +                */
> +               tv_cmd->tvc_vq_desc = head;
> +               /*
> +                * Dispatch tv_cmd descriptor for cmwq execution in process
> +                * context provided by tcm_vhost_workqueue.  This also
> ensures
> +                * tv_cmd is executed on the same kworker CPU as this vhost
> +                * thread to gain positive L2 cache locality effects..
> +                */
> +               INIT_WORK(&tv_cmd->work, tcm_vhost_submission_work);
> +               queue_work(tcm_vhost_workqueue, &tv_cmd->work);
> +       }
> +
> +       mutex_unlock(&vq->mutex);
> +}
> [...]
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Typing one-handed, please don't mistake brevity for rudeness.

--20cf307c9b8c4d757e04c6265aca
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div class=3D"gmail_quote">On Thu, Jul 26, 2012 at 4:43 PM, Nicholas A. Bel=
linger <span dir=3D"ltr">&lt;<a href=3D"mailto:nab@linux-iscsi.org" target=
=3D"_blank">nab@linux-iscsi.org</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">
[...]<br>
+static void vhost_scsi_handle_vq(struct vhost_scsi *vs)<br>
+{<br>
+ =A0 =A0 =A0 struct vhost_virtqueue *vq =3D &amp;vs-&gt;vqs[2];<br>
+ =A0 =A0 =A0 struct virtio_scsi_cmd_req v_req;<br>
+ =A0 =A0 =A0 struct tcm_vhost_tpg *tv_tpg;<br>
+ =A0 =A0 =A0 struct tcm_vhost_cmd *tv_cmd;<br>
+ =A0 =A0 =A0 u32 exp_data_len, data_first, data_num, data_direction;<br>
+ =A0 =A0 =A0 unsigned out, in, i;<br>
+ =A0 =A0 =A0 int head, ret;<br>
+<br>
+ =A0 =A0 =A0 /* Must use ioctl VHOST_SCSI_SET_ENDPOINT */<br>
+ =A0 =A0 =A0 tv_tpg =3D vs-&gt;vs_tpg;<br>
+ =A0 =A0 =A0 if (unlikely(!tv_tpg)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err(&quot;%s endpoint not set\n&quot;, __f=
unc__);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;<br>
+ =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 mutex_lock(&amp;vq-&gt;mutex);<br>
+ =A0 =A0 =A0 vhost_disable_notify(&amp;vs-&gt;dev, vq);<br>
+<br>
+ =A0 =A0 =A0 for (;;) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 head =3D vhost_get_vq_desc(&amp;vs-&gt;dev, v=
q, vq-&gt;iov,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 ARRAY_SIZE(vq-&gt;iov), &amp;out, &amp;in,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 NULL, NULL);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_debug(&quot;vhost_get_vq_desc: head: %d, o=
ut: %u in: %u\n&quot;,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 head, out, in);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* On error, stop handling until the next kic=
k. */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(head &lt; 0))<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Nothing new? =A0Wait for eventfd to tell u=
s they refilled. */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (head =3D=3D vq-&gt;num) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(vhost_enable_not=
ify(&amp;vs-&gt;dev, vq))) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vhost_disable=
_notify(&amp;vs-&gt;dev, vq);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 continue;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+/* FIXME: BIDI operation */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (out =3D=3D 1 &amp;&amp; in =3D=3D 1) {<br=
></blockquote><div><br></div><div>It seems to me like this is not the way t=
hat virtio devices are supposed to behave - if a guest splits a virtio_scsi=
_cmd_req or _resp across a page boundary, then this code won&#39;t work.</d=
iv>
<div><br></div><div>Quoting the &#39;Message Framing&#39; part of the virti=
o spec:</div><div><br></div><div>&quot;In particular, no implementation sho=
uld use the descriptor boundaries to determine the size of any header in a =
request. &quot;</div>
<div><br></div><div><br></div><blockquote class=3D"gmail_quote" style=3D"ma=
rgin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_direction =3D DMA_NONE;<=
br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_first =3D 0;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_num =3D 0;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (out =3D=3D 1 &amp;&amp; in &gt; 1)=
 {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_direction =3D DMA_FROM_D=
EVICE;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_first =3D out + 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_num =3D in - 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (out &gt; 1 &amp;&amp; in =3D=3D 1)=
 {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_direction =3D DMA_TO_DEV=
ICE;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_first =3D 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 data_num =3D out - 1;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &quot;Invalid buff=
er layout out: %u in: %u\n&quot;,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 out, in);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Check for a sane resp buffer so we can r=
eport errors to<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* the guest.<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(vq-&gt;iov[out].iov_len !=3D<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 sizeof(struct virtio_scsi_cmd_resp))) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &quot;Expecting vi=
rtio_scsi_cmd_resp, got %zu&quot;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot; bytes\=
n&quot;, vq-&gt;iov[out].iov_len);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(vq-&gt;iov[0].iov_len !=3D sizeo=
f(v_req))) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &quot;Expecting vi=
rtio_scsi_cmd_req, got %zu&quot;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot; bytes\=
n&quot;, vq-&gt;iov[0].iov_len);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_debug(&quot;Calling __copy_from_user: vq-&=
gt;iov[0].iov_base: %p,&quot;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot; len: %zu\n&quot;, vq-&=
gt;iov[0].iov_base, sizeof(v_req));<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D __copy_from_user(&amp;v_req, vq-&gt;i=
ov[0].iov_base,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(v_req)=
);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(ret)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &quot;Faulted on v=
irtio_scsi_cmd_req\n&quot;);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 exp_data_len =3D 0;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i &lt; data_num; i++)<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 exp_data_len +=3D vq-&gt;iov[=
data_first + i].iov_len;<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv_cmd =3D vhost_scsi_allocate_cmd(tv_tpg, &a=
mp;v_req,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 exp_data_len, data_direction);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(tv_cmd)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &quot;vhost_scsi_a=
llocate_cmd failed %ld\n&quot;,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 PTR_ERR(tv_cmd));<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_debug(&quot;Allocated tv_cmd: %p exp_data_=
len: %d, data_direction&quot;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot;: %d\n&quot;, tv_cmd, e=
xp_data_len, data_direction);<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv_cmd-&gt;tvc_vhost =3D vs;<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(vq-&gt;iov[out].iov_len !=3D<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct=
 virtio_scsi_cmd_resp))) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &quot;Expecting vi=
rtio_scsi_cmd_resp, got %zu&quot;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot; bytes,=
 out: %d, in: %d\n&quot;,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq-&gt;iov[ou=
t].iov_len, out, in);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv_cmd-&gt;tvc_resp =3D vq-&gt;iov[out].iov_b=
ase;<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Copy in the recieved CDB descriptor into=
 tv_cmd-&gt;tvc_cdb<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* that will be used by tcm_vhost_new_cmd_m=
ap() and down into<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* target_setup_cmd_from_cdb()<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(tv_cmd-&gt;tvc_cdb, v_req.cdb, TCM_VHO=
ST_MAX_CDB_SIZE);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Check that the recieved CDB size does no=
t exceeded our<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* hardcoded max for tcm_vhost<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* TODO what if cdb was too small for varlen =
cdb header? */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(scsi_command_size(tv_cmd-&gt;tvc=
_cdb) &gt;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 TCM_VHOST_MAX_CDB_SIZE)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &quot;Received SCS=
I CDB with command_size: %d that&quot;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &quot; exceed=
s SCSI_MAX_VARLEN_CDB_SIZE: %d\n&quot;,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scsi_command_=
size(tv_cmd-&gt;tvc_cdb),<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 TCM_VHOST_MAX=
_CDB_SIZE);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break; /* TODO */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv_cmd-&gt;tvc_lun =3D ((v_req.lun[2] &lt;&lt=
; 8) | v_req.lun[3]) &amp; 0x3FFF;<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_debug(&quot;vhost_scsi got command opcode:=
 %#02x, lun: %d\n&quot;,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv_cmd-&gt;tvc_cdb[0], tv_cmd=
-&gt;tvc_lun);<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (data_direction !=3D DMA_NONE) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D vhost_scsi_map_iov_to=
_sgl(tv_cmd,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 &amp;vq-&gt;iov[data_first], data_num,<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 data_direction =3D=3D DMA_TO_DEVICE);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(ret)) {<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vq_err(vq, &q=
uot;Failed to map iov to sgl\n&quot;);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break; /* TOD=
O */<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Save the descriptor from vhost_get_vq_de=
sc() to be used to<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* complete the virtio-scsi request in TCM =
callback context via<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* tcm_vhost_queue_data_in() and tcm_vhost_=
queue_status()<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 tv_cmd-&gt;tvc_vq_desc =3D head;<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* Dispatch tv_cmd descriptor for cmwq exec=
ution in process<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* context provided by tcm_vhost_workqueue.=
 =A0This also ensures<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* tv_cmd is executed on the same kworker C=
PU as this vhost<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* thread to gain positive L2 cache localit=
y effects..<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 INIT_WORK(&amp;tv_cmd-&gt;work, tcm_vhost_sub=
mission_work);<br>
+ =A0 =A0 =A0 =A0 =A0 =A0 =A0 queue_work(tcm_vhost_workqueue, &amp;tv_cmd-&=
gt;work);<br>
+ =A0 =A0 =A0 }<br>
+<br>
+ =A0 =A0 =A0 mutex_unlock(&amp;vq-&gt;mutex);<br>
+}<br>[...]<span class=3D"HOEnZb"><font color=3D"#888888"><br>
--<br>
To unsubscribe from this list: send the line &quot;unsubscribe kvm&quot; in=
<br>
the body of a message to <a href=3D"mailto:majordomo@vger.kernel.org">major=
domo@vger.kernel.org</a><br>
More majordomo info at =A0<a href=3D"http://vger.kernel.org/majordomo-info.=
html" target=3D"_blank">http://vger.kernel.org/majordomo-info.html</a><br>
</font></span></blockquote></div><br><br clear=3D"all"><div><br></div>-- <b=
r>Typing one-handed, please don&#39;t mistake brevity for rudeness.<br>

--20cf307c9b8c4d757e04c6265aca--
