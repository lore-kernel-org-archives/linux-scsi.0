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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D697C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 16:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 450E56109F
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 16:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhEXQDS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 12:03:18 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:39323 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235636AbhEXQC1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 12:02:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1621872057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fde/nTpGKQ0Vbtv6hoZIXes1qJtOwLDgq/8mHOBc2T0=;
        b=lcfHCPTYZQMmnz8WJtqMU7RV5LwlrznMgj5Pg/dcJacYMVhSXC11GgX9w6JzcfD7swR39r
        udAPL2E6bNbSnX2Iu+rbx/rLqm9vobTi0u2juOTqr1a1kewidR0MGysDou6TMT05wpAF9W
        NW0b5KZIFLaEwfwsN27UJVJPeaFp0Xw=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-OIP7zLHwNB2VEO_Hp5hdEw-1; Mon, 24 May 2021 18:00:55 +0200
X-MC-Unique: OIP7zLHwNB2VEO_Hp5hdEw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4QRQxOvro2ItaHLxuc1U8MdOWIvQCLoBZwp/u4Va1s58drXuZN8Ek0CNTrdSAOaDvn/5hT9vmtqNpeD7nX4W7mw0erTJjxJBpj1ohdfCqYrX0g8M8M6evzYTshOnzF8j0klc37kcrhBdo7VtwrQwmU+Uj4Nrs5iQ+r+Zi4VdMaU7GEitV1OhT2o2siX6DkOZ5/cP6T19uNnYqOcQtxqf+w0eDdcmbZBFpnaNtfTFyZrrLkkix9J8DPZ7B+zOWfX7DJSGurLHsl+XM53MoDOHDyqDqfv8O/2/APkvIAO7929kUBzGalakrTOwQaqBbbWMppzEETzTVqlwOriLVbWAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fde/nTpGKQ0Vbtv6hoZIXes1qJtOwLDgq/8mHOBc2T0=;
 b=g5YSnpacvhrqVzK5TYXut8teaGVE227TrQXCGe5E1MfXfqTQLYnj16tX2CIoxd2vyPhoeslZ6O62EUpauk7QRbu1OKbVd+Z16L6H1cG+/Z1NZDZ7j7Qz2AGk7oaudfZMxhh/u44B7ySxXh6vE4wbGIeI8znSBivcMK+RJbRvJD+a/du6eRZWnvBNRQHrbQYu+F5PqraRqjJoPB4BMKPtEjy7+cL3hHn/BkS1P7JxCk3LwrLjeirUQNvCcP4sNNqJo5Pod7Vwg75tmp7Fd8yqfiht17l78MePMPTGmdwas9Nq2ICnLzgS3PgBu5t1nRlpGB6+P2FmkLTEpXimNlvPgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM7PR04MB7189.eurprd04.prod.outlook.com (2603:10a6:20b:116::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Mon, 24 May
 2021 16:00:54 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d1a5:8072:c01f:3cf1%3]) with mapi id 15.20.4150.027; Mon, 24 May 2021
 16:00:54 +0000
Subject: Re: [PATCH 04/28] scsi: iscsi: Force immediate failure during
 shutdown
To:     Mike Christie <michael.christie@oracle.com>, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210523175739.360324-1-michael.christie@oracle.com>
 <20210523175739.360324-5-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <5587904a-2d5c-a9ad-bb0d-265cfee9a60f@suse.com>
