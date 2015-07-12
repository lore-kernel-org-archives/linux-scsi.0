From: Calvin Owens <calvinowens@fb.com>
Subject: Re: [PATCH 5/6] Refactor code to use new fw_event refcount
Date: Sat, 11 Jul 2015 21:13:54 -0700
Message-ID: <20150712041354.GA4002764@mail.thefacebook.com>
References: <1431661322-3097935-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-1-git-send-email-calvinowens@fb.com>
 <1433821856-2815280-6-git-send-email-calvinowens@fb.com>
 <20150703160033.GA11815@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29242 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbbGLEOb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Jul 2015 00:14:31 -0400
Content-Disposition: inline
In-Reply-To: <20150703160033.GA11815@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Thanks for this, I'm sending a v2 shortly.

On Friday 07/03 at 09:00 -0700, Christoph Hellwig wrote:
> On Mon, Jun 08, 2015 at 08:50:55PM -0700, Calvin Owens wrote:
> > This refactors the fw_event code to use the new refcount.
> 
> I spent some time looking over this code because it's so convoluted.
> In general I think code should either embeed one work_struct (and it
> really doesn't seem to need a delayed work here!) or if needed a list
> and not both like this one.  But it's probably too much work to sort
> all this out, so let's go with your version.

Yeah, I tried to get rid of fw_event_list altogether, since I think what
cleanup_queue() does could be simplified to calling flush_workqueue().

The problem is _scsih_check_topo_delete_events(), which looks at the
list and sometimes marks fw_events as "ignored" so they aren't executed.
