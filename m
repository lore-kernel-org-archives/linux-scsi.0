Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14456C4338F
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F17C360E53
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:21:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242143AbhHEPV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:21:57 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:31360 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242072AbhHEPVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:21:34 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FDYTi005329;
        Thu, 5 Aug 2021 15:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Om7BMcdvysgse2W6y52Fcyelzb/jLRar7OR+vKKNQ64=;
 b=y5FEnpvpHyxktFwAAUIKuSb8dnVtN2fInChKryjN7e/TQUw4rRi9r+NlzR243e4wYyx1
 bBeRPWDRbq01grjDDiBALcHzbF2w0Nfgd+5M6tfX369sCQOa8eLv9sfSg8RTCxOo6dK6
 +McbkeD6+fMrr1RmFGjkiRETKQcCaWZx9jM50aBD6KGyDyxEn9gfzOwP83AJVCWnNUM6
 ReRSjRmyGrm+ERERhTSsTVIoEokK5z5BzVzfesFnYPzQJ/gFY4OeQiDjdjUfiy4oNQW9
 nHCmpkQSko1WZNpajI6ulL5xmh+f+oWmkSVLiyEUR8fFkzBmfsAhwj5tiTeVQOZSMrNs Ww== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Om7BMcdvysgse2W6y52Fcyelzb/jLRar7OR+vKKNQ64=;
 b=b/W50x7yu198KMIwcVuKZaWMFqnZ53Kh1Ip98nJwGsbood/zOZUMan1HABLnmgFYb/SB
 cHWStjGFJlPdJhD456X+f6FF6ENegakP/jEmpGOUp7qxxamoApTnfkLIugleQqOKhBFt
 QwAHDjjlFJmebkcIbAmKRjzMclej+kfPfud+n2uoQ0nyV+Wi6iaQK2xuHwUR+/d+mhkh
 uyiGUlWuh8ycmuNQFaqgPKKuUv9PcaDIR1yHE89plsdhYNBqMWvRTgQxJ6ZFR7OIx9WQ
 /g9quaBmZUWHCiirsoDoPQXXBNqqNW5srav3lE06zXIOELaFjePGi/UbUkuIMV35R55R kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7cxn4kfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:21:08 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FFb5c114252;
        Thu, 5 Aug 2021 15:21:07 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by userp3030.oracle.com with ESMTP id 3a4un3xyta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:21:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PlLpNVlicqhsqlo5zABiFIKzXL+t/AIOQkFeRLTbQF53SZc2EhokhftVk+xr1A/4BMVGrpQJWzKEwBANFI2ms2+GQrFJ1yo8f6thURY89wCRIX1twLtSCXyAMFA4Nx/iXyrCUWcNLvKKhblrM5yWC5RypClXbJwY2TxLM+yKsEgCmE4g0BJq07css+HMRk4HikRtc7gOy96pYKvomg2HFHR6GDFg5YFyFdAZSnjEtyTt1kQMP36bZhhPxixB2e6vbVQFs1APERwLFqQFKtd1D99nCFucw0oNRbEz9wCKFHq1I3EQuhlsoY58hJZmuEPLng1PY/W6TiEmxnsoZ+Z2gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Om7BMcdvysgse2W6y52Fcyelzb/jLRar7OR+vKKNQ64=;
 b=FfbWs+AEQHUTaSYO9xoLq9DgohoT6AYtt/DpK8koepKsZHeC683XR3Q94+YZdeA9VIQjemzv+dPL8WYysxK2WeFPkSSdUNbSPJLGrdP0Si6bFbZUZT3s0YqBzhAWeNBikPfNMGGCb7kpbLHJDEJbGrRl9fSPtLor9tEEFb8gW061fRkb6TenSd9WDuRk6mFhuLTqcfFTPnFYP/OdUOAYiizrtK4gOl9VYasYbM7pcKg88PryI1J1WuGIOn9DnoV6rLibs3L6qHaKAk3QnW+wSKwsLOEmsbajo2prvJc8qomsK2EPe2KO/7hgvHV4gQ7y9Io4b1VBZAzONjJP5dlWCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Om7BMcdvysgse2W6y52Fcyelzb/jLRar7OR+vKKNQ64=;
 b=w9sQlTx/FQrdOUby0jIhjslRxjaZbmZTgEloZDrzZeIOnb0mqRXGNtmw60aQotKrIR48yjJff5Us6DsxiFrQLJQ2bkjjhOA/I0tYYL7dDJ3RQwxVQCU8ThIqikIePL0NLdGD3wt2cuUwswMbU/KNhAha4qbsPKdTWHYmzblUB18=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3454.namprd10.prod.outlook.com (2603:10b6:805:d2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 15:21:05 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:21:05 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 01/14] qla2xxx: Add host attribute to trigger MPI hang
