Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9214C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 19:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiBITMJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 14:12:09 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:57338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiBITMI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 14:12:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8AEC094CBD
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 11:11:59 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219H9pMJ008865;
        Wed, 9 Feb 2022 19:10:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=gsFJ3IscL5ZdDdn5xWN8PUS835NnU4RExG3q1P6/VfQ=;
 b=0zdOM4oD+SFyFki9CWWLZZ9GI54I7vXDCOsvrC7CDIzms+abCIgISpTAnzNdqs7DOVnK
 IXyWEnq/BoHzLkpf/fIY6QIcRj5sPAESGBcOiaEDYVYU+V6BS/zGXqk16LG1ga1SZw8i
 gxbSDCiZQp17fa95TccdtbHDbBUGb9yD9nPYSepd8W8JzTTTB97dmBeIhHQ/Elj25n4k
 EFuFFjeBY7iQXVJVdwMJqstIDAVJ1D4KHPHzrTD0oPBROY8y/DQuU81TNyXJF4ovPh1B
 fl93i/Lq8xpQrFCSh/Sa0XpfWcUXTQASBkncGhMudBMSa7UvB9ZnF3o3IhdTAlroBVAx bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgnq2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:10:10 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219J5q0Q069165;
        Wed, 9 Feb 2022 19:10:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3030.oracle.com with ESMTP id 3e1ec38er5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 19:10:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YRnOysa95h8IC3U3n2bk0s9TVeMOmtR9aC2SESxuPzGZverdqzp4kzBNZjTLLPjHHkZh4foPgRufaovJKdpQVFJWZlGQe4nXma+/Cm+ea6MKvjwtE9t0ZMOj9QxgCbR3MYe7YOnlXiI1mDPkjG24n+D4GKGfZtZ35gl8nmWNL419dVic5ZcEAV2L6bATaKYZT8sQ73zX+S3qIJlFC489hoeOHrVCAJne6BDZWpFgUSdQ8Ue0Iiaf8UoOZxJ/HMzIngQHb4GNLmcowIjUbaRWY+rZ1HD55scaOg5O0CcvNqIJsHGYJDsaYDE6W3cf4xw0p8DQNze7aN6KvtTk80CNRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gsFJ3IscL5ZdDdn5xWN8PUS835NnU4RExG3q1P6/VfQ=;
 b=MQ5xwt/nuwrr9EU7QoEp5CeX2oDzMUkUHdVMVWpKLwYsRULTeYozX3lSs6NBI93ov2qCoL5QtSeKyfcRvr7o9CJiQNciAKjHneW6ikALR0LR3mFc1q0lieXg4DlCn/lJFjvuC2fFlnrLxsanRj9v5b6BdD+WdvPmV8FGhd+uG8ys2bogBAcbvKcKOh8t9nyl9/jOijHQlUKcVuc/YAqO5e/zfVubg3ETNj+I5dxVoQOK9fsIERcPEtw9A87ODh8Xlkp31V4ESHY+xC7vsH0ehilqHg5Byyn5Ve53xqy9wFQrFDQaukA4JAY1OgaIKloLgadtahE6FNoklEp32EA+6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gsFJ3IscL5ZdDdn5xWN8PUS835NnU4RExG3q1P6/VfQ=;
 b=hxfUghiUvfVlXrPfGO1VPKlyS+bdsJWSN1h1AweKpsh05RA9VmQlDkHBmSycCYfg3t9wp9jZmHsB/op56qgw7W3vEBU3/rWpnYtTXx3YLs8hf87sUyiBXfS7I9f9T08WWkV31nbN1lPSOUV0Sj15mgGJzl7qKFt+AA15ek11sQk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB3503.namprd10.prod.outlook.com (2603:10b6:208:10f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 19:10:04 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 19:10:04 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 42/44] wdc33c93: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 42/44] wdc33c93: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHRFH1oblcPw48EWaMKfL10oTKKyLlyWA
