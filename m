Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFDC7C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC9DB206D5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 07:37:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="bKn7b/+u";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="uz4R76NS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgEHHg7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 03:36:59 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:30040 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgEHHg6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 03:36:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588923417; x=1620459417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fZn8HD7caSXnzHsB7/Vyz7JIs8xj44L2oGhRrD9AMBE=;
  b=bKn7b/+ujdDGBO9ZHL8P0dZtlZNlOQ75MMcfE4RRrXnVE9dVkKQ47e5G
   rbhA9v071cKvOmgKcojAEBCDplJ2QTz4Hp9V7J3wvNmOMhoYDwN1zlWtH
   ECfaImRR2NtGSHPR272EhZjgjLc/1Ov65jsfSatMPq30BP6kJD48+MJzt
   fDgTjhhgmkkcVKKnM9ExOa5lVrItpp8GRaeiY5oQQWTS1uHqAKqFERY8Y
   llAH/9rtoAUieZgBAV0c3To524NxCpfRB0X1O5qA628w7i/MiplQu5blK
   bgKnNcvkTnio+hEqPBzWD8QjSQGPtFbZTsIySZ0QqrxbJsV4mtfwPjFdb
   A==;
IronPort-SDR: nks4wXpSt695a8uiXXG4jVEmP9lncoB4mSecPJB+m3Ux6mn5EZLoDXhp9IUZTgPRQMILpE+fdM
 gOuo60+rAMrpagwT6PMvOeH5oqag29aVJO5mKNy5OgH5e+rrXT+SgrsyTJBFzwd3tK9h7/LeKZ
 DAmd3u0k2dy+gNfxzK8VuuvimqaneJMxjfM2sRzAaVHUrocdFh14GyFHzln8o71r7dszBYUNPf
 bTV4dTcAv5V+CGP+LKEtFRTaJqN1FZtybKtHHc8RxNsLYAmL/IK+v41tIDFFx7oGtU+a3fQ5xe
 z8w=
