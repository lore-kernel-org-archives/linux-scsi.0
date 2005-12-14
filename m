From: Michael Joosten <michael.joosten@c-lab.de>
Subject: Re: [PATCH]: Re: qla1280.c broken on SGI visws, PCI	coherency	problem
Date: Wed, 14 Dec 2005 06:00:56 +0100
Message-ID: <439FA708.9070508@c-lab.de>
References: <4399D6EB.4080603@c-lab.de> <439A17BE.5000904@sgi.com>	 <439DE50B.90007@sgi.com> <1134424057.3713.18.camel@mulgrave>	 <439E0112.1030801@sgi.com>  <439ECB2E.7070103@sgi.com> <1134485413.3356.2.camel@mulgrave> <439F0FD6.30701@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailserver.c-lab.de ([131.234.80.230]:62130 "EHLO
	mailserver.c-lab.de") by vger.kernel.org with ESMTP
	id S1030349AbVLNFHY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Dec 2005 00:07:24 -0500
In-Reply-To: <439F0FD6.30701@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, pazke@donpac.ru, linux-scsi@vger.kernel.org

Michael Reed wrote:

>James Bottomley wrote:
>  
>
>>On Tue, 2005-12-13 at 07:22 -0600, Michael Reed wrote:
>>    
>>
>>>I believe the biggest issue with VISWS is that it appears to need
>>>mmiowb() and we likely don't know how to implement it.  Hence, for
>>>that platform, it would make sense to replace the mmiowb() with a
>>>posting read.
>>>      
>>>
>>Well, there's an easy way to tell ... the reason for the mmiowb in the
>>qla1280 driver is supposed to be an SMP race, according to the
>>description, so if it fails on UP as well there's something else going
>>on here ...
>>
>>I'm still suspicious because the mmiowb() in this driver replaced a
>>posted write flush instruction, which altered the behaviour of the
>>driver.  The qla1280 is just rare enough that it might have taken this
>>long to notice ...
>>    
>>
>
>Yup.  But.... keep in mind that the failing platform is the SGI
>VISWS, the child of a PC and an O2.  I'd be much more suspicious
>if it failed on a generic PC.  (It also works fine on SGI Altix,
>a platform which has implemented mmiowb().)
>
>Perhaps Mr. Joosten can confirm his failing case with the UP kernel?
>
>  
>
OK, I'm currently doing this, though with a Fedora Core3 kernel 
(2.6.12-1.1381-FC3) UP and SMP,  running it with some ooold filesystem 
benchmark on a similarly old PIII 500MHz board. What else is possible is 
an Intel dual PII (450MHz) server board (N440BX) , a dual PIII(730MHz) 
workstation and a very recent one with hyperthreading PIV. I'm currently 
using a distributed kernel with modules, because this version still has 
the mmiowb() in place (I hope!) .
There might be a timing issue (the faults happend somehow earlier once 
the board and the VisWS got warmer), but I hope that the other platforms 
will show a little difference...
Well, the PIII board with both a 550 and a 800 MHz proc showed no 
difference, the driver just *works*, no failure in 20 runs.  It looks 
like the problem only shows up in the VISWS. Perhaps I try it again 
putting the QLA1080 in the 32bit slot, which is apparently not 
controlled by the Lithium, but rather a plain PIIX chip. And perhaps 
some other platform and chipset.

Regards, Michael



