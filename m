Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0E1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 21:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiERVyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 17:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiERVxx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 17:53:53 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E09C14E2E4
        for <linux-scsi@vger.kernel.org>; Wed, 18 May 2022 14:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1652910153;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9nOUSmm/p7iWvqgs/IKB7wJKbko67h4y58bdd9SuBAA=;
        b=bXoqc52KziDo0nRt727u7CT0a9Yf/AQdyRbqYFlPek6ZOnyfr/LWkDMZuxYLwiXyYhO9yM
        lyZB/SClF+VEgpdP7rMS90kniEzIJE/H5xIPH0ZLehiLXzgTIgRBVRuGWvwbXOfuchnI3l
        iSa/qDD0dzGRD7DfAU3ZMRZqO6j3I/Y=
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur01lp2059.outbound.protection.outlook.com [104.47.2.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-12-UJGi9eAVMLedX-4JY_e41Q-1; Wed, 18 May 2022 23:42:31 +0200
X-MC-Unique: UJGi9eAVMLedX-4JY_e41Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhq1G61QwU+VCbOvEHgg8LNSOfVU1S8tPD0yx05xAoJykKITMxaKeDkkl/1Q5aZPSbI8i8uxFuCM/1BP+88Fr8+/r0WYbWWNImkr5dq4lLkMTFwWCx6AFzfFUaz96SmL6HWdbvIYBZgumQdf8jyvhGP9BUBZbI6rJcK7+BWIJ3Qx/MOnmdpJai/yNpAdGM3gxH4+5iBSvv6OqQWp/Yaqm9SJcG6QI6sAB/ZqsEwULgEoZEHIzYJmTKjVdEkGKJdAn/cqeMs+/7dpgKGON9mW/cObUncrRgAeZWB5S5pD71TByUOtveyhf06FWCCOgUjL8K51JtfbHKvvIDwgu10c8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9nOUSmm/p7iWvqgs/IKB7wJKbko67h4y58bdd9SuBAA=;
 b=lUf0Uf6l+l5fwop20Q0B6ziqOxLVvdalGEE9Ap1dI5x/QKV+j/tayQU/MtpilWkaK9N6GU2APt7yp9/jrVZMEkgCC7nF4QW2vwac90ebMQqheaINIKYXgOwL4CZlhrZdmK5VnOMyzsM6VSCUnAlFdQzbVjf2GTGEFP7y3lEjQtWwTsdUQT/Y8BUxB7Du2gwk5qXbLrPIpJA6d7trxgRk63EtTgAXhgebZ9jh70Ha3//+Jt/PVx4qqqwaeH0yM3lNTvQRfVY7g/DZnaiuMnEbezBXNvV1p7UTNvzad7kLARl1a2XjfYFKcDHY7v2fzA4Xq8Ttiby1OdsQ9IjHQN9eMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM0PR04MB6545.eurprd04.prod.outlook.com (2603:10a6:208:173::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Wed, 18 May
 2022 21:42:29 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::541:b6df:93f7:a5f9%4]) with mapi id 15.20.5250.018; Wed, 18 May 2022
 21:42:29 +0000
Message-ID: <30b421e9-bd13-ae13-d374-d8338abcf24e@suse.com>
Date:   Wed, 18 May 2022 14:42:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 04/13] scsi: iscsi: Fix session removal on shutdown
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220517222448.25612-1-michael.christie@oracle.com>
 <20220517222448.25612-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220517222448.25612-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0402CA0004.eurprd04.prod.outlook.com
 (2603:10a6:203:90::14) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dc426fde-0f58-4447-3c81-08da39174ec0
