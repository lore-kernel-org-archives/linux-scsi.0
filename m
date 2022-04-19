Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3986FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 23:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343702AbiDSX4k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiDSX4i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:56:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32B32D1C5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 16:53:54 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JM8Pl9024809;
        Tue, 19 Apr 2022 23:53:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=HdOYnXPZUPVeOemXefKPDoa5NH/K64tgiUaZIR9ueM0=;
 b=y1BNOI6cgtEoETUAXJcN1/OrTy8/5nSopqpm8eBqTiT3a4EaxElmeAlNts3zTsxpw2/s
 oL7m/4PChpztvtf3q6eNYsG/kBaJuS8YleOM54t06Rg/PUJVPj0PCQlkLs/pzfVUhmnA
 T57P67j7UplxS47O8aARfmdl0L9hcv3+D67Urc6jYrDf1LXCLL63iqp4ZbfAkv0UbiGx
 /+PnmJgVs8wbikoevWh3Hg3IJ79k7pHezX2g1G73egJ186pXkJLEVaBfPlGV3kcP1QCO
 urSSjaplfsEbFQh8BBxYtiHHB0rqDJjiE4QhR0WkrS2Dqs5Wy6sZQJ8t2nD4OKe7ko2W vQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9fb8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 23:53:47 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23JNpgT7027402;
        Tue, 19 Apr 2022 23:53:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm88uxcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 23:53:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TLyZ6RXYfoCC67Se6VQqFo77IqqrF04W+Tt+57EVzA7U0qhSiJpcCIBR5lT91a5NKjNYYI5GZlbJThjf+A40gPfnVhvOgA0OJMDfv4fAENFCb7HMHsARjAhiYBUBJsxwuCsCYSQ2+IJ+PAeBgJ7WtEoSPWjSs1X7q2NLTwDb5yi4IzPgcA4OY2PqXqIQXe17dQ+srH8uijjtK8leTEF/xQO9QSGaaqwQYzhsPP2g+WsASK7yvaJTdHRNWkMnXUdUdj8T8bZ/y/rdE+XCbIPRMEbCEu3vAxML2h2AQHGFdEWcb4ZwQi21kDe53v3FUPlN6ijSziEUaDUJEBqSu/FI2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdOYnXPZUPVeOemXefKPDoa5NH/K64tgiUaZIR9ueM0=;
 b=fWB89TIVRLk6JEKJxpnKdUsDU55UcoKuh3NdD1cCyx3TlQY85StK1JBH7v29G/7VmtfvMlm1P45DOqhxpZf6IVCJrJQCEWAiIFzKdo7nlYjqARpyrFQikAj0446sxNOD0kZ578H2xeVAxmQ/n/wgxFn9TLG/vZ5bAoq3bpsMfAzg+Yt4sh7nZ016+kSWegpBmiyU4Bp8uT2sh+IffXLyuLWFsVr9GS+MNUm/dnQGKf/3uCe7mne9/jLI/27XEFFnr5GwYRK8za7eQPrT5mFnTgYCexwNJQQcl/YKAbYg3AqeFgnN7bBvVOqp6GIFvBTUeD19cdfOyHc4xogcSb/pFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdOYnXPZUPVeOemXefKPDoa5NH/K64tgiUaZIR9ueM0=;
 b=VT8AWywHla9DHDRThZ75bHlirgVrQfvvb6BvImPGeFp+mnG+XBZlOzztNpuUcgiJzq6UvUbfJ/8O43g9XB+22B78QApg6cHw4j/fMiUT1+bWrS5b3H9vdVReWH9zt+eOvItg79VGQzghuYXS9QsfMeoY/2crWVsT0eFbijRPxw4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5046.namprd10.prod.outlook.com (2603:10b6:408:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 23:53:44 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 23:53:44 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "hch@lst.de" <hch@lst.de>, "hare@suse.de" <hare@suse.de>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "chandrakanth.patil@broadcom.com" <chandrakanth.patil@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "prayas.patel@broadcom.com" <prayas.patel@broadcom.com>
Subject: Re: [PATCH v4 6/8] mpi3mr: expose adapter state to sysfs
Thread-Topic: [PATCH v4 6/8] mpi3mr: expose adapter state to sysfs
Thread-Index: AQHYT0cVt0Up9fgt4Ee1D9j5y87Arqz38tiA
Date:   Tue, 19 Apr 2022 23:53:44 +0000
Message-ID: <0D631932-6B6E-4D06-B9F4-90FADA84B897@oracle.com>
References: <20220413145652.112271-1-sumit.saxena@broadcom.com>
 <20220413145652.112271-7-sumit.saxena@broadcom.com>
In-Reply-To: <20220413145652.112271-7-sumit.saxena@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bdce26d-e0b9-4c5d-f888-08da225fd699
x-ms-traffictypediagnostic: BN0PR10MB5046:EE_
x-microsoft-antispam-prvs: <BN0PR10MB504629871F3A5291487C4B68E6F29@BN0PR10MB5046.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IH2I0F/LvJC2RCSbRZQ0nhvUHjH1nx+GkjVmeVKcRkuw301AbSnk97sTazfR29+zTpj92bT9hmReIhPeeFngqHKBBgzt6dLNrSHQqP4O8OaLG4nxujM/ChpHsFPND1Co7PKeJ0kKuQffMAPS+rOW5aRlJjep15B7CXkviAaSE6317N012eppMqZvLPgYWD33LUgPJrRevyBhD6RhBs8WXY5lKV5N2DJX2kjTa+qEYrcQI+vp4eKR0MJudEJKJo/dbYLRCeBHISvLadjLruTM/iaPZ7GV3dsVUsZ6XhSbx6HfLcCPRRd8Gampg08rt6rSi/EWCXDsq0BfBXCFZ//Td6Fj0iz8SUc9np6WqMO5CBEHv1qe9VSpURxbp3DIkiCn35LspazbLmTaQIHFQMZ6MKtINeXIiXbJJkWbt94weZjRWy1h+my6gS1ucVP1b7SmWXPUIQVIH5NcoGJwQ5p+bQ+W4icpfVC184QPGHbD5oMy6zWxSLNKWbMARuInkqWrONk3pLhCUio6add1nftpeziBBV+0CE7cjvZQ1FPUxg2MWxtRgFAjsUNssv9Biv/l6oEC/QAcyz1Kih+nufudyo0Fx1extMx6egyqwPD2sk/vuyr/PpwoMxq6jxLajj1o/dYBeX3lEPvFVI+EVe8u7MXi1hYU5tadVcY8cB0w3AbVkmGlfykwJZwJUKh6IXhEZYZevCq4QWA83YFAH4RAievuIH3Q0G0EPd3Jkp75U7dwqXDyBqp+wb+fwXqvFVXL1RsXDGGU059Kl/6Ua8HW5w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(33656002)(76116006)(44832011)(66476007)(186003)(6916009)(86362001)(2616005)(71200400001)(316002)(36756003)(7416002)(5660300002)(6506007)(6512007)(54906003)(66946007)(66446008)(8676002)(38070700005)(508600001)(53546011)(83380400001)(122000001)(8936002)(66556008)(6486002)(4326008)(2906002)(64756008)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wcjRL7X3s3MsNhYp5MAo5z8DHTAdbagvc6N7uX9IwO68WJAVP3CpXf2CnK8U?=
 =?us-ascii?Q?bBE7S/I70wt+rsVX37vdt6AXG7E4wXt6vtdPojA08V6bPAm5BMvX7rAwiswG?=
 =?us-ascii?Q?98iWnrP7p0z6qbKaGL4hZSfJdsIgCXyn4dSfBBdAd3vgkN4R1QGGxnHg9Jl3?=
 =?us-ascii?Q?fY7IvTQqyEWWvTqUFWE634wcN3UtG3jK0LJcpfxOx0kJWlEKKjkvIy05SpzB?=
 =?us-ascii?Q?wmw+pigcjNXY3874pz6oG1mZ8WoNF+rSWKpbCI+CNVeslT6An/PGI3F635Ka?=
 =?us-ascii?Q?x6uPwekSAadd4o16sJn7SwHu6CqMj9er0VMNTM0Jsf9EGnOX60IYvYtZ7iu5?=
 =?us-ascii?Q?bPrbnQUKJ4iFDMwqJTuQt3TgMIAR/CCuIX+KRizmYSVArJ6qfCyyt7SaeYZ4?=
 =?us-ascii?Q?50HycQ1zLqkARsnjE5eQt2US+PuVGgBW1uBgolglzpZZMJx+zLK/h5URhcMF?=
 =?us-ascii?Q?KoYO5ybWPIuVKmqAu+cL3OTWIGwp/jEYzDmaFzNyvCHsbtx6b4pObRONwu/c?=
 =?us-ascii?Q?w13WSaxUbI/KlDEeGmDqO1jyQGpzQEA3YqzDbRwIU2aOjVz+PVMUn0sQe9Q6?=
 =?us-ascii?Q?R5X0RcNtc9bvtyv75H25mI7RYXXTcuclFKXY9ez/KbiU0807eBbFFn/1sGsJ?=
 =?us-ascii?Q?XVaKrGAr4tg0kv30fQ45ft3bn57jIznR4I+QGOsh5Iv91zHPUGz/evlQLLV7?=
 =?us-ascii?Q?19rWo0wgIoYm3n5Eztm/Csu1AbzJL8rsB8sCydkrsthICJE7lnBQLNIGurpn?=
 =?us-ascii?Q?28kHlC9ZfFgrAUU3jzlDCJCigYz4RgzwEYk0qQQJ0dndNdxuBo5PGD4gBrUf?=
 =?us-ascii?Q?zJlGkLtmDqI+Q+9kjwfMuFm4fLrD/2YfSzwDQb5KHa32m0hlTs/vypq5qiFq?=
 =?us-ascii?Q?IFz+2t+oLYEoSDGXgV3SxjwbwaTaQJDqWjJ0sCo/TpM3WKrU4Mudh4QTMv8E?=
 =?us-ascii?Q?vqOI1X+7eF+a0RUU7iGv9XbCk3JwoYMOqXZf4HBTUw26RJXuS+zng89zXUgI?=
 =?us-ascii?Q?iqpRrbjUUAH8Im2r+ZAoyL73YcrG+/J/XHu6gpLpFnUzQ+HPSYMwgc2NhXs4?=
 =?us-ascii?Q?c4EdsvgZ08UL54drenBIsUbotdCwH414SRJP0dy3ob7xBlgdP6k/kjSPlp3+?=
 =?us-ascii?Q?T7dKicP37CLgqho9HSUcIG2ANLrlL7iag0kZ0Ael5VwepEpqUV8LZMN5/Sp+?=
 =?us-ascii?Q?6wuzY8P2Upp5O/UmpOFCa0OsJQ3FonkK9glgD94GQEu5njBlWee8Qpj/DWZL?=
 =?us-ascii?Q?MYLN8cnhYxmlxI16DFbaKQI/b/4QIMRSD5bunvp0ecM3i46o1NFvRmCSaIK2?=
 =?us-ascii?Q?d3Y4vPnj2p4xFfu+ZUrtS7mYs6lcO+27okiblv/EQvgsaUwOUe6VQJzPhP7S?=
 =?us-ascii?Q?mF2MajYz4ibUpgz1KlAcS9S0QqMPfDJrHQkvdYZ7KaSnJUrH8uxYZi2hYO33?=
 =?us-ascii?Q?MxZtMWu4y5m5z8Sy2aLJpIU83LQDQgZw4b+IPWb03R4+BoSEzukYySSo/nmM?=
 =?us-ascii?Q?+LBXdmCBUPHyonN7qHTaIueRpLfTgFcs+VQALaOG5dtWyur2kPQfqEuVoH3W?=
 =?us-ascii?Q?oSPePDOEZlOPlXAhfqfYpZKO04loTSV6BevA5s2E514AQo1JTGX7tbpxRorc?=
 =?us-ascii?Q?P3HeM2sRzJgw0tZLE3cW6f+51BxLhwhVL5gctxOIeg7Eu+/xgsQaKvfg7lsL?=
 =?us-ascii?Q?2EvW38kTTXEfB/8tyn0/6uGSbHfcMoae3gwk8O+IoWDVUeKDawaQKjdD+fPg?=
 =?us-ascii?Q?O2TcZ5Kk8Nhmh8JY87aTBjTQatEuHRRAvPOYXqAzyZ/8sWt8ANz3Cd8UOf9Y?=
x-ms-exchange-antispam-messagedata-1: 04+Z2Cf+wLohyQ==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE06BB0260D81F4AADBB1E3BB6BD0C35@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bdce26d-e0b9-4c5d-f888-08da225fd699
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 23:53:44.3530
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uRLPYKl18i50UAlXugoVp8sobUDybs3DhHv4VpJLLmWtE84UhqstxX3kSdRuVem7dVzeq2J4SDunakAQhy/d4+TY/iRTMvvEBlQKT9LDtQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5046
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-19_08:2022-04-15,2022-04-19 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190130
X-Proofpoint-ORIG-GUID: gbBjFmta1U3XphtPalSnoUP4AToWC1xh
X-Proofpoint-GUID: gbBjFmta1U3XphtPalSnoUP4AToWC1xh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 13, 2022, at 7:56 AM, Sumit Saxena <sumit.saxena@broadcom.com> wro=
te:
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h     |  2 +-
> drivers/scsi/mpi3mr/mpi3mr_app.c | 46 ++++++++++++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c  |  1 +
> 3 files changed, 48 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index cc54231da658..1de3b006f444 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -1056,5 +1056,5 @@ int mpi3mr_pel_get_seqnum_post(struct mpi3mr_ioc *m=
rioc,
> 	struct mpi3mr_drv_cmd *drv_cmd);
> void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
> 	u16 event_data_size);
> -
> +extern const struct attribute_group *mpi3mr_host_groups[];
> #endif /*MPI3MR_H_INCLUDED*/
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index c5c447defef3..dada12216b97 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -1217,3 +1217,49 @@ void mpi3mr_bsg_init(struct mpi3mr_ioc *mrioc)
> err_device_add:
> 	kfree(mrioc->bsg_dev);
> }
> +
> +/**
> + * adapter_state_show - SysFS callback for adapter state show
> + * @dev: class device
> + * @attr: Device attributes
> + * @buf: Buffer to copy
> + *
> + * Return: snprintf() return after copying adapter state
> + */
> +static ssize_t
> +adp_state_show(struct device *dev, struct device_attribute *attr,
> +	char *buf)
> +{
> +	struct Scsi_Host *shost =3D class_to_shost(dev);
> +	struct mpi3mr_ioc *mrioc =3D shost_priv(shost);
> +	enum mpi3mr_iocstate ioc_state;
> +	uint8_t adp_state;
> +
> +	ioc_state =3D mpi3mr_get_iocstate(mrioc);
> +	if (ioc_state =3D=3D MRIOC_STATE_UNRECOVERABLE)
> +		adp_state =3D MPI3MR_BSG_ADPSTATE_UNRECOVERABLE;
> +	else if ((mrioc->reset_in_progress) || (mrioc->stop_bsgs))
> +		adp_state =3D MPI3MR_BSG_ADPSTATE_IN_RESET;
> +	else if (ioc_state =3D=3D MRIOC_STATE_FAULT)
> +		adp_state =3D MPI3MR_BSG_ADPSTATE_FAULT;
> +	else
> +		adp_state =3D MPI3MR_BSG_ADPSTATE_OPERATIONAL;
> +
> +	return snprintf(buf, PAGE_SIZE, "%u\n", adp_state);
> +}
> +
> +static DEVICE_ATTR_RO(adp_state);
> +
> +static struct attribute *mpi3mr_host_attrs[] =3D {
> +	&dev_attr_adp_state.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group mpi3mr_host_attr_group =3D {
> +	.attrs =3D mpi3mr_host_attrs
> +};
> +
> +const struct attribute_group *mpi3mr_host_groups[] =3D {
> +	&mpi3mr_host_attr_group,
> +	NULL,
> +};
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 19298136edb6..89a4918c4a9e 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -4134,6 +4134,7 @@ static struct scsi_host_template mpi3mr_driver_temp=
late =3D {
> 	.max_segment_size		=3D 0xffffffff,
> 	.track_queue_depth		=3D 1,
> 	.cmd_size			=3D sizeof(struct scmd_priv),
> +	.shost_groups			=3D mpi3mr_host_groups,
> };
>=20
> /**
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

