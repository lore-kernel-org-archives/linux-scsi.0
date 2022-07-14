Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31A6C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Jul 2022 16:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240512AbiGNQrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jul 2022 12:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240511AbiGNQq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jul 2022 12:46:57 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD61013E36;
        Thu, 14 Jul 2022 09:45:14 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26EFnZWd008489;
        Thu, 14 Jul 2022 16:44:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BbIw4+LozC22M8/yIeNVUk6ZR4qJzYaYN1CpFbqm00s=;
 b=Nu4wFJZS8RfneT+9SXI1/+RdRPMjfevJPY921usflm5w8Ixmhe5Z344dfgR0fRN0xh4V
 zBx/xhp10kQJDizt9C1bINLbJVctR8+W80jDcy786oBxNGVZxtVnr1WIdmmcOtxwl3vi
 gEwbArqik8/gbglCjgDkQtta5KkUiD/T7uzeoYbPDDLo09aPqQfqkNZUlxekdL+cKqHW
 795uu/QDMra2a70DJaAJEkCT7RCU+omVCwWj6ZYgvCtOvq0zMWNMmFqMZS/qzdgdrF+z
 +/r6tb1h3IZNkXRueRezBcwcwyvqwLAyWzqXNgav/8/LhYqoZHPJwS19ryox/C0SRMYN zg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3h71scdv05-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 16:44:29 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 26EGfQON013925;
        Thu, 14 Jul 2022 16:44:28 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3h7046fgvj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Jul 2022 16:44:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i57ij9EdMkyGf+WRf45kPavJEjCVyBJzV4OUnnPiGKL+0rFqXcOtTUwj0oBysQh0zE19Z7K8nd2Zc022MHPPsh11/ZHUd5o7PM2TLm/m6kt52VqIwqSr3UeezO2G/IJ+zZsFuIiit5xHmJv8X00mFkVxiFJjP9bO6SFOtNIO1I1zR8asbTk7ml1eBBzkxYQrbUpJ3MdTIqXtFNhzY0d8ELgfpXcRg6VWcfe86rEVR98JqLvstWetWxWRRpyqaVw8q+QC4PlLI595Uk37JxNvAgrMYhLqZ0uHIh9x2uxz5T/Ak15XN6mGB2ipKypFcPj3ICHUw3bdTHtuJbODzD2Dwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BbIw4+LozC22M8/yIeNVUk6ZR4qJzYaYN1CpFbqm00s=;
 b=OT9tFVWLZjPN4v61vm9K/sTDx0aeNPmt2xJm3U+OsyJb4CCmAK2ehQZzSGLD8b1E1wJOhiN2RsSPiKp2PWzTwAceX2Y6p9hDVQFwt41hkR8mnROBwES8kj2KNzjZbSKYTz87r6oArvKno6AzbNFItnIvPLGkMn6f9/KwMTK/mombbudv4WhpBSqrqNf7KW1xUAr/Bo2rZ129KGRgkG4kA1AfDJ+as2NF/G/y/Ac09ZzosNz8F6RpVCa7IqsMGwPyqFPVTfrv7S0M2LG+2teymTJ3yn2Jt3xJS+vSutpucPQbfhzHu1MYux4+yKBm7UebEIFWnvsRgecEDjTOwk4g4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BbIw4+LozC22M8/yIeNVUk6ZR4qJzYaYN1CpFbqm00s=;
 b=UdS5rQql/s0U5aL1scm7gYtAG4FdI0AvUHMzZ7FyrB6lVAu3lLwn9L8KKXzqrKIQBvrlsYT8s1Cp4z08K4x/IeXL/t9HXklhyLzfNF2VVlr0H1buvuOf/VYp0bwS5pkbwKBuJh4hHTA6Vq5t3y6j++L/PDoOtodtIa0U9EnIWYc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1444.namprd10.prod.outlook.com (2603:10b6:404:46::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.13; Thu, 14 Jul 2022 16:44:27 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5417.027; Thu, 14 Jul 2022
 16:44:27 +0000
Message-ID: <0fc89e77-197b-47e6-f661-5f7f18f6634f@oracle.com>
Date:   Thu, 14 Jul 2022 11:44:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] target: iscsi: handle abort for WRITE_PENDING cmds
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org,
        Nick Couchman <nick.e.couchman@gmail.com>
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220713204212.7850-1-d.bogdanov@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220713204212.7850-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0016.namprd08.prod.outlook.com
 (2603:10b6:610:33::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b861e737-a919-4f2e-7433-08da65b81d5f
X-MS-TrafficTypeDiagnostic: BN6PR10MB1444:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h7ZGzAUeOd6dw6yEGZtXeBQX3UtDLSt+gymoq68PsYHjMlIaUfPJGXrqVwO6ICeOylqUYHY9M/uUKKdTA9VgUoFVcEi8gj21W/qS3qrxuddl55cH8ar182D29s3ivbl2fpmaMEWg1ZQJdrK85mtJBPGL0b88Iv1eMZhS3Je62mcL1HUC9PFZRYcfwc3cBfj91C+kRkCx1ItOdAlfvXd7ZBsEnMe4X+w5JdxbaiitPTYuxuFUhrFx4E8Hny/gFXLz4sGHdKQKvPrrmFD8LJbJQoqtKlYcRfYwZ4vSrQ90bu7xV94dFmAYKRD+t4uV3dtTn2N9a6jLrMolEb9lxi3S1d61IVtiDfLiTSWx1QwL60w+4EEhBnrfa42tSA4kfmAvC1CnNR2KewA21eLdmSfhSKcclWMK5Ei7whprin4WwbblKnhhb90/HP4nXST0g75B3RJ4WwyrJurA6BnDL6gHFC7Oc5D8TPCDQMiPi5uCVX87ws9YxCiN2ZPa3RSwDOg/4uwInq1ubLwyC3wHjklEuP59CQBPPHNax4TBCf+NgHijHvyg2+Yp05Qu4E61kBZGkEGNMhDIK1zmF2z4IgIcPKPp5FQx4zYxnyCVH4TRUswyKBzvZsUQvYG/Ue7+nUH9PRN/SpuQrYO/EgDvp4DEMAuNhoYni3QNBvGNFafo9tO4/0PHDbHCn6SYNrMh/ufotaH7lIsQVBIT7TsXZj1QY99mmucqCI8ALgef+bff6qQNX1HndJdiJ+AarHz6XcvflVctKZTWLXD1fszZgfh037aGujTpKlNbk/sHsUZjEFCPjJfjPUxyt7OfYsRfMse+Lw+agnH3h5sOfr2jd9cTuqHTxK+hKEFJPU05uEo4xTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(376002)(39860400002)(396003)(136003)(366004)(66476007)(5660300002)(8936002)(2906002)(4326008)(83380400001)(31696002)(86362001)(36756003)(478600001)(38100700002)(110136005)(6486002)(316002)(41300700001)(66946007)(2616005)(186003)(26005)(6506007)(8676002)(6512007)(53546011)(66556008)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TXFsR0RlS1E4eGpiam9DOVBtWkZ3dklDWlpGUTMxcEtNZWw5RXVPN3orN1dH?=
 =?utf-8?B?Z3M3UldZTkVBN2I1elNES3ppS05WWGV1MjJLYmh1Zmh1eWVWbDhMVkRwSVJz?=
 =?utf-8?B?ci9Jek1WS1RNRVEzRlhCZ0ppVW80cnNkTE9TN3g3OUgzdDVVeWVNMnZ3VnpS?=
 =?utf-8?B?My9ydVdFcVdLNlZ5K2Z6TU1sMW1RZUhmWjNZWU5mc3V6YWpyNStmUjRCdjFu?=
 =?utf-8?B?UGJjYmllOG1hTytVQ01NMEk1UEtGYkJDaG1XSjFGaUthRmxlankzZk1IRXZV?=
 =?utf-8?B?ZklvTFNEZFdlVHU2TTl4OWhMdlppWkdNQlFnWk90Z0NHUFIvYWp5TDFEak1p?=
 =?utf-8?B?ckgrdU9FU2ExQ25XWXFnS0dOdWlmdXhLR3FTMWRXY3RhWmhRZ1lLa0Y1YWNS?=
 =?utf-8?B?WjBsMCtKSmVXVTZ2dkcxN2c5RGwwUCtoM3V1ZHROS1Fkb21SQ2M5UXl5WDd2?=
 =?utf-8?B?U2psa29IejRuR3pqT01OWnVkU3hKRm44WktSN1JXNGRXVzY4aVc5by9HRk96?=
 =?utf-8?B?RFIvc2diSm01ZmZnWS9DN3R0Q1IrSDJ0d2hocUVnd25aNWd3Zlh1WnJYczhR?=
 =?utf-8?B?cUhORWFBaFFxM1NiZWlFeHpUeWFuQzJxVUFoZGM4L0ZnMEN5ZHRPNEx1bFNF?=
 =?utf-8?B?YzRHUHpmWTdwZGFtZXhyVjJqY3E3U3VSTUhFcFphb2xQZHN4WXROTVZhTkRS?=
 =?utf-8?B?am4rUkxzamY2a2R0c05HNStrbXFSV1plaEZPUnZCTjRndCtKNm1mWTZwYU9x?=
 =?utf-8?B?NlY3bUJ1a3B0NFhpS21IVGF2dmExVTJ1TWRRTEdDNW5hM3k4bmh3MGozaUNK?=
 =?utf-8?B?VXdNSytoVXVkOUpaVy9zcTZ2U2VIazN4TmVSaG5HSU5TNGdlQWVvRHY1TmdH?=
 =?utf-8?B?WUsvZy9CZ2cwTk5zd1VnQ0RaMngzeDFWZFRzc2NKMEhiN1prU1JzN3RPNDla?=
 =?utf-8?B?N29EQkJXVXhFTEZsSkRaTkxDNDNCT0ZSMm5xMGhqaG9wakMvVC8yL3lCSEJm?=
 =?utf-8?B?cmhuM3JNY2Z6SWEyaXBLR1pIY0QyOTJoeEsrYlU4NldWeFEyT1hLekN5QVNU?=
 =?utf-8?B?dVJQSmFneWlGWUFLWWR2RDhVWTZlTmNPamQrTEJ2UDRYSi9Ba2tkQkFmenQ4?=
 =?utf-8?B?YnNndWhjNlZpaGdJc205RFQyeWFCcFptRWZJU0Rha0pPdUtiUWtkT1NMRFBv?=
 =?utf-8?B?REM5dytyOXlQZGRLTmsvby9NSnNtNEIrT2VPWTdQM21CVGZyWFhNZmNyWS83?=
 =?utf-8?B?Y3lGaUplOWwzQVM5NUh3M3AzcW0wcGpxa1F1RS9EZnYzK3dlQ3FNbDRaaXZo?=
 =?utf-8?B?S1V3Ymp2RmVXZm9aRDM5OUYwQzh6K1VKdzJMWkNQQkNBVTJGUjFRbUlOci9X?=
 =?utf-8?B?U2tJZEVNTzFoQUNnYTBxWEN1MDNQOHFhTktDSU9mSVd3UGFPOCtoN0ZBVzYy?=
 =?utf-8?B?NXdHaEluNmFubG5PdVNoRHVmWUdVb05jRnF3b2VqVVNlWUwvOXVWYzd5TXBV?=
 =?utf-8?B?SXZUK0FSUXZDY0NrM0FNM2F0Y216TzFTOHRtOVJuVzg3YWtPdEl2TjZSWCtq?=
 =?utf-8?B?NTRzYjFDZzVaUmowNlljQ2xzSGJsbW5Pcm9oWWtTRUMzVVpOTHhaTzZjQkpP?=
 =?utf-8?B?MytnaGJzMTRWeFBIdk9iZmFBNjdxQUc2TEJDbXp4Ymp5VmhpNUZqSWhkd1Nh?=
 =?utf-8?B?cU9oTlhmL21CY3RSakpLUzFNWFZVSmtkTEx0MkNRTEx0KzlrZnJrdCtxM2ho?=
 =?utf-8?B?ZFpDTHByZ1Nzck16VzVoV3Z3L2h5bE5pd1dLQ1pmNmdJTkw2YS9GWnVUNmtM?=
 =?utf-8?B?eWxJYXFHZWZselFCUGtVcGZnbzdGYkphZ3ZXOHU4T1BRbVlMWS9mcEZrUFF0?=
 =?utf-8?B?M2czenZicVNnbmJUOEczUkROZ0dEd1UvNjJJTFpGNEExQVNoVC9FOHdPTVhi?=
 =?utf-8?B?bXdEazFjY2F3a0ViZUNpL0ZYNTJJSDJyTkFzalVoYUJadHhxTDB2WXlXMGVa?=
 =?utf-8?B?TlRjTnhOekJra2ZlblJ0VDJXbVNSa3VSVEJJQlNwNjRPQzBnYVB0c0lXZE9n?=
 =?utf-8?B?UHVGV04rN3dKZ0FXREVpNHhvRWZicUt1NHoxKy91NXhMTDUrZnZpWDJjbDBl?=
 =?utf-8?B?WG8zTUJ4L3RiTUlMYm1nb3F2eHppdnVYMmFFc3FFRC9yL3grUjIwQnd2ZFUx?=
 =?utf-8?B?blE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b861e737-a919-4f2e-7433-08da65b81d5f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 16:44:26.9091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ZqfP4kho5eJmPTyb7rIELaDlquoIEAEC6eIDUykazZ5Y1/mP7nibls7NdBU0EJWUFsDWz7eOAPLUxa0WYeMBYiVtv2vLTbeFOhC0osxGuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1444
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-07-14_13:2022-07-14,2022-07-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207140072
X-Proofpoint-GUID: _1BnngnCRhsyrFnNaV1PyWqeJbJZ25rA
X-Proofpoint-ORIG-GUID: _1BnngnCRhsyrFnNaV1PyWqeJbJZ25rA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/22 3:42 PM, Dmitry Bogdanov wrote:
> Sometimes an initiator does not send data for WRITE commands and tries
> to abort it. The abort hangs waiting for frontend driver completion.
> iSCSI driver waits for for data and that timeout eventually initiates
> connection reinstatment. The connection closing releases the commands in
> the connection, but those aborted commands still did not handle the
> abort and did not decrease a command ref counter. Because of that the
> connection reinstatement hangs indefinitely and prevents re-login for
> that initiator.
> 
> This patch adds a handling in TCM of the abort for the WRITE_PENDING
> commands at connection closing moment to make it possible to release
> them.
> 
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index e368f038ff5c..27eca5e72f52 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -26,6 +26,7 @@
>  #include <target/target_core_base.h>
>  #include <target/target_core_fabric.h>
>  
> +#include <target/target_core_backend.h>
>  #include <target/iscsi/iscsi_target_core.h>
>  #include "iscsi_target_parameters.h"
>  #include "iscsi_target_seq_pdu_list.h"
> @@ -4171,7 +4172,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>  
>  		if (se_cmd->se_tfo != NULL) {
>  			spin_lock_irq(&se_cmd->t_state_lock);
> -			if (se_cmd->transport_state & CMD_T_ABORTED) {
> +			if (se_cmd->t_state != TRANSPORT_WRITE_PENDING &&
> +			    se_cmd->transport_state & CMD_T_ABORTED) {
>  				/*
>  				 * LIO's abort path owns the cleanup for this,
>  				 * so put it back on the list and let
> @@ -4191,8 +4193,13 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>  		list_del_init(&cmd->i_conn_node);
>  
>  		iscsit_increment_maxcmdsn(cmd, sess);
> -		iscsit_free_cmd(cmd, true);
> -
> +		if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING &&
> +		    cmd->se_cmd.transport_state & CMD_T_ABORTED) {
> +			/* handle an abort in TCM */
> +			target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
>

Will we have an extra ref left on the se_cmd if TAS is used so the se_cmd
does not get freed?

For TAS, it looks like we would do:

- target_handle_abort -> queue_status. This would not do anything because
before calling iscsit_release_commands_from_conn we have killed the iscsi tx
thread.

- target_handle_abort -> transport_cmd_check_stop_to_fabric -> check_stop_free ->
target_put_sess_cmd.

iscsi creates the se_cmd with TARGET_SCF_ACK_KREF set so do we have one ref
left?

For the non TAS case we do two puts:

target_handle_abort -> SCF_ACK_KREF is set so we do a target_put_sess_cmd here.

target_handle_abort -> transport_cmd_check_stop_to_fabric -> check_stop_free ->
target_put_sess_cmd which does a second put.
