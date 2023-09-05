Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1579CA0FFB
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Sep 2023 16:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238695AbjIEQGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354296AbjIEKhE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Sep 2023 06:37:04 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BADD8199;
        Tue,  5 Sep 2023 03:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1693910217; x=1725446217;
  h=from:to:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=ooiJzZh4Y8B5J/n2a0rcdbd38/fODrDlYdpqS6KKScI=;
  b=ouJWXTPULQWRm8FlKxdeUj0lvnWPm/pB42WTTicliHkQpEDh2qwAHIzV
   o/0O96T3OLORLgaCgOKlAiKpomzr+9LlSDoDKK+U5nEzZeA+AkrraRaCj
   EVzSD7Oo3TNOlPN2dnrpzJ6z9sGb2p/aYRcSd5ya/XXwLS1hzzFzL85AY
   n9NTxBCeu/LLLx0jxBm7AyI/kfYjw/9D/pFrirSJVOOV9nx7p71+2klB5
   g5RJgod1pXM9x6uRFIX4luYEVnx4KnK3lhlj8bMaDawyjhgU35Eo02LDc
   zclg4MQStM6LzCVIH1zTetql++f41zIYn3Fa6XXssvRR3c6XVE9yuKZph
   g==;
X-IronPort-AV: E=Sophos;i="6.02,229,1688400000"; 
   d="scan'208";a="247588796"
Received: from mail-bn8nam12lp2176.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.176])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2023 18:36:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IilPS/ohOJVt1bOPKgFqN/dSJLhQdNSPq0awuD41wJn3TRq/sk3UQSVml1Iq9BhWJVl/nRrpBsdANg+tsXUliNeZ8SHoXfE9FN91M9yCIGsf4cOYN0QlfIuDOMzUGz0WT2kd+EHmEuKlW/oCJ4pwMPfxF6JUyAxABGduA05xyXwqJ9+6b33G1g6mQjIvhsdQH0rni87nw6Ni1/rUWwIoHLP1MvwYtHO77+U2g+LNdsTZ6lGThQdmFpq22IJF5L4Oqpvehp6phsn6WPf1WNXuQuSQHUaGeHcUCrASVnfJXQlWOpmtoDP1aamBOhamIaIPFonMpIc/UuZvjxZ/LXE0Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C8JrgidpYfndAaE5uVIpxGSxGD1VFzJaHSGq3x5ksg0=;
 b=laqhR5xrzMRU3CMlQmYQN3QoHn1ll7oywjhNH1yMe07dtOzkhauKhw4UKY5PR1BvaQ7hUMOST4DfvFud4ef1XIk9v/jqA13NDxOeIvTgjz2vbLtouOrfhY5X+Ul9GMaG+MUyYAApNiaSWXcAbw/TAe5+rqp0jPWaIHOMaaNV8q38drlPwt11RvPt8y6ZVQcugNfTE5vTfweQbEla+M18c9oM0Bmh5YhP/VT4nqmgN3r/5HZ02HBMHWh4S9Gbn858P+MqRWpGGA5UeAAv/R5ZK/HS33vMTnSE6WTErhm6zgYrsZ7JltRVsE4wy/pJNTnjt47MvVu6wXdCJODkr78ZEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8JrgidpYfndAaE5uVIpxGSxGD1VFzJaHSGq3x5ksg0=;
 b=h7MO9W8J/3OgBWTpf/+UoTSPXKVdRh8gijbUpJ5LfOw+H2uczOLuq/KR9UIVQOmd0PoGWZMEF4UhBEVgzA3T+85OEj2uRfT1t85m4vEDaZY5gtlPQvwkIfbljXiuLZ2ipZTxVbLtRiO41RfxV+pI0s4boJxwXIDoHaCy7BBxsqI=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6613.namprd04.prod.outlook.com (2603:10b6:a03:1dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.26; Tue, 5 Sep
 2023 10:36:52 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::f92a:6d40:fe94:34e9%7]) with mapi id 15.20.6768.024; Tue, 5 Sep 2023
 10:36:52 +0000
