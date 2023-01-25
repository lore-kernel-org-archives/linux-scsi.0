Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0266AC54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 17:03:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbjAYRDY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 12:03:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbjAYRDW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 12:03:22 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B131F4B77C;
        Wed, 25 Jan 2023 09:03:19 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PFPxlM029537;
        Wed, 25 Jan 2023 17:03:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=JpI6phucVGvgpmcYBwWQ8QropSnMwO4iSQthqsBeIRk=;
 b=CRcjhDdtKEha0Md5/cHLf3ECHUrVDVmv/4+a/Vnx8tjryzZqo5B4JjJvdty9V3nBO7bf
 L2muF/Ux34T/YtDWaFci4rq7zkMTbL5Qfwr2GhpLUUg8jxWWgVxK0T2jr93nbsVtBuPl
 NsH+zOx64g0Ysz/iDgc+4fo3hoXOb27zrl0UgMUecQ0n1pus7aRBDkgzlg+KvUrqydPo
 MR/i7D2FCtJb9BKEY4GE6eBZjS8gkzesk/7Ehs07N+GlbS2pXPi7REjurate6yEKq0+8
 L2me0W/n/B6vGwwwrl3VRyttRJztbCu9oA90b9BmCQgc02XHebMt+6CAlGWMpEeQfFoh tA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n10jed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 17:03:16 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30PGJtV3031820;
        Wed, 25 Jan 2023 17:03:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g6syvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 17:03:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Il7v+nBwpD/WIf/VmGrxWfw6mDGIVX0Bz+K/1gTUhoadEHVne10hfHMR6KxIN+JZ6oQrzrfRCSEyAKWWZHuvxDGNuQY++Axo4rg0V/06J47GQD4HPCGo84gcmTY/f38qDR8KAq7nzZiOBoVZjlZiaAC7ce6DJ5YROWyS+udTOMOHaOLcFDh3oJp5HjHfTo1vH8qoXmBYo/KLFzpCqQNUbO1WGEd8ARKdM4PF0kdfQ0b1Mo08t5MFWyOKw7uC1A9zNNEPCqfNfwHw+BwiFLvHwopjLEL2lDQD6ci3sE3L+LyXMdjWx4Jo03sN7YloXxoUjzZqbBgd5h0sAV7Efd2NrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpI6phucVGvgpmcYBwWQ8QropSnMwO4iSQthqsBeIRk=;
 b=boXZGIDNl5iy5Fd6eK4pmUbQok+D2u63UfdH5z2pUIH+mZY3DwZ3Yj2bB8NYJVAYDMOlxCvcvZ1XYhm/OyVfbj7+3mCISwrQSJLNQf8EB84yk9aiOOV2q/BHzLD50mZZvCOZHr5dnwC6fOiCRmCxEcNq36QXO0lXbos0MgqMX+OWvjNp2btNc21DEvqzIqBd84RXQdVXo4xB1HryF4zj4DHEkDunH8ERAp8cldLUraS6BOVstTc9vsMm2NFz+87j0g2jGE2ORFeemRVCdk49kl5HvkdO8Jr0yLWzpakrB0ToQgnY1oKw/TcFQ2BGO85kCTo41f/CmNZHoS8IPnuuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JpI6phucVGvgpmcYBwWQ8QropSnMwO4iSQthqsBeIRk=;
 b=n46P/kwG1aScF7uHfcj/cPGigTubG/sD+rz2r2vUAuOjXDIUQH1hRezxz9jhrX+y2PIf1eY17P5sURz53XCWhuJg89KYCGka7AACfqqttvFMhvS8Wtb/7sd/D7urO1YwdolxC22Z853jOnP/E6rpeQ31loIeM2v1l23e965voYg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB7166.namprd10.prod.outlook.com (2603:10b6:208:3f4::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17; Wed, 25 Jan 2023 17:03:13 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.020; Wed, 25 Jan 2023
 17:03:13 +0000
Message-ID: <825571ca-4687-4b5c-971f-b9e13efb152d@oracle.com>
Date:   Wed, 25 Jan 2023 11:03:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] target: iscs: reject cmd in closed session
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Forza <forza@tnonline.net>, linux-scsi@vger.kernel.org,
        linux@yadro.com
