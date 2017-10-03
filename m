From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [BUG] scsi/fcoe: Sleep-in-atomic bugs in fcoe driver
Date: Tue, 3 Oct 2017 11:02:33 +0800
Message-ID: <a19f782f-b3f2-c954-f982-35574b36d605@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

According to fcoe_ctlr.c, the driver may sleep under a RCU lock,
and the function call paths are:
fcoe_ctlr_disc_stop_locked (acquire the RCU lock)
   fc_rport_logoff
     mutex_lock --> may sleep

fcoe_ctlr_vn_disc
   fc_rport_login
     mutex_lock --> may sleep

fcoe_ctlr_vn_age
   fc_rport_logoff
     mutex_lock --> may sleep

These bugs are found by my static analysis tool and my code review.

Thanks,
Jia-Ju Bai
