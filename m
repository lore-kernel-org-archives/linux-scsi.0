From: Mike Christie <mikenc@us.ibm.com>
Subject: qla2xxx tcq question/bug
Date: Fri, 09 Jul 2004 16:13:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40EF2697.20804@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:34714 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S266025AbUGIXNi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 19:13:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Andrew,

For the qla2xxx driver in 2.6.7 there is this code:

/* Update tagged queuing modifier */
cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
if (cmd->device->tagged_supported) {
	switch (cmd->tag) {
		case HEAD_OF_QUEUE_TAG:
			cmd_pkt->control_flags =
			__constant_cpu_to_le16(CF_HEAD_TAG);
			break;
		case ORDERED_QUEUE_TAG:
			cmd_pkt->control_flags =
			__constant_cpu_to_le16(CF_ORDERED_TAG);
			break;
	}
}

but do you know where/how cmd->tag gets set? It looks like it gets
copied from req->tag in the scsi_prep_fn, but for drivers that do not
call scsi_actiavte_tcq that value never gets touched by the block
layer. Even for drivers that do call scsi_activate_tcq, the req->tag
value is just the tag nr, and those drivers will use scsi_populate_msg
to get the task attribute. req->tag gets copied in the prep_fn and
does not get set until after the request_fn has prepared the request so
really cmd->tag looks like it is junk for every case.

Is this usage from 2.4? Should the qla2xx driver be calling
scsi_activate_tcq/scsi_populate_msg for devices that support tags,
or is that a waste becuase you never use the tag number and all you
really want is the attribute?


Thanks,


-- 
Mike Christie
mikenc@us.ibm.com

