Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB30C433F2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0620B6196C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhC3Dz4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:56 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42646 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbhC3DzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3kGKG192504;
        Tue, 30 Mar 2021 03:55:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=b+QdvZsI5PclMz0amcBjw5wYnonkz43ZmGSLSEBzd4U=;
 b=xZffW4Q9ZBHUIWD5v1cF6PrevOiLh3GHL2h0d2yZtv2YCpRJwPUU7lfXxO8h2lyLqPJw
 kPNlRPHxZbYk3cZ6EEvd7/0w5l3RGT1wxGYxfYWXKnhTVGOLUi9nZW8kq5ilSHbVxPdr
 CGEK6ar2tLguWgVnExmcEDD6vItEIRU19ok3Aq59TTnANViR0PFUBnVUb6i57NiiHswK
 h0pYjPFSAqFsN3/4HDfq9ox9snFNd80WHs8H1qaPFzb00r69rMhcmQZjAaLbws115hJQ
 9wKO8+olQXntKv7ZX918kba7pIPwpVZehI23TrCth2wKeucU9ZRBk+msB9kerbofutKN pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37ht7bdq5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jRdF187799;
        Tue, 30 Mar 2021 03:55:18 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 37jemwj7hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NS4J6iOxOXaDdxqWc1a5OO8K+qSgIPnXZgNtjAlumooedgdoJwD2ibVRMJsamQgAnlIHb5yVbOL2JfUGSmlShIbXr0brnp+6+girRrCqSGHW5RvH5A/bIkaX+sxkIl1MLxyqeSDNryrkytwsAJ+8G23IyY4c/Yd/v0L0tyKnz8qYIDdJYFE9Q0fF70aRaOdmfev1WhQW4BqJxeUoT89J3d8degIo4sVofGsiB7ONz+6lEeyK5pjtlOHpBqBcoNbB0Zi9E2Z0m1VmtEMReEuPek4JVUYpTvW4NEGae9mnQCfBB8hAING+OU+tsM5xa5raDum8+kBREnGOEpaD7n7EiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+QdvZsI5PclMz0amcBjw5wYnonkz43ZmGSLSEBzd4U=;
 b=eNJdSUqXjytupuebiVlFzlfS1nnhjw8OsUD0ggTR0BZeONjG9B/RPCWSJYWp+VIwmS+vPcGoWDdCjgFfVMEHR6aq52QJE5ba0+zb1oZXldfh3F3oA5q0d0JCnjNbmMXKHOSL053cjFlw/xk6F38xdIFFJNCJc11RwsyIbstZGgiPDwQp5YrgSNd58aC8WFeYMclP3DC9Vd9S9R/Hi+wO/f/I7P5WeuGbTeKJI1CYwSX6rupye0Facrqfq9hHms8lYuUIpvkRLqn1xgPAnAiPeBgVFJCWvQ8zuYa+pUNtjI0OLnOsAoYNKxxNJUO7qvdXKngqhNw++3CxOk1Cp9Hf7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b+QdvZsI5PclMz0amcBjw5wYnonkz43ZmGSLSEBzd4U=;
 b=TvD+Ffg65tPtijxFlyb1fCWCAUnyxzfjZ6G1rfzGwdFpxNfh01iPdZStGb3sO4eY2ZEGph6YJeHKdrGGJn3UBaR6ANmLetE1K4LjMLvXkGIaDcTJTyYZiGyMDJI0LGVTk0t22SBqY4TaE16cMz88QVHqLNYrxZpqQJYREaha2NU=
