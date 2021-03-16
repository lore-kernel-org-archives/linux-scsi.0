Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 093F1C4332B
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E625265085
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234843AbhCPDPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60858 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbhCPDPa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39sm7168129;
        Tue, 16 Mar 2021 03:15:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+qdtLL57uKeR2ae/QBsZQjQpyJNBTC337sK1zr8Op0U=;
 b=pkB6A6GkEgOQoNXmbCZEOhd8njp+eV7ZL3JQ9vtXQcCLxPo7RsGi6NsvkdYE9weW68iX
 5bYLgxDq1/q7/ZlI/afPuxSWrj6qCS2ZXY/XxR7eLQwdgyA3/rggaEENaU+JBbK+5s2C
 VDjR3HHLDssKl3s1xeQYSif9kVrqe1xGvN7eWLsqFMLejwIC7CWobv0twyH/ULUQNZJR
 xL2ReK2p3Mkkg77QN2LFRGroR5evRUj41B0f+IM0/clhHJ7paaSmfy7kSqubO3TrqY39
 /u50sTFoLg+lXsouPnKJCV2DPA5ZFIVGsXoRYXpvnWtMJPymOk7rogvOgFC8hUp7RCA7 Mg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 378jwbe7tj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G39nhT081304;
        Tue, 16 Mar 2021 03:15:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by userp3030.oracle.com with ESMTP id 3797aygbaa-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UA5lWDZdfFBQfbgZk+n2qKAn7stCNGkixoYiUKXZlJJrxn+2R8HJAEuOdY7M6gMS2W7sIJ6GpAGmvxQIw3LcteG3NyU9BA/EapGI9SWAJcmv3FIl1JgjGcgp7RF4kmhzHFDyleDizHshKELLzw8hvL2ul5kza6vFuRXWbaBoTRgcpVJM4SvB4AATsvowe+7QJUaWJrk/xXJIG00LGmpb2ZFs+fN/JM0/+3J2ca8InYcxAg58+4itgpr5ujeNmmyi+b/ZhvJi8xSnj6j8c1PcT5zOsOYR5aZM6KaT2u0iF1iiWEdyzFCYdv874o3dHPBzyZQkEyLCwXtVj0PXiEfYjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qdtLL57uKeR2ae/QBsZQjQpyJNBTC337sK1zr8Op0U=;
 b=Kx81MSOHZeOeL0j5AQUEuYPqYO/bRM8ZU/6BVoSkj6yuXKKQtM8qb3xsnoRAkyK/ZdiMgPYMoDDpEb574EmNWFzvemV9uME8BO6Y1fML5PNOn2CaGU3z9pQPREEfFTbkanZLjMNZ7TaFyS3iqEKoK1a8HH8my6FBFjME4I+z2STdt0xGer7fUk1x5xrBx5PEFTW3J99OqxEpABTzxeykvldGVWg/AxA+5zAAv9YCGSV2gHYd/Yg4w42XFsO+zHyMvuGHHvmpjdjaI9uV3Bv/EYnaULmsXCBwJzdCxSZCKj9bjfX6r2DhTfvhBuXTEYBDOoFhtHZhXLcbtCSffDyRnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+qdtLL57uKeR2ae/QBsZQjQpyJNBTC337sK1zr8Op0U=;
 b=v90jQJfYlYWaQakFoHUSKkHadEJMfEtzq5Po2Qd5Wf6O95U8OyWbVPfbsVNEXmKuCGqv64PHPxJUEHtG/R0h6Ovyrw9a98GKrOAbcRW0yXC+BS1cWp6FkHh1du78qZVwav1HR1Xy849XuR6XpCiV1BeCR5DyNxq78mYmsqcOCZ8=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4709.namprd10.prod.outlook.com (2603:10b6:510:3d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] drivers: scsi: qla4xxx: Fix a spello in the file qla4xxx/ql4_os.c
