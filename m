Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FDDC4321E
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:52:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241093AbiBISwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241170AbiBISuw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:50:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F654C0045A2
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:46:00 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HCctS008857;
        Wed, 9 Feb 2022 18:45:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZihgzISYwqB6khsZVShMIPtYoMrKlKQxlQkncI6v5I8=;
 b=yM+J/GIOUGDsf/pEmkyoSxUSTTO8RzsHD2swaJ+zFz7k13B/Ukh7oo5Z/hK54XZ7l+Tv
 TCsem2siYuIjyvZ9/gKI0KlelnZyZpY2zsljyZZJyE3bQoeso8BkLAssW7uJ/nnKClQp
 A62geyF6II2uTO7y2exc4Kuquw0Uz1tA7bxhAnyFartBgkl0ysQtsrphNDTD/G9hNpGi
 trMZ5Viq1JWzNqNXYyxvlXOlv8WkgEiQeUNHmjVLRZjroItOUTQophjQfX3rFCGbHX2k
 ZmV6reuJddG2xMjoi7SYHzi4CgDlFmKldEIUXAAGqm4S4GpjhD8k/95T4l2GhZqANeC+ Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgnn25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:45:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IiAGq038765;
        Wed, 9 Feb 2022 18:45:50 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by aserp3030.oracle.com with ESMTP id 3e1f9hv16v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:45:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ENcxPyTSjRYdpmFxvaODGKDGJGdDL8UIAA1ssHUaKx/wB5p/dOiUHQGuwcrCpVj8ERD1pnl1jJJSTdYg9kZgSZRcYBfyEKfY2bZUDfZbVE99Ap7oC+3P9NFw8bZzsy4CNBpRUM7qwM5LpLeglU3mLXSEsd6uLqt3ZVonmJYJxrJAt7Oiu4BKrJLskpgZJterCHwG3fPqqc9V2rv7CVRyHnBXaJYhg8PCoe+lZ/T6imy2abM38KdEFkr8YMtvI4Snrz3kT+re6Q3o9ERlonxwBGLbuXXxs9wrQ7EuGr4/LpOpjMVlf1dPZgU8/phMQWRM2OMdw9fL6Yh3VekqigniJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZihgzISYwqB6khsZVShMIPtYoMrKlKQxlQkncI6v5I8=;
 b=inI+l38PCafHo+w99XZ+s5rXQE9o7V4S/i9w8w2FOmQq7rG+J2IdFpObaIXstahb1lsyEz7jSC+6wRwgRnc6s3Nudx61NXJS7mO/W4F8tUQBHQHL+a19vbdFWpr1HkHk13wL6GXyP7EGBuAlZYaV0trL/Dp5BqVvYwL7FU1AM+/6dbX1Tahi0pXKhWJNbMRIf4xwMXYhf4OWy4x/B8d8BDsNP2QH1PrkjaiNrjlHX59P/NfUUNQeUEzFqLjwY2QEPEcBvd7/pfrk73ZvVGFTcCaG3okfufxMsybKTA6fUCicUPfbbojzXf72R2kfbU/1pJqcHvEouut7c9R1YzEbcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZihgzISYwqB6khsZVShMIPtYoMrKlKQxlQkncI6v5I8=;
 b=XitWf+lvaORMAdOZ2uHDVagaMdZ8ynoxDIDIEoRgdOXF/CkelfoOJB7AepCWgLx0ZNj8FgSvWB7I7Lm1kk1HKLEC+c59DcYtlk1tGj6ciUNztXIquTm4AI7Evoxc8hLa5yqyc63eeBhP9TTY1yhHNWe4NCav/auf1n2plSo+bG0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5288.namprd10.prod.outlook.com (2603:10b6:408:12c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:45:48 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:45:48 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 28/44] megasas: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 28/44] megasas: Stop using the SCSI pointer
