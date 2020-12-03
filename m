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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FF21C433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 21:10:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEFF2207B6
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 21:10:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgLCVKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:10:12 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:25872 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725885AbgLCVKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 16:10:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607029743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+GwEPgWR0nAb2GKr4rEvJp/EVScAdYraMxIiErTwG64=;
        b=fE2WKUMIO1GZXBAVJq0ZEFLcNFHOE3cp+fpXs1hotx/U83RwlGKpVvQSeGbrHyI3ApWmhl
        uwuLVC9VJ/nk4nqYjJvALmErkwnyKgcW2Qxlvk4EBv3c7LEKgFuQaNpF5LpPkvIFcdvOUj
        UJSXbwSVeMqPVYmoK3vRJBZEnqcb1NQ=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-16--TM0shcbPvuwQfvZyYwlSA-1; Thu, 03 Dec 2020 22:09:01 +0100
X-MC-Unique: -TM0shcbPvuwQfvZyYwlSA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ku4lx6E4WtKIkMlw016YIqd72a1hkwgwqXyBA/g7Hn/RYIDq7K25eMdQrmbhp+icalz/u48m1PlGdJYCCOMysoJKSWwTfAj8HX06h8fU5e0v0YI5mYcHsLD9+F/WVgNo37LwFYkeofOeh2HsmZr5iSRLT/4IGsH+5oMUrC5YnWoEXPno+aEF65GT48yBlWG0ZtGJjQwj2N7TkAnZMvKiwO250HsCjFealhqiRY1DOsTWeTXgho0gCtzzUI42tF1X1o6V6N+SZ1GRFWyD8FFnDakSlqWtVedVmofxZxodZcqNazW0r8Sysdvs0Hr+azZVv3uYHlwUPFyZyCUO+YFPGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GwEPgWR0nAb2GKr4rEvJp/EVScAdYraMxIiErTwG64=;
 b=QKuw9O8UX6tNSKfTKPbYyoYHQOrmYYXPoIeajZAwo2E0aa61sBQ5Nrx8WbGW6/Qlh5mPLboqC6784f4OJJAUyll+ldKfDqBM49uckGyj66uj1bPXM3qcMqQ+r5MOQhuwJKxjmv+jdCDJXGS5fUiB/52gfA1udlOdAG6JEKY66FG5KJSZB3T8uMfJaYz4SxGfpBg90gPVZeSCG0/lCmW8e8ZwMZNVx5vPX/IYoolsv9Wa4psugpI2XOSkZLgvXDqg9+q/RA1a9mjdx7Em81GAmuniLslcsLJ0pQDjNCitF+NMcmMfPEZwpxSpXRlPYscA4aS2UXPMNzEfEAL7VCiIAQ==
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
 2020 21:08:59 +0000
Received: from AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952]) by AM5PR04MB3089.eurprd04.prod.outlook.com
 ([fe80::d0f5:2f85:a7f2:2952%7]) with mapi id 15.20.3611.031; Thu, 3 Dec 2020
 21:08:59 +0000
Subject: Re: [PATCH 04/15] iscsi class: drop session lock in
 iscsi_session_chkready
To:     Mike Christie <michael.christie@oracle.com>,
        subbu.seetharaman@broadcom.com, ketan.mukadam@broadcom.com,
        jitendra.bhivare@broadcom.com, cleech@redhat.com,
        njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, varun@chelsio.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <1606858196-5421-1-git-send-email-michael.christie@oracle.com>
 <1606858196-5421-5-git-send-email-michael.christie@oracle.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <0da1434e-6c02-3cac-13e6-5d910be7c2bf@suse.com>
