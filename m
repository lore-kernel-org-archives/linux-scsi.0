From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2.6.13 5/14] sas-class: sas_discover.c Discover process
 (end devices)
Date: Tue, 13 Sep 2005 19:05:15 +1000
Message-ID: <4326964B.9010503@torque.net>
References: <20050910024454.20602.qmail@web51613.mail.yahoo.com> <1126368081.4813.46.camel@mulgrave> <4325997D.3050103@adaptec.com> <20050912162739.GA11455@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:15024 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751149AbVIMJE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 05:04:58 -0400
In-Reply-To: <20050912162739.GA11455@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, ltuikov@yahoo.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Patrick Mansfield wrote:
> On Mon, Sep 12, 2005 at 11:06:37AM -0400, Luben Tuikov wrote:

<snip>

> IMO adding well known LUNs at this point to the standard added nothing of
> value, the target firmware has to check for special paths no matter what,
> adding a well known LUN does not change that. And most vendors will
> (likely) have support for use without a well known LUN. (This does not
> mean we should not support it in linux, I just don't know why this went
> into the standard.)
> 
> Using well known LUNs will be another code path that will have to live
> alongside existing ones, and will likely require further black listing
> (similar to REPORT LUN vs scanning for LUNs).

Patrick,
The technique of supporting REPORT_LUNS on lun 0 of
a target in the case where there is no such device
(logical unit) is a pretty ugly. It also indicates what
is really happening: the target device intercepts
REPORT_LUNS, builds the response and replies on behalf
of lun 0.

Turns out there are other reasons an application may want
to "talk" to a target device rather than one of its logical
units (e.g. access controls and log pages specific to
the target's transport). Well known lus can be seen with the
REPORT_LUNS (select_report=1) but there is no mechanism (that
I am aware of) that allows anyone to access them
from the user space with linux.


References at www.t10.org:
   spc4r01a.pdf  [section 8]
   bcc-r00.pdf   [bridge controller commands]

Doug Gilbert
