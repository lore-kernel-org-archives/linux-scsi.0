Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4B0C43217
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 18:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241151AbiBISwE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Feb 2022 13:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241999AbiBISvq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2022 13:51:46 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7114BC001F43
        for <linux-scsi@vger.kernel.org>; Wed,  9 Feb 2022 10:48:47 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219HBlJ3008856;
        Wed, 9 Feb 2022 18:48:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=F0xa/7uy+4aqqfp6G988VaT4t6QWr490G7+EH7zrQKU=;
 b=S//hC1a/TB/Ijwza8QhZ8CzIGf2lZI8dcCs/tCexDEhZdZD8L3WW4gekTwFm0rYbQB5v
 iFRoKNzbaX+cxe1J4JUVZ4YUZKqYHyWwHsi9x0ssALL4hq1WNvRhV9c3fxEy5UCLvADk
 A1KBUlF0522g1K3M2dDFwMeDxwhv3deK9i1U9i21J8RXA81f2AGQxSxBIc6nlxta4q/D
 MlCCMj/0PrheReHDqSDnmxrr9G86IIWGu40JCkKGt2bM2z8BCDA9YNEMPY1cQxC5x0yz
 qXZMnwZXdusLgzo/Tp5QXgVMup3Gzg2erV5BtuwygfznTcnz8MwkGnOP2o83pfHSI8s5 cw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgnnbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:48:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 219Ii1NG184695;
        Wed, 9 Feb 2022 18:48:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3030.oracle.com with ESMTP id 3e1ec371s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Feb 2022 18:48:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNoGzwceJgxI69uLMrvmB5SkPGM4ZBNi/X2Sjv3rnOFKQR9aHaht238Uf1W50GJ9lOe8ZkniYJyp4pSCKFVHfayEmhnHXTxe+9/Nq+CyimljC/FUxdFj/bVZi1AdhE5bzGKRwEhODNEjdDXcP1xfkcSNkjLHl6m2gFmNJX/9MkqEWeNsauH6Fpj7h/ZVroEGvZKHES9Hg2EbbgeyhJETPYs5llOOXgLKO/nz4ue6WwxGJE8Cr5j0Pz/lOvh9uDS2goM1MIpBRuGF5NT+2cEAokJ8FuZ7pSILsVArIcL7lbzZ1abeLR54TAZb+L6WLc3cTgrcUBCbJAN+D6R6dvvmHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0xa/7uy+4aqqfp6G988VaT4t6QWr490G7+EH7zrQKU=;
 b=QHR6weyHW/8YWjSr+3gj70+LB0UnDRco9U9Q6RUr8mKaIl/EeYH58m206BkFh51F8nfabS+XVFI3m93CDut1Msc3gTKNpJLv07IQ5sn4wdxy/NcV5iT22mZoa5L2Gndhtw85Fu6clS7eGH7J8otYMWxgeA73nURPzhmPzT3AlS+kN41udj8f7wpS/G9m0q2lTIDWbIPhDifkTmUJLu3USL4ahW3sXSZAKMS4n0cUFn3njh+76fIZB1T8TYw7RVywCEZMGeeyH3AKRkwCcTUzGaVzJrbWZVg3PtM82Tmt6hOUbgPFO1M+TlVRatWCJd9DbtxuqWdAAo6C9VbpPI5Xeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F0xa/7uy+4aqqfp6G988VaT4t6QWr490G7+EH7zrQKU=;
 b=dnsXHA3VU2+WU1fP5bkvQ7CYD0EM/rUxjuGNJ+t3MhXI/1+juE6/ePYpPEupjo+Bugw90hyAXBuOqB24osjeBskxkjBix7LivIK4KJlt5xp1ofDP7eM1crW1uYGbKaLaWgBh49sQkP0w7i1loUtep8hRxfug3dSLnrsmqJFcxZA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN8PR10MB3363.namprd10.prod.outlook.com (2603:10b6:408:c7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Wed, 9 Feb
 2022 18:48:35 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::755b:8fbf:706a:858%4]) with mapi id 15.20.4951.019; Wed, 9 Feb 2022
 18:48:35 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GOTO Masanori <gotom@debian.or.jp>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 32/44] nsp32: Stop using the SCSI pointer
Thread-Topic: [PATCH v2 32/44] nsp32: Stop using the SCSI pointer
Thread-Index: AQHYHRE9ceM0jMVzz0u0b326PElx/ayLkSUA
Date:   Wed, 9 Feb 2022 18:48:35 +0000
Message-ID: <DE31F02B-BDBC-46F0-A104-E868F01DDFEB@oracle.com>
References: <20220208172514.3481-1-bvanassche@acm.org>
 <20220208172514.3481-33-bvanassche@acm.org>
