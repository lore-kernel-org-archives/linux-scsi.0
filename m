Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F30FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BCB9610A2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhJLUhs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:37:48 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:3146 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234047AbhJLUhr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Oct 2021 16:37:47 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CJo333016821;
        Tue, 12 Oct 2021 20:35:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=4WL92QwF1sJ7OXH3k9zyeC9mtupQX01teIr2b2mUpEw=;
 b=kO4FQIl09mikiG818Oh1rBWxT24+wn23zDjdN1CHVy3C617+4xskZKBaMa8Q15sZNJqW
 tpY76p+XSATUXHx2B4l6fidKpk4vSSoHDaInZgV7WWwbGggnWbdxcX0MBgf1JhS2v+/d
 0KalgSqlFYvaSu8F0gUojjEhh8UylWgRevT97BqIr+9+pbHP5jBLXj+6+YGSA4byZtY2
 P56OJMVldNuIEzCq8TiuSPhnv/iF11cIYoBdcetpmiuag8GG42fwuxCuE/YwUuIqTf6x
 NjSM7JEDlph7ASuI6PoM4tHfWKUN54W/wq5mOcDoLC1pie2oD7sw6oFgGLIs7D5E5cpM 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bmtmk9gpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19CKZ98i018006;
        Tue, 12 Oct 2021 20:35:37 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by userp3020.oracle.com with ESMTP id 3bkyvau7n2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Oct 2021 20:35:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rwv7i6tILPwUIlXyj9Dt6tTQqjdTm+ddBvcxAsKulJKKGWBZjIbL+b6KCz0rNcBCHmniBjfTnhhIrvlvZ64bQxiutZsJvEhPElLQk5T5bPSIrnWSfuuXi69fswHybutfHf7lqiM5u0FbeffTPf4b/aITkzULceowGqlbo8jou+KWskDrO1PXzaZPeV+b+jrIIinc4+fedfHoWRc96mDRAqcsG5hcGtiVUSHfeODyKyVxJiaq9zkzQMbPy9gvD2KZx6dq1bUL2kgI0q2iRftALR3dNY+XN7nfGWST9vKaAACcWMNTy/ATmmmMOuVX1usoLtJnlGokHuv+kvR90kKA3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4WL92QwF1sJ7OXH3k9zyeC9mtupQX01teIr2b2mUpEw=;
 b=X8kuXyzwhVLXjmSWP1s26tpycKgyhTi1y2ZlUqCpr9oiN9HER8OeJNEXNpfQA+PmdP9oqS8seFtpmlIQnZ28KoyCfOE4v1l5ZZC8pfbjaAslCwDlmkv8afCEDfr3ciIsIYpIC7tXlLZvPk5tOn6k/6M/zgvE7Rvr4rHwMrUnaLxVWZpO4Z3n31zxgD8P4zVIBwk458I31ckzAs5mzJRdw+pFgCxTkcYJ/Nrdff86wt72nsnSKY5d/9niku8sue14VidpDJgemYuD2hP5zSH0JP3fPIQIoxwqTj3F261Yw8vAt3zCW9TQaLtMVJnTKCt3u0f+Af/hctGJpLDhSVrbBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4WL92QwF1sJ7OXH3k9zyeC9mtupQX01teIr2b2mUpEw=;
 b=aD8k2SsGOpMwe/46TyFwJjQdEkgTh92Uv9QahEFBEB+8YbrlcEgsMotRFrX5KJvjw1iPi65phPQBmP3KEpAFS573oRvRlRjynf91Ys2pzrNDiQXCaBIPR+xM3wfbLwkMthXXpaBr/aRZ3XqeeCQ41XHaiS/XELF1oDEJp5DHRF0=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH7PR10MB5697.namprd10.prod.outlook.com (2603:10b6:510:125::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 20:35:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 20:35:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Konstantin Shelekhin <k.shelekhin@yadro.com>,
        target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH] scsi: target: core: Make logs less verbose
