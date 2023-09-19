Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEF4CE79A9
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 18:02:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjISSCt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 14:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbjISSCr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 14:02:47 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A792895
        for <linux-scsi@vger.kernel.org>; Tue, 19 Sep 2023 11:02:40 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38JHxQaa005088;
        Tue, 19 Sep 2023 18:02:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=XAURJ19CEu3Q574IPWqhYlH36m2eJS7/Yl82oQmxYNo=;
 b=JfUClE8hKK4p7H6kAkPpPra/v8Zm4a48v2QXnqUz9pnpGS/LwvcUpM8aNNgn9LCIYLmY
 ezblTv25DMXyN5K9U1yxRhwYPsuDFVoTuGgfuPNvY27rWvsezFnpNrcX9xbqBLcy0LU5
 5d2O/AsOFAt9K6SNOhpS2d8E6N+UGKS97b1QSlnw2+m3yBpB65sw+MvFuooMM2B3jIId
 NRPe1qAuFc4sWNzDMzQbRuzQJlXRiebu5Q2QeqKUw+hbWSXSbVR7F1Y2NuDkVJnHiJMd
 FrdMI5INSLsa9guO3x9rkNOg6JrP/efCwAIUGZGiU2NO559Oehs2F95V+KVoJHjTb4nl +A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t539cnn6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Sep 2023 18:02:32 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38JGXvXI030178;
        Tue, 19 Sep 2023 18:02:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t60nhb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Sep 2023 18:02:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3t+DnxAZLCov7o2TX0JyQC3xTZlRbHChhQwbiXxQbLljW3C5cUA12qjI1A1WNqUDosWCJPgTtHlOC1RBlNy2tRrddMUPhOyopjqM6CI0wAHQrctQw1kQVjBsIJbaYtL9QsIx7MS4shU3Ws8zlx+fDfJAzbujgL+5jSmIq3TG27I1pplpTClFc4MlVLdE9SOzYBPE4h7UABSuyvlyaqRKkEfdTtA7mzBdL4WbutQ7XxbLjOFXc7mOv+EJKNqc2ZKdTYtG7hPIJGWry5TIfMEXCCLrOQfnp+n1mOo1jJLBzFtzwSoj282eaGEwT3Og5ap0su7hUFGnWC9auspfy3fzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAURJ19CEu3Q574IPWqhYlH36m2eJS7/Yl82oQmxYNo=;
 b=bGoszDw5AGLeokgp9st4CHy1FBP03eBJe2mAnajGazFZIK7nhCZpfLjCI/yhZnrMRO3azkXhLXhyGrGL3kWQvjOuI1LtvkH24i2JSyrkl8O+UmTqCISOuzlqqvhOxZG7/iI6PiI2v9vZ6RgO6iBK6bjC4jXbtGk5JAaJXMM7bgPp4yhf2o4Ays1XWROcd4WEqRrDTXfTuwQXXtoVbqoLyRiMTIKeHejhEoewdVPirlp8CKz6Whh02AONZTvXn6I5OK99S0S2x11y2qdzgePoRQunb1CwH4oHvCxve2RzTKCgCZK62+m9AwNdEgIrOHHBIJSU15w20RgaBbbRsJlWgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAURJ19CEu3Q574IPWqhYlH36m2eJS7/Yl82oQmxYNo=;
 b=PyJxGJ1LpheguHu61tCVRHrS4Rw7+Hx+cmjSx/w7Yn2CedL6xRFKaVWDjHSw5Bk7Ze2vvc4t8g/OBMjb88bisRa50/G+rCDxGuu6TrRJB7PgHwm1u6cTtvPctafF3Ug1KPvvewUO6/kWsVt0t16SLz3hyFkv92AY7kcsjAKB9w0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DM3PR10MB7946.namprd10.prod.outlook.com (2603:10b6:0:4b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6792.27; Tue, 19 Sep 2023 18:02:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6792.026; Tue, 19 Sep 2023
 18:02:27 +0000
Message-ID: <01c49e22-bc07-4c46-ab54-c2e26dcbca7b@oracle.com>
Date:   Tue, 19 Sep 2023 13:02:25 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 07/34] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
To:     Martin Wilck <mwilck@suse.com>, john.g.garry@oracle.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230905231547.83945-1-michael.christie@oracle.com>
 <20230905231547.83945-8-michael.christie@oracle.com>
 <d3d8bc89e45708cde24912b497348f12c662f45f.camel@suse.com>
 <8d8cdaefa944afd3c478ffb77570cce53f7041c6.camel@suse.com>
 <64399d0e-dacb-4789-b37b-938a5e98eeee@oracle.com>
 <25a0b3bace532c5340196466f8a4194c9b8da473.camel@suse.com>
 <e35f738c-b6d6-4e86-aa29-875b3629a0b7@oracle.com>
 <a4b2b991dbd7f9eef81feb9f6fa09850d0e299e7.camel@suse.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <a4b2b991dbd7f9eef81feb9f6fa09850d0e299e7.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR05CA0058.namprd05.prod.outlook.com
 (2603:10b6:5:335::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DM3PR10MB7946:EE_
X-MS-Office365-Filtering-Correlation-Id: 169fa45c-5c36-41ea-bf5d-08dbb93a957b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5pg+tCAnWPj/GmcMtc1ZcDLItRmUuu9EKL99ijaRV5yQilJKipKyxUjLJavVbNrtZxQRB7hbprTJsEYE50eSgSv9eqo8cC39LeFrFEYFQqib6juZavRA03gJId7pDO3zr91JLxZlWh6uodhmOr2JNki1oIJTJVQ1h7/pqHAkrOjL4aXeDPRMac+vXlVgrTPx+67wnEwigY/Pi0Dvo0mdHxgqv5BXy9CvqU2lB3Dq8lIFqWM8xCPhzSUvaRFM85ZVuUh0tipZGUlVKahadBNFRAskQAc8F5WPjsn+b8wzeljm/SezXA+0wgHSUjLx6ULIEKBd9iP3PnCU5ydMErt55eKMtoWv9LcgJVHuzhip+SRERDPMcjuYIbL8TZQb3lKpgEsaes1Xc0NMWkJTCidxz5hHhey0u0783aUBW5OnGxpSnBBGmMPKwVWumJo0BzRSu/Y+atBMyHZxSovS1YHlVmPeTeoHqLOHv+3Zt+7qQl1OokejUF/CaJZhjrwEE9FKH9gqxyzxLjs5/Lg1yZ9PtqXXnuXYuH//nmXLaQhmB25hWaVAUX23oFWPKws9vCo1sa0U/q798vjWBwcsQqcW9pUN7KsnIn2FvPGelicmmIjMdgLBF1ILDzSLYzR02eztAVH4fPpSzwxcmOT9sSGYdA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(376002)(39860400002)(366004)(1800799009)(186009)(451199024)(26005)(2616005)(6486002)(6506007)(53546011)(6512007)(86362001)(36756003)(31696002)(38100700002)(83380400001)(5660300002)(478600001)(41300700001)(66476007)(66556008)(66946007)(8936002)(8676002)(31686004)(316002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzcrWlFkTTBiVmg4TFRiWEx6YjZjRkJBZTFXT0ozZGp1UGhRSU5XdStHNXQy?=
 =?utf-8?B?V2dOc3N6bHQ5WnppNWQ0YWtjVitnaXhZTVd3RjMzZUM0WUJyaVpPdmw2aExi?=
 =?utf-8?B?RDZVRVJDWmpNWGN2bkg4MXNSdUx1anlBT25VYVBRSzRGeExiUkpKVW5Ydkdl?=
 =?utf-8?B?ZFlrMzNwMkVFaU5KM0ZleXExdkhiN0VKdEpCbE9NamQwQWhWZVVKOE05YjVk?=
 =?utf-8?B?VXVPSzV5TVQvVUpKcnZ3aXNXbTVGSzFoSnpkUjhXQ3MvNzJzbWFXUXRWUUs3?=
 =?utf-8?B?NnpmOGU1dzNLQkI3VWZCWm5rWHZVL3lOWGFYOVJORTI0cVczbWZRRjA2Wmpm?=
 =?utf-8?B?d2xVbjJHc2lrMXlQMkl1V0s1b25RdVloY3J1TEFlRE4xaGx2dWhwemRBempV?=
 =?utf-8?B?NERUMUN0cy9lR0dQZVpMbTdlMXpHZEZnMTQ5N2R4NVB5SUVSYjVsa0Z3VzFE?=
 =?utf-8?B?L2VZODVaYzFsdXNHb0JQRkYrYWYrV0M1dm1sRzJpeFQvc3RzY092cWtGcldo?=
 =?utf-8?B?b05lL1VaUk04bGpxM080R2VlMURZSk5hUkpMWDYycG5id3R2cXpaRUJwU0d3?=
 =?utf-8?B?ZkhCVXc4c0hLYmNSWWlkVWI5YTRYa2J1ZG02amtLc2pFeHRxRTcwNVduNEdx?=
 =?utf-8?B?MUlnRUNoMFJjN1N5dStFV3I4UG1ZazRWbUhCVjcwNUpLb0pBNHhPUHAyQlJP?=
 =?utf-8?B?Z2ZYUjhtRy9XOUxldHR1MVNHZEE0eUhnc0JUT2diNDVnLzJ6WnFLV2xrSmpw?=
 =?utf-8?B?RWVTNXFISmRnN0xUTk4zeGJFWUFwQVp1M3ZJd1NLVFo0SjQxZXRJYVh1Sitl?=
 =?utf-8?B?cUh0YUU4ek00bXpXZDVkNllDRGx3ZWFOK25WM041SittZW9uVjhkRFQ2b2JE?=
 =?utf-8?B?VDZPdG84cWZlRWRvSWRvQlBUY0tvVXlPNWRCRGw5L3NMSC9XTFpIeWJsSDhh?=
 =?utf-8?B?NXhCVlJzcHNiSWsyRmlEWW10NkdsUFpVMnhoRGxUN1U2cGptSTdLQ3QvU3hX?=
 =?utf-8?B?TmZuYXdOUE9iOXdnWE1Rd1ZUNlliWUV5bzNRa1M1QUlOMU9yNjFyR0FFd0ZO?=
 =?utf-8?B?TXRkK0lMY1FZTE1oNS8rRzlhYnZ1OFQwSSswTVo0QWxvMVIxZ0p2aFlpN01x?=
 =?utf-8?B?SHkyOG1ZVVJiQW5GRXFNUW1xN2IrdDJYTWh4ZnRCNm1LRmNIVlVBUGFzWDFh?=
 =?utf-8?B?TEkrdnZvSG5zb094T3NzTzIzbm5aRzNKU1FPUGZxN0RRUmgrUXR6QWVrOGc4?=
 =?utf-8?B?Rk5waW43MXJrTzFva1RLTlR0NnA5NURkamtLOXZWeVl1NEhxeEw1OXpjdWdW?=
 =?utf-8?B?WjdsdmRsMWxHYjZJaGo4OUx1UjRCUGNOWTFqMFcrYk5NTFc2MExUU25oRStI?=
 =?utf-8?B?RkNBSXdpTmR5UXdnUTk0VzRRSVo1U1J4djdJVEIzbnVIcmRmQ3hSdEVVZXRK?=
 =?utf-8?B?UGVqRUp2WjVRQU9MNHk4c3duM2pXcGRUUnZneUszQmNlRnZBaTgyZzl2MkN6?=
 =?utf-8?B?YmN1YlZId1MydTN3RitFZHp0WmVXRXlXUjZUYkM1cDl3NlRuOGE0WG9rZ0x1?=
 =?utf-8?B?aHBqejVaZlZaV2x3aE1pdndkanpDTFVzNFVJaW5SVUh0ZzJOK3F1eFFldjlV?=
 =?utf-8?B?RnJ2MG9jT29rc2Q4ekF3WlNXZVI2SVZMcy9uVUlXNVNsczIxQTMxYThtY1NE?=
 =?utf-8?B?d3NnWisyWEk1aGVpOFE3alRpWU9NUzE1dE9rQkZDYTdJRFExbUNuQk51T0Zo?=
 =?utf-8?B?SURlVHJkTmpDdzlaUjU1eU1pODc0MTBEY1UrU1RlcFdSNDlKNzlkdit5OHNx?=
 =?utf-8?B?djI4RlRLMW82elB2LzFoNm41aGxGUE1henUxWkR2T2dRVGZhblYrK05SNW53?=
 =?utf-8?B?WTM0ejAzUFhWM0FDNERkZ2JyOFo3elFlR2s2WDVuVCs4djdXYVVUU0ZFRC82?=
 =?utf-8?B?MDN3TjhOSi9jalExV2Z0Uyt1MFpxSk45cHZZeGF4R01McERJNEpxNVczMnRn?=
 =?utf-8?B?QW56L2E5aFZuaDZQSlMzbCtscXQ3T3lwWEZCUVJ1cW5HWkZVMWRJaE1YVTJE?=
 =?utf-8?B?T0htYjQzZmlWZ2d4d0FyNnNrV1k5dE1mQ2RHc0dxVGRFb1V3VVk3azVtYlNT?=
 =?utf-8?B?RGdiMmZSbFpJSEZXV05RaXhmZDB1bEVvdEMwV20vNm5IRnFDcW0vZmMyb1o1?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: pyLLmfesuFx0c7gPcdZgHxZCWDlR4pT9nGbaEMBZM2ghX6Ld5ATNNrushPOlkn1RTizKkyVg/Tot78xmTams77X/lGdLdJbCc1OzsVaRsMiSimTzBVxOLrHAqGr8vwSFazSzpjrJPn2ufh+6SoV0y285T80rigJbr2pJ/HOOJ0Y/j6kRiSMEVQUw2qiCeW1HTDSv5IVf9UclIs5DtTGxKwIwiWFRv8u8ef4gmOEbz+UkQ6pd7WEuz/Od78vS1tjAvCHnSUeoScWvJoyvgtndCAwVUl+7J4t6iQ9oMdQ8LmlUEeN/1Rlwjg58USFIToDOKK4qahX6YYR8F1XS20roIWVzjWg8ztvfP7fx8cF3QMTQ+HpCmAZz4EU7cFp0oQPcPPsEe/fHy7vAp6nhdmJ8Bw4xydNg1HZk9y/Dxq905p9t3r1WsLxVej3rr8Mj7Zur4J5Wj+WHshg4q/W2cPzmNcTiaw6UzbhwMedtf6YErQUeaYVTynFxH86R7iNuKt/k5itvKsIL2QWH3qawBNfWjMKlaY8JR9neHSfmlsMTu5JgXIQvKtWG/rN0/k2sTkCaND4hD1Vp2qaryFA/yLe02rogkYDBMRtqHsxS5fXowvTiWd5AA1LkxpSlDn0zNaU+2d58EJBzj6LJnRq11F7mXW7EsS5uDlzQ+zQc2qx4AjVlkDEYGHneD5kxPQZlttVRo82xWoqF8zAvmh86NAH6+kkyeKEcPI+oF/EiqdpK2gY8Mh1ghzho7gidiV9on72FAAhr/lfWkPzfXUtSYQP+MZ3fJPwGoWymnI2dkKj7L2gVtC0tRJTRmmA+9KuCyox9tLfjaXys4oPgvJr6zF5NB1zrKLY2BOPeqP7vY5QRN4lp6yGC3E0sz6u+OMPS3GJi
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169fa45c-5c36-41ea-bf5d-08dbb93a957b
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2023 18:02:27.1609
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u23tQ1ZIhYEDHaWIrwqw+7GC1Lztp5L1JZt0IXACnZ3tT7jGb1fd8xBOXrJ775a3joKloj68MNvhm1+aL41y9e0PxoY2MII8KbyCtMXOMPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7946
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-19_09,2023-09-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309190154
X-Proofpoint-ORIG-GUID: lhV0IGmeyBu7VGJO49kesPW9QyNB7_c7
X-Proofpoint-GUID: lhV0IGmeyBu7VGJO49kesPW9QyNB7_c7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/19/23 4:07 AM, Martin Wilck wrote:
> On Mon, 2023-09-18 at 13:45 -0500, Mike Christie wrote:
>> On 9/18/23 11:48 AM, Martin Wilck wrote:
>>> On Sun, 2023-09-17 at 19:35 -0500, Mike Christie wrote:
>>>> On 9/15/23 4:34 PM, Martin Wilck wrote:
>>>>> On Fri, 2023-09-15 at 22:21 +0200, Martin Wilck wrote:
>>>>>> On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
>>>>>>> This has read_capacity_16 have scsi-ml retry errors instead
>>>>>>> of
>>>>>>> driving
>>>>>>> them itself.
>>>>>>>
>>>>>>> There are 2 behavior changes with this patch:
>>>>>>> 1. There is one behavior change where we no longer retry
>>>>>>> when
>>>>>>> scsi_execute_cmd returns < 0, but we should be ok. We don't
>>>>>>> need to
>>>>>>> retry
>>>>>>> for failures like the queue being removed, and for the case
>>>>>>> where
>>>>>>> there
>>>>>>> are no tags/reqs since the block layer waits/retries for
>>>>>>> us.
>>>>>>> For
>>>>>>> possible
>>>>>>> memory allocation failures from blk_rq_map_kern we use
>>>>>>> GFP_NOIO, so
>>>>>>> retrying will probably not help.
>>>>>>> 2. For the specific UAs we checked for and retried, we
>>>>>>> would
>>>>>>> get
>>>>>>> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever
>>>>>>> retries
>>>>>>> were
>>>>>>> left
>>>>>>> from the loop's retries. Each UA now gets
>>>>>>> READ_CAPACITY_RETRIES_ON_RESET
>>>>>>> reties, and the other errors (not including medium not
>>>>>>> present)
>>>>>>> get
>>>>>>> up
>>>>>>> to 3 retries.
>>>>>>
>>>>>> This is ok, but - just a thought - would it make sense to add
>>>>>> a
>>>>>> field
>>>>>> for maximum total retry count (summed over all failures)?
>>>>>> That
>>>>>> would
>>>>>> allow us to minimize behavior changes also in other cases.
>>>>>
>>>>> Could we perhaps use scmd->allowed for this purpose?
>>>>>
>>>>> I noted that several callers of scsi_execute_cmd() in your
>>>>> patch
>>>>> set
>>>>> set the allowed parameter, e.g. to sdkp->max_retries in 07/34.
>>>>> But allowed doesn't seem to be used at all in the passthrough
>>>>> case,
>>>>
>>>> I think scmd->allowed is still used for errors that don't hit the
>>>> check_type goto in scsi_no_retry_cmd.
>>>>
>>>> If the user sets up scsi failures for only UAs, and we got a
>>>> DID_TRANSPORT_DISRUPTED then we we do scsi_cmd_retry_allowed
>>>> which
>>>> checks scmd->allowed.
>>>>
>>>> In scsi_noretry_cmd we then hit the:
>>>>
>>>>         if (!scsi_status_is_check_condition(scmd->result))
>>>>                 return false;
>>>>
>>>> and will retry.
>>>
>>> Right. But that's pretty confusing. Actually, I am confused about
>>> some
>>> other things as well. 
>>>
>>> I apologize for taking a step back and asking some more questions
>>> and
>>> presenting some more thoughts about your patch set as a whole.
>>>
>>> For passthrough commands, the simplified logic is now:
>>>
>>> scsi_decide_disposition() 
>>> {
>>>          if (!scsi_device_online)
>>>                 return SUCCESS;
>>>          if ((rtn = scsi_check_passthrough(scmd)) !=
>>> SCSI_RETURN_NOT_HANDLED)
>>>                 return rtn;
>>>
>>>          /* handle host byte for regular commands, 
>>>             may return SUCESS, NEEDS_RETRY/ADD_TO_MLQUEUE, 
>>>             FAILED, fall through, or jump to maybe_retry */
>>>
>>>          /* handle status byte for regular commands, likewise */
>>>           
>>>  maybe_retry: /* [2] */
>>>          if (scsi_cmd_retry_allowed(scmd) &&
>>> !scsi_noretry_cmd(scmd))
>>>                 return NEEDS_RETRY;
>>>          else
>>>                 return SUCCESS;
>>> }
>>>
>>> where scsi_noretry_cmd() has special treatment for passthrough
>>> commands
>>> in certain cases (DID_TIME_OUT and CHECK_CONDITION).
>>>
>>> Because you put the call to scsi_check_passthrough() before the
>>> standard checks, some retries that the mid layer used to do will
>>> now
>>> not be done if scsi_check_passthrough() returns SUCCESS. Also,
>>
>> Yeah, I did that on purpose to give scsi_execute_cmd more control
>> over
>> whether to retry or not. I think you are looking at this more like
>> we want to be able to retry when scsi-ml decided not to.
> 
> I am not saying that giving the failure checks more control is wrong; I
> lack experience to judge that. I was just pointing out a change in
> behavior that wasn't obvious to me from the outset. IOW, I'd appreciate
> a clear separation between the  formal change that moves failure
> treatment for passthrough commands into the mid layer, and the semantic
> changes regarding the ordering and precedence of the various cases in
> scsi_decide_disposition().

Yeah, agree now. The email is a mess because I wrote that below. I
should have written that here to save you time :)


