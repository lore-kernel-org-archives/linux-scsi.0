Return-Path: <SRS0=Opo1=DG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01D8C47425
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 11:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 812262075F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Sep 2020 11:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=permerror (0-bit key) header.d=wdc.com header.i=@wdc.com header.b="WA2ZYFX4";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="wWwzdCc0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbgI2Lyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 07:54:55 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41971 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730426AbgI2Lyh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Sep 2020 07:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1601381257; x=1632917257;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VpYaatWRBTgIADFT4VpUUpHV0hbtu2L7RhXCauNw2dU=;
  b=WA2ZYFX43IKXEfQrmzu2QJFz0Wj2LYa5A+HAtOTdLRQpaX3vvEXCFyhl
   7xKjr0dU75551METBY5tNv+86FBmvaQPj1AqeP5MYqjm+HusTfZtzJBzJ
   1I1eO3yn4aip1Nafy/T99gx/mCXyZJvcNAKoxDhX7Ka/RqiMaerHhYDRn
   zbXUyvtyOyCKPWw34L+KqfZdgIbQ8xKNsc7t+oElU8sIsKZy7IBwPr9nw
   wU2yt9Obdr2RSt9Ehd+BqcTEdRtJ1aucJYnPXcFzw6CKeo/JU5c0Z0Y7x
   qiyMDFaUivlKotV4ahd0dpCqVnkDxR/PtQsPSKW/CQStaXr9tCYeZ0w8C
   A==;
IronPort-SDR: FMQuFLFbWihNy1nQ/QdOcfTo4ijt4T28LHj9OGaS7cWVDoQrvfmOoI5bmjVT5fQX1C9cYFx+VC
 mMh/Rtp9/8pB8iQishQuzut9v1gYGl0abuT4bftTcrvOV7MyyDmYZkc5RoBR7SkI1XWm4o1o26
 +d1DlTm/eygSTLg92O+uH61VWTmY/Pn6q2ZiVHYCXhCBAuQKT+5K0UrC9yB2cp9D5H1VIhySYC
 2kC+LAk3Lha2lXN066IHRznbJKiL46EmVCgBF4Q0YJ3WVj24+ISu4Rrej5T9ZcrqE2eVFMP9l8
 IvA=
X-IronPort-AV: E=Sophos;i="5.77,318,1596470400"; 
   d="scan'208";a="251949948"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2020 20:07:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJQgvpGqJbd+uOvHyhEBv5lG3zJ5qASTNn+1EVgqcOKq9nmx0YbNJKDz+j/nyGiiZ4YhA1qjcvew0i4AXUTviBM5g40R+DQjOzdxLJQq+Y98C7CiRJ7h8xmrPN8PR+Fkl/MgifEM/si7kqG5/P3KWMllheTeanDDrAeJ3MHvnj2jr1c4nMF0rEZNTdyQxD3e9PLTT429ajnvR7Fe6pmp0SRvlGEhoLVQrW4gCfcA51Lp+ioMYJSQhhQbsIOoexUqgjt19VwZsZeKCbAmOv7V69/msPr6UcwXuhv9TbvqA6VSypvN3tP18zfJwoJ87wCrmnqXU7Qb4VCaJ3oD/XUbWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXKAJeCwzBd2FMLiHxP+hr4uDpxxNEop/tOnmKg6MVs=;
 b=eVnBgNjMkF5SHtc43qEQ5Vwb2yh2r33J+uza8WMtjlLxG2Q9BuOQ5OvlQU7jsyLDGuF56B03mAtc463r2MLZm+nGsGKYmxpvNoDy+4RI0oWQjL9Nrlq1Eth1JPVLOHFIreB9mjtQ3vk2NaV8UtZ5wKosjG4nrNPLczS285dGAhhoyJyHxdbodFy3XeFwS2SVq3kHTtA79zgF1pvTvbOmZRIuoCp9831a6op7q2m7ZQCCMgK0xzcCCjCWUJPJ0I7Z34hratR7PbyA+a1j4aWq7qHIdqoMd3EOzNyVGqsxjwQI1UkbfPWOp7VPHZpoPeK//ZOP0v3860LlozIyrKXdHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXKAJeCwzBd2FMLiHxP+hr4uDpxxNEop/tOnmKg6MVs=;
 b=wWwzdCc03nxWvjKhcq7zVS9ITLuRu3Qkj9aYO3ENRuZ2j9x531b9OVeh1zULu8t/dGhce9THOJSTYlZMKEUrHcQ2l8DdOmAjsFwMm8BH9F8HAIhMpunTb8QAzZvWRhvyWTO5GVCUJcAa0F8hZKBFAcXRhRfGmK20jF5i68ttN7w=
