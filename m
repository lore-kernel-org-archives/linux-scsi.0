From: Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
 mptsas_qcmd
Date: Thu, 16 Sep 2010 15:26:01 -0700
Message-ID: <1284675961.7280.96.camel@schen9-DESK>
References: <1284666254.7280.54.camel@schen9-DESK>
	 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
	 <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
	 <4C929368.4040903@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab0IPWYv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 18:24:51 -0400
In-Reply-To: <4C929368.4040903@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Andi Kleen <ak@linux.intel.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On Thu, 2010-09-16 at 15:00 -0700, Joe Eykholt wrote:

> 
> It seems to me we can't completely move the host lock down into the
> drivers since its a shared lock between SCSI and the drivers now.
> 
> If we just have SCSI drop the lock and have the LLD reacquire it,
> that may open up a hole that some LLDs might not tolerate.
> It also hurts performance for the LLDs that want to keep
> the lock for the duration of queuecommand() by adding an extra
> unlock/lock.


It may be even better if we can completely drop the lock in
scsi_dispatch_cmd.  The other reason host_lock was taken there was to
serialize the increment and assignment of a scsi command serial number.
So maybe we can make the serial number counter an atomic.

We can just let the driver decide if they need a lock to serialize their
queue command.

Tim


