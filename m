Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9D3C77B61
	for <linux-scsi@archiver.kernel.org>; Mon,  1 May 2023 15:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjEAPH3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 May 2023 11:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbjEAPH0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 May 2023 11:07:26 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C39100
        for <linux-scsi@vger.kernel.org>; Mon,  1 May 2023 08:07:24 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 341EJCAn026469;
        Mon, 1 May 2023 15:07:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=XMc0s3f3aa2/GkIuTQLDm1ELjVF3bg9DKBf6WwIhDx8=;
 b=jW0AMYFkX3LPvCsLIwJY9ZLT46oc14sZ9tVbxgUuD4pharlOX2u1a9IqPdO0Hvj5OLaR
 0OMWkScbHh0zLyOLPh1brF5myySCJm78Celg2iDYQmeuexTzqzm6pn/q+rTdu3L2MQYh
 w2YW0YttWn4SEJ/2e6GVZAv2XUcL287QRySqGJqdd6C8q2HOZ6tLNVX5cL8SorQ3VIaV
 8EBySVFH1yge7mrJVEjbaBmFkP44iRGSzDGGTYzY0jY2R8txIFIzNwYWXRbFQ2Me1Ruq
 oz59kIzXjcEl39mDsLIG/mZBt/X7JzsLv/eG8wl32/G9jA8t86gEJ9WXyMIf9VsiseCj Tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8t5fjk99-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:07:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 341EEOu5017761;
        Mon, 1 May 2023 15:07:21 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2044.outbound.protection.outlook.com [104.47.57.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q8sp4j7sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 May 2023 15:07:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hYEIAAjeL1YZOoCJRicde8kF5gWFuTRDQ6V76jhGAjUkKV5vcsgkN20hb6ADoHVIPoFXPtLYLlVxy7AAaImbP2fnpcGBnmcdECYVbLHZ2s7brg+C6poap3Snw06LRpgV5NFhUEKHny/brbH5Equ1jY2Nnct3qRnSUfGoKR6i874bL/Jp7xEPJF9kjnZoE6haU4iR+nrL+uRLEQ3ipC7hQxFvBpNsVjGajGHjAHvtH6UniQVUpnDGrYdvBXC1hQHEKPgxmgWVcH56F/YERF7aAV9RmlWbCFVBLUcGoxnCEn/KoJzAq3NWDW0azNuKdQlrQ8aO84mi3n0Ab3iNSVC3QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMc0s3f3aa2/GkIuTQLDm1ELjVF3bg9DKBf6WwIhDx8=;
 b=dguumsR1N8agJxOyQpAQ9ixYAueFujnO9dmO6iy1BVFdui4eH3A7UTf4csDkCE/8YwGXmShBXUP2exS5x64GGgBD8N3NZhkzgwAIv7put7QLIEqiR8hnftsnuzYn8x/ZzsWKIdi8AQYCyN2+2blaiPqJZVheX0eezQYqXKZf8T2Do9koOWnKOYRiTRjETp3IpV0UMVLD8NKlYhOZ7hYMwKknMrrj/UoHw0yhgPIckKCDCfTrMbUCWqZehVHJihOxKdXFl7RPQFY7ojRgFgLtPXlFLD1Esr6E/KZU1rHE05Y7L8LUfwCTm7nDKFrt62K0uRP+dW+YVVp9qb6ZbaxWBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XMc0s3f3aa2/GkIuTQLDm1ELjVF3bg9DKBf6WwIhDx8=;
 b=HmCR74KsL2764QXVFCv0mHrV7zNs9ly50aVAkTfUdHVQIE27QcT/Vey3nGXzJp0g3Mz1Y3fcc+2GcQOoIFvEfgfc3XxwRbtXjNTUPcKU4s1T2+ezZ/SUC91NtrPCIGFbQ+gOrXfXxFZh1L/YLjOH4IQnNpTsc1qh3GdC/uTcxog=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by BY5PR10MB4340.namprd10.prod.outlook.com (2603:10b6:a03:210::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Mon, 1 May
 2023 15:07:18 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::195a:41b1:6434:af74%7]) with mapi id 15.20.6340.030; Mon, 1 May 2023
 15:07:17 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "bhazarika@marvell.com" <bhazarika@marvell.com>,
        "agurumurthy@marvell.com" <agurumurthy@marvell.com>,
        "sdeodhar@marvell.com" <sdeodhar@marvell.com>
