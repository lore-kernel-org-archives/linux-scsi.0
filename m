Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 972A5C11F6A
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8154061D54
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Jun 2021 04:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhF2ENC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Jun 2021 00:13:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40850 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231594AbhF2EM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Jun 2021 00:12:56 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15T4633e012563;
        Tue, 29 Jun 2021 04:10:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=d33kiD1qU3Ej3bH1c4tlQe2xgAV1h06vu8/BAbXGPI0=;
 b=nMGchaotVX/b2B7gdIGRcJrHcNKiYe6rej4vCUAJI2DR6p1YC1j/3JmzyqsyirGttmAF
 n1/AP2gZg15Ro2no52qA0XhiWopuCuiymk0KE5d57HLvYd4yRvkg7IQx4kO29HY18zh+
 ihzGNUyO1Y79TZr/YYL3hqtmMbmZfo4z6K/EyVGqncQAr770mGOzMOi70zixZ8ZdQSVo
 N5T2wVsaVvz+sEEyMFHxSeFQHkSCqKM+WIzjhwVhrOxKX24o70Jd84YXzcPpEPuGAtWe
 dK5Vn/WCRA/bBmNtyVr4a5NmRbxIbLWKgmP96yxPmZ3vAU0ikYrY65LuZqzcYsH2kDAv 0g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39f6pqafqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15T49rjS052345;
        Tue, 29 Jun 2021 04:10:26 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by userp3020.oracle.com with ESMTP id 39ee0tv4n0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Jun 2021 04:10:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGbN91dagPKnmWyb6wao2f1okIW2dtig3d1qLL8q/iuURHvYDDrAyEpU7dVEoLmCvGhEirths28x/jUslY+nwJAN77a+KXtDrMjTTaYJHqdhb8HTvF95RVqqndYzgcR1GPLHWb9eopotqq33QhPNGsu/z4pZuCShxosy6DpRZvWaznoriabICXXD+s5dt2LwaxMznD1EI0PZKI2Mwb08AtY9OZsRbE3gNOkgMH6kMzuWdwzxgGq0JvGTyQTJSCMYbn6eeUh655r/YWJUtS3DyjaHZ48qu6D8VCxqGFNwjmLNfQJOFGSJ/izq/IyYLrv98U6oyM22akaIMDLbffzVhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d33kiD1qU3Ej3bH1c4tlQe2xgAV1h06vu8/BAbXGPI0=;
 b=RfNgQXYdPH+dOloTlA4lFgSjUja+r0Yu3HmJI7e/1u2PXgAOf788GEzTUV1VzCUeFTKm1O9rk2WHxe/+bYE0rQISHMxf2z15h/7LpqXuHoGoA/WEeRJC3TaghoWHRPovXhMc49NccH2tSg81AffqMJi3PvqRe+ZkTv1zkyA6oiSc1bofaHYYyFD5egdxalrdD36TimeSd3ShVUoHlwHbN2E3pjfP34QEPg00JlRvlIhMRrGN5x0MnDjRDA4WswLvTQ0WupN1GTisR+bLNO0ox1gkTr6R7EfVtozHk0igfDZoKt1VFOCcIgoIqGRVpx7Q00eQ0kI56Mvm73nNBLrjvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d33kiD1qU3Ej3bH1c4tlQe2xgAV1h06vu8/BAbXGPI0=;
 b=gZw0jRsLk+2bzzhPF8lQS4Jp/xeR2QT3u3RNIUlBykIY76k78CgB9h0Jv9voeJLPK6JzScK+Kj21gzKjLvtCKG4hf8ZmmHBfCmU2fB6BoA5yiySpB+uJDM1TPlHU23DnHgZyRJuB5oOE0YacJRjD8gRfu110fy8gpCczU1PXYn4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Tue, 29 Jun
 2021 04:10:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4264.026; Tue, 29 Jun 2021
 04:10:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        ram.vegesna@broadcom.com, dan.carpenter@oracle.com
