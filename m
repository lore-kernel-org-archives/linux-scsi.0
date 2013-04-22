From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/2] dm mpath: attach scsi_dh during table resume
Date: Mon, 22 Apr 2013 18:33:56 -0400
Message-ID: <20130422223355.GA4803@redhat.com>
References: <20130404131631.GA10208@redhat.com>
 <1365457816-31475-1-git-send-email-snitzer@redhat.com>
 <1365457816-31475-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348Ab3DVWej (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Apr 2013 18:34:39 -0400
Content-Disposition: inline
In-Reply-To: <1365457816-31475-2-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: mpatocka@redhat.com, hare@suse.de

On Mon, Apr 08 2013 at  5:50pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> Preallocate scsi_dh_data using scsi_dh_alloc_data() during table load
> but attach the scsi_dh for each path during table resume.  This avoids a
> kernel crash that can happen when changing the scsi_dh during table
> load.
> 
> When we reload a multipath device, there are two instances of the
> multipath target - the first instance that is active and the second
> instance that is being constructed during table load with "ctr" method.
> 
> If the multipath constructor finds out that the device is using a
> different device handler, it detaches the existing handler and attaches
> a new handler. However, the first instance of the multipath target still
> exists and processes requests. If the first instance sends some
> path-management request with scsi_dh_activate and the second instance
> detaches the device handler while the path-management request is in
> flight, a crash happens. The reason for the crash is that the endio
> routine for the path-management request is working with structures that
> were freed when the handler was detached.
> 
> References:
>   http://bugzilla.redhat.com/912245
>   http://bugzilla.redhat.com/902595

While this patch addresses the problem of switching the SCSI device
handler prematurely (during load rather than resume) it doesn't do
anything to defend against the use after free NULL pointers that are
possible with the scenario explained above (and as detailed in the
referenced BZs).

I spoke with Hannes at LSF, to address the potential crashes in the
endio path (e.g. stpg_endio) we'd have to bump the scsi_dh_data kref
where appropriate (e.g. for ALUA kref_get in submit_stpg and kref_put in
stpg_endio).

But that is just the tip of the iceberg relative to scsi_dh lifetime.
Seems we've been playing it pretty fast and loose with scsi_dh issued
requests vs detach for quite some time.

I'm now inclined to not care about this issue.  Take away is: don't
switch the device handler (attach the correct one from the start).
