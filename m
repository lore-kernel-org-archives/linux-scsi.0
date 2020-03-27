Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9018C2D0E5
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:02:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F8C22071B
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 16:02:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgC0QB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 12:01:59 -0400
Received: from m9a0014g.houston.softwaregrp.com ([15.124.64.90]:48360 "EHLO
        m9a0014g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726333AbgC0QB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 12:01:58 -0400
Received: FROM m9a0014g.houston.softwaregrp.com (15.121.0.191) BY m9a0014g.houston.softwaregrp.com WITH ESMTP;
 Fri, 27 Mar 2020 15:59:34 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 27 Mar 2020 15:53:30 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (15.124.72.11) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 27 Mar 2020 15:53:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Be8o4c+0ib1d8HtgIHC7Wivb8n7rZNeBvPBp1PXFep130q3ioTL3XvGY2oM256AT3LvajLzK2gekWPX7Agp4Fi7pZRVI2Os2S9ABh3ZO4sMUscH9wv71BIG69RHXqq/1to2PPdi3cqFHwkMfZbJJkJDn+1HJsucYwcQoPwh2zFWgxzqcWOgrMRd6tSoorh3cmA7+TO81+rFR7dKItU4xC66PLVojiWzubj0bPkTFlyAHcal5TzYQv1aVQy+cvLnaiLbxwT9ORmbf+dkdAECEsJ7TVlVxxlvmrhg650/PzR2SudfuqKfxloDul6i83VUFS/Xb94Vh7Tmo+tgEPRz4VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egZOqbefoFiWnGog+EREyq3TyllB99BzPMuHh4PWmHY=;
 b=UFpsUC92R7X5OXXhsyrthhOB2i/rI9mf3SvTYn+zBCyFtFdrlajkccaojYUsrGECIcdyWNI0R6AAyQan0z1QAMWY9vPv4ftLvvv39vRAOWD5V5gZteHReqpl1HGvl8yOJnoHlwtRkkjdMQVqy5tdD4YszzXNURJd035GxwXF4qefWKEENmdQaTSnOMw+Y8d6MOapiTXfXPyON5MtzmI28i7mGItGpviPCwA6RZO3Z/sn9vGd9FvYERSSJgRKWl1stsqVCzDxDwbWzAoAOfMChbhrZDpFaP1Opy8vvaDue2pkr9AL8skt9RoLl/LgA40uKLfGXPR5r5/y7f7Qc9q9mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (2603:10b6:208:168::12)
 by MN2PR18MB3510.namprd18.prod.outlook.com (2603:10b6:208:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Fri, 27 Mar
 2020 15:53:29 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316%5]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 15:53:29 +0000
Subject: Re:
To:     <chenanqing@oppo.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>,
        <ceph-devel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>, <cleech@redhat.com>
References: <5e7dc543.vYG3wru8B/me1sOV%chenanqing@oppo.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <5462bc04-8409-a0c3-628f-640d1c92b8c6@suse.com>
Date:   Fri, 27 Mar 2020 08:53:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <5e7dc543.vYG3wru8B/me1sOV%chenanqing@oppo.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0133.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::25) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0133.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:9f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Fri, 27 Mar 2020 15:53:26 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ab48574-af1e-4992-ba82-08d7d266fe1a
X-MS-TrafficTypeDiagnostic: MN2PR18MB3510:
X-Microsoft-Antispam-PRVS: <MN2PR18MB3510146DE44E324FB8CF571ADACC0@MN2PR18MB3510.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(26005)(31686004)(66946007)(956004)(86362001)(16526019)(2616005)(6666004)(66476007)(186003)(66556008)(316002)(31696002)(16576012)(6486002)(53546011)(3480700007)(478600001)(8936002)(7116003)(2906002)(8676002)(5660300002)(81156014)(36756003)(81166006)(52116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB3510;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /jdkfzjdVfWFbiGjZHS7ev/xUQ2gOh4ZKnGRPDxjbmJ7Xo4yyVEfYoXwVi+sjq0Gkyo4k1bptvZD3iX2OMk2UKasv6rbPsrWovOv/VMbmyBZVaCkpCVFe+LB0pXfvPFtSscZADqFixjF9qw8q6wTwW1Pr9YdQjmU0XH/r6rRpaR+4qeNI/stZBR9CqOccK11YHmTpjf0fJJCsJLNFwrSsW61tPfQxnArh9qa7sXFmtz57afxHzLj6jmyJAegv1J9XdRdCFDubUuRqhAyH/aKVTR6fiSeVCtrpcrK9jI3Sa4c4bJC/SvTH0hjHi18daEIlgyMuJT9Mlc8yfjeE0L85khBjLl/0tSI18ul79B3JJhBEn3gQ5sdE6Nls23wr+YhGBfiuNs2rrYoKS/hj63K9VjAb6Y3CM2a//iRtEA5qx8umAM8OLWTSkQgfH8sXyyj
X-MS-Exchange-AntiSpam-MessageData: UatvccMyIk4KwyqlESkaMvpTaSklm7w2d6zOXxuvNnBFhoK2cF7pFQqbFvimIf+//+MjzDio2d8PlZK3/A/rugMtTaBT1Z9wIK689Z7Q/HezFy9+H/rGUfNprQkvOV7DW3L5PopY5/k/CmZibOf2Lg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ab48574-af1e-4992-ba82-08d7d266fe1a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 15:53:28.9685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NkY9Vd8v79NH8lJS4+rzLtlYBbIJhJ9ro3mXpckmEi8kMpgkNaWOM3O/BxKeuydP4NwDOSe+hPUXVlJVJeUd9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3510
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/27/20 2:20 AM, chenanqing@oppo.com wrote:
> From: Chen Anqing <chenanqing@oppo.com>
> To: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>,
>         "James E . J . Bottomley" <jejb@linux.ibm.com>,
>         "Martin K . Petersen" <martin.petersen@oracle.com>,
>         ceph-devel@vger.kernel.org,
>         open-iscsi@googlegroups.com,
>         linux-scsi@vger.kernel.org,
>         linux-kernel@vger.kernel.org,
>         chenanqing@oppo.com
> Subject: [PATCH] scsi: libiscsi: we should take compound page into account also
> Date: Fri, 27 Mar 2020 05:20:01 -0400
> Message-Id: <20200327092001.56879-1-chenanqing@oppo.com>
> X-Mailer: git-send-email 2.18.2
> 
> the patch is occur at a real crash,which slab is
> come from a compound page,so we need take the compound page
> into account also.
> fixed commit 08b11eaccfcf ("scsi: libiscsi: fall back to
> sendmsg for slab pages").
> 
> Signed-off-by: Chen Anqing <chenanqing@oppo.com>
> ---
>  drivers/scsi/libiscsi_tcp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index 6ef93c7af954..98304e5e1f6f 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -128,7 +128,8 @@ static void iscsi_tcp_segment_map(struct iscsi_segment *segment, int recv)
>          * coalescing neighboring slab objects into a single frag which
>          * triggers one of hardened usercopy checks.
>          */
> -       if (!recv && page_count(sg_page(sg)) >= 1 && !PageSlab(sg_page(sg)))
> +       if (!recv && page_count(sg_page(sg)) >= 1 &&
> +           !PageSlab(compound_head(sg_page(sg))))
>                 return;
> 
>         if (recv) {
> --
> 2.18.2
> 


This is missing a proper subject ...

