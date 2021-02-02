Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26455C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C121364E4F
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Feb 2021 11:22:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhBBLWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Feb 2021 06:22:09 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:19091 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhBBLWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2021 06:22:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612265782; x=1643801782;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/G87jwiiI4upcDProjWUQ6ykiHd8BzHCdQVXb4Ql+bg=;
  b=F6tIWCnj4ge9PaENw88KiOAgoVS5C3GWdJOaLnGDxQlV7kVOH+OQpPtA
   u4izmbkhxxYuZWWx7veubUDdpwM+vvISvU6n9yKAFTkOXlabsnP7TUwGk
   zBRZY1ypv5OLokjjalFpX6Sd84kywFgHNoRVjn1d8DKDJXFSSzRV5cglL
   6d7A9o2k5ZUB0bOqF+tAkYjv3BjFk4G/DdqLnMZ4PdbWjrXB1lU2EalZ4
   ddPIQgHMhP02s+tDaaXCHsuGfzvAh71RMKtz+rR4kccVLXsoYlqCVPA4k
   EBPs0UuKbrYjhoxzNZfdnlNM+aGqO6lD5YtX4m7QdujmtPuV8t89s5h2A
   Q==;
IronPort-SDR: hEdsBRRmc6oizwtrQVNL/wuc6r5JTKJ5L1Px00vaXbRIyXGPklzmLZT5e6/fC8CnYGm2lN9iWq
 Kd7UeYqVKVLbBkX/HDjsB/7R9Wq3jRANSShLjKZNtaSWUWT9jhiRU3aQ7sEKoU8TfX8NweLvOx
 JJg4MwFS6L+plbq/JN+pUnnz/dDIx0WA61gMB4zrsko14ghOgimOu7pNCbG5AzEbipNziH8XYY
 DSXFmtPpgi76w/6tn07uyy8khXzvSRZAOKVywvWXiBwavaXjFMec7Lv13SXFugmBYz8USEqFft
 HiY=
