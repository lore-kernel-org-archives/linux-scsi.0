Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565D5C43217
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Mar 2022 18:49:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349608AbiCHSuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 13:50:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349636AbiCHSuF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 13:50:05 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7124F9DD
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 10:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1646765346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KEf4FtvED3Oy3kb+h9+Wcl2IChqaVeQg4kn+T0+gpsg=;
        b=fVATr50oUZoXmVfeUEr6eGJjUB9u91NSwm4/ANJ+Zpw6JWizi3qKmUtXVFcm4ib+A3cQlu
        j2ZJCL5V7FQIREJHIlgHQE9p9U6Y2PTFrBfezfMlOuxuaVTWosgUx1KoBq+bFb9rvqahak
        DSuIzYApUqM4Nan8wYf4hZn5IqIo8jU=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2051.outbound.protection.outlook.com [104.47.4.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-31-oFGc47kcPq6o50WMngHkww-1; Tue, 08 Mar 2022 19:49:05 +0100
X-MC-Unique: oFGc47kcPq6o50WMngHkww-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fd5J10ivP/zYwMx3PeZq0ruA1amiRv+P15s9xQtFm3XJjMGHCCeJeoJaLJHvnGfoi2cDZyxIVLh6YCy6f1lR2BZ6JR+2ElThjp/kXTMl423vgrLb8y3in9mu26024I0ExoiX/GjSOroDyVa0JfnIiY3YiMFo5EnlWZP+dcEekGZNeHJ0JKNcwFb3YRVd+Zoisx9iikC8RoRJOuwbwUf3VoMZBktSzc/cha+dnd8J6vyGdUpG8B19QyZ3tPCFV5bDESyqrnukUvOOYNSa8tqN1cwAgDJuGqXx9hzi0km8SZo34/oo1BreC7lXo1LJ69AI0LMTKy2TQ9az7zECLNnTkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEf4FtvED3Oy3kb+h9+Wcl2IChqaVeQg4kn+T0+gpsg=;
 b=PjWPzB72+hPXBPQzDmfVWFAgh/Py01JnJljTSyO0/N6CjlbmYEaHVyz+I3Q2nrQQArLed/80VJU8p8kqaspG8L3QpbstmgOoZat6kIzREqJcqvGd4ark19AlvTMC16jA+wBvxK1QTsDXi/af4hsL3IA3iaERz3BTxj0tXin6RSDMoLP3uJexsyGJs8mniRPjpS1ejpiz3bY/Wsn376BRw2AmFI/m/DNk7EEiNsDz5Rrtdf9GIkmpEeiU5/8OvOsyCXdkAu9KDGGayOO5c7IKZmsna9x6rXCOBqGQJm/h5YXuYA1YykwS9Lx4oBWCt1av/GBQwNSkqubRsF8EN11E5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB6771.eurprd04.prod.outlook.com (2603:10a6:208:18d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Tue, 8 Mar
 2022 18:49:04 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::38e8:ef44:f684:9eed%6]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 18:49:04 +0000
Message-ID: <387bf893-5ea4-e3a2-f06b-d9374d956b91@suse.com>
Date:   Tue, 8 Mar 2022 10:49:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 02/12] scsi: iscsi: Rename iscsi_conn_queue_work
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220308002747.122682-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0046.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::23) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82fbff33-1f95-4dee-20f5-08da0134517c
X-MS-TrafficTypeDiagnostic: AM0PR04MB6771:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB67717F02A125CC12BCD73DE2DA099@AM0PR04MB6771.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ipM3C3Jsk5DalrImKBIYQeQJf0uZpX/3U/0CYj+3DzDYUCI3Lktb9EcDrVkVhr5vzoZX3i5CKNuBuJBvFJxMEvffRqcFnVEBmywMWkquPfFi2XnVAtcKd0dO/72x/QznPKgoc8x/0tGUXJ8/eEGEPda0NLwzSONs88vhTUZNhj2HJm6tsZekvijOvO+TdW1SjEEca57lhpVPPwHX2MeD2JA9JMxWo5aCWvz3HaKtcP4DKKh4SaYB7+ZdypmuTEenvzolLAc/jJM5T+DVCHlS5pVtTu1vryXjzzRjenCSe6x2aJexnc+RqjPYaXCRIsHBayXzDFCOOV3mxxd9+AOroRCDy0qfDT7POjTNd1XxiUn/9ySPXo1957M1/u+jrNieSAhkC2x9KEQA+OXnZbM5kWhS8LVBXe3QOe+DUNksUrAhuggiY+zKtxNnQ38YkvTx66EcZOQ4hcBzROqRlxV6CSpkZhO9qCDoZ88PrfH85XnT6wTTz0kX+yMk8vLhV2KFCDHx/Bic9dAeqYy3pvTE6j1GRquq3cioNyJzy0bqfrSvCPNWQIjPhwaGw0SDmhnN0T04wMA+CLGFT9SCa0Xd4SGUrYGGJ6aX4D4YzzScynaVg+g5QsKQSEjOm+5eNGcJLlnedgWgFy7+fr55kgyDRSKnj6WWQD+pUrT/sQh0pAxbKOCLSkZ23cdeFDD5lO7EHWRThK0wSHY5G5ly4+lAmYfO2+rxchhu4yc/Hfl68pI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(5660300002)(186003)(38100700002)(8936002)(66946007)(2616005)(316002)(8676002)(66476007)(86362001)(66556008)(6512007)(31696002)(6506007)(83380400001)(6666004)(31686004)(53546011)(6486002)(2906002)(508600001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Uzc4RElPeG1tcm5sZWVaS2E5cDBZcEJ0bk8rRzM4MWlPMmZWVnNLTWk3bnFB?=
 =?utf-8?B?azYrUUU1WGd3bW1VNytPbHVxdGd4R3ROQUp5K2hmTUtmNVhVekV6dDl6TEJG?=
 =?utf-8?B?N25GTERkSDdXYm9LZ3o2cUVTTFpMVGNSWXFCWFR6dHV5RFlHR3hsWTFtSWlV?=
 =?utf-8?B?LzNUdFRua1F0QXNNSERrc3FSaGd5N3JaYytvUkRNcElvTzVQRlEyRTFNV3p3?=
 =?utf-8?B?Mmdqa0pJQzNSRXV5NkRjYzVJY2MrRndDMHJ2K2lOemRoQXdIaHVvY3QydUtZ?=
 =?utf-8?B?VnV1TjdTK1FuNzFNTGloNFZ5cDRVWGVJQ0piOEc1TmJ0c2pvU2R0WGI5S0NR?=
 =?utf-8?B?Qi9Fd2t4NFJVZFBmTTBwbW1iUHNETWVtVlRTQzQ3ZVNmN0xFcjcvQXVycHdv?=
 =?utf-8?B?ZFRSVjBVcnY1ZjZkMHpSTHRpaFR3K2lLbUFlVkkwT2I0YkM3S01jUjN1NUxr?=
 =?utf-8?B?c3g2bytKRGtoSGcydlFNZ1RTS0NYRjBhNjNQVlhsNFhEYmRYUWViZnNoRDBs?=
 =?utf-8?B?K3JBdlAySkZtY3ozdEpTUXZWSXBLb2lvdVE5aXphWDV2eXlzeW4rSU9UOWN0?=
 =?utf-8?B?MTdCQ001Yko5eDlJNjJRZWFldmlCVys5Y2lnb2krYklENFNBazd6dzdzNDQx?=
 =?utf-8?B?ZllNaTlKVUFNc1BnS00yNjhzell6d0RkU3dVT09IdmNPUVdxSDlUejBSZlZr?=
 =?utf-8?B?T2VNY2x1Y0ZNYmk1QW9qcjQ3d2djaFp3alNEdTZnYVl5OEpWQnNqeTJKU0Jv?=
 =?utf-8?B?aGNPM29hNEhOSmh3RnIvNlROZSt3ck9qQjRFQmUyOFBsKzZtY2ozODE5V1FE?=
 =?utf-8?B?S2pReWtTMi9KZms5d0QyU2x6QUFCbnV2bXd4MjNFTDZ3YlVjVDg4cHVCK296?=
 =?utf-8?B?eVBNSkNWMnZaZDJ0TEg1d3dhWUVmVkVDSzlMck1hU3RxbjNIVjhHellsdldF?=
 =?utf-8?B?QVNOQXc0dTI2a0FBTXV6RW1OWHRQdkxSc29NaTNqL0RzSVpZQlJjL1c1L0ph?=
 =?utf-8?B?anlyTy8rYzlqTVZZSHdaRXhST1p6aFczQXlhMjZvU3daWXZLcmZUQXltK0hL?=
 =?utf-8?B?VUpjQzZnQ1UxdEY5K2hHcDFseXBFYndYUzZpU0FkWDlGcWRVaitEL3F6Z2hl?=
 =?utf-8?B?SENVeUNMc2Z3Z0pRaG9XUkNFWFNYUU4ydEVsbTlQS095a21SQUZFdU10VHNO?=
 =?utf-8?B?Yy9Zd0xMdVJ1cHdtYVZuak9aWVdob052SVFUMlJjTWxSQTV6VlpnRm1BNWp6?=
 =?utf-8?B?bnRTd21aS3o4SEMrcHZ1QlorMUZKTlBwUkN0VVF6dzIzcmdBQkg3OFNGUUl3?=
 =?utf-8?B?OGQwWSt5OHliZi9ycWphSGw1dDFoRFBycVM3MEdTZUsyR21IdlZjOVBORG5X?=
 =?utf-8?B?bVAvWTdoYkZOVGhUd21SUVBvUmhVWjdvNEtHcituRm1rcFFzQ1ZTNy9QNlM1?=
 =?utf-8?B?Z0RjZEJDdVdXenM0N2hhdG8yTFpQOHNQYXlVNnlOdUhnRlRrZzNUTEpEdEtp?=
 =?utf-8?B?Z1dMYlRqY2pLUU1OWGZUejRyYTV0MEJJR0FJelZkakE3WXU3d01RbkhoZGIy?=
 =?utf-8?B?bVE3dEttUzdta0VmWmRrb2t3NDFrNUpDZWthT0o1bTVDTlVId2phRkFYenhi?=
 =?utf-8?B?cnZFQTQ1aExvOW02K0lqQjNaTUpPa0VrTlRhMnF0TUdTODFnanVUQlZtTkds?=
 =?utf-8?B?aml4TGlKc2NtVlBhVEEya0R3b2lsbGlKbjh2b1g5ckFtVXd0N2REVTZyL3Jz?=
 =?utf-8?B?LzB1TTZIc2RuTXFVaGxXTFh5a3RCbDBCZVhJUDU5UE9ESlpoMFJkbUVEa2N4?=
 =?utf-8?B?TGR2bEZ1U2Q0WWlDRmNCdVdOc2hxR0pNU0tydEtRemw2cU1GZ1RzY3VoaTVw?=
 =?utf-8?B?dWlYU2RzYVZKRkZSWU1tTVpwcVArUXpKbWFtTUU0UnJQUXMzVEdWTVJtTzA1?=
 =?utf-8?B?RFNPaFprN0ZhUDlLbHFuRVZSV2UyODlOMk5kNTcrRWFTYzIzbXNFOWJFaURF?=
 =?utf-8?B?Q3lhT3VkQXpsU3FWdWFHZVdDR1U1TisxUnA2UkZzU3RuY3ZHZHh1M25vKzRV?=
 =?utf-8?B?b0tLaHNhQ3pud25mbGJVeWg3TFRsR1dDbU5NVFgvSkpUemVvYXROdXJicUNE?=
 =?utf-8?B?d0h3d3NkN0xlclRob3ZOaDQycUJWNERxWGFiWk4walprU2laeXhqSVRqWHRr?=
 =?utf-8?Q?b221kqdqXWNgIzEFiL5EffY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82fbff33-1f95-4dee-20f5-08da0134517c
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2022 18:49:04.5081
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oKmpjNtMx+EjVD3htpT28621OAkdO1iv6gtWkap0MZVyIvMUyDU7A6foXbB2lRS7m5skj6aPlCMNWh8pCL3JyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6771
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/22 16:27, Mike Christie wrote:
> Rename iscsi_conn_queue_work to iscsi_conn_queue_xmit to reflect it
> handles queueing of xmits only.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/cxgbi/libcxgbi.c |  2 +-
>   drivers/scsi/iscsi_tcp.c      |  2 +-
>   drivers/scsi/libiscsi.c       | 12 ++++++------
>   include/scsi/libiscsi.h       |  2 +-
>   4 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 4365d52c6430..411b0d386fad 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -1455,7 +1455,7 @@ void cxgbi_conn_tx_open(struct cxgbi_sock *csk)
>   	if (conn) {
>   		log_debug(1 << CXGBI_DBG_SOCK,
>   			"csk 0x%p, cid %d.\n", csk, conn->id);
> -		iscsi_conn_queue_work(conn);
> +		iscsi_conn_queue_xmit(conn);
>   	}
>   }
>   EXPORT_SYMBOL_GPL(cxgbi_conn_tx_open);
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 1bc37593c88f..f274a86d2ec0 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -205,7 +205,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
>   	old_write_space(sk);
>   
>   	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
> -	iscsi_conn_queue_work(conn);
> +	iscsi_conn_queue_xmit(conn);
>   }
>   
>   static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 14f5737429cf..fa44445dc75f 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -83,7 +83,7 @@ MODULE_PARM_DESC(debug_libiscsi_eh,
>   				"%s " dbg_fmt, __func__, ##arg);	\
>   	} while (0);
>   
> -inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
> +inline void iscsi_conn_queue_xmit(struct iscsi_conn *conn)
>   {
>   	struct Scsi_Host *shost = conn->session->host;
>   	struct iscsi_host *ihost = shost_priv(shost);
> @@ -91,7 +91,7 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
>   	if (ihost->workq)
>   		queue_work(ihost->workq, &conn->xmitwork);
>   }
> -EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
> +EXPORT_SYMBOL_GPL(iscsi_conn_queue_xmit);
>   
>   static void __iscsi_update_cmdsn(struct iscsi_session *session,
>   				 uint32_t exp_cmdsn, uint32_t max_cmdsn)
> @@ -764,7 +764,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>   			goto free_task;
>   	} else {
>   		list_add_tail(&task->running, &conn->mgmtqueue);
> -		iscsi_conn_queue_work(conn);
> +		iscsi_conn_queue_xmit(conn);
>   	}
>   
>   	return task;
> @@ -1512,7 +1512,7 @@ void iscsi_requeue_task(struct iscsi_task *task)
>   		 */
>   		iscsi_put_task(task);
>   	}
> -	iscsi_conn_queue_work(conn);
> +	iscsi_conn_queue_xmit(conn);
>   	spin_unlock_bh(&conn->session->frwd_lock);
>   }
>   EXPORT_SYMBOL_GPL(iscsi_requeue_task);
> @@ -1781,7 +1781,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>   		}
>   	} else {
>   		list_add_tail(&task->running, &conn->cmdqueue);
> -		iscsi_conn_queue_work(conn);
> +		iscsi_conn_queue_xmit(conn);
>   	}
>   
>   	session->queued_cmdsn++;
> @@ -1962,7 +1962,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
>   static void iscsi_start_tx(struct iscsi_conn *conn)
>   {
>   	clear_bit(ISCSI_CONN_FLAG_SUSPEND_TX, &conn->flags);
> -	iscsi_conn_queue_work(conn);
> +	iscsi_conn_queue_xmit(conn);
>   }
>   
>   /*
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 10a9b89b7448..b567ea4700e5 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -441,7 +441,7 @@ extern int iscsi_conn_get_addr_param(struct sockaddr_storage *addr,
>   				     enum iscsi_param param, char *buf);
>   extern void iscsi_suspend_tx(struct iscsi_conn *conn);
>   extern void iscsi_suspend_queue(struct iscsi_conn *conn);
> -extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
> +extern void iscsi_conn_queue_xmit(struct iscsi_conn *conn);
>   
>   #define iscsi_conn_printk(prefix, _c, fmt, a...) \
>   	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \

Reviewed-by: Lee Duncan <lduncan@suse.com>

