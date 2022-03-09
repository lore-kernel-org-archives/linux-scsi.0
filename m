Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B43C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 18:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbiCITA4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiCITAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:00:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4689E57D
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 10:59:53 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229IuVvb025994;
        Wed, 9 Mar 2022 18:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=1lmFxS9IFZcxrvudXdcc/s5HuFbqIBQzoDC7CMNo91E=;
 b=rbTPjZvq8BLHMQv0/Jqd8zG/cwsljpYw4iFVZBa68U/ThpivMUkW7CEp00VBnh53VbrF
 qQFAZBMLxEVJf9y6+ZCJyFpuW5G0dkgGfwYID+NCkpHV8Zw/EYxYMSgYdHr0OBwYl4m5
 qASr4nBN6yx71OB6LhJcqbTvFwejXGvKFIDklqMnrfiuNTYPa/ST7VJG1j4otIghqB5/
 sOQkE4CKwfb4ePiRvThmxo1eaYM0In0IyYJRpIrLHhJPIG/XtI2ROQ2NCxh4HOS0yKsC
 R2SoS1OlTB/c+VCb+nCpfOVFLt6E44JLaVYxj/bJguoeTmAlXI0x2HOfE8aDQVe7R3KZ sg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3em0du3765-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:59:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229Ife5Q166887;
        Wed, 9 Mar 2022 18:59:51 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by aserp3030.oracle.com with ESMTP id 3ekwwcytdr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:59:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cl2SMbe4mZK4nVZlzuVJ4oZQ3AZG+/+krM8W1BxxufhjCiF081e9gUhhF84hEhuRY1Vw0WnkXQj7NyEruMzHglRJt4r4waRqQJcrL30E7tgdVVr0OznWbHZS3dhafOQcIskraYjgBd+2n4TCUSGcIi0nuuwDMwG94NXkojXvdh7S5c+qbyAYUoE9kF3x+6h4IZMqr3HA8r2jqdAQG3vuZM9WN4j7vvIUfVzZt2yGMGiYT2ZKcPAe6fs97m30ff+SrDQ8H0y1BMwsLqJFaTb+ixf5ymSu/H3yHlluBCk0tXOI3a9P8GltQmXth3j5PT46mHuB5MthQfpEeDajGdGDMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lmFxS9IFZcxrvudXdcc/s5HuFbqIBQzoDC7CMNo91E=;
 b=MKIvBhKrtTAA0z1skLTQsjjrNrCCGDcyhe2xD4NSDqTGbJNeaCr9AT0si+vSwzsk9QEj2vcn71tjKgQ5jX0ytJCCuiYRtmCoy1AYYXKHt+plKBPLpuD9bZn5bSaa3PmfU+C5JrM2tucFgLNATpTzaECd38LQ+pm5SOhX3LwVG7CvWLCwJGCbZXI4IBe2in8o6cl8+DV/Ee2u4JaMf0/4h7RrysGsV1h6xzt57xnUcW90v/jkQPeaE1v50V7T1RHNIX9Qr9rZinh2aSPI1kNWIjVsrFmSzswtMts0rZTcczAuZ6fTpampaHVnSctH1xCjd61dkdXX4XEZyqnemRzDhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lmFxS9IFZcxrvudXdcc/s5HuFbqIBQzoDC7CMNo91E=;
 b=dZZfnq/R3b8lPetfZZI0+nO+IdqEPWvRhwUDDXfKlNTY9twR/glUDbxENI1SuBPlqeG2XNeD5duPaJYrC3jidED68ynlrMxFYiKsID4p2Rofu1vMEVv5TP7tsF038483lIbw1yv1CR9IacCjPrHJ+wa+vcEdZEhe5MD0VkXp3Mo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB4397.namprd10.prod.outlook.com (2603:10b6:208:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 18:59:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:59:48 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 07/13] qla2xxx: Fix hang due to session stuck
