Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FF6E82CCD
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Sep 2023 19:52:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjI0Tws (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Sep 2023 15:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjI0Twq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Sep 2023 15:52:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D07114;
        Wed, 27 Sep 2023 12:52:43 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38RIwvJN002843;
        Wed, 27 Sep 2023 19:52:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=FW9Rf/bMwgk3c28DM9hco+UjqfiPxmvKc1MSlyfncic=;
 b=EctsWP25V8wsiExs/x9b5zo8IyVnztnEjH3pJNx7s3j9TCviRBcslWMFDbgzF7peBPLV
 yx7tNFI72ypwqPx9xp7j2dr1MkH2WWFfgmfWsrJiML5MVV2JtzjmYKjFu9dnQ1/4t1As
 y3MnQG5gninY2FKI+6gO7kHVnMVd5cPYbh5+hvdJP0L6cs2DyZ5XrHkjN6XvJQAhOjYJ
 B9sfZGi2zbD2y06YUS53zi8adDmb61Lo8kQJjN7/BC9ayrGV6tEUh+XFhb1/ulhbWefZ
 TeDYh5awHKarupUOc+PtVPsAf3me/LX+bxZUo3Jqw9J5/TLGxK7SHvXi6/C6TIlFHs04 bQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9pt3thxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:52:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38RJbhIH017965;
        Wed, 27 Sep 2023 19:52:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfee1rg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Sep 2023 19:52:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fpa3GJD+ckH1cJ2KyEnwSZF2lopO7UUBidluvpMLoowrMK0N29d3giCYYgub7jRc19YojURAdmdUenBEzovRLCwPCKyeZhL6rI+awwpwQhzLnK4jbwIXdLYHThDzAENLsjVrtIjazhN298psBjhXTYQk5hk3hzrGz4lw6NKuwUxigFySfuoOSO4+Q6O0mw2g95hLadCXqR4UvcdVaJoncrNT1CuhTxBm7t928XyuHTA/oNQ/gyestQLhphIOB/HcJV1/go7E7H5w4ud5zCooGSase/ypwM53704KuFGe7yNHQv6jxHUnXyJOjLptY2HiMTxkYuZDcySNU/ZPxi/dAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FW9Rf/bMwgk3c28DM9hco+UjqfiPxmvKc1MSlyfncic=;
 b=ZTgUJboNAAXL8PG83zMa4ILOQca44It30yVCgN74c8rrKD+3tr8pmn8CRwYMaiIvwGgpaM7OonjL/HF3UtfZZ4bBP6KPJWGpUry+862CDCEOD/3bskgm3/jwNHSduij1BL8rS1TekPmT658cCZbLnI1VcQu22+FoYXyrY1zxSbvJoJapUIgX9YraMspfyQCqpZ1QPz4UIghOdnZChRZ/HyGemTUHpKZ4q06aUHtH0unXsoLbbzoblM65w3/Nve+eMHqvu/4B5+XWSh+EgU8M5jiCLfoShfr+X/rdiN3p6D82kmtioBO4foTSo70ntGklGRmcSvZ276RXEqHO71gRpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FW9Rf/bMwgk3c28DM9hco+UjqfiPxmvKc1MSlyfncic=;
 b=ms3U8EasXullQ19XGidIuAkyBubdrOX3F1C+P/8ENKUwj6ETgNnIRzhmyHYXhLfsKq+miYBlsjGmCw1hLVY0726QS+dVxIaIB3Fua+Ki0NyXiuQAfi5RBI7snDAu1Df1n41TIkBJr06gm42+BfCGzOonsaxMyWa3W9g35Ir0Tow=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM6PR10MB4377.namprd10.prod.outlook.com (2603:10b6:5:21a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.28; Wed, 27 Sep
 2023 19:52:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::59f3:b30d:a592:36be%7]) with mapi id 15.20.6813.017; Wed, 27 Sep 2023
 19:52:29 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: Re: [PATCH v8 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq17cobz973.fsf@ca-mkp.ca.oracle.com>
References: <20230927141828.90288-1-dlemoal@kernel.org>
        <20230927141828.90288-10-dlemoal@kernel.org>
Date:   Wed, 27 Sep 2023 15:52:27 -0400
In-Reply-To: <20230927141828.90288-10-dlemoal@kernel.org> (Damien Le Moal's
        message of "Wed, 27 Sep 2023 23:18:14 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0003.namprd11.prod.outlook.com
 (2603:10b6:806:6e::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DM6PR10MB4377:EE_
X-MS-Office365-Filtering-Correlation-Id: 30413ae1-5095-4f0c-b211-08dbbf934800
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ct1jI96O+OGTYYlrPQhPRU+eHzJgII864p6oMjMJf/PcYyFQe9OB4NHO+Q0DCYtArZ+wB7HL+18X9AqTb9zQYYFcslF+BTRXoPutgQhTh9W9q081QOiQ4iZ7vWry5d/lHCB5NX+URSZiy4uxDIFPe14Mg6jXnthO62KpajJlhBKCLAOBbHsqBLkC5vlJ86G2Hx/3lEwpBE93UllwM0xZA3Q2L27CkSRsPPaHUPsAoO8WwkR8HvNSNb6x2s88xL/fhyAyRD+1/wzqewPWpphgFcYEujTLctn2+It45G7iiN4ah2wK0mB3Ve1XdhCp3qmy8soumkyqIdxdyBLENYlv8KkK2GCYEpfv13nF8byQ6qENH2it7p+tJ3d4ggsF8hGRBVjMCcKdZISqZ0xithgTKDidKNHdA/g/HDHlGSgkB3F3bRDg2YvZDi7ne1y4Ta+3iOUR8BTyeu9T0ol/ZOWXZqjjTmfFoUFwW/3S9aSgCqLbP/9mDuzrYL0ghRdrK6HpQPzsgG3dGhAOAxacpolOOYkVEqkZCazvc/CgfAzhGE4CbrFgxDmerKo32lESYANq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(346002)(39860400002)(366004)(396003)(230922051799003)(1800799009)(186009)(451199024)(6506007)(36916002)(26005)(66556008)(66476007)(86362001)(6512007)(6486002)(478600001)(38100700002)(2906002)(8676002)(83380400001)(54906003)(5660300002)(316002)(6916009)(8936002)(66946007)(4326008)(15650500001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4lPPd6rsZcdMXC9OzYxKG5j5lYMzZINmEGGT+kUfJidaYM/BPVlVQ71a+lll?=
 =?us-ascii?Q?uSkR3TEGktAoiHdzY7PchSqezzoeN7cfEow3dppmhtvu/WMcoXAe2G16Xzs3?=
 =?us-ascii?Q?nqz+1CHmgT4HfhQgaNyOIMWw2DYMj3SxR4DqL60JgON5g2d7Vv2veLpktKf7?=
 =?us-ascii?Q?2dQvblKpIh8DI9rqDw9SdvnsjqhtJ55pSRsGtDfp8ars0MX8lGZtfNObl7CG?=
 =?us-ascii?Q?QZdMN03QlDHBYWeRQUQC/XsqIO+GLi8KhLqfEzHzx4TDpjVcw7KR11s7Hjk9?=
 =?us-ascii?Q?A0FnelKsrQQHjp/CP9JRXg3G4taWSsrOs50mR/cynmD/Y/Q3NWVk0Xo4z7cl?=
 =?us-ascii?Q?PDK4nhSgnJS4pF7M1gY+DiRTkFvpVvA8rMysH3i+lJAHVCUeJZBYaODPM3WI?=
 =?us-ascii?Q?6mCM+n4vz/aqN9Mk9WUUsJj33MUzVCrIR5F5+3+4rpoGYtPdZvuX4mlUeESD?=
 =?us-ascii?Q?rFdFNYQCXnyo9ZvvZDhchLG0+9fQh5F2y7eWkf8h1kw1klwJyaN6NkO+cd4O?=
 =?us-ascii?Q?ta4O9u7SdjSDZWFzzZ8ZWS0P4r3RV2B0dNMApKtR1cvuWbmx4VFw4HGK5656?=
 =?us-ascii?Q?jOxh5k6RIoNwR9fj6rNYB9r3sbynSvBM8Vg68FLGqjaA8Iry2IbEE6tihcb8?=
 =?us-ascii?Q?FTClgtEgYVyHxbKvsYFFTpooAPab1gCdbV2eczo8svdJZjUAA2R94VwRvP2a?=
 =?us-ascii?Q?axJlnHf/vZ8JUdQHHKG4qTHS/yJm/XfXe+8FgxTBhc/SkPiH5YYBEpcIkhTo?=
 =?us-ascii?Q?JnoOKvLzy5CPaVI+TCRuNPHKkC3CeEH1DEIGzmdbSQILy9gqp30RNAuCI4DF?=
 =?us-ascii?Q?fHrYFcigB7aF5TKetL59roKber2mFBjunfaNwKQse4hhKLBz6T8AOh2ACbex?=
 =?us-ascii?Q?67ILETKMZlBbbPofMLbRuNDlk7W1Z9f4OsRw7lc/iYKmio9vgQZU1TG9UinV?=
 =?us-ascii?Q?dmIFFV1aNMtDq7oKj/Nwi4Sm2Tf3keWWHQ/P7+39JX6gMStrAm+0sOAZXK4G?=
 =?us-ascii?Q?NaBgHq+U0cfZPGk0OSbDH5E9zpgIqRUN2ygf39qTOEeRN20m4mY9puO3+u9x?=
 =?us-ascii?Q?AY2Q8jjlL8j1mLo9Yj7zgl7qmmbFqYVsQ4OyEwSeSYT1mDji8uE+vE8J56lf?=
 =?us-ascii?Q?bmU8PomJqkjnb3T4r7J2iaF1cqYeEZ/nelfkmfn2M/9bO9AdKxbB6AMRsKPo?=
 =?us-ascii?Q?SJZq/DTw0qxjon+owpz96vyHbwgjGA6WQNFLgvCzzSqrP9Ub2odRTQblNjE1?=
 =?us-ascii?Q?8SaIqL2ER5r2jJQW5ZRFiGT1ACkZbcMjA+QjxShwDyu6Cy+ILe51yxX8fc5C?=
 =?us-ascii?Q?gAqJzxFLuTiYH9WZSIIpV/YOkAlPte33+UILjPzuTd8Ly2683ImXACvJb7wq?=
 =?us-ascii?Q?JstdybXtAi1e+JAMVI7h9MJkgdbmlanCcoFn8lnJeFArf5ia6DEzcFkQMTOB?=
 =?us-ascii?Q?Re4IFM9aONTO47f7hEynxmlBPOPHxvzbNoHg/Ej3rwzX5GeO7c3g+4bBrqiT?=
 =?us-ascii?Q?ijI7x3t5lonDNsnJ6zjBBpEPyJFwM+00qPTeTqx4KQPt2W0HnCxge30r300T?=
 =?us-ascii?Q?wZ3lPi6GTggGLQmg/6lcVXZkFn5bnGleJKaD+AI5mshjze4CriOFY/wuFsDk?=
 =?us-ascii?Q?iA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?XZW0wz7Y6qvGXYB0WbJu5xAPTi7Kxcav/Iog06t+obFru4cq9IeUIwwAyqyE?=
 =?us-ascii?Q?/Y83obhaFrQDrpzUZv5UE4dw59ULYuf1cZRtMxkgf1ytXVw0B+Q9SYmtqqHY?=
 =?us-ascii?Q?iTRX0IvTrKveV9q0Mp+Un1cyl+vzjmhgcBeKMrbAEuI58FUFV3XAkmQgQcoz?=
 =?us-ascii?Q?YCFKrV4SvwZROHscASXhRqGlidiXzpawxioL2ff+8XUuoAOAXryD//XFdKpD?=
 =?us-ascii?Q?ydvZjKg3Zvv9T7hMWE5P0P7V934z0W5DL4iYvtdBZliactEsJ3w3BtCaZXz6?=
 =?us-ascii?Q?6FoNExlHTTU0oIMCcCUj8i77W3tipZVf5aev/uV2bTTZ85H/TeHhiEbbzA5L?=
 =?us-ascii?Q?+NCMYtEhCgO02DGKVSawgP+JVik7x0YuhtSAIWSJoPVrrx4MdM2LSP0T+Jxy?=
 =?us-ascii?Q?mP9e5ht05gIigA872tPgpZ+ECBEeFYVNF2ssaWBhmVoa7bDxFI9Wcvgzs3Sc?=
 =?us-ascii?Q?GXNqdgsKIPdSifKtAzmp4d+ZMRXDPBaI3wZIfcV7SKXDON97VYqsFhgFjusO?=
 =?us-ascii?Q?e70TG9xYU+JgjsAT3ytbtNYfLcy+VQiEWnvNTDBt1O1PWY+v16WXCDOY5ZC9?=
 =?us-ascii?Q?AGwTrR3ZDc5qHDN/6jPr1yA8cU8RkzpL83lbnIpdqv+HQfA0ozCePEUS0GGx?=
 =?us-ascii?Q?P+tejpD0sOqjQ3RYqstIr+2UNVyH37Q1tGr4x2GcM9KbNzGF4hzy8cgKzuSx?=
 =?us-ascii?Q?m6JzVTL/MzwpWWOXJAiOrqx89bKRE28pXTNV3nk6QAEQ+3zniXEbdqRoJTct?=
 =?us-ascii?Q?9LX97GnZ8hWPPE3l6VUJucSRZSLKLfOQ3R2mUKxrf1w3fsAP9T/9OJTc2pJU?=
 =?us-ascii?Q?HSKZqEafaltQGgKIwpLcG7bk2klsLSN6z1IoSgSbvZVmmdq+DgQPmATd5exs?=
 =?us-ascii?Q?wrxVPXNRcHqkMogx7OgRCvmBEtUJdlZFiUgdM2rIjuH6sg2kmZDUiLyi94dE?=
 =?us-ascii?Q?ZRFi2mZRYRfhUWW2RMhdkQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30413ae1-5095-4f0c-b211-08dbbf934800
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2023 19:52:29.3379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EgLOnBYX/wgg/xi5hK30sD6Dgq8rXeKLJohH5Wfidmu9BgDmykl74R2G3LcvTM8FrGUG/KKo3c8tSoLIRXCwWT3sBRQPHzwnBIdbY0Wajgo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4377
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-27_12,2023-09-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309270168
X-Proofpoint-ORIG-GUID: 3QIywGQaeB6J2XT8gMZF0Ia_57HqQCHe
X-Proofpoint-GUID: 3QIywGQaeB6J2XT8gMZF0Ia_57HqQCHe
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. This in turn results in a call to sd_shutdown() which
> will issue a synchronize cache command and a start stop unit command to
> spindown the disk. sd_shutdown() issues the commands only if the device
> is not already runtime suspended but does not check the power state for
> system-wide suspend/resume. That is, the commands may be issued with the
> device in a suspended state, which causes PM resume to hang, forcing a
> reset of the machine to recover.

> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 5eea762f84d1..14153ef7a414 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -131,6 +131,7 @@ struct scsi_disk {
>  	u8		provisioning_mode;
>  	u8		zeroing_mode;
>  	u8		nr_actuators;		/* Number of actuators */
> +	bool		suspended;	/* Disk is supended (stopped) */

suspended

>  	unsigned	ATO : 1;	/* state of disk ATO bit */
>  	unsigned	cache_override : 1; /* temp override of WCE,RCD */
>  	unsigned	WCE : 1;	/* state of disk WCE bit */

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
