Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6ED7C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86F564F30
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233672AbhCSDqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:46:15 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33392 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233694AbhCSDqG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:46:06 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3SaJB021873;
        Fri, 19 Mar 2021 03:46:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BlKqPyz4/hcRiqB00XfTV9S6jMkiCOSKTeMSDIvrlJk=;
 b=rEPhxql60Q9bFFckM7MurVPTvwFpXqycD/wzp6QZa4NvQCyyzzNiQQnSfO2buIo5QEuq
 7FNys7oZZVX9qdsUWAmw3KOruHOt3SfD7SvHAoDn5SY1oiagNjSEEgh4TEEz85u9k0++
 CzSc6l0wvUjgcE33UpqAyMYVjVSpJGhgEQnMkL+Swdos8aOvMfP+ZiOdTv10OpymG93X
 CZU8PKtz3ywZNGCvSoI6hcRiT2L9SVhlPcKVsSHhHzSEOF6b6TEX49IAsx2iJodVAlI8
 eZSRTqFA3wjt33CvpmuWBHGwi20cQVV5MFG23paO+pDqBsbbzJtprLP2K0u2En86deZn bw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37a4ekxepv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3Vc6F007675;
        Fri, 19 Mar 2021 03:46:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 37cf2b928m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WrD6tehi/wC43mvemc0NvUwSLWEZrH0raugsfSuYvZdaZTB6M3kWD4ELYzYASJ6WWB3jekaTLsawLZ6geQgRTPHj7DyHUHMSFfY4r23qV92ZVL8iFkxt9FfaY+L8nKe3BmOSHlIvgluz8BCc9TsCTcjp3uVvV+gW+qYsF9ALC3PaDmZwHWndUOhYA0v6D3NwAwXTnudy20AIdgUECzc19hUYWuYaxgdkYqN3PVAoSDkglO9WsnnNS4hPYwKAoWmKXBhJp8kpcWPQLDtgG6sqm1PufwjplH5yGIKUrqHyvxd+7l/NxbYWrl7km+w3Pa6Ypj6juM4r8FulyuOJZETooA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlKqPyz4/hcRiqB00XfTV9S6jMkiCOSKTeMSDIvrlJk=;
 b=BL+3KIQZBzf7quoGkSIOJsMdx5i2L5aJr1iR3PqCCyjTrxJ/Ev1LTuFV+XrTKwIe5zKCghYzAyCvFnLJoA3KXSfTTOND4ayPg1/go79116ZFYVIKK9vTQvD4k8ezvKs7Q3aVb/MlxyIB/F+UEp+CmKtScOTIzssWBLaXRR1pjkG1YkNA6507E4nJ0BGlCK+m/vqBVkZ3xLYC2rfIlSTnV5iK41X9zYLZfZnk9zjJrQW6sexDgKUBtN5d/HTVkiLXCCXUgNnwdpBKD3iYgsNYE+UDOQmLTTlmjRUvut8ae4IT7hghmych9Fn11+u4y0izIBgHfHCk1VQtD+LLhmiixQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BlKqPyz4/hcRiqB00XfTV9S6jMkiCOSKTeMSDIvrlJk=;
 b=b6DAR3U9r+T9GQXrudCdBlCzym+SquFBlfEyRutVSfP4BA06TDBDFV2LUyZhgKmHvrC+rnft2cLPpCWny/QtxehkL6cFCWCMD1Lu4qhK2IJ/Dn1C4Et5uMdn3FE1bQ8F3UPScS8CHQceQ6UrAYD4LttnTXzkqBMtZ4+zdq59vM4=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:03 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-scsi@vger.kernel.org,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH] scsi: sd_zbc: update write pointer offset cache
