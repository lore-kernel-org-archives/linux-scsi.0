Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0C7C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E707613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 17:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbhDVRXM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 13:23:12 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59730 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236287AbhDVRXL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Apr 2021 13:23:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHIvZX071796;
        Thu, 22 Apr 2021 17:22:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Wm9/CmiZgVEtHeMt3khnWQ7RGQSWetYYcc36N3LVpKA=;
 b=cFl3kOOkCMS83RDwJMLpnqz3hvaqbsSmOlNE7uz9nbTLel39kHGfncGSJgW92HJKNrel
 HlHfWeL5KcRjqZdg0biUksSNCIjOGkRl6SIXoAjZUEzCYBUKAyICWdZhPxRYPZMJew+I
 3oCwE/HSVDc1NoSvViWFDrHeG8kN/aC58ylHH6FvlUwb7Fj3IgTNzYBleQcp7uYQVCka
 iVIYZ4aPaaqSu5lc5+XbBd6AOB7fGXMFnv1VN/2jSdkvs40Fx7VHcGeBAMXiAZwMRr7k
 A0rFuKtqAZrCrm3mwnQfGWJNmTDW2IFW9h9QCgT/9owDe+IgdjmV8HI83EvF6KY+vVhg YQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 37yqmnp5vq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:22:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13MHLMkh052292;
        Thu, 22 Apr 2021 17:22:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by aserp3020.oracle.com with ESMTP id 383cbd3cmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 17:22:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J4oHkTJJyiahXsbYPkdtMSVKQgpvQaoQpewuxr8ivjuOPJDK/xNcaF0RX2iH0qakwHG4V7U/gzpea9lziRGcOHPwRUZWooGcOdB932+xIoDtv/0EkmR2JQ9cTlr67d8Gnv12zSLyNfoS6uxG8JxiyudLHIgq6E0qpXKsF4CLmb4EfQCjXeX1v2MDo2Cky5a9uPak2Np33j+11NesKRcmnG+nhB0bOa1hmce64vmx+vBSQeiWWYUQSJfMgynolRKMLm1X7O8YA0RzuAdP3knT46ZB0MDSHJSUeLsK5hqqtouJN5xwqGDridJO7MbkYWCHVJCwgL2HlwKPz7FlK33ZaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wm9/CmiZgVEtHeMt3khnWQ7RGQSWetYYcc36N3LVpKA=;
 b=mealzVPgSeZTkp1mtpbN1ErNLslddFGRuuJ8vQdez6jX0gK2tvqRxcpVzqRtIOZT0y/d6PK3kV6GUEyfWr9KcGV1+E1kco3gkCF3JHXmIvpn7KJNt0Wtqo5m4Oatd6jT1zGvPiaYcaY7+OSGkMHR4oPWRnl4YfRhYIsosmi2RfFGJNkzSeaBFYUboWZmNUi0jSLCqVadOC3aCj9t4Y5FBZgcUEMjnxqdwFySYhaZwE0trwETwZspVHtOtDo09KtiQHQ5aHWJMUDp8KSkFnIlUK2Cr2KbPasfNOGnVOjc5+jL38iDGkCOYicGqr0znD9mHMfTrxwpxUIpKR1SKXdYsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wm9/CmiZgVEtHeMt3khnWQ7RGQSWetYYcc36N3LVpKA=;
 b=kqGJTmdkAlcjdumcmnkhOH/cqPxM6+cFMH/vgAmwac/9RQn8JpdEL3DeQDpqakHmTOMgTIaEirk88MYdD57gAhz9GImddk3I3EDIkUieaxhqn4qkDHfzpWf4dz7GUHCnEHpf0s7p4EZub2jag6u8b34JZXZS7KYjqdEN/Ieu94g=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2768.namprd10.prod.outlook.com (2603:10b6:805:4a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Thu, 22 Apr
 2021 17:22:31 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 17:22:31 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 20/24] mpi3mr: wait for pending IO completions upon
 detection of VD IO timeout
Thread-Topic: [PATCH v3 20/24] mpi3mr: wait for pending IO completions upon
 detection of VD IO timeout
