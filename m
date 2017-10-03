From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [BUG] scsi/libfc: Sleep-in-atomic bugs in libfc
Date: Tue, 3 Oct 2017 11:08:24 +0800
Message-ID: <aa6f7a10-0be3-0178-cba7-a3a03a5b1191@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: jth@kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: fcoe-devel@open-fcoe.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

According to fc_disc.c, the driver may sleep under a RCU lock,
and the function call paths are:
fc_disc_done (acquire the RCU lock)
   fc_rport_logoff
     mutex_lock --> may sleep

fc_disc_done (acquire the RCU lock)
   fc_rport_login
     mutex_lock --> may sleep

fc_disc_stop_rports
   fc_rport_logoff
     mutex_lock --> may sleep

These bugs are found by my static analysis tool and my code review.

Thanks,
Jia-Ju Bai
