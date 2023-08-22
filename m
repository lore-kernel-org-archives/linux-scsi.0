Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D50EE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 16:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237712AbjHVQ0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 12:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237726AbjHVQ0Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 12:26:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FB1196
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 09:26:10 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37MFnh4b009390;
        Tue, 22 Aug 2023 16:25:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Aua/TPFR4yMugTh/B+oX9JWoMCkc0/ntiRlzFGPNuic=;
 b=TiqhZeQKXOyJ+MYwZZoMfVy7KSXJM0oWWMm5Cr20wTBJOdJV4lPT5ucnnMVvRCUFTFwl
 jPqoyR8cWPnzDN6ison0yLuQM6ZzEXJAZstrPQ4u+TSLn0AmvPMx5FbcPNftFy6P0wK7
 gQY4ISsf013VPjQo1oSfl4Y0Lr0cCQYPc413VBcmin67svVWZVZJTOJA2muH08lb7UXg
 y6QpUmvvyxrOr7nL39oZuT4mdWZ83HmdmP59d9xeo2of6XMGJ8C/rdZU+cFUuuv89X5+
 M57evCXsYDse412krbseE6hf8Oc5KgII1b9GmlDn84tzI5HHuuFVAkY0We/O/7eFIw8w 0A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sjmh3dtw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 16:25:00 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37MF52Xg020162;
        Tue, 22 Aug 2023 16:25:00 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sjm654yyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Aug 2023 16:25:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tz7c6dN33XZ0RpzWa41XGXm6LOvqdVN3aenz79Nlv/+/ES03E2WBgyP/cVMHdRkGIjZKgu98DZ+qpbwBodk6hq/cC1y2LQZ8eJ8eiq1KOIU9azhNNktWyAwkstrJwFhOYfm81Gi6SV4HEVlJHjxjOTab7kMjYTWoEr2+7JKPOOrF1Coj4pnwtHH2Upe2MLpC/i+IpKezfsvBnSLGmmOuJXND4BlGtJGo5h0tdrYmaarVDWg+5prSC+4t7Qtjr9lGkt/wbVoRnm/sGH8R12fJ/9uiUqgv4xyQYtxwhyWsXfaf3oKSXMRx0+pCkGVyJhmpgPzKXmMHlCauxStpsxXrEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aua/TPFR4yMugTh/B+oX9JWoMCkc0/ntiRlzFGPNuic=;
 b=QE5Ix4Ts0oMb64W18oQXetJNKD/6NepUygG4JIhyEnoDGAKSfnC1qQhMFTeAfrSDqHnibU559C5d8JjNhK3HxWDcfnF33jXRifmlzC7UPPyWT4VXPPbuVkutu8mIJiBLo2o6r95alsXE8gC2ZbVuhN9EeIphOaTNEEl66j5xxzDIOyJh5eIr9Fw0XDWo+Fp/p8lTQrpdHu0X1y3uGYsylllCR49ijMk4MsOFBWeSDHdqBwKdE4DXRwYvwftAa28KZTAmrnoKaCkml2VArVNji2SKPjo5fin81zGVgP1TCE+IGvYA+eHMU3kVrw7vJ6PyHl1+yeEdfgyvHoqMy0+3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aua/TPFR4yMugTh/B+oX9JWoMCkc0/ntiRlzFGPNuic=;
 b=csRNbZ1c8cVXhX6PYlBZEoVJoNkEDUUOoQ8IebRMG5dXDbV31ExHNophM3RNvh+JoqGa6CUG5QmxTdkjrRXV3SmT1OTGwICSd5vXImCAihkYfognPkfCHsIDi9yJ75lgSIlbfIqrx3iNOOtVvNUGYz/v3k+aXWKDmdZWDVXDhPo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA2PR10MB4732.namprd10.prod.outlook.com (2603:10b6:806:fa::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Tue, 22 Aug
 2023 16:24:58 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6699.022; Tue, 22 Aug 2023
 16:24:58 +0000
Message-ID: <2f74af74-9311-d4ab-ff06-2ab805c1806d@oracle.com>
Date:   Tue, 22 Aug 2023 17:24:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH] scsi: core: Report error list information in debugfs
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Mike Christie <michael.christie@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230821204101.3601799-1-bvanassche@acm.org>
 <36f46807-2cc0-1efd-b900-54bcaa0cba15@oracle.com>
 <9c32fc0f-b14e-9f7d-7ebc-11c0710d6365@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <9c32fc0f-b14e-9f7d-7ebc-11c0710d6365@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0038.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA2PR10MB4732:EE_
