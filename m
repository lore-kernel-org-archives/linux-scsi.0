Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8A5C77B75
	for <linux-scsi@archiver.kernel.org>; Mon,  8 May 2023 12:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234060AbjEHM0S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 May 2023 08:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbjEHM0P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 May 2023 08:26:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F3D36119
        for <linux-scsi@vger.kernel.org>; Mon,  8 May 2023 05:26:14 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 348BJclx008259;
        Mon, 8 May 2023 12:26:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=vhssHyufg9LEQj6ra5cOXlxM20dIj1K6XgzaNzwXcK4=;
 b=gm69d47jOD3mMCjBr1QlJcWbW9QparOn9KfhmkNS7BOR8g/RFId/vVBOUGoCEq1m3Jxo
 N0CWTlZmrQvieIparDPin7O3uMy4dqo8cf2OeOnxP9yoE+EB4HeuXzyBl2qwmp628LhH
 uVwfCIpA8IrOmBCbMZK1Ras84V3KBAjEn0eTDa0D1NXrry0nJ1D7mnHCZ31IDQKkT1xr
 Z9e2gB2MTeNDaHpZI/E8fw89ozQyay5A290qSqDGdMsTQsLFjJYfXZFvEcT3ORoz1dno
 XH1oANs+juZ6k/qiWoARkftuygTTIROons7I0od9FPNVVYnZ7K5inUPEarfwjoDZ7Cuq lw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qdesbb84x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 May 2023 12:26:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 348CMwp4037164;
        Mon, 8 May 2023 12:26:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qddbawdrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 May 2023 12:26:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzZnsUIfbPYWV9UcTVO07ohk+7tAdO2DGHi7QY3I1COL0p3FjBN5Jvori9nGXjymmnRbEQ2mwNEVF2heoTJqeW2xtljjQfpkPkDZQ5hmG6hmkTkjJgPqKCkHMzwotcszBvy0GwkSDfjMoo5U6J/3/35QCYlsICEm1PnkVNCzYbfi0zRP72utSzS51Jg3htJ2T5T5A5N93SwnNxG1axranFdU+wGh3bWkQBh2IGDjLbx34fzsktIGWFlM0nW0+UZzZPGIymWWCb/2y3vPR9aviUC0Je/34ib4fY1Gfg5IfZLIFWB3QjlHwqvpzEgi7wbBOhc/eaBIwx8v19gRUh3DWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vhssHyufg9LEQj6ra5cOXlxM20dIj1K6XgzaNzwXcK4=;
 b=Y6AoJy7jiRZtpyFQJ4XAlAhgp2NH2TTv/tBt7VF9Jk1x4QhWDAs0RcXjw/6pU/KTK4QSGZfMXI1B8zNbkFlg8tOC4+bM2MpWAM5byDUGDH6t4I1ukVZgbUNnMgfxJVaZzQOWlvOG2vn20ngMXk9gQJUlWslePgE8S77Ci2za4WUaRRnnlVOvb1srgaho2+bHetmzGPRqGuTqsR8P6cjBEIgJzPYYIs2jBEP2GqNZGA7qmBGI+EmGg6s2KVi7NOdnVS6nliWyqEUbfnL/3AhpWY2vouNUIzPNpudPu4KC7j2IPHj+crQ3gqXUxhXKpnT5khbFOzegzNns29zQb7Ft2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhssHyufg9LEQj6ra5cOXlxM20dIj1K6XgzaNzwXcK4=;
 b=gTREOsQvl4ayGXY9SPIn5VmMIHr1oZgH9x/fkGup0dL1PIGjMTDu8tKW/lAqV1q2FT2VK0S//8DOhk3XNuYtpBdoG/kzkg+aFe63kuYFEpFVlhifepcq0jQFZgXCg+3IFHU8T8OSlvGK7lSDnNzMdv1T8Z+pJ1/rR2F2Hkz0+/c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB6946.namprd10.prod.outlook.com (2603:10b6:8:140::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.32; Mon, 8 May
 2023 12:26:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9a52:4c2f:9ec1:5f16%7]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 12:26:09 +0000
To:     Brian Bunker <brian@purestorage.com>
Cc:     linux-scsi@vger.kernel.org,
        Seamus Connor <sconnor@purestorage.com>,
        Krishna Kant <krishna.kant@purestorage.com>
