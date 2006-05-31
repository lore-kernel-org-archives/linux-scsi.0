From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: [PATCH] aic94xx: make use of the new sas_port
Date: Wed, 31 May 2006 15:00:02 -0700
Message-ID: <1149112802.7543.83.camel@localhost.localdomain>
References: <1149048555.3545.64.camel@mulgrave.il.steeleye.com>
	 <1149104797.7543.64.camel@localhost.localdomain>
	 <1149109073.22134.105.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:494 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S965198AbWEaWAK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 May 2006 18:00:10 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4VM07a1030989
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 18:00:07 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k4VM071a244366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 16:00:07 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4VM06T6004731
	for <linux-scsi@vger.kernel.org>; Wed, 31 May 2006 16:00:07 -0600
In-Reply-To: <1149109073.22134.105.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-05-31 at 15:57 -0500, James Bottomley wrote:
> On Wed, 2006-05-31 at 12:46 -0700, Alexis Bruemmer wrote:
> > there is a sas_device, sas_end_device, and a sas_expander dir.
> > sas_device contains the same info as sas_end_device, and a sas_expander
> > can we eliminate one or the other?  Or was this a design choice?
> 
> Not really.  This is a design choice given to us by the interface.
> Everything that's connected to a port is a sas_device.  As such, they
> all share a set of characteristics (initiator and target roles, sas
> address and so forth).  The specific devices (sas_expander and
> sas_end_device) contain only parameters that are specific to the device,
> so the expander shows the manufacturer and component info.  The
> end_device shows the SAS mandated parameters like ready led and nexus
> loss timeout).
OK, makes sense

> 
> > Also during the boot process on the x260 with an expander we see these
> > printk's:
> > sas: phy[n] matched wide port0
> > If we are going to print this then we better be sure that this is truly
> > a wide port.  It seems under the sys/class/ we have both a single
> > port0:0 and then also port-0:0:[n]-- a port[n] for each phy[n].  and
> > although each phy seems to have the same sas_address the end_device
> > attached to that phy have unique addresses.  My understanding is that a
> > wide port has multiple phys with the same sas address and are attached
> > to one end device.  I believe that the expander situation is not the
> > same as wide port.  If this is the case then it is as simple as changing
> > the printk statement to not say "wide port"
> 
> As I read the code, it only prints that when it actually finds a wide
> port (as in a port that already has a phy attached) ... do an ls -R of
> your tree and I'll see if I can figure out what your topology is.
Below is a ls -R of my tree on this machine.  It seems that it sees the
expander as a wide port (port-0:0) and then the expander has a series of
phys attached to end devices.  What I am curious about is the
port-0:0:[0...4]-- the way this is laid out it seems that there is one
port for each phy which is attached to one end device, which would be a
narrow port.  Does your x260 create the same topology?

--Alexis


tree:
sas_device:
end_device-0:0-0  end_device-0:1-1  end_device-0:2-2  end_device-0:3-3
end_device-0:4-4  expander-0:0

sas_device/end_device-0:0-0:
device  device_type  initiator_port_protocols  phy_identifier
sas_address  target_port_protocols  uevent

sas_device/end_device-0:1-1:
device  device_type  initiator_port_protocols  phy_identifier
sas_address  target_port_protocols  uevent

sas_device/end_device-0:2-2:
device  device_type  initiator_port_protocols  phy_identifier
sas_address  target_port_protocols  uevent

sas_device/end_device-0:3-3:
device  device_type  initiator_port_protocols  phy_identifier
sas_address  target_port_protocols  uevent

sas_device/end_device-0:4-4:
device  device_type  initiator_port_protocols  phy_identifier
sas_address  target_port_protocols  uevent

sas_device/expander-0:0:
device  device_type  initiator_port_protocols  phy_identifier
sas_address  target_port_protocols  uevent

sas_end_device:
end_device-0:0-0  end_device-0:1-1  end_device-0:2-2  end_device-0:3-3
end_device-0:4-4

sas_end_device/end_device-0:0-0:
device  initiator_response_timeout  I_T_nexus_loss_timeout
ready_led_meaning  uevent

sas_end_device/end_device-0:1-1:
device  initiator_response_timeout  I_T_nexus_loss_timeout
ready_led_meaning  uevent

sas_end_device/end_device-0:2-2:
device  initiator_response_timeout  I_T_nexus_loss_timeout
ready_led_meaning  uevent

sas_end_device/end_device-0:3-3:
device  initiator_response_timeout  I_T_nexus_loss_timeout
ready_led_meaning  uevent

sas_end_device/end_device-0:4-4:
device  initiator_response_timeout  I_T_nexus_loss_timeout
ready_led_meaning  uevent

sas_expander:
expander-0:0

sas_expander/expander-0:0:
component_id  component_revision_id  component_vendor_id  device  level
product_id  product_rev  uevent  vendor_id

sas_host:
host0

sas_host/host0:
device  uevent

sas_phy:
phy-0:0    phy-0-0:1   phy-0-0:11  phy-0-0:2  phy-0-0:4  phy-0-0:6
phy-0-0:8  phy-0:1  phy-0:3  phy-0:5  phy-0:7
phy-0-0:0  phy-0-0:10  phy-0-0:12  phy-0-0:3  phy-0-0:5  phy-0-0:7
phy-0-0:9  phy-0:2  phy-0:4  phy-0:6

sas_phy/phy-0:0:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:0:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:1:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:10:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:11:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:12:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:2:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:3:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:4:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:5:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:6:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:7:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:8:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0-0:9:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0:1:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0:2:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0:3:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0:4:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0:5:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0:6:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_phy/phy-0:7:
device                    invalid_dword_count       maximum_linkrate_hw
negotiated_linkrate      running_disparity_error_count  uevent
device_type               loss_of_dword_sync_count  minimum_linkrate
phy_identifier           sas_address
initiator_port_protocols  maximum_linkrate          minimum_linkrate_hw
phy_reset_problem_count  target_port_protocols

sas_port:
port-0:0  port-0:0:0  port-0:0:1  port-0:0:2  port-0:0:3  port-0:0:4

sas_port/port-0:0:
device  num_phys  uevent

sas_port/port-0:0:0:
device  num_phys  uevent

sas_port/port-0:0:1:
device  num_phys  uevent

sas_port/port-0:0:2:
device  num_phys  uevent

sas_port/port-0:0:3:
device  num_phys  uevent

sas_port/port-0:0:4:
device  num_phys  uevent



