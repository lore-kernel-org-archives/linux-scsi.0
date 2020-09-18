Return-Path: <SRS0=xkU+=C3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31112C43463
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 13:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE801235FA
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Sep 2020 13:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="EDQ3g+x7";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="UnGIapQo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIRNgM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 09:36:12 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:54680 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgIRNgM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Sep 2020 09:36:12 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 09:36:11 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600436173; x=1631972173;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Q32QRsRtvtObYYuTNzLNG3+HC5lh3SmW+ga9yYvPHT4=;
  b=EDQ3g+x7DdmCbhuR//M3U7kRWQoyeqlWFaiE/OznS5WHqMfF+a7he531
   BUwvISZOkva/wIhyMSHrzkiyPuspo+wib/3nVNt1vC0BGMg4xtwF4gP/D
   Z0pxufky+PNl+/jNsp3ij9+i/PCLjAcWascqePPPX0p+djCXUq8o7jkeg
   IuZEuFtglcmLtoSEk2w0X3Ks+3mlTBKSo2xZL+ueX8+K9aTOMtw3WPZhM
   n9Qh63E9htJW1Zi6XSu+IHHZHhsu6jyNV8CheqebsSK7l9+P1ylncVATH
   HEsejWD66MXMXQTsk+0syajIWSSAa8+XuVBgpuO30V/x5SWuN62Ngm0OE
   A==;
IronPort-SDR: jSVAc2dsPX6CP0JdfNiMXFvPS+LPdqaDqpDOODMnDf9PpPCkew/n2ndBnZ4Fo/bQEr9S14KzqB
 /YtveKo6clVTFhO+PojcuF6+oAEazJ5/CMaFIMvlIYot/K2JZIGkap6MdIKVzVSPk0AsG3OQC0
 bxSvQF7wrMokR0vOBKSy6kLzmPugpZZ+BVfTaAguhqU/JG8imhLgD6ngUhG6T+Dmf9Dr0pBIEx
 q0Nv6P0rzfJTuPpsh3dFxBZ1HHDX78G2yegLRdFlcifZiVrACNtBCpefFgw4SqTMLDczXzMqPo
 rb4=
X-IronPort-AV: E=Sophos;i="5.77,274,1596470400"; 
   d="scan'208";a="147737103"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 18 Sep 2020 21:29:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L37rCR1uz2Stw+FYgwTDIj2KoKNUz+mdGQY1Z7ECddEAuMGJcEwlxkAHQYwBfGDkPnvx8q3EpSEgWHdG4NfAPNCrNE0fHpCqbudgpwLkIucD2Emu1cuuwjJp4CT6XIX5zrgaRqpsbfewYivvZIKObpfRmmDUpuu3bogaIFKB/coKtH8wHDJKYM+Msh0/zSCOtnFjt9AYdFxDDQKE+Cb3cRJpQsxIK2Nov8abXgypOomUhbhAcxCynuDH4XYn9vVEuH/eyqtOHDr2ooYH/bOtXHQIhN5PQdD//z3zvtWAf8QNQsRgME7PI4724GVbnI/odYTeASpjF0y21TbSnvwr0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q32QRsRtvtObYYuTNzLNG3+HC5lh3SmW+ga9yYvPHT4=;
 b=TVxLsYQCY0sW2dsATPcyQPiAX3OPEledlbUOA61ECvxPk7+ChaHYXq/PSfZDUlbMGfvtUUJ3f4MFbIpTbUBzYK+VlK7oHakEcETcPdyhyUy7arfTdtG7MsWn+MV8L12RpQ1NUj1qdR/gn5jG9QKniz/HuPuZNoJbKTsGCSBPU0Hi7GyvnMyNjO7fArUaS5kAL71xdMwBJF7vaMYrwwirdkQxcsjhnC0Jyddag3UryweQ8ejSkADDzWbiIh9HpNdrfrAo7ATWyRRdHtGh7MLQZjmKdJhvPcnyzINFJJNROOojfgH1+JQz9pbmYrcth+9eb/AO8cCGXXPCQyW2a6ZRzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q32QRsRtvtObYYuTNzLNG3+HC5lh3SmW+ga9yYvPHT4=;
 b=UnGIapQo/VzEdq4/vzOAyiSnAW2061jVIX+zYjt8CpIC1PN/fdsaaCicTkY10cB5T/dcMbN59igccsMph4F3LFfCrjbDqdicGPdp0rD5+mkRK0GeqlpZSoWlnqCtOrKxePxJSjMw0ANy+5nV5Pq0bbQffChGopus3QqWRr4Tgss=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4543.namprd04.prod.outlook.com
 (2603:10b6:805:a5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Fri, 18 Sep
 2020 13:29:03 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3370.019; Fri, 18 Sep 2020
 13:29:00 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Keith Busch <kbusch@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCHv3 2/4] nvme: translate zone resource errors
