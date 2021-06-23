Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EFB3C2B9F4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:13:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4A361002
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 01:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhFWBPo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 21:15:44 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:12572 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhFWBPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 21:15:43 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N17mQx004765;
        Wed, 23 Jun 2021 01:13:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2020-01-29;
 bh=sX7kiSODfV0/UKfEzW+yBMzL/05CB1qgoiFEmJ+q7DA=;
 b=ZyWd75+82gLLXemvfzA5Nbfi9RSaPIbdATp6RVp1k4UHFpExKsLn5r7sNeJXTqC3xDuH
 ZqnED4eqLsl/SBwwc5O/ZfI3F+bSo4bjcTQpUzZkN5SyLWPV8/cGThrk+zR91X81z6bw
 Av1G7qM5SEvpf78RyvtLhnOyQ2ZnKRlKVSrpB1974WZJAd61d8mh1GDSh88T8AaMl873
 2COf7edPRqge+Lw3Zeu0IbghXkgEnnZQUHFmTCtvQNWHAerWQSoFH9DzgTcpKysoLP3z
 hmZm+uxqHKq/UIEgbR5IEpAxjNHdRmqDtSdfh7yO0TZK6UXlxDwOaQA38idTDvZWq4ae Yw== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39ap66mnfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:13:25 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15N1ASMk179187;
        Wed, 23 Jun 2021 01:13:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 399tbtn82n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 01:13:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQDfu3hybkmjx7Nu0/dM6VpL6rnTs62zuNdykLJOqk7Fuo0bU8klymfB/EJnOShx1Kleb9pNMJAf67Q1ihQ8/hPqpA/h2ti77lvZ4noXc5MFdXj9UK8qbWzYbgJej8RmiTGprDrFW+3zMHczv1zB7a8MQVLu9Wy7JR4M3DratJYKPEZvGhuPD0/NY6ojLoN+DHiLxCPzP7posWoIRt6MpFLFdQn4XE8gm5qbeWyBJMskUq7IDUCquvDUaEmOtgxpNrmDXxc7/m5j+Qg3lBmUp7MSm+DEfU1s0aZNX8f9SmCUieX1AXE65fZvUeX0fQS3zWsW08gbibrXxLdMZleErQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX7kiSODfV0/UKfEzW+yBMzL/05CB1qgoiFEmJ+q7DA=;
 b=CF5+y7MQiFBzXB7M2g0r2wZ28Z5PoumlmJgMYWW6+izdLBl+R5a/AcYVWNvYdenC5HV19CJoPL8SnZWfHdxzme3yZJO5bHdoiAPohZ2B5Vm2mxFHPDX27rrZeCI+EYMxiIJacMFKQDRlOYEb6ckhXfqIsDV2xNX1FS9+6v56PUMO5yzssjFgPHMKwk1tO89QooPsT1T4LPpFzJMt3zDjjE9MwZhWU7uSxeUT3Jlhfl3pZ0mT8ucI5/ETBOQOUOUixaym85R+CB+HRBi8/gRm2kY0TzuvpnEJoCrlumi1vll2r41FXEMs/QJjS9MHpy4XQ8a0yCInNuw6P+wooBbqpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sX7kiSODfV0/UKfEzW+yBMzL/05CB1qgoiFEmJ+q7DA=;
 b=StgSlRBTKz4zv6YVA4sLd/9t0LtlLlDCthd/UE2hNIvoWJ6x+s5gs0DIeYmgXrvWiDT8M+gnQUIc1NzSYZiHweUh8GmReEAT2qgD+Jf+L8zS5233CSjdy1DF+op4DsEcBDiBXAqjkIe2rkefZXfM3zARoftPxXheWcYPplk9Dio=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Wed, 23 Jun
 2021 01:13:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.024; Wed, 23 Jun 2021
 01:13:22 +0000
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, ram.vegesna@broadcom.com,
        dan.carpenter@oracle.com, James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] elx: efct: fix vport list linkage in lio backend
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20210619155729.20049-1-jsmart2021@gmail.com> (James Smart's
        message of "Sat, 19 Jun 2021 08:57:29 -0700")
