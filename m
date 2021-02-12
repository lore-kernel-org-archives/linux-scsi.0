Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB6BAC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F0D64E2C
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:36:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231660AbhBLTgB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:36:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43542 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbhBLTf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:35:59 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJYEpL122249;
        Fri, 12 Feb 2021 19:35:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=bAR8TklF90kqFQCabdXyedBbspXzwicNwQG1VxaoZYA=;
 b=XQQvxOJ2IFflS0DvB3gESLskc/ruLBwb4NIN+wHsVF6x6LpW2L+Ebas0aSzhKZAzzeHU
 EkM+qfinM3uz8+q3CGO9axRzqVzmveQnJvsIzCdf7Zjk6+/0cjndEEBt7l/DcqrjDPXA
 XWnjOae5FmukcrrJBicIZROxS1qzGxg6zPeehxLCB+yjVDGnSL0cQWtj3v9s8ZBlgZsk
 eF2gENgcW3RzmjOUzpDY3VAxZmExTTsru3kwf8MJdg2VRu1k24PJTI/sX+cI3dBqx0ui
 jZYK7M8f+bHHq4uNXjdn6A9jv66D1+eEl7SiTcSjNLgrwChgvQMvhomq2Xf0fC3D9Id4 kQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36hgmavh3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:35:12 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJYpDm020184;
        Fri, 12 Feb 2021 19:35:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 36j4vw46mp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:35:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FRKz8JRsb8sdKMYfzLKzGg6ZB8Fb1fx0yryk1shaa3IOMe76+2t0uRfEEnV0nNlP/RVs36c91oMPWhAU9ozf7Bq8lrONcddtweyEm+mDfShz0i8QrG6+OBpRfRLFOlQ92uYt4JuuxroIsLZBR4Z/FlGLw4SkBKUhTEJUYSifyaaJVS2nFQ7nM+lsCE/CuZww0dxXrplRlD2LZCqrJwg2GaQYnMvpkB0J5EKi21Td8tBVB6NhS6XPqqZxkIp33P8wFye6IBkqjSt3TyA32gdNVetLYsT1BUsSlUEI+BTsolzVIDeT+I8uXwi+U8op+4/le3VTXxDhtEAxaezYX04aWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAR8TklF90kqFQCabdXyedBbspXzwicNwQG1VxaoZYA=;
 b=WVioAnChuEkASuuDPixldP/o9kl80P8PB0QtXlPgZ3MnTa4DOq89o8NvPmjJuFGX8zcxcly5pWtx2+9o4mmOVwv1mt0RijOXsMgYxOYda9WNj1SCLBPvPLeQxAIUuEeB93SLGVi+Xbam89eGuQ+tEPjrPCQaQuBZqHzwfoPigM0+GnbxiV9Gftxre7jjp9tU88u+2T9cD/HruFk8p3sfabXeo5Sgr/LvsgdWizW1aUduKyo8FGfq/OafIPMUCClzeTgAWa6Hi3+X6edUHGOZitRRBmmwtNXZ048NNj4u0Z8bFbxjav9FdEN06rjSEfWEej/WNAsmtOvHWExlQNajrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bAR8TklF90kqFQCabdXyedBbspXzwicNwQG1VxaoZYA=;
 b=yLWMKCbzv4nhj++Wf+qqhEnC0BYgE+h6vgwjz88UlxA1b9kYbTQZJhMMR4aUlpO+i2s1hIXWbMXncMzIq0hsnHJYbg46/LvOfjmcThm+tGZTwdQ7Lmsu74BOnDEqIYjhUPlH1tz+3QvDp6c7X3v9kiZ1UxeJp52idzKERLUaUrA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2559.namprd10.prod.outlook.com (2603:10b6:805:44::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.31; Fri, 12 Feb
 2021 19:35:07 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 19:35:07 +0000
Subject: Re: [PATCH 25/25] target: make completion affinity configurable
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-26-michael.christie@oracle.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <7023f725-4e8e-22dd-03d8-e35f72a6401e@oracle.com>
Date:   Fri, 12 Feb 2021 13:35:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210212072642.17520-26-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0701CA0026.namprd07.prod.outlook.com
 (2603:10b6:803:2d::24) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.20] (70.114.128.235) by SN4PR0701CA0026.namprd07.prod.outlook.com (2603:10b6:803:2d::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Fri, 12 Feb 2021 19:35:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aabc8db5-dbb0-41d3-9e63-08d8cf8d4dc3
X-MS-TrafficTypeDiagnostic: SN6PR10MB2559:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB255983AE1832B4ED7D18EEB0E68B9@SN6PR10MB2559.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MfK3A60MGApiVFr5lT8pX5EjNtzm+TNHOFSbbVjipfOfzH9ZscXet3pwGWZXDMnERaxGEtYgAZGsGjYfnbhe0CRstSr+BHzyfB+fyjFx51bPNeRnOr3GS4EWExF8vH2ddgj45eL12hYIoMpeVELDz28Vx9rQBqtZ9n4rpnBzjJ64YzlojTlekN9SObPnZxkA6PXHRwOE1XjXmYuNh1NJKSldxfIdxlG4/tSJCeXOjTIZrzkPwo4UUntPK99Spi8UZR6Ndd+ZCu6INPXnFOLrUUDIXl6GW1A7mteo1sQyeaLljENxKjreNlsgu67ooAVIHoFawMzKEdGeTk2fx2cW1iYqznd1MvY9akxR2GVnzD+IunFfWbnXco5MOx+aULO2JckkYzl8iqfBOtFE1trqU97MDjjJ4nlb3Tx6JgPKpA1PBFSqmoneXxwDdlG4QCru/1OEI1lfPF6Lqmy2A7RRxMmP44q2L3K3cI1xhdUYkhqI+0fXUoPmwXlBAnFa5VQ92PScQag3lBDfQa9SUfOQ4VFDj8iHbyELwckjPD26s6yzRZ/akwujLBLEZLC7sT0LAQ7zByClODzJguY9vydF/I+UTi+E7S8rQtt62aI1glY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(396003)(39860400002)(346002)(8676002)(186003)(66946007)(26005)(16526019)(53546011)(66556008)(66476007)(478600001)(8936002)(36756003)(83380400001)(956004)(44832011)(36916002)(31696002)(5660300002)(2616005)(2906002)(316002)(6486002)(86362001)(16576012)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cnFMbHZDYWMxMWVvaUtEKzVUUjcwREtUNFVudWRuQlVrMm90QkVsa0tCTkJl?=
 =?utf-8?B?Q3NJamlVL0xTSjdaVUs0SlpVWEpkVllHUXUvbStJNHZiNnpxbldrQ0tHQWk2?=
 =?utf-8?B?UHBSenhCVWdTUzZyaUZYZ0RwTWRJSGZGRlk0ZU9saDZrZTQxVnhvaFFPTGhw?=
 =?utf-8?B?dnArVTlNUnI1ZytubnF1OWpGL3hnYytOUUNTQVg4YWY0aGN1MFlJS2h4cTY0?=
 =?utf-8?B?OGsrUE92SW1vM1JkcFdQb1VxV0VCWUFxVUdiQ1dBMjJCNlpZa09wVSt5YUJa?=
 =?utf-8?B?ZDF0aGQvREd0UHdudzNvVklmY01uenhTT0ovWUh5OEk1ZzIrT05mWXFnd2Uw?=
 =?utf-8?B?N1FCQmVVMENtdHdNTUR2dnRJeEF5eEtuaEw0eTczZlUvMXcwTkxEaTkxZnFZ?=
 =?utf-8?B?Y1RwcHFFVStZYXROQTVnYU92cHJyd2hpZFlYVFFuWjhQRHkzRzR5TUVnUG5o?=
 =?utf-8?B?U2FPODRBNFJ3cmVlSjFnOU9nREN1OXJRT0xOSVpIL0Y4cStENm9lUURVZVRF?=
 =?utf-8?B?KzBsK3J4THhRRm83ZHNxbzVQV2ViMGZQSkllc240b0RxSVlzS3MyMnBOVmEv?=
 =?utf-8?B?aXVwZEYvUHE4SklYTU96bC9kcXB5bzQ0ajdhYmIrY293ZWR5SzFTQWkrdnBZ?=
 =?utf-8?B?RFdZSkc2S1RmYjFTUEtSbXU4VTlXNWNHY1h5eGhsd0huRXdpcldBSXFSbzY1?=
 =?utf-8?B?bVBybStUSE1pL0FzVXVKYi8ycjJwMW02M0Y0ZUxremZseUFCS2hJeUpDYTFS?=
 =?utf-8?B?OSthaSt6NlZOT0NJWHk1OGdBNE9GeG9RWTJWeXpaamkySTNoNkhEaWFRY0xQ?=
 =?utf-8?B?SDZlQ2RYTE1hNkdFOCtzZStrcFJjOW12V3ZEYTFWWWJvb1hGelJVMnNQdThu?=
 =?utf-8?B?WmJFVGdwcGFReFkzRFZtZ0FVS1l3RkVEZTJwWDBRVWhWS0U0TVNSSTJEc2ZU?=
 =?utf-8?B?dWQ0MlAreXRRMG4xTVltNUFhUENkWW1EblJxM2hKOE9Ya1hrZEtqdUh4SDJZ?=
 =?utf-8?B?QXgyem5hMno1bjkybDcxOURPZDFMRnh1b2tHUzc0RjR5OTloQ0ZoQ0dxTkNL?=
 =?utf-8?B?THBxYWZ2TXFoMk50QmxlUThHVENvd3J0bTBKWFBvTWNSTWZWRXhKbXR0bnB1?=
 =?utf-8?B?cU5aazhCdnBVUGxxK0d5MzdOOHVTUFZoaGMvdGZBK1RlaVJQeUVLWXlYNmRK?=
 =?utf-8?B?cURUNW1zclVCMVdVRG91OTgxVlBLbkE1dEpkc2I1bFRpSmViNEl6UTJhSTdS?=
 =?utf-8?B?akdRUjNOeHRqOGlQSnkrS0RFemFyc2tlSjd0Wnh6eFI5bDhaMVprTHZOMkV4?=
 =?utf-8?B?UDlMZWRVRTFudzd5QUFTdWNoYkt5d3lqUkJLT3greWc5S1hDWHJpSWlIRThk?=
 =?utf-8?B?SXV1L1U3bnlvaUVlNkR2VnoydnI1eXI1QzlpTWVvekxBc0U3QzRybERnYVcx?=
 =?utf-8?B?YlU2akhPK244T2lEZU9HdkVoOEQzeStHVGFYbWF3aEFodGo4OHhZSTF1ZWo1?=
 =?utf-8?B?L2dTdDlXNkJTWDdxV0srOTJEQUN2WmpCQXhGb3ZBUjNsM2M5UkNhdFlmMFVu?=
 =?utf-8?B?bmZTYXZFZ0RDaFdscXpMRHMwcnhsK3k3VXE5ckw4d1RhVkNpZ05rSUVLK1do?=
 =?utf-8?B?aURnRjlSR2IrNnlmL1hwREc0YWJxeVQzNkRIczR3Ymh3czlCZFRHWC9yd0U5?=
 =?utf-8?B?MVhPa2Rnd1V0eENEZWlIVnFncEliRGwwd0JJK0g4bU9URWlvOGhaR2t0ZGd1?=
 =?utf-8?Q?h2TQe0o7j9PgcNjihR6f/tGMKvJaRuinz+gxBeR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aabc8db5-dbb0-41d3-9e63-08d8cf8d4dc3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:35:07.6528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5+LyJylY3mj9nPSmyXmfzF35WoGjFfnoXW/picTKx9ValO/vl7w6sr1Ccelb7oFwL+6KMqeOjYcXLbqBGEzc46SnG8y4Oj1cUkayrFEfyfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2559
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120144
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120144
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> It may not always be best to complete the IO on same CPU as it was
> submitted on. This allows userspace to config it.
> 
> It's useful for vhost-scsi which has the single thread for submissions
> and completions. Forcing the completion on the submission cpu is not
> always the best thing to do since the thread could be running
> on a different CPU now, and it conflicts with what the user has setup
> in the lower levels with settings like the block layer rq_affinity
> or for network block devices what the user has setup on their nic.
> 
> The new setting is in
> /sys/kernel/config/target/$fabric/$target/param/cmd_completion_affinity
> 
> Writing 0 gives the current default behavior of completing on
> the submission CPU. 1 completes the cmd on the CPU the lower layers
> sent it to us from.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
> 
> Note: Christoph, in basically the previous version of this patch
> which had vhost-scsi hard coding the behavior you asked if we could
> set cmd->cpuid to the WORK UNBOUND value. I could not do this because
> code uses the cmd->cpuid to access per cpu structs.
> 
> 
>   drivers/target/target_core_fabric_configfs.c | 49 ++++++++++++++++++++
>   drivers/target/target_core_internal.h        |  1 +
>   drivers/target/target_core_transport.c       |  9 +++-
>   include/target/target_core_base.h            |  7 +++
>   4 files changed, 64 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index ee85602213f7..7ab27580758a 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -892,6 +892,7 @@ static void target_fabric_release_wwn(struct config_item *item)
>   	struct target_fabric_configfs *tf = wwn->wwn_tf;
>   
>   	configfs_remove_default_groups(&wwn->fabric_stat_group);
> +	configfs_remove_default_groups(&wwn->param_group);
>   	tf->tf_ops->fabric_drop_wwn(wwn);
>   }
>   
> @@ -918,6 +919,49 @@ TF_CIT_SETUP(wwn_fabric_stats, NULL, NULL, NULL);
>   
>   /* End of tfc_wwn_fabric_stats_cit */
>   
> +static ssize_t
> +target_fabric_wwn_cmd_completion_affinity_show(struct config_item *item,
> +					       char *page)
> +{
> +	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
> +					  param_group);
> +	return sprintf(page, "%u\n", wwn->cmd_compl_affinity);
> +}
> +
> +static ssize_t
> +target_fabric_wwn_cmd_completion_affinity_store(struct config_item *item,
> +						const char *page, size_t count)
> +{
> +	struct se_wwn *wwn = container_of(to_config_group(item), struct se_wwn,
> +					  param_group);
> +	u8 compl_val;
> +
> +	if (kstrtou8(page, 0, &compl_val))
> +		return -EINVAL;
> +
> +	switch (compl_val) {
> +	case SE_COMPL_AFFINITY_CPUID:
> +	case SE_COMPL_AFFINITY_CURR_CPU:
> +		wwn->cmd_compl_affinity = compl_val;
> +		break;
> +	default:
> +		pr_err("Command completion value must be between %d and %d\n",
> +		       SE_COMPL_AFFINITY_CPUID, SE_COMPL_AFFINITY_CURR_CPU);
> +		return -EINVAL;
> +	}
> +
> +	wwn->cmd_compl_affinity = compl_val;
> +	return count;
> +}
> +CONFIGFS_ATTR(target_fabric_wwn_, cmd_completion_affinity);
> +
> +static struct configfs_attribute *target_fabric_wwn_param_attrs[] = {
> +	&target_fabric_wwn_attr_cmd_completion_affinity,
> +	NULL,
> +};
> +
> +TF_CIT_SETUP(wwn_param, NULL, NULL, target_fabric_wwn_param_attrs);
> +
>   /* Start of tfc_wwn_cit */
>   
>   static struct config_group *target_fabric_make_wwn(
> @@ -945,6 +989,10 @@ static struct config_group *target_fabric_make_wwn(
>   			&tf->tf_wwn_fabric_stats_cit);
>   	configfs_add_default_group(&wwn->fabric_stat_group, &wwn->wwn_group);
>   
> +	config_group_init_type_name(&wwn->param_group, "param",
> +			&tf->tf_wwn_param_cit);
> +	configfs_add_default_group(&wwn->param_group, &wwn->wwn_group);
> +
>   	if (tf->tf_ops->add_wwn_groups)
>   		tf->tf_ops->add_wwn_groups(wwn);
>   	return &wwn->wwn_group;
> @@ -974,6 +1022,7 @@ int target_fabric_setup_cits(struct target_fabric_configfs *tf)
>   	target_fabric_setup_discovery_cit(tf);
>   	target_fabric_setup_wwn_cit(tf);
>   	target_fabric_setup_wwn_fabric_stats_cit(tf);
> +	target_fabric_setup_wwn_param_cit(tf);
>   	target_fabric_setup_tpg_cit(tf);
>   	target_fabric_setup_tpg_base_cit(tf);
>   	target_fabric_setup_tpg_port_cit(tf);
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 56f841fd7f04..a343bcfa2180 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -34,6 +34,7 @@ struct target_fabric_configfs {
>   	struct config_item_type tf_discovery_cit;
>   	struct config_item_type	tf_wwn_cit;
>   	struct config_item_type tf_wwn_fabric_stats_cit;
> +	struct config_item_type tf_wwn_param_cit;
>   	struct config_item_type tf_tpg_cit;
>   	struct config_item_type tf_tpg_base_cit;
>   	struct config_item_type tf_tpg_lun_cit;
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 45bb5253461a..cf3d916dd612 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -857,7 +857,8 @@ static bool target_cmd_interrupted(struct se_cmd *cmd)
>   /* May be called from interrupt context so must not sleep. */
>   void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
>   {
> -	int success;
> +	struct se_wwn *wwn = cmd->se_sess->se_tpg->se_tpg_wwn;
> +	int success, cpu = WORK_CPU_UNBOUND;
>   	unsigned long flags;
>   
>   	if (target_cmd_interrupted(cmd))
> @@ -884,7 +885,11 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
>   
>   	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
>   		  target_complete_failure_work);
> -	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
> +
> +	if (wwn->cmd_compl_affinity == SE_COMPL_AFFINITY_CPUID)
> +		cpu = cmd->cpuid;
> +
> +	queue_work_on(cpu, target_completion_wq, &cmd->work);
>   }
>   EXPORT_SYMBOL(target_complete_cmd);
>   
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index b8e0a3250bd0..4ed385537301 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -943,11 +943,18 @@ static inline struct se_portal_group *param_to_tpg(struct config_item *item)
>   			tpg_param_group);
>   }
>   
> +enum {
> +	SE_COMPL_AFFINITY_CPUID,	/* Use se_cmd's cpuid for completion */
> +	SE_COMPL_AFFINITY_CURR_CPU,	/* Complete on current CPU */
> +};
> +
>   struct se_wwn {
>   	struct target_fabric_configfs *wwn_tf;
>   	void			*priv;
>   	struct config_group	wwn_group;
>   	struct config_group	fabric_stat_group;
> +	struct config_group	param_group;
> +	u8			cmd_compl_affinity;
>   };
>   
>   static inline void atomic_inc_mb(atomic_t *v)
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
