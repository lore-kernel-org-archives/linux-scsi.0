From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: scsi_error: improve the recovery latency for timeouted scsi cmds
Date: Wed, 20 Mar 2013 11:24:49 +0800
Message-ID: <51492C01.504@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:15431 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab3CTDXP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Mar 2013 23:23:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>
Cc: Tejun Heo <tj@kernel.org>, Christoph Hellwig <hch@infradead.org>, SCSI <linux-scsi@vger.kernel.org>

Hi,

Please let me ask one question about improving the recovery latency
for timeouted scmds:

In the functions 'scsi_eh_wakeup()' & 'scsi_error_handler()', there
are two same condition judgements which ensure the number of active
scmds equals to the number of failed scmds:

   void scsi_eh_wakeup(struct Scsi_Host *shost)
   {
       if (shost->host_busy == shost->host_failed)
           wake_up_process(shost->ehandler);
   }

   int scsi_error_handler(void *data)
   {
       while (!kthread_should_stop()) {
           if ((shost->host_failed == 0 &&
                shost->host_eh_scheduled == 0) ||
                shost->host_failed != shost->host_busy) {
               schedule();
               continue;
           }
           ....
       }
       ....
   }

I think the original reason for waking up eh thread until all scmds
complete/fail may be in case of more overhead produced by threads
waking up time after time, right?

But in the below condition, the strategy above seems not appropriate:

   If a scmd is issued and stuck and another scmd is issued, scsi eh
   detects a timeout of the first scmd, but has to wait for the second
   one to be timedout/completed. Which means the first timeouted scmds
   couldn't be handled in time.

This may be fatal to a certain extent(the critical system especially).
So, please let me know the starting point for the wakeup strategy in
eh. We'd investigate further based on your comments. Any suggestions
will be appreciated.

Thanks,
Ren
