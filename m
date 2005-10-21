From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Improve code for detecting errors near the end of a CD
Date: Fri, 21 Oct 2005 13:05:22 +1000
Message-ID: <43585AF2.1080103@torque.net>
References: <Pine.LNX.4.44L0.0510201159470.5676-100000@iolanthe.rowland.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:18572 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S964850AbVJUDEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 23:04:35 -0400
In-Reply-To: <Pine.LNX.4.44L0.0510201159470.5676-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Thu, 20 Oct 2005, Douglas Gilbert wrote:
> 
> 
>>Alan,
>>Ouch.
>>Here is the linux kernel version (scsi_error.c):
>>
>>    case 0x70:
>>    case 0x71:
>>        if (sense_buffer[0] & 0x80) {
>>            *info_out = (sense_buffer[3] << 24) +
>>                        (sense_buffer[4] << 16) +
>>                        (sense_buffer[5] << 8) +
>>                        sense_buffer[6];
>>            return 1;
>>        } else
>>            return 0;
>>
>>and here is the sg3_utils version (sg_lib.c):
>>
>>    case 0x70:
>>    case 0x71:
>>        if (info_outp)
>>            *info_outp = (sensep[3] << 24) + (sensep[4] << 16) +
>>                         (sensep[5] << 8) + sensep[6];
>>        return (sensep[0] & 0x80) ? 1 : 0;
>>
>>The latter implementation takes account of MMC devices.
>>So I probably need to send a patch.
> 
> 
> I can see that the newer version always stores an information value.  Are 
> you suggesting that sr.c should ignore the return value and try to use 
> info whenever it is nonzero and within the appropriate range?  Or should 
> the decision to use info when the return value is 0 be based somehow on 
> other information about the device?

Alan,
The info field is optionally set for several SCSI
sense key values: medium and hardware error, perhaps
others. So if a ULD is invoking scsi_get_sense_info_fld()
I presume there is a good reason.

On disks I have seen the info field set to what looks
like the current lba when a REQUEST SENSE is sent
during a large transfer. The valid bit is clear
and the sense key is NO SENSE, so according to SBC
I regard that as a quaint response (but not an error).

The return value of scsi_get_sense_info_fld() should
be appropriately defined, that is it reflects whether
the "valid" bit is set.
I see the role of scsi_get_sense_info_fld() to yield as
much data as possible and let the ULD make the decision.
In the case of sr.c, it should be aware that due to
MMC not requiring the valid bit to be set, many
devices set the info field on a medium/hardware error
with the valid bit clear.

Note that for the "Information sense data descriptor"
(spc4r02 section 4.5.2.2) it is required that the valid
bit in there is set. Interestingly that was a change
introduced in spc3r22.pdf . So someone decided to stamp
on this fuzziness (when, in the future, devices switch
to descriptor sense format).

Doug Gilbert
