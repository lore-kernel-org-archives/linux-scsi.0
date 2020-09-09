Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 176DCC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5FE22220F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 15:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fWLM8Zrs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730275AbgIIPbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:31:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45336 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730227AbgIIP3U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 11:29:20 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089Do27p174802;
        Wed, 9 Sep 2020 13:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=NfKx4V12okRAOGppflvWqr2u0BzSKI8TMQDanUB2Tyo=;
 b=fWLM8ZrsCbooCIJWKKa0LGXFRv296Vb3pRa1X56N3PKTCiahdHNGTcCb3VTBe4C2JuGv
 WlXrSwxRbjoFtKp6exJPMv+/Vr91C4rRhXwpiaBofo8Yjka+dG0uLYHAXixkLZsJxl8Y
 ZzZ1bMc1E8N2AGpr61Uz7XImeCJug43pbfy/vbvPexlE53jklSIBRdhNT+ekaNFbos17
 lBZCZ93pFCLbyyWwr5YWHjc7ZJhi9oSxtpS9zopapSufI08ef+Doykv5fSWFxL4tQ8Ub
 aIOt8Bx7ksHWSGQxaVOV+eIwkSZj7ThA+6jqBNn05IMKoVU3cYcUI5D1bqzSIAcQWkUy 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3an1snb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 13:53:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089Dp5dH037212;
        Wed, 9 Sep 2020 13:51:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 33cmk6k84d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 13:51:45 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 089DpjVw028402;
        Wed, 9 Sep 2020 13:51:45 GMT
