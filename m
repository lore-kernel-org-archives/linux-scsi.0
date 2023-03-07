Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF26C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 03:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCGDDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 22:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGDDW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 22:03:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110C937701
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 19:03:20 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326Nx81k025168;
        Tue, 7 Mar 2023 03:03:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Xf+1xhzxQIU27Z1kIPJIQhy3jRLeQYbk+Xl/1BngIZc=;
 b=SC/+AZuwij6u2l4FxmgBOiB62EItqXGfENIVBY1BSddrvm3HkxFHojEjP3/iJzdcNTrY
 B6qMvF18TnvAfBtKREnFVwtKgiVhSKRJBt0m8aUd8BKeziHERcgNFOP03f1Kkl51gNoU
 L0C/y33i87l6BfrBRLSOtbd4SHeRPrdY+90zal9h9WtFDuADibHeyzEVGc6X3zZJk+Q1
 VZYRaOpeyotH9ycp5lenSG3bcbDvE/j8ECiPhLByq5J8brLua+ddS7vG8Re6B0UbtDDb
 FcKZ5rnouhkESwFGbiat3wVZz8WNH+EUJHjwR7hR9u8B8dueBNEtVVrmB2mkOKll6lqq Sg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p5nn90tu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 03:03:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3271fLDa037432;
        Tue, 7 Mar 2023 03:03:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4txdvqub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 03:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1gBhoWSgZWD9JxXL68Fsn2n3NecQ5aUFMBl7xm0lk+9nSFyy76L5CdwgnlFT2iApiK4/h4wCMRB1IUbvfDY9xgjyLind71oCCnlXEkyoFSXiSyj2CmWHPUf6lpXAjLrAnyMGBBhbIx4/NZwB/1Kmv1inPbIbemMob0qe2eR+AoVA6M9Qam5E3bn20yok9z/FnPZxqK4YCKSRIwZcOqwNiot3F4AaxTWSysXRm3V1XfIwjR+sjJSIVjnA/rwej3gYzilUog6+qz+UBlw/N1Mq80dt2904gUXat06FZVBg/8DGAZwnJ4xlnBdX6E7DWL+Es1lkrf0KxeSdjQlcPHFbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xf+1xhzxQIU27Z1kIPJIQhy3jRLeQYbk+Xl/1BngIZc=;
 b=RA/3B/yUllUO8neMDWmNVTHwNYZtqu/0D9V2p8/vzNZUocwPI4fKbR5Hez5yiz9oThRnImTg4gi7Eb3f+BHBZq5az6MeEmnmG1e/K+v5DcOO0xJpofMULDVdzLwENQ1uhpchp1YFgU/nS0fVSQZe5BYTCIFfasoYpejMWoCWSrpbWaSWjovEgm//wYPgGIUShW4coFcd+mHmP2Tszlt757yn22N2Ryi2q5bVFamQIilGG7eM7FpZCHqQ4v1/Cu2QLvVEVTqLMOsFmeV82HagMYN1n1B+mw3CMWFKvxujlw4TAEfFMEkvmobvpbFLbvLU8hjA7GDAOENtUB4F/zYyng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xf+1xhzxQIU27Z1kIPJIQhy3jRLeQYbk+Xl/1BngIZc=;
 b=Yqw7yqk3n9z01Z5pEq1cn0INOUdwTvNTsplRsJaWSA9X1uvpEHCKzoGn7DQNaKFaZxp306EXAjrV/nLQqNIFi5QbuxpiNeRW8VYmpPbjqPklt+Px7bbwVbC5z2Vz99eWe3aG2UPmE9GS8e6U5ma1GT93JCqBuDkYcXUyuYNGX1M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MW4PR10MB5749.namprd10.prod.outlook.com (2603:10b6:303:184::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 03:03:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 03:03:15 +0000
To:     Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH 1/2] mpt3sas: Reload SBR without rebooting HBA
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttyxl0v1.fsf@ca-mkp.ca.oracle.com>
References: <20230208102603.23264-1-ranjan.kumar@broadcom.com>
Date:   Mon, 06 Mar 2023 22:03:13 -0500
In-Reply-To: <20230208102603.23264-1-ranjan.kumar@broadcom.com> (Ranjan
        Kumar's message of "Wed, 8 Feb 2023 02:26:02 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0261.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MW4PR10MB5749:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b313f4b-e624-430a-d926-08db1eb87ee1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q06UrFYo64CD4IbXb+PWoJaYUI2SfOgI2f/zWbHqrjpFNjFEQDO/E0wyWnNWdvegHL60A8JBlRdJ1gVAhF75Dx7GpjI2nFubkHWtk90qgzZ8T3pqx/4Zj83vXmpBv0DKtQYjuSvPZtK7u6vf05gZ3sm2YoUDZO3nVPC+ESI0XS5BSNZeQr2vAP/rKPZUYRFzq9/p5ExlwwOJlE8a18fSZHn9TUJEPyTGBtJjBKJtOkmrsNSM9D5/EnHkiABfc6m6RFEbURCteJPkzAh1lzhZ6rSGuoMwEHlXafolTBMxg2KGxsaDXTr03c9HrFbln38kLvR7L1RmSWd1i22+fPUQPcFRdGdFGB773iov1fYDKtw8prROJYBLHOYuscUISbRQtQHVO2rKNi79JUSfntVe676LfPUSkNu4hsqBMFwfOcu0Em1VLitOZkMrcwy5cBibB40St5lAfSgHj9Lp/+c4gn39WieOsWeZ6btpJiCN3WcL36pWNFmrLl1oAWETZBQhYIHnEDUGLmj1JQEXuy1Rv7stG93gbhOMsixbZOT29dl/OK8/qMkn2KuTu743522njfoJFWo52GUay2TvRLmNqdztupy1p0dowgVuqRdZJi2Eb77oDceBGb6u+jLrigIr/vpGw3V926w5Ww23CmuenkPhxygulHcXwFNmw6jOCm5LSOzca2w6zVyYpTslBygC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199018)(26005)(6506007)(6512007)(6486002)(83380400001)(86362001)(38100700002)(186003)(41300700001)(66946007)(66556008)(66476007)(6916009)(8676002)(4326008)(2906002)(8936002)(5660300002)(4744005)(478600001)(36916002)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QbKmwHszLYDoLCm0EBuajy5ylDXde6cT5W4ynwVcnm9HvECLnhD8Sy+NHoMS?=
 =?us-ascii?Q?WSkUlSpyxV3lZ1vpWFy4iwHRP3LlNn8cI/HB8y6DO40qr4ev1cuwR4t4XKE7?=
 =?us-ascii?Q?8e0LaxYrDcv7ulDjWFs4t/7yHgvx401FLhedTrsSMtn9jYmNKEUrjWVGtoJL?=
 =?us-ascii?Q?KNPKDa/gYsDLhVrcxuFIku+8/qxUjvyVIphoFLLHJ6ZbFifcYyvE/WGg5VT4?=
 =?us-ascii?Q?RkZ5Z7Ngip9uq95WDLiXf7mTdE8JLGhzI73FTahrudSolAoDNvU76y3Kvp5Z?=
 =?us-ascii?Q?Pv6PwGFSnGiqQ/1j1DmlbQgjf9p41SXeqic3QeG4g/nCq8A82M8oDQdoEPf5?=
 =?us-ascii?Q?xHourDvrFH4ApLL8kwEYJAkSgzKotHswLjmMSHC98mqQafUgQ++r9+9t3qvU?=
 =?us-ascii?Q?HfFAvU11SJs9u7Yx0KlzQsnhhz/oU04VpkoRZyshwz2qM3LoOcBcwjSB47XD?=
 =?us-ascii?Q?Z8tMEWxoKfcvCulSc44CbKAHc3ffNZKmHlvZ6Lx7UmwTT4doCGLH8wGWZXBJ?=
 =?us-ascii?Q?mJn+Hq0QNpv/YEu7kHbWOdjm1a99+8I6zjBE/vlAApmphnZKNV2FlVwnM0a2?=
 =?us-ascii?Q?PXQDUdwx5RSkElmbFCkhNoNEXO8R5k4PBgaQ2pII1kqsiOPWr9tx7fQA7ePg?=
 =?us-ascii?Q?GKmnMhAbVrAl9Ko83z3dWYxi747e7S4uqeTz1wCe41OSfKuSlWB4IBluWw1O?=
 =?us-ascii?Q?knEquHJVzHn2+N+f2RShScJ4dW78EP3PuyMkSf4MXPeX94zUQgdmCvlU0jzS?=
 =?us-ascii?Q?v6vqiUgbyO7etyxoReuWwSatQmKZ36Ym6LKdXlU1efFKYuKzCLv7FM6OlDBD?=
 =?us-ascii?Q?5M+bcyBGwje7YACLoXwoW88pNuy93pyNfkJXs6IFLQJGaek3iZEjTLrYNpo6?=
 =?us-ascii?Q?EmprT8pK8N6HT8rMXm7ObrY0SEexFmmKcz/SgzlKygaTk/fptwsOMiwG4X+8?=
 =?us-ascii?Q?LPa9y3x43M6SMkstI3zJ20KgnJ12KqRwmSJcXHWPdiYirnDouTyCIzSMzSkC?=
 =?us-ascii?Q?kMHysNlrhQEjSiz+UBetw+fJI0tkfsbF28gOYZMjnlgBaspUW3w1LTENuMfg?=
 =?us-ascii?Q?BkSEiBMsOOkVsqW/7xPo7vmc/HPXujSzfQAmd9+YEjbbov2APn0aBkE3GdQr?=
 =?us-ascii?Q?sStt9xFOQ2A/ft8fLbcnp9T/kpO0+fJpXxblth6hkxjp0O/xdLl/XVcNc5Bc?=
 =?us-ascii?Q?RxdOoRW6PdvDDGEtobzTWuQxraRqYTdsNlhriqS2KPnrD2+eS7XQRFwVmkkc?=
 =?us-ascii?Q?wp0BnVkyBL+ArI6sw/h1F9KBmN1wd2aJVBeRshkS+/lAOHohw4d4XW6YBTg+?=
 =?us-ascii?Q?rkXqJHR4QHZcFcmgTXaZNXxP6aXJr//EOTslCNVMyIyK85YRif5CJcfk0CLk?=
 =?us-ascii?Q?NGo7xk6h/eNtq50i2cScPhofrpawXKXth5gVTItK3n0oJuiKGmapyHTKq9u0?=
 =?us-ascii?Q?yj5DqiDMK+56BbqoJhF9f3JhTWj/CYHyHPni6tXct1E3L4HMZonVr26hBZBk?=
 =?us-ascii?Q?A0Wy6k3VCrMsOJ0P33AYHY4wTnF1TF53J13maGL8zP5bQZPQeMcRuJPWCfcg?=
 =?us-ascii?Q?x6tEhCrtlmzWFhOvSYgYkrF40FQHGzI3c8ejZNfoQYnltn5kkFXMUki0bPzr?=
 =?us-ascii?Q?nA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rErH8VMsVQ+rmxHJnXFPrSw3mxSFW4ZUvx6uU+n8zjxxb59rhTJdtJFxUlz5h2mC5fmiwMMgsU80hb4QlZuPVE/33nbNTbRNw+2e3fxbk8gpcqMF330jkQe/j1ssYNgrqgxRDvjUvA/a+RcIgq2FVosodKdk18dsFbAkdfp6639jxWoVoLuAsiixbgv1mo00+turhcYU+i8RjDY8sb+14KMsBwTAmnDubo0h5+4wF5qTnJEmUrYFKabamaUn3PqDeb65uBs3reL1dvHTD/OehygYQbc9qTwDM6rNTGf159bMOT66i5BET3qw1cRTo1MyojJVdBeKyNmCYBT7NIWY+1F84NjZzv9u7RqbmKZBmiQm13/OsPscgTI6EZ+AsipzoJsYtHD2QPGyiGUSqLelvH7PNqDHbhjwNa0n+eNPZXFmAQDRavo1dhMekGpB5t74t0F01Oyg5UDgspBMXWx/xOjJRKtStVKVZDvZkN3mTHplNTDdB08n5ilm08pI9jbn+XckklS2NhPR2jKsz9AUixdQwTJH31I/Ni6zts31Shc7uX2f8EKNJ2fPVCpCbjNTdYrK/U7tRF2gUi38N8frqdVfZleTlITfuPRa6RWNIp0ZZTfRYLzIVZgmywSkIamQAQqmYM2whhioCo5PKiuxRZqNVarnKTbhc8nhuiNug5Nms7Jb/QURbKEqcS92cH1mzG58xzGT+V5aKXwW7ISkoz64ubsyqwrQdKHdVo85jOLYL5QDyjTug1KfY5dRjCBu32K+poQsZsKgC7DFs8bEm1KuNuHFyTP0HPH2b2D8wro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b313f4b-e624-430a-d926-08db1eb87ee1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 03:03:15.6008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a2GYzqHcNhU47qfRRlc4DVJ46FtVJ9nm+46gVlH/A6Jr2Yyrw7N1xS59/XH38D1+oecUg41inb6p8RGndVu6/FyL9c74xwdptRb9KUqN110=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5749
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_14,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 mlxlogscore=840 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070025
X-Proofpoint-GUID: e2yAEQfVpc1i_5HAiZYzwJnrbzbwWNTe
X-Proofpoint-ORIG-GUID: e2yAEQfVpc1i_5HAiZYzwJnrbzbwWNTe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Ranjan,

> Added a new IOCTL command MPT3ENABLEDIAGSBRRELOAD.  As a part of
> firmware update operation, applications use this IOCTL command to set
> the SBR reload bit in the Host Diagnostic register.  So that HBA
> firmware is updated without power-cycling the system.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
