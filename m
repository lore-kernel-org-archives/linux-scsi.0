Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C27C6FD1D
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Mar 2023 16:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjCTQpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Mar 2023 12:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbjCTQpR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2023 12:45:17 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3DCF6;
        Mon, 20 Mar 2023 09:40:04 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KFxEx2018351;
        Mon, 20 Mar 2023 16:39:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=xmJHnKwVqfoKJFz+P23n1CIzOMefjT0he7Sj6kvP4CI=;
 b=VHBlQ4A0D3gofMt19tWoiFUPSU5NnWDUlyjsKi94h9Sjk6pIi33bp0HkmvVgYvYM+IiR
 6T91PLdf7QFB2XcAyv8Kc6JpSlkVWXY8EMJxlg5Exwc2GnwyNH7Zsn/5ZxESWV3OFc6h
 Xd2VjtDBxOhH1oSxQQHzIhpNobSt01PRFT5ZC8+PgcbYUPU3203RoYVgmK7qfgsvC6JM
 D1s6LXS7RaHljqPtVlIJfgWccTQKH7d/0x/HlMdwSyA79kpWsBIxiXk1gxSJchVspNtC
 ELLOq/XBeXYSxK+sKcfN/cwapjeZP5BJHHgslKeqrVORI3QDLrUkFtLopeG7VBxfbDYU JQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd56auv30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 16:39:20 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32KFDnQH037002;
        Mon, 20 Mar 2023 16:39:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3peg5njdk0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Mar 2023 16:39:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kSjwIFxXMOkIwYeg2413rfUn7Mki9WwyXnDPzQ0ws3JIPcbuqEM+oA/QQIfSsOVoZhPoJyhRrGDGRnJ6qzX9O+jbsuAVOhZx+UpkDfccHt6r4Mv1Nc2NPT+Ouq5K4lSO9woacwaF+Jqj8Mv7hmmrlXzPeJ+1ONNlsmqt+YqEYqbUajiebhGzgKtr2qjdV0JGwyZy6DdA1Z+whBz07D7jBKiWyvSmR571Tpkxj/W8Ho6ah4C2zUleP17NIr6xvtvYsr34K3CfDvgbuvuWbCir0iYHjg887g7mJlUtsfXdLKWJT/X/NRRXnj3vtUo/MvVWWXmQdv9RRD3NyT/+igTzOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xmJHnKwVqfoKJFz+P23n1CIzOMefjT0he7Sj6kvP4CI=;
 b=gZSjWafG7x7fpTJffLmgF0RP3RxJSuPer8YGC7yEV/43U2k79VWqgO792tpXkr8JoZo5LHAQBXttiXScuUTDUyRdZEaACA6I/lr8K4UbpbA6BlGbl7ZcKjravkdQNMDgpIWrVXU8BgHxPlJT/Er3ImvT/UOvpu8vsYCH1MtkNmaM1jiLfbzAA5wuMV8vzGW74yGE5Ef5EZmdJTAQUBWJSnfoGnf8TMsv3Ig710pXOPHLvOJ6vh60nz/vQzReR2sEd8IZkooNsP6P/tDXbbRwcadwsFmTC+BmkaBJ4d0B3RGlHcA5JvpSOGW9QMZA3Hx+Eep/VGtb+v0CGdGeqE56XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmJHnKwVqfoKJFz+P23n1CIzOMefjT0he7Sj6kvP4CI=;
 b=x1j3zp5zDKm3acn5jezttXYoyIAHgKeKQ0vXu3Mdtp3+bfRCX99bBj10k51Wv45sC5dTH9LsLEConQZVGSyY5r9gFI0KlZxT15S/voc4fyHIDo1H/0eYThG9la7B0amybhbKW8q6Wyw5ZsNvj0sVnzEY5ui5AQDO/bRg9A6P50E=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Mon, 20 Mar 2023 16:39:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:39:15 +0000
Message-ID: <ed8afac2-af41-dd0e-16d0-b0253d1a5528@oracle.com>
Date:   Mon, 20 Mar 2023 11:39:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Stefan Haberland <sth@linux.ibm.com>, bvanassche@acm.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Jan Hoeppner <hoeppner@linux.ibm.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
 <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
 <20230315133039.GA24533@lst.de>
 <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
 <6da0ec0a-d465-fec4-0ca5-96b2ffb7be7a@oracle.com>
 <20230320130625.GA11908@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230320130625.GA11908@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0166.namprd02.prod.outlook.com
 (2603:10b6:5:332::33) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4662:EE_
