Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B03EC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 12:47:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5214F248EC
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 12:47:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="RZ5cUXvU";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="e7FNgDhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgFUMrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 08:47:17 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:11830 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730000AbgFUMrQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Jun 2020 08:47:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592743636; x=1624279636;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hVJPwHv5taRQoZ9kyLLMMi8ZYwsaHLTJjovM/viMohQ=;
  b=RZ5cUXvUBot3AGGlXHJdGMQLRLVLPAYSCtNpt0uagGgVOYZ2U+3nuNms
   Fid1QF9tQSyyO67JSwQsv8VjTRJeiRDDByHlEzMLJTqJsZA/jxpJtNUPb
   3UJxQ/sFwEZTACAalC4qHg0WZtTeyZbHuyhrD4AlNoukZkZP0/xTzUBP1
   u/xNK+0hh1PrW8o1fjGclqdoNb6CqIAziQXUACOz4OBxF4vP6MuXJVXp+
   9m6w6dxXvQJtwtrTWkvrR40uwaxhq+Ig8yud3BMl+j1qbWeHTc4sTF4uB
   oSIaMIc6kdrrzPSB2794drKhmzruPZV1Pd6TNyn+ICaKIWzlAHNP6QJIu
   Q==;
IronPort-SDR: g8muksEa1A/gyEJLHoZuAOtikSEPwxAS+FWqG97FYQsLn4GiGbGqIQFXOZ6oMpgHp22ZUfUqKg
 R82Pn9cMIOyzHLbqcGKidQa56mYAUTrOjt1IrFFd+b94k8GeleaJBniYgc1IIrW7zEFxT7G6X4
 bs96CKVRADIWiyAPWkSZXdVyrkVvZcz4bIQJmGWgMEEqbkJqQlpzCkgHVR+Db6ikWAGon6TqeC
 3rM/0CjqxsKjUIQVGjB1SetO2PEABu9wSSRauanqCoahnE8t4n8+3Ji4XdLRP6isYiFuGLv04F
 Te8=
X-IronPort-AV: E=Sophos;i="5.75,263,1589212800"; 
   d="scan'208";a="249743209"
Received: from mail-bl2nam02lp2058.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.58])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jun 2020 20:47:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=asBB7bfIEMktzs8s+ocfGtfCeNFi+ePvHEJ0snKln7CSCXQOVNSTEiqWoR6QFZq7a8PWBFTvdW/Ok/W2aN7X9b5mJLOHxoOPPP2EMF0UIP/NApHGlmiCafyjc1DB3ANp87usoyn0a6B0d0d2iAvPAe36Up3qs1d0whfZN+GrHSYBVclaQQOIVrWuRHRuTyi//OMyvwSNzaJL5L+ZRmNuxaMeAB3/QRCZRRf2IOKmkiQNPk5E++7QHoeBvxI/iZ19V/nKjBwwTMBcqW0+GOVCChgaUSg1vqNXByNavxrIRb0lizniWqnVQXwWZtyIXkCNro3oxyqkPhzvV9xUmTVd0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjQniCATfE50IMVlW+Y7gOcPanzJolOne2ozkwhyzYk=;
 b=SYDxlgd5+kkXwlEz3yFHp4rw7hZsWcGGOzzWzAcVnkSbU8sEEylkT8AKa8fcoSnsRFZJfjSiqvUMezy67NM51uwk4XHP9964ghJCVebpgnpI/zhre4kZ6PhmU5307gR/QuS99DPSNDSCyqG/RngUpEpVcHD/ttj4/YCHA0+lB5ywZqZigLhHgo7FMxaQr8UDSPnQb7kvseqw7C7eboh/2mOlWywMsldRW/VrYbAEbjQlEVTbXXvkitS4qQPQT+nbzgnExnus2oYVUDoSk3DaCiM1b4C5atO1TtYP16BdLEd29ENlXXa1nUUmkuiuuglzd1n/MiIRPof8XPx7ZSRJIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjQniCATfE50IMVlW+Y7gOcPanzJolOne2ozkwhyzYk=;
 b=e7FNgDhXaTjpapRtGbTZpyh5jsE4/ejBqgEdNXy/gX50AQ8ddNDuIyT9qxGsIA/DGxmvMRdc3IP6ZpzlDfsz8cIW2QU9OwrVo4AoIa5lPZ6VLgp5IqrJPew75ao6nWhDOxIPEBroKpwLeqx6r0p/5HZ3istKIcFx4LiBp7QKnbE=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4815.namprd04.prod.outlook.com (2603:10b6:805:b2::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sun, 21 Jun
 2020 12:47:11 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::9cbe:995f:c25f:d288%6]) with mapi id 15.20.3109.026; Sun, 21 Jun 2020
 12:47:11 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Satya Tangirala <satyat@google.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: RE: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Topic: [PATCH v2 0/3] Inline Encryption support for UFS
