Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC998C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F06A60F45
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 02:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233180AbhH1CdX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 22:33:23 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:38466 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233166AbhH1CdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Aug 2021 22:33:19 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17RLWN8i025353;
        Sat, 28 Aug 2021 02:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=imIrQ4D7JDcwQorL613OtZvVvno8QdciWJQuR/j7h9I=;
 b=CCa6PDPklZsul3H8K23BSN/C8yPsUmNgZUXSNteNAbrCXCdCKz/VUVwmUrgisPfp0YeW
 mN3ueXcbWPrBk/iJAsyO1aV+r4u78L9x5TakOTsVvhVVeJl78tRSJmF4Fro2FmzDWmsD
 DtK9Xo+yrcz3wQkleY3FdUy/xfK0qMhZOE9ngSyLsuzXEWrBzdNlIBtR8xsck4fBWlu4
 5nN2tWWqRiuQ6q+pPlC56188xQOpQqUWDqzS44oJqKX9+QsgDCqRJJ0rjjOzOGeHMSzP
 mWW6TlozB0Y4ZihFsP6wW6S9G5Ho/QwCbNHpvdPoWcW0pHz46Zes6qtnjjd+tYiXeTy1 wA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=imIrQ4D7JDcwQorL613OtZvVvno8QdciWJQuR/j7h9I=;
 b=bVnOzx/1jZaLdBw3UfkCuhwaFrogw7NQ40Y4rbwAWTMx+D8Y8uP4a/u4sTyvsO6+ytgt
 iqK1n23yOhrJaxX8FHD10SOZUjUyLpFcXkIjSGdIr6uTQQ2ngmsGMK69MY1DmX3FS8os
 8cKauCpjs2HxAiTLN/SbJsz29bAa0moLlwpJQSs0y8y+vqIzkQWrw6juGCj1tizzW3IK
 Pp5Te5xNIgI9sBjisf1+P+tfoPrVpDmOfyjRUU+VqBCxDKG+CYa720t0mv9kvHx+PXti
 Sxr+7fecCjeAoRZ6BgNHwusIL9/Aizvrm+vt8gotWoK2rV2EIhW24XLRAc4pPMLW0KiF ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aq1kvh56s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:18 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17S2FWlv139434;
        Sat, 28 Aug 2021 02:32:17 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 3aqb68tanq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Aug 2021 02:32:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TeIB9Id/Ex6f3N6Rp+oPlfkBfNI4S8szC6Zb+3bzgFrTqXWXmWedeg38INfeGy/3b7tybtSJ4RviUT2SKUqWAgeXG48owmdiWKUyuI5Xw1Tn+9W3FGqcYaGi7ZAYGqyj+cN6cDrpOnSol/MPYRsjmpSITBLO4Vv2FNcBB6Ts5V69DFpayJevXsIDNdRlwkjUvWaaSjxRN1dO+WGsuGTZHPs+Ru0/womyEUmrgBHd+y78Lbai9gNiquzGcICMAFe+gLStl/X6qleXbXGcqTQUvf89O7Q6N530rHQNQfrEUX40aGyQb7quwQXSgDC+TMfJy5sra9v9+DOf7dMLhSr6Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imIrQ4D7JDcwQorL613OtZvVvno8QdciWJQuR/j7h9I=;
 b=FMITzXiPMFtiBFOn1UiC/EhDIqVK5tnYABobPSFr/Y5+8115DvNX4Z4fHvtwyK3Qi4p96XBrEMfsCkzYPXhuUQjQqi+vODP70YwWd/GN1B/XwX11kfXqmV9ZZbKEoGTSYNWe9wwMoM+SXetKAe/YjEiHLJn0MUCg+N3hy4M9eTgttvf8W71N5sZDYbN8KZnUA2ngKT7KEXU1d9ZqPf1+lASbTUjHGJk8u//Za31F554syBmyn7nbL0J25cCXMbqYh1dKfOj6qUMxyNyPuudLmqZ1U/oKLI8BsgZlDioBduruULC4GTwN9KSc7JIh3GCQz1BPV0eeAV+3IEnH6ogzqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imIrQ4D7JDcwQorL613OtZvVvno8QdciWJQuR/j7h9I=;
 b=N3kcYx+4qw6EjSmtnyp1OMKTKhTmEHSGg9+SUrwPi+L8bShMV4q4SlZ6JhRrE8uEG/43cjiOWUh0QXRqS3fKg9HhlM3ZrX7yF3cG+lTMZ/Lxi8YlU4gH1p3r31a8X521aVVsfHUuMJkYWY0Q9q0KcVSaOTfqBDMH9/ZiidclbeE=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5515.namprd10.prod.outlook.com (2603:10b6:510:109::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Sat, 28 Aug
 2021 02:32:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.027; Sat, 28 Aug 2021
 02:32:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH V3] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung KLUFG8RHDA-B2D1
