From: "Tony Battersby" <tonyb@cybernetics.com>
Subject: RE: Writing to tape from C system calls
Date: Fri, 12 Dec 2003 10:14:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03Dec12.101354est.332511@cyborg.cybernetics.com>
References: <035701c3c0ac$f1ccbae0$aa00a8c0@ASTERIX>
Reply-To: <tonyb@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host02.cybernetics.com ([206.246.200.18]:60681 "EHLO
	cybernetics.com") by vger.kernel.org with ESMTP id S265261AbTLLPOe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Dec 2003 10:14:34 -0500
In-Reply-To: <035701c3c0ac$f1ccbae0$aa00a8c0@ASTERIX>
List-Id: linux-scsi@vger.kernel.org
To: 'Ujval Lodha' <ujval@gdc-tech.com>, linux-scsi@vger.kernel.org

> When I write to it at any block that block becomes the last
> block on the device. I am unable to seek to any block after
> that on the tape.

> Is this normal? Is it not possible to use the tape device -
> and modify data at any block by seeking to it and writing?

It is completely normal.  All modern tape drives work this way.  Unlike
a disk drive, a block address on tape does not correspond to a
predefined location on the medium.  The tape drive (re)formats the
medium while it writes, which invalidates anything past the last written
point on tape.  So, you can seek/read/write the tape from the beginning
of the tape up to just after the last written block, but the tape medium
after that point is not considered to be formatted and cannot be used
(again) until it is reached while writing.

As you observed, writing to tape in the middle of valid data will cause
the contents of the tape to be truncated at the write point.  That's the
way the technology works.  There is no way to update a block in the
middle of the valid data without losing everything that comes after it.
The only way around this is to use multiple partitions, but not all tape
drives support partitions, and changing partitions takes time.

> Is there some source of information where I can read about
> programming tape devices from C? So far, I havent been able
> to find one.

man st

But that's pretty low-level, of course.

Anthony J. Battersby
Cybernetics

