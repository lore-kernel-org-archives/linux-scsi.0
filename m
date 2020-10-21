Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC83C55178
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C147322249
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:57:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Sv9nbCZo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443813AbgJUO5m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 10:57:42 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51810 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443811AbgJUO5m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 10:57:42 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEoNEh151477;
        Wed, 21 Oct 2020 14:57:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=14VTLRQURNWnNtLjImUoy3T2IIST+LOHqKZqdyKQLM8=;
 b=Sv9nbCZoROhd/wbcddP+CADwu1/gwvqxIVtr8nIMuuBQy0HSiMPRbSxJEtl8QbTlr4yg
 CZ4soS2hQcVusRqOXRMGvLtUgGtmhuVb5zEXBDTTtMiJ6w2q9TMkrFuEBjVJBqK+Hcph
 /y9erlLz62wKu+J7YH4RDRDNhr8P0vtQNmjSDs1KMejDxpHON5ZSThW/or+mCvHqfFg6
 GZksW+A2bQd2tCRhRu21Z6jmKKObVB7S6Ri2rqkMMhPyfsch0DAgBAXMV7z3p02+HZIr
 s9L2MP/TwRiyrVzY9Vp1YxQCVoJJQwSpIjFnbckrFwS70c8pZ79P7z9WybSb0n0apNu+ cg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34ak16ha5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Oct 2020 14:57:38 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEnv9a132367;
        Wed, 21 Oct 2020 14:55:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34ak18rt1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 14:55:37 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09LEtb44030601;
        Wed, 21 Oct 2020 14:55:37 GMT
Received: from [192.168.1.6] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 07:55:36 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 3/5] scsi: fc: Parse FPIN packets and update statistics
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201021092715.22669-4-njavali@marvell.com>
Date:   Wed, 21 Oct 2020 09:55:36 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <C02263A2-FD40-4A57-BF52-5D9B171DD3AE@oracle.com>
References: <20201021092715.22669-1-njavali@marvell.com>
 <20201021092715.22669-4-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 impostorscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010210113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2020, at 4:27 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>=20
