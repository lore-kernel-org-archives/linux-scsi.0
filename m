Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAC0C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 06:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiDEGWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 02:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiDEGWi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 02:22:38 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18B3205CA
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 23:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649139641; x=1680675641;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DiFCPa9IUoWSTjDuI9HS+V5JgKoRuvWV8hXmRJI+DuI=;
  b=DmzkHLa/i9dVWh7VSDuw5NKiDC6ElsT4ed0PS+s19GXm+/fMrjpW4VJm
   0wRPna43r/JPXsLVbrksUnbxxBavx2gtTvXe3uf1p6DlyrRycboS3Kw+2
   pJSffvr8u6eexxODB7saeXJO08MLvOhh8eLkqw6Cg4uUaB9xqoJeBQ/1l
   ltBjJD0aR3v+CNhBQDXzzgqMZAsp5NtSIaaCVEjFeqDQD11BI15Yc0qtI
   m4v2ifp7sD4lekFb/94gHpt+PhZzgo39l8V7ZA5Zdco/DQz1+byg6YE+z
   AnNlkKjv6ZmBSF+Drj9SvKlKnOGLMPfb2OAfQG2KK0w2+WpHKEryKImnO
   A==;
X-IronPort-AV: E=Sophos;i="5.90,235,1643644800"; 
   d="scan'208";a="198008332"
