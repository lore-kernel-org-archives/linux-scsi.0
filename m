Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9D21C433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:55:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C45861955
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhC3DzL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60546 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhC3DzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jaCn141824;
        Tue, 30 Mar 2021 03:54:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=vJAUd6F2cUXK2l8JI84krT+klrt8MXGdrP+BBtt/hXw=;
 b=PxZwshkdQRLY1hTv/ecMcBEkLrbgcsGF2OiOfaON02FwayzJ2ew81I4EcoPj/K7ejO5q
 MecqpMs4B1oJHOzfHgrXPzHKAl6KySMCSzGNelEW4M0U2ijxo7z3kFWp0ibnQf6tPIjo
 PmtPvOALEtOkyTUOnAgZlHcbUQDsqyTczenyn3su4FkKT2TtPeyvDfqNQyK3001X4Zw6
 QEyz08bS8QLZtydDhdaMR4ZD3CaYlNOpPnAqi4mN4Tn0X+2YjV9hnw6tP7Q3ywzrghBt
 KzlLcJe8PPg4/ZUKPKnGvZFdppXoA6PezPe8BCNVk99FQTxDcb38dPug7GgTpHVgPVTe Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37hv4r5k30-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3ijJW193039;
        Tue, 30 Mar 2021 03:54:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3020.oracle.com with ESMTP id 37jekxyv1s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoLUUYqUxV9jwU2WKoR7eahvxhhmuz1uW3QiJk+5ewHlgPzHMQun/eTtsxEpi4tC7M6WS4JSvbYWp2tHoQ89f1YL8nC+tTKAfQ/Af2YALNf2UDBhGR4xtuOy1jR7mjhShw3OnuH3Zdp33pwhmACnnAr1MiIuDkOV9wN4DgDo3Y/as3z2bzaVm+LE7uW7uWvDA1L8fKQcuE2XIwclonVPVDYGfOFyBfkXCDjGlUYwRbd2R9+bbSaVFfxXP46dW+qcQRboDF4A+Ph4z/0dsGTdMlln7hD2KCliDFgiagRSyuCrQ9eIHg40pA9ld7F0GE8S6TKJRiSoS4STloGRyP1XMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJAUd6F2cUXK2l8JI84krT+klrt8MXGdrP+BBtt/hXw=;
 b=BKoGOFqyEGem/4JVdlIBzPDnsxk0EwTi1LAJz+IDGwDh5p7CN9ZgtYktmLH7bLB2ZqUrcThR2r0U4GbXwfh2YeY8qQZ5WQHcx1T4g6UC7R6O+xYkEaBSO9G62GqTydTkubtAA6WaSmproF4MxZ/CuKgpq3BwtlDBA8eUotsJ2XJZitMzixihwjgesHciIHhsbdsCA0MKz+CfFbwYrGuuoGFIgpEJhV1ZMLfP9SRQbhmdwzh99IQtFaXfx14dWK9nEZMDvAr9hTuD12T6QdcqUgzOhp447KncZ/kdgQSv3gNT1I1DeeNhPZ7byrmOUyEpzTZTTJ2gz0t9837DF+qBRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vJAUd6F2cUXK2l8JI84krT+klrt8MXGdrP+BBtt/hXw=;
 b=G2Gp7n50VZcaVFSrFk8UAlV/MyzrRJNRfKRZQ0ri6FBHlSHN7/AJfFXIjhCiMVd3bUuiCTfDPICoeC3x2fK+AII394366dO03PxBUzft3LmJZKoXw9Jx0flxeKyo1wXrljZNdm9ontRVgAJ9eCgqoD9B3ShERHTl4eYdhUzXAN0=
Authentication-Results: linux.vnet.ibm.com; dkim=none (message not signed)
 header.d=none;linux.vnet.ibm.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:54:56 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:54:56 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/7] qla2xxx patches for kernel v5.12 and v5.13
