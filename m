From: "N.C.Krishna Murthy" <krmurthy@cisco.com>
Subject: Re:Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 11 Dec 2003 21:17:46 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312112117.46216.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:65356 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S265133AbTLKPry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Dec 2003 10:47:54 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI -DEVEL <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Hi,
	One of your comments was
"having multiple kmap() in the same process at the same time can deadlock(),
you redesign iscsi_xmit_task/iscsi_xmit_data/iscsi_recv_data not to do that.
for the tx path use ->sendpage to avoid a data copy and kmapping altogether".

I did try using sendpage in iscsi_xmit_data. 
Whenever the scatterlist->length was 4096 sendpage did succeed.
When it was 8192 I did see a panic 
------------------------------------------------------------------------------------------
Unable to handle kernel NULL pointer dereference
 at virtual address 00000004
Dec 11 08:55:22 linux-3 kernel:  printing eip:
Dec 11 08:55:22 linux-3 kernel: c03e24ec
Dec 11 08:55:22 linux-3 kernel: *pde = 00000000
Dec 11 08:55:22 linux-3 kernel: Oops: 0002 [#1]
Dec 11 08:55:22 linux-3 kernel: CPU:    0
Dec 11 08:55:22 linux-3 kernel: EIP:    0060:[__func__.4+49981/364885]    Not 
ta
inted
Dec 11 08:55:22 linux-3 kernel: EIP:    0060:[<c03e24ec>]    Not tainted
Dec 11 08:55:22 linux-3 kernel: EFLAGS: 00010287
Dec 11 08:55:22 linux-3 kernel: EIP is at do_tcp_sendpages+0x62e/0xb8a
------------------------------------------------------------------------------------------
Has this been seen earlier? 

Thanx
N.C.Krishna Murthy
