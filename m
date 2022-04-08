Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0529C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 16:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiDHQvj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 12:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbiDHQvf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 12:51:35 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC943127BE1
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 09:49:31 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 238CJY7I003641;
        Fri, 8 Apr 2022 09:49:26 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3f9r7es2pv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 09:49:25 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 238GnPmc013368;
        Fri, 8 Apr 2022 09:49:25 -0700
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2048.outbound.protection.outlook.com [104.47.74.48])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3f9r7es2pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Apr 2022 09:49:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UWMRQlvqcZ5KOpxfkKtU52+Vb5YfbtHdc/OAfFD2au6UV2F3oVnuqVdUyes/8iqEdzgaMyIi7PtYmD/9Wmm1GL0XmRJTHYDKf+Stj2HZGi2JZWa8saMT2u6yDRIbJ+EeBaMehnEMh99McQ2lhRVSCbzjf20ccZ/vBbTZefl8U6LVJty5ghmrbzcguI+MUVXtX06oEXHX0+qXcFsMYKDaSOkg8wW6+q3CzIBP6CEzEJ9bJzjPrEXRbwA3sNTIl9kCoxel/lPYRtgVnKt1xemFb8QbETyWzTOq5Bth91C2vygfxa3iRDBbUHJULa5tTNKcAjS5IioILmTSzHx6twttuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=abWKHxP/zc6BRR1bcQVIpkSo3QuVZnxjTEEWKQLH9f8=;
 b=K//3t9f/7otLIiuUuakGQh2IOQcMBsGZypGq6mwvPHpqIzHLaMoum5hJkEmlhrrmNSBgkLT8zCBZ8f+Js96NS7Nn+7S28m6hefhGZ5yFWfo8zu0t5gJB0dnTqb22vD/GSA+udgJBmh+FmbmAdLnXnGQQDcIBv9TJh4T88x0MySAu7cQCGYKdeEbj1kQ3KjMPf1LuY0DgTpcJgOp7ro1vkPvor74j1VId702QQlztrchYjpg4hB+ZjJ9CQ8uQuf4A5qFFQFj6Zh98Q+7XSSYOIrQbgdr4wFBPH3EIdW9FzZ9eDJ9YLgHR9lI+WLeATVAC0nYjc4h9fBAqgrnLjai+2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=abWKHxP/zc6BRR1bcQVIpkSo3QuVZnxjTEEWKQLH9f8=;
 b=fiRAvxGnX+pMVTxRJXhH/7wY7Zibf3/GXODZ5/jguDYcyKDlKJ2wOHe1HwC7SrvxWEOwRaFiceLYXXCCNI1JmToO/y7SkfEbsYgTRBwr6nWqt/kmpqhlzfOwFVZGj2B5KoULEnTc3o8rK+LDo4JudUjnwK6+G7Ng2nnXp5bpvtI=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by DM5PR18MB1548.namprd18.prod.outlook.com (2603:10b6:3:14f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.25; Fri, 8 Apr
 2022 16:49:23 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::3412:b64e:80b5:94cf]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::3412:b64e:80b5:94cf%5]) with mapi id 15.20.5144.026; Fri, 8 Apr 2022
 16:49:23 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 09/10] scsi: qedi: Fix failed disconnect handling.
Thread-Topic: [EXT] [PATCH 09/10] scsi: qedi: Fix failed disconnect handling.
Thread-Index: AQHYSt1+OD2omO+4HEmAKqLZD+a5AKzmO1hw
Date:   Fri, 8 Apr 2022 16:49:23 +0000
Message-ID: <CO6PR18MB44190534F3DF8E631CAF15B2D8E99@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20220408001314.5014-1-michael.christie@oracle.com>
 <20220408001314.5014-10-michael.christie@oracle.com>
