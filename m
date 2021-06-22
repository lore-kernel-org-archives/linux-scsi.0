Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A451C2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 06:40:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ACBA611CE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 06:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhFVGm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 02:42:27 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:31012 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229490AbhFVGm1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 22 Jun 2021 02:42:27 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15M6VJHn028875;
        Mon, 21 Jun 2021 23:40:03 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-0016f401.pphosted.com with ESMTP id 39b91h8bac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 23:40:02 -0700
Received: from m0045849.ppops.net (m0045849.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 15M6X0Fv029911;
        Mon, 21 Jun 2021 23:40:02 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0016f401.pphosted.com with ESMTP id 39b91h8ba8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Jun 2021 23:40:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDTR1SvdV/91pIWp+VhgoGf4vPfIX0XJv/l0Z2wtVFwTf8tpu7U8LGPw2o3M6NCbDIoEDKktWu7L13iMxr302Fa676OUmUVqjhxWIqDV9cyK3QukPqtB1PhWernC61JXXOyRn+VZrNfIj4kf36GuzL0l3DVJleVep5Vtqn2Z/viQ6qx35aTfLdyj/AxeVH2JCpwhvV39yw5PX6lPSZW/hMqGBiuiQddNY37P5CWTu/yTcYe7ybLRowQY1hmr/bHdl5AxJH1ebLOriQ/CoCwKuWloz1ATSOCx6DZV9hJgvv1i6ICXKZ8A4LCznr6kN9ELNA95AVZ2X8LSp52YD87GZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTfjVilNq1KxnaW7cVtqbZim6MedE7Ng7sbez4UEHo4=;
 b=IePiVvpeUtMehT24Pir5t9X3aAclyCAchcOgXPYb9n5TkSZYKiflCT0S6Swz2ZAKGrIbnp9emnpxlmf6MSbwvYfIKloLrftrAuXi1WvNaqFUO4YZWUF+Leo7Hw8aad7To66yoihUcA5n6juplYZfVrzDegwMG3Qqz4pMdfWGDGRmHPFmfP/m8XloLESl0AZ6kQeDGlHeltgdBTG9hIi9xOKJ2WNL5e3jB46+sAqMD4mVtyiRAn1t8VOk+FW1wQ+TMHFC6eP4D2bBOvZMUc3URvVh8BhLZYYDnTJlyNancAcgT/sgs3LXbXOCNXxTEuyCbC9Ye7ILSTuBybfKXKezVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTfjVilNq1KxnaW7cVtqbZim6MedE7Ng7sbez4UEHo4=;
 b=lLpFs9pLaO/VdMRjdTx1wfQ0hYeevvZydLvWvXvyiHTO9afEClhJY3ugl79/vARA+B3V8zbTwFkWb6OmD20fKgqJ217Ulpk8f8HcK3engql9nvE5NHVEn8BKzJzg0msTcINBDfc03KYITyvLwud/jTOb28By4Hvz6whmb3TJM2Q=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO1PR18MB4730.namprd18.prod.outlook.com (2603:10b6:303:e9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.21; Tue, 22 Jun
 2021 06:40:00 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::382e:7359:ff37:8478%4]) with mapi id 15.20.4264.018; Tue, 22 Jun 2021
 06:40:00 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Zhen Lei <thunder.leizhen@huawei.com>,
        Nilesh Javali <njavali@marvell.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "megaraidlinux . pdl" <megaraidlinux.pdl@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v2 1/4] scsi: qedi: use DEVICE_ATTR_RO macro
Thread-Topic: [PATCH v2 1/4] scsi: qedi: use DEVICE_ATTR_RO macro
Thread-Index: AQHXYmIaGtW7RCAW3k2F5t+fuXNtzqsfncxw
Date:   Tue, 22 Jun 2021 06:40:00 +0000
Message-ID: <CO6PR18MB441968D5E1AC6F26F869C41AD8099@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20210616034419.725-1-thunder.leizhen@huawei.com>
 <20210616034419.725-2-thunder.leizhen@huawei.com>
