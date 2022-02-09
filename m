Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2EAC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:22:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231863AbiBISWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiBISWf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:22:35 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2279FC0613C9
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:22:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HURGi013354;
        Wed, 9 Feb 2022 18:22:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=yrPXRX4req6BVgzrc7cYHIG/3ZC6/ZZIuQaeUGXXFKc=;
 b=c6OmotBqN9RRybjogsWxVjXQ5m33/qFZJAb1CcYoxjyOYrRnFU6PCF75ndWgY4IaZ+aY
 G/GfEwYtOS5QM1zPSQwC8qecsjFoBXZrR1aZccp9DMXeJ2VxGxo0aUJ1ZrjeO/b+b9+5
 KpoqtWPOFEnj9ityOTgS8z/20stWulT8GlUfJsbkLJhR063OiRPXUUYBs5L79MD/cUAI
 Lk/v5GeStL1u35T1QGxsRjNuDOCpLPh1CsY6Tl9UauX5m2kPjuA7mmPFEb/LMmGOGDyN
 X2DsZnK0S/RqMiCZXwSvFGHwY//Fa8HT7vOC/3ehLvQezmP5iRQ8Xdxw7bXMoj63eJkj hA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txmpq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:22:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219I1rsL018848;
        Wed, 9 Feb 2022 18:22:18 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by userp3030.oracle.com with ESMTP id 3e1ec34ygd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:22:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4Mq18Eq9+JburJCL9zb7a4xxySZnme2Pg5FfIi7PKO4V3qAE3TU8Ta7Bc4AoWuaIgephJLQsFViwuvRmuLO7CPkjda1xI8u7a6o1pGIhg4JqqVs45jMfZISPkPJ61ztPKWHHejrXmG+jgYde+eKy9NDik1PmoPxOOnUIAkSLH0JQyqEEAkPvQkh+NWXvoHBrAxat7PcUlSAq8PXjpneb+TWj1OMXfvSmThQTfYe07IYgBxLQdFOaU7Z9Lm8mijgKHqbwGutB9tHrjuV7QJZdNb7kyuPOR4UrLngLNeM/i0pFYA3vKyihkbM2VbMpiWWe+oEyC3uHacaoI1/UEb9YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yrPXRX4req6BVgzrc7cYHIG/3ZC6/ZZIuQaeUGXXFKc=;
 b=jqaBvEvNpAdF5uAp2PDcID0L0MAOi3qkaDATU1T5UcHdHHa1kuDTy7XsxVS4dJ6D33I0XIvjgFR3kDxocLpcCqYKLJnzVb3rtdar3szoOAZGmdHft0liPSQmkZ1qOiwAKx1J/Eb1QtqvK3OwfFHH9ROPHaJf8Vzx7pYlEV8rLiGvq/TpHuhGCzehFkk1TRqC/d1bIMr2C6BG58i1/qgX/og6yWLoFRrtulFdX8n+4WfBiHxB7JMrawSKUpQK5BON3W/DGlRkVGZtlNxYI1FJHoYsI/njhVlH1EX96hx50uewlA9teWsKkgFW4YFZDoxeoWbEpRLNNRTCIWhoiexuYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yrPXRX4req6BVgzrc7cYHIG/3ZC6/ZZIuQaeUGXXFKc=;
 b=YIQHOrhlRBKft/OKD5e1UnNY4RkUrqMX3UBoSoOG9MrN4crsF4nMlV3MVlPjrWdaPzQm0cu2MvpWn/mxMLQHYWMO3kcldIZSqfxmPctCWXhf8t8R2VbrIoFhFHe6068oF90dmn044jXPuGz3tUE92ldTAxC57VfDHoTyWO0xuQM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DS7PR10MB5261.namprd10.prod.outlook.com (2603:10b6:5:3a0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Wed, 9 Feb
 2022 18:22:16 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:22:15 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Nilesh Javali <njavali@marvell.com>,
        Manish Rangankar <mrangankar@marvell.com>,
        Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 22/44] iscsi: Stop using the SCSI pointer
