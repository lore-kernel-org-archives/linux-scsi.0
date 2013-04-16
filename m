From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/1] scsi: Handle MLQUEUE busy response in scsi_send_eh_cmnd
Date: Tue, 16 Apr 2013 10:12:58 -0500
Message-ID: <516D6A7A.6030007@linux.vnet.ibm.com>
References: <20130415183949.678757952@linux.vnet.ibm.com> <1366058730.7609.8.camel@dabdike> <516C7765.8020801@linux.vnet.ibm.com> <1366065203.7609.18.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49585 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab3DPPNI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Apr 2013 11:13:08 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 16 Apr 2013 11:13:08 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 8743238C804F
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 11:13:04 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3GFD4Ch261120
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 11:13:04 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3GFD3uI031060
	for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 11:13:04 -0400
In-Reply-To: <1366065203.7609.18.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: wenxiong@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

On 04/15/2013 05:33 PM, James Bottomley wrote:
> On Mon, 2013-04-15 at 16:55 -0500, Brian King wrote:
>> On 04/15/2013 03:45 PM, James Bottomley wrote:
>>> On Mon, 2013-04-15 at 13:39 -0500, wenxiong@linux.vnet.ibm.com wrote:
>>>> In scsi_send_eh_cmnd(), this fix will check the return code of queuecomamnd
>>>> when sending commands and retry for a bit if the driver returns a
>>>> busy response.
>>>
>>> This is already handled by the timeout, I think.  If a driver
>>> continuously returns MLQUEUE BUSY, then we'll fail the request after the
>>> timeout on the command expires.
>>
>> If we get a timeout in scsi_send_eh_cmnd we call scsi_abort_eh_cmnd. If the
>> abort works, we return FAILED out of scsi_send_eh_cmnd, which results in
>> no retry being performed, since scsi_eh_tur only retries once and
>> only if NEEDS_RETRY is returned. Or am I missing something?
> 
> Sorry, I'm not being clear.  It comes with being at a conference.  What
> I mean is that if you do this, the criterion for success or failure
> should be the amount of time left not the number of retries.  This is
> what the non-eh submission path also does for retries of events that
> don't count against the retry limit ... so something like this patch
> (uncompiled and untested #include stddisclaimer.h)

Jams,

Wendy and I discussed this a bit more and I think we understand your concern.
Wendy is working on an updated patch.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


