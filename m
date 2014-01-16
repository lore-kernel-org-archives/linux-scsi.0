From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Thu, 16 Jan 2014 13:39:26 -0500
Message-ID: <52D8275E.5060100@ubuntu.com>
References: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:33940 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaAPSj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 13:39:28 -0500
In-Reply-To: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 1/16/2014 11:59 AM, Alan Stern wrote:
> Since the START-STOP and TEST UNIT READY (or REQUEST SENSE or
> whatever) commands are likely to take a long time, they should all
> be carried out asynchronously with respect to the resume procedure.
> I don't know what the best way is to implement this.  But it is
> important to guarantee that in the RPM_ACTIVE case, the START-STOP
> command gets sent to the disk before any other commands.  (This
> isn't an issue in the RPM_SUSPENDED case, as the block layer will
> prevent requests being sent out unless they have the REQ_PM flag
> set.)

We could avoid that problem by having the resume_early issue the start
command any time it leaves it in RPM_ACTIVE.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJS2CdeAAoJEI5FoCIzSKrw9h4H/0P3aefB4/ST10CAtJK0LHl4
iyqu1dXrkLgC3Q827aj+dr5rjjrE1J3oid80/bHyhXA+GB379GU77Tp9IN7XiEhj
KxcT3rU/7+ybATDmf8sx96/uuDSOgmyQ8cBw24YCEgobwraBG+K0APgvsKCAnOwF
dIq+mamjFBXDXzzfzLFOyM+VTZ0nY4iTcnXW5qAB8sk97Jt3ksfZ7zABfcU3ih4F
SqfLu25UIMNV1BYMxwo13Qf3t7j3fEmWSAXOB1/HaaERIxih/lCJc1G5oH7uTAkE
Wco6Wd7uEDErJKwXb4tSQ1nFIFoswFBbCpl553TB1YRtAxBWgFGVUWez4U5q/7o=
=6Ohk
-----END PGP SIGNATURE-----
