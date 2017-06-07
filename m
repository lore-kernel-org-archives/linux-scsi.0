From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/7] Enable iSCSI offload drivers to use information from
 iface.
Date: Wed, 7 Jun 2017 10:09:21 +0200
Message-ID: <7c8e211a-6105-01f8-00e3-63576fdee4d4@suse.de>
References: <20170606180717.5007-1-robert@leblancnet.us>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <open-iscsi+bncBCHZVHVFVMARBNHJ33EQKGQEO6A4JTQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
In-Reply-To: <20170606180717.5007-1-robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Content-Language: en-US
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, lduncan-IBi9RG/b67k@public.gmane.org
Cc: cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, varun-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 06/06/2017 08:07 PM, Robert LeBlanc wrote:
> This patchset enables iSCSI offload drivers to have access to the iface
> information provided by iscsid. This allows users to have more control
> of how the driver connects to the iSCSI target. iSER is updated to use
> iface.ipaddress to set the source IP address if configured. This allows
> iSER to use multiple ports on the same network or in more complicated
> routed configurations.
>=20
> Since there is already a change to the function parameters, dst_addr
> is upgraded to sockaddr_storage so that it is more future proof and makes
> the size of the struct static and not dependent on checking the SA_FAMILY=
.
>=20
> This is dependent on updates to Open-iSCSI.
>=20
> Robert LeBlanc (7):
>   scsi/scsi_transport_iscsi: Add iface struct to kernel.
>   scsi/scsi_transport_iscsi: Update ep_connect to include iface.
>   ib/iSER: Add binding to source IP address.
>   scsi/be2iscsi: Update beiscsi_ep_connect to accept iface and
>     sockaddr_storage.
>   scsi/bnx2i: Update bnx2i_ep_connect to accept iface and
>     sockaddr_storage.
>   scsi/cxgbi: Update cxgbi_ep_connect to accept iface and
>     sockaddr_storage.
>   scsi/qla4xxx: Update qla4xxx_ep_connect to accept iface and
>     sockaddr_storage.
>=20
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |  33 +++++++--
>  drivers/infiniband/ulp/iser/iscsi_iser.h     |   4 +-
>  drivers/infiniband/ulp/iser/iser_initiator.c |   1 +
>  drivers/infiniband/ulp/iser/iser_memory.c    |   1 +
>  drivers/infiniband/ulp/iser/iser_verbs.c     |   8 ++-
>  drivers/scsi/be2iscsi/be_cmds.c              |   1 +
>  drivers/scsi/be2iscsi/be_iscsi.c             |   8 ++-
>  drivers/scsi/be2iscsi/be_iscsi.h             |   5 +-
>  drivers/scsi/be2iscsi/be_main.c              |   1 +
>  drivers/scsi/be2iscsi/be_mgmt.c              |   1 +
>  drivers/scsi/bnx2i/bnx2i_hwi.c               |   1 +
>  drivers/scsi/bnx2i/bnx2i_iscsi.c             |  13 ++--
>  drivers/scsi/cxgbi/libcxgbi.c                |  15 ++--
>  drivers/scsi/cxgbi/libcxgbi.h                |   2 +-
>  drivers/scsi/qla4xxx/ql4_os.c                |  15 ++--
>  drivers/scsi/scsi_transport_iscsi.c          |   9 ++-
>  include/scsi/scsi_transport_iscsi.h          | 100 +++++++++++++++++++++=
+++++-
>  17 files changed, 179 insertions(+), 39 deletions(-)
>=20
Hmm.

That it rather large, just for passing information from userspace into
the kernel.
What is the actual benefit here?

Personally, I would rather see iscsid creating tap interfaces associated
with each iSCSI offload interface, and having the kernel accessing the
information from _that_.
Then each connection would have a network interface attached to it, and
could retrieve the information from there.
Plus we could use 'normal' userspace tools like 'ip' to configure the
iSCSI offload network.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare-l3A5Bk7waGM@public.gmane.org			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)

--=20
You received this message because you are subscribed to the Google Groups "=
open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an e=
mail to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
