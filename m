Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CACAC77B61
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 15:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbjEAPGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 11:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjEAPG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 11:06:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5251100
        for <linux-scsi@vger.kernel.org>; Mon,  1 May 2023 08:06:27 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EItnQ012491;
        Mon, 1 May 2023 15:06:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=wvwbATWVqWon6bbRC3rGq9bX6iFKtnHD5pYLwQvjzaE=;
 b=p1YzTJ9wmmv7Yw6QuGSny4u71oXSsVO+WVcJ1mXZuFAvvtBHxFpJaA268dlSEk9dzRB4
 o+rt/5xzFHs3mgQtHSuX8OjuLjnU3Cy76e0f3a4vvZsflQ/OQ2fUDGOdf8ARnvAkznZm
 xGrIlKprg4tKKQbvSenX0m7705pEzEe+bzSUAu1/2OH6k1FAE0gaKtrwMjH2qWoOGiMH
 p08FTLgrwcNpssg/zow7L0DsKxJQJ8SnihDyK1wUbo4JFxWjF8yv3+YnjYCb4+VCSk9m
 l+R4lvIdQvurkx7wDmXCI4YMum9Z8v4Nyg6rCL2D1PKNfB+fHYzevHUGhd84DG+0Vn7x mQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8tuu2hj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:06:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341EdPUk002423;
        Mon, 1 May 2023 15:06:24 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spat7p1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:06:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KdLPQAEHMWjDFYBjNbP9E8UO9oCewJTY3DGAiWbw9nfxTWpr5iCHgTLRi7fC6gnxvUZ4RPi0oaxVCWA5nDI6F9tpx1fBxNS1fl/Rd/CpjbLLEYo9OmONOYzI+5joiqMtBRNmJWil4eTlGpUePWReCU+pXFe5DHpEtmMXSO75SUXtplCfHwQmwrwjbzDtAVvKeaAg1xdRI/FW7QZHvC3I7mIn6cTEEE9nK3mTvFK9uDRyp0/lXxXcsBQhgoOhGTlDd0II/14pVfPc5XKvph7aBSyft6YMrqwcQy1Lo+EEq221Jh0QJyD+nyMHRXeZQuwjeQdO37vKmmxPhCFQsLVLAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvwbATWVqWon6bbRC3rGq9bX6iFKtnHD5pYLwQvjzaE=;
 b=Y0B5fuXrxyKeCElWYp968m3EJWZ2vCISyZqqMDfWuTWq5DRzpgdJG3AbcKat4zbokE0ADq9GXUdizlY4hZ1p7Vq7iV71riawVywjJS3Wn945MDbsHd9buVi++qnkUlMhX6tqiMUbrvYGuML/1jtcO3ZPPTNIJ2Sd1iMWbCRNhG9pd3TpBKw7if50pXtmDspgOdT6CmkzZ9Bvuu0Db34s2dmD6fFrucobhEL4HnAelzeTfTBNmwQcG487oGD4Bx4fSR3BwvzbEC9I0nJJMOQTVfVbna+ZGdVKKuJuCHg2EyVV7XrlaKzIG+D/lP4DptBzbwQYKNkAQJpMYwjlVWoJ4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wvwbATWVqWon6bbRC3rGq9bX6iFKtnHD5pYLwQvjzaE=;
 b=wEQJZIhfcrBpqN8iFnKwxcz8rNdJ7LJ3/8/Owad1HezeBknH4+719WPMgAy3Q2R6OkLa09S7f0UYTEg8Q4zJ5njoBmRLQUyOyc5dYYpQB+lD43fU5+OEgHhlmDt81XK/0aHc83sjlloxPzdKfn2SaqLU5Q8YISEKRGvm+qgSomA=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:06:21 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:06:20 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Bikash Hazarika <bhazarika@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 1/7] qla2xxx: Multi-que support for TMF
Thread-Topic: [PATCH v2 1/7] qla2xxx: Multi-que support for TMF
Thread-Index: AQHZeaaqFh6z1303HkSuz/gW7zSu5q9FiZ6A
Date:   Mon, 1 May 2023 15:06:20 +0000
Message-ID: <FAE1C50C-BE2B-4AD4-9B96-DB9CC33C113C@oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
 <20230428075339.32551-2-njavali@marvell.com>
