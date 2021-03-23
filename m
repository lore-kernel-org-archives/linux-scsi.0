Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D88FC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 18:07:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0184E619C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 18:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbhCWSHa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 14:07:30 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:35441 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231378AbhCWSHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Mar 2021 14:07:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1616522842; x=1648058842;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=5KidL5f9TUCxRgEB2N3/DSH3EFfJ4o2x55MK72QJhu0=;
  b=EYR8KRfIeuUhC+G2/+6TQ8MKzhg6f8Brm4Hrli5pp5XiMDnz8Mmcbobt
   R78xIbDpbpAQHxML5fJv3aqpf8pvc2DHb2eKQJIY2QV6VaYkgRq5LNS2E
   J3MLF67gpy21P9vh5LaJ1Wjg1XAOUI77dypMptGEWAKWB2Pg3/C6bBCid
   UJSzgOJ+iyhxPMIeLgHWw8GHClJq131+FuHjRYOpi1rgdyMx8S4glAzWP
   Qyq0G24P36mlf2dxpFznXJw6/r0hPUbCnunvx7PXiHVh5IIPLAKLGRlhi
   I5HKWw8TJ+qddJWONKcg0UCpt5W4pOFUKrjgCnZPRU0HPemhaNLDktWWo
   g==;
IronPort-SDR: WS8bLUhDbCROJKBZSco1rZWW3j46z35Uh3Xnr7GCdZzjkfuBX1HNGG8nsnDF5p8+yBOANxmTI0
 Fht6gqk1TbrqPmCqLRhP/mEnQLGuCV4VyuP9jE3XDiJ/XztPmQUiZx9MeEagjOaGIthsKA/hVV
 8CaLb1nHfQK9U8MBtKt/rTBBybwklbJua9SvtUj9pcIWkLLgAE4i6jFPmz/D0dQqu9341qEFGz
 OmPS+EDj8uj+zKU1utQ80zUqzFZOBXwb3oQCenEPoHJvwYITUQ57eBELmmglcDlbRPYU6ipLmR
 yCw=
X-IronPort-AV: E=Sophos;i="5.81,272,1610380800"; 
   d="scan'208";a="162771221"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 24 Mar 2021 02:07:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fw4KIUFa/kIt+lKgTa4XCzn6O5zoc+R5QifmULwShJkpgCaEtsBUk5/9BiOhxxgkGOzhKYvvR7Tzi18KT1OXKgd1h5jnHqrkPSTXMlhi+/+hWSMA1urASz3zt4e4DuBUeqzRstQYCEKLXUms5Ivt+DZxvegGUMGeBLm79QrcxmK5jv0aP68zuQ3LX5J72uVTa2zFskuo57DD7hijDYPhC6XSgCY6aGAf+7HB5FoMmhb9KGE3S+7UFx3pIbjAofzkr3TLnCGNzzZlHmAJ2eLqLxm6qLCyNPL5raXO00/efNOvvqVrEiK3psYSFYxXRIf4vO77NOwvLJAujKPcB5t9ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KidL5f9TUCxRgEB2N3/DSH3EFfJ4o2x55MK72QJhu0=;
 b=hsPl8eIYMaiy4Di42F0wfR+/ale5VnL04HVbcghAqCHGXYNZp7uXfrgZL9nY3VNkEHRNq14hbhAeIcK2ACSImJtU2hG/OqgAd+ntoYFFnKmZ15ZQyD7P2IdmhrEoaY9NBdRl7VXcpjv6DkN53P3A1H2q4SZkatXddl5SN5jPgvvuz5SdanF7vZWEtRSjMFmD8lp7IAhD5yjcY8E8vVvfdU5U8A5KBaEBuDaJfVRqSVQ4k6cZDwIMPfQP7UYgZ3jilRTedoP1pNbCteyJe6sWaBEteX9mPRxt81mmCcA1bIcDiA+5si/P59cRRfj+lrBHAyX9ueyIPipRcEjE7PuZuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KidL5f9TUCxRgEB2N3/DSH3EFfJ4o2x55MK72QJhu0=;
 b=JgTdNLSQ/0QTMcmi/AfwyUEHwYyr36Qspm66qMpKx0NoSST6GxwdbvwCOM9RdSdELdunmF2moNbbztwgftkfSFMH+6BKGX4yz0TQCPXt+f7yaAAGHIzYbF2ys/ViEe6vvAhb+AxMMRZpvGKGqh2gMPLl91Lue8jkH/e2DJucLgg=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by SJ0PR04MB7662.namprd04.prod.outlook.com (2603:10b6:a03:325::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Tue, 23 Mar
 2021 18:07:19 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::c897:a1f8:197a:706b%5]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 18:07:19 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "mwilck@suse.com" <mwilck@suse.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        David Disseldorp <ddiss@suse.com>,
        =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>
