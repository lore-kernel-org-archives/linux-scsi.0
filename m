Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5832C001DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 16:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjGZQhD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 12:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjGZQhB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 12:37:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A9D26A6;
        Wed, 26 Jul 2023 09:36:57 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36QG2cbc019208;
        Wed, 26 Jul 2023 16:36:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=t3Ctt7ZVskGSZ4ZeSSmNgPX/Z+xV999ZuLBWMW6c9yY=;
 b=m6g1OyX159nnZC+3LQR+INs9s63Fc5nhD0HLIIAGw8t2qgKG0OxdqL1WqqR5Da4tE5dZ
 Ki9VY4XFIKInLEwC4uUgeYL2LbcKbcHyXjRIBlZEBb/ngG5n4lplKdw75sL535uZJBF8
 bw5F4do+AGsoSNt7zy4s6Al3To+R7tKBrAQX//VjJ6OoYJd5iA7p53u7QxN2bMCd89CZ
 ly2aF16r9vBgdR2OD/HpKWOQ9e3YSpFDvD6sfd0GOnVjr/GbL544DKQlhNzS+QsFCzUz
 fR1Y0MP0Aa0TmJ6JHzptoTGdv2I3ZOrVE6deaHkNTImIkSbCJOs8yLcXZlwlMkjG+nOj xw== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s070aywae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 16:36:41 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36QFNxYX029587;
        Wed, 26 Jul 2023 16:36:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3s05j6f2un-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jul 2023 16:36:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlIxgJXnjc6sU0TsrMr6da4wgSp/sfoOq/ZHwnBEEFWxKC6A6xXLX2u6JUcf4GRBAivLB7leN+Ph5HJYLovKaxjA9EhEBQBdZKv+UHKRnhIMeisi+T4r7jkM0sqoG3mMeaObVkZdSJcR/+n+T9kWyiCuNW2Xaf0tSxIWz2bQy6OwJI8M8SKM+9+uDJ6BW9xzk7PgbGpIaTFHB0/ifTV23ZkrVSwIZIV72DG/H1IQ46NvWjNc8A40TsjEtqYH/yswkc38b/ohnEuuWkIAI9mfgTdkSP1N/45CK3K3n4uCbbwmKDGpJPe5bKyVN91u+rRPeSrRMN+uUOPSp5kkMsB8rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t3Ctt7ZVskGSZ4ZeSSmNgPX/Z+xV999ZuLBWMW6c9yY=;
 b=c7w5yPYug4FuPDyGaCYyTPF7IewAgqbN4/1vx2cFSxM32fvhzzw6eOCmD+pl/pbtWUuL3JQKhi6IFBNkJjMBoprhkjagbO7wiWw3fPaks2PvBFMpNq2azOkTp4404M1GuA8zwW8WK64HswNMUEXAj92hG67TBM4MuhlF97njrTAQzgIkFaTeFuHnulSaWyBUBl2aLXbwsNevVpW2pzXWA5KMHceYjdZo5vpCUU80iej+T5UI6ro8kgZUrimb2aMwhWQsByCFV9BCJzp5P/C6mOlIFA3uJ6pnmlNuSszzmXewc2e8kDt2wPiZLb25SBfGuFAAZVgbsNEAHPoprfKCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t3Ctt7ZVskGSZ4ZeSSmNgPX/Z+xV999ZuLBWMW6c9yY=;
 b=ILxM923OdbOOpaPNj3jwVG9n1NFj2w4LUKpZYgWTXayZL1mLmUBL1NqWfZO1JZ1zuUi7fVNSZj8BavAJH+0QYOQ0+mmU+fjl7bVEeQaQIXmShPpVIcLhuFyBFvr0sYBchVwBNig7bmt3ChXUhNhuoAxi+0AimnFvLs0IXhmJ6nE=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH0PR10MB4693.namprd10.prod.outlook.com (2603:10b6:510:3c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 16:36:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::8072:6801:b0b7:8108%7]) with mapi id 15.20.6609.031; Wed, 26 Jul 2023
 16:36:38 +0000
