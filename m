Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2469EC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0903660E8B
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhGXBfK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:35:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:56334 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233724AbhGXBfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:35:09 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2ClpY006595;
        Sat, 24 Jul 2021 02:15:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=pW/RKvIkR7TRZJcjXYenEW9G+jtnbALu3QyCLs/C4Nw=;
 b=j/1Sk2QF21fZ7FW4l4sVmY2qrMSCLDrM18tilkuZUoVUcc+PaZsQeBsC1xbt0y70THyq
 qX0CNN/eg/c+VdycstO1xxsYND/xusB9IwLuS8ySNtimjkz3JO23IMWzCy2JkRhgAfrZ
 P0r6S6AMxedEy6vBLE4I4AJ/O5bJzfHxagngTqa5F2J9sspCbsvGBN4bH8YkcN4+pB5O
 b7ZoXz2SnFuWZizCkiyhcMboOW2UQfKOMZ4GhdtxresqFkT+Jwfz6EeDDMVZTe2UGUGm
 zXw+SGtgtydBT20YKwCbkTi7p5wG6GaY4/DiMKECJcDTmmdnCdKnfee6eYr6gGxYpSKD IQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=pW/RKvIkR7TRZJcjXYenEW9G+jtnbALu3QyCLs/C4Nw=;
 b=sM/xuyJHAOscGKbUKFy/b6kBs23Vbp8GXedb0EuQtWRwAykyBG07i3Q33E44ZqX1H5Rk
 GWoOGxV+VkNJYf0wigtlTNPSP28yw/Cf1einSoLIkfUxkzZJDKOxf42xGEi312OZPKTq
 +VFpMGeQziLu5KlUZsGaK0lsM0jAOuUzkjn5hW3XNEp/WospxLJFLlF1a0dR+FASW8lj
 8luOC9klH+XpWcW0pX8HlTHjMDG09HGNJHMgLh82Rsy/IfldhpqSzkQtnTKSV2mG5bT5
 jXUiW1VqIzJhFWVQ/Y/vthZ6M3KKo7Iq4eaG68mTNFu4f2pB/GxPLWTxfHmSRP/ZDbpZ dA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39yj7fjc1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O25RCO188061;
        Sat, 24 Jul 2021 02:15:06 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by aserp3030.oracle.com with ESMTP id 3a08wb21ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CvbwxBK/Um5NH+1JCp9K1JZrXZk7fiUYHWceRmX6sFan7+pNxIWfNgGfgyCb52XIDHRdr15txtD5pev4Vb9UA1gQJz9MmmS6T5j7zJ+UmlkGeJn1cwneflbqnWKVnNXAaZ+S50NY1B9ZrAcZvh29R1nkqoE+gXlApC9n42R5dxmBJKrM17jXFHQ73le3hHhCpunUcwdb0N3Lmzk5YL3TnUQKpF4ixaLktU05KjVCslehjeH3+zdp+iS0fTCKFYj7fPax/PJvVRK9yAz+JFjNVB2ItujmVP4s8HJFDemLIvKJIXhQYp+sv1f/nCjXiVfeqL2Bk9Vi1GriZL3LOlNnpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pW/RKvIkR7TRZJcjXYenEW9G+jtnbALu3QyCLs/C4Nw=;
 b=W+9Z5TOMpa6VrDki2zcCvoq7BiNR9GPY00wro0qu2aHbp5xKQKUdE5aNpUgNFymaFkrwWPL2QAz3TDhqDkN9YvSPko44Yj1C9OGi80fFG4Q4htq3I6K23l8okGYrefy3OnD4KW7ta9QPh3jR5T3GDKV9YcKObVoPbQ+AzBeWghozp5qVfOSJLzyt9XGqgbWYGdyatzvSGoKKpHBzpExnEnFINIqNHxCqOcvEGLcqrtJ8WFzzJyqnZv7BZrAgop6+RKSvWzmTx10vW6eL9y3uoIhCdH5BDNb0jFyAS+9puK7kOke/E1sekfRM9VeUfiiHQhJus85JoofY3nJT9Ri36w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pW/RKvIkR7TRZJcjXYenEW9G+jtnbALu3QyCLs/C4Nw=;
 b=cfyPaxl0zfys+urO2QGicL9i70RG1pqT9inH80zq4pfqM/OV8C+cWdse2dbAnR3KjORE9j2qQMTmwHQXgjKMCzSparJ6nLXqs671Eu/7rPR4Gc3jxqRVUBIEucYiobE545F3qu2gKa2LPTiTEmc2Hc4vecB1hJCyyskKccBQwMg=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sat, 24 Jul
 2021 02:15:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:15:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     hch@infradead.org, jejb@linux.vnet.ibm.com,
        Don Brace <don.brace@microchip.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jeff@canonical.com, pmenzel@molgen.mpg.de,
        john.p.donnelly@oracle.com, mahesh.rajashekhara@microchip.com,
        scott.benesh@microchip.com, scott.teel@microchip.com,
        POSWALD@suse.com, gerry.morong@microchip.com,
        Justin.Lindley@microchip.com, murthy.bhat@microchip.com,
        joseph.szczypek@hpe.com, mike.mcgowen@microchip.com,
        mwilck@suse.com, balsundar.p@microchip.com,
        linux-kernel@vger.kernel.org, Kevin.Barnett@microchip.com
