From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: libsrp, srp_target_alloc() and srp_target_free()
Date: Sun, 6 Dec 2009 11:18:13 +0100
Message-ID: <e2e108260912060218xc8ffe1ftcd3cc4564fbea495@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37040 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933201AbZLFKSI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2009 05:18:08 -0500
Received: by bwz27 with SMTP id 27so2868921bwz.21
        for <linux-scsi@vger.kernel.org>; Sun, 06 Dec 2009 02:18:13 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hello,

There is an asymmetry between the libsrp functions srp_target_alloc()
and srp_target_free(): the former sets the pointer to driver-private
data by invoking dev_set_drvdata() while the latter does not clear
this pointer. So once srp_target_free() finished invoking
dev_get_drvdata() will return a dangling pointer. Would it be a good
idea to add the following statement inside srp_target_free() just
before this function returns ?

dev_set_drvdata(target->dev, NULL);

Bart.
