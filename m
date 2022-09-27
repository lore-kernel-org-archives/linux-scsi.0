Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F8AC54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiI0SYq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiI0SYn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:24:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAD9491EA
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:24:41 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RIOWSx030969;
        Tue, 27 Sep 2022 18:24:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Cs2gd3U79cZw+dycmSapLUSASIFJEhoCkt3BOnAZF+g=;
 b=cE1bYxGKJ49OUh5ZKG0tWYiHN71uNa7ZTnt6PRG/+bKbNA9f9fcSUaWR+vJTNir/VlDM
 SBJz6pQpdW7p4flYEPRKkHaP8J3USxFuldQFxv6gdmpAR1/ReZbTmQbf4G2BveTWDmur
 Bi6lxzJNeyrT9Oifw1Q9fEg5jRcYtmuk6+EpizS9AiCX2b6BJQyzmJusCS8xEGaXfanI
 f+2w/WFhOvWHo8+da5eKh74FkkvdghxltN/lbsmxLULvUp50me0nlISCoPuzsXApxB2v
 n8wWzq9WiHCkLRsHLXTJRLOkOtDL7H2tV1Z5xQtw+ycO0GkVsPKySkBBHMBDW8NylMWv 9A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstesysu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Sep 2022 18:24:38 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28RHcPJV002549;
        Tue, 27 Sep 2022 18:24:37 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpruh8w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Sep 2022 18:24:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzFP870VVvpTTG+MyhOtdea+Padm/S1G14aypgi2Ba5oH1d25Jgq6MkT6/qbzbXKSb5Hg6uwkS+v1bSa7MZDQNX2q6X8GFuBzRHgzE4TqH+1org2Qt6vlgFyTGuevemplu1x7YQxm7twOuEYf9MJhKceWwBVPoipLV5y491qzBK0kLp9v4G0+WxJo8H2+a8y34RxclzEsYuwh7GAZ7CgBvbzJvWGKIn1J4GBZKCiIS/RnyL781dsPI0VzY7yEle2JRBvjTsMi5dgSf1DAdJco6i0iOPTpq0xWAw+Ge7pQfhX9ggJH0JUUsKmJ/ags9L2LBCKwHggjPkGXk0eT96chA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cs2gd3U79cZw+dycmSapLUSASIFJEhoCkt3BOnAZF+g=;
 b=XVhHgcksqRnj68sIriKJSKH9HzDve5PHne0iBPIizyV1bX0RngNYi95Rz/RDyLj6eIYj1a+5fIDhaVW1oltKFUjRw0+Ur8x9GYQ0Yn5I8fFH9KbrBL0SWz6nXv3ehJ3oV2NfxOVci9T/tjm+Kzds3Sa4si4M39dJW/e/h3WLIO8iRSibn2SYqPTvN9N/tiMj5Wi+iZz+uN7345c+KOaH0CkhnOQmS8L+vOG+/n4LmFOwo1watCP7ORFK7KYBa2Oe9DMGL3WWO0dIBwwFBlztsBuwg1lBZP7rkZIani210qqTsvYXs1ww8Vk12eq4YsA9kZyNkJqls54sKhRNG1g+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cs2gd3U79cZw+dycmSapLUSASIFJEhoCkt3BOnAZF+g=;
 b=p0AJ4L8CXe2vf0tNV6l25cbPDVCetQenBC3zmXVpiCrSZgnTJHaNYjAsgQX3Pewwts6fJtWAnyKQbCM5SzfN/H6LlmIAurhDI7LYRBWtWpGyt8iJeuWe2v71KSuMINy7+lfh+gtGeHCyevrn0c79Dg+rXBSYy1M6ty8e7seeAeE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB4862.namprd10.prod.outlook.com (2603:10b6:5:38c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 18:24:35 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::498c:82a0:ebe4:d551]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::498c:82a0:ebe4:d551%7]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 18:24:35 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>
Subject: Re: [PATCH] qla2xxx: Use transport defined speed mask for
 supported_speeds
