Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4735C76195
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Mar 2023 00:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbjCYAOa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 20:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbjCYAO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 20:14:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76AB5B9D
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 17:14:27 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32ONYxG8006464;
        Sat, 25 Mar 2023 00:14:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=ssq4O6qLArWtIb1ZVoewM9Y3XtWnMBk9rdHyAakBzFI=;
 b=OSkzuW1XSZaQroytl3UC8Pp+TRPkXNsSa/W3K716ZmVfCe7G14SpnnSQUd3083e57MIZ
 0oJtItVrw6zZKvRzdTgo0KXGWZ0riYI2XiUSAMsTMAgpuwl0LHAtrhnSjBtivowU7l7E
 pRvNogeFRx/0X9Yh5CisFl0Bo1dEHFaq0/d0lfJgvSPjJ9/M0mCU5CJw3YFTOAP6lsXq
 tKpnWFtrKELPLq8m5vSTQeOvPBFbdleRHucGqzpH2FLNg+R5YzQFoOZR5ygGux0dhIh6
 Huvpb7NvLp2ml/oMva+0CGRyCF2lWUNcUAf5VYAMva14QI563etKYkKI2/WDfyKbsvH5 VA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phnnj8241-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 00:14:23 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OLZKcq038186;
        Sat, 25 Mar 2023 00:14:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxpymrhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 00:14:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j3+6OrD7mA2BE8j1tijLbuxQsi/YHEmNcuQLFI2GNlHpJCUfgxLaLVtKSmiBcf9u6HJ0v3sY76tH45m1PnLLA38PIdSPZZEuCArVdGG7/hTWiLBaOEmzOCVcTpdAUnlgQ8/9KXyt2p9qVyTIAY/r6GiC2RsYgkUQYyvBsjm0EdP+z8BcaiOtVEZ0yNMOxBcaWMewZxuujCrfCiifKbRACc5b8bIGEM+4df8pdssjL/DtZPvHJfdJEWHAsc/Gy2FWucW765Y2zZqRx4jvNYOuCMusIXH5HROG0EGZHZ6BAPUdeFl2snn8Xo7GBpmOfCTV03zOhsyIEHz1jsgq67/vAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ssq4O6qLArWtIb1ZVoewM9Y3XtWnMBk9rdHyAakBzFI=;
 b=babqridLMPy8rntG5+jSwNCM+7gA5RYK7rGpVXQ5L098GXgFBPoKb2gWLM1qykEl6LDQq7X6xHwUQNqdN5GFF6NPufSJNYq/vmQ9eAl/X8XmSsmPq/Gvu3k3+Jgjf/zqb05N+FqX5jPO1eC4JaG7bjP+v5QO0rBc4xYBKH5aoENRql+HYgoQVFx9KZTPMhUCB1cw+4El480GEZF1mzrPUD/3Gzm2GSfe+wisXmOt3IEEzmqfuinalH4MXWg++2dHpYpuEgWAUyusiskGdc3W1TVraXxUY2IQiK30k+4yIFX533MtT3/4CVXttbsHqIApDBeQaWWwFS9nwJIYe8jnmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ssq4O6qLArWtIb1ZVoewM9Y3XtWnMBk9rdHyAakBzFI=;
 b=bAmimDx55maY7W6ilk/LYDuset60lOet0uEb/yAg7U8y63vtqN2nW/m/CWqwXMVUz6STN1aAys2vK6QWRDT5uDhx8Q/9Az8KsqnCqOAYE2Or2GDUsUF8C2ZNhjI/CiZWadBXNhR6JSa2ktkgvjN9kEtofDbt9sWGg58B+jq7f5U=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SA3PR10MB6951.namprd10.prod.outlook.com (2603:10b6:806:304::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Sat, 25 Mar
 2023 00:14:21 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 00:14:21 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/80] Constify most SCSI host templates
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1jzz5it67.fsf@ca-mkp.ca.oracle.com>
References: <20230322195515.1267197-1-bvanassche@acm.org>
Date:   Fri, 24 Mar 2023 20:14:18 -0400
In-Reply-To: <20230322195515.1267197-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Wed, 22 Mar 2023 12:53:55 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0077.namprd04.prod.outlook.com
 (2603:10b6:806:121::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SA3PR10MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: 65362fb2-5d81-4976-cd48-08db2cc5e190
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5VtXtHRxMrLZOWvw1BXkutUT2Comc/h0Rrtr+Mu/c5Syu+jzwcWld3X57SFuEfcwpEmv8Tmzai0C1AqdogYWIP0+pXG4LJ60xVefgd9vgr9P2aeEsP3FvJPTF1ohxfCqQrSKjxg/WgY0/GGHzHVsY7dLS/rk8udse9L6daG+SZrbmis6uTm/S3VbBGGVVIDGWdezSErFhk1pXM3ZlcC9c0o/NhdKpglutSDKVaf5KF/uyEfpN6tCFho/Hz1tKiA45E951zRoAfRe5KjJ3bk0235K6pDhZGwRKR3C0TIOmueLTUc5a3wmjIzwyW9mzEYNMgIn78FKgz1Wy3/Oev3S52tXQZIgHVChj16cWiFZFHCorlzXt7onZku/QiLiLXNFslI2+vTMPlQmKsTFXZx2OmS21HwWLGkxvVvBQmM9btb+0P3rz8eAoUSa2GAJ3L1tnnHAoOkgd30/9FLKHDelyEDnk4N20IbIl4cgyXCi0W33gIoJNT+JE4aqa7piaqyvMe8VDVfHiHw9Qqlsf1TMcDeMMZOThBss/TD0l1il3nq2kPuU7mulxDYfMqjERn0N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(136003)(376002)(346002)(396003)(451199021)(4744005)(6506007)(4326008)(66476007)(6916009)(66946007)(66556008)(2906002)(36916002)(86362001)(6486002)(8676002)(478600001)(8936002)(5660300002)(6512007)(38100700002)(316002)(41300700001)(186003)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZBBhWYV8xZRA+m5hvgiwakUL3KR3KzQhQO9t7OEeiVcPND5qbFlYtSbeeq2H?=
 =?us-ascii?Q?myyqwVubHexJ8wGinu2CMqPKwJQzkw9B09OhnYgZezgkvEo9/OuY3VcQ32E5?=
 =?us-ascii?Q?6Xv8hyqi79KqntyJ9mIyjC2R/TsRqTWSPMGEuHOxLLiS9mQuVPHR66/3yt9G?=
 =?us-ascii?Q?g9zcidelAut6rC/5upOPu0CcIcxVzuYxcIp+vQT4WCrUabvjxTa26La0+LaI?=
 =?us-ascii?Q?JTHFVlGlLWimydpIkmPpJIoO+xqPktFlVzpJFjxS3R2k1YBeaoVOCtSIOP7+?=
 =?us-ascii?Q?A2Z3z/dsNv6mS+c5ugu6XwlbBOdRg7LN6rUcbvhnoPt5bWEnNmN+/rbyqJ9K?=
 =?us-ascii?Q?hhHvPALtjOuUNCIKApCrkg+mEkZm9NbaJE7Di/8HorIc0WTGR+SMJHjcNZ6I?=
 =?us-ascii?Q?SfexIGu4z2kEJxD8RlduyDqcuHTglRZ17fDvBl/Lgw55R/0/+3WZxtSFoV3Q?=
 =?us-ascii?Q?XyyQIDXibfyYRquAryQHNvt23oIWcMTvTAeGpEAOlVGNGksQycpDFIsN6Cwj?=
 =?us-ascii?Q?GhxmI9YInBPkCkfX9VcxRAhQggp2LfYssn9+1wbfxj97xtlAFPf/hBiYkYTw?=
 =?us-ascii?Q?tAn341Y2QHGjxvMGaRktNGcWNNdIpxBAOmigCwGYR5Dv+aoNd6o+aHmWD1MX?=
 =?us-ascii?Q?riNBKtJdvXJ99j5M65NF7pgrPZkU8+Nq5hXRwqeaz0vEH4U8kIKWB1EVsfDi?=
 =?us-ascii?Q?yHLVwJYXkvnkKB1hw7PQsYWIH50emaUaFHUkapU++8CYAv5a9RE4X/zige7n?=
 =?us-ascii?Q?MoovvOpfb3CkESHPkRNHgiXQd8HGJR/UGA12sNLviWYXCCvnANr1JzYmyigo?=
 =?us-ascii?Q?o9eDoKlq+Wp59v3BV+c3et6EBsDEy8vFy5/b3RzoJUiUkvnK5s0hJFP/aMuI?=
 =?us-ascii?Q?JrLqLlL18ZvjSNFw43p2ZiVY4452ekL4p1sqvw1mfPjGC53iyOjuY1k6Jle2?=
 =?us-ascii?Q?Salj0rJEvXb/tr0VHmgbGwNGI9bpuZydeTjKDPuvDu1puOU9K8U2WWlyxZWR?=
 =?us-ascii?Q?zeNkCQSA8crPOw/jw4P0LfqqYLsl52hvs9seZyNwuEIf6TMzeFWpquqGqa7q?=
 =?us-ascii?Q?ByP7wgJvRVYZvm7RqfCZ8jwvzBThZk/ORJqusv5cZg915GHAlRHHmUz4Z0bz?=
 =?us-ascii?Q?9nhj9IHjqLpacazcU5Lj6OIAlPGYxWMlRo4jZx3B4ikayo4EmpdYfo5EGcoi?=
 =?us-ascii?Q?XMFxALKH4MV9K3zMpGvwUjxRLnm90LON1q2NHhJZrmfpkL0Kmg7e8T+rv6LU?=
 =?us-ascii?Q?DwXSPFt96g7rqZtzMiE3xepmYwqP3SMDb3LdxWia8f52asZ6Bdo2/Nm893YT?=
 =?us-ascii?Q?xq9O2ibho+IbhO/rnvdrirsEZvqUzOIvu6rbpoCtoRy+sLISKMbx8xNDkMLu?=
 =?us-ascii?Q?n03cSty0Yd0sr1XgmVOPsUPvmhuJxGgzEluMR8UFg/T8jfNXXCd/j2RVJgRB?=
 =?us-ascii?Q?5Hzb90U6s8MTPx+cbkdv1b7c7SUsepkcv2hKggpm7duT/VCFQob0T42bhkFi?=
 =?us-ascii?Q?0wzdnMCQrYtFW1ijpWnMc0pWtYJ30h4cOuuNOm7jET7C9WSgCfIrXiaqBM57?=
 =?us-ascii?Q?GKomDAcRLR0jvKEnhJWs0W3DRcif8FC7m9STvr/SzfcCh2qEFDlRvTwYf2OK?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: +gSOQiVluDx4vJ94DUEY0cHr/vpCQTRALp7/OjPLTP0gQDSRQNs8fUzAHqM0NC5T9VjtJuAtfEm/L3G1SaVtaArVvb7x/DTafngsJ1ggLbd5t3YnDb46HP9QBWvt/Raii/63Qz/3tyhIwoadYmQBz2iR4VfcHLUB3jxEL3cVH7rt6zxk8ncEx2rJZVPlFNxf/APlPLdwbTU4eLr6B5QBZgKf/PHMsYZkaadVL7HbdvqIPBZmVqkyJSgh7HFsJBIISXiNDLGXDolZTS0NYGwy3CAitU6QJPXeR9JRET+k/M7NqHgUWEAsO3Jm8wb+n7nIYB7J6oFWAEwA4ED73+v92FNRmhbO/P8M8k6uWAhKTZc1LHB+tE1BX8klOaesTk/SwRmWxnmAtC47kLtMVF995VcQ1YeuyBk+13o+skaxE93x28KH9SjjpIol/oPDkRl69Hz8Acz0FDmQOXlGqn5Dcv0IKzu5igUU0YRMgya86kHs/pCWsM2fiUfmjs9GB4kYFEC/SIGzWwcXZWA1P+x6TtQ0URQYTVgpwAELeDG/ok5ovg7cWR0d2cXRvDaUDAGLs7FFv6TZTVMP1enZenOJVuHfrDrxLfhEKoPHl8nH35e64J/WVYvJce9Zv3XWE+0cgarMcAzYKJAr+37OtmrTWRilE6ENky40G75hQz4688V5jo77tOj4RaptCNvyD69Cj7fseNmwoE9oDwC7b/hinIPZ24k6n8a2hbMBF/Di5rCYf/AFR9Lv9aaIcb60ypQQca+q29SJH8GcLzpbgWcyi8HxA4NsSXzh42/qtLwBlu0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65362fb2-5d81-4976-cd48-08db2cc5e190
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 00:14:21.0411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n7uQ0MdPRbWgZh3NsksQTA7075LbIqr1QW84YP1R2LyNnrJQSgHF0gFQ5oCIWk6qPYb6vHbpTWO5c0dldsQWy2S4oUBRslAbpeldgGbSpFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6951
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=675 malwarescore=0
 adultscore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240186
X-Proofpoint-ORIG-GUID: iXrtGiOx6Z_4AJZaYv0VUxiPaaSSWFiW
X-Proofpoint-GUID: iXrtGiOx6Z_4AJZaYv0VUxiPaaSSWFiW
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> It helps humans and the compiler if it is made explicit that SCSI host
> templates are not modified. Hence this patch series that constifies
> most SCSI host templates. Please consider this patch series for the
> next merge window.

Applied to 6.4/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