Thread-Index: AQHYHREuQz9TL2SDfEa1MWRLoH3NRayLkF6A
Date:   Wed, 9 Feb 2022 18:45:48 +0000
Message-ID: <2D83EE95-C7EB-429A-B596-2CCCFFC45B73@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-29-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-29-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 055751df-b933-4e34-fb73-08d9ebfc6369
x-ms-traffictypediagnostic: BN0PR10MB5288:EE_
x-microsoft-antispam-prvs: <BN0PR10MB5288F010FBF1082BC2B5594DE62E9@BN0PR10MB5288.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2kMFHgRMa0B6ujp5k82XmzJrdbLj5bVW1zzni1ct9FPksmn84Hf3U0yFK7tRsRYxsDmsGmC5tsxPy7B5dGod4dON4IyJgh5nSuygjfe5gn4VsYRicC6xyTDBJxxGxHIvhERuXUFRknk/HpOYlx2kNGZG4lLfKTSLH9hRWAcOCcewHfJuDKIv9plCSrFvArAlHtiNwkGtRY07z7gdz3pZc1Z9LclBxVwocrwAqHjujjLYzUYfwEyfDGUtpSfBUgB8mBmfMyBXR87lmPgTd2/5ApLMRhyEOCkKc+5FoqbE4ohio1KrzWBrZifY4sHkoszvOvF03yDBbC8FPstYGdhyUEV3z6sGR1mlWTMoJdayBxIzdxc/c+RhbiWRihHgbrrEderF7WbuMYCBLeKkiBfHZKKIY2rNxRhlQHdalG3lcl0zSbgPkGYaBmRENX8bHDuFBoFQFcSxwXXEHUPZ1MdYnYJjRVHTj91AIRytKkiJJe2flDqVu46WQvZ2ZLPpYuXS4TX+DXZaEOrSkuuie9t4N3dCCMbAUxEEbtaCs7SIdfOPIdyZVU0W+cNOSLewh13W8IKqGwr8PXtQNO+uG9BCmL0PoX0qohDgds3H24ALAwKytEfjrUi+GlZGUcA4ymGjduJJV3BqV58Gwxvx0D6XyBQFfcPF3nHnl5jrNB8gdogyrbMYKKtTGO68NzYoF64u6vtk6QJLoOhI25DdVY0jJjaXtwMXnSsIouT+idBcvXh+BwOQgacYu5YK5lvsV2bt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(38070700005)(6486002)(83380400001)(54906003)(76116006)(6916009)(316002)(122000001)(33656002)(2906002)(186003)(2616005)(44832011)(86362001)(6512007)(66476007)(508600001)(71200400001)(5660300002)(38100700002)(64756008)(36756003)(53546011)(8676002)(8936002)(6506007)(66556008)(66446008)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yWYFSGSI4PrSKtg4Or4JyJ74cyEuj3aTv7g8DCuNU7lGe0MFsG+jIQoGuRK2?=
 =?us-ascii?Q?z6M3nBILjGg/Qo6bywpNu8UoPDnEnDiYZTsYNyYp3C6ALuTNfF830ImOLnM2?=
 =?us-ascii?Q?uSImT1OGWaSQ44nm94XMyMvnwY4eRR00pLKZd7C7KjL7GG46dD42WjUDN8uP?=
 =?us-ascii?Q?By4y/6LCEh0EBocJvcp3sJlwzNo7QYu7IqjYCsySGtAmW3p8PpLz+LthWbAm?=
 =?us-ascii?Q?5qWvFzEofkeKfEyXVFShAYbqDwklw/RaoPAhrWJof3izovPPT3oR99u08d4K?=
 =?us-ascii?Q?Ocir7VUKwK4uCuR3a7e+TXW1sYFNacEJwkTUfijnVdg8Gb+5UjxU5m2/LTyr?=
 =?us-ascii?Q?y7ZkDtU62+pedCeVosFRd5I01s34ygHlL01tvwUGDftZbUNnvxXbT3GdHzQW?=
 =?us-ascii?Q?nBohyswAc3b6UjMMI5GinnMDu2YM20p1f/juZUnpWnXDgoih0pI3T8317ZIr?=
 =?us-ascii?Q?ZUjsICl17s2tqu42Ap0X1aKRrJZvIwlmgMEA835tknikZCqBduOlELII5UiG?=
 =?us-ascii?Q?lbaFmsmIhkV8NzWVxgAOZfNeF4vswX8QalYNocnAXjosDYaOHOwMntBS365E?=
 =?us-ascii?Q?gE0xUyreiE8g4l8p2j8XfbY77LDyaTi0O/tktbR52JLtiJlrjvgcZiwYPV2Z?=
 =?us-ascii?Q?YXzfRJmraTYhsS5uTI+Qdz3ImB6Ru7ppSggvD6iOBBFHk2Q0akhWF4INDAbu?=
 =?us-ascii?Q?ENFxDgSxNOdkauPx2YsACO74JaUXuC4PFEPHedsTjspHiEnxiupZ5ZEtnY1v?=
 =?us-ascii?Q?EfVF+9OpBGnXOk4H8nDSgi4uAzQ84tgOdKBuLC+T8edcyJfkbc91XMaiA4v+?=
 =?us-ascii?Q?KwlJkOikFuQxc7TUg5M8ROx8/ORb+QCbGeWdfmcbHsrv2r/YhwGf590FsVu8?=
 =?us-ascii?Q?tb3R0oEpQ7phZPQPkAc5yrq2xwgMJPa3fLYFGJba98/mR+ByHTTnU3cIbH2G?=
 =?us-ascii?Q?yr97QLM2zTVI2orLjW/Mq32lv77g5CpkS3YGC9EIA7mcFkaXyIFpETDsuZ/s?=
 =?us-ascii?Q?D0csNKhtXaboev31ZGKzJOeum1idTyO7nIw5Ump4tMcXz7cYYLa09hISe7of?=
 =?us-ascii?Q?PJhqzIzoAOpkrYvUo3aRJDTyWKcojdPVxavjOSuYBzX8bVVvNO9Z4T8mvFKG?=
 =?us-ascii?Q?SDDFTAr/E7njDxEBKNiW+Wv+IgxiPQokFdLNfSECWR0PmB4HuzK8Ne+3fO2d?=
 =?us-ascii?Q?/PirWNoSEoCDDD+7OcStc9YrPX63Pg9d1DKTZmoAcA07Cb9ZxwkaG+jyar57?=
 =?us-ascii?Q?ibW2FsSgTsfp8sbfqgU0zdnhPpoxExm2PwHAQBIHq49VmsSuOyrRqGhOmWic?=
 =?us-ascii?Q?ymLNLhlRD1zXauJce7G7P5DLZ1Fn1PnKvoRg68ZzxUtbj09eHhcpqzYVqOoV?=
 =?us-ascii?Q?JVKgp57pNrYwloMz+XY8rrR/lBZnkHLoO2RKgebaCSfsU/EsQbuW2kKXhmvM?=
 =?us-ascii?Q?qHH0kGDC+/+7q3KfzYX6i4Ngz1FXKfukUkZU6pX3nncjvLi6xaMldkWm3PoK?=
 =?us-ascii?Q?rc93Hru52YdybrnFUjkqL+L2Gg8qr5lhUFo/Wbjfm2Fn22IIJ2/VG5ESlgi1?=
 =?us-ascii?Q?XGoEnQSRLsnEqjL4rJQJ2cX2ych9DcR9DeLVmHHkq1wE7T9OKdi8HzuBigXz?=
 =?us-ascii?Q?C3MsiCo7txH9k08lT0vjuSEWypiHQOkEFT9qfamw/yDFqtf3cyPh8SJCX4sy?=
 =?us-ascii?Q?4O9DgPgvw88sa/Fozp7OMfA2jnmgVRJlLWa3EBEgJvzIP8xp?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11D79F73C3B16943A6B28A77CFC55190@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 055751df-b933-4e34-fb73-08d9ebfc6369
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:45:48.0561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DR0HdzFyIBt2/h2H8dzKJvLgVEC35j4d/OlpkMC8alw7fQ7uKAbltPN2RhY7EPDO5wzH2pisuYXLpywkFkDOeigPefdprm2/08fCZBiXtA8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5288
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-GUID: h-eSjjEDy8ejpYBlZyEEyfOdauraq7X9
X-Proofpoint-ORIG-GUID: h-eSjjEDy8ejpYBlZyEEyfOdauraq7X9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/megaraid/megaraid_sas.h        | 12 ++++++++++++
> drivers/scsi/megaraid/megaraid_sas_base.c   |  8 ++++----
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 15 ++++++++-------
> 3 files changed, 24 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid=
/megaraid_sas.h
> index 2c9d1b796475..611871ef15b5 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -18,6 +18,8 @@
> #ifndef LSI_MEGARAID_SAS_H
> #define LSI_MEGARAID_SAS_H
>=20
> +#include <scsi/scsi_cmnd.h>
> +
> /*
>  * MegaRAID SAS Driver meta data
>  */
> @@ -2594,6 +2596,16 @@ struct megasas_cmd {
> 	};
> };
>=20
> +struct megasas_cmd_priv {
> +	void	*cmd_priv;
> +	u8	status;
> +};
> +
> +static inline struct megasas_cmd_priv *megasas_priv(struct scsi_cmnd *cm=
d)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> #define MAX_MGMT_ADAPTERS		1024
> #define MAX_IOCTL_SGE			16
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
> index 82e1e24257bc..8bf72dbc33b7 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1760,7 +1760,7 @@ megasas_build_and_issue_cmd(struct megasas_instance=
 *instance,
> 		goto out_return_cmd;
>=20
> 	cmd->scmd =3D scmd;
> -	scmd->SCp.ptr =3D (char *)cmd;
> +	megasas_priv(scmd)->cmd_priv =3D cmd;
>=20
> 	/*
> 	 * Issue the command to the FW
> @@ -2992,11 +2992,10 @@ megasas_dump_reg_set(void __iomem *reg_set)
> void
> megasas_dump_fusion_io(struct scsi_cmnd *scmd)
> {
> -	struct megasas_cmd_fusion *cmd;
> +	struct megasas_cmd_fusion *cmd =3D megasas_priv(scmd)->cmd_priv;
> 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
> 	struct megasas_instance *instance;
>=20
> -	cmd =3D (struct megasas_cmd_fusion *)scmd->SCp.ptr;
> 	instance =3D (struct megasas_instance *)scmd->device->host->hostdata;
>=20
> 	scmd_printk(KERN_INFO, scmd,
> @@ -3518,6 +3517,7 @@ static struct scsi_host_template megasas_template =
=3D {
> 	.mq_poll =3D megasas_blk_mq_poll,
> 	.change_queue_depth =3D scsi_change_queue_depth,
> 	.max_segment_size =3D 0xffffffff,
> +	.cmd_size =3D sizeof(struct megasas_cmd_priv),
> };
>=20
> /**
> @@ -3601,7 +3601,7 @@ megasas_complete_cmd(struct megasas_instance *insta=
nce, struct megasas_cmd *cmd,
> 	cmd->retry_for_fw_reset =3D 0;
>=20
> 	if (cmd->scmd)
> -		cmd->scmd->SCp.ptr =3D NULL;
> +		megasas_priv(cmd->scmd)->cmd_priv =3D NULL;
>=20
> 	switch (hdr->cmd) {
> 	case MFI_CMD_INVALID:
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/m=
egaraid/megaraid_sas_fusion.c
> index fc90a0a687b5..c72364864bf4 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -2915,7 +2915,7 @@ megasas_build_ldio_fusion(struct megasas_instance *=
instance,
> 				get_updated_dev_handle(instance,
> 					&fusion->load_balance_info[device_id],
> 					&io_info, local_map_ptr);
> -			scp->SCp.Status |=3D MEGASAS_LOAD_BALANCE_FLAG;
> +			megasas_priv(scp)->status |=3D MEGASAS_LOAD_BALANCE_FLAG;
> 			cmd->pd_r1_lb =3D io_info.pd_after_lb;
> 			if (instance->adapter_type >=3D VENTURA_SERIES)
> 				rctx_g35->span_arm =3D io_info.span_arm;
> @@ -2923,7 +2923,7 @@ megasas_build_ldio_fusion(struct megasas_instance *=
instance,
> 				rctx->span_arm =3D io_info.span_arm;
>=20
> 		} else
> -			scp->SCp.Status &=3D ~MEGASAS_LOAD_BALANCE_FLAG;
> +			megasas_priv(scp)->status &=3D ~MEGASAS_LOAD_BALANCE_FLAG;
>=20
> 		if (instance->adapter_type >=3D VENTURA_SERIES)
> 			cmd->r1_alt_dev_handle =3D io_info.r1_alt_dev_handle;
> @@ -3293,7 +3293,7 @@ megasas_build_io_fusion(struct megasas_instance *in=
stance,
> 	io_request->SenseBufferLength =3D SCSI_SENSE_BUFFERSIZE;
>=20
> 	cmd->scmd =3D scp;
> -	scp->SCp.ptr =3D (char *)cmd;
> +	megasas_priv(scp)->cmd_priv =3D cmd;
>=20
> 	return 0;
> }
> @@ -3489,7 +3489,7 @@ megasas_complete_r1_command(struct megasas_instance=
 *instance,
> 		if (instance->ldio_threshold &&
> 		    megasas_cmd_type(scmd_local) =3D=3D READ_WRITE_LDIO)
> 			atomic_dec(&instance->ldio_outstanding);
> -		scmd_local->SCp.ptr =3D NULL;
> +		megasas_priv(scmd_local)->cmd_priv =3D NULL;
> 		megasas_return_cmd_fusion(instance, cmd);
> 		scsi_dma_unmap(scmd_local);
> 		megasas_sdev_busy_dec(instance, scmd_local);
> @@ -3613,12 +3613,13 @@ complete_cmd_fusion(struct megasas_instance *inst=
ance, u32 MSIxIndex,
> 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
> 			/* Update load balancing info */
> 			if (fusion->load_balance_info &&
> -			    (cmd_fusion->scmd->SCp.Status &
> +			    (megasas_priv(cmd_fusion->scmd)->status &
> 			    MEGASAS_LOAD_BALANCE_FLAG)) {
> 				device_id =3D MEGASAS_DEV_INDEX(scmd_local);
> 				lbinfo =3D &fusion->load_balance_info[device_id];
> 				atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
> -				cmd_fusion->scmd->SCp.Status &=3D ~MEGASAS_LOAD_BALANCE_FLAG;
> +				megasas_priv(cmd_fusion->scmd)->status &=3D
> +					~MEGASAS_LOAD_BALANCE_FLAG;
> 			}
> 			fallthrough;	/* and complete IO */
> 		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
> @@ -3630,7 +3631,7 @@ complete_cmd_fusion(struct megasas_instance *instan=
ce, u32 MSIxIndex,
> 				if (instance->ldio_threshold &&
> 				    (megasas_cmd_type(scmd_local) =3D=3D READ_WRITE_LDIO))
> 					atomic_dec(&instance->ldio_outstanding);
> -				scmd_local->SCp.ptr =3D NULL;
> +				megasas_priv(scmd_local)->cmd_priv =3D NULL;
> 				megasas_return_cmd_fusion(instance, cmd_fusion);
> 				scsi_dma_unmap(scmd_local);
> 				megasas_sdev_busy_dec(instance, scmd_local);

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

