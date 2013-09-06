From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH 17/18] lpfc 8.3.42: Fixed issue of task management commands
 having a fixed timeout
Date: Fri, 6 Sep 2013 13:38:29 -0500
Message-ID: <522A2125.9040406@tributary.com>
References: <1378484566.14051.36.camel@myfc17>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.51]:53125 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3IFSic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 14:38:32 -0400
In-Reply-To: <1378484566.14051.36.camel@myfc17>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "james.smart@emulex.com" <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 9/6/2013 11:22 AM, James Smart wrote:
> Fixed issue of task management commands having a fixed timeout

	I'm surprised about this change, since it appears a number of issues in the
send_taskmgmt() still exist that keep it from handling task management
failures correctly. It also continues to have a number of smaller issues like
for example dead code of the form

if (status != IOCB_STATUS)
else if (status == IOCB_BUSY)
else


	See patch:

"lpfc should check return status for task mgmt IOCB"

http://marc.info/?l=linux-scsi&m=136242124409687


