Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EC8C25B50
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 02:41:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbjAXCl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Jan 2023 21:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjAXClQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jan 2023 21:41:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE9A3B64C;
        Mon, 23 Jan 2023 18:40:47 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30O04a0P021868;
        Tue, 24 Jan 2023 02:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EGiSlVc2SgJNPs7MMKfIBi66a491a3Y6BB5Z2V+Iddk=;
 b=ou0bglAHyy4G3k7EJ8+tOY5/CaB4UsDfbNfugUjkmchghA7kg+I0Z7hWeF2tdJD06qAM
 ZANfEtWiO15ZDfhW2iHlPD0ChlEUgU2ivSTX6MYf2MP3t0cfsv3PB6r/e3g6S2WWu9ev
 zb4kv/F0ONczK8ki41M+FUE4GiRTCDG5GaYsrK3H4whpdS0fN0uzZKNOfLkrZQwdgOzd
 eUOxt6r/JWiSjrYwcZ2wRBPDXsvBlvMLAWPz56N7Cs+lvbLXY9dYU4lfeayQD7vw9yNN
 wQA4waKTXLsJKAA7oCIGlLzxijE8k6lY9z1ruMbEIl88CBaCqnZtuQtJUoRtFcCC5I1B aw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n88ktva3q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 02:40:09 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30O20AgL001102;
        Tue, 24 Jan 2023 02:40:07 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gancy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 02:40:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3qe1sbBuHJW6yF2cI6QSOm8d1Epu5wMxlH72AIwJLvvbcBjOlLIsnSAzbLvu9dUeOMld1Vlfpk0+cEo5jAvPGdst6XRzx0JCQKgIMgaZ39NkjMapQkAMklXP2NpD3YZd99FwbMD1v+RH8i1K1fu2ZftH/ySteLqDispGgs3LObbt3Q5OeIxgntm59GxQbSTABcA7VVkNpjNkp1B4a7KzSEK5McDhOnH36ChR47/LAtHGZmXkBdkU7sIN4WrnpDAEYvla3heEOU9dP9jlVz5DyTcZ5dejqCX38tlYymkNmkZbdw4YA1+qswRJH4lCJ7t/juWoTQ7thCjUlpg3xDQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EGiSlVc2SgJNPs7MMKfIBi66a491a3Y6BB5Z2V+Iddk=;
 b=ZEJ4C357ITd6uzqhpjygOKNpFPfjmMq+TW4RJjlhsDuMIZUVGXpPj2+1OgG6WR5Wz8BkxVdobZ+a4nU6Z5uLNAXaAed7WI82k8JFIfqN7sXG/ojqiSdWcJn7LfNF0Av0LqqvLK2i5po3P9AROvP4qQC9Lsxm6eZT2B3i1Mzm+LPK54IOZ7FtM5MCN7gwNADuNnbJzDhFbBztoFkisaKOxJQCZJXMBFbbVM8WZ1sBdyJqHFQBZlunrlqfa2HftO06nVzm4h0EigYDhO2Hp61EKvWYqZLRz4X+uKVp9M9e21eCU/H2oFv+kXi4se2gb/vzr01Z7AA5vd1OZub1794NrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EGiSlVc2SgJNPs7MMKfIBi66a491a3Y6BB5Z2V+Iddk=;
 b=yf+ZJ9yk2CBxz6QoEYYyGxQ5xQs+7Ane6ye/IzMXO97FXcErPzTjqQpznUA7xeATDo9/ubzdfxn0fLfwXwYshz5cUxzX+of3FDz3KvYUO3fm3CQUco5lyphUlw9jl8YLALOag2N/mzZZqSDUyuzWX1w8Pck+ZxHYvQKy6qpu5Ys=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CY5PR10MB6023.namprd10.prod.outlook.com (2603:10b6:930:3d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17; Tue, 24 Jan 2023 02:40:05 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::c888:aca:1eb9:ca4f%5]) with mapi id 15.20.6043.016; Tue, 24 Jan 2023
 02:40:05 +0000
Message-ID: <e78f32d1-6095-6e31-81ed-898890641677@oracle.com>
Date:   Mon, 23 Jan 2023 20:40:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v2 09/13] scsi: target: iscsit: Fix isert disconnect
 handling during login