Date:   Mon, 24 May 2021 09:00:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210523175739.360324-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: FR0P281CA0043.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::8) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by FR0P281CA0043.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:48::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Mon, 24 May 2021 16:00:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7246cfe-f36e-4db9-66ad-08d91ecd1c48
X-MS-TrafficTypeDiagnostic: AM7PR04MB7189:
X-Microsoft-Antispam-PRVS: <AM7PR04MB7189F01A577C2723205CEBEADA269@AM7PR04MB7189.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DmNKS9vkNOlwtA93040okdKYRA5nrK1RZMeG+zj1NxvasMcq+F3uKn89BMlCzFIeLphk+izxZCl4OjoOXghVFxb364gjbXf2zAuKXNeahLSaW7YN5/U/1QrYgXzoTOGQPAsgHKVJChy83Mqjqo787vzcz5OiOXC8AvDGA74OhlTpqHl/ivF31d6fsL8G+W7JEqT1lftkli7kFqGIG5MnSJ0FPTryWv+EOgHYErj5Fma/vmUsPGxrNcWskzUvy/7jXI801Xd3QMLuUKMQc2/8oIrf2Hoc3FpOhF57QfrfrGMxNbmO3yLXok3AguJhcnFjtwdI0GkG39bTgs5HxWurVc34lFWtaEfPRI/BUDile5l0RzrMEd1RLhYcY7pb40mj2N9AmRfG027V94Y3VdYAlH7FeJyc1KyU4Lilq7HvuxxbvBJSFLXIItWAR2D3mO2b8DInmVvTMwmXDRlDLeIUPCGXaUGLg92Jx/7ERaAsoPvfCF69A/z/ffXwTraTSs3J9bHiufm6GE/ejqi20YdS6Da+BYOblmEKWXRAzfOjlp6aLY6FtHxfNXzWOrrByizpQfQbSZNIWegskGV38hXm3A3MghqhooiYvxmBWvnoGlzrw6un9sDSbjF0U2A8R2zCAZZa+oMcdiMJlNuPHaOlqosEFyRBzxUSSKp1ygxGELqcbs6qsAXyA0e2J0NFp0f/rgr+6k9ZYRuulmKPVNfmhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39850400004)(346002)(376002)(396003)(5660300002)(2616005)(956004)(2906002)(186003)(36756003)(83380400001)(6486002)(66476007)(16526019)(16576012)(31686004)(86362001)(66946007)(66556008)(26005)(478600001)(38100700002)(31696002)(6666004)(8676002)(8936002)(53546011)(316002)(14773001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RGtlUzN3dXI5SDRkaVcvMzRHZEpQNkR4ejcxR3cxcmE5TWpoYkExd0QrOEpw?=
 =?utf-8?B?U1lTSGpsRUFxWk9YUWQwSDN2MGhnUDdwREtsbENZVWd0c0FKYlY4UUtkck44?=
 =?utf-8?B?SjliN0VGdFNsS0JFUHdrWjJ4NlVScFlHWWZJMDduejJ1dW92RDhCcGF0SG1n?=
 =?utf-8?B?VHpxNzcyZTJ2akp3eExOZEkxOGpOV3J4ZFJtWE5Va3ZsQ0pHVnJnVGZYbnRX?=
 =?utf-8?B?aTVOcm1uRWNpUnBOYndjckVCR3R6ME5INmUzRDdCc2N6Z0ZCdnRUT05YS08z?=
 =?utf-8?B?aUVPaEtzQThVY1g2TmUyR3FRL1JpWVVlMzFxUnRYdFZ5OC8wK20yejV3ZDhs?=
 =?utf-8?B?NnNEZ3daSmJyb3FNKy8wTGYvbys1UnVGczdmRVB6aFRLOGtIT2NBU0VRM1dK?=
 =?utf-8?B?Q3A5bGtoQ0VRdFlIOStIQ3VxMUdrZjVNY3NydVZPMkp5M3RYTEtyV2xJWkJk?=
 =?utf-8?B?ZU9kbU9tZnpYWFd1MmttT3NFdlRlUFFlczMrRWxsVHc2UWxnTHlqNVg4Vnpa?=
 =?utf-8?B?TFpwMVBmZmtXaUZscHRMWGM1bVNBS2FJR0JSZjlEN3VSSDRncXZDQ0tQbDlO?=
 =?utf-8?B?TE5IeGErbnJPUXQwNGp0UFJKOTFXdlhUa2VaSGZMS2xXQThlaUtBb3U5ZmEv?=
 =?utf-8?B?NDNzT1hRbFNPM2hUUnpvcWlxNW5RWWJFVGw5RVh4K0U3NHJEYjBNL0dUQklV?=
 =?utf-8?B?STNGYU40aC95L1lFS2tTN0xFQnExZWZMUEZQQTllWmNzS3ZlQXRYam9mZFdk?=
 =?utf-8?B?YjNrTlhLNXJDejUxb0RyNFFsaW9NZHBobm9NanF0ZVRFMFdNYk44OHFkYm50?=
 =?utf-8?B?Y2c1N01Tb0dIUzN6Q2pHZzdMWXBTTG5HUXVCL3A0a0YrZlU4MzdDTjhpWk9U?=
 =?utf-8?B?dHlnTTg0YlU2ZkdmbWNTWjc3SC93WjBRbExicllXanNuVllqaU1lUDhodjRS?=
 =?utf-8?B?N2JLRlpjSnJUb1FTbWpsUkU5V1Nsc2x3bkFaRzhBSjZBekpaUW5Ybm9qT28z?=
 =?utf-8?B?SWlDZXZsTjdQcEpadWtTd3c3Ynl5RjF4RklzeHplcllWQ3I0N2F5UHYvZFBz?=
 =?utf-8?B?NFlnemZGMTV6L1VGNmNSWUhaa0IrcEdyY0lYU3Q2WExialh6Z1VPZmdKY1li?=
 =?utf-8?B?WlkyVjFYeXRHSlA4MDdoNG1rK2tvby9Cb2RwR2dBL0pDZkZkUVFwb2J1R29D?=
 =?utf-8?B?ZC83Q0c2QndjUlIvd3ZmR3lwTEl4aWFnZzBRQmJ3K1UzY0Z1bGJseWZFdlEr?=
 =?utf-8?B?ZkljTk40Q0ZQUjZHc2tGZ1BKYklURUs5R016QVVMWEMyRHhpWktVYmg1bThr?=
 =?utf-8?B?eUNHQkZIRjRqVGdSaUNKNVJyRTVjWDQzZ2F5OVd4VmxTcm1xY2dVRDdZY2xJ?=
 =?utf-8?B?N2FrckVqUmFHK2VaNnF2cUtBWDdXYjdLM2JnV3V0bDllSjFnOVdrTGtLZXFw?=
 =?utf-8?B?akVlR0lZVS8yVGl5djZ4RnVzdG5tMzhqQnFNeE15a2tUM2NSdmpsUHJ5dWNT?=
 =?utf-8?B?clk0SW9vU1c4NkxIQ0FsS2ZUUTJwSmZLZjgrckl4aDZyRWs0OVlrdlRlZVlS?=
 =?utf-8?B?WWxPQ0FOME44NnVCeVN5MVM2VVgrM3YvWFZmdmNnZTk0TTNhMXd2UTdDTVFZ?=
 =?utf-8?B?U01HWFVlYVJhTlU4SThXYXYrSFo4UXNVcHhKVWVmYnlRbDVvN1hyeVRyMWpH?=
 =?utf-8?B?ejBuT2p3TEM3RGpnMS9oZnBjUTBUaXFWODhoZEtPUlJ0WVNoay8rM09nb0d2?=
 =?utf-8?Q?/R9Qwnm5ksmMUNqRg37O2R34EJqqjUZLqOX7RLR?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7246cfe-f36e-4db9-66ad-08d91ecd1c48
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 16:00:54.3300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8pEG/SZM1NP795OkCFXF/vqmfsB24aKV4535cg2KxrAyEb6bqr04uutuU2LH31j3sARQOS2YixrL/LwPlWdEyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7189
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/23/21 10:57 AM, Mike Christie wrote:
> If the system is not up, we can just fail immediately since iscsid is not
> going to ever answer our netlink events. We are already setting the
> recovery_tmo to 0, but by passing stop_conn STOP_CONN_TERM we never will
> block the session and start the recovery timer, because for that flag
> userspace will do the unbind and destroy events which would remove the
> devices and wake up and kill the eh.
> 
> Since the conn is dead and the system is going dowm this just has us use
> STOP_CONN_RECOVER with recovery_tmo=0 so we fail immediately. However, if
> the user has set the recovery_tmo=-1 we let the system hang like they
> requested since they might have used that setting for specific reasons
> (one known is reason is for buggy cluster software).

Typo: extra "is" in the above sentence. Not a big deal. :)

> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 82491343e94a..d134156d67f0 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2513,11 +2513,17 @@ static void stop_conn_work_fn(struct work_struct *work)
>  		session = iscsi_session_lookup(sid);
>  		if (session) {
>  			if (system_state != SYSTEM_RUNNING) {
> -				session->recovery_tmo = 0;
> -				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
> -			} else {
> -				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
> +				/*
> +				 * If the user has set up for the session to
> +				 * never timeout then hang like they wanted.
> +				 * For all other cases fail right away since
> +				 * userspace is not going to relogin.
> +				 */
> +				if (session->recovery_tmo > 0)
> +					session->recovery_tmo = 0;
>  			}
> +
> +			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
>  		}
>  
>  		list_del_init(&conn->conn_list_err);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

