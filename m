Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB33C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Apr 2022 11:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234907AbiDNL7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Apr 2022 07:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbiDNL7L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Apr 2022 07:59:11 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E63C7DA86
        for <linux-scsi@vger.kernel.org>; Thu, 14 Apr 2022 04:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649937406; x=1681473406;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LtbmoVUxdlppwpYNebIhMLbCi4sB0/r4EiSbWnpWMSY=;
  b=Xo/bkxFyWe6cfQcKyJbuqJpzEqIJjAs5i3ycW6UlqfV6dIID2CdL2HW+
   0oMyGlOisnNIC7JDYMfZkcvX3zmYpqRjB4LmuEymIZtiNOetdfjeXlG7w
   N6m2tpiDyxiZgOxgXt2W1CsihP9QGD9MWrlzP5RBAj46q7PoRX9VaHil1
   ztoYHeuvB3eVgU82KiWo+nGgCCAhI/GMIkObf+rUOidLlUGsu+5O6wY7t
   MKdQKax4gyJezRH0gXq3vsWY5y93aVYrP80uDgPDvsBiSb4chFbY7u8Q1
   q0HqYE01lpB4oqTV4V6zY3j64uZh7w54fMpW20GSgdmfq3giA+41uUaEO
   g==;
X-IronPort-AV: E=Sophos;i="5.90,259,1643644800"; 
   d="scan'208";a="197909653"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2022 19:56:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RPRjK3bUX4eYvbRpOYhZOix0dDG/gkZEcmnUarbMplf4eO7Gdf93Y9AuPQdavpTPfixz/lOjXeNJJlECQPLDxL7LkwaSyLER3XDSN8sqZxUNYVILJ7CTlmvd64wCi5hvoPS76RBP/kEBOoyT8YbW9khpnDBi9f9Ij5WwSRsniGFL3xSJHqyhMtNvUuRkQ05g7P1gfk/rgU7gbQNv5XtdkFZ5mrvG12b1mcUbIpYlXbA6OMhbWUDBBVAonj6fndTcscTbjFJMNHnBmld0Vumy0Cvg+WXvYECRoNkeODc+IbG+CcHkYA/hmZ3hqgyyMbP9pjNOgZkvXH/f2iPD52RrxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LtbmoVUxdlppwpYNebIhMLbCi4sB0/r4EiSbWnpWMSY=;
 b=HJVgCMw3RB5LVIZDcljGNSx4LIleCl9N1Z/OeNcQxkIKb6WSuV6Q1Y4Gnh4Z3WS/VuS0yOzfjkOhQJixxV652E+R9iKDm2SvKmk/+VCdWlZTEMHwdnGJqA1iuP78tvrw2DMwIUI77CppvRzaTbXvXGBaPuJxlv49K9eQ1OQXWMbE+verVIuKyTO9YTpo5Jh25iIjYeoXjAX7vRJfvnHZWStgnR48UJuKEmeI/gyG6vl08BlPIzMSTQT9zmZIaAz9D3I1nb8lIicu/fohINaJuxCP2ZukHpFIwTxk7naGbY/CZ8QvcGVKBqpU2ueVaw68VXfwPvwKex+KAelRtZuhxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LtbmoVUxdlppwpYNebIhMLbCi4sB0/r4EiSbWnpWMSY=;
 b=Tz7qffNfR+PZSFCy1ClcmGVaS3s+3QyLIpoHdGI05+e8YOLfDgaIkPXjj3DGE7oKTxBD+9NDYfINKinIgx7c4Unjsg0mwYZpJtdRH/HiqoZLVSWNbH553zYGqxjjUlU8brv0ACH52XIBcOpwaHsqu93sOyXMVXJ0aV7Gdgaj3AI=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM8PR04MB7880.namprd04.prod.outlook.com (2603:10b6:8:34::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.29; Thu, 14 Apr 2022 11:56:43 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::b049:a979:f614:a5a3%3]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 11:56:43 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>, Inki Dae <inki.dae@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: RE: [PATCH v2 19/29] scsi: ufs: Remove the TRUE and FALSE definitions
Thread-Topic: [PATCH v2 19/29] scsi: ufs: Remove the TRUE and FALSE
 definitions