References: <20230125083309.24678-1-d.bogdanov@yadro.com>
 <20230125083309.24678-2-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230125083309.24678-2-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::31) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB7166:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ee985c5-4b45-4799-129d-08dafef60b52
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v3TZSRkxM4vIESDWxR7fKbT/0v3joKqbcWmnomdnMgGT1kIZ8EvHuFiuzv0QS/xLO6fp1CtlUkbDpunwexJ7YFhdKe6PkqsZTUhgAVMuSg2YHYQE/RlOtaKsfZkFc1ea6lXrHBoybirBmbCVX7b6qXr9PX3gjiJLoxKFeANOt51FrZTbi/l/j6JKigDPNQQeify3f3dAQAqdfMzHW9nkoTGpQ8j6tEPi2ZhyY7evlE+M42J9VVJmDQlkDMw2JZx4k6DMqS47qDdt2pXvsk49/Vv8fXqS6RwqQFUoPh6INS4roUW3yGQOWiJCNj1QgzSHfYMjzJTE1YQptf0zXAflZrdkUbR1cQRVteZqqlOWnB8x3VvomYedfbdMUiU7yzQ89nXmrAYmbnewx5Xsz4wzFM1OTXqjAXa8AZzQOfmRB71UQQHcxfpFrtYSTr3BGXJByO5TR/9Of7lVtoILTAUZ1jc1tfM3LNmT7YnZi2LN/AestP5jNDUuudoNNxcReh41j69k4AjjD7i6QjyaPAnzTZdAyGX48etv9+sc1m6g59edMSThaJOmHY15C2exOs7BJcXicTrwnp47hBg0fWH0nsV6M6czA4lkQAI9/aEJM/VVYKuKGBiWe/K1LPV6l+fO5kkZv+p6g79XM8DubWW/GYra/IvbXcJ4MxpVWRIJMf/gVClMEi30qUl4o+C04jbOpN2Hoddl7z5qMhO6HnE/02IlaQa5hsEVVMCcH8Fe9v8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(376002)(396003)(366004)(136003)(451199018)(66556008)(38100700002)(110136005)(478600001)(316002)(31696002)(31686004)(86362001)(36756003)(6506007)(2616005)(53546011)(26005)(83380400001)(186003)(6486002)(5660300002)(2906002)(6512007)(41300700001)(66946007)(8936002)(4326008)(8676002)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXZIMHozRTNYa253eC9ualpDR3oySUY3Rmk3aHFHR25TckNGeStEMDM2NWE0?=
 =?utf-8?B?ckNKWDVMYXc1NkNiT2ZlYW85b3ZmT3kvTk9saTNRWk1CTWxBenErUCt3OC92?=
 =?utf-8?B?UzZ5MFFwSGJaTU9HTmIwdnduaW5ER3pCdzgyTTl0eTFYVG9tR0N6SncwckZH?=
 =?utf-8?B?aDJPZG9MMU5iTjlXWURQaWJ1ckNINEtSQ1c3S1lUbm8raG1hL3NJTUlselpn?=
 =?utf-8?B?eENia2x3UEhWTG9nT2J5RWtNYWtZQ255MmxpU3lELzJYbHJURlUrcUVQSEV5?=
 =?utf-8?B?by9tMGNFZXZmUGQ4UmEzM2kzR2F0SjExZU5mQmNkOUM2ak5QZkt2QXhyZE9S?=
 =?utf-8?B?cldXNE1WcWlyNExVczZlamlrRkxST3F4em80TklTVXVtNEFVak4zUnAvWDkz?=
 =?utf-8?B?ZmZXQkZOUWRCMi8xMlg5cmpRRThWaGVBdHZ1RXFHWDR5V2QxOGJQWVlodXZG?=
 =?utf-8?B?ekdBNU5VQWNKM3YrdEI5amQ0NWQ5ZVhJbHdGczdYUmh2d0laSEZ1WmVsNXlF?=
 =?utf-8?B?dFNHbWhMTkp0ckZkQ09PdGZKVXNRWGVrcHVaYVN3ZkZBVXNaRU82OUMxbmM0?=
 =?utf-8?B?NjI4S3ptSTNlNjNXcXhYbFg2VG5YQXlPaW90QmlXaml0K291bVoxUnpoME16?=
 =?utf-8?B?djJPRzNSUERkaWhyUjV3eXFEeDF0L05hWDNIUDNod1hsdXNvQmxxQ25GQXpL?=
 =?utf-8?B?UEVUZlVLUkFEWWZnL3NJWHRhckx3WktzWXFLZ2ljeFRuN1VTQVRCdy9XZDkx?=
 =?utf-8?B?SkZZckpoZkdMRTRUSjc2MVVHUVFNRjhXWHNDQW5FdU05UzFlc0ZSdzB6QXg1?=
 =?utf-8?B?SkYwKzdGUGNFdFNJNnRMOEQrOVJYY1FqMHpaNU1ER3RPRXBucGJPOU1pWkhj?=
 =?utf-8?B?QVA2bkpHTUlCejUzRE1vQWpBNHlBMmRMMGNoYTZjWWFmUENiai9JZUhwWkFr?=
 =?utf-8?B?cG1zZEZwTWpzOVozUk12d1hHVWNkVC84czFnYy9tZ2NtT1oyRWE5S2Q0Y3B5?=
 =?utf-8?B?L04yNnRSV1lBNFhQVXBZL2Ywb3gwdzRQMGp6a3NGUHBTb09DTE16ZGk5WSt0?=
 =?utf-8?B?VG5wdUdYRjRnQVJOSWdOZzR0WG80SG02NktwYVdSQmlKd0JEVDhKOUpySzhI?=
 =?utf-8?B?SDdOZkozV2NsMjlDaXd5b0d2TkRGZmN5bnNScWJ6WGF3WUYvbGh3S0R1NitG?=
 =?utf-8?B?MGlSdVE2RHlyeDBoY2ZaYkdGWTdadGFsNGtOemJ2c05KLzFrMm9JcVJHdFRx?=
 =?utf-8?B?S3FaNXNwSDAwcmU0UG5rSEVtMEZzdDZaMmxiblIyalpXZ1lCUHp2TFJpMEVE?=
 =?utf-8?B?NnFOd0RoNmRScFI3Vit0ei9Wd3VXSXZiUXRxVC9BMlEya3NUVFByMWJuaXhP?=
 =?utf-8?B?MXZUcC9NTjNmTHRxK0tCTlZZSnFqR0c4Snc4SXpveHJWUUdGbzA4VjNOV0c3?=
 =?utf-8?B?UVV1NGdCNWtFYzNmTUpEZzkyMTNOMlVYQ3k0b3lzK3c3eERLSWFCSG84TFRH?=
 =?utf-8?B?MTdQbmxyeWVtU0FOd2VWSkJ6UUZrWjduRk85T3g0UzFIeEJhZFpDVENuR0pm?=
 =?utf-8?B?S1diOHpjUUlWMmczTVpVcHllZXo4cloxUEZvY0lsRTdoQmlzL2NDTjhaTEVz?=
 =?utf-8?B?TjBkcjdRcHdhLzVpQnl4NkdjdUtXNXhSQ2J1Mkd4Z0hYYTdwSlpxenBUTnBZ?=
 =?utf-8?B?bTBKWXhUUXM3Z2VDSGViak1ySWpTQ2sxQzdVelc1UE5NL1lJVnNZVThmcFor?=
 =?utf-8?B?RVBnL3BaaDU3alkwck5qUy9vTHVTRkkvSWFacDR3SXk3M1hlNTY3d3M2R3JV?=
 =?utf-8?B?VXhjU2JaVUhaUmJNbmJ1aWY0cng0TE4zV0RkbUdjYWwySWlHVmN5eGwyWWps?=
 =?utf-8?B?T3lGdGdtZTdGV1k4YVF4cHRpZk5lbzUxRjVPU1RWRVJFTFlBaU9GbDBLeU5v?=
 =?utf-8?B?NkFjS2phUUI5T2F0dG5sSmRuZlBaY0dwd3Ayam9VYWpPVy9yc2VWdVhOMzlz?=
 =?utf-8?B?MndWRmlPSmkrYXk0bGlNeDFpN09zaHkyOWF6VFV6NFZHNXB4R0s3YVJxQytS?=
 =?utf-8?B?a0h4TzdoWmRCYzl6ZEphbVh2anpITWFmelBtQnYrclNGS21jUGkwZEJaMy9k?=
 =?utf-8?B?ZG5mMjVIZzJwbHFsOStEUGdkS09KZWI5YWRpa0RpaXh2M1dPNmFpWXcxOE1v?=
 =?utf-8?B?aHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Ceq560zdltRrukDawnuXxQ/qr+Tk3vNCqkf83k5lnEGqU8P9UHcHsx2Z2b9agWCNbwJdhfbhhHSFHZTdpfV+/m1k6930i62fLPBmEXuT+n6WefbAoZ7YnrazNyibAKXcYXjmA/5nkuJ76AwklQqV9nc2FTGk8/oRTaSn0e9T+HfqRO6BFhx18ymQK674lFajk4uQWevlJKp+GaSqaPSQAw5hh3Gvqqj/m57kud1Vo941hPxzI3i5PtNK/zYZymzSfca/qWKtqBpgi13iDY3tIq1pNpTu9huwU3n8oBrM4PM4fJxEBahrwGRTmA4gPhY6kWizrm0r4mKq78IwBtzf8eT9Denf2QxlsTO5QPagVyfo9C77pA4KSjlYvv5eMx9pI20kmwnI8COK4vHEEETTkz13Aiy9YLSpi9iNKkDOTXCzsMndm2qAMozLmTCsQv00m/hFx21Wd77HTWj9KlSiHsqRWk/WfnvZdftMbtXs3modOp99XXzzfik6mF32GsaLdzlpSo6d74ya1B7Obes/2VMuP4I2LevGAfy+MrHFwCfPg3dtGwC67MApxcGCx0cwSr0XJfxvNai5+bEsq+ooH51EyGEEvrP3eQRlHpE+IAajzNwfjLcmoKx+PId0kzETmKLZAsJlCiOiYgpOThsdnFgzKaPo91ZLE5RYEzwttCXF7yHfSWC4cHAi4bz0krYnxsC7Y9/NWBUq93JUMrmVbTFTxFLzBClR6ZY+Zi1mmkfgUnx+iXOibz5A33W8kDbEh/h46mNakCho8tlIS+wuyktYpeNruvayrCuXXYO9t3dYKO5vGjxmU/K3+lpDp+cS
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee985c5-4b45-4799-129d-08dafef60b52
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 17:03:13.3715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0n71k71bY4ej7UDjRHKfKu/kQjkAPmqn4ekxZXOdqPx/W+OvndGZYjjDf9XilwTQO+Q3Vssi6BKGQuVNjAvmBchBXJ3uwHxsnTC1OnubFm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7166
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_11,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250152
X-Proofpoint-GUID: tbjMhNa8P9dNg8FT9PKoNXJwKKVKN8ZQ
X-Proofpoint-ORIG-GUID: tbjMhNa8P9dNg8FT9PKoNXJwKKVKN8ZQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 02:33, Dmitry Bogdanov wrote:
> Do not handle incoming commands if the session is already closed.
> 
> That patch fixes the following stacktrace:
> 
>  Decremented iSCSI connection count to 0 from node: iqn.1996-04.com.local:3
>  TARGET_CORE[iSCSI]: Deregistered fabric_sess
>  Moving to TARG_SESS_STATE_FREE.
>  Released iSCSI session from node: iqn.1996-04.com.local:3
>  Decremented number of active iSCSI Sessions on iSCSI TPG: 0 to 1
>  rx_loop: 48, total_rx: 48, data: 48
>  Got SCSI Command, ITT: 0x2000005d, CmdSN: 0x4a020000, ExpXferLen: 0, Length: 0, CID: 0
> BUG: Kernel NULL pointer dereference on read at 0x00000000
>   Faulting instruction address: 0xc008000000a9b574
>   Oops: Kernel access of bad area, sig: 11 [#1]
>   NIP [c008000000a9b574] transport_lookup_cmd_lun+0x37c/0x470 [target_core_mod]
>   LR [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
> Call Trace:
>  [c000000059e4fae0] [c000000059e4fb70] 0xc000000059e4fb70 (unreliable)
>  [c000000059e4fb70] [c008000001017318] iscsit_setup_scsi_cmd+0x520/0x780 [iscsi_target_mod]
>  [c000000059e4fc30] [c00800000101c448] iscsit_get_rx_pdu+0x720/0x11d0 [iscsi_target_mod]
>  [c000000059e4fd60] [c00800000101ebc8] iscsi_target_rx_thread+0xb0/0x190 [iscsi_target_mod]
>  [c000000059e4fdb0] [c00000000018c50c] kthread+0x19c/0x1b0
> 
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 8 ++++++--
>  include/scsi/iscsi_proto.h          | 1 +
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index baf4da7bb3b4..f6008675dd3f 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1199,7 +1199,9 @@ int iscsit_setup_scsi_cmd(struct iscsit_conn *conn, struct iscsit_cmd *cmd,
>  		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
>  		conn->cid);
>  
> -	target_get_sess_cmd(&cmd->se_cmd, true);
> +	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
> +		return iscsit_add_reject_cmd(cmd,
> +				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
> 
Did this require target_stop_session somewhere? I think this is a possible
use after free.

It seems like if we have logged the message:

>  Moving to TARG_SESS_STATE_FREE.

then we called:

transport_deregister_session -> transport_free_session

and freed the se_session.

So above if target_get_sess_cmd returns failure then we have run:

transport_free_session ->transport_uninit_session -> percpu_ref_exit

and transport_free_session could have done:

kmem_cache_free(se_sess_cache, se_sess)

by the time we run the code above and we are now accessing a freed
se_session and iscsit_session.
