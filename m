Return-Path: <SRS0=e+HO=7P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2153DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 12:13:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 080E1205CB
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Jun 2020 12:13:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFBMNy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Jun 2020 08:13:54 -0400
Received: from m4a0072g.houston.softwaregrp.com ([15.124.2.130]:55198 "EHLO
        m4a0072g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725940AbgFBMNx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Jun 2020 08:13:53 -0400
Received: FROM m4a0072g.houston.softwaregrp.com (15.120.17.147) BY m4a0072g.houston.softwaregrp.com WITH ESMTP;
 Tue,  2 Jun 2020 12:12:28 +0000
Received: from M4W0335.microfocus.com (2002:f78:1193::f78:1193) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 2 Jun 2020 12:12:34 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (15.124.8.10) by
 M4W0335.microfocus.com (15.120.17.147) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 2 Jun 2020 12:12:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O5IHjzvzD8ZjwGcYQXj/tChQAW2W6yXRcyi3M7vD/8DK7FBJM7Q8PCR2f2Ymgc6j9H8Kkb4/E28j9TFfBuVhIScZV9oMm0uMBkLeCS2/oScQvWf40WViKpR0i5zqzxqbjb5T4gEpfjbyiDG4lLFptYGMXLt5NvtoV+I9WVQVfZ/TGykiEvIIQG0CSIsGv3Rei0yizHCP8U96qdeBnOsanQldtuObxWhM5TIoWQ5xIVeu8AyCr+m8ux/8fSY22yOcDPUXRVk4W060n15ds7BfO/RFtnr22QEbyY5OODh4JT5N1EHxBXkANRhiHsmbNEqIhKILABeuyNeHRglO9HkGQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D+JjmCMUzUrwZobVBqGkk3omJ+aSdCqSmz6HXykLp90=;
 b=lgTe/hrK+cRGc7A178tYYCH6gLJX5UvT9NyZONnUOlSnCK8BstvvQYP93UPqedI20EsYL6UvTGp9Axu5jsa4TPSYCgzoODi4Ka7UK/kK5yHWjGAAPHnSCI+66Ga85PfBRZkFYi2Bt97TL/dUWzyu6c61bEvRpRWStkLZtC2anMCEYc+nLZgt36KeuXzUQvmozbyaeG76ny7leGEuqIgHa9vdDdOEtMLf5yKUwZ737FRdLszL2acLVMs3TFX8kr7bfiFkq0VjnAGGPt3qgXyQRKY18aftj+L5Er53xqWViAbDcaWo5dw3sWPuvB5csBO9hRbz/hBma3sfSTCcsuadqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=suse.com;
Received: from MW3PR18MB3658.namprd18.prod.outlook.com (2603:10b6:303:54::24)
 by MW3PR18MB3689.namprd18.prod.outlook.com (2603:10b6:303:5e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 12:12:33 +0000
Received: from MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d]) by MW3PR18MB3658.namprd18.prod.outlook.com
 ([fe80::2da0:153f:7d56:210d%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 12:12:33 +0000
Date:   Tue, 2 Jun 2020 20:12:25 +0800
From:   Kai Liu <kai.liu@suse.com>
To:     <xiakaixu1987@gmail.com>
CC:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Xiaoming Gao <newtongao@tencent.com>
Subject: Re: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused by
 JBOD
Message-ID: <20200602121225.okhqr2xitv6522pp@suse.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
User-Agent: NeoMutt/20200501
X-ClientProxiedBy: HK2PR02CA0212.apcprd02.prod.outlook.com
 (2603:1096:201:20::24) To MW3PR18MB3658.namprd18.prod.outlook.com
 (2603:10b6:303:54::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (113.116.107.68) by HK2PR02CA0212.apcprd02.prod.outlook.com (2603:1096:201:20::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18 via Frontend Transport; Tue, 2 Jun 2020 12:12:31 +0000
X-Originating-IP: [113.116.107.68]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: caba565f-272f-4b3e-ffdb-08d806ee39cd
X-MS-TrafficTypeDiagnostic: MW3PR18MB3689:
X-Microsoft-Antispam-PRVS: <MW3PR18MB3689C7E6BFE5DC47512D6919988B0@MW3PR18MB3689.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T1XU9JyPRxx044O2kPMNmLB35KGS3tqfeBD7ENB1dMyhJBZ1hn5K+mj9TahfMXX4hMGF0bXvBR+OyMdto7GVPxUJ6aPkp9C4MwYOfkIW26K2GCSjaR4RP6OoHa4YXcaP23kcqFduEPsgcN4fpxWmHmEJGVtDoWIhL14RtW8hvN4uJC7TGcccS/KZL+IsnRNOG3M2kDcLgYlISNbi95nUKJYLRFGwg7PgrVcn13s6arsIadFs8iIATIvnASpVfGV0uBBwAF0wescDuHmac9FNL8vokX+EBoa/Ea7xbH+DyOjx9MoAEW92wr5uMV5WCBKeSJzmdItXE8FQwXJxbv90c08FWCtbdnhojyX7W863uGMK6mB1am8+hzRBd5wHOceP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR18MB3658.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(39860400002)(396003)(136003)(52116002)(86362001)(66946007)(5660300002)(4326008)(66556008)(66476007)(478600001)(6496006)(8676002)(2906002)(6916009)(6666004)(2616005)(956004)(83380400001)(44832011)(8936002)(186003)(16526019)(316002)(26005)(6486002)(1076003)(36756003)(357404004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ZkDW7ODZqqoAYZC3U2scuZsvCS44bqIMeEQUE8GQytNxP44SNJgbTn/HqIkh0WV0wSxShlIWLfHgoYZqQAfDSmgiLPsu7PM9UVPAZkVwep+aPIjdH7amVYUCkJrB6JCYTbMMQHtv1r4Q6qSxJEAEVK0ltbomqVxkr9vqZ13OneiBURjf47LjJtQblhu5Ymf9wwxeMmJtEOtQTVdbjHyMjkrJZQDC++6Uueikrc4CVRBuKO4gSW3vS7T8y3jhMlDq/0c8amlWQY5zcNBqv3YUjcokHzVteeYoxFGVAG2IeoQ6XtSOkUSBPLyylcB08op8VhU80rDpkXQoLD2HC/PG9mJ0BPORoqXsWSJmLk2jj1dqwWYxTA3eybdmbFU9NnIGz9EBbhPh9cpPXL3UMXww4FzIjmfPBUn7Bw3M9aHL6546Pe7dtdRgSXmJ8rCaPrW8jv4iK6es8rMtbEGOW681eNX9yf8enjV6GaJGYHKEJ48ROVpdL3jFFMfHX/2qmsz1
X-MS-Exchange-CrossTenant-Network-Message-Id: caba565f-272f-4b3e-ffdb-08d806ee39cd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 12:12:33.1948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKRFZCDvzZMlrM/DfL4eRfqjqMXqq8ZRe5i0t9r2iwLqOyIQVGFXB/T2/+13bE2H+au4ehu/t5fPvLCtLxRTVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3689
X-OriginatorOrg: suse.com
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/05/28 Thu 15:31, xiakaixu1987@gmail.com wrote:
>From: Xiaoming Gao <newtongao@tencent.com>
>
>when kernel crash, and kexec into kdump kernel, megaraid_sas will hung and
>print follow error logs
>
>24.1485901 sd 0:0:G:0: [sda 1 tag809 BRCfl Debug mfi stat 0x2(1, data len requested/conpleted 0X100
>0/0x0)]
>24.1867171 sd 0:0:G :9: [sda I tag861 BRCfl Debug mfft stat 0x2d, data len reques ted/conp1e Led 0X100
>0/0x0]
>24.2054191 sd 0:O:6:O: [sda 1 tag861 FAILED Result: hustbyte=DIDGK drioerbyte-DRIUCR SENSE]
>24.2549711 bik_update_ request ! 1/0 error , dev sda, sector 937782912 op 0x0:(READ) flags 0x0 phys_seg 1 prio class
>21.2752791 buffer_io_error 2 callbacks suppressed
>21.2752731 Duffer IO error an dev sda, logical block 117212064, async page read
>
>this bug is caused by commit '59db5a931bbe73f ("scsi: megaraid_sas: Handle sequence JBOD map failure at
> driver level
>")'
>and can be fixed by not set JOB when reset_devices on

I've recently run into this exact issue on a arm64 machine with Avago 
3408 controller. This patch fixed the issue. Thank you.

Tested-by: Kai Liu <kai.liu@suse.com>

Best regards,
Kai

>
>Signed-off-by: Xiaoming Gao <newtongao@tencent.com>
>---
> drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>index b2ad965..24e7f1b 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>@@ -3127,7 +3127,7 @@ static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
> 		<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
>
> 	/* If FW supports PD sequence number */
>-	if (instance->support_seqnum_jbod_fp) {
>+	if (!reset_devices && instance->support_seqnum_jbod_fp) {
> 		if (instance->use_seqnum_jbod_fp &&
> 			instance->pd_list[pd_index].driveType == TYPE_DISK) {
>
>-- 
>1.8.3.1
>

