Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86B25C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E89C61040
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhG2DjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:39:25 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:18220 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233892AbhG2Div (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:38:51 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3aw4l006889;
        Thu, 29 Jul 2021 03:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=+DOt4SRXWURMEGPW0FHWaQKTfutEDhSrogOhlNov34o=;
 b=zkZRWhakJ48Wd/PVRRi4WTsAggPUhFdVG24JonSWJMR9wdZsHBK2WXZBYgjdT/vCuleY
 46d/e9YVgzOXC6JDHQG8FGLDCJJJQgXqE2Skcl5YM7pM9q2W+cjdYk3/KLk2IpAOSGbQ
 oFDjiFvKwnybNVnwn9RNqAg1FlpGQ6P37UgTTq05DVWAvD312sEGG+MgtNOJlIIDgzZa
 UCOcsT3cJZishonbfLOXO1HwK0OGSYp7N+dRIZD7e0kf305Oc+oMWgEDOV182+qAKUwt
 8Wlks+U7ikvbzvyomDceaOwl8qBeMHsIX7IynWwgicehpkB7yE50yerKc2W1UT7LHxMu Pw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+DOt4SRXWURMEGPW0FHWaQKTfutEDhSrogOhlNov34o=;
 b=lvLMXE4LeFAbNIqcWMwxsfO+zdSnVMTDggTXTRhTkuZU9ZqDNJAKcuKdczJ60SK6iHUV
 f5I7DLZRwZ307fgbL3VC0k1I5iR6Uu/X7tMCzkEqmHaCd+32JPAcrGHVmjNBeTlyZJND
 /vCoHZuHCuVSsnhtx9HSEClxieJ8fxWUFuippFMVsSsVPmBvoSKMMA8ZBxzBd2shFLxU
 Qn7zl/WCIvbgsfEItPjKVrhJKPwmpPSamCIiwhrczO92BRQ/WQFCofHJdcrq30Gp1hGf
 LbHg3WVfsXkJKn4y0X/N0JWEQrpD6/iOsC/1toIG+0LIGu3B4vR4i9/wplDqn9+iZza6 pA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a3cdprtd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:36 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3Ur3M071206;
        Thu, 29 Jul 2021 03:38:35 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by userp3020.oracle.com with ESMTP id 3a23501y0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:38:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kp0v5RxepSfdgC3GORPUCSS4Rebx0mbhPh08zkDbB/9h1/p2caV+GGRaGqpb1m6loKU5ngvPbu37Shb2ncuicvv5Uzfa5y1cWNYDLDVesGEOjc2LV7URZ5nQPTsApxGWlvYiuDBCov4Safigu8/8rjkv72FVCO12mqskoD0kMcN26FDVQm6F7AqChnRWkYakLXfXI8eNmNOSQuwK9unyANFhfik1bZcICQuxrYC9i2EC6riZj8nk5mRzjOXZxyYpo4ej9Zmf+h4Yc81pGr8IufAVlkpvfW3MDkNhi77iNJusk87SVS5pWEnzE2HWX4Vd8DjRYPx7WP6Qacf9wlW+PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DOt4SRXWURMEGPW0FHWaQKTfutEDhSrogOhlNov34o=;
 b=c/OqyrRybC1a/cPNowxhPKUWjdeINPrZ1l8CyQJ8okqGCzXwp/wioFMJp6b5q37GUqCnNtIE891Cgv9jdwMgBgpQQ+rcCB46PJTKOe8t7R8KzF/mED9yIVrwP+oUAjAWM20f3MS1FmClI9d0Pw+ywo3G0Atsue+MSq0fVrpR1+rnpZMUEikr4ooUbz5NqV4JXlK5mOCGcquRVaskMoaVI9HhlqewegzWqB9oVQZjZvI1PecvxWHFMe8M7ir/MNvYJppzzqIH275YiQ467FmEZyICooxrWR0cl8fkv6DYAJhwbeX5cDj/UFMHOCf2IS+U29YCZ8DZUiRfuDjwqzrDvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DOt4SRXWURMEGPW0FHWaQKTfutEDhSrogOhlNov34o=;
 b=FliiuNl9eBD+1YExsGEHXwQ0SKwV7MzdOJZMZZLnPlo9zNK6ZMG9YvwRGDDtpTK0IvLzNKlCuPXd4fmGWfX3k0ecFLnUoQOq6a8qTRotPT0s39SBJDDq69M5qX3lYP2yxjMl4iGm09rxJyIDQD9y2sl2HklV339D7c41FOBQtaM=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:38:33 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:38:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        Doug Gilbert <dgilbert@interlog.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 01/24] bsg: remove support for SCSI_IOCTL_SEND_COMMAND
Date:   Wed, 28 Jul 2021 23:38:23 -0400
Message-Id: <162752985698.3150.13847214881844967128.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210724072033.1284840-2-hch@lst.de>
References: <20210724072033.1284840-1-hch@lst.de> <20210724072033.1284840-2-hch@lst.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:a03:332::12) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0067.namprd05.prod.outlook.com (2603:10b6:a03:332::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.11 via Frontend Transport; Thu, 29 Jul 2021 03:38:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0bd9836-4da2-4ac1-4e4f-08d952425716
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15492995E16A6C4D715555CA8EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1227;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sdIwIl7DPUqVbmXMPF2LdI1v9CrurlDw1LMPnJQdo/J4TP8mdQwUmuPZBDWfzm6tQgPWKlTHGJGIP589GPqas/FVLXiaJNjwXGmBT96eGt8l1Cebm/cB79i/99bD/c7SAMGi1sq+VDaIgRlZlmjkfq/J5wk9qjTBZ+zPDEB/xPMC2he+YGAHLslkFlKfoHo9Tx/VV6xnZbqEYSGi2OJIvHhGXRUWxMTV8oy1ErULauRlDwzKomzZFhHxdkX8rqNSKpG/Vax2lMAGF6Bad9ztXFx0ijz8XMk6SPGMuupqnnME4n0J6iiMLhCCl3m2OjXH1elIsiPXBlVyvjdBJKBmmi8N8HO6Uu8yLkxsReFi+fhHQ04hCdfau0NKFrHEG2+VHMlTkarrbCcxaGrqb44bW3xuM33A8wzXwMaOf8ud9YgHpr14F2WUjmAMCAarY1Se8dw1/Ufa/rWaxDlfzrCiNSkxNuIBDS8ZLt1DyuLv2h6ntK7sESdRbDqhxcWmG7fQHFoZ7mo9WarzHWSATphTr2sukSCXM3TCj5mVqiU53KBl9kMSsXr1ZS8mmiu3fqfGuADSiTHoSIqCwnG+Pl1JfUlhEmp9kiq7JxwUxx2t94SLRtqOtAlPsBuNWGfr1QB6z0m30tBuoQdWvQYa8sUtaib/yqI5Qdrk0PRoCU/jCvHe6OXKhs5jWj1ICcUYGWmABooGUIEmF/4Ym06KBwF9d2ZQgz7E1zLL2ha4mdf/NzKdbZ5G6WexRNtHk8K8wXbJKuR6qg6brBVnfTvoe9Fb3lDDQanpYGBUgezFzHu1COTiDR9o629zCOc6cLCibVet
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(83380400001)(2616005)(956004)(54906003)(86362001)(8936002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1QxMitlbjJsL2dTMVdjUkg2bHBVTVdhY0tBRnZiWWRIa2JaY1RhVGJLMDFn?=
 =?utf-8?B?WUJKUHUwS29OL1liWm9KbHIycVdTSGd2TGRpTjlkTDFma1p3Z1VjcWhRdXdP?=
 =?utf-8?B?L3k2Zzh3T1c0M2d1OGNWcE5FbmY0T1pFUVdIbGlWdFByc0ZVbDF6MzNBU1Bn?=
 =?utf-8?B?TlR4OFM2TDBmOG1YYkR4K3h5MmlUa2Z3dXRpUlNwMG12NTJxcGlza2lEcGkx?=
 =?utf-8?B?dlM0YVNFTGRTTDRVREdHdE1WZWJzVU5sb3BHWE5jZEk1ckhVQ2JtVGRIa01k?=
 =?utf-8?B?L3NSTnlGRDdrSGJpRFh4SkhoQjIzdlNRYnJmM0pkWDZtcmJwY3dHZmQ5TktK?=
 =?utf-8?B?bk5UVFA4ajZiaGZ3cUp2S2ZDbFhtN091MWt3YkVrWlkrN2w3ZjFxQ3V3V1lS?=
 =?utf-8?B?UFBMVi9jbytsRy9OcnAvTEJhVXdXdlp1N2ZxdGxHZUtMWVBLZHJ1VzNpRFQ1?=
 =?utf-8?B?N1JaQklVc28rbnJPV1hBNkhRRjBDQ0YvRERZUzB0N3hydjluWUNqWnR0R2hu?=
 =?utf-8?B?MUhqYlFkSmFBWG5nK2p4ZitUM3VsTC9LMnRtOWRCYjBlL1dEZ2gwdkRDeEtZ?=
 =?utf-8?B?NW11Uld6VFYzTnZmWnM1K0o1Z0o3ak9adDY2cTgxb1FkeFZrUnZsbFdTOUJm?=
 =?utf-8?B?WmVzM3NmbElOV0I1cWYvK3Y2NzVCS1NZSDhZMENhRkJwNFVFWGF3UTl2RG9Z?=
 =?utf-8?B?ZlJnY0RsVDBJS3ZzdjloTkZZcFZWUk9yWGsxMFl3YitXd0NtVHl1alJzdUNk?=
 =?utf-8?B?d3Q2WE9MMk1QVmlpdUxDdzFKYit1OUtneDFEMjRRQmQzSmYyaDlhb3hQT1M0?=
 =?utf-8?B?b1lyY3dIVlJ5amkwTzAyWElGWWI1akxBS1Bpb1BxWlJyY3E0WGpxS1Z4S3VX?=
 =?utf-8?B?UVpWTUNPOGhOSE5YNCtJQktEUmxoWUVvSWRmNmNDTzlpb0lYNFovRTVqL0h6?=
 =?utf-8?B?NWxCWjBYaDlZWVQ2MlRqSjVPZG5VWkhWSWVEYW80WDd0K1ZPaVJVUkJCZjYz?=
 =?utf-8?B?ckIyL2tDNkduR0RhUDlUSTZVVTE2ZEJQUjNBV3NYZytHZE1ZNEhnUXU5dU56?=
 =?utf-8?B?RENzU2F0VDJWMzN6US9ZNHd0TEEyVEpLcUljVWcyMXpOZ3EwdVNRdnAzK2h0?=
 =?utf-8?B?VXpEbmtmeU5teWowU0dTc3BDa1FTZGIrK2R1TG04cFVHVXFrcklNcHBwWDJa?=
 =?utf-8?B?c0d5VnB4ZmNERGc3d3hBSEhLUTRoSklMN1Y5clJ6anY1cW9mTVU0TUxvNXI3?=
 =?utf-8?B?cGRjV1dCVytKSEt0dmRhSUZaZDRSaGp0cHVwc3EwU0h3QkNudDY1UWtnZXhs?=
 =?utf-8?B?V3h2a3p4WElOR0NWRi9qQkZhZmlla3lRWW5Wd21oTDNyRWZiK1VOZ2sxSC94?=
 =?utf-8?B?OFh1WjZkb21HVCtNM3psZWtVOUdkMEVNY3JST1lBY2RUMDhqc3dGNmd2VWll?=
 =?utf-8?B?TWtrNG0zem04R1BQL0dXTWR1bTBzT2J3TUVqclQzakVvdUk4MUEvOEtuMHBw?=
 =?utf-8?B?WkpmcVFuSDJ3YllET1JFbzlLeUJWaktYM1hkSnAvaVpNc1lGNkV5aU8yTngw?=
 =?utf-8?B?MWNpRXNhV083WVd2MzhuYnpoczVuOUN1ZThpcS8xMlkraktCQ1ZhNjFkL3NS?=
 =?utf-8?B?dVplV2R2Yk96NGdXWWduNWYxaDNQbjBpeVl3SU53Vyt5SWhuREdNbnVWTjJS?=
 =?utf-8?B?WFdaVTdIbDZUazk3TjM3blpaVkx5VXFwaVQ2VXlUTmwvelVvRmdwU041aEdG?=
 =?utf-8?Q?Ls92/gfWCIoku74ZR0w4Zd+b1ug8cw4On5KbaNW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0bd9836-4da2-4ac1-4e4f-08d952425716
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:38:33.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IOqbraI7wspi9FdJOCZxj6bw7Gu+Z8mWod9eMs4Y2fnWX/5KS+/Dzsnlx0C6tEqoLoUnagPsk0EIW8NgeQbWGMfMYSs5X6tDbHAtUd0z+xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-GUID: qcK-47k1K58FboDe8klXmYqGAciQV0HT
X-Proofpoint-ORIG-GUID: qcK-47k1K58FboDe8klXmYqGAciQV0HT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 24 Jul 2021 09:20:10 +0200, Christoph Hellwig wrote:

> SCSI_IOCTL_SEND_COMMAND has been deprecated longer than bsg exists
> and has been warning for just as long.  More importantly it harcodes
> SCSI CDBs and thus will do the wrong thing on non-scsi bsg nodes.

Applied to 5.15/scsi-queue, thanks!

[01/24] bsg: remove support for SCSI_IOCTL_SEND_COMMAND
        https://git.kernel.org/mkp/scsi/c/beec64d0c974
[02/24] sr: consolidate compat ioctl handling
        https://git.kernel.org/mkp/scsi/c/558e3fbe228a
[03/24] sd: consolidate compat ioctl handling
        https://git.kernel.org/mkp/scsi/c/443283109f5c
[04/24] ch: consolidate compat ioctl handling
        https://git.kernel.org/mkp/scsi/c/bce96675091f
[05/24] cg: consolidate compat ioctl handling
        https://git.kernel.org/mkp/scsi/c/2c2db2c6059a
[06/24] scsi: remove scsi_compat_ioctl
        https://git.kernel.org/mkp/scsi/c/6fade4505af8
[07/24] st: simplify ioctl handling
        https://git.kernel.org/mkp/scsi/c/dba7688fc903
[08/24] cdrom: remove the call to scsi_cmd_blk_ioctl from cdrom_ioctl
        https://git.kernel.org/mkp/scsi/c/e9ee7fea4578
[09/24] scsi_ioctl: remove scsi_cmd_blk_ioctl
        https://git.kernel.org/mkp/scsi/c/fb1ba406c451
[10/24] scsi_ioctl: remove scsi_verify_blk_ioctl
        https://git.kernel.org/mkp/scsi/c/4f07bfc56157
[11/24] scsi: call scsi_cmd_ioctl from scsi_ioctl
        https://git.kernel.org/mkp/scsi/c/2e27f576abc6
[12/24] block: add a queue_max_sectors_bytes helper
        https://git.kernel.org/mkp/scsi/c/547e2f7093b1
[13/24] bsg: decouple from scsi_cmd_ioctl
        https://git.kernel.org/mkp/scsi/c/d52fe8f436a6
[14/24] bsg: move bsg_scsi_ops to drivers/scsi/
        https://git.kernel.org/mkp/scsi/c/78011042684d
[15/24] scsi_ioctl: remove scsi_req_init
        https://git.kernel.org/mkp/scsi/c/2cece3778475
[16/24] scsi_ioctl: move scsi_command_size_tbl to scsi_common.c
        https://git.kernel.org/mkp/scsi/c/b69367dffd86
[17/24] scsi_ioctl: simplify SCSI passthrough permission checking
        https://git.kernel.org/mkp/scsi/c/7353dc06c9a8
[18/24] scsi_ioctl: move the "block layer" SCSI ioctl handling to drivers/scsi
        https://git.kernel.org/mkp/scsi/c/f2542a3be327
[19/24] scsi: rename CONFIG_BLK_SCSI_REQUEST to CONFIG_SCSI_COMMON
        https://git.kernel.org/mkp/scsi/c/33ff4ce45b12
[20/24] scsi: remove a very misleading comment
        https://git.kernel.org/mkp/scsi/c/a9705477f552
[21/24] scsi: consolidate the START STOP UNIT handling
        https://git.kernel.org/mkp/scsi/c/514761874350
[22/24] scsi: factor SCSI_IOCTL_GET_IDLUN handling into a helper
        https://git.kernel.org/mkp/scsi/c/2102a5cc1233
[23/24] scsi: factor SG_IO handling into a helper
        https://git.kernel.org/mkp/scsi/c/b2123d3b0987
[24/24] scsi: unexport sg_scsi_ioctl
        https://git.kernel.org/mkp/scsi/c/08dc2f9b53af

-- 
Martin K. Petersen	Oracle Linux Engineering
