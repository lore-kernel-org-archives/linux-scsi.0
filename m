From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/4] scsi: qla2xxx: Convert timers to use timer_setup()
Date: Tue, 31 Oct 2017 12:13:45 -0700
Message-ID: <1509477229-62141-1-git-send-email-keescook@chromium.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:44758 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753853AbdJaTN6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 15:13:58 -0400
Received: by mail-pg0-f45.google.com with SMTP id j3so44163pga.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 12:13:58 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <Himanshu.Madhani@cavium.com>
Cc: Kees Cook <keescook@chromium.org>, Bart Van Assche <bart.vanassche@wdc.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This breaks out the logical steps to convert the qla2xxx timers:

1) init_timer() -> setup_timer()
2) refactor qla2x00_start_timer() to not pass callback as argument
3) qla2x00_timer() to use timer_setup()
4) qla2x00_sp_timeout() to use timer_setup()

The resulting diff is identical to the patch that appears to lock up
the driver. This should help identify which step causes this behavior.

-Kees
