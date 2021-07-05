Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8B0BC07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:52:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C04D9613C9
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:52:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhGEGzF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 02:55:05 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:20847 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEGzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 02:55:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625467948; x=1657003948;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4VlFc92qTJQNXF/VzD+K5sLvmTIIhgTk4BbOlaG/BUY=;
  b=F/Vp+C47JPSY3g8K5SG7m5uYNqFDWrQVQER4T/VFeeKgGVV7qJlqovf9
   a1TGhskUGsVtuctB5Kh5II09dInxFMuxXGcLZzeLOOt2jFh0/HLu7WE0Q
   USxlaOk0kUNbHj67WjyzjEJCvxEQjshRgFz3N6fktTpqEzmuRf9S8OtKf
   GlOuyB3AI5Wv/jFUTOPU71r7O7qKIxYzAGCmEB0glkoQ9YIKWjyrRLija
   RoMC/TAs+fGDlJ5SznN0Q+Cqs5fkN06idKn7HP3oYaACcZHRRCF4YnFH7
   CsNMB52ep/G2Z1C/ZlStfvaw3FZJAg9caqEhZoPi/2+NYytHU8av0nmN6
   A==;
IronPort-SDR: r35W/XflwxbafDt2Zcdqh4SNxdOdcOQrkoa50pIvbNo7iHs0C1Hchyuc3XIB2mKx4mbHVTN21i
 hg829+xtRodsPOwOn6ZemoULjZkgTZcLKqmsd1ZogoKNfuCy6lgtk6pUg95wDBY9Lu/ctSeVs1
 x6xbqX/ec3QO5lfd8drLBCy9qjoUi0CaJCcU0hofhZ1OnqnV4AfGNYxO4PJIJSt0fcSBTebKN5
 /kZatUunETh0/GdfqGRpR+M57N1bHraLwxj30a7XJyZEzy/VezncDiS6uXX09Lb2iup/uh0VP5
 lGc=
X-IronPort-AV: E=Sophos;i="5.83,325,1616428800"; 
   d="scan'208";a="285221243"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2021 14:52:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFPo7RGSUVBn9ZNPWki6qy1MJy5Melt+BRPS7KCs1WoculFy2I63re/7JftdzoMqHJV4D3GjJuj7NQJqLW8S7IRU4+ICOJwSzf/1LmJW8wrX8FmzH1w7aOn3WJYN5DeyzMQwbXIvykjXxGJcxP9bpbSge7T2XVIBmW/X72Qey3EefD744rpNMF9ZIMG9vSMsP7UoXN/FNH7Pm8c2wfr7bPhWLr5P8dQlV3JcASwKEKaX9BVT3lpmSrdka9+XGGyNMb8cAG1CTieaQwXeH8jT6iXXh08GZJptnSc5U+H46U6p3VWXCeQMeEMPbMU7I9ztzXu8TUSsRhLdjxtccIfabA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VlFc92qTJQNXF/VzD+K5sLvmTIIhgTk4BbOlaG/BUY=;
 b=SOi02dBigbaQIHOlVjwBrfWUBVR1it0+hNRdSGzfkScP3vPahXB4X42cAKpAffAGzGMLa4gnMbeKn1SQn88Bs9Ng5WLJ9BxBhD9GpXYUcQbziO0XSW/i+8Cq0+ihPhMwalW17wDF6i1i39szgic7acx1Be9txCPxZLFIyW0sLr3rPTnMQ09KOPWWahG7z37ryNtl+EvzOm2RL6z3c8tqeICwmMX2+dtmJBTfnYwXSO3SUPMgy5FQVljqEVckuvOx78xxYR0XnB/ZKoFFDzobaKwnq2G/LDPLQ8gt6TAAZMIM0XiUm0rC2bWUn0OkkMmQu/enRGjLW1lEnZaLOAdL4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4VlFc92qTJQNXF/VzD+K5sLvmTIIhgTk4BbOlaG/BUY=;
 b=bn9OUTxQf6OQvLA82wBxb9pAIl6xYrPH7rLAKIVHbw0HjHg8biHF9S0t/4uMrkwEYH8cyjWqIsnxvvnia3LEGC68rhzl+VS+f51xVu1t0g5uDTxCfesJxJlspJe7z7QCHTpcNVMv/4z4iXH4Sheq63lYdzQboaA+EqPvS4CjagE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM5PR04MB0539.namprd04.prod.outlook.com (2603:10b6:3:9e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.22; Mon, 5 Jul 2021 06:52:23 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 06:52:23 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH 11/21] ufs: Verify UIC locking requirements at runtime
