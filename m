Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9C2C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 16:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238872AbiCRQuy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 12:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbiCRQur (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 12:50:47 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474D964F9
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 09:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1647622165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H9eq5bsMbY1MONE+tMOI/MIZQ7zC3ZY854RTdCLITn8=;
        b=Pd+u74fTnWUfx012wrBIXZJCmME0rLyK8Sm30aIPiiVBEDV4T8qzCKc8n4PYKJD62nB4Fu
        /W7oix1msDXTB/DLI+GFkBzkuwm4pBiwNh+1jSt9+CtvAPUxsQAEgyFLcwkQNvTQ5gswjC
        ktS+ny5AiFsJP70QEIsj/dQjXyRBk8E=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-27--NHRc1htMsK5sYW02x3rUQ-1; Fri, 18 Mar 2022 17:49:24 +0100
X-MC-Unique: -NHRc1htMsK5sYW02x3rUQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Acc3ix1iH/YXInDc4HJgELcsOME/2uqvrFyQfnHjRFvJJTqBfsPn56EfH8kWd/yXgkT3Nq2AQK5gTNqcl1HWNuc+s5lKuOxp+HH365eWvG9taLIcTLivLZj4KSUb0LaExdNVwO13XiJyumjnWE/hJ3n0s+cD6x+B4lYumdtBvwC6mW4TqHlrCQqwAM5PFhRjyEU8DzFE12AgiaLfmdMDP3NImnZkV1Hd4JCdPw9gqsD9qXbJicgIWuMEpFuR0UxSmWBHn2yINkJVlcPpBiZRlq35U7frKjQw3MKeFxqQ7I2sxM6m51iof1reIrIzEVrgtsmQr9rAYm3O29AaegPZ3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9eq5bsMbY1MONE+tMOI/MIZQ7zC3ZY854RTdCLITn8=;
 b=fMxRD3I33nWk8tAiiUSY/CSg+eGSpXiIXtAwPnWdBqzNJop5cNFGylZfNqUnhIeOY6afjMQyHacYi/BCQaG8UR3/HB/Otao2BkVx6Kkf9an1r9B1gaIW9sLchuuXlYN849AqbuJpHcgPsxPOSgj0pSA8dxMfV3e7Pc43d9sfsqwqGYvotPTXTko2mgcCBJ8dEvyyx/NSg41kTN1EqQBlb+sV+bKTgmF70e2vxqF9dP3q4irSBKmBGIDEfl8jjeVSg0qdOl0D0Kn5/sdTHeyqhpVxO72rMwOfqFr4a6j4dGn6NuS+xQTzFDqiO4uKXTRXzHNwBXJug8/12tKnDah62w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB7188.eurprd04.prod.outlook.com (2603:10a6:208:192::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Fri, 18 Mar
 2022 16:49:22 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::14d7:55aa:6af:72d7%6]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 16:49:22 +0000
Message-ID: <a0c28a1c-4b74-6992-8fb5-828f64930074@suse.com>
Date:   Fri, 18 Mar 2022 09:49:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 11/12] scsi: libiscsi: improve conn_send_pdu API
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-12-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR1001CA0058.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::35) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b832a333-bb03-439a-b76c-08da08ff40fb
X-MS-TrafficTypeDiagnostic: AM0PR04MB7188:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB7188270DC4FEFFE9170CCF8BDA139@AM0PR04MB7188.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vi565IBt3LouKs81H/jpc6TCLj33OS+HEFVJDOuZ7eXDVriyHkxdPplNo96ubRM3sZLivN/d7bMHJqXzqKXJvJrWjFZv3UWqAvBX874rOTc478vRrEIqSL02f0sFNELsuite5jyu75iWdfZSwuqpxKq7+cy/zeJC70Ufbcnj+UISq4ZvU/peBvo1WhhmDxiSgsheU8YJvKeojBgkJnHonP5Zto8JdqTmDW6DrJ9/Tk/Q/asCNxH9PxEM9bVvGk5dbhefsJ9JSFrVHrMGowQVmAPry9udd99mXNy9TC6+7WF3TbH0VDw7Miho0PpV/1aJMMnZS6M2ksQly3ibqauWAXGM8q0jD1EIgLhuH9tExiF9uWmOh8/V4LAuKSOlcCyRvSDGyI2sAPUFNY0fqd2AR/Gy/uKx5Mxi6HjbDGEHlgYoI87229vVWAUp+C1PoVHaGInDjiTzJafydnZJcOEe9s5FfLpjVDpe0weRhEc0dsg1CLzE/z+zPxoIWW2w2vmpcVuX+cdFK8xVtp7LOker/MFYPIuFL/JfxD2LhRqvsO+PjNj3ikMA0QSdtMWnSHzNA3EAgO9domZaJGzjYqs8Sn8xYamGp3kXzYZMs/zGqsxJz7NIh0w77X6OMUxbRcpCgGfE1qPk05+esCLqzq0Ayxhy9/M1NPI8wFb0oFdR/tW9jKFm/L1R6pRjwAyg6CWE02EwmOSSy6nhSZ7m3BLIjYA3hqc+O1gicLQQKCl2AdA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(31686004)(316002)(8676002)(66946007)(66556008)(31696002)(83380400001)(66476007)(26005)(2906002)(2616005)(86362001)(186003)(6666004)(6486002)(6506007)(53546011)(38100700002)(508600001)(8936002)(5660300002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkE2TWFBbEZvTW44WkRwWVZCa08yYlNTQ284bjl4eVRCNGdLRkRUZy9YWFlh?=
 =?utf-8?B?SWdFN1I4WStmZWQ5cXo4NlZ5RnFDRllYUUtoZjcraVE4VmFWMk0vWi9lWFNZ?=
 =?utf-8?B?czVMejZNWmp0MjIxTjJ4N05UN29adWQ1SUN3Q1gzanRpNW9CMXJiNUlZR0w1?=
 =?utf-8?B?bTZJanJBbDUxKzN1ZWd1YlR1aFJsRENQRUZ2QlRJU2RIZE9qbVdIdWJ6eUM4?=
 =?utf-8?B?aURtVWNGRlNsRmJKaVE5YXludk9HMWdrWXFpQ0RJcjhlQXdia1BCS3VJcDJx?=
 =?utf-8?B?WW9kL2JKZnNOTm5aQVB5a1ZNOExVL2pxR2NHQXBYd3FlQytHQkVwMHM0b25M?=
 =?utf-8?B?WUcva0g4VWk4ZVp0US9oK1JscVAzeng0aThaWWREdi9oTENBWVdLNlhxNGJx?=
 =?utf-8?B?dFZ5OXNzazBmTTd4Z1B3WjV3ekNVR2NHSHlZcFUrclBwMUdZMitTbGFUSzJp?=
 =?utf-8?B?SjQ3Vk1jOUdqTjZzMm03MExHOS96ZEtpT1c2aVNjVUtYWFdrdlVBMFB5Q2ND?=
 =?utf-8?B?NmJ4cVljbXBzZnpCUjI2M09XZVdPS3ByR1pTREJlQUIxUmdCS0tjbkFvK0ZU?=
 =?utf-8?B?S1c4RDB3ZmdycWo4MlRCejJ0Ync3K0dKMTlOZE5jb0xZMm8xUnZ3S3ZuREZR?=
 =?utf-8?B?OHlJMzRuVkY5eDhHQ3NaY2pLM080RjNBV2FqelZId1RyNyt0ODluNkI0TnMx?=
 =?utf-8?B?WWt5RHo3SmI0bnkyUEdSaWI1citXZXQ0djBnSllmR0NkYVY3YVJxQ1gwNHhM?=
 =?utf-8?B?VjV6c1Nxdzg4d0Znc2NQQllNQkE0eEhEOXFhWWM5RmJNcXpKWThiQU5EZTd1?=
 =?utf-8?B?TnJCMEtmTzgrZ1VYN2pGL3g5dVJKbXRodmROdzVxWFBOaVFhNXNlbmhLOUYy?=
 =?utf-8?B?bUs2OHNvNkdJR1cyNTBvRFZsZTJPYStubnRSNWl6bnFLaUVPTWY4RlZGS1pp?=
 =?utf-8?B?TlZuWUZUSHZGUE1uMCtQaTBodUxLOWFpeHNJcWFkTzlwNWJSVTg5dXNDalBS?=
 =?utf-8?B?b2xwdFhYTVk1MVlFd1JQeDkrcEh0OHl4UW1qakxDbmlLT1VwSU9tYmxWb2xH?=
 =?utf-8?B?c0o0VU82MkdGZUQxSE9SVnpCYTlGT3lEMzdUWjI1TlFjYWdvQlVGNXluUXVC?=
 =?utf-8?B?OWZ0US81Zlo5cGM5T0JtOVdMbmNzV01YUmo4WnZRWVZRNExUWnBKd1h4Nm1k?=
 =?utf-8?B?T2x0dmV5WElKb2o4NDREb0Z5em9veGNsQkx4TUV0bUVnaTcrVkEwT0plY080?=
 =?utf-8?B?Y29oZlNJSUpwamNlRnlqTUN1NTFkaitXRVpPaVVVV0dxWDRxUmNMditXUjlS?=
 =?utf-8?B?Z1gzM2xQNUJhZW9mVUwwSlBGVWdTL3NON1g2b3ltZkg3eW1WU1hlRHRQVlNl?=
 =?utf-8?B?WXVKanhMVnd4MlFUSEFFc3FNQjZ2Z2tkL1g2Nm1VVDUydlBHTVljQThyTlR5?=
 =?utf-8?B?WDdBNUYxYUdrOUF2cWZOZm1oZ28rTmZISy9meng4OFdsVlBKM2dvZ1Evb2tU?=
 =?utf-8?B?UHUxU1d5d0ExM2VNU0lzanFBek9yblhEYXhYekFhWmVPUVNyVnNoYU5SclZz?=
 =?utf-8?B?dEtnNEM0SXlQWkVoWkpzTkVPWlA4QVdXQVlRVGVuTjhZcVBYNldKdEo5WHh2?=
 =?utf-8?B?MldPeUxIazR0aHdPMjRlVWdjRVVYWTZoOVRTcXRQYUMwNFYxV29ObDRra2h3?=
 =?utf-8?B?Z2piMmJrZHNUSEJGNXZpSVJCaThQNFh4ZXM0Q2o3YmpiOW9tRlU1S2FkVUhE?=
 =?utf-8?B?aTFjR0srVW9kdGNlTE9tTVZ6VXBpcFdPOU9vUDYySWZxaktZbXJBeStlVGdr?=
 =?utf-8?B?bmxNWUJTT21sbW9NZkh2ZERUcEU4bXcxUVhrNDljanpKWS9ra1RqUS8xZ2Z2?=
 =?utf-8?B?eHVPTXgycTR5c056MzM5NjFiMyt5K2hSenNyUnhVRWkzZCs3bGN6THdLek5I?=
 =?utf-8?Q?A1uwJB8oNOCbIGOf69pZsLlPcZMKCpNE?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b832a333-bb03-439a-b76c-08da08ff40fb
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 16:49:22.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kNeNDMKInwZj7EXlei1nx3/i+FUKCJIP/E6Nyih2G0t/1tT+S4d9yr7LcDVj+G0jsCisIJ4A0MSThO+ohQwQqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7188
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> The conn_send_pdu API is evil in that it returns a pointer to a
> iscsi_task, but that task might have been freed already so you can't
> touch it. This patch splits the task allocation and transmission, so
> functions like iscsi_send_nopout can access the task before its sent and
> do whatever book keeping is needed before it's sent.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/libiscsi.c | 85 ++++++++++++++++++++++++++++++-----------
>   include/scsi/libiscsi.h |  3 --
>   2 files changed, 62 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index cde389225059..a165d4d10cea 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -695,12 +695,18 @@ static int iscsi_prep_mgmt_task(struct iscsi_conn *conn,
>   	return 0;
>   }
>   
> +/**
> + * iscsi_alloc_mgmt_task - allocate and setup a mgmt task.
> + * @conn: iscsi conn that the task will be sent on.
> + * @hdr: iscsi pdu that will be sent.
> + * @data: buffer for data segment if needed.
> + * @data_size: length of data in bytes.
> + */
>   static struct iscsi_task *
> -__iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
> +iscsi_alloc_mgmt_task(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   		      char *data, uint32_t data_size)
>   {
>   	struct iscsi_session *session = conn->session;
> -	struct iscsi_host *ihost = shost_priv(session->host);
>   	uint8_t opcode = hdr->opcode & ISCSI_OPCODE_MASK;
>   	struct iscsi_task *task;
>   	itt_t itt;
> @@ -780,28 +786,57 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   						   task->conn->session->age);
>   	}
>   
> -	if (unlikely(READ_ONCE(conn->ping_task) == INVALID_SCSI_TASK))
> -		WRITE_ONCE(conn->ping_task, task);
> +	return task;
> +
> +free_task:
> +	iscsi_put_task(task);
> +	return NULL;
> +}
> +
> +/**
> + * iscsi_send_mgmt_task - Send task created with iscsi_alloc_mgmt_task.
> + * @task: iscsi task to send.
> + *
> + * On failure this returns a non-zero error code, and the driver must free
> + * the task with iscsi_put_task;
> + */
> +static int iscsi_send_mgmt_task(struct iscsi_task *task)
> +{
> +	struct iscsi_conn *conn = task->conn;
> +	struct iscsi_session *session = conn->session;
> +	struct iscsi_host *ihost = shost_priv(conn->session->host);
> +	int rc = 0;
>   
>   	if (!ihost->workq) {
> -		if (iscsi_prep_mgmt_task(conn, task))
> -			goto free_task;
> +		rc = iscsi_prep_mgmt_task(conn, task);
> +		if (rc)
> +			return rc;
>   
> -		if (session->tt->xmit_task(task))
> -			goto free_task;
> +		rc = session->tt->xmit_task(task);
> +		if (rc)
> +			return rc;
>   	} else {
>   		list_add_tail(&task->running, &conn->mgmtqueue);
>   		iscsi_conn_queue_xmit(conn);
>   	}
>   
> -	return task;
> +	return 0;
> +}
>   
> -free_task:
> -	/* regular RX path uses back_lock */
> -	spin_lock(&session->back_lock);
> -	__iscsi_put_task(task);
> -	spin_unlock(&session->back_lock);
> -	return NULL;
> +static int __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
> +				 char *data, uint32_t data_size)
> +{
> +	struct iscsi_task *task;
> +	int rc;
> +
> +	task = iscsi_alloc_mgmt_task(conn, hdr, data, data_size);
> +	if (!task)
> +		return -ENOMEM;
> +
> +	rc = iscsi_send_mgmt_task(task);
> +	if (rc)
> +		iscsi_put_task(task);
> +	return rc;
>   }
>   
>   int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
> @@ -812,7 +847,7 @@ int iscsi_conn_send_pdu(struct iscsi_cls_conn *cls_conn, struct iscsi_hdr *hdr,
>   	int err = 0;
>   
>   	spin_lock_bh(&session->frwd_lock);
> -	if (!__iscsi_conn_send_pdu(conn, hdr, data, data_size))
> +	if (__iscsi_conn_send_pdu(conn, hdr, data, data_size))
>   		err = -EPERM;
>   	spin_unlock_bh(&session->frwd_lock);
>   	return err;
> @@ -985,7 +1020,6 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>   	if (!rhdr) {
>   		if (READ_ONCE(conn->ping_task))
>   			return -EINVAL;
> -		WRITE_ONCE(conn->ping_task, INVALID_SCSI_TASK);
>   	}
>   
>   	memset(&hdr, 0, sizeof(struct iscsi_nopout));
> @@ -999,10 +1033,18 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
>   	} else
>   		hdr.ttt = RESERVED_ITT;
>   
> -	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
> -	if (!task) {
> +	task = iscsi_alloc_mgmt_task(conn, (struct iscsi_hdr *)&hdr, NULL, 0);
> +	if (!task)
> +		return -ENOMEM;
> +
> +	if (!rhdr)
> +		WRITE_ONCE(conn->ping_task, task);
> +
> +	if (iscsi_send_mgmt_task(task)) {
>   		if (!rhdr)
>   			WRITE_ONCE(conn->ping_task, NULL);
> +		iscsi_put_task(task);
> +
>   		iscsi_conn_printk(KERN_ERR, conn, "Could not send nopout\n");
>   		return -EIO;
>   	} else if (!rhdr) {
> @@ -1869,11 +1911,8 @@ static int iscsi_exec_task_mgmt_fn(struct iscsi_conn *conn,
>   	__must_hold(&session->frwd_lock)
>   {
>   	struct iscsi_session *session = conn->session;
> -	struct iscsi_task *task;
>   
> -	task = __iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr,
> -				      NULL, 0);
> -	if (!task) {
> +	if (__iscsi_conn_send_pdu(conn, (struct iscsi_hdr *)hdr, NULL, 0)) {
>   		spin_unlock_bh(&session->frwd_lock);
>   		iscsi_conn_printk(KERN_ERR, conn, "Could not send TMF.\n");
>   		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 9032a214104c..412722f44747 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -134,9 +134,6 @@ struct iscsi_task {
>   	void			*dd_data;	/* driver/transport data */
>   };
>   
> -/* invalid scsi_task pointer */
> -#define	INVALID_SCSI_TASK	(struct iscsi_task *)-1l
> -
>   static inline int iscsi_task_has_unsol_data(struct iscsi_task *task)
>   {
>   	return task->unsol_r2t.data_length > task->unsol_r2t.sent;

Reviewed-by: Lee Duncan <lduncan@suse.com>

