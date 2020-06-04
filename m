Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B509C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 15:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DE9B20738
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 15:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgFDPwo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 11:52:44 -0400
Received: from m9a0013g.houston.softwaregrp.com ([15.124.64.91]:35471 "EHLO
        m9a0013g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729216AbgFDPwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2020 11:52:43 -0400
Received: FROM m9a0013g.houston.softwaregrp.com (15.121.0.191) BY m9a0013g.houston.softwaregrp.com WITH ESMTP;
 Thu,  4 Jun 2020 15:51:43 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 4 Jun 2020 15:50:18 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 4 Jun 2020 15:50:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JbEGnwDOrXLqO4TFcsYcoFWCP9oyT5fmE8hrxFvfM6szJh9CqwuLShYjDJcXIQRMMPeoYfT9F8cA9euuF2LYenV5d0VBYMADMjQffop8CJR1YkxpzlvLhrMK2DULGtfpejPfogLHx5UxmxDKMwHF6c/kpvIAyc3fmmIeRLdaViDAqTB8+vjmmBKdSO4ZaQRyyvQS4Mj7ck6teZk3IeUx/VLOlG0AJDXsfvtjp9XS3+uuJTSx53+beL93nmKzJPCR9seNHxAoc5Nv7RqpxGNJFKTYxgHxy1p30vtXpq9EpHsDBOsGSDgTYN0y0EUyW+cnq/nZqHpJkG+x5KXRODPTig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NM8oNXAvbeZP1HYFf+xXLOsjI2sB1T19VvO9Qr7E2UQ=;
 b=UeV/m2eN0e+4r2wpjHQlePivamyS+29u2gLekdSJvFMEA+bxVuAjtn3mbwR+RbR+/KXjU1r5mgerh3nO0UFL64tX2bFOFdAfrcG41N7NjlWZrnNByEIWXwT4+W8maOUKZOv49E3RFLepSq2K1/cMvkl12YPTSZu5ofuMAtyK492wtnsbaToFz/LM3gbtYX1yZ+vSlBKlJQVzmVwkr6XMZXVtiNFbBHdrzWi7uPnKMFK1dnyM53HIk/vtDdXKpl8DmzyOv437Oa3GeRy4RAMV2U9LBYELiSBiQM/+b9P5Avy3o5/YNTFAGDmia610ddXyqwJX4KOWUtSqTEjD8C5f6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=suse.com;
Received: from MW3PR18MB3658.namprd18.prod.outlook.com (2603:10b6:303:54::24)
 by MW3PR18MB3627.namprd18.prod.outlook.com (2603:10b6:303:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Thu, 4 Jun
 2020 15:50:17 +0000
Received: from MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d]) by MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d%5]) with mapi id 15.20.3066.018; Thu, 4 Jun 2020
 15:50:17 +0000
Date:   Thu, 4 Jun 2020 23:50:09 +0800
From:   Kai Liu <kai.liu@suse.com>
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Xiaoming Gao <newtongao@tencent.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        <xiakaixu1987@gmail.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused by
 JBOD
Message-ID: <20200604155009.63mhbsoaoq6yra77@suse.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
 <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com>
 <4779a72c878774e4e3525aae8932feda@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <4779a72c878774e4e3525aae8932feda@mail.gmail.com>
User-Agent: NeoMutt/20200501
X-ClientProxiedBy: HK2P15301CA0023.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::33) To MW3PR18MB3658.namprd18.prod.outlook.com
 (2603:10b6:303:54::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (113.116.105.151) by HK2P15301CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:202:1::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.3 via Frontend Transport; Thu, 4 Jun 2020 15:50:16 +0000
X-Originating-IP: [113.116.105.151]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 104ef5ee-3a06-4184-acc3-08d8089efa7c
X-MS-TrafficTypeDiagnostic: MW3PR18MB3627:
X-Microsoft-Antispam-PRVS: <MW3PR18MB3627D1BBCE78F2537C47A24E98890@MW3PR18MB3627.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 04244E0DC5
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4QgSw2wda1+YrUxqJljgy8NJAkMEa2z7BoPXHt9+f9tusUt/yG+707FP7j+5awR5Chr5hRXDJp7LijZJgcFIJgbyRM7lxtkIm44nLNllw63l+BzxfOg+S8KZjO4/ngtRYsJlG5ruJkbyGdCeLupdVb8q8GqgW9YPL886wnDAZmyVQL2j3YhZWFedleIqZiExO6EUp8dO+nt2jYBPndni7M6rIo8eR1clZ7amMO97s4EQpcq/zB2vL8JZcvUvR9t4ogoSRi8J4LC1EDdle12eOS51OtPB7R2cSkJ7qQp91EMio+oAbrtbHH1++KWyS1CX9fKvx9wZhTVA0uthrqs3ZQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR18MB3658.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(36756003)(8936002)(316002)(1076003)(66476007)(6496006)(6486002)(6916009)(52116002)(6666004)(5660300002)(86362001)(8676002)(66556008)(4326008)(4744005)(66946007)(186003)(7416002)(956004)(83380400001)(2906002)(26005)(16526019)(2616005)(54906003)(44832011)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: dHaUxS5jRE92UnH2krEMlQVAHSTkDllhz61WnYxxnCn/3q5sFADzGDrExlZ4klfEaJdBiX9fvEBLhTsv17Yqo6P9FKLudLh+mSCdLQWKj5uXvmgxk/8oEQImW41vWjt3uYLu4fs8xSj2+G+YljEl72vQvL8c4nL7DXU4FKNEuo3T6Yh9mjshU8C25nccmnOZx0mf8lisLs815vcGLc7AO6Z7Oq02zkNKJSKhhtpw7w+GynYeskZobUA5FF0m/H865DNiVibN17oAhdxmVqf+DsU7mpm7wZlEiIvsoQoP1anBdVHNO855Q0+j+Q7b3tdjn1xto2eLOnnAcMmlA7UGOJUWV1qTivjMS/IEnK8ZCP1/GZqekDJEWAfoWCoAe6Xk/4KqyqEvAG6/3tYZAnCayJMAtdRBwvGpz57AYcVp3z35nZ88J2g7PpfxMDA1yzwJGyLg7COHpC/Rqk/iw8fyCF/jjfJ5GBHtb8vxCm1s5rMX7Zt6SqsfIUcaKubYo4Y7
X-MS-Exchange-CrossTenant-Network-Message-Id: 104ef5ee-3a06-4184-acc3-08d8089efa7c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2020 15:50:17.6142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xS7otCYHsTDsqLaBHFspO+xsyOXyOG2tFU052ItLITHCk0qxTlUYnWtxIUKVSKNZoaNcSlAjco2xwMWmJLPw3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3627
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/04 Thu 16:39, Chandrakanth Patil wrote:
>
>Hi Martin, Xiaoming Gao, Kai Liu,
>
>It is a known firmware issue and has been fixed. Please update to the
>latest firmware available in the Broadcom support website.
>Please let me know if you need any further information.

Hi Chandrakanth,

Could you let me know which megaraid based controllers are affected by 
this issue? All or some models or some generations?

Best regards,
Kai Liu
