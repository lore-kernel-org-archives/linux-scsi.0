Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7A79C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 22:45:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbiBKWpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 17:45:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234271AbiBKWpK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 17:45:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A62D54
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 14:45:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21BL9dgJ023170;
        Fri, 11 Feb 2022 22:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=fDS1Hg3E16RyaLVoGKjWmWWFNRJOMX/3GITY3DCE/3c=;
 b=yLVDawCANiz8odNXioqUJ68cNym2W/Q2q6BP+mz5xgtQhLa7wEaX0fSCeJTWucVdchS5
 gbj1ai8DcgKEfFeMXInZm+sC4pGWBTgQiENPDFBCf6E2n+zUNRrR/fdIaiaqGSdYlvZr
 KxCnuTntD/pzTTY10eba+qtQfjxwzy9ItwcrURp5AqVtSrUU1QkMqRXl7QOz8dyE+n9g
 MQo24u/k8Vw1/u8Oo38TxpqqfrKwz0i+IK7rGiSkdCwqDeUlEDLFzInQYtFvhAd7pGFO
 0So/By7Bn4MdjDs5K+ByDTBwwAak3R38sk2hDXuD6OHViK843gpejm7CFKfAO4S/cbAy fA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e5pmv9hcb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 22:45:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21BMaHiX166563;
        Fri, 11 Feb 2022 22:45:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
        by aserp3030.oracle.com with ESMTP id 3e51rw2d5v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Feb 2022 22:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQ3ITJGwlV1fRykSp6VGwXpQJqInOLwszvXLzBbFIYP9q86mpvIy+khHVy/mEQDU6ztsWXFW/sE/A9VvlzcYdE3QrDV+hLRjNhWVQNYiuyB+uimnOpQ3l1IgSSqHL/u38luYZ51wzcVFNIK3HPu8djE1q3zCcGDW97Hb/ZqnU4dUWLlo4o7bwWwxK4l9bmCJBpklwhq7Bejk9vtDYj9iSfsto5+2Am7dMucCfaRMyZLMLrhtTwuOtUnFUTHWtKjXt5ilsqKh0U6+qn5x6l7WGjyaoUk1+hJh6BFQP8bth7jJUlmyZADRko/Dkd7H7A6sdocSS40SXzwh5Z53ITzcng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fDS1Hg3E16RyaLVoGKjWmWWFNRJOMX/3GITY3DCE/3c=;
 b=bjVG4DDlYvUX79ltIGPJkDRYqXLAei3BVe/T81r+KmpMPi2ZrgJkCb+t8x3jJ4d59gwBcgISzKQjqazNG3Kb4+u3XvZXnNMWWC9uIYEnmM5S1G8hAZP/JMv+EC8QWu4QOpTGUiMLx30eBy5gcdvX0UulSFEYLn+B2ivViaG0GoOMyBb/86CwQ1VyLQ0KYs6No/iDSfX6C12c6/LUGkAflDJcvMN3XqS/+4+5mvxicuoOyLgUu96zQqFe1eKue03Hq5418nnL7zvCOt9LyZdyv/e25ED/qXgHtxDPucX4n0/H080y6NbtHw1ZR4e8kAQIZaVyvI06bNk0Ffvy78Rp4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDS1Hg3E16RyaLVoGKjWmWWFNRJOMX/3GITY3DCE/3c=;
 b=QRm/66xl7Pgc+8hT+9i61bYjt8I/cwhy/4RXyamygYHZPir1+6R7TpmIog0690B+vWaJtIbNrMvZgibpNUNvhF3tHz6gfJv/WwCDVnD/KyMAKx0OafAsxemIyPJ0GR/3aUUmx88Z6iTnBVTgWPg4Ml+TRp3NIHbq7z5OLdjVo+Q=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DM5PR1001MB2297.namprd10.prod.outlook.com (2603:10b6:4:31::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Fri, 11 Feb
 2022 22:45:03 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::40f6:dc10:6073:2090%5]) with mapi id 15.20.4975.014; Fri, 11 Feb 2022
 22:45:03 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        mpi3mr-linuxdrv.pdl@broadcom.com
