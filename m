From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [linux-iscsi-devel] Re: PATCH [3/5]  qla2xxx: TCQ fixes
Date: Tue, 13 Jul 2004 20:04:34 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40F43242.1060703@us.ibm.com>
References: <20040712140558.GA6961@praka.san.rr.com>	<1089668486.1799.62.camel@mulgrave>  <40F32AAE.5070508@us.ibm.com> <1089728842.2055.11.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:6119 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265729AbUGMTHo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jul 2004 15:07:44 -0400
In-Reply-To: <1089728842.2055.11.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-iscsi-devel@lists.sourceforge.net, Krishna Murthy <krmurthy@cisco.com>

James Bottomley wrote:

> On Mon, 2004-07-12 at 19:19, Mike Christie wrote:
> 
>>Depending on the API, we might be able to use it for the linux-iscsi 
>>driver. Today the driver uses scsi_activate_tcq(), but does not uses the 
>>tag numbers. Instead it uses its own initiator task tags values for 
>>session wide identifiers, becuase we need tag values for iscsi ops. For 
>>example if we need to send a ping how should we get a tag from the mid 
>>layer? Or maybe becuase there are some transport specific tag values 
>>should we use someting else or keep it in the driver?
> 
> 
> The only clean way I can see of doing it is to store the tags map in the
> host structure.  That will pretty much require one host per transport
> end point.  Is the iSCSI driver moving in that direction?

Unfortunately not, but it could be done. The iSCSI requirement is only 
that every iSCSI task has a tag which has the gaurantee of it being 
unique across a session, so if the host value was unique across all 
request_queues then it would still be safe to use.

The problem is that we need a tag for every iscsi task, so this includes 
untagged commands and logins (before there is a device/request_queue). 
Should we just keep it in the driver, or could the request queue have 
functions pointers so someone could override the block layer tag 
fucntions? What I am also thinking is that instead of passing the block 
layer request_queue (with the queue always allocating and setting the 
map) as an argument, it might be possible to make the tag functions 
some-new-map-structure based.

Bascially, the host could allocate this map and it could be initialized 
to have start_tag/end_tag functions that are possibly transport specific 
(iSCSI has some magic tag values, but I do not know about spi or fc). 
this way if it needed to allocate tags before a queue is present (for 
logins for iscsi's case) then it could do so (this also means the tag 
must have some new structure becuase for normal populate_msg usage the 
msg is dependant on request properties). Then when blk_init_queue is 
finally called it can inherit the existing map structure with its 
function pointers.

Or should we just ignore whatever SCSI or the block layer gives us and 
keep it in the driver?

