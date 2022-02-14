Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54A5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 21:11:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiBNVLW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 16:11:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiBNVLU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 16:11:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C811BF537
        for <linux-scsi@vger.kernel.org>; Mon, 14 Feb 2022 13:11:12 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21EIKknl021606;
        Mon, 14 Feb 2022 20:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/AGOZUswsX/peD8abGLILeM0Py/P0XE0HZWwzdKUk8g=;
 b=hPgdEXhFpWhKMj2VrhH2TvM5GAdBIjyJmiHqKw9a+wIjJTBvKGmEJtaTRZv4JNgBOi7b
 Se5g/V2QDSUARKvHuUygJ3p7P78/hICN0ClstqmjJtcaPt+J5uwISYCcNgyUGg54OxFy
 U2jn1so1GhKfti+0Dc6gnSrF8dfxGGfajIf991+FbP4Tqgr+seZdO+Bvc9fooCIWSq9b
 f1Bk/lBFDUcepk4UOocFYKbu5BlnMbGfgml3lWtnmuIW/8Xmo+bmUbnOPNQOmgY0ukWU
 4iOfgPCPwncRdzwhAu/hy63PHZklBB5SRmkJKgv6R7PAgdGGorPAz21npPZJIMNQBQtl Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e63p25rk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:02:46 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21EK0a46021413;
        Mon, 14 Feb 2022 20:02:45 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by userp3030.oracle.com with ESMTP id 3e620wg5pq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Feb 2022 20:02:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fanmEBAN2qZrROrfvvrF2AIG+0G3L7eOtcFHKxISQl2frGfjBbZKFqhcxl0dkqwWlJzuPLEDNd4Q2gY2+BEzyguseoBXDT6anLzluVhci20skyEjU3gWaGRzCIKFxUjtirAiAW70+3pqBwkJnbRpriT8NSugDF59qlqn1c7oB9L1csQDBjTgGEEiMXsar5wFpO/+ysB11cDn4HyP2mjSVf7+RPX9QJiTXv4nxmrV1JWSZCq0mBcwC/UqwzZlwJ50zITvJn8ONoT0ptGbp2DEQ1OCPioikvg1u/UvDIJffMLZfJlXfKOaf6Q0Ocg5tP+cV7d7KJqA3i2UX3GH1AjPDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/AGOZUswsX/peD8abGLILeM0Py/P0XE0HZWwzdKUk8g=;
 b=P+rYmg6c3UOUC20M2lj9bUW3SMw8Jrk8/yy9IEMcsLTnAPKK61hOjtrAfPQRtZNUJHqV1Ga4aEfCwWi0hsRdrVGmoadSYFqTEqKTE3QY0MYVr6pxJ/sS0x8awxxIKz8hHSDOUtE0Gf6DEFnStvBGKyJhqT1H3pFQKdsqNnMCkVxKD8bRNACcNfAMnlxj8JqmgXGv74wzc5xZC/zJh/yn8B7edSzb/GbfV9fc8uGYFY0a44u+6WzQCdo1zVWOHyZPG5YEFMPBDhttVBJgDvSnMNu3V6jlh64gDsKun/25/U9cjm00oCvHa4SYMgtvNNj3wvhNqKkVv3JnTxOcK9E4+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/AGOZUswsX/peD8abGLILeM0Py/P0XE0HZWwzdKUk8g=;
 b=RwTEj+cZTzThLz7uT2jNRl22VsXdhIM2Mjn09qA7mf6+XrWcHM/OGKMCxxKwr97h0uj+pUNQl/YyAiC46XXtjF9aUgVyH0+Syqts9HDPzAsXmyNgvfDVLvubdhnNxpiy4pG05ZIYTovZo0PZl4qo2EFevxmGC72u5xRtqy/njk8=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CH2PR10MB4213.namprd10.prod.outlook.com (2603:10b6:610:7f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Mon, 14 Feb
 2022 20:02:43 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::98be:91a7:9773:9d39%4]) with mapi id 15.20.4975.017; Mon, 14 Feb 2022
 20:02:43 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 03/48] scsi: ips: Use true and false instead of TRUE
 and FALSE
Thread-Topic: [PATCH v3 03/48] scsi: ips: Use true and false instead of TRUE
 and FALSE
Thread-Index: AQHYH5dbenAlz6ZieEyi37f7gQJOZayTfHcA
Date:   Mon, 14 Feb 2022 20:02:43 +0000
Message-ID: <43421591-F7B9-4E00-A40C-20E69B62F41D@oracle.com>
References: <20220211223247.14369-1-bvanassche@acm.org>
 <20220211223247.14369-4-bvanassche@acm.org>
