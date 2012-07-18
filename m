From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC-v3 3/4] vhost: Add vhost_scsi specific defines
Date: Wed, 18 Jul 2012 14:17:05 -0700
Message-ID: <1342646225.18004.633.camel@haakon2.linux-iscsi.org>
References: <1342573172-17421-1-git-send-email-nab@linux-iscsi.org>
	 <1342573172-17421-4-git-send-email-nab@linux-iscsi.org>
	 <20120718130518.GB5589@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20120718130518.GB5589@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-07-18 at 16:05 +0300, Michael S. Tsirkin wrote:
> On Wed, Jul 18, 2012 at 12:59:31AM +0000, Nicholas A. Bellinger wrote=
:
> > From: Nicholas Bellinger <nab@risingtidesystems.com>
> >=20
> > This patch adds the initial vhost_scsi_ioctl() callers for VHOST_SC=
SI_SET_ENDPOINT
> > and VHOST_SCSI_CLEAR_ENDPOINT respectively, and also adds struct vh=
ost_vring_target
> > that is used by tcm_vhost code when locating target ports during qe=
mu setup.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> > Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>,
> > Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
> > ---
> >  include/linux/vhost.h |    9 +++++++++
> >  1 files changed, 9 insertions(+), 0 deletions(-)
> >=20
> > diff --git a/include/linux/vhost.h b/include/linux/vhost.h
> > index e847f1e..33b313b 100644
> > --- a/include/linux/vhost.h
> > +++ b/include/linux/vhost.h
> > @@ -24,7 +24,11 @@ struct vhost_vring_state {
> >  struct vhost_vring_file {
> >  	unsigned int index;
> >  	int fd; /* Pass -1 to unbind from file. */
> > +};
> > =20
> > +struct vhost_vring_target {
>=20
> Can this be renamed vhost_scsi_target?

Done

>=20
> > +	unsigned char vhost_wwpn[224];
>=20
> 224? I am guessing ISCSI_NAME_LEN from include/scsi/iscsi_proto.h?
> Unfortunately we can't include iscsi_proto.h here as it
> is not exported to users. But let's add a comment for now.
>=20

This is actually from target/target_core_base.h:TRANSPORT_IQN_LEN.

=46ixing this up now..

> > +	unsigned short vhost_tpgt;
> >  };
> > =20
> >  struct vhost_vring_addr {
> > @@ -121,6 +125,11 @@ struct vhost_memory {
> >   * device.  This can be used to stop the ring (e.g. for migration)=
=2E */
> >  #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhos=
t_vring_file)
> > =20
> > +/* VHOST_SCSI specific defines */
> > +
> > +#define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vh=
ost_vring_target)
> > +#define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct =
vhost_vring_target)
> > +
> >  /* Feature bits */
> >  /* Log all write descriptors. Can be changed while device is activ=
e. */
>=20
> Can these go into appropriate ifdef CONFIG_TCP_VHOST please?
>=20

Mmmmm, I don't think we can do that with CONFIG_TCM_VHOST=3Dm, or at le=
ast
not with the following patch

diff --git a/include/linux/vhost.h b/include/linux/vhost.h
index 33b313b..e4b1ee3 100644
--- a/include/linux/vhost.h
+++ b/include/linux/vhost.h
@@ -125,10 +126,14 @@ struct vhost_memory {
  * device.  This can be used to stop the ring (e.g. for migration). */
 #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhost_vr=
ing_file)
=20
+#ifdef CONFIG_TCM_VHOST
+
 /* VHOST_SCSI specific defines */
=20
-#define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_=
vring_target)
-#define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct vhos=
t_vring_target)
+# define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost=
_scsi_target)
+# define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct vho=
st_scsi_target)
+
+#endif

--

drivers/vhost/tcm/tcm_vhost.c: In function =E2=80=98vhost_scsi_ioctl=E2=
=80=99:
drivers/vhost/tcm/tcm_vhost.c:970: error: =E2=80=98VHOST_SCSI_SET_ENDPO=
INT=E2=80=99 undeclared (first use in this function)
drivers/vhost/tcm/tcm_vhost.c:970: error: (Each undeclared identifier i=
s reported only once
drivers/vhost/tcm/tcm_vhost.c:970: error: for each function it appears =
in.)
drivers/vhost/tcm/tcm_vhost.c:975: error: =E2=80=98VHOST_SCSI_CLEAR_END=
POINT=E2=80=99 undeclared (first use in this function)
make[3]: *** [drivers/vhost/tcm/tcm_vhost.o] Error 1