Thread-Topic: [PATCH] qla2xxx: Use transport defined speed mask for
 supported_speeds
Thread-Index: AQHY0mi3n7ZBsB1lkE6nuJ4BfDPos63zl/cA
Date:   Tue, 27 Sep 2022 18:24:35 +0000
Message-ID: <BA68566A-7435-44A4-B648-B07C8C91396D@oracle.com>
References: <20220927115946.17559-1-njavali@marvell.com>
In-Reply-To: <20220927115946.17559-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|DS7PR10MB4862:EE_
x-ms-office365-filtering-correlation-id: f29187d3-c155-4140-6dae-08daa0b587eb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sO4vZTzCkf7K6uCDDXG4VqMACQ5+AIonsxgPRGuDFzIecV6AuI8618XWfL8zSUgS47ELjGJKRzHnMpNhCDAYR8h8bdpYChwnJA8clBwwzGjrhuQoUFGO1f3MyY2fbqWKsnpV4hKx8n+4jugKpuIaF1WU3FEYXv2r5h+dLnEXSL/KGzWDvXIDNWvFwy0eK+aFvixuus5I+Tow+j9qDyj+dB4LIhXnh0y8zyxq3PkjtnXTiUKGxYo848vtEmTqMsXSA+BtvwKBTBBilX1we5H+hlY4U5yGavbUcNDRRlDQDM2OduQpqNte8Km1hKaGB+zQtceDIOuaNa12pOOkrncX/eNAqlOSPFlAuRVwZkSjyeW+V4KZeM27ecBy+CJAcdrNIq+Wo9WsSI/iy0jHRbHQrYYZn0FP0Ge/u4J7Cp8L7i5GfqFcQtO/onUifS5I2r8mB9IXyqae4ey6RWJtu58cAphQiZs6UOVFgHJQPAlc2NzPfToFlDL2Zqw0nXq7sXqU1TUdjoxS8hw9r6z+qk29YMjKwvNL1xLl9juxszAY/t95o1eivYmsUcC7E5bOUz8vGU95BGBpS1uxoyG5UIEv6Cr5KrBYaN3uuVfKIm7H2XG18ulYYtrY30+PXarWKUnPkeGad/zd2SPWHiIJm0kdsCKoBGCIn8KGaV4Cz/MPK/1pKyjaSDsXEu564xkodNdevzoDCWAlAW1yATHOrAOYRQKe+9vuaElbO+lpE7J4oADjsOXNGa+aZSv2sdE1wcqXxvMC842wSgmiJRtrvJxJtUveXz/aT2UJ1qKBTEuM1WA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(376002)(396003)(346002)(39860400002)(451199015)(38100700002)(122000001)(66446008)(38070700005)(66946007)(5660300002)(91956017)(76116006)(4326008)(8676002)(64756008)(66556008)(66476007)(6916009)(54906003)(316002)(8936002)(2906002)(44832011)(186003)(2616005)(71200400001)(83380400001)(6486002)(6512007)(6506007)(53546011)(478600001)(26005)(41300700001)(36756003)(86362001)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?woMKazZ9X0ay0OzSrlYbhYs8x8GteyEnd5pmQ7ZKqwJeWZCutErl/qq1mcJU?=
 =?us-ascii?Q?pdlyMAj7kj923XHR29prVdTrxJaHA/vDBNQUi/GCDUb5cIhXyXDmQ26DfqjM?=
 =?us-ascii?Q?UJTZajPj4lJjhGngaoXdZvEMrwz8LB6flFoyo4pCa2AbUfet0gYgATkzf19R?=
 =?us-ascii?Q?H/7OWPgNYP5lBV8yGXM7XLwimnaJCK4zef2KApinBtFU3Z0EEy6sEsZxU1Wc?=
 =?us-ascii?Q?4IaHbT4Fd71vsBdI4zJUsWAI7nFlRLiGae2J4/Cq8jboqLClhG/QQQe/msHj?=
 =?us-ascii?Q?VA/zf3ZKBpeK/64CSxgNlWg4AR2j51jpANpLqZ40+k4iYUbzwo3+K80Cn4XP?=
 =?us-ascii?Q?5xa+Z73gkwWX7FL0AarjSP69NvcyAo7HfhvQoika9u//wgNnqwTUGrny6ykl?=
 =?us-ascii?Q?fxv3HpmV2tNcOf0M3OYAOgRj0QID7F9gJz0+XYphpsFsCQ9gAmyX4Kt+22kt?=
 =?us-ascii?Q?qPUkvsmS5SeiFByTa8kZSTCLErbjcXAXXRPw5d3mDl/PEsfFYBCs7p8W3sEK?=
 =?us-ascii?Q?p8Nk1yNfiRooJt3xtkISYqdZ2IVfUsH+r5LWIQRJwMSclhcejjBdgeetYmxC?=
 =?us-ascii?Q?2BGcHYjDm6N6B38vj5+NRGNJZawbDeB41Ku/0nEnuDI6cfm6UkAFNIomzG8l?=
 =?us-ascii?Q?DrmZ3l5qxTEvE4iFo4hGNoJtvUNhcqd1d78t1wQuMdky9cvnqaKJtciLmS4x?=
 =?us-ascii?Q?wQg56GD/VA7sVl7SU1W8NU1GOIicR7VlJebBeIDFvjOIxGMtO5vgILbMiMl5?=
 =?us-ascii?Q?HyfL81VJvLtRjbew9nbVKmdSUdycQZu63P5tiwEAUEN9Xr/uMAqi+SEFj30g?=
 =?us-ascii?Q?mfJL+1zKy3yZigPun7BoocoMcm5wftdyX+/q3O2rajHSGZSSmGjEO9yC4IUV?=
 =?us-ascii?Q?deVOUGkd0sg97fMKL4ovpkUGK44Wa4U8xqKAydopQL2ZioU5s7k74DZQ+oVW?=
 =?us-ascii?Q?aiZmKYvpJywo/C9nY/FFQhg99LfF/6noYgE9kQpGJiTfd0oVfluttl5AC/7g?=
 =?us-ascii?Q?VA3ed5Llaxx5xugY75eexf4LoxBz33nfjl6DgXE8Uje5kwyURVEt2CqZRbS2?=
 =?us-ascii?Q?GhKtAnI4AzNc38bY/k9uMK46MBjifRTyfuL/7WMxyUQ+dxJwWU1MgRnFBLcx?=
 =?us-ascii?Q?NG4jhuYO5MjIwfGdalwXqaj6sLobs91EVPdKTzI3UWFxl5HVw1YnRVNX+sre?=
 =?us-ascii?Q?4YR2OIVMvJO0MEzgs2bKKSsCjWvOJubVL/6pV5qk351g82VVJ7Bbre/74KaQ?=
 =?us-ascii?Q?P7tAAo4wZFG6Xjup09pls8N7SlFKys2pcVhJ1bjHpdyRNNo5wJ/AqmHx/3/6?=
 =?us-ascii?Q?mb2Gu7ETKK5Xf3JYZJQNMFjFsrMOJyVl5KI+LCwbbQdAbLdBTUIoJKJnGzWH?=
 =?us-ascii?Q?1nRPQrJRLi2acrEKWr+JoA78hAhbUdIBarWV4TxAISB5w+KcsPubXdUY4dxe?=
 =?us-ascii?Q?gDGdMbDcSPTmKUadSl6N7gPuw+Xa//t+hbHcW9eIT5eZ4vsmKHpFl7FaQV49?=
 =?us-ascii?Q?64o7qCwqwVpGgwT2S5LbJGvpekPLnqY0MOFHSBTZxqDwfIk39d8YxC72/eNN?=
 =?us-ascii?Q?pWbt6GhON62pBTxA1IE7x8BuM8qUfK6B9kikQCvo5Dfin04l8/yvrMZFk6aG?=
 =?us-ascii?Q?Dg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <360FBEB921B3254B9CCBAC4BB8BE3086@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29187d3-c155-4140-6dae-08daa0b587eb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 18:24:35.6068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: muDwbKDkOOaW6mCv7/4f0pRiaqjKwE9M0wYwOK5APHyEDByHcvH/GRyo2PAUYi1skUo7WnEeQPp6SJU1GcPgJZzgDnkX+ZBWFlIUXDAADr8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_09,2022-09-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209270115
