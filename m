Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6D8C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5109A611B0
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:45:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhIVErC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:02 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:8710 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231686AbhIVEq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:46:57 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M4QgFV027984;
        Wed, 22 Sep 2021 04:45:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ew39my1FLsZU4QKbVgFtqtkzwT5Wr0TSTt0Hdd3KIRM=;
 b=suCrZ9QEduS0XvJHloYZ/s0xygJAgkFeio3b9qT+5BUH5iWsXTlW1RqwP0rVrjUem6kC
 tQdQPHs5wal+JoH/LdCDGoBRbfnXf1MvnBvC5ILMxWUF0TbAdrjltX04I1/vJ42Vh7N/
 PJPv96Y4oFyj4sOUdZSaq/9HVtPMIW2SzBv+NVAFw41t1YkxSI9adsUaq5EG5WtoPb41
 H1A0v1HOADOEBK0tnTV6WMkZZnHFQLxz3P4P3qytojnvfzfQ8wrB5KrHlaIeqUUU8a8s
 70vTOAfcWXmIGEbiGOp8r41ObID+zz1/GlTcv69FS4FNnfQ+/c9ch7DdrCPA29yZJDHU Ww== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4r9d7a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4ZZLm145589;
        Wed, 22 Sep 2021 04:45:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b7q5mc79u-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHpXE3NcGFHyOrzIi+ip0KEfq6sBLCVfuXECbQRXEUtRt2093o98ylcmIFwSBsY/b+GPGaINpHyzUQPhcPAMtpqwkeQU9psMlt9g/hJetkFvY9o/TZjHnjFWV+N6tz3pPYvMPWkQkHfDu1NmodsAd7LZWM9+ix7v0o0e5hxrraGWK4YKG7qsv0/UWlWk5pNgmGY1Yhj3LeLAowT7I+r7LDGDDRwlMBJYfD7vWa+R8qwNHO4nGQGd7MQ84hRgYsGhZWYFah1+YbQAVK1+fLs2rIMcWQQxkiJa271KIsl10fK5uG91/WqwinA1OO3kQNHSNiI3vVgb+H3KjquCDmit1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=ew39my1FLsZU4QKbVgFtqtkzwT5Wr0TSTt0Hdd3KIRM=;
 b=euuGCdhM2UdkkG4wqwZ4J8Z47VMNeYL+Kl6M/wl6uUrkMg+ERK8TO0AqwbmRtAbzNTDUshFJm8FPAuEhPnKK+aCjmG82WMsf8IlolJ6WBXT1gX2WeH9Xa18CXIoCriGqcATTyiAm5/u78ai5lbGt/EUkUScJfyv2qaD+zYdJXN25ymSwRmFYd6uPrX0O68Qxt+YNa0k4RFVN3dsjdEECcjTnEY+aEJmtnTcsr6XTgysBRXXNG+4rxhqyaQk1jXTcIhQJR9a5+hT3dxm1nMlKXmakU47josSJ0ORQIhPbtU7mZrCLynIjQ9pvhF4tpu9lforaA2jq9pfu8o+1qoqbyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ew39my1FLsZU4QKbVgFtqtkzwT5Wr0TSTt0Hdd3KIRM=;
 b=arI3tKRNCw0KPs0iOYOou3UgonJt0QsiOmjs0htr0o4+qMUmCOqV+twhKA8euG/RRch5C6V6TekUMaXLNxd9nt1NEYxAh7j3SANkXk4birrDY6GEw3NU/fpTJwkxrQVfs0Tm0T6iWv+1uoVjOlJXARXJQEzDZCOI/anN7K4Nk1o=
Authentication-Results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4518.namprd10.prod.outlook.com (2603:10b6:510:38::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 04:45:04 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:04 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux@armlinux.org.uk, John Garry <john.garry@huawei.com>,
        hare@suse.de, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/3] scsi: remove last references to scsi_cmnd.tag
Date:   Wed, 22 Sep 2021 00:44:51 -0400
Message-Id: <163228551952.26896.5878397565348027959.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
References: <1631696835-136198-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA9PR13CA0050.namprd13.prod.outlook.com
 (2603:10b6:806:22::25) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0050.namprd13.prod.outlook.com (2603:10b6:806:22::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 04:45:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9ed0c666-c0ed-4ebd-fc34-08d97d83beb0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4518:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4518B46389AAEFAAF06DB07E8EA29@PH0PR10MB4518.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mCPRFG1u7WXyUCIsSq5J+ZFrsBYPXJcNeQWFxwbEwnOZUlyrXD5Xz031XdcJuXj6Re6DaajypzP7vYjGaIGtWDESEBWZ1x+B+n5RcsQP5T6eZXyJFWrL9SqPszjXk54e8M8+uLGAYN3Y7GoDmJVygcwZfCVmcnxlDxUUTKg0hZhEYeu2cl5GuXZ9z46qibTHIRCRDM1F24rG35BJlHFvf6oAKYHjPPb650P0dQHTLCK9Sf2h+qCuaedFT4YAepxH8OX28WIwKF8DWYuVSlV0TbArlc5hsH/DAy1GZscnZLMVYAiiBN/aAEOAQCbvBVdx1TsgqiPdzGHyWXoH7bkKRnpD7JDiSCdQxhd0yj6tTmRsUTS+gobLUWywJvwzZXs+BryzEdEEI9QbpjZh8VO/lgWKPMk3qlr0q6xP6psOCGVJHiycX0usxGOflrIhpMOaeIs8HX83seIeVHtyI8VCyxZEZicxtlO5zEYnfKUMSUtOin3w6vCXxMXQ62VIIrSwhBPhyuYarABbqP93PkKrD4S+bcphHQV8Xyura0CqBO8fVWysgewRLVUbXLw9MNXihepHEUR07Thm79mx2qVNrAUgOTnwtn2QM0IfmVFrU1/7vlwIGjL7JoCn4bdUE8EZll2JVc4XoKQZZxyYmHokVnWB/hDftuNHrAojFrmmVa5RV12IrVEkdh7fTN8bZSdSOtr2Liq/oed94WfSw4XscT1yNvmjQ5ugWjYx7/5iubhl8hoQg/M/i0e3P70t8yRMuIyyChvV/rPIUwXOxZhq9MY3ycLxZ2I7Je6omRjLZYu3ARZHQ8yfjeX7PJzBPyCN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(186003)(2906002)(86362001)(66476007)(83380400001)(38100700002)(316002)(103116003)(4326008)(7696005)(8676002)(52116002)(5660300002)(66556008)(4744005)(6486002)(2616005)(966005)(8936002)(508600001)(6666004)(956004)(38350700002)(66946007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TkFlY2lqak16UDlUbVRKVDNkS01sSTF1ZXNDWnZDV2hxNlh3Si9ZS0ZQdDJx?=
 =?utf-8?B?UHQrcW5raXlROEZDRGxtSVd6SnF6UVJBTEM0RGlUd2xRRmRzN0RKRElEcE1k?=
 =?utf-8?B?eGIzYkpaelg3T0IzWW13RTlqejh1VWplZW9ndU9tVW94V0J0WnExL21USHJZ?=
 =?utf-8?B?U3RSSmNKTkM0czhNZjUzbVBTeU94TnpybWdOYWFvUHNqY1dZeGpOOEFGVjN0?=
 =?utf-8?B?K1N3L1RoK0U2WE0zN3N2WWgrc05GYWhuSE1JU2xiNjJDeFplWUhqTWkra3dL?=
 =?utf-8?B?d3NnQzh1VlEySzBFSisxTGVhWTVsczhBOUZCVDY5WTQxNDErWlFnbUUxc3Zm?=
 =?utf-8?B?NDFaY0F1dlJURW4vMUtYNy9lWHVUYnNxb3FRUjZVNlpzUk9JSTdCd3dRYnR0?=
 =?utf-8?B?cXRScVlNdXpsRnhVMFFBMmd0dXFYS01wK2I3SUxlclBLZnFCNXZDeS83SXIz?=
 =?utf-8?B?WllZYU4rbzZSNkJRbmFKeGJCN3pOdk9Eazd1aVZUekljbVUzcDVtc3J5QWZi?=
 =?utf-8?B?d2hWeEErSzVaTXBzK0V5akxndDh3Tkx4WjFHMVEwalpnMFh5RGdNSWw0ZnZ5?=
 =?utf-8?B?OXZ1Q2FlYTVncFp5T2tIWVo5UmdLYWNhdEpFbmhocERleG5NM3N3czVDeUE0?=
 =?utf-8?B?U09rSkswdW1kS3BlNjNGRTZMYjF5OThybjZySEd5MFhBajFmb2JpWDh4OE01?=
 =?utf-8?B?VGhqQ2JmamFseHVJVTNQNlhobnUrTGtLUE9aQW15azlacWE3bnRXREp2MG5N?=
 =?utf-8?B?WFVvcVNsaTlsWGhzYlZWa0JaS3NnbFRJRk5uTmhJQVBFSHVKbjZvSmFiTTF4?=
 =?utf-8?B?MVNlS3ZPYnQ2RS8vUG9DOE5NS3RVZzFZWEVXNk82LzZvKzhrSWtBWWtPZVI2?=
 =?utf-8?B?MndhMmFacThlbm1kV25WR2srRnJzdVU0Q2FBOFgwOStPUnppUGNUSVVkRGJa?=
 =?utf-8?B?VHVoeFpMcUp5emZzLzMxOTFBSUZ0WFlrMUFaMGt3MTFmdCtIVzJ6dWdGNWth?=
 =?utf-8?B?WVdrUEwzU0xWSlZmalY2M05adVQ4V2tHV3Q3b0FXMTJVS0tXNDR0U3pBNnJi?=
 =?utf-8?B?WVBnSGxTaTBKcnVLVkxvYVlsckx6UVQ5cHFUWmp5R013VFZNbEtmZHV3bzVr?=
 =?utf-8?B?S3dibTEvR1BsdmYzWXFaSkQ1SC9ud0tFQkhLc2hNODl3NHZtV2p3WG83Wnl5?=
 =?utf-8?B?MHNrZVlybStINWpQK0QwTmQ2T09VM1IvTlQyckJVWUVTNXRqenJ5OGRnREJp?=
 =?utf-8?B?VFBHZU5PK2FzNUtxTEpvcDlIVUpCYm5rYk54T0FhcVR2b3NoaUUwMU10V2RW?=
 =?utf-8?B?cXdUMXRaREY3ckRYTnF4QmV6QXlYTWQzZnIxaXJ4TlMwN05acWZxRlh4K045?=
 =?utf-8?B?OTNGMnRYRnlLNWg1aEtQTHlLa3NRT0dlRFVPRzFJczZxZm8rQmdvRkUyUWNN?=
 =?utf-8?B?T3R2ZmZCKzg4Z254Zk9Uc0w0Rm5EbDV0cGMvSnNQa3RWL05IVUtyRklvSi92?=
 =?utf-8?B?NWNvREVUWVNwNzM0U2grTDhsQ2Y1T1lTT3lndVppdkpKMXlOaHo0Z1dtdWlu?=
 =?utf-8?B?Yk9TQ25qZHJvSXByMWhxNXhTQUs1RHlieGtFMm9mRGlLeXpLd2dHVU0xY0pB?=
 =?utf-8?B?MVdJZHdydDRRd3k3YnVDT1ZTei9CVm5tVnpiWkNMRzhUMTFUK3g4SVI1RmZ2?=
 =?utf-8?B?TXIxdXZnRmQxVnJiaU1Ha1JUSk5wRktnTWduMVVVZ3dPNXgzRksyZXpya2JE?=
 =?utf-8?Q?OGjrvbH+IfRoXRfeJAODPpOcrzh9Q4rFjNDYOO+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ed0c666-c0ed-4ebd-fc34-08d97d83beb0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:04.4467
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4hUcGX4MkpaEGv9LPOgSolhPihqrulScvLVXDlFCD+8vZ0mSbl/JfV9NePLpvIAV8CAM0hQOD9RUNfdilcZg0WQqqlOcAya4+K+jCB9d68Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4518
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220029
X-Proofpoint-GUID: BD9lv5xM5rd_vx8q6qnU0UFF96kpJnJL
X-Proofpoint-ORIG-GUID: BD9lv5xM5rd_vx8q6qnU0UFF96kpJnJL
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Sep 2021 17:07:12 +0800, John Garry wrote:

> This is v2 of Hannes' series to fix the build errors from removing
> scsi_cmnd.tag. Here is the original cover letter:
> 
> "with commit 4c7b6ea336c1 ("scsi: core: Remove scsi_cmnd.tag") drivers
> cannot reference the SCSI command tag anymore.
> Arguably these drivers would have stopped working since 2010 with
> the switch to block layer tags in SCSI anyway, so chances are no-one
> had been using tagging in these drivers.
> 
> [...]

Applied to 5.15/scsi-fixes, thanks!

[1/3] fas216: kill scmd->tag
      https://git.kernel.org/mkp/scsi/c/bc41fcbffd57
[2/3] acornscsi: remove tagged queuing vestiges
      https://git.kernel.org/mkp/scsi/c/756fb6a895af
[3/3] scsi: remove 'current_tag'
      https://git.kernel.org/mkp/scsi/c/a4869faf9642

-- 
Martin K. Petersen	Oracle Linux Engineering
