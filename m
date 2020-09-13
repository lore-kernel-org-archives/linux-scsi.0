Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 256B0C433E2
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 08:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE8BC2098B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 08:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="KBCfSkS/";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="G22We1Qi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgIMIFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 04:05:46 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:18021 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgIMIFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 04:05:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599984344; x=1631520344;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=KBCfSkS/rNS7o3LkEMneRtOc6JUYoaN9jbOp/8XvEWvlEw1TV+J5AzY0
   IHq/K2lwpin1WRXbY78L/L1nIzEZjLomyhfSd6jeSUXdS9JqnCXVRBWIV
   vUVWoAfh72gB82ZNr7HonCt8eluQOwBKjFWRIpfDoxNxwNJksFNTxTRY7
   V7jmUW9BPHHhPAvBVgU+M060c5ylwBS+1HYSevXK/yZcnCu7utYiaImXv
   GYOIf+IGcjBHCwQ1wNuuQuyQuULcjqtnlO02T63S31YNGCUZmXmt4psRc
   nq24hMeyQiksw5ASyyA3GuaNzTpmd/rUDmshoD5QV1mWZE+HXs898GvVv
   Q==;
IronPort-SDR: 8fonozgsBRBC0tjtDhuqWfGRrHQ01VHSDc8rukpMNSzA2QP7yAk1/xTQ+YpjCZLgG29SCgX/zQ
 y4d4K2Zz4or1Uc0CxS5hFhLW3MlirOhpWraObuQoppxrGwZDiIOSlgzNEt7MQH0MKFBfo6aWZE
 ucuJ5IkXlhteUVA1C592B45pvTltbS9OmFrwuCHojZzfrtVP8A9YnlaZrovEVO0tOVBOxAyrYz
 NC5wf2eg6Q+ETgxOB2BYnih5S75R12fyYAltWZYcpcEyhSx1gL/MNpqhN46rf8E4zdU+7U+dmx
 G4g=
X-IronPort-AV: E=Sophos;i="5.76,421,1592841600"; 
   d="scan'208";a="148463034"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2020 16:05:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l853NtAAdd6Js2sx+LdggW7Al6dcVT1nAi24S39crSTiWdd6CEmm05CIfIg3UQNV3HLavDasRU1nTKY9D1SmIExAmJELSnyfpN6DpXmIDeysw0HmMbm2rZZNQXwEm4SXdPTkbsZ2r8HdDeV7huW4UFQpKLD0kWfzi+TUvRHlzM8O9l+D/XddOMXwwWYO++5gaj9JTy6zuC0SP6/eWtFYNfX7a2YEJUEVa/OODuTpEw9dz135yNqitOctA2JNGSv0iQoTvW4Pl5QSWdn5IblllDrnIsGTC7owzFwkGuqPTdz2y5Q/6W9+owltrNm+GYdYD7nOay5P4sV5TAbvOG4BjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=TxhjQMLWWUuGg+ko+RI3kxITXP2DEZYxz7ST1AUAH7H6uY4zGQoOjzX46RfIcLqFvHMVf8MSVwT5xuD1GaoLTh8jSH7gwR/CfBlVnS/yYCdXcCEx5SkncSm1ilSv0y34tWtChCQwATr4wuej7QuKzOiRaGEvcnl4l/J9q89GHHDVqjXEIvoNO5yicxluilPifiv86mwtdKTKJ5zzwY7YbqsycNcappWNTTKdQtPKWP8RkXyWiXUTFuyn3m+Gan7gQO3Hfp7bOabERd9OFEO4QuIq03OG6R6GQY9KqbJhgcn1YavtXcvO+Ox+ERx8zAXPxRB1fFrmKwrm5CWFl5uIIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=G22We1QiTVGnT1TCkrY/PAcif2p0Cu+aXQ6QoQEwIUx3ZzjYBTfZI4gU/Ot17UKj9LhDxI907Ihvsyc5vDDNDGDe6ZCVGFHGW7/uqcVMSz9TLX3jUgkj+We6X1YbzFDNNoA3Peouo1wyb5KPYLlUoSh2m/mGKqaqA3k2KJWo2vc=
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com (2603:10b6:4:7e::15)
 by DM6PR04MB6041.namprd04.prod.outlook.com (2603:10b6:5:12a::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Sun, 13 Sep
 2020 08:05:41 +0000
Received: from DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::c862:9cd5:689a:8573]) by DM5PR0401MB3591.namprd04.prod.outlook.com
 ([fe80::c862:9cd5:689a:8573%5]) with mapi id 15.20.3370.016; Sun, 13 Sep 2020
 08:05:41 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@alien8.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 2/2] scsi: Fix ZBC disk initialization
