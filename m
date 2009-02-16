From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/8] exofs: Kbuild, Headers and osd utils
Date: Mon, 16 Feb 2009 12:19:25 +0200
Message-ID: <49993DAD.40407@panasas.com>
References: <1234185129-31858-1-git-send-email-bharrosh@panasas.com>	<20090216131806X.fujita.tomonori@lab.ntt.co.jp>	<499928A3.60507@panasas.com> <20090216180028C.fujita.tomonori@lab.ntt.co.jp> <49992F99.1060404@panasas.com> <49993182.3010707@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:7718 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754359AbZBPKTb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Feb 2009 05:19:31 -0500
In-Reply-To: <49993182.3010707@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, avishay@gmail.com, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Boaz Harrosh wrote:
>> FUJITA Tomonori wrote:
>>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>>> Also looking
>>>> ahead I will have RAID 0, 1, 5, and 6 on objects of different devices. bio
>>>> is the perfect collector for memory information in this situation.
> 
>>> You will add such features to exofs, handling multiple devices
>>> internally?
> 
>> Multiple objects on Multiple devices, Yes.
> 
> That sort of feature does not belong in exofs, but somewhat separate. 
> Ideally we should be able to share "MD for OSD" with other OSD 
> filesystems, and the "osdblk" device that I will produce once libosd 
> hits upstream.
> 

No can do. exofs is meant to be a reference implementation of a pNFS-objects
file serving system. Have you read the spec of pNFS-objects layout? they define
RAID 0, 1, 5, and 6. In pNFS the MDS is suppose to be able to write the data
for its clients as NFS, so it needs to have all the infra structure and knowledge
of an Client pNFS-object layout drive.

But don't worry, the plans are that layout-drive and exofs will reuse all the
same library code that does all that. There will not be a single line of duplicate
code.

In fact one of the things I wanted to talk about in LSF is a generic, BIO based
(or some thing else), RAID engine, That could be used by all RAIDers in Kernel,
DM, MD, btrfs, exofs pNFS-objects, TUX3, ZFS and so on. And I don't mean just the
low level memory-pointers XOR functions, but the more higher level of memory
splitters/collectors, abstract-device lists, and RAID description structures.
(Because RAIDs can be stacked like 10, 50, and all kind of crazy things)

> 	Jeff
> 
> 
> 
> 

Boaz
