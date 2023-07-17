Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BD4C001DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 15:28:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjGQP2b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 11:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbjGQP1o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 11:27:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DCB1BFA
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 08:27:12 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HF0W5J029461;
        Mon, 17 Jul 2023 15:26:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8aLdpOdgOYOIN19iTd3FaTlqyd+Jvq4PeVVIoEvoNPg=;
 b=bi6x3NkrNsZDJ/xohxVku4nGjEgCwffaKg6F2hClskqWLOqvYXXSQoo7zJpL94jAgS63
 K9fl2ikyYX9Diic82+iA7U2xSKR/tmceJjsMp9zznKaPHZTxwSfXMtQvrgo5HJRsykNu
 4JU/NXLDhL0ymKyEuarXj0I9lmYTPx3/0SseYMyL9N6EC+Q6Ln8sk7Clwd1zYRJVTI3+
 oa/IUzD+d3RjKTUlo1JN6BkWu9o2FxjleJhEgDO5tRFt/ieivcNl8KFT1A0QNTcNMWlv
 Pn2UqtWMyfFsINJbtRMT4xLNATC18znmrXgDkHg5znUFCQtKLgQHZddt+5w++d2r/RZI wA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run89u0dh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:26:49 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HEx5bi017331;
        Mon, 17 Jul 2023 15:26:49 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2045.outbound.protection.outlook.com [104.47.74.45])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw3sy9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 15:26:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLZvYVrUq45/HlkYDqkiPSDwSpmaJjUa6MpUr7oogZz3P4gwPHyIYH7mlcIss1LQEKdGJ7jJXni+ENK7D7nP6ElRyxodrVWzftajnGoGbOOMdt5TmY0E4a95Ew1YeMKS1QbH/8FkkmooHeDcTmflt1pJDc+Ycf12jfw6CFkWXNJhbbwVUgufmQx9mv9qjNr8MVnemypQ5c4b+oO7vpJDa8RnquXG7+Vk9OqWaI5QhtFbeVwEtH82zz02Cvk6BvOpjHMQqxYL+0GeQ/ScnJAx7aDoru42r11G1OzsYMy1aXekIBrn0ja4Z032cfGo32fHVasjTPzuXiEL9/MViqa3xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aLdpOdgOYOIN19iTd3FaTlqyd+Jvq4PeVVIoEvoNPg=;
 b=dYeEG+t3sTILy6qBsdC5a445sWR/5QHUcDZGpDje2gO4D0te1o3jW6YS/GOaMzf6GvCL9hjMwD15bM4c34WA7b2jgvuKpbyuV9Z3sbuG7A8xOvNMz0pa9W5j/uwyyrNTI3yA/o9M8tFOLD9dEld+4rOcXYko7mhKAtsqYQv2YAu49Kfhata9s+D+qsyN+5lqoXoq9/U4HHfk3C6GnDJuqr5NxpT5WZ0yYtj76tr7o8B4o+uF/5ZjHAraZhkNwv/V6YFIebmjKUXmiR7kgQT5nqrmrPdGdWTzSJyyhxUnbrriCaEwfo7IVX5ifqqZP/cYWgkn5CJLFsB/rU17phX+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aLdpOdgOYOIN19iTd3FaTlqyd+Jvq4PeVVIoEvoNPg=;
 b=GtncvV/IQNO3LTd785xwN5WvXNb80j93YOocTgKOW/+Gy0EDC77qd2bPDZcIFdq+CvOVO9jSgR2UioiZvelklouOJmXHaOTYGcuKWBq0EfPNav6pFt9NJLN0P5Btb2Z92PK4UpTcX6nJbdT6tbT2HvNrYhXrHRUWYvli9fvruvg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by IA0PR10MB7206.namprd10.prod.outlook.com (2603:10b6:208:402::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.28; Mon, 17 Jul
 2023 15:26:46 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 15:26:46 +0000
Message-ID: <bb3cbfbc-8337-fb31-bf6e-60f1cea2640f@oracle.com>
Date:   Mon, 17 Jul 2023 16:26:40 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 06/33] scsi: sd: Fix sshdr use in read_capacity_16
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-7-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0131.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c6::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|IA0PR10MB7206:EE_
X-MS-Office365-Filtering-Correlation-Id: f54b3bd2-8b3a-46b9-d6e9-08db86da3b77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UhBxkPxQT5X7+ATFrb8mloQwL+uImHu4xbgqeU+1ndOPYsdW7hbF91awmmiMXflaA2HIieHOwBwJv/8Zw85WsSBnLPyx+SuhhEPEFYrw8Yc2ziWoGHy8HA0gSvxa3ukqFD0yh97rjG74e/ukx6z46dw4NqJCvwUHk2G4qSuJ03jcFS6t+7E29FVa/UvixQs/MfYgt9h1WJ85g0JR4IYG7YXIw/HCho9VXoVtwbwMA/QT0L9cxfKOrppoJ8eWALFdxgB5TyNhPK2p/xCi7VWw4zb7TH6ENNYJ4e63KXCl8/KROC1Y4ZyL6hhfTgAnce58/XGhRABlutfwxyu2EXmjs95/LflrOed/86b2S1zrAWGbPtlT+JNkfwk6Ei2l+Et/pgD1Sg1fZrhsrK2UDcJRoeUuXNVYVDFDXw+tWKdUv2fPJWz2yJ4Se2PSb2qJMSIgJssN5aCMPRufCe4dhKdpXOEWCnl/vOpDlc675NAVw55iacmXINYOw2xpOMCkkqXN8FCEsV7GDPYztin3T2I0sScWkErHbVuYiyQZSYUKt8vumwKPtYhDAOgFVzGqwt8ZyPjDx4bHKkgoFBAn84Rccpyt553DbDsvYnVPe93S/9548zLKiQHaJS7PkKWg07Vt/a4c4Nlj6xaLMTMI62m6vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199021)(38100700002)(86362001)(36756003)(31696002)(6486002)(36916002)(6512007)(6666004)(478600001)(2906002)(4744005)(53546011)(6506007)(26005)(316002)(5660300002)(8676002)(8936002)(31686004)(41300700001)(66556008)(66476007)(66946007)(83380400001)(2616005)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUpEV1JVeWpNOTdzZTM2TmNzeGpNckFGQ2xZWDhNZWs1cld6dndQMmVXa2Jq?=
 =?utf-8?B?cWdPNkdIa0ovWnhjOXlIVlFRK0doZGtrVndPMld4U3A5WDFJbDR1SlNadWpG?=
 =?utf-8?B?ektCcTdkUWsrN09HYmk4UXVEdkpMODVvOVIwMTJuOVorNnBFQ1c0cUxwdVd4?=
 =?utf-8?B?cy93Z0xIWml3MGFDUzFXcnZUTTFOVWR0OWZ2VGNlQ2RwT1luQ1dWQnJFRUtE?=
 =?utf-8?B?NFk1L0hHSTMrYUp1RjU1TE13TXRzTDVLeSt6OW5LYWtNWmtnWXQ3WUZ3Zi9s?=
 =?utf-8?B?Mm1NRlNwcVUvejFBOG5hS0ZpYjd5R2JVeG4rSEdLaE5MNU03ejBXYnpjcEpD?=
 =?utf-8?B?TzBlU0tPMGZCYlRXd3RBWVYzelB0RTBCcllqVytCWXNCWXpIZTFxaldHcllJ?=
 =?utf-8?B?SHczRDBwZkdNM1BYeW9zaDlJVnU2ZHh3WlpqNVk5YUxCTWx0WDZZT0grMW9K?=
 =?utf-8?B?SVdtOEd1WGxoVmVUbytBOXc2Ym51NCtCZkRPZzl6Ynd4YjJiSndQaGVPeE1w?=
 =?utf-8?B?L2JsVXMxclY3a3lIc0pMaFV4OWtUS0F4ZVl5dGFiUllQZmo2RFA1WFk4dllw?=
 =?utf-8?B?KzNmWEcybDdCaExoQ2NHRmk2NEJET1NDRVJTOTMwOTNzdTRqdmhrZ21Vb1FY?=
 =?utf-8?B?QUxzUU1mdEpqeld5Q0Vrc1l2UU9BZ1NiaVN1cERKSk16dkFnMHdNMUtCSzly?=
 =?utf-8?B?am5OVFdEd3Z5aHdlYXZpeUhEVXV3OC9rUWlVUlBjbU9wTE1kd3liQzJEYUlS?=
 =?utf-8?B?WE0ySFc4SGIycWpOcldpRVQ0WU1RZEVsTE9OZ3dzMFlycGlEYW5JQlEydHBI?=
 =?utf-8?B?TzNFSzNqWGU1b0w3RUlYQVdLTXZ3S1pEdGlUdStybm1Ia21Ib0NNYnIycEZ1?=
 =?utf-8?B?Y0Q2dXJPWGh6RVlSYWFtSURzZjRjcGZ1SklrUXI5WGJzVEVDdXVtdDlpYWwr?=
 =?utf-8?B?TjJwdHg3SmJCYnQvU1lZZ0t6MytOeVoxUjhMYVd2RGE5M21BYlV0UGlvSmhE?=
 =?utf-8?B?Wkl1UXJiN3ZzMkNjYUJHMjFxVzhsa3ZWeTRBQnRveUd0T0Q2cDdEOUxKUGpJ?=
 =?utf-8?B?VUN1RXQzeHM2QWJXNDczNFh3Mk9CU2RnbUovdUFrUVllcCtGSWVoNHNWWTBO?=
 =?utf-8?B?cGFlL0VlWkM1R09hMkMwZS93UlhXZTYySUNRZk5UUGlrS0lPNWN5dHNMWnEr?=
 =?utf-8?B?RnJseUFtMXBVTlkzNG9OSm9GTjlxMis5MGtrK1Evck5WYit6UjlzU0x6UW5R?=
 =?utf-8?B?TGowL2ZaYnNPa3N1OWZId3Q4MGRHNkxIWEMvYmFLRzJIdC9CYUl0cEtaakFE?=
 =?utf-8?B?YTI0c3F1b1NMb1VBdnZ4S3Q3UThiTUxTMncyYkg1K0NWbDNNb2JlVU4zYXhR?=
 =?utf-8?B?elZWbmVVUzIveVR2TlMySHphUGN3dStLRStTV25hVmhtMGNLY1NxYlQzWnZ0?=
 =?utf-8?B?MW5DU3dqWGpGc21jT2dEVFBmaW90T1ZRVHdUOG8reURXSzBhT0NpRHJDbGNK?=
 =?utf-8?B?VXF6blRzZ1Y3Q1Fxb0ZLT3J3SDV2OUtCRlZRZTJ6SndpUzJLNC8xTmtkZ0NY?=
 =?utf-8?B?bWNFckYreXd3WC9iNXRLM0I5ZkFKSUI0TWE2SGk1VjkyMk9UaVRDOFpJL2Vi?=
 =?utf-8?B?N0hQd2hjQmpQNFBRY1J6cnl5VTdZMTRQWGVvanAwN3lIeVZMckwxOGZCR09n?=
 =?utf-8?B?SmYweGgrYTBldEE3OHZwWE1kVWNRNU1leVJUcXZMVXlVWW1zak0rN04wM3VM?=
 =?utf-8?B?TUhNRUVkemFpRDB4TEVidllzcHcwRDI2SmQ0UGFzalMvRFpvUUZuVGxFeXZr?=
 =?utf-8?B?Q0R6eXpPTnlqbVBhUjgvNFJJaVFLMTF3Sm9OdEVnNkw0TzFNcFJWUzJnSEZ1?=
 =?utf-8?B?VUxNZzFUSmxnSUtvN3dNQ2puZDFraUs3dnNLQ0Q4c3AyS0g0YitINFA5RnFk?=
 =?utf-8?B?S00vNjFVOTJ4VG9PTzFKNGtueWZRN0d0bVZ1N0FqL1dJQmpmU1JZamhNUllx?=
 =?utf-8?B?OHU1N0lhSkFPSkVJSjVpZmoyQmZGbkhpenorUmtpZnRZNWFtdGNWWXlqZm1m?=
 =?utf-8?B?WjNtYlVHWjlkL0xyZ2lHUVdqNk12Q1pGSngrZmNDL1hkVkdvbkVBbGFYaW95?=
 =?utf-8?B?bUZZMHZGeGdQeGwvdnNSWEhjSTJLb3ZiUkNyRS8vZ0VJNE5KNHoxZ1haQkwv?=
 =?utf-8?B?TXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7mxnOh9/+GOYcc19IKTP2ZKsa/Vvbff/olmGU68f9JUmmwHR1FLkt9taS/sfeODYkpdfwMLtGxmfseHM8/JS7uiunaj4T2GyXrU8HFXcySeArlsvK8eUBrW2XVIhVqpV/fkCzzrh6Pah1Gsd0ctb7uPPoy3vFC5tiOArrT41s2Sgmru2zXZJu6DGud/kmYWtoJJGRSjYO1ZY0E/WsTPTcwHch27IgVO1AeaDnujgVT/bD6cUpeAtCqE2ACojmWkxg/zKrAKMBF9rDq/Flvm68Jc0vY7D+YZzUsM44dZJ+oWAJYOO8JINpg7UOumgoTSr7R0ebXZ0gOP+G0EgEOlzGwgOxdsKMBsKnDBFafXwWfOxKGgzT7hqkBuL3HVf7VIbJ/aB+T+YNKBfDI2r+xAp9J9++3FZU/O41p9M2ec+e0V2k9hcDUskUtMrMCEYORGGRhYepAjZPN03Q7GNoXUeD7Mzyr75KRRz+bOp59KsBHX9FIlJ47DwJNsW2ZXKtS0F/Yl33tPFvcQKfWJQkcjX78/pPPA2KS3x/OdnhPDqHcBqRA6fXWOBB8l1S6vGMgActz5sgkDqIkxFgLHbULyPm49as+wrnfU2IwqGWO1rYcnQNIVorrypxDuicLfhoKz9yAEC4UlZ5za+Jm68j13Pe/+LiyVn7SLjWhpaNSZKcD7spc2Gx9PMMzPPggs2r7Z9R49U61MeBpmZWJwpfJM+04XIv1bFXKFe0qWt2IlOSsO0VXCavWlVYsEFoTWN1neBPwdPa0wugKkl4Wo5zc6a+3lUZNg2Fdym/rZE8MQcZweePRF79803evfuW8STMKnvWdIjlWDkxm6mjVi0xurX3uwIJ+s30A6i3HWhFfHd8aRlemb+GEGNRJmM73S7hd8c
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f54b3bd2-8b3a-46b9-d6e9-08db86da3b77
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 15:26:46.4756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vaz3DFrD1qlkCHQ5Z14BlclSSxhCt4bKCJt9oFwkZfkrKClgxKFTtdRpG3A/mi4av01kzuIKo4L5JE3L0TC+aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7206
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_12,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307170141
X-Proofpoint-ORIG-GUID: -eS4B5zCYYBwC5fY-Sr5QtO3lHRCb2xi
X-Proofpoint-GUID: -eS4B5zCYYBwC5fY-Sr5QtO3lHRCb2xi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:33, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when get a return value > 0.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