Thread-Index: AQHWRrYXnkxifjeS80qrV/YqWlM3YqjjAQoAgAAFApA=
Date:   Sun, 21 Jun 2020 12:47:11 +0000
Message-ID: <SN6PR04MB46406FA71CAB5FC92E6DC744FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200618024736.97207-1-satyat@google.com>
 <yq1a70yh1f3.fsf@ca-mkp.ca.oracle.com>
 <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
In-Reply-To: <SN6PR04MB4640005BEC3EE690CB904298FC960@SN6PR04MB4640.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0e6db222-7f71-4e14-d76e-08d815e1378f
x-ms-traffictypediagnostic: SN6PR04MB4815:
x-microsoft-antispam-prvs: <SN6PR04MB48156A9E0132C9DE1B66699BFC960@SN6PR04MB4815.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04410E544A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GdttFP0qg+uxTyRqiYfmsn08e/35rye6oQL6ciK0inggkX+1yXfcVQS4pGOKW7NiRZMNrYfYaYaYMexYj88kyo1cZdQ3+ZYrQSucUA20uaPYHzR+lp+uxQKhYCwiqWRNWIBwqHmis3IIYbS2arSYTt/uKFm7hCrfEeWfHREevAA+h2vVUaVBVNu2NVGQVgPloiQc3vDD9C3FkkU1agHrBe2PvKWvTt9URDw4cAVTWzv/mrTDkDJG2/xCSSye0zQvtf66R4x550vqVSwMPCIrU77+DzaN2if9hIHXV4xthqjHN+MOUd6ceTa2+XZmCh3ykps5s7Jb6ZAGIMgAi2znTy9cD11CaT2PsJ5s4iTi66RjhG0fX/E4Ya0dywNDU8qnH6pwDKqP/o6dgGYyHimlqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39850400004)(376002)(366004)(346002)(2906002)(9686003)(55016002)(33656002)(71200400001)(5660300002)(7696005)(26005)(66446008)(66476007)(186003)(66556008)(86362001)(6506007)(76116006)(8936002)(66946007)(83380400001)(64756008)(4744005)(4326008)(966005)(478600001)(2940100002)(52536014)(8676002)(54906003)(316002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: W9kaNInIve9fIrWi29TBIDVm1qN1UOLkQtoXx7reqh1dYPdhvJKjjbuptAvkQAxKrWG2Xfn5t9FaM+vfFLAqK9lYAnM56abi3pACTA5zWZYjnKqOfxRFbBoP3WALxMZPGMMK3zAZLJxTjN1BLyjyBgRjtLrjSSCWM36Z/LVEBqsEQUX8GuzVjlOS5tIktfG7JPIBKACUnBgt4cZtjQ5slQIuJ+oK/mnj2MJwdM4bgQfuXtD13dcZUYM4+g5QALdluAGAciFppc+kxCtkAXjM63roTYdyseownxFVewltS6Ec4zAmlzJUgortPN4H/yO35AUxihrEkYIefF9lCoUxFwTMoNdxNByQNceH6TSW4FJanXs1yW0TI76PdTnUfWHjAxNImni1TY6PEtIAO5vBWbTfDYYGw4SAwQCfYQMIgUa+gznfimb5mEKPVAckr8JtYrfARXtyPRkbr5Tc74+16+l5aiYQovNAmcylzkdYGVY7ZsU6rd1pmv/CA11iHm28
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e6db222-7f71-4e14-d76e-08d815e1378f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2020 12:47:11.5014
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sp1aE2iw4cPc9lCaN6gqmV/qX6hKqFAJfY6H+ECuzZG8s5i9Tslx8J2a5G8kjdy2GpWqrmJ+1otDm+0HqsEGAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4815
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> +Alim & Asutosh
>=20
> Hi Satya,
>=20
> >
> > Avri,
> >
> > > This patch series adds support for inline encryption to UFS using
> > > the inline encryption support in the block layer. It follows the JEDE=
C
> > > UFSHCI v2.1 specification, which defines inline encryption for UFS.
> >
> > I'd appreciate it if you could review this series.
> >
> > Thanks!
> >
> > --
> > Martin K. Petersen      Oracle Linux Engineering
> A quick question and a comment:
>=20
> Does the IE infrastructure that you've added to the block layer invented =
for
> ufs?
And how this infrastructure relates to Eric's RFC: Inline crypto support on=
 DragonBoard 845c
https://www.spinics.net/lists/linux-scsi/msg141472.html=20

> Do you see other devices using it in the future?
>=20
> Today, chipset vendors are using a different scheme for their IE.
> Need their ack before reviewing your patches.
>=20
> Thanks,
> Avri
