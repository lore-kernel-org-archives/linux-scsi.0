Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC759C54EBD
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Jan 2023 05:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbjALFFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Jan 2023 00:05:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbjALFFb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2023 00:05:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893A14BD65
        for <linux-scsi@vger.kernel.org>; Wed, 11 Jan 2023 21:05:28 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C3Ppvx003509;
        Thu, 12 Jan 2023 05:05:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=aQ04Emglb3DvVVJsrBqQETxlOyJ8n3AD+O4+ycx8wug=;
 b=D115GgSAJteODvd6XOw2IA6R3P8+ur2ZWlM5S+zAfXMjCwoyit02wBW0DI8p/NFBduTz
 p7uEX51HinsewnNHWa5DsV3EhOrs9fzjDWkQV6NyEMX6ztY0CROkJlHF2hNeSYKGSqt+
 gu7pwatFmPCAnFF2hUw5AYbDciTKlPZrvRGS3wIp4wMjVOxHculXaIjmBVzJSNjZnvZj
 RIUcdfWLuoPoG8Emy1j92THjCFBkM9YKsOmLDXV7igw7XKNRw7NssKWm1Ec2VdFDMa2X
 tVr1jdPEsEmcPbdyzV8t/F3S6Ylm4h3330oNQgiavxbBla8kFYVlm5Q8gvQ7C8WCBig8 aA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n1y1nhmuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 05:05:27 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30C3FdRZ021731;
        Thu, 12 Jan 2023 05:05:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n1k4pq6u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Jan 2023 05:05:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fK83dHKAcrGLtxMISydXsk8XcirnJhvGJY2Thpgic/3bY7KZq9cr0ExaFRHZsSalQXZ8GxPVoMRd8B66+pzzp62V9adJZGHzBenWH07ORlKThYv09x9f5Y0IV0oGijVy5nZPqhgy/ZlAs4fNwv5XUj5mA0FoM7Ma1PKIy08uwLAixHdllJ9JXGVuzx7ZgidcgAM4MYR7jcHtugjXgUU88ZIQlt2U1/UbB6NfC8J4rmPQVVSATThgVI0H6n3dBixjLpSDJnB+O/ayJZWtKBKVURDyCBayCXeeDZrwPuu1vRVjyQTI5gdXBPpzC6chazTe4jhaVmazB9U/uiH0fQmLxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQ04Emglb3DvVVJsrBqQETxlOyJ8n3AD+O4+ycx8wug=;
 b=A04Fr8FAE9jC7UBmEzTqwjoeZF6YSgYi9rJEVd1gPK5Y6XwTQ+DMIN+Je7orQ92r+mOtpHxM+2uSKSr8r6ITJA9AAXmGNBWg4CwQ2z4FY6pRqsxo/E0Ek6N/8HzvUtGvYqqkep/PTrSpk7rUWYXF+0vtTctA45wnK8+Sn68ZD1xaVd9ymRraZoyq+LKgL7u3XpBbB2bJ8+vxkK0jDTtfblNDEPSArCRU93QvdK0yiTbrjf2uS5w5DMpUBx1I87ewY7SB7Bl4dh4t+QIemxWQ+kRrJuI1QWwvROT95JSK+ycoRGtL075IwZ1nfJrZ2i00nds5cT2OsFRv4KezNgrxPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQ04Emglb3DvVVJsrBqQETxlOyJ8n3AD+O4+ycx8wug=;
 b=OXVeeyUdFBQ/ap17qw2xP2RZnzmm+ohzpFUyz/Xq8pKkhnVk8TpfjNxXMfr9KzKhkvJmn1Jh7arOBBKPzIaCUkqbXP/WDa8JWcvdvPtgoJa7+lOJe1/9c5LrKYgtsNUnTe8VckoKi8Dzz6o1VOQZfJMO9WiUwl479yJCpWLttRM=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS7PR10MB5149.namprd10.prod.outlook.com (2603:10b6:5:3a7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Thu, 12 Jan
 2023 05:05:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c7e9:609f:7151:f4a6%8]) with mapi id 15.20.6002.013; Thu, 12 Jan 2023
 05:05:24 +0000
