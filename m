Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A7CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Dec 2021 03:31:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234205AbhLGDe4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Dec 2021 22:34:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51214 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232168AbhLGDe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Dec 2021 22:34:56 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B6M5EiN012504;
        Tue, 7 Dec 2021 03:31:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=QsyxViToEERe5cjFd52pAeXEATIpiy+gwYJWe2dFFTs=;
 b=YJRoArX3xpSmhGvZT2FBHrJ/jVb8EJ2hP4T56m6eWn6oXy5faCbVxW+vz+fUb41r71bA
 eSDSX9xEEpZ4vUrgxJmey+n6C0z+zOrzbLqucCh8sdjdeI//iyc7LHzQeelW5ll0fESy
 PpQoEX2901S/LhO4OH+6RR+k/4dwlEQfnLYKrO6fLwn01gw1yaroDGkPz+9ytppRAVU9
 jMKnv9yAkMgbmUl0WFUNqhKLcr8lL/gJhSA3C7A2Q3Qdz1jumfu8QmhAvQs853q7U7H7
 A5XAxPPoogQDz3W4ELc+5U4Qi4KflVIojh06il9RSqPJifs0Jb+EHqHs6GjSkhUkukmb Ww== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3csc72c4t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:31:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B73Uek2070517;
        Tue, 7 Dec 2021 03:31:14 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by userp3020.oracle.com with ESMTP id 3cr1sn7t2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Dec 2021 03:31:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJVaRRS1m8JpXvtgvWLrEkkH2DBVWn66SfmYQ7bw7bBnHhhNPSd1V0CWh6g4h59jM16n8EQqymPxUyz0h9ZSqoDdOGTROZouRTWPgovX/Og51XreJvZBf3+31UyoxWjaxLRSaqUddBTBMWYtuRWMAdCxgb9KoYN2a4qslzu5J50aoGAMYuetaOa/xStD/0khVNEAvUmV5IKmpOcJFqJ3swaoEzY/estyrjHI0rxIpD5UhKCIf6KACnaE4tk69CPvZBcoVPymdhdiNMSGjualX0Dq9jxAlNINKWc4U/fSIoiVsVwYYXC2AxRrRpDKqHQkSFd0bHEqYw9ouzO4gq0CVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QsyxViToEERe5cjFd52pAeXEATIpiy+gwYJWe2dFFTs=;
 b=UQfCJWeDC0NKugpyWAEOnDrEsH7TdK6Li8pUNddaYFkT8rwzMmluoB8ot88jz5N3gXn2Y7/JOpHjyxDZNJ4Xskg2YDKhPTzJrpfWIsdPxe3ZxFjo+SSQWjv1toXNowmN/gLz52LaRXTZNbQutyELl9yzTzk1NXvj96vaJTPWq/LjB+/iP2449YWli+8nkVn/Gju2RDBzd4KR/vBnFetq+2SlHA5p/yjbN7MsAd64SJ0Lv5lmiP5f67oy4u/5/qdWzuYIhUxALfFtOQc+LxYWAr646ZFwCfhOujZvvwxW+lYsCc/NvHOPIMGzJ6bi9jd8IYO5zOocVNYlwx2m/nEQtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QsyxViToEERe5cjFd52pAeXEATIpiy+gwYJWe2dFFTs=;
 b=yGg+2+jhwDbRND9Fbqkd+hi4tgq23mYkjDwqacUZ6MdmIvXLAdFZnBiP2vxl7TAOJDeCOuhRskDMBKgvWWBKpz881VOZ1HI0pUySR8G2Mny+lxS5HrXocDeVt3L7Fr4LakDcmk+xM2xDA0VkXzzeDyuVmhLwXsOan3WK/yhipYk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4550.namprd10.prod.outlook.com (2603:10b6:510:34::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 03:31:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 03:31:11 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 00/17] UFS patches for kernel v5.17
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmq9t7ke.fsf@ca-mkp.ca.oracle.com>
References: <20211203231950.193369-1-bvanassche@acm.org>
Date:   Mon, 06 Dec 2021 22:31:09 -0500
In-Reply-To: <20211203231950.193369-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Fri, 3 Dec 2021 15:19:33 -0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0176.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::31) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.2) by SA0PR11CA0176.namprd11.prod.outlook.com (2603:10b6:806:1bb::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 03:31:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e87fea1-97ac-4cf6-83c3-08d9b93203fe
X-MS-TrafficTypeDiagnostic: PH0PR10MB4550:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB455005EB3704930DB4EDCA548E6E9@PH0PR10MB4550.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dw2aX5b1CzG8WKtvmjAvka1LteU+GsRNNxJ9LgSCci/nvbA5QbWjuuY2veQmqhF4WDLugL0/6q3isS1xV9Uuf3tA8ofF+UUG9qTiUWGFxuZWogv8OUwF0GgaAxLLBCqvhNY76uanhzA8DdstGZXAdGqTzKBC3p+y7CyHym5gSOn4UTTarGQuExFeePNZ23n2/eHZJ+r4GUn+VAPvTrzVelz7pqhRjLdCGyF/Zz5TqI2CCxXYa84pu+F8E12/oYP7dge1lJiA0eA4Nms7sWKVzYMhTZwo0et/KIHJ+S3T74zSsdyGeNjzLwD2Ys/1pLAGz1ECD1dsEH/yk4gOY0pZfayCymlVQJcajmGb6rVU0YCD7pkTbYwBZPp/wInj00OVRbLe7UMsxuGD9yYqbEVmGy1pKrCPYctzYznSgCO4rYLWEL9sXzD+cmT5+Hr4r6SDGkFRtX0l6n1WA7KyQoFwH2/1ZlB2QLSCL23Um7xrvuPyuIcRR7Yn4E+S3YOtTsjqbLD+8pb6P83mh+CLfmdgpunNBfjwRti7vSX2quN2CTwCsJ045i2sSGEK9L2HTCu0NoYzReIrXuejQnu18vjIkcMmcgFsORPAcBljopPUilrCH9Mjc7boRQjDEXUzylI2UAsHZbS+wtelqh37Vvx4/s0Ml7sWisrVY/6X3GwtZOoQ+vtVCEtiHH84mxGjnp9FVkQk0R5zXVMcXzDbX6YyOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(7696005)(36916002)(8936002)(6916009)(52116002)(8676002)(55016003)(26005)(2906002)(54906003)(4326008)(186003)(508600001)(558084003)(38350700002)(38100700002)(83380400001)(66946007)(66556008)(5660300002)(66476007)(956004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XLcN8j2HBa56Vt8a+QYN0d7bF7UqrM3xbCw4383UfkGd0br4MoIQOVG9Q8KH?=
 =?us-ascii?Q?EPK1v0ms1Y9o1E0Bk0HwjNRzr3xyJCwk4/IiaUiAUIysU6yaNy3y4/38VR0c?=
 =?us-ascii?Q?3CVE653N8VUcHyTQhxIQ12pDH4YrWBbOdYfSQZ+Tgie+hHESDKh4nCB0Kd/K?=
 =?us-ascii?Q?ct/QvQwasxTo9AP4LwY5u5+UqQXSFi+yMs01MEdwzXRh8Wi9Y7vg9YgUy/Fa?=
 =?us-ascii?Q?DYvTLda1lXumX4FvAZhy7Z2NUx1nGmxvnKEv6RrUBeU37vkWPbwdQ9MKHN7Z?=
 =?us-ascii?Q?b9nTetZYDPp6aAJrh05K0dZdCbD4OwW6r5O7hLAm4cT071u0PpBY0DzJkPNB?=
 =?us-ascii?Q?ve8si+mcdIh/v6y/Doupa5qD6DQQ6z5Vanzp85qAygcxgYBY5uRMXc8Q3+Ek?=
 =?us-ascii?Q?B1ttMfXFWK0Tg2KiQ0y54EVEEXz6wIzNXJ2dRfYBh8PO7JLBTKQK4tiw3ZFQ?=
 =?us-ascii?Q?7DPoTiFAu4/85L+rFSTSFsyrIQurByVsc1IAh6OcSpJCsHHQLE9P9fGRiqO6?=
 =?us-ascii?Q?tLqdjP91v8Tp/usdvkGRfr6tGwtPD2FuAs/yagej/i4OCt6wd8o/AkZ6as9H?=
 =?us-ascii?Q?aFpAUcb1sl6Ej6OXFdu4+xQkyW/tkjbxI0fueZlxiMCalxt8QKlZEhcDq7u6?=
 =?us-ascii?Q?naw8ezkmQ3am2L5IEPRwkGDn1UR0pghdKVT9FPr3xVLEfXd5VZROaotyHWyE?=
 =?us-ascii?Q?KEw7mBeIsep0Svk3LK3adGUdyBg1n9fqghjievCNOn3aoMP4HFfBC595kAEA?=
 =?us-ascii?Q?Qb4uGm3fhEvBM+JWLa+Zd4BFWIYWoi1jqo+q8QnEWfaajZ+NzsG9Bx+wxaxJ?=
 =?us-ascii?Q?fuQ0MLTcP3UPEvrXJm09Mn+dyKxjUndNPl/sM0wL2JYf9972vVaxW6YCh62v?=
 =?us-ascii?Q?9yLoTji5VPobKrwdaHGQPGkU9uGDE4Q1gFrHbsusxjM/vss8i8lJWJGyX4q8?=
 =?us-ascii?Q?rg1g3Jj65TfXQGHf1c/USCBYO6/ewNQDbTLpf/Sl5NFxkkSdMoSVE3X+dLMB?=
 =?us-ascii?Q?w4PjJKJe8tOQmTmzZyLAUXjddm4pStyeHAxTAnRtRkqtGfsZrhAhgoAaYBiM?=
 =?us-ascii?Q?0McCitCGVJXFNwEKnMJYEyXE1A729KDhWXzFlsviA5nFSrMiZBnEsmIWPm7V?=
 =?us-ascii?Q?DybBXCH14hdv4AljxH8RWSRuIoKbB7TD5Ndwft9LIyCqrwNDrFg1YFOAgYaJ?=
 =?us-ascii?Q?mM14RydEeuSXo4C9kZmVaTz6ZHJv9paSik0s9sAhi013ED1kzFKUFdfIEAed?=
 =?us-ascii?Q?PLVMY/3zuoHzQ32RoeOkOJSpVZL7WK4F+nJj83J8Xd+4gqiE0iiu8YZUvXQw?=
 =?us-ascii?Q?1HoFDhEmsSiU+hfvfJ+USucy0QKoKISY7LcEdUZ0ERECKaLBv/sj68gSt8HC?=
 =?us-ascii?Q?TrNrRTGYp2qSNDmvgStJn8GelndQlPIXPpbndCiTAnrPleUXyjcGzJ08yvwI?=
 =?us-ascii?Q?qzR2vY6FAwOYuCoRhEJtPNzhIkg5q3nYGUCYF9Zg0tdUq6y5aWhmX9GwsMQP?=
 =?us-ascii?Q?zSEpiXmfxvEq/BL5ZTKQyOwudu+hfrCibOAqcHbRusdCXTwHZ4M2miHDNThd?=
 =?us-ascii?Q?3nlrfVhN0rGqq96Xb8ocbmvrpj6JeaR1vV/hV2PRAN4F7o2EGOlT5H/Psj2N?=
 =?us-ascii?Q?HUztIBLEOyJ1S1qQcF0DyvizsLm4Gog9jw546k6M18OwLPS/8DG/HLovf3YT?=
 =?us-ascii?Q?8DuTvg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e87fea1-97ac-4cf6-83c3-08d9b93203fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 03:31:11.7570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p00uVKNCvt2ovjMNAznPsMEMfd8L6X2L5xpJ6uQFl3aZurnHyjiZKyXVSGSOr9pFKSzhh5PDtazc6p9vxxVshoSbZ78hhvmfj8wiGK4QskQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4550
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10190 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=791 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070020
X-Proofpoint-ORIG-GUID: f-PBDRxjuiD97gtG2LNT9SX2zLG3R4Ig
X-Proofpoint-GUID: f-PBDRxjuiD97gtG2LNT9SX2zLG3R4Ig
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> This patch series includes the following changes:
> - Fix a deadlock in the UFS error handler.
> - Add polling support in the UFS driver.
> - Several smaller fixes for the UFS driver.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
