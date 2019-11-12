Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A12BC43331
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4704121872
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 07:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Ho3NfI8H";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="JrK1HZ+1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfKLHxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 02:53:36 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:63824 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfKLHxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 02:53:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573545216; x=1605081216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BgMAG7GCIadfqRnqQ0usLXCJ1XGMBf0nueaLwbszFQk=;
  b=Ho3NfI8HCXJgxXj00kfnGFq/Bpj/rCTnSjwj7lDTUGsHXaHTtWXjP137
   gBSjglSsysOtGb9QjLiG1v9mzD95yvDo+W3AZ4YMQpDuwDUH4lqcwJ0HN
   rzfW3HVs8JNJu41IvK0nBkww80XYsQYVVl0d4ftw8zThpwBMk3GLyfbhj
   UpxYpkPZojr5F4oyLdxkU5E+OWj0ilZ1LUBNlc3M0z+XXMzMPAUo3M6IA
   O8IYUTngRKiau4G+nyE2fYtFCxEs9htzZhcsu/3YY9IQ/tpH3dr0QOrWy
   0Vfg0prpN1pnwV3Mdr7nxZ6y9xtwufpTvMX2YS91jPLWO+ZtWJU4E9zAV
   A==;
IronPort-SDR: MV5DQgTPGT34CAd0KhBsX541r1JU1tEwGOHi1Q/0WPnxy3A2wsaPGeuK61uMsp1D4YsQy24/q7
 u1ap98JAHUoOe3Hm7sQh3XLI4B67gCg3YLJ3CHfRk/rz8XsZhmacOD1v4peIhMwN74u3LLEx59
 2MkE0ixms256EDiqBeqG0mJnvpil4vvN+JnPAjU0AddE4NrmHHoP4fhohfFvrdxN8CJnSr7P9g
 TjnTVwUnZylgGvLZGP6PlJ0vvDYHhE5fnJTy3IfxcByqZANtx0e3aW5uuUqQpkMPUXK3K/SeRB
 YYo=
X-IronPort-AV: E=Sophos;i="5.68,295,1569254400"; 
   d="scan'208";a="123484435"
Received: from mail-bn3nam01lp2052.outbound.protection.outlook.com (HELO NAM01-BN3-obe.outbound.protection.outlook.com) ([104.47.33.52])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2019 15:53:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FH/KEfdEai9Ajr0vjYV/eUw0zKINpejuzTbwPuC7vz8+6JhH/kBKGRWs+z3B/dGILJWAq67fcxoyk7ryLCgYurSpGGfHfMA4y2a2dbQ6HHCcHW5tzLdFbP4QLgev54Ejn5T3py6QZY8KJYvY6yxqLDbnryiwBomE+GbUCkfAwgyUuxpBBDmzAjD9d8e0SUU6e2mx73XOnm2SYxSbjmHrLRaeuAu3AZ8RIdXvCgQK28lwlSW1UBtAy7lGrUzfcfNgR94ZBa5RVCAHZG1spQg9MT0tz8opcZ721PDLY5VbErNmbOPq42OxuAuEE+bHsOox4q/ndRX1k/oA6N2OYYHooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgMAG7GCIadfqRnqQ0usLXCJ1XGMBf0nueaLwbszFQk=;
 b=aCFwOPL1G73KlXe2yKtORf6R5ciD97kBd1p0T5BQumgOas97jO88wkTG2VxUPbxYw4bsndSabW7yq6ARahooMP05cJnsqUUezmPEVaG1jc9WU45ulZLMlXJDTxRwlx6PBTLm2WptGCH3nEApza8JKkWdAhfKlvNwv27gLItiJQi1pOzYsZaE0Vogm8/VuAbMoQZTU5l/wUGeBKOXMtTTw0mJ+oqAn8mUaQM5tuT7pi0nYXCl0wyolmbm82RgaEVtWgcM5J0inN7Pu2bxk97kmyU3SWPfh9aToJw3MSvOAxG7fLd1tPnZYj1JxXeOrYoK6SwNM4C7G+mtRncbocviYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BgMAG7GCIadfqRnqQ0usLXCJ1XGMBf0nueaLwbszFQk=;
 b=JrK1HZ+1aG3BkrBdQZN2TqwTkUOCv4uonaRXmuHufYPdkCSrVrlcM0+0yRe1MG9XuY1//L4+Ffp3DIGJvBY8f9mWc0eXKInPDlKD8mxjmR++eGCUj9QLE8jeW/zGZBP5l6mkbIugzLBvsDUcdXGCv1ylfCamvpWzAaC46B4iSGg=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5998.namprd04.prod.outlook.com (20.178.247.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Tue, 12 Nov 2019 07:53:33 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 07:53:33 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "rnayak@codeaurora.org" <rnayak@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "salyzyn@google.com" <salyzyn@google.com>
