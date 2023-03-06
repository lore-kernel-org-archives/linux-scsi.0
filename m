Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7DCC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 18:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjCFS5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 13:57:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCFS50 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 13:57:26 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512CF7C9EB
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 10:56:28 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 326HTKuT012934;
        Mon, 6 Mar 2023 18:55:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=cLvrUH4mD26AyThEOQPf/7Nl/myKwFqwEU4pdvhaZl4=;
 b=ePjfFisVejKSqWEirBf7j4iy2cJ6PtX+lc/GQ4KD2Sqg/oG7BSXN2yqKd6H01gIrnQcf
 yNxdPvG1RUvSqRXpR+1bX3bMjy8eshk7uoZyDddXSnNCF6neVXKmDOo9HGNR/vXu5icx
 cUt+axjJBKf23uVv7GiD/Elvn6SSWfMQFd/LwiL84orz8X+clS5hr4Cpf+/Ohw6hrveI
 AYw7WSaB/S63zt229Hmb9ykBRjXZp0fKS9ZvKXgT4Qtsfgo6FibM90npi3CutOlEPJCW
 RWSImNgj6qPdUNCIH9uRVfhR12a8sxj2HQKFS9wV3Yx4YzthaT8+aHUehdawldtRw4n3 rA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xuqa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 18:55:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 326HURlV026636;
        Mon, 6 Mar 2023 18:55:30 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u1dwfrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 06 Mar 2023 18:55:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kNibp+ZYHJEQtVnqk6CQuT5BpHpPxlxepgIaykYbkTX1YDo0gd4wGvxEzR3pYGxl310UhR8urlOseHK442xX76BIsPkKq8diM/e/JKPtoP38kmOn3SFFzsezv1cpTrehIYqNZzycVJpeKXkr9ya/CS7pgFaTzVYVp3WsdyEvQAdsnBFpzPipb4wPjMZwigKTDRmr/5i87wqeP0b+DRto5BA4Mx9Oe5kfh6gXUbMwDEbdaFH5JfRR5E6sow/1Ae6Jefefi4+NcYtvCHsxjaqePirdVam9VLTEQXLxdxpn6AsCEmCgLuqC3ZU7M18/LqjSCj3E8UkLs3DYl4EvoOQyTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLvrUH4mD26AyThEOQPf/7Nl/myKwFqwEU4pdvhaZl4=;
 b=Cr3PE4SKzQ9oM5t1Oexy9pIL0u5zGmwU6EZ7tharzpRLE37xKE5Iwo2iGdt6Bn37pVgkQGZrWwX9Mu+wLyI029+D1LHQ6GLj9f8D0AH3JgXUPyznnDmTZv3U3l1yD26LviTw83LOk6WwgTWu4xvepTepBOvl3oXpgRqnXTChDNbvqQyir+TmzFGsHpCK6TNUB4shwIPcEwbUOZI9KlhQaLSrm9K0n/lPQJ3fkAvVcUAN98X3Usu3+BJUg4c3pSoIEoXcsevBBJAuTMXjigpSLUW7e5WUNmacvqYmGwrcsPijIXMlZOGmm+J5aiQLupiIYYy1g+2NvMfhgYIn/RdFFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLvrUH4mD26AyThEOQPf/7Nl/myKwFqwEU4pdvhaZl4=;
 b=rovtWX5bx5D1gkdJ9P/xTTdBrZMWEC4WlXYXWmelE1VAS2DroG2MkSjbp5EtO/R4Rxw0wsmesq6zjy2eB1vmMsJw874Mh7aAzqIXI7V0eA2SkUhf2pxpjKDeSr1eJGrme6lBNKid7Vg6ky4JtAmFdcfR587oRW/3IckrdNkNZDA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB5968.namprd10.prod.outlook.com (2603:10b6:8:af::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Mon, 6 Mar
 2023 18:55:28 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 18:55:27 +0000
Message-ID: <59da25c2-a903-d004-ba23-712df9259f5e@oracle.com>
Date:   Mon, 6 Mar 2023 18:55:21 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 02/81] scsi: core: Declare most SCSI host template
 pointers const
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-3-bvanassche@acm.org>
 <495d7eeb-bf5c-8333-1945-2ab1614f011f@oracle.com>
 <d8503629-3151-b408-a298-9583ec71a099@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d8503629-3151-b408-a298-9583ec71a099@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0484.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: e1be8c01-78a7-4a61-afc8-08db1e7458f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRyvje+9jiBLoi3qa47AV22VclcFmFCMEgZSPyca39YivUE1S/ItSmmbCTjkNMHtBjGjpWYHu9l8PcbL4lyjZjxyptrp4noML72CfLr1bpYu1DQ6Ec6A2MpxvXcdutweoOedQYCiW1198Nj6c5eIxYFnJ322PZXjOv+aTqTZZWZ/4kYD15BOc2/ko0nYPYwo1Prf+kFpLu27tgaw37YYiFD34CRG0SnR8YZ5E62XUH48+QsNXZQC0LyKI7UtwP8NmE8j0ZQj66oGST0PB07F3ptBjNJOp/eDpaxjM8aWl9lQxtwRLS3y8NVhcBR6dwZQ8YP+WXjQmgRMDkad6tE65+Dv6R4c35MHzM6T6UEBnuhArep/F4wKGnr2Pg3o5+w/pnWQcuaielX5RnquoBBH2X4X+VqlZfjCPbJvXnt9h87LoXkuphLRvXvko95SBhKV8T7QPe3XfFuBJ2txUdH29DY9Xg9+qtwTo9DpKFDV79cmVCAzkUDo4OyHyyUyq6pHazZOmJ3Unrh0tYYRKjSdrNiGYhrXV4RoDIdNvSGkMGUfl203q1b9qqUW60IeIWbMagUx1vlmCsbPZA05JqfNzaI/QQsqvrCuCJBsbxlr3TN8D4V7W3TSV7bbZOWYW6gClWUbcacEZe4h61L6EsDbx15UvXsA5VbTfkhBhO+755VzItj3lQOvILvELjjwAIFVRY+V4Osk7atRh+5Q5gmWiZ7CYqFM+WbgAGLkN1un4EE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199018)(31686004)(83380400001)(36756003)(110136005)(478600001)(316002)(38100700002)(6636002)(54906003)(2616005)(6486002)(5660300002)(6666004)(6512007)(6506007)(186003)(53546011)(36916002)(26005)(8936002)(66556008)(41300700001)(66476007)(66946007)(4326008)(86362001)(8676002)(2906002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T24xNDlRanpoTWhsT1hldEFCQ2xwR3Rsa1lnK3Y4dllDcFAwNkkwQzNMUEFT?=
 =?utf-8?B?QjJVb1loeXE2SCtuZUx6L3BobW45NnphNTBTWVlLY3lFelFHZVdPOFdFZCtT?=
 =?utf-8?B?YTF4WkF2a1Y1dy90SHdoSEp1WXl2RkFEOWcxeEJaNU9NM29qS3FvM3N3VTlp?=
 =?utf-8?B?WjVFZ2E3WG1HNzB1QzduMDlWaVoxZUNFZ0ZRcEZoTUlNUS93alkzTnpTTHJ4?=
 =?utf-8?B?NmhqVFVtWEx4UXRGdkJVY29sdTh2Smphd3ZjOGRMWnkwVGUrR3ZUVjZsZEZv?=
 =?utf-8?B?L1dOSjBOaU9Ia2JtM3lhTG9SQkIxay9adjVvd2pWVE1Eb3lJcmRRUGpjc3Nw?=
 =?utf-8?B?VmhvK0cvZVhBMnE5M2dRTTJoTDBHaGVlQkdncnRrMmt5SWdsWEtDQWE4UDBu?=
 =?utf-8?B?bjQ2QjgwNXhuM2c3R2c1Q0lCcDlPVENwM0tKUytacGxXMDNPVmUrWXppejJ3?=
 =?utf-8?B?ODNJVkpvcndxODVFRzVob1ljNVY2QzUyVkVSMFNPejNqeTdGVEM4UkYrUmI3?=
 =?utf-8?B?VWlneEFrYmRkdTE3MUV1dDdLR21KOVBFT0doNmFFK2lpM3daUVlJeTBXRzdo?=
 =?utf-8?B?cG5mOVNXMWc1bDNHVk1oZDlHYWFCWTRJT0tvbXBrckltTVdxNERsZTFKSUxV?=
 =?utf-8?B?bWxvM09oQUZLN25jbHo2NDFKYWdtcHJSYXpCeTBBNXVYU3V6MXptRUIxejls?=
 =?utf-8?B?bVZHR1VzMGZsTUtiL0VwRkxpSE1VWHpTdmdNS3hNVmxPMFZCV09XVjB3TUcw?=
 =?utf-8?B?U2RsdE1UMWZaNU40SGVXZXpLT29OM3lHdURQcE5VOE10R3gzU01kWHc4Qkcz?=
 =?utf-8?B?cFFiMEJOZ21HYXFBWmhLRDhVLzY5cGxzU0xKMlZxTU9XbjdrZVNpdmY0b0Ny?=
 =?utf-8?B?cWYxVCtoQm5Kd2dVdG52aUpjTkFmZmRIdkNnZURuYkRkdEFaTkJhei9OSXVV?=
 =?utf-8?B?UTZGanc1NHZrUUtSYWZUakE4UkhQbkJzT2F4L3pwNFdtVk8wNW8wREZaWkhD?=
 =?utf-8?B?NXY1YUNxcWx3T3pMcy9zdmEvS2s3Qk1Yak1haW1iQmpzOU5YckxxeFc2THc3?=
 =?utf-8?B?bWEyWmJwRSt5cENMeUp0NXQ4M3RiVVVaNzZGcElDdXJmWjBEaW1STCt1WXZy?=
 =?utf-8?B?eUJwQk14cWNNbm9MRDN1SUNHb2o4eWZ5OTQxT1ZlYU01VUlKRm4zMUZmS3kz?=
 =?utf-8?B?VEhnMmd1NTZMeEltdWFtNmZCSWhDL092Sk1LVk5nSFJVbHEyWittMS8vZ2lW?=
 =?utf-8?B?ZS9BWTBXbkswTHc5eDc4ZEFHMTRlcVhHcFVEU3BuQnQ0Z3lRc09pR3dpdnNp?=
 =?utf-8?B?QW43OTdSdTFVendoNEJ6SC83SXNLSGNwR0xyS05VZnR2Q0NKSUJ0R2JTaE45?=
 =?utf-8?B?M3phRDlhdEtwSDU2d09ZejZyZzVseEdnYllhR3k3bjhQM2tiWGlMNXNKU01n?=
 =?utf-8?B?TUJOK3E3akZBTEQxVjBmUlRRMWVRb0VrTDlmRGRFZHRiMklOV205bmhNY0Q3?=
 =?utf-8?B?WHFHaUQrS0NiUlN5TS9UbWptcEYxMGR1QUprUmp5T1U3dVpmQzdmWDFuV2JT?=
 =?utf-8?B?c1llelIvSzY0UVQ5a2VMcnB0TmtkN3Q1TXJJUW9tcFFkcVoxcmg0d1RvS3I4?=
 =?utf-8?B?Rno1MFVUWW12cHpVMEE0cEhBU054V0J5UmN5bWhjYWV4Tm1xRzZmOUFkUUQy?=
 =?utf-8?B?OVc0dnlhSVUyYmxRNGphT2xRTUFNMTRVV0p1enc5WVM3dk9kSGxxSTdXUUZV?=
 =?utf-8?B?aGV4dzQ2QXpYMkl5THlWajNZWjlPWk5waXRYL0d6YS81Wkt3UmFnRklQVEhy?=
 =?utf-8?B?UkVlNjZQelc3V3QxNXdaM0Nid2dzQ1pKVUNFV0VzRlVTYUl4M1J2WjBkR3BH?=
 =?utf-8?B?cURRMTdVeWpNUElRODlCVTI3Zk9QbkZlUmVlRmhoamJua0o1Z3JiSHptaFI4?=
 =?utf-8?B?czhVUlh2a0FIZmNNSGJ3UnlmZ1BIV1BZZEJOR25hKzhOVnY5WXR3ZjJrZ3kw?=
 =?utf-8?B?V3VjZjF3TEdCeFBiai9tRkRYTFA5V0lXdTFHenhVUkVMSnRwOEQxTXdsN1Zp?=
 =?utf-8?B?dlRlUXJBK3FxbUt1aTNUaS9CTzJPNExQa3VOcldrK3lkZThkc1B6bEdMTjJN?=
 =?utf-8?B?a2dFY3FhZTIyNkR3Ty9ZT2g4MW1SMmlkWVZ2SWRWaDFMSGhSQUk4aEVzUU1C?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: yrs8r5wGQwBnGAxPDkKZFwZbhG5DC4E+m+iSS7n070QrV6gHqwz+3uJ8X+Eo/qwn6ccRxtnTmX7oYxXLBAyVJtwlrw5GlgtKfD11FYk/8ErWrzEhQkmVCO8vZNunOtBW0l0nz2Vi6+6pa88BB80CBwqjUwAGlw8JZUp7NWN0qY3Ko0eis4ZLVLyi0ZyT1/MZjtH2+AdG4hIlPi/g1cwifDM5ozZvX2uIl10/ItiNVCHCKygoFGjiqQhoE3s5SShwJG2lF0qY2/yWhzcS5ycvEbqQZWE+epGJW9p2cBSwCBZpxnycAReVyruBMLkiyhwGV0pLtryfL/FDGsN/yvAPk0dCrzSlNyVdeAcnkZuNOqnPfSsegMT67910z9KWgMRZS0V5U1Top/AOJUV1q88t6EKBRRRW487wxkanop4fU36wiw9rCV+FBC2mFavJRd2cWajHBIGPQf9nxssOG7quQTdOIc0cLEKpDBoYWNJCJarL3bbqL3onFUeR7ukq2WcgZQSi07+TJOcQGAyQheEwQR2xdSVjX0RJNlrB9K2Y9VZ25LCvjJDJvkp9fASufm1Fi54R/kIp5O81/pxMjChCk4C7FNs4dKhX0MFzeLYKOhQ90gOobvdDqDMn1V/iUwn2RFZaJJ5DHA9c8FUJhppCOyfgpAN1uCcp0neDTah8JdovTTwucBlFnHrCPYeCLj++wV3XiRB38KZloUVCa16M4DITEP1onVedJQnwtBQZumZf/fujtvawJEz1gBJuS7iEBTYCLgQADc+KyHHpHHFIJTEdyodk092zZ96oZ+lN9fyqRxps2QevICAD0A5lFFhhbYNYbaiJD5hM8qmbLBR0kvXLDd8kAFKtciHFXe7lW+VN4mdwduZQd5RxfzW6W/gH
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1be8c01-78a7-4a61-afc8-08db1e7458f9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 18:55:27.1180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4yzVEtrmd/kutMa86TiK9162QG+s3F9EF+jMd6uNTfN0iTa8e2pGfYzJ9S+fZeXfPI135QtOqz2Rc6AsKpcmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5968
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-06_12,2023-03-06_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303060167
X-Proofpoint-GUID: gWjTvdO-dAXihcTTZROG7Y6uE88yZzLH
X-Proofpoint-ORIG-GUID: gWjTvdO-dAXihcTTZROG7Y6uE88yZzLH
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/03/2023 16:07, Bart Van Assche wrote:
> On 3/6/23 06:29, John Garry wrote:
>> You wrote that most pointers were now cast as const - which ones were 
>> not? From a quick scan they all seem to be const
> 
> Hi Garry,
> 
> Some SCSI drivers modify one of more members of the SCSI host template. 
> An example can be found in drivers/scsi/pcmcia/nsp_cs.c:

I seemed to get the wrong idea of what you meant in the commit message. 
When you wrote "Prepare for constifying most SCSI host template 
pointers", I got the impression that most of the pointers to SCSI host 
template in the core code were going to be pointers to const. However 
you really meant that most of the per-driver SCSI host template 
instances would be const.

Anyway,

Reviewed-by: John Garry <john.g.garry@oracle.com>

> 
>      sht->name      = data->nspinfo;
> 
> Another example from drivers/scsi/bnx2fc/bnx2fc_fcoe.c:
> 
>      bnx2fc_shost_template.can_queue = hba->max_outstanding_cmds;

BTW, surely we should be setting shost->can_queue = 
hba->max_outstanding_cmds after scsi_host_alloc() and not modifying 
bnx2fc_shost_template, right? The series is already huge, so this stuff 
would be done separately, I suppose.

Thanks,
John

