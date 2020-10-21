Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEE36C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 323E822283
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:47:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T1z4o/zI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443353AbgJUOr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 10:47:57 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56724 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442648AbgJUOr5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 10:47:57 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEitIp014488;
        Wed, 21 Oct 2020 14:47:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=GJ1F0psH69B/Zq9SYwoEkR4PX3pjNDcPmhOxvhrHzEg=;
 b=T1z4o/zI03vXir9yM2qUba/XxX31wXWxS+9zbyOfYAJLZiS/QxKHnZ+vmZQSHVqccMK9
 G5Y/PK9/8yZ/AThARiaADUfePDUn2k8fxKPmZFeqcRLmdFhDs20uIjbA/FBDiGg55aUW
 TShquXuu9YQCdiEOCYusBjn+N/rGDKufPDUroocR8B0CWF1uyuo/aToHHx9Wibcp3A6p
 ESYEVEoLzOUuVJ2FrMK2cbR2hfCAzozsNF9SKkXP+C4OgIHA2GeCDAlm86XDW80e8g9J
 Zhso4heP0G2f7/KsItRwPtPPC5YNYIecNM8xNNZfMLAK2Uwq11pC4vAX1PTB45qlJtRG kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 347p4b121t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Oct 2020 14:47:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEjvYs121411;
        Wed, 21 Oct 2020 14:47:53 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ak18rhsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 14:47:53 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09LElq5s005833;
        Wed, 21 Oct 2020 14:47:52 GMT
