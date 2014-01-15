From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] qla2xxx: Configure NPIV fc_vport via
 tcm_qla2xxx_npiv_make_lport
Date: Wed, 15 Jan 2014 13:45:03 -0800
Message-ID: <1389822303.5567.551.camel@haakon3.risingtidesystems.com>
References: <1389764525-24453-1-git-send-email-nab@daterainc.com>
	 <987039D6-194C-4CB2-910E-4FEEBB9630B9@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <987039D6-194C-4CB2-910E-4FEEBB9630B9@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: Giridhar Malavali <giridhar.malavali@qlogic.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Quinn Tran <quinn.tran@qlogic.com>, Sawan Chandak <sawan.chandak@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hi Giridhar & Co,

A few more questions below..

On Wed, 2014-01-15 at 16:06 +0000, Giridhar Malavali wrote:
>
> > On Jan 14, 2014, at 10:02 PM, "Nicholas A. Bellinger" <nab@daterainc.com> wrote:
> > 
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi Saurav & Co,
> > 
> > Here is the updated NPIV patch on top of the original here:
> > 
> >  [PATCH] qla2xxx: Enhancements to enable NPIV support for QLOGIC ISPs with TCM/LIO.
> >  http://marc.info/?l=linux-scsi&m=138930044930212&w=2
> > 
> Thanks. We will review and get back.
> 
> 
> > As previously dicussed, it moves fc_vport creation into tcm_qla2xxx
> > control plane code thus allowing everything required for NPIV port
> > creation to be encapsulated within configfs.
> > 
> > There are still some bugs to be resolved.  Namely:
> > 
> > * Determine how to save 'point-to-point' NVRAM settings across target restart
> 
> We will look into this. 
> 
> > * Figure out why the initiator logs in, but doesn't perform LUN scan on
> >   the first login attempt

Not sure what's happening here, but the same issue with the original
patch too.

> > * Determine if it's possible to collapse the name formatting further,
> >   by generating $NPIV_WWNN internally

Wrt to this bit..  There is never a case where the trailing bytes for
$NPIV_WWPN + $NPIV_WWNN would be different, right..?

If that's the case, then collapsing the /sys/kernel/config/target/qla2xxx/
formatting to $PHYSICAL_WWPN:$NPIV_WWPN makes sense here, and simply
generate the $NPIV_WWNN required for fc_vport_create() internally in
tcm_qla2xxx code.

> > * Determine proper NPIV format for EVPD=0x83 SCSI name string
> > 

AFAICT this should be the $NPIV_WWN + port_id, correct..?

> > Aside from these remaining issues, multiple NPIV ports can be configured
> > on a single physical FC port, and initial I/O appears to be functioning
> > as expected.
> > 
> 
> That's good.
> > 

:-)

--nab
