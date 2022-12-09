Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F943C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 10:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbiLIKVI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 05:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiLIKVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 05:21:07 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF5760E96
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 02:21:05 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B97nRtb017106;
        Fri, 9 Dec 2022 10:20:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=lL2sVa2/l99x7zhzd8kneJ7S65OH9BicOZhWQjDTzwA=;
 b=vyGHI8GNM0/1+zO8wX2S5hW+BODtcvWeybYm5EInwaDZdP8qGkhwmFjFuuG6g7HWag6y
 db/ZTJLr4qf2sp2dU+tlKnb2uREuaRZcAzWsinAn+RUz6pGRcGOLHucJ5gzPqV/Lozh5
 J7BcQZY+DxVjFfHQTemO23nRAUnl4ssjvk9KcspA6F6VJ6TT8v7akk93tQn1O/kfTDE2
 jb26tydlpDAinDTFd2eWfez0e2gm84/9NK7l+MjGB3UWRy3X7/8Q4wY04Z6kgtxG+9Fk
 LeC0Nmlk1lRd2/YjoQvnAcXYJs0S6Hcfjb2XXwy5GOkOLlkBjJw/bExCNsiIJDrmjpnc ug== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mawj6ux6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:20:58 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B98N74d008361;
        Fri, 9 Dec 2022 10:20:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa627k85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 10:20:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiuFKfI2foeJn4MzpXiurrpZV/DWeoXe2wCBWVSdE2NeR6JbzLLWr7MzMX3zgLDG5qlxKVzUwzz6/RYpA036f7RZ4heANqiWEkgltYMPs7J4qklP1C6gm173Z/8ra5DcqgM7REMaS4xMZwv+ADlmxDrSGN2YxuoLtOtqrnOL7Wb+n8IhW0RqKwJ/V/lSW52aRl/6BvWasup72LXMIKaPvuAxciRIVUheJgcBXIZ044f53pu6S914BuyVlaGBnWQgJekONIYyAM0AHDJjWC6TZvvlEubgd5mwM2UBmj28DIUL7fKBW5xij0l3UOJHTNxkAxgAvClmStCs67X7hDmETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lL2sVa2/l99x7zhzd8kneJ7S65OH9BicOZhWQjDTzwA=;
 b=VbC09sJq22sae/F9HkJI0HqA6KwmanZq7V1tl0TUVhM6YGEH+3oY2TLFyUpKZTPNzSJnWRPs8IOeFL855yxU5sVvikryo44efktv1M8wRYNFb+s+/WGuvZL0xy5oMB2Vra6Bu1zvqYayr3IqVhDNbz39JYX5Fnj4tabQqbKD4+XDQNymwyTnksE3sOYs836JDNly+Mr8HzUAfY5xtfr5rJ1rgnr02bbVGyTYLAgJoa2nOcH1kMATAHV4cpeQCk+sp+QbHGWVv+mEWMRcSATLQNXuW+2b1Zr+EBaOj6w37MPrknTdF4+r7V7xGPH12/fIgURpv/PnVrOYJHoHqfbVeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lL2sVa2/l99x7zhzd8kneJ7S65OH9BicOZhWQjDTzwA=;
 b=cDiBFfQj6fR83lgD4JnI50Xz3HMPs6COjrhEDh5JoMZYYNlRf+kSU6tZy9HdEwf0M9k+VQsIvAYjUC2hBD3x6u79AAOWAV4rNClROh+CYRgQW2JayzwDSU9eKrra2R2FnsD30wNU6Z0otJcTnDn/RyRtwtfQ5TNABZrHaJcSHLM=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6116.namprd10.prod.outlook.com (2603:10b6:208:3bb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.18; Fri, 9 Dec
 2022 10:20:56 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 10:20:56 +0000
Message-ID: <0875e1f9-eac5-b358-5787-346e99e4ccd6@oracle.com>
Date:   Fri, 9 Dec 2022 10:20:51 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 11/15] scsi: sr: Convert to scsi_execute_args/cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-12-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221209061325.705999-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0237.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::20) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6116:EE_
X-MS-Office365-Filtering-Correlation-Id: 107cea9c-f202-4b50-a669-08dad9cf0f22
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmlXAgo+jHDS1PF0MGyr/dFTXDXxKwO3hg+5j51jIkSoLa7nyuWyucMfdhDzm4Mhp9BFyOp0Syeh3NsjpiQOHMy9/zHN5SOIxI8TIFjH8xRk6ntaEzjnoYpwqPZdQTfQ2JAY0FZDZJKRC9HQMjEnLMn1a1kuMsJr/yllGlpLb47pS/qHoxdVTa99sfkgCWUD6fg8zN0+zJZ4Sx5svbSeHxw0xnxxFk1F7KqqYvHElb/aEG4vzOHBHPGDPOfbtcD6o8NfB7FJRzNH18dDkpheudnDLR4+SmBLWJgfwldSs99rQcjYWk2Qks5wrS0mwK4zBbmKesnvtcviUFROLP3s4Suh5CQOKmLS+Mut3EzXwEcpGL0/JQvppjvUveAMAQDAk4qANLtXmZ86Oabz9mFgX8F8O+0kJ4WO6FenI3vFrOOAVk/1x9whWUYP81yJPc7iFKTsZDzoRkQpumHJyns+mCT8h1zmzMUsWVnP3h4VoK+I4tnFrwwGLAs+bUxIinBCKM9RVGt6V9ya3vzFWLI2ycM6gXWtUAKGSttPjgKn7iLSYIj+0ds6ch2AS5oeXbLRbmVIs2rMu1FDyQk2itrqqu8XWjZWwwAOE+zXGOJxXftg/nHBOEzUibN0r5xiOSvo6q2cYGpsl90RQgAtGHtDowLubgUeYq6TWJ8aLr44zHXMa02DysB+OqLVvEXXT4NY7qutg0ovmKEoFMt2jhqsbkC+kh6krBfERwZ2HmnJGJQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(346002)(136003)(396003)(376002)(451199015)(31686004)(478600001)(6666004)(4744005)(6486002)(36916002)(5660300002)(6512007)(186003)(38100700002)(6506007)(83380400001)(8936002)(26005)(2906002)(86362001)(31696002)(53546011)(8676002)(316002)(41300700001)(36756003)(66476007)(2616005)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzEvNW5oUmNUcVFqTUFtaVNzS3diZWpweVY2dDl2WjNrV000TkRWL3VKd3JG?=
 =?utf-8?B?dWhSRmJHTlFFeWxpbytpQ2Q3VkNTa0gvZzVFaGZEUHczbVRFRnRLSjR0TnE1?=
 =?utf-8?B?R1lRWVhUck5ORlJVT1RHZXl0YnYzU2hBcXFiZDJYNndLbUIxWDhIaEorWWpE?=
 =?utf-8?B?ZEFXbUVLbHZaYlZJeUZ0TitLUGlRWlBCS3BwcmFWeXV3R0pJcHN0WmxVanJV?=
 =?utf-8?B?KzQ1WjVLa3Bkbm9mSmJVMHkrbE9Yc1BqeEY4NDBzRU5ZU3RxeVJ6VUpKTzJX?=
 =?utf-8?B?MWVTZGtJYkpFUWdSUmphb0czTVNDR29ScC9qMkZwanZ1UFIxdnBBcGhQRlFD?=
 =?utf-8?B?SHVqaTVCcXlwNHZJaFc0TFoxbGJYZTRzMUtEUnpkSWVwTmRrTHNQZmcvWVIr?=
 =?utf-8?B?VHpjSFJ6ejI3d2VzNjFxODd5VzdzaDlpcU5VWEpyTGpMMTlOdHFSVktzY1la?=
 =?utf-8?B?YW9iNG81Zkt5RnhLOTZsMHVhSEJ4aWRTWVpGZ2x2ME5xZVk4VGsxa1ZXMTFE?=
 =?utf-8?B?VmdqYmNVdGl5KzNRcGlGVWU2aXM0QllsekEyRXJ5OEUxRTNzdTZOZ0VSaStW?=
 =?utf-8?B?OGczbHN5RHVWT0IzcHdGaDI0VXprOUpXM3lGUnFNTUZFMkdxWVFLZjBDVm5y?=
 =?utf-8?B?ajFOd2tEcUdoZmdBeFMrbEVqMXNxb1hsZzRla01mQWw5WkhHSmw4VThNaDg5?=
 =?utf-8?B?bWNSL1VIK1F3NDdBY0RORkFSZW5lZ0xGc3lmeFNNSzRjZjJGWTJSQnlReTRM?=
 =?utf-8?B?U1I4a0M2WE1FWWZWTVB4SnVRY1RoWXdGS2hLK1pqOEltUnFiVzltVy9lVlQw?=
 =?utf-8?B?eEV4bHJpaGFQY09DYi9Xdnpnb0NTR1lkMVNtcG1XSHNaYUNjbTZCbmt4TWV0?=
 =?utf-8?B?clpYbjBBMytqUjJYQktFY3YwQkN5bktVWm9DMGdINTBtbHREK3RNb2lPdmhm?=
 =?utf-8?B?SGtoRTFxMkVaUC9zTHcxTEdzeUdTTFdVZ2JLUUtIcUlVdzFrSVQxSkFmK3hK?=
 =?utf-8?B?YnlPK1lKTGhEWTFoTlp0MVIxc2FsK2dub01vTzNvOHl6WjdlUVJYVDFtYnBV?=
 =?utf-8?B?eEdVaEErcnlqQlNGWlpGLytFZ1VteE9DenltaUE3VHlNalJNdHl4Yzh0REZp?=
 =?utf-8?B?TjFmdzNzRHlsVkx1MmF3K3MyUHlFeEhaT1dRZ3dON3d1dGVSa29tVy93MjZL?=
 =?utf-8?B?K1I3Tm9rY1hMZDZIS2xteVlHNjBWc1dwTFlBLyt1dFhnRk9YZmJRZkFycVE5?=
 =?utf-8?B?bjlxdERBeStpUFYzOHBWMS9HTHE0RHltRlYxYWdkZTBNRndTR0VScGszeDZ6?=
 =?utf-8?B?K0FzK3N1YjlhY3hhUTVGbGRCQXJjSWp4QkhsVyt5eXZOMWFvdGJpN2pmaE9y?=
 =?utf-8?B?ckxGUEFITk1rL0NaMGppaytGa3VCZ0JaeGloWHZ1bC9yREpubHFuWTZKY0pl?=
 =?utf-8?B?YmNFRDkwTmFKQWcwVkxrMnBFR2lLWTJzbzhlWUVUanRiMHQvUjhLektPb041?=
 =?utf-8?B?QnF3cCtBcCs5S0I2bXdTT05mVzQ5aWpPVHQ1b2o0SktaSkpRL1ZnZ2h1blcy?=
 =?utf-8?B?N1diQWN3Sy9ieHEwUkFiZE5kWUFwcEZ4NEQwWkVNNjdkd3BVR1Rucmg0YXZO?=
 =?utf-8?B?MTJzeitTVUVyS3VnTndYaUpwNXgzbEZTcGliZ1NmR0wrcW5MY2I1QWhoTGVu?=
 =?utf-8?B?QnN3ZEtkODNscFR1aGxBSm10WTBONDFGaXJhb3lwaW1CMTNLRVdDTlpjY1RV?=
 =?utf-8?B?WkJPL1RGYS9wVlZEd20rM1FHb0NPVDgvejBZNFdCRFQ0VjlnQ3lYZVlOS0lr?=
 =?utf-8?B?NmNHV2hqWkkwUXVJZnhlKzdyV21EOC9vaVVwbDU2M3JBNndPSTc3WU5ITjFF?=
 =?utf-8?B?ekZRVG9HL2x4WHRGNVRaMnNBZVMyM2M2ZlhJNTIwTENBRjZOVnJVdkIvYk5U?=
 =?utf-8?B?bEx3dmVyZUhGWDNVQjlWaUR3VnpWbDBCZWt4NmhpWW45M1RkdDlqSjJHUzlt?=
 =?utf-8?B?YjZnb2R0T2VjdVRMc21DaEJSY1RSTkd1T0lrak5jNWs5cDlnUmd1dUhLRFRh?=
 =?utf-8?B?Z0U0UmdoVVhPT1ZvMDUrWlhvTzMxVHVJL0NnaUtJUDlzT2ZCNEprbnFHTW5M?=
 =?utf-8?B?OG5yYkgvUjF4Z28yZ2dkMXBmeGJ2eGwvOEZXODdScEx3WTVrclhQMmVOZUhG?=
 =?utf-8?B?YWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 107cea9c-f202-4b50-a669-08dad9cf0f22
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 10:20:56.4701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AemrqkUCjA5NVDZu6RSlizf/rQmShwt8LCOcWW7/QKUGFcitIt8rhzbHTsyKIcJYRMpFlSV6pwDkbr8JbD63RQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6116
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_04,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090066
X-Proofpoint-GUID: PcXrL3eVc6e-0CUlVBiYPSItUbyzkpd1
X-Proofpoint-ORIG-GUID: PcXrL3eVc6e-0CUlVBiYPSItUbyzkpd1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/12/2022 06:13, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert sr to scsi_execute_args/cmd.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

FWIW:

Reviewed-by: John Garry <john.g.garry@oracle.com>

BTW, I think that the earlier nitpick about assigning exec_args.sshdr 
applies here as well

