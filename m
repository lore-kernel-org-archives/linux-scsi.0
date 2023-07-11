Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34A26EB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 20:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjGKUVr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjGKUVp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 16:21:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F4E10C7
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 13:21:44 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BICwlK019612;
        Tue, 11 Jul 2023 20:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=zG6+J5s/U6dWtAUTBzVg5GWBn3VkyhrDoNE2KQVb//M=;
 b=dRVFMxYBInAStiytl4o0qwtAtmZ2aG98aOXbxhP15SMIjwMTTtpMQmpzCa016DrWOs/4
 UvTVAiIumg0E6OlSShf3fBIO2RkRYtLpIN2IAZZSFKELeZ8+wwx4D8+TN9vP5dxOnz6c
 nV+87tLZr0Sfx7gVqHh8vrskpddmn6XBg3E9q8ZqH3+/ZcZcDUOPSXCA8DAbh3AUmGIP
 vyc/VSWy4jL3uMtszcL5NpDAClXPERNnM+SPHkkzSMncnMvmNvuDw2lR892yHQve18NE
 1dLdbxxfZke0G1mmSXUn8TGS0Bm/IAMRP/dOXxOjRTbnpAYTWt9QE9lH/rNH2Zyg8MMn TA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrgn7uma5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 20:21:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36BJtwOn008307;
        Tue, 11 Jul 2023 20:21:21 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx8bp8ry-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 20:21:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbe0lj7TtMznCNnCrijeGxs3ySqBmkaIq/K5+FmfMbbcn9LMHsHOMaVp/AzxjyWjaFsbUizT5tS6/W5oOrxhqvnTzfl7T0Ou3t7BN/7vHgdf7Iyj2hnZRUztMvgRfyaX6D3HifEN29zkFx503e6n0Sh7C+UL+aBHwYOyY0iBea/WzYaJAMo6Dtwv/vmeGGF1YOl9+QzSLAkdcKSu46M/kDgnmiCamfe1f46bNcKU/Wzj+mak5hW8uSrJta3e2sPItoRILLOh0ZOe6cWQVgSx41yh89FNIlq8RDECJ156WeIVtc++hltzSxBGmx9Eo4UAfiFYL8Y4bpql6JjsD/FFIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zG6+J5s/U6dWtAUTBzVg5GWBn3VkyhrDoNE2KQVb//M=;
 b=UU4HHZG5Y9vQSf1+hLrzfJ6QO2gS8KEnnEr00dlHPI+scrA0bsV9cxvNTtCwqA2qkzrvul/aXZ8iBiPBMA7izh5Dwz8HEc0D6gN0fvSeOJDru7Ojj1A6sLf9U0P4LotX1P0AZthCSiGtTpv5VycPZTmcWuNtQhJAvbL5kWHurWvkwRPbnF5wOs0lotL6cdcKkiR519XQIcjbAZ0gyTeaXeCGKS/4Kaz9ZprgWpsN47SHcYin8+aXEmuWU2vX8ovsUkgd8oVgolsIz1TRCTWBzrXnxcq6bob2e304egzdsHDePbs8fRPHMgkEBfw8IxCShxLDneLop9Nl+qCbBOtVYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zG6+J5s/U6dWtAUTBzVg5GWBn3VkyhrDoNE2KQVb//M=;
 b=Z536D7Dk4yFnCb70jZ3Ukr5JIj5pfmKtKAvxvufBudl35po4OP9nDgSenNOSIkZCOIU8IfMeVP1PjD/fbtgCvxg2RA4T93sFJwCzdOnZ1daR4sZkr/OIHIwM6/sGLIuVdorswqtPVynYbglP+lb2mH402al6Ci76u9j20hrlNy4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BY5PR10MB4372.namprd10.prod.outlook.com (2603:10b6:a03:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.31; Tue, 11 Jul
 2023 20:21:18 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 20:21:18 +0000
Message-ID: <765f14c5-a938-ebd9-6383-4fe3d5c812ca@oracle.com>
Date:   Tue, 11 Jul 2023 15:21:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] Revert "virtio-scsi: Send "REPORTED LUNS CHANGED" sense
 data upon disk hotplug events"
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Fam Zheng <fam@euphon.net>, Thomas Huth <thuth@redhat.com>,
        Mark Kanda <mark.kanda@oracle.com>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-stable@nongnu.org,
        qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230705071523.15496-1-sgarzare@redhat.com>
 <i3od362o6unuimlqna3aaedliaabauj6g545esg7txidd4s44e@bkx5des6zytx>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <i3od362o6unuimlqna3aaedliaabauj6g545esg7txidd4s44e@bkx5des6zytx>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:5:177::47) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BY5PR10MB4372:EE_