In-Reply-To: <20210616034419.725-2-thunder.leizhen@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.75.141.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e5f9e30e-0117-4a3a-ebf1-08d935488f3f
x-ms-traffictypediagnostic: CO1PR18MB4730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR18MB47301A8604E779865AEBAD47D8099@CO1PR18MB4730.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jq2kVk8wJdVyqO4I0YhPvs4M+g5XIbn/r0RQObPkY+T3bblK/R+qJrJui/G5t6wxxE1tV/13jMyIY96i9b7b8oOygLsb67MJ2EKu/NqtolIrYX+NVt7CddSq2++B2ZosI/r+lFmpVLzssiXAqYFcxo0SbZsttwLfTeaQ7oUcu/YhlwqfZI0kyBObS+O6mkMnTvs/yq1SnGRwypqv5gg9vPt52Snr4ZikUE5DuLn3Guo5z2esJzOdGn4gxCMWowvAGmPA+hGO0r62zm0GsdzWCI717YfxQOF7UJGqF4Tu2/RrUlv2keJgABIo+Gi2d6VCx5Vfaw1U/LgCatSdGfsy16mBnfR+DokUnoFglbVDyEz+qnFiKB5MyVa/Gx8G87Z3FhLHP1da78kRPIw1X4CDWwxST9Znrk3MNC26wXjFgOQCAEgVVUDj8uagbtj/dnFZXhaoizDurIZCsW5nE0tsvx6052TWXO+JtkyG3Gi9r+se9HJ6XOgLOiSn+Z7m5bjaKZerPC/qUUceVTFYSJvuPgenzj5t55GqXdt8d+EMonTmweOOE3r3T6PHWvd83gj/kiULVQfLRn0wu4MqE3d667zpWNUZm3+0oVNKr5IZiqPjFnPb5Q2unctrjF36DXoPpN5pjJBsEcpyWVY46f3NMg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(376002)(396003)(136003)(366004)(55016002)(9686003)(478600001)(38100700002)(6506007)(66446008)(64756008)(66556008)(52536014)(5660300002)(55236004)(86362001)(53546011)(122000001)(26005)(76116006)(7696005)(186003)(316002)(66946007)(110136005)(66476007)(33656002)(8936002)(8676002)(83380400001)(921005)(71200400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0NiyiGcjLIKbiVL/SUN8oqYIxDzCg7pelM+50Ip4oMBFlOa21LlrqU50nUW+?=
 =?us-ascii?Q?cLbWn+Op4yuV3phtuVPE0nrh25vfbXTNB+7g4OBvfNTRKQTFFU/8SfGiIvPM?=
 =?us-ascii?Q?kD1Vpd1o9JXsGw8scSfiT9zmQ067Hjxxl6KDUEjd9/Tz5W3bRuyRno3NAKsO?=
 =?us-ascii?Q?OG4iE47+0WkWzXQOMIEfd02d+yK6kxidXcqW75c/JlQHJ0RWQD4vX4PKB6RM?=
 =?us-ascii?Q?yPI061iqpzfIR69OJvId66pcAOYkyMGLu/9GQsZsGOW1FZnrkbyNAsYkP8OH?=
 =?us-ascii?Q?IvH2iGKvX0rilQyFi6PcRH06cFWeZ0kTOO2dDLUpqXC4pPXD6wqKewi8D03t?=
 =?us-ascii?Q?cBoFlU+7OK8yY8IlB3qfHRDuwYFIOHJ4HvcSPCEHlB3tTc2z8rMbsUHh4Lt5?=
 =?us-ascii?Q?7KHEqupub6AGRH3jgV4DaCVnPu9WU/OtEObuv2sxM3MAGIA+laEeLjfhnVYa?=
 =?us-ascii?Q?6D7qUKlrimerhObsfKWpQNQ3hyjnZPMdiD+h8vDoGbTvEzJ8rpIitbm5znUp?=
 =?us-ascii?Q?u+/DcnesV+OOj9TI2uF3abKEN4iHlzcwXpFwD/ZLzoIvZyU57oRg9y6ZP/Am?=
 =?us-ascii?Q?9dM1NJto5VGUqj+4nSY0wW5SO9upDz+nilMBiq/C9n0jI1vwpbXL2THQDOj7?=
 =?us-ascii?Q?sR9nJpq6TEnwa8vcXVSXl22fY98z3m7lTs19ArdypSP3Al+UmtgEHPqu5Ii3?=
 =?us-ascii?Q?HIpZ4G3llYpg6CAUYLaPNstdO391iClT+aOPCuNu2oDJsaBZfmYlFxvEMaIH?=
 =?us-ascii?Q?e72YtCB1Jq5+K+tYtpZqAkybpylc8A2DYjMwujWM9AAjbqv6BUYP7gsS8Hd8?=
 =?us-ascii?Q?ZOQPKiGpggacYQim734MVyJI+w/dtcLdqeF0gbtA82wcA/qIJ3b7BRnGc2AA?=
 =?us-ascii?Q?cxig4mJdbZRE0HvcgkTkKYxT6dZ7PFEhbDsMD2ljOaABGq+3+Z2deFpKaQVG?=
 =?us-ascii?Q?DZG0728Ypr2SdkopXRx5RwsTG0yLKyP1KAb+qzkqK15k7z8RjrOUpPRI8r8I?=
 =?us-ascii?Q?yQM/4PZtFH6fL7u87nBK66qSTyweQWTDA1mfuDJivNcjhnRDGAV8mS5fkAoW?=
 =?us-ascii?Q?NsoEof1KHzxLq3cvAE8LV1if7YX8VA9UDlzVhzUFep/6iKjNDhIgWu/dmVXP?=
 =?us-ascii?Q?rgExoOp0gfD5I+t+I9LYiGqaIAtmtNgTwaHM5c5eYEZTyrTDRhwMoTjJDTKQ?=
 =?us-ascii?Q?EWWcLc+5O/CG+o09fz3K5jMvKoAyDpKFfbivxPvgq3uoOAJpwDLWj65jQs+H?=
 =?us-ascii?Q?W0JKcS+RFwUwZ6L4pzYtQzJAwAzsKwp00P5H88T5A2TmlS6CE61cIv14fKGw?=
 =?us-ascii?Q?pU/r2jIfJ1jgdY9z/5ok0B3u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5f9e30e-0117-4a3a-ebf1-08d935488f3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2021 06:40:00.4813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mzl3YZuQ/YAjWiomQqG3nBJsDdu7qA4q6yur+d9nPo7mcDVlR2wF+d0259dWb59EUMGRy6jPLv/IqKZI8SDzuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4730
X-Proofpoint-ORIG-GUID: GtnMfOWEChCZPGI2iNFL9RrXvS9354Q6
X-Proofpoint-GUID: 9y7cECR3xzX1PpiIwCC5HItMLhH_-s5n
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-22_04:2021-06-21,2021-06-22 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Zhen Lei <thunder.leizhen@huawei.com>
> Sent: Wednesday, June 16, 2021 9:14 AM
> To: Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <mrangankar@marvell.com>; Saurav Kashyap <skashyap@marvell.com>; Javed
> Hasan <jhasan@marvell.com>; Kashyap Desai
> <kashyap.desai@broadcom.com>; Sumit Saxena
> <sumit.saxena@broadcom.com>; Shivasharan S
> <shivasharan.srikanteshwara@broadcom.com>; GR-QLogic-Storage-Upstream
> <GR-QLogic-Storage-Upstream@marvell.com>; megaraidlinux . pdl
> <megaraidlinux.pdl@broadcom.com>; James E . J . Bottomley
> <jejb@linux.ibm.com>; Martin K . Petersen <martin.petersen@oracle.com>;
> linux-scsi <linux-scsi@vger.kernel.org>
> Cc: Zhen Lei <thunder.leizhen@huawei.com>
> Subject: [PATCH v2 1/4] scsi: qedi: use DEVICE_ATTR_RO macro
>=20
> Use DEVICE_ATTR_RO macro helper instead of plain DEVICE_ATTR, which
> makes the code a bit shorter and easier to read.
>=20
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
> ---
>  drivers/scsi/qedi/qedi_sysfs.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_sysfs.c b/drivers/scsi/qedi/qedi_sysf=
s.c index
> 04ee68e6499c912..be174d30eb7c275 100644
> --- a/drivers/scsi/qedi/qedi_sysfs.c
> +++ b/drivers/scsi/qedi/qedi_sysfs.c
> @@ -16,9 +16,9 @@ static inline struct qedi_ctx *qedi_dev_to_hba(struct
> device *dev)
>  	return iscsi_host_priv(shost);
>  }
>=20
> -static ssize_t qedi_show_port_state(struct device *dev,
> -				    struct device_attribute *attr,
> -				    char *buf)
> +static ssize_t port_state_show(struct device *dev,
> +			       struct device_attribute *attr,
> +			       char *buf)
>  {
>  	struct qedi_ctx *qedi =3D qedi_dev_to_hba(dev);
>=20
> @@ -28,8 +28,8 @@ static ssize_t qedi_show_port_state(struct device *dev,
>  		return sprintf(buf, "Linkdown\n");
>  }
>=20
> -static ssize_t qedi_show_speed(struct device *dev,
> -			       struct device_attribute *attr, char *buf)
> +static ssize_t speed_show(struct device *dev,
> +			  struct device_attribute *attr, char *buf)
>  {
>  	struct qedi_ctx *qedi =3D qedi_dev_to_hba(dev);
>  	struct qed_link_output if_link;
> @@ -39,8 +39,8 @@ static ssize_t qedi_show_speed(struct device *dev,
>  	return sprintf(buf, "%d Gbit\n", if_link.speed / 1000);  }
>=20
> -static DEVICE_ATTR(port_state, 0444, qedi_show_port_state, NULL); -stati=
c
> DEVICE_ATTR(speed, 0444, qedi_show_speed, NULL);
> +static DEVICE_ATTR_RO(port_state);
> +static DEVICE_ATTR_RO(speed);
>=20
>  struct device_attribute *qedi_shost_attrs[] =3D {
>  	&dev_attr_port_state,
> --

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