Thread-Topic: [PATCH 01/14] qla2xxx: Add host attribute to trigger MPI hang
Thread-Index: AQHXieOZE1oonHXkXkmPCbQyHxh1kKtlBzsA
Date:   Thu, 5 Aug 2021 15:21:05 +0000
Message-ID: <D4B29795-29A3-4DFD-82DF-9FFEE8BCDB59@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-2-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85913a34-0cfd-409c-6d4e-08d95824a47f
x-ms-traffictypediagnostic: SN6PR10MB3454:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB34541B2E4B2C3F42C43FFB19E6F29@SN6PR10MB3454.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1186;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: idvTxio7CSu6bpSeqM0g5J9F+rOwkq6/8tURn7CMVd/u/cjT0dUo4yv53+R5qL2wLupC9FgAOYcj3bRGwFDklaBezAipp3JCJlJY5StgAwB/oxG3OCIkWUYSU79ECRSKxZ/gFWuubJfSm+ikBRprtQIV3inpEhEQo6JlOVUrMjc1V+91IV15X9YQB3Qb6JlBayC8UIWmv1pw9bljH7VJsJM+YPTcHj/tszCHUlSCKDvSoRWJUdNtS0ddKLL5cWF8geq3DiwWCki53nEnQ/kcd5sUc/0bgOxtXUOFAc68iWyky/5u1wbe4DFHwo43fI4OhgFEKJCzY4EGF4dVcj4XVo07XuHx3r0ztXAk41KqmJoMHWxTfgtUxAkMXYMpr6APmwHRQjS3wPOlaxWMDsZSIEtq6p5JJSxEplPgZHyDn3xiV0KG3N/6fVvvQCGSjoJLBeARpnw4zTkfR9VwZ0KRM7wqHsaWx3xW+UsxrPWqfjE77I51NuYWNyslQkkxTBvpTFF3PiXNANQf0acMt3IWNmmKEie+uTV5/9n/52ttc8KQ3MKMZFwaYlC+Vub8muA1dyhpxshzcaMPgGDFSpeVf9POpJmaYEsG4gB0KOHO3hL3hmtMb9GJxyJCSwXp38ytWU7tkwZ0tz6e2AIzvAhqmg9emLmyTFjhdDhELnFBFr1nhHtloGlOUr0s8YunBna3TSjraJI8p+1YC+lkr0KxgsLrUld3sk8ro+P+dpv67Uc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(122000001)(66446008)(38100700002)(316002)(6916009)(64756008)(66476007)(66556008)(44832011)(76116006)(6506007)(53546011)(38070700005)(6486002)(8936002)(2616005)(186003)(8676002)(86362001)(26005)(66946007)(36756003)(71200400001)(33656002)(5660300002)(54906003)(4326008)(478600001)(6512007)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DEEH8eQm1WkuFxCyZ91yfrq41++Jg84Q+mzfbFFXx4P5AI8hXMb6vPgx4piz?=
 =?us-ascii?Q?rqA8PxADQesOqH3E+FlNz8N9wh3IpLzGMZkGN75r+6SQ5kjxSf0DGsEI4+4b?=
 =?us-ascii?Q?HzsnKtoq275y/P4rzhkeC9sSqOlK8RqZmUXQPyy+yBOkWcmCOxMvIKHEKxIn?=
 =?us-ascii?Q?D3ToPJ1Y6GQ2+1/HJUKuw9hs62PcgZQBHPhyK1LY8fMHj+A+kx6rxAeVoqPs?=
 =?us-ascii?Q?rIO/IxA3ZrAgPmAIzT+Akn3Rz3LCuqhO/rSTayYzrquHLq8O1qmqKzIZZB6w?=
 =?us-ascii?Q?fFVOViQdkPHJ+Nwx+2MAViY616RW73UCB6Te4Dat3jyM4j32ZWm7nHzpgHV9?=
 =?us-ascii?Q?yYaGxMM6hBGerd1KvxwYQcy9C4FahV3BagtmWCvDmDN67LhFoo6agptPGiQy?=
 =?us-ascii?Q?vhWOVq4BdOO0nYiXAo9pB85SlF6Ki20M3xPGfAPOwijFN5xn64ak3EZKcNJa?=
 =?us-ascii?Q?M+ABW/FEeasxB3CFuWHVMFp7qAMoZ+A0muk162hVsRMkHDRMaPapN2K1nv4k?=
 =?us-ascii?Q?RK98N5j6S3RLK3247kjYwBhvKwxuJv1pEwVg4ZfZtl+4ozk7SC4+zyW2G7ii?=
 =?us-ascii?Q?Fba2BL4BnfKQ67TY63fgoc1ZD0fC78UJ76b1LOcb6jMDHm1pbrmW1GOu5hjo?=
 =?us-ascii?Q?sdDQwwXl3Mdn8rEzN6NXVdGO4swmaa9RaI9dKQcDa1nC8q6ruH6RpJsEjkLR?=
 =?us-ascii?Q?fgM5cw2xS2s82UCXCH0RIjvZOsQ1PVXtjG6bnx6+BCxeZemwqlaeCCAsGQse?=
 =?us-ascii?Q?dayEcskT5zGsBkA8XTT//v5kvmwJhs9nV1hzXGS6LKlmZwqFOd/JBc+C2UAy?=
 =?us-ascii?Q?7KZtydOuCtnKpJE0Tkq4Pq+AclRyRAw7aoC83WJLr65BQUc1KCW6IrDR3ueV?=
 =?us-ascii?Q?i+1p6Cc8FoG7gAY6jsP4UXQv8bpcbYMmVKyZLXlt1HULcqXHEB/WTC6P9Ix2?=
 =?us-ascii?Q?sye8AbQ+JCBPKLH2mzRFEuzbIQ1QYkjOT9S8NTc79gyGcuzJ7wdpjLx0Y9pd?=
 =?us-ascii?Q?WY40WPfIdo55fQulHwyoqEkeGA547wMzDp0lQK60kv4jCSEi60bmk6ItFeMQ?=
 =?us-ascii?Q?vkvimr3RtolV3hDKUMk1EcWFKRZ/ctA/Xme+OpDdHHHzzFfupQP7oIYuzje7?=
 =?us-ascii?Q?IdFsO0adojdr6edBMJvvzNwNpHInFBOKAb4KM6LYXkLdnRT2g0DxlYWytiMS?=
 =?us-ascii?Q?+LEplASuHjM/lHjrXCUP5A8jwKXrCTsOkAFdjTLBk54XWyLQCaiuiUWnjUA7?=
 =?us-ascii?Q?xHv+LfqOFdgDmefnyX+szhBjaXF+OY66LfXFPbhpOhDKP0iCtL2ZPgcO2R6m?=
 =?us-ascii?Q?rDbiRxJDndzes9hP5bEQG2d2?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3F07FBA6DA300442844B1079E1A0C2AE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85913a34-0cfd-409c-6d4e-08d95824a47f
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:21:05.0787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nneDqnD/pkZIGRxI+VxIPgaUFNzu8UpQce2BhmrIEOlrSZ+32Mz5lxxpG3ZM2DyV5d0ijrHy7PboYbJ1ngGCfyMzAMg7P4D6c10pJbZL0Ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3454
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050093
X-Proofpoint-GUID: cDOItyr9paS6zB-Tj5x7xi-XU56xRfVc
X-Proofpoint-ORIG-GUID: cDOItyr9paS6zB-Tj5x7xi-XU56xRfVc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:19 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Add a mechanism to trigger MPI pause for debugging purpose.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_attr.c | 25 +++++++++++++++++++++++++
> 1 file changed, 25 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 22191e9a04a0..4a0a5b4e688d 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1887,6 +1887,30 @@ qla2x00_port_speed_show(struct device *dev, struct=
 device_attribute *attr,
> 	return scnprintf(buf, PAGE_SIZE, "%s\n", spd[ha->link_data_rate]);
> }
>=20
> +static ssize_t
> +qla2x00_mpi_pause_store(struct device *dev,
> +	struct device_attribute *attr, const char *buf, size_t count)
> +{
> +	scsi_qla_host_t *vha =3D shost_priv(class_to_shost(dev));
> +	int rval =3D 0;
> +
> +	if (sscanf(buf, "%d", &rval) !=3D 1)
> +		return -EINVAL;
> +
> +	ql_log(ql_log_warn, vha, 0x7089, "Pausing MPI...\n");
> +
> +	rval =3D qla83xx_wr_reg(vha, 0x002012d4, 0x30000001);
> +
> +	if (rval !=3D QLA_SUCCESS) {
> +		ql_log(ql_log_warn, vha, 0x708a, "Unable to pause MPI.\n");
> +		count =3D 0;
> +	}
> +
> +	return count;
> +}
> +
> +static DEVICE_ATTR(mpi_pause, S_IWUSR, NULL, qla2x00_mpi_pause_store);
> +
> /* ----- */
>=20
> static ssize_t
> @@ -2482,6 +2506,7 @@ struct device_attribute *qla2x00_host_attrs[] =3D {
> 	&dev_attr_fw_attr,
> 	&dev_attr_dport_diagnostics,
> 	&dev_attr_edif_doorbell,
> +	&dev_attr_mpi_pause,
> 	NULL, /* reserve for qlini_mode */
> 	NULL, /* reserve for ql2xiniexchg */
> 	NULL, /* reserve for ql2xexchoffld */
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

