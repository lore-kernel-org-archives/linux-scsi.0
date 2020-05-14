Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3962C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 08:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B74720675
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 08:24:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="n0wP7Dsv";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="SPtTJEFa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgENIYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 04:24:17 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62830 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgENIYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 04:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589444653; x=1620980653;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=oajqTHvlHcGvATDzN9ElnSIx8DeJK//uC9A/LfnPHPM=;
  b=n0wP7DsvZM4Lq+NhcXyFQVVTzjZ+JZbjYdZDIcsfHHWQcWkBOyxR8Ht0
   HtvOR9FVxg+x0ehy17EgdgRa0nKae/bRWIl7ANWVmNX/BQAJW7bgRUGKa
   CN2G2V2WYmFBC41O91cIxSczjTo1TqYAEIGFtS7q+KfkY7MW5UQV9CCIh
   kPIDVyZcJTZWAi/X7ncWZPzew2CcyL1OtxRNfg0dWB1V9nD3sWBhxlxUe
   X38UULhX54fdSKx/1rOKfwY1sqaGte6Brh69LKhp4f1BCykLDQUKk032U
   AEJReiJUZDXGWR7SniHTecMoKaRZlR8uw0j5Z90f42NSfDfrXtNzKKGJn
   A==;
IronPort-SDR: UiCx+OGIWLiJBLhT1Fp5bGwoJbIBZB9tWPfrPNlHCySx446hdNDrjUv4RJ2dCZxmvLSHlPdGI2
 eZrf/kQXv6wEChmdUIOgEApM92U+A9qhz9C6u8FcrI6PwvKGQj5HKh8X+hi4Ir0Iqh/++MY40E
 lLYafDnvqWSylavN83hpbEw0246C/ogFGdXLpEfJSU6JRks3Fs4QnkZBfcp3ofrZ153sje7or2
 4fexJ+4B+E9VPA8Ftju9oRP604qGpYN+bl/En2RbGChs+ywL2mEVM0LxL26flO1XLp+vGaHTz9
 ZOk=
