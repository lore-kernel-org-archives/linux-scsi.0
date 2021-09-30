Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B324C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:25:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6591961A0C
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 18:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351743AbhI3S1P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 14:27:15 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16376 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1351771AbhI3S1O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 14:27:14 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18UIL01R009796;
        Thu, 30 Sep 2021 18:25:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/QSwCYe7zQAlnDW+BS5x49786xaqeZLFUnCjuMUkvrc=;
 b=fDoB5uRQSXu/AE8GqaEYJZaPdsHHuzjB+sg5EZtA1a9QOeZq0THXvQ0ALJMvDxXHeG+B
 OyxDom7t+UE/LkmdKjo7rHCD2tr5BsDDLRad2mPrpnRpO2rAIN2loJi4DUvf7z7WZgun
 HXV1Gb2fFQdorYrK8Dx20pCoS7qjtOLaOwCKt1hmXE8Ny3wUtSwetd2tP/0SI946BTvj
 xg+tVhvxBRwbKX/GSUWWiIr84jXZNEVvxZ81TN+DuF79rJECcvWscm82f0hJfZB7YxCv
 DBbX3YkuwLobFtGNqcxistN4DDiI0E5nFv8Ok9f48HpA5AHGhmMFujg11Y/28iAfK0T+ UQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bddu8tg1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:25:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18UIFpJe052335;
        Thu, 30 Sep 2021 18:25:17 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3020.oracle.com with ESMTP id 3bceu7gfnx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Sep 2021 18:25:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ygxt3i+nNg4aL2VBnvz9iAzwgW5WPv2ch5ZhoHPpkIKnJrelfMJ2G812+qw+RLubqBFqMDeU/LCgI76tuNZ09DHYGt0kOUGE6AaR3FjO/qS7RarXgGMY0o1EFt1qjLb2BTxDgCVk/DXwA4XY5CnS22x/GUNSQB1y+HGmCLBc9M3MQx1z9pc/ycC2PSNBmA9nLJVj3SBhnYl0s5XdtJjwNBfgoB2njnDQIDrVABK8cw5Lsh8jVfjWklofuuBwerrqbJ1Zo2b9ZEpuGPpzFo8Nt5jaEyVcFLRa+0ZtleI6pYxpWXOz0KO0q5KLkd8RdUps8+cklIDoJ1ZRmeq73o1L2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/QSwCYe7zQAlnDW+BS5x49786xaqeZLFUnCjuMUkvrc=;
 b=UOl3mFs/GNZxkfskXDXZoA9D12/siiVr7lNFdjahbhz3QoDC8F3k1l7zujQObte0HIF70i4wNtOswb79R/mJNYY1cLNZyN48IoIZo48sGP6f1T82gqNXKyhwFVFenk2mXyoJibIILmgDECCrON+rTqJr8pYujQkFBRgK2pawewsVEBqTZ3OoGO6Sxh1447ZkNAd0JFhNVKIVnqV/qOXlLK7ztjNUbCsxvKr9xX7DoMdr0Zh9eW5V9VVaYuVna7Tqt1m+TL2fgJejdXVmmXIednC2Uyy7Ik3gtD2aY3XSx4ZrRURBOnxKqa/40+UXpENJXAKTKW6zKhsZEbwtVLGi/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QSwCYe7zQAlnDW+BS5x49786xaqeZLFUnCjuMUkvrc=;
 b=HL3F+7YKCe9Zmx417UAba22QB5+QOviWioO1niM4m5zqtSsD8WEVdJQFtReryWv/QHtqkHBBuwTPtlIdk6qcQiVcdBLm9cy8jBXwtG6mfqfYET3sfuWun+M6muoGdSENKg37hUWyLCraVXGKU89B6O5Vgs8pf/kZlFYCnenuDqQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by MWHPR10MB2032.namprd10.prod.outlook.com (2603:10b6:300:10b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Thu, 30 Sep
 2021 18:25:14 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f502:c6da:c9bb:222c%3]) with mapi id 15.20.4566.017; Thu, 30 Sep 2021
 18:25:14 +0000
Subject: Re: [smartpqi updates PATCH V2 11/11] smartpqi: update version to
 2.1.12-055
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <20210928235442.201875-12-don.brace@microchip.com>
From:   john.p.donnelly@oracle.com
Message-ID: <bf8d37bf-4f04-be49-5ed6-219174cf0b58@oracle.com>
Date:   Thu, 30 Sep 2021 13:25:08 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <20210928235442.201875-12-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR13CA0022.namprd13.prod.outlook.com
 (2603:10b6:806:130::27) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
