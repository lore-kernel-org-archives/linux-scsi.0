Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE710E92FD0
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 00:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjJFAg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Oct 2023 20:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjJFAgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Oct 2023 20:36:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605CDD6
        for <linux-scsi@vger.kernel.org>; Thu,  5 Oct 2023 17:36:24 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 395InCUI021375;
        Fri, 6 Oct 2023 00:36:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=up7ERENKxA0X9gX4+rEoEGJomF8YfwbKhQ8+07IvAmU=;
 b=a3jp3+lb+5piioNA/S4xWrkP/CwgOMpnEk0lNn361BAB2q+gl7EdfeVRhgiF+PgRjT0S
 fuhka3Cn6LvbF/2dSXQ9sorXDtvan4jr45xT0dMTPkykMHG7DbMXaDZWAVZXow/mhnpy
 Lmr4xl+mTKwIBJt2Dmo8CN9EILUJXxrK3tD4NK3ANUQryXtxuIjGakPjdtw9vi//GmZP
 LpP3F2wA9yzvJaNJZhkAL/uIm9CWt1t9sw6jrbjwd/dQKVhOuxrgZNKPiR++UJ6GdDF0
 J8t/4X5IkDTGCofNImafULiMDowiTfYc0T5be/2u8oevQbXDiGJwogvASgvVEqUor1CS /g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebqe2w88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Oct 2023 00:36:12 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 395MVrMd033676;
        Fri, 6 Oct 2023 00:36:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tea4a3878-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Oct 2023 00:36:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EcKdF9E7qfbj7kgV/ra68re5Hl+pEQThCIm6L1IGsRa9Ty+K8WlcqAkOxKrCnKkc+m+0/l2N6m55+aJgjQWCRQwLtQBWTKdmHMERI+vxq967oi0oxG4dvfUZ66arsHgJ2yhm9mJPkzMqXdhUI8OuKQa56jEbVvA8wdZlK6U7TLqPinNo11UwhHcPc2v+tgxhIo7x4FulpzW28MwZv2QYKpqk1bimBF9JqBbKnjwlVQgj5vd1WFztnFWzCkBAworDLFwNnE8buAmo20uqVkWcd5JJaoE8/qOcpdQ0tDJHilC7ZEo+dBCk3UfGb4rtRCONCdC2aBC64b936z7PW81CDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=up7ERENKxA0X9gX4+rEoEGJomF8YfwbKhQ8+07IvAmU=;
 b=ceZ4WF7QcoL0REpNt40g3EqF2mCwXc3VKsNZJTJZlyMJAJwxEOtvDo8gN5Uj9Q4GIoBt+oDhxMNwYaBl5O17V9X1C7+yDjlGHM0D9WBtUMaM9z6fouZuBAi46UuyEG3CzKtzM1p//WlJFsrdheiiZOgihwrGbV4bbGj2De4+4zNIyWPlGN29aPZ7cQ5FSBamUgeKZifNqjtOd1D4J+t4lrw5m0HSmMy9KaQE3vEgTrfw2rqSjrQegK0t4jjTgB27JXEw193n+lCwyUZnektAsiDKB+CDz8v/AlmcfDwftSTS082pGlNO+EPkpgohhvM4m6VUDXpqPnjlNcRTNWcLWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=up7ERENKxA0X9gX4+rEoEGJomF8YfwbKhQ8+07IvAmU=;
 b=gcLGNQUxblc0qBNyBEoydTOCcQIeLEWWyax4MskRUJrPR+VieK8vGbJA4xIMcLLaq8PKLfxg49DvAY/C1rBaBFuHlkZrX2VHoQJqeePzvWfEgzSBnwcWwRqtv699r+nwhRZQp7b2E8POHddMks3GeJTvg4b69Dxj7Up8OEmD1KE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH7PR10MB6334.namprd10.prod.outlook.com (2603:10b6:510:1b1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.39; Fri, 6 Oct
 2023 00:36:09 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::37c3:3be:d433:74e8%7]) with mapi id 15.20.6838.028; Fri, 6 Oct 2023
 00:36:09 +0000
Message-ID: <c630ca48-7747-40a2-8c12-d1b212f07c07@oracle.com>
Date:   Thu, 5 Oct 2023 19:36:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/12] scsi: sd: Fix scsi_mode_sense caller's sshdr use
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, mwilck@suse.com,
        john.g.garry@oracle.com, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20231004210013.5601-1-michael.christie@oracle.com>
 <20231004210013.5601-9-michael.christie@oracle.com>
 <3e87f523-5e5e-dd67-26f3-8187b44b23b0@kernel.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <3e87f523-5e5e-dd67-26f3-8187b44b23b0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0102.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::43) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH7PR10MB6334:EE_
