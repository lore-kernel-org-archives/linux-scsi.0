From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/] OSD changes for 2.6.31
Date: Wed, 10 Jun 2009 17:28:58 +0300
Message-ID: <4A2FC32A.2040201@panasas.com>
References: <4A197CB5.60709@panasas.com>  <4A2F7896.2070905@panasas.com> <1244642618.4109.3.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:17642
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755220AbZFJO26 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 10:28:58 -0400
In-Reply-To: <1244642618.4109.3.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>, Jeff Garzik <jeff@garzik.org>, Al Viro <viro@ZenIV.linux.org.uk>

On 06/10/2009 05:03 PM, James Bottomley wrote:
> On Wed, 2009-06-10 at 12:10 +0300, Boaz Harrosh wrote:
>> On 05/24/2009 07:58 PM, Boaz Harrosh wrote:
>>> These are the accumulated osd patches for the next merge window,
>>> Linux 2.6.31. 
>>>
>>> Most of these patches are a repost rebased on latest scsi-misc
>>>
>>> List of patches:
>>> [PATCH 01/10 resend] libosd: OSD2r05: Additional command enums                                                        
>>> [PATCH 02/10 resend] libosd: OSD2r05: Attribute definitions
>>> [PATCH 03/10 resend] libosd: Better printout of OSD target system information
>>> [PATCH 04/10 resend] libosd: osd_req_{read,write}_kern new API
>>> [PATCH 05/10 resend] libosd: Let _osd_req_finalize_data_integrity receive number of out_bytes
>>> [PATCH 06/10 resend] libosd: osd_req_{read,write} takes a length parameter
>>>
>>>    These are a resend. The last 2 patches are important for supporting Jeff's
>>>    osdblk driver. (The first 4 are old patches that thier time has come)
>>>
>>> [PATCH 07/10] libosd: Define an osd_dev wrapper to retrieve the request_queue
>>>    Simple wrapper
>>>
>>> [PATCH 08/10] osduld: use filp_open() when looking up an osd-device
>>>
>>>     This patch was inspired by Al Viro. It uses the in-kernel open-file
>>>     mechanism to look up the osd char-device for Kernel users like exofs
>>>     and later pNFS-Objlayout.
>>>     It was heavily tested and works well.
>>>     It fixes the problem we had before, of need to open+close a file handle
>>>     on the osd-char-device before mounting an exofs.
>>>     Please review
>>>
>>> [PATCH 09/10] libosd: Use REQ_QUIET requests.
>>>     Recent scsi_lib changes, caused a dmesg span in exofs+osd regular use,
>>>     because of the way we routinely receive a recovered scsi sense. Recently, for
>>>     reason I could not find, this condition started to print messages at:
>>>        scsi_io_comlition:778 (look for "== RECOVERED_ERROR")
>>>     Use of a REQ_QUIET flag is needed to silence these prints.
>>>     OSD has it's own prints for scsi-sense returns, when needed.
>>>
>>> [PATCH 10/10] osd: Remove out-of-tree left overs
>>>
>> The merge window has risen upon us and these patches are still not
>> in scsi-misc. (Luckily they where in linux-next through the osd tree)
>> If these will not go into 2.6.31 I'm very screwed, with the pNFS stuff,
>> Please reconsider?
> 
> I didn't reject them ... they just contain non scsi bits in fs/exofs.
> However, since they're tightly entangled, I suppose the scsi-misc tree
> will do ... just testing them out now.
> 

Yes there is a comment about that in the patch commit log. The API
changed and I changed all in-tree users in one patch. (Since
I'm the maintainer of exofs, then naturally the Ack). I made
sure it will not conflict.

Some exofs patches are post-merge pending once scsi-misc will get
in.

> James
> 
> 

Thanks James
Boaz