Date:   Tue, 12 Oct 2021 16:35:15 -0400
Message-Id: <163407081303.28503.14772386529442220542.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929114959.705852-1-k.shelekhin@yadro.com>
References: <20210929114959.705852-1-k.shelekhin@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0801CA0022.namprd08.prod.outlook.com
 (2603:10b6:803:29::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0801CA0022.namprd08.prod.outlook.com (2603:10b6:803:29::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25 via Frontend Transport; Tue, 12 Oct 2021 20:35:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cf919d1-a37b-46f7-8134-08d98dbfd738
X-MS-TrafficTypeDiagnostic: PH7PR10MB5697:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH7PR10MB56974772B3A47B92B841E92A8EB69@PH7PR10MB5697.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kxn9lOJCYMT3CQnhsN1Fjv6AKBCdSKTxCJ0+5EllAVp34AtzvzSsKHst2yuIIDSJiHJCZOH/muLlBBq6G2JxwxqDf4tOyP4fjsaWKL6xmszefqiJSe0GFBzmQi1Tl+110PUlx4wJPW7DR/CDTYgT1seCZOuSbx7otLk/SWEeG27E9+kay5IXPT/TjJKtWABMRQu4zyfEvpLK9G3ndXWJr42tJGpNZxVcxhsaIysd0Rmzn1rkoZnHbnfsO5/0NW7oUJxnH+1ZrIJNAedpfkE18MekAXcmtqOyUdzU2HcSc6cnlhzKqmRsYAP+ineNwLcZx5j06FMrl8nv8ZLDZs75+p1eD9KiV4IR44rE656o+9C6/XVhLOyiibRmojfh8s1SCWmU79NJmBDMHI7E4+0z75XeO/7yKPVuiCfNrjMtnLH3pmYo+0aj8uPHgMN9B6hA4VHv26I0q6pCmdz+CIvuWBZZRznO2g8sQ3oUzM7iWmlxbq+msuHKsKwFesK6r1mHldVgByDXI5kbmkRBO6RdTKrVl+oGpzK9KeLAhrNZ9o9kNrHTb5j3cCEX5ZMg5gQHj+a5FxrlslWJyemSjgjBppBZ/kDFhFWasDI6kYgjTS80/vw01KbVbhcS+9xJWVdxIAntLwJAFqGyMFOb00ejokOKWjofixkLHuIYBSWwv+Ht5w2CxF9RRJOHAhsGEmdQmbXpdXr567XBPnMGohzle/EGoP2cqJFi1tg46DxJ0M0f3cMaJzYVtYAVauFhG7pH06GYQXzbq7Wjjs+vXBLXkgJNAFF8V8IzZowIC14Q/x4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(6486002)(4744005)(956004)(54906003)(7696005)(66476007)(52116002)(2906002)(66946007)(508600001)(186003)(316002)(26005)(2616005)(86362001)(110136005)(6666004)(38350700002)(8676002)(66556008)(6636002)(8936002)(5660300002)(38100700002)(103116003)(83380400001)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VDNIcWM1VG0rb0ZsZ01aa29ONFVuOTFDUmJPY0JVVmJzVzdWOFNBR3h5WnNm?=
 =?utf-8?B?aG5tVEhLS25SQTg3QmJVUHpzZHh3WEZGNWE4ajZVVm1ESDhpbEg4ODNaQXZ3?=
 =?utf-8?B?dGZ6M3p1SHdQa3grRkJzaE1MbVlFcTcweDdEVkhQTFdjUkE0Q1AxMGhhaTJk?=
 =?utf-8?B?WFJBYnM0SjBuMHVVQjM1SEFuZWMxQUxHb1BrUUFqT2t3eWVzUDFmdmpjcTMx?=
 =?utf-8?B?QnJhVVJ2OWlheGNpdmo4dG51OFhCMXJMN1l4WHMxeXFnT25JTjVmMGhxeTJD?=
 =?utf-8?B?eUIvVEFlQm9CUnBWSm5SRThTM2FsRUEzY0MwRXRCNUdhZkNiam5VRld5OHZx?=
 =?utf-8?B?SkV6VlFvLzFwR2syYjE4SllnQkJORlA5bFdESVAyMjBtYktMZXJuYXNKVzlD?=
 =?utf-8?B?TG1PTm92Slo2ZU9TNVVHNUw4alFDZFA0eXhuZWFMTTNXd0lnNU5Ld0w0OGMr?=
 =?utf-8?B?cWUwQzFRK2sreHdLU0tQSUw5YXRrdkQyZ3RGQS9TZzNNdzA5bGUrSUVXb0ZM?=
 =?utf-8?B?UTVEdnFUZmR2aHBXQ1hyMXFqdnhXdlQ2MW9hajRXVGxEaXhPZ3JsWnV2blZr?=
 =?utf-8?B?SUNSSE9CamtmR2t6eXFyOVBkb00xZWlLWk8rNWpOeEVLTUhKcEdPaGIwQXU5?=
 =?utf-8?B?eU1CaWk5ZFBQWk9uRFFwUXZMQnNsaWxWdnVQQ1BrN1JwQ1FPTjI1Q28wUVMv?=
 =?utf-8?B?eFJqbEF5WWVxVWhTSDRpM3FWWE9KZVJmMEh5aUJYY0NtaEcyZG9UTStPc0No?=
 =?utf-8?B?N0NnemlLZG55VTk1REFGeW03Q2pyYTBsVjJVTVFSNFp2WUFZeXNuQW1oTjFV?=
 =?utf-8?B?WktKRXNaTVZQOGtwUy96aTVGMDB5NFNEUVB4eVFBKzJLNlM5aDk4UXNnLzls?=
 =?utf-8?B?YnpDSjArTmVaN241QkJnYlBCTnIxZC9yZ2hTbjlhQnl3NFZYUW5Rb3F3QlFE?=
 =?utf-8?B?cE1rL3ZqelRWT3lVbUdvV2FRZXVRb0hkNkIyS0RGUWhEOFNybjhSWEphN2w3?=
 =?utf-8?B?UnRHcGNzQXJCenZEcFlidDhiS3l4NTc3Si9ONzR5UTJWM05ERHZBNy9EQUcv?=
 =?utf-8?B?THZpNkZKUWc5RWZ1ckkzLzZjQWhFb1dsRVNUOGcvUW53ZEtqQjNhazVlWFlv?=
 =?utf-8?B?ZmJMb3RpSDZRQVl0ZVRnZVN6eW5XOFVjL0NrcS91MEdURlZ6bC9CZWdnR2JB?=
 =?utf-8?B?WmJoQzNYcFlVMDVQK2psQW5MYWE1a0tJVU1WbXhtRCtXTzVsNEpMQXJka2Nl?=
 =?utf-8?B?VXpiNVhhZUQ3SHdVMjQ0WFJscVh0SnFUY0tKdndKTXRERVZyazI3UEpSczBh?=
 =?utf-8?B?MFcwNWRja05hdk9TS01RL2o0cCtBdWZSLzRBSzkvVHgzb3QrMWNhMm4relBM?=
 =?utf-8?B?K2tYT0ZidkhFSjdQNnNUeDdoL1cxWUdITWUyVThqeUNMZ3hHT0xDVkVoNGJv?=
 =?utf-8?B?NlVqMTc0aS9oQkR3OVJrSUNrL3hRbDZoVTJ5SGF5eWZuRERQVThEdlgvMDY0?=
 =?utf-8?B?ckJ4TjIvQlZra29acndUc0s3MUsvcGZnY0thU1BRR1oxTGV1RVMzSTIwVWdJ?=
 =?utf-8?B?bGt2Um5KYzRGQXJqN0d2OEpzTnNUZ0t2eDFEMG44QlJBZjBqRHlFVnh3U1Vo?=
 =?utf-8?B?dWJzQ0lkVnUzZG5BUGxMOUlkUkl5OGhVbXVyMmdIcXRGYjk4TDFRRzNDUDEx?=
 =?utf-8?B?TUUyRWgrRVFRSlVYN2taYUYvanc0bXpvb0E5RURJZFc3RmdBZWV3RzNZWDFp?=
 =?utf-8?Q?nPPlJFCaIDCpMWzdfMgmsin0F1ZKN+k9P5K9yTG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cf919d1-a37b-46f7-8134-08d98dbfd738
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 20:35:34.1109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DKQq2e5CNYzh17E+R0adNXKWV0XZ882F6w5ck79gBd9Dwfk3okJASba6/gzxvZihY8rFoOxTbjp+/77ML1HjlgYCSXNY5H8S/agelZ+LCOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5697
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10135 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 bulkscore=0 mlxscore=0 spamscore=0 mlxlogscore=824
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110120109
X-Proofpoint-GUID: i4NCfEIYvdec_qxtXPhw80JBsCd8e3U6
X-Proofpoint-ORIG-GUID: i4NCfEIYvdec_qxtXPhw80JBsCd8e3U6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Sep 2021 14:50:00 +0300, Konstantin Shelekhin wrote:

> Change the log level of the following message to debug:
> 
> 	Unsupported SCSI Opcode 0xXX, sending CHECK_CONDITION.
> 
> This message is mostly helpful during debugging sessions in order to
> understand errors on the initiator side. But most of the time it's just
> useless and makes reading logs much harder.
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/1] scsi: target: core: Make logs less verbose
      https://git.kernel.org/mkp/scsi/c/05787e3456ff

-- 
Martin K. Petersen	Oracle Linux Engineering
