From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Disk Errors
Date: Tue, 15 Feb 2005 15:56:41 +1000
Message-ID: <42118F19.5090604@torque.net>
References: <60807403EABEB443939A5A7AA8A7458BBD5E44@otce2k01.adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:56522 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261635AbVBOF4F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 00:56:05 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BBD5E44@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org

Salyzyn, Mark wrote:
> From: Douglas Gilbert [mailto:dougg@torque.net] writes:
> 
>>All may not be lost. If a medium error occurs and the ASC and
>>ASCQ imply the sector could be read but
>>failed ECC then the READ LONG SCSI command should fetch the
>>block (plus ECC and other data). For example a Fujitsu MAM3184
>>returns 576 bytes. It is probably too much to expect that all
>>the damage will be in the last 64 bytes.
> 
> 
> However, the drive has taken whatever action it could to reconstruct the
> data, the failure to report the block for a standard read means that the
> data is in fact `lost'. The data+ECC combination must be in a state
> where there are more bits of damage than the error correction can deal
> with; 64 bytes of ECC deals with single bit errors thus we know that we
> have more than 1 bit of damage to the disk. We could have 4096 bits of
> damage in the worst case :-) and never know that fact.
> 
> If I wanted in desperation to recover whatever data I could, this would
> be grand, but as it stands, from the Linux File System Driver
> perspective, it would be dangerous to accept this block as anything more
> than it is.
> 
> If the data is of the form to permit some loss, for example video, audio
> content or an error correcting stream of data, someone can make a case
> where READ_LONG is an appropriate action to take to help fill in missing
> content. 
> 
> A fun thought ...

Mark,
I will try extending sg_dd in sg3_utils to do this
when its "continue on error" flag is set. It could
return additional counts of dubious blocks as well as
completely lost ones.

If that is useful then perhaps sd could be extended.

Doug Gilbert

