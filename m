From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH][RELEASE]: megaraid unified driver version 2.20.0.B1
Date: Fri, 16 Apr 2004 14:30:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4080264E.2040506@pobox.com>
References: <0E3FA95632D6D047BA649F95DAB60E570230C7DB@exa-atlanta.se.lsil.com> <40801F5D.7030100@pobox.com> <408024CA.8000401@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:34747 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S263540AbUDPSax
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 14:30:53 -0400
In-Reply-To: <408024CA.8000401@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: "Bagalkote, Sreenivas" <sreenib@lsil.com>, "'Matt_Domsch@dell.com'" <Matt_Domsch@dell.com>, "'paul@kungfoocoder.org'" <paul@kungfoocoder.org>, "Mukker, Atul" <Atulm@lsil.com>, "'James.Bottomley@SteelEye.com'" <James.Bottomley@SteelEye.com>, "'arjanv@redhat.com'" <arjanv@redhat.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

Brian King wrote:
> Jeff Garzik wrote:
> 
>> 6) Kill uses of "volatile".  _Most_ of the time, this indicates buggy 
>> code.  You should have the proper barriers in place:  mb(), wmb(), 
>> rmb(), barrier(), and cpu_relax().  This has been mentioned before :)
> 
> 
> I'm not sure I totally agree with this statement. I took a quick look at 
> the driver
> and the volatile appears to be used to point to host memory that is 
> modified
> by the adapter. Correct me if I am wrong, but memory barriers will not 
> accomplish
> what the volatile will in this situation.


You are wrong :)  Compare the underlying asm.

Proper use of barriers tells the compiler when it cannot cache certain 
loads and stores in registers.  'volatile' is an atomic bomb to the 
compiler, killing many valid optimizations while (sometimes) hiding 
bugs.  It almost always indicates that the programmer did not bother 
thinking about when and where DMA memory needs to be accessed.

	Jeff