Thread-Topic: [PATCH 11/21] ufs: Verify UIC locking requirements at runtime
Thread-Index: AQHXbr3tGwBavDaWD06p4HH5J7YEeqsz9uWg
Date:   Mon, 5 Jul 2021 06:52:23 +0000
Message-ID: <DM6PR04MB6575B390B3ABAA9713747AADFC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-12-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-12-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bed3437d-b1a7-4fc1-ad0f-08d93f817132
x-ms-traffictypediagnostic: DM5PR04MB0539:
x-microsoft-antispam-prvs: <DM5PR04MB05398CF5248E530F39864A30FC1C9@DM5PR04MB0539.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qUY05Hu9XPSy+oo1wkxTV7sO+KxBvS2eKquOVH56qxxNk+11tL2JFi5T6B3sYsv9GU9z9atWKATnlWls9e0mMSpETmmsR8I1N8ZeDl+3t2vjgJz7L0sUYXyWYkK9v0xSmBNgEKaKonirqkIDwz5xerAIXCZ+pW9zxfOhSfWDA1oatHffSm6CRR33wbZlTDruX51B5dYf70hqqTdNcKdv9m32GeK6bVsBvk4gNOywhjn/feeQM2aKWQhddTm8mvi0bmN7TuO+hpKeyeZWWqDOQ9L0fBgRCDZB+oK5YS/lnuv9PZUSHKQVpafHFbpEPEpeWkDvQIfBVccXk9Sf/KDgt4dY41jJparrjEOxEaLLnI0YQPQdZB/5U/Wi2jDxdTSxGOyJMFXPiMMM5fCnkSluiWK7vTWoSkI1FO2yNN4eKQwINslkF7oS7ByiFKQwULtA0MHW0RSzAaJ2/PxkuyiKiclH1g+W5fVlufVc8MDAYk7f8pb8q+YptoiY1HAM05V0/rZ/nFDDqgx9F+SStwhkqTySd+FT9iGIWeEWmnIMcf7qdOyTMhlQJ37HOCc3VyHVk0XeA6mHUunGa6JYIJpOR48cFPoYffG5XQvhZ/DmHG+Uv7RAWVIqZDdcTfDZY0zcctBA0GvHMWVS0vuLdiKpXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(64756008)(66446008)(76116006)(4744005)(66946007)(186003)(66476007)(33656002)(7416002)(55016002)(9686003)(83380400001)(66556008)(8676002)(26005)(316002)(122000001)(38100700002)(2906002)(6506007)(54906003)(5660300002)(86362001)(52536014)(8936002)(4326008)(7696005)(71200400001)(478600001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yXjLijCTeYVw9WIHQz6r4G9Q0tvlf1X3e1eklp6r5UoX2MDuRKzWS6qNiZIo?=
 =?us-ascii?Q?rD5rnwXV1U/CNkVahHaUrHJE/UmqqjTmvp0S/D9x4PcLROgDGT+xzPcuYC0J?=
 =?us-ascii?Q?pmmZRwWDc0AysAUONIstLjuXfpxuEjl9WsqHF/5iXiW306NF68cnf5PVJvT1?=
 =?us-ascii?Q?U4zFu5Fsu3u25baQKOEeXB6c2y18+HgVcq4YDKJ/dSnyC3koyjMJAwR8TQp5?=
 =?us-ascii?Q?6O5tdM/LrDBnxTRrfx0d8IfP4Fll+FHjOdiMvPi9U9+IbawNPQ5LhOSpUTNV?=
 =?us-ascii?Q?1IfzIOT75Z0ZKqVEwPcz43mLDlhbV+cfrv1vdbdM8cm86kwY74eOQwavxTOW?=
 =?us-ascii?Q?kn8TvnhfJWTuiUu+MsGHMC6r4SaSYXGjqOoQXl7PZb9jJm6bBw1tO7aIigJ9?=
 =?us-ascii?Q?NyrrRAOAIXbH8RNIHv6MxvsozKSmsCcmXBe6ZoQLI3l1jQmYY42zclOQFPkX?=
 =?us-ascii?Q?kSQONv1+JencmAPb/eDlBLnHB3AL34vEpB6lEZgcx/i6crfTvWb8tJOqgodl?=
 =?us-ascii?Q?h16ApMhDymggbUccIo0mB554Y9+iLo0qqJvfEKDr66HRPiRfekKP4d1K0gg6?=
 =?us-ascii?Q?ENH7WjCmAuTCjTWyMaN7m6n3zoNqgS1pPZfznpJxKrRW296k15A0ZZQbMnuW?=
 =?us-ascii?Q?TjxFa5M7gH0xY9vx3ADG0IgpMvF9FDvLstVwRumNOpwKJ56lT8tKy0ENIqAR?=
 =?us-ascii?Q?tJ9KWtp3aK9EOHOh21mExONObyCyAf0S7ta3xmMimPD5WgVeM9nnJEdpKlI4?=
 =?us-ascii?Q?YuTvCo8Zv79Zjtf6zRtpwiG43w5l5SNdv7rGWwiYeKs4SUAQDpqnUQjVnQ9O?=
 =?us-ascii?Q?BZKW7lq4eDkPlKvkOe/x7Gfcud+MKy0l/da+ELhaGEZN4IC0t6Uwi4W6IX6X?=
 =?us-ascii?Q?BDweSeT2vXazpXfKado/1PbG1P/Po/jP8gchrNvoVQnR2nJmEw+Cx0jHRFoV?=
 =?us-ascii?Q?wYus/YctuwAU/WqvBQ9x7jr3v+Hgf2KXYaGjl+Xv1MSfcYwMz5I36J7/H6CI?=
 =?us-ascii?Q?jB9mMam0b1oCDApsNOUG4I9sHycff83djKd25UsnFDGwOCOn0Zr2r+vrGAzH?=
 =?us-ascii?Q?VHQUNxjC9NDKh0MfGK1a1WkhJbBfyJyPDelijUmNxDMVnQgFe/qRY+LuJJdw?=
 =?us-ascii?Q?lZ9SwDVuxUq36pCJx6VM86R39uN7y9BiuouZdO+j0oIXXYAIKITJqPuBT8X5?=
 =?us-ascii?Q?7mpajz4x/5qxAsBkUGhORCXPqaxaxCVfijRV8+IIyiBaEeQGFPAw0wR8Rwnm?=
 =?us-ascii?Q?ge+3/j6+Mn9wKK6ITdFWR9wyIhlVTGj06Ingx5RW+stRoV4TPcKD1+DyIvCU?=
 =?us-ascii?Q?eLZKNJBVT9rzVGnP+FL0y6lg?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed3437d-b1a7-4fc1-ad0f-08d93f817132
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 06:52:23.0968
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: t7sF2Oedpab/Wea+Sjzg0x8xUQxEo04uJDCft8khwTK+yd0Mk5uj9l+RkTE03+qJ20ObblW7TjbXdS1844bswQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0539
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Instead of documenting the locking requirements of the UIC code as
> comments,
> use lockdep_assert_held() such that lockdep verifies the lockdep
> requirements at runtime if lockdep is enabled.
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
