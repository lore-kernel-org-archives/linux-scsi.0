Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04D23C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5F2464EB4
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 03:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBIDD7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 22:03:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:55706 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbhBIDDU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 22:03:20 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191pfBZ055169;
        Tue, 9 Feb 2021 03:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=fFj8/ixo2AfyDxoBOToj+VxgdIhxqN3rlFofk+eE/IE=;
 b=zzmTklhOP26lst7mTzAj/WS8IEmWRxtMpflR9jk1SM3ZQyjqXyX2jzaE3LZ0Js5fabZp
 +gQEtLeEmT1KXmpk0kBLJdZ/qQBVengUGyV4GQtrNdq6ZNLeBtxa11EUNiYl9nR5lLvf
 GiuZ+TlF8ypDQREfEFWTq9cW1ZZ+rcLg3GKXBMs9xtzmsDlbf/w9j4NySa+XoRG7SnAE
 SjOrcQcPlYBOZzTTEgG1LiilGRuF1izLD4FaDgWYK1f/W/+cvR7NRPi/0a47bCWgwrG5
 caASkSEIuWMxXtAjNmDA2C++GgMWHAFViaxrWgN0pZxtKPXKZ08bDnYbFVhU0lfSNyRK 4g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36hk2ke2md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:02:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191KpYd089753;
        Tue, 9 Feb 2021 03:02:33 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by userp3020.oracle.com with ESMTP id 36j4vqq0b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 03:02:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LRgW8xzo9lp8vXVk56pb6ZiU7BL8SGNt9ZK33aSZvIxIZk+YQGNt+IcDZKmLkrlM1VNy2mCLBC5vNdszrL/4aRDfkVcalIC9uVPs31tQ76lyMQubzxQDjCnazRTD6z65Zk4EHj23uL2uHV4EzPgEAyCf9ZYQrHLU/hto6bI7uJCvE85I0drcPAQQHHuyvd6ephPhJjnRlC5Nv7HpBJ7UYGs68RB+9ReanCpc4/cJxTIizxmO379XT/PH3ep1wbcQbHF23Zr7uA1uRWnkN+TdZpw8SKN3MaoVQpqwuvN+cJ2Uv9T3zDyVNwDxHSU4m8uk7+/ljYrFFGqLVk1m3q21Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFj8/ixo2AfyDxoBOToj+VxgdIhxqN3rlFofk+eE/IE=;
 b=EfYfVDOszUPmGWwInL8Sa8zGVCipaPbNPt7SR3QEfmyus6mVDXnqc3iWDq6So2gxbh0g9dBe1nz5GnaHyCRsK/e5wrr94UjDCzXqBl4twmqSiur2RZQgQ5/W69WO+qlQeuQr1hGxVwOMsctdnif9Yc+/mHWvMXQksssMIOas22ZgMU74/tmf2MakLgiX2jD+3EttS74JH1nCEEySFNiWgP0ZBP+beUHYRF83IyxQ5nCXnKD/nGmDLCrYzSyGaXxbYSVF8gYbGHj0wYxfFYpBgiFgJ0lhLTI1c/zHGwo+NDyzPUz/JrZS6ecE4Jz0tGNyn1MXsMP1LxmVr5uARW/stA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fFj8/ixo2AfyDxoBOToj+VxgdIhxqN3rlFofk+eE/IE=;
 b=wGY2GhsijDcwzD+lO39p1zqatKnGo3COnqrtpS2HcDR0f7dWGfTsasXpPuLBGYXqL2HL7hTtBI4ioeAaZvT9n5ckKl83Rva25tRPZ4HHgl0Z6ZIsgdUpt6Mj4oJFQuWoZZ1cmplnPBHnkExyaFakY14IplCYNPKXybFOQkeNmdY=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4695.namprd10.prod.outlook.com (2603:10b6:510:3f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Tue, 9 Feb
 2021 03:02:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 03:02:32 +0000
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH 0/2] Additional Diagnostic Buffer Query IOCTL
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ft26rlj8.fsf@ca-mkp.ca.oracle.com>
References: <20210204033724.1345-1-suganath-prabu.subramani@broadcom.com>
Date:   Mon, 08 Feb 2021 22:02:29 -0500
In-Reply-To: <20210204033724.1345-1-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Thu, 4 Feb 2021 09:07:22 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY5PR20CA0033.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::46) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY5PR20CA0033.namprd20.prod.outlook.com (2603:10b6:a03:1f4::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Tue, 9 Feb 2021 03:02:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0b5f93a-75d5-4ec4-931d-08d8cca72486
X-MS-TrafficTypeDiagnostic: PH0PR10MB4695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46950AE51E5AC013F1EB58228E8E9@PH0PR10MB4695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MjvFaNqrFMJayo5EmKoOomSdtgN2BkGTlfxdPDkfRPDc9TwzgZPS3USrERsEdZ/2PWQ53pvj9nWcC7jQa/SByY+uQbKqyUvCe/Kc8RynPaOZ4Ud1zp6UU1dvSgzxCRC8tQPBcVH4qh4TKq8F5HiBrair1769ggxq3suXXdCsNLGWvU8BJPs2EoUvL7EYM7VJySIYWBD1PF+z89sH3BXCd2IZaptVtSqHRjRg7vwRacZZyZWn8/xQ47SetwxbJSwNHu0REi9UXt+29GMkAnD5MLyTvD1HPmpYhmhguVFWQUCI+qQgjYW1L2uaKQ8gOxI+L5MG+l60BUSy2FxlQWtyXh5g4tNbfFAabmRBrmJRoLffsRsWdetob+i/kFcyR5gQQJWuwSKo8SNDiGQT9hGUR34847LY0MRtPb/cYtVs6jtE1cTGygfqc8pRdxxOyxZULILu7nGp97nRGHnpbQTOr2+j5KIjulpOdbori5P31gS7DkpSeSoudeZtGiA+SscibKO1C+1uNdpi2KHFG0JtsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(366004)(396003)(136003)(39860400002)(8936002)(52116002)(6916009)(8676002)(66556008)(478600001)(558084003)(66476007)(16526019)(55016002)(316002)(36916002)(26005)(5660300002)(2906002)(4326008)(186003)(66946007)(86362001)(956004)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ABP5q4BUWUnm4SADyRjtiqdMY8XQga/PKn1Yk+SHsf7b4tNSyuth4KKOW0fJ?=
 =?us-ascii?Q?UMnIVMiEUWUiB3ZGEkKmMN4Vnae/dlytr/94tpWmQZmEzEZXpzAyzXF52Jnv?=
 =?us-ascii?Q?dPf6jH2Dz51EurRNxVkmfLpMutl4dolszIgMfR5WJnAXarwvXN23S2u8o3A1?=
 =?us-ascii?Q?ZK20u5rHpvOVsde391jmEu0/k+0CkfZr6XAOhPVyxuFivfJcb0ojVe5B2qJk?=
 =?us-ascii?Q?TAqlVR8Z6eUtLr2X3I01ZLOz356fn4B/SrGmfDYTWjCXalNYbhnf9rqjychm?=
 =?us-ascii?Q?e1+hslGSPxuuC1QDTHcKxOrbnEXdqodCneXpp6ktbDpOKvpWfxhink2h5VIw?=
 =?us-ascii?Q?qbLTM5wmU2LnHb5LNXfnSiDaceZSOcL2zFwKZLIKr1LxijLV7VCi7UlAgzi0?=
 =?us-ascii?Q?vYSwsIvMdEDF9UdEHaUKNEd8WLWw4+HcPJLDSZebO/veBmMIRgG/zK1j5XE6?=
 =?us-ascii?Q?Un1mbrRxY/x2C3S6IULCzSqTBigD775HFv6Xfqj30D8CorSLcWUj9ZOSgsoa?=
 =?us-ascii?Q?bwJXuIIzQnn+iMG46T+PWmotogMmJj/NeDfHU2UTf9JPmS8R7CKhv0eqKUwh?=
 =?us-ascii?Q?/2bTXGlYc+eB76TB+Th9KSMZVQHKxlLdb8N+URVCNODvfPyozzz3ZlVurkpc?=
 =?us-ascii?Q?hF1f6UL+fdL6tafbHl6hROR64PDSdKdbKI0QQpIVAbQ9t5qxEuU5X/A37DhR?=
 =?us-ascii?Q?Z/EsTupP53o6NQvN1pIX9Rde3vSJRzPDtkQ4j+BLz1U8fFSvLpfX9agEGrJQ?=
 =?us-ascii?Q?/slyiMfNZX5s7kl4UX43kVcW0BRINh5R2wEcDCXqVD5gP27/GNxSz0LieadI?=
 =?us-ascii?Q?PW3QVRpscw9Q6nhrMPKo7q8tWDDsP4IHQlBJlLCNy0xIrq6ysZ1WZVsAMA9H?=
 =?us-ascii?Q?OHhgM0bctv3K3Vvmhga7t7DZz2TBRERpLo0OZ953r/7ClzUAZBqc1aL6WLDY?=
 =?us-ascii?Q?IjGgFN0/MQ8uKX9ZDPvdcswqTV7i0lrENwwxnc2+qzZ8yycgcHBMgJs3stII?=
 =?us-ascii?Q?T7byGiY8iC/I8O/RvaK+4npRyLdoxEXxWR7L7lYJz8IUTXnBzYRDVk8kzi8j?=
 =?us-ascii?Q?SKKJ2lEktjHKUzbgLmM7H5Y/NkhhqUlPt1BXMdlv4iDoWBXCT6KdJuZL6qIH?=
 =?us-ascii?Q?aHnw+4vS/H80ZGuj/naG9Zr+bRbofc7L+wjbdpeaOoX9SUzkKMvJwETd38fr?=
 =?us-ascii?Q?1EkmyJ+5Gmr+qPpt7d69pc0fJIsDDCgqkpOYmvJtLhs0jqcRFptV6tGD9A90?=
 =?us-ascii?Q?F02updBsvCPNDbnQvQLWphY5aJloM9VAN5jCwS1BiyCTO7CsU2klfyJkLzr6?=
 =?us-ascii?Q?EoxWbAf8EkL4hEyANsjKCq3b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b5f93a-75d5-4ec4-931d-08d8cca72486
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 03:02:32.1321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCorSdOD3Kk2NjNG7xQUh/CWpJ029oq8aRCnf9h2tqwGkNNF/5fwlrC6iKRh+1mbfwBeCVLgxkApypTtLzVgHKJnf5SbUEZB4EKpKtEfu/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4695
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 lowpriorityscore=0
 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> * When a host trace buffer is released, applications never know for
> what reason the buffer is released.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
