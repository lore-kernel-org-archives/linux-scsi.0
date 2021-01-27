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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FACC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 22:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD73964DDE
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 22:54:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhA0Ww0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 17:52:26 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:56855 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230527AbhA0WwL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 17:52:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611787860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1AsVvb3csZhZe+0NJ2l4AOdWdwYVjGHoYhCn3P5U/a0=;
        b=VDMERD31Oz9yi6IYhBzBsek6WVr3nNrfkSKVfwU364B9218CRIKstJn4mkf9JpVXekPFRA
        Lb41JOI2YvbfHNG5qSfrBq8qRE3wqt+ptLLA0wR7wHf9IUjL0CvIy/lge5scEcRrTeNwYO
        PD8H/BB1G2+UcgKtIQ4aaZAoN0FtbOE=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2054.outbound.protection.outlook.com [104.47.13.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-QkfU1CNeMhGX_s7Mjx3bBQ-1; Wed, 27 Jan 2021 23:30:55 +0100
X-MC-Unique: QkfU1CNeMhGX_s7Mjx3bBQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaN9nM/NdbYHeVuPopkKou8HPxwSWLODMr6QCH9qwLeW3OhTCDtuVec/fKOWDQxtUt/ssKa8lTiFWbLAErsUaWsTwHRRnmuWkTw6WYRoHew9EicrIej6/sKluxmCyHKkUcij5rHjr9Vqn5DwY5rJRtlt2OYopAyxkluc1lhA0zqiEZ9pdQA0nSt3S2JWd4zGisPwfPjiJxQZI3fccZqwOvV9Or62KDLH8ZNDKZ+rWwGGxWdcCqznGQyEcpSc3V1UjQAgJHlfX5JXObY3VKWpm452FC/SgP5E0JE4f8oJCnNFncOHszC5+QdmvKoQszitJ0g40WJlT6gywGNAIV3xZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1AsVvb3csZhZe+0NJ2l4AOdWdwYVjGHoYhCn3P5U/a0=;
 b=WUPc734CQ3HGvC9d/APUCBnrbtniNoj+8WD8/aCVjh9O0b9kTbhKeHa/51OQdAfibJwo7WMHOo9S+UTQK9h4VVJQreydnFwQIlLL4sqhPdkB4vDKGuWxgg6Xz/GczvA1OJxExDlC190296t7bZgysyhzj2Io5ODlnUAhLuKyLS30G9Uj9gDwEaiJrP81NoMOtuzP3zl1zWorQ+zrUxhCWKSmpD8onHCU/YS4CCBFmarne9v/p65GojUfr4Wpgg5Tdhv2STj7n0FR3bpvG7paS616lt0UtPwvo5isYLtjyshTy+LA7REE4DqGJRTQjsyS9GjOauvDKAc/0t3Eh8fKsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB6023.eurprd04.prod.outlook.com (2603:10a6:20b:bb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Wed, 27 Jan
 2021 22:30:38 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::c60:6150:342e:e042%6]) with mapi id 15.20.3805.016; Wed, 27 Jan 2021
 22:30:38 +0000
Subject: Re: [PATCH 2/7] libiscsi: drop taskqueuelock
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     lutianxiong@huawei.com, linfeilong@huawei.com,
        liuzhiqiang26@huawei.com, haowenchao@huawei.com
References: <20210118203430.4921-1-michael.christie@oracle.com>
 <20210118203430.4921-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <b2d3e07a-22c5-3156-5357-77cf007392b0@suse.com>
