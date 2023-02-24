Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D1EDC7EE37
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Feb 2023 17:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjBXRpg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Feb 2023 12:45:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjBXRpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Feb 2023 12:45:32 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCED3144B2;
        Fri, 24 Feb 2023 09:45:30 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31OHhv3r019887;
        Fri, 24 Feb 2023 17:45:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=hO06dapoZ9ZkQfiFC5kiCHCW4OVSoWiTU5QV+MPVyTE=;
 b=B9zAdHP3LlkMsoXDpmPR9Tfrn3JypaS0WtNWNyCqY9xZomD6uL+LS+2yok398I1H5/vy
 HV/tCIEo0wl53QOIrALSj19b9WJVQyKerN7Az/S03ehhwRKowWB668SDzc/nJfMXekKq
 mIzPRf2n3KmZeWD/n8H0yzXYjVhuC6HBMMiaF6QNjAUeAt7EjYbMTyK62uR6GkegOlJR
 PBAJDZRCFZfObn3aRnEG3KyuYF6jfJoLHvbOvWe1KG7lJVC1H4CxJ/j1l14+hCA96thZ
 vsVJXKrvN3W7fy144I0FdWzVPau1egdxcGD/5D90Ss9y5wTXXgVforT6Zbtu6SE5ZyVp vQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntp9twu3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:10 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31OG0il2030220;
        Fri, 24 Feb 2023 17:45:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn49ssch-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Feb 2023 17:45:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ceDVCzNZXrVycDdz8H0x2evZIx87kHYKsjV+NE/oJjnksLUUjQe8iD0MxN4edI5HY7wRG1qNMW97rQPbZjdduBN4kGCoe8jMc3O41AX1rOGj2I4wmrgM1IvlqHv9fN7oVce78i5vO9noNf5RyeQpVCx3P1xFcr6uFNmVLYdhhogdcryse0cYn9BR8qq9anoGEV88Msfy/ty6RpuEKpG8/pmAeRIsGzLnxmpirCL2oTURzkPE+nfei1vlnn1iMcIWXRleAsLdjxK/uHuu6+ivuwQ43PS4xpZYS2+CwD2J9kRV0s4zrAEfj2bFK++a6A+BhmOQStFbxbYHEwnnTTq7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hO06dapoZ9ZkQfiFC5kiCHCW4OVSoWiTU5QV+MPVyTE=;
 b=h8eTFkaLyhXlUDH07FYvplKvXkBjRin5h2b0iX4HiTZkjwf+Z0X77PyvDEXMPvqaAMRztLyaQRpss/Mo5/25WDnnF3a8f0HRD7hu3OUrpb9G+Oo6+a47wsXPX6liRJnpW0psRDD6+cQtNigbowzKtjfEBzTeOfxOJMiye7AHqMlAetOTgnIUCPQ4QE4uqSUhdTDyVpoI+ONM2YBtooG1inDOtChS16047OFSafLGOsCBmo3Qp4HRSaDwiDRS0H9z4qnq6F67wGa1bAOm8UH4JK0LNymBuaNV2+0bOIQiJpk6j/8szH/NRrNXGGtZhOrjgJBAY7tNm9GGpXTHz2f3lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hO06dapoZ9ZkQfiFC5kiCHCW4OVSoWiTU5QV+MPVyTE=;
 b=gRdOSgCyHkUemd5eISNGU16yrw+LDSTOo2ynfqRymAqivah8wZCjJDCOZxT4+2jVO/JNKO5iqqrEw2vJs4Mee2Um9hUMO4BEU3JDpqN9tm9uQ0RYqKZDQp0WAEI1iTCjtI97n/3YnuGFqV279NZJwM8z1QEjLu9rix9nQPqfv4M=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.7; Fri, 24 Feb
 2023 17:45:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.007; Fri, 24 Feb 2023
 17:45:07 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>
