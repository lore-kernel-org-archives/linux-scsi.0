Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656A4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FFBD60F59
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 14:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJUOMX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 10:12:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54284 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230471AbhJUOMX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 10:12:23 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19LE4dtL010600;
        Thu, 21 Oct 2021 14:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4fdqO3ZS098LRCZoO15yiP3WRt6EBXGF1gDwpmY94d8=;
 b=hSFIIp2yEselKT9YwRhnpWdUsA0iaCons0ebYFXbQOnhriogfnhJJ8G5r1G3AQmSwpB8
 U9M/XGJN/R7zYyDDQyecGpP5q0epVDoS69sL2R+5z3xv3AIRZ6pxBCAM+1facMQKh2l2
 OFLl0EIIxNx9OScMidY8IDZIxdiq+fsX+aCCxZmE3JkQJJXkEjyZR05pFGwli1KiJiIp
 l3ltxDT4Cyz4as+4Vt6FLTDesBYucL4KmaLyqtKsxhf7z8aoZTNlPvdG9j1KHBNgik7o
 npVRusyRY50ZX7jmqbxlOSsxMHo7rGh+3eYOqMfFmEh3BuNlg7dXX6X4Fwtl6T6nSwYs rw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3btkx9y1hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:10:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19LE5dZ1178766;
        Thu, 21 Oct 2021 14:10:02 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by userp3020.oracle.com with ESMTP id 3br8gw33j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Oct 2021 14:10:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bNVexKZ85lv1SKIt3rBaAnBRUuPsL20wAx8gxNIAC5LJmCQtqRIvezUGBtYYvWHUWUJ7Pr3+qgJdvHii9gSCNcGOT/2Fp489S2oBzCgLW6rQ0x5NIM9uxnkbWrNsf7USp+0AR1Q3Rjhn/An/WBs92eORHr5Cy5BeN9ivKAn3C26cuX8n/XKeR1Hdl/cTtIxWynPB1+w6S7Kl0WU2Vxi9ICWNR/+YZzCPLUdxe9EnGMT8/cL38WlI0rHH9/EfpmD7G9vXk1WYFSTJ7pNvqpex0enhygN0wDempNxdTdZooqx4/fymAcZLfLRvW1ou/Ry+ucN8hMb9HTe3Gco8xgFrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4fdqO3ZS098LRCZoO15yiP3WRt6EBXGF1gDwpmY94d8=;
 b=J3rlzGlotqXJD4HDGyq4qlNvfSceqWdYGJNCXylfnU34IasiysZbxFrrxjiUKiJ70uMSXsmVRqmc+aqw94fN/PuCBHZvyAOkhjUnuuZ8lS2i11tLWUwl8KWx5YvwOSq3VGazWRCTZNoewyP1vIk1I1cN6l0/6WcKbO1b40WIq03fcs9rXv7+toqhi4YUykQVcx4RLdgE8/icYiOvvBTsPGZvkl0f+xXfwW166tCVuL5t6WHv04Fp8ahFZsfYYjAzkil2sVmK+mM+rpQtwzyuzb/RV+mv0tCTsUTzKDBZIgFMJcXHTReEVMwI8rrU7XcvT2UtwjpijT3tWN5N81vcHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4fdqO3ZS098LRCZoO15yiP3WRt6EBXGF1gDwpmY94d8=;
 b=xJ2ZMAFhXVVmI5u/3VgnKrJzflCsMLoH7IG/z5lDO3uqbUtCHSG33trMzMUSrMNN32Y0jACBFMf15cRPzU3qs+LcAICGqi1GQ4mUG3VuBFg6iG/w5Rl5czMANqV8Ogc1uutSvY6CxQjn16p6ShUqY0PiyZSO8qDiqiJleRTgQhY=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by MN2PR10MB4208.namprd10.prod.outlook.com (2603:10b6:208:1d7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Thu, 21 Oct
 2021 14:09:58 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::6162:d16a:53c1:4188%3]) with mapi id 15.20.4608.019; Thu, 21 Oct 2021
 14:09:58 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 05/13] qla2xxx: edif: fix app start delay