Content-Language: en-US
To:     Sagi Grimberg <sagi@grimberg.me>,
        Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        mgurtovoy@nvidia.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230112030832.110143-1-michael.christie@oracle.com>
 <20230112030832.110143-10-michael.christie@oracle.com>
 <20230113140816.GA31614@yadro.com>
 <e21571bf-2244-7b12-9765-f3ebe3a024ad@oracle.com>
 <d2629836-78f0-ddc6-c654-80a14d16eec1@grimberg.me>
From:   michael.christie@oracle.com
In-Reply-To: <d2629836-78f0-ddc6-c654-80a14d16eec1@grimberg.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:5:3b9::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CY5PR10MB6023:EE_
X-MS-Office365-Filtering-Correlation-Id: 49c56716-cbe8-4800-b64b-08dafdb44cf7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pAy+QSmnSP4fwaTDsLt7myT3qdhdbYiudtdJM9fIMQGlR6hph7m8S/KbgQS+7bPFrpf2uNDjsJKiWBoahR5RY5ceaeZ5j4sYQnEbRqr56glTvkwaEIo782Hmoor7/ZlkJHl1wOPoQyKJOrYFriepERxlLokfoaUtkI/2hc0CyTPq8JrgLYn0SmYIXKaORC7tlXjAm4b5S3GMjXkxQENaatrtv0CQ/zr+16XgXvOtIIeYTYn3OnaZWoyfj6K+X2Bv0ZzIaC5BgKgkbMua+WillE1RtjKOF/L/wq3hVYTGKZe2bh17AUarSE+3wg5niXLzSc74WW/vNQIB1QchZ/o2iCzdFaN8GzuQAijXoispGY/s1DuwEgWMbBMUNInFbbdHCdRt8OWHSnptm8JOfHoTFsMf5mqj5IgTW+SX2KKnjPFBo33GPSzvMywudg56iaF3RJzFFb1sJz54UUL3gWzcZEDOgx7XnLrTMgqtzMxhlqzTDgRt9jo8JADiSQBFpLGYvsDSAFwh27FI8JLOgUm/SlOZphh9dkh1jxUfG3Z+XfEz9HjJn3XUcuZ7pVVqjfGaiWzUY23l2s0XA5m3QMTVVca1B7Bb7QIL+NlfmbYAOZSE7yUPPYCyq5U9O0t4r6VnktJ7Phe6Z6SXgWHAFAzTOduiKCWVtK4mUznrJwp79auopo+bPQJ3rkhI6O5EFee2VI7m3twDECIvizORiXUvRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39860400002)(346002)(366004)(136003)(451199015)(6486002)(5660300002)(2906002)(26005)(478600001)(186003)(6506007)(6512007)(31686004)(53546011)(9686003)(2616005)(110136005)(316002)(4326008)(66476007)(8676002)(66556008)(36756003)(66946007)(8936002)(86362001)(41300700001)(83380400001)(31696002)(38100700002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dzBwei9mODdFUTQ1alhTNTBpNEIwclJYaVBKS3BsdE9NMGJGZFRQajVZUVQ4?=
 =?utf-8?B?Ui9xQUJEaU9nc1hJK3QzMkdVa0FSYzEzbEdDK3pudUFnelRPS1NVSG10OW5R?=
 =?utf-8?B?YVlZMGpLZXNKQUhsTFNub3ROSTVFRXlFYmRhSGwwYWk0UXNDb2paSllIUG84?=
 =?utf-8?B?bVJvek9hRzJBUytVTkdDOWxta2NyUzkxNUlxNFA3RENXMlRFUWVkNjViWERu?=
 =?utf-8?B?Zk9tYklGMFF1ejZGVlY0RjJJTUc0WVZ4SUVqOGVXV2p6ZTVkeDZWSVVKR1gz?=
 =?utf-8?B?ZURsbHdFYzdBQXQwYlA0Z0t6clQxKzRtU1BNSGk1MDZwb0lNQVZTSlh6d1cw?=
 =?utf-8?B?a29DRHJZZ05TOU5hMEl4U0N2dWZFcXZSQVFJeGM0U2VGOGI3dlhONyswbWp4?=
 =?utf-8?B?WnRobU8rZVFkTzd6ZXpqMWp5eU82RCthS1cyZ2sxZm9CMngycFhpbnpJOXQy?=
 =?utf-8?B?NmRIUkZBZjJoZWMwTTRNb3hqZjltUlAvY0NOTG9OZmkzTFY2ZnRZZU5xMSs5?=
 =?utf-8?B?UGJPWlUwTzA3ZGJVZlpITERiQTcxTGIxUjdORWNlVE9MYzRpeDQrbnpMMk0z?=
 =?utf-8?B?dHhDN2lGZ1ZFSG5RUm0waUZvSGgxclhQRkZGRlVVbUY1cGNEL3o1UlBUTXdh?=
 =?utf-8?B?Ui9MWno4WXFpM1FkMFNrdUZ0bWdUZzd2RzdFaWw5byswV0pPMXdVakh5QU1Z?=
 =?utf-8?B?Ynd3Y3RrYmwzdWhhRTNIQU5oNVF1NG9EVEJQRytiVTFDYXFzUEV2V0pHTS9h?=
 =?utf-8?B?RlNYRUtPemQzejg0cmN2aUdyTGVSSytXZkc4VzJQMVRLa0RLUXF5RFltZCtm?=
 =?utf-8?B?N1R5OUJyMnBuTEZkM1RMQ2E3RjBhSkU5Z1drWEtlelorSExud0RxVzFCUjJM?=
 =?utf-8?B?RngyWXBoK3MySjJJcklhWlV6c0tIWEVGL2dMbitlbUt3NDZLNVU5OUtEU1VN?=
 =?utf-8?B?U0wwTFFPY0FhSDhBUnVHL0VsWGF0QVVKNFZOK293N2FWTW16WlQ1UWtFRmhq?=
 =?utf-8?B?QjI4OWxaZU5NVUswVjJmaGRxWTg1MTdsZXViR2w3emFHb1VEY2dDeHpyZzlh?=
 =?utf-8?B?azRBdVFYTGZpUzQzZWNObzEvdEdVOHpYVUcrd0tJcHQ4R1ZaMUUrWGVPdWFI?=
 =?utf-8?B?NHRoR2JXQ0RMcDB3bnQyd3JySE5lQ0ZUYjlhUXpDeFNzZ3hmcnZwc0s5K0lC?=
 =?utf-8?B?N2xzcE5sS3lTZ1J1cWpMR1BBS1FEc3YvMkNyQVJsSzJGOWEyTkdIM2dBaDhu?=
 =?utf-8?B?MlBaRk5heTJ5RE1ONitxbHFnZlI3Y0FnUnhTQU9LMXdPQlJMekQxaXltdFRS?=
 =?utf-8?B?NHJYNXhDL2czUXVibEVSelZ2OVFLbTBJeVNhUnRnMFNZNEVRYUIwb2txZmdF?=
 =?utf-8?B?YjBsUGVqRkY3eGJmOXlkc1hMTHBDSkVrN0VTL2ZCQzh6NXpwa2VHU1FsZUtV?=
 =?utf-8?B?bkVLZ0xvY212clUvdXlXekY0QUprd0txbEFNTDFPV2dOY1dYb2ZCMTJQWnJH?=
 =?utf-8?B?OUQ4SENUL29Pb3FSS1ljYWg0bE10WXB0STNkbFZzSml4bk5wSUlBbk5mQmN4?=
 =?utf-8?B?UEtVek8zVHpmYXpjM3dSN2xHSXc4M0llYTlyQ3BzQlNyelJvUTRpVFpQRGpO?=
 =?utf-8?B?N0xxZ0tsMS8xUU5CLzFPYnhoTk9YQ2hvYW5LS1JjaW1Ib1pqeXRzZ3I4aFRa?=
 =?utf-8?B?bHdYQU80ZzZwOUpnK29rMkUrOWV2OS9vOStLdVJFK2t1R2JZajY4TlU5YjdW?=
 =?utf-8?B?ellaeFBudzBIamhWd2dQUFdqVU80eDhDeGpMTU5YMk92RmtNYnIybmxUZ0do?=
 =?utf-8?B?SGl0c0x4ZFAyc3gzNHNPSkhZV0tvbXdvbFNNdlVHcjcyUHA4UThZSjdvT1lq?=
 =?utf-8?B?SG4xNHc3OHg2NEVEcFdZR1B1Rnk5NEJIeFE1c0hMVXlXMmExcEVTYnhFMjVw?=
 =?utf-8?B?bStkWnNIdXVCUTAwTnh5MC9mZUU1WGJKd2tFMXlVaDYvY1FnKy9wTEFuMmRt?=
 =?utf-8?B?NWdqbGlTZDZNNVYzc3ZRM3ZBekVtYXBjbnRJM2ZLZytjRWJZelJ0bGI3SVMw?=
 =?utf-8?B?Rm1ReDZoRnVjZkpzWThlbnFJamxuZVRzeFVTWGc5MGhVVW5GTUxQcXN5Vmsx?=
 =?utf-8?B?VllGaU5zMENEV1V1Q0xsQW5TNjRmcEhhNXBQZFluZzNmWjZtUi9XZUNObmtk?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: gLr+BPbv6FYID58brPgf0mbzjfBrfIGn/SaAzaGDopQIK4W53PBxIBtHUivJYH5O+6SO6g/TJm20jDdIk43ts8TPo+BQweGT241Ph2Z/ypWl4tu3FCjePGtph6MuJRboS/kSTgr+35cu4VkcTbTZzcUGa1yxX0O0K4lUOevop5hT9Pe9aW5tKA1hTCt4w6GOSNsvE76voZZ5kfWnNJ4yAeH1vIV2ldxLsCHsyeGEyuqie6oRDli/bIsjyYRpKBMBeZhtnS3NjbDnUuGbDybHznh3NT6U8Lctgm/d3qgaUWsM93r/myG3DSKmISB6y+ShWimRGQwjg3RPeR6m0Dn4YWMpkBC+LgWDwYHzdG+cKe17M7ljaM9BogSkMy17+xAZq0k93SOqHkqC5tOMizyhOFsUwXRkSoSXxDkH6rDFaefz0Q4CKsMmaOkHgCS32QJzos5dCDDYY34h/ZLRhlv7M59M137R1pb0YoxkEBkhhxWu50SeEbl3F2W8Z+pIMgz/ZAnmx1IuW2dmtkE7+n/35es23mEWVstIXOqwKIFlumJNQce2tWwHTIMgDrrwrco99gp6znbdxdL8wfI56TY0V1PtHdp4mk1mXuktS/V8M4KrAeU4nAOVoylveN+p2GD5fW/cQWeiY3gpmXL1z3GESacGbi+yYnuoBuhlivn4bszsoVu2dQ9Pws428iLUxvpcOCs6SB5Iz8n8m05735meRTpxfmkNTT/A6BeYjd24Gc4DPJQYpDqMenI/Wn9ZVgrX8Q2dkgLzxFHEVSgoq/TDCv+Vd8WJ7tEFb8kMtCk6XYbndyZ42VnQ0taT0EF5mVHYjnI5CpiU3d9+2e7RNngBfAn2/qSWTGs3tIrrou24uhMP7LMt68WKVxHul7ZoB48T
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c56716-cbe8-4800-b64b-08dafdb44cf7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 02:40:05.7026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kWQYqXhAqUs70QJvxYCLU1tfKGIKBvUspV32ZpI3wDvjw/+bwgxJ10hA/H+iTu6jAKHRh75v6Vpin+INOOWZWEmCMfC5IiRhJLFFfRAjyjY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6023
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240021
X-Proofpoint-GUID: dvDD87BLTmvlvx-jsIkoaaTN_pJpq8Br
X-Proofpoint-ORIG-GUID: dvDD87BLTmvlvx-jsIkoaaTN_pJpq8Br
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/23/23 3:53 AM, Sagi Grimberg wrote:
> 
> 
> On 1/18/23 04:14, Mike Christie wrote:
>> On 1/13/23 08:08, Dmitry Bogdanov wrote:
>>> On Wed, Jan 11, 2023 at 09:08:28PM -0600, Mike Christie wrote:
>>>>
>>>> If we get a disconnect event while logging in we can end up in a state
>>>> where will never be able to relogin. This happens when:
>>>>
>>>> 1. login thread has put us into TARG_CONN_STATE_IN_LOGIN
>>>> 2. isert then does
>>>>
>>>> isert_disconnected_handler -> iscsit_cause_connection_reinstatement
>>>>
>>>> which sets the conn connection_reinstatement flag. Nothing else happens
>>>> because we are only in IN_LOGIN. The tx/rx threads are not running yet
>>>> so we can't start recovery from those contexts at this time.
>>>>
>>>> 3. The login thread finishes processing the login pdu and thinks login is
>>>> done. It sets us into TARG_CONN_STATE_LOGGED_IN/TARG_SESS_STATE_LOGGED_IN.
>>>> This starts the rx/tx threads.
>>>>
>>>> 4. The initiator thought it disconnected the connection at 2, and has
>>>> since sent a new connect which is now handled. This leads us to eventually
>>>> run:
>>>>
>>>> iscsi_check_for_session_reinstatement-> iscsit_stop_session ->
>>>> iscsit_cause_connection_reinstatement
>>>>
>>>> iscsit_stop_session sees the old conn and does
>>>> iscsit_cause_connection_reinstatement which sees connection_reinstatement
>>>> is set so it just returns instead of trying to kill the tx/rx threads
>>>> which would have caused recovery to start.
>>>>
>>>> 5. iscsit_stop_session then waits on session_wait_comp which will never
>>>> happen since we didn't kill the tx/rx threads.
>>>>
>>>> This has the iscsit login code check if a fabric driver ran
>>>> iscsit_cause_connection_reinstatement during the login process similar
>>>> to how we check for the sk state for tcp based iscsit. This will prevent
>>>> us from getting into 3 and creating a ghost session.
>>>>
>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>> ---
>>>>   drivers/target/iscsi/iscsi_target_nego.c | 10 ++++++++++
>>>>   1 file changed, 10 insertions(+)
>>>>
>>>> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
>>>> index ff49c8f3fe24..2dd81752d4c9 100644
>>>> --- a/drivers/target/iscsi/iscsi_target_nego.c
>>>> +++ b/drivers/target/iscsi/iscsi_target_nego.c
>>>> @@ -350,6 +350,16 @@ static int iscsi_target_do_tx_login_io(struct iscsit_conn *conn, struct iscsi_lo
>>>>                                              ISCSI_LOGIN_STATUS_NO_RESOURCES);
>>>>                          return -1;
>>>>                  }
>>>> +
>>>> +               /*
>>>> +                * isert doesn't know the iscsit state and uses
>>>> +                * iscsit_cause_connection_reinstatement as a generic error
>>>> +                * notification system. It may call it before we are in FFP.
>>>> +                * Handle this now in case it signaled a failure before the
>>>> +                * rx/tx threads were up and could start recovery.
>>>> +                */
>>>> +               if (atomic_read(&conn->connection_reinstatement))
>>>> +                       goto err;
>>>
>>> Why only for login->login_complete case? In other case the session will
>>> not hang? Will it be droppped on login timeout or something else?
>>
>> It will not hang. If you hit an error with isert before we think we can go into
>> FFP then the login timeout currently cleans up the conn and session.
>>
>>>
>>> May be the root cause is point 2 itself - calling iscsit_cause_connection_reinstatement
>>> in not ISER_CONN_FULL_FEATURE state where there are no TX_RX threads?
>>> I mean that was a misuse of iscsit_cause_connection_reinstatement?
>>
>> Let me drop this patch for now. After writing the response above about normally it just
>> times out, and thinking about your question here I think to really fix this we want to
>> fully integrate isert login into iscsit.
>>
>> The root problem is that isert login is not integrated into iscsit, so there is really
>> no error handling. iscsit_cause_connection_reinstatement was supposed to do it, but it
>> doesn't do anything.
>>
>> So we need to separate the LOGIN_FLAGS_CLOSED tests and setting from the iscsi_target_sk*
>> code. Add a helper to set that bit and do some state checks, and make the checks generic
>> in the login code (not tied to having a socket). Convert iscsit and isert to use the new
>> helper. Then handle the LOGIN_FLAGS_READ_ACTIVE/LOGIN_FLAGS_WRITE_ACTIVE and login_work
>> stuff. Then review cxgb?
>>
>> I'll do that later after fixing the command cleanup stuff in this patchsdet and the
>> other patchsets I have outstanding.
> 
> Perhaps the fix is as simple as checking the iscsi state to be also full-featured and if not, do a simple error handling within
> iser_disconnected_handler?

Yeah that's what I'm thinking above. The catch was what is the simple error handler going to be.

For iscsit tcp it mostly just sets LOGIN_FLAGS_CLOSED to signal the failure. So I was saying
above if we could just expose that to isert, then all it has to do is call some helper iscsit
helper:

isert_disconnected_handler
...
        case ISER_CONN_BOUND:
		iscsit_login_failed();
		break;
	case ISER_CONN_FULL_FEATURE
		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);

*I think isert_login_send_done would also need a change.

The iscsit code then would work similarly for both isert and iscsit tcp. There's then just
cxgb which I think just times out like isert.

The other option is for the simple case is just let it timeout like cxgb. And for isert
just do nothing:

        case ISER_CONN_BOUND:
		isert_err("Failure on unbound connection. Timing out login\n");
		break;
	case ISER_CONN_FULL_FEATURE
		iscsit_cause_connection_reinstatement(isert_conn->conn, 0);
		break;
