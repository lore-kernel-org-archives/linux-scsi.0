From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Fri, 11 Feb 2011 15:13:40 -0600
Message-ID: <4D55A684.9060208@linux.vnet.ibm.com>
References: <1297340495-13347-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1297340495-13347-4-git-send-email-fujita.tomonori@lab.ntt.co.jp> <4D543951.2000207@linux.vnet.ibm.com> <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53840 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781Ab1BKVNm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Feb 2011 16:13:42 -0500
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p1BKwpI7028655
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2011 15:59:35 -0500
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 560E14DE803E
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2011 16:12:47 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p1BLDfRS344004
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2011 16:13:41 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p1BLDdnW015381
	for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2011 16:13:40 -0500
In-Reply-To: <1297366739.18212.182.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On 02/10/2011 01:38 PM, Nicholas A. Bellinger wrote:
> On Thu, 2011-02-10 at 13:15 -0600, Brian King wrote:
>> On 02/10/2011 06:21 AM, FUJITA Tomonori wrote:
> 
> Hi Brian,
> 
> <SNIP>
> 
>>> +
>>> +static int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd)
>>> +{
>>> +	struct ibmvscsis_cmnd *cmd =
>>> +		container_of(se_cmd, struct ibmvscsis_cmnd, se_cmd);
>>> +	struct scsi_cmnd *sc = &cmd->sc;
>>> +	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
>>> +	struct srp_cmd *scmd = iue->sbuf->buf;
>>> +	int ret;
>>> +
>>> +	/*
>>> +	 * Allocate the necessary tasks to complete the received CDB+data
>>> +	 */
>>> +	ret = transport_generic_allocate_tasks(se_cmd, scmd->cdb);
>>> +	if (ret == -1) {
>>> +		/* Out of Resources */
>>> +		return PYX_TRANSPORT_LU_COMM_FAILURE;
>>> +	} else if (ret == -2) {
>>> +		/*
>>> +		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
>>> +		 */
>>> +		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
>>> +			return PYX_TRANSPORT_RESERVATION_CONFLICT;
>>
>> Does this imply the driver supports scsi reservations? If it supports SCSI-2 reservations,
>> there is a capability that could be set in the capabilities MAD to advertise this
>> fact such that it can be used by the client.
>>
> 
> Absoulutely, the target core struct se_device backends being serviced as
> VSCSI LUN would normally return SCSI-3 from INQUIRY data, and support
> the full set of persistent reservations and CRH=1 (Compatible
> Reservations Handling) in drivers/target/target_core_pr.c code.
> 
> Also, we are able to explictly limit individual struct se_device
> backends to disable PR and only use the older SCSI-2 reservations, but I
> don't think we have a way to do this on a fabric module wide basis just
> yet.
> 
> Is this something we should be doing for this code..?

Disregard my previous comment. It looks like current client should handle reservations
just fine without any further changes.

Thanks,

Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


