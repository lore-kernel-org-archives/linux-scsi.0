Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F92FC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Dec 2022 21:05:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbiL3VFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Dec 2022 16:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiL3VFe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2022 16:05:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C661C418
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2022 13:05:33 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BUFxsJ8008782;
        Fri, 30 Dec 2022 21:05:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=nXKk7AEJL5PnMhb9yaWAxj46dh41NScqyY43KhFRkYA=;
 b=mjBHq8H8yPFUOEZIYrDtRfp/b9V2lIeu+qF5tXanjtt0+ahIod9M58QExb8+QH7QNvA5
 pjz9TyICYkaLHXBWmOjqzvKaU6CPFPPadLBS7ZNtnt9ziQc629tD2A+P0dLnTfHHI3nm
 H/Kbk5LJ2bQVYs2unm520qMQQwoJ43UsSvBoJeb5dS0iRZ5va7LKOooDkhmNXFsGyd4x
 ZS78/dFQxG8kMRIn49H6NAsB5MxhetJ9NtcTZJBsmffGgQWiP2cXmAAt3KbymRh2QRNL
 ILKBfPpWppDzidvWalvWF/h4c5mmPmyO+4p9UwdA/G5xs90Uofutofkj3YcitUgzPa/K 9g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mnrbb8n5c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Dec 2022 21:05:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BUHGtpl034148;
        Fri, 30 Dec 2022 21:05:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mnqv7qksn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Dec 2022 21:05:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CF+eZVLUyj8oIQL5f0YAK4qNwqpfdOhWiCuc9w/zDGyzKPxG0JgPYSno3W/TCOWxFXquE8KSsxAvFQMnwyDF40I+rs08YpMKtkshINzbG/tbzjW4FGzD5XOmEqmP6eN02oK8raEYPNaCkW86RM5iHDyWQWdF3iH3dF2DloS3ZLbJ/csqaJHfyyvZw5DJxsbLH3HBh7C3VZL8yYj3tEzLf6u2wNRX14rTRo0QnfHFGbe7Ewj9oyQiAlt8tQur8BzvrFn0E3wIr76qC2DQv4L+R1XaozYn0A27zs1I1E/ZUYrtryFibBlDJ+iC8no9oVRi5UL6J8T1V5CW3F4cvuMevw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXKk7AEJL5PnMhb9yaWAxj46dh41NScqyY43KhFRkYA=;
 b=j0HrcSaj93aZLRjmVfo3LW/YZtpIGSziQUP6BFKM9ugo532zngFaIjZjCOhicDV0elAQ96htLgahBOaoONU70ogi0oEyaEAF1x91ztc6NNM2UkQvsuUYsGRLUJexxFrgPUftoi6fOzPDijXmQqjyGYjqULdu69mYx41JFXD5Xot7iXd3Q7rTqN4sWlAcyiU1XicmtXk2MexPtok6vvpQjnGQWNdJ2Io2+/qiHX/G8sjYXeM415fxa/o+vynVRmSEhCWTki8e57GQ2xBsaUdNeCK9vmBynviq4kOwZduhQSryw7zxRRa/PEeRJN8NbvSTOT/PaDjiyPZ7IzW3kamBeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXKk7AEJL5PnMhb9yaWAxj46dh41NScqyY43KhFRkYA=;
 b=gkxhKHA1S9d4jCGokJUknVuf8p7IPQQtHrs3BEHx/xBiwl75koz6enPVNZaYkNeAv1DdxfdnkT+YackM9FcedXOtEakVz0AQSww+Jwu4sP69zij6eNKxhQA0k5jcBhWRNqp8m7la0FL6JtcdKtqmRtyiD6299Fcl3/QDllmyV9E=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4642.namprd10.prod.outlook.com (2603:10b6:303:6f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 30 Dec
 2022 21:05:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::25bc:7f6f:954:ca22%2]) with mapi id 15.20.5944.018; Fri, 30 Dec 2022
 21:05:07 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>, <john.g.garry@oracle.com>