Received: from BY5PR04MB6705.namprd04.prod.outlook.com (2603:10b6:a03:220::8)
 by BY5PR04MB6312.namprd04.prod.outlook.com (2603:10b6:a03:1e3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 11:54:32 +0000
Received: from BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0]) by BY5PR04MB6705.namprd04.prod.outlook.com
 ([fe80::2c49:48e2:e9fb:d5a0%9]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 11:54:31 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Stanley Chu <stanley.chu@mediatek.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
CC:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>
Subject: RE: [PATCH 4/4] scsi: ufs-mediatek: Add host reset mechanism
Thread-Topic: [PATCH 4/4] scsi: ufs-mediatek: Add host reset mechanism
Thread-Index: AQHWhauhM77uE6w2t0y0fOl12ucOUql/osKg
Date:   Tue, 29 Sep 2020 11:54:31 +0000
Message-ID: <BY5PR04MB6705873E1F5DBCE7C97D12AEFC320@BY5PR04MB6705.namprd04.prod.outlook.com>
References: <20200908064507.30774-1-stanley.chu@mediatek.com>
 <20200908064507.30774-5-stanley.chu@mediatek.com>
In-Reply-To: <20200908064507.30774-5-stanley.chu@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [212.25.79.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f27844c8-661f-4fc9-30ae-08d8646e6d8c
x-ms-traffictypediagnostic: BY5PR04MB6312:
x-microsoft-antispam-prvs: <BY5PR04MB6312D9EB78AC4DBF3BF22333FC320@BY5PR04MB6312.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qR2bEb2cxUGPS8T+zT4J4G/mkBDaoqpYJwQARlBm39lYANuOEjPjxJswl50wwekC1DAqr9bFR26o4Z3lf9Hdw7fE8I64avuvKydcrzRRJ1wh+8ZA3Hhg1/fqiaeIvg08MmwRUaZNnzibAv8sK112RrxjDbUAq2PQolJSiXW/ebC62ebUffk0x0kDMRgsxHb6ae7qTzGeFr0Dj+D36q+UjNssfXtBlxPPJuxSk2iwmTbcI/UB+uCqGuy9PsiTlskNeZY1a3Of/uSxXmhq0R6KdhhcxyxOPz3bYfuNbzvOzW3HgZz5Y5Lvkkt/fl6w2qTF9vlGIPkfLaS9npJ3mnwP8N/nU6wgHYMg3A7ov4Ni/EMKz9YUUcB5MBtMSjdRP3ON
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6705.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(498600001)(5660300002)(71200400001)(4326008)(7416002)(66946007)(66476007)(66556008)(54906003)(7696005)(76116006)(52536014)(2906002)(33656002)(4744005)(8936002)(66446008)(86362001)(8676002)(186003)(110136005)(9686003)(26005)(55016002)(83380400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /2NhCWPA0++LDwuEHPdjnrvhCdz19AD05AjQ/6w7TnGuqSmEQPRgqqof6tGahPwwivNexOyNn862kedX5Neaz9bnUmu8JZ0pl7hZyV+EqdCO1B5A1MPgxsI+cLPzMffwywTHo+FJXZg8/KYDj2tYCGXFAiJt9iVe2paZGlyP76CFdJ7wnOEKhNwB2uomL2hszjamJo9JU6whOtbtCeq+mRevvWlfIqvcBzUbWeK/PVGcgIuT8kqxMz+ZGWbS1JdR9WAxewytcTfkn7qI5e0AwIGCOnF1BLkOGvF2e50xnZKYqEpeK8gdLQKPK8DUy9r8nnq3XVIAOawyLD7kAJDF4v27kajhuxDjUX7YiXFnMZPTF9yBqPyWfOvoszE9XQ3J20j64ZiBfF856TkFQ1zqQwj7clVpj31kH3ppxGlB7rYZxGmSqPQIR871ZGfQ3bwj9ZfSy6eGJYITsQOP0wFoltvYuk1cKKTxv2Lrr8760iY4WcHEI6poLWdFR99i9NRA1KwQfsyrLpAZAH/evi2sk4JVML//b/ao28ipchWP87eHbm+iOG1caWNOGGDdryZPdbEksfX1PoKgGBDPMUoIpg1IAZWaXtOrITbqyLx+o6mP49R/kEmhR42T8pRw5/Hy6H9LJjOEs7TQe0kOTxaFEw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR04MB6705.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27844c8-661f-4fc9-30ae-08d8646e6d8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 11:54:31.8406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIW+v/RUrIXMbQ/jSAQSwlU5JmvZzDjNtGi18DSrRCF7Cw8Ebs1+QACTUPySMAiEQutjJPy22tRZ1koS+VIC3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6312
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>=20
>=20
> Add host reset mechanism to try to recover host-side errors
> during recovery flow.
>=20
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by Avri Altman <avri.altman@wdc.com>

See some nit below as well.
Thanks,
Avri

> +static void ufs_mtk_init_reset_control(struct ufs_hba *hba,
> +                                      struct reset_control **rc,
> +                                      char *str)
> +{
> +       *rc =3D devm_reset_control_get(hba->dev, str);
> +       if (IS_ERR(*rc)) {
How about verifying that the line is not shared as well?
Although this might not be an issue on your current platforms,
it might save you aggravation in the future..

> +               dev_info(hba->dev, "Failed to get reset control %s: %d\n"=
,
> +                        str, PTR_ERR(*rc));
> +               *rc =3D NULL;
> +       }
> +}
