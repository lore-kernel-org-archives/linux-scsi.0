Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B9BC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 13:23:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5506206C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jan 2021 13:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403827AbhAZNX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 08:23:27 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:31894 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404290AbhAZNXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Jan 2021 08:23:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1611667311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=143ZL3GVuidn3P6PeaHIcTRjqNCcjzOwMrsyAlX5mEY=;
        b=EfhmoN0tfReWn2WYLzSlLaY6NYV++HwLYpRnGXPKzgCBCL6cNFKnr/WCYEb4t6ilSnfM8B
        W90sRHGoipQjqc3vkuynr6epkzO9tyzffSeMsPevjZp++LulzldVndkrrFjcaiMJxV8ZLj
        9OaP7iUgp+TTJBn6Tvob+Kqgw4YUIKQ=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-pRGsDs9hNv2QvYSfmzi9rg-1; Tue, 26 Jan 2021 14:21:48 +0100
X-MC-Unique: pRGsDs9hNv2QvYSfmzi9rg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oq13qCD7lM3IKIPIrjXDzOj/p+3JpUSnRXgX9ATNc3n4FUphDw+b8XQIzT78j9XeEl8p1aX8tokb30qexu1d3hAZ4ey1TD19uJJX4i+zJxWI6vOGZi9zRha2B2TGxZ6JO1CHKuO3f2d+65Vb/NMVj1batBxPrL6lysJZZMY8V/C/DWU0/VeLU+PttkXa1Nut+TU5rBD57wgSE6EOIhbQMXIhVi9wTabnukQwA+ESbiw2ZK+TXmZP/BtgQuKbQmKkcEiZnKQ25ESHJTpOBbsa0c1XKYEX3BuUhNITjyqcefJ7hYPVsnhU7FFcsljwtxy0yV3RG5nNs1WgBXlZIvv+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=143ZL3GVuidn3P6PeaHIcTRjqNCcjzOwMrsyAlX5mEY=;
 b=hTGo9mwCZK1+7R//tYWnEFftyftYfDsuoRXbrl4dWTBt1QePs9KGg8HVLOJfDIp13+X6JTlk30Ok61suBz/6uk4+BnEWXEqJbmwQpJcc0/KSDRgx4GHqwwVDbgkm/AYi3PNKkh3XqWbovqlt13mfwfDnomZqPd9JyA4jYBCy29PN52fAvDCF6+yONhjGucYUI0atoiLXv+VV9Y+qyLB6JMF3xnUfzSCna3gjAdGjq/xxmZC1qdKTvXHWqdu4GpSDqRBsOx3sIa0CPHr1r9H5VbQJIUeJ6o2vKZr0baghDGftg2bzA75e1OhzqGxzYEVL4Q+ht8W6DT6PMt7UuFCh4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by DBAPR04MB7206.eurprd04.prod.outlook.com (2603:10a6:10:1a1::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Tue, 26 Jan
 2021 13:21:47 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3784.017; Tue, 26 Jan 2021
 13:21:47 +0000
From:   Martin Wilck <martin.wilck@suse.com>
To:     "hare@suse.de" <hare@suse.de>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "hch@lst.de" <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi: do not retry FAILFAST commands on
 DID_TRANSPORT_DISRUPTED
Thread-Topic: [PATCH] scsi: do not retry FAILFAST commands on
 DID_TRANSPORT_DISRUPTED
