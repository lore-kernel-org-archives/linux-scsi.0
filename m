Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81A1C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD93B61409
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 04:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244094AbhI2EWI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 00:22:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:41036 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244014AbhI2EWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 00:22:05 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2AX0i027590;
        Wed, 29 Sep 2021 04:20:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=A5VnOQrq/CK3UmUgIBoXJq2CAi/9WoNYjFUs8Glju+c=;
 b=ZpBZpIYcbk6dD+WiSEwVDdwx4GEwG6tsWdkVqM4EMuvK9IGjEdNfkLogKbxPdOipibEq
 z/bnMhjcKYUjQrcO0m5vWA3bE9g+eWGog6leiCrdWaG24bcxd8ASYFJSr5q3kBh+Jjew
 ywv2AQEgcKekGv9iKkwn/bnS50sXe1Zq9PjqFCK5SeBvKfOc+7KfUEdXqLJpuix+aXa1
 3vrj46FMO9FrMdmgZeZC6z9Zy4qmmB94pB3xvDCSYehSg48Pd6sXb5TGQTejBwIbtQlk
 Eh0wFAxb+gsSgB/oPFjOK6Ncbzy18CMBuKAxwbbCi0ZvHERslw85MmCrdaFf04pafH2t DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bbhvc4gac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T4AUVA030883;
        Wed, 29 Sep 2021 04:20:23 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by userp3030.oracle.com with ESMTP id 3bc3bjb7h0-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 04:20:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/CTnuxFSgX0DyeIKcONwLKA2yBursH9B3UdoiPjp38EUbXvch6xj/9WfAhM6RAw8g//j/YfEHuVxN7xwRjg1yas0hnP+f1K0/bB3Hgzwa3FHW/dIPSWEjHbU/AqHwzVzq9Cdbphe8g43/WpfpPdCKhTdNexiq1RMjS0oQNzkDc6PCtndyH5acdPYLriGE493o8mpS3fSfCgwlkepzhea74y9XGhuPswZvwJbgIyGtAA17fLmv33bjysFAAyM84oZAojVX0dL65pVPE8dAXUV7gXsuEKA/25guuX0ZpEXuvLuoQERp8GhD37paUkRmzX4G5sDMqxf+kxzjI7IZ9DPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=A5VnOQrq/CK3UmUgIBoXJq2CAi/9WoNYjFUs8Glju+c=;
 b=AIlB8LK1V6XgZvBNmvDPLuOC5tO2jNUS7JADd+OCq0sH4THMOfsuzYyhJomjDtigJ5J8oxnrvw7rxfOCAOnN7m7SDPi5CaDhAGssQq6VmRfOfJiT7xYmQ7MYIB/HdbKCnGjFEF7huVxwkoejYsyHXGMpTyDBKCGRlaUyO6Cvsuo+p0ouvm3IzMiLhQA+G4RJCcBSIcjwUYSE8+TDfSnhfUzYISA3qfaoGt1imK4vIkkkwdrcIbitZo4NHtlq39igiQTFBFfxz7SBvWlJJlaHONFrG8PDcu5DabQtabCnJcEMuM+3uDEYhFGnjFA//HhVBYbND+KYa+2r1X/RWViqVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5VnOQrq/CK3UmUgIBoXJq2CAi/9WoNYjFUs8Glju+c=;
 b=C8PJr9M3J/xU9MMOQ7Yejbj8LfsczgnLKQWWWFsajEJq/uI4yE7kvkUmmr/fNfciHcuoZS2JE05aSAv4T/Xu2D7EHFRzUzMfOyRiL09huoK/YTm1rPuYhBrfI4iMpvL7IH45AmM/dGelkrYTsgVYz9Wk7P9kLnSGgGeX5FBeff8=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4551.namprd10.prod.outlook.com (2603:10b6:510:38::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 29 Sep
 2021 04:20:20 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 04:20:20 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com,
        James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 0/3] efct fixes & improvements
