From: Chris Leech <cleech-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/7] Enable iSCSI offload drivers to use information from
 iface.
Date: Wed, 7 Jun 2017 09:28:39 -0700
Message-ID: <20170607162839.ludxvmddghx5ocn2@straylight.hirudinean.org>
References: <20170606180717.5007-1-robert@leblancnet.us>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <open-iscsi+bncBCYMVIPVXQMBBPGT4DEQKGQEXC2ZXKQ-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <20170606180717.5007-1-robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
List-Post: <https://groups.google.com/group/open-iscsi/post>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/open-iscsi
List-Subscribe: <https://groups.google.com/group/open-iscsi/subscribe>, <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+856124926423+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/open-iscsi/subscribe>
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Cc: lduncan-IBi9RG/b67k@public.gmane.org, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, subbu.seetharaman-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, ketan.mukadam-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jitendra.bhivare-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, QLogic-Storage-Upstream-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org, varun-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 06, 2017 at 12:07:10PM -0600, Robert LeBlanc wrote:
> This patchset enables iSCSI offload drivers to have access to the iface
> information provided by iscsid. This allows users to have more control
> of how the driver connects to the iSCSI target. iSER is updated to use
> iface.ipaddress to set the source IP address if configured. This allows
> iSER to use multiple ports on the same network or in more complicated
> routed configurations.
> 
> Since there is already a change to the function parameters, dst_addr
> is upgraded to sockaddr_storage so that it is more future proof and makes
> the size of the struct static and not dependent on checking the SA_FAMILY.
> 
> This is dependent on updates to Open-iSCSI.

Hi Robert,

I don't think that passing the iface_rec structure directly from the
iscsid internals into a netlink message is a good way to go about this.
It's really big, there's an embedded list_head with user address
pointers that needs to be left out, and there are 32/64-bit layout
differences.

Let me take a look at how you're proposing using this info for iSER, if
it makes sense I think we should come up with a better designed
structure for passing the information.

Thanks,
Chris
 
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
> 
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
>  include/scsi/scsi_transport_iscsi.h          | 100 ++++++++++++++++++++++++++-
>  17 files changed, 179 insertions(+), 39 deletions(-)
> 
> -- 
> 2.11.0
> 

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
Visit this group at https://groups.google.com/group/open-iscsi.
For more options, visit https://groups.google.com/d/optout.
