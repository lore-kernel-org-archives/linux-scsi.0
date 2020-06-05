Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE3EC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 04:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E21FF20899
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 04:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgFEEjg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 00:39:36 -0400
Received: from m9a0013g.houston.softwaregrp.com ([15.124.64.91]:44574 "EHLO
        m9a0013g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbgFEEjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 00:39:35 -0400
Received: FROM m9a0013g.houston.softwaregrp.com (15.121.0.190) BY m9a0013g.houston.softwaregrp.com WITH ESMTP;
 Fri,  5 Jun 2020 04:38:35 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0067.microfocus.com (2002:f79:be::f79:be) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Fri, 5 Jun 2020 04:38:57 +0000
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (15.124.72.14) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Fri, 5 Jun 2020 04:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvNfgNYIGyDdskRWmJnze/q+G58DMMR4sZVWuUi+ncPUT3WLeUNoBuYDJPKdlaAnDinlPZ8SD9evW0c0x5fO2CmQsqaTLg8GzEmybftPUni9groS2Zkrs70rgwmiLq5QsqGNCJAE/vYmyAN1xs67+L7ALrVboVGuVQim7pa7b0iT/ab3tuaQxUW335VfvcvP9L7Qdjsh4zMxY92EMOHM3I9BitqBu52UkakypnvhybmtHOEHv27p+Q2mNN6i9QbaEJ3qqRpL/dqViyb2Yn/yK9IVk9kahFNdQgwUNMywbWpkn42cX8zMU/YbTozJet6aObYimecr5iBVSRa6whaN+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7z/YJ2jHJg7BMc4knEiVmUpMCeW/zb5eYaljU6VgHCc=;
 b=gy2YVzfIWRowMzHDlTlH6tC5iDSmu2tebGFfB4aWyRFI79QIHkp9kRu1iNTjTpvyMUdzFsQwJRF7oFHjQ3i7KqhtdjCmgjUQqkolOBrqiRFXUj43ZVOj/29kMWwi/sJedWN9Tt5ypA56bINw7Ri8E5+O5xuIFoliTI3s/1ajQtxnfHQi5RFspVlOJYJRfDeNtMjMMaBKY//SHZjRfDXwOHM9IsPIFAZHbb2p4asjWpWlQW0YJmmiiKaR/3cWb8fHk6H/r3WG2DlC0rLtdmkjYWIo4H226+dYgk/KeHMH9+C2Y7Sc9iecayfsdnMDbcvbYgjOhtXlT+DdzmSWpltNYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=suse.com;
Received: from MW3PR18MB3658.namprd18.prod.outlook.com (2603:10b6:303:54::24)
 by MW3PR18MB3466.namprd18.prod.outlook.com (2603:10b6:303:58::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Fri, 5 Jun
 2020 04:38:56 +0000
Received: from MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d]) by MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d%5]) with mapi id 15.20.3066.018; Fri, 5 Jun 2020
 04:38:56 +0000
Date:   Fri, 5 Jun 2020 12:38:46 +0800
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
Message-ID: <20200605043846.f3ciid3xpvdgumh6@suse.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
 <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com>
 <4779a72c878774e4e3525aae8932feda@mail.gmail.com>
 <20200604155009.63mhbsoaoq6yra77@suse.com>
 <4285a7ff366d7f5cfb5cae582dadf878@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <4285a7ff366d7f5cfb5cae582dadf878@mail.gmail.com>
