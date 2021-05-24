Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35B8C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 15:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8E3E361209
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 15:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233373AbhEXP2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 11:28:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58192 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233170AbhEXP1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 11:27:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OFA4Sj184467;
        Mon, 24 May 2021 15:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8TXS2tBo67VkRpohQsYCapsLjSGTmrsjK6TmKiFkzrs=;
 b=iSqJ3FcesSOq2dbUFnJ5rSVF5R+X0kEUcKE69wGN6nmwsnUPcLLBP6ZLpokD4RyGfYio
 PoE8UmPB/SBmYKryMK1sZ4jB71fAtKjMpFtlZe2fD0UYJtk2gnDFPLavJvYZNQh97uXY
 MzSgHRD4bA80UZBp1rxnVHERoPaTBzdvmSeAL9sEK93gQfizFIpYtnx1O3hJM7WgHWED
 W4zy81B0itT7MDMIpkXVRU1GWEN8LNI1yu7u6K9BPDe3KQFyf/GZEA+eDJjGNtDUTF2v
 JO/IDyXXIhKXgyCvQFKcXAtx7zWYUwSObO6RKzL2krspc8f70kY5s1El7z4M8op5/eaw sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 38q3q8tvs6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 15:25:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14OFBxtr144006;
        Mon, 24 May 2021 15:25:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3030.oracle.com with ESMTP id 38pr0b3hfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 May 2021 15:25:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DFXQORyDGsNaYpYFyMR9Yq3vVH/LbI79zcI3M+cIQTRly66XrHVK/aHlaQKCdbmo74AOv7AfBw9R8phk2aV1QcKlszC5A7eNnyGX4jbG9tfDHU/jyZGAG0dl1tHNYkdFusHCz/ktc6BaS3U2gwkDfTNUDWKmvnWhmkJYLXFG2glWhnAzOySb/5++LOQcz9lhbFR0oIUn1H+X6Jasa6IHTNdhShxk3jRX1Pn+1SjFngYNPoBQgxVnpjpzcNnbcWlrBVPCqwYQ2H0w7V06mayF91QcRc6ho+qyVJ7M2wToUU/qMaZ6kYM8uusmiVazqccRWI3BH3+OD/eR1mPX3KEXpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TXS2tBo67VkRpohQsYCapsLjSGTmrsjK6TmKiFkzrs=;
 b=HTFUZ0NjJVG9hCVNAkXqfJMNsXBToXMf+dqvSqQYFfzHNpCP7HZAhNYpkk9N1WLdQqeRi359wyRcBSrLn63pU4oWauOPJYWSfLubcE8XIUCtGZ7PsohSRrt1Wtrehbg4ueAdZhqlVf8lfeIhs2/rrUYvQHF7npNesJKdlJRslXu2mk7CRPVfVmpvBh1n/xKiutj2zOICdGux6cKSM7udOZK3xkCEECGFM/pc/PW65d1EOxsp/6O43yexocO863KFZkyiS0Yzuj1SHrl/hRG5vGleoIoggCbUH/8lRZs8xXXi2jZ7P7VdAdYUUPN5lAvDWrAePWkEiAabwlA5CBSuHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TXS2tBo67VkRpohQsYCapsLjSGTmrsjK6TmKiFkzrs=;
 b=U5Fuznmz6c9IzgY5oKdLtekQe9prRd8Zm1hfObi1QUJSK5Bg8oqxHjAhOskpDX6aCX5tTTo/aueMzqknXteKn6GMEUQStySRy5ZM7dzBDYg2+tw5dKucKjZPMEgn1F6kfQ7nsv6tPhIvy9KJ6F/FArReFdx6KBO90kVvB0M3RS8=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2573.namprd10.prod.outlook.com (2603:10b6:805:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 15:25:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%7]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 15:25:32 +0000
