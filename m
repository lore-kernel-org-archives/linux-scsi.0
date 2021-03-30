Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C625C433E3
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C34F619B5
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhC3Dzs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230223AbhC3DzQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:16 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3j3op141712;
        Tue, 30 Mar 2021 03:55:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=l1tYyCUOFd82FLVXMMSuUElRcfEky4CAYbaM0jPAIsM=;
 b=i5RIDsePtbu1HrEDalajU1bMfNMxXVlEBRWsvbheEuym8c/sLEn4tLyuMyrHcgHUQqoy
 AjnZ72RBhsiNP5BSKLN/I8lYmIPgBBkm8KfrnPRjJ84DKgEFlbUaFWPbqb1Z01FeXzGl
 Tr0NsgUm3j7Yk84CKrcjSI78KR5eEIhVldbbPQ3jQLeCLzu2+8O0akkb0QbWrFI2+3vN
 62Sih1urESILfcqiTtoOYJZg5cErMqSxQnPkyyrGxAx6ek2O+lDp2qRrroR9iJCZTFSw
 oc5yIj5c2zA2R8LvqALe9cP9z11mEoiYoSPO6mn5KVE+qcT+ySH0twuxhLBCTYbhEsxs xQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 37hv4r5k39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:06 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jRVS187820;
        Tue, 30 Mar 2021 03:55:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3030.oracle.com with ESMTP id 37jemwj7bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUhzIirQLtb39uZ5XLs/I6lZXREv7qmROBkHmy+bSWJWysLGQMyuhQMDb4QqdfuVppvJsJwyOFERL/YpiZyr5s9xpX6BJUJahGLOD41Eg92WEV0lKC228TiiVhRUGvyJvftBAFkbHxz7et1ULy6ZvID5Zrt45JSm990BpCl7x2DXnhS0avpw7UHceEQDZcDQYpL5tQnuWYBEsJTd7ebqkvBL9pXWqFP7aeN2j2vzrOaYLwAKb/XJHizFtHN60VmDVadj8r2tXMds4pH4JgL86heNiSmQX/K4gwPRsJJ9FfGh2wN0ad2tgAizViWZCX5WIVJdX74FKt7h7y6J971RKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1tYyCUOFd82FLVXMMSuUElRcfEky4CAYbaM0jPAIsM=;
 b=bxqK7BiPxNEeFaLhGDMae12Km8NpHy4NPQa+uVDELx+qeB7UMgPOqb/CO5WxgznvhN5s1HHPV5RO7TBQf6DC4EAVTTQ1DAeOsLXALcSZAld7Et6Idit9o0cStIhGiGlvSy+w7bgiL1dwJo4PtRQhY9DbBYnYm0IDu0xy2QUKWl0ks+A0MX7kzbL5xCZOSksaBSbIamYkvNzp1w7sjT0x1li4rrjDhXLg8u/DA8GVyyYrwu10MstXeFMonG7jJSVFJg2m2n0p4gJvFJPJQ+0NVDaWqjSegaeP/zHul/hDr2bmYtpN0HvK6K8DWkVWClf3W6cI3MRfnnepVfae5LFYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1tYyCUOFd82FLVXMMSuUElRcfEky4CAYbaM0jPAIsM=;
 b=euQLNh7MqQxuP/qyNPb+zWcW5VkNfFfUUFan9W4wCH+Q2yCp70RZz78ourzBe79pmK0+SL4travGDgXSw1VV6M60OiQRtFXrDdPOMyciD9itkzsqUKcbXVy6yZmirZRtq8nj/MPFdjS0PpvN55kRzEwDtGXnhLRPM9Yy3oO3qEQ=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     dick.kennedy@broadcom.com, james.smart@broadcom.com,
        jejb@linux.ibm.com, samirweng1979 <samirweng1979@163.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: Re: [PATCH] scsi: lpfc: Fix some typo error
