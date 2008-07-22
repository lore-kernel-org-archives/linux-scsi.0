From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: nr_pages calculation in scsi_req_map_sg()
Date: Tue, 22 Jul 2008 16:28:53 +0300
Message-ID: <4885E095.3080903@panasas.com>
References: <4885F22C.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:30850 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbYGVN3T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 09:29:19 -0400
In-Reply-To: <4885F22C.76E4.0078.0@novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jan Beulich <jbeulich@novell.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Jan Beulich wrote:
> James,
> 
> while reviewing code derived from that function I found this calculation
> to be suspicious: I would think that it should get it wrong when both
> start and end of the buffer area are misaligned (e.g. consider the case
> where sgl->offset equals PAGE_SIZE-1 and bufflen equals 2 - the result
> would be 1 when it should have been 2).
> Is there something preventing this from happening?
> 
> Thanks, Jan
> 
> --

It has been discussed before for example look here:
http://www.spinics.net/lists/linux-scsi/msg13454.html

But for me the main reason it is not fixed is because
this is only called from scsi_execute_async() which
is a deprecated function. It is still used by old code
which is supposed to be removed soon. Any new code will
not be accepted if it uses scsi_execute_async().

Boaz
