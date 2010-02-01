From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 10/11] qla4xxx: added support for abort task management
 command
Date: Mon, 01 Feb 2010 13:19:08 -0600
Message-ID: <4B67292C.9020101@cs.wisc.edu>
References: <20100130062934.GK10274@linux-qf4p> <4B67232F.2020304@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36494 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755787Ab0BATT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 14:19:26 -0500
In-Reply-To: <4B67232F.2020304@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Karen Higgins <karen.higgins@qlogic.com>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 02/01/2010 12:53 PM, Mike Christie wrote:
> If you do not need to send a abort for firmware cleanup, and if doing
> erl0, then it is fastest to just escalate to the target reset callout
> for this case. We can wait just once there instead of waiting 10 secs *
> num_commands.

Oh yeah, you want to wait in the target reset handler for the session to 
come back or for qla4xxx_recovery_timedout to be called.