X-MS-Office365-Filtering-Correlation-Id: 169c0152-4f49-4b28-b4ef-08dbc6043be6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OwfKYruaBvfzdNuJhYk37Toun12sKbX8jW6aKqFU6ndph0iehu0+pU8ULahYaWXpCSIg5zFGY8559gTyZnZZdTnEkiO0pOfuzM8m+XqNa8kyS/tYmUBAWAu/vfFoo9PVBPY8s/v0n69C/H0ZnL5kZTKgNFaDaYHO+S3UuokYXsjhQzKt2MiS1Jyt4hMh34ljIArxdQCZl8dec22zYdEo/uVY7DR7P3eMvKOE3vZhWV/lmlAlPDYSHkb5Us6R88mG6qO0KBqUgSIUNPzB4+KyD4k08r6OcKCLkEqp/KJK9iV+AidrUWOawzEo5lGg/SoyOhnYEY6kaD9wiJH8FzWtkm85RKapN2hcJb0iglFf1dwwlOe4Bucscfpbtt8ErnS4do/A5ejL/RwWCWxTbxCZLiGF33Lw2SViK4FYtSb3PKJHsQ6JZfowEk7ME6GugQChklvHkdw8XzlTkdwTYZN0IAatn718nDXca/bXocmv0/Sbt+yoJGEtIE7IlXsAY0PWwWPN360AmUEEsoUaW/HPVJeJKu/zvroKO8rVAfB/QKz9E6OqtTzRLVccn7NUanH3ScJqNxNcpNgGchuE2RNxebWsQioiIujVH3VEPfSz0DoGFxzidSUF+dhgmgPEfU4KhnAK3C3zIXsGHUQQg5H4gA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(396003)(136003)(346002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(83380400001)(8936002)(8676002)(316002)(66946007)(66476007)(66556008)(478600001)(2616005)(26005)(6486002)(6506007)(41300700001)(2906002)(6512007)(53546011)(38100700002)(5660300002)(31696002)(36756003)(86362001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWgraDYrck1hMEp6UWdiVmZZbW8xdnBQWEY3c3Bwc3lOVTVwUUU1U2pUMm16?=
 =?utf-8?B?V1kyYUp5aUlWdmVaRFNJbE5oL1owR1BuaitTZzB5aU9UbXhWNUEzQnV6eXNm?=
 =?utf-8?B?SWI3eWhua3o3MmtmRUdJY2xNNEh2NXoxMDg2ek9za1o3Zy96dHU5MWg4OFRK?=
 =?utf-8?B?UXZ1M0x1WFdBKzRuenNqNkhoUHZ0TjNlS0FpY1VXMkhHYnNIOFlYcDAzcS9G?=
 =?utf-8?B?RDhyRlcyMnZOSnE3TlF2RVZDa3BJTXJ4a1JFZVV3TWpTaGVwVmZjS1lNNWVP?=
 =?utf-8?B?eFEyM0N3cEh1OGxVMDRoaXZrZUJtR3lZeWcyZGV1S0MxMmliYUQ2NUZoRmRv?=
 =?utf-8?B?Q3o4ZW9MVUtqcndpOTJnVlIwSWtzeTRIUHM2N3lLbzI2a3R5cHJtUzR3cndG?=
 =?utf-8?B?Qk5YOUNOelZxYnJoK1FQUmkrSUdpSm5uUGFFR3hiSnVhL2NnQWNNbE5yd1Rj?=
 =?utf-8?B?ZEVNdXZDSi9iQ1NUR3JVRTdTbElFOWZEbWp4Nkcwc3kvWGZtQmNva0x4QXdN?=
 =?utf-8?B?cDBEVkhCOEVJSFJBUUZ3bnNPRHA4TU85U0V5eEVjNzh6TnhhekI3YzZRRkNI?=
 =?utf-8?B?WHhqTlJYbm43cmsvcXRKS1F3VW1PNjVEREJWMUJBZFZoT1hZeWNicGsySm5B?=
 =?utf-8?B?MGNrN1d2enVHUDh1NUZwUUlxNkFEK2tSa3JpbHpsY1E0NkNOZGFSY243d2hO?=
 =?utf-8?B?U3FOdFNsT0xxL3R6ekRwZjFDeU90cVBzRUdKQ2MrVE9HSHp5bElHRmRkMHZF?=
 =?utf-8?B?UDdWUllobFFydTMwR0lLaHpVeUNzSC8wNHd2KzJyUGQ5MC9xZWFTYW5TUUwz?=
 =?utf-8?B?b091WUxHOUdtaG0vV00zbU1YK243eWpnTW1lNWhVb2d0TTVLRUw4eko4OTNn?=
 =?utf-8?B?cXFXTlp0ajNoQ2huNzdDZ0VCUHc2aGhpQlFxaDBOdW9iOHQ5b2VXM0t0TC9Y?=
 =?utf-8?B?aUcyQnRVWWVUMTFNUUlyYWFJVnhvWlVSenI3SG4wbUFpYU85S3VlcE1ITjFn?=
 =?utf-8?B?VEg3RlB6YU1xUGV0ZlB0OG5jcFNqc1RjT3N3THNkZUdubXplUjFRWDdNQ0d1?=
 =?utf-8?B?VHlKa1Y5VmtUUmlMZkJzZnNNcmhXU2U4TXU1KzVRcDB5NjJUL0J1bENOS2pY?=
 =?utf-8?B?ZlFET3VRcmRVSUtuRUJQQVFCZ0FtYURhODlBdFJGUEJvYUozcEhtQXQ0eGpn?=
 =?utf-8?B?clpCY0llWXdSUHBuZVdPOWp5YzQ2OTM3eW9SbTJwRy9lcWpRS01CakFCZDBC?=
 =?utf-8?B?ay80VGsxaUlkeWgvM2kzelJXeDhUQUt6NHM5YS9vUlJjVmEzMkJnT1UrZDJ1?=
 =?utf-8?B?Y1E4WmxBdXBaYjBLeHl3S01Fa0NjVHpZamtSbmV5Vm1MUVlZa2J4MjFRdnNY?=
 =?utf-8?B?KzZCQkQ5M2I4Z1lrR3Z6Zm5iWWhlYzI1T0RsVXg1Y2llYUwxN1gzNXJWY0tS?=
 =?utf-8?B?T01USkdIQWV5cjA4UkpqcWkzOG1NUEhSWVZPeUJzQi9rSmNYQVlaQzViUnIx?=
 =?utf-8?B?a3cweHhYTmlMSTkxZXF2TmljbENMU0dBRTVLTnM5K2l1bklINzQ3ZUI1MDlX?=
 =?utf-8?B?SWxZT1p4YWlreDdTaGYvV2hMa2duNTZPS1ZrNjRWMzI3OC9UcEZDQlBiN0lK?=
 =?utf-8?B?Z1ZLL3c4KzdKbzFVeEU1WktqWHlLVDYzQVkvcEdmSUtKYS9zY0ZheTdpY2Ja?=
 =?utf-8?B?Y2tHM0syVzUrSENLZ05LUy84cXFoQkh1M2NscWJJUHJaWm54Mm9lUWEzZEJM?=
 =?utf-8?B?WU5iOTN3d2EvVFRBVVRsbVo3RnNrblFCaWw4UUFjM0ErWWUrcjJlUkFRQnYr?=
 =?utf-8?B?QndLdzZCQ1VEZGQyMThMbzU4L29McGdickE4Wm5XUWhrSkNwS1JwVEl0OGtF?=
 =?utf-8?B?VXVMVTBUcjlrbllSUFAxUHlsRzNyK05SQlQxcWxZbUx4YW82QzNGcmJ0My9G?=
 =?utf-8?B?NlNsTExxVVpBWGhTc01GQktRbzE3a3daNFp3TFFCR0NOS2ZSa0hGYjBkWWdh?=
 =?utf-8?B?bTdDbS9pVkhScjU1MC9zUEpqU1QvYWU4aUYrMU1pZ3NCei8zRFcwemhURGx3?=
 =?utf-8?B?Q3hlcWRRa1BpbVQ4amcvWGNVRXZkSnJHUllhUldjYWJCS2Y2QitCTnZwd3Ja?=
 =?utf-8?B?bWFtZ1JoZjg4R1lvTWt2OGE2NjVSTFRvYVRWYlFQYWt6RWNtL2VpK3crK0pV?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: B0ymdv+pnIZXBdlHdRhZ4Yeagu+Yt2EK3uYNlMiGbuYGHZLf7bU9pKmxuM/RsZn2USE6NU+DKyrdnbIAdUaFWp4rDCJje/vVDyEhLQYjvRmetUjZbp8jEmQbT13SPpghv7u5w+DiVDJTVpij8X7vgugd7hAQTsNtgsWPVWrtOUZEJa6utvbiO/Z3zW1TsvOe7FZY3RlABX72dhz2YNedHiD7WljzLOcOooQx2tXolp6JyGX5y9gDBBiLSejwd87oYv5PZv7T3hyPQ1jesHdqHeyNxKP2Yos9HTVJrUDzZZo1LOhLVMe6jWw7gzoF1UUCN4BvkWTtzO5mhqWxZxTrasrYVEbKNftwiwYv7E4G42fJEczMd6ylMDXYIZJSl6RZpTGx1BEjoQd5HIuOo4Q4QuwuFIuEU/df6GS/bDBg07LwNfpsR69f70wcCNfb16SmaizdRAlOSUIyCDOxi1sQW8BuTOvO2mSz56Z6k6WXLA6ZAXl6oN6yOuO+jrdTW4EnQ/GeQQYW39/ovk2bkzxLmzR6pGkDC8dm543A5dcogRkmMGw4hLNOImS956Szrwcsl4jRkry2E28oA6Kv5L1+psr0/RZcCJlcy8X52U9qlTfbl6vWxfEZF96mo0qqdqe7MAD3gq96HbyCG+bj5KAyuUuM/OaWvIjEJz3/kBpQwCQo93DGMpdQQyiU8KYDbIHE8/vRrWYJYa6ZTalx/5npffEb4QnUQL6GtCgC4snaRzmoJEUV76uezdyFRyFmSRd9dMqZcZ/e8M8C67qjokcJVQIlcOKEOVPjWpdqHNr8uvLmhP/sHcelIEKdZ8p+F49UgFIZekbpk71eEWezM+8g4/AYIBktCf2Rtl54BNVmxIXEevXlQTGoC2T/CI4ssFKxlKMGInkGrEWxRyfH9ORsA5pi6/d2rDNTLNKd6f0yi6c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169c0152-4f49-4b28-b4ef-08dbc6043be6
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2023 00:36:09.1887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UFR5tr5vynulW1KN2YMRGFssdfJfMgDl9uWRoinJd3tFvwbC78JaIqL8LqQJeb5NvddxEFzMf9lipOfw5QnPGV8CYcNP9/qrBOIBmdKobYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6334
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-05_18,2023-10-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310060003
X-Proofpoint-GUID: zBSRQdubEhLqTA9ujTn3TQ_MTt7CjuHL
X-Proofpoint-ORIG-GUID: zBSRQdubEhLqTA9ujTn3TQ_MTt7CjuHL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/4/23 5:37 PM, Damien Le Moal wrote:
> On 10/5/23 06:00, Mike Christie wrote:
>> The sshdr passed into scsi_execute_cmd is only initialized if
>> scsi_execute_cmd returns >= 0, and scsi_mode_sense will convert all non
>> good statuses like check conditions to -EIO. This has scsi_mode_sense
>> callers that were possibly accessing an uninitialized sshdrs to only
>> access it if we got -EIO.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Reviewed-by: Martin Wilck <mwilck@suse.com>
>> ---
>>  drivers/scsi/sd.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 6d4787ff6e96..538ebdf42c69 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2942,7 +2942,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
>>  	}
>>  
>>  bad_sense:
>> -	if (scsi_sense_valid(&sshdr) &&
>> +	if (res == -EIO && scsi_sense_valid(&sshdr) &&
> 
> 	if (ret < 0 && ...
> 
> would be safer and avoid any issue if we ever change scsi_execute_cmd() to
> return other error codes than -EIO, no ?

If we do that, then we will have the same problem we have today
where we can access the sshdr when it's not setup.

If scsi_execute_cmd returns < 0, then the sshdr is not setup, so
we shouldn't access it. The res value above is from scsi_mode_sense
which actually does the scsi_execute_cmd call, but it doesn't always
pass the return vale from scsi_execute_cmd directly to its callers.

If there is valid sense then scsi_mode_sense returns -EIO so above
that's why we check for that return code.

As far as future safety goes, this patch is not great. Right now
we assume scsi_execute_cmd and the functions it calls does not
return -EIO. To make it safer we could change scsi_mode_sense to
return 1 for the case there is sense or add another arg which
gets set when there is sense.