Subject: Re: [PATCH] elx: efct: fix vport list linkage in lio backend
Date:   Tue, 29 Jun 2021 00:10:08 -0400
Message-Id: <162493961194.16549.6472633017484253305.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619155729.20049-1-jsmart2021@gmail.com>
References: <20210619155729.20049-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:806:6f::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR12CA0029.namprd12.prod.outlook.com (2603:10b6:806:6f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Tue, 29 Jun 2021 04:10:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed8312a5-e93f-49be-7b23-08d93ab3d0ac
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5417B1968F32738A45F8C9A28E029@PH0PR10MB5417.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lSSFmvAUq8BefxpL+rT6aaq0Q9LOHYQ2AIgPnFiWfVVZHmJBFsdwr9NCvh6QUUTpyCkHrjhp9Pf27IqcBygcaLtp6dJXEx0FTw5mhEvWgK5iFfN71oKn0DNxVBT0a8D7pIfM5DodBlHAPoXeAmG7BBRXrQzQVX8u99UtsQjRBCkdjhJyr9uplT1k2jLX0lx4af+f7vB6pG5prh1ajMQnHj89anM4wVt4ORzDsTk0SsOp2hUeWbPGUubSUrMoYVoA9Fg2Sv4QCxioQKtPDUroa41PkDSFO2+JMMuhRY5ndtq/JRueVQRx2ez1TaeTxft0o+dCDdO9PfRWPzDmp21QTIEme8n5KuuJG9ijJGcoAYZo6uSXMU9D457vDR/oo3dLokh6bYzoaBYk6NL70/D/vUPqef8HQxCsdo4vUltO7NgA7XaXj8Y01csN82v5lQkbYxd/E5sNSqtBjknm1QsQ9QljB4BxZruO4pHuqTa8NKAaz0Z/jxNlCczMjL4VkCStx5JcvdMjVYDer3vzlBOBdFy58U8iMDsTYl0pD7KeVegHWRQgqZ8Yh17fmMR/3kjnlW1a9hqO8jnDzO/tZUwhAh2566hwWcMOrWiH4w4nJ6R9giN0nYY0/oeexQ3rSho28433TBP3fqgiaHSvSJLoJWQJYZTRJTw8nUJswkaTuLBjMMYwj/9BEXzv9U5OxqlEqPrtZDkk3hhVIr5T+8p1qxCoicGFvcOzFuTvTIX/UK14c5+3dZYPrkRA3Q58CtVQ+LISgkrcC//CyKk5zpzSRI9j/vrq/su4f3piWRcRarsrBl6E3fnSNtG9Mw3Zef/4h/XZAK9qzic7Cibp8yJNPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(39860400002)(346002)(396003)(966005)(103116003)(36756003)(6916009)(478600001)(6486002)(83380400001)(7696005)(107886003)(8936002)(52116002)(8676002)(4744005)(66476007)(66556008)(316002)(66946007)(26005)(186003)(86362001)(16526019)(6666004)(956004)(38100700002)(2906002)(2616005)(38350700002)(54906003)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHJSVVZFY2xuRWxSd0MwMjJhdXRIZmFia2ZLMXRzL3Q3RWpkTWE1OXh1ZmM5?=
 =?utf-8?B?Yk5CMERya2NqeURnVTRURHlhQWp5Vk9odmVYTnVkSFZwWkIzVE83S25ubnIr?=
 =?utf-8?B?MHYrQWF3Qy90am9xUEZmT0xIUFE2eDAzTDJiQ0FCRG5EemRDZzR5dWNkZzBV?=
 =?utf-8?B?Qm45M2pUZnUraEt2NjROT2UzTWZKd3NraTFEamsvRVlpUTNyNis0cTJCSE85?=
 =?utf-8?B?Mk1kejRPb21xVGpvOWVyQ2NlZjlCOTY0NDNNbnUwRURGeXBXVVRMaUEvN0hz?=
 =?utf-8?B?bk02cm50cm1xTUlyRFBIRjZaQTNPWkhlVDdweUNwcWVodEt2YzNyQXlic2xl?=
 =?utf-8?B?cks5dmh0dFVDa29hUzRDK3RTeDBiZUI2bkRBYUx6Z2hxeVRKczZ5Vzloc29k?=
 =?utf-8?B?bmFWcEkxOS9rWjJncUluRVBQajZSR0RRSlNVemhXTFdIZXlyNTR3VVlMeUZN?=
 =?utf-8?B?dFh6TzY4dlZFSTVLeDI4YTRxUEdqWnJUNmNQb0lVVnVVNWdaZWR4MFBDS1lt?=
 =?utf-8?B?b3FocFZYWXQ2MThuamNQdTFwMFVjQXJCK0I2bDU3ZWE4dHdBeXJHNTdhNVBQ?=
 =?utf-8?B?cDhucURXU3pXeDcxSWM5eWJaOXJvL1dnblJmcElhclR2THhzTzFvY3E1cEp1?=
 =?utf-8?B?RFM0S1RITFRrcXZnTXZjODJ6anhtVGxOdUtoOCtsVWoybjczWmxDamRpc1lr?=
 =?utf-8?B?U2grUWJNdCtmUnZyemNROEZoWVNhQU5XN2Jvb25JbFZZcEZ1bFg5T0plbmJt?=
 =?utf-8?B?S1ZhOGhNOWFjUWErQjFINGVuN0hNZDZzVWNTYXpYT0dqck1iZEZEa0tQNXU5?=
 =?utf-8?B?YmhuZ21pQjl4WlE2Tmw5NkpnSHdIZFcxdmFoaTRzbWdnYW93OEQ5b3RFN0pB?=
 =?utf-8?B?YlpGVFljWVQ0VVkrZHdtbTFKMTBqdWxkUmZlSE5Mc0gxek04QnpkbFlkaHI3?=
 =?utf-8?B?L3JURG5STnhXWGZRSmpNdVp3V3RqSGZNZ3ZBOG5QYjBiMmVwRHoxV1hxeUFv?=
 =?utf-8?B?Y3poM3YzU0FlL3pwdjY0NlJxUkZPUUV2VDlzS2VjaXhGNXRFM1lORXpGYkp4?=
 =?utf-8?B?M1VDU3IrTGpjUlZFZE1KUlROZzlsZlkvWkdsQmJ1TFU1ZFVwc0hZc3RHTm5v?=
 =?utf-8?B?cEgrVnVxSEdKSGxDeDVhUStsSUF3eW5PbnVCeUdXYlQ4aFU5eWNJVnBQd29z?=
 =?utf-8?B?RjloRHBLU01Kem5DN1NtcHlvWlpVZXMrNXdMY05hOTZPSmYxNkQzSnZQTzdk?=
 =?utf-8?B?VS9ub1cxNjlCdUJwSm9NZ1FBZ2RiQzZYSkh0VDJ3QTViTElJb0lucHF1WWJE?=
 =?utf-8?B?U3dKOG1WN3Q2SWxlYktPTDRnK0o3YmkzdUpWN1dFbFFTZ0lZa3BiSjlsclZh?=
 =?utf-8?B?V3BrOTYrK0Q1UkFSVDBGNDZSdGFNZ0daNUtKM3ZBcWV6eHZ2RnprZldKNzZm?=
 =?utf-8?B?TENCN2thdnhOaVMwL1J4bXM2TnkrN0Jad1MrbXdGdDJsMUNCaUw2c3lPSmxM?=
 =?utf-8?B?aHNyVk5EQ0dPb3MwdXd6K2Z3UUh4dVgvVlc0V2hvQnRCcmF0c0piS2lUOVBT?=
 =?utf-8?B?NWp6MUNMSTUzSkl1dWpkb1huOHU2Z1ZscmZzU3dFaUNLYi9YVHhzTUlvRGl6?=
 =?utf-8?B?YjA0MUNBdk5ucWZDRURnN3ViTUM2ZWxZUmJPRWNXdmlHRlU3NmpPVE5qZmtL?=
 =?utf-8?B?em1IdzFPU0hrMm9wejRQYlgzcWxRNk02RU05TDRob0U2RFV3K3dqYk1pQmo5?=
 =?utf-8?Q?ZhmfoOq80A+zvmDJQQkJW9sxKDpKr9JjhRXqEbt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed8312a5-e93f-49be-7b23-08d93ab3d0ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2021 04:10:22.6278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJVtDWHOXvfyFAYBp+ls0BE11TkFVFlVcr0H7EqpIWwCqoeNGssM8exRVDHwR9/vgJ6cTrBewLx0H2iL0yLn3YvzZsCjZwTqcA0yWcd9fqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10029 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106290029
X-Proofpoint-GUID: LpNOJ_VVbis9_XM22hNxgEddMK_LFdRm
X-Proofpoint-ORIG-GUID: LpNOJ_VVbis9_XM22hNxgEddMK_LFdRm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 19 Jun 2021 08:57:29 -0700, James Smart wrote:

> vport is linked onto the drivers vport list at allocation, but
> failure path fails to removed from the list.
> 
> Change location of linkage until after complete vport completion.

Applied to 5.14/scsi-queue, thanks!

[1/1] elx: efct: fix vport list linkage in lio backend
      https://git.kernel.org/mkp/scsi/c/f7c95d7460e3

-- 
Martin K. Petersen	Oracle Linux Engineering
