Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F1B9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 09:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343942AbiDEJP5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 05:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244899AbiDEIwq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 04:52:46 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1710023BF3
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 01:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649148328; x=1680684328;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LOS4Xy4jS1T3+k3QP7A0p/zpFnUvHqQDJVyEmPAcMIE=;
  b=N4h7LIyo86Dx16moJffgu3yiqDcs9baKVRYxpdCibwFxkch7YxDglWmu
   cn9baxW8XCjvZ/3Ispm+M7/b0WtnTW428Y7KwW/BX6ljBL3VSJyxP55FL
   l/6ayRp53JqBaLZlRwCaGO/YUWLbmfM84LF5eb2p3jJ01atsDCB4zvc5T
   zJvv/On0XFu5642o8LOm1UZAekCq0pSzPyTthlfyQT5e3FKmT89iC3gA4
   +xYKEyqdyVQdGRJ+ic3RxH79mzdEPgB/yZWwM9tWbsIf8y9dl5+qiTlse
   aPb4wQDYVw5C/PAzbkrJWhRNwek891VsN0ncmu51fh74b0mAUB+fhaWTY
   w==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643644800"; 
   d="scan'208";a="198017724"
Received: from mail-dm6nam12lp2177.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.177])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 16:45:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ju1S+1eiU5ivWARKQtDu2emYMfaOlDntsGBY7MWkg2P0Uvg7PfMXK7ZvBxXG5FP5SPxn6FnY8XpomoAtejm1Ub0swBbeKJ57SHUAPV8WqO19m6DMG1dntUeLp5fMhaZCiATYSIb7oTphfm3FlslusHGEFTtk9yPDmntbCtWNxTzdQKc0QtRbecT+kwWZ3bQbbPuvGELxqL4wkrvWA/wPGzQlBeiCvSs6Yb5om0VkimE3viiAkDdWNtFOBfP0OKqziYwZxDON/WGIgw1rYMMnR+5uCviFaVEUjNSP0g0OWyyo3x0QRfR23QZPLZcRaNDqHDCQnTasp1YDEA7VMQjk5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOS4Xy4jS1T3+k3QP7A0p/zpFnUvHqQDJVyEmPAcMIE=;
 b=EuPC0aUEhRCYB2kmD7jFjftKy7M7yxIBH8ox+/X64DYizR7Vbqe3+Eq878iINdwIHjYKa14aX6DcqhsyoEhhI7YhWCQt+aB0qo0LvYnz2G0zpDu+dEMvRgbW0hV/hXLk3RyOnU1A2UC+C8g4dOwduN2X/GPTW4nIo/bh3L7X4QAMwe+YDCspmZSMAtisYKUSxMNNLIYGBdDEH8lR2nQxtRANk16x0RZfT1rgi+rWsFF4l1ZvMvFa8iY3HD0hebs+dBb/4l0VRj57JG/PZMq61DzbttXkKLUEl1ZIAWUisSAFS6XDfnhg+00Qc42u3+n69MaezIE00edt8NHuvqRLGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOS4Xy4jS1T3+k3QP7A0p/zpFnUvHqQDJVyEmPAcMIE=;
 b=uilcbmYeVXcGn2woTx2uX8hYx41zvq60EHYFfwJlAJEQ/T1SIBY2OfmRF/8KB2QvaSmjrKhIYPyqQw2bvO5bAtgJVHeN+eVZjvMlT9OLxuRsalws3oEthINm7F1bpNCidHJIayt1ypGAxuMIQI/9lXg/aGdAb9/vqn+O5E1ci/w=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 MWHPR0401MB3612.namprd04.prod.outlook.com (2603:10b6:301:77::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 5 Apr
 2022 08:45:18 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 08:45:18 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH] scsi: ufs: ufs-pci: Add support for Intel MTL
