Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462C5C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 01:50:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 295D060F55
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 01:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbhJEBw3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 21:52:29 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:32186 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229606AbhJEBw2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 21:52:28 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195188YJ019448;
        Tue, 5 Oct 2021 01:50:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=PP7YqCJ8yw38lDI7vsyH9T2BuPMwFGHq6p+N85h2zt8=;
 b=uRFq4XlzVqh77YEsTah6cBSUykJObLrFbf4uCCI4YnbwlQMYTj5d3kD7wfqilZIShIB5
 6o17hN973vMoMl5lRVhMhbN717XH/ae8r26CaDdx+EnIJS3j6lXlwsu87BKEXnBoZFRN
 bFkGTPZD93CVEdmlCyxZQPObyuqi1kbE9lhYo7VZ5kI9VTzSJ63sa2ZJd3Kdemn/4Ew+
 X10aANbnYjXEXy/62KAVBhFX5eDIbuT5+e/AIaB5yCe74IMn0alghSgQUtqr3aNncCI6
 YdhL1XPiAIYkoHbKJVSebTBfWRYBsz/8jNTs7uT9g2eEj3+KF/KosyArWMdk18AwOFoa xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg3p5ccbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 01:50:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1951id1K008367;
        Tue, 5 Oct 2021 01:50:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3020.oracle.com with ESMTP id 3bf16s9yng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 01:50:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=guyRO1Q9Yz8GZMlVI7ObWUOG+40YGmMZ13vSH6LaX5nyj8Q3Zs5+FUZJhcDjG7sngvShIOzHKDeMysf5sWstaPXtW/MMw/0Yq/RmaaMQwo7NhgpztN8X7QyLnmJ84v9lRJi3AP6sIzVDod4DA5Wd9I6RHVAtOs6HyqxNn9N5w6GrH9Sfk1wZpC5hV9fH3xmuCrGI9ZjPmUzc/7g3EnI56uLD3DDKskICQdDIoN/DhdO68B4dkbASNrZ0cljeWsIwf0SgWzuLO7xV+85Lvk0TWYdEuT1wHnVfGZStyXkgDSFrsRX7dLc1zdMApnz+egdmAlx/FoQEWc1xzB9HmEsk4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PP7YqCJ8yw38lDI7vsyH9T2BuPMwFGHq6p+N85h2zt8=;
 b=SrGYh5B4aWC8RX+fCObHcTuzq6jfNZDxgZif2wMejavwB6eQOqMIbsmyZSDgkvM1DI1hSUa6k4C4x0xegnAyMAY75UtFnZY5QqDgx/E3yboqyOz9GtB29D3c2ocLsxFDR97eMLpBqSqlqrMSepMIAMow7K/A3oD2p2e5W9hf1US7pD/RJDlk171EMAmfEtHwTdcBWcQttzvVZv2BM2nTOyVM/t5+sSUCKjtDiXEYhdpuM9/psJnrDu6J3r74Wsyl7s3AFzxI2PrXJEH5K293BeR1P62ktAx6Q3IaRKsdi9rqPH1RkAXN6L0slaug2V/JamNZL+yZWWQw4X9kcnQmzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PP7YqCJ8yw38lDI7vsyH9T2BuPMwFGHq6p+N85h2zt8=;
 b=glA7aHQK202byIJVF67nNjVtL3pyaoDTuWS8m12kmiFANLScErNKwiTNUSqA4gjnOZGqImRaVoCB9Y9A1hVmViUeHKK7bmdtT04WR9psoQeW+MLZUycis0s17szFKQuR4n7CyvjKxMYZfGzknGujKeZMnhEHUNQjbxHydn0hNlI=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4501.namprd10.prod.outlook.com (2603:10b6:510:43::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 01:50:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 01:50:21 +0000
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, daejun7.park@samsung.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/3] Two fixes for UFS
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1r1d08cku.fsf@ca-mkp.ca.oracle.com>
References: <20210929200640.828611-1-huobean@gmail.com>
Date:   Mon, 04 Oct 2021 21:50:19 -0400
In-Reply-To: <20210929200640.828611-1-huobean@gmail.com> (Bean Huo's message
        of "Wed, 29 Sep 2021 22:06:37 +0200")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0601CA0023.namprd06.prod.outlook.com
 (2603:10b6:803:2f::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by SN4PR0601CA0023.namprd06.prod.outlook.com (2603:10b6:803:2f::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 01:50:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1d3f44ff-d6c8-47cd-4ef5-08d987a27d78
X-MS-TrafficTypeDiagnostic: PH0PR10MB4501:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45011C265115CE1BFF7A6FB78EAF9@PH0PR10MB4501.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0wnDuNPngl9yQ65sWPI2PneIkq8MWZpZ2azWYk7f0kb+30v4uVntdmfhjFSEgc9+XslUQsdc/Ybx4DkPPqPTeRNDJVz/v63nKGAsEhGW4XJZtnce94XRVBN6GwKPcQIRqjHD2vxIZCzTFCq6MZ0ruIB/9e3rQhpW/vd/Q7cB7B4Iv8yJ6NBmjPmEUBu1lSbTVLz4VmTgEUqJWB91b6XH4uqXvmXl/Nmv5eD2oeJ18dveml1QStxptGgsoIxWGHV2ABj8W64IgBzfjXtXve6qVRADH3BcTtuCXgNBymFQyUtDFiTbHkSDrgrvfSXpGGIR6ly968q1SgurwqIP603PmPb3qkuVuLtBIbRVrMf/7b7vr0kWW8XLdGyLDm1vCUX/cSh4H0vkBE/V/oV/AFHqmBDZAyWTQOgx7P2PXhFqWtfCHwpyYd9sMl8MSTyOuGnFiUhHHpZ3uFDbZnsZi7/hjetv3dhiajMl0ot31FdtdY4kGvHj/6k/OxbULQNY+16aEmfHpFNK/1iGmqD7xdWMZ/qutYsXtphQ0Blb/dVthQ3d0ehZfxTZhg96Sh1mtwvNzoupbwQ7tzTjZjIb1Jfs16W4eC3ysAM3iIazPGthXYLCEhapiAMrca6zKHRMpc1NTv2UgX48GQzI4Zd3UFwm39hc3CSyw5enRLz+frFNE5kbbFkBhU4eMOepoQplM4/RZPp5NPqmIgDkC8cCfEC25Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(66946007)(8936002)(5660300002)(558084003)(8676002)(86362001)(38100700002)(7416002)(36916002)(66476007)(26005)(38350700002)(316002)(66556008)(508600001)(6916009)(956004)(7696005)(52116002)(2906002)(4326008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wYOPKjgkEtCqhfeZJe1BgqqbL83+tnWTGiIUvsAM3m/tpKfYdJMbUW8LJ2yR?=
 =?us-ascii?Q?Fwo8e/88URfhDzrF5q4KZMFXzYkbXhYoZ2ssXILC9s+plGDgWWT9JMXsscqz?=
 =?us-ascii?Q?U8BpxdI7Jr7xgWQUlmS/vZoCUJ85M+h58nUwsHFrmRz37S93/BeCUo90gQsA?=
 =?us-ascii?Q?L0N3Bj+6AnfDIh93UBXCfYwHkhVM0KXPylI7QtQlldcXD6mdo9WrSQvJ2JHe?=
 =?us-ascii?Q?qMPNEmlRgtFYL98sNZcdFtIRVY988RWC/gUdTZppLyitq37gAE3B749xOIS2?=
 =?us-ascii?Q?O/HZIEzXleZLXI6PGGm+cpzVMPoJAUXVCBEEm224X0OS01eWE7yf1fz7WSqe?=
 =?us-ascii?Q?ssNmrK2c19+Qh4rQsUAIYUw1oh2Ko0Rfb9iqnJ/qDoQmBpW78aqUjkW3gKUm?=
 =?us-ascii?Q?aohFHRv8qsFU5cpwuOVUscPz9R0bHaGJaU89UJGZrro/QCJqKHmNdTkzN8Gp?=
 =?us-ascii?Q?AtzzR7Eqw6S7fOMzZUHmLimouCFnsRvnSiEVoqPOO9LnYWop1lTX8nrz+55g?=
 =?us-ascii?Q?jhDpA/A9p36zK+o7kIiWU2rOkJyJc9BxmqpQ4DvkoWvzzGdJh5MtMKBHRuhQ?=
 =?us-ascii?Q?iWxiFZkev0n0dqhjit/4klfg6yAQnOwOTnSB1qQbEica4fTZLSOS1COup2Qn?=
 =?us-ascii?Q?Fs5KaBd8wRQtSp5h4y13FLSfBWZ7/dhSoP87SongT0i5+RNveSg64p4cXGZx?=
 =?us-ascii?Q?3KFOTpG1kgO9kaJ+3x6S2Ujq191KQfYV+AE0mVyE0XLhq7+WbwR+vjxnJBMb?=
 =?us-ascii?Q?MFXJa2g86t9pOu9BGWUOROcxIHluryrcfcbhyRQO6mQ6hM5RDEO/K1MSUrSb?=
 =?us-ascii?Q?VJoxhXCDCpt4rVKIOUSKMkApCTNG6fH1dviXflM+upNf1qd4hC8DHDdr2Yv2?=
 =?us-ascii?Q?Vmq2YMjcTKeQdQb+oSonkn4e1f3i6+w0Hu6t7BkxuPwb1Iau76aR2+9E1tEY?=
 =?us-ascii?Q?LFivfjRyE+w0q1dKisYQpV3rE7pcluJCARZ7K6crv4Ycs8CfC+ggk6hv3wfN?=
 =?us-ascii?Q?p8um2zfsWtl2H+XkMqNuxwRvGw8VIP1ks1s+6+TAnPbWYj3vQ5VTIBKqVu7f?=
 =?us-ascii?Q?Z6HAU7kZZkSS9Rp1wrDDyrGI4lAgbYy/onNwPxzlu3t+SACOU5uFRfqYjru0?=
 =?us-ascii?Q?Ot+GcmvFMIy0tcfQEC0ZCGKVdmNYKAi0mxTz6WQxK40aFnk7G1OjTvI4MjeB?=
 =?us-ascii?Q?lD92faar2tirY5ritSv9YZIC6e4Fr4DhNeAw4P0W5nivG0XECl423OuuYon0?=
 =?us-ascii?Q?C7wX5sYn7lyb8MYGFQ3tzAtoL2llKMcgUiUv1U6rv3vPYWSCeLYvpogU2Z6b?=
 =?us-ascii?Q?FunB/4JDQrEmnFQFOpWhSWPF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3f44ff-d6c8-47cd-4ef5-08d987a27d78
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 01:50:21.0239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N5LYI8fqX4QRHv2TrDSAWMPSbYkO+37eQUW1dj/eJ7v573yNu06b99jvLQwn/2WEthT0grLg+KDICyCQuABghF1GxsLpVDnMtl30Q7ymESk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4501
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=923 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110050009
X-Proofpoint-ORIG-GUID: 6IV3ZQm7O_21liygMtyLbrbPuHRzzRdi
X-Proofpoint-GUID: 6IV3ZQm7O_21liygMtyLbrbPuHRzzRdi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bean,

> Bean Huo (3):
>   scsi: ufs: ufshpb: Fix NULL pointer dereference
>   scsi: ufs: core: fix ufshcd_probe_hba() prototype to match the
>     definition
>   scsi: ufs: core: Remove return statement in void function

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
