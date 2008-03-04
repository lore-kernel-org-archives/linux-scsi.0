From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [RFC PATCH 1/3] block: add rq->complete_io hook for request stacking
Date: Tue, 04 Mar 2008 15:02:22 -0500
Message-ID: <47CDAACE.3090203@ce.jp.nec.com>
References: <20080215.172727.39155014.k-ueda@ct.jp.nec.com>	<47CC2652.1080601@suse.de> <20080303.140427.39152329.k-ueda@ct.jp.nec.com> <47CD03DE.3010703@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323AbYCDUCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Mar 2008 15:02:48 -0500
In-Reply-To: <47CD03DE.3010703@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, michaelc@cs.wisc.edu

Hi Hannes,

Hannes Reinecke wrote:
> Kiyoshi Ueda wrote:
>> I'm thinking about an idea come from Mike and Jens after the session
>> at LSF'08:
>>   o stacking driver clones both bio and request and uses
>>     bio->bi_end_io and rq->end_io
>>   o stacking driver uses blk_complete_request() in rq->end_io
>>     so that stacking driver can work without queue lock
>> With this idea, we don't need to add the new hook to request,
>> and we can use request stacking on drivers using __blk_end_request().
>>
> Huh? I can't really imagine how this should work. If you start using
> bio->bi_end_io() for stacking usage you'll end up with doing weird thing
> with the bios ... Can you elaborate a bit more here?

Cloned bio's bi_end_io() can check the error.

For successful I/O, it calls something equivalent to
end_that_request_first() for the original request,
that may eventually complete the original bio and
notify the submitter.

For error, it can decide not to complete the original bio
and record the error information.

When the clone request is finally completed and rq->end_io() is
called, stacking driver can check the recorded error information
and decide whether it should take any action or just complete
the original request by blk_complete_request().

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation of America
