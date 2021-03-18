Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27845C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:34:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFB2464F2B
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 19:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232642AbhCRTdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 15:33:43 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:44832 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhCRTdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 15:33:19 -0400
Received: by mail-pl1-f178.google.com with SMTP id q11so1814347pld.11;
        Thu, 18 Mar 2021 12:33:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vF60li03DLVeGdeABiyKCpKx18oxi8Zc2f6uqd8W8yg=;
        b=NVhG6puBq9ML23QI4KIUNrN2VetdX7hLAnNHBxrZNTT6/KlorZMY03Sp55K+upBaji
         +2+t0l1V6gfIKgBuX516W2IS7OEzfzP/Luv4aJjvSNb7f21qNvd9C/DKFMJe/zrcWsp9
         QS453rQbLarJYk80UU2Kbioqrx9gHrPI7TgAA96sJUexZ2huHfYIEBSs8t6s07MX1rmH
         7ntonw/Xx6kW1Q+upDSH/I1s0v16+eTV3+bqAI+Yo8o74pE75yFejkCD5dSC9aaT23WA
         A12kDlYO4WIrizxCCrP50+ev8l1eziU7Q1SfGPHkUan3HeUiKAqDPGfgdOuKP/0TdTTm
         IGMw==
X-Gm-Message-State: AOAM530hquAgACli7932nzYdK/+1YOsYb5+JnW1BS+NKb6OsDcDsIE88
        m2nN6ssG+jCFe4wPr3nHqs8=
X-Google-Smtp-Source: ABdhPJwfN8pJrLzPOgxtMiOAR8T0Up5Bms9q6yY0x0u3lwslTgE8/8LpdkZv/Jw/qiQOkbjETNcMAg==
X-Received: by 2002:a17:902:a606:b029:e6:4c7e:1cba with SMTP id u6-20020a170902a606b02900e64c7e1cbamr10802226plq.46.1616095998733;
        Thu, 18 Mar 2021 12:33:18 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id w188sm3207891pfw.177.2021.03.18.12.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 12:33:17 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 0508E40244; Thu, 18 Mar 2021 19:33:17 +0000 (UTC)
Date:   Thu, 18 Mar 2021 19:33:16 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        dgilbert@interlog.com, hare@suse.de, mcgrof@kernel.org
Subject: Re: blktests: block/009 next-20210304 failure rate average of 1/448
Message-ID: <20210318193316.GS13911@42.do-not-panic.com>
References: <20210316174645.GI4332@42.do-not-panic.com>
 <20210316184739.GJ4332@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316184739.GJ4332@42.do-not-panic.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 16, 2021 at 06:47:39PM +0000, Luis Chamberlain wrote:
> On Tue, Mar 16, 2021 at 05:46:45PM +0000, Luis Chamberlain wrote:
> > I've managed to reproduce blktests block/009 failures with kdevops [0]
> > on linux-next tag next-20210304 with a current failure rate average of
> > 1/448 (3 counted failures so far).
> 
> Confirmed on next-20210316 with current failure rate at 1/1008

Just in case this was a scsi_debug issue instead (I am covering that
prospect on another bug just for scsi_debug korg#212337 [0]) I tried
a userspace solution based on what I have observed I still can reproduce
this block/009 failure. The failure rate is much lower though, I have it
now at 1/1705 but alas it is still failing.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=212337

The patch below demonstrates the exra settle work for scsi_debug
attempted, and with it, this is still failing. So either the settle
work needs *more* effort, or this is a real issue.

diff --git a/common/scsi_debug b/common/scsi_debug
index b48cdc9..ecdbcc6 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -8,13 +8,42 @@ _have_scsi_debug() {
 	_have_modules scsi_debug
 }
 
+# As per korg#212337 [0] we must do more work in userspace to settle
+# scsi_debug devices a bit more carefully.
+
+# [0] https://bugzilla.kernel.org/show_bug.cgi?id=212337
+_settle_scsi_debug_device() {
+	SCSI_DEBUG_MAX_WAIT=10
+	SCSI_DEBUG_COUNT_WAIT_LOOP=0
+	while true ; do
+		if [[ -b $1 ]]; then
+			SCSI_DEBUG_LSOF_COUNT=$(lsof $1 | wc -l)
+			if [[ $SCSI_DEBUG_LSOF_COUNT -ne 0 ]]; then
+				sleep 1;
+			else
+				break
+			fi
+		else
+			# Let device come up
+			sleep 1
+
+			let SCSI_DEBUG_COUNT_WAIT_LOOP=$SCSI_DEBUG_COUNT_WAIT_LOOP+1
+			if [[ $SCSI_DEBUG_COUNT_WAIT_LOOP -ge $SCSI_DEBUG_MAX_WAIT ]]; then
+				break
+			fi
+		fi
+	done
+}
+
 _init_scsi_debug() {
 	if ! modprobe -r scsi_debug || ! modprobe scsi_debug "$@"; then
 		return 1
 	fi
-
 	udevadm settle
 
+	# Allow dependencies to load
+	sleep 1
+
 	local host_sysfs host target_sysfs target
 	SCSI_DEBUG_HOSTS=()
 	SCSI_DEBUG_TARGETS=()
@@ -43,6 +72,10 @@ _init_scsi_debug() {
 		return 1
 	fi
 
+	for i in $SCSI_DEBUG_DEVICES ; do
+		_settle_scsi_debug_device /dev/$i
+	done
+
 	return 0
 }
 
