Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1005EC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Nov 2023 11:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjKMLxo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Nov 2023 06:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbjKMLxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Nov 2023 06:53:43 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CE9D5A
        for <linux-scsi@vger.kernel.org>; Mon, 13 Nov 2023 03:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1699876420; x=1731412420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DpSTSZgxgnMQg5wIGWTmCVEsf1dTtGs7Rooy1mNZtyA=;
  b=BjY4kg/dwjMZE0dEKtx/F0U+nqqSqvKI6ipK7p9v0VKGdN1tOzduEqcO
   x54yVljQsaPEYGEpLZd+TrY/y7HcbFEny/ga4C+ZsXUOR+iikvhxr6+NG
   FrjN+D0ATHdEcxIbR6yA4spfAW7J16jlqNWwRETOkCEjCmfWcITdk0drw
   1zvxesXRdkYXmyNjS2SCgfPzoWcAGnqv3Nt0TmCPgTtmZJxT59t7XH0M8
   Z6ofyrFhWub89EX/V56+c1W56X1jEqE2v9DkvRt2uvYw0HssGsAEss3fp
   YRN8cdLzJ5WMXK+gcBkvdM00JGu2E0r2YP4OxainyRIbmeW8ENz9acOjn
   Q==;
X-CSE-ConnectionGUID: Kxy3qJGGSxuAh1CVVF7ndg==
X-CSE-MsgGUID: gu/1DVjCTOaj3OkPNO3YXw==
X-IronPort-AV: E=Sophos;i="6.03,299,1694707200"; 
   d="scan'208";a="2010743"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 13 Nov 2023 19:53:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SD3ZTyQCcHnDSvthQwkhjDdH7prFYSruWqF0iHilMs5myuAMpO0+3zEK56l7VRpt0UeatdHSFn6/ymxAWG+szQO40tR7sZyog2AinH/n+YdjWTJBdl5mYokL/Utq9m7Oj3spWwXiQrTj2t4udUrNX3HJBILleOvCbO9TXylqyYt3qMlQDe3Gbg+6B3kjecbk4WX04N3aLYdtcF9BqEVsI+uCI3or242Q/raLCgHhmRVtJCh5HW/BG44Z4CvzaltD7wARo7xXX/IkXQ8jiirqhGVJtmG1k0OXPjyBgFcxkasr9xv36O4/a6EbKrp3EwmnWy3c+sPkuEEIwZVPBQLAZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GLY2V+9n3QNyMBiTZCxjSfaO3+U4XnXwtNmGBjtmpT4=;
 b=IlNB4YQu9m+k4X9jAd+JsSYseHq284mAaj7DQx79XoBheYpGkn219icQinAthxWGIwqhxwM+d8fErT4nG1YkSXvz71gSrDikSQA7qD9okrOvFvLXUcGr+YRNOFPga3PiGGb+K3q9n2NntsnCcXwAVAyt4MEN8FknEOYJDfWx0ZMNTIRpMl5oY1PrkYCyJakMoQGg1RIxnFdKq9XdlelUDNCMgin+BUr0gVzst5jQ394ErDKHpPPsIxv7Q7zD2UKtuePLeQAWWjdMEHGVXTski8GQ1BcfK3gQrt+y3hXEOWuNfhqHv+YqbQ0tNUDMGl1FmWyMY4OGv6iCIzv2OEMQ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLY2V+9n3QNyMBiTZCxjSfaO3+U4XnXwtNmGBjtmpT4=;
 b=ziE+bv3sX9VAhXQCQMYEsIySnbv08I1RdEcFiCw+I+KptfvzdiaG9ahw86ShSnDOdxuDobrD+dxSUQLNHWlzEllq7EbcaSp3fR3vxHDDD+SmumCk608Fc7Wuy6+57J1+gcjQmzQGDLicEM4RgXEJkuZZxOTrtrVlu9vmcNWwVjI=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB7130.namprd04.prod.outlook.com (2603:10b6:5:243::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 11:53:37 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0%4]) with mapi id 15.20.6977.028; Mon, 13 Nov 2023
 11:53:37 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "bugzilla-daemon@kernel.org" <bugzilla-daemon@kernel.org>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Thread-Topic: [Bug 217914] scsi_eh_1 process high cpu after upgrading to 6.5
