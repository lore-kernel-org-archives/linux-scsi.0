From: "Bryan Henderson" <hbryan@us.ibm.com>
Subject: Re: /proc/scsi/map
Date: Mon, 17 Jun 2002 09:57:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFF92A995C.C87665ED-ON87256BDB.00565A27@boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


>Actually, the exact format of /proc/scsi/map is certainly something
>that can be discussed separately from the basic idea of adding a file
>that does expose the mapping of a SCSI address (CBTU) and the attached
>high level drivers.

Good.  Because there's one thing in the currently proposed format that is
wrong.  The "sg_num" column doesn't make sense -- it's a layering
violation.  The information in this column is meaningful independent of
whether the user uses  or the system has a Generic SCSI high level driver
(sg).  And the names here can be confused with device special file names
(/dev/sg5, etc) which of course the kernel knows nothing about.

The actual information given by this column is the Linux SCSI slot number
-- that elusive identifier that makes all this SCSI naming stuff hard in
the first place.  I suggest the column heading (if there is a header line
at all) be "slot" and the contents of the column be a simple decimal
number.

Users of the sg driver need to know separately that the device minor
number, and hence the N in /dev/sgN on a conventional system, is the Linux
SCSI slot number.



