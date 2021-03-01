Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CDEC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE8E564DA1
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 13:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhCANDf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 08:03:35 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9958 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235384AbhCAND0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 08:03:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614604433; x=1646140433;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=RX4egLeS4JcWPIKOU/EARDGusp6F9M63PXJKq1QHtK7u3VZ6gyaEvkc8
   orIxEsYC15bWJMnrvYREOzlIoZw4jod03yjU3urWQ0C9VM9nuZSDecoX5
   EsylFCaBLDT/iEQXxPfXUKeOsMEiJuna2HiNhQ3p6AB+IJAZWd8GHuYHg
   eF22W8XBSxbIh1fsjK/FXGvkTLNxpfYAmxoy14NlAbdLvN7N9Y0p2k2TT
   ZbbnTXjwGUv30zqvog+qKDfntgGonfy1xK27iVYyUDhzDKd6WWwdzXa8k
   ohTMZao6r/iay2IaEZgHgNBiSuSGBTFvs/ShXJa9Kyzg1y+XhI7hVw4/o
   Q==;
IronPort-SDR: jRbsICe9kzaMMnLLwLrDv5WevHklXLXQ9B2TL1D7Zrn7bfU2/Q6DVFTedhAnGpsrEmVa/kxPwX
 YW8IORElDHW0vaxLxq94n2l9D6S/yxJwekuJNEScxai9silmWdV3/unnyaEukVHrM7NgCzUjUx
 Ln5HHtBSKdZxuri8BR9e1Ckl0Lof/RHKusOQOz4PcmW3ch1agGg29t8b7UcM8YbBrpgDYW3SU2
 R0Ay91UEi3mV+sjNY1ZJqSG7NMx41uqHNzYtOWpN66thIRf1k0ixLZ00NpOYmXkLgbQsKBlJso
 zus=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="265332904"
