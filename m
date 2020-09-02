Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 324D1C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:59:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09BE3207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:59:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gk78EeP5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgIBP73 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:59:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:36268 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIBP7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2020 11:59:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082Fo96E011401;
        Wed, 2 Sep 2020 15:59:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2020-01-29; bh=kjLmay4MdXd9APFKL6X82c9pOYlyhKjcXACCrEmAbAI=;
 b=gk78EeP52y69y7rpJ1suvpJVu+C2hQ+Ezjruqoixt6CfM1m+4kpt/L8otVAZqb1MtZ0h
 d0+6JGD5vHlI58Y67lo6GDPGnuJCpT3DC8uWC9AljneOhQ00shx1X3cUuJvoZuyf2egA
 nBV2SmI3dtOgyWgVk84j8xRFxIdpNlwu/GYYw1+9e4JpkVhWy39r/sw39gD0+rbcqkq4
 K5yK7FMPIKiK8lsBuw/d6fEXpP+xPQ/NWdn0FtDSSQshSFhpWxD6afmjMnowXR/IFz6b
 HA/czdtejbe+qDeCO19+WFnYhYfVIJpCUINY/skXtVQ7q7PTPqYYx8nfcAzWkSgmQaSr 9A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eymbfce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Sep 2020 15:59:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 082FtF8q030694;
        Wed, 2 Sep 2020 15:57:21 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3380kq7er4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Sep 2020 15:57:21 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 082FvK8l006176;
        Wed, 2 Sep 2020 15:57:20 GMT
Received: from dhcp-10-154-155-248.vpn.oracle.com (/10.154.155.248)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Sep 2020 08:57:20 -0700
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: [PATCH v2 09/13] qla2xxx: Make tgt_port_database available in
 initiator mode
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
In-Reply-To: <20200902072548.11491-10-njavali@marvell.com>
Date:   Wed, 2 Sep 2020 10:57:19 -0500
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <1F6E85E2-38CF-4B33-A39A-76256F5B3F1A@oracle.com>
References: <20200902072548.11491-1-njavali@marvell.com>
 <20200902072548.11491-10-njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=11 malwarescore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009020152
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9732 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=11 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009020151
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 2, 2020, at 2:25 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> tgt_port_database data is today exported only in target mode, allow it
> to be shown in initiator mode, as well.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_dfs.c | 64 +++++++++++++++++-----------------
> 1 file changed, 32 insertions(+), 32 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c =
b/drivers/scsi/qla2xxx/qla_dfs.c
> index 616ce891818d..1e9db568aee3 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -138,51 +138,51 @@ qla2x00_dfs_tgt_port_database_show(struct =
seq_file *s, void *unused)
> {
> 	scsi_qla_host_t *vha =3D s->private;
> 	struct qla_hw_data *ha =3D vha->hw;
> -	struct gid_list_info *gid_list, *gid;
> +	struct gid_list_info *gid_list;
> 	dma_addr_t gid_list_dma;
> 	fc_port_t fc_port;
> +	char *id_iter;
> 	int rc, i;
> 	uint16_t entries, loop_id;
> -	struct qla_tgt *tgt =3D vha->vha_tgt.qla_tgt;
>=20
> 	seq_printf(s, "%s\n", vha->host_str);
> -	if (tgt) {
> -		gid_list =3D dma_alloc_coherent(&ha->pdev->dev,
> -		    qla2x00_gid_list_size(ha),
> -		    &gid_list_dma, GFP_KERNEL);
> -		if (!gid_list) {
> -			ql_dbg(ql_dbg_user, vha, 0x7018,
> -			    "DMA allocation failed for %u\n",
> -			     qla2x00_gid_list_size(ha));
> -			return 0;
> -		}
> +	gid_list =3D dma_alloc_coherent(&ha->pdev->dev,
> +				      qla2x00_gid_list_size(ha),
> +				      &gid_list_dma, GFP_KERNEL);
> +	if (!gid_list) {
> +		ql_dbg(ql_dbg_user, vha, 0x7018,
> +		       "DMA allocation failed for %u\n",
> +		       qla2x00_gid_list_size(ha));
> +		return 0;
> +	}
>=20
> -		rc =3D qla24xx_gidlist_wait(vha, gid_list, gid_list_dma,
> -		    &entries);
> -		if (rc !=3D QLA_SUCCESS)
> -			goto out_free_id_list;
> +	rc =3D qla24xx_gidlist_wait(vha, gid_list, gid_list_dma,
> +				  &entries);
> +	if (rc !=3D QLA_SUCCESS)
> +		goto out_free_id_list;
>=20
> -		gid =3D gid_list;
> +	id_iter =3D (char *)gid_list;
>=20
> -		seq_puts(s, "Port Name	Port ID 	Loop ID\n");
> +	seq_puts(s, "Port Name	Port ID		Loop ID\n");
>=20
> -		for (i =3D 0; i < entries; i++) {
> -			loop_id =3D le16_to_cpu(gid->loop_id);
> -			memset(&fc_port, 0, sizeof(fc_port_t));
> +	for (i =3D 0; i < entries; i++) {
> +		struct gid_list_info *gid =3D
> +			(struct gid_list_info *)id_iter;
> +		loop_id =3D le16_to_cpu(gid->loop_id);
> +		memset(&fc_port, 0, sizeof(fc_port_t));
>=20
> -			fc_port.loop_id =3D loop_id;
> +		fc_port.loop_id =3D loop_id;
>=20
> -			rc =3D qla24xx_gpdb_wait(vha, &fc_port, 0);
> -			seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
> -				fc_port.port_name, =
fc_port.d_id.b.domain,
> -				fc_port.d_id.b.area, =
fc_port.d_id.b.al_pa,
> -				fc_port.loop_id);
> -			gid =3D (void *)gid + ha->gid_list_info_size;
> -		}
> -out_free_id_list:
> -		dma_free_coherent(&ha->pdev->dev, =
qla2x00_gid_list_size(ha),
> -		    gid_list, gid_list_dma);
> +		rc =3D qla24xx_gpdb_wait(vha, &fc_port, 0);
> +		seq_printf(s, "%8phC  %02x%02x%02x  %d\n",
> +			   fc_port.port_name, fc_port.d_id.b.domain,
> +			   fc_port.d_id.b.area, fc_port.d_id.b.al_pa,
> +			   fc_port.loop_id);
> +		id_iter +=3D ha->gid_list_info_size;
> 	}
> +out_free_id_list:
> +	dma_free_coherent(&ha->pdev->dev, qla2x00_gid_list_size(ha),
> +			  gid_list, gid_list_dma);
>=20
> 	return 0;
> }
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

