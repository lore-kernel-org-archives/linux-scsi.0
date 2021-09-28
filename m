Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A32FFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 01:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E0BA61247
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 01:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238452AbhI1BhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 21:37:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:23374 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238428AbhI1BhP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 21:37:15 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18S0i33R011470;
        Tue, 28 Sep 2021 01:35:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=AiD+mUhRfcFeCpjjXE85O63SFAQ5xinetwKCPUXRxs4=;
 b=sUi3DYDSZpIfpZQ2u9hNbG7SCUHgBYFe22c0K/hVN8YHm9WuZ3cI6SCUEpMeYCVPGQ2E
 7iEz9nNmy2Kz9a4l1spzS97iBrYQ38IiGzgZ0UZ3F03oZkI9lpATTru7JA20uEfbSU9h
 HFWwDTQN0d6NraSb0kZ3NB96wInDF5wM5rA4NHPw/UK4hJvgnOBEwsvOgEtt/8yYFedy
 Pz6zzsMuEYgeXXrva3r1fCjVpXWjleBIYgUZoaGGAzqmry8vNUTEitS+nd55NfC8n1Kh
 THctnMfg7snLTw8yLXVuQoqLuv+CihkEpO8v8NHJ/NwIEvodBmdct9I+pYw6RWfrraef mA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbh6nkhxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 01:35:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18S1TtDQ106197;
        Tue, 28 Sep 2021 01:35:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3030.oracle.com with ESMTP id 3b9rvukacq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Sep 2021 01:35:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEwdLih9XpZE1ykJDMAZjhOFotuL9vTFF3Cy/JwJH07Wx11Sxsg93PJ+umh/5IzNWnTAf8uALJDgIknCU3mJ8j9gi3F6ZVrOzWgD3J8TwgWDQsT/PiNIByxIgw09b6EXp+veWHTiGJe+TgIbcS/a8vG+rCIAlQd1GQwz4597rhiMMU+RrW6lKxIYgJLVuVcqKEmzYAhgbm+tzxLFylP3oI06dicXJ+zMb6z2vq8jqMyITrtRri4+Gl/GdwrUqiegtae0CwVNmH9NmjD22AdWEbFaweDlcaJ1Iob3snJq+/BjEQ+2AMLG3cS7+wVnxRRAwg//QSl+mBUQbuOa4w3XlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AiD+mUhRfcFeCpjjXE85O63SFAQ5xinetwKCPUXRxs4=;
 b=LUDUuu/9GHJgPVfXzpjpbzmPmig+5Cn/JpiFnDo4rlEt8exzlAiD6fJIIiYBzg2r1tCJ/AAmZU4DTQzlwI4fD+cxHNb+Uq+wL8iNQKKOiaj0kHOyte+45hRkS6a9auoJ8EIc8c+TaC3Z9c4iYrznPYOn2E1kSbjLJP2SOPoDMlvc0ovxtHtUniMvzpulV8ZLSDb1cUz5FHmmHdA1kRrCT6J4t/MSDhGICr1E6cVx4CZboJcfqtIsIrEqB8AYI99NWH0C0acbZzve/er+GHZMCYYL4HCtZbZEWhz19J9N+ML6ax14cjxDir5Y31w20jewGYhbE7UTzh1zB6tCixftJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AiD+mUhRfcFeCpjjXE85O63SFAQ5xinetwKCPUXRxs4=;
 b=Kz5f82qww9iVjIgv/UcHtChAaX9AgpTQwhT0SqUe0QEw+ysXOgpb2an8SP32w5HqkvjEbFO+seKWnI4Qm6FeQDm4NMy8dxOKIFYITa4i0PQ7ih6+qfXL8GGzR70M30V1YPTpVchVSrNxi/fnOktb5vsIWHDj8/T9HPj0ZkEsAQc=
Received: from BL0PR10MB2932.namprd10.prod.outlook.com (2603:10b6:208:30::16)
 by BL0PR10MB2929.namprd10.prod.outlook.com (2603:10b6:208:7a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Tue, 28 Sep
 2021 01:35:26 +0000
Received: from BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::cd5c:2ca8:3e2a:bb2a]) by BL0PR10MB2932.namprd10.prod.outlook.com
 ([fe80::cd5c:2ca8:3e2a:bb2a%6]) with mapi id 15.20.4544.021; Tue, 28 Sep 2021
 01:35:26 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "emilne@redhat.com" <emilne@redhat.com>
