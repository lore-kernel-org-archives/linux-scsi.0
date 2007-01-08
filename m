From: Douglas Gilbert <dougg@torque.net>
Subject: Re: lsscsi version 0.19 beta
Date: Mon, 08 Jan 2007 10:06:24 -0500
Message-ID: <45A25DF0.4070703@torque.net>
References: <4577B06D.6060701@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45517 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXAHPGc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 10:06:32 -0500
In-Reply-To: <4577B06D.6060701@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: greg@kroah.com

Further to the announcement 1 month ago (shown below),
there is another lsscsi-0.19 beta at:
http://www.torque.net/sg [News section].
It provides target (and sometimes host) transport
information for:
  - IEEE1394 (sbp)
  - FC
  - ISCSI
  - SAS (two representations)
  - SPI

It has tested with lk 2.6.20-rc3 . Unfortunately fetching
information out of sysfs could become a maze of kernel
version dependencies as various maintainers change
representations. This beta was tested with the intriguingly
named SYSFS_DEPRECATED config option deselected. Sysfs
is not deprecated yet (sigh) but deselecting SYSFS_DEPRECATED
removes various symlinks which breaks earlier lsscsi
betas.

Thanks to the maintainers of various SCSI transports
for helping me find what information is available in
sysfs and testing code for me. They are named in the
CREDITS file.

Doug Gilbert


Douglas Gilbert wrote [2006/12/7]:
> The last announcement I made to this list about lsscsi
> was back in March and that was a beta for lsscsi version
> 0.18 . The change proposed by James Bottomley that prompted
> the beta has not materialized. So I decided to release
> version 0.18 without fanfare a week ago and start adding
> transport information to lsscsi, dubbing it version 0.19
> beta. See http://www.torque.net/scsi/lsscsi.html for
> downloads.
> 
> The mushrooming of information (and different representations)
> in /sys has made it possible for lsscsi to provide a lot
> more information than it has previously. Ironically what
> storage device identification really needs is not available,
> namely the logical unit _name_ which, for SCSI devices, is
> obtained from the device identification VPD page (0x83).
> As a consolation there is lots of transport information.
> 
> So this beta adds transport information, both target
> and initiator (host) for these transports:
>   - FC
>   - SAS
> 
> I hope to add iSCSI if I can find a way through its maze.
> Perhaps USB and 1394 are candidates as well, even SPI.
> In the case of SAS, both the SAS transport layer and the
> SAS class (i.e. Luben Tuikov's design) representations
> are supported.
> 
> The new options are '--transport' (or '-t') and '--list'
> (or '-L').
> 
> Here is an example where disk strings are insufficient:
> # lsscsi
> [4:0:0:0]    disk    ATA      ST3160812AS      D     /dev/sda
> [4:0:1:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdb
> [4:0:2:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdc
> [4:0:3:0]    disk    ATA      ST380013AS       3.18  /dev/sdd
> [4:0:4:0]    disk    SEAGATE  ST336754SS       0003  /dev/sde
> [4:0:5:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdf
> [5:0:0:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdg
> [5:0:1:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdh
> [5:1:0:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdi
> [5:1:1:0]    disk    SEAGATE  ST336754SS       0003  /dev/sdj
> 
> How many disks are there? Looking at the transport information:
> # lsscsi -t
> [4:0:0:0]    disk    sas:0x0b1d2c035c7e5d4c          /dev/sda
> [4:0:1:0]    disk    sas:0x5000c500005208ed          /dev/sdb
> [4:0:2:0]    disk    sas:0x5000c50000520a29          /dev/sdc
> [4:0:3:0]    disk    sas:0x500605b0000033e1          /dev/sdd
> [4:0:4:0]    disk    sas:0x5000c500005208ee          /dev/sde
> [4:0:5:0]    disk    sas:0x5000c50000520a2a          /dev/sdf
> [5:0:0:0]    disk    sas:5000c500005208ed            /dev/sdg
> [5:0:1:0]    disk    sas:5000c50000520a29            /dev/sdh
> [5:1:0:0]    disk    sas:5000c500005208ee            /dev/sdi
> [5:1:1:0]    disk    sas:5000c50000520a2a            /dev/sdj
> 
> So everything is SAS attached, including two SATA disks.
> Something strange is happening with 4:0:0:0 which is
> directly attached to the host4. From the target SAS
> addresses it can be seen that /dev/sdc and /dev/sdh
> are the same port (and because the lun is 0 in both
> cases, it must be the same lu). There are three other
> pairs there, reducing what looks like 10 disks to
> six. The adjacent SAS addresses are dual ports on the
> same disk, so the actual number of disks is 4.
> Why are some SAS addresses prefixed with 0x and other
> not? lsscsi simply prints out what is in /sys !
> 
> To fetch further information about the target that contains
> /dev/sdf using a filter to reduce clutter:
> # lsscsi --transport --list 4:0:5:0
> [4:0:5:0]    disk    sas:0x5000c50000520a2a          /dev/sdf
>   transport=sas
>   initiator_port_protocols=none
>   initiator_response_timeout=0
>   I_T_nexus_loss_timeout=1744
>   phy_identifier=11
>   ready_led_meaning=0
>   sas_address=0x5000c50000520a2a
>   target_port_protocols=ssp
> 
> A similar check on the target containing /dev/sdj
> # lsscsi -t -L 5:1:1
> [5:1:1:0]    disk    sas:5000c50000520a2a            /dev/sdj
>   transport=sas
>   sub_transport=sas_class
>   device_name=0000000000000000
>   dev_type=end device
>   iproto=
>   iresp_timeout=0x0000
>   linkrate=3,0 Gbps
>   max_linkrate=3,0 Gbps
>   max_pathways=1
>   min_linkrate=3,0 Gbps
>   pathways=1
>   ready_led_meaning=0
>   rl_wlun=0
>   sas_addr=5000c50000520a2a
>   tproto=SSP
>   transport_layer_retries=0
> 
> Finally here is a listing of hosts, then a listing of hosts
> with their initiator identifier (if known) and finally a
> closer look at host4 (with and without transport specific
> information):
> # lsscsi --hosts
> [0]    sata_nv
> [1]    sata_nv
> [2]    sata_nv
> [3]    sata_nv
> [4]    mptsas
> [5]    aic94xx
> 
> # lsscsi --hosts --transport
> [0]    sata_nv
> [1]    sata_nv
> [2]    sata_nv
> [3]    sata_nv
> [4]    mptsas        sas:0x500605b00006f260
> [5]    aic94xx       sas:50000d10002dc000
> 
> # lsscsi -H -t --list 4
> [4]    mptsas        sas:0x500605b00006f260
>   transport=sas
>   device_type=end device
>   initiator_port_protocols=smp, stp, ssp
>   invalid_dword_count=0
>   loss_of_dword_sync_count=0
>   maximum_linkrate=3.0 Gbit
>   maximum_linkrate_hw=3.0 Gbit
>   minimum_linkrate=1.5 Gbit
>   minimum_linkrate_hw=1.5 Gbit
>   negotiated_linkrate=Unknown
>   phy_identifier=0
>   phy_reset_problem_count=0
>   running_disparity_error_count=0
>   sas_address=0x500605b00006f260
>   target_port_protocols=none
> 
> # lsscsi -H --list host4
> [4]    mptsas
>   can_queue=127
>   cmd_per_lun=7
>   host_busy=0
>   sg_tablesize=128
>   state=running
>   unchecked_isa_dma=0
>   unique_id=0
> 
> 
> Doug Gilbert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

