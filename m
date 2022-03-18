Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31ADAC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 17:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239698AbiCRRih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 13:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbiCRRif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 13:38:35 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C793076FE
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 10:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647625033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5aDFxh1l98qlsbPWdK3r49bBhGMm9x3X4Vzyd0OnZY=;
        b=kLu4Zgr0c1d+ei3jNCPCS0DMYozq96nb8IuTxz6Z1ch6veRn5rKW1jJR12BiBdlbEgrpFZ
        xWqvLj8ehFg8IP99Ak0Op+emdrcY0bPazVP3WwZU+urQcCT33ziJGgtCWyhQ35hFU2ZKmI
        7Q1pt4kvx+OJ5JtykGeALMcPvGvylyY=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-13XLp9QNNtG6vHqwNKa8NQ-1; Fri, 18 Mar 2022 18:37:12 +0100
X-MC-Unique: 13XLp9QNNtG6vHqwNKa8NQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n6abwfq8LCHKCbIxHNNwuhzBSHNewT5+wTtBL0x8923DW6r94DayJ7YR975OZw2594/tqQPn6b/c2zK68r/wZS63c0CdCdzpqHSGCn9QSdKcwr70iPi/13ufSq9DqT45fjod2Q8apEEJfn4ThZHHkOi/3sWSF4amsX/X7XXIDLXxTrW99oE1c9JRziUqLNs0kaPkD1j7RvCfPzn5kda65V9ZEUaOjX3LadxE2LDuatNGFS70qISkU7FkQZDimCPoE7hqiOwNT9MoEUGKGr8X+6uZ8SvY+Nnrtyddya3I62NSCqfzkmUKF7VENyVTrwi6GwBHGX66MBk0dw6ybZ5q4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s5aDFxh1l98qlsbPWdK3r49bBhGMm9x3X4Vzyd0OnZY=;
 b=DZPwqbt4iHyI54Uyj1V6n38gclhCIL6uETLDeUD+vvb/8J6WQYbfurvrg8a6WdHO+xWkZ21ajBRmbvugbV3GWE1D5hEI3mW+j+C1itOdAkvn5QYXghpFObZOTMaEnPhVddNw6st3iHxS154Emn2INCl1Pq76TfTcJZt9f5OMPFGwldbyBfXK6mtmFQKrVA+pRRmqVTp8auSnPwrQ1PaRSghcneT3TDON0fAbfXT1heqKK/aWrHaDnHC0qeigdvECInhB3HTljb/pTVw2qE8PtmVaEUm6Zs6zdKT0G2AEGeh7J+SDYprWlGtg/+GNoXRSVNml6ketCHaprTggUUHs/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3185.eurprd04.prod.outlook.com (2603:10a6:206:c::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Fri, 18 Mar
 2022 17:37:10 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7%6]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 17:37:10 +0000
