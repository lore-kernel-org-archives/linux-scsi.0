From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 01/13] iscsi: Resolve iscsi_proto.h naming conflicts
	with drivers/target/iscsi
Date: Sat, 23 Jul 2011 14:23:49 -0700
Message-ID: <1311456229.31450.292.camel@haakon2.linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-2-git-send-email-nab@linux-iscsi.org>
	 <alpine.LNX.2.00.1107231531310.3831@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1107231531310.3831@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2011-07-23 at 15:34 +0200, Jesper Juhl wrote:
> On Sat, 23 Jul 2011, Nicholas A. Bellinger wrote:
> 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch renames the following iscsi_proto.h structures to avoid
> > namespace issues with drivers/target/iscsi/iscsi_target_core.h:
> > 
> > *) struct iscsi_cmd -> struct iscsi_scsi_req
> > *) struct iscsi_cmd_rsp -> struct iscsi_scsi_rsp
> > *) struct iscsi_login -> struct iscsi_login_req
> > 
> > This patch includes useful ISCSI_FLAG_LOGIN_[CURRENT,NEXT]_STAGE*,
> > and ISCSI_FLAG_SNACK_TYPE_* definitions used by iscsi_target_mod, and
> > fixes the incorrect definition of struct iscsi_snack to following
> > RFC-3720 Section 10.16. SNACK Request.
> > 
> > Also, this patch updates libiscsi, iSER, be2iscsi, and bn2xi to
> > use the updated structure definitions in a handful of locations.
> > 
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
> >  drivers/scsi/be2iscsi/be_main.h              |    4 +-
> >  drivers/scsi/bnx2i/bnx2i_hwi.c               |    8 +++---
> >  drivers/scsi/libiscsi.c                      |    6 ++--
> >  include/scsi/iscsi_proto.h                   |   30 +++++++++++++++++++-------
> >  5 files changed, 32 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> > index 95a08a8..d73bab3 100644
> > --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> > +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> > @@ -271,7 +271,7 @@ int iser_send_command(struct iscsi_conn *conn,
> >  	unsigned long edtl;
> >  	int err;
> >  	struct iser_data_buf *data_buf;
> > -	struct iscsi_cmd *hdr =  (struct iscsi_cmd *)task->hdr;
> > +	struct iscsi_scsi_req *hdr =  (struct iscsi_scsi_req *)task->hdr;
> >  	struct scsi_cmnd *sc  =  task->sc;
> 
> How about getting rid of the extra spaces around the '=' while you are at 
> it?
> 

Fixing this up now..

> -     struct iscsi_cmd *hdr =  (struct iscsi_cmd *)task->hdr;
> -     struct scsi_cmnd *sc  =  task->sc;
> +     struct iscsi_scsi_req *hdr = (struct iscsi_scsi_req *)task->hdr;
> +     struct scsi_cmnd *sc = task->sc;
> 
> 
> >  	struct iser_tx_desc *tx_desc = &iser_task->desc;
> >  
> > diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
> > index 081c171..5ce5170 100644
> > --- a/drivers/scsi/be2iscsi/be_main.h
> > +++ b/drivers/scsi/be2iscsi/be_main.h
> > @@ -397,7 +397,7 @@ struct amap_pdu_data_out {
> >  };
> >  
> >  struct be_cmd_bhs {
> > -	struct iscsi_cmd iscsi_hdr;
> > +	struct iscsi_scsi_req iscsi_hdr;
> >  	unsigned char pad1[16];
> >  	struct pdu_data_out iscsi_data_pdu;
> >  	unsigned char pad2[BE_SENSE_INFO_SIZE -
> > @@ -428,7 +428,7 @@ struct be_nonio_bhs {
> >  };
> >  
> >  struct be_status_bhs {
> > -	struct iscsi_cmd iscsi_hdr;
> > +	struct iscsi_scsi_req iscsi_hdr;
> >  	unsigned char pad1[16];
> >  	/**
> >  	 * The plus 2 below is to hold the sense info length that gets
> > diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> > index 372d30c..1b160e1 100644
> > --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> > +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> > @@ -328,11 +328,11 @@ int bnx2i_send_iscsi_login(struct bnx2i_conn *bnx2i_conn,
> >  {
> >  	struct bnx2i_cmd *bnx2i_cmd;
> >  	struct bnx2i_login_request *login_wqe;
> > -	struct iscsi_login *login_hdr;
> > +	struct iscsi_login_req *login_hdr;
> >  	u32 dword;
> >  
> >  	bnx2i_cmd = (struct bnx2i_cmd *)task->dd_data;
> > -	login_hdr = (struct iscsi_login *)task->hdr;
> > +	login_hdr = (struct iscsi_login_req *)task->hdr;
> >  	login_wqe = (struct bnx2i_login_request *)
> >  						bnx2i_conn->ep->qp.sq_prod_qe;
> >  
> > @@ -1344,7 +1344,7 @@ static int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
> >  	struct bnx2i_cmd_response *resp_cqe;
> >  	struct bnx2i_cmd *bnx2i_cmd;
> >  	struct iscsi_task *task;
> > -	struct iscsi_cmd_rsp *hdr;
> > +	struct iscsi_scsi_rsp *hdr;
> >  	u32 datalen = 0;
> >  
> >  	resp_cqe = (struct bnx2i_cmd_response *)cqe;
> > @@ -1371,7 +1371,7 @@ static int bnx2i_process_scsi_cmd_resp(struct iscsi_session *session,
> >  	}
> >  	bnx2i_iscsi_unmap_sg_list(bnx2i_cmd);
> >  
> > -	hdr = (struct iscsi_cmd_rsp *)task->hdr;
> > +	hdr = (struct iscsi_scsi_rsp *)task->hdr;
> >  	resp_cqe = (struct bnx2i_cmd_response *)cqe;
> >  	hdr->opcode = resp_cqe->op_code;
> >  	hdr->max_cmdsn = cpu_to_be32(resp_cqe->max_cmd_sn);
> > diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> > index 0c550d5..9c3cb4e 100644
> > --- a/drivers/scsi/libiscsi.c
> > +++ b/drivers/scsi/libiscsi.c
> > @@ -360,7 +360,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
> >  	struct iscsi_conn *conn = task->conn;
> >  	struct iscsi_session *session = conn->session;
> >  	struct scsi_cmnd *sc = task->sc;
> > -	struct iscsi_cmd *hdr;
> > +	struct iscsi_scsi_req *hdr;
> >  	unsigned hdrlength, cmd_len;
> >  	itt_t itt;
> >  	int rc;
> > @@ -374,7 +374,7 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
> >  		if (rc)
> >  			return rc;
> >  	}
> > -	hdr = (struct iscsi_cmd *) task->hdr;
> > +	hdr = (struct iscsi_scsi_req *) task->hdr;
> 
> Kill the space after the cast
> 
> +     hdr = (struct iscsi_scsi_req *)task->hdr;
> 
> 

Ditto.

Thanks for your review Jesper!

--nab