CC:     Alim Akhtar <alim.akhtar@samsung.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v1 2/5] scsi: ufs: Add new bit field PA_INIT to UECDL
 register
Thread-Topic: [PATCH v1 2/5] scsi: ufs: Add new bit field PA_INIT to UECDL
 register
Thread-Index: AQHVlgzBbxOZtGjTZ0yABiX/LyOBa6eHL5pg
Date:   Tue, 12 Nov 2019 07:53:33 +0000
Message-ID: <MN2PR04MB69910D7CB55980F2C498A468FC770@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <1573200932-384-1-git-send-email-cang@codeaurora.org>
 <1573200932-384-3-git-send-email-cang@codeaurora.org>
In-Reply-To: <1573200932-384-3-git-send-email-cang@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: def80805-88b9-42e7-5908-08d767456a97
x-ms-traffictypediagnostic: MN2PR04MB5998:
x-microsoft-antispam-prvs: <MN2PR04MB5998018D49E020B3E6EA51B4FC770@MN2PR04MB5998.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(346002)(136003)(396003)(39860400002)(199004)(189003)(54906003)(186003)(8676002)(81156014)(110136005)(8936002)(81166006)(33656002)(4744005)(6116002)(3846002)(52536014)(2906002)(2201001)(7736002)(478600001)(2501003)(316002)(4326008)(71200400001)(71190400001)(86362001)(486006)(74316002)(14454004)(25786009)(305945005)(7416002)(66946007)(5660300002)(76176011)(7696005)(26005)(76116006)(6436002)(476003)(229853002)(66066001)(102836004)(6506007)(66556008)(99286004)(64756008)(9686003)(14444005)(446003)(256004)(6246003)(11346002)(66476007)(55016002)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5998;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k4KwPz6DELTrcHi6VggVSbOhWXCl/yys878P5pWWW+u8GcbnaAglnPXgraAXgfgW0xm4luSaaGzWYHr8cJOOzwr+WcZTgtHuBA3hj1ZJdFhJDAE+k451AcsEgq+0IdeZ0AxPUo8k+5e8osq3P22+5frHwghDPalbZ91vNwLLiffauupljdetJlxLIRvSGlcQ1eLZFz28CAe4EZl32zDAt/ANo+9tGLO4odic5D0OUoMwtspIasW7TCw/UA4TGXu+fg6WzPJhEBR2rb0+YRd/ui5eq43yB+ABkZsbD5AahYv54+sbxEaVoPhyy7bUtrMLWIj5q1Nax4Gfhgs4noS1JRwsTHLjIx4pnRWRX7wKU2ngOUX/0vqS6q8B6CLt2hxNb6N2zgoGp51KNS3h10reyJR5djSYjIuxTXi83IkJnBGcKPZHHAxb0A68SJxgUdb0
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: def80805-88b9-42e7-5908-08d767456a97
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 07:53:33.4126
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dz3ngO2HT4zqaKS021ymt5nhp7L3YWlwCaaGJoE6x7dPyPTSxjecLTSw915i57QKxlhRmx22kz8137byZbow6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5998
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Add new bit field (bit-15) PA_INIT to UECDL register, this will correctly=
 handle
> any PA_INIT error.
>=20
> Signed-off-by: Can Guo <cang@codeaurora.org>
Acked-by Avri Altman <avri.altman@wdc.com>

This is a HCI3.0 change, so maybe make note of that?
But UIC_DATA_LINK_LAYER_ERROR_CODE_MASK isn't being used anywhere, better j=
ust remove it, don't you think?
Instead, while at it, fix ufshcd_update_uic_error to check UIC_DATA_LINK_LA=
YER_ERROR when checking for data link layer errors?
