Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9125BC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A7B6610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234757AbhJLUhz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:55 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:8832 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233748AbhJLUhu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:50 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJjn9h016788;
        Tue, 12 Oct 2021 20:35:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3/mhRrM6RF9QclpyoI4QC/9DW/nCcYSZ8+sV86zNADA=;
 b=ZA/TxtJ6zfSyLXC7kE0tlwCvvyyEfZXsmnUZelpMPw7d+W0hkTTkD/7HXVm+2HEOl4XC
 3b0uYScKP/f4d/nrMqB2cp8FZBImckvbS5uZ3hWHzjRJLYcCNuANfFu0VeDd2JftovE/
 gCl76GvGLRX1EFy9KLUKHXBPGHSYgLSS5N9Hkv5kWkpVcWvX3ebDj4gHsCHchUbv4KDs
 NQ/WFl2JNSODM6x2gbZTMpOlBkTZfXb4ygm5jao/AGR3JQPXihaZqeCljaf3kBcJiyzn
 B2zl394eCAsU22Lu8HzlQV0xPhxGjhGcPZSlO+cViKCNOzCD1wK4DCOHW0Appmv6Z4PA ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk9gnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ7M6009545;
        Tue, 12 Oct 2021 20:35:32 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by userp3030.oracle.com with ESMTP id 3bkyv9jq2n-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hbr9pNjVIsm0mYjlHCiPLCNAddjnYSWpNadjY+2BqT5KfA9DUyebgXYGz25cOEVUfCjR+OY+jx1Zw0W8T0LqT++uIfiVFY1ruS3XqZP7yxf2fvAZ4UZtI9uGtuUdnchi8hDDZu8CSu/flJ3GxY3Jo4ay/E2Br5FuG6WbFXGR7BKLdK176xQ9W3FgnM6VOzKwiyxmqwRsZRb7hGKovecjcye4ONkpQTQYh8vAKE/G51xl0q8nLUyleKZWO8ABDQNPu7+4Wu+YtO3KWVeZB7KT28uj31acFmQ/0PepGK2FwxUJbd5kTjXo/S3L97rOCWh2+8L0UCStVhzgJxl1+a1aaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3/mhRrM6RF9QclpyoI4QC/9DW/nCcYSZ8+sV86zNADA=;
 b=jhb8zIOMpKTewT6/O2Gohxw4gIgi+aAxzMOBRUA+GNNnLkMpPceJoTX/liLi4Vm0cimZaCdUTo4FhKNDZSPYeGjFdlJYPSnQQoJtTpvQnehkR4Fbrkr42POtMAp6jZRkGxV9FzBAzNYMLtlrV28PlQIf/lGOMNujpEoiJ7WaSSz0qIMuWjTzUmen5io2pELLjKtN/7cLagrD8uYovJsSt/Tx5/6UE2K3aP2xV7fIG64Vwd2IWqdh+qpGRgthE0c86SbV5jFfbofv4MKi9AhuMLA8fCbxg5MDrndlp2KcscznNDnMMF26rtI+DgpwFTnWLhD0XNlOKLkQnZPRBMOtkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/mhRrM6RF9QclpyoI4QC/9DW/nCcYSZ8+sV86zNADA=;
 b=zf1/w9jx5dfKYGUi8owFcHEva8fPiVXJ/MpXuV2Z/JsQFCKPgaXCzaX/mbiO0EDBfx1tbkAeHnfvwF0jOIDD5/upc4IAxFEA9+ZQeYlT1KstWMf+RH/aIf/CZUrHYNdp9DEAyztf9kwzQuKFV0JEQFbQ57atbrCh6ot3nvZ+jrg=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5514.namprd10.prod.outlook.com (2603:10b6:510:106::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Tue, 12 Oct
 2021 20:35:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Igor Pylypiv <ipylypiv@google.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Akshat Jain <akshatzen@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        Vishakha Channapattan <vishakhavc@google.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: pm80xx: Replace open coded check with dev_is_expander()
Date:   Tue, 12 Oct 2021 16:35:12 -0400
Message-Id: <163407081304.28503.4164600039848100217.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929025807.646589-1-ipylypiv@google.com>
References: <20210929025807.646589-1-ipylypiv@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 74654a46-1fb2-462d-1ebf-08d98dbfd53b
X-MS-TrafficTypeDiagnostic: PH0PR10MB5514:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55148AFAF126677294931CCD8EB69@PH0PR10MB5514.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:350;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5KHIRddvTAgZ/uk7J6B+E0xbjhz7f7nxn1AOEOH+Sjoauv6+4D8NZvxL63feEca/IUQr9FJSwoy2z7h/z4LWA5/yyP80lOsJV9l0Z/MGMh8X2clea0HlEhtd1tfR+F/kiKfjd0fjJNZWckti798JrQC+Da3tfzZw6UD8bupG0i8rBXuJi8VHQFp2Z/cdHI0FecHMlOWWA8n+de5hUMP7uk/PTHOysm1zmTiKAI9ii8253RQzTZ780KlqKpTgRrf1g2jQwM//LePCRXmnjNthUUjlUEiRYTixvcxIeuRrrPg5I7+diJAhxeIMwBzxKi47UOuxrovHdDYm/uU2TOKTzIMzlPBK+j7OcfakQFr/Lggq8cHQ8L79MTIyRVj/Q3PVGC7OtdZRU942aoe1Nfk6iDpzRNQ9EPHtDNRwGekXvRNAZs4LYKJEshmYs8JWDBT1Qybj7sm0Ff4hpNTFFG+I2QU0UAfozDYoIjkFZ6T8s5p5ljoebADc+0uyvs25IcKZJG0wKQMjC4+yVriOihh6Gwm90l20Ahjg7L2BAvR5zbuBjAuunqpSd+H73CnuWdFu54QmuVtTRVmuJ0WfyYZ3hjU21NyJK4QyH+SqUsXFALypW03g92rfKQAk3pYXkwHYrTI90H58xADU7h249b7bfawQkCHu0jMvCaSdYQLhtDOkn1wo2oIgl/oEStar/rYHPOmz+AuN47OzkG3VzoVQELdOjKEt+zld53BwXuhY+ppX0nFLFIiBkZhD4caqdOdhS2seapQTjhLwgZxrkKT87pc2BdyhzibnFgDtTUwnztI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(5660300002)(8676002)(2906002)(52116002)(66476007)(66556008)(7696005)(6666004)(956004)(66946007)(6486002)(110136005)(38100700002)(8936002)(54906003)(4326008)(36756003)(186003)(103116003)(4744005)(508600001)(26005)(2616005)(38350700002)(966005)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dS94dnZZRXorY01YZGNvdTJMeW5ERGFxcGVxWE5hSHJYenp1NGhjU1pQeU5K?=
 =?utf-8?B?M08yN01XTUUzNjdNbVMyMldHQjc2OURmOStyYUVFR21yZFEzUklnTmFoWTZH?=
 =?utf-8?B?anN6dU5PZm8xWmUrOFM4Z2daUGcxaS9KMG95c3dPNlFvK3ZVcVRIdFU4U3Jq?=
 =?utf-8?B?WjhhSSttNVJhMEM3N2RQdjI0RkhPLzhDZFhwWW5xTFhPMVFKT240cnowZ2hS?=
 =?utf-8?B?QUh6TVk1UmZWaUIzTW9VdUM3TU1SeDUzUkY0ZEdUdVF4S3Bub2FvcUE2aFlr?=
 =?utf-8?B?alQyKytMZG1Oa1hPdjhreFZEbmFURUJJbnNjd1E2dzN1NDRtMTNTcGNYNWQ3?=
 =?utf-8?B?Yzk2NklDcEdoTEdvOWlCUHVHeEt0bFZOWDQ1VUk5Y0FacXgrSFNwbVBib08y?=
 =?utf-8?B?dWJPRmNRWFpuZUhyYVdQa2JxYWdua2xHb0JWc0VYeGQraEcrWDlieTZHbndR?=
 =?utf-8?B?SFhBaTZQSllJOVNBdmZoN3I0MlZYbVQwRDExcksxV0J0MERTNEcrMWNaZi9C?=
 =?utf-8?B?MlU1VWYxOUFNVUVNTnlPRjdjWGpLWWd1d1Q0S0RiZThuVW0xTFh4aDhjcmhE?=
 =?utf-8?B?TnkxeEJHamdlVkxrNmhCbkQxN0FEM1JrRkdXa3E4U0NQVmNQRE9Dd0xIaWJt?=
 =?utf-8?B?MEZVRXYrbk1TQzNtTjc1aTNoc2ZSdXU4YmxqVCtacGFlTzlQTWxwc3hMS3ls?=
 =?utf-8?B?Wi8rdXR5MGthYW8xbFhhTCt5d3QrT1AwS1d6VThPWS9DUmt4OUJMZlNnazIy?=
 =?utf-8?B?aWNMSEFDYk1UQnVhdFV4ZXNndmFxZG9aNlJuS2Fqb29FaHBXVkU3OFNPT2xi?=
 =?utf-8?B?QkxFbTRpOFk3VmdNKzB6NGk0OXRFbGZKZnI2YTlJRFVoSnJxSGUxQzdrM2ta?=
 =?utf-8?B?SU96Z3A5aUdqd3RYbmE5MHV2RHUva09oMUUxVE85dFdULzVvMHlPcEQ1MlB6?=
 =?utf-8?B?ajA1bXRMK1Fid0p5YlN2c3JNOXB2MEJHTkpvREJuaTBhSFZJQ1NKRmh5SnNL?=
 =?utf-8?B?U2U0d21Xc25XSEcrS2xxdU1CWTdUSGszbkZNSzBXV2hZS3A0SUx4VmhFYXlR?=
 =?utf-8?B?N2dGdTRHY2ZvYzdXaklsN1RhZkszTzFhcjR6Q3NBNkg2UE9hd1lQZU5PeU5R?=
 =?utf-8?B?RTNWRS9jTjF6VC80MmxrUDE0eTV3d0ZLLzhscWp6YnBTZDk3cXF3bTEyTTJi?=
 =?utf-8?B?eGRSWm5OanJHRDdJWXgwa0pqTjUzcW10UUJrQmtTRWJrMlI0NCsvenNYMlNr?=
 =?utf-8?B?QVFLTThBbDRvamRaV0NmbEoyTnpVTm4zZC92ZDg5MEVCMU1CMmRzZU10U2ZN?=
 =?utf-8?B?VEIwZ29LZWpWODlRMTVVQXFxL3hCdHRuS2Evenp6ODBMd2c4eWc2NTQzQ3pB?=
 =?utf-8?B?Q2FLUU9MZFNNWW9UVDRIV2dkaG80dlcwU2psSVpNL0hPQmVHUHg2Vk9TRDN0?=
 =?utf-8?B?S0JKa2Jqb0J0NWZzYUE0MTQ3YWpFbURUd1Z1bkhVY1lzb2hhWEpoRG8xbldi?=
 =?utf-8?B?SkZlbjAwYTlpNTM2Znk3L3VPUks2c015TVhoMjFueC96YU8xTWpieThnZDJY?=
 =?utf-8?B?U0M2dzNHU1BVSnNjWU1LMkZUc2xyWWtwTTZMMkxiVUNnMW0wcUhNVFNZczdZ?=
 =?utf-8?B?Y2V2amxxT3E4OERrVEFmQnBpSHVhUnhDSlIzck1KRWpTOWpGdlBacitUdkxi?=
 =?utf-8?B?SGZVYktjbm5sSitEYlZCVldmbFJDZzZXOHM1Rkw4ZVJ5L3VUblcrcnpLSHdl?=
 =?utf-8?Q?ZF0FpQwJefUj/RID07WGeIuPdr2mw2p0WO+cVk6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74654a46-1fb2-462d-1ebf-08d98dbfd53b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:30.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W9jFvZKKufimy7yvVLcgtsOXZLlDZnrgWVCdpTYeMeJEFEhVlQRPlMm14silYcv9lFjhbsy7FAaEM/Rbf5qehy3ZoVI2RTYc+xOEf/2qO4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5514
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 spamscore=0 mlxlogscore=788
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110120109
X-Proofpoint-GUID: oon8nN1nq1ym8vj_Dlk0Hxhzr9IEE2zF
X-Proofpoint-ORIG-GUID: oon8nN1nq1ym8vj_Dlk0Hxhzr9IEE2zF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Sep 2021 19:58:07 -0700, Igor Pylypiv wrote:

> This is a follow up cleanup to the commit 924a3541eab0 ("scsi: libsas:
> aic94xx: hisi_sas: mvsas: pm8001: Use dev_is_expander()")
> 
> 

Applied to 5.16/scsi-queue, thanks!

[1/2] scsi: pm80xx: Replace open coded check with dev_is_expander()
      https://git.kernel.org/mkp/scsi/c/4f632918e7a8

-- 
Martin K. Petersen	Oracle Linux Engineering