Subject: Re: [PATCH] scsi: sd: Avoid sending an INQUIRY if the page is not
 supported
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6sn10by.fsf@ca-mkp.ca.oracle.com>
References: <20230505204950.21645-1-brian@purestorage.com>
Date:   Mon, 08 May 2023 08:26:01 -0400
In-Reply-To: <20230505204950.21645-1-brian@purestorage.com> (Brian Bunker's
        message of "Fri, 5 May 2023 13:49:50 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SA1P222CA0114.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c5::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 81980a06-56c9-4f5c-3b8a-08db4fbf6711
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hgSLzukrhgnJ8Lxq5a8nJ7nIdLl9srevd4tPXw/joEQXmNnv5VLN/Y0yF624kcqkj+/m1eyAaeryb/gfyeoiHPE13g4pEspeKre/NB8f4wj59yHYdyDlOfGRDGYZpsoNUXUNuClMpe6RnFU3AMiGCSTVwgCjcFmdKNUeo6DsDJZvS/HcVgt5oIRuxcQxfB2mCzsiycPaPoScV8Hg15GgWIPeKU0635oOMhvF2XUZXKGKwrsJbB2DbNJxkgL7P6SJxsJCrIXv9bm68VktOF6R1lgrSt9RnJq6OOPOUXEsNdEEV6gDzZcqgFx1vNgP+KQFWZYh7dP9CFl0yP8wV0SrnNanSCz8FDpv+Z5YKRLL3QGzAQcr0SDLtcM3fRWZKtnGhfpW19rlxXCcKxvg1jqAwaYDPLHad0n7n6/CJ/0gpE6/r4jNFXnfsYYkuePrq/nxQUwZwudI3jmhusvCoMejdq2EmF4N/KK/U/LB55f8PGD/vrSmID/iRSZf+MtZpWtM1GzAc0vUYk+Hf/rlZXpav5x90GZLBlkENOx1pLXeWTFx0aJqFT5i+WP35fF+pznu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199021)(36916002)(6486002)(478600001)(6666004)(54906003)(6512007)(6506007)(26005)(186003)(4744005)(2906002)(38100700002)(4326008)(6916009)(66556008)(66946007)(66476007)(41300700001)(8936002)(5660300002)(8676002)(316002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FVP0fyX74wxJQquoNhPrMO4ToECL4b2u/siFew1FN8RNkjmTgfrMbGCIh5eT?=
 =?us-ascii?Q?gVZevTn7Tuz4i0t3gDgHDzxKFeUr1b/aYIYbybdHJgQ7UYy2jngZqQK8Ga6f?=
 =?us-ascii?Q?RvrIj6os5uwG21H64nB4GaUzU5RuuKsUBX6nnLNQstiVRqT5HZUr28UhqXOL?=
 =?us-ascii?Q?g50xtPYVAwov5D1YTq9XVFze1htvl5DJ5GdQu57KZc+tMs1kLUYgf/aET0tP?=
 =?us-ascii?Q?oJji05RM1SJaTF0nmtQMVvrlDwrLag4CuFZbEBk4BQuryULFxMGslxvDYQ1S?=
 =?us-ascii?Q?RQKv21bfLuLdgVJSuv2Iir1e9Go1BdNi+RE9ic3eZOnn9JimhJwKNkRxJ6dy?=
 =?us-ascii?Q?hU57LMuXihfzOy1zrREM8x3upU2A5C1oxADjySsfMSR8Pf0SVC+Pg2954RIB?=
 =?us-ascii?Q?J/rIw6bK0lVyTVAeBUGUga0wr4F9lsC5W/ypvWkcjW4/J/fXVZCLv4Wb04ZX?=
 =?us-ascii?Q?FJ/5WKdWRwmbdq17vEsu3vlx4jWYilkoN+SVUa/MaIgTIyiHiBrW99vetLUi?=
 =?us-ascii?Q?9+sTKJU+RKnhg7VCvj94j1fMeRQgV3W13EhRwU4rTz55pe53nP9Rc8uQCMv7?=
 =?us-ascii?Q?uA65TJkl4YAntSWaR1puEq8pGXbb8QKFu2nWV2s/w63xO3stS20LZgU6KXAp?=
 =?us-ascii?Q?vcNlOJ1YgnJaiBP5t/t0u18csY2k/KfOf8qHLMXD8C0a2s+eDjjSuJs6LCHa?=
 =?us-ascii?Q?6sBOLB+rzKRzK6yoFRniTKDqptoksPNfDr0AZNUKzEnaABUsRddXE0TwwaMn?=
 =?us-ascii?Q?Ems1BV9uWmCBlqFVfzFu7efTMdDvqDoPEyovp4NfldXYp9/RaQTzIXEnTjlO?=
 =?us-ascii?Q?/16n55mnU2oZCxsryOUsCKdgUQKK404kzH8drPIKeIK/60UM8WLFOZ+avPHF?=
 =?us-ascii?Q?cpxJUm665/0FYrSPYZTbeX6iij1Bnyk/wQ95vWbPOJRxA1+JTl3FKxlP5bHw?=
 =?us-ascii?Q?sz89f+DNgO1CZWHhU/7nES8d8rt99i0FigBhQZHn213wvgRwV8ENdaaizwK5?=
 =?us-ascii?Q?j30TQDbssQ0bCTKHNpHuSdkiiljBKHapg9947kpoM139w2m0ppxrCic9JBM1?=
 =?us-ascii?Q?VBZV630fkMdRNs0Y+huDZrYrYb/gNbOqqAEQ6TI8JlwFtr26u4IY7kkY/MOU?=
 =?us-ascii?Q?EODkYcOLgUVKbe/aYLgFrR9E//VdU2W7cQ7ua4yzQRZ50osoBRCqSsO7/Ipm?=
 =?us-ascii?Q?26xg0mM0o0EuV19aK6XfO2imyojmypm3rnrEBZ0ZBujlQ/1NXPngb+QlAh+5?=
 =?us-ascii?Q?oeh8LbokR486QBQMaWLWihY2/+fwfrfvoeEC0GQxpqpODpka2B0rwowlDxzY?=
 =?us-ascii?Q?s6rAeMLjLAJJ/y35reR0GG/TVfw3aJShx6AvGazAKm12hYBcMODBe+St8Ahd?=
 =?us-ascii?Q?JCnlBKNtcjGZySbaldjUmWJtX16k89UtK5torwNSI22lpJoURfjYmQPlNDij?=
 =?us-ascii?Q?YkhpEWmT2Rt9s5IkPreviZ7NFZV8kZ9W1kwxFtYj3w2BSMlaRjzT6MXh1VUB?=
 =?us-ascii?Q?UEDFv++LgciqH8ckUZ3nakOffTiXWMjL90uAGd31QqU09/874GQFVNAHaIgn?=
 =?us-ascii?Q?M1dFabOpnRi6iQlj8ThJcSxVXzDAq5dxFs9Y9sPXnzA2kcDoxDHmdkVPVZVL?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3IKrbU9iARJyEgWjFGNhpgsRa1ep5WbZxHcWYm5IrF1c42B+SER5NkPLIzm7/Mdz3UlPSJ/nKo5i6/5Kr83A86mxEqRueJfQJDD/8MERlfQ/0m0Cg9a8Yf4nuuDzRYU1hbypezmOUGHI/k12TiMz97HzFBZ5otzaPKnDc0TZlIsxA6m5rXGq24/mzq5tQzIv7gs2TKScaDzdx8bwdpM2UqDfxtc6uVeuSlvoH9CHq2auAPlRRpI4HbRwv0PWdpxmVqurqWTutz/xaxlqQoSzMV4p5OtJ1mvSDBXdznugOqqI8pJWImDk8eIzrx/rZQvAhv+hNtVJLmbZx48lqs55MehbJEHOS48OLFXDPqmlX8BfjuqbINZQpoPGs2HaNSbFL0fDeg5mp2xcTUcTsh8iv3gpzz2v/rLUG0uQcSbKXHEr2Mz4y00W3TOhreI1LPvJBk3EqOtyUULtkoqdcjWai/ZuReHWUSCwOJ04eiCAEJ6/3rNyWNI//CpUC3gaKjs8uSesD4UavAWwY5EyjG/XucjC05Z48mAsjGtvrdnORGGIOxWsqtKiP0evSAcpsyRGk6u0vyEZHNTBNwYyJiWCt0SOylrxQCDk+aXRpe4PPPegPJ3AZ8y3Wi2P2V+DOpxSex2ZJCpipbofZLTRF/r+thkThij4oKSOkl+isILMGyxMSolqd3cNaC6wwge1/+nYCIl3PX0N9MkKAkSWKlWPolt0gWu5UYH3zgpGuSu6+tE3d9RvJtG5mPR43UCBlAijuImkjjuOl/B8jJx5NVX/9Q+Hrs3sMYd0tmgAdmTYJeiRIibe5toLlCAUea3Li/Zi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81980a06-56c9-4f5c-3b8a-08db4fbf6711
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2023 12:26:09.1324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zg1CtpXwsXYupnJbW0miTr+3nmGxeVoh2m4Dnak6PTl6iBZ0EOUDeYykE7JJcCiEk7uX6gCJdQGwns0MjvyapaujgZXr0u+xv8y1l//ifJQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6946
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_08,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=495 mlxscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305080085
X-Proofpoint-ORIG-GUID: 95Fc_uJBeNRvhmvOcbRBVi3GFsVnlfFD
X-Proofpoint-GUID: 95Fc_uJBeNRvhmvOcbRBVi3GFsVnlfFD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Brian,

> When SCSI devices are discovered the function sd_read_cpr gets called.
> This call results in an INQUIRY to page 0xb9. This VPD page is called
> regardless of whether the target has advertised this page as
> supported.

We used to check the page list first. However, we found several devices
that we did not discover correctly because the pages, while present,
were not advertised in page 0 and thus ignored. So not checking the
supported pages first is a feature.

What exactly is the problem you are experiencing wrt. your target
getting an inquiry for the CPR page?

-- 
Martin K. Petersen	Oracle Linux Engineering
