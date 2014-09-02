From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: potential buffer overrun in __iscsi_conn_send_pdu()
Date: Mon, 01 Sep 2014 22:22:11 -0500
Message-ID: <540537E3.7090903@cs.wisc.edu>
References: <20130624154631.GA31984@elgon.mountain> <20140901180650.GB6549@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37025 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbaIBDWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2014 23:22:21 -0400
In-Reply-To: <20140901180650.GB6549@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, Kees Cook <keescook@chromium.org>

On 9/1/14, 1:06 PM, Dan Carpenter wrote:
> I never heard back on this.  It still looks like a very serious bug
> with security implications etc.
>

Sorry about that. I must have missed the original. You are right. I 
should have a tested patch by tomorrow.


> regards,
> dan carpenter
>
> On Mon, Jun 24, 2013 at 06:46:31PM +0300, Dan Carpenter wrote:
>> My static checker complains about a possible array overflow in
>> __iscsi_conn_send_pdu().
>>
>> drivers/scsi/libiscsi.c
>>     743          if (data_size) {
>>     744                  memcpy(task->data, data, data_size);
>>     745                  task->data_count = data_size;
>>     746          } else
>>     747                  task->data_count = 0;
>>     748
>>
>> "data_size" comes from skb->data and we haven't checked that it is less
>> than ISCSI_DEF_MAX_RECV_SEG_LEN (8192).
>>
>> The call tree is:
>> iscsi_if_recv_msg()
>> iscsi_conn_send_pdu()
>> __iscsi_conn_send_pdu()
>>
>> I'm a newbie to this code, so I'm not sure if this is a real bug or not.
>>
>> regards,
>> dan carpenter

