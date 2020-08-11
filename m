Return-Path: <SRS0=1zSt=BV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7B1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 13:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DF5E204FD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Aug 2020 13:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="j7rYi59R";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ssik89Rw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728763AbgHKNuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Aug 2020 09:50:06 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12078 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728668AbgHKNt6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2020 09:49:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1597153797; x=1628689797;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J7eMalLCSqemav9Il1ACGeMYt/uciFTa/olo62DtvUQ=;
  b=j7rYi59RnOdGWjZCvHcKJvzBOtvrZwCJlqKnUTp8mN39i4zbu3vP25f2
   Bk9NGDjT4cLfXz87R7jm63zEAPikw7EYmGgfh4D7ZwP8Sc1ai92+jL79v
   C+J1t80j5nln1AAJf3gDmkpO8LlMmV8xkOJxhck9dLItyamHoJ0R91M3e
   65yA52AWU+tQurv0mbP5wk0i3fi6XXRa6aQA0996BliJAq08KPMlsPr2H
   gfNqTUXFYgrmeg19m3jDsfMM7FGHtdS4CIRi6pf478Nqp5bk549dc7yDG
   6bO1QNVcFzaMItlZVZ1fmLxCcXev9+tzDeKkpf2Jww5/rbI9dDRY4soJ5
   Q==;
IronPort-SDR: bjtbXfWEax4gizfGhFEpg3XHnEysj0oAtt/8m88+fMUJREPxc3soqiNZmFHFY2vo/IvJMU/Wwv
 +lw96ayP8Z/n9/iEXNL42k2hn5ChwOLeLGMhlGugcydDal4s+T6gFKfVNytFAf8eg65e1jB6OE
 OCt111qH5L/I0Qcl680RgPKemp8tyr7TKUayaxlzyeGaGe/275G7pf1n6/astWvFXTmcrrASTS
 4dGt2MwylXhCKP9ftzWPTU+W8xgySMKDdjs+vP7SYaUGV9Tt9Do9jl+MOJqQal3zrZL6SlAlFG
 Nc4=
X-IronPort-AV: E=Sophos;i="5.75,461,1589212800"; 
   d="scan'208";a="144670719"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 11 Aug 2020 21:49:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ef3vYCrXkosvkBpbjk91queCEemDWiE8PpUFTEVRR4iSSxbcA7wXwxG+V2MImU42KiYnxtUDHyda2j+egdsHLmKhAp3k6QV7hIjvXvuDrk0wdSMDzlLICsOLsS3dwXIKrD8VzDzztytpFmkXzK9i7gGg9EuRsEg1f3Nmj4/F0XPL8wTY8UHIInY3vmiPBYgPqrKKlnsOnFSYRIfsD3uZq5JLFuP/KkNDLG+SnDiJv32vahJW/1/f7UWe26fE6bSFv2Ie8/V+Jxbgj8dVvihEUnuoLOA6gpZyMzSFyFpNtLpAsmfsMQ9lF6Fw4zlQetGgyTcS5M83c8YnRCWQrX/Hfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7eMalLCSqemav9Il1ACGeMYt/uciFTa/olo62DtvUQ=;
 b=h13Xk12P70VcGk14Cr7f87xdd1z4tLFnehhK6ddkPLQGnDzZkMy8PKqHtUqV/MRSorpSbGMdaeTdOUeG+yXlDbMTHJbE/VUAX16W6/QElVYb6PnI+At/7JHpJQUNfkk7SmgWexEis+1uZMC6ODtK/snZKJw30GHooiVWUKnwHCYdqGLhs8EBtdoQ0BV23RfrVab10Q4FPLdZc8GzEWC+o6DlEUjS3cGxUOi3cyDrQ0TaRrRVWwtYXSpasD2nR0vRBky/b5h3RGTxmGO1ozV/OrZ9fNinGDJcNid7kSba4+Q0ZGwVE5aHUVDi2uPJYb6SUQlIrv5b/WyRuv8/dAK//g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7eMalLCSqemav9Il1ACGeMYt/uciFTa/olo62DtvUQ=;
 b=ssik89RwFyL/4rVhl4OztqEDIf9vsnI1guFAAwvuDVrB3Q3OKfhGDCl3MiUnaf/lhyW+GCfUoR4s6BYobVhusETUb7z+ItV79Z1Y9FSG21nqF22YOS36JsE9vDCYUCjzxZAq/CUDBaY46EohvEIYcEGTvzimOdfv8bIThu81750=
