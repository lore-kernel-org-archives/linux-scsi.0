Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C26A8C4320A
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 08:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD3CC60724
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Aug 2021 08:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239605AbhHMIrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 04:47:52 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:23482 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239327AbhHMIrv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Aug 2021 04:47:51 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8kWgu006113;
        Fri, 13 Aug 2021 01:47:20 -0700
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ad8x9j6ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 01:47:20 -0700
Received: from m0045851.ppops.net (m0045851.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8l6WM007100;
        Fri, 13 Aug 2021 01:47:19 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0b-0016f401.pphosted.com with ESMTP id 3ad8x9j6sp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 01:47:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HLpVXf8OP+9v9/yfhwxZSqTQVQAbu4sqZp6xTTVUBpm5a0b5e/fzfKpA1lI/m68QF3OaqHNQUF4zKXQNzfIXQSsUf9pqEPhBpecALBotcpqnnVGVR98pW8qbgzcdlhN2D1QDCxHieh2SN7+BsvCaV+YKCgJfg5VoJPcmfNbNPzrQOFbPCeLr8yLCqCaJRYBTNqs35PIaA7iWykUaDMqJjIKCUEjnKlAzAQCvixDJSchROsJs5kzdqpBgvngh+448U9mwHcGlL5cH33M6yilbaneA4gJ5QWb5a6fibgBdMqFjilK1+a3IsTkhrRll9pm4bXq1qZXlUOhWLwUQv/9pGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSV3U+KpyLBOs7vRc4YDrfIW+XhWCvEPZknx5+ijx3I=;
 b=ir2G3tT8jjOSnhBhMP1DdhucE6ro3OAFOj+KTHfNdGRBRbGqIrJhGP622Y5B5qPZviZaljpqy4synG4C2HTlpbwa3kRfjJ4Mxl9LRQ+iB13SnnphUYuPShVrgzEyYNrpUZlqm0tp13g8VhP+XHgquHyTtWGHKgiibNf9FE5Yl1OZ4CBmdYXeZb0yohoxxSLgu8J4QXwk1sZF3AlOIX/K/yEqFWngMkNmDwXqnR1En6+7LUtJ4cRpBOU9X6JhCrSMLgoIbMZ0dVo7FRMA+6p6WnMcHz4/mG/kIHeD5vm91U7RMwIR+fGmymHv1jSDaXZv4NkLWtqc6pFykUAdeCy+Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xSV3U+KpyLBOs7vRc4YDrfIW+XhWCvEPZknx5+ijx3I=;
 b=YvImXBJdVU8BdILW5HwjcTfM6jSAgoNAQkLQ1Z+osrdQ0U5NywtK3YmdDX5VZqTZi8+4FhcvnHv9UhyEiCtq4wjeVaCO+WW5041lmj9fZN209jMq7FVLa+OlfH/vr0cxGYN0WVGpMe1NQub+y4tRApy5Bb9YVhY79gGgQroiOHw=
Received: from CO6PR18MB4419.namprd18.prod.outlook.com (2603:10b6:5:35a::11)
 by CO6PR18MB4484.namprd18.prod.outlook.com (2603:10b6:5:359::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Fri, 13 Aug
 2021 08:47:17 +0000
Received: from CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::49cf:878a:24ea:9f42]) by CO6PR18MB4419.namprd18.prod.outlook.com
 ([fe80::49cf:878a:24ea:9f42%5]) with mapi id 15.20.4415.019; Fri, 13 Aug 2021
 08:47:16 +0000
From:   Manish Rangankar <mrangankar@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Arun Easi <arun.easi@cavium.com>,
        Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/2] scsi: qedi: Fix error codes in
 qedi_alloc_global_queues()
Thread-Topic: [EXT] [PATCH 1/2] scsi: qedi: Fix error codes in
 qedi_alloc_global_queues()
