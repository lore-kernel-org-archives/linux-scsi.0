From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [Emulex] Ready for next round...
Date: Fri, 9 Jul 2004 15:24:14 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9630@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64672 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265773AbUGITY3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Jul 2004 15:24:29 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

Christoph,

Can you please take a look at the snapshot just posted on SourceForge.

The following things have been reworked:
- USE_HGP_HOST_SLIM: finally resolved this issue and implemented it
correctly.
- Logging: We killed lpfc_logmsg.c and converted over to a single define
using dev_printk. Still implements a subsystem filter in the macro.
- Attributes: They have been moved over to shost_attrs. We changed the basic
philosophy about per-instance attributes, as many simply aren't needed to be
set prior to attachment. This allowed them to go back integers. You will
find several removed as we removed some of the logic that insulated the
midlayer and above from transient conditions (delayed io error, etc - see
last paragraph). We killed lpfc.conf and have converted over to a separation
of attributes from their description arrays. One discrepancy - the static
configuration array for persistent bindings remains for compatibility - but
it's own file.
- Your big patch to lpfc_fcp.c - was incorporated.
- [PATCH] streamline lpfc error handling: This was incorporated. There were
some changes to clean up return codes and misplaced blocks.
- [PATCH] remove dead event counters from lpfc. Rather than remove this
code, as it will be used later, we have at least consolidated it and made
the events visible via sysfs.


Things we're still addressing - and should be in drop on 7/16:
- clk_data: We're removing the safety list, and converting from multiple
clock args to 1 so that it better maps to the kernel api.
- secondary data structures for target/lun data : We're attempting to
reduce/remove the notions of luns as, in general, the driver issues i/o at
the target level. Part of this is removing report luns use, etc. Note: We
will see if we can help the midlayer with addressing mode support.

We have one major issue, which has been partially discussed already
(http://marc.theaimsgroup.com/?l=linux-scsi&m=108275840501608&w=2). In
summary, there are discovery state machine events when we lose connectivity
with the target for a short period. If we do not suspend i/o to the target,
the upper layer retries can exhaust before the target comes back, triggering
other system error reports/problems/etc.  James Bottomly suggested adding a
scsi device SUSPEND function. We are actively addressing this and you should
see a conversation started shortly.


-- James S


