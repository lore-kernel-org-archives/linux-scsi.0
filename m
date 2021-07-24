Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B756EC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 922D160EB5
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 02:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233747AbhGXBey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Jul 2021 21:34:54 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38536 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233487AbhGXBex (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jul 2021 21:34:53 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16O2Cs0T017408;
        Sat, 24 Jul 2021 02:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=aRXHhfKtY2qV+IVZIKghG2dKEVY2jYGQZISFK+vCtealxuq3ey/OQ7VzVM95PVxWNhRf
 IajykBOmR8Nm+VFhKoSMRUwrT5x11Z1Caed98hiQ9ot3x4k4dGS8di9UZNSA6ktRR3iM
 2W43CbjB51bR2/YuvMVgb3OyYVTQpUudBc1a//WtKDSb+UxkFO65jxB1g/zB/caC061z
 iQOvDtz2I3IbYFMAvcOMewW3wYhWOPKDQPWsLPhFhKKRT7A85urAqa925/dJj9IjCVl3
 m0zE15n9E4TvnzazMRPFcCcL8PXP2Wp3DzHS4CHA67lWpA0drTj0hEEIgFTP3sdpqSKI 1Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=Nw8OhkboAxcA5O//e7oZFKAk3C6XyU8TAXcZcconB+IWvK+umbvg9aHRQEpiDxA5fNfX
 DFrzR+rmHUOZQs5+02B6Y9nGE5JpxjYir0SgSvArfGJtkXlhAtIEXGFUZkAgr/Y+ZBvI
 QPKa3W4LKOvLBmlHuY1r3zz0M4z0Dc8Fm8fBlZiKSwuTC1pzq1nshE0zFyO3mRYtNQdc
 rDuKwsSLbdtGCHhD8TgJIahmrXvOIdGJJnnpMOq2ox14+DVkYNGLVlzZINEjvg8PZoeD
 dVOn7/VshJm1C41fKO9TpMS635OjTVoLJe+j7VkQhipzM5Ancv85Zt8dA68Jlf2eITXh qw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39xu2fwcy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16O2FGIe188119;
        Sat, 24 Jul 2021 02:15:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3020.oracle.com with ESMTP id 3a08tyt6fg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 24 Jul 2021 02:15:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0NLiDUtqYimmIGIM5woQQ0qiC6zFFDflxy4OhA50Nq+XByaZ4GD+s3Ue9P2HGAzPEeMwntS/TrawFeseLupNmBryw9JcBjCB7yi6mQccFK8fLYVWOIm9eVXuVz81LZN425tukCK+duWY0aONf1kxYuNAsQdCOShM4iX0ScF59yPAawEmqePbeC9ryELemb9jndyLQTaWHC/9cfxIoJFrlw15U1NmKLXxhOOTmRj79Z9CeH/LPaYPZEd8KhOdg6sYO72ayQb51hwuZtLmdKPtXMDCqhDHsqAq1Ta1hYPgUlJzH6VJM46nD1uXAvbyhMXun6FrZU9ZIF50f7uuKBDAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=NnRM1w/Ui0R1BxoaVhm7tulCutqar6NCOq/EKEbBp4g3N7iZzpsnfbvVPxpGPZnvmvVYpooJ3QmhDohK84ODIaZwWIvcZvWN435jfGs/Am9u6F18t5K+cERBvPF4QqnN/Nkhy48VX1wb/o+vzVklAdpltUsrmUeEgCs9HHq8X/PPVpVzKC36LwZ/DvKoYeAbFnqHQq9T7K7gDPv1K1bBq9ysf6YCcf2o03eZEpz/m3xc1nLfBpNiOT22WSvilem458xq6MhaK7cTU5u4Lr8zLfLv6nkaS5Rm3gxwMuBZ/ibvs3qJ1lgdUBqdLQ85R2g6K2YIjrybccUtoCkG9bt9kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbBYHL24MU/sBLvuv271kV3McXH6nwuiaa8Ud6gw9Cw=;
 b=wZ37L0FLI6RjvFPvy+iw7lnp+mHfHH6ykH4GaH56dqgrBwo/OV/hj8pOl2IJjt6zK5UpDWpkQIqzkP/eRKzgkYOLlvank80V9G6Z4rN4V+RG8QeOXjltq8jCRErfJcRtKfUi8svUbyWs0+jh+39uCUv1Q31uJp5O6ojLWJvrD+U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Sat, 24 Jul
 2021 02:15:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.029; Sat, 24 Jul 2021
 02:15:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: libsas: allow libsas include scsi header files directly
Date:   Fri, 23 Jul 2021 22:13:56 -0400
Message-Id: <162692235524.25137.3112362667915281683.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210716074551.771312-1-yanaijie@huawei.com>
References: <20210716074551.771312-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0501CA0023.namprd05.prod.outlook.com
 (2603:10b6:803:40::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0023.namprd05.prod.outlook.com (2603:10b6:803:40::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Sat, 24 Jul 2021 02:15:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3caea860-de9e-462c-5145-08d94e48de38
X-MS-TrafficTypeDiagnostic: PH0PR10MB4647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46472F667EC64BD889B3EC9D8EE69@PH0PR10MB4647.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xv4/CgnHh+Ei9gi74ftGJvfnFaEPV7K8+FoB+sH759DnidTq6Ow223c58uQanLZEjQj1rSwc2zABCPx3dPfNNZX5qZ/DwrAaOatB2FyIFB+t4UW7iAfEBX39b5OutgHJRdBPTUCno8ePBq2AqF2mKvi9skk0UEdqD5YFVCfWlwVe3U0yV2IYwyUWhWYhFQN7wqFIYvbJCj094BYY420QRtYcRxVrELyhl+SP6Ci3ESKLFOrkW6Xgb6pLRqS7OaL4oppXYekdOZJEGaBNnmqVNrJr4tmIP/Mc6Z9qNRHD3ocD/0zQGgwDVkiheShVa8JCmaj6q7D3yi3pmzvY+Ze6PhUhAhAYtGIfiuvdqH8YAkHvVOAJpP/OwfVckcK0S7W21Ogdfw8RinBCSf1aAHoKU/gE4pJ/KJEzKFFWBnNye0lMgl2LHB04H5k6P4xk8LWie+hY0wpmXsZTeD95X+nSEhSlChcfd10cDvQrPzU+wHulA3ylOtDAHud0n0rDdnyBNmk0KtTqcU5+5ppxglOESHuFH4JRvdOqpighSWcK7p4jgaGGPSVRb/yVEcG//kkYJQQZIaqCW+Q2ja+OYr3aXilBMym6Wl7lM4wiZ/H/3YQ0BgLIjFdj96r422JGV9sYe1+1v5iqO5/LxiLagK0fjbQccEYsXVw/tSIR/HRpLGOTLgxV3OIcT66oNjwMh/zW18PPNEq0yFAkyejTwHg7B1TcyUbkNINbCG88yhk/zj4VfZdg2fiBfxzviUgCz3rZR7+axrcHUAaS7PEd4VH5ZW8diEQ0CDgubc2LAUPpBKw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(136003)(376002)(366004)(2906002)(6916009)(52116002)(7696005)(54906003)(5660300002)(4326008)(316002)(6486002)(4744005)(38100700002)(478600001)(6666004)(38350700002)(86362001)(956004)(66946007)(966005)(66556008)(8676002)(186003)(103116003)(2616005)(66476007)(8936002)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1REWUpmRDlaNmx4OHUyVjdQTVJvemErUnErVktvTjgxcjhMWDhWWnllRDhL?=
 =?utf-8?B?ai8wdE9GWm9uZi9aZlNGbkl4bzBJaDZEdzFnMEdtT2c5ekNBbFJ3OXR4VCtn?=
 =?utf-8?B?MG8vWkczOWYwWElwblJlNjJmbGh6NHROYWs5cWhWY2xjZWdvZGEraWtvcmg3?=
 =?utf-8?B?bkNKc2xzYUNhd2V4ZzB1dThXbVIwL1czZVRWVEQzY1pjYmN1ZEE4RHVkdVRm?=
 =?utf-8?B?eTUrcWpPU3hYR0dFSUsyYVJUWk1WSjRKM0Q1T3htbXBWcG9IU3ZGTnIrWXQw?=
 =?utf-8?B?QXBiWGVoRG11czdOUFZ4K2VTVXBzRm15NmtqUkwyZWVWS1BKR0dhUWdrejFG?=
 =?utf-8?B?VXJ4cFFsMnh4RXNML1RoLzE0QWM3ZUR3NXB3K3A0TGFGNlRjOGIzaXgwMWdZ?=
 =?utf-8?B?RWs1YjFFZ3lBREdzM0d3dHB6WVZiRmc4cjJzalhFS24rbEorblRMektDZ0E5?=
 =?utf-8?B?OFNvVDhZMENTYWNMSGVLNVNzN1MvQkVBZ0tENkcveGRyNk5JRXp3QXpnMW5I?=
 =?utf-8?B?ODRvN1ZYQUZKVUpYM3VBTGdJV3EzSFdncm1KNStYS3NBWVp4Yjg4VVZxUzJs?=
 =?utf-8?B?UWNUU283NkJLTHpzeVowdElIMmR3MzRmMTdLWjZMcHBCM1hQaU1EYWhKaHRm?=
 =?utf-8?B?QWJNcFFvMXgrVVpJbkVYVHVSdFdzWm51VzlxejBIb21nQmZnbnJjTFJkVzBO?=
 =?utf-8?B?Zk42blZnM2FLNFlaVk55TW0zRVAvTjROT2pKaXpjeURmcWV4Wk96QTlyUHE5?=
 =?utf-8?B?eTdDd2VHbXc4WWVCU0NPL0F0WlkwTE5uOFBJUnNQcEh0UjNneldnWTNkL3c1?=
 =?utf-8?B?R2MwNVYvMjZQMTdMYTUrQ1VFVno5RWVBYXIwTzhwbE9IdkhNVGNScVlZdDlr?=
 =?utf-8?B?L2RJeS9EYkMwUjMxRWdmbzdlaVoyeit3amJwb3BhTXNEMmVCWFVwLzdSc0Z4?=
 =?utf-8?B?ZGU5anpPMzh2ZnV5UjdtUHAxSEFNamVyWGRGc1M3cEo1YzJOamEzUnhRVzlp?=
 =?utf-8?B?Wld4TVpuVXpoSFYwT2xwK3FXUUFUVEY1UEJ4eUlibXNjUnlsZWZtN21BMStI?=
 =?utf-8?B?SUw0akoyMlcyc2U5V1F6Nnp4aFdUcnJ2MTdITnl2ZFVwRFNPamozN3k2aXpV?=
 =?utf-8?B?NUc2d0Y1K1JuSGFjRTN1WGdGUHJaK0lONDZNODNXVE13UGl5amZtMVlyUDY3?=
 =?utf-8?B?eXUvU1B3YUllS3hHRHhvTTZ1TDZFSmx0SVdUbm0yN1ozL3BQbzR2Z0tKdWFU?=
 =?utf-8?B?VXhuWTh4QWt1dXdFMUpwSDBsVVFqMlpEejNPUFJ1SGFZWGZPRVNYQWdaNnJO?=
 =?utf-8?B?OW1sUVZlODROdWlwbzVza3pFYStJQkVFMGlrNzBic2JqSWtuTGdiTnd6U2VH?=
 =?utf-8?B?M0FMMU13QkE2Q2xFOUx3dFNWRlFOSzZ3Q3JuTTFLb0NvbzRzRnhHSzNzUTJp?=
 =?utf-8?B?MU1OMDJBUnd6ZjhCVTc5UW9YUnFvQUljQmpLY0tPUE51d1BNN0IxQ0JNOElV?=
 =?utf-8?B?VVArWjZYSnhjOEwzLzlScFV1VWl0NU1ibXFxVjRPOXR3OStWSHJmaUlCbDl2?=
 =?utf-8?B?Yks3ZzBIcStSbklZa1FKZkFDTy9hZWlJcU4zNm5MOHdkWHZaano1dEhWZkxX?=
 =?utf-8?B?WVh2SlowVnRiREg2Z3N4RHdsV3NuZ0dwLzBCaFRSdGUzRkJxdTBrWTFSZGpM?=
 =?utf-8?B?QWhiTGEyOUhGZkNMWVVRVGpNOU1IWE93T2tQWTJZRVB3UHpaSUJUV1RIMTVY?=
 =?utf-8?Q?5K12cPkoi80OrF+JOTDUPj7bo9GX24dop8XcCkU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3caea860-de9e-462c-5145-08d94e48de38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2021 02:15:12.4571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yTT7H0j9KGbJ9kaCIxy4QISiGmy5m01feucnHuqMgpYbRSZSJhXmGNvNgj1jIQbQ3x6S4AGq1JDnpVh7lvlszJNwQre7kzUy4tdwa0Ts8Wo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10054 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107240014
X-Proofpoint-ORIG-GUID: mPZgk3spXrYN8q2E4rV3Fkk9FdE_kT6B
X-Proofpoint-GUID: mPZgk3spXrYN8q2E4rV3Fkk9FdE_kT6B
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 16 Jul 2021 15:45:51 +0800, Jason Yan wrote:

> libsas needs to include some header files in the scsi directory. However
> they are now hardcoded with the path "../" in the C files. Let's do this
> in the Makefile to avoid the hardcode.

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: libsas: allow libsas include scsi header files directly
      https://git.kernel.org/mkp/scsi/c/e15f669cd996

-- 
Martin K. Petersen	Oracle Linux Engineering