Organization: Oracle Corporation
Message-ID: <yq14kdptmeh.fsf@ca-mkp.ca.oracle.com>
References: <20210619155729.20049-1-jsmart2021@gmail.com>
Date:   Tue, 22 Jun 2021 21:13:20 -0400
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0316.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0316.namprd03.prod.outlook.com (2603:10b6:a03:39d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 23 Jun 2021 01:13:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff4381fb-d59e-473a-ec18-08d935e41820
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677FDF2339E23E92201F48B8E089@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9LEpK3ikh7YpDtj+4ihDhqQz0GDiJJ+5HMGtS6ZI/a5q5rbu8OMgNRZKR8qtGd1kcOdaj8dxi5yt9F+CZTEYYyIUKLwU7oI8407U8F5onmFliWSHTTjHuyaiBoslmKDpe0cZNxrnMqPX2uZcxm8AnYtfSAdH3WChyqHh7CLWi5I305+pfBA8M0eieBQBUvdnQfIaOZ4zmWZnzLCOAaYBHghDW+cPBhWj2MUjiTi4Q+FZNAL+b5SSVoHnwxN2FUVR2gXrbHGh7rS50LRd9yqBLeX1DS+hHDH1hT8SwVPOOKQeStTzkSjPW6740GMMkQ9o7CKD4I5QA96aZPzjls5IB5Von10OIebZiwghveLVEgE4rJN76qJbn/Q3rqDcf8RPg9kjjgtutF9ctdvVt0K7dYaOtsaVAZpgZwfLupXKmjdU5EDkIEb/dumHo4x6VAoDADsgs8PiKHUiYi00Q+Ur/Cuxi4EFNJ9Wmu4lJmf57jmnRwCt0fWU/ss8xtvETgCULVtJtGM2JHAalkazN64HjfUyC7yKcywVyyZB2H/i+lem58ynC/dwP0fdRA7ySClllIlfajkn7cJZP2tB0k1RAfEuAVeayhTBMly+NEPlxuCPZlLZHWV12+H31OZRBTDDmdyAN/jDSexJ9VrCGDx57umv+LtTXVAe+CjuNvzZU9U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39860400002)(376002)(136003)(956004)(558084003)(38100700002)(38350700002)(86362001)(2906002)(5660300002)(6916009)(66476007)(8936002)(55016002)(4326008)(7696005)(52116002)(83380400001)(66946007)(316002)(478600001)(16526019)(26005)(186003)(36916002)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ghtv9vO6WnPfELhRpuemLQVQ36BbXZplXZvc9VM/LuzI4CFUsqgV4E98CZvH?=
 =?us-ascii?Q?FjBFl4rEwxjbjvHqUx0T5lY6Jqp7ynNMtBzuUo4ZDBJBEVlTC8nXxEaavrdR?=
 =?us-ascii?Q?LG0a2tTWGDWlR3gPgLnOFpcViwCnT6JvWrK468hyxyqdxotpiqbac+ZfoVft?=
 =?us-ascii?Q?jIuxqKkWmH2+6c4wT9YoZaM8qtL5I0ruxH0B4ysO4f1RuaqSfO6VEvZ/UTpn?=
 =?us-ascii?Q?kau9LJvikEg1GbVLG9wj/spFWd6vZz1hF7cE6TnkPUYbYsWPcRdk1/EP5rGW?=
 =?us-ascii?Q?9CO5tjYsD5Sv8PNCbZEYegGx6aWh8NSZrqs01meU+d9RaPRUr7spBcXG1Qfr?=
 =?us-ascii?Q?Pw0rLZ4HvoMXaxyiiFZH3Tlr4gFIjOf17Yn8VWwtwdJTK02/mzJEk085LWvs?=
 =?us-ascii?Q?9bGlCrTcc5yntu0x4iiMBrVZ00a/DdsqLh9bPD0D2c4KjLkZqydORgp+pf1k?=
 =?us-ascii?Q?dpp1/GdQwfxFYatyUbwM/rUbU67esvA/1bZOZrim0scqp/3qUJxMwFilcqck?=
 =?us-ascii?Q?Ewu1zRZl94bqdAcu1cAs2R491mBaCxmbYm6bNGpmT08zoGhU5K0PyNSYycEt?=
 =?us-ascii?Q?Ty6olGVOdDcY22wgsy1xQaAGLkWcVR18gVasUMtH1GPFTRKIJxFABLID7orb?=
 =?us-ascii?Q?08bDa1IeqtNuyotGf42PifaJih+4BI4zum0/71i+9Vs0AL+cUXKuFw97UAlA?=
 =?us-ascii?Q?c9MsKOjlotf+2TV/s2quY/+5xoE3Xp/WlnxLx3c5Hg4YL4dYUeYrd3zmg8B2?=
 =?us-ascii?Q?Rqi0QDygS1Bou5Ib4u1u3ee0SFjnCQAHT/qnWRIv2/JD1wmVTLYdmb97cefM?=
 =?us-ascii?Q?wa79M7sUrhXDsURw8MxBvnFQf2vV5M9XGAJ9dAysOnPMmQlk2rb+f+sT1ib2?=
 =?us-ascii?Q?MsNnzipLx/eC1JurbJ2RTz75d0oa5CDKbbR25fzBNVcvEQvy7M/TzYMlcKbC?=
 =?us-ascii?Q?5B6QxyY/XZjiFQj1NdBM/KMI8t4iekBRm2pdYRldqri2e5piceFbK2PmlEy2?=
 =?us-ascii?Q?8IGfmQ4R7rca1D9Toi6wiL8FWswA+NCIPg5wcAWS1BKbzgOq2UEKx/i2uG58?=
 =?us-ascii?Q?bMvXQpi1swxTvSL+r6LNNb1iTQ/iWQh+UPT/5cKW9shXGHKyUq60fNnPyCMb?=
 =?us-ascii?Q?jSFgcHPIwok8fzI1mE4jCXhUFNYkwOaX25RI5ynTHp3iAL8mDk66XQRhdgF6?=
 =?us-ascii?Q?hDPaUjyj5hF2y2tXlKUuMx9EHFpOdSLaTkEO1Ozd1KmZcM4BltbctjN5fQGN?=
 =?us-ascii?Q?GhB0MLW6nDCqwU0AOVk2UBiCqDkt7ZQkb1Drz6dPsmFaIjP3evZb6pjrm1AD?=
 =?us-ascii?Q?3P1pH2wA+ZXA7MQfnSAjv0gZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff4381fb-d59e-473a-ec18-08d935e41820
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 01:13:22.4038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ForQER9+ZP1dSPl4Vpw47tEP4zLW/UZuZtkY8bXrbuxGlF6g+sEUHm24N3GB04iw8ehnlB1U2BqFoCwvWVaSsTSSlPchxs4WxZJMvA7S0x8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10023 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106230003
X-Proofpoint-ORIG-GUID: wpTtCbRUyEJDT_GN4KkcQL1gJhh_g_uj
X-Proofpoint-GUID: wpTtCbRUyEJDT_GN4KkcQL1gJhh_g_uj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> vport is linked onto the drivers vport list at allocation, but
> failure path fails to removed from the list.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
