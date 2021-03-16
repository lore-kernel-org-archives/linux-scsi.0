Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A573AC433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 07:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5ED4364FF4
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 07:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233058AbhCPHxq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 03:53:46 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:18511 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232920AbhCPHx1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 03:53:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1615881207; x=1647417207;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XEJALZiJ4ps0yJiSpFUAgWDbUcodL8B2Y0gEYSG65b8=;
  b=C1G6+2wvHz3FB1Mv3obTJXqe0x9Mkb+Jn9dknUT/Niw6p5FkNy0uMwqw
   UlIU+r5XIhtwBVScwO15QCfhvQ78urIbYEbcb1U4e42OrVnyrQ6Plgvko
   Xh0q2ngdE+XGteuJbrz4fklGR4Y1n+y6yd29n72F9d8UN536H+ycVm6nE
   4JytspMjcaeAi2gTQKKNddMCddm9oQU///Cry/XSzF2ss1Jt2nAm3rVHi
   rv4N68803pJOu9GC2+Xm8VYKwUWOX41IxyKbGuV/exRkePWZEQZgN1286
   Vv2EYklPqTclvsTocisvLfNYEPKAVVoS59Cx9/jSBek6b4hZzcazhu7P0
   Q==;
IronPort-SDR: sXrxJd4Wd47KifngKQhEcnlr9047aAU/sNHd0L+qfW5v0m6wVt+02iMDyTBOOORPwLH4cTtq+e
 I0+aaZD3Q+LnE7nGLg83ZanMX+RyG3GDol2NuTUBnDXVghcXOyAQSeNUDaJ5SjKX7Ol8/KBK35
 HO1sbuGcArQorABQuay702siMTk8mZ3NnMWk88csTsgz0bBwv/6IUBC0AvCbAnBF09iqy+XZEl
 5Rxq1sTOBQqSo19ZfV0GVdOaRMSdWgh0EiZqTdQ+GXPutSLkVApwHkxLTQC3R4lS+GHL1GpiCh
 8jw=
X-IronPort-AV: E=Sophos;i="5.81,251,1610380800"; 
   d="scan'208";a="272959444"
