Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA7D4CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3D422087E
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:25:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="Twz4/SfI";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fsH81Gkv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfJ3LZw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 07:25:52 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48286 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfJ3LZw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 07:25:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572434805; x=1603970805;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eQ7SXUdWwM0fiU1f3flJVuPzSgzLLwiHK5TCBJXjywQ=;
  b=Twz4/SfIbldV8AOaBOl9ehUTZyCROvPr5R1x+fKC27BNdAy0Fqz5bXb9
   sGgOVIo5M8jjYP4OtxL2cdouFh1p5xCxjHPsUtTw+Z1g7rtHFnfLZ4t7a
   bov6kkF7iS4hIBAEq4bwkMLY3NRqKztOF80VIHdbyz75tjAPPB0QTb5M9
   OGwcTV2WV2yRe2dGuzSafIQsK8kt10g6/kh2w7sO6W70F5G8A9jIMKP1z
   kbHkrJXDxrptgrBJC7fBQdK4bs0iD+hH1/hH0FV/RZ5/qmDBM7hYD3Slg
   6XYAfDmexrcQ7VnnPtbhiog+C/8UAlHQ1AZwU1DC2cqtxXiFjJ0TDE9FA
   Q==;
IronPort-SDR: GqqMWcV9+t5lmdGZtngTtkizKB5UqHiOaATWW1K73wKEm47Ah6GUxZqOCzeIf0HOKN8tOnHJOq
 ywjXBwhE6xqoHFt2bvINYKft9KUGz5bbVkiwoU/w8sKco4NvyIwMr2ga1szWde9cYxOMRInD1a
 uKxFlElDMNqMG8tH/WBwZQTI4RO4iS1nFaiJS038qz2l9p80uU/uWQ/czv/giW+I2Re1472aOK
 eOuEzHnAu7L9xrtqdsDj/zKW6JkOMN/gQ2JVr7g+CiPLbKMk3zTdmh/tcMxeGSSEv0g22hDIZI
 oWk=
X-IronPort-AV: E=Sophos;i="5.68,247,1569254400"; 
   d="scan'208";a="222819376"