Thread-Topic: [PATCH 2/2] scsi: Fix ZBC disk initialization
Thread-Index: AQHWiZOUiAJ8BYLuGUeo/0SeOOYpCw==
Date:   Sun, 13 Sep 2020 08:05:41 +0000
Message-ID: <DM5PR0401MB3591C34B9960F218E280F1BC9B220@DM5PR0401MB3591.namprd04.prod.outlook.com>
References: <20200913060304.294898-1-damien.lemoal@wdc.com>
 <20200913060304.294898-3-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:142d:5701:4822:4ace:4c09:21cf]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 100ce50c-2dfa-4841-7a09-08d857bbceed
x-ms-traffictypediagnostic: DM6PR04MB6041:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB6041B43B06E17B714E8F92D09B220@DM6PR04MB6041.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F/lxrDblUtKAgYdhC6P4MCjdPX+IUwtwEgLlGk/EbNG0ZmxJtEGqRpBYFiWZ87Jamw165pHEmNkoG32GApHqpJEiHWa8E7YcQaEfARIVK1CJSQQnYqXHcFy3sOL0/CoPSPOpnDRhYMKW1fR+pswaK++Zj84/CCtJVp9leZgyiHJ3Y5q4fIJx7UYY1b+ztZz9LtLZAHdWW45reN743dTs7uRAgKG0BW3LqDg5Tz6VFU41QC0wmoVUPglD1DjU9Ws5W2s4d0cqpxSzjO4fG3kTnfnSUrJopDw3Jv3yyFF6MlOb+3gaEpB7gzSjGz7743wKxNzcsb++yfc8IgjN7NSHvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR0401MB3591.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39850400004)(8936002)(54906003)(558084003)(110136005)(4270600006)(6506007)(9686003)(7696005)(186003)(19618925003)(55016002)(71200400001)(66946007)(478600001)(52536014)(33656002)(66556008)(64756008)(66446008)(66476007)(76116006)(2906002)(91956017)(86362001)(8676002)(5660300002)(316002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wzB/awjfrqXqLOmcOdD0Sbx86SSYlpp5WRpnQR9RJQKOUSQEzK2UaRutWkgzL9KbI+hiShH70bdhjp0wYQ3AST3HXNrwk5u4+SX0D0FpAEw8dGIQmUk0FwmBv+UtTdrsPCOe7+CghOo1yp4N5Fymsgya1LEVIFIMGm2UEh9POLnyBU16MV/omgqqxiixB494RFn6KBq1elluwfTiJ9p4OFd9sM79A54VKTCoy5QNrpvElxHCLyg5wIOyMOKA/AiNhn22aSZ4JnVYi97OAe/k9rdQhm3GP3pt1vXcJqUFgyrtJPrwfbyp7bKR6sYp8kwlfgX/DvcnlUT6iM+Oa4uGRAT8P3A9K4/Vh+PDwg6nEIGJRlh3hKJavbqJxFdvAsvuHks40n6Vbh1DEiiQE/jKMsUKXkxU4P3kiFOhroe1v8IW142LW+w8tD9ZuPMvj2QlF8HwvILBon/XssOuNx/XHZs/0SlmuQeA0OvrQ8Wj4ECYf1sKJyVTXtrWgZKYXR+UTRbBpZumDg29eglQzFH92pZAfc7CQBJRS9f/Gt8NPbICfnhtcjybQg/7pmdM8d2HSuiVHOGd1Y8iWMqytVPvWszOxCJp/U844pFBYcghdyUvaBK2mxyvo+RbTrYsVm7gRocfBpjh+KThm+k32plVZmSJ2t2eHqy1oKIlcEuCwD6oiGRZfVp3/uaSwci/CCOILIQ2YwEcYil5WGpJJOncAQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR0401MB3591.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 100ce50c-2dfa-4841-7a09-08d857bbceed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2020 08:05:41.3506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +Uex2+ISWgXFjpFNMh521n9bPZ7v7R9POtWu6j8/G3VYtaRjVmTB9gQlQ4oYdgroMpWCaNKdywjVkeXHhJ/P2evFYCXOBd+MyByyl+MEdDw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6041
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
