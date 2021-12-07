Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1776FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 19:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240980AbhLGUCq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Dec 2021 15:02:46 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:24524 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhLGUCp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Dec 2021 15:02:45 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7I4dKB021808;
        Tue, 7 Dec 2021 19:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IoABdVJQV7076gRX5r1f7Xc3UCvRSs9RKYcULAtDyyE=;
 b=PeJYupBRZT58qSlraL1OK+LAZSBHF0w/gs6c+Q55ZHQt1gcH1J5TSJgSUMsv5BHteLpi
 TfFIhLFwi8YJK9fbbQcNvBivtR2UJ9HNeoqq0bC/GMGvHTfcCzY3iZPpZymTLHhasui+
 hevOky/L2omp83QEigkhuAZl81hyqo8v4U8MI/9JeO/2fCj+mnHjUQDTmVS6KPhUQK0I
 Q3baGBGJZXmM09S8cy8EQ3ZMrGd6t0HYAZt52p/ClZ0p5553MAD9Ln0YBTb+eeF2Jaf5
 5tugYfhUBcioLDg4ojNMlY7j9sEvBwQI10pDIKcEGwvz03hbdz5Qa9i8gM4gLsRiHXJH JA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csdfjeb6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 19:59:12 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JjGDT044916;
        Tue, 7 Dec 2021 19:59:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by aserp3030.oracle.com with ESMTP id 3csc4trjv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 19:59:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKOgsVh9xK9xpaZoGsnVOMvj46rFauAJgfOiKT3KMX87ItSjMYT/E60ryQjg/9TDEY+BmQgm6yE4dFfcMXFtfWvSdcFHCiJ03Xal+ckojzUIXPjSiTBLbixg7L1Z1KPKBuhtLEp7EqifV+jPWKZJe85c3IDw/UB1Kqbw7H/8cf7vla1K42jolr1RDUcMrLiNpAgpZ+OIy8xMwJ1nuS1tb9R9ziRTun4w7wvHVT8+AO+Rmh1fHXlAnXT+uyMAkYnSzLg32p2smikKLiHq3W3FxAXwQx3KyDSvXxj403DBgIcYri87m2btTwwSQOmTTopgvdP2Ctm+uSHUeSkYxOSCYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IoABdVJQV7076gRX5r1f7Xc3UCvRSs9RKYcULAtDyyE=;
 b=LOy0j0rJEZPUYzy/Yd24QuXMp1BBMQ2czRsZbZXDGvspiKoN7gu2AAVE696WDOWrClblH0lMhvd857d6gneqxW0xInvuW7fEwFmMDLjZOrl3vmoOtNvkm675OjCTI8fRl/ebMj8B0s3T1LwVbs2kjTibrs5D8be4n9XCbxYfh1ytVrfgtVpaZ5qXipIwU7b9y+c/Bx/Ik/dZVu5IxGdAnMaIxC7R1zG9o3LCZfXVl7ZhoPPFpyv2AuaX5NkLUNRGi5jmTPlx2oDVEdyC+r+GDiOOmLOe26NZmQEqSoQ4WGyXOD1hl59jx7b8AZJoF9jmT4Lbt6pLcdYo1AR7x9Frog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IoABdVJQV7076gRX5r1f7Xc3UCvRSs9RKYcULAtDyyE=;
 b=VCrkdsFulByE/I+H5PvOqnr9k80ENy8bmv720AyQjz5sTlwLFOOQ1vmvVWaT190XjEv6beVDZIg09s58c/KHyVNsbHeDlK4JOU23rr92XbmM8nIqArSriX0SyR7/TAQgbq1fx6mn1pl857AwKkSUJlR4Bans0cDMFOl+dLv9VlM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.22; Tue, 7 Dec 2021 19:59:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 19:59:09 +0000
Message-ID: <49f99a54-88a6-7d46-4169-c37e1f00b2ae@oracle.com>
Date:   Tue, 7 Dec 2021 13:59:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH V2] target: iscsi: simplify the connection closing
 mechanism
