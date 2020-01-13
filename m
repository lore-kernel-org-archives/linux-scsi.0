Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D14C33C9A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77FC221569
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:03:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="CqwevTkn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgAMKDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 05:03:24 -0500
Received: from mail-dm6nam11on2076.outbound.protection.outlook.com ([40.107.223.76]:28385
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgAMKDY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 05:03:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ar8U7swd0KtucXSGaw0wJsnNT8XnkcY/g62P5M3Y68ZoQxfKF0+eBrNsMJPaTtCPLpv4IugzDFqLM+xPsoWiUj1ROB9uaKF6AI1EkFbZAxxg4DlW6EKOPwgSu8r62TGq7JKbQ+0MfkHaC5QrW4Z/tKJhYocriHE3/HjoD+pKzFrN0Qrqyyv0JaCwyELWMj20q5Vpezo4gPiwFdpKDmGSEHvWARJUQOYzWDwOhUpDzIBg/QtVgcxtw6WQTXl3SwgpK0srXObw6rxmiUV6Gw8k6Tb5uOgQuRhwy3j6vQgxcIZzXBslYmXaVEzDOrpFc76QqABILUxif9b6OtoroMHpBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF/u7iSFC5I8PsEK0SX0VTJsUiWOOqSgJjXKpeLE6Fc=;
 b=HMWEqTyCrb+DEN1F5KfIeqOWWhpT5pxJMolVOHQV7WlhymwV1BkWwqx2XkLIJYGyjiJrdYE95d8VkPRuqFMYjEUAcLJAboctEuEl+bw/GJdS5Qtt7wNHbwnCKkM47HwV5ZsDYqES+5VM6m2Hs0uIr7+72677btTQm07gPIJliUBlxKprgBUwMmdP9C5MpFH76xC1Mv4lvz9/SiDcHEBowGqguR4XrAZDtEgyMZs9cbTxJxYMxKGg+kaUlcefwuJhgO4dv7x00sfHsw6qGhA2su/mpQOJ4xfL8pKayacHJ7I+h8EtqHqdRL22WxNgEuOKVlzPFX1LLk2QhsT6UuPRVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IF/u7iSFC5I8PsEK0SX0VTJsUiWOOqSgJjXKpeLE6Fc=;
 b=CqwevTkn8XmGG//QreBcEQR6o3NYLtZgvDCEOpjub64KVFN52OXWKaMrumoreAHEO5OnL2RcJltPCCf+LKgQgLQMGtkES+hy1g21yntnFXRqUosuXkK2yp9h4O5S4I7gH6wqM6T7jx28a9/M2OOZYoZABq2IDZ17TtQR31QDDR8=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB4292.namprd08.prod.outlook.com (52.133.222.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.13; Mon, 13 Jan 2020 10:03:22 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 10:03:22 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>
Subject: RE: [EXT] [PATCH v1 2/3] scsi: ufs: add device reset history for
 vendor implementations
Thread-Topic: [EXT] [PATCH v1 2/3] scsi: ufs: add device reset history for
 vendor implementations
Thread-Index: AQHVwwrtbgxYZ1BTsUeVCsCQhJSvJKfoalYg
Date:   Mon, 13 Jan 2020 10:03:22 +0000
Message-ID: <BN7PR08MB5684CFC165190AD061E6B2F6DB350@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
 <1578147968-30938-3-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1578147968-30938-3-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLWVhZTliNTFiLTM1ZWItMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFxlYWU5YjUxZC0zNWViLTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjI3MCIgdD0iMTMyMjMzODMzOTczMjI1ODc3IiBoPSJ1SUVjdVdZRjVuYVExTEV5QjhxeVFQSWQyb2M9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3138d018-b889-40d8-346e-08d7980fd2d8
x-ms-traffictypediagnostic: BN7PR08MB4292:|BN7PR08MB4292:|BN7PR08MB4292:
x-microsoft-antispam-prvs: <BN7PR08MB4292672A3451055464B887BBDB350@BN7PR08MB4292.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(136003)(39860400002)(346002)(189003)(199004)(8936002)(86362001)(7696005)(186003)(54906003)(110136005)(558084003)(71200400001)(66946007)(66476007)(66556008)(26005)(64756008)(6506007)(52536014)(66446008)(5660300002)(76116006)(2906002)(4326008)(33656002)(7416002)(316002)(478600001)(55016002)(9686003)(81166006)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB4292;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6SU9qk4S8oUNKVDZRuW+KAYgnotAsvrPdQZymBT1USlg+JpIIu0d0CE6bpIDpvTvPlsDhsohZdAAWwtRFYfG3n06LhvYLgXgpis5LpJMxAiMqDH9b1WoarL6uF+bJB8wnQ4LKi6cTjOObbWKwAFtRj5roukbditC8Cm8OPXRboKHvmNIDVAgu9tGVpLPDT8eOSQyJ7IwiSEDVZzpOO+5DW4WFfEMapE5mjBhim+4nnYu56y4xUwb6AIPHGOOzp5AvKDLClNuFV1Je4RVCxKejokfkKrFTSfIkOr3CpY1cLMFN5zhgfEd9FxGFO8a0pcuG/Sqtc+eSpd5Sdb+xHcaUDqeASQmR7UtEGQ6e29URRXOctr/vFp3Yv1CyeBfQ+Sym+57gGum5fafK4nAktikRnzep2STx4sRF096F3/ZPiadZ/p4RV0P7lOvq1+mcltv
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3138d018-b889-40d8-346e-08d7980fd2d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 10:03:22.3983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4Yfj9WMbNpM5mm0Ovj5bP9OCdPYlr3Uw1LdmzDixBmHejEJlKlnZKLAxkFERsDAJZVCFooATTpWzyU2a39+Emw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB4292
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As for me, no further question about this patch.

> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