> 
>> For example, I was thinking multipath related code like the scsi_dh
>> handlers
>> would want to fail for cases scsi-ml was currently retrying. Right
>> now they
>> are setting REQ_FAILFAST_TRANSPORT but for most drivers that's not
>> doing what
>> they think it does. Only DID_BUS_BUSY fast fails and I think the
>> scsi_dh
>> failover code wants other errors like DID_TRANSPORT_DISRUPTED to fail
>> so the
>> caller can decide based on something like the dm-multipath pg
>> retries.
> 
> This makes sense for device handlers, but not so much for other
> callers. Do we need to discuss a separate approach for commands sent by
> device handlers?
> 
> Current device handlers have been written with the standard ML retry
> handling in mind. The device handler changes in your patch set apply to
> special CHECK CONDITION situations. These checks are executed before
> the host byte checks in scsi_decide_disposition(). It's not obvious
> from the code that none of these conditions can trigger if the host
> byte is set [1], which would seem wrong. Perhaps we need separate
> scsi_check_passthrough() handlers for host byte and status byte?

I think we are talking about different things. I can do what you want
first then go for the behavior change later. We can discuss that later.
The second/other patchset will be smaller so it will be easier to
discuss.


Snip the chunk below because I agree with you.

And for the total retry issue, since I'm going to try and keep the
existing behavior as much as possible, I'll add code for that. It
will be easier to discuss code then.
