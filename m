From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Midlayer initiated START_UNIT
Date: Tue, 17 Feb 2004 08:27:22 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <403224CA.2050107@us.ibm.com>
References: <401985E6.8060603@us.ibm.com> <00e301c3f528$b0ba4440$7d074d0a@apac.cisco.com> <20040217080446.GA23112@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:15338 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266186AbUBQO1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 09:27:39 -0500
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: "Sachin Mhatre (smhatre)" <smhatre@cisco.com>, linux-scsi@vger.kernel.org

Matthew Dharm wrote:
> Umm... I hope that the issuing of START_UNIT will only occur in very
> narrowly defined cases.
> 
> If you just issue START_UNIT semi-arbitrarily, you'll break most USB
> devices.

And the patch allows for this. With the patch, devices will only get
this new behavior if a flag gets set in their scsi_device struct by
the LLD in its slave_configure routine.

-Brian


> On Tue, Feb 17, 2004 at 01:06:00PM +0530, Sachin Mhatre (smhatre) wrote:
> 
>>Has this patch been included in the linux 2.6.X kernel? This patch would
>>also help the iscsi LLDD as it is also facing the same START_UNIT
>>problem.
>>I would really appreciate any help on this matter.
>>
>>Thanks,
>>Sachin
>>
>>
>>-----Original Message-----
>>From: linux-scsi-owner@vger.kernel.org
>>[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Brian King
>>Sent: Friday, January 30, 2004 3:45 AM
>>To: James.Bottomley@steeleye.com
>>Cc: linux-scsi@vger.kernel.org
>>Subject: [PATCH] Midlayer initiated START_UNIT
>>
>>
>>James,
>>
>>This is a patch to issue a START_UNIT command from the midlayer error
>>handler. The ipr driver, which is currently out for review needs this to
>>function properly. Any time the adapter gets reset, the disk array
>>resources under the ipr adapter require another START_UNIT command. This
>>causes problems with the current error handling and these devices get
>>taken offline when this occurs.
>>
>>This was being handled by the ipr driver itself, but Christoph did not
>>like seeing a LLDD issuing commands to devices, hence the patch.
>>
>>http://marc.theaimsgroup.com/?l=linux-scsi&m=107462193622673&w=2
>>
>>Patch is against 2.6.2-rc2.
>>
>>Thanks
>>
>>
>>
>>-- 
>>Brian King
>>eServer Storage I/O
>>IBM Linux Technology Center
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>the body of a message to majordomo@vger.kernel.org More majordomo info
>>at  http://vger.kernel.org/majordomo-info.html
>>
>>-
>>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

