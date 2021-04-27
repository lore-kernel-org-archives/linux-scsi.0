Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7E0CC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 16:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74123613C3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 16:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbhD0Q2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 12:28:11 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60184 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237382AbhD0Q1n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 12:27:43 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RGL8Lg115330;
        Tue, 27 Apr 2021 16:26:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8WB3NY1dS2HF+SizxiRG6nsPfewssAIc8MKjByc10Ec=;
 b=ewEutThf46Kd/+X5veRHbU9S3jjY+Sk6MydfVY4u6Hgq5bfk04PpJ0rgAfq7rS2gMt5U
 6rkwzwuwxOGHst617etDl16QBlQuit7UVB0XKaSttfSpD4EDviCSZsxdKfs6yr2gyyga
 8UB+fUtzbHINxgtafLTvI4nlHUemZmlJWoF8iUTyVrSZBAbEECdh5DwmZVImF44Ft8n9
 xc5x5m+wqIKw6vl3gprNKY4LYjsbB5Nhu2siklnLAYU+LLnQtzHPRrco/7nqKK3Di7u6
 hplHCPDdaaR/Ah1eMJ+6F8evtPIidDwkhjX2CZ00jcGlwZ1IYjknS0If9OqEWiuU0vB5 Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 385afpx4pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 16:26:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13RGNsK2175279;
        Tue, 27 Apr 2021 16:26:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3848ex7pnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Apr 2021 16:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y8nUjB+R8qwQaSbM1mXu54a0x9HS3JPzY8Wwv8Pfpw60YrXuuoYkJfL3TPxbiFed/t9/eolrlDFRzzmNj2TjtGeEuuxrgYUnxE9bDZBgHKMlqton/Oml3mIVWj3qu/2L59E+dRAXJHsvRsecCPOxBp9FMVAwF79xQYmNAltnbD3fZRo0arRy29xYPviBsyMAkXbqujhc8e8O+ZWmruGryFNN53Euo6cZKJKQjBu6qmWxoSS5JR4L7W4o+1RFS6Kwb+xbLEcUSiSaMJh5/tnqOHkc9b6OnkDaPfL64PKepGTAZgippclNsLmdyrcUlntZXYTWKZEPE6Ug5fznChnyNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WB3NY1dS2HF+SizxiRG6nsPfewssAIc8MKjByc10Ec=;
 b=HLafyYXFwQFBuNtP/y3SfNdjSLo/GUR56m26eEc3DRjA6VaeBlhnuWgsMQmSYLnE+sNuVOvGtChvgUi7rkIG8Bq12o2yyBIuf5Wk/CVOg1azvh81yyihp0G8cHBT/vcUPt6G2tufVe35iOcDgLWKQO02A6DMgweuzzkXgWBi9pjWtEZ5pH/KYNwAMFQeg/9FEDoxmmFyVe39xeeNSs5BkoHznKEpPiy0VJp6/YztNKEI+62DSJnPxnbDB3Z70dVoKIhwoQ7R+xyV1g/dWIWKmmJIOoHwGDSku8MwfleUieSvm8Ca5QTc1KDccv0RVKoHR9/oTlFdMsRvATWTACQ+JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WB3NY1dS2HF+SizxiRG6nsPfewssAIc8MKjByc10Ec=;
 b=eWHQ5N8tx4hz5R3FU0VukEIS+8uRzbpNDqWy9TbMwqsq+NSVhWH43qGJ0/GUubFVrRpfgsbjT6rCPsxqfoKbIRk6gTKZ7PA8eFxgR3F5NOMcVc9NPeKq8piVWoZlKuxAQ1L6IaJJVe0/XBDJ28eGal3nXDq7weiztgy0B6tabNk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2941.namprd10.prod.outlook.com (2603:10b6:805:dc::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.25; Tue, 27 Apr
 2021 16:26:52 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4065.027; Tue, 27 Apr 2021
 16:26:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 1/1] qla2xxx: Add marginal path support
