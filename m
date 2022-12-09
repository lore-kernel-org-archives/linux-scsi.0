Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6225C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 18:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbiLISiV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 13:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiLISiU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 13:38:20 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCF411A29
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 10:38:18 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9Hwgh0004040;
        Fri, 9 Dec 2022 18:38:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kfvyh99ICjeT0irllae14fMywrkSllOssfk7JGRzzRo=;
 b=LD5kVd9Alx/ZOEfEfc6t4yDxPidPcOqktO0uJsDgNAnmZVx8fwlez4D2MRQezMQx66oF
 GCng2pq6MaWp8tkr4tCw7Rvz1SZWBgy0fVg4SnkOiPGJAe8d0be+BdYmsu9NRICdylp3
 j02lT+ozld2/gap2NbszypVkNBL7l/NA5jJAcr4ZEFQceEt/afV/XhEDLS+3+niDz6o5
 XtHsqlfcfA+YiR+THGBlaatywGGa5mrdcNfc2w2Yt277IpxVUnD6asXIHinOen1rR0wr
 5tA5x5+D2GOPSCRp3iftcFgjJnwBRlQ/Nc+b65kAD57h6Tml9ylHLPXMkqqFNJdAxqf+ aA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3maujknnk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 18:38:07 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9ICQ2Y001745;
        Fri, 9 Dec 2022 18:38:06 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3maa6d67cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 18:38:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cj7VsycM1g8WD60cr630uxqvaGDKz6+v9nlQl7F2IJaEYvNyHEvVNxAzE6tr819eJMD1PilpR5VAx5jTkRVyvvosAsrOF8sl6OYwudCRyWFm5RIWiN9A6QF5J5ullZg8FopIZ5M2W3+ND231Zlstjplhb4DIubeyF1nEX3IUfnjMyWjs/oF8dXyz7wKJ90zrSkQdOZLOri/z1zZyQHwBzPn+3uJ99uMwixsIpjysgsMgm3B33LvbXzmMmLNq2xASoK7sgER/ivJ+j/Hb/V6hHnzliKDUIOHSVC5ywWlyRFgMGLUTsTbR+wfnz/oxLUBeDsy3jDdSH+DVeCyBsfJxhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfvyh99ICjeT0irllae14fMywrkSllOssfk7JGRzzRo=;
 b=NpUpDwKPHqJ/cXIkjUh3R4B6iCLtSpbgDdjJk89bHBT6szcgiagI8UATPEoHNDtxxWMB5uUaFBM5R3RBfYxNiW3EiKMhhlmw6McsrYoeXPBVbR1d90j0gG7kVbHgxmZ9WsCAt3LlOHjN8xR6YAdnj1SBOCN8swGn3i6V8QbsXqFr6rPnZ5pEnQVYXH6flPzXkTFAzfmiCUw2Zn5+O06UUQEEYXjQKOji7RBdMqG8W4sgZgqDHlrqz9V9n6iKIZxwTkOu6MR9vLJBh0Yt62pu5zqva0Ym7zaXNHsknXIV4lmTV4IiKcRPxAbFDrqUHLnGh5uNAMw+mCAfFfqBBcs0Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfvyh99ICjeT0irllae14fMywrkSllOssfk7JGRzzRo=;
 b=Vwiw7/kqT53a5ou4/wTAj+2Tw6dlbjhBJUy7iU+YVE6MsSfje6XSHCoNRjn85G5PIAPWeQ7liSapXtZ+59vlx3neuDKBuXDg3BWmxQkYY4dt/InDUJzPQLq+1CHeqxCo2nO5q/XZX6deFsCi/G1rRG83+Xfdj8sr5w+PeiqJms0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO6PR10MB5393.namprd10.prod.outlook.com (2603:10b6:5:35e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.18; Fri, 9 Dec 2022 18:37:57 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 18:37:57 +0000
Message-ID: <daebe4f3-fe84-1766-ddf5-53dbc9f47c5b@oracle.com>
Date:   Fri, 9 Dec 2022 12:37:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
 <0e69ddee-4967-ee07-b959-91d7de7b212e@oracle.com>
 <07f92000-5be9-2168-8e53-55aa706fc276@oracle.com>
In-Reply-To: <07f92000-5be9-2168-8e53-55aa706fc276@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:610:b1::11) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CO6PR10MB5393:EE_
X-MS-Office365-Filtering-Correlation-Id: ff3d3d62-d8f2-48c7-46fb-08dada147d8f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g6GnJtlPAyM6P1j1AaX4hhO/5jxS7+W4VgwU/s3T0BxdzjXJj+ijGSkBNfDOwwELSg5r+LkE+zOH0v76XuWimov6XSzmINvYiAvLda8bUp2BHzHwBkVeYETVCJKxGvieLtINPmUJTi1+Kaz6QBatrYblLIDLZmO4+OWzFqe4Z42cW8RipuYZ+Uu542Cp55ajd/qLFhqFQCVEEIixsTShHxi/rn6cwtmv7HJTBo+zubjob5IMF8+GJ8/G5Yck2TpFcsh3iMl9GIU4HTyecrjGylrYfub6lvqd95dRAcY1LwbbAjmQS+Zq/QaDlbxSpEv/PCCrZX1gnXCuCeNYOjf/D0JN+j3H08rschdFsEfqzuSDie6mBRioU/OiUmV4UxZI3pNBcahyFzCQDCZToEKY7/GyRUxFQQG1v7m+mtg0ww0UOM0B3vStPKKQ3n3+/V/OPVeV//rj8u+nMqHgQCmbPh6WR1UP7vOX32goupxcT2knU3g0NV8kEeBLfREvfl5vx+2/JZ0zn5XMEwx7TDKPSiBOBDhdZEnl7Lz6dPP5HL3YTTlVZYKOT8ZmInypsm2b7pd6x+tOYNr7ccdPlbL2EaEh5qMhxgflAc0Wi9qDRx0ldsP5Zel7lhVtgwd1otwzKoR0Ckg3wvsHUO/HufHkZqhz3s1vqtOdPXyUoAgcjUv3Noh+U/Fb9RCWLKM/QuM4uEoPK36AQgcejEr94n2CTG3wBEV9MM1V2DOtHnAs2kE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(376002)(39860400002)(346002)(136003)(451199015)(66556008)(66946007)(66476007)(8936002)(8676002)(36756003)(41300700001)(6512007)(478600001)(186003)(26005)(2616005)(6486002)(6506007)(53546011)(38100700002)(31696002)(316002)(86362001)(2906002)(31686004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHZrelNxeXg3KzNqakorZlZTSmlvN1A0VytGTkxCbFZQSTE0UVpJOUNjTkdW?=
 =?utf-8?B?amIzWFhHcm9DOHVmVTFpU09mZXRRYnlIaTI5amYrR3dzcVlKR3JUMy96c1JD?=
 =?utf-8?B?eU1xaW5RT015QzVNa2JGb2Q5d2x1MitVa3hSQ3V2bjFhRXpKN3dlcnBKeGRV?=
 =?utf-8?B?VGhQYVB3ZlR0bG40bFk5dWpIZlZUS25lS0x0SVBFUVJqT3pWVExVL1FYQTF4?=
 =?utf-8?B?dUpYRXdFbjRjd3pLYmkwTERrS0NUZGNybndYVlNwSFJsRG1URUVmOE9aL2pn?=
 =?utf-8?B?b2d3L3c2aVAzNjdKYnZYLyt4UEpOK1ZTcG5WWm1Dbkd0cWRYMWFxbWR1L01N?=
 =?utf-8?B?bnpySlRiNGoyazRrb2FYTEhTdEJnRXVXblFvMDJzVGJXaXhLSWdHZEFTZkhR?=
 =?utf-8?B?d1FPNnpSRUdNbE81VzRXTGtzUWpFK2Jrek5wRUVyNlZQb1V1ZldSelNOQTRC?=
 =?utf-8?B?eEgxRnJNdEtzUW5GYkRFcEdvRVA2TFBtZFFERisxVUtPekVLZDhWWGZwZUZP?=
 =?utf-8?B?T01hVWZUNWl6dHB2LzBwdkJuQkI0S3BUaDhCSlB4cnVUbVpkMThuaVlTL1Uz?=
 =?utf-8?B?UFlIdXZZSkdRQUdtQ3BLZUZBblRpdmZhQlZWZlNXV0tjM0pyZE9lYi9MK2Q2?=
 =?utf-8?B?WVdGUW9PRTdXK3BiR3RJZlFpOXJhVXZ5eUpLcUdTbEdLWVl3WlRLTGtiZ25Q?=
 =?utf-8?B?RkdFUjlOQ2tSMVNJSkN6Z0ZYcXRMRWtZQU9kM21pR2N1T3R2N2RhNFVRcVBM?=
 =?utf-8?B?QWdPSU5lQUY1Sk8wbUtZalVPNkJSamxDaU9DcG5nVWdpem1INkxFUGUxeVQ3?=
 =?utf-8?B?dE5jWFE2Q3R4bnVVRzBvMi9nZ3NWSldtSk9IVlBGTDRab3Q2Z2UvU21JWHZj?=
 =?utf-8?B?VDNScGF0MHlwNnoyVmthVXFJU0lKYktsS0NlWWxYQlVEY0djeTZZM0pXRkQx?=
 =?utf-8?B?OXBmbm5VRlhaOGF1Y3hRc0IrVGZxSERpeU1wYkJta0dJcll0TFFUK0FJUGFY?=
 =?utf-8?B?dk9nVjlheWM3UW95VDBocnF6Y01VZklxbEZvaWRsM1IwQmJwOXRIQlRJS0h2?=
 =?utf-8?B?dUxCaHBxcUZKU3laTCtsVDF1dUtXNG84T3ZhWmxXSEZsZ3Fhb1hUdXJzSmdm?=
 =?utf-8?B?TWdwMjExWFJ4NGpmK3QrVVVwaTlyZEkrUVYzMVg2MFBzakVvMkdWRFU5UUc1?=
 =?utf-8?B?eitCWVY5dTBQYUt2NndHRlUwcmd6Tk9hUC9sNHBJVWFkWnJpcDNtbTl2WmJa?=
 =?utf-8?B?bkdoanExZVBjc0E3S1dhQVlDR0dNMEhqUm0rdTdWSlYxQnZFQ1ExOVRiM1pK?=
 =?utf-8?B?U3pVL2tTQ0xLSHpoMzRISDA1dTJHalQ4S0kyQTlVWUFNeGpCN2YxL0owUHE2?=
 =?utf-8?B?TmI2ZUp0ckVubmR5aE11dEpEVjVWOTlVTWpac2xMRWlRR2pzVkRhb1AwcG9E?=
 =?utf-8?B?dmIyeFhQTDdmU2NLaEJQNkRNcVBIME16ZkxiS3J4SFJnL2xHK3JUdXVVajdN?=
 =?utf-8?B?RXpnWE1jRUpOTDY0VFF3dUNyVzAzMlN0QWViNFFoTlYrcEdJbEtTbHpXQjE0?=
 =?utf-8?B?aDFrQVREZ3Rqa2MxcDZaM0szbytVZFk4WU5TNUdGdUFVZHQvWGlnOXpEMzRC?=
 =?utf-8?B?aHoraFpHWDEzMlVjTk9pb2xCczJBSEVLTFo5ZitDcjQ5cmc2dldhRi9zMlhz?=
 =?utf-8?B?dVhNd25zZ3RGaGNoQk5QVERsSmJodGJFZFF1YzZmU3lFWW5YVzdiWFRpcE40?=
 =?utf-8?B?Y1BwTndkT2grRExHWERVNWxRTVdSdWN6djloMUJpWU1CZ2x4Y0Jyb1RsZFJn?=
 =?utf-8?B?cHFHd0xPMlVDSE9PWGJ1MnNBZFlwWk1UNG42UE9RRXloSjM1YzNBbkFnbE5j?=
 =?utf-8?B?N1lpVUo0L3I0NkJiNVVqNGl1V3JIQmNCSmVKUVZvOHFiQ3hEdDFpTnI5MHF0?=
 =?utf-8?B?YlFDVHZ4NGZZMCttMmZDOVVFMFMxcGFMYUlQbHFIZ2kxM1V0em1XanZTSGhJ?=
 =?utf-8?B?WUw2QTc4NUpUbHI3SGt2T2laRzIvOU9LRGFwODh5dUo4NXk0am1QK202QWpN?=
 =?utf-8?B?ZTh0M0tpanNXU2JDRVRWaEpONEszZzhOVXhIYncxVEpWQ0JDVFkwNGtkWnJ0?=
 =?utf-8?B?S01ua1AxNEQycFN0b2V4MDdIZHNQQzJwaEMyTFBEb2kyc2JIRjc4WE1GQnYw?=
 =?utf-8?B?bEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff3d3d62-d8f2-48c7-46fb-08dada147d8f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 18:37:56.9432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KcvXowshcwn5ejUbPi1CrKGneVHcF/X0VjGMORPnF4MzV1JRdRgW0F34WdvxBVSQM+Km8MLhaYyOFaP3UH0CZYjYegcrVHQo9xF8FUDI2NE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_11,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090151
