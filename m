Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B0AFC33C9A
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 227F220661
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 10:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="QNy8tJQU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgAMKFo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 05:05:44 -0500
Received: from mail-bn7nam10on2076.outbound.protection.outlook.com ([40.107.92.76]:6153
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725978AbgAMKFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 05:05:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zxd7HXxP7nSlakC/UDzkBuHn2cCvM0WHzbd54/FMobu048xPsqw6INDGBF5XKUJ+F2mfX9mnxCJe9Pf2YGFkLCvT5gpxrdc8YjQr7tE/ubduGyL3HRT+LmMnl+oHVP0RTglvXPz+a9JNy4t003MYvft9sctQNYsS4LNp9Lch/nzdfFSBuktOPKTnnoXgdZxSBu52Wt9W671v+jlm9CssONv3pB01pWc+jjbCvlMfldhabRfVIK+eV2aidW1RIVlTRTlFBnEkVrSUkO0gK+fgvh0gIqlN5ec15D0wrWNzU6iXToJrNNuvgwTqtCSXeBmVJbB5xxQibkXhIVP0v4mnDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=WTmfrLy16QlG3eWEryMR4RVvqhsW+PSZ3oTZBpPG1k0L0JhFLSiPVwrmkE+jfS6LESPsdNi/c/agjeSeLimXOPAldOywzLzORsfFqgkXTvocndglk4D/sgVc6P3KNcNB1c6GqGk83M+1CmofwloRpm12rVddFouBIXNVNBcUbJIv5c9tbEx7qimx3bGBl3IivgMy/gGBSnY3vNkT0+bca0mQFTYj1LfXKmatBO5ebjZS96qjIMyulWproBJpMXwguIdaensXJDJCaIe+lvGeYLPENTIXC+LQEjqZlehE2J4nFzSd6XrN+SDeyXsmq6wIyTnHLmKebnxsSPXmPA30gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1Ebke6eveyxao7m6TM2J+k5u29xj8tTIql2r8ll4bY=;
 b=QNy8tJQU9UmXqIMlca4hV9kgbgY1zkL51cnZDiuMPL2/QW8GLG5sqT/XQmvnBqbQ95XxHQFLZRQxyrlqVyc9ul2mgLZA3syl913Lp3sTUpDhSy8G1KBcNBzGAiEWRo7qkSb0f5Ed8fkFe099zXM/ACnpCzulqieCjrbq1aDINWo=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (20.176.179.87) by
 BN7PR08MB3987.namprd08.prod.outlook.com (52.132.219.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Mon, 13 Jan 2020 10:05:42 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::981f:90d7:d45f:fd11%7]) with mapi id 15.20.2623.015; Mon, 13 Jan 2020
 10:05:42 +0000
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
Subject: RE: [EXT] [PATCH v1 3/3] scsi: ufs: remove "errors" word in
 ufshcd_print_err_hist()
Thread-Topic: [EXT] [PATCH v1 3/3] scsi: ufs: remove "errors" word in
 ufshcd_print_err_hist()
Thread-Index: AQHVwwrtV1OULJKwiEi+1cpvXR6BU6foa4ZQ
Date:   Mon, 13 Jan 2020 10:05:42 +0000
Message-ID: <BN7PR08MB5684F59B198544C9A470A96DDB350@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
 <1578147968-30938-4-git-send-email-stanley.chu@mediatek.com>
In-Reply-To: <1578147968-30938-4-git-send-email-stanley.chu@mediatek.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTNmNWQ3MDU5LTM1ZWMtMTFlYS04Yjg4LWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwzZjVkNzA1Yi0zNWVjLTExZWEtOGI4OC1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjIxNCIgdD0iMTMyMjMzODM1MzkwMDIwNTUwIiBoPSJQSGkrc2lPMWJOQWIyQkhyZlNwVUhWc0Q2QnM9IiBpZD0iIiBibD0iMCIgYm89IjEiLz48L21ldGE+
x-dg-rorf: true
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=beanhuo@micron.com; 
x-originating-ip: [195.89.176.137]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 533dce1e-65aa-433a-18b8-08d798102650
x-ms-traffictypediagnostic: BN7PR08MB3987:|BN7PR08MB3987:|BN7PR08MB3987:
x-microsoft-antispam-prvs: <BN7PR08MB3987F31F81FE0A46075A5335DB350@BN7PR08MB3987.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:400;
x-forefront-prvs: 028166BF91
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(366004)(376002)(136003)(189003)(199004)(81166006)(8676002)(54906003)(316002)(66446008)(64756008)(66556008)(66476007)(9686003)(81156014)(86362001)(2906002)(66946007)(478600001)(110136005)(8936002)(55016002)(76116006)(33656002)(26005)(186003)(5660300002)(7696005)(7416002)(6506007)(52536014)(4326008)(558084003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN7PR08MB3987;H:BN7PR08MB5684.namprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: micron.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jESaNOGIXWyRXRT1VnG//c/2lG4fE9kKVhXNjHPmtVUaSQIETTA4sVs3AgZkBDzv3/Mt2/wLza0OaDfksek40mVEbUy1Gc0lulQfzruEf/iGd7cn0oztGarniHlDzi9JYmJ0kLUJQVt0bvAsJVXqWbZAv0+nSoJf0T60yZVFl6rve4eAfoRggEuglOYa1QJkQA1MtfrIPxDMdYOnhUMXsdjC5L/thkm7OAHYyifiPXolICvnGyyLXh+hVymR/yC2ZPEpifWf1L71DjIu44Su1aFEuUAdKYxTyTk/YlfFTT8ICs4ZbCUlmVQm5putc2WW+UHV9CDmc7ZgzDNrU34u7mZZXw1vLMlT8ugfZASCtfUgh8nwcvvashItp8qeHTYIB79VQIOidsz9Gh6Wg0h/Jb+w9zKelJ9JxNrSjXsp+crKbth+L3xGVT5M3wnBRd6d
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 533dce1e-65aa-433a-18b8-08d798102650
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2020 10:05:42.4354
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 85YbZ5ks6XsxvyHABZcaJilnOrhncsfmYYog76WgLeAm3GfWdHK21uqhTqHNFIA0jsh4PSKh+6GZciCjVuta1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB3987
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
