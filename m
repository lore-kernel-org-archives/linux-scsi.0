Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85BD3C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 18:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbiCIS4f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 13:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236543AbiCIS4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 13:56:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E032F574BF
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 10:55:34 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229IfaEk028057;
        Wed, 9 Mar 2022 18:55:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=iYl7MAspHthK2JqjSSa9m3M4SBmaYI4rINmZfQDQngQ=;
 b=Kg3PIlfuLraz0pKwFQapDZuSffD6tmndqht0ORjLho9zlKRQ2Eg1Ly8NtPHUR7sGD/fY
 eq66yPwzCmZKbOupMWYmOnW/Y3xOqARKCIuooLj+kLqrMVgl5VrNyp9HaIlhE6i9jETn
 OTC1sI1YRY7a1Q6avqEQ1+KtKVAqyZqKktjdFqCN1650yD5ZxTIRgTdPxoJmk0b5/whu
 3wS/BvcJnlBvsY/dGR9c0xECn0NxFzqWquuXc7ectsHl109uxikL5Bjj5YcPoPlnSvO4
 CY2suVSvbaUItGcDQHiN9VSd2SvqQCv9HBHbEeUMOE5El1fX+3RFN3DezpKyI+kRz4Zu VA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxn2k7mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:55:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229IeO7r091535;
        Wed, 9 Mar 2022 18:55:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by userp3030.oracle.com with ESMTP id 3ekvyw39b6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 18:55:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNugovwZ/6dnJpMXF3Hz9tiWJ4+AXQaMu1HVYa36jNJotKbdrtousgnMjsLbSM5xtgrcEpyINAnJsjc3p5ivt3VZ5YRiD+MLElCofHWfNkYmN6SG4xDLPrpMpmpRSQcUiG5BdmWV+dtSMCimHoKwm43yzF6D+tJX4CvtlNTOF4tgAsVjX9ZoVZ+vEpEcw0spkTSzoWt5sHmwVIZuMmGCC/PMoUHiMLSwIv9jXGAlFlYQBnL8MuXSo+psLrxMXqzkDhdXQkxiDcw09pGizQ5+G0thORHfmcjSoJeZFcwx3+dxbbTBrdNeDqL4aEkssznuR9eIMJ14W1IBEdmenRFV4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iYl7MAspHthK2JqjSSa9m3M4SBmaYI4rINmZfQDQngQ=;
 b=MszqWcSCfUQHRxlz/qDiIkSBNlcyquTgItao9IizYuwzhJZCvNR29lvNWG+7gXHaItKA+9lE05eC0DGWX8q3Yvh/A/hhDowNH0e7yHVSx63DJ46Lc21PY17Iv3euuoLEugNzeJ+DXAz5p0ieELtHWLZjsum65klUB634T+Bh1Pt/y5EUcvSlVA5neBQHCcH7Dy7IRRq9DS3PxjFof2y3cCNm+WajBWuvSF0QqZ+f2yYkeNY87st2cb0KFjZZl6mmrR2oR/LKW8aT+XNfCZ4JUZ3LXANZkt5jluR77qkGVCExnEUFw2aV2UqH9UKtLea5JCCpSFS2U9sjlyQyAlZWLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iYl7MAspHthK2JqjSSa9m3M4SBmaYI4rINmZfQDQngQ=;
 b=CCtR8BVtmIVzxsAs25vgbn4NYWHceCPTpkOr9IhB9odoY820q18kTIX6mHxwhcTWNTSOyDZ1Ssi1yqWGjr0tSdOmYzw7R9pILvgoL/U2sjyxZYoggVGuIgPvRuLvLFoMy8lIr32OKL88sjM8kmtELpU+gNat9Z61IBA+fjorlqg=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CO6PR10MB5539.namprd10.prod.outlook.com (2603:10b6:303:136::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 18:55:29 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::69d0:6635:35d6:9be6%6]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 18:55:29 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 06/13] qla2xxx: fix n2n inconsistent plogi
Thread-Topic: [PATCH 06/13] qla2xxx: fix n2n inconsistent plogi
Thread-Index: AQHYMsV9lha/5I7b1kq4c7cuKLmqSay3aPEA
Date:   Wed, 9 Mar 2022 18:55:28 +0000
Message-ID: <242C0235-7254-49C9-ACF5-D26F0C4565EB@oracle.com>
References: <20220308082048.9774-1-njavali@marvell.com>
 <20220308082048.9774-7-njavali@marvell.com>
