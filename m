Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFE1C77B78
	for <linux-scsi@archiver.kernel.org>; Wed,  3 May 2023 07:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjECHQy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 May 2023 03:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjECHQx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 May 2023 03:16:53 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E6D40F1
        for <linux-scsi@vger.kernel.org>; Wed,  3 May 2023 00:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1683098186; x=1714634186;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MRSDiTw1CrHOaPc0IWJKJp9Pp1XC/nPkxxBcWEQ1OTw=;
  b=PgvMbYx/ThUUCH0qCfrsXJ0u3pqbLG51yroFtM4jdpGy0O1oA3uBYnuq
   oNGZ52WsqaXR4eIa30SyUY1WYR2w/UUbxb5R0dl1Jznhy0kMPY7TxfwjU
   mtMM34j2oj969fWEyiHL+e3QSN4T/rjIE6AoTSVEWBpb8xOYePBtb06iF
   9jzPLRTbjPFMFiFl34/TbyVtVKS4Q2suiSUt3VovzW06gdgpTo78qleFg
   8UOO5ncXf01r4eI+stuLP8NAysbStNFSsrQepdaM4+DFCMp2ryGxxlAcc
   UT3zXNYnmAGG4cmBIS0sfitfjRWJJvIVi9glFL+z8K8aOu4huIX3upxI1
   Q==;
X-IronPort-AV: E=Sophos;i="5.99,246,1677513600"; 
   d="scan'208";a="229669938"
Received: from mail-bn8nam12lp2173.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.173])
  by ob1.hgst.iphmx.com with ESMTP; 03 May 2023 15:16:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIv3NN9h8y8TNevADL/SQWrkFehWbcqUOGCXKYlrhwwhpbh7gz0+LEJicnI3wL7hCsX05cWLuM+CBiR1tekX5Q4vhYL3JgH7D7Pj5NpmrKSXhTaoyRbq7WvcxwixiMDKgDv3B5Mr2n8PvCrep0zWyjkSU9GtmWOWihUuTRcAs15vta049qBbiqFBR7n8oTtCzQ+9ederpCMUBLX4EQ1mn3kaOwvxh7rb0clO8bElmT5uPJS8iDqkX1K9H1G/Got3To1IZ6DODc8qNlVGE3BbaK28oUkgYTT4+lhUa8Eq7xTy3fvTPGDul33zz+hSp3dYIG0kJ+6lTeT8I8r4h3a4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lWBb0+AthRZHgT5g6wgr+lP7CB/lIfWLLwGXrKWoMs=;
 b=IuqQypn93afHCp4Gmcf4Oc0kCLpaZjKFoSVWxjpCKo14nfa73ejWiLf+1hIY41Z760m0Dun8veU1Z1sYx+41xiP/od1ZX9ZB0tVHlMB9vvmEcPdDOQ+4HpjvxCOfQ3QssgmmjhfUGY1F+m7viz7e2zNWz597K9hQw3YSg9eVmT6MM0Am8KvqPy4M+vnKpgtjmdbmYXJpgugL/F+YjoA4l1wHh2IHo7vDGsQRxlwjNG3MGJgK0i79O9/9KIAcW/to0aKsdjSlm+Il80LkuwjAd8d4h52iP7n/MooCXc7/qp2M3R5Ss0RpBK4gj228UJ3/IY+ZkUJyBT8cUTRh499M0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lWBb0+AthRZHgT5g6wgr+lP7CB/lIfWLLwGXrKWoMs=;
 b=z27F0imUgSekGHxbQfbsQ6HkhSZZGLQK9KWfn5fcW3F4RVNzGCQrnmdKaAHtMq2DxpktifynXZYeI/aqoZO28aW2KehdkfrCEw38ad5VSlrsLCyYUW5rLKwfSo4wKApukhvzaV1Q4vnekpeSC5uKgq6wMu/3an9dVJX1ADAf9GM=
Received: from BYAPR04MB6261.namprd04.prod.outlook.com (2603:10b6:a03:f0::31)
 by SA2PR04MB7722.namprd04.prod.outlook.com (2603:10b6:806:14c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 07:16:21 +0000
Received: from BYAPR04MB6261.namprd04.prod.outlook.com
 ([fe80::a2a8:944:270b:13b1]) by BYAPR04MB6261.namprd04.prod.outlook.com
 ([fe80::a2a8:944:270b:13b1%3]) with mapi id 15.20.6340.022; Wed, 3 May 2023
 07:16:21 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Vishakha Channapattan <vishakhavc@google.com>,
        Jolly Shah <jollys@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH 4/4] scsi: Trace SCSI sense data
