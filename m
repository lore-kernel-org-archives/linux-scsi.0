Return-Path: <SRS0=Nn94=DV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A91C433E7
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 21:57:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD05F2222A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Oct 2020 21:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgJNV5K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:57:10 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:32791 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726035AbgJNV5K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Oct 2020 17:57:10 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2020 17:57:09 EDT
Received: from [192.168.0.3] (ip5f5af44e.dynamic.kabel-deutschland.de [95.90.244.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 750442064621D;
        Wed, 14 Oct 2020 23:47:06 +0200 (CEST)
To:     Don Brace <don.brace@microsemi.com>
Cc:     "James E. J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, it+linux-scsi@molgen.mpg.de
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Linux 5.9: smartpqi: controller is offline: status code 0x6100c
Message-ID: <bc10fad1-2353-7326-c782-7a45882fd791@molgen.mpg.de>
Date:   Wed, 14 Oct 2020 23:47:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Linux folks,


With Linux 5.9 and


     $ lspci -nn -s 89:
     89:00.0 Serial Attached SCSI controller [0107]: Adaptec Smart 
Storage PQI 12G SAS/PCIe 3 [9005:028f] (rev 01)
     $ more 
/sys/devices/pci0000:88/0000:88:00.0/0000:89:00.0/host15/scsi_host/host15/driver_version
     1.2.8-026
     $ more 
/sys/devices/pci0000:88/0000:88:00.0/0000:89:00.0/host15/scsi_host/host15/firmware_version
     2.62-0

the controller went offline with status code 0x6100c.

> Oct 14 14:54:01 done.molgen.mpg.de kernel: smartpqi 0000:89:00.0: controller is offline: status code 0x6100c
> Oct 14 14:54:01 done.molgen.mpg.de kernel: smartpqi 0000:89:00.0: controller offline
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:2:0: [sdu] tag#709 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:15:0: [sdah] tag#274 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:4:0: [sdw] tag#516 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:4:0: [sdw] tag#516 CDB: Write(10) 2a 00 0d e6 9e 88 00 00 01 00
> Oct 14 14:54:01 done.molgen.mpg.de kernel: blk_update_request: I/O error, dev sdw, sector 1865741376 op 0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:0:0: [sds] tag#529 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:0:0: [sds] tag#529 CDB: Write(10) 2a 00 29 4e e8 ff 00 00 01 00
> Oct 14 14:54:01 done.molgen.mpg.de kernel: blk_update_request: I/O error, dev sds, sector 5544298488 op 0x1:(WRITE) flags 0x0 phys_seg 1 prio class 0
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:0:0: [sds] tag#627 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:0:0: [sds] tag#627 CDB: Read(10) 28 00 5d df 2c 04 00 00 04 00
> Oct 14 14:54:01 done.molgen.mpg.de kernel: blk_update_request: I/O error, dev sds, sector 12599255072 op 0x0:(READ) flags 0x1000 phys_seg 1 prio class
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:5:0: [sdx] tag#567 FAILED Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK cmd_age=6s
> Oct 14 14:54:01 done.molgen.mpg.de kernel: sd 15:0:5:0: [sdx] tag#567 CDB: Write(10) 2a 00 21 4e ce 04 00 00 04 00

How can the status code 0x6100c be deciphered?


Kind regards,

Paul
