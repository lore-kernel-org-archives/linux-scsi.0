Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64953C636CD
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 17:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjBARAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 12:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjBARAT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 12:00:19 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E4C7BBFC;
        Wed,  1 Feb 2023 09:00:09 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311FYj4g027012;
        Wed, 1 Feb 2023 17:00:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=plwCVaWi4dSrjM/d4ryKgTnr7fA0PtC0jADmdCMAPFs=;
 b=3VxH1/sccZ6wjn2Tlm2fm8HmmA27vikAO9NJkYHWazyx4MdzmT702b4wJbeVcfD40xZT
 74pXgaWjLAj2ZmrepzBJvcJEW/jKOLbXtoraZm1U0Byw6nl0H/ZAmyTaie2CWpZVNNzc
 e7U6+mbhYz18kFrAJIsxVuYRSlIhlL8PTJzRuXhADsmIGNp6ehAR5gZ7N6kgtUsp0B3z
 DVtCVG3C49PaY0RCKV0TcRTDMnq6axFhG0ZbWeAQ1PrRF/+G6Mk1GxAj6zqnXXbE8KcB
 6gqpXr22qBnNePSfTs9j3e2wyAM16oexwjMaZO6Px0STSeu9niXDrWfsKGZ3Hn9huSU6 cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nfkd1s899-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Feb 2023 17:00:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 311GeZCa025160;
        Wed, 1 Feb 2023 17:00:05 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct57s9e4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 01 Feb 2023 17:00:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLbQ3QfjF5RDN2Plm4MjoiFnTKxokQYqbmW/qDaBcQ62NfS7s3v8d4yik4Ubq2LZik+wV4k0okkgboBeS0PMMRdUKJ/lx40jqGBJdFwskJR0ezybJczc3WpxznYG62Tl869r5N0UT2Usdw7Ci7ROLBX/nZDTOCfTnNkF6DwKo+NH0ELsgnCXpE/6PdrwHYw6/l3l1MbIIT9YA+b00vck9+CBRtSaAPcyUig+6v2QL/SDHQJ1sOPIyogVEhajSnVQ1p3UdUwPfu5nS3ViJI39RUxe31Gue75NcEk2UDE3Qqx02VudUGBKiOveDSsSohRCfs6Q3bt1UpJdDhJUjuWniQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plwCVaWi4dSrjM/d4ryKgTnr7fA0PtC0jADmdCMAPFs=;
 b=FrPlYswyAxzojMAwQ1UGhLbzGdc43vOSWRc2/nk/oryCsiJ6dIUn1ioA3YDvQ9ydfAckVXE6Vm81+o1N5P7OJ7J8uSRE7LzFZkM7hgiHFDrZqvkyMMH3eI5jHPNrW+cobo22fEWlHovTRSSCYBQnFoJ9ma53nTAlLerhpilsZPGBh0hWW7FXSDapphe8BoOCXjJA5bd3VPLwUunFlGm/3x6KO6LXV9LrwrqZr4R+qt7Z6Zk4YNcb6keYCeJwhF1KZZ1Fr/4VWPOdWtJxTslSdPPpcrvrz9/zXwfnjsz64mrWRYfbgVn/8gTAx/GoaDneoAZ7XYLtaDOXK6wXaNitXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plwCVaWi4dSrjM/d4ryKgTnr7fA0PtC0jADmdCMAPFs=;
 b=sEtiPWVeMekgvmT+ZNGLi3y7PZVvTgq7Me82xs6n1akz9/4uXiEnn9k6oYhUSwoyYo8gjisdozzZhnWFzt4NabSnsHIBtDBuZuyEsqCWTs5mBnUYL7YLjs8yVq5lNK6/kYiVu9/BoB3tvqQu8gc/VgfPzpo2lfc64FbUVEhXZ8c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BLAPR10MB5187.namprd10.prod.outlook.com (2603:10b6:208:334::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25; Wed, 1 Feb
 2023 17:00:03 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6064.022; Wed, 1 Feb 2023
 17:00:03 +0000
Message-ID: <221bc4d0-082d-e313-a11b-4d0eabed002f@oracle.com>
Date:   Wed, 1 Feb 2023 11:00:01 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [RESEND] target: add virtual remote target
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20221202122319.28508-1-d.bogdanov@yadro.com>
 <4c3e72fb-a61e-2cf4-31fd-51ccb8104792@oracle.com>
 <20230201084852.GK31614@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230201084852.GK31614@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0336.namprd03.prod.outlook.com
 (2603:10b6:8:55::20) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BLAPR10MB5187:EE_
X-MS-Office365-Filtering-Correlation-Id: f9c9029d-e4df-4fb2-0f21-08db0475c2ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0ZsEqNz+c7L0xXPUNi4nis4/vdYyIi++1Few7kIjqpnDDeOj4oy/pknk+ablcZreKjo0nqtvUYW9FwJIBlj1MYevpmehbEbwxyHtM4PuqtNrMomGAlTrRPl0GtlcvPyL1TavKbyxHYsY3Exq1dhJLZonPAWWdEyv6LpLLhufn9UAoUZd2o9XOpPGt05JrmCr8kQ7msjh4A7WHBwycWGb3h6g6atphT/aMfAJ2ulYrH2PC7bqsl1zCVvhQR80f+vqfsH8qRSBuFZMJGeSINoGxKLYqGP0+HLJXc5ODjYCWcQJgmQU/FEsYwbKKGyj5EbMGIbzWmfJ5rRI33+G3vOtWkpVITHcIBhVQFxC9h4r9RiGRJtUVb7A/hBw9Djv6kq15dVSRs+ZybXOsLy0KDTy8j44mPtdmpcTuoWKw0/oQwL+zf2dnbPyNWxzT1NB8VCEJCkkv2UpbEupPkuH4JrsGhHA5LCYsO4gbXKWS0jYk0OZyUycplx8neGViDBjfpG6eDPgW2By9Q2f4ojOAXCljK68+8zAidefePUB+LbskuU1Jkpd8tYnIvY3MjIlSI5XRn0BE8VIBWRjxmwauPBQfdTh7HhVOB3X6sy/UKIS8JuSmZK4XsFhghRY4iWyuC5J+6hN+NEC5VNCOxWIIDtukz39j/ZFlGzoMj40gIDL8myS2JCUzl+ZTQpyI4qnXiz9E135YCVirRm23BAz27H4PWMVUETpkrzrUrpxFwHCSxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(39860400002)(346002)(396003)(366004)(451199018)(36756003)(31696002)(86362001)(54906003)(316002)(53546011)(6506007)(6486002)(478600001)(2906002)(5660300002)(8936002)(8676002)(66556008)(6916009)(4326008)(66476007)(41300700001)(26005)(66946007)(38100700002)(6512007)(2616005)(186003)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXgxSDRCbVI5aHQyaWR1ckd2cUVEaXVlN1k3a285ZFVsREVFaFdoWXJsekR0?=
 =?utf-8?B?ZXFwUlJjTmR1ajF6NklYL0NaVVhmR211ZDl4RG9UeFRSUU1hMzlLNG4rZTda?=
 =?utf-8?B?UG5RUmlheHdkVCt3T3NLbmx1R2hSYnltRzVDRnNxYTh0ZWk4NDNweVRVQTVw?=
 =?utf-8?B?Yng1akZQQnZqWXUyMS9vUWJWM3NuTHM1R3AxaGl5M3ZDeGFvdjhjRENFdUFR?=
 =?utf-8?B?bGVad2hZWU1wQnZVOHpyTXF4QUh3NytjRy9oMEx5VXg3ZDh4aWlsZ3FITHFV?=
 =?utf-8?B?eHVkR28yQWFhWXExbTEzeCtSZ3ZLNWs1Nzcyb1dlZHE0L2xJdC9GcUQxaXM1?=
 =?utf-8?B?U2N3VFpsU1J2dHpZcnVGTk55NGkyZGh3N01uQjZxblRlNS9EeWlmL0l1NnY4?=
 =?utf-8?B?T2ZKbldyV3hRRGl6S0d6UENmMWd1d3hKTGVaRjIxajVjMDc4Z2tnTHZVSlhG?=
 =?utf-8?B?OEpOM0RsQVF4N1kzd290eWJEWEFhbjVXZzNjL1dxaUZidVVyOERFZ1FhSGV6?=
 =?utf-8?B?Vnl3NnAzeVhZcjU5emdjdytwN20rTVhkQTR3dk9HdDRuSXhIemZ3cncrUm10?=
 =?utf-8?B?S3hkTkZyckRHTnJkVGxNcVBIbzBER01vdTIxOXo0Y3lHcnp6L2UySjFWaFFN?=
 =?utf-8?B?T09kMWwvSWtFeERxcE5sN3oyd3lqcmlmQ3FTQzZudURjdHQ1QVhVaXl3eEJR?=
 =?utf-8?B?QmtmSkc3cWFMRGtEYzJmcWhnVVpDa3RLdHE1NGVicU04eHJuS0pRZ21oSWUv?=
 =?utf-8?B?T1VMTDdxeU9FampzbVJPaGtWSi8zS3FTRVk4em51a1dhOGdzK3VPSjVZYlJG?=
 =?utf-8?B?a3hrTXMwTEh0eWRJWGhuTHZrNmpMT25sUlNEcjVYUXh6cFc3VTB4K1NWMkNz?=
 =?utf-8?B?QUpaZ3ZUVEJUY2dQNDY2ZzgyN1Vsb3RaUXhPK3dGOTgvMDFoQlU0Z3RRRmJL?=
 =?utf-8?B?Nnk4Y2YzeUxiVkpQdzF5c0QxTjgrWU0zQ3h5ZkRkTnNrYVVWOWh4TEJkamoy?=
 =?utf-8?B?a1dvU0ZjNnR5YnpKWk1TbktjdGdZdVZmcXovTkkzTXUvUEw5TmNrN1YvSlRH?=
 =?utf-8?B?dFYvampaeGllcytuU2pweFp3NHV2SkREZXVEWkVveThOZlB2MFkxYVVKNHN1?=
 =?utf-8?B?RGU0SVhwcklla3QzbzN0WU5FM2pVZi9raktSck5sbVIyK0RXaENyRTJja1A2?=
 =?utf-8?B?eTA3TlNUMUJ0emN5ZjRIYU1xaHA1MjRaZ25LOFVTSWNTSHhxTC85cytRUGpv?=
 =?utf-8?B?WmF1aVlSOVFRZW9tUHMyYnV1MjdHTUw5VStWRUR0cjhnNHNKN1hoYlhsbHJB?=
 =?utf-8?B?aEV1OVhXRWhmRHd1akgxNG5yd0s3THVGbllIVjRBeGJsL01ZK2FkQmlrYWJW?=
 =?utf-8?B?QUZNbk1OYlVTdHFNbW51M0FNbkkyMUNiU0xlbmVydHdBV0dRMHE4ZDhwZVJS?=
 =?utf-8?B?ekZCOVZFVlJJUHFkMW01b24rT2pBZEVBQ2EyZzJleGpyQWNPamcvRVpSUFpG?=
 =?utf-8?B?b1lPL2p0QmkyRWFGNVBYdVJmMXIrelRaTlJPUWdYR0UvNkhwWStUbjAydHZt?=
 =?utf-8?B?L3REcU1LemFzWlNVWkdNL3JaZ1RVZ1pzUmlqMGNFOEtlbDl6MEtDK08zNG50?=
 =?utf-8?B?b0pYTTEzdE43YXJhU1RvNXZYOG5GMU1scDFmbHJLaGtQbE1PckRZNVpJOVFS?=
 =?utf-8?B?RnBtWHRNWG1PMnJ0dVUxWG55NkdVZVNJTkVhUlZMS3kyTSsrMFRYeUdmaFJC?=
 =?utf-8?B?ZlVHMXpJb3AzY29JeDNpc3h3T2d5WHd6ZGtKeWtlYW1oRXdNWW9yVVdFTUhs?=
 =?utf-8?B?akVneFF0Z0hwRC9lMlRiczlrcHlHTkY1ODlPUkVYRzQ5SFRYZFM0dmpwdVVp?=
 =?utf-8?B?Um9OYUkxVit0Q25qeDFuWnFNMVNQRkFWQThPbzRLNjlFN3VvZTlZNmZCOHQ4?=
 =?utf-8?B?Q0NZZ0VKeVBqYzl3M2Rnc29RcmozYTVJME5PeE1lNE9CMGQ1a1dYWjBYRDVu?=
 =?utf-8?B?Z1llREdUWkdlK2FUbWdRTGpWNU9ZMUpsWUNtTExxNWNPQnNWQ2kvYTczTnRI?=
 =?utf-8?B?R1dtVUZzdzdKV3NrUS9XQVVYVG1hYjdzY2FIMXJXamY2L0piNjhXQ0VKbXQ5?=
 =?utf-8?B?WGdUam5Uc25WcjVSNjZZR295V3ppVHBHM3JOOURzQlBjNU1uSVRQWTZPK09i?=
 =?utf-8?B?MEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HZAyYsQSqeEddAUudFQOrIBxHJNy3HuHxblpUoBkbS0mIGUSjywZq1UMIrR7c/yt+B8T9MEuhN+wT6TstDcOEvB1yGQw+yDp3snxd95gUGqIk3kwaEjtqQBIr/bxuKqM/2AMh4KQiCL6eRaHotDMnwc+G4dLzBWjQFliFmKhGu3/QVQp3HS24FBVT6ba18hwi4m0gqbzQaVnCVrIFJUJD0B7ZEsgiGk/R1Vo75zZRH1g/Gy+Uupp4WrqxZ4AS5H4T92dt9of/EiKFho2eb8csSC9FCYYehzONnMw1Uf9FOO7xh4eICm0rkUULfxm/J+wkBhYqkVMboUUYe5smPGt9mNissPrnM/9Xk6epOxLoQZVIzvehQ3X0S1AMAtwDCrj9//asC2h17ey/lp6Rmsn6uZ36fhiGEymDHBFXUl78AkEabxHLCqZFQxDjs81zZ5AoBXtBiWKsQhvX3T3KnWe6J/QqFdFw5AV0fegMocqc8kh0iJQDI5xZ/i3kVtLmTPemAD+ZpXU9etENdQPObBZnkp80zFbPQsVPkjiFfYI9Vi2gXAEkUlUQ/RrnrwCiNMBiJ8t2ztNgtSIGJ7Jww47g1WrH2Ck2hgkHXG+aFBcQndFJpvcilkS+CCqv7oDby1DsyBvHDwsUYkSoOK5G6m1r3XiGoj7gH8hJLbVj8tpa/gQiISI+OWxl8yO6e5SLP9MKhcbexbDDckvG0pu0BhtUH4NZMiKULqoBtpaXfvG2d561evD+bzhSiXB+9xbUJdwyj+Ez+ZY8Q6q8LGUfZON55E/BIu7OrQcgYIk90Q+y4w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9c9029d-e4df-4fb2-0f21-08db0475c2ac
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2023 17:00:02.8672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sPPlGuj6c2/2w7DkhpIigjR4ZHdxONNhOfPOf1H3LmJCE3S0ZEyVeOgNkddZl4uWce4Ly/BRnsfwPZyeeJ8rmMwxLUOk4gCpuMnCu4QeeJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302010145
X-Proofpoint-GUID: 8JP9c6oDBICCxPrJLArZLp85i6dqoAOS
X-Proofpoint-ORIG-GUID: 8JP9c6oDBICCxPrJLArZLp85i6dqoAOS
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/1/23 02:48, Dmitry Bogdanov wrote:
> On Tue, Jan 31, 2023 at 01:09:57PM -0600, Mike Christie wrote:
>>
>> On 12/2/22 06:23, Dmitry Bogdanov wrote:
>>> +
>>> +static void tcm_remote_port_unlink(
>>> +     struct se_portal_group *se_tpg,
>>> +     struct se_lun *lun)
>>> +{
>>> +     pr_debug("TCM_Remote_ConfigFS: Port Unlink LUN %lld Successful\n",
>>> +               lun->unpacked_lun);
>>> +}
>>> +
>>> +/* End items for tcm_remote_port_cit */
>>> +
>>> +/* Start items for tcm_remote_naa_cit */
>>> +
>>> +static struct se_portal_group *tcm_remote_make_tpg(struct se_wwn *wwn,
>>> +                                                  const char *name)
>>> +{
>>
>> The patch seems ok.
>>
>> My only comments are on coding style:
>>
>> 1. I know we have a mismatch in other lio code like above where sometimes we
>> don't put any args on the first line after the "(" in tcm_remote_port_unlink
>> and sometimes we do the above. Since this is new code, could you do the more
>> standard style?
> 
> Yes, I will do it.
> 
>> 2. Maybe for some of these callouts where most drivers are returning the same
>> hard coded value we shouldn't make them mandatory. target_fabric_tf_ops_check
>> should just set a default callout.
> 
> I see that those hardcoded values are different (0 or 1) in the drivers :)
> Most likely they can be the same, but those values are exported to sysfs
> and potentially it could break some userspace. That would add a much of
> questions.

I think you misunderstood me. I'm not saying we change any values. We just:
1. Add default callouts which are set if the driver does not have one
and/or
2. Remove the requirement for some callouts.

so drivers don't have to know about some of the LIO details and don't need
to fill the same thing for these callouts.

For example for the drivers that typically hard code values or have empty
callouts similar to the new driver then we could normally have a default
callout that LIO sets:

        srp    ibmv    loop    sbp     fcoe    usb     vhost   xen

tpg_check_demo_mode
        0       1       1       1       0       1       1       1
tpg_check_demo_mode_cache
        1       1       0       1       0       0       1       0
tpg_check_demo_mode_write_protect
        1       0       0       0       0       0       0       0
tpg_check_prod_mode_write_protect
        0       0       0       0       0       0       0       0
tpg_check_prod_mode_write_protect
        0       0       0       0       0       0       0       0
tpg_get_inst_index
        1       1       1       1       user    1       1       1
sess_get_index
        0       0       1       0       user    0       0       0
set_default_node_attributes (only used by iscsi)
        empty   empty   empty   empty   empty   empty   empty   empty

Notes:
1. qla, iscsi and efct allow users to set some of these values so I didn't
include them as they would would always set the callout.

So you could probably have:

	if (!tfo->tpg_check_demo_mode)
		tfo->tpg_check_demo_mode = target_enable_feature,
	/*
	 * This one is a weird one. I think vhost should actually be disabled
	 * like xen/usb/loop. I think srp/fcoe/efct should have worked like
	 * iscsi/qla. So just make it disabled by default below, then let
	 * srp/fcoe/efct/iscsi/qla/vhost set a callout to override for now so
	 * the behavior doesn't change.
	 */
	if (!tfo->tpg_check_demo_mode_cache)
		tfo->tpg_check_demo_mode_cache = target_disable_feature,

        if (!tfo->tpg_check_demo_mode_write_protect)
		tfo->tpg_check_demo_mode_write_protect = target_disable_feature,
...

	/*
	 * I think we want to have tcm_remote_sess_get_index use 0 like
	 * all the drivers but loop/fcoe, and can use the default then.
	 */
	if (!tfo->sess_get_index)
		/* this would return 0 */
		tfo->sess_get_index = target_get_def_sess_index;

	if (!tfo->tpg_get_inst_index)
		/* this would return 1 */
		tfo->tpg_get_inst_index = target_get_def_inst_index;
...
	if (!tfo->set_default_node_attributes)
		tfo->set_default_node_attributes = target_set_no_attrs;


Or instead of making us always having a callout, then make it optional.
set_default_node_attributes can probably be optional because only iscsi
uses it.


> I would like to keep this patch as much as simple.
> 

I think for new drivers and features it's common to add new code and
improve the infrastructure you are going to use. If you think my
suggestion does not improve the code then I can see that.

