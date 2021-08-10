Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E249C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6676F6023F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237181AbhHJFVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14494 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236140AbhHJFVQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:21:16 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5AfwY011964;
        Tue, 10 Aug 2021 05:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3RXMhJDU9vfg5LkCy3tplrDJczN/C3DsMiBADNqgaLA=;
 b=PvcCY26VqpNUQm68FSEcsscOfwr1Bv9emHlAO7ZfswaybC7U5HKtOHJVhhs2czJPxrIW
 2yY7Qmxspr/0Mh9PFeUIAB0oww3B/xdSJ6sS8KKpRXlvuPnBdiYQRGEODnt6ec7t9NXk
 IFG0IkKCbEhZig0RrSh937m4gGHRAo6r0iRV3iGBFGyfM42Eo/o+4KC/wtVCAlqJja0b
 GEcJbFdYY9QdpxcT2TK+L7URpTp09s4GeVyNmLWWN0X0G9137YfCYxFdvJIt/vHQd9RU
 Do/ViB2y1M9utnTXnms0nBtk6y6YV0k/cIJTsl/lfmFG9j9abDlOn3aASXTKc0gZ9WLp hA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3RXMhJDU9vfg5LkCy3tplrDJczN/C3DsMiBADNqgaLA=;
 b=EwUIcaUhavxsw6i+lBhV2Lbwwf3rmP02QGAlqy0/vg6Diuy4txYdIkEOlWteExQDAGGB
 3AHYMFnVxruFqVkWgJRad1PUjP1ooNvsCpjfv1Zr8wm6arutiimAG1ib7ktxW52OorGF
 D/Ifqz6sUcVKNEDsiTNpP2YDZZoDIAkMf94Mlj8RGTxmTGvd1kwbNIhMssb4GYKR45yx
 ZXKHpghnTEdSfu720ryKild4t6AbZnlB76dQcKTLx0f4s10j0F1WyJJeMpT60t16+vTb
 A/mjV0hwggb9DZq5KqpRt0MfJlsIYWCQOFNXzR/9aRWULVjRwsD0qLuDL+itdlJIylBT Yw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ab17dt9s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5A3x9149341;
        Tue, 10 Aug 2021 05:20:49 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 3abjw3rsqh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n9kMGMlLkcPuR/md2iHzLEN0dF3DmBsaM8LG3Gl8ZTrAmpZApxv8U3suDVE0X1GTyJh1SEQ0IVJHHGuo7O2iRmNlaZ8OoYg8fkRMCEkTHJXaKU8XcFKQRVFdTPYCQPcrk3rKi00b5NDTrOdxcQ8E/2GPKtTs8O+5PWEttwESCic7Cv+9jyIPdIUEuaqb2z6Swg1kttYhAi1hQirP7qd9D9XADukRhPyeC0kVBMSF0XHu5cpM2IPFouYyeG5VVsO10H0v1OMun8fpuzB7FzO7yHUCFEScLPmsrvuKmT03XEXK9M/jqtKku4FpOwqUYiabayaTKPjYo9fAvONriqKYjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RXMhJDU9vfg5LkCy3tplrDJczN/C3DsMiBADNqgaLA=;
 b=LRcsxWhB0aWsvn1ZkwI+FaPJajlyUejt5T70lS4Ck4Gc+ra1Ybyyutxj5OHNwo86lTKD3vvoO0K3zBzGLteDdTlu2bjZz6QO0bPCRUAHlQOlQNq1SI//Q1kAAT3yYtoTlDe5fatA2gPySgsuGaDo/f1fs/eZiAOlKHQLgV26BQe+WjAQtw1vYdT1yS6hOWol/1VxeAi7aCpo0JzF6/HZkE5u/7smEdOvhcnD5/Qa2i7LgGSzZS+kH0GP0Fg5W2ybd+XEUr6new26NlclEKv290nylJG30cl1KGx6zZspv2vqaiEulHdJvKSSdfpGONaItm2CPhkJ6BZa+GgXW8CJnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3RXMhJDU9vfg5LkCy3tplrDJczN/C3DsMiBADNqgaLA=;
 b=Oxy5zxWUgLc8J+NRv5qvWxnPY+3t6JZwed/qa0LXslSRfBcRgd2H9will3VcUA63QU+kXGwl+0s1AE9y0KcyIWMEac98POYsrdbjMTPGrGzqUwNxP9PSNKVCwA3V9fkysF1R+uFeEvv8desU0ihSCMT9ETYcs+x+PtDwRkQ2yPk=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:20:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:20:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/18] UFS patches for kernel v5.15
