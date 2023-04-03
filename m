Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 199A4C76196
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Apr 2023 08:14:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbjDCIOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Apr 2023 04:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjDCIOI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Apr 2023 04:14:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2F64ECB
        for <linux-scsi@vger.kernel.org>; Mon,  3 Apr 2023 01:14:06 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333624fE025480;
        Mon, 3 Apr 2023 08:13:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Gq0BqOtFn5a5k9dxWllWoW2TufRFviAFmG+XIMVNanw=;
 b=2sQooAxYO+vhJs77VgrTUBBVwEOYmPohPuDjOoPsKXiumyATpoFhAFMFvIGeLA1l2Osl
 HxeJyAoET+YCo2tIDXSXsCQBQvyuabvBtSk4OoNoa/yp8ZpgqpsMyb9qT/oYEQNeuqaj
 doMRo/F/X9w1gxW8g/1/PP/JXgtKwlXVjtIWphghtGPQRbGoi5P4e+cBNJyDuwPpXWUB
 kwRqX/164XJyuKUsFzIpf7mo4HUOtn6i/uX/0tZEHZsCzBUP39cyZ+7U8HpUtfqOe2Rb
 jmQiWR3RmhPBXaqampquvLlZG+glskyZPTmd6W8csUz1pJK/5lmQQxE1hyBODJnf/S99 sA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbhbthgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 08:13:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3337tsea017429;
        Mon, 3 Apr 2023 08:13:26 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptp515pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 03 Apr 2023 08:13:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ago8vWS1ocTwcM4HMhSrag/gvpo9qNS0gzwRat+FL0HCYlHg1YRs9jCsgDnc29uNxYjY3iVKwytHE03pQLXRUaM/6RyAyQTsIAVz3yKLESKm5UWm1BPb4+pL9juwWf+HMMM7zBVNugIK3oETWS28kLnRsNHh8DRtoV7c/dtPWcLW4uyw1i+qXYwmdY0Y88qSa2oGjsSNVcHhtU0ZC7xvgbhGWH6lcA5iNi1+DxPrmiZFDVQeEnvGDlcd9fK79Zb1TUQg1joEDBenQWWidoRMoXH/nKub3MyK+koslQ/Iwp/XdGnKYQW+8CEG8mlVduVMkVpeNU2w8C/o66qMw10f2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gq0BqOtFn5a5k9dxWllWoW2TufRFviAFmG+XIMVNanw=;
 b=I1cpPLuIQOhvTRM1ZomuVkwAtrtDnQhB/tXUsTxirO3QMJVUyu5SgK6Chq0dGv+L+CclJ6NKgeRSbVeuYsieBW3NGuVHRKRN5fG4tz4yPOXS/ETBpeFHleonYBmvv4DE3eb5m3zLfMmhbxfOlKjvsWiScCZJnJs2Ruok++FERml+4HK6sPl5XpLFC2YQTJztnDtt5+p4oWO4dwYtsZwqox4I5NVtwUIjZ2liiY2vuFcNPFgEbjPxbSY9pmk/D+CP5sAstBZTV2m91VHnJmK+N+5+mYSTmTzau89Xt4SvfHnrwwAbnjZvXdrRF4LEUzOjRtTnYAJ+uPSnzyvm4wWfbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gq0BqOtFn5a5k9dxWllWoW2TufRFviAFmG+XIMVNanw=;
 b=IiJArBtJMDZp2c0I9WolvUr6JqabadtDZRY4TMkDgLxEDQUPPenAeDorDUXIGWnCy53A9mFjWI6369FPqjJPSVvT9h3DzNhRI/fqIbpTJ142odcbKy+Vi5iu6Umc8e63XJhOX6pJiLwLDyOYXHL9OxDJuxUPZUUhs6ObMy/RZWE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4533.namprd10.prod.outlook.com (2603:10b6:510:39::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 08:13:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%5]) with mapi id 15.20.6254.033; Mon, 3 Apr 2023
 08:13:12 +0000
Message-ID: <7481900b-9139-fa1b-3fdd-4fdb9891bf7f@oracle.com>
Date:   Mon, 3 Apr 2023 09:12:58 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 1/3] scsi: libsas: Simplify sas_check_eeds()
To:     Jason Yan <yanaijie@huawei.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com
References: <20230401081526.1655279-1-yanaijie@huawei.com>
 <20230401081526.1655279-2-yanaijie@huawei.com>
 <739e2d17-f1c6-fc33-adc4-41cb97b5950d@opensource.wdc.com>
 <e9729d4e-e6d1-7bf6-25a6-5de92214b019@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <e9729d4e-e6d1-7bf6-25a6-5de92214b019@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0189.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4533:EE_
