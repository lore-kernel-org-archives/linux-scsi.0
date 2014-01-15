From: Quinn Tran <quinn.tran@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Configure NPIV fc_vport via
 tcm_qla2xxx_npiv_make_lport
Date: Wed, 15 Jan 2014 22:14:16 +0000
Message-ID: <504EB66DAC8D234EB8E8560985C2D7AD46CCE451@avmb2.qlogic.org>
References: <1389764525-24453-1-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389764525-24453-1-git-send-email-nab@daterainc.com>
Content-Language: en-US
Content-ID: <DD4F682F6E4CF6448B18A55D28055C7B@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Nicholas,

Answer for the following is below.

<SNIP>
There are still some bugs to be resolved.  Namely:

* Determine how to save 'point-to-point' NVRAM settings across target
restart
* Figure out why the initiator logs in, but doesn't perform LUN scan on
   the first login attempt
* Determine if it's possible to collapse the name formatting further,
   by generating $NPIV_WWNN internally
* Determine proper NPIV format for EVPD=0x83 SCSI name string

Aside from these remaining issues, multiple NPIV ports can be configured
on a single physical FC port, and initial I/O appears to be functioning
as expected.

<SNIP>
---

Bullet 1) After additional analysis by the team of the problem, what you
have bumped into is a driver design decision and firmware design decision.
 At the time of the problem, the problem signature did not match with what
we saw in house and we forgot to reiterate during code submission that you
must follow the step listed in the setup script.

The original problem is the driver have not had a chance to get the switch
capabilities (i.e. NPIV Support bit).  When you attempt to create an NPIV
host, NPIV creation failed due to a prelim check of the capability.

         if (!(ha->switch_cap & FLOGI_MID_SUPPORT))
                return VPCERR_NO_FABRIC_SUPP;


When we suggested the "qaucli -n <host #> CO 1", that allows you to
proceed further.  What happened there is a chip reset was happening behind
the scene, follow with link up and get the switch capabilities.  However,
the problem persist on driver unload/load.  When reload, you need another
nudge to get moving again.

Driver design: When you load the driver, it most likely that you've used
driver param "qlini_mode=disabled" (i.e. target mode=on) for all physical
ports.  In this case, qla driver will not "Initialize the firmware" (i.e.
not Link up) & will not get the switch capabilities from firmware.  The
reason for not link up as target port at load time is due to TCM resources
are not available yet.  If we do linkup as target mode, then remote
initiator will start LUN discovery and ends up with time out problem due
to TCM not there to handle the commands.  Because the link is not up, the
switch capability flags is not read (i.e. NPIV creation failed)

Firmware design:  Qlogic firmware requires the physical port(i.e. Virtual
Port 0) to be enabled 1st, before NPIV creation (other VP's).

This imply that TCM configuration have to enable the physical port 1st
also (echo 1 > enable), before any NPIV creation can happen. This will be
the procedure in exercising  this feature.



Bullet 2) As to why the LUN scan did not happen on the initial login,
could be due to the mode the port was told to come up as.   Initiator will
not scan the lun, if the remote port is also an initiator.  We'll keep an
eye on this during testing.  Please let us know the steps to recreate.


Bullet 3) Generating NPIV WWPN id:  Qlogic overall strategy for this
question is: Qla2xxx driver is a common driver being used by various
hardware vendors(HP, IBM, Dell, etc..).  Each vendors have a different
scheme on how to generate the WWPN value.  QLogic's design decision is to
push that up to the user app to generate these values rather having
QLA2xxx generating it dynamically.


Bullet 4) VPD Page 83h, SCSI name string.  If you implying to use the WWPN
as part of the "SCSI name string", the answer is the same as previous
bullet.  In this case, the setup up script would have to extract the data
from configfs in order to generate the "SCSI name string"



Regards,
Quinn Tran



________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
