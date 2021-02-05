Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCABAC433E6
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:52:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F3F764FB1
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 01:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhBEBwM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Feb 2021 20:52:12 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:27108 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbhBEBwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2021 20:52:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1612489929; x=1644025929;
  h=from:to:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ezMCiSOF2v0tZUnWOiD5EgNTF3JolLs0pdpX7NgCfXg=;
  b=PZRhEoLCoDDE3l0P6a2gnjcFZazP8Ef4Lh5FPhgC/lQcn5c7lZ7+Ntge
   kwmAD7rCWEoyVXusJi0k2kEOqcFTL0xllDHSM44xUjXy2U+UWHN2D+zW2
   2zGjCpENCNqHkAmySfdnsVytlyx6bE+0/A5x1+kaMjhGtr6bd22RMSEWB
   yu50O8XgaTHYDzfsmq9Ztn5j2EM+5H2AetvUcnxLuOYKsyhw7D2t+OfsJ
   Z14WszSAK07eV3N/KgTV1pSi7qBL7gsR8jtGmTBOAywCy855PgzSsb7Oa
   NX1AWslbRb2+03pwe7zSDwXPDJ1EnKVpE3n0GN416Vf6ggYd5OH/nhjaO
   w==;
IronPort-SDR: bGmmiHj8EHj4LjjJ/PmwhnDBwXTnPrfZtfcE66Q1zxYsuRU+/67+cvzpn8WUVxOuzJsRCOyQi/
 aQObfx3MdooRr+d4PbgAPYUbygb1mwdCS4nnPJE9B+6w+O84/9RL8F3flO6WGkiGhrqEz4EC/+
 dHlA5fnSW0Kproc49pKmrDnyE1dhVjmR9WNUaBmmHOh8vix8wUVarDgJ31WVhBa1ByZtQLygOs
 G1+DGBvZKvzLAitLBhElI7aAiUI3gA7Kkpl3wDQWAtBkd+FzWi/40loYxqkHJKQ2/Ui+x3Uj9r
 04U=
X-IronPort-AV: E=Sophos;i="5.81,154,1610380800"; 
   d="scan'208";a="159188678"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 05 Feb 2021 09:51:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9wBG12m11IHuDN5hj99axQ0tw6SVEwP30+fjGth4guHJzolGSU3f+531KrBFQbyDV2t7DGoniMqh5oVueD/RZTKZAZW13FwlQ4PKq4ZSecLqOyV/Zb12k6RDgtlhmT6Yythzx6c89shIP98y9Tq3vIb+XGKxhSEKlonBEO17X8pht8vNuperLiS9O3oEA43xpRDbxMveBlK0Opy4GJ6mCWN5963brkvweEHn8uanRMjKPS5XuHa8SdrXkoqpfQt0tLs/Adz6ydK5AecXKVSUO/LsgLDFzQK2cCQxr3GLamtnrQtxGbQKJGDBZtc2rHYaeXV7esr/Txeo/EviGUzfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezMCiSOF2v0tZUnWOiD5EgNTF3JolLs0pdpX7NgCfXg=;
 b=ioXncxaNyD2bjSblOmhGJKdjHUNQqveJgtDFo9m1ksdGBrgXMSH0AHp2mduFZhPUxniUTzJdjK1lkwSXNdLW3BQEGavlW750aXRMYDeuf6FMMx5AVtNdQLmqYET+ahnPSroBtSHdD4UWDLEEqv440av58yC5lOjjpKDx+wstMLHl79XjOAD0YmpRa84EcwxmYcVYz3d4AL8WNfKbValTppJ/JHxjSNaI3pfvFzccJG/sso3si2uLVYuj/LUxImYgrCdh0nA8MUSTZi31bNH2QAV8gxRXV1jcXDl16jxbn+UOg8aAqROHOeMXAhq/GdUEJmuIkDnHAgbO1zhR3xvlZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ezMCiSOF2v0tZUnWOiD5EgNTF3JolLs0pdpX7NgCfXg=;
 b=js4oOPS9ez3XigTz2Sn5eXDzUSic5FqLDE5b1oelt8s3pENCSMpBXmKOZdZ1jUQT1XAvUM0kWrw/gN2FulFsrtBE6kLd5luiczdPoWau0hBTV18ofP/+GC/EAB/TeiTwy50pNjtX817oY/Uzt3IvZqqBMI0lCavEKPubTJbo27k=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB6422.namprd04.prod.outlook.com (2603:10b6:a03:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.23; Fri, 5 Feb
 2021 01:51:00 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::1d83:38d9:143:4c9c%5]) with mapi id 15.20.3805.024; Fri, 5 Feb 2021
 01:51:00 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     "michael.christie@oracle.com" <michael.christie@oracle.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 02/11] target: add workqueue cmd submission helper
