From: Dheeraj Sangamkar <dheerajrs@gmail.com>
Subject: Host Channel TargetId LUN enumeration and scope
Date: Mon, 16 Feb 2009 13:45:29 +0530
Message-ID: <677131e90902160015g2e63a29byb020a98bf7369686@mail.gmail.com>
References: <677131e90902160009r7b1b43f3t53b11c032be28b72@mail.gmail.com>
	 <677131e90902160011u5613c7fibf29bb16f68a86a7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:2552 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401AbZBPIP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 03:15:29 -0500
Received: by rv-out-0506.google.com with SMTP id g37so1465535rvb.1
        for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2009 00:15:29 -0800 (PST)
In-Reply-To: <677131e90902160011u5613c7fibf29bb16f68a86a7@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
I am exploring the 2.6.27 linux scsi mid layer and I have a few
questions. I have code access and can browse reasonably, so you can
refer to functions and files.
I would like to know how each of the Host Channel TargetId and LUN are
enumerated and assigned to each SCSI device.
In case, the scsi device is on a storage array, can the TargetId and
LUN values change for a LUN?
Specifically, during path failures to an FC array, is it possible to
get a different value of TargetId and LUN id for a SCSI device when it
reappears when the paths recover?
Some code reading has led me to believe that the each remote port is
being viewed as a separate (Target) ID. Why is this so? Dont we
recognize multiported target SCSI devices?
I have also seen that during remote port time out(possibly due to path
failures or fabric problems), the remote port related data is not
discarded. When the remote port is detected by the LLDD,
scsi_transport_fc compares it with the list of ports it has and
re-assigns the same state/structure to the newly discovered port. Why
was this required? Is it to prevent target ID changes across loss of
connectivity to the (fibre channel) target device?
If HBAs are hotpluggable/hot swappable, will the 'host' part of the
[H,C,I,L] tuple change for a new identical HBA plugged into the same
slot?

How are LUN Ids enumerated? Does the order in which the response
REPORT_LUN command gives LUNs, determine the LUN ID assignment for a
SCSI disk discovered on a remote target on an array connected via FC?
Can this order of LUN presentation change and is valid?
If REPORT LUNs is not supported and the scsi_transport_fc has to scan
all possible LU ids, the order is fixed(1 - 2^16). Is this why the LUN
id does not change for a particular LUN being presented to a host
across rescans/path-failure-recovery cycles?
Thanks in advance,
Dheeraj
--
Simplicity of character is the natural result of profound thought.
