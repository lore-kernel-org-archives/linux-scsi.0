Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EAFC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E851C6136F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 04:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhJEEgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 00:36:45 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43020 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229659AbhJEEgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2021 00:36:44 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1952UGt8029448;
        Tue, 5 Oct 2021 04:34:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uE4XY+bHuzJ/TPCrDtqlmrFg99Q/yavvC6vSrIyS2+k=;
 b=P6+2cEpjFgGNgNY3XUnFapIL1mqCpuuXLQ45jXZlVVXHb0OgKyj/FdEkjQuAsQwNYp82
 Qn2ED1sTlVS+2oTg3Ljsx9+b8GSi55EPLcSM0fI7UHandXBUEKwBgs2OcGsX369QNZnK
 QJjhgXy1xBmi7MLsIP7SVvi1HV9g/3pah2vN7kMSr/r9V/jGlgRgNZHXuaVQrXemsO/Q
 hHqqpDYmsWUP6PvHJ9KC8tw5r5lUIs0M2GcO1JPiOPkpwreD19b48rzcbjnJTH0Gq3iZ
 2dDk77Vok/+l8JWEcgy95h4o9VD97fK4ky6g32u581jNfUTId300Ou2Fs683FAGuiSq0 kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg42kmmpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1954UJMb054346;
        Tue, 5 Oct 2021 04:34:53 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w4hvq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 04:34:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AB0xeAyeJLrBArTgybxmZjq2ON14NlsXuvzGemDNkbFMFPyIjDYxNEgH8Sminr6kd6hvpNf89+Au1cbuRubg3aR/ZU+F2lqu6ejOrofWydX8s6bzkZxiK0lOFhvK4RAAcA8HoMalURuwzeI1WDKXCaiW2S7CXdnB/ikwhCbWgh6ZzjxYP6F6mASY8q6CI5+QOO2Wh0gG5bykHAqFNHwYG/Sw9pr7TELISLkp0uXOY+QADgIkCYHTxgn5fAoGWdJxE6mKP0TUUjqhECotJsRDBiEyZlppEkXdRBNeRiuYuRSFOMbUJoTwvzKMUe+OzP4o59j5oH/paDFn5rjOM+zbcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uE4XY+bHuzJ/TPCrDtqlmrFg99Q/yavvC6vSrIyS2+k=;
 b=CgUPfF9dwsZ3aVSM/9iVc7Xarn6jcXnFa+etjW0Bxz+2Qf8tjOn5tveEg7dzl91ITVKybBCwSdDyuhFBIejtduh1wYX8OrnJ8a2Ct13+BaF7sdMPu+C29h74fq7g0XsYFFDWqqLtpCIt0Gz8Yi1KxfXv7ZvT8HeB6MbU85u1e9jO5IZgyOmGxJSd4b31ZytBs0ExXirke9NOFc53gb8OCWH8f/l4Zf38++wq9FDsbMEWMnXB3zEiMg5isV0AvLk8iINOK3ZAyh2PP1N3VqEGLWVR3DCayzbABwu8zmt1UEOwD3hzB2mj35jMmSWDIQ88eyWN8jvTpzD58Tg3FFLlpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uE4XY+bHuzJ/TPCrDtqlmrFg99Q/yavvC6vSrIyS2+k=;
 b=ZmH7Op3IndTGAxRS8Xmcasb57c2P+3iBiap0E6py3Pw+tRtAS1TBntq6EUKaGjrpVxX174CRj3YHYmt+91dh0XWXZ8/PxDoewEyx63hyYJIY0NwbowvCRuVQJxB124K1sJ9XAI6N/yiSxHddBkWg7Bxt6aYR9WrzKJyEFslM7eU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1950.namprd10.prod.outlook.com (2603:10b6:300:10d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.20; Tue, 5 Oct
 2021 04:34:50 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::69e7:b722:cd67:85b3%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 04:34:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] Fixes for scsi_mode_sense/select()