X-MS-Office365-Filtering-Correlation-Id: df6fab35-0678-4ec7-9329-08db824c6267
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U+liEC2v7cs+Uz+tmEcRemAisKTL393d8RULtt477vBvb6ZFQMc7USOhOvDCCMqZhLTTaR4xivlXTF1IKZ7gd9CXBYfWdsGatvQMiwnZ+ixPOYQYmXP+zSrUtHi9El7lNATEgCVFBPIOCl978A81Mmp1Zadj6PwMm8619i/zGx6FW1cpdSpy2M4vW1ee8tqW3pu5ypt3vJQb+q6u7/vN1asgxH3TFgqpgEAAJpY97vLQJg80u5LJKbZ6lAh511Puc0uyXiNHJp4h0Ip4unpPXw8oUZRvH/+dZ2njEg+bDqYNsbGtKkbaPosd6zn5t8z5csLImjgLhGIccAxhkd63d5/kpwyM59iAClOu61bAeXL3IjyK1aKbnDu69JI6rLMb3ZIEtoktZQ9pX4ihZeSkzltghKMOLEOFzEdMI87Db3uXcZOZRkFcyg0UX8CHYaC1hZfsrh1WrHiaxOO2+e1+NlF511F7GdEcaelpescQjQcQz1m061UHS5q5y87p++H0WSdYe+RyAcwqxs16QEZQHb5Cn1S565wO2wpXf+Bvj6/9UaJGFLfrxtcHBasRFiriUWhQE/QCThXs7RCsHbzzmhJOtbsfiRwBwpcn5bpZTEJn1BmZL/q6rhTuPws7bYYX+HYjzt7IWIpvig/1J21kbQvNOQNY+TWov+Eaq6IVM7qi0/iLX0RCxr0xRAkQ5CekZ8xocW7cr+0DsWaLLOWUCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(966005)(6512007)(316002)(6486002)(54906003)(4326008)(110136005)(38100700002)(478600001)(36756003)(2906002)(66556008)(66476007)(66946007)(2616005)(83380400001)(5660300002)(8676002)(8936002)(31686004)(186003)(7416002)(31696002)(41300700001)(86362001)(26005)(53546011)(6506007)(45980500001)(43740500002)(505234007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dDN4dVMrTWlvMlZCYkgrdkVnWVBveUJvZWttUyt1VktnT3BaTXdrNkZ3ay85?=
 =?utf-8?B?dGxkQXJzdGFvV2hoNlVFQ001VFZBZEZVWndXTVpQN2o3RC9YQjRSaENBR3Uv?=
 =?utf-8?B?MHh5RFJFdmJjZTFuL21EWnFhNDV5a0dJZGxqcXlrcCtDU0daOHJaOU40QWZm?=
 =?utf-8?B?Q2tTNXVOcG5qbGszTm43bWZabnVUbFd6Sm15NHZ2Qjl6VWVaV0poMUtSRCtT?=
 =?utf-8?B?UE5JNHM4K0FOTkEybVYwaFIrdDRLS3BVSTFzUWE0NjFBTjZKa1NLb0RiNkts?=
 =?utf-8?B?c1FCWm42Myt6ZWZqL2dZaGlWS0xFSUV2UWw2b0NCQlpGSFpBYXNBT3Z0SjNj?=
 =?utf-8?B?bTF0d3JDSXZWSXNNR2x5YkVuY0kvVnNHMFdudTViWUZETUhYSE55aGNXeVNl?=
 =?utf-8?B?a3F3dmJRNVhHZm5XTHZ2S1l2SlNGWmNiRUF4VGRpSHd6SGVLSlVmUTVrTXIy?=
 =?utf-8?B?WXAxUkRpOGQwY0JCWEo3ZHdBL0s1eVFHVUpidXdUVm9NWkdEYjFuRU5OUk9m?=
 =?utf-8?B?bHNyVm1Rb2kyRkoxUW1DSEF4N21UWjZVbnpMZ0tuTWxZQTRsUzVTcUN4a0JT?=
 =?utf-8?B?OXFkUjZwQlRxWnNQbElRTmdZeElzK3Z2V1JpTzJUZHFWV1h5ME9UN0liQWs3?=
 =?utf-8?B?NDhTcEZ5bU9tTTRlUDFPbWQwYkZwNE0xSytuVFBIOHAvREVzRlpaNGFMUDNy?=
 =?utf-8?B?QlZPNVdSMzNYWWM1OHBRSURPdG9sdnNoazVxK0swZzk2bmNwVlJxdE5qbkdx?=
 =?utf-8?B?NEgrclYxRVBhWWlxWDFaaytSZDhFNkFMVTV5Nzc3MDZDK01EdlA5eXpjUGJ6?=
 =?utf-8?B?bWNSUVkzamNaTzd4N0ZuNzc3VDVoLzRrekZFRVlDcGV4QmM4ak5MK1V3TzUw?=
 =?utf-8?B?bUdIcHEwdlE0WjAvOHhoajlBTWN6aytTQitDVnVsVm9OazVlMUI2MnpUQWdv?=
 =?utf-8?B?d3ZVVHIvUGtkUzhVbjhRTE8wV1ZJNFhJT1A2Q3kxRTh0ZG4rUytpTlRGVStL?=
 =?utf-8?B?M28xcm5sb21YTjZaK2NUZXU5RlBoTmlHTzFxS1d2MEI3ODNWTE5ERkNLajlo?=
 =?utf-8?B?MEpsZGVJbURVVU5LTCtDMmRrbHJ6cmpwR2JZNlZCNGZ1RGd2RmFIUTM2akIw?=
 =?utf-8?B?MnlTdXZCQm9FSjBBa1prZUpkMUMvR1IzbHExRFJ3UE5BM1dlTzhrT281dGJy?=
 =?utf-8?B?NXpNbkZoNkd4QWhURzdXWUdRbW5GUDdvbkJScHpFdkNveEwxYUR0TVBMdlNE?=
 =?utf-8?B?SDZHTjJRMk1md3QxY1I4alZKejVnNUF4b1paTlJMdWNnMHlHSmtPaE4remtF?=
 =?utf-8?B?U2xrQlBJYk5DS0VKaHQxc3ZvZnFnTWhBb0lJQUROak5GRkdaeitoUjRQaUk2?=
 =?utf-8?B?OTdoVUtOTEtMR2JISEdCbjBhQ0x4Q0pJN2ZTcGF3TlcyVkIrUndDNFR4MWgw?=
 =?utf-8?B?K2tlWkp1S0o2cnVaT05tam1LRi8vT25HZmVsRExIUExnR2hYcFBEZDhiVEVy?=
 =?utf-8?B?bHdXNTBIZ3RzSjRhKzZZZU44Nkxad1IyRzhDa3BwWGhpZGRuS3dEU2twSld0?=
 =?utf-8?B?NlAycVpNVE4wcDAzT1VXTW1NNUUxN0V6TnVaNDIzbGFNMk5jVW5FcUFuNk5D?=
 =?utf-8?B?MlJrN3dsWWJvYzJrVHpzVUF2QllMZi9oSzN6M3BVT2VmeWw2aW8zcVVaNlNO?=
 =?utf-8?B?UDhhRjJDdUptcG1UWDdiZ2pHQlFOcEdTOGM4dDh6MXdBQThxVWRNMTlPeGhF?=
 =?utf-8?B?c2xQRWFkMkRkTnBtOFRCZHJZbTNhNWJSVDlnQXN0YVpMQ2pxemhuZ3dSaGJa?=
 =?utf-8?B?NUtrOVhZb1BvOHhDY2lnTEpuWFgwRGtNekZna1FCQ1FrU0l4S2JhRjhRKzNa?=
 =?utf-8?B?N3RqZTF3MTFxcG9pSFJwNjhnTy9rQ1B0b2RyaWErWS8rY2VneU5qTjFLL2ZO?=
 =?utf-8?B?L1VWVkROa0l6ck91MjZJR2RMQTR6cHVjM2lUYzQ4ZHZkWkFCRTJsWk41K0V0?=
 =?utf-8?B?TlJxampmSmtxYXNXbDlacFZEVkNibGFhUzFyUlRnWGZUbm4zeVBGQmFpWVE1?=
 =?utf-8?B?SkhQQlhSbkUrY2hwUTRvTVF6cmxUcWFaaXlFZTFuNU9xVmN3L2ZkK2NSdFZh?=
 =?utf-8?B?bXNZSVo5N2t0c0E0OUNyZTFoQ0R6dFpQWXlqMjNHRHNNd2ptdGRiR3RBZlRV?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?Wnh3K1ZpU3FNU3JkYUJOVnNId2doeHAyNittVTB6eXJrWVpQUUprSjBwNk5t?=
 =?utf-8?B?eEJVNFFBWVFLKzZBNm5NeExDZHNtaHRqWWZMazlzb2V5cUNTTnp4ZXFvaUk5?=
 =?utf-8?B?eUJ2VDg3V3c4YzJDUGZZQ1IxYUhCbnp1R2hGN2lVZkZqamNQeUVKVm5sOURE?=
 =?utf-8?B?V1NYR2JrY2dDZEJmemE5V2hwaDZjVUZnOFpPc1B4ZzFENmxCOVFpOWFJeWM5?=
 =?utf-8?B?TE1FbUs3WGNRb3RwWXVsNERybytxMG5NSTQ5SmxhRjV1TDRTUnVxYVd6S2xP?=
 =?utf-8?B?U1A4VlZ0elhUOERsNjFyT0ErbGdLVitxL3ZaVmJQd2tLWU8vb1dkMXdIMDNs?=
 =?utf-8?B?SVNVcmRBRDVYNFV3NW1CUndrVy9OTWNwdVNaY3pKUVdOcmhKSU5RNGV2L1lQ?=
 =?utf-8?B?OU14VVVEMDBqalNwUEl6dWpiL2hwT2s0SXZsMmFkWXo3SDFvR053SHZkMzFH?=
 =?utf-8?B?dXFNNUo2Z1NoaDJWUnlBcSt1aGVUSWxXV2Y5YzBkK1ozSUp6TUM0SVhjTHRZ?=
 =?utf-8?B?ZjFuWkxrRDdpVi92UWJQakNzTXVxbkM4UTIxU2xLcVVhMzlFYjJFWTZ2Mlgv?=
 =?utf-8?B?SDdkN2pLNEduVHJZbzI1SThzOVdiZlVJUlZqZkdXSFVraUsvMXFXb3NaVFNB?=
 =?utf-8?B?c3ZWK2sxZWdYZUhEczlJZDEzd2pwUTJsZGlKcTc2dTZ2RFdPbWg5K2Z0MHFk?=
 =?utf-8?B?N0VKOUo5VkpzZXJCWUhCQ0xyVVc2d0VGaGFUQVJVeWVDY2s0endhc1BwNHhq?=
 =?utf-8?B?elNjZTZGVTBoclZuWGtWTURKbjN0K2x3Wlh3c24xOHE2dExZOFI2Z1IyTlpo?=
 =?utf-8?B?cVdabXN0STFQWU0yUFFZNkRBSkFwSTk3UExNcVI4T3dmVVBKOFBnaUlrYVJI?=
 =?utf-8?B?UFhIWkJTWDI4aWhnUEMxdTA1U1JnTmtqWlo1UG1Day9rRjY2bWR5Tk5DY3pz?=
 =?utf-8?B?ZEp1cENkRnlpZmJScWR6eUI1MlQ4U3B0MnZDbm9sQWxYWUZ0UE9wRXlPeEg3?=
 =?utf-8?B?bU9CT295MW5wcFptQ3dXN0RIWHo1eWVhai8xR3hVVU9VUFFEQ3psMkg1alZs?=
 =?utf-8?B?akFNWFJKWWpHZU11VUtFVjgwTUd2NTFqa3VDWXdMTENCK0N4alBtQnRXNURN?=
 =?utf-8?B?d1FuMjVZMTB1Rk50MG9PdlJXb1FjZDNmTkVqekFXK25MS0tGVjVTSnpnL1Nk?=
 =?utf-8?B?TFEyQlY5NGVYZUtQS2xsTkdNSDk0SjQrUkptdE04NUVvU3JMYUM3c0hTb0hh?=
 =?utf-8?B?ekozajBVRTZ4YkRGTENtZWExTWpIMlIyNEo5L3Y1Rzh1N3FSQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df6fab35-0678-4ec7-9329-08db824c6267
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 20:21:18.4777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fRG/gw8GjbfJI56DAgNwJj54zVxCL5189S5UgXOQ78A3OAJBktNSDdq7r5NgK9KgJnjSVymVWxN9OIBLNr1b/qPDmhYS61w6UTxRgdyZjj4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4372
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_12,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307110184
X-Proofpoint-ORIG-GUID: o2XzPER4O2armTLyyp4gTUpodjGHqcDo
X-Proofpoint-GUID: o2XzPER4O2armTLyyp4gTUpodjGHqcDo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

What was the issue you are seeing?

Was it something like you get the UA. We retry then on one of the
retries the sense is not setup correctly, so the scsi error handler
runs? That fails and the device goes offline?

If you turn on scsi debugging you would see:


[  335.445922] sd 0:0:0:0: [sda] tag#15 Add. Sense: Reported luns data has changed
[  335.445922] sd 0:0:0:0: [sda] tag#16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.445925] sd 0:0:0:0: [sda] tag#16 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.445929] sd 0:0:0:0: [sda] tag#17 Done: FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_OK cmd_age=0s
[  335.445932] sd 0:0:0:0: [sda] tag#17 CDB: Write(10) 2a 00 00 db 4f c0 00 00 20 00
[  335.445934] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.445936] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.445938] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.445940] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.445942] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.445945] sd 0:0:0:0: [sda] tag#17 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[  335.451447] scsi host0: scsi_eh_0: waking up 0/2/2
[  335.451453] scsi host0: Total of 2 commands on 1 devices require eh work
[  335.451457] sd 0:0:0:0: [sda] tag#16 scsi_eh_0: requesting sense


