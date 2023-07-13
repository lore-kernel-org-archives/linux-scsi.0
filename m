Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F675C0015E
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 19:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233149AbjGMTfB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 15:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjGMTfA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 15:35:00 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D95B2700
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 12:34:59 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36DJH1lV025179;
        Thu, 13 Jul 2023 19:34:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qiGdwKduLC/h2t2YiXtR1PCisnny3bD+WuFUJ72UvXI=;
 b=xdco1vSdtBOz+dkmSvGSSSmIsSSYK2gzg+UF619Z3iOxk4xx4gdfUSjuDiPVbJbGYere
 /pkPjgVQJHiXVWQnJYQkXY8bYdtvrcTcrXvGNZfvamWd59IWtlD8u4ThXdd4QbRlYFq5
 K36iprejvMmG3ugxoNXVnkFjHCZmV8XzEawOYfQqVotd1TE7a+QXoTtqN5R9XwTU/O4K
 xl0xwbEe0OTULS2kI2woQ5mKM8if7BTSKIWU8qav+EgqI7oVY0VrKtJOw5Q8pWPBHKVL
 7avxZXItmcC3CKkN8/vbgzPZK+hg2DckG4MkVzjRgfGxEVYkLw2AzE3AnMo8A3VFOMHG KQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rtq9t814p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:34:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36DIne9I003237;
        Thu, 13 Jul 2023 19:34:55 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rtpvxsn4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 19:34:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEQvdgAQvGNQGid/9QcV3vPIpVXXu8AjyVWw3TD6EeNtFEBtoO9NJKuX1fXaAk2RCZKhgJ8QFiSmRk/Nkk/ytjRoxWhSp3tlrrxFs0v7qGHISuRItV+M6fJy1vSYbb0h/NTjiXYbo1NJQ4QHt/FIUyIf0SOVz7vxH7QMNWU+grH/1ygQZZ8ZqGrI1u6b9wMpbxZom98UzxwRAUONeOQWY/xyBnBvZUT/Ezn9X93G8HdUg+bJisHEaYPxNhe7k+qwaAQoWyGGgOpTPX/DojsgBZ1ZPVFb5x7oKXCGG82SNXPFglYCgn3BQgM/QY+5VVyRpdIfYPcXy4/jkw9Y8orXGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qiGdwKduLC/h2t2YiXtR1PCisnny3bD+WuFUJ72UvXI=;
 b=kTaSzEh3QyVPpL7z7q9CDdHsmRiwe2L6iVcwQUvao5thscihKzl6/0rqjD3TurkVM+C73h8n3451G1efKtI53P5cud7xp/VJ/r+wzBneWHdL0tVm1WlFFY62YziXqo9iCCOz5F3z3xAWqzc6tb4AyCoiMZRk8N6WTq5tMsw5UnFLStS98FWlNjiG5JhWrh6l0kWZqszWYKczVg75pWCClL3qsKmv2ZKEP/4BpjomZiRKH4FpcjTCi1nGd4hlkln4pw8MJwVZ0H4OZ/4E7Cl0sfTXpJceeEVzVEu2Iz6YXkHWd/iJprM4JEuYMYdCOa7Rk5xKRH0g3awoqwVMLV0LHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qiGdwKduLC/h2t2YiXtR1PCisnny3bD+WuFUJ72UvXI=;
 b=UGEOlXz9jk7xnSxKDDKI/v1etC+lJXkkYw7GuIP+gEB49A5l4qPB5v2Omrrxy/l2C56W0Pyl9xW+a9RJuWNwwO7qmN3WFRqqAZsDlf4jgZ2PYD82vAhrUScIgavRVTn3CsH6RMgnaQovhHNFJWb8VgrDrSR87wop1NeXuapjXIc=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB4936.namprd10.prod.outlook.com (2603:10b6:408:123::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.24; Thu, 13 Jul
 2023 19:34:53 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::2ab7:3a22:b4e3:93ef%4]) with mapi id 15.20.6588.022; Thu, 13 Jul 2023
 19:34:52 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH 09/10] qla2xxx: fix inconsistent TMF timeout
Thread-Topic: [PATCH 09/10] qla2xxx: fix inconsistent TMF timeout
Thread-Index: AQHZtKBQWICPllmCCk6PWkZ/EKZ5f6+4GOMA
Date:   Thu, 13 Jul 2023 19:34:52 +0000
Message-ID: <99E98D05-541D-4489-84BE-9A499BE08C0E@oracle.com>
References: <20230712090535.34894-1-njavali@marvell.com>
 <20230712090535.34894-10-njavali@marvell.com>