Date:   Fri, 27 Aug 2021 22:31:58 -0400
Message-Id: <163011776502.12104.10452472377764901446.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210824114150.2105-1-adrian.hunter@intel.com>
References: <d5f5552d-257a-62ee-f0a3-55c00959e63b@intel.com> <20210824114150.2105-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR17CA0025.namprd17.prod.outlook.com (2603:10b6:a03:1b8::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 02:32:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f02f8ef1-1aff-4e25-0803-08d969cc0c17
X-MS-TrafficTypeDiagnostic: PH0PR10MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5515285FD6041BC8FE558DE08EC99@PH0PR10MB5515.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DKqMhpXcXFNK3LA4aSys+TXBivGyxRSKGMQ6G2iWGh83akhaINBcSXxahuTaQysgigDFDQXoXIWEqiu0spdjYc0W+nSBMjn8hBJGLEpAuXzu7QKfy9oT3RIN8vCCar9awT4iqWRrJiRCRoWyuxBku5yx/dtjoVowDNZD0wamMhbU+V8GY16medCWaFeq46rF/IN+zt8kQCkYZaOiwKLbKEf2/T6+08ynKriiJTa0zqPA1i/SnES4b5bgtWyVOB7m04/mz9WXUwuZlhjueRSUkgnqkTDK/bjywococJJwqXaR4jy4kulo3AFyCotM9he2ER8dnRBXYtrFsk8guWKj6A9tOJAc9Dq875rl6W+mWjHeTOrFfED4BAsf8v586WyEzIOpOv9x32LZrsGvNAwBXdxx3wVQxUF2ywExFpMpZN3DY8IkxZp6J8Ct9YLOQW5ID7HI8JUeGvPzTjIxLpugT1H2Q1yUVbybImXoPwcjxRb4q0EatInpmaBcyvOhmlMYG5LSeBXYdSNYO5bGeMgg8EI8D0aAduIt3C/L/ALoTZR/02nAYpcfGS+CW6uYcHnEHgnKq3sPJQvpr+Yyhp1m1ek1D5wXe9+7HwnxZ8Vi6dXCsopfD02/zuzeeGaHl8ek9sry+vk7kez9GqUoAk670X4JAh1oE/ukrCcsHzEXFLacGFMHtuXntIYdXn5U/Tj4LmDA7oe6ldywcAraUOxLL5ga0EbcVJkk0d3bkeZwZ21xKng60lljNE16ximJQ+9ah0urjcl2QR5L+LrwgdH/K1Zi18pd4he0bdVvkxogdrXA9h4865KUWnDY92fn23j+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6666004)(966005)(5660300002)(2906002)(508600001)(52116002)(38350700002)(38100700002)(4326008)(54906003)(7696005)(316002)(36756003)(186003)(956004)(2616005)(6486002)(26005)(8936002)(66556008)(4744005)(6916009)(103116003)(66476007)(66946007)(8676002)(83380400001)(86362001)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2FjdS9qUndBakJJWUt6R2xkYnl3THFBcUpFWXd3bndISytLcFhBTEVmM1ZB?=
 =?utf-8?B?V3FHaW5HSEUvcjRJeFlWRzRZa2gzelBoYVJGODR2TlNnK2tLM1c2MjJaVjdw?=
 =?utf-8?B?L2JnNTRGVTdPUVdTMmNOS1JPRnEwYmUxaWJaZU1JdnZVQTBTQXJiL3pkdFcv?=
 =?utf-8?B?eDJoR3poMEtrUmFPOTF1OU9ZTWNiOW5KQUUxMGVka1FacEhFMWxsQ3NocHpj?=
 =?utf-8?B?OWhaS1huSVFPc0hIQ2dCWHpuZXdTeVhkZlZ3MkpoUkRwL29TbmlzUzJWbmJP?=
 =?utf-8?B?STZvc2l6WnBGVnM0Y1g5bkFIMGh6U3pkaktoVWhxWVk3N1VUYXppdTRGUFVW?=
 =?utf-8?B?dGlLWE1wRHpEL0szeXhCcnpURVlIUDhaNzNqSS9pZDY2cDg4cEMrQnFrNC83?=
 =?utf-8?B?bGlSWHkxSlJTaUxPUG50eHRsNjM5QkZaQmVlMXpGSGxuNHB1RjRKK283SGth?=
 =?utf-8?B?UHA0c0YrVzNESDBmY28ySzNURnZYbThsZklPYjBCVURQTjkrUjBhZGhORVF1?=
 =?utf-8?B?K0JxVnljUTA3Q2dZc29ESXMyTkVDWDVkVURSWmxFTHkzL0MrQ0YxSmQxU1dx?=
 =?utf-8?B?bWthVldMS0JiTGhRQzJWcW8ySFBoSUhKdERCZTBIUGtVSys4LzZRemRsWkF5?=
 =?utf-8?B?eldqWVVJZTNiK0RrUkN4VWpWd2ZRWmhmOFB5UFVnbmQ0L25BVUNkR0J2eis5?=
 =?utf-8?B?eHdWM2VtY1BuNEtKZ0psbHlPQmtZaU90ZnFma0xjYmhraG8yUm1UQ0lPTzVO?=
 =?utf-8?B?QzRZZkx1YzlaU2hJQmtMY29Ga0xwdzZBenl4em5aTUZYeFJuTnR2OGRGdW10?=
 =?utf-8?B?Lzd1aThMZEFnclM4Tkk1amFIYUFkUkZSandBTDA1VTJzL3pzL0U0ZHQ4bldH?=
 =?utf-8?B?YjU5cVhaTlZwY2wwYUd5cytRaGpxWWQwSUFHUG9HWFFhdXgzS0VvUG9YYzgx?=
 =?utf-8?B?VWRxWFJQbktXMVBXZUdrM3hkQlllbFcrRkhPZTY3Y2h0ZUdKL3MvSXAvQ3Zh?=
 =?utf-8?B?emxuOW9OOVdyRXZ4RmxFQktQVVRMTWNHRzdCdVU1L2J0eFpJQmNBaXY3cGpU?=
 =?utf-8?B?bWVKS0ozcWEyRHVTNGFaSU9vcDgwWjBhbXRyYkJLWnIzRTRQbVVjejVmQkpk?=
 =?utf-8?B?eWxNOTJvNjBJVkZkSHRFTk5Xejc2THlXOUFNNkhWc1JQd29uU21YZ1ZRdFho?=
 =?utf-8?B?ZkRVT3Q2SW8rRVQ5a0VTWGVmcWpIcWdkU2dMb213ZkRNdFI5YlNMWmhkVFFn?=
 =?utf-8?B?alZFb2crTjA3bTRiU0NxK1c5NTZUdWRJV3RZcFo2SUdKc052Z0g1VmJYUDB3?=
 =?utf-8?B?clN3M2UydzZScE4rcXgrVjROaVo3RGZZZDAzUTdpaDY1clBqVVpaZUY2R1B5?=
 =?utf-8?B?K1R1VlhVQ20yZkJOU1pXcTNqTDRnNkVlRThYSHprVGdRdTBzY05ZcGUxYlNa?=
 =?utf-8?B?ei9sK2I4eG1mVmlZV0tRUnMxKzNuUjV4d3JGa2JCSTJubHh0blZMNXltSEZj?=
 =?utf-8?B?eU1HMHFDOGRiWEJaejVkSHczbXBxM1hTM2JFZFhtTnZpblhhTnJvYkhCUGxN?=
 =?utf-8?B?TEVHSHR3QjBoY1A4NW0reXBmQnlBZnovVkcrSmlGY0ZDNVRsaVJ4WEZZdk9D?=
 =?utf-8?B?RUFrTTN3aDU3cjQ0M0tFOVRVbkRZQ0ppNjk1RGJYZW56QTU3aklCWUJZcXFY?=
 =?utf-8?B?U0l0c3JSU1ZucDl3aVJLcjh2dEx6Z1I1YkxOTGF1OGMvU0JhQnlDT2lYdXJP?=
 =?utf-8?Q?8ZJ0Q0dDJr+bVInkixv68l1CWYij2mygYM3ICPw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f02f8ef1-1aff-4e25-0803-08d969cc0c17
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 02:32:14.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UnT3/YBvz49DKg6VP8Aww3Hv7DocP0Atx5q9iX0mTmhNeFBU+L575r2bLjLEuQuOMSOdT57lAP1bksO0B5g4VsudsYI34KGtj6YJA/ltx/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5515
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10089 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108280012
X-Proofpoint-GUID: fHfX2uYEkP_UCSK1PfjXneZnYL98Dny-
X-Proofpoint-ORIG-GUID: fHfX2uYEkP_UCSK1PfjXneZnYL98Dny-
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 24 Aug 2021 14:41:50 +0300, Adrian Hunter wrote:

> Samsung KLUFG8RHDA-B2D1 does not clear the unit attention condition if the
> length is zero. So go back to requesting all the sense data, as it was
> before patch "scsi: ufs: Request sense data asynchronously". That is
> simpler than creating and maintaining a quirk for affected devices.
> 
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: Fix ufshcd_request_sense_async() for Samsung KLUFG8RHDA-B2D1
      https://git.kernel.org/mkp/scsi/c/9b5ac8ab4e8b

-- 
Martin K. Petersen	Oracle Linux Engineering
