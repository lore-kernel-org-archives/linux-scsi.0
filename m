Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30B7C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 18:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351279AbiDASht (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351265AbiDAShr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 14:37:47 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1241B8FD5
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 11:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1648838158; x=1680374158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kzGolHpz/5aR+k0K+sgmc1T7W6Xy0TrBZg7Z5GRAjcw=;
  b=XiN9byOpqfLCy8n6fhOEtDlGcjGD5F4t44XKsu3m/gW5e2pG7MUc9wtC
   hqXCi+0pyU6szCq7PM5Mzxu9F5/mItSCWbcWPEFcLWDtZ3VQgB8zdBI5i
   4eFG8xRBJ5lLK6Ai86jLhQGXXyKaZYnRRP7mpA4iHlIOh9QkHcNPVNJqd
   4a67UsnThmbvTJQl+pVMc55lBXVPwZsCYIfvf3Xcw1otesaPBIaSvxs5R
   5R/PbeIKSMxD+0Sprd+kMHhzIyxuyIhtqskdHs12rIYJgOsOgXXEVnFTT
   g9wrxoiTzCLckLL4bcd49Txnn/FRFEzIkD6s+QI6tOGSosfSMQl9OxG9E
   w==;
X-IronPort-AV: E=Sophos;i="5.90,228,1643644800"; 
   d="scan'208";a="195742449"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 02 Apr 2022 02:35:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hwNk3+9RFFpw/0WAajIgpddOWs8EGUxF1fBPPI8w8nmXwOsAQk+TMs2lrkB/6NUURW2EFqEDGR1ZTeJKaLAOVCtacF2VZ/CZ6VMdedAFSwAwXmhwKrhNRR8a10Ib+BueIGlzm0qe9wuA5hepVzkn3vLJ+oP1U1q5UrJVF8YSNnHsWytMKNIVPWQDgM8chyP/tVKjofUgFSm3xpLrxefE1HmSDM54Oew/DMq7kJH6HG3IG8XH3CuAUykDNOkNKRQxgrl9kfP/mEpHynar3oDAx0Z/ljTTtwFi3rEpKUSeEYE+4MuijbRginQqTmGiXRm9sFz/5NMXtG1c/Kn7fjagHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzGolHpz/5aR+k0K+sgmc1T7W6Xy0TrBZg7Z5GRAjcw=;
 b=eFPhUNtbnvCClbLj+YIls1GBeynriUvoT/p5TfcB5vOlDUER8txHaSp/OxMuCx+4m6m1STuTxE9nr6I6jRRZMhuKjPxLvFbuBnvVF7aPsyrKzerIwRxSPhv3FChr76HA8unQuj/RenX866noXOajCmgWrcjusYI9H8E72J51emBZhrQV3dZC/TLcAo6S5Su3eN28RRE5QjLmSTIYqguYTRV51gHFLRH1b6hrAL6zVwhSth8u6PJtr9QYLv0rMXpOkjtp+cByKO+BglOy+rfkrnw81WV3FQbo61+G9jgdvku+lGivFiu04e5NnuUesWnjt9zqqTSLQ5+rcaJu4BTbuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzGolHpz/5aR+k0K+sgmc1T7W6Xy0TrBZg7Z5GRAjcw=;
 b=tgbnLh8GLhwFPoghHbFkx+CAASoXAXjmGPVk542QDQQWrbk98wsYWBuoQ/HVoG5L5Q+wDEf8Mc35tzNXcCh5q3h0mOkIeVDvec6mg8XFj8YWlCYSXOSdkTl9roVnzMCeHbH61UV/kvFjLxqxgfw+qXmcKTHkFnymD1V215Hpiik=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BY5PR04MB7074.namprd04.prod.outlook.com (2603:10b6:a03:22f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.28; Fri, 1 Apr
 2022 18:35:54 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.026; Fri, 1 Apr 2022
 18:35:54 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 02/29] scsi: ufs: Remove superfluous boolean conversions
Thread-Topic: [PATCH 02/29] scsi: ufs: Remove superfluous boolean conversions
Thread-Index: AQHYRU+Svf6OiG+NEkWGna5Tv9LQBazbY84Q
Date:   Fri, 1 Apr 2022 18:35:54 +0000
Message-ID: <DM6PR04MB65753A1233A1671C016009ECFCE09@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-3-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a70a91aa-7cd9-49f5-306c-08da140e7482
x-ms-traffictypediagnostic: BY5PR04MB7074:EE_
x-microsoft-antispam-prvs: <BY5PR04MB70749202E0D6AC8F89E47BEFFCE09@BY5PR04MB7074.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+PcLpVjLxx+FrtnsKeKtGSsuxMRBRkVeuLZ3BYIBIbU0gkOZFmzQ5D7ViqlYdyQdyJ5dGo6SAXkW94GkFmu62KpC9QiUQQv8qJH6eDKoDGVXhqkPYlWgS7epVPtmYEkegfsdbZX5Nf556+8rwd5R14j0Vp/zF8DcSS2Egu7EjmRqC/DBH1Qw6Uoyuow3PCTdxQBTctN18WElpM7qmTNB4LoXj1pTwOXwZAq67BdDg0RFreKR9QKFdCtvIUgKsdeKwvnaGUGnp+Ld97oYE1nxJ9hhlScvK6QlhzfHU5aohdLOy489I9ebJ+vc+Zh4HLbWWf+FQ0WPrNgiWORCftaQ0YhyZO9NrIY30WWQLNzwfxQTVNYpLvsGpCof4VMr1gNAtTg6miDk+LYqnpVlcZJNB+689Lk2GEXoxMA8BB+1UtKxB5iiEqMED6xMczMiZMaTf7C+5SmsvfL7Tq6+km6FwB2lqoae6huB0eRnCt+97nOFdYWAAVxsnhzyFsFPrrOngN4fm7AEbJOZnNZoAuRETKLzkxcKt3lNptrgGNR52/ItUu558rxXiA97kDZdFgGhfcIk7eOdpXLvdGcSp77xBvBGixbEGUDWUGKYS/5iQGknr5fN4s8ipPZ/UoamZiAMzUQn9D3nAU+JjHonp5ojogBQo2Dkt/kkwIM1x7kaFirrCehkMJ+/ka3XvQpYHTlfgKLsHWC4FuB6L7MYWKb1w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(66556008)(9686003)(64756008)(66946007)(66446008)(76116006)(38070700005)(7696005)(4326008)(8676002)(186003)(26005)(2906002)(66476007)(52536014)(110136005)(558084003)(8936002)(33656002)(54906003)(508600001)(7416002)(38100700002)(55016003)(82960400001)(5660300002)(71200400001)(86362001)(122000001)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NhoYNonvtSGxzXjCPjFgmFwRYTpcR9IwveudgOssofmAx0bzOJP64i/4B8Yj?=
 =?us-ascii?Q?HDDwv7nsFonhpU9Y0Gp+7OkdPwq703ME4nSkaiby2ZUcHjyrRondYF1g//H1?=
 =?us-ascii?Q?K7Lejm0qozoEkcaoBg6JZKhxjpWcKMLm9Q+RfB5IlhlFfIqE2AOpteksqJYf?=
 =?us-ascii?Q?I/WNnxJ3+c7xRRg3vtnR9F5Dm4hmPGcGqeXOflnauYPOszbc3psL/+3aTnCs?=
 =?us-ascii?Q?f6AecOM+v9U3x+9k3PDg/unXsxz6kLwzPyfhZGi4i8z13TXdsCZU6eeNT/5A?=
 =?us-ascii?Q?qMMlHav/o/FSpOYuxiKnaJpkXnQRmDUpqibj2ELioHx/6yHeCBdNm1CfzRGb?=
 =?us-ascii?Q?6ve6lgDguzlH0FDth9vYFVu2Qlk8l0d8ZuCi9U9UUTWVZEI+G9abLw9n5p2g?=
 =?us-ascii?Q?EcvH1uc6ytK5WMTXqHh+SJUsNGE1aML+ZFTL5rrwbCa23IbGVzpxwCi5Y5Nw?=
 =?us-ascii?Q?25Welre1LMtbxGWahmlhTdpCWTdvuwat7d4QdntcW36PjFs1PS2aXzdqgSMK?=
 =?us-ascii?Q?9u0bhUz2V+aGieSBotHqnbqfhFUIRkQNhWmJmGrr/uu4tpaCAMsLdqImqtd/?=
 =?us-ascii?Q?CDGKaUf2jIbLwh3b3iKt7lqr8M54REj+y5t41HH3BpDQK7b8Rsy3zQB3kCQr?=
 =?us-ascii?Q?XL1hc9jnegdl8mTEZBpwONDl4Fw/yhsduOqx3kO0iMHYchL820y9Db7ugTcn?=
 =?us-ascii?Q?S78Q/9PHLKctRqbO9rZHhNqXw3t8JyQ7M2eW30TUvN9kWiDBh0ef/WmAxlWQ?=
 =?us-ascii?Q?TEsAmDUjxYt8FyM3M+NADvrSVgw93g7i5+/DgwvPolIiymJZtlQupRcbpY2d?=
 =?us-ascii?Q?h0G/fSHpojD8DOVrEU3MH4/ufArcD6MDX4NtT2DcX6IcdKkz0aTDb/rAF/3P?=
 =?us-ascii?Q?TpnliIp73LLvn9Bf8CFWBArTGdnk8EBrb0nTuPHvRsP9RqownuBcxNI8H58K?=
 =?us-ascii?Q?SmyThxFkA70uOSFiBv3oQb/iU6dlBmoKpQ9lCh1mLCouFFCU0Rg3NopeFM/p?=
 =?us-ascii?Q?3p2rN1S3LCyb/ssezTIesuHHm1HrcmQ8OYMNkv5HjC40kI/C15/WNgCt4kFW?=
 =?us-ascii?Q?78uusPOdxzM4fPJSSdwQ+0i4Y8O2DsZSbFzX9klaPQvDENYwbIJfioSNlAsJ?=
 =?us-ascii?Q?zUZ9xhQdOxvd+VLUz8xdnhyBavu2O0j2kjEFoa50nTRrpMDb/au9rZUZofT9?=
 =?us-ascii?Q?apI1DeXoaAhNotyxDLClyhet+a8WP1y1YybBccLGnOtu18ZFhbAf0K4AKUxR?=
 =?us-ascii?Q?jggIwJ2/RR8jNILc686YQUu8OABdL5evhLEO4KgPpgfC6U9UMzcXx6Yj0z67?=
 =?us-ascii?Q?ieYWZ/HG/0eDEgmKmytPW2VuPbW3Sc1lLmhY/r2GitruBmvotsdAp5We3k9G?=
 =?us-ascii?Q?tricKIc7UuakA2BJPrh3QMWU+vjFKBVqHcDmzlNLJ3rJt+9SznVy9sQkx9Wn?=
 =?us-ascii?Q?dDjWSXgwzrB6kx6pOiqllWhNiD+W3E6gD36otPEbKH1VXuYGhvRT7qKZl/g+?=
 =?us-ascii?Q?b42ALwyAiYLy2SK9ZTKwRNqtDFlIlYfrED4g3KoF9l9ZQgye4eDUDtDslsVc?=
 =?us-ascii?Q?tH6sziksMs2xyGHazCkhn4dTw+a/E88q+ClnuV0iciy93uP/ZAKSxmiL7Qrd?=
 =?us-ascii?Q?01fP8jEuORku51IDoTnDqBb4TK6VDk7tljgt/kAotpbYaISJUceVA9PoeC7g?=
 =?us-ascii?Q?bcOW4Rrrnfv8oTOjLR183GFXI70/MlFJW40wZ4Z29pxk+FHC1/snj+ZytWBL?=
 =?us-ascii?Q?+kibpMJn8w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a70a91aa-7cd9-49f5-306c-08da140e7482
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2022 18:35:54.2039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 906dkc+Eq4MEnTEceiGkGripgJCEIGHpPWAvWujceVZ0dhzu0UI7F7diebgjjeJweurZn2N6zXMgwaPK2AuTyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7074
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Remove "? true : false" if the preceding expression yields a boolean or i=
f the
> result of the expression is assigned to a boolean since in these two case=
s the "?
> true : false" part is superfluous.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
