Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE8DC46467
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Jan 2023 02:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjAECys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Jan 2023 21:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbjAECyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2023 21:54:37 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA4E48CE7
        for <linux-scsi@vger.kernel.org>; Wed,  4 Jan 2023 18:54:22 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304MF5tB009452;
        Thu, 5 Jan 2023 02:54:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Mg69oKrNRlrXvAyKMrVMVLhr42eCwTH7XDQuKok5IgA=;
 b=KEnMmJ4dEsJEpDLDsns273I8H+B7TkrM2obpxA3FnhgZD9pKzNy9KdwkGfI+PeswWKdU
 as2emWPAkyM+Mi22xd/y31ddnrfAKRpe7XKHJViiTGJOcxDdltDeMHTTaJuNDZWR6N2t
 TztA5M6qdxuFfyiLYTTqURAxBhseAh0xB/gPUseto09QKPdu0hLAMQPB95OSzkHgizFZ
 k5mqv31HZctyRZfDi78OXDBuRoN399btxwwi+J0QlGIwLEX805mm63+p3CUh6Tbwf3Gi
 q3ruq+fTMxRknjzlfOf93pk7zhgY0+8kpOhrBQl+ZUTqNLuwUbFc05WXt4wtm3W/tDHp rA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mtc0ar1kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 02:54:21 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3051iuT9028865;
        Thu, 5 Jan 2023 02:54:20 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mweps68gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Jan 2023 02:54:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XcQ/cw8WHhbxZ/lPh88R3nUR7h2JijiQGjrHHlx2Cr9uxg/6dKPEHM/jv8mUWigXzkA4cOJXbAKtrhvKpuqPc52lLBOx7VcQA6NG5Cqcd+uFLICpl7f+oma7WT70dAaOMDuLe3Uwk28X4e0CxTKF8zmlgSittEDIa4gfCfU+qQMKdYJr2h/yl/LCqt66oXDFnYjp+QFNg1nRKE3LYDXuPeBY25oqNpz/YxkvQf7rs+Qm78cQZicJN+i2b2iMbH3URz151NbPJPxe/ydqZaTuljfwPQCxVidhPu1TV0u7nyZsnkqjCQ6yHKCBQ/u2wMr0qk3l8lcXo/SukMZ3GKqHbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mg69oKrNRlrXvAyKMrVMVLhr42eCwTH7XDQuKok5IgA=;
 b=iIb4MZY/cyud19Vvscfe6eGmPQJ/cSYENJ0v8AKG/Adfcav71RQvyJnwqD19VC4bMQfaw0JMltmKdJg8R1AgFcCBoPakHLs7WnTRhnZ6eFFMa96ydDdyqAvmHEI2C95bl8DgMF7LfUMX8JXwAjxTlCDSCMC9ld5iJK16mm+nzjWXqhnrWOkA9ur50ftlfDNeKQ28ZSA0MCVWnBjVnuCtEDNwBPCo9ZYpiIUC9+bvvZBdQ/00S0qxyt9/X8fza0YnIdxyUHTg9KxZ0YIZCx36H94kz6nzONjkyzRFFjY5nnmayObHfvxuk9eR/ImrVbRifF98PRTrFNPdg3A7YLXUdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mg69oKrNRlrXvAyKMrVMVLhr42eCwTH7XDQuKok5IgA=;
 b=a2DvF1KxbCsE9SJxvkbM1cqYZKt/110H3Sanhnm8qvnkruQ8C/vdTKKQvImBTygjB8zOUZP3o/vFvC1M5H/WfxQvZiqKm2tHIb6N+UkENUSvZCZTfYTJkEi86+GVVzv5SHerNirgRHclWADzOqKkdfFGqch+W2gjDwEP55wl4Jk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SN7PR10MB6572.namprd10.prod.outlook.com (2603:10b6:806:2ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 02:54:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 02:54:18 +0000
To:     Nilesh Javali <njavali@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 00/11] Misc. qla2xxx driver bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lemh1yk1.fsf@ca-mkp.ca.oracle.com>
References: <20221219110748.7039-1-njavali@marvell.com>
Date:   Wed, 04 Jan 2023 21:54:14 -0500
In-Reply-To: <20221219110748.7039-1-njavali@marvell.com> (Nilesh Javali's
        message of "Mon, 19 Dec 2022 03:07:37 -0800")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:208:23b::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SN7PR10MB6572:EE_
