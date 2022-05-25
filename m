Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EBEC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 25 May 2022 15:17:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245154AbiEYPRN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 May 2022 11:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiEYPRB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2022 11:17:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F3436171
        for <linux-scsi@vger.kernel.org>; Wed, 25 May 2022 08:16:59 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24PD3u6p003154;
        Wed, 25 May 2022 15:16:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=Sj++m39XlDeBtPngBI02jXhSMgwN7aJ6y47U6cYSPJc=;
 b=Bl/fN3D245KxaxBWkwKYwwH+aRTVRXN+wVvkjuEqm/flQfRkbn2NZeKUkPXb+wj091i+
 iBz0iPJdai+09onV+hyDXq01DGJpz9ebEn61XTuLdqKcKSMY4Ilt3UzeSG1ySK6F1mwb
 XS1p7GvMbktTdRatGcZm79EWSN/wt2PUrS1Y0bVWoqokh0isjhYUtGF21Xc2WycUNFtW
 3QmND6okk3eNBj8cW04nzS94cbv0nYuNTOznEPl3fGpeiA6E/SwSr2Zk0xEBc1Rz8zfD
 S3mznimzqUTyzgwTVfhSJ6/0VqT4H9mtB2qVxCpcEY/RkJ3W/D6V3lKH17LkMA6aKbXO zA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93tatj54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 15:16:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24PFA09E036433;
        Wed, 25 May 2022 15:16:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g93wyvuwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 May 2022 15:16:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iku2N1Z2VNkx0eJgTHFNbE/Rt6QIj6xGq7bFqBMk4Cb0hWIDpYw35XN5ePb5wGxAHs6P4noehP8R+oXelLeQbWaCP6jhoNNw1m3+CK59pvPD7sz6JTzu/U8oKFsTXuoBoKNdSTfhywJIxhaAqbQqLU9+CpuI4DrfX+e3t+/aMgxIRRjH/LvHbRy8G4NdXWnla6SMOypmiSEiJzTU6t5iqv70k5ivelevm8KyyguUrjCWV2uZIBB4lTfkWkkGJEpn5iYgVDnQ1uk42m5eoH3E8EavDFX/siQxEsoL2DoRSSurQ2qBzks3VthxDeTzVM4gWCejhY6LQIRyWnGKHluk2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sj++m39XlDeBtPngBI02jXhSMgwN7aJ6y47U6cYSPJc=;
 b=A0IaJJZIM5Nx06lA2rhigEIBtdk6wSGzAGHt53V3rW4kD+OULtskTi6afqkTBwueXgZWknnclaylBimyUT30JEuxoXZH4xbnXARn341na5iq4eK1dNc3b13mSyvOvhknFlm0waP+0Pu3W8tuRlNBLOSZww2pa+AEm6033Z3iNjtnd9aFMSb4hUdcy+K15rhakW9t+MciUM5zLFvNTzSuj7vhxdSAEr6/3jjF2zxufUyRmUdwrA13wKaHk3HN3b5PoZL+n28cmkcKvTXwZypdZh39nB/KENDmTp7Bk7Wdt5OA71j3l9kWRYVa7I/3LBgCtc9dkwtgKwM1tiP+oZYF2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sj++m39XlDeBtPngBI02jXhSMgwN7aJ6y47U6cYSPJc=;
 b=abE4njFDy2trJyR92bsYEIJrkOcYX48FUUAdxlzIf3EV/XBUcAw6LFCVAIJwCw8niiH6DSN1Nut8RJr4uZ1Txb//Mqs9dzVhYbqWcbEuTDS2pmzLKbb8XFJjK4MyEN7ylJt/3WiBzUasgEK883zAowVcGEWt4BAdXrTP1jaY4sM=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN7PR10MB2707.namprd10.prod.outlook.com (2603:10b6:406:c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Wed, 25 May
 2022 15:16:44 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5273.023; Wed, 25 May 2022
 15:16:44 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Chesnokov Gleb <Chesnokov.G@raidix.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Topic: [PATCH 1/1] qla2xxx: Remove unused ql_dm_tgt_ex_pct parameter
Thread-Index: AQHYbobah7S1K+EECUWb/HaurQb5x60uVaWAgAFZBkKAAAkogA==
Date:   Wed, 25 May 2022 15:16:44 +0000
Message-ID: <06B14F66-F736-4A12-9D47-6AA4A8920DDA@oracle.com>
References: <AM9PR10MB41185ADE95B92B4E6926BE639DD49@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
 <5ED96E4A-08F0-449A-8A9E-034BCFF1C993@oracle.com>
 <AM9PR10MB411874ABB2FF82B263EDD89C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