In-Reply-To: <20230712090535.34894-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BN0PR10MB4936:EE_
x-ms-office365-filtering-correlation-id: 83842c0a-df09-4b31-70ac-08db83d83aff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DbWdCvAQ8wVjkTceR3vz2BnM7R32pLq44CU+XUNmvIghlhnD4eZDrNuJr1XAjV44bp0Clel0yos7kC7y1yYYBX0yGbkoAX/ac82tgIedhOI7tIj3mD6yWASRA2+2IyHQWd8KbHxP0J+chJvyVJ9Qi05XzdxfYSgwODwuWIHaUPCDPrXuGqDrqfAyOWY8/WxkhMRDKXwgLCZ797InIShpoPGoW3v9kVwDG2Lm/8apZqdCgnUY8SBytJ0YrBi2xk14PMFM9Iv0M2ktlFXrqy9CYyMXWPC487j+XAIpvFq3x3cWt8zCrTQbLdaqj5mgB9d8OMBs+i8lcVSToV90NpnMMq5lB4Vg6UAH/f0jdD+ifVa1Y3guYRJBJSCQG02Lp81jH5fuiDhbDGhPk1aT7lCFgo4ncC5BbXG9qaQEt2NWw2Ln94q4p75QMqRxXhYrFqD+wPiUcZ1vjBhu6E/OUdExON37j7RjjshmhMrtVsFGYs0fHU7zYDYkab714gencsePaYFUSk0h/aOkIRkRMAC7qI4hOzTV2Zb+GYKnrf9aLi7vnW/m26JuIGIn4VC758ufdljypnpIJT5GdzwPfnJPx1IVtZ+vJc/p3Se8GczNoUszMNuYkaA6M//3jw22BUSB8qLOXruYh6EWtsrj9D+6Dg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(346002)(39860400002)(376002)(451199021)(316002)(54906003)(91956017)(71200400001)(186003)(6916009)(66946007)(4326008)(6486002)(76116006)(66446008)(66556008)(66476007)(64756008)(478600001)(41300700001)(6512007)(8676002)(8936002)(53546011)(6506007)(86362001)(26005)(44832011)(5660300002)(33656002)(83380400001)(122000001)(38070700005)(2616005)(36756003)(2906002)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BPy+/i+nzLp/4liyQ6dAtzxI4Z58Zqr8DU/+XN3a2OLQ+rlxs3Q8qkZEz/9D?=
 =?us-ascii?Q?8W0T1R4UkDo4VHdPjTnLK+SgkehAfAc/aot1xILDD/Y/4e9X7Qjr1B0TwHuK?=
 =?us-ascii?Q?OwydW0f47S5Yc1iwb3oTA4GYa/r0wz9KKd1dGqzi9cj1XOULft61aHiYz7d+?=
 =?us-ascii?Q?xSLOsH5d2xSjryKIFokwkasfgW4LjrWwFcZgK2nP61Q/YGsokVGdPc7Dq947?=
 =?us-ascii?Q?H7Ox8mRHyQjuOnYQn1FQT8IKfYlke228y5q9cd3h0kl6fy4qa3lTdSKORUwh?=
 =?us-ascii?Q?gBIybnbZ8BeAv0/fImx+WyBplIYQ8QdHMlDcQASP/YpBgG7wXENTQVe8CdAc?=
 =?us-ascii?Q?aOPLkbo+yva8BgvwbeqimhCsGJH+l8j5bCLJVgxmR6cNuXQMy3/XJw25jq+W?=
 =?us-ascii?Q?Xrbun9MuypkRDx1QbptH7/Ef4uttmg0Ucf4mmqC0xG0A9qfH2wIUy3DG2nWY?=
 =?us-ascii?Q?JPgKf9xFdw3ahe1Rri2MIeYNFYL8SC3EVtYc96A4kzRoVBy0duMXgqwpHpdh?=
 =?us-ascii?Q?oAL2rNLIFNpq6DJ8vLJdkdEFJWhGzxozrIg/tZR75o5aQLZrVUi0UqmcBTfx?=
 =?us-ascii?Q?/VhRWFBT+4LvU8/a+s/S9sj1rHqrMg1KrLz7Uk1qdT9aB+i9aJpPu909aAdE?=
 =?us-ascii?Q?3bUtFpEPLRyeiTM5XDbmr63n1zq5Mko5WHEly8/Vj/IJykIU5ksKjt38fOpT?=
 =?us-ascii?Q?eGX6ynUi4jvWtGj19gQSTlkGu4Bm5SqORp6Fup1KKjo7qjIs9ttr+PtUcBuw?=
 =?us-ascii?Q?qYE/4TZ/7S4E9Dj4MCXrIkbE5JsmWcli/xSmE9uEAgCEmm3rl848urEEB1gv?=
 =?us-ascii?Q?RXKfXJoWl3Yo16bn45xmXnqcFNQyhxAgaOvjTTHJPigmt4cB1dExdWVA6g0x?=
 =?us-ascii?Q?y4wD9EDtymHJ2RLMSKjn7sq/ERMLQhjEYuIv35nYjHY3LYCgjtnalXnpeMwR?=
 =?us-ascii?Q?IS898DbdSkGhNzAg7OKbXvaFJr/oj6Gc2K6gRjs87A2nLvL4exQfTXGhctYI?=
 =?us-ascii?Q?PK4XGh4VlNy7gysxvFQqRLpoh2ytZM+s3D63dfTwBZPYT4HY0qgY1qFIxTmt?=
 =?us-ascii?Q?f3MuNm40Q3DtyAkrLQzW1N6eza152F5ZBezrpokAg+2cG5sSP8dvG4XpR395?=
 =?us-ascii?Q?B+SM57vdZmUb/lDuFmFVilEfLGGH4JSk1B4VXce5ZjNMGij/6Mp4mEs7wmhP?=
 =?us-ascii?Q?JzhMJ6hUrFJv6SeqpgPA2v2vWjgyorQoV0Oqu+gxaMwtpULbIN0ZZ5F+2MVg?=
 =?us-ascii?Q?5ycJBVzgwYSvDgROcNCsl2AdFapN/pskP0Wv4lMMk3kaUS8WZFwc5A9Wrx82?=
 =?us-ascii?Q?l3NOPduWX1SkYusXKmfrWzfDPM3acvWAVCTm3Y8ea/ONaOEfD6VRToKL2H2x?=
 =?us-ascii?Q?u05DI2PUBN286QmWX/1WAfstwZ1JK8YjCvQ67QMplgFadbV5mYMd3tKfdslj?=
 =?us-ascii?Q?EcqFd8uS1zL78s7KET3kxc/Y50zM1zF+4/TJ878m66GFo6pMyJtRBu3W0rrx?=
 =?us-ascii?Q?kGUmStLB5iBdvZsAgTsKNm5hxo2nJf9jvRgnJQ+9cikMTpX9qrCyYaDcBLWz?=
 =?us-ascii?Q?vT4usOg2lNB9ChUij6uNU+w2Y6w+6g7O4dmC2g2H3KCBVzGYVnzxN3R7O85B?=
 =?us-ascii?Q?fZKrvHWWuTrXqDhJM6sgdX0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <874AB662237A594C8F47C46398528132@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: V7eb175Pk3EXoYa0T125E4DozX0PWhkejyRamGwP0SJuYGjTgHYg57ZXilp5iz39gNHMW/J8R4W8Ki0BH5qoha0tr1b2IUa1/Q3mSIacusrFV6wRcU5d8r/RQQaazAokLioGXxpY2dgkcVzzWWJtF2BAKDrTHDkhUrK5jVkMVW115wa7n/HLr/QQ5A3+lVX+R5Wvq3FxLUVxBoLdwQlG32uC0Z/mc5EeeK7ybJTtD1EaeWIOk/oAYMCvrzvzEJe8RgsJJfT3bSXfILXLg6yzUbp7e9kYGCFq+IV15XZr/+/HbUwVGtAdIKU5ixFQcATpElnqNLaRIN41abX2bBSrc6U5I4cYxHQf+TFP3/swFDYYND7Hln8g5dWYDvuvKqCVlI8OafRmCIX3cQb4fZp2JBgdy/ZnvMYpGZpF30h4AFxmP4O3mhE5S7rV039veC5fzjfJiS7Ebv8M03eL4Kj3bpaLpycsO93RKkdthfii5OBOzKD0kUTTrUQQVr+kIyZ4v+kaor5vFwzRoaX2wPVkxjv9IGAivTAEZsZGZ4zVXgYphB0GX9RlJRvSrf1BCKgInFlLy78UqlCYS5s8B50k3X67NQEKhZ+8fFazoFquHytR5HBGRnf0MzfN7on1xNYFx6O8oVUKQaZr1KuxJOSNhr6CwyQg+1rRPHDepRaZmGOrfPYHGX2U/qrv3n/J2AJk9UE4+AAx2yZdGFOVnLKjKLvgEf2lo2yB8Cc/PAtl5/d76K7rpf0gxsQ05DFNHobmflNkTAfbfHazIPLiSoQZ2M4Wa+A+QCAwjlxlV04Y9BM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83842c0a-df09-4b31-70ac-08db83d83aff
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2023 19:34:52.8742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rpky+bSSSrIyrp9ZjuII9vnt8Zyw3CIqHtN9h2fVG6bVmUXXA66TFeYsqNEVDwnn26FP3KlGE4WyPkOy/6Xsr9X9f9DWCsbEEfPf+AViJ9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4936
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_08,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 bulkscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307130172
X-Proofpoint-ORIG-GUID: TdbiRD-FrUqxOd3Nr3z8visZ83CSuieR
X-Proofpoint-GUID: TdbiRD-FrUqxOd3Nr3z8visZ83CSuieR
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jul 12, 2023, at 2:05 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Different behavior were experienced of session being
> torn down vs not, when TMF is timed out. When FW detects
> the time out, the session is torn down.  When driver detects
> the time out, the session is not torn down.
>=20
> Allow TMF error to return to upper layer without session
> tear down.
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index eb8480a0d7b0..aba39127474a 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -2543,7 +2543,6 @@ qla24xx_tm_iocb_entry(scsi_qla_host_t *vha, struct =
req_que *req, void *tsk)
> case CS_PORT_BUSY:
> case CS_INCOMPLETE:
> case CS_PORT_UNAVAILABLE:
> - case CS_TIMEOUT:
> case CS_RESET:
> if (atomic_read(&fcport->state) =3D=3D FCS_ONLINE) {
> ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--=20
Himanshu Madhani Oracle Linux Engineering

