Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE653C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:47:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CEC8207D3
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 13:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VnTnBkTX";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="B17JlYDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390532AbgE1Nrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 09:47:43 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23382 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390486AbgE1Nrh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2020 09:47:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590673657; x=1622209657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a2dKwKSp2nvqnU/xSdkeaPAx2EPhXhQdIfJ1ORWb/RA=;
  b=VnTnBkTXBYRZcohPRMZp4ZUZob1+JYmSZIpEmV1ve6uOsemh1i5m6gQg
   VKLOc49BQR7EZhXV85LKXbPjctRHz4nckYDhV1DTi0chtrzhmqe/hQgs/
   QmJq4nv7nEEmA53Wr/5CgFi4GdjgeJU7riWwFqbr+ZCnU02MMnzT0xd0p
   R1q007Z9Mh5UITKitjaIsCAvLBLINhII9LGNBQrv4KOScCb7jmRZ+rE/A
   JwKJscZYwiktcrzrMxUSpM772tPz74eQIhJlcq8inSJeFF64oydCmOVS9
   8eefBC+u1Bhntr0CrCbdJeMGI6TG+Rl59bl+GEsqjOccHbykXxZX8mHYQ
   A==;
IronPort-SDR: Edq8CogIJO5DCcucRUAUI4f4FjTg2Y9lsvQJ3fuqac5Mo0Ex+qCXhnhSWYhX/ZwQUBDoxBL0gB
 EmvWpn24FPqWEVlcAYk32eUn7vOji+u6xqf1+2FGp0NLNdFhdPhCEFTIlYsYaGr7+klbsnt1K1
 EH44eZP8Y/NdoWL8XYhAwRgqX5xfOJ0zY/Koyb2ykuYtf/CiYWVPE8Ulw8cP7pLLKX/213IXa+
 7YleySCDxIv++K4JW7OPt7ALrSnUM2oRVKzo5fPaC7NAktvBQCDQGdkwMvpncNm+UXKI2NSUQ6
 BsY=
X-IronPort-AV: E=Sophos;i="5.73,444,1583164800"; 
   d="scan'208";a="140133685"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 28 May 2020 21:47:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gIREWy7Qz2Z9UPTA2xHMnCrdmZNdp9f+OP2CsbVils27FCd/9YpDpE2iljOrwigv1MeiVuhdEXhju6AnQXWIETdfWpmnzUahMu1umM+IUxCjneGGZryUPAztxJ8IuvjE+4IzzWXX8AOH5/VCP49YHVAVGD8cA28zvJgqdHbIoWyFkpLItBGYdj9+Zh1YeLs36iEjTaAsh0S+gCKqSVoXIurI7g51co7IPc5AtSoSFNtB7T6Ep6EuMWLNkXGPEFb7n7qrL0eWzxAWLh7EVoQ7XVorXLVCOzkjSLPuzqGv4roVgFdojtTPLvCzoQvQby39Nt9Fn3CxgkLpRdto3bsxbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2dKwKSp2nvqnU/xSdkeaPAx2EPhXhQdIfJ1ORWb/RA=;
 b=LuNzGj1olonMo6MlLqqL97q8Jamq6POvQc8gsrhpME1GTrYe0lqkPsSlZ8jYpRlf/at04Pk14eNzxe897VdI4sSk9WjpxV2932nopXYmHFBlrJ9aj1D586M04Un3vbKeOQ3QahfohjEk/RQPwzvmBO601kf30DoHQycOnAqUcb5V5dcVAxV5GkfV2lOZYpQ412gLA9Qm4lIts2us62/WiSsWtuP/0xxTNY1x/avjyl+Ydf3Yk6+/2O2L/LdvQK+aT3Zo1LLTjWuRw0K2W721nfNGnbTWnZlpPe4o9yY80mjIushIGGPurk+DHFROOd8jU7xNkjHxWPnHiZ7/3V5QeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a2dKwKSp2nvqnU/xSdkeaPAx2EPhXhQdIfJ1ORWb/RA=;
 b=B17JlYDHDH2N3VMc0vfhD7ue4TSUcL2oUkbGZScPeEsELGCJz97KLQUsEJFEJuXKi5Xikr83PaAPEC7VRiUcJsfJKLmPElnihRo3ePQUNDkGRdwHCJVEg2r5XylBfzAorsSHhyV1CxbMzTeOnr/wsnOS2w52QXq0LjNp2CmtEW0=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB3933.namprd04.prod.outlook.com (2603:10b6:805:4b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Thu, 28 May
 2020 13:47:31 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3045.016; Thu, 28 May 2020
 13:47:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bean Huo <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] scsi: ufs: delete ufshcd_read_desc()
