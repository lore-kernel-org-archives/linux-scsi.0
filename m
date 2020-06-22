Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C342C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 07:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FCE425440
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 07:09:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a1+hKNwy";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="IJolNcVe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbgFVHJ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:09:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18934 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731318AbgFVHJ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jun 2020 03:09:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592809796; x=1624345796;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xU4L8omUKnmh/kFDyxQw+vC4ksI1LViS4Np9uwyXJPk=;
  b=a1+hKNwyGBa4vIMbYvhKpfZELroDejNurDO5qe7fTOPmgE/n1JwuiXSW
   AkhrN9nuxE29gnGphnYOzbQUv5delfJXg/HMyLeucJ5+ytYazfIil8MOz
   cNwQxEotYzUitndVuRATUlkWBQ4ptpb08x4jx2ryWDP0vbwPQ3elBrCav
   wM79RNBf51mBXkNRf/KI0vHsSfkMlghRKLb5yTS0yVFIv1El0dFgoQXmp
   PlXHalZcCk1EH/1thf7S81JzGGiiRfNBlajFTAp21J/OK45D2HPcKUVAT
   tVUylemf+mpn6SJE7jo/OCf9nZJn9c5HTFfGzx7z8bbC9mCh36SOCVeWn
   g==;
IronPort-SDR: 3KaCEO5JAthFbPfROAq5sIGCJy2o5gLeHGk3FEIQTfiWgvt6J2GGlZs+aXpmH0ojErYbvEqXL3
 UIt9wYfWlVO4QtIV39Ro1XoUdwCC5CvAuGiyOXSNnMjcox/mE0pOmcsQkRlCtQCgXIzsuaqTs5
 TPoiBsM8BA+MM3WLksJCASg9UHK3rjUc5Etd2E43aS5KU5dI7RAEl1ya8AFlLwe9Mxj41Z8pco
 +ANRte/NYpWKf0N/TCUB3xnyYnmEE7bfhwY2j63EmuYDP+2AbvO6/ehUYL6o1BtIjMJqVc1JdZ
 wJQ=
