Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0470CC3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 22:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiGZWjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 18:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGZWjA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 18:39:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FFE1573D;
        Tue, 26 Jul 2022 15:38:58 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26QKn3Uu029985;
        Tue, 26 Jul 2022 22:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=sxmnsK7wuAQCWN12MxR8NY3GJXVffw7Gy3B2mrOUsG8=;
 b=tuHuNF6uvTL1kgOpnDw21fls1ro/vWPNQBUtc3ezndAkCwWBFTi1xLFb7FhOZzmX+kS/
 M25xNPp0o8Abix8aMSFUpbikNHBI0yn3k4M1aRqtEQM5BYaea7lF/biOq9RKmVb3U3ed
 jWST5PPyEl62BNZum0futzTMIbp9CGWYu/EnxByqamhWcL/w+je0uRaMCZWznjiGRVBr
 ChWB156BhJqZAOPUWnzJki5SJJDFQUv4DIjnNwQU5iP+XPLXr7Gp8VjFbzXx/ALTBriQ
 mUlms5oseYb1duppu1uGu9YyqrfSEPzQl3RMHpHYkK2GaqddHvfSUpbHPT593jxfTohi jg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hg9hsr0pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 22:38:58 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26QK2d8g017671;
        Tue, 26 Jul 2022 22:38:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hh6515bet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Jul 2022 22:38:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgCNq9geXrRCblDCh5QkwobWRs+WtZZflXhlGSsUlz+e/U9I0Ym3Xvf29CN2XTJ6wAeivR9Z8rfHJrEYBtcCVGbtP/CCygpdYtSGlAuf1VHwikdP96KTuspVCtBl7TtiT2OXG17PPL256oKi0yAyvsXNbuvctPesP7kwNzewDBMg+eBpERsxSCj/2jyCwEPwRYUF5z3qmgaKtiVKwN8rTLjowycMTtyl6jaEODVz+NTCig+37AXyH5QJ7xiZHqi/ETdTHkY4cXNHk95+cKUeyGTrOATtW6So5PgtITtmMvlZLHF4oBS5Wo0gg1ML82FwJnfFfBtlgcVyYB/G2Xh6cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxmnsK7wuAQCWN12MxR8NY3GJXVffw7Gy3B2mrOUsG8=;
 b=nVCdnnZXnaBQpuwG+y8hmdrtdhb9BPfr217qJHyN5w23Zy23up0RxFe/f67UhcBlRXex70gIu9l9ohEc7tfaARQckmghQXwMMhBYMAc2wAnyECb2TS1DHHELnaV+dWYUwZLeGfztFNm8jIonGL3/JytJp/shCsWzFNa+QvolDfehC4TW045Yglw2PTWYxuQ1ym+g1lcPKKi0dnwDxHetd+S5jFwaG3s+YLynkfD41ZPvaJ6u4KjvvX5eB0YFYhj4+umpcMfe+cO5SJ5ybRDWLtYG4Nq50meracPi9hepv5AmQdt5Ohty1Sz2Rzu+je5DqB0RQ7efO+1i5th9pbJxyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxmnsK7wuAQCWN12MxR8NY3GJXVffw7Gy3B2mrOUsG8=;
 b=oLXTkaK29esryp6VB6ZTqoPn/8cKNPqn9uBzMJWI6xYq45Z2g8DBVa6c5lh4sePNt0mZLB6WFANdPNURzPxDY1zn3kbI/E2gv+7PkNBG9HJHExuifMzMOowLIugV9skc4ZMoQw0OpeBSf2trIYp8ZULSX/Ld/AhTo7NUV9MJXfk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY4PR10MB1511.namprd10.prod.outlook.com (2603:10b6:903:2b::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.21; Tue, 26 Jul 2022 22:38:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 22:38:53 +0000
Message-ID: <11b8cdf2-a41b-881f-0797-d2bfa4c45b8f@oracle.com>
Date:   Tue, 26 Jul 2022 17:38:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH 2/2] target: core: de-RCU of se_lun and se_lun acl
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220720112852.11440-1-d.bogdanov@yadro.com>
 <20220720112852.11440-3-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220720112852.11440-3-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0014.namprd18.prod.outlook.com
 (2603:10b6:610:4f::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 504365c4-f2c3-4700-36d2-08da6f579e47
X-MS-TrafficTypeDiagnostic: CY4PR10MB1511:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0eTuTx9AqYbrfFlEbyaPAfu95V66scq4jtlerREvzgsMjuMZh38ZRhLw9fV2WwbbS81P2T/oegnx2dsUq74YiDLxYIAuqiTkbHH1tuiTDtz224DNNk8OLLQU0F4zd7T/1kxw4RiRwbVEBjtxJdPaPLhA8V0BBG7ChFbeRPlVkbvZVpntsNmIk2jORkscWkFYeLozxlY7qgnvGe9ynNHt2jOutPUAutxdeb0oRBc+gc0D5qo2MHfTf70dMnDse/tUAinTozDQF5FRnRrrlgHEglpqZ4b/pQQOekoD65+cSMFK6/PkMt2nMpgb47/if/oJBMzMgWG7MU+nXKKjaCDGufrwf+8QKfEEGyEL9vblIpDD0McgVHJZb9M16Z+sARG7LWYkRtugis2/MQFLh6oMNyRfOU2kvybukqOgHHoyyeibs1bTuhHkpVMqJV7zH6SaUMt0Al0gI7f5NruTr3A7+3QhbB8DZg2wucwLWpHK2oJ2mMel9BZPa/XUOI+wGFWS+uxQLUi2lGA5OeIUlPzmv40vau1RYMA+iWD3mdGYt25wpqM2OoejfCSEOt+gc21CJuVf2Pb1JiGF1CdyKEI5O95A3xZLyqetIvUumb9A1qU6OiRrQuNVNwq/esvW1LLitU6/jTTd5f0LraOEzJlsZ8z7+0o5N41nVwJ8uuuQJnMbQ5BpADzuaMwOIwmJK5hareJjQfBOOTBv1Vr167VyHFWbxABBGmd1K30v2u1wtEbncR8LUIp9k73NoboAUmqg3XlJD4uOU68vHtaNk3GoO+DEeM5Zl8AhZgJX38d2TGeIlwn0Ww+B5zc0LYDsQz9IV8eKLP3dpLEFJQx45d6c7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(136003)(39860400002)(376002)(396003)(8936002)(38100700002)(41300700001)(31686004)(86362001)(186003)(5660300002)(31696002)(36756003)(6486002)(53546011)(66556008)(8676002)(66946007)(110136005)(66476007)(4326008)(478600001)(6506007)(316002)(26005)(2616005)(6512007)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmttTHBqOThZSHN4Vlo4L0dyNysyQUJuQVlKbTByQmV1dVhveldKNU1ZU3RG?=
 =?utf-8?B?a011RmNSV2VhTklFT1RXRGQrUE5XN1RzOUVoeDlaK1dWaGdkUHc1TzdPT2Nj?=
 =?utf-8?B?NTRLM3JXdWEvejlvOUNlRktsUHljUjZIL211WkNiVnlyK1hRNmY4SGR2T3Bt?=
 =?utf-8?B?b0plQ212T0RKVlk3eUswVzlNTXg0MU5tSTNBckR3SmNOOGx2d3ZGcWR1OWFT?=
 =?utf-8?B?L3NQWmxZSmlKT09GUEpxeXo2eWxEVUVET09QNldHM2RlOWptMlRTNUVWNmxT?=
 =?utf-8?B?Ni80a0tab003SWJGTWkxRXpja2lUQWFHemVWWHNVc3Boak9CYnc0cmNXR1F0?=
 =?utf-8?B?bzd4UUNDNzNncUwxbzlpOUpGcDgrNU5tSVBxclgza3YrOXFjY2JkKzZVOHI3?=
 =?utf-8?B?ZUptckY5NGV2UCs1Z3JpUjVueTE2TzRYV1pxVHdwSkhaMUUrOS9XRDdJQ0pz?=
 =?utf-8?B?Y3FNbGROSlhlNXhOWS9naVpQUDMxNWc5emtTekhMV1BqU01aU2JZcDZKRXlt?=
 =?utf-8?B?cjlXWlE2SWluT0tVS2V2MHBEalFwdkdHdUhZd2lUd1BGbVhMYjV3alFvWHJT?=
 =?utf-8?B?OXEranJLM1hXa3FxS2RoYXlBa3ZJWlIrcXBaZEFTelVrY2hlQUZmU3JVajdz?=
 =?utf-8?B?bnRZbWFkMHBNY051MVpxUzV5MWFrNytvakt4MmlRSFpjWjFiUlFyQnBGNERi?=
 =?utf-8?B?TmJobGMwU2RabGtMWE9MaFQ1RnltbVNZYzJyMVVHT3FubWV6SEtCRWNHaUpr?=
 =?utf-8?B?K0Z6WEpmVmxXbW9GZk5iSEhQQnRldm03cDR5ZVZuQzF0R21aU2RiTFJHYklN?=
 =?utf-8?B?OExwMmNxbHZsM1IxTVhRM3ZDdStrTkhFWDBsZlVQTE4wNWZzdmdXZHRudlI1?=
 =?utf-8?B?Q3dKSDdaVEtFeVFMYnppNlFFSGl1bExpT2FFV3ZzREtxMVRwcWpNRkEzZHZC?=
 =?utf-8?B?SXA1cXR1azc0dHNXTnpHV1g3ZWw1QU1SUitlQ05CTVduekdMbzEydlBvUHBZ?=
 =?utf-8?B?SEtWUGdOcEpud2xXaFpzWS9kcnhxZ0xGVGYxSG5ZWFZCNXRCV25GTWVqemts?=
 =?utf-8?B?U2U0VktIZkJzSGc2QzR4NTdKRVlGZXNlWldRN095Vjg1aGQ3R3dUREFzYWFq?=
 =?utf-8?B?QWtCWWpPUFEyazlMQlU4dUo5dUJ4SjZFMGtHUk9FUVlwVllEeVNNaHJpblZ6?=
 =?utf-8?B?KzRSTE5EZVgzQnlwZTVyYm41OTE4VmRiY2NoZVhBQjRJQWVoK0pwazV6RVIy?=
 =?utf-8?B?LzZQb0lxbndmeUlHYkVaZ3ZycEk3VlJQLzlGcEticDB2T1hpNzdTU0ZaTExY?=
 =?utf-8?B?MUlrakI2ZEdxMW5vcThCck45eTA3TXZWZkNSZ1F4S0VFek5xMXhBbXgyemJY?=
 =?utf-8?B?QTFXVm9TSCtkNlB3R0YybVY2S2h6d0tUZDF3SXlkcTNMbDhEOFZDdEY0QXdO?=
 =?utf-8?B?UmpXSFRQL2ZRK2pCbSt6M1ZINkxIVkthRk5JemswRFJpWDY1dENTZlFTWUtV?=
 =?utf-8?B?cHQ3S0xsTjhzYklzM256Z1FrTlhaMWpPVm1pQ3UzVEpFQnhTanF1Z1pxL0Nm?=
 =?utf-8?B?M3U5Q2l1U2MraEVqU0h1dDhLR09waVh4SmZQUGgrRzBIL1VCSW4zUzRzbTJn?=
 =?utf-8?B?SW5TbXpHdXZUbWRYdDRmallMMjFuaHdKSG5zTVZoOTR2TTg4d3BrNVp3QzM2?=
 =?utf-8?B?Rkcrc1FCb1lvYWhlQUoxMytTL3BiWHpDWFFwWVVDMzh6Vk9yVHhDOGU1WEZo?=
 =?utf-8?B?eVhwMVFGQUJqc2c2RUV3b1IrMlpIL1NxOS81Tk9aOGk4Y0dkclcxUXRsZ2sv?=
 =?utf-8?B?SW9YVjJWL05pdmtBdUkwZWtoT1pDRUVITUFiQWp5ZW1JcVRwNVFMR1JhZC9T?=
 =?utf-8?B?ckJNT0xGNXJmUTV3OFlVZ0ZjV21aZmM1ZjdMcGNwUE1XR3NGZWI4SGNjS3Ix?=
 =?utf-8?B?SUhPNVh4ek0wbDJZd285MGVnU2lGM2V3Zk5JV1JsRjNOcTZjWTdMTkpxM1Jp?=
 =?utf-8?B?bDYvRjBybHNkTzM5ZlMyb0xScEpONWkwMGlsMEFIbFdrbzdoTnBGWHB5Y3Y0?=
 =?utf-8?B?dWtRd0hBYVIwditOZVVTSUdEbTNYdmdObFBKd1FPRy85ZmlhdTdzbVVLdXBK?=
 =?utf-8?B?dDNKTnB5NjFONHdmakFGUEg3Rkg2T3poVEZJdVlnUy8yeDhISXhZc214T2pY?=
 =?utf-8?B?VFE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 504365c4-f2c3-4700-36d2-08da6f579e47
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 22:38:53.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oT+Kdn9WSi8ooy5maUz/uCZQyTUTpYYOZ0b1q3hXpCem2MXPaN3BSKkLSCwcheK26mgDC+THMQL69zGJvSfE7ROo+Kt8zp7JEaVYDX7a5Q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1511
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-26_07,2022-07-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207260086
X-Proofpoint-ORIG-GUID: xWW3InXma65iS6-SgceEs3ywzM3EhE7P
X-Proofpoint-GUID: xWW3InXma65iS6-SgceEs3ywzM3EhE7P
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/20/22 6:28 AM, Dmitry Bogdanov wrote:
> @@ -1437,34 +1435,26 @@ static void core_scsi3_nodeacl_undepend_item(struct se_node_acl *nacl)
>  
>  static int core_scsi3_lunacl_depend_item(struct se_dev_entry *se_deve)
>  {
> -	struct se_lun_acl *lun_acl;
> -
>  	/*
>  	 * For nacl->dynamic_node_acl=1
>  	 */
> -	lun_acl = rcu_dereference_check(se_deve->se_lun_acl,
> -				kref_read(&se_deve->pr_kref) != 0);
> -	if (!lun_acl)
> +	if (!se_deve->se_lun_acl)
>  		return 0;

Will se_lun_acl and se_lun ever be NULL now? Should this maybe be a
WARN_ON or return a -EXYZ error code like when target_depend_item fails
at the bottom of the function?


I don't think it's a problem with your patch. I think we had issues
before it. If they were NULL then I think we can hit issues like:

1. __core_scsi3_alloc_registration calls core_scsi3_lunacl_depend_item.
If se_lun_acl is NULL and we return 0.

2. __core_scsi3_alloc_registration and other callers treat 0 as success.

3. It then does:

dest_lun = deve_tmp->se_lun;

pr_reg_atp = __core_scsi3_do_alloc_registration(dev,
 				nacl_tmp, dest_lun, deve_tmp,

4. So if se_lun is also NULL then for __core_scsi3_do_alloc_registration's
args we have:

dest_deve, as non-NULL
lun as NULL

5. __core_scsi3_do_alloc_registration will then do a

        pr_reg->pr_aptpl_target_lun = lun->unpacked_lun;
        pr_reg->tg_pt_sep_rtpi = lun->lun_rtpi;

and since lun is NULL we will crash.




>  
> -	return target_depend_item(&lun_acl->se_lun_group.cg_item);
> +	return target_depend_item(&se_deve->se_lun_acl->se_lun_group.cg_item);
>  }
>  
>  static void core_scsi3_lunacl_undepend_item(struct se_dev_entry *se_deve)
>  {
> -	struct se_lun_acl *lun_acl;
> -
> -	/*
> +/*

Just drop the misformatting bit above.

>  	 * For nacl->dynamic_node_acl=1
>  	 */
> -	lun_acl = rcu_dereference_check(se_deve->se_lun_acl,
> -				kref_read(&se_deve->pr_kref) != 0);
> -	if (!lun_acl) {
> +	if (!se_deve->se_lun_acl) {
>  		kref_put(&se_deve->pr_kref, target_pr_kref_release);
>  		return;
>  	}
>  
> -	target_undepend_item(&lun_acl->se_lun_group.cg_item);
> +	target_undepend_item(&se_deve->se_lun_acl->se_lun_group.cg_item);
>  	kref_put(&se_deve->pr_kref, target_pr_kref_release);
>  }
