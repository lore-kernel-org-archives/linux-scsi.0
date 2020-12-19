Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4CFDC4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 12:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7216F2388E
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 12:50:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgLSMtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Dec 2020 07:49:41 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:51990 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726564AbgLSMtj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Dec 2020 07:49:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1608382179; x=1639918179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1k6MEchVqASm+ezX6uVkva+T0omXRetVE4F+VT3rk0U=;
  b=XN6Yee8+FOoNfrAR5elpifh8uufIAvo6wseozJNC3APOvLbaP+juLhe0
   /+DjYKkEjXtC+Up4BOKf21Gb2nVA/fxiga3WufTceWmTKiVevwQc3ORQi
   y46yzzBmo1/8OndYOcpWztuea8+0jphUYXPqRDs/IViScuwbvNlzVVzBj
   Ajatj9bAYNtxa+jlJkqRAArsagjoH3mgOhVT53JtQxqrP05JPnC6vxP9e
   XPQJ/ohqCrR7yx+C/FAahxcqwWWbs+BcbYBwEk3azaxZ32Lww8lIG0JnQ
   PAunLE68hUuLgxqpOOrcfh8+lJ7lqNyGdXuf2BND82zZyHiOmhKkHrK1g
   A==;
IronPort-SDR: vOOXgB1YYRQ9DNNhNC2hxFEZ1FvGi6nm7htOW/KImcp1WqQoQi6QKLdyEUjPM65D2ZTMpY9bng
 Tu0Eex+/KH3tetWMSfC0PYc05WZc+g1CpGnP9LgCrf8A/2ED6OvpRcMd+aekA+ogjIMSsJDJdD
 nQaMAEqGgvUcwVaQsaeI68VmC9vLzqK0giDBUceIG6tfk5dFcVlB9UCUgLh4SJriKKRntDXuYJ
 PojlAb0GjxCuRj7O5H/cXtClOIw0EyJAhhzFYMk48frgA8aLnfDXRTXPqEjmBj5fJy5Qnm6xTW
 CW4=
X-IronPort-AV: E=Sophos;i="5.78,433,1599494400"; 
   d="scan'208";a="159995505"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 19 Dec 2020 20:48:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WjJyW/D2QleZFUxSf8L5xlZ+LGFa4a24ONAT26aXuByYmuXf7hSxbC9jKOP7EGgbrnueYZoPqJEXD8a/toqkXRi8Ih+ByKSgoHZ2ESFeTm/aaDYD8Scajf96fJYx78w+wVLNEVXqMejeP6gcUVz6hArmlMXV1Uu0g41eg3jicMz7b8k4nNsDuiinIA9MIdxVzmn8gTjQPjy8n+fMZekN6HZ4FuisrYJgb+DHPOw237NB2ZLMharz4GbNqv646a+y1YKlbhWVfv6ohtDXHqyj/7f9C8EUzSlcCHBDWvU2D44uQQfnvR5NVu3jhNR/ETyP1Lq+BsWk0YvFhuEAlE3NhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urtqZDo/kRptlRat9qGr1aP2z18/XoOJ5EBOl57qD90=;
 b=lkYUYaJGdmj7Fa4o2Uh+QI9uA/h+S2uc7RQk3EsGAhk/yAWYYPwp21e8widCsQOUOLfxiOfVvX1JwrDbsvfAU+PunOSBul+dqWdpqXADzEqW0F3s2dqJnbEC+Z7aVtF12p1Z4PoIdFi5M6KbHl5G//ZslPvkFB6tkbDTCbWAWH7DKtd2wgQ1aPideyJmTenbNblyYBljyvKYlJyD34K8zkd54EncBk6nSeexxmBnYf0ZAgK5HftAvcMDbGybh4Pqy0RK/R1eUR+rJVzVysSOFMYM6ch71g+lt1XLqH9volM4GUY1CCAbis8ASqes3uXi8Ar/IbQZxaxWsj2+hBQQwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=urtqZDo/kRptlRat9qGr1aP2z18/XoOJ5EBOl57qD90=;
 b=fQLTtOn40Fk+CwMpqVWHbIbiw45+rq2gEF2jAwZnQVpdjeBtWiFZSODo1G5JKM9OSB1RILX+5XX0tcGrfVFOn0bv0r8HpPoxcgbQFx44ylaKDkP4ZKlJwwApc7tVXT6E4wa5XM4dlswk3XPPZvzKoCyV+Ys9ZpCalc5U8dU1Nvk=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4027.namprd04.prod.outlook.com (2603:10b6:5:ac::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3676.29; Sat, 19 Dec 2020 12:48:31 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::a564:c676:b866:34f6%9]) with mapi id 15.20.3676.031; Sat, 19 Dec 2020
 12:48:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: RE: [PATCH v16 1/3] scsi: ufs: Introduce HPB feature
Thread-Topic: [PATCH v16 1/3] scsi: ufs: Introduce HPB feature
Thread-Index: AQHW1ef8ia5Se8hQe0WKINuS/BY2sqn+OdsAgAAi5AA=
Date:   Sat, 19 Dec 2020 12:48:31 +0000
Message-ID: <DM6PR04MB6575AC2A541FCAAB60E581FBFCC20@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p2>
 <CGME20201219091802epcms2p2c86f7ae2e81aa015702572a8ef180dae@epcms2p7>
 <20201219091847epcms2p7afeebd03c47eed0b65f89375a881233e@epcms2p7>
 <X93XuJ4lsQbBgnU+@kroah.com>
