Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CF1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 21:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbiBNVq4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:46:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiBNVqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 16:46:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFB0D119F10
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 13:46:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EIekRZ028536;
        Mon, 14 Feb 2022 20:04:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=5vNoko1WBLui3dCVCo6Cuh9SuvrB8faH0BSgoLd/zUo=;
 b=qHRBA9PBMXfS73j7jkqx4sGWSNuKlbyh5ExCWaYbn4RltymzB2W7d9MPKKz7AHnahksU
 SLf2o4GnK7A9HcNIlgnIBxp2/nB9/M4eEtAY0Qdm3C90KqWglQWh9bA2T3LQjkSq7en+
 BdEBZQMv4cjUG2v1v3eZ538t/1K0hiWsJylv7eOGDn9aaVWUjMCuqh5qTuW71A78L3KM
 P5Wch4eGH7ddqNMkqi+wt0O2wyqtnhPA9Dv8oIvOoCKedY+KeKSOigaSiAHNJ705fJxO
 xX5eVNSfwMVtB1gWWTtzPs8oOq0viJEa0AbAzJHzPYMMVy9Y4fELzLAOtxKGjtB0UoX3 tA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63g15q1u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:04:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EK02v8061096;
        Mon, 14 Feb 2022 20:04:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 3e6qkx8dsy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:04:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dtvYQkW3xIfCx43uk9/evmuPISusSzT+yQZxpdPJj2VmMbs4OOpPXyKmBz1GQNxVWo80hQ6z7loaFUgULLk4GeajX4nlNIK7dSFZmKoDd/qGYSO5Q37XPDNEZp9KJDBknL2ALB9WDQwMdJfgrenRNS+KfvQz4/lUBE8tDuYEhF5OJjD9DwRP6amAUFspbJL6OUSm21HVPd2NEK4vuQc1OJ9V5Kh7c/Ka/rkqSRmFIDJMqlgn3aGj3BoSrCcBGjuISgcrcMDcIwzQHon5dGwpshHlu82EoRLNNtCq2ZbjIdUMNRjKthXryMgNLsFGtzd1z8ZUCUo1w+S4iYHgOooeJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vNoko1WBLui3dCVCo6Cuh9SuvrB8faH0BSgoLd/zUo=;
 b=X3OKZEKBQWOMnBc7kt7j9oxCuXkY2sPgL4gKYaY017T7drVdL5uNgXS9i28A0GENx/ZCaefe1Bn31OpXC4HNrnPw57xhAaRCm/DgCg1kQJ0zPxqj7wYOmC4BFLBVo6hui80mS9D3Go60KnPuAnsqy+ADIjplemBzo9MzmOAN8qIpvPoi5Oho80A8DWc3MI6MpD25G8uvcvfzwRf6/vrBQPNA04sv5v4HyTzcAfBtMDb/dhsK/xQEIhXpyKQLsYMreTg8u54DFi4y/o78MCx1BokmTH/DjxtrkxVtCa7tYV94JTMMfpD5Cey4ZmV/5oPpOrCstaaGidX3vDlvRYU35g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vNoko1WBLui3dCVCo6Cuh9SuvrB8faH0BSgoLd/zUo=;
 b=s+N44pYo1FcwtGZy6H76IDOgugRkBi7/ofpzvfYCig1QakCmwhMRFCShT9xV28rDyulgEuVAVdjmC3FS7EVvxsyuuLiffDMfK0rq6HbcJBwouViRNxjJAiE6kbkKyx5MaU2NrJwxa+9C4tYH5ZIL+CwG18Jwc3xxqF0lOsP+GCc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN6PR1001MB2212.namprd10.prod.outlook.com (2603:10b6:405:2d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 20:04:05 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Mon, 14 Feb 2022
 20:04:05 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 04/48] scsi: nsp_cs: Change the return type of two
 functions into 'void'
Thread-Topic: [PATCH v3 04/48] scsi: nsp_cs: Change the return type of two
 functions into 'void'