Date:   Wed, 9 Feb 2022 19:10:04 +0000
Message-ID: <D448CE44-0DD7-4022-9D20-8DDF2FECC291@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-43-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-43-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95f8e770-aa6e-4f29-b80b-08d9ebffc7a2
x-ms-traffictypediagnostic: MN2PR10MB3503:EE_
x-microsoft-antispam-prvs: <MN2PR10MB35037A6CD57A71A8286503A3E62E9@MN2PR10MB3503.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:178;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q24BKhjc6X5QeLv2UPpwDxMPSiFAXggypPoJjvakv4QIJCHuLaghbJVEeyzg9+E30MS/T9qeh6KHopfSE/GRk5z5OfjI5mzCL1pEcyGDt923SY9FLqWDYcHjALzenSUCqmUOh5bLjZuAQWWw7BbPBQJMy9MGzfU0PzYWHHpmZojoFpG0X3LY4PpXYxyjIfw7zjMzoEhFWv94KkzNR/TcpUx6nceythf+W5dAUl+/jY6boeJtzQ3DdKYuhhVZC/KNFEVEYSKh4z2Y6ZYgWEQqPZQuxGYQBpKF1AAaiRYlnzXdXdYWgqime4sAuO5I+zfL6Ofm61USz9azuFAbbu9rVGQUd24kA+GNtXFoQeMTTi94QTty+DWPEznzOtUXkyQcEwhPp2Asx7+0TaTXEtZe9lZA1ho7xuH8WrIVxmSGfkg0Sw2scIYN2UZ2vR4qWPWvJJR0jJh41hHyWlBS1zbHrng+D/7pOlgdvYh+FAiv6TpEIBQXRH8y/+m6MXrKRU0klfL5umPywfZUlwkoXYPsXKYp1xKGq3M9lo2+yU5LM1/0uiA2+jTScfNyIa37uCH5tIJ921PwffOiFU9EOessqPm+VQ/nur9G/D/xvxr8SkPkmRJ1pWB5kfIdaBf+CuqLlVHT8vX8nqIYu/KQs+IFlMC7wjhsMoNLKvkKALvz3fa297PDKmNleinSdo4MpRh20wWx7oXRdb/OMTl7Z8nXkHhC8p4lFBFzEIhIW4aaHqGBg2Hc4m1juUwYq70jBEsK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38070700005)(30864003)(36756003)(8936002)(66556008)(71200400001)(4326008)(8676002)(508600001)(2906002)(66476007)(66446008)(64756008)(33656002)(186003)(2616005)(44832011)(6506007)(66946007)(53546011)(86362001)(76116006)(6486002)(54906003)(5660300002)(6916009)(122000001)(83380400001)(6512007)(91956017)(316002)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Eo10dMDALtVc48EeV7UGq3ViahY2IJEjcklkd8n2tT2b88Z4C5m7D9X/nJ6p?=
 =?us-ascii?Q?D1cErOd3kt6DauJKcouAngrpntaXEFEt02ghwZNpaXz9mbgJlPatmPAQ59rK?=
 =?us-ascii?Q?kem/y0bC+uRVO9j8Ta7s6Qyqny6ce0+3yO4YYNKWLOdxfnevXcNAv6ZqoLD1?=
 =?us-ascii?Q?3c/uOjFfDqXDVrym91+7MMU7LGdkyg8EMY70wOTu4f5h9FvJ21iHirdBFgWO?=
 =?us-ascii?Q?gnxqAiSMelVhCS4kI3erkXxxUzrhs83wmGUJEy5EM1CRScDrp4vJrxmo++Al?=
 =?us-ascii?Q?l0cOXK2/G6SDbRIbX1njQZVK1S+n8YDYMmo+UI0tD+pEz0nuD8TgFLrGaP2a?=
 =?us-ascii?Q?Y9nW3hVOSTHpWWC9SAWhXIwgj4wZBd8MKdZ7Hpl5Iricd6ayRIt4zyRu2hqo?=
 =?us-ascii?Q?fQWQaK10fcZzogNHPwV7TIviKinTcB6q1pyZvjbbvlmh8VKFY2q4GZKDNZGq?=
 =?us-ascii?Q?mvDlUrP/k4CRCEb092/nIK5R+6Lc1UPK8LJotupTDcFIVc6ZgA9YNTa74DrY?=
 =?us-ascii?Q?jBSku9IvpXTWlTD1gxB9BgimYyqPBMwpUBfyGlwPK++92u2r1RE/Ytpr6iDG?=
 =?us-ascii?Q?IQjmHPeWMEoHQqdb8Uu6TwMFAmKTl2kmimrTbUv+Bkp5ZglYQ4Bx5q07/z6x?=
 =?us-ascii?Q?rE7In+iZwfBDNdQE928/dhFnUQZqRtnD4oVnICmL3dng6KhkHZ68kJVixygp?=
 =?us-ascii?Q?oiUtSO0jdUIWszFvc/+UMgC3wsMlrc/zukAbIE6DWAbN1W/zlaMreeAj8EbE?=
 =?us-ascii?Q?6+bYPUawbzGG2UF13K2uYyd8Wi0SI+mSvlUJ/hff4Pe3wWJV/jBTzMEOodhQ?=
 =?us-ascii?Q?akCtvX4qspLVToE6JEEE/KgSzdGOp3gkZNNQvEnsdzuIKXG5zvv6UN1sumYA?=
 =?us-ascii?Q?eTSkEAyuPxsUWWioDS1VaYyEiQlgvlavIz03D2K44OzyuQNghNlIl/0yG4Qc?=
 =?us-ascii?Q?LaXE8xaqpNib3FnFrj+hrrYOxSZk1KASbB9YzAXyKwmj4YK9aleBeS24oLGC?=
 =?us-ascii?Q?NTFNeFva8yixdNgKk4QdOiQvasDjsOyH7rVQqnN7xt/z81jGBVF9BCinDcF0?=
 =?us-ascii?Q?yTWlBcGxWtoyitnzwpSk3RS9BkRs2ZjKDDMf7/JDAkY4Q7d+eh+FEd7mNJ7e?=
 =?us-ascii?Q?phOh322GFhzq1DTXaNrRdlyFVXZB3d8nXtLhjXERUIeoAqy6KnUwiVq6sHRh?=
 =?us-ascii?Q?fD8G2rHP6wXCwOhWdNOUe9NhtiVe3lwjkiA1eLqqsH4CTaVD8NgHnRN32R4n?=
 =?us-ascii?Q?BPza082NgpKdN67nTLuzCY4zAzgC9uOpZP88okWOaColxJ4WMgtGinYEKA1M?=
 =?us-ascii?Q?XWQ7HcPUefD3iK50+kV+kmnoJjhLpAoVotRyzuhMkc+DPEx5JMo2LAB+QrMh?=
 =?us-ascii?Q?jSb0FeyTfEsl0Hsqfr0XJKry3ERq2qnjQwqT2KSq10aNtkt/6SO7kNmgBv1q?=
 =?us-ascii?Q?DUSQPPyrFHfoKmgos5Kzpc6OSdG+SHC5Dt1VmIqU0SFFEFDX3y4qJeyiUsHs?=
 =?us-ascii?Q?Eb4IMJIre9YM8qDH1XnYSnSHvBFhKztKvQdiWI+4pkkc5MiSKGAmpD9IiQD6?=
 =?us-ascii?Q?J9rGhGdcWa7zCcBSI5OKW96EwZavsByjFzxbaibXkY1NlGi9qVCoIUsaPAAl?=
 =?us-ascii?Q?+/dl4pGj2PV1lkY6ar2GhF+qncBj1/SEYOE3vhQqji+I0mtoOTukBgUQUsGP?=
 =?us-ascii?Q?WXi+u+wvi9VMMvQaoN1nTrazOmN4prZ9AkdkTzs8/N/p6Ozo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1DF5420889AA384B95FC613D2DCDCAED@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95f8e770-aa6e-4f29-b80b-08d9ebffc7a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 19:10:04.6903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6f8u1JhZoF4lfG3NtlrKfpKQj9ipCa7xKSsHqLrTYKpztrSNdyEbxhUtdSPHTDdY7XFbe/PAHlzhBkvrR0geu0e5N9+lao5C3fa6aS6dzRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3503
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090101
X-Proofpoint-GUID: p6_WWzW3oQt1A32tJx7aEKL2egbuY8GY
X-Proofpoint-ORIG-GUID: p6_WWzW3oQt1A32tJx7aEKL2egbuY8GY
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
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/a2091.c   |  19 ++++---
> drivers/scsi/a3000.c   |  19 ++++---
> drivers/scsi/gvp11.c   |  19 ++++---
> drivers/scsi/mvme147.c |  10 ++--
> drivers/scsi/sgiwd93.c |  18 ++++---
> drivers/scsi/wd33c93.c | 119 ++++++++++++++++++++++-------------------
> drivers/scsi/wd33c93.h |  10 ++++
> 7 files changed, 123 insertions(+), 91 deletions(-)
>=20
> diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
> index bcbce23478b8..c619c834abd0 100644
> --- a/drivers/scsi/a2091.c
> +++ b/drivers/scsi/a2091.c
> @@ -44,16 +44,17 @@ static irqreturn_t a2091_intr(int irq, void *data)
>=20
> static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	struct Scsi_Host *instance =3D cmd->device->host;
> 	struct a2091_hostdata *hdata =3D shost_priv(instance);
> 	struct WD33C93_hostdata *wh =3D &hdata->wh;
> 	struct a2091_scsiregs *regs =3D hdata->regs;
> 	unsigned short cntr =3D CNTR_PDMD | CNTR_INTEN;
> -	unsigned long addr =3D virt_to_bus(cmd->SCp.ptr);
> +	unsigned long addr =3D virt_to_bus(scsi_pointer->ptr);
>=20
> 	/* don't allow DMA if the physical address is bad */
> 	if (addr & A2091_XFER_MASK) {
> -		wh->dma_bounce_len =3D (cmd->SCp.this_residual + 511) & ~0x1ff;
> +		wh->dma_bounce_len =3D (scsi_pointer->this_residual + 511) & ~0x1ff;
> 		wh->dma_bounce_buffer =3D kmalloc(wh->dma_bounce_len,
> 						GFP_KERNEL);
>=20
> @@ -77,8 +78,8 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
>=20
> 		if (!dir_in) {
> 			/* copy to bounce buffer for a write */
> -			memcpy(wh->dma_bounce_buffer, cmd->SCp.ptr,
> -			       cmd->SCp.this_residual);
> +			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
> +			       scsi_pointer->this_residual);
> 		}
> 	}
>=20
> @@ -96,10 +97,10 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_i=
n)
>=20
> 	if (dir_in) {
> 		/* invalidate any cache */
> -		cache_clear(addr, cmd->SCp.this_residual);
> +		cache_clear(addr, scsi_pointer->this_residual);
> 	} else {
> 		/* push any dirty cache */
> -		cache_push(addr, cmd->SCp.this_residual);
> +		cache_push(addr, scsi_pointer->this_residual);
> 	}
> 	/* start DMA */
> 	regs->ST_DMA =3D 1;
> @@ -111,6 +112,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_i=
n)
> static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
> 		     int status)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(SCpnt);
> 	struct a2091_hostdata *hdata =3D shost_priv(instance);
> 	struct WD33C93_hostdata *wh =3D &hdata->wh;
> 	struct a2091_scsiregs *regs =3D hdata->regs;
> @@ -143,8 +145,8 @@ static void dma_stop(struct Scsi_Host *instance, stru=
ct scsi_cmnd *SCpnt,
> 	/* copy from a bounce buffer, if necessary */
> 	if (status && wh->dma_bounce_buffer) {
> 		if (wh->dma_dir)
> -			memcpy(SCpnt->SCp.ptr, wh->dma_bounce_buffer,
> -			       SCpnt->SCp.this_residual);
> +			memcpy(scsi_pointer->ptr, wh->dma_bounce_buffer,
> +			       scsi_pointer->this_residual);
> 		kfree(wh->dma_bounce_buffer);
> 		wh->dma_bounce_buffer =3D NULL;
> 		wh->dma_bounce_len =3D 0;
> @@ -165,6 +167,7 @@ static struct scsi_host_template a2091_scsi_template =
=3D {
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D CMD_PER_LUN,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> +	.cmd_size		=3D sizeof(struct WD33C93_cmd),
> };
>=20
> static int a2091_probe(struct zorro_dev *z, const struct zorro_device_id =
*ent)
> diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
> index 23f34411f7bf..1906c695ee4a 100644
> --- a/drivers/scsi/a3000.c
> +++ b/drivers/scsi/a3000.c
> @@ -48,12 +48,13 @@ static irqreturn_t a3000_intr(int irq, void *data)
>=20
> static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	struct Scsi_Host *instance =3D cmd->device->host;
> 	struct a3000_hostdata *hdata =3D shost_priv(instance);
> 	struct WD33C93_hostdata *wh =3D &hdata->wh;
> 	struct a3000_scsiregs *regs =3D hdata->regs;
> 	unsigned short cntr =3D CNTR_PDMD | CNTR_INTEN;
> -	unsigned long addr =3D virt_to_bus(cmd->SCp.ptr);
> +	unsigned long addr =3D virt_to_bus(scsi_pointer->ptr);
>=20
> 	/*
> 	 * if the physical address has the wrong alignment, or if
> @@ -62,7 +63,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
> 	 * buffer
> 	 */
> 	if (addr & A3000_XFER_MASK) {
> -		wh->dma_bounce_len =3D (cmd->SCp.this_residual + 511) & ~0x1ff;
> +		wh->dma_bounce_len =3D (scsi_pointer->this_residual + 511) & ~0x1ff;
> 		wh->dma_bounce_buffer =3D kmalloc(wh->dma_bounce_len,
> 						GFP_KERNEL);
>=20
> @@ -74,8 +75,8 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
>=20
> 		if (!dir_in) {
> 			/* copy to bounce buffer for a write */
> -			memcpy(wh->dma_bounce_buffer, cmd->SCp.ptr,
> -			       cmd->SCp.this_residual);
> +			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
> +			       scsi_pointer->this_residual);
> 		}
>=20
> 		addr =3D virt_to_bus(wh->dma_bounce_buffer);
> @@ -95,10 +96,10 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_i=
n)
>=20
> 	if (dir_in) {
> 		/* invalidate any cache */
> -		cache_clear(addr, cmd->SCp.this_residual);
> +		cache_clear(addr, scsi_pointer->this_residual);
> 	} else {
> 		/* push any dirty cache */
> -		cache_push(addr, cmd->SCp.this_residual);
> +		cache_push(addr, scsi_pointer->this_residual);
> 	}
>=20
> 	/* start DMA */
> @@ -113,6 +114,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_i=
n)
> static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
> 		     int status)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(SCpnt);
> 	struct a3000_hostdata *hdata =3D shost_priv(instance);
> 	struct WD33C93_hostdata *wh =3D &hdata->wh;
> 	struct a3000_scsiregs *regs =3D hdata->regs;
> @@ -153,8 +155,8 @@ static void dma_stop(struct Scsi_Host *instance, stru=
ct scsi_cmnd *SCpnt,
> 	if (status && wh->dma_bounce_buffer) {
> 		if (SCpnt) {
> 			if (wh->dma_dir && SCpnt)
> -				memcpy(SCpnt->SCp.ptr, wh->dma_bounce_buffer,
> -				       SCpnt->SCp.this_residual);
> +				memcpy(scsi_pointer->ptr, wh->dma_bounce_buffer,
> +				       scsi_pointer->this_residual);
> 			kfree(wh->dma_bounce_buffer);
> 			wh->dma_bounce_buffer =3D NULL;
> 			wh->dma_bounce_len =3D 0;
> @@ -179,6 +181,7 @@ static struct scsi_host_template amiga_a3000_scsi_tem=
plate =3D {
> 	.this_id		=3D 7,
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D CMD_PER_LUN,
> +	.cmd_size		=3D sizeof(struct WD33C93_cmd),
> };
>=20
> static int __init amiga_a3000_scsi_probe(struct platform_device *pdev)
> diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
> index 43754c2f36b3..c990b82451dd 100644
> --- a/drivers/scsi/gvp11.c
> +++ b/drivers/scsi/gvp11.c
> @@ -53,18 +53,19 @@ void gvp11_setup(char *str, int *ints)
>=20
> static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	struct Scsi_Host *instance =3D cmd->device->host;
> 	struct gvp11_hostdata *hdata =3D shost_priv(instance);
> 	struct WD33C93_hostdata *wh =3D &hdata->wh;
> 	struct gvp11_scsiregs *regs =3D hdata->regs;
> 	unsigned short cntr =3D GVP11_DMAC_INT_ENABLE;
> -	unsigned long addr =3D virt_to_bus(cmd->SCp.ptr);
> +	unsigned long addr =3D virt_to_bus(scsi_pointer->ptr);
> 	int bank_mask;
> 	static int scsi_alloc_out_of_range =3D 0;
>=20
> 	/* use bounce buffer if the physical address is bad */
> 	if (addr & wh->dma_xfer_mask) {
> -		wh->dma_bounce_len =3D (cmd->SCp.this_residual + 511) & ~0x1ff;
> +		wh->dma_bounce_len =3D (scsi_pointer->this_residual + 511) & ~0x1ff;
>=20
> 		if (!scsi_alloc_out_of_range) {
> 			wh->dma_bounce_buffer =3D
> @@ -113,8 +114,8 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_i=
n)
>=20
> 		if (!dir_in) {
> 			/* copy to bounce buffer for a write */
> -			memcpy(wh->dma_bounce_buffer, cmd->SCp.ptr,
> -			       cmd->SCp.this_residual);
> +			memcpy(wh->dma_bounce_buffer, scsi_pointer->ptr,
> +			       scsi_pointer->this_residual);
> 		}
> 	}
>=20
> @@ -130,10 +131,10 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir=
_in)
>=20
> 	if (dir_in) {
> 		/* invalidate any cache */
> -		cache_clear(addr, cmd->SCp.this_residual);
> +		cache_clear(addr, scsi_pointer->this_residual);
> 	} else {
> 		/* push any dirty cache */
> -		cache_push(addr, cmd->SCp.this_residual);
> +		cache_push(addr, scsi_pointer->this_residual);
> 	}
>=20
> 	bank_mask =3D (~wh->dma_xfer_mask >> 18) & 0x01c0;
> @@ -150,6 +151,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_i=
n)
> static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
> 		     int status)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(SCpnt);
> 	struct gvp11_hostdata *hdata =3D shost_priv(instance);
> 	struct WD33C93_hostdata *wh =3D &hdata->wh;
> 	struct gvp11_scsiregs *regs =3D hdata->regs;
> @@ -162,8 +164,8 @@ static void dma_stop(struct Scsi_Host *instance, stru=
ct scsi_cmnd *SCpnt,
> 	/* copy from a bounce buffer, if necessary */
> 	if (status && wh->dma_bounce_buffer) {
> 		if (wh->dma_dir && SCpnt)
> -			memcpy(SCpnt->SCp.ptr, wh->dma_bounce_buffer,
> -			       SCpnt->SCp.this_residual);
> +			memcpy(scsi_pointer->ptr, wh->dma_bounce_buffer,
> +			       scsi_pointer->this_residual);
>=20
> 		if (wh->dma_buffer_pool =3D=3D BUF_SCSI_ALLOCED)
> 			kfree(wh->dma_bounce_buffer);
> @@ -189,6 +191,7 @@ static struct scsi_host_template gvp11_scsi_template =
=3D {
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D CMD_PER_LUN,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> +	.cmd_size		=3D sizeof(struct WD33C93_cmd),
> };
>=20
> static int check_wd33c93(struct gvp11_scsiregs *regs)
> diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
> index 0893d4c3a916..28d73e6a99be 100644
> --- a/drivers/scsi/mvme147.c
> +++ b/drivers/scsi/mvme147.c
> @@ -33,10 +33,11 @@ static irqreturn_t mvme147_intr(int irq, void *data)
>=20
> static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	struct Scsi_Host *instance =3D cmd->device->host;
> 	struct WD33C93_hostdata *hdata =3D shost_priv(instance);
> 	unsigned char flags =3D 0x01;
> -	unsigned long addr =3D virt_to_bus(cmd->SCp.ptr);
> +	unsigned long addr =3D virt_to_bus(scsi_pointer->ptr);
>=20
> 	/* setup dma direction */
> 	if (!dir_in)
> @@ -47,14 +48,14 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_i=
n)
>=20
> 	if (dir_in) {
> 		/* invalidate any cache */
> -		cache_clear(addr, cmd->SCp.this_residual);
> +		cache_clear(addr, scsi_pointer->this_residual);
> 	} else {
> 		/* push any dirty cache */
> -		cache_push(addr, cmd->SCp.this_residual);
> +		cache_push(addr, scsi_pointer->this_residual);
> 	}
>=20
> 	/* start DMA */
> -	m147_pcc->dma_bcr =3D cmd->SCp.this_residual | (1 << 24);
> +	m147_pcc->dma_bcr =3D scsi_pointer->this_residual | (1 << 24);
> 	m147_pcc->dma_dadr =3D addr;
> 	m147_pcc->dma_cntrl =3D flags;
>=20
> @@ -81,6 +82,7 @@ static struct scsi_host_template mvme147_host_template =
=3D {
> 	.this_id		=3D 7,
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D CMD_PER_LUN,
> +	.cmd_size		=3D sizeof(struct WD33C93_cmd),
> };
>=20
> static struct Scsi_Host *mvme147_shost;
> diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
> index e797d89c873b..c519c7fa9c3c 100644
> --- a/drivers/scsi/sgiwd93.c
> +++ b/drivers/scsi/sgiwd93.c
> @@ -69,14 +69,15 @@ static irqreturn_t sgiwd93_intr(int irq, void *dev_id=
)
> static inline
> void fill_hpc_entries(struct ip22_hostdata *hd, struct scsi_cmnd *cmd, in=
t din)
> {
> -	unsigned long len =3D cmd->SCp.this_residual;
> -	void *addr =3D cmd->SCp.ptr;
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> +	unsigned long len =3D scsi_pointer->this_residual;
> +	void *addr =3D scsi_pointer->ptr;
> 	dma_addr_t physaddr;
> 	unsigned long count;
> 	struct hpc_chunk *hcp;
>=20
> 	physaddr =3D dma_map_single(hd->dev, addr, len, DMA_DIR(din));
> -	cmd->SCp.dma_handle =3D physaddr;
> +	scsi_pointer->dma_handle =3D physaddr;
> 	hcp =3D hd->cpu;
>=20
> 	while (len) {
> @@ -106,6 +107,7 @@ void fill_hpc_entries(struct ip22_hostdata *hd, struc=
t scsi_cmnd *cmd, int din)
>=20
> static int dma_setup(struct scsi_cmnd *cmd, int datainp)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	struct ip22_hostdata *hdata =3D host_to_hostdata(cmd->device->host);
> 	struct hpc3_scsiregs *hregs =3D
> 		(struct hpc3_scsiregs *) cmd->device->host->base;
> @@ -120,7 +122,7 @@ static int dma_setup(struct scsi_cmnd *cmd, int datai=
np)
> 	 * obvious).  IMHO a better fix would be, not to do these dma setups
> 	 * in the first place.
> 	 */
> -	if (cmd->SCp.ptr =3D=3D NULL || cmd->SCp.this_residual =3D=3D 0)
> +	if (scsi_pointer->ptr =3D=3D NULL || scsi_pointer->this_residual =3D=3D=
 0)
> 		return 1;
>=20
> 	fill_hpc_entries(hdata, cmd, datainp);
> @@ -140,13 +142,14 @@ static int dma_setup(struct scsi_cmnd *cmd, int dat=
ainp)
> static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
> 		     int status)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(SCpnt);
> 	struct ip22_hostdata *hdata =3D host_to_hostdata(instance);
> 	struct hpc3_scsiregs *hregs;
>=20
> 	if (!SCpnt)
> 		return;
>=20
> -	if (SCpnt->SCp.ptr =3D=3D NULL || SCpnt->SCp.this_residual =3D=3D 0)
> +	if (scsi_pointer->ptr =3D=3D NULL || scsi_pointer->this_residual =3D=3D=
 0)
> 		return;
>=20
> 	hregs =3D (struct hpc3_scsiregs *) SCpnt->device->host->base;
> @@ -160,8 +163,8 @@ static void dma_stop(struct Scsi_Host *instance, stru=
ct scsi_cmnd *SCpnt,
> 			barrier();
> 	}
> 	hregs->ctrl =3D 0;
> -	dma_unmap_single(hdata->dev, SCpnt->SCp.dma_handle,
> -			 SCpnt->SCp.this_residual,
> +	dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
> +			 scsi_pointer->this_residual,
> 			 DMA_DIR(hdata->wh.dma_dir));
>=20
> 	pr_debug("\n");
> @@ -213,6 +216,7 @@ static struct scsi_host_template sgiwd93_template =3D=
 {
> 	.sg_tablesize		=3D SG_ALL,
> 	.cmd_per_lun		=3D 8,
> 	.dma_boundary		=3D PAGE_SIZE - 1,
> +	.cmd_size		=3D sizeof(struct WD33C93_cmd),
> };
>=20
> static int sgiwd93_probe(struct platform_device *pdev)
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index 7d2f00f3571a..3fe562047d85 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -364,6 +364,7 @@ calc_sync_msg(unsigned int period, unsigned int offse=
t, unsigned int fast,
>=20
> static int wd33c93_queuecommand_lck(struct scsi_cmnd *cmd)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	struct WD33C93_hostdata *hostdata;
> 	struct scsi_cmnd *tmp;
>=20
> @@ -395,15 +396,15 @@ static int wd33c93_queuecommand_lck(struct scsi_cmn=
d *cmd)
>  */
>=20
> 	if (scsi_bufflen(cmd)) {
> -		cmd->SCp.buffer =3D scsi_sglist(cmd);
> -		cmd->SCp.buffers_residual =3D scsi_sg_count(cmd) - 1;
> -		cmd->SCp.ptr =3D sg_virt(cmd->SCp.buffer);
> -		cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
> +		scsi_pointer->buffer =3D scsi_sglist(cmd);
> +		scsi_pointer->buffers_residual =3D scsi_sg_count(cmd) - 1;
> +		scsi_pointer->ptr =3D sg_virt(scsi_pointer->buffer);
> +		scsi_pointer->this_residual =3D scsi_pointer->buffer->length;
> 	} else {
> -		cmd->SCp.buffer =3D NULL;
> -		cmd->SCp.buffers_residual =3D 0;
> -		cmd->SCp.ptr =3D NULL;
> -		cmd->SCp.this_residual =3D 0;
> +		scsi_pointer->buffer =3D NULL;
> +		scsi_pointer->buffers_residual =3D 0;
> +		scsi_pointer->ptr =3D NULL;
> +		scsi_pointer->this_residual =3D 0;
> 	}
>=20
> /* WD docs state that at the conclusion of a "LEVEL2" command, the
> @@ -423,7 +424,7 @@ static int wd33c93_queuecommand_lck(struct scsi_cmnd =
*cmd)
>  * status byte is stored.
>  */
>=20
> -	cmd->SCp.Status =3D ILLEGAL_STATUS_BYTE;
> +	scsi_pointer->Status =3D ILLEGAL_STATUS_BYTE;
>=20
> 	/*
> 	 * Add the cmd to the end of 'input_Q'. Note that REQUEST SENSE
> @@ -470,6 +471,7 @@ DEF_SCSI_QCMD(wd33c93_queuecommand)
> static void
> wd33c93_execute(struct Scsi_Host *instance)
> {
> +	struct scsi_pointer *scsi_pointer;
> 	struct WD33C93_hostdata *hostdata =3D
> 	    (struct WD33C93_hostdata *) instance->hostdata;
> 	const wd33c93_regs regs =3D hostdata->regs;
> @@ -546,7 +548,8 @@ wd33c93_execute(struct Scsi_Host *instance)
>  * to change around and experiment with for now.
>  */
>=20
> -	cmd->SCp.phase =3D 0;	/* assume no disconnect */
> +	scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> +	scsi_pointer->phase =3D 0;	/* assume no disconnect */
> 	if (hostdata->disconnect =3D=3D DIS_NEVER)
> 		goto no;
> 	if (hostdata->disconnect =3D=3D DIS_ALWAYS)
> @@ -563,7 +566,7 @@ wd33c93_execute(struct Scsi_Host *instance)
> 		    (prev->device->lun !=3D cmd->device->lun)) {
> 			for (prev =3D (struct scsi_cmnd *) hostdata->input_Q; prev;
> 			     prev =3D (struct scsi_cmnd *) prev->host_scribble)
> -				prev->SCp.phase =3D 1;
> +				WD33C93_scsi_pointer(prev)->phase =3D 1;
> 			goto yes;
> 		}
> 	}
> @@ -571,7 +574,7 @@ wd33c93_execute(struct Scsi_Host *instance)
> 	goto no;
>=20
>  yes:
> -	cmd->SCp.phase =3D 1;
> +	scsi_pointer->phase =3D 1;
>=20
> #ifdef PROC_STATISTICS
> 	hostdata->disc_allowed_cnt[cmd->device->id]++;
> @@ -579,7 +582,7 @@ wd33c93_execute(struct Scsi_Host *instance)
>=20
>  no:
>=20
> -	write_wd33c93(regs, WD_SOURCE_ID, ((cmd->SCp.phase) ? SRCID_ER : 0));
> +	write_wd33c93(regs, WD_SOURCE_ID, scsi_pointer->phase ? SRCID_ER : 0);
>=20
> 	write_wd33c93(regs, WD_TARGET_LUN, (u8)cmd->device->lun);
> 	write_wd33c93(regs, WD_SYNCHRONOUS_TRANSFER,
> @@ -648,14 +651,14 @@ wd33c93_execute(struct Scsi_Host *instance)
> 		 * up ahead of time.
> 		 */
>=20
> -		if ((cmd->SCp.phase =3D=3D 0) && (hostdata->no_dma =3D=3D 0)) {
> +		if (scsi_pointer->phase =3D=3D 0 && hostdata->no_dma =3D=3D 0) {
> 			if (hostdata->dma_setup(cmd,
> 			    (cmd->sc_data_direction =3D=3D DMA_TO_DEVICE) ?
> 			     DATA_OUT_DIR : DATA_IN_DIR))
> 				write_wd33c93_count(regs, 0);	/* guarantee a DATA_PHASE interrupt */
> 			else {
> 				write_wd33c93_count(regs,
> -						    cmd->SCp.this_residual);
> +						scsi_pointer->this_residual);
> 				write_wd33c93(regs, WD_CONTROL,
> 					      CTRL_IDI | CTRL_EDI | hostdata->dma_mode);
> 				hostdata->dma =3D D_DMA_RUNNING;
> @@ -675,7 +678,7 @@ wd33c93_execute(struct Scsi_Host *instance)
> 	 */
>=20
> 	DB(DB_EXECUTE,
> -	   printk("%s)EX-2 ", (cmd->SCp.phase) ? "d:" : ""))
> +	   printk("%s)EX-2 ", scsi_pointer->phase ? "d:" : ""))
> }
>=20
> static void
> @@ -717,6 +720,7 @@ static void
> transfer_bytes(const wd33c93_regs regs, struct scsi_cmnd *cmd,
> 		int data_in_dir)
> {
> +	struct scsi_pointer *scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	struct WD33C93_hostdata *hostdata;
> 	unsigned long length;
>=20
> @@ -730,13 +734,13 @@ transfer_bytes(const wd33c93_regs regs, struct scsi=
_cmnd *cmd,
>  * now we need to setup the next scatter-gather buffer as the
>  * source or destination for THIS transfer.
>  */
> -	if (!cmd->SCp.this_residual && cmd->SCp.buffers_residual) {
> -		cmd->SCp.buffer =3D sg_next(cmd->SCp.buffer);
> -		--cmd->SCp.buffers_residual;
> -		cmd->SCp.this_residual =3D cmd->SCp.buffer->length;
> -		cmd->SCp.ptr =3D sg_virt(cmd->SCp.buffer);
> +	if (!scsi_pointer->this_residual && scsi_pointer->buffers_residual) {
> +		scsi_pointer->buffer =3D sg_next(scsi_pointer->buffer);
> +		--scsi_pointer->buffers_residual;
> +		scsi_pointer->this_residual =3D scsi_pointer->buffer->length;
> +		scsi_pointer->ptr =3D sg_virt(scsi_pointer->buffer);
> 	}
> -	if (!cmd->SCp.this_residual) /* avoid bogus setups */
> +	if (!scsi_pointer->this_residual) /* avoid bogus setups */
> 		return;
>=20
> 	write_wd33c93(regs, WD_SYNCHRONOUS_TRANSFER,
> @@ -750,11 +754,12 @@ transfer_bytes(const wd33c93_regs regs, struct scsi=
_cmnd *cmd,
> #ifdef PROC_STATISTICS
> 		hostdata->pio_cnt++;
> #endif
> -		transfer_pio(regs, (uchar *) cmd->SCp.ptr,
> -			     cmd->SCp.this_residual, data_in_dir, hostdata);
> -		length =3D cmd->SCp.this_residual;
> -		cmd->SCp.this_residual =3D read_wd33c93_count(regs);
> -		cmd->SCp.ptr +=3D (length - cmd->SCp.this_residual);
> +		transfer_pio(regs, (uchar *) scsi_pointer->ptr,
> +			     scsi_pointer->this_residual, data_in_dir,
> +			     hostdata);
> +		length =3D scsi_pointer->this_residual;
> +		scsi_pointer->this_residual =3D read_wd33c93_count(regs);
> +		scsi_pointer->ptr +=3D length - scsi_pointer->this_residual;
> 	}
>=20
> /* We are able to do DMA (in fact, the Amiga hardware is
> @@ -771,10 +776,10 @@ transfer_bytes(const wd33c93_regs regs, struct scsi=
_cmnd *cmd,
> 		hostdata->dma_cnt++;
> #endif
> 		write_wd33c93(regs, WD_CONTROL, CTRL_IDI | CTRL_EDI | hostdata->dma_mod=
e);
> -		write_wd33c93_count(regs, cmd->SCp.this_residual);
> +		write_wd33c93_count(regs, scsi_pointer->this_residual);
>=20
> 		if ((hostdata->level2 >=3D L2_DATA) ||
> -		    (hostdata->level2 =3D=3D L2_BASIC && cmd->SCp.phase =3D=3D 0)) {
> +		    (hostdata->level2 =3D=3D L2_BASIC && scsi_pointer->phase =3D=3D 0)=
) {
> 			write_wd33c93(regs, WD_COMMAND_PHASE, 0x45);
> 			write_wd33c93_cmd(regs, WD_CMD_SEL_ATN_XFER);
> 			hostdata->state =3D S_RUNNING_LEVEL2;
> @@ -788,6 +793,7 @@ transfer_bytes(const wd33c93_regs regs, struct scsi_c=
mnd *cmd,
> void
> wd33c93_intr(struct Scsi_Host *instance)
> {
> +	struct scsi_pointer *scsi_pointer;
> 	struct WD33C93_hostdata *hostdata =3D
> 	    (struct WD33C93_hostdata *) instance->hostdata;
> 	const wd33c93_regs regs =3D hostdata->regs;
> @@ -806,6 +812,7 @@ wd33c93_intr(struct Scsi_Host *instance)
> #endif
>=20
> 	cmd =3D (struct scsi_cmnd *) hostdata->connected;	/* assume we're connec=
ted */
> +	scsi_pointer =3D WD33C93_scsi_pointer(cmd);
> 	sr =3D read_wd33c93(regs, WD_SCSI_STATUS);	/* clear the interrupt */
> 	phs =3D read_wd33c93(regs, WD_COMMAND_PHASE);
>=20
> @@ -827,14 +834,14 @@ wd33c93_intr(struct Scsi_Host *instance)
>  */
> 	    if (hostdata->dma =3D=3D D_DMA_RUNNING) {
> 		DB(DB_TRANSFER,
> -		   printk("[%p/%d:", cmd->SCp.ptr, cmd->SCp.this_residual))
> +		   printk("[%p/%d:", scsi_pointer->ptr, scsi_pointer->this_residual))
> 		    hostdata->dma_stop(cmd->device->host, cmd, 1);
> 		hostdata->dma =3D D_DMA_OFF;
> -		length =3D cmd->SCp.this_residual;
> -		cmd->SCp.this_residual =3D read_wd33c93_count(regs);
> -		cmd->SCp.ptr +=3D (length - cmd->SCp.this_residual);
> +		length =3D scsi_pointer->this_residual;
> +		scsi_pointer->this_residual =3D read_wd33c93_count(regs);
> +		scsi_pointer->ptr +=3D length - scsi_pointer->this_residual;
> 		DB(DB_TRANSFER,
> -		   printk("%p/%d]", cmd->SCp.ptr, cmd->SCp.this_residual))
> +		   printk("%p/%d]", scsi_pointer->ptr, scsi_pointer->this_residual))
> 	}
>=20
> /* Respond to the specific WD3393 interrupt - there are quite a few! */
> @@ -884,7 +891,7 @@ wd33c93_intr(struct Scsi_Host *instance)
> 		/* construct an IDENTIFY message with correct disconnect bit */
>=20
> 		hostdata->outgoing_msg[0] =3D IDENTIFY(0, cmd->device->lun);
> -		if (cmd->SCp.phase)
> +		if (scsi_pointer->phase)
> 			hostdata->outgoing_msg[0] |=3D 0x40;
>=20
> 		if (hostdata->sync_stat[cmd->device->id] =3D=3D SS_FIRST) {
> @@ -926,8 +933,8 @@ wd33c93_intr(struct Scsi_Host *instance)
> 	case CSR_UNEXP | PHS_DATA_IN:
> 	case CSR_SRV_REQ | PHS_DATA_IN:
> 		DB(DB_INTR,
> -		   printk("IN-%d.%d", cmd->SCp.this_residual,
> -			  cmd->SCp.buffers_residual))
> +		   printk("IN-%d.%d", scsi_pointer->this_residual,
> +			  scsi_pointer->buffers_residual))
> 		    transfer_bytes(regs, cmd, DATA_IN_DIR);
> 		if (hostdata->state !=3D S_RUNNING_LEVEL2)
> 			hostdata->state =3D S_CONNECTED;
> @@ -938,8 +945,8 @@ wd33c93_intr(struct Scsi_Host *instance)
> 	case CSR_UNEXP | PHS_DATA_OUT:
> 	case CSR_SRV_REQ | PHS_DATA_OUT:
> 		DB(DB_INTR,
> -		   printk("OUT-%d.%d", cmd->SCp.this_residual,
> -			  cmd->SCp.buffers_residual))
> +		   printk("OUT-%d.%d", scsi_pointer->this_residual,
> +			  scsi_pointer->buffers_residual))
> 		    transfer_bytes(regs, cmd, DATA_OUT_DIR);
> 		if (hostdata->state !=3D S_RUNNING_LEVEL2)
> 			hostdata->state =3D S_CONNECTED;
> @@ -962,8 +969,8 @@ wd33c93_intr(struct Scsi_Host *instance)
> 	case CSR_UNEXP | PHS_STATUS:
> 	case CSR_SRV_REQ | PHS_STATUS:
> 		DB(DB_INTR, printk("STATUS=3D"))
> -		cmd->SCp.Status =3D read_1_byte(regs);
> -		DB(DB_INTR, printk("%02x", cmd->SCp.Status))
> +		scsi_pointer->Status =3D read_1_byte(regs);
> +		DB(DB_INTR, printk("%02x", scsi_pointer->Status))
> 		    if (hostdata->level2 >=3D L2_BASIC) {
> 			sr =3D read_wd33c93(regs, WD_SCSI_STATUS);	/* clear interrupt */
> 			udelay(7);
> @@ -991,7 +998,7 @@ wd33c93_intr(struct Scsi_Host *instance)
> 		else
> 			hostdata->incoming_ptr =3D 0;
>=20
> -		cmd->SCp.Message =3D msg;
> +		scsi_pointer->Message =3D msg;
> 		switch (msg) {
>=20
> 		case COMMAND_COMPLETE:
> @@ -1163,21 +1170,21 @@ wd33c93_intr(struct Scsi_Host *instance)
> 		write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
> 		if (phs =3D=3D 0x60) {
> 			DB(DB_INTR, printk("SX-DONE"))
> -			    cmd->SCp.Message =3D COMMAND_COMPLETE;
> +			    scsi_pointer->Message =3D COMMAND_COMPLETE;
> 			lun =3D read_wd33c93(regs, WD_TARGET_LUN);
> -			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
> +			DB(DB_INTR, printk(":%d.%d", scsi_pointer->Status, lun))
> 			    hostdata->connected =3D NULL;
> 			hostdata->busy[cmd->device->id] &=3D ~(1 << (cmd->device->lun & 0xff))=
;
> 			hostdata->state =3D S_UNCONNECTED;
> -			if (cmd->SCp.Status =3D=3D ILLEGAL_STATUS_BYTE)
> -				cmd->SCp.Status =3D lun;
> +			if (scsi_pointer->Status =3D=3D ILLEGAL_STATUS_BYTE)
> +				scsi_pointer->Status =3D lun;
> 			if (cmd->cmnd[0] =3D=3D REQUEST_SENSE
> -			    && cmd->SCp.Status !=3D SAM_STAT_GOOD) {
> +			    && scsi_pointer->Status !=3D SAM_STAT_GOOD) {
> 				set_host_byte(cmd, DID_ERROR);
> 			} else {
> 				set_host_byte(cmd, DID_OK);
> -				scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
> -				set_status_byte(cmd, cmd->SCp.Status);
> +				scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
> +				set_status_byte(cmd, scsi_pointer->Status);
> 			}
> 			scsi_done(cmd);
>=20
> @@ -1259,12 +1266,12 @@ wd33c93_intr(struct Scsi_Host *instance)
> 		hostdata->busy[cmd->device->id] &=3D ~(1 << (cmd->device->lun & 0xff));
> 		hostdata->state =3D S_UNCONNECTED;
> 		if (cmd->cmnd[0] =3D=3D REQUEST_SENSE &&
> -		    cmd->SCp.Status !=3D SAM_STAT_GOOD) {
> +		    scsi_pointer->Status !=3D SAM_STAT_GOOD) {
> 			set_host_byte(cmd, DID_ERROR);
> 		} else {
> 			set_host_byte(cmd, DID_OK);
> -			scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
> -			set_status_byte(cmd, cmd->SCp.Status);
> +			scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
> +			set_status_byte(cmd, scsi_pointer->Status);
> 		}
> 		scsi_done(cmd);
>=20
> @@ -1293,14 +1300,14 @@ wd33c93_intr(struct Scsi_Host *instance)
> 			hostdata->connected =3D NULL;
> 			hostdata->busy[cmd->device->id] &=3D ~(1 << (cmd->device->lun & 0xff))=
;
> 			hostdata->state =3D S_UNCONNECTED;
> -			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
> +			DB(DB_INTR, printk(":%d", scsi_pointer->Status))
> 			if (cmd->cmnd[0] =3D=3D REQUEST_SENSE
> -			    && cmd->SCp.Status !=3D SAM_STAT_GOOD) {
> +			    && scsi_pointer->Status !=3D SAM_STAT_GOOD) {
> 				set_host_byte(cmd, DID_ERROR);
> 			} else {
> 				set_host_byte(cmd, DID_OK);
> -				scsi_msg_to_host_byte(cmd, cmd->SCp.Message);
> -				set_status_byte(cmd, cmd->SCp.Status);
> +				scsi_msg_to_host_byte(cmd, scsi_pointer->Message);
> +				set_status_byte(cmd, scsi_pointer->Status);
> 			}
> 			scsi_done(cmd);
> 			break;
> diff --git a/drivers/scsi/wd33c93.h b/drivers/scsi/wd33c93.h
> index 2edec34c5a42..b5d6842c6944 100644
> --- a/drivers/scsi/wd33c93.h
> +++ b/drivers/scsi/wd33c93.h
> @@ -262,6 +262,16 @@ struct WD33C93_hostdata {
> #endif
>     };
>=20
> +struct WD33C93_cmd {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static inline struct scsi_pointer *WD33C93_scsi_pointer(struct scsi_cmnd=
 *cmd)
> +{
> +	struct WD33C93_cmd *wcmd =3D scsi_cmd_priv(cmd);
> +
> +	return &wcmd->scsi_pointer;
> +}
>=20
> /* defines for hostdata->chip */
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