Date:   Mon, 15 Mar 2021 23:14:59 -0400
Message-Id: <161586054341.25014.2909275199889886029.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210301131736.14236-1-unixbhaskar@gmail.com>
References: <20210301131736.14236-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 816206e5-dba7-4425-cdf3-08d8e829b9f9
X-MS-TrafficTypeDiagnostic: PH0PR10MB4709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4709841F2BAFDCF983FA50BA8E6B9@PH0PR10MB4709.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gU35gawNHctdUv+Rq5Zp6z+ZBbJiyEZZSBqwEHiUvARAMEzkWJqUG9B4IpF4R9mgiFX+hniFDcpS8XP+Zaj9hInvJfzfXR4Q+wpqH3qu/0gLy/HXJJSmthr9wu+IRF9txKO+Fq2mFLuPO292ePzFZZn+fgMKYBoXMKQ6qOGUy5dDuGccfQIjwjEq6CzZmuRutxjJAn/ussPb3SK0xU1oWgh3YDbYrmgBwntC9KMa90EK8+955CynoUjnbKdDK3yEvhnZoV+XMFi7H3Yfsg76aeBj1OUQfcxyiXGvTNYQHLOuIOHyYWQBzE92BI7iB9Zg3b2P9XIuAz0OSq5xxJ/a94EpBEEuHD3MERGWxCFJdNywdhvB+ahedtpFGiUf9xzbAfzFcUHd+zxptAHrgNMm6cxfmRSqYhMtgqTxNrgS74D3tKzpatAdmBWwBCvW8Kka+hniSrhPj3I/ZdJ8jysYu0hL2BHau/lyVaL+m+2845VoBOddx/rBOYotznFehLwzuhgIsZEy+JVn5gn27HhzXqbnJNoMs3dmveENrB+Z7IPunBEu45FTtLVfnoa20oQXW1oQgq68UUGg64me9wEoo23SltCS4weg++VWyFwB6dLvPr4DEYIr3XcFdZSmHeaat7z5CrdP0jp2dkXSfcBvNJxTqowQV7kGKfYQMZ0bItY/njCI+ZWSfV5w1IwNDiE0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(39860400002)(366004)(136003)(396003)(558084003)(2616005)(26005)(478600001)(956004)(4326008)(6486002)(186003)(66946007)(103116003)(316002)(5660300002)(966005)(8936002)(86362001)(8676002)(16526019)(6666004)(2906002)(36756003)(7696005)(52116002)(66556008)(66476007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U0Z2aFR6cVlKWGE3Y1IzU1dUL0JjdVBDc0NWYlM4VjBDNGM5MzdLR3hoSmZU?=
 =?utf-8?B?NktKdjE4aEdnbjBQZzRhdjl4UkJRbDV6cU8xbTJJakZaaUlvaW91czZxWW0y?=
 =?utf-8?B?c2tjeGxrdmFyKzNSazNwaG1TcnJScHRrcG5nc1VlZ2grYzR1amhkbCtZbitH?=
 =?utf-8?B?R0pnSzNWY0t5Z1JRckVHNnFnZGNkYlQvSURQa255cjI2OThUUlNXeDRIbjVo?=
 =?utf-8?B?Zm12SVhReEZMVTZYZmJNVnhFNUhBWDFueU1XNzIzdG5rLytzM0pzVDZNdUdL?=
 =?utf-8?B?OThlNDI5akw0dWlLdWExY2NCajF1SGozNzU3OFFqTVlSYmE5VThuVldwQ3JW?=
 =?utf-8?B?M3lGZTdGaDdtTjFtZElrS1FSeEhRZ1ZmWG9wSWNZWlFyNWhkUFk1dUZYNVJz?=
 =?utf-8?B?V0dvT1RldGhkaE5TNFp6SmlBRUpYaWswajVUSDAxdUZoQjBCMnRkdThFbG9j?=
 =?utf-8?B?S1FMVHluSEdHRzg0T1cxb0ZKNC9wM0U5d1J3azJISzBnNzUxWkZpN3VuQnhV?=
 =?utf-8?B?dXZ1eWtuVnFzQlNMcG9WRjA1dGZaNnF5amU2TkxvbXR2MG1hYUxramd1SGR3?=
 =?utf-8?B?S2pOQldPcVpxZVdtVjFKM2Y0a3dLam9jMUhZNk9nZjN6RjF6VGRiK3lwS0Fr?=
 =?utf-8?B?N2RuRGVLQU04NTFqVngzRWZKMFNHZ2VOQ09CRXE4bkJnRE1oaGJRYm81WUlS?=
 =?utf-8?B?ZFJ2MFd1a3JJdXRnVysvbWlrZ3NGd1lFT3RNMzJmeTQxaXl4KzBZalVoaFEv?=
 =?utf-8?B?cjUxUVlyZm1zTmw0RHhsMVZzK3MzakwwTmIxZEY2VHJpMkZxNVRGRUlLcXJB?=
 =?utf-8?B?QzIzMmxraktBN2FIS2NRMmJGR0FtZUFTRGZ3ZldSTG1hejJuWkNVQ1BZcis3?=
 =?utf-8?B?L1U1L0R1cUdxK3BaaFI0QmJ2SDVBNlgzMWVoV3ZGR2RiVVRJUjNZZWRlci8y?=
 =?utf-8?B?djRmVFlJVy9yQ214VDkxdGZGTk5TcnNsZStESG96dVRzT2dTc1NwM0l0M01k?=
 =?utf-8?B?VXQweENhdm9RZ1RXS1plazExVTRXN2Z3QTQ3VEZObXRTK1VSamFIa1c1YU5P?=
 =?utf-8?B?ZjVITGhVNVBwZ3FMTFpQM2F1N0VLMGpJZjNheXdRZTIzajEvLzQ2eWlMMk96?=
 =?utf-8?B?YW1DVGwwaXhMRThyM2QxdGh6RzFSMXBHaktCa1VnSFR1U2w5enlIOWFNVUNv?=
 =?utf-8?B?aVZrVlorMk5DRWcrWlU0MEJsQ1UyTGQvYWN1aUdsWjRTUzdkOGJQQTVxOHc3?=
 =?utf-8?B?eTd2ajFyazU2R1loZGp1MFpPU2ZtUXJzcDZsMk1LY2FNOUtST25ISENjMGZK?=
 =?utf-8?B?OG9FMzVrUmpzbUhWemp3L1dZRVdieGZ2UEZRMExzb1IxVFF2UlN6cWozMUs5?=
 =?utf-8?B?Mm5oTlR3NlhBNEpTbzV1cHdyandTakFGYjhxVTNYbmszdmp6ZFgyZThJTk1G?=
 =?utf-8?B?a002OC9LTlJkaUtBTEdlU09nem11ZGFaYU94V3d2KzVOQ2s1UUt5SWVHaGw3?=
 =?utf-8?B?UXE0N1dJako0ODk0ZERCZmU5ek5yaEFUK1JLVk1RNENTZmxJRGlzU3RNdG11?=
 =?utf-8?B?OFRJMFFyUjRuWnBuVjlkQmJKOEpSaTZzR0MrVlVpTlpsUHlKbytBTTVMSWho?=
 =?utf-8?B?WEJpRnYwM1hVUVFSYTkxTnNGcW94OEk3NU5tZ3ZybDFualJvazVGREJ5N1Bu?=
 =?utf-8?B?N3lCSUtNVzF3ZGllTStjSG5IYU81cE5iOEtSMlBVQi9hQlRFVFlKdG9WMkc3?=
 =?utf-8?Q?/vQt2YpLF6uSKYQk6ZcXOJ73saGjXK9BFMCiMeT?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816206e5-dba7-4425-cdf3-08d8e829b9f9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:18.6415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QHaLA/UusVU8ONX+9iuDoWURu3myGuVjlxrWs0q+sglznauhZv6WyZOLycT/aw5xMR6rEaIvYoFWoV6o64uvAE7wZ0cKV2nn31lWwxaf1xw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4709
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=946 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 spamscore=0 mlxscore=0 bulkscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 adultscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 1 Mar 2021 18:47:36 +0530, Bhaskar Chowdhury wrote:

> s/circuting/circuiting/

Applied to 5.13/scsi-queue, thanks!

[1/1] drivers: scsi: qla4xxx: Fix a spello in the file qla4xxx/ql4_os.c
      https://git.kernel.org/mkp/scsi/c/014ace23a5ec

-- 
Martin K. Petersen	Oracle Linux Engineering