Received: from mail-dm3nam07lp2048.outbound.protection.outlook.com (HELO NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.48])
  by ob1.hgst.iphmx.com with ESMTP; 16 Mar 2021 15:53:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOxB3MBe19EVgxFhgv3wtYYubFnTdysobMRkyOUQV3sbYWh/aHN8RfaoD5YGvq0y+91VHqDzd5UawwILrPDkbrLIyNS0fSIa8yPNb11s7Kp+pSiYzj/F5Z8HRJcUXVZw08qqWnYAGQMPbVr+t6/DrOLgHV76Ec3Qye/9oaezkUWOTvfPzytGYJ/mD7ovRhSFir8irfG9hpRcCnm7hGZxaazTRpOzLboHRg2NpiyXyRj7GnkCzoTfndaE0n6j3Ugt7R2O9zJlirdxx48TsUpfr8exj4GAVvrN8kfijo4rEFBggTbxo+DE/Uf2oscKIEaIw3tBjhmRftyuJ+VFirPAjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEJALZiJ4ps0yJiSpFUAgWDbUcodL8B2Y0gEYSG65b8=;
 b=hJW7+87glp94Xok5nmucsjMAi+pbco4Q8+9fsuduA8Dl6t3/jBc6I6sh6lHBnNnQ5ixHpJmwoCYVIsCQKScBA6Nj0mwBahlBRbGscNouo6gwKYtxtIX6yJM/M38G8ohFC/LEFDcY1DOHxbXxM2iI8WqIq56ZqqEcbbEfLiTDJHb9fsRsBQYkT5YqbrZx6qPjsgPPnXNZfIXS7sfAUuMOojtUCnQjWjSY/d3xVJLkBVbWxBxkuNuzh8WAqpsXpDzgjtDomhP9LP7F+LWhCzqapYfBGXSLl/U9YRMc3NPLIVDNVEaTMXw6C9ReiOg06wYdkWT3V1IEbuuGPc/r3M9NNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XEJALZiJ4ps0yJiSpFUAgWDbUcodL8B2Y0gEYSG65b8=;
 b=sZ6BBWySC9/W4hImRypIjgXsCYHlB4k/cUpaNw1OeWHYIt1YOkJddEnqsIYXEWG/FQOEhZFEiQDSA7+o43L2P0wSXn0vAjurFcDHkGR/sQOBXJ4XZUce3Bnj/nxSAcQqwsFxIooCdVtt3IGetKSVPHhD+Ad5NaybZ0bJkfSiyFY=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7143.namprd04.prod.outlook.com (2603:10b6:510:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 07:53:24 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 07:53:24 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Topic: [PATCH] scsi: sd_zbc: update write pointer offset cache
Thread-Index: AQHXFZJ9Ugg++iEKb0KOzcBTGpFywA==
Date:   Tue, 16 Mar 2021 07:53:24 +0000
Message-ID: <PH0PR04MB7416236DBF6578C221CC65319B6B9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1542:e101:a4e0:11d7:79a0:82fe]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bdb80b81-71bb-4e19-c27b-08d8e85093d5
x-ms-traffictypediagnostic: PH0PR04MB7143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB714327201C6792A9C32B1D089B6B9@PH0PR04MB7143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T1mb36/A9xGYn40NuQa3yDp9bULKDzFLhkU2t04d1e9FqEorOUgl6+L7nY6EM9/ui1AJhfQ7MI+dZN2utfSbFyLmBH0KcQhAUXJr26kmy4bQQjNzbyVrgIuMrerxtdjzuC8PvhXBzQ2b0tZv1+3MIX8q0d543hRD16D6UEAvnKK7c6q3jtWQl98sX/fKFi/hcPnVSHKXHiyHgtMgDfYw4h5qXyf30IruzaMhbR5WZ3vw96N5ncwnooH1usTwyQgQWLzYuZziSWr/ontLtWupOMMIgqOpFWg4iof4ofUb9iU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(316002)(19618925003)(558084003)(66476007)(6506007)(55016002)(54906003)(4270600006)(6916009)(8936002)(86362001)(66446008)(7696005)(2906002)(71200400001)(478600001)(33656002)(52536014)(8676002)(66556008)(4326008)(91956017)(76116006)(66946007)(9686003)(64756008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZStN3q4g386xKNk5/6y4/NSrzGd+hkTuOYBMa5aZGdaP4pE1LDP3KhA+Ygwm?=
 =?us-ascii?Q?LQeZq0RlmWbAZ80d00lvqD9MbeixrnfsXxKyHI9EmuDtoUcTt7ExQO5XEz2i?=
 =?us-ascii?Q?WB3bWjtIZKlu9ZTgqekqxzegQQcH7gXgWQutz+KglqbtWTomFkpuazq6QTGx?=
 =?us-ascii?Q?Ri2m3pdKY5aii/PcKAfgpBOVNxwOJLwg4Hh0/maxl4b6Yn/mK/vLnzyrdfje?=
 =?us-ascii?Q?bkAJycV3zZNp7DvkSTToPgT798jKzyMUkrXzDgnPaIAdefkkJZRTX05goDXz?=
 =?us-ascii?Q?eBqYCobOauJg/sKYhlP4w+Yix60gZ0Rsn/6NWdt3/BfFMFNusJWY8DoOJmaF?=
 =?us-ascii?Q?M8GmoOTQj9+wX8UdmyvqBZINkpejeg5c9tq420Gk4CTkkxYfUchvua1DHByl?=
 =?us-ascii?Q?YnSBB3DioYgAcfEmB4IZWzN2s5OuNPYPNZEQQI0Vjm4ed9qZWCVckc2BP6TN?=
 =?us-ascii?Q?k1cYbsjxwosRqSWquFpkJ8a2YbNPBzl6H/aXHG+WgJzsKy1HXxObPMkrVhf3?=
 =?us-ascii?Q?MQJ0A7Nxhlkwcw9xntGEdW/YD71AyBFiIqhZxm4Bnl6Z9E5mDN9UreNhc8a+?=
 =?us-ascii?Q?TwU7UZDxOC8FDCFqxr3HKBgqqhGk+rONi9IeAergaawkeEFKjNG29wyRBaNK?=
 =?us-ascii?Q?ByUkRQr69npMrnE3niyhe4+SI61qdD2p8934cydA2aViNO+Xu4Cn3ypNt+9A?=
 =?us-ascii?Q?nZ95WVH11ovab375PGl6KvSqUMKVDxpI68k/KoVmRRsqf1TDEe/gWXeWeaSC?=
 =?us-ascii?Q?ofmlRJ23yMT78MjJ6Nlz7RhN4qZ806oszQjrcDG5j8aHp1vG8sJEG7xISdjG?=
 =?us-ascii?Q?sCIRhQr5MQ4FF2gVcNwZ2wiaT81Nwu0CFXuDEBi19x93dW4EWDuFaF/p4D01?=
 =?us-ascii?Q?j9frnitqu6k7GQYND5E8HZCr2N6Y8Ccm4yIDRVw0Obhie0Vsh9WJfaNxI0vd?=
 =?us-ascii?Q?FiKzLlef2mzhUNhjec4TYhkcP9Pe5Frms1LYUzniEQlJwLyzMzBcPIdMAlJ5?=
 =?us-ascii?Q?2KlE1R4P/741rTBf4OlqQsuzT2ZQIOlQPvo0csWiOJL6bsSfGhm/cJRjmnUq?=
 =?us-ascii?Q?hT8H29er0GYsgKfzuTQQz4vSXNIhZIZAv4GfX40Z5O9t+3eSbIWxoAPQZGAR?=
 =?us-ascii?Q?FClakmwcNeD5Hh0eWfLHRIS84PlXISb0fahwTfv4w9np6SikF9GzOGtw8pc4?=
 =?us-ascii?Q?XWF8X8IUsuawXsfIaAYyJrNMnIWXpIK4irnYjvoJg7kbyQRyN8bUaEC/DjiR?=
 =?us-ascii?Q?bBvNlHDYXxW0RpjH1tqaLllqzZoTCcRCAlx6Y02ce8ncBR1nq8t8HZO6Zny0?=
 =?us-ascii?Q?JkcXWfzOCaiZ8iyHEY3uz0PZNMbunf5TqlAqvoWQ9vSz4fcNzV/r8GeHaM3M?=
 =?us-ascii?Q?cMN48qoVzGQ+RmIKWHExqzwco+dRJniX9AbOpvHHS3EG+Roz1g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb80b81-71bb-4e19-c27b-08d8e85093d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 07:53:24.6559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lFo/q7ZkYSM/Vr8gVjmJ5benPs3n/hYSwVG90kMf5Y214A7pHXCyQnvWzVwIJwxiClDLhEW89mvfq1Lz25GzkjdDvQE/pojGrabiRcPvwPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7143
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin ping?=0A=
