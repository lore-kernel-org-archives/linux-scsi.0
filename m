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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4058CC64E7B
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 17:05:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E35C321D81
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Dec 2020 17:05:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgLBRFa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Dec 2020 12:05:30 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:36997 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728257AbgLBRFa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2020 12:05:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1606928660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DZXrW00/jPcwkfF21/GLUehq/TUlRXkJZoSFoqHhH9Y=;
        b=Gll0dw4lOhaWEeTzzlRBlfS3MPsnLXIJY2HdJlvnx5HhsRYUaSvugCaLky2bYOB1RQB2fR
        pN34pN9AybKwRyYVBx2CBRq04618gl5j3B5qJSKYWGMjPRwko83aF8IdwznRTx4u4EhIVC
        3ZB9iYarw8++PbXumJZjo0+YHX+PHXY=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2108.outbound.protection.outlook.com [104.47.18.108])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-I7_XFPcXNwmFa3Crkpc8og-1; Wed, 02 Dec 2020 18:04:19 +0100
X-MC-Unique: I7_XFPcXNwmFa3Crkpc8og-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LN90M7K2PwAPuyD21ua7Ors0nb5PcU3bTjrme7a9E11K6vk/8CjhOwusSElM2dDt0J42lY1glRuTxcpvC2E2L+ClzDrF1eEZhoKKMfIRHc8e1SWFc36qYSW1V47k15Xtf/RHQwd0eRhfh6stDK6xfwtyNAqzPIWQTbAijx13KdLHBzc4PD77BhdQOqlosklYrfdhiUxVYHbh7lGcS6ctzNN09d7/MOIq1VsxN/Lt0+hbqMHOAzF/BSxrDQS+dV3XL7cdJ11DHmeXlfCSyDkZJ6+PG2QIHGDefIU5zEqXHLlQ2ggk28ohS8u/cJn/TT/0FBIAFXqOwY0hjMxXRLHVag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZXrW00/jPcwkfF21/GLUehq/TUlRXkJZoSFoqHhH9Y=;
 b=QE5Y0YfKK+807mV48UED5/E679VZSwkTaQ10+npTcxLX1UYgdDUzWO6jXfdQPhzFMe7vGjF38kgXlvusOBzpf7fy1puRpXffGJBFK1U8cAOvbvSzQ0XoQff6rvylu6tYcNtKx684mQnNg14miZmnXuEh8bRBIqWVBMUQ4aVWWMkpDRvNFAHBB+CGYindPSCz/L/BAGDevi3BQiSjZcdvhUuANer15lxU2QqTAs8fH2JMCNMDu7+SmO+o9ZZhL2IdNNDlwke8nOGnR/ZOi5KNSEYa6EakcL6Nw0uxWKtegwaZmllIShCbKhMTkpsxROsHhxPuWp0H4Z8UWqSkGOy6Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: hansenpartnership.com; dkim=none (message not signed)
 header.d=none;hansenpartnership.com; dmarc=none action=none
 header.from=suse.com;
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com (2603:10a6:206:b::28)
 by AM6PR04MB4104.eurprd04.prod.outlook.com (2603:10a6:209:4e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Wed, 2 Dec
 2020 17:04:18 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3611.031; Wed, 2 Dec 2020
 17:04:18 +0000
Subject: Re: [PATCH 01/15] libiscsi: fix iscsi_prep_scsi_cmd_pdu error
 handling
To:     Mike Christie <michael.christie@oracle.com>,
        subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
 <1606858196-5421-2-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <5fbb7929-33b7-2624-4038-7c824b3d4044@suse.com>
Date:   Wed, 2 Dec 2020 09:04:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <1606858196-5421-2-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM8P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::24) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM8P189CA0019.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:218::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18 via Frontend Transport; Wed, 2 Dec 2020 17:04:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33e77bdd-12d3-44fa-e73f-08d896e44df7
X-MS-TrafficTypeDiagnostic: AM6PR04MB4104:
X-Microsoft-Antispam-PRVS: <AM6PR04MB4104F475078C100F2CBDEF45DAF30@AM6PR04MB4104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ia09LE1b9FmClSQjZ+BWd65Nr0yEIXifzNdsLTHmfo0zImY/IDOujdXni3LmeUj3P1Gia0oXvBTUFNVhgkzIfuB1phcJ5yeB/PzhXWAVhcotkeGt0+0htexTx+lxrRzxI3KY0nzAIN5PqNqpU2CfxU0qSubgXG2qLF4Bw41UADCMPOvARUeJDLmmSibndlWtAgbtK8Z4kmsY22WY1dKodMoE8+diiElkjQbyzDWL8EKj+VKS2dpb4xLUMbemK+87//GeuFw4bFsk0x4oF3pFBF6zJGyFbDQh9jWMp1GQF7s0aVfwYAvB3g8nnv1Wby0+86schxaWItYoe9ibjfVYAuDdbUYr6umazm5NcyelS4V1yQu8y1poszckNkjENGWwLg45lGyZ5Y8QXeCULdZ4oszoQ7JO0p7m1MIrum5rf2wYBwyxD9KRW5oBG9VzYHFW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(39860400002)(376002)(396003)(346002)(8676002)(31696002)(2906002)(16576012)(316002)(52116002)(921005)(8936002)(31686004)(7416002)(36756003)(6486002)(478600001)(186003)(53546011)(86362001)(26005)(16526019)(83380400001)(66476007)(5660300002)(66556008)(956004)(66946007)(6666004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cGloQUZieHJPYSthclNQblE3WjExUm9GeDluZjBTajQ4NFl1ZXRDMmhWQzRo?=
 =?utf-8?B?UklaOFYyR20zNkswUWpKcFZ1bWVYRGNMTnVPYVhOOTJKMGdFSURpdHZ1dGYw?=
 =?utf-8?B?UlE0cXlUN0lVUklxaEJwUks3SlErMW5LallyWklTREpPWjByanVzbWhsWnI2?=
 =?utf-8?B?ektocnUvb25BUUp3bGtwK1VmbXUxTlAzcGNNVGFDdDJuR2JWcGR6VytiWFhM?=
 =?utf-8?B?Q2MzMnFPRUlnc2IwNnBCV2N0clIzeVBEeUoxTXZjTms0aWJRSjNlSkRkWDFY?=
 =?utf-8?B?MnY5WHJ1NHlUb2NEZ21uV0d3Z1VKNmd1NTQzRDFTTWxzTmNZSGd0ck9qWmNs?=
 =?utf-8?B?b2V2V0hlWVc2bjZ1ZzJtKytpdGZaZU1WeTJjNEQydEt5ZVNyUGFnWGw3eGFo?=
 =?utf-8?B?MlcwSlNaZ2tlaTZOSG1jdjVqVU5GMEVDbjd6eDh3OWd2czJJbkViYUhKdEJr?=
 =?utf-8?B?bTRFR2xEM0VYK1dtd2VETnY4S0NxdlJiMmRCMGNjQ3hmTUlzSEY1WmNTTkpQ?=
 =?utf-8?B?VENETDRwWTBMZFpDZndtenR4cE9rd282VW5QM3hhNGNja0tJZjF1Ui9lc0p2?=
 =?utf-8?B?TUxKS0VKdE9GTnlLSUxoSExzQmNXdis4RU82c09yRkMzTVBNZWU4M1JlT3cy?=
 =?utf-8?B?bWRlMGZBa0NUNCtKYzR6ZURoaE9Qc0hkMmJkdGltVmdzK0Z2V0VsUXlUcGZC?=
 =?utf-8?B?cnJvMGVuRW82MENSR09INWNRU2JoU1BMMkZ1eVBZS0xhWnlQeUFtYXJacy9z?=
 =?utf-8?B?TUxmbVBqUU5VWlFabjV4TFZsMy9jeVRycTg4UGs2UzR0YS9kLzVXRG9MdGFD?=
 =?utf-8?B?QTlwZk5sN2xKeG5XaUN4K2JoNFFTQ3Y5dm5JZHpTYzlZK1VDL0I4cG12NUp3?=
 =?utf-8?B?Z2g3enFsWlhONzBOc0FMS21STnFIQmRuS3BIVndUR3pWWHJSczNkZUVpTjM4?=
 =?utf-8?B?UzdJQU1RTG82UEdsUFZtem5GZnRNaElsOWdEeXFWclI5T1Yrc2p5VVUwTlZ3?=
 =?utf-8?B?Z2VmdTZCeWhqMXNtb25Ld1JwaXRQTkErSVFYcGtoZ1B6OWxyM0dJZ3JEZlZl?=
 =?utf-8?B?bDVoanJNQVhXT1RVT29uK2JNeHJ4MmpYeWgwUFprbVJrRXQ2dmRUQmtuMjB6?=
 =?utf-8?B?dmM2SjRtZzFpMHlPT25DYXl1UU5hR1lXbFZ4bGI2cEdPdk9rcUprRm5rQ3gr?=
 =?utf-8?B?UmdCVG9oNmVPK3NxQ3oyb1ErdXoyenBGNDVDdGo2Ky9nQ0xZaUhxR3FpemtB?=
 =?utf-8?B?ZmNYOGF6cEhXQStVbEVORTdiYlhiK2hUS3dQQ2RHVUlEUUQ4Vll3bEJoeXdQ?=
 =?utf-8?Q?DR+idEHdKu8XI=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e77bdd-12d3-44fa-e73f-08d896e44df7
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 17:04:18.2474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ody1vhgEUPqKV7/j7s3n2hOtIB8foLv9Qcop86BkVfc1s3IZWmN7wEXMBnm5gvsyHk5/5vwh9OPIYC3zwAc+Mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4104
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/20 1:29 PM, Mike Christie wrote:
> If iscsi_prep_scsi_cmd_pdu fails we try to add it back to the
> cmdqueue, but we leave it partially setup. We don't have functions
> that can undo the pdu and init task setup. We only have cleanup_task
> which can cleanup both parts. So this has us just fail the cmd and
> go through the standard cleanup routine and then have scsi-ml retry
> it like is done when it fails in the queuecommand path.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/libiscsi.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index f9314f1..ee0786b 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1532,14 +1532,9 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>  		}
>  		rc = iscsi_prep_scsi_cmd_pdu(conn->task);
>  		if (rc) {
> -			if (rc == -ENOMEM || rc == -EACCES) {
> -				spin_lock_bh(&conn->taskqueuelock);
> -				list_add_tail(&conn->task->running,
> -					      &conn->cmdqueue);
> -				conn->task = NULL;
> -				spin_unlock_bh(&conn->taskqueuelock);
> -				goto done;
> -			} else
> +			if (rc == -ENOMEM || rc == -EACCES)
> +				fail_scsi_task(conn->task, DID_IMM_RETRY);
> +			else
>  				fail_scsi_task(conn->task, DID_ABORT);
>  			spin_lock_bh(&conn->taskqueuelock);
>  			continue;
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

