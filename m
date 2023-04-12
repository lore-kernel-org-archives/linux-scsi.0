Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E8AC7619A
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 18:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDLS3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 14:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjDLS3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 14:29:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23B319F;
        Wed, 12 Apr 2023 11:29:37 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33CHDrQX012022;
        Wed, 12 Apr 2023 18:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dfLbzVkX4DEX/xi/gA8qYNInRmV2hGIsflqS33WBiLs=;
 b=a4VIDeUzIiHieUeb6alcU5nAqiyerD/xUO7KL68IJl9f4ruK1gCF93U8gphslZFlpUZ7
 9maS+rGMItBbKW+C77kdfvQMAcHknAE7uH/t6S6LFsGXVtWm/13/4n/G2EqdGTHMz0R0
 Nm56PgtVWk3Xx8pcBmuQudPsqul8LpF/jYDKGPrD5yO+/JGCiDZXdpmFzH8WQlzEMx50
 Cezrk5HHU17NGjM3G6XDazNEawcOMzDa4aBLElortymPjHdG0DORSlzAgPf21wMqQkPK
 dJ9TAI//T56IXCMFaLwvd1ja1hIBk1nBnHhNAizWg5rJLwhOsh2rwoRjwuG5/tDbWs1j ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0hc91ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 18:28:42 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33CHBSdL017471;
        Wed, 12 Apr 2023 18:28:42 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puw897kvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 18:28:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNQme/GQLukypl75qNi0n/p9FlPlPKjVM76/BD5cHVNDuC+OGFnHlUbbUCuPBmn5+PBB3cnsuFOvqTKhd6BOrKkT36EUx5v381GbjYEXvOQiv1qtycjndl1dEWDjf+aEn76TuIgQ3rvisws7Ivl4kHDLJrbK9QSKIhcaoumkt7N5s+CcR/AwHl1Di7nZ4LAA7VuAYhB32wSrJ9X+yMZSQX/bHKp0uQ9tQcG7FKBy4CRrlrM1MNDO9QokwBsBuThxPxOPxAW0J8QxPB16IIaHFZ4L+xsV+TI857iCmQcmlL1yVRP5hAH1RfMejg4pZuQ7cNC66lqw0kuAEC/FeLt8Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dfLbzVkX4DEX/xi/gA8qYNInRmV2hGIsflqS33WBiLs=;
 b=eyYEhheb/zCTUCZZanq7DZSTwjXN2r37S8IgZWC8zkI9vxv3oAsSEVxqAq68msqfnyOPp5U7fJCgYFplj50G6XVORCt4/vh7x5IB0Ox+3kGBcdUh9ZHfvBhFhbGJepmdCebNYjq4Ex7Mxm2sUfqla3adXQ1Hmr9uKwivSL6SP+nGauEDBeGyrJou93kxFf28/YUrWWBtFxbe1rmd/VhYLxANN/0Fs0MsldVOt4HHc+t/1zUOj0/8ThAz/ULRE+xpcg/1fHr3Lvqzu7OkeD7pXtHQby2tKUI93iZRXGG4Xirbaomks5qkcYzFJi7kSilHs6P5jiA6vmOB2Oa3xPSieQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dfLbzVkX4DEX/xi/gA8qYNInRmV2hGIsflqS33WBiLs=;
 b=rmsnYg9QdF116qICJWCqxJ7Ruwu3vUPKe9HKLx9cpatCVoO2cAzrO7P5AGprmufUtwZc4WpnG+3dukSvslBbSug2xtB6wKs2yy7fwQSp3Rb+dYUFMbbo6Jf3MXoTLDn6xbGH/vMVCYMrH1VOzE4mlEfc6E1ojIt6L7Nxmk7+boI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB7513.namprd10.prod.outlook.com (2603:10b6:208:451::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Wed, 12 Apr
 2023 18:28:39 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::a870:411d:9426:21b3]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::a870:411d:9426:21b3%10]) with mapi id 15.20.6298.030; Wed, 12 Apr
 2023 18:28:39 +0000
Message-ID: <e85746b2-9736-9041-9327-1ad1299aa155@oracle.com>
Date:   Wed, 12 Apr 2023 13:28:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 00/18] Use block pr_ops in LIO
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     axboe@kernel.dk, bvanassche@acm.org, chaitanyak@nvidia.com,
        dm-devel@redhat.com, hch@lst.de,
        james.bottomley@hansenpartnership.com, kbusch@kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        snitzer@kernel.org, target-devel@vger.kernel.org, vbabka@suse.cz,
        mgorman@techsingularity.net, halbuer@sra.uni-hannover.de,
        keescook@chromium.org, akpm@linux-foundation.org,
        kirill.shutemov@linux.intel.com, willy@infradead.org,
        mkoutny@suse.com, roman.gushchin@linux.dev, ryan.roberts@arm.com,
        shy828301@gmail.com, yuzhao@google.com, zokeefe@google.com
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230412093617.285177-1-naresh.kamboju@linaro.org>
 <CA+G9fYv2nEBe=kJK4veunkvXD9GvqyaPFQ7rUbMD1S4+0nUS3Q@mail.gmail.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CA+G9fYv2nEBe=kJK4veunkvXD9GvqyaPFQ7rUbMD1S4+0nUS3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0164.namprd03.prod.outlook.com
 (2603:10b6:5:3b2::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB7513:EE_
X-MS-Office365-Filtering-Correlation-Id: f118d117-1ea1-4028-9440-08db3b83bc66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Q4P+PPvhAPRe3fGn+8B5irB2ovxt4aIfkm2n4qUuHdh9ZBM7UQygl2v7ehun2DdHXhiCnSz6sSVMptqf20BJ1jugUo0DJmzza/arhDGNlm6PVi+NMz1drAQ3Vl7LVHPEV4mzVU7jL84+p9ZaHP6qtpQxt/7jI5NAyA9SBkaNF/vM+oXrqlB73JV3KDdtJdo0r//Tp2/jvnPVMQNGqLCRlhfg5UWPX26Xa7sOlEMwZTLWLvR4H72Q7em5kyft2VIjerIP2eWDfflsqJJ9EEBU+Xt/PIJSMRIZJXJWSCgSi5kkBA/HNvUfhI43F+N9plyvEhSAucBsN69QScwld7AMbZahsf0kNTlY46kFh5zSifpqaPaTEL71oZabb6ziWtfjhgCD2gvUMKhmhmUaAbXZ/xSkSMlK2JYTh8B4TdY5Gzq/8J1PlJu+w4p6D1rM0m9aFxKZkjeilh3wePUe9NaBnuMIyrkyqrR4vWTiapNx5M8bFj/YEPbguzRixR+HZjLBymBs1ftYj6vYHRP/lQNqdTiyO0wzsRu69QpEo28U8Ssg1hHuZ/dllHIMGvBxIcP707gmZeQgQo2v+M1T9FEMjtx/BYBmRqY8yoObE7Btxd9w1xfD9wbjlzHHo1U9stl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(346002)(366004)(136003)(396003)(451199021)(31696002)(478600001)(53546011)(26005)(6512007)(6506007)(5660300002)(186003)(316002)(6486002)(966005)(2906002)(66476007)(66556008)(66946007)(8676002)(4326008)(7416002)(8936002)(41300700001)(6916009)(86362001)(38100700002)(83380400001)(36756003)(2616005)(31686004)(84970400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1dsUTlxWURMRmN3eXllUVZieUorQWxlZ2gxYWl2aXJiNll5d2FGTmdoNkx6?=
 =?utf-8?B?RURoN1I1YU9mNFhOWU54QnF5M3cxcmJaRmthTjh5bmRpT2ZIVStpNzUrem5j?=
 =?utf-8?B?TmUxRWxDRU5GVW9VMm5pU0lkaUpDR1BPNHZiNHJXWGI5eXQ2a3orVzVFL3FV?=
 =?utf-8?B?bVJ1SmxneExYV3o0YzZtZ1BjQmtUUlBmVmI1T09TQUFkRys1di9GR29KdFFo?=
 =?utf-8?B?aklBZnBxcFV1ckpaUS8zVUs0WWhhanhYL2drVWxKM1ByeXBaaWlUS0ZZOEY3?=
 =?utf-8?B?ZmtIc3pPcXJNZ001UXRRT0p1dTJ4cG9Pa2xCTnFldWtzYUpKQlJTMElmRlFx?=
 =?utf-8?B?eFhKVTFIRGsxT2RTMS8xUDFQSUJvdHdPUGt3dXNBcUtEU05yOUd2SFRERTEy?=
 =?utf-8?B?aWlUK1ZjMFVSdUVuL01MaVQzemZDc0JJRXptalpDTExNUWE2TmdEOXA1S1Nm?=
 =?utf-8?B?aHRpelZNV2FJTVpvZVV2cDJUOVl4djJjSFZNbmwweldSUkRCblVXdVRtZnFh?=
 =?utf-8?B?czVMaFdXWHlrRHFONmRoaTZudDlSd0I1cDFxSFZHODMreExSMmRYOVRzS042?=
 =?utf-8?B?aHBFc0tpTWNTZnZRcmxwemo0NE95YmNhVTVLNG1KaUZ5d1V0eS9rdXFjVEJW?=
 =?utf-8?B?MDI0U0piSUtwTlVlNDRhdVIwZGlLZnVzKytnWDhjQk9SelNGcUIyU0pRdW5t?=
 =?utf-8?B?QjcwQUVOZ3ByRDNHSGhhY1ZSRE1kQ3FpTjBTd0VOR2NEb3d2T2xGR25tazZ6?=
 =?utf-8?B?LzBXSFA4SWRjbC8wd0pLdlJ5WHNQVGJDUjhUTk9JSXA4MUY3czcwWnJLanVL?=
 =?utf-8?B?L1ZFS2VlaU1zWTJvYUowM1RXQkdoS2lheEJac05wZ21iRGcxSUlCZHdPWGtG?=
 =?utf-8?B?UXVTZUgxNTUrVFdYdUxXS3lsSE1JSjNJY3R2aHYxRWV0WGFGQ1VkS2hQOGt4?=
 =?utf-8?B?aEowSzlhUm8yL1B1MmtXSCtMWjNxTWlFbUhVKzBpaGJlUC8yOVZmaitBbXpS?=
 =?utf-8?B?aXRpZDFQdHFZbHd3aFhIeW95OXliYWM5aE1WRWlHYkJMendkZFBkNkVMaHQ0?=
 =?utf-8?B?QUw2ZnQzMUM5UnVaSEw2VlFjSE1mSjhkdzc0bXhOcEY0cnlzWnhEbUxXNHF3?=
 =?utf-8?B?MHZLMG1NdUZ4aENoWTBPZzRKZTVjZDBYaTQrMitrSDRiUVRlelN1L2pZR1Vu?=
 =?utf-8?B?SXF2WHpXWG1MQXQ0QkxjSzBlTkdoMVFBcGN3WEc2Yy92R1dyblBoN0N4dFA0?=
 =?utf-8?B?aHhUMElOYnMzQ05PVEV5Sk5lUWZ1OTBQUDVSYjAweHg0TEhUbXVYdmlDTUg4?=
 =?utf-8?B?cDM1UG9zMDVXVk5xRWdwRkFKRUhrNmVDMjFiN0VsWWpLT2NCNUhFS0g4SWRY?=
 =?utf-8?B?bGVzQWtOazlGSEFSUWxJSnBKUHR6UzMvUnVPUWd0Ui9OU1NXZmNpMU9iNTVs?=
 =?utf-8?B?bng5ZHZQd2NZRFhDQ3ZaUnNKTjBPZ1padzJrei9jRjJKbzAzL21yUnZlRFN3?=
 =?utf-8?B?RFZwcTZRbDkraC8vQU15emhxZzd6S3ZmWC9iRG45aWJ6QTdGdlFUMTRYMHJp?=
 =?utf-8?B?M3d2R29PNkVhUHAyVk9EaDlnM2pYVEZKM3hMa204aFRBODM2QUNpbk9tcjVj?=
 =?utf-8?B?RUFsZGtxa1YveU9LNVBnaEt3RkY4S3NzVitaZWZYanZJYWJFYVdwVW1xcmlq?=
 =?utf-8?B?YjRyZURkKyt5NTlyNFM4QlpURDVTb3JzSDk2OFpRUkcvVGpEYTN1blFlRG1C?=
 =?utf-8?B?aSt0V0UwZ0x3WUd3ZHluR3lwSjBDRWFudFd2Q0d3WkVVV3dWQ2dvNWFXLzQ5?=
 =?utf-8?B?Q3VRaWx4QWxQenROUkJOVEYrdGFONWROYzAyUHNJT1NsSElxMGlSOUsvWjZ1?=
 =?utf-8?B?S3dWeXNEMHpVeHdLeTBURU1Eb2xleHowVUhXcVRLZWY1TXFDN1NuNXZyWFlq?=
 =?utf-8?B?STJtOFlBQ1Y5VHgvUGJ0NU53YTlzZXJRbmNoZ2tkNUUwUUsrTGRWUDhVNHda?=
 =?utf-8?B?K3FJTnBTaHlBYklaVHdjSmJhTjZibnFqUXJYbE5Oem96ZXc1U2JIQ1lYOFEy?=
 =?utf-8?B?QVBTeGtINllhekhlM1FOeHhzQnFvQTNxNVBEUXdlcnp2bVFtMkNROXJ6czFi?=
 =?utf-8?B?V2FvTFJIckpSQktaV0w4aXhFWEZDYVViRks1R0x4L0dWcHROWmFFS2F2c0Uv?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?dzc1b1JzV3dEK21oSXlHYVpuQlB2R09ZM2FLRDhibWFTMWRQYnprT211WG80?=
 =?utf-8?B?ZForTG41cmVyQ3lqUDE3ZnBleDJ1WFhpOXZwaHBGbDJ6K2NQQXFhakw1WWNw?=
 =?utf-8?B?U2RlRUVYZStjbFM5ZklmL1lKVSt4Yy90Ky9haUdvdTV2cTNYM0JnZWVQdlow?=
 =?utf-8?B?MlB6STl6MlJiUDJqRzk5UXQyOGlwVVNSV0dsL0laTVVNY3VzT0ZTWjdKKzAy?=
 =?utf-8?B?dS9FTjBEZGlHQTA3Um0reWFXNW0wNHVmU3o1MlFlSVBYZWhXcDRGa3ZDRUtI?=
 =?utf-8?B?eVh2NDZVRG4vaDREQzRPVlFiOXd5ZlR6dG94Z0hGQ044c0hQTWdRaVVQRTBm?=
 =?utf-8?B?dlplSElIeWFTMmtKS0FtWitOQk5GVnpCeFJMNnZLQWJrUjZaczVKTXhoclUr?=
 =?utf-8?B?N3BsWFYzRTIzY0pMbzdpMVlOTmQzU1hsbzhCM21Lb1BVZXZUamZYbSt5REFj?=
 =?utf-8?B?Skd4eWhWOHpuTnp1MmNva29Ed2tEV1FxdG5DL29CVmdRYzNoVXhxN0U2RHYx?=
 =?utf-8?B?blpvR3FKV1dzc2FxNkh4TXZvRXVpdGMwQXJVT3RXTUJRM3FNclRlT25TLy92?=
 =?utf-8?B?Ti9GR0FwN05GKytJbm9TT0ZFc2VrRlo3c1d3c2x1WUh1Wmo4KzlkRmRIVTAr?=
 =?utf-8?B?djIrWHVnOVZ2ZGVnMVh5Ym1xYkRKdDR2Tk0zRnhsRERtOWhFb21LQUQrbnVw?=
 =?utf-8?B?SFJZYTRIWWluYnZVbTFuOXJYK09mUUZmWjJvWHBhWE93Ui9ucFZDaTRPZzk5?=
 =?utf-8?B?YUFudzJDYlZIbzlveCtpOFc2cmtCSWJkcVlTTzNWU2M5WkUzRnorK1pvcXVt?=
 =?utf-8?B?T0E5Q2hzZzdlaE1mRkEzRjQxL3JhREtUUzlzM2hPc1NBbHFPaEF0Y201RGIv?=
 =?utf-8?B?RXVZL0hsTlNqRVhuQmZVb1Y4WXdCTnhoNS81SzdEQ2pWMXE3Z2owTWxOSXhZ?=
 =?utf-8?B?Rm9oSGNWMlNTV25Zb3ppT1dPSFdtYmlZaWJMWTJsSE9Fa2dtNE5CdkppT1Fj?=
 =?utf-8?B?Q0ZwcEF4Q3dnNTVscklVWEpyVjFseGs2czM2ZXZUc285VnhROEhoWTRSd0NX?=
 =?utf-8?B?YUhkSWVkbEprbGxkOU9mY0pyRXZkblR3M1BNY2dYRU5hbVI5YWw4SG40RHZ2?=
 =?utf-8?B?Rm5BeVBOQjQvWTAyL2VqbmlCcmIwU1Q5Q0N0VkVETkdsUmpKcGh2LzdPdXBO?=
 =?utf-8?B?S3gwa0FLR3lIRHByemFPQ3ZnaHkwTGttdEYzcTZETGY2T0dQVHlyYXB1Q3BS?=
 =?utf-8?B?bkNESXM2YzJabkdFdGluY21RWWN3a3dkWTk5NXo4dzh3Z0ZNWnJBTzd4Y0tT?=
 =?utf-8?B?bG1Vb3pPbElEWlJxWUZjNWpoRm15ZnNOUnErOU1RUW1weHlMa3V3bk56TXZC?=
 =?utf-8?B?ckl6YTZmci9KcG1jbDJlTXVPS1g4czVDWlJueHdqbVBFc0lqZlBlUTBQVFhB?=
 =?utf-8?B?L2FaMS9OQmtOdlVYMEN4bUJUYk1XVThob3BjTVdtZmdXNWpNeTZ0bUVReEQ3?=
 =?utf-8?B?SDNnVm1KSktvWWJZcWFUZmZrVUdRdWZhZGpsSDMyVjBLbDNERzhGaXZXSUZ5?=
 =?utf-8?B?elJFQytyaUl1NUF5ZmZYa2NxZjE0eDluak5jUVNWV0x2S2VWakhDQ3RXcWV1?=
 =?utf-8?B?S0lSbS93U3VhcHUzYkVvWTcyenJZWTNGelNQdXFmbjRCcGRyR3RmaUhjaWNW?=
 =?utf-8?B?ZzI1aURod2ZqQm9JOHBVWmxYenF3MEdJaTgrZWhHL0o1SUcyMkJWaGk5VThh?=
 =?utf-8?B?WGdRejMyMU1iOG9xUlRVdFZ4M1oxc01vRkIxNU1XNis3WTREVVpjeDhxOUVE?=
 =?utf-8?B?bVFVUTNqQWtQUURHNDM1Z3hDYmh0SGlrQ0xUL1JwSktkZnlXUzlPYWpUYktX?=
 =?utf-8?B?aGJpbVBReStmM1dRVXdTTWNCMWZDblVhQTl1T2lTMis3QzJpM1BVR1o0MTJC?=
 =?utf-8?B?RHlpNGl1cjZEbnd5NExjWkF4aXZTWjlvRlFJZk0vcytjOXZYWlhLV3ZIYmdB?=
 =?utf-8?Q?X2KEcJaeZyqj9Y74FmRLFp65KTMho0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f118d117-1ea1-4028-9440-08db3b83bc66
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 18:28:39.3084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7WpTzkd+cxY4yXMXC/WH/InJsuMC+gdOVtBJd8gO33YKtXM2AqX6mWPD8Jjo+HW5U/4dk7GVCSwry1uvAPx3+GIPnzfACzdpMEiR3zxq30U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7513
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-12_10,2023-04-12_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120159
X-Proofpoint-GUID: 5Dl-6VgABmBOq0Wq6CGqfzDriG7RAiET
X-Proofpoint-ORIG-GUID: 5Dl-6VgABmBOq0Wq6CGqfzDriG7RAiET
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/23 5:25 AM, Naresh Kamboju wrote:
> On Wed, 12 Apr 2023 at 15:06, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>>
>> [sorry for the adding you in CC]
>>
>> While running LTP controllers test suite on this patch set applied on top of
>> the next-20230406 and the following kernel panic noticed on qemu-i386.
> 
> Also noticed on qemu-x86_64.
> 
> Crash log link,
> ------------------
> - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/test/check-kernel-panic/log
> - https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/build/lore_kernel_org_linux-block_20230404140835_25166-1-sergei_shtepa_veeam_com/testrun/16171908/suite/log-parser-test/tests/

Can you point me to the original report? I don't think my patches are the cause of
the failure, or if they are there is a crazy bug.

Above, I think you pointed me to the wrong link above because it looks like that's
for a different patchset. Or did I misunderstand the testing and that link has my
patches included?

I did see my patches tested:

https://qa-reports.linaro.org/~anders.roxell/linux-mainline-patches/

but they seem to fail in similar places as other failures that day, and the
failures don't seem related to my patches. It doesn't look like you are doing
anything nvme or block pr ioctl related and just failing on forks and OOM.
It looks like you are booting from a scsi device but I only touched the scsi
layer's code for persistent reservations and the tests don't seem to be
using that code.



> 
> lore link,
> https://lore.kernel.org/linux-block/20230407200551.12660-1-michael.christie@oracle.com/
> 
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

