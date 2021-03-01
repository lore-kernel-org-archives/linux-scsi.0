Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8906BC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AFDC64E40
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbhCAM6k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:58:40 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:48451 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235249AbhCAM6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603518; x=1646139518;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=j2XezYdIFQ4Y2JFLHRjtgz4a9Mac0iOoYbBY9pvDHjotUolXDoYdCRL4
   iBf2yCVbuzkY1sGfn9iWnhlC6KVeQzxw5DpyOVdy2rCNjZvhueaEZ25hb
   653GgSclJR0KvgHF6lTqs+B6Y2dTseBPB9HZ3mevyYsgkRe/TlgA4jCCy
   6HvgJmw/cooZPfKFa1aJ/llmszFOv3vjxbDFQck3ylayT0tOzP+phmX2y
   ujsTa+GQfkfh02K/Cvd1YQZKxmfqPW7NI5HX8STDTN4odFI230DEh1LUV
   tdaBhQRRsBlxsILeufeEQfRMRKkvyHMftzjcbnL/iBs8oKC8jomwZFSqM
   w==;
IronPort-SDR: R4kSPDLjbiiB8uSphO5u1KnEUF7ckX93PSaO7nkOOMGSCsbKOHusEFGsSwwjrHHCtQO4L7vLNe
 efsALzs17PWvZaZBRXTCh5fYIB7a/vR3cfGGJxOKEMZFENe8UUlJ0SpaEEl0GYBPydGAOc1Pjb
 N4GTt3okTHRLeRTGNTgx6e7Xayl9eGsjSOP//Q4eOvPEBNVt8dQ6Fu4jpBicj1N6J6BYn5WcBt
 f0OWUgMV2EOrYz67Q3JMFtDldM/dIXgAWJ5Ka4OkM9KZU5hkngY5GDuLGzMBCJIIny6stafd85
 uS0=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="161052564"
Received: from mail-sn1nam02lp2056.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.56])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:57:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h38coS1c4BjNd2wNi8Eg/n+U3csKquKYD/q9ZrfnO2lefAaZX/SiG/F2Dwkfd58V5w7QaDAj3iDVuR42lsx35oHVPIZgOt3MPoFOgI0cYXjYDGhhSyOYz+aWsSKDcoMizjo2lXgkwpzAeFVZB9n7uvv3PlV2eod/1BkupaETHkZ0DKJocdciWGFhKHZGYiuE90MZ0aSTNza/BzicKhBMfwTT+vtxX0+emflR6Xs26Vo+wDFVh2+wr3d5zsQQS4zLTXtmSbbqq0kTEX2BizDXtuLtzwLzp3BfCJDfiDT1ftVfa5Mw5K7siOaoKAU6JBUjIAgBRD4kFTlqK9dD0shN8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=iQYsr9y/buVC//YFJ9KF630COoNN0vplAsyiTEfQrkLb6pqEuqc9tjBHmljexF727to0lb/846R1QIxXOlwj5qW4aZmZArTTm0b4GCPazymua0HYyI1wuiaGVJYIyY+cE4co6oFt0TSYkAk/REY+LqwcBs6v2gr+Ka8rpcCnIQJhY459SPK+GUvb4xn6Pfx/J4B6clyv8tbQ4VI6IZBRl9ensr3QK0deVNhOiEi70f8TzX+DkJy/SyQgpUsTwaPVdUH2L9XDhivmFVNgVUXwlEeXXBo7Sz2iEv7B1EM61ZrSROFoIBV+9R7KIQUTfeIe9hLc0e28ILqVJsqkqVLWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=IIdoq9nio1wEptNLMSxWXKkmiL8/nYVJUZKLBjpOeNRA3Pg/h1fgE+OQ2SW2srggLr0IWy572MJar4kUf+yd9tgzCcjyZYzkNP+dQ6FKjNLeNL9LyQQ8xRN3nEKq/pyprIB5gPL5LwdIxmZvOJVt0rOvqWTuM63beo75FZyh1Dk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7192.namprd04.prod.outlook.com (2603:10b6:510:1d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Mon, 1 Mar
 2021 12:57:23 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:57:23 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "hare@suse.de" <hare@suse.de>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "mlombard@redhat.com" <mlombard@redhat.com>,
        "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "houpu@bytedance.com" <houpu@bytedance.com>
