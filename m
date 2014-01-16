From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Configure NPIV fc_vport via
 tcm_qla2xxx_npiv_make_lport
Date: Wed, 15 Jan 2014 18:05:25 -0800
Message-ID: <1389837925.5567.627.camel@haakon3.risingtidesystems.com>
References: <1389764525-24453-1-git-send-email-nab@daterainc.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CCE451@avmb2.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <504EB66DAC8D234EB8E8560985C2D7AD46CCE451@avmb2.qlogic.org>
Sender: target-devel-owner@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hi Quinn,

Thanks for the response.  Comments are inline below..

On Wed, 2014-01-15 at 22:14 +0000, Quinn Tran wrote:
> Nicholas,
> 
> Answer for the following is below.
> 
> <SNIP>
> There are still some bugs to be resolved.  Namely:
> 
> * Determine how to save 'point-to-point' NVRAM settings across target
> restart
> * Figure out why the initiator logs in, but doesn't perform LUN scan on
>    the first login attempt
> * Determine if it's possible to collapse the name formatting further,
>    by generating $NPIV_WWNN internally
> * Determine proper NPIV format for EVPD=0x83 SCSI name string
> 
> Aside from these remaining issues, multiple NPIV ports can be configured
> on a single physical FC port, and initial I/O appears to be functioning
> as expected.
> 
> <SNIP>
> ---
> 
> Bullet 1) After additional analysis by the team of the problem, what you
> have bumped into is a driver design decision and firmware design decision.
>  At the time of the problem, the problem signature did not match with what
> we saw in house and we forgot to reiterate during code submission that you
> must follow the step listed in the setup script.
> 
> The original problem is the driver have not had a chance to get the switch
> capabilities (i.e. NPIV Support bit).  When you attempt to create an NPIV
> host, NPIV creation failed due to a prelim check of the capability.
> 
>          if (!(ha->switch_cap & FLOGI_MID_SUPPORT))
>                 return VPCERR_NO_FABRIC_SUPP;
> 
> 
> When we suggested the "qaucli -n <host #> CO 1", that allows you to
> proceed further.  What happened there is a chip reset was happening behind
> the scene, follow with link up and get the switch capabilities.  However,
> the problem persist on driver unload/load.  When reload, you need another
> nudge to get moving again.
> 
> Driver design: When you load the driver, it most likely that you've used
> driver param "qlini_mode=disabled" (i.e. target mode=on) for all physical
> ports.  In this case, qla driver will not "Initialize the firmware" (i.e.
> not Link up) & will not get the switch capabilities from firmware.  The
> reason for not link up as target port at load time is due to TCM resources
> are not available yet.  If we do linkup as target mode, then remote
> initiator will start LUN discovery and ends up with time out problem due
> to TCM not there to handle the commands.  Because the link is not up, the
> switch capability flags is not read (i.e. NPIV creation failed)
> 
> Firmware design:  Qlogic firmware requires the physical port(i.e. Virtual
> Port 0) to be enabled 1st, before NPIV creation (other VP's).
> 
> This imply that TCM configuration have to enable the physical port 1st
> also (echo 1 > enable), before any NPIV creation can happen. This will be
> the procedure in exercising  this feature.
> 
> 

Thanks for the detailed explanation.

As you noticed, I managed to miss the fact that the underlying physical
port needs to be enabled in target mode before virtual ports can be
configured correctly.

So that said, scratch this particular issue.

> 
> Bullet 2) As to why the LUN scan did not happen on the initial login,
> could be due to the mode the port was told to come up as.   Initiator will
> not scan the lun, if the remote port is also an initiator.  We'll keep an
> eye on this during testing.  Please let us know the steps to recreate.
> 

This is reproducible each time after an NPIV target port has been
configured + enabled.

On the initiator side, (assuming that qla2xxx is already unloaded), the
first 'modprobe qla2xxx' will result in a qla_target session being
established for the correct FC initiator WWPN, but no subsequent ATIO
packet traffic is generated from a initiator side LUN scan.

Doing a initiator side 'rmmod qla2xxx' + second 'modprobe qla2xxx' will
reestablish the qla_target session, and the LUN scan + ATIO packets
begin to flow as expected.

> 
> Bullet 3) Generating NPIV WWPN id:  Qlogic overall strategy for this
> question is: Qla2xxx driver is a common driver being used by various
> hardware vendors(HP, IBM, Dell, etc..).  Each vendors have a different
> scheme on how to generate the WWPN value.  QLogic's design decision is to
> push that up to the user app to generate these values rather having
> QLA2xxx generating it dynamically.
> 

So question here was not contents of the NPIV WWPN value, but rather if
the NPIV WWPN and NPIV WWNN are always expected to have the same suffix.

Eg, is it safe to assume that the '21' and '20' prefixes for NPIV WWPN +
NPIV WWNN are the only different part of the $NPIV_WWPN:$NPIV_WWNN tuple
passed into fc_vport_create()..?

If so, I'd like to remove $NPIV_WWNN from being passed into configfs,
and simply generate this value internally, eg:

  /sys/kernel/config/target/qla2xxx_npiv/$PHYS_WWPN:$NPIV_WWPN

> Bullet 4) VPD Page 83h, SCSI name string.  If you implying to use the WWPN
> as part of the "SCSI name string", the answer is the same as previous
> bullet.  In this case, the setup up script would have to extract the data
> from configfs in order to generate the "SCSI name string"
> 

This question was geared toward how SCSI name should be represented in
INQUIRY EVPD=0x83 for NPIV ports.

For physical ports, this ends up being the 21:00:00:XX:XX:XX:XX:XX value
matching what is passed to configfs.  For virtual ports the passed
$NPIV_WWPN part would be here in similar format, but the question was if
the port_id should also be appended here similar to existing 'lsscsi
--transport' output, eg:

root@devstack:~# lsscsi --transport
[0:0:0:0]    disk    ata:                            /dev/sda 
[91:0:0:0]   disk    fc:0x21111111222222220x610101   /dev/sdb

Thanks again,

--nab