Subject: Re: [PATCH] target: pscsi: avoid OOM in pscsi_map_sg()
Thread-Topic: [PATCH] target: pscsi: avoid OOM in pscsi_map_sg()
Thread-Index: AQHXIADQ9AUBq2tQrUa5SFdtPvna+Q==
Date:   Tue, 23 Mar 2021 18:07:19 +0000
Message-ID: <BYAPR04MB4965DC898570F11C1B4CF06D86649@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210323162203.30942-1-mwilck@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 07e9eb21-f9bc-405e-fa6a-08d8ee268017
x-ms-traffictypediagnostic: SJ0PR04MB7662:
x-microsoft-antispam-prvs: <SJ0PR04MB76629E0CD5939D4FA8D7093986649@SJ0PR04MB7662.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:635;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: moxmoy1VYTMb801PURkV5gDucMH8iUPhYAUHTTQ/ZS90uXAVvx5r25aCsFq+N4ZjTgQ9sNoqvt2g0L3K8uG3/h+6XK1jmYxrEzhjoAT59wCe/+zUg4cauJ2SghlCmo7eko7dB8/ZZ7F3UiNF3rDdiAqJ8tXrSfhYEREoAK3FowIrDFo93OdKhIQKu2+RY0h4usA0IIGID3AM2jvwRxIs9h74VrrYb+mZVPzGzrf26umy208NteuEHMZwdiszR64ijqjCoP/IUaZFuOW9zJ07ud4JA9JA9QeXf9wcNu3tBrOE0mJ8Nh26g0to4OTwtjf4YxO9PLeguSp4v3KqgjH33TRxHs7iyfURfmTW+E5DSIRztW7cm7fu7NAi6jahKdI9EaLw+R1Ekd3F7JrNxiandShY9zQKmCCMwbaaTI69ze9/9RNyl4kkng6uUYhG/RVE+qlnsvBGvmSbBwC/rWfLuiwdf3M61YtoOypthog2g1KfqC+yNnpPJmojRtiZ+Q5C24j6j79j+MrDRtzLQZpCencr6on8ynsWztPkrKZJZ0e+J3N+HwHDH+iD+ffcsq132J09lq1tzO13JpZo17Vp31D3bNkUCiClDKTE7j7bf9ByqtcrTqwPt8CQnYlEde5fKt3s11nfKzRAvs+CLH/GVmGmkt3c4tDHKK8Xf5NKkrU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(136003)(396003)(376002)(54906003)(8936002)(91956017)(52536014)(6916009)(38100700001)(76116006)(86362001)(478600001)(55016002)(5660300002)(64756008)(66446008)(316002)(71200400001)(83380400001)(66556008)(66946007)(186003)(2906002)(33656002)(66476007)(9686003)(53546011)(6506007)(26005)(8676002)(4744005)(7696005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?uXs+LWAGfWk9sLKzMjqGQilvoD27xYl8X9HFqgioA9uS/G7L1E4SeVDyYL?=
 =?iso-8859-1?Q?t2AAFoZfdckxvQ6kdsWc1VtMPqyldxUiiHi9Vc7TdSBeaoBPKG66TlpuPP?=
 =?iso-8859-1?Q?6ULMTBavgQFKFJ/B0hTH2j9Md9JvFR++PjDI1SHkWj3XvEsns29zUKpE3w?=
 =?iso-8859-1?Q?5zAcWKOYGDzv+tzwqrepSKuvwlpc/NzAE+UXFZwdXQPDzuQi2/Q+T1ritK?=
 =?iso-8859-1?Q?/cFPJVSLRR/kJW0LcholO+9jvcLLtSSDPkI4m4fbtPAenxqwYibJmzrfSR?=
 =?iso-8859-1?Q?tLR8mYrj0amGeAYQvGjFIiC9eEDDDjZXsosJGf+WhmTEfXcgxNPHz7UP5R?=
 =?iso-8859-1?Q?J8EfA4yAToMHIKeWLCrQg9YHtMQ+yAm+Dcf+69jrSF/Jzw0pW//sGoXL6a?=
 =?iso-8859-1?Q?aLYXUT7Q2gnm2mLlX+B8Jpzze/X+My0HO5Kma7BbVmBbjjORxdhAhficcz?=
 =?iso-8859-1?Q?5OQ+ze4/H394VlyJ/91hgbGdPlpVoU5toWFwMuGenkU7+QVGCBMKRDdPZU?=
 =?iso-8859-1?Q?0n+UTBJWLP5BQaQtx+yqvkGTceRfdIlMPUB2MpS1B1TG32ubttH7fo/kCf?=
 =?iso-8859-1?Q?m6Lv5L8pETm8ofkoDcBWvoRULRzWRic+cXKATOgmIhshVvrjAurXk37bo7?=
 =?iso-8859-1?Q?DCyNDLesYKesjw4HJzZwIVX8sfgxqyrMk9m6C7UE1ST2Hoek8RV/IlyzQ7?=
 =?iso-8859-1?Q?CPTmToLAWEomz4yovgGVr/VlBoBlfy3PMWgSiAiXmy2MIMKHdydaSuqVRe?=
 =?iso-8859-1?Q?E0Fd9tFTOAUPrFFKfZnojiRCo42a5THWVAanbWG7TgDHbbg876mTGhZAUu?=
 =?iso-8859-1?Q?houwraz9pfU7aYm414jzTwQWLoHh6FyZ8UZwGImKIkpV18MYZWj1w5WZ4O?=
 =?iso-8859-1?Q?hHDjuoNM8HTIvWWeo2DgQYTgyWNj27E+e/GIBjPn3fmeReqiIWrlkBsWNy?=
 =?iso-8859-1?Q?e+DDTj5g2ssB7KSNzqDktQNTY9B/Sb9xSaHy7xL+cMPlvHITHBYUI98O4R?=
 =?iso-8859-1?Q?eSo8sQBc9Z8J4+m2pvEoNPJzUeGeg3UbkuVyUVA46TiNv98P058Vm36Mpn?=
 =?iso-8859-1?Q?DITSTCXHqAUb7pt/aMgvP+TCxMhdH1Bhrl4p9zYseXZvQ6EKC4JeONKplV?=
 =?iso-8859-1?Q?2xZKS1I/4uTssJDaBDLzanQ/s5qRqXL+TG/gByNIpdvCpaqnHEWBZxjJqz?=
 =?iso-8859-1?Q?6dySAChlkMW4FEEaevMyIM6zWjfIV1FN7jFeR4ID89YHe2xrnbfk1weghu?=
 =?iso-8859-1?Q?TMgsWozrhlOBII4xVg00BENl9mhFv54AzuCWSyMd56op4hBTxZUBxoW+Ia?=
 =?iso-8859-1?Q?gb8nYjU1bKkMQzVMgcRM0lXFJT0+4PhdYoFbvu2++AHgQPDwcWSbqvClmt?=
 =?iso-8859-1?Q?Rvy15y96G2?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e9eb21-f9bc-405e-fa6a-08d8ee268017
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2021 18:07:19.7138
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B402/Y95o2pVscmFY4I53Vego1JQ88jGuS/kHcd7forEboAqSYVBzxlF/wxZnIGZRCqh0mz7i7Tyugh2YUHF3fFx0pdsZqkTDbiCSDKHm9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7662
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,=0A=
=0A=
On 3/23/21 09:23, mwilck@suse.com wrote:=0A=
> From: Martin Wilck <mwilck@suse.com>=0A=
>=0A=
> pscsi_map_sg() uses the variable nr_pages as a hint for bio_kmalloc()=0A=
> how many vector elements to allocate. If nr_pages is < BIO_MAX_PAGES,=0A=
> it will be reset to 0 after successful allocation of the bio.=0A=
=0A=
I think BIO_MAX_PAGES is replaced by BIO_MAX_VECS with=0A=
commit a8affc03a9b3 ("block: rename BIO_MAX_PAGES to BIO_MAX_VECS").=0A=
=0A=
=0A=
