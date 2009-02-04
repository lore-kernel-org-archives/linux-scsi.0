From: Andrew Morton <akpm@linux-foundation.org>
Subject: iscsi_add_session() warning
Date: Tue, 3 Feb 2009 16:09:00 -0800
Message-ID: <20090203160900.38506c47.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374AbZBDAJP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2009 19:09:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org


Looking at this:

drivers/scsi/scsi_transport_iscsi.c: In function 'iscsi_add_session':
drivers/scsi/scsi_transport_iscsi.c:703: warning: 'err' may be used uninitialized in this function

the compiler is wrong - `err' will always have been initialised to
_something_.

But to what?

: int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
: {
: 	struct Scsi_Host *shost = iscsi_session_to_shost(session);
: 	struct iscsi_cls_host *ihost;
: 	unsigned long flags;
: 	unsigned int id = target_id;
: 	int err;
: 
: 	ihost = shost->shost_data;
: 	session->sid = atomic_add_return(1, &iscsi_session_nr);
: 
: 	if (id == ISCSI_MAX_TARGET) {
: 		for (id = 0; id < ISCSI_MAX_TARGET; id++) {
: 			err = device_for_each_child(&shost->shost_gendev, &id,
: 						    iscsi_get_next_target_id);
: 			if (!err)
: 				break;
: 		}
: 
: 		if (id == ISCSI_MAX_TARGET) {
: 			iscsi_cls_session_printk(KERN_ERR, session,
: 						 "Too many iscsi targets. Max "
: 						 "number of targets is %d.\n",
: 						 ISCSI_MAX_TARGET - 1);

At this point, err is probably zero.  Or it might be the return value
from the most recent call to
device_for_each_child(iscsi_get_next_target_id).

Should we not assign some error code to `err' here?

: 			goto release_host;
: 		}
: 	}
: 	session->target_id = id;
: 
: 	dev_set_name(&session->dev, "session%u", session->sid);
: 	err = device_add(&session->dev);
: 	if (err) {
: 		iscsi_cls_session_printk(KERN_ERR, session,
: 					 "could not register session's dev\n");
: 		goto release_host;
: 	}
: 	transport_register_device(&session->dev);
: 
: 	spin_lock_irqsave(&sesslock, flags);
: 	list_add(&session->sess_list, &sesslist);
: 	spin_unlock_irqrestore(&sesslock, flags);
: 
: 	iscsi_session_event(session, ISCSI_KEVENT_CREATE_SESSION);
: 	return 0;
: 
: release_host:
: 	scsi_host_put(shost);
: 	return err;
: }

