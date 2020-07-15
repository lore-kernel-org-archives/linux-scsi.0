Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA75C433E5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:57:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 867312064C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 07:57:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="O9iczD9P";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="sCkBZ92I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgGOH5j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 03:57:39 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52328 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgGOH5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 03:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594799859; x=1626335859;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=O9iczD9Pd+O8quIbzq1tOkAZyDLlqShlTpCDvS2Dut7EKUE5shm1L8SU
   SuY2aBrVo9x1QgXMU8fNV3qMfhqp5Gt++0zdc4FXJR9qnub7B8Vs/I4RC
   z/s5482HGIkbGHw25C0cpCJY6JC+uO7K18to7JE7bmWuDWC7eP8N2GFtH
   IM0gGx7PfRDmEE0HVYFeqhIzUyPIN/22w8Nnxh2aJdwTpadnJgTJm6MeB
   u6mZjAJiRaPcSSVy59WkF7jXj2CzNw/rStjXwIEUBh28GRB+yA2nnOE8F
   RZM2bJcaSNBPN9udKnM7NCvEXwmsD9KsCcMZ7O/ARq8/qz68aSYP1q5Bw
   w==;
IronPort-SDR: cX5KbMLntV7xLJ+Bn/z1O3Yyy/Btz42Tddl3YPt4JKAVsZEnwmL3aNPpAuXWYEh+iuZuGL5sOg
 fxKEApQ/ELsH5jZLhcuGhCfjmzNNx9bP+llzARFfTxaVWXhvt//zoBYIMrPIopEqvz/sRhr5Wk
 uW5AkPT31WjzdjcOD9WhLwqbwa0Dd2gwoK2w+Y8v0vqBJAFx1rL78BfnbFVCR+iTEnDIYTaoji
 10O2my9vEhBHMcWilY52FfbtcwptYpJKdb4rRcuDxv1T5ro151N+5CGnvxebhOhJEoq6/T25xJ
 n+A=
X-IronPort-AV: E=Sophos;i="5.75,354,1589212800"; 
   d="scan'208";a="146812075"
Received: from mail-bn7nam10lp2106.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.106])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 15:57:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Py5I41y3KEraBgknF37gZsZpWiYi/mALkVUPs83fjIHA3cIecJteMVqMD1I7cDKAJZmTOLT9lBFvkoe8V+Xc7qMVMXdPMy8BrSuFfNEIcN5KEmZ2n6CsLYp9afZk32tOqBMANJCH8YOYGAT9j7++KHAj4TYOP1g0K1sCIMHe5ShIgpS7YByAAHTtF69rtMkNVziGlJYyjm7da9bIcoPLEngBYSCqmLpuvz+TRQ4MetWJW1ucpTntwzzql17GShhJY7KqMEv+qttdAwwleCVE4+YCiPagAEuTSueJBQU2P3WhkEyBLzJ4NtXYHn+n7L1vlTJiE0aqpn8W2A7fUTiwxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=oWP3grGaURt7/ECUyvC4N2LNhw4L7/aZWGkZlCsFWZKO088xQkp656qQgOcqJBok8MjLdr6+TLR+s2Uq2CHPTRatCQ0OOsox4auihqAObcpTyutp3GRhEDrDyrhTAgbnpvURC0qw76iKCWtLvuxgwwdupTVAnmihtG9aFnFqCknlkWugLbk2qRk2hiZSF2qUSoEAVxFgExzX646SrhL3ClooZ2DixHkgEm6H4OOZufskczgQOAwlnCmHJcIw6cpkW5iy4aZwSjj/WXLilXdZA9v1KXS6ShPomE55ka47sNlpy6R+Z7Nt3UF9A54DstdmmeBL7EqQAc1MYQ/4PG7uLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=sCkBZ92IEwaGExdKaa3YCD4jbNOUlQWXyYWwInFdhxq5lvlQ/TZxHQho5vwdY9zEPl3p4Hd+O+HeI2ZLMPY4Anh0AKxc/WL/3HfV00iPwRvppfCZ2PSkV5z63C97H5WX0BaCt2mBVkTNZ7uHvkq9LftckdGwtdfH3UeQYIyi1iM=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB5248.namprd04.prod.outlook.com
 (2603:10b6:805:fc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 07:57:35 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 07:57:35 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] block: add max_active_zones to blk-sysfs
