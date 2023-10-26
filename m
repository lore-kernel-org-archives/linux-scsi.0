Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EEFC25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 16:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbjJZQyp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 12:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbjJZQyn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 12:54:43 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F9E1AE
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2023 09:54:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39QDijnp001689;
        Thu, 26 Oct 2023 16:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=FD854A9Ri416va6LVNOMaeTcm6PTbFwbQOVfuS+L9j4=;
 b=T+S2Cqo8RTU0RnwzljWNkAm/u14iPFSHUPaBjUiDE7WVSVJxQE1uYehncL6SbC9hBm65
 APP0kkUC1KEB1LXj+8NBkyxkR5nA1iXnQ1lrNTTMtJy1/q5y88IsL5I+kzyCvVxMVUks
 q2mKGt0/GY3fF7t7+VqbIU3KAoqh8+UkxB6qEOui4Epgp1WV+0TYKcaa2Vsn+78eR6Oy
 DTk4MLnpqvoar6Jchn5tUwAdtqsbAlR/qAcDul8l0os6fo0NfX4/9nFFTf+jQOemJ+R2
 DANYPPIzgFbtFxJd41RlAVM5t9vKQR2D4a8PsNc2Eig7B+F7wiODVAKWav4uTfP2Xgda 9g== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv76ubhkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 16:50:10 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39QFcgkB031184;
        Thu, 26 Oct 2023 16:50:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tv53eymar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 Oct 2023 16:50:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DoMpPxIKgpG+VoJaEiA099EveRktPpxjFz0IGR9svvBNdABe1wY6bVnKUAR8Zv2/niSN5AKhbFCZQco0WDEB9EOGpxIogrFW1jdymyT6aSy3SDmO63TQr7nkXPsyjrPRqWyt51fIVtAnZZ5aISZt5PSPAR4OUtLPc2gGfDlsnUF/PAkchkiI96j77ldRR45djUc2mo/uyaB80hvcnFil6BoXRPFTgZ3FhmRjiJyUNL8TDNF+UaMShWsCJ28HgSHNbRGs1DytTQ1y+/MG0h6fOxmZUjfRX7VPkFs84a6cJ+MgwBzYoEqxpIs2TC9qemElbWaz/SA92kkA9aqwAV5KVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FD854A9Ri416va6LVNOMaeTcm6PTbFwbQOVfuS+L9j4=;
 b=SIBi01ZfGqsA1+nr41zQTEW3wO1nsykrv/7/eoSpQ5vIOF1RK2qU5ndFD8JvPZRX+Z03+AfLjIDI17cdU0gR7yhqMAQqLe5obpq3TJaJpxuzee6q9ecQUjK5JrhRSBg1Ej1qc7RGj41HlqneGlXeRiBsdsOo/aOZnCcVHnO+bB8fORlimy030btT3eo8p1r6U1eABmJmy3pUAp5AI36oAt2ppT8atg4YosFh2gY0w4pZoXBJBMXQmjuqOYO953kbZbfXPhsfJbpUFfTRb3vnHQ7Wsee8de8k+ju1u/IyM+wfYl1jggP6p44bIIhaEjQSAHGaWugVes5cE/uPkERaLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FD854A9Ri416va6LVNOMaeTcm6PTbFwbQOVfuS+L9j4=;
 b=rpwJmQiuRe19jdVmkKtR8Yg9GJ/caYOU8iZPSD3/cIdGVd6yUUMWxS7JAC/JYYQNtW8VP3qUp7oFdWdC5onhZ5kPZA9sH3O3Bh8P1JONVPdAgbCg3T3joegKWFnCOxMU9NlcWR12/deeQd8TLRuZ5Qw46OVhxBTd6WZiTSFqblo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB6589.namprd10.prod.outlook.com (2603:10b6:806:2bf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.19; Thu, 26 Oct
 2023 16:50:06 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::449f:4fd9:2d3e%4]) with mapi id 15.20.6907.032; Thu, 26 Oct 2023
 16:50:06 +0000