Subject: Re: [PATCH v2 2/7] qla2xxx: Fix task management cmd failure
Thread-Topic: [PATCH v2 2/7] qla2xxx: Fix task management cmd failure
Thread-Index: AQHZeaauPKlUbNIRH0ClqPL4DTHlB69FieOA
Date:   Mon, 1 May 2023 15:07:17 +0000
Message-ID: <2B1FEAF8-BED4-4851-AA1A-17DDB71E1887@oracle.com>
References: <20230428075339.32551-1-njavali@marvell.com>
 <20230428075339.32551-3-njavali@marvell.com>
In-Reply-To: <20230428075339.32551-3-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN6PR10MB2943:EE_|BY5PR10MB4340:EE_
x-ms-office365-filtering-correlation-id: 538f7ab8-82a4-4da5-1786-08db4a55c150
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AKZvG/uzAW88ZKZ79m1PfzIr9NwPIsS0Eyu4JaX4j4b/wNCSNkwgZ97A70jyp/5NuUvS2/6vUCPlBsseTgEs/Itb8RyUfSQ2LP9x7jXHSLFcFCDC4iImB3NJj6HkU4LBm5C1oOMquF7qfrT1DzCnfXpOm9WiT73jSxuXMOYtnlEKT126EXE9O9JWIop3QPXBWV+3kHOP7uwORCdmxxbhZPrO0OkgAiMf6qiXt3PoaYK+2Y5m17rN+nYMPseZhZz2MazRY28gnUPuyqNjSHd3OmoeQNc4lzFBxI+Oyw63OrSFraj20qL5W9woOdBql9lioNMKL5ZKc1toIUrtqlJXyLu0jsRV+jVhio2vdHfLr5Pzu+VQ+jfGtVIcqgw5+M/YBCde1lfI+BCSu9MKrX3cakvvM7IjP0N0PGnj+f6HSGhThC9TBqjiNw7lZn4B4+vHjxzOif3H1+ZlxvuG+YEayQo7dRSZWrYb6SScbUWQjiXueuYbZPQIhO9ySaw2uPwL0PEKNlIcIE2CkqxXRmnAgsP0vEovkHX9au7sOXdJQ44zkVB/7+GBATaZKVSoQAoer5kks9JJvFuRkrnkAvujZKpuJbo+qCDcqMy8xnKhd9p8I6iO74V0ME8SZrKsmoldDpLfbrZZVU7OmZNPUl8Nbg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199021)(54906003)(478600001)(316002)(36756003)(4326008)(64756008)(66446008)(66476007)(76116006)(6916009)(66556008)(966005)(66946007)(6512007)(6506007)(26005)(2616005)(71200400001)(6486002)(186003)(53546011)(2906002)(8676002)(8936002)(5660300002)(44832011)(41300700001)(86362001)(38070700005)(38100700002)(122000001)(33656002)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8VK/bEabssGmhZMOqlSD7y1WZ8+jOZQD5OJDKeYF4228extuJ8fhYvHy0Tbp?=
 =?us-ascii?Q?PPrWkaLUX/1OnCIF4/KnKL0FxPJ16LN2wH7dHIyNov5XcLwPSs009iMCe3od?=
 =?us-ascii?Q?vxhoD2vEzPzShckM/gJfE545jZD3aVGmJV1UVS1I4gUaQkIzwQlz3ffTNXLt?=
 =?us-ascii?Q?Kesv9xICOn/nBTdfb08NlCWUjFNOG1h4qRdwa7cdqCo1J6heYI9iPuJXSUAH?=
 =?us-ascii?Q?SCqU18+sh+EyI2nbMKsXOn0/KxeZHZQp8nR77/xa/oTpkx8pPgYgRsu7LhwC?=
 =?us-ascii?Q?Ill66kp/Z96ynfujSYRQjYuSqwUIRHmUrzHPqUj3V/sUl6D6NeJj6PYrzwLf?=
 =?us-ascii?Q?iKIODyUQi2G8cd5rQ28+107ubgJ2+4b/QriRZ7dmmJ+DF+Vq2fHZFJfjYYv+?=
 =?us-ascii?Q?Z0sy0FjVqUuUqefWFfrqQBfm4QJm9mNV5/HxZR4dsPUvOPSC1e+pvxIKcknT?=
 =?us-ascii?Q?JQurC4Icr2LN3wKY3r1m5JLNYmJYz3qfSD7X60OnooderY3hzrCdHGN+znsh?=
 =?us-ascii?Q?6ya3FDVeynI7k8hMAPXCcMHYgmnOJeKoWfj1QG5QmBqY7/abh9mOty7LO0EL?=
 =?us-ascii?Q?leXCMscS4en4wF2asvR4mEWOMPzeELF8PAHpebimNEQo97sIKQhVEHbrgfqp?=
 =?us-ascii?Q?svrHVxh4G6YvZElTzVWrwO6d24I7pJIXPJsWjvGAMysf6dIBVMAtzs8qjFtu?=
 =?us-ascii?Q?7X6er/a37t5PvCC3NYcqVP/LpCZWEkQFP9Gam3ffUh4u6GA2Je7Ed2jRxJ5f?=
 =?us-ascii?Q?ulRaPv6V9JBlBsY6vr+OmtWUW2cCTZrjqq635jT8dCKBr127jdsrMnOYQwbL?=
 =?us-ascii?Q?3xkDl3DdWqhUybPhRI65Yyys7Rq1C+AZeqhaN3eA9ub330jd8P6KXW2KLs5/?=
 =?us-ascii?Q?5DZuoy3N7FmLoUhHe3jGTaEDFGfP7VsMHtNQnGIDjiQ6Krg3b8dMglldnD3u?=
 =?us-ascii?Q?HZAC5qutwCxBn9uP4Uwm58p+QK3c0/edGClvv3Vsh13eTDCDh+LcOdVMngYp?=
 =?us-ascii?Q?sV3+LJAgsG1RlkwRSjTEcAeOK5n/udgXMkZQhcO/ZXmuDWJGPe0tUMqYMZgN?=
 =?us-ascii?Q?H8cRyJIRaaLyBDkpakHFM55P4gUjNuspivy0CFSbZw30NaV6ELWHnrZdyeBX?=
 =?us-ascii?Q?2fLFd5uFt6aGkLLRjFlTnNbumRlSVpMVqaZhxikHbMsbaaK7+7PL2pPNFu4G?=
 =?us-ascii?Q?3G7z8SVhrEUTqr48WAfLTxxPywH3tnda55CnLAfpBHbXg/r0j4uQAlivuFlF?=
 =?us-ascii?Q?hLFV1JnyY0QIi8vU6n3gANtoHv4Zx1OvHEdGUgTZ/Wtx4IFr2ytCcI8ZusNr?=
 =?us-ascii?Q?9iSJSAWTGCXbSYSIjfauTqRFODJoO4wD5/6oUEeTd3nnFLASiRvXwDBbolZf?=
 =?us-ascii?Q?J7hk8rx9FMxmGPB/KaB/e0cIDHssxv8A8p31bE4chwjsCGjTydMmo+UAYvPn?=
 =?us-ascii?Q?xgIEMbYfqwPvN/h/o5OshC2iQD5KJiFM0FD+4G+nqyIs6YDIG3OtVieWJy/R?=
 =?us-ascii?Q?Mk98xOjKcs/A9EtiQbfqu+fqrHpSyW3ussKoIQ5pgMXqIIpXWf6DDVTQ6LGn?=
 =?us-ascii?Q?YQ5a47QfxqbbnabyQHsZJcqba6JTjvnGZGX57Gg3ift88gEQjD3SpXvzF5uM?=
 =?us-ascii?Q?FQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <358BEC1025AB9943BBEA7A3EE933D0CC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: QsedXRJchLuPAJZga3Y/u3sNPItUVs3+pPxp76xGkAGvspQZAvE+3vtQHOroUmJmSlm7ntlxueZW0WpdUkbnSt8GPYLT0MGquRxvvgrmuBBiATvMsPG8WBL5c3kmFkamTZwt3avcC4e0YLsYELLmuwQBrtYITRuN7HSbb82qUVNRiSLLB9ngfRYze4FooEURqc7A4tFjhdc7ROP764Te+9oDqQ12oOZLdTa69Y8sJTp0e7PrvcW4ic6yyR/W3cBbtamtgimeR0o2KPibQn1SjQ/iyNaFXR9tYqEiFbl2r1TuFSg6NNPFeV/qsSbjimO/aUcGtgci0295WbKILgs9AQg/rrwRH/I2dsUfndlFAnr4XunTsvs59zb9tSviz6Nh7nkOFEDVa0vZ2ap0YakWAq3MmbAkJJtAncZQXqWp5Z8n4ZV2zg7lcJAFORBT+tTLkvzQXOapxZSV/V6Nvc3+MdkSJwxJmbl+IcVIy9Y1elvMghqqNUq6XXAQKzjryxIBUss9kK23bqPsk6ASnzphpzoKQS7wZGCpo+rvdJ9NicTtKLLLOggN1vnCpaGSW1Nrx9Y1Vs67Xq3yCGWFnDImCXRFQccdHT+cgtOfckywP8RFJymnCUqxhoOOj10fNRFr7lZETqCxH5ica07gfzAvJLDy6AL7C1Ous+blQ+32KNj4Jb3Cks9dDQwLWQm5VQvsqxqKOKONASLp7UxUYv55ZlBMNoDqM7eb7gxj6YoZgHox5Xa9JgB72AAlqedeuybWI+wdb2XkRNHcX30Jtoe6Bk0XFcBZFObFVyhBe30XYh4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 538f7ab8-82a4-4da5-1786-08db4a55c150
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2023 15:07:17.8915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iFG2B0g8kNS90QCT6iwpySSPCZMf0SAWlEUow1k2EK26uHDpKCXKO8tBjBoXdL9aIdRsZa0bCihC8HdX/DgOEV5ndDqrl7oywtQ4SFdqwQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4340
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-01_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305010122
X-Proofpoint-GUID: MZ9IyP1b0YKgOw1cq9gSWUyCfXYlgmnD
X-Proofpoint-ORIG-GUID: MZ9IyP1b0YKgOw1cq9gSWUyCfXYlgmnD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Apr 28, 2023, at 12:53 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> Task management cmd failed with status 30h which means
> FW is not able to finish processing one task management
> before another task management for the same lun.
> Hence add wait for completion of marker to space it out.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/oe-kbuild-all/202304271802.uCZfwQC1-lkp@int=
el.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> v2:
> - Fix warning reported by kernel robot.
>=20
> drivers/scsi/qla2xxx/qla_def.h  |   6 ++
> drivers/scsi/qla2xxx/qla_init.c | 102 +++++++++++++++++++++++++++-----
> drivers/scsi/qla2xxx/qla_iocb.c |  28 +++++++--
> drivers/scsi/qla2xxx/qla_isr.c  |  26 +++++++-
> 4 files changed, 139 insertions(+), 23 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index d59e94ae0db4..0437e0150a50 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -472,6 +472,7 @@ struct tmf_arg {
> struct scsi_qla_host *vha;
> u64 lun;
> u32 flags;
> + uint8_t modifier;
> };
>=20
> struct els_logo_payload {
> @@ -553,6 +554,10 @@ struct srb_iocb {
> uint32_t data;
> struct completion comp;
> __le16 comp_status;
> +
> + uint8_t modifier;
> + uint8_t vp_index;
> + uint16_t loop_id;
> } tmf;
> struct {
> #define SRB_FXDISC_REQ_DMA_VALID BIT_0
> @@ -656,6 +661,7 @@ struct srb_iocb {
> #define SRB_SA_UPDATE 25
> #define SRB_ELS_CMD_HST_NOLOGIN 26
> #define SRB_SA_REPLACE 27
> +#define SRB_MARKER 28
>=20
> struct qla_els_pt_arg {
> u8 els_opcode;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 035d1984e2bd..2402b1402e0d 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -2013,6 +2013,80 @@ qla2x00_tmf_iocb_timeout(void *data)
> }
> }
>=20
> +static void qla_marker_sp_done(srb_t *sp, int res)
> +{
> + struct srb_iocb *tmf =3D &sp->u.iocb_cmd;
> +
> + if (res !=3D QLA_SUCCESS)
> + ql_dbg(ql_dbg_taskm, sp->vha, 0x8004,
> +    "Async-marker fail hdl=3D%x portid=3D%06x ctrl=3D%x lun=3D%lld qp=3D=
%d.\n",
> +    sp->handle, sp->fcport->d_id.b24, sp->u.iocb_cmd.u.tmf.flags,
> +    sp->u.iocb_cmd.u.tmf.lun, sp->qpair->id);
> +
> + complete(&tmf->u.tmf.comp);
> +}
> +
> +#define  START_SP_W_RETRIES(_sp, _rval) \
> +{\
> + int cnt =3D 5; \
> + do { \
> + _rval =3D qla2x00_start_sp(_sp); \
> + if (_rval =3D=3D EAGAIN) \
> + msleep(1); \
> + else \
> + break; \
> + cnt--; \
> + } while (cnt); \
> +}
> +
> +static int
> +qla26xx_marker(struct tmf_arg *arg)
> +{
> + struct scsi_qla_host *vha =3D arg->vha;
> + struct srb_iocb *tm_iocb;
> + srb_t *sp;
> + int rval =3D QLA_FUNCTION_FAILED;
> + fc_port_t *fcport =3D arg->fcport;
> +
> + /* ref: INIT */
> + sp =3D qla2xxx_get_qpair_sp(vha, arg->qpair, fcport, GFP_KERNEL);
> + if (!sp)
> + goto done;
> +
> + sp->type =3D SRB_MARKER;
> + sp->name =3D "marker";
> + qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha), qla_marker_sp=
_done);
> + sp->u.iocb_cmd.timeout =3D qla2x00_tmf_iocb_timeout;
> +
> + tm_iocb =3D &sp->u.iocb_cmd;
> + init_completion(&tm_iocb->u.tmf.comp);
> + tm_iocb->u.tmf.modifier =3D arg->modifier;
> + tm_iocb->u.tmf.lun =3D arg->lun;
> + tm_iocb->u.tmf.loop_id =3D fcport->loop_id;
> + tm_iocb->u.tmf.vp_index =3D vha->vp_idx;
> +
> + START_SP_W_RETRIES(sp, rval);
> +
> + ql_dbg(ql_dbg_taskm, vha, 0x8006,
> +    "Async-marker hdl=3D%x loop-id=3D%x portid=3D%06x modifier=3D%x lun=
=3D%lld qp=3D%d rval %d.\n",
> +    sp->handle, fcport->loop_id, fcport->d_id.b24,
> +    arg->modifier, arg->lun, sp->qpair->id, rval);
> +
> + if (rval !=3D QLA_SUCCESS) {
> + ql_log(ql_log_warn, vha, 0x8031,
> +    "Marker IOCB failed (%x).\n", rval);
> + goto done_free_sp;
> + }
> +
> + wait_for_completion(&tm_iocb->u.tmf.comp);
> +
> +done_free_sp:
> + /* ref: INIT */
> + kref_put(&sp->cmd_kref, qla2x00_sp_release);
> +done:
> + return rval;
> +}
> +
> static void qla2x00_tmf_sp_done(srb_t *sp, int res)
> {
> struct srb_iocb *tmf =3D &sp->u.iocb_cmd;
> @@ -2026,7 +2100,6 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
> struct scsi_qla_host *vha =3D arg->vha;
> struct srb_iocb *tm_iocb;
> srb_t *sp;
> - unsigned long flags;
> int rval =3D QLA_FUNCTION_FAILED;
>=20
> fc_port_t *fcport =3D arg->fcport;
> @@ -2048,11 +2121,12 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
> tm_iocb->u.tmf.flags =3D arg->flags;
> tm_iocb->u.tmf.lun =3D arg->lun;
>=20
> - rval =3D qla2x00_start_sp(sp);
> + START_SP_W_RETRIES(sp, rval);
> +
> ql_dbg(ql_dbg_taskm, vha, 0x802f,
> -    "Async-tmf hdl=3D%x loop-id=3D%x portid=3D%02x%02x%02x ctrl=3D%x.\n"=
,
> -    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
> -    fcport->d_id.b.area, fcport->d_id.b.al_pa, arg->flags);
> +    "Async-tmf hdl=3D%x loop-id=3D%x portid=3D%06x ctrl=3D%x lun=3D%lld =
qp=3D%d rval=3D%x.\n",
> +    sp->handle, fcport->loop_id, fcport->d_id.b24,
> +    arg->flags, arg->lun, sp->qpair->id, rval);
>=20
> if (rval !=3D QLA_SUCCESS)
> goto done_free_sp;
> @@ -2065,17 +2139,8 @@ __qla2x00_async_tm_cmd(struct tmf_arg *arg)
>    "TM IOCB failed (%x).\n", rval);
> }
>=20
> - if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw)) {
> - flags =3D tm_iocb->u.tmf.flags;
> - if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET|
> - TCF_CLEAR_TASK_SET|TCF_CLEAR_ACA))
> - flags =3D MK_SYNC_ID_LUN;
> - else
> - flags =3D MK_SYNC_ID;
> -
> - qla2x00_marker(vha, sp->qpair,
> -    sp->fcport->loop_id, arg->lun, flags);
> - }
> + if (!test_bit(UNLOADING, &vha->dpc_flags) && !IS_QLAFX00(vha->hw))
> + rval =3D qla26xx_marker(arg);
>=20
> done_free_sp:
> /* ref: INIT */
> @@ -2099,6 +2164,11 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t f=
lags, uint64_t lun,
> a.fcport =3D fcport;
> a.lun =3D lun;
>=20
> + if (flags & (TCF_LUN_RESET|TCF_ABORT_TASK_SET| TCF_CLEAR_TASK_SET|TCF_C=
LEAR_ACA))
> + a.modifier =3D MK_SYNC_ID_LUN;
> + else
> + a.modifier =3D MK_SYNC_ID;
> +
> if (vha->hw->mqenable) {
> for (i =3D 0; i < vha->hw->num_qpairs; i++) {
> qpair =3D vha->hw->queue_pair_map[i];
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index b02039601cc0..6acfdcc48b16 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -522,21 +522,25 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct =
qla_qpair *qpair,
> return (QLA_FUNCTION_FAILED);
> }
>=20
> + mrk24 =3D (struct mrk_entry_24xx *)mrk;
> +
> mrk->entry_type =3D MARKER_TYPE;
> mrk->modifier =3D type;
> if (type !=3D MK_SYNC_ALL) {
> if (IS_FWI2_CAPABLE(ha)) {
> - mrk24 =3D (struct mrk_entry_24xx *) mrk;
> mrk24->nport_handle =3D cpu_to_le16(loop_id);
> int_to_scsilun(lun, (struct scsi_lun *)&mrk24->lun);
> host_to_fcp_swap(mrk24->lun, sizeof(mrk24->lun));
> mrk24->vp_index =3D vha->vp_idx;
> - mrk24->handle =3D make_handle(req->id, mrk24->handle);
> } else {
> SET_TARGET_ID(ha, mrk->target, loop_id);
> mrk->lun =3D cpu_to_le16((uint16_t)lun);
> }
> }
> +
> + if (IS_FWI2_CAPABLE(ha))
> + mrk24->handle =3D QLA_SKIP_HANDLE;
> +
> wmb();
>=20
> qla2x00_start_iocbs(vha, req);
> @@ -3853,9 +3857,9 @@ static int qla_get_iocbs_resource(struct srb *sp)
> case SRB_NACK_LOGO:
> case SRB_LOGOUT_CMD:
> case SRB_CTRL_VP:
> - push_it_through =3D true;
> - fallthrough;
> + case SRB_MARKER:
> default:
> + push_it_through =3D true;
> get_exch =3D false;
> }
>=20
> @@ -3871,6 +3875,19 @@ static int qla_get_iocbs_resource(struct srb *sp)
> return qla_get_fw_resources(sp->qpair, &sp->iores);
> }
>=20
> +static void
> +qla_marker_iocb(srb_t *sp, struct mrk_entry_24xx *mrk)
> +{
> + mrk->entry_type =3D MARKER_TYPE;
> + mrk->modifier =3D sp->u.iocb_cmd.u.tmf.modifier;
> + if (sp->u.iocb_cmd.u.tmf.modifier !=3D MK_SYNC_ALL) {
> + mrk->nport_handle =3D cpu_to_le16(sp->u.iocb_cmd.u.tmf.loop_id);
> + int_to_scsilun(sp->u.iocb_cmd.u.tmf.lun, (struct scsi_lun *)&mrk->lun);
> + host_to_fcp_swap(mrk->lun, sizeof(mrk->lun));
> + mrk->vp_index =3D sp->u.iocb_cmd.u.tmf.vp_index;
> + }
> +}
> +
> int
> qla2x00_start_sp(srb_t *sp)
> {
> @@ -3974,6 +3991,9 @@ qla2x00_start_sp(srb_t *sp)
> case SRB_SA_REPLACE:
> qla24xx_sa_replace_iocb(sp, pkt);
> break;
> + case SRB_MARKER:
> + qla_marker_iocb(sp, pkt);
> + break;
> default:
> break;
> }
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 71feda2cdb63..f3107508cf12 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3750,6 +3750,28 @@ static int qla_chk_cont_iocb_avail(struct scsi_qla=
_host *vha,
> return rc;
> }
>=20
> +static void qla_marker_iocb_entry(scsi_qla_host_t *vha, struct req_que *=
req,
> + struct mrk_entry_24xx *pkt)
> +{
> + const char func[] =3D "MRK-IOCB";
> + srb_t *sp;
> + int res =3D QLA_SUCCESS;
> +
> + if (!IS_FWI2_CAPABLE(vha->hw))
> + return;
> +
> + sp =3D qla2x00_get_sp_from_handle(vha, func, req, pkt);
> + if (!sp)
> + return;
> +
> + if (pkt->entry_status) {
> + ql_dbg(ql_dbg_taskm, vha, 0x8025, "marker failure.\n");
> + res =3D QLA_COMMAND_ERROR;
> + }
> + sp->u.iocb_cmd.u.tmf.data =3D res;
> + sp->done(sp, res);
> +}
> +
> /**
>  * qla24xx_process_response_queue() - Process response queue entries.
>  * @vha: SCSI driver HA context
> @@ -3863,9 +3885,7 @@ void qla24xx_process_response_queue(struct scsi_qla=
_host *vha,
> (struct nack_to_isp *)pkt);
> break;
> case MARKER_TYPE:
> - /* Do nothing in this case, this check is to prevent it
> - * from falling into default case
> - */
> + qla_marker_iocb_entry(vha, rsp->req, (struct mrk_entry_24xx *)pkt);
> break;
> case ABORT_IOCB_TYPE:
> qla24xx_abort_iocb_entry(vha, rsp->req,
> --=20
> 2.23.1
>=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com <mailto:himanshu=
.madhani@oracle.com>>

--=20
Himanshu Madhani Oracle Linux Engineering