In-Reply-To: <20220308082048.9774-7-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.60.0.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e88d9a48-5683-4883-e4ac-08da01fe6130
x-ms-traffictypediagnostic: CO6PR10MB5539:EE_
x-microsoft-antispam-prvs: <CO6PR10MB5539737D13399637DBC46DA6E60A9@CO6PR10MB5539.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zaHOFTCsHzdetqLSM7KP9pQE0WEgVai+O4tFZaqH+mk+nebowmDwJYacyyK1DKYQKI0SBc0n0wDBVxhBPRx+ssZ+pdLrW1r2wfM/0D/QcSIAot1vRNr2NrvQH9BA08zmCY3J3OyPQgb4uuMoPsQCy0tONnYOrWIJ2Lq10tplgIgp7IU8v3bFCzJDURHTULCB+p6ccjWBwTH0RbXnrcqfe7evZf6ygX/APxbnYNScj6NBf7ESGYU9bW3hE9YcO31KnJaqNQFamiCrI4ouPnITi8xGdH9IcnTKjM7UirbIAw02QAwVlMJqSFHsLH8PvPUok5V1oMylC3uLC2uUnjWvsErH5KV15eoISmwE6SYSdgmVlcWBbLsYOczKvcnhTob6Cmm04M2v1fOFGHRpECBSxvfbsOc76KI4gbiWlFEcqiA2/xvhoiyVyCIDRMM3hL9F8m1NeduTJ7Nz+w35yX6aJo86JnYppScXPPokENO4ZK4kqxnbj+t8zFhoksI99m2VeHj0ejT3WPYUpewsPpMqITGxFbd+jF/ZtxCki5rtqeBWY30IoyeFrT1YArSc/UQ4OUa5BeybG9EX2Er+lMUTX7gCGdrCPGYpOw+a+9oFMjvj/7/XM8fozKiX+mZTLzh9vd7kJOcELrafFWx4ko7ZE1crkgMlHO3XPeh8cK4Bg0zacbvBggwXpbpjB7ItbHNWUql8c9jMSiw1UJQEquZySmLZsAvDEzEtFouqCap9pHAJ3jtJq6hAEgxAJ+UEoAlI
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(508600001)(66446008)(6506007)(86362001)(33656002)(8936002)(83380400001)(5660300002)(44832011)(6486002)(2906002)(6512007)(186003)(26005)(4326008)(76116006)(64756008)(66476007)(8676002)(91956017)(66556008)(38100700002)(2616005)(38070700005)(122000001)(71200400001)(316002)(6916009)(54906003)(36756003)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?viMOwnh7vmcLeMFQrDwLfyk5NdSEV3myWxEb75LdoS9MZI9IjfZIqRRYh7aD?=
 =?us-ascii?Q?XBwFolNVdkhROCD2ciekKxhtwy62d4Q5mZQwn1zUeybwzf5l4o67wbHT+BsK?=
 =?us-ascii?Q?mKLRwfxSn3aEGO8THU9WASW9nXxkZwy6npSCcvkhqB162I2l7oJ+uwIkCgLa?=
 =?us-ascii?Q?0hhmemi1oeM8pM2d/G3LmsDqfJkV3q1Zywf3LITX1TjQfNRnv9lSXOImN47O?=
 =?us-ascii?Q?b4ka2hX1cPLPioWRlwH/zhi8IaDxC6kKsl4v1R3BWMfgy4et2uqiSbbBUqig?=
 =?us-ascii?Q?LbeQ1yJdAvQShkGGEBZJ2DX6Cjf8rJVYkajNNnsThOAqQ/e9MI0M0rG4HQaD?=
 =?us-ascii?Q?7q+75VqNmtlmHVPpubpTGOAwOl2cRR13T3Airqyu/R4bbj7zAwiJCIOf7eh/?=
 =?us-ascii?Q?f0abtaWb/UvYiurfEEYvJ7HCe3qdJGoYLnPxUj8xr4fZZiGvPZqA51OUcDfi?=
 =?us-ascii?Q?qs1csMUgzkdSRHeV5yOXz4xC7QDbxJ9RWcWx3onpRK0AYhg46gBW5rZ9omr0?=
 =?us-ascii?Q?OSWB5x4sAa9ZADd4yTrtxKN/4a2JXS56FIsdYNsBJYUNOUuR/0iLGUAm2e8U?=
 =?us-ascii?Q?kYXZ9+B24Sl110UAgGFOB8jdWevwbhBQPa2ytVwCZH6B2gZrxAoY5tQlUS+M?=
 =?us-ascii?Q?MAY/1M+HSJrla4HeQ98wlOXZPxZrwwwfHdyH4BuYawVmwJkFjionH7tgh1p1?=
 =?us-ascii?Q?7P2XUDwg4APybQEjEmqH7MUxLFLZ4V+mumY/ah7Nvl7bRKE+IShVgqsuOlcs?=
 =?us-ascii?Q?mizHPQhW9i0EeEPmDw2jVjf9eg07rIOzmqJPzcRsVyjzFFwLhT3I3P8lp7M6?=
 =?us-ascii?Q?dTfd2o9Z0L7xo0RebtguLpCznek8f712Skc96r4pJcNwSr9d3RhpfVYMfxs/?=
 =?us-ascii?Q?0WzIeVrwVncOnOtkJqdOhsgZz1CIPPwZ148NV9+siaX5ULN/yzNlOgL7zW6S?=
 =?us-ascii?Q?GpFN+RVXVpBz041sFIv/uKLhVYwmURQ4DLsSInWxar125tT1mH4xwFRs0m9s?=
 =?us-ascii?Q?70BIN5pS9DaTzOrOW29P8hvhfJh0RcXdRaW+35ZenZe4m3/UCpsfa+ujqMoA?=
 =?us-ascii?Q?GchSXC8222Rt90nYv4tbATWcetvQICbyh8P412MEOXQtxWNMro8WRDxWzKrF?=
 =?us-ascii?Q?ZEdAmZwaKa3vKJZYSNuTtxnlGnxsUwZ/Atbj8vNeV90bF9bDRs23HyvA58OA?=
 =?us-ascii?Q?oZ7YlrdhLbvTKQu02L4XPwUizNFTGulPam7BnJFnOJpoQqjhAZlJkzAD1j/R?=
 =?us-ascii?Q?rs1VFwp3EwEHPba2C6K7tRohNwaH1wd/PltndV+ilUrXz/6hWxYLebdIF4m8?=
 =?us-ascii?Q?MbjK7WC2J3NLRQesSuMv26QBBj5nGlHe2gAFjEA9mfoYoOsveyqVqeB+R2jo?=
 =?us-ascii?Q?f8r4x9xtLo7yvj0R8XREGIzz0h8NCdaECKhWs08jC/IjAM9hZJ9zS9LjUfch?=
 =?us-ascii?Q?Gra9aYjDkM42pfov0q5cZ6xrtGskDsTrw4FgR4VSqFia9w4JAJpQMmX8muEV?=
 =?us-ascii?Q?8xQvVSl4FGb5u29WP76QlHdmxXQJJzC+w4PaHh8T5hxMRPP+14D8kZ6+JbIO?=
 =?us-ascii?Q?Cg7VvQkd95K6x9gahWh7U9uH01SLuqtGwDmBjBPKDg8g+hkFsbyY01r3Vpi6?=
 =?us-ascii?Q?yfcz7aye7Hq/Hd7sgaLuNqkHXknf2bhTsjs6Bt4l2Q+wCfRuaC+V6xaJTQdT?=
 =?us-ascii?Q?mdRt+mkFA0IqqS+9reih9NKGPVo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3330916D121E5A449F0B75B49D30F36C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e88d9a48-5683-4883-e4ac-08da01fe6130
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 18:55:28.9480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TYYukFsru9BS5afz3/oeVE4+OOApvDZHXgl3xlwz+BToyRM3yBoDkliJRM8Mv41ZUIqFK3sBo3/b6d628NrzF6E2HNO6bbg8HyeCUTmcpI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5539
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090102
X-Proofpoint-ORIG-GUID: CLViKmAtLIrCSsms1DpBvC3wdEaMDotC
X-Proofpoint-GUID: CLViKmAtLIrCSsms1DpBvC3wdEaMDotC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Mar 8, 2022, at 12:20 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> For N2N topology, ELS Passthrough is used to send PLOGI.
> On failure of ELS pass through PLOGI, driver flipped over
> to using LLIOCB PLOGI for N2N. This is not consistent.
> This patch would delete the session to restart the
> connection, where ELS pass through PLOGI would be used consistently.
>=20
> Cc: stable@vger.kernel.org
> Fixes: c76ae845ea83 ("scsi: qla2xxx: Add error handling for PLOGI ELS pas=
sthrough")
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_iocb.c | 8 +++-----
> 1 file changed, 3 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 5e3ee1f7b43c..e0fe9ddb4bd2 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2958,6 +2958,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
> 					set_bit(ISP_ABORT_NEEDED,
> 					    &vha->dpc_flags);
> 					qla2xxx_wake_dpc(vha);
> +					break;
> 				}
> 				fallthrough;
> 			default:
> @@ -2967,9 +2968,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
> 				    fw_status[0], fw_status[1], fw_status[2]);
>=20
> 				fcport->flags &=3D ~FCF_ASYNC_SENT;
> -				qla2x00_set_fcport_disc_state(fcport,
> -				    DSC_LOGIN_FAILED);
> -				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> +				qlt_schedule_sess_for_deletion(fcport);
> 				break;
> 			}
> 			break;
> @@ -2981,8 +2980,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
> 			    fw_status[0], fw_status[1], fw_status[2]);
>=20
> 			sp->fcport->flags &=3D ~FCF_ASYNC_SENT;
> -			qla2x00_set_fcport_disc_state(fcport, DSC_LOGIN_FAILED);
> -			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
> +			qlt_schedule_sess_for_deletion(fcport);
> 			break;
> 		}
>=20
> --=20
> 2.19.0.rc0
>=20

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

