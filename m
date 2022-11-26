Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB85C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 00:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKZAhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 19:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiKZAhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 19:37:08 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3DE528A0
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 16:37:05 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2APMiQws001270;
        Sat, 26 Nov 2022 00:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=amQ5iCbtCAYl3FHnFyUtw75F28ekJ1U2YbUtO4knTPI=;
 b=eiLBQciGGuUjUtlNMqCQdB3YcVyGRcdGiNwS4bH6EO/SfBpIa/FN/H4Slfxh2NqPGkg7
 RTpBIh47zqv8VzKriKHcrDcZMELjZy07YIT3RsaSdmOcEzGjqYEE++eExcehvsWPTLxJ
 rBvYZ5ZMU8FsqETx693CjRp2wJvs96nl1T/N/Cp+88wMlKUhaH4xj1yfsoBPgjKUW1ue
 +RCpQkeQ5z9g4a6C/LaElPgnqxM3YNAAnIODGa3g0qPPb/dvrH5i+xsgaADwCV8mR/lY
 hRKzVrMJk+25+p1GcbuljR4mzknvJxIzqDiO1ECSSTSU0TLEDREcvnp1NNm2b930bRRj 3g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m1nd8dh81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:37:01 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2APKWUUX015909;
        Sat, 26 Nov 2022 00:37:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnka1wgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 26 Nov 2022 00:37:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtFFPDyKGIrAjEpRZIfQAhrmV4Na07xAdSKBJj5QJRS47TwUjR5dr/c7d16ue7UUzJBfju2SeXcEbO7tFFrI8OxEnV+F3TB9RC88RYNyO9Mi5K0/aDsAsQLYnW4oI36KrBycd47VqSv+2HFTzI2qKHkt5Wx409m6Yz8YKVigpNUt4p9oBHm7iENGOCrWEU4+sXW1J+ARltw/xZdQhN1Sel/RLpU5yVOfsfRp8CFSbqG1xKNlef2jveK8saNPqlHI3AcMUYhJCvjV41it8wCwmeJegdjtEX/1Fom9sDvCApVIJPMKRyo1Kw14YDoA9aUl4MlypQZ8EG3IH6oJ6iBxIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amQ5iCbtCAYl3FHnFyUtw75F28ekJ1U2YbUtO4knTPI=;
 b=aaCGNSGKPnVOja/phwK3seHJ+3UuVOFnn98hzQtqo1R9UwVeFPWoM1TDxENkezeVTKgigbok+dH20zJjSpBJ3fGiCl8/mqIKaMbu9XqNYWDOIr1/FzLgmojcPaBTzZWQD9xRZrixvLHSU4QO20sTLHvmXrA5jyze3C84/R4QkDlqhzPZFPMWo/Tkrs8Tuxn7xoMqNMNE5xKeboj8U7BnFbnTV7PfSUmN6PntLdfLCGT0GLZVCzRqtFKkiB+YwwKHCevp3VISuUBG6YDkGNgeH1xhEafHZSu/toBGa21HwR/XX3zSheWlCm5e4Mx3/kBM/PBETJvi5GcoYQ92BFtaQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amQ5iCbtCAYl3FHnFyUtw75F28ekJ1U2YbUtO4knTPI=;
 b=iuh5rv716bjZlAEXSpSS31sQ459MbW+n6XuDYAh+bjJ8UEN7KxoGgZ1L4RPdT4gb1zB8E+yoU1oUJYnGPbrMNH2qlKbvHAqr9FH2JQwp/ZtQMd7QJ+rsVF1PUBUSQ4Bl8b/hXo3XwlSZcbqGdpgqJksL5p+uLJOe5iYZQisZ32I=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 26 Nov
 2022 00:36:58 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b32e:78d8:ef63:470a%9]) with mapi id 15.20.5857.020; Sat, 26 Nov 2022
 00:36:58 +0000
