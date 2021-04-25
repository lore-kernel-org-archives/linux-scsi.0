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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A7AC43461
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 23:49:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 381266127C
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 23:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbhDYXtt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 19:49:49 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:23545 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231410AbhDYXtt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 25 Apr 2021 19:49:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619394547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tvvcfwY/JV1gsjq0LWwJvFJ6S/XVv0pcbsOCR4fazWo=;
        b=gl4niNfQ7JRKXcD5cKrAY6LSkdsyy/iNxpbgUGLBQLb+Hst4mWCGEtSXPtMLUvYQVUcKzV
        yk+/mm6QHrQjl4AWVRpTCrhPLX0Rx8s0+t40F6soKvbxOtPjbjYbw88AObJfDvPJNrd6MR
        MYR5hnnr9x4BiOiP+5b4u6ImqqOSwbU=
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2050.outbound.protection.outlook.com [104.47.8.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-iWjh5Sh5N9CRgYUuI6sSYw-1; Mon, 26 Apr 2021 01:49:05 +0200
X-MC-Unique: iWjh5Sh5N9CRgYUuI6sSYw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OuJWYG1EVasixd98X9aTBydsIceQrVN6R9UIptEfCPPYkMc2KPnxwsr50kV9pv95XMwRRssjGC5PE4ja4w/u3QZGR+L5NxLOSOwM/Tq7Asyn8KuKjKS96F2SLqWfNAg7yiSVBLIV0O6wA3mD1rD7CUjr55UaQO1ciYWbuYzfuFkMsWRhH4CVGDklsjBNU36xt35/Py9sh/1fMjrPmKWqS07GCfqBzdDpxrklnZrgHleoJYHKzeZdV9/f/nf3NWLf9o/KdpfTjI8Si94UODuOMXpPD7oW2M/Itj6gby8BmxHozXbj/GeYVxvK92zqlGwXYJEnpHokpzRjUHp+VXaJ6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvvcfwY/JV1gsjq0LWwJvFJ6S/XVv0pcbsOCR4fazWo=;
 b=EOn/oKnzP3y5hnhEzPfSBUC8IXFn7QqSrwRSX79yHpxjNU8kGjD3P0uzkFd9ESHzk9Gl4re6PIU5rwyBMBCwlvmh9pzanKxzvb23iPuFILSLE8klNnsSYDyqTf/p8NlTKKROla/myDaTzLLkaDCphY5eMyJRZTL7C31b+WoN1d9QmhL+k9I+nm0ejB4VVW0QTY1Yvf7taVEgbymAnE2K4oJU0PlWaaMaG49BPOm3lHpoSeJjNn/MYtFrpdvqWFCQftSTrT3H8F2bQ8SKeD4HLkYhI9IlYBuA0rqOywYssW38S951/ILTqbu6rWvUf3quqNDbDWzf52R64PS6Z13L/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AS8PR04MB7815.eurprd04.prod.outlook.com (2603:10a6:20b:28a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Sun, 25 Apr
 2021 23:49:04 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::4587:b624:eec3:6e72%7]) with mapi id 15.20.3999.036; Sun, 25 Apr 2021
 23:49:04 +0000
Subject: Re: [PATCH v4 02/17] scsi: iscsi: sync libiscsi and driver reset
 cleanup
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20210424220603.123703-1-michael.christie@oracle.com>
 <20210424220603.123703-3-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <5668b366-6dd7-2aaf-e000-bd3222963f23@suse.com>
Date:   Sun, 25 Apr 2021 16:48:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
In-Reply-To: <20210424220603.123703-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM0PR01CA0097.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::38) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM0PR01CA0097.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Sun, 25 Apr 2021 23:49:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9f3cbab3-d1ab-49f7-18e8-08d90844b448
X-MS-TrafficTypeDiagnostic: AS8PR04MB7815:
X-Microsoft-Antispam-PRVS: <AS8PR04MB781531CEF855F6D6A9C8C4BEDA439@AS8PR04MB7815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gfikFmwjwOPH04vLzuffeZ3d2upUACZ5Cwj0pk9nGL5xbPJWleFYuMsPOp0NQkGVWaJIP+gCCK0UNBTemmXtVhzWGX2T9bJZziupM0zUjshItH54hk+NwJBcs3uvDes5UodWmnzhR+1XEE254XXb1vIMdZi+BBNNBo+AcuvQbgGooy0C6uSrXr1C2LRApNejqhKdJNRvj37chWGrJ3DuAKMSwqV5BC4D2uzmpGjpO+kTrLbMskM2WroRwfO7JrtwzEMWQE+qiHNAinm4rF+QBIw2Xgyc24ZUYCOimhJ9o6RW50hx2gyID4P5WjinqBWkkOXojFw1gWNbnjImfELpaChch0zOk5HCaT8c8kgJYXuDu8kW4YcVKwQHzMlg3vBCF0jp4iVnR99K6XnAfAnhRWnHBGbJ5xTMLsiUTIy5xE4WToAfRXrRkZ2evD2TjbZYMSCGTtnZw8u+jQUywsZfbKj+elumZycFMBMcdZmC3ng9rZ8jUCnoTxSyvL5wm6QLfM1om8/0x3siOOuQFMwrEvJfHyxl/UAlg9tkxRJT7NaDjtHtEJVwghUMd164NJMQQ160Rn/tm9rmt/kIGwrsk685xXsE8/MZ6oZh8LhFb6V1bdc7+aKudWNWLs1/YoDwmOW6ZN73+8A3mTDFtNtb2eIrqDSBrAqGhsoTHuvW1KVBOSCG4CVuZDfozfX+4XkM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39850400004)(346002)(136003)(396003)(316002)(8936002)(16576012)(8676002)(86362001)(31696002)(83380400001)(478600001)(6486002)(6666004)(186003)(16526019)(26005)(53546011)(66946007)(38100700002)(38350700002)(66556008)(31686004)(36756003)(66476007)(2616005)(956004)(5660300002)(52116002)(2906002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFI3Q0lIQ014Vi9EN0luT0xOMHBUdGw2ekh0T0RFb3BVbG9VdnN3YStCcVha?=
 =?utf-8?B?YjBPUFhHbW1wV0pqVzRWNGdXYi8yc2ZyMEwvQ0FaWnF1aFUyaTUrOGVOd3R2?=
 =?utf-8?B?eEpmQjBWQzNjcU5ub0NaSm1ldEpvTzhVMXVoUUk3clNaWEM4NWQ2SVY3STY4?=
 =?utf-8?B?ZStITXZ2QzcvSEI4S2ZvMzdPR3hWZWxhYk04eHZFNHFuRWZISU1uYjR5MFND?=
 =?utf-8?B?Y3JVcSs1Vzc4UkI4WGlLU0RFZkwvWWdOcUdHK0JSbXRHai9lbzhvSjlXMXBL?=
 =?utf-8?B?YUdXYjh2RzIrTGQ2U2x3VVI1Y0FkUmE2YzhFMHczaEdGRTJLeCt0WUZrUUx3?=
 =?utf-8?B?YjdaNHRDOG4vdzhoK2tVQVFmZ3hsMzU3eVpLd0Fkd2I3dUhNWG9oVjlLNUNi?=
 =?utf-8?B?aHNjZjNnNWlNTEl3TDZUSVJkOVc3ZWtZUEpVRXA5NFlKMFNXMHRINVc0OEw1?=
 =?utf-8?B?bVdIbHBYL3B6NjlKRzM3bS9LMWtOK1MrTG9sZGZYb1J0bkR0OFNmYVc3dGta?=
 =?utf-8?B?cmV2SGVycExxZnMrRGxyZEx1U0p4VHZPWG13TmZsN3hCMEJOd01YV2VaOEw1?=
 =?utf-8?B?UWpkbHpUcFpMbUI4ZWFid3duampzMHZ6My9senBLOGV0MUFVUGwzSmdoeG50?=
 =?utf-8?B?U2xFMEUzZFplUURHc0R4Q1pkZEQ2dU9xblNDTDAwTHQ5SjBhajRmK1pCMytX?=
 =?utf-8?B?R3l6Y1pOWVM2N1UrVEFJWXpicU5Qc1MxVmhneU55OUdhTzh0bnRWc1NPWWtQ?=
 =?utf-8?B?SU91YjVOWndVVHd2VmFXNnM1UldBcjh2bjNEcjBVd0svOTdHeGpUaHJUeElD?=
 =?utf-8?B?U1I2bVJEVExidHA2TlhIcER6ekRFVU9odm1DZDY0ZFZ3Y2ZxdXVlYUY5Q25B?=
 =?utf-8?B?OFhIUWNuQ2h5MGhuaDA4R2ZzRHcxaVg5blVJeFluMDNrMW4wZ3ljYXora0J3?=
 =?utf-8?B?RG5iWFdJbHVSL3lOL1ozL3RxakJuMU5rM0lhRWwwVkduWHhSeVh5ZlRFU1R6?=
 =?utf-8?B?SUJMc29meE8rUEpHdTlSN1hDRitrazdSMlhheVRUWW1pUjh0TDNVSS9RNUJP?=
 =?utf-8?B?UzVndFQ5OU40YWxaWVR3V21TYVBDOVdNT1lxM1hOcGJLNExXQ3JDM1BoTjVi?=
 =?utf-8?B?Y0Z3alBMWDlNa1ZTM09DR1d6VTRYQzhCdWo4TWRGU2ZNTnZ3cWFHSGUxWjg2?=
 =?utf-8?B?NUo3VUl2NURweUhFcUw0eGR3cDh1cUF3dGF6Tld2c3FxL24vUjQyb3ZpRjVY?=
 =?utf-8?B?R09pOGxrc3ZJdHhXYURMbWh4dm5zWGNHZ09LTTVGaHVQR2VXMzRzYTRTa05I?=
 =?utf-8?B?L1hFVW84V0pyVHpOSmNGK1o2dk1NMG5OUmVmUDJhSWFYMGFGTkM4UDBJYXJx?=
 =?utf-8?B?bytlQzVPQmQzU0NVNWNzdUZ2WnpNZEZ4R01ZeFZMRXQ0aFB6VXl6aCtRcTNT?=
 =?utf-8?B?VTZnOGRMK2JRc1U0UUNOdnp6eGJJbk15SHYyZDUrdTZZRTFLY0RpRDIyWjdP?=
 =?utf-8?B?TUxHZUhBaUw3c1lGRDdOdm45U1pxelhBOW1BNjlFdSt1MFc3WHVYWXJnM1Vw?=
 =?utf-8?B?UTBMbmtNNnJaZGR5cnlJWmJKWFN4MTkwdGJvdVptYys1YkFxdmZjUExsOG9z?=
 =?utf-8?B?cWpvZXhSa21uZmxNTnZJakhZcTR5SUxYRU9XUFYyQ3ROTm53MUQ0NlZiVXN6?=
 =?utf-8?B?ZS83c3djak9ZaUladDZIYnBzYXNaNTMzUXdkczdmbkJDMVBXUzE1aW9BNmNz?=
 =?utf-8?Q?LR2PXIsmVUFhDpGyWzs+Q9/Xv7VI7I4UAb3LPkE?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f3cbab3-d1ab-49f7-18e8-08d90844b448
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2021 23:49:03.5711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QrAB0c1GkbaTXfrpU+9/EIMTeO+x/r/qcVo2YUM7o0VCIi3rkP0PixECdH+UEb3NnvdMJQU5lXgf4S73cKlYRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7815
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 3:05 PM, Mike Christie wrote:
> If we are handling a sg io reset there is a small window where cmds can
> sneak into iscsi_queuecommand even though libiscsi has sent a TMF to the
> driver. This doesn't seem to be a problem for normal drivers because they
> know exactly what was sent to the FW. For libiscsi this is a problem
> because it knows what it has sent to the driver but not what the driver
> sent to the FW. When we go to cleanup the running tasks, libiscsi might
> cleanup the sneaky cmd but the driver/FW may not have seen the sneaky cmd
> and it's left running in FW.
> 
> This has libiscsi just stop queueing cmds when it sends the TMF down to the
> driver. Both then know they see the same set of cmds.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 106 ++++++++++++++++++++++++++++------------
>  1 file changed, 74 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 4834219497ee..80305b70298d 100644
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
> @@ -1707,31 +1689,94 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
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
> +		default:
> +			break;
> +		}
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
> @@ -1742,11 +1787,8 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
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

Reviewed-by: Lee Duncan <lduncan@suse.com>

