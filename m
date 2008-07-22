From: "Jan Beulich" <jbeulich@novell.com>
Subject: nr_pages calculation in scsi_req_map_sg()
Date: Tue, 22 Jul 2008 13:43:56 +0100
Message-ID: <4885F22C.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.id2.novell.com ([195.33.99.129]:25938 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbYGVNDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 09:03:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

James,

while reviewing code derived from that function I found this calculation
to be suspicious: I would think that it should get it wrong when both
start and end of the buffer area are misaligned (e.g. consider the case
where sgl->offset equals PAGE_SIZE-1 and bufflen equals 2 - the result
would be 1 when it should have been 2).
Is there something preventing this from happening?

Thanks, Jan

