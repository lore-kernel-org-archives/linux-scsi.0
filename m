Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 833A7C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A55060F46
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhHQDSj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:39 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:39048 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237062AbhHQDSc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:32 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3Bvo8024636;
        Tue, 17 Aug 2021 03:17:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zL5nqljamygEvNXdto+iTvS7Q+osnGyT5rCztelefUk=;
 b=iL3AT1DKar38ynHR7DfsP9Hvkr3BTvr6e0UfgdZt9yKw4bimGkwwnhHbxWqzMKMP5Grd
 zFbLSars0dAGEc75thihPhSpMPt+ytQED1ZvHFPBWGOjXP0ty6KssqLoR2y+QEiL/E8v
 kYafVTGqemdaUuc8k16IBVecZjVpsTFqzjuyVO1dneaTRSmIreWt9WOp8wyxSZr7VdAU
 6kx/23TdTiokndX6d63VJQfOT2QFPlc2laHnIPnc5nV2bZcuxWYTMWXYnCGcry5flM7t
 oDrA6U3zFRDRZ+caTFhw1Nu1LhlSAMSEZNNFfn7CzUdcGcZusOjZCIIXlSexjrLhE3Zz 1Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=zL5nqljamygEvNXdto+iTvS7Q+osnGyT5rCztelefUk=;
 b=S4yIRfUxz153m1yp9M3Lj4nb8OoIrw1cv36Qfkb31NLE93QBzB0KhF4UzZChjrsOe1Q9
 YU4oFo4WgOXz1sRyJQSLyuDpt7WhLsnqnsnFIbdo1TW9blTek7glb4eYv4E9sUGVkMFz
 M48A4/7iMGOsE10DqPEccBEbqCb2OUv/eNQjCJfwG4Nvz0keViebqFjXnIE5rG+7jZfI
 OXr70qVMilJCG0lVRxY75sgQw5dPJPTNiPiNanNw6RUjOyGQtURtB8su5+AWZWV44Wlb
 lMHuOm2xyy6UwMwc7dpRkmFZcF6CcJadLIk+Vx0krjidKBQjWN7uURf9MTD6ttMtt4Zo uA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd2y3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3AxK4038815;
        Tue, 17 Aug 2021 03:17:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by userp3020.oracle.com with ESMTP id 3aeqktadt2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQJ2Kb65XoD1nJWe7hd0pvY5C3HcBdar/0lqsx7keHIWK6XYzUBLJ1rM30F5izZ6DaIpSJ3W/cJ4fwMpnhPq2jg92lmHFK1OBG7G02tTFCsBBBDMjvcBaFpwDzL+X+UxXyEJ4CyFz6CNk9zYZEiv168g9XeoGpf+j0csZsij9iYjlG942aLAR7ufDPpJwmR6f+H+km8K9N+duNnqRjwMlgmxgs1Sl0AkvmyQzRXyzdlMdLoGzayVKvkhd+2Gv2hdThjMuWkhEKoUR9c/7AsfZ6gKuXUmLtEyv98LWWF6cQ7kALhIQ8qoGnYe8REMZKVmnZ/l4I7NVJJ1+TJFgLSgjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL5nqljamygEvNXdto+iTvS7Q+osnGyT5rCztelefUk=;
 b=nhtTfKucxN/tfwlI2GWgoQBCZ2egoCEORWPLZEdTKAdLggFTYr3hPRyklMPcNtE/9wo+/6sf7oTYS7WHih+P1/YpQOG+Wqfvo/hVEAuEeRMRqnRCy/I5T5YWlZ6AivYMmeftNkxWa/0uU/ESDGxTg5xpfpsIHhSXe5X3mm3FyIe122RH4Ko/p0vwpL3VlOympK+gaZgTDBTxZiHa5rXxEbN1KVPsgrh39LZX3aMIwN1C7IZokFgTZ6MLSbJk6BdoYBK4h3nfY3478299M2HZZqIKN17/NaPZi0T8eXEpSU3MOUcB6PSD5OqlO1eoiBqq3zWD7R2PfFDjuUSkK40RYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL5nqljamygEvNXdto+iTvS7Q+osnGyT5rCztelefUk=;
 b=I3bdxItkDpN7bwIKHu9PsexRlsMLWIuuLFuZ4pCUiDq2GGaU54/8jJkEaQPl0paBgUstozfbC6JbESlIzyVJaPS7WZ9pjJwX8febJlXnQG+fPlHqii12Xvl+kK22g5uWjI8ltjQl0hG3a8bEOxpfRI5C8Mo2jlqo0LJ637JSxg4=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 03:17:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/14] qla2xxx driver bug fixes
