Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99354C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 18:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349469AbiCHSsc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 13:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349163AbiCHSsc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 13:48:32 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B6EDFA9
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 10:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646765250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v3ET/yW+yYCzqq/xFckzdJuQjxKm0YgQ4Bq0F8DWSjI=;
        b=Z8Oe/zmEunMv0UqeCjWYqOJLNsIMtVh5cfcLopmSk+OcCr7mO9kbAsrzJe3DKIPaBL+o1G
        jq+CloxPVOOoO91bflnm9vqHS84eRoMv0O4D1rNu+DhkATzsjZBC/h/TpVR6FQpreV9F8r
        YG0t8nJ2k3psaBRPDr86WBzbuzrIwY0=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-4-T5czY9NyMlO6a-53HgBkdg-1; Tue, 08 Mar 2022 19:47:29 +0100
X-MC-Unique: T5czY9NyMlO6a-53HgBkdg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V98dSNs8/F6fbb606iifgJ3iJGbwEpeHhdVXARX2HuVcB467UGmzk1pONdbE3rWL9OKE5SVFzubfaOnf3m+wZuv474rZr6BQLp01dEeyU5oyZYeXb4ev31trhcDLlQjuw5fT2tnH8muH05AIC1ueU13VEMSQUi9FVol4X9o/JkUaMhuvh2Pgg6VopuGlgrNFo1h0ZnA22kSytH6KIlY5TtYOHLQSIONMuEOTyK84kBPe6XL+PwGGH89AcR9EVQEKwgW2J+J0uxy36jFOcrq1Iu2C5/WuvVAnQm/wTa1CvreRgeEFmY8zd+7WlnBHl7wHxvJE6I64xF2BZis93rrW4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v3ET/yW+yYCzqq/xFckzdJuQjxKm0YgQ4Bq0F8DWSjI=;
 b=jkan2M45g3gQwPsfV519HeY8odF50bGkZQ901eL8jvLkA+kPV2sr4EUFzjD/tWJxYn63QElfcQCJkDrHD3IfA7duAy7sDzJP4XqDTi3Zff5AmKM1FTPN43MEmySbjobTswLtpiNP/Oeo++2QkVSA1fUX5gxj0GiGP3JRAuSMJQ3FwUegiedlZSWuokfqbBqRSohv/LcJ+dEEndUGvhHLXHEhshgByqFtVO7jUsn3xgTcFPYOhuNY199wADzx91o5nZrwjLSpTeClA1wSmZYyPcsnS6TVuSf9hGr+AFp98Wred+Fq40DPrZtHHqpg+7K+uWsLaXLj1SSKX3DDCaX0Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB6771.eurprd04.prod.outlook.com (2603:10a6:208:18d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 18:47:28 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 18:47:28 +0000
Message-ID: <e34273a1-3e85-2ce2-f4fc-082040ce709a@suse.com>
Date:   Tue, 8 Mar 2022 10:47:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 01/12] scsi: iscsi: Merge suspend fields
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0038.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::21) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13793a02-c1d4-47f8-4cea-08da01341834
X-MS-TrafficTypeDiagnostic: AM0PR04MB6771:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6771259216FA9A39E165F7D7DA099@AM0PR04MB6771.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: suY8NkROjvMDNx6rmmICqhB8sRKdRyqmz5Ae0bwMvwZwx9JemmTtMYy/Xu4929uKEXWTz5f0/YH7RS0tWtc2bC06SJuu0QH+lmOZNlgmeksS4IgnDfMfIcLygYivp6TeL9p9hlCsQZFDNMQEzK8PR4b0EMvMwjrIsA93wRajgWr5QKgck64+wcsJ8Ef8YkBam5kKKsmkWXEhtfXIe4edZuHiD8J6LdOgCu+5zU0BExfBeTU7D2LNjdbbkEiPqON3i3KHko4C9N6T2Zy1wyShdhWvXSamjurx5XNnpKP1pYGAASO4NXs6ez2n4nFiyoRlpepqnid6FIMzmnvh8Z2uDAnHQZcO6j8d69JUeTn8s8hbmQJZDCEPPoFFCFMxDteLQWZzGT3Eg6IffYai/D2oRpjeEGmCUZtl8VX+7M6kTxpfR0J/9MbSpnNHLsSKWGhPpqQ/sTki8eqmrZiR4K+7joaKCjFCN3T0rHov4AYiCa3X+v07IdxHged0bKtYUvjkJzmJLpPRh3fo9rvKmIjHpuDDdzBSsmf8qYHplpBnWBTMh9ezyTdgQK529MF+ldb8M8WbofJx1z0v94torM21r+auA5XFr5uJIkSiKYyGX7fayxgsuiXqNTp+1sq4ZZSiaB7NvugfL7Kw05rRiZnYHLTNHirAuckGRRD1gcsrTJY22ev6C6nHsK27KWqpEGibsGfFzvXOof42jnBNrkORD8hPsWtu44MtIGNb4hmmOFo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(5660300002)(186003)(38100700002)(8936002)(66946007)(2616005)(316002)(8676002)(66476007)(86362001)(66556008)(6512007)(31696002)(6506007)(83380400001)(15650500001)(6666004)(31686004)(53546011)(6486002)(2906002)(508600001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RCtadi90Y1FaWlczd0N6MnFBb3puZWYxUlMyWDRubjQ1dlkrbExuMlpkVE1D?=
 =?utf-8?B?UEVUT0RxWWN0cE51TEVPall5NDdRZHlUSUIyM2hvRVBybExRRG8yYWpEazRv?=
 =?utf-8?B?cVN4RVhtZGJEdE8xekRjL3RwYUhldXlqbFd2eUl1YVRkZkhzQnFCNjNIYmQy?=
 =?utf-8?B?YUt4MFY4S005aDlQTlFZWk1ucVMrWGZlclJuRnBORG9ydmxRQmRSZW8zbGh6?=
 =?utf-8?B?UlprazdqZW9MZVBsblJIaEI4M0RHNlZtWU5QNHpRMld1WkI3MStuYnVSQUw0?=
 =?utf-8?B?SnVHOEJ6OSt2VVQ4aXFkSjZ2Q3B2L3VpNGptaEpwcGJpMzJFUmplSXlQZ1hT?=
 =?utf-8?B?TEROTGNyVC93RnY4alhEMTVIUjdPREY1MDdIVFh2ZFBZVms0anNDRDFqTDRv?=
 =?utf-8?B?ZFNKVGFlMlBZTXRSbDJlZGFycDJxOTNpOW9ReSt0VmJBc3JVejFSbVVmUVJ2?=
 =?utf-8?B?Qk9pb2xydXNCSkdWaEM2ZjZzMlRpWnBNSjVhdEt2SEQ3MTd6dWszZzBiTlNo?=
 =?utf-8?B?RFJCU0VXeFdaWEs5K3hsNjR2ZFlwOHk3eG82V1R4OTFuMk5qSDBaMjYydzNS?=
 =?utf-8?B?azJYekwrQW9wS1pYa0NocW1scXZUUU9EWE83cDM0bGRRZmhLS2F4TGx2STNQ?=
 =?utf-8?B?VW5mQkdDMnpsN1NySWVpUExpSmpzVWQyYXk2cHcwNlhxWXpyaGtqMFN6YVNn?=
 =?utf-8?B?SkdsQjRYT2cyZEViemhuUUtJMDNMWWx0dXRjbTlkUHQyc29uQWsvMHVwcU4r?=
 =?utf-8?B?NGE2cFMwQ2c5RW8ydm16ZDUzSlRlaDNvUFBabTh0OFpHR1IrN1p4NUVyZHYy?=
 =?utf-8?B?UGl3SXJyeXdtam9XUGs3ZW5kTTNCVnZ3YUhyYjEyaFZEVExLRyttWFZjMUZq?=
 =?utf-8?B?OXMySFhqSXQ4M1k2Zy9Bb2xudkhPRUlscGMxTjZRN05Vc3dlbEJLSjA2K0VU?=
 =?utf-8?B?WTJnZjk4b0NXazMzV3Y0ME55T1NBOEY3d2wzK1hjQ3BxZEtYOEdNV3FuVjhs?=
 =?utf-8?B?KzlCd3FxbmlITldtYlRJZWxBNUt1dDRDT3FrT3NnaTVodUtsYU1QWGp2ZS96?=
 =?utf-8?B?azY1dFlvQ2RoeXhIUG1pZTZCYTkzZkpteFNqYVVocUt2WUJ6ck9nLzRLM1Nn?=
 =?utf-8?B?Q29mOTUwaHJQZEtUSTVUSzYrRWNPQUZIb3Uyd1I2VTk5OGxLYXVUQmI3TFJi?=
 =?utf-8?B?dUNRcmkxRC9nTnR6WGJQYWRXbmZlTW1mZjVUWWVuUjRpT3Z2TkF6ZEFQWUNE?=
 =?utf-8?B?RHpLdmR0YTFKeWVray9tZDhCZUs5OXp1YS9JWFpjZXdMTC9JUTdXclp2aXVT?=
 =?utf-8?B?Q2diUko2M0pDTmExZGxDeG1Hamdodkl0N2hOM05id0lqdERRcUVWSWxaY1l1?=
 =?utf-8?B?RE5STG1GeTRMRmRTWWZkMWdGajlPNytxbVFvMjJjM2g2bFhDdVp2SVVGdlVj?=
 =?utf-8?B?ODlGK3lEbVFLamFMbUllcDIvWlFjTVkzWEJISkJrcmQ0SnhSMlJZSVpscGpB?=
 =?utf-8?B?YlRlN2h5QlI1M2pXOEhYS0lRSnczZ2pnMXR4UlpjUC82eDZOUDI4dWQ3cWhq?=
 =?utf-8?B?MTNpYUEySGNrV0IxN1MxU1BwT3VvdzY5OFQ2M3Q4TkxPekhmcFBqV1JPbE9o?=
 =?utf-8?B?TDNTMVd2b0dSYmtnSzMxSnRCK0R6NVp1YVNSeld6R1RVVTN2eFNrREpPWDBR?=
 =?utf-8?B?Qm4rbEowSkNUMnh1MFpZVHgrQUZxVlh5b1N3ZSsvTjNxVTBBemRYYXo1ZXpN?=
 =?utf-8?B?SHBoVlI1cWg2Nkp3YlFOVEtXazVrcjRiQmt6dnVIa3d3NEtEc1dXdXYra2ww?=
 =?utf-8?B?Q0NVTjRjaWgza0JrV0xtdkZQYUNtVk9UWTliYnpDcklRS0NwK3lGQ0FKS3dj?=
 =?utf-8?B?QVQwcVQrVzlkaU9rejhocHBnckcrbkZ1RXFlNHI5NWV0N2tXV3IzU1l3cnll?=
 =?utf-8?B?ZXBhYjdha1p6ajdvM05IRzdIWWtJOFpQMEJoRnhhVWo2QlZpNjJaYVFzOGZQ?=
 =?utf-8?B?djVWZDY0YVhlMjhZd0hJWk9ydThySDJBRFJxamJBektqamI1ajJrVjN2OGY2?=
 =?utf-8?B?QklaM1ZUNEh3MTdqZGxEVDRKY3JENkhxak5IMnBPYjVrM2RwS1h2NFlabUk5?=
 =?utf-8?B?UTBtbnBsUGdvSHJscnQ3UkFDYXRBbFFVWWlHSTZ5T1ZLcW9RNXhpcFFZZkF2?=
 =?utf-8?Q?3WK19ccSAtjSUGCG3cbgTko=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13793a02-c1d4-47f8-4cea-08da01341834
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 18:47:28.3604
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mkuqZ1yuSK5IjfGejSBtM5W62iL/9/IhQOR6MJZUcptatOkPPAAWE+s3ewrIcylXiuFWl5Xah55G8YxjPzF1pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6771
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> Move the tx and rx suspend fields into one flags field.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/bnx2i/bnx2i_hwi.c   |  2 +-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |  2 +-
>   drivers/scsi/cxgbi/libcxgbi.c    |  6 +++---
>   drivers/scsi/libiscsi.c          | 20 ++++++++++----------
>   drivers/scsi/libiscsi_tcp.c      |  2 +-
>   include/scsi/libiscsi.h          |  9 +++++----
>   6 files changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> index 5521469ce678..e16327a4b4c9 100644
> --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> @@ -1977,7 +1977,7 @@ static int bnx2i_process_new_cqes(struct bnx2i_conn *bnx2i_conn)
>   		if (nopin->cq_req_sn != qp->cqe_exp_seq_sn)
>   			break;
>   
> -		if (unlikely(test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx))) {
> +		if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
>   			if (nopin->op_code == ISCSI_OP_NOOP_IN &&
>   			    nopin->itt == (u16) RESERVED_ITT) {
>   				printk(KERN_ALERT "bnx2i: Unsolicited "
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index e21b053b4f3e..a592ca8602f9 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1721,7 +1721,7 @@ static int bnx2i_tear_down_conn(struct bnx2i_hba *hba,
>   			struct iscsi_conn *conn = ep->conn->cls_conn->dd_data;
>   
>   			/* Must suspend all rx queue activity for this ep */
> -			set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> +			set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
>   		}
>   		/* CONN_DISCONNECT timeout may or may not be an issue depending
>   		 * on what transcribed in TCP layer, different targets behave
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 8c7d4dda4cf2..4365d52c6430 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -1634,11 +1634,11 @@ void cxgbi_conn_pdu_ready(struct cxgbi_sock *csk)
>   	log_debug(1 << CXGBI_DBG_PDU_RX,
>   		"csk 0x%p, conn 0x%p.\n", csk, conn);
>   
> -	if (unlikely(!conn || conn->suspend_rx)) {
> +	if (unlikely(!conn || test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
>   		log_debug(1 << CXGBI_DBG_PDU_RX,
> -			"csk 0x%p, conn 0x%p, id %d, suspend_rx %lu!\n",
> +			"csk 0x%p, conn 0x%p, id %d, conn flags 0x%lx!\n",
>   			csk, conn, conn ? conn->id : 0xFF,
> -			conn ? conn->suspend_rx : 0xFF);
> +			conn ? conn->flags : 0xFF);
>   		return;
>   	}
>   
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index a75b85f0a189..14f5737429cf 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1392,8 +1392,8 @@ static bool iscsi_set_conn_failed(struct iscsi_conn *conn)
>   	if (conn->stop_stage == 0)
>   		session->state = ISCSI_STATE_FAILED;
>   
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
>   	return true;
>   }
>   
> @@ -1454,7 +1454,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   	 * Do this after dropping the extra ref because if this was a requeue
>   	 * it's removed from that list and cleanup_queued_task would miss it.
>   	 */
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
>   		/*
>   		 * Save the task and ref in case we weren't cleaning up this
>   		 * task and get woken up again.
> @@ -1532,7 +1532,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>   	int rc = 0;
>   
>   	spin_lock_bh(&conn->session->frwd_lock);
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
>   		ISCSI_DBG_SESSION(conn->session, "Tx suspended!\n");
>   		spin_unlock_bh(&conn->session->frwd_lock);
>   		return -ENODATA;
> @@ -1746,7 +1746,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>   		goto fault;
>   	}
>   
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +	if (test_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags)) {
>   		reason = FAILURE_SESSION_IN_RECOVERY;
>   		sc->result = DID_REQUEUE << 16;
>   		goto fault;
> @@ -1935,7 +1935,7 @@ static void fail_scsi_tasks(struct iscsi_conn *conn, u64 lun, int error)
>   void iscsi_suspend_queue(struct iscsi_conn *conn)
>   {
>   	spin_lock_bh(&conn->session->frwd_lock);
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>   	spin_unlock_bh(&conn->session->frwd_lock);
>   }
>   EXPORT_SYMBOL_GPL(iscsi_suspend_queue);
> @@ -1953,7 +1953,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
>   	struct Scsi_Host *shost = conn->session->host;
>   	struct iscsi_host *ihost = shost_priv(shost);
>   
> -	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	set_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>   	if (ihost->workq)
>   		flush_workqueue(ihost->workq);
>   }
> @@ -1961,7 +1961,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
>   
>   static void iscsi_start_tx(struct iscsi_conn *conn)
>   {
> -	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>   	iscsi_conn_queue_work(conn);
>   }
>   
> @@ -3321,8 +3321,8 @@ int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
>   	/*
>   	 * Unblock xmitworker(), Login Phase will pass through.
>   	 */
> -	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
> -	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
> +	clear_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags);
> +	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(iscsi_conn_bind);
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 2e9ffe3d1a55..883005757ddb 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -927,7 +927,7 @@ int iscsi_tcp_recv_skb(struct iscsi_conn *conn, struct sk_buff *skb,
>   	 */
>   	conn->last_recv = jiffies;
>   
> -	if (unlikely(conn->suspend_rx)) {
> +	if (unlikely(test_bit(ISCSI_CONN_FLAG_SUSPEND_RX, &conn->flags))) {
>   		ISCSI_DBG_TCP(conn, "Rx suspended!\n");
>   		*status = ISCSI_TCP_SUSPENDED;
>   		return 0;
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 2d85810d1929..10a9b89b7448 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -52,8 +52,10 @@ enum {
>   
>   #define ISID_SIZE			6
>   
> -/* Connection suspend "bit" */
> -#define ISCSI_SUSPEND_BIT		1
> +/* Connection flags */
> +#define ISCSI_CONN_FLAG_SUSPEND_TX	BIT(0)
> +#define ISCSI_CONN_FLAG_SUSPEND_RX	BIT(1)
> +
>   
>   #define ISCSI_ITT_MASK			0x1fff
>   #define ISCSI_TOTAL_CMDS_MAX		4096
> @@ -199,8 +201,7 @@ struct iscsi_conn {
>   	struct list_head	cmdqueue;	/* data-path cmd queue */
>   	struct list_head	requeue;	/* tasks needing another run */
>   	struct work_struct	xmitwork;	/* per-conn. xmit workqueue */
> -	unsigned long		suspend_tx;	/* suspend Tx */
> -	unsigned long		suspend_rx;	/* suspend Rx */
> +	unsigned long		flags;		/* ISCSI_CONN_FLAGs */
>   
>   	/* negotiated params */
>   	unsigned		max_recv_dlength; /* initiator_max_recv_dsl*/

Reviewed-by: Lee Duncan <lduncan@suse.com>

