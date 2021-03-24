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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 138AEC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD80661A1E
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 18:16:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237203AbhCXSQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:16:08 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:34458 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237496AbhCXSPu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 14:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1616609749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AhSRkFxbN299KpNYV1BNjZhqUWK5Aq2xxDGkM8Usy4g=;
        b=eAXYTUp2rerJGka620eBoGpnlmYzRUEPUVjVubbpeF1ZjZrYN4nExth2ql16U6QpuDbKaG
        Qu2v0q6/rSajjytl2cNzDcz8/SmMkZ0Fy+pCuMOxRj5qsbsNbWNtrJpIeDJJTdykmrzJST
        7GLhmd+G+TV86RooP6r9C5LF/kB/Q7w=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2059.outbound.protection.outlook.com [104.47.14.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-19-W6Ssi-EbORmQwU5yCvvcKg-1; Wed, 24 Mar 2021 19:15:48 +0100
X-MC-Unique: W6Ssi-EbORmQwU5yCvvcKg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WzwcPT1Veb/hIEIA+ydjYW9pAPFUgx0BIfL0mCJ/p+zpXZh8P2FjMbgbv9UNAGE2fZrAwXOXsAsgr4/nbJnqggattmbMMGa8njS6lThBUB2CbX5nJ7gUztHFP5NYQypbbznnf78Rb33Fl1gjRGe8FuM39UglSs3cSfq5oD6Pla2zjkfTYMKJGTZ0Sq2f4gLvSltsQQgOpiAVuWfPaTeTPiScUNDzuaThIsvBseyMg8Y61F4BAg2IrpxfalBSJ4zK0GjpfMKcP26fC2ewXpbfaEfDN5p5YohWF/yJPhCDOQttwQjxzaUTRrgL8xWO2EzInxW/NOSxdVWCrjDe2rGkqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AhSRkFxbN299KpNYV1BNjZhqUWK5Aq2xxDGkM8Usy4g=;
 b=mSM/e2OPEUBQ8hO4+WUOnEmEg9JFCE9G9qfNrnQSojYO2NHwI9HrpgKU0OOliGlOfWJdQFPT/l2mRU72gjio6PisARR5KFboLzj2V5VDDyw7Yt+ed3mJkgCvWcewhvJFmRzXXluNQWH+Yt1qca9O3SVtp0Kl8g5WX8E3du1oj1LUUxdOA30R1bDs8yCIz8gNyBd9qfsZ3SFL5TnZ/P3gQUYNHbp2orW17j2CpL/3Yv8QAEm7FY1zVkML6+SE+8I6fIvOxjK3UtCvwpF6M5nR2I2+zsNfiTbcgHizA8omyn2kroX2V03J+X0XIcuyHVobxTS7KEMr7hJT4Mpn5Lo5Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM7PR04MB7192.eurprd04.prod.outlook.com (2603:10a6:20b:11e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 18:15:47 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%6]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 18:15:47 +0000
Subject: Re: [PATCH 1/1] scsi: target: fix htmldocs warning in
 target_submit_prep
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20210318225858.11863-1-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <72a0d81b-2765-47ec-e9b0-a7a7cd41ba78@suse.com>
Date:   Wed, 24 Mar 2021 11:15:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210318225858.11863-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR08CA0015.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::28) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR08CA0015.eurprd08.prod.outlook.com (2603:10a6:208:d2::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 18:15:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bec1bae7-ade0-49e2-d13d-08d8eef0d8ab
X-MS-TrafficTypeDiagnostic: AM7PR04MB7192:
X-Microsoft-Antispam-PRVS: <AM7PR04MB719251E8568E93CC3AA6C0C6DA639@AM7PR04MB7192.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iGsDKvyFgSq68GyZGjJ17iiRzY4QMwZaiatYU3hR97nJwTqxutQ6IysyKbyz5QVk0GZNJlQXlr9Y3Xry//NOLv3qkP1N0KIqC7fjTS6BDaEV8+x0DXLmVQd/Zc6b0JzrGxmkJ+wvnC19lBFsbdf4/CYByF0nAVg/3iEqpa1tRN2LebYHdy/nQFL6ZIxikbNmNd33PrHvJpZPNKpIWZEb9IapviMadtqbxOMh4BGRU54VhowvMxT7c8pEtn0xTVSrP1YJJ4XR980jDysMLuHLXQCQngnpZdN2ZWqMqQWh4lWvLGtq7N1FFIgwjCZMa/dSSYN7oqx/8ajg990qeeFt+fpGByz/b7vhrZpjLen3JVHRvn7R2r5+sKN4DMpD1kb8yy3CabK8a+I02Jy34EmTISyQrUnlOFRwGGxdmj15aQDTIVGf/nnFG5JGhhugH65UT2Cc10XNIDlR5bpVGuJOZOQWIMGVPs3hQiVQk8+hB2a7XZLh2dWzoc1JJdsNpZRx51sl2b9AuHKMUWRRGlOjI0o48+qk9F/8nJIliLvgBPghQg9nc8g2pB587SWgW65itKzJVoDZvqXoJB500NL9bv7Yhf8Y4gHQFDx5PljNaAnsum1MKCeUIjsqLxczJMU4LuiKN4WJ5TMNMtgtQDV2mcwmVqtOAwNkEkKbk9R7WZxnMIxO3yE8K0o4pjnPQWA1ii0xTtNWh/G825YC2JrgFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(39850400004)(376002)(396003)(366004)(66946007)(4744005)(8936002)(2616005)(53546011)(31696002)(52116002)(956004)(6486002)(66556008)(478600001)(66476007)(6666004)(31686004)(2906002)(5660300002)(83380400001)(38100700001)(186003)(8676002)(36756003)(16576012)(316002)(16526019)(86362001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WHNjYUluNnFqQ3lXWDQ0QTFuMzRhaEJ6RmFyWWswZThCUzJLOGJ6UkZvWmox?=
 =?utf-8?B?OENnbUQ5MHg3RXFCdmtWbUZqVWNyVXBnaHNHN3MrTkVyTnBIcEl0eHZ3QUtv?=
 =?utf-8?B?RUErVkdzRjJXNE1nU25RZjNFSlMzaEVMamdDSlAzd1UvTFRsbDNFT1pzL2ZU?=
 =?utf-8?B?K2tRS29qb2Y3Q2FJaTE3aHh5VFFYdlRBeldWMlp4bTZFOEYrcnJaTnNJTVR5?=
 =?utf-8?B?eFVZbUhxYk9IWGZKOXlSTXRIblJVL2Z1U0JXV216RWRONnlSY2V0enVEQVRm?=
 =?utf-8?B?eUpHVDdMalhsWmZlZ3NPL2xvSjNGcm4zWW5RNnNCTE9CQ1R5cFgzd2J2M1Zl?=
 =?utf-8?B?bW9iakkxZmdQZThUOWFPbzVEVWRSSGgzM3h2Q3F2bllheVBsRnJDelExMnlO?=
 =?utf-8?B?NEw2NjJhajV1dWdmQ2RBRFNMNmZpekFLWVY2KzErS2s3eEE1dzN0aURKV0JZ?=
 =?utf-8?B?U3Y0Y2MzQy9MV1FXOGlBRkNKbHZ0dEtmL0VPQll3OG11OER5NSt0eWU2QVRE?=
 =?utf-8?B?S3ZKb1oyZlFGb3V3Y3BSeVVobHdRWjdUNElqai9YR2JjZjcyREc3UFNXQ09Z?=
 =?utf-8?B?TndwdHhWZG9KdHZ1TG96K2E5SlRZelJIL1YxUTN6STg4L09EZ3JGUWFucnNw?=
 =?utf-8?B?TGFDN3ZFOUpGdGE0MWpoaHJvZlU0Y0w4aDUxbVNVQjE2Mkg2V2JBM3FZU0Nv?=
 =?utf-8?B?c3VhWDljUHkrVWlxcHV2SmcxbTdwb2tUUWR6MlNCS2xycmNCNFlNZ1FwWWht?=
 =?utf-8?B?cjl6STduL2hXbU9QblFFUUtJWXBtamtzM2dMNmNTTmo5cHlqTEhic2ZiWkZl?=
 =?utf-8?B?bGRlMXkxSlgwbGxRWVlZUExTVzNxSktvdzAwUmMyVk5JcEtEN2l6U2RkU1hR?=
 =?utf-8?B?Y0JSdkM0a0l6TnBYVzVJcVhvL3Fmci9wc0duSFpMYjhtUHBya0IwQjNjYTlt?=
 =?utf-8?B?QnRXUEQrMkZ0S1JlRUF6TUlYc2UvUERRUTNJUTlseFRtL1VVZlZjM3NyYy9j?=
 =?utf-8?B?OW9ZajBEcDBQelo4VlB4QVFGZ05xZndjMmlNWktsQXNERU51d1dtT3RMR2xH?=
 =?utf-8?B?K3k2cFlCOHpSNTJTMUlVWnp1WElFdXpqNkVMSTZGbTM3alI3dnZnZ2JOQzFF?=
 =?utf-8?B?NVV3RXNFc25LVGh4UEVWOGVaTTNFV2d5SXZ6MWZibWU4SkJJUTZ4SVNPOU53?=
 =?utf-8?B?NWNHS2ZXL0xlUUV5cnl5MnNYRHR2aFk4aVVJR0YxWXFVdzhHTEJtempxWlUw?=
 =?utf-8?B?QzhmUFRkVlovbkJWUnZVck5vL0hHY0duaGF3SjdBOTFXRVA2ODEvM1k0a1pk?=
 =?utf-8?B?bFZBYzFISWl0Ti9KMkxXUGFsK1RSdEVxMXF2QVlqZ0FzcHlFTU90RStoVFRs?=
 =?utf-8?B?S2FZSms4dzh1YzdnN0VKUG93MWdiaWxkc0NYeFNRTEgzdEVKR3I0bGs5aDNS?=
 =?utf-8?B?bEhUVHdheUtxd2VTSUZpdHZ6YWV4TmtQSlYvQWozTW50cy9VRFBwRUpPUzRJ?=
 =?utf-8?B?aXlETXhmQVd5OGxTcCtTMC8vZlpteStEQnlabmVoVmFRcFRBMDgrQzJ4K0Zv?=
 =?utf-8?B?cUJxY0xlVUVqN0o2Rk1WbEpJcVplK29aTGdrTjhxalJGK1BpSTJoRGRtQ2tD?=
 =?utf-8?B?aEdrNHdrWFMwdWlPOGE3bjgvaTNYNFhUR1FrcDhBMXdjdGJjeGRoVlVhOUJ5?=
 =?utf-8?B?MGlvNnRpMEdxd0JRUG9OWTliU1hRUzk5dGh1S3BOSGNCZEljRmJ4aXVOcUxh?=
 =?utf-8?Q?+VBVoTjeFj9VAArzB/5jzmVDk41VpbQemJI3lSA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bec1bae7-ade0-49e2-d13d-08d8eef0d8ab
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 18:15:47.2073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gh0pGTYgVEtPi+O9v7XFg+aCklSfyhPqDpzQdwxX8Q81jvq4nuXr2k/6n+CVGtcN0nSIG6kEWvbJXm6id6zs4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7192
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/18/21 3:58 PM, Mike Christie wrote:
> Fix warning:
> 
> drivers/target/target_core_transport.c:1661: WARNING: Block quote ends
> without a blank line; unexpected unindent.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_transport.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index a75591c929c0..8fbfe75c5744 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1659,6 +1659,7 @@ EXPORT_SYMBOL_GPL(target_init_cmd);
>   * Returns:
>   *	- less than zero to signal failure.
>   *	- zero on success.
> + *
>   * If failure is returned, lio will the callers queue_status to complete
>   * the cmd.
>   */
> 

Easiest review all year.

Reviewed-by: Lee Duncan <lduncan@suse.com>

