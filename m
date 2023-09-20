Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A5ECE79AC
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 07:14:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233534AbjITHOd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 03:14:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbjITHOb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 03:14:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5A493
        for <linux-scsi@vger.kernel.org>; Wed, 20 Sep 2023 00:14:25 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38K6YNN2027096;
        Wed, 20 Sep 2023 07:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=/uyTMVBz8lITBPg9DWRi40lZ6dD9/wJiQ9Ze/0Nk6fo=;
 b=ZDdBDtR/nx0mD5uDWXefOhZNAlAfODXw1s6PRkVObkowKHFf6bbbTyvcJRFR/Vjnvl2T
 Lw40obV74+iqJjBOdOpvA806tjTPmDIPA5A+51Di3B/UfwOECawZ65KdepiXzQNtldsY
 p6qbd++uTdkrdiZ5JbwUTnnoSDdwitATb3oHrFJIXpGNN/Ap2Kwjkjgj5KQV4Z7r65h2
 3GN/VqkJ4RicAJH1JVSeYB3++jg1nmApuFQgcR2kXa+Nac0mPQ41EjC1KpOg0c3/hDc1
 JCZMjjxDzz7+REeU8N7nBAsKwiO0ieV8gHnQzt2OW0rqIG3+M9rN5dXtzp8Y2VAtCIcU Lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t5352xn26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Sep 2023 07:14:00 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38K6mSpw030801;
        Wed, 20 Sep 2023 07:13:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t6q2pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Sep 2023 07:13:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GmNQT9iauv5fyEOUMje2BR5us+6occfRYSuYXofkEFGhHdwmZ/aXWYj3sZAi9XfFCGEvl08I54+AMByzUi1XLM6CoIZLs2DWGZLTL85sCaL+TgJ6yQoAOovfACGyyzEWIZ2eFQkBIU/Vac1ieVagOMzW/MJHfwk6tg1R0JsUquohTbjYtrNwxclqOofuSQVRbU3lkY8lAC+S6MAFtbEzDky6XzoZtog1fplE/F5xjsM5b5AJgWr3pXQ0zn0rVR0LKSIYC0i68TnQvuxxcWeolDBjBAdIQ+bbpL0BaJszXIM4rMYTMtLMOujvyzo8NAkrNeTTCzriU70NSfAATqEEgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/uyTMVBz8lITBPg9DWRi40lZ6dD9/wJiQ9Ze/0Nk6fo=;
 b=FQbk0kOfVOerEfdHAba9GKx9xJ3jeSSV1l9d3CMBB1xY+uVhD2qDupq1Tn4hdTz8OdemkOpJ35ZnD/CHnAQmoqHP1D+jnp36GL9yznU0bwaEb4dow87Z9CK1O4+AlziedyUKF1RKQcEHUV+dmhHqDC5urW0FwzeRngbWGLN/Q5Dc1EoHjba9pbhu+zku9x9QwxkHyl/m4Xa+ZLbGqNTolEBmKP+Ndr0UzJheotSl5/dnq9iJXGwIu5ZRKpcQtczfaIzwAiKOM5wdDavduIjq9yXQXPxgomw+qTkkCnn0p+DniHJu3XCcF9HQEf7T/GAlE1tXYasdTYjdKfuY7RopTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/uyTMVBz8lITBPg9DWRi40lZ6dD9/wJiQ9Ze/0Nk6fo=;
 b=OoF2W8tSfI1gWUXXP5Qkf2e3/uZ5EY+gsjAjrj7KOAtyyronMUyixojf1FlMJhEdyyKB3K0ED6wJcl66jDNqxhYBOcuGizHSnMhf2fBrk7egy2AdDKtkQfT+JtkS/c7quXEPVq2BXoRJw2y7VW/mbEdO7daKcuuMG2+simpI1aQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH3PR10MB7763.namprd10.prod.outlook.com (2603:10b6:610:1bd::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Wed, 20 Sep
 2023 07:13:57 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6792.026; Wed, 20 Sep 2023
 07:13:57 +0000
Message-ID: <dd2ccd9e-a255-51dd-068b-ebc28811c237@oracle.com>
Date:   Wed, 20 Sep 2023 08:13:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 1/4] scsi: ufs: Return in case of an invalid tag
To:     Bart Van Assche <bvanassche@acm.org>, daejun7.park@samsung.com,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>
References: <20230918162058.1562033-2-bvanassche@acm.org>
 <20230918162058.1562033-1-bvanassche@acm.org>
 <CGME20230918162757epcas2p24a62d5f284e643a4f9e4da50ce0bd605@epcms2p4>
 <1461149300.81695164283129.JavaMail.epsvc@epcpadp4>
 <9a382188-14d2-4142-831d-223c6823f316@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9a382188-14d2-4142-831d-223c6823f316@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM4PR0302CA0004.eurprd03.prod.outlook.com
 (2603:10a6:205:2::17) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH3PR10MB7763:EE_
