Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF0DEE3F07
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbjIKUvG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241833AbjIKPPn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 11:15:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C2E12E;
        Mon, 11 Sep 2023 08:15:37 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38BChbMT000773;
        Mon, 11 Sep 2023 15:15:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Wm5uYaeXwOkYnlMbVu1W4LSxtgL/06ylftEy7sB7Ks0=;
 b=J4gT5MhUUf4cmXNlCKH3mH5rmIWbDxR1TlUgrY+LMIct9CBmg/GeK9o2tcWb6v/bMJsv
 ST9adgBwwfkgiXgjK0FwU9EgnUOsLcCdXjFxr2t3dUXgnvqbi/ooLMwSN4t7ZQTwsvKh
 G53DQQBkInTILhj5tViNkuTCf8fPU8UEJ6ByWWxXMr6qPa29anRcUfdgyRBbMZ4HDC8g
 NhD9PL8X0TC+X4N6RxiZd56NVhl9wK69ybOfXdzjCBHEToK2feFeo7oscqiGVn9BrAij
 AozsJ42Wkq8vzKSuWEyK+OBAmOBABt/2VYhK51yuibeR1cOeOsCK4FYGm8s7WeR26iS6 jA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1k4csqgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Sep 2023 15:15:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38BE0jNx007710;
        Mon, 11 Sep 2023 15:15:22 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f54c680-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Sep 2023 15:15:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbwVE9O4ECYc+JMYaN9am8E0hOwh0NlC3bsq6/5EmW9uGKXHL9JX0v8dpxuSGWUiJVt+OYeNWkWCl+xL1Fh5FHTzvrSWx8aRW1ZursHNxmHXjXHl9LRpGt8ryA+pBnz4T9nuHY1Z+5hj/qKU/VN0g8xPkLMoRiTMuezFHSviZap1ZvIwpSO5OJQsa4Jz8RAllnQdGlDAWARQMMJIqWXPJEn3Xq04YbqbQSHbOu3YvH+kZE/m48mWP9SlS/lhveLsln9ixs9KLhQiqfziLZMec4sW/foyAVTJZK68iAFAlcEVXQYneAd3+urpAJfvk9LFoBbFt34Df5Z8eKCN3ko2qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wm5uYaeXwOkYnlMbVu1W4LSxtgL/06ylftEy7sB7Ks0=;
 b=T+Y6uTpRh4YPRxul2+8dkCrX/vfubp2h+lrADIxyvuGDYoeaTuWboRD+YGUwJz9k7vFyVKCTVkHrWeU6S3N/+ROn47o75JHe5uFgcxbfYlf4uyIGr7B7+XtoHzwbfQgfpVo2hwAQiRQk6swboe2qIKuE5GzzVVRqjIgLhqfq59heyKCkHfVTfQkdlKMfVBsmXAZ1ZZzEgJDfd9nwyQ3QsrZ8yzYU43omEB8/bfYfM9FI1/L+tczlZPTG4uN+aQYsFBuqJMcDsVLRyzrKsm58IZDYzSJ+cuJJcmNnRnt5BM/R5vGPbOptvIQmqq1/6x9E2x+nEeDKNuOGxKKWDVWO2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wm5uYaeXwOkYnlMbVu1W4LSxtgL/06ylftEy7sB7Ks0=;
 b=ZJEg/Wa6jh2t9bL+wVFiTTg8H7V6vl6sfVNxUrkdaxocs8Xf7S8Lx7jIzvgvhLxYOOqEQ8UJzDwG4fPZPKzSP7RbY5BX4Md+oLkEme5/+Zoc3wmmLbJoEfidKm/VtMQoN8VjZve9WJIgLQDSCJWoMbKvqe2kOvn4sImTQX/jtsQ=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5259.namprd10.prod.outlook.com (2603:10b6:610:c2::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.35; Mon, 11 Sep
 2023 15:15:20 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 15:15:20 +0000
Message-ID: <764fa7a6-109f-0ea5-5d25-3e39874e9c8a@oracle.com>
Date:   Mon, 11 Sep 2023 16:15:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
To:     Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
 <e8ca70d1-9c88-4a80-83e4-a65f4bbe6b72@suse.de>
 <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
 <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
 <f56e4e80-1905-0dcd-fb59-aaba7a9f8adb@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <f56e4e80-1905-0dcd-fb59-aaba7a9f8adb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM9P192CA0021.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::26) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5259:EE_
