Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1E26C43381
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8046223AC9
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbhAOEJo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51850 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727936AbhAOEJn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F44IsI022543;
        Fri, 15 Jan 2021 04:08:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=YiL2nZLYHt7KXoVwnnqAL3A9iVR9giPGUcLOkqMKr1s=;
 b=KdnSaHYfoyMOgEUqysUyGY6dU19GuIROWV0clcB+mFoKDYjSdJRsOwN5IuGRh9rhX6AQ
 sFPo/faNMQYmXFgXk0xL0sIs7hipjtnagWBfBMgTlJcXihrlizsnWjqo/3uCNGWSa0PD
 bjvRu0kU1JrBxrGftTClc0RDg8tOv6BDcl1VrVyVeCp/23Pwf2t4ysOCLlvsluIJ66lO
 eZNaMDMsCLsOLJTw66a1mySlFuZaGFORDd386IEXi6fkGEgzPV8F6IRaIYXJLOjrNn3c
 23KiRWEwBObUJY7of7W8jdVMo1NV8Hk57iusN8+jaSiaa5SJS/aaumbhgApOKZnYYR+5 gw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 360kg2398m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46eXA094901;
        Fri, 15 Jan 2021 04:08:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by userp3020.oracle.com with ESMTP id 360kfagp6r-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+HxX3+pEgNhEXtZecliQPl0vmOxQN6uGtHgfpUtQDCfTuY/NdVyMSjW8X+9HIigPk4ovYUwrNkMgTcK26W9bsO71WGLLMitqH+o2jroaDshUyQ/tTGkRXMc+EF7DJR+4j5Hjy4qUDR00shwCRBjV5ahatJwmD3oldbD9+mwy8xE/vrWtceg2AJuTnQ2tt+PXUeMPWhLPotHYr75Xjq7dxlTfQayryqSaewoweOME+ofxp9jtgxptaLUtjiR0SMJEtkESlwF7guGd5cR6FMzxDf0mXRHN9Ng2/kvtT8T7sGNCIBOhpoY6572LoMlPPUDz/ggB27zTe02Xdw4O+QGUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiL2nZLYHt7KXoVwnnqAL3A9iVR9giPGUcLOkqMKr1s=;
 b=T3kyauB2pW/0Io8wmJpPh50xiOggEzt900Q32gKyntjK8+e3deca1VV1LYEUS5nPZqun+xA4ijVX7uzjNUYkApyC8bdohUIGzSVNIzTc+dP+8DI3RqqX6f76kgmGSdFWGvibUUdbneKpWm69e58pe2MyNle/GVYJIELvyn4PCdv1CyThWGWKQhepgZfkR7QMjXGnCD5/5gASi2whVOwG8pgS63zWklYHx8aA4uqjZ9hGgA7rhFC8cXBU292uSw6pHOdybuf0gfJrBgmbNCdpLFilZOzyjjQURfggblLQbxk4Ft928GTSYXnv0App6nhaxYHs/GXszJxbkiPNwebsvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YiL2nZLYHt7KXoVwnnqAL3A9iVR9giPGUcLOkqMKr1s=;
 b=SrBPfMXZE2rzXvQhEtio/VlS/4EOZSs/BHJiUpD3m1PkP+tXxHE24l6MhoKqWVJhFSljo3pDgOpJ4eP+ao9dx/YnkJIoNnpL4UthB9smA0BoRxMi/YL5KlTwLXar/PD4Bqx0w7ZqHJB7EGSwEYYyCDH+p6xlzpYxT+6TTAjeHX4=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     ebiggers@google.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        shipujin.t@gmail.com, Bean Huo <huobean@gmail.com>,
        avri.altman@wdc.com, satyat@google.com, john.garry@huawei.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Bean Huo <beanhuo@micron.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] scsi: ufs: Remove unnecessary devm_kfree
