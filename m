Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59501C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 17:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3128F206EB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 17:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="RPe1PIHh";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="Vc7zs8Jl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733197AbgFWRZg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 13:25:36 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1733173AbgFWRZf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jun 2020 13:25:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05NHHcEk018464;
        Tue, 23 Jun 2020 10:25:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=4xPhW022hLw6FvuQQuea6sVNE5vPTA+XnpXuwgnE1tg=;
 b=RPe1PIHhUiH/+/Dzg8DHw13gXzy2R55yiVjcuYRlrRmv8DXjlWauzIDl7RxBwaBTG2hl
 IpLL/xfYmtCCBjAyklQo50uui+Vv2sp+g2UbSSbR8qsgBAsu4LWNnbI2AJ+OB06m7Jkb
 RSBCiQUVq3oGdcVQEkgjdiM98LfQFnFt81xFdyzMYmTS1qB6YPiYFnTuWAZ8P8bC4tgo
 8ROI+KLlMlafq5mjjIKJfJyiMezrtJSeU2MXYMKwLIzE/yTJxlDH+PhBikjqkt6wCS0I
 OrL2NJh3eSFW/xXTVRg8JOx0PIcku2cceo3UznskJSSE+imBOH7l/qDUf3Am0Ynlx654 qA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uk24h03q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 23 Jun 2020 10:25:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 10:25:25 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 23 Jun
 2020 10:25:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 23 Jun 2020 10:25:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hku9s/TJO4i17v3tLPDdUq61FDLjtNIEhPqfMAZyQjf/vsHqZ4m8stYrDFmgI1LekPnka5Mg4y6FGaO9XxEv6fuhGU1dc4f1t2NIposCH+RB72wlTyOySl0MvUb5iJDYRttoDQNiXaU8iwrqWLgOlHuBxai79exT5AgrfNrP+B35lEjhTaMyX4vpIMEDG9pilRYi+LxLOZwzBpanv4gFh5mGvoDpvbFTuQAZsxi/f85pXPq1eoppzQF5tGB8bjduYH8z3YSV6EluNPBMQoigi4kONzj6u0TTbmonxAbUemO0hUkTwidTejx15pMoO68g6pvTskotNkdB9CSghQASyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xPhW022hLw6FvuQQuea6sVNE5vPTA+XnpXuwgnE1tg=;
 b=Qiza39lg2fbjp9FP59zkujy1nn3dqYwOWKbj587DscwZF9Omk8/Pj9IYQo+KrIyKm0jklBHflwQmlb9FYTmnwzcDLhQT2oSmUmTwK0pdD067fnXdpwq+jOLSsfmypuP9I1mwE2SdORPLcimiWeISRS5cwlvj7Ww4is+rRfqNbYYU4OR9Za9odIyLpHG6LtYLa1tlkSwek2QPfmNTQmjGxK3sfp4LTj6RJUpyxM5jF8hKaQaFMMb2X0fM5YMbQsDbCxB7Fq8Ky/IJOia8p6OPGyh3J4A42zzpQfuMlRrNCk+bwtryzcMtjCBL7tZBaX6AuSlngeRwH/Iyql/AEdUGdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4xPhW022hLw6FvuQQuea6sVNE5vPTA+XnpXuwgnE1tg=;
 b=Vc7zs8JlVXYAgjN/ZTRKU5Qqj5kUv3/Y2PRxAg3tTdnZGvXxtjY0fmqHRRocI2LQr0FCXHhDdBfmbUp81JnQY3fPXto9fsSA8UhpaPeUXWA5RHzw3m9ih3wvMDFS3A8wI7suv6kx8jnCH6twcJDdDh0lI9ftYG+bbn/BebzHyo0=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BY5PR18MB3172.namprd18.prod.outlook.com (2603:10b6:a03:1aa::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Tue, 23 Jun
 2020 17:25:23 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 17:25:23 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Daniel Wagner" <dwagner@suse.de>, Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH 4/9] qla2xxx: Initialize 'n' before using it
Thread-Topic: [PATCH 4/9] qla2xxx: Initialize 'n' before using it
Thread-Index: AQHWQpyxcvGsVoXvDEmTNeeYyoZC76jmgVIA
Date:   Tue, 23 Jun 2020 17:25:23 +0000
Message-ID: <BB957BA2-6D2C-4233-9EAF-34549463E79F@marvell.com>
References: <20200614223921.5851-1-bvanassche@acm.org>
 <20200614223921.5851-5-bvanassche@acm.org>
In-Reply-To: <20200614223921.5851-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:d453:77be:a8:43ec]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 372fe39d-1179-4e8f-4c05-08d8179a6982
x-ms-traffictypediagnostic: BY5PR18MB3172:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB31729312EEF03B346E4DF227B4940@BY5PR18MB3172.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 04433051BF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5oJPJJBsQGHybWG8YoNq5wq/1k+UQClVUTAB6GYuX8914FGpy+pFSAS7DdDFkI+UenrdqRK9roxWrQLZCGYemL7hhIXodq0WLlbdh7bXHs/pPrHwG4FYP7le81Rn3JOny/OUuWZrNAbrSuX3orMRPuv11j4vbsFns/gYlGX7hwa6n1ucGvaNn4rXxWua4tsekB6GnarjLVDHNp34RaMrLNsrSRX1wqM+iGOvTCkuH2IF7tmhQwcZHpz2HpQjQcrgRXpAoufnCLSr/ogjUqOYxC1a60htOZ+SGrxD30/0NnMLcJJQOn+MNM8iOdA84tTqcEBzv9NTGunB8dwW1FxZvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(396003)(366004)(39850400004)(5660300002)(86362001)(76116006)(8676002)(66946007)(8936002)(6512007)(186003)(6916009)(83380400001)(2616005)(66556008)(64756008)(66476007)(316002)(66446008)(71200400001)(33656002)(6486002)(54906003)(4326008)(36756003)(6506007)(53546011)(2906002)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: fVksgN3aF5Pwz9NQVVnH+przNre4s6M9s4TrROOIubqbiqumZVEREChg4b02/xaCnSAtqaLpJMIXlQBPWEk69+09/0v59Etn0AJTZszDsBDZNiudRE9YFOfg242JIP2pGsXYF8E16Iq1qRe8/FxN077JpcrOi7n24U+SM4OzNyZFFqzCggT2RCd1sUhCuBJ8GFFCbIOoQxfg7gJKx+zstQGxmbHiBcGgQwYQS8TjWp8pk9A9ISnCGuBZwNxJra4MfUWwmb1v5gYsMo1ptONRJxCe5NNIJPMsiJF9ICWPUZsUjKpTDEcHdmFonki74RYW2YxZPEUhNuUibUfhOPUr3MueMaVGU6syzV7sWUiXak4jxEjSo2ymL5jlzwfpoGnTPVT03KqS+V0BQVwGtEFX3903CwYQ+XpRGdHtqShok2iL9+4Y8XnGcRVvQtkVIT7P7oZaFBi5IX3+RwzUa5kFgKCC0TZMsVoHzgqtFXSCq9cnXDWbFAT/b/Q42RN+5B8mxsyv+qTd6lsv6iuiarNbjsYi1cD+3S6yAJV6HErJoYI=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <449E52D3FA208C46A9C1C7C385891558@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2805.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 372fe39d-1179-4e8f-4c05-08d8179a6982
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2020 17:25:23.4105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u80snSCtJ/K3wq6vOF11mdCUkBCCRmHlPWXxORcQyzB0OnwKa+cv0ldkU89YzUtXzQAkgRR9jLZ6pHe9DdDcgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3172
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-23_11:2020-06-23,2020-06-23 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good.=20

Reviewed-by: Shyam Sundar <ssundar@marvell.com>

> On Jun 14, 2020, at 3:39 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> The following code:
> 	qla82xx_rom_fast_read(ha, 0, &n)
> only initializes 'n' if it succeeds. Since 'n' may be reported in a debug
> message even if no ROM reads succeeded, initialize 'n' to zero.
>=20
> This patch fixes the following sparse warning:
>=20
> qla_nx.c:1218: qla82xx_pinit_from_rom() error: uninitialized symbol 'n'.
>=20
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_nx.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.=
c
> index ff365b434a02..71273eb634d3 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -1167,6 +1167,7 @@ qla82xx_pinit_from_rom(scsi_qla_host_t *vha)
> 	 * Offset 4: Offset and number of addr/value pairs
> 	 * that present in CRB initialize sequence
> 	 */
> +	n =3D 0;
> 	if (qla82xx_rom_fast_read(ha, 0, &n) !=3D 0 || n !=3D 0xcafecafeUL ||
> 	    qla82xx_rom_fast_read(ha, 4, &n) !=3D 0) {
> 		ql_log(ql_log_fatal, vha, 0x006e,