X-MS-Office365-Filtering-Correlation-Id: 513e2702-d69e-4966-08cb-08daeec8236b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4yhgjPeRG6wRgLEd6R/8sZodmUsoZGgIw2f8FIcEYwfNq7pHauH6uQbOYL7dqo34Ea3Xnq55Pq9EszNmQkBQJlGUuPhy8V3wEbEYbB4twyCM+rvmHWKHq3jP3++Zovkm2FEhFNCPLz46AL9OdJQ8M+NbtdhwGtcbweA7CzV28X4yucn2XINgVl6UmR6+QGGbDFk/TFT1bT0DUhAh+2CWlAVIp0kiZ5j2Q6mShAqDCeEcgSNobXTR+4iCJja8p956TGQbuEP/BmylzbhnOaMPZ1qjc2MCWiJ/3kl3EjUWEyRGT5lvl3KFAdsJBErSmWewiFdSlbPU+yktziOVcsXjHxGUxrSnkW1dAlZnhgdeRznt+l6o+4EyBwFbBDc3fnb3Gkr9GvCWu8gBMMIAfv/y00daX5MKUU9ETwfAhHiOPagfYPoJw0UmXgW+c+2h/V1MWTcU4u/Q3fjp/RDFbpn2anzRBZ6FzxR+rJly2iLW4tbCZx7UdLcaSuiDcXzw7/ShvQes28UPQYyu48wbKrM1O8q0ufB0OBMJ1nBOjd0AYSCCcwAH/IMA/Pd5dOWPzdKWn8RNTFm1bfnXriBvq+QWmIPp882oMzVYjiPverAxpQybGPx4TlSg10rcVmFIBWqm5PcpCtLZvaPDaZCu1zeAxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(39860400002)(346002)(136003)(451199015)(6666004)(36916002)(66556008)(6916009)(6512007)(316002)(186003)(26005)(54906003)(6506007)(4326008)(66476007)(66946007)(6486002)(478600001)(8676002)(41300700001)(5660300002)(8936002)(2906002)(38100700002)(86362001)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A21P3B7f707X7sEcrvmVrzED9GrAH+z+GFlGpQ6wanxpiWBwSzH9DP5j+hYH?=
 =?us-ascii?Q?2HXFd6NHnL7jnXUYshNFj3FfPPtDZuyHbicOAnEWLZh7XLlFz1fFqGHebmjC?=
 =?us-ascii?Q?CWYwqf0hUqm2E+eKg4uFR0oABrb+EQa1qT/uoYN9eC48DyTtlvsaX4NyY7Z6?=
 =?us-ascii?Q?4rMNF+gpNcl/47SnOikxT8XVXUELNAJ5WY1s7tVsr9rS2KbbapokF+ZoCgTD?=
 =?us-ascii?Q?CBzuDORPfJGKLpAoDsVgFiy4aKCJ4vP16C7IJ17AfL5zj/8uu7J/hiZz4dO+?=
 =?us-ascii?Q?NwkVzvVS49MiELR9ri7x0WExa1FlIkxOsH0r4wueNYJsA/lJuR7BSV9+6c1T?=
 =?us-ascii?Q?Pw9xfemRamX2pZLDbrhWvwYTZjDIL42CPIsDxxS5k/ovLfUCwLFQmJ2Jw9WM?=
 =?us-ascii?Q?OZx6IL/g/Q01b2Ed/dy0mQeF+3okSObJGzeKSDNb9LvrQQVb5hZe63Fe8QEC?=
 =?us-ascii?Q?IHy/YZfeoHbH955wnAkFaw3BoyxU6620GB1DQucTSdKGz91puAvD8sdKtAdG?=
 =?us-ascii?Q?Zm/GXh3hlbzlj+uDyLHJTGFb5bw3PpPBFOEIYIaNGLzEqqi75P8LPZgKp1tA?=
 =?us-ascii?Q?/BvNe3mkBxb4gKmGrOBY1gyzJBWgnPDQoX5W3lB8Ui1Veticol967GmZQCJx?=
 =?us-ascii?Q?mAkRR1duj+aD9HrewQzjzpXgHJgyP6S8okpWTDZ+rmsajo7guMKacNlT56YX?=
 =?us-ascii?Q?DWWlWW8i0dYUnZlr+75bcOGIIUXHNT3wWGTlixFq1IADv/60ZoddTIwKuDBT?=
 =?us-ascii?Q?k+f18NRGX3BSmKBXmty2kOd0+1W387toZ0cCbdyq2Oea6WR5Qd45NqCXvuc6?=
 =?us-ascii?Q?Pd/Z5fqF3EJbOTQiBJILEN9G6stw6HEQ3qCa8fC/jc9T8qLMxYljsz/cOJGu?=
 =?us-ascii?Q?IkgDMX3ASwydAjit2a8+A5+JwmrjFC7eBoRPb0tssuKjjww3hxCw2y2K3KLp?=
 =?us-ascii?Q?uT+RJGifJ9nHgaFsOizliH3qlBB392Gaj5RSwMuEG4EMM6FL2S9EZ80AvO6C?=
 =?us-ascii?Q?vS+5BKPxnGRBMPhRqHZovOuhoVIg90X6KxkM6SZylP6B17mkNb0pER5UVhg0?=
 =?us-ascii?Q?ou2pZz0RtVrHkivVnWU7BGLsNRuKquHKxoJR0FRB3C8EmB+08fFxkAYOhNel?=
 =?us-ascii?Q?X4Q0jjDbMuIgUMYSLjOMsS1xK6aDx0O9g9LPEedscsTj2wig8ycbF/3Ct/e0?=
 =?us-ascii?Q?WAfRk39xr6+aqocgo2xmCFzz5xRZSSoAG/ar0Eeyump20VwiW9UNwUHaTon3?=
 =?us-ascii?Q?oNBL78h5HW/U05ceQddFgPnpiSqX3y7NH4uj2HIY4zfdimylWlHoKs3RaIft?=
 =?us-ascii?Q?eN5KpQwhQ4dyVNzWxOAbLJn8NeJn6n8TWlPDzP5W2UJ4XkOVgZihXnKPkc2K?=
 =?us-ascii?Q?sjFYBqX3ioIay+H3rcxrCMgzYfct3mABfHQL6UQ72bdUO+oczflYkJ+b2nAp?=
 =?us-ascii?Q?S+5F98UUYj1VXgVucOsN+OCys5WsPRUzjBlbwdyaTK9gqMz06CZzU4KjLUrM?=
 =?us-ascii?Q?sKK9++40Cbs4ccbfvuySEIkJLK50oLIXr/mk/KnS0ZYkd0nucv/tA2LDtKOV?=
 =?us-ascii?Q?T6RTNawieN++Qix8kH9awT20WobdloPwgBq3nFB+T2yRuNYbTrv7w/F/9HMf?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: miWcmCEeET7m7OPsQLtZwx0xUOFBRZ0kV7i4NKfpatNMi3zNVhqM/FD7Y4vyI/3MqbQaS4a4Wccb4Yo7QjVarvijjLjbji6Y3DNVDNpglqV/0gSbfMtBIyNEafp+rLLyCWSgPy84PKxRTRnUlLslFrN2N3CUYS/mX1uzK8y1BMDkVKe4cFlKwuJi9l3mcR4+MUkdnZCUZd6hBwO2uD53KnSSAt9zWqOrePB8JrtJgImHgrzwwAgjOKhW2KKRDvMJY+q9bQw8Q+mbBGj4ElBN83odHmIRFPpGO98tOSQiMLskfiCn70eF88lo6zVdufKrl386FuCnxDMTvtLld4uZFYajLd6nTzM932AGrJf2b1Fh8EEMMg2iUIPRag84L1U0UuFDe6knp0FJuE6AgFrUqMZDfekbn36N4f+kyjsjg6Vd+Z2d6GRnY0dAiC427BMzQQqyl/pox4EaMjJ3oT28dDbMMZQj/nRMI5VGNAmiIcDf4w88dLZiLThyF2bxZQqbCXSEde3qfh8mEvWhPxFAuMnllVT+HuVz7plcCWL/N0aYk3fBWYVKgTiHgT5sFMOAPKXArwDXtpd/4zZg3hhxYrUq9yvzJDxfuBa35ASsh1QjCN8DZQhMLTxriZO/S6Z6Ql1mmNVrvFXcBLYFGnM60wGpYQR+wtoQT90sYzMtoF6SNiZ7GRdFzHGkKX3o9TY7kjMQ9y47GrgFLr9cQFO2EYdLvVyigsgimhcMXDpEp/UdAgtqZGsuqkhjB6m2HmITURL1l41aTLgBkcQIrpXrCrcaHKJ6MFD39Rh8ZZQBNtkEkKE71m4m60zQRdIsH1pkoJF1FZWRChNe4qhCB7/ZQoNC0yQ6QEzcuDytmWBsmUK0Qmgu5UvhXSvOtHcFkpMszaFXsWV/V7sSELInWzEJlz8lS+S5C4zy61oIis/He5Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 513e2702-d69e-4966-08cb-08daeec8236b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 02:54:18.3776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iEmaFQdg/GHutfSuww9vdsnBTB+wm6m5BENEVJ31zeI79f9aoS/d6/gqE+0gsuewzRvpFe9LaLLoDvc/zxW686fRlZPubwd4+XufB6OOO2s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6572
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=800 spamscore=0 bulkscore=0 phishscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050022
X-Proofpoint-GUID: DxKcKtFnbRCs00n_nU81PCoxvasf784D
X-Proofpoint-ORIG-GUID: DxKcKtFnbRCs00n_nU81PCoxvasf784D
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Nilesh,

> Please apply the miscellaneous qla2xxx driver bug fixes to the scsi
> tree at your earliest convenience.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
