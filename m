Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 596C1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 15:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CAAB61051
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 15:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236449AbhKIPPC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 10:15:02 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50898 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231272AbhKIPPA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 10:15:00 -0500
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A9EigX6015325;
        Tue, 9 Nov 2021 15:12:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=7f1ojOYqoBPhB+b+BVAuSlBD6piagKJIjxJ9IJ2u2KE=;
 b=hYzEPMouLWNH4eupgOQXJ+PKy7eQdhEJNvQ1qdVFp+wRLbzB3d+nyFMwYSuWKArvm+nv
 reWPxoqWlK+grtV3a22i2KCuYjIbplU3AMuiVXjW1/jGIaUPDu8TLv0r+hB3wD+eLAu0
 DUOHRYCFgUGYdHbc3ZTkSY9OqwZNaIky4/W8y7IeNt2nF2+twxOHusaTwejkMPJpcVKo
 SnsNtrwvllnFDwFOCjvoOmqNy0/0Md9FsT10+u/3Gn8j2JHqMmegO2rNdZb110pNozaj
 bvPYCsETbDjpGRgFuOapaMsd5m4IFWTs1HGSzW/6LShC0Aob0zpqURs7DxMYGHQrPgCz hQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6usnk9mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 15:12:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A9F61bQ116615;
        Tue, 9 Nov 2021 15:12:04 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 3c5fre31my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 15:12:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgOs3uJ8nzXHnNAc4ZIritGc7WrBMjR0rZ10TPSjqA6UPjl+LDdB/8cxHyX3bUwjgxO51wce3rSq8O5odxQoLoCIBonBY48/J0lEoBDEzAA/oobF4uSpU/TSizjUwMrD1TmP5MP5Xw5+hcdRo2jZDEuuG6sdEllvfhRUJ+WAAfGhjoRvhRYhlPxkBQhQsiibi+g6j4CDo9NOW/ASn7KiYqxkwS/BULj3WCmf/nqchtQOFGEEyxlGrfZAqrid+BON2URopyFMuq9+zpbqlJ35DCqOrayehAQOQhj1t6JT4pt0YNL5PGSllKrzRXCuEUB7+rMvrJI78u6K5I3jh2vUuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7f1ojOYqoBPhB+b+BVAuSlBD6piagKJIjxJ9IJ2u2KE=;
 b=U1rGJE+moypXwEOdQKwZIOTlhJUYSEqVa6zug5k/IMlLsgbtXX4mh2aJa9qWaQe6JNvWM4MKALb0blFvUldfSMaYqQRl071FOcYWX4XF71fWa52j7gGz1s+2zlyiBvEdOOxtFce+NKASMVZ1JgRBw1OhZ9U+tEy608nuP4csEvSPfCWc+23y+jLAoAaz6iB85vcZ6DdvRSRKKCEKNk+/7xDjPqoVHUWQ1hMMahegcUBKKc2TX74XNwWXZhHClF2B2gu1omu2pnS1z4ptuJ2sD1GIP2CsSivILX3yb57ENAv3s8EticoqgDRRMgaF3SlHmGx51GyA3gCdnm2ZxAKTYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7f1ojOYqoBPhB+b+BVAuSlBD6piagKJIjxJ9IJ2u2KE=;
 b=HIR51kd89/2IrWm+ipuXxC3fHFNXVUf/eg2OF8YdApaPnCN2PwCjmCwZv6J61er0XKgQe+33wvHO/JzF+1U9ybdgNP8aCKqXrD98R32oWDwZpv/1mwxyndwR3FRHGL3WZ520lzp+t2u4CIceYb+CqruV49tr2gR7Oh/lTjh6XTk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4459.namprd10.prod.outlook.com (2603:10b6:806:11f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.16; Tue, 9 Nov
 2021 15:12:02 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::5dd3:803d:4c46:2d08%7]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 15:12:02 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: edif: fix off by one bug in
 qla_edif_app_getfcinfo()
Thread-Topic: [PATCH] scsi: qla2xxx: edif: fix off by one bug in
 qla_edif_app_getfcinfo()