Subject: Re: [PATCH] qla2xxx: Fix excessive messages during device logout
Thread-Topic: [PATCH] qla2xxx: Fix excessive messages during device logout
Thread-Index: AQHXscDMcQafRS+Zq0KtukZ1ivPvw6u4rrcA
Date:   Tue, 28 Sep 2021 01:35:26 +0000
Message-ID: <F8363ABD-C714-4D77-9685-5E54B0AEF61E@oracle.com>
References: <20210925035154.29815-1-njavali@marvell.com>
In-Reply-To: <20210925035154.29815-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62dac85a-39f0-40f4-c354-08d982203f93
x-ms-traffictypediagnostic: BL0PR10MB2929:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR10MB29299E3FCA645B793AB92C75E6A89@BL0PR10MB2929.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1247;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A7xD0sFg6jmbIEFWIAZ8GpaH2r0lahMRVCUNKqfJPiZsU5XXmmBczKOq570GeVRZ4VoPCcl+W0hwEnsSGQ2nL0MZEAJ2nL/jrc03oQedxuLVe6hTcjr7IxxIMBJknEk6PIAuWvWM+Dtpgp2ji41S6nuzgQah0vJTHASXnME0jbpcbOs+6zfVummZFkURQRJNq7i37Mt+3EEIdStBW3jh2O3vPzz7NxuV1tQcv5XKhj2GdzUizZJqxXogWaeqajLoJBAY+61YlM/WxtkfgIlO9rA+JY4Rk6Bp9dnahI5QfYuKn9wF5tBMnAo1zDQv+Ec22dtOZISGIpHd6eCsLcah7kRGOLPXtM+lKabbE4zV6yF3Yj7Be2wW6/LR754sGwvjVSQQrfEtyD8ho9vepB47VQC6Qy0YWX4mA85X48QJHC5nxKVJZ6Gnfv0m7XCSHTXf1FOHWnS6kWdq8kGYxekvXUUZtCLGrxP2sdhQNNNYDIk0todowdL6LeBt7VegMPssJFfQXacvYp8gzJF46Yx+1Oc/kr+EdTLuVrdvRTyql5FmQB+3krG4x7TL12tuQZ3xTnILs6DbqO4vPc1rYFEHju4RwZ7MeU1ky2WiS64V70hkYYL7c0Y1ndzxEhnIKrQ1AsTPTLrQrl/wczbrsHJ+4JVlFfQ3VCfT/0AA5aF8hVpgrcZHpdPLrv699hwYCMzlFe/hJieysm7zs/RfDFfz4/8lufJ3/VPl+pV0hhBNUmNRkBaOIK8hNMKS3c9kDrLX
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR10MB2932.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(6506007)(53546011)(83380400001)(5660300002)(66446008)(54906003)(316002)(2616005)(6916009)(186003)(91956017)(66556008)(36756003)(26005)(66476007)(64756008)(8676002)(71200400001)(86362001)(76116006)(15650500001)(2906002)(508600001)(4326008)(122000001)(44832011)(33656002)(6512007)(8936002)(38070700005)(38100700002)(6486002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H1ywAKLVracI5oy6bk1PKL+yl1eswCf8D5DkkpkBFFP5O87HOttNzWiU5iZu?=
 =?us-ascii?Q?2Q7uEnff6SmYKFftu/cx+8wQuk4S7Wk+FH//iMrfPTzey3TTh6ImZIwIykZ6?=
 =?us-ascii?Q?BAurv3sGFIucQzgUqrMx/FxtUIc0Zzkr/SRyFkScyLCPJm1/QXfnVdL3SCA8?=
 =?us-ascii?Q?KQQsrekkLdqb8AIvbTYI3xcbhE1ZTGuEAcuMIc7Kpa1ItXwgcPO/TfXYh046?=
 =?us-ascii?Q?OQs69edWLHbgEnUveycX5kLniU+7TZyXtoi0OpKBo+YqM3SR0gympPSz3FVk?=
 =?us-ascii?Q?sICysCc4zSL0Y3yoRbP8ixXAHXiknmNOzHH7tr8Aqvs9IVGAwblgmx7XqmMs?=
 =?us-ascii?Q?Tfs/MddnYGqB2izTK6G2F8RH5evEZBKtVQGykD6IP9HjsSPAdWUKv6/UXOyW?=
 =?us-ascii?Q?tJTlCweH7jB5ReSkFus9xjHXvGiaRzOEWyCQSu5v2uRU/dN8tPgnd84G3+Di?=
 =?us-ascii?Q?Bmc26RJkQeNMVcZTOUFySy9J+i1RAaR0qUIjEi+JIriogCIwHWSmOlxZ2Ofa?=
 =?us-ascii?Q?UGZ3MuTck8jzI6mCpSKowxZCs5BpP36dDQ0xAnd3IUf+QQzPFQW8LXZq2HKQ?=
 =?us-ascii?Q?RH4qNTh3oJDg2vWOxWohePIvuJQwcunTaVlrwjkPxmxLyayLddzCneE5XeeP?=
 =?us-ascii?Q?yb0sI3XPjs1scUDPpG65nB9vpVuc/ffkF+sm+hziqEpMqlrWx6nGMpOVTmM6?=
 =?us-ascii?Q?lm4XsI/BlPJs4YZkXQ2mOs7LBFNg6YCBzzZAO7h+HQ7LeI4jX1wD4U4Z7Akd?=
 =?us-ascii?Q?IzOKEcK8pLHK+8pld80nXM9YHPO5FcY9xqBCF/0V2gwjQzp0DYgG2XU7bpvP?=
 =?us-ascii?Q?rP8oJ/bPU4IT0KdSw6nX73GNTrSl+jsMn2tAq26XGUTXeRs0nVWwJZChcYbW?=
 =?us-ascii?Q?ZdoYYBbjaRyBVPJVnwil7QYWblUNIGX+4oANr792U6BjW9ODBwKMJERKMkwP?=
 =?us-ascii?Q?Oef0IBO7cLR/1k1KnVrJWI6fJDBT1wALRpj1HHa4etF9BybP+2VpTYWZCpg/?=
 =?us-ascii?Q?LLhsQ5LSlHknsR0UKWA0o80fRmzuwVmo8QWLpQc5hMVf15Ah78SttoRGjy5k?=
 =?us-ascii?Q?d4arDDpZz1zTEyp39ORjjrw/tcY8giK08tfvMxZyarK1D7ng2FsWIsuSAe+E?=
 =?us-ascii?Q?RW2dd9fVrOx65N0lv6VMzsehZlnp62eI4oWK30hW5Gsvwfv5o6GNktiQ3EbP?=
 =?us-ascii?Q?rgIPAIHxY+g6nchuqJ2OrNZVhrRcjcZ/pZE3sfYqP+5nrMkBX3NuQGS5nCkv?=
 =?us-ascii?Q?PMRo3oQEjNPYHw8tqWODbEywzasDCtNat4pU3A1+T44vmhRra0oxyrrEKgHc?=
 =?us-ascii?Q?G/7RH0peifWqybCLZq7adxooNer8RnXex5dWObImCRPKhQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5FAE1FDE17236245A38BE52E3D994C06@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR10MB2932.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62dac85a-39f0-40f4-c354-08d982203f93
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Sep 2021 01:35:26.5899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q1RHaefzYaJyUUgPfIQ9iYdREzlFsB6nMFh7Qal8zaQkVvA3PgwRMQXGQ6ycmzv/AtLJY0Pn9UkhO7T67saRvs7Faweqq9vEJhow5oLB6sg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2929
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10120 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0 mlxscore=0
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109280009
X-Proofpoint-ORIG-GUID: xcfDJsemc89yAg5kXscbJrxAKGvdN_l4
X-Proofpoint-GUID: xcfDJsemc89yAg5kXscbJrxAKGvdN_l4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 24, 2021, at 10:51 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Arun Easi <aeasi@marvell.com>
>=20
> Disable default logging of some IO path messages which can be
> turned back on by setting ql2xextended_error_logging.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index ece60267b971..b26f2699adb2 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2634,7 +2634,7 @@ static void qla24xx_nvme_iocb_entry(scsi_qla_host_t=
 *vha, struct req_que *req,
> 	}
>=20
> 	if (unlikely(logit))
> -		ql_log(ql_log_warn, fcport->vha, 0x5060,
> +		ql_log(ql_dbg_io, fcport->vha, 0x5060,
> 		   "NVME-%s ERR Handling - hdl=3D%x status(%x) tr_len:%x resid=3D%x  ox=
_id=3D%x\n",
> 		   sp->name, sp->handle, comp_status,
> 		   fd->transferred_length, le32_to_cpu(sts->residual_len),
> @@ -3491,7 +3491,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct r=
sp_que *rsp, void *pkt)
>=20
> out:
> 	if (logit)
> -		ql_log(ql_log_warn, fcport->vha, 0x3022,
> +		ql_log(ql_dbg_io, fcport->vha, 0x3022,
> 		       "FCP command status: 0x%x-0x%x (0x%x) nexus=3D%ld:%d:%llu portid=
=3D%02x%02x%02x oxid=3D0x%x cdb=3D%10phN len=3D0x%x rsp_info=3D0x%x resid=
=3D0x%x fw_resid=3D0x%x sp=3D%p cp=3D%p.\n",
> 		       comp_status, scsi_status, res, vha->host_no,
> 		       cp->device->id, cp->device->lun, fcport->d_id.b.domain,
> --=20
> 2.19.0.rc0

Looks Good. Indeed a much needed fix.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

