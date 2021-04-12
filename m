Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD77C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:36:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88CBE61249
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 10:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbhDLKhH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 06:37:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18770 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237219AbhDLKhG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 06:37:06 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13CAUqal001696;
        Mon, 12 Apr 2021 03:36:34 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm3ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:36:34 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13CAVZjQ002439;
        Mon, 12 Apr 2021 03:36:34 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0b-0016f401.pphosted.com with ESMTP id 37ubhqm3wr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 12 Apr 2021 03:36:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WD2FkJjLYHdwkHaD+a3yq9vznSWXDf0tc1NdGG234zhublCeFMqklPWfyr+YvcZKEopKdzYSWPH/2GMEHtxUcr6THM1mTN2bfGf2rpPhz3mRz0mdLbbwjbeofbwt2sp+yvp4OPtj3dtqKP16xqR6OZ6WlcD9PAPwV1ZB1sYyQ6RGNHzCy4ku5o0+mL/KnGNZDQbaNczNdSVhBl7Q8+K9ALMXvmaMqKU1EbhHD1xNFhD9j3gw87tnkgqtmsizg75GQdzVmrf2crjNfhFxInd+fYVqSqHCIQo1P9QqIIVXCv6n5eRRWUn73a+RFBqwfVxQ386zJWI9qgFoZW9AxACJOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNWagqCDXwqfNTeYtViA8dacJRWy7K9kg9uV4LrB2YU=;
 b=h3LOUAQYBUKGZaYGeyN0XWBy5UffdYgZFr0QDpOufIj6SxQCE30iIS/wUqqwVM+DMrRQ4FINt3CAMAX9IqtUhw4/dhUnKMd7IBWHqDJiaLTbsTBSQJmhzi+fuVPYeCYnypcbylNNF5WWEEhMo+tAthsMVTJwxtqgY+0UG2oyUv5Fc1LvNGkLODLiRtxj2ZRnmUQkbXyFeqVWoeernVGQByesNJjJg7HpEk5CvHTU9LEQMS2gnK7RPBPq4WZ8ks6MT3nD88XHL5cpBWmEygDTv76jyQTrqEURqpjgs8PW3wt5oQ1os4EInipwM24yEDR0KRcR9AA7bg5Z5fK7o03gWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNWagqCDXwqfNTeYtViA8dacJRWy7K9kg9uV4LrB2YU=;
 b=OUXu5WD3ozqhYW3Ytb9eV6I1ERqaV6Qp0ckKki+khTlzMXXMBdXftjgrkW0HuVjI0EI8qGLf+YnjTcb64ogxl6bqS5hL/CrDCN6hBLI/yVkgJirrBD8tNDZgSUAelSMlxjnF7ztXK9V6glk3wzgp9NIHb+dwlQ2RovBYnbBii44=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by SJ0PR18MB4027.namprd18.prod.outlook.com (2603:10b6:a03:2ca::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.21; Mon, 12 Apr
 2021 10:36:32 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::8d7f:5a91:7edb:3621%4]) with mapi id 15.20.3999.037; Mon, 12 Apr 2021
 10:36:32 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Mike Christie <michael.christie@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Santosh Vernekar <svernekar@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>
Subject: RE: [EXT] [PATCH 12/13] scsi: qedi: make sure tmf works are done
 before disconnect
Thread-Topic: [EXT] [PATCH 12/13] scsi: qedi: make sure tmf works are done
 before disconnect
Thread-Index: AQHXLjkIrgAsY4J6e0uOSVWARePGWKqwstdA
Date:   Mon, 12 Apr 2021 10:36:32 +0000
Message-ID: <BYAPR18MB29984C01E7203CD2A4EB289CD8709@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20210410184016.21603-1-michael.christie@oracle.com>
 <20210410184016.21603-13-michael.christie@oracle.com>
