Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B229CC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Apr 2022 06:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237197AbiDNGFC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Apr 2022 02:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237010AbiDNGFB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2022 02:05:01 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB9D1B7AB
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 23:02:37 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23E1YeGB002870
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 23:02:37 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fea2m8tt6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 23:02:37 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23E5u4sr006893
        for <linux-scsi@vger.kernel.org>; Wed, 13 Apr 2022 23:02:36 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3fea2m8tt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Apr 2022 23:02:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ad15u503QqKy66H2fkDmG4HEryA3SK6l1UFaO39d2RABNiSjF57/NkBnYA3TrYG5aCeZwNN7uwYAEZQTf3ZGajwcmtK14SzCn4qZbH/rHq1+vb7rITfW5KZEdor2NebxwycfnCENl9f9ySfyXptL8tulWWfQhpVebnX65dutQhmsRtruKdryh5Qu2DMKdYauav6XzDp2I0eXmNRAZirj648L3mYSRGKUg/1SJ+9kTBrHXoOVksNH96LDsn2MbAdzcPPnPTmN8OAVgLi8InikFVqNjrMY+WiQNCcJHujgSaBMADy729Hm9JVWxnTmCdY1zKQTHjdrz36k5CxjFcYAxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRFeIAGrL03t5YSxVSxvPU49jFqqMT9vhH28+qxTlos=;
 b=MTiZfTCWVyxrhQebHWVnZeJChZxyzzQopgRaBMCfPtIs4S+4yt2M5aDjXz0qNuBz6tZ+oL0XWIsNJLKjZ8fiMHumc5AaiMZkpL4/9W1ifeCONcGF6MtfoBva25hlNZZU5rM8QGf9ihR5Yj5yj8P8BjwxM+pe2SEVYsjyxIdt9hqOSKXn+9cQT8GbeyRH0h4DfmkLBuQ4Oxjv2c7ziQz9Xj0IEQi27+M757x9LzyRMzA2+Z9EKft6gvd4kHTgDtDHdotONNTcBgbtrQX/hae9o1t+tkoXaMPwLkv2rJx/YnPzvUDicRiqGYuu5WTFKVSU0WdBo8KLud1rwrbtmLSOhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRFeIAGrL03t5YSxVSxvPU49jFqqMT9vhH28+qxTlos=;
 b=SkaXP3Fori0MZ2KrHtFhTzw2+/wYf07tjPFTiIbdkn06iaoFeFs0XCvH4SsASGiPuEA4yPql8aMFodf+c8cwMJyYHo0jhEFSiQEpLbRsx6o43GXj3D3uPbwkg5t4OYuvbhch/YKIwpFdSdAjxf7I2ZQ/1eiS80lBQovNAG9wtcQ=
