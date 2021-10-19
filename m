Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270C9C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9D5C61260
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 03:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhJSDRt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 23:17:49 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15536 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229878AbhJSDRs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 23:17:48 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19INXXZY025779;
        Tue, 19 Oct 2021 03:15:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=C6hpW4wNGhReH/Ira/3i8PcpNN+1YHFfPriuqcasALg=;
 b=ha7uoae/oNVycAma7gucAoExkgCzJF5glz46rQCgy20WXFzLQZhv+OpRW5uxxvg+beVv
 4dArk9/b1xXmk9+tPwNKvoBsoZgghgw0mrDnCbGO1t6akR6ocvQUg+f/KYGm/HjDkkKM
 aMknHg9+lsDGW4s7TFTgm5wmRHikzJdMJA6QfSWVRcDDqsCsI9d/FByYP7yP0XWr1Iok
 pndQAUQQp6Z+r0P7092/avRm5bTdTF3F/gS6EYIr19CLWwwVAjqc8lmDEbxsooWC2tTx
 9y6qxDrt1Whf8udmcgIYxNa0I46xGvK+Amfx/320/N8hG3SSy0ZU8ZS2PXnF+4uKE3ks Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3brmkyfruv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:15:35 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19J3AmHp061064;
        Tue, 19 Oct 2021 03:15:34 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by aserp3030.oracle.com with ESMTP id 3bqmse2myh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Oct 2021 03:15:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LYQsAV2XQrtU4Df4P6PqbrCvOaCIGObluXCKzgF0E50HKdfGKKX3csx1JK/WOF/SfyBi8A7PUGCWhncDfijFlTqVSp3M7wcOkRH8h6BCcjAq28S0Fj1jH5LhSqQUberBYT9n9yB8y+Bzd7+qRmHMimn0O3o6snoEMZIFEMDDFQiA/ALaFnPxPVwba5hPFDLxk2gKTa8u8/06BhrM3Ybzs/zKsOXXIe1gZ1GNvJjSlJZH7HKBHxPzCY93QjnSoELI013beeemwAUB5+2EY3SCu7LqyBU2u9zeCUZ/QhqIRs5GqBhbTKBVfhr4kpbdcyTqeJN2yE+SfwK6IgV2JJamGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6hpW4wNGhReH/Ira/3i8PcpNN+1YHFfPriuqcasALg=;
 b=HU4XMX7eyyHXOTrA/vq4ahyo02wsiKjWWSJHNkvd5QPYrLPEsbhyOlBt6kN/AZSAXbohOOupAySqkir/Wmbog89WkBWPtmb6CjcPxHI0xcsU6aTmV5ChW8vx+jtesONwMigrGdFvvI7sRxRSNbyTjqIW/hvBXXRzS889g30Atn9Eja8e+wi4PvNzNXvut+5Ffs+ATqziTsnoW4pyA//R6iNEwtRJ+vudY00X6Jyx6Usi+SqyuiigYuBkWgezKmGn/Imi7sqrJe6pmmWttph7ZMKAbjgtPy9nAZmBZuIVb49T8Ouqc/TsYhsvAcMf7OGhFl43q6LCN8N++pXR83s0ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6hpW4wNGhReH/Ira/3i8PcpNN+1YHFfPriuqcasALg=;
 b=Oyo4zWAPFXX9rXj1260p3ETqXef2QNdPIUBEIAFzJh6KKRU5KCp3dgldSUTH5rgJLgrdADp4O3TWp9+/3sXvC63n36GVGkrGxjRqaREWYQhiHi/VhZP0Caz5DfkQRyVvQxzsuuY/ZbDOGBTxAJD1mL78XxziC+Utm7aUmfdfAIw=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Tue, 19 Oct
 2021 03:15:32 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Tue, 19 Oct 2021
 03:15:32 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com
