Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 828B5C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CD3861A14
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 15:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236648AbhCXP4P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:56:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:38010 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236850AbhCXPzr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 11:55:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFs1EN135279;
        Wed, 24 Mar 2021 15:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YjI+IFaEcRcA3Dde8/r5i2OqoSAjB+qp+Ovkmc+IrC0=;
 b=Y712e1X3vqO32XaAypobqqOgEYvH2hw0HJcNsyAXYmu3GxJIJMdtazNLfL6k/i2PyaKx
 bcWJHvuU93vKL8lSDGcs3RL7/nHfazayl18oZ32sl820sF/lwqybEQwmmulpBafUK11D
 K0/AyjhLe1EqFWAFQDHBS83Pid5dQVGnPoiNgKiKJii2u0K8SrrAzSk0RQz0HJw4NKWW
 w5Ytw4bKA9IsNqyToxolu4EVI4IfhEpyqJI7eIlhhnEFjzNwxR3s6J2AJiOmDX40Acuv
 IRCUgmMY67lQ2CRuhPLNzQw34zJMQ0zsriFdg8fGXpryncoJw/gN/Po+EbQHN/GCOXjb jQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37d9pn37fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:55:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12OFaRAx044509;
        Wed, 24 Mar 2021 15:55:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by aserp3020.oracle.com with ESMTP id 37dty0rfta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Mar 2021 15:55:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNpkcXqoibNzN9geHKfud5dFt9JsQvubaDSvnGEDw1/0cAJDlrL3Q7v4ZI+q2An3/dlczPi2L+3eyWKZjq9axkPSn+tiUZMRKQlO9PStHXjxeNeaqj5kNqwgxH4QUfuBCtnU4HLq8LSRWGt1EH9eqFKeFNv0cgc/f/OCl1vqMgANIjriRsHhXcGrynmmY6Ic8MgGdd9xDbJxmrncKIyJXZtOOtF5UN5JXjYj38dsInDtps4TqmDfsCtJTrc98HSM7WbDatYAAB7t0m2BuwKTUXMU1hweyjXK+ZakV2dd3CGcykKPQ4nzaDDy9O7UkAHgWfcmkp4KB/OkyEhWB9S8uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjI+IFaEcRcA3Dde8/r5i2OqoSAjB+qp+Ovkmc+IrC0=;
 b=gCshisAvJJK/YWTbSBaTxUiIrLQwFu0ZDIsH/qWC1HJkK9SMdZeSJUp8myL2DCG+8rg4m5e6XlGRr0okVmBdfLOnCwegGT1c/SmDsTXF0IGY/admRySWXHCnTLNInKtzVmYaiOVO9rYMeIsy2kOolWuJt1hWeIrSIVvAZ1TZDQ7+7/x6+IGcrbcnpk/TQVJsXXDhvmsG6tmJwqxTX7EUBnKGnMDFukk0hacUW61Z4qypiwxQXmw8JQqxw9n9NSCaGgdSAIXvM9wPtn7B2+oGQ2R0izbuAy5iKC1hM9JxuzJcPWoi5qs1+Ki/qWjPQrlL+KbKrRcFsxqXrk7KOyMc3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjI+IFaEcRcA3Dde8/r5i2OqoSAjB+qp+Ovkmc+IrC0=;
 b=E9OIQGzOWsClJmPv28sTDW6r8b7rnD/mYx3Mp7EcxWc2JyMpBdSoMPmpyZ69/ZZ3yUFiq07vw7yTlRC9rqVQSyw9PrrVvidOGMf7mS7M4ZCOK6RIgWPUw2F+db1QrKqKgGtN7VkZHmgDWFfkS3+41FF28cOpUXRHhTvp4urAerY=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4601.namprd10.prod.outlook.com (2603:10b6:806:f9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Wed, 24 Mar
 2021 15:55:42 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.024; Wed, 24 Mar 2021
 15:55:42 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 04/11] qla2xxx: consolidate zio threshold setting for both
 fcp & nvme