From:   Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: blktests failures with v6.5
Thread-Topic: blktests failures with v6.5
Thread-Index: AQHZ3+ThrzOZUkCYOk+/KuBH9/1L8Q==
Date:   Tue, 5 Sep 2023 10:36:52 +0000
Message-ID: <dycg2iltyeezp6y7bqfhfke6bb3dantkk5nsyk6qjfg2o55esu@liixlkhgtqy3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6613:EE_
x-ms-office365-filtering-correlation-id: 391ddea9-5978-4120-b433-08dbadfc0486
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZVjhkGIxOm2kBK8xapj7njMjzMWtjXQZvV1qIpG4T+iOXt/lvahiee2aWUvfYYwPJO+svxAVDbt837zSHsRL4AiBYU7xzPQJDZA20nK95vPd66BMRWbnm+KGq84q/cjzvMaaKwzNDAhJzZyJFd4oIAOmX+KHTqIeM/JR6tOpNF6IPmfzoA5Nl0hL22Q/ZVxKjfLRemoJa9vwMISW3gQIrMpl5vT925e3QZJnnG61oBD7uyCr2SCxBnI0OdVKvNz24Z0yw0ks5w2KhcOCHIIHCSltYxsHMNMBTixRU7T2ILje54jnBNGKPBj6SCpkDesqh47yFpyHNd31MkHHQyyh8ORXRl/JzBGhppXzPA20u8g7iS9KV1YWLuJ0kv3OWEDpmWI82v+MEGSKiIjyYOCPTNP03OVcFmxRLoxLkajzArWz+l7/dorAtVkeAevspXxnGXmfNTZmTS2nE2+2fIOZh93nOa1tMRjlkScycqsQeQwgL9lO3S64xoWkrIzzvqo0ogjgOZl7j4kX25oxykCCedhmDbFyZy9NCxxd73iQ5OkIEqHfmJC2ks+IBV6j4XCaZPpbFJwvPwWEEz8WK5rFIT+TMdEEIAg/fzSrjHkUivWR7dpiaaVOnP4hxsxJtSSrKqqT0Aml0+WDJLBtE5MAzA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(39860400002)(376002)(136003)(396003)(366004)(346002)(451199024)(1800799009)(186009)(6506007)(6486002)(71200400001)(6512007)(9686003)(966005)(478600001)(83380400001)(26005)(2906002)(33716001)(66446008)(44832011)(64756008)(66476007)(66556008)(41300700001)(66946007)(316002)(76116006)(91956017)(110136005)(5660300002)(8676002)(8936002)(86362001)(38100700002)(38070700005)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TEQImYSQSiAZQtMgKQiUj2dahr3mfUMN+8LZukapcRSnJoeCPr7kEioOXaPu?=
 =?us-ascii?Q?PCYh+5Ml70KJAfT08fO2yrDdeESY0lWJNk+l1L51pMMXWEyjX63BY5MFXBMz?=
 =?us-ascii?Q?pHRIev+Js0Thw/ue6uRb5qPad8rcsTE7IrQTOSohsdAw/LqpUT61wKY4rZNF?=
 =?us-ascii?Q?d3/tca5tapy85T+c+gGnUC36wgyPSjMLOXiaqhqOK8Ci+VCPsjbktMAiB4zS?=
 =?us-ascii?Q?YmMlEfLYBke4Nt/+cVLmydOiUnWIcheaKARAzOvwxN0ve+IGF8+OTajhmC5h?=
 =?us-ascii?Q?LRGiwj26AGlc537bu+nxSGZzwXwA0sY0/bFZhCTwjYaPUrKOEp5lggx6ADIj?=
 =?us-ascii?Q?2UaD6XyujsROLSN3DlR+EQZWEY9P5JdM+CFC2WKfxIHkQdlDAMEugg6bgt84?=
 =?us-ascii?Q?ogwXt22PTL/13HuTwe+YwG3EvUjIwYmiNBcYExlLKoczL0ytC9u6QIdVNUCI?=
 =?us-ascii?Q?mHDvVTBluQhzq7PQKydrUHrRuxAqjXhjePNDJNrR2awTKSyBW+Pnq/TwGShK?=
 =?us-ascii?Q?wFCFDPLQ8bermTMlhXLhzE5dYCbC34GEwx4r/ek3qIJjh0Zq0K0wFIseVn7l?=
 =?us-ascii?Q?neZbWuVvDt0ZYV3IY2N1kaFcSGWFKDfhIImbfBKp5RCub7W4GsEP7Q+DRjXs?=
 =?us-ascii?Q?TzgBxTWj9gqGp1k0EAKosl/d+W/ouiDeK6r95quKWK46B2xECVczfKHhdKZR?=
 =?us-ascii?Q?byANWlEiCBYJLsWyIVvkivOZJOLn1sdt9uWrxM+zhb8y1OHZu/FUIfcopgna?=
 =?us-ascii?Q?13g4aOyPwoC2RkiahewAM1xir99lbYp3vwcF24CibfGSKrS/C6+WFsylVxqj?=
 =?us-ascii?Q?bYuG9E2ySjlcpsJ0QPuRPujftHnRyvdX5+7PwIG0m1OjxJfNTxzKXhRjc4SJ?=
 =?us-ascii?Q?vyD6litLxvwqHEBcPtcv7jfjWnQ1/+zMrzIggW2UBJNp5qHWK0lI440LDnU+?=
 =?us-ascii?Q?Cnbyk8kNSWeqC2LcLZZjPAQzZHiqs0ybZKPv2KnGOvxlTtYbSRDObrSSHZUm?=
 =?us-ascii?Q?AhOeoImBMKOSPaIiNAPs6xE3d409TKysCWkiji50RDOxLVKKRMK9vROLIHE1?=
 =?us-ascii?Q?W/9f4Pt+FtpmZrVvfH/LNbTdTqjKPrp7qiU0QJCt4WmLSzzF5C2o7B5HCsR3?=
 =?us-ascii?Q?JHcFKRzZMiYweK49jVOP3wPas6WX0Z0Df4mhDt0TWgUiJ1cv7q/L2dH2J+OE?=
 =?us-ascii?Q?yYb8Fe8lNEwx6HNuzFq4MOJpD40d/8tH2ORNkFQZ9JQCCH+5CMHAy2VXRvPK?=
 =?us-ascii?Q?kOa/lrN3ow37zDZE774EguqzbQ7ngGBxwWXv3UBt+2ZBiYlaKH0m5asUBIZi?=
 =?us-ascii?Q?EcuHC9YbKhqf/1Gn6iItGcQNGfAFeP8/970PZxzbydSTEJj6H0ekATHsLtuT?=
 =?us-ascii?Q?gHdgpMAQdXNU9zC/6BlTJkTEhRZX4O0Q2HNCUanDvqmMbuii6c4X+FpdjqfQ?=
 =?us-ascii?Q?YP4NVp7YdFhOqjkLlW5q3/o/5+L4gwQHtNdyA04eLWzk2oQLO5ncq1Tr2+3F?=
 =?us-ascii?Q?pswmIGnxy4mnjeMK5ii9CtagPkC24oqB4q0wV2SDbyIT0UhBA2i5O/KXnZfY?=
 =?us-ascii?Q?po/AjD8Y+udQ2to3IJbFoSBsxa/D9UGY5MqHPeyI0KmuAN3416Bv09aU8F54?=
 =?us-ascii?Q?k3CkkWTpdcPIVNx656i+UTk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <59BE98D3B38E5F46B9BCCCF67C8A9BFF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: P608Yt2GNLdyrVFJNwwOyUwlUITGi4TRFQD87RKpbDK0QH0MFvtOZaCcwFYQiC2MmbIk6KdImAJ0Blm+tqJBVZXfaY50FDTXCSpA0QtVR7i/14NhH+hEr+Wt1+4mhDKKSZxQqJ+7Q+pu0IP8pnpknpxmj6VYs4m3KcwBUpcetWh3neAo5UaLYfOskoJfG5O0blrOvI7Xc4WoCv1uC/XLgwE6Wsip6wtaBiWOdwgXnxt+xk3To0Y86oNB9baPcrzfomzh3P2Uwcr8QPAsVwUP+29LN/WgF0/cT51o4pmf2JHVbCGxFDhsC7c9IiaBrmLWRu0ZAag1SnWkZpXzKGFqEcUqrMwDcUYuJxwmbz8+qzhLi30tNDGcsn8VI8+rpRDAOlG2e15pTh00VbL2QHG49XOe/MhKUIPsWZD0GcdExqO+Mo8loLBM7//LuYPdN5YDYsiIDsLUFUq10l0Sco4MftqgBaUD4gNXMMS9wOh9YocjPBP2/uOFaiGuAlu1pF+XD63B1ArO/n9tPE4VSwzFyrqmQmACXx8JLtviPRnpNH9feLiutGJCRFD2gMn3ckaSeAyN7H9S5DXd1q8IR+4gDC/kOTXJ+D7IjAPQzi9cg9MzvgbJH0tXHBvTbgmyZINhPhtVMCBOUDEIfRXhTjMQD59CsVD8AK7tGEQqHx1HhynkKP+7N0tGGLJ7saizF/+4u+c/FDxIyNL9vR+vlupPnsezDasRAO36LeTEspioEgxDGU3ipC8FlQha8fhV4T+qorp3ftjRpvmX0OJnpcDF5UCBM91f1NwJF2WUg5I47cYiYrc7HOsjSpsj9cu2E4N+sIPj0872fziQEOxoyLt2dg==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 391ddea9-5978-4120-b433-08dbadfc0486
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2023 10:36:52.2011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +0ystXTN+3+gZCirRxxpIxwAkrYI5igebkg3P2x7CEABfdq2SSc4TTaRWd0MR8RufsR7qo7DFgunNp6YJK3bvYGfuXzKGvevj8ilHd+Qr9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6613
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