Received: from jpd-mac.local (138.3.201.39) by SA0PR13CA0022.namprd13.prod.outlook.com (2603:10b6:806:130::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Thu, 30 Sep 2021 18:25:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8713fb40-7d63-49ce-b2ae-08d9843fa580
X-MS-TrafficTypeDiagnostic: MWHPR10MB2032:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB20322E2769020AC2F8C04CA7C7AA9@MWHPR10MB2032.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:361;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1dYnn2VcF9ck63lJUGU8MoMWXjxN6UtMAi/EE4tk0Hb/Mya9Waup1FIYwXW+oKuu+J/bqbq9PGECFWJSAbY5I8jY7MCjZFntK52oMYYx81efwrdBkW2LpGkDBFbE8OdtmEFWOJl2IT8WLXu3loSuuFfJxPNpn6/wkdWjPYbYMZCxSan1QB/Bd/tDUIOPqEpsoBDkIm9B8l9sprcQEsaF6akgq001KnlWN5lxU+1y7gGueoMk+ii/lz/x6tNZSh7BxSP6l9zKTnf7jRXC11CfvefQezQj2wOEfBprMNf1xd2MHBJ+2YUbEt6Xk32ZnciD0/DzasqXRvjXP2g+AvnU2vaklbJjHzEIIqL/+dnSM5btsTCd/gfYL9Lf/VcmnRUAm8uQaJD3Cv1/MQM9ZzwB6BRtlubh6lIU249RZsnhEXGHuahP76D0h00jaxxaDJkFNVamRhGFYagZzk0dY/rcBTZZ5KtASJ8v1GOzBLrvVHMpS37DdMRjfqlN3wb1DgOvegMG8eQZUp/qk4W90IV/0IIJELHTTKhexbkre9Tg+HUV2voAtuxf0iiLUnY8SDq9ckAvAyFb7C/QRlcvXXzYj0tC7WpFUIjB0e+/c5x0YB8Fg5gmngJw91kwfnNUl+CVUVtVi13VNYTpo1pH5LAeKjShZvRQ1dwAfy7mgDgth9v+4Rl5OxSKgwArw4adD/yVV5gw93cUtya3jb1uL7skkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(8936002)(66476007)(83380400001)(508600001)(66556008)(6506007)(26005)(53546011)(2906002)(8676002)(9686003)(86362001)(6512007)(5660300002)(15650500001)(31686004)(316002)(36756003)(31696002)(38100700002)(7416002)(2616005)(956004)(4326008)(6486002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1lvdS9HNmxTclJOOWpuUE0zbmpBMG5KODkwRDQwc0owRTJIa0orekh6SFV1?=
 =?utf-8?B?TGY0WmlseWN2YTFiVVhnSndCZ1lsQlJhVitkb2hZdjFSa3ZlNDFjNndoWjVF?=
 =?utf-8?B?eXE1d1hrN3pJM0dBbmRJa3JxTUtWUTJpVFJEaXA3SVBiaU5Udy9wemdScTRm?=
 =?utf-8?B?MXhsaGxUUEFQUUVySFMvUm14S2wvVlRMeDZuTFlhaGJkWlBGSjJvaHhrQ3Bp?=
 =?utf-8?B?VCt2NjhWNlVDRmpvV3ZEWFpUUFpKMG8rUi9waWQ1ZU5pSktrTHYwRFdPcmFS?=
 =?utf-8?B?STFEdnBJYkZ3SXFwcU1FOEd2TFQ5QUZqUlk0NjAvS3VOMzRaM2MyQmN0WXdu?=
 =?utf-8?B?bVZHenlCL3lMQUFIR244Sklza0QxbExxU2RpdWppK2ZiUjJjSFRUNU5qc2pu?=
 =?utf-8?B?QzBXVERaa21hd01ON0pralhxVkxQZDh5bGs0Ui9DN1c0Z0FFcktzNmFmL1FU?=
 =?utf-8?B?SXB5NGYrbktvVE13ZTRtYVE5c0lMYWUvcEhTYjdybmNDdUYrNTVlYWJaWml5?=
 =?utf-8?B?dUV1NVowT3EwbU93SWhycWN4dDYrSTFOdWpGNm5uTStZcjJrYm54ZklDS1Nv?=
 =?utf-8?B?VkpCSTZFMlJ1cEl4RjlqcjhBcUtXNC9nbHhmeHo5UTNvb1FLRWU5VVFIem1k?=
 =?utf-8?B?K3ZZMnhTOVJVMHJ3ZmE1NnVLbU5NczRKTGFHKzU5WE1RcUpseXdCMEpHQTY0?=
 =?utf-8?B?OVl2WG9JK0dvNEJ6Y2ZPVW11OFByMElqb2plckdIcXJ1UUQvQkY2a0VrMmRa?=
 =?utf-8?B?WCtBVndrcmtQSit2dTJwWXFEdEtZWkhPNzJYYk9na1R1VUNCSmt1YWJBalps?=
 =?utf-8?B?TWM1SXpPWXdmVGVyYS9WeFE1YmwydENmV3dzWVVNbmYyZzFGM1hDSEl6R0Jo?=
 =?utf-8?B?OHNJZStpcC8rcmVpbDRKNDRaUXp2Y1ZxOUYxa3NxQ2JZVzZMSnArVGpVdE82?=
 =?utf-8?B?Tzl2MU51SjB0dUh0d1BnOXBnTUF2bmpmeHBuNjRWV1Q0anhsdkU3MVByVlo2?=
 =?utf-8?B?bDE4Mjg3c3l0ZitFOTFKallheDZkcXIxUExxZG5qWEpQd2RKRHJOWWxvemhX?=
 =?utf-8?B?bzlqOXRRVUVud20zT2hDdklScnQrSDJEdS9yNVpLTUQ3OTE3N2o0M0ZNSHpk?=
 =?utf-8?B?bE90YnRTVTlBc0trZXlsY1Q1TTRvOHlLRzJnWkZQaTFtN1NqaSs0dDVLOUM2?=
 =?utf-8?B?cHdpRGk2QnpYNFp3U25rYXlVWlZJUnNrNDFobGNkOThwbi8wSEdMbmk0V1JH?=
 =?utf-8?B?NmRXQ2RQTS94TkYzazlIcURkMHlPWTI1dCtyVWpKeDJTUUR2U2IvYWY3ZVZ0?=
 =?utf-8?B?T0Y4emRNdWFieGx2c3BQMUhVdlNzRTE1bmlxajVwZFlxMWZPV3dPSDRVVUJn?=
 =?utf-8?B?OEN2WCtUUUp6UjZsZ1FVZFErVnBhNmt2Y1lTdTd6UEMxUVFDTzVkUzREM1d3?=
 =?utf-8?B?bEE5VVR1Nkh5eVdLaWRqR0hQaXF5MGNpdHRNTjJYUmR4REQ1OENLV284bVlU?=
 =?utf-8?B?eVI4QWduNlp6bEhaZG9yVWNjRnNNRmxsbHJONDFCcTlCRGpPaDIwM0hUNDhx?=
 =?utf-8?B?QkVJam1mWmdyZ3MwS1JHYVBiZS9aOXg4cXhoclRNeHlmR2FxZGxtOVd0QUVJ?=
 =?utf-8?B?cUFoc2srNUZ1ajRPVVJJV3hLeGE2eVVOQ01WUUNIVFUxZncwaGpPcmFrbUNG?=
 =?utf-8?B?OWk4MisxYUdTR0ozN0dtNkE0aDg4dlpwaEF3aVM1UDJ5L0JWeXNQdVpxMVpE?=
 =?utf-8?Q?3xzv+A5LbK92qXB49v5pvOl/DRG5kaQqNBsUTMk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8713fb40-7d63-49ce-b2ae-08d9843fa580
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 18:25:14.5431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dsoa1DJNazRE3SNosTcxI6xfkbnstzuiuP228M9HLp2j1jGUOii/BONLlEDUrlcU26xoqF3toDnFn/8Q5PUw3QetCPVR9dlbDaWYsgLPI1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB2032
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10123 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2109300112
X-Proofpoint-GUID: 8UK9FEJAf4IaISzUql8u2ypzwMxKMAIU
X-Proofpoint-ORIG-GUID: 8UK9FEJAf4IaISzUql8u2ypzwMxKMAIU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/21 6:54 PM, Don Brace wrote:
> Update driver version to reflect changes.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---

Acked-by: John Donnelly <john.p.donnelly@oracle.com>


>   drivers/scsi/smartpqi/smartpqi_init.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index ffa217874352..b966ce3b4385 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -33,11 +33,11 @@
>   #define BUILD_TIMESTAMP
>   #endif
>   
> -#define DRIVER_VERSION		"2.1.10-020"
> +#define DRIVER_VERSION		"2.1.12-055"
>   #define DRIVER_MAJOR		2
>   #define DRIVER_MINOR		1
> -#define DRIVER_RELEASE		10
> -#define DRIVER_REVISION		20
> +#define DRIVER_RELEASE		12
> +#define DRIVER_REVISION		55
>   
>   #define DRIVER_NAME		"Microchip SmartPQI Driver (v" \
>   				DRIVER_VERSION BUILD_TIMESTAMP ")"
> 