Thread-Index: AQHYH5dbFoJVxMj8lE2kCWsGGAUWt6yTfNkA
Date:   Mon, 14 Feb 2022 20:04:05 +0000
Message-ID: <CCF8C240-8C13-4C80-AA76-D6B91BA0DBBC@oracle.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-5-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-5-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33ddca2b-8abd-404e-7266-08d9eff52751
x-ms-traffictypediagnostic: BN6PR1001MB2212:EE_
x-microsoft-antispam-prvs: <BN6PR1001MB2212C6CB00C3AA80FDF9EA8BE6339@BN6PR1001MB2212.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MbYapdggjqw3xn8qlruNoDLJSTlP4ekrc7anNX7XGuyP4Mbq/ZB0B4T2xdrroBxbWsEZQbWXWKc+Q7nnX/EJ5XDVTub254GyUnhaHYqL9Bj7nVT2fi5f4Bnp/ED3i9u0dQsTB38tkmD8ln4c09ceNz0khCFPy0CAfrho2J6REfBdsyZM322gACHgb1ATF2NphxKVXdQMNfJ1GtII0qxMV+3WK9sIdQJNIzTQ2A5LlLOjET95PVUprqBVnSs3Ktl9qvBUNG6O2mdGsGtrHl2viKaV6vYcBnpHAjsGbz4s3LjRdkrlGRTS8EIY33/oJDhCV+dQ1iJ5Rcum8LzI23G5ANUldjg1eIL75BsxFXkFZoWbeu+xWd2i+DXS65/6Pyc47wmI+cWIfi30zuxk5DFXN+v8bDThJJl0W0lC5i/CdK5KAUt7v0b0ZcmVqc5slITDQgoGfHYrxnZXOtRfcaTo9DN20Lhml3dUxP7h9WU3Ev4qW9uJkq7InHaFYsFDuO4iE9O7D0vvYGXzOewctzREcT7eQXx9fNvgXdvS/tZH4rWJaueYWg/49jtq9uhulYtSIveZDRMc44iHgXeOfYiBDWb6F5KmJtuh5tCIGCn2aoHaZaCyOaq5dVjbVzKN224Uh3+K82XXHGYIl1jgEe1GaD2V28rdkGzqoqRnqGEw9aisS0CIYqQTgNPL2hAqYsAidlfQLZzvomZoY5lUI1FitB/chahad1iZfrL2zQc/8sc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(71200400001)(38100700002)(38070700005)(44832011)(53546011)(8936002)(6486002)(66946007)(76116006)(66556008)(36756003)(33656002)(8676002)(64756008)(66476007)(508600001)(4326008)(66446008)(91956017)(6506007)(186003)(2616005)(316002)(86362001)(83380400001)(54906003)(2906002)(6916009)(5660300002)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zWmQAjLFSmywVnHgPyFlgBHu9QMDxstuY3E2EXpOdmNY7t6kNVSP3akM/mI+?=
 =?us-ascii?Q?ZE0YSwHIT92E5UOTCQxo3QR9jR/AfeaIDeuqh9B5u7qyMBd+mU7s2rPcMW59?=
 =?us-ascii?Q?NYqDoO9uLzkq+oF+y9e8yYRNphm2WLaOXtmElFgSmfV+fjNmScH1cEftzQIC?=
 =?us-ascii?Q?SjEAZNu06Cs/e5VN7UHvwk+GbXk7TaT/KkEqEgqCl2KsL/mxJj4I8gw6CUx8?=
 =?us-ascii?Q?Z0dP4/2Fq0WaxrN+oLIG5NJDqzKsZwMPPyjk5CQMQQZXC3iOzrLfF45QfLRT?=
 =?us-ascii?Q?1i8/TNuCh/jl2L9TxWHqOcplNM2UfHhQgwp3MiLAfA6roSOg3MVvL6/gfvFu?=
 =?us-ascii?Q?qz/bBd5dWrEyxONa3NN9KNAuufFH0ycx784mAwaT6xJHMxGBZGQ5yClVpG3I?=
 =?us-ascii?Q?df/+mLSBtnnjHJjPpTVdUVzksjbsAi3gKJWR2nPm3e64fXJ72iTIF9ueYKEn?=
 =?us-ascii?Q?5/90ioKFrnDCsAmVVCWpfgphw8kPEMQDvPe7eULnCqFw4CjaTdAoY5GDEsBR?=
 =?us-ascii?Q?CNjj0fk/YmadhJE4vICeQ5kLoOllLjmuifbDsU+7wEy7wqHWBCzjWuC2PcI7?=
 =?us-ascii?Q?a2jtmaCgKjab1GYFgUUEYEHokncTS65SqwZ/MN/6j8QC8zw82+roQEGCaDAC?=
 =?us-ascii?Q?Xv6Ak4Zv39lG8ARDPHEkPoBeZf5plto0uNfFhwXvyPrNwNm7qdt+BxhbTUaI?=
 =?us-ascii?Q?cKrylDXJB0RJEVs15TV1ew/tDZ8PnDBow8LbkXk88fBIe9UmCP2QjkoFAdRE?=
 =?us-ascii?Q?MzlREJN5szARzOj4alhx10IL0HKI2p7ncAhqRn9QtncUuoWV1n8dN51fhcTN?=
 =?us-ascii?Q?vBnyhI0YqP/qvfN5SfS+b4b4DdaegqsoGARNg6CrTN9aalskCaNP6NswfuY9?=
 =?us-ascii?Q?stNOQKgtAHVjdE4Dc+tt6I+GpuaecRWLvQFC6xypTviKlnWVVxXlspbZOpIe?=
 =?us-ascii?Q?bIKjzg5xac9gnDxiox57KNMTjNeYkTwgyxrmuei97VeuJZ93kMfIHZJE//F4?=
 =?us-ascii?Q?vXySEMe7FO1ymT3TEz/3AJf0C0ZECdgyEi5hECTKSV9PJ68Yk4JcNXq+vzq6?=
 =?us-ascii?Q?dKSKAviFg4U7E/llv73vYtzj/4qqPqqKoS2W7pGbyhh9P/G1leylKL8QzBvO?=
 =?us-ascii?Q?p7h8hKwu9zoNCIfYzOxhhCv2i+XIJiJ3CKUibLaxKjHqhUzKDUEz2cfKUCQe?=
 =?us-ascii?Q?ym7lRNcccHPlWYjQ39SIaW0VF/2uroXlxN84oXZRj4TEtzs3DmyoczaXcW92?=
 =?us-ascii?Q?vum8uG79KgTafiO5Jf5VsgscQRSX/9K+/qq9Yes/6eZxSGu5Ewen5szbS1va?=
 =?us-ascii?Q?seT5nYofVTFLwj4lZL05u8aEXmGoxWGD/PV6qp4/+bekNV75oE+ygZc5yhw5?=
 =?us-ascii?Q?DYbetw7HK1cBKjj1+B7sVffIjfUaT9oI3vmKwfDzmhACFUf/Ws/50MXCMsju?=
 =?us-ascii?Q?dnxYJbK7/f7PmL6qyieWNvsA8mxdSeK7077GTV/fc0UZzbBnKNRtryO9sRtH?=
 =?us-ascii?Q?YM8intwnYGDTx3o8gPJ+LEv0StCgaIYepWb/k8bq+LGpKGh0kaEWJ1Kl0sMW?=
 =?us-ascii?Q?dpKZMn8WO9/PCwVluBKR7IF+6FBuUPXLmB8MvncqmYRHv/h9scfH3hbXli9l?=
 =?us-ascii?Q?VvQ9Nt5LKn2Ux6xiQm5AymyqHLzjcHBzzsQgP/IR75vx0LCkx+YAkql3RvrO?=
 =?us-ascii?Q?vck2UZ3OFTFXJucdxuR+5j1q4qh5IANGiarWaWofDfmKEgd7?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D5E6CE742D9FB94DB0EAB0EB69D793F2@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33ddca2b-8abd-404e-7266-08d9eff52751
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 20:04:05.4217
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aJmvyF2eaIv8lTSeekru3wB2NWUzinWNuUhybAmo93SKH+mEYjb7eVixioBRYifNDLZMJLX2KJDEeK31D/uXEuQPdLiopQP0jym0yCGZB14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2212
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202140116
X-Proofpoint-GUID: daHxoKplywZ3NHBJIdUU4krM2srsBTGO
X-Proofpoint-ORIG-GUID: daHxoKplywZ3NHBJIdUU4krM2srsBTGO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 11, 2022, at 2:32 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> nsp_reselected() and nsphw_init() always return the same value (TRUE).
> Hence change the return type of these functions into 'void'.
>=20
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/pcmcia/nsp_cs.c | 17 +++++------------
> drivers/scsi/pcmcia/nsp_cs.h |  4 ++--
> 2 files changed, 7 insertions(+), 14 deletions(-)
>=20
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index 92c818a8a84a..a5c2dd7ebc16 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -298,7 +298,7 @@ static void nsphw_init_sync(nsp_hw_data *data)
> /*
>  * Initialize Ninja hardware
>  */
> -static int nsphw_init(nsp_hw_data *data)
> +static void nsphw_init(nsp_hw_data *data)
> {
> 	unsigned int base     =3D data->BaseAddress;
>=20
> @@ -349,8 +349,6 @@ static int nsphw_init(nsp_hw_data *data)
> 	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLCLEAR);
>=20
> 	nsp_setup_fifo(data, FALSE);
> -
> -	return TRUE;
> }
>=20
> /*
> @@ -643,7 +641,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCp=
nt)
> /*
>  * accept reselection
>  */
> -static int nsp_reselected(struct scsi_cmnd *SCpnt)
> +static void nsp_reselected(struct scsi_cmnd *SCpnt)
> {
> 	unsigned int  base    =3D SCpnt->device->host->io_port;
> 	unsigned int  host_id =3D SCpnt->device->host->this_id;
> @@ -675,8 +673,6 @@ static int nsp_reselected(struct scsi_cmnd *SCpnt)
> 	bus_reg =3D nsp_index_read(base, SCSIBUSCTRL) & ~(SCSI_BSY | SCSI_ATN);
> 	nsp_index_write(base, SCSIBUSCTRL, bus_reg);
> 	nsp_index_write(base, SCSIBUSCTRL, bus_reg | AUTODIRECTION | ACKENB);
> -
> -	return TRUE;
> }
>=20
> /*
> @@ -1057,9 +1053,8 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 		if (irq_phase & RESELECT_IRQ) {
> 			nsp_dbg(NSP_DEBUG_INTR, "reselect");
> 			nsp_write(base, IRQCONTROL, IRQCONTROL_RESELECT_CLEAR);
> -			if (nsp_reselected(tmpSC) !=3D FALSE) {
> -				return IRQ_HANDLED;
> -			}
> +			nsp_reselected(tmpSC);
> +			return IRQ_HANDLED;
> 		}
>=20
> 		if ((irq_phase & (PHASE_CHANGE_IRQ | LATCHED_BUS_FREE)) =3D=3D 0) {
> @@ -1614,9 +1609,7 @@ static int nsp_cs_config(struct pcmcia_device *link=
)
> 	nsp_dbg(NSP_DEBUG_INIT, "I/O[0x%x+0x%x] IRQ %d",
> 		data->BaseAddress, data->NumAddress, data->IrqNumber);
>=20
> -	if(nsphw_init(data) =3D=3D FALSE) {
> -		goto cs_failed;
> -	}
> +	nsphw_init(data);
>=20
> 	host =3D nsp_detect(&nsp_driver_template);
>=20
> diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
> index 665bf8d0faf7..94c1f6c7c601 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -304,7 +304,7 @@ static int nsp_eh_host_reset   (struct scsi_cmnd *SCp=
nt);
> static int nsp_bus_reset       (nsp_hw_data *data);
>=20
> /* */
> -static int  nsphw_init           (nsp_hw_data *data);
> +static void nsphw_init           (nsp_hw_data *data);
> static int  nsphw_start_selection(struct scsi_cmnd *SCpnt);
> static void nsp_start_timer      (struct scsi_cmnd *SCpnt, int time);
> static int  nsp_fifo_count       (struct scsi_cmnd *SCpnt);
> @@ -320,7 +320,7 @@ static int  nsp_expect_signal    (struct scsi_cmnd *S=
Cpnt,
> 				  unsigned char  mask);
> static int  nsp_xfer             (struct scsi_cmnd *SCpnt, int phase);
> static int  nsp_dataphase_bypass (struct scsi_cmnd *SCpnt);
> -static int  nsp_reselected       (struct scsi_cmnd *SCpnt);
> +static void nsp_reselected       (struct scsi_cmnd *SCpnt);
> static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
>=20
> /* Interrupt handler */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

