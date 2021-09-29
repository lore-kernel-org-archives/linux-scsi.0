Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609ADC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A27D6135D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:19:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244019AbhI2EVV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:21:21 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34604 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243949AbhI2EVO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:21:14 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T3DotU001981;
        Wed, 29 Sep 2021 04:19:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1suO/+QomK3sJm4xYon7Mp6/jwVkHe0hRng8F3XUZ3U=;
 b=zgSHbFhGaozmYxiMvG0M3/4qiy5dScz2Lxy4ugOW/5T7cN1XN9R1PQ1SCwKQb/W50QGr
 iS1O8HTC67x6q5xeCtPU8MIlXl7sQ9aNAPTfFwCOn3H4h5v+EPFLZM242kCV+oS2AQMg
 5WHHPzhwrZfdrwCAX6iWOSRP0wpRI/kcQHuwm2KwqgxFfjYl5uQWG0TsYHkmEHrZZyrZ
 vg0RVwxSQ724X63lMkPVImV6dddzOT4yWUI0G8bQ32PCuCtjFRZSxnjfsO9FXOFpiQnh
 54j/zIDXkxMhKscoWESwu18kBV2j5P2xB1qpoEaaMMoX+X85fmyBG8earptjhUX6XWQ3 DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bccc89588-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AU6m030852;
        Wed, 29 Sep 2021 04:19:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by userp3030.oracle.com with ESMTP id 3bc3bjb6s5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:19:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BcoDa4SotYCh99HVY4TQlpjggOJ1M5u+bYoB/HZzKtnyO3K/pZ15uo2tbxhakO+wNbXqydfcO+xymgf85XAgIMmwExKk9R/IJ8zkipeb2XrLV3TTSriReFPZbHLuYTVOWhGpG/4t7romokWGKC/aawfkMC36OYgFtFgVwBp2ynDNn5bKTMYryFjxXynK86qScErCIA4MHcGFnk10NbdwjDy59R612YlqcHCdiv1JshcA6JECIJhvH4CuQn2i3F0umvmayBmrcHJ7mpLnQ+44QSgfFSkl914QqEsRBRpl7HLrD4oGKrMQnrULO0apPBV61OKC4Yc00JvYWtCd8FbsqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=1suO/+QomK3sJm4xYon7Mp6/jwVkHe0hRng8F3XUZ3U=;
 b=ZH1idwEZwFZugUtCx4ec39LPDQjmv9DcsfI5YGf82aPV9BlgT7vVwA+++rFvp2GONHGGUS8CrLW05wH19o03FBWAWtQEZv9X4K0+Z9mUhTUIs9/Z2fjdZhRX5LomXxwwnMO5LYpbcogT5aWoXLScz29+ASTOfWyKKu0LvFIrfPymQvDVm+Cb/qufTNUK+ETEWeI6Z99WTNzOcfGFh66uB10OuT+noV5f+PpL1X+5pr7G2sHzvlGqpNjBFws0zWtfhHcXqAI4dvABIpeB8bxnoFNuUh1PVhDQBbwoRnVBXqPL29tsYtRqoQrOXTgTAIMFmiO0K+/ETiFpD8h0hjKzcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1suO/+QomK3sJm4xYon7Mp6/jwVkHe0hRng8F3XUZ3U=;
 b=dsCVvllMGkvAI5VQd1sK75r8NROBRhfXII/Bkw5b09k7aid3SsIBg6D6GtEmw9JgAdTEuUngBqdCZcjUaHFfyoLH4ynpT4cTQlcvQNMNjPw1BPoqeHb6t0M8DAqwcumZkkl7QSt37ezAZ1wy8wvU4d1xnW4yaMpZWUTcAmjZycw=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:19:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:19:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ses: Fix unsigned comparison with less than zero
