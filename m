Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E201C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 08:54:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345567AbhKZI56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Nov 2021 03:57:58 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16502 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344852AbhKZIzy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Nov 2021 03:55:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AQ4nRL8022100;
        Fri, 26 Nov 2021 00:52:35 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cj5vt4kpa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 00:52:35 -0800
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 1AQ8mEVK024782;
        Fri, 26 Nov 2021 00:52:34 -0800
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cj5vt4kp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 00:52:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mf50DNf/5mMNRmHufBLM1igC35O5SD5VPe2Xv2BbPZ8FQV4NF3xqyeKPQyq66SQ7JlCskDFPTwuEpgK5xXKRpI+D+Y+FoCEpvU1NvpQ1L43Al8pRXYW268vV6zLHwyAnGu6dkMI0a++LxPYFE0S7OeYlH5kOyER0KCgkzIF7BhFWi5HIZ3HdRc7iKx+tHdRpaXqnL8TDi9Wm42c+jUKO07Ksc6qhEPvEw7dS0nnS0jNbhj1upVDdYYcqOtm2Z2fqCe3g3VQr7m1xB9q/LUVKU1SnxIezgQBTDkN2Wdkn42acHK23d29jw4RUoyV1C612C9oL1FBcxt7ZDzeXDsUNBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0KK2HsG8aRv42Y2/COlB6qMf4XCEY+vE1gg/mxpk0/M=;
 b=VxZEGwqzxNgRmZPhQCywvbqTV9E1MAjPVu9tfk7a3OZTjRKdyxKDRLA/A10NpPeTKGtgrV+34qyTdiiI+eDALDoibkmmfRN2kf1XPT6xstlOKtUn+7E5GVBwcWm44vU/dDfDRROleaGhhe7pK2Kr05IJZYvWWZtRCXPecFehEV8pq7CROVdNPkhEMehSGl3OAg87T+6vKvZQLgXmGc4R6RO2GDxfBNyoFVrdp5EAxmbOipmaI+1lJp6/+J0hDaXxlPZeT2ucN+QynnXf6VGKKxjR3weWEisYMi0HxozbHyFQym/p1+rKw0tvmHRc6AJoftseNTELdljLdZu6+Zc6/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KK2HsG8aRv42Y2/COlB6qMf4XCEY+vE1gg/mxpk0/M=;
 b=MOO9P+rDXfMzn26teNjD8vcmnGiEGzZfI555aFimQyzPSUUAD/j6OET8X48B/vSRsay4J0xN+Hvl9uP3KJCAARvcRprt0q6TLeDSgMUzk2E8hJ9OzKcDMfzT3ZCC5JG4lNDAV55+hnoEEHXa6muG1lNiSAEnVqQLjgs4Q+MIxRA=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO6PR18MB4467.namprd18.prod.outlook.com (2603:10b6:5:355::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Fri, 26 Nov
 2021 08:52:30 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::f960:c2cb:8ca4:e0cf%4]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 08:52:30 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     kernel test robot <lkp@intel.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:QLOGIC QL41xxx ISCSI DRIVER" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/2] scsi: qedi: Remove set but unused 'page'
 variable
Thread-Topic: [EXT] [PATCH 1/2] scsi: qedi: Remove set but unused 'page'
 variable
Thread-Index: AQHX4oSo8afFlgxayk6RzvRV857OjawVgMlg
Date:   Fri, 26 Nov 2021 08:52:29 +0000
Message-ID: <CO6PR18MB44199C2AE98B79EE9D46D679D8639@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20211126051529.5380-1-f.fainelli@gmail.com>
 <20211126051529.5380-2-f.fainelli@gmail.com>