Thread-Topic: [PATCH 4/4] scsi: Trace SCSI sense data
Thread-Index: AQHZeajLSvQtpzf8lky+3WrgPH7we69BDV+AgAW254CAALJ3AIAAtEIA
Date:   Wed, 3 May 2023 07:16:21 +0000
Message-ID: <ZFIKRFICCJv5AtKj@x1-carbon>
References: <20230425233446.1231000-1-bvanassche@acm.org>
 <20230425233446.1231000-5-bvanassche@acm.org> <ZEt/SD/GiqIo5aIm@x1-carbon>
 <e859baeb-f7e7-9d58-bcfd-9b11115bdf0d@acm.org> <ZFDdWY7LqLQL0nb6@x1-carbon>
 <1232c27c-4da6-a738-c138-b0e65fa74467@acm.org>
In-Reply-To: <1232c27c-4da6-a738-c138-b0e65fa74467@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR04MB6261:EE_|SA2PR04MB7722:EE_
x-ms-office365-filtering-correlation-id: 090b6977-f3e3-4bd1-4016-08db4ba64bbe
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sy3Sl0d5RUG+hRC+r6cnN1XwG4fau0J3uvvivk5jFwxT5j4H9yFLGwLHFNXYqTRvY2xyuvjF0Z0IOLCC3+7ZWYyF5hIGKp1j8aAJziCOM3shzxogTOUUIFD0sQWoJY77m7crwa6SWcW3D5xTjs/8zprB2l/RtXVSn6FNup2Z05Bbb3U9jDS5wNPmNgvhPRtUOyy3RJfje8FhK2YsBseXTO9HaniC8WWJ+TdGblteURTNQD16mtvsUvPLdL51ZaWL4GZTLRzkm4NO80v4Sd1h0lw4rP9/qcKrqYbpIBeJHSns+OkjzMMVigXoAUC4hElCino3RZCDNJoVFmWg58pk0DFeYhnHZiPzlckSGYUBqWc62ZV3CsjtsRWQp49Q/w/ZKFAAKFOgXTEI/bm82X5iswbhQVNtjov+tCQM/pRaUmb8MT6TTWyqJ6Aho7nxa5UCE0q5+iv4R/vjWqLtLulYxZtQjRpUiRoB6DMXDRhHf/iZMLlfJ1rYwyYoKKA4pqFI3IHXR1AAcqz/Bj66vRDDl5bkFs5uNnqsaQF673AOkgEjHKFWADr1nSuNchh/daHzpyi9SBXFSj1jQ2rt3ixQZqKZMO5JnPmsHybl3ilEHtxU7J7r18z49PW+xXqaGvOx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB6261.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(396003)(346002)(39860400002)(366004)(136003)(451199021)(54906003)(86362001)(41300700001)(5660300002)(82960400001)(122000001)(38100700002)(316002)(6916009)(4326008)(478600001)(33716001)(38070700005)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(6486002)(71200400001)(8676002)(8936002)(7416002)(2906002)(186003)(6506007)(6512007)(9686003)(26005)(91956017)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TWS2j8q3bYmme6OwYNs2uFgS1QU92qI18RRz9z3BsRjdYBqTedNY+/uqwcjy?=
 =?us-ascii?Q?IY2dmh6aQGQ+0a3Ki/GGEDNym54IG3aND+RG2CeeoL6wYdk6imHRN32J4sbU?=
 =?us-ascii?Q?xz/Fq/xgtg4Jm0GTg+E6vjCM0JQUV81sp2Qa73/CuLSPWAZkdiR1fi0JlAQR?=
 =?us-ascii?Q?GhJopCjiwKwV7MFiOGTAOUHFuxjF81cDboDvpWyzMXR9PMYIc7ajP4/sO5KN?=
 =?us-ascii?Q?wmrar4eqvr6+EhyDQj0XB6AoObNTK1LaiXn3yVOkY0q5P9XSegkCl2p1GAnJ?=
 =?us-ascii?Q?6YsudrpkcAKbrLw0ayPWDxdhMjN14KH9Rili4hGVtDJYbM3fhddeEgVv6Tby?=
 =?us-ascii?Q?4ceyOLidoEWBxCMjXNju1fPnHdDDyx0Sh97CL0XkXROwZ1vXzL446NVkuaXf?=
 =?us-ascii?Q?FX3jWe2oKWbCKwsBDti/vzH5zswMuKQlvVD+8BLD1EbjUvPjOzU+tAJf4il4?=
 =?us-ascii?Q?tspWaWDMuoEIhnaU2XEN9FBSmYvPztTwJbzGKRnXilPi/J87errOrpitZpF8?=
 =?us-ascii?Q?bKTseSCnaODnUDXwaXsNS3PHcKerdupS9cxgCXiSLxO2rlvS0h6xM1fIXY1f?=
 =?us-ascii?Q?97A8AKSbafQ8o+ydd5dqYzfkvn1fwO6oyhURIG6WtSgU6G1JyhxTZQIUzjAr?=
 =?us-ascii?Q?qyzm8f3t/AGP9f/OFrVzW91s7S+p0evoZXc5NMLUtr3ICEbisxJDSTAYugW9?=
 =?us-ascii?Q?Hs//ZTnIxPWKQTgFLO5yoxDNeb9rzTMWPmFr01tXX89N8gVKXU37Rh67hFe3?=
 =?us-ascii?Q?Ect0KpV/+dxj/RiAKZg+3r7VIX8YlShYXgBxY0Eu8d5RFTFEeYE1ocDnAG3d?=
 =?us-ascii?Q?szDMNGCJoxAFJWkAQaluTd7cEDZnQ2T2G69r/pFGaxxsctnae+WmbL8qK2GT?=
 =?us-ascii?Q?quuzJ5FjjdjK49uWDldKleJpBT8AeIRXgb54FYBJvP5q03jM/Yw/71gaFmiC?=
 =?us-ascii?Q?oPnUzpirp8kuSeldNYco3PPmVOsVDU9aiGiD/wiFBMJzJEgEgGLqy8OUJ0Gj?=
 =?us-ascii?Q?T4p70VQqubyA5EQOBmSiecshtZlGLMhKO6yzrwIaYykbHQYNRdhJ+q5bHeml?=
 =?us-ascii?Q?WCjtqbr9EgzgjLMFyrlXX3zmb7D3UFyzL7qJiG7ADWGsW33xNtxrkS09mdql?=
 =?us-ascii?Q?GrGsEFJcRsclGLgUJ5wiVHcxie78vvgWY3SgYXk/QsWMEQUDwLaPas3tGMzo?=
 =?us-ascii?Q?7JD88uRa1BcdKHToxoNVV0XLtcwksuUH0DQVBIv1OZT9u3lUMnZgfL8cILfF?=
 =?us-ascii?Q?Uro/80pBySUpeDINAU7vq7TCsH0xkBa7GW71b1RoBxg0rGmwEs1964vUEcac?=
 =?us-ascii?Q?+pankmY8wvT+l9OHqXrdhuLl+PYtAhQuN9KzJhPYTTn6SJ2+aRho2B/ZhD8G?=
 =?us-ascii?Q?0+mXI3nehmwQQCSMt4X9oyOyEibLBIcNb9iupf1CuguR2l613HG2Gf86ejCY?=
 =?us-ascii?Q?IjV8moTaGMtiCVhCOVmRJMtYApEtoXj6IVaSIrLgJDC9N6eyPMk/x6InUold?=
 =?us-ascii?Q?ocADt/QoloKeBp2j2wWyRSGIpc5twE9/qp5nduhIYuvyp2e0YiKE6bjt/Lfa?=
 =?us-ascii?Q?r4QgSmm5vE+ePi6OVJ/SRlNzVk1eXhPaUPkb3ZC5PpMZzp7BDaP8AdnXs1eX?=
 =?us-ascii?Q?UA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F679DF0DE621540B49FBE4FD0ADBE50@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?BYnwJZp+j1el0lfZK6CAXFro9cZkKZUIV/DeFvrwG2Z35PCUffZSXe4u9iYg?=
 =?us-ascii?Q?iixaSL7TR7YKeacSB/uYEfKNeZ7xUMennbw0mF7RDZ76ViTuzeRY5e9rqWvB?=
 =?us-ascii?Q?tiLXVKS2ekbnk+4r2ioC7r8cdb6EEtCxHWpBKQzs1xJnrEQWDw213ddyj6kv?=
 =?us-ascii?Q?G2Ezc7fNRlRY/lyGuqzvmf014S6cuEguxu/O0OfBRAeKgX2tH121MboogrL9?=
 =?us-ascii?Q?hlEb66xQLknY4szJ+zNfbRvLlwWGAfHsj/nE6Yi+7DYbZfeDdmhAgdgwy7Y9?=
 =?us-ascii?Q?qBcM2ZXqX4zfgsUoPcjz4d8GefC8mtGwOLaT7g0qRSdd//5OeqIgMoCtFTNx?=
 =?us-ascii?Q?6o6M+cjVF3MZXkdbAftf8gagUdLcTpFD1nOMCOvnkzJ10rqj5OIRYKkNoqo7?=
 =?us-ascii?Q?5g/8nw96cT1zFhLPt8l2TydFk6OpUq5mrXczNObKrhBh67+Kwzy4wp9f+VbR?=
 =?us-ascii?Q?vIi64XqoYIL743xzz3AqRB2YKlv3IscOcNXlKka+oH2AAHMzJjMWgtKSRlkB?=
 =?us-ascii?Q?w/rp3mgjKCBKWTITsi0ZfEEPDaOV54EHeZQBxE6lyn6xo0+mY3uS3bIsm/A5?=
 =?us-ascii?Q?eQ9V1a8Zw+osc6dYVFvGz0VPOEDxt3W7pX9EK/9pPQGYq5evpEzwj5CNN1sw?=
 =?us-ascii?Q?ABBk31x65QKitvAZIShwxzJQbmUZDgTOKz1bH7CwRxQb1HoInzp0VFf+pyAX?=
 =?us-ascii?Q?KXT8Yk40IyMcv9BGK2YUIL59Yi+k4N+YnwwrpxaW6i/oauziUyqMj/hg2mOZ?=
 =?us-ascii?Q?lo1Xv97iPjCoyTREu2qX2XjL0Osk7DyR3KrAX5H4yW/mKJ0/AQJbIJfr3nYd?=
 =?us-ascii?Q?c2lYKy5ANwO6pD7cvVcxu12WMD6BtAckWKS4kfCDyUoCHeyat7isFdlMVh2G?=
 =?us-ascii?Q?G5g1CQL1S+a4eZgBG9MXLtyic3vL3jGCHBcARH6P32b78zr3TPd3zCymKNv0?=
 =?us-ascii?Q?wc9LiiRcuFzXdhFrdiApibJ+3AwbQyJtnE2RqQGnwC0=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB6261.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 090b6977-f3e3-4bd1-4016-08db4ba64bbe
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 07:16:21.0370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LEIDSA/X9zss98DlkELo698GDGX503nzMPSxoBkYIfrdCBDgodgeqFOaNk6xP3M1PbX/0KY/XQ4GDQX4dMed1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7722
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 02, 2023 at 01:31:10PM -0700, Bart Van Assche wrote:
> On 5/2/23 02:52, Niklas Cassel wrote:
> > i.e., something like:
> > 	if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> > 	    scsi_command_normalize_sense(cmd, &sshdr)) {
> >=20
> > instead of cmd->result & 0xff.
>=20
> Hmm ... doesn't the SCSI_SENSE_VALID() check above duplicate the
> scsi_sense_valid() check inside scsi_command_normalize_sense()?

scsi_command_normalize_sense() calls scsi_normalize_sense(),
so that is a function call.

scsi_normalize_sense() then performs a memset(),
a null pointer check on sense_buffer, and length check on sb_len,
then assigns sshdr->response_code, then calls scsi_sense_valid(),
and returns if not valid.


Considering that this tracepoint is called by scsi_done_internal(),
this tracepoint will be called for all SCSI commands (and not just
timed out commands).

I'm not sure how much overhead the function call, memset, and
assignment is, but I would guess that it is not free, and since
this is done for all commands, I would assume that we waste less
CPU cycles by simply checking SCSI_SENSE_VALID() beforehand.


Kind regards,
Niklas=