Date:   Tue, 10 Aug 2021 01:20:40 -0400
Message-Id: <162857263913.15955.7086109477280739051.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722033439.26550-1-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0001.namprd06.prod.outlook.com
 (2603:10b6:803:2f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0001.namprd06.prod.outlook.com (2603:10b6:803:2f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 05:20:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 218d7bc3-ac65-4744-a2fb-08d95bbe9ca5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB459796C56336FD1C9CDCD0958EF79@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UBMc5D/sQH8eHuj/wfOjIFTTQQMRrld67v3eXEK/tI1pTGRmFE8deDcdMJ94K/Xa9GBo1Vi2U26Xiiz4xBdUd9RIZhOc0joQiPdOwyvUudtga/ljeLgff38tNC4sXa8HIZeXOES+AWomcjpbG9WieeY4aMW2eWS4BwLNAI81TpIFcpd0XjGVdSAPkKyL0d7ue6SJ5QIoEFBLCaXiEV38GhOpE4Y1ADjKIJk8iTqjXjx7RDvH2LRWVAKAVpAUE0X1LXMv+UZtYM5n50qdxASduYfieJqAwnlkrVY4JMnb0OLz1jBu4766lM9ytYjUEN4P/Lv1YNMn/yoUG6MTxo14j9yi6eQqNLx1OVUMT2sfXHzu46HH7CX81WFToBjGEMGOd/uzsrtljwXjbSTGTIW/M3pu9S57K6sJkKtaS9FiPim0iCvi5NeChkVZq6iRQl96DSc5opuA7FprgHIhSwwopL8mwPfNS4R2IJeN0pSK4Mgc40Lojr8QjRmBejRafYHD/zDiFWSCkuQTIEfnC279p58A1BI2pZAdbpB6OK0hgHeSLe3IFOk7ggABCLsHy7vIQwJ5w8k0zMX09BGhFDNEr4kSagSE5MPvjD3DZ+p/MyIiFItvN8bMeBxv9eGRE77VT2jXCEN1y5DTeX43ZHDnbXBaVSqWWaS1fTMc5WO6wbdPjy9lC1wZV7nL2q/TDMjhnM/Zd1F4ezjqy1Hhc5Gurg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(6916009)(2616005)(38350700002)(38100700002)(103116003)(316002)(508600001)(52116002)(7696005)(8936002)(6666004)(6486002)(8676002)(5660300002)(956004)(66556008)(26005)(66476007)(186003)(2906002)(86362001)(36756003)(4326008)(66946007)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dkhxOG9EbTROWjUyamV1ZTJ5cG93YXZBSXZyZlZjTkYxNWtnVmNJa0Rwa0FM?=
 =?utf-8?B?aytNMS92ZHJORUcreExBKzJvZThEZSt3OUlKQU4zZ214aU0yQUhNcmtnZHpX?=
 =?utf-8?B?STV1c1NobHdWOGpQWGNRZWlrUUtKNHdXekc1QnptR1A4a3YyVUhuQnh4RUo0?=
 =?utf-8?B?TWc3dnZPbUs4RVVKUDdSTGJrSU9oSzQxNE1TUlFDVnBmTng1ZDUrbTRsc0Jh?=
 =?utf-8?B?UC9vaDRHVHZIN2NVKzRCNCt4QktsdUhRTHpERjRyMlp2NFM1K3R6TGhBTXRF?=
 =?utf-8?B?RHF2Z3YzdnAzdlNFdGJERDV2amNrWEx1cXZFbjBJNFdCWmozK0MzUkJtQkUx?=
 =?utf-8?B?K1paMzBFOE1sbTZNRWVNRUJOdFpMRklsYmFrVUNqSi9mb1dwQjVhNmREakJK?=
 =?utf-8?B?MEpTWVpUSzllYUpURXZLNkRKbG9Fa3BKY00zTFhMT2JRTXI2RjYxcElOSU5D?=
 =?utf-8?B?VnBMN3pIQ3ZjeEJ6Q1pHbG1KMUdqQzNWdXd1UHg5OEtjRzZHeE4zQVBuSzd1?=
 =?utf-8?B?aTRuVlFOblRiT0ZmVVAxeklFclArVExqeFJZM0NEZU9IMkgremxENGdweWFF?=
 =?utf-8?B?ZkkxM3c4T2oxaFNSakRwdlJHalh4dWtPbGU4UVRlRi9YTDVZK3o1Z1pJQmh0?=
 =?utf-8?B?NzBVTytyaEVwY2Y2Nm8wMSs1V0JEc2Q3M2haQ1NjbXUzZ1cySHJ4QXNVMk9j?=
 =?utf-8?B?Z1pqT2hrTXV2a0hsMXVtMk01Nkd3SWFZRjAwMFlPeDBVUG1xaWs4VHVyNjR5?=
 =?utf-8?B?QWkyTXFreUtwbTIvN1dxVXRWemNZMzNqOUs3eDlmV05nbkFvL25Zdi9EK0ps?=
 =?utf-8?B?NGNuOXhralRYaVJuWEpMRW1GdndFS3pxR1hGNm9JelNBZTZUc0RoS0dWc1E1?=
 =?utf-8?B?L3h0MFJKT1RuSVZ0TFBqc05iVkl4eG1pYWplZmh0YThTak1KZExWSEcyM3RY?=
 =?utf-8?B?eHArVlZsajR3QVUvQlVOSGQ5RnFrNlVueG5ORDdLQ3BrTWRFSElTdzFFNUNZ?=
 =?utf-8?B?a0licFFIMEdRZ1d6Zmkzd0I4bWNaRjJiZ2QyakxRUW9wSWlTblZuelZ4VTli?=
 =?utf-8?B?Mnl5RVB4THJvUkU3TmpqemxRYS9heldXT1U5Z0d5MklKdGVmRlJvc1RWckhB?=
 =?utf-8?B?Rng1aWhvYVA0dW5Cd2kzOEtwNkpBU3VoOGYyamNvS0NWM29yN01Tc3JJaWpQ?=
 =?utf-8?B?N3VEVThBZ3YzMVFaM2NNYUZ0Ykd6a21BK3ZUdjlpaHRYQkpadWhDQlU0Sm1N?=
 =?utf-8?B?TTQyeUNzMnVaYktqZU5MQUJRZGxNRHprbnp1eVhReURDRG9RWVNXcW0zQS90?=
 =?utf-8?B?aHg0cVduNlpTNXZDdGtkU2EybGZXcUU3eTBvT1ozMk5TcFZWaFZaZVFmMTdE?=
 =?utf-8?B?N3BQRTk0dkFLK1kyYytNZEZKcTl0ck1VQ1Z2djRBb1JhZTVVN2hTUkRKeDNi?=
 =?utf-8?B?cEZFSVEvY2owMytoM1pqaW82N284bkdna1dtYmt5NG1kR0ZGOFJZSDl3VEk2?=
 =?utf-8?B?bFplSGZwbEhQdGtCd00yM2RIVzYzLzJEUFJkbjhMTVhwa05oVmMxT1VzaURV?=
 =?utf-8?B?QWpwK3dwNE96ZWtjMWFVM2ZsL1VRbjMvZ1R0ZFZyeW00b1NZam5lVWpRc0JJ?=
 =?utf-8?B?TGpyR0dvQmZwaVZBN3I1L25LbUZEa3dNY2lNY1J4MWtCSm9MVzduUitaenhM?=
 =?utf-8?B?NnRvTlFGeldGSFgxbVFheFpqR3l5VjF1a0I3MlhueGVoTkdXY1JST3FMNlIv?=
 =?utf-8?Q?g1coPBl3GJRAvz29wg7K8MRaLRPtbUQPwBZ05TI?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 218d7bc3-ac65-4744-a2fb-08d95bbe9ca5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:20:48.1811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27qgqEukyd9Z4QBGfvy6/Do0+K542xDxGCF/qN2ag58/Qt8WrDbKZM4X1IxwPHP+3LdGZeB17P4aBV46loeLMozkVYUAO6Kg3PBysWK/7K0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100033
X-Proofpoint-GUID: mhQDt4JRgPZX7bNwNWn-ajncx4LwCJcu
X-Proofpoint-ORIG-GUID: mhQDt4JRgPZX7bNwNWn-ajncx4LwCJcu
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 21 Jul 2021 20:34:21 -0700, Bart Van Assche wrote:

> Please consider the patches in this series for kernel v5.15.
> 
> Thank you,
> 
> Bart.
> 
> Changes compared to v2:
> - Included a stack corruption fix.
> - Dropped patch "Remove a local variable" and added patches "Revert "Utilize
>   Transfer Request List Completion Notification Register"" and "Optimize
>   serialization of setup_xfer_req() calls".
> - Added patch "Optimize serialization of setup_xfer_req() calls".
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