Received: from mail-dm3nam05lp2050.outbound.protection.outlook.com (HELO NAM05-DM3-obe.outbound.protection.outlook.com) ([104.47.49.50])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2019 19:26:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTSmhgWdBe2KEOqhXxbAR+n2hAvDdDlqcu8lUAbpnUjVDTZHX3WfMWRSCgl2U+yhkmu+pEGziecYjT2AxrkACqjN558ce5W/QeVbKqwes7RYy5woW5tmJJSIMIFoyQZhWxJUtC8rdTrobNioUMyzyUfdLPc+mdO4krDY7eg85woMF0AS7gEuFJkFyFHScTH08PrTB+4syeEcGm7rB90USzF7IaNuD4QBqs07QWtK+b82S5/aSwZAsVvSAnbi4w9e/l3a/r3S9MEEjAiLyLeoQpCsM7K3oZBc40r1PQ1ZEw3u9+VZWCGtZYt+BSSKpQNfrey3qdxbCHJhvS9ylKK9Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQ7SXUdWwM0fiU1f3flJVuPzSgzLLwiHK5TCBJXjywQ=;
 b=SipU+z/cAPedPmk05dsLgw6q8vKiq0aXI0903oULI444n/WaLSySqx0CakR85i/DsK2sx9mMvfArYNJff6CeBXnv2u8iH29OOiYfwRgBIJ3qbwMTcdpTvKCwr8m/uUsSsixc1+KwILf2pxEx1linbir6a1v8FzMynvvrBB/uBn8GoZMYxOyIUSHKTVhAd9v7IGvwQvdnYwUf4sKPauPbTdkhaXJEKoaX7+1YRFNKTfEz/h6cuLyrXOWbFTCGuvCyEYoPz5ffSHjfW6MjIHVGLK8IQbBYbRme5wQI6X0VL6dK/qC041jXyzfLoo04JVXYRcaDbkClyLdbdY5ERhwRmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eQ7SXUdWwM0fiU1f3flJVuPzSgzLLwiHK5TCBJXjywQ=;
 b=fsH81GkvD/xJg+IaTPN+qKj94dAHDf4xbGOrppbhQPTynkHZG+Ytg9INhJYETlOER53U7KnvFTAly+t7tJG30qhWIm2voj9FzadqI13t4wbx+pZ84LhLLXMksFVupK74Aw90t6vz6aFYjaHS1p1x57W2EaTKCNtyrL2ikKiiQ74=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB6765.namprd04.prod.outlook.com (10.141.117.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.22; Wed, 30 Oct 2019 11:25:48 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 11:25:48 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Yaniv Gardi <ygardi@codeaurora.org>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: RE: [PATCH 2/3] ufs: Use enum dev_cmd_type where appropriate
Thread-Topic: [PATCH 2/3] ufs: Use enum dev_cmd_type where appropriate
Thread-Index: AQHVjq2gOrzhn9EY7Ui1v3VR8dAHNqdzDAaw
Date:   Wed, 30 Oct 2019 11:25:48 +0000
Message-ID: <MN2PR04MB699199B4B4666663F194ABB3FC600@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191029230710.211926-1-bvanassche@acm.org>
 <20191029230710.211926-3-bvanassche@acm.org>
In-Reply-To: <20191029230710.211926-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dd660cc5-3184-4c41-9b59-08d75d2be9d0
x-ms-traffictypediagnostic: MN2PR04MB6765:
x-microsoft-antispam-prvs: <MN2PR04MB6765C4966C46F63F1742C3F2FC600@MN2PR04MB6765.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:569;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(189003)(199004)(26005)(478600001)(256004)(2906002)(74316002)(6116002)(71200400001)(5660300002)(25786009)(4326008)(476003)(7736002)(8936002)(81156014)(305945005)(11346002)(446003)(8676002)(3846002)(316002)(71190400001)(81166006)(6246003)(186003)(486006)(66946007)(99286004)(64756008)(66556008)(55016002)(6506007)(66476007)(9686003)(33656002)(66066001)(66446008)(14454004)(6436002)(76176011)(229853002)(110136005)(558084003)(54906003)(76116006)(52536014)(102836004)(7696005)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6765;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BZFPiT/Q8yzUuH8ukKjT5aR1ktxMK+P1OS1MZyukxkBzkmxC/8alggEhUGLZmAVAGbdm0VXgfhQsINqIMUlnTMF5spIpQky3tRe0zepTK44LdGWq0LSDq5mz044jbnzJOvrO+nHoTvNTVFiaBTOS3QejU76k4HE9RMXNVsWFCnNSmnQLTOCGCsIs/krkV1V/BEALS5uqS7u0GrtZH2FthZyTmAdO2H+RBRxDA7cJScv6DdoxM3A44kJPqJl8WRDaCIrNUsmtzlYJIygJt1EcqrDlWA3Idw/nTunQYWsbkBbJUIqIRCZDdJMMI4kFcKnoZoKvtE3bik8AXxIhJMZjRha40MH1r7TfnqTBsv4nWY9cwLIS9hEaW9I2J/FDNi2EM5COmQ92khKvYIkYHNEIUyEQ+NRDr2LseQ1FcKhFVdbjX8ENqjxZEr/GMwkPFnEJ
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd660cc5-3184-4c41-9b59-08d75d2be9d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 11:25:48.2988
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tn5uEca4VgBQAppLnE516/fU/vlE7vMKw5nDkfpi2pYZfB/RsJFDiIoym9WsZWel5MBF8rmwrpBE/5NHXpwzuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6765
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Declare all variables that hold dev_cmd_type values as an enum instead of=
 as an
> int.
>=20
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
