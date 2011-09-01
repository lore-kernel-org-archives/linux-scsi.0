From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: [PATCH] [SCSI]: Allow expander T-T attachments
Date: Thu, 1 Sep 2011 08:58:45 -0700
Message-ID: <FC1F9E38C0703341A1A750524E2525A901853F88@XYUS-EX22.xyus.xyratex.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com> <1314812608.95574.YahooMailNeo@web31804.mail.mud.yahoo.com> <FC1F9E38C0703341A1A750524E2525A901853EFC@XYUS-EX22.xyus.xyratex.com> <1314891245.3067.11.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:57096 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478Ab1IAQCg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Sep 2011 12:02:36 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1314891245.3067.11.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-scsi@vger.kernel.org, Darrick J Wong <djwong@us.ibm.com>

Ok James, my take on this (a rationalization):

I believe the SAS 2.0 enhancements are orthogonal and the expanders will
stage-in these new features.

Every change in the shape of the libsas structures creates an ABI break
for all the libsas-dependent drivers. Fine for kernel.org, expected and
barely noticed, but the ABI break affects Distributions as they will not
be able to weakly-link modules from Quarterly Update to Quarterly
Update. This will create resistance at every step of the way as SAS 2.0
code migrates in from whatever source.

I find Luben's patch suitable primarily because it has staked some
useful territory which will make the move to all the SAS 2.0 features
less costly on the Distributions. I also find that this territory, even
if Luben has or does not have plans, to be inert but future-proofed.
Knowing how to use them may create issues though for the chosen
algorithms and for that reason alone I could be convinced that we should
drop these until someone somewhere uses them in their own model (ok, I
waffle, but placing /* reserved */ after each will solve most of the
worry about misuse).

I would expect that the enhancements to deal with self-configuring
expanders (which Xyratex does not have ... yet) to be an orthogonal
effort (minus the staked out territory) and along with other issues and
deficiencies more complicated to merge in.

I would appeal that you, and all other stakeholders, be willing to take
Luben's patch unmodified (or at least with /* reserved */ comments) with
the understanding that someone somewhere is going to take on the other
enhancements for 2.0 as they hit *real* hardware. And if this one is
taken (to at least the pending tree), we will make sure it is tested and
get back to the list if we find borkenness(sic).

Approved: <msalyzyn@us.xyratex.com>

Sincerely -- Mark Salyzyn

ObligatoryDisclaimer: Ignore the Xyratex tacked-on disclaimer.

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Thursday, September 01, 2011 11:34 AM
To: Mark Salyzyn
Cc: Luben Tuikov; linux-scsi@vger.kernel.org; Darrick J Wong
Subject: RE: [PATCH] [SCSI]: Allow expander T-T attachments

On Wed, 2011-08-31 at 10:51 -0700, Mark Salyzyn wrote:
> We will need James to chime in why your patch did not go in. My
> assumption is the lack of response to his question left it in limbo.

That's a good assumption.  A maintainers list folder is usually sorted
by thread and by activity.  I mark patches for inclusion, but if a
thread is expecting a reply I don't do anything since it comes back to
the top again once there's activity on it.

> The likely modification to your patch would be to remove all the
> unused added flags rather than staking out the territory.

Well, yes, but the question is broader than that.  In theory we can't
support SAS2.0 expanders until we support all of their features.  Table
to Table routing is one, but self configuration is another.  If there
are no current self configuring expanders, I'm OK with just doing table
to table ... but the extra bits made me wonder.

James


