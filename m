From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio-scsi: Fix the race condition in
 virtscsi_handle_event
Date: Tue, 6 Jan 2015 00:10:59 +0200
Message-ID: <20150105221059.GB23518@redhat.com>
References: <1420437898-32419-1-git-send-email-famz@redhat.com>
 <CAHdzE-_QmNZVhmChHmy3FgRjJ692Apw2Va-SGoTz25s0fLjbvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHdzE-_QmNZVhmChHmy3FgRjJ692Apw2Va-SGoTz25s0fLjbvQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: Fam Zheng <famz@redhat.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jan 05, 2015 at 11:48:47AM -0800, Venkatesh Srinivas wrote:
> On Sun, Jan 4, 2015 at 10:04 PM, Fam Zheng <famz@redhat.com> wrote:
>=20
>     There is a race condition in virtscsi_handle_event, when many dev=
ice
>     hotplug/unplug events flush in quickly.
>=20
>     The scsi_remove_device in virtscsi_handle_transport_reset may tri=
gger
>     the BUG_ON in scsi_target_reap, because the state is altered behi=
nd it,
>     probably by scsi_scan_host of another event. I'm able to reproduc=
e it by
>     repeatedly plugging and unplugging a scsi disk with the same lun =
number.
>=20
>     To make is safe, the mutex added in struct virtio_scsi is held in
>     virtscsi_handle_event, so that all the events are processed in a
>     synchronized way. With this lock, the panic goes away.
>=20
>     Signed-off-by: Fam Zheng <famz@redhat.com>
>     ---
>     =A0drivers/scsi/virtio_scsi.c | 6 ++++++
>     =A01 file changed, 6 insertions(+)
>=20
>     diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scs=
i.c
>     index c52bb5d..7f194d4 100644
>     --- a/drivers/scsi/virtio_scsi.c
>     +++ b/drivers/scsi/virtio_scsi.c
>     @@ -110,6 +110,9 @@ struct virtio_scsi {
>     =A0 =A0 =A0 =A0 /* CPU hotplug notifier */
>     =A0 =A0 =A0 =A0 struct notifier_block nb;
>=20
>     +=A0 =A0 =A0 =A0/* Protect the hotplug/unplug event handling */
>     +=A0 =A0 =A0 =A0struct mutex scan_lock;
>     +
>     =A0 =A0 =A0 =A0 /* Protected by event_vq lock */
>     =A0 =A0 =A0 =A0 bool stop_events;
>=20
>     @@ -377,6 +380,7 @@ static void virtscsi_handle_event(struct work=
_struct
>     *work)
>     =A0 =A0 =A0 =A0 struct virtio_scsi *vscsi =3D event_node->vscsi;
>     =A0 =A0 =A0 =A0 struct virtio_scsi_event *event =3D &event_node->=
event;
>=20
>     +=A0 =A0 =A0 =A0mutex_lock(&vscsi->scan_lock);
>     =A0 =A0 =A0 =A0 if (event->event &
>     =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_=
T_EVENTS_MISSED)) {
>     =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 event->event &=3D ~cpu_to_virtio3=
2(vscsi->vdev,
>     @@ -397,6 +401,7 @@ static void virtscsi_handle_event(struct work=
_struct
>     *work)
>     =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_err("Unsupport virtio scsi eve=
nt %x\n", event->event);
>     =A0 =A0 =A0 =A0 }
>     =A0 =A0 =A0 =A0 virtscsi_kick_event(vscsi, event_node);
>     +=A0 =A0 =A0 =A0mutex_unlock(&vscsi->scan_lock);
>     =A0}
>=20
>     =A0static void virtscsi_complete_event(struct virtio_scsi *vscsi,=
 void *buf)
>     @@ -894,6 +899,7 @@ static int virtscsi_init(struct virtio_device=
 *vdev,
>     =A0 =A0 =A0 =A0 const char **names;
>     =A0 =A0 =A0 =A0 struct virtqueue **vqs;
>=20
>     +=A0 =A0 =A0 =A0mutex_init(&vscsi->scan_lock);
>     =A0 =A0 =A0 =A0 num_vqs =3D vscsi->num_queues + VIRTIO_SCSI_VQ_BA=
SE;
>     =A0 =A0 =A0 =A0 vqs =3D kmalloc(num_vqs * sizeof(struct virtqueue=
 *), GFP_KERNEL);
>     =A0 =A0 =A0 =A0 callbacks =3D kmalloc(num_vqs * sizeof(vq_callbac=
k_t *), GFP_KERNEL);
>     --
>     1.9.3
>=20
>=20
> Nice find.
>=20
> This fix does have the effect of serializing all event handling via s=
can_lock;
> perhaps you want to instead create a singlethreaded workqueue in virt=
io_scsi
> and queue handle_event there, rather than waiting on scan_lock on the=
 system
> workqueue?

Or use the system single-threaded wq.


> Reviewed-by: Venkatesh Srinivas <venkateshs@google.com>
>=20
> -- vs;