Thread-Topic: [PATCH v2 2/3] scsi: ufs: delete ufshcd_read_desc()
Thread-Index: AQHWNOcRK7it8IKcqEeaGrUGUhHUvqi9gr/w
Date:   Thu, 28 May 2020 13:47:31 +0000
Message-ID: <SN6PR04MB4640DEC77E30DF64A6710A5BFC8E0@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200528115616.9949-1-huobean@gmail.com>
 <20200528115616.9949-3-huobean@gmail.com>
In-Reply-To: <20200528115616.9949-3-huobean@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2a00:a040:188:8f6c:a5cd:360c:eac5:60d4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8665e9d2-5dcd-41cc-b49a-08d8030dab4c
x-ms-traffictypediagnostic: SN6PR04MB3933:
x-microsoft-antispam-prvs: <SN6PR04MB39335B3189AEEEE5571F5895FC8E0@SN6PR04MB3933.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:277;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5Z4EE1vNUdrNweA4UVWQHqbbF4q4Po9K2ESa8txPMAUU08rlZTMXds9KNXOQDYKQChuAjhMRJ6A5WLHqIqTgaGkK0BXFB7B6q2CjXOkmP/f0fJi9xrbb9j2X5C7Yd9OdqUW/YRe4aD0/b44co+tocop8JpD9iqhkUP+/9ECUe2RVHzZbHDuDu+VFALsb4f4w0N/kSckIhZVl+fbtoEU2zZPgJ10Jo2/LXt5SBk4FHQDtDU1qrbiEIItlVuBlHHCr1j+STVk0W0cinD98DJaycZgAXYWs/dF/jNyHqgzh19zln0wuQCGV5TLHDpL/JmFuTUZAWJLLbgQauXNVrsR7FWiRkAPxiUj7d6KWlLBEW3RbU5aw3hrDoHXNv08fFDcE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(6506007)(4326008)(71200400001)(86362001)(316002)(478600001)(55016002)(54906003)(83380400001)(7416002)(9686003)(110136005)(8676002)(186003)(52536014)(66556008)(66446008)(76116006)(66476007)(64756008)(2906002)(66946007)(5660300002)(8936002)(558084003)(33656002)(7696005)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FpJt684Cz5HB8aY+Ocxdh7GSkhu/RKGC3lNhgsyCQM4di43J/MIzHgY/QIbNUpMe9pIA5Vq62A1WscQfZ7MhfJ/btuTA8/6osHy45aF8dtvLo6ZdO5/dMszSYU0bbg6OT7z5PLTFgQUK/u/SlPrrpBeFE/kCC5RpVXFIQ+grbrSjCjmnoCGA+O7CQpslA2y3X7DjvNpezG3F0WFeP0e1bngIU4N2UA6O1Z8NsmPB5TtsIY8DPFWmn+GSsv5qBaMuhuD9Ew+5xJWkS+TNDibetwAVl9M9/manJUTklyXWoHzJfiglj19y/L7lDu43/OodVYa2Xhx9SzHVlRZU3WDVD+ELQuXDDxr7ashdiGzSEylrPDthoQ3lxp/9n2UhYaBrucCSc3svy4lkQyY3r5nmJajcPQarabuHjAhGkhqYq51baL9vRwOQt6ykfATunZCjefvNbI5/ilirY2Cf8Rwj631jjms3FCI2XUQt53DY+qvg4F2O7zB5IkBd/1pnWIeXqVK54Cdz/C93YXmw7YnUTyJA1eaVS1c4DEWnbsv9+4gsrJ4aQJbtt4dKKt3zOt7V
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8665e9d2-5dcd-41cc-b49a-08d8030dab4c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 13:47:31.5075
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mf90VeOBUQA1q7CnW4ItE7ZGXWPP5PnRt2tyG31M2PHR287SjEuR4j8Q+6/nEW2RaH5LHERCpTt8ojEAQSvX1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3933
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> From: Bean Huo <beanhuo@micron.com>
>=20
> Delete ufshcd_read_desc(). Instead, let caller directly call
> ufshcd_read_desc_param().
>=20
> Signed-off-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
