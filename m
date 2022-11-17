Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECF47C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Nov 2022 18:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239456AbiKQSTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Nov 2022 13:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbiKQSTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2022 13:19:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C0A7FF32
        for <linux-scsi@vger.kernel.org>; Thu, 17 Nov 2022 10:19:12 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHHvxHJ028265;
        Thu, 17 Nov 2022 18:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=X7k8W8Ge79FKvlCts0GTCTP5wBF121HcOyj+UA4wsqE=;
 b=zgyK/4EVE+JYd7molVfOzVykqyiWDzRd8K/e4x5Ly1XHF2HLgOz+E0nvb/cAuUM6lsBg
 vtONUXSMv7HYhipB0vqXXrMWKgyzwN2iBu09ADzcxhw7GX5tp30cLoz+ku/MBkVRTPYC
 ixWBy/2rAKBwaBV8gA/AeVDPW4Ds+Iyex4BnIRmL/OgAsRXRHHe2bhzy9EkquHWSIrlz
 oEgEOi8nOdx4ZLbA7a5MSoedw8fpcypxZd15aaFgCJJVZVh6stp6KtsRt+mY9kullUUM
 XvY9MgzPFELlxLP3e52FdyqMLjfU4aG9brxEdj901NE+V7n3UIpbQUcv8etu7KmP/xWC 2Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kv8yksysf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:19:10 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AHHIkJI004273;
        Thu, 17 Nov 2022 18:19:10 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kt1x9ef3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Nov 2022 18:19:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wi1OhIApd3HqKPg0dj84/WMDPPy202HMyPRzCuAMFsIPKpZpF2YvlNrX8YlpJwtlETpBQsf3LBovC92mJOv3xHjISbYWKlO0o82j0lpyUH2jZtsPgR103DABn/6qX+cshmO/GKmiOSZnbslBJbJt/IrKWseuCeIKWn3fDL7FjsJqmXZtIt4MJ/SI8oIeECe+RX3HDM+bpseojLg1Ra9/ZuF7DdDhIoYomPa9EiQUEQkIN9ziWxsXa4TCraaOYeom4tWhJrBMSOiYEnlYR9nYyqp6dXjMmEJGM85ICa/C/ItYX/2rVz6CgHmYFrK4TyxwzyQgkp+4HAyICiUwb4HLoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X7k8W8Ge79FKvlCts0GTCTP5wBF121HcOyj+UA4wsqE=;
 b=WkfjmnpO3B1iRGbtkNteNKQnCZkAF+XxO2ibH9KlAMA3v4Y1/LKbCiI+HWPkcqpoUZuIqCOoW2lzHJdlh6Ga27zxps0b60kADKN67HeMzUZ9wyPTkOcwd46FQ+qOTiG3gulXj3Pf+b812sdPljQR71FseIdgQ5pmJpke5SklHTd3dbSq8En7IykwaQe8Rg1YDykp5qMksmtTXbWEQc1wQwrAMuiCLW7EDHJzYC3ksg/B3BTKv/zlmFXfb7wIHs0dZfCZzV+XLZuECO/v28WGDSk+III11fEXNm/XGVCfPcDBSzfW3ClDGNURJEni6YXu3JtFFD0awz2LNQ/ASzXghQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7k8W8Ge79FKvlCts0GTCTP5wBF121HcOyj+UA4wsqE=;
 b=fleNrc5+Z8fBCB0HsV0qo1HhSeG8HYlxDDjCGXfJTjy1mOpbT5Thy0l937Ml3qaC2+N+/8duGTpkADEtiAzcqtrpt9tKWF5Zli+Fdg771nA+SJM7fuMnUVbyjGRKYffA3+XCoTbqTL+TSkQmK3fPZVZL1Oi97+bQehYykn3/9KY=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB4994.namprd10.prod.outlook.com (2603:10b6:208:30d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.19; Thu, 17 Nov
 2022 18:19:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 18:19:08 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com
Subject: Re: [PATCH 0/6] lpfc: Update lpfc to revision 14.2.0.9
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h6yxwijv.fsf@ca-mkp.ca.oracle.com>
References: <20221116011921.105995-1-justintee8345@gmail.com>
Date:   Thu, 17 Nov 2022 13:19:05 -0500
In-Reply-To: <20221116011921.105995-1-justintee8345@gmail.com> (Justin Tee's
        message of "Tue, 15 Nov 2022 17:19:15 -0800")
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0097.namprd05.prod.outlook.com
 (2603:10b6:8:56::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB4994:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d0ed168-4f51-4505-9774-08dac8c837a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y2IgopMrL6EknOuic2n1Fkv4GKjboYrxnQdmFEBDZdTUDIiGghxpBZg7KaPYhDUbV2qAZ0+hIYzTV3vAmqWkoAQRCtCmgUTB+dsLmaF69U4nCq68Va18zKfjOVrncQ+xffT7F4stECBP6IMvTg2lVBfzmZ2g0UI0X0U3YFraxymK5ZyZuxuhU1x34k6goosJhqcLggnqgEk2NmNLJBRhQP37kqmuAPl6wUjOPUp4JmzvKaKH5tR7hkCcrsekGku7rQusPgJcrw/eCS+uMPAb9NTz+gzqA/WUy5+BIEQbVmB3dn1HS/mKqVnLnnnQtokFhc1MGe5rSYYX31BSY7FhGhhDls0qBe+ENbDBQUqHgp+F9hE8jx3w3a/93t+yNuq2SMaTuXWwWZXwhQZsjeV4u5+fVLfcgUTHOC8gkDVmWKKAwQ2PGQ0oV6MfAyolQpGBAnFPuDvALTqc3udKlxYVXDQZdLqejIe2hroPjerT9VORvqFa5luqOH7Onbv9t4+3+FxCed2xddXjSIdvVW8CUzVmY917IrHHwpntKYFlqMRcX3ITS5bhhmIAI2b/C7idaEsZzVgUiYE1SNThZxDpHpiMLWIEqxOaLs/kddnc6acg8jNDfH3gnDtMQh+BpIyI+j4XZo0gxwrk1+BBAxzfHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199015)(83380400001)(86362001)(2906002)(38100700002)(15650500001)(41300700001)(66946007)(316002)(478600001)(8936002)(4326008)(5660300002)(6666004)(6506007)(66476007)(6512007)(66556008)(8676002)(36916002)(186003)(6486002)(6916009)(26005)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nGzz4e0K7sZjtEc6q3V+zTzMC2+BxHkXXIeN4Yqtz5HivG2qxIBR7kA5CsNf?=
 =?us-ascii?Q?nBdZLa+YTRPOjSdKC4Ts8xnsskd0DX14LCYzdE/IvGZAQ3UoFsznfjo3rxLC?=
 =?us-ascii?Q?mlSNXhNjS8ECWY+RoDM6wPJSYsYwxdSC27YMKHVQCltl7X0VRsD6ROvfyQoX?=
 =?us-ascii?Q?ACqnoHugwlGmR74Fb0IcDPUcGlzfBc1ns5E3JReUDntMcM9UNk0CjvrmBIbW?=
 =?us-ascii?Q?PCf5FpXjBXSRx9FxZ+Fh0dyhTzn78lZEkxBe0PBTm1sO8IMi3hLYt75aSfSd?=
 =?us-ascii?Q?7a6Ii/A5meMvzaY5RqokxnCcXyuf7LKHW+sIjpVQxhIQDZVeAEJBTzhWamSe?=
 =?us-ascii?Q?uSpWXuRHoj9S0caSM6Bn4G+40zkl5bbmuoE8pKhNGaRnxZ2lnBV8X2DvMeH/?=
 =?us-ascii?Q?NqGA8vmd1QBst/mZBLqFotV3jXeGHsHwmPjtgvDCsBuRo7sT9vNipT1S1c5Q?=
 =?us-ascii?Q?2eb0nR+0n0Alut3IopbyBFZk6RqOJ3GM8N7mfwZaqD3/CfIaJtZkj6pEyGr1?=
 =?us-ascii?Q?pycVFte9QaxZQ4QdSLo2w9JBrNdM+LsbIcL/dsq3PFgNAuAFupK2KB6oWlJe?=
 =?us-ascii?Q?cvrbidQ83RN1tdOmahoIn9LsowgA0ZcwEtPBP7r6j+r3UMbC6IX8rIDKY4YK?=
 =?us-ascii?Q?AXeGb6TXmbN7X2fLNxLISUprUYsyZ8VliWWM3c7SbnyTpN/6dadpNeI53Iob?=
 =?us-ascii?Q?UnHmNgZZ3DKNJwKj+ERrEGYrhphsKq6+ANJPc3UM9mBDqdk+lB9LMBHOnYrh?=
 =?us-ascii?Q?Uw69T+3cbTCB3XcdbGAgWLJUk4gCfa+vkPHEPOAhn/ejCrjfaWct1A054M3r?=
 =?us-ascii?Q?mQrSymRWXXk8Y9McYTPZegd2v2C/wh6ns/dsnQzlFtjFYqrDRUs41UKlL3fp?=
 =?us-ascii?Q?fk+PKa/U4vkROjUHOZJgTHuoTD2pG5PbwWXRfFK+1cL6+BWu3hR6ybIx/9qg?=
 =?us-ascii?Q?bcDx7964usPJlTq0bpmxrokS17rb3fUvw/IuHBENVdUTfTHQZwb2oUBot8Id?=
 =?us-ascii?Q?vbvkyJ9Cu5GgPYAkkz3RjVqrJg56RR8nLjwcXtZHi1vNnmEvjFow+IlxItWV?=
 =?us-ascii?Q?Z2TUsrW5NYBJqQZVHI9q6V7XydnmL/s+iGQKfjO9sbNc2NhV1+VFj+f+Z6uP?=
 =?us-ascii?Q?m8OliPtoL8PRQC6kAIr46YEFSGx7AEIPOxlVH4u37Vh3zMW26VJZv7abjkBZ?=
 =?us-ascii?Q?pqFDLLUtwABO0F3EoPT9I/fHStSx5YXw0cA+BqTxgW1gJVsGx4Zs8oxesnQh?=
 =?us-ascii?Q?yst6cWdj9M6kzapL31aC1R7RvXdXDI+fEJqEOnkG9oXlTWV0b3u8aWgLUHbf?=
 =?us-ascii?Q?DGwAlsNzQ64ArNN27HCWUKBEwReokLukVRp9zq9VGO3DgxqVFPHHkNmhuxoL?=
 =?us-ascii?Q?HCXlvue2MuDhYQh9tOC+JzoZN5LwJAn7Km4xsZbqKEkkzSwxokOugDAkRU/u?=
 =?us-ascii?Q?uxR5Ss8QCG2YhTjLXN8su5ZJ6jtmHndMdrpbeq/eCHatlqdfEcZjbVIrtjLn?=
 =?us-ascii?Q?3KiQKarMofwvmZBLePyNM3XVe8/IRvoBGxasd0OaL1uPF4g/EFL6xpM+78J7?=
 =?us-ascii?Q?abQ1N6wY7zgmKXIgIO0+d7LThofhYl11YHhZ3Im1XHkwI0hESWupY2Ln9Zq8?=
 =?us-ascii?Q?Yg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: i5lNU6By1MXBZRa7CYV1HqTtoONOILQDkpQHBptveWDIAv+RJkIvCgt5wDk0svTPIl+/nHSbFyExasnb9BVYJDI1GSAMKT36gzLvHHEW0YxInDRi1kG04cVAKCVQM08bxFfVi50dxE/x+Jt6B1SlVsVSGlokGtXlTsp5bqlV2IgWqSJfZ8SRNKCpcTbBx8c/J7SIEoifl8MZy4TeQNIERdpER3wt6/FJXpnryvn9uRCNMLy98crkuVq9Rim5nvYE5uQHXK1nDNmT8zoSJC5zxQxSAWiYyPPTo1Zk4zXfnyqT56FPAfNydRuUjlvUqt5bs/ga899zCpvk2w4BIC8jpe0ox//o2BB1P30NdoAkNwz/9niScpkgG7NPWeSatTOzJ4rRwK/D5+3QsvjOdcOC1lgk/X1IBFScDXpSM/MpqCzwEYxRHwWLJu/pHKF1yiDg/X1hP5wypUaP4eP8tIr8PYy4MYMqmn5WYu6CcjRbrUYi7NxREpfwIriDc1mbwBzBU0t3CPPMcXVjBPAVP1PaTXT6TaUStAICej5fztBwo+1R7PxCWPIpm1C2Q/EQwc7Q/ppAHcA5ui67HrwFafPIx2WHRjc48qjQ/Z7m1S5YfEq7js1TUne94zDBGLELzdukN4CC/KELYOYC9y1rHG+4GTz/WPn5PNU1PM5MWsLsBqBPaaErOo/i7nkomV0YNiJWZ2Ul9vBD98vQkaNN39TUFPAGBRDDX+TOftLvufzlJj2DLHxrNgnD5nhQAxaLV85rXsqk4wwO6D3eJso+HYG/X4bXaa52Y9GEaZxYK74VNMMxUcKDvaarKneP3Wlw2svC
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d0ed168-4f51-4505-9774-08dac8c837a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 18:19:08.0809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f2PulgwT5CAN1UwmLphw70ftcXbb+UCdYHp9y6mSH8yiRiRWF214549SM0HfIGtGU9YChjjGEcR8KXU2sJiPafDpbwfsa9gTalosXgNLAl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4994
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 mlxlogscore=702 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211170132
X-Proofpoint-GUID: neLMkYwH3b9JcoceBcn2joS3Z96Bx4Y8
X-Proofpoint-ORIG-GUID: neLMkYwH3b9JcoceBcn2joS3Z96Bx4Y8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Update lpfc to revision 14.2.0.9

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
