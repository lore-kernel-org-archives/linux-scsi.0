Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0665C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC4D6135D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244102AbhI2EWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:22:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14518 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244089AbhI2EWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:22:06 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T3GPA3017419;
        Wed, 29 Sep 2021 04:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=h+7MRpYfxNCMFQFHVBqoE3NwAtHmb2Zsnps3AY8tbG8=;
 b=ScQeB+SokWMByEPvb/CuETUE3u/tFliQWExzLu+VmILMIuoOXGseoteDD3XX0XOyJpuX
 SuOoJrw5I0gceWhCzqKxoDVHm3NwfcNJUOUOfwVbjyQ0DrM0He/jXD+282u1hPylo7eM
 z8tWxjw2Z1ZIx4XLoCf57091xZtwGNpJzTiqE2dD9bJnscow3xQN3BNTXXzyw28I4+nS
 FgjonyNLCp5E31c1J1Z645nlaTcP3CXpeqg5Xu9PdxRSgbsHKpdFsiermJTgw5bQ+u8f
 uMqB3/of77B8629lw13744UNrtXiRoqRHUppr25kn4KiTkUPQ0wA4PoiaFEV79+Mx7SX 2Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcg3hg7ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:23 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AUV9030883;
        Wed, 29 Sep 2021 04:20:22 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3bc3bjb7h0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebSUMP4dWXoqU/7MYB1LPV/9VDmCKwlJuH/MhxKUmpZhxjWxFK6z1fvp870kNCN0u4OLAFPtv1TFJ+BKDu976lrSak/ZciifB5Uvf2DOuiUqM23MGSQJ96uK4fRN4lZwi+JfTLM6hqRdUJp+CxZX6xAjp4S3og5YXfRc6MGdqboCm1VmtBB8epKgjQI+SD9fjt7CTYUDhiaIYOT9mhzFeBk0ywgf9MIfk9vzySw4UIoVO1JcL2KBkBi+irVyPi2xsFxOlgZYRMLfps2OvVm7U22i8oNLfgQgnPyHAYU3XA1xw3YYXbq5EyHz2tl5SLNOOlRwBvtuc8lBzrEtxuJf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=h+7MRpYfxNCMFQFHVBqoE3NwAtHmb2Zsnps3AY8tbG8=;
 b=XfXbbeYQ8SqxNyrIJmYnhu5sByIIPpKuRlbmbiH+kY0MRXFzTJUD2XEj57juOlMPjaOR/pqNYXkx2nzbld0/BWRFmBcHFuqDGA9rMSJC+ryaVNofmg4pS1FurN/raTEy0ot+ui/7ootd3u7oHye52EKj+m2wxs/NyEZFLK/tvkGrF5iFuUqisxcaE0tGuH4MMVmV9PPpQOjIZUJDSiWNuhtCGoP7fqF9XYcFDmOg6XaKVB4Haf9z1zm6t/nkKaqs9GrqBehj9Jrx5RQ9n94lmrau1tDHnfu13xCnNpqC/eTh6lk0m3Ol8CtGcOLj9kAvigxKEV3t8iQ/zJobLXrQ0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h+7MRpYfxNCMFQFHVBqoE3NwAtHmb2Zsnps3AY8tbG8=;
 b=AxAOsTOfpkmHLM7ottwbD7aivlsgIKVrALr7CxO0ydKOwEhZRBrNaiLKcwTrbmyha7Nd7zSxkWDghA/G5oUVWIcVlPDE5NxYqC4GfK0YtWEIkKQZdHzFtfGGs0jCGwn6UZNsqjQ8xD6BoLTY6/yDje7jC2uk5JBvriSARex+qTc=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:20:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:20:19 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Remove include <scsi/scsi_host.h> from scsi_cmnd.h
