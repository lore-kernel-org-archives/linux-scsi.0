Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC87EC19F2A
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 17:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbiHDRE1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 13:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiHDREZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 13:04:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CE45722D
        for <linux-scsi@vger.kernel.org>; Thu,  4 Aug 2022 10:04:23 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 274H3iGx013174;
        Thu, 4 Aug 2022 17:04:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=IJuyZWhnIqS5HX/eni11Ugk7SQuPF4tl1kDZjGcEwPY=;
 b=kPEikIQ+JNablLBVRLSK1UHT6Iiw4eB6QtZnfoMfWevLjjVEX2VUhWmCb3mDR5TBDdYq
 d7B3XYTbF2oxBnlPV1sP9TDNh0oclH5DwVp14Rs1AtdE6q/nMe1PFsmmhOYnfZWeptb2
 DHrjzUwbRoRrxLogCqQRy409qqmMsVEEsn+vmJd1xdrqlN89Hpg9BIzYcBTmxwnrmbhp
 mgM/XZXrqivHsBfIz7g+SCFmDd+vAMNSOK/M+SzTSnrJMqM3gH3ZSMWULgnjx/ada43p
 s/X2fJigUbJ4+V55B+SpVB3aqQpnmuzLJfJoXexULQGB1B4pop3wBKhxJxFKVXLTkXBN 5Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cd9c5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 17:04:14 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 274GAnk6003887;
        Thu, 4 Aug 2022 17:04:13 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu34gxfd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 17:04:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2TxV0I5yRiZpFxJiFn0PCH+FxVz78gtgkp/3UXbIKSdPuB7w7Z7flBHsKUqQTWVgMXvG/Df0B0QYkp5posKdcWX0BWQLMmWqmCphSOjNK13QDNsPFaCY6H6760Pk6OUyiLl3NHdN/sIXMaQeqevjssIhflzgH9VV+swyGQRTAO6cd7HgckVe7tjO/yY71BE4s6SLoxt3ZxsjET0H+I01JF4a77I1SjvQ1RYezOSY6OQCQE81CWnGwYj0UbqJaRyNtMVKSOxH/EqFnzE4PYcO8Hf5/tHwq0hbBiQ09dWRYp3S9tOEtBw1G4fZ9HbUkbOL+V1U10owSVQGVgRZM7OgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IJuyZWhnIqS5HX/eni11Ugk7SQuPF4tl1kDZjGcEwPY=;
 b=azd0jNiQTJIrFuYidDaDjtBz5HWfStJqmXv4/sjP24HhqFQ3PtDswghoMFzU7kTdtgL2/vFS2J6GTKgYP/RfjNKPzK7g5hH/ZgYg/1Pcriqg9N43tviWvE731QkLQhWhDs2yZ++wAThzVaNsL+vV6eKnHLiq19tobwxoYZRmbk5akZiRjp1lxVmzesPlgmiB7ga94vgslwkMv7il3D2641N66CRWIkiUZcF+dhnqccGNvkuJ8hoSJW7YWPNxeqn/3wWxnavqLSW14zP0suMhPMKdV0UkaXifnuGJR3eNRfQdsIDqqsmig48AdD6jImDZti7floEV7d9pbVfemn91dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJuyZWhnIqS5HX/eni11Ugk7SQuPF4tl1kDZjGcEwPY=;
 b=p6pgnscw0MYUWEaTPx4SvxVkpolAOoxkoO5p28HPHzoUhTZpiY+yJogYXf3TGe1LjU4HR6AJs7/cNQJ2SbrkOQ/Lr6da9VdNY0h0jc54DuCLMrW+fSxe6nV5neRYh/zQC4asw+oLxngzO09mccteEkj3pLu4Wd/BiOWQIGfOnv0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BY5PR10MB3875.namprd10.prod.outlook.com (2603:10b6:a03:1f9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 17:04:09 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 17:04:09 +0000
Message-ID: <1136e369-49b0-c3ef-340a-ab337f514fc5@oracle.com>
Date:   Thu, 4 Aug 2022 12:04:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH 00/10] scsi: Fix internal host code use
Content-Language: en-US
To:     Oliver Neukum <oneukum@suse.com>, jgross@suse.com,
        njavali@marvell.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, stefanha@redhat.com, manoj@linux.ibm.com,
        mrochs@linux.ibm.com, ukrishn@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220804034100.121125-1-michael.christie@oracle.com>
 <cb0b6190-558d-745a-9342-d7d3eadc680c@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <cb0b6190-558d-745a-9342-d7d3eadc680c@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0317.namprd03.prod.outlook.com
 (2603:10b6:610:118::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f908436-421d-486c-0be2-08da763b58d5
X-MS-TrafficTypeDiagnostic: BY5PR10MB3875:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leTI/L/8Jet3l+D6jqd7OIe0xH7JtXusuYSktRfcqO6d4/EUfxBTAhjLtwglaKD0oiBgCNs02JkWqo46nhTcFxR2drK79PBit3BV2uhSJmZwon9kMpYLe9m9ZXi0PXaQ5wtdT/sx9BdE7TOenYyIdODMYoxFYaWMrjte2U1lccfIC3LSMvoPoDj74XuXI7S7UK/i5HHX3ujLco6twM0TOmpEmck7vr8BAIWZTvXJLKkuhf6jrHVMN5SRR1/BO9xRg56OUkxY3Cl1yUJ0x9IV0oYGgFX5oGh2zm5zhauo81Uel6/uySzYFYaehWXXD5HeGTgbtIGVZNGGy/dxX/XNk/P7f371Fz7EQYOrvKlrCBI1MV4LH0hYYj+4jVXA6QyuHjnfkprPfEDeQTCLKNEQOfd3fr78rOX43SzYeNanw4vBclwIpW08fKn/vnWIEqHqiWe9gOjFlOx8kgNAVSgnwlx0MtN+bplUe3mYOpPjJnQWNm/APxb8rgg1+wx2F1dCgzu5Zbn5I3kOQeHxQQVOkAsCVZBg3Wgx/vppbTFSdB/JG6OQ49vuP/NFdkn/4SgKpC3sQWv1a5IDNrg+Q5ozcrdL8yyFKWRAat3K0DS1KvgUQbsiz8lxlzXXAsemSOxOyiAwv7Q8Q38l1nnrw2Qy0AdwXZo57K9BtA1F4dx6L0V8WTIw0Mr8a17jXgQfoEoUZniRT8H0mmzEAsYFsUQT+z1QiYIMPR5dKjNHMQyTPAYC1jNcR01ylC99eMH5XsDopIjyaEsbKLSOrOcg4wugIOdDtp5GmWU9svRLGWqvIqqllFvKeHB3xGMcddbYF+TCbGm+HqqMKA3eQxhDIjcb+7JrRcKJp+A8BbM9ClwWdeU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(366004)(396003)(376002)(136003)(346002)(316002)(6486002)(83380400001)(86362001)(921005)(31696002)(31686004)(2906002)(38100700002)(36756003)(7416002)(8936002)(66946007)(8676002)(66556008)(66476007)(186003)(53546011)(6506007)(26005)(2616005)(478600001)(6512007)(5660300002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T0lnZk1VNmdNNTBOeDJoblkzcEVjU2JybXArNjdoUGRHZmFrelFCcjlNbEpq?=
 =?utf-8?B?eE95R3plNHBGeElWZmZ5VWphdG9yV2NOelhnRkFzQWxscUVubUU4dkdHOUNC?=
 =?utf-8?B?d3cvMVFRWDgwSFpnSmRlTjRRelBrdUhGTnI5T2VHYXNQQ0IyUmpLVEYraEJw?=
 =?utf-8?B?ai9ZaWFiOVdGN3M2ajZzOGU5WDNoVVpVV0ZnNHNLTXVHajU2TjFXbnVvcXJz?=
 =?utf-8?B?QlpxL3FUVkk1dGRWcG1GaWpBbW9kN3pyVXFEWVBDVkw3clAvR0Q0UG9SQkFp?=
 =?utf-8?B?eHdjRjJGVmJ6ckIxTG9Cdm5JVUdoeUpRQmJOamp6QnlGZUhldG9hbnpIbEpX?=
 =?utf-8?B?dHluT3EzWTR4REVtLzYvVU9OMzFGaEJ3akROaktIY1orN2Z6a0gyT0Z2WlVR?=
 =?utf-8?B?NXRhalF1T3N2N3FEdlVsZWNVY0VQOEZSU3drMEJJU01mdkwvbFdpZE8reisw?=
 =?utf-8?B?UDh1WlNuQXV0ek8zWmFnOEEwdDJkcDJCZjA1Q2lQL1Y4MzI5VnY5alNTU3Ja?=
 =?utf-8?B?S0FGZmRtUG1LcVJ1WVVJQ1l0YWgxUVhWbFlmN1cvZUVETDlPcUZ6TGN5NzZz?=
 =?utf-8?B?VkloQkpaV1RhTHNTVnhXS2RJUVZZbVpKQ1lPanc0aEE4aG9wZ3NIZzRLZ2hC?=
 =?utf-8?B?Y005SXI5NjhGZVJKWTVxTitSTnlmTlVQKzYzRVFjOGpsWSt4aHpCM0tGMEUv?=
 =?utf-8?B?WXFvU2c2MjVZMW5VMWtlc1hXbGtrVG5IRVlKcHc3Rm8xUHdOQjRMOHFhczlF?=
 =?utf-8?B?Wmk4VGJ6TjJ4TUxQYytVMmFoS1BNOHR4WmlrdVYyZVIzSnVyK3RydTBxMmhH?=
 =?utf-8?B?RjNnZUQyWGZ2RGhiOUNjazFvQnNRVTV6dGYwMmV5VGpTQ0xUc2xjeVI1SW1a?=
 =?utf-8?B?RVRHaHVGdkRlLzR1WUxqWkllb2xua2ZVc3g1MHAzQzVhck5TbkN0MmFseUhJ?=
 =?utf-8?B?Z3VHZ1E4YW0ydkhveWFjWUg1QlhlM1llNVEwVWRaYzJsU0UvRjRWS1hlOUo5?=
 =?utf-8?B?dGZRZERyZEFaOHhmMC9Wc2h6cVlhZWhEK1FhenJHN2ZnVzdMU2w3ZWVxRmRq?=
 =?utf-8?B?cWQ3WUIycU0yWVM5OXB4ZWVuOEFjMGJLbVQ1eTcwclpoRlpqdTN3aDFMNHAx?=
 =?utf-8?B?V1Bpbkl0a3ZKL0Zid0xXRjYyaGJaSVhCTWdSM1RFYmwrSUtoaDcxSHR3NjNF?=
 =?utf-8?B?STdzS3l3bGdmVk5obEFaMGxHdGxuQytkQStrWmd4THpkZmVFcnJmN09qbjdv?=
 =?utf-8?B?c1VmTWVmQXFyVlVYbHpMYTJCU3pQR21YTDk0T3FJT2pKU3ZFdURuYUpGdDgy?=
 =?utf-8?B?WnNFMVlqajZ0WWNCbjFhVGMrSDJUYmh4RFA4dXNZTmI5L2V1cHpuVkI0dTBQ?=
 =?utf-8?B?TDBWQjJhRTlKU3NCME5KU2pCRC81TjJVS0RTUjgzNHB1RkVjOE0xb3creitD?=
 =?utf-8?B?TFJpUUlUYjVPM2hZZDBqNmwyUjBKTDVuY3dRNWQ1VEpoSGtOMzNzblphbWtj?=
 =?utf-8?B?OUJsN2MrTEV5Z3dtN2pZNEFhN1F4M3ZxbWhxenRGLzRxWkJUaE1OSkFDaHJk?=
 =?utf-8?B?UTN3RWprVFNXWUlXYWZWZk5xQTVkZDJTaS9rZS92c0NJdUhXSHprSUlWYmJB?=
 =?utf-8?B?ZTNQeXZ5YXBVUVVBWjNRUnZCbkxjZUFKTm9KK2cvOWxqVVMwaUZlSjkvS1RW?=
 =?utf-8?B?KzRaT0MxbVMvQUF1OVdOWmdlcjgwaDhaMTYrN3lQcmxuZzB0UVo1VzFtNEk1?=
 =?utf-8?B?TW8xTW45WlQ0NlVVbU5HYStXbmIxVlVUYXJCdlM4eXM3MzdDS3I4ZFVHU2M2?=
 =?utf-8?B?TTQ2MXNUMDlNTFFIZk14dWxkcmVDb2s5aXpOcGdGKytFM0V3OGtBajRqYU1Y?=
 =?utf-8?B?Wmw5cEQ4ZjgxdnhBZW0vQWJMT3BXMC9kdzhHa3VkV0VBckYveGQ0UkRLa0tU?=
 =?utf-8?B?TzJGT284bmU4dFRFR3Q2OWhiT3dPdnY0d3lvSElJTUF4eVIzd1dnMkRzSUlH?=
 =?utf-8?B?di96Mk9JTnBjSmtUdytJdXBFYzdZQ2RtaGdPajY3V0M4dFlpRG5zYkZvazE0?=
 =?utf-8?B?RnkwbW1sZW5rQVdBa0pSZ0g2VHc3anRvQVZqazBtdkJLUDhFRllNZGZvMmVS?=
 =?utf-8?B?cS9mRmI5Z2kyYmYwaXd6NXJUa0gzZ1dnQTExS1pSNlhhL09RSmM2ZlpmZG9Y?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f908436-421d-486c-0be2-08da763b58d5
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 17:04:09.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+3XXi1VWfSZR2J/vFaiwAYMndMWTPvEH5ofyckm0dfwMK2kjM+qneJQO9cCGbbPDIGALhg9Qw528DSsfgh1pd+hXbv6JHZSPibk7k3MtY8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3875
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_03,2022-08-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208040074
X-Proofpoint-GUID: lxYRWH6xix11EKmSyDdsLeD9og6nNSXF
X-Proofpoint-ORIG-GUID: lxYRWH6xix11EKmSyDdsLeD9og6nNSXF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/4/22 1:55 AM, Oliver Neukum wrote:
> 
> 
> On 04.08.22 05:40, Mike Christie wrote:
>> The following patches made over Martin's 5.20 staging branch fix an issue
>> where we probably intended the host codes:
>>
>> DID_TARGET_FAILURE
>> DID_NEXUS_FAILURE
>> DID_ALLOC_FAILURE
>> DID_MEDIUM_ERROR
>>
>> to be internal to scsi-ml, but at some point drivers started using them
>> and the driver writers never updated scsi-ml.
> 
> Hi,
> 
> this approach drops useful information, though. If a device
> reports such specific an error condition, why not use that
> information

Is there a specific patch/case/code you are concerned?

I think in most cases the drivers were not using the correct
error code or they were stretching in trying to find a code
already.

The only ones that I thought were questionable were:

1. storvsc_drv: Used DID_TARGET_FAILURE for a local allocation
failure when they wanted to handle lun removal/scanning from a
worker thread.

I don't think DID_TARGET_FAILURE is right here. The driver wants
to just not retry this command. It's not really a perm target
failure like DID_TARGET_FAILURE is documented as. The failure
is just that the driver can't allocate some mem to perform lun
management.

I think either:

1. When we hit that failure path that we want to keep the 
DID_NO_CONNECT/DID_REQUEUE and not overwrite them.

Or

2. I used DID_BAD_TARGET to try and keep the spirit of their
DID_TARGET_FAILURE use where we couldn't handle an operation on
it's behalf. So the target itself is not bad but our processing
for it was so I thought it was close enough.

Note that I think the root issue is that the driver should
not be handling UAs and doing LUN scanning/removal and should
have added code to scsi-ml so it can be handled for everyone.
So really that code should not exist but that is a larger
change. I didn't want to add a new error code because of this.

2. uas: Used DID_TARGET_FAILURE when a TMF was not supported.
Again I don't think that code was right because it's not
a perm target failure. It is something that we don't want to
retry on another path but I don't think that comes up for
this driver ever.

I think DID_BAD_TARGET is ok'ish for this one. It's not a bad
target, but the target doesn't support what we needed and
DID_BAD_TARGET still conveys what we wanted and gives us the
same behavior.

3. cxlflash: DID_ALLOC_FAILURE was wrong in this case because
they wanted a retryable error. DID_ALLOC_FAILURE was for when
we are doing provisioning and couldn't allocate space on the
device, and is not retrable.

DID_ERROR gives them the behavior they want. It does lose info
but that's just how drivers ask scsi-ml to retry errors we don't
have codes for. We could add a new code but I don't think it
was worth it since we don't do that for every other driver and
their retryable errors. If there are drivers that have the same
issue then I'm for adding a new code.



