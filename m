Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D556C32750
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CA392070D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 21:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbfHMVGi convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 17:06:38 -0400
Received: from m9a0001g.houston.softwaregrp.com ([15.124.64.66]:54171 "EHLO
        m9a0001g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbfHMVGi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 17:06:38 -0400
X-Greylist: delayed 1568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Aug 2019 17:06:37 EDT
Received: FROM m9a0001g.houston.softwaregrp.com (15.121.0.191) BY m9a0001g.houston.softwaregrp.com WITH ESMTP
 FOR linux-scsi@vger.kernel.org;
 Tue, 13 Aug 2019 21:06:14 +0000
Received: from M9W0068.microfocus.com (2002:f79:bf::f79:bf) by
 M9W0068.microfocus.com (2002:f79:bf::f79:bf) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 13 Aug 2019 20:31:07 +0000
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (15.124.72.10) by
 M9W0068.microfocus.com (15.121.0.191) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 13 Aug 2019 20:31:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aXMwMapwaUmJc5kBEHd6UbI/WFdSfcbCxYz0+SzWxXYm2eNAR8+3SkXsmtrkERuDE+YPTU3G3pNwOJ82wT+Dm53NNSK3MVQ5A0G6PW5An4RoGshagF518aIFo/Lyj0PdtD0AA/6MKVhZsNuVf7ySmWYEvCjRIfsB4Y+re2WiefKgK9UsLPluUAucVoffvXfaDGqj1QaYZcOdov5Pk9GOhx9oSJW1tOagSKyA7YoV2Ho9VoYfDrefUk0sCc0dSobZ+QwQfzxZadxvVd1TbDky0F5E9OXTDselINNIsL3LKvOFZf0GWrOK0rWGo8VKjSN0cfKw124lLRZnevO7S05VtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/koJh9iRsXmSMRW/rRuhhulP2IR289NhYEMkZLFI5I=;
 b=UHAJ0zhUfeTJUKZOFJqmSwnen7mre+GHjhNVGRwsE9jrc6W/HEztAazDmim3+sUTv2fDPhks5P/laxZn4vwOMVBI/OB9Q2PDI6+HZYbhfeTXzHFR2/WDzRehX3OPas7MYPlgwZb4HNoSrRC1el857x/Pb+ry5nQPWhwE6B5LuczxQeQ2AjsR7QP9LNsnOkypMU2mpLwHSB+7uizwP0zmABGOOnViUzVrlTdhaohhAceS86Vfsmahn5bX8NEEaailQLCL4p2dX6ownAsAq4y+1QyJJfNUIgU7g7Lm4K7JcaJmgMlBHhJxitl3ZKwS3RV8QUtMSrcfchuBHAsGe8Zj9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from CH2PR18MB3349.namprd18.prod.outlook.com (52.132.246.91) by
 CH2PR18MB3430.namprd18.prod.outlook.com (52.132.246.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Tue, 13 Aug 2019 20:31:05 +0000
Received: from CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a]) by CH2PR18MB3349.namprd18.prod.outlook.com
 ([fe80::8818:7a86:93d7:561a%6]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 20:31:05 +0000
From:   Martin Wilck <Martin.Wilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>
CC:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Joe Carnuccio <joe.carnuccio@cavium.com>,
        Quinn Tran <qutran@marvell.com>,
        Hannes Reinecke <hare@suse.de>,
        Martin Wilck <Martin.Wilck@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/3] scsi: qla2xxx: fixes for FW trace/dump buffers
Thread-Topic: [PATCH 0/3] scsi: qla2xxx: fixes for FW trace/dump buffers
Thread-Index: AQHVUhYH5w0Urzg+Q0aQfFT7/cf/gw==
Date:   Tue, 13 Aug 2019 20:31:04 +0000
Message-ID: <20190813203034.7354-1-martin.wilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0502CA0012.eurprd05.prod.outlook.com
 (2603:10a6:209:1::25) To CH2PR18MB3349.namprd18.prod.outlook.com
 (2603:10b6:610:2c::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Martin.Wilck@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.22.0
x-originating-ip: [94.218.227.174]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afe5cc80-c18b-492c-c001-08d7202d29ce
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CH2PR18MB3430;
x-ms-traffictypediagnostic: CH2PR18MB3430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR18MB3430167CCC32E4A21F76CEC1FCD20@CH2PR18MB3430.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(199004)(189003)(71190400001)(53936002)(478600001)(64756008)(110136005)(71200400001)(66476007)(81156014)(66556008)(6486002)(81166006)(5660300002)(50226002)(54906003)(66446008)(316002)(99286004)(6512007)(6436002)(8936002)(66946007)(2906002)(86362001)(36756003)(4326008)(26005)(102836004)(186003)(4744005)(305945005)(14454004)(7736002)(14444005)(256004)(25786009)(386003)(8676002)(66066001)(3846002)(6116002)(52116002)(2616005)(486006)(44832011)(1076003)(476003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR18MB3430;H:CH2PR18MB3349.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H3C3yvin+Lf+Ifki/nCI6BDFHehFq6XF7t95W37015ZBtk3l9SPAXvUDYOMFP6nIjF8agNeo7H+SQhnfmX0s/KlVc9m8Y0VLbHJNuaDILz8AW3liIxT3Bf5FyvkQDhED1X4dr9eNPCwHiyNZBIUxxVTEBFo8uOsaQggkIEgT8v66Q16DY9TqEFK7M466pHI5Q+WoDnBjbOz3Wh6EhRZFFa03bn49b7MP3KhpVDkvxJ5HgsSNn06443ICLWOayPcfWEBw8dm8xEPGbvW9bf0qSbcUJ5DpAZNe4UwQNK0hboEFgLxBpLGe+VtMn09qXHEezG6SDn2+ZBxsgFmkebjZqtAXDLIUMRMmUGh+5yr1sYcvf3c0wsqAGAXCA3gRNwzB6tZu9JN9kaVpAzkMiU+xmRvlir7+7JUSNwxPmyrv1Gk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: afe5cc80-c18b-492c-c001-08d7202d29ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 20:31:05.0852
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6kyNJvmkhyCYp+JFwKu83nZtx3w8X9iQJYMJRI6CAxUGFW4xr6YH23Cru1WiHIL1dWYVlrpSZJp+uQa8dIsZsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR18MB3430
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
memory pressure. The other ones are consistency fixes that occured
to me while working on this part of the code.

The behavior in the failure case was not consistent in the current
code; patch 3/3 makes the code do what I think makes most sense in
a failure scenario.

Regards,
Martin

Martin Wilck (3):
  scsi: qla2xxx: qla2x00_alloc_fw_dump: set ha->eft
  scsi: qla2xxx: unset RCE/EFT fields in failure case
  scsi: qla2xxx: calculate dump size if EFT alloc fails

 drivers/scsi/qla2xxx/qla_init.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

-- 
2.22.0

