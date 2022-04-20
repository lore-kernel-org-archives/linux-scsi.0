Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B714FC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Apr 2022 18:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381640AbiDTSzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Apr 2022 14:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381648AbiDTSzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Apr 2022 14:55:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502814756E
        for <linux-scsi@vger.kernel.org>; Wed, 20 Apr 2022 11:52:48 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23KI3eWa024789;
        Wed, 20 Apr 2022 18:52:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=r5IycCsxoTWhD/sBju5cE5OShYWneYz/dx7chaNRGWg=;
 b=V+ubrAJi6V3mRXGUTShCv834pLv1KeZaMKbn8h5RccMPh69BxZSMmb+pAXxyZA7iJsFt
 YzA7qCJJWKGwGoRaPquZRF/reI6jwZq/XU5naPSD6pCreDYlDv1eK/14sKLxI97dpll3
 e0vIp77UmhbnDIzoecYL40RxYIxpsfDJ8VsycWI5pP0WQ58pnP5ehF6InPRb1AA9HtuM
 h9/t6mjxuNM487s63xn9dx+LI3ombeVGFIGov8L5i83JJmQQbmhgpTHStIAP440tfWEn
 f5Z/A7EIBCBlztFNnx1KhnN88/YuptIPproM/Y1V2OxjSo9zU2BM2f3Cq5u+f8qrUxAs VQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9hruv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 18:52:35 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23KIkf2c035349;
        Wed, 20 Apr 2022 18:52:35 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3ffm882uun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Apr 2022 18:52:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TE/nmgoT2o+qdr2P8EGfXxFp1v9GaEeSfOjmWF6gYQfoskRSFAyZ+9unbrm/mBDD/UnFFb8suzIgYt7Cz1bbJocZJ6yMg3h4sMfLIbcBEmFCJaHMpKljPPssYs6qwycofaXPGfCwynrEqGtcdTx0JU9uLMhMITPPOII5rBCYGuEoJ0wR1iqM9YZ/ghnc0lHENXl6xNkbc4j25nv6fDiBUuHnbf2pOt35LqH7Bwdup+egcsDlI9Me5pJfnYTCGHB3wCdaXGTL4vT1fsZ6Ib//PDtMEuHtVPkAlvDirjsu+AqOL/uBJ+rCDe0U4FAevA2X7kI7ica2pd69fEhFbSliTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5IycCsxoTWhD/sBju5cE5OShYWneYz/dx7chaNRGWg=;
 b=FPnuni99h4i8hrdQiNbprIhvLXnDwYyncDH6k+PaReBSkNzmUbhwpBhARz3S6EHMyrHGkh3zd9AHJHIHitlBAIKBs28/ywALlrt7hrUKvrsWaaS3T1pku83I5Dj9p8RWu9lyKDz80TKgcvJzTBIBDEDbMSPvzaWmbmmf/ssQP0wdPS5GNKmrhHTh2OCMGNSDVGcc+fdennd+JzEY2yIBuR+qLf/gmZUpU160SeL1jWmpuNPUZUlu2n8T+bBM2qIb6VDda4rt8NjLC/9zx9QPESYzCEUtqL7e5l/Lxx1kUowv8Sjx1806bu77dj5z1wldRsi6/sGK+GyfCJX9m5iX9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5IycCsxoTWhD/sBju5cE5OShYWneYz/dx7chaNRGWg=;
 b=DhNCnwfiCDuwrJSeDCoBnJ04vcxYYQVlschHqxv1/bfQRg5M+XQARDtDq0fHln2gsTCpBwKptBTmVcOh7CRvHEWy6glTzd+ZImFVZvnMO5kegUBhf9QF3u59o6zmScLaB+S2H/n6jRKg40e2N0FPzxM+r67mvnGbTeNoV0rXn3I=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BYAPR10MB2741.namprd10.prod.outlook.com (2603:10b6:a02:b3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.25; Wed, 20 Apr
 2022 18:52:32 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::a0bc:ec02:3bba:830c%7]) with mapi id 15.20.5164.025; Wed, 20 Apr 2022
 18:52:32 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
CC:     linux-scsi <linux-scsi@vger.kernel.org>,
        Martin Petersen <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "chandrakanth.patil@broadcom.com" <chandrakanth.patil@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "prayas.patel@broadcom.com" <prayas.patel@broadcom.com>
