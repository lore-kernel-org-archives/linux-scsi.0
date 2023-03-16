Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AAFC7618E
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Mar 2023 17:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCPRms (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Mar 2023 13:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCPRmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2023 13:42:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFA810EA9D;
        Thu, 16 Mar 2023 10:42:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GF9mHZ012743;
        Thu, 16 Mar 2023 16:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9HBueDLVavlAtOd+KKGnmTlIOT5vnE7oNZotX+4zR/g=;
 b=xOepqlJLAdnedrz5J7d4Iob2qUvsb2S+yEI1fr8Mls6LMyoQqX62mCjkF/L8KteXGG0n
 8pWK21X3OOHxgPs36YKw59yBLM+/4zXzb5I9P/b8dc76BXooh+du0wZIeg5q+pxV7HG5
 CENTiEuEmrdGRrrTKpwjDuIu7uycG+cZWtBZhRPTwpVZ8HOYAmG1qshl0tZCqPlZ2ODT
 jpAQK7tDfFuayAsthW/zpZH8JjCtwmkoU1JIvl5TBxKvQPozi9kP8Kmc4W022wDcSntn
 6QkwfDdTvXG2OUn2gLthgRfqOrvPyI4ZwTyz8rCv/VHIzyaTAKaLvaSEyvQimsMqlz2g +A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29snna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 16:36:17 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GGDGV9004928;
        Thu, 16 Mar 2023 16:36:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq452qsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 16:36:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f2LLzMYLsbbuRD9NcSW6HOvr+3YOITWo1Efwuy/j9pLmNCPpggBNrJezpsLBOmEHo3hQvPSDrlHQ1ywFhPs3iYR5obTMrTu5WkS1PvpnUNRMOSw37/rK+TjY6RSyD5TjFuS0C/xJS2zmiq2BEYmMzHVU8tC/AFA4y5BQvKHsXfrMY3IFxlY0S4cdd5bhbJq33EdxPdgX1K/hEhBjajtOdfcFZH90tLMouiZo3Jx7QJPjRwzMG0+DPmit/sRvF8qRQtuCXlvywJ2F/FB0FcsRyq4muzwfWlMz/g+sUgBkosVOK0K0S9zr2WtsPvF2WvoMN78sWIWkF5d3mBSinLY7ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HBueDLVavlAtOd+KKGnmTlIOT5vnE7oNZotX+4zR/g=;
 b=buQraPuRSLPlY3QCDMxToSLn7c7ppqPIS6lSzSu0yV0Q3t9sos7B4WKHM5xlcn5JDwQ2iKFHGuehegPhCIZd0nrjY9VYXWLxKACqW0kWj4Me5ZAy+ZLUHcZkelFSG24Q2OVfHdO7S9W/xIeJSaTW5icHLeyn7vy52imdD+TafLFP2irjtOxWeiOuL/NdfZb2PTp/6V4G/xt8LAXKsjGvFjBqznjJYkqYkbnGIcQfRPLdBGZ+Mo5zaHk2LwgjptzvSBmn4+fZmNR1DFqcTjHuyqk4ZqKogdLj1E5I8nonedCcfLXMnr4BPJypykaIjoQglZdBvox6Fg28uMjLrlQ+qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9HBueDLVavlAtOd+KKGnmTlIOT5vnE7oNZotX+4zR/g=;
 b=J+aw8lIDZEbFdhnQWlUtQYLvgtfDhfPCOh/YPsWW/hCpnIpcVN/OPqb1yLaKIodjfTFkv31pvWs+9o7nUBDDmV59u1EzoT+F3ZyZbUzQTdoT6E2fqlPF+Qv7jnChbMY1eMs3pnQnPYmRnVZ+F0iYp+GHVXADXHDX1q9j+bRz3uI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB6722.namprd10.prod.outlook.com (2603:10b6:208:440::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 16:36:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 16:36:14 +0000
Message-ID: <6da0ec0a-d465-fec4-0ca5-96b2ffb7be7a@oracle.com>
Date:   Thu, 16 Mar 2023 11:36:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v4 02/18] block: Rename BLK_STS_NEXUS to
 BLK_STS_RESV_CONFLICT
To:     Stefan Haberland <sth@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org,
        Jan Hoeppner <hoeppner@linux.ibm.com>
References: <20230224174502.321490-1-michael.christie@oracle.com>
 <20230224174502.321490-3-michael.christie@oracle.com>
 <20230314171119.GB6780@lst.de>
 <33ed9615-b570-03c7-9a7a-d07f020d3222@linux.ibm.com>
 <20230315133039.GA24533@lst.de>
 <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <4484f553-84c1-5402-4f52-c2972ad3e496@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR02CA0114.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::16) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB6722:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cae15fe-77ef-4875-2157-08db263c8eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KRgJ/E41j5PiKV+98Jz4W0anXd7e2rzN0HdGVF9zRxm7+6H4FaAjPnXaEYhxoHnEWoUs/ee8rOPitk22J+3JU3Wd54LkveWoAKHuDlW3wXs/r7GuXzUz1puHBGqLp/O/Nyr93i4tGI4owRbnSxZSM41YH5FyAWah+MISqjejqkBkXCVHMUPQWi/H3L2B9GAM61daMeO9iWDhqO6mBclbgsqTcL+WEatm0JCD3HvYwXRpglxgo3snpplhaIQf7lt0Q4UgWddueyoCFJn3Uqlt39eLph36WHrAKSiR7zvGPRIdUGe0mIV3CpQwCodIC1QFJXV8Bege4FeRmp/UFNn3mHilxvQCY7D54KkRJ9dkQXSlC0j7nnETKlpX+7Di2pjfNECiLCCBbjF4Fyv5VXz/iYlqpqPyLrvUV1SN3AnI0pMt0w4VnhNxwH+/oCYaSLfvaViCs+F2HS7iN554S1pz7er+IOCc/IBObdUcn8FiV745ae/3ZqzrtzZM/lvVUmq+DLj/19j0O83mpNd3FyRqkWzSzY69odhQAlZYpAKTAodg8FANyifVrtYZKoXs+sBUQH5lzIm+yiFjNQ3ZGi12U6vk53+Z7diKTx3+2bEbwr+TjFrKqye7xmasr7qZysBLajEgiW/PrEPRxC3ks/5u2DwFG3lagMAIZp46wFtAS9AsVcmGf9RK1kVw354HJ6mCm9/H1Uwfy7yFBPGqE/CRT8mkJUgJcSpMfXCzWEGMhEQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199018)(2906002)(31686004)(41300700001)(5660300002)(7416002)(66946007)(36756003)(31696002)(86362001)(66556008)(110136005)(4326008)(316002)(8936002)(83380400001)(38100700002)(478600001)(186003)(66476007)(26005)(6506007)(2616005)(8676002)(53546011)(6486002)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bkZEeHR2UEo5VFZFaUE4WkdabHBpVXpxdlZzRkFWSldERWZOdGw2MFFxbFhS?=
 =?utf-8?B?eXlvL0Y4a0dYbFdkT29IdGFBRHFoU29YTU1GdVRtZVFxVzRpOGJTUk81RHZ6?=
 =?utf-8?B?eGI1SlJLL203RG42UUpLTW50a09WcVgrN0lpMGhBZ2UyU3RTQ3lZcGdWbG1W?=
 =?utf-8?B?cGtBekwzMDhlVzJKelRTSkluRzFGT0xHcUlBQjFQZWUzTkhrOHJWT0RRb0o5?=
 =?utf-8?B?T2NFYnNrbEdXcXpLMnpzcXZzU3d2UU5aNDdyN1NrRDI2NURxRkZMRFJxQUFq?=
 =?utf-8?B?NTRZRnZKK0NkODhObWs2b1N2c1czcUt0UHYxUnpMWFVCdlU0OCtTU3lHZDhy?=
 =?utf-8?B?cC9aTFhIUnVSSmFsYnQ1Yjg2akZ4TnM2cURtVUNQTVJMYmxyN2Y1VGZja1cy?=
 =?utf-8?B?dkhtWlNFZGYreURMZUZ6WEg0ZXgwOFRmbFpJTVE0T1dCL1Bud3RSSlJQT08v?=
 =?utf-8?B?L3BybG94czczRXpFbTBadjgyR1FJQlZOclU0ZnJSRVpOcVFCYnJiaWx4dEdC?=
 =?utf-8?B?V0lYNXB0ZmtkbTlLczJzc3hlNlRPNnN6cE5pOThmdTVwbitHekIwM0RLdUJh?=
 =?utf-8?B?cDRDNG9VY3V0dUl2ZGVxcmFDMDY5OWxxbkRQRmtnRE1yQlpYaGdPOEZ2VVNG?=
 =?utf-8?B?Z21yZVNxYnoxcTZuUGtNY2hwSnNLYUdUSzNkMFFVOVV4aDlwWU9vRFdOVksw?=
 =?utf-8?B?OWxqMDIwTTNvL0pZbnp3Yk05ZWJHWUhwVDRwYnd4MmFlRHd2NHZMcnFaTFlM?=
 =?utf-8?B?Z0dIR2NDazBtcTdYNTUyakxLY0xyalIxOE95Y2Fra24xZGhFcFRVTEhKWmxC?=
 =?utf-8?B?YjNkcUlnQUdJQndGbHZmQmtnOERydGV3SUp5WDFkWWxZbk1wc3RwY2R4VUFP?=
 =?utf-8?B?c3o1N0tackFyQkgyNi8vNEdrYzV6dlF0ZkpLaUljK3FWMWJ0dWsxVXdseHJP?=
 =?utf-8?B?d3BMeVQrblE4UjFwN0tudmthSyszazJYWDJGZ04yZ09rbXl2S21IaHZjenpT?=
 =?utf-8?B?ZWk2ZXI5ZlduNHV0RjhFcFB2SWRJaG5ndlVpS3F5a0E1ZUN4NTZOSFByWnNs?=
 =?utf-8?B?MEN2ZG1BNldLN3pvNEgxQ0t6LzhoY28wdDNNUWZpd0VxMGdUUkQ4NThEcUdW?=
 =?utf-8?B?aUZlVWl6MFh1VitobkVHVkFFdEI4QTFOSVhLL2FZbkZKaG9uRkY2ZmlRU2lQ?=
 =?utf-8?B?R3QzMWlocTNaOU93aUhHTm1HMGp0c0lyMjQrTXlqQnpHcHRTNHc0cWQ1OGdx?=
 =?utf-8?B?MTZzbkM0aTY1K3U0a0c2cHQ4RXF2QWl4b3JjTVBFZS9YeFVsTXprcDZya0Vp?=
 =?utf-8?B?dXJ1MFNyOXpBVWtCYlBRL1hPNFFtUU50MHVrc3RyZUVmUXEzK3RxNlE1RGdt?=
 =?utf-8?B?eE9Wc2JKdlJocEt6UWNiNmliSllHNVBjMFA5c0VsR1lWRWN6eWMycmNZTnlZ?=
 =?utf-8?B?azBEVzdZd0JMQTkrNEpyc0hvbGoyS1hFNm5QNHZmUHhqMCtHcnExU2R0b3Yw?=
 =?utf-8?B?WU9IRndKcXZjSUJVTEJlNEdVUS82dHBNdzM2MS82NHlHRTA1UmRYUVovWG5s?=
 =?utf-8?B?QkVmV29XbzU4ZU9yTFBZT3lvZlNWaTRzM3pVbGRMbXhzMklTc085R21UMWRR?=
 =?utf-8?B?MFA4REs5a2g5WGlwS1U1T1g5cm8waXpIZjlVYlNIMWNIcFlSbWs2dU1Rck54?=
 =?utf-8?B?M3UzQXZ2eSt0OEhNbWFUYnU4RUZtZTgvaURJdXpta3RRaXAxcklHL04reitC?=
 =?utf-8?B?TG5aa0hLUFBUNndNVmRXczVpTStnRG1QUlpIb0NhZ1ZkVGNaWUllczFRKzBl?=
 =?utf-8?B?WkI0ZDRWUDIraERXWCt3ZHQva2JTVHJPN2tNWlNmQ3pGOEs5Q0MxQWFtMG1s?=
 =?utf-8?B?YkJMaUVnMHRsa0tObndlS3g3Um5UYzl3Q2x6VUlMQVNGRVhqR245eE90WTdh?=
 =?utf-8?B?b3Y4clR6S3czSXkxNXpJQk5lSTdoWm8ybjg0YldwMHdpMk9oTmtNSVRRNGIw?=
 =?utf-8?B?RDBpMkNnbUJXNCtUSHg0YlFkYXNxVEpVWEowV3IzSUd5VDJFQ2NJZ0RxZEZ5?=
 =?utf-8?B?U3p3dzM4dWJlYmx2MGQzc0JOR0E1WkVVVGhjc09QSmwzUUxBN2Y4ZTlzbmQx?=
 =?utf-8?B?ZmcrNzVpa1RISnRDMHNXTGthdHNMMlo5VmV0Vm5aMVlzR2ZReUxFS0FVTkpK?=
 =?utf-8?B?NEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VzV2OC9QVGtaZ0N4Rm0wTlRyTGR1b0tPelVDdVlWaXFpWDhVQzJ0MkFWdk5P?=
 =?utf-8?B?MlRmQURUcXRXK1NjazRsUmpXaDlObWJHMVpZcXJCbTRFWmtodkhTYUJuZDVP?=
 =?utf-8?B?UkRncDJDK0YySTFCQ2hnMmIyVnh6NUhLQmFwV0lpcFRHQk9hSGtpSmJBWHlG?=
 =?utf-8?B?bll2b1ppNHVXc2NCQ2Y1dGlRMDNmWnRRY3E0c1MySjd4aUErNmZNKzJUZGNR?=
 =?utf-8?B?OG1adzVCMU9rK0NiemxNWUp4TlNWcm1sNWlPWE4rV21Ca3JFZEo1eHpFVHZ0?=
 =?utf-8?B?eFVIUWJlQk1qMTRqcDJiS1MweW04Y1lZRE9HZG80V2VuK1g4Q0JjeUsza3pl?=
 =?utf-8?B?UzJNK1JhU2tVQzE0RjdZc0RDcUtoN1NUN0VQVHFaM21IUnc5T1N0NU1jUk1Q?=
 =?utf-8?B?MUNQT0FhbHNwWVg3VlFPYjdyRmpNSm9KcHYrRHpnV3l2NWRvOXlVSzhQT1ZF?=
 =?utf-8?B?Sno5eFFnWlZ2QXV6czgrdllxTklweVFuRmlZRVBxQUlOaTEvSm1SalBlSm03?=
 =?utf-8?B?UmE0ZGhXMlRPODEvc3l1M0hwUGNTcWlzdnl6KzJQemR3V0V0YnQ2QjdlT1BZ?=
 =?utf-8?B?Ulcwc3lERWt4VDVCdjBsYVJDcm1OTFBGM3BjY21UaDRZRnpxMnVscXBVRHhN?=
 =?utf-8?B?V3NkSGUxN3BZUzk3MEtxMFZ4ZTcxK1FyeWpYNTN6OERJR2VSNVRXMVBwQWY4?=
 =?utf-8?B?eFhDQ2tmdXl3SkVKMUdUYmNMWDFpWUhQMHRBTWVIRzVuMVppN2tIVTVPa1c5?=
 =?utf-8?B?Rjl4cXZPcDRicWJRUEY5ck5pYVN1dG1vdjVlQWcvazdNRzkyb2NZVVVMSXIr?=
 =?utf-8?B?ZGk0bFhaOStiaE9Da0x6cUQySURDbVFFSExORlR0cHg0cHNpY1VYaWF1ejIx?=
 =?utf-8?B?Q21hVEJqZTVCVmNNUk9EZFBIS2RmVGtGRFVCbThRZDZwNFRrcm42Njh0WWxU?=
 =?utf-8?B?RE1kdk5laXd2Rkl3azhMN1Q5NGZOWE5lL2czak1rYlFYczZjdXp6bXpZaGgy?=
 =?utf-8?B?dGxLR2JZRDAxMm5FQ1FTVitySEJrY2dpc3ZmdEJWamthb3RqN2t3eG9DR0Zz?=
 =?utf-8?B?T0p5QXYvWmFuRi9Ga1d0UTZsWmZiNGxUYVFrT3dMcUt4ZGkvUjkvM3dUUFNW?=
 =?utf-8?B?ZVFpQVRtVWViRm5WUjB4NmtkbUs2M2ZUVXlVVEV2RWFiZDVURXZMTndHNS9K?=
 =?utf-8?B?bmhqTzdFRW1nalB3cEcwSWdpbHVtTU9QY3Urdmd2T2NuRXJ1cjY5NW9xbGZ2?=
 =?utf-8?B?TDZPZDVLL1BXcXZlWWRrTzZoNU96M3NFbmxvUjNIRzNHdng2MXAwRjcyd3Zu?=
 =?utf-8?B?N2VlNlc3MzF5alRWZjBZZVc1cTNacXV0N2lSUkp4b29pNWZ1ZlFNVHpKZ1Bm?=
 =?utf-8?B?RWg2ZnJrYkRNb0J0V3YxY2N2QzVFMXJZUm9lSFM5dUlqSjVVYlZtSHc0TFFr?=
 =?utf-8?Q?kVKGtH2r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cae15fe-77ef-4875-2157-08db263c8eb9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 16:36:14.1510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M/LWbydvrcN9O67dDTEglVbW6fh3gnzNBkow2ofEYcnC3hEOMVD6RBuXTRa0oDYVMjvXlTnh76hWMWYdOMT9nWk/5AjYPnzBinlEDpnHtiA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6722
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_10,2023-03-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160131
X-Proofpoint-GUID: J7xblq_27tnTtfufmdtAgu43xVFFK8L6
X-Proofpoint-ORIG-GUID: J7xblq_27tnTtfufmdtAgu43xVFFK8L6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/23 5:17 AM, Stefan Haberland wrote:
> Am 15.03.23 um 14:30 schrieb Christoph Hellwig:
>> On Wed, Mar 15, 2023 at 11:04:22AM +0100, Stefan Haberland wrote:
>>> This also fits for the DASD case. We use this error code for a
>>> reservation/locking conflict of the DASD device when the lock we
>>> previously held was stolen.
>> But that's not really a reservation conflict in the sense
>> of the reservation API.  Given that DASD doesn't support it it
>> might not matter.  Do you have applications that checks for
>> the translated errno value?  We'll probably at least want
>> a comment documenting this status code.
> 
> Well, I might completely misunderstand the use case for this error code.
> Sorry if that is the case.
> 
> Beside that I thought that the return codes are generic blocklayer return codes
> and not bound to a specific API. I am not familiar with the reservation API you
> are talking about.
> 
> What I understood from the reservation in NVMe context is that a namespace
> might be reserved to a host. If there is a conflict with this reservation
> this error code is provided for the IO request.
> 
> For DASDs we have the possibility to reserve a disk for a host. If there is a
> conflict with this platform specific reservation we would present this error
> for an IO request.
> 
> This sounded quite similar for me.
> 
> I am completely open to using another return code and I am not aware of an
> application checking for this specific return code.
> 
> Is there any that would fit better from your point of view?
> 

I think we are ok for dasd using BLK_STS_RESV_CONFLICT.

It thought it sounded similar to SCSI/NVMe and userspace will still
see -EBADE because the blk_status_to_errno/errno_to_blk_status will
handle this.

There was no internal dasd code checking for BLK_STS_NEXUS.

There is a pr_ops API, but dasd is not hooked into it so we don't
have to worry about behavior changes.

