Return-Path: <SRS0=31eS=5N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5798DC43331
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 01:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 265042073B
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Mar 2020 01:02:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgC1BCC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 21:02:02 -0400
Received: from m9a0013g.houston.softwaregrp.com ([15.124.64.91]:45590 "EHLO
        m9a0013g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726134AbgC1BCC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Mar 2020 21:02:02 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Mar 2020 21:02:01 EDT
Received: FROM m9a0013g.houston.softwaregrp.com (15.121.0.190) BY m9a0013g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Sat, 28 Mar 2020 01:01:06 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Sat, 28 Mar 2020 00:45:37 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Sat, 28 Mar 2020 00:45:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aGZ23bakXJ97ssJJyrcidOFTs+Kxqfh59htX0mcI/tRAh9qvZCQlOsf6baQ8biE6YDL9stegWwI93LFX9PO8IHtuw1D5ky88mMkSyqf2Img2RvNgXsqbGmHP+Ifsqe+gyMnvV0Q4vZc38u3xaR7rduPrgmdfo+kqJfiBHfN/nwoxp/DkCBMT+1zZfsmISJzgQYqA0J0ZtgRDMDQCoiStn0zUpqknGdP85Rmjs5kLzzXNfcLMES8Dk0kzm4UY2G1Jrp0RHUNtUtNgJH/mPrIoxLpPd4gCaF+33jbYaxygSt42eecxNVZl71gPdNGSwWNGM6k7JTp57BjI6mnsrDeu2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kINZ4Hf0WX+3JeHao5RH6WkZs5VsJo6p9vzozX07+k8=;
 b=Qgtjkld+QHTvVDaNSA8vNcTT+0kUtEkZRQCrJG1PvDe7KTi5/RzBJGoWsv4bzcbWLmyam+NJybDdE/UmLrAd5hQUwpf9ANjRZz+oMlm3zzqIlfoFc0AACmIfIszyuFvTl7gmR0rrBfCHQszkvf0V9xFl3x5/hiGpvLkFBoH3sEXH16v8HLIVL2nemQudKhpnS8xhDVdvVVCx74KCTPncCA2p/OVipfpnywHH4djevLIMAdqkei2Ifj/Es2uV1s5V8ezP8bFr7H8gx22xs14OqG77lfFmVE3EuwldT220VHpf469q4fi54wO8ybKgFYFiAMOJVGfjKIoIZA8F4ENW2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=LDuncan@suse.com; 
Received: from MN2PR18MB3278.namprd18.prod.outlook.com (2603:10b6:208:168::12)
 by MN2PR18MB2431.namprd18.prod.outlook.com (2603:10b6:208:ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.22; Sat, 28 Mar
 2020 00:45:34 +0000
Received: from MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316]) by MN2PR18MB3278.namprd18.prod.outlook.com
 ([fe80::257e:4933:95ff:e316%5]) with mapi id 15.20.2856.019; Sat, 28 Mar 2020
 00:45:34 +0000
Subject: Re: PATCH] iscsi:report unbind session event when the target has been
 removed
