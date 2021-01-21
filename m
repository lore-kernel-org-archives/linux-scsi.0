Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E5B1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:22:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 26222238D6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Jan 2021 06:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbhAUGVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Jan 2021 01:21:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16488 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727049AbhAUGU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Jan 2021 01:20:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10L6Apwm026321;
        Wed, 20 Jan 2021 22:20:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=PQl0hpNvSa6/+aObTxtQqfofQrbgh/8DUC3JGupjgQk=;
 b=YvEYzzA3BKvoMuGkW43iHspi8tWT4lcsdKbnwVzGUdGcPgynOAUivKyHc7smuoqS3Y/7
 /qxTeA7NElop+5KSiT3PhOB2/nOymzNUYeIReCBTuv1J6YAWMorIomAkiIP/396Zkzon
 gptIUnd0K0KYwbj8QIATPqaGp0qFTl1LJ9Un/o9H3GZ6BSFRTGD03CfBPQaAasW2vZlJ
 mSpAKJR9lgxV0KH1O9CLDOrAIRB8qKQQgTz4ESA0kXem/2gJRrUFIhY8daxqrq48Eq0M
 HAZUwbenmc272dKgNn/HrASn0Nez6Iz05MRUPS8BQHaHsOzSXT7KYfaJ/Gfl5+uBlkf7 Kg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3668p2w8de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 22:20:15 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 20 Jan
 2021 22:20:14 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 20 Jan 2021 22:20:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kFBKeael9JJ3SBYddtmpgF/fBr6NvPdl11upnk/FM9xuEDywBEtpfuMcWz646TPrurwSw6ePI2WibjVSpijX0oO+znuk9oj1+t2hdoUm9Jwdp0t2IhVWTPd4+wm084a9/uuG5F80bI2f3j2jNfEEGovwUE8ERNIjah+4+aHoZh6vwSNPglHmi8n/smufMbiQqIPaIn6pDB6LIk6feNSwSPZ6DlCTvCMt2T/isSkojJ2co2M6TCkIRFEhbPaxztAZsJYQla7pClduC8Di5IrrYnxI8MWZk59OnWpAmxJ+mYlbj39CgfWG4a5RDOrpTGVdbEj/yeCWKU8Na1e2nHz9RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQl0hpNvSa6/+aObTxtQqfofQrbgh/8DUC3JGupjgQk=;
 b=DZNUHs1ilxeQZCPRnbGsPYhFqF6QkIh+JZspg6OFlKLszdj/P0mXOTaIExwvARlOPV/GJBdafq43SfdPA+86HMj/hjz04znvtAf+BQaqjl8GUjZbrnCfgU/wRjTyx9qOiCxo3PcCjZYSb9H8v6L6RIBACYpcZLO895HJNh41FVA/daFjpb6JhNy8q9b+diT9OCSaU+vsKKAwrr3V4JKyu4wyeW12vqdI0Z+rWHF2HovbkIqjXURfJpGXbQRBspuyu365Fn2+MM20uT496DFsJCs4cw65Ql9LtPzUgaVPN5zZ7jyZmTruK04bSqElZZLFFlZbuENyqZMDQpdpbhKrJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PQl0hpNvSa6/+aObTxtQqfofQrbgh/8DUC3JGupjgQk=;
 b=ewk7iFOJiBVMoQYXRTC2L3XToONIW5D9vBvwqfODE03ugaupywMmhC6L7CGEHjq6IPwJGax+a+qbJkNSAUga19oxM4hfDIoAN6+GQzhhqWRtQWzQHT1dS/W49t96tYDGoao0ZJ+dW0HN3fw6AQfnaTZvkbMsgXonW58alZ+JtAs=