Subject: Re: [PATCH v3 2/3] Introduce enums for the SAM, message, host and
 driver status codes
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210524025457.11299-1-bvanassche@acm.org>
 <20210524025457.11299-3-bvanassche@acm.org>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <5298aba0-045d-32dd-76a5-cc699940768d@oracle.com>
Date:   Mon, 24 May 2021 10:25:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210524025457.11299-3-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::1c]
X-ClientProxiedBy: BYAPR01CA0008.prod.exchangelabs.com (2603:10b6:a02:80::21)
 To SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:91:8000::ab8] (2606:b400:8004:44::1c) by BYAPR01CA0008.prod.exchangelabs.com (2603:10b6:a02:80::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Mon, 24 May 2021 15:25:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d7d60cb-a6ca-40ac-2bd9-08d91ec82b61
X-MS-TrafficTypeDiagnostic: SN6PR10MB2573:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2573ED7D2363E3605E3BA3F7E6269@SN6PR10MB2573.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E4EoS8Ik45x/feA1nkMIcSsE+RDd2PagUOSk2S2CsORQ1RPhbUVBsLJMRKh0n7pglM5sXmf2tqIrUj7nqshhwVfvD2ufweQtAxmomTzciUos6mFHHl0H1yVGRiQ/la6VvHK7RnmKFSCvX3itqlzBmKSEGsq6vZ3QP8pTxvPvrpKBcqn5hOLwHHbfqEojNCn6sIjHAYszfBk3dN5loHLIvObtstjEvhJ5aLPcbiRXUK7zoalhRH3up1Y3QlDaEenKrq6P3QWzA+DyzBdm1Vrj6tTF+IDXKuC9MbUkS0A6FRqY4Xk9ctbXBOblkZUMBh8EWZqJiUMP3OV2vGm5GujH/rcHpz1Gx1g71fvDWccWCtMXiuUN+RrVyU3EZdIWnIwhUYWOhmx40BlJeqJR73i0DUndGcEDuc0937KSNN3KP1ZY/GwCpKzxAqAUmz7a2MYWY6qJJNxGGvri2q2+5Pd2L2EHUXSMFQBk4L6Wk9CzVu+PeeM6KdlhBjOj5HjBAegITkTQgqWCj8Z2MM3YiTCPR9W2haLBgCZ1cK/Ln0zxV6q7PD5FFk16GMWi6ci+MJNNonxaac7vEiJ/uVOWx+usBAZSn/3KfUt+oJ73x1wLr4b5KRiiOVBJqBsOQXejNPNInlK/S5DhiRMAR6ei1giXiInelaMb3sBQt9o/stErB64=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(366004)(346002)(53546011)(83380400001)(8936002)(4326008)(54906003)(186003)(66556008)(110136005)(6486002)(478600001)(8676002)(36916002)(316002)(31696002)(5660300002)(86362001)(6636002)(66476007)(66946007)(16526019)(38100700002)(36756003)(2616005)(30864003)(15650500001)(44832011)(31686004)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MEI2MGJVMStWS1UvcmdLa2orV0pHUFlHT01IZWZVUDR1VmdwNGxjTERrUE5y?=
 =?utf-8?B?ZG5nL0FsekZ6OW01WUd2UmRleFJHa3VtdmM2OWpabGNPSzMrZzgvZVJqVEE5?=
 =?utf-8?B?VTQzT2pnV3FpWVlBK1dwclp0aTZETmNEVUxHU0hyZ0FJN001YUZXVFBpVGYx?=
 =?utf-8?B?UDcyZkZONERFM2xuS1hUWFV1b1krdzcwYWg1NytQQzNvbHdqRm1BZTdSbCts?=
 =?utf-8?B?M3NIU3RBekUxaTBnWThnTUxzN3c0b01KZHBFb3QvWkNyMmdaRElRUytOZnhO?=
 =?utf-8?B?cnFMakY3T1NRN3dOZHl2elNLR2taM0daN1hzOUprZDF4Zm5zemdIY0o5azNl?=
 =?utf-8?B?UVpqTG0wQjZveWlFdzJHZW9TVW1wZ1JKRkZoYk9LZUdkUDV0K2dBVHFDbnYy?=
 =?utf-8?B?UVY3RGZ1dXorN3lOZk1ITFJ1MVpzcm8zOWY5NW9CTVZqM1FObDdhMFBMRUxI?=
 =?utf-8?B?ekFhQ2RhTHJBV2YwazUzdmxLcS9SaTR4Mk95ZEUrd3JpK0hlTktaNWo1Z0E4?=
 =?utf-8?B?djUvK2FBSzYwN3FBVEIzbTdsQnpiR0kra1k1RlBHVDFHOGhhVDVyOVgzTFp2?=
 =?utf-8?B?SzQrVG5wVUpzWE1ZWjNwaEhrVDg5R1BXdzZyY3pVNUJiWFhBYnhvUmpETzQ2?=
 =?utf-8?B?MElvTkltQUNWKzBUR1RVd2dpcXMyamZySDE5Ni9GWno0WjJBbTNyY1N2NEdZ?=
 =?utf-8?B?VmxuT2xvK250NVRZVUlQUnNWTVpieDM2eGVIc0xyVkIzNGNIUWNvdG1BT3Vj?=
 =?utf-8?B?VWpBWE5mYUo2NGJiT3FTZldQZkg5alRJVUcreUVXNDU1U2ZhNmlNVFFJMk8w?=
 =?utf-8?B?R3BLNjVsbXpGN1hZenJsMXhzcW9mWG9VbGZuVkp4UERZZE81dmo3QUQxcXN1?=
 =?utf-8?B?Z2FVUTNPa0xYNVVzb2NqeEN6M0ZKME5HSkh1UG45UnVEazI4MjIyTWY3K0NI?=
 =?utf-8?B?R2VzN3ZHUDEwbDNicG1McFdDeEM2UXFpd0E2RmdXK2N6UFFUL1RQUEM4SmxX?=
 =?utf-8?B?aGJvOVR1U1UxQ3pFdC84QmFGTlovU3k1V00yWEUzeFNxcnNSK2JIU3V5bW1r?=
 =?utf-8?B?RkY3WWNkUHcwbnlWZHoyaFBnekdqcndQcWhCbVY5Z0VlUDFvRHVBblRqRWlU?=
 =?utf-8?B?OE9sRXk1elJjZXVOam91cmY1UVYzdDdBcU1SZGtXSW9QZVhSODJKRGxJYi9v?=
 =?utf-8?B?dXVyMVlXU2Jla3FaZXdYNW9BSmJIYTl5K3IzYzhSajdFMnVaK3prdGw3dkc4?=
 =?utf-8?B?MnA0MmxNbTRPUWJMZ1g5Qys1eHdWV0lGMThFTGdBM2V5ZkE2Q1A5UTFKTkdX?=
 =?utf-8?B?ODhYUytPdE1hdndTQ0VoWWFKSDY0cTMyM010VTRldEt3bU9GUFBJdis3UkhY?=
 =?utf-8?B?R1pIYWE4Si85SzNHaWpvUVhMeVJjK3loUjJsaFMyZWpaY2s4akxRWXE5OS9P?=
 =?utf-8?B?WmQ3QlBERjJNTHBBcTlkM01VNmJ4MVFJbVdkenY3STJSZ2ZJTWEzcDJ0emZX?=
 =?utf-8?B?UzFST3NGZk1XUWJtS1dwQ1dUUEY3NU1WeEdpei9VNnFrc2g1TnNhRVFWYlZB?=
 =?utf-8?B?WUhtZnhLV0VYaFMweGloY0tlaFBlMHBYb2YvTDcrbFVkN2R5azh5SkVURGhV?=
 =?utf-8?B?Y2J5RmFZOVYwUFkzVVU0VHRXZEtoVjZXNytJdW1JUXJ2b1dUT3pSdWlnQmdK?=
 =?utf-8?B?Z1N0MVpiM2FxYXJOUE1nTFZaSEJLK1FCMFkvR0h3R1cwVUl6b041eklMWnY1?=
 =?utf-8?B?dzRpZklycWN5elpVWlpScUFuZ3NBY0k1TW9wemhYZlFVUXlwY2FSZmpyYzl6?=
 =?utf-8?B?ZEsybTNOR1dnOVVSR0FxQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d7d60cb-a6ca-40ac-2bd9-08d91ec82b61
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 15:25:32.1365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gfZpSlh7z+UtvnXU2ktz1tFN/tul1zvMdw9zt6oo6hYuhM6x32f8qDDQFO+ZQcpuhxmNqUJCHkglqAyXGuOmgP8ue8Xidj7zFBLMGGMU5es=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2573
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240094
X-Proofpoint-GUID: IpxLcoSrRBnRqdOarcT58odVHmZ1Fhfe
X-Proofpoint-ORIG-GUID: IpxLcoSrRBnRqdOarcT58odVHmZ1Fhfe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9993 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105240094
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/23/21 9:54 PM, Bart Van Assche wrote:
> Make it possible for the compiler to verify whether SAM, message, host
> and driver status codes are used correctly.
> 
> Reviewed-by: John Garry <john.garry@huawei.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/constants.c           |  4 +-
>   drivers/target/target_core_pscsi.c |  2 +-
>   include/scsi/scsi.h                | 81 +--------------------------
>   include/scsi/scsi_proto.h          | 24 ++++----
>   include/scsi/scsi_status.h         | 89 ++++++++++++++++++++++++++++++
>   5 files changed, 107 insertions(+), 93 deletions(-)
>   create mode 100644 include/scsi/scsi_status.h
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 84d73f57292b..28ef83868478 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -412,8 +412,8 @@ static const char * const driverbyte_table[]={
>   
>   const char *scsi_hostbyte_string(int result)
>   {
> +	enum scsi_host_status hb = host_byte(result);
>   	const char *hb_string = NULL;
> -	int hb = host_byte(result);
>   
>   	if (hb < ARRAY_SIZE(hostbyte_table))
>   		hb_string = hostbyte_table[hb];
> @@ -423,8 +423,8 @@ EXPORT_SYMBOL(scsi_hostbyte_string);
>   
>   const char *scsi_driverbyte_string(int result)
>   {
> +	enum scsi_driver_status db = driver_byte(result);
>   	const char *db_string = NULL;
> -	int db = driver_byte(result);
>   
>   	if (db < ARRAY_SIZE(driverbyte_table))
>   		db_string = driverbyte_table[db];
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index f2a11414366d..6e08673dc583 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -1044,7 +1044,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
>   	struct se_cmd *cmd = req->end_io_data;
>   	struct pscsi_plugin_task *pt = cmd->priv;
>   	int result = scsi_req(req)->result;
> -	u8 scsi_status = status_byte(result) << 1;
> +	enum sam_status scsi_status = status_byte(result) << 1;
>   
>   	if (scsi_status != SAM_STAT_GOOD) {
>   		pr_debug("PSCSI Status Byte exception at cmd: %p CDB:"
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 7f392405991b..268fe1730d6b 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -11,6 +11,7 @@
>   #include <linux/kernel.h>
>   #include <scsi/scsi_common.h>
>   #include <scsi/scsi_proto.h>
> +#include <scsi/scsi_status.h>
>   
>   struct scsi_cmnd;
>   
> @@ -64,92 +65,14 @@ static inline int scsi_is_wlun(u64 lun)
>   
>   
>   /*
> - *  MESSAGE CODES
> + * Extended message codes.
>    */
> -
> -#define COMMAND_COMPLETE    0x00
> -#define EXTENDED_MESSAGE    0x01
>   #define     EXTENDED_MODIFY_DATA_POINTER    0x00
>   #define     EXTENDED_SDTR                   0x01
>   #define     EXTENDED_EXTENDED_IDENTIFY      0x02    /* SCSI-I only */
>   #define     EXTENDED_WDTR                   0x03
>   #define     EXTENDED_PPR                    0x04
>   #define     EXTENDED_MODIFY_BIDI_DATA_PTR   0x05
> -#define SAVE_POINTERS       0x02
> -#define RESTORE_POINTERS    0x03
> -#define DISCONNECT          0x04
> -#define INITIATOR_ERROR     0x05
> -#define ABORT_TASK_SET      0x06
> -#define MESSAGE_REJECT      0x07
> -#define NOP                 0x08
> -#define MSG_PARITY_ERROR    0x09
> -#define LINKED_CMD_COMPLETE 0x0a
> -#define LINKED_FLG_CMD_COMPLETE 0x0b
> -#define TARGET_RESET        0x0c
> -#define ABORT_TASK          0x0d
> -#define CLEAR_TASK_SET      0x0e
> -#define INITIATE_RECOVERY   0x0f            /* SCSI-II only */
> -#define RELEASE_RECOVERY    0x10            /* SCSI-II only */
> -#define TERMINATE_IO_PROC   0x11            /* SCSI-II only */
> -#define CLEAR_ACA           0x16
> -#define LOGICAL_UNIT_RESET  0x17
> -#define SIMPLE_QUEUE_TAG    0x20
> -#define HEAD_OF_QUEUE_TAG   0x21
> -#define ORDERED_QUEUE_TAG   0x22
> -#define IGNORE_WIDE_RESIDUE 0x23
> -#define ACA                 0x24
> -#define QAS_REQUEST         0x55
> -
> -/* Old SCSI2 names, don't use in new code */
> -#define BUS_DEVICE_RESET    TARGET_RESET
> -#define ABORT               ABORT_TASK_SET
> -
> -/*
> - * Host byte codes
> - */
> -
> -#define DID_OK          0x00	/* NO error                                */
> -#define DID_NO_CONNECT  0x01	/* Couldn't connect before timeout period  */
> -#define DID_BUS_BUSY    0x02	/* BUS stayed busy through time out period */
> -#define DID_TIME_OUT    0x03	/* TIMED OUT for other reason              */
> -#define DID_BAD_TARGET  0x04	/* BAD target.                             */
> -#define DID_ABORT       0x05	/* Told to abort for some other reason     */
> -#define DID_PARITY      0x06	/* Parity error                            */
> -#define DID_ERROR       0x07	/* Internal error                          */
> -#define DID_RESET       0x08	/* Reset by somebody.                      */
> -#define DID_BAD_INTR    0x09	/* Got an interrupt we weren't expecting.  */
> -#define DID_PASSTHROUGH 0x0a	/* Force command past mid-layer            */
> -#define DID_SOFT_ERROR  0x0b	/* The low level driver just wish a retry  */
> -#define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count  */
> -#define DID_REQUEUE	0x0d	/* Requeue command (no immediate retry) also
> -				 * without decrementing the retry count	   */
> -#define DID_TRANSPORT_DISRUPTED 0x0e /* Transport error disrupted execution
> -				      * and the driver blocked the port to
> -				      * recover the link. Transport class will
> -				      * retry or fail IO */
> -#define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
> -#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
> -				 * other paths */
> -#define DID_NEXUS_FAILURE 0x11  /* Permanent nexus failure, retry on other
> -				 * paths might yield different results */
> -#define DID_ALLOC_FAILURE 0x12  /* Space allocation on the device failed */
> -#define DID_MEDIUM_ERROR  0x13  /* Medium error */
> -#define DID_TRANSPORT_MARGINAL 0x14 /* Transport marginal errors */
> -#define DRIVER_OK       0x00	/* Driver status                           */
> -
> -/*
> - *  These indicate the error that occurred, and what is available.
> - */
> -
> -#define DRIVER_BUSY         0x01
> -#define DRIVER_SOFT         0x02
> -#define DRIVER_MEDIA        0x03
> -#define DRIVER_ERROR        0x04
> -
> -#define DRIVER_INVALID      0x05
> -#define DRIVER_TIMEOUT      0x06
> -#define DRIVER_HARD         0x07
> -#define DRIVER_SENSE	    0x08
>   
>   /*
>    * Internal return values.
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index 5c106c4f249e..84d4a3a14963 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -190,17 +190,19 @@ struct scsi_varlen_cdb_hdr {
>    *  SCSI Architecture Model (SAM) Status codes. Taken from SAM-3 draft
>    *  T10/1561-D Revision 4 Draft dated 7th November 2002.
>    */
> -#define SAM_STAT_GOOD            0x00
> -#define SAM_STAT_CHECK_CONDITION 0x02
> -#define SAM_STAT_CONDITION_MET   0x04
> -#define SAM_STAT_BUSY            0x08
> -#define SAM_STAT_INTERMEDIATE    0x10
> -#define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
> -#define SAM_STAT_RESERVATION_CONFLICT 0x18
> -#define SAM_STAT_COMMAND_TERMINATED 0x22	/* obsolete in SAM-3 */
> -#define SAM_STAT_TASK_SET_FULL   0x28
> -#define SAM_STAT_ACA_ACTIVE      0x30
> -#define SAM_STAT_TASK_ABORTED    0x40
> +enum sam_status {
> +	SAM_STAT_GOOD				= 0x00,
> +	SAM_STAT_CHECK_CONDITION		= 0x02,
> +	SAM_STAT_CONDITION_MET			= 0x04,
> +	SAM_STAT_BUSY				= 0x08,
> +	SAM_STAT_INTERMEDIATE			= 0x10,
> +	SAM_STAT_INTERMEDIATE_CONDITION_MET	= 0x14,
> +	SAM_STAT_RESERVATION_CONFLICT		= 0x18,
> +	SAM_STAT_COMMAND_TERMINATED		= 0x22,	/* obsolete in SAM-3 */
> +	SAM_STAT_TASK_SET_FULL			= 0x28,
> +	SAM_STAT_ACA_ACTIVE			= 0x30,
> +	SAM_STAT_TASK_ABORTED			= 0x40,
> +};
>   
>   /*
>    *  Status codes. These are deprecated as they are shifted 1 bit right
> diff --git a/include/scsi/scsi_status.h b/include/scsi/scsi_status.h
> new file mode 100644
> index 000000000000..66d2d421ad2d
> --- /dev/null
> +++ b/include/scsi/scsi_status.h
> @@ -0,0 +1,89 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _SCSI_SCSI_STATUS_H
> +#define _SCSI_SCSI_STATUS_H
> +
> +#include <linux/types.h>
> +#include <scsi/scsi_proto.h>
> +
> +/* Message codes. */
> +enum scsi_msg_byte {
> +	COMMAND_COMPLETE	= 0x00,
> +	EXTENDED_MESSAGE	= 0x01,
> +	SAVE_POINTERS		= 0x02,
> +	RESTORE_POINTERS	= 0x03,
> +	DISCONNECT		= 0x04,
> +	INITIATOR_ERROR		= 0x05,
> +	ABORT_TASK_SET		= 0x06,
> +	MESSAGE_REJECT		= 0x07,
> +	NOP			= 0x08,
> +	MSG_PARITY_ERROR	= 0x09,
> +	LINKED_CMD_COMPLETE	= 0x0a,
> +	LINKED_FLG_CMD_COMPLETE	= 0x0b,
> +	TARGET_RESET		= 0x0c,
> +	ABORT_TASK		= 0x0d,
> +	CLEAR_TASK_SET		= 0x0e,
> +	INITIATE_RECOVERY	= 0x0f,            /* SCSI-II only */
> +	RELEASE_RECOVERY	= 0x10,            /* SCSI-II only */
> +	TERMINATE_IO_PROC	= 0x11,            /* SCSI-II only */
> +	CLEAR_ACA		= 0x16,
> +	LOGICAL_UNIT_RESET	= 0x17,
> +	SIMPLE_QUEUE_TAG	= 0x20,
> +	HEAD_OF_QUEUE_TAG	= 0x21,
> +	ORDERED_QUEUE_TAG	= 0x22,
> +	IGNORE_WIDE_RESIDUE	= 0x23,
> +	ACA			= 0x24,
> +	QAS_REQUEST		= 0x55,
> +
> +	/* Old SCSI2 names, don't use in new code */
> +	BUS_DEVICE_RESET	= TARGET_RESET,
> +	ABORT			= ABORT_TASK_SET,
> +};
> +
> +/* Host byte codes. */
> +enum scsi_host_status {
> +	DID_OK		= 0x00,	/* NO error                                */
> +	DID_NO_CONNECT	= 0x01,	/* Couldn't connect before timeout period  */
> +	DID_BUS_BUSY	= 0x02,	/* BUS stayed busy through time out period */
> +	DID_TIME_OUT	= 0x03,	/* TIMED OUT for other reason              */
> +	DID_BAD_TARGET	= 0x04,	/* BAD target.                             */
> +	DID_ABORT	= 0x05,	/* Told to abort for some other reason     */
> +	DID_PARITY	= 0x06,	/* Parity error                            */
> +	DID_ERROR	= 0x07,	/* Internal error                          */
> +	DID_RESET	= 0x08,	/* Reset by somebody.                      */
> +	DID_BAD_INTR	= 0x09,	/* Got an interrupt we weren't expecting.  */
> +	DID_PASSTHROUGH	= 0x0a,	/* Force command past mid-layer            */
> +	DID_SOFT_ERROR	= 0x0b,	/* The low level driver just wish a retry  */
> +	DID_IMM_RETRY	= 0x0c,	/* Retry without decrementing retry count  */
> +	DID_REQUEUE	= 0x0d,	/* Requeue command (no immediate retry) also
> +				 * without decrementing the retry count	   */
> +	DID_TRANSPORT_DISRUPTED = 0x0e, /* Transport error disrupted execution
> +					 * and the driver blocked the port to
> +					 * recover the link. Transport class will
> +					 * retry or fail IO */
> +	DID_TRANSPORT_FAILFAST = 0x0f, /* Transport class fastfailed the io */
> +	DID_TARGET_FAILURE = 0x10, /* Permanent target failure, do not retry on
> +				    * other paths */
> +	DID_NEXUS_FAILURE = 0x11,  /* Permanent nexus failure, retry on other
> +				    * paths might yield different results */
> +	DID_ALLOC_FAILURE = 0x12,  /* Space allocation on the device failed */
> +	DID_MEDIUM_ERROR = 0x13,  /* Medium error */
> +	DID_TRANSPORT_MARGINAL = 0x14, /* Transport marginal errors */
> +};
> +
> +/* Driver byte codes. */
> +enum scsi_driver_status {
> +	DRIVER_OK	= 0x00,
> +
> +	DRIVER_BUSY	= 0x01,
> +	DRIVER_SOFT	= 0x02,
> +	DRIVER_MEDIA	= 0x03,
> +	DRIVER_ERROR	= 0x04,
> +
> +	DRIVER_INVALID	= 0x05,
> +	DRIVER_TIMEOUT	= 0x06,
> +	DRIVER_HARD	= 0x07,
> +	DRIVER_SENSE	= 0x08,
> +};
> +
> +#endif /* _SCSI_SCSI_STATUS_H */
> 

Looks Good to me.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