Thread-Index: AQHW8+N6Ml8L5lI2MkSUuLDsQaVDNqo55JuA
Date:   Tue, 26 Jan 2021 13:21:47 +0000
Message-ID: <813a6233179e68ab87f857d7fe9014931ff4c662.camel@suse.com>
References: <20210126130212.47998-1-hare@suse.de>
In-Reply-To: <20210126130212.47998-1-hare@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
x-originating-ip: [84.58.19.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fe24e5f-b7cf-4607-6432-08d8c1fd554a
x-ms-traffictypediagnostic: DBAPR04MB7206:
x-ld-processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DBAPR04MB720686C4AF3646041AD2F597FCBC0@DBAPR04MB7206.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rnkNNTgNvtb7ksj1+chRrfOIZywPzYdlTc/04RneYcfiajH3BiBlCm3sWXdJWR5b5Mog1e8h6jhDk290lGSHb2CFt2RKOiwxy7hpc/v7m5NmwOs1Gy12itH2sh9ojJ7a45VuK5ZWC5frVf6tsPlfFBOfZolzckvGLIKA7cnJaFWaxhuQyD0WM6wlNuThp44P4kpirDxwu0FwKzEy1OdCv4qId9Wtk2oHz5tAnbQQsi5SAnFWMcVR/4umTkJmHRoIWwMME3Vn+V6vXtswuVcT1BoIu17sniRRTdOMN6I4Iegu3Mnv/IRndiOKUj/+7ibVGMs8pJKCeINRgWyDqGU0rkKuynHnSkRqds/1IEQfGw7RK+NBH3XHVml+e96VC4k4AuBTdEcSAWplMHDHFX0elQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39850400004)(396003)(346002)(366004)(136003)(376002)(66556008)(66476007)(66946007)(36756003)(86362001)(66446008)(64756008)(8676002)(2616005)(6486002)(44832011)(478600001)(6506007)(4744005)(186003)(107886003)(6512007)(71200400001)(54906003)(91956017)(4326008)(5660300002)(8936002)(26005)(316002)(76116006)(110136005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?NhjNWjyddYtX2xMG3SJqCHTGZey4L8ovaUW22SgK/nKzzHFJ/hnUZdZyq?=
 =?iso-8859-15?Q?XpumJhwBW5Fud+V64mNRYoUni44J00h0DMY21KMF/h2iJ8ZwvHb7y5LYR?=
 =?iso-8859-15?Q?q2U7x9vqDPGod22u31q/vbxoGiKZvK+r4NwxQDR3FX8xDuR6DCbshO8fl?=
 =?iso-8859-15?Q?1qOxkL1rJuinPBjJFqzgcV45s8hyi3idk5hTGvyktiEjgzv2Y8Zjke1Gu?=
 =?iso-8859-15?Q?wrTD33qHtDu4IvuXlOwsG4lMSAlvyrDo4Kk4hpsvJhxlwl9cyt/awkHcf?=
 =?iso-8859-15?Q?Avu/GRAl2xmhbJ3rdMXuOvAhpwUKdvjZYwa8rgwk6N5VwDtensvt6HCWF?=
 =?iso-8859-15?Q?q+UNmwFqilvKvh0lXnXUoUprrQL1QHz5nMp1DARfyonkGX8Gna/pAPH+Y?=
 =?iso-8859-15?Q?UP/ZE8G4KH62GI0U95b2VVuU1lzvOht6TOdc6h4j9EAja09Bme7c5pXia?=
 =?iso-8859-15?Q?XWpdbYtLY3dlT5pp/+dwZpSqfBcu5JGvinUJTKjw8q8farohyyEj1Dfw7?=
 =?iso-8859-15?Q?gsB+80R8Rh79Bbb6MaEI7Cw6NSAl4w2StnAJxtZujgv4s6S1o06KfbS69?=
 =?iso-8859-15?Q?b96/YJs9nHRWgK4LdrcfNioFm7CnFsFVYEj/2Dtvpi3msj6MNyMKGhe+1?=
 =?iso-8859-15?Q?RWwARib1Kj4B4DNLANwXPAs+lclMSE7/RlvCSe7bediMr+mUF65tIX7WV?=
 =?iso-8859-15?Q?THem+9W7TrAg3fIqWvoDqNV1n74Ik/1YuWVKYlRqeiVtHLF9gc7GCIcPG?=
 =?iso-8859-15?Q?s2M1IQ7lgM7Wa+fdlKYlcJkuiO+s/fnFkEmFq2PCHcdqDjptQvnl1L23T?=
 =?iso-8859-15?Q?BF6MLSHu/47EBbQ1XjHbU4QlkOp81EoXZ9BV5Gknho8+jEVrPpfryzXmH?=
 =?iso-8859-15?Q?QItqwMHrNlxgVU2S5JLxpTt+u8xYM+o5j2Z9c0anFUQ1hnXEtSAb9QN8C?=
 =?iso-8859-15?Q?f1hB2G57OqUeRhU4eJ7AsXIYYZSb+sAla88MLYt92xRE/xUmj2zQFJARw?=
 =?iso-8859-15?Q?DDO667XGp1OtsmmoVbYwvHrshjZd3SqC0Xm/QODdB2vEMP2uKmSOlqePp?=
 =?iso-8859-15?Q?OIRPR8WjpUWndAbATyMY5bLRcn34ibHpjCUfqhk8bMYCFIpqNAwilDHWu?=
 =?iso-8859-15?Q?4/676?=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <D86E05EA52DEBE4385311218FC186ED5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fe24e5f-b7cf-4607-6432-08d8c1fd554a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2021 13:21:47.3711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WfcntOC3MHmJuggnGhh/loXIl3mJ/9o5lBuJGhOVHBbKr++K1XXeoblcimg2AWkuOG8yZr9Nd/0fX/UFTuh+KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7206
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-26 at 14:02 +0100, Hannes Reinecke wrote:
> When a command is return with DID_TRANSPORT_DISRUPTED we should
> be looking at the REQ_FAILFAST_TRANSPORT flag and do not retry
> the command if set.
> Otherwise multipath will be requeuing a command on the failed
> path and not fail it over to one of the working paths.
>=20
> Cc: Martin Wilck <martin.wilck@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>


--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer


