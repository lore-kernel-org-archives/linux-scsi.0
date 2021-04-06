Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D741C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8E7C613BE
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 04:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242491AbhDFEyF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 00:54:05 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53434 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243691AbhDFEyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 00:54:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364qIZp077955;
        Tue, 6 Apr 2021 04:52:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=DiwJPEqiaWQidtvmDk5QHXYvG2pytq8nrUwXp1sR5u0=;
 b=Xlkv351McLvt+dQI1IjzV6XMRJ8rGRQj/KDiPi4UGGnTdZgvdNV11ENM+X90/bi2LO5y
 ByCz9HCC0p1nuyYp0JltTq6GWuz0CDQgs30ImfG+pItNC5C/xLlzl2VB4/2094rNl7M9
 CVaT+m1bSVeTH29Srjg3SP2cxu33mOtvr8OjBXc91XF4GIV5k2RLvGRdctDNoKLzPeDl
 Y7C5hSL/1x76fa8LqC7SZ9/Jl8EtOR9BNIXfvV8LN1aE2CUNHoXpaBfAVSQCsdXAYY9M
 jlrKyYqLMnKtifMoMFc5CizYZZgTfbmJAWUritwL/iiXAdC41n+MO2UOEVzLbEcsrZDz IQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 37qfuxbbtc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:52:42 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364pEWQ029313;
        Tue, 6 Apr 2021 04:52:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by aserp3020.oracle.com with ESMTP id 37q2px1rky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:52:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgnLohTegKw7FNve7IJSc1aF0ADZ9JDHI74hv3/ii6hUrdnlNxyUiyCMhzQBAKOTbd/A8hQWsUsX9/RZGw0nLCDUP+VC7XnG6OIs//3kv/w3YnAxDPfrJrB3+LVu7HMM3eSxcQOQslIbWvo9aRNltG5ARpoKbBGq6AuN02KVD0lgis60lZ6uhK1UFVLHolbbJD2SMe4B4W5h4bqJcYxUrmpv4jcEyabhFc01oXXE2axZgpl+zbhKSOa6CUC92o5PcP4pfmSsjqVpHiCuId/flAA0vfyiwcuMSpubUKaKQG88bM8GQn6r0mQMbVr53cC8GHjkRGTTr7zhHTzj3vPprA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiwJPEqiaWQidtvmDk5QHXYvG2pytq8nrUwXp1sR5u0=;
 b=Yen4D1XYeOdpIJr5lz8UdFBsJZM78/3UYJYQ/IWYFhzJrNJSF4WcD4o3cjU/iky9LPNPH8QXQ0fCCKZAeYX+hkePTuoORrXmJWbLd/6lfnCHXkqawC6KyUT4MLd+xPPk3z1Yq1c0zxvVp4p7jMKvfvk9UbK5tg3EZHQ75SO0xkURthUmDoICLNGjyBGAVQOd34eSaencMLuU88LQwltFqZ/hBI96Sdpa2ilIvSCebaW2D9mFZjf69iCOdv6Hs5ZiL3TPvYKG+35ICWp4/J0fQdpuVkZb+lP5Lj2MpjSyiK4nCuLehwztL8AK8mGxL+ez7FEdbLdI9Bk8pq5W+Nw87g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DiwJPEqiaWQidtvmDk5QHXYvG2pytq8nrUwXp1sR5u0=;
 b=sFAhAtfiuEvst3CkN2klyogusROYdS9RdmpTWVbwq8XNzAzu7Qq2SjDMAlbLWUUeFblDS8/o6j5qQ2guFTdez/dnnqfSUAj3QpEgbonZtzeGyRMb7zKQl6jqmoIp1R2PE+Jpv359NF5X314Okn37nDhi/8lumf65cpsEKMcy+0s=
Authentication-Results: sandisk.com; dkim=none (message not signed)
 header.d=none;sandisk.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:52:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:52:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <Bart.VanAssche@sandisk.com>, mwilck@suse.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_transport_srp: don't block target in SRP_PORT_LOST state
