From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [PATCH 0/9] ib_srpt: Changes from RFC for v3.2-rc1 mainline merge
Date: Mon, 24 Oct 2011 05:33:33 +0000
Message-ID: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Hi Roland, Bart & Co.

The following series are patches from the last round of discussion for
the v3.2-rc1 mainline merge of ib_srpt. This includes the removal and/or
conversion of ib_srpt module parameters into per port configfs attributes,
inclusion of two bugfix patches from the SCST tree, and some other minor
changes as requested by Bart.

This leaves srp_max_req_size, srpt_srq_size, and srpt_service_guid as
module parameters.  The first two are currently required because they
are called in sprt_add_one() before the setup of individual srpt_port
endpoints, and the third apparently still needs to be global and would
not function as a per port configfs attribute.

Please have a look, and i'll be sending out a full patch again shortly
on top of target-pending.git with the other target-core patches headed 
or v3.2-rc1.

Thanks,

--nab

Bart Van Assche (2):
  ib_srpt: Fix potential out-of-bounds array access
  ib_srpt: Avoid failed multipart RDMA transfers

Nicholas Bellinger (7):
  ib_srpt: Fix srpt_alloc_fabric_acl failure case return value
  ib_srpt: Update comments to reference $driver/$port layout
  ib_srpt: Fix sport->port_guid formatting code
  ib_srpt: Remove legacy use_port_guid_in_session_name module parameter
  ib_srpt: Convert srp_max_rdma_size into per port configfs attribute
  ib_srpt: Convert srp_max_rsp_size into per port configfs attribute
  ib_srpt: Convert srpt_sq_size into per port configfs attribute

 drivers/infiniband/ulp/srpt/ib_srpt.c |  351 +++++++++++++++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.h |   41 ++++-
 2 files changed, 267 insertions(+), 125 deletions(-)

-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