Message-ID: <b7818133-6d1e-457d-a62f-360523e936c8@oracle.com>
Date:   Wed, 26 Jul 2023 17:36:34 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH V2 1/9] blk-mq: add blk_mq_max_nr_hw_queues()
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Wen Xiong <wenxiong@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>
References: <20230726094027.535126-1-ming.lei@redhat.com>
 <20230726094027.535126-2-ming.lei@redhat.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230726094027.535126-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4P191CA0042.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:657::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH0PR10MB4693:EE_
X-MS-Office365-Filtering-Correlation-Id: a528ee99-dc22-4ed8-57a2-08db8df67c16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X0hMaqAqrwB7I84HmxVVWrUDxgfmfRjG23OEgr3N+Bd8msr1XQE9A6pWQjsXEba8C3QbFe+okcJtleEpAB72IZ/mHrlzuXIVls9GKhIlXfQF7OYduzqWql0IlzAWpWULv34QmYrVTq9oM2detQGh+6AjJRHUELKOCTo9VQ2rrrCTF+Fe2BmejnN3MfihjKta4R6PkcP+JB+aYsqbpWanF0Dr9pViVLIPGXOpy4ptxSWaEINfddVDHTcDXe7aL+QMMMB1lRRAGUx77lpncHAwnCWfWTVVwTV9+Sqovp4spkrbVCVgOFsmuJ9NIhG8hlzn2HQ2BV6YyM20u+u0+9MMBKrs9ITydT1UEJ4FhYVzw3Z+RktTuHsRcjl8MTXM8uX6jWjQtJjT4LGLhYCOqBh5wEyRTLj/3PpdMSNpZD0bu1KQoKyaMHoPsspa8gsAjfleWXtRlj8IN9xJN5KnkuTbAcu5+qOtn/awYcxPdANbjCtiPZRsQebqb+Mu+hqk2E/VM+2/cuYWDi9UjmX7Khon49moPQHs/5aaEg/Jk98QZ3zy2c0mQEhfnCanENVQmEaSIDVTIpnXcHXHBFOyrotp9J5tqcX9uvAPQ2IW6Hgj0tc0+yNUfev0slstrXuX01Lja4BTRBF2sEw1O274vkpSKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(396003)(346002)(376002)(366004)(451199021)(478600001)(36916002)(6486002)(6666004)(6512007)(86362001)(31696002)(2616005)(110136005)(8676002)(54906003)(6506007)(53546011)(8936002)(5660300002)(26005)(2906002)(186003)(41300700001)(36756003)(38100700002)(4326008)(316002)(66946007)(66556008)(66476007)(31686004)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZHRFQ2hrcGZrVmRmYVhWS1l5U09Ja0p2c3RZdm1LY1JLbzBEOUppdXRLZE9s?=
 =?utf-8?B?T0JBeit0UG1YTUdnaXRobExGalByNlp5ODg0OUcrYW9nVG5oVTJwRzRJcmJG?=
 =?utf-8?B?RkN2eXhoczRGSUNEcEIzczZ1SlZVVEZyM3hKVERGQmtROTZ4cjN4RUZqWVdl?=
 =?utf-8?B?c2x1ZVZpNkdLSytONlRaWHRYWi9SeHRXVGh4dGZOZ0Nzc252OGlXNExlSWkr?=
 =?utf-8?B?U3JJaW92SVpJSUowUVVJS0RxeVBEWjk1c0FSYXQrNzJzWmZGVmlleTJTQTVE?=
 =?utf-8?B?SXMydTRDak5jand0K1R1cFdPRXJ4M1ZUZGt0clhKcVB2WGlXQlR3akozOWRk?=
 =?utf-8?B?cjh5TWhoTDdCZEdLODY4QzkzbEMrL0dIS2JvL0NOOStHWHh0NmYvaWZmRmdF?=
 =?utf-8?B?VnpoN3VNNW1IOEh4SWt2TUU0NHgvUXlBU0Ewc0VScHVMRXNpYzh6c0ExakZi?=
 =?utf-8?B?aGtKQ2JxZitMKy9EWnBYWVk0L29QSEJqRUorMG9yQ2VORi80TkZxWkV5UWpL?=
 =?utf-8?B?cy9oVnM5b1U1SlArL2VsaDVkdzRJc0l3QXQxZkpSY3JyTEdyMzFvUExNT2VL?=
 =?utf-8?B?OFB5eEdMRlVpQ1NVSzQ0SmJWenFPbHNiY2cxdmVHaDlnUXkwK21vL2N5Rkls?=
 =?utf-8?B?WFMyS3ltakZTY2dCUmdrcHlYclJPV3dKMXd4TmlMazFkemludDd1VFVwYkhF?=
 =?utf-8?B?TWduTDBVR2d2S2pYdkR6MnVFU3hTZkNjTWFOYndvdEIzbm5RckZiWkM4MWJx?=
 =?utf-8?B?V05jWWVaTXFqc3g0V3VPUlJVdjBidkFBS1pyZjlSU1FMTytlSVZlRzV2QVI1?=
 =?utf-8?B?Sk82NHcyZlMxaFN3czVPc2pwYjBKRlNqQmg1SjlkK1J0Z2VCb3QwVVc0UDhX?=
 =?utf-8?B?My8vVEZnQ2hXaVBpODhKZ1pIMitoNkgxNThvRlkwekN4TFg5NGZPTVFUczF6?=
 =?utf-8?B?OHFtRFNLdFNxM2JicHZ4M3RNRHpJWThnc3Fna2FTa2J0eHlzc1Q2NXZvVXYy?=
 =?utf-8?B?NlBnVUJRczB5eDExblEzUkFRWTFNYzJ2c3BMM1ZkZ29kSi8vOGVwcDh6YXA2?=
 =?utf-8?B?N2pSbjBJK1NDK1FGRWJvQzZNRE9BNWVVb2g4ditzYVFFS0JZblh3bktWbjdQ?=
 =?utf-8?B?Zk1SQUduVi9jVStXamYvY3RsN3lxVDlMb3FrYms5SExFTG1MYlpoSmhRSiti?=
 =?utf-8?B?R0dSelQ4M2poSWJDVks0Ymt5L2ljSVNSY1VoQUU4cGY5QlpkeTMwNTBEM25S?=
 =?utf-8?B?L2htZTBsb3hnaU9UZFZvNlNWNG1sQmp6Q2pWQlpQdVpDMEJ4bE51dVpaUDEz?=
 =?utf-8?B?QjRqOUhuSEVLVWhpUTZEQTI1L3BtR3d2dHV5QnZTNGhyVFk3M2VUOG9mMkRF?=
 =?utf-8?B?OFRKbTVOUEdLMnFyNzAvRTNRSGMxbzBrWnVwOXQ1ckRnNmxMNHdhSmVKYzl6?=
 =?utf-8?B?UGtiQ2gwK3B6ZkVhVDEveTB6UjhuUUg4dC9vK0JTaEpDMDIyTG5aK3F3aGQ4?=
 =?utf-8?B?dHFjTHUyUW9kRW1Pcm9oK3hPeWdiZ3hmNVh1M0ZSQm5mRTBpaS9abWlyYTJx?=
 =?utf-8?B?SDV5ZzlHT3JOUmwyeXI0MC9zdHB2Q1RWMVQvS1gvR0V6K3kzeWxNTmxicWhC?=
 =?utf-8?B?Z1JUWFN4dTBKZ3haZmplajJvSVJ2RlNiaWo5MGQ1NFM5NDVvOHJxT2tBUlEy?=
 =?utf-8?B?aGFPMXhPemZTb1RwR2RkZnBtQ3JVRnVBOVU1Y1doekJKZjEvTG9zcVVYbzhr?=
 =?utf-8?B?TFJpVWhza0hDM3FJNGVlbFpKQnNqeXlsZ3ZBRUZNR1Y2bDZqd1pPNXFYVWtq?=
 =?utf-8?B?aTZkTEw2SVVyUUlDREZaTlIvYjJ5dG5GZVNjalBsOFg3YTZpaUhGVTlCeERa?=
 =?utf-8?B?OVlKVjlaakxWc1hvVEhuM3lYVlpYaFhraStSYXhuaEhSajBiS016R2dmSFFF?=
 =?utf-8?B?RTF5c1JCNm1aK1g5VklNKzlJYWg1WjJsQWl6dzhLYnRXTkowb0FQSWZoQ3h1?=
 =?utf-8?B?YmFDOUNvTmdrdFRVTmhHSG9oVElIYldqRzdjdlVtTU1nRWF0WHRQUHZzK1hN?=
 =?utf-8?B?cldDdWl3YnhVUDFpQlkvRmFnUzBuUmlRY2p1OXZkcmk1VjJCeFA3Ry9kZlZC?=
 =?utf-8?B?V0hackZldWplb1Fkdms5eXdEd0hJdnBtNnJRT3FCRDNHRVRPUWE1am93TG1O?=
 =?utf-8?B?Zmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WFFzY2dMOGlsRTFZRUI1eEh0ZW95dXBQSGZydGhCekhvUGFoZHpxai9XN1o4?=
 =?utf-8?B?aE1YMEJRbmxyaGRtdUJUWnpVR1cvaWdiWjM2d1d1SmwwNU00VXdoQ0tVaFEv?=
 =?utf-8?B?Ym5YUVJoVUF2V1dJOEZBZm9tRWdKbGpFeU42Ylo4aFZlL0hvQ1pmc2l6OUMx?=
 =?utf-8?B?UG1nVEFiQTlzdjA5Rk9Ya0doVVdPdURmTmJuU2hqNW5XY2c3WFR3VHNISElK?=
 =?utf-8?B?Unp2YnozVm1DQk1nYkpBUjAzUUF1bzBzcUtSaitGQzZWUWxuY2ZwQkQxd1k0?=
 =?utf-8?B?cnVQL2dsY203N2d2Y1NxVmRhUkpRcURFc2JaVUVWTHJBVmY4Q01URUpYM3Vr?=
 =?utf-8?B?bzJwZVNQbkRzSWZUZVk1dWhwU2ZlQlhnT3V1T3B2akh1OThhYkk4ZkJISnk1?=
 =?utf-8?B?dkZzajZPYnNhUGwveVU1SW43YTdBcjI5d2lpYUdrdDh0SGxFWUZQLzBvUlZk?=
 =?utf-8?B?KzRJSkZLNmR0dWkvcTFzb1Z5OE81ZktXTHBqclR6Q2RrSTB6YXpqVTU3SGJr?=
 =?utf-8?B?N21hc0pMRmdjbXB3RVBuWU8xQ29NZjYyZ2ZwQ3JldDZ0OTRQcER5K2ZqQUxV?=
 =?utf-8?B?VllXTjNtQXdZUmY0WURHR1FPZDZzU1JONzhUdVNsL09NQjN0WU14cDJuRlVz?=
 =?utf-8?B?Rm5LMmNaaENUMElsbldkSE1rRDFrVDRnNVQxa2dOWERuT1VHU3dyaHhnVy9l?=
 =?utf-8?B?WXViTFlZNDREZithcWhnZHU1T2F1TURkc0M4V0RCRElGc2NyRzIramlsbXdZ?=
 =?utf-8?B?dXBCRmtPV3g1alUvS0tFazhIWHRCRFNUZUJkSERjVlJuNWQwMDVoblg0dmxD?=
 =?utf-8?B?UEJYaUg3VUNLMjEzak4vRXBtNG4yK0tHS0JBK2JyTXZCeTI1UE5RSW1wc1dB?=
 =?utf-8?B?UU85OVNzSFlhTzlZU2RWM2lTVWY5eGtoKzdIeU5JQmlMc3hXNkdCazZOMGty?=
 =?utf-8?B?SDVZekFxalJtdVFVWUg5QkdEdmp4NTZWMnFkUnhKMGlCM1l6QlNmV21mdGZ3?=
 =?utf-8?B?WW5ETlVnMGVXNkNhcERMcExJK2RKUHpoUTY1Z0Y3a3RTYUM3VkZvd2dWWWlK?=
 =?utf-8?B?d2pDUzJZc2lPZmJzNk9ER0lycVBPaHRBRE81VWd3ZVlsQnBDOVQ5dDhmNy9m?=
 =?utf-8?B?WlNNREcxNEd6a09jVTBZOUtpa1FyMjJhdGFmVjZHdjFQY2tDamFkbk8rK0VI?=
 =?utf-8?B?S29keFpiVjJKNDdJbEo2SEFZUkcvTk9DZnZ5M2pUbjA3eUFLaE1jOGxMVlZK?=
 =?utf-8?B?SkZGQ3lBeHhMWmM4ZG5OWVZUeTRnTldkSWhzeGlmYTRoYlM4UT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a528ee99-dc22-4ed8-57a2-08db8df67c16
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 16:36:38.8268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCVbRzEKAc542fpfp7lAkNNekFMRwEYC6GrHItW38tJoBuRgg5UkEgGVhWK4eEYsqXvEjn2XzWX7vsPKyEDsag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4693
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-26_07,2023-07-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307260147
X-Proofpoint-GUID: 5yqrGKdR8pR6NEqtKEvWVuDeGkPDY9wq
X-Proofpoint-ORIG-GUID: 5yqrGKdR8pR6NEqtKEvWVuDeGkPDY9wq
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 26/07/2023 10:40, Ming Lei wrote:

