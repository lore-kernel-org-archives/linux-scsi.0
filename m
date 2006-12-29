From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: sas_device/end_device-*/phy_identifier flipped
Date: Fri, 29 Dec 2006 11:56:26 -0800 (PST)
Message-ID: <953993.32133.qm@web31812.mail.mud.yahoo.com>
References: <4593562F.2000604@torque.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31812.mail.mud.yahoo.com ([68.142.207.75]:31483 "HELO
	web31812.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965132AbWL2UDI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Dec 2006 15:03:08 -0500
In-Reply-To: <4593562F.2000604@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, linux-scsi@vger.kernel.org

--- Douglas Gilbert <dougg@torque.net> wrote:
> In lk 2.6.20-rc2 (and probably earlier) the phy_identifier
> attribute in the /sys/class/sas_device/end_device-*
> directory is showing the wrong end of the point to point
> link.
> 
> Phy identifiers on (dual ported) SAS disks are typically
> 0 and 1. For SATA disks the phy identifier should be 0.
> 
> # lsscsi
> [4:0:0:0]    disk    ATA      ST3160812AS      D     /dev/sda
> [4:0:1:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdb
> # lsscsi -t
> [4:0:0:0]    disk    sas:0x500605b0000033e6          /dev/sda
> [4:0:1:0]    disk    sas:0x5000c500005208ee          /dev/sdb
> # lsscsi -tL 4:0:1:0
> [4:0:1:0]    disk    sas:0x5000c500005208ee          /dev/sdb
>   transport=sas
>   initiator_port_protocols=none
>   initiator_response_timeout=10000
>   I_T_nexus_loss_timeout=1744
>   phy_identifier=7
>   ready_led_meaning=1
>   sas_address=0x5000c500005208ee
>   target_port_protocols=ssp
> 
> # smp_discover -mb
> Device <500605b0000033ef>, expander (only connected phys shown):
>   phy   5:T:attached:[500605b00006f260:03  i(SSP+STP+SMP)]  3 Gbps
>   phy   6:T:attached:[500605b0000033e6:00  t(SATA)]  1.5 Gbps
>   phy   7:T:attached:[5000c500005208ee:01  t(SSP)]  3 Gbps
> 
> 
> The SATA and SAS disks are connected via an expander which
> lets me look at sysfs for 4:0:1:0 and the expander configuration
> with smp_discover. The port in use on the SAS disk has the
> address: 5000c500005208ee . The expander says that cable is
> attached to phy 1 which agrees with what I can see. However
> sysfs reports "phy_identifier=7" which is wrong (and happens
> to be the attached phy_id seen from the SAS disk).
> 
> Both aic94xx and mptsas drivers do the same thing so it
> looks like a SAS transport problem.

Have you tested this with the SAS Stack as I distribute it?

     Luben

