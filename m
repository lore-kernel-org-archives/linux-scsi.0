From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: [PATCH RFC] replace ioctl for	sysfs	take
 2
Date: Tue, 07 Sep 2004 15:40:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <413E38DB.6040408@us.ibm.com>
References: <20040907210520.0251476C56@isis.visi.com>		<413E2440.8080509@cs.wisc.edu> <1094592818.1716.159.camel@mulgrave> 	<413E2A17.80107@us.ibm.com> <1094594715.1716.169.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.103]:25261 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S268727AbUIGWox (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 18:44:53 -0400
In-Reply-To: <1094594715.1716.169.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "Scott M. Ferris" <sferris@acm.org>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, iscsi -devel <linux-iscsi-devel@lists.sourceforge.net>, David Wysochanski <davidw@netapp.com>, "Surekha.PC" <surekhap@cisco.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:

> On Tue, 2004-09-07 at 17:37, Mike Christie wrote:
> 
>>Ok. If the new magic iscsi transport specific target code handles target 
>>data like the scsi_host does for hostdata then would it be better to put 
>>our session struct in the target data? I think this also simplifies 
>>refcounting. Most session stuff makes sense hanging off the target so 
>>this might be easier, right?
> 
> 
> Possibly, but only if the way its handled would be the same on all iscsi
> initiator drivers.  Otherwise, if it's specific to the driver
> implementation, it would be in hostdata. 

Yes, ok. That is what I am striving for. By us hanging things like 
target name on the target instead of on the scsi device or scsi host 
will help us conform to other HW iscsi drivers.

  Regardless, you'd still have
> one host per one of these entities.

One host per I_T nexus/session? But I thought the only reason against 
using a single host for all nexii (ignoring the port/channel 
discussion), was that the driver would need its own refcounting.

If the target has some place for driver target data (with the common 
iscsi code going in the appropriate transport class stucts) couldn't we 
just do sometihng similar to how a scsi_device has the hostdata pointers 
and drivers seem to assume when slave_destroy is called they can just 
free what was allocated in slave_alloc. And when the driver does its 
final scsi_host_put it assumes the hostdata will get freed when all the 
handles are released. If the midlayer could provide any similar lifetime 
management functionality for targets the iscsi driver would not need any 
private structures that are refcounted internally since everything could 
fall under the host, device, or target's managemnet.

> The transport class is to abstract out common code from multiple
> drivers, so what goes in there must genuinely be common.  Even if you
> put the common session data in the target, you probably still end up
> having driver specific data in the host.


> James
> 
> 
> 