Message-ID: <2e31342e-a8ac-3ece-98a1-9b103a0a2ec6@suse.com>
Date:   Fri, 18 Mar 2022 10:37:05 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 10/12] scsi: iscsi: Try to avoid taking back_lock in xmit
 path
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-11-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR1001CA0034.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:2::47) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a756d3e1-3762-46e3-9c9e-08da0905ee52
X-MS-TrafficTypeDiagnostic: AM5PR04MB3185:EE_
X-Microsoft-Antispam-PRVS: <AM5PR04MB31856278942A465769B8E5A0DA139@AM5PR04MB3185.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T56qkeZVuvsWsTsbQq1hsJRVRHrDIg38RMYJjuUYUJ4ydHz8d4pyA1KP9Xxwha/HjqmAHzLHISkaYqQHl5XFdw4EY4vFOIwNSIg8jue3AKe/0jRJU52L5mjyWmPJw1ZElQb2HzjpWiCLkm5VKzVF2ujRSysY4IKT9LAbR5E7M5Ae5g71Yo425U0jkAiKVRtXipO4qER2njRNw9EAVOj/aPUIcc735EXVXP22q7fA+8Sdxik/a1rvsVp1+qVFWNChNX5l2zof/KIFc5EzpjCBAfMgUrT04O9gqnQvVYz8uQhglYU8i7rfAlhP8g13nNkEbVehnuNPlAPpiGGaGHixMP4YgwY5xE92qexmlCqydFMkUqDN142znQqDzxySeivAkuXkY2KSt8bnVY7kPUI2rK8M8LdSklnGEe6Qe+Pn2MrAQdXoMZHTLduJPhzXVEeDGrGWsZbiAXxxwjuhhvkc4dCl4bXYFmrBHK1diYkbPmUMyFz9L8NrW59hFoUfmoqV/XUeyfq9nGq9/baSVXB/MArY7xeiXv2gL0ezt481oa2NrgHFwInR4xxFUZ1cp03+ehHszXhduxxLHcyXzfshXyjBfQ6O3n2ybRj+Tt/Ki95AVqmDzCFzH6eYHcLyrngxPP226g+2tSQiJ7ZsafCI3wTd2E5K6wRs/G+YohsE+stIAS5k2tf6MlSq4+UIF4lpMiYVR61Ew+S1bNAP9DqFrCoSTP8OZpcX/jDL/ocpyWg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(508600001)(66946007)(316002)(86362001)(31696002)(8676002)(36756003)(31686004)(66556008)(6486002)(66476007)(6666004)(6506007)(53546011)(2906002)(8936002)(83380400001)(26005)(186003)(2616005)(5660300002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0pSd2dBOXFJRFZNOVlYUGN4VkF3THVtRG02YThtcE1kUEZ5aEoreHBqbmtH?=
 =?utf-8?B?dUtoQ1U3MEVYaTdwNVhyalhQaXlVbzZlWmtZL0kxRWQzMnNRSkJHZzRKbWo4?=
 =?utf-8?B?YW16S1hJekdBb1p3SnlTRWtpN2lmOHljMkZFditDWGs5NnBTNFVrbkxBY1FD?=
 =?utf-8?B?ejZ1d3BTczdHbnBGRGpDYnBqSXJ0QS96clVzVk9nSHVsQ2EzbU5tWDNVcisz?=
 =?utf-8?B?N3l1V2R5MzBtYTlxY1gvUVhOeS9meU9xWkkyV2pHcC92dnMxczZsT0ZET1V2?=
 =?utf-8?B?bUNjbzFPZitVSzBqNS96emFYeXlJcGRoc242cUg0bUdKR2hyWVJTMXhRTXcv?=
 =?utf-8?B?N0VnNEtRT2VOQkpodGRqZG1KUFh0MUhlWXk2WE9rS054ZS8zV3UwS05rZUNl?=
 =?utf-8?B?MzJvc3BMYlhMVTIwV3E2Q2JZcGZEdTQycExacHpISUxSMVJ5RXE2L2NBUlJq?=
 =?utf-8?B?NzJPei9URUpCNFpCK1MxSWRYQ0VHeFZIZnVDT05jTTdFMDRBSGd3QXdYT0kw?=
 =?utf-8?B?VThwMGl3SVdHaTBVTHVCRzRNdWxmVHRRQ0UzWUJ6ZEUzWU5WTGRzejJSWDdM?=
 =?utf-8?B?dVlVN1RaUDVWU3ZoYXpLb0JqL3pUc1ZTRnRvWkFFdVBGd2h0WGFjWGlrM28w?=
 =?utf-8?B?K3llbUQ4N0s3REF1enJsRWQ0QlJKTm9COHlra2c5YldTQ2VRdkhBSEFGMGtO?=
 =?utf-8?B?RFpKNWhKVDZyVG11UWh2ZWtaRkR0VmRCeFlZTUFFdFdxL2puNUtPNEs4VFdm?=
 =?utf-8?B?RGRudlhtMi84azJwL3JadEZkMVJhWUkxRFFBSVk2WnZTM1AyR0NITnhpSVZl?=
 =?utf-8?B?bVVtbXJROWpvT0tZSm9Nb1ZzT3hXbEdYcVlSQVlncWQwMXozNHh0RzFBNDVO?=
 =?utf-8?B?OXUreFI0c0tyR013UmtoS01sekFFQXlVMzZ1RXI3OFZTTit5azErVzl5TGJo?=
 =?utf-8?B?anVGTnZDcTFTYVlVV3M0SUVXY25QVUtUTnJXcGdmeVhWcUJ1aFRUQUY2MU96?=
 =?utf-8?B?Q3d0Z0hZanoyM09oLzJ4NDl5SVpsbjVZaXlJOUlvbHByaWtFZXFYWVdYUWwx?=
 =?utf-8?B?KzY1QnpsNkJPV1Z4OExMd2FSOTJKanh2ZVRVa0hVRDc3WXlsVVdNNXh5cE1U?=
 =?utf-8?B?Z253YnB1c3RmSTZxeGF0RkFyRkREMWN0LzZrS293ajFoeWFKT0FWS2YyY2RR?=
 =?utf-8?B?bzhmaEN4NldCVmZCV0EyRmc0NW9UWGVPdGhnUUkvSVQ5ZmdTYWwxclNlNmx4?=
 =?utf-8?B?cHlQNHU3K1FqNjFtQksvdGlORGF3bUJteW5UbXBzV2NxSU5KQ2FFMDBrK3pZ?=
 =?utf-8?B?QTZ5cmNHQXpCTzJDZDkyT0w3emhuR0xReFV0V1owbWdjY2FmVnoxZ2VNcDdy?=
 =?utf-8?B?Rnl3cVdWODBuUDN0YnBBL1Q5WTRqa011VVZuYmJDRWNDYWZLRjQ1UnNFSVcx?=
 =?utf-8?B?ekxRM2pRMlQ2eW81bFFSYk9iYTNYbVFrV2U5bk41cndQL0tHTkNTOFRuWUhG?=
 =?utf-8?B?eFIxK0k1bVRFczVXWm1VM2dhMlkzN3ljUzVhNTVrMWVPMmhsY2NYaVViTEhH?=
 =?utf-8?B?MlF0ZDVtOG1lbjEvTnRseUZzN1d5SVQ4YmswdWk1Q0hJa2xPNzVPcmJtVFVZ?=
 =?utf-8?B?bHc5dm12UDFCWUowd2dwekN0TUE1WHF0anRGUWlxWjVPMmYwbDFHT29SQ3RT?=
 =?utf-8?B?V3B6U2UrY21ya2crNGdTVllRR0ZZaVYxRDlRTTN1ZnNRNDV2NXZpcXo0Qjdq?=
 =?utf-8?B?R3ptek1nOWpBK2xjQ1puUDRtQ1FvdzdERE5jY2Q5ZEJIWHFVek4zSWMyc3p5?=
 =?utf-8?B?Y0ZOV09NZTdVUWlOMUgwMks2OWVWNHhENnF5bVdqTWRPWkZML0Z0a1c3bjJF?=
 =?utf-8?B?TDYyQXZUTTNxd2haNloyNWxtTXIyZWw5VXRmM003K09SMktXYm1hN2VJa0Vv?=
 =?utf-8?Q?hKsUtBG/tKUnlLnhiHEdAu+dcQMNb3F4?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a756d3e1-3762-46e3-9c9e-08da0905ee52
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 17:37:10.5161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rInlpMisasz646FZ/RXcEJo/zT5x0zer2c0UtGTY/UwryHHlHrtfrWxGbzDx8jFdtfLmBrAToak093/3awP+Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3185
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> We need the back lock when freeing a task, so we hold it when calling
> __iscsi_put_task from the completion path to make it easier and to avoid
> having to retake it in that path. For iscsi_put_task we just grabbed it
> while also doing the decrement on the refcount but it's only really needed
> if the refcount is zero and we free the task. This modifies iscsi_put_task
> to just take the lock when needed then has the xmit path use it. Normally
> we will then not take the back lock from the xmit path. It will only be
> rare cases where the network is so fast that we get a response right after
> we send the header/data.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 30 ++++++++++++++----------------
>   1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index a2d0daf5bd60..cde389225059 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -490,6 +490,12 @@ bool iscsi_get_task(struct iscsi_task *task)
>   }
>   EXPORT_SYMBOL_GPL(iscsi_get_task);
>   
> +/**
> + * __iscsi_put_task - drop the refcount on a task
> + * @task: iscsi_task to drop the refcount on
> + *
> + * The back_lock must be held when calling in case it frees the task.
> + */
>   void __iscsi_put_task(struct iscsi_task *task)
>   {
>   	if (refcount_dec_and_test(&task->refcount))
> @@ -501,10 +507,11 @@ void iscsi_put_task(struct iscsi_task *task)
>   {
>   	struct iscsi_session *session = task->conn->session;
>   
> -	/* regular RX path uses back_lock */
> -	spin_lock_bh(&session->back_lock);
> -	__iscsi_put_task(task);
> -	spin_unlock_bh(&session->back_lock);
> +	if (refcount_dec_and_test(&task->refcount)) {
> +		spin_lock_bh(&session->back_lock);
> +		iscsi_free_task(task);
> +		spin_unlock_bh(&session->back_lock);
> +	}
>   }
>   EXPORT_SYMBOL_GPL(iscsi_put_task);
>   
> @@ -1453,8 +1460,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   {
>   	int rc;
>   
> -	spin_lock_bh(&conn->session->back_lock);
> -
>   	if (!conn->task) {
>   		/*
>   		 * Take a ref so we can access it after xmit_task().
> @@ -1463,7 +1468,6 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   		 * stopped the xmit thread. WARN on move on.
>   		 */
>   		if (!iscsi_get_task(task)) {
> -			spin_unlock_bh(&conn->session->back_lock);
>   			WARN_ON_ONCE(1);
>   			return 0;
>   		}
> @@ -1477,7 +1481,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   	 * case a bad target sends a cmd rsp before we have handled the task.
>   	 */
>   	if (was_requeue)
> -		__iscsi_put_task(task);
> +		iscsi_put_task(task);
>   
>   	/*
>   	 * Do this after dropping the extra ref because if this was a requeue
> @@ -1489,10 +1493,8 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   		 * task and get woken up again.
>   		 */
>   		conn->task = task;
> -		spin_unlock_bh(&conn->session->back_lock);
>   		return -ENODATA;
>   	}
> -	spin_unlock_bh(&conn->session->back_lock);
>   
>   	spin_unlock_bh(&conn->session->frwd_lock);
>   	rc = conn->session->tt->xmit_task(task);
> @@ -1500,10 +1502,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   	if (!rc) {
>   		/* done with this task */
>   		task->last_xfer = jiffies;
> -	}
> -	/* regular RX path uses back_lock */
> -	spin_lock(&conn->session->back_lock);
> -	if (rc) {
> +	} else {
>   		/*
>   		 * get an extra ref that is released next time we access it
>   		 * as conn->task above.
> @@ -1512,8 +1511,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
>   		conn->task = task;
>   	}
>   
> -	__iscsi_put_task(task);
> -	spin_unlock(&conn->session->back_lock);
> +	iscsi_put_task(task);
>   	return rc;
>   }
>   

Reviewed-by: Lee Duncan <lduncan@suse.com>

