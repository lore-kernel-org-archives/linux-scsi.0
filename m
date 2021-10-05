Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52DFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 02:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C85061381
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 02:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbhJECXS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 22:23:18 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:44848 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230237AbhJECXR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 22:23:17 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1950qIsZ029448;
        Tue, 5 Oct 2021 02:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=ttbVD1nQOH/hig69X4fCvCr4EdRNmlWE8x70B9J0Uc4=;
 b=PWHou90V3tBZrp3wlxqq3pk15osEym+o+MGq2gp4S5pb1fOUqH6s5/YOW8MQCHXv0GGK
 Qz0D4w2R14GVD/SqDOdF964dXyPE7w3Ib1zVEWeN+SxSgB8Y+C8g6ADewgNBdOlpcbZP
 G37uCvR/Z+vPsHCMRoPejLBTzqBwM0pCUDdwcmo4qUY9ceGvoQhrojAda+klopyVtSk2
 wdgsD2HRScz5nGZTB+uooJaw3ppkQwDDeY/N1NNnByA2u8m1f+MmqZiWGUtdxe35ObcM
 SShHYSggJ233oUl1g/twigObpdua6sZBcPVG7R6isry/oXM/Yt9gX8exz/LP3owsvYBG Zg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg42km60a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 02:21:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19520I4o100928;
        Tue, 5 Oct 2021 02:21:18 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2171.outbound.protection.outlook.com [104.47.73.171])
        by aserp3020.oracle.com with ESMTP id 3bev8w1c95-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 02:21:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sqh9DdYEOpsLiyz9aeYTSbbv6SgJA0dNxQpYCSWmnuqKLSQKo0UPCnKFIHkx9enUfWYjm1fcGiBhthMCQbLdZKmgqhG7Z38SPuHIYJuNNjU5rU0X6YeN2f7XHDG6sU+qmTlCktXy+vj8hPSqG43CJYLEne9AK3uZlayxHBgcdVhLyb9ZyzKanBGhlPQbl3+iLgm2yQas9qrZbFxSojo9HRNMLURe9Rgrq7Hi5l5Gwl8KflQmrjysmkL1/RX4tOhonAKOx4Lwi21XJL1t5IWtIBnLaf4d8f25gR57zJuD7VyXG1ol6ATRhMB4foD5MRzW2NmVRbxLKlkvGLJpTOHO5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ttbVD1nQOH/hig69X4fCvCr4EdRNmlWE8x70B9J0Uc4=;
 b=TRQYQaT24dXBaBCko+fZJN9iXK44Wmt4WZLiaqwvxRS/yD94+KSI9y20Tb43eafeSSd4G0TGHRZRGe5GoSjV/lcrossfpfJ5hsJBV8IVAiroWW3JuAyJBSqoWJs1SaB5vDdtKCbPR5nvLvNQbs2YDpXyFOl1Q2D4/CF0m38XU9iZpVQD/KcVCIvVRR3xywJJwnY+peNReSVkZpEHc+S6/KL/9JvLUWWc8ex2GACsTnf8dfingzB0H43PiyKzWgnH5hh6e+tbuvzFuB/AiVHdLydFnOTHXNDmqch+xXZ8yB51GXSzLiKreGbnQ3XSYFSnM/s81YAuRSiA3IGHj4a1hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ttbVD1nQOH/hig69X4fCvCr4EdRNmlWE8x70B9J0Uc4=;
 b=X4dx0cfxzw8LRDqxcTJg95AElZ6R+d/G/juhe7bO3+nwjCVB80InHT+Ro/AbUry6wJvzc/BPnz0j9nREefC8R7I1d9M9fDFXJ8nkOSrpEShB5j4SvCNVpRLYHQIaT/3ePnqnI5cN9liItj86YH547aETJpPDAfvv6uFet2hv1zI=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 02:21:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%8]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 02:21:16 +0000
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: ufs: Do not exit reset of error functions
 unless operational
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fstg8b5b.fsf@ca-mkp.ca.oracle.com>
References: <20211002154550.128511-1-adrian.hunter@intel.com>
Date:   Mon, 04 Oct 2021 22:21:14 -0400
In-Reply-To: <20211002154550.128511-1-adrian.hunter@intel.com> (Adrian
        Hunter's message of "Sat, 2 Oct 2021 18:45:48 +0300")
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0270.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.0) by BL1PR13CA0270.namprd13.prod.outlook.com (2603:10b6:208:2ba::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.7 via Frontend Transport; Tue, 5 Oct 2021 02:21:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a2c7adf-3dd3-47bb-02cf-08d987a6cfa1
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677C78630B384D1890A92AA8EAF9@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dtaaVeI6RManFxItp0m1AlMKI4q1EDNJyRBGG13Ta1oZUIP61ZYjK04W2ulaioxa44GObjU1SjmxIL5umaj5RcJzodttrTAoDq3DtJ8wbSidBx6Xr04gcFvlgIAmrCYZ320CKAYE4EeVlBmkM7cJYHdeAI5rxjGLUrlBAOBLmz6MyQhMKpoWwjUQotodfSLckSWvfiVqnwoaBve55mHmVJmhW3xDIo8o1asZ80msqB8Q05gNHMGAtRXSjUn0Lvv+hP/6mYegjycgz5gh0o9wYVWdL78kYu8FncHf1iEhxV4ktUaWulshDg1wVz8Ve7uY/4caf84stCHlHsevIkjmIlLz795ub+MXgiJlgjSOQVFRNOI3BLHnhQAb/Hqj9flHOGIrMWv3B+bJuAHVr+aCSr5EI7wiiMD08rsuUYIhlQ8FhdW7E9O6kltLpysaVj8P/43pgAoZ7jV8UkThz5pulqHYl45yrf1+5ALjgsLVU8/TX2x+NZz9XKC53VwQymsJh0m8n5xbPhgTfDIRChZHuJM5QmyEPPbdtZQKVOg77TuzwsjmzkVaggfzuQ15tI+nZiuotdBoINJqcg9isuiP6Jb8DBjb5muK5ATbBxiKg8iyHisBJ6lI4SNktv2U8Lp1biFhID/T/c4DbDS4ysjB4f9KtowLsdT9GMAPmnNR6M3rxXdiLpAwKpBqkOYIXQLuSkGZyKt6ioLd+NwWKzjOVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(55016002)(186003)(26005)(66476007)(5660300002)(6916009)(66946007)(66556008)(4326008)(316002)(2906002)(38100700002)(38350700002)(52116002)(36916002)(7696005)(956004)(8676002)(54906003)(508600001)(4744005)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uRNYHVk4+uT1O6M26D0zRIAMkCGcclztsTynNzSiJTcTjsmShOcDgF2BVV23?=
 =?us-ascii?Q?kIBIaSkLE9Q9hqaH+6YZoCGq91ovTxqBtm6GKVwFPi2addfIb82moSerWuxM?=
 =?us-ascii?Q?V0RQV+D3re0Pw4oHSaRoRTx49+CUQcrltr4tKUwqBcUj5ktQ09oAfKlzaXrJ?=
 =?us-ascii?Q?GuJ1K6yRh8G1k7D3eFj26iccBDHjfIjg92npnRyHHWIv1R4rE4MDWe2+mlFo?=
 =?us-ascii?Q?NSrId4pn5/4chqNCqdUfO9KKCkMtQW2q/gTd8wN5URMTdEUpqqoePbzxOQtH?=
 =?us-ascii?Q?8DdV0MG7kQ7Gfzrv6oYI5JEg9ITHzD3DrDHNzWhyajLEYvJrXoqzE7+oicWf?=
 =?us-ascii?Q?j5AoFUCPdOAC9Wu9xx0hZ25ZjvmZxLeSaNeCeSN4ZZMcj71eNd/mSXvrM1XE?=
 =?us-ascii?Q?XaZCESzs0kYiIFYkX9cXPmgQFXCAUhjoQYEf5Sr7CM29a3Dax1J9Y4kCHxrF?=
 =?us-ascii?Q?A73ZzpCi9M5F1C54V57/QD/EsUeG176QvNKBj4kN+0uh3/ggIjKuBOaS8SJu?=
 =?us-ascii?Q?IoDlmbTvJWo4WEtbz/QAsBQhHiEwK47+P1k3ON5ELwR0uhZw0BmTbIEkX36Z?=
 =?us-ascii?Q?IkNenE+um/eB1EWBWazvqutyaUNFN8tdgeQBPCh9q/ge6ysiKcOP6frQkOU8?=
 =?us-ascii?Q?YTg4+faCf9JTK3Zt7F4Hx1aYGl46+rN/l5GR+AjjgpGr995Qu/Y07bfDoh3I?=
 =?us-ascii?Q?PayGm/9fxGovUTIvDDC+GeW3KRVygQ7q8P/XWQjdnaAJ3tJeunQA5BD/Tnmk?=
 =?us-ascii?Q?xylwr9hqhTWdLWSqlmwiHmw4FSgpPNJBV8SJhYtF7Mqx3sjV6SRVT1lmE+Bt?=
 =?us-ascii?Q?fYWfxrxWC3vtCI27e8qj/ZDE5NNiJ02UIoXCPxIELLqBDDzGep2U4x8pU9yS?=
 =?us-ascii?Q?DahMTvpc5vFYYFE0alb4bZGhokmC8wZ7QB3NZRbm7KCoDepxbWmh7nql4f0U?=
 =?us-ascii?Q?/kXV6iWEk8D4gwtpZPchdouCNp7dXbc882lMgM1ruH4vBNm51g7ZVYLq7CA9?=
 =?us-ascii?Q?dmsBRVsUJ9kWuia/QpAB151Se0gqFZAb/cXcjRvfGB08MPFgOkxxh9Dj4mhX?=
 =?us-ascii?Q?PsHLYwurblD/2KDXcUYeJbhKEPeZS7AoM4W0QYBNH2iGFjB/3UgRcxNUqVkJ?=
 =?us-ascii?Q?EHgSxkzZ0WdK6H/NU6QlscU1Fp4kksFInDgok+i7frGCrsVbf0UiGRJOPMJ+?=
 =?us-ascii?Q?hNfYz9Jy9mX3d1K3pER7hATb+5Q2ykWp0PQg8aRGFgCpGUcIaltt4D6Pl04e?=
 =?us-ascii?Q?4Z+w0vIzIsOhbc6TBvSsHnRAra+4RAxaJQ6ap+YxRUUuqh501x/COFXkYYvn?=
 =?us-ascii?Q?gW3j2RyxsUCpIHX9wLjUJzvj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a2c7adf-3dd3-47bb-02cf-08d987a6cfa1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 02:21:16.8258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mhMRgiffaisYpc2lW9NwtuEGaPLkm5Ca3dT7jJEZwt7YNy1Mvd3QWhljsDYbpzQ2YbftcnB5uxcRQ0GXimo+2D3vpPXvTqzlJjh4n5W31FI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10127 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 spamscore=0 mlxscore=0 mlxlogscore=991 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050011
X-Proofpoint-GUID: fiiOaG2Hwg3Rey5u-tute1He01GXS6Vz
X-Proofpoint-ORIG-GUID: fiiOaG2Hwg3Rey5u-tute1He01GXS6Vz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Adrian,

> Callers of ufshcd_reset_and_restore() and ufshcd_err_handler() expect
> them to return in an operational state. However, the code does not
> check the state before exiting.  Here are a couple of patches to
> correct that.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
