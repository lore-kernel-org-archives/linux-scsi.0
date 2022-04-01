Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7744C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 17:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236126AbiDARPd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 13:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241868AbiDARPb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 13:15:31 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7AE654A6
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 10:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648833217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uASKUxDJGF5RLHb5nJwYVkNiOeYBBXPLKAKMztduzBM=;
        b=SbohKucxOdMioTiGF0rk1Q8mVvzCorpPsHrB+/XtJwKkwsumLewd6IDxMQrapCtg3Bt3Xa
        cVklS+xQVXLixMf7Ka+vTU88xvR1Ef+sR4qw2s6HBQMsRomoW4O0f5Fz7gKlAfMOqnQgeb
        FtedoG8oBXRmBoswfctvVFY1iRp6HjE=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2051.outbound.protection.outlook.com [104.47.9.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-23-W4dVsUplNAuyI707gNRogQ-1; Fri, 01 Apr 2022 19:13:36 +0200
X-MC-Unique: W4dVsUplNAuyI707gNRogQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CF/onz0/6rCl1j9UMDw+e+0go+OwojV3l32sSwfe7+Kv6sF/ALoT41Mp52+Q099WBlWnKBhZpCwREMqVJhG92ZD8tXIR8Z0wL03nEmSoJ5iYL8rBMH9qZVZYJhEKWr8EJZnK90pmIzGNLuGgUGgRDZh5+yUKIu7ZhjXueH8qBg5BowQ1hfHA7dcGT+eJuB0fDaOeq2h/4Go1gv+0pEmeRaj0XtWlW2T+SaZrSow2Ll03z6FD/ZXuZ1jdNc1MHlivAyQB8soZSC5AgmOjY2xuw1aJDlkji9TdkuiQsV2dgtkDDKQ/x0onJuQ1ov7fFOvGgmnxTuyLgjZVDSxBOFrGEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uASKUxDJGF5RLHb5nJwYVkNiOeYBBXPLKAKMztduzBM=;
 b=SBD7Qo8UtziWNNfUS9QnMKdowXaWhRi1AVQjhZD4BZFdCko1L60KA46xzk7VeZT2/LwIpsh6kEsQqzIkI94ajWUvtalV7ojTY7gR3W1VB7RhHYDpGwas958ybjTaU9VNjN2cAFqHINRRcfVnlEq4/SDPuJvjLDMMbR6eqekPgwACO2IRX6cn6whjEvd1qHnH/S7xzZgpoSnpyGtNBTGX7k5wfEh+sGMI7nx/qpMvD37e6zb/fbRYWqfVAeeYgaQFWj6eIMqv5h8haqk5LUTyPS1BW2gvoQjGsdMyswTdF5CneFtYnD+cG7lClNZMmb/jCd4tVII2QLgbqjMSUVbGjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by DBAPR04MB7447.eurprd04.prod.outlook.com (2603:10a6:10:1b2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.25; Fri, 1 Apr
 2022 17:13:34 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::dc9:d46b:1a6d:2d44]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::dc9:d46b:1a6d:2d44%7]) with mapi id 15.20.5123.021; Fri, 1 Apr 2022
 17:13:34 +0000
Message-ID: <f3578cee-83a6-fe90-4268-8ae6d564e47b@suse.com>
Date:   Fri, 1 Apr 2022 10:13:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH V3 04/15] scsi: iscsi: Fix nop handling during conn
 recovery
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220329180326.5586-1-michael.christie@oracle.com>
 <20220329180326.5586-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220329180326.5586-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0568.eurprd06.prod.outlook.com
 (2603:10a6:20b:485::30) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a61bf233-083a-4916-3780-08da1402f3c9