To:     Wu Bo <wubo40@huawei.com>, Chris Leech <cleech@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <liuzhiqiang26@huawei.com>
References: <4eab1771-2cb3-8e79-b31c-923652340e99@huawei.com>
From:   Lee Duncan <lduncan@suse.com>
Message-ID: <12f71fbf-746a-deea-aa93-e9f06c325dbf@suse.com>
Date:   Fri, 27 Mar 2020 17:45:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <4eab1771-2cb3-8e79-b31c-923652340e99@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ClientProxiedBy: SN6PR16CA0044.namprd16.prod.outlook.com
 (2603:10b6:805:ca::21) To MN2PR18MB3278.namprd18.prod.outlook.com
 (2603:10b6:208:168::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.20.3] (73.25.22.216) by SN6PR16CA0044.namprd16.prod.outlook.com (2603:10b6:805:ca::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Sat, 28 Mar 2020 00:45:33 +0000
X-Originating-IP: [73.25.22.216]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce737134-08d8-4694-0457-08d7d2b15344
X-MS-TrafficTypeDiagnostic: MN2PR18MB2431:
X-Microsoft-Antispam-PRVS: <MN2PR18MB2431317D270FF5301C6B52D4DACD0@MN2PR18MB2431.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 03569407CC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB3278.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(4326008)(31696002)(86362001)(8676002)(956004)(36756003)(478600001)(31686004)(8936002)(6486002)(81156014)(2616005)(81166006)(186003)(2906002)(52116002)(66476007)(66556008)(26005)(6666004)(53546011)(16526019)(5660300002)(316002)(66946007)(110136005)(16576012)(21314003);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iWPBQ9K1gSLYuG3wBarowhWJOTjwVXTg4SIvEnrnFZ5pE7+ixeh9fpS9KvZCOl79qBDnM5wymM+5Sem/8tzUZuPrSum0rSbY9pgLfzOP8kwsYtR3+YYdQNBwLoIzxEeoHqbLLrSS+xUeP/pgFCXOARl3cLr9r/PEpD46pFnaOsJfJP05RaT/CECSWc9823iI2gMV1GGPuN+0QNba/SQIxmaTqBM04eC6bGJC6i7MaAtOxOqpyQSzrAd+DuM7xBoKE3amEg0ZTkXd3UE/HJbSKWOjdYwyqdnko2ftqFWTHgMPIwQAxzqw/qctPjDHyFnWb/BeiXwS1XiseDp6Ta51m1cy5pr5Qj/DHn+AKF4PWus99T4Jy4KtN78v8rYxT8/yVfVjEe3Zx6QeQrNyKoxW3OshsKFgvZ22vmxrqyTVdIDBHVWoccVDA+/Vp0saICAQKcp8rojd2qtGygcYv7OU/fyNbFtEy+Szi/hY/h3sAiiQGR7i5UUkdura1hzBTUDJ
X-MS-Exchange-AntiSpam-MessageData: xV8m0Ho8OCvKYnyZLg1ThHZhYFx4eISmLyl8lM7ZEhxxbUiAF8IkD7jtB4X0bGC7t6mVdLpZhjQjdLzHXWxNjJ1VXV3EB2q5N0w8iA9vDCpx54EzoL/BtUBwuL0xYPL9OfwSkUfX+dCLLtXFfeHCvw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ce737134-08d8-4694-0457-08d7d2b15344
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2020 00:45:34.6284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cnv/VA48U9eQtwKqrM83sBCvQoUI6HyIIxGpBsUtplJg3r5DuPOL6Ts0cQ/iwghIDW44WZp/Kr63heGitVX4eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2431
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/24/20 12:52 AM, Wu Bo wrote:
> The daemon is restarted or crashed while logging out of a session.
> The unbind session event sent by the kernel is not be processed or be lost.
> When the daemon runs again, the session will never be able to logout.
> 
> After executing the logout again, the daemon is waiting for the unbind
> event message.
> The kernel status has been logged out and the event will not be sent again.
> 
> #iscsiadm -m node iqn.xxx -p xx.xx.xx.xx -u &
> #service iscsid restart
> 
> when iscsid restart done. logout session again report error:
> #iscsiadm -m node iqn.xxxxx -p xx.xx.xx.xx -u
> Logging out of session [sid: 6, target: iqn.xxxxx, portal:
> xx.xx.xx.xx,3260]
> iscsiadm: Could not logout of [sid: 6, target: iscsiadm -m node
> iqn.xxxxx, portal: xx.xx.xx.xx,3260].
> iscsiadm: initiator reported error (9 - internal error)
> iscsiadm: Could not logout of all requested sessions
> 
> Signed-off-by: Wu Bo <wubo40@huawei.com>
> ---
>  drivers/scsi/scsi_transport_iscsi.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_iscsi.c
> b/drivers/scsi/scsi_transport_iscsi.c
> index dfc726f..443ace0 100644
> --- a/drivers/scsi/scsi_transport_iscsi.c
> +++ b/drivers/scsi/scsi_transport_iscsi.c
> @@ -2012,7 +2012,7 @@ static void __iscsi_unbind_session(struct
> work_struct *work)
>         if (session->target_id == ISCSI_MAX_TARGET) {
>                 spin_unlock_irqrestore(&session->lock, flags);
>                 mutex_unlock(&ihost->mutex);
> -               return;
> +               goto unbind_session_exit;
>         }
> 
>         target_id = session->target_id;
> @@ -2024,6 +2024,8 @@ static void __iscsi_unbind_session(struct
> work_struct *work)
>                 ida_simple_remove(&iscsi_sess_ida, target_id);
> 
>         scsi_remove_target(&session->dev);
> +
> +unbind_session_exit:
>         iscsi_session_event(session, ISCSI_KEVENT_UNBIND_SESSION);
>         ISCSI_DBG_TRANS_SESSION(session, "Completed target removal\n");
>  }
> -- 
> 1.8.3.1
> 

Reviewed-by: Lee Duncan <lduncan@suse.com>