Received: from mail-bn8nam11lp2175.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.175])
  by ob1.hgst.iphmx.com with ESMTP; 05 Apr 2022 14:20:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vv33RoaTFRf4Kj3ppuTOTJPKe/TAwJ6fETcjIHq1WlmmpqYpSnsIFQX2h2Zdyvye6Ts8K3+3btBZOo9fWEpPhGAGHNuBXb3VdNRKM88G+mzvZ0tTDLVXvHjihKO/aY8IQdrb1b6j88WHQKRZ/jb6FiQ6dE5dQ1mphipStowH3ydrikn2d1/CQNCrnxhCpvYSO4ULrYbX7vagzEPGoB9deuyt4BRY3Q0jIfm4IrBKyUhM0o/9QKOl2nBK1mTv1Yp8W+DjETO7X8RyYkU2TaDQqQSbSErfvA3wBXVpOGDvglsI4sLE5L3vMtFVvkwbgZzXLSWQARDTfQfgbZZjVn1uJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DiFCPa9IUoWSTjDuI9HS+V5JgKoRuvWV8hXmRJI+DuI=;
 b=ihR4MRUA5/Fvf9+FMti/SAHjjJzXhNkE5ksakzp96z3Aj/p04POsJW+cAwh1i2B5Y3oOvg8p1jltjSmO6dSDy7pZE8xamK3OxsQYhRezr1hPFbGPrXln42+J5wgJNH7AS5m+A3uy07252WjkXgo0/UGSNDQcXEhEVYBEKJnDJYm+zIqq3skgCgApag+VwEhPFH31HC9Dq7VFMVgoQJd28pgml95WxH/ceal40YXW+miGeM4Ptf5haI1iMJEKzUMEaAUvf9YkGAOhmUF2F9/jo1bcKU6ImzGrqPVm7i5JcVpOgiptygX3k7CtM/SP7wTqL4r1tmCrT+ldQDeBnhvvYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiFCPa9IUoWSTjDuI9HS+V5JgKoRuvWV8hXmRJI+DuI=;
 b=nG7z4hMNVY8NAH3aPKZrBhMHRdkHpj2KN4s8yvV8ccBe20g4Jjr0+86DXw+Uh08xgE2v2P0SvvwQZ8dNhSs9lDXNQTGc/oCJdCksk3/WIrEb5Y1Dgbl0XwHFZMJ1hXEKZZBB026bcQ+JiJtILbSiGRSR3ej2kv2O831biqP2LUE=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 BN6PR04MB0741.namprd04.prod.outlook.com (2603:10b6:404:d5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 06:20:37 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::941d:9fe8:b1bd:ea4b%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 06:20:37 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: RE: [PATCH 21/29] scsi: ufs: Introduce ufshcd_clkgate_delay_set()
Thread-Topic: [PATCH 21/29] scsi: ufs: Introduce ufshcd_clkgate_delay_set()
Thread-Index: AQHYRVADOtfl7tCwLUKJeX4MZMMdx6zg37+Q
Date:   Tue, 5 Apr 2022 06:20:36 +0000
Message-ID: <DM6PR04MB6575C73AC801C815982CBC0DFCE49@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-22-bvanassche@acm.org>
In-Reply-To: <20220331223424.1054715-22-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39297633-4eef-4436-22ca-08da16cc6642
x-ms-traffictypediagnostic: BN6PR04MB0741:EE_
x-microsoft-antispam-prvs: <BN6PR04MB0741E2DCDC64941880AE173BFCE49@BN6PR04MB0741.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /zjaffB0cRBRhC07CTtuc3DJRBNflS3avMci4SsHTNnDzlTVXlbB1UaLKrUg7QUjtJ+u+RanN4a3rinLlgMPvlokJFEFZSjMVcV7wDzSJ/0htV1eBoDx0PShvTCfVRvKS2j6zh9pNgb3mm1axdUxNXtgyrgGRt8KVCOD03irsBXec/jOvJOEt+rsCCVIxOe9YreMgVXf/0CUl1AFU1Di5z+lMbWdqzM/ApiPTn7CFLTRQtX/z36HxfCLmZtZejQXZsrk+0mFqDVQjV/cdn9Li/c/H5+wq2HbQcgCx4HCirl9idwicrhBPdx4YrimES76VwOkGXJ8QOPuy9PiZXd2flcaVYi0avZxW0wpu5GzfyR+kWeQUl/W7dpVje+OYy0yLLH+td3qYzJVfEFNAlfA016jFgMnZ2/AHWNsQpwNsFBy3cYeYTEfVMWwDW2MVt1sDLpbhiHdHz4liG4/SyrHmFPf/OBD60atpcUOowzM3BeIS/YpX8lpqa4T7CI7WSo9QyJG2v34MdKbOwx/zGEKPMzwsFmF7IFhFztI2oOuS4k/SFziPbITQH1Gf9NXUUcwb84s3UvoY0jCQs+9xtok5hFj98HB4C8lHiWxK0NqdhDHslkhca0sLcYfFXaNm1IvuIIF3QOPN2yqcrQmqouo4HuMBSlzGNK7ZFzBqY/1EqTzRrQPsxF7Ym7OvfG73OlslODBf1Vb9AXSCakgj7qOkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(76116006)(54906003)(508600001)(4326008)(66476007)(186003)(8676002)(66556008)(71200400001)(316002)(110136005)(558084003)(33656002)(86362001)(2906002)(9686003)(5660300002)(26005)(64756008)(83380400001)(66446008)(38070700005)(38100700002)(6506007)(8936002)(122000001)(82960400001)(7696005)(52536014)(7416002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xNP+Auls7NoxW4OlOs54+theVJMe5r8r4j7v0FECfS9IrQljDcWgnhtKfHve?=
 =?us-ascii?Q?sarIUBvz00TfSwWU7X77mjlpPrkFBWOEMXZf6djiQICKtOvclC8TTohGq1f7?=
 =?us-ascii?Q?S/V8mzAaSxSnVAKgu7T1wCdRJuLTxH/WhF405yVRmiNyF7DombirDYyHQAly?=
 =?us-ascii?Q?G6uh9ZJiJ58CVEwP4ESp+g/2o9a2ASyijJma0UPOZRE7PbR1sr801ALry55P?=
 =?us-ascii?Q?bDMhBLaX1k9ez+spHRjCyvvoPsvxjH+UNU3XCRF95Skm2zur2+gFtXI5vSyG?=
 =?us-ascii?Q?0j0TZnW5VE8BRotpYL4sIWFT2b/QPg1B0CqMPqZNAlCVIq1B3Ek4HcnFHblP?=
 =?us-ascii?Q?NV4EVd3l/TkSgaXuQjp2DsOd+N4gdyZfPoICFj6eD/MTvxCkzBiyo025eOvZ?=
 =?us-ascii?Q?DRlwB7Dlu+/kOFPXESGNXhmnQR/HUSTMdfjJWPBGcNFsX4QnDlBDVjU4O3/E?=
 =?us-ascii?Q?PZVJgm2TfSeBWW946Ffsi5Sjw9yU/X68Mh9jkMz6blhiIl1XGm23Kov1sLDT?=
 =?us-ascii?Q?6urY6woo0oILuQ3ecOHlpRpZoLbVa520paQEDqqwSCmPjVP+8WQKblxVi5bU?=
 =?us-ascii?Q?fEvU1iCMSvhMkGdBlqpuOLpW3mNY12IM2xAJoBXe0sGcNXTk6tUr8fzcnSGc?=
 =?us-ascii?Q?Wm/Unf9vxGvJH0a134wP0Unjk63oVyM0Gi3YEaYZnvUVofTFrIEGbZY1hdYr?=
 =?us-ascii?Q?T1j+inI1eEY+CSPKUHIhP6q+6H1wskagETQPn8l2q8Qx1EsO9CXuAza36PbV?=
 =?us-ascii?Q?ILTOIT30oqf9WciWcaOMd7ePL81x8+ZLIsa1nZEN0CMp1IaN2V6+hz7LwFCR?=
 =?us-ascii?Q?xtJybcsPQ/zDUijvWmLKbDNKFd5ApgJzj04MpQUztrgveOqcb86iH4FZsymG?=
 =?us-ascii?Q?khI54agKzfyhSK67h2pmOa0B79DvrLyxGix4GvQb75w2JooWj1aGTAr8iIUY?=
 =?us-ascii?Q?QwX06AAQyndF2XFvX5ZJsLYosIyi1jWwF2iXyKza5vozhss0CffSUqicx/Ps?=
 =?us-ascii?Q?dJQkXRef/s6OBaStIz7TyBkdJnxJMFmEwIGwypmyVXkapczc7TkjYoQSs8sS?=
 =?us-ascii?Q?tb+N1rHuTPXFGnu7xDpOsXkCgdq8WMC6aK9pnfHQUlN0J0obyoTOz8G4tK8s?=
 =?us-ascii?Q?zJiL+rTJ4oSKZMrhTPvPe7FgeJaq/vhnDU2K5KHwBB6RL8ItvPK5WuBmhEfv?=
 =?us-ascii?Q?5IF0kqJtnkrbGUQiev9Hkryn//TN1S9mYReDRhQOsRbd5YAvdBQSMXdga6kh?=
 =?us-ascii?Q?ws+8cwwWBeN1aQda39gQgA1Xa7VCOKwtNyOVBJltZ74zEGjy20DbTikX7J+X?=
 =?us-ascii?Q?3m8bKqWiU3+rgONB9Cwq5loxb7fxvRcmcbJdgFSKrbP6qXg316N1gcta8ytN?=
 =?us-ascii?Q?mEyxrO5f/Lv/LrkNN3GvHUL7+f/1hN5nRuPnJTj4TpUooUelU8BSAPMqEFnA?=
 =?us-ascii?Q?X7VkIFn6PhrHcDEaR8DYAouokql2ChBzDN27EVYMYHgazuGDHOukn4afZEid?=
 =?us-ascii?Q?9+3kXJVG2MLltSlrcRvoFzhBDgP1jnKXxMece9C1v/kVXltDDIt1GsZC7azH?=
 =?us-ascii?Q?xXQnGFJ8wF/+MQAuOKCOnsSSFVpeXleih5XZnvh65oozErE16vVul8DTkkI7?=
 =?us-ascii?Q?FbfTK3lTe3T4fYqboNKdx9otvX2g8nX3K7z8Utag9kqiwN2Ow2GWQ7TUTotY?=
 =?us-ascii?Q?dBJI+FcwZZjpmgO3HOC9Qjg77nIGEP23FTBA5fRLrduq6riacX8OtHTTHINo?=
 =?us-ascii?Q?d0uAbDZLqQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39297633-4eef-4436-22ca-08da16cc6642
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 06:20:37.0002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e0LGydlkhY36vz0CMTGnFSDF3M11cX0g9sphK/pyjUJnt1uBCMmuyyCBlpC5Lh1jHjJp8Fw/+ou7KhEbx5+G9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR04MB0741
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=20
> Since the code to modify delay_ms while holding the host lock occurs twic=
e,
> introduce a function that performs this action.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