Thread-Index: AQHXjcR4qElDxt5k/USOjwio4uIimqtxI9qA
Date:   Fri, 13 Aug 2021 08:47:16 +0000
Message-ID: <CO6PR18MB4419CCF46BC91F8FA5458A77D8FA9@CO6PR18MB4419.namprd18.prod.outlook.com>
References: <20210810084753.GD23810@kili>
In-Reply-To: <20210810084753.GD23810@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 508a897c-e3bf-4b8a-b1ed-08d95e36f42b
x-ms-traffictypediagnostic: CO6PR18MB4484:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB448486DF00DBE8959DAC174FD8FA9@CO6PR18MB4484.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1CzO///fAiWUeKFS2v0rPoRle2Fh45sFA7n9vRxfFMUzlxRVz5oWf/VJYCAOn220LyLVYENTQllFrWTc9tIDyQErjEl5QT8PgKikqjwFKWvOr6FLd1yXAtiNoxELZCgrVu8Ykg2tLDUh2WtQOcs0Z+f/AC01sspUxdRDobisTjIFZYOLkZpUV5UlTdQcwKzhOqJZTPzUH+fSg52MnwZ7x0rJwmc6ZRcq84FMM5sxIdStpdMs/WNImKRpuMat6EVqIylspoN8LRwWPXRIwPmbAvjTiFenSL+8UWFggugO1HdOwuo05fdPvnUuJRtDVG/hNJhOhwLB8pY04CKH0+UHXbkeJCNNh9VUYv1y58G4OQgIAFnLWBCdRLYSHCkpqCV1iOvW3pNdKrlTjgpSYwFUFR4X3IhTX08C0xvFkiWY7TEgyOYov8cLSQ4r+iXbIQsBCNmmVI7MM4xNhDB1ClFe+WMz8oG1mXRhAnLQkfPq+cpFlZNcrXfa8FA9auz5CrGvoCrFfNTW0xHeb8vVqUJgWkL16TZGs6RfcnhQ4phkNudTUtA73yjHe4+W8SuX/OnMp6kE9e7Msat64fKGNPBsflXscLXRh12HPTr0cZR8tEQMo1iQnv/dH3s4gmKxU5lleBJWgER2P0kT/L030YZQ8Wf1z/fOGJ/qKoOqe1VmJAz1xfoaaXTPpPkJI8eT22gNMRy1yxEGYkWZWaH7dH0Qow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4419.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(54906003)(38070700005)(110136005)(316002)(4326008)(76116006)(66946007)(7696005)(186003)(6636002)(8676002)(478600001)(38100700002)(8936002)(55236004)(66476007)(55016002)(66556008)(64756008)(66446008)(5660300002)(83380400001)(52536014)(122000001)(26005)(33656002)(86362001)(9686003)(6506007)(53546011)(2906002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0G35y3bGceNQK2M+Mi8kA11Or2dmlMP+1fNIYFXwE/tbXj+tWpT83T5Sj2t5?=
 =?us-ascii?Q?PiiYIQOKBO+S5OoEnJDMa2L7w8NTJEpTfe5PJFVcudX6IMwDXo1tmpuzmzAW?=
 =?us-ascii?Q?pLRsk+3IvKYgobSnJBzli/Un0ZIwUYz/zVv2sagjuwQThXrJTZtj4Ee4g/Ia?=
 =?us-ascii?Q?kTu3dOi1qVD2/j96KuCzKJXnBG3cwUq2POjiyfO1JuLBNZPfJGLs7P+FdcUv?=
 =?us-ascii?Q?DdvyRZfyrwBeySgMP2ipSpxFNgIl70+oBca50D/wh8y/0RDMS5LckIHMElJf?=
 =?us-ascii?Q?KqKwMaZpMnsB1mJpbw/ZHwQnlSuIJZgMAGcEEe+z09/UID1IVrczcFEzyAPt?=
 =?us-ascii?Q?GzWw3Bx1owgqVuRUQZnICcUblCDE+FQFlgWLKlF4mniBdvwdVrzgWJqO6Eiw?=
 =?us-ascii?Q?hBh+fLqS7LJaMYMo9Jj76EZa+t+sTvQXT96veovw83rFIOegVnc8qAQA8uxZ?=
 =?us-ascii?Q?GcpZxpQMrhjRipBLTQN1DWwl7j+cQiVIIBDOb/yeb+9lPccuBQcAIjF72HCb?=
 =?us-ascii?Q?i7AsaMXxkifH3uAlsB+YDiCkB6/bpxdMjmnJWuL3kAIy2PUQquaeQPdqYH/g?=
 =?us-ascii?Q?Y7zqFLTz1NH/oPOt/PQzid/TqyWugxz61tyUwJn6ffTTAu6wmBgUxOyF9q4J?=
 =?us-ascii?Q?fzcN13jw1yYBZDYi1HPnnb2v2FkGRm89HBy87wMPKNro5D4r30bPiSqj0aG/?=
 =?us-ascii?Q?WwT0El6RVc5mQYaDuIk7mVJ6sSOxRbqagdzZ526QzwNZpSO4m171NM6jAoBz?=
 =?us-ascii?Q?IDyRCOTUYHtYFyhLha1T8EONXw4Ukg3sbTBcoZ+Oxygby0+x9CHbMyczrMg4?=
 =?us-ascii?Q?xmFIXNkDONCpkk3RBQFdGnoDAw/N1yhzcQq7ZhEGtn2i+oQhJCJKmE0EyZxo?=
 =?us-ascii?Q?C5WGLw+Y9QYlqMAPJtQsirLenN4fidXz8eHpN8yQ9CJN9kUwo+ZOye+ke8Aj?=
 =?us-ascii?Q?dorjo3jNwRQk6kouoPmBXWtgBgud8AkObPDN5m/XNQFFbLz2tsHPcn+53kdb?=
 =?us-ascii?Q?ITZ4o68XuG40zb8YsRdW1ab7q7oXBflg5gr4tyluAHMGeECM4iyXTRhte3p9?=
 =?us-ascii?Q?OaPtW7/8C2TaagPaqQGldiyoLx9r/QZ+2Hik0VbGlehLQDVBlNy36n2FDASM?=
 =?us-ascii?Q?68glXj9kGXgZRZxwnAwYSaV3xpszO6wNJkZd7t8DlLq2uXj2zXFcl/zVA/9m?=
 =?us-ascii?Q?CvVEGeJd+JgRBN0XH7q6fioqtynd5JIsXitSbHtX8RF5jwMsQAeGJIj3vMQH?=
 =?us-ascii?Q?530s+n5KPfDdC+qojr9JBoC63JsO/5tMRdanYnTPrbymDeiojQYj/oZ7no/d?=
 =?us-ascii?Q?6kCmEp3eeKkXeSOW//Zi3CAk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4419.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 508a897c-e3bf-4b8a-b1ed-08d95e36f42b
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2021 08:47:16.4467
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jmLrZZoZPIAnUmEWk1XTKQNlupwdTlVm1VMLqAPLtNYnlyayLjqh0BnatKAqGA0IGVkK4tnB3jfKvFmGrO2ONA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4484
X-Proofpoint-GUID: z_2I3GzlXQPMpN2YcbH9oloCaqRxRkXU
X-Proofpoint-ORIG-GUID: N8E5sAAVI03daoCshgBD-RkzHZi9iYHM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Tuesday, August 10, 2021 2:18 PM
> To: Nilesh Javali <njavali@marvell.com>; Manish Rangankar
> <manish.rangankar@cavium.com>
> Cc: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; James E.J. Bottomley <jejb@linux.ibm.com>; Martin
> K. Petersen <martin.petersen@oracle.com>; Hannes Reinecke <hare@suse.de>;
> Arun Easi <arun.easi@cavium.com>; Adheer Chandravanshi
> <adheer.chandravanshi@qlogic.com>; Johannes Thumshirn
> <jthumshirn@suse.de>; linux-scsi@vger.kernel.org; kernel-
> janitors@vger.kernel.org
> Subject: [EXT] [PATCH 1/2] scsi: qedi: Fix error codes in
> qedi_alloc_global_queues()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> This function had some left over code that returned 1 on error instead ne=
gative
> error codes.  Convert everything to use negative error codes.
> The caller treats all non-zero returns the same so this does not affect r=
un time.
>=20
> A couple places set "rc" instead of "status" so those error paths ended u=
p
> returning success by mistake.  Get rid of the "rc" variable and use "stat=
us"
> everywhere.
>=20
> Remove the bogus "status =3D 0" initialization, as a future proofing meas=
ure so the
> compiler will warn about uninitialized error codes.
>=20
> Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI drive=
r
> framework.")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/qedi/qedi_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.=
c index
> 0b0acb827071..e6dc0b495a82 100644
> --- a/drivers/scsi/qedi/qedi_main.c
> +++ b/drivers/scsi/qedi/qedi_main.c
> @@ -1621,7 +1621,7 @@ static int qedi_alloc_global_queues(struct qedi_ctx
> *qedi)  {
>  	u32 *list;
>  	int i;
> -	int status =3D 0, rc;
> +	int status;
>  	u32 *pbl;
>  	dma_addr_t page;
>  	int num_pages;
> @@ -1632,14 +1632,14 @@ static int qedi_alloc_global_queues(struct qedi_c=
tx
> *qedi)
>  	 */
>  	if (!qedi->num_queues) {
>  		QEDI_ERR(&qedi->dbg_ctx, "No MSI-X vectors available!\n");
> -		return 1;
> +		return -ENOMEM;
>  	}
>=20
>  	/* Make sure we allocated the PBL that will contain the physical
>  	 * addresses of our queues
>  	 */
>  	if (!qedi->p_cpuq) {
> -		status =3D 1;
> +		status =3D -EINVAL;
>  		goto mem_alloc_failure;
>  	}
>=20
> @@ -1654,13 +1654,13 @@ static int qedi_alloc_global_queues(struct qedi_c=
tx
> *qedi)
>  		  "qedi->global_queues=3D%p.\n", qedi->global_queues);
>=20
>  	/* Allocate DMA coherent buffers for BDQ */
> -	rc =3D qedi_alloc_bdq(qedi);
> -	if (rc)
> +	status =3D qedi_alloc_bdq(qedi);
> +	if (status)
>  		goto mem_alloc_failure;
>=20
>  	/* Allocate DMA coherent buffers for NVM_ISCSI_CFG */
> -	rc =3D qedi_alloc_nvm_iscsi_cfg(qedi);
> -	if (rc)
> +	status =3D qedi_alloc_nvm_iscsi_cfg(qedi);
> +	if (status)
>  		goto mem_alloc_failure;
>=20
>  	/* Allocate a CQ and an associated PBL for each MSI-X
> --
> 2.20.1

Thanks,
Acked-by: Manish Rangankar <mrangankar@marvell.com>
