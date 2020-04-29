Return-Path: <SRS0=qgw9=6N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB07C83006
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 12:59:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A99C2074A
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Apr 2020 12:59:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=micron.com header.i=@micron.com header.b="Z2Vb7d4X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgD2M7L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Apr 2020 08:59:11 -0400
Received: from mail-mw2nam10on2078.outbound.protection.outlook.com ([40.107.94.78]:49536
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726617AbgD2M7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Apr 2020 08:59:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhpyyYWgx1n5okarqDHTt6NW8ZeI39TivG6cszWBb7ECl8/lcsEhne8nysHFp9TKZAytMa3Xy34JqQb1nciATMQCeUyPKA5EYNm/ZnR2BP5YHuJEVIXKiKLIW/cuQv8YFHXjVD0vS96qIrOnPmB3QbiPU+BNCMpFAXtXwS4db9eBZ7yXVIIGCmJFWGDqHFdPIksXFY7em75omRteuKiXgOWKKY33L40YB0UJMiwcRDt8OS6P6tN3oIyWxMXnqaZCM8kbA1jDOAjQG2kby+OYfMJLNWEAcF7Yes0C0FBXYiMaMaCv5Xgy45jOKIiGXmKmMCdsFi9xOKMgoIsAxI6BlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0gcNDe+fB7lo3m8pjWDRrBC7TLzh7VYq9TadfTKE08=;
 b=Ak8I0MutvTNoHLBkwWldYITLdszPvvsRu8KeWAKYWNZSNSmZx8BQi7lDG5BcRJXDG0TU8ZPOULlqfUdVLxh8ZuJfGqD8s0SsDe5t39LpnKOoVpJ1kY5wZcPf58+LN2TDEX3OsPLfRoVcUQQSrveh0eqJisR014TZ6vu7TPyZ7+7HHHSdOuAGWek+QAn3wvHVX23bH1T91PxtCoYCEGTP1/5O8NmUIGXPxPkv/M/iP0jdfZBiOiVgt1+wglEy/ZfGC+TfqyKPLHltpAhRiwAoRUfvio17im+xGaiRcK5b9N3IzfTYELJTdCdHu/yzpQ7SQXhIeniQ4OOEj7fhp3AcnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=micron.com; dmarc=pass action=none header.from=micron.com;
 dkim=pass header.d=micron.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=micron.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0gcNDe+fB7lo3m8pjWDRrBC7TLzh7VYq9TadfTKE08=;
 b=Z2Vb7d4X3/tHYtjcE8POE503NedEy7cWxtzvS0f+K/mn4/jD2M0KGNPca2Z/6nGYwdwIegGwlv6NGM55CAqlIe5n9cxVKTsKZcXaN4VtVdneMrVPtAXctlyMOzDkmNnb0Ci0jtPg4nRbPM0OzA2sEvBLkDnIJzpV/ah69eBrWGo=
Received: from BN7PR08MB5684.namprd08.prod.outlook.com (2603:10b6:408:35::23)
 by BN7PR08MB5074.namprd08.prod.outlook.com (2603:10b6:408:21::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Wed, 29 Apr
 2020 12:59:08 +0000
Received: from BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c]) by BN7PR08MB5684.namprd08.prod.outlook.com
 ([fe80::9ca2:4625:2b46:e45c%4]) with mapi id 15.20.2958.020; Wed, 29 Apr 2020
 12:59:08 +0000
From:   "Bean Huo (beanhuo)" <beanhuo@micron.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Joao Lima <Joao.Lima@synopsys.com>,
        "Alim Akhtar" <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Topic: [EXT] [PATCH v2 1/5] scsi: ufs: Allow UFS 3.0 as a valid version
Thread-Index: AQHWGj6R0nTpmn6fGEWz3ZvyHz0xNaiIaq7AgAdFZYCAAGWHUA==
Date:   Wed, 29 Apr 2020 12:59:08 +0000
Message-ID: <BN7PR08MB56847531D0EC603DD2C7B349DBAD0@BN7PR08MB5684.namprd08.prod.outlook.com>
References: <cover.1587735561.git.Jose.Abreu@synopsys.com>
 <c006813f8fc3052eef97d5216e4f31829d7cd10b.1587735561.git.Jose.Abreu@synopsys.com>
 <SN6PR08MB5693C397D88D16EC43E85490DBD00@SN6PR08MB5693.namprd08.prod.outlook.com>
 <BN8PR12MB3266D1F9B038EF821FA8D503D3AD0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266D1F9B038EF821FA8D503D3AD0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-150, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcYmVhbmh1b1xhcHBkYXRhXHJvYW1pbmdcMDlkODQ5YjYtMzJkMy00YTQwLTg1ZWUtNmI4NGJhMjllMzViXG1zZ3NcbXNnLTM0ZmM0NDM3LThhMTktMTFlYS04YjkzLWRjNzE5NjFmOWRkM1xhbWUtdGVzdFwzNGZjNDQzOC04YTE5LTExZWEtOGI5My1kYzcxOTYxZjlkZDNib2R5LnR4dCIgc3o9IjEwOTMiIHQ9IjEzMjMyNjM4NzQ2NjkwNjE4MSIgaD0iYlhDS0o1WTVjS0hQeGlWelZCVHBEak5jeTJFPSIgaWQ9IiIgYmw9IjAiIGJvPSIxIiBjaT0iY0FBQUFFUkhVMVJTUlVGTkNnVUFBSEFBQUFCRkttRDNKUjdXQVZrd1lHUmdzM3dUV1RCZ1pHQ3pmQk1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQkFBQUFmM09FS1FBQUFBQUFBQUFBQUFBQUFBPT0iLz48L21ldGE+