Date:   Wed, 29 Sep 2021 00:20:14 -0400
Message-Id: <163288294652.9370.14774776792021663721.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210914105539.6942-1-d.bogdanov@yadro.com>
References: <20210914105539.6942-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN1PR12CA0056.namprd12.prod.outlook.com
 (2603:10b6:802:20::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN1PR12CA0056.namprd12.prod.outlook.com (2603:10b6:802:20::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 04:20:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 195a5003-5719-480a-8a5d-08d983007322
X-MS-TrafficTypeDiagnostic: PH0PR10MB4551:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4551119B30A0A35F2B54E46F8EA99@PH0PR10MB4551.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mcMmiKiZj6coX8J9aa7fZuslue0yBvjPXLD3YvTLNMnOEQa76z4yNh8aHmz0F+dkTjZLfudmyB9qXqjTAnLC4NKqKXkTIhyUGETeqMH3VR0nwF17T4JGcs0h13S8dCT2ATdiPEAV+FF25j+fY8Jt7sW9/ODG+fERpQwJWmxmHzGke1CgsqfcFnKBfpdStgNNaIOH6L763sL1rXar2rdPUcPT6LzqJbhDv6RLxMipA6q2KVxZKMfiXVQvGTMXrwg+dWldiabrSuV4KNAap61gnqKV/dk7zFOTsfk++FwStW1HouGpLjs0DG29MCSxgNw209nNjaiulKh2mg9xnQ4ouJHoYC0cmQHQ71fQ3tM8RDbXrh0CMDhR0/vG+9ENY9P4HM5cKHnyN9otP9aHOGBDkoKXMq7GSt1rVn10YkBYXoK54H2D72RFjLBORyV63CfikP6gU4rvS7UzF1ZN1R3gn8eZtRz9zrExQnI2JV/Gl3FmZFWtri5e69Mgr4xn+I3GOGxidCeFZObtGsC2R481qhcdA/SoIh5WHg/usp/PAy13AgGtHRcMLj/DqMV97ExXjeeg/Tt3y5xKUnOnznX+q/SODWfKM8iVPj3YnxrLTUv4MrFkk6HPqEzgSLddyPy1DLzVTXp7XlwDsFZ//MPpOnXpVBS7hKoM62J4hmkcar0hnFQMEazVjc10pZis62K4bRpEaczZ9vo79Oro3xL4akP63U30lgEEzRo8VmW+KEkamLeiPqcNE+AlFGkvGjHxob199AMkqtqf5vznpwkRQq/hVl6oL9fyK/C3+bRv3AXWOCPLsjatbRZrIg3PXF2axfDU1QG9hkQqgm+c+aXjwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(52116002)(4744005)(966005)(6486002)(36756003)(103116003)(956004)(316002)(5660300002)(8936002)(38350700002)(38100700002)(2906002)(26005)(508600001)(54906003)(66556008)(66476007)(83380400001)(186003)(66946007)(8676002)(4326008)(7696005)(2616005)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck9iMVZwMGVOMzgvNCttY2RqZFJuZUs0VlVWV0JGM2xlaWREdHZGeEpBeWx4?=
 =?utf-8?B?d1F3SmZ0a2M5Z29GZVV1dXpmNWplNkhPbVdXc2pyYiszSHU1MFFuQ0dUcHpx?=
 =?utf-8?B?MlB6VHdHV3J6QVMrc0F5NXV3eUFLUVgzOE9tY2JHWnVqYmVMZnR4N2J0SWpu?=
 =?utf-8?B?SGwvZDJoNnAzODkzWGZpbWUrNlladE1acS9wOHgwTlMwbDUvSzdYYlJwbEFh?=
 =?utf-8?B?cFR2MFR6K0xmUi9paXgvZUVzZEVFQmRudUFkVWNubStzdHorM3ZaNStUVlY0?=
 =?utf-8?B?Y0xqcmFsOExvM2xJQlRDOEJwTkVKOVpES01SYVBaOW5ReGRiQUVZby8vRXpt?=
 =?utf-8?B?SFVzOER0OHh6NU9xeGdDNFhOZkMwYXZwclMvL24wRkU4c1FvNUpkRmVIZmNZ?=
 =?utf-8?B?bHQzYjJpeTJxbnhwUEFDQThac0pJcFlHdXVONW10RnBZQXJLTWRBaDI5WEJY?=
 =?utf-8?B?dFc5M00zMXZ2Qk5HaWoreGcrVWJoQUlXZGFVVXBTcGl5azVpZUdSRko4QU13?=
 =?utf-8?B?QTE4RnFqL0U5Zkp0VUcrOW1jSGdaZFVwWXRnamsrY29OSlhLZVk3aE9CYm5l?=
 =?utf-8?B?aEs0RkMrbjVJaitvZ3drem5KVDNRb3daRVlSeDd3V2U0TE1QanNEUFlCT29B?=
 =?utf-8?B?bEorbUJwRlUzMnVUQk9BQlFaS0xhZ0xQOUFGQ1l1Z0lYUE5kMDhZbkp3ZFB1?=
 =?utf-8?B?akZJZ3VWMmo3Q091VzZOS3FXZFZwK0dSTTJDOC9ZTmJVb2ppd0NoVklBUTl1?=
 =?utf-8?B?aSswQjc1N3Z2K1ozNTdhcUtvcjN6MkRWZE1heVlsZ00rc0xULzVQdmU5cEtz?=
 =?utf-8?B?bnhpcnRiYkdMMlRRS0pSb2wrdTIveHFXL3FMTU10RzZ5OS9ML3BoK0pnT2xS?=
 =?utf-8?B?dlNXWUFpS0htaXhsTFF5YVNRTVpJU2xjQTVTeDhaaEhHdHg3bXhtbE5kVTdN?=
 =?utf-8?B?ZWxoMXFPVm5wYms0VWtvTmg1TGY5NUgxdzRiSDFnUVdleFZQd3k1bVJqZ2Zo?=
 =?utf-8?B?ckZQUHNnQkpWalJyaW0yWStOWFhnVE94MzJ2SkRxVGt0Z3ZTOHgvZHNhTjQ5?=
 =?utf-8?B?MjBlYUhrZlFtWkpRSFkreEdFY1Q0ZCtlb1pvdHBPeVVOWTVRSHhoYU5lbk1L?=
 =?utf-8?B?cmN2YzRCRTV5b2ZhUUJBcnphY2tRbUNrTVc2N0VFbENjUkJmL3huVFQyTExV?=
 =?utf-8?B?dk1HUmMrckNFRTdnMDNQcjkyNFZ3UHZjOFQ5MEJYWU5yVkpTZzltV3gxSHN2?=
 =?utf-8?B?YWRpNVZRaWo3em1CTE5zTHRvSndQQ2NDbWtFMWlHNWhLYkYzYmhGMHAxb28v?=
 =?utf-8?B?YVFjaDZMTjd3aFhDWVZzYjFZOHJKamlBNmNwWS9rV3NnVzV2NUtrOXp4VlRN?=
 =?utf-8?B?bm9tZXdtbHZCZmFzTG5PRTZlWm10R3h4UkhuY0J4MmpGVHIyc2RwK3V2S2xU?=
 =?utf-8?B?RHhCbGdta1M3T2VNZ09pR3ZwQ2o4L09aekJJUjZudTYxRzJTdzdqRElhYzlS?=
 =?utf-8?B?ZXAzOWJSWVlEQW5TbndOM1dWKytmYVBBWlBFZXdRZ0Y4MGp5YWRyQ1pmZUdj?=
 =?utf-8?B?V3dWWGd0TCs4Lzh2Y2JzMWJYc2RlQjFDWXFGbHVzcW9zQVJ5NEJwSWNLa2F6?=
 =?utf-8?B?djZjRlBBVWgvcVJGeDRDNk9od002TGVkV3BxUTVYaUpRMWFsbXQ0SWo4TS84?=
 =?utf-8?B?VnVRYkVsOUppRndFbFI1RWtBNlNjNjBFbE9BT0Nvc1Q2QUdjL2pmcTBpNG1Z?=
 =?utf-8?Q?I0XP/WLdkdrprD6LytmKN8yECj2TxnBgM3TH9GF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 195a5003-5719-480a-8a5d-08d983007322
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 04:20:20.5872
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8qB3Jz1SrKQSmgwMJeXIWfb856V6VJjeD0OvPlpe5W1MGRyuuRw7oZ+Rm3uWYfREtTvqXoVwh9Jp0CwSyMXR5S9agBLhe1byZKc38xkyYFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4551
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=867 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2109290025
X-Proofpoint-ORIG-GUID: q18FIMRGQ9nyLP0dY-Ms69vdghHn6AVy
X-Proofpoint-GUID: q18FIMRGQ9nyLP0dY-Ms69vdghHn6AVy
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Sep 2021 13:55:36 +0300, Dmitry Bogdanov wrote:

> This patchset contains fixes of some isues that were found during
> evaluation of Emulex HBA as a target.
> 
> This patchset is intended for scsi-queue.
> 
> Dmitry Bogdanov (3):
>   scsi: efct: add state in nport sm trace printout
>   scsi: efct: fix nport free
>   scsi: efct: decrease area under spinlock
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/3] scsi: efct: add state in nport sm trace printout
      https://git.kernel.org/mkp/scsi/c/8d4efd0040e5
[2/3] scsi: efct: fix nport free
      https://git.kernel.org/mkp/scsi/c/ee3dce9f3842
[3/3] scsi: efct: decrease area under spinlock
      https://git.kernel.org/mkp/scsi/c/e76b7c5e25a1

-- 
Martin K. Petersen	Oracle Linux Engineering
