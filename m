Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1CCC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C461861040
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233740AbhG2Dhj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:37:39 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:15410 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233693AbhG2Dhc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:37:32 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3apYH005966;
        Thu, 29 Jul 2021 03:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vl42t9P/dFNXs5zdQq5ub6JQOPFGXz7tGpGxOnNmWf0=;
 b=HyWgMLDezVEgpYevVHAe8K36PIW/id54r2QfYD6Y1InjPHtQukQaJ2qQlw3eWolV5SDO
 QoSAl1YMYe4n4kjlBDy1BLl7B/qnd7ylrJkZLeisYdDxrJongjXj7SNNr2yuibIdZvBo
 Rl7rmxBpXy9qmwmlaRQ1Yt9GzLBPzCoW2t6TKOhIiySlf5wCV1T7vBX/RkvU6areYw70
 R4BZSXcpUSFFLSTk0X+YRqA8gbb7nlmuY0CPL0Bl2SEPY6MMvm8z235jBmJ3eR1kOMWn
 x8zd6AIuj1QJK8ZPpEBKvH/83FFZaqG0XjmnExadRxY/+oTp4fQ0cYg1Bk1a+ajd7N74 iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vl42t9P/dFNXs5zdQq5ub6JQOPFGXz7tGpGxOnNmWf0=;
 b=gTFHKq0bxaXrrnwIs0Q5fjMt3z7UZVgF4ifhnsflf4LM5Ifs8IUZK2EXstW8u4stf5dV
 CzDBNPNfoNpRXbHd01Ap7cdusaef58Go32SKC5ORkU6+nIIwzC99o8NU5QLzrp6iIb5E
 MdQRejFcs0qTe/nxYPasxN2alE2NtLxEhu3W+YhEjVMbThEfVEP943FqNAydyENn7r0t
 9tsc0W7k3mk1yjFzB7KWRGKeABa1sBdLED/x0wap73wQThvfqYOATmF2r4tFLMnVJHFv
 TQ6POCN0WSxmtS+9xfZdHbWe2Dld+mG3zkmxyW9lqQ8CADkEYQvbBcgKTSTfE+xr/E8H 7g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a2353e1yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3VbDS181987;
        Thu, 29 Jul 2021 03:37:19 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2040.outbound.protection.outlook.com [104.47.74.40])
        by aserp3020.oracle.com with ESMTP id 3a234bew8u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0NtKz+V37cdXVefhtc5HXgHHHVn8xZxcfpeJbAqG2motmPj6vtJ+erInvLq0YmaDA+BlhvxFSKXJavIeT9Z57ZigPtOfrQ3usct8kGaecE/lQThZOM/ekbtyxO1N3EpPPlcUO8/yqsGm4dqhs4CQiAoNuQwYChTxZyTHpsBjhYdQmg/sQ6XJcU2ZmABXtWCUqX/1sy90mlj0Rx2EQvW3lMA7QLTbDMfdUgPGT+WlpfQ2X+YU3W1G0/zUREEEMMc0tVKpUg43nm/6IOkuA3plbxYLlmVBD+8fU4ca6He2p3/MrEUxadSgOabYxcX+jGEkITv9MvJB+KcKY+f4sgjvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vl42t9P/dFNXs5zdQq5ub6JQOPFGXz7tGpGxOnNmWf0=;
 b=gyJ/xb6fLGXnKKTISFgqs85lF68xI88HQI3r8+OA8nBFoIwayGy8I2HcR1uAsviQPPe80O6xAv+v4IISQ6iUbjzsZXp4Ead1s6iEL09CjUFgwTNcd68kKarzytw95ntv/TaZML0Xa8uB9oqzVgE6xLqWuw8RizrX4QJXejv4NpfAXAqr8gO7rp+G18VE1TvI1965LxZpPHRv8KDBoelnz5jK02dpcAPHk5BjQUyv9HEhagElYyi5SpqIs0kOB1kFFsj+N+94DdJtBL7GZqjLpyC9Pbn3bR4kyCILIEhRBskr5Zv9L8Z8K/zEebNImLjMlENEqB3yz8t2LD1R8nZ03A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vl42t9P/dFNXs5zdQq5ub6JQOPFGXz7tGpGxOnNmWf0=;
 b=DZIXvF3iCEc1T9nRCGPMO4MBWdRKjvUbbIHgRY9G3IBVNPhX9X3WIYs1RGsOP2jStT12IzbAg0oTxh4KpVnoBy13TMojcIUSTaCndpxhbK4bGty0vEBvHuwIqLSE0mh8t6sI2ihaIiulL9gtFn3dkhFfqLO6ej8z9sowfeGsv04=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:17 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, lijinlin3@huawei.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        bvanassche@acm.org, yanaijie@huawei.com, wubo40@huawei.com,
        john.garry@huawei.com, linfeilong@huawei.com
