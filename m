Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E95C04A6A
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 11:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbjGYLNI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 07:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234148AbjGYLMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 07:12:51 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAB03583;
        Tue, 25 Jul 2023 04:12:04 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36P7oce9025630;
        Tue, 25 Jul 2023 11:11:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=j2Dz0D9hAyYkbohGF0waP094uvgG9mktNYboEm5lMLA=;
 b=fwi4wH5srAE35ye1jjY0MlHYNts/LaJbhHD++OrHV4Jv5tHuJjRX/eLe+5xsKKdWJZ0v
 kBYuJ7C8rbQwLrC4ULh/HwIBiF8MmyjVB4kBkcfG/ybrjkugB1yu0cWJEJq7UOTEk2Wo
 qrHX+i4mLpUYOM2Xl+7JJT5eI0mR9nkYHbeDqh0xn55Kuas8Dp2tXGU6hqT2UKOaQ8AU
 5uVEdLeZBV1/9kBvVSGf6mJ7KMAguXUx6HaXGcUqE4cxn5flnfuIkx0IC17zWzb1fj6R
 2P5M0VD6vFVfXmz4OfRVLM3yqCQ0g5Rs54DJjOO6/C0BUXxk+sg28ikTVdNRh7GpPtHm 7w== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s07numrsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:11:45 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36PA8qFU039870;
        Tue, 25 Jul 2023 11:11:44 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2172.outbound.protection.outlook.com [104.47.73.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j53wet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Jul 2023 11:11:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hX+sYaR6I8UdHIvtrZEo9U0b9q2d4FWCmfcFSaAvKHX3Okj69UxckMGbvWUyqtwOsuWtOZvG/AlzGOAvv4itbMcmXfryh8L6SQUGSeUMaV/jf9SoAiG05+fLd4x7/lBygNZQSwFShAY46W5JgKqaATpmXPpFSgJlryLisWm+/rF+W+azQsELjn3+mxIgdIFuBMoOhL4eM4nvmyA573UOb6wDaqt3jpwagOG/cghbhmDTEX90GTClJRPPCddyUjRUdd5QD96qSnab7eJKzwmwzcQGQaaNBmcmiBv3bUrZjAGyPwWmHkNlJSs0qgr2aY04pVZKIGnpK6dTkhYmK6SE9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j2Dz0D9hAyYkbohGF0waP094uvgG9mktNYboEm5lMLA=;
 b=IBIanie7a9+nDSx0WU8RSHr5trv0ZKJz4M1YDBqVMftAObtOHhgDCQLUUc+nmRAYr3SLzjfb/rFgl01X/X/0+MOJZ4tMT9LGNXfGDCRYTz3jB0MrMbCpjwqtufNQBVnO/SoJGvpBnXcmQ3XB2+csfuAwvuHlba4SG8ADX8q0TX5ztIgencVidgfpo3XdOdCUZltEQlmrglTeIDGXrhUFQ5cldQThS4PdnzYHnJFmfixVI4KaKmaFUcx7ZzYcqiIVqDe8Y1LwPMhTHSqgfPbaY/gStNeKA21LIN2KlLfsHgYOgY6FOiM/gAWkH+1Cf+viXPqkRDgvflQ2uxI3h+jYBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j2Dz0D9hAyYkbohGF0waP094uvgG9mktNYboEm5lMLA=;
 b=q2fffru6DRPOpa0/1wHfNBMOa5bS9kNPp2GH+IxUn+imVI9BYUzPMPmUXf5I3Ad3IfjwffOSd9IGpXkWv55FNQXhomAtUlwAwLypkka6b6FO747mMs1k1WWFn00o7/iUVT/T1QFX4t9x9dpUV1LR/V0TxG5//ctD3QpYOBQQoQw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BLAPR10MB5107.namprd10.prod.outlook.com (2603:10b6:208:324::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 11:11:42 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Tue, 25 Jul 2023
 11:11:42 +0000
Message-ID: <df18a0f7-8bc4-7db9-aaf7-746092547494@oracle.com>
Date:   Tue, 25 Jul 2023 12:11:37 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 3/9] ata,scsi: remove ata_sas_port_destroy()
Content-Language: en-US
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jason Yan <yanaijie@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-4-nks@flawful.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230721163229.399676-4-nks@flawful.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0316.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::16) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BLAPR10MB5107:EE_
X-MS-Office365-Filtering-Correlation-Id: 5db6fd86-8d03-4d6f-6a76-08db8cffecc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Os2Ar324ht0006eftxa0LBZKT4WBkdIn8j1aSIAi8wFaGNi3P7NPpmZJRV7ezZ2uxtZ49OhpzDUMhPMu++AiojGfiZtfauB4Si/FEd8Y0XOV+uwVdQz39HErbx0V7QdFVAQ6n0OcaQeR3dfPBFbwHYUlwyOO1q4GzF9KRyMady+kFwcSIsM6gdWy7OH70yOw31oNM+kT9USHRQLPItj522Sd8PP3sWXGZX+01rxS4HM/lG+zKGa0OMdZCA0OXBd+aNrtj9oG1I21YIIHv8/KGg/yP5BgkJwS3JozI5zOzG+CoBAUnFeBx6Qbj2myyvOkKqN8V9cuE66kAx1Rz4iOha0N9UxsCeEERLAa/gsoRfiRmFAl6uL/1Kzckx2X80gzNTJu5bs3vSND68Fs6DSbmmmc2HVLYy6JA9C9nur/KR8g8X6I4VlP5oKmRQweOdzyS2KdjlH2lYDZcpCCM+temOcz2XD6YUwYmVW3QvOrjj44gPcvFK2qh/1X0wD7Wtm9dzeRzOwKenrRVhWXxLiZXVfMKwqgLtTD1GoFAV6TPSAIt4sSkEHZcC8Ks4r0YnjkBAGvfPV8GNuWgJBQDCtXlRHaMGvnVOu7EIJ0q/qKPbl7au4oKq6c5DxskJxba6WtoBSIsnFJMPx/eU48cQoa9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(396003)(346002)(451199021)(2616005)(6486002)(36916002)(6666004)(478600001)(86362001)(6512007)(31696002)(36756003)(26005)(558084003)(53546011)(6506007)(5660300002)(41300700001)(316002)(8676002)(8936002)(4326008)(2906002)(54906003)(110136005)(66946007)(38100700002)(66476007)(66556008)(6636002)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDdYSXpOditoTDRvVTJjUVBpUkpOZTJhcGt4UGpqWTFmamNqMDJmZkpvNTZr?=
 =?utf-8?B?V2hCemxnSkJJYUhBQmE3d1hRVXN2eTZlcThBQlcwVzNGT2h6MEZ1WlBWcXRU?=
 =?utf-8?B?SDhmdlA5OXFqcU9ha3NOTGJGcGxuK2VyK01udCtUdC90OEdPakpsSHZ1Z1RI?=
 =?utf-8?B?VStvWngvUWlsWHMyWC96ejRQMUFUVkpybGk4ZVNKcGp1V1lmcHVZL081cnFn?=
 =?utf-8?B?YnhYd1Q4cG0za0ZCLy9yL1RlelRXTEJHV2RtWjVCNno2a2pIb3VLcGwybDcy?=
 =?utf-8?B?Y3g2VmY3RzhJdWV5L25OYU45YVNMZDkyK2d3V1c0cVRUcmJONU5XS0Q0U3pQ?=
 =?utf-8?B?bWtnRnB3Y1d0b0pZbWk5YWptYjBEU3grMWJHMHB4TEFHN1BKU2Nyc2NFckw2?=
 =?utf-8?B?QW5GOGFQeHo3bmlJekZncE5oRmQ2d2UxNGRrVWJBTXZ3SGh1aVlUTEVzdEls?=
 =?utf-8?B?VmJWVUVYdkZRdmx1ekx6bkZCV2RZL2pwTTRTT2hENnR3T3AyOUowMndUSWtG?=
 =?utf-8?B?blJ3OHFPelVTZzFHWkt4c2FHUFVKWEIxa1ovcWt5VVNYRUFrM1AvOUZnTnAr?=
 =?utf-8?B?VVkza2F5bDNmQ3pOQTk1Ni96MFQzNFRYSWMxclgvMFlIYjZreWZIdmQ0eWFQ?=
 =?utf-8?B?cjlIZUtkQzlicFd4dXBLeDF2dEQyTUdIQlIvUEJpK25Mb3RMaDY0TnNZYUtu?=
 =?utf-8?B?cW95cDV4Q1NBbUE3R0E0dHI0YjA3b2NSWUxWZDJCS1A3KzFkZXJTS1ltZVBX?=
 =?utf-8?B?TTBCbGNKQURiUGdIZDVxd0ZYRFl3R1dad0VPclpjQUdUd2Q5a21adGd1cXZD?=
 =?utf-8?B?alQ2RmlMcWwrOXJQRmxrZmg1ZFg0ekZNM0RiMXJ1d0luMmhrVWZvS0Q0dzc1?=
 =?utf-8?B?c1FrTWJRQVlwcm1qWitqU0hzdHdjYXBiRlNwSDRrL2R5U1NodVFVdExhZlRO?=
 =?utf-8?B?SGh2d2J2bllOb2ZxVGc2bFRPM3pkMUJsUGtDSkR1MFRBamQrYVl4M2xOeW03?=
 =?utf-8?B?SmFOWWh4YjRlY0ROQitHdFRsSFo3d1BNVVRFc1czOFgxVzhZeVQ2SGVJUkgz?=
 =?utf-8?B?SGhjLy85OXIzTGcvOFRjOTRMdGJNbUVnWmRFUVNja3lrN0NnVHNhVVNwRGtZ?=
 =?utf-8?B?YzdrSyt5RjZBYlVnOFpnV3hPa3k3N095M2YrK0lGNE5WN2pRUFZWY0taeDlU?=
 =?utf-8?B?ZXAwRWtqV1N3YnNLRzhKamhtSUp0NkgrTndMaEJsMytBdGVoUFVyQzA1dkUy?=
 =?utf-8?B?UkU3TzRpSWN4NnhrdENDOW10NFhuRjB1MHlDQ3BYcXJjY3lYZ0pTODRyTjk0?=
 =?utf-8?B?R0wvWlA4NXRyRXljWi93UHM3UlFwR1dUaXZUTkZlMU9ZMEFqbjI3OU5IYmFy?=
 =?utf-8?B?TktacXpTTzByUkE3OEk4VGhrMmFmMDl5NHRjSkZmbzFLdVBlbXRjNTZaY2tm?=
 =?utf-8?B?UVovdWZ0TWNHLzJDWmR4OUZqTlZoU2F6SUNzRVR1RDVXMTFEdUluN0lXSzZm?=
 =?utf-8?B?VFZHSG02S3YrenVja05YV1hPeVlYTmJ3dU9TY0Q3Y21uYlo2R2VsaGJMWGNu?=
 =?utf-8?B?UFJIaGdBcnVqQ1c1VkU0LzcxVE5ZUVR6Yi9qUDkwdXB5Z2hrTEkwSndtSHZJ?=
 =?utf-8?B?U2Z5VE9uV05BUlBTTitRV3V0bDY0ZkVwSVVzaGVIdit2cWtSS0VSSmVTQU00?=
 =?utf-8?B?SWZjMGR5S1ZoSEVEKzZNKzY2eXRPbmZETEJTZngxS2VwT0pTMzczTnplUW5l?=
 =?utf-8?B?emJpWkxrQmVZUlhFNWxhNmh0OE1DRFVpWmdkdUlWUGN6U1NUZmhIR1hpYmdT?=
 =?utf-8?B?TkRNN243NXBrSmd0T0thVldmMzBReW9JSXk4aXNhanhuallGY0R0K1h4ZEFj?=
 =?utf-8?B?RmdEUndIQ3ZkT0tIb0tWN2JMRlcrQmRhVkRHRGIzU1ZKNnVTYXhkR3YrMC9N?=
 =?utf-8?B?R1VISlFFUE9IVDU2cUhTZ210OEJYdklrNHZXYUd5ZUJFbkZKOGNySitiQ2ly?=
 =?utf-8?B?YkxNTysyRlJ1eEtnaUo0WjE5UUQxQk5pNHRLRitpek16Q3hSQVdYWG1QSWtB?=
 =?utf-8?B?UWcvKzRhN3dYVWduQ3VkYnZwMjQ3eWZJMDZmOVhYaTQrenJ0ZEVwa2RKK1Ez?=
 =?utf-8?B?cWtiZjkzT2Z4UlNyckZ2eXJtdDF0Z3RCZ21sb0JwZGVkSW96YmgvYUZqQ2ND?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?aDFPbkF0Wm9CT0t2R0l6VndBdmVQcTZ2eXdvYXVDcStHclVHK2lvOWpJMWVP?=
 =?utf-8?B?MzZJWk8wQVNhVzJqbk41bjRralFWdTRUUFN0SlU4U1BQMHdJRDdWd1V4U3pG?=
 =?utf-8?B?alZJbzNueUE2NUtKYVRYRzBNdVozSC82eHRlQm9jdFdWWTNnd1RXODh2RUU2?=
 =?utf-8?B?TnMwbldFV0lMU3BnTGJaeXZsTStYaUxvUVF1a2luSEJ3SWtUY2pjSEErQThh?=
 =?utf-8?B?dUQxQ0VhMktGdGF2M3l4U3NENjNZUVJDRld4eFZvUGYzT1dvbXJpRWZWRjZj?=
 =?utf-8?B?WVlnN0VOVkdvKzNOcEJGOGlZOEgzOUdRQ1JlYmVUWEM1RmhEV1RRWlpXbk1k?=
 =?utf-8?B?OUlsWUpXVURad2FldjNMbThYOTFjZ0ZDNzJaZUx0OWptOXJKRHRIdWx1d1lJ?=
 =?utf-8?B?Q1poVHYwVUMrRTAxQTFkbW5PUDFlTGpQTHBoT3gvSWxPZ2k1QWplVUl3S0w2?=
 =?utf-8?B?MXphamZBZUV4OXh0WmR1cmJWREFLZ0hwSFVYSzJ5ckhXODZodzJIZzQ0c29w?=
 =?utf-8?B?dVRWQmVNZHJlS0tBVCsxWjlVOUVEUWkzWmZmb1ozN3p2Zk1wUS9JNTdUVGJN?=
 =?utf-8?B?ZlVqODJVNGxBZDlDbVpBTXgvUnFEV2phNFNnNHJVTkNiSzdZRTJFRkdHYU5q?=
 =?utf-8?B?TTkvRkJxcEZTc21Sc0pqSW5TWEFialpaL2JBczBmb05XVUdueGdEemtndHha?=
 =?utf-8?B?MjlyZTRkZ3Q0T3l4UEprYm9ISVpicFNzRC9saGxOQ3BYUjFjU1ovc3FPVFpn?=
 =?utf-8?B?OUM5RGIxcVJWVndlMUU4bklrYVBlUUIzMUZKNDQwVUVSMERPNXpFd05OdU8x?=
 =?utf-8?B?SVhNZTVoZlJjODQ3R254NG4ySFR6TE5GVjBsekw3NUFtb3RuaHYzcmJzTVRi?=
 =?utf-8?B?RlkyZGZZbEt1Q1BPa095RjJNYm5ZSlN1TjdkT1hUeFF0dUtQWGpSN0YyMUd6?=
 =?utf-8?B?WHo2d1ppTTZpS09RaExsaFhwWStvMUhBaTRpbFFta25TamcvZGdNR2kvM0JC?=
 =?utf-8?B?akNhMWd2U2N4bFFERXg1WlhhTlh4cTRPVVc4K0hlcUt6SUlHSUc5M2lmL28z?=
 =?utf-8?B?RWNLSjFLNTZaV1MwMkRmc3BRUDBITDNRYTIxQTBvdCtlM1lLbVZneUYzNjBx?=
 =?utf-8?B?NG15czMxZFQxbWVkeHJmam84dERsUU5TNWg3M25oQjNiUUQwSDA2VHd1ZDd2?=
 =?utf-8?B?bDk0eFErUUhuTTVTUU94b2czYWJ5bm96WVhHQ0lHVU9aSG5qNHVFTU9MeWV5?=
 =?utf-8?B?b0s0NUxDMDVsbVI1ejlHaEZsREJta1VWVkpIY3ZJdnRpc01CUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5db6fd86-8d03-4d6f-6a76-08db8cffecc9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 11:11:42.3168
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8EgItbxGhqoTbq0PWIBXgq5fHzLRW9b/fGNQsE1pQjqDOXAl7ohzK/ccqkuqhPgWyPj2tRblk35hI6V8kPw2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5107
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-25_06,2023-07-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307250097
X-Proofpoint-ORIG-GUID: rdmeP-QPKCCKJQjcdvwD2TsH_s5fXQgi
X-Proofpoint-GUID: rdmeP-QPKCCKJQjcdvwD2TsH_s5fXQgi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/07/2023 17:32, Niklas Cassel wrote:
> From: Hannes Reinecke<hare@suse.de>
> 
> Is now a wrapper around kfree(), so call it directly.
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>


Reviewed-by: John Garry <john.g.garry@oracle.com>