Date:   Mon, 29 Mar 2021 23:54:32 -0400
Message-Id: <161707636878.29267.13485752242302529212.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210320232359.941-1-bvanassche@acm.org>
References: <20210320232359.941-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:54:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95667dd4-3afc-45e4-6dea-08d8f32f94c8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758D04F8B1977AB306A6D598E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uYLucbC6GCnCK5Nk4+kH1V4uXaqHPgEgPEgaMfAsv8b62Ir7IY215AKuFDx4la4r2HbppRum2qvlG5877gY0wcSOlvuT5aQyjmyAwEbf2lxgP7o9AOg9+4PZ643cG59fZylSLVaPCuaNcguSXe3ZzvYrYNjwE8Wex5MPY2clK1eQ+Aizfr8B+oeIjijZy5+gs7aV3WuG8WdfWNq37UymEuOHte3S1bVsfHjAPEfiYcdufu1tXWzNSA/nQtXFSAUmAlwFh3N4wSAtFpWTR3wiNOFSIsPZvyfLp/hGpoCc38TRyMjye+xUgUgN8EujliTK4LWs0VFdn+aB3BfLUukdw8ZODGFYx5Mu1Nyj8TuOT8DAjv1Bs1bdLeePSOpx7PS4j8pejQWPqwchfuQLKwaYVy4N6HPv7QtxCs6BOBRjVwlnyYJ5yDVcNAJxq00w4jD8hnoQy+jT+BbNxfVVJAs1ruQ6kBaB9HGqO3o4Qsy744jLLoOpFaKBP3zeGZyhYAgiZTIZV63LOw0gNwsKVDXoo+l+nSsgR8SM6qF7aijEzrfW9/48VJ+naWHODZiLoip5O5pc8TlPQZAo+qHKLHh6fKHT5LahKfuoPYo+WEn0jrg7UT/Mqfa5TYpclcs69olueoCfU+2TCaAeXEzZ149tYtRHPPGeI26Gy/nWz6IOE/X9vor0RgjSCyXKbkWzr9G5A7MtFP5+rK37RgNwz+pO7idW0WrlpI1KgSIC33x+xiY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(8936002)(4744005)(956004)(6486002)(110136005)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cldZRWgxLzFncnF3UkpJaVRIRFJoWWJldXhNc0FXV3V3WlNpMUV3R0FNNlV6?=
 =?utf-8?B?dE0ya2tQZTlZcUFDa25HZk1ULzdOcU1TM3ZkRzZvOVdSWHFrNHdPZHlYUWN1?=
 =?utf-8?B?SkxXbXZWUkNId3YxaGVFSnZLVG9EbmJlU2cwWE92M0tvaWY2Z0tkVjNtQW9M?=
 =?utf-8?B?Y2p6L3NkaGd1QWgyOHo0ZlNreGY3czJ3V05uOWRJc0JJUUdDeU5TVGp0R256?=
 =?utf-8?B?T2hlSXZZTGtwT1BlYUQyRkpwTkVXcFpoWUh4S0M0RDBPeUpNdDlLeXJSQ3Bh?=
 =?utf-8?B?TDVIZm5ZOVpPYmZWdUVaZFVteGwwY2NuS0pjS2VhSUgxVXd5RG1hMWJnNnVC?=
 =?utf-8?B?eFphZk43OEdFUnd6TnF1OWZvaHVERXEvRDRXQlJmTW5VYVJiYlNYUFg2OXVi?=
 =?utf-8?B?bitURDQxWFNOcFE2ZGZqZ1RyeDJNcnlta05VVWdTLzZWOHM1NEs3SkV2SjdX?=
 =?utf-8?B?UXNuM091NXI2WmxUc0dyWjN5VFoyVmdTekdzY2REeVVsTmV2N0VOa1AvZ01a?=
 =?utf-8?B?UXRLUlc3Z21oSWMzSjJ4VFY4cVlMMnBLbGhtejd2b1dTQUdTMTBtNmJOZVFm?=
 =?utf-8?B?ZUJCZmk5cXo4Q1NzaXBXb3VmVUVtODJOY0huZlZLYnBSU1V4MGt2SlpuOHZW?=
 =?utf-8?B?YjhtUWFTRlNNU2tzOTQ0c29IemVndmY1UVF1Ymd0eFhNT1JXSjBtSi8xcjRJ?=
 =?utf-8?B?YXFDMFl0N3BuYThoRldBZTJBMU5nU3RpVGJCSkgya3pHUTVPcDMyUEZiS3Ni?=
 =?utf-8?B?QlNzZE9SQ0ZOQ01rcUpRd3dlUnUyQ3VBMmluNHhoSEZkM0xHdUJJTFBKL0VE?=
 =?utf-8?B?akx5WEZaazBNN3hSZGJDaDdjTGdJd29qc01LS2JwcnY4QWxwblJYOHIvelBU?=
 =?utf-8?B?cXN6ajBESUFKTE8wSGM0UGVFYkYwMnZsb3dJeFpKdEdoYitQZ2dkcHFDTkRO?=
 =?utf-8?B?aFlSQmJYNGNLN1IveStGUjJVSk5qS3JyTkZkZkRPaHhlNHVucGJvbXFrV3Zq?=
 =?utf-8?B?S2NyT244Wkk2ZFNsc3I3YUltOHRiNDNKdGdLQWlmUFFOQkhVTldodGl2SVJh?=
 =?utf-8?B?R2MyUHJqU2ZXSkYwbUwvL3hUTUNoSWRhdnQyZ1NtejFNWUhOMHlyNWI4bS9N?=
 =?utf-8?B?Y3dRV2JSaHFwQWFxZVVLeEd0eGlXRlpGT0FCcVUxNm5uR2J2cVpWd0lqb1hh?=
 =?utf-8?B?OGhHRnZBdFgzMzR2YmdmU1JFQ2ZNSlp4bHFqQjFWNEJ3UlJGS2oydTB0cFJP?=
 =?utf-8?B?THlCaWN1bk1pZjVPSTlCMFgvMFZxeVg2Uk1oTkxzV2prdzhGd2VXS0NUOUxz?=
 =?utf-8?B?ZTh6a0NwT2ltSEhZUFJxcFNKQUt0aWlkbU14T0k2VzVISGZuVkljenpIRTVl?=
 =?utf-8?B?S1BzMk5BM3hvVW1FSDVaclMzUEw4cnFrcHVveWFSVDJhWnBGOHRuNUhiNnVM?=
 =?utf-8?B?bXhVVndtN0dsbFZBcmpaOHBqOXhrNlc4Y2hjUSs0eHRENWJPa0VMYkZIQjUv?=
 =?utf-8?B?b2VZV09JOXRSS2V2a3pLeTBBeUVHVkpaZHMzVm5GVnFWM094NDA4R253bHRa?=
 =?utf-8?B?OEVJbHJVSG50anJPZmpMejl6UFJWZFNUQUowaTdrTHZmQ055d2VlVEZ2MXo0?=
 =?utf-8?B?eHBaL3ZjVFVSbm5UeUU5SzErN1RFWnpNQmJ4QVZ2T3BScUh3SFJKSUxuR3Bx?=
 =?utf-8?B?SlZKdVZ3bHJkcnl5Rm9kWEhHNlp6R3dyQTFiSUNyckg5Z3hBaTd4SEl5SGth?=
 =?utf-8?Q?WnLOcwEYxtgfxZ3OzfrBZXYoqMY0axEqLWIS2u4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95667dd4-3afc-45e4-6dea-08d8f32f94c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:54:56.0460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2iofVoubqrzxHvsNEfiKxihwuqhhhxZLTlBXbdVEiof2VVe/4jCr+u75/toUJGVtXAKiEil80JKQV3Xku9R1ckpr+Ym+XRqlcvQ+k8gunJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-ORIG-GUID: mmcegdjW38P_YVBAbfX2fHptt3qx1LVO
