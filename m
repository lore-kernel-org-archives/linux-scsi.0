From: "jack wang" <jack_wang@usish.com>
Subject: RE: [PATCH 3/5] drivers/scsi: drop redundant memset
Date: Wed, 10 Mar 2010 09:05:07 +0800
Message-ID: <B8AD7A70524143C289C05DFE9857EC84@usish.com.cn>
References: <Pine.LNX.4.64.1003092214110.4974@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sr-smtp.usish.com ([210.5.144.203]:37029 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0CJBV3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2010 20:21:29 -0500
In-Reply-To: <Pine.LNX.4.64.1003092214110.4974@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Julia Lawall' <julia@diku.dk>, lindar_liu@usish.com, "'James E.J. Bottomley'" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-jan


From: Julia Lawall <julia@diku.dk>

The region set by the call to memset is immediately overwritten by the
subsequent call to memcpy.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3,e4;
@@

- memset(e1,e2,e3);
  memcpy(e1,e4,e3);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/pm8001/pm8001_hwi.c |    1 -
 1 file changed, 1 deletion(-)

diff -u -p a/drivers/scsi/pm8001/pm8001_hwi.c
b/drivers/scsi/pm8001/pm8001_hwi.c
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -4389,7 +4389,6 @@ pm8001_chip_fw_flash_update_req(struct p
 				return -ENOMEM;
 		}
 	}
-	memset(buffer, 0, fw_control->len);
 	memcpy(buffer, fw_control->buffer, fw_control->len);
 	flash_update_info.sgl.addr = cpu_to_le64(phys_addr);
 	flash_update_info.sgl.im_len.len = cpu_to_le32(fw_control->len);



[Jack] Thanks Julia.
Acked-by: Jack Wang <jack_wang@usish.com>