Date:   Wed, 29 Sep 2021 00:20:13 -0400
Message-Id: <163288294651.9370.6747368721693453543.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210917212751.2676054-1-bvanassche@acm.org>
References: <20210917212751.2676054-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 04:20:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bb16f01-c983-48af-ccdd-08d983007294
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4551EC093C98465D09FC20828EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9CM14QYs6eT5H3kQfjqq/SgvaIf3IMzr0gUX91UBWR88o+o5qwyaLBFwcvdXVTIPXkPIzjM8xsEB41PT2AzP8/3GEMWk5fplU/jpN/Uvex3PcHUFdoEP3hHwfMNcW1ZrWltSb6wVBLu1D6F5tHz+1Fpbn8mmLaMhjNTNOI8kyflsJluMBAnQEuoRw+CrGYf8cog96RL6dJPTIh/uULOO8yyH3QOxYuo8ZCuHRmBW9YWiNXfI0L7n4hHggs0JqTBNzqjyoPNsci4w2k4BDshGLUIWiThTl3BPaZ4S8rr4Yu8V4KHSc7s4zpDWFvdJ5xBqh0HWFnpHTIduFZV2T65NxYeundRhp3GrVoZWC1mP+n3RmSbZedjseEK9MVSQzPvjzi4oqAsCBcRr2637A/8lqkvHFmH4e9QBXK7SmEn4z0pvPpGdx2cW8nCzdZuWFEA5rtP+1RbTxq4xoyd+BgO5IlplqtZ/7aG6w2+pdtMg9Cwgl1oseEan1gmKBz7Tu9QKkRC9tD+xHUHP3ELM/H/FC3wM6J2wPuR8pykwJ8ZQFuaSSS3GWPaZpBKgMas1JHKfHlB7oPXys0gZtvNfm1uO6G2ydRyD9owNVnP/z8VbW/BJTVxe3oSMbu/SunLSDVXNgRphwWCGd6G1bnlYjNatkr2nnuZz5hgHvdrdCbzrJXbJoRBBwLyS5GSxvT8ya40aIXLyRQAHnNCDwaU1/MmT5YGNPjmusxifeKSVux53Bd34Y+cnJHF6+mtHXXkxNPt060Lj5qb/MnW8X4n1IPsySRJKPks1badbMVbfaBrC7Jc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(6916009)(2906002)(26005)(508600001)(54906003)(66556008)(66476007)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkdsR0NzQTB1NXR0SmN2emZRcUdRalVyOFJWMWJKV2JCaXhiM0hwaktsWTdS?=
 =?utf-8?B?WmdpcGpIWURjN1pkNjl4OGVGYjF4ZSt4TGppZ2dqUE5GVnhiMk1aclNHL2pu?=
 =?utf-8?B?SitWekFPaVdMOG5UUUdaZWg5ZDljRGxEcWhReUVlVkVOa2xSNDlnTnhjZWM4?=
 =?utf-8?B?NTV6Y2Z4cnNmdlJoNjQ4eDF2V2IxdHJ0bUNvQklaZzB1R29rZUxUSkpkYUx1?=
 =?utf-8?B?TlR2YXFSUDhTNjRKQS8xeDlMOUFkQjd2Z1pUcS9lazAxZ21PVGJxUC9OUk9P?=
 =?utf-8?B?Tlp2ZzNkK1gvVmYrOG9xUTBiTWJOeXJIL3Y2UW1YSUp6RDRlaVQzSE1SNXpV?=
 =?utf-8?B?Mml3TDRUaXo0bzBmUUwwWEZ6b25FVGI5eUVYWitodU1TNWI4WXJuL1BkWTlF?=
 =?utf-8?B?akE5R3VERWRpNDVrck1sNWZ2NGNHbms5UVNVR2FSb2FTZlVaN2hLVms4RXV0?=
 =?utf-8?B?b3VITjBUSkNBSFAyVUxzbVBpRTdsVURybVI5YS9YRUwvdnlNWVd0ZGdqNDdR?=
 =?utf-8?B?VGUvUzlNR3I3T09rN0ZPRTVCTkVIUHQ2NWhHY004NXl4aitMN2dEWGJIUkJV?=
 =?utf-8?B?SU5QSGhKWWI4VDlScU1FM3NjdENCRVF3c2Ezd3pzZWFrelRGQkthTWNJNWVi?=
 =?utf-8?B?RzRCd2JxdUh2RWRCZTd1UVFMRGtQd3VjUnAvVGVxckM4M1F6eVQ2aW9ZNlhn?=
 =?utf-8?B?RkVkWlllN0FudXRGNmkzT1liVm1xSHFZcHFIZXlLV2Vjc1ljS0pvbmZwaWtQ?=
 =?utf-8?B?RkdzMWJ3WEYyaXVJcXRTU29pMGFwNlFBNUM2TzRIV1JKRGFoR1UyMk5jSzRQ?=
 =?utf-8?B?cDVHeDgraTFrZ3JuRlp3cGV5UGxrRTEyYUF3eS9vcG9la0xvdGxQYmxoUUhu?=
 =?utf-8?B?a0RLeisreHBZQ3hrMmJBSXJuY0p3YXQ5Y2NPSk0yWWtISFg3c3l3RXlyTW8v?=
 =?utf-8?B?UG5kdE8wMFpYTTBmT1FuTktiQ2ZpK1R6M3J5aUk0aVkrWXpCUEJpajBhSDVs?=
 =?utf-8?B?R1FIcmhPQWR3blV4eTVxQUkrNWNPMHdBd09qUXJOSGJWdFdQTHpDazRLWjBv?=
 =?utf-8?B?Mk1aTlRER2xtSEt2WHNwRm1uTzZmWkcrU2VlOXBXanRKMkkrUFk3a0h4OFpT?=
 =?utf-8?B?ekhibUV1dXlNUVg0VERIL3RKV1U5cTV5SXoxUk51bEF2TCs0THZHZ1ZsUVJl?=
 =?utf-8?B?ZzRqMmU4T3FiRjNjSFErL2Q0Z2l5eHZESXpONjNCVkdUbUZYeS9SMkFnaG5E?=
 =?utf-8?B?UjAyV1lkWHJCR0ZuRlhwby9GdTRLdXNZZW1kRTNSMW5xWDBUWmdOQ0hLMFEx?=
 =?utf-8?B?NzNORUlRLzR3Zk5COEdRZEh0ZWpPL012MU1qMmh4MHVuYUs4Wnk5N3VXbTVX?=
 =?utf-8?B?UzFNSVYvZ2NlSFREYmlZYVhqMWR0aVZWZ1lYSGYzNHdtWkYxMEFJT3BBbk1y?=
 =?utf-8?B?VmZGRU9xM1ZjaTFkVWJ4cXpLTFJZTU1XTlJHUHdoZ2FoOFFPQVVwR1pRQmY0?=
 =?utf-8?B?U1lEcm5NVUdITlNlSURKbEdtUGdQMGNQR2ZyOW01UzR5UVR1bk5HbHk2Z0tR?=
 =?utf-8?B?VTYxL1R0KzNBdndhU2RyZit0cytmUk8yYzh0ZnE4eXdlQUEweGZEeTJFZDd3?=
 =?utf-8?B?YWxWeDdrWjdobEFmSGNXQTNRSjFhVkpXNWROOGtRclovL0pBMnNhNTNWTm5y?=
 =?utf-8?B?aUVSWmYzVHY1UWNSRE1kalZSQVVFRm5MbWlyajh1YU9sWnEwc29BQm8zNUhI?=
 =?utf-8?Q?I63TkjxXJYksSngeY0K2utLcAueqZhh96ZkDtk+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bb16f01-c983-48af-ccdd-08d983007294
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:20:19.7160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZs5hN0eYqnG9qd6yFtLSxVKHi0yBWmR8JUTQs0ikjQkI2finzJ3tl1rCB8JPoJto9B5+I6h2U6OsMirkmKZChXHLENt+sgMwvdoRLk735E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-GUID: VPYN2m__3L7CXrJLnLzkgnHVa1jesNKP
X-Proofpoint-ORIG-GUID: VPYN2m__3L7CXrJLnLzkgnHVa1jesNKP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 17 Sep 2021 14:27:51 -0700, Bart Van Assche wrote:

> There are no dependencies in <scsi/scsi_cmnd.h> on the <scsi/scsi_host.h>
> header file. Hence remove the scsi_host.h include directive from
> scsi_cmnd.h. This include directive was introduced in February 2021 by
> commit af1830956dc3 ("scsi: core: Add mq_poll support to SCSI layer").
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: core: Remove include <scsi/scsi_host.h> from scsi_cmnd.h
      https://git.kernel.org/mkp/scsi/c/a7c052066986

-- 
Martin K. Petersen	Oracle Linux Engineering
