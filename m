Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFBC0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 24 May 2022 18:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240122AbiEXSJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 May 2022 14:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237893AbiEXSJe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2022 14:09:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5B76B7DD
        for <linux-scsi@vger.kernel.org>; Tue, 24 May 2022 11:09:32 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHnMZv019759;
        Tue, 24 May 2022 18:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=dkx6ekfPhBCloJzESxOx2WRSqTXgKDI8ElkDP2tBF+s=;
 b=k0/rLQdRoxJqwPLP8KfNBpIaLdAx0usXkwGFC4A1fjv7ijKZMPWGH8TgMBQ9cdRB4r+n
 bZieDJt7VGYQqNvy+ZOXmnlc3Weh3LTxJvX7oCUG4IG6AHqnkR0AO0/3wg2YjSC7rDXA
 phlsDZ8dxcx5QqaiWpGjW3XNQY3jo92gPuYF+kVxViYJc2ExihJSi5cqV0FcgPLcmG0M
 DfMNCsP1bQcaMiS5dbS8HxI3TCYzi0w/95jX+4Xm135UDQudCZz/EImEdTLyjzoFOwAv
 gnX9VE1nsPh37MrRAn3FO6GE+B39W9F8kcrMbanSe/IfbjQ1MiW3QO9uu9beCVy9JUai 0g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93t9r3m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:09:06 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24OHwMQW038574;
        Tue, 24 May 2022 18:09:05 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93wprt1e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:09:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTk4jvRoadGH68+jpnz89VYuc3GDWarBA0LeCzhvw/Ujv2I3K3Ed8h15D/VU/dykm09e1SPQRTv8FpDHOqn+IDOYdKdReBhcEQMdJImG4CBBaJ2NFR1zIrnSgAZVPbt9ouOxtzPJc+zsdWDuVHNIsYBVzzS00Ai962+cqs/mPEr/Qrp9ypT05iHYVAk5Psk3uI+oMFuhVQIfZWifTcqlv0+2/jEv9cBN5Ox3ZGEA38TJNqcCABnw1W2SMzlutjhgA/xq9fQeXYVCioOaPkinUGnEdFLpfReQkfNoaIJxOgNMjuJfp5dTL6IczoYpq/UE3RG6slA+KeIrDa+uWCRc6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dkx6ekfPhBCloJzESxOx2WRSqTXgKDI8ElkDP2tBF+s=;
 b=buXTYbWtPhSIj30lBkAZaLI76nwk1ZM+Yt25hDFL2SGodcCdGohN+BJKqaOXJxLeEMw3zOrtvhlTDPklLKUGDjzUzxh/ZYCcquxEEQ7VYKfYp/qpaWsPVL2fiDpsLpiNjVNKJcsO+rJkS8YBR3QbJEN9pQrpzkVCVjsmh1e2MgEnukn4F9yAWU1vWwm5aKnwZw627QNxvfTAehf7VO9oeu+KhL8BcpqIemDwxFIW1iPkXs3gGtlqwvBX1Luuldmo9ZJTTg4WZYs2u0oHgRTDF4ZcVm1XTTR7yVRKU2m8BCXIodrsdyVsS6gXbwooK6IWKj7hfb0yxkfigNIf8IcYgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkx6ekfPhBCloJzESxOx2WRSqTXgKDI8ElkDP2tBF+s=;
 b=rY2ecLFinXcjA9wvslOwC80jCAGKWZX8pItqnhNRg9tGnNj9QJR3HnBgMJWTsPX8bcGV9VruePFZJm0Y9JNA0EWogMFdV25jli9lbSZzzLv9eaM00zb2A3DQoffrdsbkyY3NrP2bg9X/o5sa4hbav80IiNUzWFwL9jepFquJQ5U=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.22; Tue, 24 May
 2022 18:09:04 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 18:09:04 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Index: AQHYbobah7S1K+EECUWb/HaurQb5x60uVaWA
