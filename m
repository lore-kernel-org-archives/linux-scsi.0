Return-Path: <SRS0=lUfO=A6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E095C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 07:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75E8F207FC
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jul 2020 07:27:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="aK7u3r5b";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JEZ6JWkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgGSH1T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 03:27:19 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38964 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgGSH1T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 03:27:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1595143638; x=1626679638;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RmKitqVTx2MR8ZaomLxJkzbH9AeadVSYy6yq7cO+TzI=;
  b=aK7u3r5b7wlGgVtm3eKB/ZB/9d2LqpOtUCHOkQwYrrFQG16GduvWj6BC
   +lHGFJzZbiZie3hDKe7pL1t5v7lK8w74IKRJmOirF63YKBfdSOgdxdlGB
   uw/iIM4p7jLP5bpjDTkAg5Oew4AiE6Sd7G/5ZUsM+yP9NWWEaoqvGJNkf
   NudI8hkP+iQTknd8rBS3YckYcwRi25jfPm8mQ8euE4sn5JLzKxtH11BSi
   8zM1obtJHkBxnh7N4zdz2mVU66WryF4ptOkf5LMF4YOzxx6r9DTOvXtuU
   2443FYQX0i1pmycIwAw9G5fEN6/moG+rph4FbCIDSJHWFM+5CH0YO1PJ6
   g==;
IronPort-SDR: nfRImBJLVnrUjgwmVENiOQ3J9QFBGIIweibnnMtPebBqIqxeQCARg2ZpaRbgSYY5KNV8gWaO9r
 dx5jcD7ytDTpSfFe1l+QkbXPc32lOH50XR0rUcMYXUuCZBEfrc9jXjlxFVJIHBbwXAFAwqtyVX
 rpabGEnpioK94c/hhrpEQeh7J0ETjGr1yvQWL3jEDXu/h9DVeLcrOGBLdFdLgkYLKFiOfQuy1H
 iHuFFDGYEicaBv+6x0hscgetJB1rY0axzkb9t7XAhqAs/LcV0hH2De3eWEMKnwGTmaDlGlXOPE
 Sw4=
X-IronPort-AV: E=Sophos;i="5.75,370,1589212800"; 
   d="scan'208";a="252097266"
Received: from mail-dm6nam12lp2174.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.174])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jul 2020 15:27:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSEUwMdXfOAjD5+koiULZl20XpJLOUXj2jOT0Znh5n4wXrpQeSfiEqvwuSHsn2hJogtybDcwa0pUEarJFnqttyyGexN0DEhV99bEifP0IReizGUDFpMitMDwAFmS/siO+rxJDadGbo+Z4+h+X0QBADZTmJoFBoXs0ggtGOdi51NoBadO9gVvQvJxrrnFMMYg7jShincVL9xOETDqc7PebfdL7EhUwIn6s3ExYwkKP7afpOJmthsMmvpAo281aoldQMhqbrHWuOLOyJgtm137P4vv6bhFTp8S/ww5yA4NwSV9jiW+W8J68EkSij5d3XHsq0bpmUctreddPtIUsH+law==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RmKitqVTx2MR8ZaomLxJkzbH9AeadVSYy6yq7cO+TzI=;
 b=NMLfU4sy6DnswwaKdKF5KKPI9ex58O6ft+xYE71DdLHsD/0MK7hNGnJ3sEOfxloXnNifP/LZuJB88Y9HSxPhVG92CUKB5ORGexNx0XxS45a3X63RRNLdu+NSQq5OT6SMnQb/1GqacFXLmWYM3KTg7Yr0FcXMH9dr5GrF5+jAoeIEgKInopli9/+a84TbduW0WgYjE4gQUDwdn1IkBq9nCgzsY8M+LtoxykuqN0m0tctPcQj9DHorFOV32kwzdDc4g1lMZibRLLmuUJYgB1SEVjH9cvDxUMBHxJ7EwboyokOhmHzSnt6UtggnhlVcWSsiyZmZnKNMJJ4tKHDHAW1Zhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RmKitqVTx2MR8ZaomLxJkzbH9AeadVSYy6yq7cO+TzI=;
 b=JEZ6JWkf5S0Wr4T6zk/ZwG/jtbfA7cB5XKoKvTc7vxvThPMwovzIKOJJkQQba7R91gF4OWgxto0KYSv/tVlfwF2i/Upnm/WXw/POknNuZykZKSR0B2qztZ4drx5ESFoOq/sRKGU2IKPvQ7bEXlcB4Gt9iLncvTFLPTebKrjcgsQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3838.namprd04.prod.outlook.com (2603:10b6:805:44::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Sun, 19 Jul
 2020 07:27:14 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::1c80:dad0:4a83:2ef2%4]) with mapi id 15.20.3195.023; Sun, 19 Jul 2020
 07:27:14 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 1/4] scsi: ufs: Add checks before setting clk-gating
 states
