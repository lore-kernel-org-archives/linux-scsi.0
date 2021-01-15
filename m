Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFFE4C4332B
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B18B23A3C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbhAOEJx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:53 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43818 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbhAOEJw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:52 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43Oae144044;
        Fri, 15 Jan 2021 04:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ILXUFUmcAV46dGB8WsuH3FukFoaV1n/3Eru6gCrJDYM=;
 b=DzO5r2QlAszkWzLCFJV1jEAfS6nCYVbRQ1I2DXD+GAVsCypvi7YA/k1wI6rdkFR/C95h
 ZRzgWg/v1GibsBTDozgwE6n2IBEZ+yLy6ju/UeaIxWM2RXrTjTs/dNHwWOCQ5atNOf7f
 g+HFaQjJoh+d7WOZ2pcHX2ecYvY0cQaXMIYiBnPkoibsoCi7hOWzyyDUJLDE/jDQxZzR
 7HzUgGAx3sbn6iNMBcQ6ZpP0hz5jN1APDE9q0tYPcFiRhkp5bi/JuSXZhTw9b1yJx3mW
 Ss4wZX7ARTiPsJyl9HuybHhzC3MfqiF2gmht1wpynY4tkkK/eYiaPzi37Tr4vOya4c0N LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 360kvkb6n8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F46e8l094894;
        Fri, 15 Jan 2021 04:08:58 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by userp3020.oracle.com with ESMTP id 360kfagpa5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9vFpesBbq0NmCVnDsnQXjIz4M66+0OUQu5PdeuztUIpU/iwwjrgAWVKQ2EAtKn/I4VJc6ZHqHW3B3nDAvtNKk9dc1pe7naJmmdLq+K6jnBBTdLjSZ1IdS54J2bny80Sag+kPoXeKMmTelq7yyw+eMgP9cl1j+4+XfP2psL4dY/afTlC5+eWzRQXyf/YYPDOVWOgqgjQP33kUkty3fTVBdH5l8WkzLuRLcc/aM0bYUZg6E80oyX0yvVZe49Ae969OZYrDqxnyAn15B/IZL2fGyLC7/QRDKWA+yraC+s0vKL/6k5laiEdHBbUIpx/72hsiBfzVkabtPM//2BVtUA4tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILXUFUmcAV46dGB8WsuH3FukFoaV1n/3Eru6gCrJDYM=;
 b=GdU3l2A1umICCfGqY0AJBicVbliny2v9JtgqjHWeXhWgg5fStXVxz4NLCPPbyYK6SVzx9MUQWFyluddZpqiPpkd1Cat2xUfSOh9dqAfBrjchI/EGzL0lYoGEOYiPLKjW7CrSv5XvDixi+CS5bExKChR+X4t+7BUHJ7iwUdP8TSEJIAD5L6ckowNP1Dwe/FxgbmCoMZdFjD6lYwRa/RQ6N3hmw2JLIHhbkiT1EIz3Od+dbt/w1LmQaDcvdPUyNaU1XQwv5t/dJ8jsS9hFHJN/6uGnVXlxrX3r8MOTgCOYyBydRfSSPMe3JlspY8bv0Gboz+6sApzQP3/hfYkURuNChQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILXUFUmcAV46dGB8WsuH3FukFoaV1n/3Eru6gCrJDYM=;
 b=py8ArJpKs2BnI92STlokOULwywu5fVlZqEmYXoLJsTBYRKnG5PNKh4yvSZ8qubburz1APNVRSb7X12IVrG3jvjz/FkIYwB/VFcxbp0oxzp4rH5sizXEQivDBmV2LEy2ui1cbmInBwVdL9P36gUWuLx3QUs1/SptvKM+tEUEjaN0=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.vnet.ibm.com, hongwus@codeaurora.org,
        rnayak@codeaurora.org, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, Ziqi Chen <ziqichen@codeaurora.org>,
        vinholikatti@gmail.com, linux-scsi@vger.kernel.org,
        kwmad.kim@samsung.com, cang@codeaurora.org, salyzyn@google.com,
        kernel-team@android.com, saravanak@google.com,
        nguyenb@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 0/2] Two changes to fix ufs power down/on specs violation
