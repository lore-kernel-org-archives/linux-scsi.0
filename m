From: Richard Sharpe <realrichardsharpe@gmail.com>
Subject: [LSF/MM Topic] SCSI Unit Attention Handling
Date: Sun, 6 Feb 2011 15:44:17 -0500
Message-ID: <AANLkTikARn9U17fVKDo+dgyfz554LV=Dz+_M_xB5dfe+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61397 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016Ab1BFUoS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2011 15:44:18 -0500
Received: by iwn9 with SMTP id 9so3964914iwn.19
        for <linux-scsi@vger.kernel.org>; Sun, 06 Feb 2011 12:44:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lsf-pc@lists.linuxfoundation.org, linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>

I would like to propose a topic around SCSI Unit Attention Handling.

The current scsi_error.c:scsi_check_sense handling of UNIT ATTENTION
consists of explicitly printing warnings for for ASC=0x3f events and
then returning SOFT_ERROR which scsi_error.c:scsi_decide_disposition
ignores because it returns SUCCESS to SOFT_ERROR being returned from
scst_check_sense on a CHECK_CONDITION.

There are a number of cases where we might want to perform further
processing on a UNIT ATTENTION. For example, ASC/ASCQ 0x3f/0x0e
REPORTED LUNS DATA HAS CHANGED or 0x2a/0x09 CAPACITY DATA HAS CHANGED,
0x28/0x03 IMPORT/EXPORT ELEMENT ACCESSED, MEDIUM CHANGED, etc. When
the LUNS have changed it would be useful to have a recan performed
automatically. If capacity data has changed, it would be useful if
someone could react to that and perhaps resize the file system on that
LUN if possible, and so forth.

It is not clear that any of these items should be handled in the
kernel anyway, and perhaps they should be exported to user-space for
correct handling, but rather than just the raw SENSE data being
exported, perhaps some sort of relevant event should be exported.

To avoid having to code all of the relevant combinations in the above
routine, Hannes and I have been discussing a framework for handling
this. Hannes suggested a notifier chain of some sort to deal with
this, and points out that because the above routine is called in a
softirq context we don't want to be performing lots of processing in
that context.

It seems that we need to defer processing of these items as well as
provide some mechanism for drivers (sd.c, st.c, etc, to register the
UNIT ATTENTIONs they are interested in). The registration seems quite
straight forward ... each driver can provide a list of the ASC/ASCQ
pairs they are interested in and a mapping to an event of some sort,
but the issue then is how to defer this processing. One approach I
have thought of is to extend the error handler thread to handle these
sorts of events and on a UNIT ATTENTION give the command to the error
handling thread. However, others might suggest that the processing
done in the error handler thread should be moved to work queues
anyway, and overloading the error handling thread like this is the
wrong way to do this and that they would rather see the error handling
thread go away.

So, I would like to have a discussion around the issues involved in
providing some sort of a framework for letting drivers indicate what
UNIT ATTENTIONS they are interested in and how to handle those, either
by exporting them to userspace or providing a callback or other
mechanism for handling them. We also need some discussion around
communicating with user space. Whether to use uevent/udev, use netlink
(Hannes suggests this has issues in heavy memory use cases), relayfs,
etc.

-- 
Regards,
Richard Sharpe
