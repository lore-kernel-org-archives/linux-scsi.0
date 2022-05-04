Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1622CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  4 May 2022 15:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351683AbiEDPFB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 May 2022 11:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351692AbiEDPE7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2022 11:04:59 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55B4A25EAA;
        Wed,  4 May 2022 08:01:23 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 244EZL6N018676;
        Wed, 4 May 2022 15:01:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qOgtk7FqLtGFrCE7Bly2CnQKajcKkbyQBBt2ieGvh9c=;
 b=VW0qXWPFIYrdB3ZHyATU0AvKsT3OrmDcND4xwavsCfooVtC4O7avPv5uSe35JPpONf+5
 Dtqohkv88x/FYQMb1DnbIUpnG1FDxWVzr931nfrF9QWxF6j54WyxwN4F69RwEfeXyHMy
 ClfDyPT/DhKtyhkhn6uIUZSdO4xZo/D7Fg95l4x5np/B5pkVWAAVpkxtf8wwlpMybOWb
 bUlBEZZCJWe/Fmgso5YZHSMbsSX6EB4/kNO/qvvZkX4vXoyC2jBcqnjE/hJ9NXyWZZ0H
 SXeX9mj0xP7jg5KsKhWFIinXdPvfUusjkKM3c2gXQfBd+JQEEyK8+kqGqP2vRIcijXui 4w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3frwnt8qxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:01:09 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 244EtSYY038949;
        Wed, 4 May 2022 15:00:57 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2047.outbound.protection.outlook.com [104.47.73.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fusafmgm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 May 2022 15:00:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOomYuMB/7U37pvPdTEFEXJ+4WFbWROlrz4JFLrCCLrSOF/DUDBq2mGcSeFe4sFOJt8T3WzoaQl0wEI18qQOiBLfz4EtJLEMeLtHr1lTKNDEgRShlcKIAR9NJg7XlYB0B+qWHIIHX+PYJfbDEeqLJZVv5bVzPgJL/RO0qzktsAf3I6XLArfmMYAOslO2Vcwst6/AeYzIQkHJ8G70oDUF96PUZeuhswCXYBqelJgKge/R/S+ORiIrKtxivvZKDgByQYFWRG/1bAvk/Exxp2PY+Zev0wVqvtwryha63ABBUfT6RllsFpF5f4SuC9n6Y8g2UUow2VsyV7ctyPZXLryG3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOgtk7FqLtGFrCE7Bly2CnQKajcKkbyQBBt2ieGvh9c=;
 b=d2JYk9xZpvaqnNuOif9L0NGYAesVLGehDRx0X5ygCGs8UBbvlHbR2ePhf0hS8RkBhGLgcKn//YSklHkCfQbzE7T/08JeFMosY/cmuERLOnL8pNRLRVHhY608h/9h489ipDytYeP7Bgq1/DM6O57PRBzI+Ukh7oiogWEzhW1RfOxzZwvIlCNYPft9qDPaSoPRWxtqsA2srmcJVDkXpuhRglTiFGG9tcA45TZHSr2q+J9wqPQXDSFecwxAs4CGk4WGsfS6MOBCL9TW8GlqRKKRMIQwFW5QIaZsC79/natuRb8wmT/q2++8sEsTTRTIuiUu8bjrgZRJuSddfTz9TNH3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOgtk7FqLtGFrCE7Bly2CnQKajcKkbyQBBt2ieGvh9c=;
 b=x8R8UVgrFkad+s0NjDqj90KRpt3aewHrj4W9Vt+5Qvedl6bddZObQHkDNypxag4+rg+kmF+J3LujV0/c9tRwzYEGmIWL3bdCxyffunhWup8uth0gXrk7+tGmSWFdzhk734S+/9jCAY1qn5RkKTvHKz/U2Q1ZtC+6bUVOl8FhTOM=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DS7PR10MB5056.namprd10.prod.outlook.com (2603:10b6:5:3aa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.12; Wed, 4 May 2022 15:00:55 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3cb2:a04:baff:8586%2]) with mapi id 15.20.5186.028; Wed, 4 May 2022
 15:00:55 +0000
Message-ID: <12490814-1c26-3fea-ba15-417e27b6bae2@oracle.com>
Date:   Wed, 4 May 2022 08:00:53 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 2/3] target/iscsi: rename iscsi_conn to iscsit_conn
Content-Language: en-US
To:     Max Gurtovoy <mgurtovoy@nvidia.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, martin.petersen@oracle.com
Cc:     hch@lst.de, sagi@grimberg.me
References: <20220428092939.36768-1-mgurtovoy@nvidia.com>
 <20220428092939.36768-2-mgurtovoy@nvidia.com>