Hi Ming,

> blk_mq_alloc_tag_set() may override set->nr_hw_queues as 1 in case of kdump
> kernel. This way causes trouble for driver, because blk-mq and driver see
> different queue mapping. Especially the only online CPU may not be 1 for
> kdump kernel, in which 'maxcpus=1' is passed from kernel command line,

"the only online CPU may not be 1 for kdump kernel, in which 'maxcpus=1' 
..." - this seems inconsistent with the cover letter, where we have 
"'maxcpus=1' just bring up one single cpu core during booting."

> then driver may map hctx0 into one inactive real hw queue which cpu
> affinity is 0(offline).
> 
> The issue exists on all drivers which use managed irq and support
> multiple hw queue.
> 
> Prepare for fixing this kind of issue by applying the added helper, so
> driver can take blk-mq max nr_hw_queues knowledge into account when
> calculating io queues.

Could you alternatively solve in blk_mq_pci_map_queues() by fixing the 
mappings in case of kdump to have all per-CPU mappings point at the HW 
queue associated with cpu0 (which I assume would be active)? It ain't 
pretty ...

> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq.c         | 16 ++++++++++++++++
>   include/linux/blk-mq.h |  1 +
>   2 files changed, 17 insertions(+)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b04ff6f56926..617d6f849a7b 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -140,6 +140,22 @@ void blk_mq_freeze_queue_wait(struct request_queue *q)
>   }
>   EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_wait);
>   
> +/*
> + * Return the max supported nr_hw_queues for each hw queue type
> + *
> + * blk_mq_alloc_tag_set() may change nr_hw_queues for kdump kernel, so
> + * driver has to take blk-mq max supported nr_hw_queues into account
> + * when figuring out nr_hw_queues from hardware info, for avoiding
> + * inconsistency between driver and blk-mq.
> + */
> +unsigned int blk_mq_max_nr_hw_queues(void)
> +{
> +	if (is_kdump_kernel())
> +		return 1;
> +	return nr_cpu_ids;
> +}

We rely on the driver having set->nr_hw_queues == 1 for kdump, right?

If so, how about enforcing it then, like:

--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -4426,7 +4426,8 @@ int blk_mq_alloc_tag_set(struct blk_mq_tag_set *set)
         * 64 tags to prevent using too much memory.
         */
        if (is_kdump_kernel()) {
-               set->nr_hw_queues = 1;
+               if (set->nr_hw_queues != 1)
+                       return -EINVAL;
                set->nr_maps = 1;
                set->queue_depth = min(64U, set->queue_depth);
        }


Thanks,
John
