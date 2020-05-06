Return-Path: <SRS0=GN0H=6U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C868C4725C
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 04:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E2F2206F9
	for <linux-scsi@archiver.kernel.org>; Wed,  6 May 2020 04:45:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="hOBtEUPa";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="GkOYxoHL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgEFEne (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 May 2020 00:43:34 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:50960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725892AbgEFEne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 May 2020 00:43:34 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0464eN7T001370;
        Tue, 5 May 2020 21:43:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=rj914uEQX03mXDW0Pzv9DuxXQlx+GLwJyYv8Gkj9dhI=;
 b=hOBtEUPazr9lV1wYg92suoSSTbKDr13APWl+LDktjRc2tJyuNgngzJkWyfl2QM1o47wv
 zf8GjmDNMaBmjhTnbiXk6mCHDFy9bgFc/Dve/OuQ3XZbrpsFdUU/navsDs8u6k0rnEZt
 7MqAnobb58smBn53sdQBojyEOtH4m9iKpm7PyHkAOzZX4esDq6jCC/xUwPBcBT5RzvGv
 ZndvzJySpRYku5okkDWsH4dWm3G4vK7UG7rGH575YfqVQ5juHMo+taWFrdXvyrL4bEP6
 45R1lNa/lNxCJYN/3R5llRaWHgVrQoDEAwqzuj6GCQUQ4fv9/DcHYn9fP2WZRWTMNoN4 +g== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 30uaukub7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 May 2020 21:43:28 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 May
 2020 21:43:27 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 5 May
 2020 21:43:27 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.53) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 5 May 2020 21:43:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQHAgDLFTWrZ+hfikQPv869fZBBhC5NtIxqRErjntsCYt6aE8DMdtA/sGiY6X3QcmQGXbSOJuckg5XXJhfK5tEWArEcdHne7Fc23pMvKJ4OsrZMD8B835ge5fTSKMCp6k7bf+ZHF4o2YnXY21CPAj+GS0Zr1j33zQZqlwDO/bQnpi3RUkuA7gvib98o7cg2OQ9CrXWduoWe2dBuzPJZzlglIM20vRxcVS7uYiCKn8xEegpXynQkOGDuf43w0f0uR/fHJQrs56/T29dUhuaBMB6avpA2lENfR+aBtnkZ7u8mqqQIoguWNoPf8zeTSTDyYnYLkqZ6jmxzKFkladRw/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rj914uEQX03mXDW0Pzv9DuxXQlx+GLwJyYv8Gkj9dhI=;
 b=UqaxBAgxmalvrwZU+Z4AFQsf9atHhTn7vSnJ9nvhAdPC7OXi3b2brTPkdKmVk4qJNQBkuRs59n+bY1JExynxizNttwGPO95N6UsiAnvCxjDS7CzzJEFzmaBWGHRTfUAuaX+5/Yku94++PzCyrg+Uls+R4S3BaUxNfPaKzrrAmWVR7/RzG3EA47aM8Fu+2g6i+I0bgi8+ayUPCJJqmsmQ07uK7BnFnNK/rUp04pRkms6nL6GCIefro6XGY4W1qcEiy5r3qKxxf9lzCQuVYNomzYxA5GysrnsSuomUYiZ6A6cBUaFbG0kJ9oFJUgwPiZRhz15OdUN8ON1II0aQXSly2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rj914uEQX03mXDW0Pzv9DuxXQlx+GLwJyYv8Gkj9dhI=;
 b=GkOYxoHLrmx0q9ZqNEkbRxD++xNEnlLidKLFDWUf2BO1KdgAxF/rHlOPFVWJepE3EnZ8ilH/7KPC3xsCg67QQdWfVV2fNhdCvgD7kZ+0xUUI+1PhNeru9in8wGpy3nANw7yTTcRgvcXvSe+w95LwOSNgjkLCBgWW1vIJPinPLRs=
Received: from BYAPR18MB2998.namprd18.prod.outlook.com (2603:10b6:a03:136::14)
 by BYAPR18MB2838.namprd18.prod.outlook.com (2603:10b6:a03:10a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.27; Wed, 6 May
 2020 04:43:25 +0000
Received: from BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::19cb:e318:d173:1221]) by BYAPR18MB2998.namprd18.prod.outlook.com
 ([fe80::19cb:e318:d173:1221%5]) with mapi id 15.20.2958.032; Wed, 6 May 2020
 04:43:25 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Jason Yan <yanaijie@huawei.com>,
        "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] scsi: qedi: remove Comparison of 0/1 to bool
 variable
Thread-Topic: [EXT] [PATCH] scsi: qedi: remove Comparison of 0/1 to bool
 variable
