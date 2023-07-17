Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35CBEB64DC
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Jul 2023 16:06:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbjGQQGx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Jul 2023 12:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjGQQGv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Jul 2023 12:06:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08328E3
        for <linux-scsi@vger.kernel.org>; Mon, 17 Jul 2023 09:06:50 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36HEwqOe028873;
        Mon, 17 Jul 2023 16:06:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=8aLdpOdgOYOIN19iTd3FaTlqyd+Jvq4PeVVIoEvoNPg=;
 b=OQSUI6c12+W5q20CdvdjBZCCSSBfW5SA83L82USrAYpnOWBGbPRWuZU+Xu5Jkb/5bKwN
 dbE4y7CLFD/OdTpBjM7+0rLcWmtg2pSWAPpXkHo7B6Cun9l7CYvSnip2fWudXHpqBU/S
 ugwgrmMR/iez/xACa1mJeZ3qnudMLmXCAOi8VJOQ/ZdEZvgckRbWCRkAZ5c07ENW/ts6
 R2QGeR+xMXIuJfDsSfu++Z31hZlEcSTzyQkRrkj+8HYDKoGUtc0uzs6dkCUr9X3SASR/
 Qd6n5lZyxkklBe2PLJ2RCj9rTApcK16PhyQW2vTNlAVVpzPxpxtPXioCB/pEpRQMkFKV GA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run88k2ud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 16:06:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36HFgq5V000769;
        Mon, 17 Jul 2023 16:06:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw3uw88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Jul 2023 16:06:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwoQgmAteverUy3BKLi3AZ8yLAZj8jZ0hi+94EK9oWjMwNA8e97Zt3hbJ0n+ksl8h1mejLv0qPZA/6O7RW9btiXlPsROjW3y+wC7WDaZhaXDFbNtXTMm7uGZmaLWyz/bwL0yOWfvi9SG5lEBsI7rIvDMGAoQ5BKAy02J9QI9n/rfUVhMKFi10e5arEHFYvmJOqWR8c20bc2nNJ5J4eSU2H8cl93cf8eaaOUvIbKZTC0z0wpPcX5iL9BKc/OfPasoskyXdY6T6aBK+xD37yEK9XZhcr5E7jQgsbntURsuqdx1msYIUlcPrEa6hoVT2nY4nZwgY1ovxEl87Fj2Y1e50A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8aLdpOdgOYOIN19iTd3FaTlqyd+Jvq4PeVVIoEvoNPg=;
 b=lAM0wYbw7DBtBBzuqxnxnvk4PtDWf1U6h3Dg7rfUiHdWLzSPI7ur1NfNtyA8Q/bTIg0xhon5djaTFHEwpfLtmwLQzwOqbebvJdfErka25D1x4dUy+21SX2N/7oK6KjcjLhYQocqmgeqx11lQqt7WDYBfRH470kGcds8zney0/3CCZ/zFmI3wmIgTimUKo7KLsUWLrzNByvX/5SvRdiTvR7OLSVCoy7iPg//kcAEgdyRuAvBO8nNsPVJtvB7MQsc/8JrVuKDGgaeXKs1k56YagOqzgzf5iN+txwAXbgcStiZOiR4lWQWTu8qdejAcnefQUBGJeUoDAVH75S9sS4Ih4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8aLdpOdgOYOIN19iTd3FaTlqyd+Jvq4PeVVIoEvoNPg=;
 b=fg/Y2xNjtWbC0hlT0ym4m77BAtDAWyCIJDpCI6jT7Lr3AUul8EKu1SRv+RBleKpSUeJhfxA1bdsgbYyz9boRejhNc4uuFBXjvrGTARjqvoEw3e4TYowQN7JA8YF2tkuDPYIqVo3/a9XoaadPsymx4StMfTnGjT3GfWmJgc88ZVE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS7PR10MB7346.namprd10.prod.outlook.com (2603:10b6:8:eb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Mon, 17 Jul
 2023 16:06:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 16:06:39 +0000
Message-ID: <b9ee54af-4fdb-c480-c613-09bc3c2e47fb@oracle.com>
Date:   Mon, 17 Jul 2023 17:06:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 09/33] scsi: sd: Fix sshdr use in sd_spinup_disk
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-10-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM8P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::24) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS7PR10MB7346:EE_
X-MS-Office365-Filtering-Correlation-Id: d72d10b7-8d71-424d-205e-08db86dfcdee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KoxeG52Qt28lt4oaEhMgzRLaJiD2qHzugzrE4VPZhUZNjFUhyVJV8blM2Pwx+YN1pb4OpSX5uuyZPiKhNssDDRwMrLv/ylPtHVKhjchtg7IflCRNQier3mz74rlC5eg2tO7ZyaZ3MMqnBDqwq3aoLr+I7yjZpg9Gh4pjceOAQKaMlHJTLbguOc4FBuCSdT3z1im9V8NJYZbLXO8i6JnTpKhv2cnVOxLGtnNhdeVEKfKh+aGA+gfbHgZYeDLnAE+tLbmLKJRIzRkzeAxLgVXQmr7rk7P2zzOV7xDsKT77GN/0dXqURt7AyvPVgW/I5/JTftWjb2e9X9jhIxdXlmud3n6FE1xtqYd3Ff4TNJi7eRocdiImhH51699Nob9+xEM4i53ATH5doSg3vBYXJJ+ZwIe7qy1Q+3bExobgC7cjUizFIJS7Nnxr4PQgluo6OzW4aR/Bqg78dzbnaVKJnlVNsNI00n9NwP6PaKi74Q1UEqBZhr9mqsuuVesxDZaaTriT0kSWYVHpYPCl+dZ03zNjKCSZfEy7FiqjX3YXQC/g8EXzXafHv26oHl5CyafZXt+RFQenR0y1+qJBqK7bEqDoAr5meFcL23Yuhe3Q14RtGF54XP0/y2jKNvmqOn3GSSq2bVdLMm5Lv3M8tS0EHsOq5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(31686004)(2906002)(36916002)(6486002)(6666004)(478600001)(8936002)(36756003)(4744005)(316002)(41300700001)(66476007)(66556008)(66946007)(6512007)(186003)(83380400001)(38100700002)(86362001)(31696002)(53546011)(26005)(5660300002)(2616005)(6506007)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZUVRVFo2NE1yVHVFb0F3NjBpQUJTSnUrd0h2MzFmK0hkMnRITVAzUWhxcU9Y?=
 =?utf-8?B?a3FGcm1lMkNWb1NRcmdOMXNtcVpuVDZISlJPVVJSczB2OEhmY25JWmtGRC9m?=
 =?utf-8?B?VlloRlAyOG9UOVZxYmJjdzlsUGd5UW45a0F4Vm5yNlZkWWc5aHhPVXBNMDEz?=
 =?utf-8?B?V1ZlY0NZZzA5K3B5a3djM3FJR3R0L0g4V3hSNGpiOEUxajBCdjFJN2pxTXky?=
 =?utf-8?B?YWtldk5Na2k4cURBQ3BKbFk4WEVCN2xXWWRZVmI3SU9meHpscm5Yd2VzVTVr?=
 =?utf-8?B?NzZPWkkxcXVoSTJNQmpKVXkrdmQwdFZwUDJnOUt3NVd4TjBLWFBYdDVqR0Q4?=
 =?utf-8?B?VFJyUms0d3JuaU9RaW1jRWQ3RXNaNFQ1c0VGUWxSTVVLWHZxRnRFdFZGcDZi?=
 =?utf-8?B?R0xYZTZTZXZkV2crZDVYOVZPcXJ6NXZrNDN3V1QyVnV5YU9pWHA4WHFHWGhJ?=
 =?utf-8?B?NzE1WWNDdUoyYlRoQnl1ZjZnVzF4VUpjWjZ1WmhtL28xUG1ULzVjODlyR0xm?=
 =?utf-8?B?WGJjK0dPa0crMk9UVzRGVU5JT1ArREduZTdCNnBGYU1rcjllNnhqeXdHN2Nk?=
 =?utf-8?B?ajZNNzdWQ0VuS1d6amE5RkJVUFFUd2JYT2llUG1MR0dyZXNLbUFLcjF3TjFm?=
 =?utf-8?B?OWpwRmZJNHdoNmNlUDRIdTh5YWZMaHFpTGZ4aktBZTYrV1Yyd09XWEp4MHR0?=
 =?utf-8?B?QTJBcUZtQm9YM3JBR2VRQ0Y1aENjUTRGUEZsc25NaCtiU1FvUVhaeXptQW44?=
 =?utf-8?B?NzFGUytjdHc1Zjg4TlY2Z1pyUkJmdzNKN0RHcWlJNFBQSGpDUVdyb2hyOWtL?=
 =?utf-8?B?NHJFVng4UFhGR3lFRllwWHMrMkh0a0xpeGM2SUhOcnViUG83SEZZelV4K0dl?=
 =?utf-8?B?R1FrQmNnajZQNVlxT0Z5VXc5YUFBT2pEMFQxMmVHSWRBMmd0NERpT1NyeHJD?=
 =?utf-8?B?NC9KUmVGNjNyREJyZ1JWcHhYSkh1MEtYY2dBU2t3TWdvN3FPMTJaZlQrcjIv?=
 =?utf-8?B?LzA2ZEJNRmpDUEtIZHpEY3U5bFJzOWZia2c4U1VWR2d0SlRjWW01aDRrVVA0?=
 =?utf-8?B?MXNlU0xUNnlyTVFSM0d4eThRaDdwYU1JN0FLSWR2MHE5c1pJRE8zWS9NSXdn?=
 =?utf-8?B?V0lSS0orZFZWSnR5RzQ4VjB2N0F5M3lHcDhtUEJMTzAwMk5FRTNEQnUwR1Zr?=
 =?utf-8?B?M2tUbHptTytJS2J5WldhZ2xnVnUzN2dwQzg1RnZ6WGxYSmxpSzY0YS9UK0ZX?=
 =?utf-8?B?Y0M2dU10VFZXa0g1ZGVvNEx1SE4zV1ozeDB4Vis4bmt3aHN3R2lIcjU1a0xx?=
 =?utf-8?B?c1A1dzNxcW9ZUUQ4WDBXMWtJeUZTNmt6Sjl2Q1FnU2J3QWk0bXFqeUR2aXVj?=
 =?utf-8?B?eGlrdDA5OTRqNUZ5N3cvSVFjb3c1V2JWUXF5UGQ3d0xveFZsZGw2MHU5R3dT?=
 =?utf-8?B?dlNEV1lMelhXcTA3Qk5WbVpNY3R0QXhJU1FIZ1ltaW16dVJrT1JSV3RWd0g1?=
 =?utf-8?B?SzdJZUpXdXFSU0cxVFlEMXVLRzM1cW9QYTZlOTgxaEhQcWZVYWMvdW1FMnRE?=
 =?utf-8?B?MEFDK3RSQ0ZIME1BWlQ5dGFUb0ZYMTR0a0h5Ti9XcVpPTmNMODVCZ1NGQ2xu?=
 =?utf-8?B?Y1lSSW5XZjJ2cE9GU1ZkMWZzR1lEdzdFdnNhbHlBcEtRUzY1VXBGTnJvRC9w?=
 =?utf-8?B?NCs3NWxROVFGaXVrMHZqbzVJcER5OVNiMGRqTmQ4TW5lM05ROXpVRnR3NWV2?=
 =?utf-8?B?Y0dKSUp6Q2xscURqRkU3RjlIUmVDL3FEK3NVdGY1c2xubFFDTG5UZ2tHQ25l?=
 =?utf-8?B?amtjWkl1ZEpLQ2oreTJOTU80SjZOUjVwRU1hcXBkMXowZlZUa0lqMHEwbWp5?=
 =?utf-8?B?Z0VXUjJ6TVBZNDV1bHBTcmRwOUZvVEpaRml1MnN0Y2QxTVJLT0JxaWh1Sld1?=
 =?utf-8?B?SWFBMHVmdXdmNTdTcE9Tb0dMQTBZMnAzQ3hPOEQrdUdxdmxXY0xVanFSai80?=
 =?utf-8?B?UnBpT0NXZkVUZ2hmQmQzYjZZeENPNGpzN0toRzJqb25ubW1jVFRBbVdzQXNB?=
 =?utf-8?B?KzdpUU96bkVueTVSVWJpRFZlUm1sS0c2K213aGtVb2xDUWZGa09OUFdXNjgy?=
 =?utf-8?B?dXNOQnA2eFRvSDNwWXhEK1B0SU4xNWlKRENSbHhxQS9XUlZBY2NZQ3NkZEVT?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gQr7ZUn/phPFXqKBjBj5yCWtGzZtZODcb7AabWXjY4EeWcmoB3e45gb5sBn9SFK6MD8NxOPGJ4taKMGxA4aCOYf63d7HzFYGJwyBBOW51eLaezRpr5VdKVrYZUf07TXbdgWPHC6cR+IIlrd6qDDspivS5hmaB0gMaZpmfiz8un3Ah9of/pUUgs2h58nltj+vxJvybGdTsWkfXwNRs4eBW+s/r2RPXYD8ouQwZqdRH7A36yBV7thKOn11U3haInLyYolCQ/jhxND9pMpynpQPTfUEi7hp4Yfjgi5HLif+tm1D/kOA1qgsY4TJkVeTdaKq7eBXEiGNZO1VajtT7wLmjEE0J1OqYY4ATygvvgz4iO6ylGJFG/Ymngxub6+TqkdLd14ZDY5OF0Mrf/2L9NJhB+7IjDfIB2fmy1K8w33+Q8dCcZWEyW2jOo3S7TEnFUm9LH4n1z/wEAnbFo6LcFzXz5QcAu2eNi+F+yDVBdjXxE76eOlTMLgPKOlaphuawQ3EB9M1cGzjbXPORB19DyF/B1YS9VP7ALTg7qEDswV/i9VfjC4uIMJ7m/8/UVsg20NSwFPGazA2i1PgpEAJtTkb5uf3vdv5EQ7hw1hxQORlEz5m4nva+JGKJh2MZHdWEPAWBq9zUHzuT/3wutc2flg4RaRXA/MevXVaBO3JdmvXr0fNDkOCy+KwR1udUL/hI/UFegxO3exO9Zz31WPLKWh63u/TkHPp+mVcWVb8fgXSE0Bt7QXo/rAWxk2woPcqQGxk49/Ba3xdEMrNOY2W8lcA3lmZVYusWIAwpkHXV42kY4yrz1fqIkL0pufaLkWBmPZ4n7cm2E/+1fHrD8fz7tTJtNs03OYZ/r3MJdr0Fm6hFmIrYgsI8MY4KloT/Ttadu6r
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d72d10b7-8d71-424d-205e-08db86dfcdee
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 16:06:39.6854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8hcovqrrGS04SYlwbLWNdb/hSchWLd1BNeydigwU6AbM9SVUZBPhsHO8w07HKP66oRfNQYip+J1BM5VPjw+YXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7346
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-17_13,2023-07-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307170147
X-Proofpoint-GUID: LBcijL6yLiu5HtZyPqQwRMqAdiBgkd4R
X-Proofpoint-ORIG-GUID: LBcijL6yLiu5HtZyPqQwRMqAdiBgkd4R
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
