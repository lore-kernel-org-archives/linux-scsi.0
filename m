From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: Subject: [RFC 0/3] Add fc_rport attributes to further populate
 HBAAPIv2 HBAPortAttributes for discovered ports.
Date: Fri, 29 Oct 2010 12:45:15 +0200
Message-ID: <20101029104515.GA15522@schmichrtp.mainz.de.ibm.com>
References: <alpine.LFD.2.00.1010281212441.2885@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:44924 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0J2KpR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2010 06:45:17 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate6.de.ibm.com (8.13.1/8.13.1) with ESMTP id o9TAjGZF005841
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 10:45:16 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o9TAjGwT4100322
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 12:45:16 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id o9TAjFgN018855
	for <linux-scsi@vger.kernel.org>; Fri, 29 Oct 2010 12:45:15 +0200
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010281212441.2885@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Oct 28, 2010 at 12:14:18PM -0400, Chad Dupuis wrote:
> Hi All,
> 
> This small patch set adds 7 new attributes to the fc_rport struct so that application libraries who export HBAAPI v2 discovered port attributes can populate the HBA_PORTATTRIBUTES structure more fully.  The new fc_rport attributes,
> which would be exported via the /sys/class/fc_remote_port/rport-x:y-z directory, are:
> 
> - supported_fc4s
> - supported_speed
> - port_type
> - speed
> - active_fc4s
> - symbolic_name
> - fabric_name
> 
> These attributes would be fixed-attributes which would mean that they would be set before the call to fc_remote_port_rolechg() but then once the role of the port has been established they would not change.
> 
> There are two patches in this RFC:
> 
> Patch #1 - scsi_transport_fc: Add HBAAPI v2 attributes to fc_rport structure.
> 
> This patch adds the definitions for the new fc_rport attributes, sets up the show functions and assigns default nominal values to the attributes.
> 
> Patch #2 - qla2xxx: Add name and management server queries to fill in new fc_rport attributes.
> 
> This patch adds the necessary name and management server calls to the SAN fabric services to obtain the information needed to fill in the new fc_rport attributes.  The patch also assigns the attributes before calling
> fc_remote_port_rolechg().

It looks like this mechanism only queries data from the FC nameserver.
It would be useful to have the same data available for all FC drivers.
The FC BSG interface already allows sending CT requests to the FC
nameserver. Could this be implemented by creating the request in
common code and issue the requests through the FC BSG interface? If
the data is used by the HBAAPI, the userspace HBAAPI could create the
FC requests and issue them through the /dev/bsg/... device files.

--
Christof
