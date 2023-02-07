Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60877C636CD
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Feb 2023 08:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjBGIgW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Feb 2023 03:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjBGIgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2023 03:36:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAD22E814
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2023 00:36:20 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3177nZbo011822;
        Tue, 7 Feb 2023 08:30:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=HcNA6wNFn9COUNujSZzHZuXDej9bmsquFEQWUKyieJg=;
 b=n3ibXYSa2xgSzH6dH46QDANaG3X1iLFYzu6MkbaLPzh2ZvcgjAccuwkNn+L8fkdlGZOc
 FBpvnq7WJ/TpQhSaR/WPvtnT/R89BKBmBeRSUkzeEY/W35BeiochWfSrX2cnz1Q2vvmj
 Zn4qBCit2hMSAF9JJCo45un4AExukf+/PcY3Odn3aYhNplS3mA1ZE4Dm41scHijJW0iw
 KnWagydactqSHsfDxM2G1mdiZpDGKATGGVotWJczrH0NrRM+AtZkrHxgrE52Zv2Q+3XY
 OsfFmk2G+ISq0HPd5czBeusne1dr7aSGbVuEhi7U8vR3bCNcdTZau3J5WxpHExvP8ENE Aw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdsdmxqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Feb 2023 08:30:59 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31777gfl001157;
        Tue, 7 Feb 2023 08:30:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtca8xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Feb 2023 08:30:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+2DYIZVFzFod1h8yCcSdnR1YrKlSOMdRRcetSxK0F2k+Y3sB/yLTVXvW7iFyZPYjf5p1VaV949W4JsQi1GE7mm8l+EW218kgSnVp8NirsXRhGVFpSmbBN3p+f5S+iEW2PXB5NuCmBdOJ65A2DqAbeE11AaRNTsK3Mzpxr899L+XRC+3/4MziJvkdUEK4aXbfbBsV9QQmBmeCdH4lYQjSVzzRJEF1yPM919YBjk32gH1M1l1yGBvfJMbBEjkzDpZqmH4xQRvNEvxCO1y/cvvVKBC2mzoTHuOSQkVCGeZZplW/J3ePIrGErL1NTbSHSu23u+Hzdd6UPx2xCbsj7laXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcNA6wNFn9COUNujSZzHZuXDej9bmsquFEQWUKyieJg=;
 b=RPpE62ycfIUmRrJa29A7w6zKGhaUaPtU1wQUmBJqN6cRkWjv4NbE3L/2fe2VaWlBq1wv6r5SgaB2qpHtL8V39R8MjZjTzoZvBqE0Z2JH4T0apKqII+3xHYTxpaz4x4jza2qv1GnfhBnaN/R2aBB3wc86N47aCx0D63w2jM3/YTlWWYn3yRr8oYcFnxKmFtWaofjyDtfE1tJ8xJhSdY1UVeeK2ZiIP85kwsE+x5G/RW0Qt5+B7AabbH57O5m+gdriVJxD8ID163UtFfqRSg56yPPnE0BI1IbYY3ZVIKN1WWKcF6FkQAZ9udp9dQb3UvRUbWp9H3YUa8ozJ1rwWA9K8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcNA6wNFn9COUNujSZzHZuXDej9bmsquFEQWUKyieJg=;
 b=Eyernrl7azCR5SqsgBC/FfBrWzUvenXaG08LxylO0HYbEKnh8At8uxT9Nk6OlDw1BLCeAAWGCJtnO0bSAENqYbodQBJ3+8gq9eZdyhzBwju0wFDZpjxZTGZaCGkpuLRTz41ygvTHSXy2Hibcakie0H9iJX6AzG/zCCVsVN5p2Xg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH2PR10MB4296.namprd10.prod.outlook.com (2603:10b6:610:7a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.7; Tue, 7 Feb
 2023 08:30:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%8]) with mapi id 15.20.6086.007; Tue, 7 Feb 2023
 08:30:56 +0000
