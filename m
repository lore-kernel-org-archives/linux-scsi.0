Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C04FC433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 06:30:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00C51613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 06:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbhD1GbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 02:31:18 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:30832 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230490AbhD1GbR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 02:31:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619591432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MQfORFJWaz096+arte2FN/QM4Fdy9yn/P17UDMSol3s=;
        b=nNLaATBtk25AX8TCmLCHOuQD2jlRD0e3YlSLnQa2UZldrpqz+sRN1ZpnhVBf7yXFe2KEDk
        f6kc+f2VYVGR9AOq8u4BsE5BmMnSM/fFzpRdfbL9JzZvTdSW6ccQU1UH21kenGYAbbhlYc
        Nrk4YoPSTwzRcWpx/BdND4ScWjCaLac=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-G3TWNJWXOXigH9w-Zxg-lA-2; Wed, 28 Apr 2021 08:30:30 +0200
X-MC-Unique: G3TWNJWXOXigH9w-Zxg-lA-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LElJ9eaU41Rzio2t96NmRlpKueYo3UzkMWfQL5ZF4rfklV6ERGscZHwAus3qW/1G4hdJtggxC5fh0lXtn2Twg+vuXtLrMrm9F+BSZYC4lgxOCIFqyiSQP9G4D4yZx47S/y5XzUUSnODS7CxThk3n7KTarsD4g35V/qtg1ZA1+ZMhwP5H9CgMt5p7nlxBzca21/3iR0tEDM3lA3JOCfcYegMLhw8SQAxTjRdno/Br5tkoBTcPZFnfqEFzD2gRf+NYynvr741AwoBG8hCQMbi6YG9kRKt5Jhro73mve9zU+crSlsEo6sVJniX8Y9noDJqQFOa00tmAEKBovd8odeP9pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQfORFJWaz096+arte2FN/QM4Fdy9yn/P17UDMSol3s=;
 b=LaYekdOBb2vpyfJKYdCIWVXSDFmzw/h0VYfhlEgzKGPKXTWhNzPXNyBm29Ra0UJ7pRJKVB/fdJun6WakiXcZJXdMrx+CUZAIy+0OpR2NW6v8SN22+/hshSZPev89to6r2G5inHuME4/nQ0PPVN6AmYGdRP17cVcM/8V2kAEamjv5zuRZyQtvHQEDZ/ZbKutZZ9fcrmzpxAysRBH/GSI2WhfnrPCKrK7H2T4Ft2abu9NuTW15w6UMxIrIS6jY0MqWgetxujZIOJVSVOaH9AjVeKtJSv/wWlYjrrRiYohSElGTW2CgJvqRxcdjDrTCA4w7qpI8ukpS0EQ//wJCSsVH1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DB9PR04MB8348.eurprd04.prod.outlook.com (2603:10a6:10:25c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Wed, 28 Apr
 2021 06:30:28 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 06:30:28 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "emilne@redhat.com" <emilne@redhat.com>,
        "Ulrich.Windl@rz.uni-regensburg.de" 
        <Ulrich.Windl@rz.uni-regensburg.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.com>, "hch@lst.de" <hch@lst.de>,
        "dgilbert@interlog.com" <dgilbert@interlog.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>,
        "systemd-devel@lists.freedesktop.org" 
        <systemd-devel@lists.freedesktop.org>,
        "bmarzins@redhat.com" <bmarzins@redhat.com>
Subject: Re: [systemd-devel] RFC: one more time: SCSI device identification
Thread-Topic: [systemd-devel] RFC: one more time: SCSI device identification
Thread-Index: AQHXOp5vFUyf6ZqRIUKuQYht/xcQrqrIzsGAgAAFOwCAAAJAgIAApHuA
Date:   Wed, 28 Apr 2021 06:30:28 +0000
Message-ID: <9248c6df5484a0f5fe4247a1867945ed3902341b.camel@suse.com>
References: <c524ce68d9a9582732db8350f8a1def461a1a847.camel@suse.com>
         <yq135w4cam3.fsf@ca-mkp.ca.oracle.com>
         <06489ea37311fe7bf73b27a41b5209ee4cca85fe.camel@suse.com>
         <yq1pmynt6f6.fsf@ca-mkp.ca.oracle.com>
         <685c40341d2ddef2fe5a54dd656d10104b0c1bfa.camel@suse.com>
         <yq1im4dre94.fsf@ca-mkp.ca.oracle.com>
         <e3184501cbf23ab0ae94d664725e72b693c64ba9.camel@suse.com>
         <6086A0B2020000A100040BBE@gwsmtp.uni-regensburg.de>
         <59dc346de26997a6b8e3ae3d86d84ada60b3d26b.camel@suse.com>
         <65f66a5e03081dd3b470fa9aeff9a77dbc41743c.camel@redhat.com>
         <488ef3e7fa0cca4f0a0cb2e9307ddaa08385d3f7.camel@suse.com>
         <c8ede601244e1710dbf320c33c0f7853e249bbee.camel@redhat.com>
