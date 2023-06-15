Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA70EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 16:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjFOQVL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 12:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbjFOQUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 12:20:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A782D7E
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 09:20:45 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJZJZ028817;
        Thu, 15 Jun 2023 16:20:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DI1ITVmN34O3G4n758MZs0jj9WkCQvrcvChW4Bz1LwE=;
 b=qA5R8185F97pZ75uBa3bGHh3BojTEkdIVwJPMRE8yXZuv8mu6Q4VnwTsOmLCbtz4oeih
 oM/HCXdqlTS5JV1tAEsnNdBBoswGYrJZr318XzXSlMVCsG26A8Ffs+4IsnmwSEC7amZ3
 n/BjawsFKFP6iPb25RwggeRK+td9pQfbaSWxcRyVVIVcduZ7Gqml2i7eE6Vq4FQMSOC4
 8TCXxKRTMOj4E1L+E6guxACUMA/oBaA4pOrA6LfogNYvKNX7bHraopD6ApA/gOBh/lA6
 2gYKhdSNLdXd3OuHAV+ru6vp3J2oKQV3r+fXkjQdw0vtlOeyw7o6VOsDpUuZTvTLAet0 0g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4fy3jetv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 16:20:35 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FExsKi012403;
        Thu, 15 Jun 2023 16:20:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fmde2cp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 16:20:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACo2MgqDeIYvVbndjrfOEGNe92gQRHyBdXjW3ZbpGTPdp/iyy7859yP1O7G8P0KVy08EjzQPANyFmDCN54FKWuZXKWHqlDRM2JkQ/X1Jq54JK0jEMUKebgw4XAYNMHnnCmIBT4J+KcKdBmzvvDI+rfwZjnKeKcxDqeaMeUSIu0Zo5IgZ951J+pz3ZobYkSJKeifkxrW/OEnmvGs+PNYADHlxigdYp7RRAmv6le8UKVOPU1wRrHo1NYfMKz8KsLxFtzkv+6P04hKPAgT5yEBfTunAESavYYl9/4yho4t0OhK0rPFI8qBz6xibNhfG0B5TsBj4C9NuGTZ7WNK20Jn3wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DI1ITVmN34O3G4n758MZs0jj9WkCQvrcvChW4Bz1LwE=;
 b=K9bbZS+9+sBege+SJAaTeLPpb1MOscl5oLz+cLFaBIJ51Eb2kwXGA4pPDn82DK3c5K1A2aBgDK0qesUhDeZwDQnS4cqhYg/xDyHc51AnmT604CQfbvLbCWbHRPYXpIR2pjtRTpnDvquWu+gitEU/A53ZWcP3A9pI3G5xaBgTeZHdCWYBavhWojtcl+RruQb3bqVEFoOA8DapdBaJCkt3nh1DCAtUOhSXUwiDnZlJPBIpMFshM6pPqvkaA9m8ht/dCd23txxGe+M1u+21e5ckB35TWBUKAe6BlXZl97mECtM9S6/GP/rJxWxMgwGbuiu20yRZNxep6CXPgizS05VDkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DI1ITVmN34O3G4n758MZs0jj9WkCQvrcvChW4Bz1LwE=;
 b=q/AeIE+XLZOwdGxeNCXGFH87siJJZTpkSczxu2LviOM4kLk4YrEza1qFIMg3fG7D3jsuSVQRPWgG1xhMAZtRVOzz7PptlhOV7ckQYKMtFoSYALiMVxZizD2YAYKxArqtKwKOP1dD1diWxMRGVafToIj1sz8EKH1wQtd0/RPCO+o=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA3PR10MB6951.namprd10.prod.outlook.com (2603:10b6:806:304::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Thu, 15 Jun
 2023 16:20:33 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Thu, 15 Jun 2023
 16:20:33 +0000
Message-ID: <19f43523-0a3c-3be4-6ebd-51563635154d@oracle.com>
Date:   Thu, 15 Jun 2023 11:20:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 06/33] scsi: sd: Fix sshdr use in read_capacity_16
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230614071719.6372-1-michael.christie@oracle.com>
 <20230614071719.6372-7-michael.christie@oracle.com>
 <af35161d-ffc0-f9d2-c051-ca7f1db7658d@oracle.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <af35161d-ffc0-f9d2-c051-ca7f1db7658d@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:5:3ad::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA3PR10MB6951:EE_
