Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF14C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F388164E66
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 12:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235239AbhCAM7Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 07:59:16 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:25489 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235192AbhCAM7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 07:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1614603549; x=1646139549;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=lGxZP7Smi4bcSTPo3PsQOlSWfGEyRifzLNUFdNAf96+4urPBEml1SuGI
   gTubQWIojrk+1dikm/1+ARjLTTbOus+dV7qRRNJBKiZwXZ1zIcON1OPnS
   /ml8RjfWxjjggWAMvKGHuWpcOpPX6tcnFwkkdLjhBEEvVUdz75eqrpqyr
   A6YDobmrnvx26qh1yIYlEY9V4uvHN3nFcgDY8geMAogGZNVyTw1a/KqNm
   /eQoB/nlS6/gdMH77AP0fkZ9PRA6edOjjjpH0S/hTX9wmFs24BE1T6r4G
   00p+eJxzvBnpLr2mFjK/y+vStTNnSmYwJDCOIEGxWIwPRJyc+QeZK/i1Q
   Q==;
IronPort-SDR: YNknorh455Rfr1x/TC2s3plJT95HAm63Ywnqh2ee0Zv7h2OeBZ4mdod0/RzX24rT6CJ21j5j2R
 Pu4S+Hdvl1r66aUoaWOSC/wxSmd4iYXpfat8znSohuhiMwCdlpcwpx+5/rzq7BIzyH1m3VIde0
 4+FKbDGUROqL9vKuqU8pbGYntxJtXqpXLSge/dybLzMrClJhMCrInowBq7SOSOWtYlLza7gSmM
 k0l/eus6IG+7qd/AuF4s6diy3sZLHN7b6Emzrc7JfKbtHiK5m3tLR9/rBphngLNtJNx9SmEzVv
 TFg=
X-IronPort-AV: E=Sophos;i="5.81,215,1610380800"; 
   d="scan'208";a="271660455"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2021 20:58:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgljXzRQLmltHWzu5Z1+qhl99jwX6psNj+HXqTSeFMloOJmQusi8bebNCeICFrYJ/CewYImnsKCtvpowsQMJFG0K8UXlujkqJknlwWH1xjPv/fDVYtndPLA+Ut9ljEO5GxoHdpJejj0PTa2E4E/z4CwoTBVWCj51rh0USmev8UexKJ2CwjBe+6D7ti9tAxwIdHb6QkMuZfzOp4kfp18qww07CFmD7zOLOcafW4QbiYDYupWpuRQjcj3lrPLo0+jaD/yDEGKJox/xa2B+xGzJM1MUmDbxtpaNjsF1Ney5eDw8MAmd2Dyrx4xVUFRDcqRkPxROoUdo8Khs2N7YT/dM+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=ngpL/LlUk5JOl5eWKLdNGSiyhZlCwQLxk4ihzizn+CT5efSSCPwx9Jxwt0+6JWbVzvEG2NK0zN1+euGurqvpWal/NCeFWftmUg3se/wUOUh+jNEp3tAM/6aOlSV0+vkeTwC9sqVoMdmjnnb9s3wDtGCNSp2s2llxJxeSZbPmaqtGFJl5KLONm0bU8J8aynlCvTV26RDIye1YqIXFk3HD4kkGM8A7uleEbYyAdORxZBPbkrspWrDaiXPlV30yY/Pl2P1XCq/o6klUCFo0td6ejB5PWRR23wm1iD+3cUP6fI+IcuaUS+tXOKfa8IHNSI0EdWOStYUlrYmENkZfZO5PXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=v9qBESqdcxJtcYy3quMX0yzyPTSESOPoUWPTb+svPr84/cNZglxCaipDJKANuhmGqURUS5u6a4wAunQKLDXbLGOx2vVI6bjpMfqFX2gK0ClwTKGHGBOovIyvO2cieFzijfLn/2p153wQzSyjrb89PneK0uXEdbA0f0aLmBpZYdo=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by PH0PR04MB7237.namprd04.prod.outlook.com (2603:10b6:510:a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 12:58:00 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::3c7d:5381:1232:e725%7]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 12:58:00 +0000
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
Subject: Re: [PATCH 09/23] target/stat: remove unsed macro
Thread-Topic: [PATCH 09/23] target/stat: remove unsed macro
Thread-Index: AQHXDZbp32WWyx6t5EK1INOGllyRmg==
Date:   Mon, 1 Mar 2021 12:58:00 +0000
Message-ID: <PH0PR04MB74161872A27CE609B1F593099B9A9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210228055645.22253-1-chaitanya.kulkarni@wdc.com>
 <20210228055645.22253-10-chaitanya.kulkarni@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8981346-c0d5-4608-8a69-08d8dcb1a501
