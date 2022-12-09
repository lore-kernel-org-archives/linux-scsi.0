Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2546AC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 17:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiLIRPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Dec 2022 12:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLIRPV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Dec 2022 12:15:21 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA8103E0BE
        for <linux-scsi@vger.kernel.org>; Fri,  9 Dec 2022 09:15:19 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9GSig2003938;
        Fri, 9 Dec 2022 17:15:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=oPgkXBraVdR9RPKFlXuRU2FCNxNMB9ugkJDP0aAWO1s=;
 b=fwAy30hmVCByc+yLrqG+iRxXJDBBq+uMU18LJhRt0oYuZ8n9I27zUSTD48XDtv/wjEsA
 j/X+qX7zRsr/Nm14k6PPXewQHdwYCOdYWGd8zbICwTp4cgYnY2CZR/sL4a6rRx2IzUzb
 aSvmSJ/+OKkbTSymtRVTvBPV9dP2omRC4ttsjq+esYjjkjhgRxsbpCBrknuWvm3jMe+g
 y/hyRzK+2ndaV1ovmEMy77A0B4z5jjrI6iytrrrD1ZLYFvgPPtI8IEM8Ifh4RdeqQJ+v
 XeHwqHaIw7k0f2BSYDCGstLs0FB1u40l4NVH/zB8uE5AADHxEH7nonDpX8Wwaz4AkSJp +Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mauduwh7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 17:15:10 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B9Fo6Rt034563;
        Fri, 9 Dec 2022 17:15:09 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3maa4u3yyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Dec 2022 17:15:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kQY2IH2b/rAW/hxLjPEjc2Crv/6aHKJpBIhh2V2T0jJk2m/pzAE0Fx5CMlDUdLkFS6ws9ROB0YvYl2MevdLjVLrhwuTjwwigkJ3hNmHqRztzIxFQJr2H6LsZUhdKFa2kzq67GWiyt4fF69ylwD4l3u8HZ2ljeKa/sJUTA92sn+IIJVrAjxbAUql+72KOLJSrfeX7cD3EAfnVGXuWKWmRgL1OnnigP3rZCPSfBI7OUjq5pbQGUN0LFM73hzhe1ugGWF5P4CRVq8ogxeHevJuI36+47fuxNrS7vjCqzZ0GI+58UbBRwFS4MWj0MH4BFWuKouiOTdgdahQJpAOYgWCwoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oPgkXBraVdR9RPKFlXuRU2FCNxNMB9ugkJDP0aAWO1s=;
 b=ijyJ3u79l1xXRQ72WsKRdyAks1MExpQGyXqFM0IDDfQFbDXDD5RBOI6Xq1r3IZiWxVkZfu44ppT4empLYY9Ormkcyv1GMO2cBnhNsEkRKuahYn1BEcNM8OtydcMd3wRoNCCu8X263eMS2WKfrjtOPrnhu2UzMKO6PFoxDVp7VYGcnrWyeMgoMoz306TXM65s9SOzmgBymWZcqSIzQ8LXaoSTc+txWb8FWCrEu28mitHsfVzdQgXvRgpZSiC0bgpB+9QeLk6wUM5z1HqU8AM+tQb5riBNBFLxRTf5lfpiwDXFOlcvmIU5eNrICLqUU5rQgBbFIpoJb6J0S0KVPtmznw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oPgkXBraVdR9RPKFlXuRU2FCNxNMB9ugkJDP0aAWO1s=;
 b=jk0SyfTusGHdMMmWu9OePzQZmQKTIjhw85ayqaiRaUOrbk69Pgya9hUEXqhr/bUMpBnc3IfNy40TO5BmNTCFMfn4085svao1xkctZkR+DY0BM5C2vB7dJs4GqjNGSWsXICRuK4thoRexLIozioSQFyERnL+oBsPMFhAydbnWUjk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5729.namprd10.prod.outlook.com (2603:10b6:510:146::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 17:15:07 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.018; Fri, 9 Dec 2022
 17:15:07 +0000
Message-ID: <07f92000-5be9-2168-8e53-55aa706fc276@oracle.com>
Date:   Fri, 9 Dec 2022 11:15:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 01/15] scsi: Add struct for args to execution functions
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-2-michael.christie@oracle.com>
 <0e69ddee-4967-ee07-b959-91d7de7b212e@oracle.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <0e69ddee-4967-ee07-b959-91d7de7b212e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0P221CA0034.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:11d::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 610d823f-f75e-46a8-44d7-08dada08eb7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fu0reU02j3H2XCjSzZo3yJCjH0i0p3v91//d/xvA5Pk2xmLl7xuDb0ooXkmAAnsAooIGa5pEGHlFFmOoeF33hmdxTxDRIktlNVbCBFhvb6/+sPgrlgcrRtM4OCVJ2MOLyBcqsFEWjoO/46nlIl+cfYj/CuHgHj3wzFmtF4t442wHiLE4PIh+c79mfmJ8AWQOznYViaIWpJZ/KOck6U/LRO7bejqdAMSk+tO5KPjS4bbCvi12GPIrJLW8jF/+q7k/xrzNsXstoQaqnp41+JPWQGoePUqi8eibLrPqW7y8OjDJ08d3f7tmtHuCLEbIt3VPYxEX52PLTnxzd20lkel+bWj0BgUdaD8DfYQVmYUt2h2SJZrbxrMliux2UMVUaodDXizx3yYGWh4LENLsxi8Wm6El4P7JeAUVi8Q+XxAnPDtSGBM9u7HlpF56wWqN6OiC6wqRi4Dyi7YAgPRx9Y8uUoWVd0x7kSXmo/CEVXN38RdrTrvXbYBwW4kXaLFLnxV0LBwL0QpJ5XvnJfrnN1NDbUSJxdw9uf57MIDidJljNtS4NHz9y1hx4eSSmN8M9PZ3ApaWmw0S/84/DKoBSkwa7dSUIXA4Naz7PLudrqZjgrYFMgt2Nbt/7oazklNUHN7zKFHU9CGB0wywkSh55rMMtdyl8jEF0kffWelgHLx02nuq2vlacRjhqDfPL5UBB87UmvTwXCtIZSCZ/JVm02RnQXp8ez801jWlb+BlJJz2qME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(346002)(376002)(39860400002)(396003)(451199015)(2906002)(2616005)(31696002)(86362001)(41300700001)(8936002)(36756003)(8676002)(186003)(5660300002)(38100700002)(478600001)(6486002)(66946007)(53546011)(6512007)(26005)(66476007)(66556008)(316002)(6506007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGQvS29SMzhKRXhYY1JNSkhKMlhsZkZTejRWblFvNWlGNTloQW4vNUM4TlAz?=
 =?utf-8?B?T3JMNVNUSVg0TWJkbDdpeGp3MXkvR1FGbWoybXJicTV0ZklYaE5McVJiUnBu?=
 =?utf-8?B?U2xUUTBiYjJrenhDSWptbjJTVE9xYXRhcXF4Q3ZMSSt1Ui9MN1cwOWZmZ3Rv?=
 =?utf-8?B?MzVjaThtR2liWkprclhEM0toc3RXeEx6UnlTTWRKalBGeWV2Z29XckVEa3hB?=
 =?utf-8?B?cVFiSmhBdm9wdW9Ea3pnVTVjMmpSY1Y3VExnOTAva1N4aWxXYTMzWEhTcHpM?=
 =?utf-8?B?bzJkbUhieGpwaGxEWjEybW1nNGZuaFJvRk9lME9ZN29zS0J1SEcwUDZqamIx?=
 =?utf-8?B?aWZzVmpXeVBEdlIybG03eXpmMk5mREZCNUdwK0tCd2ZXSjAvOXNYUktRVzJ1?=
 =?utf-8?B?VmhiakpuUjRpMUhrbWNZV2tNSlhJZVZYQ20zV28xRUpZNzI5dU5RT0RzV1ZD?=
 =?utf-8?B?TnFremdZaWZldXNZejRBc3hZSEJIM1JqTVpyOE9PMGdkaTFFS0FZaGxETjQ2?=
 =?utf-8?B?M24wZTJwdTU2eFcvMk0wU05CVDhQNVBZOG5nUm5qS2JoNmtGV3RkejhwYlQy?=
 =?utf-8?B?dndFUHdyUGtjcm1BUGdEMk04QklKaEJaYXJvaEROQ2I1elRGa01LeFc1Y2pX?=
 =?utf-8?B?c2VvTlNPcE1KWERIRmpJMVkrVUdUUzc5Z0J4Y29va214WlpMdTQ3TThKaElq?=
 =?utf-8?B?YjJ1My9jZ002bDdaZzMvV2xVNVd3TzYwK3JyNDMxTVZBMytoQ1BXN29zUkFi?=
 =?utf-8?B?V21ZQVQzOTV5RWd2OExVZEU0SXNNbWxUVXBmWE9aSUt5elB5TWVuYStlcWoy?=
 =?utf-8?B?dE1mYUpPYnNNRWIyblFibzJ1b1lneHo2cEhUd2NFcWtKcTZTTlhKMDBLTjlX?=
 =?utf-8?B?OTJxcEZPL3Fzc0JkdUlPa0EyYkUzYVhibXpVcGNERndFOWIydUhQZkZRL1ow?=
 =?utf-8?B?MkFMSEFlRW00VEZNSjI3T1hxVUwxZnI3eHNDYjFtUEYwaHJZS0RXNVIrYldx?=
 =?utf-8?B?QWoweHdQVmRCc2dvbHhYRmpYcUY5dkMrU3ZsV0J6RDBMYS9vUExWdjNVc1di?=
 =?utf-8?B?VTJ2akdFdUw5SHJWaG9Jek9qbHdsNWFXWUNZMmYwTXR0WDdLY0p1TklvTUtr?=
 =?utf-8?B?bW5JaGNDVGxGSzBOT1RhMkJadU8xL1N1VnZrNGZEdm4yS2lmMWFNNi9QcGJh?=
 =?utf-8?B?SFh2aTVSOXdYVnk3cDRKbVpQQUZyM3VUNjFEZHIyOTBDbVpQNGs1KzUvOEUx?=
 =?utf-8?B?OGxVYnVjT2xhNnY1VmZsZW0vZGlHQzBORFFEM3RjWXNEV1Y0eVB0aks2VWhp?=
 =?utf-8?B?blJGZlR6VjVwbVlxK3NTL1J4RzhNSGVtSFhQd2JsR3A4T3VsVVFLbnAvdjJI?=
 =?utf-8?B?dGEzT0JXT2I1OFQ0Y1ZSTlBIRHB5RFFXRitrTGF0OE56S25HWkltSFJLd0dX?=
 =?utf-8?B?NDdHVTZNb0JZSnpUSEtZVGNvbzl5WGZYZ0Zad1BGWm9PQjJnekZvQzUrUGgr?=
 =?utf-8?B?QWJmRlhkWFNrNG5QTmhlZGw4M0pRTERMS0VmQUhtV2ZPWGV6cytNdTNkZDVz?=
 =?utf-8?B?ZGIwZHFBdTJmSHFpb0FEbDcvOGt2SFBjS01rSTY5Q29iMmlLR01HYkdvMG96?=
 =?utf-8?B?TU9OKzhNWFFtem51UFZVd1JHSjA4bHJHK2RJZkZrRE5oeG1oSGxXNDMrNWFt?=
 =?utf-8?B?TmowR3RDWDVId1hMZ2xkNFR6OFlIbVhrUThUMWdLeHIxQkt2ZVNhMXZkMU8w?=
 =?utf-8?B?Vzl1bFlGdVROSXJ1cUsydE9tRGo3NHBaalFmU1RHc3FySGdyQ1lCTzNzcHZp?=
 =?utf-8?B?ZHV0WldwNEtUVE1YSW9XKytKeGV0d0MrZXJxMURtZTdodDZEVTZuMEFqSUZq?=
 =?utf-8?B?d3U1dldLRGFoOEl6cjVqVldxVjBBV0lhd012MGRvdmU4V1pBZFJMS3RJYXlq?=
 =?utf-8?B?b2ZIbmVwbjBXV3c0ZlArMWhVeExaVUs3TGR5YlBQR0ZXK2pZWVozcjlxOHJR?=
 =?utf-8?B?eVZ6VEc4UVFQdXEvMmgyR3U3YlB3bVZrZktyYmErSUtySnIwdm9nQitDcTMz?=
 =?utf-8?B?VURSOU9GaVYyb3VkUkxlZTlpYWd2T2hYWEM2QjVoMDNqZHhFTERyT05wMldm?=
 =?utf-8?B?bnVoSEZ1UDJ3SlZxWkhwN0VodmlORmVuVmxqY0REMENtbENBbjFtdldkTG9J?=
 =?utf-8?B?YkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 610d823f-f75e-46a8-44d7-08dada08eb7b
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 17:15:07.4632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wrvnla1KWqbD7xaGF2TKNbaFD/h7+hevy3ZB7JnwzgCclHhlV/ItxH7tJ+o2a4MpH4pnoouneHJljfdgzBbCCqiC+i8aldsTz0tB/EcF9rQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5729
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_09,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=997 suspectscore=0
 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212090140