In-Reply-To: <AM9PR10MB411874ABB2FF82B263EDD89C9DD69@AM9PR10MB4118.EURPRD10.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a204f4f4-4cce-4bb7-44d1-08da3e6193f1
x-ms-traffictypediagnostic: BN7PR10MB2707:EE_
x-microsoft-antispam-prvs: <BN7PR10MB270708EB9DAE03DC87833B4FE6D69@BN7PR10MB2707.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mVTpPbm8a9gH55Fjd8U80ZcuIa0ZrQuVTaRIvQhJNbdSPTIYTE6ZqNMic/l6UU1Q0uyq4khpdcOKbP0/8B1IHnHwmCDE3/UFydwzyte3FMI9TPszZbmFw2syn/p5TynJsfH9KYIlYAMJrV8THsy5JYFLojqtOQeiUCQE8reov2f8iuxvqB/TkYE3L7/dyhkOdKPyxvr4e68gURfYXKLi2P+cSS3Lwiy+dHyGmw18XTZM4ARh7ikdMjZhPWJcdB2hg6jTOCwlBtwqJIJ1HbyLEZwXzPvDzAmQUvYWYhA4MPrMBbFyzWUtSXD3graM2QXD3hxh4sVp3Swu2NI0H8ghBkGB+im9/AUXFQNueJcBtlcm56bBgnlsfpDxMJ8HgkzZz835S86i3G17s9/1kx2jZi1hcJenZxl8i6yuQvnjsloby1dlHnsYrd3qbD/ZxNXuH3dbPuHTvzc/C6b/eqs8PVRAU4lWpgxYrD30PMxbijEg/NqDjIPde8z9MWUSR8RrY1FQJEVb3THj8BTulH5inX9Yma2RA6Dap10JGhoJ5R4Wg8SLutI4JKGFQi5eoXVZ95qzXoLHE3c/PSXKJAerqEEnz+DAZ7zMSHK39p9KC1qoVmxu1RvlWkDIi6qRmy0YVkMfEz1SKHYslAfTkJEvppKDJjA8KblDN1cgCiCBlb4zo3AHDc8rWMNb4QSdUYwm9qRzvVHtIBCDhMrlXDyu0ygMZR9Q+Lvpz5n9AZmtCE6aSC/fFoy2F3nBIR8xxy7e
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(44832011)(4744005)(6486002)(36756003)(2906002)(8936002)(316002)(86362001)(6506007)(76116006)(91956017)(4326008)(66556008)(53546011)(8676002)(66946007)(26005)(508600001)(6512007)(66446008)(66476007)(64756008)(38070700005)(71200400001)(33656002)(122000001)(2616005)(38100700002)(6916009)(186003)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lbrzTzbevXmkGiSNVsV2YHMzYmWKo6HHbHeJl/CoG0ZCNzNvZw8LseLMb2he?=
 =?us-ascii?Q?q+/poMJO1kJaidq1/afgIDx6fbzfPQbKTBY0mFpFbI6sgARk2vxzABKEuv4O?=
 =?us-ascii?Q?KnSTxYzjLDnYk2y1uSM0q+47H+RFDYrLnyTUkwOLu2gVakTBDgWQsdpvwuvS?=
 =?us-ascii?Q?hsIX3OYK5U+fyDwGe8mYWYnGpsgefcyx/WhRDBfgU8QRFd6e7oKVEjDjogCI?=
 =?us-ascii?Q?uNDRDR61iLQMbTzuPnmRiXwNIJ/La3thkfgqELGM9nTpD+Xw1SyddubzHIpc?=
 =?us-ascii?Q?2Pji6TEplASTYpBDd3gxuHIiBVjZLc2rKycD/pKdzalCKfxMYBHngcuppc0T?=
 =?us-ascii?Q?YUidYfhp2AzA+JQtSRaBHG/IujGKbpWfWFLpGkaUjTF5ABtAU+wGtnv0ADy5?=
 =?us-ascii?Q?hAgP3JzK1yKytypObazMNJ6P1uzTKIctIJvUCWmzzBm8XmtiQT0OINwcd3Js?=
 =?us-ascii?Q?l9UNt4AfqLV0ydiIRrJejul+J6plb1oJTkXy1oPAhkhOROUCD8SLvGTRYv68?=
 =?us-ascii?Q?qBpzewejDFz+Q60w7BU4BM7e156LRBj3q27Awh2qiaJo+KqEyOmUH54e6U2R?=
 =?us-ascii?Q?mQXVudn+x1/gc5MCgd3xwXkOfNog9/7BWZPEH4omLr6vhpkDcK33njHCjgJR?=
 =?us-ascii?Q?X2QovQPPHPrfqPf4oucnZTHJbChM24/68Zu50VrFnyPtIhO55IjFwRjM9zwy?=
 =?us-ascii?Q?KJ7llWtdZQjcfYQWQo8G3PWaXZpv5M83Md8I0Z6GmekzUwSZ5Gr+3pv3fp6W?=
 =?us-ascii?Q?wMqeK9Bz1XFB/LaCAmsllxDa7xsHB9LiBDBo9OVohzPoGHSeAT+H2HOmcNSk?=
 =?us-ascii?Q?MFajpcmX9xsPeVv5X4sUNggnLZkGs4dqIBl0LiyRtvB2QQ+zXYwS46NdGWo2?=
 =?us-ascii?Q?F0ZQsNRFSdlBeqDK1JRzSrE45Lc58dsFIZQLG23buD0HyK94i0koQnZGBXd2?=
 =?us-ascii?Q?tWGc3dFMwhSoQO5Ig6Dah20w+6PXDMAjGxw3eUXN6c8JIrIx4criDGyaAAiR?=
 =?us-ascii?Q?QO/SRjGURbuc3+hQsWqEhvh7zpc1rXM/82rxuCvSoEUrqeGhoWiXsIhrS8NW?=
 =?us-ascii?Q?CWpxzbYmwupNh1vuQg4hBKpEom1b3E4uExJ6Vvlg9BGKLcLSZfNzHf/0/g1K?=
 =?us-ascii?Q?uD+/NdXKk04P4+RJJtOxiVJOKDFyJCTNOPbRUaSIDVSAa5rlpzM/8WtgQx/n?=
 =?us-ascii?Q?39zLGc1FGm1hqN/8y4LXVS80GTaey6YLGmwbueqBgAW1D7taiKBxcIDxsaHw?=
 =?us-ascii?Q?K8vbAzks3+ILmEpPmHln4b5cUi0c2Q+gkbUMH3WE/g5J0ZfPptKX0p1Z+/Pq?=
 =?us-ascii?Q?aWUsILKBRVL5MJpIthFsa8mrvS1YQWRvGN2SF1/tK/nCmO6CB2aVmSoE93lp?=
 =?us-ascii?Q?Kl8fKhyMgUX7E219e/I+pA2tfMXPB09m76+58O7iL+cf+6slvla86PSRkeIs?=
 =?us-ascii?Q?5ZVCauS6KENWfKewHCbsAzIwUXKBykN8V6SuSRmkSikpCN2ejsJzNSjOjVgM?=
 =?us-ascii?Q?JETZWe7ue8OgfxgaoN2DjwjCqSMqo3I6rHMMsyNvidbAzRXYau5DR91Jn74V?=
 =?us-ascii?Q?pcuRAp0CZqtnzhGQVMKBIcS69qQweF1x9kaAoSQooMSKnbgOEAZ+R1S8Zahs?=
 =?us-ascii?Q?mcA9w/BaOd1bwcROMHyd7E4mL6HFFfkkkbzBgIgS1go0B58YypOCyYLmjd35?=
 =?us-ascii?Q?7jbZwqYbAkK4DkEsnv7OzV9iKAKXGgI8Hv13b7Ay96GoSIyZ4n0F2KiodY4Q?=
 =?us-ascii?Q?zEhZMwJBUsNgI6V9nu1W/H1wX7oKfN+JY6nwV1nimewvnR7xczWt?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13C81121B6F14840AEAE15F254C8E925@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a204f4f4-4cce-4bb7-44d1-08da3e6193f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 15:16:44.0846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /YHZsvH4RWDXg+kHujjD0R1B0teJ4y69OypgpyUStt7AYVFkfboCmVplzFYiN0eYjDDrevcYsQrDTSTDR04FlFF5Rb2yt3+H2J6Oxge1rHk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2707
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-25_04:2022-05-25,2022-05-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205250080
X-Proofpoint-GUID: LzmIex9gRPx5bxWdHiebzpgbGYgV02MK
X-Proofpoint-ORIG-GUID: LzmIex9gRPx5bxWdHiebzpgbGYgV02MK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On May 25, 2022, at 7:52 AM, Chesnokov Gleb <Chesnokov.G@raidix.com> wrot=
e:
>=20
>> Once s-o-b is fixed, Please add
>>=20
>> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
>=20
> I'm still newbie in linux kernel contribution, so I'm not sure what exact=
ly I need to do.
> Do I need to resend the patch with fixed s-o-b as a second version?

It will be easier for the maintainer to pick up the patch if you resend wit=
h SOB and RB added.=20

> =20
> Thanks,
> Gleb.

--
Himanshu Madhani	Oracle Linux Engineering