Thread-Index: AQHWHuli2Q3Dl6FLG06MBAsIf0Kgdqiag5sw
Date:   Wed, 6 May 2020 04:43:25 +0000
Message-ID: <BYAPR18MB299824A60D731DD4BFB8F840D8A40@BYAPR18MB2998.namprd18.prod.outlook.com>
References: <20200430121706.14879-1-yanaijie@huawei.com>
In-Reply-To: <20200430121706.14879-1-yanaijie@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [116.75.137.12]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fc87cbe-9472-432c-8837-08d7f17803c4
x-ms-traffictypediagnostic: BYAPR18MB2838:
x-microsoft-antispam-prvs: <BYAPR18MB283852F932B8ABC169422480D8A40@BYAPR18MB2838.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 03950F25EC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b+hV3yHe/Fb/9ERJA6sPoBqWTb7VsIZmWq+f1v9+uaOuPMy7JDCdmZQkEgq5W9k+fbKdivn1Ig+kDqzlPWZgMDnLz6zMatPAFymRRTC3pyKhofKv9g/njEmHMzGs2om4vTsmQMtyCh9txSskE2Cfvk6jrDx6Utudh3vpcQJANGdBG1rjg5RARfou4pWkr4ER5qrN5AAJo4i0jhMuTWlHgDqyV91srBNA+NscbRQsBo7bT5i1fxuNBVqMNYt54Tm0wL58QIHo8MR+9EFHJU78rgiVY2ner/xMW3ryG6Sp46zYUNrVUTa09xGNuoLmbP+0tw8VBWMWDtrtZplTY0lm3RDwnBl4sd3HL1UJKMZ93sw1whi4VIOGmEQegtrSyGeh4wMSwjfh5ZIQaKcb7q1lQwZxH/sWonEPQxKD4jJxZLOVRP/7atENAC9dkcIEzDBvPj9o75JS0w5VqDQ5Q+QUOrxYP9TOGoZfIEBtzraeJbdThBZuErLidbYx8LqEqgYSgZw5N3/ukSTc61EHRBTR8A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2998.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(33430700001)(33656002)(71200400001)(55236004)(186003)(6506007)(66556008)(8936002)(66946007)(7696005)(53546011)(66446008)(64756008)(76116006)(66476007)(26005)(5660300002)(110136005)(2906002)(52536014)(9686003)(55016002)(316002)(8676002)(86362001)(33440700001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3BlVgOE4EmommDn6RcgB8vOSYq3HxxB6On7sVA3YBE0dmLn94RTe1nVrS/uX1MflqAvRr2hUfpIWfvpGMKioIa4Y9XzAoOHW5VjMZ85hRz1IsOkk02kF7W1R8d7JiwmrENnGzITS4gujX5VgsacAOVgTXj9UP7BMGQ9mVhVq90tP9u6IZc3aL9SE+mE+tsr72umJhCrO9IGZDMmpThdUefsuk8fE3OChuA7jtz+GYVH5AhK2qBUJnA8vanueZ2Y/U4BaHgrpA4I4s3lsjLlW/N7vInFudc5zRndSej3D6cmJjL1wZA69ejvs75wIOxAOU/7kxrnXFa6dPE+2wFWM3/Z5wUAoH3agP7QqNw8Hl+4pr3OX4XYbZRjxYWLHNKYg8c6QJjGnrJxDfTEWwDYYhE2A6NiqziogQqC2OaYs7n9KvmcCwxdDzO98PuXwGzsP+Yr8EUOR9+auRrg6MN4VFzzxUS3saXW0ejq0Cj216gbvRqdRPZKzLveT0mk+HzclLR9tL6Gc/7ekJn3Yfcl5htLiN38NIU6/g7aPwwHt+GdkhMOrsmtsQNFAIv89w619FtdOnXAaSo/QtTRzGuMyN7KKxBET6XxmWcPkIOdx34ZwAaf8dGDz2MiWmYmGoO0QhqoBq8Pfxp56lXeJDDuGmxDGeV5YLlcBUt3G/W+YAkNhhsxpg2J/4OxHGKhNNIBotN3t1tndL79yJn1YCCZAm/ECHc+n6DVBedZ+5/Wh2k5BF4Q8YJqB0TwPuIq/yrGum9Uks2AFYAn8QwpA6Ag4lZ2swhOWccHKAIXThmiSWEI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc87cbe-9472-432c-8837-08d7f17803c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2020 04:43:25.6726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wui1Yp9ABWl+8Gos4B/1GoeJr828RRWXfcbU+E0w1avhXVnEoTb8b6qF+HRxXMlvCA9TDtpheFUzPDJCo/C1VA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2838
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-05-06_01:2020-05-04,2020-05-06 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -----Original Message-----
> From: Jason Yan <yanaijie@huawei.com>
> Sent: Thursday, April 30, 2020 5:47 PM
> To: QLogic-Storage-Upstream@cavium.com; jejb@linux.ibm.com;
> martin.petersen@oracle.com; Manish Rangankar
> <mrangankar@marvell.com>; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Jason Yan <yanaijie@huawei.com>
> Subject: [EXT] [PATCH] scsi: qedi: remove Comparison of 0/1 to bool
> variable
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> Fix the following coccicheck warning:
>=20
> drivers/scsi/qedi/qedi_main.c:1309:5-25: WARNING: Comparison of 0/1 to
> bool variable
> drivers/scsi/qedi/qedi_main.c:1315:5-25: WARNING: Comparison of 0/1 to
> bool variable
>=20
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c
> index 4dd965860c98..46584e16d635 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1306,13 +1306,13 @@ static irqreturn_t qedi_msix_handler(int irq,
> void *dev_id)
>  			  "process already running\n");
>  	}
>=20
> -	if (qedi_fp_has_work(fp) =3D=3D 0)
> +	if (!qedi_fp_has_work(fp))
>  		qed_sb_update_sb_idx(fp->sb_info);
>=20
>  	/* Check for more work */
>  	rmb();
>=20
> -	if (qedi_fp_has_work(fp) =3D=3D 0)
> +	if (!qedi_fp_has_work(fp))
>  		qed_sb_ack(fp->sb_info, IGU_INT_ENABLE, 1);
>  	else
>  		goto process_again;
> --

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
