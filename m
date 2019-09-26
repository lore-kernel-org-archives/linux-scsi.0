Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9586DC4360C
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:08:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 612272054F
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 22:08:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="cZywKgXC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfIZWIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 18:08:47 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:22768 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfIZWIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2019 18:08:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1569535728; x=1601071728;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jUl4yvH3sv5PWTq0mFFoC4R1SUJj4ZZE0LhBeB8gnCY=;
  b=cZywKgXCFUkERBBNGJzjAwfKVuSWUp4Mn0xSCJ/AXJW7dLh9jDkWeb2+
   K/6pDnjQkdH8zO3Qu9A26lZmKvxR0O0zJczlYfqFu14Xu7IUvZeL579kV
   uQWv54/ifU5NaH61HcN94BiPIRAlXJrJXWq1l+TGeIb1YHIHxsgfF6YWX
   YC5gg98FDqQidqAZXkWJ4SB8lxOLwKaO9UV6j2S/fw8PGUXrganOuAFsg
   7oI3dMikjMUoEHILzlrTnHMktu8qDRwjxskfh0Fu4b0ZXR0nl7/oqGzjc
   rDdd4DZIC59rRO3caUM1lKkElYRJmXq4DY3TbFHguXgffgB4DsxlWXMz2
   g==;
IronPort-SDR: US0XiD0fs8diWGKMywgra+zPWZLW7UT5sLHGoScmnPnBwryp99rLzGkdpsUKSfhUGlWpPnq898
 nqfQy5NuD3Oj/DXgz78H1J1MugUbbQEMZsVvaYTQ7ZpOKLDc9G/jho8UqDgzv/pIdCOMKP+ZsV
 9zggbZVk1Rla/U9a0Yw8P53sqApVTojDo9E34XZZ0lBhUF+c7E9RRbmuz6mDE9m3mxA407dj6M
 hwXx6GMs8M/NQKzjUj9n0mM4hdr/AZcdOt3QkZp5D/0COydlS5Ir6kVsZeZfhm0bNz5llYQ0Gu
 Wi0=
X-IronPort-AV: E=Sophos;i="5.64,553,1559491200"; 
   d="scan'208";a="123681604"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2019 06:08:48 +0800
IronPort-SDR: zlL9/nNjf7zqu8/hjqqjcBHMNQ86E+8o4tLyr9kPGt3FEJOgBszuen/OHHP3kFNSg+1MEBBlLO
 uCLs1t6eiXiyQR3jTmEA4GUrz55Eu2NCKnIEgRiRRRmFMeGcGOr6l5ALPr4/fzMGmYvrQD/N21
 vx01Zm5JEUNa2Co40CVUuBqJ24TsAdKLCpEt5cnTdalgrIe/27DdlVXI+xdz33Vn5CSHk15oPb
 zNZAjKQq1nJcBu8mvVGPO9sLj78PdW2cSIpYo1cxBKrv5KynwJNu10AKfnoXi98iUkylW+iJl2
 hDQuPDqzcD3R6trnmwvapu6y
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 15:05:07 -0700
IronPort-SDR: 1Bxr+sMRM4yhVg9saBSIl8gmYZQ2yrLgaWKyLZxEiJ6RMfnAOb3lp+Rkuy41qeqoH8vhBRr1vY
 HAkbtzi4fP+LpN4qGBHHWJctekcxSY75u0TxATQYQbRLNnTim7H6GOam0q+i3z1Zijj28DetiL
 uBCYp91ZKwTLeoaFHPOI3GOvhOZ8ip4uo/MuXvKGqP0Ma8veidUm5LvwpjYaSeaumoBOxsGhMi
 TksQxfyN+1rA3BkMsBeLVP2TR0eMt5ZiP9ctjnZFCdFoZUnL0P1yytqCoRojT0md9MMC6vjVJv
 Pnw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Sep 2019 15:08:45 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: [PATCH 0/2] Fix SCSI & USB Storage CHECK CONDITION handling
Date:   Fri, 27 Sep 2019 07:08:42 +0900
Message-Id: <20190926220844.26631-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a non-passthrough command is terminated with a CHECK CONDITION, the
scsi error recovery code reuses the failed command scsi_cmnd structure
to process error recovery request sense. To preserve information
regarding the failed command, the functions scsi_eh_prep_cmnd() and
scsi_eh_restore_cmnd() respectively save and restore the original
command information. However, the resid field of the failed command
request structure is not preserved and reused for the request sense
handling, leading to the original command having an incorrect resid
when:
A) The command is not retried and terminated with an error
B) The command completes after retry and the underlying LLD does not set
   resid for a fully completed command (resid=0)

The first patch of this series addresses case (A) above by adding resid
as part of the command information saved using struct scsi_eh_save.

Case B can be observed with a WD My Book USB disks when a read or write
command is sent to the disk while the disk is in deep sleep mode
(spun down) due to a long period of inactivity (~30min).
In such case, the following command sequence happen:
1) The read or write command is terminated after a few seconds with
   CHECK CONDITION and an asc/ascq of 04/01 (LOGICAL UNIT IS IN PROCESS
   OF BECOMING READY)
2) In response to this failure, the USB mass storage driver triggers
   autosense processing, reusing the command descriptor to issue a
   request sense command with a 96B sense buffer size. The reply
   to this command gives a NOT READY / LOGICAL UNIT IS IN PROCESS
   OF BECOMING READY sense of 18B, resulting in a resid of 78B.
3) The original command is retried and failed again, with step 2
   repeated, until the drive spins up and becomes ready.
4) When the original command completes after the drive has become ready,
   the request sense command resid of 78B is seen by the scsi disk
   driver sd_done() function and wrongly generates a warning about the
   unaligned value reported.

This problem is fixed in patch 2 by always setting a command resid to 0
when there is no residual in usb_stor_Bulk_transport(). Note that
usb_stor_CB_transport() does not need changes since usb_stor_bulk_srb()
always sets the resid for a completed command, regardless of the
residual value.

Damien Le Moal (2):
  scsi: save/restore command resid for error handling
  usb: Clear scsi command resid when residue is 0

 drivers/scsi/scsi_error.c       | 2 ++
 drivers/usb/storage/transport.c | 9 +++++++++
 include/scsi/scsi_eh.h          | 1 +
 3 files changed, 12 insertions(+)

-- 
2.21.0

