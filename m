Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E66DBC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC732613FA
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236829AbhDVRpw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:45:52 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50450 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236659AbhDVRpw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:45:52 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHitP1085225;
        Thu, 22 Apr 2021 17:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/WcPgs25ixRTXGceLxFiH0UKYKYMOTV/zimXwce4ZJU=;
 b=OywvEtLOXoB10pnpBUEFJaSh4D8GKbubZAEJ7UMu7Rdhlw3W0ckuyCsiHD8c1GxrUokd
 DgH8cyA57FPrp2X9uVqffzzO7MsoLqZPmVO/i6dkj+sRWE7tYhRmjsOfJq8gj1bO4a85
 VCp9WamsEkYXbG0O0vI8bQH6uSEEyMzQ1UysIkEtKcVyScjbwNE+mEthWRq1s//ddZ8s
 guxC7+WKgx9y6qRldRP/hHOohLKl0vBpL9PRFxKwk82799LcQRGvU/9GgU6q7dDvnmxN
 fGzauU1a4FXXx/k0pvHer4Ggso9LqT9eGYsmM9m0khjZlxzXFU338/cVCg/DRKEh+F4C Jg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38022y5ka1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:45:11 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHdrbv070833;
        Thu, 22 Apr 2021 17:45:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3030.oracle.com with ESMTP id 383ccekwef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:45:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFl3O4dc4AoRQeExQ5yG3zkRw03+kqCR9IpAlhLzfc80rNDCC567MrJ4Wwrge0kw5Z9BUIisrVEjJuvguuPlbIZN0A3OOXEzoXIsG5m+SgG/MUnW3AH973v+3+ChDmxs83ynGYzQQ1Q8O8TPB4UdTug3NuikPSouC7FxUh+7vyu40OdbYOSAb8EbX9lqVpPgTulCCbDLfmU6WmCd8A3rg0nLnESLP3gXNMW19DNW80SjTdjefhQWEFHZogsZzEqOZ1Sl+uYrXCpQyGRuMGT4UCztx59At2jgxi5KmfYvmoHxV3sl877CJBga47QEiv6q9EkCf7sds60C6e2f4z7CBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WcPgs25ixRTXGceLxFiH0UKYKYMOTV/zimXwce4ZJU=;
 b=l+AOV3EsN3c/J5viFzVke9KAZysUWiDvpPkIA5Z6VhgF99xil5Rkp3NqtsHiwE0gGL7NSpNtbFVIuRHF2ESxN/qmtElHjZwRBvrPWp/VXMT7xk5J4YpA1HbKt675/VABrjV+cQKa4Tg2POdW4saHxrlA6eKo0LhaEw+6kHqJkGCwZ3Ph71VpJjJnQbFqjkOi7EKR5qIYLKzHICAKM/puBPMIdJdn518yaTEyBFKboIgGQu9BGO120QUWwr6zRNKN7kJ5kdV8+yhl+cO2UOHnrdMu5/fgwzjiyvHc86/deJv1cwv/nDM3m2t7ggttU1stAIA77YG6Zr1DdSy3pch+Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/WcPgs25ixRTXGceLxFiH0UKYKYMOTV/zimXwce4ZJU=;
 b=oRl8WwC0nL+KDonHmJu3lm+NpTTzN9sUmcQ5IFmOYOgf48M8QCCaCN1sPN1P8MjOA8NXUycxAnBNWA56DdNpmeaiwIlgjX6dOXCyLuooo6k+SXw/FnMR2l726/Om5igekxn872ryzHgW4h13pIbDw0/L9CAv03Xon407SSlUEUE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB3453.namprd10.prod.outlook.com (2603:10b6:805:db::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Thu, 22 Apr
 2021 17:45:07 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:45:07 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 24/24] mpi3mr: add event handling debug prints
