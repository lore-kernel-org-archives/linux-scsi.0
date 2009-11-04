From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] iscsi transport : add sgio pass-thru support
Date: Wed, 04 Nov 2009 09:52:34 -0600
Message-ID: <4AF1A342.1010805@cs.wisc.edu>
References: <1256853056.7154.6.camel@wookie> <4AEF715C.4030700@cs.wisc.edu> <4AF0400F.2030608@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42378 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756752AbZKDPwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Nov 2009 10:52:37 -0500
In-Reply-To: <4AF0400F.2030608@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com

James Smart wrote:
> I actually started the patch with this in mind - making a common layer.  
> I was able to commonize:  xx_bsg_destroy_job(), xx_bsg_jobdone(), 
> xx_softirq_done(), a helper for the timeout function (chkjobdone()), 
> xx_bsg_map_buffer(), xx_req_to_bsgjob(), and xx_bsg_goose_queue().
> 
> However, what I was finding was I was jumping through hoops with the 
> data structures (whose header where, structures within structures, 
> nested private areas, etc).  Additionally, I kept finding chunks of the 
> code flow, which had parallels to the items in the common routines, that 
> had to be left within the transport (e.g. rx path in transport, tx in 
> common; or vice versa) - e.g. if I can't encapsulate both sides of the 
> code flow within the common code I lose many of the advantages - I ended 
> up abandoning it  under the guise of "complexity==bad"
> 
> I can post some of the work to see if you have the same conclusion. Yes, 
> I don't like the replication either.
> 

Do not worry about it. I am looking at it in more depth now.
