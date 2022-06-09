Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B741C43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 17:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345057AbiFIRmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 13:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345072AbiFIRmW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 13:42:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE19E16B2E1
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 10:42:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 259Fj39v023327;
        Thu, 9 Jun 2022 17:42:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=m8N2lour2pNYUKVd+esa9t4wmOwcKBhkLCSK1KuBlnc=;
 b=aYsPXmHkHxAXI6uQzjarcDjT/GnKn8UP3KzqlZKGsPpv9vQwgZ1BKiLTV/J9EsTh21zj
 97zZMKWgPEziplBvOQ/kYLlq8ucZlg8ehHKNQvWvZuVjA9w/o5z4UBeUgnJnMUahgkMv
 9j+h9CCCEPAi/p1Xcfjh9z6IjWg4/12UslxG0848XQstQbVpx/R3RzIrw+KYO4x4LK6l
 iU6E5oswm9tz8pLvWtLK1xGE15MCaNEjCFjv4NLe4P7hpnnIKPoO3IE3ztd5A4rS6fZB
 cD0wqjQwg2r7SwCJZhr8/7fB6QHdqMPXqsgMEn6pwtPVotwLgeY2WLWlyT4RhpiKhubO gA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ghvs3f486-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jun 2022 17:42:18 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 259HQG7E021374;
        Thu, 9 Jun 2022 17:42:16 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu4yaq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Jun 2022 17:42:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YDdc8+66gZTrTpQO4LpDSThfuLVN4qa+OKnuDEukP/Z9hJTu2BCydJgtfXu6TFM4rYUdoNQJoh1I4pH/VNlEz2aSyrUtWueFGDTGkZ08v09bXBfTAUhsSjOCUiqffPdhERKvAl9Z5lRDVUgo9FgBMRUk0bNsRReDQ0tGQYBe2x6pT8B2R05AZsNT7y5a17ydcIiA3EOQO13EgBI8GhFKNE/sSR8lSRxF90Lt1CXUk24GI3JDARhICJ499Oh+lqZMXNbIp9DM7DbC3aOjQ6iILG5O8ru5iDYulVi8tMtGdc8roF8MnF76JS/jvsbluRkP2W2WFEGDlobkm0HsippoIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m8N2lour2pNYUKVd+esa9t4wmOwcKBhkLCSK1KuBlnc=;
 b=L5wuUnerPMRP7FkgidnWuuR9zC2DEYHOXfocUOaGudVZ+A7xfugV1p87vGZN28cH68zAlDp016whvhz+yePN5hxJm+UsKCQFLXzFJTmDQXfQZtjBd5xa4HUbgtWY231Zzqn7k+POCUO34T3oXyWaZFRjYiwSTq1OeQFZqk0KXfoiCNz2gd1QX+NIHWWkThb6lWIZEaYq8QahobQAHQzp34WZsMJRBOYy7J2rP53IpYjR77XhQ7a99xIu7/Ni1tXLFftlhFXNyPpGoSwQUwJ3a7Pd3dltHHfPct9tntO9rUJrjPANSy+FHwovTy9V+D1FeYXKLSOoOYCzdwLaaxCSIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m8N2lour2pNYUKVd+esa9t4wmOwcKBhkLCSK1KuBlnc=;
 b=KnSETv3AOXmhblDssgxlOsvX64nq+0V+cbhl79minjJvptGneSEiLzBsJfe0aFv0dyId3BH6hfO7AZUSseTlmFlEK9p3aB2mEqU+CyqnVI0tKwGgH/8U+vbsKOoLy+cb+8i/pGTGfan1vHt1fWOs6eH9oJA4pOu0H+0+585nOR4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BN0PR10MB5382.namprd10.prod.outlook.com (2603:10b6:408:117::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Thu, 9 Jun
 2022 17:42:15 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::ccc1:c080:5df4:f478%3]) with mapi id 15.20.5314.019; Thu, 9 Jun 2022
 17:42:15 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 00/10] Additional EDiF bug fixes
