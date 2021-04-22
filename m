Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5622DC43461
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:27:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A7FE61184
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:27:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238455AbhDVR2c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:28:32 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:57194 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236459AbhDVR2b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:28:31 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHNveq028921;
        Thu, 22 Apr 2021 17:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=MsH3foInyVFB60wwYzoKQvmFK7MhMpVbcc03Tmf3Zmc=;
 b=X6zFqdRlFLIl6Z1TCaLvl7yg6Yc6fsFBOWkWsMXB80NOSDj9UMNVqcvGYX2cQLJ814b+
 savIMO8Bl/y4d2M5IoVbjcpwf0P+YQ/tQhcg6VXARq4SMUsR2of/wl19aAJAvDZaG6E+
 FY4K7CIRpd3nSsnKapdscIBGgEDZZb8Eq8m/Bt8d1ddlcan81WQBBGxTy020CicVl0YJ
 1rPiDLcEeHbOWhCbeib04HFPr+qjNIkQgsUkUnJvmA4wHhGGfUcdOGkEeo5ypu0yv1Zc
 ZKUJpAj2IiDlYQsm7jy/6GM6DIUzRM87S1HStbuDcJpSKCDA6BvtPUALjvatStwb59tO rA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37yn6ce7gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:27:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHPsrL002219;
        Thu, 22 Apr 2021 17:27:53 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 383ccek9se-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:27:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwIPIsCWlKm2oWsbyZtG13lXEsXvz3XEMhvkmAiHgKZiiaPutv1c7+gq+sLknukQ8zQ2RQiH0278YkgDvi/1RA5eFG16Yr1ol1hGqP1gCz1oh5miOHVm8K7qGBjkD1i7DZy3083VQaq2988i8FH4ZTTUzq9uAhWlWmthcDPKmt2quIJIt88lTzCl8DvmGyWlWrMt6AriOf+h5/4ppEuA/6hEWTC/lLwRSAyXegRy5qZmy6GngeLY19lI6wNw0L0c46rnop1f8Qcs3DKHwTjarHIIfX7Eq+aC4DAc+98Sqf+mOJ+hGdu2fWG3rh2rhPPR2PiRiKAJoUQnJuAMITvj6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsH3foInyVFB60wwYzoKQvmFK7MhMpVbcc03Tmf3Zmc=;
 b=epaJDk2NRrM0JmPG2aJ0zGmq6PuHujXBqTASD5o98PmCzNXN5bnV2aQWW6B/yHs4zZl+rpbPox6EppJ+xID3qD92ousc03s5afWpjf37Kq//lmkp2psRhcDvaIwBxMcBey5Fap2x0tytQFSl6/PGhF9CKBw0CXz7LPMgVziHe3Y6MUXqPPzV4vdx2GFFZ5uoCk6uCikZ9FCFQ4x6SZswCIYTS/Efg6x5AEVfBAaeJmkQt4LV1lvp9Wms3U+r7S/bNAtxIc4lRBzkAyJUQ5enVlpoVi24+qDFJMtdmUBVv4BN4X99MCJoUeUIYwVXl19dHSKYtPTN4547HJmc5Aa/HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsH3foInyVFB60wwYzoKQvmFK7MhMpVbcc03Tmf3Zmc=;
 b=gBXnCxL9nkNIW5yskeaVvmc/8JOpTmJGHjLPCD0mToMjbt5C0FQDoid2upZJdvtOqCfA+3s0vI4H3avAthu5gFsCBsmQMJ7HzEGu+UoQ7Up2c/PUOPAlA7YTqFfWaX3jKzbVFVXksg9zYR+SfWDePiCd6sj0oRzuga6g2psGsy4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 17:27:52 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:27:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 22/24] mpi3mr: add support of DSN secure fw check
