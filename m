Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D5CC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45FA761431
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbhEZEJa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:09:30 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51722 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbhEZEJZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:25 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3x2MC183775;
        Wed, 26 May 2021 04:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Bz3cVCoC5yccV1CeOHbPJad+43FYjV5aCQ8XpDg1JFI=;
 b=UU8SkdBPmKpLxF35YpcWAZ+/+gJkwTQZhq60ZtgnC856he2QIpISbNMnR3+vp2YXpE+q
 7nE0cACffllWznhY1gkSoO6uRftkMJgiKysTWvyYGHcFYHaX1HHf+j6SuW+lWug+O0da
 jRNnUvkP+dHaq4+HGJuu8/QCY+q2h6DescSBDKwHSMVxYvQvLJucm1Zp6nBctxvFjm/g
 c2O2DHSJ9VA5gkuxLTzO1xqdrOgfP0oZUXDMWz8StpwSno3MGTu6NJRkbBcbePGIyW/U
 fKFOI8B809a8Ea1AKno9vuhKhKp1gq7DVSEQqtHWhJ5LCyQHWnMaFMJDRpVwQzdpOQCk WQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38pqfcftes-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q45Jxw142699;
        Wed, 26 May 2021 04:07:46 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 38pq2uvw5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2ckzTFCdnbq+MeNMJeDgvf9fqKso0Lb4fOzcMdqmoIacGyS18Ev2JBmge2s0gbC3wN0hikxxrUw/EKJ/pJ5zgGQZd2eWA6lKSUt9l0vdbQtgUA4flyqIxj2tcdff/B4t6v55fdRUHujmat1s4MfbjP+aV8wtjwH3PVbU1XN8sNvCjVVN8TkuNTqNGaqjs0y1abuTWFvfAeK+oOQXj8NjNrEL9eqpvxaQqlziXwE9GpnpvCWLY2aJaNjHJOLpvmJMcMW7Io6ox3FJ/9LOs+bA3fP5pQt1KhjEJVxCbXvHxHVuB7dPUwIKkidNcQpJ8hPumR7x+R5ueud6JPq8qFGuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz3cVCoC5yccV1CeOHbPJad+43FYjV5aCQ8XpDg1JFI=;
 b=JHlKrTI9q+JWYlE4+cQ9eBjzb4R69d+rUgCLPEqwg48XtBX4NlyvNW4z7pIViLqmKApGTyo/p3fnoS2z255ADRD93alvFWUcLUwJYFgU1rBEchPdzgV9ngQucjPvZOGX7C+PjFT4VbInYT5SMys1AV9pBT7wAO2MdAg+RdGJXH+MCwrciF487K8qDITyvlxmfD5VrELEjaJZKQ6DzWn0bDziIAbz/coHX+82f2gtBO+jLdGSgvUuyueDMpBqEvF0JmUTIQRXQuWQLbHgoY+SwFa/nP/wQf2h4bsiM1Y7hHr8rxpA1YhEAQbaFpwTqCiXhASdbL2KPq03D7ghotfG6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bz3cVCoC5yccV1CeOHbPJad+43FYjV5aCQ8XpDg1JFI=;
 b=W83aKklCwPenodJdeJ0RTQq7eKIhAAur43aY4R1x15wR9oLs2yHBUGgYJzkw54hsOVE9BuQS/OWV2JcRI3ZfBHPxrLtWhliG3gMWtFecqNO8cBKfcA3OxNGPuRHL2/k1Y/1FMi2qQbk8/V5RttvIqYt/PrKXmgFm0xlui+nG3uQ=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        njavali@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove redundant assignment to rval
