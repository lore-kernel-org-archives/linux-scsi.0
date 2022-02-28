Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE77C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Feb 2022 18:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbiB1SVz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 13:21:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239850AbiB1SVj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 13:21:39 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06A2DC9928;
        Mon, 28 Feb 2022 09:59:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21SHnDuW015661;
        Mon, 28 Feb 2022 17:59:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bhGM5N2Kry7m3j+Gv6PPYwmkvHYZ29POMUS4UC0gAX0=;
 b=KiFy80z+6hxnzKQ7OVi1/4bTlvVW1wT0hHeH+2aWNws/w70xrrf0xig8yokhA6DkebNG
 Cs5RRw0sZe5UY4fI/A9yWFfn1TjQQEiXoYGoSswEdK0Hd8PsVDEd5awhCShPLbvYbM/2
 QWPCC5AkAJIpret81XQP41nUbIcl53Kbv2ah4W+4pvAlhJJobQlScWtqhY/U3Wqt713r
 CDqkxZVYnncPXHtj9d9U/pLJGaD23621pLuYxizVUbwALjfEy8EEJzRiMDf2sh4g5QgQ
 T8UOM07LxUoX1MAvkMdSB3WOYnbbvUWiZi8mSKIErMWG9ATusuxmROqnNVDa+PIz2VWC 6A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14brgnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 17:59:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21SHtGbQ076650;
        Mon, 28 Feb 2022 17:58:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3020.oracle.com with ESMTP id 3efdnkc092-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Feb 2022 17:58:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dUGn0/FL00yrToEbD1zFFjNeuaEhBuQ2dpYF1jcnR+okU8Cao3qwz7A/pToNGDmx5kZzg2OOuUCNZ/H7Q9tO+pekNZlVaSTwV/zpftAr7m3DfLz/3t9bwVfOgGq7V1xXEfmf7CRJ7k2yZxyb7c/2WU3m4Xe71ypEJn7PAkBPUl0Aq3z/5ed1d4R+oOaqAASRtQbgoTGV1C88lwrC//Se1nbh0pWoLxD8hiBm7Fmsn/kggpkhIoBBEAQga9xZv/+RjKCNfi3953KPHwwnGSkuwW93lWYWNRFVTJYgcct6B4fms+rMhDQdLfzW3GUSihv2o1O8jJQH1im0ZO5oheIk9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhGM5N2Kry7m3j+Gv6PPYwmkvHYZ29POMUS4UC0gAX0=;
 b=aF+z03DBS+w1z6kTHlE6uxg2mkBtfXCR4KXTtbzGl1CD0SJ2JVT65Kk/wBE9FqtDAjiv6jRG5nIy4Vn95E+t1AfI+bNcZ8FY1Lxgyl2OaLViWKTx1Hbx+QqXhDrFvNQ0zMgc9Gl0o40bOnFymlAv6U/oNJ1u4ERAiQ6Kw9dMMBE/AfJtpLgEjQpQSdJlC64rNm5mOQFvEBI+hs9so3WQb3jnS+EZcIP7dXxSvf9myWsOjnMqHfnnocIymyu3mtO7B5SYh0edIXvv0zf40jY+mcLvmoeO5KjbD6qB0Qqkr6lxaIxtFWyRqKXQ6pCrEUQ7RrvOsF6gQBAUWnE53rSGlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhGM5N2Kry7m3j+Gv6PPYwmkvHYZ29POMUS4UC0gAX0=;
 b=eBWYbUsmMtNRJrIRVuTf/CAWUzJWLi0XbEul3BwVaCyKtl8ORq02ZJfFQE769B1LIsS61+TNRcAJdfSyMyPE/fKnugkuY55o74rJ4EfqJ+WBbnwDmwhZzgTmX3De2L2Xcv4TC0S3fedzoo/0RRc6Hff6NFcP0klsXPaPh38E1MM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5595.namprd10.prod.outlook.com (2603:10b6:510:f7::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Mon, 28 Feb 2022 17:58:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5017.026; Mon, 28 Feb 2022
 17:58:57 +0000
Message-ID: <2f65d5dd-f2d8-3279-5a71-691614e65ae0@oracle.com>
Date:   Mon, 28 Feb 2022 11:58:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] target: add iscsi/cpus_allowed_list in configfs
Content-Language: en-US
To:     mingzhe.zou@easystack.cn, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     zoumingzhe@qq.com
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
 <20220217074511.9696-1-mingzhe.zou@easystack.cn>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220217074511.9696-1-mingzhe.zou@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR03CA0070.namprd03.prod.outlook.com
 (2603:10b6:5:100::47) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f120ed6f-08c6-4c5e-f765-08d9fae3fdb1