X-IronPort-AV: E=Sophos;i="5.73,366,1583164800"; 
   d="scan'208";a="246093460"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 08 May 2020 15:36:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXjDwfhzu2axdvl8vw/JaejLSy1DGtomiRUECFNsz/ORtwW0wfhO5vylI4fpJM7r/LjAJ+8CFQmrDiXgEAF9XbqEqERq9C8VDc5tpWTW6qwww4tKsUbKUoKLXexYBYGRx4GIMcph9Vk9nsrJC6fFE5MmTGzedEk4NQL9PHcXhl57o2Bvpa5j8r5kPndQx0D+16diljziuxe13FT7KbU/YsQarT33R76hxSdORv2m5nCeC1hxhkWEGBEQZwe+SrdlfHHKAv08p1RF0MSPOCkuWYH50+J0eKrIB6uWA+tcnPFCxkVcxZ+55+2SZC5b/c+ieWNh9TvbUBTIR8rDyHHKNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZn8HD7caSXnzHsB7/Vyz7JIs8xj44L2oGhRrD9AMBE=;
 b=FqQ4aTTrhv5/bW+O4DoZghBT57uj39q/kWMVFepW4/TvCJkM+j0+hs+vMOstgyBypzoS6I7f/+oFPC5XuQtTZPlBzDGiAsKrQ1btUkvWzPXmrGvyBo6MFBMeYvuTzFGRfVD5b8eJNCFWV838t7lIR1omIDo8dL22CXdoOgoEi4zyLdeQn7gnBdNJtEI2PW3Lm4g5AZ6IhIkUnFynDyY+g8hsLK8vwt9t9Wa51N9SmxWRiCmQv2gLn1z9roM1krKutf6vRuWMoWhWNADj+cbei8NNafv7Zy9R4eB4DSwaOkodaNDvcRq6UBpSlswZc+5FjXwZDXWVXJdf/TXlJHRgyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fZn8HD7caSXnzHsB7/Vyz7JIs8xj44L2oGhRrD9AMBE=;
 b=uz4R76NSRDGEkNJnwjzUzzKu0UNWsnRr3075ECXTe/4aJIM6tXYcGbB8LACBd9pHJCeVUKDS2MZnqqTxKQ06wybcd2oECCLAXG94BjlVjBG7sUoagI5Jf8GzBXIIxeXmrul/PGpNou1I5LJKc/zyl7q14lI8w58yyRm/PAOgubg=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4845.namprd04.prod.outlook.com (2603:10b6:805:b3::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.28; Fri, 8 May
 2020 07:36:55 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.2958.032; Fri, 8 May 2020
 07:36:55 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "beanhuo@micron.com" <beanhuo@micron.com>,
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
Subject: RE: [PATCH v7 2/8] scsi: ufs: introduce fixup_dev_quirks vops
Thread-Topic: [PATCH v7 2/8] scsi: ufs: introduce fixup_dev_quirks vops
Thread-Index: AQHWJN9vyvDUN/l65E2Sf7Nqh6cQFqidzPQQ
Date:   Fri, 8 May 2020 07:36:54 +0000
Message-ID: <SN6PR04MB4640B34E49351EFAB5C185D1FCA20@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200508022141.10783-1-stanley.chu@mediatek.com>
 <20200508022141.10783-3-stanley.chu@mediatek.com>
In-Reply-To: <20200508022141.10783-3-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ecf238c-d5d2-4f6d-8ca4-08d7f322950b
x-ms-traffictypediagnostic: SN6PR04MB4845:
x-microsoft-antispam-prvs: <SN6PR04MB484543091461459139AD376DFCA20@SN6PR04MB4845.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 039735BC4E
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gcejRt62uzJ9mz2l3g+o5+HKxiTK4ZeuHnLoWFDmCDnigZ1sPDY61LSwyl1QaiT85QaASJHyipGDY8HRFneYuyow9cS4LBXDzX8QsmFLYOTf3RbD6HDZlMbgXniBh4f2gIONqrwYUZOml6AgYqd4dSxjJGSxkMxCL3n/5t3Q5xjFmRdkFzl5JIZ2WN9mwjQuRPJKJuetwxMBzGMvbxRH/6TCwKNUQpC2dNOV94QdiixPCd+X5Eu70BIDxKzTRziuvuKmQRt+27+Jh2/+lup2aU1e7LK01w9xyE1b/0zwh47IfTyEyZHXc8V/56P+Jr6ZEMW9u+PoBj8CN0A8MSR+3PDU+v3MON4U0u/jpuQmwQ5LjxDggyYCkGrGN3ftpuzx5uRZfjZ2YQivYwv3OGkqP486KA3XS/8JdIMihjtDU5HeakNn4A7yJrFtL696I97hHYnmdBE7EBDBqAnFL1o1RHPnXZfktVoaYaXIaf8R43AfFswNpjbp6yTVRI9dS/+MM8a+vZJdKqhChueRR6HZEw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(33430700001)(54906003)(66556008)(7416002)(316002)(478600001)(76116006)(66946007)(7696005)(5660300002)(33440700001)(83300400001)(186003)(8936002)(83280400001)(83310400001)(83320400001)(83290400001)(8676002)(86362001)(66476007)(66446008)(26005)(71200400001)(4744005)(33656002)(55016002)(52536014)(9686003)(64756008)(4326008)(6506007)(110136005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iOaSTzk0Zd6GrpxKYh+Z+g0/IcXVEF/aFR+zHD2fDuAgQ8mPbhfcIgRvY+VbsgIHdjKwHL0BZ4b/i2pyzBjDv6RkX4AYGXrUekeparK++QwYjcWDjj+o+1P0C8i9JpNNPXG94tUGFOO1XRf2VdO5GE2DNtawnyf9qrspln7Fw4H9bIpeB5GtyiTn31dKiXhS6ztSNt/yeRhBKhO+3mLAFCUFOI7T/DuxpbSyS0gWMMhIILqXvsiB/O5tSFj7OVxPAfOhL2NInwDsHAT5ryE2EJexwSI8FiwoCkYKhP+lhRyMeItEPD68qpLNr8+JEe2xRBKPo+S8unVTJUtzXMyEa/RWb1atI28ofq7CeEY1OgvDhzEjF2zRerP11CQb1nCgD7c3YEBaDyRkydUW5L/5LX42kPsMntxnU/PiGBCWInhvkDc+2bPp7wMeMUOAQC17l+/466giqr6G4aAz91a6d59jI4ptrWCzX2DhX7fb/Rk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ecf238c-d5d2-4f6d-8ca4-08d7f322950b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2020 07:36:54.9785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: scPdgvA3KVB3SV5BN1Ss+hqttwFthH5BAKp9Zg/J9PzHPO6ZUdSC7EY/ceiNw2RPOm9GnnlFsHJWbSr4n59GqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4845
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Some UFS deivces may have required device quirks or have non-standard
> features which are enabled only on specified UFS hosts or for special
> customers.
>=20
> To not "pollute" common device quirk list, i.e., ufs_fixups table for
> those devices mentioned above, introduce "fixup_dev_quirks" vops to
> allow vendors to fix or modify device quirks accordingly.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