Authentication-Results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Satish Kharat <satishkh@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Wang Qing <wangqing@vivo.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fnic: delete the useless casting value returned
Date:   Mon, 29 Mar 2021 23:54:47 -0400
Message-Id: <161707636880.29267.11295771729577355525.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615515500-946-1-git-send-email-wangqing@vivo.com>
References: <1615515500-946-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9460d6ac-d9fb-4af6-dea8-08d8f32fa12d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760ED563DFE61DD4943DCB98E7D9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h9+DRE9lMe59ewNvb9eBAewgADKhFZsXbKU1cm4DN8jCnaigJfEhkyjKw1LKAA9I30zqRgEVspakbkDKblliiBNiERXPhdWFH5R45zOJ1fM02IDDvCBOdk9cUdjjfWfDEtLtTXY4qnR0p2cBrgZvQuamUC6GWR9+QcnxZMeEYYu/V+wWeYTaHOYP6IxfhHk6cAzr92220V29fRJXSgiroMfS05VhA5B8qmQ3eO2LKgsdqFG8MEGD+ZlzDiPFI1LCiZLdbJFaQORMA4tCzz2k5ja9toh0pGYsUfajpYHaNam8u8RgxMU2aIN8bth35QuDNQzZgwfaGBQP9UbwfW+feNtL4uaZzxL5gZVEAG19TIu56scjejiiirJPSJTimNx5I6IQk8oCiJemZREiWmS4YTLXxdzE0vRMLsztGA6Z0HphP89TmsKCvQg2oybUrCgxoPLIqrcQ2YY5nIfwrI4WEwvDhqJNBybUkMRGX4yHeegDmVeOs9AE8Xa2Vy1VYGzAPhqs/ew6WAMeWCzFWwcq9eVwv9H3R113+eW18S+IGbqJHAEs2SnWGUidMeG6+3K9WGQnfyh/GewfFiNljzmCGeGPCCu/7fcZJqs0ZwOsZNKUeUK/e0RG0348LFRhkOMnKn4TPCDtM4EgZAuhy1i/wVEJfDmvZtDWUM/pNsIXDZ5W/fvd56w//Q0MnOysgF1vmGGI5U1JnJLBCc4tEqNa9u9uxma5vE5akKxmYRdKODE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(83380400001)(66476007)(52116002)(86362001)(4744005)(110136005)(66946007)(66556008)(6486002)(26005)(8676002)(478600001)(7696005)(186003)(36756003)(956004)(316002)(966005)(103116003)(16526019)(107886003)(2906002)(5660300002)(6666004)(2616005)(38100700001)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZE92dmpUU1BBdDlCT3diYmhDNkRJWXVmMmRPcWxlMmZ2SEZEZ1ZqYkFYUXU0?=
 =?utf-8?B?UXloNnFkTlJzeURqK1YybVNuZnVFeGRCRmwxa2xQL2ZyS0EwRmNmTXV4cFMy?=
 =?utf-8?B?QURSb1BiT1UyK1N1a3Y0cjVWSjgySXBVSkhwN05oU1FTd3B2S1p1ZGFqRmdK?=
 =?utf-8?B?b0JHQW81WlZpMVFlTzdWUXpJRmFjeGozaUhYd2NHNVNjNFl4TEdibXV4T1Ur?=
 =?utf-8?B?UWVaUThRazBsZCs2VUpReXBrSjlLVnZyYnRxTWc5bDJYUnFUSDBqSzBKRlhJ?=
 =?utf-8?B?RDFOOFBidGZFaGpCTys0V3dvclJhUmxlaDhiYXJ4QWR3dmxUb2xCalBzeTFp?=
 =?utf-8?B?eXBFSFRXa096UzlOR3VJblA5VXhIRFZWMFRtZnpNZlBFOS9jYVJ5UHY1d1Vm?=
 =?utf-8?B?dnRoREJLaTljTGtxa0JLYzVCYi9WNEtXUVlkUEcrRHh4WEovRTFWenNFc1No?=
 =?utf-8?B?SEx2TW9vVmY5WURNaERGTmZYbDJIUEpqR3lXcWw3bVo4N0REZUtiaXlINVVV?=
 =?utf-8?B?eHpTNGxaQjk0S3ovKzlUVHFnQjBocmVjUDJGZjI3bjk2b0VJYitKTXRvVzZU?=
 =?utf-8?B?NmsxRDNyVmZFaVd0RDVidzZiRFdpU3loeFhsZTVLWVBvOHVxZjZnek1SZVB1?=
 =?utf-8?B?dlc2bUI5V29kU0VSdE9vNUtSbWh5cmhoVVV1ZjY3RHRyRUtKeUs3Qk8yVHlu?=
 =?utf-8?B?RktPQWtEeGNWOW1ML2hFSGNOS3VyUnNrdlg0ZkRScXRqRVBJamRyejZwWG9C?=
 =?utf-8?B?WVZ5eGg3bEM1MjNneDZ1SFd4ckZ1dmlyS1hQbTU2UGdFenZJbnd3WDhsS0or?=
 =?utf-8?B?dmpVTnJ3SHhqbnc4SmdJOHJMUkNEYlNDVVNPMFdqMmJSVUIyY0VqRDFidjdh?=
 =?utf-8?B?Tm4yUk50YXR1OWwveDV1ak5KMk9sN0JQNEg3a2sxTERsNFVWa1BxNnVzQ2k2?=
 =?utf-8?B?UTczUkZlMDBwdzRQcVBLTVozU0tkbjZSRlJ2S3Y5OTdkQVVvTGNwcXdiOHhn?=
 =?utf-8?B?TVQ2MHcyOXhzdWdjckoxZzc3Z3FLT2RHdWhIMFl3YU5qT0ZDcTFxZFZubSt6?=
 =?utf-8?B?blU0cjNybmpXYnBZeTZuanI4Rkp4cUhoT1lCK0pSdzFuUlVZMTJKN2oyUFhL?=
 =?utf-8?B?aU14RUdZdTRheTVBTXR1TmFPcEVCQnFzL1UwUU9FQ2NvQnFOalJ3WjdnTUoz?=
 =?utf-8?B?UHVmOVJicG5CYjFUUysrSW9mdnJIVjU5K29KN05LTG1hcHhMVXZ0R2FzRjAy?=
 =?utf-8?B?U2dqelRtZG92ZElRbzlONEp5OWgvSnZEd2Y2MDlKUW5GMlVXOVVncVB5Wits?=
 =?utf-8?B?eml1UE8yNldrZDVtK1hGZlBqci9US2YxM3JWazVDRUhSTkM4L3psU0JsQm05?=
 =?utf-8?B?Mmgrckx6aVFEOVJxODdudGJ0VnF3ZWxYQitDeWVZZWpTU3c5cytHRy82dzho?=
 =?utf-8?B?cTdCS0o3bENBUWd1ZDIvOTZMRnp0YUFuNVBJVk15S09ldUxrdjlHbjV4TTFB?=
 =?utf-8?B?QlFYRjR5anpLdTIzM2xZVHFWZGFZZWVtYXZvdGVydzU4RGpURUE2OWF2U0dq?=
 =?utf-8?B?M2dNSFQxMEsvQkhkRE8xZDVzUXFwcDVURDJZSUxnQ1VnK0d3MVFnaENscjNE?=
 =?utf-8?B?SlhKRkRwTUltTHBZc2plNU1MYWl0OXoveC94Q2ltNVhXSjVIc1cyS0lzcXd5?=
 =?utf-8?B?QmFqNWl2OUFhQzNZMkg5NU9oUVN5M1lUYnBiNTBtUlpUUVBFeng1ZWk0Lzk1?=
 =?utf-8?Q?lQhuLMojxCvWhyCC+bCQqkVfXOMPMKgVYbEUMCP?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9460d6ac-d9fb-4af6-dea8-08d8f32fa12d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:16.8265
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+ik0fSqh2c5uXM8l4D+yZ89ufmNSOU3BsewPW7NV+BnuWVTCwpxdDiu8j+0tenayPzaM87dzJ6FQtRKWNj44L58DqyZBIRxLxsz86CAkgI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-GUID: Nq6OIqvfstZ8ExI4C36eSjj7mA_HydpO
X-Proofpoint-ORIG-GUID: Nq6OIqvfstZ8ExI4C36eSjj7mA_HydpO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 12 Mar 2021 10:18:19 +0800, Wang Qing wrote:

> Fix the following coccicheck warning:
> WARNING: casting value returned by memory allocation function is useless.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: fnic: delete the useless casting value returned
      https://git.kernel.org/mkp/scsi/c/3ba9f38ed43d

-- 
Martin K. Petersen	Oracle Linux Engineering
