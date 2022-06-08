Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CE9C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 15:36:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244279AbiFHPgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 11:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244098AbiFHPgY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 11:36:24 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB428939EA
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jun 2022 08:36:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 258Dx1De009246;
        Wed, 8 Jun 2022 15:36:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=uwbFVb5j2JuJPDjLyOOBo4mXbljk7kb+bTZozyuJkko=;
 b=SXFj5AG6K7V14q88i0Zpm6XWT9ZGvDz8SWw3LgDwUQ0iJxOUZGfqm8JePwFVuekO876w
 72Pn/+vwI36nZerObxI6Y6bHWuGcs0e95uWHMGHSVAEipXK7X52nTk4C0UVjL1DvIHTQ
 8Qu9cPnAuATc8mgrznlTget9s+oi2spSBwShJehCabDDcG4aEg7h3mOZMTydfCJTQ0HZ
 GdXLpzK1YvX8S24v0LUVDLP08+s0HTZiIgPabn5U48JtfjR7qqjccCFBNjrBwZsAoBvT
 5Ad6m0DbX3kru3dzJ4PImODxvo14/L8GpHTS5DFkABnJt2RJHhXSKhxWPJuumMZg+MU5 bg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfyekgsn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 15:36:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 258FGZPE031609;
        Wed, 8 Jun 2022 15:36:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3gfwu3nscq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jun 2022 15:36:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BLu7bpGiI21ouT4SQcbAVS6QApL7ZGToyfN/vqbTnfuNaHjE5DcZG4cPcy1csapQNTHoXhLAN+W9XSBzU2/oVvNuAmEga3/vaGD63fXG2ujZaiMdl8HK4TWUUKvxavcmJqPHFbpBZW+9BKNRYXHAXxEuulYbn1XQeVeI0tT/KGVnMGT5KfFw8cm9StlMQiCy5OX39kF31Y9tPlF3kDDBwiTXoIDtgc7tFHgc0Ts90Fr3rufCVOuftxs13Ss8pqxBS3lrEPGgiKX3yU+8MHIg7LkmGntFp0c+bhtRe8ULAl52U0TE4G0Ku0p4qvoKRGG91+g0m66HjhXn3pEfT7HuyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwbFVb5j2JuJPDjLyOOBo4mXbljk7kb+bTZozyuJkko=;
 b=NgJ/1Foya40B/4UHwRWIaco9xLcJ0O+SAkFlyIzeVYCvJb4pmhOjR/CRMIH0YIqwbdz1YJn5urUHgn67+Boa7tXqIxrMTt+Y2Fp57cTNIst/JOrsvP+GsEmyrA0crU8i3cqqnBq7hYJ+jbbIN0rEZT6NegikSaXYdOdMDM5mWIsSm8IgTr7AjLXtAbR3ra3wZU1+siwXOs52OuPzh6wD4CE0eNGBI6HqL7f2Rj7EE35W/DM40IcZsgJp37Vfj7FMxFx+ztI2eo5aCC/XtLzEhi8ur+WRKhNsvXYdZyd9qrXAoHE/Eol8uRLoLaqZ5lheGirNvPbRWvu+qf/b+PUrXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uwbFVb5j2JuJPDjLyOOBo4mXbljk7kb+bTZozyuJkko=;
 b=nwptWRVYCl3YQf8pdpBJz35tjlan05Pl2TXB9s9DF0i0Zepn/To+gJxoKIerYn1ADntMVKPfKbNpQiFrIbzDUSj0O6aIAwoCduglP3eC6JNOh+ufYqTbztIe/yWsghQwZOEngCOC7Pvzw8Y4z4vAIqpgikoutilb8+Eh09jt/PQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5847.namprd10.prod.outlook.com (2603:10b6:510:146::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.12; Wed, 8 Jun
 2022 15:36:06 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.019; Wed, 8 Jun 2022
 15:36:06 +0000
Message-ID: <48af6f5f-c3b6-ac65-836d-518153ab2dd5@oracle.com>
Date:   Wed, 8 Jun 2022 10:36:05 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] scsi: iscsi: prefer xmit of DataOut before new cmd
Content-Language: en-US
To:     Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>
Cc:     "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20220607131953.11584-1-d.bogdanov@yadro.com>
 <769c3acb-b515-7fd8-2450-4b6206436fde@oracle.com>
 <6a58acb4-e29e-e8c7-d85c-fe474670dad7@oracle.com>
 <e5c2ab5b4de8428495efe85865980133@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <e5c2ab5b4de8428495efe85865980133@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR08CA0055.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 556faa5d-a39d-4fd7-3fa2-08da49649a96