Subject: Re: [PATCH v4 7/8] mpi3mr: add support for nvme pass-through
Thread-Topic: [PATCH v4 7/8] mpi3mr: add support for nvme pass-through
Thread-Index: AQHYT0cY2ydxqF5y0EOQd8goHQk056z5MQWA
Date:   Wed, 20 Apr 2022 18:52:32 +0000
Message-ID: <56AEB8D0-DF5C-4089-AC78-CF4F601B7AFF@oracle.com>
References: <20220413145652.112271-1-sumit.saxena@broadcom.com>
 <20220413145652.112271-8-sumit.saxena@broadcom.com>
In-Reply-To: <20220413145652.112271-8-sumit.saxena@broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c034d8a-3a0b-4acd-4b17-08da22feed1e
x-ms-traffictypediagnostic: BYAPR10MB2741:EE_
x-microsoft-antispam-prvs: <BYAPR10MB2741E1FB23E0994E10D54249E6F59@BYAPR10MB2741.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lR5YTpHVPR9c0n3HhmwiQkE+ihNlB7ZxgJslxlDsYTa0LMBgiFwJAWn+lVMlnfco0DO0fuVlIoAeN63C6PO3jyy2xTirDGlI/H3F2d1m2E9QRAck0ohyq+l1aOUhegALhbJx9T5h4mSbpXyeA7ZQceNcVwVSYXP8KUngSpQrknzlENogwrEO+HIpnKtU85QW0/b/yfW0+Kb5xrgX88XRPxH2af6+HIV7BmKtkUZ7s51Rh4/hAnz1Xybs36p4TZ7LjIT3b3XC9VhdVFtsIASfQxP7D2Cc48oAfOGcHDO1ZLbQ8ukn8m5Pm7BzJIQkS81XyCpK5hLGT/vIugvwH6aYjO1mZxR5+5r+SvVIp1tWbZFnXYNsq3U0Mf/QQKk0SMBZWmRS3jU40tkUq/qkcQmi9uIIID2pR1pYHoUf8yP/43DdAp15/J7RpNaBzqIOjAgu1zVM5nzmUPeNXnDGP4MRYwg3Ehbb3MXElpOZmOyd/2vmzXzlZXzhXizP76FPGJ8DBr15sJvOWTHrZbCf7VDG0s0F170pphOau9UNnjmVwQ1+KSYySgTolULkC61QPW+hyOWHUk0LxtzkyGIE9aoxsfOAC5z+MxB2b2tKCQEfQheVGtB0bQXw0zIk7B3e0nqWWCJNZPe2yHoQ4AzTWiBHRVjhZiDewuY+21wIy1HR8yM4f7mwaICMqTPZt3O8ozD7WP0NBXs9dGAJoLTo89HaNDZBDBtLO9eOta2SXgGxNNj6royKWweZNMrPN5eNXKiW4iajCLRPkLrEc69piXoN0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(30864003)(2616005)(316002)(6486002)(6512007)(38070700005)(71200400001)(2906002)(83380400001)(7416002)(33656002)(6506007)(53546011)(508600001)(44832011)(8936002)(5660300002)(38100700002)(66946007)(76116006)(66556008)(8676002)(4326008)(186003)(64756008)(36756003)(66446008)(122000001)(91956017)(6916009)(66476007)(54906003)(86362001)(32563001)(45980500001)(579004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ImHegU7H14uKI0Csq9JfC7LihpBROrhRF3Cl704dvEX18SLnGcKzVMDIEUPR?=
 =?us-ascii?Q?k26S2GrzsQVnTDBqhog7ikgPFh6QICjzazPjxvnIx5sPbzCtterQpq2B05E4?=
 =?us-ascii?Q?OvwIvPDHb35m7d4IWOWrGq0CimHQh8jfUjnO4uUUWfGtfn7a1WIsCLktuLSb?=
 =?us-ascii?Q?Ie06J0mj7u3+B0zUIKlHUk1z6n3MsEG4Jb6FWuHP/qnkmAJEbixiANzjL+QY?=
 =?us-ascii?Q?Fk08WDCbtwU+a5Ncm0q1ChtyaEPiES2tMizPkoeDIS1ZADsaZz8viXjmcpuW?=
 =?us-ascii?Q?iUcdsIXy4WCGFLINTJBDIP9pHBA8jgDtm/xbZ6QvAI/KR3MtEbaA2vWot3lV?=
 =?us-ascii?Q?uaEBt9lXLh3z6sxxcoBs9T0Hv9v9zzsmOQNJqw4Xcjul447REp0efWvoFlhY?=
 =?us-ascii?Q?GkPhBDubLZQIrQp9tpYu5ajep2YGNesl1gnP1zzXkNufzpTLTOq85GCtI9k6?=
 =?us-ascii?Q?nF1TtXxyBatWlkhVLffl1I7V74ZPGGkD/VzEFhliJRQmab+CZtKma903jPsG?=
 =?us-ascii?Q?a5S6S3Mf1GVayW2Sd7BupzcnoWfeUZyBwL5xmp0th+Zo4zQS8FbtUUgSSKwA?=
 =?us-ascii?Q?5g0+sZYaI+v/EmnfRjxorVDc5pY8C1sHVlXhn3FhSLzRIe55hRdwn5JraZH+?=
 =?us-ascii?Q?p7wSTY7Jf+4jSQSYS5DNbDc21GREZfVVd8svwOrSj1elSlwTicOlBDwrISzt?=
 =?us-ascii?Q?8DGZJo8LGiNHT43Nn9Qx+TA7dNLQ6ByMMW0zDGTIeMBz5Qa+hLT7Tj7gQWqI?=
 =?us-ascii?Q?mVOjKiiW/+1M8vksAE90OaZ0ycaIakGlXVMJRd3ULbuoltJ8pnlZhXVO8oQc?=
 =?us-ascii?Q?/As8AYwK+DejnZzrQhgPnD92+uu2nA2UGS3vTqwvh40DfdqA4+YJK3KfrjNN?=
 =?us-ascii?Q?CDsS50cw9w2HvQLeFfAeJiUZZXthy5y8MpGHtUfBi0AqGknZ+ZKYx9yTIL/j?=
 =?us-ascii?Q?Lg7Yb0aowwmgW4gKGcR4dEgibE2TrqpLXSPpUoutFCUR1Iej/g9A0TIaIX5v?=
 =?us-ascii?Q?NCtnE11uIN+EpoEgMayPTWVCJTdeoW4rE/eE2F8ZB7EH1gvhSqB/wHv5H99Z?=
 =?us-ascii?Q?Gre8pM3lqu2n4qaN8Yr5AMu5CQMLULO8+kbOdjG0LrBCR2t1g1Ajdr4HoMm9?=
 =?us-ascii?Q?RQHHf991xCLesAE6Sdbu1q1Rp5IwxNl0jE2EySOybpIK7j+F1oahy1gwnclD?=
 =?us-ascii?Q?wsO2fFVQlYLN1Klcvcyso5aERaetsry5Z72VC2ogUWI/KyJHAECsRBrUrS4L?=
 =?us-ascii?Q?MDNIJwYk5LMO6MeDZtyu39ENvvu9tWnLLuY8mZJfzcwGyFHoUwLL5BEQpfZT?=
 =?us-ascii?Q?fuW1waqKhFWHf8XsmOb/8yk9IJTiVnr1KPn2ImnXfArfyW4VWLT940/9l855?=
 =?us-ascii?Q?OABiTGgMNwQVhHGlbH68eDBvS7HC57ee8Kh9vNQ1THb9e6wqagfv9HUbvmkX?=
 =?us-ascii?Q?YDTKSAuNM7j2W0KPpoaSvF+Y5bY7/2eKXlbUGuH+Ecl+KIcaT2BGhJA7uVPM?=
 =?us-ascii?Q?PlBjLNX0mKpRX6kkdFqx6AjscXR/ajkt2OIqbKfV6zfLBfgP/DjRDi9hcJRL?=
 =?us-ascii?Q?oc4FCkKLg4KJxn3+rp4c8anNLeSLpZ3fwD22g9fIx322s71oi9wXPeVv7ZVv?=
 =?us-ascii?Q?O86iKaB/RdbEL8hG+PSD8gVeCeICr7KOaoMSIqu6kT2LtQFvuRJvi2y76hNf?=
 =?us-ascii?Q?lf2s+IqC7kMFHhJt9eu+jrWI6Gbx9DA4Cqo2sOhA825vaYiHiDVrDHQepQQu?=
 =?us-ascii?Q?BV8HDyKVukVNZDu6/1evnLgvWs02JFVZuFqBL9KbRNgniNIDuRM1?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15405D1CE081D34F84E7954B2620FDDA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c034d8a-3a0b-4acd-4b17-08da22feed1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2022 18:52:32.1100
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +aqsDcyckbZD7Z0b9PqwNOTL6qH2LKCtlHcWpDmUqgtJIETMI9gv2hxe3K6VQd2h3w93Jt1qplZmIppkRVLc+aQP1biOGMmkxylx6kiVMdc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2741
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-20_05:2022-04-20,2022-04-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 adultscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204200111
X-Proofpoint-ORIG-GUID: uA9Jna8-OknRqpYeUbm6-cY_9N22wN-a
X-Proofpoint-GUID: uA9Jna8-OknRqpYeUbm6-cY_9N22wN-a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 13, 2022, at 7:56 AM, Sumit Saxena <sumit.saxena@broadcom.com> wro=
te:
>=20
> This patch adds support for management applications to send an MPI3
> Encapsulated NVMe passthru commands to the NVMe devices attached to
> the Avenger controller. Since the NVMe drives are exposed as SCSI
> devices by the controller the standard NVMe applications cannot be
> used to interact with the drives and the command sets supported is
> also limited by the controller firmware. Special handling is required
> for MPI3 Encapsulated NVMe passthru commands for PRP/SGL setup in the
> commands hence the additional changes.
>=20
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
> drivers/scsi/mpi3mr/mpi3mr.h        |  25 ++
> drivers/scsi/mpi3mr/mpi3mr_app.c    | 348 +++++++++++++++++++++++++++-
> include/uapi/scsi/scsi_bsg_mpi3mr.h |   8 +
> 3 files changed, 378 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index 1de3b006f444..b2dbb6543a9b 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -193,6 +193,24 @@ extern atomic64_t event_counter;
>  */
> #define MPI3MR_MAX_APP_XFER_SECTORS	(2048 + 512)
>=20
> +/**
> + * struct mpi3mr_nvme_pt_sge -  Structure to store SGEs for NVMe
> + * Encapsulated commands.
> + *
> + * @base_addr: Physical address
> + * @length: SGE length
> + * @rsvd: Reserved
> + * @rsvd1: Reserved
> + * @sgl_type: sgl type
> + */
> +struct mpi3mr_nvme_pt_sge {
> +	u64 base_addr;
> +	u32 length;
> +	u16 rsvd;
> +	u8 rsvd1;
> +	u8 sgl_type;
> +};
> +
> /**
>  * struct mpi3mr_buf_map -  local structure to
>  * track kernel and user buffers associated with an BSG
> @@ -746,6 +764,9 @@ struct scmd_priv {
>  * @reset_waitq: Controller reset  wait queue
>  * @prepare_for_reset: Prepare for reset event received
>  * @prepare_for_reset_timeout_counter: Prepare for reset timeout
> + * @prp_list_virt: NVMe encapsulated PRP list virtual base
> + * @prp_list_dma: NVMe encapsulated PRP list DMA
> + * @prp_sz: NVME encapsulated PRP list size
>  * @diagsave_timeout: Diagnostic information save timeout
>  * @logging_level: Controller debug logging level
>  * @flush_io_count: I/O count to flush after reset
> @@ -901,6 +922,10 @@ struct mpi3mr_ioc {
> 	u8 prepare_for_reset;
> 	u16 prepare_for_reset_timeout_counter;
>=20
> +	void *prp_list_virt;
> +	dma_addr_t prp_list_dma;
> +	u32 prp_sz;
> +
> 	u16 diagsave_timeout;
> 	int logging_level;
> 	u16 flush_io_count;
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3m=
r_app.c
> index dada12216b97..428d3fcacbdb 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -621,6 +621,314 @@ static void mpi3mr_bsg_build_sgl(u8 *mpi_req, uint3=
2_t sgl_offset,
> 	}
> }
>=20
> +/**
> + * mpi3mr_get_nvme_data_fmt - returns the NVMe data format
> + * @nvme_encap_request: NVMe encapsulated MPI request
> + *
> + * This function returns the type of the data format specified
> + * in user provided NVMe command in NVMe encapsulated request.
> + *
> + * Return: Data format of the NVMe command (PRP/SGL etc)
> + */
> +static unsigned int mpi3mr_get_nvme_data_fmt(
> +	struct mpi3_nvme_encapsulated_request *nvme_encap_request)
> +{
> +	u8 format =3D 0;
> +
> +	format =3D ((nvme_encap_request->command[0] & 0xc000) >> 14);
> +	return format;
> +
> +}
> +
> +/**
> + * mpi3mr_build_nvme_sgl - SGL constructor for NVME
> + *				   encapsulated request
> + * @mrioc: Adapter instance reference
> + * @nvme_encap_request: NVMe encapsulated MPI request
> + * @drv_bufs: DMA address of the buffers to be placed in sgl
> + * @bufcnt: Number of DMA buffers
> + *
> + * This function places the DMA address of the given buffers in
> + * proper format as SGEs in the given NVMe encapsulated request.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int mpi3mr_build_nvme_sgl(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_nvme_encapsulated_request *nvme_encap_request,
> +	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt)
> +{
> +	struct mpi3mr_nvme_pt_sge *nvme_sgl;
> +	u64 sgl_ptr;
> +	u8 count;
> +	size_t length =3D 0;
> +	struct mpi3mr_buf_map *drv_buf_iter =3D drv_bufs;
> +	u64 sgemod_mask =3D ((u64)((mrioc->facts.sge_mod_mask) <<
> +			    mrioc->facts.sge_mod_shift) << 32);
> +	u64 sgemod_val =3D ((u64)(mrioc->facts.sge_mod_value) <<
> +			  mrioc->facts.sge_mod_shift) << 32;
> +
> +	/*
> +	 * Not all commands require a data transfer. If no data, just return
> +	 * without constructing any sgl.
> +	 */
> +	for (count =3D 0; count < bufcnt; count++, drv_buf_iter++) {
> +		if (drv_buf_iter->data_dir =3D=3D DMA_NONE)
> +			continue;
> +		sgl_ptr =3D (u64)drv_buf_iter->kern_buf_dma;
> +		length =3D drv_buf_iter->kern_buf_len;
> +		break;
> +	}
> +	if (!length)
> +		return 0;
> +
> +	if (sgl_ptr & sgemod_mask) {
> +		dprint_bsg_err(mrioc,
> +		    "%s: SGL address collides with SGE modifier\n",
> +		    __func__);
> +		return -1;
> +	}
> +
> +	sgl_ptr &=3D ~sgemod_mask;
> +	sgl_ptr |=3D sgemod_val;
> +	nvme_sgl =3D (struct mpi3mr_nvme_pt_sge *)
> +	    ((u8 *)(nvme_encap_request->command) + MPI3MR_NVME_CMD_SGL_OFFSET);
> +	memset(nvme_sgl, 0, sizeof(struct mpi3mr_nvme_pt_sge));
> +	nvme_sgl->base_addr =3D sgl_ptr;
> +	nvme_sgl->length =3D length;
> +	return 0;
> +}
> +
> +/**
> + * mpi3mr_build_nvme_prp - PRP constructor for NVME
> + *			       encapsulated request
> + * @mrioc: Adapter instance reference
> + * @nvme_encap_request: NVMe encapsulated MPI request
> + * @drv_bufs: DMA address of the buffers to be placed in SGL
> + * @bufcnt: Number of DMA buffers
> + *
> + * This function places the DMA address of the given buffers in
> + * proper format as PRP entries in the given NVMe encapsulated
> + * request.
> + *
> + * Return: 0 on success, -1 on failure
> + */
> +static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
> +	struct mpi3_nvme_encapsulated_request *nvme_encap_request,
> +	struct mpi3mr_buf_map *drv_bufs, u8 bufcnt)
> +{
> +	int prp_size =3D MPI3MR_NVME_PRP_SIZE;
> +	__le64 *prp_entry, *prp1_entry, *prp2_entry;
> +	__le64 *prp_page;
> +	dma_addr_t prp_entry_dma, prp_page_dma, dma_addr;
> +	u32 offset, entry_len, dev_pgsz;
> +	u32 page_mask_result, page_mask;
> +	size_t length =3D 0;
> +	u8 count;
> +	struct mpi3mr_buf_map *drv_buf_iter =3D drv_bufs;
> +	u64 sgemod_mask =3D ((u64)((mrioc->facts.sge_mod_mask) <<
> +			    mrioc->facts.sge_mod_shift) << 32);
> +	u64 sgemod_val =3D ((u64)(mrioc->facts.sge_mod_value) <<
> +			  mrioc->facts.sge_mod_shift) << 32;
> +	u16 dev_handle =3D nvme_encap_request->dev_handle;
> +	struct mpi3mr_tgt_dev *tgtdev;
> +
> +	tgtdev =3D mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
> +	if (!tgtdev) {
> +		dprint_bsg_err(mrioc, "%s: invalid device handle 0x%04x\n",
> +			__func__, dev_handle);
> +		return -1;
> +	}
> +
> +	if (tgtdev->dev_spec.pcie_inf.pgsz =3D=3D 0) {
> +		dprint_bsg_err(mrioc,
> +		    "%s: NVMe device page size is zero for handle 0x%04x\n",
> +		    __func__, dev_handle);
> +		mpi3mr_tgtdev_put(tgtdev);
> +		return -1;
> +	}
> +
> +	dev_pgsz =3D 1 << (tgtdev->dev_spec.pcie_inf.pgsz);
> +	mpi3mr_tgtdev_put(tgtdev);
> +
> +	/*
> +	 * Not all commands require a data transfer. If no data, just return
> +	 * without constructing any PRP.
> +	 */
> +	for (count =3D 0; count < bufcnt; count++, drv_buf_iter++) {
> +		if (drv_buf_iter->data_dir =3D=3D DMA_NONE)
> +			continue;
> +		dma_addr =3D drv_buf_iter->kern_buf_dma;
> +		length =3D drv_buf_iter->kern_buf_len;
> +		break;
> +	}
> +
> +	if (!length)
> +		return 0;
> +
> +	mrioc->prp_sz =3D 0;
> +	mrioc->prp_list_virt =3D dma_alloc_coherent(&mrioc->pdev->dev,
> +	    dev_pgsz, &mrioc->prp_list_dma, GFP_KERNEL);
> +
> +	if (!mrioc->prp_list_virt)
> +		return -1;
> +	mrioc->prp_sz =3D dev_pgsz;
> +
> +	/*
> +	 * Set pointers to PRP1 and PRP2, which are in the NVMe command.
> +	 * PRP1 is located at a 24 byte offset from the start of the NVMe
> +	 * command.  Then set the current PRP entry pointer to PRP1.
> +	 */
> +	prp1_entry =3D (__le64 *)((u8 *)(nvme_encap_request->command) +
> +	    MPI3MR_NVME_CMD_PRP1_OFFSET);
> +	prp2_entry =3D (__le64 *)((u8 *)(nvme_encap_request->command) +
> +	    MPI3MR_NVME_CMD_PRP2_OFFSET);
> +	prp_entry =3D prp1_entry;
> +	/*
> +	 * For the PRP entries, use the specially allocated buffer of
> +	 * contiguous memory.
> +	 */
> +	prp_page =3D (__le64 *)mrioc->prp_list_virt;
> +	prp_page_dma =3D mrioc->prp_list_dma;
> +
> +	/*
> +	 * Check if we are within 1 entry of a page boundary we don't
> +	 * want our first entry to be a PRP List entry.
> +	 */
> +	page_mask =3D dev_pgsz - 1;
> +	page_mask_result =3D (uintptr_t)((u8 *)prp_page + prp_size) & page_mask=
;
> +	if (!page_mask_result) {
> +		dprint_bsg_err(mrioc, "%s: PRP page is not page aligned\n",
> +		    __func__);
> +		goto err_out;
> +	}
> +
> +	/*
> +	 * Set PRP physical pointer, which initially points to the current PRP
> +	 * DMA memory page.
> +	 */
> +	prp_entry_dma =3D prp_page_dma;
> +
> +
> +	/* Loop while the length is not zero. */
> +	while (length) {
> +		page_mask_result =3D (prp_entry_dma + prp_size) & page_mask;
> +		if (!page_mask_result && (length >  dev_pgsz)) {
> +			dprint_bsg_err(mrioc,
> +			    "%s: single PRP page is not sufficient\n",
> +			    __func__);
> +			goto err_out;
> +		}
> +
> +		/* Need to handle if entry will be part of a page. */
> +		offset =3D dma_addr & page_mask;
> +		entry_len =3D dev_pgsz - offset;
> +
> +		if (prp_entry =3D=3D prp1_entry) {
> +			/*
> +			 * Must fill in the first PRP pointer (PRP1) before
> +			 * moving on.
> +			 */
> +			*prp1_entry =3D cpu_to_le64(dma_addr);
> +			if (*prp1_entry & sgemod_mask) {
> +				dprint_bsg_err(mrioc,
> +				    "%s: PRP1 address collides with SGE modifier\n",
> +				    __func__);
> +				goto err_out;
> +			}
> +			*prp1_entry &=3D ~sgemod_mask;
> +			*prp1_entry |=3D sgemod_val;
> +
> +			/*
> +			 * Now point to the second PRP entry within the
> +			 * command (PRP2).
> +			 */
> +			prp_entry =3D prp2_entry;
> +		} else if (prp_entry =3D=3D prp2_entry) {
> +			/*
> +			 * Should the PRP2 entry be a PRP List pointer or just
> +			 * a regular PRP pointer?  If there is more than one
> +			 * more page of data, must use a PRP List pointer.
> +			 */
> +			if (length > dev_pgsz) {
> +				/*
> +				 * PRP2 will contain a PRP List pointer because
> +				 * more PRP's are needed with this command. The
> +				 * list will start at the beginning of the
> +				 * contiguous buffer.
> +				 */
> +				*prp2_entry =3D cpu_to_le64(prp_entry_dma);
> +				if (*prp2_entry & sgemod_mask) {
> +					dprint_bsg_err(mrioc,
> +					    "%s: PRP list address collides with SGE modifier\n",
> +					    __func__);
> +					goto err_out;
> +				}
> +				*prp2_entry &=3D ~sgemod_mask;
> +				*prp2_entry |=3D sgemod_val;
> +
> +				/*
> +				 * The next PRP Entry will be the start of the
> +				 * first PRP List.
> +				 */
> +				prp_entry =3D prp_page;
> +				continue;
> +			} else {
> +				/*
> +				 * After this, the PRP Entries are complete.
> +				 * This command uses 2 PRP's and no PRP list.
> +				 */
> +				*prp2_entry =3D cpu_to_le64(dma_addr);
> +				if (*prp2_entry & sgemod_mask) {
> +					dprint_bsg_err(mrioc,
> +					    "%s: PRP2 collides with SGE modifier\n",
> +					    __func__);
> +					goto err_out;
> +				}
> +				*prp2_entry &=3D ~sgemod_mask;
> +				*prp2_entry |=3D sgemod_val;
> +			}
> +		} else {
> +			/*
> +			 * Put entry in list and bump the addresses.
> +			 *
> +			 * After PRP1 and PRP2 are filled in, this will fill in
> +			 * all remaining PRP entries in a PRP List, one per
> +			 * each time through the loop.
> +			 */
> +			*prp_entry =3D cpu_to_le64(dma_addr);
> +			if (*prp1_entry & sgemod_mask) {
> +				dprint_bsg_err(mrioc,
> +				    "%s: PRP address collides with SGE modifier\n",
> +				    __func__);
> +				goto err_out;
> +			}
> +			*prp_entry &=3D ~sgemod_mask;
> +			*prp_entry |=3D sgemod_val;
> +			prp_entry++;
> +			prp_entry_dma++;
> +		}
> +
> +		/*
> +		 * Bump the phys address of the command's data buffer by the
> +		 * entry_len.
> +		 */
> +		dma_addr +=3D entry_len;
> +
> +		/* decrement length accounting for last partial page. */
> +		if (entry_len > length)
> +			length =3D 0;
> +		else
> +			length -=3D entry_len;
> +	}
> +	return 0;
> +err_out:
> +	if (mrioc->prp_list_virt) {
> +		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
> +		    mrioc->prp_list_virt, mrioc->prp_list_dma);
> +		mrioc->prp_list_virt =3D NULL;
> +	}
> +	return -1;
> +}
> /**
>  * mpi3mr_bsg_process_mpt_cmds - MPI Pass through BSG handler
>  * @job: BSG job reference
> @@ -652,7 +960,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_jo=
b *job, unsigned int *reply
> 	struct mpi3mr_buf_map *drv_bufs =3D NULL, *drv_buf_iter =3D NULL;
> 	u8 count, bufcnt =3D 0, is_rmcb =3D 0, is_rmrb =3D 0, din_cnt =3D 0, dou=
t_cnt =3D 0;
> 	u8 invalid_be =3D 0, erb_offset =3D 0xFF, mpirep_offset =3D 0xFF, sg_ent=
ries =3D 0;
> -	u8 block_io =3D 0, resp_code =3D 0;
> +	u8 block_io =3D 0, resp_code =3D 0, nvme_fmt =3D 0;
> 	struct mpi3_request_header *mpi_header =3D NULL;
> 	struct mpi3_status_reply_descriptor *status_desc;
> 	struct mpi3_scsi_task_mgmt_request *tm_req;
> @@ -892,7 +1200,34 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job, unsigned int *reply
> 		goto out;
> 	}
>=20
> -	if (mpi_header->function !=3D MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) {
> +	if (mpi_header->function =3D=3D MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) {
> +		nvme_fmt =3D mpi3mr_get_nvme_data_fmt(
> +			(struct mpi3_nvme_encapsulated_request *)mpi_req);
> +		if (nvme_fmt =3D=3D MPI3MR_NVME_DATA_FORMAT_PRP) {
> +			if (mpi3mr_build_nvme_prp(mrioc,
> +			    (struct mpi3_nvme_encapsulated_request *)mpi_req,
> +			    drv_bufs, bufcnt)) {
> +				rval =3D -ENOMEM;
> +				mutex_unlock(&mrioc->bsg_cmds.mutex);
> +				goto out;
> +			}
> +		} else if (nvme_fmt =3D=3D MPI3MR_NVME_DATA_FORMAT_SGL1 ||
> +			nvme_fmt =3D=3D MPI3MR_NVME_DATA_FORMAT_SGL2) {
> +			if (mpi3mr_build_nvme_sgl(mrioc,
> +			    (struct mpi3_nvme_encapsulated_request *)mpi_req,
> +			    drv_bufs, bufcnt)) {
> +				rval =3D -EINVAL;
> +				mutex_unlock(&mrioc->bsg_cmds.mutex);
> +				goto out;
> +			}
> +		} else {
> +			dprint_bsg_err(mrioc,
> +			    "%s:invalid NVMe command format\n", __func__);
> +			rval =3D -EINVAL;
> +			mutex_unlock(&mrioc->bsg_cmds.mutex);
> +			goto out;
> +		}
> +	} else {
> 		mpi3mr_bsg_build_sgl(mpi_req, (mpi_msg_size),
> 		    drv_bufs, bufcnt, is_rmcb, is_rmrb,
> 		    (dout_cnt + din_cnt));
> @@ -970,7 +1305,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_j=
ob *job, unsigned int *reply
> 			}
> 		}
>=20
> -		if (mpi_header->function =3D=3D MPI3_BSG_FUNCTION_SCSI_IO)
> +		if ((mpi_header->function =3D=3D MPI3_BSG_FUNCTION_NVME_ENCAPSULATED) =
||
> +		    (mpi_header->function =3D=3D MPI3_BSG_FUNCTION_SCSI_IO))
> 			mpi3mr_issue_tm(mrioc,
> 			    MPI3_SCSITASKMGMT_TASKTYPE_TARGET_RESET,
> 			    mpi_header->function_dependent, 0,
> @@ -984,6 +1320,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_=
job *job, unsigned int *reply
> 	}
> 	dprint_bsg_info(mrioc, "%s: bsg request is completed\n", __func__);
>=20
> +	if (mrioc->prp_list_virt) {
> +		dma_free_coherent(&mrioc->pdev->dev, mrioc->prp_sz,
> +		    mrioc->prp_list_virt, mrioc->prp_list_dma);
> +		mrioc->prp_list_virt =3D NULL;
> +	}
> +
> 	if ((mrioc->bsg_cmds.ioc_status & MPI3_IOCSTATUS_STATUS_MASK)
> 	     !=3D MPI3_IOCSTATUS_SUCCESS) {
> 		dprint_bsg_info(mrioc,
> diff --git a/include/uapi/scsi/scsi_bsg_mpi3mr.h b/include/uapi/scsi/scsi=
_bsg_mpi3mr.h
> index 870e6d87dd03..67f14c89b255 100644
> --- a/include/uapi/scsi/scsi_bsg_mpi3mr.h
> +++ b/include/uapi/scsi/scsi_bsg_mpi3mr.h
> @@ -488,6 +488,14 @@ struct mpi3_nvme_encapsulated_error_reply {
> 	__le32                     nvme_completion_entry[4];
> };
>=20
> +#define	MPI3MR_NVME_PRP_SIZE		8 /* PRP size */
> +#define	MPI3MR_NVME_CMD_PRP1_OFFSET	24 /* PRP1 offset in NVMe cmd */
> +#define	MPI3MR_NVME_CMD_PRP2_OFFSET	32 /* PRP2 offset in NVMe cmd */
> +#define	MPI3MR_NVME_CMD_SGL_OFFSET	24 /* SGL offset in NVMe cmd */
> +#define MPI3MR_NVME_DATA_FORMAT_PRP	0
> +#define MPI3MR_NVME_DATA_FORMAT_SGL1	1
> +#define MPI3MR_NVME_DATA_FORMAT_SGL2	2
> +
> /* MPI3: task management related definitions */
> struct mpi3_scsi_task_mgmt_request {
> 	__le16                     host_tag;
> --=20
> 2.27.0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

---
Himanshu Madhani	Oracle Linux Engineering