Date:   Mon, 16 Aug 2021 23:17:41 -0400
Message-Id: <162916990044.4875.1233075604098415729.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810043720.1137-1-njavali@marvell.com>
References: <20210810043720.1137-1-njavali@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a661317a-d93c-40bb-4aa4-08d9612d9b3e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597F3FF0A01018E298E96108EFE9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FnMXqdZZvcKlIUlK7Ygm0baMKaWKYhgBcHsjlUo6ThEVik7kKBdIT30rsfrJlUhYT/sVdy8XkBbpYLe0mH4bpeBjMi929n5rgDnQs4jmXRpYymfsZAVMBTEbqA+BK86mCUwceca75JDE9I2cjCh/cFli+e9Jj8tWLYswaxqoMAwR/A8fD+/eUPC2Tymze5rmOX3LdHNam7BL5PrMPx5rq3RzrpuCqqLDD9Sv7vyp279/geXmk1AOksMXnPjFR4pe4Y3sX4gXF2uZVXDMtEqdNbHDAAMZHkRqRFfStHw/XSRFXzT1ClTC0nWI/KkAjq1bEqGJerazyJvxhlhPPieOreLW90UFx7pWL6SizAMlgl3jr6zO07RNFv9hJUE+gVllYD2DoF74Mq1EsJi8p5tbSFYIgJ+2jOGN51IF88FeRkOGk1doFJHOIxHVP0aw+o5my7iKhCHXLc7iZocpznqQYQM7viiPyOewqGJWF/C2by2jaMO9IEJOjJJHzEPLoxzpzv38vBtZ7UWKpER9rRtvWS/SFT0BsS2wI3Pr7uU4Haw2zMooAjq7A3i9OZnOaR8H87r/bH1A/RZSLxHaCuTcEKq0JAUrZKP/NqpnkJGAWbKaDb8twtndF0h0vjWV9IIKW9tTqgVr1JfebCIOQ2nWhm3TMlBjmtl2vgyhEsq10Eqpv3B5rxWt6CnCZubdRRBcfmfDnkdO7hIxir8ewEf1wDtoCHC5DDGUXB79b9aKVUVJ0DJ05KKmZ+Txtfe4X4MyhHGmKvH4IRT+3cuIfiqwWV6I6jSdWHOdNEZ7TniuT+W8rWZofoYq+UVY/lb0Zjfz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(36756003)(38350700002)(38100700002)(66476007)(2616005)(316002)(66946007)(8676002)(956004)(26005)(6666004)(86362001)(6486002)(83380400001)(66556008)(508600001)(4326008)(5660300002)(2906002)(103116003)(966005)(52116002)(6916009)(186003)(7696005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGhyVG9COElrejBMeEpZWmNPdlBGRTk1d3hYSW5NcnUwODJ2N2VWRUFYUjZ6?=
 =?utf-8?B?ZHk0Nlh4YWhKN2x6U0dnZXgxOEdpbHU2MkV5djZ0M01aNng1NGlDeXZsam5n?=
 =?utf-8?B?b053dVN4bU1sMTBmUkZTOU9Db1FMM3crTTZzRmtob0JtT1l3dzNHSlBaNDFP?=
 =?utf-8?B?d1VKYXNIN0l6NW9SSm5GZlE0aDJWNDI1c0pQMXRPRTFvRDJkWEEwcG0xYTB1?=
 =?utf-8?B?TUszQWhBU3hNVlo3RmhsQmFheW1QUVg2S3RGdTQzWElkRjFKV0xXQThRcEFV?=
 =?utf-8?B?Y2hPSDFCVVQ5MnpxTXozaDBVSjg5VE5pN1RZRVdxRWJ5SFBZL1NXZkVwYmlo?=
 =?utf-8?B?VjZTWC9xd1c4eDJmYUhZWnE2SjBVVy8yRjlseUhmbXZoUmVDelB6T2ZsdFU0?=
 =?utf-8?B?VDhEQ3NtcUhmSjV1c29VazgxSElBM0pqUDNUbG1BNE5ON25yL3FtaWcwazQw?=
 =?utf-8?B?Sm1UNVBmN21OVFd3UFdrSk9DVTBwbHV4YWd2d0E1VWVEeTI0T01ud2dFOStH?=
 =?utf-8?B?UElWS21HaVZuVkVMOE9wS1llR3pKczRGeEhrMW9GQlNnMkRVK0NNQk1YbGcz?=
 =?utf-8?B?WURTMUt0ckJmc3dvb3JhbDREaHA4THpEVmgwMTZablIyaWl1dUZvU25vWHYv?=
 =?utf-8?B?Z01CMWpwU21qRllzMFFGcFUrZHpoLzVpcjJNWi9yVitaWlJjT2tvaTNYMDg3?=
 =?utf-8?B?TkNMemh1SU82OVkzNXc1bHFibjJJVjd5bXVXQ3J3RmlSQUpuU29CZFZ4L3V5?=
 =?utf-8?B?K0daZmt2UFgvOW00VjJaQ0NLVXRyOTZQY1VSUmE1bE84SHJvN0N0WVdlekNi?=
 =?utf-8?B?S3NpQ1B0Y3N4UVA0Yzc5d05DYnpCRVovSnRQVG9tRVMrQzRnR3pqSUJoaDNa?=
 =?utf-8?B?U0RRNW5aaVpCNFF6VjBKeDNVNGZaMHNqYnk0YnF3bEFsNU16NTlNUXRjVEZI?=
 =?utf-8?B?Wjg0RW81bitTRU93a0VWVTFiaStDNG9IOUdtNDFjS1JjK1lsOThVTGtzdWxl?=
 =?utf-8?B?NFFuV3RkRTRqTmtvdDlSTjl3ZjFpa1FZeldZTFlDajhrOStSaTlwMm9LVUNC?=
 =?utf-8?B?ZjRPVmpUYzgzQkdFcDRQQUEyVDM3SVc3OFIreUs5TDEycDl6dHNZTStJUG5B?=
 =?utf-8?B?elA2emUwUm54eThUQUVXVnpyZ1djai9kdUE3OGJsd1lkQ1pneUs2L2pqeFpU?=
 =?utf-8?B?cFhXL3FQb0lhU0wwdkVFSm83U2V4L0pheFRVcG9xVFN1c0huV3BhRWpEZkhr?=
 =?utf-8?B?YXQ2UG5zM01heEJWazk0SVMzaHNvVjYyOGNQazVxMlFqQVpIbE5aNm5HYUFt?=
 =?utf-8?B?eU9YRjVwaWQxUm5McXh5SW50QjNyeWdjcmV0S2pPci9HeW9pTHEza3FMMXB1?=
 =?utf-8?B?RGZyamhVcFhVa2wzVklRMmVlOVZXZmlXVVlHRFhwd21tbWt2ZmUyQ3ZuOXV6?=
 =?utf-8?B?c1QzeWZQRnFHRXdCbzFKdHBXbXNYNjJaS0JiamVpUTNBdU1nUGZ0UW0xTDU0?=
 =?utf-8?B?L3RaalFNM3RNMnBUSGg3WEwrTEw3dTFEdEVNRzZXRzNLRXl5T2FHd29GaTVh?=
 =?utf-8?B?REd4S0lEK0IzMGp6ZE5GRzVSMHBzbGRKOEIwZVI1VGhhTVVGRmdWNmxBeGd6?=
 =?utf-8?B?eHpjZk8vSXBOaDZMaXZraGZuRGRHNlFUYmhpNXpUQ1FJeTdYeGsvaVpMLzJN?=
 =?utf-8?B?UmViVWJTUW9YeXBnbWxyd283Q3pMRlJwSndweW9LeXVQbm9RL2NZZE5VQzhy?=
 =?utf-8?Q?DGzpKhtj+PeWcf980ygt7YbvbDnpGWb/CquXwqC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a661317a-d93c-40bb-4aa4-08d9612d9b3e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:55.7889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zOePZVDd261nq1t8i2I2/vQNFeK/kK7F67QViWn2pym+CTbDx35B4fdZ6vzWsPN05F86M/hhLJiD4ZNDilDsbl4ftABIxXnHxazwgMb/nyU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-ORIG-GUID: 71hBPiNb0j_eHuEynXDoBJU6bs299jAa
X-Proofpoint-GUID: 71hBPiNb0j_eHuEynXDoBJU6bs299jAa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 9 Aug 2021 21:37:06 -0700, Nilesh Javali wrote:

> Martin,
> 
> Please apply the qla2xxx driver bug fixes to the scsi tree at your
> earliest convenience.
> 
> v2:
> - Add Reviewed-by tag
> - fix split of log message across lines (04/14)
> - fix commit message (06/16)
> - add Cc stable and Fixes tags
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[01/14] qla2xxx: Add host attribute to trigger MPI hang
        https://git.kernel.org/mkp/scsi/c/4c15442d9c06
[03/14] qla2xxx: adjust request/response queue size for 28xx
        https://git.kernel.org/mkp/scsi/c/ade660d4d506
[04/14] qla2xxx: Changes to support FCP2 Target
        https://git.kernel.org/mkp/scsi/c/44c57f205876
[05/14] qla2xxx: Show OS name and version in FDMI-1
        https://git.kernel.org/mkp/scsi/c/137316ba79a6
[06/14] qla2xxx: add debug print of 64G link speed
        https://git.kernel.org/mkp/scsi/c/85818882c3d9
[07/14] qla2xxx: fix port type info
        https://git.kernel.org/mkp/scsi/c/01c97f2dd8fb
[08/14] qla2xxx: fix unsafe removal from link list
        https://git.kernel.org/mkp/scsi/c/0c9a5f3e42f7
[09/14] qla2xxx: fix npiv create erroneous error
        https://git.kernel.org/mkp/scsi/c/a57214443f0f
[10/14] qla2xxx: suppress unnecessary log messages during login
        https://git.kernel.org/mkp/scsi/c/a5741427322b
[11/14] qla2xxx: Changes to support kdump kernel
        https://git.kernel.org/mkp/scsi/c/62e0dec59c1e
[12/14] qla2xxx: Changes to support kdump kernel for NVMe BFS
        https://git.kernel.org/mkp/scsi/c/4a0a542fe5e4
[13/14] qla2xxx: Sync queue idx with queue_pair_map idx
        https://git.kernel.org/mkp/scsi/c/c8fadf019964
[14/14] qla2xxx: Update version to 10.02.06.100-k
        https://git.kernel.org/mkp/scsi/c/bd19573e05f6

-- 
Martin K. Petersen	Oracle Linux Engineering