Date:   Wed, 27 Jan 2021 14:30:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
In-Reply-To: <20210118203430.4921-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR04CA0067.eurprd04.prod.outlook.com
 (2603:10a6:208:1::44) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR04CA0067.eurprd04.prod.outlook.com (2603:10a6:208:1::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 22:30:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ba67c15-3f63-4718-ed14-08d8c3132bf0
X-MS-TrafficTypeDiagnostic: AM6PR04MB6023:
X-Microsoft-Antispam-PRVS: <AM6PR04MB60237D8917185A111CF3641CDABB0@AM6PR04MB6023.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eNeKjWe/5Nw81QSZLApdb14X02/l/ZZiktiTC6jEtbodDsm42C+pRAg3dcVFdv5fEfzrTM0CeGetcHvfz+9gO/emIRNi26meG2sxmoZ8IbdXiP3c5sT/oKCdEnMjZBXJcRWfLUzNr9slDxpI1sRb7bAAHpRSCBYkbRDAlK3yM1n6b3I4KRBWroYAFW9rAR1vIbV2WmzRYFN7H8HVLfyb67mgf/Rkz9j+BO41rdDWyW8lloTwnots4JGmrqRbTKEuYFchVR/oOFtCQgoGo1tCgrqa/PmdJRrw72IJL4PPzjAcwJMGH/YxIY6u5KYdJGCyh9j76755DzrBLRsUAC3bH1hX0fGZUV6A08dQts+gsIzPP7XE/m3tG67ZY/lRAM8/oGOEw8xmWBUlLk9SN+MO4B7qM39fPayTB3ryf4oATMBE6lc/ZFtCuoTCY52qOk5M3FKi/j9i4RBXtQ78C7o4F7jdYhHqVtI5F922cfOUgJOxGfgteUaNnxA0eoPHqvpUFlWtCEHa1K5Hn12V4kZaNF+6JUQu9rmyRmgLUb39DRdaWoCNVE8YvjmiSB470lCPAMpK9HyV7nUdDUjaTZQ/7gYbcwX5RGGLLSdCQUSEqrU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(396003)(346002)(136003)(66556008)(66476007)(26005)(66946007)(956004)(2616005)(5660300002)(52116002)(53546011)(316002)(186003)(36756003)(16526019)(16576012)(83380400001)(478600001)(8936002)(6666004)(6486002)(30864003)(4326008)(86362001)(2906002)(31686004)(8676002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dFdHQVl3cWZtS1BnMGsvR1poQWlPN3JwOUFkcFhOMEJWeFplblRFOXNYb0Nw?=
 =?utf-8?B?OC9rcFgrYm5OK3ZvZUtGNDJqVG8rcGxrbVNOd1AydU4wN1Zjb3ZzVWFINDFR?=
 =?utf-8?B?VzE5d2UxaUVlMlRDVG5JZlBnbDQ5SGUyMUFRdUVFYzBZOEdiWDBVSzJiZ3RF?=
 =?utf-8?B?dkphblZqWnNua1psMi9tZENrcllsaHBPajBJZndoemIzQjFRU2NyRVhpQWtQ?=
 =?utf-8?B?R2dJSjZlUkp5QVIwSktOeTYrN0lhVlhmUmQ5dSswUFdib3A0UDhqY1lSaFMv?=
 =?utf-8?B?eVBiV3NrUXU2Tlo3Y1ZEdW51SmsxRUVvblRnUFNLOVNWYXVaYldCNVB3dFA1?=
 =?utf-8?B?UW5Ba29ncEJTS1d3QjltaFdJa2VMMlBlSXFqK1ZZdDNEVG1IUUVkN251eXFZ?=
 =?utf-8?B?Sldia3BJRFE5Tlk1L1ZpR3g2dVBHc1Z2U1BBOXNBYWVwYmpabVc1ZXZoNW84?=
 =?utf-8?B?blJtTEcyYXRJeWNVMzNURHMxbC8xMmZvM0FIc0ErQXhBNFdEY2FlZ3d6NGNm?=
 =?utf-8?B?eXVCM0dseWMxWk1VUnVuTHF0Y0UvT0dVeVMvUmVxUmNWUlArai9QMGtKZ1dB?=
 =?utf-8?B?S1Z3bDVuSVlUaEdKNW5JVnZKZjBPcjBTaWlHOE1mbjBzVEd3UFlIZjJaQXQ2?=
 =?utf-8?B?ZDdZd3JOM1B2aFJWbVRqN2hleEJ5TnJhbjdPQmc0L0pFVWZSQjhvelNZbzg2?=
 =?utf-8?B?K0lkanBvblhqVUlSczRaY1lxK3Z6NnVYSFNiaDgxeEFqaWNHeFR6b1llOVNB?=
 =?utf-8?B?RkI0VE8zZW1VNldNU0hEM2tZeGxLRWxkVU9uNDFvM1QzeTNGZzJqSytEYjd6?=
 =?utf-8?B?cms1Q0tpN1NyT291VWFWN2JtVXdmOStpbjdHakxObThtU2NZbzN5QUZoWUJT?=
 =?utf-8?B?T09YV1hpdFlzK2hJNy82RWtlQ0xKVFY1a2pRaTJhTk9IenBEK1NCeUpacmZ6?=
 =?utf-8?B?MEc1S215L0tzcTBMTzNBTDNnNUxSdXI1VDFvSldQc2JwMEJ4ZWoxZjU3Q0w2?=
 =?utf-8?B?S2lhM0hyOUYxZXo4Mnk2WHBtN0NnNnFOUENpUjlpVzJpZFNzVEdtdFp5Y0dG?=
 =?utf-8?B?ajlvSWtXK0w3K1Z6aW83UGJQZlhoNWFRbUF0RjdITTZJMHpiQm1QVDN0dWRm?=
 =?utf-8?B?bTBMMHAzNk9NQXVxU0NFMHM5Mi9rTlhJV1NVMEZ3QUttN1dQaVZrM2hsSTNm?=
 =?utf-8?B?bzRKSU9uZFVqTVZsa1UvR3VBQnI5TDV6OFJrWFV3UU1KR1RNdEdvWnRJVHVV?=
 =?utf-8?B?Q3BRUFdSYkoyeDk2dnhkSXROTjZ1L1E4RGx1SndSdy9wMEtWVWxZVXlNNHBq?=
 =?utf-8?B?SE15RlFUQUNVdW5Pa0MwRkZBSjE3VVlxZUZEcWtWNFVZN2tpNGFXTjU2WnRk?=
 =?utf-8?B?OXFVcFo4NGx3MnpIeHJJRTA2WStiWjJuV1dWd0syWDRGamdKT1JJTkFJZTE4?=
 =?utf-8?Q?sYj7g7I0?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ba67c15-3f63-4718-ed14-08d8c3132bf0
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 22:30:38.5367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JVshHmqK9nmiv/CMFCtWjU4lhlOpbVMkvi7he8z3di2taZY8qQuHiOhwllHsae8TCIC/pdFsCk+741n+Oj35+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/18/21 12:34 PM, Mike Christie wrote:
> The purpose of the taskqueuelock was to handle the issue where a bad
> target decides to send a R2T and before it's data has been sent
> decides to send a cmd response to complete the cmd. The following
> patches fix up the frwd/back locks so they are taken from the
> queue/xmit (frwd) and completion (back) paths again. To get there
> this patch removes the taskqueuelock which for iscsi xmit wq based
> drivers was taken in the queue, xmit and completion paths.
> 
> Instead of the lock, we just make sure we have a ref to the task
> when we queue a R2T, and then we always remove the task from the
> requeue list in the xmit path or the forced cleanup paths.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c     | 178 +++++++++++++++++++++++-------------
>  drivers/scsi/libiscsi_tcp.c |  84 +++++++++++------
>  include/scsi/libiscsi.h     |   4 +-
>  3 files changed, 171 insertions(+), 95 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index cee1dbaa1b93..3d74fdd9f31a 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -523,16 +523,6 @@ static void iscsi_complete_task(struct iscsi_task *task, int state)
>  	WARN_ON_ONCE(task->state == ISCSI_TASK_FREE);
>  	task->state = state;
>  
> -	spin_lock_bh(&conn->taskqueuelock);
> -	if (!list_empty(&task->running)) {
> -		pr_debug_once("%s while task on list", __func__);
> -		list_del_init(&task->running);
> -	}
> -	spin_unlock_bh(&conn->taskqueuelock);
> -
> -	if (conn->task == task)
> -		conn->task = NULL;
> -
>  	if (READ_ONCE(conn->ping_task) == task)
>  		WRITE_ONCE(conn->ping_task, NULL);
>  
> @@ -564,9 +554,40 @@ void iscsi_complete_scsi_task(struct iscsi_task *task,
>  }
>  EXPORT_SYMBOL_GPL(iscsi_complete_scsi_task);
>  
> +/*
> + * Must be called with back and frwd lock
> + */
> +static bool cleanup_queued_task(struct iscsi_task *task)
> +{
> +	struct iscsi_conn *conn = task->conn;
> +	bool early_complete = false;
> +
> +	/* Bad target might have completed task while it was still running */
> +	if (task->state == ISCSI_TASK_COMPLETED)
> +		early_complete = true;
> +
> +	if (!list_empty(&task->running)) {
> +		list_del_init(&task->running);
> +		/*
> +		 * If it's on a list but still running, this could be from
> +		 * a bad target sending a rsp early, cleanup from a TMF, or
> +		 * session recovery.
> +		 */
> +		if (task->state == ISCSI_TASK_RUNNING ||
> +		    task->state == ISCSI_TASK_COMPLETED)
> +			__iscsi_put_task(task);
> +	}
> +
> +	if (conn->task == task) {
> +		conn->task = NULL;
> +		__iscsi_put_task(task);
> +	}
> +
> +	return early_complete;
> +}
>  
>  /*
> - * session back_lock must be held and if not called for a task that is
> + * session frwd_lock must be held and if not called for a task that is
>   * still pending or from the xmit thread, then xmit thread must
>   * be suspended.
>   */
> @@ -585,6 +606,13 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
>  	if (!sc)
>  		return;
>  
> +	/* regular RX path uses back_lock */
> +	spin_lock_bh(&conn->session->back_lock);
> +	if (cleanup_queued_task(task)) {
> +		spin_unlock_bh(&conn->session->back_lock);
> +		return;
> +	}
> +
>  	if (task->state == ISCSI_TASK_PENDING) {
>  		/*
>  		 * cmd never made it to the xmit thread, so we should not count
> @@ -600,9 +628,6 @@ static void fail_scsi_task(struct iscsi_task *task, int err)
>  
>  	sc->result = err << 16;
>  	scsi_set_resid(sc, scsi_bufflen(sc));
> -
> -	/* regular RX path uses back_lock */
> -	spin_lock_bh(&conn->session->back_lock);
>  	iscsi_complete_task(task, state);
>  	spin_unlock_bh(&conn->session->back_lock);
>  }
> @@ -748,9 +773,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		if (session->tt->xmit_task(task))
>  			goto free_task;
>  	} else {
> -		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->mgmtqueue);
> -		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
>  
> @@ -1411,31 +1434,61 @@ static int iscsi_check_cmdsn_window_closed(struct iscsi_conn *conn)
>  	return 0;
>  }
>  
> -static int iscsi_xmit_task(struct iscsi_conn *conn)
> +static int iscsi_xmit_task(struct iscsi_conn *conn, struct iscsi_task *task,
> +			   bool was_requeue)
>  {
> -	struct iscsi_task *task = conn->task;
>  	int rc;
>  
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx))
> -		return -ENODATA;
> -
>  	spin_lock_bh(&conn->session->back_lock);
> -	if (conn->task == NULL) {
> +
> +	if (!conn->task) {
> +		/* Take a ref so we can access it after xmit_task() */
> +		__iscsi_get_task(task);
> +	} else {
> +		/* Already have a ref from when we failed to send it last call */
> +		conn->task = NULL;
> +	}
> +
> +	/*
> +	 * If this was a requeue for a R2T we have an extra ref on the task in
> +	 * case a bad target sends a cmd rsp before we have handled the task.
> +	 */
> +	if (was_requeue)
> +		__iscsi_put_task(task);
> +
> +	/*
> +	 * Do this after dropping the extra ref because if this was a requeue
> +	 * it's removed from that list and cleanup_queued_task would miss it.
> +	 */
> +	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +		/*
> +		 * Save the task and ref in case we weren't cleaning up this
> +		 * task and get woken up again.
> +		 */
> +		conn->task = task;
>  		spin_unlock_bh(&conn->session->back_lock);
>  		return -ENODATA;
>  	}
> -	__iscsi_get_task(task);
>  	spin_unlock_bh(&conn->session->back_lock);
> +
>  	spin_unlock_bh(&conn->session->frwd_lock);
>  	rc = conn->session->tt->xmit_task(task);
>  	spin_lock_bh(&conn->session->frwd_lock);
>  	if (!rc) {
>  		/* done with this task */
>  		task->last_xfer = jiffies;
> -		conn->task = NULL;
>  	}
>  	/* regular RX path uses back_lock */
>  	spin_lock(&conn->session->back_lock);
> +	if (rc && task->state == ISCSI_TASK_RUNNING) {
> +		/*
> +		 * get an extra ref that is released next time we access it
> +		 * as conn->task above.
> +		 */
> +		__iscsi_get_task(task);
> +		conn->task = task;
> +	}
> +
>  	__iscsi_put_task(task);
>  	spin_unlock(&conn->session->back_lock);
>  	return rc;
> @@ -1445,9 +1498,7 @@ static int iscsi_xmit_task(struct iscsi_conn *conn)
>   * iscsi_requeue_task - requeue task to run from session workqueue
>   * @task: task to requeue
>   *
> - * LLDs that need to run a task from the session workqueue should call
> - * this. The session frwd_lock must be held. This should only be called
> - * by software drivers.
> + * Callers must have taken a ref to the task that is going to be requeued.
>   */
>  void iscsi_requeue_task(struct iscsi_task *task)
>  {
> @@ -1457,11 +1508,18 @@ void iscsi_requeue_task(struct iscsi_task *task)
>  	 * this may be on the requeue list already if the xmit_task callout
>  	 * is handling the r2ts while we are adding new ones
>  	 */
> -	spin_lock_bh(&conn->taskqueuelock);
> -	if (list_empty(&task->running))
> +	spin_lock_bh(&conn->session->frwd_lock);
> +	if (list_empty(&task->running)) {
>  		list_add_tail(&task->running, &conn->requeue);
> -	spin_unlock_bh(&conn->taskqueuelock);
> +	} else {
> +		/*
> +		 * Don't need the extra ref since it's already requeued and
> +		 * has a ref.
> +		 */
> +		iscsi_put_task(task);
> +	}
>  	iscsi_conn_queue_work(conn);
> +	spin_unlock_bh(&conn->session->frwd_lock);
>  }
>  EXPORT_SYMBOL_GPL(iscsi_requeue_task);
>  
> @@ -1487,7 +1545,7 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  	}
>  
>  	if (conn->task) {
> -		rc = iscsi_xmit_task(conn);
> +		rc = iscsi_xmit_task(conn, conn->task, false);
>  	        if (rc)
>  		        goto done;
>  	}
> @@ -1497,49 +1555,41 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  	 * only have one nop-out as a ping from us and targets should not
>  	 * overflow us with nop-ins
>  	 */
> -	spin_lock_bh(&conn->taskqueuelock);
>  check_mgmt:
>  	while (!list_empty(&conn->mgmtqueue)) {
> -		conn->task = list_entry(conn->mgmtqueue.next,
> -					 struct iscsi_task, running);
> -		list_del_init(&conn->task->running);
> -		spin_unlock_bh(&conn->taskqueuelock);
> -		if (iscsi_prep_mgmt_task(conn, conn->task)) {
> +		task = list_entry(conn->mgmtqueue.next, struct iscsi_task,
> +				  running);
> +		list_del_init(&task->running);
> +		if (iscsi_prep_mgmt_task(conn, task)) {
>  			/* regular RX path uses back_lock */
>  			spin_lock_bh(&conn->session->back_lock);
> -			__iscsi_put_task(conn->task);
> +			__iscsi_put_task(task);
>  			spin_unlock_bh(&conn->session->back_lock);
> -			conn->task = NULL;
> -			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
>  		}
> -		rc = iscsi_xmit_task(conn);
> +		rc = iscsi_xmit_task(conn, task, false);
>  		if (rc)
>  			goto done;
> -		spin_lock_bh(&conn->taskqueuelock);
>  	}
>  
>  	/* process pending command queue */
>  	while (!list_empty(&conn->cmdqueue)) {
> -		conn->task = list_entry(conn->cmdqueue.next, struct iscsi_task,
> -					running);
> -		list_del_init(&conn->task->running);
> -		spin_unlock_bh(&conn->taskqueuelock);
> +		task = list_entry(conn->cmdqueue.next, struct iscsi_task,
> +				  running);
> +		list_del_init(&task->running);
>  		if (conn->session->state == ISCSI_STATE_LOGGING_OUT) {
> -			fail_scsi_task(conn->task, DID_IMM_RETRY);
> -			spin_lock_bh(&conn->taskqueuelock);
> +			fail_scsi_task(task, DID_IMM_RETRY);
>  			continue;
>  		}
> -		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
> +		rc = iscsi_prep_scsi_cmd_pdu(task);
>  		if (rc) {
>  			if (rc == -ENOMEM || rc == -EACCES)
> -				fail_scsi_task(conn->task, DID_IMM_RETRY);
> +				fail_scsi_task(task, DID_IMM_RETRY);
>  			else
> -				fail_scsi_task(conn->task, DID_ABORT);
> -			spin_lock_bh(&conn->taskqueuelock);
> +				fail_scsi_task(task, DID_ABORT);
>  			continue;
>  		}
> -		rc = iscsi_xmit_task(conn);
> +		rc = iscsi_xmit_task(conn, task, false);
>  		if (rc)
>  			goto done;
>  		/*
> @@ -1547,7 +1597,6 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		 * we need to check the mgmt queue for nops that need to
>  		 * be sent to aviod starvation
>  		 */
> -		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> @@ -1561,21 +1610,17 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  
>  		task = list_entry(conn->requeue.next, struct iscsi_task,
>  				  running);
> +
>  		if (iscsi_check_tmf_restrictions(task, ISCSI_OP_SCSI_DATA_OUT))
>  			break;
>  
> -		conn->task = task;
> -		list_del_init(&conn->task->running);
> -		conn->task->state = ISCSI_TASK_RUNNING;
> -		spin_unlock_bh(&conn->taskqueuelock);
> -		rc = iscsi_xmit_task(conn);
> +		list_del_init(&task->running);
> +		rc = iscsi_xmit_task(conn, task, true);
>  		if (rc)
>  			goto done;
> -		spin_lock_bh(&conn->taskqueuelock);
>  		if (!list_empty(&conn->mgmtqueue))
>  			goto check_mgmt;
>  	}
> -	spin_unlock_bh(&conn->taskqueuelock);
>  	spin_unlock_bh(&conn->session->frwd_lock);
>  	return -ENODATA;
>  
> @@ -1741,9 +1786,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  			goto prepd_reject;
>  		}
>  	} else {
> -		spin_lock_bh(&conn->taskqueuelock);
>  		list_add_tail(&task->running, &conn->cmdqueue);
> -		spin_unlock_bh(&conn->taskqueuelock);
>  		iscsi_conn_queue_work(conn);
>  	}
>  
> @@ -2914,7 +2957,6 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
>  	INIT_LIST_HEAD(&conn->mgmtqueue);
>  	INIT_LIST_HEAD(&conn->cmdqueue);
>  	INIT_LIST_HEAD(&conn->requeue);
> -	spin_lock_init(&conn->taskqueuelock);
>  	INIT_WORK(&conn->xmitwork, iscsi_xmitworker);
>  
>  	/* allocate login_task used for the login/text sequences */
> @@ -3080,10 +3122,16 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
>  		ISCSI_DBG_SESSION(conn->session,
>  				  "failing mgmt itt 0x%x state %d\n",
>  				  task->itt, task->state);
> +
> +		spin_lock_bh(&session->back_lock);
> +		if (cleanup_queued_task(task)) {
> +			spin_unlock_bh(&session->back_lock);
> +			continue;
> +		}
> +
>  		state = ISCSI_TASK_ABRT_SESS_RECOV;
>  		if (task->state == ISCSI_TASK_PENDING)
>  			state = ISCSI_TASK_COMPLETED;
> -		spin_lock_bh(&session->back_lock);
>  		iscsi_complete_task(task, state);
>  		spin_unlock_bh(&session->back_lock);
>  	}
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 83f14b2c8804..14c9169f13ec 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -524,48 +524,79 @@ static int iscsi_tcp_data_in(struct iscsi_conn *conn, struct iscsi_task *task)
>  /**
>   * iscsi_tcp_r2t_rsp - iSCSI R2T Response processing
>   * @conn: iscsi connection
> - * @task: scsi command task
> + * @hdr: PDU header
>   */
> -static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
> +static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  {
>  	struct iscsi_session *session = conn->session;
> -	struct iscsi_tcp_task *tcp_task = task->dd_data;
> -	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
> -	struct iscsi_r2t_rsp *rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
> +	struct iscsi_tcp_task *tcp_task;
> +	struct iscsi_tcp_conn *tcp_conn;
> +	struct iscsi_r2t_rsp *rhdr;
>  	struct iscsi_r2t_info *r2t;
> -	int r2tsn = be32_to_cpu(rhdr->r2tsn);
> +	struct iscsi_task *task;
>  	u32 data_length;
>  	u32 data_offset;
> +	int r2tsn;
>  	int rc;
>  
> +	spin_lock(&session->back_lock);
> +	task = iscsi_itt_to_ctask(conn, hdr->itt);
> +	if (!task) {
> +		spin_unlock(&session->back_lock);
> +		return ISCSI_ERR_BAD_ITT;
> +	} else if (task->sc->sc_data_direction != DMA_TO_DEVICE) {
> +		spin_unlock(&session->back_lock);
> +		return ISCSI_ERR_PROTO;
> +	}
> +	/*
> +	 * A bad target might complete the cmd before we have handled R2Ts
> +	 * so get a ref to the task that will be dropped in the xmit path.
> +	 */
> +	if (task->state != ISCSI_TASK_RUNNING) {
> +		spin_unlock(&session->back_lock);
> +		/* Let the path that got the early rsp complete it */
> +		return 0;
> +	}
> +	task->last_xfer = jiffies;
> +	__iscsi_get_task(task);
> +
> +	tcp_conn = conn->dd_data;
> +	rhdr = (struct iscsi_r2t_rsp *)tcp_conn->in.hdr;
> +	/* fill-in new R2T associated with the task */
> +	iscsi_update_cmdsn(session, (struct iscsi_nopin *)rhdr);
> +	spin_unlock(&session->back_lock);
> +
>  	if (tcp_conn->in.datalen) {
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "invalid R2t with datalen %d\n",
>  				  tcp_conn->in.datalen);
> -		return ISCSI_ERR_DATALEN;
> +		rc = ISCSI_ERR_DATALEN;
> +		goto put_task;
>  	}
>  
> +	tcp_task = task->dd_data;
> +	r2tsn = be32_to_cpu(rhdr->r2tsn);
>  	if (tcp_task->exp_datasn != r2tsn){
>  		ISCSI_DBG_TCP(conn, "task->exp_datasn(%d) != rhdr->r2tsn(%d)\n",
>  			      tcp_task->exp_datasn, r2tsn);
> -		return ISCSI_ERR_R2TSN;
> +		rc = ISCSI_ERR_R2TSN;
> +		goto put_task;
>  	}
>  
> -	/* fill-in new R2T associated with the task */
> -	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
> -
>  	if (!task->sc || session->state != ISCSI_STATE_LOGGED_IN) {
>  		iscsi_conn_printk(KERN_INFO, conn,
>  				  "dropping R2T itt %d in recovery.\n",
>  				  task->itt);
> -		return 0;
> +		rc = 0;
> +		goto put_task;
>  	}
>  
>  	data_length = be32_to_cpu(rhdr->data_length);
>  	if (data_length == 0) {
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "invalid R2T with zero data len\n");
> -		return ISCSI_ERR_DATALEN;
> +		rc = ISCSI_ERR_DATALEN;
> +		goto put_task;
>  	}
>  
>  	if (data_length > session->max_burst)
> @@ -579,7 +610,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  				  "invalid R2T with data len %u at offset %u "
>  				  "and total length %d\n", data_length,
>  				  data_offset, task->sc->sdb.length);
> -		return ISCSI_ERR_DATALEN;
> +		rc = ISCSI_ERR_DATALEN;
> +		goto put_task;
>  	}
>  
>  	spin_lock(&tcp_task->pool2queue);
> @@ -589,7 +621,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  				  "Target has sent more R2Ts than it "
>  				  "negotiated for or driver has leaked.\n");
>  		spin_unlock(&tcp_task->pool2queue);
> -		return ISCSI_ERR_PROTO;
> +		rc = ISCSI_ERR_PROTO;
> +		goto put_task;
>  	}
>  
>  	r2t->exp_statsn = rhdr->statsn;
> @@ -607,6 +640,10 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_task *task)
>  
>  	iscsi_requeue_task(task);
>  	return 0;
> +
> +put_task:
> +	iscsi_put_task(task);
> +	return rc;
>  }
>  
>  /*
> @@ -730,20 +767,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  		rc = iscsi_complete_pdu(conn, hdr, NULL, 0);
>  		break;
>  	case ISCSI_OP_R2T:
> -		spin_lock(&conn->session->back_lock);
> -		task = iscsi_itt_to_ctask(conn, hdr->itt);
> -		spin_unlock(&conn->session->back_lock);
> -		if (!task)
> -			rc = ISCSI_ERR_BAD_ITT;
> -		else if (ahslen)
> +		if (ahslen) {
>  			rc = ISCSI_ERR_AHSLEN;
> -		else if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
> -			task->last_xfer = jiffies;
> -			spin_lock(&conn->session->frwd_lock);
> -			rc = iscsi_tcp_r2t_rsp(conn, task);
> -			spin_unlock(&conn->session->frwd_lock);
> -		} else
> -			rc = ISCSI_ERR_PROTO;
> +			break;
> +		}
> +		rc = iscsi_tcp_r2t_rsp(conn, hdr);
>  		break;
>  	case ISCSI_OP_LOGIN_RSP:
>  	case ISCSI_OP_TEXT_RSP:
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index b3bbd10eb3f0..44a9554aea62 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -187,7 +187,7 @@ struct iscsi_conn {
>  	struct iscsi_task	*task;		/* xmit task in progress */
>  
>  	/* xmit */
> -	spinlock_t		taskqueuelock;  /* protects the next three lists */
> +	/* items must be added/deleted under frwd lock */
>  	struct list_head	mgmtqueue;	/* mgmt (control) xmit queue */
>  	struct list_head	cmdqueue;	/* data-path cmd queue */
>  	struct list_head	requeue;	/* tasks needing another run */
> @@ -332,7 +332,7 @@ struct iscsi_session {
>  						 * cmdsn, queued_cmdsn     *
>  						 * session resources:      *
>  						 * - cmdpool kfifo_out ,   *
> -						 * - mgmtpool,		   */
> +						 * - mgmtpool, queues	   */
>  	spinlock_t		back_lock;	/* protects cmdsn_exp      *
>  						 * cmdsn_max,              *
>  						 * cmdpool kfifo_in        */
> 

Wow. That's a thick one. :)

Reviewed-by: Lee Duncan <lduncan@suse.com>