Date:   Wed, 29 Sep 2021 00:19:18 -0400
Message-Id: <163288913991.10199.9724210873699988075.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1632477113-90378-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1632477113-90378-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8 via Frontend Transport; Wed, 29 Sep 2021 04:19:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb402ac4-9a2c-48d7-55cd-08d983005363
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4551B75F6512BD9E2E3932D48EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7+PVPcvft36UVtNrGnV6jTBBrRUuCFzJa5Lm+C/vDiUDjnNPqG7ENsayw9XZaULsSVD5SC/m4dpwFGR1VjehG1VRwmzHygWpnxCFpQ6LpI1gFlbEClfW0N7+WxlnWwmDPD8To+T04+tkZwtmW3rOX8ywo9YN+HtUe8zRQ3h3N4MeDpt0g7uAP1hH0aGFLEimOmq4mIh6t4qcAJuuoZIKimBFvOC8XUrQtsVbjuq7kXMZdHLbjL/v1eM5L1futIThCz1PNzbDkpFNJhYCWffgFwfXzkW8oyWxghuQWMsh6pxmIdno5BW8DG7Q7A1ZkNefoxw0yvpJlVfvSNOXomIJYOv2cPoG0wredFjGxtkWMAubyPJFkCftD95zAbGqeS+G1n22k86GZHiGd/siDAkaf0AarX3yX0TT1h0ZLpD4UJVvqedKYOz6nnLHfnB/ae9a3yFpvmVkxj9fAtZeQwXWEVD7TeFA87GfBJtd+T+QEsOfU3c/Xr8G8Rd7qviiyvkm53iMzRou0iF5YAT4AP20PikU4Zrep9JZroo1sytc4E8d8ERQCNjh1QsA3uib7s2UKe4alfTQxAtp+r4rQziEZfu3ifbzkIcOidortH0rcSI/4YIm/1yfcazoq/jKU8vFWZhqPF4sw51jVgDkMAnsoiGrlwvN22WGUEB+5nfRduwwB2MGUXFxLSaYyF45yM5dhhzMmPBYO6MNY0W9QpS6E+t7M6BCKrfDYNdGOPZbNIqcS/6lgGeAbFQRDQRmn1ywJakJ0nPsCXwMpok9ZIV8VfvWIpHNt6zjiGdkzyd3kqY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(6916009)(2906002)(26005)(508600001)(66556008)(66476007)(83380400001)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWM4RmxFb2ovNVlGNmJGUmhGeTN4dGw2UjZzZU8xbC9mdTN4bXZZVm1UOTJP?=
 =?utf-8?B?ZzcxUnlDRVRkZy9DakVTemk4a2hlOUlRS3ZKUVFQR2FFcjlJeUtlV1haSHpG?=
 =?utf-8?B?ZnVkZ1l2dXA5cnlHN25FTnpMRFZHR1UzQnBxRlphYmwybnFleEJGRVV1QVo1?=
 =?utf-8?B?MUJOMEVqcWdadGo2a1hWWEMxeStuNmUxalowNkZTNFpCVCs1dDRVallISmtL?=
 =?utf-8?B?d2xPR25aZDN3b3VDOWdKZzlsQmdTL3FFbmkvS25yVW8rSE91djBRRW55Z0tU?=
 =?utf-8?B?ZGtjSEozZWhnY052MXhNdW5CRm9Ta0JwTkMveXNUWGZkU28xN1l4NGl4UFFF?=
 =?utf-8?B?RHNabmhES1hnUEtwbm5jbFpncE5qd1NacDdXR2dtRjMxYVhPRXFyMHFBRWpk?=
 =?utf-8?B?VU5ZdmdsbnhjSVlJY2l2dmdjODcyUFI3bHZEdC9pSjZFdlc0Qkw0ZFFrbDRJ?=
 =?utf-8?B?a3lGVWQ1bng1NE1iTVlpenhGeEcxblYvUm5VZGQ2UXkwOTlvT1NzamN6Rnlo?=
 =?utf-8?B?cWY5N3Brc2J5YTg2TDZNYTA4c3lvVGtIRWFVT0p4SFU4a0hVSG5VWEdPQlpp?=
 =?utf-8?B?QVVwemhOTTB2SVNqdTB2QmRmRW40MXluSDRCODR6enMyTFhTMkVoQnZkL1NE?=
 =?utf-8?B?YjRPSjBJNThXdUFVY1VPcEZOQmtTWjAzWWxPRFdTenpUb1dqRHphejg0SFZQ?=
 =?utf-8?B?SUp6R3I4SHJkTHd6MTB6cTdaRGJLZGZOMjA3cmVtcTlmMVhPbmNzUy85MnA0?=
 =?utf-8?B?UjI1MmM0S2wwY1gxSUx3MlJJNWRpVnhYWStLSUMzam5EQ0IzYVVzNjFWaVl3?=
 =?utf-8?B?OXFvalptc2dMQVdaVWh6VjdXd1F5OVQvc09CM3pTNjdpZTFlTXNLWUNSdHVh?=
 =?utf-8?B?Znc5TDBnSGdaaGoxM0Z2ZjZjYjFMZnpGbjhyeitBS1RlTlhWWlVxMUF3cHlB?=
 =?utf-8?B?Q1lyb25vWUhHMVAxR3VFVnJsYXRLUUFicmNwSUszOTR3NzhFV24rdjJKMy9M?=
 =?utf-8?B?endQTk1jOWovUHhlNkxFNnY1S29iSW8ycVJWUHo2L3dSVFJZRzd4dWpHVVRr?=
 =?utf-8?B?WVRRa2VLSjkySXZXRVF6MUpQdVc0L3I5N3k5cEkwb2JOa0ExMTVrRU1GZU9p?=
 =?utf-8?B?d01HVmtQd1Vwai9TVlZjQ2UxSEprbDA2ZnN2WklqL0p5OExxUHk5ZG9BazA2?=
 =?utf-8?B?TXFFN3d3QWZ3blN3WmVkYTBjb0hKNEQxSS83ZThodkV0UUNoS3hvQmNZRUFN?=
 =?utf-8?B?Rm1rbzRlTER0aGtINktVdDBsL3RkTzJyVWN4V1I1WkwxeXNiZFZVSllSbVha?=
 =?utf-8?B?SU1oQXpsdzZNRFJ4M2lYeFgzWldndVo2dUlkazZQOVRpc0UwL1l1UC80Q1Qy?=
 =?utf-8?B?a1BwSm1najRhT2huWEMrdGM3TGFHQlNDOGdqOXU3TEIzUDExRmlKby8xbDVm?=
 =?utf-8?B?Tk43bFhhUzc2L2N6TnJOTHZpdXFCMFlSUlpkSVNUV29TTDRiRHVhZnE5VWRv?=
 =?utf-8?B?YVNDV0ovdzI4RjZWYWtleDVkd0ViMVBETXdHa0xITHE0LzlYQVNGMWhGQ0pC?=
 =?utf-8?B?ckt0SVBGZHJiNGJvSnVFVjY1cUdNdXdFYmtNZk53WWczOGllRE1WU1JBSjF5?=
 =?utf-8?B?MUdESFB5cTEwbjAvNDR1U2lqL1VvM21TSWZvQ25TOExBSW1LYnNQUUV5VUtV?=
 =?utf-8?B?cVlNSGtucUZHREg4blJ1Z0k2YkpzbDRKeHY1Z0dMbVp5NTV3TGMxQUJiWmFw?=
 =?utf-8?Q?xd1z6IHt5jw/oURf/QQz7m0Lm/MFkhxdlXVz8Zt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb402ac4-9a2c-48d7-55cd-08d983005363
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:19:27.3665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mluxM1Rm4qRTXXMIN9TgegVYvwRDrrRfaObOEXLJoXV7NiT423nyOS0gqCoQEjUFwJX4Df2HXWK/mW/60xAEhGn+Qz30NaesZkYVUL0RDgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-GUID: c2HmyHwsoOvAMENdlHOgIty6C-_GW8Eb
X-Proofpoint-ORIG-GUID: c2HmyHwsoOvAMENdlHOgIty6C-_GW8Eb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 24 Sep 2021 17:51:53 +0800, Jiapeng Chong wrote:

> Fix the following coccicheck warning:
> 
> ./drivers/scsi/ses.c:137:10-16: WARNING: Unsigned expression compared
> with zero: result > 0.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ses: Fix unsigned comparison with less than zero
      https://git.kernel.org/mkp/scsi/c/dd689ed5aa90

-- 
Martin K. Petersen	Oracle Linux Engineering
