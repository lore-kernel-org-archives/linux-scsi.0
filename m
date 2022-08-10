Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ACF2C00140
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Aug 2022 17:38:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231578AbiHJRi1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Aug 2022 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiHJRi0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2022 13:38:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E571B832F7
        for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2022 10:38:24 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AHERPf011232;
        Wed, 10 Aug 2022 17:38:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=z7iz1cTYSnkOK6X38ok9fxtRBHdWspeDomRkG4TZZ1k=;
 b=EzJvgHQdJmv6j95ZCvW/X19ZiT975pbfpUAh0HJyxuhzvRuYTblgoTFu66MosoBPBPGc
 CdhLjTq4M5rjjAJpxDyrQsD58db7NMIp45FHf/ozoFm1ychF8U+NXYpwyFzWe3mrcTK/
 bEMGwWaUDBXpVGGVoXnqai9UjPFFZIcrmRcrvUcVJ3eqGrKkJy4GQQs5R3IC5Yk1LpGE
 yDe4QU4zFKUcFpPdCKtYSzZ3OosqFRqEio5XOC0+NJ9eVWX5kJpYiffMGP67XLPNgZGT
 6fj/Cd7bwXbxuAIQjXvzUnvK4GaIArd/CcK6BLn05WLh/6fXs9WQYqxqclIc9uu9CpmJ uA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3huwqbjr2f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 17:38:13 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27AFBOVx037318;
        Wed, 10 Aug 2022 17:38:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2046.outbound.protection.outlook.com [104.47.73.46])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3huwqjc3u3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 17:38:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IhJOAHYgoYaZlp53132bUMr2wP8hZQM2xSZFRisfUZ9YUaYZfRTomBRynWE2FSu/zq1Sq1TSQtqy39V92NykreayDbrSMopxss4BRN53b87c/xBWI6So0kQ6wSenx9/qGOj2kdtP5MbYxIILk8b6hYZ5iKBXBvOlAlRwI39m+NzJiY26AWtcOFBl/1y1d+S++gLePFs8zhCL5du+yuhYcpTL1zBESRvPkR3yEoKXJuL/GHzKJpmDaicWKXCtSNZFQySuN3z9ZULCaN4yEoG0D1SnVD501eOrQbKnc016md5UN55+7iWxtxYB4WbUNZL5Rs80jyahAqt1DbO9Vck2wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z7iz1cTYSnkOK6X38ok9fxtRBHdWspeDomRkG4TZZ1k=;
 b=OkCR+kXz248ZHoNZeb3hKY6AmFm9u0LfPw9K46NnbFxOwbQOL1V6Aov5bVQJVZo52Kwu6EInuFoIapQTTFbgBwoxyAMdvZrr7FE8ERAvwCt9yNSduZQmLjXKN6kaTO9LFLVGKYBLpRfmUjA8ehdhyv2aokiFRpeIX8PkXC7fm8gu76+28wBq0JMLVWM/WBEyJKbvkwNuGd+KYaMWX6p/qHaKdKN5rnRE3I4ummpUvMqQyz6braGPdrvMmSDLUlCrStBfizkO0tXPgnqZQZfEOia/P4pzYp0+Hp9hJH+pQLwnu6vcr8bSNqEA4YYbsDaX4q2H4G0dFbefx+ijf9z88Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7iz1cTYSnkOK6X38ok9fxtRBHdWspeDomRkG4TZZ1k=;
 b=bhf/ZtX/bN8H37K9/V3PRArPYWNtXMK42H8TE9alyShMfmQOkvwZjgStB6+7M7bqMFChQxISOoMYV5Rsu0XYlzcQS6XU9WHfYdhX+42L7lES/xuG3Why+uAcAeXJF33VY/FDwEc9wGsv1I6rnkfJOvSv2N2aeBH0h/eV/axBhvQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB2843.namprd10.prod.outlook.com (2603:10b6:5:62::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.17; Wed, 10 Aug 2022 17:38:10 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Wed, 10 Aug 2022
 17:38:10 +0000
Message-ID: <2b33796a-b504-f0b0-85cf-09383543fbcc@oracle.com>
Date:   Wed, 10 Aug 2022 12:38:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 3/4] scsi: Internally retry scsi_execute commands
From:   Mike Christie <michael.christie@oracle.com>
To:     Martin Wilck <mwilck@suse.com>, bvanassche@acm.org, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Cc:     Hannes Reinecke <Hannes.Reinecke@suse.com>
References: <20220810034155.20744-1-michael.christie@oracle.com>
 <20220810034155.20744-4-michael.christie@oracle.com>
 <6149f7bdfa013e0352e59dee2669298b2c080a03.camel@suse.com>
 <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
