From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: BUG() in 2.4: sg direct IO + exit()
Date: Wed, 24 Mar 2004 11:22:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <04Mar24.112256est.332201@cyborg.cybernetics.com>
References: <406185C6.6050705@torque.net>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cyborg.cybernetics.com ([206.246.200.18]:51985 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S263756AbUCXQXK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Mar 2004 11:23:10 -0500
In-Reply-To: <406185C6.6050705@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

> It is not causing an oops when I try with scsi_debug and lk 2.6.5-rc2.
> Neither is there a problem with a Suse 9 stock SMP kernel
> (2.4.21-99-smp4G) on an old dual celeron (A-bit mb) box with a
> Sony SDT-7000 tape drive on /dev/sg0.

It could be that on your machine the command finishes before the exit(),
causing unmap_kiobuf->__free_pages->put_page_testzero(page) to leave the
page reference count nonzero instead of calling __free_pages_ok.  A
command that takes longer to finish (e.g. READ(6)) might trigger the
BUG() on your machine.

Anthony J. Battersby
Cybernetics

