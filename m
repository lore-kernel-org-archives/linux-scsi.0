Return-Path: <SRS0=e6eI=52=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3040C2BA2B
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Apr 2020 15:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB9FB20CC7
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Apr 2020 15:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgDJPbW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Apr 2020 11:31:22 -0400
Received: from m4a0073g.houston.softwaregrp.com ([15.124.2.131]:35209 "EHLO
        m4a0073g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726049AbgDJPbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 10 Apr 2020 11:31:22 -0400
Received: FROM m4a0073g.houston.softwaregrp.com (15.120.17.147) BY m4a0073g.houston.softwaregrp.com WITH ESMTP;
 Fri, 10 Apr 2020 15:29:10 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 10 Apr 2020 15:25:02 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (15.124.8.12) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 10 Apr 2020 15:25:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mAqUUW1mQdP4E+/XJFLTOvbmdZQf7tiXYAPoCOTv68AjrWS423+sY3ZB/l1L+c2VfFX/iLyf+QSCFIcKWRh1oRQ8NqeFnfjBfPGp5PSVf/jUSBYTW9W6fvE4h3wVbP4SviKd2lo3iDXRLkkWilynPo9UC7Lpma6Mzz/qGUl7pgr3EARuD1A5fiJtAqu2TFBigW6Gep3+cRwKBbXGe6NFIhqCBQtEGLFWbVdLEhqid/cqT9fjwe1TmpAoO75ZHJFXZjrwjDxD2cEnGWSd+3aiP3A7vYfTnEhtXA+HC+/yceIYPnvBA9ffnCJaQ2WBFS6uJOOqNVf5mGNn9m9lZFHo9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QsUVWqHXGccXzY67MW3jFBMHiX+x7ml7exRTUUTFLY=;
 b=l2ujdXi5t0EAiptDr6VS5j06SI25SReTDSM53M+89lN1AQ08yYJMcESCa7juSsXvrFVWB+JcDiYifQb0uj9tRVUvtJYuq7L+8GPvOOuSBE4BLZn2ENwGBKLICjwM58hBwahdODJFuh5A7PmDdIMRMWKH7KU1IDkrqZhzV+cKgo9WBhNQ3nHf7+gO2Ukrmzasox9FsPukqtGvQSL5rtmGxU4GP2Rwlri95TMCN+Dec5MLOqM+TRnK97VIMDfh1BgOxDPS5V9TTIGFa0Rq6ypAz7EHS7xTpoWQdkDia18Kaq4wr7VkADaRiJ39Dn2QWbhLbarr/GnJ6/hXcDzHAdW1DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from CY4PR18MB1640.namprd18.prod.outlook.com (2603:10b6:903:14d::12)
 by CY4PR18MB0952.namprd18.prod.outlook.com (2603:10b6:903:aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Fri, 10 Apr
 2020 15:25:01 +0000
Received: from CY4PR18MB1640.namprd18.prod.outlook.com
 ([fe80::754f:336a:c93a:90cc]) by CY4PR18MB1640.namprd18.prod.outlook.com
 ([fe80::754f:336a:c93a:90cc%8]) with mapi id 15.20.2878.022; Fri, 10 Apr 2020
 15:25:01 +0000
Subject: Re: [PATCH 0/6] Miscellaneous fixes
To:     Manish Rangankar <mrangankar@marvell.com>,
        <martin.petersen@oracle.com>, <cleech@redhat.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
References: <20200408064332.19377-1-mrangankar@marvell.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <2a93600b-7539-feb7-29d5-0b1dac4e0e49@suse.com>
Date:   Fri, 10 Apr 2020 08:24:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200408064332.19377-1-mrangankar@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::20) To CY4PR18MB1640.namprd18.prod.outlook.com
 (2603:10b6:903:14d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0008.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:62::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15 via Frontend Transport; Fri, 10 Apr 2020 15:24:58 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90a437f8-8cf4-47dd-10fc-08d7dd6355c4
X-MS-TrafficTypeDiagnostic: CY4PR18MB0952:
X-Microsoft-Antispam-PRVS: <CY4PR18MB0952F6A0DCA2E5825017DF61DADE0@CY4PR18MB0952.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0369E8196C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR18MB1640.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(316002)(6666004)(26005)(31686004)(86362001)(4326008)(6486002)(478600001)(186003)(52116002)(8676002)(4744005)(956004)(2616005)(8936002)(31696002)(36756003)(81156014)(16526019)(5660300002)(16576012)(53546011)(2906002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wy1k+kTIOLCrly1U2/GF247m5jrOSYa9nYygE12QR5VF+GRqp+Tk+9fSaU3+GyfHO66cP8yZrOX3cNWBSr2uykEXLKKNgEfIDw7miCdMPq2esy8e6dfAbcCVPidCW8E+tTVUVWCKHHe77NmM9Ol7TE0D2lUu4PzueIHUmQMw+FPvjBUbz3n9WIgPcbuJachWl7/zVCny4BFbTNEenazv9G7D2gisYjHvemmNBMas+92HwAZqO2o5AicknN9KnEMB7EpK4sHIFrlw6kHtjUAmL2jjRbMjlpEALb36moqNZwM++ijHmO9EtkMzBCf0zKvHOt4Z+gDPkw1eph27QX1tFjujOCynz92ltZe5tLPqbif+9mpC/bpYN1Bq/zne47ARxep9P3HuVf2CgDLbde7m5T+SskDtj/+0gMEK1nNIl4UufaxG5ZcabsWHHvUUFzGs
X-MS-Exchange-AntiSpam-MessageData: l/emGlzq/TvJ/kxjs1uOjdC8YXuKV/ntv9rVIN3zOKdJhc9SIEujg+VY6ZMWzIPqAdKzixUJuyzdtChC5GyNxdj4o1Rpy8kW/dhURZP4LHgANgg4rvz86A+BltyZWhcwvUDyzv+HBCjJKynVKnM+Bg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 90a437f8-8cf4-47dd-10fc-08d7dd6355c4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2020 15:25:01.0876
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HN2jDgg3yOU17CqSJBQHDrdyYpjoacol+xvyyWtL4+Dw1qLRucI9Xx+flDjy/g+VOTohhEZZ5yAKmvSN3M+pIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB0952
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/20 11:43 PM, Manish Rangankar wrote:
> Hi Martin,
> 
> Please apply the below list of patches to the scsi tree
> at your convenience.
> 
> Manish Rangankar (4):
>   qedi: Remove additional char from boot target iqnname.
>   qedi: Avoid unnecessary endpoint allocation on link down
>   qedi: Use correct msix count for fastpath vectors.
>   qedi: Add modules param to enable qed iSCSI debug.
> 
> Nilesh Javali (2):
>   qedi: Do not flush offload work if ARP not resolved.
>   qedi: Fix termination timeouts in session logout
> 
>  drivers/scsi/qedi/qedi_iscsi.c | 17 ++++++++++-------
>  drivers/scsi/qedi/qedi_main.c  | 11 +++++++----
>  2 files changed, 17 insertions(+), 11 deletions(-)
> 

Please add my:

Reviewed-by: Lee Duncan <lduncan@suse.com>

tag to all 6 patches. Thank you.
-- 
Lee