Thread-Topic: [PATCH v3 22/24] mpi3mr: add support of DSN secure fw check
Thread-Index: AQHXNQufAt9J3Xn2ukG2/4BquwzjNKrAz4yA
Date:   Thu, 22 Apr 2021 17:27:51 +0000
Message-ID: <6F361B87-93F0-47EF-A4B9-FD5BC2F6D9EA@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-23-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-23-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 771a01e6-fb3e-4469-d005-08d905b3f529
x-ms-traffictypediagnostic: SA2PR10MB4732:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4732F898FE872F553ADFAC01E6469@SA2PR10MB4732.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:166;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hEGSzAbz85zGd7kqEAdkszmqWev77iMWBmQ5AmMspF6Qmjz9Gc2q5YzanFX/mMlyrq+VJM0cCyuNvfWzlJdoaauogRIThOI+hp46zQSBuqEbMqRdOXBdXDzZjBJdOqidtLUIdp0DVxuuV98Nq4CmHQtyMqI8IjKOHa5NmO6vvPcnlrUw+GwmKLwQmijoreovV3Prgu02yJXI73xy1MUV+RvifUFK8KN77fzUg+2CnqbmN+FMyINgQ53dGHe5Uqadco1bybBHDQq82dNIkULd+HtBLDkgNoEAvMsThaJyihYFdbXKWyd8jEe9wewgPoYVMtplT53fOyYMsGS0o+nLFOR3/NSA5Ac/UJAADwT2unJOlaoVECan39TKu0nSO6uijSFSuo8autinttuBvxXI5hhrfq6Ntzd5tOD5LTZ2tC6UwUfRwX+NBaz+oF6QPO1CxEPQofAopMQv5kyhIRIE7eT1dr5sKcIfavi5Pmd1Se3PVaj7+sG4myOmJgWNHX5iKTRp9+wss2SG60CDDGD/1YwbBTcWyk2NW4SW9wPmGCRTc8NC4TrGf2QOz+28/VMk7hnoeBVTpS3zFb6BNhHbZ2ZLpTB7ZeJMyIYjhmaCS0AqPFFTL0hFDPmeVmlVLNrAehwc15xHdk+aS3I3bf5rXFJERZT86CuKPqBk26kTB9ro9Q/Y5M2a7RNaMRSySjZ3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(6916009)(54906003)(66556008)(4326008)(26005)(2616005)(186003)(53546011)(6512007)(6506007)(8676002)(71200400001)(83380400001)(44832011)(8936002)(86362001)(316002)(2906002)(122000001)(6486002)(33656002)(478600001)(36756003)(76116006)(66476007)(64756008)(5660300002)(66946007)(66446008)(38100700002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?bfdJU7qakhE0jEX791kBoQEpHd1uerrbGWxuadKF5jdDNPto+IXfLLZdQEyz?=
 =?us-ascii?Q?l7UrjTb80zFIGaQ6hHI/E0HlBPDSJFFY4IRL89O93vg/XPEDvgIgsYN81vew?=
 =?us-ascii?Q?L7+/55nOurXRQEH+HNa3P60c3HtRU/4B55xnDhLA9k7OxC4/3uLxIjCMSXfy?=
 =?us-ascii?Q?sJcRyQGfGCkZR/owg14xoEbnb74Ab4X3FA2mSeYupTLQAm7psQ2BQkk1fcPW?=
 =?us-ascii?Q?613Ysj/Ac73FGsLXQlpaXfBkfULLpQugnIOKhbj7jdHEQRTtr3i1HrxQYcpy?=
 =?us-ascii?Q?M2DWrGS3pml3evpOnWCYL3Tq1+yp7QeMl+kUM4Kuow+pkEf3wVYlENJ3sP3A?=
 =?us-ascii?Q?UZPqcWb7xhHpZnl7bt4B3xkT7vLm6GynLX3N1+6QHq8U2pEuV5/2LomMoImF?=
 =?us-ascii?Q?5FF8YE3TmtNQ6bD/Y4C6DJckeC/NpF4hL9dgqCbVocP1AYejIF4fEA+I4d9V?=
 =?us-ascii?Q?BIafV71dhTCP2zpsWNeE/h4eRFoNxcQv4xIOqi4u6la36/XupocmwK7/lquI?=
 =?us-ascii?Q?d1L1TS3ri+JQjJZ8NnUIggQYaFdwQdj+rDAeEj2QugV+LeHsP3isDL/XcqyC?=
 =?us-ascii?Q?UoN9WuqERtFud/NsyyHSNmCTygkoiUG//ivRumsda9RArFGdGbvlDXHhep7T?=
 =?us-ascii?Q?k0EzUJUBI1k7JvtQ0aCM9TkNveUtiyGwxfrZNVYePHgDLLOcC9aQlPhEYeut?=
 =?us-ascii?Q?32P8FkhYTM+XWUa0TZAx00nct2eT3hUnZYxb0hn5OhYFq6zMd59FDzhqfFVY?=
 =?us-ascii?Q?8Xpc1OSfh+dU1nHF2wNapv49qiiIn6I+hu1MPHnhFR+7Mz+NQwMsEK3WdyJn?=
 =?us-ascii?Q?zvw8oRyh+i6Azvl1ZEwS4oTLNl97KOtAt1DcijLa5G+bw5wZw54zIEsgoszB?=
 =?us-ascii?Q?Qi8tGcZPFiKC/7LkWcqLib/VhqOCk5nTvihMbOZ4lU3sMz1l6yx+JUno34yc?=
 =?us-ascii?Q?PZzb9NKjnCl+j11NGXRwGbGGOjBXJ7W17tOnjUyzs/JsgjKowytkA3FNkTgG?=
 =?us-ascii?Q?0XQbHBnzMAj4h/OMRgEAcBj78lRvP8+RoDPZStOqkr8he6JkhqUOT/McT5HR?=
 =?us-ascii?Q?Fldu248uVZwiH4sm+QTkEwanK8NKBGsMXRJewVc67JJY30hDqqHPtZ0PXVVl?=
 =?us-ascii?Q?a05JSlwwZbbIIlk1Pu5R4UYmzyyUsifIB2JHAnQkXcgRF6MEnq8kKMbvJkfu?=
 =?us-ascii?Q?Nr4io7Uyke/OOtInuTi3W4n/q3ZX9mJfV7AO09MaqIu2w6SnzeE/7QA9kyAh?=
 =?us-ascii?Q?RoViqx56RSWxlzk6YvDS/Lm41KYTg8RQd5f5o7jqB0YkBFC8xh8z90jz3kKg?=
 =?us-ascii?Q?B/Dq4+3gLv1WkDQnLMizHQrzc1T6T6MaUKJplFsXPFYSxQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E3D41AB2E0FC4F4C942D22D8B28BB313@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 771a01e6-fb3e-4469-d005-08d905b3f529
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:27:51.9479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yllqTn9EMt01zJNtLmHo83X5Ds2lUbNjYCdV9Zs6Xq3s2K1WoBq0qlEZE/YUNzNKR6G8fgG3FP28kNHfSaebgMN2TXtN0/mYPuNJoVEZsSc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220131
X-Proofpoint-GUID: nbJ0FtzRMnxCjY6IlEWPlhj50DRid4p-
X-Proofpoint-ORIG-GUID: nbJ0FtzRMnxCjY6IlEWPlhj50DRid4p-
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Read PCI_EXT_CAP_ID_DSN to know security status.
>=20
> Driver will throw an warning message when a non-secure type controller
> is detected. Purpose of this interface is to avoid interacting with
> any firmware which is not secured/signed by Broadcom.
> Any tampering on Firmware component will be detected by hardware
> and it will be communicated to the driver to avoid any further
> interaction with that component.
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  9 ++++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 80 +++++++++++++++++++++++++++++++++
> 2 files changed, 89 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 505df0e7b852..db9cb11db3bf 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -149,6 +149,15 @@ extern struct list_head mrioc_list;
> #define MPI3MR_IRQ_POLL_SLEEP			2
> #define MPI3MR_IRQ_POLL_TRIGGER_IOCOUNT		8
>=20
> +/* Definitions for the controller security status*/
> +#define MPI3MR_CTLR_SECURITY_STATUS_MASK	0x0C
> +#define MPI3MR_CTLR_SECURE_DBG_STATUS_MASK	0x02
> +
> +#define MPI3MR_INVALID_DEVICE			0x00
> +#define MPI3MR_CONFIG_SECURE_DEVICE		0x04
> +#define MPI3MR_HARD_SECURE_DEVICE		0x08
> +#define MPI3MR_TAMPERED_DEVICE			0x0C
> +
> /* SGE Flag definition */
> #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
> 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 05473b0f3c9e..836005ce6999 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -3206,6 +3206,75 @@ static inline void mpi3mr_init_drv_cmd(struct mpi3=
mr_drv_cmd *cmdptr,
> 	cmdptr->host_tag =3D host_tag;
> }
>=20
> +/**
> + * osintfc_mrioc_security_status -Check controller secure status
> + * @pdev: PCI device instance
> + *
> + * Read the Device Serial Number capability from PCI config
> + * space and decide whether the controller is secure or not.
> + *
> + * Return: 0 on success, non-zero on failure.
> + */
> +static int
> +osintfc_mrioc_security_status(struct pci_dev *pdev)
> +{
> +	u32 cap_data;
> +	int base;
> +	u32 ctlr_status;
> +	u32 debug_status;
> +	int retval =3D 0;
> +
> +	base =3D pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_DSN);
> +	if (!base) {
> +		dev_err(&pdev->dev,
> +		    "%s: PCI_EXT_CAP_ID_DSN is not supported\n", __func__);
> +		return -1;
> +	}
> +
> +	pci_read_config_dword(pdev, base + 4, &cap_data);
> +
> +	debug_status =3D cap_data & MPI3MR_CTLR_SECURE_DBG_STATUS_MASK;
> +	ctlr_status =3D cap_data & MPI3MR_CTLR_SECURITY_STATUS_MASK;
> +
> +	switch (ctlr_status) {
> +	case MPI3MR_INVALID_DEVICE:
> +		dev_err(&pdev->dev,
> +		    "%s: Non secure ctlr (Invalid) is detected: DID: 0x%x: SVID: 0x%x:=
 SDID: 0x%x\n",
> +		    __func__, pdev->device, pdev->subsystem_vendor,
> +		    pdev->subsystem_device);
> +		retval =3D -1;
> +		break;
> +	case MPI3MR_CONFIG_SECURE_DEVICE:
> +		if (!debug_status)
> +			dev_info(&pdev->dev,
> +			    "%s: Config secure ctlr is detected\n",
> +			    __func__);
> +		break;
> +	case MPI3MR_HARD_SECURE_DEVICE:
> +		break;
> +	case MPI3MR_TAMPERED_DEVICE:
> +		dev_err(&pdev->dev,
> +		    "%s: Non secure ctlr (Tampered) is detected: DID: 0x%x: SVID: 0x%x=
: SDID: 0x%x\n",
> +		    __func__, pdev->device, pdev->subsystem_vendor,
> +		    pdev->subsystem_device);
> +		retval =3D -1;
> +		break;
> +	default:
> +		retval =3D -1;
> +			break;
> +	}
> +
> +	if (!retval && debug_status) {
> +		dev_err(&pdev->dev,
> +		    "%s: Non secure ctlr (Secure Dbg) is detected: DID: 0x%x: SVID: 0x=
%x: SDID: 0x%x\n",
> +		    __func__, pdev->device, pdev->subsystem_vendor,
> +		    pdev->subsystem_device);
> +		retval =3D -1;
> +	}
> +
> +	return retval;
> +}
> +
> /**
>  * mpi3mr_probe - PCI probe callback
>  * @pdev: PCI device instance
> @@ -3228,6 +3297,11 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pc=
i_device_id *id)
> 	struct Scsi_Host *shost =3D NULL;
> 	int retval =3D 0, i;
>=20
> +	if (osintfc_mrioc_security_status(pdev)) {
> +		warn_non_secure_ctlr =3D 1;
> +		return 1; /* For Invalid and Tampered device */
> +	}
> +
> 	shost =3D scsi_host_alloc(&mpi3mr_driver_template,
> 	    sizeof(struct mpi3mr_ioc));
> 	if (!shost) {
> @@ -3344,6 +3418,9 @@ static void mpi3mr_remove(struct pci_dev *pdev)
> 	unsigned long flags;
> 	struct mpi3mr_tgt_dev *tgtdev, *tgtdev_next;
>=20
> +	if (!shost)
> +		return;
> +
> 	mrioc =3D shost_priv(shost);
> 	while (mrioc->reset_in_progress || mrioc->is_driver_loading)
> 		ssleep(1);
> @@ -3464,6 +3541,9 @@ static int mpi3mr_resume(struct pci_dev *pdev)
> 	pci_power_t device_state =3D pdev->current_state;
> 	int r;
>=20
> +	if (!shost)
> +		return 0;
> +
> 	mrioc =3D shost_priv(shost);
>=20
> 	ioc_info(mrioc, "pdev=3D0x%p, slot=3D%s, previous operating state [D%d]\=
n",
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

