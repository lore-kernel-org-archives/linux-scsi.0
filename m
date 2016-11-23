From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/2] SRP transport, scsi-mq: Wait for .queue_rq() if necessary
Date: Tue, 22 Nov 2016 16:16:06 -0800
Message-ID: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello James and Martin,

The SRP transport code must wait until ongoing .queuecommand() / 
.queue_rq() callback function invocations have finished before 
reconnecting at the transport layer level and also before invoking 
.terminate_rport_io(). This is already the case for the single queue 
path but not yet for the scsi-mq path. This patch series realizes the 
proper serialization for the scsi-mq path. Compared to last time these 
patches were posted, only the patch descriptions and one comment have 
been changed.

See also "[PATCH v5 0/14] Fix race conditions related to stopping block 
layer queues" 
(https://www.mail-archive.com/linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg01830.html) 
for a previous post of these patches.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
