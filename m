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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A558FC07E95
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8676D61374
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 01:18:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237298AbhGNBVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 21:21:33 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:43368 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237225AbhGNBVc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 21:21:32 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16E0uuTE012479;
        Wed, 14 Jul 2021 01:15:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BzWgfsSm4+LzGULp8L3qz/2ln49IrkR38iCZOnExT+Q=;
 b=X4WO7It15e1sOfqst0OzeMw2NqAeOavQYhbkmGX4bPZvuyogGkdWVOLI9IgvpfqNChr7
 Xbn+n2gcWBwa7F1ezXiCKOcpBD9jKpojZYDo8A4gWPYHl5DjmUyrxgQU7coasQ6vTHcu
 N3lxzXa4yevl5CJDlOcayT4+dzJWgdRk/lzO9nw2xpIno72bg4gXJSGk5ajlgXBTx8Uw
 36XIviF6t3uk/l8Ax1SyxP2jnNR+IXBfH49xXOmjRoUXtR8BlNwnsnZIU66tiCTrcyCD
 gpV7ROxDHOyXIJMYcvboZHnK7lEmhEMzFT5/3grro9K4lNUBTMhR4nh0qWZPt7TakeZA +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39rpd8uv53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:15:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16E1FC3A001447;
        Wed, 14 Jul 2021 01:15:18 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2049.outbound.protection.outlook.com [104.47.51.49])
        by aserp3030.oracle.com with ESMTP id 39qycxt4y2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Jul 2021 01:15:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RMdj+gc7SygI0CVq6Vxw5itNMnHA2rQYqP/3h4OqiIJnJZLPc5VwV4z8IltjUYr2T/jEICj2eFmlTUPO2v6cAwZafgwjHOTkTLJDRf9bj7CWd4qXzkAZpJvYAmdqiZMIoIIAPBTJ58hOSeMSMRcuPaUMeE9CJS3m58WbLb99cxonCnFpAKYBMK603hNjqZ6Vs+pm1EjjiEWMm3vlT9SxMlMByXNRinem5ilR5rwIFQnsByvtPtUZO/kthI7FxO+93W7NcyjyMYlgDJLZhQ74vykLN8sMMikPfesaHVp+BAHbwWtQ8SuesZlZVfy0N4jp9MD+2rGCt53hQPSJdCZ5mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzWgfsSm4+LzGULp8L3qz/2ln49IrkR38iCZOnExT+Q=;
 b=Rb8kA1Nu31rTwQXopGxyowWtPexCEDEBeNMeMi7FHWsyq9CVwPPuLiuFj+vTycYKBvtZSJFIlTjUQliEx2pfuKUGJiGO3oACbY+gfRFTvWVmSj2ftzHGGLPRSFPy8+m8q3TJdyEwWPT+MmplOwPp7d3vsLkBJ/cDiCpJDyu6f+1drd9To84dLrcMXqG3MxaFvQq3BkpZl64mP3NxPlWUxFnCjFVSCUVDkkb56IfYPoViGrmVFskC00OIQiMuPt8kxGCZms2Uw9YYBvyEdXQIirweFyvb3ETrPE0mgltHnW+arBCytSFMNmztV2fqB1BLS/dONpD84buC8SdOQ6+QOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BzWgfsSm4+LzGULp8L3qz/2ln49IrkR38iCZOnExT+Q=;
 b=hyf9DoTzrvmd6rolGrosV0JSgrhztWujgZfvY4IsgBjXx7Mpz3QIRtcMexzATqtAyDhV/iFAPHx8SeU3PYKOCKK8bAXS8rhSj1Jh/w+4xLZdaejJv+uUsyuB9I3GjYhgPE3FDDGJKTuXLk93mWlf3wnFTc0AxfXMA21Sf7fUwoc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4722.namprd10.prod.outlook.com (2603:10b6:303:9e::12)
 by CO1PR10MB4451.namprd10.prod.outlook.com (2603:10b6:303:96::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Wed, 14 Jul
 2021 01:15:07 +0000
Received: from CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f]) by CO1PR10MB4722.namprd10.prod.outlook.com
 ([fe80::f8c1:a59:f070:5a5f%3]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 01:15:07 +0000
Subject: Re: [smartpqi updates V2 PATCH 6/9] smartpqi: add PCI-ID for new
 ntcom controller
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
 <20210713210243.40594-7-don.brace@microchip.com>
From:   John Donnelly <john.p.donnelly@oracle.com>
Message-ID: <69e8121b-8ec3-6d5d-2075-e06d96e7f904@oracle.com>
Date:   Tue, 13 Jul 2021 20:15:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210713210243.40594-7-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0043.namprd06.prod.outlook.com
 (2603:10b6:3:5d::29) To CO1PR10MB4722.namprd10.prod.outlook.com
 (2603:10b6:303:9e::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.106] (47.220.66.60) by DM5PR06CA0043.namprd06.prod.outlook.com (2603:10b6:3:5d::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Wed, 14 Jul 2021 01:15:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39c25d1e-bfcb-4cd0-36e2-08d94664d15c
X-MS-TrafficTypeDiagnostic: CO1PR10MB4451:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4451E9F64E15616BCFA385FDC7139@CO1PR10MB4451.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DdQjCFCOkDMFpIbUrVrceBl9DpvLzA1MQ0HguFGFiEOA0cg2IgJgeCHl4Ct6NGQ2hbm90prNmx/9ecTRcDE8gTsE03SPwFm/RZNajB/Sgja6XYr41cZ26nYTCyJi/p4rwZHYORoVrVUYHmouqMGWAdyQClubHfAZv5AyFQWc3Qe0scSQMO9iR8eC1TDnhq/zKR7EdfQ3IsdwO5fxnRP2ZVRFCi6RxcAGdBfbS0z2N1GsI1TCZRk7WRfvgDJjAVCDVEP0l871NPIfktxHyqS+gtRTsHjfed99p4q7tz0te7JURXZ6MfufE9ybkK/jm5pz8achnxSvD1god4u8pOW9S8UT8fNA6CmxfqGD0mk3qCXA3S2E4SaURCIu3ziSQlDMICdF80U2WFJAMfwyOhdP5NHT2G2DuXaqpJB/Af93AhBXgxo4xGnboxGrFIfctdvk7kkZrfxEEf3TwDUUIpSUuFOI2/8y4W2Agk3yEWlyus2+a9P32IH5gG+TLTylVAJTfh/vc2+lZJXPiikl/MKOjkbbICoxL9Ei/d+7tWFuELeVLrN4/IjF9utIi2j5GAborbwmHUge3IoRYQjqKctVGkuns9JaJEdo62kkQfb91DyxSDqR23YaE4lDEOHFQaCBSz6tz3VBaLZTXTbx0uvM66aaFsvlYE2G9O34ureRYO4DoHfwBy+/SujyuERiAOcSFJPiY468mLZPXEEvp0qyHkwVLBZHhcVMZzLlwmGxwuc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(7416002)(66476007)(16576012)(66946007)(956004)(2616005)(478600001)(316002)(36756003)(66556008)(6486002)(8936002)(5660300002)(31686004)(186003)(4326008)(86362001)(26005)(2906002)(38100700002)(8676002)(31696002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dGhjaFVteDZFOFQ1NGxQREJrTElFdGJGQ0M2d1ZvcGVQNmk5SkZDQ3V1bjg1?=
 =?utf-8?B?VjJHR0s4K2o0ZjJyc1Z6THhQVkdWdnFDMW85bmkwenk3aVpRbG8wOE04M0Q4?=
 =?utf-8?B?R1dWejB3cG5acHFhWUtBL2cxMTFiK1NhSGVhYVNHUkYxR0prYUtNblVxbmJ2?=
 =?utf-8?B?ZXU3NGhpdmt4MFZ1bHVrVkUyaWNTRzFLRlc2TklxdVQ1QlpEcE1tcit6MHI4?=
 =?utf-8?B?VjZ1RFNiWGx0MWpZVVAwVVZtODdOVnMyOWtKQUtqR3JXYmk3RjBWalQxam9S?=
 =?utf-8?B?NStOVy9UM3NaZlM4aVp5cWhlcENiY1oyQVVVc0JxNnB5RDNCdncvM2E0Y1NP?=
 =?utf-8?B?U1pVR1hPRTJ5Myt5c2xva3doaWphd2lZNVQxR3VhQUJoaVpQOWFsUHZJdlZU?=
 =?utf-8?B?RkRYWDhjd2dPSFdYUytTSldac2JwaXZwN1cvR0FHNzRVdk4rVmVpVnlsbzNZ?=
 =?utf-8?B?cWkvS2lGLy9iMWNwSjgyai9HdEdIUzl2N0FibkNKamVQUVZGb0ZIOWJhWHRG?=
 =?utf-8?B?eE9pKy96QzNzME1OOFBPV0w3RkF6OVBacmtIMzhzMzZuUUwweURiREFMK3RL?=
 =?utf-8?B?bjl3L1h1MWpkYTU4eS9JbHZPS3Vpc3pCMjFFMVFJdEZmZVIwYmhpZHh0enFG?=
 =?utf-8?B?Rmk2T2luMmg1YnVUUmc0MXFWejdoZGxMSFV1ZzlnSjhoNDMydm1QOXBnVTc0?=
 =?utf-8?B?YzZKMVpta3UvaDhtNDRnQ0srWXZLQmxMVHlNOG0xRlZpSVR5WDVhVDRXeEZI?=
 =?utf-8?B?ZWF4WnBoZmd0VTFRRkVRT1QwWThTTTMrNFlkQVJwNkNCTFQyRG1CRUhGWHl0?=
 =?utf-8?B?bWVuVW56bmpURytrbElmZEFiZzM5QkNlRVJSbkJWcWpWOHlPaGVVcnZ2Ymwy?=
 =?utf-8?B?Y3Ewd2UzSi9odmZvbVNKU1F6RDU4WEJQVXNHQ2RoNTZZWUoxeVdqeDZlVXBl?=
 =?utf-8?B?d3dMbTZZQ1hyNFFia0NtcVQ4QURMdDJ5VHRYcG0xaG1ZaWtWOUEzVWJGU3pU?=
 =?utf-8?B?dmhxU2haZzNuN01CVDFoQVdzS3k2Nm91b0ZZWEFaUGorT09qZHZEVU56K2hs?=
 =?utf-8?B?TnB5aFdNeE1lQWJYTGswR2JtSjBPZSt5SWtHdzV3TGwrTDlCUksyYTZNWE9W?=
 =?utf-8?B?TzNYOFhzVkJNTm93UHc1SE4wVHpMZG9yUlU5Rk0zRmxDMlZuckt5bHJsVktW?=
 =?utf-8?B?eFFJM3BwbGx6VFczWktadG84d0Y4QUJtWkNoL0I2UzZJeDZzZFNaSDlUZGxk?=
 =?utf-8?B?bW5nWFdqUE14V3Z5cDRHalhBVUYwalRTMDBnK1pSQWoyVlBvVnVNblE3Rndy?=
 =?utf-8?B?SmM3N2R1RXpkUmdmTWhvL2RTTFM4V1FxYTJ6QllRanBnQTF2ZUNFVW9uUFhK?=
 =?utf-8?B?UEIzL3YzV1d4S2NBVHBqUFFWYWhPb2FmSFBSeTNMcHcyYXBuMzJLWlpCZWZM?=
 =?utf-8?B?bWI2NVBTNG9WWDdwOFc3d2RiVFJTTmdqdHpaQTdUY1dCRDVxMkU5TjYyellV?=
 =?utf-8?B?aGN3bXFyMGJEVmNsbzg2cDRyd1EwMmV3WXVoQ21LL3U5THlzR2xmZmF1R0ZR?=
 =?utf-8?B?YjZqWGxWeFIvRVdjalRYRTQzRURaY3kvQzZOSWt5ZGJLY3Ntd2ZSMWlJZUNj?=
 =?utf-8?B?bm1JdmtENGRjdk1aYlkvRUJzdExJcStxVEt5enltQi9EOFpObmx1QlRUWVdE?=
 =?utf-8?B?WXNUWUR4Qk56Sms2ckZCdzZCUnlUa0tRQjlha0dTSWZTOTVGeVNVUDN5c3dC?=
 =?utf-8?Q?ysadnpgHBzu9IRUcktrxcVA4bamSQuN1blKdnKM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39c25d1e-bfcb-4cd0-36e2-08d94664d15c
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 01:15:07.4434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D24XV/90Zm5+eHHRl+pCJSKCbYzZcPmU2DyNlcEud2EOf6foOxFaZIwyDCovgBq7PP7YFBTwDSlP7flYf5lOqtkMIEhwoDxl8zgYXZOYR5k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4451
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10044 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107140004
X-Proofpoint-GUID: 01HWbCX8plnbbuvskmzPmUifVtJ6OuBI
X-Proofpoint-ORIG-GUID: 01HWbCX8plnbbuvskmzPmUifVtJ6OuBI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/21 4:02 PM, Don Brace wrote:
> From: Mike McGowen <mike.mcgowen@microchip.com>
> 
> Add support for Norsi ntcom Raid-24i controller
> VID_0x9005, DID_0x028f, SVID_0x1dfc, SDID_0x3161
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

  John Donnelly <john.p.donnelly@oracle.com>
> ---
>   drivers/scsi/smartpqi/smartpqi_init.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
> index ffc7ca221e27..c0b181ba795c 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -9181,6 +9181,10 @@ static const struct pci_device_id pqi_pci_id_table[] = {
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_VENDOR_ID_GIGABYTE, 0x1000)
>   	},
> +	{
> +		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
> +			       0x1dfc, 0x3161)
> +	},
>   	{
>   		PCI_DEVICE_SUB(PCI_VENDOR_ID_ADAPTEC2, 0x028f,
>   			       PCI_ANY_ID, PCI_ANY_ID)
> 

