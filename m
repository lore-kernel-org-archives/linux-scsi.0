From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC][PATCH 2.6.11-rc2] Linux SCSI hotplug infrastructure
Date: Mon, 7 Feb 2005 12:30:50 -0600
Message-ID: <20050207183050.GD16526@lists.us.dell.com>
References: <20050207182753.GA16526@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from lists.us.dell.com ([143.166.224.162]:15276 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S261227AbVBGSav
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 13:30:51 -0500
Content-Disposition: inline
In-Reply-To: <20050207182753.GA16526@lists.us.dell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net

On Mon, Feb 07, 2005 at 12:27:53PM -0600, Matt Domsch wrote:
> /etc/hotplug/scsi_topology.agent
>  handles the hotplug call, and invokes /sys/class/scsi_host/hostX/scan
>  and /sys/class/scsi_device/H:C:T:L:/device/delete as appropriate.

And here's scsi_topology.agent.

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>

--
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

#!/bin/bash
#
# SCSI Topology hotplug agent.
# Copyright (C) 2005 Dell, Inc.  <Matt_Domsch@dell.com>
#
# This is invoked when a device, not currently known to the system, is
# added or removed from a SCSI topology.  This includes creation of a
# logical drive on a RAID controller, or manually inserting a disk
# into a SCSI disk enclosure.  This script then invokes the scan
# method of the scsi_host, or the delete method of the scsi_device, to
# inform the kernel of the change made on the topology.
#
# SCSI_TOPOLOGY_EVENT_HCTL is used to know that the data to pass to
# scan is a Host:Controller:Target ID:LUN tuple.  This is to provide
# for future SCSI implmentations that may use a native addressing
# scheme rather than only HCTL.


[ ${SCSI_TOPOLOGY_EVENT} != "1" ] && exit
[ ${SCSI_TOPOLOGY_EVENT_HCTL} != "1" ] && exit

if [ "${ACTION}" = "add" ]; then
    MYPATH=/sys/class/scsi_host/host${SCSI_HOST}/scan
    [ -f ${MYPATH} ] && echo "${SCSI_CHANNEL} ${SCSI_ID} ${SCSI_LUN}" > ${MYPATH}
fi

if [ "${ACTION}" = "remove" ]; then
    MYPATH=/sys/class/scsi_device/${SCSI_HOST}:${SCSI_CHANNEL}:${SCSI_ID}:${SCSI_LUN}/device/delete
    [ -f ${MYPATH} ] && echo "1" > ${MYPATH}
fi
