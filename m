Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0908C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9C4064EBA
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355735AbhCDAdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:33:18 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27636 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234887AbhCCQPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 11:15:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 123FvBYe004246;
        Wed, 3 Mar 2021 08:12:36 -0800
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 36ymaudmg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:12:36 -0800
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 123GAMcT029236;
        Wed, 3 Mar 2021 08:12:36 -0800
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by mx0a-0016f401.pphosted.com with ESMTP id 36ymaudmg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Mar 2021 08:12:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L5Ay3CJ5REu+r4m4w4/FG/sOrnAAwE5cRK/SBPFzdrKnXjsIZ53Q6FNXxymc/p4ZTcNRe3Cve4EoAi1LoiQTX++5JI2mg5YdTefvZgI7Dk0RaFj+YxoRUobfaHEyr9dWYadU1SYr2q2fJgvHco6tXJ2hXxiGKXaoCIUDLSyrzDgEOhCq1cSONT8RBGKksAwwJQuXXn2IczcRSb3itWfGixXse7G70v4+kVvaBg7cxacARybGV15KrCO/0pS5dOHVphK7dBeRZMA9NuXDyFpsa5gewdK+h56LPFUqMNX5MPnd1zxONh9KdjQMnTOZly+Lx77yU57STuC9tSsETJU5lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T91ajqwgJQ+Cul5fL4xrfq9m42GmbIJkpykXtEchLgQ=;
 b=csr39DQvYKlxMzAQz10hGL3i4+sPQw79/FJuoyJ2F/rL0SF4ggsNpYTjMgv1a4iM9gkFAZeVeHqSysDRTOlCSUNcCf5GfZlB3y+pSGK3lX3p0H585XHlas6gFRCABG4G+ZCsDsWGhE+m6ds31SbKHNrVGF3Xftn0l07SpHqEfLTBlwbRj8vCeA3A0FuQEiqSZvgS8NZFibRoumiUSnYowuOozmKxMtMo9GB9ukH0XdFzCUXIEqrxDYiD/Y/UBnWeHKQYTMqwdNmRlx/6xeho8UFNyqaHzPtzP7pEOexhXdaDnu7Li7VjDQaV8NIR0xKal+nXAdi16mJs0cm+OvMKrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T91ajqwgJQ+Cul5fL4xrfq9m42GmbIJkpykXtEchLgQ=;
 b=NEMiBYhma26HjN7mI7yl0/bX2aFHIFOYz2VVfruCLHlb7GOpI1SpruKmOv5PGeqzZBxeNcu/g3eY9TBqrY2uV/M0dPInI++NAN3ycQWx6aycTmiSeJy5XljgpEYRWLAO2YuNMUvQIOWMA/h8+12PgcbTcRyqXsck90CM2l+DFI8=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM5PR18MB2230.namprd18.prod.outlook.com (2603:10b6:4:b7::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 3 Mar
 2021 16:12:33 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::7861:b48b:cec2:255e%6]) with mapi id 15.20.3912.017; Wed, 3 Mar 2021
 16:12:33 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Lee Jones <lee.jones@linaro.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manish Rangankar <mrangankar@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [EXT] [PATCH 12/30] scsi: qla4xxx: ql4_os: Fix formatting issues
 - missing '-' and '_'
Thread-Topic: [EXT] [PATCH 12/30] scsi: qla4xxx: ql4_os: Fix formatting issues
 - missing '-' and '_'
Thread-Index: AQHXEDwd4QMNKE1RVEWyf12iJTQ6NqpybtwA
Date:   Wed, 3 Mar 2021 16:12:33 +0000
Message-ID: <DM6PR18MB30521DD343606F1AC95B2CD7AF989@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
 <20210303144631.3175331-13-lee.jones@linaro.org>