Content-Language: en-US
To:     Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc:     bostroesser@gmail.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, k.shelekhin@yadro.com
References: <20211111133752.159379-1-mlombard@redhat.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20211111133752.159379-1-mlombard@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0372.namprd03.prod.outlook.com
 (2603:10b6:610:119::10) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by CH0PR03CA0372.namprd03.prod.outlook.com (2603:10b6:610:119::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 19:59:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62ab2f32-a73b-4718-9df0-08d9b9bc0866
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB52803391EF1348878F597782F16E9@DS7PR10MB5280.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3dtwKB/mD1YX/f0qmaIf0N63B0zyD0H9sv1m+JKEiB6VgbTGlY7ltYOP31ZGzGZm9qoEC52eE9ZZamnjm3/CPXqDEXPJd0JRENlpKijJVyiWFJm5d2y0A5clzSYRxoGTcau78POnCwoTgyGxNB/Vw3eAafAhOyDmGxEYTqklEyqzMUxUSSf2DagVVsI4io1bA40FWH8cYmmGxs6Vch/stiBX6Bmfp33yYu/POeG1jUngB7ZFmeViemqqmrC4QReiSPFWpRVbbmxz4fZMZPruXkBjjuh/pxYobuALEwArQQiqrk4zC78/zs/ETwBGEJxntUVYcbxc1slIMcrDlphFB/Vfg79jMfFBIRg0O+N/YtAqdjlbVX9hlXxTFoPPMJnhCMkKHHAbuq2Hz7pmZHRQtbsd9dVV6jgNK9+bz1/TbHTALfgIsPc2jiTx7zXv/DCSxD4qoC+v8sZ75o2WobDTUJRgR0ybsOVFR0C8tsv3iSfTtcR95bHoOE4YUuMQpmvyzLRqBeXAXSbmtmR533XGCtacdlc7jdXEwPXrGk8JvFVZ0RHKqIQjMGRL07Eo00y+Odt/pDoNZ91v04CuFFXlLS82l/dlP2DP6fPeoy//4XEGjdO9eFHkY6N4aPMhj5+qtpzjG2vQmGwd4XLdoEFIaaK1AvdzyAfMPWLt1a+HEVv7Wkw20DMyW+RvOMl7IaOr3G+CbGlB1BO3nk1yntYMwKkgp9fWYpOqqXjnBG0bXYulfa81Fj77vfLs4djCoq95KmEt7AbHYPqVyi5fHe/bIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(31696002)(4326008)(508600001)(83380400001)(2906002)(186003)(956004)(316002)(26005)(2616005)(16576012)(31686004)(6706004)(6486002)(66476007)(38100700002)(86362001)(36756003)(5660300002)(8936002)(8676002)(66556008)(66946007)(6636002)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YjlhNVhVTmpaeE9SM2p5eDBhcDJXVllFeTRqQkRuOWF3Qkxqc0V1dytLbERL?=
 =?utf-8?B?MDY4OTBNbm40VlFIM0FwZXVuZm9PME5qZStpa3ZsMGQvbzhMVTBNdTlrdmJV?=
 =?utf-8?B?OG1wcWhPSHMzMlRlRFJlVXhsd2VKNnhWN3FxWU5Hb1Vib214VW9GL0pPNUlK?=
 =?utf-8?B?V1FIT3ZNeXVjL0hScnc1UnlkOVVUZ3hidDA5Q0xrWVZjbFdsVFFBVm85Z2lT?=
 =?utf-8?B?QmtmZUdjSERMc09EZXZKajhrZStDaTFRakpmM0RMWVZoSENuemJrVXRuM2p3?=
 =?utf-8?B?WWsxNUthTmxoNWgwVmhLNG95ZzZ6MytnUElPZ1FWV0UwVkU3QVVyTnkra2Rh?=
 =?utf-8?B?bFYwdFJMdUJtdXFCU2tXaHJZZUN2NGhlcFFzQkxoY2FXUGtTOWJzd2lLNXdi?=
 =?utf-8?B?eFhEcmdZSU5ubEpsbCs5R1FVNDdwUGZpbzBKV0tPeUh2QTU4M3o5QkU1aEQ2?=
 =?utf-8?B?dDVPckNmYnd5TWtTSDNITldLenMzWTl6YWdFQUcxaldEcmtJN2NkeDRjb0cz?=
 =?utf-8?B?WmlTVGRTZE9CdWN6QkVVQ1RjWnpMbFRJd3R0NHRmSHdOZG5RdDhJN0hHOHpp?=
 =?utf-8?B?b1JLQ0NMak0yZVZrUFlkdzh6cVVkNUxQMnJ2V25kTnpRRE51Y21lMGtRL2l3?=
 =?utf-8?B?eEpDenVyZ0o0c0ExNGVGNHAvNXdIYVM1YlZIQjdDZVpPMzM5ZkNhUFNVbGd1?=
 =?utf-8?B?ZzBKTUFBNGJFR3FMd3B3VElBVlF6ODNkK1NnclVLTzBwTFR2WmNjYmpKM1p3?=
 =?utf-8?B?cW5TWm0wVUNNb0EwVjM5V1drVE82cmc3TkszdDNHc0VqS2ZVMUZ2SHFOSDI3?=
 =?utf-8?B?R1FxUERRY21HVFVtU2hWaXhOWTFjWnZGT2k2bmV4Z29sQjZUY1hqQVRKU1VP?=
 =?utf-8?B?c0M3eEJDYzBVaXBtQmRPRWpxeWk3SDFjaG8xTEhYZ2NTV1dLd2pTTy93dUlN?=
 =?utf-8?B?ellMWHA0VnN5V29qMEJXMnlnZ2E5OElQeFRub2RBSitIeGEwQWM4NEd3M00v?=
 =?utf-8?B?ME9KdllQaENsbEJQN3I4WXA1ZjZjVTZPRFU1TlVaSGdZb3ZtYXlzL210SFJv?=
 =?utf-8?B?U2NldWlRYy9kU2VVcWNnWVM5aGh3RTRZY08yZkpkSFVUVHc0M1VwMmpLdFpk?=
 =?utf-8?B?M1ZuSFNqWmlpM0M1Y2gwNFpyV2xwT3VHTE80cEIzb2pmams0ZUVHL2xybFFl?=
 =?utf-8?B?RWhWdzl4dXc2bnRrcGdUeUErZW1qQXV5bjFGcGZ0OHhiN0dydXpLb3ptU1pK?=
 =?utf-8?B?d0RDUkhoZ1NFZTRETnp1OG56RTN5RnZaWGpKSSthR3NPdHk0RERzeWU3dm1m?=
 =?utf-8?B?NGF1MnZodUdnck1EemFITFdsOHlwWFlHemZMZS9hd2dZNjNLRk9CM0xmWFZ1?=
 =?utf-8?B?WHlpWjZIVVI4WHdVeFV0ZytCYlVZRDlyNUFPcENjaXZuNS9PNnFGWnAvcHpn?=
 =?utf-8?B?Yk1BYi9JK09vZ1Z3V21Ya1A0aUJsUmRKeEgyZnk5SlJIcWJxeWNLNm53Z294?=
 =?utf-8?B?S1ZGRTlvUEgvR2svVFljc2JqV1k0YW84Ri93QW45Mllyc3B0M3pkYm5zbHdp?=
 =?utf-8?B?Uy9KNkVZdHAxYVZkVzBac0x4NFE3aUxaa25HRkY5eTc3ZEFBQlROa3RqY2VO?=
 =?utf-8?B?eFV0a3ZNMGZ6MHlqbWlKTEFCSytwcXlMb3ByenBLekZzVVl5TVpOeEpGZ0I1?=
 =?utf-8?B?UUlQTk1WU1dXdzhGTEh1aUhBV1NNTCtLUHQ0cnRiMW96SzdlK0FheVNhRjN1?=
 =?utf-8?B?U3N5Q2s0K1l4czcrY2FIT2Y1dVd5bm1DSlNHZmVlSGdwQ2ZCRWlIVXpkOTVl?=
 =?utf-8?B?REpHRzNsVERtam9vNUgwZ3JtZlNqVWpWUUk3ZTNDcE15S2IyY2pvclJORE9o?=
 =?utf-8?B?L1VxTDI3blcrdnJpYjQwM3JpUXYzSFFuditybDdxRFM1N0VCQ09Zc3RyWmFF?=
 =?utf-8?B?SWJzVDlIQ2VHNXV4aUJHeWJOSTI1VUhWUGJuelZrMlF2cnJUZHp4a0dLZGVh?=
 =?utf-8?B?MmxEV1pBRDN5YWpVTlhnSnQ5WlQ3R3pTWGZvc1gyMFhTdG9SQWtjK3dhTWxv?=
 =?utf-8?B?Wkp3VFBjbTdoUjNGQ1k4Qm13eE51Yi9kVlI3U2hCOGp5eXRWS0RDMVNYUTcy?=
 =?utf-8?B?RUVSRzh5UkVRQ0k1M3B5ellKUDkzZC9hVFlid2sxM0lLc1Z1QUdQK0hEdUpo?=
 =?utf-8?B?Qjd0T0RiT2s0NUpwVXZNRjRHWExob1l4SFUyV01rcHJvejVVbm5IeUNhKzJB?=
 =?utf-8?B?QWhHQW1jWmxZMW9hM1FETkpLRThBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ab2f32-a73b-4718-9df0-08d9b9bc0866
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 19:59:09.7547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wCcaMVwlNUczOeMyfjrmqWZ6kpkzOJmrl6nQ7uLznt/LZUWexXqsdOrGO8DaQ7WA6OHqNyiB+kOuBt+7DbQn/8J/w7bLI5FdOqFLBRGTRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5280
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10191 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=944
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070124
X-Proofpoint-GUID: kHrxvyvwZIKdQGHj2Go7TLuPJqfQwrMa
X-Proofpoint-ORIG-GUID: kHrxvyvwZIKdQGHj2Go7TLuPJqfQwrMa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/21 7:37 AM, Maurizio Lombardi wrote:
> When the connection reinstatement is performed, the target driver
> executes a complex scheme of complete()/wait_for_completion() that is not
> really needed.
> 
> Considering that:
> 
> 1) The callers of iscsit_connection_reinstatement_rcfr() and
>    iscsit_cause_connection_reinstatement() hold a reference
>    to the conn structure.> > 2) iscsit_close_connection() will sleep when calling
>    iscsit_check_conn_usage_count() until the conn structure's refcount
>    reaches zero.
> 
> we can optimize the driver the following way:
> 
> * The threads that must sleep until the connection is closed
>   will all wait for the "conn_wait_comp" completion,
>   iscsit_close_connection() will then call complete_all() to wake them up.
>   No need to have multiple completion structures.
> 
> * The conn_post_wait_comp completion is not necessary and can be removed
>   because iscsit_close_connection() sleeps until all the other threads
>   release the conn structure.
>   (see the iscsit_check_conn_usage_count() function)
> 
> V2: do not set connection_reinstatement to 1 in iscsit_close_connection(),
>     leave iscsit_cause_connection_reinstatement() deal with reentrancy.
> 

What was the issue with setting it to 1?

