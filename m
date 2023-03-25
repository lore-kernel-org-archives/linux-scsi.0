Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 280A5C76195
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Mar 2023 01:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjCYBTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 21:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbjCYBTh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 21:19:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E52E1CF67
        for <linux-scsi@vger.kernel.org>; Fri, 24 Mar 2023 18:19:15 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32P15u8n002945;
        Sat, 25 Mar 2023 01:19:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=4SVbp5sDSlI16WkQSKtEIgQQFuHU7n+O4NOqm7dDKok=;
 b=qgXbkBTk+CUnI1uLBDl+ppiryJ6rob1KEDuJMr4+6ZBHnyg8nrbR2BUiimi/+/eAYrjE
 FqrXoCFK57qP70Fg1ijIQkt+3jsrYjlV8BOj8qoWZ/hISwJd6Py7hsAykAfK3UODrLJN
 +4DBKqxLn2YlhUwDBi5e8tp7z/9TDGMuJXb5zgAULUwuhRk593UHPMeIroN/4LWSj3OX
 SwyW+BcLnEcES0nfr/7XQomNEd+HG26qztxB920xH4UXC/0sDiiw+HyhxyTpApowLuUF
 CPeLtoAOYsa2zQ6zNem+8pmQVKkAR31MO7gKYUh572xTNpnpSU8ZTZBVNULygMVnz8SB rg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phpyu00vt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 01:19:04 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32ONfORa004283;
        Sat, 25 Mar 2023 01:19:02 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk5xy11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Mar 2023 01:19:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gDvMZpccxQ0AKpXWkGqSCfelukXa9lazlxEkJ5JH4vItAkPx4j7sRm+XSpuzl8igxH0tgNFhJsECYdhdrPLAsPOJleVn0Z5L9OcP7vpYz1wYETWPTw4SfOuJOUHWX+kpHn8+RNvYY4YpkuE5rAaUBUxm/ulqIdkU9ntG6KfFBpTAQpAwvpx22fdeev21IYoik4zm3Fwg7ByMz4ksBE/T1buQOr2gdWlGnWEwdScNjIxiAfhtAECpgzlx6MW1SAGntreYJElARHninzzTaA3kMY5UF7rMOduh3+vdeClkUDkqtdTvnbDYAMD/0AyD3xvxryUQeaxDrrlMWlYzHHJGnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4SVbp5sDSlI16WkQSKtEIgQQFuHU7n+O4NOqm7dDKok=;
 b=d0GjkQdwMwgHIXJyiS//1/FQyhKMPRR4Qo3s797etDL809a02+spKodkVFZUHK21yu8fN1nP1uGnSiLdrerC+Ywrlun5JHhpkRtLJYIVOuUwcUDnBxKmX1y81jwbch+WKPSrQXyBe0B0DkozdsNKgEzpqzTI1XWI3EiAHDt4CZFEitwPy/v3ShOaurmwZRBjtfnkgfdjb8ptXgUV/xQKBaP7/BfGZ+BlPCKjm18S6rpzl+Sn6L4a6UmtLLSOvlOaB9kX2Ded/mCWp39epyD+XLJqC5K+Vl4DS7dtziB+LauD+3YFFTGhrI6SR1ssgLnKOidRZU+QeBMlNI4uC/QjAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4SVbp5sDSlI16WkQSKtEIgQQFuHU7n+O4NOqm7dDKok=;
 b=z5N39jp703QBJAUNexKOA/LmQ5l6Ecj0HJgSuP8SLTNJ9N6mQ7Uugn7ibe8mV0Gb1Mm1Om+kHHpK1McTM7MLXMtOhjlIRIo3GfrV9kN+4HPZBbPdun61YrhUE0KrBpmW1KOFVsqEgHuTsITOasnEK1HaO4n9WSeUZJTXlQ+kM0Q=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB4823.namprd10.prod.outlook.com (2603:10b6:408:12d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 01:18:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 01:18:49 +0000
To:     Tomas Henzl <thenzl@redhat.com>
Cc:     linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com,
        chandrakanth.patil@broadcom.com
Subject: Re: [PATCH] megaraid_sas: a fix in fw_crash_buffer_show
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1355tiq9h.fsf@ca-mkp.ca.oracle.com>
References: <20230324135249.9733-1-thenzl@redhat.com>
Date:   Fri, 24 Mar 2023 21:18:47 -0400
In-Reply-To: <20230324135249.9733-1-thenzl@redhat.com> (Tomas Henzl's message
        of "Fri, 24 Mar 2023 14:52:49 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SA9P223CA0025.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: 54afe59a-341c-4e8e-2e1b-08db2ccee378
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hd5qSt2Q9esWk/E0pDqG25pIegxV4SwA019PgOyef+nYqcYBGIZvKAqm6a7gAMqK1KxhaCDfyNGrZf+yi7ydmB8gRM/0Q5Gy7VhrpjDIRDF4JlIbCvnQmmezcUwChGFuuWHRp62b6h6Ulmc9177zNnNN/1qODCP6yDefvYW3Z6Kcl/oI/2XEwjgH/DWt+KuQJqQLB5sP9fAOGtTYKvsEq38zJ8XWlwIaXPWvjhI6d0h0+xXehSMfcQXKXsVXDB+sdnjaOyihq9nXUxMSJx+NSTnneXmbmyigBdFvTH4pzLVHdb73awPH5riESw0V4qd6ggQqb3WfuEarwKwNVd7omchbVJ7QWDzDDS3a//II0KBhL4XrsfDxiFksdun4MFpVMJbC1PipZ/Tg7PuFqb1Mzaou94K731ChkgIe+H7tfMTQDbHmjwRgUhcxo53OwmmdlZZ18aLS92IdsQCd4RGfzgGjLdY8Y72YvbSOwQoP9bE3Vj5ylj3IwUwiJl86IKdMFpCaA6IlTuGt51bz/vN6MtUKTzKZMxr5yxpzVF50mZ0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(396003)(136003)(376002)(346002)(451199021)(966005)(41300700001)(66946007)(4326008)(6916009)(8676002)(66476007)(66556008)(186003)(2906002)(6486002)(36916002)(5660300002)(26005)(38100700002)(86362001)(8936002)(6512007)(6506007)(558084003)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z1dv+iYz7cv259WdxHwvjWuOpMO2r69cyqkLPjqq8T8U/nUPoAWjpJgFnAlt?=
 =?us-ascii?Q?seeE8L836IAF6ej8Ru4Fr1dF79QPRZ06WI03zQD8OuSce3SSSuy7n8AmOHXt?=
 =?us-ascii?Q?9QlqJnvCEjwWtkpcXrCX1iSlvkEzShxdfhO1vLS6ToIpK0unmdaNpp9HnPuW?=
 =?us-ascii?Q?lRfIqJQ4wCDj3tYVvMCly0KchGV5M6kYTd3sP8XGYuX5ETN1gE6OJT2fgF0Z?=
 =?us-ascii?Q?LqAf33oLWk8NPDDHRW6wsYLxi261GM8F6wCHxLaO9Z7dBinpCokf+oO6LaQ7?=
 =?us-ascii?Q?Aj+6WQLu4UZvRnxn9Ywv/qenMtnRrMaeYC+ojwIVKZb6aPd6LNJy9XeS2dnw?=
 =?us-ascii?Q?76Pmq3hPtD5O5arVeOWUDgB6PA4+1muYMrIJvj5YpicO2JF6fkYnoAt4hJL4?=
 =?us-ascii?Q?1DZnee+TGsgEm3Es3wl7U2un3ENsrWejb+DGUpOumoBuD/oSCHu1E0giN21D?=
 =?us-ascii?Q?1+MQKtImoJ4HdrUp932uu/XjZtIn7KjA4bOLkWNxwoBjbDZfe8UOhlC5IGW4?=
 =?us-ascii?Q?hbXaJzmt90BNR1mV9MtofaZT4dPWRYFH/XOIKX3q3jnBH1Vi1PaR7o/1rZUu?=
 =?us-ascii?Q?FY4P5xya9o8EEzInTNb4ssbw343PILriRSLEPAn13jxSziPreuAKo9ZhCXj0?=
 =?us-ascii?Q?QRY/s9A3AKeX0fZE2V2qcQHxVALxFwePt6JRHtqY8QqI6DNM/uUzpWtD5wos?=
 =?us-ascii?Q?vBIl557WmuswLQpiM1N7VnLYX8z7qXH/xcPqNfecpU4nhK6nbBgeUU6Iav7h?=
 =?us-ascii?Q?iwuJtW9FHvbO4xRTDeGNdrwJBOoxQmktX7Iza23RgsxQEuWO5bJdfAwYupQE?=
 =?us-ascii?Q?H/w3EheJ1MAmQ7Dwb+x+RgjxJMs+257lRcZL24YbTjP2h/uHUgTwqGQZ2PCT?=
 =?us-ascii?Q?3xCSKwzbwqiC4To5DjfjDgah1PM6HycbJdJeEOiUWn/TGvQNjq0MNxPBEfwx?=
 =?us-ascii?Q?qEDhaC9TvlAZZMN5tOtaGloTDqKeqhzy5hY1PGsiJqtr8ioXGdBpxjAvNzyR?=
 =?us-ascii?Q?3vaJX2Krxouk4AGLXQe2sCTLRa5cPU7MOAn2KMJTAgmsY53X59KPyc6bcVZG?=
 =?us-ascii?Q?hCWeX4O2et+T+b9SgNAK/kcKxhBoSY8xhlumAwx9+HF3pgtyJy0Yti8Af+Lq?=
 =?us-ascii?Q?GORji29BZoS/VFXE+b9srvM1JxD/DzOnfizfULVmoS7DYt1hU3NbETTxQEa+?=
 =?us-ascii?Q?4bR7B/gLomazpvSQUrIGcQd62QlE7StOXXuqOhOcMjMVjdC+XUIformZ8jFB?=
 =?us-ascii?Q?j/tlaf8r9a5M78xEMXiUZMEiToXsIUa+ol3bEqNWh9xxBPkQvFW5mgxObCCn?=
 =?us-ascii?Q?pucdtS1NF4ID8kpxJn5zEKvAp5In3zlo9bbQPiKYalBiuCm8L8J8REW4hGpD?=
 =?us-ascii?Q?bcqW3H2y13WQE3x3Yk8oL0G5kb6pfv4tsT7fasRSWOPghMCDdzs/vsXtoK5a?=
 =?us-ascii?Q?ETMAPxY9jnhIUrX7ASls5QHBeXGGIbyQ+lQWtDbxxwDhSfyiNgepsvq5wBTe?=
 =?us-ascii?Q?1GDyt6JcM9RqDJ3g15DEr/g9Psb+SaajyJOsBVy83gAVWMm6IbUkPmtI2mBe?=
 =?us-ascii?Q?meW7aQ4UobCMZsENVAD0rWO6yF3T1sU/GVBZHSQSaFECrYYXVCwTZIxxXeI/?=
 =?us-ascii?Q?bA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mQMpnVQRQlm0C8SxYFp6HWFeCvjAiLkornNuN1aD5FhRc6BFwAQIvDyu9+7vhMGAy3m0XfwoguyIe6cp+GE0L/gcBnn4PdPmaHYWsf4MVxLmkl3xNXZAFxGWTL/v79+PQIcYtNKmCJFSklyJEZTvGUX9ix9NDJxRX3hcoWJ66zzDYAMM4jSdaKP8t3lZG7fLJNregHBaLdShhhvx/YiB9JB+lgXjamZQt8cnMSGQnIfrhRtdzXP284s5Xmw9jTqQNyli8hPUQ2s0WoUViauek6daLjJ63K5Vk4Ye8qyRy8qks0abplPxbYcWQYgfhjws862Sr7GEyBLC5nafyxe0QrzPyK2vO5nAlN+J2LfosvpphtwjwUJ7ioWgt0g2FiQVbG/y6HsqJM+zRqUTpEeQ0KYshl5+ceSrxCqI+3oe2zGCcD7C4ZV0xqkS1AAT+c4InP0nWiqgo02EpA0/t6+9qCKTzj4+MXFASqMS+N+o6GWhGRvs5QHpeSXSqNPf+kTrzYPFyYQruROSVLkwEcSuN0dH2u5PQK/33xU2rZFUd2hi/Kbk4ckRp2CfvA688J+rX/Q4XyVD8LDHYaS8tMrDAJSeoVws5Lc5T/di5U8k/1pnxfMNsdBguOajLzJDGWwwOm3DIDp6QajEvU9TXDMzdFw5yu5uo4Ri5j0NkvNttraZWCRvE+wl7JPhYK8JBDbJ/kQzR3RXJ+OJRL2zl+5D4S2lCqXJr9q/k6zMEDGdluNgEDwhMvgmK0Ld/BiWIazmYTdhYNk3pFA5WJhHLfyilUxEkW4gOQfKPYGzof5vB5ai7jcq+LlYn5I2QtaJP7ZsASsfVRp8q9uoO9VZHr+zOA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54afe59a-341c-4e8e-2e1b-08db2ccee378
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2023 01:18:49.6121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xi4Jdrr41ED6PBKWtOv/qH0m7TQbqqQq+DZo6YBJ+ntYJgRyKq8X9mZiKb2GaUKdJzavkRSwMVgdxxDNqobSrJS42c26Zc85rv+zi80WT5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxlogscore=548
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303250008
X-Proofpoint-GUID: sVvSua4477dQxQtQOJ9HchC4epixlrgY
X-Proofpoint-ORIG-GUID: sVvSua4477dQxQtQOJ9HchC4epixlrgY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Tomas,

> If crash_dump_buf is not allocated then crash dump can't be
> available. Replace logical 'and' with 'or'.

Applied to 6.3/scsi-fixes, thanks!

[1/1] scsi: megaraid_sas: Fix fw_crash_buffer_show()
      https://git.kernel.org/mkp/scsi/c/0808ed6ebbc2

-- 
Martin K. Petersen	Oracle Linux Engineering
