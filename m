Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B9A8C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B8986136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:35:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhJEEgz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:36:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52342 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229780AbhJEEgy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:36:54 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952oRL1024407;
        Tue, 5 Oct 2021 04:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=QNK0hVGsT8JU33vurRzvNp21TR57OgfEDsYbyXs3INQ=;
 b=HUfwreotaTUfjjHaWcYarjpStFiBHr5DOubLKCqgnX2Hg5PTM2BPnSINmkYWnyz6e6qT
 LAeLhnRgFWATa3CQ5TSImIoGY3iVKURcPgrOhGqq8yfQ42ZkLiGRpU+l8jAwVAQ/2QOl
 umglcbHvuB+hlwyI2sEwYFCw4LWkzdNBhi/X1kA/1wNcUuAnWBhJtLXuXa6mjKAqxIbZ
 dFsBiNeczBANojcJxIz+m14mJULz9b14qoz54ozK4noD6GcFJMGRW0HtL4rvHv/tLiZi
 u424ie1HX82DDGJgW1z8K+1cps3zUt+wvuHKNbn23KWqLj+RUZxOriycEHmgc3ngEtBp DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg454chm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UIIL054118;
        Tue, 5 Oct 2021 04:34:45 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hux-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c1OdJcyLw1AKae0kabemID/G84nDUsS8naanx4enSmtQCeprLaBWU5rnm5rb3MQZF9R9hJeUT6zso7rYIbnxQxUqVAmf9nvIMNOedZ8EHTx7pyphfjL8Dq12HIT6ZnPoFr8lHMaArS9o172R0xsA0QK+Y8KsfsEbU1vBHdZxkYEkhbxxWLXSS1U/hPoOmlCYsSVabBLULx+AhaUPBUycMgvF7js2Z2hDZq4YMX1+zcOFWHIrhoO2+/0FdxyDa1OH9CVcpR+UE2LuFP+4sLMB7FEo8ymt/vdrDgrbD/4eVzqMozKlzPYranGEnAnFrFgJEknmQeVZQtvAh4x4SkLZhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QNK0hVGsT8JU33vurRzvNp21TR57OgfEDsYbyXs3INQ=;
 b=ahU45/NWXW/BtQzbp7GjrLYHj1v7pCphZuZnCFbTbs5I6ViBOnU7jrxVL4DP73DExxNT5q3t1Nm359uOtbLMd2Tap2bHqQDfAMXpPcOeyoC6qb/tYhUa3/XBtBseVpUUbJxD+Xkp/ucIOF6NlgdkaGQ05OWuHn0/3JvOL/57X3Q+Xme7V0EgNzlrxMoaIoLuNizDie+IG45v+lPw+TxDIgibQYKqd2jnYJpysPPSz4RgyC1BaIt1C32vNAlOdAaKwfYa/lEkoZfhimqJKFUNEZaVy8li8oaeex9dX+sUd+YRtCj8bWyo7vmU1uBxKMyFSYnaDRYeYaFY7ugsyWmy+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNK0hVGsT8JU33vurRzvNp21TR57OgfEDsYbyXs3INQ=;
 b=qyKlVaI7yL3F/Yp0hEeanHgv4KPpa0YHSTS64ORCNGRQt+hGMW7eiOUi0crP6Y+y5IulUW2RAD82d5ZhkR+ACpn3o16mjIep1w02oxqGiH5cUHNqIXkZbKTTZi2L3vICtErIJM7EBTJjZ8pRwmgvHEHQ0x8bil8ZAXg/R86AQjY=