Thread-Index: AQHYHRE1vXrV6v5cCUOsFV2TyMD6j6yLicqA
Date:   Wed, 9 Feb 2022 18:22:15 +0000
Message-ID: <7D561B51-BA04-4EC9-B4EC-A93F9F882107@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-23-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-23-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a595e28-17b6-4328-bfac-08d9ebf9199c
x-ms-traffictypediagnostic: DS7PR10MB5261:EE_
x-microsoft-antispam-prvs: <DS7PR10MB5261D5D58388A7BE670E774CE62E9@DS7PR10MB5261.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rgc1xwHfF6aoQeRHHLZK5GipzKP3oOod4E5xqfEk4nF+TzHCm3FVrDaa+N8c+/CAPgZ7KMmxx4DJ7kML6k4P8PK6dYY2royGwEurm6uOhYw0GKtsL/CmtcZqJXoGihzplyvnXeqYCWpHWxSaQiF49ct/fYgwvLEXhZIRaZn6R4BvHIqgaZ3vjmKV1gocmm1buoGIJY9PQcL5sOmm2JFyhxt55bSWFC4seYrAAR4cH4Qwyz/jzgnw7prYygtRq/IOJKhpJzlBwppw8T+eS6yhBq+Q2DTPX8X7cm6Bn3qEUNW3bb+mmkEoVIxYI2V9o5v7vAxgCP1+Ms438X4r/ahKifs4erW/lPEOiemX28fo1FLiq7+tNZSj0ot44s6GxH+oy96zSji5mOf5WY4X/uo3a9GV85sgbP5TTkB0xuJ0ItWtLOmVzRPVwVhxRmBTV73an8EQq0vXlEjBw/vURsBn1/mCfmHnpEHLNmrrMB7fG4vXWmXtzsZ9BeCc4nethgVsOf22lKjj2KliISFbHcmsqLfH2SnltoYEQb2Lr9kpI3NHYYPmwUR86KsIkmCjHNJbrW4PkeeqEGQ3rf1banrK/BvoIDxGyJXEwxAMt8us+gp1WaANlxdn6tzUB9G99Ehj3huN+FxarMBsgCZCKHdYPfAeWx+cA1v9ir5/s4sxawqNXctxBdodwfNz91zLoG5+KFxoV+UUF6vu66pPYKHGEI8GR6VMsR5wSVsp9PgmY4Gai5xuDU9vMz/xAMFdJ9HE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(44832011)(5660300002)(122000001)(33656002)(66556008)(30864003)(4326008)(2616005)(53546011)(36756003)(38070700005)(71200400001)(2906002)(186003)(8676002)(6916009)(83380400001)(316002)(508600001)(91956017)(6486002)(66446008)(64756008)(66476007)(86362001)(38100700002)(8936002)(66946007)(54906003)(6512007)(6506007)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?knGR4Q+UmUipBspSOTmp2I+wZZ7Zf4a88GY67a2lvjdCHN0fDETbruuwAkzI?=
 =?us-ascii?Q?RgeEAyqVqHf6n6+iBJqSmXXDyBX+RBrx+qrMrtGZQtIlz3z1F6rOwoJ7kkIf?=
 =?us-ascii?Q?jL9E1h4Ef3zL+xbWDPQR47s0+sUHyTZSXl1n5aVjkkDwoT5kqpiHzlUTIDKF?=
 =?us-ascii?Q?WwpGddchTQHkUdVCDMJ3wkdThW26F2fDW2QU3gw+jRj2n5qWQ8MAPtQyNDmx?=
 =?us-ascii?Q?22Lmb2ruByWLETEnKXi3MxhQxOyI12IaKOqEuf6RbURdkUrg7bSex45RYTru?=
 =?us-ascii?Q?KIzZx1M4tgapUQ58UlG0VeLKRqd25XQA75ktxpidy/1RI/LLje3FZRFrc++v?=
 =?us-ascii?Q?A4PRZ+aJVilT5bSSONuUtyMTP15FucoRCpxcqAbUs5Df3Yrp7775cpGOfBa1?=
 =?us-ascii?Q?mlY6azcMF+wpkDEWRGeHbJ0qbbI/PdAfj1J6evWHQs37B9KYfZk1Qk6ce7pq?=
 =?us-ascii?Q?z/7dx+O7XcQ9W621Bqwd23F6ltRLAZuJLVMtMt9RXM05CarTMj+ttn4xB2Eu?=
 =?us-ascii?Q?7QQfn37FK0o4rfEo5HmSMH4FpAIC4N0l//yOxwtGGd1L4DBG8V7Z05ZXBxFY?=
 =?us-ascii?Q?bjRuS5c0/iUcmd6wcxKU+j4S4vQJm4SIzYtwHGC0UEX29KaVvE0o4H6RaM5A?=
 =?us-ascii?Q?U1qJFD+gATQBNvB/4QpA9qFXISkkMlTKoo9QHYWlFoMVo8+60SP7yWPrCU2N?=
 =?us-ascii?Q?mdfg7UOKBANs1kR39qx+5LwuvtFHZF/QeW6fat73VM0eEdrHvmOt637AReQZ?=
 =?us-ascii?Q?Rnn7fI9wCmMvVJsQL9KsOitjBKfWdOy51iOU8ndAIpL8XnPR/99cT4H8+g/F?=
 =?us-ascii?Q?Ak7bmNCMtt2Zh3q1nr/kYM9Hq3W7wuHqpMLPOXczOi1XWeRMlFx73rOgLU7O?=
 =?us-ascii?Q?3lEX5Wokg1+kWckgAC/krb+AIdaRceY/S1Mag5T7UhDrQl60D0VncH7Xy/yZ?=
 =?us-ascii?Q?TQ3csuy/OqOs1+YMg/QAMhNPIPoI2fIkZqSFkd+CzHsyvS1eZoMwcVcXi3f4?=
 =?us-ascii?Q?AZc4F7IZUt7mdZGvi18m/NA8HpFXZ3uhE/wvatHfcNcQAU2DI9uGjj2W8zFq?=
 =?us-ascii?Q?kZSq3JRF2Pe4oDBqHplpIbPApx3ZjGZv0YHlRI4LocDgXCXgARcekp31H5Ht?=
 =?us-ascii?Q?8/INOgCXTIcsP0Put8SiJSzQDZ/EatlIchFxwIQmtq+utRGHj6Zd/yuhgfm2?=
 =?us-ascii?Q?/YwmBPLInnEFTsR2JtS4SBHE8iu6UdLLkNcp08UWt3aht6Tq7RzSqbpB5DT+?=
 =?us-ascii?Q?FgolInEJT+kxHVfUy+8iF0y5S8tS/ZXjUB783K894LN/i7hFJAXf/EkzVY+D?=
 =?us-ascii?Q?fqKM5OmAMDzcXbBC2g7n4LWw9l/1KYpK1+psIjjVbfuvov7uY5J3OXPdUtVP?=
 =?us-ascii?Q?tkl9P0Ex1bUN744bYWLHhXkuk9jzrqxtbftfHkYPEVdSMXm0j0UscC+wnhaU?=
 =?us-ascii?Q?X2Ow4UaLM3y7g6iCC6wFHRlF3oRYb+dn6LlydFCADh+mM+bgTxQLL/hiQGli?=
 =?us-ascii?Q?xCFdaTM1lfHEVGEUKf8VwddzlgxSg+C2p3By1hV6jD9D2KK+9m7GRy/7TnRt?=
 =?us-ascii?Q?WpcFm5sbYywtk720Ji1bT2XDo0VjeLz4K0KWfJnDNPp0kSgBAvLerfbgQNwY?=
 =?us-ascii?Q?xPkD4g2dAOFu/kC976kVy67FO2Ey1QgdRQvkTb1UWqZiYwL/i1rXCDBru3wQ?=
 =?us-ascii?Q?H0HtzBy220rP493TH5F62R5nPPQkelLz+URwnN41scJQJcNv?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78510E845BC5A245B58F0059B89263AA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a595e28-17b6-4328-bfac-08d9ebf9199c
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:22:15.7941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p4p5ZU3dwbLs0Bm+eDXgmnfKoMxvHTfXJWRQ4t7cBw8ftK7DBrT942TUuPq1LaXqRr/Ig9Kef+mi2RPO73SZdSLG9SzkrL0+TB8e7DICUrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5261
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090097
X-Proofpoint-ORIG-GUID: weDifnYFsnWSY_PUcNjJqYqdxAXbnCQs
X-Proofpoint-GUID: weDifnYFsnWSY_PUcNjJqYqdxAXbnCQs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Instead of storing the iSCSI task pointer and the session age in the SCSI
> pointer, use command-private variables. This patch prepares for removal o=
f
> the SCSI pointer from struct scsi_cmnd.
>=20
> The list of iSCSI drivers has been obtained as follows:
> $ git grep -lw iscsi_host_alloc
> drivers/infiniband/ulp/iser/iscsi_iser.c
> drivers/scsi/be2iscsi/be_main.c
> drivers/scsi/bnx2i/bnx2i_iscsi.c
> drivers/scsi/cxgbi/libcxgbi.c
> drivers/scsi/iscsi_tcp.c
> drivers/scsi/libiscsi.c
> drivers/scsi/qedi/qedi_main.c
> drivers/scsi/qla4xxx/ql4_os.c
> include/scsi/libiscsi.h
>=20
> Note: it is not clear to me how the qla4xxx driver can work without this
> patch since it uses the scsi_cmnd::SCp.ptr member for two different
> purposes:
> - The qla4xxx driver uses this member to store a struct srb pointer.
> - libiscsi uses this member to store a struct iscsi_task pointer.
>=20
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Chris Leech <cleech@redhat.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Manish Rangankar <mrangankar@marvell.com>
> Cc: Karen Xie <kxie@chelsio.com>
> Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/infiniband/ulp/iser/iscsi_iser.c |  1 +
> drivers/scsi/be2iscsi/be_main.c          |  3 ++-
> drivers/scsi/bnx2i/bnx2i_iscsi.c         |  1 +
> drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  1 +
> drivers/scsi/cxgbi/cxgb4i/cxgb4i.c       |  1 +
> drivers/scsi/iscsi_tcp.c                 |  1 +
> drivers/scsi/libiscsi.c                  | 22 ++++++++++++----------
> drivers/scsi/qedi/qedi_fw.c              |  2 +-
> drivers/scsi/qedi/qedi_iscsi.c           |  1 +
> drivers/scsi/qla4xxx/ql4_def.h           | 13 ++++++++++---
> drivers/scsi/qla4xxx/ql4_os.c            | 13 +++++++------
> include/scsi/libiscsi.h                  | 12 ++++++++++++
> 12 files changed, 50 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniban=
d/ulp/iser/iscsi_iser.c
> index 07e47021a71f..f8d0bab4424c 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -971,6 +971,7 @@ static struct scsi_host_template iscsi_iser_sht =3D {
> 	.proc_name              =3D "iscsi_iser",
> 	.this_id                =3D -1,
> 	.track_queue_depth	=3D 1,
> +	.cmd_size		=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport iscsi_iser_transport =3D {
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_m=
ain.c
> index ab55681145f8..3bb0adefbe06 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -218,7 +218,7 @@ static char const *cqe_desc[] =3D {
>=20
> static int beiscsi_eh_abort(struct scsi_cmnd *sc)
> {
> -	struct iscsi_task *abrt_task =3D (struct iscsi_task *)sc->SCp.ptr;
> +	struct iscsi_task *abrt_task =3D iscsi_cmd(sc)->task;
> 	struct iscsi_cls_session *cls_session;
> 	struct beiscsi_io_task *abrt_io_task;
> 	struct beiscsi_conn *beiscsi_conn;
> @@ -403,6 +403,7 @@ static struct scsi_host_template beiscsi_sht =3D {
> 	.cmd_per_lun =3D BEISCSI_CMD_PER_LUN,
> 	.vendor_id =3D SCSI_NL_VID_TYPE_PCI | BE_VENDOR_ID,
> 	.track_queue_depth =3D 1,
> +	.cmd_size =3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct scsi_transport_template *beiscsi_scsi_transport;
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_=
iscsi.c
> index e21b053b4f3e..fe86fd61a995 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -2268,6 +2268,7 @@ static struct scsi_host_template bnx2i_host_templat=
e =3D {
> 	.sg_tablesize		=3D ISCSI_MAX_BDS_PER_CMD,
> 	.shost_groups		=3D bnx2i_dev_groups,
> 	.track_queue_depth	=3D 1,
> +	.cmd_size		=3D sizeof(struct iscsi_cmd),
> };
>=20
> struct iscsi_transport bnx2i_iscsi_transport =3D {
> diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb=
3i/cxgb3i.c
> index f949a4e00783..ff9d4287937a 100644
> --- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> +++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
> @@ -98,6 +98,7 @@ static struct scsi_host_template cxgb3i_host_template =
=3D {
> 	.dma_boundary	=3D PAGE_SIZE - 1,
> 	.this_id	=3D -1,
> 	.track_queue_depth =3D 1,
> +	.cmd_size	=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport cxgb3i_iscsi_transport =3D {
> diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb=
4i/cxgb4i.c
> index efb3e2b3398e..53d91bf9c12a 100644
> --- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> +++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
> @@ -116,6 +116,7 @@ static struct scsi_host_template cxgb4i_host_template=
 =3D {
> 	.dma_boundary	=3D PAGE_SIZE - 1,
> 	.this_id	=3D -1,
> 	.track_queue_depth =3D 1,
> +	.cmd_size	=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport cxgb4i_iscsi_transport =3D {
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 1bc37593c88f..9fee70d6434a 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -1007,6 +1007,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht =
=3D {
> 	.proc_name		=3D "iscsi_tcp",
> 	.this_id		=3D -1,
> 	.track_queue_depth	=3D 1,
> +	.cmd_size		=3D sizeof(struct iscsi_cmd),
> };
>=20
> static struct iscsi_transport iscsi_sw_tcp_transport =3D {
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 059dae8909ee..0337f7888ebe 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -462,7 +462,7 @@ static void iscsi_free_task(struct iscsi_task *task)
>=20
> 	if (sc) {
> 		/* SCSI eh reuses commands to verify us */
> -		sc->SCp.ptr =3D NULL;
> +		iscsi_cmd(sc)->task =3D NULL;
> 		/*
> 		 * queue command may call this to free the task, so
> 		 * it will decide how to return sc to scsi-ml.
> @@ -1344,10 +1344,10 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscs=
i_conn *conn, itt_t itt)
> 	if (!task || !task->sc)
> 		return NULL;
>=20
> -	if (task->sc->SCp.phase !=3D conn->session->age) {
> +	if (iscsi_cmd(task->sc)->age !=3D conn->session->age) {
> 		iscsi_session_printk(KERN_ERR, conn->session,
> 				  "task's session age %d, expected %d\n",
> -				  task->sc->SCp.phase, conn->session->age);
> +				  iscsi_cmd(task->sc)->age, conn->session->age);
> 		return NULL;
> 	}
>=20
> @@ -1645,8 +1645,8 @@ static inline struct iscsi_task *iscsi_alloc_task(s=
truct iscsi_conn *conn,
> 			 (void *) &task, sizeof(void *)))
> 		return NULL;
>=20
> -	sc->SCp.phase =3D conn->session->age;
> -	sc->SCp.ptr =3D (char *) task;
> +	iscsi_cmd(sc)->age =3D conn->session->age;
> +	iscsi_cmd(sc)->task =3D task;
>=20
> 	refcount_set(&task->refcount, 1);
> 	task->state =3D ISCSI_TASK_PENDING;
> @@ -1683,7 +1683,7 @@ int iscsi_queuecommand(struct Scsi_Host *host, stru=
ct scsi_cmnd *sc)
> 	struct iscsi_task *task =3D NULL;
>=20
> 	sc->result =3D 0;
> -	sc->SCp.ptr =3D NULL;
> +	iscsi_cmd(sc)->task =3D NULL;
>=20
> 	ihost =3D shost_priv(host);
>=20
> @@ -1997,7 +1997,7 @@ enum blk_eh_timer_return iscsi_eh_cmd_timed_out(str=
uct scsi_cmnd *sc)
>=20
> 	spin_lock_bh(&session->frwd_lock);
> 	spin_lock(&session->back_lock);
> -	task =3D (struct iscsi_task *)sc->SCp.ptr;
> +	task =3D iscsi_cmd(sc)->task;
> 	if (!task) {
> 		/*
> 		 * Raced with completion. Blk layer has taken ownership
> @@ -2260,7 +2260,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
> 	 * if session was ISCSI_STATE_IN_RECOVERY then we may not have
> 	 * got the command.
> 	 */
> -	if (!sc->SCp.ptr) {
> +	if (!iscsi_cmd(sc)->task) {
> 		ISCSI_DBG_EH(session, "sc never reached iscsi layer or "
> 				      "it completed.\n");
> 		spin_unlock_bh(&session->frwd_lock);
> @@ -2273,7 +2273,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
> 	 * then let the host reset code handle this
> 	 */
> 	if (!session->leadconn || session->state !=3D ISCSI_STATE_LOGGED_IN ||
> -	    sc->SCp.phase !=3D session->age) {
> +	    iscsi_cmd(sc)->age !=3D session->age) {
> 		spin_unlock_bh(&session->frwd_lock);
> 		mutex_unlock(&session->eh_mutex);
> 		ISCSI_DBG_EH(session, "failing abort due to dropped "
> @@ -2282,7 +2282,7 @@ int iscsi_eh_abort(struct scsi_cmnd *sc)
> 	}
>=20
> 	spin_lock(&session->back_lock);
> -	task =3D (struct iscsi_task *)sc->SCp.ptr;
> +	task =3D iscsi_cmd(sc)->task;
> 	if (!task || !task->sc) {
> 		/* task completed before time out */
> 		ISCSI_DBG_EH(session, "sc completed while abort in progress\n");
> @@ -2792,6 +2792,8 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host=
_template *sht,
> 	struct Scsi_Host *shost;
> 	struct iscsi_host *ihost;
>=20
> +	WARN_ON_ONCE(sht->cmd_size < sizeof(struct iscsi_cmd));
> +
> 	shost =3D scsi_host_alloc(sht, sizeof(struct iscsi_host) + dd_data_size)=
;
> 	if (!shost)
> 		return NULL;
> diff --git a/drivers/scsi/qedi/qedi_fw.c b/drivers/scsi/qedi/qedi_fw.c
> index 5916ed7662d5..d3170f2d023b 100644
> --- a/drivers/scsi/qedi/qedi_fw.c
> +++ b/drivers/scsi/qedi/qedi_fw.c
> @@ -603,7 +603,7 @@ static void qedi_scsi_completion(struct qedi_ctx *qed=
i,
> 		goto error;
> 	}
>=20
> -	if (!sc_cmd->SCp.ptr) {
> +	if (!iscsi_cmd(sc_cmd)->task) {
> 		QEDI_WARN(&qedi->dbg_ctx,
> 			  "SCp.ptr is NULL, returned in another context.\n");
> 		goto error;
> diff --git a/drivers/scsi/qedi/qedi_iscsi.c b/drivers/scsi/qedi/qedi_iscs=
i.c
> index 282ecb4e39bb..8196f89f404e 100644
> --- a/drivers/scsi/qedi/qedi_iscsi.c
> +++ b/drivers/scsi/qedi/qedi_iscsi.c
> @@ -59,6 +59,7 @@ struct scsi_host_template qedi_host_template =3D {
> 	.dma_boundary =3D QEDI_HW_DMA_BOUNDARY,
> 	.cmd_per_lun =3D 128,
> 	.shost_groups =3D qedi_shost_groups,
> +	.cmd_size =3D sizeof(struct iscsi_cmd),
> };
>=20
> static void qedi_conn_free_login_resources(struct qedi_ctx *qedi,
> diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_de=
f.h
> index 69a590546bf9..a122909169ee 100644
> --- a/drivers/scsi/qla4xxx/ql4_def.h
> +++ b/drivers/scsi/qla4xxx/ql4_def.h
> @@ -216,11 +216,18 @@
> #define IDC_COMP_TOV			5
> #define LINK_UP_COMP_TOV		30
>=20
> -#define CMD_SP(Cmnd)			((Cmnd)->SCp.ptr)
> +struct qla4xxx_cmd_priv {
> +	struct iscsi_cmd iscsi_data; /* must be the first member */
> +	struct srb *srb;
> +};
> +
> +static inline struct qla4xxx_cmd_priv *qla4xxx_cmd_priv(struct scsi_cmnd=
 *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
>=20
> /*
> - * SCSI Request Block structure	 (srb)	that is placed
> - * on cmd->SCp location of every I/O	 [We have 22 bytes available]
> + * SCSI Request Block structure (srb) that is associated with each scsi_=
cmnd.
>  */
> struct srb {
> 	struct list_head list;	/* (8)	 */
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.=
c
> index 0ae936d839f1..d64eda961412 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -226,6 +226,7 @@ static struct scsi_host_template qla4xxx_driver_templ=
ate =3D {
> 	.name			=3D DRIVER_NAME,
> 	.proc_name		=3D DRIVER_NAME,
> 	.queuecommand		=3D qla4xxx_queuecommand,
> +	.cmd_size		=3D sizeof(struct qla4xxx_cmd_priv),
>=20
> 	.eh_abort_handler	=3D qla4xxx_eh_abort,
> 	.eh_device_reset_handler =3D qla4xxx_eh_device_reset,
> @@ -4054,7 +4055,7 @@ static struct srb* qla4xxx_get_new_srb(struct scsi_=
qla_host *ha,
> 	srb->ddb =3D ddb_entry;
> 	srb->cmd =3D cmd;
> 	srb->flags =3D 0;
> -	CMD_SP(cmd) =3D (void *)srb;
> +	qla4xxx_cmd_priv(cmd)->srb =3D srb;
>=20
> 	return srb;
> }
> @@ -4067,7 +4068,7 @@ static void qla4xxx_srb_free_dma(struct scsi_qla_ho=
st *ha, struct srb *srb)
> 		scsi_dma_unmap(cmd);
> 		srb->flags &=3D ~SRB_DMA_VALID;
> 	}
> -	CMD_SP(cmd) =3D NULL;
> +	qla4xxx_cmd_priv(cmd)->srb =3D NULL;
> }
>=20
> void qla4xxx_srb_compl(struct kref *ref)
> @@ -4640,7 +4641,7 @@ static int qla4xxx_cmd_wait(struct scsi_qla_host *h=
a)
> 			 * the scsi/block layer is going to prevent
> 			 * the tag from being released.
> 			 */
> -			if (cmd !=3D NULL && CMD_SP(cmd))
> +			if (cmd !=3D NULL && qla4xxx_cmd_priv(cmd)->srb)
> 				break;
> 		}
> 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> @@ -9079,7 +9080,7 @@ struct srb *qla4xxx_del_from_active_array(struct sc=
si_qla_host *ha,
> 	if (!cmd)
> 		return srb;
>=20
> -	srb =3D (struct srb *)CMD_SP(cmd);
> +	srb =3D qla4xxx_cmd_priv(cmd)->srb;
> 	if (!srb)
> 		return srb;
>=20
> @@ -9121,7 +9122,7 @@ static int qla4xxx_eh_wait_on_command(struct scsi_q=
la_host *ha,
>=20
> 	do {
> 		/* Checking to see if its returned to OS */
> -		rp =3D (struct srb *) CMD_SP(cmd);
> +		rp =3D qla4xxx_cmd_priv(cmd)->srb;
> 		if (rp =3D=3D NULL) {
> 			done++;
> 			break;
> @@ -9215,7 +9216,7 @@ static int qla4xxx_eh_abort(struct scsi_cmnd *cmd)
> 	}
>=20
> 	spin_lock_irqsave(&ha->hardware_lock, flags);
> -	srb =3D (struct srb *) CMD_SP(cmd);
> +	srb =3D qla4xxx_cmd_priv(cmd)->srb;
> 	if (!srb) {
> 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
> 		ql4_printk(KERN_INFO, ha, "scsi%ld:%d:%llu: Specified command has alrea=
dy completed.\n",
> diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
> index 4ee233e5a6ff..cb805ed9cbf1 100644
> --- a/include/scsi/libiscsi.h
> +++ b/include/scsi/libiscsi.h
> @@ -19,6 +19,7 @@
> #include <linux/refcount.h>
> #include <scsi/iscsi_proto.h>
> #include <scsi/iscsi_if.h>
> +#include <scsi/scsi_cmnd.h>
> #include <scsi/scsi_transport_iscsi.h>
>=20
> struct scsi_transport_template;
> @@ -152,6 +153,17 @@ static inline bool iscsi_task_is_completed(struct is=
csi_task *task)
> 	       task->state =3D=3D ISCSI_TASK_ABRT_SESS_RECOV;
> }
>=20
> +/* Private data associated with struct scsi_cmnd. */
> +struct iscsi_cmd {
> +	struct iscsi_task	*task;
> +	int			age;
> +};
> +
> +static inline struct iscsi_cmd *iscsi_cmd(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> /* Connection's states */
> enum {
> 	ISCSI_CONN_INITIAL_STAGE,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