Thread-Topic: [PATCH 02/11] target: add workqueue cmd submission helper
Thread-Index: AQHW+uqzo5O8YYXWckq45ttHWy2b0w==
Date:   Fri, 5 Feb 2021 01:50:59 +0000
Message-ID: <BYAPR04MB4965D300DB07BC8F5ACCEA9686B29@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-3-michael.christie@oracle.com>
 <BYAPR04MB4965C9444DFCF8D77E4A9D2286B39@BYAPR04MB4965.namprd04.prod.outlook.com>
 <d1557e9e-e7af-8743-39e9-3cf43688a9a2@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cfb6568c-d716-4b91-c7b5-08d8c9787ce5
x-ms-traffictypediagnostic: BY5PR04MB6422:
x-microsoft-antispam-prvs: <BY5PR04MB6422D21EA9B213E6F575218386B29@BY5PR04MB6422.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: giqvjrSDSXSCLVWVFG+dmn2tjfSZl4p0/YrfAdw3sQcbyabzAuWkAt0cT+kYdaLCj+LNd6un4ZBHZipdNcWvBCUSzYZagsvdn2t9L/EiDEPMDLP9e8BgkMeY6Mz6EaZXLipIxGPF2XGn1tWSGeacvhN493L9p9GLv6DUyBIUVc/tqAQFgRQ0JE7y2kwjcndoM/WXFn4M2XUr1MPf6uYXEJvT/n8PPeOed/chCXtYKkGLz12X9mS4VEEwXRcBNqxGoNz0arML6aqoCjR63CfmAJ7WPykCp/gj/yuAVLP0wvzDmy/E1EAv+Owc/KOI1B+5Kn4zuCTTeB7XXq2343Zm4uh4wEGNWEKeIW2R3hTndzdubya/9azOIN2T1dQfZMn3O0QFuZTivkvxUYUBZauU2yiiNhpz+KA2EV+ripi9KHW0gjkkP63Sis9u77tYPKg0qOFKEM1VpBqGXJE8IQ+4IW5baxU7tg+qvIXXF5VCOzmmqe720QJMFYxOLKKvOlJz+GCGHCX5BmAOh934FKFl9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(186003)(26005)(8936002)(5660300002)(478600001)(66556008)(64756008)(66946007)(6506007)(316002)(86362001)(53546011)(71200400001)(7696005)(8676002)(55016002)(4744005)(33656002)(66446008)(110136005)(66476007)(76116006)(9686003)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DCFqEzGnsNOYmmpp/x6BGTGD6KoJdcFv8xQ0m7lxIRjeA38PmHpQVF5K/jE/?=
 =?us-ascii?Q?hSbC5HdJCEXw6hw4FldKZ0iEgl8Y6sOxXvqZB85NhlI1Y/EbELkgwYyAO6mF?=
 =?us-ascii?Q?el7bIZhx4F1PlkdEBAXQ5qFNxXG6oXY3AnH6GbV2fe3+B9yTBR2TqOKk1/8Y?=
 =?us-ascii?Q?3VjHjv9N8qtRzkyRikENHlrLGr7N5woNFVWvnm1QYmi8rzShW5vGV4osadoD?=
 =?us-ascii?Q?BIEayF08IzmT/CPa+rpNQz0f8k1umTY7+jhV9PQGXOwvNvRDBVHZmMcsF6YX?=
 =?us-ascii?Q?fduOpvOr7fNLOIfHJePao+XcZOs6mLNN+wDqiTKvzE0yy006u+SMvq4dJXaN?=
 =?us-ascii?Q?EabHUIeAhXLAwbdm98UkeLFq2D8OHtaHWrNKHm54UX1yWsysT419TXJUx1O2?=
 =?us-ascii?Q?8i40Tg00keQJzwR1tae6i8ep3GHd6yc6hGkagLdJ5ehXRQFy2m+G7wKLL2HR?=
 =?us-ascii?Q?SC9HKv2bSTxDCZV89tGrXZ/yFu/32Kfw1hUPqPxOhBsI7TMOqVupSNiLRJta?=
 =?us-ascii?Q?s/67w5+BjlNgD4W9vXHxTU3eovNB0iI7mL963MIrh86a+oFldIuN9mGqypiy?=
 =?us-ascii?Q?WYyiYMRC03g1OVAtWjTvnQWwnJnDwGbe6U6Czt1CEfDnrAq2Vf5/jJ/DBaFQ?=
 =?us-ascii?Q?eZ6jpLM9f993Fk4daXfT252S76T6nA+HWPm6yasFOp9gKut8lfPUAqEd60LS?=
 =?us-ascii?Q?nk/98OFBmLIRdo5wfJXIjGAig/CS8lRxQCL1kFCpD4d/RhB8CW4iSIsyWpVj?=
 =?us-ascii?Q?aEM8IRt8uvWl/Cs9CTa5w1xv7siKqtO+aG2t5SNqdPcXUAmjxw7RisjVD77I?=
 =?us-ascii?Q?7OHfLn8TWYTvJ/I3wZFUkrL7YolD3SQeSsvExvd9dY5kuZ2PR6UfmDaFzybw?=
 =?us-ascii?Q?L6jJ0qlvVWEUkqFhUFkf/WWxDHUlUD67LSFfKIbXu65TflrULeZfXnK5mhfg?=
 =?us-ascii?Q?hP0U8KpAflyLgRecVQx4VcjpZgTGVNZ8UHddZ1FjXqn7yciMX3cNnlGTFYgM?=
 =?us-ascii?Q?bJMFVZyQOW095xrHpru8QxHiIB0OmQ+HpHgq/bX0muvXS6Aj/KER8fdoIfvo?=
 =?us-ascii?Q?ss+UcOyxJrUZe+9H4qJ+PsmmkZ7IGM2Uv04b1Pe/iqG5w/Zw8pwN5EQaEhM/?=
 =?us-ascii?Q?X8WMvXJRYc2W172VOHoyAv+h7TG9RLIesXPoO5oA83fWbEJPDMPslVvhvry+?=
 =?us-ascii?Q?99CdqAlgsBtOhlgoyi26w9wCKtCOrbULj66v/eawwR4aLZiKN0b2nLfJaorc?=
 =?us-ascii?Q?YXB4lSmlfep+dhHQOTIsKXatBxQ6nIwgEj3i14vvSF9ujqDQ8LsjMMR4fTNH?=
 =?us-ascii?Q?WvvEKFC4pFwN75amc2dOu3PB?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb6568c-d716-4b91-c7b5-08d8c9787ce5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Feb 2021 01:51:00.0727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kowfFwp+cG1479Qr1GcnmMUFvU1Eb+T7le2WFeU6AVva6Z/Y9DVvOTsyqynTFzzOTpLk2KbRETP86mJVNlA1Yx7WgjigHiK9tFNbkf2hZ5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6422
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 16:44, michael.christie@oracle.com wrote:=0A=
>>> +=0A=
>> Can we opencode above function if there is only one caller ?=0A=
>> unless there is a specific reason to have it on its own which I failed t=
o=0A=
>> understand.=0A=
> Patch 10 also calls it. I tried to say that in the end of the patch =0A=
> description but it was not too clear now that I read it again.=0A=
>=0A=
> I couldn't decide if I should do it now or later. I selected now since =
=0A=
> it made the 10th pach smaller.=0A=
>=0A=
if it does then fine.=0A=
