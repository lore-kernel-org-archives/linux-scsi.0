Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F04C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 15:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233996AbiKVPop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 10:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233970AbiKVPom (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 10:44:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4837F6EB5A
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 07:44:41 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMF4vHb005954;
        Tue, 22 Nov 2022 15:44:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CehOzNUb9g3odlf+hTxs6tQP8Zgr0KaXtXYKdCBXCeA=;
 b=gPu8iuio/wVrvpsE318ohM3gc4swRd0U6V6d18xn6FoTLtAAa5/TK1EsXQ4FGwPvYdEP
 YAJlVd7qhcIDC8/qDfmLbQqClXok2reLRA1D7a1qaREmTrB1Zv6I4MLCsn3UdCNm+CKq
 9K0d6H2BtdN7+/PjI/FdDo7HNZCQGnFBgklqKnlYSa/fvy/3iCDCG/ZdIkI+/UrG5h6p
 y7ejeo2VYEDAYLdmy5fhPQbJdq+Y1+lRHHqBIgUDP8pEDVbjIwC85PefrLSivWkCLHXA
 bwUCU7mQMEqwdWTnleJLsCB/A7z0hla8WL7VQHOjgCt4jtgFFnnRWnVN3keoaW3MNS8H hg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrfb0m16-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 15:44:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AMEMfXr028896;
        Tue, 22 Nov 2022 15:44:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkbbnuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 15:44:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bzqlbwZhngUkxyuobvrvrREpvxAOFYOLBblNqqkZyhdu08HyHJpNSXGSI2c37OG81LGTTuYFZk4bPKccUtKsXOORNVvd4zhY195/jGyCYEENeypsxp741zuJV3338l4MueqbrQ5D1BXSs/aBrS06WwvFQm3FFHRtLnylqoN73u77ANqmoW/TAiYUFzm40VToyw5BwsAC72mbnQPU1GdJ1e/FiPBUbps+8GdlAJ3UlpDsM2s7qfdQ3H3GVrEAlGvOeOhw10PKfQkqFY0v64bxsdDOZU12ZyNzUVTNJ7XqlQnuUyZmEGeylgqa2RaxtFx67z/JHC+NOYLhU3/MM2Orcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CehOzNUb9g3odlf+hTxs6tQP8Zgr0KaXtXYKdCBXCeA=;
 b=QS6Bs2N+TR0t0ibJuI+UCAzT14Frfaak7oZdM8t2+Z7VdeA4TSeCztTzDr//h8tjUoe5oYcSfg4zJPWT/c/qu6KHhsRqK1oWcU9N7EARnInPYk6nAfqVW+J8mcL2KZbbSxaWmponAFR2ME8cDFQPpG3JepIR4jRfraW7nkzG85l+qzY81XjEpB/rC1MAThKtqOhHBm6ewlfgZbNUb/4x6CMqN7jezoS1E9WPtvCkkCakC0Xw+qGAr0fQQeAapRbKA9H76qfUO1EmgopnAzHo8B/ZncziVAnEuXASUSgTOxZPM8OvJMWPZl3mpgn+rwtsYCUPY2yH0nZxIz4PAVRBng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CehOzNUb9g3odlf+hTxs6tQP8Zgr0KaXtXYKdCBXCeA=;
 b=SVNo+G1iDYgqeob/wAPxvNPO8FmRIX+rLc8LhgcikYdzwUIz7c/0j4VdsP3d3mAZ5xgdyXCL8LkT1yjRoHxUAX8T3dkd+So+uNeNaW8Zlponc1EM8Y7GXYy/QBHJS5DiWBIQnjy7h8jEBmpUFMRUfmpTRpcZeaK4LvdwQeftBNc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN0PR10MB5382.namprd10.prod.outlook.com (2603:10b6:408:117::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 15:44:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 15:44:26 +0000
Message-ID: <a5ee5271-5236-3af4-c8ca-531534a69d4d@oracle.com>
Date:   Tue, 22 Nov 2022 09:44:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 01/15] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221122033934.33797-1-michael.christie@oracle.com>
 <20221122033934.33797-2-michael.christie@oracle.com>
 <f89a2bba-3988-1080-8c9b-bbf7bec3961c@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <f89a2bba-3988-1080-8c9b-bbf7bec3961c@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR04CA0023.namprd04.prod.outlook.com
 (2603:10b6:610:76::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|BN0PR10MB5382:EE_
X-MS-Office365-Filtering-Correlation-Id: 61a69c65-ac75-4824-4877-08dacca06f84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5YNQGpf9MdQtQBGoE7Gp5E6d2NvIgewOR32sPqHsxNcKd2gpVhXeEfqID3Yfu0TUBmx61kQNbHpIeTstCVEpNl07RFDDIoH/tT4uYbiqwN4ZTDICi3guSIpGYKEV/tCQy/s7mg/rerSMWIkmrSREOioo/yH8Q1frocU5TNdLjlFZOn74LycHeKYptR/sq/qV7VzRojjAMmYtaNDWRNGkr6juoV3hS/QN7/sC4LYVioYBnkCTKBtFClTx0XtrWO5pZvi9G/ltncrlrwV8wRArSvDcTu65OuCCf3o69ZxJMW4lzI3oEr9QRSVxlIgWs713yT6vVH8tdh88CI16zFTlslSOUrBL0YyOcIJtQjCy6lNJZmDTGeSri4+v9wl1SqxHb9Jw2yM4jygQ2E9G5uuBDBLHWBSv4DpFnh/oAGp+p6JISPBo5cuqQtBXlHlxmCzIgA1AoKaocMofmqP9LYoUjnDzB0JMonLdwd1tbwL+VueaHozSkTzlgGkAXY5z8/iPfEOvjdlMY84S2r/7WSPpkBQs1KpPRJ/wCNn9w9nqgVgn9OT2StC+dnuvpWYk3BPakFjcgzyLSzR9qSN0cuk9I/qYCGso+BGgQE3IQIfOIroB+FcRrkzCx39eD3DGzgw3PsMdt2K16pbdE7rlC8m2bxGUX55/vItqHBn8Q+Qyw8sGeswIWg2+Vzdnp/aHAMgi0bwnhbZdtM14e5SIH9W+ZjCuen6V3XEw3NCjsvINx/k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(6512007)(186003)(2616005)(53546011)(2906002)(38100700002)(5660300002)(26005)(6506007)(66556008)(6486002)(8676002)(478600001)(66946007)(316002)(8936002)(41300700001)(66476007)(558084003)(36756003)(86362001)(31696002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTFIeXRXd1ZGVko2enQybFZSRENsYzNjaW9GUDIwakJzenErM2lnTHJTTXky?=
 =?utf-8?B?Umoyem9rR0FidXphd2RhNnExRmwzQW0rQ3ViOUVONUNoazRMY09LREJBQ1Zw?=
 =?utf-8?B?bndFaDh6enJMQUREWGtoSVNjbVl4bVRiOG9wd1lMUEZEVEpaWnFSZzlqSnNo?=
 =?utf-8?B?VEdwelloQ1kxODlUalFpenAzZTdwRjZGZ05SUDdHdWRSenpadzRhelZaWjVT?=
 =?utf-8?B?RzYvRFhKbTNNOXZtaFc2T0dMNFRzRExFd2g5WlZDZmtjc2UwdEtpWFB4UWRK?=
 =?utf-8?B?MFNUc0hPSVRuUk5vVjNQZlE1QkZreEQ5VHp5WFdCMGNJOUFCQWFmUDBKZkQz?=
 =?utf-8?B?SG5kdzMzeHMyc0hDZkJESTNLS3A3b3pnRUFaN0NxSUZIeHJUSFMxaStZKzlm?=
 =?utf-8?B?V2RYZ3dZTk1ZS0lCb1VocFJ4TnRSRDcrcm1ObWVNNVM4MUVUaWF2SU83cjdw?=
 =?utf-8?B?RFRHQkNwR1NNcC9iNXRobEhSajhLeEtuSWl3U2tBc0pQQ0MwbTBXSVhTckpT?=
 =?utf-8?B?SmNnY3NJMG1TQ0UxNlBRbjFZVkFFbUpwOEJOVmtScHBPclVNQjdTNWoybjF2?=
 =?utf-8?B?QVgxUEJ4RER3VkpraDYvdnFkZmtqYW5sWXlaT3BHY2xpY1ZHLzQ4ZGxpS05y?=
 =?utf-8?B?dTlxM01XcmdpamdjbnBUNXNiRG9OUnZETnZkRjFuQVFXZVN5YkNCY2lSZUxv?=
 =?utf-8?B?S2hkV2FSdEFYTnhZbzZOeHVobGpHbEV2TmNPaEc4MkFuUVdIVEwzbFAwVDdt?=
 =?utf-8?B?alpvdkdjaGF2TjBLeDJPUnh6bEh6dElYSzAwWWx2Q1gzd2VMZWFwMmtIMjlk?=
 =?utf-8?B?NklrOXhhOUF0blg1SC9xTWR5SkpNOXdZTVFrWUkzenRHMERCV2Y1NEIrem1N?=
 =?utf-8?B?RTRCT2psaTlVdFc4RFZLVU9YNXV6anFxRWhjSUkyQXE3SWt0WU5TcWRkS2xu?=
 =?utf-8?B?YUFqSWswZmdtam95V2dJZmhRN3dhcXdrM1Z1RURONE1DTDZUcmRJM0duNDc4?=
 =?utf-8?B?d01KYU9XRTIyd2xzZnVYZHZ2d3ZNVEFDYjk2b1Faa0krYUVCenQxNDdGWG50?=
 =?utf-8?B?K2pjNURDT1BZRUw3T01DMVNxQUg1Njl5RW05c3hYVndGQ3krK2hKQkFFS2JS?=
 =?utf-8?B?aXYxS3FRMmlQY2hYV0tUQmk5eEZWMlN4ZEREREU3RWRScFN0dnI4RmEwazJ6?=
 =?utf-8?B?QmlLVUlCemZia0RTekJJemxhQmZYWWhTOTFEdmRIdms0Sm1kYll4OW9OSFVr?=
 =?utf-8?B?c3RkT3R5L2ZDOGhLMWhaejBiNXVzM0RCa3FjMEc0c0FUSmVqQU53V29HU0x2?=
 =?utf-8?B?NG1qR25GSjl6NmZsaFVZMzZTdXFuQTdmSGVPWm80bHNBWTdUVWdKa2pqYk53?=
 =?utf-8?B?cFNUU0dLMCtMNTR2UVpsTjAyR2dVZVZ1TjZVRnFialFNc0p1dmQzRHZVODdP?=
 =?utf-8?B?NlBYU05NckxkQ3lQWEJCWUJnN2pVY0t3eTIxcHVRY3VXNjZLOGFwajV5ZVhv?=
 =?utf-8?B?cEpxZUJDeS9URnZacGhHNGJXNnl4Z3pVWDNMYnFwNzlJRHA3bXdUTzh5NVcw?=
 =?utf-8?B?Qmt0ekVIWDB3ZTQ0Unp2bWc0bVA2cldyK3o4MGRPYWUvSi9CWXlpQm1JalpH?=
 =?utf-8?B?ZDJOR2ZodHVYdzh0ZGdWRUxGb1kwaURBeklMSGdYL0MxMituczZNdGNYRmF2?=
 =?utf-8?B?dk1pY1VCbnNJSXIxMU0zZk9hcGdWVFBWQm1QOEc0TW1nc09CLzlQZUpFN0o3?=
 =?utf-8?B?M2hLbCt3MGxFbXl6Z2FRdWZIODM1WWx1ZHA0cktLQUJZQVY2ZC80UDF3ZHd3?=
 =?utf-8?B?K3psZzViSHd0MHFkNk1SanZ1QmhsT0M1T3pTM1ljQWdNaGszcWxFdjBFdU1G?=
 =?utf-8?B?S05PcGlNc3RwbWZDNXVXalZha3Q4eGs1dWJGOHZTZTlkNW4wUFNsN1hsVDAw?=
 =?utf-8?B?dzVRSWtwaXJGWEhKd05MajBiNXU4VXFmZDVlN09OOXBzaUg5MDliUFhPNjJn?=
 =?utf-8?B?dWZQUTJaeGJzZG1OVmxhVURvMURMQUJBaTFWcEFtSkZwdjlDZ1RGZGxuUkhV?=
 =?utf-8?B?VlM5VUVZYmFOdzdrdkR2RHNMekdiK1JpWE1UbXJJSjV3cko5bWUrTE92Wlcx?=
 =?utf-8?B?TVp1MVBQQ1dpMkYrN2p0UElRZHdqeWxJdFNBaEloY2YzQlh2WU1GSVlacVV6?=
 =?utf-8?B?L1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: zs/JK/85ec8guHpzKpi0pHtGVzdtxyN+hb9JHaHY/NQB8yTGcdj67rQnXDU4rTxEKBaJb/sYsiQzSgwMZ43Kxv6MQCAaYdbLzhKKDF4tnOwR5sDDlM8oGpKcLd8YSu6Y4Ip1YKN5dAd+6umcIMuNwfMRG7s+z0QgbStjOXIrvWxuCEdCbKuBOTERDK3bpN0spJDNZf1k+ThoN4x6iZU1EMLSPtXPZeLvKlbQTEXAN/RRwpuRdWxzKW4cjIUhn2xEAX0x3Uy4riQrFaoEwfK6RdFBcp7uHE+SPfG3pl9vR/UKUJTStPRj7Onf/T8t7PmderU3Qzfuaw1rZ/t11R9qJwSXbknyRa9KaGhdhdm1/BJSXCyubZOMFWPo7pup1P3577rsn07eDY2auw9naxl0Na7rZAQvPHEscexJ+nRZMkH9I0g/xJesg4GeMhg9Fsin0c/a/FrpPxMKYh8nsanqDU1G2eW41u9FsYJg77a9lWgrBkgMtSpawkkDAYBuOBNkdEIK+E74EiOznLYV43veMTEjsa9dLSlJ4mgAN9iNRV3DRT+Z/1jXACJ76mlyr7vsRYj496y33VQwUUVZicSOH5GXL8JCPKRUsAh+0siIk8pO+9Cu/Bv+w+1KNC/oJ/vHGKN1zY/TDRRxadyHn/gYUztZP8OEDvPNPEifFdn2wUbRBcS2abV/QWatWeaTMubxDRq19IPJYyhQxKKZH1Hzs5Yv2oZIop4ztgs3PD/Y/10ZJm4FCPIim+A4UDvNl/78k1LY8g/0Q+XDKp5qIkiwaQsTbAECazOAo4lE537koke1cWotm6YcYbr/uHnysjgYy1+WaYJ1h3SJ/6sqL5VhIv2xwgrSWKy5Yc/BCk5RdTTfLBoQ7VmPaLKFGgG0CmTc
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a69c65-ac75-4824-4877-08dacca06f84
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 15:44:26.5682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11kL/USfrh7WaZDOgXyLO8r/+6pfi0qJ2BQJncpR/1+S9/IulDRnX3kD3jyHFeEaeEXqv53KewZ1k51fQs1/BtblcoRclmEI0EcK/6TeAZU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5382
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_09,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211220118
X-Proofpoint-GUID: 1-C71_kQ1y1z9l2VE9FJTqRekgcHneYK
X-Proofpoint-ORIG-GUID: 1-C71_kQ1y1z9l2VE9FJTqRekgcHneYK
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/22 3:16 AM, John Garry wrote:
>>
>> -    req->rq_flags |= rq_flags | RQF_QUIET;
> 
> Are we accidentally losing RQF_QUIET? Or does it matter?
> 

That was a mistake. Will fix.

