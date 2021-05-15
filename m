Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75034C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D69D6144A
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234218AbhEODPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:15:17 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57694 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhEODPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 23:15:16 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F3E282078417;
        Sat, 15 May 2021 03:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nuJhLA6xPh1RSUzhHfkPpmkzsUEl22/sCq+i2Er+uUA=;
 b=HRNvapKaigZrQ8hZw2OME/2LMUccQnI+nYjMoTGBI2u8Ph3XMmkqbr0j+g8wM+t7nIyD
 u+xgXbDKkgAE7dRug75UrFLleAlTdktdNLbUIsvBsy/QC00lzkBwuGaI7ALPal3gkhyK
 GLWD7M6/FOgDR6MDQx1+dyR2RbEtVEqNaPeYX5I1wkcT5D/Z778plMsVi+rBXFlFCLei
 vkc2YQ/JXJvfxI3zzlS9ZUroxWZHbBLoSo4FPRHdEQ82hpfYApZWGcO2CuqBPLK+FDV8
 lSf1veIaK0zX98LzMK/qdlXBNUqxMdOoY2x6r1WO2JpL7vrRIkiAPKyqCgbHolMqDVzb xg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 38gpnunm83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F3ArW4100526;
        Sat, 15 May 2021 03:14:01 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 38j6410ad5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcHqdJ344E4LInwvvsm2uMqxqkm1FZEbvn7rd6Ag173myE5hB4E2NSVGjgdDW8SJt3nkkgzy0CtOnLDdU9aNxyx8/CMYQ42hmL/HWPoIWmcCEVcz2XNq9Ja76UNULL0WeibtLZy77I43HKcbjLPqkn0t/FYPJ4YGIABlsoh0ownb6hHhV5vcsL3ltAjWea+WWZJgDTFXXYs8tcjOyvepd57mz9DHuSEnzBxoMkc/F1xj58OzcRmtTqEXzG4f2KdpoeuzrWarF8YLIbPRdKlUmmO98zxlRRmmDWRJUcoNJh2Ugonq6f0fx5eWmocZ7KoVaTo9WpihJwXijiCWyK4bDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuJhLA6xPh1RSUzhHfkPpmkzsUEl22/sCq+i2Er+uUA=;
 b=Ou5/05rJrOCaxngyd+dY+9khyuduHILWcwD5EzZo841M8lIIba0HhLNw3Yv2TlCIzNrhnx0cvuCY8qHveNpGM75L6cpbjc58xuQbnrDXm7oO8IirMoYaKR39ZcWZwH9+UHdybd8HzQly4J9MHnvFW7pqbD0e84ni/UnbkfToaKmS1QStlOBNnge2eSgufZAlb3pixSGHua9uKewzS75RcUABZQdcR/sDhTRLRAO7tHw0btD4x9CylsdLElUmN3SSBa2LQtcs6H65RpCedb9ZKmSyTW+9bcAXay8Vrc6MwhkiPnGyey3zvbAyedc44qog/Q+BcEf11hxPzUZc+lvcEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuJhLA6xPh1RSUzhHfkPpmkzsUEl22/sCq+i2Er+uUA=;
 b=LC1wTcoWa0USG+X8qZEHfgGXqZ8wFJAwQkfNqpvtDgYVdlXuhveJ69RHZf0CMhvpt92HvEhGP0vvOdE813j74yJehMFKb+L/XIKclymj6HgNRreVllpEyIpJQoVQoEt6WYgIiC9MRiDqz3shCfj7ynUMC8mawkh4zmI6q8/murM=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5452.namprd10.prod.outlook.com (2603:10b6:510:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 03:13:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 03:13:59 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] qedf: Added NULL pointer checks in qedf_update_link_speed().
