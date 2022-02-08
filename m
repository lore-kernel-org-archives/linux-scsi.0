Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7077DC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 19:22:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386005AbiBHTW1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 14:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240970AbiBHTWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 14:22:23 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD89C0613CB
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 11:22:22 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218J7rp9026751;
        Tue, 8 Feb 2022 19:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=f+FXNdawQ5+RfD3G8VdWjjAjsdhiImi9hgIjQ3ma6FI=;
 b=ISFXRZnHVFFXKRDqteFDJIlu3gUHVozjwKwRm/760fuov0kN6wEelS3TcRlGZEEERHCR
 XCqJ9p2LEHuYcUISxBDrxVVWOPt8Ur8hYdb010mdEan2P2IJEk9/I/9emShFG0bnDxjo
 NhJ99VQxSTZQca2B3LFrVxPvgwnWw2TQsVJKmk6yj5tqMWvRrSWqEIcN+H98PXlGlznu
 fIOUN2f5NXKPtbLds2jDZn1Pfiel+AKpw+tNRMBcPu4LO2SK7SJG31HQ+egns+nxHZSu
 RYAGuBkVROsg6TwCD/I/sY11+VIH67WKtEXpRbVqL/NePDMnHtW+vs3Sep70ldhNMAhx IA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28jbty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 218JG8xd107526;
        Tue, 8 Feb 2022 19:22:17 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2170.outbound.protection.outlook.com [104.47.73.170])
        by userp3020.oracle.com with ESMTP id 3e1jprdme0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Feb 2022 19:22:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLhnFTgVvEzxfThFEAh50SCbT6JFuXEkD+hr6AJjMQ+xwihc/SoPl2LbUSo6oYnNsvVWwmEt9fgKe77mQONbVBusN56F2slWCCrc1zdOEQPSPwE+IUq4CEfGM2GG8DPlnvYP1uPwqfR6+1dslQTEixWuGN8O1UP5Z8rCkYbqoFiefUJHOUxUHbFrd1dsF+pU7BpfnhZuGLXpM5u3awKd41+PqHWfEoRHosEwuLZNG3d2pVYgu/w/J2V0boGq07/5ecMxHEUmRIKDJ6Bi2dAA+WhTgsm1UJJcCI28dYLkXT33mo56Vf+F0UzgvFEl3gNONU6mdNujWUEOSdaLkgNPNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f+FXNdawQ5+RfD3G8VdWjjAjsdhiImi9hgIjQ3ma6FI=;
 b=FyGeRu7kopdBtzE1w9iWvsmiYzu2aHKBdU4ft0iH4Z8R/o4GWtXTq6ucQarom0f/Gc8NU0HYxqGtaGzad12Vbqy7ccio8/i402ShZqAbe4NNGaxqP64nzpJQTWsuHrOdc6/1A34gagcJOHuwkCe4mmTqXo3eyVCAKijATbbYFFYXtJvEJO3anqwytADvqe+z4CMdO1lN76RB6r+4xvefLQ3jJVn8ZkTfO3JrxHE1zjZXmlYnkxscAhW1mxCzHfT4t9fBnrdXRgZufRCiWwDsOpwtnJ4O5u/Uh5uYCA9LpPhn9oG3QCgnjuSP+WFxTHxav+KwOzu6apXkEiorh5Lxow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f+FXNdawQ5+RfD3G8VdWjjAjsdhiImi9hgIjQ3ma6FI=;
 b=gFdb9rkJbq9KYb8z3ddKP3dS0NmxlxJldhC/gvW5YIiarAFzTRrKVS+txMgI+q2axtgAPkyn/hZcIqIgAUcKdX2VZM7iHSyM9oclbmMdvcDSIp4SymdWBO5X1PeCA2x9QMW/oTcYuDrWDBFLz04diOyDtEDQuE92A+oqCPRYrRE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB2969.namprd10.prod.outlook.com (2603:10b6:5:6a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Tue, 8 Feb
 2022 19:22:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Tue, 8 Feb 2022
 19:22:14 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 02/44] nsp_cs: Use true and false instead of TRUE and
 FALSE
