Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE01C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:02:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CDDB2070C
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbhA0EYB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:24:01 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:39078 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343518AbhA0EPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:15:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R45ASL013933;
        Wed, 27 Jan 2021 04:14:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=vRz7j6MX7IWxtI2Vukjx6dFWlfO1wKnDuXNWy8aWxdc=;
 b=byWaRc5f9QBTaHjWs55aSzL4TPaRFVW4WPSAUQjgW1Ds7WZwomXwPLNrqg7/E0RVplYI
 nUaP6cKoX41dDOe0PJ3TjHQO1SLcDl74vkGELkNf9dHxpSCgTg9D5ipTvLtcicQyyO7J
 WXkP+lxO7D7zU8a6+EUygIO+9dsoNDK7PkceLpXG4cYjEtRWe8QO/sL+qtG4CGJRrApK
 S36EV01BYB6pOKQMq44X0Qz6rHTHT71xXG8QdiIWffTErHJ20xBGgSKoimW/hXKJlXnn
 sJjZgW5HvKt2DV8HzAcYlBwNGxL4EMaXRy7G97DUzsgR6HqnfAbSXYeRLAsPS71rf/Ec tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 3689aan977-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:14:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R45eMX094297;
        Wed, 27 Jan 2021 04:12:46 GMT
Received: from nam02-cy1-obe.outbound.protection.outlook.com (mail-cys01nam02lp2050.outbound.protection.outlook.com [104.47.37.50])
        by userp3020.oracle.com with ESMTP id 368wjs1a59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:12:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeNO2xzlRj+LNZ5cEQw+O3oKyxX09hgx5D2fY6Jlxk9fLsTYmLOO/PCUcjBvqDL/Wey/SNsjwgjBRMpEWBbHpRqSY8F5Aq6qWH6fhVoN6/iZS0MyA4d3EuNdW1dsYkGaToUIs8n5QU1qifEkc13OV7TgzwDTJ3J9Bdhy3u+XAyqQ0sgEk6fkSSpDvEwtlgE2xvQdzHCaTcA1bM8V/u9qn77cuh/86wqrxzAR1724ICZx/PwfBDvQDQrY5qgBD/4DG+LWfJnx16enGqEn3CfXn7TGM65+ES0USf/wzV6g3tX24FYyI7zSUrE/K7vS0OSEASNAgUOMmyD4wwSusv6IEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRz7j6MX7IWxtI2Vukjx6dFWlfO1wKnDuXNWy8aWxdc=;
 b=OM05E7s//kPwuJMSaLw9e5eDfG3uDf6HlQElseQ8RxPohs+l5fNsNESLsrM+v1I0LhEsLOqDQ1VqO6X3hdULXhcGUJLjbtrJoNhlozbAXmas4RPknUQDIvl7ZUX36a+QE5wZRp1ZAh1a+cZTzIuyj5VILLrjRq5CBdPIkhby98FQx7UGd4luExcQe58bpQweglMD6cWTmyV1DzjzOPJ+NB0uB8rRFT9VpwFDAhzIMcycfQEuRmvoPNYFFCEpsaKTFlMySsQiAPbgJTE58km8ZagL8rxkVCbBBhYeWt7oOsFLhby2bs0Hu0rcFuQVS3NSLQgKUxpd8LzL+EGf4wWmjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vRz7j6MX7IWxtI2Vukjx6dFWlfO1wKnDuXNWy8aWxdc=;
 b=blzE7G9I77OWsRFjWZvOLkYbgnufN3TevbJRiFBxWPb2MtXOH5O/U0PVns+LR8wPY/7pBQU1uEc6xBGVNuRWZSImhT3EWjCpzGfuMcCg7TvsZNdBdF7F/zSzynL0Ox3/mtgeamkxTn1C3VJKusNObLEZhGpbaNYO25R70LFN3ZA=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4742.namprd10.prod.outlook.com (2603:10b6:510:3f::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.15; Wed, 27 Jan
 2021 04:12:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:12:44 +0000
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>
Cc:     <martin.petersen@oracle.com>, <target-devel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [RESEND PATCH 0/3] scsi: target: Set correct residual data
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im7jqaq9.fsf@ca-mkp.ca.oracle.com>
References: <20201203082035.54566-1-a.kovaleva@yadro.com>
Date:   Tue, 26 Jan 2021 23:12:40 -0500
In-Reply-To: <20201203082035.54566-1-a.kovaleva@yadro.com> (Anastasia
        Kovaleva's message of "Thu, 3 Dec 2020 11:20:32 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR04CA0100.namprd04.prod.outlook.com
 (2603:10b6:610:75::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR04CA0100.namprd04.prod.outlook.com (2603:10b6:610:75::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Wed, 27 Jan 2021 04:12:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ee6d205-a714-4ea3-2fbd-08d8c279cc11
X-MS-TrafficTypeDiagnostic: PH0PR10MB4742:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47428CAD8827BE561E1480D98EBB9@PH0PR10MB4742.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C21d1E75eRrTOtBxIuC/1NUFXr1BIBiO0YkWi3STN+ySw1LatgVQ/W9YYCTDoCmsw5rx2L4klOonQolcnSWt5giorHh3wwspoAhMtXNy0GfjT0u+oNDw1i1qECJULaozKjmKa4X1mNkcQcNc7i6Wn/2vxbev4bv3TB1+aF7e+8VaTFEVR6iyjc4Dpg7W2D8WBjr7ffgmLKmgBAZtNg/fYbA3g8PNcCrnQHnMJlCW+IM2tzFQta1UFApvFPSuNPrAXXEoBk5NuDkvuyslZmid440H0b/DA/waRaNq4pKmoDOMiZqCdmMidnCv8BKjZAeWHxFmoQsXGnyvqcxDkUS66wp72dfCW7qGWNANW4u4LNYztKTvgzWCjDxZMyn290636ZVPTIn7e3WZ8/mfcz97QgwUA5hk7UWlkux1RTrO5NC+ZSLRbeAVw4KgmWwwo5eq1QpfDMlzV4m2dzd9IILFS6vBvY7ulp3wCCHIJNbBVODmieKxv5DwT/rcA7HC54uIHIIt1/LQ4LoFifhwhtsmgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(39860400002)(376002)(136003)(86362001)(478600001)(316002)(36916002)(558084003)(8936002)(5660300002)(55016002)(26005)(52116002)(54906003)(7696005)(956004)(6916009)(16526019)(66946007)(66476007)(66556008)(4326008)(2906002)(8676002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?63Hus5SKBCATFYU7g8dewouKxQWCIhvYOKTcCasJAivzBVWZbmBdK/6ahvAQ?=
 =?us-ascii?Q?XKfe4UXJTEAgA/Q/y06BhH38PK9+rXVukRnvJgAhTym54O9ciUuBXbn5jjUC?=
 =?us-ascii?Q?SRyxc0SxfJIX6HDUbu78zI4GwvsNwAssSNPImPPwo9Xr4+xcyqZyj7R7pOix?=
 =?us-ascii?Q?5aefF1fdRfdKPb6KZKXAev0WiQuc3cUwlbASfThNrVRFbK8FHoXE+E0Tq69T?=
 =?us-ascii?Q?/OMgARJmXxjMGtMMsy1h/0aQLsC9v7S1h8Cl+TWkxL85ISiwU1+Cj/ESTQbk?=
 =?us-ascii?Q?A7jG5PBDJVTpwIH1AqIXI3CK3hYn/IU23nPYg8M0J1LMLn/GRbIB6UZsplk6?=
 =?us-ascii?Q?vGcQYzX1ewOYJ1VxzkTw0yhPKYuZ2n2+fqh2RU8WwRePG00Fa1ZwbomGyOOh?=
 =?us-ascii?Q?Yk8fJldpyivPWtlINA/2oP0s/Kkb2HGiDDITp1EpZ5PsXB98088x3BzjSLfi?=
 =?us-ascii?Q?FxbSw0lWqo8Fvf0T6FQnGpB6CLyXe2t7/EYYItXafzWSuws/W0Nmmkv4jqpB?=
 =?us-ascii?Q?kZz8i/scxyIZps4UXqwKVmPB8PqVl4kUUzCiEs1hugLVCgD+NqR25t1G+qYz?=
 =?us-ascii?Q?S9U4khY6QAzxAtTsccfD7OcS2x6Dj3hR5tzuvqf1aavNNL/tSlFOM/tBvZCb?=
 =?us-ascii?Q?L64DBP9IVVp1WuPvlsdz1ePzrFIIW1Ilv1g3c7KqVIj34Z8fPvy5KpuX4sm+?=
 =?us-ascii?Q?2KVyhBsU1OsDkJgrsU6suTQ9m6mYkTDMIbF/2LtQtVhTzF8sxnVcGCNlFhLd?=
 =?us-ascii?Q?FCeVknCuoxsvHBJtuP91cTgw69xpHh9mfFGcQBuazIQOcSdnIyHPQhxxMC+Y?=
 =?us-ascii?Q?36XNlQf4IYIueiUPIgZnc7WMrWcIKB9wiAelF0Arc/9QOaVwcEQfwsgcHbRV?=
 =?us-ascii?Q?dZz/oribIHR58muLOTsrqqoW8wldM+pQtDc6imqQHYC2jFVxoGKSedCAw0Pn?=
 =?us-ascii?Q?qxWnrfXVOKjkIPd3hlaKa7+Af+3Fx7ntHYc15XSZCSKgMJzz2kKUdTgIdjlY?=
 =?us-ascii?Q?vyZIPpsrJ8vEMPN+Xr9dH+LV1KTF5Q57n5CR1t5DijgwaLLRdICbJHqTFsrt?=
 =?us-ascii?Q?gLIYeYRn?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ee6d205-a714-4ea3-2fbd-08d8c279cc11
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:12:44.4868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96qbrUcbtiRw1FATAiZI+ja+LJd2AKpUzu2zzQLKSlbiKXCtbcDaynZ+BVPWdumsYKxc/szo35U2V2kkNMUGjrVWaIf+thvXC32AZ1+d7z4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4742
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1011 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Anastasia,

> The series changes the behavior of the target in regard to processing
> commands with overflow/underflow in accordance with the standarts.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
