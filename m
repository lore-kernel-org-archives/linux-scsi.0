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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A72FC433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 18:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C42613B5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 18:54:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhEFSzV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 14:55:21 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31803 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229622AbhEFSzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 14:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620327261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zEG1eZhcCdEclns7TRLDAL2kViTb6BF0kx3zvwYnBWE=;
        b=TExWuktUAal1BExtxuF2g8b1OIkd7h1NgHt2RpPqrwXPYag7QCF0mHjvLBGEK7rfXd2D8s
        se5L6DRyrGUfiLtj18gOxD5b29W82DrXwprqrozuiHJJEmSu5LaPkSFU4Lm9Gap4mYyRDX
        MXOhfgi20aVBMhETaafXDj4y7uE0JTs=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2053.outbound.protection.outlook.com [104.47.6.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-3-pkuYdSJYPMCjsVpNYuujNg-1;
 Thu, 06 May 2021 20:54:20 +0200
X-MC-Unique: pkuYdSJYPMCjsVpNYuujNg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbS35y+HKPbGI7Rr/syj0WOchkybT7frssSOqkdVWlbrla54o2JviShTxVKiD+KjQWpJ+hTTOKnnnpbpqaqqVA7m0ApglOOQj+q3ONFrL5SmQZI9wleykwTSia7plXBBnNAuSvEc9XPNhO8iM2hIJ1CNOYN32CS/4YKh6QKk/bwOQ5df5g/t1c8v9PmizC2sZRmK1dUjoM0hHRwNJg5srrbXRT27EUfCQkXSbE+26fgIQQPeT5GGwml8zLnUZwXxOdn90UCrwq6MH2UOPEga+yZzyyaC3rYVb8COwbrdtqe6wl+F0JIk/Momqx4vy5ozEMN4dJWTxpIIyDC6YNpdHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zEG1eZhcCdEclns7TRLDAL2kViTb6BF0kx3zvwYnBWE=;
 b=CQ6pFnpnUI45bmI0S6FTIYieJF4vAilZF4Xkhj/W5tm1P05qzz7V6xtUuBCIj8eL12IUIjwPCHGkvksTUFVPy7AqV0wLIqbT/kIpOTLt6Rks0hcD4Pj1b5Mf7Dg9PfWlkSUAKjMUMzF1xIuMzYG0Q6OG+xRxKPqfdLeEOlLRm7uA7RjvJTNZAGd4qgrNNFx3xfUO8dFzOg/bcxKhtgcqKoXnafRRk9xqT5c47OzXf+5AHxMoWqhLCD9N86J7Jpy2EPq6MnbAcwMjJ5/m8oO4wdOsSalxjDi8AVN3twaNZUWrfXh7efMNpjXeTyD3Jn+63EmolKeOVG5BXtis8hNq1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3091.eurprd04.prod.outlook.com (2603:10a6:206:5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 18:54:19 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.4108.026; Thu, 6 May 2021
 18:54:19 +0000
Subject: Re: [PATCH 062/117] iscsi: Convert to the scsi_status union
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-63-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <c9e51220-ca98-07cf-f107-156c458674ed@suse.com>
Date:   Thu, 6 May 2021 11:54:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210420000845.25873-63-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P193CA0033.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::8) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P193CA0033.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Thu, 6 May 2021 18:54:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91232c81-6559-4179-539d-08d910c05a91
X-MS-TrafficTypeDiagnostic: AM5PR04MB3091:
X-Microsoft-Antispam-PRVS: <AM5PR04MB3091F3AE6BC037471DC2076BDA589@AM5PR04MB3091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nloWiT+Q6l3w/57d5MBzH2oorNzf7nqN2FeG49WUYisXpq1aJju3fewTov0kKSZzx+4h38L+SyMr0bEcX/Pl+/C+wAfCTtGuTs6wuuX6JohJvCVYrs9Y/wZtsSsz6+U/ZVLXRqSAW7z3AH+kOb3kJIlj05lv3yi32zgRyBJJv/ily9ucRUlfL6tF7MmoGy7PfSVGXPpJ4xAN55wAHRJKGIftV+Tisn+967SuOjbNc3MH9cNsj+p2n9VaZ0TEAfKDuu8JinhA7haqCyz6od9ZWCSBFx0zZv4mcymY3tk+KeZuKPOehJsl5pZgf+P+R3fwHOL8kq6PEzg2u8DSZPq0nPezqTBZtcs2dVSJiESawyvxX3PNz0qBZbnUfcvbyrTE1z/1GX5weFoyZAI/kZ/Wy1VNual8eoyoL9wmN3qB41qO03fIRUUYyiHaZ3eecoYrG+4HO+X0HDtL2dNBPI8G7ZdpgZlo+yKxT0yWix8ERRraWIDKfhlAQFgntlcO3UknwKIGm8RpKDZ1u7oQ/qpHNpaTaID35AuTbfZm0pv5PRda0Hajx+vSxDYSMtFzDPZfRgB9Z+6mRxJnTdyQEg1ytdfG1RD+/shQLC3vKi5ujkYTtvZJDPQTWYNsEfdnRJeRfMk7qK9pM6FA5N6mb0h0bM+GGHMGeMYqXApE2VWDFo4d/K9HADjAKSeHpJvk09ou7m9TJHGlMIhbcdcMeQUzFh33sYoJxiLfiXKmdJ1DrU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(376002)(346002)(136003)(2616005)(31696002)(478600001)(316002)(16576012)(31686004)(83380400001)(6666004)(66476007)(186003)(6486002)(66556008)(16526019)(66946007)(26005)(956004)(36756003)(2906002)(8936002)(52116002)(38350700002)(8676002)(110136005)(38100700002)(53546011)(4326008)(86362001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RVRQZ2ZrSG9hOXJmbC9STDZ0bkhKR1F1QTFIYVBSK2dOOWVja25vTmNvN1I5?=
 =?utf-8?B?N1M5M2JrYUplTTFUb2s2MitOSnAwL291SCtrcFhHSnlmdTZzMnR3Y3ArTWpy?=
 =?utf-8?B?Q0YxOUtkTHFBTHgya3FDUldsbVNiQ2hkR05TLzFEWncweEVzMCt6ZUZGaFF3?=
 =?utf-8?B?RnhFQ2JkeFk0cFpRZUhiRndhSnNrZmlESG9HbGkvbWZDTjZ2M1BuZkxEcUFW?=
 =?utf-8?B?NG45SC91ZmhZbWtnQ0oyclFZMlJCK3Q1eXQxdGdxT0F2aDdXSXlXUjAzMkQx?=
 =?utf-8?B?d1VLM3ExOG5abXJjZTVnLzlqSEZwdStMWlJCZWF6bW8xUTRkNjhpdjQzS1R3?=
 =?utf-8?B?aEVWZVJUSDFSUlBPUW9oSDlabWJhMDBNUjVmNGNxK0x5dFpuUkR1VnBic0hz?=
 =?utf-8?B?QTlYZlh3L0JOWlpFY2R0bXdNM0xGSUphWk40c3BtemFnRHZjSFJUUDFDYkph?=
 =?utf-8?B?Vzd4S3RDRm1tVjBWMklPSFFRSW5kTTZ5dktYWkllRWVzTUtxRVFJZ3IvZnJF?=
 =?utf-8?B?cmhnejBxak8vZmtxQTVYTVQyYnNnUVRMTTNMK1d5WUtId0l0VWl4VU9ISjBB?=
 =?utf-8?B?V2Y4aFBHbDZnZDVLdGtPMWFwUmYvamRJV1ZoaTRXSEprbWIxdGlyTmQvTkkv?=
 =?utf-8?B?aHdPc3lMMHVnR0ZxZHpWSUVhaUpJc1dhVzV6ZXZpNlFORk5lNktNNGh2UE5Z?=
 =?utf-8?B?UzJvMDdoQzczSC9FMWUvVmIreElBaGdLejdyQ2h2RDA3WlNibVNPM2VxS3pL?=
 =?utf-8?B?MUJaa2pnSVgzeldXaFZ4S2JzZ0wxTjlxT2FKenZqb2Z5RHhpWGJUc0FnaXdP?=
 =?utf-8?B?OEFNWE1LR0laS0JqUzM0b1E3a1JlOFpQbm1sZ1hucHl2UGhVbmt0OFNvcEJk?=
 =?utf-8?B?dEY3V2NWUjVCdDFhempPSkVjNjhVdWh3bFYvNXM5L2ljK1pzcGJ6ajFEQno4?=
 =?utf-8?B?Z1RYNFhSVnFYeVVjU013NGRwU3ArVklkTHNxamFxbmVsWWF3ZWM0Q3ozOGZ2?=
 =?utf-8?B?Z01aR0gyclphUEJjSXlWam5JQ1pNS1VKcHczWnp3cE12M2g2YllzZ0VIVlp1?=
 =?utf-8?B?bStqZHliK01QbVFDYUVQZ3gvSkdwZ3BzSmVTTWhGNCtWMG5uQU9EWVp0RG1w?=
 =?utf-8?B?OUE1czV1MU4wbExPOEJ4TFU3eTVLL3c0a0cvS0dBS0RoQmFzejJ6cmlDaGVu?=
 =?utf-8?B?R0xXdC9CVXYxYy9PY2krREErVXhJcWlqVjg3S1g3S2pEYzB3VGpXaVd0VkJv?=
 =?utf-8?B?K09iZklMS09WQVFTT0ZpdUlnRnJwSm1LZVNRdWZBeU9uTzlFVENqZGJtcnNr?=
 =?utf-8?B?SVRvUldMRFJlMy9Rdk9DNGc0SU5GWmZwUHFJTDVwOENSaE5HRENZV3QrNTlq?=
 =?utf-8?B?ZzVOa1JaQVczZkk1OUF2RE1hOEYwU21qbEw3c2RlVWtGV2RCZGprUVhheWRC?=
 =?utf-8?B?Y3IrUEZ2cHIzdWxIbVVEdUZyNm1hek1QanEzaXlLNnkvSVBXUW1EWi81V1A4?=
 =?utf-8?B?NEIwTkRmNFVNM2tCSGl3S2VCWmhIR01nLzEzWDVDNmZCUGhaR0kyWWNZMFFl?=
 =?utf-8?B?WjlwMWZvOWlNODVFRFhmOWI3dFBQUktOZ0VMSUVQbjJaU01wOTJ1d1NoUEhp?=
 =?utf-8?B?ZWJZMTF5L1Y0clpuanN6dC9mVmtrNUZLWVdLeWVNU090WXNTQnVXV0tJRTRP?=
 =?utf-8?B?bnBGZnRucmNSMnh2dnNSNHpoc2h6cnNZa0d0cmpjNzM2Yk1YSDBoV0JIb1Zo?=
 =?utf-8?Q?UFVg8eH+4O7Yuu+gulbs2SYoa5xbV3eQYHOC/08?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91232c81-6559-4179-539d-08d910c05a91
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 18:54:18.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yiKrZxrXfMjebLH61raIyLfABIvf+zrYSl94pnURVn5IlX1JrwYMkxoTLpbRjxfh3oTKFtLLc4pUZtf4I1xBIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3091
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/21 5:07 PM, Bart Van Assche wrote:
> An explanation of the purpose of this patch is available in the patch
> "scsi: Introduce the scsi_status union".
> 
> Cc: Lee Duncan <lduncan@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/libiscsi.c             | 46 ++++++++++++++---------------
>  drivers/scsi/scsi_transport_iscsi.c |  2 +-
>  2 files changed, 24 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 4b8c9b9cf927..6bd81501fa55 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -616,7 +616,7 @@ static void fail_scsi_task(struct iscsi_task *task, enum host_status err)
>  		state = ISCSI_TASK_ABRT_TMF;
>  
>  	sc = task->sc;
> -	sc->result = err << 16;
> +	sc->status.combined = err << 16;
>  	scsi_set_resid(sc, scsi_bufflen(sc));
>  	iscsi_complete_task(task, state);
>  	spin_unlock_bh(&conn->session->back_lock);
> @@ -814,7 +814,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
>  	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
>  
> -	sc->result = (DID_OK << 16) | rhdr->cmd_status;
> +	sc->status.combined = (DID_OK << 16) | rhdr->cmd_status;
>  
>  	if (task->protected) {
>  		sector_t sector;
> @@ -829,7 +829,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  
>  		ascq = session->tt->check_protection(task, &sector);
>  		if (ascq) {
> -			sc->result = DRIVER_SENSE << 24 |
> +			sc->status.combined = DRIVER_SENSE << 24 |
>  				     SAM_STAT_CHECK_CONDITION;
>  			scsi_build_sense_buffer(1, sc->sense_buffer,
>  						ILLEGAL_REQUEST, 0x10, ascq);
> @@ -841,7 +841,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  	}
>  
>  	if (rhdr->response != ISCSI_STATUS_CMD_COMPLETED) {
> -		sc->result = DID_ERROR << 16;
> +		sc->status.combined = DID_ERROR << 16;
>  		goto out;
>  	}
>  
> @@ -853,7 +853,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  			iscsi_conn_printk(KERN_ERR,  conn,
>  					 "Got CHECK_CONDITION but invalid data "
>  					 "buffer size of %d\n", datalen);
> -			sc->result = DID_BAD_TARGET << 16;
> +			sc->status.combined = DID_BAD_TARGET << 16;
>  			goto out;
>  		}
>  
> @@ -870,7 +870,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  
>  	if (rhdr->flags & (ISCSI_FLAG_CMD_BIDI_UNDERFLOW |
>  			   ISCSI_FLAG_CMD_BIDI_OVERFLOW)) {
> -		sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
> +		sc->status.combined = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
>  	}
>  
>  	if (rhdr->flags & (ISCSI_FLAG_CMD_UNDERFLOW |
> @@ -883,11 +883,11 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  			/* write side for bidi or uni-io set_resid */
>  			scsi_set_resid(sc, res_count);
>  		else
> -			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
> +			sc->status.combined = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
>  	}
>  out:
>  	ISCSI_DBG_SESSION(session, "cmd rsp done [sc %p res %d itt 0x%x]\n",
> -			  sc, sc->result, task->itt);
> +			  sc, sc->status.combined, task->itt);
>  	conn->scsirsp_pdus_cnt++;
>  	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
>  }
> @@ -912,7 +912,7 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		return;
>  
>  	iscsi_update_cmdsn(conn->session, (struct iscsi_nopin *)hdr);
> -	sc->result = (DID_OK << 16) | rhdr->cmd_status;
> +	sc->status.combined = (DID_OK << 16) | rhdr->cmd_status;
>  	conn->exp_statsn = be32_to_cpu(rhdr->statsn) + 1;
>  	if (rhdr->flags & (ISCSI_FLAG_DATA_UNDERFLOW |
>  	                   ISCSI_FLAG_DATA_OVERFLOW)) {
> @@ -923,12 +923,12 @@ iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		     res_count <= sc->sdb.length))
>  			scsi_set_resid(sc, res_count);
>  		else
> -			sc->result = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
> +			sc->status.combined = (DID_BAD_TARGET << 16) | rhdr->cmd_status;
>  	}
>  
>  	ISCSI_DBG_SESSION(conn->session, "data in with status done "
>  			  "[sc %p res %d itt 0x%x]\n",
> -			  sc, sc->result, task->itt);
> +			  sc, sc->status.combined, task->itt);
>  	conn->scsirsp_pdus_cnt++;
>  	iscsi_complete_task(task, ISCSI_TASK_COMPLETED);
>  }
> @@ -1678,7 +1678,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  	struct iscsi_conn *conn;
>  	struct iscsi_task *task = NULL;
>  
> -	sc->result = 0;
> +	sc->status.combined = 0;
>  	sc->SCp.ptr = NULL;
>  
>  	ihost = shost_priv(host);
> @@ -1689,7 +1689,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  
>  	reason = iscsi_session_chkready(cls_session);
>  	if (reason) {
> -		sc->result = reason;
> +		sc->status.combined = reason;
>  		goto fault;
>  	}
>  
> @@ -1708,29 +1708,29 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  			 */
>  			if (unlikely(system_state != SYSTEM_RUNNING)) {
>  				reason = FAILURE_SESSION_FAILED;
> -				sc->result = DID_NO_CONNECT << 16;
> +				sc->status.combined = DID_NO_CONNECT << 16;
>  				break;
>  			}
>  			fallthrough;
>  		case ISCSI_STATE_IN_RECOVERY:
>  			reason = FAILURE_SESSION_IN_RECOVERY;
> -			sc->result = DID_IMM_RETRY << 16;
> +			sc->status.combined = DID_IMM_RETRY << 16;
>  			break;
>  		case ISCSI_STATE_LOGGING_OUT:
>  			reason = FAILURE_SESSION_LOGGING_OUT;
> -			sc->result = DID_IMM_RETRY << 16;
> +			sc->status.combined = DID_IMM_RETRY << 16;
>  			break;
>  		case ISCSI_STATE_RECOVERY_FAILED:
>  			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
> -			sc->result = DID_TRANSPORT_FAILFAST << 16;
> +			sc->status.combined = DID_TRANSPORT_FAILFAST << 16;
>  			break;
>  		case ISCSI_STATE_TERMINATE:
>  			reason = FAILURE_SESSION_TERMINATE;
> -			sc->result = DID_NO_CONNECT << 16;
> +			sc->status.combined = DID_NO_CONNECT << 16;
>  			break;
>  		default:
>  			reason = FAILURE_SESSION_FREED;
> -			sc->result = DID_NO_CONNECT << 16;
> +			sc->status.combined = DID_NO_CONNECT << 16;
>  		}
>  		goto fault;
>  	}
> @@ -1738,13 +1738,13 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  	conn = session->leadconn;
>  	if (!conn) {
>  		reason = FAILURE_SESSION_FREED;
> -		sc->result = DID_NO_CONNECT << 16;
> +		sc->status.combined = DID_NO_CONNECT << 16;
>  		goto fault;
>  	}
>  
>  	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
>  		reason = FAILURE_SESSION_IN_RECOVERY;
> -		sc->result = DID_REQUEUE << 16;
> +		sc->status.combined = DID_REQUEUE << 16;
>  		goto fault;
>  	}
>  
> @@ -1766,7 +1766,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  				reason = FAILURE_OOM;
>  				goto prepd_reject;
>  			} else {
> -				sc->result = DID_ABORT << 16;
> +				sc->status.combined = DID_ABORT << 16;
>  				goto prepd_fault;
>  			}
>  		}
> @@ -2017,7 +2017,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *sc)
>  		 * upper layer to deal with the result.
>  		 */
>  		if (unlikely(system_state != SYSTEM_RUNNING)) {
> -			sc->result = DID_NO_CONNECT << 16;
> +			sc->status.combined = DID_NO_CONNECT << 16;
>  			ISCSI_DBG_EH(session, "sc on shutdown, handled\n");
>  			rc = BLK_EH_DONE;
>  			goto done;
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 4f821118ea23..b34155d285be 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1534,7 +1534,7 @@ static int iscsi_bsg_host_dispatch(struct bsg_job *job)
>  	/* return the errno failure code as the only status */
>  	BUG_ON(job->reply_len < sizeof(uint32_t));
>  	reply->reply_payload_rcv_len = 0;
> -	reply->result = ret;
> +	reply->status.combined = ret;
>  	job->reply_len = sizeof(uint32_t);
>  	bsg_job_done(job, ret, 0);
>  	return 0;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

