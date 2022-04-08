Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05673C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 17:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiDHSAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 14:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiDHSAt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 14:00:49 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EB2FB369E
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 10:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649440722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Aq+I/3Is5kehHnTy4loVmHBSdFAL4KPltsmnEiRgbo=;
        b=jDcv7BtsMHytoDgMTW4+ORnCU0mvz6PcryDPF7IOcnGndW101av12v8jIoJ1O7M1s5CqM4
        +B7oLijl6Gykchlo1c3WXbFEYTCXs7NYOQktMvZzzVypfmQrxDEj8KjSucfXS3CL4uRXI/
        F7pQC619NNjyAIq+JskJ/5w9T7nIENQ=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-24-7f5zziw3Mtu3REdeFhF3Ow-1; Fri, 08 Apr 2022 19:58:37 +0200
X-MC-Unique: 7f5zziw3Mtu3REdeFhF3Ow-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=coeD7ZYQ89vzSmPrP5cdwVtYaPoho4avpue2Kp1E14ayISIo6pUQ1EcKApe/0N5/ZssbJ7i0gerVq76odDSbGTtPEabtrbXuUYLrO44hbCfbpUtJAgY9BKK3DO17lr6jrV3fXR869H6dtTfhc5oju1ijAKV2OWjkNqPvWBNjIJLzFRkBKJlUffAniBy92vCv0/RlliXxN0FCiIeSTr3Sj42psGTdCF4fJo8U6GTriJc0KbQjBhhDbl538+hVW6fOxG2R/s4zhqgD+m1PkiJjpPoZD2MoZWtZ3Xi8Zs1hOoLb9MzL5Xet2cyGOmuRGC+7ZuTqMxwt4Too+WwXELpLJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Aq+I/3Is5kehHnTy4loVmHBSdFAL4KPltsmnEiRgbo=;
 b=KRhrT77j+F1LY6f/7QmBufXpCqpIEnd4nhDNqBVJKKrML+el5FIMwIuSeln1dkV5LVqhPnSd5uTldzBgLQ5kJB5MamTjvw/UHz6hpl0qqd3CURJ+BH+0pUU7qW735LCiAAcA8joFTHmlFg5pN4IkkW6BwFuJGtUQBd1jnE7t3ea37UZgnRE8HL4bGO+mt4j4XC1IuGv4+HGnnCuexKDJ5a+fXil4jTfoXP5LRUpYcYo9w3PnfWMoEYrXmYsvya7xvlch91eKNPqiDgVCgaVEyP9Z8gBSaOf4DXBfi3WvzXz1FB2AequeA41M/2QyqKptUcHCQjDCTL+Ef3pIQbk17g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM4PR0401MB2340.eurprd04.prod.outlook.com (2603:10a6:200:53::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Fri, 8 Apr
 2022 17:58:36 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::6859:e5f7:b761:2d%6]) with mapi id 15.20.5144.025; Fri, 8 Apr 2022
 17:58:36 +0000
Message-ID: <8cf4c2fe-a56f-8f08-80fd-cbc1b907a32e@suse.com>
Date:   Fri, 8 Apr 2022 10:58:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 09/10] scsi: qedi: Fix failed disconnect handling.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, skashyap@marvell.com,
        cleech@redhat.com, njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-10-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
In-Reply-To: <20220408001314.5014-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0088.eurprd06.prod.outlook.com
 (2603:10a6:20b:464::33) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e5535f69-3fcd-45a2-ed3c-08da19896792