Message-ID: <cbdfa5e2-1b5b-2515-22d7-b285a0179855@oracle.com>
Date:   Tue, 7 Feb 2023 08:30:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 1/2] scsi: core: Extend struct scsi_exec_args
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230202220412.561487-1-bvanassche@acm.org>
 <20230202220412.561487-2-bvanassche@acm.org>
 <a81cb9bc-246b-1b82-fcc6-37bfb5829bab@oracle.com>
 <bc1183a8-e4fa-20c6-0508-ec36d395a20d@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <bc1183a8-e4fa-20c6-0508-ec36d395a20d@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0671.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::11) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH2PR10MB4296:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a0cf509-acc5-4de0-83f9-08db08e5a225
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HRLBlTag+GxekG40sgA+xu9qiICidKLZzMu6VCyS66zu6kLdP4wS2Vf2/PC1SE1rqF/5TWGj3rnjnTEIOXRecponrS/RDF+NTMp9GvUVeI/DPFFFnsa3RbXUd/gHU3EoK1RRb7KBIa/kdGdqNUHVFYXKGTQkubAEnrY1K8Uz1OWv5SM6FNT8t0iFHVToGjowVuMW7RNv+Qi5kY/yXp5Lp4A/xb3kh3Uccy0n88r5W0dPue3XOhLTUNv/KNbiqLA9yNiIZPK1IK+ZCMS4PBMIddb+7PgiWJOi3TLWLJd4Wr5+rhIeQnBVrPsljEchxhuXBLmRCC3tFdkAzBy0eBUGIkrqDWBrh0DNrsj48ZcahpzU5Bou7mSNxv7lrR/PCzna8v8nRgtbzguNbW+7DCaP5mROem5Bx1i0CLAbDT8mNTgBqy6sQYALJYSZzwp58SDuL/Og2FLaljrW7wa0kf97OFuklh4jKHpXmumru2r1+Kpnvm+WGuzJ7u46SnqOpHZdwbbno+miak0Kf3mFHg/umu7BlsfqSKh5zs7pmed45k2Nb/8nF+HMeC+Ucosbcl4FrH7fBGH3QBurASDMmzbcsnVsQ/FC9c3s3nPIdtjSf3ABlqWHDk62HOBNLgzTOXQwIwkDNUC3KFZnPNt1OW3y/ufvRybkTlF+RAj5R2xXSr1kO4U7Ho7ky5o0POj6n5NLIXcDYVVfY3ngxQejDvAtWxDQDl1CnjcFNSK7FisHCmI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199018)(4744005)(83380400001)(8936002)(6636002)(54906003)(110136005)(38100700002)(2906002)(5660300002)(31686004)(6666004)(41300700001)(6486002)(2616005)(66556008)(53546011)(6506007)(316002)(6512007)(31696002)(36916002)(4326008)(26005)(86362001)(478600001)(66946007)(36756003)(186003)(8676002)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTNxZXY2Tk9sWlB3RU54Ymt5ZzhOS3BucVVTckhFOGgyeTdKcEdsQ1Y4Y0dI?=
 =?utf-8?B?RUJxVDFpZ1EzUUVLZWN1SUNlYUw3dnFkRTFCK1htR25DMUdVc01YMVpUMmND?=
 =?utf-8?B?cTd1d0hBcXkxdFI3ZFlCampGSld6Wk5UVUNIOWRLQXk4N0pjZnloV3NVNzNQ?=
 =?utf-8?B?bWIrK2x3ZnVJSGg1RmxjMjFHZm9rem9rdkhyQ1JGVXVNdlpVdWFsNUNRWllv?=
 =?utf-8?B?WkVrNnowRlFDYkUzUXBWTmdWM2NuT3lMaWVkS1RwWkJNNE5nSXlFUm4vSXBY?=
 =?utf-8?B?cTJtNEphbjUyVlkySjRTTUFaMmJHUGx3eEd2Q0h5bEpBeWVHeXQzZmxCbDAx?=
 =?utf-8?B?SHdJRllHVmIyTVY0cUhXRUNreFRyaFlhd09GWWhuVjdSTjdINlhucnE5SjlJ?=
 =?utf-8?B?UlpucFgzS1ByZjJtQnZJazV3YTNkM1JTa1I4VzRpc1llU2hsdW02L3IyVlEr?=
 =?utf-8?B?K29LSDdseUVzRkhuN1FSUW4xa29CS25GREozcCt0V0VQYUxCNFZWWTF0RDRR?=
 =?utf-8?B?WkNuaHNKbEtTaTZnaERneS81WnFlL29xRWE3bjR4cFZxcndjeEMxWHRIbDRN?=
 =?utf-8?B?L01oRUVqdnhaTlpPdmZ6OE5LemxNbzl5N0dGWjl3ditCL09hQWZBbzE0cnhE?=
 =?utf-8?B?Z29WNXdZZnI0ejFNRE4vb2wxdFhOWE9lT3lsM2tOWEFHeWRKQVpwVXROQ1pi?=
 =?utf-8?B?enZySHR3WElia2NDdk9rN0dmY0NLUUJaUjNFWFhFbXZTNDhFa2FyYzVnWDFj?=
 =?utf-8?B?ZllqOVFtdVNlcHVkWjJIYkxkYy84djZwbHFpK1p3Wmt3NVlldFRuNXg3YW9s?=
 =?utf-8?B?VkhDeU5jQlgzV2NOWnFLS0FJOG5mNW4vZTB4S1FVbmVERVZOYXlFN0F6WmdN?=
 =?utf-8?B?cEZTSlZYMDhGRGZUTXZkSHEzWlNxWGY1Z2FCdW0xZkViRW85ajdNczUvT3Rk?=
 =?utf-8?B?YUxYVEg4bUFsRndsMXVpbGErd2cxblVRMmZUcHAySWlqT2RtQzhBdTV5SEtk?=
 =?utf-8?B?WnlSdFNHMzdxd0ZGdk1LMmRTVEs4b2psSklDSU5wMFFpYXRwSjd2ZEc0Kzh4?=
 =?utf-8?B?L1JpUmJaU0xrYjAxR0s5Tmk5Yk05Vmdia2lGY1ZyVWVwbERXQkpOQWdqVGMr?=
 =?utf-8?B?K3JCZExvRlNzbUxtYzV5R1I1K2FQZnpDWFRQZTVGaUl0M0gxYTNJa1BkTjJq?=
 =?utf-8?B?aXpGZnhZdUJPc1NwZnErdjcvWDNXcFFuMVU3bloySWlCNlFrdTFjcTRLbHFr?=
 =?utf-8?B?SGY0MExSZzVjTTJSRTdnMXVxQXllZmNmZlFCQm1XNDZOQW5GcWxYUmNwNzJG?=
 =?utf-8?B?RlpmbTJPR2FDTlVIMUp6SEZHaHRFaHNkTDl0dy9lbnZaY3RXeDlVd2k5bWlK?=
 =?utf-8?B?aDJmQ0JqQWExQ0VNUGVDMmZydmZZRjNJZUVwcTAySFlEeXYzOE5xT1hZV051?=
 =?utf-8?B?dG1MZk0zc2d3RmhGNDVMMkE2RGV5SE9UWElIMERnMVAxc05PMUtEN0FyUlV1?=
 =?utf-8?B?cVRUVkVzNVZBcStmZmxZT3Q0OVViYlVCcXBsbU0rYnl1MnYrUmZlaWpiSk84?=
 =?utf-8?B?NjhMeTFvb1R3RHNZSEdiYzJsdmlxWlVPVXRiZ3o2dzh4SEdWbStZQlhra2l6?=
 =?utf-8?B?Z25VZllNaW1NbmNSYUh0MkdPV3luK0o4ellmVnJTQ3h6M0xnMUxKWHg3WEVF?=
 =?utf-8?B?QUhNYktFVU1pQUFVd3VqQ2hWYkVYN2wyVjE1N2pFTVB4bnMrVkF4SHBrUHBp?=
 =?utf-8?B?T2t5WDh1Zm44aVVTTWs0WmxnSlUzYnl0U0c5K0JJclFJNUF6Zy9KQTVWTG9W?=
 =?utf-8?B?MUhQVzJGb0JLNTFSVnRnNE5YemdqY2hCd29FblhIbjdrYjlhR0xxazlzaTVv?=
 =?utf-8?B?TEZIdElOeWd2b2tKMlZ0R05MUjBrZGlnV25EQXAxOHhNMktsMUM5OTdXeUJX?=
 =?utf-8?B?bnNCc3pwN1k2SHNxR3pHaVVBZFduWTlXZXhQaWFpRk52RlV3RVFhYXQ5VVVt?=
 =?utf-8?B?Q0JUako2SDVNbWFFc2hGMlNFL09QVHQrMVc5UWJSTDVKSXpNcWM4SVlHZG42?=
 =?utf-8?B?YzczeDl1SWdHSVMzbE1NNktKYTc1YWMzMmh4ZG1uL1YxMnEwdFNlZFNTVStz?=
 =?utf-8?B?dThiTTBHU04xMm00UytnYzk0OGZaNmtKUVV3bVBrNHNGbkFwbnl6UVlWNnRD?=
 =?utf-8?B?ZkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Y+wHjapcpRof0x0bMn47Q2XD1liCyWV36BMavCwEJKOs5mofWBqyQoPOnRwEBuwXIAimWBS3odVCkIhdfQSAy5Zok2oQqf6rOyKor/ohqfzE2KKJx+wceM8DsRS0SV2nHHGOZLeR6PHySbyjwu4+JHghOdf4dJCKod5vCVqyEpNFnsPA8Dgh1znCEvAYlcbbwUudwVGFpQOD36rVF8giy5V4YhX83X+AdorOHT5O+nfJ23XTlIRgGEM2ikkAYQ9bt3ThRbRI1QVOoh5Kz8o4Tn0l+DVMdTga7nk6syHFEA4m6gJTdXXWIzqMz5o20VWKTOVbE+R87XiYtVqnN+pUUHhWN34XBOETAzfJHL+bVXK/782qhfQzuvwbXnTQZB3TEtKWF/fWZuD1VihW6T6AjeEIGUIOHSpocvreslt1DlZ4T6kxXhjWDqrZgYFDNDE5lKmm5879hMeLzLoKjinptqdE/pwdL0K1OaK8Pp9mlOpAH/Iu3erRJqHbum2xSfleH0ed7/qL00S7NdrkWb0JQscefdEqM7nbfmnNK3FBkXCIrdKOMzyFnV7IAoJpSDrRhRKMGDMJcldcQratAjU2jpgMLTTTTv29k61lsWbdWhrIUepjmLNx1SvwWHjYqObHNeP7fzIJTd4/YYiGzyAttoWtplMLrUFLuIXRqlyUGhFmBALAxG9E5OpwZj7yyYaXq4Wi33B4dT8eQKsS8vG5nhcjEiKogA1IgW0tihb4RnQYa5Pvxn7/4Xp5wfK9Fan0zT6I28NXhMxmTOMVdYblVR7Vg59FcVxgpKcPbHda8QiYkW2B1AQ+RbWbcYeqvgy/JeBMKZKf3BfYIjx4cj4UyeOgxTj4IXjQ0fURb8C6m77eGrLr3zOmROssVDr7+IHN0HE/ah2BkevM139L6mw3wA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0cf509-acc5-4de0-83f9-08db08e5a225
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 08:30:56.6456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MwKE+MeTfmghEsfp97FnSFknYmN2jHUxK5CU/WoMANWj0Ui378fblJMOej1itgAv9UQGs+h8ZXHn8YYfY0Y4AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4296
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_02,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070076
X-Proofpoint-ORIG-GUID: 1TBjtxPTvk1nI8iJNddb00ri-qeedxUi
X-Proofpoint-GUID: 1TBjtxPTvk1nI8iJNddb00ri-qeedxUi
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/02/2023 21:14, Bart Van Assche wrote:
>> On 02/02/2023 22:04, Bart Van Assche wrote:
>>> Allow SCSI LLDs to specify RQF_* and SCMD_* flags.
>>
>> As I see, if BLK_MQ_REQ_PM is set for scsi_exec_args.req_flags, then 
>> RQF_PM gets set automatically in blk_mq_rq_ctx_init() for 
>> request.rq_flags. Christoph previously mentioned that we are required 
>> to set both (BLK_MQ_REQ_PM and RQF_PM). So where does it matter that 
>> we need to set RQF_PM (that setting BLK_MQ_REQ_PM doesn't cover)?
> 
> I will rework this patch such that both flags are set instead of only 
> one of the two.

You are setting both flags (BLK_MQ_REQ_PM and RQF_PM) in this series, 
which is what I was curious about. However that is not a change in 
behavior for ufshcd_execute_start_stop().

Thanks,
John
