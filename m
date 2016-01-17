From: "Lev Vainblat" <lev@zadarastorage.com>
Subject: Device is not becoming offline on failed TUR
Date: Sun, 17 Jan 2016 12:54:04 +0200
Message-ID: <B653F0B7F68442D997F563AE5C6D634D@levpc2>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="windows-1255";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:33418 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbcAQKyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jan 2016 05:54:14 -0500
Received: by mail-wm0-f54.google.com with SMTP id 123so20138936wmz.0
        for <linux-scsi@vger.kernel.org>; Sun, 17 Jan 2016 02:54:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Yaron Presente <yaron@zadarastorage.com>, Alex Lyakas <alex@zadarastorage.com>

Hello,

We have a virtual target that under some circumstances returns 
HARDWARE_ERROR (4/44) on TUR. Previously on initiator side 
scsi_check_sense() returned TARGET_ERROR, that in scsi_eh_tur() was 
converted to 1 (device not ready). And then scsi_eh_ready_devs() called 
scsi_eh_offline_sdevs to move device to the OFFLINE state.

In commit 
http://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=87f14e6 
this logic has been changed. Now on HARDWARE_ERROR scsi_check_sense() only 
sets DID_TARGET_FAILURE and returns SUCCESS. As a result device remains 
"running", and scsi_eh_flush_done_q() doesn't finish the command but retries 
it. So in this case it takes for the stuck command much more time to finish.

Am I missing something? Is it a bug or intentional new behavior?

Thanks,
    Lev. 