I don't know the qemu scsi code well, but I scanned the code for my co-worker
and my guess was commit 8cc5583abe6419e7faaebc9fbd109f34f4c850f2 had a race in it.

How is locking done? when it is a bus level UA but there are multiple devices
on the bus?

Is it possible, devA is clearing the sense on devB. For example, thread1 for
devA  is doing scsi_clear_unit_attention but then thread2 for devB has seen that
bus->unit_attention so it set req ops to reqops_unit_attention. But when
we run reqops_unit_attention.send_command scsi_unit_attention does not see
req->bus->unit_attention set anymore so we get a CC with no sense.

If the linux kernel scsi layer sees a CC with no sense then we fire the SCSI
error handler like seen above in the logs.


On 7/11/23 12:06 PM, Stefano Garzarella wrote:
> CCing `./scripts/get_maintainer.pl -f drivers/scsi/virtio_scsi.c`,
> since I found a few things in the virtio-scsi driver...
> 
> FYI we have seen that Linux has problems with a QEMU patch for the
> virtio-scsi device (details at the bottom of this email in the revert
> commit message and BZ).
> 
> 
> This is what I found when I looked at the Linux code:
> 
> In scsi_report_sense() in linux/drivers/scsi/scsi_error.c linux calls
> scsi_report_lun_change() that set `sdev_target->expecting_lun_change =
> 1` when we receive a UNIT ATTENTION with REPORT LUNS CHANGED
> (sshdr->asc == 0x3f && sshdr->ascq == 0x0e).
> 
> When `sdev_target->expecting_lun_change = 1` is set and we call
> scsi_check_sense(), for example to check the next UNIT ATTENTION, it
> will return NEEDS_RETRY, that I think will cause the issues we are
> seeing.
> 
> `sdev_target->expecting_lun_change` is reset only in
> scsi_decide_disposition() when `REPORT_LUNS` command returns with
> SAM_STAT_GOOD.
> That command is issued in scsi_report_lun_scan() called by
> __scsi_scan_target(), called for example by scsi_scan_target(),
> scsi_scan_host(), etc.
> 
> So, checking QEMU, we send VIRTIO_SCSI_EVT_RESET_RESCAN during hotplug
> and VIRTIO_SCSI_EVT_RESET_REMOVED during hotunplug. In both cases now we
> send also the UNIT ATTENTION.
> 
> In the virtio-scsi driver, when we receive VIRTIO_SCSI_EVT_RESET_RESCAN
> (hotplug) we call scsi_scan_target() or scsi_add_device(). Both of them
> will call __scsi_scan_target() at some points, sending `REPORT_LUNS`
> command to the device. This does not happen for
> VIRTIO_SCSI_EVT_RESET_REMOVED (hotunplug). Indeed if I remove the
> UNIT ATTENTION from the hotunplug in QEMU, everything works well.
> 
> So, I tried to add a scan also for VIRTIO_SCSI_EVT_RESET_REMOVED:
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index bd5633667d01..c57658a63097 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -291,6 +291,7 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
>                 }
>                 break;
>         case VIRTIO_SCSI_EVT_RESET_REMOVED:
> +               scsi_scan_host(shost);
>                 sdev = scsi_device_lookup(shost, 0, target, lun);
>                 if (sdev) {
>                         scsi_remove_device(sdev);
> 
> This somehow helps, now linux only breaks if the plug/unplug frequency
> is really high. If I put a 5 second sleep between plug/unplug events, it
> doesn't break (at least for the duration of my test which has been
> running for about 30 minutes, before it used to break after about a
> minute).
> 
> Another thing I noticed is that in QEMU maybe we should set the UNIT
> ATTENTION first and then send the event on the virtqueue, because the
> scan should happen after the unit attention, but I don't know if in any
> case the unit attention is processed before the virtqueue.
> 
> I mean something like this:
> 
> diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
> index 45b95ea070..13db40f4f3 100644
> --- a/hw/scsi/virtio-scsi.c
> +++ b/hw/scsi/virtio-scsi.c
> @@ -1079,8 +1079,8 @@ static void virtio_scsi_hotplug(HotplugHandler *hotplug_dev, DeviceState *dev,
>          };
> 
>          virtio_scsi_acquire(s);
> -        virtio_scsi_push_event(s, &info);
>          scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
> +        virtio_scsi_push_event(s, &info);
>          virtio_scsi_release(s);
>      }
>  }
> @@ -1111,8 +1111,8 @@ static void virtio_scsi_hotunplug(HotplugHandler *hotplug_dev, DeviceState *dev,
> 
>      if (virtio_vdev_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
>          virtio_scsi_acquire(s);
> -        virtio_scsi_push_event(s, &info);
>          scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
> +        virtio_scsi_push_event(s, &info);
>          virtio_scsi_release(s);
>      }
>  }
> 
> At this point I think the problem is on the handling of the
> VIRTIO_SCSI_EVT_RESET_REMOVED event in the virtio-scsi driver, where
> somehow we have to redo the bus scan, but scsi_scan_host() doesn't seem
> to be enough when the event rate is very high.
> 
> I don't know if along with this fix, we also need to limit the rate in
> QEMU somehow.
> 
> Sorry for the length of this email, but I'm not familiar with SCSI and
> wanted some suggestions on how to proceed.
> 
> Paolo, Stefan, Linux SCSI maintainers, any suggestion?
> 
> 
> Thanks,
> Stefano
> 
> On Wed, Jul 05, 2023 at 09:15:23AM +0200, Stefano Garzarella wrote:
>> This reverts commit 8cc5583abe6419e7faaebc9fbd109f34f4c850f2.
>>
>> That commit causes several problems in Linux as described in the BZ.
>> In particular, after a while, other devices on the bus are no longer
>> usable even if those devices are not affected by the hotunplug.
>> This may be a problem in Linux, but we have not been able to identify
>> it so far. So better to revert this patch until we find a solution.
>>
>> Also, Oracle, which initially proposed this patch for a problem with
>> Solaris, seems to have already reversed it downstream:
>>    https://linux.oracle.com/errata/ELSA-2023-12065.html
>>
>> Suggested-by: Thomas Huth <thuth@redhat.com>
>> Buglink: https://bugzilla.redhat.com/show_bug.cgi?id=2176702
>> Cc: qemu-stable@nongnu.org
>> Cc: Mark Kanda <mark.kanda@oracle.com>
>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>> ---
>> include/hw/scsi/scsi.h |  1 -
>> hw/scsi/scsi-bus.c     | 18 ------------------
>> hw/scsi/virtio-scsi.c  |  2 --
>> 3 files changed, 21 deletions(-)
>>
>> diff --git a/include/hw/scsi/scsi.h b/include/hw/scsi/scsi.h
>> index e2bb1a2fbf..7c8adf10b1 100644
>> --- a/include/hw/scsi/scsi.h
>> +++ b/include/hw/scsi/scsi.h
>> @@ -198,7 +198,6 @@ SCSIDevice *scsi_bus_legacy_add_drive(SCSIBus *bus, BlockBackend *blk,
>>                                       BlockdevOnError rerror,
>>                                       BlockdevOnError werror,
>>                                       const char *serial, Error **errp);
>> -void scsi_bus_set_ua(SCSIBus *bus, SCSISense sense);
>> void scsi_bus_legacy_handle_cmdline(SCSIBus *bus);
>>
>> SCSIRequest *scsi_req_alloc(const SCSIReqOps *reqops, SCSIDevice *d,
>> diff --git a/hw/scsi/scsi-bus.c b/hw/scsi/scsi-bus.c
>> index f80f4cb4fc..42a915f8b7 100644
>> --- a/hw/scsi/scsi-bus.c
>> +++ b/hw/scsi/scsi-bus.c
>> @@ -1617,24 +1617,6 @@ static int scsi_ua_precedence(SCSISense sense)
>>     return (sense.asc << 8) | sense.ascq;
>> }
>>
>> -void scsi_bus_set_ua(SCSIBus *bus, SCSISense sense)
>> -{
>> -    int prec1, prec2;
>> -    if (sense.key != UNIT_ATTENTION) {
>> -        return;
>> -    }
>> -
>> -    /*
>> -     * Override a pre-existing unit attention condition, except for a more
>> -     * important reset condition.
>> -     */
>> -    prec1 = scsi_ua_precedence(bus->unit_attention);
>> -    prec2 = scsi_ua_precedence(sense);
>> -    if (prec2 < prec1) {
>> -        bus->unit_attention = sense;
>> -    }
>> -}
>> -
>> void scsi_device_set_ua(SCSIDevice *sdev, SCSISense sense)
>> {
>>     int prec1, prec2;
>> diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
>> index 45b95ea070..1f56607100 100644
>> --- a/hw/scsi/virtio-scsi.c
>> +++ b/hw/scsi/virtio-scsi.c
>> @@ -1080,7 +1080,6 @@ static void virtio_scsi_hotplug(HotplugHandler *hotplug_dev, DeviceState *dev,
>>
>>         virtio_scsi_acquire(s);
>>         virtio_scsi_push_event(s, &info);
>> -        scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
>>         virtio_scsi_release(s);
>>     }
>> }
>> @@ -1112,7 +1111,6 @@ static void virtio_scsi_hotunplug(HotplugHandler *hotplug_dev, DeviceState *dev,
>>     if (virtio_vdev_has_feature(vdev, VIRTIO_SCSI_F_HOTPLUG)) {
>>         virtio_scsi_acquire(s);
>>         virtio_scsi_push_event(s, &info);
>> -        scsi_bus_set_ua(&s->bus, SENSE_CODE(REPORTED_LUNS_CHANGED));
>>         virtio_scsi_release(s);
>>     }
>> }
>> -- 
>> 2.41.0
>>
> 
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization

