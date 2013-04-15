From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH v2 0/8] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 15 Apr 2013 11:20:43 -0500
Message-ID: <516C28DB.2090809@tributary.com>
References: <1359741195-2641-1-git-send-email-emilne@redhat.com>  <516730A1.4090302@tributary.com> <1366035182.30762.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.55]:49409 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753599Ab3DOQUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Apr 2013 12:20:47 -0400
In-Reply-To: <1366035182.30762.14.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>, Linux Scsi <linux-scsi@vger.kernel.org>

On 4/15/2013 9:13 AM, Ewan Milne wrote:

>> patch could attempt to clear the check conditions from LUNs that share
>> the I_T.
> 
> I think the mid-layer will handle that automatically.  If check conditions
> are reported the commands will have to be reissued.

	But, not automatically (unless i'm missing something again). The UA is going to
arrive when each lun gets sent a command, which could be a long time from the
initial UA if the lun is idle. Enough time, that the attempts to coalesce the
events are going to fail.

	I guess it depends on what you have udev doing when it gets the event. If it
triggers a rescan involving something besides inquiry/report luns then that will
trigger the remaining UA's from the luns on the target that changed. But if it
does something other than that, I don't see it by reading the
patch/scsi_scan.c code.







