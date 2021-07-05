Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1BCFC07E98
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9A7F613DD
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jul 2021 06:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhGEGkk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jul 2021 02:40:40 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:64077 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGEGkk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jul 2021 02:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1625467083; x=1657003083;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kiCqkwSHSYgXCkv5NyWt63UlEZWbFgskuzWtFG3/MNI=;
  b=GIQIMQ6jD7kir6MgfN4m5lkYVBqBiQzu90/8EmLHLDjX6vqk2TPw9wUZ
   UnJWq/rmVtpSvSEY2ZneK+Xqv3A3oXovjPt1KMv2bF27rEmtKqkfn+a3W
   oaSUOo/teLHidpX/B7lWq64yFnbu+N8nNc8kfcl+zG8aCC/Lwz8jq7E6a
   mL2HGN6TpN3PClrhJ2BLX+FRbsIxLl8JVPqwYcRyhp/b9NsxgbrRRs9s9
   fKsqshKZpVJusdDKbsX9xGTDd/C8bQxOFCCZZyEtGPbEo6BhLGGwLnIFH
   0P17K7c6Kk8kevxrCLZ+hzDEc9g99bkKKDKpZ3wn0sWiKztPqrqcPmegQ
   Q==;
IronPort-SDR: LOEmb8kh2fKbWTW1G4xcZeij2UnzUQltwa2MF9nUETpw2JCxGj9V6JpgWrgZR7R9UJ21ZzK3/G
 fHYJjWvHY+pJvjvDIRCnNQvvAaAF2PSG2BbovJTQepYXRaz3MDgNWtrLR+B0b/nBt/rBEaCfka
 5wMwRuqsTfjdYCtafQUKPbvsROMaEPepQUOJvojoEkFbL/xxggmDAR6IVq5QVh1gsPaI+pFDJ2
 pg4YU30pcN6QuhKaIhIGYEdqg9Car9DAkgA08KuZDDUtZvgnUQ9Rb0kcJijWDUMrxqjD3lwGQo
 gSg=
X-IronPort-AV: E=Sophos;i="5.83,325,1616428800"; 
   d="scan'208";a="178505079"
Received: from mail-bn8nam11lp2171.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.171])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jul 2021 14:38:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ddg7p11EH9jqClZo0nztOn1FGLfebhTZPG9hxZCzAEfiNIDGbtWs0Z4AB1gUGxm1BAcXKw+d0A8+b3IrHUgG+GmrBMXcohW3p8fz2REUeANOMxkom4WU+U1uhEfGZhJpgHnUCVxfmvHD51e3iVbMjIbQzfaEXV563SismHQBlixGqGzpW8FkTLBNEgoRZXQyqE2KibjQZDdvk2AzoLEOp1XAe+14OdTkuu7/4/2ykhDfjaZKEEq4WeZau0KHZ6fHVaoUekNgBEOoVvxO03NuZ89MtgWUXsD0nTcq061Pa0VaNfPkEgY/k4mDN+L6LfdoR+G7XFjY+aa00/DXmcn8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiCqkwSHSYgXCkv5NyWt63UlEZWbFgskuzWtFG3/MNI=;
 b=h895QafK3NWo5eqmabnnwu/aHZuE6YOTqEISh2vssLjJXGSoCvcKqj2VQ2G3ReFJPkLFD1q0xZr7q3IuNv74TIogqUxfJndj9ZnTGxgueZWQvKoSd/a5M+di9/E1f0lWrd31PEuKaoo08x7J/pHNZFqiu1jLza3xisGItLdtIvFr9eFbgSUCua6iMyEIvwFtMuqcfPyaLIGr2IX5IN6/LIKmBBNjqqXAJrzS+65QILuWomtOdm9XyChcquyjtXABPSORvL27Ih38675hbt7AV/rJXpq06QcqTgfcyHlTiJ2iS36IZr73h5lbwLKk9Zio96P+eJG8XVD3uibjlfbNPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kiCqkwSHSYgXCkv5NyWt63UlEZWbFgskuzWtFG3/MNI=;
 b=wMgbaNTImYoDptWQcqBb1kK3xO7JYZOivypkWI+mD7tsJRReHY/dMkMrgbJ5cMCFvG9xAqYmGnX45FvRSf2v14f/k+IHZPM6aaf8ULjuZxAUr8xxTv0HaHMRicxvlNEfZE66zauwwMVq6kK7sSdATJlDkrdIGBAt8KI7iI4B7Do=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 DM6PR04MB4154.namprd04.prod.outlook.com (2603:10b6:5:9a::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4287.24; Mon, 5 Jul 2021 06:38:00 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::ccfd:eb59:ccfe:66e4%5]) with mapi id 15.20.4287.033; Mon, 5 Jul 2021
 06:38:00 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Subject: RE: [PATCH 09/21] ufs: Use DECLARE_COMPLETION_ONSTACK() where
 appropriate
