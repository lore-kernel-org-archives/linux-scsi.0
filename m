From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 03 Dec 2003 14:31:04 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujiskx3apj.fsf@chaapala-lnx2.cisco.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com>
	<03120217260300.01630@naveenb-lnx.cisco.com>
	<1070383028.2345.8.camel@mulgrave>
	<03120319364802.02505@naveenb-lnx.cisco.com>
	<1070464184.1771.33.camel@mulgrave>
	<yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
	<20031203175417.GA893@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:25134 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S261326AbTLCUbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 15:31:09 -0500
In-Reply-To: <20031203175417.GA893@beaverton.ibm.com> (Mike Anderson's
 message of "Wed, 3 Dec 2003 09:54:17 -0800")
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Wed, 3 Dec 2003, Mike Anderson outgrape:
> Clay Haapala [chaapala@cisco.com] wrote:
>> 
>> Naveen, is it intended that the iSCSI driver retry when the 0B/4705
>> is detected, or will that sense code and COMMAND ABORT be passed up
>> to the SCSI layers for retry?
>> 
>> James, et al, do the SCSI layers retry on COMMAND ABORT?
>> 
>> I don't believe the SCSI layers retry on HARDWARE ERROR -- this is
>> a difference between how Solaris and Linux operate, for example,
>> unless I am misunderstanding or have obsolete information.  --
> 
> scsi_check_sense will return NEEDS_RETRY for:
> 	- ABORTED_COMMAND
> 
> 	- NOT_READY and UNIT_ATTENTION under the expecting_cc_ua and
> 	becoming ready case.
> 
> 	- MEDIUM_ERROR
> 
> If the allowed count has not been exceeded the command will be
> retried.
> 
> -andmike

In discussions around here it was pointed out that the driver should
*not* retry on COMMAND ABORT situations, rather let the upper layers
handle it.  A retry at the driver level might be outright incorrect in
the case of tape devices, for instance.
-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
   Active dissent has been part of American government since the
         Boston Tea Party, and will be until its end.
