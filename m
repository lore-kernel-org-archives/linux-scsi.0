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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6ABC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 17:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA0F16120F
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 17:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236759AbhDQRWo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Apr 2021 13:22:44 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:56574 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236754AbhDQRWo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 17 Apr 2021 13:22:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618680136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlsZVvV3gXSMIi8Jdn2vzdhcOyA0IG4NbnWrk1Y6Go8=;
        b=mWdfQCUgOc42Scz313V49rLgCDNFXBDvT7ZV62gIhMpR0XSsTx1w4VGrChtT7pviusLLJi
        jRyyIJLRRbeaZ82q1aByLKxitAUhEwo/TJPA13D0mKz4gkUff6rdq3pskB2M3HsZ1FkQM/
        RNnR35eie/Pt2QpPwcJnzyv2v3cxCVU=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2057.outbound.protection.outlook.com [104.47.5.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-5lvF2A72PAGawkiSwckJVw-1; Sat, 17 Apr 2021 19:22:15 +0200
X-MC-Unique: 5lvF2A72PAGawkiSwckJVw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDAKAUhGhDqJonMhZXROlorw7MwVZgCjV1T/LufuPgYPLktOQcpOuI0MTpduAnYtuWHTgRgeSIfKbqrCMtVxP+YQQ1MIQxcMf1bOHlAYoaZoMFZCQ87ScSyLyVhKyVcyrwZSkIkI6JDDr9yFDZyn0493MW68upAwJOoKJqD/+hx+m/hkhBz+nVEjyv15zVHYI0kWpx035hJHaDKWjhi7DK8Rq2oHI1Z2sQ8UhS0+aORh+QE96zj1S1Vk1LHSgQfHIDMRkWF0xyWI06/N21nlYdooLwnTR1rCNh8z89S4o0G2pzkfEHZ3uSd5RUHC+CFAf0Jx8c53Zd8SyK9yToH9gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mlsZVvV3gXSMIi8Jdn2vzdhcOyA0IG4NbnWrk1Y6Go8=;
 b=gVFpWA9QIcmTB1WFW6BMzaMG5xghL8IRSyEGL0Bsr/UOICwTx/mRV37cYAQemyQbkr7NwVniODtLjdRwJwCe56DELePdq4AGXCBM4YPPfNy3xzdlsOyQ3S2tD7gn/nkYKKDm0LPppRVKc4DXPsqu7rrmqI1ALXFP95P8Zfm68fXk4+X4BuDOk9IH2Fz6JpkWK5eZXXwm44thia+OEjmR6/KDnEgJ+MUd6xQtYt05WQs50ovfEIlG1dPxAqOf6OFV3nr8J8YXM+zeIy43xMw+K1dxuYGRr8bdTwFcTjxYhAB+W5KKQ/8qlzV+rBf9OkEoFrZVkdWORmVstvYZSgc68g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (10.173.254.156) by
 AM6PR0402MB3704.eurprd04.prod.outlook.com (52.133.31.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.18; Sat, 17 Apr 2021 17:22:13 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Sat, 17 Apr 2021
 17:22:13 +0000
Subject: Re: [PATCH v3 02/17] scsi: iscsi: sync libiscsi and driver reset
 cleanup
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <8c917865-72f1-fbd6-5b0b-9cea4630e594@suse.com>
Date:   Sat, 17 Apr 2021 10:22:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <20210416020440.259271-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: PR0P264CA0284.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::32) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by PR0P264CA0284.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Sat, 17 Apr 2021 17:22:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9079360c-ba41-4f45-94a3-08d901c55766
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3704:
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3704636FC2BD08D3BB087560DA4B9@AM6PR0402MB3704.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FHIM/HFZke0Rz/7tOKHIDRPweoe59/jUS+Ef7lenW0lxnqIgaWzAeSSqC+QWUmVo9NVLiBk6bvDtUHQhF9Qe7y3whxsflu/5h8ZE8D1db3/Ch9xvDgMbEkeE+ovAJAjLg3sipWUoYunDu+RlYMJe3Kw8PHtv/QrqsfWdydIoxJBcrnO19GBo7iJ+7WA3LRGcNfdEG8kb0cvnJKTjmFu3WysNzJv0JA41jv6RmRxGay8W9wQ+GNqtjCFE1DUc5+yhpBhmewlFcw9ST790TPFKR9lS07l81qMsJNRfhljY31XseGDN9lXEPLgaI/BjpKHsLrxni9/rZE3rCWHbghql1xVjuzFJpdRoOCVgGYN/Opo+SQFS3v5eYn0/MrV+0qBN0g3lnME0rHzzgJvzMhmjUBgv65AT37ooVjnCaOxv1iMSTlZDXiPk/3B4+PVxlPl5bkxs+VjUx56EihfvrcNHA1GODtGDVYXxGNskaQPGI8xEOzQApWU72WOIGLlBfUQ1u1gcbTRWHPAnLzJlUXStdodFhqN4uWWO45ZdDPTHEnSyV+5Yc2uKWpuUtZ/i3j7OVuFxIkPXFjq+OCKlxjup4Hgn1yi7sCDABWaB1Tx+Dk6BlVn5TbgqwZqu5I/p5ByxHuOJrlAjs4QMcISJ0p0RlWhkfWJ40Sb/RLse3+76cALHYWTNYXo3uQwDjQtAbhFub8v+Je9M5EWU3hTENLfRvbBDEJrx7F+4ULgLgaVY/nM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(396003)(376002)(346002)(52116002)(5660300002)(478600001)(26005)(16526019)(6666004)(316002)(186003)(86362001)(2906002)(31696002)(956004)(16576012)(66476007)(6486002)(2616005)(36756003)(31686004)(8676002)(8936002)(66946007)(38100700002)(38350700002)(83380400001)(53546011)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NVJEMlRiRGt2eHd2OWh6aCtONVpkN3ZRdVUzYVFiNGh2VDF6cTRHZnVYYzlI?=
 =?utf-8?B?c3RXdUNteE8vZ1lZekp1RkxISjFnODBKNGplNlMwY3k1aWxaNGdGUEJUem1K?=
 =?utf-8?B?UnBUOHphOUdja3ZYdEU2Z3JuYjJnOFFKQzlCUGhSdlhJQmN5Nk9aWVZhL2pZ?=
 =?utf-8?B?cElod0o4RnMxeHNLTlNCc3JkYWFUNmdva1Q2dThXNlNqSlhLUkxvVlNMMGdJ?=
 =?utf-8?B?ZXpOdHlSWlpjVmphNWE2emg4Zy9aVFI3SjNBTlVwNnJRZ3ArYk5rYzN4QlJl?=
 =?utf-8?B?ZnpJWEhCVWw2ejArK1JTeHVUQWZpYmxldDRLbHRqRkxvaHJUU2syMkZPbFEz?=
 =?utf-8?B?VzhNWHM1T0pONGdoSkIrODFkWWpOY0d2ZXhwalNpUkkwemtXbDdobWRSWFly?=
 =?utf-8?B?d2lnY0pwOUpPOHhEWG9DNHRUYkxnTWRnUG8zQU1HbU1ORzRrTS9CR0NFQTln?=
 =?utf-8?B?aUlYa3g1Zm84UEptU3ZHVDhTWnBra3p4enJEMHAxblpuekw5bS9Hb2Zuc3Y3?=
 =?utf-8?B?dUxPc2kycjRTeXFhMVVRb2QwRUVHSUhqdGw4UTZzai9TZWZtVHdCaHNOMjVI?=
 =?utf-8?B?b292dHlpY2liZ2lNV3plS080NVY3T2cxanZ0L0c1OU82VGVzUXlrNEEvU3gv?=
 =?utf-8?B?MXgreWxzZHc0bmovdkwycmszVjU0b083RGRuck44UDI4bWoxbUcxT3ZWSXZS?=
 =?utf-8?B?Y0hJRXBvK1gxeXlaaDB5bmE4V1VFd0JLMGdmU0lvNldFK1dWSWNpRFVNQzFL?=
 =?utf-8?B?Mm9JeCttdTV0UjBtRS9pVlRUZm0xWkRYeWRscmRYTkFPNWlaY2ZSQWpaOVI4?=
 =?utf-8?B?czBkbWs1bnI2aWFKWkthOWxudFRCT1hTd0ptS2lEOHVNcXJaMXlRUG9nTkxG?=
 =?utf-8?B?c1NCUWlLM1pXdnFrZmdHMWd6TzFLa05TNGdrSk1mTmxZa2ZlNGdHaHJHVG1u?=
 =?utf-8?B?YTM5emdGWlR4MndrcnMyd3hDcVcwTWhFOStqUTVGV2JMdDFiQXoyWjBJWWt4?=
 =?utf-8?B?S3FLMzJmSmN0bVRUK0VneHpxSjB3ajJWMGtjTGVnZHZVRFZJNUF4MTR6aVhk?=
 =?utf-8?B?UW1KckRoSy9ON01ObUREdlJ6dmV5SjRReEtXT2ZuZldVREpQVFdhRzAyQktQ?=
 =?utf-8?B?OWZVZDJWb3pZQnYwSmVnc2duRGxwOUYrL2VhZ0xsZDFFL2p3ZUhmNDNkd1U1?=
 =?utf-8?B?Z0MrSmdxUFNGWENVeDhRYUR4bTJwSGkzK25mQ0MyUnNxNHB6UjFUNGFyZDU0?=
 =?utf-8?B?bDlpQSs4ZE1PRWpvTTNuSVZDVkxicFJsUDVadkYwcU9ob2xLQkUxNHZucnpp?=
 =?utf-8?B?VCswa2xiRXkvNzBLZDYzckRodC9DSFhRa1ROZjNsRHArTHdVWWtGMzJDY1B4?=
 =?utf-8?B?cG5YZXF0b2ordDQzVlpQQk1SbWlqM1Fad3lHaExlUTM0blZaY05PMGlwaDFQ?=
 =?utf-8?B?NENlbWo3NkwzNitTN0VISW5ZUm1NTURxbmpFb09xTGt4bFpOdWJxWnU1Sm51?=
 =?utf-8?B?YnA3Z1pZRFkzOHhVL2k0VE8rSnEwbnA4cVl1OS91SFhjM3JQUFJmc3BhZnh6?=
 =?utf-8?B?bG1ib1BHQUhGaHhSMlZtK2p0UGVIanBmTVJyQlVXbUgwd251TnVPUlJ3VEhL?=
 =?utf-8?B?QUlhNHBBd1BZVkRGQlVuRnE4RzlTdEJKaGNnN0RpSHgvREQvZ2tiZmF3eGNB?=
 =?utf-8?B?ZnNUSXZPWCtQQjk5N3NaVmtNbzlObWxzcS8rMis4NnhsRjJWRkVDSjZqbXN4?=
 =?utf-8?Q?uryvg07gJ42htkPUmxu14cI5ix0ve333MC7UtV/?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9079360c-ba41-4f45-94a3-08d901c55766
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2021 17:22:13.7250
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mP52Dqx2++1COiuo/g89qw+6VMLREAEorPOoFASftrNIaqS7bXLd8XKAPw3M0/RIcX/SHoAJK7srM35iTirSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3704
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/21 7:04 PM, Mike Christie wrote:
> If we are handling a sg io reset there is a small window where cmds can
> sneak into iscsi_queuecommand even though libiscsi has sent a TMF to the
> driver. This does seems to not be a problem for normal drivers because they
               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
"doesn't seem to be a problem"?

> know exactly what was sent to the FW. For libiscsi this is a problem
> because it knows what it has sent to the driver but not what the driver
> sent to the FW. When we go to cleanup the running tasks, libiscsi might
> cleanup the sneaky cmd but the driver/FQ may not have seen the sneaky cmd

FO?

> and it's left running in FW.
> 
> This has libiscsi just stop queueing cmds when it sends the TMF down to the
> driver. Both then know they see the same set of cmds.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 104 +++++++++++++++++++++++++++-------------
>  1 file changed, 72 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 4834219497ee..aa5ceaffc697 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1669,29 +1669,11 @@ enum {
>  	FAILURE_SESSION_NOT_READY,
>  };
>  
> -int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
> +static bool iscsi_eh_running(struct iscsi_conn *conn, struct scsi_cmnd *sc,
> +			     int *reason)
>  {
> -	struct iscsi_cls_session *cls_session;
> -	struct iscsi_host *ihost;
> -	int reason = 0;
> -	struct iscsi_session *session;
> -	struct iscsi_conn *conn;
> -	struct iscsi_task *task = NULL;
> -
> -	sc->result = 0;
> -	sc->SCp.ptr = NULL;
> -
> -	ihost = shost_priv(host);
> -
> -	cls_session = starget_to_session(scsi_target(sc->device));
> -	session = cls_session->dd_data;
> -	spin_lock_bh(&session->frwd_lock);
> -
> -	reason = iscsi_session_chkready(cls_session);
> -	if (reason) {
> -		sc->result = reason;
> -		goto fault;
> -	}
> +	struct iscsi_session *session = conn->session;
> +	struct iscsi_tm *tmf;
>  
>  	if (session->state != ISCSI_STATE_LOGGED_IN) {
>  		/*
> @@ -1707,31 +1689,92 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  			 * state is bad, allowing completion to happen
>  			 */
>  			if (unlikely(system_state != SYSTEM_RUNNING)) {
> -				reason = FAILURE_SESSION_FAILED;
> +				*reason = FAILURE_SESSION_FAILED;
>  				sc->result = DID_NO_CONNECT << 16;
>  				break;
>  			}
>  			fallthrough;
>  		case ISCSI_STATE_IN_RECOVERY:
> -			reason = FAILURE_SESSION_IN_RECOVERY;
> +			*reason = FAILURE_SESSION_IN_RECOVERY;
>  			sc->result = DID_IMM_RETRY << 16;
>  			break;
>  		case ISCSI_STATE_LOGGING_OUT:
> -			reason = FAILURE_SESSION_LOGGING_OUT;
> +			*reason = FAILURE_SESSION_LOGGING_OUT;
>  			sc->result = DID_IMM_RETRY << 16;
>  			break;
>  		case ISCSI_STATE_RECOVERY_FAILED:
> -			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
> +			*reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
>  			sc->result = DID_TRANSPORT_FAILFAST << 16;
>  			break;
>  		case ISCSI_STATE_TERMINATE:
> -			reason = FAILURE_SESSION_TERMINATE;
> +			*reason = FAILURE_SESSION_TERMINATE;
>  			sc->result = DID_NO_CONNECT << 16;
>  			break;
>  		default:
> -			reason = FAILURE_SESSION_FREED;
> +			*reason = FAILURE_SESSION_FREED;
>  			sc->result = DID_NO_CONNECT << 16;
>  		}
> +		goto eh_running;
> +	}
> +
> +	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> +		*reason = FAILURE_SESSION_IN_RECOVERY;
> +		sc->result = DID_REQUEUE << 16;
> +		goto eh_running;
> +	}
> +
> +	/*
> +	 * For sg resets make sure libiscsi, the drivers and their fw see the
> +	 * same cmds. Once we get a TMF that can affect multiple cmds stop
> +	 * queueing.
> +	 */
> +	if (conn->tmf_state != TMF_INITIAL) {
> +		tmf = &conn->tmhdr;
> +
> +		switch (ISCSI_TM_FUNC_VALUE(tmf)) {
> +		case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
> +			if (sc->device->lun != scsilun_to_int(&tmf->lun))
> +				break;
> +
> +			ISCSI_DBG_EH(conn->session,
> +				     "Requeue cmd sent during LU RESET processing.\n");
> +			sc->result = DID_REQUEUE << 16;
> +			goto eh_running;
> +		case ISCSI_TM_FUNC_TARGET_WARM_RESET:
> +			ISCSI_DBG_EH(conn->session,
> +				     "Requeue cmd sent during TARGET RESET processing.\n");
> +			sc->result = DID_REQUEUE << 16;
> +			goto eh_running;
> +		}

Is it common to have no default case? I thought the compiler disliked
that. If the compiler and convention are fine with this, I'm fine with
it too.

> +	}
> +
> +	return false;
> +
> +eh_running:
> +	return true;
> +}
> +
> +int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
> +{
> +	struct iscsi_cls_session *cls_session;
> +	struct iscsi_host *ihost;
> +	int reason = 0;
> +	struct iscsi_session *session;
> +	struct iscsi_conn *conn;
> +	struct iscsi_task *task = NULL;
> +
> +	sc->result = 0;
> +	sc->SCp.ptr = NULL;
> +
> +	ihost = shost_priv(host);
> +
> +	cls_session = starget_to_session(scsi_target(sc->device));
> +	session = cls_session->dd_data;
> +	spin_lock_bh(&session->frwd_lock);
> +
> +	reason = iscsi_session_chkready(cls_session);
> +	if (reason) {
> +		sc->result = reason;
>  		goto fault;
>  	}
>  
> @@ -1742,11 +1785,8 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  		goto fault;
>  	}
>  
> -	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
> -		reason = FAILURE_SESSION_IN_RECOVERY;
> -		sc->result = DID_REQUEUE << 16;
> +	if (iscsi_eh_running(conn, sc, &reason))
>  		goto fault;
> -	}
>  
>  	if (iscsi_check_cmdsn_window_closed(conn)) {
>  		reason = FAILURE_WINDOW_CLOSED;
> 

