From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: Read buffer overflow
Date: Tue, 4 Aug 2009 09:39:45 -0400
Message-ID: <4A783A21.3070801@emulex.com>
References: <4A754999.90208@gmail.com> <4A76FC0D.7080005@emulex.com>	 <20090803164223.6aa6555b.akpm@linux-foundation.org> <1249345878.3943.240.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:61109 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbZHDNj4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 09:39:56 -0400
In-Reply-To: <1249345878.3943.240.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "roel.kluin@gmail.com" <roel.kluin@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



James Bottomley wrote:
> I'd suggest not:
> 
> jejb@mulgrave:~/git/linux-2.6/drivers/scsi/lpfc> git grep 'max_vports && vports'|wc -l
> 17
> 
> Assuming this secures agreement as a patch, I don't really want to wade
> through another 16 patches for the remaining ones.  You definitely can't
> reduce the vport array length until they're all fixed.
> 
> What I hear is that it's not a problem, but it's a possible
> micro-optimisation.  Assuming the maintainer agrees, it's far better
> just to fix everything at once.  However, I'm equally happy to leave it
> as is since there's no actual problem given the allocation definition.
> 
>> What prevents the loop in lpfc_create_vport_work_array() from wandering
>> off the end of vports[], btw?
> 
> We refuse to create any vports beyond this number ... the iterator
> counts the number of created vports (it's actually a firmware limited
> number, I believe).
> 
> James

Agree. It's a style thing from one of the contributors to the driver.  There 
is no issue, I don't believe that optimizing 1 less pointer's worth of 
allocation is a big deal (good, yes, but...). However, I do recognize it is a 
much better coding style.

I'll roll the changes for it into the next driver patch set.  (Yes, it is a 
firmware limited number).

-- james s
