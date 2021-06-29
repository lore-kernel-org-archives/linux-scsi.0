Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9BCC11F68
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F199461D63
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhF2ENL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53406 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232006AbhF2ENE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:13:04 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T47KLt021979;
        Tue, 29 Jun 2021 04:10:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xJeLdfY45+E9uhGVrgKrg2UqD1Pg/oVoJf99WJuXA3g=;
 b=aiAm/PaVujS2+dt8nM3AWElIrG7AbAuqJNKkZtga/z07nmrqjRR+YSEQcBiLq/YCoo9e
 IHl4Ra6+A7fvWd+GtfzlAdPsXkycgpUGMo1/HF6UFuh+t4Q+GjXZZfRHa9M7L5c7DNhJ
 fFcArwDx7t2v0xRyue2OfeqpqXaRi5xbOQK7TjMasIgeox1sJTNx/IXRAobS9HWiD7nb
 0WVSVaJQc4JaeVyNva6G2QcSYn7u0rhVY6pCOU2T0qHTeoEONxbJnAwrWYITEOSTms8u
 TtNkL60IOIt7sU/tyNliMUHbwBFTpz3N6AVyuyZtqDBvLXGITp0xaZCNJ3WpuZka6rV2 vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f1hcjsd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:33 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49rjV052345;
        Tue, 29 Jun 2021 04:10:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 39ee0tv4n0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBwsuKC2uoLwI8oHEcyDv9154h67BdCHPVvjvc3Eactb87WreidikIOntvvTdc8kqdhpWcsC4A+gphSq8cbv6UKei9VsVGOFxYkFHuz6nidRuZgXSLX2b/5BrIngpklyUNfHKw89f9auRGdYALx3JHMp0Ma4tf69XeYpgsBGfcRFcE5yRAjAzypv7wmZY5WrNIkGS2I8Rcm6NPdn6II1BxfZ42Sybn/ZGHvH3T1mbXCb6imt2uDgAX5zVWdQK8t/Q+BCmeoIpFaONqurHlNbkBQf71psWQqXtiOXfZL/3eXkjlE982i3zOJeVP8AjPyrKiGjXQmj1yG5Eg9VhAiHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJeLdfY45+E9uhGVrgKrg2UqD1Pg/oVoJf99WJuXA3g=;
 b=c4lqhwv40nU/GLZbaUqbpj+yPmaWUoaJsBLvVCo5N+baC1IL1zXFjEe1roF6WNSNOaQiHZ7yb6T5zHFn5/LhW8nYlgImCuDFp0EM2APJBT+McT9iAGHvNHoS1IYbgNlPqj3PQGBepsc25CvN6v76Wc1Nx6+fpTsf2tHAjJNVjuANUwkb8NMvXZPjAsoARM9SOLIogEQjsM8/Dn2hO2otpq93jy5GLtj1kiOSQeLy5Rh52nFs1GU8cFBGu+XfJbaynuUPrdvmyBvprfOhz22PFIIXAm3fFETqYY0I+EQTdyeJwB0dzmnshogY9LpobgoWz8+pZDNY2rR12UiBRyM/1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xJeLdfY45+E9uhGVrgKrg2UqD1Pg/oVoJf99WJuXA3g=;
 b=ZWq6JNOBe2ROh5PGR5MvfTEX0Dy6+3j5NyrmMwFefaJSPWMYi89fb0/WsV3BeQSXZg/1QDNEoH2iFDZOwXv9kVc2mrlZjbn++quZdfMSVrH/45FOpzjqRhNIEMEKDE3/NXzBlIjCVsg39KGJb/Gknsu1a9FetVSVxanRtjA2SrU=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 04:10:25 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:25 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     SeongJae Park <sj38.park@gmail.com>, skashyap@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, SeongJae Park <sjpark@amazon.de>,
        jhasan@marvell.com, linux-kernel@vger.kernel.org,
        himanshu.madhani@oracle.com
