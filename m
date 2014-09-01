From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: potential buffer overrun in __iscsi_conn_send_pdu()
Date: Mon, 1 Sep 2014 21:06:50 +0300
Message-ID: <20140901180650.GB6549@mwanda>
References: <20130624154631.GA31984@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27152 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbaIASIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2014 14:08:25 -0400
Content-Disposition: inline
In-Reply-To: <20130624154631.GA31984@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Kees Cook <keescook@chromium.org>

I never heard back on this.  It still looks like a very serious bug
with security implications etc.

regards,
dan carpenter

On Mon, Jun 24, 2013 at 06:46:31PM +0300, Dan Carpenter wrote:
> My static checker complains about a possible array overflow in
> __iscsi_conn_send_pdu().
> 
> drivers/scsi/libiscsi.c
>    743          if (data_size) {
>    744                  memcpy(task->data, data, data_size);
>    745                  task->data_count = data_size;
>    746          } else
>    747                  task->data_count = 0;
>    748  
> 
> "data_size" comes from skb->data and we haven't checked that it is less
> than ISCSI_DEF_MAX_RECV_SEG_LEN (8192).
> 
> The call tree is:
> iscsi_if_recv_msg()
> iscsi_conn_send_pdu()
> __iscsi_conn_send_pdu()
> 
> I'm a newbie to this code, so I'm not sure if this is a real bug or not.
> 
> regards,
> dan carpenter
