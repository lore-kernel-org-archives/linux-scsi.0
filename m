From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: SCSI kobject unregistration ordering problem
Date: Mon, 20 Oct 2003 10:07:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031020170711.GA5183@beaverton.ibm.com>
References: <20031013151254.521d882e.akpm@osdl.org> <20031017133429.C27349@infradead.org> <20031017155008.GA1298@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:61351 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262583AbTJTREo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Oct 2003 13:04:44 -0400
Content-Disposition: inline
In-Reply-To: <20031017155008.GA1298@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Patrick Mochel <mochel@osdl.org>, Greg KH <greg@kroah.com>, Andrey Borzenkov <arvidjaar@mail.ru>

Mike Anderson [andmike@us.ibm.com] wrote:
> 
> While I have it working now without the block layer changes (i.e., no
> delayed device_del call in SCSI). I also thought there was something
> needed in the block layer, there may still need to be block layer
> updates for other issues but I am currently not seeing them in my
> testing. The issue scsi was having is related to sd_remove freeing the
> scsi_disk structure to early in some cases. Since sd passed the
> scsi_disk structure to the block layer subsystem in a gendisk private
> data pointer sd needs to use a ref count / release function model to
> know when to free scsi_disk. I am almost done with a few surprise
> removal test cases and will post the patch for review today.
> 

I posted Friday adding a release call to the scsi_disk structure and
removing the delay call to device_del. On test8 this corrected the
problem I was seeing of surprise removal with a mounted device. A pointer
to the patch in the archive is below.

http://marc.theaimsgroup.com/?l=linux-scsi&m=106646263401437&w=2

I will work today to send this patch to others that have posted bugzilla
bugs related to this same failure mode and see if this patch corrects
there problem.

Based on feedback I will update the patch and repost to linux-scsi and
lkml.

-andmike
--
Michael Anderson
andmike@us.ibm.com

