Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7574C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 14 May 2022 16:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiENQie (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 May 2022 12:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232786AbiENQic (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 May 2022 12:38:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0002D1DA;
        Sat, 14 May 2022 09:38:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24EDswGQ020796;
        Sat, 14 May 2022 16:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=oA3fSZGfSzGdysxYoUz+l/JTPQAl8DIfAHZ2FdnrTQg=;
 b=ll1WW8adxCc75y3DOSsfr+ppRhzhj4u0lYbe6bGoBRp7QV7CHJNFUNqk4huIu3zdFAl8
 k9wJ96UpUiaNxr29l6HwXsT6nXCQAG8cQ1IHSgTYtQcaWv+nohorQ7fCruFO0jOY+WXm
 SOG4fHmkHUAeCuHmo4F2bT0ZpFqAzQbCZgHke5gOZjNNPd9f8ghKuLbOVHAulewJah7q
 TBtgzDmAplo7pWaqvgEXl6cB1tltWMOj+U6jeyEE8f/30AuV71DXTfZEAS5zmpqsUhqM
 4TJTiZZj7awRVowUiKq6vvEelfvKMCqGODv1Ky0lnx4e9/EiefxxR0dKOmUmvP897ki2 3A== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g2310gn6g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 May 2022 16:38:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24EGVw47037637;
        Sat, 14 May 2022 16:38:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22v63bs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 May 2022 16:38:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C7sdHUAlGRXzZO15RPh9A2FbSedeXDFEo0xaa7FQ2Q10KaIhHn+laiC2AgA7dtWx9cWIeTUCH4ZT8+9EnVqYtUcrYLKXgnURmuxBj7GPrVjzcb5IQdw1khD4KILu2ZiSspaXRQt1yRZPndHMncZK2aEKi1bwLcJCYBwvaR/If9Q6L8VkAx7srHOpS4G9Fl39eIOg1TcX0ejWDgEcJ5Qzn1fxo5AEXVF+MmE0FZjNlxyFsk0P0eG5mO8LnfbR+Cqw4fAOLH5SKK4tpPXweFc7ieqa0wmk9rnUUtrs2KuC/enLrlfRStb0PG5Ngv+MozBYezvXo99mjSUMccwzf5oRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oA3fSZGfSzGdysxYoUz+l/JTPQAl8DIfAHZ2FdnrTQg=;
 b=eOznjM3rWTTpKyyE7gKhdLFkJ91GyOmdquxd8rRZ0qBj6MPnSwd5FAIiv5j+OlBjCwkiAEIYkUeNWL6j3DchAaLf4y9vraMh0R5/LC4xRYSYRRjjZbSG1GHrt4S95VPRAaCVKgrlh72JG5FIHebtiD04EF8voHARxy1h+PpyecJ9+Z169QMWgm1/1OMjm03DuxQ+921KTRIpuuK/0I0HgeeH/V/0z+qkfDwoWgpF2mbuqx4xcn2PiCnG4Xa9Htd/IfbUgooZbLGCIAkVwbmn8bvsXZjiS5GSyeqwMdfP8qzFXTZQdAqYfQb74Npk85TQ1lXvknCJXPGD3qnuneLg/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oA3fSZGfSzGdysxYoUz+l/JTPQAl8DIfAHZ2FdnrTQg=;
 b=d7UmhPOYalt1TzkQuwusC3IPfH2AUvIm63Rpf9aIQw2DZ1JiDee50PsYNU2dDZDwHSklikkSfHfEO8rW2chfMOlHzpH0XWyfFPtYV+RQKP+mjzeGSekWtaIplzJ0j7vhoBKG9ef4hJP48JTIP/r8V5J1AqKyfe3a+Zx3JXSZ4Mc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3178.namprd10.prod.outlook.com (2603:10b6:5:1a7::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.16; Sat, 14 May 2022 16:38:24 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5250.018; Sat, 14 May 2022
 16:38:24 +0000
Message-ID: <97072be6-775d-cd6d-8a4c-ba7f83f06ad2@oracle.com>
Date:   Sat, 14 May 2022 11:38:23 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 0/3] target: iscsi: control authentication per ACL
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20220512104508.8680-1-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220512104508.8680-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:5:3b7::24) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e793662-e4de-46b9-a547-08da35c82a5f
X-MS-TrafficTypeDiagnostic: DM6PR10MB3178:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB3178A59D79ADC814D4166467F1CD9@DM6PR10MB3178.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Xfs5GakbgW/sv75PeWZN//0EvkN2EJ7oJ3bYH6iUjqlr/Za0LzRfU70SjqxXZ9NljtuePn1uLG/Jc0iBhG1rC5K/uSJyMjvW8R2PbRHO0LbmQluthkVTo8pzPXTgWgtCEPW1eTa6HBb3GkFcbvuCXNIq1T60ol6k3sJeH6j5y/QOsnQke3uY/STcZOlvKxsI3DCwyDnKxLr0mjSpMSe4eH7pgajKqotVQmpYPVwhSmOIaItrzcy1TiFSr5lYBQVnB0TquOHPieW2rLp+fff7F33q8nmjEp39VWD2JUr8Oz+QSvfFPi6SASgoovZFaz7frhuZa5ON72i/lvvZkFKEDrEtJHFib/NCRwaOlItY2YkkS8vEiACwIq4hVGo+YHKEw6ncD5TayqeZk3Sx5jjfvlrzgZNcNWxLHe9xromgw/858dQuaF1qe7JIruIsouA9bodiG3CJxHvHK3U/8l9VBQSuCp48BFcKw//DPJYW67V5x1EeGE27W3VJ6ZVv7hXG7+ZAS1grIFISkHg/5g8hEGgzh4Zqqc4W+TlVTEcfg4RTZ4RSiXxxEH/J0HCLycY0ywHu0Pyw+s9RqpOIqMKwPOEDGHcrouVWK516KbPalUz9nSu8xaYajVkIO8ngenu/bcggp+C8oXkBfrisCLtRhc3+XPkxgatqlYeEEO5e9o3awRKojq8VYSuQAV6yczX7wOxZ4x2LyLzBOKkL3fD21gRTaPKrm1G5lRkz1/QrUuO8pk/Dbz/e81nHtdjnfLD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(38100700002)(110136005)(8676002)(66556008)(316002)(4744005)(36756003)(8936002)(2906002)(6486002)(5660300002)(53546011)(6506007)(31696002)(86362001)(26005)(2616005)(186003)(508600001)(83380400001)(6512007)(66476007)(66946007)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjB1QXRKWXBoeENJeElNbkhrMWZuS2hYbU9OQmtpQzFaRm9DOFg4TFZJVDMv?=
 =?utf-8?B?cjVtT3ExblVWVnY3M1FYSkJNdmhBSHJwWThCSkZnakRNMmF0ZWxFcXE2YzZy?=
 =?utf-8?B?UjJSWDlNUUgxVFNBMEZHQkZZSktVaGkxNzl0V2hjRVVGbGZ6dUNuL0pIdTBZ?=
 =?utf-8?B?M3NkNitUdkhISmN0MUZ6bWhtZ1BZR1VBRTdyUEV0czNoUWliV282SGg5YXJB?=
 =?utf-8?B?TW0xM1lFQk5TeGtTYm9WNTYwclh5eTdjR3ZWdkNKUi9PWGZONkZLMnNLYThu?=
 =?utf-8?B?bmlFbzJVckhFZzBCSkxIN0xDSVRhcWt3cVptVHNhVHNBaEU0bnNIRGJPd0Fn?=
 =?utf-8?B?WmdMQVlxb2lnMTRzZ2tsZS9pbEhIUTFCSEhaQldXL29WSzFmV2FRN3lQei9F?=
 =?utf-8?B?OHR4c0tYc0dLSHZIYXlJS0JSM0NXK1Bxc3l4UzRFcGtFWnoxc0JmMlBOT1hr?=
 =?utf-8?B?emphQjdyYUVVMDk4V2k5bGVPYkw1ajc5U29ySWNEWUtEVjNZbHlMbTI1S2wr?=
 =?utf-8?B?ZnJEcm9GNHlaS2Jlc0kxc2NheHk0TnFXaU1Va0o4TzlHZGVlblBnN0NJWlpx?=
 =?utf-8?B?ZHhiWEk3V3gvV2hiTEgvbFdseTdhcUFUeEd2ZEZqL2g4UTZSWHd6L2FTLzR0?=
 =?utf-8?B?TzVjK1o4c2cxdTgvTEpwQzRYNlltTzBVUWdmc3ordXVHSkNoM0w3alpSeUEr?=
 =?utf-8?B?OEFnKzhzdUlLRHBqMENUaU5JTFlRbkJzclhIRjlFVDk2NHJ3cXh0RlJtQ2lp?=
 =?utf-8?B?d2djbFRCMVg0eEltUG5OUFF0TkdEV0I3VHl4ZGFnbitWdS9QSE1Ed2hTRi9v?=
 =?utf-8?B?QUcrMDdRTUlnRXhFZzZLbG1LTEJYbDdtN3hZQWJlZE1waWJIRGtyRjZncEc2?=
 =?utf-8?B?b25NRUJsclE3eUJlVTcwVlBqckx3M2R6TlpJbTlPNE1VN2hLa3JUaWh5VFlD?=
 =?utf-8?B?djh5S0FadmVLdXBXV3htcXRybmp0akJmV1lZZzI5SnhkbVhYMEljRGFmdnhH?=
 =?utf-8?B?UE5wNUlVMDFkK3lyTjJXa2RvcnNYZVJhK2NGQ1BhUy8xMHRKNjV0YVErL2Mr?=
 =?utf-8?B?QSsybHJLeXJBdi93L0V0bjVEVmJDQy9RVnB4MTNaRHR2M252MEVvV0FVcHhL?=
 =?utf-8?B?aDI2N0x4NTFkVDFWQXVld2JodzdCdTdsUlhGa1gyTGpDUWpRK0poVVhrWkFH?=
 =?utf-8?B?SWsrNTRETDJGQ2JwSlR5dlczYmJydDNjc2hsWVNLN0xXUFRLZ3llVjcxbk9P?=
 =?utf-8?B?UTdabzNSZzZBNUpUblpwR1U1MkUybnB3TjRwczA2WWt5d1pObmZZNk85NnZ2?=
 =?utf-8?B?aWRpeWtWeXZoOHVmZU5wTkhkU3IrSXhzSWM0VDFiNTZlUzBmS01wMXlyekUv?=
 =?utf-8?B?cVpqb3RLaEh6dGRVMFJaUWZGejNRNHdoeXhoU3Bid1F4aGRreGN6YVpDcHQ5?=
 =?utf-8?B?ckc4QVpEMnI4YnY2YkxZeGU2L0FtbnlMaTZ4MWxXV2l0YW5RcWIwdzkzUWU0?=
 =?utf-8?B?L0dFMlF4OGROc1NGQmZCeDg1UkowL2JRa00zQnBmREJlZEwya1lHcmxxSEVX?=
 =?utf-8?B?OStsTUxyTUFGQThzdVB0b3JjZmg2YVA4d1JlTEFPTitlaUJmSVIwSnF3c1JD?=
 =?utf-8?B?TXJBWWkrLzREMnJQYmpLby8wV25tZWlKU1NRNG1YVW12bHdXY2RiaytDSTFq?=
 =?utf-8?B?dE5nRS9LZ0pQdWlNcW1nazZBT2h3YUFZUk5HajgrOEtHVkJKQ2cwUC9UVldL?=
 =?utf-8?B?V1A2aHJsMjlqWWpheFlKTVAyUmNIRkJLckIrWVdQcmY2YytuRTRlNFQ2eHQw?=
 =?utf-8?B?bUxZb1M4a212UmQrV2ZrOE5CL1A4bE43U1kvYk8vdVdnTWR1aFFyQnEyc2dR?=
 =?utf-8?B?N1dOTUlNRm93VHErTG5mM084WWUrenlub0NLOUJad05Ia1FCRmI5ZkhFb2Q3?=
 =?utf-8?B?YmJJdE81VmY0UlF5L0ltUXhaNUZnd01HdTM3dmZ2UWlDbWVhZ2lpT2pDQmRS?=
 =?utf-8?B?aTF5VlBZWkF4c25Lclk4NFQwNHZ0SU9uc3RXU2pWYlNBZW43Umd2SURBRjBv?=
 =?utf-8?B?WVpIeFQzWmJmNTNSaTFINFgwa1pZSWtOU2crV3JTZGFGYlN4b2hMb3VPVWM3?=
 =?utf-8?B?d2xtNTk0ZUhDakJlMEFXaWFCWTBOU2tuc1RYSjgzQ2NvL1JWeE1TOTlTNEhE?=
 =?utf-8?B?QXRnYkUrVnA5Y2wySlNJVDc3eEgraDRyUitOZmFjS0QvYXlRREc2NjUyTFA1?=
 =?utf-8?B?Ykx3NThDL0V0M2tsVVQ2UFE1VXVYQUtMUHNDVmRNS1NJTlpTWDZLeHNNUjg5?=
 =?utf-8?B?bXNYTnJod1VsTmNpTnRIRm5WNmhoZVJsVUJRR1NVajJEVGorOGYraWMwTWZk?=
 =?utf-8?Q?q4U8kCmdiFtlIcG0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e793662-e4de-46b9-a547-08da35c82a5f
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2022 16:38:24.8239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nREALaMNEoF5Ou9PdkiyeXWA2j6cv2AUHTY0yNQdFW2zYux5gUVtrsNbaOFq4892EyIx2Bm62GEWnMaueTAIhk4i2QiGVLx6usoLwdHmA74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3178
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-14_02:2022-05-13,2022-05-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205140088
X-Proofpoint-ORIG-GUID: BPJaOMBXoEpjRqQeoit0VeHkq8v1h2fG
X-Proofpoint-GUID: BPJaOMBXoEpjRqQeoit0VeHkq8v1h2fG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/22 5:45 AM, Dmitry Bogdanov wrote:
> Add acls/{ACL}/attrib/authentication attribute that controls authentication
> for the particular ACL. By default, this attribute inherits a value of
> authentication attribute of the target port group to keep a backward
> compatibility.
> 
> authentication attribute has 3 states:
> "0" - authentication is turned off for this ACL
> "1" - authentication is required for this ACL
> "-1" - authentication is inherited from TPG
> 
> This patchset is intended for scsi-queue.
> 
> v4:
>  rebase on latest scsi-queue
> 
> v3:
>  fix warning: no previous prototype for function 'iscsi_conn_auth_required'
> 
> v2:
>  show effective value (-1) for inherited mode
> 

You need to rebuild this against Martin's 5.19/scsi-staging because
these patches have conflicts with some patches in there.

Other than that, patches look ok so just add my:

Reviewed-by: Mike Christie <michael.christie@oracle.com>

on the next posting though.