Date:   Tue,  6 Apr 2021 00:52:33 -0400
Message-Id: <161768453467.32039.7280609674321638516.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210401091105.8046-1-mwilck@suse.com>
References: <20210401091105.8046-1-mwilck@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR13CA0058.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0058.namprd13.prod.outlook.com (2603:10b6:a03:2c2::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Tue, 6 Apr 2021 04:52:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 093d92cf-70b2-4076-cdd3-08d8f8b7cdfc
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4407A5E1DE80C4AFE5930B2A8E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:262;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9vd8gcP6fnM+50OPAduFdJ/zAsRPpjJ+jqjLNieH0vuSF/AWwi2h5cQogFHhu1OVz8GWLl6zC/+Fv9uhretv07i394zpbPvcI5t0aZFz2munf2XerMLT3Mm+ciZAhOUgXygefnNsRISEwe1Wf/bkC8VozicxwsPvPDI+YCMQh/ys/2mqypKfumf20gAz/9VA9Wml8BiFS9d72P948VOjVm8iN8Au75DqLg+tqE/7Iu7PS7x3sHiQdrg8hHEqyOP0IOaaXz2V/paT2RE5kMD/2tnHCDyTnBvfRwBOroUD4gm+HkjOsjk/7RWYOGYO0gLrbPy5Qob4Hcq8V800ix+B31meODKe7Vw1ZfJb6y/eaGZZx1+oDrMBFhXB/3rpHnRtJUrJKjd0ufKblUFWgXp2abXiJ0+rT7/3xIBHkQLdYZ0N9JOTo4KeN0Krd2ZwA3YZLogXAmJ60pgORwXI2CaqG0cX0a3EiPTOXp5M3hWgt5nGk6SkoejonfZMRLkt0b9WoGuf+LPAixKKOt7j9MaWIznQ6bTenxkYshQaB9Qais9O4tRYZbWWBr7wzGz1Gf7L8ssgs0aMw13Be0XECuiDOqdhoEEdVO5Kvb798524cl6awyrAkoHZJ/g3VakLIa73iuiDanlGdIfceATXepN38QQfs3FMWV6EXvpnbdwcKBPf/AhSi7Zsdcff6GGhDMnAZ2yoM+JavQVE6865vs+1hxOCQCfj/46i7/SIrJfkHnNcqgd7aCzHJV8JmV8CVPzAcY7JmUV71hFALKl/hFRFYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(36756003)(316002)(2906002)(38100700001)(103116003)(54906003)(5660300002)(83380400001)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YlRWbHZaMzZpVVAxZDVtS2toME40TFdwcVRhUGNwRkRQT2VtbmVlcXNuZmVj?=
 =?utf-8?B?bGNtYUFRU2s4TGZ1UytQQkQvb0V6NmFsZ1BNSU8wU0J2enB5WGZwbGdoT2Z1?=
 =?utf-8?B?SXlBOTc2OXZIeWdhMkpWb1RIVzl6NklvcFcvQ0gxTFlmR1JmQTh1UGwxR1Yy?=
 =?utf-8?B?MnJiOG8yMExVNmliUGhsMzExamJiczk3RmxERE1hb01FSXgxSXM4Ty9IVWQz?=
 =?utf-8?B?dXV1eHpOTVRoSEcrV0ordkRBZlIzd3JUZzlOamgraGEyZkxpRGtFWmxiMkFz?=
 =?utf-8?B?VXorc0ZSVlpaelJzck9KdnBKVmZXbGd5aUZCOC9vTGlRMGpVWE5WcGNCQlFq?=
 =?utf-8?B?NFlzRWNzbmxudmdzOGMxMUxmWTVkSzAvQitRY2NTYnVSYU9PK1duZjJJandp?=
 =?utf-8?B?TnlPa0g0UGkvSyszaTkrTUU4YWlJRHBvb0I5dldPSFp4eDRPUWlEU0d2cjdF?=
 =?utf-8?B?Sjkza3pmeEJxcU5TQWZRUCt1MDFoOTBPZkFZU2JNUkV4SG11NDNGV0NpVStk?=
 =?utf-8?B?dmhIQTJGSUZrTXZoY3lVTndZNkdOUWtGS3ExREZzSk93NS94OFJsZWZRZHNn?=
 =?utf-8?B?R001eVdYSndxOG56SElaK3puNzd2U0huTFZWSGFNZ3p4bVd0SXh0ZGJKN0xo?=
 =?utf-8?B?TW8ydWZvL01Od0tuclVpY0NvdzRSRVNFd3VnR0ZtTXhTZUlDR1NUMDkyUWlF?=
 =?utf-8?B?UkZEc3hFMjloaTBMb1RVQk1IVVNUQ1NWY2ZlbFgzRVVOZkFSMGVybksxZnYv?=
 =?utf-8?B?RGNmWFIxNlRoVHFraHZvd1dyRHJldm14UWR0TVNyUW5ZTERqZ2tZNWRvVERF?=
 =?utf-8?B?VGRDL2dkV2E5eTVTeEwrS3VTS2pERVcxUmFBemFJNDJrZXVPV3ZSUkk0QWdh?=
 =?utf-8?B?QXRkTnl1RWVybDdXUEJFN2tzUkpTN2xnYkYwV2JwaGFXeGhFU1dUNFlIT1NG?=
 =?utf-8?B?MmliU0xxVzh6cUpXcXJ6RHNsZVRrMVE2aC9SOS9oUnBCZVBwakhDejBKOTds?=
 =?utf-8?B?cy92cEdXamlBaGpxZldCeWdudW1BMjE4dHNTb0NBVkhoRzdvK2xOT1VZQ3pP?=
 =?utf-8?B?NmszT1ZKQjV2aUs3cUY4QTN4c1EyYnVYWWtLWTVBQStFRnlWUzAxeTE0elp5?=
 =?utf-8?B?dllQaEFMZVc0Nm1UTndXeEprbGt2RmJGU2Q0bU1KSVpBL0xGQlkwV01ZcDhw?=
 =?utf-8?B?aUFsbmJER2pqWUVFcEF1VUVpUG5qMXI4WHRIQTd6ZVp6QWd2VTFwL0tNcVJH?=
 =?utf-8?B?OEZWVSswOE9ONUxGQ0gxaExkbjZCZmhFUVBZS0J0cTN1bnltK2QyaDlNbXo2?=
 =?utf-8?B?WWM1TFJtdmVrZmRWYTBhQk0xT0JaTlFvS1V6ZW5JTFc2U3lrSHdlZ0JOdHVu?=
 =?utf-8?B?WGRtdmZyU2RXU2dFc0hnUEYzYllJSjkvRE9vTytoYTlTZzNtRDRaRWpXNUsz?=
 =?utf-8?B?UldzM21Wek5Zb3loNXg5T2VvVkZoaUtRajFPWDhyVTh0U2l0dEVhUnFqZy82?=
 =?utf-8?B?U29aN1hpM3l6Rzd3eXk0VzZNNzV4bGYzdVk1SUJLZ2pBUEcrdHRlS24yYnYx?=
 =?utf-8?B?eXM5aGlNdmVVUkxEbGwzcU51aHkxOUw1NlVES0ErSk9MeDBLWFEyUFF4V05V?=
 =?utf-8?B?bVBkeFo0eUN1eG52ZWtqbkRDM2ErWXJDTmNwYWZiZlU5Q1J1c3dmTlJFZmFh?=
 =?utf-8?B?Z0Q3R1pCdWREQWd1OWtkdTBMSWZwUjd3YVJJNzFibWVWUERVUFI5SnVDQWN4?=
 =?utf-8?Q?2y9Vzwp/+/FKeBGKcxyPlghEz/WxSPEO9n5CIfl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 093d92cf-70b2-4076-cdd3-08d8f8b7cdfc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:52:39.3646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ylZCfXYFU18TzZyc9zT6/czMbWsHBzDc7PNyQtJYOaRDgDL0iJvtbEil16a0oTNdI17m/JdXyTPm83JIG3ROBg2bToEakB1ahT1TQeuuZtQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: RkKnBRpQzEKp67hTL3KzQWj0a6QmkCo2
X-Proofpoint-ORIG-GUID: RkKnBRpQzEKp67hTL3KzQWj0a6QmkCo2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 1 Apr 2021 11:11:05 +0200, mwilck@suse.com wrote:

> rport_dev_loss_timedout() sets the rport state to SRP_PORT_LOST and
> the SCSI target state to SDEV_TRANSPORT_OFFLINE. If this races with
> srp_reconnect_work(), a warning is printed:
> 
> Mar 27 18:48:07 ictm1604s01h4 kernel: dev_loss_tmo expired for SRP port-18:1 / host18.
> Mar 27 18:48:07 ictm1604s01h4 kernel: ------------[ cut here ]------------
> Mar 27 18:48:07 ictm1604s01h4 kernel: scsi_internal_device_block(18:0:0:100) failed: ret = -22
> Mar 27 18:48:07 ictm1604s01h4 kernel: Call Trace:
> Mar 27 18:48:07 ictm1604s01h4 kernel:  ? scsi_target_unblock+0x50/0x50 [scsi_mod]
> Mar 27 18:48:07 ictm1604s01h4 kernel:  starget_for_each_device+0x80/0xb0 [scsi_mod]
> Mar 27 18:48:07 ictm1604s01h4 kernel:  target_block+0x24/0x30 [scsi_mod]
> Mar 27 18:48:07 ictm1604s01h4 kernel:  device_for_each_child+0x57/0x90
> Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_rport+0xe4/0x230 [scsi_transport_srp]
> Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_work+0x40/0xc0 [scsi_transport_srp]
> 
> [...]

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: scsi_transport_srp: don't block target in SRP_PORT_LOST state
      https://git.kernel.org/mkp/scsi/c/5cd0f6f57639

-- 
Martin K. Petersen	Oracle Linux Engineering
