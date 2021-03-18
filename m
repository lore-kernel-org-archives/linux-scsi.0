Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F86C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D00264F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 16:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbhCRQA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:00:58 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:25579 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231871AbhCRQAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Mar 2021 12:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616083240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JocirGJZ1oacpmGT8TJ7CEe2eEgwOaco7ZW5iMSmowk=;
        b=iKr46ketlqjALr1E4ql2RCJRpcOQcgtGdUEks132ZBcdnZ0X765L91Ql2+JU4mQenMdRUW
        4avkQfwHTJ8BbIQAxfj1oYWuIEY9DY0TrDaUuop73jJpFi+Vha8j7AKTQBmFuTDT2xo/2S
        TeiY//7ei0UNW0G+Sv0GLH+EptbJ/Rw=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2172.outbound.protection.outlook.com [104.47.17.172])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-SmbkgkysOTu59G9a8Faa-A-1; Thu, 18 Mar 2021 17:00:39 +0100
X-MC-Unique: SmbkgkysOTu59G9a8Faa-A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpE1nIjecsQz+yzMpNyIRDqnWIY8/6D5kocziKNRj3QmTzjmVK44iUNueui99SN4y7h/bSUAZWOO9WtKJGzA1vsu7aIkpPDcHx02fcpuKxTI5cV8Rr6k5drjUcTmNfcbU8TSFxYFnFQH0Uesv1i6sRRsEPrk8XOPXFqyUnHQOeJ5QBIf44PVIgeUkJ2qvWxaGgoY/DzL4s2l/zL6rtkSctrLDAJDEE+XOa81TiYGgrrAyuc3BbHhQw+lv+elsJo6Q/L8ZoL0xdZQWygPMe2t2biZZbcaW6FCT04i4STJZyxJotQT/pojJfkMIf11ReFWL9i5z9iGV9E8uyM+yrydKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JocirGJZ1oacpmGT8TJ7CEe2eEgwOaco7ZW5iMSmowk=;
 b=EPLnYgK9I3+H5hAFqqGlj6br00gYZ4j/nS8wuw2ooqH4bOiFFTv/GYE2EU/AM5S+f7+Nh7NQYNt7OCXH4PpBbY11QOHcKbfzUNhz08k1LKjyCDAfnklG80u5fUmnM+r3Zk07UkaMajIXIRxNsWNE+h37ryoechomAQxRXZXzfa6yPqJsktQiKsmY4LrYtO9xz9dzlHVlaUf97Bs+86VQCdLg4LQoNIYl++lebBIJwJoBFAeT+QNE9NOq0CyDKk0Rb8zTnru2UvdEaoaEMxljQebHJ5JnbLqzJiHVS1dCfiE3+N09fu4QDrQsJCbeA8XrRpQzcaLjVcp+xM3k9/xIkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4134.eurprd04.prod.outlook.com (2603:10a6:209:44::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Thu, 18 Mar
 2021 16:00:38 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.018; Thu, 18 Mar 2021
 16:00:38 +0000
Subject: Re: [PATCH v2 4/6] qla2xxx: Suppress Coverity complaints about
 dseg_r*
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
References: <20210318032840.7611-1-bvanassche@acm.org>
 <20210318032840.7611-5-bvanassche@acm.org>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <b04f8794-caa7-a21a-0c5f-363dd4ea6e43@suse.com>
Date:   Thu, 18 Mar 2021 09:00:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210318032840.7611-5-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR05CA0014.eurprd05.prod.outlook.com (2603:10a6:205::27)
 To AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR05CA0014.eurprd05.prod.outlook.com (2603:10a6:205::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Thu, 18 Mar 2021 16:00:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4280f78-ebb6-42f0-ff52-08d8ea26f90b
X-MS-TrafficTypeDiagnostic: AM6PR04MB4134:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4134130409A94D69E97D02FCDA699@AM6PR04MB4134.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IoJQRh7QvmDbxy3/SoWBeGqV+nd4eKuZWW/Lnnw7KKCMRl3OBdsUy7IdOZxu8gLWjgnF06hy+xow9ZoY+7n18vn/1aaH7WMmrFbughZaFur3sdDN0d+1TzHW0na8+A1V9J+gwt0u235ho1MW7PaP+zK5KQAmZYuu/YnnLOJVaXr4h8tLHKleSm3vzrLUTEXVl73jZ/OJG8UcyMnH8nCeX9vFwmrmsxtkySQjTJWfrnIuwcYqlmWEztcisRy48GL7yEH/RmcIzpoKuawSGCGlGcP6vfWPDP7MwP6Eh3KL5tRWpxSs+vn7es7LUErCvsxKKLB3vyN+TLe0BImV6o/6HjAuHmaCBjlBvFJuQuVmNQjZ9vn17jL1AgrAZyyhPFqKlPsIYUQqOozsTjTMETPGF70/1N9CNmuM8lh+xR2iiwsAG8A/0RR1bzyuvYTaXTFMZ8Wq6KjS2yjoEc0cxQUWByCvUhCl29uCyBzr7RDxFFTVvkyFCAlPkBQCC1p1KhhlGj6VZmE5JokkWWdtvsxm3S++NiveBV7kalVhxhxQEC0hnrpyg3nKDkk/A4c0XScdiAO92G1nzZ01H64EO/VO6RWrZFYEPQNcSTB2mHl2ft1DTSOVGLk4PRcI6uVnphUNd2brbyOKJXENgjllljUClrS26dHEKtt5nBLqtBlqvzw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(346002)(396003)(39850400004)(54906003)(2906002)(956004)(6666004)(31696002)(86362001)(31686004)(38100700001)(6486002)(316002)(2616005)(52116002)(36756003)(16576012)(8936002)(66476007)(8676002)(4326008)(110136005)(66946007)(83380400001)(26005)(5660300002)(66556008)(53546011)(16526019)(478600001)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R2QrSG9WNjB5eS9mTjMrUjF6YTdIQ3JWa3NiQmowTU05SXkzVXBTMjhTS2h6?=
 =?utf-8?B?VDlhM2l1amN6d0JZZ3BjelEyZS9QckJ6VVVzbWxaS2plTGtOQm0rcGcvdVpQ?=
 =?utf-8?B?UEQraWZUT202UDhJczZKY0MzY0IzL1A1em9kTHhFRndWQmRwUmRnSlVQM1kv?=
 =?utf-8?B?TmRjREkvbVAvYy9DNFFsU0RaaW40QXJWcnk5MldXZms1R0QxKzVEUDd2RWtY?=
 =?utf-8?B?dTIzakdqYm1NbGRoSGZwQ0dobmNUUEc1WWJ5WjBkRUc2cGVkUWhjQ0tVQkRw?=
 =?utf-8?B?UXk0V2tIK3BBeEhmeTVaSlg5N3lMYkF3UEZHZy8xOXZmenp3WG1LcFlmY1RL?=
 =?utf-8?B?dmpjdG5lZVplSkx0dCt4NmpaMkNlV3dmelkwWDVHVzZTQnNLUUMyMjl5eVh1?=
 =?utf-8?B?Znd2cHhjYmFPUXpFY3pYRmUzRXlpYmoyeThreTZlSWRaVWl4K1JyQmYzZlQv?=
 =?utf-8?B?cDNYS0Fhc08wQXBPbGFLdmpCZWZFS3ZXZlY2ZjFrUCtxWFhDTzRtNHNxQzRV?=
 =?utf-8?B?Ym9ndnVxWVVWbFJiK2p4NjltMkNHbVJyY3JzMWVTTXF4R2lkWXJEYkNnWkhS?=
 =?utf-8?B?MlZJSlZQSEJlVVdGN3Q4UThHYlpRSEF1NTNabHJHUkI2enBoU25QeUhpYzlj?=
 =?utf-8?B?ZWJBRUlLWWVnREVFV3BsVFAzcFpsdFRocnYvdmlvWm5ubEkweG02WUdZTE5k?=
 =?utf-8?B?ZTgybjJLWEl2ZGpKV2JJRG9HYmt3d3RSM05ra3NZbitkT2YvbXprNGx5YnpJ?=
 =?utf-8?B?M3NKRXkrY09qWjVETXp3dVRGTGs4cFd0Q3REUFZ1RCs5cE1xMnNZOUlFUTA5?=
 =?utf-8?B?VktXeENENDJDMGswZWRUczZNdCs5dldKSFBwK21KTzVzRlc5ZlJkWjBMMDVp?=
 =?utf-8?B?RTA2NUwzMmdnZ1BFL0xrdU1SSUpEMWZlNXdoSE1KSG5WOE1TQWNCc3ZzYXl1?=
 =?utf-8?B?MGdVaUlocTkxOW1LMWN1NEpOb0p0QjczeCtkVHpFMTlZUzNlOWhFZDV3Ukpr?=
 =?utf-8?B?UlU3Z0pkcDExK2tYYVU2R1JoMGQvT3pGOTJnMSszc3BUNFRtQThXRFcxQUJu?=
 =?utf-8?B?YVgzaCtYN3pXUWovTVVoclpKZXVmcWw1NDB2QWk4ZVBjdmdWNVdSMlk2OG1H?=
 =?utf-8?B?RTFwSU5sNk5qcjlzSDUrblNaUHVZcnJkKzFzT1FSa1BPbkxvYXNYL3VLempT?=
 =?utf-8?B?bWVnTkFiaDdVMEFXc1FBVk5Pd2poeld3UUpRZk45V0drcUx3NUJoYnNUcDBo?=
 =?utf-8?B?NTRNQWxycVlUN3Iyd0xyVk93QkJZY3dQciticm5ZaGxNRjA0YVk4dUErdHRu?=
 =?utf-8?B?NjNWR2hBNzdmeXBzWXpTaWRmaEdnNW1HdUE1UVVXcFpKSDBQaHk5T00zTVlL?=
 =?utf-8?B?a0N3MmNTdEtJVzh4MVQvS3hVY3JvREhkS0UrVkgwTTZSTjVoYi9pbGVJSFZR?=
 =?utf-8?B?bWhQQjRucUlTeWxtdTB4akpDVzR0SSs4UUJFUHZWOHU5WHYzOTJxVW1pRGpt?=
 =?utf-8?B?QVVQOWtjbWdGd2pkb1BsTy9BSW82Z2ZjUlcxZEtYdVQwbm9zNGQxSk1QUGdp?=
 =?utf-8?B?TDRjdU1vVUlqdlhTeW1XSUh1MWsyNWdEbmdZY1pWWHJpQ1J6SDlCL3BWcUgy?=
 =?utf-8?B?VjJsSXhwK3lmSFhEcEVPLzVtR1l0eVlBbnJUUk1oRzFnOXVDcnZtQXVkc0gz?=
 =?utf-8?B?cGE4TWVkbk1WTWhKaWh2cFNtSmdjRXVxQUhrcmgySWphQWFoTnJjOWtFelpk?=
 =?utf-8?Q?q9aafykQYNPt0BFRh+vvToP2RF4GsNFT0H66D87?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4280f78-ebb6-42f0-ff52-08d8ea26f90b
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2021 16:00:38.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FGOIKZslIgurXBOl5XGCyQI5Bz6MyqrM0dxouKTafNkesZyrjukbOo8n9OtDs5HiDhH8ow/EB2fHEJ2SAZVMCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4134
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/21 8:28 PM, Bart Van Assche wrote:
> Change dseq_rq and dseg_rsp from scalar structure members into
> single-element arrays such that Coverity does not complain about the
> (*cur_dsd)++ statement in append_dsd64().
> 
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/qla2xxx/qla_mr.c | 12 ++++++------
>  drivers/scsi/qla2xxx/qla_mr.h |  4 ++--
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
> index ca7306685325..61eaf6c4ac47 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.c
> +++ b/drivers/scsi/qla2xxx/qla_mr.c
> @@ -3266,8 +3266,8 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
>  			fx_iocb.req_xfrcnt =
>  			    cpu_to_le16(fxio->u.fxiocb.req_len);
>  			put_unaligned_le64(fxio->u.fxiocb.req_dma_handle,
> -					   &fx_iocb.dseg_rq.address);
> -			fx_iocb.dseg_rq.length =
> +					   &fx_iocb.dseg_rq[0].address);
> +			fx_iocb.dseg_rq[0].length =
>  			    cpu_to_le32(fxio->u.fxiocb.req_len);
>  		}
>  
> @@ -3276,8 +3276,8 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
>  			fx_iocb.rsp_xfrcnt =
>  			    cpu_to_le16(fxio->u.fxiocb.rsp_len);
>  			put_unaligned_le64(fxio->u.fxiocb.rsp_dma_handle,
> -					   &fx_iocb.dseg_rsp.address);
> -			fx_iocb.dseg_rsp.length =
> +					   &fx_iocb.dseg_rsp[0].address);
> +			fx_iocb.dseg_rsp[0].length =
>  			    cpu_to_le32(fxio->u.fxiocb.rsp_len);
>  		}
>  
> @@ -3314,7 +3314,7 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
>  			    cpu_to_le16(bsg_job->request_payload.sg_cnt);
>  			tot_dsds =
>  			    bsg_job->request_payload.sg_cnt;
> -			cur_dsd = &fx_iocb.dseg_rq;
> +			cur_dsd = &fx_iocb.dseg_rq[0];
>  			avail_dsds = 1;
>  			for_each_sg(bsg_job->request_payload.sg_list, sg,
>  			    tot_dsds, index) {
> @@ -3369,7 +3369,7 @@ qlafx00_fxdisc_iocb(srb_t *sp, struct fxdisc_entry_fx00 *pfxiocb)
>  			fx_iocb.rsp_dsdcnt =
>  			   cpu_to_le16(bsg_job->reply_payload.sg_cnt);
>  			tot_dsds = bsg_job->reply_payload.sg_cnt;
> -			cur_dsd = &fx_iocb.dseg_rsp;
> +			cur_dsd = &fx_iocb.dseg_rsp[0];
>  			avail_dsds = 1;
>  
>  			for_each_sg(bsg_job->reply_payload.sg_list, sg,
> diff --git a/drivers/scsi/qla2xxx/qla_mr.h b/drivers/scsi/qla2xxx/qla_mr.h
> index 73be8348402a..eefbae9d7547 100644
> --- a/drivers/scsi/qla2xxx/qla_mr.h
> +++ b/drivers/scsi/qla2xxx/qla_mr.h
> @@ -176,8 +176,8 @@ struct fxdisc_entry_fx00 {
>  	uint8_t flags;-					   &
>  	uint8_t reserved_1;
>  
> -	struct dsd64 dseg_rq;
> -	struct dsd64 dseg_rsp;
> +	struct dsd64 dseg_rq[1];
> +	struct dsd64 dseg_rsp[1];
>  
>  	__le32 dataword;
>  	__le32 adapid;
> 

I dislike such an uncommented change just to keep a tool happy. Could
you add a comment in qla_mr.h saying why these are one-element-long
arrays, just so nobody optimizes those out later?

If you do that, please add my:

Reviewed-by: Lee Duncan <lduncan@suse.com>
-- 
Lee Duncan

