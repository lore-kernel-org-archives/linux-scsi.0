From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: sas_device/end_device-*/phy_identifier flipped
Date: Sat, 30 Dec 2006 18:55:43 -0800 (PST)
Message-ID: <255538.52551.qm@web31814.mail.mud.yahoo.com>
References: <459720E8.6050705@torque.net>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:36715 "HELO
	web31814.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932696AbWLaDCZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Dec 2006 22:02:25 -0500
In-Reply-To: <459720E8.6050705@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

--- Douglas Gilbert <dougg@torque.net> wrote:
> Luben Tuikov wrote:
> > --- Douglas Gilbert <dougg@torque.net> wrote:
> >> In lk 2.6.20-rc2 (and probably earlier) the phy_identifier
> >> attribute in the /sys/class/sas_device/end_device-*
> >> directory is showing the wrong end of the point to point
> >> link.
> >>
> >> Phy identifiers on (dual ported) SAS disks are typically
> >> 0 and 1. For SATA disks the phy identifier should be 0.
> >>
> >> # lsscsi
> >> [4:0:0:0]    disk    ATA      ST3160812AS      D     /dev/sda
> >> [4:0:1:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdb
> >> # lsscsi -t
> >> [4:0:0:0]    disk    sas:0x500605b0000033e6          /dev/sda
> >> [4:0:1:0]    disk    sas:0x5000c500005208ee          /dev/sdb
> >> # lsscsi -tL 4:0:1:0
> >> [4:0:1:0]    disk    sas:0x5000c500005208ee          /dev/sdb
> >>   transport=sas
> >>   initiator_port_protocols=none
> >>   initiator_response_timeout=10000
> >>   I_T_nexus_loss_timeout=1744
> >>   phy_identifier=7
> >>   ready_led_meaning=1
> >>   sas_address=0x5000c500005208ee
> >>   target_port_protocols=ssp
> >>
> >> # smp_discover -mb
> >> Device <500605b0000033ef>, expander (only connected phys shown):
> >>   phy   5:T:attached:[500605b00006f260:03  i(SSP+STP+SMP)]  3 Gbps
> >>   phy   6:T:attached:[500605b0000033e6:00  t(SATA)]  1.5 Gbps
> >>   phy   7:T:attached:[5000c500005208ee:01  t(SSP)]  3 Gbps
> >>
> >>
> >> The SATA and SAS disks are connected via an expander which
> >> lets me look at sysfs for 4:0:1:0 and the expander configuration
> >> with smp_discover. The port in use on the SAS disk has the
> >> address: 5000c500005208ee . The expander says that cable is
> >> attached to phy 1 which agrees with what I can see. However
> >> sysfs reports "phy_identifier=7" which is wrong (and happens
> >> to be the attached phy_id seen from the SAS disk).
> >>
> >> Both aic94xx and mptsas drivers do the same thing so it
> >> looks like a SAS transport problem.
> > 
> > Have you tested this with the SAS Stack as I distribute it?
> 
> Luben,
> Yes, but it is boring because it just works ***.

Yes, I agree -- things are boring when they just work.

> With your driver for a different port on the same SAS
> disk, lsscsi outputs:
> 
> # lsscsi -tL 6:0:0:0
> [6:0:0:0]    disk    sas:5000c500005208ed            /dev/sdd
>   transport=sas
>   sub_transport=sas_class
>   device_name=0000000000000000
>   dev_type=end device
>   iproto=
>   iresp_timeout=0x2710
>   linkrate=3,0 Gbps
>   max_linkrate=3,0 Gbps
>   max_pathways=1
>   min_linkrate=3,0 Gbps
>   pathways=1
>   ready_led_meaning=1
>   rl_wlun=0
>   sas_addr=5000c500005208ed
>   tproto=SSP
>   transport_layer_retries=0
> 
> lsscsi is data mining this directory:
> /sys/class/scsi_device/6:0:0:0/device/sas_device
> 
> which contains:
> # ls
> device_name    itnl_timeout  max_pathways       rl_wlun
> dev_type       linkrate      min_linkrate       sas_addr
> iproto         LUNS          pathways           tproto
> iresp_timeout  max_linkrate  ready_led_meaning  transport_layer_retries
> 
> Interestingly there is no phy_id entry (and a single
> entry wouldn't be sufficient if the target was
> wide port). I can live without the phy_id there (as
> it can be found other ways: SMP and the protocol
> specific (SAS) log page).
> 
> So the bottom line is that the phy_id(s) doesn't need
> to be there but if it is it should be correct.

Indeed, you assesment is very correct.  "phy_id(s)" have no
business there.  They should be represented implicitly by
the way the port is "built" _and_ only for the initiator's ports
as is done in my SAS stack.

The "sas_device" "directory" contains attributes which
belong to the SAS device.

Also, "internal" domain ports and their properties should
NOT represented and for very good reasons which I've hinted
at in my numerous emails on the subject matter last year
on this list.

> *** I plan to write another mail on the aic94xx
> driver mess.

What mess?  Did I fail to see and read an email?

   Luben