In-Reply-To: <20220208172514.3481-33-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb711e39-4e0c-4073-510e-08d9ebfcc71d
x-ms-traffictypediagnostic: BN8PR10MB3363:EE_
x-microsoft-antispam-prvs: <BN8PR10MB336350FE50B65F8726762C87E62E9@BN8PR10MB3363.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JwcUMWFG0cNkHjZGaaCNuXuHyGAifSc6Ridx0edkccAoIuJKjwwXraPWHFT4vc1OaBQkMlKqTECXHQU140PT02olLGRcffaRAG+MWMu8E8wyNf1NA8BjqoW/1hM1lozlXSRJuYSZoa3om4e5qQJVmoevGkg9VqfFlXm/J5/1Z//s6781wnUIbb6wficUh6vX2eRsYea3ntoZOYJ4S1VfSAQUZsjT4+HSdXDu3rORudK5jaYCYrQcthOUbcy0qUWfGteqQ4/9EKnClxcSlr5c7HeBaVVOwW2v5dxTKy2pbD1/zXlVJo7OkxAmd2bgdiTzrOkwjTmpoE1JvWFRZByGJSeh7ZtE37u1tly1ifMS9CpSY3RfX5svwdkQfvpeYOZUR7U8mTVCUlptOOY+LUxOmAlftmHLGqaJ36MonvtikZ49p3wUTqal/D/mjsROt5J7ZUHpNXxuJCinpdxFYaANbaaeNSYzgDLvmfRMPvYfJlOiZ2o0Yfl2ilAU1mY1R6pzjfWysk6NxMHVjj55BhvnbpPVM2AjJhwe2ISi8Mzke8teUo97Zt3L1HrRDAvaJ/cnsaAh8MCfYYGbPNgKeiIwswOvx+0to+yZ4495wuhJXc7ODBnc3GeeuRtqsOxmznV1P4FJLwsvmAvGnQoW49UpeqiehX9bS+7MGbvyoDvliS3UK0lwMescTDhYUaT8paSPfeuW7maKZXI/WkE8BBVnDfRSGkIoLwIIo2IHiqp32yoEbQji+xMv8RZwoz61CNDv
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(86362001)(6512007)(36756003)(316002)(6916009)(83380400001)(54906003)(71200400001)(2906002)(44832011)(6506007)(66946007)(66446008)(64756008)(8676002)(4326008)(53546011)(8936002)(66556008)(66476007)(6486002)(122000001)(76116006)(186003)(508600001)(5660300002)(33656002)(38100700002)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sylmHr3Mu2+9bpNRk88u6LrWB2kdVFydzRHv3mUvXpxcOe95D6cqRFZcYv2E?=
 =?us-ascii?Q?Le1YXQAGH3UwW9NkyWOEJodOI4C7UWoZtqCg4TH44YH5tdGtgGrHroS9z3Su?=
 =?us-ascii?Q?BXI37db115UHFN8TyobcavPicBzjuT0NpfGPyy2b1rYdJBeGCowLCIJkJXAP?=
 =?us-ascii?Q?LIiapx4fNnzKa0Y15f+Fw3KO6JH7uQDZVHe1GglHOZnKaoEFv/UwT5FlJgd1?=
 =?us-ascii?Q?YIxqoKGVUCWA9XKBng+k2izJa56ZKwYGoI5CHzyDC2NAyift0PpgW5RVGcir?=
 =?us-ascii?Q?kOpxjLHSwVeRnA4ld2wmU57kpNBYXE7uTpvLk3OOflC+SdDe8eNGisTTCzpD?=
 =?us-ascii?Q?2uuNie4Jdz3wY6l5B8DXP8ItnsY2IDF99covxJkXbCo2iFW1qcf9HTeCSAVc?=
 =?us-ascii?Q?jKOrk0L0rfgrUL+zDss0PcddYcBkdKCTjjZPZ2CKDpxFHaSxSpFxKLa6Lvca?=
 =?us-ascii?Q?WsjmlZY0rve6h3txjf6O/a2V+NMxTAHSu5zbAPCz7rWQGT3arHLiuBoqdZES?=
 =?us-ascii?Q?ELS4IOn2Ty/4FS1OCgKxd2E+m7axNqFelYCKlBykyAX8GO8aAMQq+AmLs0ch?=
 =?us-ascii?Q?yBMPbvqG0UzATqRH5mvo9uWnT/TvexXoMM+67VduV6BYMrEtPuAsymlOBYdC?=
 =?us-ascii?Q?rGko28IaOTBi7vkXBVdH2nv4fuq0RmZfwUzWjRt4wO+WKRrBviMEMExZKnNg?=
 =?us-ascii?Q?JId+Ww3MNEBBwcb1Ui/Ea4Ojtr+RuuyXe/FUWtq9J1q+JWDUgRZVn9rUWJzK?=
 =?us-ascii?Q?+o2W/10A92UOQVj5nSPKnD7FSGmSar09Y7gQzpl2DEwkBNxpDY3xitjT0QeJ?=
 =?us-ascii?Q?Uqw18BtpV5bROXM5j/uGmrhz5MqSqr09HGq1JTGiO0e0NN/j2rSxygcrdDDn?=
 =?us-ascii?Q?2pGt3H90oaDgNnFPFaAsuydR/QQufV7JBTYRzAzd0S+xtqyhE4XI63l7/R/4?=
 =?us-ascii?Q?MF6+qUqT56no4DcEg7jj/a/SKIEZnLD3rg+dQwPCz8U2YRCvUGdleVTGB2OU?=
 =?us-ascii?Q?xPigVSceT5GO9BIwFKkKUDM877qArb3qo2bNwTzljbINu+XiK0paD0gpHE+k?=
 =?us-ascii?Q?D/F/tJcSkinaobmeKEvN6l2xFVSshlRk/SDVTuTWPgh6iGwBbaUmVVNyHDtN?=
 =?us-ascii?Q?dw+0J4+LZxy7Eh6GX7oyv/+gOrWd3xx9CkSBo9KWfOF/UQNL3CRTHmrwFzfh?=
 =?us-ascii?Q?+0wPngToBjQglKz4d6zflA+ybTsmY+8/fsMFuIKb9F5A+yEkMbPe5RwH2700?=
 =?us-ascii?Q?LZUQv/EXK/CMXYeK+fD6TBsmTuRpuYjfXA4PZUrKswJTSSd3xW18L4/nEsTB?=
 =?us-ascii?Q?klHTqO4ZOGFDFnkgbWrS0nOLU7F5kC16JEqO/3M+xTqhRAdkCYa2q7vxdNtd?=
 =?us-ascii?Q?KeV3tXXcj+oleurIPrsCZzAcMqoj+yfkp9hL4DP+J49CF60OuUPczn1/bAAh?=
 =?us-ascii?Q?QLJq3Z5A9kIRb5UgkjTy6jaeyw9K6RHl378gL6sqb8fUU+yehUCPn/LhxKov?=
 =?us-ascii?Q?c7XoOqrjU3YI9EINT9M/Rw8RcN+S66CS3zt6f5OOObQwigJX2EBswPPgy55h?=
 =?us-ascii?Q?AOXW/u58PaZj3hyqfuheJBRoKB1rn6Aygeb/C2kcuMuHE1UevpjwhYSgsKF9?=
 =?us-ascii?Q?NDrFBbjo7fdrVLY6j2S0s6o5/4yNVODjvnrzh8hYWnTORuon+PLjYDbv1mBJ?=
 =?us-ascii?Q?zsg3twW94T4fDQgCvHhiGiR4JJOt908HHakLPxinQLJIEJyk?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2987A5173A82AA4A9117384B605E0546@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb711e39-4e0c-4073-510e-08d9ebfcc71d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2022 18:48:35.3259
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /PWhbHODB9ZeVNdPIo4HNud8K5AcEyVP9pexNQTufrHMCXFyFBywkIvM19BHblAtk2nvfU7l8xeqp5SyiN7Z63Zj5eGFu5JLOrXEIGmBT1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3363
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202090098
X-Proofpoint-GUID: VfFxdUMfnzSBlRGLI-yWolZ2f7uVWa4a
X-Proofpoint-ORIG-GUID: VfFxdUMfnzSBlRGLI-yWolZ2f7uVWa4a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Feb 8, 2022, at 9:25 AM, Bart Van Assche <bvanassche@acm.org> wrote:
>=20
> Move the SCSI status field to private data. Stop setting the .ptr,
> .this_residual, .buffer and .buffer_residual SCSI pointer members
> since no code in this driver reads these members.
>=20
> This patch prepares for removal of the SCSI pointer from struct scsi_cmnd=
.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
> drivers/scsi/nsp32.c | 20 +++++++-------------
> drivers/scsi/nsp32.h |  9 +++++++++
> 2 files changed, 16 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index bd3ee3bf08ee..75bb0028ed74 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -273,6 +273,7 @@ static struct scsi_host_template nsp32_template =3D {
> 	.eh_abort_handler		=3D nsp32_eh_abort,
> 	.eh_host_reset_handler		=3D nsp32_eh_host_reset,
> /*	.highmem_io			=3D 1, */
> +	.cmd_size			=3D sizeof(struct nsp32_cmd_priv),
> };
>=20
> #include "nsp32_io.h"
> @@ -946,14 +947,9 @@ static int nsp32_queuecommand_lck(struct scsi_cmnd *=
SCpnt)
> 	show_command(SCpnt);
>=20
> 	data->CurrentSC      =3D SCpnt;
> -	SCpnt->SCp.Status    =3D SAM_STAT_CHECK_CONDITION;
> +	nsp32_priv(SCpnt)->status =3D SAM_STAT_CHECK_CONDITION;
> 	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
>=20
> -	SCpnt->SCp.ptr		    =3D (char *)scsi_sglist(SCpnt);
> -	SCpnt->SCp.this_residual    =3D scsi_bufflen(SCpnt);
> -	SCpnt->SCp.buffer	    =3D NULL;
> -	SCpnt->SCp.buffers_residual =3D 0;
> -
> 	/* initialize data */
> 	data->msgout_len	=3D 0;
> 	data->msgin_len		=3D 0;
> @@ -1376,7 +1372,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_=
id)
> 		case BUSPHASE_STATUS:
> 			nsp32_dbg(NSP32_DEBUG_INTR, "fifo/status");
>=20
> -			SCpnt->SCp.Status =3D nsp32_read1(base, SCSI_CSB_IN);
> +			nsp32_priv(SCpnt)->status =3D nsp32_read1(base, SCSI_CSB_IN);
>=20
> 			break;
> 		default:
> @@ -1687,18 +1683,18 @@ static int nsp32_busfree_occur(struct scsi_cmnd *=
SCpnt, unsigned short execph)
> 		/* MsgIn 00: Command Complete */
> 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "command complete");
>=20
> -		SCpnt->SCp.Status  =3D nsp32_read1(base, SCSI_CSB_IN);
> +		nsp32_priv(SCpnt)->status  =3D nsp32_read1(base, SCSI_CSB_IN);
> 		nsp32_dbg(NSP32_DEBUG_BUSFREE,
> 			  "normal end stat=3D0x%x resid=3D0x%x\n",
> -			  SCpnt->SCp.Status, scsi_get_resid(SCpnt));
> +			  nsp32_priv(SCpnt)->status, scsi_get_resid(SCpnt));
> 		SCpnt->result =3D (DID_OK << 16) |
> -			(SCpnt->SCp.Status << 0);
> +			(nsp32_priv(SCpnt)->status << 0);
> 		nsp32_scsi_done(SCpnt);
> 		/* All operation is done */
> 		return TRUE;
> 	} else if (execph & MSGIN_04_VALID) {
> 		/* MsgIn 04: Disconnect */
> -		SCpnt->SCp.Status  =3D nsp32_read1(base, SCSI_CSB_IN);
> +		nsp32_priv(SCpnt)->status =3D nsp32_read1(base, SCSI_CSB_IN);
>=20
> 		nsp32_dbg(NSP32_DEBUG_BUSFREE, "disconnect");
> 		return TRUE;
> @@ -1706,8 +1702,6 @@ static int nsp32_busfree_occur(struct scsi_cmnd *SC=
pnt, unsigned short execph)
> 		/* Unexpected bus free */
> 		nsp32_msg(KERN_WARNING, "unexpected bus free occurred");
>=20
> -		/* DID_ERROR? */
> -		//SCpnt->result   =3D (DID_OK << 16) | (SCpnt->SCp.Status << 0);
> 		SCpnt->result =3D DID_ERROR << 16;
> 		nsp32_scsi_done(SCpnt);
> 		return TRUE;
> diff --git a/drivers/scsi/nsp32.h b/drivers/scsi/nsp32.h
> index ab0726c070f7..924889f8bd37 100644
> --- a/drivers/scsi/nsp32.h
> +++ b/drivers/scsi/nsp32.h
> @@ -534,6 +534,15 @@ typedef struct _nsp32_sync_table {
>       ---PERIOD-- ---OFFSET--   */
> #define TO_SYNCREG(period, offset) (((period) & 0x0f) << 4 | ((offset) & =
0x0f))
>=20
> +struct nsp32_cmd_priv {
> +	enum sam_status status;
> +};
> +
> +static inline struct nsp32_cmd_priv *nsp32_priv(struct scsi_cmnd *cmd)
> +{
> +	return scsi_cmd_priv(cmd);
> +}
> +
> typedef struct _nsp32_target {
> 	unsigned char	syncreg;	/* value for SYNCREG   */
> 	unsigned char	ackwidth;	/* value for ACKWIDTH  */

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

