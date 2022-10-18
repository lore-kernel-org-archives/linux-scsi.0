Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3113FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 03:29:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJRD3V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 23:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiJRD2j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 23:28:39 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A43BA3ABA
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 20:21:38 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HNYGaT016343;
        Tue, 18 Oct 2022 03:21:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=vgs+S6u1NQqTDHkM1sBoCE0y3BpTJzyLk7XsWl0uOm8=;
 b=w4QCNTz9ZFwD/9948vNDO4f4WdSvIhfoilE+0F5avz0OAyc3A4oEhK7UwT609menDfyy
 NfebQfnNcOVEV6YJtzRRsBcqiP6+VYYSqWvVJkGgnR/JcfsyLBeU6NLA91Hj0PGloOXV
 ly/Ufaw8xOS1yCP4lrNo/KXZzTcPTkja4Q7BWDXln4nutqEWqxxbf++Ox2Jc/gBawhD4
 LdBt/Ole4R/b1zt5yA4YtqTe6qL56fwjqvCWVBR8/hhlHJSCwkS7L1uimwElv8KKXxSw
 hJ4XBqW+VE5w7fNKfoBbXhAOUMCdJWUB3yqvIWGujoQlJFU5KJUTIlo1tzCVeii8U71O yg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mw3d95s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 03:21:14 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29HNUOAa019231;
        Tue, 18 Oct 2022 03:21:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0pw68c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Oct 2022 03:21:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtJ0GqzYopvYsz03g9JlNXjWecdXX1bZ9SPMjqSvxVBPxBlcMuPo25AcAtV+CCrirLxuonGNAZIAbSmtnAsPpAwTL7C1oBMPyjReUzo8kvkZw9UnmXGts3w+M4YLozQ4ZZy303SFXUzZZzjhZKeUXFn0qDsuVJIHcAODl2RGvp5GibjBrFSzDZNujaXZrSUlC2D1rTQG4gJ2J/YQwwyn6xboQoWKg2YUb5N8Zem6UHA2kgSKHApjZjbFF5tsu9fG6F4Uiz4APfDRxMmpFRhY/vYVxkh3NHR7whOF+vBKsIReDMDPD4BFSImtSnmZY1axOF+qyZSWGdosesB5cesD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vgs+S6u1NQqTDHkM1sBoCE0y3BpTJzyLk7XsWl0uOm8=;
 b=LKWpmuG1YlfA8CRvlDPkR7LzxJS25FqU99sB9n77nNmE1KyQMETrEekEHoYBb0Rxg/lW2VQY0VK+jTMcPII8X+2+/vsC8CUkHwI1EfgMb9hp0fanaY00oWKOsK8Nr/JjJ1G1FMGLhFjEAB3XlHe0iXt+A3Xu5a9lebr5tE27PeYl4RvimyyJQOPVYWnLLLVIW/TdHRMrHAl+r8zpqY2o+pS1++TJ/JypekUNaNXhWGnoRauKV+o1Y7THbK6gW5FCfPTlw0Uz0cjuZPMxQm805GdOGNjPjwFGCfQ+nwbL0whvorw0SJVuS/N2GDGUIEPPJempfV2ktr9kzMXoFv+oKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vgs+S6u1NQqTDHkM1sBoCE0y3BpTJzyLk7XsWl0uOm8=;
 b=iSu6FJ1WdM8dM1wDpK1JJp+/kmWQ+f8H5C4PO0LriUC4D3HKVveLvWKD5eKsOpwTOVtxHsDFIgHrtRBv9lKY5EJSg0H7z4KrZlFDGsiefM40/0O8QEFhGKxqM2WXph4/fnZDnWDm5I2GXvf6G7DbPu8KUENCSRhVfH36nM/1NvE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6265.namprd10.prod.outlook.com (2603:10b6:208:3a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.34; Tue, 18 Oct
 2022 03:21:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 03:21:09 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7 0/8] Prepare for constifying SCSI host templates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d0x24x4.fsf@ca-mkp.ca.oracle.com>
