From: Chip Coldwell <coldwell@redhat.com>
Subject: on the polarity of scsi_eh_tur
Date: Fri, 26 Jan 2007 11:26:19 -0500
Message-ID: <m37iv969g4.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:36652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965704AbXAZQZr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jan 2007 11:25:47 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l0QGPkc0021928
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 11:25:46 -0500
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l0QGPfH6005851
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 11:25:41 -0500
Received: from localhost.localdomain (vpn-248-89.boston.redhat.com [10.13.248.89])
	by mail.boston.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id l0QGPeVi013430
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jan 2007 11:25:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I have a question about scsi_eh_tur.  The comment says:

/**
 * scsi_eh_tur - Send TUR to device.
 * @scmd:	Scsi cmd to send TUR
 *
 * Return value:
 *    0 - Device is ready. 1 - Device NOT ready.
 **/
static int scsi_eh_tur(struct scsi_cmnd *scmd)

However, this function is used throughout the error handling code in
an idiom that seems to imply the opposite polarity:

!scsi_device_online(sdev) || !scsi_eh_tur(bdr_scmd)

For example (scsi_eh_bus_device_reset):

                rtn = scsi_try_bus_device_reset(bdr_scmd);
                if (rtn == SUCCESS) {
                        if (!scsi_device_online(sdev) ||
                            !scsi_eh_tur(bdr_scmd)) {
                                list_for_each_entry_safe(scmd, next,
                                                         work_q, eh_entry) {
                                        if (scmd->device == sdev)
                                                scsi_eh_finish_cmd(scmd,
                                                                   done_q);
                                }
                        }
                } else {
                        SCSI_LOG_ERROR_RECOVERY(3, printk("%s: BDR"
                                                          " failed sdev:"
                                                          "0x%p\n",
                                                          current->comm,
                                                           sdev));
                }

It looks like the intent of the first branch above is to do a BDR, and
if that succeeds but the device remains offline or does not respond to
a test-unit-ready then to finish all the commands for that device
instead of retrying them.

Even within scsi_eh_tur, things get confused.  This is near the end:

	if (rtn == SUCCESS)
		return 0;
	else if (rtn == NEEDS_RETRY) {
		if (retry_cnt--)
			goto retry_tur;
		return 0;
	}
	return 1;

So if (rtn == SUCCESS) or (rtn == NEEDS_RETRY && retry_cnt == 0) then
we consider the device to be ready?  I would think running out of
retries without SUCCESS would mean the device isn't ready, i.e. the
function should return 1.

Do I misunderstand?

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc.
1-978-392-2426
