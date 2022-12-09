Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B909C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:22:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbiLIKWv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:22:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLIKWp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:22:45 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3968411478
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:22:45 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nWQv018213;
        Fri, 9 Dec 2022 10:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=JkgJWAAIF7XheAND9K71m2yTj52fQ2hQmG0JXlwEwhY=;
 b=zt66ms7sHVOAhU9i28SxvA3tax3D/j+X6tSAgUZ64b36K+9rlWvQV6ZSWNV012k0fbJZ
 nZ6vW730lNYXCYINu42LaitD/5eUxr7JN2TyOb3W2UqF6xs/s/cvUxVDYt0naFSDsanH
 MAceWs3TCOS/IZYmPMtP3ns7Jy3C9pMqFPJrym2rQ03Z255ECc41n3U76HYONNAIflH2
 gkK/Wk8jjKkdB1OU8jWA4jG5zEhPCbcX+9mLhFYkIO74WrDyMqrNfThaD834ALHanDHL
 ngIyVceNA+ORrNYuXLv32j3qyV1gbLsFNK3jPlY3yvCSF/HfDBiLsu/N2yDUEo9hz9Le dw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujkmq5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:22:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98s6Kk036583;
        Fri, 9 Dec 2022 10:22:34 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6ce231-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:22:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZNqJG8i/6Pz7CLxu/1EMVH+NvwWPjw9c4c3b7wTJFOeziq4G+z1iHOKEQO9NLblEp52iVKX/LwA+PRc5nHiIf+2sTE03An8CzlQv0Jbn0VzgReR+kGw5JFZAfoxWjAlziYp3a5+X7rcrHQd4auytw+GM4PEtcdHWwTw1HGd+w40CdaaO1OHkDoTgFiWpoeb8M7JtK2ivby4ZF7OMt+yEQB8q4MGsI2oRXy/6Vr3TnD3H9zKe45DgSRIiN6XmWhnl9poUD6VfgZ44/WmACKqgCiTKpCcu//M5CaM4DutWgbvs4p6OTfQfG+xcfA+63P0RbRsed6+Saix0y4dsZgAYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JkgJWAAIF7XheAND9K71m2yTj52fQ2hQmG0JXlwEwhY=;
 b=bmqScYad+atRgwgC/i690q1oPcjnb7HknHWkCWpIEp7BJGXmoe8hp7bOTWSnCbTq+Ly1xFFptWOzYYaTo8YRpTYif5jxOCRTMTnMn2wT9JoAI3U1KOHN25qwjVuSVi4/5zOvpJvIzer+CmXWJ3DJoWABCU6sZG/wnjo2UuU5hMysApt8U3heRPX5NUrpXw5olewecAaua4dp8BKETB9GKK0VeuEE7pbYzS9VXqH0sgjTsKrBvotxilc6IlWwdxfVQWynba9zazv8ehtkWgF77YpXQggXErF7OtL3vHsnRGm2M9vBbNXFtTxiiyalgqPMU6sujb0wc1ks+zEZHV5xOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JkgJWAAIF7XheAND9K71m2yTj52fQ2hQmG0JXlwEwhY=;
 b=aMYSkj8rGzsXQ2o/KxD7JrmAEUa9aTEHmm6S9uaRqL86DBvtKiO8fykOhoRuDnb17+G/Ov9GWG1feY+DS/jlO9hr64F62NcWgkJnnIt7VO3RV6roKikqu6PIobP3YGXdBBhUEzjLhOXj6Bbu4li/HeiAiQdP0wOLy2KFuIO8pq8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 10:22:32 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:22:32 +0000