Date:   Tue, 24 May 2022 18:09:04 +0000
Message-ID: <5ED96E4A-08F0-449A-8A9E-034BCFF1C993@oracle.com>
References: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f2d0c07e-7fe1-44b6-f4bd-08da3db07cc8
x-ms-traffictypediagnostic: PH0PR10MB5893:EE_
x-microsoft-antispam-prvs: <PH0PR10MB589360469F9CE1E3C16882CBE6D79@PH0PR10MB5893.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N227pxzFGc6dyem8e+oRBq33CDT6maJAcOl8IeAUNe03v2kEyR8YChpbrN0o9o17566pjOXKXBD9D8qbNzofZgEEoiyRUC+MZ1xrJ++o3PCqkdDX3qYUPItlMJrL+UqvSJDU4oTYoWE/fGnCGurcdGDr5eo9f7PMFkEtvBMnC8Xxsz6C4PQ+fxKbAYLN1g9Mk5OGKmeINqOrV+My06EtZ2mNybK/aigF/amkzebtTylZFYKq++1aZOkhChOezp/qIgILs+PF2xblhAtHtWMSng1W49PCG+VQnUNwGXIC0+Zl4gB64VCg2PiwxpO/UGP6LfaajcPkc0d6uw+DtilzkZey9gJiHvLXoL8RoyMd1JBHtdC39Lt/NUaJUM3mCuhLidQFINXV8fLqtiZ4d9/a2DCPxwPOCNoe1UtOSmjvRPRwZe7Fe2k9beUVKGFKq7NFGwDWl98caAi4nixquz9yIS7g/uVlh8zo5zEcJFGXH2QvIgUvlrLzESgCsz/WgmT9JZe1HYf3TTbgcmCU8Dm9rxjFffRItFTwqg+Nm4J/zMAoyw5Z1iEYCi1DgxKNAS25sdSH9dhawT857/MmYOfjZGxwzjUDDRxX5JUItM713SResmb6eW16pnTD1dlKjW+X/wCcM5jSUyPw6Z+dc/Sp+KDeAW85uVRfbK7k5BAnSwPZH6S0irDIqDhLykPfYZ0rpEP1miLug68nSdywXr/R9cWdKSAV1egoMvlgPQBTEhn9C5G/1dfR8b1Ul9JK3fXi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66446008)(66946007)(66476007)(4326008)(64756008)(86362001)(76116006)(71200400001)(83380400001)(66556008)(122000001)(36756003)(91956017)(8676002)(6506007)(508600001)(2616005)(186003)(6486002)(2906002)(8936002)(38070700005)(44832011)(33656002)(5660300002)(26005)(53546011)(6512007)(316002)(6916009)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aWrP5tm86bLOQPvxqQ4loOgwwUzuabJ/EBRhsfoXl0qnyIOHZKf3+GK0wujy?=
 =?us-ascii?Q?JZMOxn6Hf/1dam27/4/GG3na6SMbVf6Wj8lrAyjGGBerIKpMxcRIzi1AgHka?=
 =?us-ascii?Q?ixBQhLdZ5hh9JNGqVtetsxj/XlfRNUa+qAoauWG/ejSrB6nABzGm5F04xykL?=
 =?us-ascii?Q?T7y+WunV9z2YvILdUAFYy2wtqdOy1ZPTP5Y+A9fQEbxApgo7X23qjZCYmiRa?=
 =?us-ascii?Q?kjo8Ilvb+qqfxId/NiiTsvXZSulc6Z0wkVsgbaFodkbtVZqUMIHosUYGATTI?=
 =?us-ascii?Q?eb4/uLxhAe8e2ghBhtk6uMTr6yHVBKsYQCIFdUHatUm37nV5T5eU20FtvPtW?=
 =?us-ascii?Q?+rRz7U4eX/kLYmbi3Ov9RmCHZTXoMjxZXCcwVSbnH1c6QAe7ixiNeRPcEO2S?=
 =?us-ascii?Q?Js6QDBHs+2pvGY5elyQiOEVC8tf0Or4PBVIyhxB4mM+nzTDyJp2kguHgitIZ?=
 =?us-ascii?Q?lH8wQaUTz4YE3EVThvai409uuxOjBMClc/zVcodA4PAOiqIUx2BSkIIGzfyS?=
 =?us-ascii?Q?kTEt/WyD4XzKHyGcoBwWkB3wOM/e41MC7euYQ/mgM7SScW9kZmSnJQL98x60?=
 =?us-ascii?Q?UBXuS2bXRaPeuWfb8lFsuoqNDcMKvvDYHrIKJ8ymiAPbLYL26cmAcVLEQhSe?=
 =?us-ascii?Q?1POgsnz+vned4K2wpXw3ubNd8g8t2VGOaS5H8XxclZxWFV8pC5J0p4jEuQHA?=
 =?us-ascii?Q?RULbQUEPDppimT+ByPyOrS3giO6uRjGon1HVP/sbkVU29dB/zvLByV9ue0P2?=
 =?us-ascii?Q?bY3ZZlgB1CET0OYRIj+47pNYzptxJ2P+Neeq+TTKHP3DkwVK/JKppMlCUcue?=
 =?us-ascii?Q?dIWwinsSBnjF5cLzoa06+BT1Hz8Y57NMX8Rt1j39Qp2+TlH0gEG2KPr8Yn2W?=
 =?us-ascii?Q?FpQ+3MfwE/C3nj2aU+ofuWnR0bBI89Y1+H4ynl/oFQ13Nsuf8hSPHgE/gUi7?=
 =?us-ascii?Q?Nx4p7FdAA7H/Z6FnPU82Wy799YUQ/bwpfRX+8tkVNwdgCjVBPkEdMyUugITl?=
 =?us-ascii?Q?ALaLjOWLwjPLLdJYlr8AozDhpFsahKJItP+YgRYCxQN4UH+RSsPQdUnVOxcd?=
 =?us-ascii?Q?nGu1e/6pvdbkEDu5Lg0P+ksEXlFOj7wXQ5wqO7gj1QmRcxzhfRFto8anCyYW?=
 =?us-ascii?Q?KXFzIx3bx9YeLBwbN/UN5Hcrr5Rn0Zk3lzg5Fyg1h3oBr2gmpc4N3kydCsXq?=
 =?us-ascii?Q?JIw8Iha6QbJE0+icnAhnXWd/e3J7IdjVjmHqgQK2PqOe52YbCB2Nmmx/GvFW?=
 =?us-ascii?Q?MFwvr1ryb9CXjYQHJpJhS0BZbpUzc+wGSjXUIxNLcxz1q2NXBlFa+rgQPiAa?=
 =?us-ascii?Q?ZmGcKIirOrp4u/a3M1iobLFHrTktFVEobG/xER85GnCXbprlULSrY+Yyn79D?=
 =?us-ascii?Q?odcz31ygoZ7LoFDgKtwGtWnPJjRC05lcw9RdWUyX5A0zbjvrpdr9cXvoDlh6?=
 =?us-ascii?Q?0l0OhfSq+txwiJn4sMwNZqs7Pzz42DM+OrdICcrx9rMDBOHdxstM70OfpJnM?=
 =?us-ascii?Q?byxifrq1VPzBVNnkgIAKx2MfLJtke9aEIBBHyFxG7lWZoJvMjYE1z5onAtW7?=
 =?us-ascii?Q?qdwiPU9L1ujophmY8YUz6my/s9COJNn4bJ80EMAA/Gf/A7DMiNu3Myw5cceP?=
 =?us-ascii?Q?UzHfPlP1JvqN2NDKhGag6m9eZIK49E/tcSgoLM/JWadN5CQnkFMqRMBodvpp?=
 =?us-ascii?Q?fFygQoLq5ynEB3h3btRuQp2nHDnGitQ5FpofKIhLIS5YfDNmDVzs8EdThYyw?=
 =?us-ascii?Q?lxJdCwuwIEKsZv3SKzTjzGbmaaWX34npYu59FiQAP6Yz2UrjunfM?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F33EEA5EDC7ADA4A9A0ECCBDFBC014AF@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2d0c07e-7fe1-44b6-f4bd-08da3db07cc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2022 18:09:04.2804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dcfdg2hVm6Qjhyh2wClIdE9dIVZmtskXRXUIhsQeCskgc+g92dLl/4Mcs4SHGNGWv07GOzfUkyitcNsrxdcSfz4VGgpRFlkLWnMAYm1tHUM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5893
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-24_07:2022-05-23,2022-05-24 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240089
X-Proofpoint-ORIG-GUID: PVS1rwn0gW2oDP33XVTeEZKiexOiTk_-
X-Proofpoint-GUID: PVS1rwn0gW2oDP33XVTeEZKiexOiTk_-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 23, 2022, at 2:24 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrot=
e:
>=20
> The ql_dm_tgt_ex_pct parameter was introduced in commit ead038556f64
> ("qla2xxx: Add Dual mode support in the driver"). Then the use of this pa=
rameter
> was dropped in commit 99e1b683c4be ("scsi: qla2xxx: Add ql2xiniexchg para=
meter").
>=20
> Thus, remove ql_dm_tgt_ex_pct since it is no longer used.
> ---
> drivers/scsi/qla2xxx/qla_target.c | 7 -------
> 1 file changed, 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index 6dfcfd8e7337..d03b9223b75e 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -48,13 +48,6 @@ MODULE_PARM_DESC(qlini_mode,
> 	"when ready "
> 	"\"enabled\" (default) - initiator mode will always stay enabled.");
>=20
> -static int ql_dm_tgt_ex_pct =3D 0;
> -module_param(ql_dm_tgt_ex_pct, int, S_IRUGO|S_IWUSR);
> -MODULE_PARM_DESC(ql_dm_tgt_ex_pct,
> -	"For Dual Mode (qlini_mode=3Ddual), this parameter determines "
> -	"the percentage of exchanges/cmds FW will allocate resources "
> -	"for Target mode.");
> -
> int ql2xuctrlirq =3D 1;
> module_param(ql2xuctrlirq, int, 0644);
> MODULE_PARM_DESC(ql2xuctrlirq,
> --=20
> 2.36.1

Once s-o-b is fixed, Please add=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