X-MS-TrafficTypeDiagnostic: AM4PR0401MB2340:EE_
X-Microsoft-Antispam-PRVS: <AM4PR0401MB234094220636F176FD6B357CDAE99@AM4PR0401MB2340.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DKQZ94uiQCF7EdJquPtQetrhyKl8cOTiqgq79q2lrkK9/5bL047X795f/iENlmdi22gfRI60tf8ezcaSzc0N7kWEq7VO3XLX4jPDqjUbf55HmrJbBuBT2+tLwO/srs6gujfK/E8F8x06+lXY1Sz6L040WQPN8irTJp5OxJTwwuxtyf9NAYGOVdBMapyqxKpBdxDnG6gS3Lmx1IGKD4Rvm3OsGrBzaHHA0iR1HwOfnLHHUn/ofG+q73W31JSZ4zVxmnfSrZ9L5HTDQ5Q9WDCmZeiXWiqPv7j/fgavfnV5MaHchkg2VhbBr+Zkf1CmxEc1RShyTpaudJ4sDayk4RnewScVO10/gAWxsD9nGR2RfKowg7cyfItndDUSGAUgDZg1ReKZXSQKxQYvPzB20m2a1awVMwbGlBc0F6J1xDQLgYiorFdN19Y31M0XGExAIOoY+Oo1jbOCjbHq/jvQqMdrBg/kgA4l2xoBmOUoXsK/4pi1C4Oh/gjg0/nO09P9RjM59GWIf2dUf2Dgudw6zg1pswIHcD1a2srEzxqWbPEc8Ro5ZV43QHk/9DOwxTPfLi68sSC7grVP/kA0s7n4Sb7748D4FVsxSZdCtt/UOdUuMAS8EyPsJbLHAb1JytH6heoqzrSQ7+2v5Dfhe1N/boRVuNiu2aPaOfoTJ0CRkSFi35+8m1z6fDjfC+g01+J+tqZly5vBjj6UTB8kgA2TaUplcYuOs/jDgCD+ta0eO9rdbgQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(26005)(2616005)(6486002)(508600001)(6512007)(53546011)(6666004)(86362001)(31696002)(6506007)(38100700002)(83380400001)(2906002)(66946007)(5660300002)(8676002)(31686004)(66476007)(66556008)(8936002)(36756003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QTltSHpvakc1N245T3FXRlJ5V3kxUWtSNy9OYUN4c3FudFNvRDlETTVSMFFw?=
 =?utf-8?B?Q3RGMnJSSFJQd3ZaQmZCcTlHaGZ3SEliTVhZcTllUC9kR2dtaTN0RXRNamZu?=
 =?utf-8?B?WlBwWXdRRVljUkp5NGxuQTZpYWdwV3ZtbTdiUThLbHNaUWVvcTJ0eUVRYXlE?=
 =?utf-8?B?T0RvbzdGaVE5Qzl4aEFoaDFDQjZGUHBwUlYwZlZObFNRYWdCSjluQjFQRnVa?=
 =?utf-8?B?N0szU3ora2RTSWhWUGoxek4zSm8xN24yVHVmSFpzdkhRZU5OQUNZMmZvN3Ji?=
 =?utf-8?B?dnJaRkNtQWlqM2t6aXZaL21xVWZTeXFNOStMTlBEL1FraWlqZE9IcHlHWThu?=
 =?utf-8?B?djFvaXQvRVlkTFllT3JpVlB0MXhHTGxVUmhRcWdwekduWG1sK0N2ekJDVG9Z?=
 =?utf-8?B?Y2Nqd2g1T1l3RzFIbG9hZVBYdHV6RGpiMmxDKytvYk9MNTNtNmIwMHhGWDdv?=
 =?utf-8?B?QkdDZlQyd0V4a2hjTkFOZE55OE5BZTVIaHhaUnNVRmRnRmdjM1pwQTdiTVFZ?=
 =?utf-8?B?MkJ4dTRrSENGaWRQdUV0c0ZsN3ppUWRaaTBOMWxCTnZiOHh1bnRuMlJxdU9F?=
 =?utf-8?B?MndSblZyOUx2UkNLRVdTbjVPclZJK2phTkJvSnZUWUtaM1ZGcnlpV1pxaDVz?=
 =?utf-8?B?elp1allhNHlZc3JwRlRhUElkVmJZbGtVRzZMNWtjTFpRUGt2c0dxdFJtWWZN?=
 =?utf-8?B?Rm9wazJDaENDRTNPQjg1UlVKOVpvZ3o4b0FDdDBpR1c3WGRHbnU5Wml3aUp5?=
 =?utf-8?B?VHFxd3dUcTQrYXRYZE9SZ3BkczRVeVhzNnovNXJYUlkvTEdQMUNSTzVYbExJ?=
 =?utf-8?B?NmwrbHBMT1hKY3BLZCszS3RKMmZmOHMyUFdvU2UxT1BtNS9PRGdCZEFQSkRJ?=
 =?utf-8?B?V1ljSzdxNGhmbm9xMURnanZKeHZaZm1vd20rZkl5UjBaRmZvVzhZT2grUVhY?=
 =?utf-8?B?ZThJN2JiU1VvTkxIUlZqN3ZSc2NvekxlYUJxRkRDK1ZvUEdaZlh2bEVTVWhC?=
 =?utf-8?B?YmVIMVo1Z0Y2WXgrbHRvdm5VWUZPdWlJWXo2cG91TmQyZTU3VmViUENxR08z?=
 =?utf-8?B?bktJU0JIbG81clZackUxRk42M2dkRGtaZG5FT1c1SnVyOFFjTXIyUDdGc3NV?=
 =?utf-8?B?aElCV1NoRDB2d1JFem15M0kxUVlUR29hVjRXWVdFQ20wN2Y2TUZxdVgraWhM?=
 =?utf-8?B?YVhtYVBQYklDd0RRcGs3UVBlWmh1K0dOUmluUGJUNURkTWZOSVdhM3lROEd6?=
 =?utf-8?B?cisrMVZONXNHY2JYd0JrZnJwZXROem5UZmppRDI1QTQvTTVDLzM5RnIrQlFW?=
 =?utf-8?B?VWhleThwSHNWK1g2OVRwcC94bXVVNDlBL2syVjYySDRkRnV1dFBiemFGUnBn?=
 =?utf-8?B?R1BmL2tKUExyUzdtSmVIRXJ6WFFkK29RaVVhd0FkKzk4aWxPT04rK1lYcXd4?=
 =?utf-8?B?TEVYM2s1eVVPYm15T2ZOVzdGVzNhOE5kYlU0bVl3USt0dmFFUm4vQ0lIYmJ4?=
 =?utf-8?B?TEhQdlFZZTAyemRWcHpDdnVGNWJqSFpoWGY4M1J6ZDdmMVpHZkRKVCt3elE2?=
 =?utf-8?B?MVY0QXlpT3k4SXdBeWs5dklSL2FKQnoxb0o0amVJM2JFUUR0Y0VPOXlKU0g0?=
 =?utf-8?B?a2l1TWwxQlVWNkg5UEtoenpCMFpuakRXbXVQVXh5ZUZ2VGpYR3VYTy9CNXcz?=
 =?utf-8?B?bUUxamZva1NOcTRHMGg3T3AyOXRhT0dUN0VkU1JNck04OE9nNEllSFkzaHQw?=
 =?utf-8?B?LzJGYy92SkQ0dFl6Z1BZSmhia3J6SDhNc0JpajZDOFhadmVWY0tvZHh0Zmgr?=
 =?utf-8?B?MHJMMjhEMTBCLzlBamxrdHBrRDEvNCt4REsrbGxGNlJaMklkaEtGUzhLeHI2?=
 =?utf-8?B?TklmWERESW1KckZFeEdjL0swK01hWUsxOUlkbktkbnpiNmtZSkMzajk4dkln?=
 =?utf-8?B?QUx3bHFQRzlBSllBVUY4OE5tZjF4UW9RZThXRS9tcXZKTlFZTFYzSjkvcWZT?=
 =?utf-8?B?dEhEQktKZ0hqeUZxVUJUdUZQc1BZZlJ1Q2JoODVSRXVDQldWbTFkWk4rbm5t?=
 =?utf-8?B?TmkwaVNhVlI4aElrK09jYjdJdzk4WHRqejh4NDhuTG54dUJBeFVnRlgwQUUr?=
 =?utf-8?B?K082S2dyM3VycGZmQlFBL3RLUlZIdkc0M3Ryc3dXcHhYVnJRQWVlS3NjbFlM?=
 =?utf-8?B?UDRDcmR3WEZ1VlJ3K25NdlU2OU5Od3VXdFUwb05XaDYxR21RV0dNOE1QOElX?=
 =?utf-8?B?MFoxZ1pZYXlFbm1PWTlQdjFSbnNqNzlmd0ZhRnVBS1R5NGFjbTcyZjZaci9Y?=
 =?utf-8?B?bUdUaFEzU3JWV1F5TUQ4Rk1ObzJtLzZDWTM4WXJ0WHc3cko1S3RrZz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5535f69-3fcd-45a2-ed3c-08da19896792
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2022 17:58:36.6180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 270xhdx29RQ6GFTMPLOgFiK2Ifm7GSBpZXr8UmrwEYNCMcEhoe98L4W1bF7h+GbL0ZnHWni6vvRdEkU3GmyqrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2340
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 17:13, Mike Christie wrote:
> We set the qedi_ep state to EP_STATE_OFLDCONN_START when the ep is
> created. Then in qedi_set_path we kick off the offload work. If userspace
> times out the connection and calls ep_disconnect, qedi will only flush the
> offload work if the qedi_ep state has transitioned away from
> EP_STATE_OFLDCONN_START. If we can't connect we will not have transitioned
> state and will leave the offload work running, and we will free the
> qedi_ep from under it.
> 
> This patch just has us init the work when we create the ep, then always
> flush it.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/scsi/qedi/qedi_iscsi.c | 69 +++++++++++++++++-----------------
>   1 file changed, 34 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscsi.c
> index 8196f89f404e..31ec429104e2 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -860,6 +860,37 @@ static int qedi_task_xmit(struct iscsi_task *task)
>   	return qedi_iscsi_send_ioreq(task);
>   }
>   
> +static void qedi_offload_work(struct work_struct *work)
> +{
> +	struct qedi_endpoint *qedi_ep =
> +		container_of(work, struct qedi_endpoint, offload_work);
> +	struct qedi_ctx *qedi;
> +	int wait_delay = 5 * HZ;
> +	int ret;
> +
> +	qedi = qedi_ep->qedi;
> +
> +	ret = qedi_iscsi_offload_conn(qedi_ep);
> +	if (ret) {
> +		QEDI_ERR(&qedi->dbg_ctx,
> +			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
> +			 qedi_ep->iscsi_cid, qedi_ep, ret);
> +		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> +		return;
> +	}
> +
> +	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
> +					       (qedi_ep->state ==
> +					       EP_STATE_OFLDCONN_COMPL),
> +					       wait_delay);
> +	if (ret <= 0 || qedi_ep->state != EP_STATE_OFLDCONN_COMPL) {
> +		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> +		QEDI_ERR(&qedi->dbg_ctx,
> +			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
> +			 qedi_ep->iscsi_cid, qedi_ep);
> +	}
> +}
> +
>   static struct iscsi_endpoint *
>   qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>   		int non_blocking)
> @@ -908,6 +939,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>   	}
>   	qedi_ep = ep->dd_data;
>   	memset(qedi_ep, 0, sizeof(struct qedi_endpoint));
> +	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
>   	qedi_ep->state = EP_STATE_IDLE;
>   	qedi_ep->iscsi_cid = (u32)-1;
>   	qedi_ep->qedi = qedi;
> @@ -1056,12 +1088,11 @@ static void qedi_ep_disconnect(struct iscsi_endpoint *ep)
>   	qedi_ep = ep->dd_data;
>   	qedi = qedi_ep->qedi;
>   
> +	flush_work(&qedi_ep->offload_work);
> +
>   	if (qedi_ep->state == EP_STATE_OFLDCONN_START)
>   		goto ep_exit_recover;
>   
> -	if (qedi_ep->state != EP_STATE_OFLDCONN_NONE)
> -		flush_work(&qedi_ep->offload_work);
> -
>   	if (qedi_ep->conn) {
>   		qedi_conn = qedi_ep->conn;
>   		abrt_conn = qedi_conn->abrt_conn;
> @@ -1235,37 +1266,6 @@ static int qedi_data_avail(struct qedi_ctx *qedi, u16 vlanid)
>   	return rc;
>   }
>   
> -static void qedi_offload_work(struct work_struct *work)
> -{
> -	struct qedi_endpoint *qedi_ep =
> -		container_of(work, struct qedi_endpoint, offload_work);
> -	struct qedi_ctx *qedi;
> -	int wait_delay = 5 * HZ;
> -	int ret;
> -
> -	qedi = qedi_ep->qedi;
> -
> -	ret = qedi_iscsi_offload_conn(qedi_ep);
> -	if (ret) {
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "offload error: iscsi_cid=%u, qedi_ep=%p, ret=%d\n",
> -			 qedi_ep->iscsi_cid, qedi_ep, ret);
> -		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> -		return;
> -	}
> -
> -	ret = wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
> -					       (qedi_ep->state ==
> -					       EP_STATE_OFLDCONN_COMPL),
> -					       wait_delay);
> -	if ((ret <= 0) || (qedi_ep->state != EP_STATE_OFLDCONN_COMPL)) {
> -		qedi_ep->state = EP_STATE_OFLDCONN_FAILED;
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "Offload conn TIMEOUT iscsi_cid=%u, qedi_ep=%p\n",
> -			 qedi_ep->iscsi_cid, qedi_ep);
> -	}
> -}
> -
>   static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
>   {
>   	struct qedi_ctx *qedi;
> @@ -1381,7 +1381,6 @@ static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *path_data)
>   			  qedi_ep->dst_addr, qedi_ep->dst_port);
>   	}
>   
> -	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
>   	queue_work(qedi->offload_thread, &qedi_ep->offload_work);
>   
>   	ret = 0;

Reviewed-by: Lee Duncan <lduncan@suse.com>

