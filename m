Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9E7C48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425CA61369
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbhFPDvW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:22 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:52822 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230457AbhFPDvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:20 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3jelS005731;
        Wed, 16 Jun 2021 03:49:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zocsTSlpyuhzNSdm3ml6Qr5I8u6fKMADbI1Gooy8bcM=;
 b=cvBW0/udZ9TM8ALDGcK6y1bJxEBfA5HZOQ2aqM8l5tHw1hy9Pbyv61D2mWFYsLIr766Y
 eXEgWLAHYjfpk4GNp6nMRg+U8zZE7IcJjvJ2bXXVUWuiO29G9cLnpGjGTFU7mVNbL0bH
 W5di6as7xrk3YOKbf6YJvLJyW12M6ty6jT6YK7FLQhdVxwBw9us9MQCNEtH2HSS6OEgV
 OVs6F8UoCi5mMbhAz8Az1ZvPnL1kXovRzNu02qPUxcrRakqN/oOOR5m3yUTSJIMmTxl7
 Dfrevt1a5JZ0DjMgSCTKZy6IAH2zLqD/zCxg+gnBwlW/c0/qw6UHIUDSkXg0AUOH2N8j kw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x9qstxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3jZ9D148191;
        Wed, 16 Jun 2021 03:49:12 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3030.oracle.com with ESMTP id 396watxnpc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5IXd8Uv2Tm5sS4xVwdyQmerZT50eFvZN1rVtqk6CJhDyqQvfEKanYM+rAekVkuI6e3Y7iVxyNBIhaSXg9jwu+tqC2ILKyzs9/MbUNI6us0N9OQC0DZA5fmskO7zrjhwo411/CG2NbLioWXgThQaJzy+k9TH+U67/tjIPztBnJQE1yIUIDEaY4Le6p+XH4XtnjW32YqfeZYS00ewC8JsvhfH2bTBUuHvNxwza+tw9Gy9eqxE2zhDc8PvNBGqBVtd/IIG+YVVQVtfdjR5o33tdo7BCi1leikMich8x/Kpl4qiLNpbXdxYhvGGwVZSwt71DchMl/jcOzWmuM5Hp7xr7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zocsTSlpyuhzNSdm3ml6Qr5I8u6fKMADbI1Gooy8bcM=;
 b=jzT575CgggZu0J03imj3nh+Alf+aBQNhpNa9iPkCc5nfOcWvlBPBYIpT0okspbX6LUEsnPzM46xaKmRsuZpG+9UrbM4l/FoIJti25Zwq2TlziU6FXXvmpJAuOPKcpbehgE5KhMSejd92GuJaYV0awbvRxcZ4g07FJEe8U/Dv/axhZZC+1Qqq4KLZvfO8KzKwNjte7kChm6hpMZt8GDXEdG4PMNbZAR+rbgIdPptl5F4K7UKeNwN2nIbAEmgHg1BkJd47W/WNjeTYFf/JJDxHVOR3yGG8nolHe6elS3zaBL6FcPgH6bV2UEafI6iHTO4am8RWZ4NQRA7+JknQ8HBJnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zocsTSlpyuhzNSdm3ml6Qr5I8u6fKMADbI1Gooy8bcM=;
 b=pMsnltN4a2VW/L63J5UBiC3s57LHPU21dCPUpgEhBMI2dp0c+f9/MTQtsv0dV7KrUscjlRXHFxNUTSdrHlSTyb/TqFwtpp2C230ZJUS+UWPC7UWhYeB/lQcb2bo11sjn++R3EjgQEiVyvJvgLdubzFF9TvgPtE4NmQP9aO8k/hI=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:10 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     nguyenb@codeaurora.org, kernel-team@android.com,
        asutoshd@codeaurora.org, Can Guo <cang@codeaurora.org>,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 0/3] Optimize host lock on TR send/compl paths and utilize UTRLCNR