Thread-Topic: [PATCH v2 02/44] nsp_cs: Use true and false instead of TRUE and
 FALSE
Thread-Index: AQHYHREvvRxDRbzOsUO6oymTJwhY9KyKCDgA
Date:   Tue, 8 Feb 2022 19:22:14 +0000
Message-ID: <B464FC7D-E068-4A6C-9131-4B899D15A68D@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-3-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-3-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78ba7d90-3b34-409b-b336-08d9eb38504b
x-ms-traffictypediagnostic: DM6PR10MB2969:EE_
x-microsoft-antispam-prvs: <DM6PR10MB2969C1B33D6F04AA24A46F4BE62D9@DM6PR10MB2969.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tLxKyL7d3CVk34ORiRU6NOuh8CjVCyZ7JIc7YqJeSF4r+sTIKpCuDy4+n8bm0L0SNfGW1hijY4EEDtNyXMWV8LDepTZyaldCnw0jD8NmgNuFpj/Q/IDRhRhY1FJ2oyJSkyT1FsKV2krLmjmyzrXq+NTspzgDi0tcsjdT/cAWbma58T29Q+eqzeVhgWxkLVvIUmGUuPdSHvLSNzeKP9ouujTakLzSu0TP5ohxsNKsbq03TpDKMld2evMUeZppLFV2eYubyL25c7tGC15fSlxCtzv6PlzaS50vo7aQ2BVCZX6YGE9i3v2fU6PmuTm7WosIY29GGuQVtiNozGoxCvrGZxarzOMRG7FOXO9t7f4bAD71ocKf172CW2Smxg8jLpz1+IROjdbj/SFncAg4QGKBOSmqT3ALKeshPHxN0Iwgn6SHybNUzi3BGh574GXH/eb4qVkP7LaOGuEMWRuo2Agjy0QzNzZ1/2si859lfohMvoQtDaU7SqALJvkMez/ET4J/iAyEKrSHbI8QkO2P9J5+uzHHAkNxTI239eDcbO8OmtprfZnLPL6bCvytlltLVqq0STyOe1FwQbnA8NsJeYJOJ3VhgbUZCjFPAHCZOlENwwurHz8CSfGxWXMCo2EXCouOF0p/2KbZi69ETQLupOCdHL9hUq4IY9k70YHlfrfVOiu/PJLsSM+u9/lgGX1ulrYJ1rgRCNJDuxyc9770YaRPviDnmDi6WtwMhEhEr0jW5lJowwqRDSISKaChQQZM3A2y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(122000001)(86362001)(38070700005)(66556008)(4326008)(36756003)(91956017)(38100700002)(66946007)(76116006)(8936002)(66446008)(66476007)(54906003)(316002)(6916009)(64756008)(83380400001)(44832011)(6486002)(508600001)(71200400001)(6512007)(2906002)(6506007)(33656002)(2616005)(5660300002)(53546011)(8676002)(26005)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?k7nWNfAT11UxjOudSOmYZ8+AbaaGdIlnfveO7wRvaS/jrcapKtSlsazendYO?=
 =?us-ascii?Q?ykN2vZkVtA7MzVN9lPabnYJxW74B/J/En9UBWdk+NbkPdGQ3+1OqzJ9bGhle?=
 =?us-ascii?Q?klsrRgKZE3po2wLUpR/TvX6zuhGPLX25ZJnhFLR9g2cUOvgfQwC8qljUIX32?=
 =?us-ascii?Q?e/1K/i+PuUkrNwM4sLIp35z4Vtrl0teS2JqLtj6nf8L1XcackVCG9sAIMzZQ?=
 =?us-ascii?Q?dnfnsbbVmAHUnX+4QeukurqlMa9gnvBN74PZBMcTkjAr31+uCA2knewCxfrf?=
 =?us-ascii?Q?80q0yJX823eDraH3aIz3cQBdcNCGjvziqyEE1hDRPL3MKu816SpQMLl/f4M0?=
 =?us-ascii?Q?atvOp8i8xTLqytSeknaxeWU6c74/0WA+YvtglwNPR52cddDl7Svd7hFn8Fx6?=
 =?us-ascii?Q?qChaKyZmg93xDYklZp6JhPHy10XHIcaWIpYNsWTkUZuvzqLIwkdQBU+Eyzw3?=
 =?us-ascii?Q?kNqNRD+sJWFvT1ZQC6IF8X2KfiwUe63yzt+fR2BkwDyX1BFVR2B66kBj6aOn?=
 =?us-ascii?Q?HLKJJoQyPoLpVh87L65OKFKgek7EEoJgj5CZW7nDdviLCndcS4K1Yi46px4i?=
 =?us-ascii?Q?94B5LGcqdmHI0wmNCKqzobBV8WEvLh1zGVswQx3tYvVnNp71slZx1e1/nZe0?=
 =?us-ascii?Q?vVaBLNqAJktVJEyXDzdCYvoe4oZhnh3OQj+GPa9Pgb3rQCk1m4To4bvfCdWD?=
 =?us-ascii?Q?6tQ0IjWR+Z/Zp+1w6GdNdmB8dLSuqngTH/xP5aHBA4IQTYKYb5qu5T6Gf72k?=
 =?us-ascii?Q?1Pkpv2nc/KDcC3RkptwwxKa5CrawUXnJ4MI0T5d3Va67WUnypekREkB4FSyK?=
 =?us-ascii?Q?53GErZp7SehN8XBuJt64TPoPnVtc5Nf7aZxgMEbsGF1beUlkfyY6N/fwa26e?=
 =?us-ascii?Q?a1Cg62GCy1j7lP8fiZxgBvvyIuDah4RRwbLWKp3KPXtna0y0UWAKo8c+cZn5?=
 =?us-ascii?Q?PpIqei8V1Qj7bLJ3oMnkwM85aIpcWt3xL0ksYEZh0xrUx1JbKsaAYv9l7lAx?=
 =?us-ascii?Q?SB8/NpoUilGV7Ciz9GT3fEoil/6DtQeLmROUQknDypq84jczj0vnZjRJ+QrP?=
 =?us-ascii?Q?6a9kxWR7GFF/zOwx+1qK24q/9D0M94YTwb9jSqQ0Jt3UsDJEEwLigETRhFLF?=
 =?us-ascii?Q?NsTV141uFyQg3cgePPe5G6WmrPQ7nFWeJ606L7GtgBk7buytlIPzmCgnlnlC?=
 =?us-ascii?Q?5z/bzFi5kgmtx+8qpzdk9gYwxKrGdwdn9+0RSjvdI3XpFxcNM7KQv7cF5GJT?=
 =?us-ascii?Q?gdEV4rCnIiI2d+EPSPjYNX5rx+LocPg8SSWqHbEq0c/KOwTYj9G46ScF+yNo?=
 =?us-ascii?Q?ELQzi98N2ZAEMqxVekUX4kNdgb1EQj9rDeex1p4GN7lb/iqDPp9Otr6rHH5o?=
 =?us-ascii?Q?IaJ0etB/QH3exrFgiLn7UCHW9iYdaEK9hsetvDtu+kPqdmBqqDr3JKtfyauW?=
 =?us-ascii?Q?t/rkRoMjkbgsKZ31wEt2A/AK7gCcG3/RqKdTV1s226ZKsfEz6LO+5VOrom7A?=
 =?us-ascii?Q?GRfWskKSbYWsaDQEkQIVo6/zz/Kp/0Z7kL/55BJ20cnoIwopXzKfwd1Bvvfo?=
 =?us-ascii?Q?Kt6iwDNDsEhU+PFsPfWXFwatSVeWre/pHLDaDb9lkMJfHm68IDBLqbvvYFPZ?=
 =?us-ascii?Q?LbUuyhzSEEbVBQOYpywTdB4mC80n9tFW9vUvzAaZl4medJ5Q18bfflcxFxSb?=
 =?us-ascii?Q?R5KiRnts8GVGVJ6BGaIwkM/iPCs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4487A75BD510124F8B79A86278BEDEF3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78ba7d90-3b34-409b-b336-08d9eb38504b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2022 19:22:14.6376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yV17W9bAaxPJ4krdheve6E4aYwP5pJ3uOPdoL7rodvq8t2/mFnhXlS7KaaWE402RdhCr+npjIbifGie3aWVYLPDmEfvZf9aNT+iCnxXhGCo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2969
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 phishscore=0 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202080114
X-Proofpoint-ORIG-GUID: yEMaizEZw8v23SgyY648CGMa7FlnpSS5
X-Proofpoint-GUID: yEMaizEZw8v23SgyY648CGMa7FlnpSS5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:24 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Additionally, change the return type of the functions that always return
> TRUE from 'int' into 'void'. This patch prepares for removal of the
> drivers/scsi/scsi.h header file. That header file defines the 'TRUE' and
> 'FALSE' constants.
>=20
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/pcmcia/nsp_cs.c | 43 +++++++++++++++---------------------
> drivers/scsi/pcmcia/nsp_cs.h |  6 ++---
> 2 files changed, 21 insertions(+), 28 deletions(-)
>=20
> diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
> index 92c818a8a84a..a78a86511e94 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.c
> +++ b/drivers/scsi/pcmcia/nsp_cs.c
> @@ -243,7 +243,7 @@ static int nsp_queuecommand_lck(struct scsi_cmnd *SCp=
nt)
> 		SCpnt->SCp.buffers_residual =3D 0;
> 	}
>=20
> -	if (nsphw_start_selection(SCpnt) =3D=3D FALSE) {
> +	if (!nsphw_start_selection(SCpnt)) {
> 		nsp_dbg(NSP_DEBUG_QUEUECOMMAND, "selection fail");
> 		SCpnt->result   =3D DID_BUS_BUSY << 16;
> 		nsp_scsi_done(SCpnt);
> @@ -263,14 +263,14 @@ static DEF_SCSI_QCMD(nsp_queuecommand)
> /*
>  * setup PIO FIFO transfer mode and enable/disable to data out
>  */
> -static void nsp_setup_fifo(nsp_hw_data *data, int enabled)
> +static void nsp_setup_fifo(nsp_hw_data *data, bool enabled)
> {
> 	unsigned int  base =3D data->BaseAddress;
> 	unsigned char transfer_mode_reg;
>=20
> 	//nsp_dbg(NSP_DEBUG_DATA_IO, "enabled=3D%d", enabled);
>=20
> -	if (enabled !=3D FALSE) {
> +	if (enabled) {
> 		transfer_mode_reg =3D TRANSFER_GO | BRAIND;
> 	} else {
> 		transfer_mode_reg =3D 0;
> @@ -298,7 +298,7 @@ static void nsphw_init_sync(nsp_hw_data *data)
> /*
>  * Initialize Ninja hardware
>  */
> -static int nsphw_init(nsp_hw_data *data)
> +static void nsphw_init(nsp_hw_data *data)
> {
> 	unsigned int base     =3D data->BaseAddress;
>=20
> @@ -348,15 +348,13 @@ static int nsphw_init(nsp_hw_data *data)
> 					    SCSI_RESET_IRQ_EI	 );
> 	nsp_write(base,	      IRQCONTROL,   IRQCONTROL_ALLCLEAR);
>=20
> -	nsp_setup_fifo(data, FALSE);
> -
> -	return TRUE;
> +	nsp_setup_fifo(data, false);
> }
>=20
> /*
>  * Start selection phase
>  */
> -static int nsphw_start_selection(struct scsi_cmnd *SCpnt)
> +static bool nsphw_start_selection(struct scsi_cmnd *SCpnt)
> {
> 	unsigned int  host_id	 =3D SCpnt->device->host->this_id;
> 	unsigned int  base	 =3D SCpnt->device->host->io_port;
> @@ -370,7 +368,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SC=
pnt)
> 	phase =3D nsp_index_read(base, SCSIBUSMON);
> 	if(phase !=3D BUSMON_BUS_FREE) {
> 		//nsp_dbg(NSP_DEBUG_RESELECTION, "bus busy");
> -		return FALSE;
> +		return false;
> 	}
>=20
> 	/* start arbitration */
> @@ -390,7 +388,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SC=
pnt)
> 	if (!(arbit & ARBIT_WIN)) {
> 		//nsp_dbg(NSP_DEBUG_RESELECTION, "arbit fail");
> 		nsp_index_write(base, SETARBIT, ARBIT_FLAG_CLEAR);
> -		return FALSE;
> +		return false;
> 	}
>=20
> 	/* assert select line */
> @@ -409,7 +407,7 @@ static int nsphw_start_selection(struct scsi_cmnd *SC=
pnt)
> 	nsp_start_timer(SCpnt, 1000/51);
> 	data->SelectionTimeOut =3D 1;
>=20
> -	return TRUE;
> +	return true;
> }
>=20
> struct nsp_sync_table {
> @@ -479,7 +477,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
> 		sync->SyncRegister    =3D 0;
> 		sync->AckWidth	      =3D 0;
>=20
> -		return FALSE;
> +		return false;
> 	}
>=20
> 	sync->SyncRegister    =3D (sync_table->chip_period << SYNCREG_PERIOD_SHI=
FT) |
> @@ -488,7 +486,7 @@ static int nsp_analyze_sdtr(struct scsi_cmnd *SCpnt)
>=20
> 	nsp_dbg(NSP_DEBUG_SYNC, "sync_reg=3D0x%x, ack_width=3D0x%x", sync->SyncR=
egister, sync->AckWidth);
>=20
> -	return TRUE;
> +	return true;
> }
>=20
>=20
> @@ -635,7 +633,7 @@ static int nsp_dataphase_bypass(struct scsi_cmnd *SCp=
nt)
> 	nsp_dbg(NSP_DEBUG_DATA_IO, "use bypass quirk");
> 	SCpnt->SCp.phase =3D PH_DATA;
> 	nsp_pio_read(SCpnt);
> -	nsp_setup_fifo(data, FALSE);
> +	nsp_setup_fifo(data, false);
>=20
> 	return 0;
> }
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
> @@ -931,7 +927,7 @@ static int nsp_nexus(struct scsi_cmnd *SCpnt)
> 	}
>=20
> 	/* setup pdma fifo */
> -	nsp_setup_fifo(data, TRUE);
> +	nsp_setup_fifo(data, true);
>=20
> 	/* clear ack counter */
>  	data->FifoCount =3D 0;
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
> @@ -1215,7 +1210,7 @@ static irqreturn_t nspintr(int irq, void *dev_id)
> 		//*sync_neg =3D SYNC_NOT_YET;
>=20
> 		data->MsgLen =3D i =3D 0;
> -		data->MsgBuffer[i] =3D IDENTIFY(TRUE, lun); i++;
> +		data->MsgBuffer[i] =3D IDENTIFY(true, lun); i++;
>=20
> 		if (*sync_neg =3D=3D SYNC_NOT_YET) {
> 			data->Sync[target].SyncPeriod =3D 0;
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
> index 665bf8d0faf7..7d5d1a5b36e0 100644
> --- a/drivers/scsi/pcmcia/nsp_cs.h
> +++ b/drivers/scsi/pcmcia/nsp_cs.h
> @@ -304,8 +304,8 @@ static int nsp_eh_host_reset   (struct scsi_cmnd *SCp=
nt);
> static int nsp_bus_reset       (nsp_hw_data *data);
>=20
> /* */
> -static int  nsphw_init           (nsp_hw_data *data);
> -static int  nsphw_start_selection(struct scsi_cmnd *SCpnt);
> +static void nsphw_init           (nsp_hw_data *data);
> +static bool nsphw_start_selection(struct scsi_cmnd *SCpnt);
> static void nsp_start_timer      (struct scsi_cmnd *SCpnt, int time);
> static int  nsp_fifo_count       (struct scsi_cmnd *SCpnt);
> static void nsp_pio_read         (struct scsi_cmnd *SCpnt);
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

