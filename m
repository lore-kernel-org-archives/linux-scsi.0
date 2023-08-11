Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F9AFC0015E
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 11:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbjHKLM1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbjHKLL4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 07:11:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5992BE4C
        for <linux-scsi@vger.kernel.org>; Fri, 11 Aug 2023 04:11:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37AMiwOI003287;
        Fri, 11 Aug 2023 11:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ndUCurpw8nCQ5iJP+0DF1smq18ay6qwEc1uDf7rFNP4=;
 b=WoirsGfL5v2hBg2vX6dY9m9vq1l74aO7/ldkQZYEl1h3bPGihC+wITTkG6SYXmwFh8y8
 KeeItq5LjvAfLSR7ddToVD/TKXqDqxBkOzuiJuGk7wNUqbFfaxxbAcBHZmvnLOf8JQ3I
 egqydqOuq/B8EA6i9QU2eCdvliHJ14KxF0MPgcTbSsZB2F3HZhpMtqxAJnu48ikelsp1
 bldnLDUg9H4oKLOK2UJ57UFhEORO80Aq5EPzDTKd82kvjE2/2bhhxp0IPapG0OdpU8oB
 /nLjPExsjDDNSuimgzDt1Bh4AJVPneA71TIbQVGBqm6CljEyouvG8W5Y5DL544mJCqfj BA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sd8y5gtdj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Aug 2023 11:11:54 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37BB123x018512;
        Fri, 11 Aug 2023 11:11:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cva84a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Aug 2023 11:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sp3F6+WD1cFjfvaNtT2iomezpx7tIfRy7d2YDvkuQmg+7cHsJqjkEAOKwoz/DmIlSMkbvATi/TpuLSPwkEhlGtxfcf2HeEdMMfPr7tcTPkwjEIVOWAQdy1mfWS0H81VdtlGt+u4wtp+EvyuNiD0NJwrHXdbanUusZh8pLfxvQ4r74fnW6+zjWCfQQkr6htrzZhpLkCIKyXpq85TiDrouYBN2ejexeciehWOR6Sr1i4uySkCLf6D3Wlv2semTZJbwsWqNrdZOzUcMJCgCEDm3rSZsQkYdtufOLKHcwow96pLss/1ECM1MqxZxLBtri7F/ADIOtxY/ksyrFBfnD1BrlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ndUCurpw8nCQ5iJP+0DF1smq18ay6qwEc1uDf7rFNP4=;
 b=YqykWPYopHuet64ks6ppo90n6TxNPpzvteIh+fzYjuXW07qUzVDulhRbGRVLnxvPMAa8D0DrBP+z0g6FFTL57VI8aio/SOzJw+WooZrv4vEjn2dzYhqxCWQLBSkPOIxwruPy1xfyUNkqqxAxzXx+ahae9CVl4w3eKWCZoYnouUvKZeIWtEbSSuuHfVNFd2KeYwEU9NyN3oOfGzrkSTATVn/YuAKa660RZ8npfB8APtRK6j3tJ9JQppYzWdWKQV5dFRpirQjcK1wOLQO7dDCKohMAgKuILL+bPPTu/FYQa5cBa0ZxynG85E10orXZQW9/vAsbgxPpZuMJ80LNL8ywsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ndUCurpw8nCQ5iJP+0DF1smq18ay6qwEc1uDf7rFNP4=;
 b=Oj2msh6/M1SO4Mzbd55Xe/NsSwR80gSV1ThTDUrveOUpcTHAOA9vk4gFB+zQjfivVWLQtqaFcYyRn3Li2kRaTrOBIe4XJw+ZtWAJUWiG+UtUPJtfSK6uJPbqkY/KeWQyPn+VhGkHZV28N57afErfckHvpvx4YeKVT3tCIiO/JJY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6321.namprd10.prod.outlook.com (2603:10b6:303:1e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.20; Fri, 11 Aug
 2023 11:11:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%6]) with mapi id 15.20.6652.029; Fri, 11 Aug 2023
 11:11:51 +0000
Message-ID: <ef271d1f-af8d-b8f3-9d86-d05da1d9e49f@oracle.com>
Date:   Fri, 11 Aug 2023 12:11:48 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [EXT] Re: [PATCH v2 07/10] qla2xxx: Observed call trace in
 smp_processor_id()
