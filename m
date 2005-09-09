From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] move iscsi to a better place in Kconfig
Date: Fri, 09 Sep 2005 12:03:00 -0500
Message-ID: <4321C044.3020605@cs.wisc.edu>
References: <1126191378.4845.8.camel@mulgrave>	 <43208FA2.8070304@cs.wisc.edu> <1126278063.4799.15.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:174 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030261AbVIIREl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 13:04:41 -0400
In-Reply-To: <1126278063.4799.15.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alex Aizman <itn780@yahoo.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

James Bottomley wrote:
> On Thu, 2005-09-08 at 14:23 -0500, Mike Christie wrote:
> 
>>I think the reason it was a dependency was becuase the transport class 
>>manages does the lifetime management/refcounting for the 
>>initiators/iscsi_tcp.c session struct. scsi_transport_iscsi allocates 
>>the scsi_host, and the initiator/iscsi_tcp.c's session structure is 
>>allocated in that host_data.
> 
> 
> Yes, but Kconfig isn't about lifetimes or, in fact, much of the way the
> code is constructed; it's about how the user selects particular
> features.
> 
> In the current setup, they have to know to say Y/M to the ISCSI
> attribute question even to see the config option for the iscsi
> initiator.  This is a bit counter intuitive (and definitely isn't the
> way any of the other drivers that depend on transport classes are
> presented).
> 

Yeah, sorry about that. With the userspace split and interpreting and 
implementing the review comments everything got a bit mixed up and we 
ended up the using the classes in a strange way. Should we resplit 
things up so that the host_alloc code is not part of the transport 
class? I think this will help the ql4xxx guys, Andrew have you started that?