X-MS-Office365-Filtering-Correlation-Id: e9bf116a-a8d0-4936-845e-08db6dbc71a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v7aaL+wZV3n6rMFb2J4zWRrywIy37RjewX189kpiZTk8Ne+JHajfXhUoAHrhXMrsr/+rZfTqT7UeWr/Wos2yEmYoq/NLBq0K7ogcsI4/9VPyL/WFFKNUP9IeMkQfTC5is5mC20I7YrUQ7vDJtB5w37sm2UzL0JqJ79NWccJZwXAx2A+nYUlaThQ1c/S5sFNR3IMp3/sXaHZQyCnQoTvlkzvfozCu8tUhSS0x4+IxCoAldjzcIBBwoh9aVRgOSK87b89Fn/Gz2EYasRaHTuabf+rtjoiWJYRbjsH8i2vQfszsYYB0SRmi8ClaShpPmn0S1Vn2SjCgpUv3fFJ9REoD3j6IiwGL579HynZPz7ianRqYN41mFHuiiEZO1hilBX/DngvLAI2a0wlKAy2olKhItq4h59PlJd+QIrx3QJbaaIG3xaNqp2KdgnKHo4O8k37O29/aY0ORUWivREVeh/KHWJz7//hv+0leexbbcflLHxkMV8taGdh2MnIxoAEoZ5SexYEifGR9JuGAsWRgYik4nim+PDPwBSYU5QvmjwDUgLczJP2kRfTAkjCdgnuxPVpZBc3sT8eiYJEVOSnDF3jJhuY/kppgcIA63EXScuwS7CtWkqFbJ7ghWK5fFx8OSTBhp/93GdKI8DIzMUBbMziLCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199021)(31686004)(38100700002)(31696002)(86362001)(83380400001)(8676002)(5660300002)(316002)(8936002)(41300700001)(66476007)(66946007)(66556008)(2616005)(186003)(36756003)(478600001)(53546011)(6512007)(6506007)(26005)(2906002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUpsdmZucjRQclAvMmpPRWt1c0JDU2FFQW4ycVUyMng4ODh4ZFZjRzZJd1gr?=
 =?utf-8?B?R00wYWZCdk13RHNmNUhOcXJaRjd1bVB3cUNEbVdESHRNNzJOaEZmQmt0U25C?=
 =?utf-8?B?UnIwWnFWMVplS0t2UWNoei8yNmh5QkpUbDI0eXNqS1FkemdpTm5LZnpoSDBV?=
 =?utf-8?B?K1ZhTFB2WDlkUWkrM3JBVzJxN3UyLzUvTW42TjUvZFhCcFZNcm5vME1xdThl?=
 =?utf-8?B?L2orNmlMRktOUjl6bEJYdEZIZks4VlVIdVdaSDRuandpWVFWdW5KbitzMkxM?=
 =?utf-8?B?ZWxIYklpL3JkbHNma1h3L09ieVlHdGNLVUhUUmRlcUx4WXlJdUpOeTByUndV?=
 =?utf-8?B?SldyRi9JbEtrV0Foc0ZTRDgvcDRhUnA0UDk0bG9YdWlVelowQVAxNXZkQlJR?=
 =?utf-8?B?TGM3ZUhTbnpTS3JSSVBLVW04RVljdHpYWWgzUWM0S25LbFNFZDlaZUkwd2p4?=
 =?utf-8?B?eUtGN1FYUFhxQUZ0WmQweTFhdThWS3czdE1LK2ZqVk9nOXUxYlF1KzVrNWJp?=
 =?utf-8?B?bkkvSUpDNVArMzBTVkNHMHZXQlBRSkRtM3prOC9GZUxjNmJDMCtGZFdtdUUv?=
 =?utf-8?B?Sy9vM0piZnNWMlhJeURMemlKaEV6bURiQmRlSnZvUWpkYjczNlRidW9aUjJ5?=
 =?utf-8?B?Ky9uT3R3TC9MTyt3ZXUrenFocTdLYzd0UEhsZlpNSHU5c1ZrZ3NzU092S1Yy?=
 =?utf-8?B?aEh6Q1NqdWxwVTFKZ2tSd3hhVXNDNUYraFd3RGVjMjdpNElpT2liUDJWL3pr?=
 =?utf-8?B?ZzNnbDlMR2JjLytOQSt1UU5YdlJjK3YyWjFadjY5TlQxOWxxZFhMM1JXZmhD?=
 =?utf-8?B?dStSU0dnVzlhMzV3cENiSWZIb0FhV203Y2V5QU1HbFZwdUM1V2VVTDBOWFlQ?=
 =?utf-8?B?RU10QWgrWWJzcjNBVktQOUdTU0JCM0p2MjV1cnhPM3hQUWZLZzlHczl0ZVdM?=
 =?utf-8?B?L3NhRDlwOHlqSWFoeTl1em04N2FEQmlYQjVaZnFyVFdxSVVNbVUrZ2dKb2dT?=
 =?utf-8?B?eFVNbGZBV2MwSzZmR1VvSEZpekxrUFJoVjRHZmNrekJyNDB4YVhLdkhLTy8r?=
 =?utf-8?B?bkl2Y01HSFhPb2g3N3psTzR4YXM5OW93MTRSRU55a2hTN3U3VmJCTnNpc3Fu?=
 =?utf-8?B?T3Nybm5UMGVDVXY2aGdRUXp0OXBTNGtEQzkxQXBrejhDVk5xZVBwaU1vbmZZ?=
 =?utf-8?B?VkZxVUdMd09LZ0tnM1NxdnA5bTJ5T3lDMHAycDN1RzJpcVUwcXV1RmJMUm9o?=
 =?utf-8?B?aS9XWTlWdXdqM0ZxZ0JjSDBKTWxwR080VEhmUVBYZFlDV2U5ZUVyS2ZHN3h5?=
 =?utf-8?B?TXJkOUxTNnVOa2djRWFHRTJ3bmV5K3d3MGd1aXVUQVhhRkRNUUtuNklPTkxD?=
 =?utf-8?B?d3dJTlJHM2ZaYUliamNTeWlrTSt2dWdNWVNiS1l5a3FSbFo0RW9XbURhZ1pa?=
 =?utf-8?B?cDdDei81Y1ZpSUVQbmN1Mk5ndDRRT2crbFFTbkk5czFzT25Ka29mN3F3cXpT?=
 =?utf-8?B?VXNsM3VmTTRJNGxUQnpBVG02ajM0d0hrMDVLQU13c2lCangzSFlNVHZJbFRu?=
 =?utf-8?B?cXYvMUI1SFN4NEZrZldSZmRZalZnZ0x2MmhEdk95YnIxMWpRelRXdHM1WDhM?=
 =?utf-8?B?NitLT09kVjV5L2pLZCtDNkVRLzk5aExLRGwyMEVXdTRnVmh4OU9jTkloU1E1?=
 =?utf-8?B?dVlGcitYWVQ5SmRDU1R5czJzVHExc1ZNOEpGTDZnSnM3aE1VWVhPT1N4dnBk?=
 =?utf-8?B?N3pKODhydC8zdHhMUitEbytsTms1cFVtcERVSFlkSWNBUFlvbHdTemFqWDN1?=
 =?utf-8?B?TDladXhWdDg1M2djb1pnV09hc0xBaFJyV1IyRThJQklMSmQrZVUvK0ZlQXJM?=
 =?utf-8?B?YVY5Q0p3bS9iTU5DY1NXT01JcW5hcnJFRXNpVCtrbVF3TjlDeHFrczh1ZTFw?=
 =?utf-8?B?UTE5dHJKalVTZENWQ1FsaktMeWlGYWRneHBUVXpDVUMxSXUvTnRoWjVOcld0?=
 =?utf-8?B?U1g5ZTNsZ3RQUlluWVhrR0NzY2tVeXNUbXFKTnZTOTFkVzhRMlN0NE16UHFT?=
 =?utf-8?B?RXptYm1ONjVjRlhNRUExelpOSWN4RFlHcXpwVUxrc2IyeTE2eWtJYmU3cnMz?=
 =?utf-8?B?UDZ4UzhoeUhvTkN2OHQzVS9BTzFhaXdTN3hyNEpvendnSzVoTms2V0xyRzVa?=
 =?utf-8?B?bFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 0rR5SGOBYlgJvUD2eFjGPxQVXTbTCh+T8J5oMJHvp0oqysDLMwnQ6H5luWQWg5SUJPmyyMPe0F5pUv9+1ggz7sVLmb2M+6KUlP8JUPpDNLSZSOKiX6PmL+eTPuXrXUu75DNp3FPe2Yui9cY6VfG8gHO6nEzcjSeSqj1jThpx0erAVnnwBjFe9sargH2W+OYx1Qlu/0Va2L+XBi8mZhvK2M0mYtH6x/6fKbF4kGblW9TyZor1GPNAroCrHt/VTZ96s43etWtVXoSNFIoTkzh4Lh4Oo8ZuBnqxdJ5+Wuh/hs/n0P1sIL/636Ou1MR9cwU11+uEtn/jioMYbIFJDk57lNd5iZHGL8PtOmnRCscHjllc7xttoKsJML/0+iHAJ3RIpqJUQ40fKYPD84FFtfhILPucW9kanlXhgxzosfbsCEz4H6Kc3mOdx2dlMW5WIPZCduPt0kBsgpSRHuGzuHJTVSSeNckB0XNgvzE4hpIgvwYoHOtcp78qwCJGapQSTmAt9wg2mrSvBqUItU3IAWfzUYyRCHp7nmgZBF565Np4JfAufn9v1aidnU+57Juw5hSLm86pmA9L+g7htD+iRz7JN47GkYHVx21O7VAZwgM9gvnwkfoN33cBKqZqA/E0ohGnhgjJU1vvS8VJmx7F1YTPNa/w9Lp6TkH8fsKD2rnfSHuV07fEWNR4XpEilQGhSjeQk5k8YDYFpSGiGBKhIurOVfuBRXyoi3UQWdI6zuMj0269sZd+CpET1YwMgsREr3QOlVqCAKcMFdLcCUdG76wsqI+TWuIAAuLwEMx5LabSLrKKU2xnCEGVRDigCnSsF7h43sxt4TPo8Ccdr8vHV49eGuUtAB/jAmWme4JXe7QxaefhZpibkmD6FUWfgGXwQ9o2
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9bf116a-a8d0-4936-845e-08db6dbc71a2
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 16:20:33.3763
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OgAgBOq9cm1c4HaGI0zZV7QwirBOVRp3Ff1TltTLU3lIYyD4HgnSvGWDEPCeXeeD4LNudCu9IEjfzfUwH3/NWAjbDZzSMbwYyfDmHOaTyh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6951
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_13,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306150143
X-Proofpoint-GUID: 0AKQf8x4KGlEqzTrF1xo2SsVwnDsE0fQ
X-Proofpoint-ORIG-GUID: 0AKQf8x4KGlEqzTrF1xo2SsVwnDsE0fQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/15/23 10:41 AM, John Garry wrote:
> On 14/06/2023 08:16, Mike Christie wrote:
>> If the_reset is < 0, scsi_execute_cmd will not have set the sshdr,
> 
> The code change below now means that we only access for the_result > 0, so should this be "If the_reset is <= 0 ..."
> 

Yeah, will fix here and the other patches.


>> so we
>> can't access it.
> 
> shouldn't access it, I'd say.

That's fine with me. Will fix here and the other patches.


> 
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/sd.c | 7 +++----
>>   1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 84edbc0a5747..a2daa96e5c87 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -2428,11 +2428,10 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
>>           the_result = scsi_execute_cmd(sdp, cmd, REQ_OP_DRV_IN,
>>                             buffer, RC16_LEN, SD_TIMEOUT,
>>                             sdkp->max_retries, &exec_args);
>> -
>> -        if (media_not_present(sdkp, &sshdr))
>> -            return -ENODEV;
>> -
>>           if (the_result > 0) {
>> +            if (media_not_present(sdkp, &sshdr))
>> +                return -ENODEV;
>> +
>>               sense_valid = scsi_sense_valid(&sshdr);
>>               if (sense_valid &&
>>                   sshdr.sense_key == ILLEGAL_REQUEST &&
> 

