Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7E5C2D0DB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:27:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B34A52071A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 15:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="O+gRoPoF";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="CTJ+dtEb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387438AbgAXP1j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jan 2020 10:27:39 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:7968 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgAXP1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2020 10:27:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1579879669; x=1611415669;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=O/+PW8hwS9P62ItR5pTM76yyDPHZ6KuUFVlIxhkBjlE=;
  b=O+gRoPoFFVV3GJ1yLp/kb2wG+8JnIx7ECUtwG8QWx2Xf9EXsLuddE9zb
   7SMyQa89xdBlG9IfzslO4pNkqtfLARfg7LIl82toAAJEDUr6+rMdpNJA1
   K441RNHZtHRAqmgQ1kaagvYyST/QUjn1FSQBzZMslAzPR4KPlGX695q89
   w6c40XxtdwMqSmRJgB6ET/G08GM4f9Vp7JvTwAZAA7V86SnSA+YsZbLFE
   PZqFBY5zppF4DlhzJsHkUpxhWNOx0kVXTLz3xDAGYd/lcX9lBpoH9ZAi8
   FS0UctfObPOIJsszFS2wbmE9GmyNMs/81VnpN2Y8Td2t1nuUdXX5Y8eUV
   A==;
IronPort-SDR: xmgeuCCbFalknq9EpQ8kIa8isMt5IBDkFgwvsarWfJpPTJaDuZ4cf7Jtzysh7l1wjjM3O0bj37
 MhD3suWTFbmU19LFrXIhLaTmHmLo4RxvjFwoyWDFbqFwMGPxRO9TYJarX66ff+HSDdIg8sgylx
 Ey9f3TcDHkp/JByuna0WXNggGTTXasKTb17S4OnRBWAe9xpFVTIJVautH7csiIQXJwrLivMwSJ
 mxX/L+C5xISW+ZhKOkar5TT0e5FTqi3f7USZr2tHEabE5+iQEbvQEIlM08kYR/a42/fDybzvcQ
 T7o=
X-IronPort-AV: E=Sophos;i="5.70,358,1574092800"; 
   d="scan'208";a="230022343"
Received: from mail-cys01nam02lp2057.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.57])
  by ob1.hgst.iphmx.com with ESMTP; 24 Jan 2020 23:27:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxpN1W9uX9dp3j1Ev3YzKLmpmE5MsiHkPdhQVBYylwPqMsaIq3rUpUfIbKi2DReUXX1kebNhpBEotTLlfY4TzYeTlJd9cQ2eISkYEwKZYjIjNvYlliWt3d72QMXRk0X1uwnche5eN6ywA+Si5OQMEsUVZPH8sKeiUe2hH2COztE+K9PG7G8nFlrn7sSZylpAkk2j5JJl/I2I5YX71QnsJsPjkzJLycd2dMvfqlScpUyHSxRivUnEWr1nVwjRWH1vWrY/1Zo8rDjliyNcSjIE6C4iklZECQ4QQAOwIYqe9FrG4R1yIONCMQNF252INVbn4rybK9Z65YC97D3xVuOCVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvM7X8oCWjjQ8OxNhvj+HctJObl7cCNAeQPgJFdH7QQ=;
 b=aTqVQm6GKiA0ATevBsYRSLMly/utM8rDOqshQ6W3J57fCgswtiV7VhIVVML1JFjvSc9BXbgyCxg2p+P5cHf5F/irq7NxYivLqybwY4zn8kegHLom/zpy2s7Vs6g497Qtgbjh9Rfe3f+3WiGa94bYs+hPszNHTrUJXlaaXaus6it8J7Zum27QY+wuqLk4syT1Ax7wT0fQk0G5f+Li43zj3xDXy/tyNdj8S3CwNwovtLsFt7K3Wt3YPKmHG3HhOd7WSfr4X6TYbQjU7+xQCwLSptIWoSBlwq5oFRRL5hD+qh8GU17o77bT0MV1mJaweW5pCP/bjV+Oh1E+jiiFl+++6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvM7X8oCWjjQ8OxNhvj+HctJObl7cCNAeQPgJFdH7QQ=;
 b=CTJ+dtEbia4mXALzTkV0xY6dpyAd4YqopntVWbRrIDDBvYhIbtfmdFcj37C+KFpe8vQuwCFkHCCXF9O77CWHEmfsM9Vem9ufHdXyn+4SeexDX1DXydB9KwfDoFn1rDnryphsiguJsX2W9sWM48xNFimWVQP8Iu9/DUAxjyBMXA4=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com (10.167.139.149) by
 SN4PR0401MB3598.namprd04.prod.outlook.com (10.167.139.149) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Fri, 24 Jan 2020 15:27:36 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::e5f5:84d2:cabc:da32%5]) with mapi id 15.20.2665.017; Fri, 24 Jan 2020
 15:27:36 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: don't panic host on invalid sgtable count
