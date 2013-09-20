From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH] sd: dif sector calculation
Date: Fri, 20 Sep 2013 16:52:06 -0600 (MDT)
Message-ID: <alpine.LRH.2.03.1309201647220.31457@AMR>
References: <1379475143-2792-1-git-send-email-keith.busch@intel.com> <yq1ob7ndt0w.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50160 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab3ITWwL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Sep 2013 18:52:11 -0400
In-Reply-To: <yq1ob7ndt0w.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Keith Busch <keith.busch@intel.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Ric Wheeler <rwheeler@redhat.com>

On Fri, 20 Sep 2013, Martin K. Petersen wrote:

>>>>>> "Keith" == Keith Busch <keith.busch@intel.com> writes:
>
> Keith> The ref tag should be the device's physical LBA rather than the
> Keith> 512 byte bio sector.
>
> The bip sector is just a seed value set by the application. It is not
> correct to scale it based on sector size or PI interval.

If I follow the current implementation correctly and have a 4k physical
block size, a two block write at LBA 0 will generate ref tags 0 and 1
for that operation. If I read back one block at LBA 1, the current code
will expect the ref tag to be 8, but come back as 1, failing the compare.
