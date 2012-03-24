From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] block: Make blk_drain_queue() work for stopped queues
Date: Sat, 24 Mar 2012 18:49:33 +0000
Message-ID: <4F6E173D.9060800@acm.org>
References: <4F65E09D.6010600@acm.org> <20120318155703.GB8045@dhcp-172-17-108-109.mtv.corp.google.com> <4F663BE3.4000503@acm.org> <20120319170435.GH11069@google.com> <4F68E34F.1060502@acm.org> <CAA9_cmcZUueDCc2dZXayWDqAoggXo1+pqqjpk8VLEbk5wrtdDA@mail.gmail.com> <CAA9_cmdp7Ov7ZrCv+NEuxs9WXAk0ts7uOo2UDxBAd_feT6gPLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay03ant.iops.be ([212.53.5.218]:60126 "EHLO
	relay03ant.iops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab2CXStl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Mar 2012 14:49:41 -0400
In-Reply-To: <CAA9_cmdp7Ov7ZrCv+NEuxs9WXAk0ts7uOo2UDxBAd_feT6gPLQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Stanislaw Gruszka <sgruszka@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bartek Nowakowski <bartek.nowakowski@intel.com>, Jacek Danecki <jacek.danecki@intel.com>

On 03/21/12 03:37, Dan Williams wrote:
> On Tue, Mar 20, 2012 at 2:01 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Tue, Mar 20, 2012 at 1:06 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> [..]
>>> - Fix a null pointer dereference triggered by sd during device removal.
>> Hi Bart,
>>
>> Do you have a log of the backtrace in this case?  I'm going to put
>> this patch into our libsas/isci test environment.
> We beat on this patch pretty severely in our environment and appeared
> to only trigger a hung_task timeout when our driver / libata took too
> long to recovery for a 15 device unplug.

Thanks for testing - that's appreciated.

The null pointer dereference triggered during device removal was
originally reported by Jun'ichi Nomura. A call stack can be found here:
http://www.spinics.net/lists/linux-scsi/msg56254.html.

Regarding invoking blk_cleanup_queue() on a stopped queue: some code I
was testing could trigger this. But as far as I can see both the fc and
iSCSI transport layer code take care to unblock a queue before
destroying it, so these transports are not affected. There are other
(non-SCSI) block drivers though that can stop and restart the queue. I
haven't analyzed all of them. So I'm not sure there is currently any
upstream code that invokes blk_cleanup_queue() on a stopped queue.

Bart.
