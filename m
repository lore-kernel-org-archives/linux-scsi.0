From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH v5 2/3] libata: async resume
Date: Fri, 19 Dec 2014 18:46:25 -0500
Message-ID: <5494B8D1.1070608@ubuntu.com>
References: <20140305201443.20088.85361.stgit@viggo.jf.intel.com> <20140305201735.20088.22124.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:30260 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752689AbaLSXqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Dec 2014 18:46:30 -0500
In-Reply-To: <20140305201735.20088.22124.stgit@viggo.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, tj@kernel.org, JBottomley@Parallels.com, Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

On 03/05/2014 03:17 PM, Dan Williams wrote:
> From: Todd Brandt <todd.e.brandt@linux.intel.com>
> 
> Improve overall system resume time by making libata link recovery 
> actions asynchronous relative to other resume events.
> 
> Link resume operations are performed using the scsi_eh thread, so 
> commands, particularly the sd resume start/stop command, will be
> held off until the device exits error handling.  Libata already
> flushes eh with ata_port_wait_eh() in the port teardown paths, so
> there are no concerns with async operation colliding with the
> end-of-life of the ata_port object.  Also, libata-core is already
> careful to flush in-flight pm operations before another round of pm
> starts on the given ata_port.

I realize this is a little late but I finally started looking at the
patch set I was working on last year again, and now that I look at
your version that was accepted, I realize that it only addresses the
libata side of things.  sd still issues START_STOP_UNIT synchronously
in the resume path, so without the patch fixing that, you shouldn't
see any actual speed up in resume times.  Or are you using the
manage_start_stop flag to inhibit that ( at the cost of taking an
emergency park on each suspend/shutdown )?


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUlLjNAAoJENRVrw2cjl5RU48H/2APBJMJ9XyTEfa7r6+M76zH
jf238VwOJUuTUC+Mh2h3AoQVkNy4E8CM/CAnWww8Y1iAvuRTptp9J64NrAQdylCf
p3KLIqhXaGmGvgx1SpzwzwGhbvZ9YM8w1uRC1VLACr9ZwySjEXyEv3B2kZDDUMEj
xxnnQfM47f2km6pxhV7nzt1jHlvaWhvPsuRSaVFxLQstbGR9U1VLJnESZgBFYipR
w5z0dmhssE21A/T8B7dSAx5tDCATeWsMn5fDtQ15MFXgfguXrmmOuHLBtv9EGPZt
d5M1rr2E7WXems5pBoxJMcYFblwQ/h30qPEkRNgYXrfTRx7h79q20tWNI+B1D1c=
=s6tS
-----END PGP SIGNATURE-----