Date:   Thu, 14 Jan 2021 23:08:30 -0500
Message-Id: <161068333183.18181.11643822705956870958.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1610103385-45755-1-git-send-email-ziqichen@codeaurora.org>
References: <1610103385-45755-1-git-send-email-ziqichen@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cbf16199-9232-4721-4f50-08d8b90b4690
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB456811FBDDDFD6B03E6690028EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNn8BUKwvIdAnK9kUFSqJf3Uw6jZP4VgnKGA8xl+DfarrP2N8U8Ba52n6kPZfs2hJ/D6Sy82WPvYcodxdBi2Ki1aPkO/inHL7ys+cFVR3V1Qp6CcKw5CB31EXOr1KfwPY0nRNJrAg7IYNoeKsPoDlkGeeim0hl0CT2NkRvf2G1YCi+nzZAJAvkVJ5keLrnUxHIpXXoe3U5lbAxuHPXO+dYMIZL/G96WspZtfL7U1OMdncrWcQhhyraaRqlA+aVZ8P8oF8ciPU8icdDTOJGyjekE9xzXp3k+JWHxBX03DFSFY0yUlOcnk+qeeOB3wXWKHHwBafKWtE6veOz6qpWAe4K5rf/izcCBCDlCzoeRw6NRyikEQqUzQEtFJrIVc4zSkryWsqndZcAmO8lZhSxos7FGHcT7BMQM/ILjWVwdm8QRwFiUofWbetzVAhXQm5vF7kagIimt4TC8iMA36Vzkr5YIkN1NRmEtCFA7Q6qHjdQ7lBf3SyS5S8+mZ3uSleoVZnGq6pX81lrwNJ07nuchvvA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(7416002)(4326008)(921005)(107886003)(6486002)(8936002)(2906002)(86362001)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aWl3b3lwOXpkaVI0eVlrOHlaakhJRHNlUkVYK0VKUjJ2dVhLdmY1Z3EzVzdz?=
 =?utf-8?B?bnA5WDI4eU50T1IxNVgrdk9SUTlTQjZsTGxIKzZYcm55cjZmUkpZVTlNQnda?=
 =?utf-8?B?MHhNaWZxVHJFbkQwSDBpR2tBSWlHUGNXalJadm1qbnNhN0NLei9jQVZQSHBP?=
 =?utf-8?B?RFVwMzJGYjFlamE3ZS95ZDc3aS85czk0V0cwcm1VNlJEN1FaT3NBOVV4VXJU?=
 =?utf-8?B?UElDT3h3WnlSaEJFczJNMFpxR3FrNlRlOFFLVHZEZEJyOERmYkMvME8xd1k5?=
 =?utf-8?B?U3JIYTdhU0tQU2xoR2htMzNSTkVkTFlidmtxVFhOeTk3U3dxUTBkTFlkelNh?=
 =?utf-8?B?Y1RpRFJ0alIvZ080a1VuM2tKeTYvVm5icFdJYUQ0R2ZzNm1iOGxHZTNMSkRv?=
 =?utf-8?B?WUw5QnZ2ZTUzSGlOdUpIKytwVDZlRW11REZXWGFoYmNmczJGZGtESWtWTjh0?=
 =?utf-8?B?NWI4aU1JNU5GcldQaFQyc3BuMkJmUVFNMHRpZzlDaFB0TVl4OW43VW5EVC93?=
 =?utf-8?B?MDZCd1BBblhlc1B1WVVDemRQZ0NvQTg2ekwzYXVVd3ZOVXNqeU1tSmlBcmVz?=
 =?utf-8?B?RG9LMFJuNG5kNjY0a0VBY1pHbVlRWEdna2ZsTTBac2oyUXZESEoxZE1JSy9L?=
 =?utf-8?B?SmRneXNlY1FUS2Vldzl5Wm96a0xSYlU5U09VRGluSGNJazdRUENvVVEraktM?=
 =?utf-8?B?bkd1Tno1cWRWSXdQTHRjUUQ4aUMvZWFhSzEreWxlY0tLeUZGcVJQcnFzMlpv?=
 =?utf-8?B?RytJR2FCQ2kwOGM5Sm9XMU1iWk95YmkzRCtETkhtSk0rNVNIbkR3c01NWnlL?=
 =?utf-8?B?cnVjRmt2dlhBdnpQeWpvcGtLSVBBNnc4Y2VRNHJoUzJYcVB0dStOR0dKUWR4?=
 =?utf-8?B?ZkE4OWQ4VHJDRHVEZHhQZzdFa1hMeXo4M1owS29FcTBUZm9tNDdIZkpoSkJC?=
 =?utf-8?B?L3VvVENnQVhMK292TEpnSDk0MVNrNHpJZlBlNlMzbk05aTBSVkpZRit5TUl6?=
 =?utf-8?B?aUd4cklWcjF0RDBNcFNyUFZNQzJPVGhvditDVXRpOVlpVFdSQzAvZ1pwYktM?=
 =?utf-8?B?YldhNTcveWR2eDcwbWFsc2o3eTh0b0hrc0hmRCswdm1jZGdoODFrdThKdmNm?=
 =?utf-8?B?WExOREs0bUxHZmxnZ2NjZ2o3bVFrKy9pUFZPK3RackMrZGpGOGFZWUlzWFZF?=
 =?utf-8?B?R1N2RjJ2VTM2K2hTRUNTOWtzMkcvOEtORHpqQU9iZ1hBOUdWTFFUcVZkUHZk?=
 =?utf-8?B?b0R1MXlLR1ZPSGpuejFYUHhTYXlaOElWVlpYQ3A2Q1c0ajFieUw4YU9zcUd3?=
 =?utf-8?Q?VggL3aa0G9+p4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbf16199-9232-4721-4f50-08d8b90b4690
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:55.5543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /9MZ99UTTLM4jN/YhJbok9UHpo2tWdJ1MDI7ffcDEU5ws/6rXnXisvDA+gTFTrp+GfJ2IqOMtvepg54K5BjwkVFMrcl9GW6PyVofGOboewI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 Jan 2021 18:56:23 +0800, Ziqi Chen wrote:

> This series is made based on 5.11-scsi-staging branch.
> 
> As per specs, e.g, JESD220E chapter 7.2, while powering off/on the ufs device, RST_N signal and REF_CLK signal should be between VSS(Ground) and VCCQ/VCCQ2.
> The sequence after fixing as below:
> 
> Power down:
> 1. Assert RST_N low
> 2. Turn-off REF_CLK
> 3. Turn-off VCC
> 4. Turn-off VCCQ/VCCQ2.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/2] scsi: ufs: Fix ufs clk specs violation
      https://git.kernel.org/mkp/scsi/c/528db9e563d1
[2/2] scsi: ufs-qcom: Fix ufs RST_n specs violation
      https://git.kernel.org/mkp/scsi/c/b61d04141368

-- 
Martin K. Petersen	Oracle Linux Engineering
