From: Olaf Kirch <olaf.kirch@oracle.com>
Subject: Re: iSCSI fun in 2.6.21-rc6
Date: Wed, 18 Apr 2007 21:02:41 +0200
Message-ID: <200704182102.42805.olaf.kirch@oracle.com>
References: <200704181622.16171.olaf.kirch@oracle.com> <46263B7D.5090200@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:23865 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993031AbXDRTD0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 15:03:26 -0400
In-Reply-To: <46263B7D.5090200@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Wednesday 18 April 2007 17:38, Mike Christie wrote:
> Could you send the trace? It is weird that we would get a storm of data
> out commands for a IO that was only 4096 bytes (assuming part of the log
> did not get cut off and the above line is the last one).

It turns out max_xmit_dlength was 0, hence it kept looping
forever in an attempt to chop a 4096 byte payload into an
infinite number of 0-sized pieces :-)

It turns out there was an old iscsid in $PATH that spoke an
older netlink dialect, so any parameters set by iscsid never
reached the iscsi transport, and the connection essentially went
unconfigured.

So, how about some consistency checks prior to connecting?
I'll submit a patch if you'd be willing to consider it.

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
