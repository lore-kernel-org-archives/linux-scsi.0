Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31704C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D7026127A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 01:31:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFHBcy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 21:32:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45858 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhFHBcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 21:32:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581Ux2Z191472;
        Tue, 8 Jun 2021 01:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=6K23I9Dd8ydEPxoeZRWRLnUclGkfG390OzP8FmTKSbo=;
 b=GEWjA/0JFVEjA69XSLOohYyvJEvN39FE9JZN3Jxl4S6woKqwrF3JxJS+zQHBD5cWeLwM
 tmXfOVm4x7rJamAehBa9xZ1G9yoL8VN0O2rcatfsWw/5F2LgAxB8pJJWWhSZ2wrTxNbH
 b9OEz2xhrT8XUHSJlIbItMxEMQAjYFlrYU1kj73HtitbnVmgKqGj+7w+dLsDNfRmiGpZ
 Lv3wRoS+cu17CY6P2xcSY+mi4406K7dGxPtZPPVTjTw5g5R3yqc713/DYaM/ahDubWYb
 uunt/8j0fSDWB5K/Hh94Fom78eRy6CWylnbDJqkaINENRrOObCr50gUTmBYqUFqtZ2Sn sw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3900ps4fv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:30:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1581UJBa036606;
        Tue, 8 Jun 2021 01:30:59 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2172.outbound.protection.outlook.com [104.47.73.172])
        by userp3030.oracle.com with ESMTP id 38yxcua2yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Jun 2021 01:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eIvKQNiPxJLPGTtLMQBD7Yxc+ooy1vPqx34V5lmtrFL+JzyeeIkv2fylxERLm5nwBbgn5M2qpyrEhSdjkWQuzTU3wyOou+YHgLFO9A0Nqq19tL/nFFNP+yghDuoo+ONYRGeKs7Td8/4hGudZWZ2Qjp4MmL1AtNJF+UXt5PuB24vbxT9vYSKsUgUg/8sKoKFSvh+MBm0kbyY214CbtIEP48EEb2z19z3p3yvwsuSPi4hAve1RBhZ/MuEQf/dxEvLOH2f/w5e8pFQEHUAIR52t6Tw8Ct4mqjb2Js/SgEBFFMAwcEh5vnmmwBfnqARby+Z1OLtphliIA2q+nOtm8WfIUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K23I9Dd8ydEPxoeZRWRLnUclGkfG390OzP8FmTKSbo=;
 b=HnmNDyjKhTzFotfp1PuqnN9pvdTRg0h3/V78uF2YcUe4wEApDi2ldH1k45wLbL+NLmBL4dzBx8FKTbIh4KAonK3vFNiDUyV8hja4y6BeC4hybGVvnThSopiBo43GlT2QCG8nbjWLEqCEBM3ZGg4kNaABmPt5atP8nBb8QWYcHedSszartSbm4OQKpjsN4k0mnFCJfF21QhlVOpcvvqe7KRXOCUmmfnlPfLHQSNxDlZH5QmEqkCwKSA9/ZQcOgLzMaP/acwtTrmKdwjv/+B7OZcTBYMNQ4QN2o9DrlfdLZOUscU0d9qd7CgOmDyTGknCC0Goxn+ouCEpZiMApyiG9Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6K23I9Dd8ydEPxoeZRWRLnUclGkfG390OzP8FmTKSbo=;
 b=CZZpvBRcNeoe3W+XbtF9uPG2vkqOUMj7cmKtnug6gZO5KAdI4BdyeJ27tqQVkqiWr6Rju48BJTxP4s7CWlIicECbAvHVZ+eUzhdqG7MfCyQ8fts2vWXDALe85iTICI0L2tMLLYIWu8hKPsw/rKwna0ln/kZ9t6QPg0PzMX8G8QY=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4631.namprd10.prod.outlook.com (2603:10b6:510:41::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 01:30:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 01:30:57 +0000
To:     Javed Hasan <jhasan@marvell.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH V2] qedf: Update the max_id value in host structure.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czsxkurj.fsf@ca-mkp.ca.oracle.com>
References: <20210602104653.17278-1-jhasan@marvell.com>
Date:   Mon, 07 Jun 2021 21:30:54 -0400
In-Reply-To: <20210602104653.17278-1-jhasan@marvell.com> (Javed Hasan's
        message of "Wed, 2 Jun 2021 03:46:53 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR05CA0023.namprd05.prod.outlook.com
 (2603:10b6:805:de::36) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR05CA0023.namprd05.prod.outlook.com (2603:10b6:805:de::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12 via Frontend Transport; Tue, 8 Jun 2021 01:30:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f44da9d0-a149-40a0-bda9-08d92a1d1080
X-MS-TrafficTypeDiagnostic: PH0PR10MB4631:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46319C72BE839B813FE5B0C98E379@PH0PR10MB4631.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D4cZCq3GpneeWow+Hjn0xB2NtZxccyDRyBLlcDOdPnGVAvx/qgN2Mlxq7v4+CMnSP2BfeESzVWWlmMHclNqNXZl5nFdhHnYDKaw1kTTPUGTU/5gjL4bqDCaU2IW9F+8eyFWovfcqSZPnvmJZYrlOe6g/COdMfYHLhFThEbZqUq+mwRoJvOeT4cKCEtqvBfvIHeZP0yUnIFQhZWuMiQAeQsc+LiGM45t6Zay4zzxT+OjgUVSEg1kBtZ1J1GztGDUEj/FpbqYFmRcngXeNCX9ahgFZ2GR7ZElmfm97Xy+UQGDJlatu5xHDbcVlYak7rRb33S96/RSYU3Zka6zWagkvKgAyqGc1f9n1hqa76iSxT5jYFcYst9juuyUa8v49KUwGZBkYSMcHWSYhxeuB5/Kfp7RmU8LKWVDQkv+47eLSQ4aAm5YesRqPOtvOGIinWXNwiDYBIFdeYH5IinEVWbgDjGbFKDKqavSvHa2Xbx29kGDeNn05OTaG1EvKq8jTp4+cF48IrmK8wMGvCvBqFU9tHg6wJc7NzvxjbnfRdNjDNFZyiCKZO8Z7YFsiWh3iU162w4Z0ldbRZl0cr61i8F6WjVKgoQzue/wLUX7f1b4GBMWQHH7DqlhZ8V+S2hSPqcE3vNyURFtf9ehsNrYHU3xijQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(376002)(136003)(396003)(346002)(6916009)(16526019)(26005)(186003)(66476007)(36916002)(52116002)(7696005)(66556008)(478600001)(8676002)(956004)(55016002)(15650500001)(54906003)(5660300002)(2906002)(316002)(558084003)(38350700002)(4326008)(8936002)(86362001)(38100700002)(83380400001)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OCLyB4SUk0a7slNu42CsOxGxDF6vPZIZm4DOICG2baou/Zk5d759bLOB8wqw?=
 =?us-ascii?Q?RttxT5YhUZOGQhLmgI+M+jTjBH7WrC67z82ZSrTP0sG9/pC8nRM3Q5zrqN71?=
 =?us-ascii?Q?6e1oklWC2ASjcqP75v5pQI0vWgeL2yUBddUPe+okDV3jqzahFOFtD4eu9Lyd?=
 =?us-ascii?Q?Z05GCZAVgP12j8yqldDPCGjI0V/QEEbSZpB+SEeBoD5B9GYYqQkLyCdRWXJY?=
 =?us-ascii?Q?v1LRZxZcllgYs48VuZYQsxp5db5V1ToVG0hDX/0N6LOiGQazBi4mcCUqvrrQ?=
 =?us-ascii?Q?/OVoDBcQrRh1ELE8s9m1iw244EJliKYSmUxKiZItkN8Kkxozt43a+LVaS2BT?=
 =?us-ascii?Q?HkjwNGjS6eotNI1Q/EsW3eTU9/2qch7Tr6GNcMY3YVbPD7RtczelT2yIz+8U?=
 =?us-ascii?Q?blOAbKu2zYgS/CGIzCXCHDMy2Ons6KSXTdCqprvN1QC75+fE4vfaERfnuzaA?=
 =?us-ascii?Q?t7fSxIRdLDqg03P8aIW+0dTFbnoP32dnaVdCFLyCvpeMrf+yjziGNF3bD95X?=
 =?us-ascii?Q?ilHjuaVW+B3WLxLrcFjSkHrNFo56VmDQvIEQybWzu0osRJZbef8yAk5KAiJV?=
 =?us-ascii?Q?3nxxZBDt4SloMsoSN5dwSDykuH3WRnOZFESwKaeMuyMnBWTX5f2+mJn639H3?=
 =?us-ascii?Q?wZV3Awp7G18qZwBjx/NE8p8QFnDV9ezqQaBQoFo+yXo2cGHkeVn8AU/W5pUe?=
 =?us-ascii?Q?O5vki6ui3VLms5BIbSG5mLK7kosBhI2+37rg+wJFReFBZEK/zMw2yiTGc5gN?=
 =?us-ascii?Q?XRrjUnZq0Zw2/PeDLWkj8jW03GBzTQbgjl1HydTeKp1T0IiFOh/NPj8jhifU?=
 =?us-ascii?Q?J8JWya6FkflkY4JI2+gdYY6cyB4FBEMXkZ6r8lvZB++t6n/JvEL8K9yqiHrV?=
 =?us-ascii?Q?HW0VoBs1BCywwWYStqVW0GLsDEqHmMDEMRKNj6GI/E46lCpYDP+Og3qTzyF9?=
 =?us-ascii?Q?9LWfbzxCTN8xCtEx1YUY42M//ZJ+ectraMxlkH1r7gQ0N4C4G0gE8TARO1tl?=
 =?us-ascii?Q?/l+lCUOWaiuBZl3cod1db1eH9HkWqbNHspQYHQN+l1hVCD5OQ7x+4veHp/iy?=
 =?us-ascii?Q?isz6tT7ZCtG3d7DX7ppWiem4I/EWv0WzNNu/+0zWtGeGwje0KSbuVOMfx5WP?=
 =?us-ascii?Q?cpQ5zyXuuUoBsWi6ULMNTQfPYaQfqts0n7HRR09cv0lYeagt/pazVlNoBcgG?=
 =?us-ascii?Q?kaf4IvA8BFM4p1WdBlmuFWEgP9J3dZ9PkX47UOBGfrC22izD+M6qsWIikD6S?=
 =?us-ascii?Q?yPXYwTdGDRV5HmmGFrEYam+7GCEAPXWSVbNWlkPNn9Tc/hh+c4D7IP/Nrwbu?=
 =?us-ascii?Q?eBQP+aFb2S9qPIjxJy13vcaR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f44da9d0-a149-40a0-bda9-08d92a1d1080
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 01:30:56.9792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dYGVkHVCiQb/r9Q+Ek/U2S3ZugRg8VvnU6k7+XqSEoRavIr2i/BFY3YWtbbxtc98J9afymte87iiBiSgRWha3QUTTU3Qq2nBeVGeM1X9nBo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4631
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 mlxscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106080007
X-Proofpoint-GUID: __J-NgX4uFYEmh--QeG05kGEq1VUbvu3
X-Proofpoint-ORIG-GUID: __J-NgX4uFYEmh--QeG05kGEq1VUbvu3
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106080007
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Javed,

> The max_id value defines the max id of the target that stack can scan
> during manual scanning through scsi_host sysfs interface.  If default
> value is 8, update the value to the max sessions driver support.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