X-MS-Office365-Filtering-Correlation-Id: bdb2f78e-44f6-4130-b7a8-08dbb2d9e991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OUoBHz+dBmpS1AyrMWoX/BSW4JNOus/4AYbWO4/r7d4CQFFcd502TWy8BzBi+PLcuHtHLw4HfQmSKy9Hjli6rYCT/BsxOHPhTDvfXucke2J3vizXbkrzaddwXYjAUMNPfNK1PrbQ4QOaUIywzbx4yRCNjsdTFMSQN26DTNfnmjxqOxy4AUkmtkhK0dV7Od283IYWNQeOT3ZQ+kdzS8eEPyxJOmkqbSRAQd40o9kp4HfgUcVJVuec6HXqK3cV0vASkj+719WhxAwgXZ3DtUnD6FBkn5Iha1wz/7BQZPAcxjRs6ljfKfU25ceXZb4VtWNHh+gI+8GI8uWB9HZZvZHPE+HZbaDjjBLu+BLkST6noHjPVhSfmS2t2R+68I73RRhTqM+gBVAeMyyiZ5AY2m4/HcQ3KKdNUoMNW862qvnruHHi8nrmmRtXRQ7uVqMfv/LOb+i6sAstajoDf9rCPTM0aHW3Rq5Ss0Hvl8HtvMEKhzhmWqOl+SLhfhtbpgZcuAhBgkpnk/4vvOoLWbXWgpxOpvDgahKBI8UnBmByQOhErgs99vgkvp3lbGkRoUndR4rIJN6H7ny1OYsucjeC/+w+OKjXIk/n8rWeGOPrzcNTOYm5AiEcRpbc3jpKLY+fql4/qG6aWvkYhvGb0XLed+fG3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(39860400002)(366004)(346002)(186009)(1800799009)(451199024)(110136005)(6666004)(6506007)(6486002)(36916002)(53546011)(6512007)(478600001)(83380400001)(2616005)(26005)(54906003)(66946007)(66476007)(66556008)(4326008)(316002)(41300700001)(2906002)(5660300002)(8676002)(8936002)(86362001)(31696002)(36756003)(38100700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WHVLaGFkdHoxcXZ4VWljVlB0Rm1WbjM0aUc1VTlSU3ExV0JVV3krcFZ2MDlw?=
 =?utf-8?B?dDdibWZrRXVWcnZFM2xqbDBiUU5lelpNMjdGdFdsWk1rSFdJaTFWVW1SM0s5?=
 =?utf-8?B?aE1yRytJdUlLaVF5dDRGMUVJMEQveHVWYno5QkRVcUxTc00wUkZrUHZQUXJ5?=
 =?utf-8?B?UFV0VGF5UUdUTkRoZVVwSE9FcDI1ZjJBdWd5OUFkWnlnSkZ1dzVkVElSRmUz?=
 =?utf-8?B?bnQ3dVp2OWhPVW5XOS9JY3ZYSSt6dnFXZCtSUDBhLzN4WU5jWWVTQ0pqaDJL?=
 =?utf-8?B?ZUdLbzJkV2JiZVNOR0RCYWNPbHdieDFONDJ0WjhkVm5OVkpyczBkcjQ5ck5y?=
 =?utf-8?B?TnowbFFVZ0VhYmRkekg2bUdQcFlXSml5QjNIeFVVNjNRTDdvSlFmK2hJemlR?=
 =?utf-8?B?YXF3VWJkc2xML2lkRXBMTi84MjZlUmdyLzFLN2NybmY0N05weGMzZThZdVdR?=
 =?utf-8?B?MDJKRVBjcGU4eDR5WkNZOVA1N0xmK0xMT3NOT29hZWxud1BleFNzYis4cnE3?=
 =?utf-8?B?eVFrSmhYeENZUWZzOUJlUFJXUEdZS3RlU1ZkTzNnM3cwaGJXaVdPbG94NE93?=
 =?utf-8?B?QmRISkFpdWRwZWNjNC9OWThyTkQ1VHlJTnVzRW55ZkFsdnBDTU9xdFVsclAw?=
 =?utf-8?B?MUczOHJIeHplc3Z3RDFsWGJpVTFMbjF6dDZDNG1TZEJEVjNJZ2ZxVDM0Y2dO?=
 =?utf-8?B?dk4xbWtMdzg0ZGR0NGsvaHJTTGJ2OFJERFlZaTdjUktNV2JDUXpySUgwdDh4?=
 =?utf-8?B?Z0x6L21lcXo3ZXVpVFVWWGtoeHVra1lEUUd3cVFzVDZ3RmhST1lKYk5Md0Yz?=
 =?utf-8?B?Mlh0Rm4wZGg1cmFadEE4d2dQbFFCTlpTWWFNK0FvTDdLQSs1c1VvTEZ6N3BW?=
 =?utf-8?B?KzlUbGRSRUJhbXZRT0xPMmwxSEVoYnR2aVhya3crNk4wRWZPZDVrNHVwWXFv?=
 =?utf-8?B?amVxRXNPeTJ3TlNMTjh4VnNIL3YvT0VJVHlUZ0NGWWF4TUdxUStmbnZocDVM?=
 =?utf-8?B?ME9ORGxhV3gxUjd1RnVrdWtkaU0rSVhJbExkZjFLTUVNNGd2WHY5dHdmU2JC?=
 =?utf-8?B?ZnFOTzExdGttazQ5UmhsY1dwbXZsT0Z1QTdFbUtkNWlKdDJtTTFxQkVlOVlN?=
 =?utf-8?B?S0Q0cmVqdzE3ekZVbTVhbFViRzUyYW9JNUlCTlRFYVlCbDRzazBkZTJBU2Vv?=
 =?utf-8?B?bWg1d2FHWkpHRWZ4MHRQU2NPVU1EZ0RXMFc3cFpia2hkYjVlRnpRMFhXeHlt?=
 =?utf-8?B?RmQzWXBaREUwVUFrV3BmVkxQTlN5WVRCQXFoK1hHRDZiMjhldXFzNlRuUjRp?=
 =?utf-8?B?ZFJBM3o0VlJ4N1BxTFJyWUowY2k0U2xaWGo5Z0hUSTNPR2ZWd1NIeDlnc2pz?=
 =?utf-8?B?azI1d1hzQXBSc2tGY2hvdTBHNEt2K1ovZGtBTmtsVjgyNkVJbHNKelVaditS?=
 =?utf-8?B?TGNnQi9vNGF2WlBMampvdGNGRnFwMHBzRXFCRnlxZjd4bkZ5U3BMS0pESytl?=
 =?utf-8?B?RkhKZHY3QUgwbytSS0xtN3cwTDY2MkVwc2kvMGlzamR1d243TmNvakpQc2tn?=
 =?utf-8?B?MXBKZE8wMk5UWlZROTVFQmp3WjRUaUdvM2pEVWZjdkRkT1V0N2c2ZXBlTi9W?=
 =?utf-8?B?R3hqcmo1YW93ZWF6TXh1VnBMWU44Mm9nYUZvYVc0SnNSd1ZOYzFaUGVMMXlw?=
 =?utf-8?B?NkhxTlo2Z09LSXNxVDdhUHpyZktpZGFxTW5DVk0yTjJaWG1vMGhMUWlDb1c0?=
 =?utf-8?B?ZlltU1ZBeVVlUkZsWnNuT2xEUGtLK3BvcVlCMENOLzdyU3ZwNFNqdTFHR3lk?=
 =?utf-8?B?dDIwNytYRkdsRWl4UkhCd3EyREVTR0Z1YTMzSDZjTlNKNUcxd21vYUR5NWhq?=
 =?utf-8?B?RFJvR01xRTBIQ2F4ZlRNallVcHN1OHNQNEtyUE9WL3d6OTF0USt4RzRvWCtK?=
 =?utf-8?B?NWdQUldhbnRIVG84YXZramxNZW9jcGZBVEtkVmlCNjBCb2tYelJLL3lZaTAr?=
 =?utf-8?B?NHJVdDRZYVVDSUFwMGdORG1KVTJHcjhFZG9RWnVqSDB1dDRjSzBzblB2bEZk?=
 =?utf-8?B?VmUwdXg3QkxqcE01MFl6bW1vSTlGTDVENnpPRnBhcjlGVE02bk5UOTdjZTI5?=
 =?utf-8?B?dzZJaXdkeUlRdnpXdWdSanpmZXV2WFlpeE1XOU84VDBJN2dSNDNtdUFKc3hH?=
 =?utf-8?B?UFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?WUJKamkvNEFSUmMwNnM0RlNTREhLUm5jUExCbXR3NkFYbjZseVlGS1RHeVN1?=
 =?utf-8?B?blBXa2FkaVhqSWpYVEk4ODBSamNHeFNOeGUyUXdCTnZ2cTkwUHQ4bU1PM29P?=
 =?utf-8?B?U1ZQajh3bHhIYTNXZkJ2bTJQaWY3c2ZWZ2JrUHJoY3ZRU0kzTnN2OWZ5TG8r?=
 =?utf-8?B?WVgxelJOLzd5QTB6ZEd4RDZRNlZuL053T2JMOEFVS0hWamRiQVJoSmFQYm9F?=
 =?utf-8?B?WktHc2thc29xNmhHN1VZbm5JMWE3dWdGYXlPVnhlaUxnWXFGdFd3Q3ZNQ2t5?=
 =?utf-8?B?TE1jTUtrbVMvTmtsRGlEaEtxYlNxME85bUVoRjBPYlZlbHhBdkRWNmlFbHhw?=
 =?utf-8?B?UnFGdzc0bGZENmRyYksrNGw2dUJ1Z0lSNzBFNlhCRXFRcGVQdFFrSEhFZGNQ?=
 =?utf-8?B?bWtsWldpSnJaNWtndEcxUFByd2hZSDNqMm9KZjEybEZjSGJVSGFxb1hxUXJ1?=
 =?utf-8?B?dkFRd0loMWk1RjFHV3V1RGtqZDJmV3JFOVIxa0ljb3Q4ZWtsZngyc1lBTEpK?=
 =?utf-8?B?R0dFZHdUMndpMnFUMExmMTBWaDhiNFdqRTFpWkhiakpmV1ZtcUloQUZoM1Rt?=
 =?utf-8?B?Szlqa0s4OTIyY1p2QXFtRkhjUWNZM1dJVmErWUZOZXA5NDlja1hVek92alVi?=
 =?utf-8?B?NzRLeGtYZ1cxVW1XSFpJZmp1VDZaQ3RBWlE0OVA2MUg5SkZKOUpmUGpCL05z?=
 =?utf-8?B?OXdGVlpySVV3bVg4OE0yOHU0MHlMZWVFR3lTZkVoLzFCTENCeE4yT29jNnZQ?=
 =?utf-8?B?alY5Z3FQS2tVZytlelZSckFrcUYrd1lPaEhrL24wUGZNaVIvakk4Q0lBWjRn?=
 =?utf-8?B?YkdscDNvRkpsMlEycVQ4SjRwL2FhZm9BZXdBRko2SHNjelcvNjhxakNMQ3N1?=
 =?utf-8?B?dEdlVlgyajFOUFB1Q3daL0RxMmVBVU94ajFWbnhYUEhieERnVzlURkZLZEgr?=
 =?utf-8?B?VzRSRVc5a1hjVWJOZTVaUzB1K1NGSHE5SHRaVTdIQVI3eDNSM0xEVFZIQmda?=
 =?utf-8?B?T2VLQzBmTFBpUUFSazBWNENaa3daOG1aUnNGYXl4U3V2Q2JlTmVLZUw3b2hz?=
 =?utf-8?B?WTNDNVhlbS91UWovUHFuQnY2TzFXYzNuZFY2RytsSkxrMFlSRVRWQlFDbnZp?=
 =?utf-8?B?Mi9McUN0aHZYa3J0RDhjZlpkTkczaFhpVWIxNExuZFZFMmxBcUlJdUwvZWRY?=
 =?utf-8?B?L3dLbWNSRzFkU2FtYzh5ZjJyUmJ0R2kzMFhXREh4MjY1WGh5WU1QNjVnMUMz?=
 =?utf-8?Q?enzst4cV9K8py5f?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb2f78e-44f6-4130-b7a8-08dbb2d9e991
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 15:15:20.1771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6ouWI9AgUJP8DQoP/G0KIjFAwur5xHeGsUjJowUCNPeVFCSM+MkWELviccC9lMs1QGnFC5lduTPzIlkdLfPLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_10,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309110140
X-Proofpoint-GUID: Qaz_7GRqZEuSsPZyh9-w11BGlY_J-XdL
X-Proofpoint-ORIG-GUID: Qaz_7GRqZEuSsPZyh9-w11BGlY_J-XdL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/09/2023 12:48, Damien Le Moal wrote:
>> For hisi_sas v3, RPM is supported and a link was required to be added in
>> that driver between the sdev and those host controller device - see
>> 16fd4a7c59. And that is for a similar reason here. I see that we already
>> have an ancestry for libata between ata_dev -> ata_link -> ata_port ->
>> ata_host dev, so it seems reasonable to add ata_dev  <-> sdev dependency
>> here.
> libata creates a link between ata_port and sdev. This is not very natural, but
> as I said in the cover letter, the power management model is weird as everything
> is per port, even if a port has multiple devices. Nevertheless, I tried to apply
> the same for libsas but failed: if I add the link creation in the slave_alloc
> method, I fail to get the scsi disks to show up (no /dev/sdX device files). Not
> sure why. That was with my pm8001 adapter, which is the only libsas one I have.
> 
> Side note: having an ata_debug (ata equivalent of scsi_debug) driver that could
> act as a pure libata driver or as a libsas adapter would really be awesome for
> this kind of tests 😄

hmm... maybe scsi_debug could be modified to support ATA devices (with 
libata).

Regardless, I'm happy to check the code change which you attempted if 
shared.

> 
>> I think that this should really be added for all libsas drivers which
>> support RPM - pm8001 is missing, IIRC.
> Will try again tomorrow looking at hisi driver for inspiration. The other thing
> I need to better understand is how the suspend & resume operations of libsas get
> triggered. For suspend, it is easy-ish, but for resume, it seems to be tightly
> coupled with discovery, so the the adapter resume (scsi host class resume ?).
> If that is the case, then that is done*before*  the scsi_dev resume because of
> the existing device link dependencies. So I am not yet entirely convinced that
> adding a link between ata_port and sdev will serve any purpose now that the
> asynchronous libata resume is fixed and synchronized with the scsi disk
> resume... Will dig further.
> 
> That said, it may be good to move libsas suspend/resume fixes to another patch
> series. There is an outstanding regression/problem for pure libata devices that
> this series fixes. So would like to get the fixes patches in Linus tree ASAP.

Sure, and I do realize that libsas is outside the scope of this series.

Cheers,
John

