Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 957B4C433E9
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FF3865101
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 16:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236656AbhCPQ13 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 12:27:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:45902 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238758AbhCPQ1S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 12:27:18 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGK467041948;
        Tue, 16 Mar 2021 16:27:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=n/2ilrmFcJ1CGleg6AB9UgPk6gw7MQPc7EeqUKCAZTo=;
 b=bTjpW7eRlmJ6RbKeQYyERiUz+7OScG0pYMJm20DmnGT0jNBxaJTp578C+emYcZ+/6qyg
 HDWatpJtl4w2ao7Q8RgbfSY5rtlOgQKoBq7AyCxmFMxlBewNfwltrttyum3SVx3woLGM
 PgeC1gSp1o0tUrmoHKzxAU7Qry/8xuXF4omuw1fYPLwlGeGPSYUkMCX5dNGN6jmbsCjB
 hliheuus3koFgT/0CYT7dUejKjrVHGt1+C41a4JOsIVEarlFqxqDtjuQshE2c7ujJ+Kr
 7ViGKyi8zBmfTeybtC5GqJni4xgBPNmddgT7hIY0L2a7owqkp0GQDKGP2IxutGMlroFA 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 378jwbgy1t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:27:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12GGM2Xf178809;
        Tue, 16 Mar 2021 16:27:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by aserp3020.oracle.com with ESMTP id 3797a1duu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 16:27:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbIb3QlTTcc7VzHaySmF1K90/CfPpG5laLNpxFvXV7mj5BSOubAMqv/nhWGE0VtZxm7Mw87ryNT56LLHYy8KnacEwRmWizOCGBPUQdQOaeRVzG/RL9jbMcs4Bppzw5kqX7DizBFvjBfwMHflIzXIs/4LYfdccRoEmurfi0vHq9RW6FRGsgL+5pkxVUG4rlOxvub6C7ZF8aJuRd2u4I2vXTX8TCZ3UhzWuhwbmJhhsK5U40Pdui4bxM4eZIW92m3g/4UpneWSJix+xcuxGtzMciEFa+2AxxO2xhdUYlaZ/e0DsNhdBzO6EFSZiBn8RSsdeFsWmoCbQrDmpt2isX29EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/2ilrmFcJ1CGleg6AB9UgPk6gw7MQPc7EeqUKCAZTo=;
 b=HqjfZhsayOWodm0cYohepT7AbfzVkJL8/37zqT2PHAJmnP+foRa/LmzwsovGaABGuw2NFVnQl2uQJmOxR7j71xpu7m/K46TQc9I+qkUJySItj/TxLWFKKR5zYkSnO9wfvkprekXR57yZd+9nXYcwp2fyLN4GOnomcoq+GsTg1qP9maDF/c2tL8SFTCtHSepaXUcCCTbifR0fMhjqrihbz3RCQmz91ulVHlXzhwnSj1c0Dt2KOdyT7LLPbssrANMXc317q0vKCCjUFD+XyzV3UZjXqLt1u29ks4aS55VvjXQfXOvYh49jXCAUNfRNbR5/CaZAOzitHTX4eAXjqvYhqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n/2ilrmFcJ1CGleg6AB9UgPk6gw7MQPc7EeqUKCAZTo=;
 b=KZWgHyqFlTqN0nJesv/xFIKNg+yhRHN6KBHQBZYtrQyRo2ww2RzBJAAtz9o0mMK542gBV34OZu6ObY3eES70WGZDk4UHJVGSTjhreqCuY9nM/8Hj0pHTRpOB6tfqj3TenvTlaGrnaq2cFjaFO3NaJ9iblo9Im6gRbB4/TTQpfAk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2464.namprd10.prod.outlook.com (2603:10b6:805:4d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 16:27:01 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 16:27:01 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Quinn Tran <qutran@marvell.com>,
        Michael Christie <michael.christie@oracle.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 3/7] qla2xxx: Fix endianness annotations
