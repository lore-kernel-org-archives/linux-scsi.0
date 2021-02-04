Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE7C0C433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CD0A64FAF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Feb 2021 23:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhBDXQb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 18:16:31 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21580 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhBDXQa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 18:16:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612480589; x=1644016589;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=8Z28lnyVxGzegXBe8qLIBn0PuVqMuqMI7pjnj9jGK60=;
  b=RjTWuSfPhhsGYgrg3UzutEQVu4XzlBFAkW+D+ej6+tLdkLGRzKTerxmU
   D06nUc88wMPOPLXxVobyxDGImhdg6L5kazCke92SuPBdsuEDSvHcc3/Oc
   WUxoZkFTlufCr+DKP24eD9wooJ4NpaGG/We0Ihurv4f8jNMkxQnUkIysD
   56YXEIUe7hoKlh1mIop6ynOOU1MJEkrHiMUfI6mmcS1R+ML5ROHW7TV3L
   jPFCFnwyc2JzFIikiLqTn806yU4CtVFeTceCNKfSp/5OuqG4ISJ3/67x+
   zfURjz3NZr0dbfL2dmpL2zR+mHPD8Vt8f+v8QFOFOQcx6C5g8MhEW2gf4
   A==;
IronPort-SDR: cEYHcpne1Dh7LLk+iVo5wjEcz7P39XflnBPSAc/DjEd0HybtofxalyDDZ22g1rzqr7X8Rve467
 w1Q8WHp1w55xokEG4dUAOv6gIPY0yyD/xg52UdvmGH8uwOVsNZEZhjL+T9OHxZosRG4S9DAW0F
 pC5d/TSUlIt0gTKklqEldjedhpchDmV5fW5z9NOMMUD8r3e8npompsZ5i9h7i1t7TT4hmVYR5t
 UmtncJ96LWGdojSQVgeg9c1llItoyPGP2l/G0SMSk/X6Jo7oKx7y622QtqpGRqEen487Dr41HN
 xiw=
X-IronPort-AV: E=Sophos;i="5.81,153,1610380800"; 
   d="scan'208";a="159179031"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 07:15:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXYrni7+m+BVWp+XAKscsPWFFtPtpzbPPSZh+07VDhpua1+7llwqaiCvk6q7vqe8JC1160gmc5Mi6XSbaNGJA9tckqVSyqa0BkiKO4SjYfoOEXLf1YAgowP95b0QX4KvhYUTwiARR9opUkae0zKrkwdKHBCBYATIeGZIMMS603sKottRnpKsLyvUNYfnnpVGinI0YZbSOi+mk6FsIu75CSfWKlgFNjTC/KSAjk3z1iCh3O8DGrCesRpfBn/3GjvSImUwWS5tkuRKGtywLU+wuCiHMfNwGFv7Ye0Nxl0IrdhCOpgvoIKPt+nxjk/gG1fCGsXTNHu66F18PKyqHsBTdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Z28lnyVxGzegXBe8qLIBn0PuVqMuqMI7pjnj9jGK60=;
 b=St/mZl5Kd2EuMBdMqt71e/XIxSW1lr92tQiNgQfYSn+95ixKqttFwm6bV+tmuxA6ZNdJf3p/5luJhKuega9BkOKHJWfKcxEPaBKYH7AkfW3yZZzVYcBMhSRYS79Fr21xTfVcG9U9NztI+75rkRQnwjC1r0dPr9OI6f/gTsHELE19E3gRrrU8FPFeRV3DS0MFCymfziA/Tdqvo4djsOoWlrnbKMzOJ3Wbaz9ZH9oESVsMjicP4ilJdiFMlfpjLgDni+nPdUhxtDfSADgBaTQTcba++U2I0gEB7VA8QD6oCr4N7go+DcuCGBc4YNh8CDXJoBdGlGtd2h/zlKmVW7oKPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Z28lnyVxGzegXBe8qLIBn0PuVqMuqMI7pjnj9jGK60=;
 b=i+TxzkZ4d1SvbEsyHw+0mo6Gj+y55P0Z3Y7Bl+WcbXWZN8YrTIY+1ekIUUugFCw9lfGW6SUP0OFyWoRgB7jVA5JeBQ4wp4L4NDiqeBxaNd4moE62remjXeYDkUsvYwRBD3Or9nrVGSlAibO5MTrtC7AuXLH02fecXpClmiRTbqY=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7694.namprd04.prod.outlook.com (2603:10b6:a03:32a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.24; Thu, 4 Feb
 2021 23:15:22 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Thu, 4 Feb 2021
 23:15:22 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 06/11] target: cleanup cmd flag bits
