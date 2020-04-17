Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2A87C352BE
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 11:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3413221EC
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 11:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Xw4sYBrK";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Lmxxw0DS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgDQLO7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 07:14:59 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:40391 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730091AbgDQLO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 07:14:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1587122109; x=1618658109;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=uwDTJvQF+ggoZxXhliuBBdeLUlaT0MzSk4RdsQ7roSw=;
  b=Xw4sYBrKzT1iU2wPCMc7FLdqGlV1vfQkbsPNDOyOLlIshhW4KK8HNqfe
   cFvj8/gUUSzPYC+umyhsvysuxRhqBDOqJ6HeRd4kiNf+GadDfcj07YFPE
   xBcobbrrEo2z+sZ65rMhu3cne2WZUMtmu0jYp6KjfqkB2jivT7WUwcPvS
   665HYARw3qHwn5QfS5t0lG7X4KCmrHe/5Po1xD+Y19N1yVSm89n3gDsiV
   x7PLdFEVRPVFZjzBMlaAsGZjRLfDFxvfpILg0AyP4Y5CzReVsdCeJqfdz
   KM42XGBZTRLwdnKJVLqcMiZP47Ck1CprkWOe+h1K/RT2U1smkolHOfSi8
   g==;
IronPort-SDR: rc/HFN0ZDTThghrsf1Vi/CRIdSx9F6GnOBuHEpGAnyghoYf0+G3R46KW+i1Vkow29j2kH/uue7
 uEvB0NIyfV42ovKRm5wPA6+o+xYuyToTP5aSyFuanZCDwvWbm2hzX+iJC22kWvZZx1g1UeJOUs
 MPonszxaH6Dlshqhp7mo5gRv3nLYAhcZytXTPQ9udHgHYS1bo+tJt131GiwriVIM3k+CDCd+Ru
 1lDdnVzb7ABUPyaN4v2dUvvKIV05eXTosg62L9a+RpHr7VgDQ3uNaTg6jFSb76UlBaHlexd/lm
 n9E=
X-IronPort-AV: E=Sophos;i="5.72,394,1580745600"; 
   d="scan'208";a="237986144"
Received: from mail-sn1nam04lp2054.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.54])
  by ob1.hgst.iphmx.com with ESMTP; 17 Apr 2020 19:15:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UeZRcIF/7+81DX65qo1gkl/KFaESYQNlHjQCW1/C3IeEMOoQU7HjaTfiuhpHBfWzZFPQ3m+D8CA8aX6vyTW7sgv8BMEI20KZgnOq/QDsGCTE8b2rhm3uhxMn5dtzqFiUYnBJwt0q/33Wjr8JH2KBykl55CX+Baj0HmVkUgoteobNC6msFy00xT4+5TLJZ9a3do0IElaGPd1i7FL2MIu4pubh0qAGnNy7VbgihRity0FLFnlof+xvHeT6B3C81TKSc0Z+vIkovYDPyHdZGkHQTY8Vgbrzu19AD6OOvZ9yvEvpBlggbuX84lN47ORgSRhtNYvcQSnijvEMZPipDgiHjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gbcRDLUK/CWo+dnZdqMol9+5Qf+EmUyu4JbUzB/MHQ=;
 b=F9EvrBsO5fgJzkEk4mOaGTDeIl00wOPe++hB4apgQ5JC8Qgu8yWtSld/Q/jqo2ZTej2BFiwlTKI2//ZN51StM2YgVEUOWfPCZh4fCKfdB0pnfGPr62+vRB5n3sCNx1ZqU04bZMIgzkweIEaYhAyOr5Y7m7Ea6Ic0JAL7c78roO+/0tBCG8vvfR7selxTNTPKwhIdOc7Ge0KM9kEVt4QaDfwam1kyLs8+7TkVnYtsSagcLRP5mLyXspqjCZUS19ADNweX2jvVhM3PTJ3Wz5wpuxHJMrIF1BXVAZbgo3GSbX1mf1NT1LlacV0YrEQYfKP9beQm1pyPsQzUPICRxKp5Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gbcRDLUK/CWo+dnZdqMol9+5Qf+EmUyu4JbUzB/MHQ=;
 b=Lmxxw0DSPH+kPfTv14SzXH+WmYCXpZobRDm4XSzbX47hXYd/FVH+3764newITtRQusS46TPeD13hpv3qu/TUYxa7/lj8eXV6U5TqBAl+4fIhRN34886X4zYR7zRtO4EueZ8Bcc4YmkwI9vHF3uB6LnJTVtyPbOb4E5pY4mLePlQ=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4447.namprd04.prod.outlook.com (2603:10b6:805:2b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26; Fri, 17 Apr
 2020 11:14:56 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::3877:5e49:6cdd:c8b%5]) with mapi id 15.20.2921.027; Fri, 17 Apr 2020
 11:14:56 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
