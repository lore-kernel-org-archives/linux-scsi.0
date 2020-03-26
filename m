Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74BACC43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 17:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E54820719
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 17:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbgCZRkW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 13:40:22 -0400
Received: from m9a0014g.houston.softwaregrp.com ([15.124.64.90]:45173 "EHLO
        m9a0014g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726067AbgCZRkW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Mar 2020 13:40:22 -0400
Received: FROM m9a0014g.houston.softwaregrp.com (15.121.0.190) BY m9a0014g.houston.softwaregrp.com WITH ESMTP;
 Thu, 26 Mar 2020 17:38:59 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 26 Mar 2020 17:35:25 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 26 Mar 2020 17:35:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1kmBDcHu3OmJe7raI2nQ8aTxvsOOuQ1/zXosqDpmUrXAHbeX6W/Hpp4IFjnsPrypDvm38RyNHQxYnnzdD6VtMuyhWlk2IZq8fWGlIDJdKqec2jE77v5AMuvsJeTRf2LMdrWYINNZWsc/BTO2xwB6x+YgIWS454m91wAmJbKrzcWKlm9NPXpoHqmkoNusyDHCw2kZhg9WsUAXBFQ/I6YD7gjGurTe2mRwQuJzvjx4DjFN/p7kQJjVxTQWcZdGwFs8LubmkkxhncHQIuRSbD8l3m+OGkTE7tO2oEE89WoA90QGh3LRDcvemUySOOi3imnoLe0DehvK+GoiBs2MKmqGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KnqIo0rWw/nad9DwT7/GilIxbt/xJbsNb5dSib4DDFg=;
 b=dtFsKP8eOanzz0bRrcRCF5T/2nGMU6H45Z+N2HNi7rylSqcR1oVizSveJxrD9dmNogmNS6wxy3oyZVNW3OA6NZLFqe+EHOVhDqCzYtbP/hCVZYkQzzjrwQ7wwy9JMuvbnNVOti4KSSiKr7858qSPm54HNTcQYSersyHSodkhTYh3LJgRocIQ1rRH6JG4kfpxO8wut5XSXlMPytDcViu3GSg12ctWiafbxSzxNin5feCJI1RimJcumN1RvFhHBDJ9ssO4jVfGlU9UGBjmixfXSO23w7190C1lGXiqqN70ayu4pHQ7kqTFcgddHR7f1IYd2jkMxcH+ro+2f3IX13mTPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (2603:10b6:208:168::12)
 by MN2PR18MB2832.namprd18.prod.outlook.com (2603:10b6:208:a1::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Thu, 26 Mar
 2020 17:35:24 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316%5]) with mapi id 15.20.2856.019; Thu, 26 Mar 2020
 17:35:24 +0000
Subject: Re: [PATCH] scsi:libiscsi:Fix an error count for active session
To:     "wubo (T)" <wubo40@huawei.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     linfeilong <linfeilong@huawei.com>,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
References: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6916A28542@DGGEML525-MBS.china.huawei.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <d4f7d5e1-1695-488e-2fee-ab562173d079@suse.com>
Date:   Thu, 26 Mar 2020 10:35:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <EDBAAA0BBBA2AC4E9C8B6B81DEEE1D6916A28542@DGGEML525-MBS.china.huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0344.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::20) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by LO2P265CA0344.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 17:35:21 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c24c07d-2b1b-45cf-15e3-08d7d1ac108d
X-MS-TrafficTypeDiagnostic: MN2PR18MB2832:
X-Microsoft-Antispam-PRVS: <MN2PR18MB283211C8EB5000542FD82D5BDACF0@MN2PR18MB2832.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(66946007)(66476007)(54906003)(81166006)(110136005)(81156014)(8936002)(478600001)(8676002)(316002)(4744005)(52116002)(16576012)(5660300002)(66556008)(86362001)(2616005)(53546011)(26005)(6486002)(2906002)(956004)(31686004)(6666004)(186003)(31696002)(36756003)(4326008)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR18MB2832;H:MN2PR18MB3278.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OsC5z7JC2D5SUjOUQ9B81ly2Qi13yw1VtuxjuKGtKILoqiQA3wr0ZN/qpFzM4HEynjIoQWmMKXOmDoA++9CJ/IDWnOM7cDfDiNEhOtj0+eRk5XET31hrifrQYy4aZHAa0sXAdCJRoF7GWHkNonVori84tkLj3tMdOdWIlhqDtBU9z6vr2ElLf/FE7DLhJI9DjrYREiMXRzQo7VHh0THqJoSgX/mwdzJ2f5c1jffJFg9h9fc5POAFlAKFH0F2gnfxWEctCNsXIJ3Xa4X+UKCdf6G8BahGeymgAslnG4Z/KTMSjMH9I74h6gJuM57kjNBRDJXu3RMvSONBk1ONsutjI/aCL16kmY3fEe5L/F9o+futpi0h+sYJBhqnT0Miwtl9YvjdQOePoJKbWFUa9vZdQhFcSCkwxPurvbq47AmdB3PCGhv2OmBpUYBnYTcSP+tE
X-MS-Exchange-AntiSpam-MessageData: 18rljXGFLzYfsse4D4ibEdKFjMQVFzf527KTxrn5rTevyusXHTtxkp/TWAX/7kdLs1BShalizHvcEiDVQSkVwYVSh7K2BsXR3YnJVqThFSCQS6OGCEEb+Zp9ys7UmUkRoLOE08aKXjJaOUJx1TnzPA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c24c07d-2b1b-45cf-15e3-08d7d1ac108d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 17:35:24.1414
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QDA8oTcSZG2Xl0DGKj+NCwTTKQEuddpz2e8tK/788MOwE7Vzdt9gWKHSJgNGpw8AnsTKtT6bjCwhLF4jvt5V5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2832
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/20 11:53 PM, wubo (T) wrote:
> From: Wu Bo <wubo40@huawei.com>
> 
> Fix an error count for active session if the total_cmds is invalid 
> on the function iscsi_session_setup().
> decrement the number of active sessions before the func return.
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  drivers/scsi/libiscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 70b99c0..b7158eb 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -2771,7 +2771,7 @@ struct iscsi_cls_session *
>                        "must be a power of 2.\n", total_cmds);
>                 total_cmds = rounddown_pow_of_two(total_cmds);
>                 if (total_cmds < ISCSI_TOTAL_CMDS_MIN)
> -                       return NULL;
> +                       goto dec_session_count;
>                 printk(KERN_INFO "iscsi: Rounding can_queue to %d.\n",
>                        total_cmds);
>         }
> --
> 1.8.3.1
> 

Reviewed-by: Lee Duncan <lduncan@suuse.com>