X-IronPort-AV: E=Sophos;i="5.75,266,1589212800"; 
   d="scan'208";a="141961978"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jun 2020 15:09:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gL+go2CCp0C0ipt3RGCSnIXcpR5c8+TI4Jks+j/OzQFzwZdnkvAZjHOdm/fyQBGkkbI4f8prDPgXqzP+zm8c+PGWq+zd32V+W+Tf2Oqk1j8rYjwN4Kd+C2KL9gFkOR6heyv5l6TcEug3PR22A8nYlgF3HUSQS7eD7LEtHXmaCf716MfYln0ZbbQQpBTDJhFPbnbidjon3dCpYOQ0x8mBHFDB0Wp2qjroAmD+osp7E+GUct7kiqRRIL0EyVpoLZrqcMtRAaoUFbJXslahQT3dVdBZPz7L87ub7Z8FVw79J9QO/o9zdu2bxDq4HSeT5hoLIbNDMnce/pgX2DDwm5fYmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYZ9gNHg4efpliZSXVsYtPbwCcohoS9e0rj7tFlQqF4=;
 b=nVN5kXttPAfHMWEPjCsnrXgFA2Icx7JcDB/BgVAfTs/mZBZoQ28n3UuEs8UD/2IDAR5UImlFqhErAippfEDojNGPDPKrPzrzemiqVWBdTV7zxvdXx38rE8Ncxg6VojNf82hfd5SBnS9Zn0Jcfu+M1T0pSv7bgsggTLTHH59mb2RNBLe/vQFASjd9/NnDAu9B/wslNZh4l1X41xE57lawsQ/KvG9WYN0H7RrdJkQJCDZNtfhBjWC1z4JkKBBveJUFjvrmu5k58ROM903wZ1XYzu+wFmQs1iUhQ3D9wA6dWtzs884p3Yux5cSrWgdqFB5fQMW1E2oCI1nPcpMoTXcGzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uYZ9gNHg4efpliZSXVsYtPbwCcohoS9e0rj7tFlQqF4=;
 b=IJolNcVeCUCMYAFL+reboKaHBkCvIjnq/yShA2eD3UHij31DnbkOMDekAwlCelzeclCq45QsqRQv90blKp5qII8lJc3H1mgHun84pWrbAZspcNv2b6nzQia3GaJsIEx2AsTb/WFmyovGKbAtGys2Mtrl+Kr5riGZQ5Ew6x6wc4Y=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB5199.namprd04.prod.outlook.com (2603:10b6:805:ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 07:09:54 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 07:09:53 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>
CC:     "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Satya Tangirala' <satyat@google.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        'Barani Muthukumaran' <bmuthuku@qti.qualcomm.com>,
        'Kuohong Wang' <kuohong.wang@mediatek.com>,
        'Kim Boojin' <boojin.kim@samsung.com>
Subject: RE: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Topic: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Index: AQHWRrYXnkxifjeS80qrV/YqWlM3YqjjAQoAgABbkACAABnTAIAAw6gw
Date:   Mon, 22 Jun 2020 07:09:53 +0000
Message-ID: <SN6PR04MB46402022A2020B45FEF10BCAFC970@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200618024736.97207-1-satyat@google.com>
 <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
 <CGME20200621123523epcas5p43bf94789149e6a49a4f9c18b10e1ef37@epcas5p4.samsung.com>
 <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
 <000001d647f5$05a494c0$10edbe40$@samsung.com>
 <20200621192656.GC1140@sol.localdomain>
In-Reply-To: <20200621192656.GC1140@sol.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a0a33659-c749-4a3c-cf39-08d8167b434c
x-ms-traffictypediagnostic: SN6PR04MB5199:
x-microsoft-antispam-prvs: <SN6PR04MB51990016999C98FBC05CBE2BFC970@SN6PR04MB5199.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LExPr6IAw5rOWSngTZuX9vDTsdztPmgC4tYD7SvLAJh3DyvW2I25/lpdp3hU2ALsfOtFNhtrnhOJxdir/XlswdefX6An5Vbs+Y4F/V8i1afDxLdkMXgdh9ew79l3bGHR+N8SSj1T9uSRCJ6F6DYyg+nAEreuH7ulxh3GDDv4brFE3jH+Q1GvuY3mZ/CqK2MyL13LtvQMw3kaZCgWI+NUwZVsDO308/N4TkOx6yTCjhqOJGzeHwN3Laee8E5mtGDF1tlJus1Rnp6GHvAu1GBCoGGWdWr/rWP1MecaRCX0NZYvdWwPdN0m8cSLHbVXnZqOC9EcksXGvIsM/kftvZP+PKwSstVRw8b6eM9eNqg3bBuatajcHdh+vbDHVkUEBNMGSeumYGCWlNSB/FF5zCF2ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(110136005)(2906002)(478600001)(316002)(186003)(33656002)(26005)(4326008)(8676002)(5660300002)(8936002)(83380400001)(66446008)(55016002)(64756008)(66556008)(66476007)(71200400001)(66946007)(9686003)(76116006)(6506007)(86362001)(52536014)(54906003)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uTg+QyesbHZgthYjfPPvCxnOq5PD7vOqRGLsaYAhdfqRxywPeMh/rBUwreCEdQlf9zHbXDwt7YRNUG29ySdZl2D2kcqot9seKE1HXBH4GXc9oVXmAbDB98aP69VNE9fVXNCFf3pmCfzXhc3/+2ij50CwnBWk+WKZZCg0taxiZBMVRh5mZXELkSb4RMccjJmvIW+DLC3uIGrhM237ZjrppTtZxqs+M9qVyZ4AQIjg/NYqkKVfYOAalLuDrFF3jIqhnXpk6HARJe+uHuv/qNtpsJDN/5X9B2HbVy59v0RjF1Te1Xj7WhfGnwWEaCkdceO779fVM381XnxzC3BenPHLm3CqaP8MINPy25KiwVpzjFcdBWsqjV59wrqzOjl1jVHPjVeIE5twJ57XFPW9ayGB2ivfviLvsJhPCTh2gHJRH/7vBvDuYB0x1mr8rLZj8DWEZHSFMvgNKSi5eUAU3HL2VN8PSZoA7DsUwbqxFsigZ2Y=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a33659-c749-4a3c-cf39-08d8167b434c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 07:09:53.6692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gSfXrQIXMJjw3HZK2soFxNOIzCtd6sQFJS3JmKd+x30O2b5fkn7XInAliZRurhmG+3loh3ILoNgUZ6m4dIZf4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5199
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > A quick question and a comment:
> > >
> > > Does the IE infrastructure that you've added to the block layer inven=
ted
> > for ufs?
> > > Do you see other devices using it in the future?
> > >
> > > Today, chipset vendors are using a different scheme for their IE.
> > > Need their ack before reviewing your patches.
> > >
> > Yes, as of today at least in Samsung HCI, we use additional HW blocks t=
o
> > handle all the crypto part.
> > (Though I need to check the status on the recent SoCs).
> > However given the fact that UFSHCI 2.1 spec does includes Crypto suppor=
t,
> > and going by threads that you shared, looks  like other
> > Vendors does uses IE. I am inclined toward getting this reviewed.
>=20
> Note that Boojin Kim, who has been Cc'ed on all these patches, has alread=
y
> been
> working on replacing Samsung's legacy inline encryption implementation wi=
th
> one
> using the new framework.
>=20
> Unfortunately, Samsung's UFS inline encryption hardware doesn't follow th=
e
> UFS
> specification, so it needs custom driver code and doesn't take much
> advantage of
> ufshcd-crypto (this patchset).  However, it can still use the blk-crypto
> framework.  So only the driver needs to differ, not the rest of the stora=
ge
> stack.  This differs from the "old world" where every vendor had to custo=
mize
> the entire storage stack to support their inline encryption hardware.
>=20
> Anyway, ufshcd-crypto (this patchset) is still needed for all vendors who=
 did
> mostly/fully follow the UFS specification, e.g. Mediatek
> (https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-
> stanley.chu@mediatek.com)
> and Qualcomm
> (https://lkml.kernel.org/linux-scsi/20200621173713.132879-1-
> ebiggers@kernel.org).
>=20
> More reviews are always appreciated, though note that this patchset has
> already
> been out for review for over a year.  (This is really v15; Satya started =
the
> numbering over after blk-crypto was merged in v5.8-rc1.)  So I'm not sure=
 we
> should count on many more formal reviews.
Ok then.
This works as a practical ack by most of the large chipset vendors.

Thanks,
Avri