Received: from BN8PR18MB3025.namprd18.prod.outlook.com (2603:10b6:408:6d::30)
 by BN6PR18MB1138.namprd18.prod.outlook.com (2603:10b6:404:69::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.13; Thu, 21 Jan
 2021 06:20:12 +0000
Received: from BN8PR18MB3025.namprd18.prod.outlook.com
 ([fe80::a4c8:8998:fa0f:35e9]) by BN8PR18MB3025.namprd18.prod.outlook.com
 ([fe80::a4c8:8998:fa0f:35e9%3]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 06:20:12 +0000
From:   Saurav Kashyap <skashyap@marvell.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
CC:     GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH] scsi: qla2xxx: remove unnecessary NULL check
Thread-Topic: [PATCH] scsi: qla2xxx: remove unnecessary NULL check
Thread-Index: AQHW77wyMn19oZWOtUmoc3X3C4j9t6oxm0fw
Date:   Thu, 21 Jan 2021 06:20:12 +0000
Message-ID: <BN8PR18MB30253D9117CECA0D933FC772D2A11@BN8PR18MB3025.namprd18.prod.outlook.com>
References: <YAkaaSrhn1mFqyHy@mwanda>
In-Reply-To: <YAkaaSrhn1mFqyHy@mwanda>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [103.103.215.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5cf2cedc-6839-4900-3cf5-08d8bdd49c11
x-ms-traffictypediagnostic: BN6PR18MB1138:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR18MB11383AC1577C774D05BD62C9D2A11@BN6PR18MB1138.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:411;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SoyQwZPQk9Gs2zC+2bszxJN3nsE7OQdEsvI2SbN/QN3PxI3FSXm6Ur3Tfp7elFSB1/o1caznysz1a5Vo9vzkLI5VBsx7C72kyMpW9Vzq1u+clF7qMaKTj7ZwpRBo+soYxDwou4aHDtflD26r0ueGqQgVxHBYtupXdGoUEKUn+0uwehvQFcTPtJk4Dmk8+2+daSww4FqzOqkFYYwL6kLUO+Y5Zn8FNYuXL8JGTHCvHvs+1f5CcPRgk49OJJusOv1mwsYYpynMPYBVC4n2JTBFEECwWtqz2NLm/Z6yQO9fJLPOX7a62kLf72OKuELb2JzhYe3FqPrleY9IxnPBN50RrY7G2oNYSmM0GHgcSf9aU2FQmRKab+NalYJr+2/UMVckIj6Sl/x1Ugdo0iMo5VCdCCA+RYlQHPVqrTnZqVehw43PSr+PMRwl6WxsI1YStkJ7lbCqSA85uqZQHbe185GoCT/VmC45fNgkGvjYklt7UV1A/Nn5qQn2Z01+aMZNV9UqfmdDLUxyUul4sZf0LYQoTg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR18MB3025.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(9686003)(2906002)(6506007)(64756008)(52536014)(71200400001)(66446008)(66556008)(33656002)(5660300002)(8936002)(86362001)(76116006)(6636002)(26005)(66476007)(8676002)(4326008)(316002)(110136005)(478600001)(186003)(53546011)(83380400001)(7696005)(66946007)(55016002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9R+YkFZ7pJ7O2zqzfc4sA3rpcY2V7m3LGZ4XF/omxuy8cEw2HNhCNTeOgX/Z?=
 =?us-ascii?Q?wX97/INfIl7RZ0vfrSG9MiHoCxR63HU7Hwp9VaApioVY3M1slNIOhsxPYzBC?=
 =?us-ascii?Q?B4G2/EQBfxPezzrTVwzvPWty4y9bjvCJLQQF8ixqMSSk7eWGdKT6FdAOp5iV?=
 =?us-ascii?Q?gdOriwiNfKtcNqQRKXO+afgc5Og+rykz7h7vlHmEEI3JVi60dl5ad2+nxUEP?=
 =?us-ascii?Q?N/24s7wAYgT9RsEg0l2kOB/ust7sXGC1oqNGN1243otmedruKL0Z+Kh1/NvQ?=
 =?us-ascii?Q?TA2SnHh938kPnBPDRqhbyZWRNIWeGBzYqJ3lVcfztq054uSnZkUScdGmC68+?=
 =?us-ascii?Q?fyqrQoJwGjUpvZ6yG/bnCAqdVuZE5UxHRJnzfEcUslDuQuo4M9/yZPYbQTAk?=
 =?us-ascii?Q?OkosoO5RN92t7mupidGgKBFwsre3gLoqH119THRMVPoJv9lJtDsaWI/wTPmx?=
 =?us-ascii?Q?SXNGWr/+attu/uhMwU4rd0yAX0i0ZyIswg39Aiy1VvKLxTMYeUWB9JMCUuk4?=
 =?us-ascii?Q?7MnyDsS3jrbA2yQI6b1revRJd1ccIIy3b7bzj4L+Kx5VxeCU3xUzUoFzynNE?=
 =?us-ascii?Q?tBbj4g0euc79P56YW7LC1A2BH5iK4HGRavIe8lKtxOnORkSdZVu3uF+VH3tg?=
 =?us-ascii?Q?mHy59vWLD1tkcsAb42MV843/0fF+FCI6auM8DKd1hYUgZlRh+lL+6SNF/SlS?=
 =?us-ascii?Q?iyhhCaDvJNJS5vYLG5TX/3ogW11ugslZnJyHED0JWnr0DKvgr9t7cJ4WiV7x?=
 =?us-ascii?Q?oPmpraLNFpua6wpGDd9OOAVFF3YLbV3lZBYVX62OcLt534XgQ5+CfEsynokm?=
 =?us-ascii?Q?C7OuL4x0byZxYzrDfdDznXVCJG3Y8zbysJ72ndGkrDq+KlBhPnSTty3ZZXvK?=
 =?us-ascii?Q?5U88kOBAenkZvXDhY4HTuB/+5v4PEW8YTXBcbq3G59QJAo54Q+fOHdIkcSST?=
 =?us-ascii?Q?/HOThXfNfs0fTDj+zobxOXRlKugp8CgrzApnFDlF/Lk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR18MB3025.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cf2cedc-6839-4900-3cf5-08d8bdd49c11
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 06:20:12.0837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q3RGq7FRZh1ZtMLcPGvp/tor0Z4bIuRgO3QZIVw5Nox71OIr+wtyHeUplYYaT6exW457tN5iD1Jz64/yJ6jiPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR18MB1138
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_02:2021-01-20,2021-01-21 signatures=0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Dan,
Thanks for a patch.

> -----Original Message-----
> From: Dan Carpenter <dan.carpenter@oracle.com>
> Sent: Thursday, January 21, 2021 11:39 AM
> To: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream <GR-QLogic-Storage-
> Upstream@marvell.com>; James E.J. Bottomley <jejb@linux.ibm.com>; Martin
> K. Petersen <martin.petersen@oracle.com>; linux-scsi@vger.kernel.org;
> kernel-janitors@vger.kernel.org
> Subject: [PATCH] scsi: qla2xxx: remove unnecessary NULL check
>=20
> The list iterator can't be NULL so this check is not required.  Removing
> the check silences a Smatch warning about inconsistent NULL checking.
>=20
>     drivers/scsi/qla2xxx/qla_dfs.c:371 qla_dfs_tgt_counters_show()
>     error: we previously assumed 'fcport' could be null (see line 372)
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/scsi/qla2xxx/qla_dfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_df=
s.c
> index ccce0eab844e..85bd0e468d43 100644
> --- a/drivers/scsi/qla2xxx/qla_dfs.c
> +++ b/drivers/scsi/qla2xxx/qla_dfs.c
> @@ -369,7 +369,7 @@ qla_dfs_tgt_counters_show(struct seq_file *s, void
> *unused)
>  	seq_puts(s, "\n");
>=20
>  	list_for_each_entry(fcport, &vha->vp_fcports, list) {
> -		if (!fcport || !fcport->rport)
> +		if (!fcport->rport)
>  			continue;
>=20
>  		seq_printf(s, "Target Num =3D %7d Link Down Count =3D %14lld\n",

Acked-by: Saurav Kashyap <skashyap@marvell.com"

Thanks,
~Saurav
> --
> 2.29.2