Content-Language: en-US
In-Reply-To: <2b1943b2-466f-5674-1c8c-7db7b2dc4738@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P221CA0036.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5bcc1225-72ff-4f86-f245-08da7af717b9
X-MS-TrafficTypeDiagnostic: DM6PR10MB2843:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PxmNAHvU1+4iUzhg84lvPAdt9pykdZLDDpL8cIJxEjV5f85q/7gUGCUfcS6IbdxqxWY22n4X6eqQ9rxaASaZNxCyxRraNEloQxhoqLNJ8k5SkAtKgv8qrfqwf8qO5K/17XJ1qYdgXlgUuzrwfW03OXyd3ojOd05YIR1cx/0ApAU+DC0BtmlZFd2a8hbmBkrTHkowzn8hugmIoB8tM81N497NTVBlFgPnuDk717UHWvDNcXV8mprVgRcAUJF4Dtj3TNuOeXxWtoBXszsslQLmXQPEtiSZDM4mKgsf2bpMFyDNXzTBlVwoznva86p700Wr9Xf+Xqe/KQiFrcfT81r/CpRq7l7KzwHjyqM/U3eZCalRZ4kY21Dg0ptwkUIUOmfcZb5Vaj7RSKeGOXJWn5NaWiAAPokeI65IoRQDAK7BTP358dsNlHepKojXGZpWt2N9IDpdCwYcRR7txBBQl21lY6RVJ5WOr8MEwx1xqzJeXe/dwoBwDKQGuK8DVRWo2Ddoto33KdmWv/s+KcLRN64K1EhIn8U/45XvkB9Gk8hdUXzoFACPXmkdjkiWTtO8/mEdJf5gR+POF9UWkd7xGr2w1R2AxTvYbH3Mpnv8vwgSZ0cTj8I9cUyaNGBfk4dc1PsNUU+bfcJSQ6a5kgAGJFFW1pC+VijpuMllcU3uOspSIq2u3GrfoCSx1GIZp18qEYv3GiAOyMBZ1/CQb44P3q9SmUgHy/BcqqG+3ZFuinvUcAVjHGKZg/XUiJR5avVX7HP/WG3scOXE53dBpXUR6R2D9LzrnjyNz0xVdeY6EM7Ha02oIU3h8nZR5xE8cfHIyOHnKdiYXvPmx2AznEBV2J8lzQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(346002)(376002)(136003)(316002)(86362001)(38100700002)(31696002)(4326008)(66476007)(66946007)(8676002)(53546011)(5660300002)(6506007)(2616005)(26005)(6512007)(8936002)(186003)(66556008)(36756003)(478600001)(41300700001)(6486002)(4744005)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVV3ZURPVituNmorZW9qSCs4d1I3MmM3MHZjMlMwWnRzREJ6ZDgzMjB1MElJ?=
 =?utf-8?B?ejdRSFNYS2RCTkVDRlFMaDU1NUFZRHBtZWZEZXdiSU9ha1d6dmJLeHZyQVY1?=
 =?utf-8?B?dnl6TU5nT3owL3B4MXpvMWpZNklESFkvUHhxbWttY2tRRWdVTGxTSzBuS3V6?=
 =?utf-8?B?dk1EU0NFYXNRNzczRGZwcnFOdFRqbFF2d1ptYm0xZ3NCS1lZNGJQV3M2TEQw?=
 =?utf-8?B?dmdrODBFSW52MWhzR08yUWdpdURwTzhnVGxhZDlXZmszb1pPS2czUjdrRGI2?=
 =?utf-8?B?bTk2ZFFNRW1sODlGZnYvR2NUVmJEVm9QSDNCM3hhRm1zS3B1NjhkWUlwYWd1?=
 =?utf-8?B?TlZtdzd5UTNhaTBFbEVrZE0xUys5ZzRsVDYvS3RkL1MweVJpSi9hQlhMc0xR?=
 =?utf-8?B?UHpjMlFBTGJzTjdMemZDTDM2NmZrbTE1emlQL3hodDR4dzF6clVIeGxLdFlx?=
 =?utf-8?B?WUJxRVFWUzB6KytnK3oxbE9tYWRkekRXSDBZWmVUc3p3NDlIWmR6TVBXaTQ3?=
 =?utf-8?B?UFBRRU1PMWZ3dCtRc252cGNmYXFkbjQ0SC95R3hNYWxoSXp4MDZ5MzMxOTEy?=
 =?utf-8?B?YkR3VVorTEovOWg5SG9wclJJWmVNYmxHS1NLbkNPdVJCTHMrUmd2MldJM0w3?=
 =?utf-8?B?ZUh3S05xVXVDU25GZllHK2RzTDgvOFpLaUJzSnAzcC9hWmhqWWNiRDNnQnRu?=
 =?utf-8?B?d2VGdEtyWXlQaU5nMVg2WlFRSVNtWW1mL1E5ZlV2aUJBVnNVZXJyN2svcFk1?=
 =?utf-8?B?bG5VVjJQVWxQTjJRT1Q0Q01GSWtWMXA5Vnl4b3NTMzVBYURVQTB5bGVKdnQ4?=
 =?utf-8?B?U3dESVB0UlA5TDIxU2VZMVNkSG1ReVM5V1BGeVYwSDlLUWtNNDRSVzJrSmht?=
 =?utf-8?B?Yy96RFBTamtwV0cyUWlINTVueVhpTTJTdXpyRmszaURzL08zK29vY3hDOUFq?=
 =?utf-8?B?VXM3Rk9rSjc5VTBWdmFYQ0xmQUs3Zi9vMXpKR1VjN3BxMC80enpqc3RENzhP?=
 =?utf-8?B?biszT1RPVnlUc0JoMHp6ZnR0NmgxcnBYQVdVWlJkRmExUGxZU3R4Lzh2UFo1?=
 =?utf-8?B?aDZ5RGtKNU9Jd3gyL0ZSWlgrM1hYcTJRQTdodnhYTWcyY1h2bDB3T1AyaU1s?=
 =?utf-8?B?NWFpS2JmVTdoTTZ2bndoQ2xRbGV6RXFSam1SUHZ1c05KaWtxTmhMaVZLNUFJ?=
 =?utf-8?B?bXpPaStTcXhWUUFrS1ROS0Q1MUZLUTgvQjdCTjRWNHVKa1VPOHlLUVZjMTVn?=
 =?utf-8?B?bjRCbnlzZVVBelcyVEVZOUtKdzhmaGdieDh5c2RlcEpabW9LUFlROGNaWDJr?=
 =?utf-8?B?Qk42ZnpxMk8rbHRReGd5YUlYUXd0ZklrN00zT21VOSt0RHlxazNneFQ5SDdI?=
 =?utf-8?B?RTY3cVBZV2Q0a1VoNERXNlkyR2hTMjlsYnBJUktpT3h5VkNLMDZpdk40c1pp?=
 =?utf-8?B?YmYvQjZUT3dJNlZvelFhYkFUelBLVjV1M0tMUENuamtISFdmSi9icVd2UGVS?=
 =?utf-8?B?dVBYeXJsTTFFSzIzT2hNK3JKdDFjZlFWNi94MklKUTRnNXlFaG9MaFZlc1Js?=
 =?utf-8?B?RFdTandVdjRQOGljdFlWVWhSczRlREQzamphZlVIQ09HQUpwNzdMVlhwdkU0?=
 =?utf-8?B?VTRuSDBmNTV6bkRBQUlJZnJpWmpCYUNHenpCOFZBZ1JON0JWQm5ZNERrV3dD?=
 =?utf-8?B?UWFENU9YSmJ0cjhUUmM3NlczaitWSUsvMTg3V0UxRDJlQUt6cEJzckhwWjV2?=
 =?utf-8?B?K1g4WmlzS1BKeFV1OE1uOEhDM3lodGFmMktTdHQvYXh1NjB5ejliMkhnczFn?=
 =?utf-8?B?QWtBSUdxREEzekJOZTlybEJOWi9lVXJ2c2RNS0lJM092WG9WaFlORkp2c2Jq?=
 =?utf-8?B?dkdqZWczUWZodktKcjRtUVRFODJ5RS84ZE5YVE9WRzF5RkpFdU9EaTNxaXZn?=
 =?utf-8?B?VjVQd0Y2ampRWE9WSk1ESnJDaGljZEYwTHVNd292MFZmWklmTlJtaFdOa3pk?=
 =?utf-8?B?MjNMMDROVlBkTnRSQW0ra3ByZCtVK1BqTVlwWlEvRWtDa05ORGlJRk1xQ053?=
 =?utf-8?B?NFFIOWtaUWRzMjlFZkZNQjNBczhRVzZKTWUyQjJsTzAzOFdaUm1PdVcvQ0Jq?=
 =?utf-8?B?dkxYdWMyUDdGaHp5bnFNNDVOMU1zTW5JenNsemg5M1kvaGY3K0xmcyt3ekIx?=
 =?utf-8?B?ZVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bcc1225-72ff-4f86-f245-08da7af717b9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 17:38:10.1325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DauvJi2H+1YXv5vz4xVn0KBr2xz4h2o07Mbi9e8zri4g7iEQSKzPUI7U6qPorTCEpy2gi1t18DbW2a/G0FmxBtM82leNDoSmafmWRI4iGpo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2843
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_11,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 adultscore=0 bulkscore=0 mlxlogscore=975 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208100053
X-Proofpoint-GUID: aKMWR213DTZ6K351EIaN5K1VXkqKKyEp
X-Proofpoint-ORIG-GUID: aKMWR213DTZ6K351EIaN5K1VXkqKKyEp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/10/22 12:06 PM, Mike Christie wrote:
> I think because the cases scsi_noretry_cmd is used for are really specific cases
> (scsi_decide_disposition sees NEEDS_RETRY, retries < allowed, and REQ_FAILFAST_DEV
> is not set) that might not be very useful. I'm not sure we want to add a bunch of
> cases specific to scsi_execute callers to scsi_check_sense? I don't think we do.

To be clear, I mean for this approach to be generally useful we would have to
add the cases scsi_execute callers are retrying in scsi_check_sense. We could
then remove the scsi_execute caller driven retries and only have scsi_decide_disposition
retry.

It sounded really nice at first, but to do that I would have a bunch of cases
that might be specific to pr_ops, alua or scanning, etc. Then I also had cases where
user1 does not want to retry but user2 did, so I have to add more SCMD bits. So, in
the end it will get messier than you initially think.