Thread-Topic: [PATCHv3 2/4] nvme: translate zone resource errors
Thread-Index: AQHWjUjpDWYPCX4jkESswoik4Y/w1g==
Date:   Fri, 18 Sep 2020 13:29:00 +0000
Message-ID: <SN4PR0401MB35981EF822D883E062E633989B3F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200917231841.4029747-1-kbusch@kernel.org>
 <20200917231841.4029747-3-kbusch@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1460:3d01:8d9e:cb93:a2df:3de3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3d6bb88a-6165-4963-c35a-08d85bd6cdd5
x-ms-traffictypediagnostic: SN6PR04MB4543:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB4543570C9713F9B5545233B79B3F0@SN6PR04MB4543.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wi7iaWxqbtixwDmpO06ZZbhsIIMY3dAwegCHlS7siRp11SS0bMqYZHH/Y4b1LpVr0UnApygRkJXkeaBwV/xJ1TB4Kp37kES8P1o/csjn1rEim7FKT7BNiRa3kKJb50xBFsH9RSD+GycUpG94iSGsEbaX04Fd2JD5loP2ypw6huDGrl0xSFNK/JvuIejr3pQubMRN6Shpqqfr7j5+N4WC3aYNnbsofmwVhEp/cjdvkB4KxnkF5JZJP6H6QEQBlE5Va0ErmflDjTCUpxdDkUI9jS9WkuwFP5QW/udd4cqvAMe53LpUwi53Fq+4N6Ft739fiws/6JzQQnhTVIQbXGJ9JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(8676002)(6506007)(558084003)(33656002)(186003)(91956017)(4270600006)(54906003)(2906002)(64756008)(66556008)(66476007)(66946007)(19618925003)(8936002)(66446008)(7696005)(76116006)(5660300002)(55016002)(86362001)(478600001)(110136005)(316002)(71200400001)(52536014)(9686003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MCYi92rM24wPMd48LjUQIQC3KkDxJAbjG2ZwCvHKYJhbkQ40smotBy1LP+fY5XZ8f+Xx70X9xfrnpQR+i3P/3DqZsOIW+2rlw0qQNTNJQcFyiZXuBxdkkjaxVzI4kzOtrVbvzYhXUR2P5554g2O3FjsbT3jECJrwRIbd8pELWb/WjMNaAP+oONg1VJt5Rpb1NCZrr8/Q1bmE7J4bVRVXq6wdtDvBVexno0wqvuz0MJJ9HvEPRCnObGRV19ugFIYCQmGhwYj+56PjJ4WhcDTzYDNmp5YtXak1GbSyr41VgRxh+J7nncOoTqHHtv0+mfS9B1C/d+P5FcfbVftusx7rqsiv8f5zsRsdaqs/zEsBlFH0ngi/2jF1OnS4oKsy7olyCHmoE4y44Sn9axWzFIQHwELmPBfzWpqxYIBukD3tiusKRiYKQ0W+Dr+DZTYtLdkQL13aD6eYimIr7fAClCGMtgMnemZr/1I4MvpdokbRmFzshmnZ/mLdWJeZ0WeeqoV2u2y+62GGs1s8G3yE9i1dwBORL7cvWyfZMJPgxDYmhB2UvmLvzka3HpVmQ3Ay4pkt2e4dHzzU+/O23GgTbD9HJ7ka6QgS87yOKa8+bLg/WoZH24vLqLkyvCCcsdBCczJaVoyt11PmZddMuVaiKOMSNdGoh7sXqBRRxTAVveodOAGvv1lWqngazsfko5VMGHPbcyxQkYHZ+xG+52t6kLrM3g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d6bb88a-6165-4963-c35a-08d85bd6cdd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 13:29:00.6013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0QOL/TB9JGjKrhz+UIL3PjxAx1lMLplokHSVhqZ0QHkEMog21h1MYv4TjFHkfIHOrnYBcWJIVNieIfhDRN3xYtAcNjodleeMFPPbS1YY/Bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4543
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Easy enough,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
