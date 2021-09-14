Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87E2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA36B61185
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhINDpl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:41 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:42704 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239190AbhINDpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:34 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXjsE006606;
        Tue, 14 Sep 2021 03:44:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3xKadg5CraBQvDODRUev4bpw+Bb7ujuxCBjvEND22gM=;
 b=qnRHkAA2jOLRHnzA8wqsBB/0pH6CLi4gjEvy2Gdg0zpfKIfspntOpP7Abo3/ggF2VfN3
 gqmGdlxxoztfn0NY26NbjrijO8+kcL1/pxo6nEBu/ZT4Jb5cJ0tprCakECbuWvRbaid0
 L63rGvY1LEXdkWjXuRWb9ezWWnXqe0b5XVj5BYZEt/tEAVhzzEmbrcRJVMFuYfZ5I3/M
 j1gwedYxa83PePHgjZizZPvCu9UFCwkJiKeBUSZ5g23L7ZRwYQFyoT7SI+k+kl+m3Qw4
 69UPZKuWr4YuzuanZKDfzv+XQByBizGgnF7zDgeP6rms/c61JRZk6gUlYgfrT8+oH9Iz 3A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3xKadg5CraBQvDODRUev4bpw+Bb7ujuxCBjvEND22gM=;
 b=oZStT1Or0K3ff9GJvu9XhqyoTiUQxP4V3cBg6t28L6siZByRnPTK0bka6oP3Szbo+syA
 Ttc+wAXW0OYp36MWaD3DuRvvXTC0EYTtySzOKXzeZ15sLznPBA6J+XlvCu3sLmVncJsV
 WjGKxihhvqDdaUYh6nPjk17bWlczdIH+MxM6OI2EktGbad2YyJewlSLBpfqRHqz8toY3
 xdeb0qHAXrEvxDcbWyfasdobcndoICd1fOJtgD+c7cm6jeOtr9pR2kqWkq0XjDfIpO/2
 WxuLVDoa5LF/CqcL3Y+js3pHSw9T4JXrmZUU7wEl22SEbGZ7Rrek/jjs6czVw4GFtPag mw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1k9rw0k6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3fQr1109415;
        Tue, 14 Sep 2021 03:44:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3b167rd618-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TE1STLhfzuGo9SWH8U7mKPn3+5SKnfJdX5YaNJcsOcaRdv2E3cSUHu+6/yIu+2+42PAt9Yib7LOqIYStvMuUzwj2Xt1Glpr6FsHU5muHtLIoqK6ExMazkRqOBU8sGiQGSTAKb8Vk72mgsLdXe869hadDdpBR+zLR8jxWXuHfPhi9uPw9/Xv4jiuRn9cnz+mRHinEfT8nNKcjJ2vCEwCVJ1C77Jxx2mPZtm3bKEZZOrJqytOs39ojgCyuY8/F8d0aoX3+rOYZKsrxKz4tTeVaWvEp6ZXBVAuPvyrl+1he5vKKS+eOG8dJ1rPGQ0qi0lW/4aXh00CduUPiSBI4m8ckwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=3xKadg5CraBQvDODRUev4bpw+Bb7ujuxCBjvEND22gM=;
 b=WoVu5syaeswi5dcTkMbwybYlbrvo0t4EBpi9ULnW9O+NPMY8GmQvEkZI6+BcbWMdk1zUuu1mEMy/YHwhEG+iH6yHMNFgAxbNxCiqhp34BtkNxF1h8jCHZydRdYU9Ciq8A3QKyo//6aF1qYbi2X0oLyXbPj02mwKO2EPzG4jlrr+Z/6nUHfC5nNkpWqv9WzbXz/4aXNAygRcCbrrQuFdJ1ydkEVVf3J2VlLGAI/prnNeHSlQuZVng7E6RnxwfzYNNrfzJXf4QxJGhcEEl8HvPxDqD75o29heWWVKb+xaFNAU7Kly86K+nljLqdeeMLK6wG5frdxe7hkZTB+V6M1zgww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xKadg5CraBQvDODRUev4bpw+Bb7ujuxCBjvEND22gM=;
 b=UrnC3efTasScjpS2MuWNITJs+uw7zvu96V9Zlv/7/UUFB6QnDbJx7AIfABnX/g+bbyaSBLX04RM8qG6emNXhdNFOJIYCJR0rnlSE7cXcjxz6/8+LNvUVnE+DlXIfG1JgvxM0gOw9UICv43Xy1J9AegVlrI1ecw8Qbsv192M1nfs=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel test robot <lkp@intel.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH] elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology
Date:   Mon, 13 Sep 2021 23:43:50 -0400
Message-Id: <163159094717.20733.17682304455683852276.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210830231050.5951-1-jsmart2021@gmail.com>
References: <20210830231050.5951-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ece90023-1318-49b9-27c0-08d97731eb11
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45025F3D62887959B69293568EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:216;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dj6oVpKpaRPXo/j/Pbn4LYfKPG/daN5Dy1ARxvOz/6RSzrcRcGJ3OsdoXlEMXVbrZMcXIl5dvVjspPJGaVcHmETkfi/6whCpCUPSpy19UGieVo6yvEbUjyG6Un6UVCx2Xxp0ouqI2pl/qEdSfEj40+yYsVw/2Ne+UV4R+qEPgVOXkVgYcZOGqLRtjd4f87kjEnSYPvGZXwLlVnRbt2H0WoLpRB4VWaMNTwojWSxsH62I8zRL5S9ukdvqbSIX/lPmPDnOnTBi4QqL7XC6gM6H9uy3KCSfklB+yB79/8eSdUOpUILRlsFNJkl7CBd2PbyQb2THRJhl4F2337XQ/XV1LRyIiiSe18TAhR4u2dLEdhhALvCynLHREpvECJqEGA2qCnbGR/egA18eHX7oAn+sFlJ/pYmtdLVFVkSq6YcFsmX1H90RbxSJTOOnOxmtq8qErp5fsg6Yip2HwRupjaSNbmx+1ZIzMYEJHA/++AHNilpGRAkOVJFQAcQ1snKX3VJIpbDZeK64IwXIbKtaDRtjDB+wS/Ed9JkavnwKfBKbONVgjoEUh1/ADZqAmcANljM+hf8OVrbKshGl8SJV6BI/Pd9OkGSC3mEljsbXlwld5temVuwvSqv3pqOoB3gdEWi8G4ZnZ2G1gRBA3aZkbLGkKdqJONjMstZ2Gc+DL75hTnKgip9VD2hunugqV9guoQasG5LWximzrrNU5XEmPFHaGlipyjDfqvHU73OsOCOlxCBNkfz/pDFzv7mFGfs8C6aTbo1R7ljtYCC0ndOcDnd3G/qJUYS9Pb2A3wxeSuHQnFE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(83380400001)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2o2d01Sck5iMU1FL0NoR2xiQlZYMzJudDVZV1gwUWVnd29HYkEyYU15SU1R?=
 =?utf-8?B?SFY1TEVUVzFoc1lCV1Ftbmo1ZVRTTUg1OXl6dEZrWTVVWS8wMmh3U0E0cGw3?=
 =?utf-8?B?Q3ZjUnpQckdyNGxGWlhvSmUzaGk3NTU3Y0dvZFNZdjFzayt1d3VEUDY5cTgz?=
 =?utf-8?B?NytGZzhWRUxsUzRZRXNGejJ4NjdsU20zY3M3b1FLTDJRSytsQThLaktIN29T?=
 =?utf-8?B?SGZSR2hXaVJIeVBYYm1iMC9QVkg4ZytkNnRVNFRoc2R6QkNGa0tNV2lUOUsy?=
 =?utf-8?B?NVpvM3h5VUZUV0x5bEZPNkdlcXFzVXFjdFdEeThVTm1UUVlIZTY0N0hXWW1n?=
 =?utf-8?B?REVPSHlFcUtURXBudktHR1RkS1ZmeTB4bnF2V0tRSnA1MmNWT3hNUDBSL3Nw?=
 =?utf-8?B?eHVOZnZOZU5sT01aZzdyZ1krSDZjL1Rqd09RSjNpck9oR0QvM3dQYmxqWEdQ?=
 =?utf-8?B?OVR4bjJUNGU2RWQ1R1NHamdHZGp3ZUF6L0MyVGs0UkVEL0szNDhVYmdiUDIw?=
 =?utf-8?B?SjVydUNJZXQwOW42Tk5wajluQU5xekFINzkveGNaKytIMnl3QzhJNVhJWktO?=
 =?utf-8?B?cEFlL3pWL1NHNUNpQVVQbndVOEw0VmV3OVdIZFkxQnlNVmk2VDF0aERObjVi?=
 =?utf-8?B?SGdFYzdsc1dYSnlQa2ZqdHNkZVFWdXJQYXZqZlVoVm44VkxZWHRMQjYyZ2JI?=
 =?utf-8?B?N0M5aFlrbzVKdUpPQnNHMmJ6K2M2QWY4bTZlRGR1emh6a1YzcG9Delp3VmdI?=
 =?utf-8?B?bXNwTDlSbTNva29LZ1hDbWgzWlpJcFpFY2EzZ1BGa3loR3lTdFQrZ0w4Qi9J?=
 =?utf-8?B?NThpMGJDNHlGMTJXRXdRamFyZVlOSno2dWVuajh5WkVlWXBOajlHdDZZVVZu?=
 =?utf-8?B?T0ludTllcUFrSVNQc2N4TDRtT3RqejZZQjFKbzhHZGQ3YzFQdDZsWnVzWllN?=
 =?utf-8?B?RWhSWVk5QTIzaHJwN28xd2dLRDcxeUphZnJUVnhtd0Q4bU9vY2Y3aVErK0tY?=
 =?utf-8?B?SFRxNDF1OFhNVjg1VDl4dk1nK013TysxdzlXeVVqVUNadGVWYm9VeTdvbnBa?=
 =?utf-8?B?VEU3TjdmYUVwTGhhL2p1RmJJQ1NkdUwvVTZ3cUtlUjZlYWFUc0FRSHNnVnpP?=
 =?utf-8?B?THdWWStHeEpRcWVCUVc1U3pmR0Y5d2RqZ3BvRmVZcjc2YlhscFJNME9UZVo0?=
 =?utf-8?B?SWlQb0ZYL3ZNR3FYekNYeWNpa1JPWTVHY0src2o4ZkloVmxQemlyUHJJYXBW?=
 =?utf-8?B?K1VHTzJMOWh6UXJNUGp2SldLMWxMZGtIcGRrbDlKTEZXbG5VZ09SMlVtdUZq?=
 =?utf-8?B?RWhxem5USlJPYnVJV2tQZzZhWlh4UnJ0RERNYitEeXA0dWVhY1NNMlBpMDRW?=
 =?utf-8?B?NytpOFMzSXZjaUIydGtxcFhhWkpyV3lCU1ducXRCbUx1Q2xwdVpsSVZqc2lL?=
 =?utf-8?B?NHY4R3dWZ3p3czF0MzFHbVhIc3Btc2NGSmQ0c3RObUx5a2NtbXRZVWk1NHBX?=
 =?utf-8?B?YjJocmlYVERXNXMxVlUzSWtmUHh1SmZxQURFVDZ6ZENuNUxFY0ZwK3hqTFE2?=
 =?utf-8?B?Tlgzc0hCallWQUR3QUVBNEgxdzVOSkhNLzByRm1VU0cyMkJIK2hhSGxUMmw1?=
 =?utf-8?B?d1duQ2U2S0lhVkRDaEt2SHRMUkM4TjZsWnNGQ2Z5R1FLcjRGNGtqQ0ZSYitr?=
 =?utf-8?B?Q05CY0QyS1ErdTc4RkFEUEZhMXFvUm9ScXd1ZWVXSHZ6eDIybDEvbFRpMjV4?=
 =?utf-8?Q?mQkxbTOy7g2319J1A+ZkZ1T5OowlbD7IrkUFNtm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ece90023-1318-49b9-27c0-08d97731eb11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:13.2201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3QNzQKPdpH+Eh/jsSQibG4HCImvsW99xpH4GtShMe/8Vz+I/VDLN4ngTT8Y4jdr7YRhulhcpCGl8hBPeN8PwlaiYPFgvYqgiUt0z8nLP8Yw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-ORIG-GUID: I7JUN80AoK9DsKzeozGRXQP2t0K6rfGY
X-Proofpoint-GUID: I7JUN80AoK9DsKzeozGRXQP2t0K6rfGY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 30 Aug 2021 16:10:50 -0700, James Smart wrote:

> the kernel test robot flagged an warning for ".../efc_device.c:932:6:
> warning: cast to smaller integer type 'enum efc_nport_topology' from
> 'void *'"
> 
> For the topology events, the "arg" field is generically defined as a
> void * and is used to pass different arguments. Most of the arguments
> are pointers to data structures. But for the
> EFC_EVT_NPORT_TOPOLOGY_NOTIFY event, the argument is an enum value, and
> the code is typecasting the void * to an enum generating the warning.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] elx: efct: Fix void-pointer-to-enum-cast warning for efc_nport_topology
      https://git.kernel.org/mkp/scsi/c/96fafe7c6523

-- 
Martin K. Petersen	Oracle Linux Engineering
