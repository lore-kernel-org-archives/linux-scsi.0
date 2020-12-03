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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D8BC4361A
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 21:09:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 561EB207B0
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 21:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgLCVJK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:09:10 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:55436 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLCVJJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 16:09:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607029680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tS5vUj7dqe3KDPpcMDay2i9IQUirJnVpzCxy9mvO2Vs=;
        b=D8H4qUOuGBMrt3mc10KRHzJVBf78HsbpCvnn27rR9gjPPz3OoxCbos7CX/CSU0ToP481XX
        X6NBh0pyMomJxYMXNhZad0SnFNbreRuVaYZh0SIwxEfbbyECB9r3V7IBTVy/k607cDn6jn
        yGZIoZfX+t/Qr5wQsS/q9Hlpd+vbtdM=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-23-OTLdMj3FPB-ucV1VeRP4fQ-1; Thu, 03 Dec 2020 22:07:58 +0100
X-MC-Unique: OTLdMj3FPB-ucV1VeRP4fQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTurlog/0TxD5omepi09wUhVVNfCsJmo/KRl3dUhRgNWCs8jkSZHqp1aKYUVBtJ1joD2D7K/2aAVreawYo3S9d92cuYxeyrLJcKHUVQ6dnIuPvIamV6tk/D9Z7vi7Tq9rXPJ5gcBO91AX9U7UY92Rxd2sdYa4N3SDQ0tpelCF1mzw1HmHHaUzPx2Zbc5GFjE3FKEqPK3Dh636UVoGS4iN1non4bKKdEY/c2DNyKykVk5PM3BIWmCpnulWvPmej4xVsVVkteVYCN3S6Zg4DpK6x0J6xykPCNhLPdLPJyUDC5Hmpkj7wdch+V+qOXR15rLEdH3R2wnjDxh8ES6mM1VIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tS5vUj7dqe3KDPpcMDay2i9IQUirJnVpzCxy9mvO2Vs=;
 b=I2oCuqIVKUNyBgCHrvjxMvl2rb2+lJstqPX4usvgHUtz7qzksNeQ0+pioNBOI31TxV9Eo95VYIVrqqiILgffPeL4acXgw9a9gxmxHdSCXedbpfHKqqSdP7NDbfnh01X7RzeF6fqZT3Io0stCwUPJ6ema2sWlwhhzEo19T937e94hQFmxBrCgjCHpGT4v3+OUZfHiOAwjlX9Eatr4q6YWoEra9/baUHhhIRqqcoG/TwAZ+y+w2MU4ppOyjWK+0bigWpObEnTzn7VhUDX9AzAnwXkiNjn6J70Z+32WRRo6gUunfQakoaC0AKUxfXvwt99cPab5W8ZYN5hK8UcypVPrzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: hansenpartnership.com; dkim=none (message not signed)
 header.d=none;hansenpartnership.com; dmarc=none action=none
 header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB5016.eurprd04.prod.outlook.com (2603:10a6:20b:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Thu, 3 Dec
 2020 21:07:56 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3611.031; Thu, 3 Dec 2020
 21:07:56 +0000
Subject: Re: [PATCH 03/15] qla4xxx: use iscsi_is_session_online
To:     Mike Christie <michael.christie@oracle.com>,
        subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
 <1606858196-5421-4-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <6ad2dc00-5480-6a27-1381-45241b9ad78b@suse.com>
Date:   Thu, 3 Dec 2020 13:07:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <1606858196-5421-4-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR0302CA0025.eurprd03.prod.outlook.com
 (2603:10a6:205:2::38) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR0302CA0025.eurprd03.prod.outlook.com (2603:10a6:205:2::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 21:07:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 80caafef-fdfe-425e-ecab-08d897cf81b3
X-MS-TrafficTypeDiagnostic: AM6PR04MB5016:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5016045FC498E881D97A8A56DAF20@AM6PR04MB5016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +EAZB7Tx4GiNbvfbpsbRxiSzz6ox0McJvKNApqLXzd2bgehMxT5i6qn/b022MaXqYMgrLPim+7h+rwLAwIRClypRdW59qYj3xQiF8q8TPbLS2o462m7NeRLdVvwd+ln2i9ZTnTJeXSCGDbWBMPk3MuMtJaGImHn8uJ7wNDJ2ayRWLd1hrzZC0yuQxeepJ+Biv38Bk2WE+opf9Rr09jZ+OlaPXhJfZbrMSEm0eXgtRt5KOyXolW3sjij0lhEwyR0gIlmvNhryLNN5QkxZXyxIK97jMxFxNlSa18E5c9hWQ0SuskLBb7FjcS1G/QnveGEu0nxJ8XCwLWQeAATThzd4ZkvGxF7h0J1GflyMXGw8UELtZMayqTrcnRztOt2NpUoIV+WCtQBVXj/1ABbYBFf3RC8BlcAOYjocrg99wesfz2qfa/IBAWAp+5NQ2YhLD5RwJfX27eqVDpEllqPVkx77ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(396003)(39850400004)(7416002)(36756003)(478600001)(31696002)(6486002)(52116002)(16576012)(316002)(26005)(8676002)(8936002)(2906002)(16526019)(53546011)(31686004)(2616005)(186003)(83380400001)(66476007)(5660300002)(921005)(86362001)(956004)(66946007)(66556008)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SXJMbFJCZUswZWZTMVhDdGMzUXorZHg4cWJnRlFyWkw4U0hFbDd2QWpRRm1i?=
 =?utf-8?B?ZTR3aVlERExNbXFCVzZ2M2IwQTJiN25TRGhUVUhnMVBvWkhPNElnNEpzQUh0?=
 =?utf-8?B?bjdxZnZBbjFHUTFha3lubTV1Tmhkblh6c1dWWWVsWVdFcytYaFl3dzQwYmkw?=
 =?utf-8?B?YjZWNy9iakxpZmJsb3ZPWmVPdlVtRVUrUkJjQzBONkE5WDloN1A5R2p6dnpN?=
 =?utf-8?B?WEJXblhwUmN3SFhxdnJUYjBkaWk4QjJYV0xCbDlUSFpHdlBaRnRrbW00ZTU0?=
 =?utf-8?B?VndwOW5MeVlPbXFnRnAzRmdQcGhvYmY4VTNmK3BETHhjTXc4Qm96K2hqQ3BT?=
 =?utf-8?B?bFIzaHpkNU1JRDBnbjJnTWZoV3pxZkl4TTRQVVVJRldKcmhlYmtqb1RaVzBG?=
 =?utf-8?B?SElMSTI5SlVnUFVhemZ4YW9wVmJ3ZHZTU0d1M0h4WWJvblpZdk9zYlJJUXYv?=
 =?utf-8?B?cytKRGVUMHZyWVpSZ3FVTlhaNUhHeCtHd2EwalJnNVA2aUU5MFJrZmxYZDJu?=
 =?utf-8?B?WFo0VG9FT3d2YmhVejlSdXRWOTcxOG1sVSt1aWQvZlpIdWgvVi82V0Rvd0I5?=
 =?utf-8?B?akl4TEJFRDVQUmIxTnQwQnZMdnhPeGExWHZLaUxad2l3TXJMOHRLR3N2ckY5?=
 =?utf-8?B?Yk9ZQVdiTGdlandaSjdsQlNlTm0yTUhGMzVHZi85UVFJNWFUZzdwNFB6U2t0?=
 =?utf-8?B?ZWwvcEFlYi9ucitJQ3VtbjFVMlJrbU4yNXlpcUpiZVByNWxwdFg4c3QrSzBG?=
 =?utf-8?B?VVRydEg3ODRCaExNcFZVemVQb0VOYTlCMEZGbm4yTDFqZERVVldPRjJrZ2VM?=
 =?utf-8?B?VjNSNkZ5aEQvV1cwc2tWOEh0d1JhZzBOb3dEdDgrYzIreGtlaTlDdTBmOXFr?=
 =?utf-8?B?YXhyQU5qTy9qaXplWnEzZVNQSk9sZGQ2aWltOFpzQm1FSG9KZ2owSWpNc0JU?=
 =?utf-8?B?SHEyWTJjNFdBNlV3Z1VGWWtUSmVjVTRwcE5waUdERHlvTCtWdjk2OEFsTDRi?=
 =?utf-8?B?TnVNc1NDaHRPdTFpcTVpUWo2Yk9zS2FCQUZOUXppQU8rWk10NEkzY2tJUW5R?=
 =?utf-8?B?SmJNWHdid0grL3pVU3N3ZnVLM1NYYkk5U29TdndhdSt1SFpoUmNENkU4TVVx?=
 =?utf-8?B?OXRadWxYS05hTTg5VEh4Q3R3ZWlNNk5oZjNEZEMvRnY3QzRPYWNTOEZTZUlo?=
 =?utf-8?B?cmpCYXh3ZWlidm1pL09WWkxmbloxckJmSnJ1TnFsbit2UC8zVjNsY2xkZFR0?=
 =?utf-8?B?K1AxeDl2YXE4Y3g1YXh6VDhTSi9nWmFHMFQxWC9PdERoY2tCNS93a2RYcW9M?=
 =?utf-8?Q?Hhz9symMoC6Kg=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80caafef-fdfe-425e-ecab-08d897cf81b3
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 21:07:56.6679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pXSGbq2JUAhRoIdWGBGMSlfyt2qhL5L8VVTAG26uPNCODLZxgXjjG3jo9tBgUzefQHLnZqmEo1jQ735n0x3izg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/20 1:29 PM, Mike Christie wrote:
> __qla4xxx_is_chap_active just wants to know if a session is online and
> does not care about why it's not, so this has it use
> iscsi_is_session_online.
> 
> This is not a bug now, but the next patch changes the behavior of
> iscsi_session_chkready so this patch just prepares the driver for that
> change.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index 2c23b69..6996942 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -844,7 +844,7 @@ static int __qla4xxx_is_chap_active(struct device *dev, void *data)
>  	sess = cls_session->dd_data;
>  	ddb_entry = sess->dd_data;
>  
> -	if (iscsi_session_chkready(cls_session))
> +	if (iscsi_is_session_online(cls_session))
>  		goto exit_is_chap_active;
>  
>  	if (ddb_entry->chap_tbl_idx == *chap_tbl_idx)
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

