From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 1/3] SCSI Userspace Target: scsi-ml changes
Date: Mon, 06 Feb 2006 12:33:52 -0600
Message-ID: <1139250832.3022.26.camel@mulgrave.il.steeleye.com>
References: <1138157885.11692.32.camel@max>
	 <1139164228.3017.14.camel@mulgrave.il.steeleye.com>
	 <20060206113356T.fujita.tomonori@lab.ntt.co.jp>
	 <43E78D68.7010301@cs.wisc.edu>
	 <1139248965.3022.11.camel@mulgrave.il.steeleye.com>
	 <43E793F2.6070703@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:657 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932267AbWBFSeN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 13:34:13 -0500
In-Reply-To: <43E793F2.6070703@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Mon, 2006-02-06 at 12:22 -0600, Mike Christie wrote:
> I understand. To make this worse, for the target code since we are 
> mapping data like SG_IO block layer code (we used their functions) we 
> need process context for the unmap. To handle this we added a work 
> struct on the scsi_cmnd and the work struct is pretty large and only 
> used for targets. We can move all the target specific to a:
> 
> scsi_tgt_cmnd {
> 	work;
> 	host;
> };
> 
> And store out scsi_tgt_cmnd in the scsi_cmnd->host_scribble or somewhere 
> on the SCp. Is that too hacky?

Could you take a look at the execute_in_user_context() function I'm
hatching to add to the workqueue here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=113916262109180&w=2

And see if that would suit your purpose without any additions to
scsi_command (probably the data carried would have to be the actual
command).

James


