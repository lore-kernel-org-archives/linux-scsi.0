Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EFEC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58BAE600D4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhDVPDO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 11:03:14 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:45048 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234158AbhDVPDO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 11:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619103758;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MzEddlG4rcURtcVWAiwAlO3A7ll/qxHsfvlDtnPe0hw=;
        b=Poiw7k8X+Q44zf7ldAJpsNV1+hmWBONi60IPTO9deG7OrBbFHWmAHnPUBCE//pALinRyd4
        sTOx4g4AkVNXEMTqqFDQOmnacjfTn5gciIeCLm7Mpj6qUl2EMREB4OrGj0ZQRtPC87c+Ba
        uzdpl/fGNCqpVif9wYv2rEbxlAgzkq4=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2052.outbound.protection.outlook.com [104.47.4.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-21-cLtSlO7bP1i8ul9hxoth-g-1; Thu, 22 Apr 2021 17:02:36 +0200
X-MC-Unique: cLtSlO7bP1i8ul9hxoth-g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SnSxqSVWQwvJTLXsYRdLTDiaBXf2q3H55cnBxU8nla7Ss36ZtEMgW/2Ze0VFSlyevSR5QNUv3E28I2PMTiMCrl0bBbYm8tCHCzJG/MAQXgcpvhgjRw36p7z7hXlF5yG0ZOELjqPdfoGVbgwXkRAHnbVTyfIplD4mMVNcVXxNgi6P+9yktPdDswIqAJFQOOlKg3d+j3lakvKJxEa0S/g712QXCnswHukaqfTbAeNkGoveAsJfjDJg5rAjXMgHUyb7S5hqcZxdXq7kZXwgeXhVMG/Rg+hDp0ZJIFvOqucuhy3ggPfRmTWALwNrh7j1aKShuRml8ej+DK+fBwesn+Xm1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzEddlG4rcURtcVWAiwAlO3A7ll/qxHsfvlDtnPe0hw=;
 b=WoxLiGkwsaYYE6mR3Anu9nueatwokxPXxiV1Gz8uY/mct5R7hNObTyG2k5mTKsjOk1Zj9O7k1YKlb8A3uaJqQHOrwWf9W7RRLp8Zv+LeR6GSRVPu3plyiqL0blCMY/RCypJ26zYd4mUjss/xsMg4x8O5CtZ+D88JA+/WZ6VZF6ETXcOXZAJHiR+Ote5bwXm/5Om4BfBZapwcN/jevz96H+UGYMH2EMl1YB6OJ/+YGlcyxv/F84MR+218+GuZgUnY2IfTnTrMZa+irNIr0LG9O3hKedieWIB8F1D4MHGWsE2gCl8CSvasTx1r5rA8/c0TTY583b2TS0i/TXmVFpTsAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4885.eurprd04.prod.outlook.com (2603:10a6:20b:c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21; Thu, 22 Apr
 2021 15:02:35 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Thu, 22 Apr 2021
 15:02:35 +0000
Subject: Re: [PATCH v3 05/17] scsi: iscsi: wait on cmds before freeing conn
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-6-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <cbb23794-ad88-1581-20b8-e0a5898f43d9@suse.com>
Date:   Thu, 22 Apr 2021 08:02:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210416020440.259271-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22)
 To AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM3PR04CA0138.eurprd04.prod.outlook.com (2603:10a6:207::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Thu, 22 Apr 2021 15:02:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1709596d-30f1-40a8-4dfb-08d9059fa9a0
X-MS-TrafficTypeDiagnostic: AM6PR04MB4885:
X-Microsoft-Antispam-PRVS: <AM6PR04MB48853E307F4FE20A15E06031DA469@AM6PR04MB4885.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5tj7dyaF98DmP18cNIF9Jwv9AqElDZfwepCzUsbf/7M4xulaf61cAdOGQbdO+yf0iRJNE/mcAQWszXRqGSoQg6YQkohFvapshMAQKwDSzbXIzaheRm09LLgTWWlnEtL6wMN7+NC1pBFwlESgCDMJtu1q5e6c4iWrHW+NmiDHWzG9ah59sl+5eaOyNwNeSwqUQVTz3CBDYhbKKIVutrMx94pVmtm25flSOyksIze6paBC3LAo2Ff87oxFbujnlcIsC4tA3S0QTEZTXM5uOH4AlMsBS7v2YoHkQHEYJBcPYEWUKQC0h6J1JxqXB+ToQzSOliAb0XV1w5xj6DrrFRY5tEynOE57HGszCqIsdidBJDZnGV1DXGtIUMLzQa9ZHeKS0jhNfgqXw+wWZm2YNYu62/JjgR3KqrqV0+VW7iM55ICOC6uXpiTnY8IB75OPVRYBKmm+VcVRD+YJ1HVPAFiX2wrtCcQqxq32cD/jt2c1e2rF+XTMMf2faXeaB6ks9Aip/OrFQ8SMQb4OlYpfXnZVvO4Ex1lah9qW2VknIYV0gfg0MxYPL+OXAQtq4mixOEvc48H76xuOzcjHO5eN8XPVEYWxr1y9f4AHzujuIXsRSbvQFMVDmgnMlNvy3Ww1aoYc+OcvO12AnxLPf1lcCP24iM19b4VHnx1emly0MxP/6DrNvJWOqoQHLllVIRdc3n6o0CuYamttYX8pOHwWmLWUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(376002)(366004)(38350700002)(956004)(8936002)(16576012)(52116002)(8676002)(2616005)(31696002)(16526019)(26005)(186003)(2906002)(38100700002)(66476007)(83380400001)(66556008)(6666004)(6486002)(36756003)(5660300002)(66946007)(316002)(86362001)(31686004)(53546011)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVFZT0hvZmpSRHRUSXZPb2JiY2RzcVlYYlpidlhjMkZpditvODc0TWFKVTA3?=
 =?utf-8?B?aGFrSCtnM3M3Q1hOWmt2bnRQaUd1Nlo5Wkovd2dyS1NwOGVJQjBxbzViVENa?=
 =?utf-8?B?K0FManIyMHJSUU5TQ3FBbGVSU0U2WEwrVTAzOXM2Z3J5VXV0N3o3TWtUeVhT?=
 =?utf-8?B?UUVyZGgxNnVlcnRuVUdkUTFFYkpya2c0SytzZGZLSUcyYlliMnU2MVpZT0hD?=
 =?utf-8?B?cjg0YTVITzI1TDVQeG1YR1hyUExRbmFkRGMxY3YzaXZubmRmZG9CMXcvNmJC?=
 =?utf-8?B?QmIzaGJtRHlITjlyUUxaTVdIb0Jqc0ROUVNMbklRYWdjbTRWV0taYW91RGVQ?=
 =?utf-8?B?aldVbU0rMUErWWdRQWQ0SHBydnJrUGRMd2YrWjBEWFRWSkVSSDA2ampVUjIw?=
 =?utf-8?B?SkpXZHppOWwwWkhwSkxQMlBiRVFNT3F2aDd5Q015WU5wOXU4VEVOWWRvOVMr?=
 =?utf-8?B?SzNjSHQzMUhlbmY0WWRyT0NpdWV5SkhkREhCbG5KWmZ3cE9JZDhwdUlYeEFW?=
 =?utf-8?B?UDF6bXB1LzJCNlc5bWxNaGl4VGRRWGpCQnIwUnRpajhtTjIrTGxObldmR1JZ?=
 =?utf-8?B?bDRGamFubmx4Ri9VUHpBYXoyVDlqRmZHMkl6SGJPUmZ1aE9CWHBGOVBHOGs5?=
 =?utf-8?B?ZWlPUWNnNkVEeG9zV0ZYUTEyQVhtKzJJZ0k0NnVjcDl4Mk5ZTlpYM0ZWSklF?=
 =?utf-8?B?QmNRNVcybEMyWTRCVDVoMUU0SXJkTXlJZ2xDLzVxRTJwMzdtT3JZSHdraXk5?=
 =?utf-8?B?S3JoZC9WMkJKZ2ZPU3hSKzIwKzhQOC9keVUyT1R6aWRCNkJ3L2laSGlYelVh?=
 =?utf-8?B?UCthTE40MEozekQ1YkxFOG52UTlMcXc5NTNieUNRWUx5WE1YU1JrQjZtaWNs?=
 =?utf-8?B?NUlLNmdnd05lUTFXVmh5ZFlpbW5McW1KNjlWbERGLzNMdzUzV2dzZ081V0x3?=
 =?utf-8?B?dXVVbFBreXRNZDFZRGZ6TjVHM1lmaUd6UkRLZ1NvK092Z2NodnJQNUx1a0Jy?=
 =?utf-8?B?YlRsV0ZvK3dGTnBLREI4Y3RFS0FtRi9yRnVpV0xHWng2NUJKRC9uM01kZVBp?=
 =?utf-8?B?WVZvZFZ3RE9TNmdVWGVlVUNGUFFsSnQwUXBKQzBXK1hQWE9uRDI1b0RMWmhx?=
 =?utf-8?B?NWxXU3IwVTFuZjB6c25iRWptVWNubEc3ME5pcnhCYU1hSjJ4UEJJaGhtNzUz?=
 =?utf-8?B?OUE1aTNqUzBSclpLOWpiWUR4VGFrV2lwRkJRWHljM1BCMWdJT2d6c3FPZXFl?=
 =?utf-8?B?N3BhOEJNbkV5OVQvVWN2V29SYWRQcXhOYzhtR1QzM3NRWU9Qei9saGJVaTBs?=
 =?utf-8?B?U25nMnBhRndsMjFwa1IzWkErcVlLbXpSMHdta2I1RDVWeXZRd3F2aE0xd2dX?=
 =?utf-8?B?c1l0a2FSRS81c08xZEt2bHkvU1ZPak84QzNmK08zV2hUYkdqZGFnRmZCYlVB?=
 =?utf-8?B?MUJuUlp2NkhYZVU2REcvWE9CWklwbktvczVGRndzR1B1dzdMdzFMT09aQmlN?=
 =?utf-8?B?OHFhL2xvZFZjZ2FKS1FnTjdUK1R6UjU2SER0WDlZNGJudG1nU3NqYklxa096?=
 =?utf-8?B?WTRDTFpySzRLc1BUczYzTVIxa2locC85Und1aTlvMWU1N2YxOEpveGxEbUQ1?=
 =?utf-8?B?U2diU1dRSDJMWXJVM0RMYjVFRHdJYWxvTzVMbFk3V255dUdoaFkyTGNINWFI?=
 =?utf-8?B?elNaYmtrc01QaE1NbTdLUlNlQVZoZ2t1VWhHM0RKbG1PbUhKUG9pOCtLM0c2?=
 =?utf-8?Q?PZm1Kt4a0/eT+G3dcMHdll95LwOM9NzRlJA82Z/?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1709596d-30f1-40a8-4dfb-08d9059fa9a0
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 15:02:35.5938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IuO3gElxKHNKkcpy8fZpIKGor0kKj3tVPpr/R0Q0/vwhf9EM+TXSKKfq0VqWmX7QRvOnyZs7Y6HkPmVv5GvN3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4885
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 7:04 PM, Mike Christie wrote:
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
> index ce3898fdb10f..ce6d04035c64 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3120,6 +3120,24 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
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
> @@ -3144,7 +3162,17 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
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

Is there a limit on the amount of time this might spin?

> +
> +	mutex_lock(&session->eh_mutex);
>  
>  	/* flush queued up work because we free the connection below */
>  	iscsi_suspend_tx(conn);
> 

