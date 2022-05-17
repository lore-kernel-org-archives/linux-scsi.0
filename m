Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8458C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 02:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbiEQCAY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 May 2022 22:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiEQCAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 May 2022 22:00:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C0140E67
        for <linux-scsi@vger.kernel.org>; Mon, 16 May 2022 19:00:22 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GKS0De009409;
        Tue, 17 May 2022 02:00:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=131uvpYSEKHbz5e03v9EfQAHhxIOajc40yghQnKDAa8=;
 b=Zl0a3fkm5d1QR8K2J+gkUfUIYMMKc6x0zHixGwRVnreMKCxn2I4cC3wHS8tTnAD1Eouw
 Qq5TfbXgZ6pACeGXi/igXIRmbaXyB87RbEOQZdLFqSQOC5weD3DzblKxBGxqLzHx5/ql
 LRYwbKx5scIc+K4c6AYtZLoYNG7Lf1+giDXbSVL+XHEvoOfzhnj+6Xpc0Qq9qJlUwc2F
 N/IyoZhjW4UJmIR1/aV4fZd9AKpU0/vk2786gH39jgN4g2j81m1g+gKE6xrReysQKB7g
 WbbcMPaaxicTPvZEytkbT8W9BEwvfIfGbei1NqD7d+odGGSRBePusw2yB9s+Drn/mqlV 1Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24ytmvxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:00:09 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24H1twFu016113;
        Tue, 17 May 2022 02:00:09 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g22v2j0b9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 May 2022 02:00:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inosTd/tUv+EnqarC68XFfR67N2oTJ4vLUmi/0UktVl/CZDUjpOfB1ioAtpm2AdN68H4jST2PIQ4NdbFTCvtBNRfpScX6y5/WOfhTU5XSyh9vh0qoosrlx7a6grybOmu/roTxJ97IQnQhUub0ZMzqLvsgLj336sO4tCprCHv7UqZoGpibtk+ptkwHAsAPhMUP+rwIEDUgGfuj92/ATbybL4U0V8nE9hgWqUItFIQAIkkE/xrjQCGu1bhJiuTfRa/4xpSxbYivLW75aDCsNoS9Fi+2kea0YHjF9eCL4yg0aw4b1I6LmNEiodqBS8WWJSrNBxG7iKZ0nS1z6UgNc8rLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=131uvpYSEKHbz5e03v9EfQAHhxIOajc40yghQnKDAa8=;
 b=mwdkdyfwZUSJtrpp4dZ8UEftIf9OkJyri8b6ZYFyBWPgcrYpshM1QK2y0RIUm/hpJ6Rhn6Ml5komC818iyTCofxjCjaVi5SzYXleRnw1pNcAQn1cinFIWWqRDSGd2HKnd6QfBk/HXvQZ5pJfOYXke+xNFgbLtLfSNTZav+RzsM8ZFBXzbpOCSVY5aaoedddPv2lt7ENNWDE28Txg3WVkM4h7sqVySN1BPUXcopnhi2SXP/qYCQJ79vNNvUd9lJl9ArYRiSB6TXYjFt/fpDi3842jlHNYciyQaNgTGM8JwR0ZRa9Ww2+tOKChvgIhd84fcLfGSYp9OYAv1NuIvctXSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=131uvpYSEKHbz5e03v9EfQAHhxIOajc40yghQnKDAa8=;
 b=u4rC9vd0OcyG0a492CBAB5QTKXE5vVzz2pq3tIkIUKsvyn4H7dKgvtwZjDffPmipnhIO1TGSEFbwjLPYE2xLycLitfnqrKEVdKZ9XrD+aLEk22qt9+Eu2pra97Q5hLWvc1IoElD9G068DyRacfgBGfkmpGpR8OPd7t3Y9w4PlpE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2837.namprd10.prod.outlook.com (2603:10b6:a03:81::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Tue, 17 May
 2022 02:00:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 02:00:06 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>,
        <eddie.huang@mediatek.com>, <tun-yu.yu@mediatek.com>
Subject: Re: [PATCH v1] scsi: ufs-mediatek: introduce new UFS4.0 HS-G5 mode
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ee0srkc0.fsf@ca-mkp.ca.oracle.com>
References: <20220512135654.3656-1-peter.wang@mediatek.com>
Date:   Mon, 16 May 2022 22:00:04 -0400
In-Reply-To: <20220512135654.3656-1-peter.wang@mediatek.com> (peter wang's
        message of "Thu, 12 May 2022 21:56:54 +0800")
Content-Type: text/plain
X-ClientProxiedBy: DM6PR14CA0063.namprd14.prod.outlook.com
 (2603:10b6:5:18f::40) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f3b15f0-359e-4c3f-c492-08da37a8f718
X-MS-TrafficTypeDiagnostic: BYAPR10MB2837:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB283711E096896377F027E9BB8ECE9@BYAPR10MB2837.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dBRb4ibqGnJGz5kWmi1Ptr10a6gG/h+imN5YWDyefrxPyyFNk2Zy1WjtgZmH7OKOYaVRcfHkNnrDP01CNeSNYT629CF9YHRCS+bSNjyTGrlsFUf4dI0LpeJNZDo86Vtj54iZMEIRaerB4Wvo1kCpfJ6M8hC64q+Th+O5FL0XcJC4kNcxAXBangCrSo88EcV5RZUFXEKl+34+GgXnDQcjOxAGMXnqi1JTtpXpvOBkA78iOlZNwXqnNbqJGd08/x0CNS/HDlAVxtbhddelwgiKn18M3IWzYe1AWcY9pZ6us0aLADV+trutY5Jmwg1fB6IMYpIGVCY0rkUKhpv0Oj/uTy6lYmKELB929Bn5K573gx4jgYqkRdgnGIVljeTv9sYmLdIlrQwXNnoGWJlZzL5WfCOrJ1PFeU0HtDxbmCJk3lJejVWcg+8zI+71s3FUQDCviIQp1UvHN+6QC/JSJsgcbrcKN9Zl8rs6Ab+OEQNLDYmFudwAAf1ZSd7RXcdH6risAaJr0rGlJAWZiwI/sn1ywzo3re2Gdun1wBcThbrsI7iaaOfl1bX1XSweAhgL1DU4YwtM+shulfJjQ2s+hfnvWKrzC3msxBlgokGEE2WAiLGD4ZTsjDJOj0FH4DDcjpr4dkRQAByfL40guKtXtbetqYf44fybMRWtV8y95ZcOM3jYK61kZq3w7Y6IPlJhth5hHG+3MMsb2k+LYqHgwmnMNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(6512007)(316002)(6506007)(36916002)(2906002)(558084003)(6486002)(508600001)(8936002)(66556008)(8676002)(66476007)(66946007)(86362001)(26005)(4326008)(186003)(6916009)(7416002)(38100700002)(38350700002)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u6Xt3iecCEvjXc3HEOOTkOtyPx3ZU3kRdvbV5Aoc3+de40JXfyXBeq5GfZxm?=
 =?us-ascii?Q?jJCvKXBC+wq0lEzi89PUYoSGcOFUNaKD5Hx2UhcH9D8VPYlruN2M5qKYgNc3?=
 =?us-ascii?Q?/cx3STcSigGCbt3liuOdwVxuKpkaHab6GA3DexR3jKCy7BEm9PO3zq8/V+jy?=
 =?us-ascii?Q?bMDDv6lfcF8iM+tfgPk89n2fBvGDyAuCTq9qEFrZhIwHretYaabNLnRHzLLE?=
 =?us-ascii?Q?8q31RW8CmPkamGPmcheRdcGQU4yNfIs2KMnLF8QY8bQf7tqAZ8unIYaKu4uW?=
 =?us-ascii?Q?c/JP+CLg8d7j6yPmFVryYSbXUo3IqFAFh1SZvTAFse7dvRJfWnW0LL4xq9Xv?=
 =?us-ascii?Q?9C5vIXiujOM53PDWDGxTp8XfGRwVofqrgTfiJxOWfzdLTikZynq8jD5SBhWb?=
 =?us-ascii?Q?OCO+9YlE3IMkBtTy0j/qwEdhCyPKBbQUnDG35V2CeG3HgUl1WmAlpVKSppu+?=
 =?us-ascii?Q?DEjsyOg7O0u8muDKwQxEaZmuq3SUcuIrxSgyofSnVpCVtgrJ4sXact2ZuZHd?=
 =?us-ascii?Q?NE4reG2ogwbXDDee3gr8eUJql1/DNzw1UczzDxlgV4Yaydd1TnPQcJaLfTOO?=
 =?us-ascii?Q?OIkRBJQooFUftudSWvyIPLhBCtsQ5ysSj//Ttjp++RSD9uDV2dMQNWg2gfow?=
 =?us-ascii?Q?Q3Pn5d8rIUX2HHOmk5p1D9lv88+gtTzopq6M263OQDCNzlHIf4mXRlGeoVs6?=
 =?us-ascii?Q?S1ujnohuBYDIa8MmEvOb75shIEwUB7vLJedRtdhKLfxRlFH49FGJ/Ikz79g7?=
 =?us-ascii?Q?zMCowp0PkD8euqx069SoqGT+aRdcxq0ZUwJS6mJZq7EehYgvJIxX5s6dbl0w?=
 =?us-ascii?Q?So1O+FDgxP8NuuAyytI2AfjMTuIQg3yZdWqsRP2cMzRL8ZoYwjggq1vRXTkx?=
 =?us-ascii?Q?31zmUF0fB0+Az1knMdcoaZu53h+A9F7IZoKpLTGBb3Ig7y59I/VhEr/oQG0o?=
 =?us-ascii?Q?P5egz6svVGW2cb9Lzes9H6R7Z5BJXRtE6gSCk5RQFuDUT7+s8zu31wM4yKNc?=
 =?us-ascii?Q?a8LSvlWi60dtlWU0KoWYNgddkqDDj75jcZAqC32yobtVEkkqkW4LJ9HQHcsN?=
 =?us-ascii?Q?cL6WMBFn0ZN7BdKDH60IXp/nQrbwv6Mk/wpj+RZoKChNxXsGVyiBDB+KOFrt?=
 =?us-ascii?Q?KmiIcQZJnvVXudOAEzjTuUA7oVL1u0ey3SSgHQiWzOg8txN/VPjYI3c8Y39K?=
 =?us-ascii?Q?oV2sIM+jpT4+Lo5eM9XQyNtE1FEGPJg2RZzhDLDc15KSRDO/L1ABJt4EBMdI?=
 =?us-ascii?Q?D89s08Rv3sUC+aA61RqtgDMZgg2N+oFV5zBQTvs++ot7QuTXgnBMXmTWpZuR?=
 =?us-ascii?Q?+QMjdcZQJl3WlYR7o+8Si0FW8OVjY2NWmO+V7j483IrBnwWQDlua1BdhIwZU?=
 =?us-ascii?Q?gT8PLoGzKJxy+BeRZRzQ417UvqhFVUzQvPBhMDO13B6caWvIUzysWC7kQrgR?=
 =?us-ascii?Q?11ABQ+e/0OUTWmtEqGFfSGYwUMjzEOnqEFfFwu7duSgxiLEBfYIGmD8He6od?=
 =?us-ascii?Q?IshrSxWp0Aor8zzd5i0QQr9TYsjocP9+TlvGmRioWr9qyBT+qmA1li8IrZ4Q?=
 =?us-ascii?Q?k+bA8LnKnL1Dx2a9sAiPEpeiWULSsT5TrkBFE+M494tdGTY3ANPWofo5Jxlg?=
 =?us-ascii?Q?VCZ670WsnfsKN9QLeZbtBBSd89m26JuKa4SAvz/US8rT9YrOGNGeht7uNvXB?=
 =?us-ascii?Q?DqkSC7NtJFVRvE6iuckgreM+4+30qEybIMNKF/7R8Qch4YrdjUCC8MCJYsjK?=
 =?us-ascii?Q?JcqmGFi35AHozSjLUewS/bNaYp340Mk=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3b15f0-359e-4c3f-c492-08da37a8f718
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 02:00:06.7850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B1miyUIQ5PhKNEFzP5aQWRDiwrvvBlEOvmTpakjNUb6yxdZKvCVpV83GCG27nRGpkBWYWyuodK28Cg70m3v9ZcUZwnWcylKbNV5tjj1cLGQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2837
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-16_16:2022-05-16,2022-05-16 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=948 spamscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205170008
X-Proofpoint-GUID: xNZghzAlDGAh-GJftTGn7CfZne_BytzS
X-Proofpoint-ORIG-GUID: xNZghzAlDGAh-GJftTGn7CfZne_BytzS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Peter,

> @@ -4101,6 +4101,7 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
>  out:
>  	return ret;
>  }
> +EXPORT_SYMBOL(ufshcd_uic_change_pwr_mode);
>  
>  int ufshcd_link_recovery(struct ufs_hba *hba)
>  {

EXPORT_SYMBOL_GPL()?

-- 
Martin K. Petersen	Oracle Linux Engineering
