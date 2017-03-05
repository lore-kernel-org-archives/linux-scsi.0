From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Sun, 5 Mar 2017 17:35:28 +0100
Message-ID: <20170305173528.00006b41@gmx.de>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
        <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jsmart2021@gmail.com
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Nicholas A. Bellinger wrote:
> Hi James & Co,
> 
> Adding target-devel and Sebastian CC'
> 
> On Mon, 2017-02-27 at 15:28 -0800, James Smart wrote:
> > I'd like to announce the availability of the Broadcom (Emulex) FC
> > Target driver - efct.
> > This driver has been part of the Emulex OneCore Storage SDK tool
> > kit for Emulex
> > SLI-4 adapters. The SLI-4 adapters support 16Gb/s and higher
> > adapters. Although this
> > kit has supported FCoE in the past, it is currently limited to FC
> > support.
> > 
> > This driver provides the following:
> > - Target mode operation:
> >    - Functional with LIO-based interfaces  
> 
> Glad to see the upstream push for this after all these years.  :)

How does this compare to ocs_fc_lio? Does efct replace it?
 
> >    - Extensive use of hw offloads such as auto-xfer_rdy, auto-rsp,
> > cmd cpu spreading
> >    - High login mode - thousands of logins
> >    - T-10 DIF/PI support  (inline and separate)
> >    - NPIV support
> > - Concurrent Initiator support if needed
> > - Discovery engine has F_Port and fabric services emulation.
> > - Extended mgmt interfaces:
> >    - firmware dump api, including dump to host memory for faster
> > dumps
> >    - Healthcheck operations and watchdogs
> > - Extended driver behaviors such as:
> >    - polled mode operation
> >    - multi-queue: cpu, roundrobin, or priority  (but not tied  to
> > scsi-mq)
> >    - long chained sgl's
> >    - extensive internal logging and statistics
> >    - Tuning parameters on modes and resource allocation to
> > different features
> > 
> > Broadcom is looking to upstream this driver and would like review
> > and feedback.
> > The driver may be found at the following git repository:
> >      git@gitlab.com:jsmart/efct-Emulex_FC_Target.git
> >   
> 
> Can we get the patch series posted to linux-scsi and target-devel to
> start giving some initial feedback..?
> 
> > 
> > Some of the key questions we have are with lpfc :
> > 1) Coexistence vs integration
> > Currently, the efct driver maps to a different set of PCI ids than
> > lpfc. It's very clear there's an overlap with lpfc, both on SLI-4
> > hw as well as initiator support.
> > Although target mode support can be simplistically added to lpfc,
> > what we've found is
> > that doing so means a lot of tradeoffs. Some of the target mode 
> > features, when enabled,
> > impact the initiator support and how it would operate.
> >   
> 
> I don't really have much preference either way.  

Just like Hannes I do favour integration. I guess it could be
comparable to qla2xxx + tcm_qla2xxx, lpfc + lpfc_scst and
lpfc + tcm_lpfc. That approach might even help Bart with his
target driver unification if he didn't give up on that topic.

> > 2) SLI-3 support
> > lpfc provides SLI-3 support so that all FC adapters are supported, 
> > including the older ones.
> > The form of the driver, based on its history, is SLI-3 with SLI-3 
> > adapted to SLI-4 at the point
> > it hits the hardware. efct does not support SLI-3.  
> 
> AFAIK I think Sebastian was using SLI-3, so he might have some
> comments here.

I do care for SLI-3. Currently I still only got access to 8GFC HBAs and
even our new cards are SLI-3 and not Advanced-8 with SLI-4. Seems like
SLI-3 is not dead yet.

> Since he's been the main person using the original tcm_lpfc code from
> way back when, maybe it would be a good idea to send him a couple of
> SLI-4 HBAs to help with the upstreaming of efct..?

The code I got here is actually a direct port from lpfc + lpfc_scst to
TCM. As of now it kind of works on kernel version 4.10.

> > 
> > 3) complexity of configuration knobs caused by the kitchen-sink of 
> > features in lpfc ?
> > we are pushing the limit on needing per-instance attributes rather
> > than global module
> > parameters.  
> 
> This is exactly what
> /sys/kernel/config/target/efct/$WWPN/tpgt_1/attribute/ is intended
> for.
> 

Sebastian
