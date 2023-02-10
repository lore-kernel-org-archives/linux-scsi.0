Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03DF6C636CD
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 09:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbjBJJXB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 04:23:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbjBJJW7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 04:22:59 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9AD6F208
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 01:22:53 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31A7O4XB023986;
        Fri, 10 Feb 2023 09:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=TlgqPhvmJ+89k+KicjM3UfOA4jlkZbDoWnBYldfydHY=;
 b=GMM81/YeYF48ZXjg+WsbgJf6NLtepwPeY+Vdp4Qa7DaCcfL7+m2qbCU/9RHqmEx7pk83
 bGQ0FzzZdvkgwjUDXZPnAZSGBNgV+LtZymlXiV6SeO5ILWyWDRjPi6pbCFdZ76mbZeCo
 pxeAwVyQQnd1HNEACNZoZuKXX9lL4rj7CcJ/S2dLf3fS2A3rHfVwnb4x1Bdz3ycRikpD
 mFwQTW1VAdzhXYCseKO8YSSs0HuI0kqR5SJqactyuY+SVHdlWXjgmZ+W00dgBDqP1s5e
 XraeHfNkiV1XkulPlBGefug9OUbNBMcKIQF9k+ZK1X3cV/7Y8LdL23XM4FAQERMW+eqE tg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhf8acsfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 09:22:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31A9GE7Q036014;
        Fri, 10 Feb 2023 09:22:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtgc0a6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 09:22:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=We1wniE7/KLwswpUZ51pZK0N5SLTUoG3L36t+pltyvyt4tzWvOaKpePxJGVg1m4ISZa4om+nYzK0xBpe210uq5kHVXwzcyE0C6NNJhOZvOVPIp5Xb0yCfShVqsTc2nkPn7E4QKIeKs+hrK/YsgBQLfXmzVC4LvwWJJG5Zr8xbi8knBFoviGZR+siPAXaVnmnlbZ/umrNxec/q2kxQf8v0PG6iyaMGL6F3tAiZ/j5HcuqwaWjVIWLay0dse/5x6ODlVoPEcoiZMmc43i+X4kz0nCMXSF2+0O1I/skXqaayT5A281D57HrfjryTT8dAa+RsHBEcywN3WZmNgBkU7GquA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TlgqPhvmJ+89k+KicjM3UfOA4jlkZbDoWnBYldfydHY=;
 b=jsaeSNdT0SFwDzFUASk7Nj04ix7v3EKPu5xlviIQD88OqAJ7repz0/BheB5z45pvfHW8RfoN3wQXgJAbmS+UNH4OIPTFhoBY2dhe4MCQWUovzplStCI6z4R7TSlzWdTnoXAv0oUCRCqAc8qEbPt3juL2a0kWo0/cXeKcaNm6wNIH1t3lm7pQKMNhngetpouEGnhJNst9DjnvphUAlB3JPS2JAa7Q0QqGYHSc2DhmV5OOlWgwYNj8izqLfWs80bCr0rAWxqyALtFoFKBQ/6AhQ2GvmqbD8DI4QUsnbcKaSgUCAsQ7So0ADOyfJZxHYZERRhkwtPzlPdwCH6fILvPz7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TlgqPhvmJ+89k+KicjM3UfOA4jlkZbDoWnBYldfydHY=;
 b=NJglk4VTzK9HnvYAG544GR6iktRIXUYF3NDKGviJJzFS+r36mIlMm1fzW85aX7hPobOE5H770VEIGFiy4jz2hgVIdlX9v2rQRcgxIVKPGku02SWHrN8YpcJm+Udm4vVG5YcwNf7OlFF93wDxlNtp0VNyzmrm98xghVvfhNtUuGw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CY8PR10MB7194.namprd10.prod.outlook.com (2603:10b6:930:77::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 09:22:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6086.018; Fri, 10 Feb 2023
 09:22:39 +0000
Message-ID: <786859cd-a24c-1f8a-470a-1b2fee08b5d5@oracle.com>
Date:   Fri, 10 Feb 2023 09:22:33 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 2/3] scsi: ufs: Rely on the block layer for setting
 RQF_PM
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Jinyoung Choi <j-young.choi@samsung.com>
References: <20230209185328.2762796-1-bvanassche@acm.org>
 <20230209185328.2762796-3-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230209185328.2762796-3-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0017.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::29) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CY8PR10MB7194:EE_
