Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1170BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E3722D75
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 03:24:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAHDY3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 22:24:29 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51290 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbhAHDY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2021 22:24:28 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10839WmB178160;
        Fri, 8 Jan 2021 03:23:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=SACTd+q1OhPIKpPdRxnPzBuAYx8T5sAV/zfDOVF0mV0=;
 b=eLu5i0OjwvjDzcUZSktZUV/7hRy+pqXYeZlWW8mn9G8Sp3135YqWlzvzc6o5ix/pkhfP
 /3gYwDIS99tJjKBwXBWVGkpbletEJRu9Q9XenYC4sLlHtBFsBlYo7FpVGsDmWtsLPt84
 dFGX4PY61yy3Aa/9D0WGWLa7RgH4p4Iqsb3/lGUFYEAC5zgafzoURM63mX68AhsYtbax
 uo0NknQROjTWnSMlb+NcQrHGmlqR3WqUVdbaMV6QHjKoHyxucqQKByLEneEruOPR+VzA
 VRMoKDAfiDl514Era/Q/K5otWV3HmiGaaRwkteN+52AjtH/hPbpbO27Zyv7HPgOQZ2SN Pg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 35wftxevwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 08 Jan 2021 03:23:37 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1083AUNx094479;
        Fri, 8 Jan 2021 03:21:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 35w3quqtad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Jan 2021 03:21:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcZRyCFc/G4qV9ITOWCrZusruQezdn0MWTXJiQ5EuUVHhtexM30SN/GhLDMfuigcAOq53z9S6kinDiu/Nkb7S4UMQ8yDE5tskIu+bu5n6m0YBzHWw+VYPWY4ejVFW/2WMnIOhoMHty5ow92NJ6eahDa/WMNKI5GOR899Mr7KfrQ0WkA3Vgfua7KrNuNyefmuiNZPySPSMtC4W+c9GfDZxWcub4bgv73wDv8m73q2ps8XIatCa0vk4MLqGX/j9Xtg5qWuoYDg2HLSMR0ORa+Eqd+XgImONSJYiVW3WJu8qQbYVmhfFya9aecq46/YCJnivmbwNlGXYCwX5rLXp+wTNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SACTd+q1OhPIKpPdRxnPzBuAYx8T5sAV/zfDOVF0mV0=;
 b=CMCNLKKE7KVH2c6j7H+gJ1osa+NvcB9t36CISlJy7oBXmLF9h7HDzqcgDdafs0ALC/OO2YaF7OKLFrfDTR2dnd6rtq0CAhwYnp6MJKj0iathp7P+l33a6tBsSv70c2LwHqSgWyQz5YiDZxanoI/fBeHv1yMeOUXE0zPiPXVXkUzSuEhLRjCJT6MHvbqay9HjGBg0aLL1XceM/VgARbScgaveVNNMGkNFGBO07JSUZqvMtm27RESFNRrDuMVGwaOELUSIBuBVoEnGrjHXUu9ZvJRnQWvSN307HACRcKt+9ITLZw9mJSF9UrotrKsVYWUvM5gp7ejr0vHXiB5PaHNfKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SACTd+q1OhPIKpPdRxnPzBuAYx8T5sAV/zfDOVF0mV0=;
 b=RAGiJh+Ius8qsoMYnmU9CTWhRTgKuuilmzD4T3xmdQL9b8Rl7wBj1pBiiHifO3A4wL1dI3zi1/B8VOBhEMJQUC/RoubQ6/hReB3KjHUNfc8nXhkl8Omj4CtOkGaIjCVN7YuGHLUD8q7rCnWJ8zfSWUYzdPcQerusxDGfyl+Qzjs=
Authentication-Results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (20.182.127.76) by
 PH0PR10MB4470.namprd10.prod.outlook.com (20.182.107.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3742.6; Fri, 8 Jan 2021 03:21:35 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3742.006; Fri, 8 Jan 2021
 03:21:34 +0000
To:     Viswas G <Viswas.G@microchip.com>
Cc:     <linux-scsi@vger.kernel.org>,
        <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 0/8] pm80xx updates.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1mwce4p.fsf@ca-mkp.ca.oracle.com>
