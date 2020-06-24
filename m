Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72698C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 17:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D5B0207DD
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 17:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="dH9Bo6uL";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="AKFUlKog"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405951AbgFXR7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 13:59:24 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59798 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405950AbgFXR7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jun 2020 13:59:17 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05OHekFp025237;
        Wed, 24 Jun 2020 10:59:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfpt0818;
 bh=iEK6/rNyy90m0buZ5I2sYE7lGv7iZJAfTxM3aj4hKaU=;
 b=dH9Bo6uLzuJ+vh8npC2MHKd1LZWO/WYlOohWsvZWwVQaaYFg/vZLGBV6XhjnzSq5mNtV
 +ozEV4bdvbxf5SGCPzk9jvCImJxmR9i6oSt9YXLVJz2kM6reb7hRVwleminJiM8uc1e8
 96edUnTQ/OIAZE+GgB9cmAHJbPoYbRX5r12LlpbcuH7Fxd5to1X93vVgwRO6dDLolMrR
 roslAYd7lwQZbRRxxmbO+QFcMPkz9uExORt/sAMzIcvd/pG9S5ltspo2ut7+Ef8yipMG
 tA2FtRosBaAZBoD76Lw0Mv+uY62ePaEq6qSzQvjpUMGwrELxo2jm/KVYdZb0r94XXbWC HA== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqgv53c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 24 Jun 2020 10:59:08 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 24 Jun
 2020 10:59:08 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 24 Jun 2020 10:59:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M+e6yACydzqLxuC7bI/40ukzY4kJ0l6GLo8Hx1TeyB4Jhq1uVr2g115zxiovNXZEbKElhLXOYuwNeno0Oo+BD0x6bzb3IaW5ynZZ+znzR7I6Npq/iB2YtV+HpWmoqOf4uaD0G2YZcWtXz7vEKpPpAmRJswbNrqlfo276qMSh2OBnCmqlfD0yuEd9otQvURfUPRq62EQkmtPWks8rVv4O3/Xj+xviNTU9h59tOV9dTo5SDJnXGihRTWKfh3xc5lzzdKlW7ibSEseBgBPCINx9zyj4PNTkn7QItlEmRWtKlzgOhwUNQ0hiuECQhR0b0a8dpSWPzhWW7wpXuuxbgtpAww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEK6/rNyy90m0buZ5I2sYE7lGv7iZJAfTxM3aj4hKaU=;
 b=Bm3idwtuMkg9p4Uu4Au9aVwOV741PuLfmPH5ZTWJ8AjomVa8GxAZzXLN0fZ8mUxdYrzMvSjOvcYwUaeTte8TUdBjjorUlxEbQnLZn5tqjrzI40OHf9nEgVjJKaW9rTp8/mRjERmgiv+wyuewfz3EMx34E6piW+PdYXpdO01mJICttbx8jDyjvjuHxoiZ1epxoTvr4jOmFVmOCMSfMcpYUhKQtDGAOghwc9YIVB3tIkOeeSbxDnHVhpxx6Lc41ROZ/5jUwv8FtDkQbhGWTcG7iWw7dOv6xeQyyv9Rq29AZUmNWvOaOlesTKBh3QIncC1a21RKVtXEC/ffos8j1C1vYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iEK6/rNyy90m0buZ5I2sYE7lGv7iZJAfTxM3aj4hKaU=;
 b=AKFUlKogNZKILSJ0We/s5W3BmKgjbKDiSElc73WJmq/f7AZZUoIcg1YlYWZ9H+C47yZrFQD8qxgqlr60gGtDTw1AFVxnvvPiRBIM3YtU4BoQk4ZRYGRZN6c6PzFEUN9sKzyJVlnGI1xp96MPwk6M5k7I5wBjJL0QFHEU2Z7/KZI=
Received: from BYAPR18MB2805.namprd18.prod.outlook.com (2603:10b6:a03:108::25)
 by BYAPR18MB2456.namprd18.prod.outlook.com (2603:10b6:a03:130::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 17:59:06 +0000
Received: from BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b]) by BYAPR18MB2805.namprd18.prod.outlook.com
 ([fe80::fd09:61da:c548:e61b%7]) with mapi id 15.20.3109.027; Wed, 24 Jun 2020
 17:59:06 +0000
From:   Shyam Sundar <ssundar@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     Nilesh Javali <njavali@marvell.com>,
        Darren Trapp <darren.trapp@cavium.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: Fix a condition in
 qla2x00_find_all_fabric_devs()
Thread-Topic: [PATCH] scsi: qla2xxx: Fix a condition in
 qla2x00_find_all_fabric_devs()