Authentication-Results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR1001MB2320.namprd10.prod.outlook.com (2603:10b6:301:2e::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Tue, 5 Oct
 2021 04:34:42 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Anders Roxell <anders.roxell@linaro.org>, jdelvare@suse.com,
        linux@roeck-us.net, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
        avri.altman@wdc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
Date:   Tue,  5 Oct 2021 00:34:28 -0400
Message-Id: <163340840530.12126.18445526303542936565.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210927084615.1938432-1-anders.roxell@linaro.org>
References: <DM6PR04MB6575F2F6841B0573560E10ADFCA49@DM6PR04MB6575.namprd04.prod.outlook.com> <20210927084615.1938432-1-anders.roxell@linaro.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf5e68ac-3f58-45f6-3237-08d987b97306
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2320:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR1001MB2320305D1AD9AE5BCD3E631E8EAF9@MWHPR1001MB2320.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vMyDuGW/35DYl4k+d9OKnhJSgjNLOnNdDzd2FP6W9NI2/dNbpm19nxSh9pxv24QZPIuQl3NfBYCq0beDCD26/c++xyRhsyXlSlXOxabMTIE3Ewl6KcxfpdHQe+HG/FKPuFnH/KSTMOEpAxxBCzRmOscsJrVw6L9KzM9ScIcOVBcbcFE4JUimo+7mPZKttZdRyRD2vtZpuTxkCU566DljB3+JzPSuJaQ8pstr7sThPV9e76CNKmVatwCFI3jYMiWXi99CmNaU1bW72vLP6MsE663j/8h9zFIAc5eieNuCm6Xm7NZxcMv8O5IJ8Ht02/6s1BgE8q2tcT76PkqLANID0+6OuthZQTpyphFRDoUfjsHi2T0Ej8Um1rBH2SNNnrpI+p5zGhqvFCmy4dbkcp3F3Q5vRpcPXGspaANnWgSQBvkXXPEF5G4mFRZrxA47IUi1dNM9LbdMb71kj1R2MKoly4so5lIdXUmMID+kWBZOjSaymvR8KEL038Vm8bWJAPK2Vr/z+AmuxsB2iH+TLv8xH8PU34TuCBoKKBHvphpb4n/sUr9iFMDqU8/pplU6TPidr47V3Uoa232X8k9s6HwMbLuKbGmVW6FRcKs0Olp1wyrKrPP7wsfIAMXhB89SVNHVSG7rKBxQr1hq9IbSUUc0eRP9YErF+vZWnBeYckWm9IauqB3WznilKKnsEIjdN9Wy26+IzHWd25scSYLmPHjyhy1rRbbf39iB3+nKMPw5jDAhz8sP2ADw1eMWPQhwTOBSRtMOlwlaOuxewKjnVaQN3KR6L2BXsFC3btJ39X2Z098=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(956004)(966005)(2616005)(2906002)(6666004)(5660300002)(38350700002)(8936002)(38100700002)(7696005)(36756003)(66476007)(52116002)(508600001)(66946007)(186003)(103116003)(4326008)(86362001)(6486002)(316002)(8676002)(54906003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UW1lNmRtWkdUUFNiYy9rNDFKWFV2NFcraU9lL2VodG5NMDFUUlY0d3RReGhp?=
 =?utf-8?B?TC9oOFVUQUN6R20zYnkyRnVaTjFHVXpmNE9wdGVNc3pMUkh0NWxaWVBqQnN5?=
 =?utf-8?B?ZW4xRWJxczgrWlpxWE5ZSmJoeTI5V3hIYkdLWDNCQ1Z4QThoL0E4V2RWR2U5?=
 =?utf-8?B?UGsxdFVjY1VTWllhandQNU9aTnVsTUppKzEvbDl4SWJxR2cyWGlES1NjTmNi?=
 =?utf-8?B?VnNKU1p5VWRLRSt3eTVFZUpBYlgwWEd6UzBRbUdzUmZ0L2pvTmVvNEVWM1lO?=
 =?utf-8?B?VExUZ0xUcHlSMEFqUFFMVHFEOERPNlh2eVNVN2ZjR2VtT3RTN2Vpd2U3azh6?=
 =?utf-8?B?VjlFTXY0OUt1NWJMUE5wM3dBY3JKVzN6WkNGSSs3WXBpSHJZNklGU3dDMnJQ?=
 =?utf-8?B?ZUJtRjZqek15MXdabUNJSThiTllLNDZ5K3JzNXB5MmhRUXR4d2ZXKzJrWS9K?=
 =?utf-8?B?d1d2dUNXaWIrNWVqb0RjRzVMS3VEQ2RkemUrVlFoR0pINFhPeDEzOEttejJ6?=
 =?utf-8?B?N1lobWpPYkN1Wmw4OGZNL1RSN3k0Wm95dHVJVnFiRUhEUCtsVHlNVUl3R3Fs?=
 =?utf-8?B?bU51anlXdFBiNXpJWjQwKzRLRmpUZW92U295dElXa01CSlJoZE8rN0pqY3dX?=
 =?utf-8?B?L096Y1RuV3ZpOGxQM0p0U0kxQmJNcDhTaGZIR2FIT01GWVVEZTF3aldHQjUy?=
 =?utf-8?B?V292T1JRb2VoV0ZBdzFGcVBGSk95UldCb0FOL3ZqaGhSTlR1NUtHam9QSlkw?=
 =?utf-8?B?NnBkL3RrWnpEN2JaWnprVHduVlBGTGxJTncxYi93YVBmSk9tdmpySEhtb3hO?=
 =?utf-8?B?czcxN3FET3hJUVN4My9DWDNPUVE2VFc0ZWp0QldaRHhwS2ZvalA3TXppaERO?=
 =?utf-8?B?dzI2eCtyNlJDRzF3dHNQNDJURTN5alFiZVRBeFJiUW4rb1BUdG5NMEd4ZEh6?=
 =?utf-8?B?aFdBQXFrckYwc0lKMEVXcGdNc1o4OWIraWprMDhuTkdsSlBIKzRjRVd0RENB?=
 =?utf-8?B?S0p0MDQ2N0IvWGdvaXVxTUM3aDdJRVNCUitZYlVuQVBGdm0ybEJHYmhJZ0tz?=
 =?utf-8?B?U1p4TERzVjNqTXRTREFlRzJYUTJodTU3L1dMOWNjeG83NWZ6MU8vV3VubjVD?=
 =?utf-8?B?OWYyZmhrbmxwZ0NHZlhiSGU3RC9qaUNPTWo0bzNjb2swZmwzVFRjYVRxdkpp?=
 =?utf-8?B?bjFiaHBmUTVoZFM2cmlPbEs4b1VRaEZ6eHVla3BlMy9PRG1iRFU3OFlNNzRi?=
 =?utf-8?B?WS83Y1djdnVLVEc4N3NqSTNEQTRGYitEVmNXdWo4NzNrQWdpWU5HNWExcjl0?=
 =?utf-8?B?OGhBUXVjVU9YMHNkUDlwV3l4Sm5tRlliYS9xNStqV1hBbUtsNDNubXFmQy9D?=
 =?utf-8?B?czBXcjFqaThlSUFLSXpUUGZLMDdVeEMrZnEzQ1pOQ1pZeFhkWDNMSXFObFpx?=
 =?utf-8?B?OGhFYWlYWm13VHhidTljY29uMVVGdlY5Tk1wY3Rhd2c0dzNsY09JSTYrcE95?=
 =?utf-8?B?S0RHRHFMMXdFSmFFeTBJbS9KdWJTNWl2QkdEd3pSaDZvWEVBZXlueVoxMkZP?=
 =?utf-8?B?ZzN5K1VPWU1jNXhiL0Q4QWY0Ym5sSS8vaXpZQVIvSGlSUElycTBVOFdtNlVZ?=
 =?utf-8?B?aVNuMU11OExxRTdkTzBDSVZWTDU2MzdkMTVHcThiNlFHL0QxWW9tWThIY2ZI?=
 =?utf-8?B?OXdaMkFtd1BydzZ0bjBaU0liNE1aQlFPVWNiUjBCSXhjakpTNGpvU1VSajNO?=
 =?utf-8?Q?ptBe3p2X53EPodfxMLyjnZzD9OlF58uIiTZhj10?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf5e68ac-3f58-45f6-3237-08d987b97306
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:42.0759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4LRgXtdcD3BPUkUifX0ss4p8vfoPqN5IcHX10YpTWFyZl3jZEIBeYAIjQZAkS22wr03dgP/dLkywZSXjUHcBIH8rwTlfXESG2zN97rCrbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2320
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=939 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: 2_eNYrtrA9SdwLbx_4suqVIuNL_VaKF4
X-Proofpoint-ORIG-GUID: 2_eNYrtrA9SdwLbx_4suqVIuNL_VaKF4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Sep 2021 10:46:15 +0200, Anders Roxell wrote:

> When building an allmodconfig kernel, the following build error shows
> up:
> 
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_probe':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:177: undefined reference to `hwmon_device_register_with_info'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:177:(.text+0x510): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_device_register_with_info'
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_remove':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:195: undefined reference to `hwmon_device_unregister'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:195:(.text+0x5c8): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_device_unregister'
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_notify_event':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:206: undefined reference to `hwmon_notify_event'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:206:(.text+0x64c): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_notify_event'
> aarch64-linux-gnu-ld: /home/anders/src/kernel/next/drivers/scsi/ufs/ufs-hwmon.c:209: undefined reference to `hwmon_notify_event'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:209:(.text+0x66c): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_notify_event'
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
      https://git.kernel.org/mkp/scsi/c/60c98a87fcaa

-- 
Martin K. Petersen	Oracle Linux Engineering