Thread-Topic: [PATCH v3 2/2] block: add max_active_zones to blk-sysfs
Thread-Index: AQHWWiRjfWZ6hdXePEOmoN+no96YEA==
Date:   Wed, 15 Jul 2020 07:57:35 +0000
Message-ID: <SN4PR0401MB3598093418CA2F80F019C70E9B7E0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200714211824.759224-1-niklas.cassel@wdc.com>
 <20200714211824.759224-3-niklas.cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:853f:9b43:c773:dd89]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d3dc1485-a16c-4906-4e77-08d82894bc70
x-ms-traffictypediagnostic: SN6PR04MB5248:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB5248A8FBBF187FA097314BEA9B7E0@SN6PR04MB5248.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i42W09O+1nTo+ObjXOkLQjE7JyOLwA1eoN1C6FNXKPtOOcfV/w3pIJHWqJ5XLU/shvSJzKlViSEbby8Ifx0xvZ5jaFr6Zsj2MKln8ucYFZYphEYw/5S14hoGMNvTArDnix5XoxFplYFV8ParUKICwLhhdg53OECMpW3mE8FI0v0h5vaZ7HvUBB/dS1aGS2dmSHJk4xIcpi5BU6d9amsRU4S5k/mPTI3eywkPKg3SoNZI/fh7aBTTiUyiIOOalfTyoJTs/HwTMWJClaONGQTop/WgoOI57tvzjQ4+pM8/30E4yTs8SrnvcHhHP4f6P44n//nm5HvwEEIelpO6LQ/Kbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(396003)(136003)(376002)(346002)(478600001)(54906003)(8936002)(7696005)(7416002)(186003)(9686003)(110136005)(2906002)(6506007)(4326008)(55016002)(52536014)(33656002)(71200400001)(5660300002)(66446008)(64756008)(558084003)(19618925003)(4270600006)(76116006)(91956017)(66476007)(66556008)(66946007)(86362001)(316002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: iv4I8vgzFjqjlNuq5x+pUwpVyItUOmMqnevtNtyZBlCylDGiC86w6MLQY1X/2ukD9cWRSncqEkt/p1XWzoP5BZmIRr5EeDdkJvBKMzpp9Dbn+h99/Ym6hyI21ai0BnLNx8Lou2aluPB4Yipi/c0nuZPATTTCLTceuOz6ndzx3l1A6LmeW7daSMIBh2r+zTS4fg2p3SLa6Iq5JOXfErxn9Lmw88/Rc/710XtEeI4yLWlLIJbf1MXWI/dlCpFi3HyEoytHgFlpWfJbHnLsEiAAupc/y/JZptqwGfyP4FdVIli9+tiPv9wWI6Q0GbAQQ6U7CeZeumbcT8sXMShGdiLCWYAku/5urMGGoJpuDm6Cz3NzuDMrDfFInmuyiaMLE7RvGfMwEeJna6+e+Fk20+FXsMCDCuGYWQ84bYqgja9CUYXAXUrpnNFLmFf4rWAULTl5gShGa8FAgDISPnFqPk25yVX/IYMWYae1w1sUwS3m77+7UP2aNL45aROVqUA0mnLkU3prAPSSLR1nFpDlXbNED7SxMWLIcgkzqYUq5OjqwIYZvCocQd2fp3WgmuMjE+nP
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3dc1485-a16c-4906-4e77-08d82894bc70
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2020 07:57:35.2993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: euL1MeDHGcgwD9HRnEvmgxKarLxpahT7HxKhteCmWC7RhuS6fjFK8gGSbXexTQU4LASHLM2zJLxHhF+GM5tjXi6wsNsWG6xzZGTxnxysh8Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB5248
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
