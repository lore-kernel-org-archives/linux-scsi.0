From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 7864] New: A MTIOCTOP/MTWEOF within the early
 warning will cause the file number to be incorrect
Date: Wed, 24 Jan 2007 20:48:04 -0800
Message-ID: <20070124204804.77486468.akpm@osdl.org>
References: <200701222107.l0ML7KPn010266@fire-2.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46624 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115AbXAYEsP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jan 2007 23:48:15 -0500
In-Reply-To: <200701222107.l0ML7KPn010266@fire-2.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ce_reisinger@yahoo.com
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>, linux-scsi@vger.kernel.org, Kai Makisara <Kai.Makisara@kolumbus.fi>

On Mon, 22 Jan 2007 13:07:20 -0800
bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=7864
> 
>            Summary: A MTIOCTOP/MTWEOF within the early warning will cause
>                     the file number to be incorrect
>     Kernel Version: 2.6.19.2
>             Status: NEW
>           Severity: low
>              Owner: io_scsi@kernel-bugs.osdl.org
>          Submitter: ce_reisinger@yahoo.com
> 
> 
> Write records to a SCSI tape until a write fails with a ENOSPC (you have reached
> early warning.
> Now perform a:
>    struct mtget before, after;
>    ioctl(fd, MTIOCGET, &before);
>    struct mtop mtop = { MTWEOF, 1 };
>    ioctl(fd, MTIOCTOP, &mtop);
>    ioctl(fd, MTIOCGET, &after);
> 
> Check the value of mt_fileno in the before and after structures. Notice the
> after is 2 greater then the before.
> 
> The problem appears to be in the block of code starting at line 2817 in st.c.
> This block is entered because the drive did return a CHECK CONDITION with NO
> SENSE and the SENSE_EOM bit set. At lines 2824/5 the fileno is incremented. But
> it has already been increased by the number of filemarks requested by the
> MTIOCTOP. I believe that the residue count in the sense data should be
> subtracted from fileno, not a increment as is done.
> 

Thanks.  Could you please send us a tested patch to fix these things, as
per http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt ?
