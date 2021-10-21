Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22BA1C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:58:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02592611F2
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 13:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhJUOAn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:00:43 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:57458 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJUOAl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:00:41 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LDhHls005276;
        Thu, 21 Oct 2021 13:58:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5wPFW27jHN+mZXJGNlpWAUvO2a4iyc5HflJbIqC1iHk=;
 b=zOyWyq1XKRw+Ekhq5yBbHa7vFYVlooh21pqK3y/iHt0r9RaavkmmsaGj/Snn5+Bv1AcJ
 UgKBNIXb+Ni8QJGdNovfqPUCX+ydZgWkwhikVf8vMaWfgtRI7fOzJVyoupBJY1ch1FHI
 qiuDsBks/wGRrYfph6sauwMM+9jkUCbmY1q5gsC33dQdTBgGpN1J3RgzPtcFektgiiRM
 C68xWu2bUGJlkYqT37aupuYCHAy/cH+x1ny0ABbScaE/hrO547SDhWCAy/yWZdH1LJTW
 xU/FFblVpRpcQUC+oQX+7xB4rOrLrkrGofxsmzGa++PNbRnFU9DBTQ2nJv7eGJXQ3LAT bQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btqp2n8m2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 13:58:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LDotwI063945;
        Thu, 21 Oct 2021 13:58:21 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by aserp3030.oracle.com with ESMTP id 3bqmsj6s08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 13:58:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/nv51TUoETEFFdwdSCm68cadKr53BE7PRmg//AOS5rfXvdrewFZLtG5F4K7cZ5AlDVhIMpEfj3DSdowifH04n3CsCW4nHDHXftEeIftiGbfRcJUaqluqhNGcCdAvsrbEBfoYFsjTCVnLRTuE9KiTeqUegSPtz0E+3fRIXjvbeeah2Bf5uXmyS5zTMz4afcHaHGeycKXwvcyoZE0IDi3ySi2bxPafAA2a43/DDgjKlOr2aC4oFNKbftUpJcrEk7mC7UkTGCaQ+oA5t99KaA8cmfmhqjqPFSNG9HQBjjQubgqihUxnkFHCcVnScEdzBXYlKwJSnY/5+aXrTUL+/tpEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5wPFW27jHN+mZXJGNlpWAUvO2a4iyc5HflJbIqC1iHk=;
 b=dit2bku8kHIx5AmzO/EHnrGzq+bBfMh0fuKk3UTjW9ti6I1eKNJt97LWxtaTut7VOS7hWTQGTMATJPUelxW4G+WAgNVlepqTn9f9Hv483ZZwD4B1Zp8hfKTHHSR6lEW4LxNmoXfVN6QqybRcfVLVmWBixbDIEjVqZpi6pTBiHwTz+o/KZGKY1fukXF2BNt1v/ZxQzE2GSYQANsNOpV/1LwRn5AtFbdpu+vy0ECX5Cn838LpDS/R1M73ogfECkXx4rYhkubx93c3T8cAjoDXYUdtZal4lVnw6EqBRyy8hEmiBC1KPnZOQ6kx8ZIj+x33y8HS2Fv9PekFZjTP0ltE5Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5wPFW27jHN+mZXJGNlpWAUvO2a4iyc5HflJbIqC1iHk=;
 b=Yx8iX49B7kSBXqo9+JG0c92SBJMrWtMQNgCFKPdnDZhcC0NG9Iolyy9MMN8MLyjENLkl9qGa59V/BJneeDNOpAK7H4eOVDF5Ql6OpYuYRT82fc7/XDNWgGkTzFqzrYaMbiyQq4NaN0q4FR1E4edf1bZE7/osUbxteAGL/7YOLMU=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BL0PR10MB2963.namprd10.prod.outlook.com (2603:10b6:208:78::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 13:58:19 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 13:58:19 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 01/13] qla2xxx: relogin during fabric disturbance
