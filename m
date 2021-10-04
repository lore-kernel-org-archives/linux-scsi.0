Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8288C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 20:36:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B747C6120C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 20:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236521AbhJDUim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 16:38:42 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:22724 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234781AbhJDUil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 16:38:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1633379811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x8oDhCHFj2z3PlFg5lVpGp39sZcCtIvMJQuB7lfSsPc=;
        b=finyx/+RHzp58Vn46MMK4YFPSi8pC6ghqRdk3lpM71XMS9LmBo0RfYrA3QM95/k2NqbfUc
        Hx9XOVrgHvWuZAtEHWykt1wCvBfZZKXjVHNb2cwecBTUklh+qIdK5z2snnU2P5neokveCN
        BCZfJjffb22myeTge6YZNc9qPfBeJaE=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-0cyUAsKBOiOQeT1nn-wY8Q-1; Mon, 04 Oct 2021 22:36:50 +0200
X-MC-Unique: 0cyUAsKBOiOQeT1nn-wY8Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pt+UKcES5WnECVejugOsK+CQqGD/IzwL6AMhk23BLN5ywoOvoT4lKwKyLDqu+1OieobQ7V2D1IL1g0+/rEghieuEHBbT2XNtDqlZWn4uHnOaTLXwOni7Ymmc2aqhtaF8VQI0zmXBLJzgiOWpTHepfKkCOF9ekSi9YMjBuwPk4chOOetw3xnXMPn28HkX9uE2rM7WKr5iFMkDeGzz3eIj0MnKFqQ4MeLbafMknWakjyfPbGq7n/6uSX2CWYAFP6CkKnrQqi1keTGrIaGjQMM0EtPTlmoW8ykeBCwVjUkV4bA1/3liODrDcLO8Qg4+IpdQveSwYN4mZ9YTZ+MOijnPhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x8oDhCHFj2z3PlFg5lVpGp39sZcCtIvMJQuB7lfSsPc=;
 b=RTAU5Y/hivK6GlahQGuiM6tgQ8ALedhJMduJ8REa4Lg7b4RYCC/7KR1bli81Ns8envNuVmF4cTL5N7S5AlrPbfdZ8zDR75sL65pYhNLZ0j8bTF6E+V4y0fcoTLzVfLW73Li9tK+Qq8wWX4ZQ4WWHjmticsgVYbFHZ3YZy2CFIH7tCh+4D5ENWtG/lNtPwb9lt54QDJQP2XcOebLXhN2RUj5YmaCwEz5+ehsHMoLV36mvUrk07Xqa/9d1Jkl4zXxK/K3GyoNNfwet8XiFYew+oR/gI+oRQihDiNSKrAApIhX8lfgyf0OvmLnii0tkM7Tz9cXIn5c5BIqWLDWyisbogw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0401MB2658.eurprd04.prod.outlook.com (2603:10a6:203:37::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 20:36:49 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 20:36:49 +0000
Subject: Re: [PATCH] scsi: target: core: Make logs less verbose
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210929114959.705852-1-k.shelekhin@yadro.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <6a719833-3d02-fbbf-490c-a06886648186@suse.com>
Date:   Mon, 4 Oct 2021 13:36:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210929114959.705852-1-k.shelekhin@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR04CA0063.eurprd04.prod.outlook.com
 (2603:10a6:20b:f0::40) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AM6PR04CA0063.eurprd04.prod.outlook.com (2603:10a6:20b:f0::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 20:36:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c99c9bdd-901b-42ce-cad1-08d98776b0a2
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2658:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB265817BDD0A5AC3108330786DAAE9@AM5PR0401MB2658.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:138;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cXKVEJtZu6t1rDLRTVVnopQHLmwsrf/tY2ZCKXCJfkTx1ZdRoFw34GzDcB+go7DjSwju2YcTl1MIn4o92x6ERHt+v9F7kxElKjrQ3zklwj9aR5mheyTXp/E66acUGJda45s22ykPZY94ifBYZxtGVC1eSvmWkdngMCObk2ACrAg7Xfmt+SUtJPS5v+TZ3sTcBs0pQ3c7AMy1in3atsMcWM9WxQWDA01yiHr0xEeFqjJIrxmGCxrHVUViKyuwePcoifE9vNQ0uBMifmn9Mmp06uh86itnhYdJklHiWUwD6GVjm0BsTwUbQQcPaeUU5witTVGWdGxyXaSk1Gqoyxirq5qxqvuaZ4v7x3ecP2b9XzHoomb8P8dyYgVS3444J628B17ur+sFd0Sk2qh2BTgBJe1GmHvELVB0dAMjZOJqY6BFsGYjSkaxFQIZE8NKYnlrpiyCdoZv5qQA/9YVj5u9S878/lBsY0ZnectN7bR/90tmFbND4/qqKJKwH6hAE6CpkD8KreZQk1GqH+u0Uxth3SSwm4VHrGAKuXwDf7xvbV+6RfEDPjn0bZnuOaYTvlONJ03mvmBrKLzElXGL/zPpm7iFN04Y2bKWtNdYtGSsXUaeWcL4oR8OlrSZ4uq8WjV61B7WI4n2BNGen/T+7p/Y6dMjhWlTxJkfoP+7PTgdRW5ysJsFgGmY7H6sLaHu5oVN9AiwPmkjvETxy+Xi8i4fxyKtKzRbswZSpnV7tVI2vHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(956004)(16576012)(5660300002)(316002)(31696002)(26005)(38100700002)(66476007)(2616005)(4326008)(8936002)(8676002)(66946007)(86362001)(31686004)(6486002)(83380400001)(36756003)(53546011)(110136005)(508600001)(2906002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2xHU3RTNWhMR3l0UHN2L1RDRXlOalczQkJSVkdxZWdiV0UrS2ZrR1FMMFRk?=
 =?utf-8?B?aERyM29OOTJXejdCVDBoeUp4NUxxaGF1cjRxL3ZCdzgwYUJWd3crcEhTNzFa?=
 =?utf-8?B?QVUwOEVTTWRCMTFNNUZGWGVINnprdll4UVpqTFJBZ3RnWGhMNmYyQzhJWTNI?=
 =?utf-8?B?WlFwVzhqU1oxYmlwMmZkTG5yRWpwMGEyU241OHJuaklCU0Z3TjBZcyttK05P?=
 =?utf-8?B?bWVxRFpqc1RwL1dzRDd2M0VIbVhNbWphV0ErOEJxaG5FNFZMcDY5VnJZdE1m?=
 =?utf-8?B?Q0daTW1MVURYSUpBb3pOeGlDZXNTLzd0dy9maXh5MitFenc3d3JJMUZSU014?=
 =?utf-8?B?YVM1eTV5SHpsUUptWEJPRGQ4LytrQ2hCc3hHcEM4WnN2cHhvQU9MVHlqRkwv?=
 =?utf-8?B?NjRLVmZMcC9odGlRSUNTTlNicnFaemE1NWNNanJmSWVZRW5CY1dQRE1HODFE?=
 =?utf-8?B?V3Y5NWp2VWRLclNFQmNuWmE1MDJlV0hIZ3VVYXJpN25CekNQRU5wL3hsb2ZN?=
 =?utf-8?B?Y3B4dTNOODhQUDBVaExXZlFMUllYK05IcDBJci9RaDd6NEt2VGRVRG80aVZC?=
 =?utf-8?B?c1RUZ2FCbjltTEZOS2Z3Z2REQTAxVmt0aFZMV05oTnN6WkFNK1NRRjhCWDVn?=
 =?utf-8?B?SEc3OTFjaHk5VjVZamRJb1ppZ1FZUVNXWjZyYWZoWUhXQStRcWsyeVpXd21K?=
 =?utf-8?B?V3BUK3prVGZackFpbmhVeXVaWVBHcWNGVDVjTm9RVHZJL0ViVWF0dlhGQnpp?=
 =?utf-8?B?c1Yzam80UzRGNkdOS0NQKzdaWDYxVHlKWVFiVUkwdGFNRWhzMjVML0hVQWtP?=
 =?utf-8?B?MmM5anhaWUpTaTlmVU1RdGpQWTZVR1k3Tmo4Uy82Ni9HZ2JKSDNQQXNjS1Ir?=
 =?utf-8?B?Z3ZmRmsrRVJLNzlMTTJsOVUzRVQwRE8xclFYRHVrbVFVR0FicmtidW55OFpi?=
 =?utf-8?B?NDc4bk55K1VsMG1FbjZBYTRUSUo0N01hcGNObzVkOGpFT1dNOXR6VDh5NGxL?=
 =?utf-8?B?OTI4UTVJUzhkWFNzaTlqVWZSRi8yNWFxOHZyR1JCWjQvTWxMZjJxaUJJcHlH?=
 =?utf-8?B?MStPZ2dJaUFQUHBRNFo1T2pwa3NsMFp2VWY0akh0N3pEaE1sNFZFb2FnemdN?=
 =?utf-8?B?RDdEYXc4aE9TNFRTT2JOVksxOG5mKzVYcEE3RTk4SWhJL1FDTWNtSlZFT2FV?=
 =?utf-8?B?N1VQOE9yWC9sYXdPWXNMTDdIcjVzSERwR2x5MW1vWFlUTzRwcm5zdjhiTTZX?=
 =?utf-8?B?akV5bWJKbzRITVZjdTArUVJWbmZ3V1d2ZHR2aTFmdmRBZ25uTkgyV1JQaFVV?=
 =?utf-8?B?UXNmV0NvN29Ic3pIbk1YNVh2bDdDNHpOczRESVZkRktHNzJFRzg0VG9ZSFB4?=
 =?utf-8?B?QXFMNHZIZ2VXYVowWHNaN3NEN1NhUFdEa1JGR0Q5S2NEMEFlZVVJc2I2ejFE?=
 =?utf-8?B?bmp6SmszYUU5d0s3WHAxZjY2OEIyUHRpY2N4dFh1NkFIMVkyWmV5TWdRcGZy?=
 =?utf-8?B?aE95S25XRTBOdDBQZzZ0cjU1UkF2UFhQa0hCQWdBdFRQTjdVR2VuQXAxN2Np?=
 =?utf-8?B?UGtGem9aTUQ3NVJNRUIrS1prR0pOek9XTkhJenlBV3l6aEhXSVBlUlR0eG80?=
 =?utf-8?B?Z3BxS1NuNUtMeG5vaU5FT0FzTmkwMkozVUlIMUNCTUtyK1VnbGVTc0dhbUhM?=
 =?utf-8?B?MjQwMUFkdGRLbmRXR3JTbHAwaWJjZVJId0xudEVvRTk1VWFweXRYMXV2eGNz?=
 =?utf-8?Q?QFjTW5fk31IsFZRwk53hxy9UbxIae+kb57tCmpT?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c99c9bdd-901b-42ce-cad1-08d98776b0a2
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 20:36:49.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4VS+53/hzHa3BhDY//IUjmN1/GsSIcdKVkfUp2iLbWq8FYO0WTRC27MsZzWNVgbulaOSx0YkZPLOM1HGd9KStA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2658
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/21 4:50 AM, Konstantin Shelekhin wrote:
> Change the log level of the following message to debug:
> 
> 	Unsupported SCSI Opcode 0xXX, sending CHECK_CONDITION.
> 
> This message is mostly helpful during debugging sessions in order to
> understand errors on the initiator side. But most of the time it's just
> useless and makes reading logs much harder.
> 
> It gets particularly annoying if there are many initiators that come and
> go or if an initiator runs a program that does not care whether the
> command is supported and just keeps sending it.
> 
> Signed-off-by: Konstantin Shelekhin <k.shelekhin@yadro.com>
> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  drivers/target/target_core_transport.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 14c6f2bb1b01..4a0055ab9151 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1511,10 +1511,10 @@ target_cmd_parse_cdb(struct se_cmd *cmd)
>  
>  	ret = dev->transport->parse_cdb(cmd);
>  	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
> -		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
> -				    cmd->se_tfo->fabric_name,
> -				    cmd->se_sess->se_node_acl->initiatorname,
> -				    cmd->t_task_cdb[0]);
> +		pr_debug_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
> +				     cmd->se_tfo->fabric_name,
> +				     cmd->se_sess->se_node_acl->initiatorname,
> +				     cmd->t_task_cdb[0]);
>  	if (ret)
>  		return ret;
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

