From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Why are DID_ABORT and TASK_ABORTED handled differently?
Date: Thu, 12 Jul 2012 18:49:55 +0200
Message-ID: <4FFF0033.2090902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934111Ab2GLQt5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jul 2012 12:49:57 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q6CGnvZh003317
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2012 12:49:57 -0400
Received: from yakj.usersys.redhat.com (ovpn-112-21.ams2.redhat.com [10.36.112.21])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q6CGnuKL021485
	for <linux-scsi@vger.kernel.org>; Thu, 12 Jul 2012 12:49:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Currently, DID_ABORT relays the failure to the upper layer, while TASK
ABORTED (after the suggestion at
http://marc.info/?l=linux-scsi&m=121932916906009&w=2 was implemented)
retries the command.

Is it correct that when TAS=0 an aborted task (from TMF, persistent
reservation or anything else) can result in DID_ABORT?  There are some
clues of this in the drivers, but on the other hand scsi-debug has a
very strange usage of DID_ABORT:

static const int illegal_condition_result =
        (DRIVER_SENSE << 24) | (DID_ABORT << 16) |
        SAM_STAT_CHECK_CONDITION;

...
        /* DIX + T10 DIF */
        if (scsi_debug_dix && scsi_prot_sg_count(SCpnt)) {
                int prot_ret = prot_verify_read(SCpnt, lba, num, ei_lba);

                if (prot_ret) {
                        mk_sense_buffer(devip, ABORTED_COMMAND, 0x10,
prot_ret);
                        return illegal_condition_result;
                }
        }


If it is the case that they are similar, is there any reason why the two
are handled differently?

Paolo
