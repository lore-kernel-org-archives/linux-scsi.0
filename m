Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4E09C07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:17:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D4F361289
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:17:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbhGNBUG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:20:06 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:22734 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237198AbhGNBUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:20:03 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E1GPjP008491;
        Wed, 14 Jul 2021 01:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9r6Q4Pz/9SxU9x4OawY2lTSvq3bu1liMWJhDcQ0ksYE=;
 b=oCB+TDBdvFZcKspZSrbKP/OAsNB610JCwtYy0NjMDoFL+Ovz77kK9mTHuKtbvFgRqhZa
 VHhUWtqim/0dEybwcrnxn+c1A6OR5U+Xx/jqRfuTbp050LeUaoIsMdnuZrfXpda52Aug
 y0+woMROxB1GtUkjvzUtDejdkkvUcpYfMSrUvNdIUVnt4etOxlnhxeZtU7GDHV/V4dzA
 9B1AjIOk3N6XR8okZDxwLJw/UUKJoRaZwVX33uBMBiohwHu/1gAvOR+VHL/GFa4CpETK
 E11KEWv187PqMpqFgRwZZGNNTz/hC2eOxP0gx2I2WdmVNh6+wGx9GBoxvSKyvbf4A9G8 OA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rqm0up1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:16:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1FCJT092492;
        Wed, 14 Jul 2021 01:16:58 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by userp3020.oracle.com with ESMTP id 39qnb1d243-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:16:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rn2k4RmR3LTf987sJ1siPUzx8tQuOOZMurV5kzh7GCAFzaTxIyBJpyCuGuWzyBTBXisZ4DO/wTWq1etXr6IQQFfPz9rIziYpq2AQJoiJLr+a2CZHHOYQzuLt7B/FazNWCRBhexDva9A7vezJLauZZ4j/N4E9q23gdkCEPt1b/45cxTiquzE6UML8vAs/6nq/k/BRwKjR5Xsp99zf4nx6ANTOewSeUt0PZJ8cZ2E5PkSJ4+Tpkp8tjoJoY8vA/De5Wa4aOgEwDg0k0ynJ1UIbfqyilO5waHy2zj0QrFrGG6HBPed5p8E+CuCUTLtN53cyMfrZ3BkL5JQYwo7vIiPcqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r6Q4Pz/9SxU9x4OawY2lTSvq3bu1liMWJhDcQ0ksYE=;
 b=bF3VHzkqDopmdl9qsv6KOgUCZ2YMTiQ5bDKUp8IVnvO8G92xFYlQFU4LTnJREdWAVBk0xVKmuQxHiaRHM83Ki3ZWrK3HFBj3XgwN6mE8fOrLWOopeeiWY0RYivzou3JYMd6yaWzzzKYVENmmq12GuzESqWtlC+Xzlh+XfZUUW46p902LtZzBvo6rfKj5Pgtpe+jr7cWcceSU1gDmPvsPU9He90OBREJfdzIbI0FMpBm4qhfNGWoCTB0xe1Li/x0V5gFbbjd02iU+KVd4Ek5OJiEXtaFD+d7aQ2JHwh/rcX6DwT4HcTS2sOudCJ/+gEOvXwg5WOc1zhnpYOhX9GS/0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r6Q4Pz/9SxU9x4OawY2lTSvq3bu1liMWJhDcQ0ksYE=;
 b=T3agoRCeg7X9+XusrIDNtgglT/Wdsyi4rZYAFEnNLVn0hmznHj/6y9x8DA7NsJnhoLC+ashxNa0/eCAyYfNKXMsG4ZynMEW2FNvg/USgWxGeMD5Njm4iFH4SEcZMJD7keQKGA7CduYukA20i5GVDWeTWoGYfxCs8onQJhVdXHmk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 01:16:54 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:16:54 +0000
Subject: Re: [smartpqi updates V2 PATCH 8/9] smartpqi: fix isr accessing
 uninitialized data
To:     Don Brace <don.brace@microchip.com>, hch@infradead.org,
        martin.peterson@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, mwilck@suse.com,
        pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org
References: <20210713210243.40594-1-don.brace@microchip.com>
 <20210713210243.40594-9-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <b6f1f0ee-1b92-ebb6-642b-769531b7e578@oracle.com>
