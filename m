From: Lan Tran <transter@gmail.com>
Subject: BUG: SCSI INQUIRY thru SCSI_IOCTL_SEND_COMMAND returns no errno for disconnected device
Date: Thu, 30 Sep 2004 12:43:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ac71172a04093012437c353f83@mail.gmail.com>
Reply-To: Lan Tran <transter@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rproxy.gmail.com ([64.233.170.203]:51466 "EHLO mproxy.gmail.com")
	by vger.kernel.org with ESMTP id S269398AbUI3Tnx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 15:43:53 -0400
Received: by mproxy.gmail.com with SMTP id 80so2489293rnl
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2004 12:43:47 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: johntsai@us.ibm.com, tranlan@us.ibm.com

We have a SAN system set up, where our host is connected to IBM ESS
storage and SVC storage. When we disconnect ALL FC cables between the
host and storage devices, and then send a SCSI INQUIRY using the
SCSI_IOCTL_SEND_COMMAND ioctl to the
sd devices, the ioctl does not return with a failure code. Instead, it
returns with a zero-length buffer.

Is there a reason why we would get a zeroed-length buffer instead of
an error return code?

We see this problem on both an emulex driver (2.10f) and qlogic driver
(8.00.00b14, non failover version).

Looking through the kernel SCSI layer code, it just seems that the
SCSI inquiry is packaged up as a request and sent off to the LLDD. So
is something strange happening in the LLDD's ...

Thanks!!
Lan