Thread-Topic: [PATCH 07/13] qla2xxx: Fix hang due to session stuck
Thread-Index: AQHYMsWH7ddqSUIzVEGjXrpOA/LJY6y3aicA
Date:   Wed, 9 Mar 2022 18:59:48 +0000
Message-ID: <1D7C3911-B44A-441C-98B6-1C3ACD474072@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-8-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-8-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17198315-7d8c-467b-6b24-08da01fefbeb
x-ms-traffictypediagnostic: MN2PR10MB4397:EE_
x-microsoft-antispam-prvs: <MN2PR10MB4397E72FB500A6CD7C3E01A0E60A9@MN2PR10MB4397.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uGBduvlDMoLZ2Z9ujU8r9H0BRRf0/QpEbldh1GcPEvM55NedLMkjYOzvvRhVRwxoUCDznIb5nWvQhWgqhUZVXLo1Y+t+esdBrlNtEiCCUtD/ZtUnXhXWwDl3nsyVoFmisLh2R5ECH72+YvJ60FIXiy8vzigl8MjM5AgRviq5E1Y4+uRWkpzfckAAW80lSQTlG7Qvcv/TmLHKni7ox1V3QnTbetoqSTflRbmq26V/fxM2DbrYR7Kj0H0B7YIudRDXFnya/OQT8e5a+QGJrsSatP2TqbsaKDVNtZSsSu1WfaVxvl5zIh1/A5IJU9k7T2/JWJJotmaOxpZIPwOzKMIgk6G+VaXc7eIhZNqGE3YlnerQzgWd3F8zouKrbAFm3uD5IIPc3wl6FE4Cbu3wxNgC2dZuJjDYGT1Q32pDD/6SwAvIuST/RMq23eF4tIhq9EYV/i0BS7jL3XA9k1HRhJznYU2lpgQSppkCM11kx8xCRGag7wYG+NcQTgn/cf84uL4r5jaxu7mbiaoDdxXg2sIJQywxbXsVna8YOGav5jReG6mRa+/OAByLDJGbor06B7+u8DLKrIp6xo042jsDMhtQYKZR2Ye/O7hgyrLcgZFqJ8gek0UB1eoLRBN5/7Fil5ZyrmOjkHkS+lW93MSWW09A2REfZZq/zUMq+/Qq6rd+ZGuD7ZZHAvcwNLxswcEjiWFe9G5EGRWAQk1TJGQMIiJejQlTU/6hy1qXMhnwwBuGyBy76PTNGk4YDDcoOzdjiAkP
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(64756008)(66476007)(66446008)(66556008)(91956017)(8676002)(66946007)(76116006)(38100700002)(122000001)(6506007)(53546011)(54906003)(71200400001)(36756003)(6512007)(6486002)(508600001)(6916009)(316002)(2616005)(2906002)(26005)(186003)(44832011)(38070700005)(8936002)(33656002)(83380400001)(5660300002)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?His/B+x2SlbFDJ8H6+1dejMd1fRUPhNc+b+VN188CiCJv1k6Kgg9lnSZ3nza?=
 =?us-ascii?Q?W1vdPXi2lVmZuj+zmXg6ovySIWh+p6CRsHyNOX7hN9vgWucaqJRFqhQXJ7vV?=
 =?us-ascii?Q?J5cnWSKHrRJOeToTJsVP+2Ci7RpFMaD94/UFsYG9fHvaJ1JrkW+jZiM0e9iL?=
 =?us-ascii?Q?GREU8dVhjxdGbyzNm2LcEvr2sNgWuBfNLwynZs93kl2w8/5f8kAYmiU4+UTn?=
 =?us-ascii?Q?2yqiQ38cpdUVP2kbqOO7zwrVxCUYe8lb/U17bPkQkq5hoDruTAd1QXfe9tvh?=
 =?us-ascii?Q?BQb0lpOZIFnIkl+Q+u2AVJYOavF2BMZYH34ptMRWh8nRYtmiDOH0SZ/8ntnI?=
 =?us-ascii?Q?TF1LTcclhDRSHK767q0tKr+KPl3ex7I7dO1YEsb62jm6DtTQmjgWXBsc5Xgu?=
 =?us-ascii?Q?MQD5cgZc5JIa98uVtW9GQy7GnDgEh0aYmNzHBSOj/no/6fADK9BX3qQyGQNx?=
 =?us-ascii?Q?0jSqzbrz/rfhb8iKgHJ/w6gVWXHMn/50md3DN9akWmlkd1mzhARAzAw65XYO?=
 =?us-ascii?Q?prcidTaCRpCjlvhmE6N/EziQwMvkK4KP0Te9cMuecmiBikAByixFZpYpxQXk?=
 =?us-ascii?Q?cZTSU0oNLr6NFeitYR+/2SLlmozU84wt7RZNUf4Q916lutN3vbiMkFiGzrRG?=
 =?us-ascii?Q?IuBjzw1/Bffac1vitoqCdRJPURv2wqjf6mVr6SMC+1L4FL9/rrcEbI3LXpTt?=
 =?us-ascii?Q?1KhnrfaQ7EnPbsB5ru+pt9hC6ofQoSY9z+RbIX/eIln/xtviXAR6p4U/0Udt?=
 =?us-ascii?Q?UJPhYdRnYcBYVjRuCK+DvPILq3qHtz7Lx+vR25/xYLiKpNJavdT9DdJbWwuJ?=
 =?us-ascii?Q?edUh2KXh5g3DiY2dtPK6zk1alaN3Tv/ooBFDFqp0uDlzUEngMBlsGrZm0l08?=
 =?us-ascii?Q?ctDi37htU7ESBmLNPOXGR01lMIApxFglmLhOubUTZHHL6QEpoWh3ZzUgM1e8?=
 =?us-ascii?Q?0A6UAcBDPvQ529MbhYP77kYzLhRvZHzFa07IFJxKQuytsBk9gaTvUxADCTQL?=
 =?us-ascii?Q?cskrjFXLCZcvtV2/zjti5H/9gg5GCYaiwpPSIJDlyNsjZ6Aems7evCYeMjGQ?=
 =?us-ascii?Q?gyXiElQZwxEaWIIXaTuT3zuDMrlCdEeabB9X4wrnPO3w3/Lncgz04eZdSFEq?=
 =?us-ascii?Q?wcYyU2EjqRIrmpa0NS5NQIi1sqIAAW57z34r+0w1R870VbXLyztAL3TVJ9fH?=
 =?us-ascii?Q?kL/vJ6XZFS5jIzFATLVVnnOO/1SRBlhgvbC2ev9aIjUZ9EU1/sFqSCy3qXkY?=
 =?us-ascii?Q?nMIugyFjC7eSAUO8Lbt/AGAFaT1+jIADzLLBHsWFTru3a1C58oKHRHZN5j/G?=
 =?us-ascii?Q?ZyqWx4qqpGmrORpULInC9GWqbpANL/ImrqSep45wSpkIYN9BDpdhQAOiaxgf?=
 =?us-ascii?Q?OeDk92FmvXqjDuyEqRkxXURrcFup0F9rxHWbdjNlMjxj3AEUzsM+k4z9eJ52?=
 =?us-ascii?Q?3CNsFetr/frjHD3JIrBeDrIoxK2WUJCRik2QIHA7kmrFsL659SyKeXHcaQhW?=
 =?us-ascii?Q?Y3tWTU4Am9XYeQYVnKwIofSP7WWe8Svzdf5uDChPq/+iybcIaCYfO7YImBye?=
 =?us-ascii?Q?fEwwEbQxY3Bvaj/io5ABWbFRsdy7ngEbltF2xJuGOZqdu06PXQc1XuotutVP?=
 =?us-ascii?Q?wtg3Uh1v3WA3BTjylhNv/7lsTnYu5QRQbAHKzg3/Y4VG0763PQ2imEpzWEu0?=
 =?us-ascii?Q?/XuyILXP3MEe7nz+WV3o5ki9+qc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9AFB3AC2A22E5047B7A305DA74AD3CE6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17198315-7d8c-467b-6b24-08da01fefbeb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:59:48.5083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xY6AW03XHcbyIsjyIzG0NFa2fmhhHZRShE2jc3r6/7DKvoFEe8DgpABuwSNRrWuLqheVMbfsv6ejXi3+81IgKyWrEBKMlxCazw5GzYzmcu4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4397
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090102
X-Proofpoint-ORIG-GUID: pNpfJyfUXgmS-I-bIDt-lFIaCQVb9HKn
X-Proofpoint-GUID: pNpfJyfUXgmS-I-bIDt-lFIaCQVb9HKn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> User experience device lost. The log shows Get port data base
> command was queued up, failed, and requeued again. Every time
> it is requeued, it set the FCF_ASYNC_ACTIVE. This prevents any
> recovery code from occurring because driver thinks a recovery is in
> progress for this session. In essence, this session is hung.
> The reason it gets into this place is the session deletion got
> in front of this call due to link perturbation.
>=20
> Break the requeue cycle and exit.
> The session deletion code will trigger a session relogin.
>=20
> Cc: stable@vger.kernel.org
> Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |  4 ++++
> drivers/scsi/qla2xxx/qla_init.c | 19 +++++++++++++++++--
> 2 files changed, 21 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 47d7fa1c7ae8..b0579bce5b88 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -5437,4 +5437,8 @@ struct ql_vnd_tgt_stats_resp {
> #include "qla_gbl.h"
> #include "qla_dbg.h"
> #include "qla_inline.h"
> +
> +#define SESSION_DELETE(_fcport) (_fcport->disc_state =3D=3D DSC_DELETE_P=
END || \
> +				 _fcport->disc_state =3D=3D DSC_DELETED)
> +

