Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E549C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F036960F44
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239318AbhINDqE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:46:04 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:64656 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239316AbhINDpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:45 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXw3V005121;
        Tue, 14 Sep 2021 03:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=hg4zpf1vb0QhidsxrxJWYw884EoSQ2/t+WLHIOFXWko=;
 b=ZqoobBvJarP2Pljzru8zcW6IWQPtCgFzk97q5UOqHdpYEZjTHq6Rq6/CaCz2x9g4k8OX
 kld4VpLGiheReYLmp+yRDnxFlpQsxIYvh7n9azLfrx4RtMLihZrL9RGwV7tbvG1UjPxl
 6KfEP0TuzJzAg1tOaqkjfNY/VePNTIS2DTZJCQZHbol/8JSrsMsEdJrNRUINJmcebmd6
 jBOgg9mZRozfaUjR80xBz7JgDI1/NPMbV536tmXsw9jq8asyJfIRbETS65oKv8sOWmTM
 nQp7sYBJJ3enTeGTopppOHrdjmxrWgsBNCEVTyPdC838upDUbPCxArZa+Ehn6nbL98Rp vA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=hg4zpf1vb0QhidsxrxJWYw884EoSQ2/t+WLHIOFXWko=;
 b=h2JO4cddB6kvm+ahXmV1a6rlH2r6mc7lhObwEdoZ24zg2/qiDSwqgjJ7248+2TX/VSsA
 UxH1E+HASsxIJvJVPTJ1B/gFicsFAyRI96yz4AmtsCoJPv2rabdJEAVdTKyW2eGWGhKw
 EAvwWYRdo8xn9Ohz3YAB5zY/Ow3oKcLwzdnvz1ULe4Qd+Y7yXDO2bJM8Gy9gP+Z+TF6i
 Pc63VgHlLPhb8ALpWjMtG6bM3C+TgoI7ooWCSDrGlNUG8P6IUeJKCnDiFLF/cqq0B/Yg
 14LdBlSHtUoVmqvT1dEPf0ZAghiCkfsZl4vz5jCgkELr9zlii19pzfza6a0TUwNV7bo9 kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka94wun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3f7ap097745;
        Tue, 14 Sep 2021 03:44:04 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by userp3030.oracle.com with ESMTP id 3b0hjuespt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XBMEMe3K5EoTbK1twikLTVKkdX3vGGsjuhfWFJMuFZgZkqH/Nt5vjDWNPtXLFFL0/mYZm8obB5oDyuMYYQSWoFODw0zzHQFKNyHuNU2+0bOELl+kcuC6UqTFv5DXFCIYiPusrErn9lS+ZfMJOz0f+ep35LKjDVIRcwivBqzITKmRsWckXdZJClCBdWLNRQsqJuwjYnp+hBqIyxiFMASaSCTAxvNKZURXH0E5REfB5vYyvxyfnvKst0H7gw3znCYeX32hB/WDteZeiWgJ4HozVwW+9SEc1pTxhe3mUL9x19p67Si43gDy8+qf7xfNgSm0ScGLktpEiTXn54QconCJmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=hg4zpf1vb0QhidsxrxJWYw884EoSQ2/t+WLHIOFXWko=;
 b=PkW4pxKLJkiXjxEu3CzNOrPS5wEkEyEBTqgpiEDAuOk4cc1stHCNpQkSRJfG4Bjs5gv28fIK3KvSj2ZINkYQxSlH6uQgBGi2RM9wYWl0M7IGdmsGKy24TeRhGA+KjYsaj1ohdHn2Xc0IWjyyv/R05tzPf0fWhf1pm/Mbd3VExqc9AR+lP1B+phD8aBQZkYqvEeVPkIi8dxAZqGOArgs/ZjlQN7qKJpFmb+TtWLun5U5lqqxlTRla6aEkq1Qx1WNKdYqLG/xMgJAc8fg2lAHWDRInnfbOHs9CV6cU4G0JT2xX0fy1R489Q3vNjya05RFJNLoN2eJuzwsI/jmUu3mX6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hg4zpf1vb0QhidsxrxJWYw884EoSQ2/t+WLHIOFXWko=;
 b=YI8Kj070G+D1fjQjHcXrvMuOG/p4nHNFaR5F0zfEWpjFnboCSw1Kz7ZClv3lStccANQyKz8E1aQV8MKxpwTzRGR2dF0Vj+PaSyFWGazJj0k/nKtHVucjDHZxobqIOeuoFPC7VA3JWUKx5eYWvdvFc6j2wjiedKadBFhpEOVy/Mo=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <huobean@gmail.com>, linux-scsi@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH] scsi: ufs-pci: Fix Intel LKF link stability