In-Reply-To: <20210303144631.3175331-13-lee.jones@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.94.50.131]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2486a5ea-f63c-43e0-d50c-08d8de5f2752
x-ms-traffictypediagnostic: DM5PR18MB2230:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB22309164E8C1D3D5370570BDAF989@DM5PR18MB2230.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:272;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IKQrFNx5hB8638NlKqg0aFuE8zfC8cRkqC4BulrHMo6pxk2ooWlnavUbPOUes7DpdUlOGZm6g2GhXd/KPa2OrbwNabOhtOAjgWIDJQnciDoZbNMCFIESV8yFvfZrSvAsNl6pHehSR0JSmVUXphzeYYxqPAucz4jPWe33njP71kT2++44czmSrLUv4+OlQUkrd/wOkw0/k5a3ruUWw7vvXIr0OUEs3wSkRCyk6aCShabbmbyYGw66FXT6UyEg2Z7dZYMIbKZxSWwkMRoE1g6i0I1/u3yugeYliEY9sO+YjAxWyZlVPxZTbNvvYwPA0q++WDyN1IyYUv31XruQ/uyUnyh650Ag6XHAXyTiUPWwWrkZZWgbFVDX/3/m0iNO7waRS1xz6ZxQNjlMYn70JBIyeF7Dyp+0bqq/21eyq2KSQpPB8ALptpTTfWS43oehen4WUO1S3skpSKUQLTmfWUwmK0D8Nkndzx1XjfPO+3kk/QDQFQaJGe9opsZXZBtgzmHzXGr7mIrCV/c7bYLGIxFnO3t43Owd7UDOa8PynRbGFK5ilypxzacc75ijgKyMdJMS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(136003)(376002)(64756008)(6916009)(8676002)(55016002)(2906002)(54906003)(83380400001)(316002)(55236004)(478600001)(186003)(52536014)(66946007)(5660300002)(66556008)(76116006)(66476007)(66446008)(8936002)(71200400001)(26005)(7696005)(33656002)(86362001)(53546011)(6506007)(4326008)(9686003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YT8UP3ALJkybM9y9DCJNj6N0JD8CLEf8sXGkeZDaA/ddTI+UGByGf+rhzaQW?=
 =?us-ascii?Q?EzJd5/aCcEkP/6VJvVpFO4u7AcSJ6ai0DLH17BkaKsXILxMiougKEnaW9WPr?=
 =?us-ascii?Q?N0PSEtAGg5boWezz3mC31wU41f6EmYk31LLCJ8y8Hi5z7tJ1AR6HmUi1owKh?=
 =?us-ascii?Q?d35GJ+DGLZIONlgfnlut8aZ1z1qbWAM/tXeC8nGSpRpKb9Xo+OfKu3kB8x79?=
 =?us-ascii?Q?0czmV7DG0ZAciuH+Lbt01oiPLeZNXLvXLSiPWcqs553dMQLQaFX4aA2DB4HA?=
 =?us-ascii?Q?wbRX/tfPtfokNRyN52JopHqs3UowGIXyFFwUVw7NhpqxaQEzxWH6uzOeRJQc?=
 =?us-ascii?Q?ZiMLLcGCIiHrKTLM8zA2qIbmr5DaDGh2maH7yUQh/NLT6lCgmJndilYTNsRx?=
 =?us-ascii?Q?/dh+EFU8TWOsQut7+WDAO0fRKF8NQfanIssmbpGakGTAhN1/9IIzBqKcP8qt?=
 =?us-ascii?Q?lIGCsM5sntVZocJI/0HNe3Wm0P4MCbueUfSscJaJcNmz2F2JcMr0mDn9sUcz?=
 =?us-ascii?Q?Nf7UiwusU8EKrGJLHnvXWYMhcjKj8Q+OGuuRba3/dTVmn0L2FV6Mtt9Fk2eQ?=
 =?us-ascii?Q?/OpFY33HZDZ1nkfYCdh0nR746+V4mFMEVneNjIQSIYliIHp5Y9Q/p+Be+cDk?=
 =?us-ascii?Q?K93I23QarVxMYHznggCd0Ij3ZKLNsF8pdDQ6zCMDfz20jE6g2jewsf7YUik2?=
 =?us-ascii?Q?Bo5EvxjZrHrBGlryffs30JmdebkCi3Lpt6p0rKa8PivXkCLMAuKH/4GdicS5?=
 =?us-ascii?Q?jHVJ28RRqBvE13BoveYG0c4FFLCRGkVSw4S7V47jc3wa4hezCO5Uo3l1gM5z?=
 =?us-ascii?Q?acfv2UYTHIrZRSFH6zEgPVSaOtrR5oCsSups+HZVmnTihkuggtaOUDz44E3c?=
 =?us-ascii?Q?ItarKn+xehbesSqSiNq5jxEb747XEUOwl6OhUumn/roQBaQu7HpJUb+Mt8uS?=
 =?us-ascii?Q?cP1LGWUfMgzyEjzMvF2mzchTwva/gVx846Hrz2UBffI1pG6stqXQTKjEHVZK?=
 =?us-ascii?Q?/QfmzWjsjNZ1OsjdsoDwwaHgt03UWkbVso++B0Y+meAShvSQsLm4ljqdNT4S?=
 =?us-ascii?Q?XdCy7boWVXUVHem3KXCuMEP0A8m5qAjB3vcSAISuEStMAYk000CSUqklvKHb?=
 =?us-ascii?Q?qSRqjW9lCYrFtvg+feNcSufopT4fVECvOqOCgmMn4UFnsGhT/cHBFxhaFEBn?=
 =?us-ascii?Q?dkVgc5Y8h1LVFTDxynifZoD465raiVqGMeNdds1+Ap95FeTGGrPZXS3Ss5+L?=
 =?us-ascii?Q?cirBRuj59NDoMbmX7mA1WWEQqxo0D9fdZHoFCmzKfo6SjzjvTFEsJkbcQyhB?=
 =?us-ascii?Q?+MM9IUO7HHXSc8Nh2tlBpbbW?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2486a5ea-f63c-43e0-d50c-08d8de5f2752
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2021 16:12:33.4805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bx4K6s4IYanAebSe8APys+KS+8gKKBOqMOIoVd9pZrRMEmZFKDTw0XU3FZBJUsPIQCeD23NHatZuFlHTwgc2Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2230
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-03_05:2021-03-03,2021-03-03 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Lee Jones <lee.jones@linaro.org>
> Sent: Wednesday, March 3, 2021 8:16 PM
> To: lee.jones@linaro.org
> Cc: linux-kernel@vger.kernel.org; Nilesh Javali <njavali@marvell.com>;
> Manish Rangankar <mrangankar@marvell.com>; GR-QLogic-Storage-
> Upstream <GR-QLogic-Storage-Upstream@marvell.com>; James E.J.
> Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org
> Subject: [EXT] [PATCH 12/30] scsi: qla4xxx: ql4_os: Fix formatting issues=
 -
> missing '-' and '_'
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Fixes the following W=3D1 kernel build warning(s):
>=20
>  drivers/scsi/qla4xxx/ql4_os.c:631: warning: expecting prototype for
> qla4xxx_create chap_list(). Prototype was for qla4xxx_create_chap_list()
> instead
>  drivers/scsi/qla4xxx/ql4_os.c:9643: warning: expecting prototype for get=
s
> called if(). Prototype was for qla4xxx_pci_mmio_enabled() instead
>=20
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Manish Rangankar <mrangankar@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
> index 7bd9a4a04ad5d..597a64d91fe92 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -618,7 +618,7 @@ static umode_t qla4_attr_is_visible(int param_type,
> int param)
>  }
>=20
>  /**
> - * qla4xxx_create chap_list - Create CHAP list from FLASH
> + * qla4xxx_create_chap_list - Create CHAP list from FLASH
>   * @ha: pointer to adapter structure
>   *
>   * Read flash and make a list of CHAP entries, during login when a CHAP
> entry
> @@ -9633,7 +9633,7 @@ qla4xxx_pci_error_detected(struct pci_dev *pdev,
> pci_channel_state_t state)
>  }
>=20
>  /**
> - * qla4xxx_pci_mmio_enabled() gets called if
> + * qla4xxx_pci_mmio_enabled() - gets called if
>   * qla4xxx_pci_error_detected() returns PCI_ERS_RESULT_CAN_RECOVER
>   * and read/write to the device still works.
>   * @pdev: PCI device pointer
> --
> 2.27.0

Lee,

Thanks for the patch.
Ack-by: Nilesh Javali <njavali@marvell.com>

