From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] [SPF:fail] Re: FC initiator performance tanks once target mode is enabled
Date: Thu, 26 Dec 2013 09:22:54 -0600
Message-ID: <201312261522.rBQFMsu7016680@wind.enjellic.com>
References: <nab@linux-iscsi.org>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:39807 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab3LZPsG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Dec 2013 10:48:06 -0500
In-Reply-To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
       "Re: [Scst-devel] [SPF:fail] Re: FC initiator performance tanks once target mode is enabled" (Dec 23, 12:20pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Steve Magnani <steve.magnani@digidescorp.com>
Cc: scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Dec 23, 12:20pm, "Nicholas A. Bellinger" wrote:
} Subject: Re: [Scst-devel] [SPF:fail] Re: FC initiator performance tanks on

Hi, hope the week is going well for everyone.

At the risk of wading into this controversy any further I thought it
might be helpful to clarify some issues given the dynamics of this
situation.

> > Once I figure out which portions of QLogic's code resolve the issue I
> > would be happy to post them as patches to mainline. But I can't justify
> > the effort to do that if Greg's proposal is DOA, since I wouldn't be
> > able to make use of the resulting patched code.

> My issue with Greg's proposal is the additional of new interfaces
> specific to out-of-tree code, that no mainline code utilizes.  To
> repeat, we do not add interfaces that are specific to out-of-tree
> code, regardless of what subsystem / driver they reside.

I think the overriding issue to consider here is there was no desire
by the SCST community to keep the codebase out of the mainline kernel.

This isn't a case of a group attempting to leverage kernel resources
while hiding their own efforts.  As I noted previously the Qlogic
target code base, modulo your significant efforts, was largely a
result of the work which was initiated in the SCST community.

Given that, I believe it is not unreasonable to review whether or not
the target code has, what a reasonable person would consider, is a
necessary and sufficient set of interfaces.

> So what needs to happen with Greg's effort is to convert to using
> existing interfaces for qla2xxx port registration that tcm_qla2xxx is
> already using, eg: qlt_lport_register() + qlt_lport_deregister(), and
> make them work for his use-case.
> 
> They already provide what is required for an a mainline or out-of-tree
> target stack to function, and yes, even ensure that multiple target
> stacks can play nicely with qla_target.c logic at the same time.

Everyone's time is at a premium but I believe this discussion would be
facilitated by a review of the sqatgt code.  Here are a couple of
extracts which may be helpful:

+static int sqa_enable_tgt(struct scst_tgt *scst_tgt, bool enable)
+{
+       struct qla_tgt *tgt;
+       struct scsi_qla_host *vha;
+
+       TRACE_ENTRY();
+
+       tgt = scst_tgt_get_tgt_priv(scst_tgt);
+       vha = tgt->vha;

.. [ removed ] ...

+       qlt_lport_register(&sqa_qla2xxx_template, wwn_to_u64(vha->port_name),
+                          sqa_lport_callback, scst_tgt);
+       qlt_enable_vha(vha);
+
+       TRACE_EXIT();
+       return 0;
+}

----

+static void sqa_target_release_cb(struct scsi_qla_host *vha)
+{
+       TRACE_ENTRY();
+
+       if (vha->hw->tgt.tgt_ops == NULL)
+               return;

.. [ removed ] ...

+       qlt_lport_deregister(vha);
+
+       TRACE_EXIT();
+       return;
+}

In SCST the qlogic port registration occurs when target mode is
enabled on the interface, ie:

	echo 1 >/sys/kernel/scst_tgt/targets/sqatgt/PWWN/enabled

Since the exported qla_target interfaces operate on 'struct
scsi_qla_host' pointer values a list of those pointers which the
Qlogic driver core has initialized as target capable is a requirement.
Since that list is static, as is the lock which protects it, a
callback interface seemed an appropriate method of obtaining this
information.

If there are suggestions for an alternative strategy I would be happy
to implement it.

Otherwise, a review of the sqatgt code will review that it implements
all of the function callback pointers in 'struct qla_tgt_func_tmpl' as
well as only using symbols which are officially exported.  It is my
contention that obtaining a list of target capable interfaces is
something which would be considered a necessary element of a properly
architected target mode driver.

The MAINTAINERS file suggests that Andrew Vasquez is the custodian of
everything in 'drivers/scsi/qla2xxx'.  If there is no consensus on an
alternative implementation I will submit a patch to Andrew for his
review.  As others have noted, having everyone on a standard codebase
would seem to be of maximal benefit to the kernel.

> > I agree with core kernel maintainers that encouraging out-of-tree binary
> > drivers (a la NVidia) is a Bad Thing, but that's not what's being
> > requested here. Please don't throw the baby out with the bathwater.

> That's not the issue here.  Greg's effort needs to use existing
> qla2xxx port registration interfaces instead of creating a new one
> specific to out-of-tree code.

As I detailed above, the sqatgt driver does use the existing
(de)-registration interfaces.  Unfortunately, that interface requires
a pointer to a target capable device definition structure, which the
callback provides.  Something of utility to not only SCST but any
other potential SCSI target stack which may evolve.

Which by definition would be considered 'out-of-tree'.

> --nab

I hope the above is helpful.

Best wishes for a productive remainder of the week.

}-- End of excerpt from "Nicholas A. Bellinger"

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Prioritization is a favorite management buzzword.  What it really means
 is stuff that isn't going to get done."
                                -- C.J. Peters, MD
                                   Chief, Special Pathogens Branch, CDC.
