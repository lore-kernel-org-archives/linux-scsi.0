Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 638DFC54E76
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 12:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjKTMlv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 07:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233554AbjKTMlu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 07:41:50 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9786B113;
        Mon, 20 Nov 2023 04:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1700484106; x=1732020106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qXmzrU3JWv+2BY+PJ5l82WbQCLplz9LTVCMnWTC0BrQ=;
  b=cVn0m+OAZ2gx3dDc98v61LsEygjGOdnRGNEW5raU2mBzwNzuP5kbVNm7
   1zPWyWYOv1cFM9zWDI+eo/WBRkSmqRnT5CIR+9nIQnAPp+fyN140brUz/
   ugUDmqlov3ee3SG6BWZbF3QzCCzl8ho7d8uCBv2szWG5/mTYIqJ7mv6+e
   GIYZKFd2nSXqzpU+y5kf4asSisOd/P5Y3Y+ArXej/uVQVLoTwA9KESvqJ
   sqKQs0ciwLPUEhsKf785XGMLcYaqDLpo+p03Ckt34M3Oi7Ph9RwFCVhT7
   vD3T0zBLspFXL3gjTlPkudCfkhAc7RUI7aTU+qQsOB+WDAfXRVg6y8Dqp
   g==;
X-CSE-ConnectionGUID: tl04ZzhgTpuFve7SNEDfCw==
X-CSE-MsgGUID: 576KniwIRSulu5hj/1A4DA==
X-IronPort-AV: E=Sophos;i="6.04,213,1695657600"; 
   d="scan'208";a="2710009"
Received: from mail-mw2nam12lp2041.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.41])
  by ob1.hgst.iphmx.com with ESMTP; 20 Nov 2023 20:41:45 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adsnpLlJX9uRPPY78CzAGks7JzkQNSdu9DS9Q95GzB3c4hlm9XG7vu8BIvuuGPr2Pn87mx6y/ty+O1u+UDC+GvTIZ5DDt8Gzwg89+3fvzQ2i399XAlv4rLzZ7U95Yx8JTLLboOF9lJXZ80fitougZdrEWHvSOChE+dyHgZWA05MK1n2+smxLpFv614SwtbEoxJ8lCYWjP/F3qu+s8WGLAPyNQBiH9EtPCDpK3shtoJXs/t7Ykf8KY/oFml3ioouBi0wc9sZ0TzSnl6z3w3jrePThUwAoG3WOlNHBZml9erkYRKznrLyQ/gHCohGv2JQOlEVYcG21HSQGVJJAAIoiQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1gA6wNLx2WDn7AYzEyMQBoQ3ZFkFO0wREa701XZ97/g=;
 b=QOrllGFi64EDLRTlU2086JmKVZV8LClsXqsziEanagSxeKMBRHIDWBOihMzjQd7p2rojhBxTmtIbwjzkeyquTih1Cjjh4a8lUHNvvcipPqcWDHfOF0mSYenw/h+BcSdYLBtluSCo0MXkYHhKoG6nHA8Wq2jCDbkQiglOzHhMBnCJtSxmDmjcUOcDsIhAU7uNaoY8AlPzEhttDGs7dQNmVIUG6NxHxiGPG+Xx8BtdZ00ZrDzRhQbe857OZjCo6RGAN6JcUXEQIwFB5a0rarcvrRSWr2udMuQWFM0+fImzZVu8wzUKeLInaL7kmgvRfICSusclxbq5ZT164Q7N2E/AkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gA6wNLx2WDn7AYzEyMQBoQ3ZFkFO0wREa701XZ97/g=;
 b=SuZi0YxEU1A2KhMnUxx6UtAmlqZrzzOLAOQddLUgKPXmHlZDIeTESHnBzZykDBGnlcMMz0O0iJHYmdfOBEYTsIfAFnu+uam7+L9qgmo2vjXtU4oRlpjQKheacBgrZDOFbAjK6Jo01qSA2vUuInfGBZxSSkt+os5x2w8gfwjNjO4=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by MW4PR04MB7251.namprd04.prod.outlook.com (2603:10b6:303:7e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.27; Mon, 20 Nov
 2023 12:41:43 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::ffca:609a:2e2:8fa0%4]) with mapi id 15.20.7002.027; Mon, 20 Nov 2023
 12:41:43 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Phillip Susi <phill@thesusis.net>
