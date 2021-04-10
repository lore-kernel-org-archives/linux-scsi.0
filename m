Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8285EC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 01:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 579E7610F9
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 01:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235368AbhDJBNX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Apr 2021 21:13:23 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:63044 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbhDJBNT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2021 21:13:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1618017186; x=1649553186;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GLXjhjGelr+DTO/EW55/gHeQ8fcCWC78w7r4WI+0fyk=;
  b=WayFW5aMkc7vKBlhfOuVbzykm/kSfjgAkPlhQbZ+1t+TlxLd/fIrbn8w
   EpH7HkA7LmFDJr2C1BoJekPZne+Npv1AnVkVqytyGCyIm4yr1R0VyyuqT
   mqM0yIeAigNd+aKq6HlO6YXDUcJFq7ap03dj8hdBEp4swCRuQanGiI19Z
   O5hTYbHr0WaC54qoCzwJCxvzHsisnRt/RqZWY4+PAIlePmaLYPDxmcIyr
   GajWOGbaQvncegqwEJKmIqugP58URtQ52lmr4Q8D/AFXU2NeQKtWvO/Rk
   XDbq8UlVGETjsZOdUCaQlDoBW3SO4WDGp8MC0JGjbVT3azSsUavNOIRj+
   Q==;
IronPort-SDR: 7NGNJsdZkIW+5pmQBJmpqhxnvzw64Rju2nKoL0DAweRTvPrSQ2HTACtUDtOsVrD0sE+lT8XTp4
 dt4ZIsF7Mr+BZpKE1Tks7jJUEs/A+cxED46ealcPsLQ9dIGQtQQJfyU0140gzouwQxH2Agn2UB
 O7kGo9slZHDeUmT1hB+sYVkXvVDueOV3Xky/ux/Yju44y4921Fn+ttU3336eU13lMfABlKM4lM
 GYsII1XHErk2tV3MRmXgSuSxOx6gU4zR5ukrhfItsbsBDyFhi6bGkvfAT+iMYff/KUXESeBQ3b
 TuI=
X-IronPort-AV: E=Sophos;i="5.82,210,1613404800"; 
   d="scan'208";a="165202044"
Received: from mail-mw2nam10lp2101.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.101])
  by ob1.hgst.iphmx.com with ESMTP; 10 Apr 2021 09:09:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNJ7PHHyqpCfzUcnlayAWNT31z4AINv0Gj0PFtv5acckYz+SG/B+KGtPmDcshiFTZyWB0Mig8xRZn4e/kz0ki+ydp21qC66GHbYmZ8iWQcZOxQKrT2nfh+niMj8SAw/WNCrr/+HXSd/sOCiRJuQ6WtwyM0B6+MRkMC7QCrj9OxJX354JjhUqDnGnu8Vn0aI6xjwhIHf5wG77tJELX6wgTWg3JmTNVpUA3kKQbBOkzVTXe//JHqHl0/44dS0yDYyIaWLHsRy/msmU1scH7Mz6IHpuxGpHh4f4qcJfqftazwq7HZBpCkV5PwJ0caiHxzAdXs6hocKW9FgllEaWH+/zpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCP4a5waPiwtwitSxSuCFSOiOHdoOBow1Ywrcy+w4cM=;
 b=U5x7CywdbaJrWbs77lSUuXWrAquuQ9edu0Th9IgynHXy/BbPhnYDoNu3Lrsr1XiprMcO/yI4/JQxJRbOJkXh1aw/puxU2cROQzuS+GDLxsTlEvxJbna0RwpuUXzHKy3g0pdEQxoWatdiNLWIEZwUglJw08SZUK1dWbdHD4UpfMZwmGflv0NKqt7g0Fco2K9bQjB00+NPyRwKtoCez5cgb81EB6WaHw6NCzXP2NXEBNcB/nJNXMQTkvIyEihTjoWJ1Ac8EWcrA+/dzAUHs8geZ1NRcFpPZZAYEYZqXEs59Pb4XGmpzOJY6RIdAYSfBaFZh69GsPE4kZsvexVFy23RMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCP4a5waPiwtwitSxSuCFSOiOHdoOBow1Ywrcy+w4cM=;
 b=LcdITKaimLyEQVtITS6NIjqfQhFJbKGF6m99klOcczaxT0AvGNNqFTA8CSHOVbIOwKdVROpaRKUrwOi0zB3Ul+vuDr+r/LkuIi33o3SiLqnEZbYcvZZ8E73ESVkBQ51es4qKhKWRrlvRoVNojAmREXm2OJvInnrF0vmVPeFCdxM=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB1259.namprd04.prod.outlook.com (2603:10b6:4:3d::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.26; Sat, 10 Apr 2021 01:09:46 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ed2d:4ccc:f42b:9966%7]) with mapi id 15.20.4020.021; Sat, 10 Apr 2021
 01:09:46 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
