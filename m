Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C367AC4320E
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98F8C6125F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbhHXEEL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 00:04:11 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16358 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbhHXEED (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 00:04:03 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xDZI012605;
        Tue, 24 Aug 2021 04:03:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=N/qAjwnEOt6I/LcwARUQ/du7COp02Gs+Wx0Uz1xFRpU=;
 b=eEpQ4M13ZtYmdYvL3tfToo1UEGDzONtC2CPsZDHk8zlAJkZ118PrMd+UYYiH+UiEAnN7
 ypBC263NdQw/7p+aADBAJt/6SvW1rL/PKbZtqK/YGXOnDRI7uSqb+lrEKAQP8KSBYVNy
 Uh1Mqusl7GNGUGOHFfDpg1qyzhWp04uxl+vdjY8Kext0xXm/YZ+ibpSrFaxpG2ETja8e
 dUGI5LfYpRLAm9AHFi1wCh6ivhMmEH1A2oOJdJDe0fhry9i360RY/yFtWGiiKZhVnUfp
 RdJ4vMAvYEh7Npgo/ZvwJBAt6vTmJrY9s2lE2s658In5Gvt+PQL+ZknW78qu+mkECmEV fw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=N/qAjwnEOt6I/LcwARUQ/du7COp02Gs+Wx0Uz1xFRpU=;
 b=Ux5jcjeQKqhfXohzFEiL2Dh1i6Iu+N39YuCky1vkbyxBCV8JqgtC6056IS9YhpJYkdAe
 NH06h7DY+eMa4Ik+RN7fPXWqNcy/0V3FY5l14+KK0x1B6Z9UBLLVPZjVJPKEyYhzNDwD
 ZwuOjP53V6qwK0ThJRpiIDD8L8u+Bc7SmFubdvxu6NsT866JmpqMr7TcMYVH+DAsjjgc
 4VO1hLuTEgannNB+UdwGehUY/WylzwLG59/o7apMzkwdeglmR444tcbOqsfddsl3Bgui
 DtedMFJZCPCfDEyD/n82ZK6X/ZHyliv7sCCkpt3NL9ZZQmPkdSnkrhAfMA8o4MOU3OCU 9w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwcfb5sm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:14 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O41N3q082500;
        Tue, 24 Aug 2021 04:03:11 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3akb8tya34-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hJWDoz+51xepK0KO3XibmE/jwOOTtjNEd2mlbaNWGCxtGRyIpNqINQs8gy3Oqxd3X1BMTv37Hu64WsRzNwqgLu4u5p3XrUy2tTv4lyk8/IakbKSQNtX326Cu2lWsIBUZxTByRATDokdyCwY41jeaq1aBZtXRbWWEBZPc8YpyeoNmyhsNn4hNSKm3p2Jnt0p3pZv2n9BzCqAbFJbaQxUKhD0Drox8JFdiyoqe8PYOoX8KvqK72+BYmcKVLIyyNC+8rMYxamoaKeAGmOk4xJeS72zjOCPCgPQmcV4d68YPrygNN2q0co1hoy1b2s+FZOgGmL0H0gBGzZV8QUTtF8i7zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/qAjwnEOt6I/LcwARUQ/du7COp02Gs+Wx0Uz1xFRpU=;
 b=cauTk7t/yTcdlkjD0BiObnGe6I16IaaifA3FBwFs7knlO/09oDmv35HHM/Zczepci72kK7G6euTOI0CA9IzCAPHTzzIm7a2dYaXIFFP83RyDHCXpnht1LsIjzpWIie8vaDZeSnTXw0IlCTE21W2yP3j620sBc8NJ83uBR/e+5h7pfel8F3rsw+9GwUwKCiQv8X1Q1cIfprj9o1WZnHj9E32oyJjEvhAC6FAYpQJOv6Cn0z5OAOJKZbwi3isKPwLpge5aAY5YsDV6U0mfZFdlNdjzO9jLgt+pQooLpgJLxZmWI7QWQEB7XeHDNCyoXWYH9XxDzItoKlWAInKX8xgoHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/qAjwnEOt6I/LcwARUQ/du7COp02Gs+Wx0Uz1xFRpU=;
 b=kUL8Th8DinKmxpVShV9oAVd7QTHv2lUnMcgoj1/4+gtI/pnlJkf76WQ/bcYZNJ8kOEWNTsLtsOZPEY+l9xRy2bu4oFd+vQMnTiH/ZRp5evg67xCymLv5A/V/ECo6P73a5siUtESAtiRaUmfCFfuxw6Trn8EFKtSkb/xPtF5Sjz8=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 04:03:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 04:03:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tuo Li <islituo@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        baijiaju1990@gmail.com
Subject: Re: [PATCH v2] scsi: target: pscsi: Fix possible null-pointer dereference in pscsi_complete_cmd()
Date:   Tue, 24 Aug 2021 00:02:59 -0400
Message-Id: <162977310549.31461.1789264867256411794.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810040414.248167-1-islituo@gmail.com>
References: <20210810040414.248167-1-islituo@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 04:03:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3899b79d-a6e9-4e0e-ac56-08d966b41601
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5529A5948D8C5618483D285F8EC59@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D3Cht2LjKStfNjCPo5vmhOzymiApCzfIsPHbFUCGcjkEkiBSKrv2SkHT9aEle6o+Ds4gCmaegbuzbo8+FdctVLLt8VI+ccsmgvqjlFep8UdqbENzdvxlSpncJ3DLaXQ/F6FAIRd6OjWLl1M/H+hqThj8KyeL+VYTvWHO4oS6dIhQjcE7hqOw54ptxZFPZnpjw+FwOYlmTx4XNSw6FtFV+DsTIAqUzf6qOghMWkh5LaZpLI3jIq+WlHfGjWNdIL1owOTkaeFoZ6DH5qTO46xQr2LOZNaiRzFNEq1j1SHIZ57dvhUM/ZlXYnEUFL2zjiHEWwxNxpQr/B2+8d3nwBwZ0sIibs+iwTHJ3mMYDsKkOAD3ocNbcNtjNmRy5+oCqJ73opKIaX5O51DV50pPit12APwOBs2fO1vK0FigUAjJ2jW69sDiHjJKvKLN6mydsH0VxHloTE065tjN1kWo4DeW10suiKxwpTPlpXk7TtlQCeVxgncYqd2sOHM7qf2b10/+sO5i6pjFjPLOkmHJi9JwUQ9ivzI+SaRDP0KyXxoncWQqFAKBgr4ZxFCAL1gwQvsn5hHdkJ8NZEKgey7uJ/ZKG5lcgxgIyW/V2S6YcdQH5AQWdRLHli1eR242ozR74A77rA/D+Dd0YcmzRpjijingl/JlI1SXHy5Zszc/6ZGAOPayPxgTSSYUWIQu4LR6OozhoC37SNQn9tK7C+gNgS0C68drvuZSOwpDDhM4usLbHqbSWdupUK1yXialuQaBfCXAtesIeU/r1v46tIcyThdcQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(26005)(5660300002)(4744005)(186003)(8936002)(966005)(38100700002)(54906003)(6666004)(6486002)(7696005)(478600001)(4326008)(2616005)(956004)(66476007)(66946007)(52116002)(2906002)(66556008)(38350700002)(36756003)(86362001)(8676002)(6916009)(316002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NTIxU2dJUTdTMXY2N2w3ODFZL0FscWpBaERWZ0R1VHk1bUNHVFhlMkNoS2p5?=
 =?utf-8?B?elVzdmdVM0oyZWN5YlNOYWJ4ME16U2J2TjU5NnN5cmExVDNNbmpOeWF3UkRw?=
 =?utf-8?B?TlBTWS9Ga0hubm5oeXc0ai8yUmU4c0llZzBveXJzVnNYT1NGdk9vNXBhNC8r?=
 =?utf-8?B?SzVzcmYxMEhrUXBCME9aclA5ZmcvSnF3bnFVZFRnZ3BOOGs0ZHZDYjlhdGhD?=
 =?utf-8?B?MnB1OGNXZjdQUERRTjZMcGE4YitxVmNxa0hCZVJLV1NOZW5kK1AvRExyRWRI?=
 =?utf-8?B?akNGZzRkb2ZCS2JRZHN3Vkt6WHJOa2p0QVgrQU9saUJtQ0trYVNzcG5RL29U?=
 =?utf-8?B?bFhYZlFReXRiWG1mekFwVnI3U2RmZDhnSWR2ZnpWZmJ2WDhnTFVTa2JFOWZr?=
 =?utf-8?B?LzM3bnN2d1MxZlN1ZkhwaklTTzVYTWpWSExNZ0VHdWpGZEpjM1hubDdUQjJC?=
 =?utf-8?B?SWgwbHIrWXBZVW5VOFVXdmVBaGErTkFiYTRtd1MxaHp1YVBQbGdpL1I5bHUw?=
 =?utf-8?B?MkJTb2Y1ZnZWQmQ3Skw4UFdpZmcxc3UrK1UyT3ZnYW5iRkxxaTJoUDM2UnU2?=
 =?utf-8?B?bUVZRiswT0pRaFZGVXNJNjRqa2RRVWNLV2pEdDh0T1FSVjM2ZkJ1V1NtOUdK?=
 =?utf-8?B?K3AvQ1ZhSW42Q1FkeXphOXRJZ3NsNCtoYzROZllENWxVV1dGV0U0ZWZMRUtm?=
 =?utf-8?B?UmhPT2lZZTRZd3hjWjlBYk9qUmJMMkd1QlpHd3IyVHNhbjhiQVptbFhqaTFC?=
 =?utf-8?B?UUhZTGNWVXNNaHNpNUNpN0JIVTVGQ0xVNnIrQnkrRUJpZEU2MlE0RVV2bTZW?=
 =?utf-8?B?bUh3a0lVekpwV3I5cTk4c2k0R1BJcDh3a3ZDN0VrY2NLQnhsNXd0djFuWEJI?=
 =?utf-8?B?am1ZM0JjVmVWN3lFSncwWEZQSnAwaEN1enNBd2JKSmovQnNvNVBQMWhuMERS?=
 =?utf-8?B?YUZ5dy9jblpNWnRLTXpPK3pFSXF4WDE0Ny84SkVaSVBoRGhSaGI1M2lNanZH?=
 =?utf-8?B?M1BuZ3M4ZFJ5WUtlWngrMWNoN0szWmZrU01uMUcwT3ZwTTRlU2ppWTJjT0Jw?=
 =?utf-8?B?dHd4L2dPcDdUSHAxSnZudkkrZ1ZpYkxqQk9iTGpBdFMwMFlpQml0WGdWUzRi?=
 =?utf-8?B?ZHkwMzhvZHZPZm0vOVZWRkpjdGZXdWZIWXBJbzJZckFKZDBLeVUwdFR2dFQx?=
 =?utf-8?B?NDBkVEZQMzd5WXJ5U29XZnE0eXBPdmdxR1VxakgrUDdnUDNQRm40U1ZiYzFX?=
 =?utf-8?B?dVZ0aDB3MDRyYXJSTnUwUnBlRXNRWkF2OVBhU0J5MGw0QkNBcmxQaDZpak5B?=
 =?utf-8?B?MncvNnk3MFZ0QW45WHJwUGRGOUppbXVRRit1cTlpb2lWMnZSZU5LbS8xMFI1?=
 =?utf-8?B?UUNja1luaXhWZXRHSGxsblJrOGZtTHR2b3RvUE5hdi9JQ1NRbzJaM28yMk9L?=
 =?utf-8?B?Z2NPNENCVUFKZWVhS3hMeDZZd2ZnYUpEb2ZDSCs5NFI0T1JFTEtmOHJUYlM2?=
 =?utf-8?B?RmdOejBqanBHbVc3c0pGTHJ6Y05SZitZMElacTIzai90Rm1oeERUTEhDcS9J?=
 =?utf-8?B?QXgyZGFQSnBYc1hmQnlrZnk0TWdJSUxwcXRpZHFTWWw3VmJCSUFFUDFyME5X?=
 =?utf-8?B?aTBhTzRKZklTak1qUUxSRUJqRUtOR3hIRE1pK1dOT0tsenVMdEhYaFBRUGxx?=
 =?utf-8?B?dksxdnl3OXVMN0t2K1JGMUM0Q0hmMmpxUTV3bjhTYVUxU3kvQWc4R1cza3hi?=
 =?utf-8?Q?YlprMfkKtU/3BWfY8V9EXkIZYVR+vkg8Iotkwgd?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3899b79d-a6e9-4e0e-ac56-08d966b41601
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 04:03:10.0962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hQUy/MEd6OuQjZCFsvUbupfNLxBMXVsc9s7wCtInx+e7OSRL7KLqDdoRnXFumh4NV/UenPqr9FIxrScsWGDQMkG/v+n1qg8aXvEyABNy4ew=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=895 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240024
X-Proofpoint-GUID: J5_8a_quObzJFND1tKbpiuuqNjF9bezq
X-Proofpoint-ORIG-GUID: J5_8a_quObzJFND1tKbpiuuqNjF9bezq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 9 Aug 2021 21:04:13 -0700, Tuo Li wrote:

> The return value of transport_kmap_data_sg() is assigned to the variable
> buf:
>   buf = transport_kmap_data_sg(cmd);
> 
> And then it is checked:
>   if (!buf) {
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: target: pscsi: Fix possible null-pointer dereference in pscsi_complete_cmd()
      https://git.kernel.org/mkp/scsi/c/0f99792c01d1

-- 
Martin K. Petersen	Oracle Linux Engineering
