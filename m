From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] [SPF:fail] Re: FC initiator performance tanks once
 target mode is enabled
Date: Mon, 23 Dec 2013 12:20:52 -0800
Message-ID: <1387830052.5567.194.camel@haakon3.risingtidesystems.com>
References: <201312141651.rBEGpZ59028749@wind.enjellic.com>
	 <1387811608.1722.20.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44945 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab3LWUTr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 15:19:47 -0500
In-Reply-To: <1387811608.1722.20.camel@iscandar.digidescorp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steve Magnani <steve.magnani@digidescorp.com>
Cc: greg@enjellic.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mon, 2013-12-23 at 09:13 -0600, Steve Magnani wrote:
> Nicholas,
> 
> On Sat, 2013-12-14 at 10:51 -0600, Dr. Greg Wettstein wrote:
> > On Dec 12, 11:45am, "Nicholas A. Bellinger" wrote:

<SNIP>

> > > We don't add interfaces into mainline drive code to support
> > > out-of-tree projects, because quite frankly, it gives less incentive
> > > for the out-of-tree holdouts to use, improve and contribute to
> > > mainline target code.
> > 
> > But the kernel does provide services to external users through a
> > binary API supplied by exported symbols.  Your work on the Qlogic
> > fibre-channel target driver includes all but one small function needed
> > to allow SCST to use the in kernel driver.
> > 
> > To Nicholas' credit, the engineering work done on the qla2x00t driver,
> > as a component of porting it into the kernel, provides almost all of
> > the resources needed for a straight forward integration of SCST.
> > Having anticipated this debate we focused on designing the sqatgt
> > interface driver so it would integrate cleanly with the architectural
> > model selected for the kernel.
> > 
> > Bart, if you could review the in-kernel Qlogic driver you will find
> > the the tcm_qla2xxx.c module interfaces the Qlogic driver with the
> > in-kernel SCSI target engine.  Similar functionality is provided by
> > the scst_qla2xxx.c in the sqatgt driver for SCST.  So there is a
> > reasonably straight forward and standardized approach for getting both
> > projects on a common driver infrastructure, which as you note benefits
> > everyone.
> > 
> > The only missing piece of the puzzle is an exported function to
> > enumerate the target interfaces which are available.  Since there are
> > exported functions to enable/disable interfaces, handle session
> > management and a variety of other functions it doesn't seem
> > unreasonable to provide a method of enumerating which interfaces are
> > available for target mode.
> > 
> > So Nicholas in the spirit of everyone working for the common good of
> > the storage community I'm hoping you will support our proposal of the
> > following patch to Andrew Vasquez and the Qlogic maintainers:
> > 
> > ---------------------------------------------------------------------------
> > +void
> > +qlt_get_target_list(void (*callback)(struct scsi_qla_host *))
> > +{
> > +       struct qla_tgt *tgt;
> > +
> > +        mutex_lock(&qla_tgt_mutex);
> > +        list_for_each_entry(tgt, &qla_tgt_glist, tgt_list_entry) {
> > +               (*callback)(tgt->vha);
> > +       }
> > +        mutex_unlock(&qla_tgt_mutex);
> > +
> > +       return;
> > +}
> > +EXPORT_SYMBOL(qlt_get_target_list);
> > ---------------------------------------------------------------------------
> > 
> > Which provides the only missing piece needed for SCST to live happily
> > on as a modular extension to the kernel.  With this in place we can
> > all focus on more pressing issues, such as why Steve Magnani can't get
> > two ports on the same ISP chip to run in different modes.
> 
> I have code from QLogic that appears to resolve the issue with which I
> started this thread, namely crummy initiator performance when the same
> physical port is configured for dual initiator and target mode. QLogic's
> code appears to be a fusion of the mainline qla2xxx driver and SCST,
> which makes it taxonomically close to Greg's sqatgt proposal.
> 

Glad to hear that you where able to resolve the issue on your setup.

However, as you've noticed mixed mode operation is currently unsupported
in mainline qla_target.c code, due to the fact that there is not yet a
clean method to transition between target + initiator mode for a given
qla2xxx port.

All of the methods for doing this in the original out-of-tree code where
terribly ugly hacks (and continue to be), and hence where left-out for
the mainline merge.

> Once I figure out which portions of QLogic's code resolve the issue I
> would be happy to post them as patches to mainline. But I can't justify
> the effort to do that if Greg's proposal is DOA, since I wouldn't be
> able to make use of the resulting patched code.
> 

My issue with Greg's proposal is the additional of new interfaces
specific to out-of-tree code, that no mainline code utilizes.  To
repeat, we do not add interfaces that are specific to out-of-tree code,
regardless of what subsystem / driver they reside.

So what needs to happen with Greg's effort is to convert to using
existing interfaces for qla2xxx port registration that tcm_qla2xxx is
already using, eg: qlt_lport_register() + qlt_lport_deregister(), and
make them work for his use-case.

They already provide what is required for an a mainline or out-of-tree
target stack to function, and yes, even ensure that multiple target
stacks can play nicely with qla_target.c logic at the same time.

> As an engineer with a problem to solve and a deadline, I don't much care
> whether the name of the solution is LIO or SCST. But it is a necessity
> of my project that the target implementation reside in userland. AFAIK
> LIO does not support this, nor plan to. 
> 

Not true.  The patches for target_core_user.c where posted last month by
Shaohua Li, and after review over the next weeks will end up being a
v3.14 -> v3.15 item for mainline.

> I agree with core kernel maintainers that encouraging out-of-tree binary
> drivers (a la NVidia) is a Bad Thing, but that's not what's being
> requested here. Please don't throw the baby out with the bathwater.
> 

That's not the issue here.  Greg's effort needs to use existing qla2xxx
port registration interfaces instead of creating a new one specific to
out-of-tree code.

--nab