Thread-Index: AQHWRkaMHB4BJYzZ+Uqb7cERHdz0M6joFb+A
Date:   Wed, 24 Jun 2020 17:59:06 +0000
Message-ID: <06779DEF-C420-40F9-B675-99BB6CCE86BB@marvell.com>
References: <20200619143041.GD267142@mwanda>
In-Reply-To: <20200619143041.GD267142@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2600:1700:6a70:9c50:4159:d419:ec3a:b950]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c6982e7-0336-4a01-2e34-08d81868499f
x-ms-traffictypediagnostic: BYAPR18MB2456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR18MB2456C6BE61DCFEF154EF55FBB4950@BYAPR18MB2456.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +s0MRZgwHkDMeqJFo0NaWgP5xJlBs+Cs0VVHVr1oa+aA8vYL/IJ+2r2HDN7kdurFhpqoJppt2unrk76ucQxPemnxtdcEeb3kTFYsDT4IPQTvnU20zelTPGj5hsfhxEQ5Oh08tPlM/+CepFtaULvOiBGHmVLjicYhJORhNUuBBzs1nXMrYx+d5ZiDMj4ATXcKrJMDWkEnKo3ARlD9NQPSWBL5Ve0Y4HlxZTfzV2qmKQBTJy3TZbj5yT5eu6K7KRjq8QvyzeKreGYNI1d+bmWkP2Y01DFMH0t9FvyVjFswrCcGBHen3fyS34NJSi59KGpieRNG97gMpYwCR6uJbIHlQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2805.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(2616005)(8936002)(6486002)(5660300002)(54906003)(2906002)(66946007)(83380400001)(66476007)(64756008)(66556008)(8676002)(6512007)(36756003)(4326008)(478600001)(33656002)(186003)(86362001)(76116006)(71200400001)(53546011)(6506007)(316002)(66446008)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 32vf1vme1UBO7IQrt+h7D2wd/ShqosRE2q5IO2gXs0lvvvHQvdiunn6avebn3c2uG+kY+aftYfoUqDXH1OeBdCZhjENCW18fzFy1jC7Hzt8wnoYbgOP8xEbFpbu3QbQsKmpD2+ERTdPSB4X+I7PO+F5mu1JJuwN9dd+Fpm0M1hY4iNSWWl6QrEPbEf6rHcV5i5W5zL4VFjuR7kOgj+ox+wYGU+GCQri0WlSF+ZTiudm5JMJcgDZGw1DZXJUXsNbTRq8YccAxwDTV7bJgnAOuc4lBOBcaNnmkxP5T1is9ogIDUBOgH09k7xDIyrTy6i+7MJEWRf2PKYawcuxNdO3bqxyAGn9jtGrpTN+2wrJJ1oCoAxthuujkgcU7foxC/FcjreZGzGk/nHlji8Fz9TWm9vhYOuEYcTSmLO/5NcjcaRFQjx98FDFcVrXlbVcQHKixmiKmOOs+nvdMXBxaMrWwdmhpLro5MTPXOxqwN+dFvXV7xozMwMmA7CnK/Vixs9Xg3hvYmyvGD6O9RCWCfOII3GlQZhC0ZhE2iKw8oJR/L9tGTfXpoD+fjJw98n9iJVFb
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A77CFBDB06F0B9429A68780DCB83BE0D@namprd18.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c6982e7-0336-4a01-2e34-08d81868499f
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 17:59:06.2410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XTIU6PXmwc6qKRLo2svjdHf0VKNVr1xUxNb6RxOrMi1lHU0zrsFmrUkh4xU2rkuMJh3+l8Fbzg4zN72Posha1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2456
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-24_14:2020-06-24,2020-06-24 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+1.

Reviewed-by: Shyam Sundar <ssundar@marvell.com>

> On Jun 19, 2020, at 7:30 AM, Dan Carpenter <dan.carpenter@oracle.com> wro=
te:
>=20
> This code doesn't make sense unless the correct "fcport" was found.
>=20
> Fixes: 9dd9686b1419 ("scsi: qla2xxx: Add changes for devloss timeout in d=
river")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is from static analysis and review.  I'm not super familiar with
> the code and I can't test it.  Please review it extra carefully.
>=20
> drivers/scsi/qla2xxx/qla_init.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 4576d3ae9937..2436a17f5cd9 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5944,7 +5944,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
> 			break;
> 		}
>=20
> -		if (NVME_TARGET(vha->hw, fcport)) {
> +		if (found && NVME_TARGET(vha->hw, fcport)) {
> 			if (fcport->disc_state =3D=3D DSC_DELETE_PEND) {
> 				qla2x00_set_fcport_disc_state(fcport, DSC_GNL);
> 				vha->fcport_count--;
> --=20
> 2.27.0
>=20