X-MS-TrafficTypeDiagnostic: PH0PR10MB5595:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5595C3F1FBCECD40C71BBBE2F1019@PH0PR10MB5595.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMmI/JM4m6zlXSBZVUVt7JYZ1oKWnsCsovATlnHe4sBvYFmV3dIAGTQzGMBXOBDMCBsx6Zpv+/ARqnSNFgDz01IxNp/rCU/TC8c8xZMZwaNc4ClQoJuUH6O9F/aUjwKraT1AuHDVKhuSHb62hLHp+cGN8L/FiIOtWG4R2VPFzkZ5Ykgile5kdjqtEE0keWv9BIxsRN1sAijHLld7MSI+QwhR6VfdEUPT4Qv6eNTq81aBSkLmnl5odAbNcEHD1+9ITLsckWfWP5URSCZrTYw2VPSRNRB8D0uBC6WEqKLMD545ECSlE49xxwuF6QTBGyFMLLmJO7qqrthBVTjp05GXBQ4cF0gFPE7amsYy0hDVWRcebKklLYGH66eONHL/u8S4TEChOZu1eyCnP32OoXgJkmy9mKsfc/Azycyk2GpBSvK1CjONDITczvkk51KCNDdlQMMMTofQnwIsT6tEOzAsYRQxUMsf1MuyMoOZ2y4wcL1lNj6VXW/PZy6RTvh8xCNH/KCroEOd/PNjgYE05C5BT0spbhLj87qbJzkezo1Rzor7kXTPfWAQL6wpa0/Nmdnhe50fNwq8UyQVIvAH/dEUq4vl1vVprQX3lOt5upcJaLGOh8n11ABNcm2nRygGPl61yfq+R8b3bzVHY+VRDknOF5WyfpcQBUzqFfy4LBlYA9r8kiMR5do93j2bp1hDoXDrnvRC6rtEaERkUq4EF+MNo+HRF+GSynlowYp2gCirRSw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(26005)(186003)(6512007)(86362001)(31686004)(38100700002)(6506007)(53546011)(508600001)(66476007)(31696002)(6486002)(316002)(4326008)(8676002)(66556008)(66946007)(36756003)(8936002)(2616005)(83380400001)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2d1bjNpRitZSDZmUDRXbEtWcWVnOGMxYmxBR0Y4VXB2Z0RtdXNsZG1PS3lY?=
 =?utf-8?B?WEJvaXhyQk9IWEpUUUsvOWw1d0FWOERGamR6WWtyeFdhbWpSMmVTZHdObzhk?=
 =?utf-8?B?c2FuZU9iTm5EQmVBQlhYVS9sS1ozMUdhUURFOWpFbzJuS3ZxZGpVOTdNamJv?=
 =?utf-8?B?SHYzUmt4WmJkNGpJN1RiNHEyNmw1QzJYYStyZWpWWmhsOFl0SkxYVFc3dVJ0?=
 =?utf-8?B?bVNGUDNWVEU3Y2pkdUsvbGVKVU9XMUQ4cHkzanN1azFZNlRjZ0RQK2drRktp?=
 =?utf-8?B?VllWWk1pbHk1bWI1ZTdwU0Z4ZUpZQ0ttNDYyY2VUM3IzMXMvL0hKbk1wdk9L?=
 =?utf-8?B?TkNxa2ZZMUY2eXc0WDNlZWk3TXQ2V1FwNEQ1K2ZJMzMvaTBzNUdxWEE3bFdH?=
 =?utf-8?B?c1o0TVdOeGdPTXAzbllLcXNORC9TcW5ud3dSY0pEN0IwVlZGM0JScExNU2lV?=
 =?utf-8?B?bDJMVXVxMWlSbDNFUzNCQmkzTEEzKzM3SDVCWUJidDF6bUZmbWxKU3J2dmdq?=
 =?utf-8?B?aitodHhkTk92Qk5GL3VQTEJ4Y1QyZzJCTUFuZ2g1R1dUeDhFZnFESitPM01k?=
 =?utf-8?B?Qk5XZGs5M1dPRFhrRXFFazFKbEMwTFl6VDViRDdoalZEaTNJYVJ3aGszR2x1?=
 =?utf-8?B?SUlkNnJzb25yM2g5UEV6ZE5nNDJwYlZ5VHhFUW9JbDM4cURhZ1BZN1BweUoz?=
 =?utf-8?B?QWpQaEl2Z3ZTdWxXR1BzQnpKNFJyS0dnU0N0a0QzRndhaHJKeG8rcW56R1dm?=
 =?utf-8?B?UGhBdGxqY2x2SFg0RVFkdmlLTWp4Z3lTbVZwV0xlN0l6bkovdHVJcmNWL2hG?=
 =?utf-8?B?ODBXS1o4RGRmR0txQk5wZzRlKzd6NUhBVmtZQU9naE5XbkowK2VleHIySHFh?=
 =?utf-8?B?UFFkVXlraHZVV2ZNVC9MQTRwWU0vZk9FZm9WUHVWQS9aSjI1VTVJeEtDejVi?=
 =?utf-8?B?dmFDMjh0clN5QnJSRTExeVh3UVlsR2JSbCtBWlliSzRJWGcxNXNFTWsxeEpy?=
 =?utf-8?B?cllQL3JkaGRuelE4NmxPWTA0S21wUlJoM3NmWGFQaWRFU2dpTXkzdVFwZGlI?=
 =?utf-8?B?YVdRRTUrTklDT2s5MU5IZXE2T2U0cmV1VTZzZEpKa0Q3WG1sYlZXT1luZ0l6?=
 =?utf-8?B?ZFFId0plb1RPcENCMGVWK3piU1RHNUR2eWphL0tKdXpYVnArdmFnRWlBSXFZ?=
 =?utf-8?B?MGcwSGhTclQrek1uY05VYlBwWXVXenBKZkRxUS9NYis0ZDVDMjc3bXowdXZR?=
 =?utf-8?B?aFlrRXJ4dnowdGowRGxHT2JLVVh6Qk1oNTFjakpqakRQRkRKRHNnQXdDRHdY?=
 =?utf-8?B?Y2FZZ0FMY2N2ZzFIdGJIRnZjdUhrVTJkQ3E4STAreFFFcXdNcXBzWW50NC9V?=
 =?utf-8?B?dW8vaUFzeHVkb3QrWEEzRHpUTnlPWXZlY2pxWjEwTjhTYTlCSWM2ZVFaeFVM?=
 =?utf-8?B?aE83RTYvMUFaVGE4MHdHb0VNazVsc25QYkhiMlFJT08wTDNiaVdZaFQwL1hF?=
 =?utf-8?B?UlpTMGpWUWRpWUhKZHZaL1NBQVRuQllOVlk3WGRFYnN4N3J6V2d1TVdJa21z?=
 =?utf-8?B?SzhHUStaMG9qa0JWYWFmS0NDOG1PNDNtdm9Ta2Z3ZUJFenBEekd4TVQrK2xQ?=
 =?utf-8?B?NWo3anNVVi81ZjhGYjFOcVpXVVVrN2NmbTBQWjhmMHNEa25VVHNSOFc1S25Q?=
 =?utf-8?B?MlJSdnhjMWY4Z05SazdqWnpVM2FzOVUyNi91NnBWakdIcWxUVTBPbEFZc05l?=
 =?utf-8?B?Z3l6cnVYZUNCdUhVOHc4WVRuWC9ranVvMjVwVlo0VGJINUIvWHl3NXpYWCs1?=
 =?utf-8?B?S3VLUWl0dEk2TVBqVEYzM2pveVp0RUdMci9OZ2orSzRMRlp4YUlXdU5OR0hD?=
 =?utf-8?B?RkNzZ1c3cWE1czh2YW5SNXM1M1ZTbHpUK1dZQy9XZXMrTFg4d3ZFYkM2QVIw?=
 =?utf-8?B?dDJYMFVNbXB5aCtBS3A2a3ZmWXViUlE3ZE1IcGNDZVlaa29PUUlHNy9BUGh2?=
 =?utf-8?B?V3FpSE4yLzVYbTNBVXhwa0Y5dS9LSWxiZTJYSGtQUXRUcVRGS1lsbjJmcjdJ?=
 =?utf-8?B?UmpGa1Q2Mk90ck5saWl1c21KUTlJSFlHdGtRcmhDYldzM0JjNWQ0Z0Q0NFVz?=
 =?utf-8?B?bndFdGErMkprYkw1Tm0wN29pMEVpNmc1cWVRZGJuanR5WUVPOHJPM2NuaHlQ?=
 =?utf-8?B?bE5Xc3B5K3U1U3ozYmxjeHlFRnpsQ015aFplOHN6V3dHd0ZlQzVYR09Dc2tT?=
 =?utf-8?B?WTlBa2hMOVBQaHFybEpmbklWV3pBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f120ed6f-08c6-4c5e-f765-08d9fae3fdb1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 17:58:57.1861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M4fcEVy1oc+sTHmttwOX2yk5seVnxu40yfFYZmprdZ+g13fuACSvGiYqWuRsipYs4/NbK6piJdSWFIPefEyA87dWiE9ZijG/ODTwjMIyLF0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5595
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10272 signatures=684655
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202280092
X-Proofpoint-GUID: VxHwHc_eRageMKzih97aNY96_Lsr24X5
X-Proofpoint-ORIG-GUID: VxHwHc_eRageMKzih97aNY96_Lsr24X5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/22 1:45 AM, mingzhe.zou@easystack.cn wrote:
> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
> 
> The RX/TX threads for iSCSI connection can be scheduled to
> any online cpus, and will not be rescheduled.
> 
> If bind other heavy load threads with iSCSI connection
> RX/TX thread to the same cpu, the iSCSI performance will
> be worse.
> 
> This patch add iscsi/cpus_allowed_list in configfs. The
> available cpus set of iSCSI connection RX/TX threads is
> allowed_cpus & online_cpus. If it is modified, all RX/TX
> threads will be rescheduled.
> 
> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
> ---
>  drivers/target/iscsi/iscsi_target.c          | 66 +++++++++++++++++++-
>  drivers/target/iscsi/iscsi_target_configfs.c | 32 ++++++++++
>  drivers/target/iscsi/iscsi_target_login.c    |  8 +++
>  include/target/iscsi/iscsi_target_core.h     | 31 ++-------
>  4 files changed, 109 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 2c54c5d8412d..82f54b59996d 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -702,13 +702,19 @@ static int __init iscsi_target_init_module(void)
>  	if (!iscsit_global->ts_bitmap)
>  		goto configfs_out;
>  
> +	if (!zalloc_cpumask_var(&iscsit_global->allowed_cpumask, GFP_KERNEL)) {
> +		pr_err("Unable to allocate iscsit_global->allowed_cpumask\n");
> +		goto bitmap_out;
> +	}
> +	cpumask_setall(iscsit_global->allowed_cpumask);
> +
>  	lio_qr_cache = kmem_cache_create("lio_qr_cache",
>  			sizeof(struct iscsi_queue_req),
>  			__alignof__(struct iscsi_queue_req), 0, NULL);
>  	if (!lio_qr_cache) {
>  		pr_err("Unable to kmem_cache_create() for"
>  				" lio_qr_cache\n");
> -		goto bitmap_out;
> +		goto cpumask_out;
>  	}
>  
>  	lio_dr_cache = kmem_cache_create("lio_dr_cache",
> @@ -753,6 +759,8 @@ static int __init iscsi_target_init_module(void)
>  	kmem_cache_destroy(lio_dr_cache);
>  qr_out:
>  	kmem_cache_destroy(lio_qr_cache);
> +cpumask_out:
> +	free_cpumask_var(iscsit_global->allowed_cpumask);
>  bitmap_out:
>  	vfree(iscsit_global->ts_bitmap);
>  configfs_out:
> @@ -782,6 +790,7 @@ static void __exit iscsi_target_cleanup_module(void)
>  
>  	target_unregister_template(&iscsi_ops);
>  
> +	free_cpumask_var(iscsit_global->allowed_cpumask);
>  	vfree(iscsit_global->ts_bitmap);
>  	kfree(iscsit_global);
>  }
> @@ -3587,6 +3596,11 @@ static int iscsit_send_reject(
>  void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>  {
>  	int ord, cpu;
> +	cpumask_t conn_allowed_cpumask;
> +
> +	cpumask_and(&conn_allowed_cpumask, iscsit_global->allowed_cpumask,
> +		    cpu_online_mask);
> +
>  	/*
>  	 * bitmap_id is assigned from iscsit_global->ts_bitmap from
>  	 * within iscsit_start_kthreads()
> @@ -3595,8 +3609,9 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>  	 * iSCSI connection's RX/TX threads will be scheduled to
>  	 * execute upon.
>  	 */
> -	ord = conn->bitmap_id % cpumask_weight(cpu_online_mask);
> -	for_each_online_cpu(cpu) {
> +	cpumask_clear(conn->conn_cpumask);
> +	ord = conn->bitmap_id % cpumask_weight(&conn_allowed_cpumask);
> +	for_each_cpu(cpu, &conn_allowed_cpumask) {
>  		if (ord-- == 0) {
>  			cpumask_set_cpu(cpu, conn->conn_cpumask);
>  			return;
> @@ -3609,6 +3624,51 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>  	cpumask_setall(conn->conn_cpumask);
>  }
>  
> +static void iscsit_thread_reschedule(struct iscsi_conn *conn)
> +{
> +	/*
> +	 * If iscsit_global->allowed_cpumask modified, reschedule iSCSI
> +	 * connection's RX/TX threads update conn->allowed_cpumask.
> +	 */
> +	if (!cpumask_equal(iscsit_global->allowed_cpumask,
> +			   conn->allowed_cpumask)) {
> +		iscsit_thread_get_cpumask(conn);
> +		conn->conn_tx_reset_cpumask = 1;
> +		conn->conn_rx_reset_cpumask = 1;
> +		cpumask_copy(conn->allowed_cpumask,
> +			     iscsit_global->allowed_cpumask);
> +	}
> +}
> +
> +void iscsit_thread_check_cpumask(
> +	struct iscsi_conn *conn,
> +	struct task_struct *p,
> +	int mode)
> +{
> +	iscsit_thread_reschedule(conn);
> +
> +	/*
> +	 * mode == 1 signals iscsi_target_tx_thread() usage.
> +	 * mode == 0 signals iscsi_target_rx_thread() usage.
> +	 */
> +	if (mode == 1) {
> +		if (!conn->conn_tx_reset_cpumask)
> +			return;
> +		conn->conn_tx_reset_cpumask = 0;
> +	} else {
> +		if (!conn->conn_rx_reset_cpumask)
> +			return;
> +		conn->conn_rx_reset_cpumask = 0;
> +	}
> +	/*
> +	 * Update the CPU mask for this single kthread so that
> +	 * both TX and RX kthreads are scheduled to run on the
> +	 * same CPU.
> +	 */
> +	set_cpus_allowed_ptr(p, conn->conn_cpumask);
> +}

We can hit a race where we call this twice for the same CPU right?

The rx and tx thread both call iscsit_thread_reschedule and cpumask_equal
and it returns false for them. The rx thread might be faster and return
from iscsit_thread_reschedule and is setting conn_rx_reset_cpumask to 0.
Then the tx thread is sets it back to 1. The next time the rx thread loops
it sees conn_rx_reset_cpumask set to 1 and calls set_cpus_allowed_ptr.

Is that the only possible race? If so it seems ok. Maybe just add a comment,
so later when someone else is looking at the code they don't waste time
and think it's broken and know it was intentional or at least we didn't care.
