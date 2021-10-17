Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F18C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 01:48:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 644BB61054
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 01:48:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbhJQBuq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 21:50:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:3966 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229456AbhJQBup (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 21:50:45 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19GNc52n003979;
        Sun, 17 Oct 2021 01:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=+cFwtQCYEvl0GbGUS4ZAT4ksWbauIRxJB5d15pIY6R4=;
 b=q5mtMXdc9heKRB3gXvPOnVhJ1/7axFJr9jlO1O6k57OuR8X7hLAiy9nswvsVYKecbxQ6
 EHpNBeBSog8oHNCxauBKWabWvSgtoQXl+osasArrzAe7WpBtnQsAq/E2zcZuK+amtZXv
 aH5XtfHmmUZPHrbwX+VDa3k3Ta/ZKnG6lCtlw1lTc5geMw5WCOqlKD+gZvrnWowopmwn
 JWl6ZjX5tPwZngcekP7g+dPwLDL3pU6lC/5brZt5EqDPg93omS+xJZZHMIfFH4BvGlOJ
 LSzxZjnFmRf8CO57ElYOLWfMcLkdxYXrH64D1RRrd+igLb+xv5h2yMVk+C4DhtsvCZoc Uw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqj6sp77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 01:48:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H1jKhL163719;
        Sun, 17 Oct 2021 01:48:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3br8gntqkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 01:48:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y1aUrDF8air0eWM+w4GGvXfdxsbAccHTIdklpBwBRnP2qDPPNbEMqEngZsd9ihrieH2zV0sWM4uEnFL4dZt66smZ6Mvmor+mxO80YXTmO/unEv5BgHOuIGM97bjAJNio2kFoN0VDO9SDmzw5Ha79q8y9fKvajClMsNT8k7aCRN9DHNW/IND9pBszXRY1k3o3pmNX1JFSw207js03dokz7wzliJKVtcvtV+OhINl+8BHuTqlXFGqKvAZcPyzo/L9dhDoH/a5SoUHTNAzzjZdMp2nuzLeI1K6hkSzcIgpm77JOnXSCWwCR2GFVo2eI9ESx0NjBU6ew+AGETQr8EvNe3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+cFwtQCYEvl0GbGUS4ZAT4ksWbauIRxJB5d15pIY6R4=;
 b=hPOKNWz9XAoZIdU7igVClJENhqmmscTH8OfdLdqCFD86Sn2+oPaoq4jgQJKSV1o344olCMRZPoXbaihrZfbq/61ltjIzs3mT+xKhYPf5w6VpGZ2dsTKErbD2O74Zwkd90a3dPGPKH/nRAVFE7ZvbEXHOwjlnNAij4JU79/Qz/51DW7roJR9e7nzm3K7tnRxRbxITBOJgW+9vWcKNqewr1Nf/VKcIoue4uLG+VJ7LKHVeBX3pDJs2n7zUBMnbbjTza1iIo2GV7AMMbVa0uGuXftt3uJz3jWMKmugaWqXfdPqFGG7jy0WTCexr80eZ/Tl9WcqLxnOrU8rOF7L9o+I5Ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+cFwtQCYEvl0GbGUS4ZAT4ksWbauIRxJB5d15pIY6R4=;
 b=D4NEoO4fqpEqa7EzWyuaiQjj18JsI9NOlOPL+LDNHx3zZf2cjYjtAk/Ey/fPxfEimRkYZE/gwY7CtwcelxC0s1RLuKbtQg1H92aWxakk3Wc4h1UmcKCVapGdv7KgTH+mnhta4VnoYcff+PKN9Z4T/7KHCICxuR9soQffxoy/AJk=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5532.namprd10.prod.outlook.com (2603:10b6:510:10f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Sun, 17 Oct
 2021 01:48:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 01:48:27 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 00/46] Register SCSI sysfs attributes earlier
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k9gifq9.fsf@ca-mkp.ca.oracle.com>
References: <20211012233558.4066756-1-bvanassche@acm.org>
Date:   Sat, 16 Oct 2021 21:48:24 -0400
In-Reply-To: <20211012233558.4066756-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 12 Oct 2021 16:35:12 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by BYAPR01CA0029.prod.exchangelabs.com (2603:10b6:a02:80::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Sun, 17 Oct 2021 01:48:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6eacf047-8162-4013-bc4d-08d9911036da
X-MS-TrafficTypeDiagnostic: PH0PR10MB5532:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5532194E95F1E8F6B15951038EBB9@PH0PR10MB5532.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9hXo77jIKUeZQX6oxO9RgBdkXVCrUpFehpPWCwcjkYl3pO/7gVoSxGy4di4xnQBjCNELtxB379dG+WuzORKx5w4DM8S/9O6QuDXuzbeG7aQxej9T5wp254I1EuoZ3Us4PR62du+u7HStbdC9ydjkUnCz4i+2XtnIQTDjqi2Hk12tnWaNTwi10Gv9eWny7hKH+u4oN4U/FcSlDhbRPSzjf7Pm21GNMnIK0PXKQGXeH9iofu+IO/R9Fs8RZvFwRJ6ueVBZ6MLXbK3F8LY5dlr0RdZKpqMtu8Ae0L0gYzcaIe/VbsfV3O/SLJECheamNKiQKUertDOsF4JYDGaOzS2nTZPMvIQ6l1GzVqkc4tfpnoiVgm8c7rEvgoJOdVRVyZ6FsUoyrrYKX6OKkIE4rvSTF3ZYrZjE/bB3iVW09AbYFTmnEgf5Ch/XA1C4CFiaeyoHvypnxNsfKDzLlNlTRuunEVhqpfCOwlLpyNbatgLwx3+P2q7J9DbAksUiMZ0N4Yb8+UdCqX0IHHjA1xISxGBRgAJ1sZpc4B1UaMPb/Wby5G7FUhU8Px7PKOXLyY2/284RTI64ijhZbJPpHx6lStRj8dpUfhEHapy5l/bYhpXMZn1Yle5VhD7Apcny0PGvJXoPHHtsuGE7CdWoyXQ/rDyDbhN8ICoSlyjld3nYlTagJ1z1a0XpBXF4myIF/xOUwIqBn8Ksy8JE51vVQNMafA0GxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(55016002)(8676002)(8936002)(66946007)(66476007)(38100700002)(38350700002)(6666004)(26005)(5660300002)(316002)(956004)(36916002)(186003)(86362001)(4744005)(4326008)(52116002)(7696005)(508600001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k731HF8M5xUa4oPk2bO6Z8tPvqq14UdoriQIEyl6IKEl5elPZsaPigS0szYy?=
 =?us-ascii?Q?2ltx+Y3Yo62MrK2jsM2SW7jDxjuvVDkZ0lO/r8byNS9Vt/2A692pmDfeEV91?=
 =?us-ascii?Q?73jINMJ1GTUUIb4ghXZiUsXyw3FXx8k5aa4s6zpP3tnPWSayo/O4xPji+plv?=
 =?us-ascii?Q?wD9PGANJM2TY61qEhevDEpJcKDgsvXPiwOBQ/r3Sqwof2Z/DAz/9Lw+v8R/v?=
 =?us-ascii?Q?BtjCefz3ZVyfpXt6Vl8S4ZJ8bSvwzSxSzvPUOEwiKp1BvGlS5u1hI1qIAwkI?=
 =?us-ascii?Q?X9S0Y2ijikeaukpergYQ9hlhmNQ5BqyjOEoDvtq1lH9PXc3OoVnflABB0wUo?=
 =?us-ascii?Q?FVauSIJTD+IjlBdSRGKmpLQKxZQblzZ22uJCaSiFvnosro1G3SqWyoX3NXGn?=
 =?us-ascii?Q?utkUlfI/nsC1pKE/mcPH++FmHsk7R1hD3AXhDBlMP6joqT3pL6wCe5rgTegf?=
 =?us-ascii?Q?t+ygQKoKgLyo9oCDTywt4VDqVK02XLIis4hh0fPTo7P4afWN97RHrdT8z4w/?=
 =?us-ascii?Q?8RxYPCLnK6gejK2Yq+6rIaw0lpGuoPmrrrlmuwT0D/1372DxjVsFxKiy5UdK?=
 =?us-ascii?Q?WEnW0ZslQZv1ZAAIbehNSrttlqrBh+xYL17xDPWu/58oUyV2rX5sWihRBn2s?=
 =?us-ascii?Q?8es4xlsGowcSYfc8+GEaQpuI5ITeo9+uNdzQDnA6WOiRn6PJYM0gWPlt/0VC?=
 =?us-ascii?Q?ykriOyCapYrs+uQhM6YnWqZ6xVOTBbXvResQ+SWxqieqktyZ3kS73lmzeXZe?=
 =?us-ascii?Q?up/nJqf3EHfZpt6VTuDRKc2w8l2loBZf73MOgqjOKVaixuMZ0oSrhMgYt3Oe?=
 =?us-ascii?Q?yps1oowIciS4t0lOcY4p5vDbjIpUBNK9f/3Roq1FaP7PrhQlr8zM9dYbVD7e?=
 =?us-ascii?Q?3ysnf7Gsy4iOJaB6nuIV1EJi3FRv99PDXVXxJahwBxqP2BdczF/0KIjH5PBt?=
 =?us-ascii?Q?4Wmqm5a276MfnVrjx4nQwnUSXnWilcyztD8lmjqAEA7MxmaPEeFY6Z6gXEpz?=
 =?us-ascii?Q?8Sh5ZZZ1jv/onnE60L8eiQf42NvCSnSVuxbqak7I+yrliJYDVo1JDdEokXeU?=
 =?us-ascii?Q?Xn6GPS1QR5KWUVwIbytlr2B6fLm81d4BusKWJzKnfj1FXA5rX8nT3LK0OiMF?=
 =?us-ascii?Q?7WuZ9jMV//jtD6soFpr0AhpmomDzPbeQ1YQpUX4Ff+eIz9p3Wco9OQoNjrw/?=
 =?us-ascii?Q?ZCHGJyw/htXGlS8QovbsNoOL5cKwn71VL5FX0AjiGt3a3+h+9QoyY5p01mZy?=
 =?us-ascii?Q?hN1pDRbCslRwkNsShvFoy8Q2xwIHu9XWzzLgXZp0C03cMydKNKgii69ujjdz?=
 =?us-ascii?Q?NT4gnvM+slaudieY0hsztS3Y?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eacf047-8162-4013-bc4d-08d9911036da
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 01:48:27.6311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wlH3KxQNEuoo3b49FtIBvKYYVjlkDNA3gJWbuxrFjK55HAdHsNxROXST2NvKtMNQdWolTPRo2tYPuX3qEhHPRv82J3CB5czylGfrYR0f9a4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5532
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=971 mlxscore=0 adultscore=0
 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170010
X-Proofpoint-GUID: eWUAcQ-SCmMtZzwMOEW0OIBHWCOtahT8
X-Proofpoint-ORIG-GUID: eWUAcQ-SCmMtZzwMOEW0OIBHWCOtahT8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> For certain user space software, e.g. udev, it is important that sysfs
> attributes are registered before the KOBJ_ADD uevent is emitted. Hence
> this patch series that removes the device_create_file() and
> sysfs_create_groups() calls from the SCSI core. Please consider this
> patch series for kernel v5.16.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
