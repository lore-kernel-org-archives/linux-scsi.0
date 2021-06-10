Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365B0C47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18B76613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 14:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhFJOgw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 10:36:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbhFJOgv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 10:36:51 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15AEPlSc082777;
        Thu, 10 Jun 2021 14:34:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VpYIiSAQk3zCTjirR04kRDc8vOrwwiyPP1xhcVCWZdk=;
 b=i7J9CmSZKoUDSsJ3yBIi/g3X5SWlSLfeMCSbP5nr5Wd4fpQXBdRKSbYinoW5EPrWQHXG
 i5eFNe//CjtM7kCkEY1w4wmkes1XIxZgiGKZtsr5ltogc4nJW3QBsqxIk2R+2wW5aDd/
 geI0hgn92JZvp++RGD/yEKSypQ2SKJHE7Z58h8LiBMstOqAyHs0so4Qjj+k/miCqxvod
 BRS0Mllzg+4mGU1DSWe0k8lVLYE5H+HNY8lDLcWXQLwqu7YiV376rlDqWyEQQMXtp0pS
 5KAvtDOZHHMGUI+JsrggiMLFJefrihSPpAFR9i9mP17SGTAkorBOO0c39+kwnvngtGaJ mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3900psc7k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 14:34:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15AERQ8c158201;
        Thu, 10 Jun 2021 14:34:40 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by aserp3030.oracle.com with ESMTP id 38yyacn8uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 14:34:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fv/Ki+NwVvN346Da8YPhiCwScG/ykkj6PHkQHWqvKWO4zYDs6XKxxDSN/cG0Psf/ftUrn4A4Gr5ds3+gWD8a+tdCSsbLMwifxZnfYt6ICdlGmb9NKfZtq1WjLND20AvkhYHlZCO6OHeGUV/6KOifvBhtGGR1cuu/i5yQ8fA0PDeblJeVLyWbEHLPN0Tu1g0oCPnj7JbTmf5czosj934qu9NuNqVhZ5visTzAnuag/ypPvYpdYTFHH+ADD0hGRazcPmqZcH2h3KJERjKSSqKMYGvSeKKtRZTBEEfc2OtAtFEnnS1Ht7Br9e14VYDMbFKBM66s2V8UCFEYBU44kzXGMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpYIiSAQk3zCTjirR04kRDc8vOrwwiyPP1xhcVCWZdk=;
 b=jhhSZ2DfKhaRKKdDRo+3UoqcDe+tDh8bYbKxqTplO6b84qzC+3kVj1hJREy9+rn2Fsh4V0JSbQHwSicTHsTE21krpFFJOPyaC5uP8xHq5n4IFV9QkxOMKStxDWzgn+eAj6lUjQYeeNYaEaXEiUfSynRdiYeEwm9lzpoiiaIE7sE78F29MbwrN7QewjGsY6a0Fw6FAGl0l55fVS30Vh6/sw6QhUK7aLaK/srgg6LI48u20K9tKgUjDVBAnvX3ZscIqQ1ae3R9dFDN3QbwnoZEmuMGF+E1sVEX+A1cwLm/Kg+2podOu9dXLZuBf8wvBlY5XF9NiOKMCPv+w2g2P1F8Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VpYIiSAQk3zCTjirR04kRDc8vOrwwiyPP1xhcVCWZdk=;
 b=QGUYD7IWRSdMuTI6HYqrLvsJ1zGNN8Hx8smocJm91Gd5Pwi0gj9W5TI8NH73WQRtHSaYnb+MvXYnVvkfJMsOV1Rv39hPFfGp+5l0r6jazCTN75ZXJk8i0A2kHBKGLWNTUKF7altLxhoCNu9AuzHH0DHWBzorakAeDHP9TB3C20k=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3453.namprd10.prod.outlook.com (2603:10b6:805:db::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Thu, 10 Jun
 2021 14:34:38 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4219.021; Thu, 10 Jun 2021
 14:34:38 +0000
Subject: Re: [PATCH] scsi: qla2xxx: Remove the repeated declaration
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        linux-scsi@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1621843402-34828-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <dbdb7278-8a06-bd52-b071-5552d3487cdd@oracle.com>
Date:   Thu, 10 Jun 2021 09:34:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <1621843402-34828-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2606:b400:8004:44::12]
X-ClientProxiedBy: SN4PR0201CA0037.namprd02.prod.outlook.com
 (2603:10b6:803:2e::23) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:2001:91:8000::cda] (2606:b400:8004:44::12) by SN4PR0201CA0037.namprd02.prod.outlook.com (2603:10b6:803:2e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Thu, 10 Jun 2021 14:34:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93ec2198-7bc5-4fc2-8afc-08d92c1ce05e
X-MS-TrafficTypeDiagnostic: SN6PR10MB3453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR10MB3453E706454CA12C17FD6AEBE6359@SN6PR10MB3453.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:200;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DRsVFpi2234HEHzfhqENJ1ZmpQXk9eCpEGXjAClsOhqMAJIZZKjJpTr0gCTIJW4p9dzGmAKAJTssIC1hxne0/JriyvhKrm5ZOCSaTTcCHuA9waE0EocQ26q4tkv04aTbf2vDLzv/uKyVVFZ4LP7sAqbAurdee+v0ont2LG0ZH8Mm8WskUfeQCCLM0ntrZ1K9WtdUEU+EgKBnScm9SaR4eRJ9rbzqjIy10g3283hKRUt4NrCUxexCFmgu+K9vguEJyjSJAtVKN6PjugOqCnPpWor0DVLbhrdp8+dk1tGhErr2Zk8i7NXoNrLYzAbKC73od46WBwekFtf/7+7VdtJmGUnujEk3LlHC903Uyu46eOryDqiyj9kOdVuEPdyyOlBXQp657/W/wmkkFe4ke3m9EJIgGqSLxcAvrxEbdqItkMSdQG6udmgW6JIsJKj/JWu0rTiXab9HvDm0XkVzD9DGcyBQVk3tj0wD8UvZFskZoCyj4M10geNvzhQR2xb7wILsWQw/jlczh1RpTQ1GybtI+YHmj9OrRYy7G+GayGsQIBzmDHAw+WZE5O9dRRXtkrj31l5f/5GwEaRWWs/Z1BBTEMND8wpX1tl7TJenR+yDneHKCS+1R1irW0+WVQRWyLMqewwdb1Brk9cjZnaYkh03LiKz+3x++uIkpbXHgziHq1Vqye/C35wRYzqCJtHWh44A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(346002)(136003)(39860400002)(83380400001)(316002)(8676002)(6486002)(8936002)(31696002)(31686004)(36756003)(86362001)(2906002)(2616005)(44832011)(38100700002)(478600001)(5660300002)(66476007)(66556008)(4326008)(66946007)(186003)(54906003)(36916002)(16526019)(107886003)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N0VNSzlrTUVMQ2hCYXR6aHh4SDJtclFKanRvMEwyMm81cUtSVjhSQjFONzNI?=
 =?utf-8?B?S2tkaUJVcHlkY25EUnZPMXNkQ1o2TTJCTCtFK2NicmhYR242aWRPeXl5ZXZ0?=
 =?utf-8?B?SHFyT2xUUEh0THNSUzZTVWU1VGFlaENWZ2JTSkp6Yno3UXd6VVpYdnpMdTJQ?=
 =?utf-8?B?M1BnaVBpQ3F4ZEVhYTVINVg0VlM1Mjl0ME1Zc3RLUUxPaVErdDNYOUo2WWhi?=
 =?utf-8?B?b2Rub2w4THp1eFVYeU9SUDFhMnRiYzNGSnM4ZnhZS3NjVkRyQVVaWkRoTEhV?=
 =?utf-8?B?N1VWdHpHM0FZSDBKQVVOa2M2NkxqbHdWZnRIWkZ3UWR4dzJRckhJS1hyWk0x?=
 =?utf-8?B?dmk0NDNOalAxcm00ZW81Sk5TUHdEZlg5a0Q3WWpyL2JPZU5JQjR5dE0vWHVD?=
 =?utf-8?B?cUYvR2Z2QTJLZzBMOG41dUNBN1JFMHA1RndYNTVFc1Y1VEtQT0ZPOUtyVkNs?=
 =?utf-8?B?NmNiY0kwMUNaZjhPZkU5ZUxGTllKRHBldWJhTHZZUG40a2lwT2Z4QThUdW11?=
 =?utf-8?B?eXRsZFRjWnQrQTYvbUdOVkZBODRLOG1yY2ROQWxINWpCV3lRU2dvZTNlNzdG?=
 =?utf-8?B?d2pqYU5XMHdEQzl3MmJ4b3VpcTl1dW9xNXVERHVyOXdrMk51eTVRYlgrems3?=
 =?utf-8?B?by9nOFZkNmV1dHBpNjc1OG91b3E3TktDUGpod2dBS2tIYUJlWDlGSi9zZ3RQ?=
 =?utf-8?B?RGJveWJDWGc5enBpWFFLV3k1U2R2MEFZaDNjQU5GYityUVcwVlNQaUZobGU4?=
 =?utf-8?B?WDdkd1JQbXBtdEYwR0NiancwaEh1T3ZCQkdkZnVxR3pXYjNLOUliaERHcTBO?=
 =?utf-8?B?L2JOUTVjL1lQWVhOZXhYSXAyVTJuOWw0QlpDalFJMXJxUDlTZWV2bVZIWXFs?=
 =?utf-8?B?ZzlEc0ZsS1BRNnl6Q3JobzVMbStyMEQybWtBUHNqZTdseU5lR1ExT1hGaVkx?=
 =?utf-8?B?Mzh6bVVHbW9MQTR5TjBXZjRrVG1aWE1WVDVVb0FiSmdZVkpnc3hkRVBHSWsw?=
 =?utf-8?B?NDk4RnpOUWEycXV3Rnp6VU5uSmFvMmZKYmMwelNIWVVua2xaMDlzenhNNFpB?=
 =?utf-8?B?NnJybnllQUU2WW5COUNJbmZLU0dJVnprUldIbkVQd2R2b1lIV05MRlRHMTZt?=
 =?utf-8?B?Z0dZY1V5bzgvZ0p6eXpwQWhPOXRIUlk4Z09Makg3eVNhaUZidG5iUVVybTd1?=
 =?utf-8?B?S2pCTnVaZWdrTFRlR0pkeUlqTUsxKzhlR09zV0FpSEdITG9kNWZ5UUVsaCsz?=
 =?utf-8?B?L3BzUVJjMG9nNUN3eFEvREhzbWVmM0tCQmpZQmMybEN5VjRXREJVMU4ySWNY?=
 =?utf-8?B?TlhrZDZmQWJXKzIrWVpJTDNteXhEekdsbWxiMlFsbzlVZzlQVnc1eHFBWWRO?=
 =?utf-8?B?Mi9YUnJad3VNMzBnYk43YTVMZ3RxTHBrVlJXb1NSWjcwYTFyOXd6emtwVXlD?=
 =?utf-8?B?OVVUQ1VKTG4vSlA1U0RPdVhjRkxZRU5LS1RaSk9WeWVBRk52NmJQMzZUZ0ov?=
 =?utf-8?B?ZHFvOE1tSmNORDdiUU45VWVMWS9OSFFGV0hpODN2d3lwWm1GaVFjQiswZ3l0?=
 =?utf-8?B?RmhYbjBmVW8xK2NlanhRMTMxWFlDTS9SZFJQVHlDemtZYTAzeGRaQXRoSHJL?=
 =?utf-8?B?d2F1SjBiMnNjdEVzMVd6M0dWUUQ0dUlsczFYN0pINURXWlR3c0M3WkVpL05E?=
 =?utf-8?B?cjZ1TnlFcGRDZEN1MjBiU0ZXd01jMFRONk1RTktFT09nWnJiajY2d0d0Rncx?=
 =?utf-8?B?OW1VV1IzVlRSUW9NVXVLTkJFL1BROFJ4WXkxR3o0Y0pxL05FY25LU0FqZExi?=
 =?utf-8?B?dTJLVnpuZ3E3QUJvOXBCQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ec2198-7bc5-4fc2-8afc-08d92c1ce05e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 14:34:38.5383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H0wZVBmhP5yUmCXdlinYC235xgOnTxU0WusB6PmVoG5uOcAhPvmrOEhemWupvRMw211k6kGBmdxe5vYdihRwjJ8+Nya6z49jAZmPo1GLGOQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3453
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106100093
X-Proofpoint-GUID: DufL9uMcVdhaepW6nkeF3LfTleiNMfir
X-Proofpoint-ORIG-GUID: DufL9uMcVdhaepW6nkeF3LfTleiNMfir
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10011 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100093
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 5/24/21 3:03 AM, Shaokun Zhang wrote:
> Functions 'qla2x00_post_uevent_work', 'qla2x00_free_fcport' and
> variable 'ql2xexlogins' are declared twice, remove the repeated
> declaration.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>   drivers/scsi/qla2xxx/qla_gbl.h | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index fae5cae6f0a8..418be9a2fcf6 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -173,7 +173,6 @@ extern int ql2xnvmeenable;
>   extern int ql2xautodetectsfp;
>   extern int ql2xenablemsix;
>   extern int qla2xuseresexchforels;
> -extern int ql2xexlogins;
>   extern int ql2xdifbundlinginternalbuffers;
>   extern int ql2xfulldump_on_mpifail;
>   extern int ql2xenforce_iocb_limit;
> @@ -220,7 +219,6 @@ extern int qla83xx_set_drv_presence(scsi_qla_host_t *vha);
>   extern int __qla83xx_set_drv_presence(scsi_qla_host_t *vha);
>   extern int qla83xx_clear_drv_presence(scsi_qla_host_t *vha);
>   extern int __qla83xx_clear_drv_presence(scsi_qla_host_t *vha);
> -extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
>   
>   extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
>   extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
> @@ -687,8 +685,6 @@ extern int qla2x00_chk_ms_status(scsi_qla_host_t *, ms_iocb_entry_t *,
>   	struct ct_sns_rsp *, const char *);
>   extern void qla2x00_async_iocb_timeout(void *data);
>   
> -extern void qla2x00_free_fcport(fc_port_t *);
> -
>   extern int qla24xx_post_gpnid_work(struct scsi_qla_host *, port_id_t *);
>   extern int qla24xx_async_gpnid(scsi_qla_host_t *, port_id_t *);
>   void qla24xx_handle_gpnid_event(scsi_qla_host_t *, struct event_arg *);
> 

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering
