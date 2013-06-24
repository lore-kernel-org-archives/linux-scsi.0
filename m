From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: potential buffer overrun in __iscsi_conn_send_pdu()
Date: Mon, 24 Jun 2013 18:46:31 +0300
Message-ID: <20130624154631.GA31984@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21717 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab3FXPrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 11:47:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org

My static checker complains about a possible array overflow in
__iscsi_conn_send_pdu().

drivers/scsi/libiscsi.c
   743          if (data_size) {
   744                  memcpy(task->data, data, data_size);
   745                  task->data_count = data_size;
   746          } else
   747                  task->data_count = 0;
   748  

"data_size" comes from skb->data and we haven't checked that it is less
than ISCSI_DEF_MAX_RECV_SEG_LEN (8192).

The call tree is:
iscsi_if_recv_msg()
iscsi_conn_send_pdu()
__iscsi_conn_send_pdu()

I'm a newbie to this code, so I'm not sure if this is a real bug or not.

regards,
dan carpenter

