Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD7AC6FA8E
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 17:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCBRaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Mar 2023 12:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbjCBRaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2023 12:30:21 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A25A39CF9;
        Thu,  2 Mar 2023 09:30:20 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322HNNb5016689;
        Thu, 2 Mar 2023 17:29:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=/YkzVVGJ27ha24TVR+okGBklvlvhpS16U/Hm1uf8ZR8=;
 b=hqhKHgMFaf0iQohhL3ODCHVf0CLcmckLHKpw/JhNCuxRNc9EJOeZDypTNn3Bub8bH3J6
 Qlny/qeN3t8Oe/NHyc7eZLgYcjPxerbCBUqw+WH6kPsBI/4FnDBt6lPrPz32cTvgZwV6
 3MSKjwA6k+SlxZxZ4rOkaoXKwXW3oaVP6Rg3fbQkYsFmCq20iGSmJCjJdkFYv8pNp8xT
 AaNYz3XD7GSONPlKXnHhBrCvn6gBkJZpvOolLX8tDTjCNJT8oPfXow7E0CKFhp/qebqs
 T980oIR4sEdogKRyGFjsX741ueQYXoyOEQkvHFL29lcD57yS4SccoA+vyDQ9iT6Rn5+Q wg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb7wvk8d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 17:29:54 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 322H6tDt033185;
        Thu, 2 Mar 2023 17:29:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sabv5m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 17:29:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaxkT49kf7+qHVqk+feSEA3WHuSs7kpMozqv/LDcrQZwp+o2kxTsVsTGlT78o5LpO+hDnckCJ0vNK+s2czlPMKwlDLJT3YPdqoHz5qCvc0NtXkk/190QtM9IS2Lbv7TCFFNY5xmtcv/uA/wCyDF10WbC5/VDW0S3cYKhz1Z6XKJZ13xCwDOIyVZjHjv2nOw1YLtFXP+hONydMWtmFdiHT47NQnD0DBaEPqNerkhheYFYPpED8efNxrjCG+dVX5gTHwTz12kI47WXn/fxOGKUaTCBeJjc0aDClHGZeIuC60v9mDbYUVebQBDYZ3u76kF8pIBKPfu4AHc8deygxLTuGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YkzVVGJ27ha24TVR+okGBklvlvhpS16U/Hm1uf8ZR8=;
 b=Ln6JcpVWBnWPJmavol5u96aeA0OlvVve0nTjbkKFr/Hvwt+YKVU7y5WLtA+bWGON9cFzBP9amKeeh67OLIZ5r5PhcQ1C7y4JdYHzFyhQrFFkqplnu7ruGWUevZOS+0LSkHvgMgqjWT7IFAMzSxJoHgzloJPRqdRKQXV8mjceS7O5F/rEkSXnKba2rCXUE0/XGE8zbf6UC7SKHFsT4XIYE9JVjG1+DvTaZcDIzebj5zSufLDgLV7y0O7pNkVKXjVM1uxqEchyvxNoHojmQMwvCXsRdNVvlLxk4UdcoaHALoFNx1SNzZYDxFMVWp5+Pf3JTiCHFwZov3U05skbBsWexg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YkzVVGJ27ha24TVR+okGBklvlvhpS16U/Hm1uf8ZR8=;
 b=f8/3jUKez90EohawJAtkCMMbrsEo/ZzjkS2ovu+5Z7+xeoj/JRlibbi0ajigBiBMI3g4/J0mHVNqPYo+L6A6lDyb+6li2YtK0wMp5sY5sTy0vw/ttlk1Z1XJHyvc0aehmIO8TwQCyZvF+J18nlZIrnsrIx5MG3FyJYk3c8sEYYY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM4PR10MB6207.namprd10.prod.outlook.com (2603:10b6:8:8c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.12; Thu, 2 Mar 2023 17:29:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 17:29:52 +0000
Message-ID: <896813f7-9296-8072-fd2b-de25d9d4ffe0@oracle.com>
Date:   Thu, 2 Mar 2023 11:29:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 07/14] scsi: target: Fix multiple LUN_RESET handling
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230129234441.116310-1-michael.christie@oracle.com>
 <20230129234441.116310-8-michael.christie@oracle.com>
 <20230211085922.GA5419@yadro.com> <20230302094317.GB1340@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230302094317.GB1340@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR07CA0087.namprd07.prod.outlook.com
 (2603:10b6:5:337::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|DM4PR10MB6207:EE_
X-MS-Office365-Filtering-Correlation-Id: cd1efcc9-45a9-4b4e-8093-08db1b43bb08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zzolG0jWi3cXQFqRw3FcILWpHKRcCXsm9E5RD78iESY61mENgjRHSZuwIYNCmcQgbOFZAeoahAUY6MB3B5HuiuyVbc/IReOxAgrX3vNeZctckIPNdLNuu96lL/Eyg4X45id9vCYTvwPX0Buqy05roRJrjnsURMPpy2pBLyhq7hXn0XzyPKpzRzkSBkYorFoa8WcvfT6prBvOvDLV33k/wzR3tAuO2tUTRRgI9EtHfsXMeru4ccmy6vwXq0sdl24W1k7taHHBduMyB+MWni1/d2d89kpHrgSKGC9HIONuN7U4amajIWy6ZAtfBBhaCNhGIGWlsudToa/UndhpeoIWFDh2r9NHPlSx7dlG32DnXPOCEzgFvf8MBcNsNZWujDtax3TK3+hiEh2Z4DymWofpvvg2PWJKJXZ9k+VBYIoR1E32msc2AnxB0CPuj9JcqAhjRGItZobfJ//mBqRZuy0n9KvLxb2NTgo9QbOiosTmiTrUqf1voZRhluxYRWUMR+PuZnYYDQQxL71cJgXHOLisMJwz7hii8X8jvOVGa0ug3Ad46X7RcDBEJVC1dl1kItOl9M8kUbaWw5YTChZuIcQrf7N+XShZCfF1V95rBaMJHEWCv201mNoHxLXCMeEZF+OTHyxIJDn+8IjlkOkdR3OQ122MnQvILJj4v7gOD9gG5J4sj36AXTGFA5+s4a87++zvoKJ9C8RTBkTvu6R3Yf5g3QOixZEPwnDfFYgwxPMTBaU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(376002)(366004)(396003)(346002)(451199018)(83380400001)(31686004)(2906002)(2616005)(26005)(6512007)(186003)(53546011)(6506007)(8936002)(5660300002)(38100700002)(6486002)(478600001)(6916009)(4326008)(8676002)(66946007)(66556008)(66476007)(41300700001)(31696002)(36756003)(86362001)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEpjbDR1U2VUa1g5NDVCbnVaYm5QT2Q4bzIwV1RXOC96bzdrTGwwMUI3dHpx?=
 =?utf-8?B?S1V6WlpjTGMxSU1hYVRnQWhMVE9zMnY2dEVUT2JzcXdqRVB3aGZRZXE3UHpM?=
 =?utf-8?B?ZWdCUmhBTmpxWTkzTzJFLzNOQ2F0RWMvQkQwa2ErK2U0dHFlUkI3Z3R5SUFQ?=
 =?utf-8?B?OUlINUI4ZTlBVktqaDEwVkJENTAwczBVM0pvUmdwN0VWeS9qRFhCNEtFVVpG?=
 =?utf-8?B?Y2lUcmxSMEx3OU0wSGgvTGVTTFVoM0hPN2c5emFMbmRFWElDcGg4R3JlNEVB?=
 =?utf-8?B?MG5BbFpJcWZEMG1mS1hiTzJLTzlKRW1NSnFxYmRXQi9wNUg5d2o4elJqc3hK?=
 =?utf-8?B?b29ZRzYzYjZ1VUFlY0FJWlpaOTF2SjZKZ3R1aC9xTml3cEMzVEFINDRob3NO?=
 =?utf-8?B?VzVjYjdybU9jT2NwaXl6RzRkUDV1Qm5GS0NYVE5oblg2Wjc3ZmI3UjM1OWhF?=
 =?utf-8?B?ZnQzL0lKK3c4UEgrbXBzL0hIZFJUZU96MGJ6MFFGOFg4U1VZZUE0RE9CRmhj?=
 =?utf-8?B?cXhSVXA5VEROeXpGUjdHeWRvazlMMXRDVWhWM0svQWVySVUrVUxhOGlKb2c3?=
 =?utf-8?B?YnFZdjF4Q1c4SnFHcEQ0dW5zakZpY2t4UFhhWGg2dUFLOGJ0d0w0TFltUEdH?=
 =?utf-8?B?RkpGbU0rMzRhaFk0VkI2d0tzT05QNmF4Y29OeEEyczd4aElxb3ZTWjZLdDg3?=
 =?utf-8?B?M05aN2FtWHJpa0xpRVRINlBGTkQ1V0VyWkVZdTVVdWpuWGlueUlyQVFPVGlW?=
 =?utf-8?B?cjZsV1N4QXdrTkVIdWVUaHBSaHErTHRXRWY3T1lQSFNURHdkbHlqaW5Ncksy?=
 =?utf-8?B?YXRjV0RKVnlDY2dBYkpDb1dlUE1UYS9TdXZ6MlpTQ3hKQ3N0anRjRVVMOWx5?=
 =?utf-8?B?dC8wRE9uK3Z0Q3RLYnZsaW1DbXRsWFZ1RzlDV2pTQzVuYVdUbTlheDBad0pn?=
 =?utf-8?B?UHg1dkM5SXZselgzUjczTityNkgza01CSHhPSWFNVTFBY05lcFB2ZUoxeXNU?=
 =?utf-8?B?cmNsaFUxTGJDVDRrT3h6VmRMczBQVlN6bFF1eG5VQkNJY2xCOGNianFCRE1E?=
 =?utf-8?B?UkFESGpTbXhDZ3RPek5jTlFabVl6UzFjZ2pqSjlIZmxBUGVDSTVLcGVoUVJn?=
 =?utf-8?B?WDlJa3BtdHNKRTN3RUVuOEIwV241VzFkS0hxVGpkMG9LS2Q2bS9qVE14MlBr?=
 =?utf-8?B?Zzk5U213MStDSnJnWElJS2tGbkhJYlRzMm5xUmJsUWNkbk80SWdqWGRERjlp?=
 =?utf-8?B?eHpFVnhBTG0xZVlVS1RURVBNdGs1WGdkVVArNGVFK3Fmc2h3cDErNmlnRWU2?=
 =?utf-8?B?OGZ3aXZydVpYb1NTVEhsUjlzTzFUa3lPZTBHdTdDeFBsalFkL0QzL1VSRUhC?=
 =?utf-8?B?cHBTWFdqT3RHaVBvNDNlUXNpK2dwYjJsZmY1cVRwNVRmeDJzSWNCZlMza1Nu?=
 =?utf-8?B?OXM1QVFLUDIxZ0QwNS9QYzU2Z2crTjMzUEVhZ2tPNVUvczh4dEo5QnZ3L1ZH?=
 =?utf-8?B?LzRnZzNoRVl3KzZxM3k2clBpTHg5aEZ6dkZJZC9Ia3VxSThMcWF1NFhzM0k0?=
 =?utf-8?B?NGtsTWhuUTF5SUc1dUE4WjdqRE9nZnJzd3pnYTB2cG5Ga2VqRnNPQVk1eXpu?=
 =?utf-8?B?aHBlR3J3cmlhRU5nQ0ZPWHMrdjJMTXFLMCtIUWJMWU9ERnptQTdRbW5tUGdS?=
 =?utf-8?B?cGVsbUs4WkEvdmxmMTNFTHNicENrbkh0V0toR3hMRmI1ZnpqeEQvOHV0VXU4?=
 =?utf-8?B?TnFwa1N4U2hTbUZVWXovOFhjRTFOWTBPbHRwajg1cGVGRW5RNnQyUEczNXlj?=
 =?utf-8?B?bUdYR0sxTElEQ1UwR21wM2hkR2ZDT2JBSE1KMmY3MEg3bDB3QkJLaCtpZThQ?=
 =?utf-8?B?eU1DUFdrK2xrRW1xUE8wUS9KN3dzMWYzSmQ2c0toUi9XbEtxTmJzay81bitN?=
 =?utf-8?B?TWx1aTIrTjAxN0tmakJ3NGh3SE9JSVZua1daOHhWVHhIZXo5cUQyaU13ZUhi?=
 =?utf-8?B?eElpVnh1OXAzSlFqR2dQR3pBcUNYZFE3Z0RsNmRXLzNNRlB0RVJpMVcwQVUx?=
 =?utf-8?B?OFpHdlZrbkJlUXNlUWZlemFtb21zYkVQa1hBT2RGZEZ3WVF1cS9DZGU5YVVu?=
 =?utf-8?B?UkxsUUVzdjQyS3dnVWYzYmVBUllOd3dBMmUxUWRjYmYzdnF0YWJxc1RJY3pm?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: nxAN70X6jf+5Ie3xEapgMM7g1j4u+BIqB6g0JIQU+2Z5eeoLWloylFJW9g3qUuQKvq4hqgwc4oxC8WHF5mGKiWxEcos83a9skKr7aNSllguCUhUuulG2iZq0M3SimkrADpATPwooH5KhXdhW9SV6dDOhuHXcd7jCjzDHX8srBFGOgd1gdCVSJdMyvFfpj2JLsL07n6Dn7e9u6hMAFZQjlCz9ECMU/KKi7qV62zq9hfWplL8EW7nolxN4GjzLBbi12xO7zbkPnOnjeYRCIFqzSZOsSqrNzb/UKn55MFLm4kYA/HjwRAG9O0IeN/p5oA3gG2QHGyhKal6BgS0/Nlfc7SWmbW3JL5nuWyxp9pDRQKDA0gOBGLN46+YJupK/ngjNhk/eqr4CjzrE/YoAR91l0pw5WRw0WzptqnMmLz+U8z2UUxLqggiIhkxYK/UNInHnAo7zKNMI0gWELyC+0j/VAD5V8mr1pGfTnO93Yx7dr5R1Ci+q0nJar2bxtskDR/H6depGCQ5S+ONjKrRppOWjqus+Ivf9lFDqyNdY5fTo8lUkkqGnGX/D3so6YWFT5QH37E4M9kgFR5rwKLR8cqFHcYfWKwNqUbOIFZzcf0zrNOujwOjmuxEMgFqFz6bgV8OIV5HRb1YcVx37OOE/oyqXynaZDY7rUwou0g+F6uuI32ApVof8mtVJ+FJC98Z28j9fY4+LIhxxQWRA+V0mDYjcTSYwQEqgmjpSOxFqsn6Q0XIsLu/+bA4URg6R/xjP+/MU1i2FA1i8KGj5yPrP62yEJrdEOVgV92qpt6TB/wxYj9yMfeRujJobYU3+zDPNp9C3aRsVpKAdeIZW+mKr+09nmbrskcMp0FL0tYvfmZTBJMfYglbNOYbt76txT+KJkuwB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd1efcc9-45a9-4b4e-8093-08db1b43bb08
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 17:29:51.9431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKx9aGVINbylI9fiugIDzY1SUvHh0a5CfseFv9ViWlNqN7kreXDqQAT5IocRuY3PxoWBYw0AuAE6qGlGOhrFsVQ2IMC4RfxxgUhSuaO+4bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6207
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_11,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020150
X-Proofpoint-GUID: I9bZy-g0F0Jhr4a-qSok6U9b91QL9-Mh
X-Proofpoint-ORIG-GUID: I9bZy-g0F0Jhr4a-qSok6U9b91QL9-Mh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/23 3:43 AM, Dmitry Bogdanov wrote:
> On Sat, Feb 11, 2023 at 11:59:22AM +0300, Dmitry Bogdanov wrote:
>> On Sun, Jan 29, 2023 at 05:44:34PM -0600, Mike Christie wrote:
>>>
>>> This fixes a bug where an initiator thinks a LUN_RESET has cleaned
>>> up running commands when it hasn't. The bug was added in:
>>>
>>> commit 51ec502a3266 ("target: Delete tmr from list before processing")
>>>
>>> The problem occurs when:
>>>
>>> 1. We have N IO cmds running in the target layer spread over 2 sessions.
>>> 2. The initiator sends a LUN_RESET for each session.
>>> 3. session1's LUN_RESET loops over all the running commands from both
>>> sessions and moves them to its local drain_task_list.
>>> 4. session2's LUN_RESET does not see the LUN_RESET from session1 because
>>> the commit above has it remove itself. session2 also does not see any
>>> commands since the other reset moved them off the state lists.
>>> 5. sessions2's LUN_RESET will then complete with a successful response.
>>> 6. sessions2's inititor believes the running commands on its session are
>>> now cleaned up due to the successful response and cleans up the running
>>> commands from its side. It then restarts them.
>>> 7. The commands do eventually complete on the backend and the target
>>> starts to return aborted task statuses for them. The initiator will
>>> either throw a invalid ITT error or might accidentally lookup a new task
>>> if the ITT has been reallocated already.
>>>
>>> This fixes the bug by reverting the patch.
>>>
>>> Fixes: 51ec502a3266 ("target: Delete tmr from list before processing")
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>
>> Actually, this patch even fixes a crash that we've just faced.
>> The second LUN_RESET moves the first LUN_RESET from tmr_list to its
>> drain_tmr_list, then the first LUN_RESET removes itself from second`s
>> drain_tmr_list, then the second LUN_RESET tries to remove the first from
>> the list and crashes because it was deleted already.
>> So,
>>
>> Tested-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> 
> Unfortunately, I am revoking my tags. This patch leads to deadlock of two
> LUN_RESETs waiting for each other in its drain_tmr_list.
> 
> To keep LUN_RESETs ignoring each other something like that is needed:
>> ---
>>  drivers/target/target_core_tmr.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
>> index 2b95b4550a63..a60802b4c5a3 100644
>> --- a/drivers/target/target_core_tmr.c
>> +++ b/drivers/target/target_core_tmr.c
>> @@ -188,9 +188,10 @@ static void core_tmr_drain_tmr_list(
>>          * LUN_RESET tmr..
>>          */
>>         spin_lock_irqsave(&dev->se_tmr_lock, flags);
>> -       if (tmr)
>> -               list_del_init(&tmr->tmr_list);
>>         list_for_each_entry_safe(tmr_p, tmr_pp, &dev->dev_tmr_list, tmr_list) {
> - > +               if (tmr_p == tmr)
> - > +                       continue;
> - > +
> 
> +		/* Ignore LUN_RESETs to avoid deadlocks */
> +		if (tmr_p->function == TMR_LUN_RESET)
> +			continue;
> + 

Shoot, that adds back the bug I was hitting.

I have an idea for how to fix both issues, but let me do some more testing
and will repost the set. Thanks for testing and reviewing this.