X-MS-TrafficTypeDiagnostic: AM0PR04MB6545:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB6545EE22A239A2D5A4349DAEDAD19@AM0PR04MB6545.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P9gyuEOwIYQu6SDZLQcMTOIsMxGVNvC2RvkwN94XeO2/grejshA2fZT3vqGEPcb6buQ/ZCg4jiK1SkWX+dcI8ZQk+w7l8O4GNH1LFypY4Y5TDxhCBuxryrgN2mns0zsOUDBiwXhYXeK0vSlo2yw5l7J6AYCme+eGNxcrnnzWedL1896oxUZQxU/O5Q22OVEuAR3e41hX0+EWRVcdiKPc0j88LR655WY6n8K251059zCbkj6hu7DRnNosfo3dP3N7HCa0+R5UjMH6ab3BwjtWk7ni6i2IVnQy+XfHPt9pLFcvOPwsL0htgaRqsrdbGNRcwUliQ7BOzFjVJTElvmgIQbpYlEhkTero59G2MCGHFtmQspzvDyraC5UbvNVzuasyYW2h6/6GjiQ182gX2gPLxh6kuVEr0nUmrHi7BNbVzohP+TlMNBGqhcXGTrwU9Ev1ZSX2cEd2Le0jCjP70yW45YFbpwYZE26pplyUdXDLvNFBh9OFdTdWP5rrqc4hCgsaep4K0jt/W0f2LQzjEJA7+Zpl8moH/d2IU+R9htF+Sby0fanlIC1wqaMEoyXAZChv1xkUGSpRCRA9PR2V2L7oFXlKtLh9YZPw8BPYmS6cn+vRlHwOK57cB+m+BMwPADWZSmBKzdpurWSF73dIBjNFL7R8ygkJ6LyNsaxbbKEQjSvgYwumQNoG37mTAwYRZk0HoZYRpoHSj1+rNU50JawmeEv//zqOUY5wIZKPx4C9AwGPiO6CHvh7Pag7Ss30r6L+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(6512007)(6666004)(6506007)(26005)(83380400001)(31696002)(86362001)(186003)(2616005)(5660300002)(8936002)(66476007)(66946007)(66556008)(508600001)(8676002)(36756003)(38100700002)(31686004)(2906002)(6486002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2J6SnhiT1VYWWx1MnJmN0UyNFpLSFNjTnU1UlI5V29qL050enFQbnRpYzdO?=
 =?utf-8?B?bmZwbzhqZVpITnAxTWs1ZDVLbXppakdNOW93RnZWYTJYZyt1R0FHZUx2bTZZ?=
 =?utf-8?B?WGI1UmVRQ3BpZDN3OVlDcStoOFZEU2s2MUFadHhjMUdDL3NVbnNwZVRYaFNS?=
 =?utf-8?B?RHVlMWNTeGNhSXExSFpBVDdwT296MnRBTXZybC8rUGREaUc2TVJJR1NlcDRy?=
 =?utf-8?B?NlpuTzlmTnZvWkthTHlSQjhidVpSa0NKU0QvM1MwUU95QTUwZmtING9wMXJ3?=
 =?utf-8?B?WEMzdWkwenpUZU5UOHhaUE9SRVJJVHFBM1ZSMmhuaSsrbFJLcWJvM291M0hR?=
 =?utf-8?B?OStGQStaVjZlQmVOc212WlJ3cHhUODNIbW5OeHZXbk9HeVBQejQrdlpPUm5R?=
 =?utf-8?B?cUhYNDFoa2U1OFVOMkxtQStIWERyUHRuUmJmVzBmQktlWWhoOVM3MWsvRWM3?=
 =?utf-8?B?OFppWEFRRjBaOEJDU081d0FhZ1pEK3VLSGhZeEtSRjVXc0FwWWlGZ21FOWly?=
 =?utf-8?B?Z0JhZUorMDdLdWgzaTR2SW1PYkcyNmtKYnFkczA5WjRnRENTUnB1Lzl6NnNo?=
 =?utf-8?B?OEJDVmRpYzd1OU1VbmRGTjBKYWlpcTl1eks4VGhUTGhxTzljUGpoOGU3OWxk?=
 =?utf-8?B?ZFlZckxzTFlqSjRGeGZKYm9TMkFSbHhXS0NVNkFzREdqZkFoS2RDRmo4OXl3?=
 =?utf-8?B?ZVphMFJqdjVYVmttdXlPa1VyZk8vTllrRzk5bTRsSFJuSDJNR0QzUkx2UDRG?=
 =?utf-8?B?dU5xN0hoQU5JRWZYQlAwSi9RTE1oVHpiUEhrQ1lhNDV4Z2VQbW1wR3pTbUxP?=
 =?utf-8?B?QnYrSFlSUFpnWktMaU54NlY3dmkxdGZyQTJ2QVUzTWRMKzRSSGQxVk5DOXRa?=
 =?utf-8?B?ZTZteHBvS25rOERJK29nMEk1blZ5ZThRQWVvc2dFWVJ2UnducHRVV2I3OW9E?=
 =?utf-8?B?bUVZWUoyRktCM3VZWHNHTTZ6amhNM2N4ZmNKR2JiaTRLK3hhazB0TWN2SFM4?=
 =?utf-8?B?WFU0NHhicWFVa2M2N3ZNNVF3YTc3VVNQK3NyOEVzaUtnSXdjV0NpZDVxbWJu?=
 =?utf-8?B?MVd0Nkg4NDYwb2xMblFaTmNmOUh5TlJsYUFwYjY1TXBZN0tReEFOdkZMNzVq?=
 =?utf-8?B?Tm1SY0JNWmc5ZFhTd2JuS0lNcnIyNWF3SXZPSk9DekhvZHl1ekQ2NENGMXNI?=
 =?utf-8?B?aVBIcnFKT0MwMytrZUJJaXo2T0VWSWQ1bkZpbEFKdEg4SlpDNHVyc1VGZDdj?=
 =?utf-8?B?Rm1URkVTa2FldjFGTUQzSEFYMU9hU3ppV2RPR1dBYTFjRE9qNU81eUthQnpB?=
 =?utf-8?B?VXBncW9kRm5za3BxRkh0OGhJSUQrZHJkVDU5WmIzMm5Bd0RuZmNWVE1iN1B4?=
 =?utf-8?B?MkxRM3BNcUtjQ3kwMjVPTWI5c3JVYkNmaTVxM0EwelRsYUNveU9yYTUrRmcx?=
 =?utf-8?B?a0cwbFpIMVVBdFhqSnpXZHJGWTlCUkIrTkh5ckRzdkxPbFlUNFRLTEdrOGdt?=
 =?utf-8?B?WXNwejRidVhaUUozVlBzRmxNaWs3T0FRUnNKbFNRd1h4T3NmV08zM2l4ejhk?=
 =?utf-8?B?cnNCMWpCVjB4YWJGeVlGeXZDNmQyT3NuVkhqei9sVElmZnJvY0R4NE9XQmVo?=
 =?utf-8?B?aTFQbnpRNjNMTHhhejJGNkdEclIrNWhMNnNiNW1jeFNCcnJwWkoxMWxOV1FU?=
 =?utf-8?B?bFdRQVBIUE1ieXhvZ3hDZ29nSERCUlRLcVUvaWVJbUJRV014aTRad0ZnSkZh?=
 =?utf-8?B?QThyZkt1Njl6RE1OTWdEbHJlTWVvaEsrZUx1UTZZbDZYWGdKL1UwTmVuRDVQ?=
 =?utf-8?B?UXRQdFh0NkpoaVBoY1R6WG5IcTR0L2NTRnFWMENrb0dmZHR4MTEwSFErckxn?=
 =?utf-8?B?anVtVnRSRDZkN21URVE2bWdTM2ZXRWlkbzNQeXk5TGpQQmJnUTBXMmFUNWo4?=
 =?utf-8?B?NWNudjdvald3NkQzTXZSVU1kZXhocEJ1M1RuMFRoY1N4ZHlkRStraWgvT1A2?=
 =?utf-8?B?dm1KRnlEenJ6U3dKdnlnK0o2VXIycFlacmQvQnd3SUpUM3NOOGFCcVpiUjZY?=
 =?utf-8?B?cnZyMmdPL29sempscVYxdjVlSzI2MGNlTW1tSENoaGg5c2FTWmJzeGVmVFVQ?=
 =?utf-8?B?Wnk1UEVUd09NaUJEejN4ZWp3SWtKRmNUTHZLY2xaajN0UHhDYjVnQTJ1QUFl?=
 =?utf-8?B?WVVMQSt4MnlyL0pmTGgrd1FwR3hWSFRrNHlndWxYUUw4eG1XbitnV1JaQ2kx?=
 =?utf-8?B?bnpXaW5ZYWNOZVJaek5jaWJhYkNFZ09jZ04zK1VNR3k2OWp2bERxaGU4M1JU?=
 =?utf-8?B?Szk0cVZKUHRxeGh1YnRTWUhXRGdCUlNIR1VvQnNLYVRHU09xajJSdz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc426fde-0f58-4447-3c81-08da39174ec0
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 21:42:29.6160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ynJqAZj3cuhhtvWkQVlgwA0fXLHrAWZYflhCHE3G/9mqOzukBEeFnIj2wEHXFyJqtZamLwhKDuzkW+51fifFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6545
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/22 15:24, Mike Christie wrote:
> When the system is shutting down iscsid is not running, so we will not get
> a response to the ISCSI_ERR_INVALID_HOST error event. The system shutdown
> will then hang waiting on userspace to remove the session. This has
> libiscsi force the destruction of the session from the kernel when
> iscsi_host_remove is called from a driver's shutdown callout.
> 
> This fixes a regression added in qedi boot with patch:
> 
> Commit: d1f2ce77638d ("scsi: qedi: Fix host removal with running
> sessions")
> 
> where in that patch I had qedi use the common session removal function
> that waits on userspace instead of rolling it's own kernel based removal.
> 
> Fixes: d1f2ce77638d ("scsi: qedi: Fix host removal with running sessions")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/infiniband/ulp/iser/iscsi_iser.c | 4 ++--
>   drivers/scsi/be2iscsi/be_main.c          | 2 +-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c         | 2 +-
>   drivers/scsi/cxgbi/libcxgbi.c            | 2 +-
>   drivers/scsi/iscsi_tcp.c                 | 4 ++--
>   drivers/scsi/libiscsi.c                  | 9 +++++++--
>   drivers/scsi/qedi/qedi_main.c            | 9 ++++++---
>   include/scsi/libiscsi.h                  | 2 +-
>   8 files changed, 21 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index f8d0bab4424c..e36036b8f386 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -568,7 +568,7 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
>   	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
>   
>   	iscsi_session_teardown(cls_session);
> -	iscsi_host_remove(shost);
> +	iscsi_host_remove(shost, false);
>   	iscsi_host_free(shost);
>   }
>   
> @@ -685,7 +685,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
>   	return cls_session;
>   
>   remove_host:
> -	iscsi_host_remove(shost);
> +	iscsi_host_remove(shost, false);
>   free_host:
>   	iscsi_host_free(shost);
>   	return NULL;
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 3bb0adefbe06..02026476c39c 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -5745,7 +5745,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
>   	cancel_work_sync(&phba->sess_work);
>   
>   	beiscsi_iface_destroy_default(phba);
> -	iscsi_host_remove(phba->shost);
> +	iscsi_host_remove(phba->shost, false);
>   	beiscsi_disable_port(phba, 1);
>   
>   	/* after cancelling boot_work */
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 15fbd09baa94..a3c800e04a2e 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -909,7 +909,7 @@ void bnx2i_free_hba(struct bnx2i_hba *hba)
>   {
>   	struct Scsi_Host *shost = hba->shost;
>   
> -	iscsi_host_remove(shost);
> +	iscsi_host_remove(shost, false);
>   	INIT_LIST_HEAD(&hba->ep_ofld_list);
>   	INIT_LIST_HEAD(&hba->ep_active_list);
>   	INIT_LIST_HEAD(&hba->ep_destroy_list);
> diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
> index 4365d52c6430..32abdf0fa9aa 100644
> --- a/drivers/scsi/cxgbi/libcxgbi.c
> +++ b/drivers/scsi/cxgbi/libcxgbi.c
> @@ -328,7 +328,7 @@ void cxgbi_hbas_remove(struct cxgbi_device *cdev)
>   		chba = cdev->hbas[i];
>   		if (chba) {
>   			cdev->hbas[i] = NULL;
> -			iscsi_host_remove(chba->shost);
> +			iscsi_host_remove(chba->shost, false);
>   			pci_dev_put(cdev->pdev);
>   			iscsi_host_free(chba->shost);
>   		}
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9fee70d6434a..52c6f70d60ec 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -898,7 +898,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
>   remove_session:
>   	iscsi_session_teardown(cls_session);
>   remove_host:
> -	iscsi_host_remove(shost);
> +	iscsi_host_remove(shost, false);
>   free_host:
>   	iscsi_host_free(shost);
>   	return NULL;
> @@ -915,7 +915,7 @@ static void iscsi_sw_tcp_session_destroy(struct iscsi_cls_session *cls_session)
>   	iscsi_tcp_r2tpool_free(cls_session->dd_data);
>   	iscsi_session_teardown(cls_session);
>   
> -	iscsi_host_remove(shost);
> +	iscsi_host_remove(shost, false);
>   	iscsi_host_free(shost);
>   }
>   
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 797abf4f5399..3ddb701cd29c 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2828,11 +2828,12 @@ static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
>   /**
>    * iscsi_host_remove - remove host and sessions
>    * @shost: scsi host
> + * @is_shutdown: true if called from a driver shutdown callout
>    *
>    * If there are any sessions left, this will initiate the removal and wait
>    * for the completion.
>    */
> -void iscsi_host_remove(struct Scsi_Host *shost)
> +void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown)
>   {
>   	struct iscsi_host *ihost = shost_priv(shost);
>   	unsigned long flags;
> @@ -2841,7 +2842,11 @@ void iscsi_host_remove(struct Scsi_Host *shost)
>   	ihost->state = ISCSI_HOST_REMOVED;
>   	spin_unlock_irqrestore(&ihost->lock, flags);
>   
> -	iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
> +	if (!is_shutdown)
> +		iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
> +	else
> +		iscsi_host_for_each_session(shost, iscsi_force_destroy_session);
> +
>   	wait_event_interruptible(ihost->session_removal_wq,
>   				 ihost->num_sessions == 0);
>   	if (signal_pending(current))
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
> index deebe62e2b41..cecfb2cb4c7b 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -2414,9 +2414,12 @@ static void __qedi_remove(struct pci_dev *pdev, int mode)
>   	int rval;
>   	u16 retry = 10;
>   
> -	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
> -		iscsi_host_remove(qedi->shost);
> +	if (mode == QEDI_MODE_NORMAL)
> +		iscsi_host_remove(qedi->shost, false);
> +	else if (mode == QEDI_MODE_SHUTDOWN)
> +		iscsi_host_remove(qedi->shost, true);
>   
> +	if (mode == QEDI_MODE_NORMAL || mode == QEDI_MODE_SHUTDOWN) {
>   		if (qedi->tmf_thread) {
>   			destroy_workqueue(qedi->tmf_thread);
>   			qedi->tmf_thread = NULL;
> @@ -2791,7 +2794,7 @@ static int __qedi_probe(struct pci_dev *pdev, int mode)
>   #ifdef CONFIG_DEBUG_FS
>   	qedi_dbg_host_exit(&qedi->dbg_ctx);
>   #endif
> -	iscsi_host_remove(qedi->shost);
> +	iscsi_host_remove(qedi->shost, false);
>   stop_iscsi_func:
>   	qedi_ops->stop(qedi->cdev);
>   stop_slowpath:
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index d0a24779c52d..471422641ab3 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -411,7 +411,7 @@ extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
>   extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
>   					  int dd_data_size,
>   					  bool xmit_can_sleep);
> -extern void iscsi_host_remove(struct Scsi_Host *shost);
> +extern void iscsi_host_remove(struct Scsi_Host *shost, bool is_shutdown);
>   extern void iscsi_host_free(struct Scsi_Host *shost);
>   extern int iscsi_target_alloc(struct scsi_target *starget);
>   extern int iscsi_host_get_max_scsi_cmds(struct Scsi_Host *shost,

Reviewed-by: Lee Duncan <lduncan@suse.com>

