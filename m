From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 15:49:48 -0500
Message-ID: <52D9976C.2010009@ubuntu.com>
References: <20140116220409.GA1183@linux.intel.com>	<Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org> <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:59679 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaAQUtu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2014 15:49:50 -0500
In-Reply-To: <CAA9_cmcHpWOk_GoAZ_6k_0VDNGdac+BmHB1GxaTNkWNVjcztJQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Alan Stern <stern@rowland.harvard.edu>
Cc: Todd E Brandt <todd.e.brandt@linux.intel.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/17/2014 2:31 PM, Dan Williams wrote:
> Once dpm_resume of the disk is asynchronous, is there much
> incremental gain by further deferring spin up?  The drawback of
> doing on-demand resume of the disk is that you incur the full
> resume latency right when you need the data.  System resume is a
> strong hint to warm the disks back up, and they will go back to
> sleep if unused.

It isn't a strong hint to warm the disks back up at all.  You *may*
access *a* disk soon after resume, then again, you may not.  Either
way, it isn't good to spin up *all* disks after a resume only to have
them stop again after a few minutes when they aren't accessed.  It
puts needless wear and tear on disks.

> Of course it reduces the power savings if dpm_suspend/resume is a 
> frequent occurrence.  However, are systems that make aggressive use
> of system suspend shipping with rotating media, or do they ship
> with disks that are cheap to resume?  If suspend is not frequent I
> wonder if it is worth the trouble/latency cost to keep the disk(s)
> asleep.

The vast majority of systems still use HDD; SSD isn't *that* popular.
 Also there is the power savings of leaving the disk in standby when
there is no need to "spin" it up, which while fast on an SSD, does
still increase power consumption and so should be avoided.

In any case, this will have no affect for most people since ATA disks
spin up on their own by default.  In my case, I have a backup disk
that I rarely access so I enabled power up in standby on the disk and
don't want the kernel starting and stopping it every time I resume.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS2ZdsAAoJEI5FoCIzSKrwsm0H/3JyAGvgRF2GWZquo7o+z9Mr
dUpkKfEvWpP5ZbrM+aJ6pJ6CUNABjpq4U+kjrEQ+KdydpStSokOLWPlwxBQbTm6R
oz9SAfBofZJHTPa2Jzxadh6atHSSzTg8HOQBmJ5aVU0gGOJR5wo3b8ddSAEBAXLH
NftNMwqOxgvrqG3GMmN1aAJV5qAXjJe1itAfnTfvbfBjrBqI15aIDCDXom+a5zj9
wUO7tuaoB+O3S5lI4eaeY5VIQrh5AbaozJST2s4Nzch9T/Ki5LEDDCVooUaQ+aU2
lEfJZbSMttD+J/SiTLnPoIPxEe72c7JcemjE0r7aPqLeE8AZHYrylttvIHIIStA=
=It+N
-----END PGP SIGNATURE-----
