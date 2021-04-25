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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63BEC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 23:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F2E961103
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 23:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhDYX4Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 19:56:24 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:54383 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231330AbhDYX4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 19:56:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619394942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=99hRW+A3D3e88Iz5Jc9ni0hVtd/eYO3mFh3+WOp7U8c=;
        b=P85557YZc7MqlOyboZzdjxi2NoxuAET1wzDq+KnRhFIJW9GzigF/D3li32N9lSdgXwl6rS
        huQm7rGjHjwwxVaZBTzvlT7SkAktMca3uITNtG5DN60ItIMYJcTsDTxJPhGL+USQoTflWX
        f0VPcDLKeqTARL6kdT0S+Pd4hZAx6xc=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2052.outbound.protection.outlook.com [104.47.8.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-p2Z-y0jeMBegTa2dI7WLVw-1; Mon, 26 Apr 2021 01:55:40 +0200
X-MC-Unique: p2Z-y0jeMBegTa2dI7WLVw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv0Af282fLfk+wLgpdBZmD41dS27Qi641PqMQzz7l/GjXKy1fyZa2gwNrH0LQJAt1FOi8Gug/ZK34D54f4A2fOJgiNATTf2fKWYcMIX7HXGUzWtpfGD4tFYB1a2R2EXKEA2mVSG4YiAAL2AB+mwBqYi8A8n6n9cI2VLweR9YSmsjrgi0sTIqV6d/416yH5Hl1Y9BUVoGjHcD1ArdlwIEVycWdr47WokpsCyy6D/aSwF4dL1CJl/cI3CUQ3FFHJju7fQ/NMCc7l7oBbUI2vbUcVs+w8d7rLFJLq+Rei4LK3WGS9q9zhhTm22n5ah1oXukFB4DZ2tA6kihoApizQPo8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=99hRW+A3D3e88Iz5Jc9ni0hVtd/eYO3mFh3+WOp7U8c=;
 b=Ux/tfGP6w9t1uUSvLcI75ftEFJuwqJD82vIatE9SXmCv/PwOyXkFsBSwzisZ2gIkc6pdizM6jy/1knjRz2YvzN1knzE9QxBd83mUdGA4Dgeh3vp1de/kHz+e6ZQH8VuVRF5w00da9OR1p0qdkUb29lTRqx3iWVWWMceqm4nU0EVM9VmKVaMfO+hOXCC3dnM6MrU9BuM+r1ojSsIFGO098dySgWTXk60BR3Evcd2MOKgOnSCUAnjQ5T3IrRMhBGzps0G0OaNX+Uhh2vBaPDxsFjc2UydvUpkNbU6KIvc1/o2mGAUoJsByqxF9IZBwEtYCVGDGtDrH+M28+H/rYcnIOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5334.eurprd04.prod.outlook.com (2603:10a6:209:50::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Sun, 25 Apr
 2021 23:55:39 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Sun, 25 Apr 2021
 23:55:39 +0000
Subject: Re: [PATCH v4 05/17] scsi: iscsi: wait on cmds before freeing conn
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424220603.123703-1-michael.christie@oracle.com>
 <20210424220603.123703-6-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <bae5f2c6-42c9-4cd8-166e-6b848389a555@suse.com>
Date:   Sun, 25 Apr 2021 16:55:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210424220603.123703-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR1P264CA0023.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:19f::10) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR1P264CA0023.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:19f::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sun, 25 Apr 2021 23:55:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8be1fdfc-810b-4dc8-5f28-08d90845a091
X-MS-TrafficTypeDiagnostic: AM6PR04MB5334:
X-Microsoft-Antispam-PRVS: <AM6PR04MB533406D8575F96EE0D2FAC70DA439@AM6PR04MB5334.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YJNt8psEjiteyD8/dKLBK088y9tAuP69Qab9ySXseX20lySYQ8S5UNg4cyD8nK2TvNSLkrIIZ1c2ddvL2e6hFfEJHGqvRNWF/vJPniRqXh1RSEjhonqX+NaBYqqTEaIurrWmLq8IaEiPS+xxjXxL1L5YAShNMfTSuNGK/CX9SdU0Tw0mLCExwQVsi2UbOYu9HHuRsanoFfq1vn4bDD+rzAlET9459rQ6hHbI8jqHzbZewBOHPFcEhrrO5K+sHUsbXfWNjKve8KKFAbJk5IBxWSOhIZqQLhIhhLKVUvoHBRNR99eMykynd3lzLCmQZ4s16CxPu3ypWDDHipbm1TUMC2TtpxGzLL3yfF5HKfPgyzcDVDHOl5cfDuDrfndNdICqJlLcxTW9iCD8GS6mcqWhXkPSiRD86VUObnddCxZ9R+XYYfCC3qcqMkLTYScH8vDORoCQxbJ+bI/QCMChL81Um589ZPmDZlQ8bg9WwZ7fWeReAGtAWzwfn/N1i0bMJqlYFJXLWGvumNm3MtDM2j2Jp5Q5XYowi8wISQik8kO0iWIgXCIAu9qPTVi9tCv+tm6oj9Adli+T4QUuddxKL/C8fmrqZy1CrCCEntdVY4CxRup4+2O2BP922owZcZ1r75by1jRcno3Yo2MWxKTq7+Y2tqRsfoHg23tvwAjAWPE/vz5K8oU4q9o8h6itAPCXAbrw4jEmGD35kOaZC9AgqE1T+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39850400004)(346002)(136003)(396003)(316002)(8936002)(86362001)(8676002)(16576012)(31696002)(83380400001)(478600001)(6486002)(6666004)(186003)(16526019)(26005)(53546011)(66946007)(38350700002)(38100700002)(66476007)(36756003)(66556008)(31686004)(5660300002)(2616005)(956004)(52116002)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?THd4MDRJSytpNVhjWHZIdi9LZ3BrY284SnZkY1U3MXl5dXhtZUR6S0NTUkgw?=
 =?utf-8?B?OEF1SnBmR1BYb0VTUFRqVVRJaGtjbEQxNUd2QU9kSGZrQzdYZjdQWlMvRnV1?=
 =?utf-8?B?bkNCdlV2aDh5Sm9TN3FPZjJvSllkMGpqWXFLZGVteGw1L3BqSUFISFBadFF3?=
 =?utf-8?B?OThzd1hYOU5TclgwWm1DNGJXRGFSK0ZhV21XVmd0c1F4a1lrL285YzdUaUlK?=
 =?utf-8?B?ZjRPbGQ0TFdSV1lOUnB1SllRUDVGMzZwLzhaT1BLbUY3TEpWYXplVSt2dmpJ?=
 =?utf-8?B?ZWFoaTdJMFpmdlpIOTgzRE1Sc05wZjRxaG5ZVzhuK3p5TUswNVM1dlVXc1cx?=
 =?utf-8?B?a0YvZ2ZqbHVsM2IrbEc2cWZDa1dPU0lDdHNoWUZEWWZPdStzMTdsd1pBOVk3?=
 =?utf-8?B?NE9oeHNjbisycVZEV1E5ZjV2UVFqTXc3aWVpNngvOTFWWWowY3Vwclg0TE1p?=
 =?utf-8?B?SjVLNkJFaXpsN0RKeWZvY1pyNmN5b1A0NmdLZXc0eEQ2eEZreW5VSytKem82?=
 =?utf-8?B?WXdNdjZ2dW9FdkxtN0JKVmtWMHF3WDZYNWlscWRFZ0xBNjlkVTNCWmlpcENE?=
 =?utf-8?B?aFhUT2l2dW00VFhURDRwUVlwUGxLSTVER3dwZHVIdkxtUWRJcm9aU3FsdDFh?=
 =?utf-8?B?bW05bEY3c21tZnFUZGFhdFMzNTUzOXRWRWVlU0Z3NTA0SG1jWGpkdmZwMkFx?=
 =?utf-8?B?SVp2TFRsU1hKdEJhUUY2MnpQQ2t4UlptT0xDUnFlaUJzMUxwWVpqS3g4RS85?=
 =?utf-8?B?UUVOM0hJWlUvRW5vblJRZTVtcFRmMGl4QjhVTnltbzVlT3NjYXBvNXltQndU?=
 =?utf-8?B?OUx5K0xvVU03dnF2ZWVmY05TY1RPaWVWL243VkMyUUdpQTRMcWpXOWR0aGp1?=
 =?utf-8?B?UmNHVXFxSzRmS2tLUkgyMTMwUitDRDVGT2RoVmRsc0JMRnZVb3JrQ3B5UDZm?=
 =?utf-8?B?MkRxOStwR2JDYmVOV29sUnlQVXppMW5JVUY3V1orODQ2cXFOaTlSQjVXMmNI?=
 =?utf-8?B?Ni82Z0EvMXlpT2JhQms2WU1jWFNTUjZwM2xwMW9sOHFMTDZWd2xpNU45RmRo?=
 =?utf-8?B?YXFDSVhWY0JvaFFTQTh4QnBSUFdhRmFFWVBjUUdCSkNKOU9kQ1JTYlpiSktk?=
 =?utf-8?B?VzhXSFlldjBiQW10MStOZHVvNTZIWUMrREpGQnIwVFZtRlF3TUVCblgzb3lH?=
 =?utf-8?B?Sk5jS20rSXEybHVISHRtK0dHNFZqTVZ5eUJCdVBlTDNPTUtVVmVDTUltNnR1?=
 =?utf-8?B?MzA4VlJPbmZHUnF6ZnpDeCtYZnZyZVBlRW5BMlR6Z1pWQUZJc0NMUmI4YlFM?=
 =?utf-8?B?bFBHR2Q0bm93UnFVTHZGQXl1UGdNdFJ6ck5UTXRUTEIxL1gyMTA3ZUc1enZz?=
 =?utf-8?B?YzVsWlVvdCswZjlVdmliaDBBQWFSTkFubDlDMHJHSnFkTkdSVjhRRWNxQkVw?=
 =?utf-8?B?RGFMejBTdVBiN2NwQ1QrTjZCQkJZUkVTRktvWDJ6Kzl0NlhCUk5TVnZ6dDls?=
 =?utf-8?B?TmF3V3FKK0Nhbjg2N3M0bGNrb01tcjVzVUpFZzgzR280YjcvOWZoZGNEUnA0?=
 =?utf-8?B?NE5DZVh5YWo5K1FNRmVRWDM4RnRYN29CYjkvRzZmZ0UxQjZneG4wYUlTeGFq?=
 =?utf-8?B?NEdNKzJ6SVJPS3BNMU1HbllKTm1JdTJyeHpwOVZkeHNLVi9lUmtOMkRTVVNm?=
 =?utf-8?B?cy9qRUVSdXhGQm54aXZKSHpRb1hUL044bVUralVDL0Z1SlFNZGhWM1ZSek5k?=
 =?utf-8?Q?Nsz6HssA6EsM8QDCzU9MKA7TGE9FYukZ+fIVAC+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be1fdfc-810b-4dc8-5f28-08d90845a091
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2021 23:55:39.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LkAD6OdSLFlQxq3f1hwQ8DI+QXQ4cTIwK1dmnx7hhHl2+/7421Idscou7VRrta/tby8kD7tJ5DQuAIryXX8PZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5334
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:05 PM, Mike Christie wrote:
> If we haven't done an unbind target call, we can race during conn
> destruction where iscsi_conn_teardown wakes up the eh/abort thread and its
> still accessing a task while iscsi_conn_teardown is freeing the conn. This
> patch has us wait for all threads to drop their refs to outstanding tasks
> during conn destruction.
> 
> There is also an issue where we could be accessing the conn directly via
> fields like conn->ehwait in the eh callbacks. The next patch will fix
> those.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 0f2b5f8718ca..e340a67c6764 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3124,6 +3124,24 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_conn_setup);
>  
> +static bool iscsi_session_has_tasks(struct iscsi_session *session)
> +{
> +	struct iscsi_task *task;
> +	int i;
> +
> +	spin_lock_bh(&session->back_lock);
> +	for (i = 0; i < session->cmds_max; i++) {
> +		task = session->cmds[i];
> +
> +		if (task->sc) {
> +			spin_unlock_bh(&session->back_lock);
> +			return true;
> +		}
> +	}
> +	spin_unlock_bh(&session->back_lock);
> +	return false;
> +}
> +
>  /**
>   * iscsi_conn_teardown - teardown iscsi connection
>   * @cls_conn: iscsi class connection
> @@ -3148,7 +3166,17 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  		session->state = ISCSI_STATE_TERMINATE;
>  		wake_up(&conn->ehwait);
>  	}
> +
>  	spin_unlock_bh(&session->frwd_lock);
> +	mutex_unlock(&session->eh_mutex);
> +	/*
> +	 * If the caller didn't do a target unbind we could be exiting a
> +	 * scsi-ml entry point that had a task ref. Wait on them here.
> +	 */
> +	while (iscsi_session_has_tasks(session))
> +		msleep(50);
> +
> +	mutex_lock(&session->eh_mutex);
>  
>  	/* flush queued up work because we free the connection below */
>  	iscsi_suspend_tx(conn);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