In-Reply-To: <20210410184016.21603-13-michael.christie@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [34.98.205.117]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 04ceaa21-1a2e-447d-32ce-08d8fd9ed714
x-ms-traffictypediagnostic: SJ0PR18MB4027:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR18MB40276ABA87AAEA9991C7062FD8709@SJ0PR18MB4027.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gQCy0w4Hpvf4MwOuR9QohGTkYQroO+vgo9ufxUNdY6cMi2wnTjs5Pu825UYSnee6vBsigjHOsk0nykHVAbUZrBqWASOkh5zcyHgBtFQeBWRn6fpV+Vsxa/vPQwqVDNWN0w842Smx3G2wNi1Ri7HB6elP2HteWSt+RKTGNZ9zPixo6bLJT5oGa1kSLvm9AD20dEX4RT7nNw/+74S8nUiX4AF7vuL7WFjPc1NJynATt0n6pFRFPpwSR3UjGVcSLZLu1TXpCHueu84g5GBUcvNYV5/OYWnY3ENFKQjUbB3L2oz4NJhtCslmvs7ALazeh90pg3ED2hmCD8K7nBJqmJgEQZkrNKDgpeEYVdleqDC40qAO8eW0TCODWN8qXZ3C2fY5S5xB7vy1kP5kHP9jScfHcjrzGcwoV5e2HSkhmAlJRDHRh+yVNGzX2zLWdNS1SVUto1msFVvKo8J0hXGy2OZ+r9NGFgJIpIRcpeT7lcoroLLf7/h8Z6MTTXcIWErlHHNH+5LjkbhQcfwupo2qxs9S0ZJYB28F34SNmwErgELasA+PearP3X8Nkcdfe0N+PyK5/+AAE8A7GCbNLyi+e8AmXuy5MLVm/7AM4nkPxWwvvto=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(136003)(366004)(66446008)(66556008)(64756008)(186003)(66476007)(66946007)(76116006)(7696005)(2906002)(26005)(110136005)(316002)(53546011)(8936002)(8676002)(52536014)(6506007)(38100700002)(478600001)(71200400001)(86362001)(5660300002)(83380400001)(55016002)(33656002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?qTScFakx8D00so+pRXrAy4ILiHtiZScfSXsDKDr4E77ZMXkVbzOKLQ0c8nLd?=
 =?us-ascii?Q?RYHh0SimVpfTlcyguKbG5vXKQUtvLDnTOExDM2oeeu2HhbfiTiSml1GL05ja?=
 =?us-ascii?Q?As1nWhqADUDXkhoV1oHNWAc1mEEBNJGt1fnZGAsqYEn9qsJNEunCqvgNpmtR?=
 =?us-ascii?Q?d7ZaYN8qnm9rFpyF8kBaGZHtSh5HiwXTeW4vBDROGEOp8VxcLOwQgkHiLkMr?=
 =?us-ascii?Q?/muufRLdWhrkC4OtK33TK8w7VnP/YnsLXV0hVJFsMz+qWoKCHSMJ6nNEUZf1?=
 =?us-ascii?Q?cWLJeLmIQ7x2eq/5TUBNaWv1qu3pV6oPnmdulh+eXYGaSEI+heoAoo8NoE+z?=
 =?us-ascii?Q?bonYIF3+Y6c+b3pR2/gY0kGeQ/BpqHdbtw3Hw5P4cYmH7JcKvghsxZNCuKkU?=
 =?us-ascii?Q?TaPz+cq0t8w8TtKLDbEt6133F5uPhLCAZgOjpbj0SfzkEoDYiqAoOMRVAIVW?=
 =?us-ascii?Q?M3hjh+D9FklkAH8tUBC3BF+gzaKroH/rAjqkduSCaMAvfdzdk5yzzAcKBMSh?=
 =?us-ascii?Q?uBdbOSaA4nz0AHlKGI0KfWFcAuLKtujTqLbZeqZnummmg/o3D5tr6DLytI+P?=
 =?us-ascii?Q?xSiziug655FqrbqZaBixWrwRAwxKbvmYbmcTZ/OMLgzwZBUvkrsCU5C/fZMD?=
 =?us-ascii?Q?y0l0IqBp3cKOIYjzmsfUhSRAek2tVFZMOV95lgVAAe3UuaI+vP0PoDKjGvye?=
 =?us-ascii?Q?3OiLJ/UESz2BfHJXFNK7ZdS7nL9ESFEFwcbXEr8Vu7prem9hwJJd4n+VAbf0?=
 =?us-ascii?Q?TOeAwi+aVeF9vU+vLld5LKRvcet6W3finBNBNjH5lZSoYwZ4ylaPHd/n2SVf?=
 =?us-ascii?Q?0D5JXSLOmo5MqFhfDCkpMgDk+nLZDMlMNQPgJER/Q9vOKewkqKAb5U2nA/fo?=
 =?us-ascii?Q?WXMJaJ1Bkch4VtA7Ug4MGSH5sRumcKX10k+hO63hwsIw6LZ0BOVaY0NljDkA?=
 =?us-ascii?Q?t13iR5Jkh/kWryic2UY4pykkEzZrjzGVCssfP7/Xcx1qDjMRIiMuHklAnheN?=
 =?us-ascii?Q?GhIR57Pl/XbIsCR/EzohFQADPZWdqs8VSZhq+yEeY1d28fQFrhpgtK4agsyU?=
 =?us-ascii?Q?gF8X36vi+99JjYWtJHqyEbl7PBEL2o4s/hCk2jCsQgzDSRCD8muLZA6MWu/w?=
 =?us-ascii?Q?Tyx4qoIgcNTKSFCBQKQ+ivAgRZtcYle/t+EiLS4gPbRDorjb2F//Wh+ZcuKq?=
 =?us-ascii?Q?2VHUYGJ2/7u3+acKkYJcT5fCz8Elq/aKcWFrDZTbFQ66AcmEj/FcltcS1eQa?=
 =?us-ascii?Q?d1CnWT9JMeujog1rDGxi70+oafElIPLGE9PjNtVc5rgtHC/90Yo3O1shsOKv?=
 =?us-ascii?Q?RqeyMAbrOFJO9NVcTiyObdFm?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2998.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04ceaa21-1a2e-447d-32ce-08d8fd9ed714
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 10:36:32.6781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9LRdQWaZTuCi7kb1VS3Wvv3Lxzm9c0oMPfkr0wunTR3L9ioLbEhmly0xK+lkMfgDn5V+idZU1GMd6zSGvEDg2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4027
X-Proofpoint-ORIG-GUID: EKYQwRuDhd2JzfaoW7MzwzTrXKB0jRF-
X-Proofpoint-GUID: EtEYFaY7rjIwPtJc_8IgN5vquTS1muXg
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-12_09:2021-04-12,2021-04-12 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Mike Christie <michael.christie@oracle.com>
> Sent: Sunday, April 11, 2021 12:10 AM
> To: lduncan@suse.com; martin.petersen@oracle.com; Manish Rangankar
> <mrangankar@marvell.com>; Santosh Vernekar <svernekar@marvell.com>;
> linux-scsi@vger.kernel.org; jejb@linux.ibm.com
> Cc: Mike Christie <michael.christie@oracle.com>
> Subject: [EXT] [PATCH 12/13] scsi: qedi: make sure tmf works are done bef=
ore
> disconnect
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> We need to make sure that abort and reset completion work has completed
> before ep_disconnect returns. After ep_disconnect we can't manipulate cmd=
s
> because libiscsi will call conn_stop and take onwership.
>=20
> We are trying to make sure abort work and reset completion work has
> completed before we do the cmd clean up in ep_disconnect. The problem is
> that:
>=20
> 1. the work function sets the QEDI_CONN_FW_CLEANUP bit, so if the work wa=
s
> still pending we would not see the bit set. We need to do this before the=
 work is
> queued.
>=20
> 2. If we had multiple works queued then we could break from the loop in
> qedi_ep_disconnect early because when abort work 1 completes it could cle=
ar
> QEDI_CONN_FW_CLEANUP. qedi_ep_disconnect could then see that before
> work 2 has run.
>=20
> 3. A tmf reset completion work could run after ep_disconnect starts clean=
ing up
> cmds via qedi_clearsq. ep_disconnect's call to qedi_clearsq
> -> qedi_cleanup_all_io would might think it's done cleaning up cmds,
> but the reset completion work could still be running. We then return from
> ep_disconnect while still doing cleanup.
>=20
> This replaces the bit with a counter and adds a bool to prevent new works=
 from
> starting from the completion path once a ep_disconnect starts.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_fw.c    | 46 +++++++++++++++++++++-------------
>  drivers/scsi/qedi/qedi_iscsi.c | 23 +++++++++++------
> drivers/scsi/qedi/qedi_iscsi.h |  4 +--
>  3 files changed, 47 insertions(+), 26 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c in=
dex
> 475cb7823cf1..13dd06915d74 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -156,7 +156,6 @@ static void qedi_tmf_resp_work(struct work_struct
> *work)
>  	struct iscsi_tm_rsp *resp_hdr_ptr;
>  	int rval =3D 0;
>=20
> -	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
>  	resp_hdr_ptr =3D  (struct iscsi_tm_rsp *)qedi_cmd->tmf_resp_buf;
>=20
>  	rval =3D qedi_cleanup_all_io(qedi, qedi_conn, qedi_cmd->task, true); @@
> -169,7 +168,10 @@ static void qedi_tmf_resp_work(struct work_struct *work=
)
>=20
>  exit_tmf_resp:
>  	kfree(resp_hdr_ptr);
> -	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
> +
> +	spin_lock(&qedi_conn->tmf_work_lock);
> +	qedi_conn->fw_cleanup_works--;
> +	spin_unlock(&qedi_conn->tmf_work_lock);
>  }
>=20
>  static void qedi_process_tmf_resp(struct qedi_ctx *qedi, @@ -225,16 +227=
,25
> @@ static void qedi_process_tmf_resp(struct qedi_ctx *qedi,
>  	}
>  	spin_unlock(&qedi_conn->list_lock);
>=20
> -	if (((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -	      ISCSI_TM_FUNC_LOGICAL_UNIT_RESET) ||
> -	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -	      ISCSI_TM_FUNC_TARGET_WARM_RESET) ||
> -	    ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) =3D=3D
> -	      ISCSI_TM_FUNC_TARGET_COLD_RESET)) {
> +	spin_lock(&qedi_conn->tmf_work_lock);
> +	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
> +	case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
> +	case ISCSI_TM_FUNC_TARGET_WARM_RESET:
> +	case ISCSI_TM_FUNC_TARGET_COLD_RESET:
> +		if (qedi_conn->ep_disconnect_starting) {
> +			/* Session is down so ep_disconnect will clean up */
> +			spin_unlock(&qedi_conn->tmf_work_lock);
> +			goto unblock_sess;
> +		}
> +
> +		qedi_conn->fw_cleanup_works++;
> +		spin_unlock(&qedi_conn->tmf_work_lock);
> +
>  		INIT_WORK(&qedi_cmd->tmf_work, qedi_tmf_resp_work);
>  		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
>  		goto unblock_sess;
>  	}
> +	spin_unlock(&qedi_conn->tmf_work_lock);
>=20
>  	__iscsi_complete_pdu(conn, (struct iscsi_hdr *)resp_hdr_ptr, NULL, 0);
>  	kfree(resp_hdr_ptr);
> @@ -1361,7 +1372,6 @@ static void qedi_abort_work(struct work_struct
> *work)
>=20
>  	mtask =3D qedi_cmd->task;
>  	tmf_hdr =3D (struct iscsi_tm *)mtask->hdr;
> -	set_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
>=20
>  	spin_lock_bh(&conn->session->back_lock);
>  	ctask =3D iscsi_itt_to_ctask(conn, tmf_hdr->rtt); @@ -1427,11 +1437,7
> @@ static void qedi_abort_work(struct work_struct *work)
>=20
>  	send_iscsi_tmf(qedi_conn, qedi_cmd->task, ctask);
>=20
> -put_task:
> -	iscsi_put_task(ctask);
> -clear_cleanup:
> -	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
> -	return;
> +	goto put_task;
>=20
>  ldel_exit:
>  	spin_lock_bh(&qedi_conn->tmf_work_lock);
> @@ -1449,10 +1455,12 @@ static void qedi_abort_work(struct work_struct
> *work)
>  		qedi_conn->active_cmd_count--;
>  	}
>  	spin_unlock(&qedi_conn->list_lock);
> -
> +put_task:
>  	iscsi_put_task(ctask);
> -
> -	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
> +clear_cleanup:
> +	spin_lock(&qedi_conn->tmf_work_lock);
> +	qedi_conn->fw_cleanup_works--;
> +	spin_unlock(&qedi_conn->tmf_work_lock);
>  }
>=20
>  static int send_iscsi_tmf(struct qedi_conn *qedi_conn, struct iscsi_task=
 *mtask,
> @@ -1547,6 +1555,10 @@ int qedi_send_iscsi_tmf(struct qedi_conn
> *qedi_conn, struct iscsi_task *mtask)
>=20
>  	switch (tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) {
>  	case ISCSI_TM_FUNC_ABORT_TASK:
> +		spin_lock(&qedi_conn->tmf_work_lock);
> +		qedi_conn->fw_cleanup_works++;
> +		spin_unlock(&qedi_conn->tmf_work_lock);
> +
>  		INIT_WORK(&qedi_cmd->tmf_work, qedi_abort_work);
>  		queue_work(qedi->tmf_thread, &qedi_cmd->tmf_work);
>  		break;
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c index
> 536d6653ef8e..8bbdd45ff2a1 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -592,7 +592,11 @@ static int qedi_conn_start(struct iscsi_cls_conn
> *cls_conn)
>  		goto start_err;
>  	}
>=20
> -	clear_bit(QEDI_CONN_FW_CLEANUP, &qedi_conn->flags);
> +	spin_lock(&qedi_conn->tmf_work_lock);
> +	qedi_conn->fw_cleanup_works =3D 0;
> +	qedi_conn->ep_disconnect_starting =3D false;
> +	spin_unlock(&qedi_conn->tmf_work_lock);
> +
>  	qedi_conn->abrt_conn =3D 0;
>=20
>  	rval =3D iscsi_conn_start(cls_conn);
> @@ -1009,7 +1013,6 @@ static void qedi_ep_disconnect(struct iscsi_endpoin=
t
> *ep)
>  	int ret =3D 0;
>  	int wait_delay;
>  	int abrt_conn =3D 0;
> -	int count =3D 10;
>=20
>  	wait_delay =3D 60 * HZ + DEF_MAX_RT_TIME;
>  	qedi_ep =3D ep->dd_data;
> @@ -1027,13 +1030,19 @@ static void qedi_ep_disconnect(struct
> iscsi_endpoint *ep)
>  		iscsi_suspend_queue(conn);
>  		abrt_conn =3D qedi_conn->abrt_conn;
>=20
> -		while (count--)	{
> -			if (!test_bit(QEDI_CONN_FW_CLEANUP,
> -				      &qedi_conn->flags)) {
> -				break;
> -			}
> +		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
> +			  "cid=3D0x%x qedi_ep=3D%p waiting for %d tmfs\n",
> +			  qedi_ep->iscsi_cid, qedi_ep,
> +			  qedi_conn->fw_cleanup_works);
> +
> +		spin_lock(&qedi_conn->tmf_work_lock);
> +		qedi_conn->ep_disconnect_starting =3D true;
> +		while (qedi_conn->fw_cleanup_works > 0) {
> +			spin_unlock(&qedi_conn->tmf_work_lock);
>  			msleep(1000);
> +			spin_lock(&qedi_conn->tmf_work_lock);
>  		}
> +		spin_unlock(&qedi_conn->tmf_work_lock);
>=20
>  		if (test_bit(QEDI_IN_RECOVERY, &qedi->flags)) {
>  			if (qedi_do_not_recover) {
> diff --git a/drivers/scsi/qedi/qedi_iscsi.h b/drivers/scsi/qedi/qedi_iscs=
i.h index
> 68ef519f5480..758735209e15 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.h
> +++ b/drivers/scsi/qedi/qedi_iscsi.h
> @@ -169,8 +169,8 @@ struct qedi_conn {
>  	struct list_head tmf_work_list;
>  	wait_queue_head_t wait_queue;
>  	spinlock_t tmf_work_lock;	/* tmf work lock */
> -	unsigned long flags;
> -#define QEDI_CONN_FW_CLEANUP	1
> +	bool ep_disconnect_starting;
> +	int fw_cleanup_works;
>  };
>=20
>  struct qedi_cmd {
> --
> 2.25.1

Thanks,
Reviewed-by: Manish Rangankar <mrangankar@marvell.com>

