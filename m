Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE30EC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 18:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbiBASkl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 13:40:41 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:55850 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230156AbiBASkj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 13:40:39 -0500
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211IEb2p018940;
        Tue, 1 Feb 2022 18:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=0qFdgkVlet6cSwEFmII1YzmuFdsm+xWD7LOFn8VD4fA=;
 b=JtzCZ5ouGSHnktZHVaby9wSysBvuV42oh4Y90ZgkFRNNNSUg4/igHF4eGXNjLcaM1OEB
 90d45IQSC8t8jk2ok+txjzZZKSKtaLjVfkp3r5ReUbCM5wmycEN5dmurScXqA6VYXZYH
 Jqq+BCmMbtuBuSKhJope8XzrRg/fcirJaly2TPS1o19f3ZcTvqVRCPFf6qy4IMxsfors
 3THjwlVhnpR6fl9uAW29hxFxnjtxJZjbOwkNnBvl1iRFXDon+uRPkFVvGAsB1A+PAdej
 8bui0yaDBVMtW46FcNHobWwbVtYwn3/TM+ppSFPjI0ompP2P2Y9hUcvn/kfam9GRmQkn DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dxjac3uty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 18:40:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 211IZapE150157;
        Tue, 1 Feb 2022 18:40:34 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3dvy1qhpcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Feb 2022 18:40:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avSsgLkdJZND1XC+LXySsIbvFXJgZc+vUj7NRm8M/kPdxQTCRvB0wm0PhT63I9UfSlkOX0VnHSyY/LvQj3D9dA6kBrWWdT1q0HJ8mqFxL6Cd6ahHERsK8dOdUlOwbF/tDv/zXlVfjeaGQYnUsTWUYvcuwV59s+p/XXkp+Kp5DkXpqveRd96xyBbVzfJnga5kHE06aIdy32SSqNCVTNXcPG9k7hH1bZMln/wiTiieRqRPN424ZRwKqeoMrQ/73Bc+oo/+lu8uHxzOFiilHsdgoQNfkDxEzl7S2lfJMlpdyYgflhZKKv3TCAyOLKDJBhWcHIdOXMFU02qQmRyoiMITDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qFdgkVlet6cSwEFmII1YzmuFdsm+xWD7LOFn8VD4fA=;
 b=IliwPzb0Vr+x+qDMk2Nlxtykcu8IfFUsQfsxU7vBajndsrcO50M1EHD9kTP1U28ejJsmBOYKdszPifTQh0SQTOoirtidfnJ6f5bKWJhLbQMba/TrOAf1FfITghdOBP6PW0GoTzqf02ToC62FoZMmEV0hO7g8xHhIKwRRuOHuZV1zzgV21NNhV2luvZGXw8oI1qbZkk+96zB+Nvfe9BvaHypTz1Ftbm1tLWI+DpnSBMG8gDhGk8NMtddXg4GV67j2gCKQpiR1E+R2Uvux/OzgYdPx1Q4bddcV4p826J0/evh20oUuvYPBFK+MHrPyC/+fndDK2Af+4gueJV3BN48J/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qFdgkVlet6cSwEFmII1YzmuFdsm+xWD7LOFn8VD4fA=;
 b=tEXraIkUZXRBS52H4IFFxmStI3KANtSAxVhI9OVhV7RF9hC23DK8cwKk01VEjhw2TjUia2gbP6K5EDdfCD0wV7aBrVWkYB3pfjFqt6kksLsQvQ5dMA8xH+tZMPOwFqwZrLCHGMTl7SF3RoLDzRcnD4+Ib0LaVtu+9f9S9jgJuWw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ0PR10MB4720.namprd10.prod.outlook.com (2603:10b6:a03:2d7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 1 Feb
 2022 18:40:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1caa:b242:d255:65f3%9]) with mapi id 15.20.4930.022; Tue, 1 Feb 2022
 18:40:32 +0000
To:     Ewan Milne <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: scsi-staging crashing on boot
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czk68msp.fsf@ca-mkp.ca.oracle.com>
References: <CAGtn9rmosXZtSgn24gFNYTzkFrHgY+pQBNTiP-3N6-a8OX+HzA@mail.gmail.com>
        <yq1ilty8o81.fsf@ca-mkp.ca.oracle.com>
