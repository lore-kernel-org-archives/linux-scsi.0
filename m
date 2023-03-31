Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B76C761A6
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 16:31:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjCaQby (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233180AbjCaQbi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 12:31:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6821823FD5
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 09:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680279984;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=AvuVQhbB6sQNpw8Mymcj39/nOL4/GBRsblrkJXNADLc=;
        b=fetSo+NnRYsTTW4NnK34EfNShN3hoyrhXklV5XrKyyv+2GLg+ybZbDtJFy56lRJ5gZM/iu
        BA3POylgWD27Lv00jdT2rZMvVWl455bB6OxPjX+MRN5PXjvfTafOfvReVJYnqepD5CDCRv
        h95VwAXEI2glldiPmYam9buUH8UFMf0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-Z9PmePWDODerdH2fgv-PeQ-1; Fri, 31 Mar 2023 12:26:21 -0400
X-MC-Unique: Z9PmePWDODerdH2fgv-PeQ-1
Received: by mail-qk1-f199.google.com with SMTP id o63-20020a374142000000b007467ef381beso10739310qka.16
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 09:26:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680279980;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AvuVQhbB6sQNpw8Mymcj39/nOL4/GBRsblrkJXNADLc=;
        b=dZKetiBf4kpN/XyU1LLkBjA/+VEopEdF9Tk2f4w2UlFZHyMAlsdld5sJPtoUqPWKvt
         a0+OT0yeZvQ4CTS9DrYay4+dKfq41LA8lpfVQ1A/W25Ted9djY1vjmQ3BvdNklvwu5xy
         BpZXlRohSR/BD7NkRAyEpmZXLAeejpLrQ5S0HRd8zt109lubnDVRUNUsif07dV525szr
         00OG0oSWGmuLfKMwIxarO1boPzCRaDK0Di+Rl3mp7C04Qq9Rn5BdY6oR6AYbI6lPVP5n
         oxDJbMW6SnviFAhnP9AweLBFYAnQLLjtHKzTGeQaw3GSfW+jBvDc7y509XxgKZ+KgcNo
         WomQ==
X-Gm-Message-State: AAQBX9dByCv7DTynNliOBQK1dH7WhVTjeL63IInvXSu4l7oJ+cZfLPN2
        dIU9Raomqe5/9YfAPfSzwHMpfieaVTv2vDK6ykaQmQt4epFrCmUf6O4sFOtK1mouJPUGZb7UeaQ
        Rf+Co3mrYgEWd9iRU/wROTg==
X-Received: by 2002:a05:6214:29e6:b0:5c4:2d5b:9ecb with SMTP id jv6-20020a05621429e600b005c42d5b9ecbmr45686510qvb.44.1680279980622;
        Fri, 31 Mar 2023 09:26:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350YD0+MFLtyL0hz01T2VfOCtBoAHzNkgeAtkgnyc80Jt1xyT6cWzJEU09c2avvC5ytNcGXvx6g==
X-Received: by 2002:a05:6214:29e6:b0:5c4:2d5b:9ecb with SMTP id jv6-20020a05621429e600b005c42d5b9ecbmr45686486qvb.44.1680279980365;
        Fri, 31 Mar 2023 09:26:20 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id j2-20020a0cc342000000b005dd8b93459esm711514qvi.54.2023.03.31.09.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:26:20 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] scsi: message: fusion: remove unused timeleft variable
Date:   Fri, 31 Mar 2023 12:26:17 -0400
Message-Id: <20230331162617.1858394-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

clang with W=1 reports
drivers/message/fusion/mptsas.c:4796:17: error: variable
  'timeleft' set but not used [-Werror,-Wunused-but-set-variable]
        unsigned long    timeleft;
                         ^
This variable is not used so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/message/fusion/mptsas.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 86f16f3ea478..d458665e2fc9 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4793,7 +4793,6 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
 	MPT_FRAME_HDR	*mf;
 	SCSITaskMgmt_t	*pScsiTm;
 	int		 retval;
-	unsigned long	 timeleft;
 
 	*issue_reset = 0;
 	mf = mpt_get_msg_frame(mptsasDeviceResetCtx, ioc);
@@ -4829,8 +4828,6 @@ mptsas_issue_tm(MPT_ADAPTER *ioc, u8 type, u8 channel, u8 id, u64 lun,
 	mpt_put_msg_frame_hi_pri(mptsasDeviceResetCtx, ioc, mf);
 
 	/* Now wait for the command to complete */
-	timeleft = wait_for_completion_timeout(&ioc->taskmgmt_cmds.done,
-	    timeout*HZ);
 	if (!(ioc->taskmgmt_cmds.status & MPT_MGMT_STATUS_COMMAND_GOOD)) {
 		retval = -1; /* return failure */
 		dtmprintk(ioc, printk(MYIOC_s_ERR_FMT
-- 
2.27.0

