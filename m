Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE41AC61DA4
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 22:56:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbjCOW4K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 18:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbjCOW4I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 18:56:08 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C66B3D908;
        Wed, 15 Mar 2023 15:55:31 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FMnXXj001274;
        Wed, 15 Mar 2023 22:54:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=qGKS6qtv9fJHNs8h02pwAFMXqmAqHAEtDIcwqOW3vAw=;
 b=DyEy1ZJaD2XV3/0XKSToIO8I5q/ghPThcsgTrz9W3bybuAO83A8AStCsH5Y0QRY1rce5
 vlIHeWPSHFeI1v12ERa4fQYTniXG4VwfsI4a0OP8yVSG+ONxFox0XaXL+aePKDrthsd0
 314nCOLuLEaQiVo5Jc+ywP2s6dQNGDctl+1wbkwXGjhAqDNBtrlae01spT+lEWldU5g7
 xzEtrJ3Cj4AaZeQOlncr9e1Xo+nWJadms4XEonGhQMJuaq8aiUZcsN9D6Ahgpn4ONe8m
 IijF13g9MLkvyfJdAiJAb9npQooAWCRQ2rGloF7Y2WUA1uCUrolmvLyiMiJOVreiRTSc 5A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbp4m83qp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 22:54:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FMkprG003961;
        Wed, 15 Mar 2023 22:54:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq4406j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 22:54:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2LGRCVrTHN3kgFNoG9e3Yby56MKKTKvquvnWYzQi4xagSydcFOJtEDxhzNK18cxSgYTCTTJ9df919mNOjQm1x7VCo9rFpP4TyEd9yOmrXFYV1cG0Pc3cgqYQnN1Ofi8cJO8umq0aPG+89v0Sma7GS73stvsleGLODjjXuv4MUNIiNokogWbbtpkWgGgKGJqALKcdMRZv9g8/OsvkBDbTCylUzyDmMbkgqSTj+buHskPjbKvq1iBQgj0PJedYAr6tT/moVaiiRuKHFeFqcXOlV7VF+FxVx8VZImyVMxoYRy3p9sNg2qvz/K3qV1/GVUBc2WCa7pfYWOjm0lE+YJf7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGKS6qtv9fJHNs8h02pwAFMXqmAqHAEtDIcwqOW3vAw=;
 b=PrPnbRi5T77oL+OsVWkr0GFtuoSghLaIL6T+2SkXRsLG9TO10maHfNI5evrBm2lPpZ76rmbIdDo/PvucqV/lhadqFsqeIKN8BFlVfDIEIYepeMu3kMqgkH6Ar4stMDcgciPwCCYxORT3cCoLYFJWVswF+GjsZyJLWdAVU2WNVrH/DFNkIcmzQZ5ei74NnKBGDSovsKtXmXfgyweozZxV4wX07FY7038wAyTjNLi7o3ovEPVWTaKK7vjJkNTFUHHLV9niH6WMVeA6hOnbiE0W+tdFvHyL9ox6GNYPesqDeT9gaHOlVrd5MZDlLxrnuXP29EwSmB8W7Co994eTAm+IIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGKS6qtv9fJHNs8h02pwAFMXqmAqHAEtDIcwqOW3vAw=;
 b=mztSFjszRtSohs1bh99B9s8oCX0nfWWsr9KoLX1CxCyXWVuVhFWX8iK5Uik3c8VLsWxf15fhuuDaLoOEcl6X0A3r3FcjD/ORVLTxQ3+2Cqwqnp6FULS2FgC65ga78wS6s97dbJIfAyUwPOKrvB76nA5exekqhqfFk3LTbtbwirU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB4853.namprd10.prod.outlook.com (2603:10b6:408:115::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 22:54:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 22:54:54 +0000
Message-ID: <e39fe3dc-2d77-64bb-09c5-dc165f9fbb74@oracle.com>
Date:   Wed, 15 Mar 2023 17:54:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 07/18] scsi: target: Treat CMD_T_FABRIC_STOP like
 CMD_T_STOP
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, sagi@grimberg.me, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-8-michael.christie@oracle.com>
 <20230315104757.GA30859@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230315104757.GA30859@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB4853:EE_
