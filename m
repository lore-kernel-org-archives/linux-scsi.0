Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA23C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 18:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48721611C8
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Sep 2021 18:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhIRSgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Sep 2021 14:36:17 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:38702 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231128AbhIRSgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Sep 2021 14:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1631990090;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GG41YiMhGOwqi/CUJa+uIwdClMcXxiDj/RRJVZU6cHU=;
        b=ML9OQ+ickEq1wq0mpw3A44vNuDBfWp4q8s0jo2qh5suDfGjxEinKnmfVgvcNgZmbEdReK0
        WC6icajU+uwfHG4XpNnP1gtTwZKHu/BRHqopcvq155UduXkjju55nPEpNboNhtOY9amywd
        69wT+Ja93mOrzT8gzspPcsnKAlF1A7U=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-HjC2x_nkPZ-sn0a_ZBN5aA-1; Sat, 18 Sep 2021 20:34:48 +0200
X-MC-Unique: HjC2x_nkPZ-sn0a_ZBN5aA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SGE+KWRblERDuc+3iZn14JFdXk7up8SDPPnBbdvImMYflZ7UrW1d7UHn8lHNGsNjaXQ+A/6SneUzPk95SY4pdPSHiPAZVIGbuFQo3AEkKfYWqXb80e1EGs7swDnlI9wOB84QjUZ0KGs2evgZz1UKXpL0bhBPFj5R3u6w4JECC31ysrKkCzhYvWFn3ctef+H4Y8GoKL/tZgUHmZbdgokqjo9nKDSbpaAmQkU8wFg7NC3twXZ6sGAijAM7prX6Oy989E4uFF38QC+7GjiQReciKrY2isaKkhxinreQBbVcaHdPtAj09gJf5AojpmDmAzoRCSPXM59ECGAWKPiUdp/yeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=GG41YiMhGOwqi/CUJa+uIwdClMcXxiDj/RRJVZU6cHU=;
 b=kscQ8VMt4e2d0bzdptlZcsY5vi1FhpClYW65AvbQnFnkLm47myuUyZ7b4Pq0pgMbyz4j7ou5uFTZ3Enoe9+4v7k/QvHpfGlcyKC6NPQ2Usu9jqrhOplKKtlXJu+vcgpKNP+5Je/04xrCH38v8JWLbwEcPlPu1Up/ofK79liJpfv2DDmNu8S54HrtZmbelQR2kEaGN5oQcvHEXsSb1vJ3+IKZamDkjt2hRpnIDuxVPexKumTE2OFYcooGG1OqvRA76gVp7P7V9JwVKWdO7Pa5STf8Blh0NLU81jRMct6T0H6jqCWW5jO6z4V6NYNxxIX5vKrPtjyxSa0r9BRMMoOwRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM7PR04MB6933.eurprd04.prod.outlook.com (2603:10a6:20b:10d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.18; Sat, 18 Sep
 2021 18:34:47 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4dce:478:1ef4:7a85]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4dce:478:1ef4:7a85%3]) with mapi id 15.20.4500.021; Sat, 18 Sep 2021
 18:34:47 +0000
