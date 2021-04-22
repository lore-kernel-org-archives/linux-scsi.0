Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A580C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:48:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395C3613DE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 15:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbhDVPst (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 11:48:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40074 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVPst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 11:48:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFOuLw058739;
        Thu, 22 Apr 2021 15:48:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=j5bNo+bsC6M+95KsTRUWerTA95Hhm4UiXwizd9T2BIs=;
 b=xLehuZxLhtdectPAzKc/cHU6B+0pxX6RxpwUbVQidZG5G4cAFwxu0RwnGBx7fijAjYeH
 b3+nkdDLR7bb6vAb/afJV7Pwuhq2mZyhY0vPZ4KUNtcrbWSv8wXHtSkSiHc54dv/AcKI
 3HDyFMkLRmdQ5azTINe+Y71RzPcyvnlUd0XcubLkTjwIoFBDOph47ODd1Yua8Po1+7EC
 hl9SnEN/jBcvGWJBj3PwZUOv9Ty289dc+KzrqKv4r6ybExLZJ6U1cdmpJ8oV+uNs+GYM
 XpUXawOzYrcVngO2q6asoVZ3tWmGTdagZAxBv91N5yOocdXgdX80mGQ6mRNj7IHcMUDv QA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 37yqmnnvh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 15:48:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MFOvnC029146;
        Thu, 22 Apr 2021 15:48:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by userp3030.oracle.com with ESMTP id 3809m2fxsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 15:48:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GdEDqCOq8ySwDFTdqWhGmM1Y01DPeZVx9mA0wBdQf7Z2E8ydd63ZwzoQTioAL/9mEGKfTESJOR4U5V2XN2wsZxbHWmZGvCHWmXW05BCAHcEKs/6RC50XesjaG9VoC8D5YYUEFGu3RP9zXcDFA8g1vLkSbjnulaq5nSHFYQNFCpmcjxYqB9vNuSMzdzGz6wsKnrK7MZpB5f37cD8Q1DS2FsAhINzENfxBmA+G6g1zdElADHCPrbBqoyhyCdjPD64kyoW4HFPF1g5z8U9x4fuxh4C3MjYhmhmwL1mPrOVLvAxC+5eyCtmqN40OCLTPrWRConnLKuPD0owc63L73ZeATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5bNo+bsC6M+95KsTRUWerTA95Hhm4UiXwizd9T2BIs=;
 b=WKGZe8uXFGclIhykRnMYwK5mB6K9kf62tJC2hkLubnwRj+lCSj+xYNegFl/SLK0q+mvB3keKKGo9fCoVLs/pxzVbNyi5BMzbARIOl9eVtnYUTMfDIaGxynYXkdLg9APFGmyDgyKA7wAWKFOLlILx7ERK4Snm1pyQMU2OnSTUrIIs0lxGGUc2TA+yKDzldcOFxCc7PcBTANfoo9XmdBpXTnzqWtm+h0FVEZUUSzgDLtz7Ws7VgiCBhVG6nL/xx7hBbWdpPAzZEU/Nil2ycruqL+/2fKVuGvNr0HpR13q7R26zGaTVXYa7LKPXFVNhYcsiVLEyyvbgqOn8/WIxIqaFjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5bNo+bsC6M+95KsTRUWerTA95Hhm4UiXwizd9T2BIs=;
 b=NqILAGPDq6zidmaeWhDT31KcB3m61nyehWFcQv8tjgLj+6pEj1zgbUV/Or6h4XNWz3uHITUi3FFnBcku9RNtSAGC2jOFiOFcBBmCbNZdh9JIKschiZ+SisEOlYcRuId1c3fzQw5IKuY3cEsAop45nEUcKJG1qKcfvJPjeWA0OyM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 22 Apr
 2021 15:48:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 15:48:08 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 14/24] mpi3mr: add change queue depth support
