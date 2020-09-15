Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57160C43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EAE3D20770
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 22:57:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eFCUS2ss";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KI3pVV+f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgIOW5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 18:57:37 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6029 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727306AbgIOPUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 11:20:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600183239; x=1631719239;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=MJGwv+fCDObMkEUlfKjrxxaUaD24OYnOha2OLOFVHug=;
  b=eFCUS2ssHe8RLp89tnZbg+ks+CeUxhhPyAiUy8MfNocOFMXZZ+RENQEo
   AMWB1dv6sofvRW+WoPWTXO0EaHa87fitDr4Ta7e7+o2IWE6fiNMDkGAAb
   tgLpbxOgjikDcm0Dmrf0TggPQPw3QFccYdIZPvgVb8o7qVXJhps2F5yLY
   9LyJc/Je8CUKHx1iZyw89KvIwVMBoyX+LrKTgh6GhDdNijogaVsfGtns+
   JV8jyVuBxcof+NJOGFWcc1XkQ9TJIpS0tXKENDT90fBAhfmd+s9K5rb+C
   LlTMKmum4mF7gUNjwm+3secC7VbkcCVPZQHVQn2N7dug3iUlNpG2G8ZLI
   A==;
IronPort-SDR: j3rGxcLur7LlqvKyrOylGnPS6dt3Q+bMZVMB/Dsr5T7gXhd97MUpL87fLfaNPUOVXs1o1z9Tvo
 axQqeCqqwi9RiPpsxQ0qWx65MTLg+c+pzcklEwSw9adHc69p0eB4blDPM2SsN2TJ0Vy4uOjyYU
 GyyLaSUce5RFH4DGiHQ/JfndPQDkuCRI4imFXejGYlqTAdc+UKcDHs5W4ZXrntPNuAd875CHDQ
 iUVKusRvslida5GdgVqhSdPqW7CxNX46dA5Hqs3ZAxm52pxhmElVghbV5BjCyVVlJXd+3kBwMz
 AGk=
X-IronPort-AV: E=Sophos;i="5.76,430,1592841600"; 
   d="scan'208";a="147353704"
Received: from mail-bn7nam10lp2104.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.104])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2020 23:20:34 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HdUUNloN14En/OzoVlR2pVhUrV7I0EHwnD1v9jpLVRGCN68JK2tNeSMJdZEw/h8pdACTA/ly9D5L3cLyEVoas9lJsz9WU8ST6CDz+sdMbf6/LNlYNpM+nS+eqxgexZGQnt2vE2g0Y+VxMBkR4LDQnD+Zrdjal0XKykbfqN/qsZZCONf+UsvDKNSdm685yj3sBz7Fy+12BcGyFW+asHaeDlI2RrxwMnH7GM8VDZflnLG0OfwNd+7qL8FtlKr1Ae8GxLUHDzAGHbwPraKSHVVN8qxnbzjUDfvE/K8ID+cThA1Z714QNZjSNC9ekrGDdhslKRJ2NwKkz9tLgq4RfvC5oA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJGwv+fCDObMkEUlfKjrxxaUaD24OYnOha2OLOFVHug=;
 b=VAwEMQLOFKoz4Ks7HTT3hegx1mCysz8/IPsaruq0qsFoUNhuBhahP2ez+SdiH6NCNbYkzB2v3FOE4gMW4h6LJHU7Gx+Xg2ZiK+OGE/AsomCosrZRd/xgw/AsfNdOHij7so0uFEqG0bfIK8T1mv419A8CE6aPvuQCRV1hFj4Vh+MJ948CR4oCdkKIS0CWHJEwZd+S1vOTy4B35/W19fLznyynZpDlAqLogq+1EM8ywG4kB+GlQ7PqlingzFiswArTZRt36aHh/UScap1PJOFfIaFZguKiwLaI2XcO26gmFyPyN1PkmCOqLvbzmklgHW3w2iODldugzLazXXFp/rylYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MJGwv+fCDObMkEUlfKjrxxaUaD24OYnOha2OLOFVHug=;
 b=KI3pVV+fXhdXTKBwYTnsyEMkLsJJrrpxIMAeLcbgJQz7qg5kyF03/Y06EEeHo8AxQZJANe/nYAGBqssAbMC2EYnhkt3Kj1pWLWSAsdU6Vy7NHR1cO+49TpNXnV2arkB/hVfHUu+lgWfJdHiGvtKymeQH2UUhx/wdWu5T1+8MBmo=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB3887.namprd04.prod.outlook.com
 (2603:10b6:805:49::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16; Tue, 15 Sep
 2020 15:20:33 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3370.019; Tue, 15 Sep 2020
 15:20:33 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Topic: [PATCH v3 1/2] scsi: Fix handling of host-aware ZBC disks
Thread-Index: AQHWizKQecPKfPPtxEyTOURisQm1hQ==
Date:   Tue, 15 Sep 2020 15:20:33 +0000
Message-ID: <SN4PR0401MB3598867907382F25F39317569B200@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200915073347.832424-1-damien.lemoal@wdc.com>
 <20200915073347.832424-2-damien.lemoal@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1460:3d01:38cf:f1ce:e1ec:d261]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3ab42785-ce80-4990-d92b-08d8598ae3e2