To:     Gleb Chesnokov <gleb.chesnokov@scst.dev>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] qla2xxx: Initialize vha->unknown_atio_[list, work]
 for NPIV hosts
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y1ryo8ke.fsf@ca-mkp.ca.oracle.com>
References: <376c89a2-a9ac-bcf9-bf0f-dfe89a02fd4b@scst.dev>
Date:   Fri, 25 Nov 2022 19:36:55 -0500
In-Reply-To: <376c89a2-a9ac-bcf9-bf0f-dfe89a02fd4b@scst.dev> (Gleb Chesnokov's
        message of "Tue, 15 Nov 2022 12:38:08 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:a03:331::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e75b56-9b80-47f3-a36c-08dacf465382
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HaaGXdpdC87OruRCDLi4o2eGI78/MuutcD1Pg7bLYacYLXGwWSbBy8tXDXjwUXDL0hIVCXYClROgHLrUNCziR8odl+oWMo2qq53UWtMJhI/qlRJVzP8p60rTlkBl6f5hGU1PeReF7u7rfCIoMEUsXLzanuOu1d565UsK1ru9ZBl2YYA6eH7EP4gh16D5+JLqdhVr2mLBnN5gATZmbHqfQZ+rIEYLk4MSXmmwYaWaI2dbPwtzon+fTFfqGFvCoDUnHGjJgoVCLBZNDn2SifUukp+j4jGMvH5cz6qHp1nQpIQH+tIYXQQgHF9nCmaVGBs72B0MBafuJPZxWs3JgSjPklkYGFdXkotcVNft9323hFnGEHHKVG56meHEqieVGgPDDSE1ipem1YoSrkZOJrwyCiwxqo0DkIFvCQn3WvacU1T0H4s6/a8UL65Ovd1aOta2jL8yVRM4gJn+f7sV3w4eJ8ztiOsS4W0vDTuO4TJEKpe7xqQj1MrJQa6mo0aQaRZH793q8VrqZSscymtpVcMTWTlndTER75asSclm8F+MBG4MXL97gKGQP481GvoMHKhvSFOKhWp6pGgZl7YpL7//QQrKeXK/Q0CNIi5MTZp3yoS8qpcask4SYUw6mAan04BUpo5gAqtdrXhmdh/lcuZzpQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199015)(8676002)(2906002)(86362001)(66946007)(66556008)(41300700001)(66476007)(38100700002)(4744005)(6512007)(8936002)(5660300002)(4326008)(26005)(6916009)(6506007)(6666004)(316002)(6486002)(186003)(478600001)(36916002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/QLapdiGQf1wPnGTV6X6Pu2aTFZwchhcNryUJ6ruiOMn5dPwh21RCh1HrEKu?=
 =?us-ascii?Q?ZtXZ97bilzPYf5YusNhPWdU747WicLchpdMF9wpD9viZ7s/tgQT7PeTjtvFS?=
 =?us-ascii?Q?iKJ87KAHbICXixabZFEQDboL5pUso6upUufltFB6o47Azk9Q55Uw2P9KXbQU?=
 =?us-ascii?Q?bthlOE+iiaBW8S0JiG5XzYFNiosuMv479GPXqUV9LqXQkK5yJpki0OBGOGeT?=
 =?us-ascii?Q?elkrLMYhBvYAl2DE7qgDpZYJec+uHputXPLCGE7F26GRjJVw5WA0pzKlVq5y?=
 =?us-ascii?Q?UfKnZTSImzYhI8Z8U4PcEfpxdK0U0VJnLFAh6ALaNXxHne25s/U+WZ4/7kBs?=
 =?us-ascii?Q?jnr3Rzf7dGykSAiX0qm5XEtPQpnOBR/OjaRlfKAdaGxHO0JRWUFDleNroDqr?=
 =?us-ascii?Q?crRYdgSVh1PnGGBzVnRLW8Zsn4mqYGGgOVrIk5wkmDwX3qJ3GmG0/DBtTZsz?=
 =?us-ascii?Q?2fNkrHg9Q6ycp3NyfDiTqCby9xd0aLQU7PmwDK2r+opU8SYPLIusY+mluZXa?=
 =?us-ascii?Q?hUcwW70feBV20HUm5Ag7G63T9y5kP4ZhlpapiW+AEDYZe2PeIvarRbZ6E/1t?=
 =?us-ascii?Q?q5ztgTPCIwzT4mCWVAos6kW1A18h5HzbDbqvPdrQsNEo6OoTmo6N0OMJdq7j?=
 =?us-ascii?Q?7g14vMQ2Y7MZrnYLwBWXT7Du9r9uoCRJnPO5fjV67acTQ43ilqGdDTPsYkNu?=
 =?us-ascii?Q?Krj4CO8J6qg4lOqhkKwGV5FGb2uzQYhmJIDt9klCaRS8CCECYY6JLWKkCFIk?=
 =?us-ascii?Q?2HYOh9cpEhR8tU554IAgQtd49nfYWQxBlVaDIrh5IZO3vK153SebulNlullL?=
 =?us-ascii?Q?ezPS+jZcoqrFIUNNWVqK0EOERvkldc76AR0YqVW0bLu4dADjUHORJMA+2JGy?=
 =?us-ascii?Q?MAN3/i3J+4UwZVWu7PcODUyMzeXA1ArsCPd2DlK3SsAhriovXZcded4Tandd?=
 =?us-ascii?Q?iehtbLmRpbgLThfYs6d7k+v8HVWIz/5R2RCOxOD5mpAD4Z8DJgxCneuaR4qN?=
 =?us-ascii?Q?oJlFyHkoAFG/1OMWYfvS03oTFIxiAqTXoMVAur7N+Fh5XGrHrAEggxHI6zaf?=
 =?us-ascii?Q?m5/rBmVDDS5Uzx+73ep+Gwt1YIR2f3j70NJgrSUODHVQpvyYfoUjZzQLcOSc?=
 =?us-ascii?Q?EX8eXoTK1B5vRk+vBSBikvAZBSSxBJZZqhqSkEO8Lkdn7BUIBk2SePBd7/8U?=
 =?us-ascii?Q?Jjzta5Nk9kImGSkWvyOFZRSy49GMlVh55INA/XlkFjsF6qkYJZkPmblUVA/R?=
 =?us-ascii?Q?sOBFVZVuQabZkTji7ZqSidcovLeP7JlcQR4Gzv51XK44x6kW2wIFOhrtNQXy?=
 =?us-ascii?Q?Z6P4Mk3hxfX54nc1eUNFvbCYxBXZ0dD4O6G7qd59RKZFc3e1bAYP8EsPrFZ9?=
 =?us-ascii?Q?S4YafPgrP8zwSLhKpywmYPk6//Salfj1YSN7c2q+DUEZmVZA45MS62WvSlAO?=
 =?us-ascii?Q?HbXuRDCvJzW24pe0GCsn59eZDInggk1zpzRzG6CZZDJls3MVCrzt998MygBJ?=
 =?us-ascii?Q?cm1mNtqr5cCF8B2NNjMYWBRHNDEV5ZqE334GGDzzZ+JsWt09U8wff2e7P87Q?=
 =?us-ascii?Q?M76BhHNtoRzbFkCe9KXLrzS8Fuq9zRJ5HuB4UdlPRh8KYDpK2z5MWHfJK4+r?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 4KV9mzhL/p7h8s705PjchSJ4Ptu9MibGTygLtiGbeMLJvC73H0VB3QzHEOlh9grprnrP2Bry9zHtyHBIZPvg9XOOYYme1Zs+98soD1fvPqG4wG03zjlmK5Lb3TOHIfPCOuaFuxlUpO1QetQ6VqvKVlEMm6pxkv+khP9bLCjpoeq00FK86EbjfU2n7Uf8Gh4MbatcwI37nK26qKh+g4L2VH9FPHNAmu2psb7i/U4CSunNhpkolMnuPlRKvHQfLC+4982T1beYCdH59pgTaIUcUY7pvFgERGL1BvJZMmrPxxS08ABmhm3t9J84paryDP8/4EcwKjbRjZbt2cWbHFRxsWnQzrw9OvTPzL+NuYkR3VkQcEHKPswfIFS196xTOx36Wbksqf9pWc+e3FLo39GlsdR4ZP1YGNpcDe9Y1gwFYjZdYuTKLiKZDGtj4V7ZRh6Ys9ijGmCsWWsjsJ+Nqn0c3OI+mdXHz+z67sUBS865L00dGOp8X+j5pJ5m1S2rVwhu2n9ojDyIPW9QvJE6IcevREt6RoT2YZe22RbkAEtVkvwfA2gj4iFNKqvJp0JGL8Ei6IHuJFg7hKgMFQ0fugEFnDJyj0CnbiG7WSIiPQ8fOfQipD6U4AOh/4WrZ4euXoQznInraF+l1nAN9PL+9uLnvJ+ufhj28IFaqi4cX/0s08uwhqfiNDBauVSUcjqt0oXofFECpu5hYmhXa6t0MYGv+MylxFRC/ZyYm3Dk7XaEJ/06tlDrefZuLoX2A95Or3b/maCObotzduoEBlW7hF5X79fuoAzGApXR/Qvh+kioQQQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e75b56-9b80-47f3-a36c-08dacf465382
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2022 00:36:58.3170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ql0HYZaXIALmnFr7Bgu7r4yvpIahMVcyJbHWm9ywfy0mC8QSvQUO0dJNh319zDyfPCHkDN40r/w6iixqZ5Ct/au1PUyklR+SWsiYlXWoAbk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-25_12,2022-11-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxlogscore=897 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211260001
X-Proofpoint-GUID: 9_eabE-OPEVsfcZPNX6qgT8qMOCMC25n
X-Proofpoint-ORIG-GUID: 9_eabE-OPEVsfcZPNX6qgT8qMOCMC25n
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Gleb,

> Initialization of vha->unknown_atio_list and vha->unknown_atio_work
> only happens for base_vha in qla_probe_one_stage1(). But there is no
> initialization for NPIV hosts that are created in
> qla24xx_vport_create().

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
