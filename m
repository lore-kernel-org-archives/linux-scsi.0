Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDC8C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 03:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EC7764EEE
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 03:29:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhCDD3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 22:29:01 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:39266 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbhCDD2i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 22:28:38 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243LU4J079468;
        Thu, 4 Mar 2021 03:27:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=d8CnOw44iNM3bPPfsh5mRkWQ7IZKyZw+V1Os2ij2c4c=;
 b=IiWwN2A4g/wqFBDDs2nRMWDPFKp5CB7X54Vrq8TwnvFmCYjHk3xCaJfEudcd1wqdYBou
 4GNP5QIda0rISJU7lQEMSUOSdm1/W6lOzPQF/9kgW92FWioH3SrziJyy7NRrKIFc40Vw
 RRSCHnNlDVFrJ1Ma+s1d9VgS+foTlxwbkwwZZBlytjRGumdqXAfBZ/Q1t+2pd38COels
 T4IA5Nh3LILsr+OhGo3fiTMPKz51MJj3LlGIbuWL25b21Qst31vAtdulPK7YJB7jq5GY
 b/jxjSBmJWWtxMir6SBqC+5/g/MbbHeiQfKAEK+LPvjGV3R2gjOyuFwPfocZ9rKz0JZq fQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 371hhc711y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 03:27:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243L5Ax040254;
        Thu, 4 Mar 2021 03:27:55 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 36yynrbm4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 03:27:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fz/uTJBTdpYhbiC3Rq+I73lFU1FWIzMyk0LilvOPqHJmEjo++3DRWvNGPwNPWrSvKcVV3PJJvgs+ETWXGuowcVHmW2pTarv/+VMWnz1os5T+FSvFA9inKFTcxXoz+lyckhYfHYw6N+phr6R2B6/aY+Vf5uob7Lx8V4fTfmASVhww5vxIiWMKNtC3Hn/ZogjpAqu55MQntMcSTWwHquLMpSbrXi0KijMX8hQMDzvcgJW5YNDynI9eUBu1MCYBcOV3M7b3uHosaQEz7+93xpik7DMgCpJl+4vmQ2T41DgJVg35+MRzDTckn/YL6e8S2+e7fVJ0c790XGqXatCb3c2enA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8CnOw44iNM3bPPfsh5mRkWQ7IZKyZw+V1Os2ij2c4c=;
 b=PmplcRQibdXujslk5r3nbGWGe3qNkcPqe6ztKrO1k80PexhuIX5JRQwpEiyByCffztdBHON/YKPcSdFGVDMCXJH3GdReafh8dKrZ8aRe/kNgL6H8WBIYbMOQhBwm3p2wycAcdSbvwka9aLC14MM7amgoZZL3od+AvYA0+MM8Td+0024E7iO+7vg8nvluOd4PcG5co3ytFPog1AdehxFrUSGM3EK3q4GsYgJULpIbUCYLAIJ9QB+QDuab7h22yR9a1pO0WglTtizZdlTeO01ekvPdkOIijFFZBqXA1Jyi0Yisa3H9G1Adz4fOIq0exV2LO9MzS7gXzc9dCrzJYxhm7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8CnOw44iNM3bPPfsh5mRkWQ7IZKyZw+V1Os2ij2c4c=;
 b=G9Dhdv8sqyyp6+7AzsTqlP+5wmReNscaRASOjQ3ua2PxJp+lAAQsMeCjPZU26twEySm+MhheseGOjhkvorK4frJNL+hsUVwrwcZBIDx9uh3dQ1f/o9w8VMLLDxfvo+GvUAS7lYL5uQ9r6jwUN8lacz6f1iRgkr5LESEIkAP1UMA=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4423.namprd10.prod.outlook.com (2603:10b6:510:40::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Thu, 4 Mar
 2021 03:27:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 03:27:53 +0000
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/5] io_uring iopoll in scsi layer
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sg5bha3t.fsf@ca-mkp.ca.oracle.com>
References: <20210215074048.19424-1-kashyap.desai@broadcom.com>
Date:   Wed, 03 Mar 2021 22:27:49 -0500
In-Reply-To: <20210215074048.19424-1-kashyap.desai@broadcom.com> (Kashyap
        Desai's message of "Mon, 15 Feb 2021 13:10:43 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CY4PR08CA0028.namprd08.prod.outlook.com
 (2603:10b6:903:151::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CY4PR08CA0028.namprd08.prod.outlook.com (2603:10b6:903:151::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Thu, 4 Mar 2021 03:27:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bf61c276-8d9e-41f6-7477-08d8debd7ee5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4423:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB442386B71D15AD75479011088E979@PH0PR10MB4423.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vn2mc7nb63ZK/QLPCMxZCZ+LsqwjWXNfD0G15gZ/qoq+rJ9mx/XRp2vNJUQVznsi9oTkMPPUI5h7uO+ZHuRnQqQrz2NF07AIIR9UCFR7Z2coIqQo1hcKHX/1Tkwq8s2mRtMwARs8oUjD5PWT6+RfGAkinjvy8UJOgZxAt8/9g//U2mGr/snEnACJYmfiXsad89dQ3icCgrPoA7SPEFLlw32Rg5vljYb6Ky1MB2QG+b4VMaSdYb18w232cZQr+nMEPsBb4HQvEhCVnlBZ/t8IaRr459lLFld3W3vzhzXzOR+QG6uqANommZLsDesUN02oht0K6H1OWBuMej1pTfov0Qb8mlLUq2R7RgwfoiZQexrR1MFWJyu9eESshfCCmWGpfg6cfR5tgCWXJDKCxxMtIhdDSCLwjVJ/tiagWVMW42zYNcSsi3waTGjaBb+Y/8gNoZgzTTbWVQgSuQdX5U8GMoEp6q686dl+HMnM/RcsD1bl42pqKf9A2nyIfWyoieZ4m+cbyJk4lVsi8wUaBQqu6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(376002)(346002)(136003)(39860400002)(2906002)(316002)(8936002)(558084003)(8676002)(55016002)(4326008)(956004)(478600001)(86362001)(6666004)(36916002)(66556008)(66946007)(66476007)(7696005)(26005)(52116002)(5660300002)(186003)(16526019)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lUTpYl97ISygzF9JbCPs0t0DRWaVLXUvX2OKVzmxzzr+9S3pWP1cnihF6ZyJ?=
 =?us-ascii?Q?p0/9LdDL70ApgOTMHV388Hao5+qwYaXpHywu+wGdjtnE31hDQMglDr3+ueYO?=
 =?us-ascii?Q?h/3bPinqHAmX/1uLuC8jj7i9fY517ywAvBBvf/dZoV+TVw0ufCyJRIq8jliP?=
 =?us-ascii?Q?tNDd6efnfuhnu0vn1CV0UdtqoLLN0rJiFEhjtufNTsKjRTzg4QHo3Y3RryYx?=
 =?us-ascii?Q?VXLC2dVubOXCA5uddD3KguVDNlfmVUjZLoVnz902uvwV385X4WBtxm9JXuFO?=
 =?us-ascii?Q?MMFQJ5i4drb5vrB9gYWXvhzkBq8viE1uNSI20xylVjeBxX0FgYhTSI58eror?=
 =?us-ascii?Q?8EwWD7GeCqeG0A1C68aVnAcw3LKoG4AhYHttBQ1J//oB5UuOgRhaAbdcheVa?=
 =?us-ascii?Q?3j8FNrBB+2wkCaomGKg2Hq50Nk8UqDNpEQMnyAPXaqS8V5kmvhVRA4KpKX4o?=
 =?us-ascii?Q?R1HNNTUUgWMWgYwbPG1BDg49dSrLS4ss1zHrBATLPMo5mJA+nQ26A9u1DVrm?=
 =?us-ascii?Q?Aima2OVX9xs4ex0JXufs5u7DdlsUX3VO0UDsKxzq3KpGpJ8Q0K5VP5FMq4gg?=
 =?us-ascii?Q?wgxBy59oyb9GV1uTysbT8H03cDD9P95KaRZH8v1LJKeeZSu/RKb6RfJZ6nXx?=
 =?us-ascii?Q?C3EQlC3JArxQ67t72igWPIasu0AMXDizaPaK7LvE1JJ+Or2iEHTBMsM/1fPT?=
 =?us-ascii?Q?HldxO49a2Hq8RqCO3WbQ/pjVSPXoDMn/dO7jbhzVLRgxXz6ibtjhSTpAtwYW?=
 =?us-ascii?Q?7QMBie/l73auTQ21jwcqH505N7i7VRfO95eSGi46ucEllcjbGllvYCvcLCYC?=
 =?us-ascii?Q?KWk6XGNkCfRf6THmQ1orz/6CUWfwm1xnLSe7pT69khs8v/57NXj6hIN6KsIk?=
 =?us-ascii?Q?7RuCrzBoBlggEJ9FDsEl1kBl8UO5Qb/5DzLNbEz8L4EEOauAKMYJSgp9tRyG?=
 =?us-ascii?Q?V2QkYBga1kTimtldfiPlmEeIvQDobikUTCUztYiKrg0XEBzunL5pclfGATrC?=
 =?us-ascii?Q?O0Z3t/PBIbSAG3YZUPuIVXEck7wzz59GBoXgvhptD2tPmaNvhd2xUeZk5DtJ?=
 =?us-ascii?Q?y6oSQ1KcDNqFWG9MDDRSNL2bmxhDgGMLETWKqbHVCJG5bKAGqSyEO17tUtpC?=
 =?us-ascii?Q?ZMu1gTAchm3RyOMkW4nxQ2nAs4m0VFGBASfgIwXkoZWc6BnT7/Q0SNfowHCB?=
 =?us-ascii?Q?9Ybm9ZJkchhdPZ1Tf/KHC3b4Hiu+7CuVYNKvrdMxHLjoMsQULGR85yCGH5xE?=
 =?us-ascii?Q?1srnIakYFvNOHgeY7+bWgoyxltFwEn9ciXjlcDJkqqgLfHcrEdH79ga7Rr11?=
 =?us-ascii?Q?hP3tQ1Bnrb397DvEMgpxcTtS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf61c276-8d9e-41f6-7477-08d8debd7ee5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 03:27:53.4685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zFTN6V1sL7Unwsx194tJB7PPa2po/Msugkkoi/Yi9gIhWoSuOBu3U1mjvFLkzCff1jzvHJNEe4TKd+xnVKCEY4cP1jexYDQaaE9zQl17Vts=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4423
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=976 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040012
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

> This patch series is to support io_uring iopoll feature in scsi
> stack. This patch set requires shared hosttag support.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
