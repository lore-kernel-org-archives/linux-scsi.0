Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFB6EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:51:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGXUv0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjGXUvY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:51:24 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6948310E4
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1690231879; x=1721767879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OT1GjXBtOAQWMUF2h3j/5oftWxJuaNRYKHItkE3yS9Q=;
  b=C2ocNkLYsi1sk8tDh5BVWlrodu1/BqB2WIgoIvYpRNk4fRPWyK1K5u3G
   kPrXpiACPfo9Eoa8HlW2u3wUomGIM8F+OvJcbosd5JOD5EmoTZV5k7B+c
   G42tqezEgd718SJoNYxyVd6ZL84J12zIVZjW7EiOPWPwUNYpe5cSTv8FZ
   7HjHT45MNnlfuhd7NEOGx5bksNMMIMzPfqihcEHj9H1UNnrufRkQ18OXO
   cLOcIy1LYddg5m/o+xwi7/AVviUCKKuhlsDP0HYjnhLxmUn9kN6LZOwAw
   IES+ru77HXMB/0ELr9a8nv2+g4bDPbNzUVr+/G+rRQlVs29fzZx/L05np
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,228,1684771200"; 
   d="scan'208";a="238752598"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2023 04:51:18 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZqIfmHr2cJmhrY39OkMUt+hW7oqMtPLVjDfRiHdpXLxfzz9ioJ7T1boNrfY762vcYRHwUQhXn9KXcGh7QVPRjNXO526CWI7IagV4bein+ib4CHQCebx1ZeFSqov/zbjzDU4L3yz+KYXDhpeCiFLPLIxA1OwQwZEDJ9pL9iGtubnimiqL3T4nd+Qx2gdBy4upwFjonufLdnhWrUlP7ZVaXpCQ9NaOr57y/z13spc/n4//qIBGdZRpb7gbAFjWsFh0mSO/29KaQfap8DHvBO7xsY5IAXn2cwLddLiyo8mCHpq+g9t7E384KhpJaMK7wcWjj5HJons68FiGSk4EI3wJVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OT1GjXBtOAQWMUF2h3j/5oftWxJuaNRYKHItkE3yS9Q=;
 b=UNyYdGvvX9s4gWbToWjazNI4gPiH91DN3tlvLsaPcnAa8WbNsHhVUl/7/T/ixR1VtwBroY1pLKL60mu0PghgGJKX3rTD/eq4PMr9HSlxiqacuL/xbiU0ZT5iLAyRzLdKMIm2q2BVVVgGEy27g07VynRNoL75nRh98yQPaHSjLW5pmQWZ8zxP3054DHEpQ+w1mnF69XYbjoO+ghO9mBrqB9q7cDlKECUYlXjbnigd5e9cSvo3LhPK/R+tIAy2lUEIz2CqJHSnrqEkk+3pO2xP83Anq57oN7OwEgSI7QTgnuhPZqwyO/+RXCTf92dlwNU6U7aXfyK+WYXNF5HbATrD0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OT1GjXBtOAQWMUF2h3j/5oftWxJuaNRYKHItkE3yS9Q=;
 b=gCqhE3Wj1cu2PTxb/qWbbpYNwvoEi+tlpfPmpt9njLYEo6aaA4sI7EvDGbjx3nU0/fvYYBodVN3I18vPrHFHsNwTY2920vlrcJLDw/41Klge3pFlWfQn21DoTWpdkblJHXzdjo+RHyhVQMOwzTOVF1ZDcm3G6Xp1y8ySIdqGcQE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 CO6PR04MB7585.namprd04.prod.outlook.com (2603:10b6:303:b3::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6609.32; Mon, 24 Jul 2023 20:51:15 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::4781:1e0e:9df8:940b%7]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 20:51:15 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
Subject: RE: [PATCH v2 1/2] scsi: ufs: Fix residual handling
Thread-Topic: [PATCH v2 1/2] scsi: ufs: Fix residual handling
Thread-Index: AQHZvmq97J37AE4OR0a2T2DLfGAQK6/JZCMQ
Date:   Mon, 24 Jul 2023 20:51:15 +0000
Message-ID: <DM6PR04MB65759AF898382D9CAA4AFE7EFC02A@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20230724200843.3376570-1-bvanassche@acm.org>
 <20230724200843.3376570-2-bvanassche@acm.org>
