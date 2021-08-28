Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A260DC4320E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 838926023E
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhH1CdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:34478 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232555AbhH1CdP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:15 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17S1hjF8020671;
        Sat, 28 Aug 2021 02:32:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=B0GB/m3XM/RvOmydFmMxUTCPDaPU35ilDhb9kgpiDBk=;
 b=B4VUcTpye1Ftxagxs+tYXR4/3PqZtDfRGkqL6F8z9u0Mes9KKWqFAIHOUW9jeyosAqO3
 YzulnR7iCEDUOdYweQx5yWcUng0Wqc0jBmCEM5mJ/BXh+3diSbDu7zkogwCzqGdCpJsr
 yMZ9JtN0U+XQ7ThKvifsauQrtq6QDxxbimT2z7Ca7Sl9QBAQEUW0u3mao3ck8Sc9IuqC
 Cw5WomNlTljcVw7H5GqVR4R6srs1IbC5ysOFIBUoWkftKSvu4Cky2hk9orFghRYMLIx5
 i8H9nBPJ/UwS7z+25nBR76Ov1UeFeO960nGV6iq1vxmJkiSNqEbk3FkXisSdTu7cwWYi vQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=B0GB/m3XM/RvOmydFmMxUTCPDaPU35ilDhb9kgpiDBk=;
 b=Wscn/xHv++AqIgDKANeVIFlQQuSSUAHG/z9AtZv0oqIebggphVTGmWm0+4mkg0nZ7rPJ
 Fd8/jCRdLq4V4+7DKjKrhE8h5VJwoNA/7fWhPQly/vaypNafaoaaCtjJD2TV3qoVU9Li
 fqnWRBvwM5RYNb0dUn7ben0qzhLW036Sk5Bv/O6xQj4hguaxu43pw6oRuTbvvTvKaJiw
 9m6ph2OB58L56NcfFpejHqSUW8MKBgsKxOVAt6I/dIf9kJFaHmvLqpaheCHOHYbTRD79
 oiQGivAzAPjoPRqxoTL7eyfD6/xVYOzV9YcBA3KXAP7LS7E9sno8KcCnSnyX5+Mgs/Ia JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aqbr200y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2Fm2e147458;
        Sat, 28 Aug 2021 02:32:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 3akb935rd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3JVDjMLFRTxb1HZ9fImJuvBx2bMGfC4PYi5wbYOMDgezyDSxlsGt1km2wJeNbb2iieAxTnG9ZQdofwo1Id3xLshIuG1BGCriBNw7StAFe/5/Z1q16N+uv1+S0pch2l6/yHokOYTD1p/Du9Lc/LE9egBrud7sIZwlWQTzw8t3r7SJpoHWJ9PRnP7ZBUL2tuObsPCFnkofkrXpIowhMMBtG0eIZoyxLgmKgY9O1jdaY3PFg27dvWff2pLfJ2UDMc9KSeihiSMesaUdX5nRs0BmHfxSGjrPGTKvJ01kJEMPSiaTBF9WcnpaeHpNQOG/kBmh9zqvJXanyqxMaH7xd0VDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0GB/m3XM/RvOmydFmMxUTCPDaPU35ilDhb9kgpiDBk=;
 b=IUHnLph0USA38s8ruJ7/Xhz358viopacYU5kT83PvZYq91nzzYjlt8zSANt1SSisBtCUl5uwPUGLYMDfQ6XZcmagOY+0Kpiloth76o3r6be7ta8QNKCJ1byV0BaH4qfBsxEOf/IMI8RLzCgrdCHck719GDe5/YM1pHRNx1cITv9a+kTrBIIAOzg10scwUsWYeBlGMwLUXT91eq3uhFHdED/qXNFbE/IM0UyYPrpDAFDIHmHjt/ySkMlP5tFgPphwbWob8/omA+QySVcAKXvObPp/By0cFvhxx77f7GTxOahvDaCvI8xmJ3pdsGcrcducQXRHdGAS3Yt3kSE045XwZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0GB/m3XM/RvOmydFmMxUTCPDaPU35ilDhb9kgpiDBk=;
 b=c88KVafsOej3EmbpQ0fCZpnGalUtTsyMCmxxZCkwJWXgX25NFmdd63JU9UCHsT8FldXkXUG5sl3bPHlDjpFT/K4kAGsoLGnCTQBdbm+Pm5RaCSbFAkGMrHIN6wmN00Lqxdpeh7CkmqPIcVpNPTblHKW1JdK7kGwyqO2FJnKRVTo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Colin King <colin.king@canonical.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Karan Tilak Kumar <kartilak@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Fix spelling mistake "progres" -> "progress"
