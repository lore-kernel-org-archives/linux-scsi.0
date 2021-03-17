Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92358C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4427B64FA0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhCQPss (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:48:48 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:54638 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232487AbhCQPsN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 11:48:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615996115; x=1647532115;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gcTXi/BzrW1I13fnr5L+Xuq6aof+BNyo0Oeuf7bK51Q=;
  b=Otspu3LiQ4j1SPqRcqds4lFuI+AwPy90PL2CckYlsiDzo8CEYW7KA/TP
   /ON53AkPU0gHqtTpUW19qda2iFtdyO+qQ2uvkFl4YZLZGlb0ceT4Rrh6B
   OWroVSXOKoo6h+R/QfLqkkdvt9cs+2IzBIi1teRhjGpY1PSdszPtiLgOb
   WDhmXj0NDGFSLYw5619C/ZKrGnGKeeH/hCHS5BmZqNhmU6kOE/0thYfC/
   zZnjKg2f6RGgWxvp+qzjmwtMuXoCHtcxCkk6aczGJ5NpsvOlEM475cmoN
   0e72qPROUh+Wr2pBvDHjUy3GFMIRYqy1ye9FmJNCiFUKq8rFFPGJhM0UP
   Q==;
IronPort-SDR: +e7ithggeBRGBH45fYVTdDOswKGjeCoG1WFJ2AjD7phOZ/JyR20n0UyV3gCYhCs0qbaPiMycf3
 dpnDhKUFD9tXOl7jvRL9DIH1GPZRFjpkr5LFJR4bQhtliNEc16oO25YPjcF+sl2GCWGZVJ2MXb
 tZDM4xymnMRXx0hDWalrItn2liuXssaeaz7HJtDaUOvQcYk+b6R23/flsrwVAL0FNzJPplqBhw
 4FtwvmMk0AovW2gMT6TXLJKBTBVgO6RIM4TSUMwn7jXlDvIBeGg7C6OLkHI80oPZKKzDgvNbi+
 Ljo=
X-IronPort-AV: E=Sophos;i="5.81,256,1610380800"; 
   d="scan'208";a="266769312"
Received: from mail-mw2nam10lp2107.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.107])
  by ob1.hgst.iphmx.com with ESMTP; 17 Mar 2021 23:46:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4qDPhekW/rcEXTqsKDWmWRM4oEeldCLYOcEIwuKu3W7PhnaGtIk32HJq9MMlCN2I+VKsHUsv6ZPeykrsZchbXtyxG6yxdnq6FCK1I46QsR/pFwcZX7KBEv7q8YDTdgO1b34LOicnBuc7/4eg2xWbXJc3r6tfR1CdczyNva9HM4e1myzPV03/AEBIyilMjyIwlDBgGroyh1uGolSzQiC4FM5djV9SWbexyHQAgDCPyryWqcCxyB0tnkt1pyKH/lk6k0KG1zhMcOGUIrqLU04kiMGTG2wTPzHq+fqI3lvGUJnfn0l7RBMNDYrW6RvoV8Z+Bct7ZG1KxeGGBKH/BJokg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oixRYkMAWFcMGTNCFdXtII99EcdsyRp7H7DHsI+UCKI=;
 b=btBENU1BuA0f4Nk+4aiBDStukcyeGlyj88luza+1mNakFET0s4S/UzA5ym8OKitm4mGB1b5Ae3V+Uv/I72eY8su6ri1jpKm2OHpG2o9I3//A6XzDczSbewNruXNiF1ICuoKAFHib3+6CjedbEBgN+XaWV9ysmJrL09DNRfsY0gZXd1ASrwLEVmMNpZwTYfsz3xqRH/iUjgYNWj2N8G8LlmfhTO0u5gBPGb2kBbQprE+U/Ajhzbb6fdiQptEqhUHCfDxKTRWxS4eJmnb6nbxYZbp3rR+mTJRv8rQjYl9fUfjniE75cuQsHo/nnsgkE6L9drhlRK8iMdmCms+P3b8mcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oixRYkMAWFcMGTNCFdXtII99EcdsyRp7H7DHsI+UCKI=;
 b=xHJvqVG54kuy+8KEdmIRZGckNv/RP/EARzSjAgr8mYea6CAjgu75aE6p2WUHrZEa8XdKVD7q9TNGCgdsdTknLe8xz4icdBe0WtWjd6g1zkXQTS0cZPi4IzELT1ykmykUbAvqMbk1l+B9DAJccNP/HGDuxmUuGPLmYl7uxlSkHqg=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB7116.namprd04.prod.outlook.com (2603:10b6:5:242::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3955.18; Wed, 17 Mar 2021 15:46:52 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::e824:f31b:38cf:ef66%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 15:46:52 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>
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
Subject: RE: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Topic: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
Thread-Index: AQHXD2ex1y1f5g2rP02e5lIjKmzR26qIGY0AgAAGPJCAAA7hAIAAAEIAgAAbY4CAAAQzAIAACHQAgAAQ5TA=
Date:   Wed, 17 Mar 2021 15:46:52 +0000
Message-ID: <DM6PR04MB65757E84F80B654689FBAE05FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-7-avri.altman@wdc.com>
 <59a62fc17ec9229a8498e696eb0474be@codeaurora.org>
 <DM6PR04MB6575006E0682C3D11F54965DFC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1d0e3c5441ecf14b6614ec0af0d30af6@codeaurora.org>
 <DM6PR04MB65750C0AE1F1EDB41EDEE491FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <37d0a4f115ad5d08ab12a76e6cbe17a5@codeaurora.org>
 <DM6PR04MB65755C69AD3D64BC5B1E93D8FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <4562e78aee9c5fbb7bbff65930fc81cd@codeaurora.org>
In-Reply-To: <4562e78aee9c5fbb7bbff65930fc81cd@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [77.138.4.172]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dedb5aec-07c6-481d-2d01-08d8e95be2b1
x-ms-traffictypediagnostic: DM6PR04MB7116:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR04MB71169251135A06C40704D648FC6A9@DM6PR04MB7116.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uuR4cbK9LJEUQVA1Hel3pmaHI9Oi32nytkoamVZTEP1uZivsx6jVmSn+sntFkFCtjLJ6a0AiFu/QQ7ksDAdFopUBvyUHe2TBHO9UzkvArFerjApnDaDezOKs4dkRcTFAqkEuUSTZmhyUf5HPhLP5bgveu9/nBjB23GuUGvydfsTElBxAmn7H8D2sZvvMdwbWpfXXP7TnO3mmbXbIWZ5tVuGnnSGgB3C9izx5F0CysvO5F9QKWTBtQ38wdEGdpK5cbUnUoXy2fPq2m5WaBcIXO4vvFwXBYwqk4QORrsPQsxVtJF+diNJeNiCh1Wwu1EE74btUSci87scFpQ9iyW0TcaMwXOaF2rFNQD+CJanMYhD4loN52ZYdUrGv9XlaAZ87YVAsKpeVU7dFW41/5goVsGhHtV0qgeoO7ObFAIwWUZKxGYyjnM/GKW3Rpssk4JyLy/5Y/AiJd7zeD+eltKZNkjMc23uNaoqLWEGta1XYTsRUgNcpBtkQLH+xlRMkdXAandPKMYTSrD57YLYaGMtZUfW23m8oo9pwq64I6w8hqQQB2Z9VisSpdl/Hd9p/w9FM
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(478600001)(6506007)(66946007)(66476007)(66446008)(4326008)(66556008)(64756008)(71200400001)(186003)(7696005)(9686003)(8676002)(52536014)(26005)(86362001)(316002)(5660300002)(55016002)(76116006)(54906003)(7416002)(83380400001)(2906002)(33656002)(6916009)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0dYHZrSXPplkm7hND32LIL1wzAMCJac7n7n2EL2ifdGd0CoYZiOpB2pRyj2R?=
 =?us-ascii?Q?dJkGM8EjP4er99wwlrCJky4ubQvMTQz3mCrYOjusYihSiIamiWXONHxDd5iM?=
 =?us-ascii?Q?b/crGGy5lY/M3iEWLaNNax/rlDQDouqMr88MkDTCOwxeOtJ4BrtIBEUz4jg6?=
 =?us-ascii?Q?hIB3ZRY8/hjNwlDKg/0xs6gedrdO4JXh3QCxQLNiWoQoQOeHrZxR8lNue9I/?=
 =?us-ascii?Q?BHomycGmLP4nU5wi/0naqM6271nrPMH0pUcWLyZY/3fYVaQ50PhMc2z8s91E?=
 =?us-ascii?Q?z+C5GRD5BMmfaUyGu/206zEvP6skZ586L8CuZKYhbBrCF4mlNxD0sXRe2Huv?=
 =?us-ascii?Q?/P+gDAqTrI+B+ajvyV9ZMyvu8DyPCc0UK/fs/JxeXp4aLF9nRRnxjo3lDOqY?=
 =?us-ascii?Q?VEPAgnp7e/nJi+vFv7UU4mjdAgEdZU3qPWVfAsiWns9BGzvlxwuCX+ISMMbG?=
 =?us-ascii?Q?QpCORRktygYa+pqH2jcjSfqAYnhfii/oQySkWnIrFC21zb2QvOHsqwioPBbz?=
 =?us-ascii?Q?wxuejjsr2/1oGjBqwSHZx6xyF2Du8yrN6h/9Wjm09v8CNQRqblowHqtkbESy?=
 =?us-ascii?Q?tqVmYUmeJncnPCqcGlAHZugMiNDY5GgX9L5cVZ+HiDp18IbKfBvLUSoRjJho?=
 =?us-ascii?Q?pWwQDySCGMs/zLttLtiWV6y/Q7WvU7r00yTvTDE5Wc0RGBKg293HHYiMWLPt?=
 =?us-ascii?Q?uT0wscP5oTJOqvp1XCRAs9IALPai81bGEW9k2hfNIuB61kqTa+U8T7vtzAID?=
 =?us-ascii?Q?xlXRDcJ4qfzxd0lrJpJRmxUqj6Xco6cVtg+MHi7KSuFeiaQLEWdnneeAOUBG?=
 =?us-ascii?Q?2CTlJMFEsxyxkOnELYsAIP0JildwJHw9QQEP03ym9vjM4trYBAplEc/JpN3X?=
 =?us-ascii?Q?eaF9h0W6o9aVOQkwDIymRDw68CN13uaE5rtqSFQE7lpz+isfK84gVhfpKjsB?=
 =?us-ascii?Q?IqnMg5vNwGNwM9TvhguLICcT+r56mcBI5hIvaYptKaNSfX64KCspeM848Fld?=
 =?us-ascii?Q?/O357BFXJFJ36xphkfVbIdkX6XpSbAyoekhXJAmbtLOxpJjEXgkY0QBpx2va?=
 =?us-ascii?Q?/wzwEx50g8zsgyceE5KM2kRGdFYrAOwhuY2x0Z06wSdM1XN8yu/Pn/y+68Hj?=
 =?us-ascii?Q?Gnw59LM1zsgwWEFpckQpGy1ZKcnX+/RX7r+Kpnc04CJShO97F1s1bdTLxivk?=
 =?us-ascii?Q?kVKbx8UguTt2xuDjgE/HDTz7iuhtFe0IanQqEYMIOJVFBZYNpp7eYw3GwNWl?=
 =?us-ascii?Q?bFVySAwbF0Fv9pozg0zsoqd6o4NQ3GYR9ryipUWe4o+rbNzl3FaV7q3U+X3d?=
 =?us-ascii?Q?d77rvQc0gTb0SU1H/KwsZMh4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dedb5aec-07c6-481d-2d01-08d8e95be2b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 15:46:52.6029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 71oC0RfV2+JRzfI3LhRQ1En/xYF947yrfWkeXOByEpcSMyNEDAoTSal6x7y3obYZ08s1t5P1ET0CAKnfhSYumg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7116
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >> >> >>
> >> >> >> Just curious, directly doing below things inside ufshpb_rsp_upiu=
()
> >> >> >> does
> >> >> >> not
> >> >> >> seem a problem to me, does this really deserve a separate work?
> >> >> > I don't know, I never even consider of doing this.
> >> >> > The active region list may contain up to few thousands of regions=
 -
> >> >> > It is not rare to see configurations that covers the entire devic=
e.
> >> >> >
> >> >>
> >> >> Yes, true, it can be a huge list. But what does the ops
> >> >> "HPB_RSP_DEV_RESET"
> >> >> really mean? The specs says "Device reset HPB Regions information",
> >> >> but
> >> >> I
> >> >> don't know what is really happening. Could you please elaborate?
> >> > It means that the device informs the host that the L2P cache is no
> >> > longer valid.
> >> > The spec doesn't say what to do in that case.
> >>
> >> Then it means that all the clean (without DIRTY flag set) HPB entries
> >> (ppns)
> >> in active rgns in host memory side may not be valid to the device
> >> anymore.
> >> Please correct me if I am wrong.
> >>
> >> > We thought that in host mode, it make sense to update all the active
> >> > regions.
> >>
> >> But current logic does not set the state of the sub-regions (in active
> >> regions) to
> >> INVALID, it only marks all active regions as UPDATE.
> >>
> >> Although one of subsequent read cmds shall put the sub-region back to
> >> activate_list,
> >> ufshpb_test_ppn_dirty() can still return false, thus these read cmds
> >> still think the
> >> ppns are valid and they shall move forward to send HPB Write Buffer
> >> (buffer id =3D 0x2,
> >> in case of HPB2.0) and HPB Read cmds.
> >>
> >> HPB Read cmds with invalid ppns will be treated as normal Read cmds by
> >> device as the
> >> specs says, but what would happen to HPB Write Buffer cmds (buffer id
> >> =3D
> >> 0x2, in case
> >> of HPB2.0) with invalid ppns? Can this be a real problem?
> > No need to control the ppn dirty / invalid state for this case.
> > The device send device reset so it is aware that all the L2P cache is
> > invalid.
> > Any HPB_READ is treated like normal READ10.
> >
> > Only once HPB-READ-BUFFER is completed,
> > the device will relate back to the physical address.
>=20
> What about HPB-WRITE-BUFFER (buffer id =3D 0x2) cmds?
Same.
Oper 0x2 is a relative simple case.
The device is expected to manage some versioning framework not to be "foole=
d" by erroneous ppn.
There are some more challenging races that the device should meet.

Thanks,
Avri
>=20
> Thanks,
> Can Guo.
>=20
> >
> >>
> >> >
> >> > I think I will go with your suggestion.
> >> > Effectively, in host mode, since it is deactivating "cold" regions,
> >> > the lru list is kept relatively small, and contains only "hot" regio=
ns.
> >>
> >> hmm... I don't really have a idea on this, please go with whatever you
> >> and Daejun think is fine here.
> > I will take your advice and remove the worker.
> >
> >
> > Thanks,
> > Avri
> >
> >>
> >> Thanks,
> >> Can Guo.
> >>
> >> >
> >> > Thanks,
> >> > Avri
> >> >
> >> >>
> >> >> Thanks,
> >> >> Can Guo.
> >> >>
> >> >> > But yes, I can do that.
> >> >> > Better to get ack from Daejun first.
> >> >> >
> >> >> > Thanks,
> >> >> > Avri
> >> >> >
> >> >> >>
> >> >> >> Thanks,
> >> >> >> Can Guo.
> >> >> >>
> >> >> >> > +{
> >> >> >> > +     struct ufshpb_lu *hpb;
> >> >> >> > +     struct victim_select_info *lru_info;
> >> >> >> > +     struct ufshpb_region *rgn;
> >> >> >> > +     unsigned long flags;
> >> >> >> > +
> >> >> >> > +     hpb =3D container_of(work, struct ufshpb_lu,
> >> ufshpb_lun_reset_work);
> >> >> >> > +
> >> >> >> > +     lru_info =3D &hpb->lru_info;
> >> >> >> > +
> >> >> >> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
> >> >> >> > +
> >> >> >> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru=
_rgn)
> >> >> >> > +             set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
> >> >> >> > +
> >> >> >> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
> >> >> >> > +}
> >> >> >> > +
> >> >> >> >  static void ufshpb_normalization_work_handler(struct work_str=
uct
> >> >> >> > *work)
> >> >> >> >  {
> >> >> >> >       struct ufshpb_lu *hpb;
> >> >> >> > @@ -1798,6 +1832,8 @@ static int ufshpb_alloc_region_tbl(struc=
t
> >> >> >> > ufs_hba *hba, struct ufshpb_lu *hpb)
> >> >> >> >               } else {
> >> >> >> >                       rgn->rgn_state =3D HPB_RGN_INACTIVE;
> >> >> >> >               }
> >> >> >> > +
> >> >> >> > +             rgn->rgn_flags =3D 0;
> >> >> >> >       }
> >> >> >> >
> >> >> >> >       return 0;
> >> >> >> > @@ -2012,9 +2048,12 @@ static int ufshpb_lu_hpb_init(struct
> >> ufs_hba
> >> >> >> > *hba, struct ufshpb_lu *hpb)
> >> >> >> >       INIT_LIST_HEAD(&hpb->list_hpb_lu);
> >> >> >> >
> >> >> >> >       INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
> >> >> >> > -     if (hpb->is_hcm)
> >> >> >> > +     if (hpb->is_hcm) {
> >> >> >> >               INIT_WORK(&hpb->ufshpb_normalization_work,
> >> >> >> >                         ufshpb_normalization_work_handler);
> >> >> >> > +             INIT_WORK(&hpb->ufshpb_lun_reset_work,
> >> >> >> > +                       ufshpb_reset_work_handler);
> >> >> >> > +     }
> >> >> >> >
> >> >> >> >       hpb->map_req_cache =3D
> kmem_cache_create("ufshpb_req_cache",
> >> >> >> >                         sizeof(struct ufshpb_req), 0, 0, NULL)=
;
> >> >> >> > @@ -2114,8 +2153,10 @@ static void
> ufshpb_discard_rsp_lists(struct
> >> >> >> > ufshpb_lu *hpb)
> >> >> >> >
> >> >> >> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
> >> >> >> >  {
> >> >> >> > -     if (hpb->is_hcm)
> >> >> >> > +     if (hpb->is_hcm) {
> >> >> >> > +             cancel_work_sync(&hpb->ufshpb_lun_reset_work);
> >> >> >> >               cancel_work_sync(&hpb->ufshpb_normalization_work=
);
> >> >> >> > +     }
> >> >> >> >       cancel_work_sync(&hpb->map_work);
> >> >> >> >  }
> >> >> >> >
> >> >> >> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufsh=
pb.h
> >> >> >> > index 84598a317897..37c1b0ea0c0a 100644
> >> >> >> > --- a/drivers/scsi/ufs/ufshpb.h
> >> >> >> > +++ b/drivers/scsi/ufs/ufshpb.h
> >> >> >> > @@ -121,6 +121,7 @@ struct ufshpb_region {
> >> >> >> >       struct list_head list_lru_rgn;
> >> >> >> >       unsigned long rgn_flags;
> >> >> >> >  #define RGN_FLAG_DIRTY 0
> >> >> >> > +#define RGN_FLAG_UPDATE 1
> >> >> >> >
> >> >> >> >       /* region reads - for host mode */
> >> >> >> >       spinlock_t rgn_lock;
> >> >> >> > @@ -217,6 +218,7 @@ struct ufshpb_lu {
> >> >> >> >       /* for selecting victim */
> >> >> >> >       struct victim_select_info lru_info;
> >> >> >> >       struct work_struct ufshpb_normalization_work;
> >> >> >> > +     struct work_struct ufshpb_lun_reset_work;
> >> >> >> >
> >> >> >> >       /* pinned region information */
> >> >> >> >       u32 lu_pinned_start;
