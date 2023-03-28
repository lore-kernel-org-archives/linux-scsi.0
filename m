Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7002C76195
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 07:00:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjC1HAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 03:00:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjC1HAp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 03:00:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F621BE9;
        Tue, 28 Mar 2023 00:00:42 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32S70OQ8000449;
        Tue, 28 Mar 2023 07:00:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ak88U4g0856Qh/KVi5rOt4N62ZQBV6mtermmlPtmDq0=;
 b=XK0oVtragQaY6+r4eu2I6am9ZS1o3ce68aQBYAdnuc6tnJAF2yBvjo1teoSFWP0C2hIg
 FN5h5PHoEETjDSAww9JVGZmqzvFYKO5BJTUP7idcsDOeT9cloM+WWejHTLpCRqINKs6X
 p3OgGB8fkqPp5XVvZ31+cJwmvIi1L676sPhub7s+yPt9Jq0CTxANw1LkL6/1eiaaXlSB
 NT1NHwQYFCqtzwQEr1NTi+Wza0zjewxsruRS1ftEyVNZ2KOU/PWdEIRiifBOzLdgNVNE
 ZbTg8xDSyIZKIrch3Q89QH+xVMPstoSnZeJAFLKqqiV1JJcZ9jOvXTrCg1s/ZNvpvkyB Nw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkuf7801n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 07:00:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32S6pQ2q027647;
        Tue, 28 Mar 2023 07:00:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd60960-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 07:00:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyzm17HmoOucH3o4j8Ls5hUjwJLa8PAGUiQNhpl0YELLp2n+ZtBwgBe7hNckxpl6MHJYr75nE/7BX7WX3GvgwRu7dm+mordEQhRykwdZijI3N0ZQYVaHkZrYSTwa/mOHnrFPw2N4LiQI8p5lpZaXPOaTsK5AwpIgkwvQjllJLgztceknCcaXuVusKuTGKRznCAeTkkArYKiSGCMdmd2hCAuRpnurkR1I/lC9OXrUUvyOMx5dQk8GtB/GWGp9TiuKL8/IkJ3hCY2SfspIma3TKhILQ/EyCByRN1t1Y8L2NOUOGgIVbJoeV/ZvRN8Cgj5zPiKnDN0hribPLC5XSqj/Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ak88U4g0856Qh/KVi5rOt4N62ZQBV6mtermmlPtmDq0=;
 b=Q5i0xTjMsN9WH6P36NZZHQByg2VTe2jt+HvFSs8afOPjq8K1n9H2nWYVhLG2jnubj8xD06BDE6Rn1F2QXjbC4/rYyDDRd2TdILSe2UOaCcAWD/kJuX7nsZ+I0ESlGCLkAnE9Vov4BJB5dV3dZMtUXjubz2VCb12R7v4vRQ1I6QM7L/ciXzg+HOyqSfFIwTFDZ5rEQeXMDZcQDTTrWKjKb6PjOWwx8VXt738lUt/Oab6WrKCR40p8wGsHR+j94HAwNeB3bzrP9jPKcEx1eJILZergihBu/rKP24ZqQYJH+qImSsbpnK6GEP93j63A1YwFsXN/UJ4cId5WRmdNBoewnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ak88U4g0856Qh/KVi5rOt4N62ZQBV6mtermmlPtmDq0=;
 b=ca9IDo4fJz3zRm56mvgH3zaJ/d5qbFpsf55wOsLfW1TsvzliZdD5R3HVRIDwantlRm/MzG3n9J3QcTbwR5KkVl4WQFfLH6Uivtq1uKu/Ns919Or+nMmZk0SSYH+og2U4gDPd4G2gao9HLrccBcIEZiEXwYButOiC7UJy7iGLxxI=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7301.namprd10.prod.outlook.com (2603:10b6:208:404::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.28; Tue, 28 Mar
 2023 07:00:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%5]) with mapi id 15.20.6222.033; Tue, 28 Mar 2023
 07:00:37 +0000
