From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/1] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Mon, 15 Apr 2013 16:55:49 -0500
Message-ID: <516C7765.8020801@linux.vnet.ibm.com>
References: <20130415183949.678757952@linux.vnet.ibm.com> <1366058730.7609.8.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:57785 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3DOV4C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Apr 2013 17:56:02 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 15 Apr 2013 15:56:01 -0600
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 644BB3E40042
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2013 15:55:45 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3FLtpb0117288
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2013 15:55:54 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3FLwdx3028287
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2013 15:58:39 -0600
In-Reply-To: <1366058730.7609.8.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: wenxiong@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On 04/15/2013 03:45 PM, James Bottomley wrote:
> On Mon, 2013-04-15 at 13:39 -0500, wenxiong@linux.vnet.ibm.com wrote:
>> In scsi_send_eh_cmnd(), this fix will check the return code of queuecomamnd
>> when sending commands and retry for a bit if the driver returns a
>> busy response.
> 
> This is already handled by the timeout, I think.  If a driver
> continuously returns MLQUEUE BUSY, then we'll fail the request after the
> timeout on the command expires.

If we get a timeout in scsi_send_eh_cmnd we call scsi_abort_eh_cmnd. If the
abort works, we return FAILED out of scsi_send_eh_cmnd, which results in
no retry being performed, since scsi_eh_tur only retries once and
only if NEEDS_RETRY is returned. Or am I missing something?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


