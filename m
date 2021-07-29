Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DC5C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D26D60F01
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhG2Dh0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:37:26 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8674 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233485AbhG2DhY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:37:24 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3bHON009545;
        Thu, 29 Jul 2021 03:37:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=eQlYUbtuZ6fPhlKmOZlCj0MRLM3/4MDbHmuB1CkgFXI=;
 b=qp6/xtkzlPUd0JIsofc9oktxXfgMVpMfHj1qSCmd7fmORzM/Rx1z44Gid5jlclvlBgUt
 GmQZ0tkOJOlcQ3naRb5cTrdh3ibww2XZdFlhwhJyWskT9skSs4Fac93aWc/b0Ip0i7Vs
 tHf5dETv2orPrKMtGpcmsYRsIUH9YggriUaJxTGcyHQp6Yh2RNs0+LmwbLUEDWXJBMkB
 8wSh7rqgXMrIfM2Nbnba7htiXRUsBifkR2IkguAeScNDod5hUhSu5aI8P5doZDCbuI04
 VPBMzXDsRbz5hGYhYyisa1gq5IZ1sOVJJj1t3c5EbngWv8xBiAEB/owGVLaIGvfdirAk qQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eQlYUbtuZ6fPhlKmOZlCj0MRLM3/4MDbHmuB1CkgFXI=;
 b=lKjX3yKDdL2+YMsbOJv9S4v2/sRKBjeVdEs1CK9t8gSm+fxBQyPl6LJHKdPQQyVfeun/
 g9dI95kWN6t5RLFyE9c//OhKPFhLcfR21M2UMVKLO0bnXNIke1JXOuLob3LJETNUsiYB
 9KXOQhcIy3k5catgKeY/oKvFVT10LZQJ1pdBCgRJJOAQfmlUCz87WaQxGDtAFYUfreWF
 UvDGgf+uBI7sAB5G+ko3PSMtfJRFlzu3feerFopVVUe6Bl2dZ6xofQ4KpCcrJkp160Dh
 LS5WWEoKjj2udBKZ05GOHKgMsqykSdXowN7BM7k4MsReWOeQ9w13TST9y21jpfQjj2xS jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2jkfcbhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3V0lM035553;
        Thu, 29 Jul 2021 03:37:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by userp3030.oracle.com with ESMTP id 3a2356hmxt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7uqdiL0dkEnwOMrzIFJ2WeuedntwlGMvkpIhxgHZ/a7emQdHEMwP6vF9jN0kV3mtw049R3SCRNluD2SaHo+InwEd67trU/+dJoqwy7WuORV6Iy2/3zWgvcOJ4Wwo45qu4pA3go+4kG952+Rou8VYszHmQlbVc42LGW/AVLRQJLsPjyNEpsSEatKMXrT1et6Kc+Gy3/phFZuYZhwJE9DGZU8t/Nav6gcnH8Ao80w620+jxTVdG8s7/F7nTrkaC7iWNseanrDHb+6hgY0EkNAZgqn/UzcSqFR5a9Qj4DACO+3xDRsq7dqdgqbZziRjBEOpNAFMLSenO6htCcCKKfrPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQlYUbtuZ6fPhlKmOZlCj0MRLM3/4MDbHmuB1CkgFXI=;
 b=WzOKnKMmKzmC0wwnn4esMoA+lbSmPnApKWRmSux1a/I+8VTWSJWj/cQI2+wz1XnmAgGg+02gNJI4UaOGqoCaWukUJkdbCJdU4yaHdnrs59JTCxX7/yizjk8A35XobbUGW6Mp5FcR+5N2uKIFPVKoHFEceJbKhtDXzHViL+MCr2PjUcQf4BUhlMQ1Mnkl6BpzZmrnp/f0JqAykiubwYxX9ogrYjHKKLH98uGJjLu+Snc/iZzXynDRxze5BP2Bqoo8fuYuCBh30j0mu4YF01FqwIavNwAIy2YM7PTVVg+dOVDzipJEMWRNMwx6AIRIRecXxDZzD1+thB+2Bnl7yUiFQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQlYUbtuZ6fPhlKmOZlCj0MRLM3/4MDbHmuB1CkgFXI=;
 b=XnNmJ3aVsWDKIHKTO9nTYe8qb+gwsVgxBShdU9OlQAKRTOvcP+Ur2MRg+1zW7zvMUmZwVt3EoYQyFd0BIMlgHUn5hE+6U/N6LcGArl2efZ5m2vOURrrevuEi0XywxNxiq3vVIYhp9ipVoul1R7uD3dMakqZyjF+2rckAJOKwQqs=
