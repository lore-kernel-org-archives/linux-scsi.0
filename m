Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9C9C04A94
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 19:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbjHBTl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbjHBTl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 15:41:26 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54C4CD9
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 12:41:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HIkCG030163;
        Wed, 2 Aug 2023 19:41:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=uuu17EeTBAxuW9WKdHX1KNL0EKTsY/DFNk2coE0jgXY=;
 b=VbhMcth9uBJapcsoIc1XrIM4J7VyajZ4g3DDLDkLfqvk5A2c5P8qlGfGF1wpdwY0QoXL
 ZfB/7S/kXn8fqY2ouLuTR2pwhmfe7hsccz8Unc179V0QmDa5idsK8uHt5crwEWlA2LmQ
 Acs4PNqFS1ateTD5VeWgd7uZg/VAB7ZVbIcxZ8OvGSAPfw2f76d9yA+kvyPIOJAxNpme
 6I3z+Jf2vatAcPq7bmymcGvz+waraK/CmegMkZw8yRqIxAZZqssktofw63dgnEPV2N0C
 0TqwhFCEZQkFbL82XqJzvyCMuxhyuNbS9iSWUGvV9KYlDxtU6zYNuRb/aw59gTMXitl5 Mg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tcu0230-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:41:23 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372IRM3v025186;
        Wed, 2 Aug 2023 19:41:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7ex3vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:41:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbbG+7MHpJ47XyDS5VntM5IvytTQ0JXYLP9GP8vuUU9s/0LQ940GO+KegMEUul9FWjGb2tk9m1T/WKpVBiZ+DW6TkBCyzGBtDTWdMqdTQ0TTkI2DEVT+diuoEok9EhvTYOkn4OYyTIuCMWLm/lCkMgYfS4JgzkUFwhKamNmY7muoihEYiuURyWsBDoo6Kp4KrqArOyUjAu+NE5hqPlIviMant6OMNxKYapioPPDq9mRVZGKEcUf6kpwwZRcGytUlVStUpJJUsWhTChMGMJbeFUzmjFKiX2/8LtRvOHpY/jN4bKggiddRsoX/BHgTFVXL+3XV4N4WrEP0+gMbfSj6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uuu17EeTBAxuW9WKdHX1KNL0EKTsY/DFNk2coE0jgXY=;
 b=bZkXdZWrQPNzmk0b9nE3gWnf4tUEGq6bA7fuWLM6VfJfQStmPwL3iq96EWlHcUSL4yaVsXms64ilF4G8c4ItqQ2trpmgh3bEPqZyr+hCYFpijt2044NrpLrZ9jaDnE0iZ3UV0t1il5UitvcDpVqWfglOs5YhYhgggMGssfxv+XlvrZKYkjNo96YhcSeNegbCBAcb17Rv6u3xaN08O4m6M4CwsNjpDppkXkxYivMpJvWKxO+Y50PNNOhZ7SPVtCvEdI0W7j74BHV0ifIrJqqjddZgRkweTPBCA5OSVQNtnev233QDeMbgmACcrmTE/WgJNwmjVQF1G/rFiwsBz/g2Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uuu17EeTBAxuW9WKdHX1KNL0EKTsY/DFNk2coE0jgXY=;
 b=ETEk5deQwMDpLb/gfxcavJ26HpJf8BW+BdUYYcXZ2GJJuvu5Bf5xE1bsBkjAKRTOhwt2e9SIwaL38ssKNipO0WnOBP+w6uiSUI0TY+EzvG+g9ciGt18scBlDfwD15mmrF214z1CSmXZvEdVz0Opgl1K/8nPxyf50+flMhhK9GW4=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by CY5PR10MB6072.namprd10.prod.outlook.com (2603:10b6:930:38::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.47; Wed, 2 Aug
 2023 19:41:21 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 19:41:21 +0000
Message-ID: <9a056eed-653e-f018-ff94-be9d2bca8e4e@oracle.com>
Date:   Wed, 2 Aug 2023 12:41:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 02/10] qla2xxx: Flush mailbox commands on chip reset
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-3-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-3-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:a03:60::20) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|CY5PR10MB6072:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a9f03c2-c9fe-43dc-83e8-08db9390727f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3KhaUSYyr6sedyDftpCYUzoeFbeZC+8wAMTl9BjxQ+7LlTgixNWZXAUoXISott7lHALHu1mU6JvLPass1FenmD061A2ZxIzjh2bEvQF6x3a7NbhwkcsV7l/icc5Owhnsswd0UyrkyRoonKg3H3veGmcrFsdyymAr26Dgn+fuI3dhCT4NGSHkHBulRtr2cR2s0Z7Cgixatulz3vG7Z7QAPXZjlCPpXIpvnBx5nYTXVFI4yLX8UPHtM0qrLsn3hdGM1G3GW7QRKSSBa6Pjfd+wEj9fug1TjHqk0NEL2fM8RlmBDLjMdc7AzjvbLDMEOkrRexFGAaHhm5KWOiSQeiYNglEe1YBcHIHPjVhdVzr6UfU4dkh2XNKUWwEv3Ci0H5LuuRz+ozT2q21VYtb6B6yRCAOvE27vKDS+ntOBnknGtlq8IqBHrN/lx1+s93ZYMXj6niHQWWeQxJBrsuWzn/0JrJawRdM4TGyL5ECPYEMUXP7vQ7FQCJErDPNhQ9MYPkalquZwiDDUSQ2qPG0Vs3x6K+Vd8DKCVNCmoM6vwpcplPbGiFV6KyJu15BHBLDR//OQDcJ9uKlU6AUX/t9GSOPiOuhYyVl8M6WWE//6+X3wjVNQzSV2d8FsWpyWPW2Uj3yTn5b1RkcIR9LlcvbkZyi4PQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(396003)(346002)(376002)(451199021)(31686004)(44832011)(5660300002)(8936002)(8676002)(15650500001)(41300700001)(66556008)(66476007)(66946007)(6636002)(4326008)(316002)(2906002)(36916002)(6666004)(6486002)(6512007)(478600001)(31696002)(86362001)(83380400001)(2616005)(38100700002)(6506007)(53546011)(36756003)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZElzZVhJY05XUDJuWnFvbFk1dTdmajVkWURhU2p0Rzl4dU9ySElRQVl2Mk1I?=
 =?utf-8?B?NkZnY2FRZlUzNW9QS0NRS2h6VUhvV3MrUzZhUDlOUW5jSWtUQVJvZ2V1L0Yx?=
 =?utf-8?B?anVQa3ZSZ3JFK3ZYbmdwLzRtUHpKT3NNZEk5WTlTSmtieFllOUY4ayttWFpi?=
 =?utf-8?B?bG12QVRnUW1TbnlqTHN2L0VGM1MvU0d1U2R4b3VEUVRYamNBK1ZjM1VMQktH?=
 =?utf-8?B?Q0pvMTlMc3BaRmhVbTFKSWIyZFNlZG9VK1BLTnplYS9BcVY4d2o0aDhNRkJv?=
 =?utf-8?B?Zk0ySHlmR2NLSHVtTnRpc1lqbVY5YkF4UlhsUUxPZFg0a0drcTZtSzR5Zy9N?=
 =?utf-8?B?ckdpUlFlMG5lYks3ODQweEdKYythUnl1Q0xQSVkwWnNqeFgvV3ZFWGRDWS9n?=
 =?utf-8?B?eFR6VUVPODFjSUhTWGVrcXlYRXZtWTV2VnNZT1JvNTgyeStHQUE2N2pRSEZl?=
 =?utf-8?B?N2xSb0ZPQTRNWW1aZ202bHJadis3ZVhBZVM0QWpMRjUxSDIwMWU1dDhuUmRK?=
 =?utf-8?B?aGRXY1NDVnIzckJyY1VVMGswQ0FvTXV6KzQ4SXJIY09KcWR0Sk10a2huSUdw?=
 =?utf-8?B?aWxRK0VQN2V2S0srRmVBdHpHN3ZMVTR2Yi9uYmR1MTVmRFVVQnlLY0ZKNFRY?=
 =?utf-8?B?YlBLc2pRZGdkN1pxc3Q5czdWdnNyeUVuS2lqTkhsUS83bnk0Zml6cXhUS0RL?=
 =?utf-8?B?elBTSWhmVXlvQjRPN2Q4dHpUMXlKNlU0M1FmQlZNRWdacktHS3hUT0FJaWFj?=
 =?utf-8?B?OUViWTROdFJvYUllV0srSHlnT3NUZmFVTndiK1pRcm5CWmV2TzVtQ0JxRlZU?=
 =?utf-8?B?Y0Nsekx1OHJMUGthNzQ2cjVYRjhWQ1NUNDMyTjJWcWF3SUd0OTRXUWZOY1Ro?=
 =?utf-8?B?REJ2ejVzaHFGanF1bFNRWTRJdnhDc1lWbytiRnBUWWRHcjBodURWN095QkVS?=
 =?utf-8?B?Nk01RnRLUFVHVGVvY1JVK0dHQWx1UDlYMENmb0hxaXlRMEYybjZZYmMyYk1S?=
 =?utf-8?B?T2ZGaDMzM3dLYVpVdUFuOHNSVW1JRElWTG1RUDYxcnBNK3lUWGNZd0VEb1Yz?=
 =?utf-8?B?YXZRUGkzL24xTE5KeXpYRTNxUFEyRTFtd2hraUMzN0pmZCt5RkNIRXo4dEpV?=
 =?utf-8?B?QmhJN0lTSmRNSlBYV1JHVXhaVThxK2I2UGVMaS9GdkdDQy9wWlFOSDh6akc1?=
 =?utf-8?B?T2tMZFhFTGRCYXFVRlVRZWRCVk1wTTFsNlJqZDlQcFdyWVdNNVZoQk9TeWVU?=
 =?utf-8?B?aEo5YkFlMDBTaXphTHpLSjdCVGRiN0cyTU90bkNucUs5SzFxUytqbFowL0Mr?=
 =?utf-8?B?WkhPYU10bGlOeFo1NWkvb3daY2xKSUNkblVjemZTM1hBMDZYNUlkK3RUR0JV?=
 =?utf-8?B?QmExSlZUTWJHTCtLTXc1VzFucjNoMHMzTmVXVTJXWUZzRFNjT0RodmpjcHV5?=
 =?utf-8?B?WU96QVhMR3FoMHdXUTZxZDhaNmpuYVkydThKdHVDbEtURVc0VlM5dFE3SmFP?=
 =?utf-8?B?L1pjOW9mTjZ4QWpvbjBrMElUZHNzYXNlak45TlkxNWh3cjVwTzlkZWlhb2J5?=
 =?utf-8?B?anBoNjl3NWtDbEpMRXhQR3NqbUVlTHFNTXNBWVVMa2h3cU5yRzhjM1FnVWtG?=
 =?utf-8?B?ZG5sbkZKeVpSMjhkaFlvZ1d6NXQwcG1vSDVpQjVhdjNReXRwOWVJZlF1VUkx?=
 =?utf-8?B?Qi9nRjI3dWNtOTRTaGN4Zzg1Ykd6by9EZkl6ZVBqaDBWSFpWQ2xzRmtEc3dq?=
 =?utf-8?B?dzNWVG5PTVEwaGg2WHBEZW1IUU9yYStwY29lckNVcDlXYzZEQVNUTThDR2pi?=
 =?utf-8?B?UGxlZzFpaDN6WXhOMzQwS0xFRUpTdkNZWS9XbVg0OUxWczVLNVl4cU1tZlc0?=
 =?utf-8?B?bzdsQzZvZnlYbW5Rb1poRDlZSXVCMm9kdzBMZjZqS3Y0N0tJNENTWnZaUm9Z?=
 =?utf-8?B?THpjUGJsSmVXbFg4OTJ1aXhRanNSeUNNc0hkdEVGSENNSEY3aGVCTUY4bU5n?=
 =?utf-8?B?eEFZdEs5NHg1dmxKMnFIOFVsZEVEYUd1RkRqcUo0N3NUbW03ZlZaMjk2a05M?=
 =?utf-8?B?RHBGYlNaR0IyVFNVelQ5OWdJc0NXTnRHMFJYVnpnbmxZV2syeCtudVVZbDda?=
 =?utf-8?B?WGNuTjZSRnFwenJHSUhRY1p2ZC9QZkZ5bjFUU0JuRE5rRnVuYXRrVlQvU1la?=
 =?utf-8?Q?pnR14B6JUiWOpKfnUh8OzRU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: dqrenrIQvBPXngE255sRGQpsiyRdNvIAuzWOuajZuHbTY/p+a/UqEiqZzY78f2MQGO6i3EYHAbTawvAvngRaRhhG2Bl6ILsRlYb6MUPgG9UXBnnNzKEAQ7sggQF5q0uHHfJavYW53FNYeIA9CKF6VuKpW54fGITzz92Fu8/2xnxYRq8O9UNK8FDYd3PUoMQTsn1Q0pyAK7SjV48vWXl6JH3gURaSMTcMvYZt4wwnwkccwW6lQ2qe8VSHtLVzVJv0PYt8rxFQ5Qy0HZ1lxhmWmS+BjXWaCccFI0mhSR85Z0jYfF3F4a9BqgCokPO86U+YzyN/eEiXGHR3eb9s4IpJGXSI/heIVSWLHZ4ZuQXYhA5mDFajEuxIuj6BP/70j13nBrF8+vPZBNTvfgszy5fO70JRnzFQx361KJq5BBMq4Pvci/+hT7/EnE9PooovMJOlBe46mZklbJtVfL5FYfBNT2VmbWlECpkDb1f+JKzcwIJtftxpXTsWSrR0iIUS+coSXgqXO3LAO3BIO5Cn5D6IxJmyyv1NHy2ja/JdPn3x1d0IkWQZBMkLcJOWvuKBgDmWVjkfe/kEzsgfSIMQs3Q+HnFKOB9TBzQqzSZM+AQ7qv9Z3p+AYp3585CAzYOsIAMa31jzmXH8WP+dSX6fq5awTWQ8KMMA3ca5qt9GY+K42UD5lvGdoy7Z5VuGJ7X9KLUE1wstsxOV9COfCZfRbqz9hLcS1I0kDautPpEKI3GAoTmlR2ImoAtn4cmHrxoMcIVxIQNBeaI1a7Zo7TXxYLbRnQDw9RoVRZTcBJEvtgswjWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a9f03c2-c9fe-43dc-83e8-08db9390727f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 19:41:21.0978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcFGQPhvgW8fJOExKgyFVUDlyCWUstF+uIcVWRiF2YhSMJzbLjySpiyWR876PYcciUGwq/m/DtCwVwfVhpde+pah9xAR1RRWO2ICirg3LnM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6072
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_16,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020172
X-Proofpoint-GUID: cFxzirJCBRpgWl3DnR2rM8HlmrXal15z
X-Proofpoint-ORIG-GUID: cFxzirJCBRpgWl3DnR2rM8HlmrXal15z
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> Fix race condition between Interrupt thread and Chip reset
> thread in trying to flush the same mailbox. With the race
> condition, the "ha->mbx_intr_comp" will get an extra complete()
> call. The extra complete call create erroneous mailbox timeout
> condition when the next mailbox is sent where the mailbox call
> does not wait for interrupt to arrive. Instead, it advance
> without waiting.
> 
> Add lock protection around the check for mailbox completion.
> 
> Cc: stable@vger.kernel.org
> Fixes: b2000805a9759 ("scsi: qla2xxx: Flush mailbox commands on chip reset")
> Signed-off-by: Quinn Tran <quinn.tran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_def.h  | 1 -
>   drivers/scsi/qla2xxx/qla_init.c | 7 ++++---
>   drivers/scsi/qla2xxx/qla_mbx.c  | 4 ----
>   drivers/scsi/qla2xxx/qla_os.c   | 1 -
>   4 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
> index 806d08f4f310..5882e61141e6 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -4412,7 +4412,6 @@ struct qla_hw_data {
>   	uint8_t		aen_mbx_count;
>   	atomic_t	num_pend_mbx_stage1;
>   	atomic_t	num_pend_mbx_stage2;
> -	atomic_t	num_pend_mbx_stage3;
>   	uint16_t	frame_payload_size;
>   
>   	uint32_t	login_retry_count;
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 2a9fbb3e12c9..ddc9b54f5703 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -7391,14 +7391,15 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
>   	}
>   
>   	/* purge MBox commands */
> -	if (atomic_read(&ha->num_pend_mbx_stage3)) {
> +	spin_lock_irqsave(&ha->hardware_lock, flags);
> +	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags)) {
>   		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
>   		complete(&ha->mbx_intr_comp);
>   	}
> +	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>   
>   	i = 0;
> -	while (atomic_read(&ha->num_pend_mbx_stage3) ||
> -	    atomic_read(&ha->num_pend_mbx_stage2) ||
> +	while (atomic_read(&ha->num_pend_mbx_stage2) ||
>   	    atomic_read(&ha->num_pend_mbx_stage1)) {
>   		msleep(20);
>   		i++;
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index b05f93037875..21ec32b4fb28 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -273,7 +273,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>   		spin_unlock_irqrestore(&ha->hardware_lock, flags);
>   
>   		wait_time = jiffies;
> -		atomic_inc(&ha->num_pend_mbx_stage3);
>   		if (!wait_for_completion_timeout(&ha->mbx_intr_comp,
>   		    mcp->tov * HZ)) {
>   			ql_dbg(ql_dbg_mbx, vha, 0x117a,
> @@ -290,7 +289,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>   				spin_unlock_irqrestore(&ha->hardware_lock,
>   				    flags);
>   				atomic_dec(&ha->num_pend_mbx_stage2);
> -				atomic_dec(&ha->num_pend_mbx_stage3);
>   				rval = QLA_ABORTED;
>   				goto premature_exit;
>   			}
> @@ -302,11 +300,9 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
>   			ha->flags.mbox_busy = 0;
>   			spin_unlock_irqrestore(&ha->hardware_lock, flags);
>   			atomic_dec(&ha->num_pend_mbx_stage2);
> -			atomic_dec(&ha->num_pend_mbx_stage3);
>   			rval = QLA_ABORTED;
>   			goto premature_exit;
>   		}
> -		atomic_dec(&ha->num_pend_mbx_stage3);
>   
>   		if (time_after(jiffies, wait_time + 5 * HZ))
>   			ql_log(ql_log_warn, vha, 0x1015, "cmd=0x%x, waited %d msecs\n",
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index d622d415a3c1..a18bcc86a21a 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3007,7 +3007,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	ha->max_exchg = FW_MAX_EXCHANGES_CNT;
>   	atomic_set(&ha->num_pend_mbx_stage1, 0);
>   	atomic_set(&ha->num_pend_mbx_stage2, 0);
> -	atomic_set(&ha->num_pend_mbx_stage3, 0);
>   	atomic_set(&ha->zio_threshold, DEFAULT_ZIO_THRESHOLD);
>   	ha->last_zio_threshold = DEFAULT_ZIO_THRESHOLD;
>   	INIT_LIST_HEAD(&ha->tmf_pending);


Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

