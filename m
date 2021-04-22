Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A34C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F006144E
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 02:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhDVCZP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 22:25:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:32804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhDVCZP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 22:25:15 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2Lwg3164966;
        Thu, 22 Apr 2021 02:24:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=plP0hkJtla0sBcfMvRz5pIIhaaMNUkL8eKyCuBRLauc=;
 b=CSYH0QbS+iEXFkVLvSYNV1LVcMQEZt6WoGqWC5R2oPdZQIyC6dH2vcTnTfIFQJuxXJoE
 Lb8xqVdApH4kM/Nhf3X/f3SnegLQXp34PS8wyAeIaCEvqvWt8/X2Gp2dhtOX4xe2ellL
 CaaRgoTd9jn/SfgoDxtNRoudPgzRDDCxAgS9bjJsY1DGzPT+qk1xj2m0qp+SV2hbrocY
 s9er78g7taH6qHb/H4F31Vr75u39qG8oVYiNHqM0rDH1cSu025qI5g6mqoieBtdi/Tqv
 ig2V00U0lOwYzPHlWMw1h7/XDMF954F+/W2FpJdL+VYKKZJykUUWTufdxBzvnxMgbgdw Cg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37yveakmvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:24:36 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13M2KBPU066310;
        Thu, 22 Apr 2021 02:24:35 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 3809k2rnsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Apr 2021 02:24:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HZU1pRSx0fAz3+15O1Hk0a0Pfb0eHz++NutDoL5vxNbklF037KCsLObUDCw5EMWs2LjCwSP3vMGpdIYv86Ndu5UyjW2VHbNZG9DqXSetQjtW3sjnZ9492jEX+ta95ZTydAieyVXBGva3iScaGL4oI7WVzCErHg0nO28/Llf6dxTsvaGpssAECnxzv/gwlx6z+jgZ6ZRk1CxVV4e/11ZVJsW86tRDZfog6SQVoTWe1Km/EJ/oSEkgEY/4vGBJltI6Rr+qIKAFBEO+glNn0KIBMRec9JKrFsAhEevAKNkaHE2Dln14wqzrIjgb/8iTFbzcAaFIDePArOaBRrSdscTflw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plP0hkJtla0sBcfMvRz5pIIhaaMNUkL8eKyCuBRLauc=;
 b=UlpTL+RKRCZceIMesnTIn2dF1GMGGTMesvlL8vidlVpcvzzkm+GuZ92AzXmSn1TMLNe/LbaOuitOGOyD1O7pip8Cg8UD69H+4jOhAuKwyZs0Qc3NnLIsDL1QEErD9TNo0O8v1zy9vjYlxPFzhVmyJfD1bwfC1R8hhDq/ygE9lileT7+/GQsgYIyL+WFdtnrj92Hk7u69UXjwVZnFRWe5Y7QE65qfQEQ36T3Opgv2NloNVUP4jliCE6jfonrlddUtYPXlJDTFdUO4Lb9yH2CZbGF/+EOpkyjnq0YYL2pz9FgFZV22wwjl2F50y4PrHeh1tPL8DAK8VSEo+wG2X9Jy7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plP0hkJtla0sBcfMvRz5pIIhaaMNUkL8eKyCuBRLauc=;
 b=MT/qfifaMXGAUCmMkl4ElJUSLGOJf1lTaUF6esxk+gkCn1ieN7Uvh5LHa9ow3NsuNkOc7iXIn/UtO/o5rM9WO0AaZQ8xReqlI2DmciKr3Ey88t1MfYEwBfjkHYqkDf5BuNZQi5cQTsrxnSpUoTQVIpdp/6/TTOiHD1JGWkRui6M=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2942.namprd10.prod.outlook.com (2603:10b6:805:d7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Thu, 22 Apr
 2021 02:24:33 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4042.024; Thu, 22 Apr 2021
 02:24:33 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "steve.hagan@broadcom.com" <steve.hagan@broadcom.com>,
        "peter.rivera@broadcom.com" <peter.rivera@broadcom.com>,
        "mpi3mr-linuxdrv.pdl@broadcom.com" <mpi3mr-linuxdrv.pdl@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v3 11/24] mpi3mr: print ioc info for debugging
