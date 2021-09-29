Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598F2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 366976138F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 03:22:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243834AbhI2DXk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 23:23:40 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31822 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243857AbhI2DXh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Sep 2021 23:23:37 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18T2JN6n007974;
        Wed, 29 Sep 2021 03:21:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=HJbja9wqwPecdRYoV+W5Ze8C+Y0+Ha2seM4f89yMh7E=;
 b=snwTeCRYw2/vJF/mbNpoUi1bjQbOo05xIbwNmqQkhJVE6Xl2v98nO+yMjA1zCqTMJVWw
 murGiRrAMn0/Z3x6hBjgmgjOj9mnyGbIVHXRvALY+N3+ePw/OkOhJf7Q5m9jALIlUnod
 RV5ppPqJ3fgmbVMeOqwWxYCpXoCp78ZjSVbAz2UzHI22+IHHyt54rPLD7iL5GFuBL/t1
 fcnmzWUE6P6qmgln/vOU6rdc4eKHVtrzcBP5s73s/zmqxb94zICb+m/RwNQt8zZ4a5ss
 3mllweNtrGeg2h8CmSCetRM/RzYsvNLbP73kKeZ3aw2cYmK6vn1qrIk7Eca8kiyJdnbl jg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bcdcvrmn1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:21:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18T3G8bv099665;
        Wed, 29 Sep 2021 03:21:52 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3020.oracle.com with ESMTP id 3bc3cdhxf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Sep 2021 03:21:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GOc5WMS6Jl0DuUrEJX9nq/R+c61IXJgiepfRhTzpPjwAqSqEqQvKhlUwnXqUKjYQAYoK1NLQK/6rZp1wWjmo2ev3I/Dv0R4fDvUISk6ixElk1h1gf+FQU57jbup5Deg5TINPL9bztS7ZMbTMHuxYAPucwx1swkIlE02F9LJkcVEu6r9ArllZnQuAMu6TcjJ+5gtil553FFmTpJ+6LraqqmrbKRHpWDmzwQia+j6KjmvcSjpBuyqfPD33aA2Bbkmfyvvnqp1wzXMdaVkwTMNpm/wGpS+LJwB7a5VJqnXAGt/6oXU2fxeddEdLEOE3EI+WjYatAIWxvA003UBegnNwFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HJbja9wqwPecdRYoV+W5Ze8C+Y0+Ha2seM4f89yMh7E=;
 b=LTVPJbMsdVWg/okCJZd7Euck1NK5T5GoKecUr8TumSBrMwV+XANB19w27Y7H2+EudT1rHLYyUapTg+gxlQWRas03QHOq92N6DwVAR8AXnoDK6zuoMtnpcG7DDJqSv5Ft4XEo1oApGtyBygLisAAdivQEnfjUO6anebBXG+rf3su8jsydZspRVuLwFBQZ7jdoTWNM5R8wW1Z2lQ1XkYCemgA3AteFCzjMm5dzl9suXI0QE92xRhZ5rL0/pYsg0dPTVh5Ujuas/aVkQHP7gWKmiufr0ufebFcpf54DKwzLRG0xCri1xqV7AuuCr5H6uNgtRwdqNLBWCxQZ0GWZRWal2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HJbja9wqwPecdRYoV+W5Ze8C+Y0+Ha2seM4f89yMh7E=;
 b=p7HhER+RzP6VDZeTyfSvByqD0IX6gzs2UK7brzMtbD0pO4Hc5y9VfAzjmRytt2qJHC9vezfrY6lCjPq+ETTWRHqPTJ7aXUUhFNaooc78ttb0R7ZHobEmLEvqHLXXBFBbc44Q0YchxflbVt1f2THeC3YSx3LxcBiVr075nz+GU2o=
