Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FBFC433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 14:42:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4890361959
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Mar 2021 14:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhC2Olu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 10:41:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44376 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhC2Oln (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 10:41:43 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12TEZEt3147785;
        Mon, 29 Mar 2021 14:41:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=V4+OhJOjCWn99iylHuXhzno3MaMoHS9aBSRQljfaEEk=;
 b=oc3LGMJ3kyPZMO3wGmVD6JmJ5Z47mLnCe69evYUH9pVwTigfjxhK9SCSAcGLmjufbn6X
 9Fsvd13FIF2qKX8yoK6xcPzbRJvX4EdqiY/W7JzyCr+E8vjuE5LlLRRsGvUEBaWuXhJP
 fPPKlHFu68dzL8l3n5r3oEDISv+M5D5KzpiUkea2f+6LwjnNLwIk88U5voJBTf61uxV8
 LA+KC2aT56vqTFZ76u2UxlbbJ/eKXzv4tEgKsHdzFmGoky3PJc0Amv8wJua480qtTwza
 mQLd0OwVRxXsVKL6gRN4spVCnqeLVBtctq1AYh6iDc/QVEIYaKKsIXhwURT6PLMTAPm4 cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37hv4r3sh5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 14:41:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12TEVOwf022877;
        Mon, 29 Mar 2021 14:41:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by userp3030.oracle.com with ESMTP id 37jemvt53q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 14:41:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQIj1yARagJ/TZ6T5QdRoBmesRtrIIEytFfuwPDJn0RejYHGygmrLutM0SaLqkt6r23KYhAN/cKVD60U5Y5l8IIRTzoA0FNJFBlsmKUCjSyUVmagDkONSC2zBkU0Xi4sXGZq91okv8qC42c2NfJNVDBvTrs271qAdB7ALKi13a5OgMDlK5fNmzN+Kr+n1F3XLp3KYrzcRDWl2eqSh6Z1doRHrq9cK1XZ1VJMrq/aj03c9Ge9qMR/A5m9PEwRZ8ar3f/Mk1Mmhb389eqW7VfzQOc31dGLnnPLDIhhkn5EHZ8WoogV8EbCM8IAYFAT86m5ZwhAR/OkPzbt+3t5pZ9q9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4+OhJOjCWn99iylHuXhzno3MaMoHS9aBSRQljfaEEk=;
 b=UIbkp1D99MLuNXAfRxMLTR3TqHf2nrGRnitws/276sbGrYYpHuYe/GP2ga33+0dPMcvhlmnneu+xlfOI58OdGEN9xiDKsONAU58vyroVbbad9ZmiW08Tbc+GZSdsCLn0artVydf7GR5Ns/T2zyHZO7VpidD+KbyZY8EE/a1tg35GRbdN22WkU2Uee8i3QxJGg8mrvYX7QHx43WM+6dKKLNRS9iPAQNbzws2/SNald7QvWX2I/CyCioqFsnQU5jjzEeZQS6fyDFb8aNKeSdSxxGdmEzT7t4LBCteDfTkyyml7hu5LYm1CEbHKIgzIZnVHe39WjpdOBfNzYtynz6f0HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4+OhJOjCWn99iylHuXhzno3MaMoHS9aBSRQljfaEEk=;
 b=X72SRLlXriR/AI5C/sO01+ODORmCh3rYw1L6jkxXES3yKceju/zK28CXNDMmVfzxTv7Fm/YlfPgSD5xoMCNgQsFhiFiFeSFXjyinwwFJv6XeHG2OZiBY9lxuSZsFZj4I/5LldceQ2S/iVobyv4m/ffJbs7Xmne0CW5c/WwlNDXU=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4586.namprd10.prod.outlook.com (2603:10b6:806:113::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Mon, 29 Mar
 2021 14:41:36 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3977.033; Mon, 29 Mar 2021
 14:41:36 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH v2 03/12] qla2xxx: fix stuck session
Thread-Topic: [PATCH v2 03/12] qla2xxx: fix stuck session
Thread-Index: AQHXJHn75ylESdSpC0+L3RZCYrh6RaqbCj8A
Date:   Mon, 29 Mar 2021 14:41:36 +0000
Message-ID: <313A30B5-6FBA-49FA-A656-018ED4217890@oracle.com>
References: <20210329085229.4367-1-njavali@marvell.com>
 <20210329085229.4367-4-njavali@marvell.com>
In-Reply-To: <20210329085229.4367-4-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fab6a5d8-64e5-4b13-2ef7-08d8f2c0c17b
x-ms-traffictypediagnostic: SA2PR10MB4586:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB458637F744824CF01B016434E67E9@SA2PR10MB4586.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zFL3r0iwm7pGw6weCODZhfQuqxLAZ97PMiImFyIrUdMsfPC9ZQ4JOnHiUUYQtdSoS1CerFIgP+m3JXDj92jpRfWczR7p5ARth/F05rg4I0/lvLWWDDqISKIZdUmnyjWxWzJC4llySW/OVrYNs+wPZVvo9NaGzYGZ/mfU96yWOGUNIhtg+ouUq7uMUMkxawTcl6WsEkvwerfqlSDb0uArRnFMuj7glgu+5Ty0WXFghCmw9fTcEYwwezdvn4tC4Lg7XVCG2LwVS0GMzCRcDpN/RGZreAyOCm7qhKHng3csvsgU6uiF0MF+NII143Au1V8a0K9/n7UKxD9+JbrXLKLo+voMfnajuIs6wwmiukLqNOkmTlzmuGlYGSDGD43ojWa0SgHSmnIoK39nMyj+phZCh6K7KcLpGIEWiheIqSms5QpPmziMGevxt9UaGweEiE+DDcsw+PydLLhUGzCmYrtw2gmZlYVZFr+5gffsQFZ+WU6DTC57j9tVu9V3jQErp5bzUH12LpBLESe2T4sOqtqbeEdfLGFN5pkaO39UyraE2bp/+c8GYW98nl/IrOmuzP/A9YIlCiuUU5WyC/hcs0PZeMkRaknPuCAJ387/GqIOwG67eQf1VWixfQigR195PyPMdC8YS40y6NoYQDNPjwWo486n36UNS0z1RKm9kB/p10Uulyy1EWicWhX8i3jouQHL
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(376002)(39860400002)(346002)(83380400001)(33656002)(478600001)(8936002)(26005)(66556008)(44832011)(6916009)(6512007)(2616005)(4326008)(66946007)(186003)(66476007)(76116006)(54906003)(316002)(2906002)(36756003)(66446008)(6486002)(86362001)(53546011)(6506007)(71200400001)(5660300002)(8676002)(38100700001)(64756008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Mzeb3HwUoiLTVdptn86lpBi0AfQPmyy+geARFc35/i76SzFaSdRTafG3VUA3?=
 =?us-ascii?Q?RUwxCv49d3NihekCqVnXeLvCEYyqbnDet+HGBYOxttw1foYLfCo/vDL2kCCk?=
 =?us-ascii?Q?YAWFw/2+f4LyWv8HDeaIDebFUMXsCkg6CvC/SFXWqYrlULWzGRYuNRyRfWRe?=
 =?us-ascii?Q?akd2bJrzxAqubGbhIo/8eTQiIw0h87Wh4Gax8vcDpPXEF3F/AsVl6xSZ8j3+?=
 =?us-ascii?Q?ryd+hj+2EUObN3XwXB9J6x5/58PYFoW8eckmF3JV5F+Giu6wLBexYlJYpJnK?=
 =?us-ascii?Q?1VrW0KGdTJmsf3TiUt7KcpLkuy84e3LxSnwAVJFeGfhGIVq5ReuIyQgOtrqj?=
 =?us-ascii?Q?cS3CmCbop1KglaCVMmjm6Lh/W86DuSuEKWAGTUOFBvMwddy3Y/sGRTgw7rSV?=
 =?us-ascii?Q?wX1khPdiZXy6n+iMYoXu/ARLmlNUJym6Run3wsyLZ4DgxSU1ctdk2EoduSrV?=
 =?us-ascii?Q?hI6xyS/oVlNqkrKwX1L2ZROOzBUx6vmhZ7F9kBGJxTlrG5AQV25gOGH7c3RK?=
 =?us-ascii?Q?1yP/OTTrdGd2hhdrY6Ee96pkALDomYkVsUyupVAmoPuK9eCRnC0iPHxFFMYp?=
 =?us-ascii?Q?wNLAAYadUAdRJf9s6ZPqQTop1uECjazehBfnxXCVPDExeD3Yd1zAGmgl4P6P?=
 =?us-ascii?Q?/cx/B63li8W4c/4xypV8DYu90f3L0grm26YHfFKM8KRgNk3fM/RK971iQ7L8?=
 =?us-ascii?Q?LvWxBEjcm7OnZQGVdCoGt5DHjkCHXMXWKQf0ad//gqwLHsPeg1kDhkU9jxal?=
 =?us-ascii?Q?Bb55jFP6+1nckQSFdCCAmQSNjtFKTkOasZwlWS0N02fy4a61f5Erf2278lqt?=
 =?us-ascii?Q?UyNU7uzOcgEc7RVaU4rtCzxldkyIsZqGzyHxMatrpAyzBGldw23q8utSehNs?=
 =?us-ascii?Q?5VD8FVAwM1DxypISNryF4PAPnvYchVPqpQ8LW/kTjkrtjIxl44JcCC2F22ku?=
 =?us-ascii?Q?O20XaciuFU2lhf4HduwhT6dpUzys/oUei1W57y5hwTfXkN3VFECfKh5fEjS8?=
 =?us-ascii?Q?Dqx/NGR3nEEvzOgjUW8Aun66qK+nt+kdd04SpzpXrJM+pD52p3ZE+85iH3ih?=
 =?us-ascii?Q?qTWRHNYIoUENlik96SG7HP+a4ssytFmktyaEJh50sGYHZRUfeZKsZT4TEBsB?=
 =?us-ascii?Q?OtVKiiIV2yxj5S3xaZ+s1ED/nsPaclxgetK3NEDEy3bU0W8l5Cs/+SEHO5bI?=
 =?us-ascii?Q?a7sseJLP6LGXYV5btxyyL2IxtC+FG410rtG9rXOvxC7ggTIG1WskdGICsyTi?=
 =?us-ascii?Q?pdSFEIRUd141lU5J0kQnUCnxeUdqU5fDMtOX8DNVdOiTo6gTf77rOuWcTqbR?=
 =?us-ascii?Q?ZWkRb8S7bhanDIE52McPQusgcaZVtNBsAxNoJANf+LFyKg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <573EC75B606B924EAA8F155A7E5DD491@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fab6a5d8-64e5-4b13-2ef7-08d8f2c0c17b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2021 14:41:36.5174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NBQCL+e1/du3sizdL4XDM+n+HWHqVeQDGbKtLQPGfkjWF9vsjjgfkbGHa9HJV6EB4UNLCWbbtHk5269Q34IT44+0bkI1EJm33u0qRFnwpPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4586
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290112
X-Proofpoint-ORIG-GUID: 5bI2hmfV2acB4CW1ap_OfIZt_3lSX-Nf
X-Proofpoint-GUID: 5bI2hmfV2acB4CW1ap_OfIZt_3lSX-Nf
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103290112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 29, 2021, at 3:52 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Session was stuck due to explicit logout to target was timed out.
> The target was in an unresponsive state. This timeout induced an error
> to the GNL command from moving forward.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Tested-by: Laurence Oberman <loberman@redhat.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c   | 1 +
> drivers/scsi/qla2xxx/qla_target.c | 6 +++++-
> 2 files changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index af237c485389..f6dc8166e7ba 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -718,6 +718,7 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_ho=
st_t *vha,
> 		ql_dbg(ql_dbg_disc, vha, 0x20e0,
> 		    "%s %8phC login gen changed\n",
> 		    __func__, fcport->port_name);
> +		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> 		return;
> 	}
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla=
_target.c
> index c48daf52725d..0d9117a30ff6 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1029,7 +1029,11 @@ void qlt_free_session_done(struct work_struct *wor=
k)
> 			}
> 			msleep(100);
> 			cnt++;
> -			if (cnt > 200)
> +			/*
> +			 * wait for logout to complete before advance. Otherwise,
> +			 * straddling logout can interfere with relogin.
> +			 */

How about this ??

			/*
			 * Driver timeout is set to 22 Sec, update count value to loop=20
			 * enough time for log-out to complete before advancing. Otherwise,
			 * straddling log-out can interfere with re-login attempt.
			 */
> +			if (cnt > 230)
> 				break;
> 		}
>=20

> --=20
> 2.19.0.rc0
>=20

--
Himanshu Madhani	 Oracle Linux Engineering