Date:   Tue, 15 Jun 2021 23:48:50 -0400
Message-Id: <162381524895.11966.12465269181374620543.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
References: <1621845419-14194-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ebd52f40-460e-41ed-cf4f-08d93079b32e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46636B6C8CE42500AD39EA418E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kqHWluniePm0aov0fdLXyySDyODheVP/ZiNtQYayUe/rp5EUGS+yfHuP0pldLAi5SL8bM/6fjMST0e3rMbL/gTVonkU/cf8quQwyOrdV2HMKOMImy3PwBzVF1d7O7BEat1ftkQJBFZfE2SZh6lIetBW+AtZ0JfqFSjxa+0eoUm7w66y4FQDhcgYJ458HDieMEpNbn65kEfr0vYHFrZeAoK576ylSHoLe26ZTdN+CoMlKHAjkq9hBTBaVmIPReMwCof7dGaYbukcoJyUqqDYZxqXgslxCyDTwGfyYao1VVzB3MIKjjfB9D52l3vwkC/WiMf0jWsPwgs5F5HTlp2+G+dr02a3q04mzMvrjRGfFE82gP153v+HDsT9inG6C86RUHOkahDeiGGEPVszNyZMNHdiC8WNf7om9IaD8qVcfEWyoz5FVcvSzJ7sjQ1MPTJqpKyMW19a2NZjrpFci2QNo3TkK5Eha964so15vGm8YkBGU0b1z1TE8Wq2ib26JM7CP6wAxlbYf36mjurOuexOgiRqYFY69na5iRfDQa9OlZuPKh5oo884fqTA6ZB6fDJ17WzKH6rmtrzrtSezhuOIJ+HoPi+2xJ7QASJe2TgVDoC5t6qeyi9OhJgnRlbD46HobPntg1Wg4Ptk7xXEFZWcpviY5t4OGfp3Ax7ohvI1xM5tfCUZfoHWaLJXJ7LTTSFmmGIWX1JwPQigJWKT5SV6fvGlD932cZSlzxFqj4yThbs7JXSqu17Hk2tdA19AL1AfUpr1pprbBjwSyqM4pg09TGdXkbtgvGthckS/mnxf5HHJ1rW4eKFHKi35IntO/b7Lu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(107886003)(6666004)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3dhMFdSaUE2Rml3S25HUFc1c1B3Z0UzM1BURG8xMTdWOGJBanBCdEdNMEQy?=
 =?utf-8?B?QkloOGllMS9FTm1XbjRQaTdwd2puaHBCWC9iSHVDWGN0eG5GYjVqZ1YxbklW?=
 =?utf-8?B?N3E4RDdpVVVBbTU0Q0xLODl0R0dRazN0T3RiYXNXcGF1WXFxb0hEeGFiNjVp?=
 =?utf-8?B?bTlTQzFjOHlTQ2JkTUZjRThMVlZva0FERkdkbGtMRGVNOStrcXYyVHlLMmQx?=
 =?utf-8?B?V3VZTndQbVpBOVVsbFpZRGdrVkQ5cjBtc1BCc1I4RkV2L0xsMDY1bXZwVGF2?=
 =?utf-8?B?ZzN3dGdkRjhGdE5tbXJpWlhKN0ZkdnJSNEZJblBwY1p3aTY2dlB4S3REZWIx?=
 =?utf-8?B?eXlXMmhYWmpoUkJ0K09pajh2VjZEN3NVaHFVMHhvbmZJYTE0S2dYVXR1dDV2?=
 =?utf-8?B?Vm9HK092M2JjZHBGRllDa0dYWXdRS2h4eEVIanlKWXhmaXh2aUpzemFTd0p3?=
 =?utf-8?B?cjlkdU9kM0pVZXNuRXdnd3RtbEdQb0xRUzRXY2JYbzJlUi9SYi9DVTltREZx?=
 =?utf-8?B?T3hpelkyK21EeXV4QmJ0YjhNWHZTeTIxZ2Y4T2dEdjVpNi9nYkJXbHVjVXJU?=
 =?utf-8?B?Zk5LN1IrV0cvdS93QkcrTWpaR1JXUTVDNjlCZDNrZVNQemIyclg0M2l2S2p6?=
 =?utf-8?B?bHVYMHB2WHJpc1lFcnkwMGI1QTB6NEMxQUpWbUlXUGxHVkNiVGtqdG40ZFZK?=
 =?utf-8?B?L0p0L2NDWmozY2ErM1ZTTlZQMDlKYUgxVW9EYU1DM0JxSTJWOXZ5MERnZ0VT?=
 =?utf-8?B?N3BrMmJGcHhmNURRSWVadFdwdHhkR2g2Ym5Zb05vRGRlTnVUQXpmVUx5ZUJK?=
 =?utf-8?B?bjlIa2tiRXFsRjFKRWJJUmhESjdyamYxNG02RElTRzhreGtlYVFrNFFDbFFX?=
 =?utf-8?B?VkZwT3V2cjZUVmswaGNDdDBwRzlZTnNqT3lLbmw3QkZ4YTVHZDFQUUhtczIz?=
 =?utf-8?B?SXl4QjNVSklHaVFHL0F6TThmcGxjVm85TUd4UEppWC8zbXJacGJXdnA5VWdJ?=
 =?utf-8?B?S01RZWVqaXNqSmc5cjFDRmtKMk42NWtMYngyRXFnYUFjZWwxTmUySWMzZVNR?=
 =?utf-8?B?bWNoM1kyRXEyU0QwZlBMWWVyL3pLd3ByMlVrbEVVODd3TXM0WHB3Y0RkZDZX?=
 =?utf-8?B?TlBkV1lLODRhc3BMZ2JHSkpMTjNHbi80U1Q0ZHdEVXE3ajc1OW1xRG9FbnBE?=
 =?utf-8?B?RlB1STQ5bHh1UHg2ekh4SW9hYnJNYUpESWlURE5JQUR2eTNMMWJ5SUNVN3Vm?=
 =?utf-8?B?MGlHUHU3MGV6UnJPSzg5Y1BaWDMwc084WWp4eFZyc2NvVm5nZk0reGZSZi9D?=
 =?utf-8?B?c1dDVENxQnNKYlBEQlVOdk1UUEljSUJhNWhpYm5sRkRlVFNrWkhvbkNqMjlX?=
 =?utf-8?B?T2tBdk90TGFKRWV5VWN2OEdNb3NsMHorNDdYVkEwUUxVZVREZi9KUklhUzZ4?=
 =?utf-8?B?WHdBRTdxeFdNV2NXbDMrMzlRRE5rM3ZwTEd2YUwyRkVNaWw0cWFKTGFTNWhk?=
 =?utf-8?B?MzBlU1hiajNRbmZLZUFRSCtMRk5KRnIzc2N5dUtvUWx3bW1kcGpQaDlqa3NZ?=
 =?utf-8?B?N0xUVmhqRkpTRXpERlFuSy83NXBYNzFKTUdjN0tnaG52SGN5b1JUMkdaT1pD?=
 =?utf-8?B?NWVpRlRwdEw2YVBSK2k2TlVvdmxPL2xudnJBWjNjbUd3OUNGYmdzbVFRMnpQ?=
 =?utf-8?B?UmE2UUpLWlBhQzY5cklRR3h0aWcxeXR6QWJRcHFTN2NwUHlLSERpdGRWZlpn?=
 =?utf-8?Q?KRH6RCP/Dja2Yf0SL2+si44tMZL7JytFFbcO5Hz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebd52f40-460e-41ed-cf4f-08d93079b32e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:10.6644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fclLKNEKtmxWpjzXt6psm4dKKVpo8ysokngMWC4J3Ptv9fJN83zT7HxXP6EmD13jMUWcKt1Zpe3Z+K4v5uSSpyCQ+jcR5eeUJnb7e9fOp64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=730 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: PCvCO92pL9SoVBtY7oMgXQ2rz8At5ozl
X-Proofpoint-GUID: PCvCO92pL9SoVBtY7oMgXQ2rz8At5ozl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 24 May 2021 01:36:55 -0700, Can Guo wrote:

> By optimizing host lock usage on TR send/compl paths and utilizing UTRLCNR,
> we can get considerable gain in both random read and random write performance.
> 
> Can Guo (3):
>   scsi: ufs: Remove a redundant command completion logic in error
>     handler
>   scsi: ufs: Optimize host lock on transfer requests send/compl paths
>   scsi: ufs: Utilize Transfer Request List Completion Notification
>     Register
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/3] scsi: ufs: Remove a redundant command completion logic in error handler
      https://git.kernel.org/mkp/scsi/c/1cca0c3fdc91
[2/3] scsi: ufs: Optimize host lock on transfer requests send/compl paths
      https://git.kernel.org/mkp/scsi/c/a45f937110fa
[3/3] scsi: ufs: Utilize Transfer Request List Completion Notification Register
      https://git.kernel.org/mkp/scsi/c/6f7151729647

-- 
Martin K. Petersen	Oracle Linux Engineering