In-Reply-To: <20220408001314.5014-10-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 029688b6-cc98-4c95-355e-08da197fbc17
x-ms-traffictypediagnostic: DM5PR18MB1548:EE_
x-microsoft-antispam-prvs: <DM5PR18MB15483BC8E1649AD7EC06EC07D8E99@DM5PR18MB1548.namprd18.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4JzfiwJvTWGbeTKj+Kqb4khadC2IPbTJXuYMoqk5gnBXh5SGe2vTATNEOFMpXlco/Xh/oP7AZ4wKpX/xAFBFMFiOSzhZubHqZC4rP/lrUmSzfrit1nCGW39E3LNoNIh2p4TwO0ROzX5TWSh8/LQPcRWPr5Z38YhXEX+1bq6qoweLtwxSbCpIPsvUh/cThT4p6ZtpeJ8BrFtu5JsPfex7emGKU7CWUU1CWkmMjlmQtRugpMSDec2FA4CkjG1h9VmcIh+3Z6fY4zTK/GAT92CZ8yyh7d3bkKefcTRv1w6ZCwjvTHpZmB5o4Llas72y5iUJji1KMPQf/lyDHnPNZzEjd/4qg1ADu0kw91yP2XQ0E2nDlZI1VcY0CArau4X8h+4iyUjvQM1w3mXOdv0xH4Vt4uWCTBdAB4NyPXEyyGG/QLkd1asxZmuHbrRyR3f0NdxjrncpRj1zxGt0eCRlbApaniKPb7sD2PGv/Pv/JfKkbx9zsoEXM5cCfuMu7Fr7rO7pH36g5T3BAXkuMntxCXbbHvVPm9Z7fi9udyMdjH0/tCNEg2aek4epoYDcX6ISsCPByN6HzzGCwc9Q4HC1GTEDd8cDqMbfgiOGRBO+/9CC7eaqCwOUXQMKZu6QmbpmMmnCU2KhHJlG0hrmdx+Iz0ch0ybY2IRrd7mf7Tz6uzW/3hJoT16EOlZi4emCBxccZ4FuZtMvLFhs9W80kGBIUKqJ8Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(55016003)(66946007)(66446008)(76116006)(66476007)(66556008)(64756008)(33656002)(83380400001)(8676002)(86362001)(8936002)(52536014)(122000001)(38100700002)(316002)(5660300002)(2906002)(26005)(7696005)(186003)(6506007)(508600001)(71200400001)(110136005)(38070700005)(9686003)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?07Y7ID4MOm9QB/yyaBpYWfWrq+8deeDMm9SOfMvOD5IShAuiRhDu4KJGfZB8?=
 =?us-ascii?Q?Cbx3sdplclgaQQqVR1ZCf+Fop7UR1WHfwspSLCVDNMCJ+LJdoIrXcCTl8Fyy?=
 =?us-ascii?Q?pwNxt3C8wWzQzOnoh9LSRv0PcRt+BoBi0VM8XpeUstWIVhVbsW+ZPWik5/C1?=
 =?us-ascii?Q?9uBkwYK6UXh5QltdvyY8zxeLPQSmWx0pEqoAQpp+z1uPS4XrsHKYsCjfMGX4?=
 =?us-ascii?Q?HX3B1sFGKJ7DaoddnsTKfsTdRxii8PZYKO45k24iUJVEabk7iX4z7TORuZOw?=
 =?us-ascii?Q?S1jzYrIhyR/7LRuMIoxxb6RNt7jdeqtUiYjuSc+ZOo2VcuLOUWzK4RU7u2L/?=
 =?us-ascii?Q?YjkEY4ttB8ueRECXbEhLM63F3GH32SGBsFHO56kKxWH8xbJEqFzsCCBnYDDj?=
 =?us-ascii?Q?ZuTP+Q/yWRuYY4SZ50dhxKWUBzRMZZK105lqWRxLsM/pyYsKrM8NJp3Opdbu?=
 =?us-ascii?Q?VeefpmTLyRZVZyU+kE/M2x46Jc7KQRH5lP8lJuKezClmj4gDxomdnbgoTxqj?=
 =?us-ascii?Q?HC8+Cvyww9QOjMsXIqECQtS+6v/VT2BsD4HuRF5qI0TPrgHTRREEiZjcxPwx?=
 =?us-ascii?Q?FHzyifUogMoFUJpoI97h5PU6IK1lrr+SxBjqa6YI8VDpB3S5DLVNKf1P4ZJL?=
 =?us-ascii?Q?B/IjDy/x0T30RX3GwPG9YR6szk/CGvPGMVhI2HMMThVtxQERxEVqdSJnuHQw?=
 =?us-ascii?Q?NZgCV6NAwpqoKTKo0OIN/GZTQ1wnbWlosLF6Qf6HFAALTodLfaPSJxHJj41u?=
 =?us-ascii?Q?xUfnwIZkCxtHP1lTeEb/Zm6hrzSn8jhnUMYPTjYXaIOT5IX3LMB5NQkEI39R?=
 =?us-ascii?Q?oWSbD2dITFjSgFMK8bWg15LngsT0BMep0wMKkzYUXmueA6u8LRPq+c3rHzaX?=
 =?us-ascii?Q?2qnrrYStUnKWnKbKnUYZoV0vptGpj4hQSGyT6mHWu4P4AWyhuh6jp+x2d9Wn?=
 =?us-ascii?Q?6pMbJonyT+raEm0YJo+zfQ3ghB3u/fC0GFSmJA+r+kDsZH9QDhar1DHRatrJ?=
 =?us-ascii?Q?nKqwNlOPB/GySIJlY1yqjRBbusVwTvA4nKgw9R0N4hIpS9ZkcfXmv+R+0YgR?=
 =?us-ascii?Q?gstf4ihE/rXYQQ8g9Lkt9PYSAIfct3IEhNB8T9D1jH67+nDYyJ+dhgKpxvjS?=
 =?us-ascii?Q?bYT6Xr2zy0DUlP+vBl4Ik2aamRuuhEGUfXZHOvFywr8mwKpYNAfUX0O2ZwE6?=
 =?us-ascii?Q?TyYc+eYundJt9z7JCTlq60HDbqp+PGUAZnqI9KXZfcNtyKaw+PSZT2X6cVbZ?=
 =?us-ascii?Q?vPmbvi8N5YabPn9fVC0fAuF7sNFBk/YVB7sH0mJG59aflX0DNMrmHP1vjetl?=
 =?us-ascii?Q?e9V6LDqyQCTkhvOjP1Ka78lOJwPSQmT2CGkoQg2hv8bI/osDaB2Aku9/RA6b?=
 =?us-ascii?Q?SGCgBVLOc0CGRZVi/2EGh+Jlo9XvBZvP4TE0T17WlPBEZtGeOfGKLHSHbZ0B?=
 =?us-ascii?Q?5DDAFwYOZa4dCGR8lDlF5SwUvMeOnLaEYFqqb05eMlzWBGUBfijmQy4gKKc0?=
 =?us-ascii?Q?1maW2uEQhmNTVqaq/JYhI79ySWizMBRP7/uGKlVNV52JhLqbJE6tbdztuW3U?=
 =?us-ascii?Q?7ZqjMts1mES2GSSf5Pa1oYv395FYBLWJoHFiacRQKedN45WDLKxBhapbBIr0?=
 =?us-ascii?Q?4Yh4eyJhFeZRwuyEnGUUP12o914/ktyOeoOCerZczGwcnpfX1aJWlIS+ZzgN?=
 =?us-ascii?Q?U98jbQfN/lTQRMx9qXS0EZbIVB2aYKVAUPf5Y70qrJcx7UYExJPloFDBt4V5?=
 =?us-ascii?Q?KK2acJON2w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 029688b6-cc98-4c95-355e-08da197fbc17
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2022 16:49:23.2275
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fGvYWQGwaA49zotLPj1V27YfWRSPV2AWAJin0KeEvnHVE8QoNEdU7o4OtjpihcO9UKAlj4UxMIFucTJKoPKGRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1548
X-Proofpoint-GUID: wZlHTrYK9puk60L3IFcqTf8NyRmmeC6C
X-Proofpoint-ORIG-GUID: SxDQQEvS2v-QwDGP7WzrQER6VYhrRyad
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-08_05,2022-04-08_01,2022-02-23_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Friday, April 8, 2022 5:43 AM
> To: Saurav Kashyap <skashyap@marvell.com>; lduncan@suse.com;
> cleech@redhat.com; Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <mrangankar@marvell.com>; GR-QLogic-Storage-Upstream <GR-QLogic-
> Storage-Upstream@marvell.com>; martin.petersen@oracle.com; linux-
> scsi@vger.kernel.org; jejb@linux.ibm.com
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 09/10] scsi: qedi: Fix failed disconnect handling.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> We set the qedi_ep state to EP_STATE_OFLDCONN_START when the ep is
> created. Then in qedi_set_path we kick off the offload work. If userspace=
 times