X-Proofpoint-GUID: xOgQkzE1hLW9t2ug2rGZUH3qXg7bawvw
X-Proofpoint-ORIG-GUID: xOgQkzE1hLW9t2ug2rGZUH3qXg7bawvw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 27, 2022, at 4:59 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Manish Rangankar <mrangankar@marvell.com>
>=20
> One of the sysfs value reported for supported_speeds
> was not valid (20Gb/s reported instead of 64Gb/s).
> Instead of driver internal speed mask definition, use speed mask
> defined in transport_fc for reporting host->supported_speeds.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 28 ++++++++++++++++++++++++++--
> 1 file changed, 26 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index fa1fcbfb946f..6188f6e21464 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3330,11 +3330,34 @@ struct fc_function_template qla2xxx_transport_vpo=
rt_functions =3D {
> 	.bsg_timeout =3D qla24xx_bsg_timeout,
> };
>=20
> +static uint
> +qla2x00_get_host_supported_speeds(scsi_qla_host_t *vha, uint speeds)
> +{
> +	uint supported_speeds =3D FC_PORTSPEED_UNKNOWN;
> +
> +	if (speeds & FDMI_PORT_SPEED_64GB)
> +		supported_speeds |=3D FC_PORTSPEED_64GBIT;
> +	if (speeds & FDMI_PORT_SPEED_32GB)
> +		supported_speeds |=3D FC_PORTSPEED_32GBIT;
> +	if (speeds & FDMI_PORT_SPEED_16GB)
> +		supported_speeds |=3D FC_PORTSPEED_16GBIT;
> +	if (speeds & FDMI_PORT_SPEED_8GB)
> +		supported_speeds |=3D FC_PORTSPEED_8GBIT;
> +	if (speeds & FDMI_PORT_SPEED_4GB)
> +		supported_speeds |=3D FC_PORTSPEED_4GBIT;
> +	if (speeds & FDMI_PORT_SPEED_2GB)
> +		supported_speeds |=3D FC_PORTSPEED_2GBIT;
> +	if (speeds & FDMI_PORT_SPEED_1GB)
> +		supported_speeds |=3D FC_PORTSPEED_1GBIT;
> +
> +	return supported_speeds;
> +}
> +
> void
> qla2x00_init_host_attr(scsi_qla_host_t *vha)
> {
> 	struct qla_hw_data *ha =3D vha->hw;
> -	u32 speeds =3D FC_PORTSPEED_UNKNOWN;
> +	u32 speeds =3D 0, fdmi_speed =3D 0;
>=20
> 	fc_host_dev_loss_tmo(vha->host) =3D ha->port_down_retry_count;
> 	fc_host_node_name(vha->host) =3D wwn_to_u64(vha->node_name);
> @@ -3344,7 +3367,8 @@ qla2x00_init_host_attr(scsi_qla_host_t *vha)
> 	fc_host_max_npiv_vports(vha->host) =3D ha->max_npiv_vports;
> 	fc_host_npiv_vports_inuse(vha->host) =3D ha->cur_vport_count;
>=20
> -	speeds =3D qla25xx_fdmi_port_speed_capability(ha);
> +	fdmi_speed =3D qla25xx_fdmi_port_speed_capability(ha);
> +	speeds =3D qla2x00_get_host_supported_speeds(vha, fdmi_speed);
>=20
> 	fc_host_supported_speeds(vha->host) =3D speeds;
> }
> --=20
> 2.23.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

