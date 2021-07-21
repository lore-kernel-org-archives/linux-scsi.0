Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8872C636C9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9791C60725
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbhGUCmX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 22:42:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:24514 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231493AbhGUCmV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 22:42:21 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L3GpW3011748;
        Wed, 21 Jul 2021 03:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=sgTQq6bnPEdtGGSz130UpxIIWb7D/BuKO2t8UlgsyDE=;
 b=UbIxzt0uNLnyetsjYYX2mRbf/PA1V27EChPsj/cAusGUAj/4ZSBhuVIL0y7F2s2UFZGB
 FkS7K24ZH4Bk4ZkJEt728q6kJEmCaaa3WF+fplJQP2bv13jzCTLAyzWbM0TTBJiiAbuR
 oto6QWc+G1R8B4zZprkG1qjJDJSW6+ZegeOmzNV+kYHy83XZ5wa1NCC70V+1xqcBs3zP
 L99uTeBtxwd9JymqNR3yBfidQV6dy2cMj5Wd8ub6EXHANI+062KgPYgLfJ1p65Ao3C7h
 71cSgON21wXOpeYSWF9PLSvRtzUuJ/dlii1gn4EVP3VriMTv/6xSxNYaqeORhpHsnf1l Ww== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=sgTQq6bnPEdtGGSz130UpxIIWb7D/BuKO2t8UlgsyDE=;
 b=HsWXTFHIzr8lwbkSFSXDj9KJwPYmh98QSHpNA1IWxuUOfYB3beOV7b4ml0jw2ZtR4P0T
 Tb4cOFMZ4eb8eZcZ5QQarcfv2simJ1aRPzoWTA9Jswewd+K/InFUJ/neDJdXfTgeWQ86
 vFJfU/+2BourpAou2dJka5ED2tB2TItpD9OPJNR06MSPuahZ92/b7MqaMxvrjoKkZq/V
 K1/mIlSVEaq0H0Ys57gQmvYNWvqDNW5SyqkPJC+WZD9yQzyl8aTDvJmCxKZz568Gi1o7
 mFA6mKrp7vLmWqNfjry9feGd5k29aUkBWMDnkxCjmI4niGvS7aCv4oQQuP1PyLFhn6d+ 4g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39wyq0sdbe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L3GWU5041333;
        Wed, 21 Jul 2021 03:22:54 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 39umb1rdnt-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RAOAdxhQxlb3lENO3gjzhshK9VScRJFjZVTPNwAmri2EkTA5ZhOcDi26qHXFeptTWNYLrjzu3NpXmLyfq33l2yzIpaw43LO592IEpy17K/ptsQ2YQ/zd/f0s604V6TSg/Py9u1QbbpidbY+ckr9Xv/pNOQ4Cg+FSgVfB1BMqqG864OvOh/fzzlaIFNkiO4H/Iy3NgLYneO6yYQi1cEJn3xTh2QyYrTgJcNe4f/wAZ++ouAG4/Vhh/mY9Kp2i1EYgzrdw5wSdQBaiGjQCu+hxpn/83VpTJa11euEUJPkDsZ7cCv5cqdyJki5Mi/4mk6aOB2ifb4q8VtS1Hz0kS3W8pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgTQq6bnPEdtGGSz130UpxIIWb7D/BuKO2t8UlgsyDE=;
 b=TLof8A6l5P8NcullI3Pm6h6Zz1KmNrg9G7Q5mR4JCjyapgmmLLb9Vgot8MEEd2gDb019WVhQvm61UIjv4a7N6hgDy408qbsK2BgzTPKShBsN0VNQ450O5bLtbIjg7UjF+RUSBl4IjrCbhm7TWY8isZQuhDIhXxYEa5nBCJncyM7bSeQWVNYB5plSWTSNCs5/e++tQ0R3oA6WAafxothseaAPfJvxC7kU3kU3rq1u6TLduv4IISeegmR1lCSn7csmawBk3A2Hd+Ff9QwXs+5BvjRzJnyN+KfWS3cEDf19Ez9/jkF50UOIIiHc84lc84Gr0q9/6gmW3SvSKtKrsDlfcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgTQq6bnPEdtGGSz130UpxIIWb7D/BuKO2t8UlgsyDE=;
 b=F17wKKH43OchH5b4QkxRmqiFplBSvj1lrrBQXVqGVADFSWQVj7Y87Dz87aedc2yV5MoVPL6KKUIdLw1g7jO3Xiov5rjg0x9FRFk2H24beytKzKA+Y/SJ7WtVAqg+Ain4q2I8Sx4V7w0I6AfN0Y5bJ8gLUPp2XxvPja19FLqCbLY=
