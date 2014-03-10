From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/13] T10-PI support for iSER initiator
Date: Mon, 10 Mar 2014 21:08:57 +0200
Message-ID: <CAJZOPZJ8B+f8P+1MrZ=6CnHhxQJXZ2xN+vh2Z8NNBNW2oNGjJw@mail.gmail.com>
References: <1394041431-28399-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394041431-28399-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Mar 5, 2014 at 7:43 PM, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Hey Roland, Nic, Mike and Co
>
> This patchset adds T10 protection information offload support over
> RDMA signature verbs API. This set, along with the iSER target set,
> allow end-to-end protection information passthrough and validation.
> The patchset was tested against Linux SCSI target with iSER DIF
> support applied.
>
> iSER T10-PI support enablement is currently controlled with
> module parameters (similar to lpfc for example) which make them
> global. In the next phase we can consider passing these parameters
> from iscsid nl messages, which would make them per-connection.
>
> The approach I took with respect to escalating protection information
> errors was minimal iSCSI intervention in protection information affairs.
> I added libiscsi a hook asking the transport to check the protection
> information status, and construct the proper sense data in case of errors
> (the alternative of letting the transport to construct sense data seemed
> much less appealing).
>
> Note that this patchset comes on top of a pending patch for iSER to suppress
> fastreg completions (http://marc.info/?l=linux-rdma&m=139047309831997&w=2).
>
> v0 patches are available in target-pending git repo (branch rdma-dif) and
> passed 0-DAY testing.
>
> Roland, I would like to hear your feedback on this.

Acked-By: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Roland, given that Sagi addressed all the feedback from the reviewers,
specifically from Mike Christie, and has my iser maintainer
ack on the series, can you please go ahead and apply that for 3.15?
>
> The set is ordered by the following:
> - Preparation patches (non/minor functionality changes).
> - Add protection information execution support.
> - Add protection information status check facilities.
> - Publish T10-DIF support to SCSI mid-layer according to
>   IB device capabilities.
>
> Changes from v1:
> - Removed extra space (BUG_ON).
> - Dropped DID_ABORT from sc result for data integrity errors.
> - Fixed failed sector report.
>
> Changes from v0:
> - Fix protection information dma registration for unaligned scatterlists
>   which may happen when the block layer merges bios.
> - Don't fail connections on devices without DIF support - warn and continue
>   without DIF.
> - reword FR -> FastReg
>
> Alex Tabachnik (2):
>   IB/iser: Introduce pi_enable, pi_guard module parameters
>   IB/iser: Initialize T10-PI resources
>
> Sagi Grimberg (11):
>   IB/iser: Avoid FRWR notation, use fastreg instead
>   IB/iser: Push the decision what memory key to use into fast_reg_mr
>     routine
>   IB/iser: Move fast_reg_descriptor initialization to a function
>   IB/iser: Keep IB device attributes under iser_device
>   IB/iser: Replace fastreg descriptor valid bool with indicators
>     container
>   IB/iser: Generalize iser_unmap_task_data and
>     finalize_rdma_unaligned_sg
>   IB/iser: Generalize fall_to_bounce_buf routine
>   IB/iser: Support T10-PI operations
>   SCSI/libiscsi: Add check_protection callback for transports
>   IB/iser: Implement check_protection
>   IB/iser: Publish T10-PI support to SCSI midlayer
>
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |   46 +++-
>  drivers/infiniband/ulp/iser/iscsi_iser.h     |   71 ++++-
>  drivers/infiniband/ulp/iser/iser_initiator.c |   98 +++++-
>  drivers/infiniband/ulp/iser/iser_memory.c    |  445 +++++++++++++++++++-------
>  drivers/infiniband/ulp/iser/iser_verbs.c     |  287 ++++++++++++-----
>  drivers/scsi/libiscsi.c                      |   32 ++
>  include/scsi/libiscsi.h                      |    4 +
>  include/scsi/scsi_transport_iscsi.h          |    1 +
>  8 files changed, 771 insertions(+), 213 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
