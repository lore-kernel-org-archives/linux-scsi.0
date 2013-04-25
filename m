From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 2/2] dm mpath: attach scsi_dh during table resume
Date: Thu, 25 Apr 2013 09:48:04 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1304250938480.8307@file.rdu.redhat.com>
References: <20130404131631.GA10208@redhat.com> <1365457816-31475-1-git-send-email-snitzer@redhat.com>
 <1365457816-31475-2-git-send-email-snitzer@redhat.com> <20130422223355.GA4803@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab3DYNs3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Apr 2013 09:48:29 -0400
In-Reply-To: <20130422223355.GA4803@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, hare@suse.de



On Mon, 22 Apr 2013, Mike Snitzer wrote:

> I spoke with Hannes at LSF, to address the potential crashes in the
> endio path (e.g. stpg_endio) we'd have to bump the scsi_dh_data kref
> where appropriate (e.g. for ALUA kref_get in submit_stpg and kref_put in
> stpg_endio).
> 
> But that is just the tip of the iceberg relative to scsi_dh lifetime.
> Seems we've been playing it pretty fast and loose with scsi_dh issued
> requests vs detach for quite some time.
> 
> I'm now inclined to not care about this issue.  Take away is: don't
> switch the device handler (attach the correct one from the start).

I did a patch that disables device handler switching and it was NACKed by 
Hannes. The problem that he pointed out was - when we load SCSI device 
handler modules, they attach automatically to SCSI devices they think they 
belong to. The user then can't set the desired device handler in multipath 
configuration because a different handler is already attached.

So we need a functionality to change device handlers.

(or maybe stop the scsi device handlers from attaching automatically, but 
it would surely generate a lot of other regressions)

Mikulas
