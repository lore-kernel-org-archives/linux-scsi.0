Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64484CD13CF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 00:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjIRAfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Sep 2023 20:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbjIRAfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Sep 2023 20:35:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF24411F
        for <linux-scsi@vger.kernel.org>; Sun, 17 Sep 2023 17:35:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38HNNjGt018394;
        Mon, 18 Sep 2023 00:35:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3iH2RwEpGZNXmEX9dM0vyjgPbe6h3KCx/wNOVm9/vbc=;
 b=pcVCrkkR0TnTi7KgoPoQ/XLEuZo8EGg8fiebuACBfe6aXRxszUuw0ZIQglHo9kGLI2aD
 YJO4FrEVkStUJDUL5SGI3aJRVPLkt0F2sW9aaUB9K4LB/MhpIprpOaxUVIcwQIZdJTpJ
 nDArmhMxgM7GrRS9m7uNPmjEGyMUv5PmRuAndO+wM+98cVFMqVlT5B11JK6Pe1kKzV0Z
 yNhZj3zVkPZxcKOgz1U+G/K/JgAeHVepHynZrMiukofbpAVg6WJOphFB6nCcKOnMfXcV
 HC/uMjoPjqiU3A2chHaarEkh0Ec0wMcBSYBFqygLKX7Y1IT6TT1l0MzagKLPa4qWRGcX Jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t5352sn5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Sep 2023 00:35:13 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38HMK5KH027105;
        Mon, 18 Sep 2023 00:35:12 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t40dcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Sep 2023 00:35:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzZ0Lamq+AiCQwhBlmGqDStdMtqaCwLYx6QqwOeSTnl4qM7mrNPPCxqcVliJDxhLDBGCk9Sgm6XiVsmZRVMus1NcnN8xVJuYW/MEQ4CLHG5GUgfrRO1HvtWOtm3n8GtvGtYRsTPklTPQ8FDeiESrepwaoRAYLNy+Q7WfFTnDO0BII1el6IlDHhqv20WuwsqEY6ntSn3/cKIZB1spFxeN8qdZzisGKCA9eibn4gq11Vgsi2DJcnBjWMusX2bYgLzTxKPe64Rh8o6/LrunotyEIIcUIFLwlzQTitMzN2LhMo7Fl8y9pX1EIW0fbmZ4kkF+sYdVmP7bV6VY3I7clNCYhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3iH2RwEpGZNXmEX9dM0vyjgPbe6h3KCx/wNOVm9/vbc=;
 b=EHHtO3HQTehnXG0bebpK+DTQzIONztbG1GMaak+XeDzhOBzVA29NHjvuLVT1HBDKdKMPmQt0hj+eDR/jKW8MyLrwMygeUyXBgWz9/swgJ9EUFfw/PLY94Ovq/UEGnAigdj1Ui4LmuP1vQfWo0sF4KLtwg43UALkzwPAWiurkU2o1wu5aCHXg06xHv5CAZ1yKZ1RsaPr4pfmcztr7qXJfQZs87eUfM7msVpkzBdI7R4hP8+tg2rgUi5OPO3eMrcNALlokpW6cUgJF2bI7So4VV/fQY3uw05RT0BWE1byXaH9vdLCG4ZNufDUdqeaXynwwZjpB0r/QZOIieUoAXxYT1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3iH2RwEpGZNXmEX9dM0vyjgPbe6h3KCx/wNOVm9/vbc=;
 b=vZEPV/Tf5a8acEP2cUVCTcAP2hXu2H9V6yeHZQqhgzbgW7J/3vVPxu30ykJEBkMT+hUbN4ajE17UZNsofFNBmk/BwikN2/8tytkDJHX4wkfZuEnsbj4OLZ+5AVC7e6idJm99BVFqiFRkrfUYsyEov/BaX7bOyardAZ4hVjErkRQ=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM8PR10MB5399.namprd10.prod.outlook.com (2603:10b6:8:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Mon, 18 Sep
 2023 00:35:09 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 00:35:09 +0000
Message-ID: <64399d0e-dacb-4789-b37b-938a5e98eeee@oracle.com>
Date:   Sun, 17 Sep 2023 19:35:07 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 07/34] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, john.g.garry@oracle.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230905231547.83945-1-michael.christie@oracle.com>
 <20230905231547.83945-8-michael.christie@oracle.com>
 <d3d8bc89e45708cde24912b497348f12c662f45f.camel@suse.com>
 <8d8cdaefa944afd3c478ffb77570cce53f7041c6.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <8d8cdaefa944afd3c478ffb77570cce53f7041c6.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0096.namprd05.prod.outlook.com
 (2603:10b6:8:56::28) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM8PR10MB5399:EE_
