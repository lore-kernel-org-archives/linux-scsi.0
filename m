Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0564EC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5D19613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344709AbhDMFs7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:48:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344729AbhDMFst (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:48:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5j7bX146396;
        Tue, 13 Apr 2021 05:48:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=TzSg9IRx6Eysoa0eW0bt9sg+YxoyvrMO7KLPnvYynrA=;
 b=IfRjKywZWThsqGvXjWlys5Cw5hYXeGduKEfYVGRzxPT+J9W5/EV+RClpVs9eCz72IoQh
 VcTpbJFtSClsCVCXNcg5d3UxzQoNtdLVrs/tF3+sbIiRT+ae/tujtekKljTL50W7d0Ur
 /hMeLYQMil6u5W87e4RDB1Nr5xOXhKWOd2i4HVnjdWUNdHL5d6WtZFC7wKXD3h8BSDpp
 HXj2uJM0qupX5fGt+UUIH/+x75GCMpBMfQsJbDajzhX8y/YM+k62sR0S0ZAVDtR59+Qt
 spH35a40YzZfRKzc5Aj+9vxi+8pGcvDxiR08xijPSlEBuqJXCdsCB9d23RrmufDcCUKl fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37u4nndswh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kRYI137164;
        Tue, 13 Apr 2021 05:48:28 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by aserp3030.oracle.com with ESMTP id 37unkp3mc2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+b77F4nJqhUXZ2QQtEqdQfc0apDUKd88WyDMzDSnsP8ZuhoQAjDklZO54/rtCTT9E4CuMrdhQNxITOwFSzKdUa05111CmFPW69H5vISVq7SQ7TRYJmoaviZ5bzljoPEmFRFGsEPuyjYduVrUNcgoTeE6IfhoQ6Mz6XZsKgTWbe/hnChzlbQt0TWwMTHdAtTC3tdnkhfjzC2/cC1DhhOfEBW7A9kxc9awBNvlWrfa5AaSucsFh+W2gfjHgC1zt2AJCI59GkX++07iUvgc62ToupLhaODLSGfx0AFP6W4f32/RX4ZYfs8nxl/5BHWDGAIFpyjRMUIG40vKDXh9xt0NA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzSg9IRx6Eysoa0eW0bt9sg+YxoyvrMO7KLPnvYynrA=;
 b=C5MiESpjEwqsxYn62i7h+rJLBCWlb3Xg1rjetP1/qNMKXrt/rn6uAbFROC3vqTETJPHLo1oUGgK6XZuDozCCU5IJrKVar6HNUheJVivt9f8PQy1k286H76MQql6wsRVjgWZeZayTk4gT0SDHmR+U32qfskVsHlN32tpWVssRvg/GdlvFlnpc/ca5Q77iICJizIL46cj4HwGhCBosw32PtsiNBQ/zjysOzvyWE0Zx4KetfcRXbvqz0udEp5FyUQWyNd+yw9k7w9Ce+M/Mx2Y/m+ff6FXgbTOOWHNEBzs1PzyUdQxHjJ231nOuaNvHpYvdemL/BXAK8E+q9fgPcs1r4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TzSg9IRx6Eysoa0eW0bt9sg+YxoyvrMO7KLPnvYynrA=;
 b=M/5e5XlovR6YvtNYK/rNPQp2z7jDHD+Z5IDa3eBlkpQeH856BVG72eM3Wo/7Gw4teaL5oR97nNsvc8iITmb+lw/+AFxiEjnX7KfkKlovrfW11HRkWHHvLOe11IKhf9Suf4zwibP7eztYvMB6NaRSkvw66ZLRXJaO6GVKNv9ImLE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Mike Christie <michael.christie@oracle.com>,
        target-devel@vger.kernel.org,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH v2 0/2] target: Introduce dummy devices