Received: from dhcp-10-154-140-107.vpn.oracle.com (/10.154.140.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Sep 2020 06:51:45 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH 1/2] scsi: fc: Update statistics for host and rport on
 FPIN reception.
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200730061116.20111-2-njavali@marvell.com>
Date:   Wed, 9 Sep 2020 08:51:44 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <679A2425-B8A0-4714-9E24-7C0EC67B4FCC@oracle.com>
References: <20200730061116.20111-1-njavali@marvell.com>
 <20200730061116.20111-2-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=4
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=4 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090124
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 30, 2020, at 1:11 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>=20
> From: Shyam Sundar <ssundar@marvell.com>
>=20
> Add Fabric Performance Impact Notification (FPIN) stats structure to
> fc_host_attr and the fc_rport structures to maintain FPIN statistics
> for the respective entities when the LLD notifies the transport of an
> FPIN ELS.
>=20
> Add sysfs nodes to display FPIN statistics
>=20
> Specifically, this patch:
>=20
> - Adds the formal definition of FPIN descriptors
> 	* Delivery Notification Descriptor
> 	* Peer Congestion Notification Descriptor
> 	* Congestion Notification Descriptor
>=20
> - Adds the formal definition of the event types associated with them
>=20
> - Adds a structure for holding fpin stats for host & rport
>=20
> - Adds functions to parse the FPIN ELS and update the stats
>=20
> - Adds sysfs nodes to maintain FPIN stats:
> 	/sys/class/fc_host/hostXX/statistics/
> 	/sys/class/fc_remote_ports/rport-XX\:Y-Z/statistics/
>=20
> - Add stats for Congestion Signals, that are delivered to the host as
> interrupt signals, under fc_host_statistics.
>=20
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/lpfc/lpfc_attr.c    |   2 +
> drivers/scsi/qla2xxx/qla_attr.c  |   2 +
> drivers/scsi/scsi_transport_fc.c | 410 ++++++++++++++++++++++++++++++-
> include/scsi/scsi_transport_fc.h |  34 ++-
> include/uapi/scsi/fc/fc_els.h    | 114 +++++++++
> 5 files changed, 559 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_attr.c =
b/drivers/scsi/lpfc/lpfc_attr.c
> index a62c60ca6477..9fd35b90cb53 100644
> --- a/drivers/scsi/lpfc/lpfc_attr.c
> +++ b/drivers/scsi/lpfc/lpfc_attr.c
> @@ -7158,6 +7158,8 @@ struct fc_function_template =
lpfc_transport_functions =3D {
> 	.set_rport_dev_loss_tmo =3D lpfc_set_rport_loss_tmo,
> 	.show_rport_dev_loss_tmo =3D 1,
>=20
> +	.show_rport_statistics =3D 1,
> +
> 	.get_starget_port_id  =3D lpfc_get_starget_port_id,
> 	.show_starget_port_id =3D 1,
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c =
b/drivers/scsi/qla2xxx/qla_attr.c
> index 5d93ccc73153..e34623b7cb6f 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3143,6 +3143,8 @@ struct fc_function_template =
qla2xxx_transport_functions =3D {
> 	.set_rport_dev_loss_tmo =3D qla2x00_set_rport_loss_tmo,
> 	.show_rport_dev_loss_tmo =3D 1,
>=20
> +	.show_rport_statistics =3D 1,
> +
> 	.issue_fc_host_lip =3D qla2x00_issue_lip,
> 	.dev_loss_tmo_callbk =3D qla2x00_dev_loss_tmo_callbk,
> 	.terminate_rport_io =3D qla2x00_terminate_rport_io,
> diff --git a/drivers/scsi/scsi_transport_fc.c =
b/drivers/scsi/scsi_transport_fc.c
> index 2732fa65119c..587b610e13a2 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -22,6 +22,7 @@
> #include <net/netlink.h>
> #include <scsi/scsi_netlink_fc.h>
> #include <scsi/scsi_bsg_fc.h>
> +#include <uapi/scsi/fc/fc_els.h>
> #include "scsi_priv.h"
>=20
> static int fc_queue_work(struct Scsi_Host *, struct work_struct *);
> @@ -33,6 +34,10 @@ static int fc_bsg_hostadd(struct Scsi_Host *, =
struct fc_host_attrs *);
> static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
> static void fc_bsg_remove(struct request_queue *);
> static void fc_bsg_goose_queue(struct fc_rport *);
> +static void fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +			       struct fpin_stats *stats);
> +static void fc_deli_stats_update(u32 reason_code, struct fpin_stats =
*stats);
> +static void fc_cn_stats_update(u16 event_type, struct fpin_stats =
*stats);
>=20
> /*
>  * Module Parameters
> @@ -418,6 +423,7 @@ static int fc_host_setup(struct =
transport_container *tc, struct device *dev,
> 	fc_host->fabric_name =3D -1;
> 	memset(fc_host->symbolic_name, 0, =
sizeof(fc_host->symbolic_name));
> 	memset(fc_host->system_hostname, 0, =
sizeof(fc_host->system_hostname));
> +	memset(&fc_host->stats, 0, sizeof(struct fpin_stats));
>=20
> 	fc_host->tgtid_bind_type =3D FC_TGTID_BIND_BY_WWPN;
>=20
> @@ -627,6 +633,266 @@ fc_host_post_vendor_event(struct Scsi_Host =
*shost, u32 event_number,
> }
> EXPORT_SYMBOL(fc_host_post_vendor_event);
>=20
> +/**
> + * fc_find_rport_by_wwpn - find the fc_rport pointer for a given wwpn
> + * @shost:		host the fc_rport is associated with
> + * @wwpn:		wwpn of the fc_rport device
> + *
> + * Notes:
> + *	This routine assumes no locks are held on entry.
> + */
> +struct fc_rport *
> +fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 wwpn)
> +{
> +	struct fc_rport *rport, *found =3D NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
> +		if (rport->scsi_target_id =3D=3D -1)
> +			continue;
> +
> +		if (rport->port_state !=3D FC_PORTSTATE_ONLINE)
> +			continue;
> +
> +		if (rport->port_name =3D=3D wwpn)
> +			found =3D rport;
> +	}
> +
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +	return found;
> +}
> +EXPORT_SYMBOL(fc_find_rport_by_wwpn);
> +
> +static void
> +fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +		   struct fpin_stats *stats)
> +{
> +	switch (be16_to_cpu(li_desc->event_type)) {
> +	case FPIN_LI_UNKNOWN:
> +		stats->li_failure_unknown +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LINK_FAILURE:
> +		stats->li_link_failure_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LOSS_OF_SYNC:
> +		stats->li_loss_of_sync_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_LOSS_OF_SIG:
> +		stats->li_loss_of_signals_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_PRIM_SEQ_ERR:
> +		stats->li_prim_seq_err_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_INVALID_TX_WD:
> +		stats->li_invalid_tx_word_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_INVALID_CRC:
> +		stats->li_invalid_crc_count +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	case FPIN_LI_DEVICE_SPEC:
> +		stats->li_device_specific +=3D
> +		    be32_to_cpu(li_desc->event_count);
> +		break;
> +	}
> +}
> +
> +static void
> +fc_deli_stats_update(u32 deli_reason_code, struct fpin_stats *stats)
> +{
> +	switch (deli_reason_code) {
> +	case FPIN_DELI_UNKNOWN:
> +		stats->dn_unknown++;
> +		break;
> +	case FPIN_DELI_TIMEOUT:
> +		stats->dn_timeout++;
> +		break;
> +	case FPIN_DELI_UNABLE_TO_ROUTE:
> +		stats->dn_unable_to_route++;
> +		break;
> +	case FPIN_DELI_DEVICE_SPEC:
> +		stats->dn_device_specific++;
> +		break;
> +	}
> +}
> +
> +static void
> +fc_cn_stats_update(u16 event_type, struct fpin_stats *stats)
> +{
> +	switch (event_type) {
> +	case FPIN_CONGN_CLEAR:
> +		stats->cn_clear++;
> +		break;
> +	case FPIN_CONGN_LOST_CREDIT:
> +		stats->cn_lost_credit++;
> +		break;
> +	case FPIN_CONGN_CREDIT_STALL:
> +		stats->cn_credit_stall++;
> +		break;
> +	case FPIN_CONGN_OVERSUBSCRIPTION:
> +		stats->cn_oversubscription++;
> +		break;
> +	case FPIN_CONGN_DEVICE_SPEC:
> +		stats->cn_device_specific++;
> +	}
> +}
> +
> +/*
> + * fc_fpin_li_stats_update - routine to update Link Integrity
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to link integrity descriptor
> + *
> + */
> +static void
> +fc_fpin_li_stats_update(struct Scsi_Host *shost, struct fc_tlv_desc =
*tlv)
> +{
> +	u8 i;
> +	struct fc_rport *rport =3D NULL;
> +	struct fc_rport *det_rport =3D NULL, *attach_rport =3D NULL;
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);
> +	struct fc_fn_li_desc *li_desc =3D (struct fc_fn_li_desc *)tlv;
> +	u64 wwpn;
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(li_desc->detecting_wwpn));
> +	if (rport) {
> +		det_rport =3D rport;
> +		fc_li_stats_update(li_desc, &det_rport->stats);
> +	}
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(li_desc->attached_wwpn));
> +	if (rport) {
> +		attach_rport =3D rport;
> +		fc_li_stats_update(li_desc, &attach_rport->stats);
> +	}
> +
> +	if (be32_to_cpu(li_desc->pname_count) > 0) {
> +		for (i =3D 0;
> +		    i < be32_to_cpu(li_desc->pname_count);
> +		    i++) {
> +			wwpn =3D be64_to_cpu(li_desc->pname_list[i]);
> +			rport =3D fc_find_rport_by_wwpn(shost, wwpn);
> +			if (rport && rport !=3D det_rport &&
> +			    rport !=3D attach_rport) {
> +				fc_li_stats_update(li_desc, =
&rport->stats);
> +			}
> +		}
> +	}
> +
> +	if (fc_host->port_name =3D=3D =
be64_to_cpu(li_desc->attached_wwpn))
> +		fc_li_stats_update(li_desc, &fc_host->stats);
> +}
> +
> +/*
> + * fc_fpin_deli_stats_update - routine to update Delivery =
Notification
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to delivery descriptor
> + *
> + */
> +static void
> +fc_fpin_deli_stats_update(struct Scsi_Host *shost,
> +			  struct fc_tlv_desc *tlv)
> +{
> +	struct fc_rport *rport =3D NULL;
> +	struct fc_rport *det_rport =3D NULL, *attach_rport =3D NULL;
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);
> +	struct fc_fn_deli_desc *deli_desc =3D (struct fc_fn_deli_desc =
*)tlv;
> +	u32 reason_code =3D be32_to_cpu(deli_desc->deli_reason_code);
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(deli_desc->detecting_wwpn));
> +	if (rport) {
> +		det_rport =3D rport;
> +		fc_deli_stats_update(reason_code, &det_rport->stats);
> +	}
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(deli_desc->attached_wwpn));
> +	if (rport) {
> +		attach_rport =3D rport;
> +		fc_deli_stats_update(reason_code, &attach_rport->stats);
> +	}
> +
> +	if (fc_host->port_name =3D=3D =
be64_to_cpu(deli_desc->attached_wwpn))
> +		fc_deli_stats_update(reason_code, &fc_host->stats);
> +}
> +
> +/*
> + * fc_fpin_peer_congn_stats_update - routine to update Peer =
Congestion
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to peer congestion descriptor
> + *
> + */
> +static void
> +fc_fpin_peer_congn_stats_update(struct Scsi_Host *shost,
> +				struct fc_tlv_desc *tlv)
> +{
> +	u8 i;
> +	struct fc_rport *rport =3D NULL;
> +	struct fc_rport *det_rport =3D NULL, *attach_rport =3D NULL;
> +	struct fc_fn_peer_congn_desc *pc_desc =3D
> +	    (struct fc_fn_peer_congn_desc *)tlv;
> +	u16 event_type =3D be16_to_cpu(pc_desc->event_type);
> +	u64 wwpn;
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(pc_desc->detecting_wwpn));
> +	if (rport) {
> +		det_rport =3D rport;
> +		fc_cn_stats_update(event_type, &det_rport->stats);
> +	}
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(pc_desc->attached_wwpn));
> +	if (rport) {
> +		attach_rport =3D rport;
> +		fc_cn_stats_update(event_type, &attach_rport->stats);
> +	}
> +
> +	if (be32_to_cpu(pc_desc->pname_count) > 0) {
> +		for (i =3D 0;
> +		    i < be32_to_cpu(pc_desc->pname_count);
> +		    i++) {
> +			wwpn =3D be64_to_cpu(pc_desc->pname_list[i]);
> +			rport =3D fc_find_rport_by_wwpn(shost, wwpn);
> +			if (rport && rport !=3D det_rport &&
> +			    rport !=3D attach_rport) {
> +				fc_cn_stats_update(event_type,
> +						   &rport->stats);
> +			}
> +		}
> +	}
> +}
> +
> +/*
> + * fc_fpin_congn_stats_update - routine to update Congestion
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to congestion descriptor
> + *
> + */
> +static void
> +fc_fpin_congn_stats_update(struct Scsi_Host *shost,
> +			   struct fc_tlv_desc *tlv)
> +{
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);
> +	struct fc_fn_congn_desc *congn =3D (struct fc_fn_congn_desc =
*)tlv;
> +
> +	fc_cn_stats_update(be16_to_cpu(congn->event_type), =
&fc_host->stats);
> +}
> +
> /**
>  * fc_host_rcv_fpin - routine to process a received FPIN.
>  * @shost:		host the FPIN was received on
> @@ -639,8 +905,41 @@ EXPORT_SYMBOL(fc_host_post_vendor_event);
> void
> fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char =
*fpin_buf)
> {
> +	struct fc_els_fpin *fpin =3D (struct fc_els_fpin *)fpin_buf;
> +	struct fc_tlv_desc *tlv;
> +	u32 desc_cnt =3D 0, bytes_remain;
> +	u32 dtag;
> +
> +	/* Update Statistics */
> +	tlv =3D (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> +	bytes_remain =3D fpin_len - offsetof(struct fc_els_fpin, =
fpin_desc);
> +	bytes_remain =3D min_t(u32, bytes_remain, =
be32_to_cpu(fpin->desc_len));
> +
> +	while (bytes_remain >=3D FC_TLV_DESC_HDR_SZ &&
> +	       bytes_remain >=3D FC_TLV_DESC_SZ_FROM_LENGTH(tlv)) {
> +		dtag =3D be32_to_cpu(tlv->desc_tag);
> +		switch (dtag) {
> +		case ELS_DTAG_LNK_INTEGRITY:
> +			fc_fpin_li_stats_update(shost, tlv);
> +			break;
> +		case ELS_DTAG_DELIVERY:
> +			fc_fpin_deli_stats_update(shost, tlv);
> +			break;
> +		case ELS_DTAG_PEER_CONGEST:
> +			fc_fpin_peer_congn_stats_update(shost, tlv);
> +			break;
> +		case ELS_DTAG_CONGESTION:
> +			fc_fpin_congn_stats_update(shost, tlv);
> +		}
> +
> +		desc_cnt++;
> +		bytes_remain -=3D FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
> +		tlv =3D fc_tlv_next_desc(tlv);
> +	}
> +
> 	fc_host_post_fc_event(shost, fc_get_event_number(),
> -				FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, =
0);
> +			      FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, 0);
> +
> }
> EXPORT_SYMBOL(fc_host_fpin_rcv);
>=20
> @@ -990,6 +1289,61 @@ store_fc_rport_fast_io_fail_tmo(struct device =
*dev,
> static FC_DEVICE_ATTR(rport, fast_io_fail_tmo, S_IRUGO | S_IWUSR,
> 	show_fc_rport_fast_io_fail_tmo, =
store_fc_rport_fast_io_fail_tmo);
>=20
> +#define fc_rport_fpin_statistic(name)					=
\
> +static ssize_t fc_rport_fpinstat_##name(struct device *cd,		=
\
> +				  struct device_attribute *attr,	=
\
> +				  char *buf)				=
\
> +{									=
\
> +	struct fc_rport *rport =3D transport_class_to_rport(cd);		=
\
> +									=
\
> +	return snprintf(buf, 20, "0x%llx\n", rport->stats.name);	=
\
> +}									=
\
> +static FC_DEVICE_ATTR(rport, fpin_##name, 0444, =
fc_rport_fpinstat_##name, NULL)
> +
> +fc_rport_fpin_statistic(dn_unknown);
> +fc_rport_fpin_statistic(dn_timeout);
> +fc_rport_fpin_statistic(dn_unable_to_route);
> +fc_rport_fpin_statistic(dn_device_specific);
> +fc_rport_fpin_statistic(cn_clear);
> +fc_rport_fpin_statistic(cn_lost_credit);
> +fc_rport_fpin_statistic(cn_credit_stall);
> +fc_rport_fpin_statistic(cn_oversubscription);
> +fc_rport_fpin_statistic(cn_device_specific);
> +fc_rport_fpin_statistic(li_failure_unknown);
> +fc_rport_fpin_statistic(li_link_failure_count);
> +fc_rport_fpin_statistic(li_loss_of_sync_count);
> +fc_rport_fpin_statistic(li_loss_of_signals_count);
> +fc_rport_fpin_statistic(li_prim_seq_err_count);
> +fc_rport_fpin_statistic(li_invalid_tx_word_count);
> +fc_rport_fpin_statistic(li_invalid_crc_count);
> +fc_rport_fpin_statistic(li_device_specific);
> +
> +static struct attribute *fc_rport_statistics_attrs[] =3D {
> +	&device_attr_rport_fpin_dn_unknown.attr,
> +	&device_attr_rport_fpin_dn_timeout.attr,
> +	&device_attr_rport_fpin_dn_unable_to_route.attr,
> +	&device_attr_rport_fpin_dn_device_specific.attr,
> +	&device_attr_rport_fpin_li_failure_unknown.attr,
> +	&device_attr_rport_fpin_li_link_failure_count.attr,
> +	&device_attr_rport_fpin_li_loss_of_sync_count.attr,
> +	&device_attr_rport_fpin_li_loss_of_signals_count.attr,
> +	&device_attr_rport_fpin_li_prim_seq_err_count.attr,
> +	&device_attr_rport_fpin_li_invalid_tx_word_count.attr,
> +	&device_attr_rport_fpin_li_invalid_crc_count.attr,
> +	&device_attr_rport_fpin_li_device_specific.attr,
> +	&device_attr_rport_fpin_cn_clear.attr,
> +	&device_attr_rport_fpin_cn_lost_credit.attr,
> +	&device_attr_rport_fpin_cn_credit_stall.attr,
> +	&device_attr_rport_fpin_cn_oversubscription.attr,
> +	&device_attr_rport_fpin_cn_device_specific.attr,
> +	NULL
> +};
> +
> +static struct attribute_group fc_rport_statistics_group =3D {
> +	.name =3D "statistics",
> +	.attrs =3D fc_rport_statistics_attrs,
> +};
> +
>=20
> /*
>  * FC SCSI Target Attribute Management
> @@ -1743,6 +2097,38 @@ fc_host_statistic(fc_xid_not_found);
> fc_host_statistic(fc_xid_busy);
> fc_host_statistic(fc_seq_not_found);
> fc_host_statistic(fc_non_bls_resp);
> +fc_host_statistic(cn_sig_warn);
> +fc_host_statistic(cn_sig_alarm);
> +
> +#define fc_host_fpin_statistic(name)					=
\
> +static ssize_t fc_host_fpinstat_##name(struct device *cd,		=
\
> +				  struct device_attribute *attr,	=
\
> +				  char *buf)				=
\
> +{									=
\
> +	struct Scsi_Host *shost =3D transport_class_to_shost(cd);		=
\
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);	=
\
> +									=
\
> +	return snprintf(buf, 20, "0x%llx\n", fc_host->stats.name);	=
\
> +}									=
\
> +static FC_DEVICE_ATTR(host, fpin_##name, 0444, =
fc_host_fpinstat_##name, NULL)
> +
> +fc_host_fpin_statistic(dn_unknown);
> +fc_host_fpin_statistic(dn_timeout);
> +fc_host_fpin_statistic(dn_unable_to_route);
> +fc_host_fpin_statistic(dn_device_specific);
> +fc_host_fpin_statistic(cn_clear);
> +fc_host_fpin_statistic(cn_lost_credit);
> +fc_host_fpin_statistic(cn_credit_stall);
> +fc_host_fpin_statistic(cn_oversubscription);
> +fc_host_fpin_statistic(cn_device_specific);
> +fc_host_fpin_statistic(li_failure_unknown);
> +fc_host_fpin_statistic(li_link_failure_count);
> +fc_host_fpin_statistic(li_loss_of_sync_count);
> +fc_host_fpin_statistic(li_loss_of_signals_count);
> +fc_host_fpin_statistic(li_prim_seq_err_count);
> +fc_host_fpin_statistic(li_invalid_tx_word_count);
> +fc_host_fpin_statistic(li_invalid_crc_count);
> +fc_host_fpin_statistic(li_device_specific);
>=20
> static ssize_t
> fc_reset_statistics(struct device *dev, struct device_attribute *attr,
> @@ -1792,7 +2178,26 @@ static struct attribute *fc_statistics_attrs[] =
=3D {
> 	&device_attr_host_fc_xid_busy.attr,
> 	&device_attr_host_fc_seq_not_found.attr,
> 	&device_attr_host_fc_non_bls_resp.attr,
> +	&device_attr_host_cn_sig_warn.attr,
> +	&device_attr_host_cn_sig_alarm.attr,
> 	&device_attr_host_reset_statistics.attr,
> +	&device_attr_host_fpin_dn_unknown.attr,
> +	&device_attr_host_fpin_dn_timeout.attr,
> +	&device_attr_host_fpin_dn_unable_to_route.attr,
> +	&device_attr_host_fpin_dn_device_specific.attr,
> +	&device_attr_host_fpin_li_failure_unknown.attr,
> +	&device_attr_host_fpin_li_link_failure_count.attr,
> +	&device_attr_host_fpin_li_loss_of_sync_count.attr,
> +	&device_attr_host_fpin_li_loss_of_signals_count.attr,
> +	&device_attr_host_fpin_li_prim_seq_err_count.attr,
> +	&device_attr_host_fpin_li_invalid_tx_word_count.attr,
> +	&device_attr_host_fpin_li_invalid_crc_count.attr,
> +	&device_attr_host_fpin_li_device_specific.attr,
> +	&device_attr_host_fpin_cn_clear.attr,
> +	&device_attr_host_fpin_cn_lost_credit.attr,
> +	&device_attr_host_fpin_cn_credit_stall.attr,
> +	&device_attr_host_fpin_cn_oversubscription.attr,
> +	&device_attr_host_fpin_cn_device_specific.attr,
> 	NULL
> };
>=20
> @@ -1801,7 +2206,6 @@ static struct attribute_group =
fc_statistics_group =3D {
> 	.attrs =3D fc_statistics_attrs,
> };
>=20
> -
> /* Host Vport Attributes */
>=20
> static int
> @@ -2176,6 +2580,8 @@ fc_attach_transport(struct fc_function_template =
*ft)
> 	i->rport_attr_cont.ac.attrs =3D &i->rport_attrs[0];
> 	i->rport_attr_cont.ac.class =3D &fc_rport_class.class;
> 	i->rport_attr_cont.ac.match =3D fc_rport_match;
> +	if (ft->show_rport_statistics)
> +		i->rport_attr_cont.statistics =3D =
&fc_rport_statistics_group;
> 	transport_container_register(&i->rport_attr_cont);
>=20
> 	i->vport_attr_cont.ac.attrs =3D &i->vport_attrs[0];
> diff --git a/include/scsi/scsi_transport_fc.h =
b/include/scsi/scsi_transport_fc.h
> index 7db2dd783834..be7392ea9f91 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -284,6 +284,33 @@ struct fc_rport_identifiers {
> 	u32 roles;
> };
>=20
> +/*
> + * Fabric Performance Impact Notification Statistics
> + */
> +struct fpin_stats {
> +	/* Delivery */
> +	u64 dn_unknown;
> +	u64 dn_timeout;
> +	u64 dn_unable_to_route;
> +	u64 dn_device_specific;
> +
> +	/* Link Integrity */
> +	u64 li_failure_unknown;
> +	u64 li_link_failure_count;
> +	u64 li_loss_of_sync_count;
> +	u64 li_loss_of_signals_count;
> +	u64 li_prim_seq_err_count;
> +	u64 li_invalid_tx_word_count;
> +	u64 li_invalid_crc_count;
> +	u64 li_device_specific;
> +
> +	/* Congestion/Peer Congestion */
> +	u64 cn_clear;
> +	u64 cn_lost_credit;
> +	u64 cn_credit_stall;
> +	u64 cn_oversubscription;
> +	u64 cn_device_specific;
> +};
>=20
> /* Macro for use in defining Remote Port attributes */
> #define FC_RPORT_ATTR(_name,_mode,_show,_store)				=
\
> @@ -325,6 +352,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
>=20
> 	/* Dynamic Attributes */
> 	u32 dev_loss_tmo;	/* Remote Port loss timeout in seconds. =
*/
> +	struct fpin_stats stats;
>=20
> 	/* Private (Transport-managed) Attributes */
> 	u64 node_name;
> @@ -394,7 +422,6 @@ struct fc_starget_attrs {	/* aka fc_target_attrs =
*/
> #define starget_to_rport(s)			\
> 	scsi_is_fc_rport(s->dev.parent) ? dev_to_rport(s->dev.parent) : =
NULL
>=20
> -
> /*
>  * FC Local Port (Host) Statistics
>  */
> @@ -436,6 +463,9 @@ struct fc_host_statistics {
> 	u64 fc_seq_not_found;		/* seq is not found for exchange =
*/
> 	u64 fc_non_bls_resp;		/* a non BLS response frame with
> 					   a sequence responder in new =
exch */
> +	/* Host Congestion Signals */
> +	u64 cn_sig_warn;
> +	u64 cn_sig_alarm;
> };
>=20
>=20
> @@ -515,6 +545,7 @@ struct fc_host_attrs {
> 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
> 	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
> 	u32 dev_loss_tmo;
> +	struct fpin_stats stats;
>=20
> 	/* Private (Transport-managed) Attributes */
> 	enum fc_tgtid_binding_type  tgtid_bind_type;
> @@ -667,6 +698,7 @@ struct fc_function_template {
> 	unsigned long	show_rport_maxframe_size:1;
> 	unsigned long	show_rport_supported_classes:1;
> 	unsigned long   show_rport_dev_loss_tmo:1;
> +	unsigned long	show_rport_statistics:1;
>=20
> 	/*
> 	 * target dynamic attributes
> diff --git a/include/uapi/scsi/fc/fc_els.h =
b/include/uapi/scsi/fc/fc_els.h
> index 8c704e510e39..d630692a6346 100644
> --- a/include/uapi/scsi/fc/fc_els.h
> +++ b/include/uapi/scsi/fc/fc_els.h
> @@ -917,6 +917,9 @@ enum fc_els_clid_ic {
> };
>=20
>=20
> +/*
> + * Link Integrity event types
> + */
> enum fc_fpin_li_event_types {
> 	FPIN_LI_UNKNOWN =3D		0x0,
> 	FPIN_LI_LINK_FAILURE =3D		0x1,
> @@ -943,6 +946,55 @@ enum fc_fpin_li_event_types {
> 	{ FPIN_LI_DEVICE_SPEC,		"Device Specific" },		=
\
> }
>=20
> +/*
> + * Delivery event types
> + */
> +enum fc_fpin_deli_event_types {
> +	FPIN_DELI_UNKNOWN =3D		0x0,
> +	FPIN_DELI_TIMEOUT =3D		0x1,
> +	FPIN_DELI_UNABLE_TO_ROUTE =3D	0x2,
> +	FPIN_DELI_DEVICE_SPEC =3D		0xF,
> +};
> +
> +/*
> + * Initializer useful for decoding table.
> + * Please keep this in sync with the above definitions.
> + */
> +#define FC_FPIN_DELI_EVT_TYPES_INIT {					=
\
> +	{ FPIN_DELI_UNKNOWN,		"Unknown" },			=
\
> +	{ FPIN_DELI_TIMEOUT,		"Timeout" },			=
\
> +	{ FPIN_DELI_UNABLE_TO_ROUTE,	"Unable to Route" },		=
\
> +	{ FPIN_DELI_DEVICE_SPEC,	"Device Specific" },		=
\
> +}
> +
> +/*
> + * Congestion event types
> + */
> +enum fc_fpin_congn_event_types {
> +	FPIN_CONGN_CLEAR =3D		0x0,
> +	FPIN_CONGN_LOST_CREDIT =3D	0x1,
> +	FPIN_CONGN_CREDIT_STALL =3D	0x2,
> +	FPIN_CONGN_OVERSUBSCRIPTION =3D	0x3,
> +	FPIN_CONGN_DEVICE_SPEC =3D	0xF,
> +};
> +
> +/*
> + * Initializer useful for decoding table.
> + * Please keep this in sync with the above definitions.
> + */
> +#define FC_FPIN_CONGN_EVT_TYPES_INIT {					=
\
> +	{ FPIN_CONGN_CLEAR,		"Clear" },			=
\
> +	{ FPIN_CONGN_LOST_CREDIT,	"Lost Credit" },		=
\
> +	{ FPIN_CONGN_CREDIT_STALL,	"Credit Stall" },		=
\
> +	{ FPIN_CONGN_OVERSUBSCRIPTION,	"Oversubscription" },		=
\
> +	{ FPIN_CONGN_DEVICE_SPEC,	"Device Specific" },		=
\
> +}
> +
> +enum fc_fpin_congn_severity_types {
> +	FPIN_CONGN_SEVERITY_WARNING =3D	0xF1,
> +	FPIN_CONGN_SEVERITY_ERROR =3D	0xF7,
> +};
> +
>=20
> /*
>  * Link Integrity Notification Descriptor
> @@ -974,6 +1026,68 @@ struct fc_fn_li_desc {
> 					 */
> };
>=20
> +/*
> + * Delivery Notification Descriptor
> + */
> +struct fc_fn_deli_desc {
> +	__be32		desc_tag;	/* Descriptor Tag (0x00020002) =
*/
> +	__be32		desc_len;	/* Length of Descriptor (in =
bytes).
> +					 * Size of descriptor excluding
> +					 * desc_tag and desc_len fields.
> +					 */
> +	__be64		detecting_wwpn;	/* Port Name that detected event =
*/
> +	__be64		attached_wwpn;	/* Port Name of device attached =
to
> +					 * detecting Port Name
> +					 */
> +	__be32		deli_reason_code;/* see enum =
fc_fpin_deli_event_types */
> +};
> +
> +/*
> + * Peer Congestion Notification Descriptor
> + */
> +struct fc_fn_peer_congn_desc {
> +	__be32		desc_tag;	/* Descriptor Tag (0x00020003) =
*/
> +	__be32		desc_len;	/* Length of Descriptor (in =
bytes).
> +					 * Size of descriptor excluding
> +					 * desc_tag and desc_len fields.
> +					 */
> +	__be64		detecting_wwpn;	/* Port Name that detected event =
*/
> +	__be64		attached_wwpn;	/* Port Name of device attached =
to
> +					 * detecting Port Name
> +					 */
> +	__be16		event_type;	/* see enum =
fc_fpin_congn_event_types */
> +	__be16		event_modifier;	/* Implementation specific value
> +					 * describing the event type
> +					 */
> +	__be32		event_period;	/* duration (ms) of the detected
> +					 * congestion event
> +					 */
> +	__be32		pname_count;	/* number of portname_list =
elements */
> +	__be64		pname_list[0];	/* list of N_Port_Names =
accessible
> +					 * through the attached port
> +					 */
> +};
> +
> +/*
> + * Congestion Notification Descriptor
> + */
> +struct fc_fn_congn_desc {
> +	__be32		desc_tag;	/* Descriptor Tag (0x00020004) =
*/
> +	__be32		desc_len;	/* Length of Descriptor (in =
bytes).
> +					 * Size of descriptor excluding
> +					 * desc_tag and desc_len fields.
> +					 */
> +	__be16		event_type;	/* see enum =
fc_fpin_congn_event_types */
> +	__be16		event_modifier;	/* Implementation specific value
> +					 * describing the event type
> +					 */
> +	__be32		event_period;	/* duration (ms) of the detected
> +					 * congestion event
> +					 */
> +	__u8		severity;	/* command */
> +	__u8		resv[3];	/* reserved - must be zero */
> +};
> +
> /*
>  * ELS_FPIN - Fabric Performance Impact Notification
>  */
> --=20
> 2.19.0.rc0
>=20
Looks Good to me.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

