Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6396EC64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 02:52:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCJCwU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 21:52:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjCJCwS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 21:52:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBCEF16AB
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 18:52:17 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329LwuH2021600;
        Fri, 10 Mar 2023 02:52:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=lZWWCnuagyY4WSKrmn7UK/95EQScBj8b4h0lOr9oqK8=;
 b=2tNfrG9b27YynfdXLdTRViM/aV9X+E1YvbVsf2l0k2p4MOi+ED2OeaH0YNPITb7f0688
 MLmabAT5qmp1vUTltMfz/EvkmMx4hNoljK+vhUynVtNOYmNxQ1E0E33o3fN1LJruOogO
 stovLaU+9/Xeq7nqE4djIJ213VjcSRQPesbLjRDvHISiFgBv52wRKR9eyyvYkvI1nhci
 U6UrIStOCHRrCS7zm0ubBEc5DkTnYjV4u+YD2yPLDHy5ESOC0h6rNVxuLU1uef2RXNWH
 lknNmbaK+S1QDfZ2lFTM7+aIO84b+oB7LflKBB64thzzcBNYjBL5So6mdnoG1TCF+58i xQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418145g8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 02:52:01 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32A0GC9O026632;
        Fri, 10 Mar 2023 02:52:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9w2pc6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Mar 2023 02:52:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JKKyKqFqGXG3IJgmpedbjJFrQKZZ66ouA6hpuZqi4wfXqVlkMaV9LybYShncbhLQm11oPpyJ+cTqnczyWhA62zxr/JqECuEkMD3FflNbo2h6h8WgvLvFzE8kA0RB1puarfU1Ich7WuyaInXoqwBGw2ae9PyZAGSOo/6HDiKZy20JpSIAxsNKchbeQmk6jbAYF8HvuTPbcXujWN8sBF01vCLJm8NnrLuvBGq9aLYArST5WsnZxdX+0iO8R7J3rpASfWkT6gp0rcpnKUUR9a5rGEDmGISgUQENLy/nX2HfXv/VgYrDs2/1EqzKmaW0PQrzl8mxzJeFHFjLhoLJcjYgrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZWWCnuagyY4WSKrmn7UK/95EQScBj8b4h0lOr9oqK8=;
 b=ij/zWE3e6aF0OCoOkUrXZsQBhOiB/wjpkfSrQPdcFvv9cXxkV/8a8BLMWXLqKczi5FLTXLfhXuc1JTEUqXa0fCE3XoR/a2jO3kS2QEot41aBw3rMddBYvP/yv2VxyNTBRWVIqDw7U9lNg8JrdPn56xKCMBtyZoz2nBkdkSQZBmHqwxF64VsdAlKCja3VMWH/ZzDNOIeiOv6cY//y8fFKJtDzM/Zrx45dT2dn8pgs4lM4WVzMhEdp+GkprlJJG93I4AWPSIaaPSXlmOv/t2FmjUhXkSxwfHVZ3Q0oCGpLEJ1ej9RzrVhWfxu5AdORkWW4DxwW4EVa9PgVRnVscZc9dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lZWWCnuagyY4WSKrmn7UK/95EQScBj8b4h0lOr9oqK8=;
 b=ATb7LpFu6OKKHEBQWcJ0TgNLu42KB4GBgHvcz+8O3sTKneS7fLGjcbxgpizYJEHkkbdDLqXmky8IbE+Z/us3G7v7YgnwtOQwKyv4Daxke6Ao2ZPQbq5bxvdatN8INRtemu5okZwR/B7fc8OT0w3Zd3CHUF+R+UIH5uH4oPFq8zQ=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA0PR10MB6842.namprd10.prod.outlook.com (2603:10b6:208:436::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 02:51:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 02:51:55 +0000
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/4] Add poll support for hisi_sas v3 hw
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yb98gjn.fsf@ca-mkp.ca.oracle.com>
References: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
Date:   Thu, 09 Mar 2023 21:51:48 -0500
In-Reply-To: <1678169355-76215-1-git-send-email-chenxiang66@hisilicon.com>
        (chenxiang's message of "Tue, 7 Mar 2023 14:09:11 +0800")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0353.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::29) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA0PR10MB6842:EE_
X-MS-Office365-Filtering-Correlation-Id: fc26ed1d-4469-499c-9bf0-08db21126895
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PAaY7768d1Cqi1Q1tTN+XaJmK2/Yrvr0L+++11yg6tbn96xaGZrqkHdYHn7wo0Lw9zwJ4BLOS5PX7/9kU94fv1s25RHaD8cSW1Jtekq/NOVQxUj3ZSFj2kImv0iFyIVQ9sjZShtdd2bIBuw7R+hKg7ZzXUdVUM4W3NcofGmKXyDsRXjYXxu0TbuOhdLKTGGTdWE+5PKFr8Kykox8dvvrhdkzwSQe0b0PnbNgMv1itQl5DEYdlV7LlyAvMQY1ZL1O239LkbIT5OzlroXmZM2gS2EhdnV19K6hpfRHMroLtVTpQb9yoYroqTyxlSkDTftlBlId3SzBLwmvCgQCNXqzYXAvSdPcFtHRlT5WSsu+MECLTa7WZtTHi8kty4m9bOeYKMaWWxdbeAUMLM1RnGb5WQ8CLlJI67v06Q46PF8yBofoGXARygTBxV5KqYhtg1+SRwX6vR2+Giax9wvur6L16+xSPakai6I4HpOpjFpJjD74qIe/ChoIwo7z3P7NTIie1qHESdViW6XIIav62Pfrk+NjhNii06vN/8cRaP4yM/srjFA307uvHg1eGfQ1S5Q/l7y0kqh6wRGlo6Gjb/DcqQS3KFOlb16oLWNdwgCWfWNqsvoQdKUHzZnN9L42MWnJ/Iv15kciV9mMxfhUGUkjZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(396003)(346002)(136003)(376002)(451199018)(6486002)(36916002)(186003)(26005)(6666004)(6506007)(41300700001)(8936002)(66946007)(4326008)(6916009)(8676002)(2906002)(6512007)(66476007)(66556008)(5660300002)(4744005)(38100700002)(316002)(86362001)(54906003)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kwUku1IN8gino5G4Q+ggjQYR5+VqNqhuSc3/qapWxK/Fh8LZcUnyAPNR56F9?=
 =?us-ascii?Q?z/9pXFesP/4LLHbV3Fgxdqjn7feaFzOlxGToj6eR2p8h8MFXZuhmGq47rjjm?=
 =?us-ascii?Q?1RCNhxTCY9eJ+S/zO3S/8Bq+iKX618XJWtdkoXTfSjRDCDzzDFDsoM7VRahp?=
 =?us-ascii?Q?EiAILBZGBNCpSyhtX6hpe+zmiBaldp/mgWaXC2C5Q19wbuyy+gE/zFJJmilp?=
 =?us-ascii?Q?KOrpGaMuJApiXZCbwFvjFRqCB/WYn4EEXk3QRWCb4AtS8nSHxWiDNMJJDRXF?=
 =?us-ascii?Q?g/yc94kgB0lPEYVGPL3Bu3I/ac2ShNF/H88kSVGVj8FiU0CWnDR3CXIdtoSI?=
 =?us-ascii?Q?+5WUkXTOYqgZkYxIIqSB/KUjr9PVRiaOLBlwZfKhoiN7mYEAsGJmFAMwjlIT?=
 =?us-ascii?Q?7jA6G5G/nhYemfOYH3A1EYmu0ZwR2Q5zfVm7Tk3WFkKF0BHpJyACQFscfSMo?=
 =?us-ascii?Q?nOUBN/4xeDSrkUQQzAh4W3iFnqgFV06X72AcaGdhYiplw3AuLQUASwcWUlig?=
 =?us-ascii?Q?Us3ECtH/5jpgitUbuUGK7N1vgwml6/1Mxd4YYWWcmLpuUY6Z5JLyathn6O5F?=
 =?us-ascii?Q?StIq1HNs+wfuxOa80XIBB8c+eQQB+8Y/zHsNmiFo1aJ03JKHgCJywVK0nDr+?=
 =?us-ascii?Q?3XbJA/BY6W5ac4IsvDCinE4pDWJmvSfz9LMPC54JmRFIxGT/r08TDiBA/hVE?=
 =?us-ascii?Q?gh4l06dPBu3lckCt/sk3+6qE2wWhuZUuZg/l+Zwl+KuzcVpZ6PyrXs8+3oGB?=
 =?us-ascii?Q?crsMejfGSuflKFeq4YQpU2t5XpyomYgoa4HC+i9DdU8JecbMwr42L270p/BZ?=
 =?us-ascii?Q?W/d65YIy1Tpnd6NMpTAQXQqtKvIoxaa1uiJOLTGpUJ2N8MAXwfAgKWszV+qP?=
 =?us-ascii?Q?sFkWxYxbRbaioB/k3UhiSRSl9O8ljzE2iXJY6pQrvuI9fMRguquu/8P2pJzG?=
 =?us-ascii?Q?CRXsi41xlHcFaysFpqFI2hU97xIjimC/mly31gABgSOi3GpAYElDQMRvcvQr?=
 =?us-ascii?Q?O+RDmvbEtEf+fQUkrpSHueOYK8l6jCpg5dAc/yzoATcX5DA1St/9yKC2PZf0?=
 =?us-ascii?Q?o9TlZd8IDBCikWc8DJNnXKTGrlA/qv3GayMybJLO59O2URgM4dYLaROfjcyx?=
 =?us-ascii?Q?8aBYSFV+KhVLOXOCwTd2fSwgc4XGSLmnD2mL5boHB9TUEVdf3HJCToB3Y9fn?=
 =?us-ascii?Q?ksDGcnRZTGaZuy9ELeJrqaPCFmbTdEzwgk5wus/kIXLwfGcbIgrkY+00g6JK?=
 =?us-ascii?Q?7Widy/3WLNtRkaCbkTaPt+WFr6MwveUkltbx9+zfYz0euB4RKSZk+eLccD1G?=
 =?us-ascii?Q?d1921cnFdV8qYUd4bIfXaNQ2qg+WsMgJ5xJhZIwpchemJBqul2jN81NFnxbD?=
 =?us-ascii?Q?1AXj5KVYkMyGexCEffCYf7pHjE2cVGqbFgXXqD1fFzkYJadopDfhQz/VglU/?=
 =?us-ascii?Q?y7lIVjSETZv+VZIaTCQwAB95kWXNqBn2o1XE8mOTbb4FHXdOlrGYu3AvuTD1?=
 =?us-ascii?Q?kTBN1dFkyq6t5a/9lAQYoWhXM4Jq2bDS4sQs40s51XQXrtiSvUNQVqgwZb7Q?=
 =?us-ascii?Q?mPkPlzbqGkIrlwi9k3a2Np4SZoT2UJPwtbamujomwcAOh618MbVMvj7XepiZ?=
 =?us-ascii?Q?zA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jh4fu2is1H6Y8uRhQIVJwYQJeCb947P1Hyrk9Y+w4QVk+LCKlLoguLl88/FS1QO20YCpbLFaRUWj9tL678gqMLmn956ier7awuTyC2itygPeEFjopNb65WLpMO0MRzCHFv+hOQnwjKTVEJKqMptEvIA+v1ujCHXtEQsBy0HrTXx24mS75OsS8gWUd/uyyR76TzSFp91cwu44sfS0GZtrb/pworuPSyvOIg4y9emS2TCpkw99gcXHR91DyS2+3p3ffd21KDkoR6iwvNiriYsXJbWmRI0fWu9j5IZWKTuYH8AymDOkF1lDN9R5lFFRG0ysSCEttasFvvAVT1mabWXvxttw6e5PVULXmFtXFIvyPlakGwy8t2HFtVZ1qx5MzOXgnl9DBBpbzUJu0Wmb3goOiFSIX2XYp9P6XtHUX+Xho1iwiv7f5+G7MeLBDdTRry5to1jp89GoyaoIDAPF+EINH3on7v7krXmu78sqekFZj8HACh1b/VFzTWnx6rGd8mgugNJUHVhwAAqqF21joXbJNHMItY1oktvpInPFQcpC7lu0UmCXV4VvXmOYB7QW3JV2DHRpKSlxaD3xu6FyaNrPCcEuZbbk58nxBAnoGBtXVAJkiem8GM1ZObGWKdq4sfEqGV7V+T95Zx6IrriBBMkRmx+bht92zLa6pjj6X3uLZ7OenQvVeL3wYdwlZBiaXQIGhNhW/YJlgTLjHZxMCElG8jxh05qQPydlbwOxcdqxp+Yh0dMRviyciwvUzOcmdc/exr4K1PrLFnQ6FRSbES5zQxVeO/mhkRqgudn7CpSzuUbh7h35bWsvHxAeqHs49eVUBR4zx2iyTP2ypdORj3t5qunz+ogQm3uQAqS1NYLJpoBm7QI6HNLAQhpXPDacAG+R
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc26ed1d-4469-499c-9bf0-08db21126895
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 02:51:55.3632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F6E6GussN24gCJ14/8D32UmwjGFIBMqpb0+Cq8jtngjPdkaJrnwMxBYwZEz5tM6fyCFLmvP/UdTuc6FaL9Hq++TWHpMTOWnRnhS4JDssAD8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6842
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_14,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=569
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303100019
X-Proofpoint-ORIG-GUID: MfJTi518R6m0sJK-xhoiCYyc5-GFXQOc
X-Proofpoint-GUID: MfJTi518R6m0sJK-xhoiCYyc5-GFXQOc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


chenxiang,

> To support IO_URING IOPOLL support for hisi_sas, need to do:
> - Add and fill mq_poll interface to poll queue;
> - For internal IOs (including internal abort IOs), need to deliver and 
> complete them through non-iopoll queue (queue 0);

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