CC:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Can Guo <cang@codeaurora.org>
Subject: RE: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was off
Thread-Topic: [PATCH v1 1/1] scsi: ufs: full reinit upon resume if link was
 off
Thread-Index: AQHWEfSTyhgt9a0PxkGvKkn0dRVeQKh9Lncw
Date:   Fri, 17 Apr 2020 11:14:55 +0000
Message-ID: <SN6PR04MB4640B897B44048D80E197F90FCD90@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <1585362454-5413-1-git-send-email-cang@codeaurora.org>
 <yq1imi2vra7.fsf@oracle.com>
In-Reply-To: <yq1imi2vra7.fsf@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7773aa92-5311-40eb-be54-08d7e2c08f42
x-ms-traffictypediagnostic: SN6PR04MB4447:
x-microsoft-antispam-prvs: <SN6PR04MB4447DCB49EA489449C3EA522FCD90@SN6PR04MB4447.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0376ECF4DD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(76116006)(66446008)(186003)(66946007)(64756008)(66556008)(4326008)(478600001)(4744005)(66476007)(71200400001)(26005)(52536014)(7416002)(6506007)(81156014)(33656002)(8676002)(8936002)(316002)(110136005)(55016002)(86362001)(54906003)(5660300002)(7696005)(2906002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3tma5WZ08GrrM4v3Fi3GrPvn/TF1Xka2A/ZZvBOeBXofzZJEr5xLw2Y2eXrU6p95jcMcx87oFbWYJXV2PFCOLUkxsuj3ikdCNuR13uZayhsHZ7P4Fa1jfZ9kQERkqMvcVT6ZIzvF4VBiinJQyRbaniCeiGSQsSj5RZ0545Bhg6HsEIhSX5kTPsvSR26SBgCf7XZjP8/8/f4HIigJIvPWsyf4v2++GgGcigTV5J7d9BpTyM+V6LA9xi3NZjDe6Yhg9eM4xPH6s3e/CFEJlvXzrYNi6tpScVNong1awU/qAW2ZwJzjtIf4/piEtnZ3x7nMniH9TGHgG0wmnRS143eFEgzXforpV0H0M+UdbASkV1bsIaxPb5axtFqr8n0s/4dmOfKEiS/UMCezI7n/mpzFixFXvEjatbqirzTtWhBu1rWC5KwyDCwczBnvese4hpSL
x-ms-exchange-antispam-messagedata: hjIHUThXkxYJjl8AKd3TaHT0BaDn2n/t2DA+k0hrZojHOdUjOSxTstl1hao/KkomZeQv3qDajBTWJgrtTjcPp9nPuh17y/eQRHWQTRJ/u2u/gVOlo7DQSOoEUjQpOCFN9S5Iil8WfjnzT2pv3Whkwg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7773aa92-5311-40eb-be54-08d7e2c08f42
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Apr 2020 11:14:55.9389
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GtezYHn+ON/5P+SBffoTUcTtAPzq3ZxfI20sZ8SVSzz0dva0xVWuCQLNtP95kmSlJpQU3Io0NGP1TJlfDo68pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4447
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,
>=20
>=20
> > During suspend, if the link is put to off, it would require a full
> > initialization during resume. This patch resets and restores both the
> > hba and the card during initialization.
>=20
> Avri, Alim: Any opinions on this change in behavior wrt. your
> controllers? Would a quirk or callback be preferred to changing this for
> everyone?
You have a v2 of this patch and a Reviewed-by tag by Alim.
It looks fine to me as well.

Thanks,
Avri

>=20
> --
> Martin K. Petersen      Oracle Linux Engineering
