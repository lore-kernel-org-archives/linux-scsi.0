From: "Janne Karhunen" <janne.karhunen@gmail.com>
Subject: INQUIRY failing after hotswap
Date: Tue, 10 Jun 2008 10:43:17 -0400
Message-ID: <24c1515f0806100743g3fea3abclf79511476d812a35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:34697 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757180AbYFJOnT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 10:43:19 -0400
Received: by py-out-1112.google.com with SMTP id p76so1224938pyb.10
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jun 2008 07:43:18 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I'm looking at a blade that occasionally refuses to re-add disk after
hotswap. Reason seems to be that when I do:
echo "scsi add-single-device 1 0 0 0" > /proc/scsi/scsi

This symbios scsi controller comes back telling us:
scsi_scan_host_selected: <1:0:0:0>
scsi scan: INQUIRY to host 1 channel 0 id 0 lun 0
scsi scan: 1st INQUIRY failed with code 0x100ff

Now if I read this right, it's basically telling me that there is no
device here:

status_byte = 0xff // What's this??
msg_byte = 0x0     // ok
host_byte = 0x1    // DID_NO_CONNECT
driver_byte = 0x0  // ok

Occurrence seems random. Any insight? State seems
permanent, it's not able to re-add the disk ever if this
happens (reboot is required).

Controller is
03:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010
66MHz  Ultra3 SCSI Adapter (rev 01)
03:01.1 SCSI storage controller: LSI Logic / Symbios Logic 53c1010
66MHz  Ultra3 SCSI Adapter (rev 01)

Driver is latest sym53c8xx (_2).


-- 
// Janne
