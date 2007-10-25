From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: Short INQUIRY return
Date: Thu, 25 Oct 2007 16:41:52 +0200
Message-ID: <4720AB30.5080003@panasas.com>
References: <4720940C.9040802@lxnt.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21876 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753749AbXJYOl7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 10:41:59 -0400
In-Reply-To: <4720940C.9040802@lxnt.info>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexander Sabourenkov <screwdriver@lxnt.info>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, Oct 25 2007 at 15:03 +0200, Alexander Sabourenkov <screwdriver@lxnt.info> wrote:
> Hello.
> 
> 
> Background:
> 	Promise TX4 SATA300 with sata_promise driver generates lots of errors, 
> both read and write.
> 
> 	I'm now trying to port Promise-written driver, which works ok with 
> 2.6.11, to 2.6.22,
> 	so that I can hopefully discover the error-inducing difference between 
> them, and gain
> 	some understanding of kernel internals in the process.
> 
> 	I have somewhat cleaned up the horrible mess the Promise driver code 
> is, so that it compiles,
> 	loads and attaches to the controller.
> 
> 
> Problem:
> 
> 	Its internal port scan prints out correct information about hard 
> drive(s) discovered, and correctly
> 	(i think) fills out response to the INQUIRY command, but when scsi 
> subsystem receives it back,
> 	it contains some garbage instead.
> 
> 	The same code works ok on 2.6.11, and I think it would work ok up to 
> 2.6.16 at least, but I have not checked yet.
> 
> Question:
> 	Can anyone please point out some drastic change in SCSI subsystem
> 	(and what it would take to fix the driver up)
> 	that would result in such behavior, so that I can save some time 
> digging it up myself?
> 
> 

Just at the top of my head without looking at the code at all. I would
say the bigest change would be the use of use_sg != 0 for all commands
in Later kernels. (k>=2.6.17)
Look for and around the scsi_cmnd->request_buffer usage. It used to be
that for commands like INQUIRY it points to a linear char pointer.
Today it will always point to a scatterlist array and use_sg is the sg count
of that array. (Usually ==1 in the INQUIRY case)

Just a shot in the dark
(Where is the code for that driver?)
Boaz

