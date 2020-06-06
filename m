Return-Path: <SRS0=2jUW=7T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C435C433E1
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 04:51:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12297207D5
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Jun 2020 04:51:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgFFEvg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Jun 2020 00:51:36 -0400
Received: from m4a0073g.houston.softwaregrp.com ([15.124.2.131]:52056 "EHLO
        m4a0073g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726153AbgFFEvf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Jun 2020 00:51:35 -0400
Received: FROM m4a0073g.houston.softwaregrp.com (15.120.17.147) BY m4a0073g.houston.softwaregrp.com WITH ESMTP;
 Sat,  6 Jun 2020 04:49:20 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Sat, 6 Jun 2020 04:51:00 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (15.124.8.13) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Sat, 6 Jun 2020 04:51:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1JIZ9aNkBqIZEOUH5+RqLP1zbF2+nQO2S7CRF4kh/nyoAs0d6yM7B93ML0Kr0pMDPfIVpCs7ZQs0gXnYxSe9W7Y/7bwj6PbrEaupYVOHOUHeKYk0u3mW2JFAMVtJ/A026tZwjGP6vdd5cSCfl9oJUKXfnLcMk4D1B9ijVQw77DD5cq4gc/+h1mnxT9phfGL8PEmXX4N7Q8cHpTfgOkUFnMvJqOTW5WsoBMJskNMf3AKZm/ruizUCP3Q7RboJGHzEuEoMrRnxeSVd0UwkoJgrPXoJi6uGMV9AqxnRJR+ewTJoH7bCEhhUyV29nrSQzj5F8NoqwRQAoc3zdzKxOyNVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8u/DUfgAbkFPZ3SWktHw+VQLzpTJN7uju2nK6F1lQ38=;
 b=OcXBZos1MdR6mfsvRh3rFHO+0yQHi8L/cPcAqA/Dy25Psb8r75AgRbY5gAy9QJKhSOAVt3IInulPt/qytj6beVfQauNEnw0tjgM3yz9M4cKW0Vn1qBeL6UI2rJ0lqeVpF6uOeMTOTnn2b6D4N30wRSQBMMxBs4ioPxEUUMPw1UP0odOmioqKZoyhHAf5UfH+WquKq3kN2x5VTW9a+7MOCfZX+PDv7Yu6wc8uPusKraZ7qIrUhWLqDaqJjZmBzV087We9arRaDxeKYFCCk2BgyFnzpaI74nrZPZ5a8anpleg9jGPkmV8f5Vfyt6zstHAB5sCqtrAjoLLJkDxMAYCUXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=suse.com;
Received: from MW3PR18MB3658.namprd18.prod.outlook.com (20.181.53.24) by
 MW3PR18MB3545.namprd18.prod.outlook.com (20.181.53.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3066.18; Sat, 6 Jun 2020 04:50:58 +0000
Received: from MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d]) by MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d%5]) with mapi id 15.20.3066.023; Sat, 6 Jun 2020
 04:50:57 +0000
Date:   Sat, 6 Jun 2020 12:50:49 +0800
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
Message-ID: <20200606045049.da6nxagcom7w4gki@suse.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
 <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com>
 <4779a72c878774e4e3525aae8932feda@mail.gmail.com>
 <20200604155009.63mhbsoaoq6yra77@suse.com>
 <4285a7ff366d7f5cfb5cae582dadf878@mail.gmail.com>
 <20200605043846.f3ciid3xpvdgumh6@suse.com>
 <599e459f0a657fed8a262a34f43b035c@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <599e459f0a657fed8a262a34f43b035c@mail.gmail.com>
User-Agent: NeoMutt/20200501
X-ClientProxiedBy: HK0PR01CA0064.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::28) To MW3PR18MB3658.namprd18.prod.outlook.com
 (2603:10b6:303:54::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (113.116.105.56) by HK0PR01CA0064.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sat, 6 Jun 2020 04:50:56 +0000
X-Originating-IP: [113.116.105.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72e77b85-40ef-44ff-be0d-08d809d533d2
X-MS-TrafficTypeDiagnostic: MW3PR18MB3545:
X-Microsoft-Antispam-PRVS: <MW3PR18MB354589459FEDB3DA810B910998870@MW3PR18MB3545.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04267075BD
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sk1mkB8uKbBkdd/Tkan6jXQfJlek7Ow6bXGmIVid1bd4+j7zLE3dfxI2XQ2wGkt8KqAiQ5oLzgaEyuEKpN6A13+euoBwsszDMTs4sSdmbGYqDAL+8MitZCnfl2kJW5bHGpvEegYsJ67p4i9vKeen+sd1t9oCwnNWpw4gSxNmJBmjjopiljwUDY8i4k5e9c8t+sa4KtwDhapwWZvIHO/HNw1yf6FKQ0/9KTTdXyiMyQnT3BIaHY+C9iyXB6jDkcu7AQDqvJeSynCxHk0BkHwDzYTu1su/KkmjKKWnqKyczeOKsahPmg/CrFodnD/piEo1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR18MB3658.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(44832011)(16526019)(4744005)(54906003)(8936002)(478600001)(86362001)(956004)(52116002)(316002)(36756003)(26005)(2906002)(1076003)(6666004)(8676002)(66946007)(4326008)(2616005)(186003)(6916009)(66476007)(7416002)(5660300002)(6496006)(83380400001)(66556008)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DirpPQzcs71GD6XX/7zO2Ou7LcWEN1IzX7j00qPnj1S6vs3Kca3HRsRDNlJ2fq7ZrYoOpKEM/IDbJst0zPfbP8zLCcqcThPP9Q9XpZZMt4i0tpHdv3hZEtSVycPA9ZrdmVIy0/m+g4j47/9zqVPJXTWNSis9rLyx6kbFo/+VWEf4D8C3cTc+O2CqU6hLMDOM3gppoiJ+ql392wSVKe5AOaTcEWUANtZlGLVbCX1w9SXbDUDZpsZf+jfJH/KAbPiNQN1NZV3+VkXePNbiPYdMv+HJ/yqvD7DgrTfWwomN2g2T46amk8ThcscXYdqS/kwrFaNncXu5rtsZ1zH76h+cwO6sO+Y1/4cRuYMdWHaJ5vgODmUKrWkIIJYiWSENOv8z2bHo9W1YiQVfCmTePG7xPAXUJhYVdjZhFbuqmHs/ATCHtBnvsffaeey9GAH2Yx/3v9UzEWnqpnwrwBJGwTjxagKwZQAuYxQoCJDpEU0IXOe+OCC8wH31/U2WtGVGX56R
X-MS-Exchange-CrossTenant-Network-Message-Id: 72e77b85-40ef-44ff-be0d-08d809d533d2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2020 04:50:57.6193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y0Rqk6td9WOT3l8P+tIgaTDDnoHvo1tXls7RKCGHq0USAaCfSaHvZw2h7Y9Cu2Ck4caEPfJ4sQTnWD3mdea/2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3545
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/05 Fri 21:00, Chandrakanth Patil wrote:
>Hi Kai Liu,
>
>Tomcat (Device ID: 0017) belongs to Gen3.5 controllers (Ventura family of
>controllers). So this issue is applicable.
>As this is an OEM specific firmware, Please contact Broadcom support team in
>order get the correct firmware image.

Thanks for your help, Chandrakanth.

Best regards,
Kai