X-MS-Office365-Filtering-Correlation-Id: 47ec02b8-023e-4765-6f63-08dba32c5380
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uK0sTdUTZ48wCLUCYz//6EX7fRFhUs15ZQZ0EWXfpeSQMuCdDxnw+gMeQmaAbUCigKHDLbOlKVpVNHIK4ptx2F+ThA42Mpurv3Nt+y22MGriirQsfn7qh4qXsrcQkmM9Q9OtxkNI/Ic36TofUphr/0iwt2SJ4FJDTTKpV+1L9xk6Aj79vP8wfpR0sAnDq/VuHwMqH7WXfoeDUXontEhcHAqsPFoxjEYe5bQZPfUtPtAx0f7ZrQh5KyLdwBzc1/XevkyUOJKzUE9AYYKOSH21SVDJIcIyrnwexacyvVLd8YVlOLTuLJZyQQpLHdYx7S0Zg1P72e6LThVQUlPByZ8YAptkwIYP8CytaeQH3IpKG6pEjhoALkqHh4jG5rNmcV6xQFEzRpoWDRoo4aC2LWJ3XeAIA9OFUsh9GR0EAypGJZtPiLgMm99xpQDRyG0XDT1QfODvBb0ODv96Exmn+sJtjfvxLSKz9DD76pY51/K23IlT+GBYOaTxKiNNu0w0VvpWp2w97gFmajkfW++trtAJ7IuNJXBhXnDF9QTTajkFaUcsWFCeeuRdZ7a6WVrZASEtG9VhZJAaLGZj5XVK3yeVinamd6BssuZ8tgpBkzdaOh3oq2pvVa169GT6VqSn7iao6MJs8h6XdPY6GqQc6E/FyA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199024)(186009)(1800799009)(2906002)(83380400001)(6506007)(6486002)(36916002)(38100700002)(53546011)(5660300002)(26005)(31696002)(86362001)(31686004)(8676002)(8936002)(2616005)(4326008)(6636002)(66476007)(316002)(6512007)(54906003)(66946007)(66556008)(110136005)(478600001)(6666004)(36756003)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjQvZ2NidW5lT1lldnBBVGE0RXhDaStzbmEyaVdSUk9DYld0bGZIWkJrU0s1?=
 =?utf-8?B?ZWc3bWlNblI5K2NCcklvOUt4ZVA1STRhUzJJYlBOYnNwNlVBcXZBMmZuRG5n?=
 =?utf-8?B?MDhpdEMxZ2lUNHU3ZTIwMXVPVm1EeTBwWndGb3RKMVFvL2FMTGFGdlFKRlpq?=
 =?utf-8?B?R3NNa3NNMGk4dHZEdU44SWdhc2pIR2NrL2oxNDQ4K1BwdklMMER4WVRTWm9H?=
 =?utf-8?B?WnZldWF4T0JBbklWaWdQcmpldlJNQzlGNmpzcmFtQVJLN1pVSzlqZGVnTXlw?=
 =?utf-8?B?c0VYbW5vMUEzTEQ0M3d0Y05JUmhUK0l0d013aGt0WHlmWTBkcEVWb2tnenlU?=
 =?utf-8?B?a3dLSUNPSnpneWwwYXNqbjV5eWY5czJleVZnTkR1M2ZFSlAzaytJQUhtYWdC?=
 =?utf-8?B?bVd2MCtjWm1McDlxWkhNWDdtdEVQZi96TVlIdlV5MTZ2aDcvU3dISWIzUFFv?=
 =?utf-8?B?c3JtRkZaU2ZiR0M4VzQrQ2xZRm1jYWgwWENzM2RlbjFNWVluVnRIdGFMWXY4?=
 =?utf-8?B?MzNXbjhwc25pWmQ2NjVtYkROUW52bWxLT1JKUlFFNWsxZEJIdUZGRUdwS2Rp?=
 =?utf-8?B?YmY2cGI5aDdlRXpYVzRSUWQveXZqc2dhZDNBcjhiVW5lUjcyanJOZEV4TW9z?=
 =?utf-8?B?UXdaOHVRRmJaNWdUTy8zNXY4c0RBeERGTVRFRXlGcWpMUWtmUjMzZnBQeVNC?=
 =?utf-8?B?T1JzLzVZRURzYndCNFhRT0NyaGhYZnFPWG14L1MvUVdPZ0hnMzhZYWV4VmRu?=
 =?utf-8?B?SnhHSE1CZ0FFdWZQSkNoUE84eVI3L1NMdkR4d2JTUC9rQjJLN0pJelpZWWNS?=
 =?utf-8?B?bWtVSHdBMDRCS2U3NDFwSldmU0JnQnh5VXVRcERUNXhOYWNNa1VoUWhMd1ht?=
 =?utf-8?B?bTFaOVBVZXp1RVNPRkRyeUhnaktoZEh2OUV6MTVrT0kyYmZ4b01qZWlaNkxP?=
 =?utf-8?B?ZEFBeHlqSGtpd2phM2RURlJQdldkRDdtSktpSWhpSFhvU3JGMUVmV1BoQnkw?=
 =?utf-8?B?alNiZUozempuejRIQUhJcTY1ajM5czNLME91cGVKOHNOWEFEY1BaQWNDK1Bx?=
 =?utf-8?B?RWREOUVocEtoYmdna2RuOUR6eUY3bWRmV2c2aWxJbnpPWm5Wc3lGUWJvQWtk?=
 =?utf-8?B?d2FjRmxmcDlPaWxzWUhkbHFRYWcwQlpwOW5RcnBmdTZYa3pKQTFGalNML2tU?=
 =?utf-8?B?QmZjRUJBeHllYlUyVERPOTdLckIxTDMwSVBXTW9IWjEwK25QSjE0a3R0aVNn?=
 =?utf-8?B?WDcrNFU1cHpaMFJIUnhTZWhhamUzc3RnZkVjZkVkMGtzbHBGTU1LTnZ6SHo1?=
 =?utf-8?B?ZVpNUzM3MXE3YU8rcjhjaVg4b1FXMWNKTjY1QkVaU1JISXZNL2pVbHNVTUxG?=
 =?utf-8?B?aTRuT2tjNEYxaXR2SlY2cGljNGQ3THFvOHNacmEvaGNpNjdDaTNraTIrQTVM?=
 =?utf-8?B?aUttMDY5QWJvL3VBOXp1QlJuTERoQWVOWUg2UUNkeTc2SlNTQVpxei83ZmJQ?=
 =?utf-8?B?Q1daa2VoTnRVaURSeTI2MHB2YUhESndPSW5IbjMrc3ZVTHFkN1pSS0VmMU0z?=
 =?utf-8?B?TWg3MlNsU0tUYWR6cnp5czRCYzRBeWt6T1QzRE45QVBaSS9ZTm1ST3Nib3hy?=
 =?utf-8?B?QTJZYWQrdVBieE9lUng0cmpmWnF1bFJzM0syazVxNDZIcnB5aVRXZzQweklB?=
 =?utf-8?B?UGNWb1pmMndOdXkrUDZ4MGRMa3lDMVBqcGlyMXBkNGpmTUlRa3dBa081dVk3?=
 =?utf-8?B?eE5maWJNUzl3bUFCZE9JeUpSL2JHMFhPcHY5MGtGNi9ycktKSkxFS2h1V0R1?=
 =?utf-8?B?VXN3dzc2TnpFZXFxblA4VmtsUlZLQU42Y29xSVNyUVhkUlJPeE5OZXF3eUlF?=
 =?utf-8?B?UjlseTd4R29nK1lORG5zbi8ydDNhdTR4WndIVUkzT2NIc2t0THljUUlGZmNS?=
 =?utf-8?B?YXZhd05CMFRsVUZNb0YzYU54Y2t6UkNvdXNRcWk5TTZGdVdmVWI3NERwVERC?=
 =?utf-8?B?Y05SakxJZjZ3ZEV6ZEtZZ1NnMUFvRmZuaEMzaWMwU2Jhek1hL2ttVllYRkpQ?=
 =?utf-8?B?YzZDaE9yRDE4ZVJ5WU02dEZDSU9YUDlDNnRVeXRZMURmbU0rc1dpWm5hUTNy?=
 =?utf-8?B?U0ZIei9meExyRFJpQ1R2dVN4WHRKazFDQU5kMzJKbXE4R2k3cVEreVdpODVF?=
 =?utf-8?B?SkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: LYiKVhiWkBB80jJ0t9g3YbuaBFj8xfsnjyOUNlR4XFFjknLh+WUBOJH+m4prXZmfa2uAA4YD7zbxKr2dDSsExCXW2c8lLCJNOaS9rSUBahXQmCGjNaWwOndk2NUWvfa/pmE4EglT2ueVyE+odhUh/+GugrnH9RpF16rmaVywQ2o0S+S+M0pp0M26n81dRyHDgDch5LS6tGXHDATpvLGZOtitxT3dVsVtFj1lltCTMg8D55YdLe6Ya858SfrQ2UiVzgF9eLCqqNfXVl4Dd1HG53sDW951bDYx7d4NFkKWRMkp1Pj+xeGZjCGtFcG3TosJsCzS7FYESDHTVcc5Yo2xqeljc5mqozkzWH86EsjTF2hJ9VX20Z/hLGX6rowoxR/AYEZ1Px5UEmnPiM3d3jnnxTpL+xiOLZqgy5b6suu4LSuFYBRqlwViApACZijd7YH5qZjHNQwZQ7xUPub0ytQH9GMhbGwof9FefvWO3FTgyfyDZ1zfW49j8HhN6HIS69HXOYOVJBCp0tuj9mM17luYXqtWSE1J1N4dK87/XwqWyBJleI0R4a1LZsENNZD8hHghmBn9Tib8jhcNJEqs1yNEftANGG1wnZI86lpYBg+lF92LUyqBckQ2kXWHrI3z2AAqyGOI96q5xbcldZ+j/UW4Va9VPDAXkTMMkFBC0k+8qsgYHMW1N++0hXDj8zt32gBFuMEXpudJEaV03FP+BGxFGyiTopWnMxgRBokjsjPR+iVzIS8uNmt9UJx8LSKeQb08AeQ6I+EICRydfD7lelABapaezZtxnHWIJrnUhDskuqo3aWiZX76UidXqiVLrHaE8aph/JZi2Ff4BNqt2rOZrrsmRhHJcBfn1L+8UdzSVUq+dRBYay9QSXuqNAsVlHH40z4iOTYvAeRPkrzypUChhGtD9A/u0/SKLLdgr/C5o5R4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47ec02b8-023e-4765-6f63-08dba32c5380
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2023 16:24:58.0147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdS7GCPPWC2g8+AQe8tXt/jRm9c86F69wLC2cv7UgXIBUhN2vLnpq+znXQPKnUKTFd9jYmqOHyzNiEsPyncV3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4732
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-22_13,2023-08-22_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308220128
X-Proofpoint-ORIG-GUID: 3Y58K8XuAl0I252IV1Vft2clH78kGGmi
X-Proofpoint-GUID: 3Y58K8XuAl0I252IV1Vft2clH78kGGmi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/08/2023 16:25, Bart Van Assche wrote:
> On 8/22/23 02:04, John Garry wrote:
>> If it's on the first list, then there is not much point in checking 
>> this list.
>> It might be even worth checking list_empty(&cmd->eh_entry) initially 
>> also to
>> save the bother.
>>
>> Having said all this, adding those checks will add lots of unpleasant 
>> indentation...
> 
> Since the above code is only used to export information through debugfs 
> I don't
> think that it should be optimized heavily? 

