Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996BEC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 00:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 61F2021D7F
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 00:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="FS2Q29vM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLAVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 19:21:12 -0500
Received: from mail-eopbgr690078.outbound.protection.outlook.com ([40.107.69.78]:20779
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726887AbfKLAVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 19:21:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfTR+DPqFfqc8HzHzSqrgnF+Azgfw5fnAL0KFqnKE7dnoCk6MblDVCN1/9GktJjIqaIDbIaSAS0qoNht88IiiTWV2bp8ywa83u5hYToZdRB8c1VDVeAOidJ+aGXRpoOoKjrtFVtv1hX6dPcNtxOZTqdql+CE59gUEchcZ26wzl1uK9h3xIyJv+WPGcfFDqk/oFu0gE5Er/EH/2U29NCjK3kaFS+GhdE+575CEq/4s7pqbsl2cHjWJYJ4k7W/AX8AZ6uFRWK+iA8MDAu1EvG3ftdOELxEQ4dpf7z3MfQbE7zYQ2tX0nq7dkwJUVCZYH3FjTGR+lE4KqavoC2i6wGvJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgETscEaz3Q6S7+ulLMPv5SV5CZf51s5BfO68Li8t8A=;
 b=LX5JYYMoXD6h2UbTHOYxkzhLmL3kvcnzvHiUzU+oD0EZpfA7otAmQ5p+ZJ96n1hcNvTkIqOZ+f3llV0jo6DSQ+xzT+UKfJhHtsJmGKp3ELO8rquUVPKRv66/NS/8VN1KrfKuM32lfFzy5dcjy4jHKD/+twlhOO2S9jR/w2dJ4CpFu41HmaT7kFHYpIotkYsXERlYg7ArcKFGv1sp7GRw+QLp2mdsv6Ex0kLfjBlnUVmLCR23Bw2cuTh23Wmy/QK78DwBfzHjaTjnz57Tn3E+Tj+o502dgcano96kOihJ9VmayUjTeP3u9IZk1EAX6Vw+opyw8A1gxnUwqkjdpFaAHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgETscEaz3Q6S7+ulLMPv5SV5CZf51s5BfO68Li8t8A=;
 b=FS2Q29vMXuwvafTS6MAEFgsCGmQYbjwJnlUpvJCoDfikKg4aIFROe7aaLa1N5zkX5nHfEqNlM5nwIW0JAWpuWIdgEi7/NASX4rrNEgxiaj5GVNqCvGiNbh48cwuyl7EipNxyp7bNeawARgF+sOGv2ITL9YNAxRBA6BqDarOWbAs=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB5524.namprd08.prod.outlook.com (20.176.29.76) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Tue, 12 Nov 2019 00:21:09 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::a91a:c2f5:c557:4285%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 00:21:09 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "pedrom.sousa@synopsys.com" <pedrom.sousa@synopsys.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RESEND PATCH v1 0/2] Two small patches for UFS
Thread-Topic: [RESEND PATCH v1 0/2] Two small patches for UFS
Thread-Index: AdWY7wB4UlFJaqPmSsGCWRpPuD+RWQ==
Date:   Tue, 12 Nov 2019 00:21:08 +0000
Message-ID: <BN7PR08MB56840512CEBCDD2A1194F7F5DB770@BN7PR08MB5684.namprd08.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTUwODFmMzliLTA0ZTItMTFlYS04Yjg1LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFw1MDgxZjM5Yy0wNGUyLTExZWEtOGI4NS1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjU2NiIgdD0iMTMyMTc5OTE2NjU4ODk5Mjg3IiBoPSJjZGRSOHQwMXgvaWMzSWM0bkt5MWZLc3JvZVE9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [165.225.81.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f02f48c4-406b-40eb-0cb3-08d767063747
x-ms-traffictypediagnostic: BN7PR08MB5524:|BN7PR08MB5524:|BN7PR08MB5524:|BN7PR08MB5524:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN7PR08MB552426732D95A20CA439EA8CDB770@BN7PR08MB5524.namprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(366004)(396003)(376002)(199004)(189003)(71190400001)(71200400001)(26005)(186003)(66066001)(6116002)(3846002)(2906002)(66476007)(476003)(9686003)(102836004)(52536014)(74316002)(7696005)(55236004)(486006)(45080400002)(6506007)(7416002)(33656002)(2201001)(4326008)(99286004)(55016002)(14454004)(478600001)(2501003)(86362001)(76116006)(66946007)(305945005)(8936002)(316002)(66446008)(8676002)(7736002)(6436002)(110136005)(54906003)(4744005)(5660300002)(64756008)(66556008)(14444005)(256004)(81166006)(81156014)(25786009)(921003)(1121003);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB5524;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pQYS1VcSrSQz7xjkMZYgcofJYXw4bzFu6mKuZzFgKkcL+SkNObgW2D7FD9oBoNY2VB21rzRNZ7to063TpPeLA5AZyDXs9eop5pquIswwWEG5c3PL2rqLq+yIMTcVP4N7Z23iF52H9pg7irZ/UBfv6Ro2Y9BlEnzJwtY6w7H8fke8bivFVrlmeBp5HolJE6h2cF7GaUk9yF7QQ+LTSm+My1aB/q8svw0qNFUbnug42GkPheNMEcJirSxhjYFDO1W7qkMWn02dvmCW1FmH0agnaQEuO5qmvasMV9jkrcYbIivFYL/vL91jQvKa0/ndBso73/FFVzkilPkZt1X8gkFHD9Up18U3v2AXsQ8VFU77TQjuaP4v9OHnWLcK8rXV4on/gWj+YC6e0DMjIuk02gbuJ/BE5zMQUptBoK+hnOGFvN/ZS3dF5MC6QIdUeKC08XjO
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02f48c4-406b-40eb-0cb3-08d767063747
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 00:21:08.8557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MDvvg/GbVJXSBYbav3QWgkZFacPWOHdzWnqQs+aPMs/1KgMXaa4IuSX1oqs58i/P88YhUPJz/xFFAeftM0Fvhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5524
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bean Huo <beanhuo@micron.com>

Resend since ver.kernel.org rejected @outlook.com.
Hi,
Here are two small patches, one is to fix a potential bug which could
chase system hang-up, second one is to add more helpful debug hint.

Bean Huo (2):
  scsi: ufs: print helpful hint when response size exceed buffer size
  scsi: ufs: fix potential bug which ends in system hang-up

 drivers/scsi/ufs/ufshcd.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--
2.17.1