X-MS-Office365-Filtering-Correlation-Id: eacc224b-de66-4124-7d90-08dbb7df1c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rPmvflrmYhZA7paiJQvUwOwr8fpi1U8b524l5DdWTxEqtMNcaK4oaiyNifZ1dcJ8ad9Y2zTn+Hr+r/r/puTW7wIN4+pqTnakX2gGSVWg5cT8VrhfPrXY4TLF15U8g7pmXzHc+7ymMBd1QNLwoHjJ6sZaEGpKqK7g5gChrBH7dHo8OmyGM3LVpDRWR/wLJ/xO7lp/vBRSX8PXv9epa2rfCKzgLTN1I9jY5A77Y/R8RIKGGEBeVKhkCqzPQ+vUg9NRT9zWrCFRLBppklIdsxLynbTlyWhyeu4qcnSRYJh1JL5K2/sMQu51yJ1WE1E8nqeF6WXjq3NwS73stdu4BFbWN5N7y6WzYoa9tPMmlPVfz4GaNWlcpNTUuIFmBZO3eCrAEj48oqGZZDz+5AU6Iknald6UPRkHCzIw1q/Aq/UyXxKPuzSlvHI2IzMYodG9kdnKQ3FCVhjCY5A9SvwQ/UkCru69di7vQ8uq4RFV4COyjlutqG9URppquSes4Rjg5u+9K9VOeoAxN/9VAt0KtiivMu0Imgmx9lr8JTz9qIp9C10+OmGIFJH0y7ff/DYc+ZvWLiMjxqtGOp7RNMuV5ccyiad3Ugyk7oEx1ScW/kcjQXQerdNSV6BooLJo26CkAp7nUg04q8bYZ4pTDDNm3IZEOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(376002)(346002)(39860400002)(396003)(186009)(1800799009)(451199024)(316002)(8936002)(8676002)(41300700001)(26005)(2616005)(83380400001)(6512007)(478600001)(6506007)(6486002)(36756003)(53546011)(86362001)(31696002)(38100700002)(66476007)(66556008)(66946007)(2906002)(31686004)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Vzg5WnYrS3JNbEtJdUxkZXV4bnFYdFhNWVNVbXVEYnJOR054OXVvdW9jZ2l0?=
 =?utf-8?B?cW40OVNBU0YrcGQ4VVErOUc5YUNXZTd6dXVjc2pXbEpuRjVBQTFDdFQwNDR2?=
 =?utf-8?B?VUtiVzFlRnpTdmNqZU9DRmJ6VXRGQlVrSmNla285YUlFekJwOTUzeE5rSnd6?=
 =?utf-8?B?R21CVzdrRFJGWkU2WWcxb0xHeTFrSDFEQ0hkdXRlSWEzdUlsZEcvY0pTd0JS?=
 =?utf-8?B?cmwwa3JxbjNyUnl4UDBwTVdFSWc2MWVEOUxBQ0xwVDM3TFRCVmhwTTVrS3dN?=
 =?utf-8?B?L3N4cHZHTWRNQytYL1FXM2poUzBJRUpNWnpQeUQ4ckhhMnFOcHl6RUV2Wllh?=
 =?utf-8?B?aWtwZXRnUm05Z2VCc1EvbW5IM0FJQityYTZWdStyNkdNU2dDUllkQkkvSnRk?=
 =?utf-8?B?Ujcrc0dEbjlibnhtbnpHcnBTbEgvenRkR1NMb0l3K0hDZGZpUUhIRTRCUGM1?=
 =?utf-8?B?RVNrL3JtMnMvNytrUThjRkJ0TSt5UzNweGNsMXJxWGlBdjBOMituSFBPSTRZ?=
 =?utf-8?B?SnhhNmdaYWpJZGkxUzkxOTFuU2c4ZmJmWlBWY216T3VqNmtxcURFbUtSbGI5?=
 =?utf-8?B?dlozbnozNDg1VkRqMGczV0pDNDVMTXExMThaMVE4TzJmR0w1bTc1QmNhQkkz?=
 =?utf-8?B?a3dDZ3NYYmpVYzRGYmZ6NHc3QTVvNy81RVZwSk1NeHRoZFhUc01QbzNqQmFo?=
 =?utf-8?B?dEJFNVg5SVVDUVlRL3hlaFF4bFhQMUpEVy9JY3h3U0pOU0NsMDNNTWEyNWFz?=
 =?utf-8?B?b1FQVnJXYUJjL0txOUNCM2pONllHUUFSeW9acWZZMm1CZjdtOGxiaFpoOC94?=
 =?utf-8?B?M3JqYkFzVjZ2ZVFocnRPek1rR29GSnZ4c3ZQMDcrNWhYc2RiSFo2ZDZ6a1RW?=
 =?utf-8?B?RysxTWdxbUJ3YVBxLzZ0ZlRiOVNucHg1WEo2cXU2OTlhU0ZTeTBmUWZHZDNN?=
 =?utf-8?B?VzNhTEgvRlFHeGNGSUp4WWdWbFhaZVMwZlZ5M3Q5R2l6TDVQa3REeG1mT0xT?=
 =?utf-8?B?d0h0Z0pxdlBsMEF4N05KcUh4SnZNaFRyTmNLcWljaldRNktmNk5MOVd1QnRu?=
 =?utf-8?B?dVF1UWttZkJGZ21pWU94WWlZMVdCMnFlRlNDL2pkZUFCZythR2daczVyQ0cx?=
 =?utf-8?B?UnlGWjd6WFZmc2k1MVdEYysrY2tCUHlwSXFwSytNTHZlajh4NjUvRWZUME5w?=
 =?utf-8?B?RHJxT3RDeXcyMFVINHM3TlEyNDBQWkZzc0QyOWIrSzdxaTNpR25XeGVkbEVm?=
 =?utf-8?B?QlVWcGlFTVBmSDIrVWw3eUhWZXVjY3Frekp3clZNSXJ3UTJ1Vk9uTkVDQWYy?=
 =?utf-8?B?MXdUa0M5YkR4M1NNRS94cEVHSXl5ejJ4dkQwZnczM09FL2FqYnlyeWZuQnlL?=
 =?utf-8?B?SVZhSVlXRkh5QVFTTmxnSUZ5aUpzbjMxUFJzZFdDajcvTFpLS0RNNlo4QldM?=
 =?utf-8?B?d3Zzd0pRS2ROOWRCSXNBYWRiQUdFS1QwMmxuVWZqSHlPZGVuWDltMkR4dmlt?=
 =?utf-8?B?ZVFnUUcxNUxVdHZuVjZUS3FTRTV6TGNkNSsrYVFVVGRIQUNYWVpWRkQ3WWk2?=
 =?utf-8?B?QjF3WVoySlhHQmEzanJQZWMzTTBrcVdWVXZsNUtPbHNDOWMvZVlUNGZUNVRD?=
 =?utf-8?B?dzR3YldtZjJuYlFZSWUvTlJJaVZORktpWVdGZGQ4L1BzOXdKQ1dwakdGU3pR?=
 =?utf-8?B?aWNHN2YwZHBpUG9VMEVuWGdjb3E0MTFzdWt4cXhEZWhEeFhKUXdDVTJsc0tv?=
 =?utf-8?B?MGREQ04wV1lYMnhoMCtYNlNVTCt5UnNYTnVtcmFMKzcwcjNVaTFIWnRvQ0xs?=
 =?utf-8?B?cEd4T2NvcUxxZWtlUmVMZnVGK1V2SktWREdlSklmT1cwSWxGR2NsN0h6UkJJ?=
 =?utf-8?B?ci8rYUxGa2NRMVlSUlFlRDNSbStVTGhxbnhtVy9yMFNGajM5NHFUOFFvNzRP?=
 =?utf-8?B?LzduYzFtYy92K1pPLzlHUUFWSFMvUVNsamxwU2ZwdzlYVUxVbnZnbm9INkxR?=
 =?utf-8?B?Q0FxZnZpL1MwVmJNRi93YmhmN0NBR2lWOHlPa2IzVk04Z1ZWUnFNS0s3dHBq?=
 =?utf-8?B?Zi9IdEpZTFBjMHVvV3F1NExLejExY1FmUXBwYllMZ1FlUlZDRVVIclpSQTF5?=
 =?utf-8?B?Y1oxTStXYkRaaVEzcHZmc2ZlNzU1c2FuNGgzNENNeTRMV00xb3FmYTlqcE1n?=
 =?utf-8?B?S3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JtAAel69meqpI6s8tLEGbvpoQaLJEYm8aesX/X+XayBktTNkyiywkMmi30n8mK1uoNlKBSUCrWGyq6qFtE54Ypxq2D/ZUtSnLucNxsg43YI8CgDU1nJqxsQ2HXb/UGB2Tge97BOCxy3bvLMTC+odAZ4fwBiyLso4CZUeTnwV4NuQGKo/6n3bp2D3OzDKlB+subn73Qx8CU4IFN6ZR59wshcb941TYHUEKpG5kKNJCp9tOfTsfkJubRxxKy1LdBjtPdNuUXBRvlo58BGw3GKqD77wdy6RHKeFXePYyxANV6HVlbTiSwLi7Hj9PtTh1tPUiUN+kEU6GWC7jkHwQuqVwZhiNygipCIvOSEQPAtBJpFRL02qob8kSo+3rXId+RWI9o8bXHtsmt+0js/w3FGlLIQYNQo6RWY4Kz1rwnzMYbTcX+dC7gFAA9mwtmpM5kpApq9AYFQgR8icZ3pfVSNOHaZtaiai/aVxVeHb8WTXTdqe+Ozk7nKC5dkTR5gvDuW+AAmUcVxcq/qVOHwFf0q0urEQ/uUhoJ8YBOv69qGWL3X5LP7fyRQt0ZGADmxigaFv6mLAgD/Q1ObQnrQJ6Sez1ijkHlcn0Eqzni2t02jcLOTC/YsMlzRbnv0UEkgF6nnTyTYieopm+py+0rfH6BrA2ELYRsepW7jCz1pEHZjapikaAZU5Hj/Hv0SFm4i/+pP2yCzxhDHmUsFxUPW5pc2PWT0lDWvixYx4elXoMQaOU5vWPuIJ980wyPmR+xQwpBKdWQKPjV2gHB5I2UtgsC9TU5qrh7Fi72SP07kOKa0jPFd1dM8qdnuuSOToE/fWuW5Q3ki7T2mE2ByhvKUQvDBxpNPK6XofYlWs7/vm5Gp8PdClNv5vVP7q2Or4NgpMmxAT
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eacc224b-de66-4124-7d90-08dbb7df1c94
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 00:35:09.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ecggiiw2/mnxv1R+eCfpxaxHtjGrFkVeYZ68oGMPqiGaZbsPRutdgVjFIXqQqw+NPaPhXhuqgKjrXWgYfJfKR9UhIhJghttiG66gPLiL4I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5399
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-15_20,2023-09-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309180003
X-Proofpoint-ORIG-GUID: xXllIli0Zo0kJ6hkSTuhl5YueZFnCFxh
X-Proofpoint-GUID: xXllIli0Zo0kJ6hkSTuhl5YueZFnCFxh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 4:34 PM, Martin Wilck wrote:
> On Fri, 2023-09-15 at 22:21 +0200, Martin Wilck wrote:
>> On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
>>> This has read_capacity_16 have scsi-ml retry errors instead of
>>> driving
>>> them itself.
>>>
>>> There are 2 behavior changes with this patch:
>>> 1. There is one behavior change where we no longer retry when
>>> scsi_execute_cmd returns < 0, but we should be ok. We don't need to
>>> retry
>>> for failures like the queue being removed, and for the case where
>>> there
>>> are no tags/reqs since the block layer waits/retries for us. For
>>> possible
>>> memory allocation failures from blk_rq_map_kern we use GFP_NOIO, so
>>> retrying will probably not help.
>>> 2. For the specific UAs we checked for and retried, we would get
>>> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries were
>>> left
>>> from the loop's retries. Each UA now gets
>>> READ_CAPACITY_RETRIES_ON_RESET
>>> reties, and the other errors (not including medium not present) get
>>> up
>>> to 3 retries.
>>
>> This is ok, but - just a thought - would it make sense to add a field
>> for maximum total retry count (summed over all failures)? That would
>> allow us to minimize behavior changes also in other cases.
> 
> Could we perhaps use scmd->allowed for this purpose?
> 
> I noted that several callers of scsi_execute_cmd() in your patch set
> set the allowed parameter, e.g. to sdkp->max_retries in 07/34.
> But allowed doesn't seem to be used at all in the passthrough case,

I think scmd->allowed is still used for errors that don't hit the
check_type goto in scsi_no_retry_cmd.

If the user sets up scsi failures for only UAs, and we got a
DID_TRANSPORT_DISRUPTED then we we do scsi_cmd_retry_allowed which
checks scmd->allowed.

In scsi_noretry_cmd we then hit the:

        if (!scsi_status_is_check_condition(scmd->result))
                return false;

and will retry.

> so we might as well use it as an upper limit for the total number of
> retries.
> 

If you really want an overall retry count let me know. I can just add
a total limit to the scsi_failures struct. You have been the only person
to ask about it and it didn't sound like you were sure if you wanted it
or not, so I haven't done it.
