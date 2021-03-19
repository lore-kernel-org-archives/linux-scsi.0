Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71DAC4332B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C751C60249
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:48:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbhCSDry (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34312 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhCSDrY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:47:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3THJ1028150;
        Fri, 19 Mar 2021 03:47:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2pNx5s9XXeYQqHSwPdEDKZu6gT6r3WkKSyyYtGhO+xY=;
 b=shVPdxAk+bX1d6hRi4x3YIxBpgl/lnl9XrCMBrN24paS7I9FG2qylZLu9Iz9CnMDOyfu
 iztok3oXJ+uhKN5aUS/WHXVPF2lL7ShCT3eAFFc3vM40dKOI6la7MlF2JQ3OostObjMs
 LWiIE1RwyjM2DuEDd39KytrzPY3YIbRKlNei5zMSV+1qEgT//TPKe3lm+a54ZIhkNo3O
 Fr0uPfSoV82O5GhW80va6EBRJX1P+YCOm5EGn7Z3ysjIqlO8E3+KE2FbKe4D8ADwS6bK
 47+ymkNVpXkZbnoNBD+//DRRty4iZeueBRWS8CQEdzxL6ZBWs0QlVhwhA37Jw+25X6gh rg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37a4ekxeqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U9X1175143;
        Fri, 19 Mar 2021 03:47:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by aserp3020.oracle.com with ESMTP id 37cf2v0dur-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:47:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kp8tSJrCx6B//Q7Bqzi10ZQZDrJfI+wD+c2d/vsrn+aChzlyUAifbe7WHH/+/IZs5kXaX+A+GL9iUCiQZvPS7a77gfpryiVbhUdrEn8Lxfu00vuUAOVAgtOgicc6o+EKVw3y1ypzXDm58BJ++GmsuMvx0SpCF5N81NU/kGjisMzo/0PC2Ri7rUPSkb6i5/rD6ZxUoml7kEVoqQ5EOiU3VpC48ouTkiN4wvGKhGYdo2sCieH0fu2SKoUNSkgfMq+dMeYjcsKxpIhBPiWfEBGTAwEjkKPlefURgEj/Dv0+8tguqN+CUrtN/Ca0mhXGuIM/tJgT9meWQiUjnTJnx9ntSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pNx5s9XXeYQqHSwPdEDKZu6gT6r3WkKSyyYtGhO+xY=;
 b=ngQnrtcoE1ETl6X+VqHqr2muYYG6OT4tPi1+Ijj4eHA+/p/rUzhsv7ALQK6x5qcKjwfHxB6IqZrrTW73NpstadSkcbJyzWJx5hfB+Mr/Xc+kAEWvk0KdOWadFcENbvRKuBcazz90+CGSaN5J4r9K6Prn5P2p/FVJC7bnd5O8ofzZDrZyGa3gFz4ep34rij8VntICN2mEWox4CIk32RhpAXTOokflBl7KWjMhwzi5N7w05Awo5+Hr1IPF6zOEpj1mWu+6F3JjQ04Wh8EZkxB//id2xBevsYP0dxkJxHM5KgINktDaRBgSbQaUQHzVSI9IUY2c++DJwy7jYU7j6DNGtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pNx5s9XXeYQqHSwPdEDKZu6gT6r3WkKSyyYtGhO+xY=;
 b=AkJwv+9e877u04bkJAXiNj0JDzq4sMxseZJME46MbeAoF4EKAPFroAZ9UlP89lGuJCpCO4+2xqhfNdB9vhVu74rdDw/uGyEFQt34XrAH5+CJYnRmuGMtsAjmuuGEFTzpQmgwHCTEQCUEVTMHpF0p571/uSepuF1YrGeTOhJVPVw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4470.namprd10.prod.outlook.com (2603:10b6:510:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:47:13 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:47:13 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     aradford@gmail.com, Yang Li <yang.lee@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com
Subject: Re: [PATCH] scsi: 3w-sas: remove unneeded variable 'retval'
Date:   Thu, 18 Mar 2021 23:46:45 -0400
Message-Id: <161612513550.25210.3780556775606635311.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615272064-42109-1-git-send-email-yang.lee@linux.alibaba.com>
References: <1615272064-42109-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:47:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3acbcccb-f0c0-4b5c-6f43-08d8ea89aeb3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470B1877ABFAC6D3893F0BE8E689@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2BnSryVV+sTxxFD/WzyeaGfaO7GXTgtUQ5M0VNHQfnPf6psYEOx8YozDz/lUlGpDxULOsoiLZFOmNYccXeZNBRZsKJvNHWVjriWHBtTFMN18aW01+JTwXIEI+U/kHdU33CeBJYU66ZPWT2WrqrD09UzOaLbeFadY5VPPlRLcVyusK5Y37kZ1gI5vNCI8SQXYcOORYCVlcgHStrKdvog9twd+QcDaiYajgUPeJ5fByi7WKSZHfCHE7LfXx1lZb+KhwCo8brrvehM7oN+s6YtJ3Fz0aMYemYtBY7d1Ew2ksXj2cCRPQVDI9AEkCQzijWP7epgxbEYa9wr2lRBllH89HVXY2t/21kq+/MvPXIUzIHCrg/dggt7QFIzF9dq6AkEmRxg8UPIWaZYkPUOAQro7i3+TJWtcZJhnGzkJBYxOX1XSPp8zM2APow92eMY0oCNBDIdnWZUxCgW8548f8G9nP72b/IMcjoZzSqIAdQ5OkO+gZevFtDnjXVQkWOnhLUTzSB9JhCU3gLNFwRf042s8C9s+KfVEs1O/4v+eMhAF6EEdAuZ6GzUaLkExXa9KBNcK1r9QSYKIjJVBpFW9SRc3Bg0JOYbceF83mIZ7hpFLsRayfowmh+n4ycZbrAmEchHz0cePg+pAekamlluaO+yWuxeg7GJZfN3m7CJoCYaOgjhEdiQZRRqZHec04zrragge7RKbH1A2ITBWqZFt2ywMumplns5vdNH+9gU2hnX8V6g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(346002)(376002)(136003)(38100700001)(2906002)(4326008)(956004)(6486002)(5660300002)(8676002)(16526019)(66556008)(186003)(6916009)(6666004)(316002)(8936002)(103116003)(86362001)(966005)(2616005)(26005)(4744005)(66476007)(66946007)(36756003)(52116002)(7696005)(83380400001)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZmRKOWNHczF4ZDUvam94aFhVTWpWVnFwckhtZG55RDFuWW5DZ3FpU1hid28w?=
 =?utf-8?B?Wjk5enlJZnhlQS9DMVg2N0EyL0oxSkhWb3NWRCtSNkFjcmZVbURBT3lvMUpJ?=
 =?utf-8?B?WDIwR2hkRVQvZCtxUGdVWjZySzM0YWtLUG5rVEFIa0hVckJyNjBPYXlVSWRx?=
 =?utf-8?B?MjB0YWV4amJmUFViK3pVNjkzNkNDaXpVN0dhOFZBc1QxbTBjNXV2dk55U25h?=
 =?utf-8?B?VVhBM3QyZ0M5eTFkeWhjYi9OTFZjaXAxMlEra2tCYU45OWhMTXdzSHM1elFS?=
 =?utf-8?B?NXVCajRNMWlSZXEyOE1lL2RVd0Y1SkVrSzRFMG1UVDVFRnkvdnBFMGVqNzFP?=
 =?utf-8?B?K0xTS21nZGN2UW9Sd1hDNU5Oelo4M2hLSkk1b2tncDdKb2dVYlRRanNlNkdJ?=
 =?utf-8?B?NjVCUm9VbG9mT2N2N24zMVp6Z2tsVHNMbVNKMU5uV0x0eFJSYnA3S3hud2JL?=
 =?utf-8?B?V0NnZkZyWHFvaXVQN2hNTnp3dmNuaDFyOGlkZDFobzVtTlhHa051dXhvVUc5?=
 =?utf-8?B?dzlWeXJXdElyem5laFoyM2dpdVRWVnE1Y3dZbjRRa2t3aDhnd3NtR2dkZFAz?=
 =?utf-8?B?MXpPWWJjWXBnbm1NQnNTNXZPU0V6a2h1M0RxM3ZEdmZ6MTRRVlptK002NEhL?=
 =?utf-8?B?cXRaTUdwcWNKVklNQnpqWHVYM3dnbzBBUUFaaWFvU1Z0Ym9JTTk1NExuSEFz?=
 =?utf-8?B?anBpdmY5RjhZcDVLdzE3MW9jQmFmZzdibFZVZzk4NUZhWUtGaEVNbExSNXdD?=
 =?utf-8?B?bEx6MzZnTTJkYWlQU1gxSi9VeUhtS2p6bEhrK0lFMHQvMWpKaktVNkc3NWdO?=
 =?utf-8?B?dTRLenFYZGluYXlJYTg0eFdZKytYeW1QTFM4bFJxaDYxQzVxRGVJVEswQTBK?=
 =?utf-8?B?NHpDNW1kL2RRWVNKcGVoS2drcjhMeG15L1JzckJWeVFaLy9CTkloaFFvaTZB?=
 =?utf-8?B?MW92SjFTYTM1YnhLWEF2d0I3dWE3dTdsRGc4eGFZS2RMNVR1WU54MWV0aTda?=
 =?utf-8?B?cFhaN0lzVmtjN2RJMC9SbHBzZFhSODRMWmNFanMyU3JoZ3hpNUxobHVkRE4x?=
 =?utf-8?B?RjY3VjRxSDZqZWxTZUpzY01JQkFOVCtKeHVOTmtzZ0JrYmUrcWVuRDVHSUY0?=
 =?utf-8?B?YnU4OCtjdXhETmZnMXl1cEExaTJoM1lNZ0ZWd0lXamE3YkxyRytnMVp2SW51?=
 =?utf-8?B?bk1BMkFrcG9BeDNqOFgxenVCVm1yT1dLS0dJYjNPMEdiV2Y3aC9WVE16KzhM?=
 =?utf-8?B?K2pMbU5GbHhYQi96SEVQR3VMRHcvZlVKVDRHRUpHd0JLNlBwK0tUbjVKRWtC?=
 =?utf-8?B?Tzd0SFA0ZXFkeGFKZzVibkRjd3B1SFcwTWZpU01yUnkzTkFTb0w1NkhmYm4z?=
 =?utf-8?B?VzA3QU1QT0FoTEN2L3dVUkpHL0x6bXcrR1BVcURETjBEdFdzZUxEVHJmUno2?=
 =?utf-8?B?cERYSVNaaDRmeStmQ3M0WjVxZWZSV21jVVdEZThvbEViQWV6NlZUM2diT1R5?=
 =?utf-8?B?eVpJWWJLWCttamcramZ0S0I0WEtobWtqSFVZTVRsemh5RENoRmgrMTNscWho?=
 =?utf-8?B?VlNFNC8rQ2VES0xzMEhQN0R0alIxSWxVRkRpc2tac3hLT3pDZDh2dmFEL0pD?=
 =?utf-8?B?K0p6Z292VUJWdGUxdE5YY2YrOUN6V2lZTm1iTllPTlNkUDEzWm10WVdpQU9l?=
 =?utf-8?B?bklsTUZnVGlPbHJvc294VWhFQ1BSd1M1akpFcXBHM2JQQVJDUTk3UHhFUVJz?=
 =?utf-8?Q?776GMPJjBSrdM76aZ84a3hGQj/4jXPVNZBhFRXt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3acbcccb-f0c0-4b5c-6f43-08d8ea89aeb3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:47:13.6992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkEAUJLhG0TSDHwyYF+nr51Dwj8NFKIR3W1LYnp4SbNf0LDh8ioOvKsHdwaNS0VVMpXmsY2u0+QECav9vtkuvr/xS4eV8ZjZo4BrzyvwA1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Mar 2021 14:41:04 +0800, Yang Li wrote:

> Fix the following coccicheck warning:
> ./drivers/scsi/3w-sas.c:866:5-11: Unneeded variable: "retval". Return
> "1" on line 898

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: 3w-sas: remove unneeded variable 'retval'
      https://git.kernel.org/mkp/scsi/c/2af0bf34ae1f

-- 
Martin K. Petersen	Oracle Linux Engineering