Date:   Thu, 14 Jan 2021 23:08:24 -0500
Message-Id: <161068333185.18181.5939894363923891007.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112092128.19295-1-huobean@gmail.com>
References: <20210112092128.19295-1-huobean@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34be5c1b-0b68-4a55-b65e-08d8b90b4029
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB456862E13A5DBC148EAEC6828EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: paVBY0tx3Vi/++ew4pn4bURwxOLpPTOwFc6NZMYhI6fbPuT88ZcYPRR7NJ0MmMH4m365UM3DJaAy4zBOq1ZW2Aahi3eDFCp0OYwRCZCJpDZttOYMZmwPl7jWpo4bq52elxqLjiyv7PykFqf8g9Jl2gQ9j25TwSX6V8KO761ZXzKGxw3SBc4h7eqZs0rlwzD0n+Earcux05Zk0umKRoiDeX10oRMFaNIT9vskPMAEKnKIstjW6NHm58H4njZyBOjLSP/NG5PXNYgqDgOX6NrCxm7PLclCEsn3A/Gb4PZyczNM1Tj68Jja3V0suLflBBR3u6SQvzTMKhsu11oNKb9OwetO6T0BHZfnICFRVrpm8vgJLN22OaafSc/gRGH+zRSIIQJKEo4Awk0cDSPkNjpwJgTmpaZvh1bFWLzfEqLPHKnN9sR0ECv9Ye02JdEQooQsTpeDWvv3rIMyUkeOFY5/0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(54906003)(36756003)(6666004)(316002)(7416002)(4326008)(83380400001)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TXZqOUJKMHdaVWtGK0Nob3k3OXp6aDh3ekIvczNBQ0ZmUnpUMmxjZjdTMzZ6?=
 =?utf-8?B?VXo0WGxTc3hmUWZqRk1qbDhMNEEzMmtacVliVno5Smdxc1RTNFNONEl1YTF1?=
 =?utf-8?B?YzAzRUg3QThvRzI4cktoUmJ6Nit6dFVSQTdQdTRxNE5Qa2ZnQnlMZkVJOEl3?=
 =?utf-8?B?RW81MWk4djhZdTJwWERPZUNCeEJDa1QzcW9RQUhkcnh2Z2N2VEptMWJVK0pu?=
 =?utf-8?B?NmJUSXh5cjNxSHVRbzB2MjRhRHlJdE9XYnI3Vm5jbzU3TWFXdzJQVE5aSVhG?=
 =?utf-8?B?K0tiQTllaUJoa2lIdkZ4RldrWm04ZXpFeElVWGtoVUR2ZHYwOFNEZTNQampO?=
 =?utf-8?B?aGYrWEI3ekt6SCsrWC9IZ0VVRndMTzU2cWQ2Q1lKSGF0VklzQVN2Qjg5alpC?=
 =?utf-8?B?VmNxL2t5UEtkM2ZUWUNLczF0K1drWkJ5cVQwQlZUYkFFMWlFb0VsRWZ5aGNa?=
 =?utf-8?B?YitweFVpRm5Lb3hkc09BSHRHcGNkVHp2dm8rR2t5VWpzN2xjN1M5V0hnZm5h?=
 =?utf-8?B?cFlRK2thcVJ2ei9xc1VVRDlZaFpuS2NUOGpkTFFXNzN5bHlIcDhBQTlUSWFZ?=
 =?utf-8?B?VHZHcmI0b1E1S0d3dlFtQ3JtYzZ6MHlaSE42SklueFNxZTlmK2pKNnc2S2Qx?=
 =?utf-8?B?d3FlUkY5bmVzdGVYbFVUQkpRR2NHQ09MTjh3eGFaUnJUMnp1MGc4dkJHNW9D?=
 =?utf-8?B?a3k3ajdGVzZpRkpHUmxGUHJQNlpRZ1loQWlhY01ZY2xCb1ExRlM0Z2pReVlR?=
 =?utf-8?B?NFlNdnhlY1RrY08yNTBKV25XT1UyTUlHS3J2UEJKRVM2NkNxSENxak9ETjBj?=
 =?utf-8?B?SXVBUnB5STRMcjhSWjhJcEh0MlFUdU5iY1hMOXYzZWJCbGZ4eE0vbXYrUEhy?=
 =?utf-8?B?dzRuY2VacXJxckpXbHhKem0wSmpVWXpwNHhJVkk4Wm5EVlk1dW1sNG1TNXpi?=
 =?utf-8?B?ZndvNFNJSm4xK2V4NW5Jb3Z0eForcUpZdjZPYlJTREJ4M1hVc3E2R1Jlckg5?=
 =?utf-8?B?TVdFUDRQcHpDNTZIc3ZXdmwrcXZqeHBSbkVPSHdnbnZHMXpTUVNKWExxRkxM?=
 =?utf-8?B?akRNM1U4RW9PUkMybkwrWXNWRDlUSDNRcVZPSDUzUTA3ejRBU3poMGwvcmgy?=
 =?utf-8?B?MmtNSFI0bFR2aEROdHVrZXJCa01HbUVNanpKeld3TTI5NmQzWTVyS1VZU291?=
 =?utf-8?B?SVkxbzZMQkFwVE0zd01nU2NWSFVUNFFGN0tjem0wemRNbG00UXc5ZTgvaXk3?=
 =?utf-8?B?K3EzZzRlNEZoTHpKK1JqQm1JMW1kbHFsaXRhVEFhM0VqNmFmYllQVzN3ckoz?=
 =?utf-8?Q?g7Focna9WIIug=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34be5c1b-0b68-4a55-b65e-08d8b90b4029
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:44.8206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gM8WL+Z4tlwWl1MW8KOL0QLBQEF/munIUnYmHvx2fQXWvfkIouqT49qMmHZzqy+XdIUkwIH7DKx7T2ygLe6PqpmZ16ZhWPkSJOFs1/yIruA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Jan 2021 10:21:28 +0100, Bean Huo wrote:

> The memory allocated with devm_kzalloc() is freed automatically
> no need to explicitly call devm_kfree, so delete it and save some
> instruction cycles.

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: ufs: Remove unnecessary devm_kfree
      https://git.kernel.org/mkp/scsi/c/b64750a1b65a

-- 
Martin K. Petersen	Oracle Linux Engineering
