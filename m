Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D4A8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jan 2022 05:32:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbiAEFcM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jan 2022 00:32:12 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:7040 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230527AbiAEFcL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jan 2022 00:32:11 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 204Ni7MN032151;
        Wed, 5 Jan 2022 05:32:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=89vKV4/p7w+e32au/MAF7yolseFNbmL4ifBSjP1wPEk=;
 b=K4Bx/S+aAR1LuTI1bdo1tlemgC7wY8COEO3S2nzgMVxevyIi/q2Kfa5DaBpHfrLuTP8v
 yh1i5fM9DZZb8veKA3qOrWdpi9KqlZl3ECQJvniRadbtBJj9bpuVC7KFzJJZBqe/WZgU
 9dqMa7s46c9kcRghNZI6jmxxcAMfZEHUt/xgmOt39SEBNX+LeewDYq48wjC5paNE9gYs
 uir9ZffD3xn5IbqBgcglBbERIdhfAl9uFsO8eV35pwQIkNXByh4r8E1fpO3BfH3qw7y5
 hdtq+c3n+YoLGQVaiub5vPxcVYSxGHPZbMSU8jHDOcrfoBEkK1HeCwtkN5W7eO7UsM8H AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dc3st40t8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:32:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2055VF4i168251;
        Wed, 5 Jan 2022 05:32:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by userp3020.oracle.com with ESMTP id 3dagdpsr33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Jan 2022 05:32:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XKfMdmh6nBawatFUujW7vLVOLCgzxDlmfV3j7wBNgV54UZ5Z6r1/bD2kFow3cACc6X2OtKxCKsgtRnabaRrOKYjbIdQtE1ROk5WvXKBRn5SPiTkvmDdG1kyVfhFKJgea3hRV7OaX9DZyTCMOejCbgOJCMtG4hc1hawoXZqoZrVgi+F6yZWNMOehM0nBQflgm6R7MXHTu67RjQjqoNse5iuzykXzFejiHhgqTAzrMT/SKq0WD+g2VNdtYn2qd07u/SuzLP4aovlaAx+HT+kuAcQwpbO+b6rzaXAvY9GOaIeb9ioc1pCn/VzlNAHetNFbMaF4jrg9f2ONtlrLiWA7j4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=89vKV4/p7w+e32au/MAF7yolseFNbmL4ifBSjP1wPEk=;
 b=k1WgAJoAK5VIosDLatx25XbLcXQ3X5pkqg8vQ/iW0CLE1IdyJepvt2zx8gPhbjHioOBN7JXJYHYOGFax9TiOHGAzmFG+6J2EhNDs67nko3qs0G4IC6r4d8ubbW0p0juAR2691yESNjWkRDy/jKZNgpqvm7GE3VhIzhpE02i0fIzFjPUAhrAjx4TllIDDv8C9x2zESulHEURrIjV7hiIbNRm29J7MVYxvcxd3ovWCJyBoctVBO9NfpOlKVAcQtBad1HLvj3A/nUomRjknc8HlYCgYRDjZqODJ3K0JWz0GApTL6NIvVUqObIwuyaC1ulP376btBcTq/2VfkkQ9PD6UNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=89vKV4/p7w+e32au/MAF7yolseFNbmL4ifBSjP1wPEk=;
 b=zlwyX4xqquWPrjY0r7Vh+FTtNsV2wtU2N0VT93qIkWlfQYWLg+w7dMENLqIwuAOXI9mpS1OxNix2Q0p6yw7UQxF/73On/u+xGOm38lyDG+TCrVn3xPqWOCpxJCdoCadovW0X+ChRMaot1BKXSdm/CDfH++k01WHWuv9fYC2Z50k=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4791.namprd10.prod.outlook.com (2603:10b6:510:3a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 05:32:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::1053:7ae3:932b:f166%5]) with mapi id 15.20.4844.016; Wed, 5 Jan 2022
 05:32:07 +0000
To:     Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [PATCH] mpt3sas: Update Persistent Trigger Pages from SysFs
 interface.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0fezr1z.fsf@ca-mkp.ca.oracle.com>