In-Reply-To: <20230428075339.32551-2-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BY5PR10MB4340:EE_
x-ms-office365-filtering-correlation-id: dc3e240f-90dc-4afc-e3e1-08db4a559f0a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZFWf/tcmxL3hok5JXbOc3JUcq6wjo/AQksjoE5sY9RFp7obDLLZBtEamu5YRFfs4fViDMOS8dX6v8iML0omD1fg5azR8z9CDXZGf5EThnzRFmFsNSB5Z1w8UWCXxJeocykBEUe8kGX0oQML2jZwknewEw//7y6pktfsdr2LloTkFiE08a+r1DNhWNxdsz9Qfts2Lp9HxnDAqMFjiT2V6rzYPaRpTpN7vCb/dGibztmv7eMb+zB9gnT2udxAowIRAID8qjuTsqHGqsMTz5GmfsbZrCt2eHTkhnuXllqG6WROM0EUMNdv+yyPNYQxAGglMu6sbEuStmcFohBCjrNlaTKMbEnC6zrZX2HtckZAAoy2i2JILvahfBt2WUcg6KXpQwnBgLqCVBPaYYkAZLXMzGZtmdZbSPPyDgEtoeaX6VZC5zAGY9EAtQYYxcTIQqe4504snCUt8PBJgBPHaE/jUMpSiM7+v/Oo6VTt3EgHbBm1jUC+fzgN889TVjLIa4NpptYNVym07WkyBFwM+6qzchm2X/NEejuPIDUC5WgVSgjL+/zSWeY3BVVsJY3njxtLMj8txzLeaMnMpTz1mmEwhm5yZrO4N5k1d10FgSe6V8B5d8i6rhXzekYylbbGFb+o4Q49VJKoAb2Fc1Qvx96Jztg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199021)(54906003)(478600001)(316002)(36756003)(4326008)(64756008)(66446008)(66476007)(76116006)(6916009)(66556008)(966005)(66946007)(6512007)(6506007)(26005)(2616005)(71200400001)(6486002)(186003)(53546011)(2906002)(8676002)(8936002)(5660300002)(44832011)(41300700001)(86362001)(38070700005)(38100700002)(122000001)(33656002)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nn/oa+p5GHOldElAo3UsArE2grutdGmGBweXMqrzJ3Pzgis5Vu87Co2FozSl?=
 =?us-ascii?Q?p4SFps/M7iqiiQH4ozKKE6Jayw4uVFWx4t3oUg6z2yq4JpKhVCODUJa0DCQX?=
 =?us-ascii?Q?F8Q2K7hbSeOsuNOTaOoT6nJMzNitdq1WrUt6ll1zy2zUMAJBkSaTzuPSrkno?=
 =?us-ascii?Q?OkacGSE09/v9yPyKeqF9lVBO+Wc3MTxJa664SV4MYYWPG8zlcYG8UFGBQDW/?=
 =?us-ascii?Q?gQ5hgbjlTVGKHb7smW7OBShbBSO7aTmIBgNvQ/0wuX4fNrgN59ckqFYlRG4i?=
 =?us-ascii?Q?Os1/qU9aHSxbW8oKc41dcnfJdS6+eUHY/NO82kRNjApcnaxtbwLCAf6mRGHZ?=
 =?us-ascii?Q?9JJezSo1rVEl7Cwz4RBtWjjtjOcpL0Xz5HqMcy93TnswUSclVBNtLirf5tah?=
 =?us-ascii?Q?U8pWHiLcOu59FhOIEuxI+0sZndCmw2aFYOU327L9TT4BpMw52/SKx5pC0K40?=
 =?us-ascii?Q?f6tlbUsVTqpJrY9ALuUYBKCp1eoeh+HMIRbCpBrEAUzynJqdh79I7nIBYjpv?=
 =?us-ascii?Q?mlNWsCP1qcIpAGQyWYvvethIMl+vMGNRfl9MuQp4Y7f7n6rbiHo29yW7zrv4?=
 =?us-ascii?Q?Qo/RXHVR+VdEyjExuLGMExsnO8QT8UgiuHY5YUihf5xB93WJn5i7lx4T24UH?=
 =?us-ascii?Q?7hW4J97RW5l4BgcKU0kRWfrh5klpicaUTTE4bVxeDcgpcBvsMME044oAkpRU?=
 =?us-ascii?Q?k07yNChpV9ecD48DRffK7cGYo3oySKwl/I/3eRqeSXeNKwKv8iab8duLC6xl?=
 =?us-ascii?Q?7xL1nYFIEXRQU166tzNVjuMYf8a8x02HdL668xcYK8jotemGu0ac7haDfkbI?=
 =?us-ascii?Q?EWV+SoSdWurVvOyc6W1ib+jHJUcWh+MxQQVqe/8Nmi69phPWq0soo3m1v8yA?=
 =?us-ascii?Q?kFU4Oz2PudRTeqvdHuYBZgbJNa7ldGMZGqDhKvYjMS8dU7vhaoJMoSwji+kk?=
 =?us-ascii?Q?HIUTrtRO48KU8YXPGgF0lDSxtYRm1LKqalXtw8hWDaCCrwyBDyKnZH8XjiUW?=
 =?us-ascii?Q?dj2drPUejE4GfIkwSrvsv0mlHsE5mUteQxPltNhCPpec6P/0Q8VLw+vVSWBr?=
 =?us-ascii?Q?/vvMh+MD9CD/FnMxMEaz80WEA0gu3LpDaERuoemcG63hGOhAmlU22nu1FaNw?=
 =?us-ascii?Q?OCFdX7x9R+bN+R3X0PgKEPgz5b39gKUGKLdbFo1nSPw7Vl6J+k6FQVzDRt9M?=
 =?us-ascii?Q?Vhr22o+smog0PKJUe5ga6CAc+tmWmrVHdcJ6NFWgvSzQUR9S9C/AcxT7KXDZ?=
 =?us-ascii?Q?68o5bdpK84juKxKvKs+CFMg026mGpen5M/yhWibfMFx2PfqhH0s8V+VgzRPZ?=
 =?us-ascii?Q?YmtA8adiEMMPDh55lIxh53TUQBrkrVogc+mDdRJFxZesxheYhra4I+bldXLy?=
 =?us-ascii?Q?EV+vAfDLvYRxoliOljvNklsVzzQogmdtEZZxW7jSCoBoVbuLJkdtzml9/mqf?=
 =?us-ascii?Q?IQCoPHzf5JGOqyM6rmpBEAozUXXo5SCRfv4JEIr/KRlvcVO/rUhTmd0lnzdd?=
 =?us-ascii?Q?Exj/51U0VnhnQA9bjXtqKMo7emscCBdQQ9RXvL9eelKx2k+Uq/ZpL92FhoYf?=
 =?us-ascii?Q?DjWTHfA8G7EUrZQUvjuxryKJJRZdfRMaO9WqEi3WSlp5lnUN+fG9AylUD9bK?=
 =?us-ascii?Q?VA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2C3197B780F7824DA060AF4C5E6100B5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JMdS95q1c1vPn1y3q2qcX7ugsTTinhHEH6nmz+jBY+sasIviKCh/jN+EROz1Njdj6QKdUIyH8oAuBlOEs6/B73jk+r2UbaBhjFxkpnlslKFRAQGQcn6Nr1ZnfaAOQVYeBmSwQLAyRaGp/g9PVHjnetqqwalq6Wito6F/M01b28aGCQFbjzdLAp7K1unnY8OP/ouID++O/IgeD7WmQ1CHhwYpmQkcW8vRBH0toNos1uL11STDvUHFCl75QAjHCS85FWlTUw4mH/JoWiv75k4bEEQTlrfUGV52Q4zut9tCfBxplp31q95YZexnf9uF892ZBFxmI0VZmS7rsIMxznqqR3y8b0Z7AGaKmJmq8BBoh6y/Ny2omiheFJ8Y//NsbWAHJ5SGvRP9/QGoY8Hd1Irw8KGhCj9h2lvq8MEes6Cmqe7Hky0TTKvPi7g8Px1EKtZ8tPE+aswOxiSuhDv/PYFJdko2e1DmmBDm1T7JjVtOlkE3lb1evFhlh5820iKFmXx3oUmoqaaCNI9lNWgtxnTKelNKbxgaJDk01rcdrVwzcDzbESiA64jyMW1Lc1ADtwRxWfTsyD0R8oHl3+jJwdX650/6fLXt7wS1+eKPO9IJFhr73KZdYpP1jwYZArJxzj8Ts5aC/MpcKHR6V+mCdDuKnJjbqS5eAtloKHJxqtVpYSRof9Ai07WCqG67rQ/52DtdY67PyuFVx8FH3eCOmOEKry/e1udvPXzTG7nGRug0CCjsRYtUoW3mvGpjSpP2vLjKFBEiBlpr6KV8BinqzCeQpgEcoexNHghH1cqkLZDXV98=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc3e240f-90dc-4afc-e3e1-08db4a559f0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 15:06:20.3550
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lfZBIQTOGUsD353ghPcciKY9EcH7Oym8GhqtOF4OdtY5y5rq2p8BC870ECmv/pbxXlqbEDatvPtW3gdtOxH6L8ZPW9m33GTYSwVPzlV0h8o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxlogscore=981 mlxscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305010122
X-Proofpoint-GUID: zg7WXXmR8IhH6gKQL8g8jDnzvsklVx20
X-Proofpoint-ORIG-GUID: zg7WXXmR8IhH6gKQL8g8jDnzvsklVx20
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 28, 2023, at 12:53 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Add queue flush for task management command, before
> placing it on the wire.
> Do IO flush for all Request Q's.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304271702.GpIL391S-lkp@int=
el.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> v2:
> - Fix warning reported by kernel robot.
>=20
> drivers/scsi/qla2xxx/qla_def.h  |  8 ++++
> drivers/scsi/qla2xxx/qla_gbl.h  |  2 +-
> drivers/scsi/qla2xxx/qla_init.c | 69 ++++++++++++++++++++++++++-------
> drivers/scsi/qla2xxx/qla_iocb.c |  5 ++-
> 4 files changed, 66 insertions(+), 18 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index ec0e987b71fa..d59e94ae0db4 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -466,6 +466,14 @@ static inline be_id_t port_id_to_be_id(port_id_t por=
t_id)
> return res;
> }
>=20
> +struct tmf_arg {
> + struct qla_qpair *qpair;
> + struct fc_port *fcport;
> + struct scsi_qla_host *vha;
> + u64 lun;
> + u32 flags;
> +};
> +
> struct els_logo_payload {
> uint8_t opcode;
> uint8_t rsvd[3];
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index 9aba07c7bde4..ef11ce46381d 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -69,7 +69,7 @@ extern int qla2x00_async_logout(struct scsi_qla_host *,=
 fc_port_t *);
> extern int qla2x00_async_prlo(struct scsi_qla_host *, fc_port_t *);
> extern int qla2x00_async_adisc(struct scsi_qla_host *, fc_port_t *,
>     uint16_t *);
> -extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint32_t, uint32_=
t);
> +extern int qla2x00_async_tm_cmd(fc_port_t *, uint32_t, uint64_t, uint32_=
t);
> struct qla_work_evt *qla2x00_alloc_work(struct scsi_qla_host *,
>     enum qla_work_type);
> extern int qla24xx_async_gnl(struct scsi_qla_host *, fc_port_t *);
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index ec0423ec6681..035d1984e2bd 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2020,17 +2020,19 @@ static void qla2x00_tmf_sp_done(srb_t *sp, int re=
s)
> complete(&tmf->u.tmf.comp);
> }
>=20
> -int
> -qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
> - uint32_t tag)
> +static int
> +__qla2x00_async_tm_cmd(struct tmf_arg *arg)
> {
> - struct scsi_qla_host *vha =3D fcport->vha;
> + struct scsi_qla_host *vha =3D arg->vha;
> struct srb_iocb *tm_iocb;
> srb_t *sp;
> + unsigned long flags;
> int rval =3D QLA_FUNCTION_FAILED;
>=20
> + fc_port_t *fcport =3D arg->fcport;
> +
> /* ref: INIT */
> - sp =3D qla2x00_get_sp(vha, fcport, GFP_KERNEL);
> + sp =3D qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
> if (!sp)
> goto done;
>=20
> @@ -2043,15 +2045,15 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t =
flags, uint32_t lun,
>=20
> tm_iocb =3D &sp->u.iocb_cmd;
> init_completion(&tm_iocb->u.tmf.comp);
> - tm_iocb->u.tmf.flags =3D flags;
> - tm_iocb->u.tmf.lun =3D lun;
> + tm_iocb->u.tmf.flags =3D arg->flags;
> + tm_iocb->u.tmf.lun =3D arg->lun;
>=20
> + rval =3D qla2x00_start_sp(sp);
> ql_dbg(ql_dbg_taskm, vha, 0x802f,
> -    "Async-tmf hdl=3D%x loop-id=3D%x portid=3D%02x%02x%02x.\n",
> +    "Async-tmf hdl=3D%x loop-id=3D%x portid=3D%02x%02x%02x ctrl=3D%x.\n"=
,
>    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
> -    fcport->d_id.b.area, fcport->d_id.b.al_pa);
> +    fcport->d_id.b.area, fcport->d_id.b.al_pa, arg->flags);
>=20
> - rval =3D qla2x00_start_sp(sp);
> if (rval !=3D QLA_SUCCESS)
> goto done_free_sp;
> wait_for_completion(&tm_iocb->u.tmf.comp);
> @@ -2065,12 +2067,14 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t =
flags, uint32_t lun,
>=20
> if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
> flags =3D tm_iocb->u.tmf.flags;
> - lun =3D (uint16_t)tm_iocb->u.tmf.lun;
> + if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET|
> + TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA))
> + flags =3D MK_SYNC_ID_LUN;
> + else
> + flags =3D MK_SYNC_ID;
>=20
> - /* Issue Marker IOCB */
> - qla2x00_marker(vha, vha->hw->base_qpair,
> -    fcport->loop_id, lun,
> -    flags =3D=3D TCF_LUN_RESET ? MK_SYNC_ID_LUN : MK_SYNC_ID);
> + qla2x00_marker(vha, sp->qpair,
> +    sp->fcport->loop_id, arg->lun, flags);
> }
>=20
> done_free_sp:
> @@ -2080,6 +2084,41 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t f=
lags, uint32_t lun,
> return rval;
> }
>=20
> +int
> +qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint64_t lun,
> +     uint32_t tag)
> +{
> + struct scsi_qla_host *vha =3D fcport->vha;
> + struct qla_qpair *qpair;
> + struct tmf_arg a;
> + struct completion comp;
> + int i, rval;
> +
> + init_completion(&comp);
> + a.vha =3D fcport->vha;
> + a.fcport =3D fcport;
> + a.lun =3D lun;
> +
> + if (vha->hw->mqenable) {
> + for (i =3D 0; i < vha->hw->num_qpairs; i++) {
> + qpair =3D vha->hw->queue_pair_map[i];
> + if (!qpair)
> + continue;
> + a.qpair =3D qpair;
> + a.flags =3D flags|TCF_NOTMCMD_TO_TARGET;
> + rval =3D __qla2x00_async_tm_cmd(&a);
> + if (rval)
> + break;
> + }
> + }
> +
> + a.qpair =3D vha->hw->base_qpair;
> + a.flags =3D flags;
> + rval =3D __qla2x00_async_tm_cmd(&a);
> +
> + return rval;
> +}
> +
> int
> qla24xx_async_abort_command(srb_t *sp)
> {
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index b9b3e6f80ea9..b02039601cc0 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2541,7 +2541,7 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *t=
sk)
> scsi_qla_host_t *vha =3D fcport->vha;
> struct qla_hw_data *ha =3D vha->hw;
> struct srb_iocb *iocb =3D &sp->u.iocb_cmd;
> - struct req_que *req =3D vha->req;
> + struct req_que *req =3D sp->qpair->req;
>=20
> flags =3D iocb->u.tmf.flags;
> lun =3D iocb->u.tmf.lun;
> @@ -2557,7 +2557,8 @@ qla24xx_tm_iocb(srb_t *sp, struct tsk_mgmt_entry *t=
sk)
> tsk->port_id[2] =3D fcport->d_id.b.domain;
> tsk->vp_index =3D fcport->vha->vp_idx;
>=20
> - if (flags =3D=3D TCF_LUN_RESET) {
> + if (flags & (TCF_LUN_RESET | TCF_ABORT_TASK_SET|
> +    TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA)) {
> int_to_scsilun(lun, &tsk->lun);
> host_to_fcp_swap((uint8_t *)&tsk->lun,
> sizeof(tsk->lun));
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