Date:   Wed, 26 May 2021 00:07:22 -0400
Message-Id: <162200196243.11962.2847628665224786477.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1620643206-127930-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1620643206-127930-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31cac82b-fff9-43b9-b189-08d91ffbd08d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4469261DBC08609AB104DB268E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RaVXEiTfnRJhMSLPW2iCKkywrXZrmvhYJNdfDhp2QOhEjpJCQSdoHnUh5sdDLxi5JWS6xdxT2khHZLJKBCXQWRfHjHOqA2F45PgyyazNuLFyvcreaCheRoLv4Ox9avJ3ZgMwA6C9enRCHd76pdb7g+Pdn8tvoHoQLyQcFj99tmUUWBcrY4p5RYhZt5z/nnnSL3mGNx5FNcZX+RwJnqqDQligAsMjsKYiJeR+FWvI0SI+5eISSqZSs5dCBI8vFwj1xa2f1EOtzCQ9bGkQ+HP6QYv2T4LptN06gRFwcJdmYQcOTcPYuS+o2H23U5+57xVwB+uBS/iNhqKdMGh9T+Cu9/S4g1htZRyVjo5PrrKZCc0wstJzBg/PcBpwqxZORc6CCX3oPn9DUVCT/Kyl9xshPjvw9fWX8TggoXgLmsCQaOMlXppv10it8JULAAL6Eng78LqakdiP9U19LpJiwZ5UM5ZW0oZ+Iw979ei1vwQ2owXPMK4KyENAW3IOOGmuBnKL40B4bfb9f7W/8ESJAgH7zszWSL2zBL0UprR7H2namKUA0K8r9rn++avBUjAGGpSByJawSidC1v4/wAbvetnge5ECv1bOcgS/EqSQc/F3awqCYOaYM+qncNbZ9zOIBo8FhCXftWKR0I9+z6DNIxofMYg1VctgsLLtxXpL44ZvDQHWXMNe7kjZKW5Kc0ossfS2u/CW/T2Hj4IlNmDmhl+rVbIcGVrczy5YjEvbD9Lib+CPS5815LJZ6ZlpxdsV6NxucCXvY4JDNOUfFyhn5xUWXA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(966005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VTY5ZUFBNWlxWkh5WjhFWFU1SFcvUy9TZnp0MSsxeHdISXpjU1FlUG9VS05k?=
 =?utf-8?B?alN5VUxORXdGdjFJaHhtYmljbXRoMjdqN0t5c2RUMDd4bWV6S1hwdS9Fd3pu?=
 =?utf-8?B?MFNiYTN3Zlpydm80Tm4zVHB4VGU4QllpSDY3bnA0WEpybFc1V05aV01OMEkr?=
 =?utf-8?B?cStSUnRPSkhRSGRqK2dsRlRuMFU2dEw5KzZEVlNYZk9IaWZoQWxnNzIyQ01x?=
 =?utf-8?B?VDNBQlhPYmR2MWp6eVEwblhkeVJmbXNvWks3dnZRUTlCNDU0R1VBT0l4YjZs?=
 =?utf-8?B?Uno0dlVJZll3aFkvVnlnM0lOL0MyTjRWNW1NU0VmelhlOGtYRUd2TGZ4UUNm?=
 =?utf-8?B?WW52RDdnUmdZOEhmclExMitXR2hqV0F3N0VScHZwSWRwZTRJRFNaaU5RTzV4?=
 =?utf-8?B?aW03WVR2QjZDYXpOZExGL2NuMHc2a05BbjhSdlhDeVdQSmQ0U0twVU1BMnVo?=
 =?utf-8?B?clEwTnVLaHhyRVN0KzdveHBqNDJDcHIyZTFUbTI3VXg4L3dEQTN3LzRBVGxh?=
 =?utf-8?B?b0wwOHE1SmhwL21La2ZCaU1JN3pSK2RUemdKQTJpK3VPR05zd1ZESDRLbnpZ?=
 =?utf-8?B?cTE3aFJ4bzNuK1ExaEdOVGRGRCs3T21zR21QbU11elRnR1NiaUY4cGJ5R2dN?=
 =?utf-8?B?Ylh6NWltaWltUUVCM04vbmVtdjBrNWMxTXhSTk1WZDA4QVQ1QlMwaUdqeWlj?=
 =?utf-8?B?Sm9JVmx3WWpLWjBzZVJIVkxhS2xTcFUzUXg2RlI4TW9PZ0o4T1ZkV3FZZVQv?=
 =?utf-8?B?NHdKZTJhcVdWZm0zaW4wZ0JNUVdXL2NMOFgwQ1BndDFINXpmZUw3ZENZVHh2?=
 =?utf-8?B?NHV2VXdVNi9KYWpKQkZQTHVwTDBpTU1iMURxS1Q2OTlPTi9SMTh4ZHRvNVgr?=
 =?utf-8?B?MDd6TzBJNDg4bnE2S3RLcEhSZEdjenZDeFJuL25GN2hITlhyZXdsTXB2MkJn?=
 =?utf-8?B?U25yQmdrU2w4WHkrZmdHMHdZUU9wQnpCa1J4bjB5cko2ajVja21iRVI5NWhy?=
 =?utf-8?B?TndhVjFqVitYeVJSblF3c0lZNllRd2FWYnNxSjh0TXc2UWxuQVUxb2RHc1Vh?=
 =?utf-8?B?YTVxeFdCZm5sNWtNbitjR29IYlVwOE52MS9CSjN4djlOUVR3K0dGK2l5M2Qx?=
 =?utf-8?B?bTQ1bVFNVWhOTmZndHRMZm81Nm1UVkszeEJBRHZWK1RZR05nY0hNQ1dzT2cz?=
 =?utf-8?B?UWJ6NWM1NTBXRzFUYnJEb3F4S2YxbTR1VW96endzWlQrVEtkYXlCNzVvc2Nx?=
 =?utf-8?B?RUMwMStreXVod2Y0VVdHS3BOZnFwclVTOFY5cmEwSU0wbzlhNk9SVXNZWkpn?=
 =?utf-8?B?TEJBdlF5aEZLUWJwVmZjcFMrcG1jODJlZ2hvZFZqSDJqdVd3enpReHVRZXMw?=
 =?utf-8?B?RUtmVDJqbHE3RWxtRFZSTGFPQk9tMlBuZ3NIdVpkbSsvY2VmN2FsMlZXdzh0?=
 =?utf-8?B?SHNCcndHSk4zY0RQZFRvSnNjaStLYSsrMStNZnpuUnFyUGZjMnpzcEE3bGNJ?=
 =?utf-8?B?TVJLMERhTWlmeHl3aTJIbVF3R204MktNODZEbUZiOC9EWElBWVEzWFhMcldH?=
 =?utf-8?B?K1o2TVdka2NPTGltVC9lRlZxNHNUbnVTOTMydTRobHFJYUxsM2ZDVE9QVUFW?=
 =?utf-8?B?WXRuZmFPUkhaK1RvRmZkRUUrMURRUGZsMVpRbFJhT2dlZ2tmOVRtVHUyQmt6?=
 =?utf-8?B?bDVXL3g3UXJqT2gwYTNCOFJoaE16UGEwNEFoSmQ0K1B3YzdCUHV6bUh1M3ZW?=
 =?utf-8?Q?PkkurIoaftEGdTx4HZLxcK05AVbIhTcEHTktb92?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cac82b-fff9-43b9-b189-08d91ffbd08d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:44.7846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bsr+k3Dx3g15VFwf6frm+n3SVLROubHpyfY60jU87wkI0fKIX5KDKppNOWX8KB0+IVCCvqPx5qjopwgzgcE9s7/YFCDZbjG5oph6CWZ4XGg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: o-CXk9YLFtCfVmQngN8Pqk2DfWtILguP
X-Proofpoint-GUID: o-CXk9YLFtCfVmQngN8Pqk2DfWtILguP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 May 2021 18:40:06 +0800, Jiapeng Chong wrote:

> Variable rval is set to QLA_SUCCESS, but this value is never read as
> it is overwritten later on, hence it is a redundant assignment and
> can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> drivers/scsi/qla2xxx/qla_init.c:4359:2: warning: Value stored to 'rval'
> is never read [clang-analyzer-deadcode.DeadStores].

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Remove redundant assignment to rval
      https://git.kernel.org/mkp/scsi/c/cb9eb11fd572

-- 
Martin K. Petersen	Oracle Linux Engineering
