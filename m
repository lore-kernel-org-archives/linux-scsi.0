Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A970EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 01:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjHHB00 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 21:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjHHB0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 21:26:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E264510CF
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 18:26:23 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 377Kwjbc003999;
        Tue, 8 Aug 2023 01:26:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=6QD2QMSa+FZoeLzX0kvX4LRYIdBIFp2JZhrGxdxhCYQ=;
 b=DY6yj1jFsHoWdwwXcmZ5hLudS4kTq+jfYzyqFr4ZjyccQoLngGDPUt9WKvYWWQ1fc+4+
 2/fn5p+LsaR2dh1geb0XysFAaFg4ZzjqSAKa36iwtfe2ur3hfbQM01uGbUPX/hld64Nw
 InTPBXbX8ifxmaDscRMtShrr7K/MADoGE/N3nUYJp1it8wITY97RtRSGZDL/DONN0iHs
 UInryWJj1do2/MeVyDeOndLB8mqAwQaBbxv6jo15eFfjlzO/1SzEnLSDqT3A0ZQ4au8s
 jmvW5Gpp2Ot0hvidaQGjPlRFEA07W4Bu2LKqry0rfAGNh+p9ocrfsVczZ3qK+czYdpwj IQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9efd435c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 01:26:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377NCumH021366;
        Tue, 8 Aug 2023 01:26:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvbv3w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Aug 2023 01:26:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzZ0AMZ4LCq1SCo9NVWqtBlYow463BUSVV1JQya+6iKQAxcrYZcGBfsBbnl2lmrSn7Wo+Y8wxM3lYOFosb5nsVkDfNoBrfzR0OkiGGLgwkSzqI+uTWxxrCz9xbjRBitUxsge6gCBUdOKWUXhscYq0k6Ovo9/ZgeZcAiWQZg6TSk3zkW+hSgpYYsX0H4kRwK8nvMf7TQ2duDkMUHbXb01C9nhXLqaDre12/9Dw5Zs2VmSdjNXixLu9RSQpXaRcaTCMz4W7iB81ss2b8z4PsuExszRpjLvyiWAaT9tCLV5Y8xon2sZQgKQ1myMdiOysXhf/XEwGx3wEDOxCzx4tc//nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6QD2QMSa+FZoeLzX0kvX4LRYIdBIFp2JZhrGxdxhCYQ=;
 b=QFdz1DsaCiviBwCPFAet8xymfYsUqVlOAB0PXD8l968ii2McT6JFe+wtl9Dfm97tPFV3zqp4U0CnXLD33MhwmJPbA8rAsT1sLvDCdP7ldULPYqHDCimkj+HcdvYyg8jzN1pCDVgHVQoiLme6j63UKfqZ+XOL5UjNVYw9Lvq+TyFHu20ZZrTAXnlHKLL8CnF8cAXq0RWZIYVMeJKBiqx4ZLb6yW07HhpSNhaGsjM3P/6B2NjuI82DStsb5mJCfLZJRy+EGq8XB1BQutmKciwB8tqUtryDLBua/QWRfPeMhc2fEbwB0ePSquidZJrhznkAtISN5HPEkA+w2k43M1e7wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6QD2QMSa+FZoeLzX0kvX4LRYIdBIFp2JZhrGxdxhCYQ=;
 b=Ozvy8etIdGrdqpuoNkUcLxkPg/3rQh7rBmB5yLL70m74Jw5mdnusLNXH/N3pyzwkyMu9O+yDFE9FFuFGsD5zTch+fEgJ3Smg8F7o3KSg0W75d9PEC0WscEG90RuLYTfv7VR9lNYFslg0EE9Ocbt7Z4omMso8IGqzbMRMvdDkZBk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5352.namprd10.prod.outlook.com (2603:10b6:408:114::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Tue, 8 Aug
 2023 01:26:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%6]) with mapi id 15.20.6652.026; Tue, 8 Aug 2023
 01:26:17 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 1/1] lpfc: Modify when a node should be put in device
 recovery mode during RSCN
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a5v2l3yp.fsf@ca-mkp.ca.oracle.com>
References: <20230804195546.157839-1-justintee8345@gmail.com>
Date:   Mon, 07 Aug 2023 21:26:15 -0400
In-Reply-To: <20230804195546.157839-1-justintee8345@gmail.com> (Justin Tee's
        message of "Fri, 4 Aug 2023 12:55:46 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5352:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ac47d51-13cb-4e19-92bc-08db97ae76dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3kqGTmoPa/aNX/FuLejwkLk0M9JrGTG6+AVAs6qiiDscOMqeOiP2sBkur/fp8wqygcC+24iSUEVM0cSsTh7wNlUlQI1j3BJXZpSvOLxSH3D2dCw7j9CxC/icFKkswg2FwTX7UVydHknMIVqJG0hBQjXoaeJVRSn8MsvWiLotkIuY88zo78muWFcbXEolB0dqeOJ33oEEU/MFEzwrLgPcKbU6XgcbAFNNMCpAifK9mTopoBTZH175bzDZFMULLKtspWsXPHhO1o42XrYOFYHgvKnn7H3PvkWIOsKFCcS7ScoKa22nfymoNgkqtA6Svsh1OqUmX+dpPBx7cAlo6YEDyJJqWiIKiaPIEr5uWb9LGJwHUqMn5yIu0cTFGLlM4YCKbV5nHhGLq1rgRDalbq+kzaYJJMYpaSyKHHHVk60I4zEbIhMNgq9wGZS5269GuNrRLize5zLxNgiLvQdCoT5QO6bATbxdrXoLLBe0IPeXT9ltfBYtHcNznXjUrLNjTG5qnWsbvwhWo47diFCzXsck8QYvJjoCFf4dHNbwsidUr0fk2aB3hoa5XIMCmjuq/F3LtXn79yNQASy/j37qjCELXfisZHRYD8EmzZvA/a1nAE5T7ikRCEW4wwq96HjQh1o5qwLxCOaV3A0j4f6XGRYXxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(396003)(136003)(346002)(366004)(90011799007)(451199021)(90021799007)(1800799003)(186006)(6512007)(26005)(6506007)(38100700002)(5660300002)(86362001)(4744005)(4326008)(6916009)(2906002)(66946007)(66556008)(66476007)(41300700001)(8936002)(8676002)(316002)(36916002)(478600001)(83380400001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yR8qbo1CtxKal6shmPlYBS7pkzECHa2KP+BZyaxro5czlpM+4vNeSKD/AiWR?=
 =?us-ascii?Q?5pAFBuiqtjc01LKac3sE6hpYahn2orhV0Q1K9bY7iTF6nytrJRVQSXtS0zuz?=
 =?us-ascii?Q?C/Xg//ZThn9mrqYhr6sBPAC+PJGhVHbBPX4u7pXOfKQTpy1IwOViUSl6LIX+?=
 =?us-ascii?Q?WWkSGyTGNw1B4aa+A0LlWOQ4etkVPnvSL3JHZRa6UUL62OjXFMUbHoxjXvs/?=
 =?us-ascii?Q?yCO4Yp1jWF199y5lPHfIIeEQCodJqsgBy520qkVAtS8FMZnWAXatK/osXmcb?=
 =?us-ascii?Q?dzdMwcl49PQ+Tdc5s7moK5zmlhw3d6sZ/RTzCvi8hGP1Lmr+efME5d7mZcIn?=
 =?us-ascii?Q?Nw1nq/DDWw9otO7LSmh5TImPPS0g0O9eeKPLfNFhHUbvIB3N09vNxNT3w1U+?=
 =?us-ascii?Q?9W61TwyaYvdYA5WCMsnxNvzamptBaFUnNfDFvHhExTCsepCT1v1Kd1pycJyv?=
 =?us-ascii?Q?tC0RY+VsP94KZ+KF21UDGi/DISsBZdBTdWcSG6jFj9tbQNe0z23eQvmPkjT1?=
 =?us-ascii?Q?Bl++qZtoCDf1KrR4gOfrVmVR/JYXuyVjv8Ma3mqvsM9Dz8ZOco0//oC/oZ21?=
 =?us-ascii?Q?9YNCn+1fmGNwncN0B0qMH77NtwPICs/CSFxaqhTJqhpIEQqM7CIvdPG5R+Lw?=
 =?us-ascii?Q?cGpgLFX9GqOwhn+6ouIS7X15UR5P0lQTAo9BCHRcc1G4Af2Wu6qA6doYsXnu?=
 =?us-ascii?Q?XPiYeSAi55hZFsPHC3wX8ojwbS9IJtksYKUbGFzDlJ3nPFR7t9Z9BseVMtu3?=
 =?us-ascii?Q?VI/Q+Bn03fF0wybXK5dhsic/3WqKeod+fJEk5pjw1jnyYwlHvBraGdmYeuaf?=
 =?us-ascii?Q?Sp8Ywm97MWSnvypOdLFMTCCi8doCvPOxxfBBJ/Y6biDhVQy6wRPZWTda3T1f?=
 =?us-ascii?Q?fS7DFCbXVbu55GCeMWX3h9DsdnOJPfE6Nhg8PIY3RySVHtaXaRckyBOwdny9?=
 =?us-ascii?Q?XyYHmF2NuwQEWyz4HaADJbluI9gP/Z0KGfnZrbNg2POjfxZ6xGfV94g10tEw?=
 =?us-ascii?Q?5sR+TAsi8tJhoWaj2QH14GQQFDEXRMnR/hbImH12dsrmU8XGxA20Cx+9cTCw?=
 =?us-ascii?Q?/6ye5HPNuwAvd+3bBGnMaCGwPwojz2is9hwR/jtuSsKwC5tOyVHzYjzsbHDO?=
 =?us-ascii?Q?6HxkpGgVIRQeXrLpWkJfCapjiPWhXULGlNQZ48zjEPnvDQhBzFpF79Kf2wo3?=
 =?us-ascii?Q?JCCmC94E1hS2GgdUaSAL0JrBcjbreO+cY0o7ftpxxnk95Zo+Afr4cAvQtQFd?=
 =?us-ascii?Q?kF7V9W1yDs3fj/kYPF9K383KPOU+hGU3WpW+gqUz7NxnM9+KjpDHDKFbp45S?=
 =?us-ascii?Q?nTLL41IBbW6PsP5RT0s4xJ5BIDXn/zJUREaRL0KzFffI+6VJwbE3TsRFQczf?=
 =?us-ascii?Q?q/jbCb+5kRhHPMoUcRwKDlvM7lB5glPZYPQgKuSzACTgp+OoHgVKVWvsj3GX?=
 =?us-ascii?Q?uOdChncl4RjdMI3QiDt11bgBDa/ciwGnXez6I5uC6srK60okTCYvgwS3z8Xk?=
 =?us-ascii?Q?FP3n2q+3+Y8LfzzdFUCecvNube2uzfO/+GJ9bu1bNeNWCixINVklZV0EMxef?=
 =?us-ascii?Q?EGjH7zAceOg01PHqGlRvHxJBIM4zh0/rs3+QqVbPdpU3IftAv/phdB5CKXa8?=
 =?us-ascii?Q?Qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: DVnZaUx1AeNwnq6eTPrhyn9MZmg5Pcb/aFFwuWlxfIHZCyAzyq7fo8fqc7Xg0up6bI6995hycc3bRXNe8nU6SZaMdYdj3S7fMpBtyvmVQq3K8VLW45KVUqIxII1pIirD/IcJtBNKAK85Z65MFlaSpyW2xIL77R4gPf492slZL8Gk95i1i/Qmk8a+dRDsjMbPh01QPnn4eZTtftkf232Ujy7QXy+e6Nr/Qur9wxAYgvhwlU/09vBr98CtF98QW/YUr96kDWj3Fu8deDGE5K+6NGQo2O+SspfgrzuD5oULI3javRXWj+mJpOuZytajp4GK5G+G+TX19niDJKau8u/LGKklWP1vl90ixJ/2HeSwr1zbIsbX9udBkHAQsQXCz0cxyNde0qcNCxQXnIe9Lnr9mGClZ0rPa+fNG+PXEgHVZwf6pwgskid5GP1qI1fxUuNoWhuAwPtfrzh9DfCnOjQoflHADhkDm3Zg4Gopu9EHleUB3Lpkfw4WZbGgwWL9twV/9EggmjG39FjF41ecAexQGh8xIGJ0PfX52j+Pb6f9cwoHYNgg3TvYsDOAXiuyyKYy50gk36ku1WLgMn4zMTYxpPaoqktJOdHKib/W96LuJWQzxGG5K8G15vP95LVDmkvr/b5wqn9I7061Gr5rX0CMEL68vFdC2su/MN6M8gqWHvrkc9OG+4vZDYcDPO1mqim9Nc77Dqf0VF0QdT6sgldmJLigYFMBcVsm34NJsFZfuplue55Pt8raBZAXC6WkmdcECkefOHrepnOATSjc/fphaEIHoq4TGo0H7Df9qkNQnbBkpA3IL1Hnm5Ajz/j7EwF+
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ac47d51-13cb-4e19-92bc-08db97ae76dd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2023 01:26:17.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0BOK7Hnbap4Y5nAt0Sf3TVcdvjHIt2rjpgQP6TmcABeKZZpdJtE09OJb8RUQmyniOlBDdGlWWE6Y4H9Bj2eaJTNk85pWBR2uTGasJxAg8/U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5352
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_28,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 adultscore=0 mlxlogscore=858 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308080011
X-Proofpoint-GUID: Z0bx0bOCPgxzXcZ4aQjlNPzYpbYMipIa
X-Proofpoint-ORIG-GUID: Z0bx0bOCPgxzXcZ4aQjlNPzYpbYMipIa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Only nodes whose state is at least past a PLOGI issue and strictly
> less than a PRLI issue should be put into device recovery mode upon
> RSCN receipt. Previously, the allowance of LOGO and PRLI completion
> states did not make sense because those nodes should be allowed to
> flow through and marked as NPort dissappeared as is normally done. A
> follow up RSCN GID_FT would recover those nodes in such cases.

Applied to 6.6/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