X-Proofpoint-GUID: mmcegdjW38P_YVBAbfX2fHptt3qx1LVO
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 suspectscore=0
 clxscore=1015 bulkscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 20 Mar 2021 16:23:52 -0700, Bart Van Assche wrote:

> Please consider the first patch in this series for kernel v5.12 and the
> remaining patches for kernel v5.13.
> 
> Thanks,
> 
> Bart.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[2/7] qla2xxx: Constify struct qla_tgt_func_tmpl
      https://git.kernel.org/mkp/scsi/c/634b9774d335
[3/7] qla2xxx: Fix endianness annotations
      https://git.kernel.org/mkp/scsi/c/37ce4f3531d4
[4/7] qla2xxx: Suppress Coverity complaints about dseg_r*
      https://git.kernel.org/mkp/scsi/c/17603237f789
[5/7] qla2xxx: Simplify qla8044_minidump_process_control()
      https://git.kernel.org/mkp/scsi/c/a20821e3f471
[6/7] qla2xxx: Always check the return value of qla24xx_get_isp_stats()
      https://git.kernel.org/mkp/scsi/c/a2b2cc660822
[7/7] qla2xxx: Check kzalloc() return value
      https://git.kernel.org/mkp/scsi/c/e5406d8ad4a1

-- 
Martin K. Petersen	Oracle Linux Engineering
