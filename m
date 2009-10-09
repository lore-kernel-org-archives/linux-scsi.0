From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL] SCSI fixes for 2.6.32-rc3
Date: Fri, 9 Oct 2009 11:15:38 +0200
Message-ID: <20091009091538.GA4154@elte.hu>
References: <alpine.LFD.2.01.0910060851590.3432@localhost.localdomain> <1254862442.4383.183.camel@mulgrave.site> <1255012399.4187.24.camel@mulgrave.site> <alpine.LFD.2.01.0910080736490.3432@localhost.localdomain> <alpine.LFD.2.01.0910080742230.3432@localhost.localdomain> <1255031298.4187.260.camel@mulgrave.site> <alpine.LFD.2.01.0910081252090.3432@localhost.localdomain> <alpine.LFD.2.01.0910081255510.3432@localhost.localdomain> <20091008210737.GD29181@mit.edu> <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:42885 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997AbZJIJQ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Oct 2009 05:16:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910081410400.3432@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Greg Kroah-Hartman <gregkh@suse.de>
Cc: Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Jing Huang <huangj@brocade.com>


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 8 Oct 2009, Theodore Tso wrote:
> > 
> > So would it be acceptable to merge the 50 kloc of crap _during_ the
> > merge window?
> 
> Yes. I actually looked at the driver (since I had pulled it - I've 
> unpulled it but am still mulling it over), and while I think it looked 
> huge and overly complex, it by no means gave me the kinds of vibes I 
> get from some "obviously-ported-from-windows-with-no-clue" drivers.
> 
> So at least from my quick look I didn't get the feeling that the 
> driver was "evil". For me, it's a timing issue.  I hate getting big 
> pull requests after -rc1 is out, and I really don't like the feeling 
> that people are just ignoring the merge window.
> 
> That said, if somebody wants to look more closely at the driver, and 
> then wants to convince people that it should have gone through 
> "staging", feel free. But that's not what I've personally been arguing 
> about.

Greg, what's your take on the quality of this new driver? Do you have 
some time to do a review of this with drivers/staging/ versus drivers/ 
glasses on? The Git URI is at:

  master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6 master

To me, after a very quick skimming of it it's borderline. The driver 
looks like proper Linux code at first sight in places, but i can see 
_lots_ of (as in thousands of) odd bits - at least odd for a newly 
submitted driver:

 - 200+ instances of bfa_boolean_t, which is defined via:

  enum bfa_boolean {
          BFA_FALSE = 0,
          BFA_TRUE  = 1
  };
  #define bfa_boolean_t enum bfa_boolean

  that should be bool simply.

 - the driver is full with misaligned vertical spacing like:

struct bfa_pcidev_s {
	int             pci_slot;
	u8         pci_func;
	u16	device_id;
	bfa_os_addr_t   pci_bar_kva;
};

