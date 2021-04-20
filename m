Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC03CC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B4D7613C2
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 14:29:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhDTO3v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 10:29:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56376 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232462AbhDTO3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 10:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618928957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K3BSInHpJ06n1vOJ2iQ/avtpnGNO7W34ykpGuv/2Wxo=;
        b=Uhvz3KPTva9etfFeaN82Ip+k82gZM34zDCuIs6ypRN5heDAsy0xdSUiuHmYVAUALAuLdr9
        TThgM/aVHY8C/d15jiDa+fUbWoLp6Yq8Ji/Fcw2Oc3UdQstTQCh+1IqdOQmUfVgahR5tDY
        DfOb+4oBZ2saW49sHAWTRBcTEb23ngg=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2052.outbound.protection.outlook.com [104.47.8.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-26-9uJKYnqwOGqzsBLC_jnk7Q-1; Tue, 20 Apr 2021 16:29:15 +0200
X-MC-Unique: 9uJKYnqwOGqzsBLC_jnk7Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIsg1Z+YNKTFfb56BmRkxz8FIX5isuxAGPwjal+1OuWDSwGO6QV/+i3cXbdMsBghJ0h0JkWWY/8Cfj5P2ysZkWGTQP0WZ2mgKtRnhddk5n+4sjqJNb9rmBJfT8Lt9ruoda8D4fKdiBQVzsjwOpqk5K8D3s4ZQTCI5dM+rvW3en8W6lto1Ac0yjqafvWsV6cEn1PMs8XzYwecGXM7hM4WM/8Cj36V9jPkXtVz75ROqfQXokO6GzRE/v7SwsF3QVrzrUfek8kTb8vXwvHsxJuyS3In3KloeVu8BgvzrhRBra8nORwQdsM2AwwS6WL48Iyt8cCdVoaa6fp8IDLyNIm64A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3BSInHpJ06n1vOJ2iQ/avtpnGNO7W34ykpGuv/2Wxo=;
 b=UCQwebnVuxQogniQzrDKx5dQV+wCQOm+TYyi0/rDGuBZO+2gSCEwUUJVlu9XqL/0EEN8AlB8iFqDDjVN0iOIKuMtDmumI/AV//rbTcveiFOdXyiJuDMS18NOE83vQB/jKsaaTp1k/CeKBGuSKbZlVxhhfBw2DhtnLOwWjBEPMrLjU1kw6IJGcFjT2jjLKN8WZt0clsVqYdb/Rj73vhuzgu6nxP3qj/X6p5FrtH+aT9PrVKgFqwdXxSemySxEsWCXN2ujA4BqJT57b1tWsUsyVJfUZ/6jxqjvW2+5ptkOdXJrn/+jCWvbK+4bqU9eoCfvUSLGTaWtVaSajM6Qs6Ulow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM7PR04MB7190.eurprd04.prod.outlook.com (2603:10a6:20b:115::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Tue, 20 Apr
 2021 14:29:14 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Tue, 20 Apr 2021
 14:29:14 +0000
Subject: Re: [PATCH v3 04/17] scsi: iscsi: drop suspend calls from
 ep_disconnect
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <958c23cc-22d7-0728-f94e-1773e2d2b375@suse.com>
Date:   Tue, 20 Apr 2021 07:29:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210416020440.259271-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P193CA0004.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:50::9) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P193CA0004.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:50::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Tue, 20 Apr 2021 14:29:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74465f53-f928-43a2-4e52-08d90408ac2f
X-MS-TrafficTypeDiagnostic: AM7PR04MB7190:
X-Microsoft-Antispam-PRVS: <AM7PR04MB7190CBC334490B2C9A08A9A4DA489@AM7PR04MB7190.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:663;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gk3Ik5EPBzDf1KiQKHih/EjV5szBVjjuTWKQ0Rk5wFQZilpqWzErzAENIZetKuEQiZ9y6LU5PhdNUbBFSWVMetON5YladLptVbxVBscK9lsSoVhq0252ZWLc2J7k/Pj/TP4abLgdO5Q+7M8132ReXnXSwjkWp+e86sJOOpY/t9c3EjpEuJ7s0ngZr6QkZ0LNemWkS/zRZlrQuNG28uUawJrCHgYO17LoSpkDUfRoeB1zBQTHEh8dguOaVlCLFYf1rZmvba+FkAExeY/2V/D7YHhzf6whBb6bGEpymUBOGj90RazjU32TbGj8I1yySCCr4dWyIqAZoHy8ln7nafWOlvTXLD4eAuoxwMuiavRpba5ZiKXHKEGFnq0dP2j3smYJKKdhA0ZynH8O4ye8h6pOB7ApETvdj+/Cm57l3owYf2lythIwWfP/TXdeNTi4uH5RZFL047Zp8tSmKbHtfFRgin30LvFLLMyykMo6aWBhccT5KKxdnrmWkj6EMLxuSEFvCDPiaiWe2Kx1YAVGSKFySSS7enxCHF5kC7DKlMDcuuA5k6ug+Y6tu3MUCvPdFnfIU4EhOTdPUzndwnryjDTQr86NC6HYJZ+McY0pzvUG+//ymo01lkg5HvziQT2GfloUsuvnJBpWkXxV/pR1q1f9Z4Dm0IrK1TNZGh+cFT8cE0ARHp1cqj4/Nqu6QDlGE8z1qlzMBXGcpDTzeThIe22WuX/o2Et8UlW2Oz9e1sLx9EU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(136003)(39860400002)(346002)(15650500001)(8936002)(38100700002)(53546011)(16526019)(31686004)(31696002)(8676002)(2616005)(38350700002)(956004)(66556008)(16576012)(26005)(86362001)(66946007)(66476007)(36756003)(83380400001)(316002)(186003)(478600001)(2906002)(52116002)(5660300002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dlFTQnp1VGxqUERIZDY2Y0pXdnIzTHdmbG5FcmRwdUVNSDVZb3JieUJxSkx0?=
 =?utf-8?B?SnlkNXRwajM2TWN1cWdhekVIWTQvRkVucGhoSFgyWDN3TzJscm9LLzZmc2Y2?=
 =?utf-8?B?UGpBY2FkOUREWFZjRi9oTVZLM3FVempONm1MbWpWdXZoRXQvTXZTZ3g0cnM3?=
 =?utf-8?B?RjFvdjFtNzhEeGROZ2kyY2cyRnpQNDFKYm5XNE5DY0VaVVJHbFBRcHN0ZGlj?=
 =?utf-8?B?Ni9oUjVCRVJTUE5BZXNjcUVIc05VY2dLQ20yMmJFMFhCOCtpMXh6bCtmVlFW?=
 =?utf-8?B?R0wybjByYURDWDhKaFpMQm94Q1BQS01YMmg1VlRzby9oRkpJWXVXMmdMLzh5?=
 =?utf-8?B?RFdjVHVUNzNSMnNJSFJwR3JsQjdITUZJRWU0TndaOG9vNUU1b01oQWk0NXZL?=
 =?utf-8?B?cWdWZ3prVVRtY0V4bExSenhQbEM3dUFtL2Y1TC9jQXdPVXN1MFV4amx4WGdD?=
 =?utf-8?B?Q2piMUJqdUpuR1NhVXhzY3AvamJJbXNTQkRsV3VYejdsckRHRWV1OWsrQW1o?=
 =?utf-8?B?NkJNK1VEU0JFTjl6YUZ4Slk3YVdoMDE0T1pPS0lhSzdjQzU5WVZtYmJYSHp1?=
 =?utf-8?B?a1VreStqY3B0UGcxVWZZNk1mRENKclZRNzc5Mmc4OUxTZG1wdldQelBNZ1lU?=
 =?utf-8?B?QlBDcHUyc1B0ckdkMUVyMWNkOUw5MVZTbmNUQUZwZWZTT2swejNsN1FSNWZ0?=
 =?utf-8?B?ZnB0MUFWZ0VmVDhGMCtPNytHbWdnaCt1UjVQa0lKcTZERXZEdk4xTEtEWlE5?=
 =?utf-8?B?S2VVQmVCckpLVFhHNTl1ZGxWTkNmdGNoSzdpQU9JdVdFTWI3MENJaUFpWi9G?=
 =?utf-8?B?UFNsRWVmOUJsZmNJU1AxUUM4UU02Rm50ZWhzZDVFVmV3MXJQS3ZtMEtRNzY3?=
 =?utf-8?B?cGV5b0xMYlRGTXBCUTk0aHQzU0RNSUYyeEV1NTFDNjNpbUUrSEVGMzJvQk1q?=
 =?utf-8?B?WkMyb1VCVWhlQ1dCS0lwcGhIWklsVW5sRXNqRkcvaVRYVjh3eFppVjhDeXgz?=
 =?utf-8?B?NkRmd1ZFVzc5ZXl5ZkMxTUNZRGRiV2hYeHp2NkgvTnJlRi9pWmVjdHltc2hi?=
 =?utf-8?B?VWpXMVJHY2NsVG5BZFhsMy9TSVNlTHJSa3JvN1dqUVp5MG1uWnQ5SUpiVGxj?=
 =?utf-8?B?eHpJcmtlTkxZWjNwSXRNQ2U2a3FVeElOZ3lNZTU2WjNDbWJwVlBGbVVtRlUx?=
 =?utf-8?B?dkRXbEhUcXFjb2kwVHBCV2ZFWVVlaFVUcE0wTWZRYUdvcms0U3h2bmluYUNu?=
 =?utf-8?B?dzB0ZGlyMTJhMmgyV01vb1htMVFDM1ZweWVwdnVwdkVGQnQ2ak5ja0NsT2Nt?=
 =?utf-8?B?bENwTEdCeFlIVjR0d0IrZzlvTnovWHVOeDhOSjl1NXBNRzNSZ0Z6cjdrUUoy?=
 =?utf-8?B?SU1RSGpwSnpnUS8xUEp0UGxkU25qSHhLL3hKT3RySktoUmxPaFFERWFRaTlW?=
 =?utf-8?B?Tk9XZHlsVCt3OXhhTHFQeG9SNWlndGU2Uk4ycDhKMlh4OVQ3K3pSZ2h0b05O?=
 =?utf-8?B?b2MvZWdnckVtd09WWWRjb2Z4VjRrdlZMVnl5clY1WFovNlBvZms1N0hKdVlW?=
 =?utf-8?B?YUI4SjBaYUlxMUFOY0RoYnRFNWpnWUxvSTJsYndGM1RCb1c2ZUpVeFlDeng0?=
 =?utf-8?B?Y1lYOVlrTC9ZZUIyTGdCaGR1MVRaUWd0MHFoTUJmdDlRZzJkNzhzVTZxZGwr?=
 =?utf-8?B?NlZzU1FHUmhLTTVNN1dPZ0Zhakl6R1FnTmZhUm03MUhaRDlKS2l3Qk5mV0dj?=
 =?utf-8?Q?3F+aH0wUc58rnXpHJbcDIb9zQLUL9fUJL5dqwi8?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74465f53-f928-43a2-4e52-08d90408ac2f
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 14:29:14.6525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UOoWhFKTfu9Tv9EtYBEHpJ1cIaD4Y/gz5yu2qiQWkSM34aAT5tkmAZdgTB8AYD/nnw3n1AneL6cSzqBh3qgw9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7190
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 7:04 PM, Mike Christie wrote:
> libiscsi will now suspend the send/tx queue for the drivers so we can drop
> it from the drivers ep_disconnect.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/be2iscsi/be_iscsi.c | 6 ------
>  drivers/scsi/bnx2i/bnx2i_iscsi.c | 6 +-----
>  drivers/scsi/cxgbi/libcxgbi.c    | 1 -
>  drivers/scsi/qedi/qedi_iscsi.c   | 8 ++++----
>  4 files changed, 5 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
> index a13c203ef7a9..a03d0ebc2312 100644
> --- a/drivers/scsi/be2iscsi/be_iscsi.c
> +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> @@ -1293,7 +1293,6 @@ static int beiscsi_conn_close(struct beiscsi_endpoint *beiscsi_ep)
>  void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
>  {
>  	struct beiscsi_endpoint *beiscsi_ep;
> -	struct beiscsi_conn *beiscsi_conn;
>  	struct beiscsi_hba *phba;
>  	uint16_t cri_index;
>  
> @@ -1312,11 +1311,6 @@ void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
>  		return;
>  	}
>  
> -	if (beiscsi_ep->conn) {
> -		beiscsi_conn = beiscsi_ep->conn;
> -		iscsi_suspend_queue(beiscsi_conn->conn);
> -	}
> -
>  	if (!beiscsi_hba_is_online(phba)) {
>  		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
>  			    "BS_%d : HBA in error 0x%lx\n", phba->state);
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index b6c1da46d582..9a4f4776a78a 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -2113,7 +2113,6 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
>  {
>  	struct bnx2i_endpoint *bnx2i_ep;
>  	struct bnx2i_conn *bnx2i_conn = NULL;
> -	struct iscsi_conn *conn = NULL;
>  	struct bnx2i_hba *hba;
>  
>  	bnx2i_ep = ep->dd_data;
> @@ -2126,11 +2125,8 @@ static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
>  		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
>  		msleep(250);
>  
> -	if (bnx2i_ep->conn) {
> +	if (bnx2i_ep->conn)
>  		bnx2i_conn = bnx2i_ep->conn;
> -		conn = bnx2i_conn->cls_conn->dd_data;
> -		iscsi_suspend_queue(conn);
> -	}
>  	hba = bnx2i_ep->hba;
>  
>  	mutex_lock(&hba->net_dev_lock);
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index f078b3c4e083..215dd0eb3f48 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -2968,7 +2968,6 @@ void cxgbi_ep_disconnect(struct iscsi_endpoint *ep)
>  		ep, cep, cconn, csk, csk->state, csk->flags);
>  
>  	if (cconn && cconn->iconn) {
> -		iscsi_suspend_tx(cconn->iconn);
>  		write_lock_bh(&csk->callback_lock);
>  		cep->csk->user_data = NULL;
>  		cconn->cep = NULL;
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index ef16537c523c..30dc345b011c 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -988,7 +988,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
>  {
>  	struct qedi_endpoint *qedi_ep;
>  	struct qedi_conn *qedi_conn = NULL;
> -	struct iscsi_conn *conn = NULL;
>  	struct qedi_ctx *qedi;
>  	int ret = 0;
>  	int wait_delay;
> @@ -1007,8 +1006,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
>  
>  	if (qedi_ep->conn) {
>  		qedi_conn = qedi_ep->conn;
> -		conn = qedi_conn->cls_conn->dd_data;
> -		iscsi_suspend_queue(conn);
>  		abrt_conn = qedi_conn->abrt_conn;
>  
>  		while (count--)	{
> @@ -1621,8 +1618,11 @@ void qedi_clear_session_ctx(struct iscsi_cls_session *cls_sess)
>  	struct iscsi_conn *conn = session->leadconn;
>  	struct qedi_conn *qedi_conn = conn->dd_data;
>  
> -	if (iscsi_is_session_online(cls_sess))
> +	if (iscsi_is_session_online(cls_sess)) {
> +		if (conn)
> +			iscsi_suspend_queue(conn);
>  		qedi_ep_disconnect(qedi_conn->iscsi_ep);
> +	}
>  
>  	qedi_conn_destroy(qedi_conn->cls_conn);
>  
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