X-MS-Office365-Filtering-Correlation-Id: 463ea1ff-efcd-4703-92d5-08db341b448d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +A0Pdeu/QTDTb+FDipBA73C9B+Q1uQiSOCPUMT3fKozREwDbdABHRza1Zmj2DRrldCNnXtHJ1XANWYcY3Ims9guLi6bTx4OrSifgIcnag+HZN07AqNnJdb4UKjS5PGj5pSZgei8mvcs1tk7yYvC4FA7GcMmxmYX1ge0sCinAqednng4PNhmyVy+SNchYrGn+CTy0PRlVHt5r0Uiu4s2FB7XKwzoXbEJDZBwH/goSAkpFMIKhZouDY5dUqMw3r0BllD4yG9EnS7E8Td6ExAhxYJhcfrrXeLnwYUVGuIad7TaftZlwoxRUhbdFXqjfBrhRVnD1aJJUv2Nz/D1qu1jMGZl2S9VCAVyGXUbd8Ax8Jusa0c+Ps4QT4iDlQMlPdSlLvwHz+6gIZoUQttQr0rQYJ8iMrZ7qIuV+fRrCTa5rmxiM4jN2wZrUQiR3IHt/KgqE726TLozAfVIUtgevHWE8wkpuiyR0Xysk6wkPCCvhwNsokJjs/XSwBNN1D54Cs+YRDPUMOrL5FxzugmxB9y8459XALz5PzBlXD7ciDU/+7KOTvNOtb3ONmPkeM7yT3xw0Ktp6mLIu4SHjL+nqVnOmEhhBW2/I/eAx48A8rpimKoP9Y53wuMhj6LwLB/kzZd4ZdcpAQoEh2NnsNOA30+xayQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199021)(38100700002)(5660300002)(2616005)(31696002)(110136005)(316002)(36916002)(6486002)(478600001)(186003)(53546011)(86362001)(6666004)(6512007)(6506007)(26005)(41300700001)(36756003)(4326008)(8676002)(66476007)(66556008)(66946007)(8936002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VWhQb0FCcEphRFNKV0x2WnpmV2Y4SGR6MjNnNGRQbHFDQUxpNm16ejZmVFgw?=
 =?utf-8?B?cC9rZlhOblY3NXZmMEY2R1Uxc1VqaWFEeHV5RlZVeXRabDBXUk4reFNrNlJj?=
 =?utf-8?B?cktQbUNzekl0T2p0UGxnL2QveUZoQnR5U1NnYks3SzNXTWxEMVpLVWpZN2ZL?=
 =?utf-8?B?RTI0NEdjNjBpcHJ3Z0UzSis4UmhWQjFKQzZFeEVMb2llbDk2WG1zOGRoQzNv?=
 =?utf-8?B?blNJMkFLTDR0U1A5VUpKMmNGYzJBallYd0ZNbFhqMlBNcG9PTFFTMW00Ynhs?=
 =?utf-8?B?eTBDVjFDd3RZNHBaeUdiQUlzRzR6WVh0ZE9xWGU2MGZCQ081M1Q5azRkUTY2?=
 =?utf-8?B?UDc4UkFrSzNZTUUyOGRCelRHUjhWYjM5ZGk1NlFGTWcwSWdqOHpSbWs5RTF6?=
 =?utf-8?B?VFgvb2lxellzNDJqTVNBRDZ6TEVrRkc1Y1ZzaVNmVnZ1NTZzeWFRdGRXeUJR?=
 =?utf-8?B?RkJHK2Fyd1E4cGE2MWFVUUpPaDJIRFpwZEZXTkdITXQxMWt6eHRGZ0JPT0tF?=
 =?utf-8?B?YTFkQ1FwaEJ2UUY1Q1lYQklLcDlONjNHTXFISDdQRDJDSlhaOEpsWkxiY0gx?=
 =?utf-8?B?dUlDblEzR3pYZzY1eFMwazkzOUJlQXlpOGJVRVNMODVrUnVoN0tJb2VuTWFY?=
 =?utf-8?B?WVhGTzNyWnNQazJxN1hTT0RTOHQ0N1JRcnRoN2tlREl2S093N2RrUFpwb2FB?=
 =?utf-8?B?clJLYmo1eWNvSnlmSjUzUlM1WDZ6c0VjVlN5a21HZHlyOTYrejVpUkpHYVZj?=
 =?utf-8?B?MEhOY3FtNkt6aEs4MG1ZRzBITjBiRVFGWUZVYVg5cjBqTFpUTjR2Rm5wNHgr?=
 =?utf-8?B?Rm9jNGVHd1BiODdJWmlhZVB5NGpFSTMrRmRMS05NYUFwMy9EZFdleDJJbWZq?=
 =?utf-8?B?Q280cVIyai9jRTJmUkhVUWdPM0l4SUZya0hDTlQ4OEVBZDdYOUJScTZFOVpI?=
 =?utf-8?B?R3E1MlI3QmxXeGkxeU44VU5GSzZxMmwzZk5PVnkwWTNBY1NLcmlrcDVJN2pB?=
 =?utf-8?B?ZG9vMVdiWGE0SlNCeUdBQ0lFNGU0ZEtWanh1TnBTTzVpQTZ2RWFCaWNrclVo?=
 =?utf-8?B?bVYxdW9iMEdSVUtiSmdmZHR1aE1IU3RGd2prc3JHbWk2alBMeVljOERuNnJh?=
 =?utf-8?B?M0grUTV2ZzE5VndmOGZPU0pjZmZYMU9HUVgzWnJiK1JZdHBtL0pwdVdRU1dC?=
 =?utf-8?B?VjI2SWowait3Y1l1L2h6K1l4SVJsZFVBbnpnejJIcVlkRjBGQVdvaUR0RkJU?=
 =?utf-8?B?MWwzWUNUT01jOTdrU1BZTmRxMFpVMThzZEVSOWdJUXcrRVZ5aERnQ3ZyUWI3?=
 =?utf-8?B?aUFSa2oyYjZBV2t6Z0VOVENSZE1BQkdxK2pPbXlkR2FFbzhHamRuVkZjY092?=
 =?utf-8?B?aUdYaHBJYWNqV25nbnkzK0dRaEZBaGRYRCtaUVVHRHlwTWhManIrdmFuK0do?=
 =?utf-8?B?bUFPbU4vaDduZ3JZcmduSUFoblgybHVHMVoxUWY5VC8xUCtTUk1vdE11ejJJ?=
 =?utf-8?B?SmNubnZxMkpRLzNSb2VvbmdCSFczeFF2N3VOL3RqSm9uOTFDUnhINGRLVmE3?=
 =?utf-8?B?bjRXajJVdllDYlpzLzU1ZlErVmhJWVhhbHBSNE5oMXd0dWVzSUk3UW12K0JT?=
 =?utf-8?B?L2trZytkR2NDR2ZvaWprdlRUa3hvcGdYZ1EyaWQvYlh6NzZvb3MxZkIwcFNO?=
 =?utf-8?B?bitLSDM3cVR2YTBkdWVFbEJ1ZmhhRFJ0Q3ErQXR5ZENDbmwwUzE4eEx1dDQ5?=
 =?utf-8?B?anNDUnRlVWJsbGZDb0FzOGN5MEpScjlEalhtWWdkeE1LeHZQWDRWVG5OK2VD?=
 =?utf-8?B?QjBmMlRvaE1kMzF2am5aaUlKUElwaVJSSklGSVBrUjN6OHVHNHJjWDRQODgw?=
 =?utf-8?B?bVdMVGphQXlkU1JjdGZXT3AzSzFhdENOUU5VRlpPTCs2YXViVTdid0ltQjMy?=
 =?utf-8?B?aStueVNJTjhxUGJUakJrQkdnK1AwdUhBM2pIa3ZoNS96b1pGQlh0bUNsYXJn?=
 =?utf-8?B?QUoxc3VGVG9xSkN6NEJsTFAxaUFnemlSb0dqUExOWWE3QzI2RUx4bGsvNTlS?=
 =?utf-8?B?eDYyNmtzRWpkZk4rL1lJaUtxcW1IZ1BuVTlIN2hpWEkrRFBVQjRONnVuYjgr?=
 =?utf-8?Q?+C1evjYHllVnHxkix9I8LVnwm?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RTN1TDdhdXJWbTBoVGJSSzByTXk0anc2eFV1K0t0MWxvYlc2cjVITERVb09a?=
 =?utf-8?B?SVAwUXQvN2I0SEhWUnhOMjVxYUtKQnJ3WnBZZXIvMExXREcyN2d4Q3JOSWZ2?=
 =?utf-8?B?YnJkZHFLMllGV1hUN2dqc0VPaUtQb09ZVjFoMC9UY2d3TlNBSGxjaTBOMVJi?=
 =?utf-8?B?Zk5pcUM1VTYrTDNneFN4UjRRZ2dldlFnNTZubGhzZXB0TllLUHdnQmw4Zzl5?=
 =?utf-8?B?OXlnRUoyci9mTnZuUm1pRGNyaVV0dm0vMis1cXhuK05DRzNvSFRWdXRpT2ZG?=
 =?utf-8?B?UEJYdm5nYWFlVDlXdmE4eWVTdFQwYTN0RmZPY3NRN2RiSUdteURpWXk4RWo1?=
 =?utf-8?B?STQvcTlTNU1WdGY5VTkxWXdKRUIvNTdkdmtuTXloblJMRVdUbmhUenRwMTda?=
 =?utf-8?B?OTdielZFZkRwb1pwdlhnMU40VzlBcC95TGtVWEJxUWhJY1Q2NXVickdVMS9n?=
 =?utf-8?B?eVNPSmdxL0hYZEg4MnRCZ3lxMDNrN0UzajMyVnZNa2xVa2hvTFY3cTFBSzBG?=
 =?utf-8?B?TkFEUjhMdE9lRHhuVU9TWXBoMnZGQkVHbHUzVXk4VFphdTY3TnMwUnhjWk16?=
 =?utf-8?B?TmFFMHBUdzJJTHpSa3RpUDYrdFlXU0llMEhBQTJVVWYvaFpqczNVS25XZzIx?=
 =?utf-8?B?TlJwMHdDMGVjZUNaaHhWUlBvNkNINlRCcmtVZGdHY2NpZXhGK1RYVS96Y1Fi?=
 =?utf-8?B?RUhNSE10UjBYS2E0ZHFzMzFMOU5HZk9ZZGRodmN5dm5OM2NlUEQ4aTJEOHNi?=
 =?utf-8?B?OFVFdFg3czh3bkx0bDZwaklqR1U3ZFZVNmVHMDQ2aEwyMytoK1RrcjluUENu?=
 =?utf-8?B?Mm9ycjdGcjRFbzFDWkwxK1NLRkpBMUJTUWNBcGdhOFlUcWJjblQ3V1JDTHZx?=
 =?utf-8?B?QmJNTXduQmJ0cWZEbjN1NUltV2Nwc0xEanFmK0czRzBuVFArY2h2Y2MybytX?=
 =?utf-8?B?QU5kdVQyRmFEZmgrUXE4bjZNVUFoWkk1am94S3R2ZXEwTXVDT29UQmRKSnN4?=
 =?utf-8?B?UVVvZnZWWU9rTzI5NUhYaU1Bbnk2aEE4S1Y3Qk9tUnZzSmcrZC9FUE5xV2Vo?=
 =?utf-8?B?eWFRaW5FN3E4N2ZhME1JMTVKNzkwUnRCbmRXVTJGTTNjS2xrWWdZTEpXMjRL?=
 =?utf-8?B?blZWY3cvMXVmemhLdnBsSTNWM0Y4R1YrZzRudndHd0FUa3hGM0RqU1o4MDhU?=
 =?utf-8?B?TzlqSWswcGhnUk5WaDVScFVNR3NqZTFwZFBsYWg3NkJhdnRrT0JyNUpVWDRY?=
 =?utf-8?B?ZjRQOW5jcG5iRnpDWnV6dFBJa3BDWVVvOHdzRmxQWVFwNlNsRndiYWlrZS85?=
 =?utf-8?Q?A7liNOHgsqoPw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 463ea1ff-efcd-4703-92d5-08db341b448d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 08:13:12.5019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TS0xqKstIjTNl51wL+RY5o3ibt2HBzCkTpzY1Y1ksTIjY5Q8ISZ1vRH8dHTiYdx4zUXuOIwaLpkBW4TLUDubgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4533
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_05,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304030063
X-Proofpoint-GUID: 023BoBbcibuw0rGtX3WjWbIvFFMUS4Yh
X-Proofpoint-ORIG-GUID: 023BoBbcibuw0rGtX3WjWbIvFFMUS4Yh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/04/2023 02:37, Jason Yan wrote:
>>>
>>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>>> b/drivers/scsi/libsas/sas_expander.c
>>> index dc670304f181..048a931d856a 100644
>>> --- a/drivers/scsi/libsas/sas_expander.c
>>> +++ b/drivers/scsi/libsas/sas_expander.c
>>> @@ -1198,37 +1198,35 @@ static void 
>>> sas_print_parent_topology_bug(struct domain_device *child,
>>>             sas_route_char(child, child_phy));
>>>   }
>>> +static bool sas_eeds_valid(struct domain_device *parent, struct 
>>> domain_device *child)
>>> +{
>>> +    struct sas_discovery *disc = &parent->port->disc;
>>
>> Missing blank line after declaration.
> 
> OK.
> 
>>
>>> +    return (((SAS_ADDR(disc->eeds_a) == SAS_ADDR(parent->sas_addr)) ||
>>> +         (SAS_ADDR(disc->eeds_a) == SAS_ADDR(child->sas_addr))) &&
>>> +        ((SAS_ADDR(disc->eeds_b) == SAS_ADDR(parent->sas_addr)) ||
>>> +         (SAS_ADDR(disc->eeds_b) == SAS_ADDR(child->sas_addr))));
>>
>> Drop the inner-most and outter-most parenthesis.
> 
> No problem.

Personally I think that the flow:

if (SAS_ADDR(disc->eeds_a) == SAS_ADDR(parent->sas_addr))
	return true;
if (...)
	return true;
if (...)
	return true;
return false;

..reads a bit better (than this and the current code). However I don't 
feel too strongly about it.

Thanks,
John