User-Agent: NeoMutt/20200501
X-ClientProxiedBy: SG2PR06CA0091.apcprd06.prod.outlook.com
 (2603:1096:3:14::17) To MW3PR18MB3658.namprd18.prod.outlook.com
 (2603:10b6:303:54::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (45.122.156.254) by SG2PR06CA0091.apcprd06.prod.outlook.com (2603:1096:3:14::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Fri, 5 Jun 2020 04:38:55 +0000
X-Originating-IP: [45.122.156.254]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 89e8389d-f187-4c6b-4dd9-08d8090a5b50
X-MS-TrafficTypeDiagnostic: MW3PR18MB3466:
X-Microsoft-Antispam-PRVS: <MW3PR18MB3466497194527454BAC65B6D98860@MW3PR18MB3466.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0425A67DEF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oiup2pHYY1+POwK9RHz93ZUa0F2o+VMBvqfrB6/W7f0nIreqK7cWEFpfkae4WYRSQQ0bCxbiRgM2GKwN2OyeXy8u+NGa2rgBRlKo6z1lA4N8MFyrE1arsO2bWQ9tuQPr9gVCijb22vvPVh549FdYzmgCzAkLBgXLNHKN42+FelhZN6Jqh3qkn0cqSIMn+8e4I61SiVrrvY1zqRpMPTXEvQqZFLJMSA7ByjGtWiIbKMqrvWVz5gqm5hU6FzongikuLNkaEk2o0bgro8kabViI1sR9S8p0BnQxninkwOxW9/G/wlx3auWG5BGV3WDxJUsx3v3tSHMFzTKqhBiVASgBwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR18MB3658.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(36756003)(66946007)(4326008)(6486002)(478600001)(2906002)(66556008)(8936002)(8676002)(5660300002)(66476007)(6916009)(7416002)(1076003)(54906003)(6496006)(83380400001)(26005)(6666004)(86362001)(186003)(316002)(16526019)(956004)(44832011)(2616005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: cwpIVRTbJwtpRIVDYqhU+fN99D/wwZukpocuYjRUtoSLUn2GR8oK9es78VXf8ta1VcbxKotTLlnzBstStzQ++i5LVISagISluedd2DUM1MVbBYT+Ph9SWh8cqxxL5dPrBTCOX5vpxcNJIS/OLEiEUULrxi1YefGj0v6azNgoabTAPotzb3QgBg6LVoQ3W+XsHIb8MA7saDXXTeFN9QUU2XwNd04CpF8U+/mM8xhM6VfNP6P+2j8CIU4GcsHuKsFBpNXavrFYvL5hwcE52CjmN1/fmRCS5TBUvHZtBvAEmZuTjU3V4kKqGNmE0etausjr4+I/QQFQH2iqglEeest2qA2QqbVilG0CJx1QTaWOBydEsL235WgePdCU5v4FX1eRWiZ0zEplknyaBAeL/7pB60O9WqTFYQ6qdKdhzEkehvIgXh4jaq/sw4XtqwDz2EyfGgW14S40/NAw/I8mb7CAD7F04smgjpufF4WFjLORzXVjYr8qgpxUy0m3VhsAhCm7
X-MS-Exchange-CrossTenant-Network-Message-Id: 89e8389d-f187-4c6b-4dd9-08d8090a5b50
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2020 04:38:56.3429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hcvt2Mpmt4SbXLYNFLBjJt5xZEywwD85USz0/1rmdfNe2BeXXOF7bSCpjymTHO6MA2WCR+Pu7/VBhM0fTMNsCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3466
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/06/05 Fri 01:05, Chandrakanth Patil wrote:
>
>Hi Kai Liu,
>
>Gen3 (Invader) and Gen3.5 (Ventura/Aero) generations of controllers are
>affected.

Hi Chandrakanth,

My card is not one of these but it's also problematic:

# lspci -nn|grep 3408
02:00.0 RAID bus controller [0104]: Broadcom / LSI MegaRAID Tri-Mode SAS3408 [1000:0017] (rev 01)

According to megaraid_sas.h it's Tomcat:

#define PCI_DEVICE_ID_LSI_TOMCAT                    0x0017

According to product information on broadcom.com the card model is 
9440-8i. So I tried to upgrade to the latest firmware version 
51.13.0-3223 but I got these error:

# ./storcli64 /c0 download file=9440-8i_nopad.rom
Download Completed.
Flashing image to adapter...
CLI Version = 007.1316.0000.0000 Mar 12, 2020
Operating system = Linux 5.3.18-0.g6748ac9-default
Controller = 0
Status = Failure
Description = image corrupted

I tried few more versions from broadcom website, they all failed with 
the same "image corrupted" error.

Here is the controller information:

# ./storcli64 /c0 show
Generating detailed summary of the adapter, it may take a while to complete.

CLI Version = 007.1316.0000.0000 Mar 12, 2020
Operating system = Linux 5.3.18-0.g6748ac9-default
Controller = 0
Status = Success
Description = None

Product Name = SAS3408
Serial Number = 033FAT10K8000236
SAS Address =  57c1cf15516f4000
PCI Address = 00:02:00:00
System Time = 06/05/2020 12:36:59
Mfg. Date = 00/00/00
Controller Time = 06/05/2020 04:36:58
FW Package Build = 50.6.3-0109
BIOS Version = 7.06.02.2_0x07060502
FW Version = 5.060.01-2262
Driver Name = megaraid_sas
Driver Version = 07.713.01.00-rc1
Vendor Id = 0x1000
Device Id = 0x17
SubVendor Id = 0x19E5
SubDevice Id = 0xD213
Host Interface = PCI-E
Device Interface = SAS-12G
Bus Number = 2
Device Number = 0
Function Number = 0
Domain ID = 0
Drive Groups = 3


Thanks,
Kai Liu
