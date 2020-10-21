Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB89C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:56:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3932224E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 14:56:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="W1p1mT7A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443632AbgJUO4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 10:56:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36892 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2443041AbgJUO4f (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2020 10:56:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEmva2018087;
        Wed, 21 Oct 2020 14:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=Z2G6Iv6z2dlIE8PHG92xWZVAsg7tlx60852YY2Su1xY=;
 b=W1p1mT7AzVSXghybw20bv05il8GvZIB+utE1GI6qH/dLO7teFi0m3BkgYpjDhW8RghZ8
 plwGnOZjwNFLatg3DFjvjf2i4bIFCF+mu5zX1nz+/AnHIs9VpgWQOPeROY4pV4qzy3mg
 /qYDdLclgsC7+MWGykU2aZ2gSE26noOsEaa8PhowQpbdTXRSvTba1RhV0EIxBv+8pO4B
 W+FQB9SMRfrdk2V/jUnPcCW5pt+0HZe4tgz+DcS9hlpTbNHlYlsJEMCZ4vmdvQ3LiVe2
 21eJjYYW+Ddf9mHIujk/5fTOZdiV5q+UE+DHMKWi+FQOc3i0EE/0jVfml1XypZC8nKgG FA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 347p4b13kn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 21 Oct 2020 14:56:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09LEnv74132219;
        Wed, 21 Oct 2020 14:56:32 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34ak18rtwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Oct 2020 14:56:31 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09LEuUZM011043;
        Wed, 21 Oct 2020 14:56:30 GMT
Received: from [192.168.1.6] (/70.114.128.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Oct 2020 07:56:30 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH v3 4/5] scsi: fc: Add mechanism to update FPIN signal
 statistics
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20201021092715.22669-5-njavali@marvell.com>
Date:   Wed, 21 Oct 2020 09:56:30 -0500
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <577B3B37-2C6C-47D3-B710-3D80BFFE70FE@oracle.com>
References: <20201021092715.22669-1-njavali@marvell.com>
 <20201021092715.22669-5-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210113
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010210113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2020, at 4:27 AM, Nilesh Javali <njavali@marvell.com> =
wrote:
>=20
> From: Shyam Sundar <ssundar@marvell.com>
>=20
> Add statistics for Congestion Signals that are delivered to the host =
as
> interrupt signals, under fc_host_statistics.
>=20
> Signed-off-by: Shyam Sundar <ssundar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: James Smart <james.smart@broadcom.com>
> ---
> drivers/scsi/scsi_transport_fc.c | 5 +++++
> include/scsi/scsi_transport_fc.h | 3 +++
> 2 files changed, 8 insertions(+)
>=20
> diff --git a/drivers/scsi/scsi_transport_fc.c =
b/drivers/scsi/scsi_transport_fc.c
> index 4dfa0e40d8e5..3f816ab1d845 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -2100,6 +2100,9 @@ fc_host_statistic(fc_xid_not_found);
> fc_host_statistic(fc_xid_busy);
> fc_host_statistic(fc_seq_not_found);
> fc_host_statistic(fc_non_bls_resp);
> +fc_host_statistic(cn_sig_warn);
> +fc_host_statistic(cn_sig_alarm);
> +
>=20
> #define fc_host_fpin_statistic(name)					=
\
> static ssize_t fc_host_fpinstat_##name(struct device *cd,		=
\
> @@ -2182,6 +2185,8 @@ static struct attribute *fc_statistics_attrs[] =3D=
 {
> 	&device_attr_host_fc_xid_busy.attr,
> 	&device_attr_host_fc_seq_not_found.attr,
> 	&device_attr_host_fc_non_bls_resp.attr,
> +	&device_attr_host_cn_sig_warn.attr,
> +	&device_attr_host_cn_sig_alarm.attr,
> 	&device_attr_host_reset_statistics.attr,
> 	&device_attr_host_fpin_dn.attr,
> 	&device_attr_host_fpin_dn_unknown.attr,
> diff --git a/include/scsi/scsi_transport_fc.h =
b/include/scsi/scsi_transport_fc.h
> index a636c1986e22..c759b29e46c7 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -468,6 +468,9 @@ struct fc_host_statistics {
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
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