In-Reply-To: <c8ede601244e1710dbf320c33c0f7853e249bbee.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=suse.com;
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f52cb152-7805-4fb9-6fb2-08d90a0f1d68
x-ms-traffictypediagnostic: DB9PR04MB8348:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB9PR04MB8348E07A8A4F2A098EE6CF4CFC409@DB9PR04MB8348.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Op9rcHLWcEDT3JWIQ6h2V/iQ5RFNmYebVdBGQtnybZmhvh7D3M3g5ChumTj2cUA8dNKFXgxj8CnZ1rh6Qv5YCWvIA0rQ1ysCEUnVO4cSgAZDdEgxB1ec/A8jk644OiRy7+04QYMXLcPufqsF9dCMYOrox7g4XviDUE3UXxOh06sVEN7s/OeV4bhvH4AKQ0/hAdoSJi8akG6Wn8gUKGRT0CijAZxWqecz3wtYmbtnmYuBjRQkGWhII0siuzVaAn8+BhJzaFINhAS+qT1Lj4v3wgpieESzmilPCX2cuZybaX6EyFCJut36p3vN+oDVPY9OZn0sdy++DnAsO6pGTNkaMYVtLM70XbU4DuKWU8/VxEBFZwmM3O5iy/xwX8IniW1YPSiKdBz/SpK1OhBviORlNCNLk67oVT3deQ65YROI5YS7vcEbISmF6n2roTUyimMqTHVUf9X0tmjG2uax41BHVOLdU2AILrBJgSE2gtbwUCohfMqvyBDg/eEj4vR8lgSmcfmmUohOx2d7gV0yFha73pZAzu7N/922o0QmLLMeyfTCstNm9dceFAn66BSrl5BsDuTiyTKr2wkczIOfGkLHdGwTM5tqWM6SJqG+zyr5rW8Y4yKJeduDHcM11zCmyw0lOPyc+VospNTO2xHqhQ5bL/3RXfnej09biFm+SZCCZlw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(396003)(346002)(136003)(186003)(2616005)(8936002)(66574015)(966005)(26005)(110136005)(38100700002)(86362001)(71200400001)(7416002)(122000001)(478600001)(54906003)(83380400001)(316002)(44832011)(6512007)(76116006)(66946007)(6486002)(91956017)(2906002)(66556008)(4326008)(8676002)(64756008)(66446008)(66476007)(6506007)(5660300002)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?Nps4zF67FxLDsCtPmMzSBKeVv9u0K2r+KYvg5tJa/lyX6WmgJhdWCy30M?=
 =?iso-8859-15?Q?wUmytiCyLp9hHS5dTOOTAmzqnJQQIiFGxSuIv6hqDfCrLgVy9GpqnvxoJ?=
 =?iso-8859-15?Q?QkHqpbHhIZ7jk2oWGw042llcahc4Foy+ci4RtxP9Y5RuiEoyrjHTYdUPF?=
 =?iso-8859-15?Q?SR3nmY8mfvBm4ioriLkvG8/AclK8AWK+SWU72Qw7k0KsoZWmVmgsw5AUS?=
 =?iso-8859-15?Q?HeBcQAso3Uv9ZnToVFujhaRV5cCcurPi8qAHJA+YKGI7UAZws++gaR4DV?=
 =?iso-8859-15?Q?aH5uq9jEnKVKA3QuZSredekrypL2DGe+z2NFwkv2e+OexQ4wViwhweNIN?=
 =?iso-8859-15?Q?/CzweA4ZyvBRXij31kMrWd/gRS8Lt2vMYYkV61K+oTf4jWfIzjxEwYlKe?=
 =?iso-8859-15?Q?9LdY1flldytCmgLXRzwyr8OUbQ9JBF3A7LYHZQiJQR1bp1rTd+oEpraav?=
 =?iso-8859-15?Q?+ptSYTtbqLJt9s+NvbjZW403w6C0O+SSTQPwVsBzu48vtafkbrrYXkmAa?=
 =?iso-8859-15?Q?vCxCU5YRX9G9+6+nXEXlN2w4UMOj61BqjYeDeF//bNZKDdzGMbPhjj75u?=
 =?iso-8859-15?Q?jCAGsLJkStFoqf/SVJxAnOSMO98vHaxCQ13NWZJyTVuVg/aa42untPRBo?=
 =?iso-8859-15?Q?qAsEBs8OaNpThQXthf43ma36iw/cPbTFLtjP4Eo8KIQ9MBhfs+XV0xR/e?=
 =?iso-8859-15?Q?Xh9Y4BN3PgbJHZrm4QHrs+4HTVwcTtzcolYvgyKZfkWPfFBglGMDDtEAw?=
 =?iso-8859-15?Q?0on0WdMcDgmfT7H7gqNEvhozixFaduH+9UWtYNKqA3q9PKnUgPPDWke1s?=
 =?iso-8859-15?Q?KIAZPw/SVfl2d+2gGeiZtIMP4HYCv/JYy3uTyuiecxa6SykbZfhrHdo1v?=
 =?iso-8859-15?Q?hcjxEfRDJHx0rAHecEOOQ5eu8tYzWLY1kgsrTq28BXwMKdeHEO9AneXRu?=
 =?iso-8859-15?Q?HZtDG7pDlaovDoy4+SF5yLLLvshlghN+8UJ6d57tEbZOugUDfUS16ctU3?=
 =?iso-8859-15?Q?GKgilNqKAQJF0s4dWQaome82+KE4QrDcKHrv/EH/kSkYNM/R4E0pr8fnb?=
 =?iso-8859-15?Q?emfoLl4hnwirUEjhMujPoU5dSnQXmt4q1jY+/VNu7HQ8bUdysvjE6h4nH?=
 =?iso-8859-15?Q?IY5YbaHXNcspp534QvkfswaJCvyZJWUUBldUBrUvP1bCTn8jryUlPlbSI?=
 =?iso-8859-15?Q?UfbUVJvGaFz5I374DaVouqXj98IbrNwwmdKkgKhTzboc7g8Ut5lIrwIQP?=
 =?iso-8859-15?Q?Ys2C6DCRnWjDSPtZr7ZvuiBQ8F47DVw42f6Dnii0qxhqp3Ix1Az1DrTCX?=
 =?iso-8859-15?Q?xpkPpz+G8D1IXdLpeDFWSW90CRKtB06dHTN/Y/QRgK+ox7Cw4+Ek+spcW?=
 =?iso-8859-15?Q?vn+55WDd9U2VohP1Kh4VlwrfzFpyuP1S7?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <15183A7E88461647B8575C548998E707@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f52cb152-7805-4fb9-6fb2-08d90a0f1d68
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2021 06:30:28.2987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jUoArR0OkPuMUuIfVKUVtr/dzI1lG4RtTm5FYh5cWMWQZWuBkahzKCEpsHRtixuYGOd0rU0dZhNo/cxCY/oh/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8348
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-04-27 at 16:41 -0400, Ewan D. Milne wrote:
> On Tue, 2021-04-27 at 20:33 +0000, Martin Wilck wrote:
> > On Tue, 2021-04-27 at 16:14 -0400, Ewan D. Milne wrote:
> > >=20
> > > There's no way to do that, in principle.=A0 Because there could be
> > > other I/Os in flight.=A0 You might (somehow) avoid retrying an I/O
> > > that got a UA until you figured out if something changed, but other
> > > I/Os can already have been sent to the target, or issued before you
> > > get to look at the status.
> >=20
> > Right. But in practice, a WWID change will hardly happen under full
> > IO
> > load. The storage side will probably have to block IO while this
> > happens, at least for a short time period. So blocking and quiescing
> > the queue upon an UA might still work, most of the time. Even if we
> > were too late already, the sooner we stop the queue, the better.
> >=20
> > The current algorithm in multipath-tools needs to detect a path going
> > down and being reinstated. The time interval during which a WWID
> > change
> > will go unnoticed is one or more path checker intervals, typically on
> > the order of 5-30 seconds. If we could decrease this interval to a
> > sub-
> > second or even millisecond range by blocking the queue in the kernel
> > quickly, we'd have made a big step forward.
>=20
> Yes, and in many situations this may help.=A0 But in the general case
> we can't protect against a storage array misconfiguration,
> where something like this can happen.=A0 So I worry about people
> believing the host software will protect them against a mistake,
> when we can't really do that.

I agree. I expressed a similar notion in the following thread about
multipathd's WWID change detection capabilities in the face of really
bad mistakes on the administrator's (or storage array's, FTM)  part:
https://listman.redhat.com/archives/dm-devel/2021-February/msg00248.html
But others stressed that nonetheless we should try our best to
avoid=A0customer data corruption (which I agree with, too),=A0and thus we
settled on the current algorithm, which suited the needs at least of
the affected user(s) in that specific case.

Personally I think that the current "5-30s" time period for WWID change
detection in multipathd is unsafe both theoretically and practially,
and may lure users into a false feeling of safety. Therefore I'd
strongly welcome a kernel-side solution that might still not be safe
theoretically, but cover most practical problem scenarios much better
than we currently do.

Regards
Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer


