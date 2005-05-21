From: Douglas Gilbert <dougg@torque.net>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Sun, 22 May 2005 08:06:50 +1000
Message-ID: <428FB0FA.7040302@torque.net>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk>	 <1116687698.4999.3.camel@mulgrave> <428F55F1.3090006@pobox.com>	 <1116691256.4999.16.camel@mulgrave>	 <20050521162220.GU29811@parcelfarce.linux.theplanet.co.uk> <1116699144.4999.37.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:53721 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261652AbVEUWGv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 May 2005 18:06:51 -0400
In-Reply-To: <1116699144.4999.37.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net

James Bottomley wrote:
> On Sat, 2005-05-21 at 17:22 +0100, Al Viro wrote:
> 
>>Tell that to firmware authors, why don't you?
> 
> 
> I do ... but they don't listen ...
>  
> 
>>>Does anyone actually have one of these RBC devices and does it reject
>>>the six byte mode sense commands?
>>
>>Yes, will check and do not expect the results to apply to other devices...
> 
> 
> Thanks ... I'd be surprised if the entire class of RBC devices simply
> ignored the standard; I wouldn't be surprised to find one or two that
> are out of spec.
> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

James,
Perhaps __scsi_mode_sense() could do a simple sanity
check: for any valid mode page [after the header and
block descriptor(s) are stepped over]:
      ((mpage[0] & 3f) == page_num)

If a response fails that test, we don't believe it.

Doug Gilbert

