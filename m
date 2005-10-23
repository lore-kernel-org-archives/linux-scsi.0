From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: infinite loop with 36 Byte inquiry (sbp2 regression in 2.6.14-rcX)
Date: Sun, 23 Oct 2005 02:33:49 +0200
Message-ID: <435ADA6D.4040705@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:17308 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751331AbVJWAeI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 20:34:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Ben Collins <bcollins@debian.net>

Hi all,

I just noticed that devices which require sbp2's inquiry hack are not 
usable anymore. I don't know when the regression crept in since I don't 
remember when I used the affected device successfully the last time. One 
thing is for sure: The code change which triggered the regression took 
not place in sbp2 itself.

The device in question is an older 2.5" FireWire disk, DViCO Momobay 
CX-1. What happens under Linux 2.6.14-rc5 is this: Without debug logging 
turned on, it seems as if the process which started the sbp2 probe 
(knodemgrd or modprobe) is hanging in D state. But debug logging enabled 
in sbp2 reveals that it isn't locked up but rather caught in a loop, 
sending inquiry commands:

> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_module_init
> Oct 23 01:26:59 shuttle kernel: sbp2: $Rev: 1306 $ Ben Collins <bcollins@debian.org>
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_probe
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_alloc_device
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_alloc_device: allocated hostinfo
> Oct 23 01:26:59 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_parse_unit_directory
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_management_agent_addr = f0010000
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_unit_characteristics = a08
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_command_set_spec_id = 609e
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_command_set = 104d8
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_firmware_revision = 2800
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: Node 1-01:1023: Using 36byte inquiry workaround

Note: The following also happens if sbp2's inquiry blacklist is 
commented out, i.e. if sbp2 does _not_ enable its own inquiry mangling.

> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: sbp2_start_device
> Oct 23 01:26:59 shuttle kernel: ieee1394: sbp2: New SBP-2 device inserted, SCSI ID = 0
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: password_hi/lo initialized
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: login_response_hi/lo initialized
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_query_logins: set lun to 0
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: lun_misc initialized
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: passwd_resp_lengths initialized
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: status FIFO initialized
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: orb byte-swapped
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: login_response/status FIFO memset
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: prepared to write to f0010000
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_login_device: written
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_handle_status_write
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: command_block_agent_hi = ffc1ffff
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: command_block_agent_lo = f0010020
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_set_busy_timeout
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_agent_reset
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_max_speed_and_size
> Oct 23 01:27:00 shuttle kernel: ieee1394: Node 1-01:1023: Max speed [S400] - Max payload [2048]
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_send_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI transfer size = 24
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI s/g elements = 1
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Use scatter/gather
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Only one s/g element
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_handle_status_write
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Found status for command ORB
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Completing SCSI command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_complete_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_response
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_send_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI transfer size = 25
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI s/g elements = 1
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Use scatter/gather
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Only one s/g element
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_handle_status_write
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Found status for command ORB
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: CHECK CONDITION
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_status_to_sense_data
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Completing SCSI command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_complete_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SBP2_SCSI_STATUS_CHECK_CONDITION
> Oct 23 01:27:00 shuttle kernel: scsi0 : destination target 0, lun 0
> Oct 23 01:27:00 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
> Oct 23 01:27:00 shuttle kernel: bh: Current: sense key: Unit Attention
> Oct 23 01:27:00 shuttle kernel:     Additional sense: Invalid field in cdb
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_send_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI transfer size = 25
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI s/g elements = 1
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Use scatter/gather
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Only one s/g element
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_handle_status_write
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Found status for command ORB
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: CHECK CONDITION
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_status_to_sense_data
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Completing SCSI command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_complete_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SBP2_SCSI_STATUS_CHECK_CONDITION
> Oct 23 01:27:00 shuttle kernel: scsi0 : destination target 0, lun 0
> Oct 23 01:27:00 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
> Oct 23 01:27:00 shuttle kernel: bh: Current: sense key: Unit Attention
> Oct 23 01:27:00 shuttle kernel:     Additional sense: Invalid field in cdb
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_send_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI transfer size = 25
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SCSI s/g elements = 1
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Use scatter/gather
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Only one s/g element
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_check_sbp2_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_handle_status_write
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Found status for command ORB
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: CHECK CONDITION
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2_status_to_sense_data
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: Completing SCSI command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: sbp2scsi_complete_command
> Oct 23 01:27:00 shuttle kernel: ieee1394: sbp2: SBP2_SCSI_STATUS_CHECK_CONDITION
> Oct 23 01:27:00 shuttle kernel: scsi0 : destination target 0, lun 0
> Oct 23 01:27:00 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
> Oct 23 01:27:00 shuttle kernel: bh: Current: sense key: Unit Attention
> Oct 23 01:27:00 shuttle kernel:     Additional sense: Invalid field in cdb

