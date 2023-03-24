Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E8D0C76195
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 21:40:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbjCXVkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 17:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjCXVko (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 17:40:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD52D523;
        Fri, 24 Mar 2023 14:40:43 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OLZ8bR016033;
        Fri, 24 Mar 2023 21:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ASEvFYwFr/XymaH1K8oexY7+R038tzN40G3g7xA1kqU=;
 b=p6aUcuMkY7lqtRDTCzIyfwJtb1GXvb0ajKpH7zqfm+Gd0/s8enTROhC8j0Ki589vDOJx
 3U342EOQRpkWNm5nHibt2bVpbHtOkSO5NFPOopYMM+1SxYeQetg1mvfETdAT57mLqI4+
 TeT1I7KWLiYWgEUZdVJ6naNrbSQUxTJKkAo2nJhme6L36p16MY7188NPqb8NFE7hBJNY
 cQK2Z3zr6MkWotjwGBQtrxJQodHYb4NPTtXQGsgx4lL/Au7znygWtXKD82Dq4iJlKseu
 VWwlqVz5MXc3+sn5FbJ5uN68KjPxSTAvEP7JXkY8vVe4FtUvSlMydcZ+59+l4O5kwwO+ Gw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phkw7806h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:40:40 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OLGA23037950;
        Fri, 24 Mar 2023 21:40:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxpyhdjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 21:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIooeCkx9FMNv8w88l5/Sabkj1CugQuTtlfi24C7gG0YOlm8XOb6c4RYRXxEf1UZ/VF/KZ/1B3d4EZ43rzt8G2FCQAF0u5wK7oJ068hywGa21ytfHlJK3LOExlyprXC2QVWbocgxd9x3dPxhHuqaE97vIgTXzFiW/EUvaOm3QE2mpoAKMMw0FC4Quy9GNgUY1elJRFhnJVm8n4ECDOjNrn2xemesuu1h2DErUZFnNVFAHG6oX10N8JfOlqrsQmhh8ai5BfNG3plP1fC9BjS79D1aSSaYdxBdSpITbUaqusYCXr3NNj4XGsjrdU8dE8qd/eb0ZUhzTUKK1flG7qsqWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ASEvFYwFr/XymaH1K8oexY7+R038tzN40G3g7xA1kqU=;
 b=ClCvhHH59wLVYb4U+WKOJkGpKVRMWy8VstgPF+yfhrktsoqprE8JTmbiS1XjbwqBL+z+q1AtfGm7w8490Qf74L6O8JsyNooZmJ94xYgKoCo4HtRUj0gSmZovHC03MHNyW/JN3cLLMmB3CaBUF05KQe98Yvqm6HqbfrcxuXwtU9ksmtGGRNxFmcS6rIWy+Haxht/y2lZgB/y0cMSGh4102KlkPYPRJsHYC0p+FnVB1TOfnt7uBxkIGz57Ri1zle1QmqYXyqgI7wXMThvWcegSRVWaoe3AXotcJ7nV2MRL1y3LC9qzbRTYGDmAQsj4WMYPpRWmk6u5ZYyXpdYSsYd3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ASEvFYwFr/XymaH1K8oexY7+R038tzN40G3g7xA1kqU=;
 b=cypmnNDQ+DF6osZPTuR10FcwqbMqM2vMNwmI02Azz0XVvc0YEO4dvZdgvOuG9Y8uLQeHXl1RXGljohQnwsAJecuf2odSVpBQaWLqTW53dCA/0XnteoTOcANnCe10gf84QcngX1mKurCo2G9lHtiunYEOVaB/crI3RA/uNeOWv28=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7240.namprd10.prod.outlook.com (2603:10b6:208:3f5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 21:40:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 21:40:37 +0000
To:     Mike Christie <michael.christie@oracle.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v5 0/9] target: TMF and recovery fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11qldkev1.fsf@ca-mkp.ca.oracle.com>
References: <20230319015620.96006-1-michael.christie@oracle.com>
Date:   Fri, 24 Mar 2023 17:40:32 -0400
In-Reply-To: <20230319015620.96006-1-michael.christie@oracle.com> (Mike
        Christie's message of "Sat, 18 Mar 2023 20:56:11 -0500")
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0182.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7240:EE_
X-MS-Office365-Filtering-Correlation-Id: 802cbddb-3417-48f9-81ab-08db2cb067fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Va4CiUEIgj/XUUnEO4mWdNtOELWbIlu47TAE6W34UbVBEpA9nnhrA7/n3QtHjfsf0ce/XtwTWnzb6v4WRgy1Jr5roDTKmQhWyv0DFM02wk2O5qC4NhFeCyFTrDNgda/jdyiPBd0c8nIsDxZ4F/C5exy16Qo4OQ2NBUGFt4SQw3zR3721RLLjc7lpk0WSRg1kG0MBJQ/YcSCDUSvLYg9nAcPZTGWGKz5mve/a9PFQ7tmn5ytLi+yo14MbXssZOvPAfMhE0tCxz86Y1Vcb2xQjMakOMojTtdVpKBb2qjxxKpIlE0NjHr+rGjCT2ZvE2exhVTKtUfvGII4XyOrjg/37w8B1RBcwBLoFI/rufhwkCwB/Dp0pNh2y0zNsRJNaMroUs4i/4bMsh0ZA3nPDTIGSNL4ZKRP+d9D1agoCPgnHoV5a9V/1vugLD3Vq6dY/KjajPyP+IGLEGXYtTIQysCeZKZNfLrx7bE07/tRqb9jaYbiVXfqmG9m8zAxN7ouoGm0CbeZX0Hlwm373Rzaou7jX6/1GhHI8UHvIC/npqve1yRMMcLg5877M/guRy9pX+yLg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(366004)(376002)(396003)(451199021)(2906002)(478600001)(6862004)(36916002)(38100700002)(41300700001)(8936002)(6506007)(6512007)(6666004)(26005)(186003)(6486002)(8676002)(4326008)(6636002)(316002)(66946007)(5660300002)(66556008)(66476007)(4744005)(86362001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?N5ZS0R83BYswyknlxnp8uxXZDVte/HqxTaaNBJsp8XpbJ+74a06irAwphRR+?=
 =?us-ascii?Q?JOxX6rOcV+c+GBpbWQbZd7cNFML4uVQ2Yx7r6lBk6I1bymiWphU1Is8ahu2/?=
 =?us-ascii?Q?f6QuRntGIHk+RSVQrZVNN2UavD96hzhcjK0Z2YN8DW+n1d7Uv5vBSO2uwqC/?=
 =?us-ascii?Q?grfsJn2Gfo6TVjg43k9TxWbRdP40ogVGMgGH3PIyyWcTDR/crXpTjOt+GLo1?=
 =?us-ascii?Q?kC/LGjIfme/07WodGxF3iSdN+rTQmrnc4D8MV/2Ey/uidi6wonFN8BkjTgFg?=
 =?us-ascii?Q?AwMKatdoapv0sefPv4cAJd+6oISqmJD7sF/yT31ET4MzwuUcAqIWyg5ZvpQs?=
 =?us-ascii?Q?yOEdnVr3mH5qNjBdXztffClipVclF5h3JuTyGhk4w4xPgshiZ0o5c/uLojQj?=
 =?us-ascii?Q?TzNm3IweMur134qx5/kxE6nUVGYVtd9DADANA8zjIQ6mpI2f1O73k+3KE2+c?=
 =?us-ascii?Q?4g+jflciOilBQen+Gu0mwfkSvpCcRTouTEaHqdjmbys5N0dL5nziF6erTbFq?=
 =?us-ascii?Q?qCK75beF8qpZ3MxFiRgsUOCU97l6RMyeTInj9VB0/BC8fhwA3f1JtjjkFw2O?=
 =?us-ascii?Q?PzIYdKUkNBo1QuwX/hQnTP+O/vBJDdbnQ3etxa8op5BO1TUy+YFGPhh+YsHx?=
 =?us-ascii?Q?fW9zL7qNV4ZrEhvif4L6BwgH5n2Y0fgmNKxlDjl2rR6BNNwmLwx/xP0fYXoB?=
 =?us-ascii?Q?o03/0AyFb/4bbbUu3QzFHMtomNIVBZk2q8NcggpCgNYQf0RjfnZDjsVlNPNk?=
 =?us-ascii?Q?AQEzZxBnEl+5ihFjgTfQZrk2f+C1QQVNXyGbAKMkz8sXn4N1+YlJwTNZdUej?=
 =?us-ascii?Q?dGlBg76pVu9p92XoIOWAbYMRN/AAuN1rl8r0zBTSUhsyzdpR93g+/J270Ph6?=
 =?us-ascii?Q?6+mc9PbIc0yefLKDVkhFcgb7UbGB5ns/jQzqxFVzUsZyTtz0egHO5tzbeylG?=
 =?us-ascii?Q?VXNfKRD+f4AV3aWwup9f3nxKbq0sNDWXFvGc8UD2d6VROdUIbS8AIkVmlOy1?=
 =?us-ascii?Q?3CUhEuqt0fVhMANXFltTeFHYS9C4YwmXuuOkYt6ldapLcGp7OZjtlh0JRmLk?=
 =?us-ascii?Q?4NdV/XLH0WeqAEZ+g+sCorsqDCrW0iVd3jEZqvaCOn4TWC7U8uqOMBhjqajj?=
 =?us-ascii?Q?j/9yUzrxIdnH3nFJHGRoVEXVCn0uSHBwR9KkGA5gVEumwCluhSFN/kb6OphZ?=
 =?us-ascii?Q?TrNOhvitcCYhBC9szqD19TZxmQH/w47NFZaETO56CzQKAHYUqF2+xb4NQ+6H?=
 =?us-ascii?Q?47pYp7sPT+MH/KIlQXg3kc7ewJB973TTMPzA7fzJ3NYUyDzsuAgCaUR8K/9U?=
 =?us-ascii?Q?cnXZdJ6u4VN5BxoqxWwUZbm01vq6H8/PDQoqLyz4kOOs3yHsiJACK2RT7/NO?=
 =?us-ascii?Q?LwftI7tg5ksqLdgR0vE3D87ADNREqFYXqR3ZeXA/m4wU1BDLkUlh+QVgWH8z?=
 =?us-ascii?Q?/sxBfnkn32EPBqzf7VsgBcEUReTpMM/3HUldHaXzzmbBcKqrmrW/KXsB8PA9?=
 =?us-ascii?Q?WPfpl5XTo264DghUnfL2uyGeKLJDVqhTvsrFhXkmspjdgbsXGgt6RMLcG8KP?=
 =?us-ascii?Q?8vXOYtvbmiPo3kCuCFiPGNl53uGD5sMBGqyaHEV73Kkwn8ts3psiyIwU708H?=
 =?us-ascii?Q?qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: ur9F+LxU+aSXFADWn3ZYiK4Y+y8w9g6tn7CRflImp3+m6eNNpLPLSyr98c06B7/mSIT7a0gZJh10OnCXb6FXchVGIjBNqdYjY1DGd6zjMTaneHclHRIW544dkNeOExaqmxyXr/EDOoQHhGzFUG5rZK2jOEaSCNjNJXiFDbVKtf5RCI7Ehcs0A/Ivc+Y4KvksRGrm8CP8ar06jfegkgzdH7ba/4xx+cj6B5CiGhLllFWvQ8m2wBpCygjqPyUO46QKbg5K6yo6/jSWn51Nnr4eFrnscQDxHyuZ3vGxIsEHD0i6iBPlPGifPpyY5bjmX/PGjHzzOtqOi4JW96oM3JX05UJ5ue/jJDArdhSjyM9vQEKK9VGaJ5MEpTtjFmzYLjQdJCa7MCXmy2bTMEmwvgsn9zkcIp4CSuLIMfc1Rt/JTWVs7iBVKR1DWA0jsyH5ZNXOW/XYraXEKh+BzUmGfVI3TjcZ8+n2p6RDd3eRID/dz0Q1JmTaofHUzFBc1nzsUxuoXgDKkwXSIUYUyeINsShYEsZHg+4IQrp1/OioYfTm8LPIQm8XjzD1fmzIwvXDJOChtFR39dTEnqOcV7ZuzeKNWjOnPOdtWffkSqnBceNYapAquNpRnMTDN8SYIcUz/JVb5twbgZcvBE5cIHT5y7eaTREbQL0u0VmrO4N5LiNanYVm/pq7ftjmeYXi80isKMr+jOgBetM8QY9fw+QGMxYaPH50EyAPGWjurcmhR5ivki3n4DzarPgvFlQjGZL6rqWsuLt3/Y7hoBTd5mJxiPTGbJWHpJtWhJS5/5vi/cW5VOtrm6PEh/clj6TDpd9224zj
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 802cbddb-3417-48f9-81ab-08db2cb067fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 21:40:37.5374
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DHnzEEqRJ6rUliZLt7RHElGOdwkEdyeNBrbBXdf7n1c2GYQ1Zt6ctXSgCy+q61q+nOfwBPWS4DfS2o4X7MhUGPyct2LHZKCk+YE4sGu/cvg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7240
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240165
X-Proofpoint-GUID: 4MCe3bXkUHBWV_l6qdDYZYhnGz9rlFN-
X-Proofpoint-ORIG-GUID: 4MCe3bXkUHBWV_l6qdDYZYhnGz9rlFN-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mike,

> The following patches apply over Martin's 6.4 branches and Linus's
> tree.  They fix a couple regressions in iscsit that occur when there
> are TMRs executing and a connection is closed. It also includes
> Dimitry's fixes in related code paths for cmd cleanup when ERL2 is
> used and the write pending hang during conn cleanup.
>
> This version of the patchset brings it back to just regressions and
> fixes for bugs we have a lot of users hitting. I'm going to fix isert
> and get it hooked into iscsit properly in a second patchset, because
> this one was getting so large. I've also moved my cleanup type of
> patches for a 3rd patchset.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
