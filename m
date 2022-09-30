Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AD4C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 00:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiI3AEG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 20:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiI3AEE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 20:04:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC9D1C481C;
        Thu, 29 Sep 2022 17:04:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28TMihJR005146;
        Fri, 30 Sep 2022 00:04:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Yy0/b1Me17kmzXocyRQgnz/ZqsDeZuj5EBczZ7Z9Otk=;
 b=IPPnI/u1A79sFM1Gu6OoW6hlRyF7whc/NUQRihD7KpKRCwoC9+llEzszS5n5Z8ylXBEH
 8KLP8CFpZzSUD8SDtlqQJAeQrjJBgbATyAQ5DKtQZJnPZunr3793NHYNHfQBAirfIlWM
 O/WkoJf50l+jGgkNZ/7Pf97sbe4bUCn8KnoIqS9UfrrwRinfUeJDnx+7HWNzZfP7I98d
 YV9k1mNLNI6JMYnWcYWYbbme87B1yPZKgHA54Pi2tccYkl3eJPmJTxqqqPc6Wjoxe6cL
 BnNMpjzrjF4NPNFlkC9dw3IlKauvbNcKZAV58hwUFeDbCn5m3zUJHCabHt6dj6nC13l7 wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jstet6v57-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 00:04:03 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28TMw6er039481;
        Fri, 30 Sep 2022 00:03:56 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jtprx4tk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Sep 2022 00:03:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTdDQN+wNdugaCvs7EMYUd08TzuAkG0pO9tvMZbZiOXA8zJ4Fpg2/uNW/6sETjiwDdO3Jh2lO01XDgOH37NxgEvXlxIH4KJOZevulHE3ndtn6Jh32v5reP3757o9fdETU5BhmEq8KPRFKgKmzpcPRcLH4KrCKgMkcCE9IwbG6X3gfbYXV7PLD12aAKRmMzWhr7rAyYgPbJJbvyc3qCiCsCUSQAg3i1jrptQRUFFGpyMXLPuQTh68kq2bCWyZpy7sokMXxiopLDIZIfgj0IeFBbJ7wdFtbPDfPMEaaMNwNU05W+evQCvhVRvXAfbN8hdgpV53ckCPRe/W2y76zEyRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yy0/b1Me17kmzXocyRQgnz/ZqsDeZuj5EBczZ7Z9Otk=;
 b=NnCYif2Sf/L1nZVdPUZEQoqHcbLwVueYbaTbmUx1/Aj/0Nn7a4g4awNc8Gekn/sthBqk0RAW3GjQ4hy+6GMa7nDk27aMMHZd9N+8fq7k9gTykrYFW2IIOtgzQOeH6eCQ81vVMMOgy6vz6smerzi7UlIVznZJNZPfyreZ5yA+8+luv4YA0cZvVw3mZqcB+4FXHl1CmwpK+0+w1CR8YYgf97Imr2w9yjggQwGfh01OZcGP8cspZzFSPkNDUbSr43L5ss18wDIeVvJ7W7QCY34VZ8lWtjJspdSoEQ6qpJ6HngSSC8MueLJ+/MY4qcP0Ktaai0lPIsUkdNfS0KgrswQyZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yy0/b1Me17kmzXocyRQgnz/ZqsDeZuj5EBczZ7Z9Otk=;
 b=BuNMb/3nw5GkNUtCObszkYhNWzJfjbSawfGJAOyQhDTVw0yB7QNbOXo4okmsbnwYSBYk7JM/Vop0IXf27SYSCxC3zxxx9GmF017ZROBMmY9lodkxaukLnt4UnLXhPfeNWAY9+8zFuMPNTnMZHyienN+Zu0KswBaYbYn9qIDQBnc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB4918.namprd10.prod.outlook.com (2603:10b6:408:12e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.20; Fri, 30 Sep 2022 00:03:54 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%9]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 00:03:53 +0000
