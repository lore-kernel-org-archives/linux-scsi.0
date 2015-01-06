From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio-scsi: Fix the race condition in
 virtscsi_handle_event
Date: Tue, 6 Jan 2015 09:15:49 +0200
Message-ID: <20150106071549.GA29433@redhat.com>
References: <1420437898-32419-1-git-send-email-famz@redhat.com>
 <CAHdzE-_QmNZVhmChHmy3FgRjJ692Apw2Va-SGoTz25s0fLjbvQ@mail.gmail.com>
 <20150105221059.GB23518@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752383AbbAFHQB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2015 02:16:01 -0500
Content-Disposition: inline
In-Reply-To: <20150105221059.GB23518@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: Fam Zheng <famz@redhat.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>

On Tue, Jan 06, 2015 at 12:10:59AM +0200, Michael S. Tsirkin wrote:
> On Mon, Jan 05, 2015 at 11:48:47AM -0800, Venkatesh Srinivas wrote:
> > On Sun, Jan 4, 2015 at 10:04 PM, Fam Zheng <famz@redhat.com> wrote:
> >=20
> >     There is a race condition in virtscsi_handle_event, when many d=
evice
> >     hotplug/unplug events flush in quickly.
> >=20
> >     The scsi_remove_device in virtscsi_handle_transport_reset may t=
rigger
> >     the BUG_ON in scsi_target_reap, because the state is altered be=
hind it,
> >     probably by scsi_scan_host of another event. I'm able to reprod=
uce it by
> >     repeatedly plugging and unplugging a scsi disk with the same lu=
n number.
> >=20
> >     To make is safe, the mutex added in struct virtio_scsi is held =
in
> >     virtscsi_handle_event, so that all the events are processed in =
a
> >     synchronized way. With this lock, the panic goes away.
> >=20
> >     Signed-off-by: Fam Zheng <famz@redhat.com>
> >     ---
> >     =A0drivers/scsi/virtio_scsi.c | 6 ++++++
> >     =A01 file changed, 6 insertions(+)
> >=20
> >     diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_s=
csi.c
> >     index c52bb5d..7f194d4 100644
> >     --- a/drivers/scsi/virtio_scsi.c
> >     +++ b/drivers/scsi/virtio_scsi.c
> >     @@ -110,6 +110,9 @@ struct virtio_scsi {
> >     =A0 =A0 =A0 =A0 /* CPU hotplug notifier */
> >     =A0 =A0 =A0 =A0 struct notifier_block nb;
> >=20
> >     +=A0 =A0 =A0 =A0/* Protect the hotplug/unplug event handling */
> >     +=A0 =A0 =A0 =A0struct mutex scan_lock;
> >     +
> >     =A0 =A0 =A0 =A0 /* Protected by event_vq lock */
> >     =A0 =A0 =A0 =A0 bool stop_events;
> >=20
> >     @@ -377,6 +380,7 @@ static void virtscsi_handle_event(struct wo=
rk_struct
> >     *work)
> >     =A0 =A0 =A0 =A0 struct virtio_scsi *vscsi =3D event_node->vscsi=
;
> >     =A0 =A0 =A0 =A0 struct virtio_scsi_event *event =3D &event_node=
->event;
> >=20
> >     +=A0 =A0 =A0 =A0mutex_lock(&vscsi->scan_lock);
> >     =A0 =A0 =A0 =A0 if (event->event &
> >     =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_virtio32(vscsi->vdev, VIRTIO_SCS=
I_T_EVENTS_MISSED)) {
> >     =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 event->event &=3D ~cpu_to_virti=
o32(vscsi->vdev,
> >     @@ -397,6 +401,7 @@ static void virtscsi_handle_event(struct wo=
rk_struct
> >     *work)
> >     =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("Unsupport virtio scsi e=
vent %x\n", event->event);
> >     =A0 =A0 =A0 =A0 }
> >     =A0 =A0 =A0 =A0 virtscsi_kick_event(vscsi, event_node);
> >     +=A0 =A0 =A0 =A0mutex_unlock(&vscsi->scan_lock);
> >     =A0}
> >=20
> >     =A0static void virtscsi_complete_event(struct virtio_scsi *vscs=
i, void *buf)
> >     @@ -894,6 +899,7 @@ static int virtscsi_init(struct virtio_devi=
ce *vdev,
> >     =A0 =A0 =A0 =A0 const char **names;
> >     =A0 =A0 =A0 =A0 struct virtqueue **vqs;
> >=20
> >     +=A0 =A0 =A0 =A0mutex_init(&vscsi->scan_lock);
> >     =A0 =A0 =A0 =A0 num_vqs =3D vscsi->num_queues + VIRTIO_SCSI_VQ_=
BASE;
> >     =A0 =A0 =A0 =A0 vqs =3D kmalloc(num_vqs * sizeof(struct virtque=
ue *), GFP_KERNEL);
> >     =A0 =A0 =A0 =A0 callbacks =3D kmalloc(num_vqs * sizeof(vq_callb=
ack_t *), GFP_KERNEL);
> >     --
> >     1.9.3
> >=20
> >=20
> > Nice find.
> >=20
> > This fix does have the effect of serializing all event handling via=
 scan_lock;
> > perhaps you want to instead create a singlethreaded workqueue in vi=
rtio_scsi
> > and queue handle_event there, rather than waiting on scan_lock on t=
he system
> > workqueue?
>=20
> Or use the system single-threaded wq.


I was sure we have one, but apparently not :(

Pls ignore the comment, sorry about the noise.

>=20
> > Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>
> >=20
> > -- vs;
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