Subject: Re: [smartpqi updates V3 PATCH 0/9] smartpqi updates
Date:   Fri, 23 Jul 2021 22:13:51 -0400
Message-Id: <162692235524.25137.11282428808940131954.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210714182847.50360-1-don.brace@microchip.com>
References: <20210714182847.50360-1-don.brace@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Sat, 24 Jul 2021 02:15:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce16c651-f978-45b3-a04f-08d94e48d989
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46476C6B7EDBACD4D520E3A18EE69@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: flWjZHnRXv0fH167PORgdBtXQD211mZ4ZnZkdtSlDWqXO81bLf46S1iTWp/dkMnUQGWGNEsHFVpux/CVYthbKbwlcmCK7G8YX7zCvCIleZcGcepz/uxEu4SKaQkwVFACTHGwHhzC2idYQHAMKSW4IY4boHYkdWgxtf4cLDKQltMlbX4VLFWZxe/I4SdWxp3v6/1N7FEjixjoZJ85qJNLIaVjkPvPh/n6jc4NvgjpLrbdXwIQr+XenLHjEBFFfJzVuQjsySCkg2bnC6qDU6zmb1jfxYqTSp/lLIscrq2E3EtZP6/foHtIcSMbq3Rqg5AoC/QSo+3hsY22MMKrqqyaTESNWlQMDNTWgyU4gMmviF66Vs+rTeXkpVhZ+gZGlalfAJRwm3fONlw1ASkweIYDD1gd+Q2gYsCmrlWlzfkVh3fXwK0RB6cCk89d1iJ6fY20RdnxqkUzWjRiW8GiroHFpnZeCyHEWknc9JSYmgL2pIOijeCwO1OSHnmZya+Lej56oJtCQE9LJ+G7V/XqojdSP3z9bziFNLuH5ydg8E1S675463PL0ERR/ogUJODu5JopriRdsZEQfyCNeZ6j5BH6mQVmh8hRW3+yZmZvMGWnrSuiVdsyHNvMyQileIDAS5K4aricsVZJYPV/QQSf3EBguDiDM4JQBhctHyzvyxX+ihWx4+9O39bIiGlJX83FLtEHgqrZOw4q389wGYZLioTCbzvl9aizzZDQTou1LPGSs2ps9ZHuY/H98XrL6uX7Cmuz0cDI3TDxSNVCpjgkpIGBk0Oxm4tnuLMLjk/FAbILbQHjVjNOGo0Hucw5+GuRa/6/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(52116002)(7696005)(83380400001)(5660300002)(4326008)(316002)(6486002)(38100700002)(478600001)(6666004)(38350700002)(15650500001)(86362001)(956004)(66946007)(966005)(66556008)(8676002)(186003)(7416002)(103116003)(2616005)(66476007)(8936002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm5XZ3NCKy9Dck8rUGd1aTY4aitXczZLOXJ6a3ZHM2ZhY05VNldlY2RrRWJj?=
 =?utf-8?B?K1k1ZFhPWXJZcTY1MFNkVVdSYk1Wd2d1UW9ZZFdTb0hEMFJlL2UzMlViNG9r?=
 =?utf-8?B?aTgwc0RUZFpkU2JWcmQwTlhLUElhS3gwa1oveWV5Z3djZThTZURSRGRpTzVL?=
 =?utf-8?B?NXFZaHJVRlJ3VG16cHRLUTlGc1VsYlNDLzc4K05PRFhBVWR3YUhETWdzcGhh?=
 =?utf-8?B?MWxyTWxTS0I0VHNDRjh1Q2gyVEd5SDN3TTBVdHNpZCtmOTZHYWdHMDdiUzdp?=
 =?utf-8?B?cy9CQjQ5MzdvN2ZzWmVNZmhqM09uR3FBaG9RSzdOclA2Vkt0VFZYSHBMVVov?=
 =?utf-8?B?dWhJUmtOSm9oTnFlbUdKdVNMN011cUNOOC9aeit2eENCajk0MzE2Y0UwWmxa?=
 =?utf-8?B?ZVpnYm9pMXlEYU96Q2dPYVIvdU5HQjJGN1hmaEZVMVB0M1M4cGdvODBxOGtk?=
 =?utf-8?B?UEJrcTlDSXA4S205alVnRmdkaGEzbzkyeHhLOWczbVh2cG54MzlJbXk1eG9G?=
 =?utf-8?B?dGdSR1dsbldtNm5xY1BEcUZHV2I1TVlxVlY0Qk1iT05ZRjNPQlJpeUxaa0VM?=
 =?utf-8?B?QkVBWjlQeTdKT1I2RFFDQm4yNVVJR2EwSVd5UjhKWkFkdHdBdDQyNU1vUGJ1?=
 =?utf-8?B?VEsvZVJpdHdhWE94MEpQU3cweGlJREdmQjlkOXdDSkN5WVlFNTBISGxaR2NL?=
 =?utf-8?B?VWxqZmp2c1NDSlh4Vm04bUg1ZStxREpQQktWclB3VW80WW14RUlLUTk2VGlr?=
 =?utf-8?B?UGNTclZ2RWF4MWxOSWRBQXI2bkJzOXhtWGszUHJPdmQzWVZYa2NqblZCRklV?=
 =?utf-8?B?dlJ4RGNMTmgvWjEraXV1R0tYc2x5YVA1VGdaSWZFd0xoNVROZzRxYmo3YkpE?=
 =?utf-8?B?ZkUvTG1HUC9PV0NrdjVwUEtCVjRISVF3VUxFVkcreXRMd0VISUIzejlHb3c3?=
 =?utf-8?B?R0V0dnhVOGQ4Y0hRZ1cyTEFvb2tJb2Q0bVU3U09wWmNldmgzcGhhdXgzL0dD?=
 =?utf-8?B?ck51ME1Tb0k3UEtQeUJmMGFmUmx6YTJSRVZWOEVsTllQOFMzdFRnZ3JqTHNr?=
 =?utf-8?B?RnMraWlKYml6ZXJCOGhXVWRidndDbjBjcCtiRFpwV082cVBrZkxjV0VmdUhB?=
 =?utf-8?B?OGQ5N1VuWjF0VjJWK2pXUnluRlE0RmJSM0xRR0M3bWFuZW9KUHl4REdlSVM4?=
 =?utf-8?B?N2VwSmY1cTdkTzRjcDNGVVgrek9iSDlYWmVwSFpSZFFiZVRBaGQwTEtkUXBH?=
 =?utf-8?B?Yyt4ellEbkd5ZDVGU0ZBRnhFTWJMOXV6cE9ZM01MamVMVFRpK09XUS96aTVQ?=
 =?utf-8?B?bnFyTU9PL0orQ3RaeGZ2WGdJNlJhSzJNZHZ0djZrTFl3cXVyV2Y3Ump2TG5P?=
 =?utf-8?B?dm9rM041ajN0enZ1VkYyaUlqUGFlcEdFYWxtcmRFSmdEM2I4ZnNEUVg4QVIr?=
 =?utf-8?B?TnZWbHFhVEJuNWN0VlR3WUowWFlNVksxbk1sS2FlV2Njb2loRWVZbEV5WnpH?=
 =?utf-8?B?ZWh3MXZ4MnphT0ZrU1dOMFVPMGk1cWhpbmRaNHVVS1JYVTRxZ1NYUGhOdEZr?=
 =?utf-8?B?UTFReWhkdUNJNGdUMkVCYVBnUFR5dE96M3Fxeko3emNncGV4Nk41WnVaQlNC?=
 =?utf-8?B?aHlXdUE4K29wS2JLM2JmVDZSa0NIOHoxeGRWRS9VRzFLS0FaSHBYTlYyOG56?=
 =?utf-8?B?bUdXTFNPeURaU1djTmhWU1AwVzZxOS80azJzRzZVTjRHTEtOSzEzRXRQOVEz?=
 =?utf-8?Q?yTBwmBxxQqWXtOGXTc5jDY1XkgaBnfMsSYo/Nx4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce16c651-f978-45b3-a04f-08d94e48d989
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:15:04.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zS/r0K43N3hD87g0s0JoPgheiFfTg8vi5XCZ9SLBHz2CG52JKV2Mx9lGhAG5uQAwZmYrmCbN+R5lYhjoGz4xeYxyL2QHVGvd/A/kGivP8Ok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107240013
X-Proofpoint-ORIG-GUID: Tzx2xbR0Wl7gayTFrRWbiwevIOXrz1j4
X-Proofpoint-GUID: Tzx2xbR0Wl7gayTFrRWbiwevIOXrz1j4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 14 Jul 2021 13:28:38 -0500, Don Brace wrote:

> These patches are based on Martin Petersen's 5.14/scsi-queue tree
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
>       5.14/scsi-queue
> 
> Most of these patches consist of adding new PCI devices. The remainder
> are simple updates to correct some rare issues and clean up some
> driver messages.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/9] smartpqi: add pci ids for H3C P4408 controllers
      https://git.kernel.org/mkp/scsi/c/d3af3f647bd5
[2/9] smartpqi: update copyright notices
      https://git.kernel.org/mkp/scsi/c/889653ecfc98
[3/9] smartpqi: change driver module MACROS to microchip
      https://git.kernel.org/mkp/scsi/c/6aa26b5a2c70
[4/9] smartpqi: change Kconfig menu entry to microchip
      https://git.kernel.org/mkp/scsi/c/8e505fceaa2b
[5/9] smartpqi: add SCSI cmd info for resets
      https://git.kernel.org/mkp/scsi/c/f0e473e0f603
[6/9] smartpqi: add PCI-ID for new ntcom controller
      https://git.kernel.org/mkp/scsi/c/e326b97c92cc
[7/9] smartpqi: add PCI IDs for new ZTE controllers
      https://git.kernel.org/mkp/scsi/c/09d9968a8eff
[8/9] smartpqi: fix isr accessing uninitialized data
      https://git.kernel.org/mkp/scsi/c/0777a3fb98f0
[9/9] smartpqi: update version to 2.1.10-020
      https://git.kernel.org/mkp/scsi/c/f339c7e491a8

-- 
Martin K. Petersen	Oracle Linux Engineering