References: <20221015002418.30955-1-bvanassche@acm.org>
Date:   Mon, 17 Oct 2022 23:21:07 -0400
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 14 Oct 2022 17:24:10 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN7P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:806:123::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6265:EE_
X-MS-Office365-Filtering-Correlation-Id: d1f0e25d-3fd1-41ba-eb45-08dab0b7cd34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujPqteEBaFP+zK9XkTfm1l9G9MysBamVsLpuQEdFtRXNH5ZsCJKYahvGBIF49zpxwyNfG32ZbKroJS1Nx49ac5vdeNClLjv3JHeeh6DQafgl8ZNdymydhkG2j2zp/6zi6woOnhl5WRWiwmp9LLBSHTD863p60wN+1FzptH2ldZWduG7JYeN/gr2RopTG28xuoiV5PCqpqfjNANgjaOdYpLlPBp877b9YoEeYo7VeHcQ3ppecQXiIFcX16LQ45miwXITLsHArakIwCK77pvezaMUhVNV1DUQZSPUqEDWlORT+kJxgL9rZI08OSIZMK4xILCyBKuhCX51jcFr1IxkgYekbzznctpr+W0Vi7B5XfPY9OVI4ONijjs2DFelQbLKBEEbHq7dCD7pMy+M1TN1ihps41ZAEwjtZTZnHa7dj/9wUjTbysoEkMpIXS+JeaPzGWkB0uX9Rg4l6LtMGPREnqzyFpeO/+Gt696uyXJl00GQqSYG1B5nKc9ZHEpcgT3UCYdegq/15P7FLPLNOXH9d5t31d5A9tzsUMg7e5AEk43sY82m6f7AMShBVm8lTcLdfWaTLxbDNEDi0osFphVG8dRRYTnqa1dc3Iwb05E2fR5H313DGjhJavF7MlKCrOKivv9/f5uR1yrengVuNdFjEMw3mS3GrFUVYZHu5GNuoAAgi03LRb7N+6wqv+Rf2UUEM18Mk73P86Z3myoZD++oOQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(66946007)(6512007)(6506007)(2906002)(6486002)(6916009)(186003)(36916002)(316002)(558084003)(26005)(41300700001)(8936002)(5660300002)(86362001)(8676002)(4326008)(478600001)(38100700002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?snAUg4z6VjUVjOptmUdvCkbhRoWmSV/pNNJHe54U0u5bohUI37an7xr5/nC1?=
 =?us-ascii?Q?F0oUmCsmRW4iuWYgAJg0VGy9NegL2mDzfZVSB9YiUT3gM6qB0ZF3ZDjxpBnC?=
 =?us-ascii?Q?0OZVYd4H806BkBD5eQEffhxyFxUuF5lk6qFZGaJFsNZn90K7sthXQz2RkFBi?=
 =?us-ascii?Q?FZUAzUoY7QbfInbEGqvAnEXSJl+AK8l+NWxZ9jRyXp/dE1aAX1sYBMycPQJT?=
 =?us-ascii?Q?zR478vsBYQceL44KTE/myyyLnIMe0PNkXA/etlUHYwXZx4s9cY73Q01zetKe?=
 =?us-ascii?Q?Z/5ClWc23t+y1NiF5Zt+qxGUZuga4cGbtLU66wfkGIQyXVwlAI9nOkhJF+EP?=
 =?us-ascii?Q?IhOc4dc8+xsHef+59CQQ2TV3VpznclI1trnMG5dTJ2BN1buKJhKNfWJxEUJF?=
 =?us-ascii?Q?6bU0kfgfRHyj3wrt0b569MioZM9zvjeQuWcew4le5CJhmXeJzSwz5woWCvxH?=
 =?us-ascii?Q?jkPrUmqEe5wwi4YZwoLZ1R4lbjhXWlGce8At+xErcJOvnubK0xkjxoWdgsIp?=
 =?us-ascii?Q?kP/jTtTgL1wM5uvK50BW5qQZ4Cc7erv3d2jBRQbbSqrBYFfXH15+cqkr0fOf?=
 =?us-ascii?Q?Wlj+G2QlCmNrgJQw40mZ/XAwMUkHYBNVzc4hB6uYaYqVXVPbtM0MairLzEva?=
 =?us-ascii?Q?CMANP0qc2BmO5XNLsDaBj0hSehpR3ERGSt/QkXf93N4Nvw9LN/TiQ1HXCocP?=
 =?us-ascii?Q?3+go1CnD7t3jKsrZX1HbMPRGYjUQNp8+raePN9q2rNVyAZ40o61M/NY2Vufy?=
 =?us-ascii?Q?ioi3eIIxBjeHeDfNKiaRIERVOS5i1VWUtIzRKhXeQWcv6UlmJSO/NYQNoCcx?=
 =?us-ascii?Q?1T3/jo7GvotWcVofiYRgLqx7jvurwz0BrD3IeB0mG8iJRXibmoBudzrSnWyB?=
 =?us-ascii?Q?kUfC666jjJLcqSA9/pyfi5Xn72GQybnqMmvz5mUoo0hGOxpCpe8JpPDI3rgk?=
 =?us-ascii?Q?69ZRz2HgIvCdywKsLsc/Ip2QFMOxxJ4Kg80/noAYRbn3XhNdHOoa03SCQ35s?=
 =?us-ascii?Q?ihaOzMEW+FHuvb3k6aNJpHZeaiLsYKuGCMxYOxAwBXlYCTylwFKeC87ciA9U?=
 =?us-ascii?Q?aknDH4+acHan7Zhk+8YdDVhhtuQj+bfctGB/KQVd96YFUlqHMYm/wdrkzPMz?=
 =?us-ascii?Q?ZmCRYUiWz+s2za7/PY7l6Fpw6M1WHHZaqpPMvZxrJZXx7n6lrIUa0smNoA9g?=
 =?us-ascii?Q?SBccj+4mPmCtjXle+eyNw5JvLN0niYqUuBN8qiwTxmI6uzTUkXsTpB38+OUH?=
 =?us-ascii?Q?CpUJZ4PFy6wr/QR8X9UaQ1Oyh1yPdrVNQR7+30DoKfaTPAbeQ3vw6eyuLKfn?=
 =?us-ascii?Q?mHKycACfM3Ni4KULoS36eIbntp63kIZRkLu+6BFW6weeJRE566sYrNQvzd+O?=
 =?us-ascii?Q?cJM3hjhHanvxmnZ1z6lZNOTC6GsbcighsTVQ9SwzOHgRij5upgA3pRWaaSO5?=
 =?us-ascii?Q?Yfs8dbVJkDRJCxNvbCwGJ7n4rCIBTzavdXFhsP9nz5+7MiYN9zLcT2hmmCJC?=
 =?us-ascii?Q?5FLuS/NqF1h1D/AXfuQ6YACsAtCpI7Zmw1Qg9p0hY4T35WhKl/O/BvPvNZBi?=
 =?us-ascii?Q?peqxQspOVIZuBLSwUZdbvoXVjxCn4W9Y2mwve/GnzWjIMsUDWz7YtDJd6UCn?=
 =?us-ascii?Q?mg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f0e25d-3fd1-41ba-eb45-08dab0b7cd34
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 03:21:09.6522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OSwnqn8PUEDb+TN7CZZ9tRFovsJzhg7CMMcPtalAzrvMcPFau0cU5teUeHN+0BJ4a34BuTzeymM50rbV27FkW51KKQ5m7HfG3YHpAZHBF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6265
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=755 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210180017
X-Proofpoint-ORIG-GUID: leiB6zBjHDVpPnLAKItHM_UY1eqCzrnW
X-Proofpoint-GUID: leiB6zBjHDVpPnLAKItHM_UY1eqCzrnW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series prepares for constifying SCSI host templates by
> moving the members that are not constant out of the SCSI host
> template. Please consider this patch series for the next merge window.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