References: <20201230045743.14694-1-Viswas.G@microchip.com.com>
Date:   Thu, 07 Jan 2021 22:21:29 -0500
In-Reply-To: <20201230045743.14694-1-Viswas.G@microchip.com.com> (Viswas G.'s
        message of "Wed, 30 Dec 2020 10:27:35 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: DM5PR22CA0013.namprd22.prod.outlook.com
 (2603:10b6:3:101::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by DM5PR22CA0013.namprd22.prod.outlook.com (2603:10b6:3:101::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Fri, 8 Jan 2021 03:21:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a6083263-5cb5-453b-554c-08d8b38480b3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4470:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4470C5C70E43BA170A2739C88EAE0@PH0PR10MB4470.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: selue8J68a4s8AnpNJdgPVmJSWFk6a5Ok1y0eF1IKgz6Yt99AI5FCglIH+Pey9khVV05P47ypOKw7BLfPNqGEvVutFT2bNf35prR3GFoqcloQ4NmEMXuGeYlaYoaVdtilR2JLRuMOxwixkbOYuhGHQLh8UGr0v+QnOLAGHs9OsUrKbe2MQ9ug8RZtzwadjvT2HkYUVtcdmxt3rWSdKO/Jb7GbRUawn21vYC0MfpEZQP+9aeKwzYn8s072p6+HCdiy+UZhwzNdGpwH460re/oYltKk2piabJ6IMgBPZnwOwFIV8pfemXEzCmus59urJUR8RPcTOJ+qVBFgEMHbR/SOup/cqJf2mPy2XAx7+wmKGB+0oFVrwUMe4UZ0iCCotcVAMbkdl1lIYSydyo/AtJrCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39850400004)(376002)(396003)(346002)(366004)(66476007)(6666004)(66556008)(186003)(36916002)(7416002)(7696005)(52116002)(478600001)(66946007)(86362001)(16526019)(26005)(8676002)(54906003)(6916009)(316002)(2906002)(956004)(4326008)(55016002)(5660300002)(8936002)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1pF2lj1L7RJmuh5LKepk7xEmt9nK+4ZC7ZkMVj1+KBTKN+waD0JoSeskkas2?=
 =?us-ascii?Q?BbYq8Y7/wqBy3dbfgCXtxGIDuVVKvZ7yDHpZjiadPnQRErV78E7kR/YYBRDc?=
 =?us-ascii?Q?1tBOeRlsw5oTLfT+SK7NKSZIo47Br2eB9QsC4dHja0M6YyuFKnEOVTsbnYyd?=
 =?us-ascii?Q?3SY7p75CHQGOZNQpMFCcDyghbbpFKOqTmA7Q3QMORbo0LYuBKI+Xmlkt+kfy?=
 =?us-ascii?Q?h8v36aauflb1ukliHoOfdqJjkd7dOltbpzlAZXXwsRBRvWuRdYFM+RNRfaTg?=
 =?us-ascii?Q?qoLGxFR2msl7Xbkt9JoQ+0UL486mO78+199e2B/eXp8NdH/z1WvcvU+vWuoI?=
 =?us-ascii?Q?kN8nXvr2e0FPbsdsEZljP5sulSCurKlWgscYsNdLkJsgdAJW2EmIszTOp14R?=
 =?us-ascii?Q?j6xPxUvws63qR7cUFTvqxTeRyhtW2ddEFlBzZ65AbnBkrcVbiAsRV2sUDLHR?=
 =?us-ascii?Q?g7iKoQCZLIen8dlJn+XmKY3FNsIXkTgLutuVXkiQcL+y7yI3Vjfm8XxUI3Qv?=
 =?us-ascii?Q?awsSVgU7UFv7JGH0MosH2KHSvCXpZrJ1Sp/8zmiSVWVa8L5IiYJoPv5Gsh6l?=
 =?us-ascii?Q?AwRFKV8KnKv/cS3Of34LHF4G5/r/WkmVO+qsVZIM1GhIzCDQgUdf2JQAy+oW?=
 =?us-ascii?Q?SUuP37zUkYvjCGLnMZmi+8FfSPjAUOdjHZPUvgRJpLL2x3SnOHE+2NrOD+Ur?=
 =?us-ascii?Q?DCYAGTvaBgg4xrHjwnGHTI32H5eCUibhHyu2wC/IVbE5+JbqMeHCqTctCs7d?=
 =?us-ascii?Q?wkWzBajxovgnT/v8ykha5Lt0O/Xw2gBwOJsF1CjhXhhQse+rtI/N9M0FoSTQ?=
 =?us-ascii?Q?UPb/eTHkEQcw2FVN1K4psW7SA2H0QR+z+1fsZ7Upcuuqck+RxH2yVdsl58x4?=
 =?us-ascii?Q?AuX/fpTJN55UW5qA/zYKZ3G7eDoOkejyqtkO2FBAK63tC7+8ed9gzEYLelYo?=
 =?us-ascii?Q?MSaZEfOoaTILdApkuBlYOrMGaUVYcpoNpHqJoTUXdL8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2021 03:21:34.7762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: a6083263-5cb5-453b-554c-08d8b38480b3
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dw+pLJDf8wxZbhOHYL7rW2CeqC1D+oPxLaROONJ4h9SMehGJayc56HAQQP9A8GJx6I1KhyFkcYQEziKj4tYACSx1weT7yUWXc1cyBV1MeBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4470
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 spamscore=0 mlxlogscore=848 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9857 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101080017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Viswas!

> From: Viswas G <Viswas.G@microchip.com>

This series was submitted as <Viswas.G@microchip.com.com>. I was going
to fix it up but various tooling gets confused and we end up with weird
lore links.

Please fix your email address and resubmit.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