In-Reply-To: <X93XuJ4lsQbBgnU+@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ee47110-1e18-47a4-8d58-08d8a41c63ca
x-ms-traffictypediagnostic: DM6PR04MB4027:
x-microsoft-antispam-prvs: <DM6PR04MB40272D4477CD79480118A648FCC20@DM6PR04MB4027.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: El+bWaP37uXymG1lOU21Tx4FVFLbDy1LVmJ0jFEi36eK80oyIzgwOg32gm2h9dDa/fzJ3mAzFMxWaTH9xj/0BhnS7bEkgSi8AC8sNuG/W6UXUfYbquKJ4+cV//+KvxNoSONLz0gG9L5+zGMB+E7UPbu60AzuAdURH8+KuEQof+Hf8WXqjgcmX/Ye8B4hosznDBMP7bY5WIWeNY9EziE79PlD9IrhcmUJCrkJUQIQDyAei1wUWzVkfeuEoPX4FPOmEjYFtrYMZoYP0FqfEF0NNUu4q2GKMgwYCss6STkmE2yZKzcmPTTBJ3cCBYo3uRrpAp+zt6o6rClUvmP3NcW8I5pzm2u7P4hXOOYQDaIcBRkyIQzxgsUIlEHaCC6SS8OIMyx3DInVVc6fohpUzncbrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(316002)(76116006)(4744005)(66946007)(54906003)(110136005)(86362001)(64756008)(66446008)(66476007)(66556008)(2906002)(7696005)(6506007)(33656002)(52536014)(5660300002)(83380400001)(8936002)(186003)(9686003)(55016002)(478600001)(4326008)(7416002)(8676002)(71200400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9/8yiNZfLQw4LJIFyWQkjVSBnSeiqIx15/Dp4WKpsu8G1LlJyJARa2UBIXxh?=
 =?us-ascii?Q?z8wGmrz5OaKDDT5vM0PMDTifDzn8+LMiQlH1nPkljShzydha4OicQAKgg2eV?=
 =?us-ascii?Q?cOaMezbKjSHS9PDFAB+4LKv4GnwY8UxuQ66vvicQ2/fVQrv3/qpWcvVJmjcz?=
 =?us-ascii?Q?bhCBTGNHhwbgIw41bfZ26JsmrZqwv0arc4vK3dNautA0W1H3e7zIx1VFxx/4?=
 =?us-ascii?Q?lyrxUElPLj84jIOM9sIKuU+XvcUgypxwsQGav6jbq1WvYd6uWcMxyUvbff8f?=
 =?us-ascii?Q?bbK27Znm6pf6W6O3MC+Y+/DlQGBY/UljaWWk9cjdA/a8FQ5sk/nGQ+NdStye?=
 =?us-ascii?Q?ffBzIoUt4R/T8vCmz/fp/+R+2se1eTfihKdQ2Gsn7yWi9SdljxwnBQwYo7bk?=
 =?us-ascii?Q?3KjfgNdI4Hs+1ndDtrES8IIgUwf/1yPF5rSfPzj5bEHRxBVSmAsjD9UeCyrU?=
 =?us-ascii?Q?lWKgvs3WOYm3N7OBom8Hc/vs6QwqqwD1TjU4+tFUXoKZwywLQ2hW/Hf5tME2?=
 =?us-ascii?Q?jPbvd4fnyI8m4BmDL3echUmp16moA87Vxpv2QqFBfrxMZkFmEjD7wBKrwcg1?=
 =?us-ascii?Q?Msq3MguygdoyqrAsx7hMzdXpEH2nl0UyC7vgo6UJPxMH1L7mEnsmuGILqPjH?=
 =?us-ascii?Q?3N/7FSD5a1OUuNxqrwJHuNlxEp3+UmqZ6K/aoA/TCfGwpGDqJoJMFDul2mOz?=
 =?us-ascii?Q?+LA9dDU0kq99Of5TCLc4FH04iHX2J9IaagE+jKoqRg8r1UfiAj6uqNBgfxus?=
 =?us-ascii?Q?L3lBmJfPWkkMLoGjt1zeK9E3xAO09557p/oE1n60JwbZzjJyWqBqIF1cBE4D?=
 =?us-ascii?Q?wsqSS3WSpaWmSuuZRppx7wS8HBCzzgqgpLCHG/E9bBs8EfFL5ELIkF6i661f?=
 =?us-ascii?Q?kX+cxH/4yjzvdP36Ztm0pfKJPt4/8ckGzbW8k+rql3eUCcRmJCSSb0K0M889?=
 =?us-ascii?Q?a5usSfbrE7RNPr1D0OJBdg6N5dU4C6k8iPFs/zep2OE=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee47110-1e18-47a4-8d58-08d8a41c63ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Dec 2020 12:48:31.2008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2qR3NoXNgOU0KdHd4dUhRcWQrP+LQjESav0fiu5Whwi3ak0bf45CoKjrI57n4H2bDty8bEYbec+HDQGhf+f/FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> On Sat, Dec 19, 2020 at 06:18:47PM +0900, Daejun Park wrote:
> > +static int ufshpb_get_state(struct ufshpb_lu *hpb)
> > +{
> > +     return atomic_read(&hpb->hpb_state);
> > +}
> > +
> > +static void ufshpb_set_state(struct ufshpb_lu *hpb, int state)
> > +{
> > +     atomic_set(&hpb->hpb_state, state);
> > +}
>=20
> You have a lock for the state, and yet the state is an atomic variable
> and you do not use the lock here at all.  You don't use the lock at all
> infact...
>=20
> So either the lock needs to be dropped, or you need to use the lock and
> make the state a normal variable please.
hpb_state_lock is mainly protecting the list of active regions.
Just grep  lh_lru_rgn in patch 2/3.

Thanks,
Avri

