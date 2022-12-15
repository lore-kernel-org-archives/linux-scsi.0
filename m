Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5101C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 17:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiLORk2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 12:40:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiLORkZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 12:40:25 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560AE4386F
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 09:40:23 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BFEn15S004453;
        Thu, 15 Dec 2022 17:40:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=M1pcEb/hGh+UJP3jXqt8/IOaNF8VR508v1hlauTN85c=;
 b=yETc15cgiQFb69TZLAIleTjOH92uDbegZmAe+LAV/iHb9zbeMsgI2Ls/0wtGpiJFUuqP
 TyCanRebLKua+kA2ATYNa84wwO06gyMZmr5MNMPUzls6UNldcEFN5spdVdRcCEQ8i+S+
 NyVheFer+3k5d+9t2RUmxexd6+R700kJaLMCZ4cSU++A6fp+3iy126ozEEIzL+TujtC1
 CZey1fZE0dBPwDaQiZsixi5+9geTAFAFfFu59ERaugItdf7/fhwccnvWuahfg9QcnwEV
 d03AVmZ1YxGQSxPlE+23q1Ky9/RBSF15JRvKSHVczzTtdDBJWZ/84queWAhZ+ao64TP/ tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3meyeudr24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:40:19 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BFH7aiX033067;
        Thu, 15 Dec 2022 17:40:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3meyer2s0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 17:40:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTIv+V9PRJpowipZAsWJr8Rf0ksw18l5E7yXr6ErArBcqr7Jds89APmz4kSh694je8PxHUPcliUBh+tFFJCG7W232Amcno7/kqNpG+jCP3i9Z/yBht9Po4VrqBpeGhzY0T69O3iZNb1wkjMkW5mz6XE1qqX7UsV4NvxCcIO5jaYT28j8xXFzKX+tjwbvs04eg7Qt7o3fMs8sS5HGmO0tLV+dD6faxqF+RzML9WWKlwY/w3wgCgO9jmKsfw5J2KW435L9QyUlOXx4Ly72zhG69IOKwIn1CPWtnu0n1ua304z4Kjju9pNo+7IsoxoPsVPzdMsEpLyG2m2DMXgOLBWS0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M1pcEb/hGh+UJP3jXqt8/IOaNF8VR508v1hlauTN85c=;
 b=CRHwJTp8dpQlAaERkxFqqbvqafMMMNFxLCUSFZnAdKVUzD3ikofmyXXeQf6vE/ABzN6+dOeIUagynkM+UT00goUuaj8LV1c0UtgjxVzf5segGisda5iBsL1LhAkFl9K+KYSKEce9YaCUreEEGt3gQF4zLRKL/dyY3KILlqatNhYjTvB866lBXdj+urhm+SCpY5jbYdwEDP+ehK8W2wwK1RhFnXrglsg3PyQTE6Y3ll5OtrfbPDUrypgC8CTe4BumHb7um55wZOmAYRCMs5ojjUf4bYmbMJC2Un6oJsl5+pYQZET8fKBiLrMqy8tMhfy10Rpdur/R7WCax5/Pm1CeOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M1pcEb/hGh+UJP3jXqt8/IOaNF8VR508v1hlauTN85c=;
 b=hHJvp59Xs9x2WzffIdwGMqjbWQpmV20s5NP61nC2lRjKodn8rTqynR7kjkHfp/NHdZ5QYb4acPXBnDMZmla5dBQRWIBDq95CNDXeCVVE12ngxQiOaBjhi8lji1WaCAv33S/y9nfMDjpsqkmBI3594FGjV7YRgSGwIBfnped4BaU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by PH7PR10MB5746.namprd10.prod.outlook.com (2603:10b6:510:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Thu, 15 Dec
 2022 17:40:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5880.019; Thu, 15 Dec 2022
 17:40:15 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>
Subject: Re: [PATCH 08/10] qla2xxx: Fix erroneous link down
Thread-Topic: [PATCH 08/10] qla2xxx: Fix erroneous link down
Thread-Index: AQHZD3ehaA1AedFSCkOJARm/qNYDuK5vOaWA
Date:   Thu, 15 Dec 2022 17:40:15 +0000
Message-ID: <17CB24C7-744A-4182-9668-8C1AF84426DA@oracle.com>
References: <20221214045014.19362-1-njavali@marvell.com>
 <20221214045014.19362-9-njavali@marvell.com>
In-Reply-To: <20221214045014.19362-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|PH7PR10MB5746:EE_
x-ms-office365-filtering-correlation-id: 4a85448d-2a18-4b13-8fbb-08dadec36d2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lKF/T6rsHBWDid61KnBxJxTiWCRGmQD4saqMmR/NWOBKT5xFgwc7G4nynIWgEO8oe5E3rihuldacpFPSHSLIvx5oNTe7rqJ1dWUmz8eSecbVLS97O0zRCKZFPc2mNRRrozZRKyYi1bp/gP6VZAdZAAv7kCX2mvRbwXSwU4By6nL3YTqZXK5AQgw/Pq/ofeu2HTgvw9HndsvrcMWVUL4RRarbwQ00br3L6LL1sq05vsygfnN7gN/varnJ/RruIyHUB/Yfro4wdvHg8YxiGEX0GhmqH9wl9pYnnvUJJciM8pObdGxBB/0NX+4qM8L69uX6+4/ItUd1VYGDqubuCRWcG+ZOmoyrkTKC5ZAxdbZKmGT8UtzjMTEzOorzsCgappcuiUZQz9VjVyBneozEvkDfoQ14e6nscQL8t7CPemFJ/FFcefm7kRgnpf+4M/GyoDNjuTiIYwH2saOYhQGEZyFMeAGX35na/AVC6Z9RAKZJbsKqS7pWMjecY808j6fI561X8S9rwUFYppVW/uM14TiR/hxhCkXMmfq9AbqXE0F4v/vFxn0nRRsAiGK6pu/A5f6dc6WhsNndhWKuCE7KLkF0Vacw02qgQAzChir/HyDdQZMzva+lSrGlGjcBCFhIUyuXpB9xkZzB81IzROawlekbVn4P78YUxtFZn/mOlcNF1HutpPATE1XfEgKAvOFKLGxh9MWY/7uvqqtESC8Bbk2qmUqAir1bMefvYL80WawJs18=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199015)(36756003)(6916009)(38100700002)(6486002)(86362001)(71200400001)(8936002)(478600001)(316002)(38070700005)(54906003)(122000001)(33656002)(6512007)(186003)(6506007)(2616005)(53546011)(66946007)(83380400001)(76116006)(41300700001)(44832011)(64756008)(66446008)(2906002)(66476007)(66556008)(8676002)(5660300002)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YBJJQEMI6p7WBGy3mkm2sRIZNxlf1dbjGyIBoR7DCGosljFN4x4IVSmRcwfB?=
 =?us-ascii?Q?z26k1kDmcrZYn4p91t+XlCHb8sLmU+dZhLtzLEAVdwzEPkoHPEGwo/1v3JFu?=
 =?us-ascii?Q?DZIHppNrGy0XT9SBiR+KUXhuCTltofMC6STcrpLY7t+J4i+6PO8mIOA3/1Ea?=
 =?us-ascii?Q?evmdMxnQMlD7d7I9dTkxZCNuLU8aDcPL+ib4ankqRuPU7o+CHlYciYRw/jcZ?=
 =?us-ascii?Q?FmhdMd7JCD4x9NpclZ0v7IHtFLtAQdxzNvVY1r+dBqruE6gaNvwYtegZXxH3?=
 =?us-ascii?Q?kntplcwq8w1ucJFMlKyPmekQSyqyMrxA9xL2c60mkD3AxQUNX6t9cl7otcR0?=
 =?us-ascii?Q?nz1HIxhfFwalz0Wz4poyzAwaCCY1If7/rIEenIvWzu+Fe5StsepjPbiuKifn?=
 =?us-ascii?Q?cwRJXarQtp2Kt0t5nSXhLTSZ0hkJnGvegSbLWKzN/OPp6o86DQpoQuLhyVP1?=
 =?us-ascii?Q?tjO9hhXdpfayILFEFoqjU6B1IRMnkyxdM+4v5gSDfbwtlQytS9YdrVO0VbCP?=
 =?us-ascii?Q?pOHZ4QSDT6itkeoyWAJod3cOw7KiqQ3UnRafsF0OTVIQHvrE9QY29ZQe3kwJ?=
 =?us-ascii?Q?TOejnZPDKp546SmBh2AB4Dp0mlYzWTtcUH8uxId4xGBzj46qwN8lRvVG0EkP?=
 =?us-ascii?Q?oAUTmfF9cdsJrsf3juvdRWIktZSeFpqXEX3DHDWv3A97BbjzvoPdeXkaugJ0?=
 =?us-ascii?Q?WEF7jCIyOGXmdW9B1Lzw4gD4JJ9g7rTrzpaG9QvFV6xdYcG3PIkOhjIIfQhM?=
 =?us-ascii?Q?EQQcI5GIMui7tNpDQDewteNUwYPZ4hc6IBEf+FFT5oq+VfZX8847GnGnEwwH?=
 =?us-ascii?Q?LBPnEWtmKMULYnx2RDgVK7D2OjJfx4Jm7AJAFveGoqiDxTdHJkMZsU5o82LY?=
 =?us-ascii?Q?3rl7ZiMrkTeFEdYrGSXJ1G2ciohoa5+f7x07bLc/tC0W4hDFeR4eWvLmBbuo?=
 =?us-ascii?Q?2pzU/sLT877Utmd9TKkRMB4oLWdI+nFvPS62IZLnanxbBUY829JwoWVkiB1e?=
 =?us-ascii?Q?rZVGaixLxLTlIDHxjfWH/KJcCNGxYrz5LU+JcExTSK0tZ439GC6jyofVQKKj?=
 =?us-ascii?Q?ECMDhYSXej9CToxRx2voFaMrmYZWBvcMOuT2DaDHX4Oa02tN9BqgDxYHmX3E?=
 =?us-ascii?Q?h+lyt4GxQ5S9CMn8gj9ZBFdzfKsMMasAIDLgrA3nmvcUEISOhX+ITueutKNj?=
 =?us-ascii?Q?D3pogwli1IVEhC296696KEutslOr0RotfYYDHmAvasSD7f+Mz2Yd8tMvWR4W?=
 =?us-ascii?Q?TyVRMBfT1TlY8yEbQ/SPAKsXCY7/SSDPR0YtqPGxZmMlDvjLz7vyoS0KKbaR?=
 =?us-ascii?Q?7/iMrvPPLWlTAzZ5IrqGSUJHjpN0dwLkR1UEXLjOK2blv7bKv3IczWZ111lS?=
 =?us-ascii?Q?rl47Qr7hb6TiglNlTraWIjt48gMBLc64RQ01dmZLDbEFw28vffu11M9jMacY?=
 =?us-ascii?Q?e56Axp2yZOUpX3Aduf1QaAqZudP70+FyAeGBh7RwQwctdYyzSOcj4M8BOpd7?=
 =?us-ascii?Q?zn/37VKl/mKgzLDeJsLC9hFbBqii4tcXAauMkIKo/chzyAVdK0OLyh6a9wfz?=
 =?us-ascii?Q?l1FZa2drMH31GljOiYGzFn6soGHXF2eQvspOTMkKmDm0yZ/ExbV22+cxWQGf?=
 =?us-ascii?Q?fUclqNT/SzDpWazmcBvK3ZKJA5jVZEFLMLdZGZ6YnmdL?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <818F9C5F5F1EA04E8DDF26B78EEE75C0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a85448d-2a18-4b13-8fbb-08dadec36d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2022 17:40:15.7503
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S/JhkpEoz8oDCoLNO2nMyYlN/b49RMlJuWwmWlqc7YoJab1g/R7EjQZWNsC4GgaXIW1djbLxfrJI2z5aQSAwixEgoJkrUk0iOEaArPkNHpM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_10,2022-12-15_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150146
X-Proofpoint-ORIG-GUID: FgHHKejlyq4szD9vV9y9XUlocpKRZlwk
X-Proofpoint-GUID: FgHHKejlyq4szD9vV9y9XUlocpKRZlwk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 13, 2022, at 8:50 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> After adapter reset, the appearance of link is not recovered,
> the devices were not rediscovered.
> This is result of a race condition between adapter reset (abort_isp)
> and the topology scan.
> During adapter reset, the ABORT_ISP_ACTIVE flag is set.
> Topology scan usually occurred after adapter reset.
> In this case, the topology scan came earlier than usual where it
> ran into problem due to ABORT_ISP_ACTIVE flag was still set.
>=20
> kernel: qla2xxx [0000:13:00.0]-1005:1: Cmd 0x6a aborted with timeout sinc=
e ISP Abort is pending
> kernel: qla2xxx [0000:13:00.0]-28a0:1: MBX_GET_PORT_NAME failed, No FL Po=
rt.
> kernel: qla2xxx [0000:13:00.0]-286b:1: qla2x00_configure_loop: exiting no=
rmally. local port wwpn 51402ec0123d9a80 id 012300)
> kernel: qla2xxx [0000:13:00.0]-8017:1: ADAPTER RESET SUCCEEDED nexus=3D1:=
0:15.
>=20
> Allow adapter reset to complete before any scan can start.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 1fc4e6209db7..6e33dc16ce6f 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7095,9 +7095,12 @@ qla2x00_do_dpc(void *data)
> 			}
> 		}
> loop_resync_check:
> -		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
> +		if (!qla2x00_reset_active(base_vha) &&
> +		    test_and_clear_bit(LOOP_RESYNC_NEEDED,
> 		    &base_vha->dpc_flags)) {
> -
> +			/*
> +			 * Allow abort_isp to complete before moving on to scanning.
> +			 */
> 			ql_dbg(ql_dbg_dpc, base_vha, 0x400f,
> 			    "Loop resync scheduled.\n");
>=20
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

