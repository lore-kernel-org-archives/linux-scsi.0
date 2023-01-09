Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7FC5C54EBD
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 20:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbjAIUHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 15:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237609AbjAIUHH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 15:07:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A497A193C8
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 12:07:06 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 309JvNYf005070;
        Mon, 9 Jan 2023 20:07:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ESyPDxtcODJaqxFn4b1BsHosQyP2Fu28hZ6QBB3N78w=;
 b=KWtEjMagbxPNgU2GqtygqMqU8jvQqzCUttJONj7a8v+p7XSyimwQq6pWgu8Jju4Kqxbl
 s7PcaqRF75ms5g+obznqMJkLVegtjevTxXoXWu5CKqZYRyF/6tJLvsmGMfH1MLGY7nNV
 yLLjiei4zlKHpvg13b8JEDbLo6UeGjiWlB4g5zQwvg6WImhlmh3mPIYIsbzFEVDk9A79
 vbmboYtT+r37u7mCTsqxoCM9SPz/CMixw/iMTbW8EeM4QhTeo0R5XS2psS2UUtDZY6VZ
 5bLmUYVTattOdSiDocr/Cj5ZI/sNmEND6PJRKsBZ1SKkHHXi9ne8YD6HO/2RckfWrjHy HA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mydxmayu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:07:04 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 309JpeiT035357;
        Mon, 9 Jan 2023 20:07:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n0h8umx7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Jan 2023 20:07:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZK6V9MSkv9ld9JqjMkTethkHnL8EdxA1OeScRZZ0UqeaJLxgJSSeg12Qhke3wqO3eFXDsi5/6KR6EtocKJjjx7eTzKSVPGHjfMwHGSTseZZleKXTBl2GaRwewnFF3o+2Et0DdQyHXjrjDRmPbYuo8UOvKmqmL3vO6FMH2oZI4Jzo0hahGnK2jksKe3Q2vYBgAwzNaJ1NaVAUL8RnUjLLeRCIrilmbfuwilPjMV10pFBYahqfA4yYRkfAKJiz15hUUxe0ykkr7sCZai5y+CBGcqKAFODddKsDZqomh9d0Zgs/9wMn5suurDmNXnCxpDnq62j2Dzf6r4OX8vX/d05krw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESyPDxtcODJaqxFn4b1BsHosQyP2Fu28hZ6QBB3N78w=;
 b=QrfsZIXu38z3mXKUh8ltwmYpw609XAph5x9juz9YKPBr4AImXQz4ejwZwAZlp1ufT9z3v2KdbMS1/hQS50MqogaUeWy/bcofiZCAqVHz/lRuY1EkDIqgtAAkRpDs1gPT9AQUUzyExkc2riMUNazqA/rOcG3M1xQ2m3PM4Kf2DWqzg18GblxQOG2xIMs8W8zyNhuL5yGrbFOEoh4lAnkHrPoG6LLRhVqA4MXKDqWUCcNboRMdpW6IpENVa3O/5swLwNZYKBVStcqpHlDK/gxEcyE3I8GCMI+/rbtcIHRWoktdYcCw7MwWShxe4/KzBZaRMhzKr+zsjpQuUW4uRYTYwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESyPDxtcODJaqxFn4b1BsHosQyP2Fu28hZ6QBB3N78w=;
 b=qzWZ+C8fmYrlqNuiCOhiWy8nLjyd1H9LJfdtmByT6UasjyOPcSwopfjU8DW5n/hpG2x7aaBDcsNdvfJvMgGC6VVCMZ7mIp3QBlJC+jADBFMhJWK0aEeR14dJQaZ46s0g+YImLJOCIbkM8leARkKJeJL5SD+Ya+L+kdpAFgmDi8o=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5191.namprd10.prod.outlook.com (2603:10b6:408:116::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Mon, 9 Jan
 2023 20:07:01 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::bc55:518f:9d06:9762%2]) with mapi id 15.20.5944.019; Mon, 9 Jan 2023
 20:07:01 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 02/10] qla2xxx: Remove dead code (GPNID)
