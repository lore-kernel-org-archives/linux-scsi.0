Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FAFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 18:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC966124D
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 18:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232869AbhJESEo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 14:04:44 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:38788 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229626AbhJESEn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 14:04:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1633456971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ep9cwthQ9M1+TOJtKSNBRifSVrMz8cc+Vn64Z8SBfqQ=;
        b=Qixz4MZylstPdqfqQGHOYSUFn7X8QUajPhKb5G8WmVL/zstLeIR7szoNyLeaIrLaZyOr4y
        XeQC+J3vGKXridYyQyOa5XdjoEKs/wGZC6vBGIbW3U59F4acswHJ9NLMOZ6i2dDYqynEd2
        F64cNVlqG0uA5SOnHdTJzZ9cU5FRUpc=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2050.outbound.protection.outlook.com [104.47.6.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-gIRF3AArOBy9s_H-iJiv7A-1; Tue, 05 Oct 2021 20:02:50 +0200
X-MC-Unique: gIRF3AArOBy9s_H-iJiv7A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FyBCltj1dPhBXb+HjZuTNxkhpMzOZgx2Q0uUSJ52wItvnY/rCsmRqcUWr+e2yIecF3bYmTfYyHS1pZ90svuCZ1BkUVKFuzILaPA41pE+b8qK2fdcUr9q9L7wfXinr6N5d45jnY0VIEwxO31jnX2NQ7oPqQ4lscKDcAWGxnaw+4HvAYHDvWQr0R9q0y5rzkoc5+UrAc+8YkaV4tihbvdVlE8XaqIVIc2Y792yCNt3oFYc2snGejHSrrPPV9ZxiG/yaBsndo69XGAcbDP3/8q5U9rLq4RhRNltWrH70St1fUH7pVCDDOVk0BoQG9G6pz/SHAxaMZ9duMFvODwWx2iAWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ep9cwthQ9M1+TOJtKSNBRifSVrMz8cc+Vn64Z8SBfqQ=;
 b=X3p6ZF+y7idQkRJ2Gvkr3CQCgSP8LltmYrIDGmYZyR7RRBKDGDkaZSpnGsKt9HMnTldhHAUNcXhjPnUWBM0Q6VD4j+KOnynxV/gcplRPQcRtZultMZqRXEfRm6YqJmOzDU5PL857IA11iF8ATnFkoJem/Chsr4ESTw4x81cQ+Y13Cu37nHRClWkQ/tp/kCOZaiRu9tHkbojzzGWSKdCHD+sf5QN+12/4u1BPTAETbWFfXn0nDDGGCMrcrkq4rYbdqdj+0h5D0/KDc9zUKgAcElmm6hxawctvyinusdPOVLnv+VoRoUsZ7h5svjcnAz4SzHM0Hv6PmsCJ+a3fkGO8yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7831.eurprd04.prod.outlook.com (2603:10a6:20b:2a8::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 18:02:49 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::a555:3b27:dc03:8fcb%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 18:02:48 +0000
Subject: Re: [PATCH 1/5] target: fix ordered CMD_T_SENT handling
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20210930020422.92578-1-michael.christie@oracle.com>
 <20210930020422.92578-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <217dc64f-79d8-42bd-2290-74ab350a2dee@suse.com>
Date:   Tue, 5 Oct 2021 11:02:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210930020422.92578-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0137.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::22) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
Received: from [192.168.20.3] (73.25.22.216) by AS8PR04CA0137.eurprd04.prod.outlook.com (2603:10a6:20b:127::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 18:02:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bd57c04-b198-44a4-031d-08d9882a5771
X-MS-TrafficTypeDiagnostic: AS8PR04MB7831:
X-Microsoft-Antispam-PRVS: <AS8PR04MB7831FD76EFB88B49A1591148DAAF9@AS8PR04MB7831.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ykWnoFW4vu+Kv3ltndZUyghk8daCbzw58MtIA6w+Zjkdtg43qxtVj6M6SvbQnaQds5b4dsUVybV5HImLEZqsdr9RF1ZTgEWygf1zFfSjSqhb5qshHqBH08CtVeKVnt/FCEWtZ4nliskoJHlXWkfV7ewbsttqQmFTRhQAffq32h+/s8MxVVS4jKqatCjsIXNvyE9QbPl+khYUvVcM9CmRQHF4yjnq+KrgK2JazEcPSJBg4LioaR5IWoRiG15cHW8i9BNA5FbLEKntcQhprs2PqMyZYKr+BYkHPyzMyRmVY+0jkwXiJD47sB4xnqTpR6nCYePPgFvsc9xm+JFOiEWHtBpJBkgBEExmrl6dBZL4kjvPV9YdpHf2OgmgXdQ2yOyMYVkyR4t3n4nwP/lJVmwAXXj8iHCtjQagMWkeG8c2KRr0il6BriIcfFcYKch7777TXi6mjXXDmDy3kIpXbvgTDh52HEhPG66JbTvGG59QOvb6dMVaobIdzWfI25qWW/wMLID1gC9e8stziOO1p0QwGamqE0de1UHVbQzoSCe5UuZy6lg8kMN71gGqH1sBEbCHEBo0QlafFO7MDwL5fPpzSBTaW+WLfhZtbsicIZGpZkEJ5p34Dqgv+a+B8mtvTzvV4LuSqTGVA/tyWJQEAje1OXnzd1J4MlNdAiWuAkfeNvt832aXSCkyunL+l7+JHPlza2Wn0vZz8heSRNTHEgiNXqF0nhhzeVWOGNiYXxakQBY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(186003)(26005)(31686004)(83380400001)(508600001)(5660300002)(31696002)(2616005)(8676002)(316002)(16576012)(53546011)(956004)(38100700002)(2906002)(8936002)(86362001)(66476007)(66556008)(66946007)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SUkwYTR2V1dzaVVKSGxYUjNnb2N2L2pjOFBkVGZBTm5kekI1QXk3amRpdVds?=
 =?utf-8?B?cUczRXRsbTFjU3FLSkFoZzRjb3BpVTZxc0hOTkpJamh4QWQxU2lXaXBIdklt?=
 =?utf-8?B?RHpFcUJPVFB6MTlRdTdEaEgwTlluOWJ2VzNlTmQ4dzN4d0E1azdNUWNGa0FR?=
 =?utf-8?B?S1p6ZDRBRnJaeE8wb09qOEdrRU0yejZsZ3F1Qk9NRmJHeDZHa0dQTUREUHZ5?=
 =?utf-8?B?d3NoenVGazlmOCtGdmlSQjkxQVRWVzhLVmdzT1VFR1lna01rWmM4bHBDQkI4?=
 =?utf-8?B?YTI4YXQyU1d0QU5qcFNRUC9peEwycXFXc2lCc0kyWnRiL294ankwbHlmdERM?=
 =?utf-8?B?VGt4clFIVWJFbzdEVG1wLytLbVg3N21OamZrK3l0TnVWNmJuUWpXajgyY052?=
 =?utf-8?B?TTFsM28xUTVVcVNJQ1N4bW4xNWswSHczYnBJenJaSC9EaWViS0gwQTFaQUd0?=
 =?utf-8?B?L0I3Z3FyaW9Wemh5UDJncXp6N01sZ2FmbnlnRmRyeVZGUi9uS2lUenJMMHVj?=
 =?utf-8?B?M1RPdSt3ZFFSZDhyZFpIemNpR3Fib04xaGwyTnZDeHNpZWtuYSt0L2FidGJH?=
 =?utf-8?B?NTFZSGZqSTd2c2F6Snl6eGZjVHJGYVc5b3E1aHlsbWFmZkhsRHJRV0N2VTNG?=
 =?utf-8?B?OEhHeEJJc1BSanZzVE9KK3k0WUZkMGhiNzFFRUhYclE3SzNucHFBN2dhalBX?=
 =?utf-8?B?eWpSOC9EZkFTOHp0YVVnMHU2RXQ5cjhRZlNqMXkxUk5DeUNXeHRVVWNWYTRn?=
 =?utf-8?B?c1lFMDBLdTBIU29xSDhBMDhjZ05tUUxpKzRoSkc0Rm85bVAxRlZKVk5SaS84?=
 =?utf-8?B?NWlSL083YnJCdHRMTFRQcjlNZ0pSQ1d6TE11UnFRMTBIc1hYTlEzRENzbWRw?=
 =?utf-8?B?YldIaTFFOFNmaWYrdHczbGUwYWNxN2s5dWkwOGFvUHcvV1Q5amYycG9FYVhm?=
 =?utf-8?B?MHVmRWhaTW9nWDIyNDNKbUgvc1AxekoyZFlKL1lleWxtR1poQVRkQlg0UGdN?=
 =?utf-8?B?aXlXVDlQa0FtaU1vR2E5akZ1NFJidytyYzNMcGJlRjRrNFFFVDhRMkZpTVdZ?=
 =?utf-8?B?cE0vaVR6aW1SblJxczNZSVJJKzdZc1dDNHphWU9qYkZEVnpiakwrekUvS0Ir?=
 =?utf-8?B?MmpzNmJQRmJ2alJDTFoxbFFESk9admhVdTNlM1gyMXE4VFlKdC9xM0dUZDJu?=
 =?utf-8?B?MHp3bVlXWngrOXNoWm4veXJsVHBnN0UzM1dzSEZKZ0E2aUppZ0krdy85WFRn?=
 =?utf-8?B?dk9oTEhYeC9rbzRYQmRUZ2lRQ3ZSZmczOTExVFdwOVF5NThYMVovaXJmS1RQ?=
 =?utf-8?B?M1FSSVA5TVZjTHNiaEtmQkpMRCtrSTZSZm0wWWIxWkY3cU00V3NDSkRxQXBT?=
 =?utf-8?B?US9FWjBlSXhPTmM5cFZlN3crb01WMXBNMnNrRTNxSkJNOEpUTFVrTlYwYXNR?=
 =?utf-8?B?K29PdzZqVFRJUmc5VzVlSE1QUjFSN1B6ZU0wbVZtZHZlY0NSLzZ2bGc3UVE0?=
 =?utf-8?B?RytBY0FJYndkTmtZOHczUGlScDN0RmdvajNMMTNjb3JSZldtdTZ3SC9jSE5H?=
 =?utf-8?B?U2N1c082Nk51QU9PQ1dpeER1TGNhNlN0NW40alRRalhKV0NVdCs4Qk0vUUJt?=
 =?utf-8?B?SkszNDZaclZVdFAwcTJ0bG5FR2o4aThQcTlmUFgzNWdUb0l4TWQrRHUxcWxh?=
 =?utf-8?B?SkZtL1hqeTkrSFVia3hyZzhPMDNzSWRnaU9wZXdYQWpGc3AvZ1lYaE9DSEhk?=
 =?utf-8?Q?0dW/9BWdgY994X0JE4D8KG2vy4e+Dp2cWqGwaqA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bd57c04-b198-44a4-031d-08d9882a5771
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 18:02:48.8412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jPrOcMlmjCBH9sIz9DSCa8gvy7XJEvxpOtlgInIQDhOrVTPGPR/lRuB3gNEM31lbgZnqybPE1bBJeGJHX9We2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7831
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/29/21 7:04 PM, Mike Christie wrote:
> We can race where target_handle_task_attr has put the cmd on the
> delayed_cmd_list. Then target_restart_delayed_cmds has removed it and
> set CMD_T_SENT, but then target_execute_cmd now clears that bit.
> 
> This patch moves the clearing to before we've put the cmd on the list.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_transport.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 14c6f2bb1b01..e02173a4b7bc 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2200,6 +2200,10 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
>  	if (atomic_read(&dev->dev_ordered_sync) == 0)
>  		return false;
>  
> +	spin_lock_irq(&cmd->t_state_lock);
> +	cmd->transport_state &= ~CMD_T_SENT;
> +	spin_unlock_irq(&cmd->t_state_lock);
> +
>  	spin_lock(&dev->delayed_cmd_lock);
>  	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
>  	spin_unlock(&dev->delayed_cmd_lock);
> @@ -2228,12 +2232,8 @@ void target_execute_cmd(struct se_cmd *cmd)
>  	if (target_write_prot_action(cmd))
>  		return;
>  
> -	if (target_handle_task_attr(cmd)) {
> -		spin_lock_irq(&cmd->t_state_lock);
> -		cmd->transport_state &= ~CMD_T_SENT;
> -		spin_unlock_irq(&cmd->t_state_lock);
> +	if (target_handle_task_attr(cmd))
>  		return;
> -	}
>  
>  	__target_execute_cmd(cmd, true);
>  }
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