X-IronPort-AV: E=Sophos;i="5.79,394,1602518400"; 
   d="scan'208";a="262991073"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 02 Feb 2021 19:34:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCurrq6voYmlcZ7TN5LlNj83M/q5lJHl/EIfw4wiUw6mjiL9T71eR0vPDZEUX/JJv7vZMbmVIJ79caQ4Yb0Cc29PPu3z2RpcC30E6KR8dWAv29ttS6nrSbKjZOW3Yuft9iH4oNAul9u3mEYzev9714qblMBqWC21Ty7xr8arlHOuIKmZ6OuEQlNPwfGMJQ4/jtT1g2ntrEJxXcEfDt0sq+GL7GxRkN3xGB7dffiKhuX0v74XnRJRK2tymN4TcWduWxDxX8h6yA7+PivvwfH82Skk3Qucy/Ybf50kNMiqEgqjiCQOKppC2v0TsvWqNFFTTQcVnMWhIAPrq4NaUaOL5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpUD3xyQQpMevAc+xFOi5W9Qr6ln+tSGUdkycMRWd/E=;
 b=gD/b+Vi13b+CxC1K1ipK85lxV+PwdBG27cTVNgLQUrPEfpoC7uUurYy+HIYRmP7WTkt1TeK44sn+QYfhtn0y00555i3K/THPYpTz6Dbp9X64Np0EG9xtogSi5wrzIfA9AdHTHGpWCuII8W92Y594JhL/9uCMMq+HGPAJvRoWe8VDGb3u0CAddryVH60i+h8aWo9hNTmUHPXjpdarx3CNZxEYk+YGtrFAoxEBj6uqDwNb6Fnpya8dSCfibE/arVosrS0NzVs8hjLq42jr8LXk1R38hlDD6xlaEOHQEcmsAhhboyzcMgKy5dWAKWpAY0oOcmyzG4RBAzIXf/jB88NWvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpUD3xyQQpMevAc+xFOi5W9Qr6ln+tSGUdkycMRWd/E=;
 b=ubj/O8YQM8d2EvJL84HahDuxpU1bZkhzNhY+kofDU3qRXSe6+OieGcmR12Y58puyzzf95fa1Bn25g4p+VsO66quiESdU8mZw9jYeL2mooeXCidMCdtvFsnvVQs1rGnABGCWuhn3MwujBqJdtGJyZ7Uo5ANNrq+7tXLlZtW34YTY=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0266.namprd04.prod.outlook.com (2603:10b6:3:6e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.19; Tue, 2 Feb 2021 11:20:58 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 11:20:58 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Topic: [PATCH v2 9/9] scsi: ufshpb: Make host mode parameters
 configurable
Thread-Index: AQHW+T3hFFjX8Zgjx0+EZ0J0IzMsLqpEt+SAgAAAf3A=
Date:   Tue, 2 Feb 2021 11:20:58 +0000
Message-ID: <DM6PR04MB65759CC63EB06C365FC36CD5FCB59@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210202083007.104050-1-avri.altman@wdc.com>
 <20210202083007.104050-10-avri.altman@wdc.com> <YBk1HZijbtkMrO0O@kroah.com>
In-Reply-To: <YBk1HZijbtkMrO0O@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 62509031-be49-497d-ccd0-08d8c76c9d65
x-ms-traffictypediagnostic: DM5PR04MB0266:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB026627C22D0EE3C154A95178FCB59@DM5PR04MB0266.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fvo2TkICidap1ePZQx1sYr2oeIU4Cbs3iYk3nMXubsM3zZMDdLMtCxMfG3+1l20664DNeenbV28e03Yqx9v9BYETQLLifguHRdYieW6hcpGPM3t64BFgg78CSP26caZmG0XXioG7eRBl6CpcJrRh1mRIOhzIxyrGv5uN1pxFDe+I7uXZRqL2DKj1O2XbmRVBYl2oSHv+Yvmr9fHQXuz/Gvr5yiTX6wXH5KhNiaWj1wuvoPMc6+dc1+fyIxRHVdFGChQk2sz6qXbMF1ResHQwIIe9gcSnhYSU5RGVBSw3DLuTsjwyDoSUA02/cvxbn+vXVd8p9NgjylQwS6v/eeVp/3OQO0D5KvXKZbSsryAB0yA/OkaHdPZxCOGaQ3e1/7ZXtyWvURom8gzvYkU6TXcPI3XoFhGFXkTagJafi7B+IKTMZAWri+dVOObgo/cB3ydW0RyrDpNvpiOfnp3Vpu5Yu8GdXKE36Qq9eNLnHVJaQBGMSM0+hDLtRKUO7FOUle0W6rsz730CzhgrOuTvzWD25w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(558084003)(8676002)(4326008)(66446008)(6506007)(186003)(64756008)(66476007)(26005)(7416002)(33656002)(66556008)(8936002)(66946007)(7696005)(2906002)(54906003)(86362001)(55016002)(71200400001)(316002)(6916009)(9686003)(5660300002)(478600001)(76116006)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pLDDfMwii5gf6ciCRrRc939gUBDNGoboPt1GDCb8ZV/TWB7txPc17Ix/2vDS?=
 =?us-ascii?Q?dFWhqbINQWckmZF+ejtsA4Z1gqOe2IkSR+QGWAC0Qqx4M3o1Vu4kQhiSGCXX?=
 =?us-ascii?Q?yehar02bUw9HE+RbEXOB7T34i5soyEGKBuSihkNbstUn4C7pIBRqxVFmXD1o?=
 =?us-ascii?Q?av0R+beGLkQw5NKWbmVDFF8t4CAjHBKMzNpZGBSIHU9EZoFlVcT432S5JJ23?=
 =?us-ascii?Q?Kg6mY17CKR9G+2jV7B1guxsNiZuv4yYqaICisA0I8N67pgEVqGvtZwgMvO6F?=
 =?us-ascii?Q?Q/TwWY+wcP0DqrrI6i4xv67UXTs8x9uuSNwMH7+R7HfKcHifriOqUVcaKvk2?=
 =?us-ascii?Q?ine5mQkO0fVlu+PJMPWTtguR6yxTC0Z2tPAVa9Emmj8E/i7SyhZgRo2ry2Vv?=
 =?us-ascii?Q?Lh+2CdFJ2M9TmYnxGUS++bM9S0+GshJ9nwmuckBBV/CRZcZtefCP2+FYXJwf?=
 =?us-ascii?Q?CBj9Rx1Fo9cXReHly55/gctkTr3UQrV7g2bZjBLkBCNTVEbfqqS7Ytw0WIg+?=
 =?us-ascii?Q?BVrpA8G8/lIc7VfHFWKikGu3wUH79oFPFHyjJxEBVssQAvwA0YrrMAmeAqHr?=
 =?us-ascii?Q?qjy1xOHNqpecOTkgFJFV1lLn2IROIeQCmSfpmQ0nIA3h+1tSfFg7PJrDm704?=
 =?us-ascii?Q?qUEe8yeWA/1SIUWB+sQV+d9EqXhm3YpGndsglK4ZtXAfCrGVv5urtZkicSqV?=
 =?us-ascii?Q?qMN3YGAbqV0Ht2qrnHbk/ZhS8tRtaE5AvHNzm/xNLLE3GJN/7F9W0LBI8wTn?=
 =?us-ascii?Q?kmigsLXgklXcN2fPinacqJgO1KGzkKGj24RleDCc+H7PoxTLau5oN+DlIYCJ?=
 =?us-ascii?Q?9fVgxS2xW/M4+GS0MeLiYHc/cplWAfco7lMs1hseRxTMvjAHEzVyEdVPAOQx?=
 =?us-ascii?Q?nMHTNjq2w5xhXa30MOjCxTqolJ2I65JxVsUSK0pz4f+P7amXhHwBnJzrHwYY?=
 =?us-ascii?Q?bExQ9e2RCf2YrUQhJiRjlzk/WD4++2/jOmDwku79bepKXSaywHBkk99gq9iU?=
 =?us-ascii?Q?USpZxxPNUJkaMzLuz9uF0mPPPxnVDSkTIthfM3zTmOsFYjNeWeIVSWVjMONN?=
 =?us-ascii?Q?r8t5XmI6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62509031-be49-497d-ccd0-08d8c76c9d65
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2021 11:20:58.2989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JgGR1mFjrd8AZv0ETBwTGmoEpg+bOB4DnsIcZpxfWEHfb4lys1VD2zhfUhE6HW+ffmqkscA+lxtDkxnbt34v3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0266
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On Tue, Feb 02, 2021 at 10:30:07AM +0200, Avri Altman wrote:
> > +struct attribute_group ufs_sysfs_hpb_param_group =3D {
> > +     .name =3D "hpb_param_sysfs",
>=20
> Shouldn't this be "hpb_param"?  Why the trailing "_sysfs", doesn't that
> look odd in the directory path?
Done.
