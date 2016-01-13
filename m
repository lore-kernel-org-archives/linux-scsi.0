From: Hannes Reinecke <hare@suse.de>
Subject: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 10:10:43 +0100
Message-ID: <56961493.5010901@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbcAMJKq (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 04:10:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

Hi all,

I'd like to attend LSF/MM and would like to present my ideas for a=20
multipath redesign.

The overall idea is to break up the centralized multipath handling=20
in device-mapper (and multipath-tools) and delegate to the=20
appropriate sub-systems.

Individually the plan is:
a) use the 'wwid' sysfs attribute to detect multipath devices;
    this removes the need of the current 'path_id' functionality
    in multipath-tools
b) leverage topology information from scsi_dh_alua (which we will
    have once my ALUA handler update is in) to detect the multipath
    topology. This removes the need of a 'prio' infrastructure
    in multipath-tools
c) implement block or scsi events whenever a remote port becomes
    unavailable. This removes the need of the 'path_checker'
    functionality in multipath-tools.
d) leverage these events to handle path-up/path-down events
    in-kernel
e) move the I/O redirection logic out of device-mapper proper
    and use blk-mq to redirect I/O. This is still a bit of
    hand-waving, and definitely would need discussion to figure
    out if and how it can be achieved.
    This is basically the same topic Mike Snitzer proposed, but
    coming from a different angle.

But in the end we should be able to do strip down the current=20
(rather complex) multipath-tools to just handle topology changes;=20
everything else will be done internally.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