Date:   Tue, 13 Apr 2021 01:48:13 -0400
Message-Id: <161828336217.27813.4442940540515306830.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322200938.53300-1-k.shelekhin@yadro.com>
References: <20210322200938.53300-1-k.shelekhin@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 549bf815-6966-438d-910d-08d8fe3fc28e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4614E4DC357605C836CC389C8E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zTC0bbTCL9sd5WAkfISYemsvihJFy2SCTk4C/P4e5JbdElE4j5UoBpmtEMOTnoxf/IVQ5rNKxvrPagkNPFAUC/W9aUbi9j8iUan3t7MfjtbBikeHGUXnNChvsUGIrlluZrjriV3lLlFlnzHFvdLuBSnbKnf8KCAfkWA4DJkxWR0EeZgr1DxLdf34lJbf166MmXKct8kQN5V6qr+mASQ1ZbubwqgXpM/k//iZFip78FxALgo2g6SnObHHpGWMYxuGU+bDdUti8EiqaP/EaOpOWPNTgSbpcIcfqYCP3y8aa/x9c/wVEdc+WrbGyIL/+zUjM3mmY2qBbiykgxk4lpxzHdT7kME1Jetsjy+gh9qL5EZqLEiHHqaYV93LkybpfcrPuTXqhOYENHlTmGNOKs5tB6zS6kM5hjPqyZeS3OZMyzw55wJ20dVTgBFDJPNcikZTOJq7X3Av2FStB/VHUqcZ96cyP93BxGlSkBvRxda8+tq9nasz/FamculyTTXNdn1ppu1NLYO2/2Qf0dveHAiBCXtSPFlLELOQ9vBT6LlUsaaK62F1Jsl4BSlHq2ltl8Mf6OVzSK4hWpICXtBFTRxX5vOd4H4WCwWCULhqZG9z/f1HODVzZ7Zo32Wg+jIX6SUObaoDwq9RmWlevEBZgGdSAKMvATTq0etnuIZWQd2pRhtrpVjQ9LQIhoQqWGFztLSsQyz/BoNKKJqHoAHeHR+iQeRzo7kg6R9uL0sHg+xwC1E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(4744005)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(83380400001)(66476007)(16526019)(38100700002)(186003)(110136005)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?azFRV09iR0NJaXROcGJzV2hGak5FQWg2MllDQjV2L2VZWXE2Y2VWT3AyVGI3?=
 =?utf-8?B?L2tUY3NTa3BKT0xqSHBSa1VRcEFPQUJVRDlpU1lNaWQxWExjN2xiM2V2bFJO?=
 =?utf-8?B?U1dEOW9mbitWV3RSM0NtaXJ0ZlAyVk1OWTd3UG5BbjNBRDdpenMwZUJlRmMz?=
 =?utf-8?B?bmlCYmJ0aEU0RUNmdjc2MUltOSt2RkM3RU12b1A1eThZMWdheDVnUUYzMmNR?=
 =?utf-8?B?MzVRVVQxek1hb2NWTjljM3RrcjFhYkhpNzgwdFpRWWNtd0kvVktteWFkMU1X?=
 =?utf-8?B?M3VMWCs0eG1VOHdqWjRLS2xYQnNnVXhlSWQ2RjJYU1o2SnZKMlRkbWsrd1da?=
 =?utf-8?B?SWRPKzRVdWJWSkx0ZVB3MkpGVmt0QXprb1AzR1NzTmUyanhjTGxoTHNBN3ph?=
 =?utf-8?B?aE1lU3VmYkhac2lzNG5EZzRHYUlPOG1TMzRUbUJjYS9POUp6WEJMY2FMc1Jy?=
 =?utf-8?B?eTBIN0l1WERVTjVHM2JnSkVZRTRzcTFTVE45dmJMKzZDNzJYZ0lXTWZJRVBs?=
 =?utf-8?B?c0N0MDczUWJDN2d6ZGVGVkdyV1daZEpoZnVVTWkrZWpFNEZYeGcySW5STzIy?=
 =?utf-8?B?czJsNDFWOXNqMFNOdFhhbHRSWStkYWdaNDlFVkk5MUJJa3pudVpzOHpJMkpI?=
 =?utf-8?B?UGZacUFiVkFQejZBZEl1MCswVTM3YXNSY0VPSi9nSCtjcDl3T3N6UXJ3dUZ2?=
 =?utf-8?B?M3hSNFFRZ0tXQUpyYit0TGZHaXJRUEhmcGZZMzJPU2oyd1ZzZ0dmdUZXT1Rm?=
 =?utf-8?B?UWlqY1ZxM2pKZ2oyZXZWblo4b1RKblVjLzJvSi9xcmJlK2ZRc2xXU0ZBY0Nx?=
 =?utf-8?B?ZVdOMHRZRGNINUl5YnJaU1kybU1mbVY2VjhSYjZIay9jN1ZNUFBDN1NxdU1l?=
 =?utf-8?B?eVFCUGlEeEdSWURjZHBBVEdwUjhQeTNYbTZKRUNBejBsbC9qQWFyajdXUFMr?=
 =?utf-8?B?bWpBNldwbWtFSm1aQkJxSFhCdE1zTGQ2REtCMmNBcG5lUEl4UWxwZ3RlaGpW?=
 =?utf-8?B?NXRNckMrNG9jV291ZlVHa1I3ODRwOUVFd2IvUVlmTS93UUdIRzZVRDdPaDFS?=
 =?utf-8?B?SUdXL2lVWFliaHdvbDBNUGUxYXcvMEU2U3JTTFNpU3lhNS9BMm5WeFpIaGVl?=
 =?utf-8?B?VGw5dGlBcWdna1dBM2hMSU5kS0FqOGpvcEpYZUUxWWswSTU2SkR6MDJVeXVu?=
 =?utf-8?B?Vk5Bcm1mbzJlbjd5NGc4N1M1ZjkxcXdDM28xR1d5ZEFGREtCT1BTQUJGdEJv?=
 =?utf-8?B?bVYwZTVLRGlmTTZseVRacmxlbFNUVnVpbzFWQklkUlc5U253TUJhd053TDZ2?=
 =?utf-8?B?ZG03TmJxbHFEdDgyWlRyanpzSW9lcnc2ZEx5dkFlWDhGYnBjNGJEK29QZVZY?=
 =?utf-8?B?dWlINnJIamdsa0w5T1RYeERjcnFrc2xjUW1JbG1aNmhkZGpEZXo2RTViVG5H?=
 =?utf-8?B?Ni96em1aZ2drcDkwQlp1MmRLVWVQb2o4NHZLcHA1MXE5UE1CcUV2NFJMMUd1?=
 =?utf-8?B?Ui93SzloWWNPcWZSU1RzS0VFNFVPNW1QUVF3MWFmSGNkVzdiZDBWejZFTzkz?=
 =?utf-8?B?bFRHdWp2bTZtd1hlc0hLNS8xNmNDOXFWeGZGY256c1R6NlBpQStCRFRwUGRj?=
 =?utf-8?B?Mml6dVFmS1doa0VCTk8vU0V4WFlOV01XY0VqUUVTM2hKYTd6S2RuNnE1ZzZQ?=
 =?utf-8?B?eWpKNjlvWUlFQnlKWWl2eUhDZnZnUmRjZGhkZWJlNHdlaFZoQ1IyTW12Tmo5?=
 =?utf-8?Q?qSXSxj+rp70JDItP6l7FboEvKMYEBD/030pM/vQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549bf815-6966-438d-910d-08d8fe3fc28e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:27.5085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LmAvznxd+E5fQ/SygAICcCEEjdqabp1ubNFiV+nkI5CeZR9qCqWHX9NCo1NiouAShMzDWazu0Qw9doqZAm/rY7YV/dTizhla8uGwIdSAxfs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=968
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-ORIG-GUID: nVVD9SeHzW1svv_e4YmZFLNIgw-zcoDx
X-Proofpoint-GUID: nVVD9SeHzW1svv_e4YmZFLNIgw-zcoDx
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 23:09:36 +0300, Konstantin Shelekhin wrote:

> This patch series (inspired by SCST) adds support for the dummy devices
> via the new DUMMY flag of rd_mcp. The rationale behind the change is to
> give a user the ability to create conifgurable devices for LUN 0 with
> custom WWN values (like vendor, product or revision) as some tools like
> QConvergeGUI use LUN 0 to identify the whole storage.
> 
> The advantage over simply creating a NULLIO rd_mcp device is that the
> DUMMY device will not be seen as a block device, hence less confusion
> for the system administrator.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/2] target: Add the DUMMY flag to rd_mcp
      https://git.kernel.org/mkp/scsi/c/0aecfa662e43
[2/2] target: Make the virtual LUN 0 device dummy
      https://git.kernel.org/mkp/scsi/c/1b5ad814af5e

-- 
Martin K. Petersen	Oracle Linux Engineering
