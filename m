Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C49D9EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 16:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjFOQYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 12:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjFOQYO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 12:24:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79E21BDB
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 09:24:13 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJglX008844;
        Thu, 15 Jun 2023 16:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Qe+Szw+CLxHobJPyj/Vf4EELMNEjXXbr0vpgWNQ6TpE=;
 b=v5tpwc2D4I5fv+uMRb+uZGEo/4hzR0BleS4PT8QW0yLataqPs2JFo3aEjA24/qm5JDeB
 eHGe2cZ3ICHHcJnHDyz+P+wWmSEoymBzy66AMN8r144ZRQ3XG5INnNml9jx2OoycUWhb
 Hl00FA4yVcHyBI1ELoorlbMjyT83wU82PTrGma4EJ2VFS6TwKaf0Pi9rBbE+Yfoc2vh6
 riEX3BNjsjiFe4mdytS+9lpY5NBZk+DTW8GQ8N30YSxUvn0vFHqndvXfi1LVH5gouYt3
 Cwt+3x+yWv+kxD+S20KksGkupX0jDk/LEzpLmd/mkCm4ajKrT6FyIuyMCeNeBCkds93t iw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h2atckc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 16:23:57 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FExL6Q011514;
        Thu, 15 Jun 2023 16:23:55 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm765qb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 16:23:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nok6WXUVp8RypJXM2kZr1xpQYUFOAt0O3nay6A6mpFjfJqJclHvQFTOzSs13Ufzcqa3jylP2thVpQR8JiPaoPba/ZDDP5NTDMV2GbW/aFmmti+Kaehu7Of2T9+G5hValhZOTZe4KdHWNsK0+mXxk7Kx+jnsbiu8riHrAfM9Vv3tceto7ul6K1X/n1106T4tPIKkthdA+AGBkXWPzt/LsT1hoJIxTaKqqf7KunPSgE/q9qCfRn6rM+nTcTylAN5J1KYIngwLKWW5srPBoe+/LjxekIuHmkjJn+tbIwDIWZLbly9E0js9M75QQ6e2rpHNyCws9epv1tV9h8hYor2gTYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qe+Szw+CLxHobJPyj/Vf4EELMNEjXXbr0vpgWNQ6TpE=;
 b=QI2FMs/U2nhqmfwiUpPqDqv5NLIlBgyGQj3pXFQy25/7gy05pVDV+QpLZFfF4ltCDGZjZ1miHidOXLx8zRZor7M7t1KKs/de9mPUYgzi4hKHFP73TRnNaf06KFeWWmECbdaNxuGcngBZ72nyUR4bWDv4ETkNbl2gncmI24oDrPRI0PnACXXARljr+iCcYd0J1cx8HbtJ9GMVPX1hvIqmfuEQFrkeWPOcFZqRT2CakV6+qQP1mHjDYiEzXpj9dZ32CSu10cK+DPE+e/de4dwW71P9weV+PfBe6+vwJ1U8vgn2bt5I+gkQbHULZJNWyLKAx2TzNV1u55TuToaPldzdpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qe+Szw+CLxHobJPyj/Vf4EELMNEjXXbr0vpgWNQ6TpE=;
 b=Lzc9zYEgCPnOTRElR0zOG3mIqcXzdw3bYeLz6PNk4edeVNp4lcm3neRkcAl2Ko+HONUvreGtqrktKkiYjn1EZE3bmvzjicaloaXPoW5KTtvA7aCru1yd+LZgncLuCXkmMyGaDLN8Klyn7CoCWKfrGtRHWMSwysgEIQlAByg8Va8=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM6PR10MB4219.namprd10.prod.outlook.com (2603:10b6:5:216::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Thu, 15 Jun
 2023 16:23:49 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6500.026; Thu, 15 Jun 2023
 16:23:49 +0000
Message-ID: <6dbd8d38-9dda-55a2-4c79-9999c262e5f4@oracle.com>
Date:   Thu, 15 Jun 2023 17:23:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 09/33] scsi: sd: Fix sshdr use in sd_spinup_disk
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230614071719.6372-1-michael.christie@oracle.com>
 <20230614071719.6372-10-michael.christie@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230614071719.6372-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P190CA0056.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:656::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM6PR10MB4219:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a905984-25c9-4643-ceb5-08db6dbce63a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z74bO0gIMr3mI7lHB9G+AcHXE7iYLX81ZIP2jIe98DQrmAC9JFgnd2Ms8CITb1h3zdzubxvCXJvW/TjQhhMOdv6vAhtnSSqXNVLqmUMQ/SHXpDMH5zaOfel9G2tnQtw7cESrqOs1Yfs8GyeNAYsbYVZWLP9StSSmiH3M+t8am8D8dnZne0BcRNTpbIozaZW6uSFL2HxMhoeJhrtfsDt0jgGh9aBYX7hUH+h8IgzDoTDdz7mfbelSLwd8qEIgt7sR2WuwyX09QsB9LkVMCAkZcNnbYc7aDDpcJn1r+Cf9JZb550gfIFTtQinuEuEAv/yngEyWR8+tj7jDUsX8Rf+/PH3UjUMUPcpUam34/5KfpAnWzuP3UyILWZcendKc0ced0lPkIAnBoOSiGAWCBQc8C61EUPqGVj0xeZ/L1t1RVad+GbBzdOZQ19YOnnx++DOu0mT+tlSk+IhkER4YhzybjjxqOqEb123Vumao7n2Kk/xCcUD+BaghoSv/AeuWjRDg8b7z+ORiQEChcW+dKlb9GGRR4OACUVj3bFP/uXb+fIFVkbPhP2csyEBcZmSXGh2CCSwE/l2sAoDiFYSBz/y5LbATP5c2qgdMIoyWfwt19LawPxl5iQBfccYvMjBWG9dqmor8OIyQXCUmm9RgGLPdKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199021)(4744005)(2906002)(83380400001)(2616005)(36756003)(86362001)(31696002)(38100700002)(8936002)(8676002)(6486002)(36916002)(316002)(41300700001)(5660300002)(478600001)(31686004)(66946007)(66556008)(66476007)(6666004)(53546011)(26005)(6512007)(6506007)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S09URExUMC94QlEwT0pZYmVTOE5WK29UK1AwUnkwVmJVenlENmExUlBqcHR0?=
 =?utf-8?B?VWp3WDVIb0tDWDhraXJMK2ZvQ1ErMFRSWUpMaENZekRXcFVxYU1Rbnd5S1dm?=
 =?utf-8?B?UmNhZFJhTGVEZ0ZybEZMQWI5alE0OTBzazRWbkNnVlVPTEgyb2o3YkxlZWNS?=
 =?utf-8?B?QUNwMUp2eXgwTkJJcUQ3a1FyaDFEdVp3WXVzNEJQZ1RjbHZEV2FUQ0hiNjg3?=
 =?utf-8?B?Y3VONFExaER2TkxwdmRZS1loM2lGTVBHa0VkQ3dBaDlpcEpEemtZYllpcFR1?=
 =?utf-8?B?K1JkV2ljWkRBRVl0blRhbkNVTDR2a0I3MmExUURSL1J4L2plNllaalFKYk1V?=
 =?utf-8?B?aFRYRDhQK3RWTkp0MWRFcmgwQ0hoNFE1Wll2Umh0djdIVjhWTDdmaHZKZk5R?=
 =?utf-8?B?WGJaTzNpUUswZDE3SFBTTG41Sk1PWjhhSDk1U3krV05tbnVsS1NmYmFXaHo0?=
 =?utf-8?B?QnJuci8zemhiSTk2ZUUwQTRyaVFsYi9ZWkxSN1ZEQzVuL3JaU3JmSld4M0tC?=
 =?utf-8?B?ZS9RczE1dTBlNGE0WnFYTUZNanRtWnpwNW9aNVJBRWY4NkpjaEdiSi8xTlFG?=
 =?utf-8?B?a3BXa0hNL3d0TGV0czYxZFdGTW1sM0tObVBrd0lITnFaZE53Y0hlMXBRaGxn?=
 =?utf-8?B?K05od1RUbUdnKzNsZTNXcG5oRlBiNzdnbG9oM1hRV29lelpKOHBOcXd2b0hV?=
 =?utf-8?B?TUoxRERpVWQzNUlkdGIrQ0hENzB6c1JBby90L1Z5bjBQeHdlQW15K2NqMGFT?=
 =?utf-8?B?UUh0aitYV3R2ci9rdDBYdzRRUHQ5cnlBYUtYTG9LNTVPRlhzVWNoUjhYUThM?=
 =?utf-8?B?R1ZXcWd2bndLcW45QkhXWjRVUjhob21FY0dBSWZSa1RVNmwrVnJEdk9wbGRt?=
 =?utf-8?B?U3FOWFd4RU5rSExUVXZEV2RvMnVFOXloNDJZOWg4VFBld0VjTDB2aDVGSE13?=
 =?utf-8?B?S1hOWFcyVEhjTEV4bzNoT3JwNmN2YzhWUzlraXh0dFhMUTJVV1NXYTJ5Mnhn?=
 =?utf-8?B?cllUaDk2Y3E1VEZCWG9FLy9QSGM1Nk5jbE1KUXEvWnI5NUIwRitCK0Q2TDFJ?=
 =?utf-8?B?N3dPcFQydG5tZG9pL1dXVGV5R2tFanJCSFdhcThzOUVOMUR4dnhkNVBmeGVa?=
 =?utf-8?B?cGVYNTg3WXlHcW1OYlU1a1pGaXpueUx6aE9heEFxVTdTT0kxSjR3bXlrWVBX?=
 =?utf-8?B?NVQyUEVpOXhXRFp3NVlUWktGS24yTEd2WHJSUFZjVFB0NTAwNG02MGVJbVlN?=
 =?utf-8?B?RDFIRlkvY1VQR0EvWE5LcEJDS0MvNnhiYWx0alZMSVBwN2ZVOXV5dEdJQTNH?=
 =?utf-8?B?YkZpTlRkUHl1a05MaEtKd250K0l1THZ0cVRhU1c4NmI5MWExcjZSRFFJWkRt?=
 =?utf-8?B?NTNNUVdvR3N0Vk1tZjVnblBJeVdVN0szZlNEcnVVRk5NVmFRanNpelpPU1Zs?=
 =?utf-8?B?Sk9randkZWgxL1VQVVZ3WVBubE4rTUQ1NThQaDM0Uk5FU2diaXd2M0IrMUxD?=
 =?utf-8?B?aWNqTjV3Y3pLVDB6NmY4dm9aUGE0czdJYWJDMENENEZMTmIvUkVXZVRDN0JB?=
 =?utf-8?B?VHk3Yk1tdktHWmwzRmJsQm9nTFZjV3pidER2V093dm9nVDduV0NKWkdVSmlZ?=
 =?utf-8?B?bUdydW94RCtvWWExaU1NVVVHZ2lxazdrL3h2OVZadGF3aEVncTJMMGNnZEJz?=
 =?utf-8?B?NlBSUDgwU1djTDBOOUlETTJVNWlGRGJtZWYzbmdRbFRrTlN0SlR2cnArT0Zp?=
 =?utf-8?B?RHVPVk03TitJTFBhcmJ1NVl5V2pjUDJ3OGplTWcycmZMZW1KdWdZYzNPVzRx?=
 =?utf-8?B?cDBmOWNqSldrTnBJMTRpWWtHbzYzWUsvMnNwUEpseW4wR2hMZXRoWHB2RGF1?=
 =?utf-8?B?NU1Zc1dFNHVKZGJQYTVNT1BKK3Mwb0JVWitkUFVlWngyeDd4NzBMZ1F2R3FM?=
 =?utf-8?B?d2RlaGc1eGJxZlI2dm9NWFZxSW5pRmMyUk4yczJOVlBiTUNtSTVyUEh4YTd0?=
 =?utf-8?B?Z1dQMERDY3hRUmRFMm9majhCcXhGbVd1SXg5WFlZTjFvejBQdXFEYUw5TitC?=
 =?utf-8?B?YnB0ZS9DSHIyaXY2a3RNRkZaY3pCbE9McElwVkNvZnM1Y1A3WkEwSlp0b0ZV?=
 =?utf-8?B?UUhxdWZQZzZmZk92ellhcy8xWGQwdExORFhPSHAxN3lSbjY0Q1pvVno5SzRI?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Uxp1/EdR9FXTF+GjzJ+eH1iJcOsA6pDS4KvO+fgL7RqsfnYWhD4nsAkY0zo16GJPSQN35ZW/B4L5icN5wUNWeYActmOdjesMx4UG1a61PksrmzmA6CKKqsToSn7NOWYqSYd1HsDaLoX4SldITOS+qKST47WdDSQ4k7FGoJYcQVE+4D3J8ZKlmoQ8gzCkBn7p6om3uefTwxJPWNwN9ytSZpM3wnjxYrFhySw5Hg+C0Fz1Q4Om8mmDs9vw5vhwf6gESJPE4jIqdYf3PHfcmd/U7en728AGjpjQ55iv+gLT8PX+E3PSl1SHXJu47tvUy2Bym10O6gyAgdzWZ2lNLc4TxuivgIPo06UqnX/gkZ5NoyHxCphRswdoZPD25JAdQlXBtMaNvf3zc7hjxCgmc2CUdp68fblNxlvi3PNQ55O3OdoC77dHUBWcAL6O9Z5aTL3mIfmrHqzp02d0dqUiMZiM6YmzqH49aWtSVdL6NqxUQhqpXe9e9EVR2SoeJbsfhfoeIytwsyOoOE4UaZFgEuw67XePmaghK8cgWcKCkQk7lGqTPlReevh7WS1DPY/e7eoLFsJeKZ4Go2ghLzhjW+MAaN6tnCWxfSASUjpDI8JnCYkSKwi8Ee0dc8BsdzXzq+83yfZvUVJxIpdss65bb5Zx+EOAcl589ZzQOlmthFb9lUdYwNdtSRSTgAqDMFmCgzNawZ73/99hI3NmBiG3dSn9znvBKT9JTcUsS8j7iSeGqI+zhqM+tP3ixrbtHy27qVWidl7HsqJKsq6RofJymo+ufeUaA7FSRBBZ7o7JHA5/ism/8Gkd226xjdtY0NSPchBOiv6bk+QaZRg1bHxLAZeyza4RBphxCMDlc/hK6lPe36FFgMLVlzbmAJfnUZzHWBMC
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a905984-25c9-4643-ceb5-08db6dbce63a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 16:23:48.9538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4sRY+5cAydYINgj4O33xB4EM+RpQV7Rdy7XgtwXWB/8H8bqcWZGktkWIdUIYwlh3RcDaksyLJqps9tg8cGSIvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4219
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_13,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 spamscore=0 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150144
X-Proofpoint-ORIG-GUID: wRQOPu8e_6sflLwco3CMWVcKhNNrvT1a
X-Proofpoint-GUID: wRQOPu8e_6sflLwco3CMWVcKhNNrvT1a
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/06/2023 08:16, Mike Christie wrote:
> If the_reset is < 0, scsi_execute_cmd will not have set the sshdr, so we
> can't access it.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>

On the basis this is changed similar to what was mentioned on 06/33, the 
FWIW,

Reviewed-by: John Garry <john.g.garry@oracle.com>
