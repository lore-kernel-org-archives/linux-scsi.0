From: "Sachin Mhatre \(smhatre\)" <smhatre@cisco.com>
Subject: RE: [PATCH] Midlayer initiated START_UNIT
Date: Tue, 17 Feb 2004 13:06:00 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <00e301c3f528$b0ba4440$7d074d0a@apac.cisco.com>
References: <401985E6.8060603@us.ibm.com>
Reply-To: <smhatre@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:135 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S261807AbUBQHgG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 02:36:06 -0500
Received: from cisco.com (samrat.cisco.com [192.135.241.21])
	by india-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id i1H7ZsWT015662
	for <linux-scsi@vger.kernel.org>; Mon, 16 Feb 2004 23:35:54 -0800 (PST)
Received: from smhatrew2k (dhcp-10-77-7-125.cisco.com [10.77.7.125])
	by cisco.com (8.11.2/8.8.8) with ESMTP id i1H7ZPq15279
	for <linux-scsi@vger.kernel.org>; Tue, 17 Feb 2004 13:05:25 +0530 (IST)
In-Reply-To: <401985E6.8060603@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Has this patch been included in the linux 2.6.X kernel? This patch would
also help the iscsi LLDD as it is also facing the same START_UNIT
problem.
I would really appreciate any help on this matter.

Thanks,
Sachin


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Brian King
Sent: Friday, January 30, 2004 3:45 AM
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] Midlayer initiated START_UNIT


James,

This is a patch to issue a START_UNIT command from the midlayer error
handler. The ipr driver, which is currently out for review needs this to
function properly. Any time the adapter gets reset, the disk array
resources under the ipr adapter require another START_UNIT command. This
causes problems with the current error handling and these devices get
taken offline when this occurs.

This was being handled by the ipr driver itself, but Christoph did not
like seeing a LLDD issuing commands to devices, hence the patch.

http://marc.theaimsgroup.com/?l=linux-scsi&m=107462193622673&w=2

Patch is against 2.6.2-rc2.

Thanks



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