x-ms-traffictypediagnostic: SN6PR04MB3887:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB388772A7E65F40BD3497A1619B200@SN6PR04MB3887.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uXEoCBYBs/Xlq+LDPJKL4eq2meKLINW5CvMYpB/Rew2uGfbVLOmt0mzULQ2x+WXDyHTpE1x4xtOMI6o6ld8/J9mk2Wb9HPrAGMu5mD7sHtVqX0MHlFnPfe4Gnxlfw61RRjvYIP4U4te0uWir21FbQS0tEI9vI0P1zMY8ztpZVIRP7fWyNtUcPqNOnzfNrIzwP+r47m5aDXf21W8DReju39SUJTY6x9GAmnJSvjl7Y/8wLq8LlcdIKtFdWBul4f8j+dD6BVepXuHZQ74GlHnMKo5+GTZ0O7QRnNBI3Fudbj0fEtsA3OCC9nqXd19CJVszjpzuwUrbh0kDJkBaGZMDBkPkZy4xEm/cjqj30nKB6lCxXBH9Yejw1eC1SkNXzuyh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(4270600006)(33656002)(66476007)(558084003)(66446008)(64756008)(7696005)(66556008)(54906003)(86362001)(316002)(52536014)(66946007)(76116006)(91956017)(71200400001)(55016002)(9686003)(6506007)(5660300002)(110136005)(186003)(4326008)(478600001)(2906002)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: p4zyyJhJZACehfiFU47N8tF2W04i+UIkQQY80pMGDaAJqjTsrzITpfRjVphuCa/c0gKN9dWWAfV6C3xS2CVZnveE5esx4Ws29w9UwbYm6lhlsmKoYzPieXhQuFqVLlLAHTeZr7HHbLp/Sa5TfN1qe1nTElZbbKCqXz1cfIBCcXboqgWLyO/C0/jJzbeIk2siOpwUsUPI+IVy9ozS/l54gcr0NP+aIa+jDwpARjrUvm2mGYyMyprKzASzRihpXJGhJF8mtMKxV/ZQL9JiuT74OlaorQQFaiFd2mwlxlYWyaMpEepJ9fez/P+ffTomX+14v3GAagjMVDZN9JOIsekkhxSnNhwVCPnekLHOc3t73HNML6CkrayCRG6C0MxIBaHs+TWiKebkiplhjzxJ0TBMvxFEVhNdgvG7P0nqree7gojbhQgm0jjnnkhI4hT+VIW5RS8Vi+XJHvZOTXpxSVzusfrba/ImGnGdGpQrlbNv7gFmHYIVWl7Qe+O0dba+thtYl+519szIaodaa52Kqn5Rq48p2Mo8Vy16+1mRZLi+mIp6pxxMgmFt9drJ/O1kI4xrQsm1WuVARouh+0eJZj9tRj4beo9M7fOCV0g4tSfsPwPMrg7kL8RepUQEjnsye8gKH95Mb9DqW5Tc5HBp5hmFt+xfx8GQiimtSrmQMVMULFTPeilsUUEeK6nW30QKiXLWgqUJDH9coliXdQPWi/oUtw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ab42785-ce80-4990-d92b-08d8598ae3e2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2020 15:20:33.5119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ksC8U01Pkzm8QjwCJ5+g/E0LkgudRWnBlss6v90pb8HbICzb47zxNmPtVPvUJiaJE7K2zjA9/6u7zFVUBKOFmvv9C2qMlW6YY0XEfgMZYWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB3887
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Whoops forgot to reply,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
