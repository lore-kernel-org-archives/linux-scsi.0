Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A0FCEE0213
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 00:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjINAqN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 20:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbjINAqM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 20:46:12 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5DD1BCD
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 17:46:08 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DMxgTF015341;
        Thu, 14 Sep 2023 00:45:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=Hcxq2y1wekrZFoyZMsQvXb5/3MjuuQkbXYZ7GfyjM3E=;
 b=IOaeeyy1fTHY4jtcdRtYFg2h1A/6YRvm4vVrjhCwAMJD0dgV7MENuyAvD6/oq2cN4bzy
 UcuZkIeNUkAKOrO8ajN6LGU7vUWSmM01petUJ+p5Xyma3FniAYRlBpK0H2LjlEu9qoeS
 13ikrCwDLe+Z6Mu7I5qo21UTo5X1/aho/PFLSSjHmmUy4dO1REgjQo6IayKMo21v291G
 iXft5PIeky+uuN/lY3xnx3XmXDbP1889OT3i3vXFNYfGDKLuEFqiRBBZ+n3s4+d1KILr
 Zn4X4KoRkSX+YtZjIt5WYKQZ5oCvqPCcJ1xjeqO3Z+yad4TTroB2LADuVWNlg3GqlyGj lg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t37jr2uj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 00:45:52 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38DNUSdo004480;
        Thu, 14 Sep 2023 00:45:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f58ra8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 00:45:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B3J8Ng43H+esp00wlmNFb6PE/aO35RtM2ShadtpFtta6QyOqHWKK452MdHHZb5grQbqcfp63AF0CcxUU/lMlU2/WvRBkgF+gOgEu7nZRBUGe+SW2/0G3Md3tbdjhX/jTQhbZYTO3LI33sOTuMzJQb1auTa1fdwGqa39s/I8ZiieBgDlu2exyrka9wk+mmJszFPtoorgDQDDXvWPiTyAcrU6b9L4JwUK3VrqqSDRmMDJsXDh26usFD70afkO6X9eaqb8v8QqsKTKfhpTkWhnrZ0hW/EfA4wMrxBE3kzECWRRcC5nQM2LsPbbajYnSkYwMi07yH93KBCRucUjV5scSPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hcxq2y1wekrZFoyZMsQvXb5/3MjuuQkbXYZ7GfyjM3E=;
 b=LKn4Dj1FCgTMZbUtd7WzqnYhYC2FbyFbUkjEBIXVr+Opls3qKaBk62DS6PkcZ0aOtynjk76JmvBLKrMNNpTfzoMzOJfmwpllI8P1DFtIgIl869upGjNkPznwtUJyyKVrQUaHFUGINNsBlzs2DrnElYowx0GM2FmGwQduxjSuDF/ur8hYUScyGGzroB5+MhjhEVBK8tBLM984Qw2DT4PiCOD3hzpX4EeY9HXm64NYaHMVcZhhm44aCCVn271VGeO9OZjvcNDHkVmkCuKwsnPUacmQCG+T0In0hXYVzfjwiL0J93qa8dfcPzMHzlgUeWgddZ+7dMtQoDMdKj4v6Kphzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hcxq2y1wekrZFoyZMsQvXb5/3MjuuQkbXYZ7GfyjM3E=;
 b=tUWcUF3nlVSjZOlrRdPxCl+F1uKcAiyzuaCc1SxJm/4c/euLb1cj0PFhJLGnGpSeAoiI1huIcIXTL+SbaYGOqsy95XenVMe05rySHkKdT3Z1BHP1y/yT+joH0d6M1pOm9Hzi0xoWSdfATXvj7kzSzSDjKq1XCz78jTy4M+N/0TU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5580.namprd10.prod.outlook.com (2603:10b6:510:ff::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 00:45:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6792.019; Thu, 14 Sep 2023
 00:45:49 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>, Bean Huo <beanhuo@micron.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
Subject: Re: [PATCH v2] scsi: ufs: Include the SCSI ID in UFS command
 tracing output
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v8cdfuq6.fsf@ca-mkp.ca.oracle.com>
References: <20230907183739.905938-1-bvanassche@acm.org>
Date:   Wed, 13 Sep 2023 20:45:47 -0400
In-Reply-To: <20230907183739.905938-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Thu, 7 Sep 2023 11:37:16 -0700")
Content-Type: text/plain
X-ClientProxiedBy: PH7PR17CA0032.namprd17.prod.outlook.com
 (2603:10b6:510:323::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB5580:EE_
X-MS-Office365-Filtering-Correlation-Id: a3951f44-7272-404a-f56b-08dbb4bbf07c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mmq5BpFuQSmbwEmcPJBno79pdQWwVP9zYSLTiqsrI6udpPw36t0Zu20/dq03k5yfbb5x4pPwSVCsphPt+WREZrHH/3nshg697OK47il+FE3KGQRZvmI0y06PCP76M+C1VnXNKbpfWfPrMDBT9e4maL1zpAmUt9NHlOuP2qOY6S8tIzS5c16sfCNvb2mss1hzAMtvUmYSusuG1WwhW7m+M9TTGlD24VhOrPvOcpGpsOnqD0XydX2YOMfGGkF+MJjMl4yl90hZbNcJL9+xnkVfdAWVUlwrsmPgeZJkGbkzcTk3DPxO58NHWkyq1wMBE/xbLi1BoP1uuRnS7k3BWL/GOzLBMxuh2Z8b4SuyiwMu2h0fVUBAjNcyk+n+uPkD/dMQy8MC/wVA41CiXQMrt09RtR8EhJVagZpJkRwOr9s+YH++cLp28eDIU6LLg85cAKZ1aBXNHniWqxpfkyskIJ7ABsf0vWbiJFz3fMem/DtY+leUrmv8TKWBhKzh0Ad8PPEA9d0dNsftfhuYucAokxhWZUHDGGLYTU8OuQkkrEsRpkjMXTuAswI6nufSpM7479n4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(376002)(366004)(186009)(451199024)(1800799009)(4744005)(38100700002)(54906003)(2906002)(66556008)(6916009)(4326008)(41300700001)(316002)(8936002)(66476007)(8676002)(6512007)(5660300002)(7416002)(6486002)(6506007)(36916002)(26005)(86362001)(66946007)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WUziCUGSYg9jvnp1C5MLOuLbFr2VQJ6RmgFQ9l8yWa9NUYxoGk0wHiKiQim7?=
 =?us-ascii?Q?lof0e9n+EhSDddFNfyRKCLpu+hQ7H+EYElm5Rkkv8fnAB3gXBa/yPhEOHWab?=
 =?us-ascii?Q?70SkdJ9DZqJ+jpTSFvQhBTC1i4/5p5d7hj/5IZNvJl8weOSbddEkq6T3ZGRu?=
 =?us-ascii?Q?VKfTK/23bX00KlztWcjvvisxwdOVGsJlDytzmk4e3oK8/+ayKDAGlpoxdQmZ?=
 =?us-ascii?Q?GIB21DnxBb8POWYJKEz1vuVlcFxEcT4qEJQ+8E/A1GsxUrQrJIUf70qc5Cm5?=
 =?us-ascii?Q?Ohfi+ZUNG/VQKtNA89AAtFXxiHgeekUvCkexTKNmhf8geXm6E3yVo/jH/lDB?=
 =?us-ascii?Q?8xmvUMexRIcogRTiCHubJRoM1GBqoZ0bybKh8ZhNyhAIPM9OB9xcEYd/scCl?=
 =?us-ascii?Q?sMKHZRrJCjnFXXWGOw5OTCAWDsp/TCT1khed8kizxiilVZ9Q35XlDGBn2gr6?=
 =?us-ascii?Q?G69Fi1qQEormIU0SR1oaebhihyXEwW7VJwZ2ThfoZs2DAuzFRPZTxRV9y5bL?=
 =?us-ascii?Q?TlOyJEgD1YpwoPpTtkNgb1Hr1aHHD1SA9x8ZTIOU6cBbSP1udR+FL/tIRzt8?=
 =?us-ascii?Q?2FKVOU1eKd/s4WWoxNZytLqwf/nUvY2NMBwHzOLfmxrEQoAZNff1H0ByGDrT?=
 =?us-ascii?Q?y9RuTBulmB/dXLL1oxShpIzlHkBC/Oo9+goss3GDwSz35ooyOByjj6X8C9nc?=
 =?us-ascii?Q?Px8O28qwTIjg8gL68XlHoJFegecHK0/aDJvvh6/gojiaU2fLLWmnr6c8AEwR?=
 =?us-ascii?Q?Bg8Tii7ueo9pqoziz0n1/DTz+E/A5h7VK6hXW1i+Fo7E3MmigFeO+RsHvaAR?=
 =?us-ascii?Q?eEQq7lZrHE6uNw6DvJhcIREd9C3GkzL8yeFw0XW4zHKlxqRoyw8dDeH79NV6?=
 =?us-ascii?Q?JfSkqBLIEoWSR4FMOFa3S3ST1XXnyBeWqkyKN9Et6JtyOYr529Zz3ms3vnz2?=
 =?us-ascii?Q?XA9/NhY2j0+e2wTHDG2ZcdWRo5Gkk84AQybbibnEgQqtBFmdOLh9LkjkR6he?=
 =?us-ascii?Q?fb8AvTpP1nla1gok+/xrpP2HhcNEqbIXIiODewXmBCngfJiEzztrUPdbGeYI?=
 =?us-ascii?Q?APryUsxTDY6bXSZuTsYUB5++kpAW7lzhGiP3AmBJUCZa5utkByVTEDVbHuTJ?=
 =?us-ascii?Q?u1FdqFOCyYFlZlDVoZoRMM4zluMAt2qMFXoKctEXkIlGKm5K4v6SHSOLb/zC?=
 =?us-ascii?Q?wrgkqc5yQvEDbFk0dhh9Jz+RyScj2ffoRIG472Gcy89x6FhDEe4FwO3BASh5?=
 =?us-ascii?Q?ivW/uYSLjPHIjxDEM7iRUgX6xDi+KYKA7bvSAr38EFwo+z0Tp0HmBxoLG/qw?=
 =?us-ascii?Q?PZRfwVPs9AjOwAtFc7wg7q3iNClLZ+qbDfZHf2yTv1e7BVl98aoIl4JHODjh?=
 =?us-ascii?Q?6c3kYRwdPm+Qb7vcqgPUr3q3yqSWZbhtHD+tBb6PuiruNjJ2hFH3hCbU/5qG?=
 =?us-ascii?Q?kGz0CCk8KORLHlIj//nAqKgDhetj/+6y3Pbfl1H4i7VUord1PQTw+XI0R/9y?=
 =?us-ascii?Q?I3MMfWyBX+JaAXw4hz+qYqRIqMZYOnLedhdiUuGWrgeCY0Fqh9rfScIY1tny?=
 =?us-ascii?Q?wg4Y94qXWWuBqaEGbLweZN3g+7Q+b2FvKnVCgwrtrd/gxNrh45tYhN3rzLbZ?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ssNxa7eDfdYfEJ2VRkpBbOP7xM38dWl0rPNA3Wgjr87m3X8AbjGjTDvWAWX/?=
 =?us-ascii?Q?TPLY4uOd3TH2O5iMOS2A512aNUJ6Pdre4A+kil0JM1pFwyCY2zi9Gx05/asm?=
 =?us-ascii?Q?sCoJg8j+pS4GalBYohX+l35Mz0hnKO+d9YmKD1QITKQmuib4xSNXVrI5bwAe?=
 =?us-ascii?Q?/i0y9A0Uvnzdf0ZTu4+V1IlSWCmkXOE2mx1wuXQJJIolzKuOEQEnsOdXku/a?=
 =?us-ascii?Q?F4fv6YVH8B0iQ8EQnK9zaFr4870aWcdf/SL4AANL1oUWgxPRES6L3vAAua09?=
 =?us-ascii?Q?mwDjelxbkpIRayuROWvTdKhJbFKCkBv176FtcEWs7d3gctjJ1ofDkIgtpndK?=
 =?us-ascii?Q?7Q+CjsbOkSeMCZe3zzykVIzxIkJoMF12Jkrxnpqe4WE/YgUohGNE4NEyx9UK?=
 =?us-ascii?Q?4GSXfRXtkwbDLE0vDBXckWSQOCC/BliqyqMcHny9nAaCO3xUUVvTE+f89SzF?=
 =?us-ascii?Q?ejomeXZuxAE6o7/BuJGEZA1bfjZOtWArmf2lKQRDbMjQuqGV/XU3RGwVHnar?=
 =?us-ascii?Q?P5jJkbhm3+Pn0q9ylhpa7249lv6yMGL4XZgrGkxh1a9llU+ZOcm+gupKEMff?=
 =?us-ascii?Q?JR44r9GcwCxMx8TIxwl986ROo/hkqTpilVpG1iVzSPaeEKKdwXAglLLMK9e6?=
 =?us-ascii?Q?OcnbuNziB0pip77ihj+MkHIiPlDkoltOu9RgxumALsk3Oir9r/8VfH9MbiNo?=
 =?us-ascii?Q?KvmFsK3/DwU3ouTGB9kp9hLa6L4jlGAmKKU46AlM0G4RRf3gIS+Dt2h1NUs3?=
 =?us-ascii?Q?Hk0uUUH+i5mXVTBc+3ZHgfv2oX/RPmLOJ6EBl7TWBCQMRX7lDgBOzeqd77eZ?=
 =?us-ascii?Q?9OiBgsNTq9NInvoMLmowZMTBqZbk7Z9X5tkofRiNGNRGsZGcLmWFcDfNu/pO?=
 =?us-ascii?Q?OeWKny/wg5KGaVWmJRbYF7KE8/8P6zu3RAM8Ka6uAvQh7KF7lTT191TokmDM?=
 =?us-ascii?Q?RNvBdOiyFcsJVg95Bkn4bVcaRablBvYh20YSwF4N3r8qbSJCPK1QkiYJa8CN?=
 =?us-ascii?Q?49wyJ3Y2qSmRt+ggLOly1MahmNIWpOZVK2iQzIjZfZIhRec=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3951f44-7272-404a-f56b-08dbb4bbf07c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 00:45:49.1398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nFtOsZeskPGVl14ao/KBpQfqGe+3rSjuSzHqXHfARr5PBS1gkzqnO/kjsx7+35BRl/WyNxy3dqlgw/qZ0r0j7p6a4tDhgLy8pG/UtibsKzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5580
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_19,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=900 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309140005
X-Proofpoint-ORIG-GUID: K8SishHS9HpBUsXV93YumTdFLgsIkeCl
X-Proofpoint-GUID: K8SishHS9HpBUsXV93YumTdFLgsIkeCl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> The logical unit information is missing from the UFS command tracing
> output. Although the device name is logged, e.g. 13200000.ufs, this
> name does not include logical unit information. Hence this patch that
> replaces the device name with the SCSI ID in the tracing output. An
> example of tracing output with this patch applied:

Applied to 6.7/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