Thread-Topic: [PATCH v3 11/24] mpi3mr: print ioc info for debugging
Thread-Index: AQHXNQuQ+E25lAN/H0GvlnSyukJZ2qq/0yoA
Date:   Thu, 22 Apr 2021 02:24:33 +0000
Message-ID: <71E0F995-F2AF-4E05-8542-DE2B607530D4@oracle.com>
References: <20210419110156.1786882-1-kashyap.desai@broadcom.com>
 <20210419110156.1786882-12-kashyap.desai@broadcom.com>
In-Reply-To: <20210419110156.1786882-12-kashyap.desai@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0871fe74-59cd-4d1b-9e04-08d90535c445
x-ms-traffictypediagnostic: SN6PR10MB2942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB2942A21E2A53DCD7E4129550E6469@SN6PR10MB2942.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:321;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mT+NcV5avph6njNC7WY8qjfVsTjyOvUCyNXmnVkmpzXgUyj2BChOQF7guXBVaHjE17GmqdEtV9YpbX21IdJZLQN4eBZqSDs4T4jNLjYrvbMbvxHYJEWHM3F7WPpWFwApDQbKEHWKfg56cue/OYjO94MokvXQD7s7+p/Fa8dKKJsfqamKEjbpKfScMdBpmSCs/0fBOSJkNAzP7TfhpV7yRgsejTufc5edzbAArRFJklJd5REhMiXJ8VCFO0mmmqWj0CwYFDvm0ezz8lfHteEoSwu8x7YBYsigipQIG3INkA3g4xnx+M73/Q4OfCYIW3zquZsipC6BexwUKw+KT/AKOSV/DT6J+u9jwjnksj2AKEDLLvlmeIIg2JrlgwWOJBr/j2qPi3+m+Ptxx3M3tchJzKUOfJgqA8MS9YEEFbI8AlYZ8ezH9NkIQ1ItMd5O5YusTDES12xaZEnlYVAMqpz5ptLub4FAb1P7+y+1JQE13qCEEEUQ5GmsLHYZYGs19INrmN5cgMpbm7LJzevK1FTbB6YpG+t6KS13ab4yN+TWbrKAY92jHX674jZR/fkP0Yl9AazcbdmMWVG7Kf1OFfybCVAUAjIFyi7sWXG3655FF4bGcujUDIbtUDZvtCJpTWKyU8S6azzZMxzdxWucPu0dnHjjDLpzGVG/O5bmSATftTmq6/hDUbd/q0qN0/4UwHSB
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(396003)(376002)(2616005)(36756003)(64756008)(26005)(66476007)(54906003)(66946007)(122000001)(6506007)(83380400001)(53546011)(76116006)(44832011)(6512007)(6916009)(8936002)(316002)(71200400001)(5660300002)(86362001)(66556008)(4326008)(8676002)(33656002)(38100700002)(2906002)(478600001)(6486002)(66446008)(186003)(32563001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?6SHlmWwsCxXQYq19z83PaH+eskTcvJ/x/XtNsGjkds0PXGZIIZg89bVjJURz?=
 =?us-ascii?Q?gKztrjiEHAsP7VN7Y9yBlSs4UBTYf6h9ITGbBC3Skdpdw61Vea6Kc+cXduLg?=
 =?us-ascii?Q?xYvVomGnYLLmuDknaaJtS/cbf3ZF/FfRikA6ZNMjh2DPi+v9KMvEulDiPkvI?=
 =?us-ascii?Q?l3DrH73EF1lQF9eC0m1oKcRJhiWvUdOQJuj216lzF6X3ZWBs1FhjMSi0CJg3?=
 =?us-ascii?Q?YufQCphLKfgs0flHszLERAqY8d+rMwdGl/vD01+z0Oz9ALEvry6AriW14+s1?=
 =?us-ascii?Q?Pm2doD+9zl9n14xBBMiZ2S9B10isFNsnw+tw22wtycd2zIxh1c7iiDQ407Tp?=
 =?us-ascii?Q?t2vYj1+tBp12tBmqO1apRi822DIwIqd/echSUxFDW4GamQdiKqaqXFiMj2g5?=
 =?us-ascii?Q?jI6+9JlRfAkHqBFUHMCnWtgvVQfLiXzE29PC8u6W/QPXOeE0JKCSs/725TV1?=
 =?us-ascii?Q?IYqpaMzhL5/dVO5Dkqepn4rnVHd5X+8IITHj1AGLqr2OVDah1YGsqiJ5OJkT?=
 =?us-ascii?Q?G8ZNDEFKbjcuzp1MwHFyR4wlMQXPHnRh7B7/r4P96zgsvr/LyjJLkcNZsR5o?=
 =?us-ascii?Q?iCcDfrwUJ0D6BFlGHK+t2/I+/4Z1HWvQL2JdqFEvxdvUTIZJT0x8QWyJkoc1?=
 =?us-ascii?Q?tSqVlH4I8aRKesGdf6sXEAX+Pp1Xf/40GqtwKB+78znM1SePhA+KMyNbu4OG?=
 =?us-ascii?Q?7+6KrxXZO/G3yR/gOPTUv/Xk5cTM1/Umu+HWGNlJTDrz9zDpqHVqo5lTUjaM?=
 =?us-ascii?Q?00yPEcaMLiX+3S6O8z/vIOi10FET3D19KYoH7OVy+SxLUUQzA/202HoqHOkT?=
 =?us-ascii?Q?n+yGbtzKiSp7bYo6dboPUbVPiNAGEp6GPn96hiRtjulgSNMSBlsefFOcBVgQ?=
 =?us-ascii?Q?DyR3NwdqrQWiTchhfYROtn2QgN/Vok2mPtqUjyNdXFGFHBhhxoauURPDOALO?=
 =?us-ascii?Q?2dONJ5HWna1f8BmnUXHZgharYwH94KbC8MiCM6Ox7jgBW7UCXVCio5RTjJ79?=
 =?us-ascii?Q?DO81pujXZlux6a+4locg0fWIR58+dkvgtmDsgkVu9/ikZHsUJXfcJHX1vX0G?=
 =?us-ascii?Q?f/SD8tjRr5DaV+GsGHzv9bw7bR96VYR879I6Ksm8RUEqlddrErI2qFSHYp4v?=
 =?us-ascii?Q?uWJZb09JHVi+MGvq2qZrEBM49BFlT0rwnw2kif21XKnXXE74/CQt5iFve/WE?=
 =?us-ascii?Q?a2ivko1uG27pZASP68BnfX9WKtNMWBRLDmnl6EeyBul1rfm1bi9MxuXUktny?=
 =?us-ascii?Q?2fe5ZRTcE1HwRbmnjoD/jxyn8h4ArU6GK81+smq2NORXwuOHX3VxBnsUK8HO?=
 =?us-ascii?Q?nbuEa2aE9UnNftbf3+u0FQQsREa2jBffXJSbMdVfVQgkkA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C750AFA0D23B914C867E695DE0C3B02C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0871fe74-59cd-4d1b-9e04-08d90535c445
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 02:24:33.3139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GtlqWdYjV+C4dR6HWM7wzmtRXYEIUehvgnxfVRXEa8W6mukusWATnlOsJntR0GQKJaCyUPpOkb5KzzTojFDEKNT47jq0By8xwQLXLp2G+Og=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2942
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220019
X-Proofpoint-GUID: Zm4jUEwPeyXwMf5ACWY7W5qdVv9PEeQL
X-Proofpoint-ORIG-GUID: Zm4jUEwPeyXwMf5ACWY7W5qdVv9PEeQL
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9961 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 malwarescore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104220019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 19, 2021, at 6:01 AM, Kashyap Desai <kashyap.desai@broadcom.com> w=
rote:
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
>=20
> Cc: sathya.prakash@broadcom.com
> ---
> drivers/scsi/mpi3mr/mpi3mr_fw.c | 80 +++++++++++++++++++++++++++++++++
> drivers/scsi/mpi3mr/mpi3mr_os.c |  1 +
> 2 files changed, 81 insertions(+)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr=
_fw.c
> index 4e28a0efb082..3df689410c8f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -2550,6 +2550,85 @@ int mpi3mr_issue_port_enable(struct mpi3mr_ioc *mr=
ioc, u8 async)
> 	return retval;
> }
>=20
> +/* Protocol type to name mapper structure*/
> +static const struct {
> +	u8 protocol;
> +	char *name;
> +} mpi3mr_protocols[] =3D {
> +	{ MPI3_IOCFACTS_PROTOCOL_SCSI_INITIATOR, "Initiator" },
> +	{ MPI3_IOCFACTS_PROTOCOL_SCSI_TARGET, "Target" },
> +	{ MPI3_IOCFACTS_PROTOCOL_NVME, "NVMe attachment" },
> +};
> +
> +/* Capability to name mapper structure*/
> +static const struct {
> +	u32 capability;
> +	char *name;
> +} mpi3mr_capabilities[] =3D {
> +	{ MPI3_IOCFACTS_CAPABILITY_RAID_CAPABLE, "RAID" },
> +};
> +
> +/**
> + * mpi3mr_print_ioc_info - Display controller information
> + * @mrioc: Adapter instance reference
> + *
> + * Display controller personalit, capability, supported
> + * protocols etc.
> + *
> + * Return: Nothing
> + */
> +static void
> +mpi3mr_print_ioc_info(struct mpi3mr_ioc *mrioc)
> +{
> +	int i =3D 0;
> +	char personality[16];
> +	char protocol[50] =3D {0};
> +	char capabilities[100] =3D {0};
> +	bool is_string_nonempty =3D false;
> +	struct mpi3mr_compimg_ver *fwver =3D &mrioc->facts.fw_ver;
> +
> +	switch (mrioc->facts.personality) {
> +	case MPI3_IOCFACTS_FLAGS_PERSONALITY_EHBA:
> +		strcpy(personality, "Enhanced HBA");
> +		break;
> +	case MPI3_IOCFACTS_FLAGS_PERSONALITY_RAID_DDR:
> +		strcpy(personality, "RAID");
> +		break;
> +	default:
> +		strcpy(personality, "Unknown");
> +		break;
> +	}
> +
> +	ioc_info(mrioc, "Running in %s Personality", personality);
> +
> +	ioc_info(mrioc, "FW Version(%d.%d.%d.%d.%d.%d)\n",
> +	fwver->gen_major, fwver->gen_minor, fwver->ph_major,
> +	    fwver->ph_minor, fwver->cust_id, fwver->build_num);
> +
> +	for (i =3D 0; i < ARRAY_SIZE(mpi3mr_protocols); i++) {
> +		if (mrioc->facts.protocol_flags &
> +		    mpi3mr_protocols[i].protocol) {
> +			if (is_string_nonempty)
> +				strcat(protocol, ",");
> +			strcat(protocol, mpi3mr_protocols[i].name);
> +			is_string_nonempty =3D true;
> +		}
> +	}
> +
> +	is_string_nonempty =3D false;
> +	for (i =3D 0; i < ARRAY_SIZE(mpi3mr_capabilities); i++) {
> +		if (mrioc->facts.protocol_flags &
> +		    mpi3mr_capabilities[i].capability) {
> +			if (is_string_nonempty)
> +				strcat(capabilities, ",");
> +			strcat(capabilities, mpi3mr_capabilities[i].name);
> +			is_string_nonempty =3D true;
> +		}
> +	}
> +
> +	ioc_info(mrioc, "Protocol=3D(%s), Capabilities=3D(%s)\n",
> +	    protocol, capabilities);
> +}
>=20
> /**
>  * mpi3mr_cleanup_resources - Free PCI resources
> @@ -2808,6 +2887,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc, u8 re=
_init)
> 		}
>=20
> 	}
> +	mpi3mr_print_ioc_info(mrioc);
>=20
> 	retval =3D mpi3mr_alloc_reply_sense_bufs(mrioc);
> 	if (retval) {
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr=
_os.c
> index d82581ec73e1..39928e2997ba 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -339,6 +339,7 @@ void mpi3mr_invalidate_devhandles(struct mpi3mr_ioc *=
mrioc)
>  * mpi3mr_flush_scmd - Flush individual SCSI command
>  * @rq: Block request
>  * @data: Adapter instance reference
> + * @reserved: N/A. Currently not used
>  *
>  * Return the SCSI command to the upper layers if it is in LLD
>  * scope.
> --=20
> 2.18.1
>=20

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