Subject: Re: [PATCH 0/9] mpi3mr: Bug fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq135kpowey.fsf@ca-mkp.ca.oracle.com>
References: <20220210095817.22828-1-sreekanth.reddy@broadcom.com>
Date:   Fri, 11 Feb 2022 17:45:01 -0500
In-Reply-To: <20220210095817.22828-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Thu, 10 Feb 2022 15:28:08 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0015.namprd04.prod.outlook.com
 (2603:10b6:806:f2::20) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9434d025-1aa5-4eda-7b01-08d9edb024a3
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2297:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1001MB229752351FB8A75773D02A3C8E309@DM5PR1001MB2297.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VULySeM8uHnz20eGK7YrqRrT4bLmQyer/zAiE08Gy0HKsDeWsHJ8V4zV90LGXXsUtusSKB6rh6v9kWVRwEQXb31ENO3M+6xP7xgCwlwPrSGHnMLNLPLMb9BfvF0+l/ikLtPSBXeH9NEp+X2IeZBWouBz/v4c6Vd5cVAdjgebg1JYGfj8zof0DLKIUKOEuI9DPsPg31bragVu/8FrO3zE7etZl1mgzRpHOsBaKUMtmPWswB94IGyNE4dpdUSjK24XFMI8+tlN5rfjDj1mMD8VgDy8vtme1vy0CfrnkU04cQu1grc2y6AAOwtUBKxa9+mhOGLKyAFxUJVPwMF71G9pBcLAiVR5JIj8xZsw7oupSTDovog104bwh2qC0UOx/f/r6dZfKa2d+X6nGg/AimNqlZkstBOT9uxdyOoRAivDUvBE+UCLV5oFL9fjTQlu5Xnj/87kinX07EM+4Y4mS41IOgFU0D2IcgSFwCIq4qE800c0HZYF1Fni8UxqFwvphVhOtoHJWdw40ZRBoi0lCSmgqDBrdLEvm4P2ftcZeckaHFm/mihOfOr76H2q+NHweSQ6k9K3kPgASjzJgeNa24T6rN5eMF2gKHC8L3zDktRFXiYUOp9quSYbzsc9Px/HXiULCPx4KGCOjTZFUWj6kwGnsQMpVP7aOQk8nu+NnTF5fzqG1n08WQ28B2vf+sLs3xC/qrZsqaX3gEEZEA3egEW+8Lg9Tevrg80ctLmbod8wrmo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6486002)(26005)(186003)(558084003)(508600001)(38350700002)(66556008)(66946007)(2906002)(5660300002)(4326008)(8676002)(86362001)(66476007)(6506007)(6512007)(36916002)(52116002)(6916009)(8936002)(316002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9MbOS2i8zAXnAq96pDlzZ0azftq87fNlbmqA/1+g6HStLbxDlt/y4SeNo11B?=
 =?us-ascii?Q?QtgfrlQkoIVtQLYyl55fBtwOqzhVB9G75/Nbdc7vAo38pFRyjz0i4nWVJyfX?=
 =?us-ascii?Q?gYLX3odII0tM3iPAOA5CHDhSQVOmApgSEBZCTdVPG1kRaymgvWaj9uejHX6j?=
 =?us-ascii?Q?TxMY5kNl/WmrJ7t0W9qp6VwUGO//KzQKclb/ygZwCbZs0XOcxgfT2wtD3CDI?=
 =?us-ascii?Q?rHRe0xfVaBwxrEsMHt/obht8p2d0RYTDQpEK3p2AaVWnUQpWTV42/UycL1c/?=
 =?us-ascii?Q?LaaoEdekb9Pcf/gHKXJUvqOox9zhFG9SVvzyh1aRdc3fVlgSLbOp641oPX+Y?=
 =?us-ascii?Q?d6eLYwr9SFE78oedkUpJr8alxHPhsz0HlZmI8s50Ap9lgX1thOXcika+xNn6?=
 =?us-ascii?Q?7oP59IFUfhYVXivZV2kzDwdH+Oah8kUslsbgYZXPSc3eDh/x1YiwSGy6rcpt?=
 =?us-ascii?Q?RsJrzTh3jf1HO6zPbn//yHD/Ag+5ak+9sJVaKvnA5dtR8R77IvJ24lOj57VS?=
 =?us-ascii?Q?vuqNuuMAsET+e53rv95H4PRYq8shLgsZelVgNr1VwT/QffPZKanAyGx1VBne?=
 =?us-ascii?Q?GfmrjHO2kiWw2+XOWH1S+vffbkDQQuPYskDe//blV5fjjYYR1HHIritUOXnw?=
 =?us-ascii?Q?cDOepLQvuESt/qO1/2NyMQZghKifnkdroCjXVfLec2K0cexBCMgiwGs/7vCq?=
 =?us-ascii?Q?Cot77DT7fW2eKgbPIiUIC+TOaNg4lMfxaQ9cQhqrtRVKrMgTeHcblKGMVJeR?=
 =?us-ascii?Q?L+mgUwBWpgx+JUCFWsEC6CaQ7U/7Nka4B/a/LnHStJ0dD70NhMe5LytVuRYh?=
 =?us-ascii?Q?y9EBWpEjkoxHqW27ehFa+lF/2fDcCurIGkSpfuG/YumbM5LlJNcUHxiLhILW?=
 =?us-ascii?Q?AR9wOCtv97rAnUDFOLMyL6yMzX0SZGzGPC/vR94Zo1Do3YjZ5Qqwazsqp2o/?=
 =?us-ascii?Q?p6Dq0o/z10EwxJ6qjthFldCw9kVRtl86rp5z8Y0AqFdzN0QC+MgXdCtZWLki?=
 =?us-ascii?Q?9vPzZkEZs3bmM7NfOqiWVAWYwsq60Vuwvd3uA8UtJkUftqfTW9XMP7k6REND?=
 =?us-ascii?Q?BuszmO3tQXFJFkKclPoGitXnns7q/I5v+crpdIDebyJm87lVmf17+XqQnL0C?=
 =?us-ascii?Q?a6EConWzfwbpVkEyxglUYrhvUoA4N9rS4NJwvAqcZS7ubndIUFCKS/F7771R?=
 =?us-ascii?Q?WWEP+lqizNiEaCMHGzhWopL5SKYNDF9IexIrbIfm772cNCcOqCQvpEXV4GuC?=
 =?us-ascii?Q?TlbtiDQHuRf1vdF8reUFNz9qmMbNm3AY+jZaTfrnNKG44KGzBokUuAxZ5LnM?=
 =?us-ascii?Q?MY2q7hDcViiN/44vYAXIDJwi6iGJ+6ntiRfi/3gwZW67ilFupz6Fm2EoLMw6?=
 =?us-ascii?Q?WsNlFsWXjqN4GBTu9IWrPGmUZlT3nmqWAGqujoZ0dHhkErrIUOG/5zl3HqEV?=
 =?us-ascii?Q?/HOGpZoE3hgPWO8FUJN0BfBTWbkDtPUXZPkZH4ORO+CBQqXy6WljZZQ2Fozw?=
 =?us-ascii?Q?D6h7Fin3jYk8RrPjoVXByNlrtFKumZ+K+pNFF4qfJB4Ys0zMJevRHDZOB3Dh?=
 =?us-ascii?Q?a0nEw6iE/uzWuuTCLSMJUCCVEzHbTBcHPJRo4cH3gyLzKoVr3pqXRp9SjX0x?=
 =?us-ascii?Q?k90OAaEXDn5tRqPqQKU23UATMlB3LU2tTYIcyl3hWxGhtaBkvS3+bsk30yoC?=
 =?us-ascii?Q?zrrcxrlGIKB1oghRyr8gOmZeeGI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9434d025-1aa5-4eda-7b01-08d9edb024a3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 22:45:03.5293
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fOnDZvM/1H29T11bp+CvDS5MFjxvJ4wDvTW4+QnHzkOMwYehKw1Rx0nV7qK0lBfqcqg1R2cfznSqGF82EVVEFjdXYTEtsH+t8a2zgVIh81M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2297
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10255 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=651 phishscore=0
 suspectscore=0 adultscore=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202110113
X-Proofpoint-GUID: QG94q6A6lhoMc-Eurrf9gQwH7_R8_ftP
X-Proofpoint-ORIG-GUID: QG94q6A6lhoMc-Eurrf9gQwH7_R8_ftP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> This patch set contains bug fixes for some of the mpi3mr driver bugs.

Applied to 5.18/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