Received: from SN6PR04MB4640.namprd04.prod.outlook.com (2603:10b6:805:a4::19)
 by SN6PR04MB4080.namprd04.prod.outlook.com (2603:10b6:805:4a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Tue, 11 Aug
 2020 13:49:50 +0000
Received: from SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68]) by SN6PR04MB4640.namprd04.prod.outlook.com
 ([fe80::c86c:8b99:3242:2c68%7]) with mapi id 15.20.3261.025; Tue, 11 Aug 2020
 13:49:50 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Can Guo <cang@codeaurora.org>
Subject: RE: [PATCH V2 1/2] scsi: ufs: Fix interrupt error message for shared
 interrupts
Thread-Topic: [PATCH V2 1/2] scsi: ufs: Fix interrupt error message for shared
 interrupts
Thread-Index: AQHWb+Tuoliy5EtvoEOLkrM2do502qky7JeQ
Date:   Tue, 11 Aug 2020 13:49:50 +0000
Message-ID: <SN6PR04MB4640D8FA22E983946538388BFC450@SN6PR04MB4640.namprd04.prod.outlook.com>
References: <20200811133936.19171-1-adrian.hunter@intel.com>
In-Reply-To: <20200811133936.19171-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d34fa242-645a-4037-ab67-08d83dfd6b46
x-ms-traffictypediagnostic: SN6PR04MB4080:
x-microsoft-antispam-prvs: <SN6PR04MB408025FFE0D1ACAA4A9DE4E3FC450@SN6PR04MB4080.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NhJVb3+oHNDs8FDgazkvA70Kka/tDd0xTW0sW7TpxUMU3EDB9IZtSpZTbXp7J0INK8aqrhm6MV5kvKBLlydRqYVCR9n+4kLnGq/uvHthkm6Ck0eSaktj7GNwtfBHsfi75DPK0hAvFUquSGjuwdDysMjltRqcWJMiigggvFcaCbQGaEhSXKRRPc3rMEm8AI7rIIm9lbo/94a2D40LxwZVOScSioJo+CrsNbh633EzFaQdQJeh9S0pAQLtKozE9ZlBzCq5up5ihBIabz9DINgm2C2hdVak5LfNUCvGPPBl8sfwa7P/Zut8JZfifnSr46ZnUM826puOH6vXSZOrA+IekA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR04MB4640.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(5660300002)(498600001)(52536014)(8676002)(83380400001)(4326008)(33656002)(71200400001)(9686003)(2906002)(55016002)(186003)(8936002)(6506007)(7696005)(15650500001)(76116006)(64756008)(66556008)(86362001)(110136005)(54906003)(66946007)(66446008)(26005)(66476007)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PjqhVGJr/FXZbh5x7YNQmCMvPOk9Ts9pCFYgUdAdIQpmy1FUPB931HWYrVLo4sMCpqMHDIeLzvlOqjh40K5GwYanNCu09MwW9ngwXehZathvc4SNEHccf1hu413T5o0Ny3NzAUSfn7YFtTV9YmzpcVKrwgWohVV2YwJXkp2Y6/DqQMZEKp+r217mm7s6GHF7qvDRm/Wp1wbVp17Igwz/b+2fiXBZn9tbXJI+kGZZY8KyksP5F5IhIGEl5lSn2kOiBAF6PceZegCc7CxwaXybHNsTT5kxkNa8qeiiJigDDTrqA64GY4mS01pyPkBxu6F0rVqzsEck5vZgqu0m9+ZkYHkM+SC7H6YAIMUZ4vmzP3L8b0WjfQtmteQoHIKysoAokrDSyYMq/63GyTMtqyoFORZIqWnBbmzvSWFhBIHJAreMoccoDUsKNGby62B6VUbdiw14fRQWDl347IZ4r6/en2c0FLdbY5w535ERsv8Mr7KZNliOu4G2WdsqcIXa1yN+7uI517bFL38aZSok7eulvqN3Si5zq+An0n1mftggbRqthYhf8OCZm4i/1UAqdZERB+NcMVic1JGDaV/7BrZWGZuadIcvsh6UbHsg4qwk0miZu8RcTk3Hf+rP+jBxSe4ycTlf6PtODfB4cCy5nsWmyA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR04MB4640.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34fa242-645a-4037-ab67-08d83dfd6b46
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2020 13:49:50.7159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WcsoalNNb2JcuCjo+7lWuq82XpDK7Kl4q4YuJcgwUozaoO8wgycExEnVRRJYuYJTMHoKQoXYLRssHxnfVPi8mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4080
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> The interrupt might be shared, in which case it is not an error for the
> interrupt handler to be called when the interrupt status is zero, so
> don't print the message unless there was enabled interrupt status.
>=20
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: 9333d77573485 ("scsi: ufs: Fix irq return code")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