Thread-Topic: [PATCH 09/21] ufs: Use DECLARE_COMPLETION_ONSTACK() where
 appropriate
Thread-Index: AQHXbr3paXcu6u4m8EaA/MhnMZxt1Ksz8m3Q
Date:   Mon, 5 Jul 2021 06:38:00 +0000
Message-ID: <DM6PR04MB6575850929BFC9C5D6100561FC1C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210701211224.17070-1-bvanassche@acm.org>
 <20210701211224.17070-10-bvanassche@acm.org>
In-Reply-To: <20210701211224.17070-10-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9de053b-a45f-4e75-0fbb-08d93f7f6f22
x-ms-traffictypediagnostic: DM6PR04MB4154:
x-microsoft-antispam-prvs: <DM6PR04MB415494F359D15D8C8EC8CE72FC1C9@DM6PR04MB4154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: I4xbjb7/z7kZtH9D8IvL0d2gfirfZSRwpQLrmORM+ceWOj9vw7xcSl3PmGdX2H0UeVKrntcgiW9P9bYcHEnUdyeWkzQ/CyWBanuHXnyBaJzWNjSWMETLqyL4yvnTwTogpJvzKLLPObhtCyX+b1A126UeEbmTixfYQmBd4d9aU9jfiJM4y9aXoVKlIBar/zBluGlb8R+LQUiTkq5oIjocSGkRrOWOtRkuHSVcRL+g4q+woHskWMn6OzqyGjvIowV8HCBJiSWq+/AXcsvqXbW60EvDBWJhnGvKkxlRE9u+grzOHvjPHgvkIO+OKLowTAMrDGsDgiIosfvc86CxysqraJfruVqb8kQzuL3bq0N31YVnV9pf+PWthdpymNWmywyFPrGGIC/VGaNbT0o9VmUO1biInu36KMDRJ5PVLkHw35urmeXDBKWfZWoCJQaCIJQ3YiPvG0ilGS9RwJxsJnYCE3Zd0xDNFJhxZmpgcKtJH3392zRqJXTp67L2kp2vsduUvmVs14K6XsGVaWG0HMHSUeBwJw8juGazSJp7NzvEBtfIasZGKcQOqJCkduOmOeaqpzkeQ2RFOhpNy24InMNVQ8EvQzowb9aX7wSRLSooUzhZW9ftTbBnlFZbEylLaIv4WZOHJiYr7xaSfbQIiWRJig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(8676002)(55016002)(66946007)(76116006)(8936002)(2906002)(66476007)(4326008)(110136005)(478600001)(5660300002)(186003)(26005)(83380400001)(316002)(33656002)(66446008)(64756008)(86362001)(9686003)(38100700002)(7416002)(71200400001)(4744005)(122000001)(66556008)(54906003)(7696005)(6506007)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?btEzBp1tQG3uxpvSe8ncPeqV64+hTj4UOVFbMYHpfqav4j9MSHSSh0b4B0a+?=
 =?us-ascii?Q?F+gBQEfMs7qWbQhO72AhCYRw4T2NY6KDrGOZOMpG6rBAGZmlBCRuzRhYkPWA?=
 =?us-ascii?Q?zAhqg6Sbsk54p+GXsvwbVxuI3282XxgkOtv3/OAlwaNA+UE4xFs1zcu0CYQE?=
 =?us-ascii?Q?6Tm5jzJ1l4DleoNBwiu+GZJ38DxLAebgV9xIixSM66svr/aoQs/9Y0JoyReR?=
 =?us-ascii?Q?A17ITvOzneXFM+Kni87aZ0tUoLWIrhD6aFdW/Dq24AUqtjGC7JLPqo1VxAGH?=
 =?us-ascii?Q?V4Pb9c4WfjiDl0Rn+sJLKLbXYshCOU8ZmWoizj5VHm8aRRGWSztTP21TI/eZ?=
 =?us-ascii?Q?OjIqpfCGUChEq5w/NlnHPBeCY4vBITv6ox1MY1L4KAMF/AQYefWJ/Q8Eyz4v?=
 =?us-ascii?Q?Moz2bZvPXEoEsDzt5ljxsVrcprJDzdTaW43wNr66GlskCSRauhM+GOhxOKj7?=
 =?us-ascii?Q?UdhhPsTxo2fLKE2xBI8exSG0CSW4qIaEyMcRUvbAvA7dg8x6Q7FigGPE6Cqa?=
 =?us-ascii?Q?9jOWrlAWbgXnmNRGA/sQ2g1i18o250IhoFQAGRfei70MaUY4XeRRyEyKS2jL?=
 =?us-ascii?Q?I8nTp3TyPJqT5yl8SIAutR01CvqJX6wU6uhCsOdDEvjOr6ck2oFQkzT55IPL?=
 =?us-ascii?Q?+AyZGuizCXptsKencT5E7/Ce9wf4do/EY3LHFUEDRRvNahf0QVAKaU8N0asT?=
 =?us-ascii?Q?r+/x883OJUIG33rmPDp4TANrNYkTbmFN8guXlM0LZkBvq6ZHbGO3jjUvch92?=
 =?us-ascii?Q?ncPXD68TWaxsrUHa80I3KXn8wwRSWReAlBlaJRx+8UmIxfQZWG4hWzr8ioPu?=
 =?us-ascii?Q?PWuCtKVRgu1L65W5rrtOsEpSY3l3ww2tYHkmc2HG4bWd4ZU6r2pupdeexn+r?=
 =?us-ascii?Q?zXMT2qC/0kUZ/ecYTQW7Ex+rmjTtXK68ogTzRgzP6oku/2dVP+QMCMUrKfoP?=
 =?us-ascii?Q?7cGS0BbegJd/LY2EoQDaLrpfXsfJk9zccFp55CveY927MqHB9k2Lt/jdLHn7?=
 =?us-ascii?Q?PKXrQ4sPe80ZYQg6oGnENlOKNJevrfsk39KzuOZzAechZY1Et8gzKWcH664Q?=
 =?us-ascii?Q?y1q+gmxbSO0V1/FkAmjlLPhHE24r0QnDMdKpmXhStTeb4CeLQRb1t21pdxTw?=
 =?us-ascii?Q?I7nOwIOjpOvTPpU0po/w1Fgr+r1UYWQpxYWOmFN/EgHP8Fx55QI38q5HD9Nf?=
 =?us-ascii?Q?pFiA0CkgGUE478uSKVAVVPfqeK+IS4WQu1RK7Vm995hJNTD8ejV9LNP8bYpw?=
 =?us-ascii?Q?J3Q+yiASVE7cX6U1iH+/k0mqE8C0KW7XtOcDe2XjtMGPYRvR8VaXKmj6+26O?=
 =?us-ascii?Q?fm+7BrsSIi6v0Tpy6gYyovml?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9de053b-a45f-4e75-0fbb-08d93f7f6f22
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jul 2021 06:38:00.6291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjKWgPZfat+19D0JOuZSnEX7cpZsxpyBfoGSK4SaDi3LmMiOnkN5hR9UM/EJhPwatWAdfZQgHQV4TC8sHr2ePA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4154
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> From Documentation/scheduler/completion.rst: "When a completion is
> declared
> as a local variable within a function, then the initialization should
> always use DECLARE_COMPLETION_ONSTACK() explicitly, not just to make
> lockdep happy, but also to make it clear that limited scope had been
> considered and is intentional."
>=20
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