The inquiry is repeated endlessly, until the drive is physically plugged 
out. The process which entered into this (knodemgrd or modprobe) becomes 
responsive again after that:

> Oct 23 01:27:07 shuttle kernel: ieee1394: Node changed: 1-02:1023 -> 1-01:1023
> Oct 23 01:27:07 shuttle kernel: ieee1394: Node suspended: ID:BUS[1-01:1023]  GUID[0001041010004beb]
> Oct 23 01:27:12 shuttle kernel: ieee1394: sbp2: aborting sbp2 command
> Oct 23 01:27:12 shuttle kernel: scsi0 : destination target 0, lun 0
> Oct 23 01:27:12 shuttle kernel:         command: Inquiry: 12 00 00 00 24 00
> Oct 23 01:27:12 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:12 shuttle kernel: ieee1394: sbp2: reset requested
> Oct 23 01:27:12 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:12 shuttle kernel: ieee1394: sbp2: reset requested
> Oct 23 01:27:22 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:22 shuttle kernel: ieee1394: sbp2: reset requested
> Oct 23 01:27:32 shuttle kernel: ieee1394: sbp2: sbp2scsi_queuecommand
> Oct 23 01:27:32 shuttle kernel: scsi: Device offlined - not ready after error recovery: host 0 channel 0 id 0 lun 0
> Oct 23 01:27:32 shuttle kernel: scsi scan: 37 byte inquiry failed.  Consider BLIST_INQUIRY_36 for this device
> Oct 23 01:27:32 shuttle kernel: scsi0 (0:0): rejecting I/O to offline device
> Oct 23 01:27:32 shuttle kernel: ieee1394: sbp2: scsi_add_device failed

The inquiry obviously comes from scsi_add_device() -> 
scsi_probe_and_add_lun() -> scsi_probe_lun().

Here is all what sbp2's inquiry hack does:

static int sbp2_send_command(struct scsi_id_instance_data *scsi_id,
			     struct scsi_cmnd *SCpnt,
			     void (*done)(struct scsi_cmnd *))
{
	unchar *cmd = (unchar *) SCpnt->cmnd;
	unsigned int request_bufflen = SCpnt->request_bufflen;
[...]
	if (*cmd == INQUIRY) {
		if (force_inquiry_hack || scsi_id->workarounds &
         	    SBP2_BREAKAGE_INQUIRY_HACK)
			request_bufflen = cmd[4] = 0x24;
		else
			request_bufflen = cmd[4];
	}
	sbp2_create_command_orb(scsi_id, command, cmd, SCpnt->use_sg,
				request_bufflen, SCpnt->request_buffer,
				SCpnt->sc_data_direction);
[...]

As mentioned, the infinite inquiry command loop also happens if the 
inquiry hack is disabled, i.e. if the "else" branche of the above code 
is taken. Furthermore, the loop happens with or without RBC command set 
conversions being done in sbp2. (I discovered that while testing the old 
pending patch which cleanses sbp2 of those conversions.)

I stared intently at scsi_probe_lun() but did not discover yet how the 
infinite loop might happen. It's a bad hour to do such things.
-- 
Stefan Richter
-=====-=-=-= =-=- =-===
http://arcgraph.de/sr/
