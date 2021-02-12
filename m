Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D13C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3A3664DF0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Feb 2021 19:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhBLTSX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Feb 2021 14:18:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:33344 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231725AbhBLTST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Feb 2021 14:18:19 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJAGbE077543;
        Fri, 12 Feb 2021 19:17:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=C1dYFtt0TTQJS8o1HH03OeruC0aNSZJablSocXMWNlU=;
 b=JUagPh8M+diGQga2nA4hPhws/X/kJ++KJffisga/RAORaM+dD93TjflzJOuChuVXkfod
 X0mlvk/zo0KJcCLiFglsrofp5iQ3aqzC69NGF+wqGKqGOcaBFPdn4Kr7+GNJidMbHVcC
 sBDfzQreQh/g6wb2aSkKrIqLNmXAH8oV9EylR3EawiNU/tJmkmLbwcgbr5KpVwA9dXbG
 p0wz3c+WorAnqahsu6kUGVL8U5pI2V5cQQGlful5DvLZUZM7W7Fod52Yo8CLrpXQaIis
 qujEi41opT+Gi3hlTC0TItEy3O/iW1JujoWvGmV1n4x+c+BWLVYScz8lfUzSs/XSaknK 5g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 36hgmavfd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:17:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11CJA78D156123;
        Fri, 12 Feb 2021 19:17:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3030.oracle.com with ESMTP id 36j4ptbmn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Feb 2021 19:17:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxAll89iJx6JO/QfwCJoGAhlr4E5vas3kkzFnKMRTJyvY7Zd67V4LCtj3o/yhCXc5XNfJok0RurdPT8Rpwt6FhilH3w65qtDJH1SHXXlzej4NGjR9ZQsFFmSbAkZ7wY0OniQLcC9/D03W7twVFk8npWiXHC34re9nZJGTJp1Vper0WoOiAwkl2s3ekYi3iMzaw+20Eo4GAuwt8bnhw4lgk+gDf8h7Kl1gNk+IYksbXHq9Tg2RTpXdsM7w9aZsFXF82QeESqSaFdCPrcp9YYGvLDG6g2e18+FucagP4sAvxidG4przNA8BirzVA/UOVPhUtBFvtpSc2Yx9kjvg2oinA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1dYFtt0TTQJS8o1HH03OeruC0aNSZJablSocXMWNlU=;
 b=ExpD2ibuV6R8YlBrOtBa4iXfHvqML1lLguVS2rsG7nChj88SpmFooo8YfLl32D92ivqdZV2XGskGktRLfJQXIS/FYwfM3kPig5dUn3ar7zoBuVlRAavi7HqeX122el07/uvpzePI2YxuoK7pmda3q5wAnAgi1vuBqCON06YdtqTfQtHrry6LsNZd+s9GhLE5kTUKBh72A6+J7wqIt5/T5gNrPqC3m91jwstMTBi0H66+l464kewR539MDZCTtfVHOE32AXtZyZHLXwOno7NsutcVmWXrhUykLxkJTrctjCP1WTA6J5cH2AneA55Nm2QbnFcOO9XIg/7KJ2nL35Q28A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C1dYFtt0TTQJS8o1HH03OeruC0aNSZJablSocXMWNlU=;
 b=v9XF1R7AlwEELp99AhguKRdkHftL0/OAtAwWJDNfbKf+3WkCsev0QIAerBFAT3amuOIG8C5UJOPfPEhXFqlNnRrg/FdFZbbwtVGlEPNniJtVcCs4UfzJjoKWbdPWy/4599UkBQSn9s4/k0BO0QelNDN9YOQJw6HC7eYVk1KDmLk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2704.namprd10.prod.outlook.com (2603:10b6:805:49::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Fri, 12 Feb
 2021 19:17:26 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::793a:7eef:db3b:ad48%5]) with mapi id 15.20.3846.027; Fri, 12 Feb 2021
 19:17:26 +0000
