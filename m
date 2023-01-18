Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7A2C38142
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 02:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjARCSL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 21:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjARCSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 21:18:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92F44DCF3;
        Tue, 17 Jan 2023 18:18:09 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30HLxCUE003619;
        Wed, 18 Jan 2023 02:18:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=38KoO3Y37lOn7NQo01NMzPOJDWaukpKHJmoOOTORfLo=;
 b=KxrxpbdCpBE2YlozrJCd7GWvrlXv7enO+ZxHXJYgAXQ/QG/cjWG0LLXqscmSWEigAAnP
 yT0eBP5cvlTILmR0Crkb+ssfQQN8FIY1tkR8gu0JLzgIwvB7hYva3+CRSLxpx+BWP7Gg
 KPwU6fr7uQyvs7CrYMv5NhYTqlKBbA6aLVxiD5IxHf6rXaQTamlTMKE5+6TXuRCmZPIZ
 8pioPaZ4ZSC0gXyqOgQLtohBC77PKhX4b4lorJW2fHJxDoZffkEeK1UI+36qmJcd1X7F
 fVfgY6x4uoOZSf7BKcCzc+hZMPrrir66OiTQK11PnTlKut+hIK3qCoH4QluRVv807Y1+ Kg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n3mxt6e4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 02:18:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30I24N33033557;
        Wed, 18 Jan 2023 02:18:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n67nqrb9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 02:18:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isjZnMgCicnqSCvqnzEafhjAgS7rI5p8lfqx2TrwE90ZDr7eAgsq0fwpDLeAURzajPd+NDYTHX++woGusjF40i8unq9u1eHfwdrLmecmr1dRRfekyn+ozrXk4hyUtsL5YYQyUpm0A58o8bDtX8Errn9GhsGVmOyrNNkFhcC4VirfORFavJ2D0eXZ9HSUqNb8WEDdGp95BbylSOleWJiK0K6mGTYKMJCFWtf8/jXwChwRYhdIQykKr6D1j6vBbSCSg1viDNHnIV2/4Xyd8iX9AP6jwUdjs5viR9w3b4qy/bMEKpBwl2Q6Gtv5qbagohDQI9NLmrG9Rev5wXodW24YYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=38KoO3Y37lOn7NQo01NMzPOJDWaukpKHJmoOOTORfLo=;
 b=mYD1tNck8dI6+45hXvAmXqLpC03sye7WWrwO/Xz27vNjpZ3oeutoNImt6469dY2AYmK/SS01WzvR7CcXTACvIJMDZ23oFmvxp+jCjBKgU6nLqQig6x5iWYofL5FdGDy/Aha8HUowSEwU6GMLsDOVq8F0mT8neMim80c9tbIIMg5o/u+NCXD0SLhXVuG2JIx/A5P0/vTdl4CgR+xy1sum+/YTFN59WVNdvO0IJ+7g9PxsXvv7AfLuTbQFAdBkbmapP7iSdsAM3sQg7CGQfktM3qqFU92ZOOSh0OzVPdi5Z+VqIh7vSLC9igxxsdjjpO1ykXLiSJQpKcDTXml2N834+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=38KoO3Y37lOn7NQo01NMzPOJDWaukpKHJmoOOTORfLo=;
 b=qxRRuA6fokzDCgAdVTaFRsYIn9gkVdHucXJQtQdrIxp99SVnAcwcPhEztD9wacz7vkiRdJ0Wa5y/Gn2F55ROspycl2YZH+GGjtBQDEC5y8PFRFn2Jq8BBJgxMJ9T/NCtyj+ivO+iH+ndR3M48p597S808GMEy6+BnbBElKQRgMc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB5771.namprd10.prod.outlook.com (2603:10b6:510:127::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 02:14:56 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6002.011; Wed, 18 Jan 2023
 02:14:55 +0000
Message-ID: <e21571bf-2244-7b12-9765-f3ebe3a024ad@oracle.com>
Date:   Tue, 17 Jan 2023 20:14:53 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 09/13] scsi: target: iscsit: Fix isert disconnect
 handling during login
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <20230112030832.110143-10-michael.christie@oracle.com>
 <20230113140816.GA31614@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230113140816.GA31614@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR06CA0031.namprd06.prod.outlook.com
 (2603:10b6:8:54::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f093c6c-0001-40a7-2efd-08daf8f9ca53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KgqTqXSO7wWjcv8AVGFChSpH9ZlXRQKZ4pkUS48K8kJk+716rLLTssFysPW57r5lv+z5NL9bh8+cdt1ztgoV26H3Yqtg6lKIEdgGKFooCLJjW0RmATIaQvf3tssJ17/itQVroCKwHTKEfVvPbp2Oa0n2PYtnhkeaN9HStHlvOrTGSb7/mpP89wXFz0XKZ22IV4h42ARYy4dSgqFhgIzwbJ2UCFB/kwMHkPStLH61nspVNFQj720RyZ1w2qrBkGfBYNz7qegWL9gqL7ElBv467qHCG+2hD0KY4Wn4JGhjIs28IFDTvNDlPrh3ReAee+18H5i5yagIepLn/57xSfRZooRBrDjvRvUUecLPyOFrkwl6I7P18iGccqVGdjP9hB9zW/MrEkdtZKI+EHbOwl95MxbqMiD89vSPvWR/PFLHZaxp5GyI6+/Ntrk+RDkb3jjoRJ2gAY1BVj77KOldTnDcgCZDLE1+IdRBxfpbYY0ii2fnQp4NPCxj2Sq4HhgDbiQDULgQ3un6sNHvXdCTcHX7o9w1ELNH8pvc8xMS4mKmjBXAQ354x8OmX29x2MmkjSXCNnfmaKfNTAVTlxFeqTlM9iJkm6qrSMbNc6H4FqLBELkqT1Y0GK/l8giS/qpua0M6iKVsqxS/oP0jH9w+LiTsCErJdZVPmTby9+OtrXqka2QEHa3zz5p6Jdc8/Ud7S3rX6F4pwrBv044LsfvHaM9mkGlWMbVfNwBjcZNw8RZrhCo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199015)(186003)(2616005)(53546011)(26005)(38100700002)(6506007)(6512007)(83380400001)(86362001)(5660300002)(8936002)(41300700001)(66476007)(6916009)(66556008)(4326008)(8676002)(66946007)(2906002)(6486002)(478600001)(31696002)(36756003)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NG9jNGduN2l2aXV2bmQyU0dhbWFLbUZYbnJiMzc5RzNYMUNSb3IxV3d0VUVF?=
 =?utf-8?B?U1c4aTZFNXplT1RvUTdVUFoyRFBwQWJ2NHdOY0lKQWdSQThuSGtNcmVyYlJP?=
 =?utf-8?B?WGV4bDZNcWNYU0psaGdCZTdneDlDVnRXT1lQdmgxSXVva2NYV0QydCtPOCtM?=
 =?utf-8?B?VFA1ajR1blE2NkJYZUtRMkhOTFpUQ0xiWUNEb2lEUmUxY01ibTZVUHQ1WENI?=
 =?utf-8?B?RDIzdGhtZzJnNDQwM3NPNUsrM2dXMG9XTE1ldW1xK2xqVkYxM21QNlFvaGxq?=
 =?utf-8?B?V2I1bko1MlNqZWlLekZZQWdnNUw0MzZrMmlKbm90K1BLUE9IRk55eTUrNVRY?=
 =?utf-8?B?OGdlSEI1UzVSS213TlA0M0c4U2tZZ2tUdVR4YlZxaFVYMUpmOCtDMEhjcnhS?=
 =?utf-8?B?ZmQ0aU1iamdpWm5acnRPRC9hTW9keWgreEtod2N6ZG1kQmREdU5VMTZXR2lr?=
 =?utf-8?B?ZzdaKy9haVZHOFhPWGZUNTlMVHkzeUpDZk04WEhvKzkyOFBoL2NXcTNJRTdW?=
 =?utf-8?B?bjViWjRkRHdYcjZsaXpLMkdkd0dadyt1TkpwTUJDb1V1b0VxU3VHMDRRM2VM?=
 =?utf-8?B?c1FSeitLWEhHZ2tmRVJvajBINDA5NUY3ZDdKMXJKVENRdTRRTURzMUN4MklF?=
 =?utf-8?B?aUhmQjZkN3JRei9GY3oybm9sdHdyMmpsZkJza085TFRMbGdDd0djOHppQndK?=
 =?utf-8?B?MXR1QTY1RTRBd0lacVhQcWJzMXVTM1I0dU5kU253WlUzMHNEZER2dml1eUZo?=
 =?utf-8?B?SGJuN0p6YjNETTNZeWw3OEMvdk9tYnR0UWx0bHFpSmFzOElYTlNlYVlBdW9U?=
 =?utf-8?B?NGFjRG16ZHpZemNPK3ZDOXllZkFYMGNSZnA5L2RlTGRmZ3UrRDNXUkRMYWxC?=
 =?utf-8?B?YkNhMUUyVzdZck1uWktOZDRWVGlkRWFjalpjY3hwSFMxY05BVExLQVZTSVBV?=
 =?utf-8?B?RmRFRmlDNWZFMWdKNklCK3BiMkxtQzRldGR2ZXJuSkNVUE9aay9SWmxZM3Nl?=
 =?utf-8?B?emNhMzNrRURpOXhOb2Z4TG0xN3c5b1dYcTNZcldnK3NYWGRWRU1MV3lrMm44?=
 =?utf-8?B?NHhTbjV5S3Jtd0JOOUMvNThQVFgyNUhTMmdLUVRvUWNPVTQ2bXBMdUs4VW1Y?=
 =?utf-8?B?ZlhqYzVhc0NYKzJYenhQaVgvTnZxK09vdWJMV05PUVFPQ2VJZ0VlVDk0ZVVp?=
 =?utf-8?B?alp2d2c1elYzSmszNFdCZnY0WkNCeFN3bXJGcVNPREtHRkUzUkRvY1pSWG5L?=
 =?utf-8?B?VmZJd0VVUXQ1SHNFSnh0Q3BQNjg1UGtDeHBROURDM1lWU1UzdlFQZERzS0VS?=
 =?utf-8?B?RkU3c0JpWU9WM3IrTm9wVkFxNGJ6SDBuVW9iL2RsbnU3NkZLL2hOVkhSZ3ZO?=
 =?utf-8?B?OFE2RXFDemlQekNDZks3ekRSRzNTbUpQV1dnY1AwcmxFQXUycjZYbHJyZTNJ?=
 =?utf-8?B?TURsSEdSSm9Ia2tjeEFWUFlJV3VSalprb21oL2g5OEo2OHRRT1QvSThRU1Vy?=
 =?utf-8?B?RmxYUEEza2Q0cXhCd21lWlpTN0wwMFlSTUJiZ3JrTkpHbTdZMTVMMlNaZWxy?=
 =?utf-8?B?ZGxrS0ZIc1dpOFJBSTJKVGxaZm1UYXRzTDJRb0FCYlJ5Z1ZoY3E1MzBiOVFa?=
 =?utf-8?B?Qm1JWDJxanRyVGgyWlRjTDFaWFdIK0pVaDJSc3p3aWdFOFRoY0RUTitJckxK?=
 =?utf-8?B?dmFNMGxGbG04bGxXR2VUMmdQd3dLMFdkNys5cW9QWTlqeFRqSmQ0RjZ6NlJM?=
 =?utf-8?B?N3BxbHhNRFIzK0ZYTDBJWjRVWHFwd0FXTVhZRngwbGxiTUFxWDBYeXcwOGoz?=
 =?utf-8?B?cU1UYmVESk9xWktuS1A4R2kvb25EejF1ZU93QmZhd085U0xkUWhDbVNJdTBW?=
 =?utf-8?B?bnRIOHdzNG1RVUpBWlNRSFJFUUc0N1diQ2VsSEdRV2k5RCtXdWVSMm5MMzls?=
 =?utf-8?B?R2hKeHZMY1ltait1dzFWR2pVTXR6UDliQUYxOWlScFdtOHA0aEE4WUt2RUxC?=
 =?utf-8?B?K1JsYmo3YldCeHVHT2poUE8zYk5uZkhWRUw5L0FMYmlQTW1jT3pWbFNaZHNP?=
 =?utf-8?B?Znp2NDRpREVrTk9LMVJPQUZxVmd6L01HUSsrZFRhV0VOYWF0djVTRlJBQUE0?=
 =?utf-8?B?L1pGdDFHWmZJVHFkRzJmalA4blBDaFlVYmt4SXY0d1FrMVhOUk5OZEF1Lzls?=
 =?utf-8?B?Q1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rzRPo/nJ6dx7AqVGNbZZjPjVP76yy6WMh2o5dCcxn4TeEpvGBjDGWGqtTPXz+aqVw/8NCJ9/1bv4GrIj3ccnn85STe6/ctOavIweV+cE2eCIakEwEOHPQBq3m5Ce66Wbm/RHX1NcSZY63yBNp9n/RLHUEL1xU1lEXp43gqS5SH6agL04JmSGb4cfTaUhMbK5iB871FTjxKYJRPAtEh13egsL8A9xcT+2AmhvSL5U66poN33Ryz+pv4hMq8UHCSdGul1S4p8jBJdfsqvoM+W8TrhsWp9nsHJVDNzXzXmQ5vrAiPdNca5LLnwYJIiVZ9zBxANcW9rxdSihJn+owlxNH/KkctEAU4C1KEalzbUPtOOremIQsAlXW81HmDWeMCAaHVy3vdAe2YIkPEDBGUuM7qatfGRFntVkPePdgN1kq/DMMsHhWFCTTw6MJyJWVckDFbKwCxyWsIhF3Z8QllgpF2VQ23z6zgjjYhlmq/7hAPUBoGxQbFbKHVI0JzhsFu4IlFRHsr5vPrR/Ucr8nhq5VNFMP8JRX87seS0ehc3ACdqsmxzLuhMt5q7e+PPLNaaFv/bWYd+XYPBQfZ0YS5a2r6rWxNxlOdtQqTdi/XKdX+QR3yJOMAUv4XT25ADFhSSkQ5UtJuSnVjsc6AGyOZCByeSByjU9NnAFRDFzpL+FUDZG8LPBFceVDXxJdHcO8ilynIy+Bhb2T8g5k2jK23cF8Ik72uBxj5XQ000xtNdN4EVh6kN75QBq8x88QKv+ARNnl9jZwZBUNxREvloqpuYNLPOJ5sIipltjppqOWPsB949mJRswNG/R0WYUCV1qEGQVbkoHjgxFaVklvHFDSHtR/Dr05Ha/TenkylOJUQHVQHlwhoArFC4/QQCdbmLhxzDl
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f093c6c-0001-40a7-2efd-08daf8f9ca53
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 02:14:55.3528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFu/mlpVnxi0hrC/ZgnFNxSi3vdNercUCxdflcZG5rQVqcqyxArp9+Jf9hADMjAoFXPjF2//cvvUN03Q/yvQYIIeoYuvwnbgJNrnScO4k9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5771
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-17_11,2023-01-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301180016
X-Proofpoint-GUID: Knq4RteZ8k6E405Q5HU8vhxOyffrSKx9
X-Proofpoint-ORIG-GUID: Knq4RteZ8k6E405Q5HU8vhxOyffrSKx9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/13/23 08:08, Dmitry Bogdanov wrote:
> On Wed, Jan 11, 2023 at 09:08:28PM -0600, Mike Christie wrote:
>>
>> If we get a disconnect event while logging in we can end up in a state
>> where will never be able to relogin. This happens when:
>>
>> 1. login thread has put us into TARG_CONN_STATE_IN_LOGIN
>> 2. isert then does
>>
>> isert_disconnected_handler -> iscsit_cause_connection_reinstatement
>>
>> which sets the conn connection_reinstatement flag. Nothing else happens
>> because we are only in IN_LOGIN. The tx/rx threads are not running yet
>> so we can't start recovery from those contexts at this time.
>>
>> 3. The login thread finishes processing the login pdu and thinks login is
>> done. It sets us into TARG_CONN_STATE_LOGGED_IN/TARG_SESS_STATE_LOGGED_IN.
>> This starts the rx/tx threads.
>>
>> 4. The initiator thought it disconnected the connection at 2, and has
>> since sent a new connect which is now handled. This leads us to eventually
>> run:
>>
>> iscsi_check_for_session_reinstatement-> iscsit_stop_session ->
>> iscsit_cause_connection_reinstatement
>>
>> iscsit_stop_session sees the old conn and does
>> iscsit_cause_connection_reinstatement which sees connection_reinstatement
>> is set so it just returns instead of trying to kill the tx/rx threads
>> which would have caused recovery to start.
>>
>> 5. iscsit_stop_session then waits on session_wait_comp which will never
>> happen since we didn't kill the tx/rx threads.
>>
>> This has the iscsit login code check if a fabric driver ran
>> iscsit_cause_connection_reinstatement during the login process similar
>> to how we check for the sk state for tcp based iscsit. This will prevent
>> us from getting into 3 and creating a ghost session.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/target/iscsi/iscsi_target_nego.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
>> index ff49c8f3fe24..2dd81752d4c9 100644
>> --- a/drivers/target/iscsi/iscsi_target_nego.c
>> +++ b/drivers/target/iscsi/iscsi_target_nego.c
>> @@ -350,6 +350,16 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
>>                                             ISCSI_LOGIN_STATUS_NO_RESOURCES);
>>                         return -1;
>>                 }
>> +
>> +               /*
>> +                * isert doesn't know the iscsit state and uses
>> +                * iscsit_cause_connection_reinstatement as a generic error
>> +                * notification system. It may call it before we are in FFP.
>> +                * Handle this now in case it signaled a failure before the
>> +                * rx/tx threads were up and could start recovery.
>> +                */
>> +               if (atomic_read(&conn->connection_reinstatement))
>> +                       goto err;
> 
> Why only for login->login_complete case? In other case the session will
> not hang? Will it be droppped on login timeout or something else?

It will not hang. If you hit an error with isert before we think we can go into
FFP then the login timeout currently cleans up the conn and session.

> 
> May be the root cause is point 2 itself - calling iscsit_cause_connection_reinstatement
> in not ISER_CONN_FULL_FEATURE state where there are no TX_RX threads?
> I mean that was a misuse of iscsit_cause_connection_reinstatement?

Let me drop this patch for now. After writing the response above about normally it just
times out, and thinking about your question here I think to really fix this we want to
fully integrate isert login into iscsit.

The root problem is that isert login is not integrated into iscsit, so there is really
no error handling. iscsit_cause_connection_reinstatement was supposed to do it, but it
doesn't do anything.

So we need to separate the LOGIN_FLAGS_CLOSED tests and setting from the iscsi_target_sk*
code. Add a helper to set that bit and do some state checks, and make the checks generic
in the login code (not tied to having a socket). Convert iscsit and isert to use the new
helper. Then handle the LOGIN_FLAGS_READ_ACTIVE/LOGIN_FLAGS_WRITE_ACTIVE and login_work
stuff. Then review cxgb?

I'll do that later after fixing the command cleanup stuff in this patchsdet and the
other patchsets I have outstanding.
