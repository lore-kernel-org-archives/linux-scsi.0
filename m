Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DB8C4727C
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BABF20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 11:04:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="V/ipliUC";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="RorWfT/T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731930AbgJALEw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 07:04:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16916 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731548AbgJALEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 07:04:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 091AtNEE026215;
        Thu, 1 Oct 2020 04:04:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=zHRAVeec5+xZ8usVzLndG0PEHsq8l9SnwzkWWeEBKPc=;
 b=V/ipliUCdp3BtUgpG+XKwO7T0sRNKA1LgHzHdkKquAx6JX/N3Q4tfM9nv9pjY6BIx9Um
 Z3qAM8jNRZDisVJ43XdXFT6oIO4elfHf216wAfC6CvdBgfIhXAoNjVZ7Qh3xh2vbA+oj
 SyisyYYb8V8D/UBy8QmfQNpqd9UJB3i/NLTz75+pEZjtDLFnLTCcaDj+qmLVU3TPMJyy
 /epPM3MSwanQzHNSy3Z5tb91H/yY7xNcRf6BPmIjudhoXdfb8dIcnJAPf4M5YUAu2Ngn
 nrYG1k4SbdHbf3+IqV0+6vYJAR9luj+JwgCJMNODSIf6RCJC9dQuB+dBI6sE7uKOnANB hg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 33t55pe4hu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 01 Oct 2020 04:04:41 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Oct
 2020 04:04:40 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 1 Oct
 2020 04:04:39 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.53) by
 SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 1 Oct 2020 04:04:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y6wRUVHcyfURNOxkHkV/534FTF/xDI/3YanhcMJ4OcF+jEmjn5klUeZARmfIvyra2Y0FSn3P5YjTTX08W8ISCFOYSx1m0FzbnnZRkPDbYtOHRqUhuNCmQVkQyewFiNlKoWTmBuRYi1koVI+v7ij+Dt1SBfFbi7Bdix88wiR2WmYKnjwRIIzYUb7PTXGYpwNBlKM2Iyyrzeu7MGwWqzFlqi3VaRci+M5qd1qy5VuDwFdUxo+cSJg4qITAq+cQ0eqFSv8S4fkwyZ0oIFGxvW87lligGyJb+V0Qhx7vYcw09WB9TlTr48rOqr0dS3vK+Vp2eoak2vWOLEisp78RqKT+gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHRAVeec5+xZ8usVzLndG0PEHsq8l9SnwzkWWeEBKPc=;
 b=I/ujRH4MhhHv17MHA260dQvp3UZWAegVfqgqpq/m2/kDCpPWLoPNU3O2g3jM3w2pFzJ1hqBz75ww1q8MGvo8t4kpMUBbHXFgSLQEY/JZKM1Q94l0rIIDBJIQS7TiuZgvAWBvwqnupdW1pcOTWWbakbpVD2FDR6DRylCUlgR4jBf+uSDVl92oyyId4WNftBWI26CT+hnQ1dfyN6bUhur7UmDnqzFsz3kDrcFvuSUkIyyBp8ZzdYpQl3Pd+PUGqpsX0+g64mwcvHZw7PPv025p0vqqw/Rd+U69SyV148cfNTcSWS07sutj6xcoB+bOGvD2GKy5xiW9zCt1VnQHqeGyhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zHRAVeec5+xZ8usVzLndG0PEHsq8l9SnwzkWWeEBKPc=;
 b=RorWfT/TP88LLVMlr59x3OO8ivvaap+5AN5C0014oSMJPtXsPrYJy1bZ7xyE3Qjy46G/1snQfy8DZJhqcEc7Iw/kqYZi9KyKQAPkwQsVgO6Nt+eoKjAyefh0bm2mjCDU+g5N6EJqDYsmCfSV+sDYEqYq3098hRyvzPFonxw6KpU=