Message-ID: <6ba0093c-9c0f-4669-b1fd-ec2baa1738e2@oracle.com>
Date:   Thu, 26 Oct 2023 11:50:05 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/10] scsi_error: map FAST_IO_FAIL to -EAGAIN in SCSI EH
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Benjamin Block <bblock@linux.ibm.com>
References: <20231023092837.33786-1-hare@suse.de>
 <20231023092837.33786-10-hare@suse.de>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20231023092837.33786-10-hare@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0091.namprd05.prod.outlook.com
 (2603:10b6:8:56::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB6589:EE_
X-MS-Office365-Filtering-Correlation-Id: a798721d-a2df-4aa7-038b-08dbd6439b98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IChMnrZklN16BUixAHdsJ6zV5u+ZpRd+Ia1yUHMJ4PXFN+I49G5A12hHo3KoApr98Bl/vDcKjC6ByTswjAgfIfAa60Ro82XlqxbqYWVgkNma0jnzB5ftYjeFm95sh94gmWx1D6MO5NqXJ1Z3M//sly+Boq/SaIciGtczvbQK39JUQXBpsWA8lR4pG0slGbFrRHX3Gs5tcW11GJ6yyajZknyv+H8WwI4/vyrZG4lLwz0LX3QgnerRIpanJ2mDOXQAz4FXneGDP/3cMPCNU3eKq9VAtIfVu2huc2GRDbbqlZFDmlHaDtO5Vlypg8cjXp9wnFzlZrAZqjgU/4iBfsTAwiwVxpKGp+HLU5Hfz2tSx0eoU0KFGMaHEXe2tC0eJZIaOvkpT3SV93suDLa0uIpw11bjaALaSgYc2Dez4Oy1I63T+GBm7gtxHCD38LopFoOw3FrTe4166YiEMV9UbxPRu3cv2ypokLy2crSMj++mx2mkfl51fOkHQAl9OFtwZBn/O8qnNjto/Cq8NLUU2svEPBz89/R4Hn4K5FGKay0xGId5XiWr4ZfqYzlU3csBruiz2HpPOStvuwFBVIlVsUfOPr1Q/JC7qAL1YrzTf4ODaf3qAm9pypUGjEHcnTA+Yc/kgwlEAXxqyzkol8GCl2uV1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(396003)(376002)(366004)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(53546011)(478600001)(6506007)(66476007)(2616005)(54906003)(66946007)(6512007)(110136005)(36756003)(31696002)(86362001)(6486002)(26005)(38100700002)(8676002)(8936002)(83380400001)(66556008)(41300700001)(4326008)(5660300002)(316002)(6636002)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0tQb1phTzYySkxXVDNSYXFEdjFXbDRFUkJxMitjTGxBc2ZXVU8ybDVBVGxS?=
 =?utf-8?B?bkJNM01OL3hON3NxbDEzc09ZWXY4TkgxbU5iY0xhRE9CMEhwdEJLeE04dVE2?=
 =?utf-8?B?aXpZSEVFdnlXMFg2eis2ZWljRXZMRGwzZHgranpvNW9iNmkvcDdkTHk1QVc3?=
 =?utf-8?B?MjF4ZGlEdk5TRzNMZUN0dEdkbWJFQXpkdUZHVXJTZDVVZnJBM3ZzMyszd3NK?=
 =?utf-8?B?M1NQOVVZT0Z4VERLM3JRTnZQS3pPN3ZrdzNXMXlETVpVcHZXZHBVTnRMdXh0?=
 =?utf-8?B?Q09lV1RuaThjc1p3eFVIdmhzVHZOUFBoWU5PemdSWkl2MXRwSHZIVTJ1TDBz?=
 =?utf-8?B?N3kzWFdiN2V1QXRzaHdXb3BUVjNpZHFaMndvdWdqcUhheVR1MnV3c014R20y?=
 =?utf-8?B?OGl2MEs5R0Q3WUdqbDZmOGxXT3dsaVhzZitabDQ0VERwcFExMW9zc3ZBZzNx?=
 =?utf-8?B?UHI2dHUzQWhkMERzbjVaQUhoY3dEaVNkcTZ4NzNPbDFuNkxlRGEwQ0FQS1dK?=
 =?utf-8?B?d1padkNLTmVGT0JQZnEvS2tmQ0lldHhOYnEreE9iYmRhSUI4TkcxaGpqNG90?=
 =?utf-8?B?cmMrdTFMOUpZNHQ5TFQvZk0vTytnWWpoOEd1Njl2MDkrbGFGS1Mzd3d6aFNW?=
 =?utf-8?B?Z0Q3ZDBCd1ZtZEwrSnI2T1pzYzJVZVQ0aUU0RzhmQ0xZMGY4aHoyNEQ4Z3g0?=
 =?utf-8?B?QzA0ZU5mMEk3Z2lxaVh3Y1VQUXR2MDJhWUtrWjNWSzBiSXZiMHl0c1p4Ui94?=
 =?utf-8?B?bFZNeWx5Qk5wWlRTVEZ0dmNraTJDdldRc3pPVU00M3RsU2paWFBhU2JLTkQ0?=
 =?utf-8?B?UWJnWXJQK1RiWjI5MGxNZVRLSHBDVzlDQzlJdC9DcnhZQ01FVUtTdmhpVUdm?=
 =?utf-8?B?bDNMR1JJU2Z0SElGb3E4Nkg0Q2J4TThHMGVhdmtGVDJVdzRtM28vNW0zMHRD?=
 =?utf-8?B?VFdlbTNTd0QrOTBjTEhMN3k5Z2Y1Yk94dkIrNklCaGZyV2tTVW1iTGxlNnJF?=
 =?utf-8?B?R3hXVGMrQ293d3Y1SExidldlYzhvcENGK3V5cDlENHJOMVJMQVJsbUd2M1Nt?=
 =?utf-8?B?dDBoNVhqWVZsNmtFSkRtb0FrSFNBdmcwZWZ0d2lrWXNrcy9XeVFocG92VHdZ?=
 =?utf-8?B?dm91Zkd1U1Y3VGt4QVBuU3FQN1dYVGF2TENhSXZXZC9Ibm1UTWkwUHU5NDh5?=
 =?utf-8?B?a2NGTS9IeWc3VmlKNGVWejVyVDhIcDhWd2RXK0lMMHA2dFZrdk93c29mTEZq?=
 =?utf-8?B?OElnaitWY0ErQld4RjdWM3MxRk0rWkJjQTRaVXVzUU4xa1FRdEtUaW9iQ2Nh?=
 =?utf-8?B?TzQrbmpzbEhlNUVYcTdlV3YzTE5ueTYzbW9HZVJuYTROVnYvYlloNFRRUnJ5?=
 =?utf-8?B?S3RhSFl4aGxFRmtSa1RydWlYaGZvSFR6eHJ5ajlvTW51cHNyUjV4b2FjalUr?=
 =?utf-8?B?UmtSOUtsL1M4Z1lWRTBNNGhyck4zYWRQeGhKKys2QlNPVEZJNFRDUDlvV3BE?=
 =?utf-8?B?dzRaL0pTRHFhWXB3VnJqaWNCOU1rdk5WQWh6VU82THJEb2hGeVY2aHczdk9v?=
 =?utf-8?B?RUVaR2MwMit1M0VxWUMvZ3paNHpONG1QU2FVNGczcDF3SXFpN0VYSWFuaWRk?=
 =?utf-8?B?M2VmZXZ2T1Zla3BsdjArdVJXMkdlZXNYTTVqZVlVbWRRZDN1MERxVnB4UkFB?=
 =?utf-8?B?aElpa3BDLy82ZC9kTWtlNENaSzRoNE41RDlOTnRNMjk4cXE2OExjTGthMkhZ?=
 =?utf-8?B?T1NOUHZmeEVHWTVFQVhFZjV4L1VrTWdESC9GWnF6SzBJVDFlcjRmN1R3R2l0?=
 =?utf-8?B?RWF2VnFxZ21EYkwrUTZPMS9EQ1BBYUY5Q2RtcVFyVVdtanVlRTZGc2JWaERT?=
 =?utf-8?B?MWtMa2RWTUhSQzJmWHdlc2R2eDlNTlhiMWV3ZmxnYitRNlhJOW5JczJrYk0v?=
 =?utf-8?B?QTlmZG5TNTgzZGtkT0xwb21maUVpaCtFWnZNNDY1QmZUdUJUaXJmdXJ5b1Yw?=
 =?utf-8?B?emtpZ2RFdTdLdzFiVEZOT3UvYlBXVnpKNWtpRGthYk1FdGE5U0FTTzkwTktD?=
 =?utf-8?B?ZlZIUmZVL2R6ZFdpWmZUL0F3c0FjSVZTMFdVMWpSMzhKMGducFc1amMxUDNy?=
 =?utf-8?B?TTFYSGt3NWNCN1AyTWV5WFFxR3N4dmtTS0dvcHlUK0g3OUtMOFhCd1dOMlZH?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VZ5lT9KYB7oAi8gD3GnbVQQgm3FtpsRwrECJczB6YAzG0yitFJijOiP/48UUa/3Wjf9YkKlyc+EddHvvFIyGk2stUNto0ogywuUrbRlWNskLMef8I3lS4XdYbsIUgS+IiGPqxAlqL6O1JLeelg2JBqlpHnWAEG4Ifw5wTsllelY4A+w8am6e1tHsihxFJaE2w5zJs4OJx+IoB512+2fbxEv8oBpJceA+qVRcIS109takMF5IwLsDueqWLJZxfIKo9rJE78AjLzA9snwe6jKIhHdT7+GgcavIUOWbKtpK4xqQ/2Vp3ROqMZgU8ascHuuDjN4Z6pqEHo/vj5Lr/GwKLqB4mXBu7DCvf71UFDuFgyVN0YSNl08VoWiLuD2enKhd8nssB4L2stvMMJDJxJBSzTL/82JXSexuKN1JTUocRf/hMK/wscoI9Onoam6zPgRcxGWdXSW7fIO6xQuTczFev50D2lnZ8Y4GuxqjTlt4EFA/ocRdNF682a//27wGHcdxrd7y7TKJSjDKuGc8yRPwoMzkWN0Vkel+84FG2QyvScmLJE3qZpE4jD6ipvRic1Dr/LkMnVjImvNX5SRh6rvOHfw1MgwWQ16cnV+VKXkGwnrgrPMvFArR/YYT2KeL4s9zY5nZOyVPNyyrmPAZXnK5QntJTT6vhKTOozqYNzXYhNkzgBJkzmVFH2y1paUc6xjfovRZNM+BZBuPtQOsC5K80og1ZMksbEHHuUHfBW4YjZs98vCFvzqiKPt3hSn1tIe+/2KniItMG4COMmcFfcBfWlWrQwtNJp8BrQlDecyaJuQJCJkt8LnZsKdX14F7dqvfzDS8jAiaRQHd+kVXXNjcwo73Cfu/LDR+TsiFYiCiFH3fc4mlp7RMXe30IEYHR1ZyYQqHYc/nNgmZjFX2hButxw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a798721d-a2df-4aa7-038b-08dbd6439b98
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2023 16:50:06.6303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pbbIlc1OFw/LSgUlZlcZvHEGHQhWMhEkWM4ioOBU8g41SSUziuEc3lsZiduQ8FIAdSJXo3oPeJ48oeNSBnwJ78bHeN/IQp101/byjAp5Bo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6589
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-26_15,2023-10-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310260146
X-Proofpoint-GUID: 5zVTFcZhhKP_dNKUKTiqXuqZduyz_jtI
X-Proofpoint-ORIG-GUID: 5zVTFcZhhKP_dNKUKTiqXuqZduyz_jtI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/23/23 4:28 AM, Hannes Reinecke wrote:
> Returning FAST_IO_FAIL from any of the SCSI EH functions is perfectly
> valid, and indicates that the request could not be executed due to
> the transport being busy.

I'm not sure if that's completely correct or maybe we have a different
view of what it means to be busy.

FC, iSCSI and SRP normally return it when the transport is marked as
offline/lost, so for normal IO we fail it upwards and userspace gets
an error.

What drivers use it as temp busy error code? Is it the lpfc one
or a snic one?

> But that is not an I/O error, and we should return -EAGAIN from
> scsi_ioctl_reset() to correctly inform userspace.
For the sg_reset example, if you tried to run sg_reset again it would
fail. When sg_reset tries to open the device the open function will
return failure in the open call because the device is in the
transport-offline state for FC/iSCSI/SRP.

If you are going to change the return value why not sync it with
what we return for normal IO and return BLK_STS_TRANSPORT/-ENOLINK?
