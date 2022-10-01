Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F1FC433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  1 Oct 2022 09:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJAJHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 1 Oct 2022 05:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiJAJHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Oct 2022 05:07:44 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21731150764;
        Sat,  1 Oct 2022 02:07:44 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2911X3bl003872;
        Sat, 1 Oct 2022 09:07:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=/HNkerm2Qc9TNuJIYPq1NHQDVzZwMt4Ai9MeQdNUauY=;
 b=UWcADZ3cZEz8bzYyG4ySbh7DI7ZnFp1Kcm0wltZ9dEehK5hoR8ohZ9bhRAUwK7onAruv
 aTVFlWeIk+z/KlseiH9vPfd5AaBysh/YMiDc+wwI43S3Kw++NxeQ6rfVgZZnNL93zEIC
 QQFu3m2j9DvcaqJTfQSNpwkFkCs0aAyGnRWHB4GB3P2nvYwZS2N1GgLY9WNNb6cqYq3I
 KjwwGzV3CsjRCeeE15/VDHSIxEeD6nBQ+6lbQy86tgNL1h4XteWmtw8Ht3RjhPydPx95
 xqrUKWyUScpD1fXahk5+9mUGDE20lw5IrTyyy8+52+jHmQ+QUED8D0CPd87e+VzJSezY 9g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn0ffb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:07:43 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2911XYad033744;
        Sat, 1 Oct 2022 09:07:42 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc07x34n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Oct 2022 09:07:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IHK9Q+HdRBSYIt56D6RFWaWRw4UoN+68y47PtMgATH+ymrR33FTeP9bU+n3N59jTH0k6GWT6mhbAJXZVE6srsyOFf3nmFtIyeXOfOsYvLZOg3rZz8XQ7uSuHmow6dc2atyzxHGl7KtLN8QybkbLoyGmzgvF20mJTkxH/qSYYFH/IWrHvGUuYwTIYc0gWCkzIlh4qBgvMM99rwKZB7n3jeH4YL4HT9unMZleFoxG65p5DhjdVzbPTTkiS2iX88cYY1KY3DFAKS9y61dXuMdGfdOe+RsBm88zdrmdKqxTzOFS2qjZQ4sgJoL/Y35/8g5gxR7isNHdedaYP159a2vXDew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/HNkerm2Qc9TNuJIYPq1NHQDVzZwMt4Ai9MeQdNUauY=;
 b=fxsvAb+3KuXoUWvlvFm5EkHVSuKqVa1E010CfSxI7ayA+SHN8O3NQPbrFlWzS1cAJPxLCe+q4tnXao8uFmdHqgpIjqaaoiWGp551Dxn5VAyar0+3kVoVKuBuqPp/0Jr/G2lqSwI27/+RLuXMc52V7rKjzXgwVmFb+yVyE6fWBh68VH3QMHi+c36F45wFPm+qvIyqSg/sErSAcdESsasbdAw6w4Stvz0o8Er5QaZ7FVJsNK92QaYkpB7s9cdn09MzVcT7w7rnUf1A3s19be4dNc3A2eoR7byK7upe/tmuNpJSfu6gpgMTlIxMT3sDybJ+cy0xgZoMO2RQS4GXEQHsEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/HNkerm2Qc9TNuJIYPq1NHQDVzZwMt4Ai9MeQdNUauY=;
 b=i+8RulyKkOnYO5migjzi5+7vONTMq/VJmqhFiF2Qh3W3qstdvPsIrxGaW9gBmHd+t4o7pOf9xlOIb5P/xgr4W4u9EOSdqCuA0b5BvsUrl6KFGFh7OvHT3AiF/beg5QiDouYAs10Md7PI35GPccATkBWWWh5K5QGDIbWDJ65ZCB0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4703.namprd10.prod.outlook.com (2603:10b6:a03:2d3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Sat, 1 Oct
 2022 09:07:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a497:8929:2c6f:7351%6]) with mapi id 15.20.5676.023; Sat, 1 Oct 2022
 09:07:40 +0000
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH] target: core: UA on all luns after reset
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r0zrlxo2.fsf@ca-mkp.ca.oracle.com>
References: <20220913163602.20597-1-d.bogdanov@yadro.com>
Date:   Sat, 01 Oct 2022 05:07:38 -0400
In-Reply-To: <20220913163602.20597-1-d.bogdanov@yadro.com> (Dmitry Bogdanov's
        message of "Tue, 13 Sep 2022 19:36:02 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SA9P223CA0011.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ0PR10MB4703:EE_
X-MS-Office365-Filtering-Correlation-Id: 8618be12-5edc-4d6a-25ef-08daa38c64bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tc1/xfhd+zBfTw6ALfyK5zBZZcW72KQyvBRb9tTQ24I6KQfcxH5H53lBWcAvUGwAlSEcYGiGOdOWi68fkVwMkYs7n3wH3vp3n88eD2iGR18Qi4W1b+IuXCRbLc8/8OcSTynVk5+7FtGAfJ+vVY/aG5enHfUl503lZItHB8VLPJFKvym7tIZpOsgpbZEQibanQ0Kc0vo3r8SlDZwOFE0P7Ux9Hq8kMTKXiUf+10AUXcRdCdVDtDpKyprCKpTy/29oY3BII3JEWPjdRqDbbBueBfCqmWxddYMqwHb3jzgCf+WJNs/+iNBtBYj+SoBOh2wsKfnEPlx9xND96QiednLWWPVfkn9rm3jj1N65om7YlspjIKZMcHPyWUjnKCaICmsS4xJ1K3ZWW89Du5Gw732GE04xm3u7ChRTTQ+mo/ZUb68XXGBjaNlKjWVcO97j9+tBeTXbMUwXD2Xj0HFMAieTy0Ukn7VB1j99XIBb4UQHQ+Ai4k5tlb8glPtBrr3wck6u/OjgsfruhUaNDL+12iRUkNelzXDtTAOn1VjMt1i5AQl1EAu4cvjSJkJBBx4S4jJ3jl8RMqNHijtOeyM8iCZDmRPJkzyo6CRN/elzfesrGUCAbrQJzhdcTE8TamTji1+7+5lAokIlIiUnHH7NQhjXEvdcenJDc1lHsLkoNKitHt8Jhw2EKYlwmyvKQuuXCUOsmUWZzpQ6HzNICEFIxuYYRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199015)(478600001)(6486002)(36916002)(6506007)(6512007)(5660300002)(66476007)(41300700001)(66556008)(66946007)(4326008)(8936002)(8676002)(316002)(6916009)(54906003)(86362001)(186003)(558084003)(2906002)(26005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fTNLSQH3udgkP3FBymOaMDLSqvACUx7iu2wuAVoQSAcbq/9XZs3IGa5eMHnr?=
 =?us-ascii?Q?pZyk1Q3PjhWTWilfg6K8SosOzQh4N9cFlgW1c7GAOCLl8LHdUhWhJRK3rKQG?=
 =?us-ascii?Q?oPdolFFZoelogOO4+zI7Ln2PzTyenJn3mS7+GvS/KRMwZKQ3fGZ8A6zKjL6P?=
 =?us-ascii?Q?6jlEtMoZ2XFr+S5QmurKAgKzQKVCD5wbwtpyZjJE4GhSOw0YhDESCsOH41Cy?=
 =?us-ascii?Q?86QaAs/QFOJwDHHr0dvTwyyM1CtZWGYE7XUrGX63OcXNAX/AbwEev9eoab6s?=
 =?us-ascii?Q?UuWd37RLmZRHVOo+BCkkyIWuCQ/xmcxshMjmhIZl3Geh/m+eZszQaucbr/gV?=
 =?us-ascii?Q?gahDnDIogbgcMYPRaNNx6tkYHO7KvRPdlFD9Anaqc67bFrlxTTnP06WH5nkE?=
 =?us-ascii?Q?C3ou64vuwcW24ifmQpFXjtnipXDp4tbomqxx4vzZ9wzHrR4FvC1WLcaDBb5m?=
 =?us-ascii?Q?tBTAxQ6iSS+rBWWFK8AU4PxZCT8AGBgL5EzxnR7+qOJnwuVn9/8X9oEMQO08?=
 =?us-ascii?Q?QJZ5waypuI7sW/1HM2q9On6dg4cNroQjLSyjzthnvTkTGSgUKtfCGB26EEK/?=
 =?us-ascii?Q?2H6QjmiWLxq4WzJyDOQpF6Vo38qctoXZzMA1YaFH9POG+VlkFkK/6CPCMbG4?=
 =?us-ascii?Q?w4Qwf/tHefA7qxweaQor7DIj23lDh6NbGul/2kkG7tmh+L7Dh7YTVgkrWZXI?=
 =?us-ascii?Q?g7aOyVrRxrOLIu6AdtousQIIQFT1JO/KzdroWpX9z0DZFueobk3+9xWYWuf3?=
 =?us-ascii?Q?J0wpNmxXqmyxB+HuyJ+eZZoYUmxEPtR2ThQhzwoTWgzIbwXpbeYUemrNqbLo?=
 =?us-ascii?Q?t+s78MGpvUegfTP9eTc1zXp37QTV6UyMtOvKRaF3DHOEZ5tmUcFu3P2VVERL?=
 =?us-ascii?Q?zlUQl+yYZlku7ANKQLQZ4rJX731sw8SNjsG0HcShhBmgX7g5j7gecg7pEXHX?=
 =?us-ascii?Q?lAq4iDeKPnilC3GYPYmOz7n79R6ZSw1M1eU/2RgG7Diac1fwihUZSH2XI/X9?=
 =?us-ascii?Q?8ZuN2EW0opyRBjl1Pj18K3oXcyiRq0ecUpdiCPPNbee6ppftF0f7Ggj9T5Fi?=
 =?us-ascii?Q?ahzCKg558nPxa2ddmlh/SskBAFnr25SiGqWo35CEgMbY9DOTcPegODLRx6ve?=
 =?us-ascii?Q?R4xp0BAxLXxvMeSp7mwbkHUF+KR/4HllTMxp8iQi87uQnCMmupreW9yQMC+r?=
 =?us-ascii?Q?fLlK72hxugbbvQ5P4SCiGEhIuAbIaEHj+B5/Dyp8cRyzemLgsKhV7Qep8q/M?=
 =?us-ascii?Q?EXxqoQNJEw1+Fctu+pDs5xB8MYIDH8fWYGM/D6DF+qpSmhlFE++95RQ3hy1Y?=
 =?us-ascii?Q?piv7XX2TS6JGxe9HC4hydU6nama4Gs0PmYkecPpseMvyZUSiYUnsnFtaV1j/?=
 =?us-ascii?Q?6MxrquL0CDMTojiWRVS/5eRRo7mNqkINEMN9Dx7geSrTYcd8iHcILRoQv3xt?=
 =?us-ascii?Q?h8c94FbHzSm6v0P0vvICSt//ZkoWxk4GoysIKC5EaInhRy2mSgZiEz7Fgzns?=
 =?us-ascii?Q?mB75VXpAsVMkNbh7tvB7pEkDXsatCmNm3yXKv+Ecr3fpLVkTKHdw+LmdD57V?=
 =?us-ascii?Q?MgZKqxG2hMvMDha5OfLQbsDOsvAj2cLMNnTVy9qMFw9Lq17Tim3BbvjFN8VZ?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8618be12-5edc-4d6a-25ef-08daa38c64bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2022 09:07:40.8865
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ADP1ZxSesPaHgvJMy2acFGDdEJG0qNrIR9fBbs331Qm0/RPyu4mVgLtUhdssxgjEr1sRXpoLHLmr+5SZzkj2H1RnxjvI+OPoxm9yGrm8WKg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4703
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_06,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxlogscore=929 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210010056
X-Proofpoint-GUID: 9ihBVM7HbNojoRvTagnFPwxFEji6Cc9i
X-Proofpoint-ORIG-GUID: 9ihBVM7HbNojoRvTagnFPwxFEji6Cc9i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dmitry,

> Allocate UA "BUS DEVICE RESET OCCURRED" on all LUNs on all target
> ports of the device upon reception of TMF LUN RESET.

Applied to 6.1/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