In-Reply-To: <20211126051529.5380-2-f.fainelli@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb511442-7140-4ab5-c788-08d9b0ba1455
x-ms-traffictypediagnostic: CO6PR18MB4467:
x-microsoft-antispam-prvs: <CO6PR18MB4467244DBC5A3DAD808CAE18D8639@CO6PR18MB4467.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1265;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vf0NMngJJ6WW1iF8Q/L5nkyHmUU6/R/+Esc/q1TsdIz1WCeMbOOe+37myDKNbnCDzVLhKNDcFreaN1d4YHMiKPV/eIiBEHV3CscQEEbaOQcActBGWJaTQ0HcWL4obmHq+1So/UIpVFbQcxluemYvsI9nuYVibtZ6zCW7uT/HuW2G+f81p6dCo9zAjT8zYmjNMjotW+4Qfcz1ikNPLAJ5NfyH0SDQjK/pdzrDbK6Fd2q4bkG6KXZjVL2XPzCPDGCrhausnk2Ea2BGvzspdXynBo4NWUi7hN5fliHCfsX4N4A0FuMMsjmSu5ZqKZz4//Jif3bETIN9z3fFe6JHLaUNEZOqKi9yztHuUY/23m2e+r0M4E2rDdAuJnCJ6cfg+1oS5iNctrRsddR1y34+j9pJyetfWLaQNbYKxtG6KkIohIFRd28WQ0P2j/ZkDoi18DKMOgpG6T2gdcSp1OGlO1o1APxaZXHaGY1xxpuU6Dxt1ftN7g8+nmMjwgnvTOxyxCfypku2rDQY++uBYaKaasVAyVwCeSbxnRxc+I2MSHXucM+xW3DA2kqlyPy5qlWLeFLB4nEjSfl+8lUfl8SLDcYYSCabbcSGDwf+/Hlxo7cPEWgEdO3hgNrdO0qUY+/UHQBLdkwAFvLyusJjzjbrSlbzOJ2dFW+LjATmjOUEh1ilvs+/Afti/lgt+x3atcNCavc2k4/8KmNjpnvWCpyotnP+jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(4326008)(66946007)(83380400001)(76116006)(5660300002)(7696005)(66446008)(9686003)(26005)(508600001)(122000001)(6506007)(66476007)(64756008)(54906003)(186003)(86362001)(38100700002)(316002)(52536014)(8676002)(53546011)(110136005)(66556008)(38070700005)(55016003)(71200400001)(33656002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tk977iVpFc5IYqKJNxUbQylVN07lWRmU2rpLLreh2aqRiJ+otjACt7Fj6sEa?=
 =?us-ascii?Q?Ssy4CTcsPT+DESkrtaA/M+Pjv0R1evOl10NGJ2Jk/JwtzjoAsTEKASBT64rh?=
 =?us-ascii?Q?27KEr49+b8NUhBisGQ4DNKb8aAMAWAUlAoenb//2c2B8csynhBwLAay1aOjc?=
 =?us-ascii?Q?uOcH+wEKPxb4uyWPCP48wGv90BgyvMmdCBbSiXcs2mJicDvKuBvJKX4PQjtS?=
 =?us-ascii?Q?F6r+Zxw67m6ZYhKUn9A0FaakH+h1nsm1EnPXoDoTteiAzsmk47YobjI3cssF?=
 =?us-ascii?Q?v5OKmU281P7Kjngtg0IfRb6daOjhKomYl+u/hUUoZ9MPWZCqHdrCXGW/A/fQ?=
 =?us-ascii?Q?WmXfdcyeoPdRRkUQRMuH6JrwCuX/pYb9nTp0sgwufFB7CV13rBK074F6RNrG?=
 =?us-ascii?Q?co9sKH87eqqgELute0tUYY+qT/edwDCHG1mCJzA0WMM5M5qM5Lm8WXO6zhw/?=
 =?us-ascii?Q?kk5ktZSKwrKFsMcpgXBXynuQoHPsZrR3pi1LcfPpM6rhE8QLV3iRYVAv9dEF?=
 =?us-ascii?Q?CN8gAJq2y6hB6FYZaS/siCI7+yC7RviaKDX8WAc8saUPSkiKmucvI5qRZqS5?=
 =?us-ascii?Q?d76DEwZ6/lbBGSZg2vgXx0tKh33kw52uNt6iXyW5ir3hmPJHic7QX3f1lTB8?=
 =?us-ascii?Q?VWrg3IslrQ7oOmR4fz2i1lk3Dm+qWhWi299/sK5uPuUQRcQlHhmHMain15I4?=
 =?us-ascii?Q?nqVMjJ4wHBO9Hg6DXNVET6wU1gFOfGG7rbktNgRN+86T6OTR4+kUrz+jGnFL?=
 =?us-ascii?Q?AXFNKMOUnUDme68ETo/Tfxg0EkRAjnHRfUn8dTdHDncJEEyC1PS+LabPzbbe?=
 =?us-ascii?Q?PdWzSrKlchdhZ1XwgboWe1rSiG6zursQF4QYIaITRRFXJJHTxoiCGlU09kTV?=
 =?us-ascii?Q?3TJxgXGrtOscEwo7UhLmV03bu6V80c7n/HDCY7hNvIndYi9luIZnxjIFyiMw?=
 =?us-ascii?Q?0H6/vqDMPDrUeFPjCKA8sXlMnkln2Wu8F5sKvJVOAc+xg9GLP3K9OPPTfUUC?=
 =?us-ascii?Q?/tl7dmC2WvMEnQCj5m4zJRIuMp0qPthLnalNJ3NV3/cic6npm+d4QJk3R7u9?=
 =?us-ascii?Q?9qe9tU+y8bbr0K0sd48+ksneaCWqwHKa7a8oDjoOuW02angs7YId+WLIr7L7?=
 =?us-ascii?Q?xC561ONiZ0Fx5Xd+1drlxpaLhIQM9erjpCcyj5QGS4Sg4bXcGaI2+5sGSw0o?=
 =?us-ascii?Q?8R5kRLpxwgSoiPFgOg1H3N+qr842vw/aKDWk6ymja7CijpJa6V/eIyjtowFj?=
 =?us-ascii?Q?/KtFgnwjaNDsQXMznvvAx7Fh1ax3qFF/WUVVktrHTjWxxB+i4E7dHUGMM2EI?=
 =?us-ascii?Q?BOUDYLyhB0CCHp/w/AkHBo/QM4S8SHXd5raZCOFKzGFiWKLbzSQ/Abrrcd+/?=
 =?us-ascii?Q?jCeBBmCZK6Nb90GsMeXugFoRtQeAaJRtXHTgkYYiT3Mwc1BVcPuql2pipNk1?=
 =?us-ascii?Q?mZQt7YU1X2PFIg4qwlk6UlVyXrzPWLqla+fGxQ8UfpdtrPyzt4Pw6GjXQJ+5?=
 =?us-ascii?Q?KDqTcjDqIZTYSNz0VcmI7k7ysDhtj3tckR8c9zXv07zfXxkqBDghFrBv7hTI?=
 =?us-ascii?Q?rZjFM57cPAGHY/bWr7P1hyPIBa5VxReJwdd65ZGz4QXcp5utdcoOi/rUWS/j?=
 =?us-ascii?Q?vw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb511442-7140-4ab5-c788-08d9b0ba1455
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 08:52:29.9733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XEnGdr79fvtmlo3fS3jlqx396O0i0rCMlrS8rU6HLahAt82btN+4rEW9MG1m10uYqTJZCdzHIYfgFIseGOVrnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4467
X-Proofpoint-GUID: LMOmNADs42ZKeTvseAwaYVhp-belUFNd
X-Proofpoint-ORIG-GUID: DFklVT2CA6m94PkAq0GRdbNfjGBdbJ16
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_02,2021-11-25_02,2020-04-07_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Florian Fainelli <f.fainelli@gmail.com>
> Sent: Friday, November 26, 2021 10:45 AM
> To: linux-kernel@vger.kernel.org
> Cc: Florian Fainelli <f.fainelli@gmail.com>; kernel test robot <lkp@intel=
.com>;
> Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <mrangankar@marvell.com>; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
> Martin K. Petersen <martin.petersen@oracle.com>; open list:QLOGIC QL41xxx
> ISCSI DRIVER <linux-scsi@vger.kernel.org>
> Subject: [EXT] [PATCH 1/2] scsi: qedi: Remove set but unused 'page' varia=
ble
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> The variable page is set but never used throughout qedi_alloc_bdq() there=
fore
> remove it.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c index
> 1dec814d8788..f1c933070884 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1538,7 +1538,6 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
>  	int i;
>  	struct scsi_bd *pbl;
>  	u64 *list;
> -	dma_addr_t page;
>=20
>  	/* Alloc dma memory for BDQ buffers */
>  	for (i =3D 0; i < QEDI_BDQ_NUM; i++) {
> @@ -1608,11 +1607,9 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
>  	qedi->bdq_pbl_list_num_entries =3D qedi->bdq_pbl_mem_size /
>  					 QEDI_PAGE_SIZE;
>  	list =3D (u64 *)qedi->bdq_pbl_list;
> -	page =3D qedi->bdq_pbl_list_dma;
>  	for (i =3D 0; i < qedi->bdq_pbl_list_num_entries; i++) {
>  		*list =3D qedi->bdq_pbl_dma;
>  		list++;
> -		page +=3D QEDI_PAGE_SIZE;
>  	}
>=20
>  	return 0;
> --
> 2.25.1

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
