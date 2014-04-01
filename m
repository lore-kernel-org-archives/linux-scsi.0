From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/4] target/core: T10-Dif: check HW support capabilities
Date: Mon, 31 Mar 2014 18:03:00 -0700
Message-ID: <1396314180.22665.69.camel@haakon3.risingtidesystems.com>
References: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
	 <1396047927-14189-2-git-send-email-quinn.tran@qlogic.com>
	 <53360E54.5060004@mellanox.com>
	 <504EB66DAC8D234EB8E8560985C2D7AD46CE87D7@avmb2.qlogic.org>
	 <533620C0.9060903@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <533620C0.9060903@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: sagi grimberg <sagig@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-03-29 at 04:24 +0300, sagi grimberg wrote:
> On 3/29/2014 3:53 AM, Quinn Tran wrote:
> > +
> > +    if (dev->dev_attrib.pi_prot_type) {
> > +            uint32_t cap[] = { 0,
> > +                               TARGET_DIF_TYPE1_PROTECTION,
> > +                               TARGET_DIF_TYPE2_PROTECTION,
> > +                               TARGET_DIF_TYPE3_PROTECTION};
> > +            uint32_t pt_bits = cap[dev->dev_attrib.pi_prot_type];
> > +            pt_bits &= se_tpg->fabric_sup_prot_type;
> >> At what point should the fabric fill that? it can vary between portals
> >> right?
> > QT> Yes, protection mode can vary between portals. When user select the
> > physical function (via fabric_make_tpg), you know the specific portal
> > based on user input and its capability. This is where Qlogic register its
> > capabilities based on specific hardware.
> >
> >
> >> I would prefer to do that as a function pointer to explicitly ask the
> >> fabric it's support.
> > QT> is it still require with previous answer ?
> >
> 
> Well, I think it is nicer to explicitly ask the fabric at that point 
> instead of checking what it previously set.
> 

I'm currently working on a series that explicitly queries the fabric for
what PI modes are supported, as per our LSF discussion.

> By the way, I think this patch breaks existing iSER support as iSER 
> doesn't set these bits.
> Thats why I think it would be a good idea to *explicitly* ask.

<nod>

> 
> >
> >>> +                    pr_err("dev[%p]: DIF protection mismatch with fabric "
> >>> +                            "(%s). Transport capability bits[0x%x]\n",
> >>> +                            dev, se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
> >>> +                            se_tpg->fabric_sup_prot_type);
> >>> +                    return -EFAULT;
> >> Didn't we agree that this is allowed and the target core should
> >> compensate on the lack fabric support?
> > <QT> My recollection was that it's not recommended to have different
> > portals with different supported feature.
> 
> Well we seem to remember different things...
> Anyway I think it is better to compensate that in backstore/target-core 
> level, that would be better
> than silently turn off protection. Martin? Nic? your takes?
> 

At the BoF we concluded that when a backend has PI enabled, but the
fabric does not support PI, that target-core should strip off the
INQUIRY + other control bits that normally indicate protection, but only
on that particular path (eg: session).

This would allow different iSCSI network portals to set a se_session bit
at login time in order to indicate if/when protection is supported at
the fabric nexus level.

If it wasn't for iscsi-target / iser-target sharing the same endpoint
across different fabrics, the PI information could simply be queried on
a per /sys/kernel/config/target/$FABRIC/$WWPN/$TPGT endpoint basis, but
alas it's not that simple..

> Also I don't know what rats are hiding here if the backstore is handling 
> IOs in this time...
> What about cleaning up all the protection resources the backstore driver 
> might be managing?
> 
> >   Meaning a SCSI Write without Dif
> > down a none-T10PI portal update the data.  The Guard on the disk is now
> > mismatch with the data. A SCSI Read down a T10PI path will run into a
> > Guard failure.
> >
> > By introducing this option, Disk vendor require additional logic to
> > compensate for this. I think it's cheaper to have supported hardware
> > rather than support nightmare.
> >
> >>> +            }
> >>> +    }
> >>> +
> >>>       if (lun->lun_se_dev !=  NULL) {
> >>>               pr_err("Port Symlink already exists\n");
> >>>               return -EEXIST;
> >>> diff --git a/drivers/target/target_core_tpg.c
> >>> b/drivers/target/target_core_tpg.c
> >>> index c036595..9279971 100644
> >>> --- a/drivers/target/target_core_tpg.c
> >>> +++ b/drivers/target/target_core_tpg.c
> >>> @@ -632,6 +632,15 @@ int core_tpg_set_initiator_node_tag(
> >>>    }
> >>>    EXPORT_SYMBOL(core_tpg_set_initiator_node_tag);
> >>>
> >>> +void core_tpg_set_fabric_t10dif(
> >>> +    struct se_portal_group *tpg,
> >>> +    uint32_t fabric_t10dif_force_on)
> >>> +{
> >>> +    tpg->fabric_t10dif_force_on = fabric_t10dif_force_on;
> >>> +}
> >>> +EXPORT_SYMBOL(core_tpg_set_fabric_t10dif);
> >>> +
> >> Is there a user for this function in this patch?
> > QT> I'm on the fence with this piece.  Just thinking of a case where DIX
> > is not available for initiator side, but user wants to turn on protection
> > at the link layer.  Our test folks would like to cover this case in the
> > future.
> 
> Not sure I understand. Initiator will send the target data+protection 
> (DIX disabled HBA does INSERT), why does this help?
> Why should the target fabric care who generated the protection (OS or HBA)?
> 

So this is the case where the fabric is responsible for doing the WRITE
INSERT + READ_STRIP (which could be in hardware or software), but the
INQUIRY PROTECT bit + friends still need to be masked (on that
particular session) so the initiator does not generate PI information
the host side LLD cannot handle.

--nab
