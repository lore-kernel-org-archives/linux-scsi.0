Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01DCDC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD07C61040
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhG2DjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:39:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50124 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233654AbhG2Dik (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:38:40 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3aJvg005087;
        Thu, 29 Jul 2021 03:38:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=la8ln9UNDIm0fmeLJqV9XKz43eJFDpVCD5SC2wq6aY0=;
 b=CsfscY2lx2HTXGAg3y3jbymcvHI8DlsPEwpZfe4o46Tc+/j7DaXrc9VVi+ZmUPJme6Tl
 48hcsKrmYZ+eve2i4DMJWo32PRckd45usQEKAJR9jX5jRZ+Y/HxvCEYJlh/3JBUUmZql
 jUvjPW9o8HxdmGNA4TYM+PYK8u7WCW70TudUkC0rc0NBWYO8cR1O2WUV/9xzVfUNWtQ2
 6t5Y4F4oCdJnsPxLPJc9d/CuWxDzaNPufyl1YCifcqC/ZSwUvg6SBBkVhmvo0WOZCtvX
 UmjcTjVrxsdWsugTzRzgY2tDBIh6miQT/YVthNXbbmD9JNEyqdHmIr91lRxTJ6ei45dO RQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=la8ln9UNDIm0fmeLJqV9XKz43eJFDpVCD5SC2wq6aY0=;
 b=L/m5jxkuWE0Q/2aos6RfNv95qIhxf+9Z2shM6Nh39c5LrwoQbLGkIB1XESM2KjG5SF+3
 gRw/UllrXHBVzLMYAxFJdipr1UtcacQEmS0wi6CexlwBXl8FvrSoHE1V1IYOkA9LwYKI
 JOnm2i1aLh7L92TWEQXkSSLxMCEScUZ0e4rKcj0B1gnmgIWVR1gxK5IxuhM4DpLG9xyc
 /XqSATQ5JfrQLeIi2vKBYEcM7lPAYZBszUKAqxfeiiA5x3ZUrbgeYPuHW/NYOeThlKTz
 zbyTFt0cecTf3VQAy6qi7FEwTInkXaQzT1Mg69UvPluFYwSbrD/5z+Kc17IX4R37g9r+ IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2358e20r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3Uq59071135;
        Thu, 29 Jul 2021 03:38:33 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2047.outbound.protection.outlook.com [104.47.74.47])
        by userp3020.oracle.com with ESMTP id 3a23501xyq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YjbztfkGZacaaKxGjWqTgobmEsmhS8DfJM/jk/G2tVQZbg02Bj2PvbfHIyTEPRdPHiS6SWpD6CgwDoAkDD5veEj/lqD++dTE2LzviM5DY1pjHSkAPoF8GAzQVg/8zTmLg3ohP4bV0mA+jpj0SPBP2hMei23KxLwEc51DKvrgVvY0auUy/GeyXZGWq12ciyR79TeTkDXkVLgSQKWE+z1TUlo646HsuymH0ogAQvaNrZPTyDujmHPdK0DH/9OtNSQubVa/bfu2/AwQbzt6I2LpwZTvMb7lRBoOvWqHNSOmgTsxAAHEUn+KI0diufHS4+XzresI+w7Ag0E3ZefZumleTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=la8ln9UNDIm0fmeLJqV9XKz43eJFDpVCD5SC2wq6aY0=;
 b=evdEoqlTh7IbyjkGWS2+ba/VAsHjECPrWEZWULfsiSOIUWvLMyPV0oOPCMpTZRz6Nn9zEv5HCJgUvAleA7KnRQxb7cI94BT5NuHCjitaVOl2WIhnD1sDaJ1Feo9pAZSWm6Y2KZ6zfNsYTcnEdxzSLI1JrelI/uQIO+Lkb5GFIbfrOtaMZ3Uy5qfegUK3BmgA2TsYMXzXMdbWOPJyDovYQjHX8acmGBHr9ze+fsQH5rMR2IFQi+c6W+/Im+WCtiGivIVhmpF4CjyVKJD258rJdEN97rG6FshxHszcq8EeMCrASzdPkAn1K3RVXk8mL0JdrkYypmB/gWH5Uvnr/lMlBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=la8ln9UNDIm0fmeLJqV9XKz43eJFDpVCD5SC2wq6aY0=;
 b=G9W6MIxYk3RqvdnDAUOKpQMlNBek00aSQLgCd6b7+CH+LK6ojtj59BDltaTysnc8sbR0MxGjZhLKTlUqOTLByN65J0V5tuWNPls2xL6GNm6uDNDwV4Xu6Ve1PbYfxIarSHkvw6swh07BWSsUMlc9pRK2FMlxkqiqJ9vIdCH37l8=
