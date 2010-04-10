From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Proposal for BSG Interface -V2
Date: Sat, 10 Apr 2010 05:27:39 -0500
Message-ID: <4BC0529B.5040206@cs.wisc.edu>
References: <20100330234759.GA5874@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52668 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0DJK1u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Apr 2010 06:27:50 -0400
In-Reply-To: <20100330234759.GA5874@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de

On 03/30/2010 06:48 PM, Jayamohan Kallickal wrote:
> 	Have modified the code as per code review provided to
> remove Generic VENDOR opcode in the driver
>

You forgot to remove that code from the class code, and you forgot to 
use kmap like we talked about.

I just sent a patch to try and make the fc bsg code a lib, so try that 
out. For the iscsi code I think it just needs a fix up to sg_virt code 
(should be using kmap) and it needs a kfree on the completion path 
(looks like your patch was leaking what is in the va pointer and I did 
not fix that yet).