Message-ID: <698c0549-7f80-9845-ae25-b889b7b49d6c@oracle.com>
Date:   Fri, 9 Dec 2022 10:22:28 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 13/15] scsi: target_core_pscsi: Convert to
 scsi_execute_cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-14-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-14-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0172.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2e5938-18a4-48f3-cc5a-08dad9cf4887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLTkYBq4sdbBtW5xdjiv9Ol58FzG2IxaoqvrfX0XZkInw8Z7Bk1GdcJyYQUsY6iYt9MvZjqu0Qv5wEjCj5vhJf+3WQLOVvMf7QI4qs9m+lRJ9dp2cxRv50TYluyY+f0wRoD/xVM5YNqCqxgQ+9IG+JQm5QucDxKWqW4b3J2q6aQMhQSQIwMhOe9FevkF4BowA47+gt9UN2JG+DpjABULYJnHiXyK4Y3PXcUbNV7z1x+Yag+r9Ao3hN/y5GvTUUFv1tQIQF4l5mTEg3zGkoHxyZF9O4Et9Yuv52B/rBro9j5ncHjkXvxDHoG6qOFjJz7HnEGR0RfZsPFLTSNAlZoLZXyLrsOC90zUnNqTW/evpMj6cGDcBX3pBrtszFqMu+daw7rxrWWqGou1ItoPYOBnkkctGYRF70Ca04xqx93Bo1KJKE/d4N1d8DI2uwd0RpHO/o+fTeEuHAH6GSu1yWoDhPt6RxJETrpwJwpkIb06u7yGASjBtdaRBKAOCPLGrZGyUyebD1e2X/8kOyLwo+DyAAP+jJwy8HV1ZX7rf90erxOjBTyODWd/tKXjO1Gi57nMz/mUebkKKm9XzdeFv4yQsLQp9cHTgyAEjaLWxCbmN8MzqQj8dY5O8iKXM2Ogaaqi4cWiN9FEObkg7RO0sE/+ud9woZdal52oA171sRcZlsOtAFjGujxXZbPWlDtCuQMn5XuSmndKSGrOpfnIEsC/1ZpB1GsNE00SbY2QwKcRH8U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199015)(31686004)(478600001)(6666004)(6486002)(36916002)(5660300002)(6512007)(186003)(38100700002)(6506007)(8936002)(26005)(2906002)(558084003)(86362001)(31696002)(53546011)(8676002)(316002)(41300700001)(36756003)(66476007)(2616005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SE5heCsxcGJzMXErK3gyeU00aDlmaTdMUU9EbG5uRXZTQWlMbnpNdytZakIx?=
 =?utf-8?B?aWgyK2MzQWUrdGt6dVpBZm0rditiZWcrM1VKTWQ3SmNWajJkSGZLdXJQdXdQ?=
 =?utf-8?B?eW5RcXpKc3VLclVkeExsRW9Ob0NiUW0reFN1TVdQK0QvNFRrVEhHdmp0d0Nq?=
 =?utf-8?B?R3ZmbGk5blpIeDd5bkZPd3pCRE9ET2wyd1h2OFpTL2Z6cW5pSUwybFhDTjlB?=
 =?utf-8?B?bk50ayt2U3RhUUZ5Y1RFUGV4RTJmQnAxc2xiWVRsZ25rcy9EcUFOUXhBajlm?=
 =?utf-8?B?dEUzUzZhWE0wWm50RWpvcWdDMzl1TjdqNFhTaXhqUlRhdTRDL0duekx2WGhv?=
 =?utf-8?B?V3c5TFpJYWpEOTdOaVBqOU5nN3Y0TENjTEMveTZwWC82Wk5sWHJlbFNDV25H?=
 =?utf-8?B?MWd2c0lOQnArNDJUWGpCaG4zVjE2WUZvd3dWMVczcURVZGZKSGJLWlBFUkli?=
 =?utf-8?B?SklQa1pIVG5oM0doZW5heUhVdVA1YUZ4NmQwbmJOY0FsUEF6a1hEZENYMkg4?=
 =?utf-8?B?YVBJdVRBT2ZnUTVmcEtldVBybXpqNFNMeWt1U0NOQmFUWU9DSTY5cCtia3pl?=
 =?utf-8?B?c1k5VU93aWlCR0FOSVFvSjcreTlNV3RjMSsybGFhM3pPZWY0RmRyejVnbUVQ?=
 =?utf-8?B?WXFyN3dKeE1FNW5NN2NBY1VDU21kMXYxSFMyRkZDeGZWK2VCWHRubWJITmY0?=
 =?utf-8?B?dnV3bjJHUGF5R2JuOWxrRk1Wckpzc2lrTlBUUHV6UmJjNDduYzk4cUtPcXlM?=
 =?utf-8?B?YnZEZ1VyWjFUNlV3SVJYQmNMSytEeUFIbFBvTkRLdzhOZlpFY3MzalBpWWIx?=
 =?utf-8?B?ZGxIdGk4a1hoUUlKdGx3dXlmKzl3SmVFc2RydVNQS3NWSXl3Yk9xeWJTcy9m?=
 =?utf-8?B?cUM1VWNhYU5ZR1RwcmI1Y2tRR3ZaY0JPK1U3aGdSS1hEV3lNM2VEQ2RoMFhy?=
 =?utf-8?B?Uk9TU0VKS3FrWUEwTUhkUi91ZWRjUFJjMmFJdktvN29JSzZ3aFVzWDQ2Zy9P?=
 =?utf-8?B?cmVobFhLOGJXYjdEK0QwTHh6aFRwbnBGVjBZT2g1THd3YlRXUUszTTloTm1x?=
 =?utf-8?B?L1dUcHZ2TkZvQjRIT0p5V0FRckc3MUoyT0d4emVrQnZCM1F5amtuRUtlT0Rj?=
 =?utf-8?B?V3ZVNjlqY2phaDNsdUJmbEFTYkFOVTdsZ0JXQXV6Nms1OW9XdUNCNFZQSU1x?=
 =?utf-8?B?WmsyWGtCL0xwUVFBbDlDbXc3amZCRlBNRThpYkpVaWNyTE91ckxDa0pyVGt5?=
 =?utf-8?B?eURmOGtrdnVIdWs1NnpXTzVPMzVpeUQzdkRyVDQ0dXVTTTJjM3hMVDgvVmpv?=
 =?utf-8?B?SFhVSENlbkhISzh3T0QwOTRERVJKaEhRY0VjaERMdVJrMEUvbkJmdDkvazdD?=
 =?utf-8?B?bEpsUlFQTzBnL3lKTmQvbkpIcUNJVmtwZ29GVkRKRzlQUVp4NzAyQlhHdUhz?=
 =?utf-8?B?eTltbXYzTGxxSmFYUEs3R1hLbVZ3WnRFQzJxVGJHQVg4K0w2Rzh2Y0p3SUpZ?=
 =?utf-8?B?cHVZanN2VWQrZ2Y1ZVQzVlE5WW8yOC84eUtwOWEyTFN6S2RQdVRTQWUya3Mx?=
 =?utf-8?B?RW0wdW10MzV6Z0JGVnh3d0dTemZLc3IzNXZWaUlKYUhOQlR5WnIzYXJOOEhq?=
 =?utf-8?B?YnFFR2YrVFhmbUdnN2ZqWnZuZGtDV2c3UlVpaVptRDBpZksxQ2tDRFlaL1FM?=
 =?utf-8?B?cUttZ2w3NDAyZUl6azNrdldwTGI2WjN4SEtUd1Y4aWE5TnVqenREZSs4VVdD?=
 =?utf-8?B?NzFoVndVQUFIOWYybkZrM2kxQVUxemhDMjc1RUFKbklCdithS0Eyb0JpaHlR?=
 =?utf-8?B?R3RzK050TlIzSGtqWmRsMDNFOWhCZjVWSEN5c1k4bE9pdGdMTzFTYVhnN0l6?=
 =?utf-8?B?SGZjK1VxZmdidFdERkVxU2xsMHdaUlp4V0hDZjhzalRxNDRNZVZJMUFlbjdK?=
 =?utf-8?B?TDJsUUxLN0hsZGk3Qmt0amdPWk9ROW5YZjZ2dDltR21ScmJMNWgrd2laelhX?=
 =?utf-8?B?Nm1pRVJHaktPUmlGU1QyNVhzMWtxdDExRXRkQWM2bEM1OFRVVGxIVXZjc3Jv?=
 =?utf-8?B?VzBiSkgydlpkdGJ0a3JibDh6OGF6a09SdStTWkpjbmpBV3Y5Yjd3Ymt2ZUwz?=
 =?utf-8?B?aEVselJlbU1pZUR5RjFNTy9CNklKc0wxdk9EdEpiVTQ0TS9sSUFWSHJQazdE?=
 =?utf-8?B?dlE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2e5938-18a4-48f3-cc5a-08dad9cf4887
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:22:32.7319
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: f1LydcTW+XASiysToPW15F0kT8LIWIjTQPLA62qEyHwpkHxdZm06nS1q5r5azO7b0RRF/BjZxUeb877TnBYQTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-ORIG-GUID: s4RcXCdaGp3s_WtFfJKCrmXniNIYeRMA
X-Proofpoint-GUID: s4RcXCdaGp3s_WtFfJKCrmXniNIYeRMA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert pscsi to
> scsi_execute_cmd.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>