Thread-Topic: [PATCH 02/10] qla2xxx: Remove dead code (GPNID)
Thread-Index: AQHZFb95aQYf2eMM8UqyG7fwaZCsY66WoF4A
Date:   Mon, 9 Jan 2023 20:07:01 +0000
Message-ID: <BCB04BBD-15C3-4D38-8C21-541F5CF9FF3A@oracle.com>
References: <20221222043933.2825-1-njavali@marvell.com>
 <20221222043933.2825-3-njavali@marvell.com>
In-Reply-To: <20221222043933.2825-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BN0PR10MB5191:EE_
x-ms-office365-filtering-correlation-id: 860737c1-cb9a-402b-93e1-08daf27d11fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3B0FYEo2yLhypacrRuwIM0claCrky2jFeuBuY3IkUbf4zZ55xPGvKZVDJLQIl05HKTbqojM5u6MoXKEtvzHKp0kfsRPlryURUaL0JIhqRl+3sf8vnra7AV7F59pvg7JcnJWBlNluBf4vpwQ8HEfl4BWhKP8eB96qt+JEfdb+xKWBjSVGIcawvFhC5d/XydTTDwT+trXoE2wusXhKaBt42/XbEMgLt9+kAkPAcfIAW5BTyeWmZcMSLzZKCTdSFiyIMdeJrdBVMs7jazUHKKx73ZfecKNc169c4sSgx/CsxmAsp4J+s/v7PHGaIUc5r9wG44brGN0rlpz37qIU7c+BnreJpd/i/cF7yr1xhAs719BSIKsJaoaiLoDXU05A3p5TGBh9F3K+tV8T0WBvJ2C9vQXoQkua8zURMoUB0mlydVanBHF7gInaeSr/kHOVbYExvmeYMSUMg5PqTDwxcLGLH1yym0Xd/Ct+IjICyQjmf5igF/xbzgG3ZnkKefoqkxPQtdGGXa6ce7CYPXpJLsLYk0l+hHvmfWBfqnODh4cwQjFUaCIK8lPH0LX1/Ec9DaW33AWbqbS7n1E12P7yG3JS8KBwjbys99P0XPVsZxpBvDTJrLCVh+5wyeaSwelOaLNjL4qFnFq+rw2vsch7rJFjF+ts176KPEOK1uMrYcjCTS12O/7GWIO1OAG72BoQ/pJ/3hFdqrjmiTp4UpMxd80kWvegp2UHgDjG+Ee404w4k6o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(376002)(396003)(136003)(451199015)(83380400001)(122000001)(2906002)(30864003)(41300700001)(44832011)(8936002)(5660300002)(38100700002)(186003)(53546011)(6506007)(478600001)(2616005)(6512007)(66446008)(4326008)(6486002)(66476007)(8676002)(64756008)(316002)(6916009)(54906003)(91956017)(71200400001)(66946007)(86362001)(66556008)(76116006)(38070700005)(36756003)(33656002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?anzUaHV/pByAZHplECTtktF+70HaeAh91TtuTpOaAOHtKivGNHqB3rFaypdD?=
 =?us-ascii?Q?s5qHBPPxWBWMT96KvG7/VS6rUL2bSSbZlwMritNBN58jp8qtmKlBnCaQLQ1H?=
 =?us-ascii?Q?kiQyWMOABZNxG3b+umYiHnnJtTAi40Bd/0uJXhMn8/1Lmtzg4D+90uO2I88s?=
 =?us-ascii?Q?NNOSGpaGA9suN2QLzXE9hWzVRQVetsfGPNZTHplyLiq4HvgAGZPNVzFLPWJ9?=
 =?us-ascii?Q?baaMHGkZM0FHao6ZhP0l4Ocy9/6iY3WjGOU8ocj1qnw807XTOI2+9iamdxyG?=
 =?us-ascii?Q?eG6VtPfF7DVkmImN0icfXu8jClJsvTBogED8TCAExJg8V6ay/rIgzRFEpFAi?=
 =?us-ascii?Q?Bf47SyvmeOuuDXMVIj8wGQNNfnh3DShisSTRqc1W1EKCHFiBGZA7tztIffoq?=
 =?us-ascii?Q?xR+JwXsfjaRL9X1XrNU+RGK9ObuE6dgSoxQhYjf2L+l4aVSkgd5MygfWkB4J?=
 =?us-ascii?Q?sc6OXEc/WsB4tcoR0yVdojZyAHLKTDdUvaeBIu9O1D2iXY0ZRRvYUavjTDWU?=
 =?us-ascii?Q?EidhgTqqJ9UcqXtTuxyVKSv2aMaREBzLiHRbeegryO25JnaLr5+4bECSsnQm?=
 =?us-ascii?Q?HWBjwLjtbHkhZtJ9Gx3lHBHYlyZy9lHc0qkzMfVW2WO0hX2vLwpUiXQaiPJk?=
 =?us-ascii?Q?vqHmzV46/T8Ok3GvN9lisSHAQ0gkIew0OlW+P6FGciNuTeeeetJFJ6MdlJHR?=
 =?us-ascii?Q?4WTeEA8/t2fy6V47NxT6HjLBgOVr17Wa5apvO3TqZEv4yrHb1gWuYZCJ5RQ6?=
 =?us-ascii?Q?DcsMxAAdEUrFkXeh2sFQNY9pLSTFQw78d2H/b75huyFOXcOx8rsyIMtSaaei?=
 =?us-ascii?Q?rwYVUs9dx5/KuXF1djtHsv/bLKfmVDOc4CCEo3tzzMOrovRWkHIcdOjnVtxT?=
 =?us-ascii?Q?w2g3BwgyuTh5IDFIFtyhFX3UezTeIvucjslVZjfqGHVSvvsdQHWSYbK4HA3Q?=
 =?us-ascii?Q?HxIVo5k3VedZwGQAWOUaSGlrlf0rywlPmr0emk3gJ82IOlQtQtAg87U5NN3u?=
 =?us-ascii?Q?XUbDZCs29no+V9tuN4JjBdZL5qpPByp22pWezsjIb7VHkrkSotKAtmQHdC5G?=
 =?us-ascii?Q?VawH2Y65UHtTFy/uPSi372z+p1BNkYLm7o8wsrd6tCWSJUglF58zpLjA0WuG?=
 =?us-ascii?Q?E3R7ATExslCEkJNKXcibWrZWbD+5kStUm4a2ZTSg8mtIo8CYM5y4LDmUQQzC?=
 =?us-ascii?Q?lEl0M4tw2RRO34BEU8hVKFomNBn92ASw09aPJYH323HP+2TTkIHGoyfKjAiE?=
 =?us-ascii?Q?t7zzeiWOUrBuroRzy1Hu89I2IFxQKB430p4W7kv7kK6bQBBCGsoQi8D0Rxbp?=
 =?us-ascii?Q?r/sgUz/yRJzmQQXYQ6M6T8iYYtabd0m8S+4H4POtdzGprLfUuZBAU8avR7Op?=
 =?us-ascii?Q?YYG77gsg5BuAFBTNIMYUAg3vbo38a42pJcTnJmVLXRLidarXavAkU24rpv4y?=
 =?us-ascii?Q?dA6XLiEMCGxtlD67IAl7jhvwOomgPBFpe1S+qQWGaOuDc7Q8RDZw7/IDuDv4?=
 =?us-ascii?Q?1k60ji/HMasEgCtOYX2YIyykzNdgXStDed9dTMpxhixVUHupsOxA2JDTBFht?=
 =?us-ascii?Q?mgsbAysNJ2ID8roBa7/k+2ZHTmPgDd6Xq0Ee62AEIKM9JFUMCsQidByz/q0b?=
 =?us-ascii?Q?oD3jMiSgwaL5+mViTU/dJ9fJ1HJNTd5CBW4KamrHzdWTZ0QACE2TCIlzW4X8?=
 =?us-ascii?Q?yjFoKYdVSp1s5IzZ1aIqWVgEjfE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AC2B6E3DA2E87845B26A08D70AE594B8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AHnsBOoyz0JszDgysn7XkSDSHudxnOdCuxUfcOX0MORPVAx4JtVt2otjdhKUWF+D+XDa4bisHKBIFUvt2eLPPX4HjyVHW9Xs1ZfztR7HUfSxMm8K9AC0ucHBZ0Ybn26FXf6Xu/pYcrqtOKMyedvOuT1ZD7SnZg/KX8Cn4JW8fUz90K+mmQOyvbXtGssNiV2Cxe03p5kYeuXYpIFGeIDw5w4S4ajOzBmqljLJwV9Q6v+eSjBLpfeEi2f5l2nGRFXIHuuSDlz9iVPUpho3WpVK50+Hht8GH+mWvEmJfP11TYhNOv+QaFxdq/98W/1cdB+UhWiFkXVXj31e8uG/sny2t6Ei15tuIG66ujx6VG5GLmrvLcf991lBLKnGepdWvdQ93jWbzvKE5Ul4u73MQnlC+UoM6/X5Roo6H1kb3+N48aAqCID+iMRhusZZ8Hmzo7vip9qfKPORy+oxRFrQ7l/osPRxMOU6C7sSzw35EG3ryF2C74qR7xJk6c6YurPFvzCsXB/bJZm37zx4xsDCyO7q0Wmh1yDiWXKErufAYk8/65Qcg3oGqOBKwX4S1HzG6L6GxMC+8IQdYITkVBeJwPF7/nxt0oPmqZLz1vTwYjSW/w3ZOXtXkMNctibxEk9LHxYsW/byhppATu4PnTT0lycUQWuKYkopG9r/laXvNjvqX5sF6zgDfgeQYTa5+mUTU1EumPROA0myrExeyIL0kJz8tktV60fB5Ml3GETaCZeXP2FyrPCma8ox96S/bbkWp4AbjN82DdzMIAFvI/8+81SpzSpQufvMlTdRR1x8fUts90c=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860737c1-cb9a-402b-93e1-08daf27d11fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2023 20:07:01.2567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8FsGUvVnBJVavJUx/Z2My2NGXgsgoDJB9CtOHqVH8DXncl2FJhPGqzXd8z/usHUQdo2G4klrIv8j5pjakjtXMGlBnbFVnwIKlF6HCdQIuzs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5191
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-09_14,2023-01-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301090141
X-Proofpoint-ORIG-GUID: oLMNaJ9TQJri3V17ePuOUjeovpo3QKCE
X-Proofpoint-GUID: oLMNaJ9TQJri3V17ePuOUjeovpo3QKCE
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Dec 21, 2022, at 8:39 PM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Remove stale unused code for GPNID.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_def.h  |   7 +-
> drivers/scsi/qla2xxx/qla_gbl.h  |   4 -
> drivers/scsi/qla2xxx/qla_gs.c   | 297 --------------------------------
> drivers/scsi/qla2xxx/qla_init.c |   2 +-
> drivers/scsi/qla2xxx/qla_iocb.c |   2 +-
> drivers/scsi/qla2xxx/qla_os.c   |   4 -
> 6 files changed, 3 insertions(+), 313 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 0dde3fa9e258..9ee9ce613c75 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -3479,7 +3479,6 @@ enum qla_work_type {
> 	QLA_EVT_ASYNC_ADISC,
> 	QLA_EVT_UEVENT,
> 	QLA_EVT_AENFX,
> -	QLA_EVT_GPNID,
> 	QLA_EVT_UNMAP,
> 	QLA_EVT_NEW_SESS,
> 	QLA_EVT_GPDB,
> @@ -3534,9 +3533,6 @@ struct qla_work_evt {
> 		struct {
> 			srb_t *sp;
> 		} iosb;
> -		struct {
> -			port_id_t id;
> -		} gpnid;
> 		struct {
> 			port_id_t id;
> 			u8 port_name[8];
> @@ -3544,7 +3540,7 @@ struct qla_work_evt {
> 			void *pla;
> 			u8 fc4_type;
> 		} new_sess;
> -		struct { /*Get PDB, Get Speed, update fcport, gnl, gidpn */
> +		struct { /*Get PDB, Get Speed, update fcport, gnl */
> 			fc_port_t *fcport;
> 			u8 opt;
> 		} fcport;
> @@ -5025,7 +5021,6 @@ typedef struct scsi_qla_host {
> 	uint8_t n2n_port_name[WWN_SIZE];
> 	uint16_t	n2n_id;
> 	__le16 dport_data[4];
> -	struct list_head gpnid_list;
> 	struct fab_scan scan;
> 	uint8_t	scm_fabric_connection_flags;
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index e3256e721be1..2acddc8dc943 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -721,10 +721,6 @@ extern int qla2x00_chk_ms_status(scsi_qla_host_t *, =
ms_iocb_entry_t *,
> 	struct ct_sns_rsp *, const char *);
> extern void qla2x00_async_iocb_timeout(void *data);
>=20
> -extern int qla24xx_post_gpnid_work(struct scsi_qla_host *, port_id_t *);
> -extern int qla24xx_async_gpnid(scsi_qla_host_t *, port_id_t *);
> -void qla24xx_handle_gpnid_event(scsi_qla_host_t *, struct event_arg *);
> -
> int qla24xx_post_gpsc_work(struct scsi_qla_host *, fc_port_t *);
> int qla24xx_async_gpsc(scsi_qla_host_t *, fc_port_t *);
> void qla24xx_handle_gpsc_event(scsi_qla_host_t *, struct event_arg *);
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index 64ab070b8716..fe1eb06db654 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -2949,22 +2949,6 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_po=
rt_t *fcport)
> 	return rval;
> }
>=20
> -int qla24xx_post_gpnid_work(struct scsi_qla_host *vha, port_id_t *id)
> -{
> -	struct qla_work_evt *e;
> -
> -	if (test_bit(UNLOADING, &vha->dpc_flags) ||
> -	    (vha->vp_idx && test_bit(VPORT_DELETE, &vha->dpc_flags)))
> -		return 0;
> -
> -	e =3D qla2x00_alloc_work(vha, QLA_EVT_GPNID);
> -	if (!e)
> -		return QLA_FUNCTION_FAILED;
> -
> -	e->u.gpnid.id =3D *id;
> -	return qla2x00_post_work(vha, e);
> -}
> -
> void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t *sp)
> {
> 	struct srb_iocb *c =3D &sp->u.iocb_cmd;
> @@ -2997,287 +2981,6 @@ void qla24xx_sp_unmap(scsi_qla_host_t *vha, srb_t=
 *sp)
> 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> }
>=20
> -void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *=
ea)
> -{
> -	fc_port_t *fcport, *conflict, *t;
> -	u16 data[2];
> -
> -	ql_dbg(ql_dbg_disc, vha, 0xffff,
> -	    "%s %d port_id: %06x\n",
> -	    __func__, __LINE__, ea->id.b24);
> -
> -	if (ea->rc) {
> -		/* cable is disconnected */
> -		list_for_each_entry_safe(fcport, t, &vha->vp_fcports, list) {
> -			if (fcport->d_id.b24 =3D=3D ea->id.b24)
> -				fcport->scan_state =3D QLA_FCPORT_SCAN;
> -
> -			qlt_schedule_sess_for_deletion(fcport);
> -		}
> -	} else {
> -		/* cable is connected */
> -		fcport =3D qla2x00_find_fcport_by_wwpn(vha, ea->port_name, 1);
> -		if (fcport) {
> -			list_for_each_entry_safe(conflict, t, &vha->vp_fcports,
> -			    list) {
> -				if ((conflict->d_id.b24 =3D=3D ea->id.b24) &&
> -				    (fcport !=3D conflict))
> -					/*
> -					 * 2 fcports with conflict Nport ID or
> -					 * an existing fcport is having nport ID
> -					 * conflict with new fcport.
> -					 */
> -
> -					conflict->scan_state =3D QLA_FCPORT_SCAN;
> -
> -				qlt_schedule_sess_for_deletion(conflict);
> -			}
> -
> -			fcport->scan_needed =3D 0;
> -			fcport->rscn_gen++;
> -			fcport->scan_state =3D QLA_FCPORT_FOUND;
> -			fcport->flags |=3D FCF_FABRIC_DEVICE;
> -			if (fcport->login_retry =3D=3D 0) {
> -				fcport->login_retry =3D
> -					vha->hw->login_retry_count;
> -				ql_dbg(ql_dbg_disc, vha, 0xffff,
> -				    "Port login retry %8phN, lid 0x%04x cnt=3D%d.\n",
> -				    fcport->port_name, fcport->loop_id,
> -				    fcport->login_retry);
> -			}
> -			switch (fcport->disc_state) {
> -			case DSC_LOGIN_COMPLETE:
> -				/* recheck session is still intact. */
> -				ql_dbg(ql_dbg_disc, vha, 0x210d,
> -				    "%s %d %8phC revalidate session with ADISC\n",
> -				    __func__, __LINE__, fcport->port_name);
> -				data[0] =3D data[1] =3D 0;
> -				qla2x00_post_async_adisc_work(vha, fcport,
> -				    data);
> -				break;
> -			case DSC_DELETED:
> -				ql_dbg(ql_dbg_disc, vha, 0x210d,
> -				    "%s %d %8phC login\n", __func__, __LINE__,
> -				    fcport->port_name);
> -				fcport->d_id =3D ea->id;
> -				qla24xx_fcport_handle_login(vha, fcport);
> -				break;
> -			case DSC_DELETE_PEND:
> -				fcport->d_id =3D ea->id;
> -				break;
> -			default:
> -				fcport->d_id =3D ea->id;
> -				break;
> -			}
> -		} else {
> -			list_for_each_entry_safe(conflict, t, &vha->vp_fcports,
> -			    list) {
> -				if (conflict->d_id.b24 =3D=3D ea->id.b24) {
> -					/* 2 fcports with conflict Nport ID or
> -					 * an existing fcport is having nport ID
> -					 * conflict with new fcport.
> -					 */
> -					ql_dbg(ql_dbg_disc, vha, 0xffff,
> -					    "%s %d %8phC DS %d\n",
> -					    __func__, __LINE__,
> -					    conflict->port_name,
> -					    conflict->disc_state);
> -
> -					conflict->scan_state =3D QLA_FCPORT_SCAN;
> -					qlt_schedule_sess_for_deletion(conflict);
> -				}
> -			}
> -
> -			/* create new fcport */
> -			ql_dbg(ql_dbg_disc, vha, 0x2065,
> -			    "%s %d %8phC post new sess\n",
> -			    __func__, __LINE__, ea->port_name);
> -			qla24xx_post_newsess_work(vha, &ea->id,
> -			    ea->port_name, NULL, NULL, 0);
> -		}
> -	}
> -}
> -
> -static void qla2x00_async_gpnid_sp_done(srb_t *sp, int res)
> -{
> -	struct scsi_qla_host *vha =3D sp->vha;
> -	struct ct_sns_req *ct_req =3D
> -	    (struct ct_sns_req *)sp->u.iocb_cmd.u.ctarg.req;
> -	struct ct_sns_rsp *ct_rsp =3D
> -	    (struct ct_sns_rsp *)sp->u.iocb_cmd.u.ctarg.rsp;
> -	struct event_arg ea;
> -	struct qla_work_evt *e;
> -	unsigned long flags;
> -
> -	if (res)
> -		ql_dbg(ql_dbg_disc, vha, 0x2066,
> -		    "Async done-%s fail res %x rscn gen %d ID %3phC. %8phC\n",
> -		    sp->name, res, sp->gen1, &ct_req->req.port_id.port_id,
> -		    ct_rsp->rsp.gpn_id.port_name);
> -	else
> -		ql_dbg(ql_dbg_disc, vha, 0x2066,
> -		    "Async done-%s good rscn gen %d ID %3phC. %8phC\n",
> -		    sp->name, sp->gen1, &ct_req->req.port_id.port_id,
> -		    ct_rsp->rsp.gpn_id.port_name);
> -
> -	memset(&ea, 0, sizeof(ea));
> -	memcpy(ea.port_name, ct_rsp->rsp.gpn_id.port_name, WWN_SIZE);
> -	ea.sp =3D sp;
> -	ea.id =3D be_to_port_id(ct_req->req.port_id.port_id);
> -	ea.rc =3D res;
> -
> -	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> -	list_del(&sp->elem);
> -	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> -
> -	if (res) {
> -		if (res =3D=3D QLA_FUNCTION_TIMEOUT) {
> -			qla24xx_post_gpnid_work(sp->vha, &ea.id);
> -			/* ref: INIT */
> -			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -			return;
> -		}
> -	} else if (sp->gen1) {
> -		/* There was another RSCN for this Nport ID */
> -		qla24xx_post_gpnid_work(sp->vha, &ea.id);
> -		/* ref: INIT */
> -		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -		return;
> -	}
> -
> -	qla24xx_handle_gpnid_event(vha, &ea);
> -
> -	e =3D qla2x00_alloc_work(vha, QLA_EVT_UNMAP);
> -	if (!e) {
> -		/* please ignore kernel warning. otherwise, we have mem leak. */
> -		dma_free_coherent(&vha->hw->pdev->dev,
> -				  sp->u.iocb_cmd.u.ctarg.req_allocated_size,
> -				  sp->u.iocb_cmd.u.ctarg.req,
> -				  sp->u.iocb_cmd.u.ctarg.req_dma);
> -		sp->u.iocb_cmd.u.ctarg.req =3D NULL;
> -
> -		dma_free_coherent(&vha->hw->pdev->dev,
> -				  sp->u.iocb_cmd.u.ctarg.rsp_allocated_size,
> -				  sp->u.iocb_cmd.u.ctarg.rsp,
> -				  sp->u.iocb_cmd.u.ctarg.rsp_dma);
> -		sp->u.iocb_cmd.u.ctarg.rsp =3D NULL;
> -
> -		/* ref: INIT */
> -		kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -		return;
> -	}
> -
> -	e->u.iosb.sp =3D sp;
> -	qla2x00_post_work(vha, e);
> -}
> -
> -/* Get WWPN with Nport ID. */
> -int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
> -{
> -	int rval =3D QLA_FUNCTION_FAILED;
> -	struct ct_sns_req       *ct_req;
> -	srb_t *sp, *tsp;
> -	struct ct_sns_pkt *ct_sns;
> -	unsigned long flags;
> -
> -	if (!vha->flags.online)
> -		goto done;
> -
> -	/* ref: INIT */
> -	sp =3D qla2x00_get_sp(vha, NULL, GFP_KERNEL);
> -	if (!sp)
> -		goto done;
> -
> -	sp->type =3D SRB_CT_PTHRU_CMD;
> -	sp->name =3D "gpnid";
> -	sp->u.iocb_cmd.u.ctarg.id =3D *id;
> -	sp->gen1 =3D 0;
> -	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
> -			      qla2x00_async_gpnid_sp_done);
> -
> -	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
> -	list_for_each_entry(tsp, &vha->gpnid_list, elem) {
> -		if (tsp->u.iocb_cmd.u.ctarg.id.b24 =3D=3D id->b24) {
> -			tsp->gen1++;
> -			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> -			/* ref: INIT */
> -			kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -			goto done;
> -		}
> -	}
> -	list_add_tail(&sp->elem, &vha->gpnid_list);
> -	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
> -
> -	sp->u.iocb_cmd.u.ctarg.req =3D dma_alloc_coherent(&vha->hw->pdev->dev,
> -		sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.req_dma,
> -		GFP_KERNEL);
> -	sp->u.iocb_cmd.u.ctarg.req_allocated_size =3D sizeof(struct ct_sns_pkt)=
;
> -	if (!sp->u.iocb_cmd.u.ctarg.req) {
> -		ql_log(ql_log_warn, vha, 0xd041,
> -		    "Failed to allocate ct_sns request.\n");
> -		goto done_free_sp;
> -	}
> -
> -	sp->u.iocb_cmd.u.ctarg.rsp =3D dma_alloc_coherent(&vha->hw->pdev->dev,
> -		sizeof(struct ct_sns_pkt), &sp->u.iocb_cmd.u.ctarg.rsp_dma,
> -		GFP_KERNEL);
> -	sp->u.iocb_cmd.u.ctarg.rsp_allocated_size =3D sizeof(struct ct_sns_pkt)=
;
> -	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
> -		ql_log(ql_log_warn, vha, 0xd042,
> -		    "Failed to allocate ct_sns request.\n");
> -		goto done_free_sp;
> -	}
> -
> -	ct_sns =3D (struct ct_sns_pkt *)sp->u.iocb_cmd.u.ctarg.rsp;
> -	memset(ct_sns, 0, sizeof(*ct_sns));
> -
> -	ct_sns =3D (struct ct_sns_pkt *)sp->u.iocb_cmd.u.ctarg.req;
> -	/* CT_IU preamble  */
> -	ct_req =3D qla2x00_prep_ct_req(ct_sns, GPN_ID_CMD, GPN_ID_RSP_SIZE);
> -
> -	/* GPN_ID req */
> -	ct_req->req.port_id.port_id =3D port_id_to_be_id(*id);
> -
> -	sp->u.iocb_cmd.u.ctarg.req_size =3D GPN_ID_REQ_SIZE;
> -	sp->u.iocb_cmd.u.ctarg.rsp_size =3D GPN_ID_RSP_SIZE;
> -	sp->u.iocb_cmd.u.ctarg.nport_handle =3D NPH_SNS;
> -
> -	ql_dbg(ql_dbg_disc, vha, 0x2067,
> -	    "Async-%s hdl=3D%x ID %3phC.\n", sp->name,
> -	    sp->handle, &ct_req->req.port_id.port_id);
> -
> -	rval =3D qla2x00_start_sp(sp);
> -	if (rval !=3D QLA_SUCCESS)
> -		goto done_free_sp;
> -
> -	return rval;
> -
> -done_free_sp:
> -	spin_lock_irqsave(&vha->hw->vport_slock, flags);
> -	list_del(&sp->elem);
> -	spin_unlock_irqrestore(&vha->hw->vport_slock, flags);
> -
> -	if (sp->u.iocb_cmd.u.ctarg.req) {
> -		dma_free_coherent(&vha->hw->pdev->dev,
> -			sizeof(struct ct_sns_pkt),
> -			sp->u.iocb_cmd.u.ctarg.req,
> -			sp->u.iocb_cmd.u.ctarg.req_dma);
> -		sp->u.iocb_cmd.u.ctarg.req =3D NULL;
> -	}
> -	if (sp->u.iocb_cmd.u.ctarg.rsp) {
> -		dma_free_coherent(&vha->hw->pdev->dev,
> -			sizeof(struct ct_sns_pkt),
> -			sp->u.iocb_cmd.u.ctarg.rsp,
> -			sp->u.iocb_cmd.u.ctarg.rsp_dma);
> -		sp->u.iocb_cmd.u.ctarg.rsp =3D NULL;
> -	}
> -	/* ref: INIT */
> -	kref_put(&sp->cmd_kref, qla2x00_sp_release);
> -done:
> -	return rval;
> -}
> -
> -
> void qla24xx_async_gffid_sp_done(srb_t *sp, int res)
> {
> 	struct scsi_qla_host *vha =3D sp->vha;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index ca216b820b1c..c66a0106a7fc 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2323,7 +2323,7 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_hos=
t *vha, struct event_arg *ea)
> 			ea->fcport->login_pause =3D 1;
>=20
> 			ql_dbg(ql_dbg_disc, vha, 0x20ed,
> -			    "%s %d %8phC NPortId %06x inuse with loopid 0x%x. post gidpn\n",
> +			    "%s %d %8phC NPortId %06x inuse with loopid 0x%x.\n",
> 			    __func__, __LINE__, ea->fcport->port_name,
> 			    ea->fcport->d_id.b24, lid);
> 		} else {
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 6b91dcfd994d..9a7cc0ba5f58 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2920,7 +2920,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
> 					conflict_fcport->conflict =3D fcport;
> 					fcport->login_pause =3D 1;
> 					ql_dbg(ql_dbg_disc, vha, 0x20ed,
> -					    "%s %d %8phC pid %06x inuse with lid %#x post gidpn\n",
> +					    "%s %d %8phC pid %06x inuse with lid %#x.\n",
> 					    __func__, __LINE__,
> 					    fcport->port_name,
> 					    fcport->d_id.b24, lid);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 078b63b89189..bbbdf2ffb682 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -5016,7 +5016,6 @@ struct scsi_qla_host *qla2x00_create_host(struct sc=
si_host_template *sht,
> 	INIT_LIST_HEAD(&vha->plogi_ack_list);
> 	INIT_LIST_HEAD(&vha->qp_list);
> 	INIT_LIST_HEAD(&vha->gnl.fcports);
> -	INIT_LIST_HEAD(&vha->gpnid_list);
> 	INIT_WORK(&vha->iocb_work, qla2x00_iocb_work_fn);
>=20
> 	INIT_LIST_HEAD(&vha->purex_list.head);
> @@ -5461,9 +5460,6 @@ qla2x00_do_work(struct scsi_qla_host *vha)
> 		case QLA_EVT_AENFX:
> 			qlafx00_process_aen(vha, e);
> 			break;
> -		case QLA_EVT_GPNID:
> -			qla24xx_async_gpnid(vha, &e->u.gpnid.id);
> -			break;
> 		case QLA_EVT_UNMAP:
> 			qla24xx_sp_unmap(vha, e->u.iosb.sp);
> 			break;
> --=20
> 2.19.0.rc0
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani	Oracle Linux Engineering

