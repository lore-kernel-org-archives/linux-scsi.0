From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 3 Dec 2003 09:54:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031203175417.GA893@beaverton.ibm.com>
References: <03120118001300.08627@naveenb-lnx.cisco.com> <03120217260300.01630@naveenb-lnx.cisco.com> <1070383028.2345.8.camel@mulgrave> <03120319364802.02505@naveenb-lnx.cisco.com> <1070464184.1771.33.camel@mulgrave> <yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:23289 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S265081AbTLCRvF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 12:51:05 -0500
Content-Disposition: inline
In-Reply-To: <yquj7k1d4ywe.fsf@chaapala-lnx2.cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Clay Haapala <chaapala@cisco.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Clay Haapala [chaapala@cisco.com] wrote:
> 
> Naveen, is it intended that the iSCSI driver retry when the 0B/4705 is
> detected, or will that sense code and COMMAND ABORT be passed up to the
> SCSI layers for retry?
> 
> James, et al, do the SCSI layers retry on COMMAND ABORT?
> 
> I don't believe the SCSI layers retry on HARDWARE ERROR -- this is a
> difference between how Solaris and Linux operate, for example, unless
> I am misunderstanding or have obsolete information.
> -- 

scsi_check_sense will return NEEDS_RETRY for:
	- ABORTED_COMMAND

	- NOT_READY and UNIT_ATTENTION under the expecting_cc_ua and
	becoming ready case.

	- MEDIUM_ERROR

If the allowed count has not been exceeded the command will be retried.

-andmike
--
Michael Anderson
andmike@us.ibm.com