To me it's not really a matter of having the code optimized, but more 
about having clear and efficient code.

> Anyway, how about combining the
> (untested) patch below with the above patch?
> 
> diff --git a/drivers/scsi/scsi_debugfs.c b/drivers/scsi/scsi_debugfs.c
> index a9bc5f7ce745..f795848b316c 100644
> --- a/drivers/scsi/scsi_debugfs.c
> +++ b/drivers/scsi/scsi_debugfs.c
> @@ -45,15 +45,16 @@ void scsi_show_rq(struct seq_file *m, struct request 
> *rq)
>       list_for_each_entry(cmd2, &shost->eh_abort_list, eh_entry) {
>           if (cmd == cmd2) {
>               list_info = "on eh_abort_list";
> -            break;
> +            goto unlock;
>           }
>       }
>       list_for_each_entry(cmd2, &shost->eh_cmd_q, eh_entry) {
>           if (cmd == cmd2) {
>               list_info = "on eh_cmd_q";
> -            break;
> +            goto unlock;
>           }
>       }

I think that list_info could be set to NULL here, rather than when declared.

> +unlock:
>       spin_unlock_irq(shost->host_lock);
> 
>       __scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd->cmd_len);

Regardless of comment, above:
Reviewed-by: John Garry <john.g.garry@oracle.com>

thanks