Thread-Index: AQHYTppFS0TSMrV7SEe3B40dOCvSL6zvT+fw
Date:   Thu, 14 Apr 2022 11:56:43 +0000
Message-ID: <DM6PR04MB6575E54C25A1720E2D10460AFCEF9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412181853.3715080-20-bvanassche@acm.org>
In-Reply-To: <20220412181853.3715080-20-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 459a45e5-8aa9-4f29-a4e3-08da1e0dd812
x-ms-traffictypediagnostic: DM8PR04MB7880:EE_
x-microsoft-antispam-prvs: <DM8PR04MB788081807DFD29808147A32EFCEF9@DM8PR04MB7880.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R/i1KarRwJPqE5o61kQAkf7G6boQ52nMm/xE0aJxywNpz6iIrGiEYuMYX6ldagVcP3ig90s3AVH8BtYm0Es2zi8DpE8oYjbxvpHE4qMbtoYatox3TPCTRAffIA9M/MSBOkaUKXrws1hbI/FVaB0WWeq9HaMU5DF4MbrheN02aK97zlWNd7x5ugck3Q4WNEOmSfxjjUGksZNpEu8R1xPvCY/OfsV03T5oHIhBzi2WGLA3XmHxSLMRW7rBlPE0xXqv6gLMZh/ifDfnQ6QyqxVGcLkvOnPD8G+mA/GolSIfGJmj/2JE7ElL3b5bpe+r9ks6tH8/EAiSNIZ2EVbDqdyyR1IvSPoWDPfzDrW16YGjQrFUPQMW4Zd2Xaa6B8u0Xrz4sPxz2vBxzLmuyQwcoBa7CvZBYd4lrTWtcKUN5yYbqsuB78QQPhZByb622r77kupcnWmpfOCI684nW3dCJRFcdFHLAPezV76JeEbzD9vjghutKpsO5rRMPnhn2lKlzPRPY7/qkPhi1ISnRjBXy+pkzETNmH2y1jv8DoWZMOGt031EVpl8m/RiltJ9+0YfV64TsIq9HXEi8t50AX6AJn83fQIRf1ma4all/5v+3fDwm/goXypYWcr9DD/hyXfpPJ90vmAMutvWNF3Qv73L8tS4ZlG2kIrbneCVcJH1f1aw+62j+hmbb5uYrVlgyRtB6x/hhaeYzHpvFglco6y43pLKOw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(66446008)(122000001)(38070700005)(26005)(86362001)(7696005)(66946007)(8676002)(52536014)(4326008)(9686003)(33656002)(7416002)(186003)(8936002)(5660300002)(6506007)(4744005)(64756008)(76116006)(508600001)(66476007)(66556008)(55016003)(110136005)(54906003)(38100700002)(82960400001)(316002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XjFqAkNQ10hkhkRilpoCLK4lEfComvdRs0rkXa0iGU8EiR8J1UvyO0ig+Qlq?=
 =?us-ascii?Q?daDnB6E5FtnAePWerPXY1gIgTV1/lBUIjM8xwcsu4xV9uvYwXM7DHDtgcJOI?=
 =?us-ascii?Q?6LTwCRCW1jvZ8BVWbtcutPhgVdfYNjikjpiSW0/vcV7MvRyxPPi+GSio8OSY?=
 =?us-ascii?Q?IjmaIB7aLtpCgWfTJz5wWdbcqlCf3/t1wQN/JmE7Ih3nIOBu8nDoaOglFtBc?=
 =?us-ascii?Q?+geRGYy5JCAp6De8RF+TlHhDJKyYCszx5P6nvxoFRLKLiq6D0eRYm4+POPdB?=
 =?us-ascii?Q?uzahPRnHJHzPiB0IENhq4spu8iQd8nZ6shbyMlJs3DCE+HUVcxI5TY/KqWwy?=
 =?us-ascii?Q?Pn0MVlmuIepkiGIWKQpV3a2J4ltn8f12hT2x76ysCArfJiqPJ+OB+m6sYmX3?=
 =?us-ascii?Q?X+q+wAYUOj0Dtt8EzUedGfQqm0dmtlqHkdwAHV7GKUwoFjKe3Cx6KkmpC7OY?=
 =?us-ascii?Q?PvneoGRm7pvAggP65wqxP+9/UIhA8nOgkUVIZmnCR/KpvlGR0RXX+Z0DxVzG?=
 =?us-ascii?Q?F1JEwzVJqMw17owt/6Zcdg8Knf8elyIcKT/ZJsU8qI/tym6zIo0U83yL1dov?=
 =?us-ascii?Q?iSxBKBESEJCumrfYognay1/cKcP1kIaTHMDIcVn9y6f/Vkhr+Zsqk3HS9cSf?=
 =?us-ascii?Q?CjS2ipyhZedidVDv1t8CZYBBeXdaNowq+jdgb9VgT3p+Iem2agvvovcMr8vC?=
 =?us-ascii?Q?h3GoypMi2ckp8YFfuqOW5xkcfdipS3+xaSYQOq+fSrh+2u6u8e8AHgJiRCno?=
 =?us-ascii?Q?WTMKynxtlyAPsWyiI2GSwG3rs5ljEH/yMOoS/ZkXR0f7TtvGvkg968XfWUJ5?=
 =?us-ascii?Q?Fn/rOelx1U/OqB+MeyTlqP91cLO/c6ceb/1ya3yeJTC+Xn5CKYzuAYJl4rjS?=
 =?us-ascii?Q?uLOa69lRCR8+inCjdD5Rw3MMitNDymc3HYxmACd8rS3zDEANfN2061FqZ0nn?=
 =?us-ascii?Q?kGt+T7HaDYBFuzX6RC6Pp0JDsCGbvGQKdaqg34YmZVIFG8tsLFOYL6gvarsp?=
 =?us-ascii?Q?05ak3L6DoSLCPh9HShLPa6ioREdiDsXzUmMecLV+93tDrzFrUm4rZha8e8PG?=
 =?us-ascii?Q?bCjU8w3ZewOz5YORGmSuCV0XLeqIt70P9AtorB8XGxRK+/wyU7lt6Vbp79TY?=
 =?us-ascii?Q?1dHKIl8/aysi3TKCOoV2doIM0oVBIt+hHf2Dlm06Kr4OCwSRg0ctLX43SqgU?=
 =?us-ascii?Q?amh14LtVyhkbdGJnQg7Os3vMUgcUE3S7HhMV42QvDhzIELPa431D69jHF58P?=
 =?us-ascii?Q?gdG/BOZuY7UGQH3LSfyzVTQsThSyyWY36bQk4bY6oI8/+xnJdGfRTdzVB5k6?=
 =?us-ascii?Q?+qy9M+E1JyWO4vwVGZrce84eFTImiop98jKN5Pcmi8lffovbVSCYCQTtdwwa?=
 =?us-ascii?Q?8zHd501ehEAKowKY8tN94omL4N33fM8oyyELGfLRAhwbHxKZQYEOnF+xyv+3?=
 =?us-ascii?Q?oGuixoN2q5sETkG4IftrezWZ6QHPQC9STPEOqvzbC2vRA6cbDV1IDCiWD3qP?=
 =?us-ascii?Q?SCgaWh1TMvljfap9J90vft4Yv0zI/Q+m5yIOVEvWnXSAeuDx2AZerf2FktnO?=
 =?us-ascii?Q?mw0ABZxLiU8nidq4reLy1T0CjDH99+4wCPigknIDKiWzJgNVx8kQlF1hl3UL?=
 =?us-ascii?Q?ps5UJsfc0vN5RcnBHYbZE7mCiTCe38H8w508y356FnEoC2PVStMAPtmX9Za0?=
 =?us-ascii?Q?odpDfklw41u1pwAfygHlajF+eEeWMAzn9Oo6Sc9JIFxzr6s7Ibs1AJDtg+WK?=
 =?us-ascii?Q?22vAsh9DFQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 459a45e5-8aa9-4f29-a4e3-08da1e0dd812
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 11:56:43.3449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NmFx5Bpo5NU3Vg4RWKEkea/EJ1aR8Z0POFI9chIEM+PeCZ4U7AoxRHZvdYfNpT+xiXIR5NufqCfpJr0ak4Wl0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7880
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> In the Linux kernel coding style document
> (Documentation/process/coding-style.rst) it is recommended to use the typ=
e
> 'bool' and also the values 'true' and 'false'. Hence this patch that remo=
ves
> the definitions and uses of TRUE and FALSE from the UFS driver.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
