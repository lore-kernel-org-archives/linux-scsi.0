Return-Path: <SRS0=+pba=Z2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC4CDC43603
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 15:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7543A2084F
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Dec 2019 15:08:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="T2aF3Kp9";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="nNsaKSAb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfLDPIV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Dec 2019 10:08:21 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:17430 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727889AbfLDPIV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2019 10:08:21 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB4F4f1g010625;
        Wed, 4 Dec 2019 07:08:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=fborGbvYfVQkraV9d5TLHLJOH+LOh7c1K1mSTXqqTfk=;
 b=T2aF3Kp9ousm0qDk74Cc7IbznEXfSuY4cy+pX43yt2HZ2EIzh8P23XKQPykIRJH+Y/Bv
 JNLUBr/K0dY64Y9AIDAAOMCk3H2gwOX6uVzu81WDCyPuERaN903WibQVRrdTIZ6W06lI
 BWblTvpRTbSBtQ6NMvsC8k4gWxlEIAcKB/c9hmTtjP0MqMCTiRq/uYdoXtEUjUMeTyfP
 Qw+6eIkE+6CM0EMbHOWg/5EeEdLZYvP/9ShwrdGbXH7VvA610mB4oay4oef/nZIsMk8K
 C98uI6Nzj7NOwf8fgmqHPwkNfFiNDkPJzEmiYNbjkTwl8TTt6WGkzLh0hddyVqpMand7 0w== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2wnvgvmhvf-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Dec 2019 07:08:13 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Wed, 4 Dec
 2019 07:08:11 -0800
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.55) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Wed, 4 Dec 2019 07:08:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJbQ30c//pWwvqA0A6DLVLl/lVxDF1YMmMg7umkRWQTQHWEvR9klRw+kfER7RIcqtQ3kYqhi/noO/y41YA97+X+yQXjLUUyn8OR7dhRJ8WWq8iPCXp7l+QoEkp6nQ0qGsQQ8qei1ry2PQ9qVj1X7citdYOxcL4LEm+VRiq9ZtIQahi1KQUDykPF0BZdEgJncqk4xPE6EJ/Lbn7B/1kA1R0vNuh4sqq7hNuqGlEfHoKiNDnaSIJTYmzBAilk+rH+RsHJoYA1sPc9wc1aC2CoMgu/cTMOSSz9SLinBcTAgJuD/NBTqpstfH+aVDL27AwmbWARavcDxnI1jW9VunW81LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fborGbvYfVQkraV9d5TLHLJOH+LOh7c1K1mSTXqqTfk=;
 b=YiT83vM94OfDWRMXTk6sNTvYQm5TA0muybhO/DfskRkG1fmXMYNdHH+2PcdI93WDdRsICPS0TUeZ7UAUIQCLObedvg31R9rm/JoJWAOsgMARnwaCf6GSzWbTgPhPrD0Y1OnRFvOos+RhNGtveajhzwT9WjROVm/l0u0KkXqpoDj1cAC4DffEzOx2HJp1zEDOP3sDBjZq/p9OeklRjMG42mv5txWSBxNIPPW7ax/OEL/cdGOovsmn48LBhVyiMMGrhkdM767am2/vu8a988X4gSf25Yw9HyRei7tZEIeyQAaaDI0PT6tU0WxMNMfVAlzp7eAYuHQ68xoZm/U1/YZbAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fborGbvYfVQkraV9d5TLHLJOH+LOh7c1K1mSTXqqTfk=;
 b=nNsaKSAbrTPS4MN4wulc909LtSUZuCGhNMQcry7c6w6WdGuoiuIStktQNDTIBURAUvZn5vK+bu/8XKqFcRiVsmk8gOu8QbgWxGUYf/gjxD0cDvUI4EKvXlUoDBRrSOYJ/Bxt+xV5pjW6Ga3CTByaCmsA3GecC7ZMlqe+Uo3hMbU=
Received: from MN2PR18MB3022.namprd18.prod.outlook.com (20.179.81.79) by
 MN2PR18MB3214.namprd18.prod.outlook.com (10.255.236.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.12; Wed, 4 Dec 2019 15:08:04 +0000
Received: from MN2PR18MB3022.namprd18.prod.outlook.com
 ([fe80::50f5:6e56:bb7a:c6a5]) by MN2PR18MB3022.namprd18.prod.outlook.com
 ([fe80::50f5:6e56:bb7a:c6a5%6]) with mapi id 15.20.2516.014; Wed, 4 Dec 2019
 15:08:04 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "QLogic-Storage-Upstream@qlogic.com" 
        <QLogic-Storage-Upstream@qlogic.com>,
        David Somayajulu <david.somayajulu@qlogic.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] iscsi: qla4xxx: fix double free in probe
