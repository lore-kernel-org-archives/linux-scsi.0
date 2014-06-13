From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v4] sg: O_EXCL and other lock handling
Date: Fri, 13 Jun 2014 10:33:37 -0400
Message-ID: <539B0BC1.2020303@interlog.com>
References: <539A453F.5020502@interlog.com> <20140613090316.GA18032@lst.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38434 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbaFMOdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jun 2014 10:33:43 -0400
In-Reply-To: <20140613090316.GA18032@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, vaughan <vaughan.cao@oracle.com>

On 14-06-13 05:03 AM, Christoph Hellwig wrote:
> Hi Doug,
>
> this looks generally good to me, but I don't think open_cnt and exclude
> have to use atomic_t, as they are only ever modified under open_rel_lock.

They are read by 'cat /proc/scsi/sg/debug' [in
sg_proc_seq_show_debug()] but transient off-by-1 reports
are not so important. [Prior to locking that block with
read_lock(sfd_lock) that routine sometimes printed wild
results, so some care is required.]

> Can you take a look at the version below?  This changes open_cnt to an
> int, exclude to a bool, removes the open_cnt underflow check that
> the VFS takes care for, and streamlines the open path a little bit:

sg_open() and sg_release() clean-up looks good. The
back-up goto at the end of sg_open() reminds me of
Fortran style :-) More importantly my sg_tst_excl*
tests give this version the thumbs up.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