Subject: Re: [PATCH] scsi: bnx2fc: Remove meaningless 'bnx2fc_abts_cleanup()' return value assignment
Date:   Tue, 29 Jun 2021 00:10:11 -0400
Message-Id: <162493961196.16549.11333754782684730029.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210618164514.6299-1-sj38.park@gmail.com>
References: <20210618164514.6299-1-sj38.park@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7218e57d-af2b-4139-1c84-08d93ab3d272
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5417D1073672A963E0C10CB88E029@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:854;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fOy/fXApV58pyNOcxs3nLj5BYddWWGawL4OMrdBUFUvJaim+BOctw42wcclJar5qGeELet5iUiGwIdOHYeZu1k31cjyg6PbCCwMoSFMB3rLmuD1lY+e9QYl4H96CFQEkHxREkiJZsE8ClWeuHsngkg8h5+1OUioufxuapctZqWS/BH/SWI+qi9eMXNh00sDOb6ma9cJPbc8VAI/gHnm8/QvxJpuraIQgPT0tjIu6+Mnr1fX4ZhfBb8p0WBGklymb0RujHhNgf/VgvWm2vHvUXB+3wZ4O4Qmp/onxkBKTPM1MXuIpLt4WJ4m9p0qorfqP2AghejPtNzo97bTxSV50EsLIp6iJsQ0HcmPdVJE231T8FREXbb88fkqKS1WvC0xoyb5Z+8ITWScHc5xawnGsITWUzPNjmlhRUtpz8XDLxUFgi5Tj/dhv8yA1mCtD788cYPdMSxc/z05pUduY1ZJxEnz8H35oTKsPCXBDeSUzah9qEBC5aqDCzCbqUF+5y+Wpy3MSKkTdI9OgZcaDpX0HQ0zQxL+XleiHdUtmIFiSzJucaGgAgfqVFCjEJaMWZ1O1V4Va9SC3A/Xh/tL/j/iRKsQP4s4pU46M2IyyQkLQ0kZBS2AxaYmUapZIH5shHoObb4wu2hGoZzqp3BBhoDAC9R7EXT44Xku7dHyIjH+4SQ94x9UK9GhPiGaEeRmYkOnUeBrNhQ2q948LDgWDtCHmkjq5Tr6rxiDiRcMdDMNmZ7Hm1x7zSDp8+k0NGSt/69JQSPKAkzl4SZMmN10l6zggYh/lBznbjRTWA7vGlvu48N1Lm8zesdmt7HkCCKzFW0Oo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(966005)(103116003)(36756003)(478600001)(6486002)(83380400001)(7696005)(107886003)(8936002)(52116002)(8676002)(4744005)(66476007)(66556008)(316002)(66946007)(26005)(186003)(86362001)(16526019)(6666004)(956004)(38100700002)(2906002)(2616005)(38350700002)(54906003)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WVRXOUtFN1hmM1V1Y0EwbWpwSTVtaVlLT284N01PWmtERFZmS3dScW9YOHpL?=
 =?utf-8?B?SzFha0hqcmp4MVJOK2pqbFQzTUdnVHlrQ00wYWVoWDFidG5LS2VwR2hDVEJV?=
 =?utf-8?B?a01oUDV6UElDMS9KVXFvU3pKRE05K2RkZHQ4YzdWZWhwUHpYMVRHYXVZN3d6?=
 =?utf-8?B?QzlHOS9lQlowN3FSWTVzVk11LzkvdllUeDlSSnNMc1pud2tDYktUc3h4aDA3?=
 =?utf-8?B?cWlPYnNYV0haTFRpWUI2L2Vrb0gzYk43N21lME5yNVRFdXBEb0JzTzdBSTRR?=
 =?utf-8?B?S1E2am1abm12OWhRWFVmbFgzdGxnZ2pSRnVLTUJub29HSk1GR1grWEw2OUJW?=
 =?utf-8?B?T2k0SVlxLzdGYnFYUTl0bkUySURWcWhjQi9DRk0vZmZmOVBqY1JaZE1vM2tF?=
 =?utf-8?B?RGtMKy84MlFXYkw5MEpZYlpUcndMc3ZmQWJObUdxSEZ4NUV2ZXZ5WW91NkQ4?=
 =?utf-8?B?NVRpckE0cW1jK1pzcW5Ia2JJL2RkSUU0K3hLeWtEUVJTZlNWMGU4WTh4UFZG?=
 =?utf-8?B?NFlHeVhNbUxnSEswRkU4TjdGUlBkWGgyMGd5YlJUWjlJQTFiM2JmYUoyQitT?=
 =?utf-8?B?dTNUWThQb0tHcjFFRWIzc2U0VnduWEFseVNxSUIxMTFxRitBREIwcml1bUFL?=
 =?utf-8?B?R01oa2xWcWxESmYzOC8rcjYzZWxKQzNpbkxla2M1NDBkS0Q5alljSWdtK0U1?=
 =?utf-8?B?OFhsSUZVSExYQ3k4NEhVcW9xeGticXVHU0o2ZmdFWjZvSXZlR2lVTVhHNit1?=
 =?utf-8?B?K251UGcyRE1aUGtNekVicjA3K1J4YmtwOGFNNzdsQ0RUdCsyeWZvOUZGQXVt?=
 =?utf-8?B?SjlNSHF5eXNrSFJ1VFA5Z09qcE16ODhkbDhZTXdac3NlWW9NQWpMa3ZzZW9q?=
 =?utf-8?B?a1BlZlJvUENIS3g0aXNuaml4RndxbzdNbUpqR0tlWHFRMHRocHlxa2NxQ1Ji?=
 =?utf-8?B?MVpZeldFazd6QUorclFQeGlaOE1mcHpUeDlsNmJNN0VMUHl1cGk5c1JxbWFD?=
 =?utf-8?B?SWJremZlYUxjbEZRRjRKMXR2d3BMeXQzQ29welowelhyOWVsc0NFYWR6QllT?=
 =?utf-8?B?SUY5Wmp6Zm1TcUtSOTlncWwzOHQ2QktWN2dxaXhCQlNWRVdxUXMwNjFtZ1Nl?=
 =?utf-8?B?dEZmSVk2REFMRTNzVy9YUzNwSHFlb3VmcS9RMU91WTBoSHFIR1lWZkhHUGR6?=
 =?utf-8?B?TlpqOGFNNkt1cWx2R2hnS0ZTZS9TeXIwR0J4VlUzamoyM0syQlVhaVJKL0ZS?=
 =?utf-8?B?UjkyemVUUFZETkwxcC9FVGJNWFlGVW0rY1A4WFBkUVJxUWMyZlppK1ArYzJ1?=
 =?utf-8?B?OEI5UmZQclMrc2JuR1hveENtWkdPWkExTUNsaE9IR1FVVXZuak5FbFNmWWFu?=
 =?utf-8?B?a2pmZXFLc0FJQjRBR3dRMnlZRTRaZkRvL09kL3ZmUUNvWHJPbkkvVCtmZ3k0?=
 =?utf-8?B?YWl5V1NYampHT1FTZ25EMHVYOSsrNlVNYkRLb3poQUpHSE14djBEYmNqcHIr?=
 =?utf-8?B?cHJsWFRRQmt1QUpzdGc1Qjh4S2d3TjJRelVPMWVsNDBzdTlkZFlkSXg1MkhT?=
 =?utf-8?B?a2xYbml5SGJpS1VCREdqYS83cDJpRmNjN0F6dWlOU0Q3RGdPRDY1SzdsakZT?=
 =?utf-8?B?ZkxtKzdCWmtSdVd3WkhhWGJzZGRqOHNjSTlyWkI0WGZPQWNQK3ZWWmhab0hx?=
 =?utf-8?B?Nms1Wk54RVJDN0lSaUNyZzBsK0U3UHJFVHB4ZTJvTFdnc1kzaXUwRVJlQnNQ?=
 =?utf-8?Q?VRkfbaY7osv/Lnkq5Bkv92vlHjqbb/e0BtP1KrC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7218e57d-af2b-4139-1c84-08d93ab3d272
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:25.6286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wazqOMtXzHzpwH/PhLcrZ+oBloKPUD2DIJWo1271wUzQ9D6O8RQ0/QsauRS0gLROHZy1mPH+TcVYzMc1lxEHReaRJ8790LbDTSGCr/eeYGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-ORIG-GUID: npKxKJeS-0MpUjFYIoOhJNyFqKNZhNoI
X-Proofpoint-GUID: npKxKJeS-0MpUjFYIoOhJNyFqKNZhNoI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Jun 2021 16:45:14 +0000, SeongJae Park wrote:

> Commit 122c81c563b0 ("scsi: bnx2fc: Return failure if io_req is already
> in ABTS processing") made 'bnx2fc_eh_abort()' to return 'FAILED'
> when 'io_req' is alrady in ABTS processing, regardless of the return
> value of 'bnx2fc_abts_cleanup()'.  But, it left the assignment of the
> return value of 'bnx2fc_abts_cleanup()' to 'rc', which is meaningless
> now.  This commit removes it.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: bnx2fc: Remove meaningless 'bnx2fc_abts_cleanup()' return value assignment
      https://git.kernel.org/mkp/scsi/c/73b306a2bcb7

-- 
Martin K. Petersen	Oracle Linux Engineering