Date:   Fri, 14 May 2021 23:13:52 -0400
Message-Id: <162104840194.20119.990874889649538237.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512072533.23618-1-jhasan@marvell.com>
References: <20210512072533.23618-1-jhasan@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0226.namprd13.prod.outlook.com (2603:10b6:a03:2c1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 03:13:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 78710c0e-6880-4478-b3d8-08d9174f7bcc
X-MS-TrafficTypeDiagnostic: PH0PR10MB5452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54525C14D6E06CF2173A78618E2F9@PH0PR10MB5452.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2V4aE4Uw6TxscQF6ZQ8S6VohVfCWk1mNEg4gBOG98869yspD6p/SVXTF8Ig1Uya5SLX3b+JbYK4bTfBSVm9dT5vbT6G1sPhkb2zk16iJrbvlZeTSwbjKvYMvRTd8mAnzUgzGzHBt/cdNh6Vd9DjRH/1XgvVTwVhG5rlqLmDNMZfkfR5wt473g1SoVS7mSBuhE+UMfNcTtNYPt9JAF7mq5xrXm102YaACZWIud/XcqSxG6sFiAnagb64E8eRKEM6U0HMpV/G2bzXfahcC02Qn5kxzqhq48JIDgwnJISkc86D4uONMbQ3eFQ4sJsvdoRjhL4fakcn6eWYJRPuLCVDxguUUsUNnjjOvg8KVhRvxRdREfDN0I7Bzv3cHRd9he2GKXlt1SgvqeaZDAis08hpMsE2t1urGUJMbdV8HDiSAOrSH3yAoXsKHZPO2aVMgur0pFhKVItfBCPTGK8dhHfqCCNNqrFvHDVG27ap4IHM1H0h/kKSPNWBrjIslWfvudP5E609nAVlcKQ03WxSvAdM8vbI7501IVeL+7NVSdsLRip/KloTlOcki0y1GKpfa0R+Q0kBSKHSdDhMuFbrYridOaPLKxJR4At2ed8NKQZziSR3k3TFqpKT5JocKY4PxB/HNsiII+N+nZ3dl9MFlH4HnOl/st+sc2Uh5INKmFUJVjUpYNNTGr0Q8luRITuaQfIqVW5eA6tpxdGY8y7bM3rZARBznT1s9JbYiKgsFZ9rlQrw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(7696005)(52116002)(8676002)(2616005)(26005)(6666004)(956004)(83380400001)(66476007)(66946007)(36756003)(2906002)(6486002)(16526019)(5660300002)(103116003)(6916009)(478600001)(316002)(38350700002)(4326008)(966005)(8936002)(86362001)(38100700002)(66556008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SXg2cTh5NEs1cjd3eW4xVHlPYVZKT0FObU9Mc1lOcmpCTlZTSHBuL1JOVUdz?=
 =?utf-8?B?VjBvc1BWTFpWR3diT090U2QzelBHcU1xRVdselNKRW5TR1pObFJMYithVkJF?=
 =?utf-8?B?akg0NXJKVTRUTHY0WDdHdkhBVlZtSzlOZUwxbW5NNjNVajF6ZjA4dlpBb2tz?=
 =?utf-8?B?cDNRcm1rVG9ycmdRY2dWVTZvaWRranNiK2JpNTNERWNZSXVDb05HaUg0QTFG?=
 =?utf-8?B?a2UwWlVxTW5BS0FXTnZZRGZ6T2d3c1F6Z3ZBMDlxRXI5WVJvRFZyN1FxeEJ3?=
 =?utf-8?B?VmdVcVBLc2NDMnNTdUNIVFBmeGEwSWNQOEZEbGlvNnVlVmFaVFFxeU95czhp?=
 =?utf-8?B?Qldqbi9BdzZPM1RMbzFoNVErOGtMZ1JDVmpqOTlFbjE2M2Q3RkNxQUt0S0RC?=
 =?utf-8?B?NEt6Qlh3M2dZMk1zdzQzNlFnVDczTTBRbitvYXo2NFlnNXp4ZzkvelJ3RG1U?=
 =?utf-8?B?UTZkL2Y3YXNkcGk2OGNRVTBKOVEwdXJjbWpJTUUzdWE4UjJvZXRJRWNoblpt?=
 =?utf-8?B?ditSVGJrOWRNVnJ6N2NDUHN3NkpVN2p5QnhsejZGUDdPblQ2UE1nS2hDcXBJ?=
 =?utf-8?B?VDVjcVFNKzhCaTZ0c2VTalZJZlY4eG1aYXk4NU9rMHhCeTY4ejUvTVN3REYv?=
 =?utf-8?B?c3dVL0ROUEgwdSt1MWZLcVMrTVQ4MTFBTnYzUTR0U0ttT2NaRFg3T3Jwb2dm?=
 =?utf-8?B?SHZhTFdqeGRPcHhhUFphZjcwUTdyN0dzbkdtK0g5dUNJNUV5OTV4MkNCOEVO?=
 =?utf-8?B?Z20rOE1SMzlFTmR4UXhRb0FtNUFDSjc2RmdSMU1pZDJhTkRrb01MaDVxMkZk?=
 =?utf-8?B?R013akFnYkpuYjVRVnZ5NU1YSnJMQlByWnpjeWdGSnBPZzgwK3JPdGRzSENK?=
 =?utf-8?B?WE9FYVNDa0xhMjJKbzF4ZGJnTEFmZVp4dWRIcjZLUmppNXkwU2RiRExuNDBw?=
 =?utf-8?B?N2FVY0kxNkVMcnVVaXdEMHJ4ZU0zby91NloxZHRqek9xOC9uSTVzckEydHhR?=
 =?utf-8?B?aDBRTTNLSTNGMjUrblNsT2Q3b0VtUE9Ya3FnVzBqOXlUbzZzMGtRODdaN0U3?=
 =?utf-8?B?VE9QUTBlRWlrejEyYng5ZVFhQUlXV21sYVV3UjhtTXB6UHc2Si90YzhJbk9u?=
 =?utf-8?B?SHpJSVg5cVdsTTJqQThkdUtJaHlFRnFKd25FcmJ2OWhPbU1LNDNCenY2aXBC?=
 =?utf-8?B?dnVRc09oSktqRElrVzRYNG5hSG82aU5ORXhpTkkzekpIeEFzd0Q4ZkNGR0tw?=
 =?utf-8?B?enJqd3IySk9odDBqL29PSHN6QmNBWHpLSXM0T1AyRDluYWZVVkJmUmdDUjM0?=
 =?utf-8?B?TkpJL1pxL2R4YXNTRWtWMTYzZlp0Wlo1UW50ejl6TXRWTU8wRitLSjBybURG?=
 =?utf-8?B?TXZwc0VZWVhUOWR6cGpOc29BTy9WeWlXeFczUHRIbmQ4UnlVRm1qY29MMTBT?=
 =?utf-8?B?SlBSK3QwVnhXQmpWT2JnQTJNSzZxVUJ2aHdSOUpja3FURDViS0o0ZmpEQlVn?=
 =?utf-8?B?OWwzSHRtaDV6Nm93UFBuUlRxSklwcE4xVGFNQVV3UU8xT3RZbDJCR29MQndW?=
 =?utf-8?B?cFhlbzdwR3FXOGIybndhbk0wN0lFTDh5SGhmeXhaeVpDMzNOd2lycnlabTN0?=
 =?utf-8?B?Y0FOazRFZjd2SzBlTnJJRnFWSWFBNGg3YUprYTRlNFFWdnNLTkV1YzJjeFRF?=
 =?utf-8?B?cUtpaGllNXd6N3lwaDU2dkdFQ1YyVFZkRkZvaVRzNEsxV0M1Y3pBNFF4OFlP?=
 =?utf-8?Q?ZoxW69SimXntIH+8aP0k3qIg2/3JSqdQqjByn4T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78710c0e-6880-4478-b3d8-08d9174f7bcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 03:13:59.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqBilB785DZ1UR33f42OHFe1hoJr7Ff6voLZwG45wnfDoJheDRa8PXyDYmts/2SK0aneBahQoNlTOgoykQTNqSByP88/9xpi/3wLYnwZBOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5452
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=935 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150022
X-Proofpoint-ORIG-GUID: H4QForebqN4aH-1ssZqfXmp0teUqyAma
X-Proofpoint-GUID: H4QForebqN4aH-1ssZqfXmp0teUqyAma
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 adultscore=0 spamscore=0 clxscore=1015 mlxlogscore=999 bulkscore=0
 mlxscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 12 May 2021 00:25:33 -0700, Javed Hasan wrote:

>  Issue :- BUG: unable to handle kernel NULL pointer dereference at 000000000000003c
>  On installation of RHEL-8.3.0-20200820.n.0 distro below stack
>  was generating on error.
> 
>  [   14.042059] Call Trace:
>  [   14.042061]  <IRQ>
>  [   14.042068]  qedf_link_update+0x144/0x1f0 [qedf]
>  [   14.042117]  qed_link_update+0x5c/0x80 [qed]
>  [   14.042135]  qed_mcp_handle_link_change+0x2d2/0x410 [qed]
>  [   14.042155]  ? qed_set_ptt+0x70/0x80 [qed]
>  [   14.042170]  ? qed_set_ptt+0x70/0x80 [qed]
>  [   14.042186]  ? qed_rd+0x13/0x40 [qed]
>  [   14.042205]  qed_mcp_handle_events+0x437/0x690 [qed]
>  [   14.042221]  ? qed_set_ptt+0x70/0x80 [qed]
>  [   14.042239]  qed_int_sp_dpc+0x3a6/0x3e0 [qed]
>  [   14.042245]  tasklet_action_common.isra.14+0x5a/0x100
>  [   14.042250]  __do_softirq+0xe4/0x2f8
>  [   14.042253]  irq_exit+0xf7/0x100
>  [   14.042255]  do_IRQ+0x7f/0xd0
>  [   14.042257]  common_interrupt+0xf/0xf
>  [   14.042259]  </IRQ>
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] qedf: Added NULL pointer checks in qedf_update_link_speed().
      https://git.kernel.org/mkp/scsi/c/73578af92a0f

-- 
Martin K. Petersen	Oracle Linux Engineering