X-MS-TrafficTypeDiagnostic: DBAPR04MB7447:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB7447319440BCB35AC5CCFCCEDAE09@DBAPR04MB7447.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bGlFXeUGYRKi44N47YFoH2WDFpV+zZH06xweSAmB3Y1YmVFMlj56u3nA1UK43IbM5SCSLgiVBbXyjTVwviFDfOLMAFvAziQvYQOzInIrOPRceL0f+//vU0WbmvxEpxrqlKbvA8PBnj3M3Q4LqgKNkz2hgpAAZKx2DlevxqPBxUpZu3FgYyFsmxBsMnACWumY3Me5XvcnMWeLwk5ohlJxE+NT5arLCy+ujEbJ48mpnirLs1x4ccGMFuZjWmfMxeBossqa+PYUfI2lC9Da4NFAX/rqpBdLKZ3vxh2OeKEaZFUPTgl5b1K4QDZ4hweELyiYCPtlvzLAVTe4M1kvvhFYA+NDGHRmegrxnnSKNpiD563OUWoEPdex+py1oMsdtsRtTlZkGmpLg7AZ35vFJEcmrwosR3fY1hOcxRXBzxZza+gKSaP3AiIFVmssSi/pVHB0Log8ND5E3EcVwuHK4GUYv4RhMJ6IxJpqnAn9mB8/Q6Tn8TWxhhtP0w4DLVY3S0ZiyOKRbM7W9nXlNu0tiSqbfCLMgauvgnX/YKrFrtyKzrNjrKzbTrpcP0PDPrdh3I1JcRrxKPoHMLZ1OaAsmQu0s7k6EZOWDmhgQy9gjywUBINIdDFxgavkM+OsfPZDO16GJybbpEIGPUgUnWyULCiwoXyfJWlNaiXkohPuN+MQ96dPk1cxUBDKw/0f8hzbwLDPX3kJfNcBRfazMUs3E8aZrhRjLYGEvKUUjh/RCmcywgE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(38100700002)(6486002)(316002)(2616005)(186003)(26005)(2906002)(86362001)(66556008)(5660300002)(8676002)(83380400001)(8936002)(6506007)(53546011)(6666004)(31696002)(66946007)(36756003)(66476007)(31686004)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TjVoNVFIenEyKzlYaG1DL0xQNnFvaTViMS9Ic24xblZCMG1rbitSZ3ZiNGdk?=
 =?utf-8?B?aUpKNmNrOWhIRnlQcElRVTNZOGsvT01FR2F6REo2RjVXcFpYWSs3QVkyaHc5?=
 =?utf-8?B?ai8rOXlyVW1UVHcyeTNQZzNDWVg3ZThySEg0eTZhOWNweGtocGNjVXNBNHRv?=
 =?utf-8?B?dDZFaVA1YWNlT2trUlRMQUxHU2ZMZHlnc0lJTW9kL0ovYUF0K0lFVWF3M3Fl?=
 =?utf-8?B?WW1HVWdKaG8vMm9aSkNlNWI4YTdjNEV5OXVnT0pmcFRpcGw1QVhsK25IclB2?=
 =?utf-8?B?QWZQRTVvNXZvcWwyRlVmUHFsWXlPWnBEekJaWndrcGZrTENlUVdPZXJQQUdG?=
 =?utf-8?B?aHRPNmxwYm84RzZBRGdJaEJoV3VKQUtxU25GWEppSHZzajdVSEpETmxFNkJo?=
 =?utf-8?B?Tnd4SFRmVFhHVHpadWY1STQxazhiMmpCd0o3b215V01ySzZGbUhSUGtINmJF?=
 =?utf-8?B?UEkzbHFNblRPWEhSREE1YjFmMFJUUlNPYjJjYjBlQkl6c2xlS0ZUMXZWUS85?=
 =?utf-8?B?RkhveXBMZ3p6RHVCNUo2cnFwWUx2Znd3bmZGNkJ5N3dWSzhmTTdOelpONDU5?=
 =?utf-8?B?Z3BXSnlFUVo5bVl6RnYxMzBYTU92MFYwU0pNQlZpOFdyWWtBL3lXV1piM1l1?=
 =?utf-8?B?V1lORlJSVlg4a3pLOUt2TjNDbitBUCsxbjhPTjdSSlBZVlBMK3Q2NnNCTkRj?=
 =?utf-8?B?Zk0wT2s3Yjd1R2lSemVuQnlYZGtNb2V2WnNUTUd1OUZoUHdqYVZYVUNac09Y?=
 =?utf-8?B?WHhwWFBuRUg2M1lpZ1lvTFhsN3EwWm0vYjg0U0hMU2RvWi95TDhTaGVXM0R3?=
 =?utf-8?B?OWxoV0FmZTlrUTBpNWQ0MWpGV2tKTmcvQXk0N2RCcHV3VFczZTB6NldvWVRw?=
 =?utf-8?B?WXpxd1lVOVJkNzE4R0c4QXg2K1NrdUlRU3hQai9CV2NpMzd2WTNtRTREZGFH?=
 =?utf-8?B?S0pCdVkwT0ZFSEFyczhmaEpqZ3IrajRNS0UwS0NmWkVIWkpreHdBeDE4RnJs?=
 =?utf-8?B?dWpSUk8xSEtIcnJCeTBEY0FWNUZCV3c1dUowTG9oV2hVSjZVdzU2ZXJMVTFD?=
 =?utf-8?B?UnJTNmk4S0h0UHkxVm5UZVN0YU9RaFhZTXNuSW0yUFMvcTFHWnZvbFdLRm01?=
 =?utf-8?B?aXNIcTR0cGJEQit3YkFDSThrR3dhN2cvaXVMUmNZUzVJL0VFSWNFcWx4OS80?=
 =?utf-8?B?aCsrSG50U2RNSlVyMHZYSUpFclZZa0E1Nk5DQTdWa2hXUUdyMW41VnErZm1L?=
 =?utf-8?B?NUpVTVpObUFVN0s0VDI4bzUvbG1XYWNIby8zTDc4VFAxckI0aE5CNU1UV1ZI?=
 =?utf-8?B?ajl1TDBZbVhxM2tHTWlScVVRODJQWkJxZ01VYmNKbXRtbGtuTmRiejZ1OUQ2?=
 =?utf-8?B?dmcvYmVEcWNKd3NEQURJVGZGOXdmQlZVdFU5OTk0d2ZXSjJOTm1ObmVCeVRx?=
 =?utf-8?B?R1dSNzNsem1FVVhzdHA3WVFpR0F6ZEpRbE1jczBPampra0UrcFI2eFo2STBJ?=
 =?utf-8?B?cHFxV1BpNUluOXh3UkQwVG0xNHpDL2t6Tmdsa1BqdXFPYmY3dVpwNGNMdHJE?=
 =?utf-8?B?RE9HZS8xeVRDR1l3MjEwdE5JNjZ0Lys3eStMN3RlcityQnVYZER1eFFsMWJT?=
 =?utf-8?B?V2c4NkpXYzNieExoNTQ1eWE2UjZ5d21VaGdQSHkzYkxiT21hZ3YrODJhd3di?=
 =?utf-8?B?NFU1SVpkbHM3eDE3NkFMRCs3SlRuaUlDdUpHZkhNcXZDT0ViOHIxRmdtdWJk?=
 =?utf-8?B?eFN2ME5NNTFLbFltbzdBKzZuOE5FdGVpWk9QY2lsSEpNbkE5ZGVjdC9DTW13?=
 =?utf-8?B?dG05cHFtTW9xSVpjak9RajVZWVBRY1VSUGVNMXRHZ0tuOThhKzNyUFFoYytw?=
 =?utf-8?B?eFZnbEttZGF2UTQzUlBoVHFQZHVrbUJNejduZ0dGWTU0a1BnN1BhMWlwLzdz?=
 =?utf-8?B?R21YbTJKTVA5NjA1eU83VHptR2l0M1JVMDYyQllySXpDdG5tMGhDOG9KekJz?=
 =?utf-8?B?NmVHTUE5K1Q4b1RxMWFGTzVxR2hUQzREdCtwU2JEeXY0bU80U3ByVnNLbUdO?=
 =?utf-8?B?NjRGV1Zsdjc5RFZJdVZPMkt2aDVGRVlhdktxOHpRRXNDNEpJMThBVFlicXcr?=
 =?utf-8?B?TnkxNTBGTkMyTCtTOGppZjNqWExtYmoxZjhDTll3WUtNMUJuVUN2Q210ZWU1?=
 =?utf-8?B?RzY3VmgzMHptb0VWeTRZNDJiUUd0cnprRjI4USthaGI0WGJuV3hEc2tLdmx1?=
 =?utf-8?B?U2pPdlZ6LzllTmk5Y3hFcVBDTk1BMjllWFpMUENUSTNuN3U1U0hmSUxCUXNT?=
 =?utf-8?B?SEMyUXR4SmROOWhXY3R0ZzZ2bks2dWxpWUtMNXlJUjc3enB3SmRIQT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a61bf233-083a-4916-3780-08da1402f3c9
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 17:13:34.0449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HROsZwi4yPjzhJr+8HUipMaWfvhd20PDsBGolt7qVxjc7M6VgUflo7QDBtDQaiFXMO65rgzE/0b3w8OM2dUEDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7447
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/22 11:03, Mike Christie wrote:
> If a offload driver doesn't use the xmit workqueue, then when we are
> doing ep_disconnect libiscsi can still inject PDUs to the driver. This
> adds a check for if the connection is bound before trying to inject PDUs.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 7 ++++++-
>   include/scsi/libiscsi.h | 2 +-
>   2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 5e7bd5a3b430..0bf8cf8585bb 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -678,7 +678,8 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   	struct iscsi_task *task;
>   	itt_t itt;
>   
> -	if (session->state == ISCSI_STATE_TERMINATE)
> +	if (session->state == ISCSI_STATE_TERMINATE ||
> +	    !test_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags))
>   		return NULL;
>   
>   	if (opcode == ISCSI_OP_LOGIN || opcode == ISCSI_OP_TEXT) {
> @@ -2214,6 +2215,8 @@ void iscsi_conn_unbind(struct iscsi_cls_conn *cls_conn, bool is_active)
>   	iscsi_suspend_tx(conn);
>   
>   	spin_lock_bh(&session->frwd_lock);
> +	clear_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
> +
>   	if (!is_active) {
>   		/*
>   		 * if logout timed out before userspace could even send a PDU
> @@ -3318,6 +3321,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
>   	spin_lock_bh(&session->frwd_lock);
>   	if (is_leading)
>   		session->leadconn = conn;
> +
> +	set_bit(ISCSI_CONN_FLAG_BOUND, &conn->flags);
>   	spin_unlock_bh(&session->frwd_lock);
>   
>   	/*
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 84086c240228..d0a24779c52d 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -56,7 +56,7 @@ enum {
>   /* Connection flags */
>   #define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
>   #define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
> -
> +#define ISCSI_CONN_FLAG_BOUND		BIT(2)
>   
>   #define ISCSI_ITT_MASK			0x1fff
>   #define ISCSI_TOTAL_CMDS_MAX		4096

Reviewed-by: Lee Duncan <lduncan@suse.com>