Subject: Re: [PATCH 20/25] target: cleanup cmd flag bits
To:     Mike Christie <michael.christie@oracle.com>, mst@redhat.com,
        stefanha@redhat.com, Chaitanya.Kulkarni@wdc.com, hch@lst.de,
        loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210212072642.17520-1-michael.christie@oracle.com>
 <20210212072642.17520-21-michael.christie@oracle.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <677e4fe6-4dba-5cc2-7953-71fc89dd405c@oracle.com>
Date:   Fri, 12 Feb 2021 13:17:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
In-Reply-To: <20210212072642.17520-21-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN7PR04CA0103.namprd04.prod.outlook.com
 (2603:10b6:806:122::18) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.20] (70.114.128.235) by SN7PR04CA0103.namprd04.prod.outlook.com (2603:10b6:806:122::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.28 via Frontend Transport; Fri, 12 Feb 2021 19:17:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68d14ba9-7096-49e3-96da-08d8cf8ad540
X-MS-TrafficTypeDiagnostic: SN6PR10MB2704:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB2704CA93EAA7EF2A3CAD2C31E68B9@SN6PR10MB2704.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KomM917TnoySdWJ+7OwVfAT+XVlXahmH3mFiRx2BPLosyD8H0csAQ7V3kLPVfOUDSP0DcOD3ijwc/80ZUDSMxo+KGu4Vr2ZK63j7BKOtMRTlh8wVnyctcL6gj0BtdyRQnxoJujTKaP5FuhSX1rmPohEAU7xJgK2xiqk0zijZQQ6xpOVxa9BqOWiF5CAZiqhaU31yEbsyDpRceYu1on43cHQVYX00cX61eeJLv8d+sBq4Q1rtnBw2J+xAXb/1y6PaVnMert9Y91QCNmTB0P4RV6rm7vrnhlaDkd4P/hSPYrjWsIAmzhLTRJvGqu/jCV8XL4Bw+DG57aOXz8SFDeZl2YDrpvBWxpS734KMCsXveDHkFl7Y8bot0fQ9Au76UbM0kAy0dBH6wjagJsvCTvNpMfDwFwpeZkrVz3MCA9EfxyuY+GxsixpzrWqwOm2pYpF7lSLB1ddI5JQtDdc/Zsx61fkteJHUliAtFImHd0RCdG9EENp/1GUbvZBIhJRokzt4Lh0mAhaCtFCOCgMH2HgEQQv63n0UHqD0xCiPTMGGfTUp7oLWlRosXVe6bwoxotjuv3gJcNWJ6GMDN3dDI5dY4JmskDRO9hQIZwcXCiKoxNU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(346002)(39860400002)(396003)(26005)(8676002)(44832011)(316002)(186003)(6486002)(16526019)(8936002)(956004)(5660300002)(16576012)(2906002)(2616005)(53546011)(36756003)(31696002)(86362001)(31686004)(36916002)(66476007)(478600001)(66946007)(66556008)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cWxjeHNNREFRcC96SmRzTzhLYVFTMzIrV1luem11azZZMStLQUxKN0dNVG9M?=
 =?utf-8?B?VWJWeVluQm9wY0VjVlI4TFZRWU9RcXdRbkwrM2NidkZGWVFhMzNlL3VnTzhr?=
 =?utf-8?B?VUZMZjBiVEY0QkVZdGF3Y3liVmNoa1RQMnRIdWEvYTI1Nmd3RUhBcnBBNXdp?=
 =?utf-8?B?YmsrVkRtVXFINk56akJEY0FIYndQcllXeUVOT1lxdFFsUjQwWExQS1hlNExO?=
 =?utf-8?B?ekRydXVuNHlZeTdUcFQyeDd3NGhjaDB4OG1HMGREbFZPZWlTUitZTXRtbVR3?=
 =?utf-8?B?SkRJWE9iREtSYjNzWGlnN2tWaHlqa2QwVUxSOW5iVzNpT0Z5eWVhdU1GVis1?=
 =?utf-8?B?WHBDd05jQnhDUi8xaFRRTi9mMUpBRXdwSWdrdndxQjlnZGFYNWxhb2xYR0Rh?=
 =?utf-8?B?OWJUdE5iMkk1YXVvRTkrckRDbnFQZEhpclE3ZDVxSm9JZjdNalZiUXcySlVi?=
 =?utf-8?B?Z3JxUjlmcTBiaWhEV0dORDA2UG5TOS9IaENBRUE0dG1JdjI2aEFWdllmcEhx?=
 =?utf-8?B?QitURnNxemQxYXNiVHVrRElSV3RYS05zMmdRWi9iK0NaVFdWc2NHY09DOWxS?=
 =?utf-8?B?NzhvNjZaTzQ4eUx2V0lUMDZmeEovYS9XSE1zeWR0RXdhaXFJb1pEd1pxckhh?=
 =?utf-8?B?NGpBOFZTTThNajlnL2hEYWQrZE9zdzFSNUdDSitiaEtxbmhDWGFTSVJxdDNC?=
 =?utf-8?B?S0NyV0RFNWFkMzZIUTFYNHltd3dsSlB6WHhzNTh0TlhJUHhnbHVaL2YzVmQx?=
 =?utf-8?B?c0FKRis5RktuY2g0ZHlnc3p0QVFHNGR5WVp5WEJMY0Y4S05wdmhWT0RxRDha?=
 =?utf-8?B?WEUzekxXSnB1ZW1Pb0wwV1FCVjFaY0FELzU2aks2MGFwOW5zRGUwUXRwTlNL?=
 =?utf-8?B?TnpDTXU3TThTMzA5RmFCdWxaOWJLSC9qMnNBcVRmdlhQMklXTVduSTR1dU1i?=
 =?utf-8?B?OU5abmdMT3V1UTlOZjhkcmRCUXdDVmM4c0FXNHJiRGc5eHloSmVYUjRWNkQx?=
 =?utf-8?B?dTJTWVZlN0pGQ2hiMkdUb2w3djB3SXBaYk9vaE1HSDU3dGpuMVlKRlZSWmov?=
 =?utf-8?B?MEF1R2FMNzFna2U3Q3lhWTNLQngxNENwWnFrbGovSXdESkJjQ0YrZ3B0UHRN?=
 =?utf-8?B?VXh0TkxiVGdpNzF1WXJ4SUtOUXFOc25nakJBZ00yME4xZGZuZFpiOGYvakFk?=
 =?utf-8?B?Q01WbVhKeWVNZ1hodzJ3WmhhRzNSUlUyTVZTMk1ncjlxZDZIako2QjdJTTRp?=
 =?utf-8?B?Tlg5M1NJMThSV1Y4MTRoeTZJV3FicDlZMjBqZVhERnUxUis5WXB2cHQ3T0l6?=
 =?utf-8?B?V1p5cjY5eXdhUlJXZk43Q1BzMjdDbTRrQzNUWUNvT2JkQ2Q1eWFXUGFLaU5w?=
 =?utf-8?B?VE1NVzd5UDZKVTFwTFZnc1dFM0FhaHdnaUZDaEM1Rm9jRTNDSzdSTGVqazNZ?=
 =?utf-8?B?dTl6MVprUER1N3hZeDB1aDZUMTByK1dVQ1k2dTZsZThhd0pOd3ZpZURKWVN3?=
 =?utf-8?B?Q1U5OGJuTEp5YVZkMzA1Qm53Q0REalpUb0NjMWlTWklKdkwxbHJ0aVE0MWpW?=
 =?utf-8?B?aFhIcmdLUS9yMUFLQmF4R2JCb0t0VjJMQXFicVlTNXY0bEdKT1hDN0pldUxj?=
 =?utf-8?B?TXZ6V0VSbFVPWXBVNng3L0x1UW9xVjVUYnFXWWdKVzJvT09UeExpUkh1U0hz?=
 =?utf-8?B?SW9iNDNHVGtFTk9QWU9rUExGa0VNb2pnelMxaThGbDc1WTg3S2ZrVFE5b2Y4?=
 =?utf-8?Q?t1Tf6ybcgGlNNE3g1A7fWOM0cvkdEpGUxiVlHL8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68d14ba9-7096-49e3-96da-08d8cf8ad540
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2021 19:17:26.4021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sa/lPR+Wrbaad0oHWb2N9hHFe3R/hnNqApBYufnDoYwsn5hkAMZzgZNt/m/GRGD84/iaQt1/3UGquj+1JmtGumq42btajFvmXMLO+DsVwhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2704
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102120141
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9893 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 spamscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102120141
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/12/21 1:26 AM, Mike Christie wrote:
> We have a couple holes in the cmd flags definitions. This cleans
> up the definitions to fix that and make it easier to read.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/target/target_core_base.h | 38 +++++++++++++++----------------
>   1 file changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index 815de4c97230..5e6703ca102d 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -127,25 +127,25 @@ enum transport_state_table {
>   
>   /* Used for struct se_cmd->se_cmd_flags */
>   enum se_cmd_flags_table {
> -	SCF_SUPPORTED_SAM_OPCODE	= 0x00000001,
> -	SCF_TRANSPORT_TASK_SENSE	= 0x00000002,
> -	SCF_EMULATED_TASK_SENSE		= 0x00000004,
> -	SCF_SCSI_DATA_CDB		= 0x00000008,
> -	SCF_SCSI_TMR_CDB		= 0x00000010,
> -	SCF_FUA				= 0x00000080,
> -	SCF_SE_LUN_CMD			= 0x00000100,
> -	SCF_BIDI			= 0x00000400,
> -	SCF_SENT_CHECK_CONDITION	= 0x00000800,
> -	SCF_OVERFLOW_BIT		= 0x00001000,
> -	SCF_UNDERFLOW_BIT		= 0x00002000,
> -	SCF_ALUA_NON_OPTIMIZED		= 0x00008000,
> -	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00020000,
> -	SCF_COMPARE_AND_WRITE		= 0x00080000,
> -	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
> -	SCF_ACK_KREF			= 0x00400000,
> -	SCF_USE_CPUID			= 0x00800000,
> -	SCF_TASK_ATTR_SET		= 0x01000000,
> -	SCF_TREAT_READ_AS_NORMAL	= 0x02000000,
> +	SCF_SUPPORTED_SAM_OPCODE		= (1 << 0),
> +	SCF_TRANSPORT_TASK_SENSE		= (1 << 1),
> +	SCF_EMULATED_TASK_SENSE			= (1 << 2),
> +	SCF_SCSI_DATA_CDB			= (1 << 3),
> +	SCF_SCSI_TMR_CDB			= (1 << 4),
> +	SCF_FUA					= (1 << 5),
> +	SCF_SE_LUN_CMD				= (1 << 6),
> +	SCF_BIDI				= (1 << 7),
> +	SCF_SENT_CHECK_CONDITION		= (1 << 8),
> +	SCF_OVERFLOW_BIT			= (1 << 9),
> +	SCF_UNDERFLOW_BIT			= (1 << 10),
> +	SCF_ALUA_NON_OPTIMIZED			= (1 << 11),
> +	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC	= (1 << 12),
> +	SCF_COMPARE_AND_WRITE			= (1 << 13),
> +	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC	= (1 << 14),
> +	SCF_ACK_KREF				= (1 << 15),
> +	SCF_USE_CPUID				= (1 << 16),
> +	SCF_TASK_ATTR_SET			= (1 << 17),
> +	SCF_TREAT_READ_AS_NORMAL		= (1 << 18),
>   };
>   
>   /*
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