Received: from [192.168.1.6] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 07:47:51 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 2/5] scsi: fc: Add FPIN statistics to fc_host and
 fc_rport objects
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201021092715.22669-3-njavali@marvell.com>
Date:   Wed, 21 Oct 2020 09:47:51 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <744B61B2-1B86-4ADF-97C7-4230697CE5D5@oracle.com>
References: <20201021092715.22669-1-njavali@marvell.com>
 <20201021092715.22669-3-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210112
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2020, at 4:27 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>=20
> From: Shyam Sundar <ssundar@marvell.com>
>=20
> - Adds a structure for holding fpin stats for host & rport
>=20
> - Adds sysfs nodes to maintain FPIN stats:
>        /sys/class/fc_host/hostXX/statistics/
>        /sys/class/fc_remote_ports/rport-XX\:Y-Z/statistics/
>=20
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: James Smart <james.smart@broadcom.com>
> ---
> drivers/scsi/scsi_transport_fc.c | 117 +++++++++++++++++++++++++++++++
> include/scsi/scsi_transport_fc.h |  32 +++++++++
> 2 files changed, 149 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c =
b/drivers/scsi/scsi_transport_fc.c
> index 2ff7f06203da..501e165ae6f1 100644
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
> @@ -419,6 +420,7 @@ static int fc_host_setup(struct =
transport_container *tc, struct device *dev,
> 	fc_host->fabric_name =3D -1;
> 	memset(fc_host->symbolic_name, 0, =
sizeof(fc_host->symbolic_name));
> 	memset(fc_host->system_hostname, 0, =
sizeof(fc_host->system_hostname));
> +	memset(&fc_host->fpin_stats, 0, sizeof(fc_host->fpin_stats));
>=20
> 	fc_host->tgtid_bind_type =3D FC_TGTID_BIND_BY_WWPN;
>=20
> @@ -991,6 +993,67 @@ store_fc_rport_fast_io_fail_tmo(struct device =
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
> +	return snprintf(buf, 20, "0x%llx\n", rport->fpin_stats.name);	=
\
> +}									=
\
> +static FC_DEVICE_ATTR(rport, fpin_##name, 0444, =
fc_rport_fpinstat_##name, NULL)
> +
> +fc_rport_fpin_statistic(dn);
> +fc_rport_fpin_statistic(dn_unknown);
> +fc_rport_fpin_statistic(dn_timeout);
> +fc_rport_fpin_statistic(dn_unable_to_route);
> +fc_rport_fpin_statistic(dn_device_specific);
> +fc_rport_fpin_statistic(cn);
> +fc_rport_fpin_statistic(cn_clear);
> +fc_rport_fpin_statistic(cn_lost_credit);
> +fc_rport_fpin_statistic(cn_credit_stall);
> +fc_rport_fpin_statistic(cn_oversubscription);
> +fc_rport_fpin_statistic(cn_device_specific);
> +fc_rport_fpin_statistic(li);
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
> +	&device_attr_rport_fpin_dn.attr,
> +	&device_attr_rport_fpin_dn_unknown.attr,
> +	&device_attr_rport_fpin_dn_timeout.attr,
> +	&device_attr_rport_fpin_dn_unable_to_route.attr,
> +	&device_attr_rport_fpin_dn_device_specific.attr,
> +	&device_attr_rport_fpin_li.attr,
> +	&device_attr_rport_fpin_li_failure_unknown.attr,
> +	&device_attr_rport_fpin_li_link_failure_count.attr,
> +	&device_attr_rport_fpin_li_loss_of_sync_count.attr,
> +	&device_attr_rport_fpin_li_loss_of_signals_count.attr,
> +	&device_attr_rport_fpin_li_prim_seq_err_count.attr,
> +	&device_attr_rport_fpin_li_invalid_tx_word_count.attr,
> +	&device_attr_rport_fpin_li_invalid_crc_count.attr,
> +	&device_attr_rport_fpin_li_device_specific.attr,
> +	&device_attr_rport_fpin_cn.attr,
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
> @@ -1745,6 +1808,39 @@ fc_host_statistic(fc_xid_busy);
> fc_host_statistic(fc_seq_not_found);
> fc_host_statistic(fc_non_bls_resp);
>=20
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
> +	return snprintf(buf, 20, "0x%llx\n", fc_host->fpin_stats.name);	=
\
> +}									=
\
> +static FC_DEVICE_ATTR(host, fpin_##name, 0444, =
fc_host_fpinstat_##name, NULL)
> +
> +fc_host_fpin_statistic(dn);
> +fc_host_fpin_statistic(dn_unknown);
> +fc_host_fpin_statistic(dn_timeout);
> +fc_host_fpin_statistic(dn_unable_to_route);
> +fc_host_fpin_statistic(dn_device_specific);
> +fc_host_fpin_statistic(cn);
> +fc_host_fpin_statistic(cn_clear);
> +fc_host_fpin_statistic(cn_lost_credit);
> +fc_host_fpin_statistic(cn_credit_stall);
> +fc_host_fpin_statistic(cn_oversubscription);
> +fc_host_fpin_statistic(cn_device_specific);
> +fc_host_fpin_statistic(li);
> +fc_host_fpin_statistic(li_failure_unknown);
> +fc_host_fpin_statistic(li_link_failure_count);
> +fc_host_fpin_statistic(li_loss_of_sync_count);
> +fc_host_fpin_statistic(li_loss_of_signals_count);
> +fc_host_fpin_statistic(li_prim_seq_err_count);
> +fc_host_fpin_statistic(li_invalid_tx_word_count);
> +fc_host_fpin_statistic(li_invalid_crc_count);
> +fc_host_fpin_statistic(li_device_specific);
> +
> static ssize_t
> fc_reset_statistics(struct device *dev, struct device_attribute *attr,
> 		    const char *buf, size_t count)
> @@ -1794,6 +1890,26 @@ static struct attribute *fc_statistics_attrs[] =
=3D {
> 	&device_attr_host_fc_seq_not_found.attr,
> 	&device_attr_host_fc_non_bls_resp.attr,
> 	&device_attr_host_reset_statistics.attr,
> +	&device_attr_host_fpin_dn.attr,
> +	&device_attr_host_fpin_dn_unknown.attr,
> +	&device_attr_host_fpin_dn_timeout.attr,
> +	&device_attr_host_fpin_dn_unable_to_route.attr,
> +	&device_attr_host_fpin_dn_device_specific.attr,
> +	&device_attr_host_fpin_li.attr,
> +	&device_attr_host_fpin_li_failure_unknown.attr,
> +	&device_attr_host_fpin_li_link_failure_count.attr,
> +	&device_attr_host_fpin_li_loss_of_sync_count.attr,
> +	&device_attr_host_fpin_li_loss_of_signals_count.attr,
> +	&device_attr_host_fpin_li_prim_seq_err_count.attr,
> +	&device_attr_host_fpin_li_invalid_tx_word_count.attr,
> +	&device_attr_host_fpin_li_invalid_crc_count.attr,
> +	&device_attr_host_fpin_li_device_specific.attr,
> +	&device_attr_host_fpin_cn.attr,
> +	&device_attr_host_fpin_cn_clear.attr,
> +	&device_attr_host_fpin_cn_lost_credit.attr,
> +	&device_attr_host_fpin_cn_credit_stall.attr,
> +	&device_attr_host_fpin_cn_oversubscription.attr,
> +	&device_attr_host_fpin_cn_device_specific.attr,
> 	NULL
> };
>=20
> @@ -2177,6 +2293,7 @@ fc_attach_transport(struct fc_function_template =
*ft)
> 	i->rport_attr_cont.ac.attrs =3D &i->rport_attrs[0];
> 	i->rport_attr_cont.ac.class =3D &fc_rport_class.class;
> 	i->rport_attr_cont.ac.match =3D fc_rport_match;
> +	i->rport_attr_cont.statistics =3D &fc_rport_statistics_group;
> 	transport_container_register(&i->rport_attr_cont);
>=20
> 	i->vport_attr_cont.ac.attrs =3D &i->vport_attrs[0];
> diff --git a/include/scsi/scsi_transport_fc.h =
b/include/scsi/scsi_transport_fc.h
> index 1c7dd35cb7a0..487a403ee51e 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -285,6 +285,36 @@ struct fc_rport_identifiers {
> 	u32 roles;
> };
>=20
> +/*
> + * Fabric Performance Impact Notification Statistics
> + */
> +struct fc_fpin_stats {
> +	/* Delivery */
> +	u64 dn;
> +	u64 dn_unknown;
> +	u64 dn_timeout;
> +	u64 dn_unable_to_route;
> +	u64 dn_device_specific;
> +
> +	/* Link Integrity */
> +	u64 li;
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
> +	u64 cn;
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
> @@ -326,6 +356,7 @@ struct fc_rport {	/* aka fc_starget_attrs */
>=20
> 	/* Dynamic Attributes */
> 	u32 dev_loss_tmo;	/* Remote Port loss timeout in seconds. =
*/
> +	struct fc_fpin_stats fpin_stats;
>=20
> 	/* Private (Transport-managed) Attributes */
> 	u64 node_name;
> @@ -516,6 +547,7 @@ struct fc_host_attrs {
> 	char symbolic_name[FC_SYMBOLIC_NAME_SIZE];
> 	char system_hostname[FC_SYMBOLIC_NAME_SIZE];
> 	u32 dev_loss_tmo;
> +	struct fc_fpin_stats fpin_stats;
>=20
> 	/* Private (Transport-managed) Attributes */
> 	enum fc_tgtid_binding_type  tgtid_bind_type;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