X-MS-Office365-Filtering-Correlation-Id: fe0bc7ff-b2b9-4d1e-6260-08db25a84afb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ia4XZ0/EbfMR1/4CNJLEyHGSgTKh1pkn+b6Bq8rgpc9OBEOvLFMeJEhNzTcJLh6ce+5bjN+BmQp02wFfDYlHTT/hy1DLnqx9lxt48SPya+OtZ2kSBldIvtESm4usqSAgqGxju6kbv0euqkLYe2z7vBm70ciZpoPxhVP9TpsxKg3NablG8udisNVyWTfIhBvDQ2vFcwZfmw5SsVmzcDvlb1md2pNksY5t5IwiXgfi87QRoBb/PWJL0rbPY4TTqdEXgaKKbjHVjzjxmwO1HbDuxmeNc+tiyHMYW3n5bt0BgV0TPREvN17lVJSdfl93A5xDBR7bCoeN23GqH6kT+L4VhGMy6HJL5sKZ7v34s6Y/iFcOBxIlzbzyIXT8ckjqpcZhEi8PsqGlzIRP43tpf+YPc/jNv8LrjCduFycX+KIcICnWtGTdTwLgcd0UqaIp+5zq4RwdUxTNBCWXJUyWzXuxQrXNeNbp7wLrTDphCrS1RUDUgmiO8DSxq4KdQGGVc+JYltMEbY4759/2xwpg/tAajkOtGdmxrGd9XEhIGFo+UWmHFrW805+3Tga5mepSTxXf53I2ELkCP/R1p3pNNGO4rmJPpsnbCjPRCqT7HlYEPyB96pfnJPJ1Xoqhx2D4sKQLQJJyd2QARgVW6qy1C0Majv+3OwdCDuT9pb491Qrf6j5wf5NOPvhBsoJyEUg3ouNkmqqWSZoEmF9+9S+zQx3ki7lZGZG1ui75LlveqKvdZwk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(376002)(366004)(136003)(346002)(451199018)(38100700002)(31686004)(4326008)(6916009)(41300700001)(316002)(66556008)(83380400001)(66946007)(8676002)(66476007)(8936002)(5660300002)(2616005)(478600001)(31696002)(86362001)(6506007)(53546011)(26005)(6512007)(2906002)(186003)(36756003)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnVzTm5nYnJYbXZtcUlGRU5tdUhQdWhGMmVWaGtmWUdtR2o4aC9zOEJuTmoy?=
 =?utf-8?B?SDlWY212ZWFFa2FCMHVveGplcjg2UmNjYVgrSkY0OHRRMmxNaVZ2TURKNHQ4?=
 =?utf-8?B?Ykp3MXBvNkNaTU9rWW1ZWnpMWUZ2ZlRvalNmSjhjams1dUQ4K3kxTlBqQ0tD?=
 =?utf-8?B?Ny9Wc1FmS0Y0VWlYRkl1QnhDT1lFL0dCeDBIajFPVEZXZXJuNWhjaXhMZXNZ?=
 =?utf-8?B?MmFQT1NqRHliSjc0Y2c0SXMzM3pxUXlyb0FRZUt1ZFd0WEFzb3kwMjN0ZTR4?=
 =?utf-8?B?bVYvWTdrMWE2ZHBFbU9ZbVQxT2NGZjZyczVLZDFVVWFDZVBGeGkwL042Q25U?=
 =?utf-8?B?TkErd3B3M3JJNkdrNWNPZGVCZjllSEVzMEdjK1VYbUFoZU1GYXA0d0RmeTkx?=
 =?utf-8?B?MmRLVjZVSzNOemFIdm1GVk1uaXlXbExZMkVOVk8wYnVjS3crVnBrRVVqN3RK?=
 =?utf-8?B?OEpOVVF4MkhBc2FzdzJTTUhGZ2QyMTVxL3N1VkRwNHROZytrWGVFNUFuWTV4?=
 =?utf-8?B?cEVxR0dyOGROaVFvVDFOQ2dxWnNNbXpUeDZjUXJBNUNvbWtGdkdpWG8rWCtE?=
 =?utf-8?B?V0N4c3AxSzVCVnBFRGpoWnJ2M3ErTitOMjFrcENMS3lZU2p3d1VHVm9FZHQx?=
 =?utf-8?B?TitaU0RDUDFsVFBucWtqZHg5UmpJVDgxR1VKdFpIYzJic0RXMHNubkNTd0dF?=
 =?utf-8?B?cEhydW9kVE1qVUhDM2VYTDJ6S281YWRRK0l1V1BJSWgwOHFJUDViTGxNZ2xW?=
 =?utf-8?B?MkVja1NyY3c1RVlwS3FpMCtpS1hFTkp6MUk5V0hCYmdSK29GM3RsSkttZ2VQ?=
 =?utf-8?B?Z3ZON09sUHFuM0l4T0lidGluTlhFSk9lb0RvUm4rRW9VNmk5TVoyOHZDMEJi?=
 =?utf-8?B?Mjl4UU41b1VndnU3MjlQN0RKV3FCMmVQWmZSN2VJOTBWMUllUFpYc09TQXMx?=
 =?utf-8?B?bjBqd2dzNEdTR0tjZlo1bG9GYnNSU2MyWDg4S3ZjYzhrejlnSS9CdlRUMG5F?=
 =?utf-8?B?YmFwdFlEcWoxYVhNVmJUaE5XbTNIV2RrWEwvMVFqZ3NIT1g1T3NoNjdHcmZD?=
 =?utf-8?B?NWRRYjBBaktYSW5RekYrYWk5djZYS1BNSmM0VFBvcnNEaUcyQUNFV3lOWm53?=
 =?utf-8?B?V0d0bXFPemJUWERzMzFkTjRlNGYwSlpNUXlVNzZjRVBRbVczYm5kR0NRcTQ0?=
 =?utf-8?B?M3hONDYyUmNxUHRlTmsrdnk3ckxSTVg1bEhUUk1JSkRqRWxwL0VvcURpd1BW?=
 =?utf-8?B?ZlBWMm1NeWorZDcwbVZ5b3hDOG5pcjlGUjM0cWhxYTRWbFRURjI3dXhJaFRG?=
 =?utf-8?B?Mnp6QmhFUUxRVE1kNTdVTW9tRFl1dGNUc0tQcm55dHptamFmY3JXZ0FtMlhm?=
 =?utf-8?B?SHh3K0ZQMjduUndUUFRWeXJ3T1pHVVBkZXBzVE91MlVzd0I5YU8xcHVPeERj?=
 =?utf-8?B?aW1UNXF6V0habkNoU3RMWGFOTERPNFArL0ZmcWRGVnJWcWk0UVIybnBBR0FB?=
 =?utf-8?B?S3dPdFNpK0E3dDJ2a09rQmoxSnhWVkdIOGJ3d0dyL25WeGxJaG9xM2RCRHJB?=
 =?utf-8?B?dkJoUEFhdllUamV0SU9jbXNFcjQzR01IWlFPUFJtZWtvNVpDYjF3M041VzFj?=
 =?utf-8?B?Z3ZZd2d5UUg3V1lDTUZkc0doWGpNNno4UllhWWdhZ2l3dlMxQXZ6ZHNvZklX?=
 =?utf-8?B?S2lJeEYxMlg4aGU1L0lObk0zZGJLNUxGMy9hY1JOYlZGVzdhSEhNb1piUHli?=
 =?utf-8?B?Uk9STUlrVjRJdWxrSHdncGZzdlVCTGFqSERKaTdObUZGdUVIUklTRXl0SWh4?=
 =?utf-8?B?ZkU5UnE4bnp5YjFqMEdMN21QVmk5QVoybG9kVnVMYjhRRHJOVFVJV2Z4eGNi?=
 =?utf-8?B?WlkzZkZrSG4xdnNscnpTVGlTby9zdlJybVZHR3Q2QXFtOVk2eWdxV1VqUVll?=
 =?utf-8?B?emxpUytyQ1pXS2k1TCtCc2NyQlBQWnVLa3VQd2lQRmRoVWdYOTZSYkNSVTMr?=
 =?utf-8?B?ZWdwcW5BS0xXbjIydmtpSzVxeGM2aitnMUoxL0E5Y3VyeXdvNzNLTHVWTWNi?=
 =?utf-8?B?d2pmTWFCVWF4dDdvWUtoL0kreldrcFZuY0pqTnppcjlpNVowSktldHhPTjVX?=
 =?utf-8?B?THlabzZrMjJ3Nng1MUNzNEhDQ3NONTJCcW13MmIva3NwWjJpNTg4L0dRZmRB?=
 =?utf-8?B?WlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uq/lCT0HyR+tXRSkwLPOT8Ajmw9QvqbwEtInGwj3z1zcw8FfKQCZJrJQxWexs8ndfYbJLoqA76rTaIy2JOMVD8J7vTFNiIn3g7uc1tHLk8v6K94qiIRe4jwek2Tf2v8C3YLdeB6p+U1RAbK1iX5fg9+48zPTeZOhfdtg3RtsHgfBxKp3I3EFRFmJnqZDjW4Shb4tbfGimalqyhF4jgfTsC5raHRmA3gFjLwdnkp8dpHjCOA4ChVp1Fi5PYDw//joofT+p3IEetRD7UEqpEbLKiFZWRJmhSUxm6tXkA+b+gdpvrSeYusCZzXs/EOmBLNCz7aoQZPnwoE3Ld/qhO6+4LkH5gInQ89gWw/YT6NhuBShL+I3oqzImOf3UqpujkbvyQLNEzQAQJgQEpAWCa2m8HXeafO2zzSJJaAR7R29nTC1CvSKg97nSG+UECBIpM0nctyLHRVGSCVI+P+5ulHL42pbY1Z8sWq8xsFmnbd9USndsNBzyWfIJrtr75qrNIC6ruA5YioP6fi3vhtQo1tfJAfKm2tpUn+6UgARUrBNqAZukpoK8J05CVdZ+t4as2BqNn0UFVoxzJ5MBQJIS+EJxrXsytAtb5133szUjM3SedYCBDwJyWj1GgbiykRoM+dm1NRcpQWHEU8P67w7C5Q8RjBPfJSZb7SOORAZVz3yIwVVbNWHsIGhR4drBaFekC80OukZimPFbK0Mdn/zZHKTFYs8wmRzvLd9SKMEYqHgiCzxcOl9BgRiftpXtOJYDTc4xhe/uSxuYS+tnNDsaP0PP74OL77dWwn0mXn3gdg+Usb0sVL2ZFL39ml7kqJgu4ygFRp9Tj5/ffdYlhDlmPe8TFYExPkuEwnhzwXEgB0IM+HDQ2028u0n8v6R8aIVe4zs
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe0bc7ff-b2b9-4d1e-6260-08db25a84afb
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 22:54:54.7341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VSTOU6AIbMKZllopiJL1hmzvceYcaOB2nKmh3V0InSAF+WxnTEEW5rVzy+5SG1/LdSkIziUAAvqbAzy8UfUPMp28uPhFY1dgi2fwDw7ykwA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4853
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_12,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303150187
X-Proofpoint-GUID: xaqF71eBisJo49UTL5HS5pZrMWHpWpck
X-Proofpoint-ORIG-GUID: xaqF71eBisJo49UTL5HS5pZrMWHpWpck
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/15/23 5:47 AM, Dmitry Bogdanov wrote:
> On Thu, Mar 09, 2023 at 04:33:01PM -0600, Mike Christie wrote:
>>
>> iscsit will set CMD_T_FABRIC_STOP on running commands when its transport
>> connection is down and it can't send/recv IO (tx/rx threads are killed
>> or the cleanup thread is run from the one thats up). It will then loop
>> over running commands and wait for LIO core to complete them or clean
>> them up if they were on an internal queue waiting to be sent or ackd.
> 
> The current usage of CMD_T_FABRIC_STOP and CMD_T_ABORTED is to
> distinguish will command be aborted or finished at the connection release.
> Technically that means who is in charge to decrease the command's kref.
> 
> The current usage of CMD_T_FABRIC_STOP and CMD_T_ABORTED is race free -
> it checks and *changes* the state under a lock. They are mutually
> exclusive