X-MS-TrafficTypeDiagnostic: PH0PR10MB5847:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB5847B7D95D66B02E50AF9C64F1A49@PH0PR10MB5847.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRpZQa8PaFdb9H7uAxsyvkXS1MWsq+cTt5hP05QZquMuEyEKu/TVwVISBg3ZsE8pOEj312JwWLsvYG8dLaY/RZiiehoABUp0HLkE9bUphSrY86iDh5wVkb1/BEZ0Kid8SvQTyKjWCZMNIMus6kZPm0HPIRgi9XJej9pAj1bLXvg8Tvm3F/rS+CS5Pr5UmpdiEo2HgcqBq7KV++epqKCM4aQY95/aqWm17C3F+m3hEcbglvOYsstFBSxezXEb6MMwbOEdWsORDYuXlgiBW3eAMZznxnoBs0MM3ipf4XlBLFiOk/eOQ/HgZvC+TKcrCbPoM5CLV3iPUm/p6Gj9ctQtz2JKoZACMVninHCGYPRsYHWsDS4D8RANX34FirRtGAlJ2b1I1mGX9OuI5n/V8SqXpeTxPoSmp561kuwo/UX5lL2CQMA3JSOUbDp30f+r6R4VvFuM9SVESwPKimCpn5CPdIzveG3alInAMER3SIVVu3xhPldr/HTDu71ech5r09gM+1gmnatAOu9ZoI0A5tlnxd29W2zRdbftCac/4PjvltPF4Y4LhFYTyrsxziS1vBEJkkreIa4pMD8zwBM9KxKjyMmAMsvjG5HsEMgl65/nrWpUpYFjlsW8AZb64+PKEFAKapzWQ++84lCLXryMMXiCV20B0XT2GL1a/tGvDVpTLgr/pQ54diXvOkUt26kDjo+2GTWjxw/mW6p/SksnanbrffiwD3mj3F7jzz9KbYj1uOsVjCMiBWKvjKzJQ3AD3OWJuyXirm75D7yCuW7d2/p/8du0iQIDejboLkzP/Wtwkzbcctq1+J/CkCEiKcSzD+5Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(26005)(2906002)(2616005)(8936002)(31686004)(66556008)(66476007)(8676002)(66946007)(4326008)(5660300002)(53546011)(54906003)(6506007)(6512007)(316002)(186003)(110136005)(83380400001)(31696002)(508600001)(38100700002)(6486002)(966005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVVoSHRyT0FCOGRzTCs4ZTlYQUwvU3l3NUwwRk9vMzJESjVENG1SRWdOdll5?=
 =?utf-8?B?TGUxbllZNU5kWkZXWEo2Mm5pMUluTnIraS9VYjk2RnlMVXM3SG5TazRYaDdk?=
 =?utf-8?B?SnNzaHNIYlJoMWlKZWlmVTZ4OEt3MlFiOU1Ia2gvQnh5RUd4ejRHVXhaYVIv?=
 =?utf-8?B?V1dvYUFBMi9PVldwdGVCYjR0WXdIcG90WTRoMTJ2WGNodnJ0TDlNNEc5UlNa?=
 =?utf-8?B?eHM4YktEYnI4bmkvaFYzSm13cDJJUTBYcjNHNkNSa1ZXMmVkQ25Ua1VIMnVn?=
 =?utf-8?B?ZGtrK1RIU3pYVzZpVjlzL0dmYndmVDRYQ3p6a29rdkRaaDRBdWk5NTVLYXN3?=
 =?utf-8?B?OTU2aGV2dXlzbk9pNi82bnhnMDZOSVlXa3hWcXg5U3hsUkRmTVZmL1JIUjNH?=
 =?utf-8?B?UVR6TjZ5cWgyV28xRWNWbFBaa3ZUOWtVeDgxczhOK3F6eEdEbDZzcWZRYnhs?=
 =?utf-8?B?ZFFEdFlIZHZPRmVHMGR0S25VeTFSblBaM09UU0x4RlJOYytSTGpOS1p0Zm53?=
 =?utf-8?B?bEc1ZlI2T1pYRG4rM0F5R2xxZXBUWDFvQW1iM28rRkIydk1RaGU2SXkzWEZO?=
 =?utf-8?B?bGR0T3ppUXZDeDV0bGhuOTJyQUVzRXdBV0x4M2hqZE9PRFRvR0Uwc0pjaGsv?=
 =?utf-8?B?dTV5WnVvOUdGZTJZSlJoWVgwNlFYWkI3ZUZheWgyYWpJUGl6WHRzdVVjVlZG?=
 =?utf-8?B?eVFaMHFHWXJ2VzJLY0g1c1JLUXBoc1V3U0E1OTdLdnFHSDMyTUhQWE4rajV2?=
 =?utf-8?B?dmIrMHlGa280L1lZdEtNekw2TFFBTjdTSG9hbXJKSU1oNURmMU5qeHcxeGpF?=
 =?utf-8?B?QkZGRkorTzg2K2x6UkRiVXYxSHlWOXBGczdKcVRsVWptVEUzRk9VdXAyM3hs?=
 =?utf-8?B?TU1wdSt1b2Vud2hrOFNNTVlTRVlqdU1sSEhYRnorb216U3NENG1LVXh2S3JN?=
 =?utf-8?B?WWl1Nkk3UFJRbCtTaW9iQkpPbkNSQ2FCVGdEUlpqVk5WWEJMcGFUb0lGa0Nx?=
 =?utf-8?B?TGx6T0hTSXFrL0srQUlnUWJtN0UzNFRtK3Q1SXl0VWE1VjEvVElnZjhwSXI1?=
 =?utf-8?B?cVZMalZFZ1dONUVaYVlzNkRwaVdUbmxDNm5BcHcrbDBNc1M5Y2U1WU9PK0NS?=
 =?utf-8?B?OW5qcUF0MmlNQTJwdmV2S056dG45eTl6WG1mUlBvT0dSVGo5RTlQc01rNmtL?=
 =?utf-8?B?Q0pzRGp4VlFxMFIvQzdjQndLY1I4cWRzbC9xUGg3dk9jNC9XUXFOOEtsSjNx?=
 =?utf-8?B?R0UrbjJyemRkVkNKRTlPaGpSZU1WZVY1UDVhdDBWcnBuaUt0M3FCNmYzWVVh?=
 =?utf-8?B?Y2VHaFRoc08rQWVQUWJES0NieG9tdU1QeHp1VHNkeTNMdFlzVzk5SnVIdnVI?=
 =?utf-8?B?bWZPUGQwVFE0RGxzaDg0aWtIZkdjd2w2S3BkMGtQYVNMeXF5dU1GZ1JKWWxI?=
 =?utf-8?B?Vk9UNm5xbzNibkIrYjNaVklMMlRmTEphU1NLVnlOT1I4M0k1SUFPRU1qZjZj?=
 =?utf-8?B?TGRJaUFrZkQ5WlQ4UVgrbGlDbUEyT1JWUldWRVlLSHZSSHVZdFl6Z1NMUXpU?=
 =?utf-8?B?MVhyNC8wTWFQN0V5RDFoOEEyWHhOMFVvMU43Z1lwTmlKYlVGMTZZN1JCZEVP?=
 =?utf-8?B?ZUc1UGNIdldjLzU1MDJPblVLeTF0UC94YUJKNmhOeUV6WGYvZjJ5amt6WGds?=
 =?utf-8?B?SDh5ditnMGFBZUhnQk9Nb1FTZ0hrODRDT2N5OVQxVjlnL0ZGNFR0MXB1R1hB?=
 =?utf-8?B?b3dIQXgyUHUrS3JObk1MeUkrRVJxeDFrSGw1OXFPS0VCQXJ1VW1QMXMrYU9N?=
 =?utf-8?B?VGZtOWFObnlqRTAwT1p4T01YaUNTZUUxN0o4a0JNNFZHV1FiUkJDQ2VtQ2Qw?=
 =?utf-8?B?dEsvRElDUkZWWE0zVjVtMCt0U2trcnFoY1JLNDJ2KytKaE9XaGR2d3c2dGJr?=
 =?utf-8?B?MFc5K0lVcHVjRjFGaTNSeHlReEtkYXBGTmNFMlZMeHhkTForZ1g3RE5vZEwy?=
 =?utf-8?B?cmlhYml6SXRXOEszRkdPQk1aMUdrTDZGQWNpVkxLRXJCc3RKSVpqYitYaFhR?=
 =?utf-8?B?MmZiVWk0c2RBckpxZjZ5N25zYWljcWRQZUsrTE1UK0lwWHduL2Z0bWVoaGtz?=
 =?utf-8?B?em5WOXo2SjNrQVRXc1dtY1ZPeDJibUIzS1VzajhhbGRPZzB4OC9GeHNhQ2ZS?=
 =?utf-8?B?amwvTVM2dDBTWFlvbHExTFZBWFM4a3hoQzQzK0RTUTRyZVlYbVg2VEwvZHg5?=
 =?utf-8?B?Q2k1R05YY2xHNEdGNzhTdVZUV1hheC9MTlNSVGVSaTBLaUhYQUVkV1FsWHd5?=
 =?utf-8?B?ZFhOS1AzaE9qRmhTSlVrSFVBQ3RUT01rdUFxMWhuQ0NFcEErOUd0VVk5SEt2?=
 =?utf-8?Q?7GXGTu4HYg8L7mHI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 556faa5d-a39d-4fd7-3fa2-08da49649a96
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2022 15:36:06.7160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2OLUzVUNuzwE1YXANT6YbgjofndDjvli/YYO3r745Gqsw3UFv1hmuGMHMUtTR8DLI83ZFRxNWoi4cDW0KCZ7r2w9n97mN5Tbr+L7nu13Yg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5847
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-08_04:2022-06-07,2022-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206080065
X-Proofpoint-GUID: 9_5To7znGOTrCvQ5jlqcocgkbgLNzeAB
X-Proofpoint-ORIG-GUID: 9_5To7znGOTrCvQ5jlqcocgkbgLNzeAB
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/22 9:16 AM, Dmitriy Bogdanov wrote:
> Hi Mike,
> 
>> On 6/7/22 10:55 AM, Mike Christie wrote:
>>> On 6/7/22 8:19 AM, Dmitry Bogdanov wrote:
>>>> In function iscsi_data_xmit (TX worker) there is walking through the
>>>> queue of new SCSI commands that is replenished in parallell. And only
>>>> after that queue got emptied the function will start sending pending
>>>> DataOut PDUs. That lead to DataOut timer time out on target side and
>>>> to connection reinstatment.
>>>>
>>>> This patch swaps walking through the new commands queue and the pending
>>>> DataOut queue. To make a preference to ongoing commands over new ones.
>>>>
>>>
>>> ...
>>>
>>>>              task = list_entry(conn->cmdqueue.next, struct iscsi_task,
>>>> @@ -1594,28 +1616,10 @@ static int iscsi_data_xmit(struct iscsi_conn *conn)
>>>>               */
>>>>              if (!list_empty(&conn->mgmtqueue))
>>>>                      goto check_mgmt;
>>>> +            if (!list_empty(&conn->requeue))
>>>> +                    goto check_requeue;
>>>
>>>
>>>
>>> Hey, I've been posting a similar patch:
>>>
>>> https://urldefense.com/v3/__https://www.spinics.net/lists/linux-scsi/msg156939.html__;!!ACWV5N9M2RV99hQ!LHLghPLuyBZadpsGme03-HBoowa8sNiZYMKxKoz5E_BNu-M9-BiuNV_JS9kFxhnumNfhrxuR7qVdIaOH5X7iTfMO$ 
>>>
>>> A problem I hit is a possible pref regression so I tried to allow
>>> us to start up a burst of cmds in parallel. It's pretty simple where
>>> we allow up to a queue's worth of cmds to start. It doesn't try to
>>> check that all cmds are from the same queue or anything fancy to try
>>> and keep the code simple. Mostly just assuming users might try to bunch
>>> cmds together during submission or they might hit the queue plugging
>>> code.
>>>
>>> What do you think?
>>
>> Oh yeah, what about a modparam batch_limit? It's between 0 and cmd_per_lun.
>> 0 would check after every transmission like above.
> 
>  Did you really face with a perf regression? I could not imagine how it is
> possible.
> DataOut PDU contains a data too, so a throughput performance cannot be
> decreased by sending DataOut PDUs.


We can agree that queue plugging and batching improves throughput right?
The app or block layer may try to batch commands. It could be with something
like fio's batch args or you hit the block layer queue plugging.

With the current code we can end up sending all cmds to the target in a way
the target can send them to the real device batched. For example, we send off
the initial N scsi command PDUs in one run of iscsi_data_xmit. The target reads
them in, and sends off N R2Ts. We are able to read N R2Ts in the same call.
And again we are able to send the needed data for them in one call of
iscsi_data_xmit. The target is able to read in the data and send off the
WRITEs to the physical device in a batch.

With your patch, we can end up not batching them like the app/block layer
intended. For example, we now call iscsi_data_xmit and in the cmdqueue loop.
We've sent N - M scsi cmd PDUs, then see that we've got an incoming R2T to
handle. So we goto check_requeue. We send the needed data. The target then
starts to send the cmd to the physical device. If we have read in multiple
R2Ts then we will continue the requeue loop. And so we might be able to send
the data fast enough that the target can then send those commands to the
physical device. But we've now broken up the batching the upper layers sent
to us and we were doing before.

> 
>  The only thing is a latency performance. But that is not an easy question.

Agree latency is important and that's why I was saying we can make it config
option. Users can continue to try and batch their cmds and we don't break
them. We also fix the bug in that we don't get stuck in the cmdqueue loop
always taking in new cmds.

> IMHO, a system should strive to reduce a maximum value of the latency almost
> without impacting of a minimum value (prefer current commands) instead of
> to reduce a minimum value of the latency to the detriment of maximum value
> (prefer new commands).
> 
>  Any preference of new commands over current ones looks like an io scheduler

I can see your point of view where you see it as preferring new cmds
vs existing. It's probably due to my patch not hooking into commit_rqs
and trying to figure out the batching exactly. It's more of a simple
estimate.

However, that's not what I'm talking about. I'm talking about the block
layer / iosched has sent us these commands as a batch. We are now more
likely to break that up.

> functionality, but on underlying layer, so to say a BUS layer.
> I think is a matter of future investigation/development.
> 
> BR,
>  Dmitry