Authentication-Results: linux.dev; dkim=none (message not signed)
 header.d=none;linux.dev; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:38:31 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:38:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Drop BLK_DEV_BSGLIB selection
Date:   Wed, 28 Jul 2021 23:38:22 -0400
Message-Id: <162752985698.3150.2222713451567339320.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210723084624.2596297-1-guoqing.jiang@linux.dev>
References: <20210723084624.2596297-1-guoqing.jiang@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:a03:332::12) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0067.namprd05.prod.outlook.com (2603:10b6:a03:332::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.11 via Frontend Transport; Thu, 29 Jul 2021 03:38:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5e02150-363f-4103-01d4-08d952425629
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1549381A394C58105A901ABF8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2hLBenTonX+kEL9BrRpcFU0NapyiA0Icie9llwVXxnRyz1gT9SVqqDxthg1C0C/ASa6EIjIayymglPSjgS0L7VSkxgnqw3H93F7KVgBJ3MNaz52VN3wkaB/DTMx5sXGV0MFKreTCJY8mUotD4KkryHrlM0es4N+4WBDlyM6P5Dv1VukiRXlQFmgnJyyt8LaZvNLFDVIceOqxhCmfxA2T36y7EEvizpJuoudDZPYrkYSC+B7J5rJqXVmjuFqQ1Fp5RZjEoy5o+ScXymWQ8Ogj3BKWnKF817XK4yFH7RQvc2+90jM6FtCzDlG7YCTnUnJd+v55VK4yxR0ViUyoBvfQxfeeRujC4cchyGE8VPnqje92VJ+031DD57zRicpUQKEtpJFwADLOyz4P9l+PtByLnWPUUEsALE6e1hUHEjh6mWoZIdW3PQ2iFErJfnbulzg121ZRtbb/RRpGT3nMx/i+PQEq5kmGPncYQYe9nK48Z3ZzUdLzIJ68kAgzWBIlPc/LK+KLlWutcuGrXt5JRs4UrULHUSorZwzguMREw9deG9C/1Ng1mBXDv74pGzk0IyIjYJD3BltZxHfm/s5JGSGLHNwLdW3k2yoacJq+NgNMneikZm9pcPEpmqQpy6INhzY7B+YQd+LrY81ChJFix/tqW5dPJH1CMnBsq885cUiKvnQZE/0a8LG6cg1ED+rG93uySPR1nyZX2Pn/sKJreArDW2AV8qfr+QucX2UIhYKLizQvM4RID9kDfeEVyVqhhgbhZUN15Z1km4RHn9oOgepyPTvSRu/uVG3xHQIdd+IcHN4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(2616005)(956004)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVN5ekY0a0ZQRVJKMmlKcmNmSm44dytpYUtrZURsTmRPS2NYc2RoeXp6THJ5?=
 =?utf-8?B?eUE2SGdqN0prOHZWbkIxeDJjY1pwZFRQOTB3WnFPK3BLUkhVUm9HanpBVG5D?=
 =?utf-8?B?Tm5lYStUcmFxek9pTHlYRzRLUEtMZnZuR0ZnWjdpYnBnVHA1WHJURTFaaU55?=
 =?utf-8?B?STRzREhrNzVLeFUwd0ZHZzJadERDclNlbjVnUHdsajNENkdDWTVDRHh3b3J5?=
 =?utf-8?B?Rjk2UVZVNGJ0VzJPTmhuZDdNRlpLWjlUZGdJdG9acVViaXNMY3FERForcm9J?=
 =?utf-8?B?a0RQWjZMLzdRMFhTcW9WSUx6dXRyREZBaTFxak1jR3hyMWlyVThBSWpyYnl1?=
 =?utf-8?B?bVM0b1loaTNtNzErTEZjRUtzV095eVZuSkVhcUdZL1FtKzRzUTZqZGZhYkFO?=
 =?utf-8?B?K1VOejdSWlp1T3E2RG4yczB4RWhZRzNOUDJHbk02V0s0SlZTVlBySDVYVWxw?=
 =?utf-8?B?SkZMV21VUEFrdUZ2L2tvVFQ1a0FFeU1janVtTlBMZXdyQVY0UnhZR3B1Zzhn?=
 =?utf-8?B?eHQvY1I1SURQYVhLUHdZSlpLdDBmeGJDK3FrQzRwNlVPUXFFZkJqandjSTRE?=
 =?utf-8?B?MGgrc3FpTkI0KysxV25pZm1KTFJ1cDhOa1lwTUZRTk1tWS9ZTXBMRmVkM1lR?=
 =?utf-8?B?SW5HTG93aWRHQU8vSVZIeHl1WDRqV216QzBTL2Y5eDVWb2RxQU1rOUxmZ0VJ?=
 =?utf-8?B?anBBdlJ5UDBTZmN6Zk1Mb0JjcXpEUjFZTE93K0p1MnhwRzJZYllKWmwyT2Y4?=
 =?utf-8?B?ZG5JVmNGSUNNdTBqLzY0SzVNeEpmQkY2SG03MW1oQkg2NzRwNTlvTFhuUzJB?=
 =?utf-8?B?YmJSYVhaOUp0c3dyTlM1R0ErQ241cGgyL3VhWG1qeGhFWm1NU2ZTdElIbk1N?=
 =?utf-8?B?SmtTWjRTUHNwWkMwczlndS9IVTJDNzdGRlBUQW1tSkxNWkxhci9zbm9na0tN?=
 =?utf-8?B?V1F0b1d5UjA3K29lNFI3Z0xJamVyUEh2TnMyZ0ZURjk2Rit0Q2NUQzcwWUdC?=
 =?utf-8?B?WDhEVEZaUUM2U2VUNGk2K29HUTArZXZualdZSGpIWDBTcXV0NDdzSHhocldW?=
 =?utf-8?B?ZWRaR3M1aEluT1dRZDFqaEFCOVNkRllhUDJLNCtNMTNWcW9HYXdNN29GVnc3?=
 =?utf-8?B?bGs0dHdYcDBiV3BOWUR4b2ttVGR2UnZRRU9POVBDbEhsdDVkdzZQaFg2eWM1?=
 =?utf-8?B?N3l6RHI2Qm83RVVNS3c4OVdkQVV1V2I1M0tySzZDb0hwUXZXeTVRUW1xbkFB?=
 =?utf-8?B?SW14Ty9PQm1lOUt4eXkyWG9vc1YzUjB1OUd2TWNTNlFYNXYwVllvTzNmdTRl?=
 =?utf-8?B?RkVTZFZUWUV0djFBZ2pjSVlxOVQrN3ZzMklIV3c4dDNSc0Z3NmpkTXk2SE0w?=
 =?utf-8?B?WDhUbXN1RjUveEhlUkVyR0ZtVnZtRkdSajRYSXp4bVhHSnN0b1g0OXdwWFpH?=
 =?utf-8?B?bmx3WWFyMlRWQ0VCZSszdmw0bkRLMzhIMlEzMXA5Sk5TMFdselNueFR5dzAv?=
 =?utf-8?B?NDFNT3kxUzVWNzgyU3FYMVROSzlSK2pBTEk5MEdROFZBTFJBUHVDVHJibmY2?=
 =?utf-8?B?UkVVN0pYT090d01xYk1qaWJDKzNiVWY5dlJEK3pjMVdmUC9jQXRHNTZsUDFR?=
 =?utf-8?B?SGZieU9uSG5pS01qOGZMWktrS3l2b0w0S24wZENUN1ZadVk5dlRLWUVncVpY?=
 =?utf-8?B?RkE0ckE5NlV4V082T2lMQThIZzlHZGt4RkE4WjRrRzM1OFprMldXL1I2UVE3?=
 =?utf-8?Q?8KThVqPku899LUg3s18kw6dP0nC7qBhfi/Qmo0F?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5e02150-363f-4103-01d4-08d952425629
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:38:31.8563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKc1PmeIigTwpVuL1KDc2KD/Kjb3gPyQ8cUpyPzSI8wxYeXyay2O49EirtxOu7hDVY8FGyDwJ2bidpPDPIhdXVLegGoWx22jiVgYhASWjQc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: 4AfFivrVkwSNpEjdUkhnqnMYtQkv4nOx
X-Proofpoint-ORIG-GUID: 4AfFivrVkwSNpEjdUkhnqnMYtQkv4nOx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 23 Jul 2021 16:46:24 +0800, Guoqing Jiang wrote:

> It can be dropped since SCSI_SAS_ATTRS already selects BLK_DEV_BSGLIB in
> drivers/scsi/Kconfig.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: libsas: Drop BLK_DEV_BSGLIB selection
      https://git.kernel.org/mkp/scsi/c/0525265e434b

-- 
Martin K. Petersen	Oracle Linux Engineering
