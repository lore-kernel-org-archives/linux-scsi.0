From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 5/5] scsi_debug: Implement support for DIF Type 2
Date: Thu, 27 Aug 2009 14:54:44 +0000
Message-ID: <1251384884.6426.31.camel@mulgrave.site>
References: <1251267481-24135-1-git-send-email-martin.petersen@oracle.com>
	 <1251267481-24135-6-git-send-email-martin.petersen@oracle.com>
	 <4A952D54.5010102@panasas.com> <yq1ab1l91zy.fsf@sermon.lab.mkp.net>
	 <4A965366.7080409@panasas.com> <1251380478.6426.11.camel@mulgrave.site>
	 <4A96962A.8050208@panasas.com> <1251383413.6426.22.camel@mulgrave.site>
	 <4A969C80.5090604@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbZH0Oyt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2009 10:54:49 -0400
In-Reply-To: <4A969C80.5090604@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Thu, 2009-08-27 at 17:47 +0300, Boaz Harrosh wrote:
> On 08/27/2009 05:30 PM, James Bottomley wrote:
> > On Thu, 2009-08-27 at 17:20 +0300, Boaz Harrosh wrote:
> >> On 08/27/2009 04:41 PM, James Bottomley wrote:
> >>>
> >>> The general rule is not to confuse coding styles, so the correct way to
> >>> add stuff is to use the existing conventions in the file.  You can
> >>> optionally convert the entire style if necessary.  However, for these
> >>> get_cpu_be macros, there's no real benefit other than saving typing, so
> >>> a global conversion effort simply isn't worth it.
> >>>
> >>
> >> This is not right. The get_cpu_be macros are ten fold faster and smaller
> >> on all the platforms we ever use. I'm talking about 16-96 to 1 for a 64 bit
> >> operation.
> > 
> > Assembly comparisons didn't bear this out the last time I looked; what
> > changed?
> > 
> 
> I'm not sure what test you made. But for instance on x86_64 which has unaligned
> cpu support, the get_unaligned_be64 is a simple SWAB instructions as opposed to
> 8 "or" + 8 "shift". Not to mention BE systems which do nothing (memcpy)

Well, what I saw on x86 is that gcc optimises the shifts to exactly the
same code as get_unaligned_be.  What does the assembly comparison look
like on x86-64?  However, regardless, this is hardly critical path
affecting stuff.

James


