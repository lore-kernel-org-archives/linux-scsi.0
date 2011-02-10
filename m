From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Thu, 10 Feb 2011 11:38:59 -0800
Message-ID: <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <4D543951.2000207@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60253 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1BJTjF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Feb 2011 14:39:05 -0500
In-Reply-To: <4D543951.2000207@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Thu, 2011-02-10 at 13:15 -0600, Brian King wrote:
> On 02/10/2011 06:21 AM, FUJITA Tomonori wrote:

Hi Brian,

<SNIP>

> > +
> > +static int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd)
> > +{
> > +	struct ibmvscsis_cmnd *cmd =
> > +		container_of(se_cmd, struct ibmvscsis_cmnd, se_cmd);
> > +	struct scsi_cmnd *sc = &cmd->sc;
> > +	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
> > +	struct srp_cmd *scmd = iue->sbuf->buf;
> > +	int ret;
> > +
> > +	/*
> > +	 * Allocate the necessary tasks to complete the received CDB+data
> > +	 */
> > +	ret = transport_generic_allocate_tasks(se_cmd, scmd->cdb);
> > +	if (ret == -1) {
> > +		/* Out of Resources */
> > +		return PYX_TRANSPORT_LU_COMM_FAILURE;
> > +	} else if (ret == -2) {
> > +		/*
> > +		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
> > +		 */
> > +		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
> > +			return PYX_TRANSPORT_RESERVATION_CONFLICT;
> 
> Does this imply the driver supports scsi reservations? If it supports SCSI-2 reservations,
> there is a capability that could be set in the capabilities MAD to advertise this
> fact such that it can be used by the client.
> 

Absoulutely, the target core struct se_device backends being serviced as
VSCSI LUN would normally return SCSI-3 from INQUIRY data, and support
the full set of persistent reservations and CRH=1 (Compatible
Reservations Handling) in drivers/target/target_core_pr.c code.

Also, we are able to explictly limit individual struct se_device
backends to disable PR and only use the older SCSI-2 reservations, but I
don't think we have a way to do this on a fabric module wide basis just
yet.

Is this something we should be doing for this code..?

--nab