Thread-Topic: [PATCH] scsi: don't panic host on invalid sgtable count
Thread-Index: AQHV0sk7+a4+stC0Ikyi1hQPwOog9g==
Date:   Fri, 24 Jan 2020 15:27:35 +0000
Message-ID: <SN4PR0401MB3598BBEDB6C867B365300AA09B0E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200124151607.31375-1-johannes.thumshirn@wdc.com>
 <1579879382.3001.4.camel@HansenPartnership.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b0cf0934-78b5-4134-c827-08d7a0e1f096
x-ms-traffictypediagnostic: SN4PR0401MB3598:
x-microsoft-antispam-prvs: <SN4PR0401MB3598EA83B3A4B17EBAB901B79B0E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(189003)(66446008)(26005)(64756008)(66556008)(91956017)(66946007)(66476007)(76116006)(4744005)(186003)(2906002)(478600001)(33656002)(53546011)(6506007)(55016002)(71200400001)(8936002)(86362001)(7696005)(9686003)(81166006)(81156014)(8676002)(52536014)(5660300002)(4326008)(316002)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:SN4PR0401MB3598;H:SN4PR0401MB3598.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OExxDXKzcaeG7BxzpyukxpL885fk3Vf4uekO9cg+KEwKYTZusIE734BQlkxvko11ueogMOd0Nwo/0Tf9vy0m/S1XaLrH1z6J1NaIy88XDNiRBVaBWp6i5eIKf9ycv23LYf6zfBDNq696fgYiCwkaS35uiEPkFQfGHGwj26UNFfNI9qmTLSEZJNGhNKAEUgwJvLzZgL/HhiqrGwUinfVdlZw5MU987YCdi+FGHWsxCa45qi+ODcV9Pi5/Iou7MjRUwXgvj/m2aPoPWe5dNZVYvUct11y7bOopj8Tr4/VqU8nYafB7PtLLXfwNUnxM9TqJE6sJzu1q6JSDhZBKZD/XWj8gdDuvD91KRLwtbtD9k+d5qwGVFG455AxS3BgrR1ZAkms6wgVQ8iLRyRTVoIrSLXeXlhvrl35PWpgEBYBkRXVA8wftU7bMyBmJfT8s7HXE
x-ms-exchange-antispam-messagedata: aDEEmR6p0ckRjZNFnOiBbquQ8VqHWSCTKiPk1NrceL75y4ZxUeYqpZgJQ5yAU4nLqzHXvNzy3pnoQM2fJpVGTUHhTbh+D+LAuKETsykk17ccB3SDTUJWuyzlSrALS1VJqugwu+fkwSPmAMjEsHQ+EA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0cf0934-78b5-4134-c827-08d7a0e1f096
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 15:27:35.8884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D9eNCSASA9r6ljrCwYm4Udn7sxPNg+3eYsOb4JOIsxT/jTtGzvbY2Qr7kN5apjBC0wYbj5G5m8806xW4Vv9jrRqxBSJyV9SdYNoBZccYlNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3598
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/01/2020 16:23, James Bottomley wrote:=0A=
> On Sat, 2020-01-25 at 00:16 +0900, Johannes Thumshirn wrote:=0A=
>> If we have an invalid number of entries mapped an sg table, there's=0A=
>> no need to panic the host, instead we can spit out a warning in dmesg=0A=
>> and gracefully return an I/O error.=0A=
> =0A=
> Can we?  This is an assertion failure which should never happen.  If it=
=0A=
> does, it's likely an indicator that a system has gone seriously out of=0A=
> spec for some reason, like internal compromise, CPU/Memory failure or=0A=
> something else.=0A=
> =0A=
> The HA view is that panic is appropriate for conditions that should=0A=
> never happen because it helps the machine fail fast.=0A=
=0A=
Yes but an HA setup could still set panic_on_oops and retain the fail =0A=
fast portion.=0A=
=0A=
Anyway it's just something that popped up when I was looking up =0A=
something unrelated in scsi_lib.c. It's not that I'm married to this =0A=
cleanup.=0A=
=0A=
=0A=