X-MS-Office365-Filtering-Correlation-Id: e55cad06-75b6-4387-4efa-08db0b485aa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mzHJd5jcv+Gl20VeB/aaPtBkI/PC9t6IVZMFixJmpv53/EaSXUH5mvuptbflGcOZJZi4U+Pz+hw8Qsi3CVB1+upKWah0l8cF6qDx1/m9GZHDfi26twk2PGIpIMO5wlhDiwbbws4WJ+n3FolACpqDKXZhE9Mgss6x/OzEdc3FbAhicCOxFXNyhIpvsUETT596bamAqwn2Ax2FSCg/vA0y3qn3Ls4bOXv5Y/7JL2ondWjMhlE2g2053My0dpxoKTgBqiNipw/Q3qAOUFE5P9TFHHlAadffb20Tsi+jS5UU65TzpxxeD1CTYIIHPeVskH0w2vlVmnFKWRRxuxeICnRFx70PRImQ8gk4JPaz1gg+s3vKOZvt+RBh+poYzYzuW9VGBAKw5UnXAusHi3quL6PwiervMmbNkJ8AOfZLsWKqHVAqkuheLqt+t6TN6VsqrJsfBnIiW8a+jUwYpDU1hVDin8LZK1eMPvVtMo4ToDgdvpkZ+zocHVxyWwxQR2XBhXX06hqvNXkCYkyPaWkT3UTvl8uPDiDmuVqC9uYQPLSwFAwHepjaWyX1FCfWoVGiRyc91L5k4wkcfQgl1W50R3d97VtdRWLfohrpLsfVoub3tJrLvG871yaHn6pz4KmLQ/mApBDIlWiYpe1R4TlruHnr56Lg2k3U3z0I6j/VODBWpGVnRuuOynKruXxpbFYp3Y9G2vAVMGgkqnDNfXDTIoCujlyp+kSt59VD2+YCOHAWN6vok9m2+IDUNB4guD2PTrCsMljkAaRFngKQjU8etOMCDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(396003)(366004)(346002)(451199018)(41300700001)(66556008)(66476007)(4326008)(66946007)(8676002)(2906002)(36756003)(31696002)(86362001)(5660300002)(38100700002)(7416002)(8936002)(36916002)(6486002)(6512007)(26005)(478600001)(6666004)(186003)(966005)(53546011)(31686004)(2616005)(6506007)(110136005)(54906003)(6636002)(316002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tm1ha0hjQUhzbnRiSGZhbEt1TkY2eHEyM3dxZzJDWFU5Rmhnb0hsVkl3aUd6?=
 =?utf-8?B?RGRsTFNmS2FqNkhjSThJNENJYnFpcG9ZRkFXVUJwM3Q3U08rS3h0SzhEZTRk?=
 =?utf-8?B?M09wbGJBUjQweFNHR0lQS3hGSzZNenVFMXcwb1FsaVVpcFgraTdxUW1TUS83?=
 =?utf-8?B?Rno2VEYvVTIvakpTQnY4TDUxcEZLMWFOQXVWaTgvTWdqYS9sV2lGOVJlLzFa?=
 =?utf-8?B?U0w1dlU5SnV5NWk2R3A2VWs3czRaSFFrVWcxZ3AzSkFIaTRCOFZ6RXFXa1h4?=
 =?utf-8?B?RkhTenpjRzQrQmR1MUNJR0RLVnZkUzhGWGZRNkxrc1RZSTFwNnYrSG5kUVdm?=
 =?utf-8?B?NStjUXdKbFJjbnVDMlU2bUQyYVFURUtnOHovUi9iZnczV2Q1SGdVRDBNMXJk?=
 =?utf-8?B?L0pUdWxyMFhVb2pUT0hQVkd5ckFsYTlobjRNd2oxU1VTZ2VKTndGaUYzZ2Nz?=
 =?utf-8?B?eG5iTXJrMmphNkpTdHZTK1FycWZNR1pLa21nV0dyZW45YkR4Q0VBdjJmT28x?=
 =?utf-8?B?VFNWUExVZm1RVlNLdUtjQ0J6QmJuQisxdVdpWXpvbkxtU0kvYVRPVHMzajVz?=
 =?utf-8?B?WnVzY2EyTDEwQ3FPeDV2KzBUUFp5akpwNHp2RXFLbUZlNU9vdlpwdTI0WE13?=
 =?utf-8?B?QUl4WHM3TFRHS1JuYTZ1bFRjY0UxTWxsd29qa1RBNDJ2ZFpXQm1pdmFFT1lZ?=
 =?utf-8?B?VjNqYjM2MlV6cXlMWFl5dDUvczJpeUNPYThsQW5OdFRQU1EwUVVPMjI2YTZZ?=
 =?utf-8?B?QmNNczk5TXg4TzF0SEdGR042V05CWkxSa0w3TVdwbU5aNU1zS0ZDMkVIZ0xy?=
 =?utf-8?B?ZXpuSlFORVBsTmtoeDNuVEZaUHJ4NW1oMnFscVBnR0xQMnRneStwRGZES3Jq?=
 =?utf-8?B?MmJZdHZ0QlZPaWp6QzVXUWhmbGZVTkVyRUJSdWhsOEMxRkNhZUsrNFNXK0R0?=
 =?utf-8?B?Z1UrMTgrTVVveFZSNVRtTWk1dEJaeEFITkxub2pJRjlkb3drWXlWcFJvcUJi?=
 =?utf-8?B?a2QwaTVwTDhZSXA4VllmOTBUZXpra0NtVFZBNC9oRHgyWTBKOEVqaFhoTXMw?=
 =?utf-8?B?ckxIOWtZelVNZmFuNEVRZGs1b2hET09HL1M0SGU3d1JBL3dNaVVkc0h6SWVF?=
 =?utf-8?B?S1E5aXpXQmJZSVFHdXMrR1VPcDBXcUkrcVVMYi9nU1lvNFFmNFI0am9FSFpE?=
 =?utf-8?B?RDVlL2hJeGt4eGxJRklBQ05Kbmg2Um00ZTRzSlRXYlN2RDlEQy9QcEJEUkkw?=
 =?utf-8?B?WnJCWTJ4b0xLYzZGOEJzREN3ajlycUx0TDZPcnBIejJINmlKMkYwRjVucTBq?=
 =?utf-8?B?TDJRWnFydHdUcCtOMUtEWFBTYnFJaU9BLysxODZsbjkwOHJQN3NkU3pzYjNK?=
 =?utf-8?B?MVh5NGgzenBwNDcvSUJGTElpbVRFbCtDdTdCNWg5c2tlNENJWmpCWWVDR29k?=
 =?utf-8?B?OTRzZUJWMndDNnVGdFlTTEZHZWlUTE5vKzV1WG5pdFJNZ3FndTZVaVFvSkVE?=
 =?utf-8?B?OWxHZDVseW5hTU9RcjExSkF4ZE44YnFHVmFlUzlHaWpRNGQ1Zk9xTGowQUZX?=
 =?utf-8?B?cU1Ia1hQVmZYVnc0ZWJ2R0txQmNRdmxUa0hTVEhic0NZL2tjWEZpNTZXYXJZ?=
 =?utf-8?B?bHRJcGd6M3FqeWNBdHJFdHY2T3RLa0hsZHdPZVJna1RJRkdTaWZWamdad0E2?=
 =?utf-8?B?WUxzcDhUM0p2d256WE5lZjNtOGJ0Skg4L2lJVDAwS3ZRUWVlRWxUUStTY05B?=
 =?utf-8?B?cDZ3NmNDNXdCRmR0SFZ1ZW9oM3FTMTBsM3IwcDZ4VzkwTVMrZWI1SlA5V1FC?=
 =?utf-8?B?bEt2ajdXbTM3aFJTNGgrZTVRSmNtcFkxVzZCOFBKai9rcksvV1NDZDEzSlZW?=
 =?utf-8?B?WS9zVUlRbGh2dC9kNkVEcFpFYlY3UUIxdFQ1YnhCZ3JvdisvZDd5ZnMrSHNU?=
 =?utf-8?B?ZktMYkphdEpESWRmYnJKSlpnYjgvQ3o1bmhpazgxRWJLOXh1VW5TTGw4eUZ3?=
 =?utf-8?B?d0o3UHBxQnlnZmU1bkF0Uk9RVW5VSW5pUmNpZU1rbUhYL0tkbkdmd1R1cjJR?=
 =?utf-8?B?MXBTdmIrck0wNjgveC9uMzlpME1LeUJGYWZsYW8veHZ6cUdUTnlGOUF5bFNq?=
 =?utf-8?B?dXUvRy9WTkwvQ203cURzcWt0L3VkM3FlTDAvb0hjOFlpSTNLRFJCSWQvRHFN?=
 =?utf-8?B?N3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NTdTelUvanpHU1gvVHVqbk5SdW5pelE5VTV2VE5vT3h2VXM2TW4xY2VRN0Y3?=
 =?utf-8?B?MjBvbGhiUTlzenptTmNUTWZlVE9YRm5TUDJyK1NxZFBibVhkVWRUVlFTRzYv?=
 =?utf-8?B?SjZkQUM3Q29pL2NkSmNiYzM5WFAxY1hMcWdpNEVrdERBUFhGcndVOEovQmlX?=
 =?utf-8?B?M2Zpdlk4Y1JHdUErNUN6eUt6RDlXZXpJNHBkVFkvUkdxWC9yZjVHMDQ5NUp5?=
 =?utf-8?B?cU5iU0pidkI1U1pWZnpqOFRGZUpRRWhkbEdwOWRWakswZXpRS2hVeUJnb1p0?=
 =?utf-8?B?SlRzRTN1L2RJMW1qNU05NG11dnhiZGx4Y0xOMTRza2EwdUd2UjdVVGVSK3Y3?=
 =?utf-8?B?NTg5L2FHdWdJanp3cGVXaEZORU5KbUpkUk45QjAyWllNVVV5b0ZBRjh6L0FG?=
 =?utf-8?B?cG5PYjdESnNGd01JVDNzMXNpdjEreWRhWkpBdnhiR1Rtc1JNd0x5M2lVemhZ?=
 =?utf-8?B?WkpxUisxK05qeUs0ZVNlVStXYkRESGx0N2xITXlvMU5JbEkyMUtTV1lkeVk3?=
 =?utf-8?B?aE55bGlGT0JFcEZpMkwxQ0VLUUk1L3pGdDdnRTB6TG1SVGZEQVFuZnpvaVdK?=
 =?utf-8?B?QkF4RlpoSGxZVU1KLzc3MzdIZlBSeEdBcjNNd0hFQjhsNHpuVWZYWGxOQnl1?=
 =?utf-8?B?aU9IWXIwMDhybmptM0ZwOW44KzF3SGljbWo4SlEyT3FFQkNSTldnVXM0M1Jx?=
 =?utf-8?B?TW5LTDU1WkdhelNRZTlWcXYra1kzSEt3NG9jVEJkYWgyNXc5WXFTeWZ3UEov?=
 =?utf-8?B?d0Q3aXVRSG5NQjRIMENmcmxRQncvdFNZVVY0RFNvUi9ham9RL2RIQ1pBZ0lE?=
 =?utf-8?B?amdVbnl5dy94OFJIRzVicTdtNHRCbjRKcVNIais4MEpOQWZGQTh2NHc5Qkhy?=
 =?utf-8?B?TEtvaXNqYzN6bDJyY0plTWJMSmtJNXZHMTJvTG9HTHdZN3oxSjF4UW9nTFJm?=
 =?utf-8?B?bERodkZ4WlJwL2xPRHgzczhGOHRmdG9hVjBLb0s1V2EveHJkU1lGT2pHNUZH?=
 =?utf-8?B?V1IrdjNYamRNazZoVmFYWkJBdHBJVFFhMGF1cFlycDlhNmhxYVRzSDNDMU9G?=
 =?utf-8?B?UHc3MS9CaitTcnU0SjdTUnpFTnpIZmIvNjU1ZEpzWTFvZFMyTmNwTE1kTmpM?=
 =?utf-8?B?QkZVY2ZPK3JyaFh5OVcyTTNOVTVFNFZtUVhGZlpGeC9VaGlyc2JUSCtibWZa?=
 =?utf-8?B?aWtaUEhVVXgzTytqQS96YSs5Z3dzR1Z2eTF3bm4vNFQwU3l2ZThsUDd1aFZ5?=
 =?utf-8?B?SWlxN1o2enJrd0VyNUE5OFg4cXFiOHJqYWZDUW1nOWVWempSNUVtTXdWQ1h5?=
 =?utf-8?B?V0ZrTWxzSkJsZGJSY2tMYXI1YTE1RVl2dTJBM1d4YTB4QmtGZmo4c1VBbWdJ?=
 =?utf-8?B?OGpqMTluVDFDdWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55cad06-75b6-4387-4efa-08db0b485aa0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 09:22:39.1562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yVwWlb+ZmpG84cUOX5YAk16fQEbnZk/Y4egIypOh8ZHhTqSnNZK/1DDBKX1yuXSrVVbMC8laqBBrtzL8uJDB2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_05,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100081
X-Proofpoint-ORIG-GUID: SIjI44lMekLy6tlHwmCRSLlfsBKATdJ1
X-Proofpoint-GUID: SIjI44lMekLy6tlHwmCRSLlfsBKATdJ1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/02/2023 18:53, Bart Van Assche wrote:
> Do not set RQF_PM explicitly since scsi_alloc_request() sets it indirectly
> if BLK_MQ_REQ_PM is set. The call chain for the code that sets RQF_PM is
> as follows:
> 
>      scsi_alloc_request()
>        blk_mq_alloc_request()
>          __blk_mq_alloc_requests()
>            blk_mq_rq_ctx_init()
>              if (data->flags & BLK_MQ_REQ_PM)
>                data->rq_flags |= RQF_PM;
> 
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

To me, this looks ok. JFYI, this is where I understood that Christoph 
mentioned that we are required to set both flags:

https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/20221115081355.GB17445@lst.de/__;!!ACWV5N9M2RV99hQ!JQJXru7NACJ7vH7xvV-26xPrgI4gDRZ8NP0Q9uYYKB_5RYq949y6HINgGq1D6prwH3V9FU21ntPhxpoi--Pe_qd2tz0$ 


However, to me, we currently set RQF_PM after alloc the req, so I don't 
see why just using BLK_MQ_REQ_PM in the scsi_alloc_request() call won't 
suffice (since it would lead to RQF_PM being set).

Anyway, feel free to add:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/ufs/core/ufshcd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> index 0cfe112ff8c3..3512dcc152c8 100644
> --- a/drivers/ufs/core/ufshcd.c
> +++ b/drivers/ufs/core/ufshcd.c
> @@ -9141,7 +9141,8 @@ static int ufshcd_execute_start_stop(struct scsi_device *sdev,
>   	scmd->allowed = 0/*retries*/;
>   	scmd->flags |= SCMD_FAIL_IF_RECOVERING;
>   	req->timeout = 1 * HZ;
> -	req->rq_flags |= RQF_PM | RQF_QUIET;
> +	req->rq_flags |= RQF_QUIET;
> +	WARN_ON_ONCE(!(req->rq_flags & RQF_PM));
>   
>   	blk_execute_rq(req, /*at_head=*/true);
>   

