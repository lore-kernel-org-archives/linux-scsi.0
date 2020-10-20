Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73C8C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 10:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4622A222C8
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 10:51:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="d9/Bg7Gz";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="LJCWao/r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393358AbgJTKv0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 06:51:26 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:18270 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392281AbgJTKvZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Oct 2020 06:51:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603191086; x=1634727086;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6usQxq//2DwEFtCcu/rRmdfWXYgOivb6/+q1LY/UY5g=;
  b=d9/Bg7GzWMNk5I0i6wIayB6z6aXkkD+Yuuw4rt4FK6Mhn5zGZEfpx+sD
   6t9a0/EEZUf3MTq7hz1NonQ3bvUSsXr5fjKguOA8Dtsoo2d9oEg4GAdOz
   skb8DH6UNSnR6VW5CxplHlxQKnIYCjdYwgJTfuUCL/HRKYky1bLDEBhWf
   Y/utdTvHe9OQBpbriy9aZ3t/Tc5Am0zLL6DZf1SC9QtDXyx7/QSdEqLBo
   euMGsGJCWmm8gYl0wClPP96jGtL0YBvcZfM5xofKBsZMnrd9yqP+WCz8e
   Ux2zcK9eNFwZI6opm5LP7SPafbYpTmYlRKkD4eKaZ4SCO3P7A6AJ4YTuH
   Q==;
IronPort-SDR: 0ugat5/Z02aJJnMd1KbBDv5Gd/YYAQS0Hvu3JLdlammKcCZ+OGD9Gxi8wjE2yqy/4lpKu3SG6Y
 a29088HLrjfsX9E2WnpwBbnK29ZnGd0reGMATJmoSWuW0VDCTtcge2xv8jMnw7vVjbVdVNdxeP
 VCPQ3Nx/SnzkfCtJ2i942/hsO5PNP6ZAcCGPgOewXw9rSIZbeBT1XkAHNnnTcDgDOH28CBAUFY
 6vArbCm7Li7onsqojdDcZllT9n/7e4vpqiKDNfvQrZMo6qNe9Yw1Ev6Pr1uhEiWvTL9DkVTQF/
 hBM=
X-IronPort-AV: E=Sophos;i="5.77,396,1596470400"; 
   d="scan'208";a="154839337"
Received: from mail-co1nam11lp2170.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.170])
  by ob1.hgst.iphmx.com with ESMTP; 20 Oct 2020 18:51:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTvGM8/3VRzbc/A0FT2/Xh2n7MNxmgE7asnq4ndC27Nh4FiNynkVy/7T08LOKve7zkwmcFPVVaadva5zxG8h56h5i4c4m3w2lP3HbVi8yOgDcw2H/NXFJuAezOEhShbkHMOdSJdtthGsq2gi16qqdOc+rgpAY1xtJ0RjaF4y50Js3NTM3kLRbgGJTe8K6iH60v6Bk1/2Fi3/m8iPCmmUZQvXo3d51sLHMFHvYKdxSQcBXa4aIkCECNheIcee9cvocApsFzEX+TxXyr1Cf6ZdLVG7oqBFf+pk8fJRMvfDbWfC66KG1/m6PgIfUL2NYjVTxVsYQ+zGsyG8vlhcXW6o1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6usQxq//2DwEFtCcu/rRmdfWXYgOivb6/+q1LY/UY5g=;
 b=Ev3lAa39+e03iwGuxTjdrm+PZkotyTU2sghrcxGuM7pdi5CHEerWTCkPjpdvTzAMePU/QksX4f5/K9H4EgUZ3Vo1/fMMSRvv8SmGHUQe0SXUFdjm4wD0fm2uXldwhWjtWMRzHHOcnRG3//XgNXhotjCGr2a0VxiLN3O+vSdfg/kDpFxuPHy7RtCv1ZOeaeQ65lpNlVEeBg1ooreXyFdenRfB90K640h/B/fvM4xAXhtzfTXXgoW/sj9afYYBtx4gFU+ifnSkmtcabULmhlM98ghUud9hAggAkJxZeXbeauDqME+fMoaThR8QPMZahzxyXF3v0YkWDbcRXi2G8C2EDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6usQxq//2DwEFtCcu/rRmdfWXYgOivb6/+q1LY/UY5g=;
 b=LJCWao/rvUV6iGpTpBtyhtDuR2UfzFNfKFqohuY4E19BdbfZ0KbExcA/dRKxqWSb8u58BKV0TwCIHqsNXXggiRtf5tEEE+NBIfPPvGDoy6nPiSHF4B0/QYNr/jMoA3YTpl1wgK57AYC1HluNmWjzWRO1aW8/UVPqHpzau6YZ0lQ=
