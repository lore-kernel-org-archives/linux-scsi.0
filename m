From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for sysfs	take
 2
Date: Tue, 07 Sep 2004 14:37:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413E2A17.80107@us.ibm.com>
References: <20040907210520.0251476C56@isis.visi.com> 	<413E2440.8080509@cs.wisc.edu> <1094592818.1716.159.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:44000 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S268261AbUIGVnQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Sep 2004 17:43:16 -0400
In-Reply-To: <1094592818.1716.159.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:

> On Tue, 2004-09-07 at 17:12, Mike Christie wrote:
> 
>>>This is exactly why I ask these questions.  The iSCSI driver
>>>developers just implemented this, because they thought this is what
>>>you and Christoph were asking for.  Apparently it's not what you
>>>wanted.
>>
>>Thank you for clarifying this. So we should go back to a single linux host,
>>right? The iscsi session is an I_T nexus, so the only way to store the
>>session state in the host is to allocate a session per host.
> 
> 
> No; for iscsi, the host and target for I_T is the right thing to do.
> 
> The reason why doesn't lie in terminology or a specification, it lies in
> the code.
> 
> When the cisco-iscsi driver was first presented, it had a single host
> for everything and a huge connection management resource array hanging
> off that.  This was clearly wrong beacuse there was a huge overhead
> managing the array.  The correct approach was to make the host
> correspond to a single element of that array and use the mid-layer host
> management functions instead of home grown resource management
> functions.  Doing it this way makes both the management and presentation
> of the information more logical and the code cleaner.

Ok. If the new magic iscsi transport specific target code handles target 
data like the scsi_host does for hostdata then would it be better to put 
our session struct in the target data? I think this also simplifies 
refcounting. Most session stuff makes sense hanging off the target so 
this might be easier, right?


> James
> 
> 
> 