To:     Justin Tee <justintee8345@gmail.com>
Cc:     linux-scsi@vger.kernel.org, jsmart2021@gmail.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.10
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lem8uywi.fsf@ca-mkp.ca.oracle.com>
References: <20230109233317.54737-1-justintee8345@gmail.com>
Date:   Thu, 12 Jan 2023 00:05:21 -0500
In-Reply-To: <20230109233317.54737-1-justintee8345@gmail.com> (Justin Tee's
        message of "Mon, 9 Jan 2023 15:33:05 -0800")
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0020.namprd04.prod.outlook.com
 (2603:10b6:a03:217::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS7PR10MB5149:EE_
X-MS-Office365-Filtering-Correlation-Id: 33e6cb11-0bb0-4027-cf63-08daf45a9cca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hpOxWh8Rsqd8bmV7dhf1JhFuSmORxZRVXKlQ+IUc63Wyr8V+XqnCkZp0BnC2wSiLKNcRbmLhP28J8YO77C69XpwCMvvnxkMHfFYBrD4dDB/MJsKcBtQZuXdDVPkiScfNQYwd7vc+Q9wefJHZLpJFELGUGjtV8XfTSfsnzE5Z38c2zMMKoptaU2yq2EOQBxTXRKyC1p7fy03LCb/qZybBvULR8TaDbyMlckCmf/qfgoQeIldsuPLMSrH3t8MWj8bfio8lA9BCLxQ6bTtDF7H4TGY2tSo2kcmd47JMrh4V4vCVKkce1baymsIdqiy2d7ShvdFOZdEkN821Zo9Hj5q8eCedyW+4r1u8Zlz7Z4Kv/a73YU7ana3XDQj5p27BKV33vOFpo26Y6HiEQQ+9pkpM1p0a6ghaRbXWv8NUE3QpNVbV4pIf5K9HcL9lFKuo/q5PRRClLACy2+l8UkMsli1QoGR18Z+IU4+LSKLF+1kH+kC//reVm1c00QHE20zEOneWewJ0C2nFK4b9S8tuKs0ePMskB9JsQrb4c4/H/57FZoR0M/YssFrj+mJcr5Yv3bic9OSaQLTiNU449w473w9/bsBPK+YASPIoaPt443EHiv0ZugZ9AgZeLTvQjYNCK5LVOsHUHv9THYP0w9ZVWLMunw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(346002)(136003)(366004)(451199015)(8676002)(66946007)(66556008)(38100700002)(66476007)(558084003)(6916009)(4326008)(186003)(86362001)(6512007)(26005)(316002)(6486002)(36916002)(478600001)(5660300002)(2906002)(6666004)(41300700001)(8936002)(15650500001)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4Bj0qyUJ6js+JVT+Y1Nm0TZH+6NqY6sxmmX3R+KRcLz5VxWJk10ucNN3nfR9?=
 =?us-ascii?Q?g6uexUrVbPp0mK996d5FzZqFXEtVnvIh8gHgcIuAGHO/LuGLnlC3eJqvnEh+?=
 =?us-ascii?Q?wO4fO95NWcv+WCbbNAzo6Xsv648je6bq98x7QdSe3jSj3WvrOKtOgb1/YGB5?=
 =?us-ascii?Q?tUhi6qhasMcz28+DxJ60kNNr0BfvZjc4v64uyzdmRXtxXcqwf+M4owRgRERM?=
 =?us-ascii?Q?fO+/flF1NsJRz8hUEC5SBG9DX0QUnhuYIvhSU73F8ZLFY+wlqnZiPAmy1MNJ?=
 =?us-ascii?Q?bwQoh9xsoGiyJ3arF8ub5YvQ8llL+KjXEKboSHlbQk0qqcDmp5MRWEh5MAgB?=
 =?us-ascii?Q?z8zhkgUKs6zAdKrE9m7syWSld02S7pfmOQPn3+XfaVSgwzapy0gc1sTWOZkb?=
 =?us-ascii?Q?2ajQxZPVFCRn3A0vmzzNDgDDsUl4YpnK9kHb4jWwuXEQwONlCDvHsaZUnzlX?=
 =?us-ascii?Q?5MJwP0Ph5bzBBtjrB9/n+h91/iYjbQ1Qv0A1PYOAjb+XWRGcRdSuGHujGWVd?=
 =?us-ascii?Q?UXJnpGmt3K5/mBNtWmqi5EBcMNPhwJRNK72BKn+XW7hhxnj8pLY3G9t/I+pS?=
 =?us-ascii?Q?uR3MjK9ecnEZ7JUio8Wu9ImyCC/fcr5DUk5BwcXCqb9+rRSTL527hDHltjZb?=
 =?us-ascii?Q?BYXhngNKCzBt45zy1+s2uG1j3t+9cMg0ETP70iVXHC2hMn1u/8WeAeyVSHVO?=
 =?us-ascii?Q?Kf16luHkcz3PNnywMZV9+7rc/FPLYpTh3SlXKV19Fhv5ull0Q7ov6ElFpoxu?=
 =?us-ascii?Q?X9YCNDelIjmMY6OEZonpJ2dXYmF6lx6Xn1Eoqijs9q4mPi3+CUDoRRD0jVPg?=
 =?us-ascii?Q?ppeTMW6izjy+NRE517z8isbX+dL4gqIGbvrzjxU69b9UcZaaDStcD6Ne0yqH?=
 =?us-ascii?Q?6Mpzvhjzwj9wEkLxYQHflXFKeXhgaVg41meCz8NOMXnzJNH0JMhpyv/sTpWn?=
 =?us-ascii?Q?DQLLc3viW7bYxaDtrv/JYAfVWYRj0SeRGYU1F+80aUI+YoZ9zoTRQzB18Ffz?=
 =?us-ascii?Q?RXAWmcawVSFjL0Q7zdHJQdbi/yFsyznvbP+HB8LLIsws/Cd3O/qn2JPNAiw3?=
 =?us-ascii?Q?cTOck5R9uAofJHkWEruTx0iUpRx5fK1p6GQASmCVN4gyqpREmMrh45qmXShh?=
 =?us-ascii?Q?c1K8Smo86zy/qQIz5O2xRLpSChO3mwE5ydscqdweV44Oyb0/PKSg+9gvKHPL?=
 =?us-ascii?Q?4ysS+WWyJIUcrtTTLp35A1ju8Rm5baABkaP0DggA9gx70g7SaLNf8qTV7eCq?=
 =?us-ascii?Q?idc6VArZ1gp3fZ1iXPQifagXJEdlLz+p+XinGWjOrmbsg30Ata1YZimkCLUc?=
 =?us-ascii?Q?bTCjHXAyrZUc321u05N0JQExLOJYLGmTSvHccXjpNciQIosIuLypF9NJ8oqv?=
 =?us-ascii?Q?5lBTeq5ziHEr0cwSJfMXWAbuj9XrEk/yPnnq2p18nuzO1wu73oBpiEcD9HGY?=
 =?us-ascii?Q?prdBuHzNIF1vXz6EFXjXgIK53DsJ+jK8uCY9/g7WnAzTzTu1DstM/C+nCtxt?=
 =?us-ascii?Q?HbG8VxYkV1Y5Fdi3dqjd0Zeqpug/GzN8ZrVxpdr/n0NYdI1tkgMwwczuc8+A?=
 =?us-ascii?Q?3O9PzssWH47abfKAt9tOJorggXxNepmtwsF/8c8XKatU/y1FrrTUMJgHCODS?=
 =?us-ascii?Q?uw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lREj1OxboicLUGuAhxtbhpAL03XBWTIOD+VZN/IgFGYy4lwc0DZqNc145EwnzBqzO6j8uglL1fvS14CqWG8KyPuJAz1RBqeHyXl/wYYsG06thFT9yamudHZJ0ugUsYYKV67UEnjTi2xkXww7EkOg3H4BaH2EGC4/45sSygcbVX+oz5cZxKiCIv3I1BgIIQuA0/eg2BOW7MHrei/8ckQjBAYuRA/Zglg7ME9GT7OAEEOQWZ4iIFaxgzm3N32aqolz+NkbL67mbSrdui3lsEON3iaDrf1gauTv1e32Ce5njLNQ3VEjnMDXeGWAyWrxLESgxpbo6q9iKHxjFwMaUKAQkaEoYZhzq5tmfO9UCphLYMmeRSVT6Egyo2UxIngsMOB+U/mkuYB5fCE5rq6oX4/mrpb4TJyom2uKN2mK8Cs5DQGepyEvT/maWxhIkPKtr66VN75toWDy8AyztZRHDpDTgTnYRCNUY7L3Sm3SQIKmt9VjZII2NWRm5Io43SooMBQcvmwFMGWndnZl271Q++nikn2FzqwnGGRD+pzhj2fowkdqfpIkHA1VT8wMbEDhHnkIIyXJVIUgP62B/sPSG6fo4dmZ2EOPs/fe9QUWDvbJn49ii1ZJyY36KQGR+A2ekBPJU5i6GVIfvytv7rcBU4VVa87Xf2FWa8s6XW8ZXH453MhznH+MPXfc62wipp7AS40MyV6JOTEwrFv4lixAqCw3v9pLTjC+FdwLnZ9UQVExFmtqa8p5XATWm3o4xn33FqJlbG4LhUdqgxgICGte7Dx9/wDydIHuA7m4kAgzbOVRXUjjSZe1vx9mx3fKPcpqeCs9
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33e6cb11-0bb0-4027-cf63-08daf45a9cca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 05:05:24.5023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHQNg6ZzmTGMg9RkyKV9aqcXxZQ0KG4M+91uJUNM9PEeINgCjdKsaSd4Yu5igvTT7bM9S/R11K8OhSWsLZhYdhf5QnjMWUY+OcSWq+lmZwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5149
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_02,2023-01-11_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=530 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301120033
X-Proofpoint-GUID: 7TyC4x457gTKc5k-2ynV-tg4gpjtzRbA
X-Proofpoint-ORIG-GUID: 7TyC4x457gTKc5k-2ynV-tg4gpjtzRbA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Justin,

> Update lpfc to revision 14.2.0.10
>
> This patch set contains fixes for bugs, kernel test robot, and introduces
> new attention type event handling.

Applied to 6.3/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