Thread-Topic: [PATCH 06/11] target: cleanup cmd flag bits
Thread-Index: AQHW+uqASyfFD75GCE6ILMCzQM+nGA==
Date:   Thu, 4 Feb 2021 23:15:22 +0000
Message-ID: <BYAPR04MB4965F14E79A2BFCAEC55952E86B39@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-7-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c1ea8ec2-d30e-46f7-18bd-08d8c962bf2b
x-ms-traffictypediagnostic: SJ0PR04MB7694:
x-microsoft-antispam-prvs: <SJ0PR04MB769490E501A72C7E59F47E4186B39@SJ0PR04MB7694.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Je635zt7GG4EamE0qJa18Kr4VI6mR5LcGgBRSEA6Id7LsSBGA+bqkkdCnt23nvPb+FnE+LPqdBExRECY+CwvbUPEIlgP8UQMLkM9xSXBe/yKFPBwqTHXpyPxOGmrI3hnnWdFvLYblqR9yJ82dkIgbeb8kgTWRxYbx0FOzCskkzlnIZnhx74sO13cEqus4WnNMxBJYH3LsWgbt2HFs+StdgcGuzPqsXHIZshpQ+xhsurT6+Sp/XH2ml3yszX+Aas8otCIkbtd2TZk+0/tRxZMNAAY9d7MaOrKUZyclEARHWg72d0kqUM1ZSfLhKyRqYCbS4go5bwXDC7j2Q9RpIbpbBnafEjyREhAtec6ek4pmZjBjl5nsuLgtpHtOeP2FOGS+Gn+nG6aBHCMguBaNBSy/QjNH4bcGyrRq9nRfEr74LT89fweL9R5KMpqS4XEehZE23sNwLHJh4L7gA3uynqfxfgT5PMe7G1T8Wv0lp5AsSjmPiEgXKjqdxn7JCnhNkvyynLRrl0wtHtFXRF5YBoAdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(5660300002)(66476007)(64756008)(86362001)(33656002)(8676002)(76116006)(55016002)(7696005)(66556008)(9686003)(8936002)(110136005)(558084003)(2906002)(316002)(6506007)(71200400001)(66446008)(53546011)(52536014)(478600001)(66946007)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Hnpy+RCgvDrllJ0lw6IkcDlSSRkrCO6qdbUEVddo1FDf2MhVs1Ml82f4gkSU?=
 =?us-ascii?Q?BGBYl/1rc9GPTP80+O6gpa3ABT+URUTBBbYmEsTpYDTx09LFvufEYhCednIl?=
 =?us-ascii?Q?lUuVf+HoQM+jN3yukqzxaKMMx1hOhGgDmVJiOQ+KH4ACZSh18bnsilVUNH1G?=
 =?us-ascii?Q?gytpBtAmUiuL5x71Lta1yWBqn8QZX67s1xJ2xyjfTc9dB42KeBdP/LTQJ9bz?=
 =?us-ascii?Q?ozjq4ZQnkSJijfpq7nckdJHNKP6927w4SuwHUBMXeogSwQXAnzaxeCQoSECP?=
 =?us-ascii?Q?stOnPDr/lHeWEan2Hn7B60NxkyW2QH442hCEaTEmzFAay2gUo5PBZuohgK53?=
 =?us-ascii?Q?XqMSPverHd0/tqXGMacX/wnSWlT485SFPksDDuaww4x+4zYWhZX4t0f7YGNJ?=
 =?us-ascii?Q?4vaajClRB3MDyPZpmKRyLMf1xgQc32A22t9Nh+VStQzlnwySsRGleQXfQfnQ?=
 =?us-ascii?Q?dAo9fSMG65ncOXcAYSMxGkvE+q1/H+0WQlvEuySbrq217DgOs5pJYCp67MJx?=
 =?us-ascii?Q?brsdK4ZNbOipZhZwCbnZW7yWu2gVxjm+QKuAVe1KOqEDlPjLFoxC7QsU7+Qd?=
 =?us-ascii?Q?LHk3WwjBhn45/Gh6blXz8EvPvtIkN2My0GQD01tPccJ8sCZLyYSz2OQ9+qct?=
 =?us-ascii?Q?8bMcQqPsAQ9UT9JYcxB19LKG9kd8jCTjNk0DM5hrWLIM3VqBb6rAGnd/k6Yx?=
 =?us-ascii?Q?s52gCeIVtANJsEVvpKP5mABbeo4NykWVslDnbzHXmEMHQCM4Lm/0BgAgEX6w?=
 =?us-ascii?Q?I+QVNYZ0PIirvRwQnD8/UkEXw9HHi6vx2hI3ItqrX310n7LSfCIxnWSLWpT5?=
 =?us-ascii?Q?OEKNRG433VA2VxeZlzM8Jzz9FgSHBfGyJ4vTyn0VOXET86w7HyzepKKqW/De?=
 =?us-ascii?Q?8WDVo0/9d6r+D2gsS2QsmG4FQdc8IJRBj78C/AwEnrg/ojUZVhZh9n++woKm?=
 =?us-ascii?Q?ZMc01BAyJ1y7mwPE3M9Qhnm91SWMqZaZCJsckc5LYnYNtZErYtDzFHWyWaU6?=
 =?us-ascii?Q?X06FyitDZx7tY9WaZQ4/M27Cv+CpLyJsaO6aKb21KWOKSMelHU5ElL02MS1I?=
 =?us-ascii?Q?tOEKTc5pocB/cbOn6XriL/zZJwM+lrm33a8W2V3dKHE3GiC2bO1WsNOk9QSv?=
 =?us-ascii?Q?oDqvp7u3Dp7UeXtE6iJ6sVvrP9D9Inz2bIZhaLiWyU1gPkAzRnnzWZ3tHLAy?=
 =?us-ascii?Q?5H5kjl3uTVQqKlANxsvzdmQspKYVc/xL7x9AJ6l1iby+xccJUrvAD7wFXqTE?=
 =?us-ascii?Q?+guH8BSPLRgSw9s+6cQZoxDi19Ng9fziSVW7gQq+W+1qeiaF+xrcsHE1JcWC?=
 =?us-ascii?Q?hY2x0O7AmmyM5DBmf9qoZxZa?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ea8ec2-d30e-46f7-18bd-08d8c962bf2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2021 23:15:22.2926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jFROOTjCtmZJByO7wYv7VDP8M7xHwBAkw2vEz1I0Vaa0ewyNkFS5Tx9wUgFWY0NfPHkH+FVatal4Fppksx6B2/8J9ONLH4344uVqi1h3Ds4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7694
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 03:40, Mike Christie wrote:=0A=
> We have a couple holes in the cmd flags definitions. This cleans=0A=
> up the definitions to fix that and make it easier to read.=0A=
>=0A=
> Signed-off-by: Mike Christie <michael.christie@oracle.com>=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=