Thread-Topic: [PATCH v3 1/4] scsi: ufs: Add checks before setting clk-gating
 states
Thread-Index: AQHWXLnHWRh9qzZI+UewR3pmAiHbqKkOgl3g
Date:   Sun, 19 Jul 2020 07:27:13 +0000
Message-ID: <SN6PR04MB464006AE7A2A6D8C57603123FC7A0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1595045585-16402-1-git-send-email-cang@codeaurora.org>
 <1595045585-16402-2-git-send-email-cang@codeaurora.org>
In-Reply-To: <1595045585-16402-2-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 38e04f47-a656-4037-1b28-08d82bb52878
x-ms-traffictypediagnostic: SN6PR04MB3838:
x-microsoft-antispam-prvs: <SN6PR04MB3838C098D5BBAC22865BA2E0FC7A0@SN6PR04MB3838.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0W/kxTXvh/d7wlU/lNw3go6lWA8KFPK9byq+uzM/6w7zOj/cVnh6tz8OYukqxjUK8eDZ80OoaI0+jHD+2OAT5GKQH+MnVxTb14o3fS9xtmIetoJ/8NimsABEBjS/YChz0ybYSFw4PbMyDit+zFFYwlrGq7OyOryEhHFs1JpJA91NeUG0DEUQlD7pvyUgON8tVnYnYzEsAtQMsjTNnB3uESQtR3BN+Yuzd/t550O9Ibph0igHehbpEwcpbTGKWV7RAuv3Qre5uvtDfc/DV2NMoNsLFeuRd6Ddto7XR8m3cyLwbaql7ZAo6mupCOjNSh7DNgjRnLnk/Gz07X9CXmTyNrkXSuHPiujNqq9wss/hBdic6Is/4SZLh5xgavFa7pal
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(64756008)(9686003)(66446008)(66476007)(66946007)(55016002)(66556008)(33656002)(4326008)(83380400001)(2906002)(8936002)(86362001)(8676002)(558084003)(26005)(5660300002)(76116006)(7416002)(7696005)(54906003)(52536014)(478600001)(71200400001)(110136005)(6506007)(316002)(186003)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: UWhjLOFpbd2KPZ1wMBA/f6kcgBVmtXYuixSnJtrTSFcW+8ZqiI4aPKOtGxVLVrKRWK235ufVm0GxCnfpHKJbNOD78Q0q0PeOBbxqBCqTyB4T0m+I0qdG3p1eVB/bGe7PvTC8fhdjXUmxHOeB4xi3IUkU2PG+2TUccGqj9nKn+djzdcbX88d7dIYDmyeOl47K0QMzQRPip2ui9xRWcTkFoyeijQJKws7bhCjQCTSHS9ndai3ICxDxAhkGLIUvp6LGCk15bl48flvDRYoJLv1vdtgELe4RuiTEayHbevEulN7oKuXrrJ6SiDP7poBBRu8p0+5hwI6vskoKqf1jSU84X8wRx7lGXsCqQYCYpkw9gw/EAEdaHpjCAeRwpDhz6FeqYDOC6Yh4pRhJOsggmDPsbwi33rK6ud2jtBtzfiSv15zRiLjVmo1PE0k7+a93etYh5fMmTlcRwY2KGnsOh9ofMTCJKADqfw7/kbiQ9+UP26tH4/nixWTbvdB3mRixuBcZ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e04f47-a656-4037-1b28-08d82bb52878
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2020 07:27:13.9031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFypT8cZ8d+EYw7BKCaMPoVra8ftMh1mGwxb8onvY2ksji0gs+W7egHLMCY0NNXgdy/TOMC9bzEIRBQNGa+XNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3838
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Clock gating features can be turned on/off selectively which means its
> state information is only important if it is enabled. This change makes
> sure that we only look at state of clk-gating if it is enabled.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