Date:   Tue, 01 Feb 2022 13:40:30 -0500
In-Reply-To: <yq1ilty8o81.fsf@ca-mkp.ca.oracle.com> (Martin K. Petersen's
        message of "Tue, 01 Feb 2022 12:58:09 -0500")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0019.namprd14.prod.outlook.com
 (2603:10b6:208:23e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8163c8b-8f34-4dcb-13f8-08d9e5b253d0
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4720:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47209B91CCCA0DCEAFC57CEA8E269@SJ0PR10MB4720.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hs7CKR4d/XJBi4FPRTIlPiVwF0HW6Ush8INNsAMiiArPYCeey8JIDapQyeh8tXeQhjKfHJae5i+snHxaPbk0MSzfz27JW3n0h1TBiWXYntnMzxlm0L9FzWhXwg6qKkXPjR+3wGInJ7A0uWMzZeC7faUsZkO1sYCwMvlDCoz0SIotuItUdw9rSt0K/0S50qiWr2Il4Z/+Ojq8v/239IUHB2p3MSQ9zEwS7xvw6eXaSCuwMVj//pujyyqvBdIuZQbmDroZfm8IypkyswLzE8b8jSNICPthwCNBPXQ8B2Pw9IFRTKxo/nNoYbhdN6Ozdd+0QN5uPEBL5xqg9Np+xhTs+k5KpZ4WGFlFn1oNlTEfhK3aB/bSIne4OBovxUd/Lh9Xc7XdBKlUf9pB/DnmCiOSysNjxczZedOhIFAqhHEtrigCO1fNDGslutppGyPvSzwcVEMhqhdvmFreo88sYCDaeCAUBPenO5xBqMrPW6OvgIjjHJIYxlkv8cc7LDeWUDSjw1AoFwmt2JCDdqPsmOh3zsecXkouYehC6WES4gRxB2o9tfiAEVFmXRu8Mf+oSD2wH71muDH81KmllYrzMQTkjudWOeiXJm56fk1hcQ/P3W7Z9AqIh+3Xt8Z0D1DOjA1EMty9Flc/mdRUHRmr+++MPq9OHqOD4EL/88Xc6SakqRs6k1oXIWTi8cGCskn8bhVR5adAeloX9OYhgdqx3UfdrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(558084003)(5660300002)(186003)(26005)(8936002)(4326008)(8676002)(66946007)(66556008)(66476007)(6512007)(2906002)(6506007)(52116002)(36916002)(86362001)(38350700002)(38100700002)(3480700007)(6916009)(6486002)(508600001)(316002)(20210929001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MbUp+FVnjqx0ARR3Bk1Y9DeccIejOvWvHS17252pl81B/AxnEQ7EhtkkstXJ?=
 =?us-ascii?Q?0C8WeAWa84YnWbR2xDnEVLm0ZduDuUbY86wS1ouEGODRO3j3kK43vGmrUHjB?=
 =?us-ascii?Q?k+P4h+RZQsNyPZl2UgI0zzG7Z6GX+9v65awiDyUQQ151zw8tjiyK7xvrb9my?=
 =?us-ascii?Q?yaKoq1MhFsr9DzKkxLmuxpZo0gaUdYihpTjnuk7Blcj5YrwdeZZ0HQWjB0b7?=
 =?us-ascii?Q?yHfTBGubAiDWrWBjrmm/4wzjuexWkzKpMhGqqIv68G+3aFEnGRO51cZVbYq/?=
 =?us-ascii?Q?NjOAvtfJDN3MaBImNEIsX2XJ4000pD8uPD62hUa6QDJ10I8/tYUDv1p6iSsl?=
 =?us-ascii?Q?hYVISEGmuYGCZAvtaQvTGL1xpFAtXnreTn9k8ECyviRmHKSN2qS6S6JOuQMh?=
 =?us-ascii?Q?gz0xXg4vUWvZEW7p6yV1ICzfAkYsEtjSbw5pqzWAnNtskgVy9DA70cIAmmWv?=
 =?us-ascii?Q?HadKSPYJs7ym0DZSFX6X9caK+yxjIpDvIIY4RojYGa+92vQ09uKOsrpFT4aA?=
 =?us-ascii?Q?iqylyPAKwDRcRNZFjbmTEi1vfZ+t8NhNWN3ykiH0rpzJXbZ9j/IvVxDfpNlH?=
 =?us-ascii?Q?i8YzOcerw3xsSaMdSYx1x1XEHnLRh669mvVxPNrQ9dnfpriCNJ++RxXAsk21?=
 =?us-ascii?Q?X24JrAfF17VkbqRpOL2fcI5pDoiX1A+08CMYN7ICM4sEavXKAay1lbVkrP78?=
 =?us-ascii?Q?b7jPuzKkTjKF6rHHptatqEsqbkyD5/skTWJznBZbXmZ9MYpxSleNA0jz37e2?=
 =?us-ascii?Q?09xPHbvrjMfhOFLb2hBtt0jmQrxjvf3n6tUOmBf//W8qgysSNxwx3oF4TP3c?=
 =?us-ascii?Q?TegNHy9ZNgthb3VMm7VBQkO4aQqr3THyzpdFJbZF9sJ9COI2JFnZ3MWPXioq?=
 =?us-ascii?Q?OdbfksuqZCqasTqFAUw6jbNswSPt6wluW2jm3ZZHp1j8Gg9t+S6WPCPvdBJr?=
 =?us-ascii?Q?/ynfYXKEjLsHHUewYlsI51J4guQd7IzRe3OFgZgLLot0ZOSp2n7/8MctH03d?=
 =?us-ascii?Q?J3rOlY7d/gzuI5aDy7vj4ty90QTOISSSw4F3QVnR0OEO61ukj4FjmBFrapqb?=
 =?us-ascii?Q?adNHWmPqtPAUEP5SQAHTGjtPWWofc4GwiayMW5Ftfu1YEumgQQgL4snOXxEI?=
 =?us-ascii?Q?gAmufB8/MVN8GfTqq+FRf/hJDuQRXX+1iFSdQUl1vlvvtlQBrkLwKy1KkGlg?=
 =?us-ascii?Q?2/qMH4jFTZQKUTZ2dJ0dz1ubvec9pfDQ6/ZOep5Gd0JbwJya6pBTk/rMWRfD?=
 =?us-ascii?Q?M5vR4bMbBa+qIU733X0aLLyraGcT+ZKtg03NRANNeu2LeNEOhvkwT6QtbmQn?=
 =?us-ascii?Q?74Zk0oIOIrtEBK2zlTefNDSeJP3vO088hdkYTq8lrdVSWlkuyylr+/tEWYrA?=
 =?us-ascii?Q?BY1XVgtj66D+85FHNJtLpDDIvg9nSGZLWkXXhNDdmC54xGoW+b8dCEpHCWsQ?=
 =?us-ascii?Q?26SaD6JVx5SBpueF+aS6AmcwqBRNOlMy/vmRG21hsw3ZDOw7VbX4kegWDaDO?=
 =?us-ascii?Q?5L2hGewzFemo1os4P7hx2U9CAxfH93rjBQMK4qRwf02eQcKPI19GD+CtOKZZ?=
 =?us-ascii?Q?f5ljgBhSZU6CwiF2X3Jn71wc3yysyyBnaXEH2OVIYDVvUy7KLDG3KkDNpOXa?=
 =?us-ascii?Q?ZspRLQTOImqRAXVp0BE275KhloXhA9DHliUQ5BLN3UIbSptXPy8YnUYLEPUf?=
 =?us-ascii?Q?j9/5xg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8163c8b-8f34-4dcb-13f8-08d9e5b253d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2022 18:40:32.4439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CjLL6ncPByQggmk85OhVhw1kTtJaz9pYRJo7qfung+6fFyky5rOVG34en/npiHD8yygJuwXC5Q+wltGiSRhBSn4IHDTe7SXVboZ6CEhrHO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4720
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10245 signatures=673430
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=899 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202010104
X-Proofpoint-GUID: ZwMmy85S_tSkvcZ2Ztw4pWo-1v6fqrE9
X-Proofpoint-ORIG-GUID: ZwMmy85S_tSkvcZ2Ztw4pWo-1v6fqrE9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> That would be great. I had lab problems yesterday so I didn't get a
> chance to complete my usual run prior to pushing.

Boots fine for me with lpfc (and a0af3d1104f7).

-- 
Martin K. Petersen	Oracle Linux Engineering
