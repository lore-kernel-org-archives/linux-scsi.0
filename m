From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [RFC 0/2] Add fc_rport attributes to further populate HBAAPIv2
 HBAPortAttributes for discovered ports.
Date: Thu, 28 Oct 2010 12:22:19 -0400
Message-ID: <alpine.LFD.2.00.1010281220230.2885@localhost.localdomain>
References: <alpine.LFD.2.00.1010281212441.2885@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:17811 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758760Ab0J1QWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 12:22:22 -0400
In-Reply-To: <alpine.LFD.2.00.1010281212441.2885@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


Changed subject line as this RFC only has two patches.

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
>
