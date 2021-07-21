Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 806D7C636C9
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B76161106
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 03:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhGUCmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Jul 2021 22:42:18 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20690 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231363AbhGUCmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jul 2021 22:42:17 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16L3GjVo011724;
        Wed, 21 Jul 2021 03:22:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=6PajHicsLrUf4acGvNVx2HauugGBAYmQ+csKRtDWAAM=;
 b=lZyhwUtbjJ7C7sX1i8tKfWdRN7d44pzioQHAZhEGvZgoeQQYonZ952GMJS6iKaPZ6fQI
 wU3B5fo4ZfPKk5iRjLegCokWxLc3Il4vwK6dqS4teZLEE42F/BaU2HfFV1RF0okoNagH
 Ycy35e8EAfQCNv3l17vqM/JyPptw2LLDQhU2eEjlpXw+DIT3SCPJZSVQ19Sas/y9/vmv
 oHDgjM0T4sVPWPR/mNyx1cd4iowPGH3COSqOquAGfT+cAdD5OUfPLVKZ1Y5B2bxBBWKW
 PdzyU5ARXvCDdm9FPhl159WDEGQRi8Kqh7XB65Wr8TW8FIypFr5i5FRjqzavmjm0EwfK hA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6PajHicsLrUf4acGvNVx2HauugGBAYmQ+csKRtDWAAM=;
 b=ee7PiF/cHWFUOAFD3/xgRyolQQUR+Rhbt0X32fBxFvG+vs1JMC/38xLh+u7RaOwaCkXM
 uCia0Yf4jU+i3Ye6ESFmA/twZkDKseWa1ZccB/kfNFZ07qTVxodNKber5N++pWvPlZZ5
 vlDIsNrXgW9sU9gbkJH76GO1FV5EgdH14Ih9idCjh3u22gmbeaZwGHMwzVftI1+Npj25
 WGqYGa8go7JjCboZNVxuFBu4Nz2J4XRjMuRiycxPDZ93B9PGBJGpy7w8iow1WTezYGi3
 44I5uefWUsHmcZwJGNHOqS1lTtaoSIZktT3uUFcXRZkhW+bQMQuR6I3PxqAG2b9krUUC hg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 39wyq0sdbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16L3GWU3041333;
        Wed, 21 Jul 2021 03:22:53 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 39umb1rdnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Jul 2021 03:22:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RyCAgiPMnp7+IktuKKtsXyFrZW/x82qbFVU8SIEQLRdrlWN7V0dfXZnotpQFcBHy3+0FJfiupvkJqqPAnPutQJN0OLhnWAKslc9bW6VUSpDSniSuXkEtL86AGo7Ivsc5B5PxgSB81z+8ktlxbrXwxPTSQqlGrYgtsKTZRUSgGPNPZL92MAEhC1+nTyKDaa3btCy+nV1WcmOQu5KhOopNl+Jet++UN7l08oKfzWbhfQr5k6XPwCpsyFTzSvz/oZ+F+P35w1wdlLUaKfu1zwlQ8oQ+1bgR9Rum0LYo7WtvbDmtQge3+Q/w+jwfZ6ZcW4R+4vtHo+9cU6DEZJow+FgIEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PajHicsLrUf4acGvNVx2HauugGBAYmQ+csKRtDWAAM=;
 b=HivrnCXqy3MvD8zoVEpbBHX1r1WObJK6itVf4bMGSAkKYck9GScTwxPNVtLhH5hCfFQ9jdHe95eXhsVPx8z0GCIBKS/DAK6b0InoMJx4JffjM97xLVBf7mOGxNoovga4nrD1K35FXlOvYldZQPhJRBeioHeHi/DgQtlfsn7j3qVDjiOzp6ttaFbwKcL1mclV1UJPq3KH8Pz14T6+dBMO4OqOR+V4e5n7br/9iyNdo9QwqD4u6jVgyuiyBKLYan40e+mlQkWfl4mreoxyD9gTTFN4w9pGb6xMr4srGFdF5P10AnlGBeCnELiRMoDxKCt7bHSUey6zBQhD3UfAJWTkaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6PajHicsLrUf4acGvNVx2HauugGBAYmQ+csKRtDWAAM=;
 b=fMRVWgcgftEJkJcO5mIXW+gFJCqmwbQOxKvwbncIaLf9vajeqA4FN4JqMJXDUXOkQ4C6RulYqxwfaCrSoznUrFV9DMUQWbNoI/eLZh/qno+adM5+WjXnlk0lAJmg069BuM9bZizFfnF7SZjCu1K6NVrL7S+t/erIVm6OG2CLWLw=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4680.namprd10.prod.outlook.com (2603:10b6:510:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 03:22:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 03:22:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux@yadro.com
Subject: Re: [PATCH v2] scsi: target: fix prot handling in WRITE SAME 32
Date:   Tue, 20 Jul 2021 23:22:45 -0400
Message-Id: <162683773926.29160.9695511456908046343.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210702091655.22818-1-d.bogdanov@yadro.com>
References: <20210702091655.22818-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:806:130::13) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR13CA0008.namprd13.prod.outlook.com (2603:10b6:806:130::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.13 via Frontend Transport; Wed, 21 Jul 2021 03:22:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c76f976-0e7f-44ba-da07-08d94bf6d214
X-MS-TrafficTypeDiagnostic: PH0PR10MB4680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4680F0C7185E8B4C7C181ACA8EE39@PH0PR10MB4680.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Yl8nhrGTy7PC6CwkVsHTC/TSMoHKafHChmIJtvHjpeOk4rTnmyB45HzqR9bQVAf1uf0xoTTolRuXh59hlSBxQm5Q7iOWn4McJwhsnBBz471eQFzczpzn157ujL5VTXX3Z05iQhQyST0D6wpYTOl2EXTcZFWHif7IXGVE2fXr+0fZDDwlQGNk+ZprUP2wk+0uHQOw+P5RoTQWfN3uVARFEwJUGrxBPKveVZKsTpS5fBp4tQdwmJHTvPDRF3KoOImATUfk4oamVJQG4JkQQCU9WIfOAUYUX3L18LcSfa5DJcft//lrxUH6rzjUX4SMOTqnz9nXU6Utp58Gr9Htl0F4G9BEiNwcmbVNV5XzIUkJccsaCA0jGusMJNvho6Z/sZBAgaxuHxEwpk2Dcz2iM0ayAP63PcRIfWEUAiwCRFcD1UHtXUsWG7a+fwJEZiNoRtfztRbdzATq8QFBV+R+seZJAi1i6o9GkgQGo3WVgaPE6k3rr8tDnZWqv86ry6Cp7V/MPkv37N1D6s8ftnWQlTbLNhD2YQ8WDG35DE8Dy0aRzUqzwPXItq28qoRQdmjTUthzR5c/c+uelTk26HzHu4dnFyA2ef+fEzTC7lQ+D4jBZuv7KkYMPZ2rsSBu/ICj5ez2yqpHoJ4v4rvwUG0GlKTtb1U7ODkmgvDHafCgiSlBCxYetD5rqUEl+paLerRVfwPzAxSFITEbzqJpaOJXWn4B2Zbu3Iy7YXwHct8XBYQRfIlEn9QGw17FdB1XplHuO7nB+w3xmjoRjKlFVznisgIPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(376002)(366004)(136003)(66556008)(2616005)(66946007)(956004)(7696005)(38100700002)(103116003)(966005)(478600001)(66476007)(4326008)(6666004)(5660300002)(52116002)(86362001)(8936002)(316002)(186003)(26005)(2906002)(4744005)(8676002)(36756003)(38350700002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmRyQ1FqRG0wUTFKNVZtRngrc1NEWHM0SHN3SkZXRzdlb3BzelRqOW1laDlq?=
 =?utf-8?B?N2VwbnMxUU1uWHpaTjJoTTJ6RnRmcDZoYkc0WGJrMjRlYUlYRm9TZFNsR083?=
 =?utf-8?B?UlU3K1RWUktaMC9Lc3U1elA0TnhpV1BsMTFNN25MeCtQSElVM0ZjVTBvZzcr?=
 =?utf-8?B?NVBZREtQeUQrWVpMUVJzL1U5M05TZmZ2bjlLQy9ac1puQ2VDMXVKYUVRalZU?=
 =?utf-8?B?NDNpa1M3MkdyYmYvMVdlcXZTTXFZdGlrVDE4ZDdFQ0FnK1pYVitMT1QweEJT?=
 =?utf-8?B?TktZOWhyM1Z4eXo4L3FmRmJEWExMQmRIcTRKTTdvN0ZmUEd0N3FNc1JGVHBp?=
 =?utf-8?B?MGNuakwzS3grK3FLbDhvWFVwc1gwUzBiL3ZKdHdlNk1HSEx3M1dFMUJGUFhw?=
 =?utf-8?B?OVBEdFNyM2g2K3kvemVHcitjNktEYXNHU3RJNVpZZ2l1VVdFd0hPKzErRld1?=
 =?utf-8?B?S2IyWDc3emo2L2w3M3NXdlhSM1ZEdFhDeGtmNkd2ckh3OUc3WEVzWTlHSHh4?=
 =?utf-8?B?d2dRU1dBZjlzSFVJOThndXlBdWMyQXh0d0t5NUpGMUxRTWxRTndKKzhQMnFk?=
 =?utf-8?B?NmtvUlAwaG4zN0NKM3RYTXpHT0FVUjlmL2NiVWRFcmUrUEJXUEpKREgwMlBz?=
 =?utf-8?B?d3V5SmQ4LzhPNm9SUkIvMHlXTEhuS2NWc3dibGJUK3ZoVURpTTlLTldSWTRZ?=
 =?utf-8?B?aFNGWUVHRjkyMEhkN2ZWVWZoVk0xNjBpQjFEOHIxdWNyMmp2MzhzWTlZWURF?=
 =?utf-8?B?UndHWXRrU3ozYWdzSGJkNkIzN2N4VXc4U2dHK0pSQVE1Rm92djhIa2NDMmto?=
 =?utf-8?B?RE5FV1pGZm9CajJTREQwZzdka0p2TXNQOWtpRmRoM0lmb0N3S2FneFdBcC9M?=
 =?utf-8?B?V3h3UFdzUkhUcm93L3BWQUlORG9CcnhMZ293MUZhcUdHNVIxMFptZEhTZkNh?=
 =?utf-8?B?K0tlY3FhTjNUZUVSZFRyUTBjSjRSRGdGWmtsdG9meUtVZk9ndUcyUEJkOFdj?=
 =?utf-8?B?Y0dIclRDaXBxM2F0Ym9PVHBHL3F6Y2tJTkQ0VzJtTlJWKys1a09DeEFML0ZW?=
 =?utf-8?B?NktPR0pvU01LZEgya0l6aGNjSVBvZzRRNEptMUpPYnd3bk5XVmNWRHE0aGd3?=
 =?utf-8?B?dDVJNDA5SCtYODdnZWNsNnJjZXNMeTUzRzdWWDgrS2hKOUJBSFZNYmdGaHBF?=
 =?utf-8?B?ZnBCelA3cSsxaWZjRzBXd2NHdjVkZEdhSmlUckNBVVZRcW1PMC9IQTY5TURZ?=
 =?utf-8?B?VG5HNnRZTDdnM2YyK0dSeTBtMGxZU0oxY3pkUzV1akFyQTc2Y2lkdHRZd0E2?=
 =?utf-8?B?Nm5qeTlROGdubzRlZ0x3dzlUU2lIRDgvUGlkRmpzbTl4MThxeFJsWDVORnNk?=
 =?utf-8?B?M0pHMmhvYmx4dnhianVMOWhqb1ExNXcwMWpYM0FWZlQvN2VIME9EMUxsL1dI?=
 =?utf-8?B?VlhnTkhOcUFMU0ZFekJhNWpvUjdqSDQrbWpBaVo1NEx4UHA4M2JDQ0YvaG53?=
 =?utf-8?B?cW4zR0RsVDQzeWQzWXgrMjk5a0R1dGlZemRoSUlNM2YxWXMwd2JpRHRJZ0cz?=
 =?utf-8?B?SG9IZUUzaFpnbkRKSjlBMXIrcFpDZHdjL1lRdERjTDdYNWRCajBudzBWNktq?=
 =?utf-8?B?cXRzWEdNVTlnOVBUL3o5NloveWFUZ05SRHFNdDJQSkVaQ0RvandhVG9YQnBG?=
 =?utf-8?B?NTNYUXNoN0d1SHFaWnN0Mkl6SVZld0tlRWpWNW91UGhUL2l1a2tyM3hvcS9C?=
 =?utf-8?Q?wG0KL/jLi+2/z7b/oICQLF1O7VkmA1YO38OM5zt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c76f976-0e7f-44ba-da07-08d94bf6d214
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 03:22:50.9988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PGq0KPdRZQ6eKFmWefBR+x+zUyY8hlF5pb2LmpIh80fCuxGK2qVzDxaz3b2IiaWGJtcLG66tbeaEAErv6HqooPdP5kYDeUmYT87aTZM6Hfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4680
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10051 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 mlxscore=0 adultscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107210017
X-Proofpoint-GUID: H2msHnVZkn_zf-VjwbxIZc9aI86Bh6qc
X-Proofpoint-ORIG-GUID: H2msHnVZkn_zf-VjwbxIZc9aI86Bh6qc
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2 Jul 2021 12:16:55 +0300, Dmitry Bogdanov wrote:

> WRITE SAME 32 command handling reads WRPROTECT at the wrong offset
> in 1st octet instead of 10th octet.

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: target: fix prot handling in WRITE SAME 32
      https://git.kernel.org/mkp/scsi/c/6d8e7e7c9321

-- 
Martin K. Petersen	Oracle Linux Engineering