Date:   Mon, 13 Sep 2021 23:43:40 -0400
Message-Id: <163159094723.20733.6404780781337011919.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210831145317.26306-1-adrian.hunter@intel.com>
References: <20210831145317.26306-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ead0e419-813b-4390-ea64-08d97731e47b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4502BE36433F90E9A828BADE8EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sm5M0NtLhRcEQpgV8l5kxVglBgy+GGE5AMMa3mpOv/nRwwdbZ8hRK0feP3S2hSV6pFBzTNmqHxpQHDxT8mEedmBVTu2kBJKuTQFzySTKBsbYs70mntAI+1Ms69A39fUlPJSc0384FaLsBzMx2aVpGE2Fl/yP2Rz/nr2M6VTOI8Q8ACV8FKjelXmyVfKqns95AA8fAWdnvWaJekrhP6pAbHsNqTC46S4BizI3W1/E9iJHLThU2yP9noE+nD3rPw+9LJHvmMq38RRfCeGF8ObERBec+nmEvGchYEwRKJl0J0YNDzksH9LkDJacOuuFyjopyssocDVQYXtPjHIGWI2ZE6nOXsCjGRaGlvRMES9PDXQu64JsrGIVYJIEe3v9kQFenoYICov0tah8R0Eky1B7jjiYLMPo9LrHfluf1gBVFk3UoYqTi/ewz0YdOSvCingl2jea57FQodK8yDnZQTPNO+P7Ce7DFAv5Zm3ipqHP06/dLJHMAGadtC3uprl7D3DJdOTfJ9NWSonkA388tVceqndAi/TeKLZQiDWLTM43j0i9QRm64DNPwY56Dt+1ePuGN/2eTiKKABz2NCyDKmUISGBE3zDI1aup9ZCtOxTcNhg0auS/o045MmQl60EgGFOKoiPCnCe67eWGf9beajM8oOhd9r3Ty7v1SJC/mQzSK1wFz1L/fYxB37o4byxA8sRaX+JEl9/xs4zi2KzNkn3SFbNzjEzABHuulo+XBqZXxx0JPZbpg5Cpv/Yhj8AJXjNxkt+o1QIYUehKE7tJ9wa1TCVcsy21Hdyd7J/kxM46Pa0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(6916009)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFZzYWZ6a09sWVBmN2x0WUZ6RUJNclp2QzNZOUozeVJybXU3V3EzRXo5aWg3?=
 =?utf-8?B?eW1IN3JJekY0ZVFpdVIzZFVxR3M2Q1YrUytZUVFXakgzUGV5eW5RMStzdk8w?=
 =?utf-8?B?SFhDczM0NFJRQnlZcWxjTC9xZjhJVVJaRVpBVWsxczc3bW1jOThBSzcyOFJa?=
 =?utf-8?B?RHdzQ3JLd0cwYzhBejE1cGphMVk4ZmtWTWFTVVk1WUNrYmc2WGdXS1I5Uzls?=
 =?utf-8?B?eUdwK0VmaGlaMmFNcURoMlFMWmYwbzJvT0ladTBRQnpGOVpJZHU3VXV0b2VZ?=
 =?utf-8?B?dCt3M3RPRkRic3p3WmZTUnV6aGxmYXlxdm9wUXBySXg0UzV0a1NNT2Rnb0RW?=
 =?utf-8?B?RHAzRzRsa3M5aGZtTHpoOTdyMCtvb2pQN3IzL2grV2dhbFg1NTMycDd3U29Q?=
 =?utf-8?B?aUtmK09qUHNSUXJ6Ymtvc3dpNTNUSFI1SDVJdkR5UG1wSHh6WVBndU5PcmZK?=
 =?utf-8?B?RlpiRlRnN2orRmE3eVdoZW55WUJlYmpjS1lYbXh5NjdiM2ZtOHFFSFdzWjdl?=
 =?utf-8?B?cGI0QlBUVWhpcEZjQUdYdGlhUThyanN5eTU4UHdRbmt1dlNyd0ZvdFRtSW14?=
 =?utf-8?B?ajVnbTlDaVlmWlhkNWVDYy8vQUhGRjBJWFk0bG90TVVoSTNnQklHcEUzSnFs?=
 =?utf-8?B?SEFoMkloSGVWL3BETXJjb3FndnZoVkZiT3JtdTV5anZkZmZQREtmOUhLSkRq?=
 =?utf-8?B?NTFuU3hoaCtPZkluWEwxdGxXUUt4dFNUcE1nU05LaE5lRWVpeSs3Y2J2ZlVF?=
 =?utf-8?B?M1VYSXlBOHFtVVc5MExFb1NMeG5FUXZGblliM0R3SnI4RTBVRmMycHZTNHBV?=
 =?utf-8?B?UlhwOW9uVWJaVkdzamxWdStSTkJhY28wQnFlaVhKWW9iMWFzSDhxRmdQZmJB?=
 =?utf-8?B?cWs4cXJOSG9wUEhSdHdlSytpNXFZczlZby9EbnFVNWxLdDJUT0xUd054S3Z1?=
 =?utf-8?B?MDV6blZjQldsZGozUGMwRE5aNnMxZGMyWkhqdzNBbTRFRjVpekVoTVJHN1p4?=
 =?utf-8?B?eVlLRTJzdjhtQldsYXo5WVplRXFmMTF6OGxZeXF1UHY4TnYxL2t0MDNDTFVJ?=
 =?utf-8?B?MklZVGRUNW4ydUo5Zi9hSWpDclAwWFFPSE9ROXVJRDA5N2FlVmFWMU03YVla?=
 =?utf-8?B?QmFmV0tiYXJCeURFcU1mUHpsdTA0L0tpbVNHUnlqTFFZaEVlTE1ZUXBCK3R3?=
 =?utf-8?B?ZjhMVU4vR0xhcnlIWExOTnB5bnRiRnlJL0R6K3JOaloxa3hQaGwwcHVjbnVP?=
 =?utf-8?B?dGhoeTZHZnFNdVVHQzI0L2NHcExaM1lONmtyNlRiQXozN0pubXdvL2pCVDZD?=
 =?utf-8?B?VTEyVHZoVE1jUVdxOFo4RTdFLzBPQUVNck5VTGVUdGdnUUZJWFExdkYvUjY1?=
 =?utf-8?B?RFZud0xBZC96S1p6YldNS3QvVi9yZmxVb21BejBJS2tXeTZGRVNrRjFkcWFS?=
 =?utf-8?B?dUdtdk5jTGdqUCtmb3dmd3p0eTdjandPT2pCdnBqY1R1Tm03eEJBL1h2VVVw?=
 =?utf-8?B?NDdhSm9FZjFnNDlLMjBxTEI4cE9BUDRDcU9OWnUrVWMwQUpFdk4vWHdVKzEw?=
 =?utf-8?B?WCtYaU1kQjNvWndQdGpTNWhVL2IrSHZtdG5oanFOaEpCZFJkTnVSVHFKL28r?=
 =?utf-8?B?dy9tcGtFT3p0dUdQK2dSRGpKS05MMGQrQUNPVGh5UHBjbUZvd1h4eHZ5UlhB?=
 =?utf-8?B?Z3J6b2ZQSElUQVFLbW8vRy94cDBQdmdid2xYRGtzZzBJRFF2Yit1ZXZWZUUr?=
 =?utf-8?Q?sXM8XgZ2xjU9nGbbIs591cEinqZqph6fwRqKrpF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ead0e419-813b-4390-ea64-08d97731e47b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:02.1906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEt6oygEuuUchFoEmhtI1Xdw9HOmpkm6rf9mANEsfTVontoyAAC4X2SzmuuZpTNsf0BANWo9JTsDOFP6axtr2U59kKlqjjGnS4AZNKc3vxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=848 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-GUID: PdxQ15hvCnVqjb3CXo1mvFM4hMGQyldD
X-Proofpoint-ORIG-GUID: PdxQ15hvCnVqjb3CXo1mvFM4hMGQyldD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 31 Aug 2021 17:53:17 +0300, Adrian Hunter wrote:

> Intel LKF can experience link errors. Make fixes to increase link
> stability, especially when switching to high speed modes.
> 
> 

Applied to 5.15/scsi-fixes, thanks!

[1/1] scsi: ufs-pci: Fix Intel LKF link stability
      https://git.kernel.org/mkp/scsi/c/1cbc9ad3eecd

-- 
Martin K. Petersen	Oracle Linux Engineering
