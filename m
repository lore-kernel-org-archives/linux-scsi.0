From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: iSCSI fun in 2.6.21-rc6
Date: Wed, 18 Apr 2007 17:19:31 -0400
Message-ID: <46268B63.8000201@cs.wisc.edu>
References: <200704181622.16171.olaf.kirch@oracle.com> <46263B7D.5090200@cs.wisc.edu> <200704182102.42805.olaf.kirch@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49806 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992838AbXDRWTU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Apr 2007 18:19:20 -0400
In-Reply-To: <200704182102.42805.olaf.kirch@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: linux-scsi@vger.kernel.org

Olaf Kirch wrote:
> On Wednesday 18 April 2007 17:38, Mike Christie wrote:
>> Could you send the trace? It is weird that we would get a storm of data
>> out commands for a IO that was only 4096 bytes (assuming part of the log
>> did not get cut off and the above line is the last one).
> 
> It turns out max_xmit_dlength was 0, hence it kept looping
> forever in an attempt to chop a 4096 byte payload into an
> infinite number of 0-sized pieces :-)
> 
> It turns out there was an old iscsid in $PATH that spoke an
> older netlink dialect, so any parameters set by iscsid never
> reached the iscsi transport, and the connection essentially went
> unconfigured.
> 
> So, how about some consistency checks prior to connecting?
> I'll submit a patch if you'd be willing to consider it.
> 

Ok send it. I added checks in userspace to make sure we got valid input
from users. This is in the svn code. In the kernel I only added minimal
checking for invalid burst length settings we could get from some
targets iscsi_conn_start. In the kernel I would add on to them.