Thread-Topic: [PATCH] iscsi: qla4xxx: fix double free in probe
Thread-Index: AQHVqb5xj1Jvw0WPY0aGPn90JQsn1aeqFX0Q
Date:   Wed, 4 Dec 2019 15:08:04 +0000
Message-ID: <MN2PR18MB3022879D8451A01AC7B0894FD85D0@MN2PR18MB3022.namprd18.prod.outlook.com>
References: <20191203094421.hw7ex7qr3j2rbsmx@kili.mountain>
In-Reply-To: <20191203094421.hw7ex7qr3j2rbsmx@kili.mountain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [116.74.183.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b083bf4-866d-4cd5-9315-08d778cbc33d
x-ms-traffictypediagnostic: MN2PR18MB3214:
x-microsoft-antispam-prvs: <MN2PR18MB321463296A69FB0CF94BFC50D85D0@MN2PR18MB3214.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(376002)(366004)(346002)(136003)(13464003)(189003)(199004)(7736002)(11346002)(55236004)(6436002)(102836004)(229853002)(76176011)(186003)(26005)(305945005)(7696005)(6506007)(53546011)(74316002)(81166006)(8676002)(66446008)(3846002)(81156014)(66946007)(66556008)(76116006)(64756008)(66476007)(2906002)(8936002)(5660300002)(52536014)(55016002)(54906003)(9686003)(86362001)(6116002)(110136005)(99286004)(4326008)(25786009)(316002)(71200400001)(6246003)(71190400001)(14444005)(14454004)(478600001)(2501003)(33656002)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB3214;H:MN2PR18MB3022.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bh734a9JGZie3rqUw+TGLRoOsB3hmdGwiqir2r5KNFCqaHIsHHuVgOHAi6y+G2iAJ32eomCtTgmEELE2X8E8I2oZGQFFR3huQzpxu8XOZwxY5RRwcli50d+8/N6nhaUrChn3VNJFFISZ5du8tzFuSN+3OXJ3GZpIsx4nfotStmLRo+zKyIxe3L6JLfCt6buo1BKlfdOD3IUM99ixgv/Y4Zd7KiQ2/ENHrrcMRacWnwtTpXombgHEYgNDnAS/1c7css3H7A4KwaOno2hN1v8iEtCGG/Xr+048PhfjuG0VtLlpQ529lNVvqC5OpLAldDlTObxykR9RIYTItFy92wsZldNZRx48q+3xlwalvtWb+oxq3rSO0c/IFM7+CphRPAAmnx3Prpg++SG8uZ53mynYYlkZqz7IWDkV8V57DQBxwh4vdSHeO4Mhu0HvazL75oDNDypBRJvb+zx8pVC1K/S/SWOfTvMp6FhEpNtzrdSS+HNfvN4bwaalpVFP7CVII9DPex1eXJbw7oJiw/NS505FRQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b083bf4-866d-4cd5-9315-08d778cbc33d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 15:08:04.3872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r/n/4gPVK4nuqU05ygMU0n6+WbLHhplnA/ddbsksNWRlADrvWSxDTFK/tBpTav9Tx77sDUTh1kB+CpJOrBRYDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3214
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_03:2019-12-04,2019-12-04 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org <linux-scsi-
> owner@vger.kernel.org> On Behalf Of Dan Carpenter
> Sent: Tuesday, December 3, 2019 3:15 PM
> To: QLogic-Storage-Upstream@qlogic.com; David Somayajulu
> <david.somayajulu@qlogic.com>
> Cc: James E.J. Bottomley <jejb@linux.ibm.com>; Martin K. Petersen
> <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: [PATCH] iscsi: qla4xxx: fix double free in probe
>=20
> On this error path we call qla4xxx_mem_free() and then the caller also ca=
lls
> qla4xxx_free_adapter() which calls qla4xxx_mem_free().  It leads to a cou=
ple
> double frees:
>=20
> drivers/scsi/qla4xxx/ql4_os.c:8856 qla4xxx_probe_adapter() warn: 'ha-
> >chap_dma_pool' double freed
> drivers/scsi/qla4xxx/ql4_os.c:8856 qla4xxx_probe_adapter() warn: 'ha-
> >fw_ddb_dma_pool' double freed
>=20
> Fixes: afaf5a2d341d ("[SCSI] Initial Commit of qla4xxx")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
> index 8c674eca09f1..2323432a0edb 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -4275,7 +4275,6 @@ static int qla4xxx_mem_alloc(struct
> scsi_qla_host *ha)
>  	return QLA_SUCCESS;
>=20
>  mem_alloc_error_exit:
> -	qla4xxx_mem_free(ha);
>  	return QLA_ERROR;
>  }
>=20
> --
> 2.11.0

Thanks
Acked-by: Manish Rangankar <mrangankar@marvell.com>
