Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83257C11F66
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DA6C61D51
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhF2ENI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:50056 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231955AbhF2ENC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:13:02 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T464tb012615;
        Tue, 29 Jun 2021 04:10:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/VlbRWo9cnOYMfE40TE1+/0Id5YW7XW/bJStzLHNwEo=;
 b=meJPLCYnMdBxBge+U8nHiCbcXUDV+GCDeOPgy0pM0/CmR8bLVjzAEqpriliCcHRZx4TJ
 87e1mlpIczPI5Ztx1S1fNp9GQF/5LIjXn3nU4uDJMTMaM7KxILALGw1lgckCOpDwNcod
 +ZJALQnYI1jXkoIpXns5QJicuts1b3tlnKawZoCidzIeJNGrGYYMm2E8dCFqu8ESsgHr
 JBrh/60GknpFKC8jnANtfiP1X01GigJLkM7P5wJK5z4a3iCBkFjSAjFXxjZHalqwPR/q
 4lfQXvd9ixpTCID7c83j1q7FpzZV8USokqVYbBUfBCcf3QrFLVJW8uLTlD8iVvu77Ezo kg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6pqafqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49rjY052345;
        Tue, 29 Jun 2021 04:10:29 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 39ee0tv4n0-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YT7pD4pwas+0BrIC7MzZ4/ZvYY9POKDWn4x9cr060kEzwH28ZwsQd2KhbzCn4vdTKbKwH9soTqL5cAnpl/zby1xPdME7SLjvuoNzNhkZ+0ge9UuiTQ2axnGqveBDZ0OkevSeUhwue1oyFDpH5Uf12DiS9p13r2Htbzp9iHBhwby6SiP4R+Gp89HWoxIeFu0XyEOHVZNEWMeEzopmsD3bSNWCocGVCKYgyhIhGMdbV2H7IG6fY/w/NVaVtIcyuVnYP7DFVB/TyBr6jeCnop1x7FsqmN4Q+4y/nEOyXXGkcvR2x9V2qqxtvobTacCGhKEisPLlRc9IPqJqcEPje/ottw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VlbRWo9cnOYMfE40TE1+/0Id5YW7XW/bJStzLHNwEo=;
 b=LWk2M13Oux2nBXxzjh1BVit3MFhW6E0KAjBVc33mDCSJajjwE+AWQzxyG5IqMqyFkYmJVeByZ+SFSiqB2VI2viHSQjSvIB5M0voFJdDOnJLP+6zNfqksUJQ6nDN7K4cT5/KyTE97JoeBenlT3fcnExcsZ+wnD5VPoAMpCY6w5MHJWtL6VaSKKtrC8NhywDHfjHPV+Ik3groJ95ZfZxgsWEIAv9aMi/qPwfK2nuGnDcqBirZ4fo4ylXqZhfmLGLU7v2dMLlfvIoG01xGQg8YIXz7KMThhX4F8uVCevXadK/JpxrwDa3Fkfwb4CIQRYab3a44+SyGl7eY/OBBCZIWo5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/VlbRWo9cnOYMfE40TE1+/0Id5YW7XW/bJStzLHNwEo=;
 b=js5ePOt6ijZ6jOf8SNaUV4lNl+9wlhhAEPXnub7Pg2D8PUa2F+Fu3WTqkF4JergTVUyasKPuDoeP/aj7ILU3adhckIliEr8jiyJ0vJeknKQJZ3RoO0eyYKrLD5Rw3U18xMu9jk8SxYh4bwMALuuwsr9Cp/qoomJaTH1l6fjq44o=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 04:10:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Yufen Yu <yuyufen@huawei.com>, jejb@linux.ibm.com,
        john.garry@huawei.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, yanaijie@huawei.com,
        Wu Bo <wubo40@huawei.com>
