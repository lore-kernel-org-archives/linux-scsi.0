From: Pavel Andrianov <andrianov@ispras.ru>
Subject: A potential race in drivers/scsi/megaraid.ko
Date: Fri, 12 Aug 2016 13:44:18 +0300
Message-ID: <d68c390c-1794-796d-cdb2-402f1214ca4c@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>
Cc: Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Vaishali Thakkar <vaishali.thakkar@oracle.com>, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

Hi!

There is a potential data race in drivers/scsi/megaraid.ko
Regards such case:

Thread 1					Thread 2
...						...
-> megaraid_probe_one				
    -> request_irq    - now an interrupt may arise
    -> mega_query_adapter
      -> issue_scb_block
			interrupt comes 	
						-> megaraid_isr_iomapped
						  -> mega_runpendq
						    -> __mega_runpendq
						      -> issue_skb

In this case the structure 'mbox' is modified from two threads 
simultaneously. Or, more correct, the first modification is interrupted 
by the second one. Likely, the first thread should acquire the same 
spinlock adapter->lock as the second one.

-- 
Pavel Andrianov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: andrianov@ispras.ru