> What kind of testing was involved in your patch? I have not merged
> yours in here to try it out on our enclosures. Either way, I want to
> see some movement; James any directions?
> 
> Sincerely -- Mark Salyzyn
> 
> -----Original Message-----
> From: Luben Tuikov [mailto:ltuikov@yahoo.com] 
> Sent: Wednesday, August 31, 2011 1:43 PM
> To: Mark Salyzyn; linux-scsi@vger.kernel.org
> Cc: Darrick J Wong; James Bottomley
> Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
> 
> ----- Original Message -----
> 
> > From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
> > To: linux-scsi@vger.kernel.org
> > Cc: Luben Tuikov <ltuikov@yahoo.com>; Darrick J Wong
<djwong@us.ibm.com>; James Bottomley <jbottomley@parallels.com>
> > Sent: Wednesday, August 31, 2011 6:44 AM
> > Subject: Re: [PATCH] [SCSI]: Allow expander T-T attachments
> > 
> > Since Luben's patch on July 28th 2011 went nowhere, as there was an
> > unanswered question regarding the future-proofing that Luben added
in.
> 
> Are you saying that the patch I posted,
> http://marc.info/?t=131182720200001&r=1&w=2, didn't go in
> because I didn't entertain Bottomley's unrelated question therein?
> Or are you saying that it did go in based on TECHNICAL CONTENT? I.e.
it
> was buggy, or wrong, etc?
> 
> > I decided to submit a simplified focussed patch we have been using
for the
> 
> By "simplified, focused" you mean one which doesn't define 2 out of 3
flags of 
> REPORT GENERAL SMP response?
> 
> > past year testing with the Xyratex enclosures (5U84, 2U24, chained
with
> > *many* peered expanders with Table to Table routing) that should
> > hopefully expedite things and will be on hot standby to refactor as
> > requested (including tossing this baby and refactoring Luben's patch
> > should he be too busy, no hair off my back)
> 
> Now onto technical matter:
> 1) I'd call the flag "t2t_supp" to a) fit in with the rest of the
spirit of the
> code as other fields are also called "_supp", and to b) actually
convey
>  the meaning of "table-to-table supported. Your naming of this flag
> "table_to_table" implicitly means "table to table supported".
> 2) Please also add the debug output as my patch did. People will
> be wondering what went wrong if their domain didn't work, and the
> debug print in my original patch would tell them that.
> 3) You don't check that the parent also supports T2T. That's a bug.
> 4) Your patch logically does this: P=T && C!=S && (C is T2T || C!=T),
> which after expansion is equivalent to:
> (P==T) && ((C!=S && C!=T2T) || C==D) ==> fail
> where the outmost parens are an if (). Albeit from not being entirely
correct,
> it also obfuscates what is being sought after. I chose to use the
negation for
> successful check to make it more clear:
> (P==T) && (C==S || (C==T && P==T2T && C==T2T)) ==> success,
> Translates to
> "If parent phy is T, and If child phy is S OR (child is T and child
and parent
> both support table to table) then we're okay, else report an error."
> Which is: T<-S is okay, and T<-T is okay if both parent and child
support it.
> 
> Alternatively, Bottomley could just add my patch upstream.
> 
> > Please note, as I am *stuck* on Outlook as per company policy, the
> > following inline content will likely not patch clean even emailed as
> > 'Plain Text', the enclosed attached file should do the job. I have 
> > Cc'd
> > all the folks that originated the files in libsas, as there was no
> > listed MAINTAINERs.
> > 
> > NB: this patch (and Luben's independent patch) results in an ABI
break
> > as the structures change 'shape' and thus result in a different set
of
> > libsas export signatures. I have an internal patch I use that
preserves
> > the structure shapes and thus the ABI; but would be considered
> > inappropriate for the pristine trees. Said alternate patch would
work
> > fine for a Distribution tree where ABI concerns are an issue.
> > 
> > Checkpatch.pl reports clean.
> > 
> > Sincerely -- Mark Salyzyn
> > 
> > Cc: Luben Tuikov <tuikov@yahoo.com>
> > Cc: Darrick J Wong <djwong@us.ibm.com>
> > Cc: James Bottomley <jbottomley@parallels.com>
> > 
> > Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>
> > 
> > drivers/scsi/libsas/sas_expander.c |    6 +++++-
> > include/scsi/libsas.h              |    1 +
> > include/scsi/sas.h                 |    6 ++++--
> > 3 files changed, 10 insertions(+), 3 deletions(-)
> > 
> > diff -ru scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
> > scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
> > --- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c    2011-08-31
> > 08:32:21.000000000 -0400
> > +++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
> > 2011-08-31 09:07:31.000000000 -0400
> > @@ -331,6 +331,7 @@
> >     dev->ex_dev.num_phys = min(rg->num_phys, (u8)MAX_EXPANDER_PHYS);
> >     dev->ex_dev.conf_route_table = rg->conf_route_table;
> >     dev->ex_dev.configuring = rg->configuring;
> > +    dev->ex_dev.table_to_table = rg->table_to_table;
> >     memcpy(dev->ex_dev.enclosure_logical_id,
> > rg->enclosure_logical_id, 8);
> > }
> > 
> > @@ -1239,7 +1240,10 @@
> >                     res = -ENODEV;
> >                 }
> >             } else if (parent_phy->routing_attr ==
> > TABLE_ROUTING &&
> > -                   child_phy->routing_attr !=
> > SUBTRACTIVE_ROUTING) {
> > +                   child_phy->routing_attr !=
> > +                    SUBTRACTIVE_ROUTING &&
> > +                   (child_ex->table_to_table == 0 ||
> > +                    child_phy->routing_attr !=
> > TABLE_ROUTING)) {
> >                 sas_print_parent_topology_bug(child,
> > parent_phy, child_phy);
> >                 res = -ENODEV;
> >             }
> > diff -ru scsi-misc-2.6/include/scsi/libsas.h
> > scsi-misc-2.6.new/include/scsi/libsas.h
> > --- scsi-misc-2.6/include/scsi/libsas.h    2011-08-31
08:32:22.000000000
> > -0400
> > +++ scsi-misc-2.6.new/include/scsi/libsas.h    2011-08-31
> > 09:07:31.000000000 -0400
> > @@ -144,6 +144,7 @@
> >     u8     num_phys;
> >     u8     configuring:1;
> >     u8     conf_route_table:1;
> > +    u8     table_to_table:1;
> >     u8     enclosure_logical_id[8];
> > 
> >     struct ex_phy *ex_phy;
> > diff -ru scsi-misc-2.6/include/scsi/sas.h
> > scsi-misc-2.6.new/include/scsi/sas.h
> > --- scsi-misc-2.6/include/scsi/sas.h    2011-08-31
08:32:22.000000000
> > -0400
> > +++ scsi-misc-2.6.new/include/scsi/sas.h    2011-08-31
> > 09:07:31.000000000 -0400
> > @@ -341,7 +341,8 @@
> > 
> >     u8      conf_route_table:1;
> >     u8      configuring:1;
> > -    u8      _r_b:6;
> > +    u8      _r_b:5;
> > +    u8      table_to_table:1;
> > 
> >     u8      _r_c;
> > 
> > @@ -528,7 +529,8 @@
> >     u8      _r_a;
> >     u8      num_phys;
> > 
> > -    u8      _r_b:6;
> > +    u8      table_to_table:1;
> > +    u8      _r_b:5;
> >     u8      configuring:1;
> >     u8      conf_route_table:1;
> >
______________________________________________________________________
This email may contain privileged or confidential information, which should only be used for the purpose for which it was sent by Xyratex. No further rights or licenses are granted to use such information. If you are not the intended recipient of this message, please notify the sender by return and delete it. You may not use, copy, disclose or rely on the information contained in it.
 
Internet email is susceptible to data corruption, interception and unauthorised amendment for which Xyratex does not accept liability. While we have taken reasonable precautions to ensure that this email is free of viruses, Xyratex does not accept liability for the presence of any computer viruses in this email, nor for any losses caused as a result of viruses.
 
Xyratex Technology Limited (03134912), Registered in England & Wales, Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
 
The Xyratex group of companies also includes, Xyratex Ltd, registered in Bermuda, Xyratex International Inc, registered in California, Xyratex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd registered in The People's Republic of China and Xyratex Japan Limited registered in Japan.
______________________________________________________________________
 