x-dg-rorf: true
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=micron.com;
x-originating-ip: [165.225.81.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ee482eb1-5d3a-44ef-3ccf-08d7ec3d1aec
x-ms-traffictypediagnostic: BN7PR08MB5074:|BN7PR08MB5074:|BN7PR08MB5074:
x-microsoft-antispam-prvs: <BN7PR08MB5074D7C05C0C71F4097253DEDBAD0@BN7PR08MB5074.namprd08.prod.outlook.com>
x-ms-exchange-transport-forked: True
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 03883BD916
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR08MB5684.namprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(110136005)(4326008)(5660300002)(186003)(7696005)(6506007)(316002)(71200400001)(4744005)(2906002)(55236004)(26005)(54906003)(86362001)(76116006)(9686003)(52536014)(66446008)(8676002)(66556008)(66946007)(64756008)(8936002)(66476007)(55016002)(478600001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ste/Jp1JFhAsknWY3iHPyzZzrXcAUTlcSEyGI33Pf2GMCsOtyC3XLVX6KYlksJQcW0w5DHJu1YLTl4PnUQkNL/ecgsVGdyZCgRjAvCOhfnUPNWpyNSR8xjo0k0YayQTx/CwsGQDqSnBiCx7qt8KUmsI4FJAnG8K5QkpvG9zXhqpn5VApWLgcIMlIXejlBmvlk6HuOgmeVtse4OI4gd0+bQxXLge8akI/Xs/T7G30L+/cRiGOODgqyHFY5zsdc0cYJtxLYJGlOZjFFNUvsa6KbVpjqpSaazLAXc5RLRbyD6gbcfkjCj6GsIFoMFExaRuwNoUzkpOX6VLK9Ubq8jPUfjlROVT8fzVgpQnLo6RUW7lh4y5SP3zzQnx4ZVDSNguP2gNWnOPl+0dOlq4ExMRVZ88wvys67qB59gZ+bG6Cg82WAIZa8Oi6gsfrriaSDXCZ
x-ms-exchange-antispam-messagedata: rMdCgS+ZfIVRbXTqoO3HcqFOlo2D22zbKWWZ6Ri1BcFUelsqD32Z8ET+sQzCoLZvSn/xY2jLGA7KLWXvd6zBGK7czgjcIZI8VZYbk8KJA4tvdpK5sLR77cLI/wT8m4BeM9UksT144Aslb2HE0bJ5GKxOKB2t/QE6UXyUgj/1XypQLXOu8P6rWJipqjZj3xtVTzwoHffxNheO6rNT0K3ufQSxlaww3fwisE9gzw2o4zs3AvuuNcMrkKRX6rAXJfUYBhf6M3OMyRVtgdZ8br6Rud7Mz0z9t5holAMSz/F5da1c7Pvh0brEvtaFdEaPFuhmRKx5K6mCFtyssTwdaOf1678X96vg/1/2Ar+OPVlXK81J9QNBBmyyesHEP0atLCA1ORfypeYB3Hcrv2G90f/JEcnKD7pTGWUTopSf4ZA2bomlm/ZtFgBOtVXTdnN8s2qdjQsUTWMpgq60/rXS6/x8NJwWiHSExxTDfA4FhLH+3pOlM2ZZ7rxTOQFWlEgawRI47UVXSIGB34UqII18ArMFhpOIpFXKK1bbirgbEqaUwFPSBnpCFNmjHouEpatartYtYEnjq7/Zn8Z8dACWi9hvpCLPHmyd6Xkf5jOiAE1LBN+9dZog98VOEAEqeOnJUNL9b/WMk41yIL6p5s0VLK14yLhG0xqQstldZyeR2HZq0TlGVBZ9jbQTnH1HG48VvCDPpCN7I36wGEBOgb0apRwC+XgWiGiOU8htiYeStyojRT3ULD3DLKwEB6cKQhSlhGT9KtFDjacVPScRZRg1J4+43llLTLodLuq+LUpco0kcuuY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: micron.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee482eb1-5d3a-44ef-3ccf-08d7ec3d1aec
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2020 12:59:08.4514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f38a5ecd-2813-4862-b11b-ac1d563c806f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sGydVbNeeCcFYYP60IhZk8c8nQZnxvFN/PhMdboBOecqBIjuYGrcvjZ42V3hKQvo/I3AiyWpqAjwI8aEW8QPUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR08MB5074
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > > @@ -8441,7 +8441,8 @@ int ufshcd_init(struct ufs_hba *hba, void
> > > __iomem *mmio_base, unsigned int irq)
> > >  	if ((hba->ufs_version !=3D UFSHCI_VERSION_10) &&
> > >  	    (hba->ufs_version !=3D UFSHCI_VERSION_11) &&
> > >  	    (hba->ufs_version !=3D UFSHCI_VERSION_20) &&
> > > -	    (hba->ufs_version !=3D UFSHCI_VERSION_21))
> > > +	    (hba->ufs_version !=3D UFSHCI_VERSION_21) &&
> > > +	    (hba->ufs_version !=3D UFSHCI_VERSION_30))
> >
> > I don't think these checkups of UFSHCI version is necessary,  does the =
UFSHCI
> have other version number except these?
> > Is there somebody still v1.0 and v1.1?
>=20
> Probably. I think we can leave them or change the dev_err to a dev_warn.
> This way we have logs in case someone is using a non-supported version.
>=20
> What do you think ?
>=20
Hi, Jose
Seems after your patch, all of current released UFS control versions will b=
e supported except the
version suffix is non-zero. Right?

> ---
> Thanks,
> Jose Miguel Abreu