Authentication-Results: cloud.ionos.com; dkim=none (message not signed)
 header.d=none;cloud.ionos.com; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:15 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Igor Pylypiv <ipylypiv@google.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>, linux-scsi@vger.kernel.org,
        Yu Zheng <yuuzheng@google.com>,
        Akshat Jain <akshatzen@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Fix tmf task completion race condition
Date:   Wed, 28 Jul 2021 23:37:03 -0400
Message-Id: <162752979291.3014.15260731489772834449.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210707185945.35559-1-ipylypiv@google.com>
References: <20210707185945.35559-1-ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2fe0b84-57e6-4e72-aa0a-08d9524228c9
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1549CB954C01818C2E4D8F0E8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1360;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MsdyO8EAwrDuMWHEKo+l1j+slVMD7pKK+yUQFQMq9d8HqVvyi2Ha8zYUHHFuam84O8N1DgLyIP7ProgQw8W7Ozs04rZC2X0c5tqbxCAZ+LF55uVriwlvohO8QmwB3jSi/wBnJH/2sOzBYjXfUifhJJaa0WhsGH80p7L344mAThv/hUXbA2TNLpj96AJVNudgo9AWfNSfWJEyx3OCpMlu1M63vQiDFnY6MUBAu8+GyKCcHPIiVYh9AoB+9gdI79avFxA+DEjv5PfGMJoU1tjdVebgHDedGxQsXd06g8126C6oNwGlXcRbYWltkZ83mrMkUSwIDEV55YNa4MCfHdZc8c8zvFAOFXSQIPd7z+w+303+YGqrtB1RrGmSCPZHw9gNYKU2Pr0omZIuJBR1LQ8ELdGj83WMwTU075Da7gjlgEP+b88zTiL1iQvgTQOd7gBKcl6xQlCWYN4dvbZq3WM5RlLAtxN+lMXBlo1qseY92RSbj8S3v0B7IDJSP5UdNoJe3E4EWpveX3S/3XqcZszkjYFCNDwQfsuZtGJ7rTy/tQJ5pbg7aCXGrNHdtsttbDMfJCgXkJqKeIKtlkoGTNL3wy0lFZAh61HYEItFMkKa25EFqVqLzBsB7UJwav0wMF/XJtU9+2yfk2iOpd+tiG9dYx2G49O5GiVVwcj4cHk7kHoj4TJnajtDHlShm2ATrvoHOKWiCqoY3wGKWusiwHHTomzrbXiJgaCPU1oJXZlvSIwDjYRfpceyNnlVXesK6L7nPzAymlsCFdk33ArbLrfihg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(2616005)(956004)(54906003)(86362001)(8936002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y05uTG54bk9lN2hEOVRZcWNwc2tpb0dCR3F6UDJ3a1NNLytuamlmeXBkTmQ3?=
 =?utf-8?B?MFhtYjEwV2ZUNVNxZDdzSDFBVHRmRzNzcDJmZ0t4SUZKdkt1VGZzWFVFUHBn?=
 =?utf-8?B?d0h0MW15a084bWsrMk4yR1BKNWFXWHdyVjE2VUxhMGxCbzM4dWNFZEVsOEtp?=
 =?utf-8?B?emppMjdNZlp4MFRQUzlzazZNNnZiWWZTRE5BUXUvb3RpbXVhRE4yWVAxSE1q?=
 =?utf-8?B?VUVDL1lCYjdzU2tGb2JUZ3RMMUtFRGlhQ0tJTnVUa1RhWERPSFBBVzk3QUxZ?=
 =?utf-8?B?aFR4TS9DRkFxTnJMdjV1THRtTTgrQXpZMWVBZkxhUlFmWFNNL0d4Z2xRa1BJ?=
 =?utf-8?B?TTBKQnRqOXlEeUZvS0g4V05adjFGWFk4eFFiM1M0c05pcEt2bmZhNkFpOUo0?=
 =?utf-8?B?RHFDV09xMjhJMnlCdFlaQldDejI5OXI2OXZIM2JucytLbUU2TXowZFU3Qnds?=
 =?utf-8?B?a0hkQW5IMncxb1JUMVlOSjRlb1dGUzdEbi96OXZVWUpHYXdRNDRuL3BTOVhH?=
 =?utf-8?B?S29tbWgyVENYZHpsYkIrTWYxOGltamluWXM0V0M5T3JnczRkSFVObElGQm9Y?=
 =?utf-8?B?WFVaWGVpczRjRXRoQ0F4L3pscjY0dUR1Z0VYSUpxRHBrM2tqbm1pMjlDVzhF?=
 =?utf-8?B?V3dmSUZVVGFWOFNsb2lDa2p6dmtZZXJqV0x6dm9CbXhDZmpBVjFoSWJHUVJF?=
 =?utf-8?B?R1ltWjZURFJyUDZrM2VuQkJmSjlJN1QyUG1GTFhCYWU2bmZIKy8xL1hScjdt?=
 =?utf-8?B?VWxRcGN1blBadGdKK01kQXpSY0MvS2UzZjFWaklGeWRYbTlFR1NZVTRhR3Nr?=
 =?utf-8?B?YWhyYk9pQkxUME5JTFVaM3N1Q1lMcFQySzZhVzE5QmZheTVQUjhwTjdlRW40?=
 =?utf-8?B?bVNrZ0NqMGdFNGhqY21EWHFxY2MrM2cwaE9vUFdsU21Hd0wzRjlYSlYzbFVa?=
 =?utf-8?B?bHg0ZjYwcHFxais0SFhqc21ZdUcwajNJUmRTYW1Qbm9aeVBKREVrZW94MDE1?=
 =?utf-8?B?TmNtMk9vbE5xYldRRmt3a1k1RTBiOHZwWVVYR1JONExtcTg1SDZQUHloajlI?=
 =?utf-8?B?eWRhVHVoRUtoOGlOK3F4RkloU0Q3SkJraUpXU0dXTU1ETjRmeVZEc1IzSE5G?=
 =?utf-8?B?Z2VpaWxTcExRQmQ2L3htSW1lZEpncHU2eVgremczYWplZmNxYThZck0yd3J5?=
 =?utf-8?B?SzVSbnBIbktSQWZMVngwd2RCWFRPQ2tpSFlOUFd6RWZiUkFWQmN1Z3duWUhy?=
 =?utf-8?B?L2Y5OVhMMm5OM1JKc1dRMzlXUkJNNEd1UUxXeVYrTmhCd0ErQzcxOEtFMzNt?=
 =?utf-8?B?NU9oU0kySC91eithQlNWSnd2VlVtTGJpZnE5YUxjaWNWd1ozT1ZoTzRjZ1Y5?=
 =?utf-8?B?Y2Jqbm1vUmozdndBTEFQb1ZpZWRGajRvWTNCNG84TzdadGNnNnZRd0dZeGxt?=
 =?utf-8?B?REg3eWNjMFUwbGdRWU41ajRheXlRR3pYRzBJMW41REdxRkJyTThVdGFUb2lD?=
 =?utf-8?B?b2NHdHVpSU8xNmFiVjNVcjJBb21heVhOSmo4ekxmbktqYmJPbW8xNEFGa0ts?=
 =?utf-8?B?VUlqYjIvYng2L1hBdjhlRW9SU3dPZGlITDRuUjdoQkJmdnZKWjJaWDh4VTRZ?=
 =?utf-8?B?Z05JYjN6M2hhTWcxdVdsQzdaQ2MyMmcrMHhuNm5rVHV3ZE9IaHl0a3diTk5k?=
 =?utf-8?B?Wk45SUR1MlNZQWo5aEtpWnFvU2o5a2wrNUhZL1pKRGJNR0NvRlpkRFNMek9Q?=
 =?utf-8?Q?o3IceMJYgDXt9hseiWWCq6f0X7l+c9rwvOPJWAG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fe0b84-57e6-4e72-aa0a-08d9524228c9
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:15.8266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dt/g1xTSu/xhrD1GyUY5x/ApbyFO7qIbN/spicY8GkbmXc8IXtKcOL2+m9DwhCmNpPEXtEIKz3RWes4FpxuqsAv7SgvW/f6uxW/ty/i1UOs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: Eu0GSfj2UJSIfJZAGOvRpIkNGjzrtsCF
X-Proofpoint-ORIG-GUID: Eu0GSfj2UJSIfJZAGOvRpIkNGjzrtsCF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 7 Jul 2021 11:59:45 -0700, Igor Pylypiv wrote:

> The tmf timeout timer may trigger at the same time when the response
> from a controller is being handled. When this happens the sas task may
> get freed before the response processing is finished.
> 
> Fix this by calling complete() only when SAS_TASK_STATE_DONE is not set.
> 
> Similar race condition was fixed in commit b90cd6f2b905
> ("scsi: libsas: fix a race condition when smp task timeout")

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: pm80xx: Fix tmf task completion race condition
      https://git.kernel.org/mkp/scsi/c/d712d3fb484b

-- 
Martin K. Petersen	Oracle Linux Engineering
