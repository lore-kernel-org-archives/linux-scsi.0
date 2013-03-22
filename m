From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 03/11] iscsi-target: Add iser-target parameter keys +
 setup during login
Date: Fri, 22 Mar 2013 15:57:55 -0700
Message-ID: <1363993075.30339.37.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-4-git-send-email-nab@linux-iscsi.org>
	 <514C938F.30301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48656 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423359Ab3CVW56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Mar 2013 18:57:58 -0400
In-Reply-To: <514C938F.30301@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Fri, 2013-03-22 at 10:23 -0700, Andy Grover wrote:
> On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds RDMAExtensions, InitiatorRecvDataSegmentLength and
> > TargetRecvDataSegmentLength parameters keys necessary for iser-target
> > login to occur.
> >
> > This includes setting the necessary parameters during login path
> > code within iscsi_login_zero_tsih_s2(), and currently PAGE_SIZE
> > aligning the target's advertised MRDSL for immediate data and
> > unsolicited data-out incoming payloads.
> >
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/iscsi/iscsi_target_core.h       |   10 +++
> >   drivers/target/iscsi/iscsi_target_login.c      |   69 +++++++++++++++++++---
> >   drivers/target/iscsi/iscsi_target_parameters.c |   75 ++++++++++++++++++++++--
> >   drivers/target/iscsi/iscsi_target_parameters.h |   16 +++++-
> >   4 files changed, 156 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
> > index 2587677..553cc1a 100644
> > --- a/drivers/target/iscsi/iscsi_target_core.h
> > +++ b/drivers/target/iscsi/iscsi_target_core.h
> > @@ -244,6 +244,11 @@ struct iscsi_conn_ops {
> >   	u8	IFMarker;			/* [0,1] == [No,Yes] */
> >   	u32	OFMarkInt;			/* [1..65535] */
> >   	u32	IFMarkInt;			/* [1..65535] */
> > +	/*
> > +	 * iSER specific connection parameters
> > +	 */
> > +	u32	InitiatorRecvDataSegmentLength;	/* [512..2**24-1] */
> > +	u32	TargetRecvDataSegmentLength;	/* [512..2**24-1] */
> >   };
> >
> >   struct iscsi_sess_ops {
> > @@ -265,6 +270,10 @@ struct iscsi_sess_ops {
> >   	u8	DataSequenceInOrder;		/* [0,1] == [No,Yes] */
> >   	u8	ErrorRecoveryLevel;		/* [0..2] */
> >   	u8	SessionType;			/* [0,1] == [Normal,Discovery]*/
> > +	/*
> > +	 * iSER specific session parameters
> > +	 */
> > +	u8	RDMAExtentions;			/* [0,1] == [No,Yes] */
> 
> Typo throughout.
> 

Whoops..  Fixed.

> >   };
> >
> >   struct iscsi_queue_req {
> > @@ -284,6 +293,7 @@ struct iscsi_data_count {
> >   };
> >
> >   struct iscsi_param_list {
> > +	bool			iser;
> >   	struct list_head	param_list;
> >   	struct list_head	extra_response_list;
> >   };
> > diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> > index 9354a5f..bc4e0f8 100644
> > --- a/drivers/target/iscsi/iscsi_target_login.c
> > +++ b/drivers/target/iscsi/iscsi_target_login.c
> > @@ -343,6 +343,7 @@ static int iscsi_login_zero_tsih_s2(
> >   	struct iscsi_node_attrib *na;
> >   	struct iscsi_session *sess = conn->sess;
> >   	unsigned char buf[32];
> > +	bool iser = false;
> >
> >   	sess->tpg = conn->tpg;
> >
> > @@ -364,7 +365,10 @@ static int iscsi_login_zero_tsih_s2(
> >   		return -1;
> >   	}
> >
> > -	iscsi_set_keys_to_negotiate(0, conn->param_list);
> > +	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
> > +		iser = true;
> > +
> > +	iscsi_set_keys_to_negotiate(conn->param_list, iser);
> >
> >   	if (sess->sess_ops->SessionType)
> >   		return iscsi_set_keys_irrelevant_for_discovery(
> > @@ -402,6 +406,56 @@ static int iscsi_login_zero_tsih_s2(
> >
> >   	if (iscsi_login_disable_FIM_keys(conn->param_list, conn) < 0)
> >   		return -1;
> > +	/*
> > +	 * Set RDMAExtensions=Yes by default for iSER enabled network portals
> > +	 */
> > +	if (iser == true) {
> 
> if (iser) {

Changed.

> 
> > +		struct iscsi_param *param;
> > +		unsigned long mrdsl, off;
> > +		int rc;
> > +
> > +		sprintf(buf, "RDMAExtensions=Yes");
> > +		if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
> > +			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
> > +				ISCSI_LOGIN_STATUS_NO_RESOURCES);
> > +			return -1;
> > +		}
> > +		/*
> > +		 * Make MaxRecvDataSegmentLength PAGE_SIZE aligned for
> > +		 * Immediate Data + Unsolicitied Data-OUT if necessary..
> > +		 */
> > +		param = iscsi_find_param_from_key("MaxRecvDataSegmentLength",
> > +						  conn->param_list);
> > +		if (!param) {
> > +			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
> > +				ISCSI_LOGIN_STATUS_NO_RESOURCES);
> > +			return -1;
> > +		}
> > +		rc = strict_strtoul(param->value, 0, &mrdsl);
> > +		if (rc < 0) {
> > +			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
> > +				ISCSI_LOGIN_STATUS_NO_RESOURCES);
> > +			return -1;
> > +		}
> > +		off = mrdsl % PAGE_SIZE;
> > +		if (!off)
> > +			return 0;
> > +
> > +		if (mrdsl < PAGE_SIZE)
> > +			mrdsl = PAGE_SIZE;
> > +		else
> > +			mrdsl -= off;
> 
> Is there some PAGE_ROUND_DOWN macro we might use here?
> 

Not AFAICT in current code..

> > +
> > +		pr_warn("Aligning ISER MaxRecvDataSegmentLength: %lu down"
> > +			" to PAGE_SIZE\n", mrdsl);
> > +
> > +		sprintf(buf, "MaxRecvDataSegmentLength=%lu\n", mrdsl);
> > +		if (iscsi_change_param_value(buf, conn->param_list, 0) < 0) {
> > +			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
> > +				ISCSI_LOGIN_STATUS_NO_RESOURCES);
> > +			return -1;
> > +		}
> > +	}
> >
> >   	return 0;
> >   }
> > @@ -481,6 +535,7 @@ static int iscsi_login_non_zero_tsih_s2(
> >   	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
> >   	struct se_session *se_sess, *se_sess_tmp;
> >   	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
> > +	bool iser = false;
> >
> >   	spin_lock_bh(&se_tpg->session_lock);
> >   	list_for_each_entry_safe(se_sess, se_sess_tmp, &se_tpg->tpg_sess_list,
> > @@ -530,7 +585,10 @@ static int iscsi_login_non_zero_tsih_s2(
> >   		return -1;
> >   	}
> >
> > -	iscsi_set_keys_to_negotiate(0, conn->param_list);
> > +	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND)
> > +		iser = true;
> 
> Can we avoid type checks in the transport-neutral code?
> 

For this case, not AFAICT.  As sess->sess_ops->RDMAExtensions has not
been setup yet.

> > +
> > +	iscsi_set_keys_to_negotiate(conn->param_list, iser);
> 
> Maybe it's too ugly to go that far, but it might be nicer to pass 
> conn_transport to this fn and check transport_type inside, instead of 
> passing the iser bool.
> 

I'd like to avoid any more transport_type other than the single one
mentioned above.

Thanks,

--nab