Received: from CH2PR04MB6710.namprd04.prod.outlook.com (2603:10b6:610:93::10)
 by CH2PR04MB7048.namprd04.prod.outlook.com (2603:10b6:610:98::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.24; Tue, 20 Oct
 2020 10:51:23 +0000
Received: from CH2PR04MB6710.namprd04.prod.outlook.com
 ([fe80::89c9:1384:f052:530b]) by CH2PR04MB6710.namprd04.prod.outlook.com
 ([fe80::89c9:1384:f052:530b%6]) with mapi id 15.20.3455.037; Tue, 20 Oct 2020
 10:51:22 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Can Guo <cang@codeaurora.org>, Jaegeuk Kim <jaegeuk@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        Jaegeuk Kim <jaegeuk@google.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: RE: [PATCH 4/4] scsi: add more contexts in the ufs tracepoints
Thread-Topic: [PATCH 4/4] scsi: add more contexts in the ufs tracepoints
Thread-Index: AQHWm2f/I0ejIh2QaUeberVOQ/pxIqmf19WAgACO0tA=
Date:   Tue, 20 Oct 2020 10:51:22 +0000
Message-ID: <CH2PR04MB6710F6367C3862F3107A78F5FC1F0@CH2PR04MB6710.namprd04.prod.outlook.com>
References: <20201005223635.2922805-1-jaegeuk@kernel.org>
 <20201005223635.2922805-4-jaegeuk@kernel.org>
 <f55c7b379283bfb90e884e9b1bdf170e@codeaurora.org>
In-Reply-To: <f55c7b379283bfb90e884e9b1bdf170e@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0c15e6e2-e20e-420a-4481-08d874e615cc
x-ms-traffictypediagnostic: CH2PR04MB7048:
x-microsoft-antispam-prvs: <CH2PR04MB7048B4E6BF47A31BDA8DA2CDFC1F0@CH2PR04MB7048.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kSfLo8eomctpKVL5IVjtSudfEqA28zrxbIOAIM9byEtV2/lbakGI0kHc6ePeACHo//fGKNt55nlIXIJIn5BJ/Ew8eGtOBCeWC/oYsPegLRV3/AM5V/CFUGEBYhLFLCOT/ZLtxg1SEbbwuH8XvH67evPKPNZPKtafx2QnRRORDvL3ZOCVSiZJsRSP88/y384OkUFjNe6D5EnIc98Xgtx7QOotTdwDbek+v94Qdl5ObmukkpDcbCEhQA/mCM0ZFFkGyRO0aToQxlLtYdOnyyGc1YCT4eOmrtibk3ge8PR8tntmA33a2dSUQ5WYFok6lHPcJaDLyh7UkeHUaeF1aDWf3g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR04MB6710.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(5660300002)(52536014)(83380400001)(558084003)(9686003)(6506007)(54906003)(186003)(33656002)(8676002)(66946007)(26005)(66476007)(66556008)(66446008)(64756008)(86362001)(53546011)(7696005)(478600001)(76116006)(2906002)(4326008)(110136005)(55016002)(316002)(8936002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bDFievUX8Qe0ofkQJGi0UOQhClMKSCEG3nDMY4ZFHnhqiB7uhQQoZtpDWwyPHAW5HZVQ8hiI2k920H2XaCq11aHU4786LmbEMir1ZVIybW1ZNgtBvPhyhBPeKIip0EphP8GEd9IxayDXuCqq8GViAX8kKV78YAaO97N+nuZ4gYmzRYMk6cQ6Cs0MjOjV8c46rsaAdKbBXINA0B3HzFWdvSKUyCN6zSZwYmug2rEzWMlnlBS0ETUZMrPFBe1i4VMHNjG/v9rKOfe1FnyZuCYhuSjiHKVxyxUBRRfcUkOipF/XC4oN4QYQdAxKPTkY1zw77xKV86Xukq/L4c3kSy4cPE+xFuvIHu4CN0HbMrelcgDZxEwYMDvKnmMxqIcxfl/BmdTuwuj80K14dJNjkNIDW2QjWkQv3Ry5zpccKeR5ZxWjnGKA18eg6vXnBNEjXpiMXxC3HFqutlj2MGlWd2NxQoLzwikARVTxJwW5acL11f3zXcMAuqQGye42cykhGl99BR7zuPFFptu8PF863ywVSg5AStFQ/tsqKltCmKPl4xGlQ+yWyuKZySbbWR+lc6ZtmoLBImcKfcN1ar4bLWvI6b3n9E/mD37cJJtnLzFWudl1VuguOd2KH4sa14D7I+HTtq8iZaQwPQ8JWLjCDBlSjw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR04MB6710.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c15e6e2-e20e-420a-4481-08d874e615cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2020 10:51:22.8589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CMe6avAUnxcLkYAPZGIgrnysA/1y41OFfJoI8AKlak291ckD2w7yMWuYSwxU7HGyd9k85Dm7m2iBK345oUosbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR04MB7048
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> On 2020-10-06 06:36, Jaegeuk Kim wrote:
> > From: Jaegeuk Kim <jaegeuk@google.com>
> >
> > This adds user-friendly tracepoints with group id.
You have the entire cdb as part of the upiu trace,
Can't you parse what you need from there?

Thanks,
Avri