Date:   Mon, 29 Mar 2021 23:54:38 -0400
Message-Id: <161707636882.29267.9083461226547627712.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322075645.25636-1-samirweng1979@163.com>
References: <20210322075645.25636-1-samirweng1979@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f20176b4-c3f0-4ca9-cd92-08d8f32f99bc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47585CE4FF00FCACC4042E7A8E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1AzfIslT270/qxQB9jHfmFVpB2btytvxd/wVks5Xj8W7upd4ERUK9e3tIh8N5mnnJmtNAFYVObXsvWD1e132GauN0cXCfMoUTLqmBBWqPjmxbBy8AeuVit7ic5QaCT6DJBkDsuFXbGBDKhtGfcn5lnhuzCiwxAdbAzWQ2+OysDmtAv7OFcqdad1/XIzbAStk6sWu0Zn2enMyB4bl/hRZkSicsGPFa1hCGOnpn+QQJ/5A+Nm1SDSHteOav8pDNbuJbw1Kab4br8FR4EcoONNcy18qbw/5uZoAoh0EQWZE6mrR5ZFkywUFO4KeI3skQhScBlzbkC6QDG/vojMToYMSGekUoCH0KUg67KpNKBzTSseq2Knco62u9VNhWru+hL8HbG2R6mYBkqW5sOdMJwiDdyOpr0PeDuFpEmm+qH4Sm2jfMSMSCjsS1Tca5cYBP48JJYkYp+y3DJgOoWpm0MXzM5qq1/k1jneBI1FFESE/r/xnc6uvkn6R1FhYVy+VdByqEvd7kFTrlGElDVoBMv9rDjBKzx1b7542YyMwQtZPAoim4yB6bPBVECEsrfHlOcOShThSNAs/B0DzJW2YbUAIQpIxT6GfrOA1cSMie2tr/lhWHnSM0LlptSQLJ1GVvlqbLd7fIB11CNlq/ZTdRtTp5n4uJo2gdGwMXD26Iq+j5n5udLgsmEcz3uPoiEwPNGgnQlw7xB3da6pY64i91qZ737B/LVMwUBfodksKfVsfwec=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(6916009)(8936002)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(54906003)(2906002)(558084003)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TVQ1Ym5IcWxVUkpGVUE5MjUrNVdBbVlUb1kxSytZaUg3dDF0U2pFeWZ0MlF2?=
 =?utf-8?B?VmswQXNxMklOVmNIYXZlTCtvNWd3dDhhVG9Yb0xxMGtvdXNKTmdhdjRlMWZT?=
 =?utf-8?B?OGxoZkovWmxlQS9OZEdFazEraEYwUWRxNWRMUnNmSUlMNmNlcjBtRHdzMngw?=
 =?utf-8?B?M1Ryc3h0SHBybzlqU2kxdTRrQlFXQndHUXVFd0RscmYxUExuSW1JaVBUZytp?=
 =?utf-8?B?bmFSTzE2Q0xtTFJHWnRNRmJwVkVYVVlqVHBKN1EyNStlbmt4ZjhackFZa3ZR?=
 =?utf-8?B?WTl6bTlTeTVHWGRmdXN2WTltYnEyY2lLWVhhWk5mM1lTUnpNZHZLNmsyYjg5?=
 =?utf-8?B?N0xpSE5WbE5KcTAxTDBCMW0zNWF1Wjl0UUYrYUp0UjREZ2M2Y2pFaEk4OEZz?=
 =?utf-8?B?TUNuRXJSWGt4NWRyTzVhUkFjcHVTWWtlV3c3dzljeHFOb0o1bEplOWJCRTVY?=
 =?utf-8?B?SzdWNmt6TEQ0NkhDNjlXWVkyVjd6aWtDK3RWUUk3ODljeUFkVWErQ2pORmpJ?=
 =?utf-8?B?Wm5lLzQzY05VSHdqOUQ1U2RtdTNab1FBbkxsc2Eza2J3Z09CMUNHR0dnSTl4?=
 =?utf-8?B?Q2xqdHlXekZjaTRUQldWVU0yWkhRMW1nQ0RTam5xL0lLeEl1dENiQ1V0QUJv?=
 =?utf-8?B?U2xIdTk2RFU4RGgzbWVrdkhsMG12YmwrVGlwK3FuUWJtbTE1UDMyRS9QYytQ?=
 =?utf-8?B?NUp1ZTV1SWxIN3RjaWNBakp2SnZXb1hkMXJzSWhmVnpMc2sxTlJQZE9WQUZx?=
 =?utf-8?B?T05iZ3g2UDVRdXI0N1pZR1BkRVRZK0hCMmNpZm1uMWxqZDRNUVZjU3FKMnR2?=
 =?utf-8?B?NzVnYVZrV2lTNHNnRUxpTEszZmlUZGUxdjh4UDdNMERKSytSZTRCMTFvcHdz?=
 =?utf-8?B?czR6d2MxS1RiWVBHQVJxQnBkaittenpzKzJDcVRFUzIyY29qV3RLc2ttaHBu?=
 =?utf-8?B?RjdSSlI4ZTRaR0JhNzY0VG9odzRNNjU2Q0NQbGVoQmhIcmxONC9MSFAvZFRt?=
 =?utf-8?B?V3RWejcxL2Z3UXpnTmJBUjZWNWRIeUllVG5QcHY2ZVJ6YUE5VE1QNDVaQXdh?=
 =?utf-8?B?dXhZU1hxck54amJMSlV0S0wrMkhnSXJqKzl6YXJ0WGdET0pLaXU5UnZ3enVI?=
 =?utf-8?B?UWllM0t6Y2RlOWIySE9NN0s1NkxTd1JjRzNPZVVIcGlTUE40aEVFbll6OVVa?=
 =?utf-8?B?dzFWUWFuRzVRZXJSSTR3M0VOclBIcFNkMTFVVkY3eG1KdmZNMlM5Njk5dHpS?=
 =?utf-8?B?c0JQa3hXTVhCWFd2czZGNU16b3pwcEpkOXR5aUF6bi96TVJoRUZiWXFDUlVu?=
 =?utf-8?B?Znl0VkdUbmZMNHhucTVoV21yVTZkUlY2cUZLcjBaU2taTmZORGxNdGYvc0pF?=
 =?utf-8?B?VFg5Q2J0SjlGWXo3bnNzVUtBOWlTZXhDb1huOG5zWUc0dGZ6NXdMMDNlRkw1?=
 =?utf-8?B?djkvc0ZaMWMrMWZ4YXZKQVVGMHdTT2JFQkRUQUcwODlhQ1ZvaVRVbjd0VTNT?=
 =?utf-8?B?bjhtUXFuVUE4cGFqTjhDcjZpemQ2TU9oaHgyNnpLYXoyNDFLbFpyU08xcnI4?=
 =?utf-8?B?L0VObWFDZ1pla0dlcVc1VGVzU2hGRGJJNnUvd0duWTFad2RGZnZxTWdVaGd5?=
 =?utf-8?B?VTVUUjUwRkJFdGZVTVVTQkZKRS9aSi9JQzM3V2tpS2tRSTA2ZStTWkpDRG5F?=
 =?utf-8?B?dGlNUzhOQ2EvdDI1REJ1NUp3cEZoL25EMlEzZ0pySk96eG8xNE5ZZDQvOHA4?=
 =?utf-8?Q?K9AGfIU6n5HOe+rBCFNIBvj7zl1XtLL3V4Uf2vi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f20176b4-c3f0-4ca9-cd92-08d8f32f99bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:04.3385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: atx+IslCjAHq7djaxIuxEC+h/6D99dzvEEWYVevCNH2vyq2VjJWvyBvdDleRrucfZ91VDVuYhJwP1Gfoy5JAhcwDQZ8kc+ey+kTF5vUwk+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: hSYSrYX3Wg1-hGjjAbsY7mWQO7WDuLY1
X-Proofpoint-GUID: hSYSrYX3Wg1-hGjjAbsY7mWQO7WDuLY1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1011 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 15:56:45 +0800, samirweng1979 wrote:

> change 'lenth' to 'length'.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix some typo error
      https://git.kernel.org/mkp/scsi/c/89bbf550eafc

-- 
Martin K. Petersen	Oracle Linux Engineering