References: <20211227053055.289537-1-suganath-prabu.subramani@broadcom.com>
Date:   Wed, 05 Jan 2022 00:32:05 -0500
In-Reply-To: <20211227053055.289537-1-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Mon, 27 Dec 2021 11:00:55 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0161.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::16) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87770649-8dfb-4cd5-18fd-08d9d00cb69f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4791:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4791BDC0270E29B990E5FA818E4B9@PH0PR10MB4791.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wr1HezWigr3YZqtjk1ckPO2k1ogf2+rD3EQrMolAwfKz/NQ37PtZY8o7fEQwEueZIT5syywQHthIUn5TBeuWL1GPfQ3W1xGgEx9L8Qg8uc0MP8K9fNXmr8Xou+hl+t/gRDstENGmakZSO6S2MVueZbrDzXtm3Y/OX5ldeokQc/LWES5btAYGd1tUeAFlAldxyF/4DZKpfSjMlMtjkiCkR/jjGaNddf4F0A07v0a9Q1ceF/OV2BAq2qApz/XldvTw3Nrx1tebHyAYrwztLQsl3ixpKLKznRRr7DkH8Jg1RLEWE7kywkcstdGYyNVB1VuwNDfxWtHE9sLVai7qo2QRfvfDxHG8NItowjW6AzRHBuSMSCd52/T+BkIgBb5W92FvBAHod2qvcD1RYLDOBMusHim+C/CITgONdKEOHd/6GblPvN0VIkIwAwUoyaHQLKqyQpjPN7shXlArbNTGRdtf+USottE17k4RBe25vZf599h0nNYSE85Csjb38Gnk0zvNfWJ3OVDRerwCYqedvIhtPTmt6YyEvwvBQQyqdH/hMitF2HSxmZAIINO0vPwsgQNT3MrFfA+AEGLvUCH2VHg1YzOM56IQeXCPoTwcHVpFdr+BTin4gGZhB950WXWM8Gcgc3HP3nUBvHsz/PHZz5b9T8/zC8F5xhPCIvJ4psCN1ZY70lwCPrWvF683qwPTwoek1PlgzNoLhPpk7+N/gafNyL1yGaJp+pqKBWy2wXSaiKQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(26005)(186003)(66556008)(66946007)(38100700002)(38350700002)(83380400001)(15650500001)(316002)(5660300002)(52116002)(86362001)(4326008)(558084003)(2906002)(6486002)(6512007)(6506007)(36916002)(6916009)(8936002)(8676002)(508600001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j97GjwhYlo88zBt84n6KMvdpm2A+nlrzZsvLf+Yz8ub6jVSaqZ1CYdC2ChNF?=
 =?us-ascii?Q?K9nQM2DzwibG0v/NQb4w7Qd9lx/Cvyx3uUCj4SPDQoO3UvfDiv4/Rie7/SCf?=
 =?us-ascii?Q?e29xHskuTXMA7tAhIInFFSSv4kMVxZLvR7Ui0QjBwkqPOKME5vmtTGbUYRBD?=
 =?us-ascii?Q?2hgE/3yogGHneaXreDrMDma5+nKpqg1/nuRw8Uv3g/TQ/YrnisfX2fE4FjCz?=
 =?us-ascii?Q?86zHWbHYCvUxFyWA8XJxXj9yH3Qz43Ji1k7hx0EvKuiOQzoPiy1LKZOJCAK/?=
 =?us-ascii?Q?naNtwdWpa7e74/9ptVfC9AMh4NFpFnIINCfAzYgmeydX7ac896nUDNq1Rmu8?=
 =?us-ascii?Q?fJPrFlnTqVb9/oPeYTEuvWhij5vjW05d9F2ATAZMgMxlZJAOm4UTWjS/bXYK?=
 =?us-ascii?Q?3J9n+tXbIyFr3XzA0mp6ztdNeC0dZpPs5nDGtPegndcsi5dXwu5nM5Ql+Rcc?=
 =?us-ascii?Q?Sr/B3gYzK883srzD8Oqv9b56Bt4J4Uuh1D0HrfG5x95/zPWvGHA5gVm2d1Xe?=
 =?us-ascii?Q?Wz48CFnYOjY8yZm0jEc0thcOWiGTMzXFcK4nZ6xrkMZLNS8xbMgrghs8VzHx?=
 =?us-ascii?Q?aRy6liZ8jjd5Jqcz+2VJiMCmWXEz8CT+Hn2MG/LB5J2/trwkAj/bVX/Z/C2+?=
 =?us-ascii?Q?c6eisjigI65/qX1NHYWBz1IwfnkmPYJIkb2ATwv/6vmSfUPMunNcWWMcAoBZ?=
 =?us-ascii?Q?nyxLGC2cjXNH9leOXm1v3IJrGwax9M6TIou1S1DEOCDUlSoOiJJOB1g7RyWc?=
 =?us-ascii?Q?Q67AcbltTL0SaRYBWdVE3V1oCUfjtfUWsMr1Df9vfHZ8PfYDWCKuDXVNQmbn?=
 =?us-ascii?Q?GrCpThP4aKaTFtUx2M1ycZrRBFYkUXduTyaBRQdtpMWEmAzpyWnDbzj4IQST?=
 =?us-ascii?Q?NyEg2NDofCi4KVcAa8d8CTtqx+uJM9s3gGGFg52yYj54uwyk+skB/cGwRe7c?=
 =?us-ascii?Q?j87d27FHAxtCfjh4Jb1miEwORWsWa9eSU/BNfkraEVQjw94LvNObs3+AMJ8s?=
 =?us-ascii?Q?YuC/wsmwIdbMsDUmBmkVsO0xo8rzovY3iCr2Dgjn1oXvM8oXHCLHsjrb23zm?=
 =?us-ascii?Q?AEnM06VPVceRKQpuWJfFhY2+D5kVVw0isZ1SeaX6XHas8s7Az9oROZeZ3FnV?=
 =?us-ascii?Q?LsLFi4J4EqcD4nnc9ka3oRgyRRhRCOVVypxbEUFd2pDLlpORZLINGCADNL6P?=
 =?us-ascii?Q?xfypnuv9KEh2MGCHwzMqPJtrGRwigAQUpId+FFLmtZLbE8sAMVuyDSZy/nF3?=
 =?us-ascii?Q?78LOcxdtuKVTpDCdWo9jC1NXKY1m+WdsguZNmEs/eY8cS/kABv9cgUHkZwKG?=
 =?us-ascii?Q?po8lupUZ+MWLX+i/o+E5PQIK4wmW7Pi1ekORjfwMPzP/oUAC1nMly+cjtNo5?=
 =?us-ascii?Q?/TgYeN7tJQdogddL4fe6uohrtAvLPpXCoFrqQDzinlm67oAbumgN0NdKLOhL?=
 =?us-ascii?Q?j4XSzElO2BPWaK8NsgH3P6cTnjSklrlcChcpSm9MIBhZKQGMZzYPT3gFh5Qr?=
 =?us-ascii?Q?DI1JTNh6MzFnf4Etahc1G44oHF183Jt01HNxw1O6SyYsaBGknIJahLSi6prQ?=
 =?us-ascii?Q?JeanjiTxuUC1iKfROEcIr/yiegAOPlG05ExYnIPsbC7LzMzTFBFIv9DKMfQs?=
 =?us-ascii?Q?mV1FlcHVvnmAbhfojKCoifU/hnRbJskCtn1u0SIz4OhV2whFar8FToWeYB0L?=
 =?us-ascii?Q?5lBKYQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87770649-8dfb-4cd5-18fd-08d9d00cb69f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 05:32:07.3575
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rq+WPKib6VZL54NVKJZd2cBp3YCE88fI8J6Xm51RuiAkZStD0zBHj5nhpSTghuaDCMYmnzK7V1+VHtWebjW/xKRAMA+6EjPD3N5jXQXKv3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4791
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10217 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2201050036
X-Proofpoint-GUID: Wh1v6gldsyUByHtiXeLbgTPG0BsiqQCJ
X-Proofpoint-ORIG-GUID: Wh1v6gldsyUByHtiXeLbgTPG0BsiqQCJ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Suganath,

> Updates sysfs provided trigger values into the corresponding
> persistent trigger pages. otherwise sysfs updated trigger entries are
> not persistent across system reboot.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