> out the connection and calls ep_disconnect, qedi will only flush the offl=
oad work
> if the qedi_ep state has transitioned away from EP_STATE_OFLDCONN_START.
> If we can't connect we will not have transitioned state and will leave th=
e offload
> work running, and we will free the qedi_ep from under it.
>=20
> This patch just has us init the work when we create the ep, then always f=
lush it.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_iscsi.c | 69 +++++++++++++++++-----------------
>  1 file changed, 34 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c index
> 8196f89f404e..31ec429104e2 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -860,6 +860,37 @@ static int qedi_task_xmit(struct iscsi_task *task)
>  	return qedi_iscsi_send_ioreq(task);
>  }
>=20
> +static void qedi_offload_work(struct work_struct *work) {
> +	struct qedi_endpoint *qedi_ep =3D
> +		container_of(work, struct qedi_endpoint, offload_work);
> +	struct qedi_ctx *qedi;
> +	int wait_delay =3D 5 * HZ;
> +	int ret;
> +
> +	qedi =3D qedi_ep->qedi;
> +
> +	ret =3D qedi_iscsi_offload_conn(qedi_ep);
> +	if (ret) {
> +		QEDI_ERR(&qedi->dbg_ctx,
> +			 "offload error: iscsi_cid=3D%u, qedi_ep=3D%p, ret=3D%d\n",
> +			 qedi_ep->iscsi_cid, qedi_ep, ret);
> +		qedi_ep->state =3D EP_STATE_OFLDCONN_FAILED;
> +		return;
> +	}
> +
> +	ret =3D wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
> +					       (qedi_ep->state =3D=3D
> +					       EP_STATE_OFLDCONN_COMPL),
> +					       wait_delay);
> +	if (ret <=3D 0 || qedi_ep->state !=3D EP_STATE_OFLDCONN_COMPL) {
> +		qedi_ep->state =3D EP_STATE_OFLDCONN_FAILED;
> +		QEDI_ERR(&qedi->dbg_ctx,
> +			 "Offload conn TIMEOUT iscsi_cid=3D%u, qedi_ep=3D%p\n",
> +			 qedi_ep->iscsi_cid, qedi_ep);
> +	}
> +}
> +
>  static struct iscsi_endpoint *
>  qedi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
>  		int non_blocking)
> @@ -908,6 +939,7 @@ qedi_ep_connect(struct Scsi_Host *shost, struct
> sockaddr *dst_addr,
>  	}
>  	qedi_ep =3D ep->dd_data;
>  	memset(qedi_ep, 0, sizeof(struct qedi_endpoint));
> +	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
>  	qedi_ep->state =3D EP_STATE_IDLE;
>  	qedi_ep->iscsi_cid =3D (u32)-1;
>  	qedi_ep->qedi =3D qedi;
> @@ -1056,12 +1088,11 @@ static void qedi_ep_disconnect(struct
> iscsi_endpoint *ep)
>  	qedi_ep =3D ep->dd_data;
>  	qedi =3D qedi_ep->qedi;
>=20
> +	flush_work(&qedi_ep->offload_work);
> +
>  	if (qedi_ep->state =3D=3D EP_STATE_OFLDCONN_START)
>  		goto ep_exit_recover;
>=20
> -	if (qedi_ep->state !=3D EP_STATE_OFLDCONN_NONE)
> -		flush_work(&qedi_ep->offload_work);
> -
>  	if (qedi_ep->conn) {
>  		qedi_conn =3D qedi_ep->conn;
>  		abrt_conn =3D qedi_conn->abrt_conn;
> @@ -1235,37 +1266,6 @@ static int qedi_data_avail(struct qedi_ctx *qedi, =
u16
> vlanid)
>  	return rc;
>  }
>=20
> -static void qedi_offload_work(struct work_struct *work) -{
> -	struct qedi_endpoint *qedi_ep =3D
> -		container_of(work, struct qedi_endpoint, offload_work);
> -	struct qedi_ctx *qedi;
> -	int wait_delay =3D 5 * HZ;
> -	int ret;
> -
> -	qedi =3D qedi_ep->qedi;
> -
> -	ret =3D qedi_iscsi_offload_conn(qedi_ep);
> -	if (ret) {
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "offload error: iscsi_cid=3D%u, qedi_ep=3D%p, ret=3D%d\n",
> -			 qedi_ep->iscsi_cid, qedi_ep, ret);
> -		qedi_ep->state =3D EP_STATE_OFLDCONN_FAILED;
> -		return;
> -	}
> -
> -	ret =3D wait_event_interruptible_timeout(qedi_ep->tcp_ofld_wait,
> -					       (qedi_ep->state =3D=3D
> -					       EP_STATE_OFLDCONN_COMPL),
> -					       wait_delay);
> -	if ((ret <=3D 0) || (qedi_ep->state !=3D EP_STATE_OFLDCONN_COMPL)) {
> -		qedi_ep->state =3D EP_STATE_OFLDCONN_FAILED;
> -		QEDI_ERR(&qedi->dbg_ctx,
> -			 "Offload conn TIMEOUT iscsi_cid=3D%u, qedi_ep=3D%p\n",
> -			 qedi_ep->iscsi_cid, qedi_ep);
> -	}
> -}
> -
>  static int qedi_set_path(struct Scsi_Host *shost, struct iscsi_path *pat=
h_data)  {
>  	struct qedi_ctx *qedi;
> @@ -1381,7 +1381,6 @@ static int qedi_set_path(struct Scsi_Host *shost,
> struct iscsi_path *path_data)
>  			  qedi_ep->dst_addr, qedi_ep->dst_port);
>  	}
>=20
> -	INIT_WORK(&qedi_ep->offload_work, qedi_offload_work);
>  	queue_work(qedi->offload_thread, &qedi_ep->offload_work);
>=20
>  	ret =3D 0;
> --
> 2.25.1
Thanks,

Acked-by: Manish Rangankar <mrangankar@marvell.com>
