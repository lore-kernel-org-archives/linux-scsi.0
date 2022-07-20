Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAD2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 02:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236043AbiGTCbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 22:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240341AbiGTCb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 22:31:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7670F6D54C;
        Tue, 19 Jul 2022 19:31:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26K1U67q002381;
        Wed, 20 Jul 2022 02:31:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=7pSQTlR9hG/xSD4FpDqvGosaE+124UPlE0Pw1jn2Qzo=;
 b=kQ/BPs+MMtWc7cqBEXuxQc/tht1gEPviAS8Q3F9Q+su89S/DjYsl1HNd9ongcf8qFvdx
 KSEaj4KzbNsP9S7BhpYFccsyTHgF0s0NLRnuxHY8iHe/rD9WQgFuUUQeDRRfN9m27gSg
 EYUg+//biuA9j6v3bRMrpB+7PxZqdpFnD62tjHzTlL0w1XB+wVh7FZCqpLPyKFSsUdQC
 99446p+ZCh00MKF/fz0Konfmy3JkrIq7DCV/K3eDImF30FMAdEbMILjE0daHPI55eIKo
 wyLzPvBM7feXa0o5iHCtavshkXx99JvT0ybsCEn630b90exqIOAuouxfEzF6Ou9ECJhH Dw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbn7a821x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 02:31:21 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26K0YMC7010046;
        Wed, 20 Jul 2022 02:31:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1gh1a0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jul 2022 02:31:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeqNthVRkc9tq4bcj6KGUBjHmvtH3r0LZqjK+wQsZtkQDmsVIinqtO1iCZwyq6r6k4n3BvLhznCVNvVfAz3hIYO+5cBxsn1Qeh7G2nhKCe03MFIDvvVi29Vo7qxJstSktrP+Ozp3lDQuNyjpqV4Mx27XpWCZetKCazN7ouAAK5Mad4/o3hafts6h/axEpTaZLLL8ccL6JPRj8Sqq/EwjWEyaNCgQw33u0fMaiHTvzugSoBxTQkYHZFF0fmAOfOJYwNZjVC0/lZxeh+KGIlL4gGzLNmaXZM/bSqQ6s3Jqgb0cPDf5C1YqH05svMPjDB6osVV3JxElMffhAFWcZT9n2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7pSQTlR9hG/xSD4FpDqvGosaE+124UPlE0Pw1jn2Qzo=;
 b=DOnGRbQp7aDMTutzsMaflnr+ehrTvTIqvgMmOXVFmw50lI7f6y6fqfEPL+wQukBYoyq/odh+Wac+n0gjU7f8+r4TWhSyB0ZNmHbfp6D50Tb99oPYGnT/XWb5ZdYls0auKoCcqJIDKwgavwELmpvtKuMMLFMx0x2t43DTtLMpdaAygScUkzCFZR9GyZZIBJAKbu4eHDfXz/Vgbgj/jH6SetKyhAa/GUUPim/Tt9LuLGfqEqbS2faqDcNq+Of08JoYydqXPZ4XHuO2GNBgFVtPOMseLcZLgg2Iq/8g084rvdu3BXEatM5rSZpu/RuqBRatfw/kQd5vXiuSA8lhYngmPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7pSQTlR9hG/xSD4FpDqvGosaE+124UPlE0Pw1jn2Qzo=;
 b=DwTBHCeOtCe+iyHtUYzQpMjUzJJhO5HKscDRR7VSQsJ4rwfjgwk5epBYg50YDP04dJnfCDjHRdqEleA1nasp0h6KZELlVBYjxH2qZpcKHyB8u4hj+lIWSkXOQ/i4FTfntQQ64EwXgiqDVEQDlhdXeFwu4PzaSTHmG/mgMgW/YfU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR1001MB2313.namprd10.prod.outlook.com (2603:10b6:4:2c::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5438.20; Wed, 20 Jul 2022 02:31:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5438.025; Wed, 20 Jul 2022
 02:31:14 +0000
Message-ID: <9e7172c4-2f84-275f-1bc1-1ffe3fa7a363@oracle.com>
Date:   Tue, 19 Jul 2022 21:31:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH] target: iscsi: handle abort for WRITE_PENDING cmds
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org,
        Nick Couchman <nick.e.couchman@gmail.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220713204212.7850-1-d.bogdanov@yadro.com>
 <0fc89e77-197b-47e6-f661-5f7f18f6634f@oracle.com>
 <20220718084534.GA12544@yadro.com>
 <9e1c0853-a5f9-cba0-2f51-05ac773f1fa3@oracle.com>
 <20220719161403.GA27979@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220719161403.GA27979@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0269.namprd03.prod.outlook.com
 (2603:10b6:610:e5::34) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90f20975-c0f7-4772-8858-08da69f7eaba