In-Reply-To: <20230724200843.3376570-2-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|CO6PR04MB7585:EE_
x-ms-office365-filtering-correlation-id: 3634343b-6f18-4ec0-2116-08db8c87b8f2
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xASaQ7g7mKzAKoo25x5ASGeamupI+ml2+hokwEvc9DhMmT/t5x3FyUBvNJcSVUgO4kVBBWrDWgCvf60pMsBlkcK56Kg1UviWxbg/hEI93oclwBszpa3eFMxWL4LPx980i6ir1fcvSmqq82u/yXZKVAcS0Fhe632cYeUqN4dpupvnZrD7fasHdr1Pg2UH8nxeRKUNX/U3/pu0bsgl+YXdPz1H3GkF2qKbuINoiiCTE1aWzAlNCSr3frOqkCgShz7mA/PYtYiXuhN/JruVIuTl6x0mR+uMJpOKiO750Xjz8Br5YQps3YYntsJ8DqNNUgqhPkPCzMHuUJEZvzwbQxUc++bQY9Ukrd7MAHX/6nqSK8kZtG+aGG00huJM6VljXYWla2ZLcrwbAcLOE0HoyFeHbp31bQHD9DqVwb/wbBrQ+Cj/M6lR3XOKNxHMS7BM4cEf6tVPkdEOHWT6Np7QCKKf3LU0zGS6cM5zKa8VBN866vbJPN0X9SLQjnvG+TZ7yjdBex42g3NhY4GEnKNIrZMK5qCH2/dHftXmcsymicWZQMx1U2WYJRJd798kDKPnYG/6ezA7Z4w5gjtjXqBaJEc7zZPN+AxLCfTDaeUZdSX6BfmaJv8Ye1SJZhGPtXdqfGf5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199021)(26005)(186003)(41300700001)(122000001)(478600001)(6506007)(9686003)(86362001)(64756008)(71200400001)(66556008)(66446008)(76116006)(66946007)(558084003)(33656002)(66476007)(38070700005)(4326008)(316002)(110136005)(55016003)(82960400001)(7696005)(38100700002)(54906003)(5660300002)(2906002)(7416002)(8676002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?wEgDeVZlQIUWZPoz9jFYKziVtkASdrJxdOobpCWDNFMC3rMLJQjl87S4hP1i?=
 =?us-ascii?Q?CWr9bAkn1cy0HAi33KhGolaEvc1wf6X6HI33bKXkNDQBmqcgFp2X7a2qoH45?=
 =?us-ascii?Q?xoypTR/oE990dqbrfsVSGkPBNkUg4rM4PkMsn4nmaHVn/Dv1XQ3XYL06DuvO?=
 =?us-ascii?Q?x7CQ88KIrGToR5OACQOG+3ofKm4JRVBZ59z6oL3mZvUXE+D0dHo6QlMudCf7?=
 =?us-ascii?Q?NNV8SRDW0MFPLh2qx0LOXA4qSpdkL9tkjiVGQGX7m3GawStuUzzX/+vEJA2+?=
 =?us-ascii?Q?uVcNpkr4DXuvF4JpYvrWPWyDbUR4I+WXCt2kdnq/VY5Ue1nJVQLdU1caE/wy?=
 =?us-ascii?Q?Vq+n2A8hVztJ+oUUYwbdt9awU9yPOgnHb9MawwaWTNu7Xrg/u0JqtKayVDAI?=
 =?us-ascii?Q?Ky6DehnXs3+RQB3EKWEW/i4yzcxem72yr6bY+DqnthpQqfVQfIzoun1teony?=
 =?us-ascii?Q?/0bnqggW85G5Wb61ebAJKpC/FEwsxtER9J2EvUOVqjsok1iJLOcTON+kqL3F?=
 =?us-ascii?Q?R1OQwVAbwAiA8+vWv87SKgakw+tu6KjtfYwchndOqWEjJbpcelee0PnE4vhT?=
 =?us-ascii?Q?2eP95+xZVVoJ/PH2Pyzjv4jQqNkPA9FmgoNdYSiC8AR41Aqd0RmCwCEq0l+y?=
 =?us-ascii?Q?+STd4l5AXiDX3R0xDDFTaXQPoZdgax5f0HyZ8T1Jes9G1KK/KtOtV+zW5Ubw?=
 =?us-ascii?Q?dpBLzRVws/R+JArYswaXw0wvbe8w8bqtN+dohce2RtHhN/qiwuaz24MTABJ8?=
 =?us-ascii?Q?Q2FLTOabg6ANfP1hRbQScWzplr/hvY43g7faKjR0d/tYi8TUJ8JY9ScS4GSo?=
 =?us-ascii?Q?tytJhW+X0OCeoeXSELnwOio8IZbkrlJcv+qocOuhYk6SuLwKzFvH+qbNoGAi?=
 =?us-ascii?Q?PxZUx2WqcEinjFQ/9cDxBH4p6a7HvxerATnNjtPq5og2WwfHRua8JwcXhzg2?=
 =?us-ascii?Q?cEa+jhzfPzuAW+kGGZ5outw/l/uOOJe94Yedk0KHAGUjW6JABlJFEEx5T/bo?=
 =?us-ascii?Q?t7s8vJGvzL382yLPDvgWHI57ZU1rAwoqVcG2mqNyVm+GbOyOVti7iQp3TnQ6?=
 =?us-ascii?Q?/PHUUcO2ZRiCu6SeoIUHhbTnc9fG623NX1ZSJFsIWV33tNTQTqSz/AkpCaWH?=
 =?us-ascii?Q?s9JQlcWdvRjt6ln9LoRi1EEU53rotdUf3cG+4q47YGHtKSnVtoDc/G4VQT90?=
 =?us-ascii?Q?+2B7CEslTjMvhA8k0/vPbk7xGBLQXj4IU234WNjpOChS79keqjtQp7W5c5Tt?=
 =?us-ascii?Q?UxJ2mcqVX97DAfiQ7UPC6ZPS0+SliTuFwsAh5G5nOL/GvaFx0J0kcoQgfl8k?=
 =?us-ascii?Q?a2EMXOXz0rcogTS3jyzfL/6hlTAHmXtXO5zLWL7IU0vSEH0tXRuSC5v0cciX?=
 =?us-ascii?Q?wl5OvvgLAGORZCLKQ/3t5LAgAA4W1hqIOSh9NDY+PO23s9FwRhB0YAGdZjW2?=
 =?us-ascii?Q?pqYfaThsCCf3RS7lRFCFTHcJS+Rg/Idt2zyapeKAKw9lqWkI2awQfrUrlcZD?=
 =?us-ascii?Q?kseth8PzICBPHAgjXBR1hlOy+StadT1LF4jlcvurz6bFXduzSB/OnPJhfdXh?=
 =?us-ascii?Q?R5e94U0IwrQmJRTa5kHmMrscIwvjvFr1dLqqp9uG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?rMkAGUrB8iO4wO7DqzmTM29DURkSbh7tl6P29PMvSaAc57Rwynm46I60AHUp?=
 =?us-ascii?Q?ojTjnlmxxnxWY3mZNPRDXbzExekWTorzt+hXF36Flxnj9opQSDNAIRXpi7ON?=
 =?us-ascii?Q?G+MygZHpvsa22kL5yyBbkubNr94jxS3FU6UGBrJADRohYEDfWFWI/kVTmZ4I?=
 =?us-ascii?Q?sUgn3ebN18mgiTakEZ/apmYUG4CmqlvguHtbDoLCXhg7szjEvJ3c9VBUy7xc?=
 =?us-ascii?Q?lsETrxZAdTNNFOo0A2lAYXNDwYuiqOvJmO5ggEtKmQLAzyetFnbOeULVuhaF?=
 =?us-ascii?Q?r2Q4xyB0tDnzeGwee/cBSH9QFFtYUBF0mhwKAaLfvkU+XJe7UafyK1rRLsJf?=
 =?us-ascii?Q?bltyCH5bLNXc4lvzSZRsuzPXS9dIeo0T5+eCuhLsjXeK58cLg6Rp5bpGp2zf?=
 =?us-ascii?Q?eV94yYnc3jZHRLp9YSdziC7wDV1fbooBZ89oS7l8QviIogV9SYy0+l4CzSmQ?=
 =?us-ascii?Q?9PpiYFqm6Ax7Sef+Jxxg8GyPD79f0aW5mPR1ssyMNnhP6hkDUkjX6vBvRcRQ?=
 =?us-ascii?Q?ZVdZYdMysSFo3FXc3mWNj8b5aU0i55fwTNZPOJoTrQR2lxRxze5BlGJvIpjd?=
 =?us-ascii?Q?K+x9SAk58/2iDGUXw+tNflhNte9LlxtGv8Lx2ym74HVMb7qWqUE/Z98esR99?=
 =?us-ascii?Q?D6MhRsM2MiDQgKxuDN7HN1of6024rnkK3u9BMjIRUm6H+Gq90QHzpofe8dPN?=
 =?us-ascii?Q?Q2T13B7H52D5+C5YjdDVPH08bujlYloooJgPR6n3r8Djkcbqz2CkqkIPlaah?=
 =?us-ascii?Q?NyUt9F2Awou9bkulCFeg9FxNU2CLO7ysNPUua//rJBiUU2CNurIu1ed/8Xe6?=
 =?us-ascii?Q?EVAqz6/5DV1fG32WJIZlFD+XRqAaKCabL0lZQjtjfwSjTzBBHiqW+npclT5a?=
 =?us-ascii?Q?0OpFou6HfxMaIBvrIZNI4v2VQjf11I3NJqU0+cTArQH29kpXj9rPOwnqgspd?=
 =?us-ascii?Q?Yid9rmvrLMX8/HtKZOfWB3Wp43r5Hwk5Eql1NslUJas=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3634343b-6f18-4ec0-2116-08db8c87b8f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 20:51:15.4077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HzhvN/qXjJeXqFBRDrjjyo9V6+paUZUM4lZXwiejI4YPsrTkklyVY3+E05EAk7sM2gDaR3VCqME7W+IuXKZrHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7585
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
> Only call scsi_set_resid() in case of an underflow. Do not call
> scsi_set_resid() in case of an overflow.
>=20
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Fixes: cb38845d90fc ("scsi: ufs: core: Set the residual byte count")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>

