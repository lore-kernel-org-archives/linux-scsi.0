Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67E8AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 19:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbiBIT3o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 14:29:44 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiBIT3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 14:29:40 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D78D4E01566A
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 11:29:34 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HLbta013346;
        Wed, 9 Feb 2022 19:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=RuvGUjaM09IPPenSH2KTUbagi6pdlqhAz2qgRP403sc=;
 b=bHABSA85nEKrqkKS7lQEBGZDnqrh3KvIzO6c3znKJlys6z1r5r4ce3ddZgvzw0FRadrX
 76g7bKvg5OZlt4wvNqegpVICQPf4gTBDPN7tEsupjmJP2WYE9scpoD4WOP/cxTb17ign
 4s3ku2J6h2+lnIHFo4HEN8lX8oYKsyj1onR2iKiTFk/qwwQhjcfbEEDlfWrF0BLEJYZZ
 fqUCjgDgZrqmmbYD0my9w2q6ilFZ7BiHOPcUS3UOmJ5e1KBQuqO0/Fy5b2WO9dvC3/N6
 KgohijNnszOeY6AGZ32I8UTg2NmDPyFnAvq8AbFkBVviBqiAGNBEpsLRVPUQqBkA/q61 Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e368txrfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:10:40 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219J6Ajp120357;
        Wed, 9 Feb 2022 19:10:39 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2049.outbound.protection.outlook.com [104.47.56.49])
        by aserp3030.oracle.com with ESMTP id 3e1f9hwbfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:10:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klPAT5Axscajua0YOymuvWG2qtbBzGf1DOkpFIoczAs8YMHYGw2ei0LMljCfYbyG4eqa3GJknooRt0IwslHogbxw2z28GcvK9NahNp2Xq7Z4bjxnlzGBAuZyFw/8Cmu9fSaaHNBbKjkR/HptJ4H60LG37/T2kKDBOzyMyf8pyJr7vT+f6y16updQKeZ098m/8yFHNaGoMtQ3qLOgcazTZvZDtYC8JwFuGDWbN5ou49spe/1m/V26nKt48IxUf4X+erH2npMv8o6C4m0hMy0n1LinwsCj/UZXqVH9O3BhTHwzqzy9iAIJIKUE0Pb4tsCRGJ9OzfriuGpKZ3BCglfAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuvGUjaM09IPPenSH2KTUbagi6pdlqhAz2qgRP403sc=;
 b=MznC0IfdpUcg2Wr9IfswK3yvCsYDh9XNLGXvlph1rs5LPb2WhFIVDX5S2Znev4nLIdJ3jYrUWs4q2C99mnwIHneqH2ESyo8aQsLwN5rYR9lol2h2OymGD7eMMgOjvk95QYvWBf/6amu1Yk3S2nwJZTmEQun1yThK1fdcn/PwvwD2+C38ENTidTN7vuLX89UfohApZPUipplr0cVy7ZGBa654cHCX65dc1AkWusnY4N0jbCUHiTWtPoTK2+R7zOJu9TQ/j6ZwnBdq7B8z9arYYcLwmiCvaHocedT5SX666QpalWXivk6sIWmGNbNRNZYmOQpHu5rQ/qSV9yceLLN+zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RuvGUjaM09IPPenSH2KTUbagi6pdlqhAz2qgRP403sc=;
 b=ChsXjVRBWfxY1+wNL0mOWD8MpYvL2SXyMqqEx6WSPBXTcnqHaATaPglg4OYntuue2cS9FsjQuIbRKjLgAc2JvvPQ9OwJ4CIZnFXBrU9lmPlXxVSYEHCqHQTyB2A9zBkNUcPWnCYTBTa5mEsQD3tuc/jRTMYYoqivm/o96GC2uak=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB4098.namprd10.prod.outlook.com (2603:10b6:408:b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 19:10:37 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 19:10:37 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Reviewed-by : Johannes Thumshirn" <johannes.thumshirn@wdc.com>,
        Matthew Wilcox <willy@infradead.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 39/44] sym53c8xx_2: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 39/44] sym53c8xx_2: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHRGD/LqweZ9IHUWctnTvnr4B1ayLl0wA