Subject: [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to BLK_STS_RESV_CONFLICT
Date:   Fri, 24 Feb 2023 11:44:46 -0600
Message-Id: <20230224174502.321490-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230224174502.321490-1-michael.christie@oracle.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM5PR07CA0073.namprd07.prod.outlook.com
 (2603:10b6:4:ad::38) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 68f8e0a2-2b32-4883-aa55-08db168ede6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X9XAqsgzG5j+pFiDpiU/C0eBY78BZ88JPUg1ZoXDC2brd4EW/f/DASSbFQBp5zeZ96wjMNfZrIRModLg1uszf7ZwnK7W32RAJ8kY76VoLaFHf7bagar2lDKkEULutDH3yAHkSt6bV1b/WLEEapzC/ZW0bMaxZwr3O1Tjpypa/4LS34qDrJ3jLpUwmfBSoGGddfJBUA38emQaL/SmnoSVa9xFiOJ62/X3z6YfaMf77J3NBTz670Db/su8tbrBOSTp8ndtlI06WgnAiW68qfVtIW3cF65kGemHuVOhdw/JGSQny+wUWqoPeszva0m7QZaM7V2jgfNNAPYvX9bakm7bRMFpE5uJxkQpVpT36AV1oNjtCBCv7uWOlAgBXnn0YRsqUJ9MDTjo77gkH+FC0yikr1kgLHTbjkFzGITcQNO38cQsDytCrt40f9p87ZL7KprBZqPWTgnWb49A5zlrYtU1usJ1Y3jKoJngg0AZakrKG1Qchjpt9BAmIjumnURBu/ZWjwD15DydO0nuU/PXqs0wEKYmzJxqPoQJcQSLldyaMAE7XFoxSfab2jvB5CHlV6XJ7Jl0qvxpBsyF0rwCg+2mP6tBcxlQxxuVV0Ki1PcKYsU2SSHHzf2Kvd/alEc6Ao6PpwxavgdXLwMbIEd0C0ORf9KIyrX7S/SEs/iiOQRoWlBngDdT60kWaMUYDtH3WSmK
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(376002)(39860400002)(136003)(396003)(451199018)(4326008)(66476007)(66556008)(66946007)(8676002)(83380400001)(41300700001)(316002)(36756003)(186003)(8936002)(54906003)(26005)(5660300002)(2616005)(38100700002)(7416002)(6512007)(921005)(86362001)(478600001)(2906002)(6486002)(6506007)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?r65rg5VhulFr/T6HFtlP2/vWbJOtBuf5GYHtF0q1uputJ5UBZx1Q1hEs/3w/?=
 =?us-ascii?Q?EtH/+70niLsgWJkb8YUqDXnlENT7uh4z0KdIXEKcA0yxxktuRNZTzWKxk6pq?=
 =?us-ascii?Q?itDNbIA9/0jA3VcYSH3yAxKqPaUpuDvVfX46yiJEhI5/KPO01Hs9siWGG5oA?=
 =?us-ascii?Q?kacFPZ5KvTvKXEKpT71asDeeHDhX3DyvhyfwBv9hkXGeKAlSHc+egUKEebvt?=
 =?us-ascii?Q?4vKE9ro/Ry6m9JEeE0DI45Ba8IVsOzDR5M33+QxKmI9iSMqfuNZ7cOuRk7I2?=
 =?us-ascii?Q?naT9+Lk7mg3u8W0MFFpFnqCh59+S2828lO9k9IeS4rpXZZmllPEiBCpfpfRK?=
 =?us-ascii?Q?LpJtMLzzp5GYgAX6LfbYGs+kRteFknKNb2lCAjhl4ZVFkZmC/O1qG6BoPfTW?=
 =?us-ascii?Q?W+Fjg51zd0mAVupwShcDIoa2RThsGGg0KikIGUYgMT/UpyjxvDG1mWLP1uwT?=
 =?us-ascii?Q?WdejkYZ5dOv89sVYshDTX4Pm4a2Eg5fhCUQtgrIa0+sA4DqXQRwg04y/4lmq?=
 =?us-ascii?Q?14TgP/j8/nR04pmsZzMgmvsZuo7ZEMGkGfDZGiI1iS1CErhGnyYR10gRLt5G?=
 =?us-ascii?Q?x8sJcZFbKOQpkl1ElvCA0mEdvD9eoGeXyj0IaM1YHlZHRbzJmxnjReVwn0DG?=
 =?us-ascii?Q?IiWDbiue9mCXlZiUCw7oIoaAIVa6U74Bjlog8OxIZObtXWSY+QBxO/zauc4R?=
 =?us-ascii?Q?3cOHwhmPU5EjdY/UBm0b5l7N02crO018ztQPEWipgC8MCYZp4ajz4qHgAXBL?=
 =?us-ascii?Q?UPN+GlJ5VR4tdcVTIHdvsLUX5Bddx7l3iQyausv9d4+ETRo8LK2GEwPzDW07?=
 =?us-ascii?Q?cM/i4uAuQ4TelhAMIFEYRywLCfNp2FAz8WMQwwEcM3c4sqjuSNZa2HKSlYPi?=
 =?us-ascii?Q?VGtO/KCZ/FrFy9Ot/AdySeCIb5fV2V7Wi1zJZd7WF2di2w10Wty+dnY/gNUS?=
 =?us-ascii?Q?wjJPhF7u53iiGWiNB18qhH+CMfs+Jh81oDaBbXbLUeyZJsHGRa6M7/zSniUf?=
 =?us-ascii?Q?0aBjy0qhjEDeLcNbkO2T/gprKMVw5+EvgYZsjDuj7PKxMlBDeW4LJmkUNru6?=
 =?us-ascii?Q?Tx/OdnPjJK3B5ttziArFecovIhJ36gheyTVVpLMM67WhDHfSc4VfBnEFrXXh?=
 =?us-ascii?Q?IX9SOQORoMCUXnJJdDYsZEc9iFL34THN0+VFhTmKLlWnT0m/CuZHs1i3GR+1?=
 =?us-ascii?Q?YpF0oMKIGVbfpdWIzmrgpl/qqlewkI9dfaSBlmz4jT6E0uYbqFPsYK1y6Uvh?=
 =?us-ascii?Q?CXRjwlWI5JlJU+tbkxrGEOEJLfkWm9V2ORm0i3eFOVVFUS8Rs/Db24F0e4iy?=
 =?us-ascii?Q?CL7Jt31lBrlBjU9kb0hvjmpmYVy5CXqtnTZ5+IImjOzgPNklEhKmFyQ1tXuD?=
 =?us-ascii?Q?/BSjNaCP+RMw4e2Ax8kBAn6oBVm80TWeekGUxr4ah+t5u92wGhz1Iy4dhb1K?=
 =?us-ascii?Q?gX3Iy90fmUXfYiNkZH9RPHrYfj36m0VXtSa5fZt+xS3dbVuWBi4icCkm+QCm?=
 =?us-ascii?Q?4J1XZm0OOor+PxDL7nDjp5SSAZX7gZmEhCeQH/azTcfHshNmbWLItU3dU4sZ?=
 =?us-ascii?Q?VaV+26WK+k/VhdoCxBAHGSOpgCixCQoKESjAIaAP3/EEoyjNTQINmAvxT33x?=
 =?us-ascii?Q?sg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?FSEj6sKsB0K2IdHRVA3o83Qduf9aFlWSnMGc8+4bm15dFFesABn7TEfL2MUk?=
 =?us-ascii?Q?ORSZ8P+D+Y5izX9rAlh5wZnZH67gPZJLheP7tkrytyBCZOSjpyt88DtoUPP7?=
 =?us-ascii?Q?MC24kO64lV5qg8ml6iTrKO14rZFXdVTtk6peD6CQURS246VSkDbXUwMcKY+k?=
 =?us-ascii?Q?WNlGemUObMTEH66skEnHt8tqgpBdBqq3Yijm0cNZlqN9XHRAFqHLmKMpTcA3?=
 =?us-ascii?Q?0Bsm0QKU4iNA88pg9OLL1sxGkgQTA9zmsCkBRKxI5UIO50blNYqMxGHhtNmV?=
 =?us-ascii?Q?D5+XWj+tJp15K2iL3nbEBLJnuk9Hrg5tpDdYq2R7o4oYnnNBj4rOcSmVNVnY?=
 =?us-ascii?Q?ulKHLUXFvXaWS/VOlcb6rAPQN4Rbh2sXc0w9ou37EIFR6RnRYGdDye9zY0Ub?=
 =?us-ascii?Q?Fer1+GqELmPCGIlnONZ/DzhQdTe22KeIMaKdkksFUM9xYkV9kmJdDeB5Tqte?=
 =?us-ascii?Q?Q8cRYIpWFTuSiwyrVxB5YKRD6cqmD4f3iZxoBb6Hx7NZRVjx76BGHw/S9uVS?=
 =?us-ascii?Q?N/1vH3SafOdjXnv2jePcx+AvsznkfYjv9pUhzwX9Hsj1KsH1wEKJRt8l9Vtp?=
 =?us-ascii?Q?X0opbZ904w4/imtT3+LQSg27210iZ9FN0ByWunbDdbLNARVxBvoySjn98/F5?=
 =?us-ascii?Q?llTSyTukw0PFY3YiIT5Iq1AmFEHJmJOYErQ/Pb1IRxvhhZheMMZ47l34KlMB?=
 =?us-ascii?Q?fvVg3kYXgMnq8JLxzgguvUIDWHH+7deBPakQEpptM7aiYEEauy5J9hXj6NIk?=
 =?us-ascii?Q?OeFXxExRd8x/AgRZiQWeeM5VjL2FEdTC7jxhpKzsjISdLtQzkRIk+r9IZUQE?=
 =?us-ascii?Q?nddqabQx8mkVBpNMbp4vx37GVxgKAu6kTWL9iPgrimxEDmaWNbOUUptm4kHo?=
 =?us-ascii?Q?mbgw6MsFZRWMF2ZIvqaiqnOMwmmykBAyTbRe+b2oDEtjnLlqRRXUL9W8zUB9?=
 =?us-ascii?Q?wue59EjJdlzcCcYe8AHoRzXKOzLUbV26vDVYkj+8cJPLqczEelapE0t7uC77?=
 =?us-ascii?Q?cxMG8VzcRDH2KbJjJu/RxZ4lOa75xY4mVieCcsMPLkV8TKiom5HC15eNiX+y?=
 =?us-ascii?Q?OhU66WLh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f8e0a2-2b32-4883-aa55-08db168ede6d
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2023 17:45:07.7515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mbSkSJUvrqAnyVeywt1Epo/BTP4nnSqba9Bz9EePXeP9mAeyxBLNJ6rRr0voXPFZ/I38PBEBjVgwOC7spkrY4abFyKCrNTCEfNG7GcaU2us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-24_12,2023-02-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302240139
X-Proofpoint-GUID: 18G97uzfIZi1UU6BSBZ92MYP8zrOMy_i
X-Proofpoint-ORIG-GUID: 18G97uzfIZi1UU6BSBZ92MYP8zrOMy_i
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BLK_STS_NEXUS is used for NVMe/SCSI reservation conflicts or in dasd's
case something similar. This renames BLK_STS_NEXUS so it better reflects
this.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Cc: Stefan Haberland <sth@linux.ibm.com>
Cc: Jan Hoeppner <hoeppner@linux.ibm.com>
---
 block/blk-core.c          | 2 +-
 drivers/nvme/host/core.c  | 2 +-
 drivers/s390/block/dasd.c | 2 +-
 drivers/scsi/scsi_lib.c   | 2 +-
 include/linux/blk_types.h | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 82b5b2c53f1e..4439e68064a2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -155,7 +155,7 @@ static const struct {
 	[BLK_STS_NOSPC]		= { -ENOSPC,	"critical space allocation" },
 	[BLK_STS_TRANSPORT]	= { -ENOLINK,	"recoverable transport" },
 	[BLK_STS_TARGET]	= { -EREMOTEIO,	"critical target" },
-	[BLK_STS_NEXUS]		= { -EBADE,	"critical nexus" },
+	[BLK_STS_RESV_CONFLICT]	= { -EBADE,	"reservation conflict" },
 	[BLK_STS_MEDIUM]	= { -ENODATA,	"critical medium" },
 	[BLK_STS_PROTECTION]	= { -EILSEQ,	"protection" },
 	[BLK_STS_RESOURCE]	= { -ENOMEM,	"kernel resource" },
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8698410aeb84..ba6f1911f7ea 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -278,7 +278,7 @@ static blk_status_t nvme_error_status(u16 status)
 	case NVME_SC_INVALID_PI:
 		return BLK_STS_PROTECTION;
 	case NVME_SC_RESERVATION_CONFLICT:
-		return BLK_STS_NEXUS;
+		return BLK_STS_RESV_CONFLICT;
 	case NVME_SC_HOST_PATH_ERROR:
 		return BLK_STS_TRANSPORT;
 	case NVME_SC_ZONE_TOO_MANY_ACTIVE:
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index a9c2a8d76c45..a2899d9690d4 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2723,7 +2723,7 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 	else if (status == 0) {
 		switch (cqr->intrc) {
 		case -EPERM:
-			error = BLK_STS_NEXUS;
+			error = BLK_STS_RESV_CONFLICT;
 			break;
 		case -ENOLINK:
 			error = BLK_STS_TRANSPORT;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index abe93ec8b7d0..7cc7fb2d3359 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -598,7 +598,7 @@ static blk_status_t scsi_result_to_blk_status(int result)
 	case SCSIML_STAT_OK:
 		break;
 	case SCSIML_STAT_RESV_CONFLICT:
-		return BLK_STS_NEXUS;
+		return BLK_STS_RESV_CONFLICT;
 	case SCSIML_STAT_NOSPC:
 		return BLK_STS_NOSPC;
 	case SCSIML_STAT_MED_ERROR:
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 99be590f952f..2b2452086a2f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -96,7 +96,7 @@ typedef u16 blk_short_t;
 #define BLK_STS_NOSPC		((__force blk_status_t)3)
 #define BLK_STS_TRANSPORT	((__force blk_status_t)4)
 #define BLK_STS_TARGET		((__force blk_status_t)5)
-#define BLK_STS_NEXUS		((__force blk_status_t)6)
+#define BLK_STS_RESV_CONFLICT	((__force blk_status_t)6)
 #define BLK_STS_MEDIUM		((__force blk_status_t)7)
 #define BLK_STS_PROTECTION	((__force blk_status_t)8)
 #define BLK_STS_RESOURCE	((__force blk_status_t)9)
@@ -184,7 +184,7 @@ static inline bool blk_path_error(blk_status_t error)
 	case BLK_STS_NOTSUPP:
 	case BLK_STS_NOSPC:
 	case BLK_STS_TARGET:
-	case BLK_STS_NEXUS:
+	case BLK_STS_RESV_CONFLICT:
 	case BLK_STS_MEDIUM:
 	case BLK_STS_PROTECTION:
 		return false;
-- 
2.25.1