Subject: Re: [PATCH v2] scsi: Fix the issue that the disk capacity set to zero
Date:   Wed, 28 Jul 2021 23:37:04 -0400
Message-Id: <162752979290.3014.18254427496615744471.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210727034455.1494960-1-lijinlin3@huawei.com>
References: <20210727034455.1494960-1-lijinlin3@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 277b2afe-5f14-4e48-14fc-08d9524229d8
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB154997B8A6531FC828EAB8CC8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mtw+VLahcheFaqku52UkpD2kDomSsCmrrmKfistAE9oX6RhE0LuQNl7ZOz8wD70YBQk7ssHMngJ3ZaovH3bZJq4qIVzoUtIIHVRGpqfkOMvOEv11MKmgl1vi9dVSw9n0CiVlo7gGWRDLM1gFfvqPKpTrsi5zpyvQjS/YFVpFECs0BsiNoVtNeipAmmJL3psPkOOks3hchVus7ByUxUHe//ivZqgrC+4scB7vjpaSmGsoGSaXjWziGcqfkITmztu0jxMKL6W4WYP1gVZf0gph9FO4sCUZVyrT0x5FQ8lfsjYJsp1TJ3QCGh3NDqyfoQix9HCddZE1FvXGATt19p7xIqvF4wcisFEv6Y+T5RvBXiMCV/whZjvTOiAixcXv4L2jdCS3ol0Q5Hl7NWeNl69IiWgVd60Hva9pwHXCC176o0+9lflQVdfEaXNPfds+MexiIM7vj8L+RUsDXEnW/SUqglxtBDARuO5GXQXg2R1e+Ub0FsXbssRS303fS+XIKXMico333XtaSvPVBN41n3LFjr9edNfw/UmGB2LeHYtZJWQyLYR+T83+6cKClu25QMuhDQmKiucUJfJrR4IyF/YGjDBF1IReDMqS30Rkyeqda+nEI387Fj0+qAK3ZNrhFbVwI6IsZk4yahXhaNeEGHyOSWFeEINFgRx0PutHW16s567DpXNkgRs9V4LRh2ECktceEqBbQSEgcdxVhefbPK9d6PcEZhCPa8qu8SoB7KHx/yBTHFyEtiiZMTF0uA4YdK9AtsN8TC5UiBs2IJuYRQqMEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(2616005)(956004)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ak1HeE0zN3I2UCt3YlM1UVQwZ1hRMTg3aVlmdFFTRjUzUTUzaUU3a2VFUGJi?=
 =?utf-8?B?ZGV3RHl4eFlBYXZETWM4ZmxicmdQTTE3NHJZV3BsNTFKeTNxMG5PMzliMlBs?=
 =?utf-8?B?NFVuM2RGL0xXbTJ5ZzFFMVU2VkgrZGUrbXQxbkx5aFhuVitYS050M2o0N05H?=
 =?utf-8?B?U25GdVpsY3p3MlBjYlAyakQ3ZnhlV1RGSkpEVGh0OWFQM0tUR085REdRSGlW?=
 =?utf-8?B?SmVtT0I4cCtYNHBuczZsN2QxTE13TzVaUnc2N3kzSmdVV3hkU0haZGFjblRV?=
 =?utf-8?B?K1FpL1NMdjBYWGhxdDduellJRTE4U0oxaVczcVA5cjBOcWRld0liUnlHZ1JU?=
 =?utf-8?B?clprV0hFYi9vWVIvMnk3cSt6ZWc0N2xNQVpBUWRhN0tKTXpHcFdzZy9DRVNa?=
 =?utf-8?B?bmtMNFNKQlpSY01Od0tERFZ6UDNnRzgrQW56WHpjNjQ3alp1TUN1eSthbmRN?=
 =?utf-8?B?TVJ1ODRvbEdsR2Y1RE9UaXNPMzFhdnM0aW93VTdoWVdzQ1VGREpiQVhqUjBB?=
 =?utf-8?B?LzRzU0QzVk9VNGZ0QjB3Qk9SbFRicGdZc2lNME9ZUmdHYWJPdFZDbmwrNE90?=
 =?utf-8?B?ZWpGbWsvcUF3LzF2QUVIMk9oSkw2YVdOK2dGYzJqWmhtekNIb1dvbTA1bHhm?=
 =?utf-8?B?aXF3b0E2RG14QjlPNFRONnpXWUh4clg4L1o0VkI3T2NVU0UxRTh0aXArdDZ1?=
 =?utf-8?B?aWthaXExYW9vd2N3c1pLbm9IVUExT1JGakpaSVNoZGFrQ1Y4YWFHaW11aTI5?=
 =?utf-8?B?a1ZYajZqNExLZU1oenFhS2ZRMXBWZERKUENycXQvN0tPQTBzdEhGZG44NDhi?=
 =?utf-8?B?WEpBRVNkNjQxMzRoT0tuRy93Znh1MTZrSG1UUHg5TnBVak00UW5kblpMK2cv?=
 =?utf-8?B?WHQ3LzFUOG0vWHEvampkNCtsSHN2aUcvVFQxMjloSVA2UGFtdzE2amRtZmQ4?=
 =?utf-8?B?M2lBM0JpM1h5MFRnOGo5WmdCVDc3bG0vNlJJNVk5ZVVRNTJCVUFlSzRrMmNG?=
 =?utf-8?B?YWUvVDhvSkNXWUVlYkErZXkzYjdkNUM2bE1wVEJYTE1kN090blNtNFNDaVov?=
 =?utf-8?B?Q214OVFHNm53bkdKZHZzMWJibHM1Zlp6SCttZUVPcFBqdTYyOUtCdzRJdDBZ?=
 =?utf-8?B?UVJKMmNrdC9PMzh3c3lRdFVCQ0FVNW0zM3E4aUNpNFU5RkNoSjlnci83QTh5?=
 =?utf-8?B?UVA3T3VlS3BONXVJTGsxQnhSWEg4OWpQS0YzSGU2NEQrNzBJa2VodHU5ckk0?=
 =?utf-8?B?ZlhWTVJsNmFWVXk3ekk0YTVEL3ZDWHZBZmVUeWJaei9MYmxGNjdDbHpGd3Fv?=
 =?utf-8?B?dUFaaVVxN0xPZlhFd0FLUDRxOWF0S1ZkVXR6ZU1HemVxbFNnVmxaZGxubVB0?=
 =?utf-8?B?eHhWNGlxeUgzai9iRWVaQTBRWUNQRGE3elRmVlF5MXR2QWFseUlXa1Jlb0JZ?=
 =?utf-8?B?d2dmV3dmNFVBdFhMdjFXVE5QTllQQkROeW9aOVNMZFpyUGJ0TXEvMXBhY1lq?=
 =?utf-8?B?YWczd21BYzNnR2NJQ0UycGFLbUFsVDlrR1NsekNMdkZkSkFEdTQ5UUd4R3FQ?=
 =?utf-8?B?aTRWMlU5SDVpYnBnU2xWNE9OcnhORElsV3Zpd01scHBYb0lKOXkrUE94Rlgz?=
 =?utf-8?B?TnlTQ2lIZ3BUSEw0Sk1mRDFPZklrOHFtTVVXL2dCak5PL0VKRFFlUW1OU1dt?=
 =?utf-8?B?L0hHbjVpNG90NFRDdiszVTgvRkJndEptOS9oME4xQVZSOHU5eVB0SVBnZ0h5?=
 =?utf-8?Q?/DJ994E4JkQ/mJ4SGENWfGAbU1dJMdhKpJnTjST?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 277b2afe-5f14-4e48-14fc-08d9524229d8
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:17.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PO+9UNUtU9HLD8mBGmloa+dlSD2zZrBMa7YvDqhUMs4JXgtDjjUSLKoMgFbHORu6Z5T/JGMZyoaCHUae8XYPysoRFLTGpQbXz8aK9xY9te4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 suspectscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2107290020
X-Proofpoint-GUID: 60S3A1GwOBkGNpCN6Oms6QMLO2M6O0gh
X-Proofpoint-ORIG-GUID: 60S3A1GwOBkGNpCN6Oms6QMLO2M6O0gh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 27 Jul 2021 11:44:55 +0800, lijinlin3@huawei.com wrote:

> After add physical volumes to a volume group through vgextend, kernel
> will rescan partitions, which will read the capacity of the device.
> If the device status is set to offline through sysfs at this time,
> read capacity command will return a result which the host byte is
> DID_NO_CONNECT, the capacity of the device will be set to zero in
> read_capacity_error(). However, the capacity of the device can't be
> reread after reset the device status to running, is still zero.
> 
> [...]

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: Fix the issue that the disk capacity set to zero
      https://git.kernel.org/mkp/scsi/c/d5c8db0e5cd4

-- 
Martin K. Petersen	Oracle Linux Engineering
