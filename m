From: G S <gogman69-linuxscsi@yahoo.com>
Subject: Why does SCSI mid layer mark the LUN offline in this situation?
Date: Wed, 30 Sep 2009 23:46:31 -0600
Message-ID: <da0ca6030909302246s4527cc98v6e3b37d7ca3bba2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:39621 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZJAFq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 01:46:27 -0400
Received: by yxe37 with SMTP id 37so7520615yxe.33
        for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2009 22:46:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Howdy,

I have a Linux (2.6) using Emulex and QLogic FC HBA's to a disk array
product, with a single LUN presented, say LUN 1.

The dsf is created for LUN 1 and i can send SCSI commands to LUN 1.
And i'm using "sg".

If i delete LUN 1 from disk array.  Reboot the disk array.  Array
boots up only with LUN 0.

I have recreated LUN 1 on the target storage array.

But any attempt to send SCSI command to LUN 1 fails because LUN 1 has
been marked offline by SCSI mid layer.

Why?  Is it because RSCN seen by HBA driver is passed up to SCSI mid
layer to trigger re-scan?  And re-scan no longer finds LUN 1, so LUN 1
kernel structures are torned down, and LUN 1 marked offline by SCSI
mid layer?

Doing following to add back LUN 1 will bring it back for access,

# echo "scsi add-single-device <H> <B> <T> <L>" > /proc/scsi/scsi

Above "echo" seems to cause a blind re-scan by sending SCSI INQUIRY to
LUN 1 on the h/b/t/l hardware path.  That SCSI INQUIRY succeeds.  And
that success seems to cause LUN 1 to be marked online again.

Thanks much,

G
