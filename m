From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 0/32] Refcounts and rbtrees to increase luns above 255
Date: Tue, 17 Dec 2013 09:10:32 -0800
Message-ID: <52B08588.6080102@redhat.com>
References: <1386979160-6928-1-git-send-email-agrover@redhat.com> <1387231426.20247.260.camel@haakon3.risingtidesystems.com> <52B02D13.9000207@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3LQRKg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Dec 2013 12:10:36 -0500
In-Reply-To: <52B02D13.9000207@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 12/17/2013 02:53 AM, Hannes Reinecke wrote:

> But the LUN addressing improvements is interesting.
>
> What I found during development of the 64bit LUN patchset is
> that the target core stuff has a very rudimentary LUN handling:
> - 256 LUNs only
> - LUNs are kept in a static array
> - Identity mapping between LUN numbers and array indices.
>
> What I _really_ would like to have is to do away with the
> LUN array, and introduce a dynamic LUN mapping.
> This will allow us to easily implement different LUN enumeration
> methods (Think of hierarchical LUNs ...).
>
> Also the assumption that a static array is always faster for
> lookup than a linked list is wrong.
> A static array is faster if the entire array fits into the processor
> cache. If it doesn't we basically have an immediate
> cache miss _for every array access_.
> Then linked lists etc really are faster.
>
> So do not take things at face value; only real measurements
> count here.

Yeah, seems true. So do either of you have any tips for how best to do 
measurements?

BTW I was looking a little more and am now inclined to think a radix 
tree is more suitable than rbtree. It seems ideally suited for our case: 
want to lookup by an index (i.e. LUN) that is usually a small integer, 
very fast lookups, yet also can grow and still be space-efficient.

Regards -- Andy
