From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/1] scsi: Handle MLQUEUE busy response in
 scsi_send_eh_cmnd
Date: Mon, 15 Apr 2013 20:09:17 -0400
Message-ID: <20130415200917.Horde.bB0zPpir309RbJatNux2L-A@imap.linux.ibm.com>
References: <20130415183949.678757952@linux.vnet.ibm.com>
 <1366058730.7609.8.camel@dabdike> <516C7765.8020801@linux.vnet.ibm.com>
 <1366065203.7609.18.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57995 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934768Ab3DPAJV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Apr 2013 20:09:21 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Mon, 15 Apr 2013 20:09:20 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 9D6F76E8047
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2013 20:09:15 -0400 (EDT)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3G09IVS258526
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2013 20:09:18 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3G09Hxv030534
	for <linux-scsi@vger.kernel.org>; Mon, 15 Apr 2013 21:09:17 -0300
In-Reply-To: <1366065203.7609.18.camel@dabdike>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org


Quoting James Bottomley <James.Bottomley@hansenpartnership.com>:

> On Mon, 2013-04-15 at 16:55 -0500, Brian King wrote:
>> On 04/15/2013 03:45 PM, James Bottomley wrote:
>> > On Mon, 2013-04-15 at 13:39 -0500, wenxiong@linux.vnet.ibm.com wrote:
>> >> In scsi_send_eh_cmnd(), this fix will check the return code of  
>> queuecomamnd
>> >> when sending commands and retry for a bit if the driver returns a
>> >> busy response.
>> >
>> > This is already handled by the timeout, I think.  If a driver
>> > continuously returns MLQUEUE BUSY, then we'll fail the request after the
>> > timeout on the command expires.
>>
>> If we get a timeout in scsi_send_eh_cmnd we call scsi_abort_eh_cmnd. If the
>> abort works, we return FAILED out of scsi_send_eh_cmnd, which results in
>> no retry being performed, since scsi_eh_tur only retries once and
>> only if NEEDS_RETRY is returned. Or am I missing something?
>
> Sorry, I'm not being clear.  It comes with being at a conference.  What
> I mean is that if you do this, the criterion for success or faiure
> should be the amount of time left not the number of retries.  This is
> what the non-eh submission path also does for retries of events that
> don't count against the retry limit ... so something like this patch
> (uncompiled and untested #include stddisclaimer.h)
>
> James

Hi James,

The failing case for us is: Doesn't matter what timeout value we set in
wait_for_completion_timeout(), it always returns with timeleft = 0.
For example, if I set timeout = 50 secs, wait_for_completion_timeout()
always returns with timeleft =0(even adapter is already in good shape in
20 secs).  We never gets a chance to call into if (timeleft) leg.

My understanding is: if shost->host->queuecommand() failed with MLQUEUE busy
response at the first time, wait_for_completion_timeout() always wakes  
up by expired.

Here is log when I enabled scsi log:

Apr 15 18:44:35 ltcsatiocp5 kernel: scsi_send_eh_cmnd: scmd:  
c0000000f88bc980, timeleft: 0

I applied your patch. Because timeleft is always zero, never got a  
chance to call into
if(timeleft) { leg.

Thanks,
Wendy