would you be open to changing the macro name to IS_SESSION_DELETED(). Since=
 you are checking for pending deletion in progress or deleted for session, =
name SESSION_DELETE is not reader friendly.=20

> #endif
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 6ffe44b805b6..3c58a2911937 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -575,6 +575,14 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_po=
rt_t *fcport,
> 	struct srb_iocb *lio;
> 	int rval =3D QLA_FUNCTION_FAILED;
>=20
> +	if (SESSION_DELETE(fcport)) {
> +		ql_log(ql_log_warn, vha, 0xffff,
> +		       "%s: %8phC is being delete - not sending command.\n",
> +		       __func__, fcport->port_name);
> +		fcport->flags &=3D ~FCF_ASYNC_ACTIVE;
> +		return rval;
> +	}
> +
> 	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
> 		return rval;
>=20
> @@ -1338,8 +1346,15 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, =
fc_port_t *fcport, u8 opt)
> 	struct port_database_24xx *pd;
> 	struct qla_hw_data *ha =3D vha->hw;
>=20
> -	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT) ||
> -	    fcport->loop_id =3D=3D FC_NO_LOOP_ID) {
> +	if (SESSION_DELETE(fcport)) {
> +		ql_log(ql_log_warn, vha, 0xffff,
> +		       "%s: %8phC is being delete - not sending command.\n",
> +		       __func__, fcport->port_name);
> +		fcport->flags &=3D ~FCF_ASYNC_ACTIVE;
> +		return rval;
> +	}
> +
> +	if (!vha->flags.online || fcport->flags & FCF_ASYNC_SENT) {
> 		ql_log(ql_log_warn, vha, 0xffff,
> 		    "%s: %8phC online %d flags %x - not sending command.\n",
> 		    __func__, fcport->port_name, vha->flags.online, fcport->flags);
> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