Message-ID: <c359daa5-e282-bb82-7ef4-a3826e06675c@oracle.com>
Date:   Tue, 28 Mar 2023 08:00:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [regression][bisected] blktests scsi/004 failed
To:     Yi Zhang <yi.zhang@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
References: <CAHj4cs_RuqDeoZhbqZgMTx1oQBN+mwFgTpuwE4h0PV0LHYQCpw@mail.gmail.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CAHj4cs_RuqDeoZhbqZgMTx1oQBN+mwFgTpuwE4h0PV0LHYQCpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0499.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7301:EE_
X-MS-Office365-Filtering-Correlation-Id: 34f2ed81-5b12-451d-745f-08db2f5a221a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mlfLtyFJEOIbvxRMlgHmme79qH+pArHk/l8INdnwYdibX6hgV02mIKE47Gw2um9/3BVLZC0FWTKy406Ms8QYnH33cXfXBkYNS1g5c+RJJK8oMq03iCbwokeh0CD5AjhQBHOdUh3U07AQ+PQAuOSuIFCrPXHmklqXyg53swaqCLet/TGC1Ne13Kp7+gP7vTkmn3iEs3nGNRE557TayRHRm0ZXtIJdhcW8kq8dwXQdyXt3dYH+muJNsaej+kXukCfmdteI3f2DYAIZaFbaSyEBiTrreRbVW1aDxYm1nwZdskR85Z0GmcmWAdsOTPcxxcxYBAbm1/hctEYU9fNrKBSAgqbEreQyHYWBkSn5MzFlfH9zsuNxzTkQfsQtldW4x70xkuppyRhamX/KA2lki7H5Xj0jHT9lTwKTK2nVcc62+5htUcx3ZBAO6E8EjLZC80p+FiqyF+QS/7BJLgOONLBnc/cFR3pBFbxROgPqzDnYGA5lyDeOAjBal3JLU3KheAC3UdksttjHgr2x90NAYpvuZiriuxQ5sNasUcQKlGP0a5ejdAD16jgsPHgeLz0J9L9H8Ubn91tP62eKA3X9LjOjw6R6lt31hxf05b1pxgEWgNQrzBIFvPH/JMcT7qWyIm44ml4dgRri0N8Ga3UsIFIXnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199021)(31686004)(83380400001)(2616005)(41300700001)(31696002)(36756003)(86362001)(5660300002)(38100700002)(6486002)(8936002)(36916002)(966005)(478600001)(8676002)(66946007)(66556008)(2906002)(66476007)(6512007)(4326008)(53546011)(107886003)(6666004)(6506007)(316002)(186003)(26005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ampEN05Mc1V2bVJvQUJ5MFU3ZHEybFlRUmM3Nmk0SUtQNjZmcnp5YkhQbXpY?=
 =?utf-8?B?Q0gzRHUvdTduUG1zZlpHVG1NRmczS2h3RjB5bjAvVSs3c3RpVHo3dnY5Qkth?=
 =?utf-8?B?VmZKVGtHNG9xTUg0K3B4TGpQNndBZXVKeVppS3FYVXJQUTNtZWVFWmplWm93?=
 =?utf-8?B?RUlOd21WQkE1alVBQTVpTmlWZk1FQmVvandaNzBtRFh5RHdXbm83bkxNSzJu?=
 =?utf-8?B?WXNxVHkzODRRVm1nd2JPU0twOGZTUTYzeXgvOGhmT0hjYW1iL2FoOGtKU0w2?=
 =?utf-8?B?VUZsVU5ibzAzNFhrdTJHUnk3bG1nNDBEbUZJM3E2ZXlmZWsvMHFiUGVGODR0?=
 =?utf-8?B?cjVWTURyNWFSU0NyVzFETncwaVRJY3BMODJ6K2huM2pQcWpHb3hsTDlBWWxV?=
 =?utf-8?B?b0JNWkFGU0JXT0dPSlNhQnB6M3F3aGxQT0dJNnFYRjdZcW1QOFlQSUVNMHRG?=
 =?utf-8?B?TXkrcTNOdVhSdmU0SlhObDloTlNRKzMyOVowS0pYQmlZN0hkanh3VFFVQVhG?=
 =?utf-8?B?aG9HY01jbTlNRUMyUzVHWE5sOEpva0FacXVwTGFOMXFrVGtQclhKWUNScGtJ?=
 =?utf-8?B?NFZjekgxa2hZTE43alBzZHY3a09UdEhvK01YVXZBQUM3R016SG5Ic3c5eW1a?=
 =?utf-8?B?YmNEa2RzSm9KQnIvUUh4NTlKbTFRdzlIVzFMVS9HdlZySGIvb0ZRVzB4V1JQ?=
 =?utf-8?B?dXNhM1BjcTIvaUM3anM1eWp5NmhSYjlLZVRzNTZyN0NDTFhBQ3J3ZG1EOHZo?=
 =?utf-8?B?UlJ6UkpyMm9WeGZlbUtULzBGK1BTVzRtK2J5Y3VlRjJYaEViMTRRWmhVTXk1?=
 =?utf-8?B?bFMwTnZrS3F5RVE2ZUVlanJVYUJBb3F5MHZJZmEyME5JSi94L1RkejRwS2t3?=
 =?utf-8?B?dnFNcko4RVozd0JLdmVoM043SnAyOVc5V3VnTStvcGplQlAzOUZVOW1CK3ht?=
 =?utf-8?B?OGdiUGNJM1VQQW9BY2xIVHNsY2ZGVHNWWUFnK3dGN2RTYURZdDBKUzU0dXBi?=
 =?utf-8?B?YjRVdHp0R0llU2RvR2VYYjVJLzIxMGpnR0pmZVBndEhXQUM1ZHMvNFFPZ0xj?=
 =?utf-8?B?Tm02YkVONGkvMU9meWRkWU5tbFV1bTAyWlV5c1QxK1BpZHJYTjduSUhLWFJr?=
 =?utf-8?B?NU9JelkxOTZqSjYrNDhRY0tPUmFoRWFESmtqdkJIRktHQkNnQ25kMFBpWHhr?=
 =?utf-8?B?RzNaQ0YxbHBwVDdLTXRzQWZ5RTlySFRvajRweTY5ZHdDZ2tITTAyYnZOTnh5?=
 =?utf-8?B?N1ljaHNOa00vVW1LVkZGSWo1WXkzaDZudG9yU3BjVlZZa2JuRXcwVTB0VFBS?=
 =?utf-8?B?Ujd2NzR1Q2lheHVEQ2xhZlpYTUlpeWlIUDQ2dFgvRVpHN29jczRoNTdFTXNs?=
 =?utf-8?B?OW1SMmozVmdhZG1TMzd1NlcvdkJpMUpyeU5haUVFanl3UXAyeHNZMjN2VXNM?=
 =?utf-8?B?cTB0Y1J5NXVMeUhTS2Z5U0Y5REFCZk5JZXhjZlJlWUlWOXFZSTd0MktrWXR0?=
 =?utf-8?B?VERWSFNpa0RKVGNSejNTclJaZU8vdTd0R1UrL3Y2czlrZDl0dXBZLys2ekRv?=
 =?utf-8?B?Ti9RUENTSzRNMGg2WWxDZWNleWpxWURUbGRHeStPaFExOHo5K09FdGJtL1FL?=
 =?utf-8?B?SnFvVUQyK1VXV3lKNk5WZWFETjRtRFE4R3ZQcjRMRXVYQllxSTRwTlFMNDFR?=
 =?utf-8?B?dnlUaTk1U0pyL1pKVlJRQklMTjR2MlNsM0huaEVkbW1HTXlIdVJ5d1RXM1Mx?=
 =?utf-8?B?TzRTdzh2alE4NThoZFpPSDI2Z0NrRnJUdXRnckVxcXk0azhTcElPZkhmOUk5?=
 =?utf-8?B?SEVaejIxcnUzbE5XQXFqQVE3dVYwTy9UUzJ3blZFbkNaNG5wNk5vL3NUK1hT?=
 =?utf-8?B?ZDVSa0p6UUg2YVZUOEdFNWxWZDQyVlBla01rajREd0FKSGpxYnFMODFrTFBn?=
 =?utf-8?B?OU5xQmFiTnJKaVp4OG1UOC9YVFFvMFFhcGJjZFZKckU4Qm5GY0l3SVFCdGk4?=
 =?utf-8?B?RmhPcUNxZEYwUXhmdEtKdjdUUXJJTUpjWEsvSFhKaFZnbTBGaWRtZDY2bWVN?=
 =?utf-8?B?ZEVvazVscVNoR2tSNWlhR0dnRG5RL2lOQ1lGQkU4TDcwSUZwS1ZrMDEzVnpj?=
 =?utf-8?Q?yChzwiI6rKt8FBD+Wrt0si6vh?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: op0Tsm4RZxXnwgVm+LVLoEa8jBp4tDt836GBkfB9DsyR/y8RNIo6mVObtw005TZhl8mi8ZnJHBYMPugg/Hy+dsF7GL1tBTl1P+16oOmZjCTKkNySx+J3YCjjAkZJJbVxI13mvNob9lWijLD4LaRfv6sruArMZ5IbPl8JCAA1MURO+4+TvtMnu77gmrb45UBw+WjeMN5bEtWlY2MJKeCgA0rxbiHekZo816Pp4mQLCfl3eYavxW8i00OkSPlDFZGs2lPM7iNhdXWUFRD6PJGYM03IIa8FH0diWluWgcd2haeq0HrQ2sGbyzoI4GgbOWGH00dzmjgeRX9Q4xVlj9G4G2FDqiJBVvv2g0t+szC1wsuDEx/NH6dp1FMTGYLiGtg8EPc0I6yn0sQf6OQFl9FA6Y7+2GS4SdAkDrlVvr3t4aGzounAZOYJMdt53NtD746hXnNs6UoQcfrXZcLGaHJIkSfs/uHTzeXxa8PdxvcaRIoZmwusqrvG8KpnV7bC2cO22SJnc7meij3paSiViTPek7B5OrM06mzgnyf+CNSjXmK3a/4Z94LmW6Ab6ryKm0RN+3cv3iHFMHeBW1ZA451qRwUj0gbJ1bxOybuBqdhbTyzCN80LfZifsdtYGu7bO39WGTtVn1KTmVfolJBrIHpUfDbmCVBgMF9eEwKn0+m47XRgQjAR+1/oc3mra0Wynj9i+2w12Una3AhAKi1HLZYSOnC3bZnXYkBf9BCm4WIiA7fFn9QZZNrjcoVu+SYDmvsO8F5s5mqGbGtTKTQeYqk3j6dEozvy/5oiy2KQT1FJtdk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f2ed81-5b12-451d-745f-08db2f5a221a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 07:00:37.1242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H6ZVj0GOeEcn4Fp8MJV3swOrsZ+z5B6kujYWOqu0uAB07ASqdNCT/uen/nLTx+Ean24rzApPaDmSbi+zhvRC0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7301
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280057
X-Proofpoint-ORIG-GUID: ngLVDwVSw5FKstz_RX0Ab9nGiylJHig2
X-Proofpoint-GUID: ngLVDwVSw5FKstz_RX0Ab9nGiylJHig2
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/03/2023 03:53, Yi Zhang wrote:
> Hello
> 
> I found blktests scsi/004 failed[2] on the latest linux-scsi/for-next,
> bisecting shows it was introduced from[1], pls help check it and let
> me know if you need any testing for it, thanks.

Thanks for the report. I have sent a fix in
https://lore.kernel.org/linux-scsi/20230327074310.1862889-1-john.g.garry@oracle.com/T/#ma8b4e8856df99139ae4879fa0f49befbf69f1a57

Please check it.

> 
> [1]
> 151f0ec9ddb5 (HEAD) scsi: scsi_debug: Drop sdebug_dev_info.num_in_q
> [2]
> + ./check scsi/004
> scsi/004 (ensure repeated TASK SET FULL results in EIO on timing out
> command) [failed]
>      runtime  1.889s  ...  1.851s
>      --- tests/scsi/004.out 2023-03-27 02:51:16.755636763 -0400
>      +++ /root/blktests/results/nodev/scsi/004.out.bad 2023-03-27
> 22:49:53.511526901 -0400
>      @@ -1,3 +1,2 @@
>       Running scsi/004
>      -Input/output error
>       Test complete
> dmesg:
> [  268.314709] run blktests scsi/004 at 2023-03-27 22:49:51
> [  268.325391] scsi_debug:sdebug_driver_probe: scsi_debug: trim
> poll_queues to 0. poll_q/nr_hw = (0/1)
> [  268.325398] scsi host0: scsi_debug: version 0191 [20210520]
>                   dev_size_mb=8, opts=0x0, submit_queues=1, statistics=1
> [  268.325575] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug
>    0191 PQ: 0 ANSI: 7
> [  268.325693] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [  268.325775] sd 0:0:0:0: Power-on or device reset occurred
> [  268.345884] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.39
> MB/8.00 MiB)
> [  268.355905] sd 0:0:0:0: [sda] Write Protect is off
> [  268.355909] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
> [  268.375943] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
> enabled, supports DPO and FUA
> [  268.406011] sd 0:0:0:0: [sda] Preferred minimum I/O size 512 bytes
> [  268.406016] sd 0:0:0:0: [sda] Optimal transfer size 524288 bytes
> [  268.537442] sd 0:0:0:0: [sda] Attached SCSI disk
> [  270.067115] sd 0:0:0:0: [sda] Synchronizing SCSI cache
> 
> 