I wasn't sure about that because __transport_wait_for_tasks will always
set CMD_T_FABRIC_STOP if fabric_stop is true. It will do it even if CMD_T_ABORTED
is set, so you can have them both set. I changed that in patch 14 so we do what
you described above.


> 
>> Currently, CMD_T_FABRIC_STOP only stops TMRs from operating on the
>> command but for isert we need to prevent LIO core from calling into
>> iscsit callouts when the connection is being brought down. If LIO core
>> queues commands to iscsit and it ends up adding to an internal queue
>> instead of passing back to the driver then we can end up hanging waiting
>> on command completion that never occurs because it's stuck on the internal
>> list (the tx thread is stopped at this time, so it will never loop over
>> the response list and call into isert). We also want to sync up on a
>> point where we no longer call into isert so it can cleanup it's structs.
> 
> If fabric driver knows that responses will not be completed by HW
> then the fabric driver shall itself complete such responses.
> Please do not shift this responsibility to LIO core.


This patch makes it so the fabric driver can tell LIO core to not do
the last put, so the fabric driver can do some cleanup on on the cmd when
it completes on the backend but before we free it. Basically for isert
iscsit wants to call aborted_task to clean up the command. iscsit tcp will
also re-call __iscsit_free_cmd to cleanup queue_status calls that were done.

