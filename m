From: Steve Magnani <steve.magnani@digidescorp.com>
Subject: Re: [Scst-devel] [SPF:fail] Re: FC initiator performance tanks once
 target mode is enabled
Date: Mon, 23 Dec 2013 09:13:28 -0600
Message-ID: <1387811608.1722.20.camel@iscandar.digidescorp.com>
References: <201312141651.rBEGpZ59028749@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60324 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3LWPNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 10:13:31 -0500
Received: by mail-ie0-f180.google.com with SMTP id tp5so5956231ieb.39
        for <linux-scsi@vger.kernel.org>; Mon, 23 Dec 2013 07:13:30 -0800 (PST)
In-Reply-To: <201312141651.rBEGpZ59028749@wind.enjellic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: greg@enjellic.com, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Nicholas,

On Sat, 2013-12-14 at 10:51 -0600, Dr. Greg Wettstein wrote:
> On Dec 12, 11:45am, "Nicholas A. Bellinger" wrote:
> > > What I would prefer myself is to have a single set of target drivers
> > > that works for both LIO and SCST. That would not only make both projects
> > > easier to maintain but also would expose all target drivers to wider
> > > testing. However, since the interface between target core and target
> > > drivers is very different for LIO and for SCST reaching this goal would
> > > be a challenging project by itself.
> 
> > After spending 18+ months on qla2xxx target code, and getting it
> > into a state that it could withstand public scrutiny for mainline
> > acceptance, I have no interest in making changes to mainline driver
> > code for supporting someone else's out-of-tree stuff.
> 
> I believe, to be fair, that if it took 18 months to get the qla2x00t
> code ported into the kernel that it would have taken even longer to
> get fibre-channel support for the in-kernel target stack if the
> process would have started from scratch.  The kernel implementation
> stands very heavily on engineering work which Vlad, ID7 and others put
> into the target code.
> 
> Secondary to implementing the sqatgt driver I have been through every
> line of both Vlad's code and your derivative work.  It is a straight
> forward exercise to follow both pieces of work side by side.
> 
> So despite all the hostility and rancor which surrounds the two major
> Linux SCSI target implementations, lets concede that the in-kernel
> fibre-channel driver benefited a great deal from the efforts of the
> SCST community.  This coming from someone who arranged for a small
> amount of financial support for some of the code which is currently
> residing in the in-kernel Qlogic target driver.
> 
> > We don't add interfaces into mainline drive code to support
> > out-of-tree projects, because quite frankly, it gives less incentive
> > for the out-of-tree holdouts to use, improve and contribute to
> > mainline target code.
> 
> But the kernel does provide services to external users through a
> binary API supplied by exported symbols.  Your work on the Qlogic
> fibre-channel target driver includes all but one small function needed
> to allow SCST to use the in kernel driver.
> 
> To Nicholas' credit, the engineering work done on the qla2x00t driver,
> as a component of porting it into the kernel, provides almost all of
> the resources needed for a straight forward integration of SCST.
> Having anticipated this debate we focused on designing the sqatgt
> interface driver so it would integrate cleanly with the architectural
> model selected for the kernel.
> 
> Bart, if you could review the in-kernel Qlogic driver you will find
> the the tcm_qla2xxx.c module interfaces the Qlogic driver with the
> in-kernel SCSI target engine.  Similar functionality is provided by
> the scst_qla2xxx.c in the sqatgt driver for SCST.  So there is a
> reasonably straight forward and standardized approach for getting both
> projects on a common driver infrastructure, which as you note benefits
> everyone.
> 
> The only missing piece of the puzzle is an exported function to
> enumerate the target interfaces which are available.  Since there are
> exported functions to enable/disable interfaces, handle session
> management and a variety of other functions it doesn't seem
> unreasonable to provide a method of enumerating which interfaces are
> available for target mode.
> 
> So Nicholas in the spirit of everyone working for the common good of
> the storage community I'm hoping you will support our proposal of the
> following patch to Andrew Vasquez and the Qlogic maintainers:
> 
> ---------------------------------------------------------------------------
> +void
> +qlt_get_target_list(void (*callback)(struct scsi_qla_host *))
> +{
> +       struct qla_tgt *tgt;
> +
> +        mutex_lock(&qla_tgt_mutex);
> +        list_for_each_entry(tgt, &qla_tgt_glist, tgt_list_entry) {
> +               (*callback)(tgt->vha);
> +       }
> +        mutex_unlock(&qla_tgt_mutex);
> +
> +       return;
> +}
> +EXPORT_SYMBOL(qlt_get_target_list);
> ---------------------------------------------------------------------------
> 
> Which provides the only missing piece needed for SCST to live happily
> on as a modular extension to the kernel.  With this in place we can
> all focus on more pressing issues, such as why Steve Magnani can't get
> two ports on the same ISP chip to run in different modes.

I have code from QLogic that appears to resolve the issue with which I
started this thread, namely crummy initiator performance when the same
physical port is configured for dual initiator and target mode. QLogic's
code appears to be a fusion of the mainline qla2xxx driver and SCST,
which makes it taxonomically close to Greg's sqatgt proposal.

Once I figure out which portions of QLogic's code resolve the issue I
would be happy to post them as patches to mainline. But I can't justify
the effort to do that if Greg's proposal is DOA, since I wouldn't be
able to make use of the resulting patched code.

As an engineer with a problem to solve and a deadline, I don't much care
whether the name of the solution is LIO or SCST. But it is a necessity
of my project that the target implementation reside in userland. AFAIK
LIO does not support this, nor plan to. 

I agree with core kernel maintainers that encouraging out-of-tree binary
drivers (a la NVidia) is a Bad Thing, but that's not what's being
requested here. Please don't throw the baby out with the bathwater.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>