Date:   Wed, 9 Feb 2022 19:10:37 +0000
Message-ID: <3F99F2C2-B9D1-42BB-A78B-7968372D8D44@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-40-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-40-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c9b67b1a-3d41-40ee-54ef-08d9ebffdafa
x-ms-traffictypediagnostic: BN8PR10MB4098:EE_
x-microsoft-antispam-prvs: <BN8PR10MB4098645E3F0F6D588BCE84D0E62E9@BN8PR10MB4098.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8L18xUJFV+Cc9bIt0mvV3liMUSSLJbB9D6NKPmI/yyMZH5vLU2MHUwM7V7o6fuTruzBsKfanNrWXTGly071xmVv4339mdPFU2mV1BcjMCjlGvXSwqMO4OfLf5Tm8+HB/zl7Ua47crs7RvekwOO/VEgZAsNhBR+aecmoAQucw/puXiFAhk6o/hKAkQEq/BoILGrrNkIgWfK8Ucj+pP1ZHspCspdZGcaXreay0/qdyVT4GqYRTz9iJVLWtMiPJ6LIGC2XtCMQUii86tdAijzK0+WqOTpF0Eu8B08C6uZqqt7YfBxsDndWUW+VvbenDXc9pjhSkbP5l8g/45Hn2VmtliRCkNrb8ZvPH8NLD8KdvLzbQo+8E5TtRLKW9y2VFDaoMRMphZaA7jkZfpBEswEOSwMSqPTz9yKAE1v5reu37zbBs2YGwiwDvyhVoH8G/WiUZGRcCqvLpClzmMs6Vm7Glg7cIBueCn21jC5HuoS0MOpND+FQ0XJ1oJdcah2nAf1JGGQMCsgAi7Fic1jI+DkobwXYrOV4RwWxhrm4XIH998G0CB8ZoWmzVpRLj9Rwqo6jF7lS75F29LzyMuZDit8youyDmIFWxfbGv3wdsCKjGzEL+EiE77vNnm0/tp8D6XQNN7YIhV9zh1lq/dm/jfcWF7XpgYl1UbCbidUjbN5XWQm/j3QemnuHrBBZFryHA7A8fn3X1+yBJFjtJesg6AFPn3ZIHp9s+7NK38fvA8buBVk8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66556008)(64756008)(66446008)(66476007)(186003)(66946007)(4326008)(122000001)(76116006)(8676002)(83380400001)(86362001)(2906002)(38100700002)(44832011)(54906003)(6512007)(71200400001)(316002)(53546011)(38070700005)(6506007)(36756003)(8936002)(2616005)(6486002)(6916009)(508600001)(91956017)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jYVLWl0sGwF1vGhiDzXblVPPY48ZJsotZjSyDg+FGVH1Qlg0R6q8quZ2cZW9?=
 =?us-ascii?Q?2JTzBypS+uiGigLkFMajM6h9lhWJNW4oAdWBtlgzIjjxGBIwJzSYVgXh3Nfr?=
 =?us-ascii?Q?swHOoZn6+HXCYxDQT2x+ZpH3I6AoB6DVDRUEx3IHFTpgscHGvLEASuBeoItJ?=
 =?us-ascii?Q?JyM8fFZPd6pfgMMZuMIlFiMffH5nLkmfi4y2g6Vqep+AiOU3+ti7uQSTce0T?=
 =?us-ascii?Q?S9jdfYhBaxxAZUuZt2uo02C6g06udrPRFxtCVl5RciOXRgcXb4WBjpABeXAG?=
 =?us-ascii?Q?tsFZM50TFLaHlawIVO9Urk3viTp+/xYMDOMydkNEL+4qMhVphCCsmam2aJ0h?=
 =?us-ascii?Q?i0a+9jG4UzZv+sPiebDRAEo/rg0AAJ/wFtX7zfpMB60e/TyW6PNJFqxtDgKW?=
 =?us-ascii?Q?m6FKt96W3dFGIA7stunMHe4rk9DeInye5O3Kzh+rjzs1GC3Zf2zvM01iWBRx?=
 =?us-ascii?Q?eLZ4hzmVsXxYnc97onYvgfYnPffPkdLOFewQl75HgGX67JxtXPIDMvYl5P7Q?=
 =?us-ascii?Q?EYm4EkkJha5w8aN0ACJBhiNVYp2OH2IwVcSbS+UfvloZYxH59znvtJjB7MSg?=
 =?us-ascii?Q?SUVzxTdgs8GY9T+4mD6kTUuWrkvos0hXJCEVFYP9D7X6/YZtxjSu8TQR2Suq?=
 =?us-ascii?Q?1iPrU9Fin41b7H0shu/Zlamt4pJK0JS1uJBD/0QYKIajtwyImAay35ELDhZy?=
 =?us-ascii?Q?MIOLwvWdr19gBoxIZHf62MQxOGIy++aWaCjKOJB8382Z7aYBZXGBNxwZXzOB?=
 =?us-ascii?Q?XdLX1EA5TNxtZCSlGDN3dNkqUFdl7GcXkslGT3EecEse81COpmgga18BLaby?=
 =?us-ascii?Q?pCq/o7Fh6OSI48ier0EXyfKHlp1W3ukC6+PZ0vgr4A3D4KQI679ccqUo5UQd?=
 =?us-ascii?Q?+CEqfBcxxdX9lYjSRHa/2AU2Np7yYWuRZC3ZPdwjS4ajVogGA+cHubZxQuxU?=
 =?us-ascii?Q?3vdIcIhZhDSYyKi+Kgj/NwLZvylEEmp+z8hDaqS9pG2jWyGnWdHHCQnGXhpE?=
 =?us-ascii?Q?rWYRZxSK8zTd1ino+gYTiNzbANHbcMkzzqDvzezGtjrhHcGO1KopqMsggoh4?=
 =?us-ascii?Q?vzhHuViN+/zPIBPMthj1Qjic0lUf0cz/kMU2K48SSwbwaijjb/jRzJ04Mp8w?=
 =?us-ascii?Q?4LuD9f1lOp6SWtMA83/diSdWjzEpYpTyJD/NqXOffiQKs0sbeMKpA44bb+zD?=
 =?us-ascii?Q?c7aMSxqKpdhOo9fjF/v0DSAZ3ozrXgz17ccyJl3lwi+pbYdriUS//fs8ybHm?=
 =?us-ascii?Q?kB8q4Zpsebiv0gStk/6yV07Hjrqbi9Xl+z6YPvSo9cLvYHTL9I5/O2YhctOa?=
 =?us-ascii?Q?gMSrmpR3pb1LGqX9o+T+/2vVRrUiktL07FltyBzCzf2RgHr/x98wZHPG+nDb?=
 =?us-ascii?Q?iWzMRmghWUE/d+Bs1bHaX0IG1cccWZ3dLdbj0biZL5AkoS3Q5JOARF1MgjM5?=
 =?us-ascii?Q?kqKQLpLh0iboYn1dG/22k8Pz5Aem8nBvU+TqWqTW9NvOoGGLOR9NoRdM/mnd?=
 =?us-ascii?Q?kYLRC/GmQFcCkqnJ3V0aArgikct43yZ1NFeb/isUP9mi+EtWXy2pPqdOquKC?=
 =?us-ascii?Q?V3brmhDYnN2cUkDIfwHoSaVN4kT49WZEi1DFg2ZbCNOUo/GQN5jX2Lx2/RmA?=
 =?us-ascii?Q?5BlUcFv8G/Jih6h8VPPpCBqE9Q5oRz3cMneoJ72hNqJ0LpmvyWrAASNEZqHa?=
 =?us-ascii?Q?EEQ1iL3bjv59YBmRBaPAbNSEK/aNWExU2QL5i5CpF5CMUWYQ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F15A92A0083CE441A922DBF8E5142AC9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9b67b1a-3d41-40ee-54ef-08d9ebffdafa
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 19:10:37.2037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /+UYMqUWIAU4Q7uwSxKnsiRcFQjQgPNDGp9myAEJlZeOOWG93h9XukGlVbRlfDbjsVsIp5U0JtCGg9oiTIiC9G1gEBM1cdywMMOOqafH0A8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB4098
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090101
X-Proofpoint-ORIG-GUID: ZQvfsOMrD2lfsZQkrTr-_sY8ek-51_Ci
X-Proofpoint-GUID: ZQvfsOMrD2lfsZQkrTr-_sY8ek-51_Ci
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Set .cmd_size in the SCSI host template instead of using the SCSI pointer
> from struct scsi_cmnd. This patch prepares for removal of the SCSI pointe=
r
> from struct scsi_cmnd.
>=20
> Cc: Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/sym53c8xx_2/sym_glue.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx=
_2/sym_glue.c
> index b04bfde65e3f..2e2852bd5860 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
> @@ -118,7 +118,7 @@ struct sym_ucmd {		/* Override the SCSI pointer struc=
ture */
> 	struct completion *eh_done;		/* SCSI error handling */
> };
>=20
> -#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)(&(cmd)->SCp))
> +#define SYM_UCMD_PTR(cmd)  ((struct sym_ucmd *)scsi_cmd_priv(cmd))
> #define SYM_SOFTC_PTR(cmd) sym_get_hcb(cmd->device->host)
>=20
> /*
> @@ -127,7 +127,6 @@ struct sym_ucmd {		/* Override the SCSI pointer struc=
ture */
> void sym_xpt_done(struct sym_hcb *np, struct scsi_cmnd *cmd)
> {
> 	struct sym_ucmd *ucmd =3D SYM_UCMD_PTR(cmd);
> -	BUILD_BUG_ON(sizeof(struct scsi_pointer) < sizeof(struct sym_ucmd));
>=20
> 	if (ucmd->eh_done)
> 		complete(ucmd->eh_done);
> @@ -1630,6 +1629,7 @@ static struct scsi_host_template sym2_template =3D =
{
> 	.module			=3D THIS_MODULE,
> 	.name			=3D "sym53c8xx",
> 	.info			=3D sym53c8xx_info,=20
> +	.cmd_size		=3D sizeof(struct sym_ucmd),
> 	.queuecommand		=3D sym53c8xx_queue_command,
> 	.slave_alloc		=3D sym53c8xx_slave_alloc,
> 	.slave_configure	=3D sym53c8xx_slave_configure,

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

