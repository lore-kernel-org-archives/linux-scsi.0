From: Pavel Andrianov <andrianov@ispras.ru>
Subject: A potential data race in drivers/scsi/mvumi.ko
Date: Fri, 12 Aug 2016 15:39:32 +0300
Message-ID: <cb9e90a8-2f68-dba2-9126-a0c90973a65d@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Vaishali Thakkar <vaishali.thakkar@oracle.com>, ldv-project@linuxtesting.org
List-Id: linux-scsi@vger.kernel.org

Hi!

There is a potential data race in drivers/scsi/mvumi.ko.
Regard such case:

Thread 1					Thread 2
...
-> mvumi_reset_host_9500 -
    is called without any locking
   -> mvumi_wait_for_outstanding
     ->mvumi_start
       ->mvumi_check_handshake
         -> mvumi_handshake_event
           -> mvumi_handshake
             ->mvumi_hs_build_page

			   interrupt comes
					      -> mvumi_isr_handler
						-> mvumi_handshake
						  -> mvumi_hs_build_page

In this case the same data mhba->handshake_page is modified from two 
threads. Likely the first thread should acquire the same spinlock 
mhba->shost->host_lock as the second thread.

-- 
Pavel Andrianov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: andrianov@ispras.ru