Date:   Thu, 18 Mar 2021 23:45:56 -0400
Message-Id: <161612550236.18396.233058887900722742.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
References: <3cfebe48d09db73041b7849be71ffbcec7ee40b3.1615369586.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR03CA0078.namprd03.prod.outlook.com
 (2603:10b6:a03:331::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR03CA0078.namprd03.prod.outlook.com (2603:10b6:a03:331::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Fri, 19 Mar 2021 03:46:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53f85fa0-8248-4659-5471-08d8ea8984c8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4616680F95F5098CD2C0EF468E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0x1YhnAhWlbNY29vTHqcGJxr06osk+7e0HsUzPgKrlqd8Fq/KgwSVaYVtHIPPfv2cdPNH1Thhvv4IMZnHp7H8yH6GSwJCczJlz2BYm4cXtmz7EHfto6tNJm9T6axz2sYMqrIEp9/2vy0nCxOvLDdg3zPOkhrEsBQv3FuQ7/NcrmP9tKcpj0BAfIwi6pfzpgCZfvw178aTQR1ErmWZE1aZbFsIHeXD17m+r99cpGLrABI+iHCtnIWyLh0zgyJ5Ngxjkd0ZbdhTDsXAaOnNQL7oRUdfzAsWvhc1qlK5DGQscSEvz+2RRX9ixN8hUGUoMqojWtxEN8eW6KD5yFpeS2hwGakA4UiyssguM5EIqGiBBdGggqtI7iJ1JmwxHu3nFJVHmfSeUWyWgDylgzeGmCIqnrqluFXJ8Bq3U7PiCT6Xcaxt976rE0YrBfnC5aFeV4z6C53KybJPMR2x6+RfdFUtt9qfzDfMayBFkwevX+gZF4ZcQA5iWa+y6sJaboF0pcmP/+wUPohgwHwnUxYdTLxi0hg63bPQo63smHuSK/cJh028IvkoA1Rvy92tRWuoZuROTfZ/BtO5N+gD0AbtkClic+Q+dftU/NuMYyXpenPotnoasscH4A7JauxhgDihpOV8FgEK5onH+SLnZEdy3FSy0Ibex5vF6PWLfx8Fh5R/z0U4ATYeuL1bBoh1PCmi+PI+ldfr06/ER4Vr6UD6MNEFIMvJRi12UZIZW/81UmEerM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(956004)(86362001)(5660300002)(26005)(6486002)(16526019)(2906002)(66946007)(52116002)(66476007)(7696005)(2616005)(15650500001)(4326008)(8676002)(6666004)(66556008)(478600001)(316002)(966005)(54906003)(36756003)(186003)(83380400001)(103116003)(38100700001)(8936002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cHpPQ3VSNnQrRlRUOFNLa01PL0hTM0dQT0VuaXVBN1lHbzlseU8xWEZCL2d1?=
 =?utf-8?B?NzdmREZiVGJCRmpGTjBMQXlQcnh3SVp2R3RrbkZ2T3RsN0hFOVhuQVYzZ0N5?=
 =?utf-8?B?MzJPVy9rbXpXTlRWZkszYjJWR1dBcmVUMkRuS1I0N3lxTGpabUxRYkxTMkJN?=
 =?utf-8?B?VWEyUlJlTzF0bFB1YU1OcGFJV29NUGZYOTBzd1lrVjIzN0NsVUFrK2EyejFh?=
 =?utf-8?B?R0FpRndVQ2RxcVJuTEF4RGlYa1k1MUFBTzVtQnp1QW9zdUVQQkdudktaWEVK?=
 =?utf-8?B?SktqaU9DdW5rcUVITUFHeFRNRDFCZXdtL2hFcmI4N092Tk5mM08vRW1jSmFN?=
 =?utf-8?B?Nld0TFhyNTY2MUlobENpMWZkWWtCR2RvT3NzZHdVb3Q2QkQyZTBBeWptangx?=
 =?utf-8?B?Zyt5a0RtdjBOWjY0SXRTUjdYTWtDdC9aNzh6Tm5pSUd0ZzZmejNmNXpEckNo?=
 =?utf-8?B?aXl6aEZ4aEhrMlpmSytCQUZQYW1tNnU4dWdqWEh1Y2lYNXByY3FuaXNmU2JD?=
 =?utf-8?B?czNMTUJEM1U4WlVUZjhJZFFaZytHV20wSVB2SzNUaWdVc25MWHBJQzMrL0hn?=
 =?utf-8?B?UEtDblBhdHpYTUx6L2RIcFdSN3NHMS9mc0N4a1ZVWVZPWHBqaWRJQTFLYmla?=
 =?utf-8?B?eC9KTGNiYTlCNlh1alNIWVE5eEhUK1FaQnE4MUFpRmp0Uk1xN2hReWl6bnN0?=
 =?utf-8?B?TlRjTmJlUWY2aDJOQzNXMmlGeGFta1VVRzlxdEtlb3pKV09WQWVUaWhEc3pm?=
 =?utf-8?B?ZmlJN0NpSDhLWGJqRUFuQ1B2eWYzdGpPSEhidlIyQ2VLQUZNNjRNaVlEV080?=
 =?utf-8?B?YnYwM3ZEbGE1bStyUVIva2pzbW4vc2ZUVnBWd2NaaGFFdXgrUTA5Tm8xdGNj?=
 =?utf-8?B?NkJZanhKOTRiNm1kWlRVem5hUURiNWpBWWRYT015WG04TU1qalptS1d2WkdU?=
 =?utf-8?B?OWt3dnFJK2ViWEdhenY5N1g4OHI5OTQyQmlyemFHbDNYNDVHUUxQb2xneDd0?=
 =?utf-8?B?b29zcG5IOXVSR3pPbVppeEdaWm4zV1NweUF4OU1JYjQxU3ZkN002MUdqbDZr?=
 =?utf-8?B?TTRrRm9kL2dWcmdRZkwrNHNMUHMwTHBaV1dLbXhDMjM2Rm5JODdERlVtRzV6?=
 =?utf-8?B?bWk3K1R2T1ZJcVVkYlR6S1NkZS9OZHBwMG9sTm5yTWRIQVFCaDJPL2haT0Rx?=
 =?utf-8?B?UzVRTzN2S0JyVkg2bzBKUEQxWGlOdDRZZnJBcVdhVlJtWTBIc1ZnQkR0cGFG?=
 =?utf-8?B?NEI0M0ROSUdqemdRemZxTjRDUXhuL3hxbXU1UnY1SXprOStHbEFScDlVeXF5?=
 =?utf-8?B?bFREQU1rekNyeVB3eGlHeEVxUnNGL1YvdGF6aWtlQVpLSlhCVmgrMkthdVVO?=
 =?utf-8?B?clhENlFITkhaOWVWQTZ5M0FEaWlvd05tWGdxR2QwN1p1c21PaFMwMjA5ZTJZ?=
 =?utf-8?B?d0laN3RvbVliTTZtckZsakduN3hSRDdrS2s1azJlOHlrUXBPN2w1cUxaWGpI?=
 =?utf-8?B?b3ZlZXhXdDZNVUVYdzM1Nkx0S01mdEdoZmFVWkk5TytyNVBlZUtsSktTZGRy?=
 =?utf-8?B?TCtab3Noc3pHb3k5YnZvZThwb20wcHd4R2F4UnY3RzVmTEtZZkxqREhscGJo?=
 =?utf-8?B?cUNlVks1bVBUcVYyMTh2N1BFUGkvMmhsRHRBOEY2RUx1WUFpaTF4UGZBZHpl?=
 =?utf-8?B?N0ZxbVQ1a1I2Q1phS243Z1dpaW0xRHVzZURiSUwrY1RGSzFaSkhzeDFHdWU5?=
 =?utf-8?Q?eBjKfy9RFrMj10p+AKSyU5rTLW4S88BaV8l7P1O?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53f85fa0-8248-4659-5471-08d8ea8984c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:03.3529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsDAnZAtsBbvBoaM2O+HzjW97bnlFYt2ePeR4xH2QlRRVjQaClLXgBp/CmM8DwP2sLkRNx84A1T/NbHOjpNVoJvhV917+fXsJwMBf2lGwCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=621 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=803 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 18:48:06 +0900, Johannes Thumshirn wrote:

> Recent changes changed the completion of SCSI commands from Soft-IRQ
> context to IRQ context. This triggers the following warning, when we're
> completing writes to zoned block devices that go through the zone append
> emulation:
> 
>  CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.12.0-rc2+ #2
>  Hardware name: Supermicro Super Server/X10SRL-F, BIOS 2.0 12/17/2015
>  RIP: 0010:__local_bh_disable_ip+0x3f/0x50
>  RSP: 0018:ffff8883e1409ba8 EFLAGS: 00010006
>  RAX: 0000000080010001 RBX: 0000000000000001 RCX: 0000000000000013
>  RDX: ffff888129e4d200 RSI: 0000000000000201 RDI: ffffffff915b9dbd
>  RBP: ffff888113e9a540 R08: ffff888113e9a540 R09: 00000000000077f0
>  R10: 0000000000080000 R11: 0000000000000001 R12: ffff888129e4d200
>  R13: 0000000000001000 R14: 00000000000077f0 R15: ffff888129e4d218
>  FS:  0000000000000000(0000) GS:ffff8883e1400000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007f2f8418ebc0 CR3: 000000021202a006 CR4: 00000000001706f0
>  Call Trace:
>   <IRQ>
>   _raw_spin_lock_bh+0x18/0x40
>   sd_zbc_complete+0x43d/0x1150
>   sd_done+0x631/0x1040
>   ? mark_lock+0xe4/0x2fd0
>   ? provisioning_mode_store+0x3f0/0x3f0
>   scsi_finish_command+0x31b/0x5c0
>   _scsih_io_done+0x960/0x29e0 [mpt3sas]
>   ? mpt3sas_scsih_scsi_lookup_get+0x1c7/0x340 [mpt3sas]
>   ? __lock_acquire+0x166b/0x58b0
>   ? _get_st_from_smid+0x4a/0x80 [mpt3sas]
>   _base_process_reply_queue+0x23f/0x26e0 [mpt3sas]
>   ? lock_is_held_type+0x98/0x110
>   ? find_held_lock+0x2c/0x110
>   ? mpt3sas_base_sync_reply_irqs+0x360/0x360 [mpt3sas]
>   _base_interrupt+0x8d/0xd0 [mpt3sas]
>   ? rcu_read_lock_sched_held+0x3f/0x70
>   __handle_irq_event_percpu+0x24d/0x600
>   handle_irq_event+0xef/0x240
>   ? handle_irq_event_percpu+0x110/0x110
>   handle_edge_irq+0x1f6/0xb60
>   __common_interrupt+0x75/0x160
>   common_interrupt+0x7b/0xa0
>   </IRQ>
>   asm_common_interrupt+0x1e/0x40
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: sd_zbc: update write pointer offset cache
      https://git.kernel.org/mkp/scsi/c/2db4215f4755

-- 
Martin K. Petersen	Oracle Linux Engineering