Thread-Topic: [PATCH 04/11] qla2xxx: consolidate zio threshold setting for
 both fcp & nvme
Thread-Index: AQHXH59gaoRd0z/+ukG3+AwnNGXJTqqTTQoA
Date:   Wed, 24 Mar 2021 15:55:42 +0000
Message-ID: <4E40DDBF-D024-4B15-8BCF-584BFAB5258E@oracle.com>
References: <20210323044257.26664-1-njavali@marvell.com>
 <20210323044257.26664-5-njavali@marvell.com>
In-Reply-To: <20210323044257.26664-5-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [71.42.68.90]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 257aa176-34dd-43b9-ec1b-08d8eedd4760
x-ms-traffictypediagnostic: SA2PR10MB4601:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB460139C08375B2D036297CF1E6639@SA2PR10MB4601.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hJ8NgvwMOolS5v3pOhNgM3Y2W2xEjN6a1HRg6+Rc++NVDpEY5Xxf7lbnLhVCag631UisrianApKH/wM3V+RxGIff1RgvNarNJ9Y74BtRkqTCTABtTQUTZ9QNSn/T+dW6iLTgVuVg4D9iSb5AjHvZs39o7fRuWLJJBX/blnHF6zRRED2u67PGxslh8+bwG6fQoKRShV+ZY6r/DSrwwO1TyutjWmY6kavXPsxuboCkmtecPBu+GeYK0RL9yqhmE5KFg95OfIKaB39yjXrOF0agNhlRwulpu+5j5U4zyLR62LkiGUWTG2POILQ+vTbz9vdj05LRnjNWE16MKlaAj4ybfEf0XAMijm79NTzSv+pI7aLee1kO1ZsToxdWKDUTp/x4UP3Q6vWVrvARgBmNfvNqwb7c/sHx9y5oOhGum0padcZV9jRRnRtgx3Xf89IWA9NLoY55YOGg5/zTz2e6bsLt20qwhWaWt9wn8L6CdmDiP9hxgtWspIavjKPyUoE05gmQvJpkMyfM/rke/PWAyb84RMhJffgpMjyDDLMwdocH55POHcEiD/EduD2ElbpBgmrz81tO1Hz3VCQqjxVFDt02gQq88xhXa5stnrbspjpEYfBorsK5thA6JYSa+il7A20MR97MPNsA0IJ0r8dvjAxwLw/rAGErtfdJvCrFLYzsJiN2JKMWW0ruVS3+QZwC3/+W
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(39860400002)(366004)(346002)(64756008)(83380400001)(6486002)(186003)(53546011)(33656002)(66556008)(4326008)(2906002)(6506007)(6916009)(66946007)(26005)(5660300002)(8936002)(66476007)(44832011)(66446008)(36756003)(316002)(2616005)(8676002)(38100700001)(86362001)(76116006)(71200400001)(54906003)(6512007)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?puxbWON67qReU+xd2PO6dWifjwbVyEgZVVxTz5g60ZbgFyOgqhKEBMrd2Lyx?=
 =?us-ascii?Q?HaFZNcAe8h4tUutZf1TaB2mKR1/KvQc0FAIJFWyrTCwx9qVXhw2Qb2macaqg?=
 =?us-ascii?Q?ZQDBJB+ueCoihq+T4uSzeYHo+CvRG33YaCTzu3M2S08q3QJlwk8GDkqZpDmo?=
 =?us-ascii?Q?yMp/oN0A1wUGE4fbXx1sb5dUYu9Wqs1zTE9qio/584znqLYwNbC5JeiPoQff?=
 =?us-ascii?Q?u2/uDbMIvI7BQcyolDC3HC0c5W2odtTCkGwVPoYZdK047kSetosNx9jRZNiq?=
 =?us-ascii?Q?D5OdftbA+L6prLwwwSGTNdhBgAGjALDeiV7X7asMdJGKjSow96KrdHCvJjCn?=
 =?us-ascii?Q?/80B0fpUXSeUVQf/BDzHt+Mi6SJDHvrGttBiqlOZfq1dVmlJU6BE1rCyV7AO?=
 =?us-ascii?Q?3B8Nl2PH1k/pb77UPF8z5RVM3F/K2ncQH4nmU/hI0Y67Cks2koN0f8Vj06Hj?=
 =?us-ascii?Q?SeUdSBgQVKRMej5DDYkwbMOAodP0T0fOLfSJFSbZDwmyRXHGWGo6obMXo2hp?=
 =?us-ascii?Q?TnRPxFCR1ItMZAffg/b/OidfngaBMSR/jcwihEU7ZB7AlD6plqucAsfuiGgA?=
 =?us-ascii?Q?GnERA+rjaNT8aG19iXyN/azRKJcTzT/u93X25LuRNFvGwgf4CTNVFvYQ2i8d?=
 =?us-ascii?Q?RcsUHu9lzmE2O2p6fFed9V9KDZs+VcRbgMr8ZHgZvhcLcd4NohMYCXrfTI4v?=
 =?us-ascii?Q?TuVY7ZKfXKNVfTSshx0oc/GLy8uMCOG8EgEY9+AFSMCOAP//DZowUFqKs9hb?=
 =?us-ascii?Q?ZUXqTrHg5LvyzAO5B0uvcpR/wMa3CsSJJVdjUBuxJBTNEaa8PxT4IwI8sJd6?=
 =?us-ascii?Q?YSKJTCD3AZq4N2k1Onhaq91cFAMakuaRI3+8LvMT3xGElY/uDC/TEwmGc6Ns?=
 =?us-ascii?Q?ivhTQf9LqOjBmfDZ1HU/tH25vUsDAcJpOroohN3U/vyGuZHXywFJLCn23v8u?=
 =?us-ascii?Q?jsUXxkY2G0o18dY6JdPGKbxQHpU51G1UD3cZWo3IBA+CaGTzretzUgnWaWQ+?=
 =?us-ascii?Q?rM7TANaRD7SiMJI1q5AVvsotA1Diarj1fGvIy5GzaXDqn0zGsANgJhDbNtMJ?=
 =?us-ascii?Q?ZYW576iCAStdj8XJtazJ7P3fMqWbjT6z8BF48hcld8dBv1okg5UAxjQyy3mw?=
 =?us-ascii?Q?SOlrjAvJiMQCK4dDvX5TooySX0e9n59usV5QUQ+3+RHByiQYWKwd3/gCfL2o?=
 =?us-ascii?Q?Uei/yfB4cy99W2aWY/oOjIVaMV6U2tTdB8/CeB4yg/RZcmCOI/tf8fYJ7LT8?=
 =?us-ascii?Q?FvhQRTacKx7Sm7HejqAf0QUOMXhP9nZ97MS89S/cYnjDno0PWTOLU5gG18b8?=
 =?us-ascii?Q?W+912Cy6vjUaiXqq5MnGorbc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F91DBE8C1383D044A2C68BD61F260D50@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 257aa176-34dd-43b9-ec1b-08d8eedd4760
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2021 15:55:42.3943
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q+H33tDxtGYX21CsDXwcXcsZdW153Jog9GFrYy4Ez/Av5IQRhjUX2xYm6jTDQ/x3nChAxvRPbzONtzhDkxsJfZSqt9Q1qeJ6tuyeUc8Ka8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4601
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103240116
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1015 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103240117
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 22, 2021, at 11:42 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> consolidate zio threshold setting for both fcp & nvme to prevent
> one protocol from clobbering the setting of the other protocol.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h |  1 -
> drivers/scsi/qla2xxx/qla_os.c  | 34 ++++++++++++++--------------------
> 2 files changed, 14 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 49b42b430df4..3d09f31895e7 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4727,7 +4727,6 @@ typedef struct scsi_qla_host {
> #define FX00_CRITEMP_RECOVERY	25
> #define FX00_HOST_INFO_RESEND	26
> #define QPAIR_ONLINE_CHECK_NEEDED	27
> -#define SET_NVME_ZIO_THRESHOLD_NEEDED	28
> #define DETECT_SFP_CHANGE	29
> #define N2N_LOGIN_NEEDED	30
> #define IOCB_WORK_ACTIVE	31
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 074392560f3d..6563d69706ba 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -6969,28 +6969,23 @@ qla2x00_do_dpc(void *data)
> 			mutex_unlock(&ha->mq_lock);
> 		}
>=20
> -		if (test_and_clear_bit(SET_NVME_ZIO_THRESHOLD_NEEDED,
> -		    &base_vha->dpc_flags)) {
> +		if (test_and_clear_bit(SET_ZIO_THRESHOLD_NEEDED,
> +				       &base_vha->dpc_flags)) {
> +			u16 threshold =3D ha->nvme_last_rptd_aen + ha->last_zio_threshold;
> +
> +			if (threshold > ha->orig_fw_xcb_count)
> +				threshold =3D ha->orig_fw_xcb_count;
> +
> 			ql_log(ql_log_info, base_vha, 0xffffff,
> -				"nvme: SET ZIO Activity exchange threshold to %d.\n",
> -						ha->nvme_last_rptd_aen);
> -			if (qla27xx_set_zio_threshold(base_vha,
> -			    ha->nvme_last_rptd_aen)) {
> +			       "SET ZIO Activity exchange threshold to %d.\n",
> +			       threshold);
> +			if (qla27xx_set_zio_threshold(base_vha, threshold)) {
> 				ql_log(ql_log_info, base_vha, 0xffffff,
> -				    "nvme: Unable to SET ZIO Activity exchange threshold to %d.\n",
> -				    ha->nvme_last_rptd_aen);
> +				       "Unable to SET ZIO Activity exchange threshold to %d.\n",
> +				       threshold);
> 			}
> 		}
>=20
> -		if (test_and_clear_bit(SET_ZIO_THRESHOLD_NEEDED,
> -		    &base_vha->dpc_flags)) {
> -			ql_log(ql_log_info, base_vha, 0xffffff,
> -			    "SET ZIO Activity exchange threshold to %d.\n",
> -			    ha->last_zio_threshold);
> -			qla27xx_set_zio_threshold(base_vha,
> -			    ha->last_zio_threshold);
> -		}
> -
> 		if (!IS_QLAFX00(ha))
> 			qla2x00_do_dpc_all_vps(base_vha);
>=20
> @@ -7218,14 +7213,13 @@ qla2x00_timer(struct timer_list *t)
> 	index =3D atomic_read(&ha->nvme_active_aen_cnt);
> 	if (!vha->vp_idx &&
> 	    (index !=3D ha->nvme_last_rptd_aen) &&
> -	    (index >=3D DEFAULT_ZIO_THRESHOLD) &&
> 	    ha->zio_mode =3D=3D QLA_ZIO_MODE_6 &&
> 	    !ha->flags.host_shutting_down) {
> +		ha->nvme_last_rptd_aen =3D atomic_read(&ha->nvme_active_aen_cnt);
> 		ql_log(ql_log_info, vha, 0x3002,
> 		    "nvme: Sched: Set ZIO exchange threshold to %d.\n",
> 		    ha->nvme_last_rptd_aen);
> -		ha->nvme_last_rptd_aen =3D atomic_read(&ha->nvme_active_aen_cnt);
> -		set_bit(SET_NVME_ZIO_THRESHOLD_NEEDED, &vha->dpc_flags);
> +		set_bit(SET_ZIO_THRESHOLD_NEEDED, &vha->dpc_flags);
> 		start_dpc++;
> 	}
>=20
> --=20
> 2.19.0.rc0
>=20

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