X-IronPort-AV: E=Sophos;i="5.73,390,1583164800"; 
   d="scan'208";a="137655256"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 14 May 2020 16:24:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KoG9jfuwFEzZ0AFpNAX3WN0qF7EK9W/UfOV+QMp0vxd3On4n4lqLJoc4o9lldSEF6ISpVai6OxtqUKuhdxlN/d/+hBQILSim9+VW8YYtEt90j305/CTH4k5wOARlQrHPUCCpwaGa+VaQLfok1g9UAjbtFH33yfVNfMphjWcS1UJC2T69byk+TjO4lSk7McCAC7H3XUiDGkChXxuYb5qX48mx/NK8Y4f5BwoEW2yFFTrzhwGy2m5oQtpdQI55eESMjQMRNArk7E5qkJqKBGpUzp01oe5CC99VuFwadRhvq32ivf367Zf3+9kk9+/kNqVqsmYUFtIVOO5r8MlMkxgLgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oajqTHvlHcGvATDzN9ElnSIx8DeJK//uC9A/LfnPHPM=;
 b=iwImq3Yp+S0SthwBncrgCHRKun4tAsjMDsLPgvxaPww69GW3h9JEjnaA9szNpWJ0hvWUxyyfAhfpciZvRNtsdUZK2eqrZ73XruUfcZ5+rEGqppUgIxcFWcQivb1Kk5kX8ahB8fT1f3YISW9uNnuOf26KTdExbbkM0tjNKoALkgwTwuEuGcYeu+edrmOq7biHvuxE3iMRuUlqZDmM0vu5L1Ud0IaOxRsbWPApNrGk9oLTUSH2QjwIklBjgVKgUPI5Ue7NVdI+8O2vsREEI4YobldmvHTdyv8GJ9LHJTd8tjGhyYakRlvr1XAmYR1llpGPFoQkj+S5OIy6sypdfpHvJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oajqTHvlHcGvATDzN9ElnSIx8DeJK//uC9A/LfnPHPM=;
 b=SPtTJEFawycWp49zUeoCZCKSZIR1n0+i9bMdgjHkNZFiUkUNKB/XPYJnj5Ffwu5n5kKZfdrrk9DqVzPqITe3I7JcA5xIclD4htnQElilSyc1+Jk1mGJSpSzYlKdlqtVG3rX4AwfsDXq3RNyhvr6N4aoWNgUqTc2sOrQHGOXe4zc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3632.namprd04.prod.outlook.com
 (2603:10b6:803:46::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Thu, 14 May
 2020 08:24:11 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 08:24:11 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: Signal drive managed SMR disks
Thread-Topic: [PATCH] sd: Signal drive managed SMR disks
Thread-Index: AQHWKch2WFLvOU29K067YttMEcYJbA==
Date:   Thu, 14 May 2020 08:24:11 +0000
Message-ID: <SN4PR0401MB3598F0C027AE36A783528A1C9BBC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200514081953.1252087-1-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fa43f608-ed73-459e-ce27-08d7f7e02e31
x-ms-traffictypediagnostic: SN4PR0401MB3632:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN4PR0401MB3632D57B3F9BC9569BA86AA39BBC0@SN4PR0401MB3632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 040359335D
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/oTEoX1o3kK5RzrvMMpiHec8Nrw/a9nZe4sYGTdEvTqQmtvtUtB9El7mG4EYfnI7lmyQAPgN29w9oVkXb4RggR8JWXCDeBOan8wCHDbzYxvJ+e16XAv+Wb/w0kMju8yEay+/46YSutWFm0f4SwZRebYp6KTy6d+QNWbOfuhuaTwSr9o4VH2FNJNlqC45yjFshKzMZqcXNezwqT/rSIDloUGUQms79TQQXMCIEgF10GAhjlKNLFrF3ard0wemuEfVQIzz5pbFfRTIZEcKoIKN46Wk76FvtV8SvPLhzYZO0IGiVua4UJ9GqODXPw1D4cIxRmJRWDj/+Galgn8Q1qXueKDv5DQEzyCdIPoPbzBqSPMKNznU8/WvXxkIWaVjAxriCVYJLioRWD3k+QYsCAbgZPunoc8n32K2YDj9rqnbNCI9I0/BvUhUxCU4pQYitIk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(396003)(346002)(376002)(26005)(33656002)(9686003)(316002)(110136005)(19618925003)(6506007)(8936002)(8676002)(558084003)(7696005)(186003)(2906002)(64756008)(91956017)(66476007)(55016002)(66946007)(66556008)(71200400001)(66446008)(86362001)(76116006)(478600001)(52536014)(4270600006)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: eTKN29L/W2H9G3BRRKjP7wML5jQwIOl/N+ExEhxQpzCCcqx9HRCGBJYE4f2KlQKkLbuMnX0CKWPS2WOFSIx4bvp32l4+0qRhDDmoC4xk9eIKbgkQVm8Kct9j43ONLQ6NWMu/R4OT/WmsPk5X+bCpVl+4dgl8oYzHpaRn64CX5xBDVmmoi2SEgTbPUS7K3gQjAy/xQXyxfl9WegALz2/OYzd/GtqO3ZkZRfOD5BLd3++l5qHsxScCzRA+lTGPzIdNBafxq6d4ga+/jft449Y0Y4SYt8/M5CmTG+mvVdnNybUSDWJuqTTJPIVG1R44SRmj2vtjv6Fa4NHQNTxaD6ogZLcWcDU/bpv46oMwPiW5O1x6L8agEB+TRDUkkky+y0LeY2VZct6BZCDQv6J/0lsVJFcVZ+u2DcfrgbXZth2/wx66w+3/vNC7zrztwXkaSbgEitOX81FghCsUDeBKQtvTzbIxIzWejc7mD3+I850LsBrb/G16cdtgetj1xg48UPer
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa43f608-ed73-459e-ce27-08d7f7e02e31
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2020 08:24:11.4996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vaQB5An6Di8gpHH1amBw4hbbat0eqTU5TR4kC9Z41PBkKCtuG3r+UxXjevHoQsDRKJGYMv4eR/bUKdYy9XBKVX1awPh3nfEMwwot4a3x8G8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3632
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Loos good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