Thread-Index: AQHX1WBI7MQICD4cFUGMEsmx7r2sUav7TYqA
Date:   Tue, 9 Nov 2021 15:12:02 +0000
Message-ID: <6C6F1560-33F8-4913-874B-19E3AAA37A85@oracle.com>
References: <20211109115219.GE16587@kili>
In-Reply-To: <20211109115219.GE16587@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ee83e89-e951-4391-04a5-08d9a39348ae
x-ms-traffictypediagnostic: SA2PR10MB4459:
x-microsoft-antispam-prvs: <SA2PR10MB4459178FB8723D7D52E81AEEE6929@SA2PR10MB4459.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Najcz/+V8TXfUDonkfzYd1peDdnoqCvMkLcqqzGneotvLmXEY5JOs5ShsQF1/OFhoTrb10dixubWLzgOFXxgVaTgc//MvVDRUnmSiepVpFDLp+QnViKE7PQnMn40TGdH3ED3PjNoSPz20yQnid3GWx+Vgk4uFUgLZlN+P6t2D7jknX6ODTGIAEjqC1DH1+VEKiuvM6AWwIERUlPXT6oAgICDt2wx8t1hvFArFTXM6x8/HUQuakzsxsvio89frjxX9hPcz6meTo/R66ab6OHQYLRXYpKcst9A9bynj/YECGsQPdXSSJbNNYS5CVU/eIDboLXH0IYfRZL5O/iaF3KbJqGrm2b20MeigosUNIPC3bSRRnJal3Z8omBvrbSZozfQgRchgIrdBGpI6pPB0ewYKmABsgTBGL7Erib7EHC0eD69MXEsjydgRl21zpgc/ieJGdnCw322QGlGoI9R51k4i1iFvJ1L5VgqTLq8Xpq196YOq10gy1qaNxMMhQoIkLuKddaSxwbl24uWHkL4BB0o0mad0vVenLEP6V4YVPiAjsfIs2q2o8lN8bWMcgnoF8m7XO6M+TeRCZBEI3OVB0VQKecpS6/cLyGQlDMuO7AIft6iM2ql/SP84dI2lW4dmv4ArDy4VdqLT9jGenNN5Q2wLeKZT5/662duaeZZ4YmXKk615x+lHoUpjcxlPfbRP/9cFMPtu8ThUA6O0VTxo950WGb0AwOACaaq1ITMuwPfbFLS66VM71WpVyxgGUhVr9Ag
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(86362001)(186003)(53546011)(6506007)(76116006)(33656002)(6636002)(8936002)(38100700002)(66946007)(26005)(64756008)(66556008)(8676002)(508600001)(122000001)(2616005)(37006003)(66446008)(66476007)(4326008)(38070700005)(5660300002)(36756003)(71200400001)(6486002)(6512007)(83380400001)(316002)(2906002)(54906003)(6862004)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?qh2wcSekjJeyNSJHY3NgZiSDp5a4DUHRRLJGfYo2yNcGpNiz8rPw+ntMat1K?=
 =?us-ascii?Q?aG1Ga7MOkQOHeJC7L/0ccJkZQpw2mwy7SbODBJkGWFSP8k2j+fuZXdcykliX?=
 =?us-ascii?Q?vySkk83GkcWiryZdtnTTXz9uIrkf7QwB88QIlCUrEVm99Wxm08WN63g5eARI?=
 =?us-ascii?Q?uWkDl4XeLrY0E7BpUKSgnNO4oLlunCOPdbIpYDiTXXwI0sEmp3Ra6u/galZ2?=
 =?us-ascii?Q?F+TpL0KeicM3C00WBDs6SmSZKv8zWOdtivinQ+duqLju9ewoWKagcv5qBkkq?=
 =?us-ascii?Q?1fDuX/PzDdFONx1g5e6+sg30tv1UJOORwiy5VRkmGdnyyIYdWW1+SCKMGQ6v?=
 =?us-ascii?Q?UZpuPSaZ5IVLGzhLW51BGW2BiYP/79jY36StvZp4Z3aOp6m+1k+86jY/zINq?=
 =?us-ascii?Q?H1vwy2ZI4dJKOJSOb94VjO+B2BFACIH25gjmgK3Qj20qY/Wi8DEx5B5hrzr4?=
 =?us-ascii?Q?jU+Rs9A7YQthGlM45axv776yq/35ozdsl56+NKoV3MBzY14zKl6vZjeDJRP3?=
 =?us-ascii?Q?WnWuHs/Qo1YvttenS8AtgUEFEpN8xhWgLGnEw3JX4iKTJoZwj3Z+gUGvAvtv?=
 =?us-ascii?Q?cUPLDl+0/gvrcAsFVFcnGmlIplTIQS77m04t3S9u6TW0mywumoTyettPMTB/?=
 =?us-ascii?Q?iSaRm+vgaZDFp7hW95vsTUrK80X5WS3hscJPaplGZCTqspgpfVgBfsWNDBCe?=
 =?us-ascii?Q?XD/fvqz9R8pTFlaUpnKhnh3M1Cc/cnfx1sdrOhTnXonEonf9VEOPNB53BKQ9?=
 =?us-ascii?Q?hPIa7eeVKIwZLAf1Iab87WTpph/kgHaS69T62eJqkYwOSro+toYqu3BLMUM6?=
 =?us-ascii?Q?Yw590SddD+q0tPHVBk8aqJ22u0eqJ5iB01mXZx3RdrrgR7+kjxY33hrnxD61?=
 =?us-ascii?Q?N+bdlre/DW9ytI1hYMj3k95gnvN+52Kw/ElgX+74swpPzeqHoncx6mx1TETl?=
 =?us-ascii?Q?XLOiYB3NgNv4Ulh8eOT3a1Rfx5JRCuD6sY7lewvgZhU41sNcx9Un7DHL7I5N?=
 =?us-ascii?Q?71qBpI12Y5E2Z8V2HF7j9CHSynBZjWFH2AIVFyNGFyNGEXkHf+xPF6S11uBm?=
 =?us-ascii?Q?w5+v4ZPFc3uNKz5imQcE3EqdjruOKml5OZgZpzvmA21o63XM19Xi+OwGdvTs?=
 =?us-ascii?Q?ZwO3ch4BZoLT9GnTGyYfy6OvLtjR8TjDJHIzgBVolshxIavEfx6cf1+sQXEb?=
 =?us-ascii?Q?7C93gXcpgPXFSH9jHssgAMFiNJ981O7gZVUT0Wjs4eKdXWMsx2gbLWmz5NDk?=
 =?us-ascii?Q?vInj3GeutslaUKK2ZuZY3OQUsCoPNPPY3eSH+TnzZC/pvxW+V0VzXiIFiZF3?=
 =?us-ascii?Q?ZycSy/8EUd1C86Im0Yym5nOBXNgeTFiGmCxbI4sV7GJ29zRruxsB1mgU6KVk?=
 =?us-ascii?Q?xUXxniIEh3njz3wo8jrhrLobIgPgaUQpD3PkQIousXtqOoN9lpM1KfZu6Hms?=
 =?us-ascii?Q?pDypk0T433CHGiQletrwKXAhxUWGf1JHBrurWdbd3Se24RJehnDRz5DsyGsR?=
 =?us-ascii?Q?wmtZoliB/q6nTOfl5Q0aLMWPzl1n+vzNtNnBvVBBOTN/URVl3voVOxo9jFT5?=
 =?us-ascii?Q?1IeZonAUlZmhTTeGamhCt5k3mtQD4swQ8Mp3wraVmFQUdaVlLloCZ/GN+C9H?=
 =?us-ascii?Q?3IzzjtnW5qf1Ore0IQ9067CIh4mLHEyBi38l10oQOnqh0vZaY0Fz3+IUPVJM?=
 =?us-ascii?Q?bCVn7DatLe4XD6Dwixpfnc95tag=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20AE61C2075B2C44AFE335696A8F3DAE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee83e89-e951-4391-04a5-08d9a39348ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 15:12:02.3860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6lReug/6RmmuXg7t5CYP73ynnXgSLe8TGkTE+UrUMY+tW05NGOVHBFKMQROSL8FYtkDbuGaagPb9euDYNq84cl5/l1yhw/pRGBQf2KR168c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4459
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090091
X-Proofpoint-ORIG-GUID: 1H8Ve4-4eoCdJCU70OrHk2-8hSLwc5Ya
X-Proofpoint-GUID: 1H8Ve4-4eoCdJCU70OrHk2-8hSLwc5Ya
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Nov 9, 2021, at 5:52 AM, Dan Carpenter <dan.carpenter@oracle.com> wrot=
e:
>=20
> The > comparison needs to be >=3D to prevent accessing one element beyond
> the end of the app_reply->ports[] array.
>=20
> Fixes: 7878f22a2e03 ("scsi: qla2xxx: edif: Add getfcinfo and statistic bs=
gs")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index 2e37b189cb75..53d2b8562027 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -865,7 +865,7 @@ qla_edif_app_getfcinfo(scsi_qla_host_t *vha, struct b=
sg_job *bsg_job)
> 			    "APP request entry - portid=3D%06x.\n", tdid.b24);
>=20
> 			/* Ran out of space */
> -			if (pcnt > app_req.num_ports)
> +			if (pcnt >=3D app_req.num_ports)
> 				break;
>=20
> 			if (tdid.b24 !=3D 0 && tdid.b24 !=3D fcport->d_id.b24)
> --=20
> 2.20.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

Also, I agree with comments from Ewan about the ql_dbg(), it needs to be fi=
xed as separate patch.

--
Himanshu Madhani	 Oracle Linux Engineering

