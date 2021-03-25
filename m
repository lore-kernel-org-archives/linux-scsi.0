Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00B8C433C1
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 01:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A091861A12
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 01:49:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235794AbhCYBsv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 21:48:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56408 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235751AbhCYBst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 21:48:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P1iAYW053716;
        Thu, 25 Mar 2021 01:48:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=AWKD6TWoZwX/5OcUsWniBeuMfEXLKAvbTn+q7Btb8f0=;
 b=mdRaUh0o96d/x0du6fmGmDO8dKf7QEDwqbwzK4AKGBfmMqW3B5xr2Iti9d193dd9Asd2
 seiit3Rq/j4yBoWEb1I2mD6JQCsE5AnDOYpKN57wcNcR1w19KSRHx5zY5+M0Cj+z25eX
 ciTnh8tzPX79FnFsfCDHkfGML18v0G4Ob1tOav4ewXVdf7AWQrdKW+TElLtv0+w3JfOe
 czX8lPBGDZVHB+uZhnddo7C0V/6K+AnIivmGV6y1z0PN6r1k+ypz/uFt3HQhT7JC00Q9
 VW3Ny56rRW0B2SJH3pLnQtzlbPGoPGZ0+y8MXKOe3gxOWNHW6dCUsg9SH3kd/7Mh6Pl8 XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37d9pn4p22-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:48:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P1iv4t019776;
        Thu, 25 Mar 2021 01:48:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by userp3030.oracle.com with ESMTP id 37du00k3vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 01:48:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K7R6kPHXqlTseQrMWLV9UCx9Xnhbgu/RsMBkHuvj66QkrERtKUSyBDAS/jfCi9D7Y0I23rLIzcg9qlKLoUOI+a16GgefDxVWG0CJdMMrepo6ZT+g1dL/3qO8rhdd/nm2YlBvFe8A70zf7kuQYK7Kcm/wRLwg78nU5saRRc0ZMDJYdlvCbUL7vEdrsbjZJ242doVVdH39pTYLk9jTAHSo1YbiFJMba1Il17Zohl6APwumBqcNd5jUWtvTwtE0PdvgHpwKYgBBZWo+KAuRKNay18mY+uA1ABsnCO1C/tqQ5z5oc1dIbBPQmS8b+pRC0ZYn/IrNqPhESRS5b72PfKbDgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWKD6TWoZwX/5OcUsWniBeuMfEXLKAvbTn+q7Btb8f0=;
 b=QzMNN4Fev6IkSoKL8/+MXIXM0MqbDnjAx/x3YA+iTkAIzxt8pxbCK7CNbP7We73a03zXBOF9a0c45jyTPzZWQvU5sn2fTLeFry8oFxjV6s2sghJI/jUAgLWW2pIW8V9k4IjVWcLZVZV8G2px8AUK2UlW/uiJQPYfTbMDKk3iYkZZe+pExGhNdT/1qGJ2R6kyClRzfU+HzyquQkIdiHIQ2LoH3AEEkf3aE/nAoRqX15IutiUfBZrcTUP6wHzInYz4rov3g5osMhYM4rTfYMRYOsarwanGwYEIf8+CUCl0GvF0r44uU6asZbI8sZ9su06ISzQj5sEnh3actrbxhT3VbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AWKD6TWoZwX/5OcUsWniBeuMfEXLKAvbTn+q7Btb8f0=;
 b=FyF5iZWaxz54QJOk4M6JxqZ7955Kg6GYXhmCXz9hlVKJhElkw3ugrgzRVAoV/np9f4XAPlCtsAMS+hUbvBev0C3Ucyw8qO90zT2ttIUAfBC/EMHHcwoOXdYVMpAaMMZngXuZ1+2aMmP6cylFs7/BWj4Ehsq7aeh++73r8FUuodY=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4712.namprd10.prod.outlook.com (2603:10b6:510:3f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Thu, 25 Mar
 2021 01:48:41 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 01:48:41 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/7] qla2xxx patches for kernel v5.12 and v5.13
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wntwknqh.fsf@ca-mkp.ca.oracle.com>
References: <20210320232359.941-1-bvanassche@acm.org>
Date:   Wed, 24 Mar 2021 21:48:37 -0400
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Sat, 20 Mar 2021 16:23:52 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:610:b0::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR03CA0027.namprd03.prod.outlook.com (2603:10b6:610:b0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Thu, 25 Mar 2021 01:48:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38a88af6-3440-46bd-e58f-08d8ef301e25
X-MS-TrafficTypeDiagnostic: PH0PR10MB4712:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47121BB775C6EF1060DCBB6B8E629@PH0PR10MB4712.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EkFpVoR+tKHP8Qu55Gv/kROm+ko102gHjc3AHWkHZbMuEeklbRp/sq0JsQbVT1AfyeQMaJ8XlJPGVflSNiwH/Y8QpyQQPHdgH3/UWHI9gZvM6pRmR5hNufgNI6JydJwPyhapAuKQLvFtgDirfTAHyuEVdrfMyF17JuvtUBjSCHFtoY2eZ3kAjCfO33OTvlwku1b6uLPwuJZ5kHCaUGSMdslpx8xEE+S0+qJgnjXggOd0wmWplDrGyCvhFm/9dgVKf3CY7EIgnW3O6uRyM/BUHsTiqWn1XmYir9y0HrHWXGlK6DtYL5UWAOMqBeI9tWYmbQy9QMbO0E+YuFoDPdMaRI7Inox4BfGpWppXZVCE69nRaKRID2yO9kaWQMn1MqFFD1YEivSOAjxtLV6MkCw+gtKjHvV8xkjexH+MuBmqdwNlmJpB96myhk22hNVaHWbPfFyc/DieukMWlMpWNm4bppUnu8XiHT2aQPE6whOAsdMX0USi1Q72+Al5x+/0HkYnuJLoqbS7Y99e/TH6AewNcB1zj0p50iuqjlYmq7FrYinsgadgpz1aiDCfUO3rdI1AEdTEdKXmf2tKTfvCiM6HRvLi010dqLKxg98Og8brZd7XlSyo1+SX+BPMuNTGyhL+ysOpuHIL3Jr9WbXAkdUOMbcZjRI/Mw7kOSdGcofpwM4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(396003)(366004)(376002)(55016002)(52116002)(66556008)(6666004)(956004)(66476007)(86362001)(66946007)(186003)(16526019)(26005)(2906002)(558084003)(36916002)(7696005)(38100700001)(54906003)(8936002)(6916009)(4326008)(478600001)(8676002)(316002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?03nZNskkae53GUzaPB0qK4FpYJ/347FIUNCRwKonvkqWd/UE8DuLJTHn+64b?=
 =?us-ascii?Q?c+2Z54AYWHqDgS2RElgnoq61Oo7ablqRQKy4kaQV7eHRqopChaps1CVA8yaF?=
 =?us-ascii?Q?5EFvrMp2ORMtusKaS1Yml3gp1wYsMPYkq3hVTRowIztTJ5hs/Y30KEKHzVd2?=
 =?us-ascii?Q?JfO6iWWhPyi17FC6kG5NEjRokPnk31XeWxzPAkvJhWNJJJIc0KdRRuhdAgEv?=
 =?us-ascii?Q?Ykt5tF2P0FPQ2o8mDccfD+GBwlJsFdWa9v+Pjs/C23uDMLaVnxte+D/BJOVO?=
 =?us-ascii?Q?zBBvoi+u7rT1AR2RCzaNgySth44WRxb6wbTCbMS8VLFZHQ9KYXazVli3bjHo?=
 =?us-ascii?Q?rAM2KsZj8/ug+umN3wv+fYXFEHP7xMLkp2F9uJISdhAp9Lb4fbakSYgav1Oj?=
 =?us-ascii?Q?iC+lbcEQCCe/cIblStK+befvNYmWXb5LRbfd8zANxolNPo4icoZ7HJhFUOOn?=
 =?us-ascii?Q?9MeR9eqRlHOI6oYMCKQKoH2SjUzmqgYxfvZqD6VDW/DW5prexcdufE6l1cU7?=
 =?us-ascii?Q?kxb8Pwrc64jH4ov9NfSwHJ9v8g3ggp9hGy1/fgBCo3+jF677iLB2iv5/YWPX?=
 =?us-ascii?Q?YloSprOCr+bI/21m9sge8wdPbEaMv7DDtuNCyUuBpNJnWv3D04ihemo5cHmz?=
 =?us-ascii?Q?QJSdDqu39NK6cBzOM3bCRRAOivb1Dv8FF0PHu2E+Pu/xn3YsIkrpUWCj2AC3?=
 =?us-ascii?Q?3hSsFrk61j7lppm57ekV2bMDVCobNxasiPPKZwriEWUvBX23FX6+Fjci5OcW?=
 =?us-ascii?Q?C5Y5iTb0Dpm0UNezFqrElEkB7U9MOa96sjmZgYm/Ogid4xCTFhtSY2tm6W4M?=
 =?us-ascii?Q?g4sm9XTZAvlqj7IWqN8mYhFaW7qEF/12wV0c70sxWUjXy1hoWnqE83Dv+3CS?=
 =?us-ascii?Q?p6U06zzSDdFp8GdTa5xRFN5bxOBcYv+aEk5i8bnFpEEKsV7XT8E/LZK+bWUo?=
 =?us-ascii?Q?NvBtPi83JitNRm+9tjboqOiDH2JD8Vad/A5qIAnRT7bioqh4D5v693JEGy6r?=
 =?us-ascii?Q?QT57xbIOOnBpUtDmqIpdlurj93Qz+rMa9L6v32YJVIQMJ1aigX3SYYi4VpIu?=
 =?us-ascii?Q?2PmblZCnfSYlnj/MQopbvwX4IC96ULRfO3xip4Vl7EVTPV+YTLd9VbzNlZ2c?=
 =?us-ascii?Q?68XFzHm+THiwDIySY+tGgseVdAo5gEik+/PihBpIq/Rt7TRaVfN+xqaT4Blk?=
 =?us-ascii?Q?N4mZiiRJbtp9gDIjVaGanbR67YEmNmqMkpArFWWOjBj3sbiCVk/lI4LUD4Yi?=
 =?us-ascii?Q?R0AQFIgECzD9HO4QnGRTpvGYfpBovzsgY5yQx/IkKZgD5rOC662epE2jhC8s?=
 =?us-ascii?Q?vTMpFNrrwvHrQMuHorETTbkr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38a88af6-3440-46bd-e58f-08d8ef301e25
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 01:48:41.8045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gsPeYZKJqjtkui8fecY5za3Vx4lVRfBb1E2pkCYnefK+3kSut2N1V88IoutXoRIcQUnCfsWTgFTesmGvQaQkSKJuoo9sc8+xy66bWuT7p0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4712
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250010
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250010
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> Please consider the first patch in this series for kernel v5.12 and
> the remaining patches for kernel v5.13.

Applied patches 2 through 7 to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