x-ms-traffictypediagnostic: PH0PR04MB7237:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7237361717AA28660BFA26D89B9A9@PH0PR04MB7237.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uXn23dqSWuy88Q0Zi1nlwEy88ZSwCYbEtyBbyF8E971KeCAIEPG1P/a957mhmsPyDUjorJ9VuDJh0emx3OOYc/uw4bDqzgFvG2xFVMXcT2HiUa4ui6OLG16EMyFmicSk/zmDSp+DfCqG/NSy4M2BDK2PWF3yZQzKVeA4GZAmtYz4RF79JeXscdzRh3qoNTpX2fjUfHL0ufKmDzfuauzXTc2EYbsaqXYLXWK6xwG3q88xZlocyChi6TWxq6TFcmxdhdOqNgA+KoeqI0b9Ib8xingcPLGcUC4XralmE56+eRVbls7srKEujPDuIXNNVF4Rj25nwlGR0ohxwdWEQdDvSNJxHGw+i2ecKNkUf+f8tsiK8MJEgFojbtGx0JSzyq993vTayO9r+quZ7kUYOVUqULFVK/qt+85yhtTrICmsFq/9LHNLWvH1314qA09queb1Qqf2UOuTy/6QlKJBw4pesDi7i+AnGfEI4JBjcJdMOMRMJckXVbgBG87x0qpbSSg4UMl8cp7cHwFeBeKyC+ZaDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(4270600006)(71200400001)(7696005)(54906003)(478600001)(26005)(558084003)(186003)(316002)(110136005)(19618925003)(4326008)(52536014)(33656002)(5660300002)(66476007)(66556008)(76116006)(66446008)(8676002)(8936002)(66946007)(55016002)(86362001)(91956017)(9686003)(6506007)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?e9TVEBXyU+tSSF9N1LO8JdsmKr8uEpA0qlRq4OU/E23BfAEFtvileLVii4jC?=
 =?us-ascii?Q?g2mFEs9czS45BjITJh+Cg4ik7ku3cQ35jRXjMtPb+6ZyFAWNu0VMExr25RTd?=
 =?us-ascii?Q?4WMb0bWHNDVNBkte9UOqBDkyR9Ra9dx6moY+5VKHHcnWXfmZxulJ9hXP6gYR?=
 =?us-ascii?Q?1JcuBRF5pR7XSimoCNSJgWcy5RsYTtZFZPqYmEIi/C/+jzV1DndcZ8JbyevY?=
 =?us-ascii?Q?3nI8JTK+gBDGMINGaZoEk/GcD1lhrVplLPCWdoEoriADrjzbOuWCt3wKVn5l?=
 =?us-ascii?Q?haaOIEPB1r7ASys4h1kigAYgcOnd3EfUJ8XQrviXYGA/WOi6u35GIIheF/94?=
 =?us-ascii?Q?3rSYD2k6RjhGhSuVGlFg+aJ5zHHdFgCMg6qmYj+Lu4OxjdMjrKMB2wWfebG2?=
 =?us-ascii?Q?k9jKNeYlChoJ0bSumg1C+XxZPwgUHIPsDyrh39jYtzKa3aHxdHfuocgvm4uR?=
 =?us-ascii?Q?lpxEycbOXs86dh43++XdShMjl6fkrJHp9HesWfXYm+NMp7xIPnSU2MYbcfag?=
 =?us-ascii?Q?WwKtNLpv7yWT6/DwwXiZormbHya90rBfKUc+C+oicKv7YufMSQ2m0NCcSUro?=
 =?us-ascii?Q?IolvWVGo+N2EovCW//braTMM8ZZzBuOPNR8jeKUFMuwnpcWHJPKV8cJbKbqA?=
 =?us-ascii?Q?PJRRIs5FvaOOkM7NdzAGrvPu55fsEEFsdXEvow6IpyZIFvhufp204HkxCWJt?=
 =?us-ascii?Q?iIRb2pewe9/MN5h2hJU+PLYc6xleVA5zSEDPrBbTep+KTeWmIs9YVEOlPgPh?=
 =?us-ascii?Q?ryoVI+eO64MhLebFnkrvgX8v7ExKtRV8ukZmmp42rLbPviN6bQYIyB/jlmir?=
 =?us-ascii?Q?3OCoPBH21iF4OLvXaTK+kuL+oa3uIcVuAq+4vsz77YGNaO71uwjtVn0bcZW6?=
 =?us-ascii?Q?WBcjIbDQlRgKZgAdhq+z2jb9Xa4R4iIVjbSuz6JZ/E8Tq+o7ORho8BPSdmOu?=
 =?us-ascii?Q?aV0o14Hy1TWjmhc1wJ/96QGCmzKBGTigjDs5Snfxy9WLY9n2JMri0FgIRAu9?=
 =?us-ascii?Q?hqa7RDGmdefKRMZnYdEeq5dHCpfzz2tJGxBqAnIf7syb6RUFcHRRboop9y6E?=
 =?us-ascii?Q?chGRFWJUDOW9F7kRssk6gTdxOMsdzIIeYfaFMNwsizISI3fUExkx0iPSynl+?=
 =?us-ascii?Q?ZpPLFoo0APftI6TvPbCMUBUo87mGVf62an1w5Xv8h99HPZSgU3JgIOQ7Gsjj?=
 =?us-ascii?Q?2PMwyGsA5soGXiJeRrqsSxAbYDyNNfFIPQ54/5/mK55Rm14XjlBV0ciQ3iOd?=
 =?us-ascii?Q?VziHR7tm5C/7OgLBWQTRdvDjIxigB27wM7EV79VDBkzdZGKuQBHnYBZDRZrI?=
 =?us-ascii?Q?8sFsw7hdRcez/H5M8dTp8KsaSniK/V/tP6bV2CUo2blfJQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8981346-c0d5-4608-8a69-08d8dcb1a501
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 12:58:00.7035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WCyd9cGIxe12ZZ1p6QH9flLEQspcTAeops7pqQ5cuFLd+i6MTRVwURUnS40t7DJ/3pvPg1Sj6qSqI/XbwnUwUERzdM8mkKnsYBuHExJCQkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7237
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
