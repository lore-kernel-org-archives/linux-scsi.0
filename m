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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19A6C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 01:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3EB2613B4
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 01:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhEFBc7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 21:32:59 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:50281 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhEFBc6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 21:32:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1620264720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iPz61N420qBKucczNvZ2Yq2JHhZnUaeoyJ8fXDWO27s=;
        b=WptPXUT6xEVPfn98++x5odniOf+N6bH8KMqadmxdCWBWnJrPLGN94WlxFL8QBY3ooo9RPN
        rW9FVZsDsp3lQOFbDU0p+KeX4IQgA3fhxHY1c/xUTij9YuPaXmv7bJaFhHKVDrWU+stFVU
        SiF4K/6MdnUiOLyjsqGWpIBMQVY7/vE=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2052.outbound.protection.outlook.com [104.47.9.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-22-9DOhTQYfO7qp_oACydwpsA-1; Thu, 06 May 2021 03:30:05 +0200
X-MC-Unique: 9DOhTQYfO7qp_oACydwpsA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UhwLG9PIZJOGOs785qJ/v/lpj1nrW9HsSev5uW6ECc39r5zBCocZ6emzZPwax2AqS/yBKEuY6cwa4P2DtyE0wJVdZbAys5CFdpwn1nhmcaAQPDYumKZ79AiO5cfSSPjcsTr0lISdaLaCZ2ccm4xvtmO3axM0nHPLp9iUT7YQ/lBMzGdcpi4jT0BEjZzUo0YSjKzXH1DdsST6ZK5LALmf+pbGfI7NAL/Z1J1tVs037vDXwbNZbuxBlA1WYG78SKy1P5Ve8RQrtfooUt/SoQViJ8ScUbqVQSTBySFbsw4cjD0rwd4M8VTU4LsB1Bwxy3GE0EI6C6wNC0iDiDUVIlogQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iPz61N420qBKucczNvZ2Yq2JHhZnUaeoyJ8fXDWO27s=;
 b=ib0LB3ZnjfNeOE9XcY+ajDKmM0JMnMkaz0k/T8mVnOsx239HhP1CjqeEPm2s09Ulp3XLWifBHJcSKECbICv4nfbwSi7UDq786mLqPZrk0VbYgGKcZBRhYSZ1e0A6+SItSgVcnhEdCkY92O3ZcsKMBsbJl866J/70OigIEzTyhlumL55MOTEXkLvE+Jc5ML4CHCUZhQqAltrdR7hNmu8uZA82Y9VObTuYT2iCcMmgy/NTS6U3R2iAROt1o1JuJlZHxl6NXSiVMzwPAYu22dsov4cm3LThKE202/jyTyMdRu/rJdSEQcOlkPLgEwmEwEh8FYR7c10TDrx9bbcjtvqBww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB8279.eurprd04.prod.outlook.com (2603:10a6:20b:3f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20; Thu, 6 May
 2021 01:30:03 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.038; Thu, 6 May 2021
 01:30:03 +0000
Subject: Re: [PATCH v3 6/6] scsi: iscsi_tcp: start socket shutdown during conn
 stop
To:     Mike Christie <michael.christie@oracle.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-7-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <4a85af97-881e-f293-e0cc-9733c73f934d@suse.com>
Date:   Wed, 5 May 2021 18:29:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
In-Reply-To: <20210424221755.124438-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR1PR01CA0031.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::44) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR1PR01CA0031.eurprd01.prod.exchangelabs.com (2603:10a6:102::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 6 May 2021 01:30:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41652e18-3e5a-430c-97d8-08d9102e78d8
X-MS-TrafficTypeDiagnostic: AS8PR04MB8279:
X-Microsoft-Antispam-PRVS: <AS8PR04MB8279DB2DAB0EF3D8C225A250DA589@AS8PR04MB8279.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:506;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Qd1TU/hOuF8AVS40iORerTOvwcXPdO3in7MPbwKRgCfiGTw0uNMX8eneOIWJyruUzK4Jp1O252+vJxYRNYwfgnSOjqhbPrDhz1mAZX/pJz0fmae7ftLECTf9caGtlKADlP86tTaxhnlvS9NzreFj2OOMInzjMNjJP5Tyb5TITuMDGJr8QVew6FSsn68wFndt1VoSgFMwuNhKhK/IEUtkTw3sPJ8yY5fixtfjltGlrKM10BpCOmntOkuDGK6hD9E2ezwja5FQQ67IasxEfFGgknUYxJNpCOAInFsrIExRMxt+5Ka3PgC0mXvWTwsEdAY1gNozWnMu4ISklzF19DQbUs78KNBC+rcchRC8RbfjDvHNaKUzaco1U0LJ+nVrbb2taF+MkFijxdYQqMN0zyENC4TYjvMcFrtSMRIZtFS6NCcm0vyMTYlaXZmQ+IBf5VeTONrlKS05//hc6NIY3B2Nln7Kyfe0GGRhR7o9JHb1SGKdzatO8nWBfOShksq4W5g3KLVMlYbnm/Knrgp+ErBhGki5Tv1c2g/TWsz3mYfuPw6pWnqQo+A6CLfhGosgV9EBfmZvies/f83xcgutfIVhOmrdYcmsbkbb7Nzj8zvxuDxCLFiKfNJAzeWYY/99vza4zbUXOjHR/7tWymBonNRCwISgYhFi74/d7Ht8pKbpdU/FCIt1tklXh4L3tcxVeZD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39850400004)(366004)(136003)(38100700002)(38350700002)(83380400001)(8936002)(31686004)(186003)(478600001)(16526019)(6486002)(4744005)(53546011)(8676002)(66946007)(2906002)(36756003)(52116002)(5660300002)(2616005)(66556008)(31696002)(316002)(6666004)(86362001)(16576012)(26005)(956004)(66476007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SVZhM2lTQ0daeEM3WWZuTFlBTTZFcFFFbzlwelJiK1RTWVBUVjBXWWprM2c4?=
 =?utf-8?B?c3U3TGlpdFNlSFVybzYyY1djOXNrNDM0ckJKN2h4QTVCWlkyMDQ5TVZReWc5?=
 =?utf-8?B?RVNCSG5Ma3h4S20yd1U3TGNGTWwzVUpCcFpDQkJ0Vnd3cjFPV09RdEtmVllo?=
 =?utf-8?B?SUFHbUQ1YWhENTNaZGRISk5ENi9OeWVlQWlkUmFxSTk2SXh3dFZDSE9IQTBt?=
 =?utf-8?B?VTlhVHdQVnZWZXB1ajdJZWRkLzJpYTQrYVQreHAzR0wyVWs4YmlOSFA1MUVN?=
 =?utf-8?B?Ykw2TGtFM090VVNLQnpaekdxc1d2c2Q5MEVpSnp3WlQwc244TmEvTDhpZkI5?=
 =?utf-8?B?ZjZNWnRDQ3dwdjlPeHR1OE5yZ2JhdktvU05xMW03MDNhWXFnajFlaEVTWFBr?=
 =?utf-8?B?R2pZZndjeW9SaXIybnpFS2dWK0Rtai9MdHpwMHk1VjBpKzI0QkxqVGJ5bWNv?=
 =?utf-8?B?d0M1aUdubHJhSTgyR2ZiTlZ0YkxNM1J1SzVRY3htWlY0S2xDSU16cCtTUitV?=
 =?utf-8?B?WkduRFZCblJndDRZOHA5WDZRRXlhV0hUUnNiSzkvNjFxaWhoQ2lVT1hNT1Nx?=
 =?utf-8?B?ZHFpQnMwZGxDZ2lDUUMrYU5zSE9XK3lUSEdsRXpJeDlROE9lQ0tXSWNuREVR?=
 =?utf-8?B?bGtraVhlenNCRWNRNkQzbkNlSmhaOWlQdGJWa2NiOUpvRThma1lHQWc5eDBQ?=
 =?utf-8?B?UUduTWkrUUQ2YXR2MHNqZzY2VXlQaG9lTWEvbmlXOFhmV1o0Sm1KNmV0V3cv?=
 =?utf-8?B?QzhxQ3l6L0ZoR3J0QTF2RThtbmVrSEtqa2VNSWhvbGJZS3dXK3F3TklsUWZB?=
 =?utf-8?B?eW5ma041emZyZStteDdqTE9PQXE3d0hNVHNjeHYramVsYi9sTW50UVY4ZmVa?=
 =?utf-8?B?ZnFmZzVWRWY1K0pNOWRKTTFEWkZnSUFVTXFXSE94bERpY0pPcUlNVEhRZ0c2?=
 =?utf-8?B?MXZrbDFJZDhPWS9oN3NHb3VFWTdRWXZuajRxQ0tNUlBHQm13Ym5SRFhXYit5?=
 =?utf-8?B?RWV1a29vODUwMUdoY3Z1d29kN1IzWWlOUXR6a1gzTWRDSU54djZWQ2xuaDYz?=
 =?utf-8?B?L0RhNXNpeVZXMUorV1FCU0hvUURNZ0VkcUJjRGxteTJVeEd5UWV6Y2ZCc09m?=
 =?utf-8?B?dTV4K2JiajdmTlI3bk1jSjM4WkpwcDBnbzRGSitTVU1YNXZ5K2RnREdsNktX?=
 =?utf-8?B?TkNvZzI0RTRhK3lHQlZlUVdKOHhZUDZzS1NTZ2VxelZlMmtSdlBLa0Jkcmhj?=
 =?utf-8?B?YlZNTkFaeVR0c2Jrd1czeE5OU3dVVTBFR1EyZ2pRSDdDNmxFcFluWUM3QmJK?=
 =?utf-8?B?Z3hVcjk4Z2JsNzJBdEJOaFo0N0xUMnZoUWZhQWhIdjdGWUJPWjVrMlFtS0VB?=
 =?utf-8?B?V0ZiQ3VWb1lYQUdYaHhrLzM3aXBZU3JnNk42WDF6Ym9sOFd0TTFCdE1DdkRa?=
 =?utf-8?B?YWVJNGcySldGMVNqQVZCbGs3WDhXM00zTEtlZVNEdVc1N3dCNHZNZUxyYTBp?=
 =?utf-8?B?TUtiQlFoSTFqOEl0UW9xdkQ1YlkwOVk3T0dPZGsvMXMvN2t3YXNxQ25KL1Z0?=
 =?utf-8?B?L0tsNDRSQ3Qxam44WkdwMXJpa3NwWVcxUlRWMnl5bGRiWUZ3c3hGWnBPMC9r?=
 =?utf-8?B?RlZJSTB3cWFlcVFRY1NCUmNwMldjNXNwYkF5TFUwRkJmUmNDcEJuakFaTERK?=
 =?utf-8?B?RjY0T2Rjd3hrc05lQ05lTkdxL0kvUzFtSncva3A2cjFjTXM5dUNrSU8wN2RF?=
 =?utf-8?Q?2ycYb/VBZ27Sqcu9LEtMj4x9LBZMaoLo18WyAEm?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41652e18-3e5a-430c-97d8-08d9102e78d8
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2021 01:30:03.3155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63eUn3rvOAlf/yXMgOfaqebwrUXeeQ/qzfGX8DIZXaDUV5TneCXxEns8yNuI9GytC16qGH4IV24O0sMi3Vwgcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8279
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:17 PM, Mike Christie wrote:
> Make sure the conn socket shutdown starts before we start the timer
> to fail commands to upper layers.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/iscsi_tcp.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 553e95ad6197..1bc37593c88f 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -600,6 +600,12 @@ static void iscsi_sw_tcp_release_conn(struct iscsi_conn *conn)
>  	if (!sock)
>  		return;
>  
> +	/*
> +	 * Make sure we start socket shutdown now in case userspace is up
> +	 * but delayed in releasing the socket.
> +	 */
> +	kernel_sock_shutdown(sock, SHUT_RDWR);
> +
>  	sock_hold(sock->sk);
>  	iscsi_sw_tcp_conn_restore_callbacks(conn);
>  	sock_put(sock->sk);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