Thread-Topic: [PATCH] scsi: ufs: ufs-pci: Add support for Intel MTL
Thread-Index: AQHYR+gUd7jogGxWM0ejV8vt/YjnSqzhAD8A
Date:   Tue, 5 Apr 2022 08:45:18 +0000
Message-ID: <DM6PR04MB65758B548863663DBCA3B4E7FCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220404055038.2208051-1-adrian.hunter@intel.com>
In-Reply-To: <20220404055038.2208051-1-adrian.hunter@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0526e4b6-f58f-49e1-547d-08da16e09ce1
x-ms-traffictypediagnostic: MWHPR0401MB3612:EE_
x-microsoft-antispam-prvs: <MWHPR0401MB361238A84170676682964BDFFCE49@MWHPR0401MB3612.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5r79nnOalXn0ZLM+Ht9fEP30e0WRU1tVRkfzn/cl9l+NMjBcV4uwJSc6Hr6ZxjwuSX3dDfPYoj9iHCr1nsuqd2LmwhKlI44pWaGhRLkETV+3O0JRj2ughuy8S1PHJK52VDQKBVPPKlLjeru1Hbtdx6yVWtPassFF2PoluXVi39zb0g4Cp45xvG8KPM6YS9rFXjMyfKou9b6IedXjbUF1oji4L+u5iX+mrP/yaGiCZ4ZqTjK9uLGYP1kgwHcD5yzn1MMcg90kgBIMmRLilbrJ7EG9kjpK8oAQzPd3evgwhUOIUNSR9+2Kj9/1FEl1IazSSw7KWPQKRjO86j6fxfwZwTWxLxbprmX4Q/ZvsDpqWMXFnr6xj//sjP9hSrNJY/l5264yYxCh+tLW6dn2hwcUu5OpkmX2U5Qgyi/q8WJ8LRM99x90ZJ2QL+BN8fULFKoMOEU3iuMG3uyT6aZSI1xCbcyb68xyIJ7SMVDTD/pQ5tORMrmtF9ZH0U0K0LjB/Zm2p6pzcwyiD78Z9j3p5AzrmjlnCIQlT5BB5b2j4ji7x6PEe4WFMUAjn1+j3KARfnyQ83Uro4RZXKe9ABp47TZcZ8Sh8XDrz94/lG7E9Pf9r97Wl5e8hKybneIQMscaQllVkt9gNCsRzza1bywWVfJbaWtdm0ICDF3h+uj1IrHEhWb4tW9R1JfQy6Bzs5VKmASaqWmMwg8oY9cMJdGZKOrdHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(33656002)(71200400001)(110136005)(2906002)(76116006)(82960400001)(64756008)(316002)(54906003)(122000001)(8676002)(4326008)(66556008)(66946007)(66476007)(66446008)(38100700002)(6506007)(86362001)(9686003)(508600001)(8936002)(55016003)(558084003)(52536014)(7696005)(26005)(186003)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sghRJaYBQA5kfSiLwUibeb2BkYZ+YidXwj5U6ESAPoiAXlv9t8pEtxcvKVeG?=
 =?us-ascii?Q?8VcJpneWRpesq51uamHZZ+sOllKLMfxldb167S6t1qsv7VzcB/qxJv0uX/8l?=
 =?us-ascii?Q?2yM36fgIcSBUl6hkMkivAYIf0e3dXj1gIVOdyUGabATIiDMWDTkF2MghY9/I?=
 =?us-ascii?Q?SsoLGvhDHJYzlHa1LfhgssLFnnkl0nGDhaUFSFWiQD6XLL97yBJ85rfSyMWh?=
 =?us-ascii?Q?YuId83q0C4KqZ/jC3tb1IKSqNtTjBU68xNsaq9toM/EJutf0tTkKdYzoYlwg?=
 =?us-ascii?Q?3pZs0GcqbAvQqcRq+yMSP4lkmMsoIrNK5d7Yd5RXZiO+nAxnlraDRzlyAEQ5?=
 =?us-ascii?Q?kY16nrXT/WL6m8mdh6kL1SuUN2BUs7kJwBzHJkClLj5K6JYvOst2YKJpxC1R?=
 =?us-ascii?Q?J7SMgulHmmRqCW1S64Sm4aqNa92wt9f6YF4itGIvAujG+wzY4qjtOvUcqlns?=
 =?us-ascii?Q?ugTuG3ezvK4oreRujOa0m81SvIfvqPpjeVaCHNn3qIdYVUGqp9+VL9+J2yFm?=
 =?us-ascii?Q?K4cD4hLXpjAAEWR2f2WXr50UimXCbqruVwMrU0AeCuNdKDXDg462CsrkPcMD?=
 =?us-ascii?Q?yhm7BDV4igBBvPi/2oWaPf/SKVqtoIViOMFcv6FciAp+fnoLFDzEdS9Px5dS?=
 =?us-ascii?Q?s6qWnXKMTQJjGeQBHMXZ7GyaBFhjknz6kbWNUYNsxu2pfOonE0w6wbVoSiFu?=
 =?us-ascii?Q?ruzW73eZmjAnO9B+YFfMXwyJtzJABNkQkVQRswdHg2MSNVhyNTrhU/cZ78AD?=
 =?us-ascii?Q?krUAC4ORWwcLxAzd97Y/Pa8xiEe4QWlQNy00s0DxBnIvHXhEvfD6Bmh7L8Xh?=
 =?us-ascii?Q?B78HsdNC0bx6hNCePdX7bO+2eoGgqwYt7pIJ2DXV0/AaTqxhsbyqpDGl8btr?=
 =?us-ascii?Q?50qlvxSPeAmFZqmgR8PcwZSKBnQta/ZnDVcUotbJYIXaJQWvsW9fN4IxRfWF?=
 =?us-ascii?Q?3MEYLuizJa+TIAj4FDHBMa0hOVMB2tfB41YPNpvS9nvc3aBmLKosZFeot1sE?=
 =?us-ascii?Q?7vqXkfHhH2Fr1sitC7jkX8ZX0hl8Rh8epaY1BW3fueFRsc/U/+PLFB5cOkv9?=
 =?us-ascii?Q?zWZcsse1Zby1wAaZjQ5f23cwT+MUuijsPjFVDueChZkj5wukgsrhZwo4jaRM?=
 =?us-ascii?Q?GBAAognpEbCD0yO6WfYxo0BlcmbtdZwKvrrDsSXXRYcfVuOvql7Px6QyWZB1?=
 =?us-ascii?Q?efr28uM3m+RmYN3vrvh2bHb1GmroSKnxIgC5SxyzM0qzOhJBNu8zcqMMp03k?=
 =?us-ascii?Q?2G8RdZu6nE4Jbr7M85/pK+WUkfS1Y6ptyL1gDNfLlEz3nrY8mQBgdwu1L5W3?=
 =?us-ascii?Q?lf8rWm8240hxVaVrdxjTF6BkF0JquHK/XJYy1vcxJoZeWf65MZftSjWc9VKe?=
 =?us-ascii?Q?ckIjloO/6SxABpOaL1PbHd7KlW0/9LEwlZNrtF9iTBxxDjLwXoPiWLJ1wg9g?=
 =?us-ascii?Q?Ei01QvbPleYA2ColKCDA5A4LJkEqomBSSGmOyaWMObMVAxdD8IB+vl6r8vl4?=
 =?us-ascii?Q?bRkp9w+uEMUI3IXiS15XF4KihGgegNMpQP8oWvs0JnST8GA7Clzkk8lR3/r5?=
 =?us-ascii?Q?KCk4ztE2hpusdD/fwyIt5Y+8DDkRWWm/gEB0ASe3owrj6GYJNZXRsB2cvcWM?=
 =?us-ascii?Q?A+6bIZmDFOwHxSp2gnx7oLBhbTX5qrSkXoI4mCQ5VlMX0l7GNDezv9i6AzPK?=
 =?us-ascii?Q?suYz0vLfqgJwUEL2qEmLy34Qr7yhvqd6Qe5GbN8jVDM/69kRjJXDsQG4xJ1E?=
 =?us-ascii?Q?8O6UNOv+Ig=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0526e4b6-f58f-49e1-547d-08da16e09ce1
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 08:45:18.5751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fz0BcuwY/BcZ9ZYhxCE0Eos/JRlkdLaoCYiRJaEW7iVudVn8cgxuj/tVlC+jov0+0slelUPJDunQZthlHoXxlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0401MB3612
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Add PCI ID and callbacks to support Intel Meteor Lake (MTL).
>=20
> Cc: stable@vger.kernel.org # v5.15+
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