Subject: Re: [PATCH 44/84] libiscsi: Call scsi_done() directly
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-45-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <7b003352-89d3-3c1d-c12c-038f8a1a36b3@suse.com>
Date:   Sat, 18 Sep 2021 11:34:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20210918000607.450448-45-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P193CA0036.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::11) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P193CA0036.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Sat, 18 Sep 2021 18:34:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cff84363-9bfe-4f20-988e-08d97ad2fdbf
X-MS-TrafficTypeDiagnostic: AM7PR04MB6933:
X-Microsoft-Antispam-PRVS: <AM7PR04MB6933BE921781A26B7BEF1007DADE9@AM7PR04MB6933.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:425;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccwSBMsB/ozsYkrdjBxkbb4i9xJMrIuN8B1sU5PfZ3jCDuaL3wWvElKQQLoVJZSk02zhnMXc1uG11eRVaFYOAmWUHMyG0hMuN+qFtxXf3q2P2zfqrf9gmoFg2QWaTnKlZJMUsm+/S5LZ1vXXQu+M0i2hE60a2VoKiPlA9PsDnN6l9NaX9lPT1qFXoqcAuPea6xE0O6hWGg2oPwlFzzxpsT5gty/MuPhr9nE+iwprULMMuXFbJ3Y5G6sfCfWF3hP0Llczb4wpjthkxHZGwhaTnCaz6/f+frbZcnnZZLTOzO2dc9+ARi8G6Wo5gu/DdaiMuurZSAmOas4E+3GJejqkbCDhQlc50+SZKOZvBjGRT9A1/T5Cxb+W18R+VaRO9sFlQUIG3typDJxw9TvMppy9AGrgqWsLJzOn76/ZnzjcGbm3/b2DwWb6lZvn5qY7e28RQxvwLo8HjJ5pkCxGxqPb8rgHwPVHBUhjX2uiaKGKuoVajaf4pUxw4fmbB8OOXc6dfg6c55KACFR9MaF1UBtC7UkLeOqmXYR5LaJce9j8aT4BNr6OWPHdz4fmay8mCv1yuHaOI09h9WFimN+F9IhL9KC3bsiVyy1CFcxgOYgcFLhqYyxOEW0SZEWXnDcmnY3P+WU6JJzoJDS1UJVnwcNyEou21L9uPHrtvoxyRlmPjVZMkfgWEYMAoaHJMdeuxIKx3h1oF+iPLV4ty4WywFAM23FOIemaEp7hZFKsPLBQHoc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(4326008)(54906003)(5660300002)(8676002)(31686004)(31696002)(186003)(53546011)(2616005)(26005)(38100700002)(66556008)(2906002)(36756003)(66476007)(66946007)(508600001)(110136005)(83380400001)(8936002)(6486002)(956004)(6666004)(316002)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1M2UVArYXRvMmFzNjV3bTE2WTdnS1NMOTlnOWZmQ0pHSi9ma01YMTRQSVgx?=
 =?utf-8?B?ZCtqaWZoakZubUZidCtzM2lHN25Ja2dTNmh2LzNJRVR0MkkxSjUzWGJvOFpl?=
 =?utf-8?B?b0pPRU91c3c3RFFWVTM2enhyanhpQWQwVDE5QlZJak12VVhmQnFmcXp2U0ti?=
 =?utf-8?B?dWdKSG1QNmNzY1JiYmJ5TmxZdmo1K2lZR1daNGNsMEdKc2JVNFpnZHNYa1JN?=
 =?utf-8?B?NkVaN2VsOGgrK3o4cUVZcTFYY1JSVExPMVg5cGcva1ltcnJKWXplbzlWaERI?=
 =?utf-8?B?QnFTTDlKV3RiSWRxSUdLZ3M5ZmhXdzZjeUhiZHBCUlFRU0hCSlYxTFlTWkxy?=
 =?utf-8?B?OERDNWFFc1ZrQnpGYjVSUXRmY3g5Ly8wWWdZcEVBQng3WkoyZjBDZTNyTEcr?=
 =?utf-8?B?cVdtazNxaG9jQUg5NGFHUkg1dFRZRFJINXUyMnY0VmFJOU9jOWhBSjNSQm1z?=
 =?utf-8?B?ekk1Q3FwM3lmYWtZUVljeXNnWGVqSW43T1RFcXFza056TlFTWW5MTzl1VDRI?=
 =?utf-8?B?dGxOalRmajNVQnlNOW8yTXZCWVJPL2dqU0tNdnllTjcrR0xibWlzcTJDbjRa?=
 =?utf-8?B?RHRjWlFEaDB6bDNVT1pCcGVjWFJkN2xDQWlnVVNzTXVxN0ZqclI3N00zdkpm?=
 =?utf-8?B?UFR3Q0t2bUZNU1JaYkhFS3U2Um1rbzZBR2l4SU5lUGJ2SlRXeWxzVkZRUlVL?=
 =?utf-8?B?T0hYSlVpaDI1MWRpenVndGlHd3cyRVNpemZkYm93ZFBINmNKY253cVVBUmRY?=
 =?utf-8?B?cW5WcUxzU1lseXdhQ0tKdTdpU1dZSE1ab3FWU0ZwSTNrVDQvOVg4ZDBaZ0xr?=
 =?utf-8?B?N0JqRENmUElWcHl6MVdNMTdDWGNVR3l0ZHVQNU1sdW9xRnd0bnByU0RyTloy?=
 =?utf-8?B?bXh5bUZHbUdsNDdxMGtCaHVHcmRzYnlURzUwakRzT0FZNE5zSDZtY1RWQStW?=
 =?utf-8?B?SmY3YXJ2RURjeVVVSUdRa1ZKNXJlazV1ektiNGhMaW1IZWJ0VVVzNklwVkF6?=
 =?utf-8?B?QXYwa0swd0s2dlJ0clpjTm9jUE5aeGlkZnB0UWluZ091SEdoUUw1azlhTWxs?=
 =?utf-8?B?TmVFWUxiWEVwMTYvKy9SOGxNRHl1U3dyQmZ2d2pYcHpsZHpPQllQWmNXc0g1?=
 =?utf-8?B?TXFTYnM1TWIvcGJwR1FjS3BxYTBqdkZQUWJkMUxSanNnYXFTeldCd1lERW5Y?=
 =?utf-8?B?aE42UFA2ZmtmVHNQWHhjZHJJeXBQQ3RyVDVOeGV5YUljRERtWlVaQldPb2ZV?=
 =?utf-8?B?Q292RkszaEpwbEZsU252YWgyeW9vU0YzQUQwaFYwUEozbXpadWtoVDQzZkR5?=
 =?utf-8?B?VmxtUlRJUG5CNlcvaGkyNExWeU5UZnJjb1JGd1Q2VnA1MTJRclh2VEVYRnB4?=
 =?utf-8?B?YVM5MzY0aENBZXpsL2NtdDFJVkwwWGlvdW1KZFVEcFk2c0k2RVJkcHptMVN3?=
 =?utf-8?B?NXNrZHNNM3p0cG9uUzAzeURDNWxmd3E5MmpueUw1YjJMSndQREFsRFJrY1Iv?=
 =?utf-8?B?YnRVN2VYa2V0T2I3SzNmRzdZYytmMzVLdmgrYnlpem9hS3FUc2laNldyN2Rk?=
 =?utf-8?B?YjA2YS8zbU9UQTIwY2xnV3pLNlRCSFg2NC9iUmZ0QThaams5Nkk3bkgxTXRL?=
 =?utf-8?B?azJjb2xCeFFsakN6SzVXM2RyZko2OWt2RG8rQ1M2MjY2ZFhYd2RkNUdSNnFS?=
 =?utf-8?B?WVRNNExubC9PRWJaSzloZTRCamZwZmJEMGVvRFhhS1RqZzlZYlg4ckZpelYz?=
 =?utf-8?Q?RbnpZjM/EVcqBa4szB25W/paLWBJ+lzD0v/06Fn?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff84363-9bfe-4f20-988e-08d97ad2fdbf
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2021 18:34:46.9358
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F1ZpvL+WNMR0uyiLNQ3H2QCCbI4Y2onjplgMM2koyAqmeRFBl0BU9vDf9hEY/cK0wwg7HWwo8BZO5XlGzxjfXQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6933
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/17/21 5:05 PM, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/libiscsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 712a45368385..7beedc59d0c6 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -468,7 +468,7 @@ static void iscsi_free_task(struct iscsi_task *task)
>  		 * it will decide how to return sc to scsi-ml.
>  		 */
>  		if (oldstate != ISCSI_TASK_REQUEUE_SCSIQ)
> -			sc->scsi_done(sc);
> +			scsi_done(sc);
>  	}
>  }
>  
> @@ -1807,7 +1807,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
>  			  sc->cmnd[0], reason);
>  	scsi_set_resid(sc, scsi_bufflen(sc));
> -	sc->scsi_done(sc);
> +	scsi_done(sc);
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_queuecommand);
> 

Reviewed-by: Lee Duncan <lduncanb@suse.com>