In-Reply-To: <20220211223247.14369-4-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 36b48fd2-baac-4f3c-0a99-08d9eff4f640
x-ms-traffictypediagnostic: CH2PR10MB4213:EE_
x-microsoft-antispam-prvs: <CH2PR10MB4213793C032DC3B5D75DA9D6E6339@CH2PR10MB4213.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EqhXm9S6Af4JscjIGQKBsxMg+sSEw38GPMov3IahZEJ4+JsWelETuJMlE0MWFZVUKzDyKcU15480WM7xukTb6FyCsoi3VsjPqWnvXoJlJ8Ya7lb8extYy1tfVq6l8+5prXXS944BMPqLDZ/8LrDFYszRmyd5edFecsUTScNpnTWDsn8Q7JrXSNZKCoFGhGxLZznOCh6QSqN8Vya6tQo2GJIdbgI4lu9pk8FoiKKKrEYe2ECvYTPgzorcIN4e2KJsg2xb5vfO19Yby6Km0gcJkq9bJIoaKbgFYrvTLiJuwBbJcHKBdycfjGYNTgpnnoP+3/1+z7IjdBIc6qpLFKTYI3UVTYmeyxFTViFStCNiR8YZjaqeR3oDMqqSwIfa8M09b4lZC9a3MAVxr5v97dNFx503IyCu066akqMGKbTjmofOKxzeReYXOjC3LRAdy06hNa6i+Zeiyoehwe0G4RYg7mpW/XbvdfBRSWNTjlBwFBeh/RGYyf3cttUE9o/OXUfsEPz1285hodr7Ahwx2Zm8LP3MnjwZ0gY2hLToda/mv9+DcTnDYYZLZlMW762uwK9b3Hh2IqRdfUpl8W9g3HN6UrPXx7GgjhfL4Tb7RuzntD0WnXqjUuL8pnKM6Z4A3eeGtxj899npRfJMENPu3ut5w3BU4oxAT+NkDhr18x0CvyoBTDal3K1qLrQiJNWvw8HHKtnVy0ODnMIv+p7kxpE904diJvU1A0i3zuR+HlLJ4Y9BBdTzaxKHzZaohn6Dkf3A
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(86362001)(36756003)(66556008)(33656002)(44832011)(5660300002)(2906002)(91956017)(76116006)(6486002)(64756008)(4326008)(8676002)(66476007)(66946007)(316002)(66446008)(508600001)(6916009)(54906003)(6506007)(6512007)(186003)(38070700005)(53546011)(2616005)(38100700002)(71200400001)(83380400001)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xa5CQXNqPeHtqPCf2v4w0vcAB3hOh5VW+CYomicd9MjOueoRNowR1vqGPu47?=
 =?us-ascii?Q?dBposQgfhKwOJF6JQSnpBgsE62BHdU03u6vjaZjNMtZ5RqSV4W+v9UBprIfn?=
 =?us-ascii?Q?yGKp+kQg5/NM/Drs7mfRn6IvYl5w7edZC2i/dWDNQuxcUknTB4yAvPPb6k3D?=
 =?us-ascii?Q?diEJyIeIaki37ZoFdOYk/aqpOanlTOJTO8CaMluvRD1NKfGUEwxJSvUbhzcf?=
 =?us-ascii?Q?F1RypQX+1o5WiS1oK9vi5zvfYgtZamx2vvMuk+E6IsQnOgptpZ+FlrW6m7ZC?=
 =?us-ascii?Q?Xa8QY8yrY7gbzBXVlIcvbxMCVHlFN77boxMsZU+FiLSXqAHs88PO6hhYQmSA?=
 =?us-ascii?Q?lRBNmYgTbksudssEs+DS0rJ62/9gf4Y67CtxvSzz6hewKYj/sEE8bi3ZJO6X?=
 =?us-ascii?Q?s+E3P2ANzpJGrl7NPptlChYJWDZKIrYGBppSiQWDEON6ZL7m57KQYIq0igP0?=
 =?us-ascii?Q?jElZOpSsYBf7BEAhgCswwlRdHB1OVwc3tByH8E96eXA61UCx2/RmT+tPeSLK?=
 =?us-ascii?Q?Fdflp0eDBdaAdrqQchczI3cvecj3jRHJ4OO978F1MKcAdoHIjVyyXdolCJJg?=
 =?us-ascii?Q?uEcfrjlCvn8iQLODRpv4igmzYsBF2a0onk2bBg8BAsTH9TaSBqwQN9XisqYz?=
 =?us-ascii?Q?DTvPN/+PqMXTKRW5w1+D6U9IUxw69c1KiEurWo3ac30T8R0yi5cZwxrRqE5o?=
 =?us-ascii?Q?zd6ZZE22NO0HUOiOMaZcN4UAoREmYyueVkP/ZNkLRJNduh72UWpu/7WtsWeX?=
 =?us-ascii?Q?IloGbvqod0RixiNerIoXwrPg0An+INhskFdZn4i14BNIYdy2VyM4nPzsfHWZ?=
 =?us-ascii?Q?n+XBSX5RXZbcfPCzdU8tD1dONqCGRfqTJ10D0ib/ac2WwM9XrS6rQZHX9d2V?=
 =?us-ascii?Q?YhEl2ePlXgAK0vkEd04T/rS/dtmSc82uj+gmtRID1aWYiDWqezRRhVEzf8Zv?=
 =?us-ascii?Q?eqPNHSVNXYPA3ywqS6A5+NUTgn/12t5jnPZ+oQrwHrxeLLyhlJUeUfXbD3ZT?=
 =?us-ascii?Q?OLQtPBY+UHCCCsbEka4eE7i1e4N7CqUWhvkuJYAmv3cruSpS4KISiYXc7s5g?=
 =?us-ascii?Q?UrY0ipjdSTuIqvxWtIaOfbBB2KSaHXZyhKhMlGF2RU4c3Sab/n+75MDL5W9K?=
 =?us-ascii?Q?z9IRWfIioVxjQUIxBhSaHkJatFHqezn6gizKTDKRMW1P5gcPpJuZivoT4lDK?=
 =?us-ascii?Q?4TuysgB37drDkg3D+bM0A5vLTu23vN5Km+QvB8c/0u9/TGQLCSgGnUxDiWED?=
 =?us-ascii?Q?8MXTkIzzrN+/lKfjuOxPY7Y2oxazSZ1ge4WMPHnOC9vtKlVnRCFS/dY928na?=
 =?us-ascii?Q?Nk9RD2rswQJTiHeMC1yhIkkF1zqYwjPj1nV124ymHK7Ra031nhC+mLkBhzrI?=
 =?us-ascii?Q?gsJbgM4dMOQGPiHxnZbp2eUDg+1iA97gLQdXbUTaODzFJ54nU/UtbI/8bAte?=
 =?us-ascii?Q?slLixO+DazNt3QzSM18VSzb6EInfgpSKsUb1SZy+ZS23pFgU6zHSWbdZWbmz?=
 =?us-ascii?Q?CVhN2IKmnWsaCAV+oEzfPWzTpS/uJyv3k8sxA8xZjWgpY3NNuS0iqKdpO+Iv?=
 =?us-ascii?Q?6FxDQ7h6U/lLE3Rp93nw8RRFQrQRVlx7pLN4BpYQ3ejTkvkqlW8sw1t10jYM?=
 =?us-ascii?Q?m08sUOEzP1np6O6a7XPre/jt1IJQtd0vqT+fRJ8jTZMH0opK3zSfFz5TR/ub?=
 =?us-ascii?Q?qMEPLaTDxufNRPObUhdrL5TNZEf0l7qGMcOU/on10mqaMMd8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CE0750A374348649A6428FA46381FB4C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36b48fd2-baac-4f3c-0a99-08d9eff4f640
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 20:02:43.0993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8viL+8Uc9hbLlSJjsRl8exwDIeyUZ7f8vvyj5z5VNcnfDiJuqdeCtvsrPWXPBzn6N2CqabRLCZEz4uzoSDw6Mz7w17hpTeEN9FYst3FtYFM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4213
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10258 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202140116
X-Proofpoint-ORIG-GUID: XFpWdLci4rxsE43jkDDi5LO5EZvD4IuP
X-Proofpoint-GUID: XFpWdLci4rxsE43jkDDi5LO5EZvD4IuP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 11, 2022, at 2:32 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> This patch prepares for removal of the drivers/scsi/scsi.h header file.
> That header file defines the 'TRUE' and 'FALSE' constants.
>=20
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/ips.c | 36 +++++++++++++++++-------------------
> 1 file changed, 17 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 59664e92ec8a..d22ba53d6028 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -945,7 +945,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
> 			scsi_done(scsi_cmd);
> 		}
>=20
> -		ha->active =3D FALSE;
> +		ha->active =3D false;
> 		return (FAILED);
> 	}
>=20
> @@ -974,7 +974,7 @@ static int __ips_eh_reset(struct scsi_cmnd *SC)
> 			scsi_done(scsi_cmd);
> 		}
>=20
> -		ha->active =3D FALSE;
> +		ha->active =3D false;
> 		return (FAILED);
> 	}
>=20
> @@ -1287,7 +1287,7 @@ ips_intr_copperhead(ips_ha_t * ha)
> 		return 0;
> 	}
>=20
> -	while (TRUE) {
> +	while (true) {
> 		sp =3D &ha->sp;
>=20
> 		intrstatus =3D (*ha->func.isintr) (ha);
> @@ -1351,7 +1351,7 @@ ips_intr_morpheus(ips_ha_t * ha)
> 		return 0;
> 	}
>=20
> -	while (TRUE) {
> +	while (true) {
> 		sp =3D &ha->sp;
>=20
> 		intrstatus =3D (*ha->func.isintr) (ha);
> @@ -3086,8 +3086,8 @@ ipsintr_blocking(ips_ha_t * ha, ips_scb_t * scb)
> 	METHOD_TRACE("ipsintr_blocking", 2);
>=20
> 	ips_freescb(ha, scb);
> -	if ((ha->waitflag =3D=3D TRUE) && (ha->cmd_in_progress =3D=3D scb->cdb[=
0])) {
> -		ha->waitflag =3D FALSE;
> +	if (ha->waitflag && ha->cmd_in_progress =3D=3D scb->cdb[0]) {
> +		ha->waitflag =3D false;
>=20
> 		return;
> 	}
> @@ -3387,7 +3387,7 @@ ips_send_wait(ips_ha_t * ha, ips_scb_t * scb, int t=
imeout, int intr)
> 	METHOD_TRACE("ips_send_wait", 1);
>=20
> 	if (intr !=3D IPS_FFDC) {	/* Won't be Waiting if this is a Time Stamp */
> -		ha->waitflag =3D TRUE;
> +		ha->waitflag =3D true;
> 		ha->cmd_in_progress =3D scb->cdb[0];
> 	}
> 	scb->callback =3D ipsintr_blocking;
> @@ -3464,10 +3464,8 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
> 		if (scb->bus > 0) {
> 			/* Controller commands can't be issued */
> 			/* to real devices -- fail them        */
> -			if ((ha->waitflag =3D=3D TRUE) &&
> -			    (ha->cmd_in_progress =3D=3D scb->cdb[0])) {
> -				ha->waitflag =3D FALSE;
> -			}
> +			if (ha->waitflag && ha->cmd_in_progress =3D=3D scb->cdb[0])
> +				ha->waitflag =3D false;
>=20
> 			return (1);
> 		}
> @@ -4615,7 +4613,7 @@ ips_poll_for_flush_complete(ips_ha_t * ha)
> {
> 	IPS_STATUS cstatus;
>=20
> -	while (TRUE) {
> +	while (true) {
> 	    cstatus.value =3D (*ha->func.statupd) (ha);
>=20
> 	    if (cstatus.value =3D=3D 0xffffffff)      /* If No Interrupt to proc=
ess */
> @@ -5538,26 +5536,26 @@ ips_wait(ips_ha_t * ha, int time, int intr)
> 	METHOD_TRACE("ips_wait", 1);
>=20
> 	ret =3D IPS_FAILURE;
> -	done =3D FALSE;
> +	done =3D false;
>=20
> 	time *=3D IPS_ONE_SEC;	/* convert seconds */
>=20
> 	while ((time > 0) && (!done)) {
> 		if (intr =3D=3D IPS_INTR_ON) {
> -			if (ha->waitflag =3D=3D FALSE) {
> +			if (!ha->waitflag) {
> 				ret =3D IPS_SUCCESS;
> -				done =3D TRUE;
> +				done =3D true;
> 				break;
> 			}
> 		} else if (intr =3D=3D IPS_INTR_IORL) {
> -			if (ha->waitflag =3D=3D FALSE) {
> +			if (!ha->waitflag) {
> 				/*
> 				 * controller generated an interrupt to
> 				 * acknowledge completion of the command
> 				 * and ips_intr() has serviced the interrupt.
> 				 */
> 				ret =3D IPS_SUCCESS;
> -				done =3D TRUE;
> +				done =3D true;
> 				break;
> 			}
>=20
> @@ -5592,7 +5590,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
> {
> 	METHOD_TRACE("ips_write_driver_status", 1);
>=20
> -	if (!ips_readwrite_page5(ha, FALSE, intr)) {
> +	if (!ips_readwrite_page5(ha, false, intr)) {
> 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
> 			   "unable to read NVRAM page 5.\n");
>=20
> @@ -5630,7 +5628,7 @@ ips_write_driver_status(ips_ha_t * ha, int intr)
> 	ha->nvram->versioning =3D 0;	/* Indicate the Driver Does Not Support Ver=
sioning */
>=20
> 	/* now update the page */
> -	if (!ips_readwrite_page5(ha, TRUE, intr)) {
> +	if (!ips_readwrite_page5(ha, true, intr)) {
> 		IPS_PRINTK(KERN_WARNING, ha->pcidev,
> 			   "unable to write NVRAM page 5.\n");
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

