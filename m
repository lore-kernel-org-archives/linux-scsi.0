Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A66C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B0E560F44
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 03:44:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbhINDpq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:45:46 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:58726 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239225AbhINDph (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Sep 2021 23:45:37 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18DNXw3W005121;
        Tue, 14 Sep 2021 03:44:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=jfhCI2+ukHsGHRVKYwUgMx4nFE8UWgcZadsEI3DM874=;
 b=Oh0/hJivQGMsR6TN7Ig11ZNMVx1afyOx5TbPNOt6yPMzjr/MyTaJBGX+1BzChViSv11r
 TIHYKAQxMdWZSRFry4ZbzE/v6jRpspqEPXGv7Ea1su9FOJds1HBiMgTTPVBxTl4evuu/
 na+vZaEfG6xd+3i40GsfwvVVI4qjyqSjzCfmTpWwvNbI8Fei1DcXAMckelY6+q8xDhCs
 pYd/ZG4nNMyJz1TWjgcALsUyAyJXRFt4VCxl47Utw7cMUjdvdDM89Agzdi1FfEjPerY6
 qdLyzZ210gLwdKYcbsVncBIUz/2E1zibIUr3duTjmctGxPgx52O3xKVrimSGo3lp/1j+ aw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jfhCI2+ukHsGHRVKYwUgMx4nFE8UWgcZadsEI3DM874=;
 b=bRPidk8/U+H8yAq8aFyNGDT+MY9e3z0VpMDAIB3VCztHwvyNh1/+0GB2PlMgOZwT/uCt
 SrlLazQ/8TDM/WeOVoHSsEVyuFv99TKYvAQ+kBcqZCe5GZ57IFDWJ6+/eggwpeB8xxeW
 s/Eh4QbK6lmYm4ijRuXcsLjKV5xTVMM0yyo5QyXx4VIOGqs9KYKgukWSaerZvtyNPU4c
 aTA8IYIz7lMwpxp7V7vPRWcECrMpc1mNz1tuerZoSbZ5TegsDsNAcDME9Cqnu/gmdlnQ
 L8FC/JlXNx62qjZZ5/qbo8l4ld91tK6Fmpbgx20fTQDxQP5L92XVgp7D+MG7Uyujgv0j YQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b1ka94wut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18E3fQr0109415;
        Tue, 14 Sep 2021 03:44:13 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by userp3020.oracle.com with ESMTP id 3b167rd618-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Sep 2021 03:44:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=irZ9d0/ToYtKuWON9sZpmZ7hDUO71kQ41yDoxuXk8zsUQrgRkP5Rx9OwcAx5Zyy1MVT3XPlZTP07gqjBuadAV4KOkYIfHEZzIbsw32ePKlhBxRwBCezSk83cMAS5/AhSWaPuSB1kcs8q9EvvDXpI5hP2TbO9pkUbCalTP/h0CdqWb2k+KMmV4iiPwEyq/1pJxljoIl+LS5t6Cjb0gDgZiaoTxqcHHh2FQRmnKd+TM/xW1Vk5EOULLxzUTuzoKFyAKJEFtQREEwxV30xDeN3v3OiNwjcnpY0ALqO1MBNUN+MTvRDY33Sr6VnVXv7yiZ4u581AAnafeLdeTyzQdyqQgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jfhCI2+ukHsGHRVKYwUgMx4nFE8UWgcZadsEI3DM874=;
 b=F7TEaPFxtK5IjTFQS+8iw2v9dfl8UbbcrjXvsiAiDNE2gOU1wL+no8W4Nk86EThH6WVO3UurIpcqj4zcnOsgtiJOwwxz21d7ZG8IwaCjMVOuK8Ckhs6Mku0bWkKy2Lolb7wCQ+ecmiIjv4HgPG5ZsGBFE8sMFLlqAhWSt37Xm+UPiUNSMs/6NudbAbIphrIorgK6T3qdMGXto5tijzXx/vbma+K4ylECEgGdwQHolEKpDeZmXFhKOTgF2/SEh/1XZc+5ESaU0uO7QsjJhcmOzJeSL44dpefWdhgfq2CZ2OafEhdjSngu6/fObOijsqJFG14HiR9V2xHYEDP+RtWsSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfhCI2+ukHsGHRVKYwUgMx4nFE8UWgcZadsEI3DM874=;
 b=Fi1dLt0MTq4I1l4B7aV3tfe3F/rr61x+nWBMfKMCj7piTbd4zT05734srgK1GJxMPeYiwztle8D98uN80Fq8H9iSNXiAAXiCf8/IbDEA1r/a6wCkzJ98BbMYH3vE1J6WJED2kc5nyX9KutCbxjYCHBik+oICOQHVAJhPwROSKbM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4502.namprd10.prod.outlook.com (2603:10b6:510:31::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Tue, 14 Sep
 2021 03:44:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Tue, 14 Sep 2021
 03:44:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH] elx: efct: Do not hold lock while calling fc_vport_terminate
Date:   Mon, 13 Sep 2021 23:43:49 -0400
Message-Id: <163159094720.20733.11054870005869547040.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210907165225.10821-1-jsmart2021@gmail.com>
References: <20210907165225.10821-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0401CA0014.namprd04.prod.outlook.com
 (2603:10b6:803:21::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0401CA0014.namprd04.prod.outlook.com (2603:10b6:803:21::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 14 Sep 2021 03:44:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47df5be2-a8fa-40c5-70ff-08d97731ea8d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4502:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB450200F446E130955F77C1138EDA9@PH0PR10MB4502.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvjyR/5WQmkK1aEROj4cY1CNU1cNJfVXts3Ebj2Dv1iEnOgRVEOTKtFg0W8BvbhlR6aTvLkyeImUQhBkzAUioYQGLUxhZpmZarai5Ro1yRbjIi8tu3jCocU0pdJAXymIYNgcT4ePjWGSWkyKbOaXAChF/VcxYUwYhvRhPfy1qtaSF6rE/q7ygOswYZ5AHxzGTDGWilJQQxq7P1QpJC0VvCFASI4cxcZlsT0Yhz681FaGofSLqOu3NFxKjm8J9IDNCwvUm2lXwfSnjwnCPsLtRWgGq5Z/F5ELbzUeBu+3ZbynAQlXYZRd0QLDUdwNmtpnF6myhrR9XVu824j0/eTqAGJZpmG78BNL5IqftD/CdU+/fwmAhB4ue8GvN9IcSnk1SV4nXD+osBFBMRqXYxcc6S8AWkU8cbUnB8jxL1JKc1pQF5D5wFnTV9MCgL9oDmxNAp6LgPSKah0ucpd+Th3laAFnHT8ys2vLAoygT0it2VbApV5V5VOvFX6dOMb807xfcL68tP2BxDIKWwUHgARUtrH2oI5T6IXxkhYJ60BfnoFFeSBzfk2LoWwLf6KTgNh8uxjxAdQo2lMcjrYYfGP389ygDThe5vjJi3ywojgTPGuecAHeIQaUIbv21gY66C5GgkF5YWaWm817ec3CVpp3oK9+x5EXu0zky4D0+97KxdnSCbeoa44AHc971RVtNn8VE83kH5bt6njhdCWEN7JIJX/2DTluQStmHxCW/AhaOIR4YGdjGIYjk4Fy8qpwCnSk+TZsdODQyna4I+KW0awmGCfpdyRg/MboQ6293v3w59E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(316002)(86362001)(38100700002)(2906002)(956004)(8676002)(36756003)(54906003)(8936002)(66556008)(66476007)(478600001)(38350700002)(66946007)(6666004)(83380400001)(6486002)(2616005)(26005)(4744005)(4326008)(186003)(7696005)(52116002)(103116003)(5660300002)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkNXVDExdkhCMVM0MVRnRStLTm10SkJiekJabVVpNGVBejdkS09jZ2g2a3Qv?=
 =?utf-8?B?ZUtZeTdyZk9YRk5XenlhcHlLbzFRQ0d5ZUE0RjhDWmlqYTZ2NnhqSXdRY0FR?=
 =?utf-8?B?Yit4NWRKbXpnRDNaZUNTOFNKZEVsVTc3QVgrVHB1dFdueVpWdVJTZk9iTE9D?=
 =?utf-8?B?TStiV29US3ZLRjVXbVV3bE9neWJUbjN2T05WRXhXSGZUTG9NbkM0dE5UUkZK?=
 =?utf-8?B?Y1dsOE9MNzk5N0hLL1RkRU52ZCtnN2czcmdMcmZvL1AzRjl1RjVmSktEUm9z?=
 =?utf-8?B?WUNGT2xQNDZEczBtNldPZG51YnlKdkRvUWZWeXhXaUJDUTBENWJjbU80NU1F?=
 =?utf-8?B?WGJPc0JFRmVqaVp3M1lrN1doQ3ZUSlJNNUJpZ2RLSTUrSmNIcTh3TExhakNh?=
 =?utf-8?B?YXJteFJhUUtKbXpyOUVjbG9CRkVpcHpEV0tKQi93cDNtNFFvSnI3YWVCQmVt?=
 =?utf-8?B?bStzY3VOck1PNjY3dERwZTNza29PTlg1WXMwVzByalkrNE94RG0zdE8rVXJi?=
 =?utf-8?B?aTRSdHozRm5JWlFpTVJZbTl3K0dnM3VPcHl6NE5CRXpzN1lzWG54Mkd6dEp3?=
 =?utf-8?B?UnZ3RktqeUVvM1lFUURpWXZKb2grWlRuNldNcDRpc0E3My9QTVhjQm9lcElh?=
 =?utf-8?B?aG5iUnI2akRlSUpFRFZVa1BiNWZqY2JlQ3QrMEwwRzFrMXpseEFrVDAwMDdR?=
 =?utf-8?B?QXpSQ0VJSlZmcUtiWnh2cEpJMTMvTFN3WVBQaFBhYSsyT2EvQWZDaWppcFdu?=
 =?utf-8?B?b2JKbXBBbTVEaTc2am91bENtTlBWTGZ3QjZ6bmx1akRKWHZqRHBabTR0YUwr?=
 =?utf-8?B?OFN4Zi9Nb25yaWROS2ltYWgvdEYyWVUwZVQ4Ni8wc0FvV1Y3RjhyS0ZYNUds?=
 =?utf-8?B?WmxEUXVDNDYySXBFbVpyN2ZjMHR4dno0bDBWNmpVcHVPbzRwRTFyM0Z1NXVI?=
 =?utf-8?B?UnR4eU1RMVducHdSazlyNWgzY1NUL3g2YlJhMnFBbUVSdkI2c3RLM2FmeDJJ?=
 =?utf-8?B?NUdjTklrLzd2RkxWRU1TcGM3MUgwM1UrcmpleXRpdUF0Y1ZkTHBPUzhDMHlD?=
 =?utf-8?B?TkJpMWRqYzE4VE9Fdk1vNzl5ZjZ1S0tLemFWM2NrOVdORi9yM1FoQUZLYmt5?=
 =?utf-8?B?UGpreHU1N2ZLcGdweng0NTF3VlV3TkhqOUJtZFZDRzl4UXozdmxjZ0pmYmpr?=
 =?utf-8?B?aVNIOGhvZnhIOVMzUkp5RGtZUFgxRjJKRUIvL2ROYllPNkQxZjFGdmZxTEY3?=
 =?utf-8?B?Sk5UaW9EUUU1bEV1dHN0d3FRWlNTNmk2d2V4T3EwUkdkVGlqR2JnRE1ob1Z0?=
 =?utf-8?B?V2tGMFlJdE8wdHMzVnlsWlFQQU5udmVTS2FwY0grQjRBNWRjSEZ3dWhiVTIr?=
 =?utf-8?B?dTk3SXY2d2pNY3hHUk5rcERqV3hMMWhNMkFncFdBeTQxKzBOR2t1L2JYUzlu?=
 =?utf-8?B?cWU1eWJFMGNKK29mMkY1TlhBYUlkTWxFdG5sSDRMNmlnNW1pRmNhbXM0aWlY?=
 =?utf-8?B?OHZDV0o2a2xpa2tKaGpSWE9jTlNHRytOK05yNHRaWWNzMVIvZ3BmK1VaR1dk?=
 =?utf-8?B?eUVua1JMUWdValFLQnM4NmZVZUcxOTJuQXE2QktqNktSTjNzSW45ME01SCsv?=
 =?utf-8?B?L2ltdlRialpmVmtka2RBdllxTWh1eDJheW1tSGxkR2h5WmRXUkY0UHB2NmVY?=
 =?utf-8?B?NDVXdW42QVJCR09yYzRGUzZJY2lzRzRQZDRJZUpMVktQWEdqVmtDMUpzSDhV?=
 =?utf-8?Q?t1INaxtnReC22h7AFz5/vjBh4Ulg3oAvnKHwf+C?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47df5be2-a8fa-40c5-70ff-08d97731ea8d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2021 03:44:12.3638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMm5hthpzKdlLjqOnImQJmszyF7V8KNTsVUA5couuD4za/4HduRW/BVtrVw4JoLYgBnv1T5fRHtyB+WE329RREOZ5pgeBogRowDOS1mqFKY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4502
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10106 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=810 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109140019
X-Proofpoint-GUID: XQMjXo9OJ4kqTPxrQRYQg06B-kBdIaoz
X-Proofpoint-ORIG-GUID: XQMjXo9OJ4kqTPxrQRYQg06B-kBdIaoz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 7 Sep 2021 09:52:25 -0700, James Smart wrote:

> Smatch checker reported the following error:
>   drivers/base/power/sysfs.c:833 dpm_sysfs_remove()
>   warn: sleeping in atomic context
> 
> With a calling sequence of:
> efct_lio_npiv_drop_nport() <- disables preempt
> -> fc_vport_terminate()
>    -> device_del()
>       -> dpm_sysfs_remove()
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/1] elx: efct: Do not hold lock while calling fc_vport_terminate
      https://git.kernel.org/mkp/scsi/c/450907424d9e

-- 
Martin K. Petersen	Oracle Linux Engineering
