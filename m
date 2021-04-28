Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47734C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 19:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5F3860C3E
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 19:07:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240379AbhD1THu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 15:07:50 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:40798 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239829AbhD1THt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 15:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619636823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6tDZaV9YTPUjNvKG43o7FpdAiISBCoNL+ZD24S0gohU=;
        b=jaz1TneIeRq9q6KUsOwRuyJvsg1ykHr+i6UYyT3AUdB5EleDvX1HBiIT8aptMdLNOdjdi3
        San0e4tA4/EaL15fbv89B4+0IjH2DJxJmOg3Q8uAAQIUC6gbPej/ntYWtyAF3XoEZUUvdT
        dwhb34kfFw9TBfUoXzvKYlq22uyZwRc=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2050.outbound.protection.outlook.com [104.47.0.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-RmUlo1SaPC-2gJvaKVHF5Q-1; Wed, 28 Apr 2021 21:00:57 +0200
X-MC-Unique: RmUlo1SaPC-2gJvaKVHF5Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adWhxWhftfdyVcCNlD2X2mEyCRf9/zibTtikeZyi6N6ZTxOyC8k80IxGd2SqYCuyeW2Ki4025Wh+60+k3KBZirYwV9qDTU3fsXyjmhexbUEDCvwRwvNtV6y029a2nqEcbQUUulisiN+B2w5wuOXv1lxYr9AB24uQb4BlSatxEUBgZM0IbXi8evygAZMWkNdek3TffZV48DR33iw3YPD37iv5iEuhqlpbHPJ+cjjUsFhvf+69ZWaZrYX4DfkvZRvD1KdGILwel2IslvOtwbi89PaEfJn6T+sotadsowpk1sKxoARaiZpFV885aJ/UQgfDdaJlqfgIv8ivnFEIUk3I1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6tDZaV9YTPUjNvKG43o7FpdAiISBCoNL+ZD24S0gohU=;
 b=cLajjNBaav4Ds1bvrAARQdj5HT11jd7Fac3ZDnmMegDbDRLs59tWA49x/egx1tg3DDwXeGh0eg/qolwkOFM/Veiu6VASs43EN10UjjKVWDr2WUdaJwTDRIve8ngKq0dzlOpbaYHkKZTwxeR/Orq+1A6ftY6vTOBgoO2yKrX1TRHNFDQnPT7KuKoXaOoMUAV8ArVYTDCLkFBdvAeXlZ8mGEQ5TowBAXTn1LwTnOMKESKgaGIhxhfQaNvcmnYcox/IDGeSUuQd1rj5UjhUOVf8lHQiXFrxZ2m3KJCnjRdCw5MVm6giwUjAUraBmbd/4C3TPsL51HiMzc+ocggF9vGrUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Wed, 28 Apr
 2021 19:00:55 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.038; Wed, 28 Apr 2021
 19:00:55 +0000
Subject: Re: [PATCH v3 1/6] scsi: iscsi: force immediate failure during
 shutdown
To:     Mike Christie <michael.christie@oracle.com>, khazhy@google.com,
        martin.petersen@oracle.com, rbharath@google.com,
        krisman@collabora.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424221755.124438-1-michael.christie@oracle.com>
 <20210424221755.124438-2-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <59a618d4-4e00-9ba6-e2d4-5ab2add3e8e0@suse.com>
Date:   Wed, 28 Apr 2021 12:00:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210424221755.124438-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR3P189CA0076.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::21) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR3P189CA0076.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:b4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 19:00:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d79ee0f-bbd7-45df-5212-08d90a77f2d2
X-MS-TrafficTypeDiagnostic: AM5PR04MB3089:
X-Microsoft-Antispam-PRVS: <AM5PR04MB30895B23ED2FB49361DF0CDCDA409@AM5PR04MB3089.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tBw6G5FktuftJDNmV5kq1IEdZAtITfv39GD8L/q/tqlWscfUdIDpqUCOmf12KZbqcsEIC/MoBYcM5KkRgBdztDqGWuwrY/nzQ4K+J/xNXeB3XbSkU5qX2ytjJlwWixnou3JfP4AlJkihCOdDGngng8rb2G9bLQyg3oT7X1kXnd4lWeCN91+TwHKBCr2sRsqQm20DO+CGqX6kfzht8u/gNF4bZdo3CjwpeusDBM0sXn3YivJzwU3Fk1KqCkZnoaBZZCZ+3zGnN3j8PMX0J/+staukTnq5Kgjtb5HMBBiwIPR9JSXlQAuUGTT6qREgTsWP6nvawXpE4QDVr11b22rq6Rl/dG/+BlJgu4K0H3ixfxSYCFD5I29xPGFAjp5tRGpq0ND01I+LgxeZGtLzjHt8hUp38cj9lbpAw5SMumjUSi6G/O559At120e0kLE0aPwGA8KKoJKWykubPEmFmVMhFFs40XIps/3ok3zat8Do7Z4I9F2NbBlH8EO5/iwhnLLX57qJsO24jiugtY2sfar6Uh+OlX0Rb/JUlzEQGYyj6Bs/VJ266GI6JR30IyakaOhOstlNV5sl8lhzPLDDhiZDiJ2WHX5XTjlxU0mTIBo02Xy/hFg7wrBdc8bxeL0clIGYhSKeUIqdgMV5M2hFkA9LcOHc7yhnzxpX+EM58H05yXWEhoUyXfYubqEu5WyBqTMxmeLjFAUrl5WO9ccOxMmkG1EzZ5GgbDvffD/Ei3r+A/w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39840400004)(376002)(366004)(136003)(6486002)(52116002)(5660300002)(86362001)(186003)(38350700002)(38100700002)(66946007)(66556008)(66476007)(31696002)(956004)(2616005)(316002)(478600001)(36756003)(16576012)(53546011)(8676002)(83380400001)(31686004)(8936002)(26005)(6666004)(2906002)(16526019)(14773001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UnIyaTdubWVQdngvTkgySWwydy9lNk55dUJXSlhmRGtDRklKSStVbHV2UHE1?=
 =?utf-8?B?UG83WHFGa1pVQk9lMnJlNnNaakl0U1lEOHphcWttakN6cDljWmxIZTBvaTd0?=
 =?utf-8?B?eVAzRDdlN0tIT3cwdkx3RnU0Zmh6eCtUNmNnSmZCRFYrblZyY2dLUlNRTzBY?=
 =?utf-8?B?ZUI5VHRNM2s5RVZXdnVGdW9uZVNDTGEvU3BCOE5VUzJaeVl3ejE4aWFXRU1M?=
 =?utf-8?B?MDBsUjJKckdyZjl2SWFsUmVpOUlRSVJ6b2Y4em0vTUhpNE15SmFmYTFpd1lL?=
 =?utf-8?B?WVlNWlJMdlB4U3ErY0ZzVkhMeDUrN29zWGNjdlJTaGYvL1ZrRGU5QWloN2tX?=
 =?utf-8?B?Z1I0Z2VScXFhYnRzbFgycXJ4dllEdFRBWFlPbXNNUmt3MWxVUnhlV0lvSE1W?=
 =?utf-8?B?bDU2djlOUFNRbjdRbEhWQmNqano2V1RuK0tLWVl1S3hiQkhObWJqLzJkeEFx?=
 =?utf-8?B?VXorb1J5ZElIZ3ZEREhBd1VUR2Yva3FYanpwdk1XMFdGcVNHQWUrOXU2ZmFJ?=
 =?utf-8?B?RGdFZXlBd2d0R0tIaWxZcW5aMWVGMGd0Tlp5MENoT3hveEFlakFZeVFidDNE?=
 =?utf-8?B?VGFFRlBpbUU1K0l2SUg1V1N5ZmZGTDZNczltYys4RmRqQVV4Rk1kMFBVWEpl?=
 =?utf-8?B?anM4QWk3ejY4QS9iVVdLazg3cUZ6b1JCcjl5Y0V1TStmcjNITkhGVkxPVWl1?=
 =?utf-8?B?TFUvTW9yMTdmYmpVa25oVTlFcmlSNDBnTXRYQmc5UExBWll0dFJLYnlqQ3NW?=
 =?utf-8?B?YjUrYjdENE5kL2RneGdpMDFUK0Y0RjIzR3JIYzMxK2s5ckRzVU41NElUSHBt?=
 =?utf-8?B?L3ZwY0wzbDVpQ2djQ3V6em41aHdtdTdScTJDKzVnYUVQQ1VDdUpjRVhZTVpr?=
 =?utf-8?B?VXp6d3pjM2QvaWVDSWs2TFc3MHF2NGN2a1lLNHhhY0RGeGlPbG0zdVFiVWtu?=
 =?utf-8?B?ZTlqem40U0t5RG1vdFZDeXhOTk02QlFXOHVoSkliWDR5VVFSOWU3empKTkpu?=
 =?utf-8?B?blRlS2pZREUrbENZMGhsb2tWM1U2NVRCbUI2UjZzQUlsZWRGZ0NDRDVNVFNo?=
 =?utf-8?B?TXIrV09HRDgyMUtDaG1qWDZZb0wvVVQ3MEMrNnFNSWpLOWZaK1ZxYWlUWjBq?=
 =?utf-8?B?a2QvZ3FEUGNqdEUvMVBsbGs4WWRtMW5nUDh5cHRDVTR5SXRjd2lUSmJ6TWx1?=
 =?utf-8?B?WUZXZFlrbCtMeW1kcHhPUSswOWp6Zzl3b2kxZmxiT2xaRFByc0ppQmtsU0F6?=
 =?utf-8?B?bGllV29CVE4yZnR4SlpCeVU5TFo0S1dINk9KaTZqNXNqUVVueHU2ODN5dU5p?=
 =?utf-8?B?UHl1N1RGb213bTVwODhreVZqM2MrOEhNeDJneE5SY1E5QW91L3BINEl6ZGdm?=
 =?utf-8?B?UDk1UEZmb2dJRFBnOE1tMDFSY2pwMXVUams3NFMrMXJHNkpTVkpOMjE0UEdz?=
 =?utf-8?B?OVFpL1ZXYlhiT3JSNDRMYTQveUFJOVJMOEJkbGV6RHkxR0UxMDRBUEtZZTUy?=
 =?utf-8?B?bUNOVDFZZFF1Rk1XRC9UOTZSMlY5RVJFdmlHUlAxVjdrN29kSzdWVXRtNVpO?=
 =?utf-8?B?OVdZMGNMSm5Da2RZcW04cE5kcEFXSVU0TmZET0ZsZ2xNL3BkMEhuL01taHVr?=
 =?utf-8?B?c1lsTDg2NEo4cHhtcllvNUh0ZGRPVmZxVzRob2pkQWhjeDFEdVllYzl3b2Zn?=
 =?utf-8?B?M01vTkNBVTJteHJKNGg0R0Z3a2RhZWxrcERqeERQeDdiRlkyNlBVaGpwU3Ry?=
 =?utf-8?Q?QC5egY+bZJMlj6xRzE0F94mw3K1TObIOsvuk31c?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d79ee0f-bbd7-45df-5212-08d90a77f2d2
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 19:00:55.2314
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yCq85kAFKJIuhA++EJa8BkDdXLf7Dp4rfx9IECKbqToOXmlZ8B7cPx/qjxu5XTx24DtGeGo9zuHyED529CXwZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR04MB3089
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:17 PM, Mike Christie wrote:
> If the system is not up, we can just fail immediately since iscsid is not
> going to ever answer our netlink events. We are already setting the
> recovery_tmo to 0, but by passing stop_conn STOP_CONN_TERM we never will
> block the session and start the recovery timer, because for that flag
> userspace will do the unbind and destroy events which would remove the
> devices and wake up and kill the eh.
> 
> Since the conn is dead and the system is going dowm this just has us use
> STOP_CONN_RECOVER with recovery_tmo=0 so we fail immediately.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 82491343e94a..0cd9f2090993 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2513,11 +2513,11 @@ static void stop_conn_work_fn(struct work_struct *work)
>  		session = iscsi_session_lookup(sid);
>  		if (session) {
>  			if (system_state != SYSTEM_RUNNING) {
> +				/* Force recovery to fail immediately */
>  				session->recovery_tmo = 0;
> -				iscsi_if_stop_conn(conn, STOP_CONN_TERM);
> -			} else {
> -				iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
>  			}
> +
> +			iscsi_if_stop_conn(conn, STOP_CONN_RECOVER);
>  		}
>  
>  		list_del_init(&conn->conn_list_err);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

