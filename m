Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D1BC433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 784442064A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 13:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbfHNNwd convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 09:52:33 -0400
Received: from m9a0002g.houston.softwaregrp.com ([15.124.64.67]:54324 "EHLO
        m9a0002g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726263AbfHNNwc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Aug 2019 09:52:32 -0400
Received: FROM m9a0002g.houston.softwaregrp.com (15.121.0.191) BY m9a0002g.houston.softwaregrp.com WITH ESMTP;
 Wed, 14 Aug 2019 13:51:53 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Wed, 14 Aug 2019 13:28:28 +0000
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Wed, 14 Aug 2019 13:28:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbI1acuIpHps3ijd4F2e9EicxhNm1b3yCh0jkuGHE0uuv5BytTI/9rsyPGIDuhYyt3ydUtINb1DMOIAs3iRIEwPmfGTGJrAqMnl8TdoGwgc8j9Ds58zrdh9dh/1g/LxuMheYWGcPd1iZW9fhldgV2MWRlqVM/IQfz44P/i4fQir3ogvmd+Ru/Xjewy+4IURHc+2Cki8debFGR8TK0UkXBHtMuDHxZZWL4O/okwNf30513CRHdtlt/Q4JGOr9bPn3C3Zgx/epvgFD4TN3jzT6IAyMWG0amd4zJX236v1PNQ1Ayyowdic0kku3HZxXJDGhr97DZMz3XeZlDnoYEBy8/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T+W926CZct00RJj7pTb+gd0i/s0VPf/lf77nJLm6BnM=;
 b=XZa9QBfyuj0bThgnJbHdmfWM2BqZKLB7RJU13si9uSiCoS4j+lc4+afy3qkOR4FExg0cgTI9/Mdi0t8IY7ESUrdwvuCEIocbF8zsBs4zIdeH5eqpRdXfFvT8MobEmq5tsv1bXIS5m4853KvVqQRgvUlXzwnvep7uqt8a02O5r50rfBiI+yUxblyt5MUtT7alsfd3URTqg6NzT3DzqfM7bHIp03Er4RkpYrykkqkUAmRBs+Q4NppMTNLsPUSBl/KAmaLQIfWxNU+SpMFMn+gVY+SRgwcyGCHUm26zuvP7I0lKuhCwRckFMnNJhbSPc2zbHMVgKgWnuo3RlY33iwnWQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3206.namprd18.prod.outlook.com (52.132.247.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Wed, 14 Aug 2019 13:28:25 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Wed, 14 Aug 2019
 13:28:25 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Joe Carnuccio <joe.carnuccio@cavium.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 0/2] scsi: qla2xxx: fixes for FW trace/dump buffers
Thread-Topic: [PATCH v2 0/2] scsi: qla2xxx: fixes for FW trace/dump buffers
Thread-Index: AQHVUqQm9KpDbfRTdUekc9UfNDe55A==
Date:   Wed, 14 Aug 2019 13:28:25 +0000
Message-ID: <20190814132642.5298-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0016.eurprd06.prod.outlook.com
 (2603:10a6:206:2::29) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:2c::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [94.218.227.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae50c08b-3f2a-476c-7177-08d720bb48c3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3206;
x-ms-traffictypediagnostic: CH2PR18MB3206:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3206F36344EE023DBAE0A229FCAD0@CH2PR18MB3206.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(6506007)(6116002)(53936002)(81156014)(1076003)(3846002)(2616005)(54906003)(2906002)(8676002)(476003)(25786009)(36756003)(186003)(6512007)(102836004)(4326008)(81166006)(99286004)(386003)(86362001)(256004)(52116002)(316002)(66446008)(66556008)(66946007)(6486002)(6436002)(110136005)(66476007)(50226002)(14454004)(5660300002)(8936002)(4744005)(66066001)(71200400001)(7736002)(305945005)(486006)(64756008)(26005)(478600001)(44832011)(71190400001);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3206;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dX3bl+Jy+6I4xiiw7LHmR/3DuTowc37E39JjPxMAVriNJKlo1UBs3Hxc2ZSAaMuYQBC8MCnvwnMciYmPf1aeI9jIaOa0/M2xetek4ph3vc8ewFotlEQHuoNMRy5n2T2rmER43eVJUw9LjG3SxrEPypMTbloKk2UBzSEw9HfCtF6srr9xcu5noy3dalEP90c5LWzhvikOolBQwQYMeW4flQ/qZVeWxr5m3inQunYUD8jCqOOEiIls4zrxd9yyQ6x5K9hKPvIPWxS0UlpycqX5WGe0KK1XBuKAzcwBDR+yzKBD/ZkYZMQJwamRcGpIb4PkHzxA6+LzJU4kRXNJWKto5mfZM0ZFd/0vsD5x6cxQtSWsEdXfosI/RDSGY4NVPi4ipHwDAvGheZN6Zqo2Mdi2vxPDm1EOWv2ITe1VSVB7juY=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ae50c08b-3f2a-476c-7177-08d720bb48c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 13:28:25.2982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0kf6x2+tqCIEKtG4KHzNw1EouXnmR+ja9dYWZX8U5ih7E+RJSAKNBBC8H2a1pJEJB4k98vzeGnh8sr2ygtuntg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3206
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

Hi Himanshu, hi Martin,

Please consider this series for merging. 

The first patch of the series is a fix for a memory corruption we
saw in a test where qla2xxx was loaded/unloaded repeatedly under
memory pressure. The second one is a cleanup/consistency fix.

Regards,
Martin

Changes in v2: rather then keeping the patches small, cleanup the
buffer allocation code properly, following (and going beyond) Hannes'
review suggestions for the v1 set.

Martin Wilck (2):
  scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft
  scsi: qla2xxx: cleanup trace buffer initialization

 drivers/scsi/qla2xxx/qla_init.c | 218 +++++++++++++++-----------------
 drivers/scsi/qla2xxx/qla_os.c   |   1 +
 2 files changed, 102 insertions(+), 117 deletions(-)

-- 
2.22.0