Received: from mail-bn8nam12lp2171.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.171])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 21:12:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hv8BT4FDvCDZoyyczU1WGNP2QcSmMByThwpppyAiMs/eYd//J3VWo8qJzeM0vh8NuH/qjyj9C3VF9pmyXKiAGKLTyy5lHjN0OXsXf4upVKg12b/YRdPRjoa61DQuJ7Z21U0fgdAbyJ45rslS5WzGmzW0z9HtCaTtHG+XH3UMOn8wp50aRdKmWws7gL4eQi5z9Mol0zFgSAcYGImOOWgSEddap/tcs9K7p84C9pwIC47JuB4gRBdXP7oesjfL9RCeOFo85QU8Z5y+/e2wMpUJu1HmNGgQgVXVNKlv3THPeWDjEuliPT2JdsVODsimLjLQOkopzQIr4RK+g7mNzATlHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=jTtNTXaClYWQZvG7VZTGOP9JOhQNcti2hV4SN3XJnCFnrLn6yzrgwZHVQZxZCSvLYNuGhv0yAXymxisHHVjYVJ7hgF7gpGRkS9HS+C7RLWVQPsosaAW0T1u9tv7j8y9RAYX4emDfLuCu7NeIl7nqi1QN8L/1mZcDZfL0Z/QgpYLKLPI1FekbvE7syDeBMahzEPDpSXdpKoNIKt6z92pkw3O07RaCNylQz5jaBRAQEschnbANAICNCkbNJg4KVvBXECrNJ73QdwJu++QwfBgorGq9nbRQ48toeegyoEmk2X0ZHZSb0YxJb69T+HOFeyHsqYhnnM1T2IjS9rJRLLKf3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=eOtJHAZweJBbtxI0pkjLAyOoLevZeO3RIeiseUvf1ZuB6hpwV5ctf4sM2XCQt2hzUYO6dX5og54wr8HOKnzKOMVGffMorKzT4HlDeExqDJ4SARu5O1UFCydSR2uald17vm/Hdfj9Y9QXuEz8IcaD0q0DjlrXUoQFE+IeEZPQpxs=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7605.namprd04.prod.outlook.com (2603:10b6:510:57::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Mon, 1 Mar
 2021 13:02:18 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 13:02:18 +0000
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
Subject: Re: [PATCH 21/23] target/pr: remove the memset with declare-init
Thread-Topic: [PATCH 21/23] target/pr: remove the memset with declare-init
Thread-Index: AQHXDZdh3XmFz//n0kiBhV/u401gog==
Date:   Mon, 1 Mar 2021 13:02:18 +0000
Message-ID: <PH0PR04MB74160B471CCAB1C3CC6DBE199B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-22-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e1b9a4e6-6793-434a-41a0-08d8dcb23e6e
x-ms-traffictypediagnostic: PH0PR04MB7605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7605BA894256D76243A555699B9A9@PH0PR04MB7605.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IIGypURMFn1HB0o5B14pg8YyJIvXzQ4XR/zfIcNwcor9NKJHlyX0f3da4OKmDjEUFUG6W+1nQ80xAI1QYH+b5yQiSUjkXeJLVouBBWdeSUD3c+HA81zCLxE96IrToWbQz8xW2Go04Sg6CfXjNuY6OEN/1x329Q8fDsg/LiChacQBSDcpOeAzr0hujCd6394y9HfcOGu37YSaWJ6yY2LGfx4wyGcd45tEbSQT3d2tSY6wXOrNuoLuWjqrWP2C08csnLi7VVXld1ZHZ2HON8MlRHtvzFilv5EjLASEDntOOm/cpptbsqpIf8nXvnZh0dnXwT6xKxCveT4xWbiFeun9dcnTpXDOrx0IJS9xxEJktMQsHbV9YdtPbvdiZbqarlPQrsL+86MDGuilaIUlLzvpVWsDxzdsPKqFGfIe3/UCkJFo4iByK/iH41Joo+0QMiZCEVOmYUxUsH264a98Nqrya0Lwciq0l/k3YHrfgDEtoybkbl8JbZBmKSHomzyMAGPsVUh66BvaZde9GqQOWvCYSA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(54906003)(8676002)(110136005)(66476007)(66556008)(66446008)(64756008)(66946007)(8936002)(2906002)(7696005)(71200400001)(4326008)(316002)(478600001)(5660300002)(52536014)(19618925003)(6506007)(86362001)(558084003)(91956017)(186003)(9686003)(55016002)(76116006)(33656002)(26005)(4270600006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+hU/c+PL7u5u2Jo97v6W30ZJ5sc44c1QXRS2lENuA9LcluHpMuEQ+KmD/IZt?=
 =?us-ascii?Q?JfClR7iF4eYWiLdxTZPetO7iTtzgdNhXRoQNncka9xTCFtSWGyYtSD1Jb62p?=
 =?us-ascii?Q?z23/beYXM+VVvl6pmbV76VarwnmKhxOvzRjxOgj8d7VXqpQdiIrluubICo4T?=
 =?us-ascii?Q?9do1N9VxSF+k/j2oXNrB3tE5qLZ3F7jaRcj61KzSrRks0Kk1egyA/OgM5QqK?=
 =?us-ascii?Q?AEA1pa22AslSzFboRczEdPTY9WEqVhbvG6CYwO7kx271Y3k0vADJzUGmJx2Z?=
 =?us-ascii?Q?Cmh4igCsvlI+v1O6X8Pov+RmIdOXTCBW9grnBu9ikSwtCazOLwwV1qvtqsRC?=
 =?us-ascii?Q?gq0E1Cx8sB/iRWQe1vI7C74bPE9O78HaaVYcXo7VFgHz4iuEUSEf2LGGVnWJ?=
 =?us-ascii?Q?QqqQHE/rgAFxUKk4RhQj9uW4bXcj6sGIDE8acaLRjAdGj8N58zp8D3gLcF/T?=
 =?us-ascii?Q?rJc8hi3UxHtC+bm0mm86EdfGx3Ur8BOmoknk3vqllYAzc7rAMz7md5Ov/BXG?=
 =?us-ascii?Q?EHlQY5WCgtKBBQ3s5TM743W1aHLwxeaG9AxW7D78BgcJTj6qBUszql0WGL0+?=
 =?us-ascii?Q?N8MnAw6jYSFgrKU2RuLUfuxaqF8eH4DHwYHIitI4Ka5XDXHu+tqvuRiw46EU?=
 =?us-ascii?Q?bpv3m6fB/42Kmts9XfiNrY7nmx/oRjbgc9iRH80Uf3Z0WzAyhQac7/3kEJd3?=
 =?us-ascii?Q?cMDeRMK4aHL0aWEC6O3NVGu8hp5e6whwephn5wiROZbdJGCDhgY5QKq0Ha0r?=
 =?us-ascii?Q?1Y0j9K1s0O+XbF3A2qo3d7YCfmzYCwQKGpMoU47VKqurPunb/z6Ibx5syek8?=
 =?us-ascii?Q?3z/6bYani6Cop/Dc2O/z7pfk3kZyhoV6Prexyaae3mG4IwO1woOsLg3nCt7B?=
 =?us-ascii?Q?IMx9F+QCth2eIGdvgsV7JVYIaGtx4uV5WcXFflKaO6nkKa15P406SlEGDPgq?=
 =?us-ascii?Q?QOuAAPRZTeaPWR2fpPcJTHVjsSISoJvzv6NBaM5J+2iS0nVSU1PwYcKYE1Wn?=
 =?us-ascii?Q?Lk0NDod2OFJPu930uAfAp1iiSbK6mU2YLrm4f/WgeOjuRnHrLr0CQq/VqWjb?=
 =?us-ascii?Q?vUPC9xdoZuQnVoDbbzf9GwsOl5FOSPYxdzf5ujZoP9tEorIkgZs5otmWyndh?=
 =?us-ascii?Q?DOlemC1WEi8etAlADDptzXeJ012rmlW2vZ9DUIIBd7cYk1LB+JYzaVOFQSbK?=
 =?us-ascii?Q?WtWU+yZ/9umaxRsv1/w4IntMoeiCu9hbt2E51+k0UOGmgpyY5OEi/3s0/y0C?=
 =?us-ascii?Q?u4t7D+/hhSc4IFmHo9GjhVxm4st4C/tvvQkJMSR4+CQCMqrHNuds6fuTkekF?=
 =?us-ascii?Q?qlmr5PHEDs2x87DOyK/iVAqBrcH53IVmBMiN7if1zpeKNg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1b9a4e6-6793-434a-41a0-08d8dcb23e6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 13:02:18.1323
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 22CIIWXATgbZibV9qxWBkFYiYLYblguysBK6Aqu+fDWlhgPdhiJ9HUwkl4t6/je57s7xcmPTGXMFAtgQsJYuUaawGX5Fqgwe4GFbOALyfeM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7605
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