Date:   Tue,  5 Oct 2021 00:34:34 -0400
Message-Id: <163340840531.12126.6968820627705525515.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210820070255.682775-1-damien.lemoal@wdc.com>
References: <20210820070255.682775-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR11CA0001.namprd11.prod.outlook.com
 (2603:10b6:806:6e::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0001.namprd11.prod.outlook.com (2603:10b6:806:6e::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22 via Frontend Transport; Tue, 5 Oct 2021 04:34:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fce7cc36-1257-4f3d-328d-08d987b97818
X-MS-TrafficTypeDiagnostic: MWHPR10MB1950:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB1950152AFAA44121546223198EAF9@MWHPR10MB1950.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/vpl1DfDrJp3setrSqhWTo1TKOXdbR6eW1dLQGx9Wyr+0XAnTFUIxm2wnxokSncN2FWzUgy/6dSEqNbVC6ez3E+wKnKmbEulloKTfPHjaoMRHcBoiiu8JdxaUJiVV1dIDqI2c68zYPGfKlK1awHFkHGx5NUe0fxkzz0wXwm4Ta5jMF+vWYFW5jQTwmZ7yVaAks8TvaNUkop5j5xut86OPpvXFh3jE58go1rE7iEUb0OurrR7k4sMqvHZlP1XZEXkxC1ybtypt8J/nCUE/4NIPSZkr2IVXdWfu3z+JttLHGaGM4pxPclS+ts/glGVk/tXlwXmEvl3+6P/gzVw+EGiFARBlQXo0HE1pTHa5I/6qFcs8nyNbBNpKmsw1WvK9VzklekzNlUihzBfgSmkWWY7N4bCDi7Sgq6Tu4MBWNZOSeljI+PfnFdqAs1RjxLMiAHF97tYgt/cORDGWmGHgWTNSett1QEzyNI3IoKfsxOA2sakwIJgLDdfsXaDqvqbKAoLkcYtd9mzeRBheqM6fHP/s5Um1fUXzL6VnAFkzt4ARvEpJOIE/o8JKxDggrgs3U9f7/whyipFYBEb/lJej92UcvL5fp9y0ez6v6NNBsyPmFPl9tLDdrp/ZgO9H2mQ6aRFn/cIrMJ9EhYH8pdh/DupZ/EEF4Kngb9xR9SNA+yclIYcWd9MhqdR4yxW7NYw4sGX2QURXH90iNk2H/wDb5FgY8ahyW4Bgnw0PF3s0wQNl27uhhxyQ09tcuddOvR3czQXkAs9MhPG4Pdbla3WEkm3lzxp1LjgZT0cJFHFYZxZXLu6qbSeBsIgj31rSh5bVtG15Pl5muBSZf//MpZIKydtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(38100700002)(6666004)(956004)(5660300002)(6486002)(36756003)(4744005)(38350700002)(186003)(83380400001)(26005)(8936002)(8676002)(66556008)(66476007)(103116003)(316002)(107886003)(7696005)(86362001)(4326008)(2906002)(966005)(508600001)(6916009)(66946007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXo2OVBhV0hkVFlaMTIxS2pqMGdaQStEYXZCMnZib2J4VWg5ZElIck9KMGpx?=
 =?utf-8?B?TUhDdm5tT0EwaUJvU1FDZjZyZ2dnekxTNy9SbWR0OERWM0x0cEVaV25oQnNI?=
 =?utf-8?B?YzZ1aGtjT0VyYmZ2UUxHVEZNTmp0aTN5SUZDVVYyNitoMmg3bzBXbWV6Y0lP?=
 =?utf-8?B?dW9RdXpqM20rNkQzZXJLS2Vja3FsNUFFTXZaczJHd1ZtZWRBYjE0ZjF2cDhp?=
 =?utf-8?B?YmdpTm9xVDVVSThldkEyQnBtWnRMaWNGNTBEZ09tclZGVnRlQlFNY25Kd084?=
 =?utf-8?B?bVJwK2wrNXlMbHFmYjdVMzBlTzBITGpQTFUzMzRyeGUyNG5UbXNOWDFBYmVC?=
 =?utf-8?B?YmppVkVBaDhLSmlVYXFEM1A2anFCQkplaFZhemdaQ2Vpc3VXTmJJcEdCZjhs?=
 =?utf-8?B?Rm81V3RUNTVYZHdXaFllRnhJVUZPcS9aTWZpa0dXaUh4dThmWjlUZDhtMStq?=
 =?utf-8?B?VHRIa0Nyd0l4NE9PTTNGdWdVbjVlTzVqbTFhdnZsaGUvQjBaenUzVU96UHVZ?=
 =?utf-8?B?d1YwSDEyTjhWRVNmRlVwYVkyUG9XY1E0R3pCUENIZ1BkcDZtTG1tU2picHo2?=
 =?utf-8?B?VUR5ekFaYXhibmFKR1NtYVFsS2RHRlBZNGd0cE9sNnB6M296TzhaT2h1QmN3?=
 =?utf-8?B?c1QxOXB6NkpwVSthYUhMQXAyNWtXUmhDc0d1Vm5UM2dSeTRwb3p0Y3BkbGc1?=
 =?utf-8?B?N1cyTE1TeHM4aG5HOGNHVXJ3ZnJSVDVmRXZ4VkMxeHZhZzhjbVUzdDdnWlY5?=
 =?utf-8?B?ZDRTc0Y2dlBuT3RUNDV6K1B2UVlqTGp6aEpmNVFCKzNaOS9XalhkYVNqL0Vk?=
 =?utf-8?B?UjJFK1FKK0NyeFJOSmNIMmhRRS9KQko1cTlYTlZocmVzUmV6TW5WdmJNcDZG?=
 =?utf-8?B?VDREYnlUYU5LSHBIaHVVTFFmRmF4MkZBcUMrN282WE8yUy9hKzhOTXZXSGRW?=
 =?utf-8?B?ek9sdGgvclJyTSttaWlGM1NkSDRJSlkrNXVGNHBIdDVoUTNza2dHTTFObUR6?=
 =?utf-8?B?Yko4eHhqRkc0eWNQT3U4TUJwSSs0aFpZS2U3K3dBYk5zZVFDRVJzL3ordDc4?=
 =?utf-8?B?NHlxaWs4V2UzVXlVUkxiTDZxQWJkVTRZQ25xUml0b3I2RFlCNUpyYzZCRjE1?=
 =?utf-8?B?Y3dxSUFzTUlSV2UxdXhQamlEZWR6Y3NIWVhjUmtlYkl5bzlFTUgxOW9NNDFV?=
 =?utf-8?B?Uy8zV0JwdXRVNHQwOG1PRU5Oa1hQTXlxdG9vUjJ0VU5zZ1NRbGFqeXJlNGlS?=
 =?utf-8?B?UW12YUFpSmlpWjNBUmw5MFpPSXBOTWV1QzZxQ1N6NE8vRk5GZG90UVpuQ1dy?=
 =?utf-8?B?Yk9nSkVKbnJIQ0RTTnhSRWZmdDFpSXVFbVY1ak1qVWxxb0lQUU5KL0Z6dmN6?=
 =?utf-8?B?MEJXSGtXaVN1QnFVeklpSU95Z1RlMDdaYWx1eXRkK1VmS0NkSkJMcGl1cm1L?=
 =?utf-8?B?bkZ6UWp0VVN3Qm44TnA3OVJYWlFkMUZKUEpzWTlZaGd6UjMwUmFMR1QvQ2ll?=
 =?utf-8?B?ZGVFTGJHeDVWV0RUYmpWSG12clB5Z3J5bDNtamxwc3Q4YlVMWHBlMFZVdHVl?=
 =?utf-8?B?R0RXc0lDMnFGWGdIb0pBN0JZWnlOTFdycGFHbXlwNVJ2ZFBSOEo0WU9LSWRx?=
 =?utf-8?B?bllQazNuaWV4cS9tL0NnTWxGd2x5OEtPS0lwcnkrcTM1NVU1c0REcms2aXBt?=
 =?utf-8?B?Yi9zdDdCbytNQUI3Vm00MXFveSs5Q3IxYjBLcmtSMk1xR3Z4cU1HUU5xNzFx?=
 =?utf-8?Q?yewiEyscSvTyfXteFBA/1CAQGUl1i+Uf2k9rT5o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fce7cc36-1257-4f3d-328d-08d987b97818
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 04:34:50.6243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GjjJ6UlDBTupGFSdfpuYuzwgic0JGN31ihRkjNWx8BsQ2mQNepnk2/8hV1g14sVE0+flDjZ314O663DBs4mcwvmraZK3yLA18E4l7P5Jdcs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1950
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050025
X-Proofpoint-GUID: aPWYhQ3tlNnyRxR8936uLfjzdvEpcjjj
X-Proofpoint-ORIG-GUID: aPWYhQ3tlNnyRxR8936uLfjzdvEpcjjj
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Aug 2021 16:02:52 +0900, Damien Le Moal wrote:

> The first patch in this series is the formet standalone patch titled
> "scsi: fix scsi_mode_sense()". Patch 2 fixes similar buffer length
> handling problems found in scsi_mode_select().
> Patch 3 fixes the use of scsi_mode_sense() in sd.c to ensure that calls
> are issued with a sensible buffer size for devices that explicitly
> requested the use of MODE SENSE 10 (e.g. SATA drives on AHCI).
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/3] scsi: fix scsi_mode_sense() buffer length handling
      https://git.kernel.org/mkp/scsi/c/17b49bcbf835
[2/3] scsi: fix scsi_mode_select() buffer length handling
      https://git.kernel.org/mkp/scsi/c/a7d6840bed0c
[3/3] scsi: sd: fix sd_do_mode_sense() buffer length handling
      https://git.kernel.org/mkp/scsi/c/c749301ebee8

-- 
Martin K. Petersen	Oracle Linux Engineering