Subject: RE: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
Thread-Topic: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
Thread-Index: AQHXJgEueLuV4ularE+yUH8qPo3IjKqm9ZCAgAAHZsCAAAthAIAABAWQgAADOYCAAAxloIAF4+wg
Date:   Sat, 10 Apr 2021 01:09:45 +0000
Message-ID: <DM6PR04MB657506ADA145380DE29C2A5BFC729@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
 <20210331073952.102162-7-avri.altman@wdc.com>
 <e29e33769f23036f936a6b60c7430387@codeaurora.org>
 <DM6PR04MB6575719C78D67B7FA1557C21FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
 <6bb2fd28feb0cd6372a32673d6cfa164@codeaurora.org>
 <DM6PR04MB65752BA21FA1857D6EA10B62FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
 <a11edfeed79b8f411dc1948aadae0f25@codeaurora.org>
 <DM6PR04MB657516510061FCFF7755DF74FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
In-Reply-To: <DM6PR04MB657516510061FCFF7755DF74FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 691f4b46-dfdd-4163-fbda-08d8fbbd54a5
x-ms-traffictypediagnostic: DM5PR04MB1259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR04MB1259D2155EEB340FFA44ED6DFC729@DM5PR04MB1259.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YWULegCyX8gAwaOJ7NkKfGEOySHGju00Wuk4/NUJExY6TeejdraJiFEM4IxOmGWcC6H6HDLGRtSPp7+trH5aChfssRnd9X15ocTvDYICkkdNvhpm17AwFR2Hx403PoleiAZtf2Ax+sXM0S5bkIHWntmsrVL7MC9MBhlpvW5ztn3q07NbLfH7nvoLuKJt1ujXNwdUY0s3VjzN0o+SgcVhfNBhYEUkRct3nTNJWDyr75Pk7eCpeVHnuf9AjDtH6YyMbDeUXaS0mmpYrwFDjzy+yqJSIpixwEG536s+4YCok20Idrz53nosa93+RyxNg0KCcF0g4A1V1H7VU1pW/C12JEFJ9hfdk7BwSdfF2F/W2jXqfVkETaGnzeHK/TXrdNq+GnRGz9zpkq9kiCCj9w0BbvGROdXaIuXAWew9ZyquqIEq7lFoRxpDzNmLH9vcOhjpG7Mdqak8jlQjTSKMc/z/K20B1OQdyaeXHA9FadHDOeVESHUVR4j0ckCYfHdNHU49GAYfCGsz3SYnsIzjyoaAorUlqHoboQsUUUOfC4GMSLLDWX9HpdUWi+3mshqzf1FT1nTx8C3U/mUXQa+UkoGBMEZ66xi7A2G+qWyYs6JvXMR0sNambK8SKEgzNNf+Xs5969x65VePF09e/jU4M3UDnFCDNt6SMWl2QxmBUrTo5ZY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(52536014)(316002)(8936002)(83380400001)(71200400001)(86362001)(478600001)(33656002)(38100700001)(7696005)(9686003)(8676002)(55016002)(64756008)(5660300002)(4326008)(54906003)(53546011)(66946007)(66476007)(66556008)(66446008)(2906002)(186003)(76116006)(26005)(110136005)(7416002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?vz9YtkGjZUpVo8v2OHWxKzAJIxODAF5JhkChpqOKk1cNvvFpMfAAonNhqMpK?=
 =?us-ascii?Q?oGeOpJMRfQ6D1NMdQB2U/fpqnNRs7MXN7KPS01er0WVOqd0eaMEMQ1Tj2cR7?=
 =?us-ascii?Q?Hego8BptrO26tWrnBS796C+uM73K0mrGv7ng/uBp61MsAUibwIfI4uTAec6T?=
 =?us-ascii?Q?QZHNNqCgVKWEo4f9yd9o6tsfWV5EXaxCS9NwIVwHTMz9Ay1AUxDU5gWXZeh2?=
 =?us-ascii?Q?7irgyhUHs+HPTBmdsbTnkRggrQATDNvQ2fQsAkTX2U588o3w/zeTHhYoWdWl?=
 =?us-ascii?Q?x1Awa4ZcsVZnVyq3uHRgqsuA5ekXdzh6JIncjSdyVWxY4HZHXCwCjQ//0z/Y?=
 =?us-ascii?Q?jjC3TBToDqyt1jXoKTF7p6s3xeXYevtvNCTvOWsQ2jRrEge4GVruxrDjmV66?=
 =?us-ascii?Q?nmkiuAa8D2+qVnxCOcs6GfrAslb0DuHvvfXTwgxt2fz88tG0/ZBwnaNHrfl1?=
 =?us-ascii?Q?0mXRN9ESRLcjRoUPxtYenDNLFuZ9pVCadzs4p5LO5AdxhCQsADHcJ51mfevd?=
 =?us-ascii?Q?Alb2aAHiQlp3AN+DzIh+Atp8PZT3S1LrF5PdYhbhznWxpzDNjrNYOwH+pl57?=
 =?us-ascii?Q?1vUhEpDw4f4Dv1SmtOAJXzRxHcfnbIPguC8beaVBdtuV4E39AeQ4mLMO7XlB?=
 =?us-ascii?Q?LFuWRAQK8zaXv8axDf2svMBqjjfcPmH59G5TEcR4UBhx0DsJRXHMqw2vcPW/?=
 =?us-ascii?Q?nSAwpxfEyqz520rXsB/1/QheazBwCrgmN2zDGAHXTYfo5ys28ghrZwO34YIT?=
 =?us-ascii?Q?/EVJ9cINc/2rPIEAaZhiZyeH/22VH1uWsArHDboTsNqktXQOTppT6zN7/Xj9?=
 =?us-ascii?Q?KVvRCRKQ5PWulN2mJ4Az2pWft9pjkd+wAnsnOSdqq0IBojND2Xp/FEtzJBve?=
 =?us-ascii?Q?vneFeCdexUEtZ7Hxu0g/RQDWNG5iHDPoDbwTb9K7XE1AIOPSq44dVhPFBsKf?=
 =?us-ascii?Q?1uZ5jKliyiYoM+94CylPwxcbbDwaYbavKMfgNqHc7u4mixO5HOCDNZQLg0So?=
 =?us-ascii?Q?E1NS1v97nhy7Om96cK1NAzEvlAPcCrk+ZTCOl2Q4LGMN1Y3fk7K9Otzul83/?=
 =?us-ascii?Q?3be32km9IiHMtPtwQ/0WSSiZsyGMWfEP5u7RQpniOxDZvIIByQ7sBTJrFsTf?=
 =?us-ascii?Q?fXPtki8eYIdvKsEEHqT5YJGiMGG5hKGbN4V5Cga3MHx/MkQ3NnW/jJdWFIkk?=
 =?us-ascii?Q?ue8CYQmx+RZrI0w9IMq1TcU9U1HKXcmOCyhxBGn0zCKMdvjK5l7As5tUhkcO?=
 =?us-ascii?Q?SlVYYFjxYm21DNBy1yJIrLqj8Aiw1d09z7flz9aS5bH4Dy3mKfC4PJpbFjdh?=
 =?us-ascii?Q?oNg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691f4b46-dfdd-4163-fbda-08d8fbbd54a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2021 01:09:45.8797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +CwxKYePirRetFximTJkhVZ27hERKz+eehkaDAdo9Wy0cA4LVMlMifkqcF+RT0o+xvM+KlebER56e7x4bwf8mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB1259
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> > >> On 2021-04-06 13:20, Avri Altman wrote:
> > >> >> > -static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
> > >> >> > -                               struct ufshpb_region *rgn)
> > >> >> > +static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
> > >> >> > +                              struct ufshpb_region *rgn)
> > >> >> >  {
> > >> >> >       struct victim_select_info *lru_info;
> > >> >> >       struct ufshpb_subregion *srgn;
> > >> >> >       int srgn_idx;
> > >> >> >
> > >> >> > +     lockdep_assert_held(&hpb->rgn_state_lock);
> > >> >> > +
> > >> >> > +     if (hpb->is_hcm) {
> > >> >> > +             unsigned long flags;
> > >> >> > +             int ret;
> > >> >> > +
> > >> >> > +             spin_unlock_irqrestore(&hpb->rgn_state_lock, flag=
s);
> > >> >>
> > >> >> Never seen a usage like this... Here flags is used without being
> > >> >> intialized.
> > >> >> The flag is needed when spin_unlock_irqrestore ->
> > >> >> local_irq_restore(flags) to
> > >> >> restore the DAIF register (in terms of ARM).
> > >> > OK.
> > >>
> > >> Hi Avri,
> > >>
> > >> Checked on my setup, this lead to compilation error. Will you fix it
> > >> in
> > >> next version?
> > >>
> > >> warning: variable 'flags' is uninitialized when used here
> > >> [-Wuninitialized]
> > > Yeah - I will pass it to __ufshpb_evict_region and drop the
> > > lockdep_assert call.
Please ignore it.  This of course won't do.
Will fix it in v8.

Thanks,
Avri