Authentication-Results: hansenpartnership.com; dkim=none (message not signed)
 header.d=none;hansenpartnership.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 03:22:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 03:22:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     james.bottomley@hansenpartnership.com, lduncan@suse.com,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: iscsi: Fix iface sysfs attr detection
Date:   Tue, 20 Jul 2021 23:22:47 -0400
Message-Id: <162683773926.29160.6098468343671863397.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210701002559.89533-1-michael.christie@oracle.com>
References: <20210701002559.89533-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:130::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.13 via Frontend Transport; Wed, 21 Jul 2021 03:22:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6d32bff4-5b06-4734-6b1b-08d94bf6d317
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4680F1814F04183088C234DC8EE39@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jTcsL7vmLEJWDNiCP3Oc2J/7gxC+gllOosEwXWfpVyelc1ontVXJ+uwNDVvSCv9LWsiUEkP+YN4aNK3lUGBGkNTUoezM5RSKgW8CcqYjv3yWSobBdXoOoXTqY3YMJFw8BHR8RoGsm5CJoRmAyspEZxZImiXF76XVzK/Ojl6piKqUUYFEejIohz1Y7drYaQ7v9pvHy6L5wuFyBgCshmjWn73mjSJAlplOgESvJyAMWFB4ZJFDnOY3NFkOWu9wKKxy+2crVXHE5zKdzEszgm0hmFCjpWMpcqTxBoFIiaxDI61BWb2im6leCGImM06n0q7R9zqQNs76b259XnmRL/4SBDRrNAJLwDSysFs9JONS1jxwSCPtQfa0meUFDFh5xh7yZkRVe6R47baN225RyZ1yYSQJvSuqn+RF0xrpxh0b2OECbDs8PBFqcq5LG6oiobZSNjfFIQeQEbvUE1aCnjEYS9a9IjQp7X2Poxf87KBUXFa0JdWCO1x0HUEqW76E2s71ZxQ4zj3eky0EzWeIDuQTEbfMAlWSCg1JRmqy/xvjgqKkjmdDmz1w/Y+azK85ZLM+w9Go7bT11Tn6mjds1RibC+cG9mx7bW9+5jPyqP2C3CbiGHKBBxP+An9RNmJC1rOKuaRNOlezh3+uN46lFu5CwEsQjm4AU/3w2ahn+NZY/4QQzvUVbp6QUDQgq1JRP0aes2VEaD8N7uHmW0/Uxb12idpHkG8LQy7BhK54LDPnrBWnM812Mutf27xIIn1jHc38ge5fnHRsvTjTAwWsfSPhtg47zq8wpoVl41uB9L23EQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(66556008)(2616005)(66946007)(956004)(7696005)(38100700002)(103116003)(966005)(478600001)(66476007)(4326008)(6666004)(5660300002)(52116002)(86362001)(8936002)(316002)(186003)(26005)(2906002)(4744005)(8676002)(107886003)(36756003)(83380400001)(38350700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmxDWUw1dmhadFRaYi9WL2RzSThKdGd2eFhXTmpJMHhuVFhQb3dzQU5kWGxM?=
 =?utf-8?B?RmpUS1I5TldOK0IzZUlKRHlRdVJJWVYvNUFCRCtuZ1JXYVdYSVhSZ2ZJRjVz?=
 =?utf-8?B?WDBpcXRHYm9hRDI3MFF6MXI0ZitmNHhNWDlmdllteU1mZ3VWSGVwRCt0ZjhE?=
 =?utf-8?B?ZGp1c0pSVUV2QU1QWG5OWU1PZE5sQ1VxUThhZXBNY2YxODlDWmV1ZUxCT2tz?=
 =?utf-8?B?QVdSR3lDakluMXpaQjYxTmxQdloraThoeTBYR3Z3STlXVU00R1lOTFZMem16?=
 =?utf-8?B?SUhyUlE5eFVrTUlCa3Q0OVBqU09zWXBneFF0Q2EwaVJsK2lxWkpibG03UENi?=
 =?utf-8?B?OUxWbVQ3VHRDVWVFVENuYk91dDllSHVadXQ4MmRYVlB2L0JnUy9HYlV1ZDlD?=
 =?utf-8?B?MmEvNkxUOUtPaUM4MGVqcHM4MzJsSnhsNjZ0Z1g5MlhSeEo2VVJhRUc1YnJG?=
 =?utf-8?B?enJFTjd6UHNta2N6emVXbm5wRk83Z0ZvdTUrNFhQWENTUnVvRlU4MnZ2QkRL?=
 =?utf-8?B?cWtZb0lrYWtQRXhuVG1uRFhQT0tCWHNkNGdxVVUyYk1YUkhjOXhrbmtyZHFy?=
 =?utf-8?B?OGx2SFJ3QkMrZlloQmV6SHRrNmVqMUdmbDJ3NUpwaUNFRUlNQ0ZHVU5sb1B5?=
 =?utf-8?B?WUtWeXRHU0NVamcwME5zdWxzZ1ZjajN0Wk44dEVpdFV2Mm1wZ1VvNyt5V2ZR?=
 =?utf-8?B?UlFnbXEyYldpMjhZa2g1dUdMMC9zZXphTkwrc01RU053MDFmdzZhR1NXTGdN?=
 =?utf-8?B?bkJVRVdzZ1lmVmdyUm0zTlVhTkpOVWw5YnBoWUVyNUMzdWNtZkN6M2JReGRy?=
 =?utf-8?B?ZWR0ODU4cU9uQ2ZIa21jd082cUZhc3J3bVp2QytoZTNxUHNEWU5zaUo2cVh3?=
 =?utf-8?B?ZzZHWGlqdUZjcjZsMjJIc0srakVkU1ZOalZlVjRSalArT1hSaWhsanJSakRU?=
 =?utf-8?B?YWQzMEtTTmdra3VaTWtJN1BXRGhCdzIyV0FTbUJvZENmWjh3NWZFK0lCMWFt?=
 =?utf-8?B?SE5lMkdheW9rWjNVQTZQYzFOc3FObmVlbjR6ckkwTmdiajVXZFRtbzBBYndO?=
 =?utf-8?B?Y2xnV0ZKQk84cUl1R3VwSHY3NjlXVHRua29GM1JnQUxpT3NrZ2dFSVJMSy8r?=
 =?utf-8?B?MEZ2ajZyRmw5a1BLNkdDV3pLekFQdmFGRlZFSitPSGhvb1A2VUVHVmxrTG5q?=
 =?utf-8?B?dnBkcmJyWFRKZS9XbXkxbWpXdU5qbmZ6M2FwZFZrb0hoZnk4WUJnb0JBOWk1?=
 =?utf-8?B?bjIwMFhwa2xVOVJMMDRqWmVJZDVNT1J5ZktTMDNUTHlkRjlVRmxzOFptbjFG?=
 =?utf-8?B?RzEzTWNtWi9BZElUSDJ4eEhGdlpiYjUvNzYvRkc0REhvUnJBYnhvaHZjclB1?=
 =?utf-8?B?QytiTklmZkw0SXZpZ3Z0K1pncC95M1pmSEFXNjhpclp1U0lXR1F4QisvZmhO?=
 =?utf-8?B?UFpkYTBpZTJQM1IwZS9jOHF6VVZnV0tPV3dJSnR2T2hDV0lsVUdKQjdIZEY3?=
 =?utf-8?B?QmhCUEowSXIyVHQrbjJLNk5qN3RRYnlTNG1UL1pZci95aGdDcjZwMVhDeU9p?=
 =?utf-8?B?MC9hc2RNYTNEcHRWWVJ5aHJ3cmhIWjB4V3haS0hnLzRvMjNBeFdyWkF3dGxu?=
 =?utf-8?B?UzFZVTRyVFdoMVlFU2VZRmJHSy9Cc04zbWVzWkVsbExsT1hOWWU1NmMrd0xV?=
 =?utf-8?B?S2ZEUEpnQlNsa3BzOGV5c0pJUjdoaEVoU1pmSExySEVGc0tzRGVXMEU4bTg0?=
 =?utf-8?Q?9kTdtSo5htKK0yTeoMhzQ/3R7AlXI4Il2g3/XyD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d32bff4-5b06-4734-6b1b-08d94bf6d317
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 03:22:52.6943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hj0376XlAFtEqpk6gJ8CmYmUmE8XDf1TFV8x3iRIV92KNEwty6ECv4tsGU2wo5WucDnvo3zpnbnp3rL2i9dOXNndSPDTVlYJSaUFxhDBng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210017
X-Proofpoint-GUID: UPYei4EuRzReOC2BxxRjqCpfgQVzwWhJ
X-Proofpoint-ORIG-GUID: UPYei4EuRzReOC2BxxRjqCpfgQVzwWhJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 30 Jun 2021 19:25:59 -0500, Mike Christie wrote:

> A ISCSI_IFACE_PARAM can have the same value as a ISCSI_NET_PARAM so when
> iscsi_iface_attr_is_visible tries to figure out the type by just checking
> the value, we can collide and return the wrong type. When we call into the
> driver we might not match and return that we don't want attr visible in
> sysfs. The patch fixes this by setting the type when we figure out what
> the param is.

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: iscsi: Fix iface sysfs attr detection
      https://git.kernel.org/mkp/scsi/c/e746f3451ec7

-- 
Martin K. Petersen	Oracle Linux Engineering