Message-ID: <85c21e59-fda3-8b94-95c0-2483b4c5a05c@oracle.com>
Date:   Thu, 29 Sep 2022 19:03:52 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH 6/7] scsi: target: core: Add RTPI attribute for target
 port
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220906154519.27487-1-d.bogdanov@yadro.com>
 <20220906154519.27487-7-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220906154519.27487-7-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0035.namprd05.prod.outlook.com (2603:10b6:610::48)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 91ef2665-aa4c-4eb9-ca56-08daa2774327
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1OcnEwGkAuarbmw8ygxFbrPbsbi0BHutDpRoxUpdgOHgu7RctZl1EQFgGR2wTkuQd86eeK+MvMIcvEjhpj4PIocQo5U+eCSMOr+52I9LrT+n9bExuVuXkGdyIotRhkFODFv+I+70LnpjHZUca5pk63Ef0tkBccMifM78y0wxA2wdTG1Q3yPHl2GWIE85DK3aVl5ksXa8IHUGDuxV3YshOQIlYOBzseGEPvkl6Utbm0iIJUxXvw8lZcfg3hn5toXr1Cmi5vqPGILoluKvA5q92Fwz50ycP0n6L/TEktMzTNs7hh9N4Jv3eHf9yRmSRBLq1pCuWQkhXKvYsQ0nJYBOfLY5IvbbEtnYlxkBW2POwB9FUeJ1BZq1NmPRuJ9ewJPqnT7qpm/swqKA2HQDoIcge+CHZss9JN8adbRtyP3VcMKLlKFhdEQN967FFi8buJd5gZNCC6gI2aDRUwSTAp2uRfJIp9+/tJ4og9zwqPWKftDI+MwUKRCiDWSkVEyU4KA7pXSpCTwKzhMGYpW+000iJa8mq9Knnn6wh2H+TH8tD1W4Hu0LYvXkmIXuALg6QXLWy4DO6a7KUKeg81t8g2oVQntUQxLitmPHqT985IO1REwH1k740ou08xFW9aEXaPH4/sRC2thkyEcM9ylhmMltSDTWGwHR+7ApbLdzMwygouQAcpwiBQZlMgI1lyRFjfkZquqhXozvqV2bKd3Ym5xy63wPQzJpF1psSovxLP0DgLIcLhMFUx0m/yFPFyKosPhP40Je8y+G1Nuaq5xUsQP9M5ivoybrBmvrgio6u+Ishmo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199015)(31686004)(186003)(2616005)(83380400001)(8676002)(6512007)(478600001)(38100700002)(6506007)(53546011)(41300700001)(31696002)(86362001)(5660300002)(26005)(8936002)(6486002)(2906002)(316002)(36756003)(110136005)(66946007)(66556008)(4326008)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2ZxbmJHVmFKZHlXdEFBYUlGUVdRem84dmtWMGpqUmxKaHJzQ3lXTmdHV2xt?=
 =?utf-8?B?Qm52SkhqVFVENDVOMzkwMjR6VkJqaklUZnhGajMwN1BWcnpKSUR5Vm5vZnN6?=
 =?utf-8?B?UU5MYUNLTzdLcURadkgyVktHb1h3SFNIdVlXVXhlM29YRXRuZ3lTVGgwc2F3?=
 =?utf-8?B?LzhBU2dEV2d5YXBiSVlPaHl1akN5a1o2SXRMMXZ4U0c1VkdQbUY0eFpLRXlR?=
 =?utf-8?B?Rlhybk4vWE5uZmZLVXFScG16a1p2cXpydmk0Y3NHems2MXc1K2hiNnpqQm40?=
 =?utf-8?B?TmQwVlBqdlh0YTI0aEkybWJtaG9XK2R4dlcyMFZsNlU5R1JkQ0M4OGh6Mmcy?=
 =?utf-8?B?RXRKK1BXZ1pLVXF2SjV5QmdrTUpTU04vMjF6cTBpanN3cnc5RXRyM1krVmdL?=
 =?utf-8?B?b0tCYUdaeXhaZWE0L1k3dnAxakh3bDU4WTNPS1paMHpWRnNmMFNBUEo1WkZ1?=
 =?utf-8?B?VHQ0RTRwUjJQbVpLZFRUTWVkanh1TFYyUGZSMlNNaS9XVkZ6cC9JVlVsbXYx?=
 =?utf-8?B?UTRFUmlnOXFqUU02YmhUSGxacFluVkpqTkg5RHNjVzc4SmhLelFLMTJucXVt?=
 =?utf-8?B?bEVnVGt5KzcreFRLNWdkN1lVcjlRQThOQjdrZllhcVR2THZoeGxxOXFqY2dG?=
 =?utf-8?B?YVUreTJiZjBJRGNBdGJ1MjNqeVU2emh0MSt1amh4U05pSWx2WmxkQVZoV1lz?=
 =?utf-8?B?aDE2UUdIWmhLMFFNdVN2MHQzMHhid21kYTA3dHZsMXQycFdETy9CakFVQkZQ?=
 =?utf-8?B?dHNDVkUrZ1dUSnNGbXlsSFlOcHFGa09XdG5PWEU1VHIvYTNZOTBhb0dmeHBp?=
 =?utf-8?B?T1ZzQkowM3lRQjg0WVFELzh6RW95RGlxWDRTS1RucVE1MXJMVzMyMG5ibWpl?=
 =?utf-8?B?VkFNRjhtSmJ3THBuQ3BsSk1GSldsRTU4eXFyV0dFR3RKU3hNdUJGZWFSby81?=
 =?utf-8?B?V2RMRGxiV20ySlYvaUc1SWpOSDBhMlB1Q2FIRXZKcmZWSEpsU0dzWFNZL0ZT?=
 =?utf-8?B?WWVGeHFhVDZFSU5MVUplTDVxNHJ3R0VyY3NtdXFYbXdlY28rdU56d2swSE1W?=
 =?utf-8?B?MFVmRFljRVFkMjdadkxGTFBjRHNDbGNaUFMxVG0veGhXMDl1dGZyd0JOVFlD?=
 =?utf-8?B?VjMyVWhLRXBTa3pQekVGSld0OGpzQ0lseC9EdTB4Z2tTdzQ3eksxWHBQeWVL?=
 =?utf-8?B?Tmg1dFprc2x1S0FFSEhYaTVhMlBmRmdMd3ZRQUxHM3NFcVAvMThGTlNZT1NI?=
 =?utf-8?B?OXUzQUNiWU9qcDFKWDBXT2NudXA0cFU2NlRjcWJjdzJESFhmZGdQd0VlZEpq?=
 =?utf-8?B?dUFUVmxLell5VXBRNENDZ3JaeDlBUnluSUluSXZ5YWRuZkFKUURjRGQ5K2Fn?=
 =?utf-8?B?MWhMUjNlR1VnUVp3SmJKdXM4MHV6ODlXNi9vcE1hQjlHZlFacnpnQUZveWJS?=
 =?utf-8?B?b2g4dkxCaVQ4c1ViU1E4b1JuYjNXLzBobkhQeTNQaVBKWitCd3FKR1FBeXE1?=
 =?utf-8?B?YnVOS3VVbWdXd2pnMjFLRDBkTDJ6MC85UDlWaWpGcjk1UzVTQTcwWDEyUURl?=
 =?utf-8?B?eWFjOWlsVk1VeUJXSk9rZnpPQnlWY3JXM3NvL0VkcEhGdE9vcmxBVUdQTzlv?=
 =?utf-8?B?MzB5aGc0TXpTY09NSWp4Zkp0L1FWWWY5d3dza0RGRGd2ZWZQTXZEcmtCNXJZ?=
 =?utf-8?B?TVRkbW5DOWJNc3VKSGU1M2d5ZHB2MW41MnNaZkV5dzBMMnlkZEZaUEVHSEhU?=
 =?utf-8?B?aXozUmdvdEFmeHBaVG53ZEZJbXlXVVo3YXBNR3E0VFQzN3JVQjNxK3JHdGUx?=
 =?utf-8?B?WCtVZGFsd1djZ0p6cUJnVUpVOFRTYWVNZlBQRHlvZnA0Y3p4S2tzLzZZeU1l?=
 =?utf-8?B?ZTRzRVJSN1hSWG15dmZVdld4bTB6S2QrcnFEUkExT0lEbTA2UW82eXdwZkpT?=
 =?utf-8?B?WFBQVGh0ajlxNzQ3ME1aUi9kZmxrNnk3VXMzLzVaek5RRVVBSzdWc3RNelNK?=
 =?utf-8?B?dWVFaSswL29PWmw1Zm5XYUdtbklrV2RmQWk1dUFPdlh0UEZDcTdabTBwVGph?=
 =?utf-8?B?MG5BWVRzNFhhUkk5d2ZkZGxxUkpqUWo5elJ6ZG8wWXd0b1ZoWUZlTUoybHlk?=
 =?utf-8?B?cDRXQzR6cW85Y3Y3ZkRKTHJLZHl4Qm1MdGhMT0VuWXV6QTQra0hVWWswTTdF?=
 =?utf-8?B?K1E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91ef2665-aa4c-4eb9-ca56-08daa2774327
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 00:03:53.9085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AHvimSmUC7zBtbrJuYOOCETYyysIMkl9RASmVMvToe/d+/Abh85UChsMV7wGDq/RH4smwxdZASkEh3q5zix/b4yRxyhKwFtIkgRTKxoSRKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4918
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-29_13,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209290150
X-Proofpoint-GUID: bTS7PPy9AmRNGYYCk0cc5IfcyS0Lbpz5
X-Proofpoint-ORIG-GUID: bTS7PPy9AmRNGYYCk0cc5IfcyS0Lbpz5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/22 10:45 AM, Dmitry Bogdanov wrote:
> +
> +static ssize_t core_tpg_rtpi_store(struct config_item *item,
> +				   const char *page, size_t count)
> +{
> +	struct se_portal_group *se_tpg = attrib_to_tpg(item);
> +	struct se_portal_group *tpg;
> +	bool rtpi_changed = false;
> +	u16 val;
> +	int ret;
> +
> +	ret = kstrtou16(page, 0, &val);
> +	if (ret < 0)
> +		return ret;
> +	if (val == 0)
> +		return -EINVAL;
> +
> +	/* RTPI shouldn't conflict with values of existing ports */
> +	spin_lock(&g_tpg_lock);
> +
> +	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
> +		if (se_tpg != tpg && val == tpg->tpg_rtpi) {
> +			spin_unlock(&g_tpg_lock);
> +			pr_err("TARGET_CORE[%s]->TPG[%u] - RTPI %#x conflicts with TARGET_CORE[%s]->TPG[%u]\n",
> +			       se_tpg->se_tpg_tfo->fabric_name,
> +			       se_tpg->se_tpg_tfo->tpg_get_tag(tpg),
> +			       val,
> +			       tpg->se_tpg_tfo->fabric_name,
> +			       tpg->se_tpg_tfo->tpg_get_tag(tpg));
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (se_tpg->tpg_rtpi != val) {
> +		se_tpg->tpg_rtpi = val;
> +		rtpi_changed = true;
> +	}
> +	spin_unlock(&g_tpg_lock);
> +
> +	if (rtpi_changed)
> +		core_tpg_ua(se_tpg, 0x3f, ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
> +	ret = count;
> +
> +	return ret;

Just return count.