X-Proofpoint-ORIG-GUID: Eer7AwCgwpCi2qtwnovWDeI1kKlV0Kca
X-Proofpoint-GUID: Eer7AwCgwpCi2qtwnovWDeI1kKlV0Kca
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 4:40 AM, John Garry wrote:
>>        * head injection*required*  here otherwise quiesce won't work
>> @@ -249,13 +238,14 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>>       if (unlikely(scmd->resid_len > 0 && scmd->resid_len <= bufflen))
>>           memset(buffer + bufflen - scmd->resid_len, 0, scmd->resid_len);
>>   -    if (resid)
>> -        *resid = scmd->resid_len;
>> -    if (sense && scmd->sense_len)
>> -        memcpy(sense, scmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
>> -    if (sshdr)
>> -        scsi_normalize_sense(scmd->sense_buffer, scmd->sense_len,
>> -                     sshdr);
>> +    if (args.resid)
>> +        *args.resid = scmd->resid_len;
>> +    if (args.sense && scmd->sense_len)
> 
> I am not sure that you require the sense_len check as you effectively have that same check in scsi_execute_args(), which is the only caller which would have args.sense set. But I suppose __scsi_execute() is still a public API (so should still check); but, by that same token, we have no sanity check for args.sense_len value here then. Is it possible to make __scsi_execute() non-public or move/add the check for proper sense_len here? I'm being extra cautious about this, I suppose.
Do people want the BUILD_BUG_ON we have now or a WARN/BUG?

If we move to a single check in __scsi_execute or some non-macro wrapper
around it then we have to do a WARN/BUG. We do the macro approach now
so we can do the BUILD_BUG_ON.