X-MS-Office365-Filtering-Correlation-Id: 8751335e-5bea-4065-8a07-08dbb9a92789
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: URyDEkLKAnA7I46rBMvW4AlG1UcGallN64P+1ltmOIo6boFTY9ThHEESQSR7lLUauTAdhlENwmieEhHjeTsONiILP4Hy+HAWkKfG+NUoEFYBI04ASyeRNGi9zCmr6bFd+Vp1xyVSCY3WWlnjpYnU55xIOkMaI6y4RssJ79DlwwixmO0HEv5Ki4CFpO7R03DjPTMB9Iup7dUa8loT6KllhopHl8GpwP2gemzHmI11/nyDZhCYGrQnnuecOquOldaEZ0/doyAfXn2HSWXamcCxrlKavKxdtXXTJi0OeQNx3MV4WspFsgFPKsjH9MSEi/dsXBke3/ksMTqJGAF6w/J7zNOufjs+nLx6NYaQfhX3dL2KB2Uo4wa7+lfLRTp3CypsEorTT+DPBYf0azhb5hg61YAUxMEB8olseDJUshaWSOIAX0ofAtOv0SDLbX32MUXRNBeRYRsuKwBwg0T7I7Owf0g+ouyQEyGg8jg9yIEFMkXvQGUY8kZl6UfeRyGML2AbsteYoe3HWwFVVXhsKZW2wGFpBW1pj05e2L0HfwZeglE+0BxY0OEGstWhN4jAUcIKUlGZYh5BZQbhIBOO3XcXz2vQfLzY00avArPWRQ2KfJXQ7V4HO+pr7JeY6aQMa0jgPU3x5DHvtc+iwH0SH1WUhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199024)(186009)(1800799009)(38100700002)(86362001)(31696002)(36756003)(31686004)(36916002)(2906002)(53546011)(478600001)(6506007)(54906003)(8936002)(66476007)(6486002)(6666004)(66946007)(4326008)(66556008)(8676002)(83380400001)(6512007)(5660300002)(7416002)(316002)(4744005)(6636002)(110136005)(41300700001)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUhrOGhCQTVUUWwzdnJKd2prOEh3NGNIZUphdm50YklxRkVPR1phZ1g5QWFD?=
 =?utf-8?B?cjRlSUlqMndZSkZQbkVFMFdCQ2dpSUtRY0lORndMS3ZseXV4NTZyREQvai9K?=
 =?utf-8?B?bVdNVGJyMkZ6NFJEWkdDaGpyWkt0OXF2R2pKOVcxZE13aERQZVhmcm15QmFi?=
 =?utf-8?B?SkNyaEY4Nlo0N2pTUFRzTGxxS0xRcXlaTkdOVVFKNGMxbjFjOWZ6emhtMXV1?=
 =?utf-8?B?NklVT2l0TTFPcUJ4cWFtRHB6U0JOWkIycFRUaUR2MnpHdVBQS3MveXJmckFL?=
 =?utf-8?B?ZUl4M3JsTnNhcXBxWnZTbEJCZWRDSFRxMGxIOGUzK2k3N1BLTXpkYWIveU5B?=
 =?utf-8?B?Y3ZjQ0hxRlN0WmZoSEVOU0JiRmVEUGRCYW50cHZPamFvRDVkNUp2b20rQW5N?=
 =?utf-8?B?eVpWRXdaZm5COGY4Ymx1SkgvRk81bThRTmR4VlNXbU8wUFFqZUNCeTFlS1Bn?=
 =?utf-8?B?Y29oNk9ydThxRElpRG5IVVZMZmVYaVVrRDdGdkNEYmJDVVV3WjBaNnBLcnB3?=
 =?utf-8?B?ejJUZXlORzdwMG1OZjhDd3BaazBrSXNnOVBDeTVVYjBQQTAvaUR1R2hrSXpX?=
 =?utf-8?B?ZEZyMDBGQnF0NEQrYXE2dHN5b2M5VmRKaC9jd1hkaFFGU0p4aStVUC9zTHRx?=
 =?utf-8?B?cEtNZWtTOHZES1VwdjNZd0tzY0lLczNQdTB6d2l4U21aMFNCUzd6YkxEa1Rl?=
 =?utf-8?B?UnlMdzFkMjIzclppbm4xTGttZHMzRXcxbDdiTnAxekR6d25IOVRzWmYwQ3R1?=
 =?utf-8?B?aENtejFEaFA1UWVUUkxWVDVlTTZ0Z1hkSm1yZlNsNTNCN2dxM21tcjZiL09L?=
 =?utf-8?B?TWV3YTgzQ29XMmlPYXJ6bmtCbUJNMEo0c1BEaytFMHdPYlNHaDhBS0J5ekxC?=
 =?utf-8?B?Ky9LV0ZFVWpCQ0dOQ3hhRGxHem1Td2MyQ0Z3bEk1QSszZkViWU1tbEkzZlNZ?=
 =?utf-8?B?S0xST3d0c0FzY2dyMkt1aGxUc1VFWWdEUHRnUHBBbnpLZG96OWg2Q20xYk93?=
 =?utf-8?B?VmlQZzJ5QVpxd3lSdkxhbkpDV2oxaTV3WTY5NXpKcnRsMk9QNHorM1VxNlox?=
 =?utf-8?B?bHlDekYzekJJNkZ2OUVDUkI5RTZBWUFwdFV6aERYYWpqbHFldlRRVXRrcGRr?=
 =?utf-8?B?TU11djhhT05kaXB5U0NIaDFqWC9JVkN0TXB1T0VpejY2WWUreHFKRlJNRWpC?=
 =?utf-8?B?S2FxVlNsNGU0VmhuUzNmR3d4MVBwMXNoVHJmK0wwS0FnSHphMHlMSFVsSmJ1?=
 =?utf-8?B?N0NITFArR25iNGJhRkdscVlGdDZ1U0ptb3hBRWFqV1hZZUNFemxpUTJSTk5O?=
 =?utf-8?B?ZUVQcWVZZ2JiZGNMai9KTVVONFRIblNCVnk4MzNiV0RLNENCNlpWM3NvY3lQ?=
 =?utf-8?B?NEhGQllmYmR6cnJNaWo0REVwSUFaVlFwMkxjR3BXR3pjZGNMbzFYMXVrN0c0?=
 =?utf-8?B?OGE3R3Y4bjBYSkoyVDEvNjA3a2RZZEhBRWlXYjVoV0F2L0YzRUtKSUhnV1lj?=
 =?utf-8?B?cHpZVll6LzRuYXVXVFhjNFByU2tNd1ZWcGZ4cXdKUnMvNXl0VW9UaGtTOE54?=
 =?utf-8?B?L1dDeWh6WWx6UkU3WnJMTEc4ZTBkZHB5dnFGblY5NGtNYUtqRE1pbFdXSURG?=
 =?utf-8?B?RXRFQStGWFZvK0xJemh6U3Z1RUovZHdMbFdvRjRWY2ZxZmhKdlRHaWNTSWVo?=
 =?utf-8?B?MFJnTG5JYU5mSzYwLzMwOC81Qmc5N2Z5MDB2NWV2NENITFErTjJnYkJLbXB1?=
 =?utf-8?B?aXQxRUFXMCtSQ0VDU0ZsT0JRVEM1bXRhbHVsS1dKcEFmM1d1NllLdVR4cFp6?=
 =?utf-8?B?L0NDRTVRYm56TEFWcHBaRThxYldBeHFTTEp6WG1FNk5TU0YxMXh1NkFqNlAw?=
 =?utf-8?B?aHE4NEtBOXh1SlBwRCtCbUt6TFRWK2xGdUM1dVRnYXBtWGlUVGNsZ2xhSHpo?=
 =?utf-8?B?SCtqL1owK1dhUXR2M1F0K3E1SDNNMldIck9hYkd6b0RVcDg1THp4RkhaT0dz?=
 =?utf-8?B?UkI4a3JzaHRZcW5iVkxocmJzRHY2LzNtelRjcnVYK3UxelQyMDA0M056VnFr?=
 =?utf-8?B?WjFqbmRZajY3RjhFOVdDVlVBaG9KeGlld1hoSFNKNzZxQyszVCtnNjlnWHFU?=
 =?utf-8?Q?q4sy86wBEVEwZaR9+9KyLojpa?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NVBPWXd0Y3JLOVp5YVhqV3BxbDllWGJjNUQ4VENJMTZ0ZHh5bm1lZS9lVE9W?=
 =?utf-8?B?VWxVSEZJcDRYdUJrWnJwRnBDQVpaY3Z0RVo1QjJ6ekRGcVQvZzJWcFpSZ3VD?=
 =?utf-8?B?MGx4S3NPakpVVGV3QVVHV2hDaS9KRWlLMS9wUXVWVDFnT08xeGlrWnhMWWZD?=
 =?utf-8?B?MGZsQ1J5ODNYNVFrYi80OXlTMm8rN0FFYXJUMmo3K2dEY1cyVjNKeVJIZDlE?=
 =?utf-8?B?aG00elVBL0tLajVlZkhSU0tRdFFjemN4dnlBMjYwdUVNMk56UXkyKzhHcVJh?=
 =?utf-8?B?YnlmMlRGWWZkbkNkWUFkdyt5a2ZpQzE2WDNOMGd2UWpROXlTdFdmd05DeWZt?=
 =?utf-8?B?bTNxT3lJc3padWNiLzFNZWt4WHIxZ3F6OEJPVkN1ZUd5ZkxvdW5nOGdFdVgz?=
 =?utf-8?B?cWwwdWNYV1VMdElRQ1VkYmp6emJQU055am1vY2xKSnB6cDhwZEJyalY1QTRG?=
 =?utf-8?B?M3JudEdiTStVenBIekRDN09LcUZBa05XalpqeXdMY05XY2xrWjVVOS9TUEhH?=
 =?utf-8?B?VFVxRXhFNWFmT0U1RzhYdzZndktUWlI3TFJnZG1xS1RiS2ZvM3lTYmk2Uzhz?=
 =?utf-8?B?RFNTRFZ1cGlVZjNKdlExWElJVmpBcFFLUWdBVlRkTWkyYjNpMkVnZW9IUjhG?=
 =?utf-8?B?cTJEdmxzRHlGSjYyTjNOTFFZZ3dMYms1NlhWY25FMDFxZTE1RXZBVHJYNVo5?=
 =?utf-8?B?WGlaNy84YXI4amVKLzcyUWZwT1haNFM1TzloMWZRWWxtclF2THJKZU1ZRXIx?=
 =?utf-8?B?V1FCd3I4Qm5qS015YVBHQUJXNWxRYnJ3NngxVzY5OEdET2tBSmxwMmVpVlRP?=
 =?utf-8?B?U0dvL21wL1ZVbkRwMkVYUXVaSHFaaEdmTkVEWmhOQmNxYk5sUUUvVkFsUUxZ?=
 =?utf-8?B?dUVkRjExRHYvNVkyRVUrcDhITndRd0tMVVJMUWNsd0c0UFZDMkdFckovSWpV?=
 =?utf-8?B?dEQ2RHB1emFlN1k2K1hucFlHalcrRzlndnlNTFNHalVrQUxNS3o5b1ZHREFL?=
 =?utf-8?B?cDRsOVRjWXJzL3RROW5lbXE0OTQ2c1JDRWozaEhrSVJSektwVVlQSGErQmhC?=
 =?utf-8?B?cnBYK2ppbXRTNlFIMjdEbGtMWjgweTc2by9HdFhWTlArRERIT3UzSmVubWk1?=
 =?utf-8?B?VXY2UjF0d1JxUnVVVFliYWVIVjRvc3JGekZFaVg1ejRPSXEzMWppU05mMmxs?=
 =?utf-8?B?VE1jRklrZi92YVBRcUsxNWZpZkFtaEJmZXRzbnAwSWlZRk9wZzkyZ1FsUUZw?=
 =?utf-8?B?SGVLWVVscnk0amNLL0VmRXptbzdoNU5iRWZXVzBpN3J0UlFLNm10SC9VU0g5?=
 =?utf-8?Q?VQbXiKXLU4aYHwk17vstRk/76OhmyN/Alt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8751335e-5bea-4065-8a07-08dbb9a92789
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2023 07:13:56.9675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bs6h0W+oXcnRf6aHTmwlm0G0/L6TF4Eha/2RmH7JLyGq3eDFm9y74y5VSlv/lYeLbsVQaifjuwC0R13O7Lc6Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7763
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-20_02,2023-09-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309200058
X-Proofpoint-ORIG-GUID: gj6NrT3lLarqhfb4NAmIzh2oa_cJptVb
X-Proofpoint-GUID: gj6NrT3lLarqhfb4NAmIzh2oa_cJptVb
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/09/2023 00:29, Bart Van Assche wrote:
>> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
>> index dc1285351336..5fccec3c1091 100644
>> --- a/drivers/ufs/core/ufshcd.c
>> +++ b/drivers/ufs/core/ufshcd.c
>> @@ -2822,7 +2822,8 @@ static int ufshcd_queuecommand(struct Scsi_Host 
>> *host, struct scsi_cmnd *cmd)
>>           int err = 0;
>>           struct ufs_hw_queue *hwq = NULL;
>> -        WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", 
>> tag);

How is tag < 0 even possible? Indeed, I doubt the tag >= hba->nutrs 
check also, since shost->can_queue is set to hba->nutrs - 
UFSHCD_NUM_RESERVED AFAICS

John

>> +        if (WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag 
>> %d\n", tag))
>> +                return 0;
> 
> As far as I know, a return 0 from a queuecommand means that the request 
> was accepted by LLD.