Subject: Re: [PATCH 2/2] scsi: sd: fix system start for ATA devices
Thread-Topic: [PATCH 2/2] scsi: sd: fix system start for ATA devices
Thread-Index: AQHaG67qnMhhNGzcakuc5JNWe4ClCg==
Date:   Mon, 20 Nov 2023 12:41:43 +0000
Message-ID: <ZVtT/d1hW/dFmS4s@x1-carbon>
References: <20231120073522.34180-1-dlemoal@kernel.org>
 <20231120073522.34180-3-dlemoal@kernel.org>
 <a3008d49-32db-51cc-f9aa-ca9ec91ec14d@omp.ru>
 <27500ebc-1ba5-4171-b93a-227f1391d63e@kernel.org>
In-Reply-To: <27500ebc-1ba5-4171-b93a-227f1391d63e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|MW4PR04MB7251:EE_
x-ms-office365-filtering-correlation-id: cf70765c-53d5-494f-9c54-08dbe9c60cef
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: grxbspib6vgncwPaRZQ0CRzFjErka8KwRu1177rjp/DWv2kkKaV4XFo22rnQrVXl2Kd2bDRUgd5nwzDxkCCn2q4FjCPIfgV+ZNRar0cotsOq+YykXb0nG9Lc1yBhVOQ4NlU5VjdQ/AWjJOeNES6Trp8XNDZWvZVxFm6bqxQk8SHMBJ9Az61HKq+qWeVP4jzdxjD4yaVbOI8OPOsRSdtUekPP+3F4bQZH5c/TWaFNRoV7lbTKbeGdJOHSEGP79pmRRUwFHbItL/n98NC/GRA87IU0W5AkSWGWH1G5UKeglzJkDgW3cdLb4sPaThvf8nUdVLojP9GhoXlgWIe3hpRR2w2NypJ3Dr6w87PqzwssYjp4dLzahvtBvVs2NhqLqaZFRzcm7h+G3akCzXrRCZ/ylRZ6Uup8UExc6tL+vzu0+xvCs52Hw6WNEBZ15nzzYpdUIuBQpSYoqd4ToNf3DMZ0MHmSt2Qls0FjLCHtGh2PoxJacJ+bViYQQvYzACgL0G/QsRMn+IdrQJAjn4xZ49r2G04O9T64r7nATqNLRxO3GYqiEHHGq/G2uVbMhzx4rJNmWT0VdeP7Qx05/+pjMUNghYrAKYSqG6/oZ+zJ3kf1YB2vH3/tnChn4PzN/RqfyYn/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(346002)(136003)(376002)(39860400002)(366004)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(91956017)(76116006)(66946007)(66556008)(316002)(6916009)(64756008)(66446008)(66476007)(54906003)(26005)(8936002)(4326008)(8676002)(38070700009)(38100700002)(41300700001)(122000001)(82960400001)(33716001)(86362001)(2906002)(4744005)(5660300002)(83380400001)(53546011)(6506007)(6486002)(478600001)(9686003)(6512007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Zjm7mqngBO9uNnlxBuFpET2PiCbt7IQMsCJLOEGCJyZhRvN95SEPwsNYpj8O?=
 =?us-ascii?Q?6kqWs/T0zm9FhT9v3mWam4eJ3ZMYv2hbu7ICcfawwMmjQCQmwHXHjhsQjvco?=
 =?us-ascii?Q?eClaYt3c5OPefCi4dCVmHt1Bc7cBphvlSLf4/q+WvX+bnUreyqjZjYzkPAef?=
 =?us-ascii?Q?KHqYZ9VXGgHScL61KzEzPp3ByESYp9+zl74gacKfKRTOgR9j/j3IDKWeHVlg?=
 =?us-ascii?Q?9kNeaDJP5tyur11aEZp4z5Kr8BYUEfaCTXQFunv0Fa8EfOSzL13eqw8YbTt1?=
 =?us-ascii?Q?VGXbEdpZ2KUjuBz4GDU0swN/dyY4HsKFrjWVHwOMxgoj/oKabqfD7AtHpq97?=
 =?us-ascii?Q?09fS0HT7LJ4bT4o0GUVXAFhgVw3R11UoAXwdzQN2ErxkFH8GHQVwPbyjtL3I?=
 =?us-ascii?Q?bVBcbSJQap74TiaYbjgyLY7IMWhTTWJ2zGf+/y4Hc61kk1BaEJ5w+Le5iTN6?=
 =?us-ascii?Q?2EibpIv9yIfMvupJW0yP60Fjw0NlMBCXKULWpZHyJTnjseTeL6tdAoonFC+7?=
 =?us-ascii?Q?CdymQZARIM8Aj3t+j/SP9pBwlpKfLrOsrF4uwUv6tpx0ieDFR5uzTHOiGB2b?=
 =?us-ascii?Q?sxhGjqbZ5XzGw90+m6XFIvIxCUWZlp85t50W1SR4yB6S23P9RY94/Fk0EUla?=
 =?us-ascii?Q?OzBVK7jP+AjH9RUe2SuYnN+CzJAhAGA0WuajlnPADokdtHCTZCIAPC8jAmIk?=
 =?us-ascii?Q?NjmnhGmhAv211ahVN2eDeKMNDfjv9qyvCbDlLy34qB+Y99VOyG9P8HMRqsgh?=
 =?us-ascii?Q?kav4vUeJl+MxX5xJX2y1uNWKnmC8XwGV1DU/p3voy0vTUbZlhhZTlvOYMa7v?=
 =?us-ascii?Q?E+sCDswW2LCG7FPgFy1yobnpOy4tDVhPDwlY7TTKOLeRqE0x6eQtRgwua1Wm?=
 =?us-ascii?Q?qJ/dQG6wtWcSCWNyB635mbrnHuj021Ookcv4GRfy4WUQJcUixF6EgJz9i0/n?=
 =?us-ascii?Q?6c9WKvh26lbRB0jHUWPE2m7a0MF9TXN+r75zo/po5FiUNdCbEeSIEF2HOw0s?=
 =?us-ascii?Q?Xb38x90YhQN5om/5ia2GV22F9CygyQ2evd30RIZkWGBzdkBv9vsmu2MkYxdG?=
 =?us-ascii?Q?KsRwnJvohQdQhhdmCshWL3vGQiJPnrhZmyLXMBVBi/6xr/9DT+5vcKa3XWFc?=
 =?us-ascii?Q?WuMv0++CEEpbtZasTcHlNYhj8Db3RcuBS4//tiuuf/f2+XRhKXUM9OwWk/KF?=
 =?us-ascii?Q?RVd9W/azJqjAsIgusA7OCWE8XTuadSHQV7vAe8JDhtj7DaIoSLbLh1V1LkNj?=
 =?us-ascii?Q?zunCwYKXHKK9yzRa9LM4XSjhkmrdad71orxjgWSvXiqJeLptM0+D2Q9iA98d?=
 =?us-ascii?Q?eMjw7hJVqFdvEQ9Gzp6PoUI8+7W63tA6LM7QCwyGqyJ0jbUScFfrElJEC7g4?=
 =?us-ascii?Q?TrwJTepOhUFiYYcYZnSrhEvrK0RSF+snJTyWWY2Kuyx5dj6ecWcIUJdwFf2G?=
 =?us-ascii?Q?1LLCYsj1Ek9Db0uUWL+TcHaFIzvHslpySKtZrNyipJcRPU44DpAevPcmhjjC?=
 =?us-ascii?Q?TCGWX4PZ3yADjtBLyaBXb/d2/naTQxT0eoxBuMHkz+/NUWy86pJIb+g6mnnJ?=
 =?us-ascii?Q?6PzOqccqxITQmEDqBgTD4rXH1DuT79IzTUyZxFNwJT9+HY/exAJuJzygABbd?=
 =?us-ascii?Q?kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AA89A10BAEC83445A946015C667D6D91@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?NACBtFnq5t9eyCt0zZ77UcmRPszYVmkNmmMFBFdavbX3U/MRnG593ld0DvNx?=
 =?us-ascii?Q?XAGtEOp3jAyMjdJk7SbOC795lDUzvYEfPAno75SytvOnwQlNa+8+hHWqHryP?=
 =?us-ascii?Q?II1G9L/2J2m+BM88mr3T8eklwrF2mgh4DUIQ3QtrHzt0rCmBJVgWhw3ZFC6W?=
 =?us-ascii?Q?HcsV4dPpewvco8ZEgDwKkNhZwCEcQycHKTkr+DMLzslXbgNHUnt3dTymysv+?=
 =?us-ascii?Q?qMPeP85BeHWPmihM9om4WOmb5FB635eYSgZ3DxHWlaFMn7x6r5QcKxA4+2fZ?=
 =?us-ascii?Q?VtNatSH5UB81lAubbrqiezmz7ymkxJOdBLYGyToXichAdE/ZlRuNVwo87nn4?=
 =?us-ascii?Q?Mw94Hi0Tx/fniEWyyXaGkSDGN0zpm4zoa6FKBCw18/lz6CC2jadzvsuyerqD?=
 =?us-ascii?Q?nhILOiR3QYluTxDeS+GEa8A+VkHZirwZVUK65Cqp8KJoXvgF67FOygzQs0rm?=
 =?us-ascii?Q?EeiWLQxkJWv4EUXz0SzRxDbCkvAAzJgMEZk6BIMgddgXLgrRiIUKckfOahXW?=
 =?us-ascii?Q?kNHdQn+aUcY9GYc8PdwJWnArxiAKCtX21aFxFdx7aef57pxOvL9e1OVVaBnF?=
 =?us-ascii?Q?csiggU/NQmiZebJNtyw3h0KxdT/CKAqXLvhjKXtfUxaH7mTH56X+xfaTb80e?=
 =?us-ascii?Q?TWADa3tY2+NyyJs4UUrn1GqKrR6x59fdymQKVMBRyLLN8bw3vJvtJ/9I2urn?=
 =?us-ascii?Q?/fjb9FlVWASH2HWswT91RJ9Jp8jLADoIQyt2WWy5BMfxshthoBBvRj6z5jg9?=
 =?us-ascii?Q?clrkDOwzBzHnYC9DT6eihs28a6Mzlc+6Ij2rx7qbUfkQy5jAL0/Mr1dDI20g?=
 =?us-ascii?Q?s84iaP42pYK/JHDt6aNpydcYgUDGDGNUvmZBTo9IT7bfUQTkKCcxf9tMu4m7?=
 =?us-ascii?Q?+r3AsbGFTlcpH4/qYy16ZXRYCdfGLnbOoyeWIlwnyJILTq7hvOPyGRwTsNFq?=
 =?us-ascii?Q?vb1zZRsapdp/6WvOHLwaNzVM+Sna+caRXLrcjv37v0A=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf70765c-53d5-494f-9c54-08dbe9c60cef
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2023 12:41:43.2348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ed5ySkjgfKFFmU3Lf8LR+JamAA1/zXNNii97dSr+DTOqkViplvFi0g+hgx/j6RoBpwdX12EXdpl2x72yqfmn7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR04MB7251
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 20, 2023 at 06:00:08PM +0900, Damien Le Moal wrote:
> On 11/20/23 17:50, Sergey Shtylyov wrote:
> > On 11/20/23 10:35 AM, Damien Le Moal wrote:
> >=20
> >> Ti is not always possible to keep a device in the runtime suspended
> >=20
> >    s/Ti/It? :-)
>=20
> Arg. Yes.

While we are nitpicking :)

>=20
> >=20
> >> state when a system level suspend/resume cycle is executed. E.g. for A=
TA
> >> devices connected to AHCI  adapters, system resume resets the ATA port=
s,

Double space between AHCI and adapters.


Kind regards,
Niklas=