To:     Nilesh Javali <njavali@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        Anil Gurumurthy <agurumurthy@marvell.com>,
        Shreyas Deodhar <sdeodhar@marvell.com>
References: <20230807120958.3730-1-njavali@marvell.com>
 <20230807120958.3730-8-njavali@marvell.com>
 <c010df11-79e2-15d2-135f-71ffa6a6e8c8@oracle.com>
 <CO6PR18MB4500AF34C81EAA0943260248AF12A@CO6PR18MB4500.namprd18.prod.outlook.com>
 <bc617ed8-ea8c-eb4c-30d1-a3099684bf59@oracle.com>
 <CO6PR18MB4500364274A11D261DFAF021AF13A@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <CO6PR18MB4500364274A11D261DFAF021AF13A@CO6PR18MB4500.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P189CA0039.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6321:EE_
X-MS-Office365-Filtering-Correlation-Id: a6a8dfa7-5600-4d4d-c248-08db9a5bc33b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kwk6wZXhWynuMLgwxNxqfA1x+nnHdJpuYu+tu4sOcdKLwvDyRGfvtXF8N8mguhpRcf7k6jxl61jwst5VrYePouamFPl9OtyJmWtvnRaoh206WEvdiVTUvemsPnEqzIeTwSOE3WUWhyA47yxAHPw2EiwsZOM27p9G/w/FSsBbIe9WgzqCjgGY2p9JW1nc3EXUsdmLGLEJa23SaCrhVk58oe9TGWnt/gk4IEiwGRJUn8hdnSFDpq0IVrSeK4Ss6N+XiSTqBG47yn0KgICY6yDniz9W26IiASgHpyW1Yg1OdQFgVPq0KxU1J06cvbxa/0kVkTnk8xUrfnzEc26pP8i5aDMciHUOQOrivOrtlGLHYsHDSsF7ljmM7aCv2C9Y3dmil6dKj5AjyvGf0ifziZSlNBV5zrBpYlKm8IDcJvLfLhTSZyxKlGPrWuhr+CS0m1GA/MpNj4Q69iKdoST7X2IbAhlyqu9aPtqOH8XHJGFXw6NqbUKphP/c7Nnc2hpCEtZGdMEx6V0c/FYmxaRGAwXUq5jrm4Lmm7A6dlUyFb0XKDsNHZGLjBBSqJfTy2s0REIRavJotSV9cWlnBM8tVR1+UDEjHPtTINRQqweC1yAEWV5l+sybbpVnEhom6kB91O6H2PdLt6IR4S79WS4WDSnf8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(376002)(39860400002)(346002)(1800799006)(451199021)(186006)(36756003)(31696002)(86362001)(38100700002)(31686004)(110136005)(6666004)(4326008)(8676002)(8936002)(36916002)(6506007)(6486002)(478600001)(6512007)(2616005)(26005)(53546011)(4744005)(41300700001)(2906002)(316002)(6636002)(5660300002)(66476007)(54906003)(66946007)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFpGTWc2eHhuQWVIUU10RUplOWMvZG12V2RzbjFJUUJqUWwvenNsWmtSVTZr?=
 =?utf-8?B?UThnclBiNU5kY2U1akVUMlJEUE5GenYyWG95M2d4WjRWK2VaYXJ4SkdoRnZp?=
 =?utf-8?B?NkhFUENETGNQb1JCOW9LZGVDbWUrbzhEOFcrQXdIUGhxL1hsMjdadE9VRmhV?=
 =?utf-8?B?SlgwMDFYNnFCR2pSZHJlUGUwS1pNSmwxcUdEbjM1RWl6ZGJkVFdtOFZXT1hV?=
 =?utf-8?B?d2EvckNhK1kwdjQ5Q2lyZk1mdkhTekppUldaWDJnRnU0U29zcFdsTnBURURm?=
 =?utf-8?B?ZFIweVRIcHlPRlhVaUZUa0R5N2YrazBSNHBXNGh4UDlFWXkvOXc0bElXOG9w?=
 =?utf-8?B?NDhPTzg0cXdTR0t1WWVTSENkZEhLMVgyNkh6S2tyakh2NUMwZXhnRkRNaEp3?=
 =?utf-8?B?QWRmK1ZUZ0ZlejRGTEFiaXV5MEJuRXZCT0kvL3c1TFF4anJYYTVrZ0t5dWo2?=
 =?utf-8?B?MWwxS0lSTlRSTlVWdHIrZlZFYXZPV2I2Q2ZXUVp3TUVaMnFpOERQM3llWkpZ?=
 =?utf-8?B?YllqNXp4U3NFTXRidjdmc2poM1dFUlkyWHM3dFQwWStiYk5ZU1lobDVlbjBU?=
 =?utf-8?B?OVdFcTBSNEduWlB0QnRiTE5iMWhhdkVKMS9HZmVtc3VIaEpjSUk4MnIyYXR3?=
 =?utf-8?B?S21WMjJXRUx4eUwwclpnWjVLTUM0akkyb0IwVHhrVTZocDhySlo4WndHYnlt?=
 =?utf-8?B?ZkxQVjJmTFVpQTlld0hRK3lHL3k3RjZFTHcydjB5OENaU3FzSkVSU3M3UEM0?=
 =?utf-8?B?QytZbFV5dGh6aitWdVVmTVFXQS9aK0I3VlBENGsxeGY0NFZoQlFLVGpZNGNw?=
 =?utf-8?B?SDRUODBUbTc5WUg2aDhmOWZIMEppenovYyt3anFENlBxOVFTL0VjUlR1NEYr?=
 =?utf-8?B?cFJsbFRYVDJYYkY0NTc0dTcrM0dUV0M1d3hXcWxPZnZqSUQwTWR4Q0R3dGJw?=
 =?utf-8?B?SitiSmZzOGttc21jSE1tOVVhSExZTzJackN4bG00M2VTQnB0a2NXbmI1NGkz?=
 =?utf-8?B?RW1YT1V6K3ozUVVSVjlRQ2t6aDZVdHZ0dmMxbTBBdGVwTHpsdGVqdG14bzdW?=
 =?utf-8?B?SlE1eGNwdzBWc2I0SUtJOWc4WW9BWkFBQTQ2NW5xcFIxWk5qZ3hOZEZjN0h4?=
 =?utf-8?B?cm1zMUg1REh2bkttQzEyd2tmMWRwSmd6ZHMrVWxKaWl5U3U5QzBNVnc0aGtG?=
 =?utf-8?B?MFMyZzgwK3ZmRDJ5OFJ1Qy96b2psWEMyME5HbTljangrYmFKcVJCQTRYWmN5?=
 =?utf-8?B?OFN5RVU3RTVHbFVJZU42cnk0UTg5d1pGTzVmQ0xhek5WYU1QZjVKeTZZVjds?=
 =?utf-8?B?QTIwcjRsR2lIZlNwVG1mUTdtRlFRazUyMEdhWUF3SThXdHNCbFhscVIvZUNm?=
 =?utf-8?B?WWJiMGRBRW9hb1Yyd3lNVTJEV3ZvZlVZb0lzS3A3dUpmMWZDNmRZOWVnZXU5?=
 =?utf-8?B?dWJKcXpuVEtKL09wbitsTnVHS3lYTXB6TUFYSUlJL01EYmNjTXFHL1RKTVU3?=
 =?utf-8?B?a1FNYmJhbHdOaEVDSExXYzJaRkJSbm9GMmF6d1E3UWhwUUthQXkyT2UycDJq?=
 =?utf-8?B?bG94N1hpTzU0WXFOMkdGY0ZIYnF3amQ0TDBMOHlKNnR0dnRnUko5amlWVEVz?=
 =?utf-8?B?Y1NESmpjdkJmenVxRVo1amtyK1MrZnZsVzdPVFVDZkJ2YjgwMkZ1ZzBTbjJa?=
 =?utf-8?B?RFpiNkZkb2RINXN0QXFWSDR1M1BPclRBZTBJSGlQL2ZCWjYvNC9aSU1RZkta?=
 =?utf-8?B?NHRjK3cwTWxMWmRZOWpwcWh2VjBqNHQvcTBPSGtEK2pWUlEvUks0N0s3VFh1?=
 =?utf-8?B?QnBmSnI2dmc1RHVuOG4wdDlFYkJJSjVOZzMyWXlXSUJUdGxTM0lEMzNuTjdL?=
 =?utf-8?B?QU1xZ0hxKzJHZG5jTGpWbHAyRDdTRlMvQ1IwNG9LemF2QUFPcW15R1NLUHha?=
 =?utf-8?B?UEpLVTZHT2RqZGlCUzdIVytVRUhaSFdZb3EwcTFrT1E1MEJvWGVoQUxnSjBC?=
 =?utf-8?B?VVhHS2JIOUxsVXlhVlh5NmJYck5pVmZaWXYvS0kzakZ5NVh2dEowNG1wdDBq?=
 =?utf-8?B?RUM4QnBwV1VSQndyT1UrTHNOdVRrNUYvOHlWTDFXN3o4cjZkbzAyQnAvV1JE?=
 =?utf-8?Q?c+r94Mo06cF0zuh5ZzQxHJO+m?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GDZff2Go2N0G+rmh7FxHPIgN/QcA2B8xqHliVXamDygiZHd4nIevA6JEBrCRAT9TxMB86+1ZGPpJtUPWKQOYmaDh5L0AYidMvK3AudrCIDBn8tBEo6d5vt61vJQRoEcvfhdDMJu5sVzKozgQuwF+SBTozPZtpwZit0QUnz9dFhJ3eAM/4wBFq18kYqyom3Lm589VbyR1KCvGTdv4pTG1GNVy/vbX5teIzCm6V/ScwkH4nXqnoLUibm7asfXe/+KCxzst1659kgl7usNWqUZcLB+KIfMxUAE3YoYeQkwTv0JzO2vLMMY9uKaLS3DoJZ+mM/OPgAqQM91Llt4USSjUrnDdIvZWWrfzaeGztJx+FwkN2ql4MUp7SNpoanYvIxKGBnw0HPnr9uW77Wm8RH+y13k0Orvx7rGYVo2hdWbCb8TMjkHmbvewpHfBJSu0B8Gza69OLXfuZDkvWqcsSmSyD4qF3+xiXXQpB5xNW9G6pkStjL3Ev7a1wD6W0fWLSx4HsMAGZ3SK350xPADUK4Tpm/OTpYrnR5qsd6jqVXouJNCEBIHz1OHzHAwESgVvRrzpuMGdUsc0x0QpkuMJ+jbbzoKs8tVK6C6sSIZZRtiuyV0yLlExZHfUSGCIr+BMNQg+fEGAuTuPu/cp3epiloIo+mdvo9Sj7JCfy3KpHr0kQa+bxU1vMPLyQX58xKkNpEbJbWFPml4D4hzmO2QdsYYjEmUx73uysg3SJAHaZONBGkEF4Nyaq0209KDGlGo1AoxGbwO3cQGwcJSbNGJCA2jAgqQQI9ZjqNCAXOnhqkcS6pA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a8dfa7-5600-4d4d-c248-08db9a5bc33b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2023 11:11:51.4228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m0GelYEc1rZqK295Sdiegr7omYHY3vtUnuoTFo0uuhc2sfdxUK52E2a1ArmwhpAr9bhA/Q3dYS7merTm02OUyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6321
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-11_02,2023-08-10_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 phishscore=0 mlxlogscore=951 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308110102
X-Proofpoint-ORIG-GUID: l4mMP_Cp47vbgfIAW7AzJAu38rdEROae
X-Proofpoint-GUID: l4mMP_Cp47vbgfIAW7AzJAu38rdEROae
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/08/2023 12:22, Nilesh Javali wrote:
>> So isn't something like
>> queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work) same as
>> queue_work(ha->wq, &qpair->q_work)?
>>
>> I see that queue_work() already has the raw_smp_processor_id() call.
> In fact queue_work uses queue_work_on that has raw_smp_processor_id.
> So, qla2x using queue_work_on with raw_smp_processor_id should be okay,

Using queue_work(), rather than queue_work_on() with 
raw_smp_processor_id(), would be simpler. Simpler is generally better. 
And I see no advantage in using queue_work_on() with 
raw_smp_processor_id() (over queue_work()).

Thanks,
John