Thread-Topic: [PATCH v2 05/13] qla2xxx: edif: fix app start delay
Thread-Index: AQHXxk3T9e+Tkaa7eEmpVHw5+jiSUKvdfguA
Date:   Thu, 21 Oct 2021 14:09:58 +0000
Message-ID: <97F2A226-D0DA-4644-8B3E-6520284F2339@oracle.com>
References: <20211021073208.27582-1-njavali@marvell.com>
 <20211021073208.27582-6-njavali@marvell.com>
In-Reply-To: <20211021073208.27582-6-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 696f38ee-e581-4e17-f20e-08d9949c76fd
x-ms-traffictypediagnostic: MN2PR10MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR10MB4208D25DDE5C50CD9CE68044E6BF9@MN2PR10MB4208.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:162;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wkGuIE9i5aPhGMxpPO/Htd/m/9p71XqVIEdDZ1SgmrZwWiYScaBh6AkbnL7lY5Ze/8tNSEDXRMNcWVXJLZ4ha2svgD1jynKFgw8U66WooNurwwtwS9hAMHa0mv1UBG0sxkFEkIc/G4O9jJqYa34Qz4UVcKWzUKWBQXHK+nv7PsiTEj3K4Z0zFTtkooh8pthqTMs6ObRfccPMZcFG4iQ84TzzT2GELcOLJdht91ajlEnZCFowxlOC75ommrrE1Sd9Z4nOliSbs9ONFlgNQapbEOkpd2Sq0fIVDmSjSyncOVNC4hvT/Yvt1I1NsfVA/D5HFEDLIt0FSbMo9SqW2EKSH5pD6OikE3ek/XB7rC4hUaxjuLxsBldK4eRCQE4pcmAEAGQXW/M4zXrCRNEyo9vEfMd7xvnGgEbiNOJapmr4M0Rj+cxkOg4hbCdxrklIGj5Ju37YkeabvdwBy/HcZPkakRS6z2wBV+Kfjk67RJ5pBPd482uum/HtwnU/YHvtmWWUGsKxH2wEzLndVj6c1CHtm0j8cMoyzY9lIXemXYgBRT/2RxwCAfOl8eltZqRQrnLoj1Q2opvOm2GMEbNWoiIX+4/kixyvmiLy0UKTTme1ukyizignbJlYDD2lNC+belgLj5kMM65yi5Y1IXJqO/yjYfdYXmRGoqzrpqY5RMHu4UgOD85IbBbGoMHagUsfh0c08gxjuuavKqzGh3s4lbZy0Yr/irSfXUa7YV16Mx3I9TtVHHQ8owXCakKUM89TqcVA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(122000001)(71200400001)(6916009)(2906002)(2616005)(36756003)(6506007)(186003)(44832011)(6512007)(83380400001)(8676002)(508600001)(6486002)(38100700002)(316002)(54906003)(8936002)(4326008)(76116006)(5660300002)(26005)(91956017)(38070700005)(33656002)(86362001)(66946007)(66446008)(66556008)(64756008)(66476007)(53546011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yR1NYaMnmoVCoCL4NMjxv8FPLD5eEd83gQIZrzcMVf00qfwUXAQlJVc/Bp7Q?=
 =?us-ascii?Q?3vyW+WyYw+P0pmHkfibpcEBol8Dyqwc+CaLUeV7uq26ET5t4iB+NOxUKtt8f?=
 =?us-ascii?Q?/D5tUFcEhg50ERUILrmIs0voRo2fUeL0IbmRf/MHa1HSrlUAQB1qEyj2/Lkj?=
 =?us-ascii?Q?X71KxhWmW7OxwUV5oY/CBzcrotMYSVfEKHj4iONNoqsiVtRqUylpnk9M08Qv?=
 =?us-ascii?Q?7yflPqsj97L1nslI77TXl0+qxWdlEq5KygmSIwrmCMIjNQcAwvnjHiDDbZEO?=
 =?us-ascii?Q?ZWYDq/vpkriKuS2uRO1SRT0dlLxx784uGcCbEnXCTzAjTfxQHA2/qdJgniWW?=
 =?us-ascii?Q?PAjsk0P2xYeoshBOSdW9clYPz2klOPVkBCmmaH2JXkpL7PgEs4XX6MjIubYc?=
 =?us-ascii?Q?8z58hbhtCMgp1sEsCTl1k7JrsLj+iXTGtAQuZ29b5U6F05oKE8Z+UVwmm0tN?=
 =?us-ascii?Q?eNcLWO+fMAH6uUoUwSGnsyORdSHlVCx2FofLmM2s/toCkcus/ggoWwHcUDIv?=
 =?us-ascii?Q?q/a9hc+YCg7nE8NEKKjbaJ/T7DGeqLQ2gda0xs6btK0q4+ZeOj8bWQRlU2rd?=
 =?us-ascii?Q?ulGqiWgLCN2UGaJDaZnt0Ustn8noIvEX9fe1Xquj0ZObVn+biYGjoKDakZ8M?=
 =?us-ascii?Q?Tim1RR6eMeO1Yyy4ry94XfvtEJVJhH897xKFZk6yBp/+qew1mW8HT/yNf7fl?=
 =?us-ascii?Q?kKVPWbrqhVGKSoskjMQBajyQm5jVyo+UczU/FRQVKvP7VC2pV84+EICgMvhX?=
 =?us-ascii?Q?WRRiviGp+JUuTyPXEUlrZiiEOVDSA8YWFrn5L7k+elCE0sY07F6hdSc4T8WG?=
 =?us-ascii?Q?CDQ7+YQP9tdnkH1NPigLwojyNcXoB4FfU4d1zdOKic9oZWOellt+EE/rp5Sk?=
 =?us-ascii?Q?dm52RwcyvK7z2KBqtaPUtY6Xv8xh/wjyUYiTQ+BfxZoi4ok78sGAy0gQyla0?=
 =?us-ascii?Q?m3JIYf461RD3XGjL54A6Lc85QMfd0B6dN2I6aHSdVicvV6j8cWCCZkvOYIpM?=
 =?us-ascii?Q?jAtXBxTrvyQY1ce57RsRWXgMVY91uK3dFMRvU+FosxeC+FUr12p3Eg61VbPU?=
 =?us-ascii?Q?vOHsb1S9h/54aEWlY3A3zEgsFxGntVwY27fU3Zayo/UyMBzfY9U56jjUoI72?=
 =?us-ascii?Q?LKczbE65GgDuQVT0KM2O7aScXSo6keaaHtVJbap0+dvwnhDEC9zcBKOC62Tf?=
 =?us-ascii?Q?kAYgHHZlqKvk8bBWcRB7JrXauInpMLpxP1WeqRHbEAvnntfMoWVM42n9xJ3G?=
 =?us-ascii?Q?YSH4VWimUrvLYURqHmsQZx2Ix4UWzRPNyeJ/5Gp+fkTgZMMdZeuQcvDoH0Wo?=
 =?us-ascii?Q?yPfQI0rUFJcHHhQeZnbdnyS85iBVJsu6aV3Nwwe4RERGvA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C9E0102CCC093499575F3AC2D6BB387@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 696f38ee-e581-4e17-f20e-08d9949c76fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 14:09:58.0699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: himanshu.madhani@oracle.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4208
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10143 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110210076
X-Proofpoint-ORIG-GUID: eEtABD5X3waEA6PSm9JCwpfWKQgIQ951
X-Proofpoint-GUID: eEtABD5X3waEA6PSm9JCwpfWKQgIQ951
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 21, 2021, at 2:32 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Current driver does unnecessary pause for each session to
> get to certain state before allowing the app start call to
> return. In larger environment, this introduce long delay.
> Previously, the delay is meant to synchronize app and driver.
> In today's driver, the 2 side uses various events to synchronize
> the state.
>=20
> The same is applied to authentication failure call.
>=20
> Fixes: 4de067e5df12 ("scsi: qla2xxx: edif: Add N2N support for EDIF")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_edif.c | 64 ++-------------------------------
> 1 file changed, 3 insertions(+), 61 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_e=
dif.c
> index cb54d3ee11aa..33cdcdf9f511 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -290,63 +290,6 @@ qla_edif_app_check(scsi_qla_host_t *vha, struct app_=
id appid)
> 	return false;
> }
>=20
> -static void qla_edif_reset_auth_wait(struct fc_port *fcport, int state,
> -		int waitonly)
> -{
> -	int cnt, max_cnt =3D 200;
> -	bool traced =3D false;
> -
> -	fcport->keep_nport_handle =3D 1;
> -
> -	if (!waitonly) {
> -		qla2x00_set_fcport_disc_state(fcport, state);
> -		qlt_schedule_sess_for_deletion(fcport);
> -	} else {
> -		qla2x00_set_fcport_disc_state(fcport, state);
> -	}
> -
> -	ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> -		"%s: waiting for session, max_cnt=3D%u\n",
> -		__func__, max_cnt);
> -
> -	cnt =3D 0;
> -
> -	if (waitonly) {
> -		/* Marker wait min 10 msecs. */
> -		msleep(50);
> -		cnt +=3D 50;
> -	}
> -	while (1) {
> -		if (!traced) {
> -			ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> -			    "%s: session sleep.\n",
> -			    __func__);
> -			traced =3D true;
> -		}
> -		msleep(20);
> -		cnt++;
> -		if (waitonly && (fcport->disc_state =3D=3D state ||
> -			fcport->disc_state =3D=3D DSC_LOGIN_COMPLETE))
> -			break;
> -		if (fcport->disc_state =3D=3D DSC_LOGIN_AUTH_PEND)
> -			break;
> -		if (cnt > max_cnt)
> -			break;
> -	}
> -
> -	if (!waitonly) {
> -		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> -		    "%s: waited for session - %8phC, loopid=3D%x portid=3D%06x fcport=
=3D%p state=3D%u, cnt=3D%u\n",
> -		    __func__, fcport->port_name, fcport->loop_id,
> -		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
> -	} else {
> -		ql_dbg(ql_dbg_edif, fcport->vha, 0xf086,
> -		    "%s: waited ONLY for session - %8phC, loopid=3D%x portid=3D%06x fc=
port=3D%p state=3D%u, cnt=3D%u\n",
> -		    __func__, fcport->port_name, fcport->loop_id,
> -		    fcport->d_id.b24, fcport, fcport->disc_state, cnt);
> -	}
> -}
> -
> static void
> qla_edif_free_sa_ctl(fc_port_t *fcport, struct edif_sa_ctl *sa_ctl,
> 	int index)
> @@ -585,8 +528,8 @@ qla_edif_app_start(scsi_qla_host_t *vha, struct bsg_j=
ob *bsg_job)
> 			ql_dbg(ql_dbg_edif, vha, 0x911e,
> 			       "%s wwpn %8phC calling qla_edif_reset_auth_wait\n",
> 			       __func__, fcport->port_name);
> -			fcport->edif.app_sess_online =3D 1;
> -			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
> +			fcport->edif.app_sess_online =3D 0;
> +			qlt_schedule_sess_for_deletion(fcport);
> 			qla_edif_sa_ctl_init(vha, fcport);
> 		}
> 	}
> @@ -802,7 +745,6 @@ qla_edif_app_authok(scsi_qla_host_t *vha, struct bsg_=
job *bsg_job)
> 		ql_dbg(ql_dbg_edif, vha, 0x911e,
> 		    "%s AUTH complete - RESUME with prli for wwpn %8phC\n",
> 		    __func__, fcport->port_name);
> -		qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 1);
> 		qla24xx_post_prli_work(vha, fcport);
> 	}
>=20
> @@ -875,7 +817,7 @@ qla_edif_app_authfail(scsi_qla_host_t *vha, struct bs=
g_job *bsg_job)
>=20
> 		if (qla_ini_mode_enabled(fcport->vha)) {
> 			fcport->send_els_logo =3D 1;
> -			qla_edif_reset_auth_wait(fcport, DSC_LOGIN_PEND, 0);
> +			qlt_schedule_sess_for_deletion(fcport);
> 		}
> 	}
>=20
> --=20
> 2.19.0.rc0
>=20

Makes sense.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

