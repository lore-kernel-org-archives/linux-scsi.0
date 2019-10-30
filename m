Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D739CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:20:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2847520862
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 11:20:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="OYIDrM50";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="YZU1z8bn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbfJ3LUk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 07:20:40 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:65228 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfJ3LUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 07:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1572434440; x=1603970440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SDoz9JIs07EGNtsCYaZlCrnXsD5QilzoSBIpd2F/daM=;
  b=OYIDrM506QFvnhemGDN5edtktTV/9FWQpLRsqFvzvR6gYm5kv6Fwt5XK
   7SZVUeGVfBDiYzCCenx4EqB7OcC6Gt6hELK7+RDOUeAWaaFfRByMk/7y/
   Q6uopXXYjBhGi6Z4mTD0cC0zoiG7y45dohoNkGUbBmb2TlmHUpsfXMaTD
   uETnqQGqczvtD1tOc8x/JgTlpH2UWA584+rI4E7fjEUvP6fYYhFrYOIw3
   gx/BYZS58sUgR/Zob7BxqpaT+rVdAagGNcminRPk0967DMy9r9DyGFMfL
   eqG0y4sRn/StExH9+P/8bwm65gsVnO+tfEZQ12S/jW3R6MVsIXeV72phF
   A==;
IronPort-SDR: Y7nRPQH5dmQdWL8iBoeUV1ko3LXBIAWnsoAtP7BBjC7eBRkXJkCJewAaPGCdpn2tUHbfjwZ8EY
 FHTLfz+h7wZCMNcKHtkWZHTZBKhuzLBnlagGXDZeKObo8gZexueAXNEyTiyo9BzJdknfNc7q0k
 qgkb5wJk8OJWC3X+VieZJS3y56CxAr+A2z9lPuDvFIkE7zgJeS9X/z4B6zIX12VvKTj9ZF/Udl
 6oz+6kvvNd2gYpFVbn/VUG+vsCa49xBvnm0gAeE9J9+hXe+OaYAWWdtBKCF82GrVAJn5Um3Ddw
 C4M=
X-IronPort-AV: E=Sophos;i="5.68,247,1569254400"; 
   d="scan'208";a="126106946"
Received: from mail-co1nam05lp2055.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.55])
  by ob1.hgst.iphmx.com with ESMTP; 30 Oct 2019 19:20:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZyBvZ2P1vV0ua+XZcGCuSGy53AJoLz1x9iGpVAYxxwS83pYsHYRFb9Xegrw5Voqs/nm9z/iLmhP0QIP9J/FS9R59AlF4hpLrIzsvP5B95AnW3MbKlYzRgfuBwtFcQEamg6bEMxuvazZm5LOC4y6QPm+fSBggP3weg4dnY3RizchL62NwgViGqW8Em6gOZC4lLfOW98WtA8wIuSQNjHkbbzLSYoM5691YDGVkgOxmSLH41TssiLuC00cBCxf9Tw3dN2DbqykcMe7NB9EdnQZ23Ct69rb+gn+kcOJ+YSxHE62i25EiIVEfNsDu5zi5N2oojQ2SAHgvpnGGNntHIWNTAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDoz9JIs07EGNtsCYaZlCrnXsD5QilzoSBIpd2F/daM=;
 b=cPZ1G570e4yGJe6EQZRLMJ5tNFMsJDqB2FcVd7MsWxD+tuN26QezMYBJc1FsmlM5qWBnrh9rn4eQUh/SoLEcaA6cpHcCWF+OmqHOI6XiStb0gxu3NfVbXQn2kAVGJHc9xR7EQ7mPyGSQLo2Jv+ZQOPNvLLJCccp8yy2A5uwCiiPxot5+tB8fNwj5XWc2awZUI6X8+gjbNvP6bfPL/ClP7MG3+Zu1Umsj6Hf/KiLpVtuVOsEKeALLJUfZQMnql9/iwRylVl8PcON+nUGSgzmYAi8O/Xrmh98omgDGTCNxiXhOkEKN3vPSdNGJlJ2dz87RY9hjVtLV5BZnxD3jG52Hag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SDoz9JIs07EGNtsCYaZlCrnXsD5QilzoSBIpd2F/daM=;
 b=YZU1z8bnpKuzMgfH35kPW6NnKtg6S6VyzNOAvOFt+PPxwljKSf4Fz1SY135sJgeE0YVrYWHuSV63STRoP6HuFT/TXi/K+AgKPSqMgJKyajMuOab8h3GQh2y7vqbZUwo7oZXlBTKptk4+DBH14LrjVqoMBRjY/TQPB1U/nK9dipk=