void
bfa_timer_beat(struct bfa_timer_mod_s *mod)
{
	struct list_head        *qh = &mod->timer_q;
	struct list_head        *qe, *qe_next;
	struct bfa_timer_s *elem;
	struct list_head         timedout_q;

   which suggests that this driver was treated with a
   de-ugly-ifying sed job without a human looking at the result. There's
   over a thousand (!) of such instances in the driver.

 - various forms of avoidable whitespace damage: for example 873 
   instances of 'space' character followed by 'tab'.

 - bfa_timer.c looks weird - implements a naive timeout mechanism on top
   of real timers? Why not use real timers in to begin with?

 - Also, the .h files are layed out oddly. Bits of them are in 
   include/*, bits of them in *.h.

 - the 90+ easily avoidable stylistic details attached below in
   drivers/scsi/bfa/fcbuild.c.

 - accesses to cmnd->host_scribble both seem an ancient method, and 
   are also somewhat SMP-barrier-unclean. (i'm sure it works and is 
   correct in practice as there are heavy, serializing functions around 
   those places, but the casts still look ugly and there are no 
   barriers.)

 - The 290+ instances of bfa_assert() uses should probably be BUG_ON()s 
   or WARN_ON()s instead of a wrapped panic. Nothing ever defines 
   BFA_PERF_BUILD so the wrapping seems removable.

havent looked further and these are all easily addressed by just looking 
at the code and doing fixes that dont impact the resulting .o - so very 
easy to do en masse.

I dont know what's the current mainline inclusion quality threshold for 
non-staging Linux drivers - it might be ok. Also, the driver commit has 
been rebased a few days ago which makes it hard to see its stability 
track record.

	Ingo

--------------->
ERROR: return is not a function, parentheses are not required
#191: FILE: fcbuild.c:191:
+			return (FC_PARSE_BUSY);

ERROR: return is not a function, parentheses are not required
#193: FILE: fcbuild.c:193:
+			return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#196: FILE: fcbuild.c:196:
+		return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#198: FILE: fcbuild.c:198:
+	return (FC_PARSE_OK);

CHECK: multiple assignments should be avoided
#226: FILE: fcbuild.c:226:
+	plogi->csp.rxsz = plogi->class3.rxsz = bfa_os_htons(pdu_size);

ERROR: return is not a function, parentheses are not required
#231: FILE: fcbuild.c:231:
+	return (sizeof(struct fc_logi_s));

CHECK: multiple assignments should be avoided
#248: FILE: fcbuild.c:248:
+	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);

ERROR: return is not a function, parentheses are not required
#270: FILE: fcbuild.c:270:
+	return (sizeof(struct fc_logi_s));

CHECK: multiple assignments should be avoided
#284: FILE: fcbuild.c:284:
+	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);

ERROR: return is not a function, parentheses are not required
#290: FILE: fcbuild.c:290:
+	return (sizeof(struct fc_logi_s));

CHECK: multiple assignments should be avoided
#305: FILE: fcbuild.c:305:
+	flogi->csp.rxsz = flogi->class3.rxsz = bfa_os_htons(pdu_size);

ERROR: return is not a function, parentheses are not required
#309: FILE: fcbuild.c:309:
+	return (sizeof(struct fc_logi_s));

ERROR: return is not a function, parentheses are not required
#341: FILE: fcbuild.c:341:
+			return (FC_PARSE_BUSY);

ERROR: return is not a function, parentheses are not required
#343: FILE: fcbuild.c:343:
+			return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#347: FILE: fcbuild.c:347:
+			return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#350: FILE: fcbuild.c:350:
+			return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#353: FILE: fcbuild.c:353:
+			return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#356: FILE: fcbuild.c:356:
+			return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#358: FILE: fcbuild.c:358:
+		return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#360: FILE: fcbuild.c:360:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#375: FILE: fcbuild.c:375:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#396: FILE: fcbuild.c:396:
+	return (sizeof(struct fc_prli_s));

ERROR: return is not a function, parentheses are not required
#417: FILE: fcbuild.c:417:
+	return (sizeof(struct fc_prli_s));

ERROR: return is not a function, parentheses are not required
#424: FILE: fcbuild.c:424:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#427: FILE: fcbuild.c:427:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#431: FILE: fcbuild.c:431:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#434: FILE: fcbuild.c:434:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#436: FILE: fcbuild.c:436:
+	return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#443: FILE: fcbuild.c:443:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#446: FILE: fcbuild.c:446:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#449: FILE: fcbuild.c:449:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#451: FILE: fcbuild.c:451:
+	return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#465: FILE: fcbuild.c:465:
+	return (sizeof(struct fc_logo_s));

ERROR: return is not a function, parentheses are not required
#487: FILE: fcbuild.c:487:
+	return (sizeof(struct fc_adisc_s));

ERROR: return is not a function, parentheses are not required
#514: FILE: fcbuild.c:514:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#517: FILE: fcbuild.c:517:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#520: FILE: fcbuild.c:520:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#522: FILE: fcbuild.c:522:
+	return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#532: FILE: fcbuild.c:532:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#537: FILE: fcbuild.c:537:
+		return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#539: FILE: fcbuild.c:539:
+	return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#553: FILE: fcbuild.c:553:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#556: FILE: fcbuild.c:556:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#559: FILE: fcbuild.c:559:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#573: FILE: fcbuild.c:573:
+	return (sizeof(struct fchs_s));

ERROR: return is not a function, parentheses are not required
#581: FILE: fcbuild.c:581:
+		return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#583: FILE: fcbuild.c:583:
+	return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#600: FILE: fcbuild.c:600:
+	return (sizeof(struct fc_rrq_s));

ERROR: return is not a function, parentheses are not required
#614: FILE: fcbuild.c:614:
+	return (sizeof(struct fc_els_cmd_s));

ERROR: return is not a function, parentheses are not required
#630: FILE: fcbuild.c:630:
+	return (sizeof(struct fc_ls_rjt_s));

ERROR: return is not a function, parentheses are not required
#646: FILE: fcbuild.c:646:
+	return (sizeof(struct fc_ba_acc_s));

ERROR: return is not a function, parentheses are not required
#657: FILE: fcbuild.c:657:
+	return (sizeof(struct fc_els_cmd_s));

ERROR: return is not a function, parentheses are not required
#699: FILE: fcbuild.c:699:
+	return (bfa_os_ntohs(tprlo_acc->payload_len));

ERROR: return is not a function, parentheses are not required
#724: FILE: fcbuild.c:724:
+	return (bfa_os_ntohs(prlo_acc->payload_len));

ERROR: return is not a function, parentheses are not required
#738: FILE: fcbuild.c:738:
+	return (sizeof(struct fc_rnid_cmd_s));

ERROR: return is not a function, parentheses are not required
#762: FILE: fcbuild.c:762:
+		return (sizeof(struct fc_rnid_acc_s));

ERROR: return is not a function, parentheses are not required
#764: FILE: fcbuild.c:764:
+		return (sizeof(struct fc_rnid_acc_s) -

ERROR: return is not a function, parentheses are not required
#779: FILE: fcbuild.c:779:
+	return (sizeof(struct fc_rpsc_cmd_s));

ERROR: return is not a function, parentheses are not required
#800: FILE: fcbuild.c:800:
+	return (sizeof(struct fc_rpsc2_cmd_s) + ((npids - 1) *

ERROR: return is not a function, parentheses are not required
#822: FILE: fcbuild.c:822:
+	return (sizeof(struct fc_rpsc_acc_s));

CHECK: multiple assignments should be avoided
#855: FILE: fcbuild.c:855:
+	pdisc->csp.rxsz = pdisc->class3.rxsz = bfa_os_htons(pdu_size);

ERROR: return is not a function, parentheses are not required
#859: FILE: fcbuild.c:859:
+	return (sizeof(struct fc_logi_s));

ERROR: return is not a function, parentheses are not required
#868: FILE: fcbuild.c:868:
+		return (FC_PARSE_LEN_INVAL);

ERROR: return is not a function, parentheses are not required
#871: FILE: fcbuild.c:871:
+		return (FC_PARSE_ACC_INVAL);

ERROR: return is not a function, parentheses are not required
#874: FILE: fcbuild.c:874:
+		return (FC_PARSE_PWWN_NOT_EQUAL);

ERROR: return is not a function, parentheses are not required
#877: FILE: fcbuild.c:877:
+		return (FC_PARSE_NWWN_NOT_EQUAL);

ERROR: return is not a function, parentheses are not required
#880: FILE: fcbuild.c:880:
+		return (FC_PARSE_RXSZ_INVAL);

ERROR: return is not a function, parentheses are not required
#882: FILE: fcbuild.c:882:
+	return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#906: FILE: fcbuild.c:906:
+	return (bfa_os_ntohs(prlo->payload_len));

ERROR: return is not a function, parentheses are not required
#919: FILE: fcbuild.c:919:
+		return (FC_PARSE_FAILURE);

ERROR: return is not a function, parentheses are not required
#939: FILE: fcbuild.c:939:
+	return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#971: FILE: fcbuild.c:971:
+	return (bfa_os_ntohs(tprlo->payload_len));

ERROR: return is not a function, parentheses are not required
#984: FILE: fcbuild.c:984:
+		return (FC_PARSE_ACC_INVAL);

ERROR: return is not a function, parentheses are not required
#990: FILE: fcbuild.c:990:
+			return (FC_PARSE_NOT_FCP);

ERROR: return is not a function, parentheses are not required
#992: FILE: fcbuild.c:992:
+			return (FC_PARSE_OPAFLAG_INVAL);

ERROR: return is not a function, parentheses are not required
#994: FILE: fcbuild.c:994:
+			return (FC_PARSE_RPAFLAG_INVAL);

ERROR: return is not a function, parentheses are not required
#996: FILE: fcbuild.c:996:
+			return (FC_PARSE_OPA_INVAL);

ERROR: return is not a function, parentheses are not required
#998: FILE: fcbuild.c:998:
+			return (FC_PARSE_RPA_INVAL);

ERROR: return is not a function, parentheses are not required
#1000: FILE: fcbuild.c:1000:
+	return (FC_PARSE_OK);

ERROR: return is not a function, parentheses are not required
#1027: FILE: fcbuild.c:1027:
+	return (sizeof(struct fc_ba_rjt_s));

ERROR: return is not a function, parentheses are not required
#1076: FILE: fcbuild.c:1076:
+	return (sizeof(struct fcgs_gidpn_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1093: FILE: fcbuild.c:1093:
+	return (sizeof(fcgs_gpnid_req_t) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1110: FILE: fcbuild.c:1110:
+	return (sizeof(fcgs_gnnid_req_t) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1140: FILE: fcbuild.c:1140:
+	return (sizeof(struct fc_scr_s));

ERROR: return is not a function, parentheses are not required
#1160: FILE: fcbuild.c:1160:
+	return (sizeof(struct fc_rscn_pl_s));

ERROR: return is not a function, parentheses are not required
#1191: FILE: fcbuild.c:1191:
+	return (sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1213: FILE: fcbuild.c:1213:
+	return (sizeof(struct fcgs_rftid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1234: FILE: fcbuild.c:1234:
+	return (sizeof(struct fcgs_rffid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1256: FILE: fcbuild.c:1256:
+	return (sizeof(struct fcgs_rspnid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1278: FILE: fcbuild.c:1278:
+	return (sizeof(struct fcgs_gidft_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1297: FILE: fcbuild.c:1297:
+	return (sizeof(struct fcgs_rpnid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1316: FILE: fcbuild.c:1316:
+	return (sizeof(struct fcgs_rnnid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1335: FILE: fcbuild.c:1335:
+	return (sizeof(struct fcgs_rcsid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1354: FILE: fcbuild.c:1354:
+	return (sizeof(struct fcgs_rptid_req_s) + sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1371: FILE: fcbuild.c:1371:
+	return (sizeof(struct ct_hdr_s) + sizeof(struct fcgs_ganxt_req_s));

ERROR: return is not a function, parentheses are not required
#1388: FILE: fcbuild.c:1388:
+	return (sizeof(struct ct_hdr_s));

ERROR: return is not a function, parentheses are not required
#1428: FILE: fcbuild.c:1428:
+	return (sizeof(struct ct_hdr_s) + sizeof(fcgs_gmal_req_t));

ERROR: return is not a function, parentheses are not required
#1448: FILE: fcbuild.c:1448:
+	return (sizeof(struct ct_hdr_s) + sizeof(fcgs_gfn_req_t));

total: 93 errors, 0 warnings, 5 checks, 1449 lines checked

fcbuild.c has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.
