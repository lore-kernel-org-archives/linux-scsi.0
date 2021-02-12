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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B393C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2271264E99
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhBLTJg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:09:36 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:44210 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbhBLTJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:09:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ4oQD178803;
        Fri, 12 Feb 2021 19:08:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dkNa1Qknx3FFY4hYwQ3v3XPuhiZZN/GMrChezNxUiNw=;
 b=rRkyOfCryJAF4eV61joCt5vZoUj4wj+uA5cMkSqFV+dJ+TeAQfBSmHGo+XUbwhHxUspQ
 xcQ7UMMtuQu2zOo8enJQ7qrnSr8YA/YleHU8fGSODbYxS+nKevtLpm18xqH4Kt5TQbHi
 mmwb0ckfEroYpHuB+XSaihfM7QuMLOKQOCmN9Nfg1/l5QZzyACWB/qWcx4l1Ysv2BFGk
 dFmVxgqViN1dFr/1sHqNClj2uKy3aMFuEPIG6XpwNhm0muYnPva3NRs6pptBf7lDyP3z
 uSBPWzdWhN47CSYCUIwcNkMXuC5v0InVNnmydqsIhOwArUmi/58Pm93h3aMlZIvbudtp 4A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 36mv9dxgvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:08:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJ67lj145292;
        Fri, 12 Feb 2021 19:08:22 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by aserp3030.oracle.com with ESMTP id 36j4ptbcxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:08:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cCzP5wP1N6T2KMrfynJSmzJy+/ph4ZGv6ZQAxNI1it0ySuT2silzASn8+CoQ8XkcmggAXKHqUGWZMruUlySHWpD0vl4RDZXfLxY3WyZdOIk7ktIy/dCP0zAa7iVBRSj1aKE7Ke5GqRZ2IKIH1M3h8RfkMkFAAYHiSruwpma1ddPasnsfttIfU1ccW3+bgTuCu+5cyI3JTVNQdcBOea+EMG8zl+PKzR32Np9AXerweX9GpVK+Mbo+LbsLX6t28afnd5L6/FxeIGQcfDfNm74IJP4BVc7GRPtwc0m7BLEtEtZPCWcUBuU5M7NNrjVmKBLq2dNFbRZmqpoSg+naQAGp9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkNa1Qknx3FFY4hYwQ3v3XPuhiZZN/GMrChezNxUiNw=;
 b=l4B8pHSMZ4VQe5zSMCZNnmvLMIIhC/v8H5EjD4SBAcYmiyME4HOakYmiiBSynIOj4uGiYr1dtHyIN+w5Hf9rQwq90ibYohArice0pUHtJ1PGib8d7/bGS8HVXSrMklp9jHJukVQnJ09FUQGMK/AgACvf82XD4sXkPoGDNWJqPvTEjhqQdVXLf2fg066AMHYNULUgxdjW3r/XxFFS+/cazAirrH+SfM91AMQ+Uo3iCJp52DwiTGoEXBgqcofjn8F3kvMC5P+JBgWjgB+G08wlZ2+uZoD3klGog42rUMc4691uRGZIlW/CAIG28JPCXcIJUIU/cL7ed3NDPDGV+3JgyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dkNa1Qknx3FFY4hYwQ3v3XPuhiZZN/GMrChezNxUiNw=;
 b=LsxNCu+sB+FW950cfDbXzLfDKznZ7vIbOymy2kv5YECkf/UYgFwsi0Q7cKOi6rPusTx7e+SbaBAo5ALRfo5ml7EQyj0Lgss7lL769hzdJ4FGjeEMYgQd1cRprmXbf70eRmfkimw1giBaGva6pG6AnZRxnoNc4LhRrcGq99iOXC4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4795.namprd10.prod.outlook.com (2603:10b6:806:11d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27; Fri, 12 Feb
 2021 19:08:20 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 19:08:20 +0000
Subject: Re: [PATCH 03/25] target: rename transport_init_se_cmd
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-4-michael.christie@oracle.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <9720c52d-eca5-883f-1378-f2447a652fa1@oracle.com>
Date:   Fri, 12 Feb 2021 13:08:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210212072642.17520-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.20] (70.114.128.235) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25 via Frontend Transport; Fri, 12 Feb 2021 19:08:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 553f07c1-cc78-437e-717f-08d8cf898ffb
X-MS-TrafficTypeDiagnostic: SA2PR10MB4795:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB4795DDFF7ECD5877D0903C34E68B9@SA2PR10MB4795.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdWBkGFXZyqCJYK/+Xh9Hdn8QMsS6t63psFn8efxcgn8Ue5hIOZmZlnGO+ifYqi/KpIZlC/yb2CMGk2hMsm1M6SCkFZ3qhJEEaQmf0ufVKg0OiOCD5NasNCBweR5M694a+1QYpIOb69SXwWsF40dz/d+Hl2rI4EprpfgcI3jVVtHOWbgv5UMOh6rXuTC2Buw0GKPFoplOpg0oqjb7o12y9iZM42Hmjk5xSSdtFaB/oR0V2D0PEJChM/wApSjgH7ElaHdq5Qk7zzIMPD5rqEDMQ0WKvL3Ji6aNiNG+Jf1KvIKOMNp3Z0UADsyg7tJ44gyf6+mjifX8gSwDyWbJQWZMCTLuB894RG8gWtg0koNVYDlj5Ftg6XyBGK+IpsObiBNrfbvxlESs6gVfA1njVAPgwU2MABNqkHU4D1Yi4I+9UY0s3IiouBgrq7YaoRcZZ1/D7ClPSo8VaaSSOto6V1CMQADRqC1bHdg6WPuz4m4W6nq+ZQpv/qaEorui2OEBk6R8YpZDY/ipLVOJ5plIBjbrb/S182x7KavsV6GfeaGmY1DRZFYp+TlGLGpdBMMxZ9WRJdkpi6UtsnxjllL5MqgI7R2TLvLyn2FFAwsGPAif9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(39860400002)(136003)(396003)(366004)(44832011)(2906002)(66556008)(8676002)(53546011)(66476007)(83380400001)(16526019)(66946007)(36916002)(956004)(2616005)(478600001)(26005)(5660300002)(86362001)(186003)(31686004)(6486002)(16576012)(8936002)(31696002)(36756003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eFBWTU1QS0JJUWNIMDNjSHhUWUtoQnZiQW1GOUFNTmFsbkdQc2JZQU4vQXhJ?=
 =?utf-8?B?ZzhtS1lxWUQ3RHNSMExRN0RZckd6WHVRbG9JdVRYWXBsb2dCaldmenlIbHBa?=
 =?utf-8?B?eitkeUNpck1tL2k2ZFIrbTE2REJYOWVVdkxiUXVlNEllclB2VTE2WHRTUWZN?=
 =?utf-8?B?RWlTUEkyUExULzl0WjdDK3NkMDFLNjlrSVVETjVNNWd2MGdZZ0dnQmNJYkhF?=
 =?utf-8?B?cVROWlk2Um5jU0xWVW80Wlk5d3M0R3JDU1dST2pMY3Q1bTZWc1l3d3pTQjNl?=
 =?utf-8?B?NENhQmVsd20yNWZkRFkrRE9jYmVZdU5GYXlNbmZ6RkpmeDJMc0FmRFlUdTVC?=
 =?utf-8?B?LzdrL3NtSXlXTHNmNHJZNFQrcklVRHgwS1R3Zlg1MWx4UzRlY3NrNnlnM1Bj?=
 =?utf-8?B?Sk1icHFGV0lPaFU1YUxQNHU3WGdpWHpubWc2UFFMejZOY2hoQWJKcm1EZHhD?=
 =?utf-8?B?eDRrdWo1VFU3MDhLZ1V5MTBTZFlVbE1ORW9US05paEg5d3BIQ0hTTHUxcjVa?=
 =?utf-8?B?dVZROER1S3hZRnlWQnRLb2NkdmhPZit0TGYzMVFKTFNxNVpmRkhzaHQ0V3Yx?=
 =?utf-8?B?Qm55QzlBN1ByV05rcDFvQTA2Q3hnQU8zOE1WUkgzdG5rWDVYNjRKMjJ4TGhD?=
 =?utf-8?B?VGlMU2kyeFZLbzJPTjU2aEUyNXI2cDA3S2RYbEl4V0xsVmlNVDBZSkxSL3Rq?=
 =?utf-8?B?Y0pVVklaOERFUFFNYms0ZlVwUlhXYlBWU3NxdmZjbmw0V1lsWnBoREdHUjhP?=
 =?utf-8?B?ekN3bTQ1NEVKUzBoUktxakR1eGZ5Znp4RS9GclFWV3JvYkU5K1pvTFBqRUll?=
 =?utf-8?B?RktpVWhrZk5FZzdPRUFYL01JYkxrQVd6RnlJVmJvNjhLaHdCWW5lNHUrd2ps?=
 =?utf-8?B?RWQreUpNd1pZQmNmdFdPd3dYaUNsQ1ExamcxV0JPTUVkMDBPWWt2VXIvNi9G?=
 =?utf-8?B?bXdkYVF6bi9GWTh0MUhHWFhOM2FzamNaTzB0WGhVenhrYjVMRWdkK2hlUi9X?=
 =?utf-8?B?OFJnKzFkT1V4Q0hkc0d5VmxWTEQyUnZneGJoZ0MwbHZHLzRnTFp6NXcxQkl5?=
 =?utf-8?B?dXdaZkx4Rnp4UzI4MkxtZEw1USszcFZTU3EweDVmdjUwbjBDY3VESXVidVds?=
 =?utf-8?B?ai9mMUpRUWU0a0lXVDBkenJxcmxJdUljT2tPNGJhTFBTVUJ2dSs3eTh0cVFv?=
 =?utf-8?B?SDhHdzJqS2ZEUlpGUVBpVkF0RGlEZ05KUktMMDRORnpmR215ckZ4MnFjYVJG?=
 =?utf-8?B?QjJGK2lOU3BySkczUG5SeVZvLzVzcjJvTFlOTVZWbjZoZ09EZ1UxdUgra0do?=
 =?utf-8?B?YjY0dFkrR2t0VGxUZ3lxc1pibllBdFZnU0kwMUhPNDNTbFhUOVQvNGREanFL?=
 =?utf-8?B?OWJaL3E1R1FPTjV6S1hUcjlJa2dHZ20zUnd3bkNtZVZ0ckNLanh2aFI4NzNN?=
 =?utf-8?B?d09SbElyektlUCtUSDUrb1Z3SUhUekd2SVQySkpvUHl5czBIWWFGUlhRaGFy?=
 =?utf-8?B?R202V2Y3QndEV284cFM1WEwrem5CQmxpRndDWFFXdjUzVzhzSTgrZ0FKV2xV?=
 =?utf-8?B?UVBNRXpLVlg1cU80bTlUU3pjcGh5WXJqelJqakpscmc1Wm5Da3djWTdhWDFD?=
 =?utf-8?B?QlI0WXBxdUFnZGQ3Mzk2QlhWRDhqQlpSempENENWSE9Kb1FRK2UvMlRhSHBL?=
 =?utf-8?B?VjB6K3ljZkZzWUVmQnpnV2dUdmU1aE5EV2NvaEp1WFdYOERXMHBsNnU3Qzd6?=
 =?utf-8?Q?20EVSGDfpO1AcKQ4oqLGR5F9sLA/ce781I/HU8i?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 553f07c1-cc78-437e-717f-08d8cf898ffb
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:08:20.8273
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xNycCiz7IxE3pL/txnwCBCQu2GNfZSdPhG2okeA/Low6cMk1xZ5R7LvmS8uc5ZcOsQdnKij8TAhhpxqCsIipZHzHEK0dmcDBzG2/3JgGDnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4795
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120140
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxlogscore=999
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120140
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> Rename transport_init_se_cmd to __target_init_cmd to reflect that
> it's more of an internal function that drivers should normally not
> use (usb seems to use it wrong and iscsi is that weird guy), and
> because we are going to add a new init function in the next patches.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/target/iscsi/iscsi_target.c    | 16 ++++++++--------
>   drivers/target/target_core_transport.c | 16 ++++++++--------
>   drivers/target/target_core_xcopy.c     |  8 ++++----
>   drivers/usb/gadget/function/f_tcm.c    | 20 ++++++++++----------
>   include/target/target_core_fabric.h    |  2 +-
>   5 files changed, 31 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 518fac4864cf..f2107705f2ea 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1154,10 +1154,10 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>   	/*
>   	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
>   	 */
> -	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
> -			conn->sess->se_sess, be32_to_cpu(hdr->data_length),
> -			cmd->data_direction, sam_task_attr,
> -			cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
> +	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
> +			 conn->sess->se_sess, be32_to_cpu(hdr->data_length),
> +			 cmd->data_direction, sam_task_attr,
> +			 cmd->sense_buffer + 2, scsilun_to_int(&hdr->lun));
>   
>   	pr_debug("Got SCSI Command, ITT: 0x%08x, CmdSN: 0x%08x,"
>   		" ExpXferLen: %u, Length: %u, CID: %hu\n", hdr->itt,
> @@ -2013,10 +2013,10 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>   					     buf);
>   	}
>   
> -	transport_init_se_cmd(&cmd->se_cmd, &iscsi_ops,
> -			      conn->sess->se_sess, 0, DMA_NONE,
> -			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
> -			      scsilun_to_int(&hdr->lun));
> +	__target_init_cmd(&cmd->se_cmd, &iscsi_ops,
> +			  conn->sess->se_sess, 0, DMA_NONE,
> +			  TCM_SIMPLE_TAG, cmd->sense_buffer + 2,
> +			  scsilun_to_int(&hdr->lun));
>   
>   	target_get_sess_cmd(&cmd->se_cmd, true);
>   
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index b5427e26187b..013f4a5e8972 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1297,7 +1297,7 @@ target_check_max_data_sg_nents(struct se_cmd *cmd, struct se_device *dev,
>    * Compare the data buffer size from the CDB with the data buffer limit from the transport
>    * header. Set @cmd->residual_count and SCF_OVERFLOW_BIT or SCF_UNDERFLOW_BIT if necessary.
>    *
> - * Note: target drivers set @cmd->data_length by calling transport_init_se_cmd().
> + * Note: target drivers set @cmd->data_length by calling __target_init_cmd().
>    *
>    * Return: TCM_NO_SENSE
>    */
> @@ -1369,7 +1369,7 @@ target_cmd_size_check(struct se_cmd *cmd, unsigned int size)
>    *
>    * Preserves the value of @cmd->tag.
>    */
> -void transport_init_se_cmd(
> +void __target_init_cmd(
>   	struct se_cmd *cmd,
>   	const struct target_core_fabric_ops *tfo,
>   	struct se_session *se_sess,
> @@ -1403,7 +1403,7 @@ void transport_init_se_cmd(
>   
>   	cmd->state_active = false;
>   }
> -EXPORT_SYMBOL(transport_init_se_cmd);
> +EXPORT_SYMBOL(__target_init_cmd);
>   
>   static sense_reason_t
>   transport_check_alloc_task_attr(struct se_cmd *cmd)
> @@ -1623,9 +1623,9 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>   	 * exceptions are handled by sending exception status via
>   	 * target_core_fabric_ops->queue_status() callback
>   	 */
> -	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> -				data_length, data_dir, task_attr, sense,
> -				unpacked_lun);
> +	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> +			  data_length, data_dir, task_attr, sense,
> +			  unpacked_lun);
>   
>   	if (flags & TARGET_SCF_UNKNOWN_SIZE)
>   		se_cmd->unknown_data_length = 1;
> @@ -1797,8 +1797,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
>   	se_tpg = se_sess->se_tpg;
>   	BUG_ON(!se_tpg);
>   
> -	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> -			      0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
> +	__target_init_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> +			  0, DMA_NONE, TCM_SIMPLE_TAG, sense, unpacked_lun);
>   	/*
>   	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
>   	 * allocation failure.
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index 66d6f1d06f21..e86cc6135587 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -615,8 +615,8 @@ static int target_xcopy_read_source(
>   	pr_debug("XCOPY: Built READ_16: LBA: %llu Sectors: %u Length: %u\n",
>   		(unsigned long long)src_lba, src_sectors, length);
>   
> -	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
> -			      DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
> +	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
> +			  DMA_FROM_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
>   
>   	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
>   				remote_port);
> @@ -660,8 +660,8 @@ static int target_xcopy_write_destination(
>   	pr_debug("XCOPY: Built WRITE_16: LBA: %llu Sectors: %u Length: %u\n",
>   		(unsigned long long)dst_lba, dst_sectors, length);
>   
> -	transport_init_se_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
> -			      DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
> +	__target_init_cmd(se_cmd, &xcopy_pt_tfo, &xcopy_pt_sess, length,
> +			  DMA_TO_DEVICE, 0, &xpt_cmd.sense_buffer[0], 0);
>   
>   	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, dst_dev, &cdb[0],
>   				remote_port);
> diff --git a/drivers/usb/gadget/function/f_tcm.c b/drivers/usb/gadget/function/f_tcm.c
> index 410fa89eae8f..dcce6e2605f5 100644
> --- a/drivers/usb/gadget/function/f_tcm.c
> +++ b/drivers/usb/gadget/function/f_tcm.c
> @@ -1050,11 +1050,11 @@ static void usbg_cmd_work(struct work_struct *work)
>   	tv_nexus = tpg->tpg_nexus;
>   	dir = get_cmd_dir(cmd->cmd_buf);
>   	if (dir < 0) {
> -		transport_init_se_cmd(se_cmd,
> -				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
> -				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
> -				cmd->prio_attr, cmd->sense_iu.sense,
> -				cmd->unpacked_lun);
> +		__target_init_cmd(se_cmd,
> +				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
> +				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
> +				  cmd->prio_attr, cmd->sense_iu.sense,
> +				  cmd->unpacked_lun);
>   		goto out;
>   	}
>   
> @@ -1181,11 +1181,11 @@ static void bot_cmd_work(struct work_struct *work)
>   	tv_nexus = tpg->tpg_nexus;
>   	dir = get_cmd_dir(cmd->cmd_buf);
>   	if (dir < 0) {
> -		transport_init_se_cmd(se_cmd,
> -				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
> -				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
> -				cmd->prio_attr, cmd->sense_iu.sense,
> -				cmd->unpacked_lun);
> +		__target_init_cmd(se_cmd,
> +				  tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
> +				  tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
> +				  cmd->prio_attr, cmd->sense_iu.sense,
> +				  cmd->unpacked_lun);
>   		goto out;
>   	}
>   
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index d60a3eb7517a..4975c4d2a933 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -148,7 +148,7 @@ void	transport_deregister_session_configfs(struct se_session *);
>   void	transport_deregister_session(struct se_session *);
>   
>   
> -void	transport_init_se_cmd(struct se_cmd *,
> +void	__target_init_cmd(struct se_cmd *,
>   		const struct target_core_fabric_ops *,
>   		struct se_session *, u32, int, int, unsigned char *, u64);
>   sense_reason_t transport_lookup_cmd_lun(struct se_cmd *);
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