Thread-Topic: [PATCH 00/10] Additional EDiF bug fixes
Thread-Index: AQHYey9juG1U4xHxf0epDBC9jbKLr61HWiMA
Date:   Thu, 9 Jun 2022 17:42:15 +0000
Message-ID: <21B5E58A-3D54-4ACD-B28C-DBE29D4E2938@oracle.com>
References: <20220608115849.16693-1-njavali@marvell.com>
In-Reply-To: <20220608115849.16693-1-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 181ddc5b-3d76-4cea-47bd-08da4a3f6435
x-ms-traffictypediagnostic: BN0PR10MB5382:EE_
x-microsoft-antispam-prvs: <BN0PR10MB5382BBD90E73E036586C087DE6A79@BN0PR10MB5382.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /8PuOhmVunavMHS3ofIdz4tHupWzr8HC8g9IVEqSMthxKCxAEeqzyNcYLt3EWfkmgCu752LycoERqM/AqF/cqgYY3Trjad5J+11rGudC29UcdUHt/Kv7/IoUGcr0kXwprEy+z7MO8vGgb9aFnv2DTuLXGeqaUn1QI8jnijsaI/SagmqdckjBJ5jIGPL292rAWze1GwUN/v4VvcsnvbHzF69nIHzSiexg6v0W+24plKHU1glrc+D8v6YJczGFfd7XponhHSjnk5Gs+xwZx8nrFlUdH2Tn7r1/5uQvtmF7Hbkh4j/9jgwGXeuTmhMq87LLpAURhDV7oVORqB6/hPspBJjl89o+AnNgrL7XoXnUi20JwZr0bfWOe1FcJj42gzTms4ZooDPpWM3Smpe+BZWxPZZGJvRumaDQi5nU/EX7/xIlV8AvBWAVujL1AmQDfVXPeaadp14B1hoaUE1/GlJxcqtFp+SVXLGhRoa1U76oPxLlz7UKDZrnJxjYwKsZ1ee5ZUBrLPK7NbYuh8SpEK1xuY3JPyL884Hh7wVseG7/yzObHz261ySxaub1Hb6QjptqvD9frTpt1sOCjpnoUH3hsH8qKSyUBPjEz7+B3DJtNUyZBkHjAAncWqcT5I0c1/Rr8tbuSyLu2k/THTZbVZBnQNKK/Ylwpx1i1nH8i8kfQNQFc3mhTbBfATIRAng02unCcnfqG0T5YqHpB4gJpZDNZTRe0DI2Kplpdd4qqngiu+LmGovSAsyciTwn8siCHzRx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(8676002)(4326008)(6512007)(91956017)(76116006)(5660300002)(38070700005)(44832011)(8936002)(2616005)(122000001)(26005)(66946007)(66476007)(53546011)(86362001)(6486002)(508600001)(186003)(64756008)(66446008)(71200400001)(66556008)(316002)(83380400001)(6506007)(6916009)(54906003)(38100700002)(33656002)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?LP8Pq25rgxng0uX8OJGbgd+vAmU8B1TOTZUUKODALEk4KhpdcRDA+1dQsxLm?=
 =?us-ascii?Q?9CHyUV1fCSG9ZVCWoNcpC8YfhHUVS2l6eUzVRyjjTAth38h0oMPjY7fVjYIj?=
 =?us-ascii?Q?X8N7Euczt/fycKuSqPNUSA+9dqCRJMrckfCsZJ2P7uUjOld9032lAnkxBO2m?=
 =?us-ascii?Q?vaglJL6P7qSob5Id5UJ1RLWR0t4vdPyobYgv8onyDt5rOU13fc1Nf4tW0uDE?=
 =?us-ascii?Q?jjwzFsOH6yp7vswgqSYOGZq5F9Yjh71rp2W3G5a3NuXdJlAYBZOHz1T01T/U?=
 =?us-ascii?Q?bX6zWXXDJburKgjrjkNyY1CAOrMSkkb/t9BhXJmIIS/36K45g4qX9TFCxgxX?=
 =?us-ascii?Q?cs63wFRUwJn5fgzOtwsxSXSMeF95y06B3wai6m0j9kPmr20f4Hd8YhoOn07R?=
 =?us-ascii?Q?pVB8adnp9saOQ+LsUEHEyvG/+wrs24xpzXyAjLhODQDlRsLU6EbVtQ1LtLyH?=
 =?us-ascii?Q?AQLx3HOi5fBPVajG/Lkaf5dFjRk8coaGmW9d+oaSAaTeiegSsdZtwmXa5yC+?=
 =?us-ascii?Q?gyK8IHIW4jSbNCfdA4U2Lw/D9zTk2UiFN6w90/X9zQyFP3sRJbfWTiB4eTzG?=
 =?us-ascii?Q?l3UaynbdOOOrCvz7KjL0N9As6QuyOTSCSlqb/3NxW2a+kcWbtwCcyTVddA5i?=
 =?us-ascii?Q?momG4p72k5U7TByqGDypHwWsWvlYbZoSV3rEJDRhrT1JYbypS4gon4pHjV5E?=
 =?us-ascii?Q?6O/phts8Yhg/rolx/YyFnYGIydgYf+PdNbw0tX+TgW8/bdyvReFjmKqerC7S?=
 =?us-ascii?Q?PKdqE5RrjiL6EdmM9ZXP7Z39XQnvICirenVCoMqBke8JOtZ2yDJvlA/7aV/M?=
 =?us-ascii?Q?RhNTXzls2x7nOVh1VsWF7IpwOCmeilVEJK1avR2KcKTvnLqvejHH2A4zKs+7?=
 =?us-ascii?Q?2RITP2g95rb8uKfNmGzmbafuOvT9EjxF1FXHfyO7GKpdFngPM+aezrrs+bIR?=
 =?us-ascii?Q?6hDWN6aIATeaHCqymK6EpqoS07m6yAKwomz75gw9i1yuZocZfviaPTIHKtin?=
 =?us-ascii?Q?pOJQnHOdjYL7PY5feJQI0mGLJTzp0pAcX5LYgIH0XTfpXg2v2wnP+XeNUj+r?=
 =?us-ascii?Q?JWd0+Ahev1J4YxuTH+D4BY4JJa/3BV2v2sZi431s2puOjSLp/rxdw5baFOsG?=
 =?us-ascii?Q?BWlixSnmQau1YQ7aciN84Y5d70sGOHOVMHyzqLRc22tSmvHyujNerUyOPvky?=
 =?us-ascii?Q?FGijOLHGsjm/oR/Iv4fjQuV8Bec2e1sIRGgWwcXXvyIFxNB/1kaBWtJstl5z?=
 =?us-ascii?Q?0A0idJ/8D8PFYgibUcK0sn8BeoUy8MT6DBZIePmyfTm0rFkU5BXUf4fGxJRr?=
 =?us-ascii?Q?CpkYR2kDh6/E9KD89c+BMgxZEPybTO4uFn3jzf1AQvxpu5TXeJiPkHNL5SnZ?=
 =?us-ascii?Q?Jga6U2Af8uqSQDs0L+avSO9wszaycSK6O1mTs8v89+CCjZEEuAanS3YnzViC?=
 =?us-ascii?Q?kuWjlJvqS/1qcr+RadQRA5u1iRX0yememTSgfTihtCH+son41rXrBDFhrE0a?=
 =?us-ascii?Q?sthHpl/G8peanu++RQOakv5ylY1gsFJusKaK1vkhdrHRyRkbW7kkHbrW9Siz?=
 =?us-ascii?Q?06w0Aviu55/WKhyr/yW8Bez5v1Psa6Hj7LTyWFMAN1K546yGJ/TJUt70qFuS?=
 =?us-ascii?Q?P3jOUFPRLrd1WMBnQ2RvPNzuBDpMeLdD+j/wDtpRU1jRl/btJq56JNP4udv4?=
 =?us-ascii?Q?5C0UtXCNEtLpFaNhUIjHohvuy+3S8wlesq12B3XZ9fgq2n2qvcXYQ//r8RUB?=
 =?us-ascii?Q?yFY8YZ01r1hnwFS9bfhS0caZph1+DFykaFLE8/wWsqBZoEXYzNPv?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA6AC6C03E644C4C9B18B4323C2039A1@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181ddc5b-3d76-4cea-47bd-08da4a3f6435
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2022 17:42:15.0798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pcGG69lpxeigh5XbXQ+o6kH1BCADntrqopKiBf2TTl380KGFLHZMYnBWZCrgY4UeuzOmFUnQod9MUmztKXwLX+3ZrmTUKtOe7+3hCWG9xb4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5382
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-09_12:2022-06-09,2022-06-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206090065
X-Proofpoint-ORIG-GUID: CPBdjUOsNtdlx2GIMCq60SDua1xdtN9K
X-Proofpoint-GUID: CPBdjUOsNtdlx2GIMCq60SDua1xdtN9K
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Jun 8, 2022, at 4:58 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> Martin,
>=20
> Please apply the qla2xxx driver additional EDiF bug fixes to the scsi
> tree at your earliest convenience.
>=20
> Thanks,
> Nilesh
>=20
> Nilesh Javali (1):
>  qla2xxx: Update version to 10.02.07.600-k
>=20
> Quinn Tran (9):
>  qla2xxx: edif: Fix IO timeout due to over subscription
>  qla2xxx: edif: send logo for unexpected IKE message
>  qla2xxx: edif: reduce disruption due to multiple app start
>  qla2xxx: edif: fix no login after app start
>  qla2xxx: edif: tear down session if keys has been removed
>  qla2xxx: edif: fix session thrash
>  qla2xxx: edif: Fix no logout on delete for n2n
>  qla2xxx: edif: Reduce N2N thrashing at app_start time
>  qla2xxx: edif: Fix slow session tear down
>=20
> drivers/scsi/qla2xxx/qla_def.h     |  5 ++
> drivers/scsi/qla2xxx/qla_edif.c    | 80 +++++++++++++++++++++++-------
> drivers/scsi/qla2xxx/qla_edif.h    |  4 ++
> drivers/scsi/qla2xxx/qla_fw.h      |  2 +-
> drivers/scsi/qla2xxx/qla_init.c    | 10 +++-
> drivers/scsi/qla2xxx/qla_iocb.c    |  3 ++
> drivers/scsi/qla2xxx/qla_isr.c     | 35 +++++++------
> drivers/scsi/qla2xxx/qla_version.h |  4 +-
> 8 files changed, 107 insertions(+), 36 deletions(-)
>=20
>=20
> base-commit: 3fd3a52ca672fea71ff6ebaded2e2ddbbfb3a397
> --=20
> 2.19.0.rc0
>=20

The Series looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	Oracle Linux Engineering