Received: from DM6PR18MB3052.namprd18.prod.outlook.com (2603:10b6:5:167::19)
 by DM5PR18MB1017.namprd18.prod.outlook.com (2603:10b6:3:32::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.24; Thu, 1 Oct
 2020 11:04:37 +0000
Received: from DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::e9ec:af5d:dfbe:2099]) by DM6PR18MB3052.namprd18.prod.outlook.com
 ([fe80::e9ec:af5d:dfbe:2099%7]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 11:04:37 +0000
From:   Nilesh Javali <njavali@marvell.com>
To:     Ye Bin <yebin10@huawei.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
CC:     Hulk Robot <hulkci@huawei.com>
Subject: RE: [PATCH 2/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in qla_os.c
Thread-Topic: [PATCH 2/3] scsi: qla2xxx: Fix inconsistent of format with
 argument type in qla_os.c
Thread-Index: AQHWltDWc7m8B+RM9UWzSMpJPFxZtamCl3jw
Date:   Thu, 1 Oct 2020 11:04:37 +0000
Message-ID: <DM6PR18MB30527194D799747C1C4D1737AF300@DM6PR18MB3052.namprd18.prod.outlook.com>
References: <20200930022515.2862532-1-yebin10@huawei.com>
 <20200930022515.2862532-3-yebin10@huawei.com>
In-Reply-To: <20200930022515.2862532-3-yebin10@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [59.90.37.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 109f8fd8-511a-403a-f096-08d865f9c9c6
x-ms-traffictypediagnostic: DM5PR18MB1017:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB1017A2A8410D9A9C3CF1A51DAF300@DM5PR18MB1017.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:16;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x/jSG+PASKunDkzWD0Le7xw678rwEXP9klwSkajs0VS9wPkH+lapbdxOkECpeng8abG5QX+rlWSI6bjbDp7BfeAPg9G+K74b6GDNaCQB9ggRuBEAV9Tm+C2PAIC3t+UORTLDjYV8LIe0FXppHoSzNVYshvFtn9G3fB2/K5w9C/lM3cp9iWTGR4fuvr5em5Uf24wTBn4Hpr7GGohtnIeXV5MkEo+WcAJJCF3mly/6DuRNpLi8UJlc8Lc0mCGanQDZuqPQCR3PbbDgu5vWHP+UyX1OiuiJfBaZRTMneZFvewtbG3+vdLnbSioeVp+LFzRkEjB2IK2SF3a9pBqjZeClSubei7PLj7rxFKvzxf/kfGXTlKQe2VlI2tBEoIDmOGap
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB3052.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(110136005)(316002)(71200400001)(66476007)(66556008)(64756008)(66446008)(52536014)(66946007)(55016002)(4326008)(83380400001)(9686003)(2906002)(33656002)(76116006)(26005)(7696005)(5660300002)(186003)(53546011)(8936002)(6506007)(8676002)(478600001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: V/7qescsNtrca5WcvNPp9Jecw6OxnW0adXNSZ9oP5hqyE7juSFMnxw4l5V7tIi/U92POov4XFk6joH6RGj8NsFmEUp0aGJzrklbhFr4Fok9FbM0MDhl+s1fot4aP2XxPWIVxtvXIPaTq1m/RxTaQEh+eAKCFSqg0WS4blc4EN3tnV2MRf3sxBnpXRlozdny1RP3YNGYZnRA3HZbi/ZwyWaiEb4FuXAzN+rW1p/Oq9kkgZHiMpT/a5tco6Mw05ghVArvxD0i3ootKmJNSvGSxPpEvgNC1RYLosuAvXNhHsRQOmwOZGoP8VDM6NHivKR7genKfkt6xL2pEucox188NwDCuYP49TGx2tt0N9Xwr1DMofqFfHKB7D5jEUcT/sPSytmhOHh+sqN2znCcYnaGfi84gBp1kW9PTvwDSv8I2lXee0oeJpeQdmO+HJw3nGx+FJhwcFMhMNbbsWR/TJcpGqFXA8VWjX7fG8yunYOSA9fygShFEJNSwYCUAOmRdC0PSfTLcdwfC44S1JRGa5mSF8txgUIlghJTFESW2srIrLFIobXpzxCTXCS09o694a6D9NfjXE1yoGNPN2HEzRJgd733azHNn1C2BIi0YkAqEOcaXEOhBxflGLfpdtZBvXXy/65NfGPgeiV3rfRcDWwO0sw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR18MB3052.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 109f8fd8-511a-403a-f096-08d865f9c9c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2020 11:04:37.7576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mAIJ+2pIi6rWMfacvdzVsF0IvoUwRmLqsq+ASFoOuBjbTc5vpSvHFsOZ3IpSqjRRbbjRfUlFy/tbH62qw3ljPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1017
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_03:2020-10-01,2020-10-01 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Ye Bin <yebin10@huawei.com>
> Sent: Wednesday, September 30, 2020 7:55 AM
> To: Nilesh Javali <njavali@marvell.com>; GR-QLogic-Storage-Upstream <GR-
> QLogic-Storage-Upstream@marvell.com>; linux-scsi@vger.kernel.org
> Cc: Ye Bin <yebin10@huawei.com>; Hulk Robot <hulkci@huawei.com>
> Subject: [PATCH 2/3] scsi: qla2xxx: Fix inconsistent of format with argum=
ent
> type in qla_os.c
>=20
> Fix follow warning:
> [drivers/scsi/qla2xxx/qla_os.c:4882]: (warning) %ld in format string (no.=
 2)
> 	requires 'long' but the argument type is 'unsigned long'.
> [drivers/scsi/qla2xxx/qla_os.c:5011]: (warning) %ld in format string (no.=
 1)
> 	requires 'long' but the argument type is 'unsigned long'.
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 910a6ed0ccc7..473a02603697 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -4879,7 +4879,7 @@ struct scsi_qla_host *qla2x00_create_host(struct
> scsi_host_template *sht,
>  	}
>  	INIT_DELAYED_WORK(&vha->scan.scan_work, qla_scan_work_fn);
>=20
> -	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha-
> >host_no);
> +	sprintf(vha->host_str, "%s_%lu", QLA2XXX_DRIVER_NAME, vha-
> >host_no);
>  	ql_dbg(ql_dbg_init, vha, 0x0041,
>  	    "Allocated the host=3D%p hw=3D%p vha=3D%p dev_name=3D%s",
>  	    vha->host, vha->hw, vha,
> @@ -5008,7 +5008,7 @@ qla2x00_uevent_emit(struct scsi_qla_host *vha,
> u32 code)
>=20
>  	switch (code) {
>  	case QLA_UEVENT_CODE_FW_DUMP:
> -		snprintf(event_string, sizeof(event_string), "FW_DUMP=3D%ld",
> +		snprintf(event_string, sizeof(event_string), "FW_DUMP=3D%lu",
>  		    vha->host_no);
>  		break;
>  	default:
> --
> 2.25.4

Reviewed-by: Nilesh Javali <njavali@marvell.com>
