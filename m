Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EF7C43219
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbiBISid (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:38:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239678AbiBISiT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:38:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CD1C050CDE
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:38:08 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HFruO017470;
        Wed, 9 Feb 2022 18:38:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=DRUMxDDY0hYQHEUGXxsF2gVakRfxvWJxtHJIJY5INcc=;
 b=GzaHcEqhgXfP9UsC+YLKMKa3kS5oFufDYgwpaI/DKfFnYcYpTFTQnCFc3W/ou3vX7CYj
 c+VnyltW7qMhb9qDK6sotP/Y18jdgT8Pwq2oQt20SC+UQ1hTTUZXZ9Kn67LBZMvAjOr+
 tt4cFkjegvWfbKHueiJCeYSeJa2vJrZPFbkQzksihwm7txo8CyYnN+2v3fs3zaB3Q68p
 2fWm/6dymNeSqt4oZYtrZndyWI0jxAxV0Flz/86LO3H8hvk4pU6FTI4T6JxzmnchCzHp
 aOV0/o+UJyhrI40aqyWUUdMF6U863E3U9PBE/TVTQzdZ4BhIqC3tIkAdw4am+Se9B6bc pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3h28nddf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:38:02 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219IPqlb116902;
        Wed, 9 Feb 2022 18:38:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3030.oracle.com with ESMTP id 3e1ec36cr6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:38:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmDV2tVL3ApKIn7pAR6Pd8o1Y5fJ32UHuT104MD6pLTnif0qx+Mk5fATiKeLWFhLUSEDNKacJqwMJEMph35aJMK13zvAIyak22Q5c/20Q4IXnhBjLVZ642ZGME9pBwRVAgeuR5/fwva3y5iXZ3suQvAnNV7G5YZZ+rjwkrg1QliaxncZdw3vSmfpx/l3PmH9cmdodxeAQ0jG8mxUg9PLgGL4+r6T9DI6yEy+Qa5NgqvjsfPSw+33lvkYTErIHOmudLHW4Vh3AoO8O+JI4b6e0zPBYSYTHkds3mHvZpMN+2cO9TyPKDyMnuxi54PSwAKPt8GygV6kD1mUqfcPyHlZeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DRUMxDDY0hYQHEUGXxsF2gVakRfxvWJxtHJIJY5INcc=;
 b=GGGH/K4fXlL5w7FYhb+s07NiVd3goPlY5wjgs9nUKgs6kACc8DtSUzztQJlnpYCw+u6j5nnw228BsYnRABbCY8y0V+h0JavlMPXvaIj7P5f6MQBu/geL22mqd3rDdRnxQSPL4aKFkOoftsy22W2AC9XoRO35sqEAlrNQAgAPRLBXmEzeSceGx1mFsr+0qv+WGUiBUCUgzVHeayey5Zc76rmhfucY8MEYvFB63zq2XBAtoA3+3W0VuLGg7L//Kw3OIlD2WkWodjURKOFqUl0JBrCVbyrYaQwzykFqWJUH/dHdNqOgpxfGU7MvgcFbkq6F+Nr55XxPLuh3LdyYY3A8lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DRUMxDDY0hYQHEUGXxsF2gVakRfxvWJxtHJIJY5INcc=;
 b=DU/W8aJf+PF/GWRaI02dlT58T4LYTja8IVbHSNpp8AfXswI6GhSKQ4B3RrA4AOcP3Stv3IVVJt3GsM93+G3wblmPTNf8SJg3tMWwq+F4vBLFJ6DhoP0BGIn1+jhZTu3Klx0YR54xhXViOK36OCmZDUni+IpI5jFHSDw+E8ERQG0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by DM6PR10MB3673.namprd10.prod.outlook.com (2603:10b6:5:17b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 9 Feb
 2022 18:37:59 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:37:59 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 26/44] mac53c94: Move the SCSI pointer to private
 command data
Thread-Topic: [PATCH v2 26/44] mac53c94: Move the SCSI pointer to private
 command data
Thread-Index: AQHYHREmzl3a4jXaT0KTq9jwxWtJ86yLji8A
Date:   Wed, 9 Feb 2022 18:37:59 +0000
Message-ID: <B144655A-823A-40AA-A7CC-38A1A2431183@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-27-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-27-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df406872-d118-4f6c-e49c-08d9ebfb4bd4
x-ms-traffictypediagnostic: DM6PR10MB3673:EE_
x-microsoft-antispam-prvs: <DM6PR10MB36739ECBBD3F222E10FFB1FEE62E9@DM6PR10MB3673.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LUUY4I9JO3pzGm/d8aRSV4ESpmaWtD83Pqkly+W24FP0gzfqElAWH+/ceeb6KA7Bic5QzEjitFLommqt8vJVTGMWkRQ2f3qeqgyuXbdNS72dL+T73Kn0xxvorgED7wb91YWLSPGQA4mstw3vLxILKAERrkjutyH+otx5J3kQ3Oyz7Kx+ubfLU5R+LIyaQbq8CRLVr0RbJZvUaTeXwXIJqNKu6d8qMKU+mqCZ3xW+Bbl/UF9P6F/6aWzx7CuNYhDJxQfUasnq4J0/E1KVfmeuC5GpoULOarEpDabfYk00B3HWDWZj+1MjcyQYooKUxZq3CpM20NyiGjx4qCXQV2sEL9eQg1dtHDTzSVIckiiM5RbxHU2+HyeXbQzpmzcBexcIK+EPHHq8PxrAR5zT/CTMWc8DSp4cTcEX1pfOAg8WvWZKdm8JHRvrdadlgqWK8nSPmqEcwoKfflWnErVIrSKqxrlje94zEcJlUOP9gqmAgG0ZB3S3qZm0mUGuOCNf9Ud1l/iNwgtbW4Ei1pMDzBcFTs7GoZTLJpfZB9MvuOYcWF2+kEeISWSAkCPHDWwDR+yxf/1+acxp1iuT81CKC3Xo6i7iUQygIQYK6d+E4FgtUFR/QSkuBjUOtEgFrUz2jmSkFPT8dwaFfIFsTU7nbg28D6FLaWjPEl+ZoOniuT/xnp8lny/my99j+4a+zxABzDPVHonpMhLC8IdzXNQzjeQRHLQ6Sw8h01drEqf3gSD8WjnOVwzJM56u8lxc3U6V6/UR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(2616005)(66946007)(53546011)(316002)(508600001)(44832011)(66556008)(6512007)(6506007)(2906002)(33656002)(186003)(4326008)(38070700005)(76116006)(6486002)(8676002)(83380400001)(36756003)(66446008)(54906003)(6916009)(66476007)(86362001)(64756008)(8936002)(5660300002)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EtEgwk4jSm8O8X8OBTmCZTb/P7UYGRlNcbEKiFsxACUixSEXdUOJTqaV2xUd?=
 =?us-ascii?Q?5yrRDfGhLYnGuXdAeAbixr9P0UdZ7o8MMIdv8gYpAvx+mwLVQzJ7ThXbXd4v?=
 =?us-ascii?Q?6N7Fu4GksUGhBmZWiovoiDDiRe8tq4YbAcohujpx8UeNSG3wLbC12d4gkxPI?=
 =?us-ascii?Q?Fi/u5nlee/tCz5WWl+ZFfY1AnXMdMuqjlFeKGmg39g2QFsOLzJ9HMte8ROOa?=
 =?us-ascii?Q?YD3dwOoVxS857Pi93SFumwOuD8oouoFl1n+6yMAkbVLBrM9tcSF0DtxIOQzK?=
 =?us-ascii?Q?keCqNyZHt+tUyTuVjlUEuBAWa6PV7hXF5DVqEXrS9feOd4y5Mf9R3th2Hk6t?=
 =?us-ascii?Q?ix+grJeqxgxLDp3t8f2wtHCwfJBaUYg+9KfKtgoEQzgjpNtQknfdUjvervFS?=
 =?us-ascii?Q?Z3pfrLYUiwU1w/bNzUvDOZbL6L6ZBPUnUl1VSlk7UwPbmJP1Xt8QAVkFIye9?=
 =?us-ascii?Q?CSnnquxC5fZjS02hoIjpGEjsY/Msc+nWDNd4hVXsFbPsmBn9AljqOxYUoxCM?=
 =?us-ascii?Q?MzYCqlR8C5EwKM9VwCgr86Is/yQSv+CiyDz55u2H+oJml/DECGf04Ku36DhC?=
 =?us-ascii?Q?ik4jIfGXanmOVqLQLLcr+1zHKjAP1zfwerZxPeYqXx9biqWbiG8sesZn28/d?=
 =?us-ascii?Q?UAKYfM/TMw01Tc541aiYwjGW4BlFWFDqWveuGH9crI8GAzzDZ1+w3ow/t3Mg?=
 =?us-ascii?Q?sNeZlA15dHJfRQvj7hrMUNsNLty0JQ22dv1EAbC4THKbUkTmeuDlTSYAAwba?=
 =?us-ascii?Q?e0saIF0O2dVk5wKpvNWpIrNQSI2U+jKZWGWHm3EChPp921oEEmUuDNmK6S6o?=
 =?us-ascii?Q?x+4tAePXJ4n5ljgbkMwmlJQPQIhoJ0dbO30XEgF+1+wXYaMU9JT/hhv35P7F?=
 =?us-ascii?Q?ECtcXnhdRlsbe0O7fzVu4PqIYgKYDQzJ6lFcz502QYodRmbEbq6ru0VRQmQy?=
 =?us-ascii?Q?5PHyK1pQ29iNkGgYdlMr6BaetCw43hDOAInfLJpZQweysyboU4UUAetVshVz?=
 =?us-ascii?Q?+42l10lFB/ZdUO6JjHFFyrEmsBIVFctPtOe0Bo3ugMJey5B0I/isVIYC8eFf?=
 =?us-ascii?Q?Bb3n5tZuhUUnktYc7LNoImKn06UTSJSH87r3vLEbsLw7vldD7/EjpvCKjf6R?=
 =?us-ascii?Q?sjRg1WlozQ3MwGehAqoRm3EXVXzqIRISkJtZWJaIvTKMXixxG5zyRWOwZbQ+?=
 =?us-ascii?Q?HGdNUBT6dOtiYik3cruA4pp9gOXF6EuikoRdboxfzcBmWXpvRa6EIVRWeKbC?=
 =?us-ascii?Q?S1FTIzxskZK4ExcisnfOJTAS+ni/cdEpgtbtyzmRMNxUHw2V/eEh1Zi5egbe?=
 =?us-ascii?Q?U/PrkL5qrqBmtDoDVEZiz18SADLY2Q+okFrYiayAul1KXTb40qPD1z3BnV6B?=
 =?us-ascii?Q?3/IlwllY+tAZKfGfyo+K90eHivEoW6xywX6tjncE/XKtZbq4hY+RQL68wza4?=
 =?us-ascii?Q?KKMG4kxQ/nNKw9VOLIlJeYrv8eB3nuaARo8KdYHJnK2PFO9WPvv0c5z/00nJ?=
 =?us-ascii?Q?fIkU1OF2TIqZw6OdPB23PNbnbn9wlZEbYyDndknt+gYobolidSGvEMn3v+Jo?=
 =?us-ascii?Q?4ksvdNZhHtyXveye+XnO4G1FwOIbb3mYvfsqdfB2UKefK5FLpDcAXCaF9KBq?=
 =?us-ascii?Q?anUPDfXL3E6AGTwXBKz4wTt+iBdS24tE+m8Lgccne6zD6u7udBC246QmQPSI?=
 =?us-ascii?Q?3SXMiv5v+KdE3SrnsAu+7+TuOSNi16rnhhrlNNXruuiECnWY?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1987D920D3212141B4D18942B9CC102E@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df406872-d118-4f6c-e49c-08d9ebfb4bd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:37:59.0416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7MKCey+cNL+Zc8qmrzW047rqt47lxJC8kiXAXj9/q2UhjOvufrmK2cOFh0ssEMGPvn7HTIC8YtQxVQ520PJJGEU8ESAg9AgkKPZ7r3HT/q4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3673
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10252 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-ORIG-GUID: ZUc630oJZqBP5IUYBf6KZAgQS_nmPQQr
X-Proofpoint-GUID: ZUc630oJZqBP5IUYBf6KZAgQS_nmPQQr
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
> drivers/scsi/mac53c94.c | 24 +++++++++++++-----------
> drivers/scsi/mac53c94.h | 11 +++++++++++
> 2 files changed, 24 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
> index afa08309de36..f3005b38931f 100644
> --- a/drivers/scsi/mac53c94.c
> +++ b/drivers/scsi/mac53c94.c
> @@ -193,7 +193,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
> 	struct fsc_state *state =3D (struct fsc_state *) dev_id;
> 	struct mac53c94_regs __iomem *regs =3D state->regs;
> 	struct dbdma_regs __iomem *dma =3D state->dma;
> -	struct scsi_cmnd *cmd =3D state->current_req;
> +	struct scsi_cmnd *const cmd =3D state->current_req;
> +	struct scsi_pointer *const scsi_pointer =3D mac53c94_scsi_pointer(cmd);
> 	int nb, stat, seq, intr;
> 	static int mac53c94_errors;
>=20
> @@ -263,10 +264,10 @@ static void mac53c94_interrupt(int irq, void *dev_i=
d)
> 		/* set DMA controller going if any data to transfer */
> 		if ((stat & (STAT_MSG|STAT_CD)) =3D=3D 0
> 		    && (scsi_sg_count(cmd) > 0 || scsi_bufflen(cmd))) {
> -			nb =3D cmd->SCp.this_residual;
> +			nb =3D scsi_pointer->this_residual;
> 			if (nb > 0xfff0)
> 				nb =3D 0xfff0;
> -			cmd->SCp.this_residual -=3D nb;
> +			scsi_pointer->this_residual -=3D nb;
> 			writeb(nb, &regs->count_lo);
> 			writeb(nb >> 8, &regs->count_mid);
> 			writeb(CMD_DMA_MODE + CMD_NOP, &regs->command);
> @@ -293,13 +294,13 @@ static void mac53c94_interrupt(int irq, void *dev_i=
d)
> 			cmd_done(state, DID_ERROR << 16);
> 			return;
> 		}
> -		if (cmd->SCp.this_residual !=3D 0
> +		if (scsi_pointer->this_residual !=3D 0
> 		    && (stat & (STAT_MSG|STAT_CD)) =3D=3D 0) {
> 			/* Set up the count regs to transfer more */
> -			nb =3D cmd->SCp.this_residual;
> +			nb =3D scsi_pointer->this_residual;
> 			if (nb > 0xfff0)
> 				nb =3D 0xfff0;
> -			cmd->SCp.this_residual -=3D nb;
> +			scsi_pointer->this_residual -=3D nb;
> 			writeb(nb, &regs->count_lo);
> 			writeb(nb >> 8, &regs->count_mid);
> 			writeb(CMD_DMA_MODE + CMD_NOP, &regs->command);
> @@ -321,8 +322,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
> 			cmd_done(state, DID_ERROR << 16);
> 			return;
> 		}
> -		cmd->SCp.Status =3D readb(&regs->fifo);
> -		cmd->SCp.Message =3D readb(&regs->fifo);
> +		scsi_pointer->Status =3D readb(&regs->fifo);
> +		scsi_pointer->Message =3D readb(&regs->fifo);
> 		writeb(CMD_ACCEPT_MSG, &regs->command);
> 		state->phase =3D busfreeing;
> 		break;
> @@ -330,8 +331,8 @@ static void mac53c94_interrupt(int irq, void *dev_id)
> 		if (intr !=3D INTR_DISCONNECT) {
> 			printk(KERN_DEBUG "got intr %x when expected disconnect\n", intr);
> 		}
> -		cmd_done(state, (DID_OK << 16) + (cmd->SCp.Message << 8)
> -			 + cmd->SCp.Status);
> +		cmd_done(state, (DID_OK << 16) + (scsi_pointer->Message << 8)
> +			 + scsi_pointer->Status);
> 		break;
> 	default:
> 		printk(KERN_DEBUG "don't know about phase %d\n", state->phase);
> @@ -389,7 +390,7 @@ static void set_dma_cmds(struct fsc_state *state, str=
uct scsi_cmnd *cmd)
> 	dma_cmd +=3D OUTPUT_LAST - OUTPUT_MORE;
> 	dcmds[-1].command =3D cpu_to_le16(dma_cmd);
> 	dcmds->command =3D cpu_to_le16(DBDMA_STOP);
> -	cmd->SCp.this_residual =3D total;
> +	mac53c94_scsi_pointer(cmd)->this_residual =3D total;
> }
>=20
> static struct scsi_host_template mac53c94_template =3D {
> @@ -401,6 +402,7 @@ static struct scsi_host_template mac53c94_template =
=3D {
> 	.this_id	=3D 7,
> 	.sg_tablesize	=3D SG_ALL,
> 	.max_segment_size =3D 65535,
> +	.cmd_size	=3D sizeof(struct mac53c94_cmd_priv),
> };
>=20
> static int mac53c94_probe(struct macio_dev *mdev, const struct of_device_=
id *match)
> diff --git a/drivers/scsi/mac53c94.h b/drivers/scsi/mac53c94.h
> index 5df6e81f78a8..37d7d30f42ef 100644
> --- a/drivers/scsi/mac53c94.h
> +++ b/drivers/scsi/mac53c94.h
> @@ -212,4 +212,15 @@ struct mac53c94_regs {
> #define CF4_TEST	0x02
> #define CF4_BBTE	0x01
>=20
> +struct mac53c94_cmd_priv {
> +	struct scsi_pointer scsi_pointer;
> +};
> +
> +static inline struct scsi_pointer *mac53c94_scsi_pointer(struct scsi_cmn=
d *cmd)
> +{
> +	struct mac53c94_cmd_priv *mcmd =3D scsi_cmd_priv(cmd);
> +
> +	return &mcmd->scsi_pointer;
> +}
> +
> #endif /* _MAC53C94_H */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

