Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22078C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D168B601FE
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbhBLTRh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:17:37 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:53890 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhBLTR0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:17:26 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ8upG181308;
        Fri, 12 Feb 2021 19:16:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4prx2emN4AXSuUYSn+loYaOdC2fKMQy8OFzkrj7Vico=;
 b=mcVdQrOennrM5yjeYSly8tV8TbC35jD4p6a/OWPXlAnkzs2OE/llSBLXNdLAMBhUgXqQ
 +M+O78cisVVo4BeK2tL1Nf1q7u4nMY0dxJSKGdcS5fYLgbdTjf6okPwFdk1/c1HPEtIp
 lEkShLPJJObdqCLobD9JdIMlLBExXcVicDe7KCPfO9YeFPgUGrDI9gH7DzRaKWhluKMR
 oejEU8ozU7c/bRuzcgCRB0p+MYiQcL+18p61CPXptTaBE67nm7sRb1Ee6yTjTbs5lk2y
 BmL72LpeD/YhSRlDTVaocDGRwEGOraAxV82BD/FzyqzNjIdtsQUyq4t2XNZiitIo4U0F xw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36mv9dxhhf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:16:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJA8HB156173;
        Fri, 12 Feb 2021 19:16:37 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2046.outbound.protection.outlook.com [104.47.74.46])
        by aserp3030.oracle.com with ESMTP id 36j4ptbkxk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:16:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aSzDPDmMRA3U55+zkBX+NT4vkTrEa/wv121dN38JQEL38Y/w4D14E/u0FYmpmfbHbi3FCGL5eVl+dYBqPdmgCdaSR99dy2diQE+3X72blMHds3X396Gm0QJwkg1O3aokgimpdmb6XqRhOJteJTkSk4BH5JZO0BNCoVJVqwDW8FnmwFQ2cZx3RBuPqh4tVsq2GiE0F7eG8Lq9DznRo71dLX+xQpenbH2UGQorDVSNKfqfoLMzk0iy5QYYne7bvffcvbPTzurQpeR2kCN5Z4LYNl9q+jrlwpLoQCaJzTsxnB7+b4fUtIgrgPWhwkEqYNVUcIS5vS+HlmsxrQ1Ks/MadA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4prx2emN4AXSuUYSn+loYaOdC2fKMQy8OFzkrj7Vico=;
 b=LF5IzsDzXjvAdQsDxPyL9IqMSnAJYjKmy9OYa9h/dsB5fHnqV17ZWfWPjRTXS7waFgpIqm2ub2+e7Su88c6biJsJpYJ/LH9raB0cDnyhM/RwXF46fS+uk9UZYINTLMwZEf76WXiLUu4i1WwTH9c7N1LvhSAKya6ljZvWZLjpvfLVNmkX0qP2sN0S3zP2LjjZDg2wohk7fpJi9jcZ2GSIwE1x1GTz4i9WGGpp2UEB6zHx7qxtMZyHw7IMywEbq8NWPWIyqux8mtgheBKv/t2FpH8sJB2p5fHZ78NBeJVUl7+6Yi6zrD9XYU2k4pasyXJb9xbJGaoUafNytRdqbw0UUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4prx2emN4AXSuUYSn+loYaOdC2fKMQy8OFzkrj7Vico=;
 b=T1gRLOfbBeiWqJnBSqx+WKhRKfQmzuwEvQKvCJGIdiBgprlJYungcoHsQAa381+gMUhncYQF/AGUYH/gH823pkbldHFWE46tJOcHRuuxkURmPfSZ+DBsdl7N2a7UsflryL6/PFF7/KTZ8twrjLeXX6uuCZ/vuQZzrh2QTz+cCl0=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4538.namprd10.prod.outlook.com (2603:10b6:806:115::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 19:16:35 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 19:16:35 +0000
Subject: Re: [PATCH 07/25] qla2xxx: Convert to new submission API
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-8-michael.christie@oracle.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <83988138-c464-5d2b-3ab8-0e7954f06152@oracle.com>
Date:   Fri, 12 Feb 2021 13:16:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210212072642.17520-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN7PR04CA0095.namprd04.prod.outlook.com
 (2603:10b6:806:122::10) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.20] (70.114.128.235) by SN7PR04CA0095.namprd04.prod.outlook.com (2603:10b6:806:122::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.28 via Frontend Transport; Fri, 12 Feb 2021 19:16:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d041274e-a9a9-4786-b984-08d8cf8ab6b9
X-MS-TrafficTypeDiagnostic: SA2PR10MB4538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4538F4D1511107C4F0E5F1E8E68B9@SA2PR10MB4538.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:873;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Db4P63DoXvfBoMdpr3Xlu2CO4U57hvJELayj+C4DA6H5B7SF4nKDkGesBUnwgu2IATPZhsqxc7zjZNfDnGBLn3Tnc6Ot02bSp2BaJkWI5cofoC7rhCWSPqYrZiSYvDyMzXyfOE6KrDNjkPtKvS/3JBFCeW3zts+xFXT5uJ8+/6lHGKXCOlBkUj8V4Mva/JbSgvhlxuY/GXAuqNY8xIb7WI55y8DBsPZ1JjZFJVA9/eFU2TPqUCR7LVX38r9CWGmF5Yn+TpJuIVkjwTiYqllqVy6DnHsLcVpxJ5GxJxc+mva/XYEu7HMQE5C3fc8F/C0U1S1P3pS9yhicrBoW0ykJHNMaB1MMh13i9YlLYVnEJC+bXT8m5b0DV2GFJbCv76IE5fQ3IxB4lKyeRmfOZGnw54yZdWI1MECZnpO/uIOOC9IR3gbMQrTVJIXWrj/x/FmG1NOjGS2oHvN8uL8EJmeW5M+rK8ZiSW/zb4oqGfxXwms14Zs08C2d67pxrnQQaj1uF7DSFm4g2gGmNpBz343ABZScN7NTJHB2v/GikFS70IS+YzrqaKiwwB/FVUOVIyeAA0bPWoPagLMMQfQkfPTVp37INdU+YjiPC6X8nUi/Q+k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(39860400002)(136003)(376002)(366004)(36916002)(26005)(86362001)(478600001)(36756003)(5660300002)(83380400001)(2616005)(956004)(6486002)(316002)(66946007)(16526019)(186003)(8936002)(66556008)(31696002)(31686004)(53546011)(4326008)(8676002)(2906002)(66476007)(44832011)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MEdLbDBCSFdiai9xU3FPakh1VXY5ZXdhMWYwbVoxMzhvd3FzYWxrTXZqdG4y?=
 =?utf-8?B?ZjNjUGx1TUh4UlFCbmhaZml2QkhmN3JUcW4ydjNVTklYWFZZTUticHVPcmNs?=
 =?utf-8?B?djRRU01EZUVRaHIzWTBkSExqQ2JmNFNlSGF5QWV5c2Q1eTBHTTR6RFdDK1Yr?=
 =?utf-8?B?VEczNTJWbHNkTEpMRjBTY3NpU1MwSXRRcDNsVmhwZXg4UmlycWk1UVFTbjVR?=
 =?utf-8?B?Ny9KbytXNldDaWloa1czdEpEWlQzT2E5Y2xZL1ZTVy90Y1JjQlRTUEVCaGRy?=
 =?utf-8?B?WFgveGdpeEwyR05YY3lMN2x1RExGdit4VDEzM0ZtNFNkbmw5L3B1aDJFODdr?=
 =?utf-8?B?TFFnNXg4ZHMxMUVCMFkvU3QxaTRZbTZqa2V3LzFrclI3U1YzSW96V1ZKYStZ?=
 =?utf-8?B?TUIwQjFBZHhTbk1mUzZpUXFkOEtObnFZSjJHN2I4SGxrMHFOM2xxbjBDdU0y?=
 =?utf-8?B?ODB4dlhpRkRYbUZCV1RWSCtLZGoyVFRSOE1rOGJUM3BUYVY0WDBDeitadEd0?=
 =?utf-8?B?SlZKZmQ0YjJRRGdmcmVlclladFNLVnlPa3lYL3JkNUJiQWtXeEtRTXlKb1ds?=
 =?utf-8?B?YUpJOE8rK3d0MDBYQ0R0T21mMW1EUVo1cUUvWVpNb21mSVdRa2NpK2VGMFkz?=
 =?utf-8?B?aWhsUTNCRFh2TnRBUWpMcUoxekJGS0tOa243NGhFMzF3VHVQVERaTFlUQ2dT?=
 =?utf-8?B?RGFXcXBBM2lVUDkrdnZnYWhpQ0crQUpneFpwZDdibnp1a0haRnFlRnZ5Q0U0?=
 =?utf-8?B?dDM5MlZ6bUkycXJkdUgydTBFRkg0VWNYanhLdVkwM202ZTE4WjFxTzY2YUNC?=
 =?utf-8?B?U254NHVTZEpGTUxQNW1kY01VRndwenY1dmk1TEYzbEFVQXBBcElZN3hvNnZC?=
 =?utf-8?B?REpkcyszWWJ6K3Vnb3dOUTl2WUwwZG1TRE02NDI2ZDQ2bnU0MEYzZ1NoZTRp?=
 =?utf-8?B?ZDBQSExVWnFtQzg5REZROXJJTEdHZHFocTIzRFlZVS9sNHBldG8xY2d1ZDJR?=
 =?utf-8?B?emdycStkVk92VFdKWXk5RjVscHp5eTBjYmZvUGcvVko1YkhGbUtsSU5sL1I0?=
 =?utf-8?B?a29vWTgrQ2lHREpnQzZKaVBSR2RmMTR3WFZjT1pGUTMrNDI4NDNxcisrWmNE?=
 =?utf-8?B?VmsxekpJaGFrSEw1UFpvSUM4R3ZOWDllQlR5MXNNU0pGYVFvTGltZGw0RUNk?=
 =?utf-8?B?VHhwQTNXOHlMWENQYjhkZ0Q1RWRuTmFrSEZVYndpcjZHYytPSzRBdEpLZzE2?=
 =?utf-8?B?WHYrYlJCaUN2TlVpZFJpSVM3V1F6aFRMWkU3aEZza0N4YzZuc3dROUphejJs?=
 =?utf-8?B?Z25INFZ5cTlNZTVoT0ZvUlU1RzViYWhNYXdhVllQdWg5M1g5VVo5VDJGbFRZ?=
 =?utf-8?B?am1aRnVMci83QjlubDNvNDVXd0l4MWc2Z0tsbFh0UFc3a3poM29IY25oMDlH?=
 =?utf-8?B?Q25KdlVuekVFTUxwejdkWHM5TnJva29na1BFazVnb2FhTEtlZmZCdkZ3YUF3?=
 =?utf-8?B?QzNqOWJHRWpCZkdNQklLMlFoSTJVcllpUm4wTTRiQVJ5NUV4RnpXb0p5WmhK?=
 =?utf-8?B?bCt1UmhMZk5xNFZQQXU0ZWxGOVlQaGpuN29SVUVrVE40MUFjRERHazl1UXVZ?=
 =?utf-8?B?ckFCMXQwbjg4NmR3ZHkzN0F0SkdiVlQ2ZDRGNGlJN2xlbE5KeGN1TUFWQjIv?=
 =?utf-8?B?endrbDB1d0JTdXVJYzIxUzYrKzRXdU5zT3JDdnY0MGphRU9LbXB1SDBGc2ZM?=
 =?utf-8?Q?UIQnI22k2AZ0YKrwco3fSz3kThIx5CPPNxhczLh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d041274e-a9a9-4786-b984-08d8cf8ab6b9
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:16:35.2425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fYeHABwWuLwJNyJ6Rlzd5GafqEQxdhuenweIDFYJHxD0pGYYRxHKjtxv9az0TUsZd2AwspSGoDsUc58Mghil9R5lUTuolrQzngNdOqmaWuY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4538
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> target_submit_cmd is now only for simple drivers that do their
> own sync during shutdown and do not use target_stop_session.
> 
> tcm_qla2xxx uses target_stop_session to sync session shutdown with lio
> core, so we use target_init_cmd/target_submit_prep/target_submit, because
> target_init_cmd will detect the target_stop_session call and return
> an error.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 16 ++++++++++++----
>   1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index b55fc768a2a7..56394d901791 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -451,7 +451,7 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>   	struct se_portal_group *se_tpg;
>   	struct tcm_qla2xxx_tpg *tpg;
>   #endif
> -	int target_flags = TARGET_SCF_ACK_KREF;
> +	int rc, target_flags = TARGET_SCF_ACK_KREF;
>   	unsigned long flags;
>   
>   	if (bidi)
> @@ -486,9 +486,17 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>   	list_add_tail(&cmd->sess_cmd_list, &sess->sess_cmd_list);
>   	spin_unlock_irqrestore(&sess->sess_cmd_lock, flags);
>   
> -	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
> -				 cmd->unpacked_lun, data_length, fcp_task_attr,
> -				 data_dir, target_flags);
> +	rc = target_init_cmd(se_cmd, se_sess, &cmd->sense_buffer[0],
> +			     cmd->unpacked_lun, data_length, fcp_task_attr,
> +			     data_dir, target_flags);
> +	if (rc)
> +		return rc;
> +
> +	if (target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0))
> +		return 0;
> +
> +	target_submit(se_cmd);
> +	return 0;
>   }
>   
>   static void tcm_qla2xxx_handle_data_work(struct work_struct *work)
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
