From: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: nr_pages calculation in scsi_req_map_sg()
Date: Tue, 22 Jul 2008 15:36:32 +0100
Message-ID: <48860C90.76E4.0078.0@novell.com>
References: <4885F22C.76E4.0078.0@novell.com>
 <4885E095.3080903@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.id2.novell.com ([195.33.99.129]:30201 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbYGVOgF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2008 10:36:05 -0400
In-Reply-To: <4885E095.3080903@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

>>> Boaz Harrosh <bharrosh@panasas.com> 22.07.08 15:28 >>>
>Jan Beulich wrote:
>> James,
>> 
>> while reviewing code derived from that function I found this calculation
>> to be suspicious: I would think that it should get it wrong when both
>> start and end of the buffer area are misaligned (e.g. consider the case
>> where sgl->offset equals PAGE_SIZE-1 and bufflen equals 2 - the result
>> would be 1 when it should have been 2).
>> Is there something preventing this from happening?
>> 
>> Thanks, Jan
>> 
>> --
>
>It has been discussed before for example look here:
>http://www.spinics.net/lists/linux-scsi/msg13454.html 
>
>But for me the main reason it is not fixed is because
>this is only called from scsi_execute_async() which
>is a deprecated function. It is still used by old code
>which is supposed to be removed soon. Any new code will
>not be accepted if it uses scsi_execute_async().

No, that's a different issue: Even if the sg elements are all contiguous,
the count can be wrong, as described in the original mail. And as said,
I found this in code cloned from scsi_req_map_sg(), hence would be
interested in confirmation of that fact (or explanation why it's not an
issue) regardless of the function itself sitting in a to-be-removed code
path only.

Thanks, Jan

