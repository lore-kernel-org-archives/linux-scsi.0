From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 07/13] target: Inline struct se_tmr_req into se_cmd
Date: Fri, 20 Jan 2012 09:44:43 -0800
Message-ID: <4F19A80B.6000902@redhat.com>
References: <1327009163-10177-1-git-send-email-agrover@redhat.com> <1327009163-10177-8-git-send-email-agrover@redhat.com> <20120120161209.GA22481@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21276 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796Ab2ATRot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2012 12:44:49 -0500
In-Reply-To: <20120120161209.GA22481@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, kiran.patil@intel.com

On 01/20/2012 08:12 AM, Christoph Hellwig wrote:
> On Thu, Jan 19, 2012 at 01:39:17PM -0800, Andy Grover wrote:
>> This saves all fabrics from calling core_tmr_alloc_req() and
>> having to check the result. The downside is se_cmd gets bigger for all
>> requests, but hopefully later patches will reduce it.
> 
> Without patches to void the overhead it's not acceptable. Fortunately
> it should be doable fairly simply by using an union for command vs
> TMR fields.

This was my thought too. We should be able to move cmd variables into a
union w/tmr struct very soon, with a low risk of introducing bugs.

-- Andy
