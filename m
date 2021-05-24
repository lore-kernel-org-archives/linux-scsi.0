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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB32C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A66D360FE3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 18:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhEXSiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 14:38:54 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:54392 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbhEXSiw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 14:38:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621881443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WPyRiYjjo2kLqd2rLwSsiuwu0geubU6g2uYn/g0C+FA=;
        b=NR9SiKMOJ7emNgDwY3eilYy4r/+2+LCLAWkuTkJdR60357KYPQFx3W2g1h5JAzP/OV/F/B
        YKbPFl1Nyz9ECstQHBJ8GvMB2qH3IGQTSXC3wLEb7NGg6YEo5P+pD0ZUT7+k5sUerybRPS
        nSzmJ5Ja4NM37HbvuCNAAPAgicPMlVE=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2106.outbound.protection.outlook.com [104.47.18.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-sTSd-YtJPOmtyL_zlhUL4g-1; Mon, 24 May 2021 20:37:21 +0200
X-MC-Unique: sTSd-YtJPOmtyL_zlhUL4g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yu6sTCjnrkbDtD1Ei76FN3g8i4ORK7WXX5UdR+lSreqqHlVodYe37e7pJ2pjgAGmf0MgQ7PEFQgQIElu5arz6cxlmgrElyaVwbAdhgYpKaB/QqcAggYiXH1lu3hg+SVXsWv+vaqlGcFnwUtJLt9SbG9C3eeXlBQsx56kV2oNaOjS79PjmmhugBSSQ6C7ybXqnHOcocSFhmYtMqrAcOmR23F7n6lE68glWkC3RU364btntP3CDY4nw2CWfBPGXgkczSu4aqAJCg1glkQxPcAuryWlcmU/z1g5Uj4thjB/INb/EetgzGj/6q1Mk5M+xxoBJUkj5yb1slzk3vQURNMCug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WPyRiYjjo2kLqd2rLwSsiuwu0geubU6g2uYn/g0C+FA=;
 b=kGBck7ECUdpr7YvkEwr4X18KmgzkJVxGPpoY2t9GNGYM8x52ugyK/l6Ctw4Mj//SmmWBP+YmOI8tJwsUTL6eJVBkpFXEulxmprZbYkVhO3lbSy7m8nu5sbwp88KrFD6zQf1LWhGv2qvubHQoxM/QhWdTDpkNyB8mqPd1yDvJVjXEgZlpa65B40jxY40goFd8YoNGiXxKok7BuNanfDXbXeFSahbTpGEJ2q9hO5Rlyh3G9121Gs4cchUnUkyW+xRqbURtxYSIS6DucslXEQ3bN5mMtlvdRfGhvEGvq057VWfybvB2eXJPTAsKqfohtfO9JrzerD3ReOqmLjemruSU9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR0401MB2546.eurprd04.prod.outlook.com (2603:10a6:203:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Mon, 24 May
 2021 18:37:21 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 18:37:21 +0000
Subject: Re: [PATCH 12/28] scsi: iscsi: Get ref to conn during reset handling
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-13-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <7ddcb66f-764f-e25d-bbe3-a7df515a7792@suse.com>
Date:   Mon, 24 May 2021 11:37:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-13-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR0P281CA0079.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::19) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0079.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.16 via Frontend Transport; Mon, 24 May 2021 18:37:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58ce1cd9-4f4d-417f-37ca-08d91ee2f748
X-MS-TrafficTypeDiagnostic: AM5PR0401MB2546:
X-Microsoft-Antispam-PRVS: <AM5PR0401MB25461600A71E3077AD53E844DA269@AM5PR0401MB2546.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIOWjFJzCFQBvwkce5J5GNpBmwVOtqxDWT9l5iwb15p5mIcE9+j9uHkeUvddCOLRQeKi3m6O9fFuLmqkXfLbj7UzbmYuPL06hPn1waKPZxQbVpKXnYcL0FZgz6/sn2lP38D6rkzSfBuA+jyr5HXr12aiw10DxW6YR+lv42jZbiSXeEDDsbqgAX+585oLId8XIWZS3gIJ7nb0jNO1djB0WonGrnneFxNEr3qsemEwsWr5dE9ZN5grbsswPJt8V9+7atRHah9glwJA1rzNSZZr8ccMIckAlgztL56rlHc1XT1cn6XqNUL1yF/h0zh/m1W5JTaVhGmRyUPgIuV27CbVst1xleO8LFc92GOk6lBPsCka0tLIH17Dth49vPlZJAOxbz759NQV6qDmHHHj2NCqaER9GHmxoqyfPJa1aUBgxAS3gRnlsRxmouxjaYJqSkDUJSGLCorvActNcWLtiicE8yJdts45Y1CtG+6kV8IJt3ryduywd0NvFcUpuyW2nMEBAgE3uyvNHtX+V1s6GWIuYBx3Z4hUbCecxAZKwxafUSZsvygtmHXBjW0bj4qJ5uRKRe0/daXK54itLU2It/C6gCMtqe6GWUp60RvPIbChv/fCEHZ4Ik1bAnc2oLp4trtIwAazUldW1TlFcqeGegDey5rcWEpGDWxepE+IwaYvG1uWBkuAO0zhrg3J1qX1LErL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(366004)(39860400002)(136003)(6486002)(5660300002)(2616005)(186003)(38100700002)(36756003)(16526019)(53546011)(16576012)(316002)(26005)(31696002)(6666004)(66476007)(66946007)(2906002)(86362001)(31686004)(8676002)(8936002)(83380400001)(478600001)(66556008)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L255ZnJzUnMyaHhvcVRuK2V6dWszQWVlcWpaNjhCN09YSmpGUTJmZ0Y0WEI3?=
 =?utf-8?B?VjV2TW9rQ0ZaaG1CcmN3ay9MRG03MllTZjdobUVzWVl0a2RjVUp6TkZIdllN?=
 =?utf-8?B?OVZEWDJaQTlJU2NLZEtUMnFKMHN2c21DS3NKNkVqVS94WHl3UHNSNWV0ZnU4?=
 =?utf-8?B?MVhuWDNQVWt2cUNUTnR5MFpheUR5bGlQN09BMXRuV3hiU2JWeE9iMWdRaFRz?=
 =?utf-8?B?N1ZOYkVtNFoyU1lhbjI5T3RhNW9kdlBpNUpRREYvWGZSbk1CTFdnNi81VzI2?=
 =?utf-8?B?WklGUzFyRWpnVlNMaUtnRmtpQUk3L2pocXByMk16WnlYSnAyUkMxWENEcDJi?=
 =?utf-8?B?SnV0WVFFRGg2a2RwQ3FzeWlQdi9aL2lXS01KZHhPNFBzZ2Y0eFFqMVR1OE9r?=
 =?utf-8?B?U1IyVkJ3WWpxQUMwdmZ1VUE3KzdBcXJodDExMG9mQ1FmQ0ZYeTJLS2lZa29B?=
 =?utf-8?B?cmNRNGpIVlBHMVFVK1hCWS9wQzFNTDVJUStTU3N6T0pvZXY3TEtIakxJM2lQ?=
 =?utf-8?B?QjkzaVU0SHVSZWhhZlB2VXlHeHBPUURReXVpUHFmK2VSUUNoaWYzbVkyRnY3?=
 =?utf-8?B?QzFvanNEYklhOFFSdWpYVFVRZDE3SGNtbng3WVNrNG0xOTFEZ0xybUVZbGp6?=
 =?utf-8?B?WVF3V2FreUxsUFBPY0JpMDdDSTJiUGZDV1dnaFRWNkdhTENWcnpGZzhvQ0Vq?=
 =?utf-8?B?TzREU1puOGZ1elVDMDZvRjd2ZnZzRzNCbnV4N0hEaUozSEZQanpBdlRTYmlB?=
 =?utf-8?B?ejNrSG9NRHhlb1pOOTNZU3V3QWZOYm5BWXEreGZxdEdsUmZEMFFVSHMreUNy?=
 =?utf-8?B?TkFXQ2JjYWMxMnFaRmppaVlaVDhFRy80VlFINjgvaUJ1S0UyYk5Yd3M1ZUs2?=
 =?utf-8?B?MWVNTFRiWU93VW94c0t1TjlXSmlRQ3VxWlUvaVFMTGtOSG00NXQ0ejh0Sm1W?=
 =?utf-8?B?UFdnaHllS1BpZExZcG9PWE4wK2ROSlJndVltSEkzbkZzWnhKbWt4S2liVzFh?=
 =?utf-8?B?dU9hUGVHZnZRbm16LzM1T0wyNUlmdE9zWmlnaVo3VDJkZzZPN05OMHE4Yzlo?=
 =?utf-8?B?ZjZuemNlR0o2dHoweTRYdXRKQ2lCUWQxR3k1ZnBpM0g5NllKbjBLRklpZmRw?=
 =?utf-8?B?VkhzOGJvTExjNTNDU0tGckdyNzdPSm4rNVUyaTRtWjZuM2ZRTVRBbTVBZlMw?=
 =?utf-8?B?N0E0cnRqK1dRSXRYOFcxZHRYUUgxUGh0M01KNDRvY3R1eU9HQVVQZ0xoakIv?=
 =?utf-8?B?WVVnNzBtQ0VZbGdoaHpqaVJxcS83cFpXcWFCdGhEejJLSTdsL3BZcWFrQmFi?=
 =?utf-8?B?RWd1b1YwR2NUVkVQUnltYWI0WFFBT0dBSHEwWCtQUVdlWFo1UlNuUGdGTzI4?=
 =?utf-8?B?dUJ3MVN1TkJuRzlEOGR3NXNrZFpDU3psZlgyTzZVMzZUNGZpanZSODcxZy9Z?=
 =?utf-8?B?TGhkakhlYjZYZEE2b0RzaFQ3clB3ZE5qRlZIaXJSY1pHK0RPRGRaN2sxenpB?=
 =?utf-8?B?Wkt0YWhqMktFNDNZVStDUE9ubGNiZFBPYWtaL29weGRhTDQ3MUN5aUg2QWhi?=
 =?utf-8?B?Mmt5WFRRbE1sdC8rbFdYVDIvdyt0ZG5VREhad0F2NUs0dW9PM1BGUE1OeTJk?=
 =?utf-8?B?bzhaVnBrdlFNVGVQRmxFZ21KUDFuVWY3TXU0Wm1QZDhTNm1ETm1OZy8zTzhh?=
 =?utf-8?B?amRiM01sZ2ZyU3BtMGMzT2syd2hzdjF6VnNPQm9CMUFpL0UwRFNIYkpnVTF1?=
 =?utf-8?Q?Nou0yGQcK3nG9XtfZmuUllLZKKU4akWMCYecWy2?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58ce1cd9-4f4d-417f-37ca-08d91ee2f748
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 18:37:21.0802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0tBtqVA6eYdJt2leAjd2XSBc11D4RtvxXY9PawdNtJ2lqqA4plbyjGuLr1oeC0BxvOJwu1OQlFLd3m4mguiKaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2546
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> The comment in iscsi_eh_session_reset is wrong and we don't wait for the
> EH to complete before tearing down the conn. This has us get a ref to the
> conn when we are not holding the eh_mutex/frwd_lock so it does not get
> freed from under us.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 6ca3d35a3d11..b7445d9e99d6 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2492,7 +2492,6 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>  
>  	cls_session = starget_to_session(scsi_target(sc->device));
>  	session = cls_session->dd_data;
> -	conn = session->leadconn;
>  
>  	mutex_lock(&session->eh_mutex);
>  	spin_lock_bh(&session->frwd_lock);
> @@ -2507,13 +2506,14 @@ int iscsi_eh_session_reset(struct scsi_cmnd *sc)
>  		return FAILED;
>  	}
>  
> +	conn = session->leadconn;
> +	iscsi_get_conn(conn->cls_conn);
> +
>  	spin_unlock_bh(&session->frwd_lock);
>  	mutex_unlock(&session->eh_mutex);
> -	/*
> -	 * we drop the lock here but the leadconn cannot be destoyed while
> -	 * we are in the scsi eh
> -	 */
> +
>  	iscsi_conn_failure(conn, ISCSI_ERR_SCSI_EH_SESSION_RST);
> +	iscsi_put_conn(conn->cls_conn);
>  
>  	ISCSI_DBG_EH(session, "wait for relogin\n");
>  	wait_event_interruptible(conn->ehwait,
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