X-MS-Office365-Filtering-Correlation-Id: 20a8e5a2-5af8-4aa5-9df4-08db2961a4d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /YixQ9am8jG7ueubP8Ej2fJrbf/eywD/eAQaxsSy6BV10WjTRmXAHxe5mFDG0qk1qcuYt2uEZBrmhIbPCJa/eACo8x+DmmnTcwFtTKM/oybdLIz493/l8gRtHEuvgJkuT88reMAZj8dLncG4A2R8o5M7ykNvoiMdMPirUTK2T+uBnw3Awbw61KngvHdKzdLBVSSouet4uQc+n3kr9w4bQA6EgrJJeDzp/CWEvA5UEa0btPuKHKdzHctmG0x/mq/6Gt9YWDMBxRAlNZJiGmA7p9OxFybTIit0qk1TSMFaOA4vYxBcV0FS3ZzUXGSDCUpn8FeMuK6TdBUku8s7O9LThKtG7VUhEuzQbQuTSXO5MvhaS4Fv1q0wgWuVMLMhxK27XrdiNOi7/WkrNbIsoTSkXOsRt1blkQyT9clNDb1M7KwctvmaxzjCb4loan5DQrld1oY12z8WrnCMKH8NyuNQiRCJv9zxmkqFw5703OzSoFIUctrJVhPAdaK26UFMWMLAxfgtYIAf9Rl+FK/vuGVz2zAhkO9oY8697+bnPPxExJn6+m9+9RYVuonCRC99Wlq6vZ1X1It6tlB6l9DV3OHaePTs/EfrndiFvr8vnFq+FKsPyZ2fBhuIVVwOHCnelZTkrZ/0bEv+qL8EsO1UniB7lll+vgiprWbpROh9s6rP4Lv6H0xhsOpDdLW1DwuAzo3uTIK+FwJBOtk+HwxLT5dhyGL0RlNFxw4W0Z9VfOQ5yY4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(136003)(376002)(39860400002)(451199018)(54906003)(316002)(31696002)(86362001)(6486002)(83380400001)(2616005)(38100700002)(478600001)(36756003)(53546011)(26005)(186003)(6506007)(6512007)(4744005)(2906002)(8936002)(31686004)(41300700001)(5660300002)(7416002)(8676002)(66476007)(4326008)(66556008)(66946007)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?REtCbWhyQUtDUnVIeHB0cUdXT0NIeDlhc0VZZW5GS3MyK3NFcGxsdXRtNy9J?=
 =?utf-8?B?OW05cXcwb3RYMkdmSldaSXE2TUxmeXNxTGVLWVNLYWNscnBBcUxwdk5BWU5k?=
 =?utf-8?B?ZmZqQXV4aG1KY0lmWnVuSUw4dTlVWDYySWVkckNoNkR5bnN5TVBUUnp2eW54?=
 =?utf-8?B?YTNuSzBJdytiVHMyUHpoYUsreURhM3VETG0xTTFsQkUzb1JWVHl5dE05TmR2?=
 =?utf-8?B?dkdLb1hoeWQ3THEwWXZKWThhT051aHlJYW1WZEFyMGNaZ0hNMTF0VFBMeEtl?=
 =?utf-8?B?VlFGUnoyVjhMLzlDSk0wNzJPWUNSMnRmS1BWM2ltYXFaaTA5SWJ2SkNhNWo2?=
 =?utf-8?B?ZEVLa0N5dVZUK2NZK2o2ZERadXp0cTYyMkpBNG5YQTBzMmFaZ1VMdFhqbUNy?=
 =?utf-8?B?aTJiNGFnam1hbkVVRENzTTRmdlVBdC9heXVYbm5uU1JMRmNzWGRUVG5SVkF0?=
 =?utf-8?B?Zm1xeENnVitHWG44UXk3L3ZGcmxuOE1NeG9vZVc3RFdFcmZBZ1FRTHZlMkhE?=
 =?utf-8?B?YXltSzNLZ3NFeWtFTCtyTXFvNDR4dnJZQTdSRHdYRXQ4bFc5WkZTajNpd0pH?=
 =?utf-8?B?RXdJa0lNcmhIdmlORmFUZStzdzluN1BkRk5wZ3d2N1didDFJT1JrUWlNbE5y?=
 =?utf-8?B?TmJuY1lKVjN5R3NPcmh2WmlRTkIxQXlWTWltN3dNWlNITUNYRE01aWs4bXZ5?=
 =?utf-8?B?dm5HS0R4V29XcEMrZWFIa3JlaXFpNUlQbXdiZm1Yay9BaHFuQXh4cnA4bzRr?=
 =?utf-8?B?Q1BwSEpPQXpabi9LcUx6Zm5aSVNqaTBYcjc5WTJZbkQ3eEtkdHFlaFpBR0Jy?=
 =?utf-8?B?Z3krdFh0M2RMaU4yMjJscmJYV3A0Y1RZYTdsdmpoQ1haMUpCcGpMQkQvVVln?=
 =?utf-8?B?Ty94VGhOR0g4NGJZODJCaXVlZW8rSU5DY09qcGxCbzR5d0k4eEtWVkE2OUpT?=
 =?utf-8?B?UzJHQjMxMGFWc01iQjArblV5WEg1Yks4NDVPSmFYSE9ET092MWtyWW9XcGhW?=
 =?utf-8?B?cnRFbDQ1TWF5ZTRQV2JjdHlVMXQ0RGs0M0FLWFlCOHU0VnlOWEMyT3hZTEFT?=
 =?utf-8?B?YWVmdWxTNEllMHJ2cytUTWFILy9odXI3VlRiaWxBbmJhVkZSajlGU2tJb1pS?=
 =?utf-8?B?UE94ZXJFWjZ2OXIxVjVMQnB0aHNJbUtaSmlNbUJUVFZDaGZIQ2hDdGNCVjRT?=
 =?utf-8?B?UlRxTjU1TFhYU1pVYVIwUzkrVWhYenZ5NmVmUi9La2t0bytlMUpDRmJnMlQ4?=
 =?utf-8?B?bW9rTExjVUhlaXBFS2hURzhaUEwrTC94R2I4RGVSeGFtbXVCZE9Rd2MvelNP?=
 =?utf-8?B?TXdlZFlTUmJHWnFneW5uaU0welVGZ0xGaGUva3hmS21halJCMFlDZjlndXpS?=
 =?utf-8?B?eUw1bTBSQ2lnVThrbExkQVNpSmhqemtaeVJIR3BQLy9CSFMyMWpTa0RGaDM5?=
 =?utf-8?B?MzhwUmZuWVdtKy8xR2lUanJiNEdnWkwrRDdrbnNpTDMwUFV3d2NwZGloUTFP?=
 =?utf-8?B?YXErMXE2SEtkUWtyQ3pvVXF4NUxyQUE2My8zeHdnRDhDQ0VRUzdoc1ltVlVF?=
 =?utf-8?B?dnJTT3ZXM1phUHhGVjFRZXFXVGhubFVudDc3a2taWk90TENLY3VUMXZ2OFUv?=
 =?utf-8?B?dk9pT2lCSDVjS2FZZm5zSmxoa0tIdExsK3NVMHlvdTR5OVVNNzBURTQwZmw4?=
 =?utf-8?B?Umt5dHNmRmRJSjEwcWVaTGI0anlCNkx5NjVpdXgrS3pqM09oSWVybHRKcHlO?=
 =?utf-8?B?V292K1VVZ3NEODkzYUttcVdpMmpZVi9QNkEvbExrWlQ0M2tScTBYZVAwUFVP?=
 =?utf-8?B?RkRzN0RWeE9QS3NJZWcrNFlYWmsyS1QvbWdVQjJOeng2dlg4dEVBamtkakJ0?=
 =?utf-8?B?ZWFqeEFCRHMxeWpBZFV2d1FjVVQyZ0MxVVM0MjhhZC9Qa2NUZlhLaksrd0ll?=
 =?utf-8?B?OEpBeXo2Y3libmNlUjRMQS9Gdys0QmRwVXIwby9ienJ1VjByU0Fsalh0cC9o?=
 =?utf-8?B?d2xqOWg0UEt3RmxyV3JLZk1Bb1VMblZ2ZytLL3QvWlRDQzJWbjVmbFhFTkxk?=
 =?utf-8?B?MnZoYTBKd1ViLzlJQWNrWm9mRmRRUU1Hb2pVSDkxWlRzdzBsNVd5ZlRXUzVz?=
 =?utf-8?B?ZXV3OG5yL094dTNjWWtqL1huNDhjc2d0Z2tLWHJWdEgxNzdqOUJ6T0dXQXdO?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZWdTMWZBVm42bzg4T21QenhFQ2MzVUJkNTgzMW1RZHN3OXljZzgzNzI2WjlC?=
 =?utf-8?B?Q3BqTW85NEV1ZENJREQxclVsNjZuZVUvaTNBVU10SWQzbk5UQURJaW1DQjdp?=
 =?utf-8?B?V0tYU2NMNlJMcGVJbUhQTDNET3hreXZTakY5aWI3UklwNVNvOG9OeTQxL2dG?=
 =?utf-8?B?RzZxOTl1YkMzM0dmU1Z3RDcxb2xSZDZrWGZ0V0JRR2RWUHdIbXpwQ0hseUZ5?=
 =?utf-8?B?ZmhUcFZNK0VYMHg4eG8zZytLQi9pNjFQK0lwYzJQMkxCWU9KMGhuUWJueThq?=
 =?utf-8?B?TUZNYWJFRXNqbVZOQk9CTEZIMlhxUUdQcEpnczNUNE5YRW9XZGxtSlh2YTlF?=
 =?utf-8?B?WEVaN205anJLTGEyUXFiRk94M3ZGaUF4akQ5TXdCQUY1RlduN0RwQ3M1eEYw?=
 =?utf-8?B?M0R1Mjl1dXpvYjFtVkVUQXYycytydVJ2QXFraERlTFRyUHgzWkV2anZsVHIx?=
 =?utf-8?B?c05tb0lFVXBvVkJBdlRZL3p2WjVwWWFoZW84bXgwOVBhdFE1SUV2YmhHT1Qr?=
 =?utf-8?B?MktZM3JNR3phWDRvNWRWSzFWdVY1ZVQ1SlVVNTBXS21pekl6ZHJhMTlDSll0?=
 =?utf-8?B?U3RNRTc4ME1iUU9SS01tMmJUV0RRaEJ5cE5QdXVGRWs1d2VYMGd4ZEQzdGdX?=
 =?utf-8?B?QU85Zm9rQ1grd2F2bXBOZ0lJTFZWMHV4dlhDcGVYWnR4dmF5c0NNajhrLzJp?=
 =?utf-8?B?SUR2U3gyVXVuV2JINmZLNlpuMTFwZ3JISTJYNEdVNnlnbEc1Q2p1RUI2RlBq?=
 =?utf-8?B?S1o0R3lua3U3Q2pRTFBEWURuTGtlVVhqaGhKVTVaM0R5M2JCWUh2d09mN1c3?=
 =?utf-8?B?bFdrNjJlN2twVFBaRjZNQUJaWnhxUnRwWHNLdGNJMXp6MWVpZ3hyRXBYalg4?=
 =?utf-8?B?R2ZIK0pPaEFBazdQZXl1YTNPRmM3cFNsejJ0UllMdW9xRkxEdkhvbE1mU1JG?=
 =?utf-8?B?eDViU3g0UXhNYVdFZ0lZNTRidHFYbktSb2djeDJaMFhWQXRIVVNJQm05ZkFo?=
 =?utf-8?B?VzU1K1RWV2RCVEdtb1A4bitCZkc4UUNCaFJQMmpZYTliZjFqUjE2OXJzK3lM?=
 =?utf-8?B?eTV2Q1ZJdHVlZlhKMzAxek95YnJNcy8zOG14UHg3SjhpOFo2RXhEOWVkZkZz?=
 =?utf-8?B?RUdvRVdyYVljZEJOanp2dkxXMkJTK0ZJRUZKc0U1MGZVRTNtKzJLc002bWIw?=
 =?utf-8?B?THFaNjdZbWs3OFBiN2pZZXNGK1YxbjhJMUVPN2d6TmkrbnBYbFpwVUlYYlJp?=
 =?utf-8?B?Z2dzbzNicmphMVVIRjk3YXFuc0c1c3hieFN3cTZxcGxpMWZzcHloTExOSFJY?=
 =?utf-8?B?RUpTc1JGOTRUQnBKdGUwaGlPTlc4NTdwWlZKajZUcGJBRkZ3SmtGZXBMMGU3?=
 =?utf-8?B?cldjam84ZjF4a1hlU1RUZzBEMmp5Mjg1Umo5TkIzVWJBRTVTN0tqN3VqY0I5?=
 =?utf-8?Q?YZiHYZI7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20a8e5a2-5af8-4aa5-9df4-08db2961a4d1
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:39:15.8699
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uMC3cVlQ8j9rzQmMuF2Ug1VitYUDIdDp5QOQBfqHn83eifQn4veUXE6P0f+gpuuKxBNvenegCB3Cifc2/69cBlFtoWDRtATgE2g0ASliLus=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_13,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303200141
X-Proofpoint-ORIG-GUID: DNz4M7Pbmc4-v4LyZ9dY2mGoQsAs9vsA
X-Proofpoint-GUID: DNz4M7Pbmc4-v4LyZ9dY2mGoQsAs9vsA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/20/23 8:06 AM, Christoph Hellwig wrote:
> On Thu, Mar 16, 2023 at 11:36:12AM -0500, Mike Christie wrote:
>> I think we are ok for dasd using BLK_STS_RESV_CONFLICT.
>>
>> It thought it sounded similar to SCSI/NVMe and userspace will still
>> see -EBADE because the blk_status_to_errno/errno_to_blk_status will
>> handle this.
>>
>> There was no internal dasd code checking for BLK_STS_NEXUS.
>>
>> There is a pr_ops API, but dasd is not hooked into it so we don't
>> have to worry about behavior changes.
> 
> Yes, we don't have to worry about it.  I just find a bit confusing
> to have a PR-related error in a driver that doesn't use PRs.
> > Maybe add a little comment that it is used for some s390 or DASD
> specific locking instead.

Ok. 