Thread-Topic: [PATCH v3 14/24] mpi3mr: add change queue depth support
Thread-Index: AQHXNQuT6WPu06Cb9UadTA0VTddXearAs6+A
Date:   Thu, 22 Apr 2021 15:48:08 +0000
Message-ID: <E4CFC470-8C27-49E9-B2ED-B3FF624061F8@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-15-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-15-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d8a8517-6f70-4459-03ff-08d905a6068e
x-ms-traffictypediagnostic: SA2PR10MB4506:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB4506C46F217B75DD83B07484E6469@SA2PR10MB4506.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:79;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2dIy0JHNcPqz2LKKkkn8xRAVU0FqqyvulL/LSnrIy9MLWcqioCeH7O17+7ZUje01g2pjF24MzmKIMmwvpig85nN2IfUz51/L4osQNg4Sl2LIxl1Ocoayjf9qi6qBbYTv9XI16BfnOvujd653MknGPEZbGdXkfa1C322G71SsLCJOfKHgyOoFrnHpgjwcp2/Ly7yp1l4fkuRfW+B9WhShmHjcPb0NMY5z2QwLg6fg0YMXu+mdMmNM0aM2V5W2bsoEBS9bKlSRs4UvDDqS5hqc2hkGIuj/4UpQwrwJxigNIYdL517Ohb92wOGwHCxT5cQJ6p8Q0bGNtYiNui2eqSKRUnX0g6zFkRb5pJdPeNSDArVnuhJ7KGMmirQZzJat6FTsPIpVkGNC2m1aDegdHW+KqDBEc7nCbgkB6Qw4NgfQ+mxwqnfgZNLL7C8fCeVxyQYKHaRc3JRX++BjA5HWdebXsb1/BxTRh68Wc+WxZMyj8xTZo+PqZM/fM+UxVgy10i7rLXOTsVFz+u5B5L25exIegcyv8VBWzDxca5M1ZxUDZ6fuqPymFNdKdZgZmigMV40Mjt+bUwjhOAoXHJgnl0ocgm5YRSHBQMr1YFiQn6yitgZ01k7eGALs1zzxp0bnBy0EqVdyARRfmb/+o1o0UzKaPOyfRtU3s3Vs2yhtj2ppyEl55jMOQ584ll7VIeqs0DGd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(39860400002)(136003)(376002)(64756008)(66476007)(186003)(66556008)(66946007)(66446008)(122000001)(71200400001)(8936002)(38100700002)(2616005)(6506007)(8676002)(4326008)(316002)(2906002)(54906003)(76116006)(6486002)(6916009)(44832011)(6512007)(26005)(5660300002)(83380400001)(33656002)(478600001)(86362001)(53546011)(36756003)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4bljgg5nWDF317qHcZdjgy0fzYCgvPFRrKYXKTXLYZ9Ogn4L1gRFLFNnCm60?=
 =?us-ascii?Q?EXIsYRxDLbB+zTs5TiHHKUA8lSKRSLXWmd4TzZBvvojGGV9DGeI//wSWxlH+?=
 =?us-ascii?Q?hxrL/RuNSuo18+ga17GzzvUbvypsfVCEcAkcngyfC21D5QGPyy9ZZnh8qxlF?=
 =?us-ascii?Q?adZzwq7aWmUZYl6Qu7LIHUCE/Pgye2a5QAAxs/1mMScd35lR9gbKEdhjSwZH?=
 =?us-ascii?Q?e2Y4CDEcTqicAdYc8OoJW3G8CMKKV0RJAzZKlvFsNcPYYld78JrTdgKCGaE0?=
 =?us-ascii?Q?n8dMIhS/T2rVMhsf9Tq1lvXGgogHceCUdKp3HY3iZ22Lxr+5ykavJ4O+0u+7?=
 =?us-ascii?Q?Z7iiDgWngWZXHes/ndhMw4RdFZgYBiDhenKD56OF1zfCN82Md+ONyR8p6Gsn?=
 =?us-ascii?Q?tnSEQCLwKYDRGYxEcv88GfgXzQC5fAunAG2RLMaTX0YMfLvcZ/WR2CMi+E6q?=
 =?us-ascii?Q?XgC8nao3kWQbTD0Kb3MpOrbemS3l7q6mLqXOQcF/7aJrEGSzbawx3J9UMrvd?=
 =?us-ascii?Q?rPjZIXVUK93ic8HI6q0qe37CtFYTTFzbddlFzThubGT0XLy5GNp3XIqBCZXL?=
 =?us-ascii?Q?+6lXmSLdROzH9t304oYMffvRWIDPGDV+b705R1c9Uz0G9NOnFjdZf4MF95Ln?=
 =?us-ascii?Q?7SEOonXKm9nOZqYj5tqH/9wrIsTz3nOe0P3/W1mo9STnxISSxkxf0/d2yrLg?=
 =?us-ascii?Q?TTLN1L8Tdwr/m7U7g2N1vMrbTozYQyv0sbnEDU+EaeSXU90qxTfiKOtS9PJe?=
 =?us-ascii?Q?3yjJNuqnyYF2tAFLUPwJbeoRgJXoLa9eXKI4SSFCd1zCTHxrl8AxQ/tYjfs5?=
 =?us-ascii?Q?E5lcasqPggRN2J5FZNmmkVmNjCC+Qzf1CEHkcearCzzUxjIf6M/9JutNkVB5?=
 =?us-ascii?Q?4slkMYg3536akaAfFnZcchj2LHV9XP8IJd/7sPzYsL3uKvkklVmFUnNhjcjM?=
 =?us-ascii?Q?e5Or28Kx59RJpRBIUktCgC6TGpjJSVct9QS5KLrD/e9E/D4vS1NZ+gEbopcv?=
 =?us-ascii?Q?dk7j03CrFyM39OMgnZWdH+rY+V2AyfS0yy6PT1/btZ3i0q9Ja+z4jUhdYhWD?=
 =?us-ascii?Q?NTxVmYoDhA3k7rvtZo2LTxZxI0QIjTy3QPHhsJLPpfidGGL4gX0dmo2qW/rb?=
 =?us-ascii?Q?xXdUTFLv+/t1Yvp1FIAC3NurDq0skv3ULKCnAic4ZvsEDo0bAeGP1izB0BTm?=
 =?us-ascii?Q?T9r/xkRIoIHl4FpsPAdg0SSn1mWsjwixMnmDbggHYGOPM180yEb8RNp/ISDN?=
 =?us-ascii?Q?WsxmYzN/gdrrgf9d5KXFemLAUSkEA9whb3D0ZPACF7ozj7aiyKt+ogpjMNS+?=
 =?us-ascii?Q?t51cfzDZ3Uh9ZbzcN3vFkIXEcz+1sCZU0yGugeRHd6137g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D60FB6F9922ABB4DB3921D4B8EEB4F78@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d8a8517-6f70-4459-03ff-08d905a6068e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 15:48:08.1817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3rYhodgywKXKPRdTnHn8GhW/WFs2vZ7Pihk9rjIo04gw7F8ZmQSeFURTh2d0pAqMA/bFnLCmvQ+aLkRMzOu2Dlwu+9Twyw1waGmKyltw0Wg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 spamscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220121