Subject: Re: [PATCH v4 0/5] scsi: libsas: Some coding style fixes and cleanups
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fscw61s9.fsf@ca-mkp.ca.oracle.com>
References: <20221214133808.1649122-1-yanaijie@huawei.com>
Date:   Fri, 30 Dec 2022 16:05:04 -0500
In-Reply-To: <20221214133808.1649122-1-yanaijie@huawei.com> (Jason Yan's
        message of "Wed, 14 Dec 2022 21:38:03 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR10CA0032.namprd10.prod.outlook.com
 (2603:10b6:5:60::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4642:EE_
X-MS-Office365-Filtering-Correlation-Id: d346da3a-06f7-4241-0fcc-08daeaa987a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sIDlcpS8mh6GJiaIGR23Y8SVvJFiCe1peTpc97xzeRvG8V73nXJMmhSzShym9OEStjeKCeseGJCEBzPnjvduPiRI0IPBlXkdrPxN6iv9dZYiJU7/xwBzZDQ5yWNWouDrkDW0H2x9yu4OJ2gzB1TaIi77n9mghv7dVDIbnNNK2by+e+58awaOk3nx41UDiZClSoEKhHkw8XWItR5Z61iaebjT9Zz04XzAupIRe3Ckt1kdgpmixfU9l6QHLaQh/q02FyHaZjxhqwfUd3bkb6ovUAy8/pbidyMhsy5yMERgLtIH5fz/4NTo+wvy3UO2HK8/9u33cm5Z+moWrgOfTMUrzBsTQOoP07DyuuayMTPciaErlM47EEX+FYRxjiFtNytlUZtwwy87sSrFNyL89dzaDTMHiMtjfgD3/CLySXIn/TaXN3DZYBvMcn3BkKGgUtR/abqJhaL2QfJhIbwvIFy+io3HwnwxMhP+nYjfmwLCGKoxbCChs3R6Ga1QN+HX2hQ3MX14NN1FjeUss2HMrTt7crdOcB7tMNvjoICQug4FvGURKMNw7Z5/KMh/pSV/WdZINM3KFkgW32Ml9EBrkOznxoH/Ak02wfU18MAIVCz2qFjdReZh0phMSEuO1N6icuaBpaEIoNfqDyRmWsJmAI49Bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(39860400002)(346002)(451199015)(558084003)(5660300002)(8936002)(41300700001)(2906002)(38100700002)(86362001)(36916002)(6486002)(54906003)(66556008)(6916009)(66476007)(66946007)(6666004)(478600001)(6506007)(4326008)(107886003)(316002)(8676002)(26005)(186003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HxrZsuNERCHvFIdok2C9evQ4HpBzDVgJ2odS2dqTHa+2Eq/VlZpzZ13IgkMm?=
 =?us-ascii?Q?egIyvJZ1N0b/F59wFPY4hAbFjKMTQO+QagNrYlmsUSY4rCYe8ywUXqJfK96w?=
 =?us-ascii?Q?gQiXUwbzL/9zqVKvybTzOd6Anj3J+JUOxpM/CHLBkUlVOeEc6IxrseJ1zs4i?=
 =?us-ascii?Q?1ReEQwF+B1pKy2bzHWt9hQW/SnjDNs5ZX70vOUx/Q6Wb9jRGXO7Y1jgBGU7j?=
 =?us-ascii?Q?bv4I99Y+HtDzVaJZQ0dX8gDR785A74+eTG3Cz5vV7SI3WB7didxJmNHRkfc2?=
 =?us-ascii?Q?WGBt1Du5ARV8Px3KwM5r/m3qEjYBbkIXe1ZivqKWjeyYc8ryxmvVsFa0Elue?=
 =?us-ascii?Q?7do8cqtPlHa26AFW2iWiHTEW2zx8wshR6zHtE+TfkhPI0vdyrsMgQIJhOM6i?=
 =?us-ascii?Q?To/wBd9V+8eUHMZICLPZjXJK9bKYA4EpcYJuXF3ERQeBmnhD+BMECa7oX40f?=
 =?us-ascii?Q?AI//Bdbrz6x5j0WjGdPj741DIeDijrtjj2ezcQ/iNfXYdS1svh2+6BfB0HMn?=
 =?us-ascii?Q?aY5gRFXcmFgEPTAjyVFHwXVOg0/Qm049P8Bz1MeKOJGwBYXrlTJcxlqwQEI3?=
 =?us-ascii?Q?p/TELA+KgwbNuPwZ7Kl87ClwFM9ftcDdsUzPkPeLtbjHL6fQFLHFOC46GUSG?=
 =?us-ascii?Q?xZ/sbi/+GuhjhgckIW8NLgkvWlDM8s3Wtc+vhx4xthS2pRnPQSnrJNpD5O3r?=
 =?us-ascii?Q?yTivLV1nFjg+q9Ofswd84gReiqThVg8RJLyogNF9vD5wTtnvMut1//QrcFjR?=
 =?us-ascii?Q?s+7O+s+Vvf2RsrHiycdxwOZ9AYAJvAJoLb1QEhFq7qdd49wjlAaHFELWr2YK?=
 =?us-ascii?Q?S6vCug7ES+cIN5Xmx107daYQkTjtVMJhHFXBS1YPCigiHJ3ujuMVYLBDq/p7?=
 =?us-ascii?Q?1ZYYKmrp09g9ccPDGgNIBoSsTQm/R66vv+w4Fs4132G4TzviRI9c0KRI7DNf?=
 =?us-ascii?Q?+SYSkpHp5iWtW9UXcShVVx9fNx7MFXyalIkaofmER0sQ/Z3rco3ORFdXlms+?=
 =?us-ascii?Q?ezkDWoLLNwVr639WxxvxVQv0mBdWycKta7fffxU4R9leKRkciwq4MnwM9Sy/?=
 =?us-ascii?Q?yqDTxubjwxdTASnSok2nEWMitgDQYNCZ1BEU92VSbR6NTFqTW1I8V48iEGzE?=
 =?us-ascii?Q?YPovL2r/hZekWZpAHsQWJ5QNrHmnfdl1w6W050CthYWMHiIV2VY8LbwapDv+?=
 =?us-ascii?Q?LV/wNIfSOJ2+/oQXItAyKuZ2pUqXIYgO5zyuKLq4wNsMyrBOxzQahwxJlcx4?=
 =?us-ascii?Q?s6M2RlBSR//nz6PY7DUJh3b+ufbCDFBc1C0dB7+smh1QK9bihPFGcf8rpax1?=
 =?us-ascii?Q?IrC+8gBA3t9E2Tnxdu8KeYrdZYJmog++RiIkCXU3I/Bk7wK9VdF1XVAeuJwj?=
 =?us-ascii?Q?SL4tcnxsRjCIl1W8EK3XPZPM+WnBbx2xmSziHMDkR57JGjKaUleXe/FEcMsu?=
 =?us-ascii?Q?Y5BbOAJXVxcEbiiKl5YMsXjvG9fFKCjNX0ErDtJeg8P1UwiSB4UZE65dFSji?=
 =?us-ascii?Q?o3ExhHrU+RophX+zdRULIpkvH+YfO9d99gOGcrjNobe/6rZIsRWjOWj9OkND?=
 =?us-ascii?Q?Bw/gKPwHInKKo3s2V4zxCXSyuy6wn9GZzCEmfUc+xkpqSO4ZszIsHC+1+S9g?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d346da3a-06f7-4241-0fcc-08daeaa987a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2022 21:05:07.4023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Um/PNdTAGnu9Q1kglSLsXR71nA9wNZFr8Rs3iXTiaOaW3pJyhCGxBPqPBvvEB9xPpS/UHms/tfD7lESO/vUwlzoDOZbXyfTF3H9VHXdd20A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4642
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-30_15,2022-12-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 bulkscore=0 spamscore=0 mlxlogscore=932 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212300187
X-Proofpoint-GUID: acBfgnBmWF9ncTnXsehTq94IIUcBjuHw
X-Proofpoint-ORIG-GUID: acBfgnBmWF9ncTnXsehTq94IIUcBjuHw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> A few coding style fixes and cleanups. There should be no functional
> changes in this series besides the debug log prints.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
