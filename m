From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Sun, 5 Sep 2004 22:19:12 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409052157540.2062@poirot.grange>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange>
 <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange>
 <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange>
 <1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:3049 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S267482AbUIFFuy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2004 01:50:54 -0400
In-Reply-To: <20040905173134.A31521@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 5 Sep 2004, Christoph Hellwig wrote:

> On Sun, Sep 05, 2004 at 11:42:58AM -0400, James Bottomley wrote:
>> On Sun, 2004-09-05 at 10:56, Guennadi Liakhovetski wrote:
>>> Ok, how about the attached version?
>>
>> Well, it looks like it would cure the symptoms, and I can apply it as a
>> palliative.
>>
>> However, the disease in this driver is that it snoops the inquiry data
>> and gets confused by the double inquiry we now do for certain drives.
>>
>> What really needs to happen is
>>
>> 1) remove the inquiry snooping and believe the flags in struct
>> scsi_device instead

...and use tags set up by the block layer...

>> 2) Don't turn on TCQ until slave_configure()

Well, this alone wouldn't help with this specific problem, exactly because 
INQUIRY can be sent later too. Or would the mid-layer completely disable 
tagging for such a disk?

>> 3) remove it's internal TCQ black list and put it at the mid-layer.
>
> Umm yes.  But lets get the driver no oops first and then move forward.
> There's still a lot of work to do on the driver.

Thanks
Guennadi
---
Guennadi Liakhovetski