X-MS-TrafficTypeDiagnostic: DM5PR1001MB2313:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5S8YgUrzw5m7GlWFD96VV7Gz4ChwOrDycxvUaM9zo1P02cb/r46qufH/ucisZSO7zMi+SAwnzUUhEx72rtG5/wBfxck9jMDE4HyQUADpqws0yW4MRQ936zUEayffD76Bw4TXBVxzQasJ2FHEmjUWzb3ZNmelsBxybOwV3R+PxVFpAFuUDTVULAFONLxuMEmq+szN5RGIgygYL6zb5o1RY1CD6BcPSJ7oUVKVD33huc+DHu7rb1VglDl6d3Btt+TKThRbqh0boliBsK5xEzaHcJx388lvUIsl0rDPtrCI0GtrqzvDQ6/t5mMVoP66xb9NEmog9QKeFaRJ/TzKsAYssviGbZYf1vAqKdf51GDqZccNCv7ln6nrRBFbkZSfMei/zC4S5NiK0hDDZyP7qTQEMSDOAohvQK3Nse1Zqd7IibkiZUIEJHlpoiVdL6OqfBwe9X0PwIaOUep2f9SrTXGjl07exenmqiRI9gkSF1niHMPU659G5y2STA2AzyxsZRv28m/IViXyHzanY3HVYIpQeqv6J3u6jWvbaKDtJ7c7f/MafBE/s4usFO+dIMkWejK3dzFXGNwvtw4xsYh2gBThxEu8xlAiYAXJWnGKPz/Y1i0L1egOE1VqlozNMJHFA8W6sF2gjz2HQ84EtLDesLc1yideSYPJI17fK06/Silyja0dzWFxpONY2Y3tAsFbonSOw7QTjyyzINwiMUOCbRLAnNziAaU5X/hGDB+TlEQgtTvPAHYcPgngbsp5vBvhvTwQJWChy7VPei3jaLpKGoYhwQhMPG0eihLqzAARsPkDrYS6dc9giGTUfz4HHCRmCmkGUNexUho135vUEkS+5EUYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(136003)(366004)(396003)(5660300002)(4326008)(6916009)(8936002)(2906002)(31686004)(66946007)(54906003)(8676002)(86362001)(316002)(36756003)(66476007)(66556008)(26005)(31696002)(186003)(478600001)(41300700001)(83380400001)(6486002)(38100700002)(53546011)(2616005)(6506007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDQxeG1KREFJUVRtMGtpam8raGJESG45NXduL1R4QkFYYVF6eSt2VFQyQ043?=
 =?utf-8?B?UUh6RlV1amV3RFBhRHNpTXlPNVNPdzAwWlNQM2hrUE9yRk96a1oxcHovN3dT?=
 =?utf-8?B?UEZlb0JJQ3pWRUQzOG1GczRtclRNRG8wbTlDb1krZFlzMmVHcWhuZElXS3dE?=
 =?utf-8?B?Zmw3YU4rOXhoWTNybVM0dHpvdkZsbmhQaUdEK25LT2lMUWUwZzg5QXlLTUNK?=
 =?utf-8?B?MVh4MjJKQ0p0V3NDVHF2N0QvNzYzdmU5aVpzcGtJcituU20yam9BOUZ5a3dH?=
 =?utf-8?B?YWJ1ZzRCSzN3YkRUL0VKZTdINVljNVYzWkNtOG9McFNjS2FlMVduVGNKOUNO?=
 =?utf-8?B?YktIdkVWMXdQU2YvRlpIaHE0aTJscVFlc0VaOHd6SGRELzJOcHJLYlRFQ3RC?=
 =?utf-8?B?eXdmTE9pMVByVXNFc0lVT1ZiZCs1OCtHa0xvZE5RT0xHamM4b2tHNE9hQnlV?=
 =?utf-8?B?UDZzU1JTUkp5QVQzajdoeXh5Q2dOM0w4emxaZXpvb2lHMkg5NlZPRU5aZ2ZN?=
 =?utf-8?B?U1dQM0p1ZTI3N0UydG5xVXc3ajg0WVN2TjF1ZTg2RXZuRGpJazBZclB1ckd3?=
 =?utf-8?B?TFNBQUV3azBlUytHV3hyNUp6NjRqLytJTkcyUGViSUpKN2dNaEo4UVZHM2Fi?=
 =?utf-8?B?OEZPYkFFaDVaS0pmaUN5aEdKS09mcjhFby9NS05OWENFQkw0d1lmSytheUJw?=
 =?utf-8?B?UUYxeFYwUXVpYlRIVXM4WFk3aHRJQ21tNlQ1UUx6OVVNbEQvbW1VRnBNRTdL?=
 =?utf-8?B?bG9wWW5vMEp2bldxK2F0K2VZT2VDVkQyaTVhYXd2RndyQUN5NEEydTZsY21x?=
 =?utf-8?B?UTY2UFFZekNJODdSZFBsYUZHUVZzV3k5RWNib09kcUNtQ2h5aTNTQitxM2Mz?=
 =?utf-8?B?Ui9kR09zL2dVZ1QrR1kwYUFERGN3QXYvVTJESmtrZUk0NHZDdHpCM2o3aTNs?=
 =?utf-8?B?a1JsdUVTd3NxeksvZW1ENjA4WUpqaURKWEtPTWpJeXFTSGpLb3pGSlBiNUVw?=
 =?utf-8?B?ZEhRd1VrL3k0akF3RE95OHM2eU8vVkljNUJpUXNIVWkwQmZMQ0lPcHdlVWNy?=
 =?utf-8?B?cHVFRzRsditRQTVYY2xham9hcnUxZDMzalZ0ZFcwSXZyWmhRdElEZXhoWnR6?=
 =?utf-8?B?eU1WUkhFVXVJdXN3MEorL1lKa0poWmFXMmxXdEswUkdMclpJeko5bXVLOTQv?=
 =?utf-8?B?VElHemVBTDZWL0RHTERRN2hVQ0pzRzc0aEdsbFdQQ2p4VnRsMkMydGdXTEtM?=
 =?utf-8?B?a0ppOHo5L0NQMjRDdGN2bitEOTRGaU1EeUNDVU4zTndEcDdOYjY1T0xybFl3?=
 =?utf-8?B?Zys3TkhDVmszKzFaS09CaW5HYWswbS8wRFlYSUVHU2F2MDVNNE1WcEg4NStQ?=
 =?utf-8?B?QjRpRThxRlR2SHdIUEhya0ZQRnVSc1F0b0s5WVdzZXV2V1BadlN3RzEyYVpV?=
 =?utf-8?B?bmRReXU2MHg1MFhvdm9MNUxFMkJ6TU5tZzRtV1RGVnYrdEhNeDZkR01EUGxh?=
 =?utf-8?B?bDZqYXZjSE9CNFZJcllzZENPaTV5TTVzOThqNWpCYy9IU1BCdVRhR0FMZVY0?=
 =?utf-8?B?K2NSRmtNeGVud3g1NUdhcHB5aGhJdFhzcEJjbEpobFBLanZzcVMwMnk1WmVw?=
 =?utf-8?B?ZHNNVjJrOTN5aFlESDE1YzJOTWgyd21WSjcvVGx3U1BIdU5DcEp5Yy94NGNz?=
 =?utf-8?B?UUt2Rng4NGM1WGFWb0EyRERDbnkrMFV5NzRYbG9FbE9VcW80aEhsc0JpYzMw?=
 =?utf-8?B?YnJscktLamg1MGwrYWNVNnRXVk11cHEwSWhvQzFrZGduTUYwcm9NVWhHV2NE?=
 =?utf-8?B?NHpZRGFlUWdUalg3Q0xrOEhPOFdFYzd2OS9GODhpdkVWYU43SzVLNXpkYzQ1?=
 =?utf-8?B?OWJEVEQvaTBERUNreTEyUENJNWtsaTEvSjRWZ0xiL1MzMVQ2WmJ3R1JWS2pz?=
 =?utf-8?B?WDRBNXB4Ymw1UGNGbkhaM0tBYzF4NGx5TkdpTk1ySmVMdTFmWDhEUmJGZnJS?=
 =?utf-8?B?aEorMWNDaUNMeVFNN1FGOHFqNjQ1a0lBakQ5bGVzWWlVTkR3akJNWU8zdXpT?=
 =?utf-8?B?Zk9SV1pNWlhieHZzaThTanpqbERibVI1QjlZWjg1bnl4ZFM0VXFFdXZhak1o?=
 =?utf-8?B?WXRRWE14ZHkzZHVVdW9tTGxZUUtMMDh0M2IvMnRNNUhiRDBJOW1IaVZlRHRu?=
 =?utf-8?B?SGc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90f20975-c0f7-4772-8858-08da69f7eaba
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 02:31:14.3840
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZWD7WFnBD/mwW4AhnVNVreC60ugmGwnie8DY2/vztt4D9JYk8P8XCzxXQvZMwQPqkv8cAFHvsYHz2DyjIUPX9juIDBgmihAfgUIALq7B1gc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1001MB2313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207200008
X-Proofpoint-ORIG-GUID: 2xC8rrVOgEngzLPjevH_0mS7mlxU8ruo
X-Proofpoint-GUID: 2xC8rrVOgEngzLPjevH_0mS7mlxU8ruo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/19/22 11:14 AM, Dmitry Bogdanov wrote:
> Hi Mike,
> On Mon, Jul 18, 2022 at 04:22:36PM -0500, Mike Christie wrote:
>>
>> On 7/18/22 3:45 AM, Dmitry Bogdanov wrote:
>>> Hi Mike,
>>>
>>> On Thu, Jul 14, 2022 at 11:44:25AM -0500, Mike Christie wrote:
>>>>
>>>> On 7/13/22 3:42 PM, Dmitry Bogdanov wrote:
>>>>> Sometimes an initiator does not send data for WRITE commands and tries
>>>>> to abort it. The abort hangs waiting for frontend driver completion.
>>>>> iSCSI driver waits for for data and that timeout eventually initiates
>>>>> connection reinstatment. The connection closing releases the commands in
>>>>> the connection, but those aborted commands still did not handle the
>>>>> abort and did not decrease a command ref counter. Because of that the
>>>>> connection reinstatement hangs indefinitely and prevents re-login for
>>>>> that initiator.
>>>>>
>>>>> This patch adds a handling in TCM of the abort for the WRITE_PENDING
>>>>> commands at connection closing moment to make it possible to release
>>>>> them.
>>>>>
>>>>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>>>> ---
>>>>>  drivers/target/iscsi/iscsi_target.c | 13 ++++++++++---
>>>>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>>>>> index e368f038ff5c..27eca5e72f52 100644
>>>>> --- a/drivers/target/iscsi/iscsi_target.c
>>>>> +++ b/drivers/target/iscsi/iscsi_target.c
>>>>> @@ -26,6 +26,7 @@
>>>>>  #include <target/target_core_base.h>
>>>>>  #include <target/target_core_fabric.h>
>>>>>
>>>>> +#include <target/target_core_backend.h>
>>>>>  #include <target/iscsi/iscsi_target_core.h>
>>>>>  #include "iscsi_target_parameters.h"
>>>>>  #include "iscsi_target_seq_pdu_list.h"
>>>>> @@ -4171,7 +4172,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>>>>>
>>>>>               if (se_cmd->se_tfo != NULL) {
>>>>>                       spin_lock_irq(&se_cmd->t_state_lock);
>>>>> -                     if (se_cmd->transport_state & CMD_T_ABORTED) {
>>>>> +                     if (se_cmd->t_state != TRANSPORT_WRITE_PENDING &&
>>>>> +                         se_cmd->transport_state & CMD_T_ABORTED) {
>>>>>                               /*
>>>>>                                * LIO's abort path owns the cleanup for this,
>>>>>                                * so put it back on the list and let
>>>>> @@ -4191,8 +4193,13 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>>>>>               list_del_init(&cmd->i_conn_node);
>>>>>
>>>>>               iscsit_increment_maxcmdsn(cmd, sess);
>>>>> -             iscsit_free_cmd(cmd, true);
>>>>> -
>>>>> +             if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING &&
>>>>> +                 cmd->se_cmd.transport_state & CMD_T_ABORTED) {
>>>>> +                     /* handle an abort in TCM */
>>>>> +                     target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
>>>>>
>>>>
>>>> Will we have an extra ref left on the se_cmd if TAS is used so the se_cmd
>>>> does not get freed?
>>>>
>>>> For TAS, it looks like we would do:
>>>>
>>>> - target_handle_abort -> queue_status. This would not do anything because
>>>> before calling iscsit_release_commands_from_conn we have killed the iscsi tx
>>>> thread.
>>>>
>>>> - target_handle_abort -> transport_cmd_check_stop_to_fabric -> check_stop_free ->
>>>> target_put_sess_cmd.
>>>>
>>>> iscsi creates the se_cmd with TARGET_SCF_ACK_KREF set so do we have one ref
>>>> left?
>>> Yes, you are right. TAS case is not covered by my patch. But that is
>>> actually another bug (that iSCSI does not complete responses in case of
>>> connection closed).
>>
>> What do you mean this is a bug already? I mean is there a leak or spec violation?
>>
>> Spec wise we don't need to send a response to the initiator when the connection
>> is closed for a single connection session and ERL=0. We just can't because the
>> connection is down. And the initiator knows it will not be getting a response
>> because the connection is gone and cleans up on it's side.
> Looks like it is a FC term :) "Completion" there is a confirmation that
> a response has been received by a peer and a driver can free its
> resources now. A failed completion due to network error (logout for
> instance) is a completion too.
> Under "iSCSI does not complete responses in case of connection closed"
> I meant that iscsi_target does nothing if tcm_core queues a
> response/status when iscsi connection is closed already. It does not
> "complete" the queued response by decrementing kref by
> target_put_sess_cmd like in normal case.
> 
> I reproduced that bug by simple test case:
> 1. Export scsi_debug (with 30s delay) device to Initiator on 2 paths
> 2. On initiator:
>   # make the first IO do some initial IO traffic on the disk to make the
>   # second dd to send just one READ_10 command.
>   dd if=/dev/sda iflag=direct of=/dev/null bs=512 count=1
>   # start 1 IO on the first path that will hang forever eventually
>   dd if=/dev/sda iflag=direct of=/dev/null bs=512 count=1 &
>   sleep 1
>   # LUN_RESET on the second path, to make TAS feature send a response
>   # for the command from the first path
>   sg_reset -d /dev/sdb &
> 3. On target:
>   # simulate local connection reinstatement (like on DataOut timeout)
>   echo 0 > /sys/kernel/config/target/iscsi/iqn/tpg0/enable
> 
> In that scenario the connection will be already closed at the moment of
> target_handle_abort => queue_status(), iscsi_target will not free that
> cmd at the connection closing because that command is CMD_T_ABORTED and
> tcm_core will endlessly wait for "completion" of the queued response.

I get what you mean. I can replicate it with just one path and one dd.

> 
> That is that another bug that is not addressed in my patch because it is
> really another bug.
> My patch fixes only unableness of relogin (due to aborted WRITE_PENDING
> commands) that was really catched by our customers. I believe that it
> make sense to have it in 5.20.

What do you think it will take to fix the TAS part of it? I mean how long?

I think at least we should add a comment to the code and/or git commit so
if it's going to take a while other sustaining type of people seeing the
leak and hang will not waste a lot of time debugging it thinking it was
a mistake in the patch.


> 
> For RecoveryLevel > 0, I even get a crash on cmd->conn dereference at

Ah ok, even more fun.