Are you saying that is shifting the responsibility to complete the cmd on LIO
core? I think it's the opposite since the fabric driver is doing the last
put and cleanup.

However, are you saying that just adding the check is putting it on LIO core?
If so, we can always call check_stop_free in transport_cmd_check_stop_to_fabric.
The fabric driver's release_cmd then has to figure out what needs to be cleaned
up then. I can make that work. It's more complicated than just what I wrote
because of how isert handles failed cmds and tmrs, but it's doable.


> 
>> This has LIO core treat CMD_T_FABRIC_STOP like CMD_T_STOP during
>> command execution and also fixes the locking around the
>> target_cmd_interrupted calls so fabric modules can make sure cmds are
>> never marked both CMD_T_COMPLETE and CMD_T_STOP|CMD_T_FABRIC_STOP.
> 
> CMD_T_STOP is some ancient logic that is used to move responses from a failed
> connection to a new one during recovery in ERL=2.
> I believe that CMT_T_STOP logic was reused at connection release just
> to reduce conn/session use-after-free cases at command release.
> 
> Thanks to this patchset all commands in the connection are waited for
> the completion in iscsit_release_commands_from_conn(). Is there any
> sense to use CMD_T_STOP mechanism there now?


CMD_T_STOP does 2 things for us in iscsit_release_commands_from_conn:
1. It waits for the cmd to complete so we don't release the conn/session
from under a cmd.
2. It prevents transport_cmd_check_stop_to_fabric from doing the last put
if the command is completing normally (not aborted). iscsit does it instead
so we can do some extra cleanup.

For iscsit tcp, we don't need 1 or 2. Funnily enough if you never brought
up isert in the other patchset, we could just do target_wait_for_cmds
and be done :)

For isert, we don't need 1. We are using it for #2 due to how the driver
handles failed cmds and tmrs. I either need the some check so I can tell
transport_cmd_check_stop_to_fabric that iscsit wants to do the last put,
or we can do release_cmd based.