Date:   Fri, 27 Aug 2021 22:32:00 -0400
Message-Id: <163011776501.12104.11809765363820301877.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210820151835.59804-1-colin.king@canonical.com>
References: <20210820151835.59804-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bdaa819-7bbe-4c3f-1d6f-08d969cc0de9
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55157559E8CAAC4F08FABD478EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YwFzKCOlXxWWy/gIX4GOni4GiAn2UtF/8oedZeVQD5pvJwzfD6cadJMEVF1lC0KerVv9u6rwUzBqRt8A1p3mvq5fzkWDtyF++/e4j55VsYmy4TYaGFqb26Ks8GWF5fvrWA8PnAZ1EWlDygLz7YEfz0fTjwrjfZWRPxgTOjrHrE2hr2VweYQN7HFIjutyNrHcIyHxfhVQIHFEKsPVv0Rsmcp1EyApqQ2iE4gSGY6TJ7bFNRjVcDB94Y1h0r88nxBWwEDBkYkUy2J0G8foBMF9zV34XqU0zhRSUem0Yb1hzW3vw9Bz1O3gJIJ6GL7WcHmI2mZ2W7oViin7dGiKZcoQtjzBu0Kgk+kCH5uBjE5JVkh7V6u5xNv9J6tFdoVWXxmhqoEYJ4WHd2LQyFM9XLW2RKPVW7qj/bXe1KtWlr5zihZnoLdU2BbQ8At/6G1rfADs0+9svOtAKzvzii9wX4IaXqIGGu9mzCqvnwJkMtmO4RwrdKs1oSm0qgx/w1k+BhghDVPHGXkSVHcbFWqlp2lFV4V7VdrzIBHHnrenMWzhzB+uxsrJxUxOhH6DqM/+HFqRjE45gYu2MUe8G+/sodH8TCWgshDKKW5sTVJPzqh7fM805ZL+OurfquVuXwKICLhlrfLsR2TkR5f36W01ECMXg/vlfSZPUq26M8tIwBsgNQSno4bsxR9+LbkOqrmlX49DkFI0TGAsztoSdXKrRABH0F6s9oqAheXohOsdybIjemy7a3tQDVhER6PSiG68oNlSYVhgbIFURRfRScBnQov5xjJaD+LaNnaEvJrUiL2Rtxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(110136005)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(103116003)(66476007)(66946007)(8676002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aTd3T2tOQzZUUDVrZnVvcHNMWThHenVEdjVwMUFFVVJXckdYTzZLd1NlcTJ0?=
 =?utf-8?B?K3VXVjNCYlVVY3R2NHJrYWY1SU90UVoraWV3SCtoU2tHdndLcUM4TjhvMVBa?=
 =?utf-8?B?OGxDclA3bXpjY053WWlWNFVuMm1zbWU3ZGZFa1RVNjFlNjZZREI3MnZMWnpP?=
 =?utf-8?B?b3l6dC92SVBWZnpEaS8xRG5wSklkRWVNMVk3MjZyQ1ZNVzV3aWhpa1cxME5E?=
 =?utf-8?B?c3p2dTdEVDJBdXZ5ZEV1RDB0aGZjSGhDMXc0MDVUUHRzRHJKQ0dkYk1aYmNV?=
 =?utf-8?B?SFZyWXR5SEQvZ201eFhvYlpYWjlzTGhBS09xMVcyS1pGVlZlWFVWSFVhcGxa?=
 =?utf-8?B?dHF5dk9SMzlMMGtsbmxBMjBXMk5qYXZUY3RiVlVPTnMydVdYelRpcXkzbVNY?=
 =?utf-8?B?blpIL0R6ZXlVRTJNdHdtQVhEaWVZNW9HcFd2RUk0SmpBL2thNmZoQVcwazVP?=
 =?utf-8?B?aHVCZDhiVnhBK2FVSFo4NHIveEFuODBVVDd0QlBOZ3BjV0dOMmMzMDNYUUwx?=
 =?utf-8?B?ZWtadDBKY0JmQno5cDk5b1hLdFdjKzloclg4UTh5VXNuZE8rZUxhTTRTVWhw?=
 =?utf-8?B?a1l2Wkd5b3NCU3laMW1CSGtKTmpEN1NrSkZHS0VMRHhKYjNjb2llNmJiV1Jo?=
 =?utf-8?B?V0ZQQm45MnhNaDEvM3cxZVJGWXV6eFByRVRmL1oxRTNOY3QreW1VQlRpbm9V?=
 =?utf-8?B?aXJUQ2Q3ZUZscDNIajNHbmtmbjdlWnNQK0dDak9UVmFLaWYwQ294YUVVelNs?=
 =?utf-8?B?amh1RXB5eXNlaHMyeGdPaUFtU0FGSzJQRHdvYUoyNE5WNE50WnhTdHpJWVho?=
 =?utf-8?B?ZlZNTlU3S0JMSVkranBqeTN5a2tyTlZybTIrNVRZbTVMc3V3SktjVXVkTDN0?=
 =?utf-8?B?TWE4RG4wckg3VnJsbEdqVEJuWlJVanBaRWtqVGx1eVF0THFyUzBYWFlaenhO?=
 =?utf-8?B?aThlbFZpRy9xY0FQYlVmSXpOOENTK1U3WnBDMk5GMzhERFJYWjc3VjZ3bTI4?=
 =?utf-8?B?RllCaDZ2ZFlxbk9xcW0yckFkOURVYkxDZTVIT0crdnZuQm9JRVlhNmJCWm03?=
 =?utf-8?B?MUdhYXhWUkxabnRDZHA0Z3NjVktzMDR6cHcrTFRXNlZsMTFXQ2pYaGVGbmNH?=
 =?utf-8?B?SzlybGdjSU1lV3hHME4yWkNzdHpRc0pMRms2NVRuak1jWnZXYUtxaGgxSU92?=
 =?utf-8?B?Vk5HeFhOb28ydTdZWTYxOTRsY3VwZ2daS1dtM2QyMlBmMWIyMDN0TmVNOEFM?=
 =?utf-8?B?dm5Fb3BuRjlrRUtYMi9XZ2ErVWFTVGJXcEhzbkpwaWtXeE5NYXU3NHkrV2FH?=
 =?utf-8?B?TUc3bDE3N3o1SFZSQ1hQV0Y2cHpFbXdYdWxBZlFQUzcwZHQreDN2NFROakJ1?=
 =?utf-8?B?dUFwajVIVVNOSlp1cnYxdk9Lb3V2R2Rhb1d2YkFvNFBsZUxER3o2ZjZsU0ZX?=
 =?utf-8?B?SVpoQjFFWWJ6aEI0T0F5dGQ2aTJaT1EwdGtOUnhDV1JVMW1Ca0p6eDYxTThq?=
 =?utf-8?B?SUJmbDIxcHQvaThqUjNoWnZVeHlBc290QWlSaFdESlR2Z2RpU29QQ1VjKzlx?=
 =?utf-8?B?NnJEL1ZXT013Z0c5TkxZeTZiVnhETjlMQlN4c1NNSXBIRjROOFp3RUlENXVr?=
 =?utf-8?B?WnEwOFQ2TWtPdCtYN1ZVdTlWYnpUVmhxa1YyQllUcHlOQnlUdlF2L2JHM0s1?=
 =?utf-8?B?QzYvZlF0MEliOHlnZFFhOGxOUG1WRlNkVlZhK3dzRWl2ck1zOXBoYVVKcGll?=
 =?utf-8?Q?z8cInVhaMzVnCFjdH9DCKSldDGRG2gU3kDQhEAV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bdaa819-7bbe-4c3f-1d6f-08d969cc0de9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:18.0826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z7/Qj9I1mS2B0xrH55ioPYjiJ3n2HmoL7ODVwqcKLsMVe+tKVwZUjaUrqbyBbdc/My/XlXpXHIN0y6Q0Q7ONoAwX0EU+wzRKG6JENm+D/X0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=993 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: ncdW5C1K0LaH6gojp3262eazOev335VE
X-Proofpoint-ORIG-GUID: ncdW5C1K0LaH6gojp3262eazOev335VE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Aug 2021 16:18:35 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a SNIC_HOST_INFO message. Fix it.
> 
> 
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: snic: Fix spelling mistake "progres" -> "progress"
      https://git.kernel.org/mkp/scsi/c/1259d5f0f5ef

-- 
Martin K. Petersen	Oracle Linux Engineering