Date:   Tue, 13 Jul 2021 20:16:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-9-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR16CA0035.namprd16.prod.outlook.com
 (2603:10b6:208:134::48) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by MN2PR16CA0035.namprd16.prod.outlook.com (2603:10b6:208:134::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 14 Jul 2021 01:16:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3e78cdc4-a645-400a-ade6-08d946651122
X-MS-TrafficTypeDiagnostic: CO1PR10MB4451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB445114B2D64801425F10BEA5C7139@CO1PR10MB4451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wW/huMwMr11eSR9xhOvFRzjRuJTB7fhhUaZfn+7fTvyqLioLZRsU033w9JOtdc7nnCWpnNFdF1PB6NMkQRk4vVO4UN6KTHl55QUHwYw3T2WBtvEeo17CPUBsiJyYrIhz3MHA5bOUSO5zaNfGyzjY33qn1XpYtWAoGf8Suyww/fnwKKyNA0o9o3qtebHEWvvY5QA3qFNcoORgmnV9Jmq7v9Q1/0a8l9SUeMQJr6jH+Sokwij6H9tiVI8wnyulwg8241svcj6U4RnVi8QQX0AuOz0+xrQ8lBiXqOIH51UEUvNoIwI1hBMZ9IBttBPO8yaJiL9so3SXJ+GggYG1e2+NbsjnV3dJgv5VPeXpi7Qkxj5zUf5X9lvPDMimHmn2irABhNETbmGHkuXDANRyFr3qWko2h8Hq0AtRbh/hA9lZlXQCsLLwNIy0XOJosN7pjizB1StXl9vW8RINSb7Lc/hJ0bmCFSP/AqLT0rtIDiCvfa5GsmqlLmp83HzrzGQVJU11ipyu0labTPaFi13eqwnddFWalrPFI+IlMxifxjr5KK8/907mZOZBdVthHnvA7+XCvBkidQlSPN5USA9pnaoowD/2G9UNoK8alC1zGoyDRvX07SwGTn5MIRaeYiytA9F7CIR00T6DzNvdGRamOKVjnauPPjyHPy4YehQ19P7+XblOtQyWdD/8cpzycwYXgRejNbgcoYJKrfhULhtHfdeK1oiJNi4246y4ph6VIPCRUU4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(83380400001)(7416002)(66476007)(16576012)(66946007)(956004)(2616005)(478600001)(316002)(36756003)(66556008)(6666004)(6486002)(8936002)(5660300002)(31686004)(186003)(4326008)(86362001)(26005)(2906002)(38100700002)(8676002)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UXNhQTY5d1pEU2tuWlRjeC8wUmc1NFd3RXpoNERmMExkQUNyNkhlSUFJdHhx?=
 =?utf-8?B?Q0Y5TDJkQlcxMW9kcTNQS0s4SFJBWGVNVmlqZ0tJakpURk0vVGlaZ2I1cDh5?=
 =?utf-8?B?eWR4L20weXRiZ1lxTi9HeHUwMzBhV0hNV3ZoMHoyZE9hOVBNVlRDWW9yMlBE?=
 =?utf-8?B?RThiNHBVT1orMkRSM0h5QkxwYnhLNEZVRVdzbUgyZWVvRWtvaE5lWHNBTnNz?=
 =?utf-8?B?aW9BZUY3N3gwMWdORTZ3L2ZnL0dDL1lJd0pJUzB2RGwwSnpBUWE5eEZWeHMx?=
 =?utf-8?B?RG0rQkRrM2puUEtKd1EyWWl2TExiWmxacmc5dFJVMytjekM1eDlraGQvT09u?=
 =?utf-8?B?YVBBL3dJVnprTWJUWmRhckdKTTNMQmJWKzBDZnFVSDBzcXFSS3JEN3hLbWRx?=
 =?utf-8?B?UUdPNGFzRkFBVm9EWVhFZ3liZEVsVXk1eWpqaEo5MDFrdklpdVNVVjBSZ3VD?=
 =?utf-8?B?czN6elFtKzZuZVVUbVFqVHcrUURBMEMvZXN0cTZ0Y1hjSXM3QWxRd1ZOTExH?=
 =?utf-8?B?Uks5Z09qSkl1RUJaa3F5d1E2azhPaVFnejBSTFBzQWFnYjM1ellzMDRUSlRJ?=
 =?utf-8?B?V1lIRVYvaGVub2tGK2ZjRE9NYStZaWx0TzhmM1Rva0FkVm1vbUxCTmRrdG1l?=
 =?utf-8?B?THVyZ3dobW03RzJzWjBQMTZwWWdpSjlscHBNNTNjVG1ZQXpKV2Z5NGVjUXNR?=
 =?utf-8?B?ZDk5RFduY3ZoU0ZxZmhkYVh6Wnlxd2N6aDJMQ296a2t6SHJWMFpvZjAyOXVY?=
 =?utf-8?B?NnJTbzNvdDN0NmVrcVlCaEZLekVGWXVjME11N3FGTjByU256Njgwbi9FNk5s?=
 =?utf-8?B?ZGM3RS9qa2NOVEV4bXo3L2pBdXJlTCtma3pQNWUvYmdkM3RITzUzdnR5ZzZ3?=
 =?utf-8?B?NGo0ck9PVFB2R2pUU1lxTnZKYzNjSnhSQnh5M2hseE9yOGMrZG1sdC93THZX?=
 =?utf-8?B?MTV5R2xxWG1nNEZBYkxzK1VVbWl2N1daZFpqb2ZBNERuZmo0Y0c3alZQMjZy?=
 =?utf-8?B?T2VTSUdWU0VYTGVVVDZXRVJBZWpNREtpMkpPRFBxWk9xSUs0OTZDejBiVmlY?=
 =?utf-8?B?NC9rYU84ZWNCVEU2N3NWVjFYYSs2VVhnM1owTUlZQVc2cEEzWC9mQmFqNS9z?=
 =?utf-8?B?NEVnM2diemhjN3NyRkpkSXJpaDcvc1dJTDdpNHNGQUlIdmQ2Y3Z2bm1oZzFa?=
 =?utf-8?B?a0djOXRwMTc5L0JIaDN6TGpZU0RmalZVYUJWTUg3eTRsOHNIdnZrUnlnTTY2?=
 =?utf-8?B?ZDZCQkVubUcxRTVXaTNmSk1vSFZSWDQvVEtUQUtod1JuMEhnOUdkQk1iNzdO?=
 =?utf-8?B?a2xoTUNnQ1FJYWN1TDl5Z1ZrcFc3NmJTZWlUZWRqRktESlQzQXBZYS9CMWcy?=
 =?utf-8?B?djlxRXlNdmVtZDhrZFl3emJ3Uk9TckZsaUc3MVhWZGc4QUpMUWNhS2RURW1J?=
 =?utf-8?B?SHZrR3Jma0ZQOFlWdTVsVHRQZitEczJKdUxXc21yVkRYeWsxelhORGpGWTdm?=
 =?utf-8?B?S3NsUS9rV3VQakx5aGtwMXEyWWhTK2F6RVZhdEVZakp1SytJbU4zS003aVFK?=
 =?utf-8?B?M2xnV0JZdEpoNmRKZ0hkZFlCRVpwSk5WQVN0RERDSTNvVlRqcThubVY1TlE3?=
 =?utf-8?B?S2tjRjdUNHJHN2xQYmtZREZoTTg5UmdteGVqankxUU50TzMwOHdXVDNzazhD?=
 =?utf-8?B?V0FmWjUrTjhKNDJleWE4Z1ZwYW05QTJJVGkxbmR6YU01NmRsUnFzR0NoLyt0?=
 =?utf-8?Q?KneL53q8hPoMang3y3dhfEF/PAopuyozCD2Vzqi?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e78cdc4-a645-400a-ade6-08d946651122
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:16:54.4614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYJaS8fiXAOA0lMR+sFmkH2xY07Iugl0ze43SSu5hu7lDVmQZVICgMdic5xDvw3GkxfY5gYP7kS8C7/DvxZcce0ccZOQNtsry7QbDVOSZqA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107140004
X-Proofpoint-GUID: MjkfEOx4Oe0iGD-NWB3z7F9aFnAiKpCa
X-Proofpoint-ORIG-GUID: MjkfEOx4Oe0iGD-NWB3z7F9aFnAiKpCa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Mike McGowen <mike.mcgowen@microchip.com>
> 
> Correct driver's ISR accessing a data structure member
> that has not been fully initialized during driver
> initialization.
>    - The pqi queue groups can have uninitialized members
>      when an interrupt fires. This has not resulted in
>      any driver crashes. This was found during our own
>      internal testing. No bugs were ever filed.
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>


Acked-by : John Donnelly <john.p.donnelly@oracle.com>

> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index f0e84354f782..ab1c9c483478 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -7760,11 +7760,11 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
>   
>   	pqi_init_operational_queues(ctrl_info);
>   
> -	rc = pqi_request_irqs(ctrl_info);
> +	rc = pqi_create_queues(ctrl_info);
>   	if (rc)
>   		return rc;
>   
> -	rc = pqi_create_queues(ctrl_info);
> +	rc = pqi_request_irqs(ctrl_info);
>   	if (rc)
>   		return rc;
>   
> 