Date:   Thu, 3 Dec 2020 13:08:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
In-Reply-To: <1606858196-5421-5-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.25.22.216]
X-ClientProxiedBy: AM4PR0302CA0012.eurprd03.prod.outlook.com
 (2603:10a6:205:2::25) To AM5PR04MB3089.eurprd04.prod.outlook.com
 (2603:10a6:206:b::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by AM4PR0302CA0012.eurprd03.prod.outlook.com (2603:10a6:205:2::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 21:08:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 51b783e8-6356-48aa-c08b-08d897cfa75d
X-MS-TrafficTypeDiagnostic: AM6PR04MB5016:
X-Microsoft-Antispam-PRVS: <AM6PR04MB5016C32E23CDFE3846769C22DAF20@AM6PR04MB5016.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EFhCE4GVSzqn6F1cjD6HiWQXIBxZDtWsLh13GvaWdSfZtG3sUaqGbauKHpIvuMx1IFSyWfUpX5NrS7c9AYRwxgcpdjuq+HhJO9PEH4I+nZenlEdumISqo2RCUloae9c3CWMo1AlXRmLNjIiWbQ9e/HHIHKYJmm9qMDGwmb1jAeMrW1STYalvTM2Q+MjLvFaoOFrGo2ZVcRmx0TypgFJXkiYV9O9fHQ306IGuivnseMwIsNGVhF17n5jmRLiLTcfbUQEavtYvHgy0fodaiDABxcxl89jrhuzQRAJzJu/uEP7eDpQuKIOMzbntdDd+qE9bqDX1lOSm8KE0n/2Kq4W1sTlPSCvUdZ3HPKWHYQcLWjmytb+Yqkw9S5DvaMfnUdf3yIUI2JALepx1OrNHwngaKMvtc5RkAcycXH8djrcCBMc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3089.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(396003)(39860400002)(7416002)(36756003)(478600001)(31696002)(6486002)(52116002)(16576012)(316002)(26005)(8676002)(8936002)(2906002)(16526019)(53546011)(31686004)(2616005)(6666004)(186003)(83380400001)(66476007)(5660300002)(921005)(86362001)(956004)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MFREc3N0VTRILzhyQVdTUjk4MThLZ3R0alMyNU1vbW5rOUNub1owQVpiT01n?=
 =?utf-8?B?c1ZBYXdKbWQxdVhCM2UzOTdUbmg2VjBub2Rvbm1rc2ZKQ1Z0ZThxNW1LMUtw?=
 =?utf-8?B?UnBlVnZPQ1g1YnpOM1RWaDFUUDNWb1k1SE16Vkg4L2FtTjBTSDd6T1BNUUll?=
 =?utf-8?B?WUZrZ2R4dFJ4NERZTVp6NjdWVGZNK1NHSlh0OWpXbjQwenhGTWgvUHg2QnRv?=
 =?utf-8?B?YmRnVHgwL1hMS3dnU0k3S2hWOFlHdXdtaWREdllHaUtSd2N2VkZRM1FCUWZ1?=
 =?utf-8?B?WmhGVU1TelVUdm1NWFZQSHpXeGE5LzcvQ1pEYU5seTlOTXBPM2VlQ2J0eUVu?=
 =?utf-8?B?VG1HU2I1SG1FNGE3NDRkWVMxM3o5RUxsU3RvWUMvM0taMzBtNnRxWkd0QkFw?=
 =?utf-8?B?THBRNERvQjIrdVBEQW9GcmhnN3hHVUltWUpHWFFVNEpKcCtrK2ZhbUtDOHY4?=
 =?utf-8?B?VjlUQWVEcDA3d0RpS2Vra2NNaXFvYVZTKzh1VzViQlJOQWlUWmxJQXFENEpp?=
 =?utf-8?B?NFZkR095WW84ZE9mU1ZTU2VwQ1E3TGRDcUtrVVNnalhTVlNuV21RV3Fjd1BR?=
 =?utf-8?B?OWpQL1lQdUN3UWY2WE5ObGkrbUlKU2FUYmVBRldZN1RPK0RTOTN6WCs0RVpj?=
 =?utf-8?B?RzJGSU1GZkhQSnhackNBWUdYN0hZMjg3RzBSOWhnTWFXYWJEVExiSHBNK3E3?=
 =?utf-8?B?KzdJNkhjOW11N2hnbDdCcXUza0xOZkFIQ0lDZkI2STRKY3Nzb2F1MHhXeUhp?=
 =?utf-8?B?MlhRdEFybnRJRnI3RVVKV01rcU5HSlZNOFJucGowV1dtSUk4Q0ZEbSs2TWtk?=
 =?utf-8?B?cUJ2WktHYk51SzRhdGZnSzJsM28zYTduQW9ya1JGSTY2VDBMcW5nYU9zTXlj?=
 =?utf-8?B?ZWMwaDJiNE5OTGNWYVFMZEdiZlc5aVYrOXlxR2dIeDQyTXdZWWY2YUtyRFJM?=
 =?utf-8?B?VWJVdVM4YjJzMXZVM1k4QTZSUEhQN05WWWd1anFDU2NBY1ZyLzFMb0JSUjE2?=
 =?utf-8?B?WXlMMTA3MU5vV2Zna2czR1NxclRhRWZHL0FBMmFSSUZSc2JCS2ZOdHhXbXZQ?=
 =?utf-8?B?dlhWeDlHU2FsaHNSczYwOEFiRW9qSW93YVh2ajZycEtYZkh0RzJVVnJMSG0w?=
 =?utf-8?B?RFBkOUtsOHdITWtNVFJobHdXNm9ML1p4emptUmNhdFFUVVBmMGJhaCtvTWZR?=
 =?utf-8?B?Qjg5b2QvWXp1bUtHQ3Jvc0FMOERJNUdTbTN0THlYa2l5MHVHOXlUNzkrcmwx?=
 =?utf-8?B?ZmZWb0hORnFCb0ppS1hMd2lEdTUvVjVja2crd2tXcTA4TldjK09nMnBkWWZu?=
 =?utf-8?Q?SBTcEn/QjVTJg=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51b783e8-6356-48aa-c08b-08d897cfa75d
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3089.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 21:08:59.6797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: soOzoVJoz4r9o1qk7YHn3c6hSCZ8pALQuYfn/1a/YHR7VBsDo/Ciy0cAQj1Rbl/CKsWJj918NsgqOfd/hTBD6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/1/20 1:29 PM, Mike Christie wrote:
> The session lock in iscsi_session_chkready is not needed because when we
> transition from logged into to another state we will blocked and/or
> remove the devices under the session, so no new IO will be sent the
> drivers after the block/remove. IO that races with the block/removal is
> cleaned up by the drivers when it handles all outstanding IO, so this
> just added an extra lock in the main IO path. This patch removes the
> lock like other transport classes.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
> index 2eb3e4f..e9ad04a 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -1701,10 +1701,8 @@ static const char *iscsi_session_state_name(int state)
>  
>  int iscsi_session_chkready(struct iscsi_cls_session *session)
>  {
> -	unsigned long flags;
>  	int err;
>  
> -	spin_lock_irqsave(&session->lock, flags);
>  	switch (session->state) {
>  	case ISCSI_SESSION_LOGGED_IN:
>  		err = 0;
> @@ -1719,7 +1717,6 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
>  		err = DID_NO_CONNECT << 16;
>  		break;
>  	}
> -	spin_unlock_irqrestore(&session->lock, flags);
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(iscsi_session_chkready);
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>