Subject: Re: [PATCH v3] scsi: libsas: add lun number check in .slave_alloc callback
Date:   Tue, 29 Jun 2021 00:10:13 -0400
Message-Id: <162493961195.16549.11486252640692386592.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622034037.1467088-1-yuyufen@huawei.com>
References: <20210622034037.1467088-1-yuyufen@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f0c3f41-b666-4d28-8832-08d93ab3d3a4
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5417981F7C89BCC77E9AB1138E029@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ET8llAh0xY3vYzrkHc7VXtJaw/l0VaSB1N4DdK7eLznq9mIiRkIVFBg1iPOO9Gm9LQp4Bb3dF2LLSOgwl3Zw5wzhocHAIxduzJrfBhXf9BQO4l3ffM3n9gGgxhCU2ig4k9ANGfVqvyULPyccZr6g9EM81wNqM4zYoauvZrsVs5gnkeKA8NujznjAecwBzY1dZ+4Jx4j4R7vs4UpH1SpoHNw4m6DtG2GqwxuEGo2JH5ZCXRLImFrOS7C1bkt0NKDu2SkpjZbooIQon4dDKe78HQ8aDAwuQ3LUMUEYkvmAK+BeRLKubrFRJDx6zk3Gh/NUFv7zLskuyZyJLNO1etk7lbc+gIQ2H2ObTIxaa4UDQQF1pHPy5ekQxRq2crnOtcY3RgXPW15XcqXWRozvyR8ZN2yiICTRmiTfYR8F7LXAAcNW1hd6oadLyxPv024RGDlwglHovYmL87l7d0nad8m2tmCLuApGttyQ1OtFbXVS6YV6bHsQ0kyz3unPGUP5Y+hJQ2EwpV8ymI+qmZDxzFkvr9AGzYxegzOzZGYk1lQw26nSobnvyafNk2iz6meR9pvBETL0W/Foid5YrMpg8N3QfUsnSyjyXv4IDnKx7cVQ4WpESLzVkyY91ETX51RpMWdkEK65mpA86KoF6Y7ZZWacC7CyYQCB0YRqqy5Bfs6o7V62s3L7OvWP1hKa0VZAf6m0HVVFpAz+SFPgn9NTXtnWvfEky+vAkdOuF2NiEJxBCYqkQyvDvJxwp4xr1qE226Bhcdj6hYZBAUuX+rKIYeIceXh2uFaebMjd/8DVXne3Dv6eOHVcxNeq2lh3FsO9RA6bL6RrVf5DMm1FSOLPhZk1UDseKNswDf6I/lP9oSf8Rww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(966005)(103116003)(36756003)(478600001)(6486002)(7696005)(8936002)(52116002)(8676002)(4744005)(66476007)(66556008)(316002)(66946007)(26005)(186003)(86362001)(16526019)(6666004)(956004)(38100700002)(2906002)(2616005)(38350700002)(54906003)(5660300002)(4326008)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czE1TTBTU2w1N2pLb2Z2eXJsd0R3bXZLajVrQ0xXd1htbHpkQkljbmk2ZXN4?=
 =?utf-8?B?Yko2Szl2NU5IY2ZaSXpBYXRkSm9tc3J4U25OelVZWUJjWFFiU1BoZGNmMkVp?=
 =?utf-8?B?dzdta0ZPNlVvUTVZSUsrZGh6eng4eW5rYmxBY1pqbTZIM2dPN1U5QnY3dEM3?=
 =?utf-8?B?OHl0dHJDNTdKMytKbWFicms1NldvdjN2bmNFaDlXQmtaQnF3Zk1jL2ZGM2hR?=
 =?utf-8?B?RDZOWW9rTHZ5c2VaUnJjcWVhSnZYZWx5ckRBWWVqRS9BcHpieG1tVUpuV3hx?=
 =?utf-8?B?NEpiRHZOTE13K1VjOWozUWFTTEdkODM0dUJCMFhhZmphOXFnM1ZlRTNqNFds?=
 =?utf-8?B?a2lhMFFDT3Zrd01TenVZV2JsRHF0OUZKTk9OU3A4WnJzN0djblBwSGpzcitI?=
 =?utf-8?B?ZTJsaFN1NjVhMHdsbWt6QU0vaitNcm5hanlENWp5NXJNWk93cWw4MTRQZ1Jw?=
 =?utf-8?B?U3RIci9OQ2tFR0JXM0FYbWpXamJJemlPSmErZkViKzNER09ud2VLYWlZcmg2?=
 =?utf-8?B?WDJYWW1FVmdCcWFXSnQ2bEhQL3VNRys2d2FpR2dqRElRZ0ZPQmo1YzVNZkxS?=
 =?utf-8?B?WnB0M3I0R1F1YUFBRkNkVE5PNU85bm10SHczQWJwcU93by9UVmNxUmFMdWd5?=
 =?utf-8?B?dEVlMUVTRlVBb2xYQjNLMTgvM0xNY3p5M1lUaStIUEJqVEZOalpmZDhUTjA1?=
 =?utf-8?B?RjRRZHMvaWx4elVGV2ExOFZiT0JtaHFTbHdha2l2RlVETGVPUUU1ejhsWkov?=
 =?utf-8?B?eGtSci9lRlpSMHhqbkl3L0FUS1REdmFIQldLWExFNWlvRnFnUE9ubWl1RVdQ?=
 =?utf-8?B?QmMzSm41MmlQK2tCZ0tLdWsrS1RZVzBZMlhSRVVVMTczei9PSWlJZEdXS2pY?=
 =?utf-8?B?UXg0ZkdNcmFCTml6cU9pd3ZVRkorREFCQzRtdzJ3cDhCUkM4OXhabkFadzJM?=
 =?utf-8?B?WTd3TG9pZElkcWYxTTVlZlJ5ZytRZWdzekRNSk1rVkRwVm1seU1JbWcrU1hM?=
 =?utf-8?B?K3dUMDAyK083WWJ1WE94VGlPbGNzU2lGSlRNSHZTOWVHN2FjeEhqbGFLRnpM?=
 =?utf-8?B?Wm0vd283N01ZWGpWQm9XVHhZamthaHpmNStMOEhXendUN3VCc3NZLzQxOFBO?=
 =?utf-8?B?RVoyaFhUUitCcllCMjJQaWp5TnNQbmxpVk01a0k2WTdVS08xUlFqaHhwZXly?=
 =?utf-8?B?R3R3ZVJtWDZUQXA2bGtmYndUOE1Nc0FmM3NsN3VOSUpjdDZlNG90a216RmJW?=
 =?utf-8?B?aVhEbnA4dXA4RmRtd2lKMUh3RkJFaW9pbmx4TjlxNk1oMkNUMVBYS0pvL2JJ?=
 =?utf-8?B?ZVhDSmJUNmxpeUNiNXlCa3lzTW5NQWFsUE1SN0NFaWd5RmxSRUtURFlVai9v?=
 =?utf-8?B?Y2lac1lBNG9BbWdMNG4xZ0JVMXdCRDRrcU52NGdzZFpWV01ia0JybEQxcEtH?=
 =?utf-8?B?N0NaUVZUSlM1SzFnclhBbm5Dd1p5cWZtVXkya3kwSng4dEp6YTBhaHZJK2xM?=
 =?utf-8?B?VEtxMDJHYWVoTjJ3cTJiY2NvV29YL2FnKyt3VkVlSE1FdGdyUUxucXdINkJu?=
 =?utf-8?B?UUtZUWlzSlZUbjBnSzNpdEFGM2JUcVl0OGdXOURMbGhtVHFXOXJCeURTUDNE?=
 =?utf-8?B?RVdoU3o2c2ZGb0RTa3d2bmkzVkN2aG1SS1lsMk84Rmh0SUx2ajRGRDAwL1M3?=
 =?utf-8?B?d0RnaEZ2M09ZV01obHcvSWV2SW4rUE1ycm9wM1JZblVOZGZyUGVZVU5xNmhB?=
 =?utf-8?Q?b/h4/GI/hcG16g8kLKKnUO8EM0pNoWuXU31iD83?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0c3f41-b666-4d28-8832-08d93ab3d3a4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:27.5859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tvk2HfaenA7geKLuKAywRsUQ8e7J/ApG4fh35WzJ2kox2qotWEHFuNulBaC0/y9oAa173FY9HaNftbWzStZw0r2tHdU2noLtD3QqWwmRbuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-GUID: QAf1MU4FLWWSuZOSNronqZmZpNijeI9l
X-Proofpoint-ORIG-GUID: QAf1MU4FLWWSuZOSNronqZmZpNijeI9l
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 22 Jun 2021 11:40:37 +0800, Yufen Yu wrote:

> We found that offline a sata device on hisi sas control and then
> scanning the host can probe 255 not-existant devices into system.
> 
> [root@localhost ~]# lsscsi
>   [2:0:0:0]    disk    ATA      Samsung SSD 860  2B6Q  /dev/sda
>   [2:0:1:0]    disk    ATA      WDC WD2003FYYS-3 1D01  /dev/sdb
>   [2:0:2:0]    disk    SEAGATE  ST600MM0006      B001  /dev/sdc
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: libsas: add lun number check in .slave_alloc callback
      https://git.kernel.org/mkp/scsi/c/49da96d77938

-- 
Martin K. Petersen	Oracle Linux Engineering
