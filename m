From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] qla4xxx: TODO for re-submission
Date: Mon, 12 Jun 2006 13:05:09 -0500
Message-ID: <448DACD5.6090205@cs.wisc.edu>
References: <8889.1149988615@bebe.enoyolf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:15506 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751535AbWFLSIi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 14:08:38 -0400
In-Reply-To: <8889.1149988615@bebe.enoyolf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Maxey <dwm@bebe.enoyolf.org>
Cc: Ravi Anand <ravi.anand@qlogic.com>, David Somayajulu <davidcs2005@gmail.com>, Duane Grigsby <duane.grigsby@qlogic.com>, linux-scsi@vger.kernel.org, dwm@austin.ibm.com

Doug Maxey wrote:
> 5) add the block layer code.

Some related issues that we have discussed offlist about this and should
probably be discussed here are:

- Are we supposed to follow FC's lead and remove the devices (rport,
session, target, scsi_device, etc) if the dev_loss_tmo fires. Currently
for software iscsi, we leave the devices/session. This was to reduce
memory allocations and because software iscsi has to basically poll the
connection during connect as part of the relogin process. So unlike FC
or hw iscsi, if we remove the devices/structs we have to end up
rebuilding some of them right away anyways.

Removing the devices has the benefit of simplifying the scsi/iscsi code.

- Scanning. We currently do scanning for open-iscsi in userspace. For
iscsi root this requires distro support. SUSE has it. Fedora is working
on it. There is also Debian and Gentoo users or maintainers posting
about working on it. For qla4xxx, we could stick the scanning in the
kernel like FC and distros would not have to worry about it, but since
they have to get this working for software iscsi do we just keep the
scanning in userspace?