FYI, here's the run results with latest blktests (git hash: 2045e8d3df86) a=
nd
kernel v6.5.

Comparing with the failures observed with v6.5-rc1 [1], I observed one new
failure, #5 in the list below. Also I observed two failures got resolved (#=
1 and
#2 in [1]). Comparing with report with v6.4 [2], I found that the failures =
at
block/024 and nvme/030,031 are no longer observed (#2 and #4 in [2]).

List of failures
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#1: block/011
#2: nvme/003 (fabrics transport)
#3: nvme/* (fc transport)
#4: zbd/010
#5: srp/002, 011 (rdma_rxe driver)

[1] https://lore.kernel.org/linux-block/mklc3tlep35diuya2nnthlx2n5g75kikcqv=
mims4uox5qsszay@crbdp52wenhc/
[2] https://lore.kernel.org/linux-block/lkmloyrqpebispffur5udxdiubmevvodtsv=
nap3jz7tv5ihstr@jg7ejye3bein/

Failure description
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

#1: block/011

   The test case fails with NVME devices due to lockdep WARNING "possible
   circular locking dependency detected". Reported in Sep/2022 [3]. In LSF
   2023, it was noted that this failure should be fixed.

   [3] https://lore.kernel.org/linux-block/20220930001943.zdbvolc3gkekfmcv@=
shindev/

#2: nvme/003 (fabrics transport)

   When nvme test group is run with trtype=3Drdma or tcp, the test case fai=
ls
   due to lockdep WARNING "possible circular locking dependency detected".
   Reported in May/2023. Fix discussions were held [4][5].

   [4] https://lore.kernel.org/linux-nvme/20230511150321.103172-1-bvanassch=
e@acm.org/
   [5] https://lore.kernel.org/linux-nvme/5cb63b10-72ab-4b7c-7574-48583ea8f=
fd1@grimberg.me/

#3: nvme/* (fc transport)

   With trtype=3Dfc configuration, test run on nvme test group hangs. Danie=
l is
   driving fix work.

#4: zbd/010

   f2fs mount fails with zoned block devices. A fix patch is already
   up-streamed for v6.6-rc1 [6].

   [6] https://lkml.kernel.org/linux-f2fs-devel/20230711050101.GA19128@lst.=
de/

#5: srp/002, 011 (rdma_rxe driver)

   Test process hang is observed occasionally. Reported to the relevant mai=
ling
   lists in Aug/2023 [8]. It is suggested to change default driver of the s=
rp
   test from rdma_rxe to siw so that we can take time to fix the failure.

   [7] https://lore.kernel.org/linux-rdma/18a3ae8c-145b-4c7f-a8f5-67840feeb=
98c@acm.org/T/#mee9882c2cfd0cfff33caa04e75418576f4c7a789=