X-Proofpoint-ORIG-GUID: inJVUMsOoqOrxnQSAd9pYMgLu5ocqzz6
X-Proofpoint-GUID: inJVUMsOoqOrxnQSAd9pYMgLu5ocqzz6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220121
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
> drivers/scsi/mpi3mr/mpi3mr.h    |  3 +++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 35 ++++++++++++++++++++++++++++++++-
> 2 files changed, 37 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index fe6c815b918a..e3ce54f877fa 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -141,6 +141,9 @@ extern struct list_head mrioc_list;
> /* Command retry count definitions */
> #define MPI3MR_DEV_RMHS_RETRY_COUNT 3
>=20
> +/* Default target device queue depth */
> +#define MPI3MR_DEFAULT_SDEV_QD	32
> +
> /* SGE Flag definition */
> #define MPI3MR_SGEFLAGS_SYSTEM_SIMPLE_END_OF_LIST \
> 	(MPI3_SGE_FLAGS_ELEMENT_TYPE_SIMPLE | MPI3_SGE_FLAGS_DLAS_SYSTEM | \
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index fd5fdc61169e..99a60e6777d5 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -649,6 +649,34 @@ static int mpi3mr_report_tgtdev_to_host(struct mpi3m=
r_ioc *mrioc,
> 	return retval;
> }
>=20
> +/**
> + * mpi3mr_change_queue_depth- Change QD callback handler
> + * @sdev: SCSI device reference
> + * @q_depth: Queue depth
> + *
> + * Validate and limit QD and call scsi_change_queue_depth.
> + *
> + * Return: return value of scsi_change_queue_depth
> + */
> +static int mpi3mr_change_queue_depth(struct scsi_device *sdev,
> +	int q_depth)
> +{
> +	struct scsi_target *starget =3D scsi_target(sdev);
> +	struct Scsi_Host *shost =3D dev_to_shost(&starget->dev);
> +	int retval =3D 0;
> +
> +	if (!sdev->tagged_supported)
> +		q_depth =3D 1;
> +	if (q_depth > shost->can_queue)
> +		q_depth =3D shost->can_queue;
> +	else if (!q_depth)
> +		q_depth =3D MPI3MR_DEFAULT_SDEV_QD;
> +	retval =3D scsi_change_queue_depth(sdev, q_depth);
> +
> +	return retval;
> +}
> +
> +
> /**
>  * mpi3mr_update_sdev - Update SCSI device information
>  * @sdev: SCSI device reference
> @@ -669,6 +697,7 @@ mpi3mr_update_sdev(struct scsi_device *sdev, void *da=
ta)
> 	if (!tgtdev)
> 		return;
>=20
> +	mpi3mr_change_queue_depth(sdev, tgtdev->q_depth);
> 	switch (tgtdev->dev_type) {
> 	case MPI3_DEVICE_DEVFORM_PCIE:
> 		/*The block layer hw sector size =3D 512*/
> @@ -2650,9 +2679,12 @@ static int mpi3mr_slave_configure(struct scsi_devi=
ce *sdev)
> 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
> 	tgt_dev =3D __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
> 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
> -	if (!tgt_dev)
> +	if (!tgt_dev) {
> +		mpi3mr_change_queue_depth(sdev, MPI3MR_DEFAULT_SDEV_QD);
> 		return retval;
> +	}
>=20
> +	mpi3mr_change_queue_depth(sdev, tgt_dev->q_depth);
> 	switch (tgt_dev->dev_type) {
> 	case MPI3_DEVICE_DEVFORM_PCIE:
> 		/*The block layer hw sector size =3D 512*/
> @@ -2892,6 +2924,7 @@ static struct scsi_host_template mpi3mr_driver_temp=
late =3D {
> 	.slave_destroy			=3D mpi3mr_slave_destroy,
> 	.scan_finished			=3D mpi3mr_scan_finished,
> 	.scan_start			=3D mpi3mr_scan_start,
> +	.change_queue_depth		=3D mpi3mr_change_queue_depth,
> 	.eh_device_reset_handler	=3D mpi3mr_eh_dev_reset,
> 	.eh_target_reset_handler	=3D mpi3mr_eh_target_reset,
> 	.eh_host_reset_handler		=3D mpi3mr_eh_host_reset,
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

