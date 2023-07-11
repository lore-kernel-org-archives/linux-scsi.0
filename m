Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0C2BEB64DC
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 21:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbjGKVug (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 17:50:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjGKVuf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 17:50:35 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1807E10C7
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 14:50:34 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BID89a010886;
        Tue, 11 Jul 2023 21:50:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dlwWVv11lwxS5rhDFdDl40e9qzjFW1RBaFwiDl+fWLY=;
 b=cWXCjQbPZ3aYAyU0Iq96ZGqERoKOSP7hVHC/1qIZ5oMg7NACocendnwB/ck30qF2RlvN
 rdiwgG8ovDTxEZb8fUN3rAY0l5ln26uT8KyAscOLTK7SEnzmbOq3JNleykrQp0G8fX7a
 LpIb1ukWPddMlYiswLaBWz+Xxqus53DwCnmN3LI7oVAtfMvQh+3fkTYROoz1CBZFM8Gt
 AVRII8qtgOrlmuvUVKlL5BYwc50yv415fQNjtszWqRed6DL2W0NC+yRJPbsGlKcyYUKw
 +btYwB5v3YAIRG/feOFRXTkXoPCcdwu41CO8O0rLyaFn1hldMRm3LryiMJfEkG1NLJ/m aA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrfj63wwq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:50:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BK45ST007066;
        Tue, 11 Jul 2023 21:50:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx85h54m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 21:50:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4gJ1y6w3UW6n0UfyvFSZ/kApl4EnCvu77i9y7Nn3QnDDuRAsdSS2kLluqpDaim4gJKJj0pHVpkUIRMyxKWzPRJ2R3IV6zVjKsTfs7axUkgH5ILOED6cmVNeu45msIbL8UjT3PR2qvoqGAfBj7Wu50YSKzizlB4DYPRwHQ9WaHnyuOAILnGHN2JV/cKBQ/N6ItShqO60mbU7jEZox9GEO8LiEs0E6KfBkFfJ5aCs4UMVMdGFF65QqMNDhHUjdF4vgYMEKt3qsELgFt70ktwGqgWILnirjPJFysKi035jEiJZeFqP4cgZMrF+TDeqQk9+B1NWXN2P23FfeGMKchuQyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlwWVv11lwxS5rhDFdDl40e9qzjFW1RBaFwiDl+fWLY=;
 b=cGl4Im9t1+o1NWk3L3S3LTfgfeIXW40mCiyFhOHYtH6Gp0sv5vP0oRjiKc5tnTbWSGbYo5BaQDnpPIS9xZFzbA404e7NaRewbjoAzxAni/nrudptRuTZL893yNah3QPlk8wWXWcvyANbLWK9s4bwofgUU7LPmYBwoxp1x0njx4KgYCphw8X7+x/ZwDFv9rqThG+0tlkCEIOYLxRNQIHjESyMZAiPWWeCKplwEtAMrHO3fVDL7eQ/8y/M1zrKwSlYRupixx/vbAtgV7o/08wRN3aWuWto+INHIwjJXv4TLLk4EerP1+O62LRfOfK0/CRjxMtw1iZ5EWbyhscvpQ5FXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlwWVv11lwxS5rhDFdDl40e9qzjFW1RBaFwiDl+fWLY=;
 b=QuZsue1QF3K7zQMn4IpxXBwsV3hbn/HoUif3wpp1MC8ZcjZBfNPjfriclggfetG2Nv4cjgNka9T7LURPU+p1nfHLscV5WcqNWsF9KePw1h23snLgx1XwjlRPYg5WbX2fPDgMsPs/4DwH/7XamRA5psISSLbb0+4wpoS+siz3jYs=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB6950.namprd10.prod.outlook.com (2603:10b6:806:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Tue, 11 Jul
 2023 21:50:23 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 21:50:23 +0000
Message-ID: <5331d223-6fd0-d9a8-86be-469285010010@oracle.com>
Date:   Tue, 11 Jul 2023 16:50:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 00/33] scsi: Allow scsi_execute users to control
 retries
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230711214620.87232-1-michael.christie@oracle.com>
In-Reply-To: <20230711214620.87232-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::22) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: ef136277-0675-40ba-a743-08db8258d442
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iDDK/e7dTGKhionzs/Phn/48HEtFDMotwTwT0opZMhXXlCC9U4jrhNQPfs5yxEHBr0E63wSejs9HATkfyvTtDzCpdjzuJb01ARSm90TZD2lo4sb7lMZT+JaFasB3S7idbBjcSwz2OQhU7pkvFlugF2lpmvSv9DIEcdhfTau9bSh36V0V3OMdfhYx0CXqne2AC32IZcDuGsnRBn1gEIJBId8xCcQ9EQCgSXKCnGCQsCMBGgngnvwzTkseibH8JDf8SnpSqpJneojWxdCtmsyXhpoINhBs+T9v1dCZ1E8DC2nFac7GaeXFIjTIZxtTj4cmG04n3RRZE9MRQywEgg+p/zcJLekH/e0M7UT2Vp3rZ3NgYJivDKjv0rNkVlhMN82pLJ+um2irxBOWukgPoOuD/jrY+U5RlIbBvfoueuWqsksds7W3UnmWKhEs0mMAeE+/vLdhnqZ4mK5Tzb90PDPTQPtcHRZ6oahQFUmZY7kzqpMQTn8issnbG/24ymFMsUOzeYTFvA2l3+7EDl95RucOERgShjU/Kmv8t440pBCLq7TWNhx0heLPlAqlRPXUjbyzputFmAIBr2NAE0NAJd2qs7qjxRu253m5M/gwFPV0Gyj9RL204n7I5HymV1iTPUgwBez/FgUVOlV5/th+ez8rMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199021)(186003)(6506007)(2616005)(6512007)(53546011)(478600001)(26005)(83380400001)(4744005)(41300700001)(5660300002)(66556008)(2906002)(316002)(45080400002)(8676002)(8936002)(66946007)(66476007)(6486002)(36756003)(38100700002)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGxSUkRWelNFZDdsb1d1aW50NlVZV2VOZWR0SXBGOEFjT3R1eDFSeWNmQWJI?=
 =?utf-8?B?MHk4eTFSMDh5bnFxOU9BeklLSGc4S2UyL0poWFRjWnV5WXVFY1A0VzlJMmF0?=
 =?utf-8?B?cS9aNVpxQ1YvWVpKYlV6Y3hMOU1rSjBscXQxVzJPTFBYMzJHS0xyZ1JvOHE5?=
 =?utf-8?B?Qy9BTkFsSjN5SlM1aUdmNUNocVhsVFRCcHVHcmN5ZWV5M0lVSi9xTkRINzd2?=
 =?utf-8?B?UElhdnNPcndOMWlnTHQ1UGkxNGkyaVpYT1ByaWpzYUJYQ2o1cWZjeTJ6Y3Ji?=
 =?utf-8?B?ZmQ2ZWdTZlB2SGxUV2FjYXBBOXh0dkFzM1hKTXRSbmRTK0NXakdZZ0svUm9I?=
 =?utf-8?B?MHdlMURId2dHQlZhTVIzdnV6enpYei9JdzVYT0kvUjhmUFJPczlhOEd2SnNy?=
 =?utf-8?B?aTlyZlpreGdSdjY0dHRUeGcweTdGVDJzSk01NU1CTm1TWU8zSk5GeHExZ2d6?=
 =?utf-8?B?cUovV0JNVHRPSVVSWnd1eXYzbm9QNHlZZEI4RFpqZnBOb0Y4cVkyZkc3dlNQ?=
 =?utf-8?B?UnF0TkdadkI2aFdpeEdqNTdiL1ZGLzkrWkdQTWxqSWR2RTcwc0pQNWtyb1d3?=
 =?utf-8?B?WmxBNVZOeUFmbVVjRy9way9oRW9lUWk1bGJhVlRCZkFtTDRoM2lDM3U0K21v?=
 =?utf-8?B?cCtuNVJoNy9DUFZPY0NxbTVRYlFjR2ZOaXY4dUlyVXMxYnRKYzl3Skt4djUx?=
 =?utf-8?B?RTNIbHNxNW5INFBuVlFzU21KRDU2L1BMcC9WbTJLczNXYU9XeFNPRm1lMHdR?=
 =?utf-8?B?T3BYb3hmS0hoTHhzUFZva1o3eGtnRVRsSkh1T1M3UkYxNk5wTnJwWmRoTU8z?=
 =?utf-8?B?M1lyVytXWTVYeW9iRWlLek5DQkxoUDZ3WU5XZkR4aUJ3WGhrRmw4UmJkZmFK?=
 =?utf-8?B?bmFtOExCenpPbzl5ZzhabkVwY0trMm9LOEJEZFVjZlhLNUpYcjZWM1VRRGgy?=
 =?utf-8?B?UHM4MFJZQnZzMGpQS2VnSUsvak4xNFBwTnJlZnJ5SDJNdC9GYUVrQU9UL1M1?=
 =?utf-8?B?bHJ4RzkwWkg1QnIyQXZRVytDZFU0dmFhdzZTU1BSdUNaZVFTT3kxMVk5UTVV?=
 =?utf-8?B?ZHhFQjZ2YjZRQnU2cTRlZkVzWnJtWVpMYUZVcU5sdHJ1UDh5UE5EVWtMeVJF?=
 =?utf-8?B?Yk1nTlVDd3dHYXF4Ui9ITkVLVEVSbHdPbzBhS0huWTZvenh1aHBFbmN2eHJ2?=
 =?utf-8?B?TUY4bG9xZHlwYU5PdktvekQ2YTAzTU8rR3dOZE81T2lXZUN4VmdoRXdTOFBJ?=
 =?utf-8?B?MEhXWDVHTVVubmkzais0L3c1Y0VnMzE1MHcwNWNmdDBtYW9lbzdzVm9XNjZ5?=
 =?utf-8?B?R1l6M2oyVGtIc1hLMi9kRzZUNk1zNnlXOXlLWXYvYWJnYkVoN1BrbG8vUmZi?=
 =?utf-8?B?amFjcUFXU0trMzd0a1dGSmt0TTI2Vjcwc0l3b1pnV3NyNUpVUkJ0aHlrUS9X?=
 =?utf-8?B?SDZNUmNFUFc2ajFNM2w4THRraWpUZ2FiS0wxM01tbVlKV3NhOGgydjNKbCsv?=
 =?utf-8?B?RVpaZnBnazlmZnV0cFhmakEwWFFvdmN4bGUzOVNqUzg3b0ovY1UzRWNpSEJB?=
 =?utf-8?B?eEZlOCtvMzloQkNhUW5ZbVJmRi9qTkVqamdsYWt4SGxUK0hIblNQWTkyNE42?=
 =?utf-8?B?TWdpVkdyQ1RjWE1EOURUcFQ3Y0hpY0hSVTJLSmQ0Sm9Lcjg4RWJnLzdQVjRN?=
 =?utf-8?B?ZllCZWFxM0dRU1J2QXFHOURXamxTMlc3QldCS1NDdzBLb2pUWDhaTHhUZ0dZ?=
 =?utf-8?B?aWRycTF2L0JtU1NBbzlVNW9aaThMNjNuMkhtQWJybFo3VFNVczc1VnJLOFNX?=
 =?utf-8?B?SnZMUVd1Lytia2VjSnFuaElBZ2hqTTdlbDE4RTI4YU9ubkFIQmh4SGZ3TTgy?=
 =?utf-8?B?Z2tVSXdwT1d3K3l6WjM3Vkw2M0RrYStuVHZlZU51Wm05Rk1mNmthekR5TWg0?=
 =?utf-8?B?eFh6NTlzM1J4QUJucEd6RmRudmJVM1hwajRiWUJ2K0NQQXNuN2EyaFNSVjJx?=
 =?utf-8?B?MHhWWWswVDNEQ0NwVExSdlR5T2FYdjBLbHUydkF2aHJSZmFGbnlmR1M4UFEw?=
 =?utf-8?B?d2VsemNVaERla1o4RHZnWmgyY3ZTb0NHMkNuaExNdkEvcUNMZHNCeTltNi9Q?=
 =?utf-8?B?blE1RFVDeHNQRzdPdGluVmNNakhrNHVFU0Q4c2hDbXJMUzZrc0FYdnl0NFA4?=
 =?utf-8?B?VWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7q30ytZi2qVeOWW23FoCI/NouCsCNmijH/JVJDFS+ZUi+/CrkFWuiBDzCkZi8u17PksjvlKUmAD+OV5Ud/4HZ2mCKzdCiJrrNGcAU4Z8fRy4hdkRjFnJ5sIvfNUeezSCzUdq9SWlErL4QzkGbkm/4ml3iGHOu4gBUt0J8It13E28oRccj2V8AA8mefojOWrlX5ijrOI+3WIIFD0SkQFOomeHVYD6/kA2K0EdNyUsudAzbnWxZ0gynPoaRmn5dk+Z9n73MeNHArcfVQUICSwJO0BvBKP7nIy8LD+rqnHyvn4zge5p8PeF6Vjo6/wFdxTKZfcUpq+GP/gtmDx8fkMAVKoE6Dx0vKjj8if3vAdBi1n5Kilkn5W/n/zgpJjlZDTVqOET9n+e4VVT1GpRAO0z/uIqfICSvy6jG6V4GpmSNdkNjmiie2fHL5iYioPBsHznldi1c4Hw7Z/3BUqsaGZfUHKRJeJdGofx1XhSL7alkVfjOxtEwqvnhESF7dt6Uf/MwsAVInghELfGN7OPQ8kkf+9T6UKmrqVROGilkH8bcHkRFa+FGdZ8/Zv6Ix8liPmYdmw52vIrD+qTq3khD2bigTOWdC0uVGi6LzVhSmViXFpDe3NeF9YOTg0p5r6iETF5ddBKGoq1J477/Ygd2FV18Dp4fxNxicv8p8rTwEZmyBs38vKrv99YLupBb5P3kh/cWF4HaadvRTov5N3Wgsa7XMKn8j+5Bc/UM2neM/WZ+RBqdqQ7BhUTlsjwK8aFfECjfSJJE9Tpv9AS7HWVFgYvBlsQ3xlJ6t6uUhCyuhlP03lQraZ8CqEgMtKyY3+8XZDpXaIEBLrSJdTbHBKvTPUBzMdALF2NqkdOqXWGhx5/4pLbF4zNDp/t4ljCzra04o2i
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef136277-0675-40ba-a743-08db8258d442
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 21:50:23.4313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SZdMHd3MvvStf578DMS5RIQQlc6tC+QtTxAj+HbwHLzSTLfobXWzEwzyGIbU3KQOEclBJ7BzKZ2mq+OpnO87BUSVJ0FH07pQx+sf8IKQpYg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110199
X-Proofpoint-GUID: H5YzLvhSDruWz9AfBH4wp2N1Uhj4-84t
X-Proofpoint-ORIG-GUID: H5YzLvhSDruWz9AfBH4wp2N1Uhj4-84t
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm sorry to have to spam the list. While sending this patchset
outlook started to return failures on me, so only patches 0 -24
got sent.

I'm going to look into it, and will resend this patchset when I
figure out what happened.

On 7/11/23 4:45 PM, Mike Christie wrote:
> The following patches were made over Martin's 6.6 scsi-queue branch.
> They allow scsi_execute_cmd users to control exactly which errors are
> retried, so we can reduce the sense/sshd handling they have to do and
> have it one place.
> 
> The patches allow scsi_execute_cmd users to pass in an array of failures
> which they want retried/failed and also specify how many times they want
> them retried. If we hit an error that the user did not specify then we drop
> down to the default behavior. This allows us to remove almost all the
> retry logic from scsi_execute_cmd users. We just have the special cases
> where we want to retry with a difference size command or sleep between
> retries.