Received: from MN2PR04MB6991.namprd04.prod.outlook.com (10.186.144.209) by
 MN2PR04MB5757.namprd04.prod.outlook.com (20.179.21.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.23; Wed, 30 Oct 2019 11:20:37 +0000
Received: from MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce]) by MN2PR04MB6991.namprd04.prod.outlook.com
 ([fe80::5852:6199:7952:c2ce%7]) with mapi id 15.20.2408.018; Wed, 30 Oct 2019
 11:20:37 +0000
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
Subject: RE: [PATCH 1/3] ufs: Fix kernel-doc warnings
Thread-Topic: [PATCH 1/3] ufs: Fix kernel-doc warnings
Thread-Index: AQHVjq2hoBlj4/okiEal3S2XtonlUKdzCoxw
Date:   Wed, 30 Oct 2019 11:20:37 +0000
Message-ID: <MN2PR04MB6991C67C132754E283EEF1FEFC600@MN2PR04MB6991.namprd04.prod.outlook.com>
References: <20191029230710.211926-1-bvanassche@acm.org>
 <20191029230710.211926-2-bvanassche@acm.org>
In-Reply-To: <20191029230710.211926-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Avri.Altman@wdc.com; 
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dff30f0d-d0b1-41a7-a247-08d75d2b30c5
x-ms-traffictypediagnostic: MN2PR04MB5757:
x-microsoft-antispam-prvs: <MN2PR04MB5757A5F1D69A6D2D48269A0CFC600@MN2PR04MB5757.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(199004)(189003)(76116006)(66446008)(256004)(74316002)(14444005)(7696005)(9686003)(8936002)(76176011)(446003)(110136005)(54906003)(4744005)(7736002)(476003)(26005)(64756008)(66946007)(486006)(11346002)(66556008)(66476007)(5660300002)(81166006)(81156014)(478600001)(6246003)(14454004)(102836004)(25786009)(52536014)(99286004)(305945005)(6506007)(86362001)(8676002)(3846002)(6116002)(71200400001)(71190400001)(6436002)(316002)(4326008)(33656002)(229853002)(2906002)(66066001)(55016002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5757;H:MN2PR04MB6991.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OWTqDK7ou5rn1utKNv+u1VPXKAGQgqj+ggV2Ucb/FOXXUZ9JqwVwujpx6bMZ0OYAtgy+x1KD1t3NTXNUjoU8d5BJx9dLAeH5I6gqGjL+z1t+uZEihaJ842OkzR+PuDMabTmBngmIXlz8/eDEgxwaYtfuroWvHSeGTir+pGkpJvjzcWVVJBBu3/hOqcAeCo/YzDmFiEy+XkbUEDWtAhkMUzong5jhcVGIeO2AGEEM+Tn/GEPcfz2VXnQvpmTcHZ+QT5zXXCorqMLmieTZxD8YXujzn4wSpPq1/O778MhUaF0UwkoDkz6XqcVCPKpAdMjDnzD1fEDBCByhohKCTgt3Eh+0VZ9426cfxT+i1uKMt1hMbkh366ILkTe8zreXl2LoGLjxgU7A7Hs3Q5wP/tKiZbZ/EsW/ZzQalYrxRILk3+z9zfsU+y1C1NaYNvS0BCvU
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dff30f0d-d0b1-41a7-a247-08d75d2b30c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 11:20:37.8653
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XfdC3p6aUeo07nldgj2v9n57f9b+nI1X9hFdCrrRqv0iGTxrku5nD9SFhbC1CKwamtmZY2VIKVHrZxLP24Om/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5757
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
>=20
> Fix the following three kernel-doc warnings:
>=20
> drivers/scsi/ufs/ufs_bsg.c:165: warning: Function parameter or member 'hb=
a'
> not described in 'ufs_bsg_remove'
> drivers/scsi/ufs/ufshcd.c:5789: warning: Function parameter or member
> 'cmd_type' not described in 'ufshcd_issue_devman_upiu_cmd'
> drivers/scsi/ufs/ufshcd.c:5789: warning: Excess function parameter 'msgco=
de'
> description in 'ufshcd_issue_devman_upiu_cmd'
>=20
> Cc: Yaniv Gardi <ygardi@codeaurora.org>
> Cc: Subhash Jadavani <subhashj@codeaurora.org>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

