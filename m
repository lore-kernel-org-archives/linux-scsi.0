From: "Qi, Yanling" <Yanling.Qi@lsi.com>
Subject: RE: [PATCH 0/2] : definion, code, and use of new SCSI ML hoststatus DID_COND_REQUEUE
Date: Fri, 2 Feb 2007 17:31:34 -0700
Message-ID: <0F08E10B769EAF4EA2C43A573B8CC87F8BD30D@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35666 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946167AbXBCAbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2007 19:31:36 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id l130TxG0017973
	for <linux-scsi@vger.kernel.org>; Fri, 2 Feb 2007 16:29:59 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id l130VaB7030685
	for <linux-scsi@vger.kernel.org>; Fri, 2 Feb 2007 16:31:36 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Goggin <egoggin@vmware.com>, James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Edward Goggin
> Sent: Friday, February 02, 2007 5:34 PM
> To: James Bottomley
> Cc: linux-scsi@vger.kernel.org; Moore, Eric
> I think I see your argument ... retries for BUSY and all other
scsi/host
> status's are limited by the code in scsi_softirq_done which filters
the
> disposition returned by scsi_decide_disposition, so no status will
yield
> an indefinite retry.
> 
> Not clear if that's soon enough for RDAC/MPP.  For the VMware case, it
> appears to allow an additional 30 seconds (beyond what DID_BUSY_BUSY
> would allow) for a retry.
 [Qi, Yanling] The following code in the scsi_lib.c will be enough for
RDAC/MPP. BTW, why do we do "wait_for = (cmd->allowed + 1) *
cmd->timeout_per_command". With a sd request, the wait_for will be 180
seconds. (SD_MAX_RETRIES=5 and SD_TIMEOUT=30 * HZ).

static void scsi_softirq_done(struct request *rq)
{
	struct scsi_cmnd *cmd = rq->completion_data;
	unsigned long wait_for = (cmd->allowed + 1) *
cmd->timeout_per_command;
	int disposition;

	INIT_LIST_HEAD(&cmd->eh_entry);

	disposition = scsi_decide_disposition(cmd);
	if (disposition != SUCCESS &&
	    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
		sdev_printk(KERN_ERR, cmd->device,
			    "timing out command, waited %lus\n",
			    wait_for/HZ);
		disposition = SUCCESS;
	}
Thanks,
Yanling
