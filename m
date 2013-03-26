From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Tue, 26 Mar 2013 15:03:25 -0400
Message-ID: <5151F0FD.1020609@interlog.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de> <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34654 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754160Ab3CZTEJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Mar 2013 15:04:09 -0400
In-Reply-To: <alpine.WNT.2.00.1303261354360.5004@N5102REMCQXM4BS.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Jeremy Linton <jlinton@tributary.com>, Robert Elliott <Elliott@hp.com>, Bart Van Assche <bvanassche@acm.org>

On 13-03-26 02:00 PM, Chad Dupuis wrote:
>
>
> On Tue, 19 Feb 2013, Hannes Reinecke wrote:
>
>> This patchset updates the SCSI midlayer to use 64-bit LUNs internally.
>> It eliminates the need to limit the number of LUNs artificially to
>> avoid aliasing issues; the SCSI midlayer can now accept any LUN presented
>> to it.
>>
>> The LLDD specific settings for 'max_lun' have been left untouched;
>> it should be raised to '~0' if the HBA supports 64-bit LUNs internally.
>> However, it is up to the driver maintainer to raise that limit.
>>
>> Hannes Reinecke (4):
>>  scsi_scan: Fixup scsilun_to_int()
>>  scsi: use 64-bit LUNs
>>  scsi: use 64-bit value for 'max_luns'
>>  scsi: Remove CONFIG_SCSI_MULTI_LUN
>>
>
> Hannes,
>
> As we've reviewed these patches internally, the one question that keeps
> coming up is how do we handle hardware that cannot handle a 64-bit LUN
> address? For example, some of our older 2G/bps hardware can only handle a
> 16-bit LUN address.  Currently we convert the u32 value to u16.  Do we do
> the same for the 64-bit conversion? Can a way be devised to "opt-out" of
> receiving a 64-bit address in the first place (IIRC this was an option in
> the v1 patch set)?

Chad,
Perhaps I'm missing something. Given a t10_LUN and linux32_LUN
and the proposed linux64_LUN then the traditional 16 bit LUN
value (flat space addressing ?) would be either:
     (t10_LUN[0] << 8) | t10_LUN[1]
or
     linux32_LUN & 0xffff
or
     linux64_LUN & 0xffff


Doug Gilbert