Thread-Topic: [PATCH v2 01/13] qla2xxx: relogin during fabric disturbance
Thread-Index: AQHXxk3Txb78aRmdX02Ovjb+G9a17qvdesoA
Date:   Thu, 21 Oct 2021 13:58:19 +0000
Message-ID: <71BA552E-F062-4289-A250-B17488524083@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-2-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ad6bd7f-cf71-484c-b79c-08d9949ad660
x-ms-traffictypediagnostic: BL0PR10MB2963:
x-microsoft-antispam-prvs: <BL0PR10MB2963D006AFD722D754825C6EE6BF9@BL0PR10MB2963.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vChk5LxLGL9ufLBchplBfRkpWi5Bb+nVNAnvzr+59g5K17FEE1QbZ8Z45BdoZcA06YXUli8Hr9ck7VY5yReeZhA+h4nACtMnRJJVDckkvqMxB/YBOT4lTjXRxpOs7GSzo8sL7qS1cfA2H1sV0NMlwZPX30oolS/mlROr9dZ5lv0ttA3naUqoIW9kx9QTJiXUDNCIAGtbvtyrxcjJ6UPxzvewXjz20M6OzZu1RMDpbR/27D1NOUcfgrRvhd20oV+p1une+LPYqKVTYzHWFtqbxGYLtBOQCyfIUzBWB5Yr1z2Y+2C7yY3xtMa8Z0Z6dUk0kmt+KvmajoFJ8sKSZxRi9Gwvow4f/lTvdy/3DcJT9tBleFWchP5PRQhQiwL1BXFrId4J7v2pu6zuvGt5hS0nfNC+fwa/ENekPYEa2fyeDLqyp9NzX326Zt7ujZSNzravRVxB/JbQiIBHjjNHkbbLmPQTa/zlKd3vhZ9v/IB/LjcWebYjzB/rkUDTMNJ15HTWPa2zhoZ+WoOiVWFM5vMznUBHrIvOHAoXtB+wuGxzEqHjTmayqZo9slBvlRpKpjeIE7Efu16vILpdyoH3hWl7ERu/IXCwqdjzDmmfIR5pbXC5zi70hJ2JNy58Q7wMGVL/xETS7eVPhwzaBjC5uZTq1Dh7auMIoUzvTFEVZnNb3Rwjm7OD+B8L48tYIIhwe0AQNhZp6y1Zj5y0AzdzEg5/5RfCXhigk30T01RDmdTCSJ1bfNevo0nGDgtzUT4O0iN6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66446008)(8936002)(8676002)(64756008)(66946007)(76116006)(91956017)(66476007)(4326008)(53546011)(186003)(71200400001)(54906003)(2616005)(44832011)(66556008)(6916009)(2906002)(6512007)(508600001)(33656002)(36756003)(26005)(6506007)(38100700002)(5660300002)(6486002)(122000001)(38070700005)(86362001)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?T/sxsUBTzCiKWXulkMKbuf43VMad+FrR8wfwPK9vc0InfzUFWas31e0dsEXB?=
 =?us-ascii?Q?ZsYy09lzgFQhd6IYfuoKAhsajmfwoHcyjzRYfjJeVUDlA7TQF/dN8cmJV0iz?=
 =?us-ascii?Q?cdPernrkMwuuF/9EtURkUBaa5gYvesTihfUeEMRylm5q7O07/71PfzOVhLR3?=
 =?us-ascii?Q?1Bx6XZYyKNwTvcLgan/ZnAxox8XNvDMZZqWuQXDmorTdqy0d7sjRVjlmZKFZ?=
 =?us-ascii?Q?i1oT7NboBgF6W8RerDDVBaaCBCJLC6M/U6cYlIXyhwJNHjI0SQPScYmRkPSQ?=
 =?us-ascii?Q?7+AChTOG3Wf73veXK0YVaWiWbvge3RoO6Q8j4Xhg+scwgU8dnftI74fHFZnc?=
 =?us-ascii?Q?vWBO9QXgaiF2y9Zw1mzPoOOfOWGg/+TUh3jnzjHKtuG5WAdNIBaWViS3aeZu?=
 =?us-ascii?Q?FCCgsStD2Tuaa8omzMZPD7gd433aYvGVpXji8HSNkS6OADDXS7m1fZ0o5ZYC?=
 =?us-ascii?Q?cFlczkRZe2V8EwW+Japjxms2RcTER0XjNxpcz/aiaqi/1jkBsWzRt4JWVBnr?=
 =?us-ascii?Q?tihQ+QKPy/lNpfF0fRcWUR6WZLxWVddJuzYtlEUlUGxk4C/nplCVZT2yHb35?=
 =?us-ascii?Q?GBOYRWjeNwag2l6qj7Vb6+8dz8tkbpOJkrIkAomS5c6oipVAX3RoEdTAKuvY?=
 =?us-ascii?Q?Jb0dL0ia5PbGm2JQKYAw2/Bh6XE2vQhMAUc+4M5ztWWRslXd3jYfnJhpmdiB?=
 =?us-ascii?Q?jUNKEYMPQ0O4OYvjLm9tsTiHK0NydCdgjs5DcshtYRPQQ9P34WpXQdfGFf3g?=
 =?us-ascii?Q?2C9ij8DgORS8tZWxvHociIVHhZXYtxteqtE/QaQSd1aA9ui2bFKATVBY4Rlz?=
 =?us-ascii?Q?FI2W9AHSVU9/MM+C2d2skNj9yy8b1lgUrTtDoA6WfqZinkrn5H/okW0x9H1L?=
 =?us-ascii?Q?OIR8E8QzMZgGA3nT2aQl9hG+zlzGLfRogCrFiVv/ZPGTaL1XVQTC9X6qkauj?=
 =?us-ascii?Q?/7GJj/hU1B7qd2677+HXowiYf5JjzXgkmlPx8ka/s8sbqG/tHs3Ce6CKB/pY?=
 =?us-ascii?Q?9qlc1E0pBQrD5Nzoe21WnHpJYjssYSH8K06wQIV89DJ9q74xWUYnvYrFjM6q?=
 =?us-ascii?Q?loJLPGdFjyIKvpoFc/wQvTirejuXUM8VPTe/ygkyxunVd2niz8IZJAIiW2zo?=
 =?us-ascii?Q?z4Ef8Fpp/E9Fd0A/T/kCawUhF8CzXXbXN+/wxi02I+eHPiSk27aqCXxz3C46?=
 =?us-ascii?Q?Omc1XAjTelZnnwH8QBofRaddvkAlXZeCuNGQmU31zP71cjc240VnhMFAh8oK?=
 =?us-ascii?Q?/klAES8ON30891z1RFNgvcHEGG9y8ZnQzn6/YaVrIo0wFMBJlhWkZHrvQPeu?=
 =?us-ascii?Q?w4A2CtmlbeIOsKsDgGl3X6xIGcMh4j1jiikzzOkUIwVC0g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F70D7A621AF73945A9E71D1A0FC0F42D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad6bd7f-cf71-484c-b79c-08d9949ad660
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 13:58:19.0274
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2963
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210074
X-Proofpoint-ORIG-GUID: u5y8PAZ1s_aX1OnCLx4hoctaGYuFvE2k
X-Proofpoint-GUID: u5y8PAZ1s_aX1OnCLx4hoctaGYuFvE2k
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:31 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> For RSCN of type "Area, Domain, or Fabric", which indicate
> a portion or entire fabric was disturbed. Current driver
> does not set the scan_need flag to indicate a session was
> affected by the disturbance. This in turn, can lead to
> IO timeout and delay of relogin. Hence initiate relogin
> in the event of fabric disturbance.
>=20
> Fixes: 1560bafdff9e ("scsi: qla2xxx: Use complete switch scan for RSCN ev=
ents")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 54 +++++++++++++++++++++++++++------
> 1 file changed, 45 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index a9a4243cb15a..339aa3b2737a 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1786,16 +1786,52 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, st=
ruct event_arg *ea)
> 	fc_port_t *fcport;
> 	unsigned long flags;
>=20
> -	fcport =3D qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
> -	if (fcport) {
> -		if (fcport->flags & FCF_FCP2_DEVICE) {
> -			ql_dbg(ql_dbg_disc, vha, 0x2115,
> -			       "Delaying session delete for FCP2 portid=3D%06x %8phC ",
> -			       fcport->d_id.b24, fcport->port_name);
> -			return;
> +	switch (ea->id.b.rsvd_1) {
> +	case RSCN_PORT_ADDR:
> +		fcport =3D qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
> +		if (fcport) {
> +			if (fcport->flags & FCF_FCP2_DEVICE) {
> +				ql_dbg(ql_dbg_disc, vha, 0x2115,
> +				       "Delaying session delete for FCP2 portid=3D%06x %8phC ",
> +					fcport->d_id.b24, fcport->port_name);
> +				return;
> +			}
> +			fcport->scan_needed =3D 1;
> +			fcport->rscn_gen++;
> +		}
> +		break;
> +	case RSCN_AREA_ADDR:
> +		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +			if (fcport->flags & FCF_FCP2_DEVICE)
> +				continue;
> +
> +			if ((ea->id.b24 & 0xffff00) =3D=3D (fcport->d_id.b24 & 0xffff00)) {
> +				fcport->scan_needed =3D 1;
> +				fcport->rscn_gen++;
> +			}
> 		}
> -		fcport->scan_needed =3D 1;
> -		fcport->rscn_gen++;
> +		break;
> +	case RSCN_DOM_ADDR:
> +		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +			if (fcport->flags & FCF_FCP2_DEVICE)
> +				continue;
> +
> +			if ((ea->id.b24 & 0xff0000) =3D=3D (fcport->d_id.b24 & 0xff0000)) {
> +				fcport->scan_needed =3D 1;
> +				fcport->rscn_gen++;
> +			}
> +		}
> +		break;
> +	case RSCN_FAB_ADDR:
> +	default:
> +		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> +			if (fcport->flags & FCF_FCP2_DEVICE)
> +				continue;
> +
> +			fcport->scan_needed =3D 1;
> +			fcport->rscn_gen++;
> +		}
> +		break;
> 	}
>=20
> 	spin_lock_irqsave(&vha->work_lock, flags);
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