From:   michael.christie@oracle.com
In-Reply-To: <20220428092939.36768-2-mgurtovoy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0105.namprd05.prod.outlook.com
 (2603:10b6:803:42::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aafc81d0-a317-4859-0530-08da2ddee3da
X-MS-TrafficTypeDiagnostic: DS7PR10MB5056:EE_
X-Microsoft-Antispam-PRVS: <DS7PR10MB50560BC7849D9CEFB191BDE9F1C39@DS7PR10MB5056.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xYVYXUzmunI45CPCxCnGghl4BhSqvsT4JZZdt9QtoyRK14/lZnLnFm+UTd7jsXHHugqbz6w+fvnIAD3QnLEaYDDdeaytem3i8ZTiNSaLP+7x3gMzwIX3v4fwkltXr8E8tGG/7wzGGM1JesQROGT8nFvQ8Q4Yd+UuRVrPVW6IQzXxZ/8qP3wQ05uQZabvPjGy4M3i/bH+JcHtgnIS53eZd7mlhA4jAui0t9mPd1x3rjhV+M4B5loXvyVmNNxghCf9LFBAM4qDihy33RTa7MN5ATLVlYxrjKuUdEvqvwuXtfw0KXMYGrfVcG+dgENHcvNypv9/IHaoT7iA5z4OuyhCGcQQZRyzXO/NO4Fuw/DkauPpXdvwVtR5PPClcoRkHozdBSs/78U0sPUgAMcWNc22mykTIJ5JtEDpYy4LuV2j3q/OEP+ilGP/38FA8/TEU0GAwIVRy9Gtv2bI2CeWGE0w2GQcNknuDlfsxD+E9zROIGSDtJKP10aHURzn1to1si5kZt4rcKDBdFEQChKHKvu2we+YNb/kW1Ta6PsjEQiE+YE3+paLTv6FUfe0ytvyw3S/KgLeHfFiVb/xHhZni/84Ozzd5c/NnTWqBndlehN12ojbKLvzViqrUZPVLGvca6uC/T7di8nc4/iqylmei+pQQ4Go925F+674nncwzwEy7t4XM6U+uQQNlC7W/32i/kAC2u0h+Rj7ZIJuzHfzRadmtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(38100700002)(9686003)(36756003)(83380400001)(31686004)(186003)(6486002)(4326008)(5660300002)(508600001)(86362001)(2906002)(8936002)(66476007)(31696002)(53546011)(66556008)(2616005)(66946007)(8676002)(6506007)(6512007)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEI2QnQ1S2JKb2VDVGZGaEdmeFN5NUg1a3c5NFdCNzFvZEtrNkRhRkl4Sms1?=
 =?utf-8?B?Y0R4UFM0UTQ3bHc5TWR2QyttTi9DL1BFQ3dXV2NiajBGQndQdENWQkhwSk5Z?=
 =?utf-8?B?YWpIS3pSd0pwcjZWZzZLbGoxN2ZieUs5bzM1TlNCMmVySTlTMlE5Nlk5YVU2?=
 =?utf-8?B?cmp6TmdzVUtpeEdWUG5QR0JOOXpXMS9QRGJQTnhmTnVvZDU1MXh6cjBtZ2Vl?=
 =?utf-8?B?OUZ4aWRpU2tvMzJxSVBIdjNTaEtRbEJoa2NUQVV4K0M1WVJuenBYREcxNzd5?=
 =?utf-8?B?UTlJdnk5UEtDaW5QSU9wdTZmVXZ6ZzIzdkh5SHc4Yy9oZFN0WjUvUzNFRXl6?=
 =?utf-8?B?aTdMbEpjelArbWRxalI0S0J4TjBqWU1xUk9NS2VDUzFzcjhHdVoweEkvQVh2?=
 =?utf-8?B?b3U3eEwxdnQ2YThRWldhVUpmNm1JSm5qaHZqeTNqYk1hU0ZzTGhVc0NuaWlI?=
 =?utf-8?B?NCtqS2RkTGltekduSUsrTmEzeldwTDNRblAvcmR3OWFHbmNTbm1XT2VJVlRK?=
 =?utf-8?B?WEkzSHhSdElqaVVRWWVML1VsNjhKc0NETktYQ3FONld0Vzg5N3ptbE45OEFP?=
 =?utf-8?B?OXo1M2VwUG83THJZdzdyeS8vVE44Z01KbFRMdmEvY2F3a2lWMHErMjA4Ylk1?=
 =?utf-8?B?OU5SbS9oS2toSEM1L1R2L2kyWWFxbU1SQWUzMk9qaVI2Vy9tVE5ydEVjWi95?=
 =?utf-8?B?aG1MZU1mRlpOQVhsTjVqVlY3VXhqSWVTMHBoRTl1SDZMWVBqV1RHRFhPaDRE?=
 =?utf-8?B?NzhjSE9iT2R4dU9LWW03dUp6cmdSNmtCaDRNd0pBL29JQmNGdDZpa0l0ZDdk?=
 =?utf-8?B?cGo2TkFIOUhpN1FrSTNaU094Rm9yUkxHRThmR0Y1aGsza1FpMXhGRmlYb053?=
 =?utf-8?B?V2tXdDBHZlJ1dlJEVnl1NFRqOVRxd0xNOU92TEhkN0MzeFBybDhkYVcvanRJ?=
 =?utf-8?B?VGQ1amhVcHVHMVhnb2tELzc0amFzcHVNUENmalFwcWJKb0VJR3hNQ1JBRDhs?=
 =?utf-8?B?YTBIYjY5NUNFc0xqdUVIMkZpYWZNLzFwWmlCSkpQMzlZV0hWQjNTbTdHZ3lJ?=
 =?utf-8?B?cURJZTRUcitZV1pXUDBuVk1qT3gwaFdmRHVuZlBrYTRnODlIRVQ3VWxya1BI?=
 =?utf-8?B?ZnNCWmw2eVJ0dFVld1JnR1M5WWhaNnVlbWIra1ZaM2hLK0F3UUNRTnBDVGVC?=
 =?utf-8?B?N2tCRitMb1RhVmF2V1pyZVkweXpSRUptUDYvem5qK3dzdXFCS2JibWRuMHZQ?=
 =?utf-8?B?NjUxU1B5WTVoT2pXQ0hQM3E3YmN4Snh6SU1TN0dNUStLQVlBTEVWQ0VZeVZi?=
 =?utf-8?B?UU1NODg2OFFtRnBsamovd2JQZ1hYcXhHZUxRUkY3MTZMSEo3Zy8vaE5MUDRO?=
 =?utf-8?B?dnV5L2s4U0grYmZhTEtTSXU0RHMwMTRMYTdrb1F3UHgzT3lVUmhWMWcycTVJ?=
 =?utf-8?B?N3Y2d0REdXRvc3U0SUN1VURENzJjTElUUmJiL1Vjcm1nczE0emwzRFdqd1Fk?=
 =?utf-8?B?K2grSUFaZGcxQk04ZUN5NzhuRnJ3YVZEV1hBaHd5RjRoNWIyUkg5dWlvemEx?=
 =?utf-8?B?dUd4U1dnQnRoeC9UYXlTSUZONnFmRHVIU0JHakdqSG5ONmM1d2FFVXpmVkVM?=
 =?utf-8?B?dldxSDFNeFB3UDNkN3NLMWhKN3pCT0Y5c29kcjRWT2hmam45ZW5qZWw3cSsz?=
 =?utf-8?B?TUhMNDBWeERRaGhqTisvKzhNMFpBY3lHMm5VdDN0NDJDNzltMk4wN0dBbVBx?=
 =?utf-8?B?R3hNTzJmR08wVjZHZXNmNnpUUHEzbm9qS0dnQnBBdlBqck1VbWg0UHM1OWo3?=
 =?utf-8?B?VnMrQ1RqVFoyUWlNbWhMckdacW9ad1lZRlAwb0Fzb3lTUmpNekk4andPS2dM?=
 =?utf-8?B?dUFzQitSeUdVbkd3am1qU0pyYUV3amhVRzJlL2srKzA1aG5oNzBqRW1pL1Vi?=
 =?utf-8?B?K2RwN2hGYkY5OW1Dem05djhFRUZOcEU5Z2Y1Y2xKakd6VWRNbnJwL0NvU1F5?=
 =?utf-8?B?OUVDUXNpbkxFVEFZdVg4NHZsM1dZREJyZWszOTJaWmptUlV5VWUrZkNEeVlQ?=
 =?utf-8?B?UElKdU9NUTU4cXYyWkc4Nk8yNTZhaUI4VjZOWlJIRk5XelVHWEU2TXFON2Za?=
 =?utf-8?B?MkVLUXJCazNVSGNYeXd4OTdOTUM1R0xMYWtrTkFFSFhuTWJqK3RRbVdwVHhy?=
 =?utf-8?B?eHE5R2xNKzZWTW42OHpkbnFLMEFoUmVuakdlQzV0UkROcGtmUWVlT3RGZSti?=
 =?utf-8?B?US9UcUdSNU1ZWU5hWDVnbTcvYytBMW1CRUlGa0NSSnlUUHR0ZDNPUUhvYWhU?=
 =?utf-8?B?ekc2K1hlL2srNGJmUmpDTGFCZ09QNjlNdSs3Sk16QXBtRVZscU9SMkQwYVFj?=
 =?utf-8?Q?jpDEiUzvzqMfQg6k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aafc81d0-a317-4859-0530-08da2ddee3da
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 15:00:55.6302
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O0btk+47+vGB+JMsTOQfE3OkGRx90JzI/FUQo1aqW0kWQFH065eQaBfp4nlfrVv3cFniPRCHuy8qHLxV1Y9h8+TO+iSqjSlQ0Q4EzCo9aSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5056
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-05-04_04:2022-05-04,2022-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205040095
X-Proofpoint-ORIG-GUID: LEfuFRHfFGY5vhBCvd-V1YSOvAGr-pEn
X-Proofpoint-GUID: LEfuFRHfFGY5vhBCvd-V1YSOvAGr-pEn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/28/22 2:29 AM, Max Gurtovoy wrote:
> The structure iscsi_conn naming is used by the iscsi initiator
> driver. Rename the target conn to iscsit_conn to have more readable
> code.
> 
> Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c       |  64 +++----
>  drivers/infiniband/ulp/isert/ib_isert.h       |   2 +-
>  drivers/target/iscsi/cxgbit/cxgbit.h          |  20 +--
>  drivers/target/iscsi/cxgbit/cxgbit_cm.c       |   8 +-
>  drivers/target/iscsi/cxgbit/cxgbit_ddp.c      |   4 +-
>  drivers/target/iscsi/cxgbit/cxgbit_main.c     |   2 +-
>  drivers/target/iscsi/cxgbit/cxgbit_target.c   |  44 ++---
>  drivers/target/iscsi/iscsi_target.c           | 162 +++++++++---------
>  drivers/target/iscsi/iscsi_target.h           |  16 +-
>  drivers/target/iscsi/iscsi_target_auth.c      |  10 +-
>  drivers/target/iscsi/iscsi_target_auth.h      |   4 +-
>  drivers/target/iscsi/iscsi_target_configfs.c  |   8 +-
>  .../target/iscsi/iscsi_target_datain_values.c |  10 +-
>  drivers/target/iscsi/iscsi_target_erl0.c      |  28 +--
>  drivers/target/iscsi/iscsi_target_erl0.h      |   8 +-
>  drivers/target/iscsi/iscsi_target_erl1.c      |  30 ++--
>  drivers/target/iscsi/iscsi_target_erl1.h      |  14 +-
>  drivers/target/iscsi/iscsi_target_erl2.c      |  10 +-
>  drivers/target/iscsi/iscsi_target_erl2.h      |   8 +-
>  drivers/target/iscsi/iscsi_target_login.c     |  58 +++----
>  drivers/target/iscsi/iscsi_target_login.h     |  22 +--
>  drivers/target/iscsi/iscsi_target_nego.c      |  52 +++---
>  drivers/target/iscsi/iscsi_target_nego.h      |  12 +-
>  .../target/iscsi/iscsi_target_nodeattrib.c    |   2 +-
>  .../target/iscsi/iscsi_target_parameters.c    |   8 +-
>  .../target/iscsi/iscsi_target_parameters.h    |   8 +-
>  .../target/iscsi/iscsi_target_seq_pdu_list.c  |   8 +-
>  drivers/target/iscsi/iscsi_target_tmr.c       |  30 ++--
>  drivers/target/iscsi/iscsi_target_tmr.h       |  10 +-
>  drivers/target/iscsi/iscsi_target_util.c      |  78 ++++-----
>  drivers/target/iscsi/iscsi_target_util.h      |  62 +++----
>  include/target/iscsi/iscsi_target_core.h      |  10 +-
>  include/target/iscsi/iscsi_transport.h        | 100 +++++---

Reviewed-by: Mike Christie <michael.christie@oracle.com>