Subject: Re: [PATCH] scsi_transport_sas: Add 22.5 link rate definitions
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k9dd7sn.fsf@ca-mkp.ca.oracle.com>
References: <20211018070611.26428-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 18 Oct 2021 23:15:29 -0400
In-Reply-To: <20211018070611.26428-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Mon, 18 Oct 2021 12:36:11 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.18) by SN6PR01CA0001.prod.exchangelabs.com (2603:10b6:805:b6::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 03:15:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d39d765-1c8a-420b-68c2-08d992aeb5b1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB459789D40F5509F3845168E98EBD9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6UqFhiFblY1vPklZ473r06Hk8g9Lbkp5kjdjm+BIO3plBkv40KGNiT0ElFuf8bY28+xESJ9Kn6f7sWZOnvIcC8SXmKcUa44uGfzKWutBVEHd9aNKn0uIYnQEwz80e/LFEpoQiSjyjokUJ4UA8uiw/htrZvPtX3lNxYjFfLHtPYoXzJByUH+dvhBfwGnH/JMsNTkpyJKMOepceKeaV5YPjHTDn56EiR1ih3ISNDelOibBJ9Wr1zVmEBYoxLUgRNsqOrZ+tBTCAWNRDVMVZWTdKUFCPdY5FAuj631tsDc2poU5/5X4naH++3VxNy9Gdf/XRWc8iu/GLBJVENyCU9jI0qbco6tPgwjr1UfOyY29hT4MqNCvZI1dtYRea3eNPty6xjBI4R1Q9U1SmzqZGo9ii7eca244xtmpHguOkOo2VoZB4um/0b3RKN1qlVjFGKsA0WCjdmQQTWUSxWiDEx70xVgrymZIOPSlqmqUR4LeoT8NbwX29kDVPZaQk4enD9SBS66TxOFEYwE71MEHQ6OcR2z7oyG9q1Urimy5iN2QPgp94/d5t73GO6DbD9LfackW8j8/jmCQMGc9H9DK1x7wmDAP1ih3VZQrvC6e354PgWsPTQ/0LlFTENfogYrJdsPpyJC0HG1eJB3G2exT99qvs1Fg6QWX1nK1FOYAuVSu+pQ0/Sr5466fQiFZK5LmrG7yKK6fNwYSxEliC9VBheO+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(66556008)(55016002)(36916002)(558084003)(4326008)(7696005)(66946007)(956004)(66476007)(5660300002)(6916009)(38100700002)(38350700002)(8676002)(8936002)(2906002)(52116002)(26005)(186003)(508600001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jm+D4kDNS+hRKRf+zMB6Llv7nFSpp3/r2Rdn7mSA7kMlHV6INc7JC9XViF1?=
 =?us-ascii?Q?XByKwx7PCW3GzrzIPPtIVHRNgAP2dtzsYJHdSeKdghg0e94g5UdkJlmfMajd?=
 =?us-ascii?Q?Ts3st75MxI4KjX5bhVr8AK21KqcQ+nH9zmaHtf/w6IKf9br3ID1ozJA6K4gP?=
 =?us-ascii?Q?AdKmPUrMSYTnfnJR2ELdR/lBi8WsRkddTSkxmRmpraw14oT6c2kq3mbj1W8Q?=
 =?us-ascii?Q?jfof3IVSLBcs+PSFB24yHmVUY5G9Wwn3ozlexgVd/37FVLO/JPMJZUNrZH1j?=
 =?us-ascii?Q?KYE2DkJ1ccJry1v90sJIDBnmwbxWupNP29bmIIvqAWbczuEHRsC09BHkgLwJ?=
 =?us-ascii?Q?gLOGCYnU8LHxnM6Z7Mgas+6ZMSoFGMuuHXBE8WyH59TkTYvWVHBwquF9tCeA?=
 =?us-ascii?Q?+MmYBFJ/Y/keUcmuaGZd+7AIkxuHNBFIAZ+yUmfo/0doMgf/tIC5QOuUM/j2?=
 =?us-ascii?Q?oDWabMzCnvIzOO8QrGQuW1TOWTO8LNASI3yz8Gtm4aFw3fQHg3yIymQ9xtW7?=
 =?us-ascii?Q?8T4ilOaSleiu54XZVUbDgJSjRXAESkuFTsvqy9+YmBbKkP4YL6kAA7PZ7tgr?=
 =?us-ascii?Q?AfB5Jxw6o4fvCl1BXVgpcVRGEesY013A8C73oF8lV0L5FQjvYjDELw/26u5/?=
 =?us-ascii?Q?dCc4oGRdyHqyu1tTNlnVeJvW1g9lU+RqBo32t3/m7jUX76AtDWk0cz6AO6O0?=
 =?us-ascii?Q?cq0EpO6JmlV7TfGke9kWeXG+V3NF1OvVs4qTEfJSXrKhzapt0BGvfFBfmb3t?=
 =?us-ascii?Q?ZUi0nLxbfNsXHMQWcA44hugOAzfvWC4hytBP08RUkVSWsCEj99WWgGxX0j5P?=
 =?us-ascii?Q?H8VRP15wjY/zCp8pwy0kGqSWntZszZ76H4ODwdaePYshDVbBba30LCzA08Ch?=
 =?us-ascii?Q?SKKe5640xXxTXseSFlWyiDD3RaAgY10/XaAc5/afI5ehV9vOq1y7VpzupLJ3?=
 =?us-ascii?Q?8r2LUxTCKPgD8fDK2nAbcuy3UoMvxDUwdkyGeUzZAX+6I0crhZkN2wmvx9iW?=
 =?us-ascii?Q?nfL0wqd9kI4AjaqzXMWoFoLsC7KdqGkyS35XWgxJGHSy4Y+UUsq3msdqNe1h?=
 =?us-ascii?Q?JWHeqUsfwFhGcKKnNLJm8MtTmNEwcrqkv6utHWXufq6X8JNMrFpXS8xB/F2Y?=
 =?us-ascii?Q?D7wmvrNub2dVwhlDJETd0XeK1THwOIEaMK24750ugcq3vzj2fDWRjg8m0vqy?=
 =?us-ascii?Q?YdhclCNB6MSoKTbHuNS0J+4YlbmSHMBv90q6dugSncslc9Nt054tkoUNjl8q?=
 =?us-ascii?Q?mHlIulw0lcPO8stGpHe+1um+Djp5lkZTX4qIQ3Ijhnz09lELFykFkiWF1aVl?=
 =?us-ascii?Q?r77nHVVZ3XIstolOKhnoFQAD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d39d765-1c8a-420b-68c2-08d992aeb5b1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 03:15:32.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZJNtJ1ZnsPiyscRXUIYquH/2ugYDWOb63Ju+H7ECaik3se17YimfTmKVPR8laPiv9nI+8HviUni84KIhoPiVG6TEIJqbJAoR+j7mcmgplIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10141 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=904 bulkscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110190016
X-Proofpoint-GUID: bPp7oXDwvDInWVQ0TnuemURuZ-rFj6hp
X-Proofpoint-ORIG-GUID: bPp7oXDwvDInWVQ0TnuemURuZ-rFj6hp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> Adding 22.5GBPS link rate definitions,
> which are needed for mpi3mr driver.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
