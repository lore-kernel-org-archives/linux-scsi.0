From: Brian King <brking@us.ibm.com>
Subject: [PATCH] Midlayer initiated START_UNIT
Date: Thu, 29 Jan 2004 16:15:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <401985E6.8060603@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:62678 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266455AbUA2WPG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 17:15:06 -0500
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

James,

This is a patch to issue a START_UNIT command from the midlayer error handler.
The ipr driver, which is currently out for review needs this to function properly.
Any time the adapter gets reset, the disk array resources under the ipr adapter
require another START_UNIT command. This causes problems with the current error
handling and these devices get taken offline when this occurs.

This was being handled by the ipr driver itself, but Christoph did not like
seeing a LLDD issuing commands to devices, hence the patch.

http://marc.theaimsgroup.com/?l=linux-scsi&m=107462193622673&w=2

Patch is against 2.6.2-rc2.

Thanks



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

