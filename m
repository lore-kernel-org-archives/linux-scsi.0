From: "Sachin Mhatre \(smhatre\)" <smhatre@cisco.com>
Subject: RE: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Thu, 13 Nov 2003 20:00:11 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <008d01c3a9f2$a56e60c0$8f074d0a@apac.cisco.com>
References: <20031027153932.A16679@infradead.org>
Reply-To: <smhatre@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:2377 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264298AbTKMOa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 09:30:29 -0500
In-Reply-To: <20031027153932.A16679@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

Hi,
	We need the md5 and crc functions from the user level as well as
from the kernel. The crypto API and the CRC32 kernel  library functions
can solve the problem of md5 and crc computation in the kernel. But its
not possible to use these APIs from the user level. One way could be to
use system calls. But wouldn't that make the code cumbersome?

Thanks,
Sachin

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Monday, October 27, 2003 9:10 PM
To: Krishna Murthy
Cc: linux-scsi@vger.kernel.org; davmyers@cisco.com
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1


On Thu, Oct 23, 2003 at 05:34:10PM +0530, Krishna Murthy wrote:
> Hi,
> 	Linux iSCSI driver 4.0.0.1 (linux-iscsi-4.0.0.1.tgz) is
available at
> 
> http://sf.net/projects/linux-iscsi/

Here's a list of a few comments I've come up with.  I haven't yet looked
at the data structurws much, but it seems there's a complete lack of
refcounting.  Also there's lots of comments were ysou complain about
scsi midlayer misbehaviour or bugs - please submit patches or submit
workarounds when you encounter them, that's what open source is all
about!

Also the same question that went to the unh folks goes to you:  why do
you think your implementation is better than theirs and why do you think
cooperation on one iscsi stack is impossible.

here's the list:


highlevel:
	- kill md5.c and iscsi-crc.c and use common cryptoapi
	md5 / common crc code instead.
	- please kill you thousands of atoi/aton reimplementations
	and look for proper linux functions like simple_strtoul.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html