X-Proofpoint-ORIG-GUID: ozFxLqBQ4P_tW6yzqg-i22vPGI8o724c
X-Proofpoint-GUID: ozFxLqBQ4P_tW6yzqg-i22vPGI8o724c
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 11:15 AM, Mike Christie wrote:
> On 12/9/22 4:40 AM, John Garry wrote:
>>>        * head injection*required*  here otherwise quiesce won't work
>>> @@ -249,13 +238,14 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>>>       if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
>>>           memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
>>>   -    if (resid)
>>> -        *resid = scmd->resid_len;
>>> -    if (sense && scmd->sense_len)
>>> -        memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
>>> -    if (sshdr)
>>> -        scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
>>> -                     sshdr);
>>> +    if (args.resid)
>>> +        *args.resid = scmd->resid_len;
>>> +    if (args.sense && scmd->sense_len)
>>
>> I am not sure that you require the sense_len check as you effectively have that same check in scsi_execute_args(), which is the only caller which would have args.sense set. But I suppose __scsi_execute() is still a public API (so should still check); but, by that same token, we have no sanity check for args.sense_len value here then. Is it possible to make __scsi_execute() non-public or move/add the check for proper sense_len here? I'm being extra cautious about this, I suppose.
> Do people want the BUILD_BUG_ON we have now or a WARN/BUG?
> 
> If we move to a single check in __scsi_execute or some non-macro wrapper
> around it then we have to do a WARN/BUG. We do the macro approach now
> so we can do the BUILD_BUG_ON.

Maybe we have to switch to a WARN/BUG.

It looks like some compilers don't like:

const struct scsi_exec_args exec_args = {
	.sshdr = &sshdr,
};

scsi_execute_args(.... exec_args);

and will hit the:

#define scsi_execute_args(sdev, cmd, opf, buffer, bufflen, timeout,     \
                          retries, args)                                \
({                                                                      \
        BUILD_BUG_ON(args.sense &&                                      \
                     args.sense_len != SCSI_SENSE_BUFFERSIZE);          \

because the args's sense and sense_len are not cleared yet.

