From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/10] fnic: FIP VLAN Discovery Feature Support
Date: Wed, 30 Jan 2013 14:36:59 +1100
Message-ID: <1359517019.2373.28.camel@dabdike>
References: <1359504323-14453-1-git-send-email-hiralpat@cisco.com>
	 <1359504323-14453-6-git-send-email-hiralpat@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45209 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752434Ab3A3DhQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2013 22:37:16 -0500
In-Reply-To: <1359504323-14453-6-git-send-email-hiralpat@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hiral Patel <hiralpat@cisco.com>
Cc: linux-scsi@vger.kernel.org, Anantha Prakash T <atungara@cisco.com>

On Tue, 2013-01-29 at 16:05 -0800, Hiral Patel wrote:
> FIP VLAN discovery discovers the FCoE VLAN that will be used by all other FIP protocols
> as well as by the FCoE encapsulation for Fibre Channel payloads on the established
> virtual link. One of the goals of FC-BB-5 was to be as nonintrusive as possible on
> initiators and targets, and therefore FIP VLAN discovery occurs in the native VLAN
> used by the initiator or target to exchange Ethernet traffic. The FIP VLAN discovery
> protocol is the only FIP protocol running on the native VLAN; all other FIP protocols
> run on the discovered FCoE VLANs.
> 
> If an administrator has manually configured FCoE VLANs on ENodes and FCFs, there is no need
> to use this protocol. FIP and FCoE will run over the configured VLANs.
> 
> An ENode without FCoE VLANs configuration would use this automated discovery protocol to
> discover over which VLANs FCoE is running.
> 
> The ENode sends a FIP VLAN discovery request to a multicast MAC address called All-FCF-MACs,
> which is a multicast MAC address to which all FCFs listen.
> 
> All FCFs that can be reached in the native VLAN of the ENode are expected to respond on the
> same VLAN with a response that lists one or more FCoE VLANs that are available for the ENode's
> VN_Port login. This protocol has the sole purpose of allowing the ENode to discover all the
> available FCoE VLANs.
> 
> Now the ENode may enable a subset of these VLANs for FCoE Running the FIP protocol in these
> VLANs on a per VLAN basis. And FCoE data transactions also would occur on this VLAN. Hence,
> Except for FIP VLAN discovery, all other FIP and FCoE traffic runs on the selected FCoE VLAN.
> Its only the FIP VLAN Discovery protocol that is permitted to run on the Default native VLAN
> of the system.
> 
> [**** NOTE ****]
> We are working on moving this feature definitions and functionality to libfcoe module. We need
> this patch to be approved, as Suse is looking forward to merge this feature in SLES 11 SP3 release.
> Once this patch is approved, we will submit patch which should move vlan discovery feature to libfoce.
> 
> Signed-off-by: Anantha Prakash T <atungara@cisco.com>
> Signed-off-by: Hiral Patel <hiralpat@cisco.com>

This one isn't applying for me at the top of the scsi-misc tree:

jejb@dabdike> patch -p1 < .git/rebase-apply/patch 
patching file drivers/scsi/fnic/fnic.h
patching file drivers/scsi/fnic/fnic_fcs.c
patching file drivers/scsi/fnic/fnic_fip.h
patching file drivers/scsi/fnic/fnic_main.c
Hunk #3 FAILED at 411.
Hunk #4 succeeded at 628 (offset -1 lines).
Hunk #5 succeeded at 837 (offset -1 lines).
Hunk #6 succeeded at 926 (offset -1 lines).
Hunk #7 succeeded at 988 (offset -1 lines).
1 out of 7 hunks FAILED -- saving rejects to file drivers/scsi/fnic/fnic_main.c.rej
patching file drivers/scsi/fnic/vnic_dev.c
patching file drivers/scsi/fnic/vnic_dev.h
patching file drivers/scsi/fnic/vnic_devcmd.h

James