Thread-Topic: [PATCH 3/7] qla2xxx: Fix endianness annotations
Thread-Index: AQHXGhhxqfEbxfCrq0yiVGQm1yYsxKqGzjGA
Date:   Tue, 16 Mar 2021 16:27:01 +0000
Message-ID: <E14899CE-78D3-4F9D-99CD-051DF7E0891B@oracle.com>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-4-bvanassche@acm.org>
In-Reply-To: <20210316035655.2835-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b2e3634a-0f61-4ecc-3df0-08d8e8985422
x-ms-traffictypediagnostic: SN6PR10MB2464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB246485CAEDD2687DF4249DC7E66B9@SN6PR10MB2464.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:353;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VFzs6mbY89Gmruog8RRhqdCBzU3WR9UZYg0nvd8AK/drKYGfnktmejO8NKSQvz4gna1ouJ8tZjf2w5NtJfodDlqmQLjb804GFlsXczrKZqjrt3G496lyQl3K8b64IgmjF8fC4f86WBqVzaZmm4WYa7k8zDDUJX/jb3b1lm7WYPaxIRnOR0cSVFQzbj9fa5Co6uC5QVfpZ7m1ujJ5B4/wHbcVKoX+C8e1wOcJvuRoMO7UiwsMjXmP6rNIGWEgC8bbryS+/BzwGEBefwG4xl78DGHLnNxz3AdFUzuUfUW3S8QimeihJtojKjIDBKSDKBmPKj/z4dPCg+Z8rD3G3gJlhP32R82e4TIxN1FSLcb7BEo5RhXwQAiH064NLQcaVLk61cnWoKcX2EJRS2S2mNI68j897dO8xfiQrhtWF599JH4dTYTfZSZ7V1iMOEdDG3De0bETnzFzLa/oT5id1ZODSrfglQvyOkv7abXssNzvTJOUhHRckwOVpcNrHe/p6QpVuwo/FCUEVG7KLdLY88WBEeFUmrC3WhRz9wvjiswtnlUHwYXkFKTVUZSpkQeHbtXGOdAH2YkOfzZFPb8PiGe17JAqqVq9Wha2mkiiIJ67MEzcfb2KsaMysX1WyqUQils7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(346002)(39860400002)(376002)(396003)(66446008)(66476007)(36756003)(6486002)(66946007)(8676002)(6916009)(316002)(64756008)(66556008)(2906002)(53546011)(33656002)(71200400001)(6506007)(54906003)(5660300002)(478600001)(4326008)(2616005)(8936002)(26005)(44832011)(76116006)(186003)(86362001)(83380400001)(6512007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?9NpGKSbBBv9eyKMa0miswpfF0B/x9Nf4RS+1tHFImD7vRm1xG0CsFrO2ttSk?=
 =?us-ascii?Q?6MGSDrzEQ0Zy8LnQh415YWvl4vt2Ykad3XqzGDaePmLwyMDcKQp3AcGZgkZV?=
 =?us-ascii?Q?OUKB+brgm5u55I+dvw47HKGiN14ipUKiiFECKYc5yD9qaqZrkukcFhBSm9Fb?=
 =?us-ascii?Q?9ZyDpLSSmv3ByVDyR0DZ6EDT5TA/FHYMciLB0EJ2KE0vhgpMZvnnsAmLXW2X?=
 =?us-ascii?Q?k3RD9t3IcVbemI9oyLGFxXYWt2xHFH9SBj9hDQ+pgafTYqLuScd/FTHoQjv3?=
 =?us-ascii?Q?xdxYgtTMXfCs3stBQzNpMsM8qGYW33SIxCfyyrFUWWpwnqHFBexFbp9U6VeD?=
 =?us-ascii?Q?8TR74rZ7GXnDOYJrKPOGGCI9K0gPxH6cogLkDnFW/LMuUYvxWIhFGB+kNpIO?=
 =?us-ascii?Q?aaJHo6jS3ln8miwymEoXq8db5gIyhqLlDGFrAXmRrag1xwFHi3pbZGJfhRHu?=
 =?us-ascii?Q?TF4fuxVW3JJXqATxqZuXa5r5YkxKlcua2u56SXuOMuc7vUqw1oo/O5XZ4r6C?=
 =?us-ascii?Q?BSawZMRzYOQOjtGMxbKxsp0uUq5E/jkAHiAJQBPQR7cv6YpMOdlE5BlRH3yN?=
 =?us-ascii?Q?+tyrNHOO6OkSY9Y564Xu88lA06aAhMDH+ZwtemTFcxU9shIeTefmTRLux5QF?=
 =?us-ascii?Q?zpsgvpQj6CXmwpKFHU94nrUsHM/stTWHbDor6KBnm+W9YEApz86nw4pJNSsp?=
 =?us-ascii?Q?yuaurMU4gN7UGwTHAnBGTaktuNammMErua+fmBRiZGSosGKLDDd6XmDNPkc+?=
 =?us-ascii?Q?Rsi7+KJA+ptVsPtXrN/JJ7dhZieK0PtuVSpQRGXYDGu6xXLBatmofMkKLwVd?=
 =?us-ascii?Q?T5rJfeUrFspKykCXSQa5+8bIC5O60wM2FZlKedLPGQJJOvGdRMPl78bgIy8J?=
 =?us-ascii?Q?pNN0w72iFMwR+eF1DvWCcr80jjFEy+oNZaKJU78vCe+z+AkYaKs6QC+jsBB7?=
 =?us-ascii?Q?/hYMEwbuGpxh92c+8nXqhySeuNmGZr1I+1L32iUgJybT7IF8zyMAS0K32gc0?=
 =?us-ascii?Q?k9P1nMz4v6lY74h0ZN/GPRg74VTi3AXlreTuJTLyH5VyJRCAD6ot7g75qY4V?=
 =?us-ascii?Q?XMhqEnU3S/gR0e+Rhext/Dv2BaYXQjP9KlJtDbePow/VCLDvl5O7F666U/o9?=
 =?us-ascii?Q?Lm/pHFwVy6dYDNl3zbZXkSI+kNjdRQQVxiNZwzUnyzF/EPIEYTFg7GD19Ku/?=
 =?us-ascii?Q?RAaLzmO0IV1QnFm/nkovDc7ZX6gjpL88sZSy0xrQPFX0zCqOn0Ahp6smLAhQ?=
 =?us-ascii?Q?SBUKmr2E3Jb99WUiWZLexj7wAgiiKFcRApFlPuuDGYdiKW5Oj8ibzMwT3FXJ?=
 =?us-ascii?Q?DWFd7B0d/NMvJxyYpfDB4mutAmttnPW5X4PMIisJZGbZwA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <08D12B71137CA346B86C263853E72D9B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2e3634a-0f61-4ecc-3df0-08d8e8985422
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2021 16:27:01.6149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bIF0R69G69SKYQfS1i1bhw0twZFc5GNIMSBKrP7hUUV90Kem5Nd30fGtIAC4RtpAwLeO2pa6jHgpdhfrSEl6EPtDLtFweJyDKwzWiQDNj+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2464
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160107
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 15, 2021, at 10:56 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Fix all recently introduced endianness annotation issues.
>=20
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Daniel Wagner <dwagner@suse.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/qla2xxx/qla_def.h  | 2 +-
> drivers/scsi/qla2xxx/qla_iocb.c | 3 ++-
> drivers/scsi/qla2xxx/qla_isr.c  | 2 +-
> drivers/scsi/qla2xxx/qla_sup.c  | 9 +++++----
> 4 files changed, 9 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 3bdf55bb0833..52ba75591f9a 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -1527,7 +1527,7 @@ struct init_sf_cb {
> 	 * BIT_12 =3D Remote Write Optimization (1 - Enabled, 0 - Disabled)
> 	 * BIT 11-0 =3D Reserved
> 	 */
> -	uint16_t flags;
> +	__le16	flags;
> 	uint8_t	reserved1[32];
> 	uint16_t discard_OHRB_timeout_value;
> 	uint16_t remote_write_opt_queue_num;
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 8b41cbaf8535..eb2376b138c1 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2379,7 +2379,8 @@ qla24xx_prli_iocb(srb_t *sp, struct logio_entry_24x=
x *logio)
> 				cpu_to_le32(NVME_PRLI_SP_FIRST_BURST);
> 		if (sp->vha->flags.nvme2_enabled) {
> 			/* Set service parameter BIT_7 for NVME CONF support */
> -			logio->io_parameter[0] |=3D NVME_PRLI_SP_CONF;
> +			logio->io_parameter[0] |=3D
> +				cpu_to_le32(NVME_PRLI_SP_CONF);
> 			/* Set service parameter BIT_8 for SLER support */
> 			logio->io_parameter[0] |=3D
> 				cpu_to_le32(NVME_PRLI_SP_SLER);
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 27165abda96d..0fa7082f3cc8 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3440,7 +3440,7 @@ qla24xx_abort_iocb_entry(scsi_qla_host_t *vha, stru=
ct req_que *req,
> 		return;
>=20
> 	abt =3D &sp->u.iocb_cmd;
> -	abt->u.abt.comp_status =3D le16_to_cpu(pkt->comp_status);
> +	abt->u.abt.comp_status =3D pkt->comp_status;
> 	orig_sp =3D sp->cmd_sp;
> 	/* Need to pass original sp */
> 	if (orig_sp)
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_su=
p.c
> index f771fabcba59..060c89237777 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -2621,10 +2621,11 @@ qla24xx_read_optrom_data(struct scsi_qla_host *vh=
a, void *buf,
> }
>=20
> static int
> -qla28xx_extract_sfub_and_verify(struct scsi_qla_host *vha, uint32_t *buf=
,
> +qla28xx_extract_sfub_and_verify(struct scsi_qla_host *vha, __le32 *buf,
>     uint32_t len, uint32_t buf_size_without_sfub, uint8_t *sfub_buf)
> {
> -	uint32_t *p, check_sum =3D 0;
> +	uint32_t check_sum =3D 0;
> +	__le32 *p;
> 	int i;
>=20
> 	p =3D buf + buf_size_without_sfub;
> @@ -2790,8 +2791,8 @@ qla28xx_write_flash_data(scsi_qla_host_t *vha, uint=
32_t *dwptr, uint32_t faddr,
> 			goto done;
> 		}
>=20
> -		rval =3D qla28xx_extract_sfub_and_verify(vha, dwptr, dwords,
> -			buf_size_without_sfub, (uint8_t *)sfub);
> +		rval =3D qla28xx_extract_sfub_and_verify(vha, (__le32 *)dwptr,
> +			dwords, buf_size_without_sfub, (uint8_t *)sfub);
>=20
> 		if (rval !=3D QLA_SUCCESS)
> 			goto done;

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