Thread-Index: AQHXNQuU8wAg25jqNkaYBFvLFbJVnarAzg+A
Date:   Thu, 22 Apr 2021 17:22:31 +0000
Message-ID: <BB123E3C-71C1-443C-99D0-269F6196B86B@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-21-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-21-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f787b8f0-1fb2-410a-d5bc-08d905b3364a
x-ms-traffictypediagnostic: SN6PR10MB2768:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB27680B7705B1438BFE06CFD1E6469@SN6PR10MB2768.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:159;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iE2FVpNz+VrCqLaLwoV9Utg4xChjwqfoK5002lhKlXcb2C7X/yZEcGDkTXzCj3GrqnLHN/tVLHbDipYFWB3iLHrQZBePgL0gQDHXscLiAGpLha9idog2Di2jHfY2gipiNNv0iGGirTpj7LmePVtebydEWSqEBcx305bf2/ogwjAR59VVEYEmnZN8qyVOjhFVW1Y5/KvNvgdGHnPsRIRvcRfZ1/VYopXp7MXBDBJkStQ4QNDUMghAr7WUFdvt09Ku3WL9l7a+cGOqEnfjAsbnvKRznjvfAMTpWX+7h3gRXfakyOaBqZnSMSnH8mVOEThe3MlWUZ/CCq9txlksGWq1GgDtqKxTDB0jwGsRCrhswMlnEN8+pdTAoSUQEnF0GYFVh2MB5MtHwuWbSVOHIlDc090NWAGyIFs7hOH72biYn/W3bh5ec4AePq48IXU6xDCP6tTl1oeALnOPz2EcPq1Gl7HgzebTdKBv0an+DxSh1QoRrgl4IbEzWzACpQq01xHAICW5S9U0mtSK4lVOmHAq2tJg5yMo1eJRjrfrXvAAf2oCQ9I8g5r4uz7R9JHO3Pl38EfPHdUjuBr7LZigdWy9ZTxIYl4idwxmMG6AlbaUKyp3yDzTceNLXs+cFZj08tINASwteiWHwAdvAIHDOritPIG8Xxi8jkHfCEU0Co/UGeVLYWbeWRg0MmhWU50kzFcQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(39860400002)(396003)(366004)(2906002)(2616005)(83380400001)(186003)(86362001)(33656002)(76116006)(44832011)(38100700002)(478600001)(122000001)(26005)(6512007)(6506007)(8676002)(316002)(64756008)(53546011)(54906003)(71200400001)(66476007)(66946007)(4326008)(66446008)(6916009)(8936002)(66556008)(36756003)(6486002)(5660300002)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?S2CigFB1loT+21rvDvxzGQoorRTdjshX0HF4OAN+PJJJC0b7PbQG9cHVFXb/?=
 =?us-ascii?Q?a3DIbiiyYKYKHlBRhbK+E9jDnXH9ZcVpJBmkHDEejg0eG6chJd3QV+Sla2AH?=
 =?us-ascii?Q?Yb/yGeTG1iEsBKGHJwxP2sBTCrX2xCy5PbRHwxCz4Qs+hReyiPLs8y6Wvwfe?=
 =?us-ascii?Q?+Z8dLGLbaw4yf8Xqkw7opOalSB+kWhoXy0pU3csAQJnTk1hGhFSM2XCYsk0C?=
 =?us-ascii?Q?yPTfwEDUbJq65HHwgEBHhe3kCBXrUeyUqLTpBSsrr4WVx7yFKVb0aguZ0tVf?=
 =?us-ascii?Q?DysCnyE4038zbO9YTsX78zYx7PEjC5f5LRrbOoMHK0M4qRzm4OZPDaC1IhKb?=
 =?us-ascii?Q?509Sxl/wZ7FcLsyNpDpMNhNdjLabADZ/dy7vKQJb4/+bM9uKIpFKO+PvdmZd?=
 =?us-ascii?Q?Tf67mvywlWhm8MVXZKZWYTCSG0Ml7Yq0iHiOgD61cGudVSbyhfsdjB4smTWW?=
 =?us-ascii?Q?/j6mXJKjuXEimpRctxcFZFRgKfI15NuMF45DpJ2tM6EuSnVW/9q5rBbFQyP5?=
 =?us-ascii?Q?2fWuDS6hrFOWnIsexk7LApnwStzh7+jH6baK4ZGg5ci/peS8diFTuVhA8gls?=
 =?us-ascii?Q?3PlUaIlDMlpBMwuKdauAQi0udiijmw8qN7DEmn8hkPicn+Fx7hCkNME39Sxg?=
 =?us-ascii?Q?Mvyo2qqNHAIhmt7trubswX4Y3vT7krRGXjBQO0DiNvePFOY5xQ0fR6uVQ1CP?=
 =?us-ascii?Q?Ea5xraAFnh0hr10S/SFQuc511QYgRbgI+wBz4iGw/Ua9ffyfGSP4ah2RtDSn?=
 =?us-ascii?Q?KSW7EJkTrx4b7BteE4kPLRiv7lXLSC2yLgkpAb2QfjI5v4xkipRdCwsDwP8M?=
 =?us-ascii?Q?VOyylmyXuHxEdS82Lz1ge1QsF5597hcXmL4Bh+Ay5wuOKM4HBDYEeKsAoiE9?=
 =?us-ascii?Q?0pkxez2uspBQm+ps5NaqWVL18/1OMsiXkn/R5OYdK9Lmyc69TfsptTpZSi2g?=
 =?us-ascii?Q?iFnpz8uf7t5b4WezcOD/yRDc1jtVdNIN79nruXLJsrOEKqMa9b8RLCSyBPgM?=
 =?us-ascii?Q?xUNaJuI9lhKj1xNexkUnvlvvHCrWbQNxt+k0NFppy957GiQz3EzU3T+BDgex?=
 =?us-ascii?Q?3IBchJ5rVcz9aJ7PJbv9dKpu0qvuPNLS2aavOTK4aCRoMcPzNSweJg02Mye4?=
 =?us-ascii?Q?9uReDBb3wqstkb4FloY73FOQLmii63sC5J8Si/7gRSLA4xDYW4YrYPJH/uGm?=
 =?us-ascii?Q?I+kgvrCTVJrECAsqz+3URmGF0UAFjjHxtCPPHx/aDHlrcVqYwP5FOLwAQu/v?=
 =?us-ascii?Q?oq2l9S4QAffnbnrlJiEyJ30S0Ik/vtTd3aqEr43XUe0YpHREyoyH9XNuf5WE?=
 =?us-ascii?Q?XGRKaA3uAWq9aE7lFE23S2vWB0IuOftCV4tf4IA7Dgb4rg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4B2DD249DF3F804AB7A438D27DC649EA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f787b8f0-1fb2-410a-d5bc-08d905b3364a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 17:22:31.7155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RnhE9nl9LnreHAQS4RVkLlDH6/2uwivsDvsdWSr6uLBAKE74sPR5T6PVqIf4MvKJpMJdHPNPiy5beEuySZ9wM1J0uTyViSlk3PFUC1ZT4UU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2768
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220130
X-Proofpoint-ORIG-GUID: H-ayeTqsxaYGR67cOGL9jGyFwIL7ur-7
X-Proofpoint-GUID: H-ayeTqsxaYGR67cOGL9jGyFwIL7ur-7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9962 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 impostorscore=0 spamscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104220130
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Wait for (default 180 seconds) host IO completion if IO timeout is detect=
ed
> on VDs
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr.h    |  1 +
> drivers/scsi/mpi3mr/mpi3mr_fw.c |  2 ++
> drivers/scsi/mpi3mr/mpi3mr_os.c | 53 +++++++++++++++++++++++++++++++++
> 3 files changed, 56 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index ff3e68a6d0b5..505df0e7b852 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -102,6 +102,7 @@ extern struct list_head mrioc_list;
> #define MPI3MR_RESET_HOST_IOWAIT_TIMEOUT	5
> #define MPI3MR_TSUPDATE_INTERVAL		900
> #define MPI3MR_DEFAULT_SHUTDOWN_TIME		120
> +#define	MPI3MR_RAID_ERRREC_RESET_TIMEOUT	180
>=20
> #define MPI3MR_WATCHDOG_INTERVAL		1000 /* in milli seconds */
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index bb1d2c45e903..488fc3eac9dc 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -3779,6 +3779,8 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mr=
ioc,
> 		}
> 	}
>=20
> +	mpi3mr_wait_for_host_io(mrioc, MPI3MR_RESET_HOST_IOWAIT_TIMEOUT);
> +
> 	mpi3mr_ioc_disable_intr(mrioc);
>=20
> 	if (snapdump) {
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index 56f1e59e86cc..ccee3e7359ec 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2435,6 +2435,43 @@ static void mpi3mr_print_pending_host_io(struct mp=
i3mr_ioc *mrioc)
> 	    mpi3mr_print_scmd, (void *)mrioc);
> }
>=20
> +/**
> + * mpi3mr_wait_for_host_io - block for I/Os to complete
> + * @mrioc: Adapter instance reference
> + * @timeout: time out in seconds
> + * Waits for pending I/Os for the given adapter to complete or
> + * to hit the timeout.
> + *
> + * Return: Nothing
> + */
> +void mpi3mr_wait_for_host_io(struct mpi3mr_ioc *mrioc, u32 timeout)
> +{
> +	enum mpi3mr_iocstate iocstate;
> +	int i =3D 0;
> +
> +	iocstate =3D mpi3mr_get_iocstate(mrioc);
> +	if (iocstate !=3D MRIOC_STATE_READY)
> +		return;
> +
> +	if (!mpi3mr_get_fw_pending_ios(mrioc))
> +		return;
> +	ioc_info(mrioc,
> +	    "%s :Waiting for %d seconds prior to reset for %d I/O\n",
> +	    __func__, timeout, mpi3mr_get_fw_pending_ios(mrioc));
> +
> +	for (i =3D 0; i < timeout; i++) {
> +		if (!mpi3mr_get_fw_pending_ios(mrioc))
> +			break;
> +		iocstate =3D mpi3mr_get_iocstate(mrioc);
> +		if (iocstate !=3D MRIOC_STATE_READY)
> +			break;
> +		msleep(1000);
> +	}
> +
> +	ioc_info(mrioc, "%s :Pending I/Os after wait is: %d\n", __func__,
> +	    mpi3mr_get_fw_pending_ios(mrioc));
> +}
> +
> /**
>  * mpi3mr_eh_host_reset - Host reset error handling callback
>  * @scmd: SCSI command reference
> @@ -2449,9 +2486,25 @@ static void mpi3mr_print_pending_host_io(struct mp=
i3mr_ioc *mrioc)
> static int mpi3mr_eh_host_reset(struct scsi_cmnd *scmd)
> {
> 	struct mpi3mr_ioc *mrioc =3D shost_priv(scmd->device->host);
> +	struct mpi3mr_stgt_priv_data *stgt_priv_data;
> +	struct mpi3mr_sdev_priv_data *sdev_priv_data;
> +	u8 dev_type =3D MPI3_DEVICE_DEVFORM_VD;
> 	int retval =3D FAILED, ret;
>=20
> +	sdev_priv_data =3D scmd->device->hostdata;
> +	if (sdev_priv_data && sdev_priv_data->tgt_priv_data) {
> +		stgt_priv_data =3D sdev_priv_data->tgt_priv_data;
> +		dev_type =3D stgt_priv_data->dev_type;
> +	}
>=20
> +	if (dev_type =3D=3D MPI3_DEVICE_DEVFORM_VD) {
> +		mpi3mr_wait_for_host_io(mrioc,
> +		    MPI3MR_RAID_ERRREC_RESET_TIMEOUT);
> +		if (!mpi3mr_get_fw_pending_ios(mrioc)) {
> +			retval =3D SUCCESS;
> +			goto out;
> +		}
> +	}
> 	mpi3mr_print_pending_host_io(mrioc);
> 	ret =3D mpi3mr_soft_reset_handler(mrioc,
> 	    MPI3MR_RESET_FROM_EH_HOS, 1);
> --=20
> 2.18.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

