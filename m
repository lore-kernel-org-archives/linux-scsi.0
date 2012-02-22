From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: scsi (sg) device status vs FC connectivity
Date: Wed, 22 Feb 2012 03:02:33 -0600
Message-ID: <4F44AF29.6020608@cs.wisc.edu>
References: <1329860107.22873.YahooMailNeo@web46407.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42031 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950Ab2BVJCj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2012 04:02:39 -0500
In-Reply-To: <1329860107.22873.YahooMailNeo@web46407.mail.sp1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Candid Shot <candid_shot_1@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On 02/21/2012 03:35 PM, Candid Shot wrote:
> (I hope this list is the right place to ask SG Driver related question ..)
> 
> Background: A FC cable-pull is simulated by disabling the FC switch (Brocade) port.
> 
> 
> While /sys/class/fc_host/hostx/port_state might confirm the FC connectivity is missing,
> 
> /proc/scsi/sg/devices will show the scsi device to be 'online'.
> 
> My goal is to be able to return an error to the application, should a cable-pull happen.
> 
> Is there a way to be able to tweak this behavior where the scsi driver is able to look at port events,
> and possibly return errors during read/write operations? 


You can listen on the fc scsi netlink socket for fc_host_event_code. You
get values like:


        { FCH_EVT_LIP,                  "lip" },
        { FCH_EVT_LINKUP,               "link_up" },
        { FCH_EVT_LINKDOWN,             "link_down" },
        { FCH_EVT_LIPRESET,             "lip_reset" },
        { FCH_EVT_RSCN,                 "rscn" },
        { FCH_EVT_ADAPTER_CHANGE,       "adapter_chg" },
        { FCH_EVT_PORT_UNKNOWN,         "port_unknown" },
        { FCH_EVT_PORT_ONLINE,          "port_online" },
        { FCH_EVT_PORT_OFFLINE,         "port_offline" },
        { FCH_EVT_PORT_FABRIC,          "port_fabric" },
        { FCH_EVT_LINK_UNKNOWN,         "link_unknown" },
        { FCH_EVT_VENDOR_UNIQUE,        "vendor_unique" },
