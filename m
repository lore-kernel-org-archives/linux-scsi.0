From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Disk Errors
Date: Wed, 02 Feb 2005 13:55:15 +1000
Message-ID: <42004F23.10009@torque.net>
References: <60807403EABEB443939A5A7AA8A7458BB5232F@otce2k01.adaptec.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:59024 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262257AbVBBDzC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2005 22:55:02 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BB5232F@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org

Salyzyn, Mark wrote:
> An unrecoverable medium error is typically `corrected' when a write to
> the block occurs. RAID cards will use the redundancy to calculate the
> data and write it back to the offending drive for instance.
> 
> Otherwise, for none-redundant stores, bad media is as good as anything
> to remind one that the data is gone ;->
> 
> Sincerely -- Mark Salyzyn

All may not be lost. If a medium error occurs and the ASC and
ASCQ imply the sector could be read but
failed ECC then the READ LONG SCSI command should fetch the
block (plus ECC and other data). For example a Fujitsu MAM3184
returns 576 bytes. It is probably too much to expect that all
the damage will be in the last 64 bytes.

As Mark pointed out, if /dev/sda is a virtual disk then it is
unlikely that the READ LONG SCSI command will be supported.

sg3_utils has a sg_read_long utility. "Long" blocks can
be written to the media with the sg_write_long utility
which was introduced mainly for testing (e.g. creating
"artificial" medium errors).


BTW I noticed that the block layer reads "around" a medium
error. Say 8 KB is being read and a medium error occurs
(and the info field is set to the lba of the first failure)
then several small reads are done to reconstruct as much
of the original 8 KB as possible (probably with a block of
zeroes corresponding to the medium error).

Doug Gilbert

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Bryan Henderson
> Sent: Tuesday, February 01, 2005 1:01 PM
> To: dougg@torque.net
> Cc: Kit Gerrits; linux-scsi@vger.kernel.org
> Subject: Re: Disk Errors
> 
> 
>>So there are two situations in which damaged blocks remain
>>accessible:
>>   1) unrecoverable medium errors
>>...
> 
> 
> What's the rationale behind leaving a damaged block accessible in the
> case 
> of an unrecoverable medium error?  A possibility that someone might 
> actually be able to recover the data?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