Authentication-Results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5643.namprd10.prod.outlook.com (2603:10b6:510:fa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 29 Sep
 2021 03:21:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 03:21:50 +0000
To:     Colin King <colin.king@canonical.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: return NULL rather than a plain 0 integer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee98f4n0.fsf@ca-mkp.ca.oracle.com>
References: <20210925224113.183040-1-colin.king@canonical.com>
Date:   Tue, 28 Sep 2021 23:21:48 -0400
In-Reply-To: <20210925224113.183040-1-colin.king@canonical.com> (Colin King's
        message of "Sat, 25 Sep 2021 23:41:13 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0034.namprd04.prod.outlook.com
 (2603:10b6:803:2a::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.46) by SN4PR0401CA0034.namprd04.prod.outlook.com (2603:10b6:803:2a::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Wed, 29 Sep 2021 03:21:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5789645f-a299-4a93-1595-08d982f84702
X-MS-TrafficTypeDiagnostic: PH0PR10MB5643:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5643EDB60E1148F7B5482E408EA99@PH0PR10MB5643.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gb1OBmtOp0F+L6tk7rqd1Z4hnkS/SuukUAI8ZkTnYGe44glS8XRrXPisd0B+x3W4bCE+fxbbsZQWGauiQd7LYaSbj3/agn27bgbN8owm1xDYTr1qNUCmgyn1uMae+FzGH+idcjzFgFspBFB1hoasTBorCdRUkvtVHj/fR/rWcx2U+hD77UudqEJ8j6QNK1c/Uoi8X3xvDAwhWNZo9PT4USQ9d1vgQ5WnGumFNs7wlTAtSusT/kdVxTqAM1ApeHcPwOMR1uvt1GXoiPIXNBusceeH7bX+ySdWH9lHRndPcy5FaIwNETGBJBuqThAmlZlU5a1ozg9Un9tCNsgBMx+9bbsIrwnQ995Yb6sLPluPJFushILD24eJn7/ePIxEPut0mylSycC3rRMgxXRA/8vDv6rNEk0FIU00Wf8fFlsFY7pkxnKXebbaM9cjqnEb2sLDJM9eUuaQvhTSCcAu71No1Y5A1nJBt1Z8xHKSGWzjFgTpD7Ysdi645EupNgjlpZ9sXYou1EsOLcW8sYO9+LYJg5auUUW4ndqNVdvBIdfRFSndrBJGeRMssIWiBZ8S4cCS34yFUFCVaoCdomBvlngRCV1dhf6DcIJU18uOf+3RCLx8G1KnIQXUfCXPjl5tDJCtPFGfTWJxqoN8X33SDFBTPkJ6nEsHmbaHsguuxY6bOSZ1BfsEiG9a9BURQADZFiq8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(508600001)(52116002)(38350700002)(38100700002)(316002)(66556008)(55016002)(26005)(66476007)(36916002)(54906003)(66946007)(7696005)(558084003)(86362001)(8676002)(5660300002)(8936002)(956004)(4326008)(6916009)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZtVn2SJgJBdaeSAuawqSIr5KQdM36hKZMZI7dwb2ynx7dSq3dfnlaZVwUSdU?=
 =?us-ascii?Q?KHFx9SludxqWP/lI8Dzzk8b7dg4mJn/3jqw1K1xON+hj+0Vxgl+AvO1uiU6I?=
 =?us-ascii?Q?OPc3b5oZVs+o27NbZ+3FPFS2jjxmbwk5uw4djQ/k40tR+aKnCO1URqDOwQmy?=
 =?us-ascii?Q?w34TgXFc8faGNGnOMysT0we5vW/pZPV08dtPiPtOmPAF1JPUyn5SdEFlCbca?=
 =?us-ascii?Q?OXDw1rK20vhr80CWmhnyy1ZutWU4kE86cc1lpFvxR3IMsfLM3YNvmo+tgplA?=
 =?us-ascii?Q?T3EUeZQK+kstpzGoM9LbqjvDI1F8rzPVcsdgCmyRmW/NTmh31CSMZpepnARQ?=
 =?us-ascii?Q?raVrzmGV14yeIb+mxifQhhQxe2eYaPhQWK0+Usukka9nZdnQU9FEScf4cStc?=
 =?us-ascii?Q?q0s0Yoy+rwwzjqm6cmgtCc9ye4wl2mQg2e/sMY0nmt9tYOkZg1bW0rDoPKZg?=
 =?us-ascii?Q?2px1M84Yq/U2+JZiXkSiWz4Dj6D4fkLXadEb/Voo3cuo6XMWm1QoqZetLo48?=
 =?us-ascii?Q?inY36sR79Sn7rrcIIcOW6t9yJWdEHS6TuVkt5tK2ut5EVjZEpI9ZX7UvyqPf?=
 =?us-ascii?Q?8b0ZWfKPhM2eN4lDKblvTz0bvQqq2tT10Qj1UiSjyFy1PCUnPICJvgESNvuz?=
 =?us-ascii?Q?9k4S6/SgA8e/8wicN3g1wiNerBxUqEdowxfE2n3upIHwiS0BLhq99fRSBpt9?=
 =?us-ascii?Q?giFd2jjOrLK9igtHJyoq6BmCMYonTKuUopUW2rRAG9C8webkit6dE0B6ICa8?=
 =?us-ascii?Q?pNQCHcHRZpsfkH5G2TG0PU8hkUH/siiNk8n5zvxxNA8SxLou0wOX1Kg7nhLf?=
 =?us-ascii?Q?lzmJP9lNcPoa58BHklKEUmDmwqxRrqi9irRbqUKtyQHHMv0i7Yx8NqqEIt0+?=
 =?us-ascii?Q?FTgE5g1i2xCSGCEz2SYcKRCbRnJ5axxXj9NlcrZqf+B/PABfC++qVINHyF9Q?=
 =?us-ascii?Q?MjlWXBmxFODbAMgaN7UqcTqmjqg27QoTLnI6M2dCtgOlQQ9fcOW7bsZ4aU7m?=
 =?us-ascii?Q?WzXAeFkL3AxZrBdIFSckgxBf4FZTnjd35d2TJXikfUagnXSs9G65bycq6RCw?=
 =?us-ascii?Q?AiLBsls+Al7btjCL51hD0CBWQI0J/ufMKOxrfjhL667KXfmoUJ8PqTcWB3lM?=
 =?us-ascii?Q?3fTtSDPhrCu4uwHkonGQSu573W4UM+p8RUcVJ2ufGx2TGnt7JosWvWN1Y/jJ?=
 =?us-ascii?Q?Vnt+Yh26/yD+Ylz7awyCrT36G1F9Kk9prIoH3kLha4rl6yGJ6O4tZ1oNr5yV?=
 =?us-ascii?Q?UM5oM2cPwBJ6dcv5A30lDzZK+7QGWD6UYo5T44V0/iRnkI7XZuDSRas8Hz81?=
 =?us-ascii?Q?7FQ96xUXejPj54soV79UxoOK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5789645f-a299-4a93-1595-08d982f84702
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 03:21:50.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vfxWVzpfk/pGIL1Eu48CmZmCzaEwd92rCdelZrVQRHKBUQ0ovEo8OplgytlglD5xTpOwy/ws4l/OUpyO5Y6IX4pVMi8psits5XSV+4qFq0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5643
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10121 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=974
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109290018
X-Proofpoint-GUID: ol_F5VbCLW0VtTqtBSa1bfLerV5ZyogF
X-Proofpoint-ORIG-GUID: ol_F5VbCLW0VtTqtBSa1bfLerV5ZyogF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Colin,

> Function lpfc_sli4_perform_vport_cvl returns a pointer to struct
> lpfc_nodelist so returning a plain 0 integer isn't good practice.  Fix
> this by returning a NULL instead.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