Thread-Topic: [PATCH 1/1] qla2xxx: Add marginal path support
Thread-Index: AQHXOyON4PS9VLZxMUSf867BJqiZbKrIjfsA
Date:   Tue, 27 Apr 2021 16:26:52 +0000
Message-ID: <99408A1E-476F-46EE-A48A-F2A63B5EF973@oracle.com>
References: <20210427050914.7270-1-njavali@marvell.com>
In-Reply-To: <20210427050914.7270-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0aaeb7ba-4ddc-4f39-674c-08d909994433
x-ms-traffictypediagnostic: SN6PR10MB2941:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB29410C40591AFE6A70287638E6419@SN6PR10MB2941.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wFjmy+DLSZdBWt7N4SPb6T1qkDfNfupopCxe6faGIyDqBKCRlIl73gh3+kK/eWHpwZrVlAfB5ykrBSbc7t5kuAIrbDsjiRn1B6wXROs7FdOjLFOeqkHC1Ea1latTbFLVY4rutOuRdG9OHR2HT0R0No/nN8l7nJrWeucpHGWVSD8Gkz8Edhy4ZsL2mUh4xAEGUxMICxj+Vtv5IoIVCrHxFNE9BNRGNlKPoLfGKs7tj949EMQEDWhVSmgn4Z0SPdNyvjL7ANQaqUVyD/bjDbVsSFHK6P3YDVyFHyRHU9GO/gcOBx6BqOw+En/gqSUFi6+JZm+Qw/JGEjRl/oCumQgjbeLIAiuMHDBJxrd9ylZcyisf+gcaMr7VuoX9lwiQvijWcP5/PjfZ1IelKBxuI2G/wqAKm9fG8fLxOXpdGr/OiepQgastdcwPsFVLLwhDesS0TA6zOLBezOn2p1uFubSEFRygmNLSfZN5lKg2nejv52SCvb5b9Q93nGSMT0QbenE6tB6WXV/b8fgBtK7MUqjpFO+muxtCw5UNgLBS+h34RBY5la3CgfldrGCvu9RU5aUNJaQGrwRPh/2ahItc6yDsnpMZHnVGgSgAZwCYCGL830MyUT5VRbjUqCUrQtbIsOK45qDt2Q6D1wOIEmFRLR13d6+1M0+FOFm3ZbILHW7aq1o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(396003)(346002)(26005)(316002)(2616005)(36756003)(186003)(6486002)(8936002)(4744005)(4326008)(54906003)(44832011)(2906002)(478600001)(86362001)(6916009)(33656002)(71200400001)(122000001)(76116006)(5660300002)(66556008)(6512007)(66476007)(66946007)(64756008)(8676002)(66446008)(6506007)(53546011)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BocGkcMBubiMmkYab+HqZ814bypkCO8560cBQaBRy8nER5ymPPYp23tHDcaE?=
 =?us-ascii?Q?zTuSga7+5yrM3DhR1Ya8/Z5dWaGbt2EYcP34Q3ueeM+9rhqgnDQhsTskLkxf?=
 =?us-ascii?Q?5GM8u8tfKrvQBwBPKqjnc70cVXWKxrEJFh7k0peMt629WuRpcMYYakWkMSwY?=
 =?us-ascii?Q?vjtoSBRz+BfXdhUgrJ2Gza5ZNUj+0BSY8F1MtKX3Ag1juysVS+pA0C6jfXd3?=
 =?us-ascii?Q?06DnzzpuL21KgGuO87cETHCv+OjR5oYaDrYQUkRIHNo/tptR/A9PQ4839vDl?=
 =?us-ascii?Q?J/P2SqRxdyAZsjbxww+lwr/8UJTVRMIKuwTsrnUYbG7dOcixyjYDbHHtNmI8?=
 =?us-ascii?Q?wip/RcK/yKUnRbvRQlAmR9R51tAprbxKwlQCSeOCQQytAosTzxNp22vjx6MX?=
 =?us-ascii?Q?xQSD0B1SeKCWlKuIjomMKEn9ZWb5DUCnbrb6zRj1OHwL4Yv8YjpnbQXDI1R9?=
 =?us-ascii?Q?UtGDBn7DsNWGuRwF+LAsuV2ktzOf44J2Vvz4QocfzOkeX46qL8G9M1wr887E?=
 =?us-ascii?Q?09/uLazgz0xc/El+vO7XGOcnw3KFq6Vo6WdhZ2axZ1jek1dWCnPqz0Nhf7D/?=
 =?us-ascii?Q?colHKiMYnOcXrs7IoSjHTYgTYLr06bayZV7rGeD27Xerk+eNKTaRVDON1q+4?=
 =?us-ascii?Q?s6nr6qhBs1seo2PvfN9Elb87BwnqKLTBw/SGIcIXsD0C5DqVngZbHkU7Fajn?=
 =?us-ascii?Q?a67GotqABkboxFwmzFaeph6jtTfmM7xddFaqdv4B+wASbK/ZD6sQwzwoAk+F?=
 =?us-ascii?Q?N6Hj9VTOYR20/83Dmk5jzZCqwx66rCUnM83tQqPkC45AVXBh51fqSz4+4WQI?=
 =?us-ascii?Q?PHEOiVNHhQvyWoPdITn2czP2FHuH4vXJeqrdbM/upDZScnOu5JISnn1vb+hJ?=
 =?us-ascii?Q?50UsSBPCYS66mUiUw1ydxR7PDSWDOyYBb3jxqAMtNW4tog/bH33xcN0UdMof?=
 =?us-ascii?Q?YKxt2+DWTkjNy/dx+6mWfle+pvz3bTQQfe/NPmlaPErVDnMjUppXJw4/S4Eq?=
 =?us-ascii?Q?5LK0W+8o6mYd6++iAICigZut8TkL9iPGdkhGIj/iDI1xKATh4oyDDJOKI23u?=
 =?us-ascii?Q?vIXB4qd7JTcUVHrL2vecUe+lflgXP4pYi9pyEAnimBz5P2y8GuBjuUfNNWpl?=
 =?us-ascii?Q?m+77KhRLV/cnTds3j6/1QT/OH0aM+YwuKF/N3WSi4LZkJDhN9DqWD69sHAHm?=
 =?us-ascii?Q?3OVbgu7je3EAU3ZwCKIqyead129Q8btZ1kXIbLst3G3+qs3bIFIy/lCp0kA5?=
 =?us-ascii?Q?SLiYO0fMBzqNIVRX+D1JpRzxfLLzL71QBqGp282NlOawH1xzXsfdQ/0H6OM5?=
 =?us-ascii?Q?Dnzrfi+iGn2jKpV+GKxazCrsfZ1RWRLRMuDpAE1dhd5kLg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E99ED104DD3A0644929539ACB019BADE@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0aaeb7ba-4ddc-4f39-674c-08d909994433
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2021 16:26:52.6902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JYGGUtL2MGDNQQkKTyGS1Yh5ZbMcFZjndwDJrArUyArnG+Do8PSvrZN70ZB1hImJ0oKEcGwnm5bxEKcb9RlTXxQBtgqfKR8xcSLPOUwVmfY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2941
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270112
X-Proofpoint-ORIG-GUID: pxkmKG01LYNeKeIAjDAxZ6dnwZ9vyS_o
X-Proofpoint-GUID: pxkmKG01LYNeKeIAjDAxZ6dnwZ9vyS_o
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9967 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104270112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 27, 2021, at 12:09 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Bikash Hazarika <bhazarika@marvell.com>
>=20
> Added support for eh_should_retry_cmd callback in qla2xxx host template.
>=20
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index d74c32f84ef5..4eab564ea6a0 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7707,6 +7707,7 @@ struct scsi_host_template qla2xxx_driver_template =
=3D {
>=20
> 	.eh_timed_out		=3D fc_eh_timed_out,
> 	.eh_abort_handler	=3D qla2xxx_eh_abort,
> +	.eh_should_retry_cmd	=3D fc_eh_should_retry_cmd,
> 	.eh_device_reset_handler =3D qla2xxx_eh_device_reset,
> 	.eh_target_reset_handler =3D qla2xxx_eh_target_reset,
> 	.eh_bus_reset_handler	=3D qla2xxx_eh_bus_reset,
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

