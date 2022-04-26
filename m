Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA4AC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 02:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbiDZCa3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbiDZCa1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 22:30:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7930113C8A
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 19:27:21 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PKtQoD022277;
        Tue, 26 Apr 2022 02:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=6Grt/sgTWGz+nxBn3X+tgorX1HdZDUxgzLfWonCDNtI=;
 b=zH73pV90fEqz0uK4Eubg1/TmpSiLxD/C86uY7MYwl49lUFDY55pYuMP5lTB4DecJ0eXR
 dmGgGc8xBWyGGRQscnU71pD0f6oypR5IoYqwwDhRmN9kJkbE/RrSC3jmeoD8cc8Kohdz
 xiJjOm6HcpZbpqeGnjFOJPZ20n+4pF2g94w8KlWYso5EPFrPoDgDs70P/yg9LF2IiN0T
 Nmj96A+I+9CKSE2BucFd5g5srv1KC5uTtENypJekSpgXVrcy7bx1ddrmZQckyXcg1t5H
 gLJ8TrgkCw50r4N/TpBMRWy/kyFeboR4I+IyITxl7Kc9M4OC6dkCvuicXLzrbdl1uuvD Xw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4cwbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:26:56 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q2A1lX013702;
        Tue, 26 Apr 2022 02:26:55 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w2xxps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:26:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fugV9U3MOG51t49ASeBtK/QbrzhckKonj/XwgRGH45q3iJAver3R+WBl8z/n4cmrq8nWdrucQu7EiMQCMsOXJUa9rXkxHOtjY+GB9mM6LevJZVI/CtjpDczmO4JJlKjaJyICqominOdJK7hwJ88G8tuHlOTGSsphhw9e1VCCEl1QIata0/ahPI7MTRHZSZv49L0M9KO6JYmM41DQcA+dp7+MwvKIHjdPv822a3IynAHUCFkYFVIUWCbZvOyMNUJCtjfDpQmDNRwaMY9a3NWzDYBrLElv6lQjqoRp9YUBxgctiRQw8f6l4Lt27nygZwXhWQ6FJ7/SmYEhee+dq58v6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Grt/sgTWGz+nxBn3X+tgorX1HdZDUxgzLfWonCDNtI=;
 b=QspC+WkeX4etX01Y6H9LYXRxbeKtnik7G5usI7xIHA2PNqCW/Z4sQdvdT7Lg3S70OxNMC08na8YLx/ooyv6WyLEhomRTSqrJie1/bAoZHRPYgn2XXC+rBr6rlbCkNqb2BIpGwQFe4afAeOnZYq+EzFaqECyvCB0LwEYfC4SugGivJoyn1wCTOiu9gP8V1LhzqSzUJIyyeOxk93npn2Y1YF0uXC1S3v9bjzHq/95cgrPYSUqdVHVShqgwsYtb6/LrFvISYu25E19hZqwKDp1vr9179+ZuioGZ5KEHl54XokqMyYmiy7iyItagFDurREvM/MmtKOM76Y6DWfMp9Yo/AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Grt/sgTWGz+nxBn3X+tgorX1HdZDUxgzLfWonCDNtI=;
 b=REauJpEl31CWjRX5qw0J/H32pJk35lUpLI+rrIPRxHny2/le6opBSZtIpLW5tbjeg9DxT2FiWLYoDj4iL+Fqxp9KMYrHtnumGxrS5LdxEBhlgheqo107lk5NuyXa4aCwLLAeW9PQZ/dQ4yp/r5bu3gzNmO4vtFmq07dweMasCVM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN6PR10MB2035.namprd10.prod.outlook.com (2603:10b6:404:103::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Tue, 26 Apr
 2022 02:26:54 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 02:26:53 +0000
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/2] qla2xxx: Remove free_sg command flag
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17d7cy3z3.fsf@ca-mkp.ca.oracle.com>
References: <AS8PR10MB4952747D20B76DC8FE793CCA9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
Date:   Mon, 25 Apr 2022 22:26:51 -0400
In-Reply-To: <AS8PR10MB4952747D20B76DC8FE793CCA9DEE9@AS8PR10MB4952.EURPRD10.PROD.OUTLOOK.COM>
        (Chesnokov Gleb's message of "Fri, 15 Apr 2022 12:42:24 +0000")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0117.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25255416-7631-45ad-149d-08da272c3a5d
X-MS-TrafficTypeDiagnostic: BN6PR10MB2035:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB20355BB10336AD92F6887C0A8EFB9@BN6PR10MB2035.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MBdWBT4hf1mUB8lbppkw+xjUo/S71++oyppmQg6Bk5jutTzfrZwExzlMs41htdH26Zxy2+bocsyGCAjL0E7bexvvQkqucO0/oj5wMuQ6TBuj7AUL5InYycAHm6i4w5+BZNxBNAWQOOW1F/73lvEvdIACDnbnBmWmj5m4C900oblAArGIWnCdmQNRYg95/YPMzLOG4fHdqnOQx3J0OLOW6cJ1LOuL9Eu8imWOsHcUNB1U39KGpCRLii3UXVfSpfnHbmAC9CqCFbXpzhfmSFhAzrXSw0EmWwfjXlTk1RH0f6zEOwV0Lf9d6anXZfzUhICox5c9t3o9gPqFEtJhpxOAfQvAU1p+5+nggzM1+wl4ETix0xv54gzJ4vsZKGsh9Vg2qJmPylG9cbII0z5H3laCRtgEvJESg+oDNQtHiUuolwI4dD8S385rs9e7ym7d+PXYVVKX4GPvHEBxH5io6NHj+ZK17kHJDzW7GNNlO7nez9sRKANC/901FUqdHqVUSfH9EUzkvb3wrjoj0F0AKCUCAIwS/veDZE4xoL19v7sq5NfsNwK4oEqCtgsgnbEXF1cvbYR99kRn7ZmxYRzb/y3AWDldhrYqqBif43D3qVs5mYhCKvzGQ28dFZLDYoKk21HWgtQPawX33n9dJRd6ySZR5j3Ofh7Cv8xuHbvFOqHzpZV7oOC5tnywO3FwwKhaGGrdbpf4nf0NdPqXzBKnNG6kzw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(38350700002)(26005)(186003)(2906002)(6506007)(66946007)(66476007)(66556008)(8676002)(6486002)(8936002)(508600001)(4326008)(38100700002)(6512007)(558084003)(52116002)(6916009)(5660300002)(36916002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?omdNJYs/Y84rvabDNoEiX0b0m53xiStAmU0Zb/+2Qb7sbHyND352M55w8KBo?=
 =?us-ascii?Q?CPnV6NSkKioWEm3uS/KJsXr9RE65KMKDmbrtLD18pgw1kkUeeJ4aIQqmUL3p?=
 =?us-ascii?Q?/lfM9w7dsEqQiQDahe5t47iWErGW8ZtxaowLT7Zk2/vxsK6g7JW5jFTBOtlP?=
 =?us-ascii?Q?Vg2/oUSf3As1B5OFe7Ao0XS/bjaOvyDy4NloC26CU+w915LI5mbfrr3ABCV/?=
 =?us-ascii?Q?Bp0rpiSHs2a/e6Sx4peI4KYiHEtAveSX0CFd4kGwUOWkIzVA//8uUTTx28fd?=
 =?us-ascii?Q?ny036qGLlpn90FXXnSsg3aDx20ZaUdpyeM6Wg4cZWo3aAOqooNPeFPzdnX4k?=
 =?us-ascii?Q?VZ74BD2WcPbQB7xPbhxIbPkJft2MwzFjjwATrmTwt5PHLNljUepqGSp+Px1N?=
 =?us-ascii?Q?o/AKDbH0lA8vbSsNATpoT8RiIWzT5Lq/6WvPv1D1+/GH/16GH6xzuoHWW4aj?=
 =?us-ascii?Q?1sAu23DZAPhSov1Ndn47CXlevbsFgu95a0JYdF+DePHEZd5WcLrs+kMik5gE?=
 =?us-ascii?Q?URDJeqliGbQ6jw2XoUvJdiBdrJ5wX/GFUCcHDUxkAzlzKbkqnCLdc0P5sDqY?=
 =?us-ascii?Q?v/pgyirR2FMNJR3+rR8cFlUC8FAx7ZnWfqEeM8L9SVaKXoS5FLdboKZlkUDy?=
 =?us-ascii?Q?ZVQRDtUFQ/KD2ZVdOpBIQeqizykxYhymjCjKsnpfUGS+Qh+RQ1MUAstnQMa2?=
 =?us-ascii?Q?ZyZghlps1KDOmRa1v42Vxgrwxsx+NTmWmE0jRzss1BVBXRqvu8O5LSZIEzMK?=
 =?us-ascii?Q?tOLyJl7fHoS2+hTcIXsIV41D9WnidnjnqiCaDV3WoPivX27OC5m7y7a6AZ11?=
 =?us-ascii?Q?6iNR/kr4FVrG4XE9QCfGvAYnxrYAbcmBv6aPwPprD8YooM0jeZlS1R0jdqrX?=
 =?us-ascii?Q?Neq6o+MybGqx9OCvMNP08eRW4oBfPsjEo1kb2aX5zwhmEap1cN2N1wIk4U4G?=
 =?us-ascii?Q?B2/bxjPw93MHqYEQzVIFLil0yLLDpWcA3ZeuGvDBZXZoxV+NdBeEboUBoJIy?=
 =?us-ascii?Q?A5a7U54HD9/LbwA76kJn43qm5285zLPm/tE4M3wxFezuHWW2KneTrfwsPwOz?=
 =?us-ascii?Q?e0PIgqrqglyXrFyR204P6/KR/YoWWV3E/BRWz+bXvkOzMGEDfg5k9ndc0VJA?=
 =?us-ascii?Q?/J4h4LC++jw7amGKmzIe3K6cOYhKRTB/Lyhfe4IT1etgoZPV7BQkE3RC9z1f?=
 =?us-ascii?Q?BbXjjUWFD3C/OB3GvrxmkiD++H3nFtQ+XUpESdWHjks+SheBaZs1kcvzqMsu?=
 =?us-ascii?Q?BrnQfbZFRdidrnxdODlWyqE+FcuTXHOs7DNETL8T1cmkJwV+prFFoCpItVDp?=
 =?us-ascii?Q?QV+UB9SL7zvGlCAaCeSodvgFlyvBg5CB/z9YVyWQby2gm/RndiAMyLnb+Y/6?=
 =?us-ascii?Q?DQTWvlctoB+9gPvXxKwJl2E2nBDF7MpUJME9R1yQoX9T+S+ylz42/ioDfdKP?=
 =?us-ascii?Q?Q0/Jowswm9aMgtkHY2x6mCVN1oQqUeiHkYstC9BMVJQjSBSK52EizY9H8ALy?=
 =?us-ascii?Q?tWGeZGOdIDWHjSk9jlWApVpo10IpFXFtvLOhfGFVKZJcQvizE3sYr8jhwGu1?=
 =?us-ascii?Q?XACPIJQG+OVWwqUBrH1NpbHGgb0HtwQXPTGN5P72meJDj581FjrysEpV0g4W?=
 =?us-ascii?Q?s/ob+Cus7LDDOWjS1pQKaQ2xlqg+fU0kr7+r2T7yZUgxu0vey8N2HCWdmLhi?=
 =?us-ascii?Q?JP5Di+KR8jZw1CFtR6FDYJWmRKeD6i1DiI5ZNBPNiCPSOplpPXkXNUJ4RZev?=
 =?us-ascii?Q?U+Ewh29yE86TjqVWUOUEdzkalRQAVAY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25255416-7631-45ad-149d-08da272c3a5d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 02:26:53.8989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xe0Dfrjun3cyP1QG/QSG9hfjvQ7LD0dfUXRUQ6kxSi+7uXSwuroE7mbu9PbDKc3Y7sHqvO3paj4TFUafkP/XYRKSGaVWVamob/jcjwafl2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB2035
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-25_08:2022-04-25,2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=973
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260013
X-Proofpoint-GUID: HxDgjhuQAhX3e7fmJrRgBGRGhK5khEyx
X-Proofpoint-ORIG-GUID: HxDgjhuQAhX3e7fmJrRgBGRGhK5khEyx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> The use of the free_sg command flag was dropped in 2c39b5ca2a8c
> ("qla2xxx: Remove SRR code"). Hence remove this flag and its check.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