Thread-Topic: [PATCH v3 24/24] mpi3mr: add event handling debug prints
Thread-Index: AQHXNQujPLPbEMChu0a8u3CSIHg51KrA1F4A
Date:   Thu, 22 Apr 2021 17:45:07 +0000
Message-ID: <84CAF7B1-CE38-456D-A214-27F8DD6D9AF5@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-25-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-25-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b7664e13-d9fd-4516-488e-08d905b65e5f
x-ms-traffictypediagnostic: SN6PR10MB3453:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB34535563B0EEBFD23915E486E6469@SN6PR10MB3453.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:549;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fz9aR5EUNYk2Xk3csPrZUTItU5khb7py4Id65L05On7/q37WUGZVWLkX7ePzbqoBK8BHgykjM1um4lpOqz1C6hSYfrXeygE9UQM6jyS2LYigkUH+93oSIjPn3RIo+Iufti0JHC3/bf6clxz2sSvoNCgyWK2RnIhPpoQ50QiXvD4G26mK5bKySiEnIXQbHJRXvw8seHcS6oWeYzmVEfTD60n/BufQcysQHGbzzULtEL3vn4t/A57AZZG5PeYT9oClcIiDYlQr8eqUi9ogUWy6QttXfKhfkm2+U4Sa+zuNb5mKbM14+Ddv/En1owov0SBw3OgwHnSjcz6O7TYHv9KHKxvhBuzgiSxX2bZDy/VD8ETIkkHqHSZaiaokH9J/RvJcUP5BRTS6qAYLAjnpqZlej3AS9M4onGyZictlhbybe37BvA2Vk5QwNyC/70I0ESGiEVYJATWmaN/ewxkOOBVBlh6MSx7xHx+ZiFj1gjebAWBXe5AZpUnsQdAqBJYlSzmHo37oZtApgGLaQxZJCovMMNu/6lCvnN2vZ7um40NUzzrbl9yPWB0FSISYfdMiWihtoqQweh1tTtqp4pFAKGAQcJuC93XTiFgo/R83U0zQZTaO8pefp8abuIllTWMT4wkE8JHHgbTqeTSjlDBEPEptqGAqIY7tT+kh8peVR+hTsaK7jw/cBMvKdfVVJs/tHtqT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(346002)(376002)(396003)(86362001)(4326008)(6512007)(5660300002)(6486002)(30864003)(8676002)(66476007)(44832011)(66946007)(33656002)(71200400001)(66556008)(76116006)(36756003)(38100700002)(316002)(186003)(66446008)(53546011)(478600001)(122000001)(26005)(54906003)(6506007)(83380400001)(8936002)(6916009)(64756008)(2616005)(19627235002)(2906002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?TLsFnxw3lG453aaUbmYWV+8SoPmgMVbgNEIYWtUZQPvhsXPCRhLGcoQqfwwM?=
 =?us-ascii?Q?FfTqw75HwTxO+rHGaY/6iknET/XxVbEuAFCRpkgDWVA08RMsxE6XpGGW6s/h?=
 =?us-ascii?Q?flz+3Doc1onf8M5zKOmraLB8sZxuE4e3u5vgEamvQowV56hKZTBKUb9LoCJi?=
 =?us-ascii?Q?9xeJ9RRR2zxi/a369iDZlMr8BNelkvw+A8u0lW2QlzT8d/GxWFkWt466j/rC?=
 =?us-ascii?Q?SLx3sYeDbSGbOz+edbhFKJ3flF9iSZ6GP3iYe3PzZ0iDwzFbQeDlpAVZlHVh?=
 =?us-ascii?Q?N23u3y7830mLEHn4UfSqdoVSJd/pkr1C919vSRPPcDkSyMCJEUqrtQpoS/DN?=
 =?us-ascii?Q?r7506WQjTFSZaJARkz1CkTHsCExdF9Qz3U4WYictWUmjLmRFiNY86r75JzBc?=
 =?us-ascii?Q?uvoJEgqjrVZ05GzZviIUf6ditvhVTknzGPu8DCW3efP0G6GUqY1TDSxZpX3J?=
 =?us-ascii?Q?DMqepUIs+DQCyN55xgP2TwaGuGkKi1lNrBGbD0XGm5m+0cF9J6ho4JsaiDXb?=
 =?us-ascii?Q?hcwC8YBpCgcWrLMHFul2nWzIOad/bH9optTUJe9BnVkNg6gjQuu5Nt8y7P4R?=
 =?us-ascii?Q?Mz3aV6xefObfhuygo4IHBDdilL2nzMGJOttRisNyok8UZL1b5gvhm4RsDjV3?=
 =?us-ascii?Q?gdLCjTQfZueXwnXRHH59pknaNtpPlzvzrrCtTWdLSzT5m9IaRjQLli21Ca4z?=
 =?us-ascii?Q?fbvGkXZHdLnuNHOQHs6sh9u7pDN10VW0axivtl2rErKWpDq1da1MACTug6uS?=
 =?us-ascii?Q?JpEItEDWvUVnsw21U6ptZRekYw93yjSipQrgjUqj5BHczqV/19kxQylotwpy?=
 =?us-ascii?Q?1zOOYB8OQvbHr/RXdyUMIhmRuz4VC4Pg2jCb9AeKKaO68u5yEEcY2yJA78J/?=
 =?us-ascii?Q?YE6PDEC5BQpK1TGS1+XGowImpWITnx62dQAFdC+pqsKTXdLS83GYz6crAJvi?=
 =?us-ascii?Q?ncDyTBtwreOqahsdzlabcwfrm9aWz1NhmPt8suuHbHkb+Qpmk+ydugRElFIF?=
 =?us-ascii?Q?AXMVG4jcu8AOTL2cPy8EEKmoOu+LT6U3QQFSNVwOKbVM8r+iUKZHM488SAAu?=
 =?us-ascii?Q?fSHmZ2g1Dvxfv2llgmDttMum/ZhhxpuxAx14oyq2+buN8rceeo8kPb8VoO/8?=
 =?us-ascii?Q?7GXw0kizhLECGPJfziNAXNz6nP21yM5izVTcJZs0ReCge4P0ksIeb40K49K+?=
 =?us-ascii?Q?r24R4xs3AZdthceq5Lky4aVazAdJhitQ3/A+x8snVndUC/ANr46NX1OCNjp2?=
 =?us-ascii?Q?83A9xtXqNAUqT6Vz+roc3F0Q2LemrWiDBofz7FT+PC8ciAcPgl5muxC0sqgE?=
 =?us-ascii?Q?iern5Gc698EKWFQT+Ewk6i8gu+Tfyx9NyXFc0CRyB/HXPQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9F08A413A3D9CF4E8CC0DE376462A63F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7664e13-d9fd-4516-488e-08d905b65e5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:45:07.4756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B6TkLW4mOVA91aoJbZFo3AdJ1gWJu0qSycoCiWq7yGiYxgBNrr46czvJwrpJfFVkMqnKeUV/+aJ+myQXubA/U4sJz2Dc0eSFspegalAtMok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3453
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 suspectscore=0
 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220133
X-Proofpoint-ORIG-GUID: eZeS9Mygy26hMAe5j5SNkp3w1ke-upvR
X-Proofpoint-GUID: eZeS9Mygy26hMAe5j5SNkp3w1ke-upvR
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220131
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 116 ++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 164 ++++++++++++++++++++++++++++++++
> 2 files changed, 280 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index ee20d63f6061..b8c3ae98e5f3 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -155,6 +155,121 @@ void mpi3mr_repost_sense_buf(struct mpi3mr_ioc *mri=
oc,
> 	spin_unlock(&mrioc->sbq_lock);
> }
>=20
> +
> +static void mpi3mr_print_event_data(struct mpi3mr_ioc *mrioc,
> +	Mpi3EventNotificationReply_t *event_reply)
> +{
> +	char *desc =3D NULL;
> +	u16 event;
> +
> +	event =3D event_reply->Event;
> +
> +	switch (event) {
> +	case MPI3_EVENT_LOG_DATA:
> +		desc =3D "Log Data";
> +		break;
> +	case MPI3_EVENT_CHANGE:
> +		desc =3D "Event Change";
> +		break;
> +	case MPI3_EVENT_GPIO_INTERRUPT:
> +		desc =3D "GPIO Interrupt";
> +		break;
> +	case MPI3_EVENT_TEMP_THRESHOLD:
> +		desc =3D "Temperature Threshold";
> +		break;
> +	case MPI3_EVENT_CABLE_MGMT:
> +		desc =3D "Cable Management";
> +		break;
> +	case MPI3_EVENT_ENERGY_PACK_CHANGE:
> +		desc =3D "Energy Pack Change";
> +		break;
> +	case MPI3_EVENT_DEVICE_ADDED:
> +	{
> +		Mpi3DevicePage0_t *event_data =3D
> +		    (Mpi3DevicePage0_t *)event_reply->EventData;
> +		ioc_info(mrioc, "Device Added: Dev=3D0x%04x Form=3D0x%x\n",
> +		    event_data->DevHandle, event_data->DeviceForm);
> +		return;
> +	}
> +	case MPI3_EVENT_DEVICE_INFO_CHANGED:
> +	{
> +		Mpi3DevicePage0_t *event_data =3D
> +		    (Mpi3DevicePage0_t *)event_reply->EventData;
> +		ioc_info(mrioc, "Device Info Changed: Dev=3D0x%04x Form=3D0x%x\n",
> +		    event_data->DevHandle, event_data->DeviceForm);
> +		return;
> +	}
> +	case MPI3_EVENT_DEVICE_STATUS_CHANGE:
> +	{
> +		Mpi3EventDataDeviceStatusChange_t *event_data =3D
> +		    (Mpi3EventDataDeviceStatusChange_t *)event_reply->EventData;
> +		ioc_info(mrioc, "Device Status Change: Dev=3D0x%04x RC=3D0x%x\n",
> +		    event_data->DevHandle, event_data->ReasonCode);
> +		return;
> +	}
> +	case MPI3_EVENT_SAS_DISCOVERY:
> +	{
> +		Mpi3EventDataSasDiscovery_t *event_data =3D
> +		    (Mpi3EventDataSasDiscovery_t *)event_reply->EventData;
> +		ioc_info(mrioc, "SAS Discovery: (%s) status (0x%08x)\n",
> +		    (event_data->ReasonCode =3D=3D MPI3_EVENT_SAS_DISC_RC_STARTED) ?
> +		    "start" : "stop",
> +		    le32_to_cpu(event_data->DiscoveryStatus));
> +		return;
> +	}
> +	case MPI3_EVENT_SAS_BROADCAST_PRIMITIVE:
> +		desc =3D "SAS Broadcast Primitive";
> +		break;
> +	case MPI3_EVENT_SAS_NOTIFY_PRIMITIVE:
> +		desc =3D "SAS Notify Primitive";
> +		break;
> +	case MPI3_EVENT_SAS_INIT_DEVICE_STATUS_CHANGE:
> +		desc =3D "SAS Init Device Status Change";
> +		break;
> +	case MPI3_EVENT_SAS_INIT_TABLE_OVERFLOW:
> +		desc =3D "SAS Init Table Overflow";
> +		break;
> +	case MPI3_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
> +		desc =3D "SAS Topology Change List";
> +		break;
> +	case MPI3_EVENT_ENCL_DEVICE_STATUS_CHANGE:
> +		desc =3D "Enclosure Device Status Change";
> +		break;
> +	case MPI3_EVENT_HARD_RESET_RECEIVED:
> +		desc =3D "Hard Reset Received";
> +		break;
> +	case MPI3_EVENT_SAS_PHY_COUNTER:
> +		desc =3D "SAS PHY Counter";
> +		break;
> +	case MPI3_EVENT_SAS_DEVICE_DISCOVERY_ERROR:
> +		desc =3D "SAS Device Discovery Error";
> +		break;
> +	case MPI3_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> +		desc =3D "PCIE Topology Change List";
> +		break;
> +	case MPI3_EVENT_PCIE_ENUMERATION:
> +	{
> +		Mpi3EventDataPcieEnumeration_t *event_data =3D
> +		    (Mpi3EventDataPcieEnumeration_t *)event_reply->EventData;
> +		ioc_info(mrioc, "PCIE Enumeration: (%s)",
> +		    (event_data->ReasonCode =3D=3D
> +		    MPI3_EVENT_PCIE_ENUM_RC_STARTED) ? "start" : "stop");
> +		if (event_data->EnumerationStatus)
> +			ioc_info(mrioc, "enumeration_status(0x%08x)\n",
> +			    le32_to_cpu(event_data->EnumerationStatus));
> +		return;
> +	}
> +	case MPI3_EVENT_PREPARE_FOR_RESET:
> +		desc =3D "Prepare For Reset";
> +		break;
> +	}
> +
> +	if (!desc)
> +		return;
> +
> +	ioc_info(mrioc, "%s\n", desc);
> +}
> +
> static void mpi3mr_handle_events(struct mpi3mr_ioc *mrioc,
> 	Mpi3DefaultReply_t *def_reply)
> {
> @@ -162,6 +277,7 @@ static void mpi3mr_handle_events(struct mpi3mr_ioc *m=
rioc,
> 	    (Mpi3EventNotificationReply_t *)def_reply;
>=20
> 	mrioc->change_count =3D le16_to_cpu(event_reply->IOCChangeCount);
> +	mpi3mr_print_event_data(mrioc, event_reply);
> 	mpi3mr_os_handle_events(mrioc, event_reply);
> }
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 9a189fb32ab0..2cef7403f941 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -1005,6 +1005,85 @@ static void mpi3mr_devinfochg_evt_bh(struct mpi3mr=
_ioc *mrioc,
>=20
> }
>=20
> +/**
> + * mpi3mr_sastopochg_evt_debug - SASTopoChange details
> + * @mrioc: Adapter instance reference
> + * @event_data: SAS topology change list event data
> + *
> + * Prints information about the SAS topology change event.
> + *
> + * Return: Nothing.
> + */
> +static void
> +mpi3mr_sastopochg_evt_debug(struct mpi3mr_ioc *mrioc,
> +	Mpi3EventDataSasTopologyChangeList_t *event_data)
> +{
> +	int i;
> +	u16 handle;
> +	u8 reason_code, phy_number;
> +	char *status_str =3D NULL;
> +	u8 link_rate, prev_link_rate;
> +
> +	switch (event_data->ExpStatus) {
> +	case MPI3_EVENT_SAS_TOPO_ES_NOT_RESPONDING:
> +		status_str =3D "remove";
> +		break;
> +	case MPI3_EVENT_SAS_TOPO_ES_RESPONDING:
> +		status_str =3D  "responding";
> +		break;
> +	case MPI3_EVENT_SAS_TOPO_ES_DELAY_NOT_RESPONDING:
> +		status_str =3D "remove delay";
> +		break;
> +	case MPI3_EVENT_SAS_TOPO_ES_NO_EXPANDER:
> +		status_str =3D "direct attached";
> +		break;
> +	default:
> +		status_str =3D "unknown status";
> +		break;
> +	}
> +	ioc_info(mrioc, "%s :sas topology change: (%s)\n",
> +	    __func__, status_str);
> +	ioc_info(mrioc,
> +	    "%s :\texpander_handle(0x%04x), enclosure_handle(0x%04x) start_phy(=
%02d), num_entries(%d)\n",
> +	    __func__, le16_to_cpu(event_data->ExpanderDevHandle),
> +	    le16_to_cpu(event_data->EnclosureHandle),
> +	    event_data->StartPhyNum, event_data->NumEntries);
> +	for (i =3D 0; i < event_data->NumEntries; i++) {
> +		handle =3D le16_to_cpu(event_data->PhyEntry[i].AttachedDevHandle);
> +		if (!handle)
> +			continue;
> +		phy_number =3D event_data->StartPhyNum + i;
> +		reason_code =3D event_data->PhyEntry[i].Status &
> +		    MPI3_EVENT_SAS_TOPO_PHY_RC_MASK;
> +		switch (reason_code) {
> +		case MPI3_EVENT_SAS_TOPO_PHY_RC_TARG_NOT_RESPONDING:
> +			status_str =3D "target remove";
> +			break;
> +		case MPI3_EVENT_SAS_TOPO_PHY_RC_DELAY_NOT_RESPONDING:
> +			status_str =3D "delay target remove";
> +			break;
> +		case MPI3_EVENT_SAS_TOPO_PHY_RC_PHY_CHANGED:
> +			status_str =3D "link status change";
> +			break;
> +		case MPI3_EVENT_SAS_TOPO_PHY_RC_NO_CHANGE:
> +			status_str =3D "link status no change";
> +			break;
> +		case MPI3_EVENT_SAS_TOPO_PHY_RC_RESPONDING:
> +			status_str =3D "target responding";
> +			break;
> +		default:
> +			status_str =3D "unknown";
> +			break;
> +		}
> +		link_rate =3D event_data->PhyEntry[i].LinkRate >> 4;
> +		prev_link_rate =3D event_data->PhyEntry[i].LinkRate & 0xF;
> +		ioc_info(mrioc,
> +		    "%s :\tphy(%02d), attached_handle(0x%04x): %s: link rate: new(0x%0=
2x), old(0x%02x)\n",
> +		    __func__, phy_number, handle, status_str, link_rate,
> +		    prev_link_rate);
> +	}
> +}
> +
> /**
>  * mpi3mr_sastopochg_evt_bh - SASTopologyChange evt bottomhalf
>  * @mrioc: Adapter instance reference
> @@ -1026,6 +1105,8 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr_=
ioc *mrioc,
> 	u8 reason_code;
> 	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
>=20
> +	mpi3mr_sastopochg_evt_debug(mrioc, event_data);
> +
> 	for (i =3D 0; i < event_data->NumEntries; i++) {
> 		handle =3D le16_to_cpu(event_data->PhyEntry[i].AttachedDevHandle);
> 		if (!handle)
> @@ -1052,6 +1133,87 @@ static void mpi3mr_sastopochg_evt_bh(struct mpi3mr=
_ioc *mrioc,
> 	}
> }
>=20
> +/**
> + * mpi3mr_pcietopochg_evt_debug - PCIeTopoChange details
> + * @mrioc: Adapter instance reference
> + * @event_data: PCIe topology change list event data
> + *
> + * Prints information about the PCIe topology change event.
> + *
> + * Return: Nothing.
> + */
> +static void
> +mpi3mr_pcietopochg_evt_debug(struct mpi3mr_ioc *mrioc,
> +	Mpi3EventDataPcieTopologyChangeList_t *event_data)
> +{
> +	int i;
> +	u16 handle;
> +	u16 reason_code;
> +	u8 port_number;
> +	char *status_str =3D NULL;
> +	u8 link_rate, prev_link_rate;
> +
> +	switch (event_data->SwitchStatus) {
> +	case MPI3_EVENT_PCIE_TOPO_SS_NOT_RESPONDING:
> +		status_str =3D "remove";
> +		break;
> +	case MPI3_EVENT_PCIE_TOPO_SS_RESPONDING:
> +		status_str =3D  "responding";
> +		break;
> +	case MPI3_EVENT_PCIE_TOPO_SS_DELAY_NOT_RESPONDING:
> +		status_str =3D "remove delay";
> +		break;
> +	case MPI3_EVENT_PCIE_TOPO_SS_NO_PCIE_SWITCH:
> +		status_str =3D "direct attached";
> +		break;
> +	default:
> +		status_str =3D "unknown status";
> +		break;
> +	}
> +	ioc_info(mrioc, "%s :pcie topology change: (%s)\n",
> +	    __func__, status_str);
> +	ioc_info(mrioc,
> +	    "%s :\tswitch_handle(0x%04x), enclosure_handle(0x%04x) start_port(%=
02d), num_entries(%d)\n",
> +	    __func__, le16_to_cpu(event_data->SwitchDevHandle),
> +	    le16_to_cpu(event_data->EnclosureHandle),
> +	    event_data->StartPortNum, event_data->NumEntries);
> +	for (i =3D 0; i < event_data->NumEntries; i++) {
> +		handle =3D
> +		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
> +		if (!handle)
> +			continue;
> +		port_number =3D event_data->StartPortNum + i;
> +		reason_code =3D event_data->PortEntry[i].PortStatus;
> +		switch (reason_code) {
> +		case MPI3_EVENT_PCIE_TOPO_PS_NOT_RESPONDING:
> +			status_str =3D "target remove";
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_DELAY_NOT_RESPONDING:
> +			status_str =3D "delay target remove";
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_PORT_CHANGED:
> +			status_str =3D "link status change";
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_NO_CHANGE:
> +			status_str =3D "link status no change";
> +			break;
> +		case MPI3_EVENT_PCIE_TOPO_PS_RESPONDING:
> +			status_str =3D "target responding";
> +			break;
> +		default:
> +			status_str =3D "unknown";
> +			break;
> +		}
> +		link_rate =3D event_data->PortEntry[i].CurrentPortInfo &
> +		    MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK;
> +		prev_link_rate =3D event_data->PortEntry[i].PreviousPortInfo &
> +		    MPI3_EVENT_PCIE_TOPO_PI_RATE_MASK;
> +		ioc_info(mrioc,
> +		    "%s :\tport(%02d), attached_handle(0x%04x): %s: link rate: new(0x%=
02x), old(0x%02x)\n",
> +		    __func__, port_number, handle, status_str, link_rate,
> +		    prev_link_rate);
> +	}
> +}
> /**
>  * mpi3mr_pcietopochg_evt_bh - PCIeTopologyChange evt bottomhalf
>  * @mrioc: Adapter instance reference
> @@ -1073,6 +1235,8 @@ static void mpi3mr_pcietopochg_evt_bh(struct mpi3mr=
_ioc *mrioc,
> 	u8 reason_code;
> 	struct mpi3mr_tgt_dev *tgtdev =3D NULL;
>=20
> +	mpi3mr_pcietopochg_evt_debug(mrioc, event_data);
> +
> 	for (i =3D 0; i < event_data->NumEntries; i++) {
> 		handle =3D
> 		    le16_to_cpu(event_data->PortEntry[i].AttachedDevHandle);
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

