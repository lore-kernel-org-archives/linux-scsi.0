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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059E9C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 21:11:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D74E9611ED
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Apr 2021 21:11:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbhDXVMD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Apr 2021 17:12:03 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:43791 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhDXVMD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Apr 2021 17:12:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619298683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yQXKKyy9EytCoI1kt/lGCwV6UzSyBwjW/sjhIEi21VI=;
        b=mijX8o2D8xhE2S92vS/o2uNzGOgh+DOkyW8vt8vxB54gnt+3jsKNS5kSss6aB+MxL5HD/i
        k7WvY5i1NnNZ5p5+pXwdjZhi+8k+PF3gRsqcA648E/j+Oe7heTu/3cc+gIco+bi3oR5ITN
        6MPb4Hex5jPr5keRGzDer6GcQ37DI4I=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-C1T2m4PCPh2xu8O3yqN36g-1; Sat, 24 Apr 2021 23:11:22 +0200
X-MC-Unique: C1T2m4PCPh2xu8O3yqN36g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChUsRfdxg3AFU2EMLg1q65bxkGPvNaBv1sIPEE4kO8Gg0a2rFiGUCdk3k1hiIJbTna72YNO3U2znOHBha2sQjRdxxVvBme9gKOUoYzohYnaDZwNBE0y6fKxaEsAys9vEpikT9EtE+d7rfyDkiCQft2LNUtRLRRAXFwjiNxUTkzESFmWWRCK6MAvfcK74C6UmS2DFFP/36yNDB224O0pI9Wn0QyEeBbn4s0v7Gf3FAi1RbsjJucYi7haoHBZzMSab7uJoTilGSvkEr8Ln5zyYKFN0bhiW+O0lh7hMND7NvX2SvmvonionGF5vRqRtPwXm9d8nuhEVtGqssTuBcwwXqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQXKKyy9EytCoI1kt/lGCwV6UzSyBwjW/sjhIEi21VI=;
 b=XiVJ4HTsy20BcFlcMA3IjBJ7LA4BGJ01shFdGgmvLpYj1jhZ5iYDtqKYCvk5z0W/mC1A2GwGGdKkUPWDLH25J1sHwHDFJ4Usvi3w/xQIIm87vkc3yvs8D/YKiXpRJ9uxDOZKn4X5bzCYNdG2oPrJ6HeqhfftW52BA9pSYySpdpT7ywfefb/7pjT0U8ol8TCzr1Su0k8iTYipkULcu8Cn/R86HeWHZ6q8QCBeD83JVV88QATli89rhp2ZGHas6paDhfV8k4eIjxMLdXHomn1ywQyHvDGrZ8MsQ7j4QQUrs6muwrCvtSq8VUzHCv1Yovwho9gbLIQhL6bGRAfOGWPDpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5925.eurprd04.prod.outlook.com (2603:10a6:20b:ab::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Sat, 24 Apr
 2021 21:11:20 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Sat, 24 Apr 2021
 21:11:20 +0000
Subject: Re: [PATCH v3 06/17] scsi: iscsi: fix use conn use after free
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <866332db-7b76-3ad5-7816-8d34c987440c@suse.com>
Date:   Sat, 24 Apr 2021 14:11:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210416020440.259271-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR0P264CA0117.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:19::33) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR0P264CA0117.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:19::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend Transport; Sat, 24 Apr 2021 21:11:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ba032941-fbaa-4edc-a8a3-08d907658213
X-MS-TrafficTypeDiagnostic: AM6PR04MB5925:
X-Microsoft-Antispam-PRVS: <AM6PR04MB59258E9B76A8603F4690DA1ADA449@AM6PR04MB5925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:608;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lb9aSb3PZ911ic3k3V6TXNL6yJvxk3jWQeQyGvz4hIe4OvRWViFFfOAe2uzTD7IxIn0E8OllsBxeQIEwcx9zEh0GIIAOG5kA1lTzCSbKHVaPgYRJNGlCfY2nVmZTyibHX6yZp1E9hVvrvif2OG6OLg1nY7A7SUI3dbAXcYpby6/DBtEnEHx/UEYJMET01xfI8FCOu+qSd1/wu7Ng4jsHFRFmUv/cEqTBc5PGt5WSzQDBzS8rVy1Jm5V8JYqiwwiqHPyuM7zd/8yNGm3UZuXG8Oo7XTLnI4N0sDZ9dVvV+13AqawCQi4hnbwvPyKVWug3+1GRJRVQbGxZYeWO/YHeran2cI1IF8kU659/9GBisCL3TGPsapfMhlTzR/4eRwTrPnnlGu+7sfDiAvp2M85Eyux+ojG+qBEq4P9g5euCqCf6mqtF4BVFGgh/VeWFCuDjUi1DybuT4ALDyG5D5EpwrfFKINrc9WOLmMJ3WQgE535uX87NOv8NrtnSYFdohOanUet8iAwCAZNTTs4YS2BzD030FPunYbX4z6Lnu8C31tO+0o+XuuDaPRuFdGz81UZwNExVAy7+b91g2wp0cycmVT5dHI8F5/K7746ZZS8Q9qvOoIyiO94EWGowNRVu4on+tf6pNzRxEMG2ufHjS9S1GbmTbWDPFBaxEIG+zGDnFnV0DV9xjYs07ouNakDPhWAzMaHg3jVWr5gXhJ9knbBovQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39850400004)(346002)(136003)(186003)(26005)(5660300002)(16526019)(2906002)(83380400001)(8936002)(52116002)(316002)(6486002)(86362001)(956004)(31686004)(31696002)(2616005)(478600001)(6666004)(30864003)(16576012)(66946007)(38350700002)(38100700002)(36756003)(8676002)(66476007)(66556008)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RTdhbUl3UHhvbmVMbWVCUXRCQTVFK2YvSnlyUy9semRhRU5YZGhNRFVMT0pQ?=
 =?utf-8?B?WG9wTklNMFVDaWlVa1FpT0xtZFhKV1R5SGxZTzdUNmNBUmQyK2lDVDB5Rmx3?=
 =?utf-8?B?VW9IeVBRdElTVEhwZ0FCQ0YzOWNRd2hOYVB3NzYvWVYxOUdIZzFBRTJKMlFW?=
 =?utf-8?B?cWd4aWlQWGpJb2tsemszTXNaMGdpUzlOaXJVUENQQVM4UFRLRXh5M1lDc2tK?=
 =?utf-8?B?YjNqS0FvWC9wa1lEQVZDWFphMk1SUXQvSlg3bGdwVFhYbXpJc0ZpNjJnYkpT?=
 =?utf-8?B?ZkVWU1NMYk0yRndkTVVLTVM2NzFrellZcm1OTFAwMys2VXZnODNKMW1DQU8w?=
 =?utf-8?B?bzlmbXB6c0xxNjZZM2k0ZVRjaHFHWEFwTksraGhZdGpUeFRGY3F4YU5KYTFm?=
 =?utf-8?B?Q1hzbzBHRnZCcWdHdHdBcUxFTGRSdG1sQkNWOWJRRlh4eGtyd0xQYnBaVXpY?=
 =?utf-8?B?SlZaeWY1bUd5TmMzOXpmQ3ovQ2hsOVhGYmxjRzRDdG1sdTlTTTdJU1ZsaDhs?=
 =?utf-8?B?cGhGZnVsTFFPRHcxSnNTM3hYNkpmQ0R6RlFEbjdQUXg0VTdiL0NPSlNuenJB?=
 =?utf-8?B?V210aE9PbXJMZVFIQ2ZYajEvbGNNc1cySlFVaS82N1ZqNzBJSWZrVC9nL3Y5?=
 =?utf-8?B?V0ptalJxU0lkTmN3TWoxT0R3WTNNemlPbGRtYU4zNUlNZkN5amg3cDdvNjJt?=
 =?utf-8?B?ZFVsaHNLMlJ0RDdVNHJicXBjWURvVVlqbTU1SWs4WE42alFaQjVCYmZ1N2Rn?=
 =?utf-8?B?U2k5bXQ1KzBzcllpQldUOFJCQkpxNmVscnhScWpxK3NCSEtXWjVUL0Vjbk51?=
 =?utf-8?B?MFlsdFFWRFRPaXBrdHlBTlZiMCtGd0tSVE55dTJIMUxKaXc0RGxCM2x6TGpq?=
 =?utf-8?B?R0xmWm5oZVRId2J3QUN3V2pyT3RCbUZobnBwb2pFWHFMQ2Q5cUV5aGF3V2hV?=
 =?utf-8?B?ZE9uakNLYURmSWhrZ21GbVl4SXh6LzlvWWczcys0NjUwVStsZjBYV0xjK1k0?=
 =?utf-8?B?SEFqNGJzeFJtRkpSSEpzQWNlQ2tITFI5RnZJT3VLT1FEUEI1NE40TXRHb2wv?=
 =?utf-8?B?MGtieHp1bVB2N2hrVUdtVVlnMUdOL3FQZHdPTU9XUFZobmd5azZwbTZJOGNz?=
 =?utf-8?B?Y0g5YmpvZ2xnNERhamh5Z2NKc3plNm1Ham9OOUl2amd2SGsrVVZmVWpiQjlO?=
 =?utf-8?B?MXRRUEs5ZXJzRVNsNUxZVUk5WTJ6U0ZPUk8rRXlJVUZUY08vTlZOVjJucVY1?=
 =?utf-8?B?K05aU201Ri9VYWhpUS93bkQ4TmRBU0FuM1E2dVBZZW5jNkQ2ZHBnRjdoNUw5?=
 =?utf-8?B?Y0pRT0Rmd2FmVXJEZWdXREhlZTZDcjNUeE5Pdk9UZGtkSVZTbjJTZlNIUTdC?=
 =?utf-8?B?ZitiMWRJVWtObUp6UzZxa1FaWHRYNXFKWlJod0dLbGlsbW9pVlBiQkRvUEoz?=
 =?utf-8?B?amxwenlhU3VsaXV2MU9pQmx0ZWd0WEs3S2NDNlZ4QkxrRTRiUTFlYS9Bc3hn?=
 =?utf-8?B?TGdlT09UOEhJVkVzaGtOVE1RTUY4Q2E2bUxBQUNnMnVHK09nQ3NZRk0rNm56?=
 =?utf-8?B?NkRzMDJ5VXZKQmZTTlNEelZFVmhGdWErY29PTmZrZTFnd0NzT21FaGZ1WkF1?=
 =?utf-8?B?QXhQU21hSkRDcG5GU01OZ1ZaekpMeDR0OExhVU9yNHQzUEp5RU5GZG9TY281?=
 =?utf-8?B?SzZuUTBTbEI1WlYvT2VaZ3BlY1BObTV4SXQ1N1VGV0FnZXlCcDZOdzhybGsr?=
 =?utf-8?Q?rEyC+rxFacsL4RbeFOiydltZCDASOPzH+xQc9gt?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba032941-fbaa-4edc-a8a3-08d907658213
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2021 21:11:20.8011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMEIkoPC58UnrL2sWhku1KnbPnuRez7SlmaEMqPqPeyHwvoqbz6Ko4ysZJC381dM5wRtIymg9vUixGle4ILypg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5925
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 7:04 PM, Mike Christie wrote:
> If we haven't done a unbind target call we can race where
> iscsi_conn_teardown wakes up the eh/abort thread and then frees the conn
> while those threads are still accessing the conn ehwait.
> 
> We can only do one TMF per session so this just moves the TMF fields from
> the conn to the session. We can then rely on the
> iscsi_session_teardown->iscsi_remove_session->__iscsi_unbind_session call
> to remove the target and it's devices, and know after that point there is
> no device or scsi-ml callout trying to access the session.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 123 +++++++++++++++++++---------------------
>  include/scsi/libiscsi.h |  11 ++--
>  2 files changed, 64 insertions(+), 70 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index ce6d04035c64..56b41d8fff02 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -230,11 +230,11 @@ static int iscsi_prep_ecdb_ahs(struct iscsi_task *task)
>   */
>  static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
>  {
> -	struct iscsi_conn *conn = task->conn;
> -	struct iscsi_tm *tmf = &conn->tmhdr;
> +	struct iscsi_session *session = task->conn->session;
> +	struct iscsi_tm *tmf = &session->tmhdr;
>  	u64 hdr_lun;
>  
> -	if (conn->tmf_state == TMF_INITIAL)
> +	if (session->tmf_state == TMF_INITIAL)
>  		return 0;
>  
>  	if ((tmf->opcode & ISCSI_OPCODE_MASK) != ISCSI_OP_SCSI_TMFUNC)
> @@ -254,24 +254,19 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
>  		 * Fail all SCSI cmd PDUs
>  		 */
>  		if (opcode != ISCSI_OP_SCSI_DATA_OUT) {
> -			iscsi_conn_printk(KERN_INFO, conn,
> -					  "task [op %x itt "
> -					  "0x%x/0x%x] "
> -					  "rejected.\n",
> -					  opcode, task->itt,
> -					  task->hdr_itt);
> +			iscsi_session_printk(KERN_INFO, session,
> +					"task [op %x itt 0x%x/0x%x] rejected.\n",
> +					opcode, task->itt, task->hdr_itt);
>  			return -EACCES;
>  		}
>  		/*
>  		 * And also all data-out PDUs in response to R2T
>  		 * if fast_abort is set.
>  		 */
> -		if (conn->session->fast_abort) {
> -			iscsi_conn_printk(KERN_INFO, conn,
> -					  "task [op %x itt "
> -					  "0x%x/0x%x] fast abort.\n",
> -					  opcode, task->itt,
> -					  task->hdr_itt);
> +		if (session->fast_abort) {
> +			iscsi_session_printk(KERN_INFO, session,
> +					"task [op %x itt 0x%x/0x%x] fast abort.\n",
> +					opcode, task->itt, task->hdr_itt);
>  			return -EACCES;
>  		}
>  		break;
> @@ -284,7 +279,7 @@ static int iscsi_check_tmf_restrictions(struct iscsi_task *task, int opcode)
>  		 */
>  		if (opcode == ISCSI_OP_SCSI_DATA_OUT &&
>  		    task->hdr_itt == tmf->rtt) {
> -			ISCSI_DBG_SESSION(conn->session,
> +			ISCSI_DBG_SESSION(session,
>  					  "Preventing task %x/%x from sending "
>  					  "data-out due to abort task in "
>  					  "progress\n", task->itt,
> @@ -936,20 +931,21 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  static void iscsi_tmf_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  {
>  	struct iscsi_tm_rsp *tmf = (struct iscsi_tm_rsp *)hdr;
> +	struct iscsi_session *session = conn->session;
>  
>  	conn->exp_statsn = be32_to_cpu(hdr->statsn) + 1;
>  	conn->tmfrsp_pdus_cnt++;
>  
> -	if (conn->tmf_state != TMF_QUEUED)
> +	if (session->tmf_state != TMF_QUEUED)
>  		return;
>  
>  	if (tmf->response == ISCSI_TMF_RSP_COMPLETE)
> -		conn->tmf_state = TMF_SUCCESS;
> +		session->tmf_state = TMF_SUCCESS;
>  	else if (tmf->response == ISCSI_TMF_RSP_NO_TASK)
> -		conn->tmf_state = TMF_NOT_FOUND;
> +		session->tmf_state = TMF_NOT_FOUND;
>  	else
> -		conn->tmf_state = TMF_FAILED;
> -	wake_up(&conn->ehwait);
> +		session->tmf_state = TMF_FAILED;
> +	wake_up(&session->ehwait);
>  }
>  
>  static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
> @@ -1734,20 +1730,20 @@ static bool iscsi_eh_running(struct iscsi_conn *conn, struct scsi_cmnd *sc,
>  	 * same cmds. Once we get a TMF that can affect multiple cmds stop
>  	 * queueing.
>  	 */
> -	if (conn->tmf_state != TMF_INITIAL) {
> -		tmf = &conn->tmhdr;
> +	if (session->tmf_state != TMF_INITIAL) {
> +		tmf = &session->tmhdr;
>  
>  		switch (ISCSI_TM_FUNC_VALUE(tmf)) {
>  		case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
>  			if (sc->device->lun != scsilun_to_int(&tmf->lun))
>  				break;
>  
> -			ISCSI_DBG_EH(conn->session,
> +			ISCSI_DBG_EH(session,
>  				     "Requeue cmd sent during LU RESET processing.\n");
>  			sc->result = DID_REQUEUE << 16;
>  			goto eh_running;
>  		case ISCSI_TM_FUNC_TARGET_WARM_RESET:
> -			ISCSI_DBG_EH(conn->session,
> +			ISCSI_DBG_EH(session,
>  				     "Requeue cmd sent during TARGET RESET processing.\n");
>  			sc->result = DID_REQUEUE << 16;
>  			goto eh_running;
> @@ -1866,15 +1862,14 @@ EXPORT_SYMBOL_GPL(iscsi_target_alloc);
>  
>  static void iscsi_tmf_timedout(struct timer_list *t)
>  {
> -	struct iscsi_conn *conn = from_timer(conn, t, tmf_timer);
> -	struct iscsi_session *session = conn->session;
> +	struct iscsi_session *session = from_timer(session, t, tmf_timer);
>  
>  	spin_lock(&session->frwd_lock);
> -	if (conn->tmf_state == TMF_QUEUED) {
> -		conn->tmf_state = TMF_TIMEDOUT;
> +	if (session->tmf_state == TMF_QUEUED) {
> +		session->tmf_state = TMF_TIMEDOUT;
>  		ISCSI_DBG_EH(session, "tmf timedout\n");
>  		/* unblock eh_abort() */
> -		wake_up(&conn->ehwait);
> +		wake_up(&session->ehwait);
>  	}
>  	spin_unlock(&session->frwd_lock);
>  }
> @@ -1897,8 +1892,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
>  		return -EPERM;
>  	}
>  	conn->tmfcmd_pdus_cnt++;
> -	conn->tmf_timer.expires = timeout * HZ + jiffies;
> -	add_timer(&conn->tmf_timer);
> +	session->tmf_timer.expires = timeout * HZ + jiffies;
> +	add_timer(&session->tmf_timer);
>  	ISCSI_DBG_EH(session, "tmf set timeout\n");
>  
>  	spin_unlock_bh(&session->frwd_lock);
> @@ -1912,12 +1907,12 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
>  	 * 3) session is terminated or restarted or userspace has
>  	 * given up on recovery
>  	 */
> -	wait_event_interruptible(conn->ehwait, age != session->age ||
> +	wait_event_interruptible(session->ehwait, age != session->age ||
>  				 session->state != ISCSI_STATE_LOGGED_IN ||
> -				 conn->tmf_state != TMF_QUEUED);
> +				 session->tmf_state != TMF_QUEUED);
>  	if (signal_pending(current))
>  		flush_signals(current);
> -	del_timer_sync(&conn->tmf_timer);
> +	del_timer_sync(&session->tmf_timer);
>  
>  	mutex_lock(&session->eh_mutex);
>  	spin_lock_bh(&session->frwd_lock);
> @@ -2347,17 +2342,17 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  	}
>  
>  	/* only have one tmf outstanding at a time */
> -	if (conn->tmf_state != TMF_INITIAL)
> +	if (session->tmf_state != TMF_INITIAL)
>  		goto failed;
> -	conn->tmf_state = TMF_QUEUED;
> +	session->tmf_state = TMF_QUEUED;
>  
> -	hdr = &conn->tmhdr;
> +	hdr = &session->tmhdr;
>  	iscsi_prep_abort_task_pdu(task, hdr);
>  
>  	if (iscsi_exec_task_mgmt_fn(conn, hdr, age, session->abort_timeout))
>  		goto failed;
>  
> -	switch (conn->tmf_state) {
> +	switch (session->tmf_state) {
>  	case TMF_SUCCESS:
>  		spin_unlock_bh(&session->frwd_lock);
>  		/*
> @@ -2372,7 +2367,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  		 */
>  		spin_lock_bh(&session->frwd_lock);
>  		fail_scsi_task(task, DID_ABORT);
> -		conn->tmf_state = TMF_INITIAL;
> +		session->tmf_state = TMF_INITIAL;
>  		memset(hdr, 0, sizeof(*hdr));
>  		spin_unlock_bh(&session->frwd_lock);
>  		iscsi_start_tx(conn);
> @@ -2383,7 +2378,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  		goto failed_unlocked;
>  	case TMF_NOT_FOUND:
>  		if (!sc->SCp.ptr) {
> -			conn->tmf_state = TMF_INITIAL;
> +			session->tmf_state = TMF_INITIAL;
>  			memset(hdr, 0, sizeof(*hdr));
>  			/* task completed before tmf abort response */
>  			ISCSI_DBG_EH(session, "sc completed while abort	in "
> @@ -2392,7 +2387,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
>  		}
>  		fallthrough;
>  	default:
> -		conn->tmf_state = TMF_INITIAL;
> +		session->tmf_state = TMF_INITIAL;
>  		goto failed;
>  	}
>  
> @@ -2451,11 +2446,11 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
>  	conn = session->leadconn;
>  
>  	/* only have one tmf outstanding at a time */
> -	if (conn->tmf_state != TMF_INITIAL)
> +	if (session->tmf_state != TMF_INITIAL)
>  		goto unlock;
> -	conn->tmf_state = TMF_QUEUED;
> +	session->tmf_state = TMF_QUEUED;
>  
> -	hdr = &conn->tmhdr;
> +	hdr = &session->tmhdr;
>  	iscsi_prep_lun_reset_pdu(sc, hdr);
>  
>  	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
> @@ -2464,7 +2459,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
>  		goto unlock;
>  	}
>  
> -	switch (conn->tmf_state) {
> +	switch (session->tmf_state) {
>  	case TMF_SUCCESS:
>  		break;
>  	case TMF_TIMEDOUT:
> @@ -2472,7 +2467,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
>  		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
>  		goto done;
>  	default:
> -		conn->tmf_state = TMF_INITIAL;
> +		session->tmf_state = TMF_INITIAL;
>  		goto unlock;
>  	}
>  
> @@ -2484,7 +2479,7 @@ int iscsi_eh_device_reset(struct scsi_cmnd *sc)
>  	spin_lock_bh(&session->frwd_lock);
>  	memset(hdr, 0, sizeof(*hdr));
>  	fail_scsi_tasks(conn, sc->device->lun, DID_ERROR);
> -	conn->tmf_state = TMF_INITIAL;
> +	session->tmf_state = TMF_INITIAL;
>  	spin_unlock_bh(&session->frwd_lock);
>  
>  	iscsi_start_tx(conn);
> @@ -2507,8 +2502,7 @@ void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
>  	spin_lock_bh(&session->frwd_lock);
>  	if (session->state != ISCSI_STATE_LOGGED_IN) {
>  		session->state = ISCSI_STATE_RECOVERY_FAILED;
> -		if (session->leadconn)
> -			wake_up(&session->leadconn->ehwait);
> +		wake_up(&session->ehwait);
>  	}
>  	spin_unlock_bh(&session->frwd_lock);
>  }
> @@ -2553,7 +2547,7 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>  	iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
>  
>  	ISCSI_DBG_EH(session, "wait for relogin\n");
> -	wait_event_interruptible(conn->ehwait,
> +	wait_event_interruptible(session->ehwait,
>  				 session->state == ISCSI_STATE_TERMINATE ||
>  				 session->state == ISCSI_STATE_LOGGED_IN ||
>  				 session->state == ISCSI_STATE_RECOVERY_FAILED);
> @@ -2614,11 +2608,11 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  	conn = session->leadconn;
>  
>  	/* only have one tmf outstanding at a time */
> -	if (conn->tmf_state != TMF_INITIAL)
> +	if (session->tmf_state != TMF_INITIAL)
>  		goto unlock;
> -	conn->tmf_state = TMF_QUEUED;
> +	session->tmf_state = TMF_QUEUED;
>  
> -	hdr = &conn->tmhdr;
> +	hdr = &session->tmhdr;
>  	iscsi_prep_tgt_reset_pdu(sc, hdr);
>  
>  	if (iscsi_exec_task_mgmt_fn(conn, hdr, session->age,
> @@ -2627,7 +2621,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  		goto unlock;
>  	}
>  
> -	switch (conn->tmf_state) {
> +	switch (session->tmf_state) {
>  	case TMF_SUCCESS:
>  		break;
>  	case TMF_TIMEDOUT:
> @@ -2635,7 +2629,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  		iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
>  		goto done;
>  	default:
> -		conn->tmf_state = TMF_INITIAL;
> +		session->tmf_state = TMF_INITIAL;
>  		goto unlock;
>  	}
>  
> @@ -2647,7 +2641,7 @@ static int iscsi_eh_target_reset(struct scsi_cmnd *sc)
>  	spin_lock_bh(&session->frwd_lock);
>  	memset(hdr, 0, sizeof(*hdr));
>  	fail_scsi_tasks(conn, -1, DID_ERROR);
> -	conn->tmf_state = TMF_INITIAL;
> +	session->tmf_state = TMF_INITIAL;
>  	spin_unlock_bh(&session->frwd_lock);
>  
>  	iscsi_start_tx(conn);
> @@ -2977,7 +2971,10 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
>  	session->tt = iscsit;
>  	session->dd_data = cls_session->dd_data + sizeof(*session);
>  
> +	session->tmf_state = TMF_INITIAL;
> +	timer_setup(&session->tmf_timer, iscsi_tmf_timedout, 0);
>  	mutex_init(&session->eh_mutex);
> +
>  	spin_lock_init(&session->frwd_lock);
>  	spin_lock_init(&session->back_lock);
>  
> @@ -3081,7 +3078,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
>  	conn->id = conn_idx;
>  	conn->exp_statsn = 0;
> -	conn->tmf_state = TMF_INITIAL;
>  
>  	timer_setup(&conn->transport_timer, iscsi_check_transport_timeouts, 0);
>  
> @@ -3106,8 +3102,7 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  		goto login_task_data_alloc_fail;
>  	conn->login_task->data = conn->data = data;
>  
> -	timer_setup(&conn->tmf_timer, iscsi_tmf_timedout, 0);
> -	init_waitqueue_head(&conn->ehwait);
> +	init_waitqueue_head(&session->ehwait);
>  
>  	return cls_conn;
>  
> @@ -3160,7 +3155,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
>  		 * leading connection? then give up on recovery.
>  		 */
>  		session->state = ISCSI_STATE_TERMINATE;
> -		wake_up(&conn->ehwait);
> +		wake_up(&session->ehwait);
>  	}
>  
>  	spin_unlock_bh(&session->frwd_lock);
> @@ -3245,7 +3240,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
>  		 * commands after successful recovery
>  		 */
>  		conn->stop_stage = 0;
> -		conn->tmf_state = TMF_INITIAL;
> +		session->tmf_state = TMF_INITIAL;
>  		session->age++;
>  		if (session->age == 16)
>  			session->age = 0;
> @@ -3259,7 +3254,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
>  	spin_unlock_bh(&session->frwd_lock);
>  
>  	iscsi_unblock_session(session->cls_session);
> -	wake_up(&conn->ehwait);
> +	wake_up(&session->ehwait);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_conn_start);
> @@ -3353,7 +3348,7 @@ void iscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
>  	spin_lock_bh(&session->frwd_lock);
>  	fail_scsi_tasks(conn, -1, DID_TRANSPORT_DISRUPTED);
>  	fail_mgmt_tasks(session, conn);
> -	memset(&conn->tmhdr, 0, sizeof(conn->tmhdr));
> +	memset(&session->tmhdr, 0, sizeof(session->tmhdr));
>  	spin_unlock_bh(&session->frwd_lock);
>  	mutex_unlock(&session->eh_mutex);
>  }
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index ec6d508e7a4a..545dfefffe9b 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -202,12 +202,6 @@ struct iscsi_conn {
>  	unsigned long		suspend_tx;	/* suspend Tx */
>  	unsigned long		suspend_rx;	/* suspend Rx */
>  
> -	/* abort */
> -	wait_queue_head_t	ehwait;		/* used in eh_abort() */
> -	struct iscsi_tm		tmhdr;
> -	struct timer_list	tmf_timer;
> -	int			tmf_state;	/* see TMF_INITIAL, etc.*/
> -
>  	/* negotiated params */
>  	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/
>  	unsigned		max_xmit_dlength; /* target_max_recv_dsl */
> @@ -277,6 +271,11 @@ struct iscsi_session {
>  	 * and recv lock.
>  	 */
>  	struct mutex		eh_mutex;
> +	/* abort */
> +	wait_queue_head_t	ehwait;		/* used in eh_abort() */
> +	struct iscsi_tm		tmhdr;
> +	struct timer_list	tmf_timer;
> +	int			tmf_state;	/* see TMF_INITIAL, etc.*/
>  
>  	/* iSCSI session-wide sequencing */
>  	uint32_t		cmdsn;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

