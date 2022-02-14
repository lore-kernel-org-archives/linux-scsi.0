Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414A2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 21:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231171AbiBNVhR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:37:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbiBNVhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 16:37:16 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478FBED958
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 13:37:07 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EJR6bT003911;
        Mon, 14 Feb 2022 20:09:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/FHyB2I5+YzsHjJo1sdWNG2vGFO0nFNwmr//qhAShek=;
 b=alWD5/fvuonizfuNW+lEA+G083wg9BCPzpZObgg2nn5zO+FUDVr2lbYGQjdDrvwsKnsA
 WlAkMbC9pkPhiMn+ezi8F8lKafwz1XPnqDQuFbF6xxBi8jehSFHGCqVjUkVTuD+OoKFE
 GCW70yUmu5RU/I9WlHuvAET+gx7VtTMfwtT8+fYcAHse0gbIAGTtNFvYh9fg4Je1lo9y
 vJcZmekgeWdGRAKFqrUrqeu1ZVtlYxS8b46soRlmbTB5kx2+0PzlOpOJZl0tC4NN2yJ2
 F7BEXTqsoQo5qTzBlU05R6CHJEMCYGg1X+FW2LPnc3+bjF9DmYua9SJ8PJs8lsnmXKR2 jA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63ad5m4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:09:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EK0Qs5133168;
        Mon, 14 Feb 2022 20:09:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by aserp3030.oracle.com with ESMTP id 3e62xdp4dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:09:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+hlrOoRTzR3iC3dkW7cs1cl8zOrIJ2zMaNkdcfXbORlvmnjZV9lzUuZOQcpuMReZdZj2uV8QUJnCtfiP5xuGTQUZ1J9feYkImnxexnaplQk3q8RrmM03mZ10MzPtVs9DduuwrtqJpdo9iE9rmVowqtWcCnGKojC1OsTlZ01l0j1FC98e1QnnhZqQybYWjNTQL+Qk/fvzO+LY+foqR+DLgiUUpMtE4lfWe6njDyVRNhmwfSLe6ysPlVRVye3z+0WnKiIK5E+IrCXLBu2rzhwfZE8BhnRgo1QMJtsjrPjBM4efaZtETU1JehllFuSUXwLyR/4wMg8Jkckm+uHIqqNRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FHyB2I5+YzsHjJo1sdWNG2vGFO0nFNwmr//qhAShek=;
 b=lvhWAg4b34LUzLcG+HlMRjWVWg+qF0J53E/YYYmzzWdz3zKTkchePAqPzrzh2wt9JF2wRw8bDBt8Sh5MEJUVuD8s8LlJSK9wFI7S/ILMyrUfKudjeVH03ap/8YOzvw2heC+t5medDi5fIkRa3bIhPcOwSqgCUk5Olrw4dfCRqKwCjD0o31wAwwnBZ6ur3bQklBCbNdFaDNocFVl/E5R0fvp4Z7d1VawIeHLCp1/Ydi9EOjrYRLRrhsA2iGaT3Ag9Co1bIbp1coKQq3Ouu/On+hdMMFfkQA9IpoobhjTLE27AdO6fpc+ogRsfe/n1CGj+nY0tye9B5Tl7Jaw3bnmpAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FHyB2I5+YzsHjJo1sdWNG2vGFO0nFNwmr//qhAShek=;
 b=qVTfxoSKdLlnWsfmzeOCSkwWy5TVA6AyOXBUora9EPjsq89hVDP7qk1TrzCNKs5yRUA8G+NQwQ/sJNfNvjyhR9YaQGOHAzfMpHh2JV0xKtWEs9lIRDREvVyk94hdPgGiRXYbcwixyw9OSk/Qmle7p58Iz3SEfK1BKhCNqv8mg8w=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR1001MB2212.namprd10.prod.outlook.com (2603:10b6:405:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 20:09:45 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Mon, 14 Feb 2022
 20:09:45 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 08/48] scsi: NCR5380: Introduce the NCR5380_cmd_priv()
 function
Thread-Topic: [PATCH v3 08/48] scsi: NCR5380: Introduce the NCR5380_cmd_priv()
 function
Thread-Index: AQHYH5dlFZGVNVBjUkO+WSq9hPBWzqyTfm4A
Date:   Mon, 14 Feb 2022 20:09:45 +0000
Message-ID: <B9F1E0A6-1BDE-4422-9489-215D280C9000@oracle.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-9-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-9-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59ad1cf6-3e6d-49b5-0f28-08d9eff5f1e5
x-ms-traffictypediagnostic: BN6PR1001MB2212:EE_
x-microsoft-antispam-prvs: <BN6PR1001MB221210D6047D2F19459C9130E6339@BN6PR1001MB2212.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bU/ImGiIVGXbbSjMbmryAavrWhVEp3WfgmF0gNT5IlVg13ndIpUYU/mFUpqrqqwxS07flLMtoFXopmr1PlTRv1Id9A4YkfivAtdu7jXHcImvdwNir0eOLM6I6AnkWGl3SxIXaeLwgWVMnNmKB1FW9fYMloZeON5kalvPYXpVpx0oiLsKxsHR7L3GiCvQxpiT8D7Z+6PpDN8jpdhVdMcN8dpucOOm8M6LsXcXS05umBiRIqdVXgGv7C7OhpI2KKf68JYT20YUS2awKXwKT29QUVK0BR9AYpRJZUSytRPmvAgDYJUNHAQoLerL3jMHPIlAW6ymIRT+kliHv4tmT3mKVd1ryc4FbyYa/MKdwGoHJG3Qhe2p6jiCWQDsqwofSrTG+TT6gHlS+NlwB5zfSqJabjSQ9bEu5YGOpeu0krniKxyZ9xfmtp0kSaMC0yVzxZDE65HiBJNDDUECfg6jEb9BavVtXvIpSe+1nn2N/hRiJaao8GTc53Z7ktvr7X8Gq8kRgIXq917RSgIhHyf9ph8Us+our2OSKVw+n2CHxVxIRFmbxk3SoJncuEj8N1bwaKz5SsWDWGi8ITbQK501maI7n35OJvhBF9P517EQUNHvicF6qWQOQOlqIo/Kl5s/R7oCN4Zbtx0PdCZyQXPZ6rcuYCFH7f4gn0hXaCfjEEO4zTnYJZz2GNf7NGvge3nP2x0m3YjyMGOinJMzQNDn5pTxA3Ex5RXVz4NWFDVviqPulX1wkQJdMvdRJm2ggPEAW70f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(71200400001)(38100700002)(38070700005)(44832011)(53546011)(8936002)(6486002)(66946007)(76116006)(66556008)(36756003)(33656002)(8676002)(64756008)(66476007)(508600001)(4326008)(66446008)(91956017)(6506007)(186003)(2616005)(316002)(86362001)(83380400001)(54906003)(2906002)(6916009)(5660300002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JsM7dZehEzfoBurfZeTM/jowk0VjykMWb2Es8r+kld7jZ/fnt3UQub9GsLZv?=
 =?us-ascii?Q?9yW8mXUKAo3DuHPjQq3uLEB+lJSlOjZCUloCwUObmLSLdY5TwWCXysSp+GhC?=
 =?us-ascii?Q?vWcAGvl5ZGnZ88QbXBCI95H6dlW0vkNMl2AavunZW1nZYUjenTSAWQtvq1wT?=
 =?us-ascii?Q?YfYXhsLO1vM0UlHcBJHnetg87YF5Vy8tRs4c9c2Yfv75j4ibrDsvjhtInVp+?=
 =?us-ascii?Q?l3T36UhIdB26MUBsa4XTvRYw3EU2dloMv5ftI856K1HsjbClslFopL86uBrh?=
 =?us-ascii?Q?0CFcY5z3KRsw912pfDTNAaTXoCCSVZTdQwP93On8DvFkbI9zD3ywHa6V7Sjo?=
 =?us-ascii?Q?eDD0pvRD+L9j1Zly9qdiysJbTsmgDuNiffU2jxj/7u0oJA7wY+lxLcTAeSES?=
 =?us-ascii?Q?eyWXbqcNrcUiao3V43evkoaYs6hl8vdCM924nMm93LPNuHbXnjI+zJ38meKB?=
 =?us-ascii?Q?WWgvLMNKGeOUKit9LUy3jg+OihSHEbTt5uXpq1z4zXyQ8R6ATLbf0dgMIdth?=
 =?us-ascii?Q?GyRdDT8K0bvtLBRRYAlUOzuGosTNZKgVS6MEwC/0CN4jh622k4gcDRccaXrO?=
 =?us-ascii?Q?NvRdaN9u7drzw+Egcj627Q6NcP65lOui29jMc9zI03ldNXsPofJTy9ZrDQp7?=
 =?us-ascii?Q?oLxTkcnRIm9nQfosL7yuocKr6BW5ty/VFju2kIHJLElcHpLg8SGVrGnIUb9B?=
 =?us-ascii?Q?CAnxLJF1rXxA5xDnFAqlLp5h85kC/yXJ57mgG2lHLP+si2fuFmxxi9AJLRnW?=
 =?us-ascii?Q?PJu1i2i5/XoBHIikf77zvfpVotsMjRQ98AubZr7ogtVBO0RSjcmRzzNzBrcc?=
 =?us-ascii?Q?xg0gUGe45vScn5UJLq2CzKs5p5AcqXvVFTdC1wiA55ydJLpq2VbHTZ/e150B?=
 =?us-ascii?Q?1pkMsLozuF+PkgBsCSFHxuucNRc9fx7HNSW6S9GYiRaxORBQY0gjDmLlbQVv?=
 =?us-ascii?Q?oy9nPA5YiyuBcrCBaX3iyVA0G4NPD5vw+1p1FL3kdk8+E5M06iDLfEd6ALo+?=
 =?us-ascii?Q?TgbbpkJ95VsISkZK3//Bny86mEN2meEYEZRxGram2Eo9cay97xPNpPSY1ySG?=
 =?us-ascii?Q?pIdv5SeAu2EyHxE8Or/B5eGpYIybwoNLitwxsiO3NwZJiuLDXUK9ARQOI4ii?=
 =?us-ascii?Q?+f1EPjaypJH/KOUaZwaEvP97W8DWIFLnUpqhkm07BK5Ii6gwd7/wI5Cpj+cj?=
 =?us-ascii?Q?vqpZbR4JCJI34oZ/C1ZSfz+NG9mJEt9BrCRfb+cC1ue5RBGL6dCgQGF9VTKV?=
 =?us-ascii?Q?gmGYI3Fw7u+L3qQ5r3LpcYRHzZSeB4APH9QjSM9/mnFPVa6n0PmijNuWJ/Oe?=
 =?us-ascii?Q?foS91+4bLKD2dbhWYZnQsdc0crCiWCZEBEdu1XUiG3dj//XVV9yBpJAtOWlj?=
 =?us-ascii?Q?mPb+HaeRakgKOHORWglfE6dCeikZh+X1BWALeQNpM9eE9LWG41rENILiyh5P?=
 =?us-ascii?Q?apj3aKWoAm4t0MHAIx/FBMRjh5m7uZ5Vh8MYu3U7ghX2KHrzf7Mhw1LgtAsD?=
 =?us-ascii?Q?9aRvBOvvR36ykndcDlmFw8OeNuGbhbAWdb8N0XDl9BtmQQKJ+kdaFeloqAHJ?=
 =?us-ascii?Q?yJT/pMO2OM+06x0fvpYJQ7JGMSJQiGJJxRAjLuwws4+536wLho4hCKe7UyTp?=
 =?us-ascii?Q?EMLjZQ6fAl1MMEI4hgusigZ4if9cPdPjlUr3cG/9X8w5RN/5FKKVllqP5gms?=
 =?us-ascii?Q?gct5IryPzW07TulLD6JHQXuwmnNsf7u3KJDmjYDq6RWPxqjJ?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <335FEC71F1EE8C4C8211AADE1673751A@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ad1cf6-3e6d-49b5-0f28-08d9eff5f1e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 20:09:45.2420
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M3pDle1B5U2lN6RsYDP7yiLSocwEk6Sy+pvmtV+mdBtVEWNH9Wb70VkGJhF5lg1pewKzwpJrVc69et9JxObAoG8i7q7eez1GsDLWXSsGQ04=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2212
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140116
X-Proofpoint-GUID: _AfQyjY2CVcCslA_s4ZPxFGWOKmzNnf3
X-Proofpoint-ORIG-GUID: _AfQyjY2CVcCslA_s4ZPxFGWOKmzNnf3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 11, 2022, at 2:32 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Introduce the NCR5380_cmd_priv() function. This function will allow to
> access the SCSI pointer in the next patch with a single statement instead=
 of
> two, e.g. as follows:
>=20
> 	struct scsi_pointer *scsi_pointer =3D
> 		&NCR5380_cmd_priv(cmd)->scsi_pointer;
>=20
> Cc: Finn Thain <fthain@telegraphics.com.au>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/NCR5380.c | 8 ++++----
> drivers/scsi/NCR5380.h | 5 +++++
> 2 files changed, 9 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 55af3e245a92..6fa5e363945a 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -564,7 +564,7 @@ static int NCR5380_queue_command(struct Scsi_Host *in=
stance,
>                                  struct scsi_cmnd *cmd)
> {
> 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
> -	struct NCR5380_cmd *ncmd =3D scsi_cmd_priv(cmd);
> +	struct NCR5380_cmd *ncmd =3D NCR5380_cmd_priv(cmd);
> 	unsigned long flags;
>=20
> #if (NDEBUG & NDEBUG_NO_WRITE)
> @@ -672,7 +672,7 @@ static struct scsi_cmnd *dequeue_next_cmd(struct Scsi=
_Host *instance)
> static void requeue_cmd(struct Scsi_Host *instance, struct scsi_cmnd *cmd=
)
> {
> 	struct NCR5380_hostdata *hostdata =3D shost_priv(instance);
> -	struct NCR5380_cmd *ncmd =3D scsi_cmd_priv(cmd);
> +	struct NCR5380_cmd *ncmd =3D NCR5380_cmd_priv(cmd);
>=20
> 	if (hostdata->sensing =3D=3D cmd) {
> 		scsi_eh_restore_cmnd(cmd, &hostdata->ses);
> @@ -1690,7 +1690,7 @@ static void NCR5380_information_transfer(struct Scs=
i_Host *instance)
> #endif
>=20
> 	while ((cmd =3D hostdata->connected)) {
> -		struct NCR5380_cmd *ncmd =3D scsi_cmd_priv(cmd);
> +		struct NCR5380_cmd *ncmd =3D NCR5380_cmd_priv(cmd);
>=20
> 		tmp =3D NCR5380_read(STATUS_REG);
> 		/* We only have a valid SCSI phase when REQ is asserted */
> @@ -2206,7 +2206,7 @@ static bool list_del_cmd(struct list_head *haystack=
,
>                          struct scsi_cmnd *needle)
> {
> 	if (list_find_cmd(haystack, needle)) {
> -		struct NCR5380_cmd *ncmd =3D scsi_cmd_priv(needle);
> +		struct NCR5380_cmd *ncmd =3D NCR5380_cmd_priv(needle);
>=20
> 		list_del(&ncmd->list);
> 		return true;
> diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
> index 845bd2423e66..88a1bb41b72e 100644
> --- a/drivers/scsi/NCR5380.h
> +++ b/drivers/scsi/NCR5380.h
> @@ -230,6 +230,11 @@ struct NCR5380_cmd {
> 	struct list_head list;
> };
>=20
> +static inline struct NCR5380_cmd *NCR5380_cmd_priv(struct scsi_cmnd *cmd=
)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> #define NCR5380_PIO_CHUNK_SIZE		256
>=20
> /* Time limit (ms) to poll registers when IRQs are disabled, e.g. during =
PDMA */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