Subject: Re: [PATCH 08/23] target/stat: remove unsed macro NONE
Thread-Topic: [PATCH 08/23] target/stat: remove unsed macro NONE
Thread-Index: AQHXDZblpRTFN1/fLEa7crAEZNg1/Q==
Date:   Mon, 1 Mar 2021 12:57:23 +0000
Message-ID: <PH0PR04MB741660A98C715F2269B5A65A9B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-9-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ab00b019-39c2-41ae-6f9c-08d8dcb18ec4
x-ms-traffictypediagnostic: PH0PR04MB7192:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB71924077496BB3F6314BBC879B9A9@PH0PR04MB7192.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+YPAdG8R5DNx3qIk24d8+8rGcjUfRvqAQmn2/t5erKZ7pP8wM89swh8JG5LyNrG2WPgeimc91z7u6UrG41KZBVNjyxi428f7ALxCi12ws1VoIkfCpU0l875COhzWmWsXp2v8QsYkkWVGt468arV/27ChG2fcKfASMSbSlCYBvyssVdk4jY63SfhDPcyoIF14zBKVp3fGLkjkYcS2RZOsWZVG00B+dtjLpVtLEvRgGdH3HJIHNeZnWb5oZpffmXbl5YvU56tYhYAcRut9m9v34msADP1Of8PFg3PjJcfrImdWwZKLEV6YSAb7qnOebNOuiUAF1239rGfTTo2kObTKzw/+0qWh/XHsC7jkf4gUTtjIr9yBwCPP1t54lnYGhjn6HR9kTpRzYXq06YYn4CFSYfsRzCQ0ic9ksVOyspnK886c51lUq2I+1S//OX77Fd3jjcaH6ZxsxqSaWXVeXBNuhYapRb/e3M6ELC5q2/N/iGaWBOaYuM41Zfp/G4wb5qUt2LXvc8O3kF7Iz02cKC3Iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(39860400002)(396003)(66946007)(54906003)(110136005)(66446008)(76116006)(64756008)(33656002)(66556008)(4270600006)(91956017)(316002)(55016002)(8676002)(66476007)(9686003)(5660300002)(26005)(86362001)(8936002)(478600001)(52536014)(4326008)(558084003)(71200400001)(2906002)(19618925003)(6506007)(7696005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?XHl8GlS+5pjEnnq8F8V7m3KMJ4NVG97OzYcPyPoPjf7rouE18OqmramHRa8y?=
 =?us-ascii?Q?SOhZfc0/QIYEE32Sk78+wNFmumSY3DaLfWqR/LchNtU3BMiRDeBgHgJ8gSGm?=
 =?us-ascii?Q?PLhTzeC2q/r4jVyi474qjJYnCufdeE9nYAVNHk3HzWLrdJsj9gabT/2o5XB7?=
 =?us-ascii?Q?KJOS2TWQqcYVpXDwJG5PmMyrF6lTuAmCoBEhJfiMz0wXDllDaViCyBqsJTZh?=
 =?us-ascii?Q?t13qCXy4eYDTE80NGcvz1yZtbMz7yTXyUZAb0L/HtsX7PANTVCmDq/bHSIsC?=
 =?us-ascii?Q?apgXVOZFsL9P1ZMfWEgRLyMdTNPiHX/EKoMvU3dNW55tluMZeCPYTM9kePL7?=
 =?us-ascii?Q?ASAdFxP7QktQRl5PhM4VWBCwLp1JXrgt2pw3qaArcUQnV8Vro7NgPvLnBsxG?=
 =?us-ascii?Q?Zv59KDCPOdOLNAeY9yH6jpaqZzUNS5miL17tP3mzNlNB5o8NvA5KbocFcByn?=
 =?us-ascii?Q?0xXDUtv4W7FMXviI/4waQo5MVRmMRRLFfVNSXVDDv/I9O01K8rF7OUhQChxS?=
 =?us-ascii?Q?MjzGFuoHLZB0bkgjBYWBLgekabIa2GD28OLGjREHJ/JM6bVuSmwKRhEqqt5h?=
 =?us-ascii?Q?a4UajXjD3yKCLV4BnAju01dV78fn0i7hHyP37T5PqJJi7mslX7Kj8c65ueXi?=
 =?us-ascii?Q?rJ+RN29+2t/Jf0L1TiuHQ6Of4hZv+IyZpqV6KT3gpRDE5GTUWdhgvdwyvrkk?=
 =?us-ascii?Q?nHCE5JadJSotpeEC4vPXs+qdC+dftDthexUNAkT/uwB/I83nU3tkrkyThbfK?=
 =?us-ascii?Q?a34XReW4Ut8Y+OloCl2zlUYg+9OlVggrWpG7EqcmhW/5vkHtpL/rEVdd9RRF?=
 =?us-ascii?Q?YuSK4o/6qoIJE6wJmeN5bPb61ayGwdwIWbpdZj1Er3gOFohNGwVH/0j0SzVc?=
 =?us-ascii?Q?w7LJaL3t5wYjrIy0+uxVs6iF70kgFQiERNf4B9NbzZve+5iqW4a3Hij+ckES?=
 =?us-ascii?Q?CqtFrpIA2LTSXMFIuZGBugB6Ds9cmebn52bg4tjoq+UoQdFfwOk7ZFU0QFBA?=
 =?us-ascii?Q?Pvq1AKTzQ/ZTQzPnc5+s5YRnDscJLFcOBSlg2gbQldcbl1vl06J4DGDte6KZ?=
 =?us-ascii?Q?/aqXLSuZoru8RB2dhZu1UM8Y/YkNLIipNYN/ovCu53n2D3CG7mNrU1hUiafU?=
 =?us-ascii?Q?05uhgVO+tXYfTRfZRsZd72tsNCenevl+nyTplekyFSz6IZ5QgYHDaKMh5Rp7?=
 =?us-ascii?Q?Ei9ChaMFJdjerBA8m8n9amgDihdIFI8E44Ricc//SN4vO/053iZcFTTd9V7w?=
 =?us-ascii?Q?RLWAn8gDPne9r7sdckMf656hjGTjaS7tCdCyUi/DvkawuIfmg/ObGFVhZHEU?=
 =?us-ascii?Q?dqzgI1WV+7EA27NPZHn1CLeSzKtv9VEjPL8Jzm89BbLzJg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab00b019-39c2-41ae-6f9c-08d8dcb18ec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:57:23.3882
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: npWjLbMQVPCB3GtL5YTjV9Eo/MMedHxYKrG/VYUOb0480kjgLDyvVUJZWR5aeAPlLNssw2RjfYj1bcuE00eLQ3wMlwppxBmu4azhU2u9QMs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7192
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