> From: Shyam Sundar <ssundar@marvell.com>
>=20
> Parse the incoming FPIN packets and update the host and rport FPIN
> statistics based on the FPINs.
>=20
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/scsi_transport_fc.c | 293 +++++++++++++++++++++++++++++++
> include/scsi/scsi_transport_fc.h |   1 +
> 2 files changed, 294 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c =
b/drivers/scsi/scsi_transport_fc.c
> index 501e165ae6f1..4dfa0e40d8e5 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -34,6 +34,11 @@ static int fc_bsg_hostadd(struct Scsi_Host *, =
struct fc_host_attrs *);
> static int fc_bsg_rportadd(struct Scsi_Host *, struct fc_rport *);
> static void fc_bsg_remove(struct request_queue *);
> static void fc_bsg_goose_queue(struct fc_rport *);
> +static void fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +			       struct fc_fpin_stats *stats);
> +static void fc_delivery_stats_update(u32 reason_code,
> +				     struct fc_fpin_stats *stats);
> +static void fc_cn_stats_update(u16 event_type, struct fc_fpin_stats =
*stats);
>=20
> /*
>  * Module Parameters
> @@ -630,6 +635,262 @@ fc_host_post_vendor_event(struct Scsi_Host =
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
> +	struct fc_rport *rport;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(shost->host_lock, flags);
> +
> +	list_for_each_entry(rport, &fc_host_rports(shost), peers) {
> +		if (rport->port_state !=3D FC_PORTSTATE_ONLINE)
> +			continue;
> +
> +		if (rport->port_name =3D=3D wwpn) {
> +			spin_unlock_irqrestore(shost->host_lock, flags);
> +			return rport;
> +		}
> +	}
> +
> +	spin_unlock_irqrestore(shost->host_lock, flags);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(fc_find_rport_by_wwpn);
> +
> +static void
> +fc_li_stats_update(struct fc_fn_li_desc *li_desc,
> +		   struct fc_fpin_stats *stats)
> +{
> +	stats->li +=3D be32_to_cpu(li_desc->event_count);
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
> +fc_delivery_stats_update(u32 reason_code, struct fc_fpin_stats =
*stats)
> +{
> +	stats->dn++;
> +	switch (reason_code) {
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
> +fc_cn_stats_update(u16 event_type, struct fc_fpin_stats *stats)
> +{
> +	stats->cn++;
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
> +	struct fc_rport *attach_rport =3D NULL;
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);
> +	struct fc_fn_li_desc *li_desc =3D (struct fc_fn_li_desc *)tlv;
> +	u64 wwpn;
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(li_desc->attached_wwpn));
> +	if (rport &&
> +	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
> +	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> +		attach_rport =3D rport;
> +		fc_li_stats_update(li_desc, &attach_rport->fpin_stats);
> +	}
> +
> +	if (be32_to_cpu(li_desc->pname_count) > 0) {
> +		for (i =3D 0;
> +		    i < be32_to_cpu(li_desc->pname_count);
> +		    i++) {
> +			wwpn =3D be64_to_cpu(li_desc->pname_list[i]);
> +			rport =3D fc_find_rport_by_wwpn(shost, wwpn);
> +			if (rport &&
> +			    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
> +			    rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> +				if (rport =3D=3D attach_rport)
> +					continue;
> +				fc_li_stats_update(li_desc,
> +						   &rport->fpin_stats);
> +			}
> +		}
> +	}
> +
> +	if (fc_host->port_name =3D=3D =
be64_to_cpu(li_desc->attached_wwpn))
> +		fc_li_stats_update(li_desc, &fc_host->fpin_stats);
> +}
> +
> +/*
> + * fc_fpin_delivery_stats_update - routine to update Delivery =
Notification
> + * event statistics.
> + * @shost:		host the FPIN was received on
> + * @tlv:		pointer to delivery descriptor
> + *
> + */
> +static void
> +fc_fpin_delivery_stats_update(struct Scsi_Host *shost,
> +			      struct fc_tlv_desc *tlv)
> +{
> +	struct fc_rport *rport =3D NULL;
> +	struct fc_rport *attach_rport =3D NULL;
> +	struct fc_host_attrs *fc_host =3D shost_to_fc_host(shost);
> +	struct fc_fn_deli_desc *dn_desc =3D (struct fc_fn_deli_desc =
*)tlv;
> +	u32 reason_code =3D be32_to_cpu(dn_desc->deli_reason_code);
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(dn_desc->attached_wwpn));
> +	if (rport &&
> +	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
> +	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> +		attach_rport =3D rport;
> +		fc_delivery_stats_update(reason_code,
> +					 &attach_rport->fpin_stats);
> +	}
> +
> +	if (fc_host->port_name =3D=3D =
be64_to_cpu(dn_desc->attached_wwpn))
> +		fc_delivery_stats_update(reason_code, =
&fc_host->fpin_stats);
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
> +	struct fc_rport *attach_rport =3D NULL;
> +	struct fc_fn_peer_congn_desc *pc_desc =3D
> +	    (struct fc_fn_peer_congn_desc *)tlv;
> +	u16 event_type =3D be16_to_cpu(pc_desc->event_type);
> +	u64 wwpn;
> +
> +	rport =3D fc_find_rport_by_wwpn(shost,
> +				      =
be64_to_cpu(pc_desc->attached_wwpn));
> +	if (rport &&
> +	    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
> +	     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> +		attach_rport =3D rport;
> +		fc_cn_stats_update(event_type, =
&attach_rport->fpin_stats);
> +	}
> +
> +	if (be32_to_cpu(pc_desc->pname_count) > 0) {
> +		for (i =3D 0;
> +		    i < be32_to_cpu(pc_desc->pname_count);
> +		    i++) {
> +			wwpn =3D be64_to_cpu(pc_desc->pname_list[i]);
> +			rport =3D fc_find_rport_by_wwpn(shost, wwpn);
> +			if (rport &&
> +			    (rport->roles & FC_PORT_ROLE_FCP_TARGET ||
> +			     rport->roles & FC_PORT_ROLE_NVME_TARGET)) {
> +				if (rport =3D=3D attach_rport)
> +					continue;
> +				fc_cn_stats_update(event_type,
> +						   &rport->fpin_stats);
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
> +	fc_cn_stats_update(be16_to_cpu(congn->event_type),
> +			   &fc_host->fpin_stats);
> +}
> +
> /**
>  * fc_host_rcv_fpin - routine to process a received FPIN.
>  * @shost:		host the FPIN was received on
> @@ -642,6 +903,38 @@ EXPORT_SYMBOL(fc_host_post_vendor_event);
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
> +			fc_fpin_delivery_stats_update(shost, tlv);
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
> 				FCH_EVT_LINK_FPIN, fpin_len, fpin_buf, =
0);
> }
> diff --git a/include/scsi/scsi_transport_fc.h =
b/include/scsi/scsi_transport_fc.h
> index 487a403ee51e..a636c1986e22 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -819,6 +819,7 @@ void fc_host_post_event(struct Scsi_Host *shost, =
u32 event_number,
> 		enum fc_host_event_code event_code, u32 event_data);
> void fc_host_post_vendor_event(struct Scsi_Host *shost, u32 =
event_number,
> 		u32 data_len, char *data_buf, u64 vendor_id);
> +struct fc_rport *fc_find_rport_by_wwpn(struct Scsi_Host *shost, u64 =
wwpn);
> void fc_host_post_fc_event(struct Scsi_Host *shost, u32 event_number,
> 		enum fc_host_event_code event_code,
> 		u32 data_len, char *data_buf, u64 vendor_id);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