Received: from CO6PR18MB4500.namprd18.prod.outlook.com (2603:10b6:5:356::24)
 by PH0PR18MB5002.namprd18.prod.outlook.com (2603:10b6:510:11d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 06:02:33 +0000
Received: from CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::854b:4e02:9521:a86a]) by CO6PR18MB4500.namprd18.prod.outlook.com
 ([fe80::854b:4e02:9521:a86a%6]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 06:02:33 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
Subject: RE: [PATCH] qla2xxx: Add an additional flag to fc_host_fpin_rcv()
Thread-Topic: [PATCH] qla2xxx: Add an additional flag to fc_host_fpin_rcv()
Thread-Index: AQHYT8QpA4MokFP65UiNUe49vaEMTqzu6lZQ
Date:   Thu, 14 Apr 2022 06:02:33 +0000
Message-ID: <CO6PR18MB450023FE365AFA6D8673FBC3AFEF9@CO6PR18MB4500.namprd18.prod.outlook.com>
References: <20220414055431.19712-1-njavali@marvell.com>
In-Reply-To: <20220414055431.19712-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 855b64d5-d26a-4e8e-8086-08da1ddc5e4b
x-ms-traffictypediagnostic: PH0PR18MB5002:EE_
x-microsoft-antispam-prvs: <PH0PR18MB5002880B9273BF0EBF732D20AFEF9@PH0PR18MB5002.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e0how8Ppt6Zyun64KtWTlDR2M6Vtf48nay1tPCJvXRCRYjUzv9Z8xGvdeUtv8HTfUNzxadyVMsPKJYZn46ayy2WpNhd676G6GGvBE9ClnSPtdlqVdC2RQgiuJRJoMBFUPtg95WGXmRsNpv+GD+Fu5UwazUxv1Xsz+j4GAv4GOwkTqzzm7g2sToEsySy6v1a5Xw/g4R9jrJ4UL8QEeox/ujAJVL8bDKLkb3QoIT8f7qQ4M1gdNL0aEyQWshvz4oX3JAQ4Gj/wlXmFJ0ZTyb+sEKJH5bOF3o4ut4doOeQQY5Ku6yEL8gOvNUo2SORAxuuuFgSu8DER5V/7wRGPHPI1yZYU4rCmkxK+jMw8APTBmpn/6ZnZcU9ULZrTsURCbUMBiISPxPCbgAo4S1auijyP5gD1SMDcpdLHbc0/Xx/RRhrg/WejnmwV059oxKHF+0ld3Tj4PsXZYTixRZmRhsgNq3lxIO+95/dyjztT9Ss4EZcpNh2sgTtNUHy82XhLVidV6VR/kh6G5e7/cnGGGZKz81lYyn3GmNc4UTwmB0yF3+yoQtGdxetZScJUR42SGM0D6quOAChuZHygDseB/zx8BgFaMZUPxo+J2tgWk74iZJEBevwhivx5DWlWSqvygF4NN3M7NudengAHdxRg5IrcyHm4pJeLxynbHetrc6BX8SiOiiZBbosGogfOdS72K3eonfz6+r9OL7hTYBHiZuD/cA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4500.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(26005)(2906002)(9686003)(8676002)(107886003)(4326008)(122000001)(38100700002)(38070700005)(86362001)(186003)(33656002)(55016003)(508600001)(5660300002)(64756008)(66476007)(66556008)(316002)(66446008)(71200400001)(54906003)(110136005)(53546011)(52536014)(6506007)(7696005)(76116006)(8936002)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IzkGBceikYAgOlxk+A5GBQHLqKWhCBidVIH+B6ulnH2ha9JCVee+3cXEgztM?=
 =?us-ascii?Q?W5yIabbE7hdwM+YnarsTYUHh+zpA6lTVCrH3nfUaTPkIq0kmkiy7pOix+ZHx?=
 =?us-ascii?Q?weuthIJKALD/PIjDi1wzJHvkA6jGj8r14X+qLnUQaemLLUm+LYT7hosGxutW?=
 =?us-ascii?Q?dCCfAzGJAVUVe6LR7zqDTihd6BcQJhxSpx+b1FOEu8vmvG+5cWKeTYn3sdbC?=
 =?us-ascii?Q?es7ZDHGGE0rs4SxIi8zZu0VkitKE7hldT4LobOHDz2CYQvSXmVNlxOrK8VJ7?=
 =?us-ascii?Q?7U1vdBWwUQ+WuDx28xxFQ9y2O0BgKRb4n9EDSURRIjLyUYlbU+ffrYuYyI7q?=
 =?us-ascii?Q?+tGPZ9Pt+MwqNNkF9lDHTKF2wn7lCB5R3IRAMmxXwYJ1iSwYXEiEgQII93F/?=
 =?us-ascii?Q?CJvPS6Nw1cdQ9SxiCvBi3eZ3U9g87STd7ixo9e49Z6dErE5OOO7n45SZ/yx5?=
 =?us-ascii?Q?IrggVvJPJ/SByFX84EkolLsNwawICBQbinH6exPpgHFaylGkGbSkOHUQMZ3b?=
 =?us-ascii?Q?UyyscW6A1uOHXjJE/MC9wNUBZyz5q/uPrQrzHGi7n8XztI6dTlOkJD78rl+P?=
 =?us-ascii?Q?fS38c0fs+VDGtUF/KmVM8M1WKInbhUOOZ21wiBrER+3Ef9q7JHsW+6tS8n5r?=
 =?us-ascii?Q?26mq/idofB2cgwoQXO+fnZjdgHuZs7D8GMM/wwR6RZdjpvh1umjmxH1NeHax?=
 =?us-ascii?Q?prqbh7ueYmRj8HfhMF3s97vAyUIUuBij3DQJbIW08/cWFYuWBck6GYqcaCyC?=
 =?us-ascii?Q?GUtf2ugz7zLDrPJ6sE1k8Dk0C7RrQZ1/x4Bav5OvAzgvkHZ6asGST5ikU7nu?=
 =?us-ascii?Q?BxnMaNbbg3MoXSsnw6tfWx1o9aCw7SJT707hmTLs/VywgU2NNpybYsRK+H1f?=
 =?us-ascii?Q?sPxIUYGjybtUXyd4Fdub2GVAR+A0tisLLntKfTb6i+caXNCmYetGK65U81rj?=
 =?us-ascii?Q?5jee2G8wdRLBo8f9ER8szjQ1kxVPQbF7bp8WlRpbwB0EWok5x7KfKA1dzmDk?=
 =?us-ascii?Q?o115NeOoGEmRR6SHZdgWagzWa6E+ovOJ/uYcZ803Jla76W9RwkpoFJOiuD5p?=
 =?us-ascii?Q?X1BC9HjgPVZgMPxOGRqk5bgCYKcy5i0lt1WzKkzbKNQh0WdrinH1yLQJaPT0?=
 =?us-ascii?Q?q7MWEgR8AGLcrW80GmWqBeAs64sjbVSK+FIr5UumSrrkuA5aBRrVL7RX3qDS?=
 =?us-ascii?Q?FUXAIT2cepGpCV1nHx6P9RVkVr/9I9G29OQSAT0+ZENMjJNsFml7hMtTWjHY?=
 =?us-ascii?Q?SFvnyx0bBphdDiOfigOiUhulyuhBGrgb1XxpghzXH2tZPHrLk2dDeiFuuq81?=
 =?us-ascii?Q?X4MNbxBr/YLd2x2GwgNNxa1sRM2I28QCEyKGYmx0IMZ/3SkbS4fyjCGj9vXF?=
 =?us-ascii?Q?oW6+tw6kzBdyjT4AE4WnGvUWFAveBnJuERvwlTIZXWMTLjFqPQfS2YCw3CPy?=
 =?us-ascii?Q?CghXAFEHTKe8HAEF1PfuuZobjpN1zM2X7vNOuje++N89Blytrw4TwvjPm9Iy?=
 =?us-ascii?Q?47S0aXMTBTeo48B5pr90Ef6aFkPNG81hcAWXzJ29lzgnMi/+0acAYvk49LUk?=
 =?us-ascii?Q?+gJrSrU7mA8K41GI/pHBWCz3pCDVf5Ra+F9BClVejPWdNE+qX62+35tYg0oY?=
 =?us-ascii?Q?sPmJ1NCo4B/GzHo6e6nxTBetHJ47kI+kqdNaLttWYLhiy+G4YxDMNnPND86P?=
 =?us-ascii?Q?KYj51BbBKSy3WGt1ZR/j5uFGOEUqA+9SXgcurFA27rvO1LTpvtdUDk/O379z?=
 =?us-ascii?Q?JXY2Spt95w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4500.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 855b64d5-d26a-4e8e-8086-08da1ddc5e4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 06:02:33.7113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zRLwDHyOpXUbGAs+jEvYTHACmwcKTa1JrrQ8Gh6L12x7oKvjKyMd84GCkKyfIzSPjbsbwEeg2/bLzFe6QzpXKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB5002
X-Proofpoint-GUID: f3FZU5b0dZpWlDygVEIY5yfETpy8byoS
X-Proofpoint-ORIG-GUID: DIISvoAloO-b8j3z7ybTU_U61g1SXI4S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_01,2022-04-13_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Please ignore this patch. I will re-send patch as RFC.

Thanks,
Nilesh=20

> -----Original Message-----
> From: Nilesh Javali <njavali@marvell.com>
> Sent: Thursday, April 14, 2022 11:25 AM
> To: martin.petersen@oracle.com
> Cc: linux-scsi@vger.kernel.org; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>
> Subject: [PATCH] qla2xxx: Add an additional flag to fc_host_fpin_rcv()
>=20
> From: Anil Gurumurthy <agurumurthy@marvell.com>
>=20
> The LLDD and the stack currently process FPINs received from the fabric,
> but the stack is not aware of any action taken by the driver to alleviate
> congestion. The current interface between the driver and the SCSI stack i=
s
> limited to passing the notification mainly for statistics and heuristics.
>=20
> The reaction to an FPIN could be handled either by the driver or by the
> stack (marginal path and failover). This patch enhances the interface to
> indicate if action on an FPIN has already been taken by the LLDDs or not.
> Add an additional flag to fc_host_fpin_rcv() to indicate if the FPIN has
> been processed by the driver.
>=20
> Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>  drivers/scsi/lpfc/lpfc_els.c     | 2 +-
>  drivers/scsi/qla2xxx/qla_isr.c   | 2 +-
>  drivers/scsi/scsi_transport_fc.c | 6 +++++-
>  include/scsi/scsi_transport_fc.h | 2 +-
>  4 files changed, 8 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
> index 3a445a0fea86..e221c25b848d 100644
> --- a/drivers/scsi/lpfc/lpfc_els.c
> +++ b/drivers/scsi/lpfc/lpfc_els.c
> @@ -10084,7 +10084,7 @@ lpfc_els_rcv_fpin(struct lpfc_vport *vport, void
> *p, u32 fpin_length)
>  		/* Send every descriptor individually to the upper layer */
>  		if (deliver)
>  			fc_host_fpin_rcv(lpfc_shost_from_vport(vport),
> -					 fpin_length, (char *)fpin);
> +					 fpin_length, (char *)fpin, false);
>  		desc_cnt++;
>  	}
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 21b31d6359c8..e01d9a671749 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -45,7 +45,7 @@ qla27xx_process_purex_fpin(struct scsi_qla_host *vha,
> struct purex_item *item)
>  	ql_dump_buffer(ql_dbg_init + ql_dbg_verbose, vha, 0x508f,
>  		       pkt, pkt_size);
>=20
> -	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt);
> +	fc_host_fpin_rcv(vha->host, pkt_size, (char *)pkt, false);
>  }
>=20
>  const char *const port_state_str[] =3D {
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transpo=
rt_fc.c
> index a2524106206d..6de476f13512 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -892,12 +892,13 @@ fc_fpin_congn_stats_update(struct Scsi_Host
> *shost,
>   * @shost:		host the FPIN was received on
>   * @fpin_len:		length of FPIN payload, in bytes
>   * @fpin_buf:		pointer to FPIN payload
> + * @hba_process:	true if LLDD has acted on the FPIN
>   *
>   * Notes:
>   *	This routine assumes no locks are held on entry.
>   */
>  void
> -fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf)
> +fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_buf, =
bool
> hba_process)
>  {
>  	struct fc_els_fpin *fpin =3D (struct fc_els_fpin *)fpin_buf;
>  	struct fc_tlv_desc *tlv;
> @@ -925,6 +926,9 @@ fc_host_fpin_rcv(struct Scsi_Host *shost, u32
> fpin_len, char *fpin_buf)
>  		case ELS_DTAG_CONGESTION:
>  			fc_fpin_congn_stats_update(shost, tlv);
>  		}
> +		/* If the event has not been processed, mark path as
> marginal */
> +		if (!hba_process)
> +			fc_host_port_state(shost) =3D
> FC_PORTSTATE_MARGINAL;
>=20
>  		desc_cnt++;
>  		bytes_remain -=3D FC_TLV_DESC_SZ_FROM_LENGTH(tlv);
> diff --git a/include/scsi/scsi_transport_fc.h b/include/scsi/scsi_transpo=
rt_fc.h
> index e80a7c542c88..a987db5c7d63 100644
> --- a/include/scsi/scsi_transport_fc.h
> +++ b/include/scsi/scsi_transport_fc.h
> @@ -856,7 +856,7 @@ void fc_host_post_fc_event(struct Scsi_Host *shost,
> u32 event_number,
>  	 * Note: when calling fc_host_post_fc_event(), vendor_id may be
>  	 *   specified as 0.
>  	 */
> -void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_=
buf);
> +void fc_host_fpin_rcv(struct Scsi_Host *shost, u32 fpin_len, char *fpin_=
buf,
> bool hba_process);
>  struct fc_vport *fc_vport_create(struct Scsi_Host *shost, int channel,
>  		struct fc_vport_identifiers *);
>  int fc_vport_terminate(struct fc_vport *vport);
> --
> 2.23.1

