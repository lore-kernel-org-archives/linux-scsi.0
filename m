From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH scsi-misc-2.6 07/08] scsi: remove bogus	{get|put}_device()
 calls
Date: Wed, 23 Mar 2005 18:13:26 +0900
Message-ID: <42413336.2010004@gmail.com>
References: <20050323021335.960F95F8@htj.dyndns.org>	 <20050323021335.0D9E25EE@htj.dyndns.org> <1111551355.5520.100.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Received: from rproxy.gmail.com ([64.233.170.196]:38001 "EHLO rproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261270AbVCWJNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2005 04:13:35 -0500
Received: by rproxy.gmail.com with SMTP id 1so226162rny
        for <linux-scsi@vger.kernel.org>; Wed, 23 Mar 2005 01:13:31 -0800 (PST)
In-Reply-To: <1111551355.5520.100.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

  Hi,

James Bottomley wrote:
> On Wed, 2005-03-23 at 11:14 +0900, Tejun Heo wrote:
> 
>>	So, basically, SCSI high-level object (scsi_disk) and
>>	mid-level object (scsi_device) are reference counted by users,
>>	not the requests they submit.  Reference count cannot go zero
>>	with active users and users cannot access the object once the
>>	reference count reaches zero.
> 
> 
> Actually, no.  Unfortunately we still have some fire and forget APIs, so
> the contention that we always have an open refcounted descriptor isn't
> always true.

  Yeap, you're right.  So, what we have is

  * All high-level users have open access to the scsi high-level
    object on issueing requests, but may close it before its requests
    complete.
  * All mid-layer users do get_device() before submitting requests,
    but may put_device() before its requests complete.

  Thanks for pointing that out.  :-)

-- 
tejun

