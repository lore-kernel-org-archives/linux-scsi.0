From: Tom Yan <tom.ty89@gmail.com>
Subject: RFE: sdparm: return mode page "Write parameters" for only MMC devices
Date: Tue, 12 Jul 2016 20:43:51 +0800
Message-ID: <CAGnHSEkgxu+eep7yjuOc2H-m8nWKgB7VZqXf9Aw_Mxbv0w9pwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:33501 "EHLO
	mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933130AbcGLMnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 08:43:53 -0400
Received: by mail-qk0-f176.google.com with SMTP id p74so12192799qka.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 05:43:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

Since version 1.10, sdparm would return the mode page "Write
parameters" if the MODE SENSE data from the device has a 05h mode
page. However, the page number was also used for mode page called
"Flexible geometry":

[tom@localhost ~]$ sudo sdparm /dev/sdb
    /dev/sdb: SanDisk   Ultra II 240GB    0
Write parameters (MMC) mode page:
  BUFE          0  [cha: n, def:  0, sav:  0]

[tom@localhost ~]$ sudo sg_modes /dev/sdb
    SanDisk   Ultra II 240GB    0      peripheral_type: disk [0x0]
Mode parameter header from MODE SENSE(10):
  Mode data length=40, medium type=0x00, WP=0, DpoFua=0, longlba=0
  Block descriptor length=0
>> Flexible geometry (obsolete), page_control: current
 00     05 1e 00 00 10 3f 02 00  3f ff 00 00 00 00 00 00
 10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00

Therefore, it would be nice if sdparm can be made to return the mode
page "wp" only when the device is an MMC device (PERIPHERAL DEVICE
TYPE = 05h).