Thread-Index: AQHaFigJDbyVTUHRX0GhwsgVfncCTA==
Date:   Mon, 13 Nov 2023 11:53:37 +0000
Message-ID: <ZVIONaawuLOojZin@x1-carbon>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
 <bug-217914-11613-kPEwzlBcn3@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217914-11613-kPEwzlBcn3@https.bugzilla.kernel.org/>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB7130:EE_
x-ms-office365-filtering-correlation-id: 6cf7ce4b-4274-429a-94c6-08dbe43f2bfd
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5J3A/GJ0znLfS+wKgAlEbzBiKBO0glDkNvLsBN/J2k4JmH5fvA2wAmvb5D467iyGdcD5O+oKz1eFYv5ghIdxzsWnVnKkjoogaBgEgwaxPrMqwKMRvrhKhscz/x9rO8GHLE0FPcmDnxB5c++GiGzFfRr7rSdkfONW6CxfJMbW5TtGbqM3uAqqpu/SgcqLXDkoi+UxELyh8Eg3iCCBxf6HP92PQ0kyomHGwP2G15zp5Ivw9vCECwkt4jPZtmhgsYLr+N0JdutDC85z/pqtzZkMz9lx1Y4vydF/7ATU/IYdDg9zH7TiS0aDsji2bls6aUko4/o+dAhUuBD6JFH0bwkm6xNrErjIpQKZfotiLLMOhpdmOOUeSHFEuwzKier5Na27QvOkaCyCgy9/nF7J4iuByLCHQXJPlARa5skpo2QE3V8lsEjaYh97a+GaaqJ4NIV7WutUHYJzEGtAhvYltdE3zI4ScPuucjU+gmbU18bRo1i4dNZEeZC+yov1BpFd1X2TE1i3xAS0ivso6F4jn+RFNObe38le7AFJNx3vCn6mG7j/JvrMYn+KzgPkFQTF+CNiDgm91BhBMPnfZCHwJMypMlgT1pe3wICH3ShVIqIB7Sc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(396003)(136003)(346002)(376002)(366004)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(41300700001)(122000001)(83380400001)(26005)(82960400001)(38100700002)(9686003)(6512007)(38070700009)(6506007)(478600001)(2906002)(33716001)(6486002)(966005)(86362001)(5660300002)(76116006)(66556008)(66476007)(66446008)(316002)(66946007)(6916009)(64756008)(91956017)(8936002)(8676002)(4326008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9fDimsfHrJFpKDHVOEtQdfvMzAU+evLq7OGodUJyfGnXNd2d5IpPam4GFM/R?=
 =?us-ascii?Q?xhqyMC46NoQJHc6wEjfr6ShK0ZDovUkliqIhSARepg7xY2TEIiyesidLg4f6?=
 =?us-ascii?Q?hPTc2l2u9F24NRN1i7X10yWKKA8wnbwUs9b14QMY2RVi/qMHT3eBvvtSwXtL?=
 =?us-ascii?Q?sXi8ILoZxpvBPA+6B/HpC8tFX83oWeGg49wvkk7ZfXVMliJd0oS3xJrApAhe?=
 =?us-ascii?Q?aMsR2zyW3LQRa13ijF8U8jbYcgrye36fDwTU7VBHytSBN3DQfmeZz7dtvFaw?=
 =?us-ascii?Q?5E7vhHhQ6HMZhIHkWht/dz909Q02hcbLj8ZAiJEhXdw2Qi1ScwTYvr9DEhCQ?=
 =?us-ascii?Q?idErP2EBkxcMvxKAnmHU/OMpC11wqRDMCCHfElOrJI6tOF6/6A9DCJxW8y/n?=
 =?us-ascii?Q?TIAYclGQLC/9lH/rbcXh3URc72y02+S0tgPy/5cNdaTA62F0C89V54GxaQM2?=
 =?us-ascii?Q?v33nV1fxdsY6IZdch1oKOuMWLQug4mmBnH5zbUH8jCS9l4rj6z40Yt5KKAmY?=
 =?us-ascii?Q?bAUwW4XBsVx3lc85uuEQ8ZYJr6lZqArjM1RXa3RbNTzD7eMBt/oeD9RJ/eJh?=
 =?us-ascii?Q?JLIFu6P1tBrbSG2rbAiIHopfZmrAZXB+OLixb1ups7Nbsr+p9KEE2dCvd/y4?=
 =?us-ascii?Q?S8yAhtyL3+5YtTWVBZ9Cr3OpZ1rF9YQAmE/s01mB/7EnfWWcf4heKyFchq+8?=
 =?us-ascii?Q?h97uN+V3MyqwQ0+UPKBTEusc6oVK83WZ7USgUsRGh0ZYfL7pe07RbKAJpa/l?=
 =?us-ascii?Q?LdcbjApxnsbj+1ByyKMpgNZxQMofQ3409Dx8g21qLY0sQnz+LEXSoJzCZ6Qz?=
 =?us-ascii?Q?EG3RMf9T9gCTHnscbPoYDgt/OOP/fRN8HwHv+jGlNlYFF+YUJcNt52meBuR+?=
 =?us-ascii?Q?IudpBOr6NIie8qe0hEFjocbXh3kQSX6BQAU8o3HzbMrQ0QlnFvacwXC3cO1n?=
 =?us-ascii?Q?jqgQWS8r6H4W8mx18NhU367a/ndXkFM4ryBfBnR4ADFTF1+yOZzGUC94AoB1?=
 =?us-ascii?Q?wcBmJX8LEDl7MQAn4CVI5Ca0DUC8m6+IkyMidrKOhoKmXPp1nmh46VNzo4DL?=
 =?us-ascii?Q?mpVFVJmALlNN1PGo+sOqzx8ArYJsHB5+CwtUS49M9gYWHlQ1SFpbq7+0AIvC?=
 =?us-ascii?Q?rnMLOW5kbTg1NRmieq4hxkib3Fayzqg+9nEpmmd5gRwurs8dtFyu7nRmV6fc?=
 =?us-ascii?Q?XcyeM59/ajUbITX5ySm6jnM+YC7vSabpoJSsVHdCalwi9QghH+n57MEaQb+m?=
 =?us-ascii?Q?d+F+6j/uUraieDaQuzYFQe6Fl92oboshC45iW+AJKEm+XArZX0QsAPP04rm6?=
 =?us-ascii?Q?YwuZCiA3sz0B7+juUA3Q2nq7KnQlDkwAs0dzQD7MNZ2klsuVvyKtEl79ockr?=
 =?us-ascii?Q?8pTthCfz0AWMbzYH8tVPVGsrK2RK3HzrWQlBXvoSB+Vz+I6n/anKlwgtWTkS?=
 =?us-ascii?Q?UYaBAoTIzUuFGKHWWAvliNevFP+t6IP3N4GqSWBdyaw67NjcMSr9Wk6sIxVV?=
 =?us-ascii?Q?OCK3s5GPAGrPWAl4xhBDqMtcRqlLH8BHMgTd+JeKsDHCji0Jl1vyaSEPVSvB?=
 =?us-ascii?Q?ucvgyc/DiSMvtmKy4oZBZEiFqb+paZXIGJOINR0gvKdFzCCYLMG8vxd3WtCj?=
 =?us-ascii?Q?zg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0161092BD8C51B458D4BF0FD6B1F4632@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: usvnYQzyGkR2Ge0xTfVo+lg128UBrd00hsaCMSCQWdKxeInmRe00JMb5RyMIBQlq3UfrHOo3+jHCIoDIyS/KDMkg4GmeaFWwqdy03ho2GXeDkZ3Im3zb7IjGrCc5wkVW1znSQ1KciPce6xSjpHkrMDygpioMqCJTIjKoeIcKoifdc/0FnxutBNIyWsij12sQWQ8hOHJDTv0zd5qEqzGbPnlBaWuKO4ZlPDrYz1NMzQEp12z/zj/XFQ/8dl4prjEcjUy87Mwzb+4aKvK9QRB+7Hz1xD7k/WvHdK7V6I0ypPnUueb3umh88EDek9QLpLo2wk8tC0HMp7b2/ZBpRuFvAQ1ZYVh4rcl8FFZyPeRFiJyo/h3yAHuPB9sbNDEyF8tPQ6qidPjOzVwfnRanMrOc17YGKKX446jSO9WP7aHf0OTpuA3kui+2kPY3HOjy8Iinm5XWdTsb+QyoDYgtyNMabBzelqHTQFfEBiK+ak6r7z92EAubY8045q2fHQ9Q4sQipw/1XFb9VeFLQDKi37qWiv5s5Z6wnGi5V3WEsPEB8gyrIHLSJZG+7YZatV0PiBCsITKM1TssgWVlZYzPAyczvePO/JDrM4Uc/i9pyCLo8UWV+V0b+P4uf7SYbQYCRwh8ha6JOEUK4K9CbfIsUXsdxLSe+ZHUwdYWxkb7gJRTKIXW94SgbnCynlYr48be8le4TBWN9MTMbCUZd922VQ5ps77diG+VHY7vGHBu6UurJX9QbALDOBo/8aBrGeJoeVGvGbivsEqtZUO+oYSw5JE+tW4x4u8lb0DfoHIn+6Mj9Ulm7UiDm7qRa6D53VnVfDmt
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cf7ce4b-4274-429a-94c6-08dbe43f2bfd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2023 11:53:37.5148
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HUZ+nNndBb0/zeuBCAvQxV4ix/IWjdWE7PdSOXqwyPebCz0PdiiFT48rH2tjsJBeyt9FxzSdvtLE6V7puG93Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB7130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 13, 2023 at 03:30:57AM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=3D217914
>=20
> Christian Kujau (kernel@nerdbynature.de) changed:
>=20
>            What    |Removed                     |Added
> -------------------------------------------------------------------------=
---
>                  CC|                            |kernel@nerdbynature.de
>=20
> --- Comment #7 from Christian Kujau (kernel@nerdbynature.de) ---
> Noticed the same here when upgrading from 6.1.0-13-amd64 to
> 6.5.0-0.deb12.1-amd64 (both Debian kernels) earlier this month:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> $ sar -f /var/log/sysstat/sa20231108
>                 CPU     %user     %nice   %system   %iowait    %steal    =
 %idle
> [...]
> 18:30:03        all      1.03      0.00      0.45      0.04      0.00    =
 98.47
> 18:40:01        all      1.07      0.00      0.52      0.05      0.00    =
 98.36
> 18:50:01        all      1.07      0.00      0.53      0.04      0.00    =
 98.37
> 19:00:01        all      1.35      0.00      0.69      0.08      0.00    =
 97.88
> 19:10:04        all      1.09      0.00      0.52      0.07      0.00    =
 98.31
> 19:20:02        all      1.14      0.00      0.51      0.05      0.00    =
 98.30
> 19:30:04        all      1.62      0.00      0.65      0.08      0.00    =
 97.65
> Average:        all      1.06      0.00      0.50      0.06      0.00    =
 98.38
>=20
> 19:32:27     LINUX RESTART     (2 CPU)
>=20
> 19:40:03        CPU     %user     %nice   %system   %iowait    %steal    =
 %idle
> 19:50:00        all      2.27      0.00      3.23     57.40      0.00    =
 37.11
> 20:00:02        all      1.29      0.00      2.70     59.27      0.00    =
 36.75
> 20:10:03        all      1.48      0.00      2.93     58.38      0.00    =
 37.21
> 20:20:03        all      1.40      0.00      2.94     58.93      0.00    =
 36.73
> 20:30:02        all      1.39      0.00      2.87     59.99      0.00    =
 35.74
> 20:40:03        all      1.48      0.00      3.44     59.83      0.00    =
 35.26
> 20:50:00        all      1.29      0.00      2.88     60.84      0.00    =
 34.98
> 21:00:03        all      1.31      0.00      2.63     59.81      0.00    =
 36.25
> 21:10:03        all      1.33      0.00      2.72     59.85      0.00    =
 36.09
> 21:20:01        all      1.31      0.00      2.82     59.28      0.00    =
 36.59
> 21:30:01        all      1.39      0.00      2.92     60.51      0.00    =
 35.18
> 21:40:01        all      1.34      0.00      3.04     60.04      0.00    =
 35.57
> 21:50:03        all      1.29      0.00      2.51     59.79      0.00    =
 36.41
> 22:00:03        all      1.36      0.00      3.23     59.81      0.00    =
 35.59
> 22:10:03        all      1.37      0.00      2.56     59.13      0.00    =
 36.93
> 22:20:03        all      1.36      0.00      2.88     58.46      0.00    =
 37.29
> 22:30:03        all      1.31      0.00      2.65     59.07      0.00    =
 36.97
> 22:40:00        all      1.32      0.00      2.72     59.61      0.00    =
 36.35
> 22:50:01        all      1.32      0.00      2.72     59.35      0.00    =
 36.61
> 23:00:03        all      1.29      0.00      2.68     59.30      0.00    =
 36.72
> 23:10:03        all      1.35      0.00      2.62     60.11      0.00    =
 35.91
> 23:20:02        all      1.29      0.00      2.91     59.55      0.00    =
 36.25
> 23:30:03        all      1.32      0.00      2.72     58.37      0.00    =
 37.59
> 23:40:01        all      1.34      0.00      2.97     57.74      0.00    =
 37.95
> 23:50:00        all      1.33      0.00      2.54     59.90      0.00    =
 36.24
> Average:        all      1.38      0.00      2.83     59.37      0.00    =
 36.41
>=20
> $ last -n 3 reboot
> reboot   system boot  6.5.0-0.deb12.1- Wed Nov  8 19:32   still running
> reboot   system boot  6.1.0-13-amd64   Mon Oct  9 23:14 - 19:32 (29+21:17=
)
> reboot   system boot  6.1.0-13-amd64   Mon Oct  9 22:39 - 23:14  (00:35)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>=20
> And top only shows a single [scsi_eh_2] thread using ~50% of CPU time,
> sometimes there's an events thread too.
>=20
>=20
>     PID USER  PR  NI    VIRT    RES    SHR   S  %CPU  %MEM     TIME+ COMM=
AND
>     336 root  20   0    0.0m   0.0m   0.0m   D  50.0   0.0     53,37
> [scsi_eh_2]
> 3794126 root  20   0    0.0m   0.0m   0.0m   I  25.7   0.0   0:06.27
> [kworker/0:0-events]
>=20
> This is a Debian/amd64 VM running on a VMware ESX host. There's a virtual=
 CDROM
> drive, but nothing is attached here and I'm not using it, all:
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> $ lsblk -d --scsi
> NAME HCTL    TYPE VENDOR   MODEL                           REV SERIAL    =
     =20
>     TRAN
> sda  0:0:0:0 disk VMware   Virtual disk                    2.0           =
      =20
> sr0  2:0:0:0 rom  NECVMWar VMware Virtual IDE CDROM Drive 1.00
> 10000000000000000001 ata
>=20
>=20
> $ dmesg -t | grep -i scsi
> Block layer SCSI generic (bsg) driver version 0.4 loaded (major 247)
> SCSI subsystem initialized
> VMware PVSCSI driver - version 1.0.7.0-k
> vmw_pvscsi: using 64bit dma
> vmw_pvscsi: max_id: 65
> vmw_pvscsi: setting ring_pages to 32
> vmw_pvscsi: enabling reqCallThreshold
> vmw_pvscsi: driver-based request coalescing enabled
> vmw_pvscsi: using MSI-X
> scsi host0: VMware PVSCSI storage adapter rev 2, req/cmp/msg rings: 32/32=
/1
> pages, cmd_per_lun=3D254
> vmw_pvscsi 0000:03:00.0: VMware PVSCSI rev 2 host #0
> scsi 0:0:0:0: Direct-Access     VMware   Virtual disk     2.0  PQ: 0 ANSI=
: 6
> sd 0:0:0:0: [sda] Attached SCSI disk
> sd 0:0:0:0: Attached scsi generic sg0 type 0
> scsi host1: ata_piix
> scsi host2: ata_piix
> scsi 2:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI=
: 5
> scsi 2:0:0:0: Attached scsi generic sg1 type 5
> sr 2:0:0:0: [sr0] scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cd=
da
> tray
> sr 2:0:0:0: Attached scsi CD-ROM sr0
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
>=20
> Will that "scsi: Do no try to probe for CDL on old drives" patch land in
> mainline or is this still under discussion?

It has been in mainline for a while:

2132df16f53b ("scsi: core: ata: Do no try to probe for CDL on old drives")

$ git tag --contains 2132df16f53b
v6.6
v6.6-rc4
v6.6-rc5
v6.6-rc6
v6.6-rc7
v6.6.1
v6.7-rc1


Kind regards,
Niklas=
