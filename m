From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [dm-devel] [PATCH 2/2] dm-mpath: Allow 'default' hardware handler
Date: Tue, 03 Apr 2012 10:45:03 +0900
Message-ID: <4F7A561F.8020809@ce.jp.nec.com>
References: <1333385035-6663-1-git-send-email-hare@suse.de> <1333385035-6663-3-git-send-email-hare@suse.de> <20120402170426.GA28901@redhat.com> <4F79DCE4.9050804@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41755 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab2DCBqi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2012 21:46:38 -0400
In-Reply-To: <4F79DCE4.9050804@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org

Hi Hannes,

On 04/03/12 02:07, Hannes Reinecke wrote:
> On 04/02/2012 07:04 PM, Mike Snitzer wrote:
>> On Mon, Apr 02 2012 at 12:43pm -0400,
>> Hannes Reinecke <hare@suse.de> wrote:
>>
>>> This patch introduces a 'default' hardware handler for dm-mpath.
>>> When specifying '1 default' dm-multipath will be using the currently
>>> attached hardware handler.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>  drivers/md/dm-mpath.c |    8 ++++++--
>>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>>> index 922a338..bbf950f 100644
>>> --- a/drivers/md/dm-mpath.c
>>> +++ b/drivers/md/dm-mpath.c
>>> @@ -586,15 +586,19 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
>>>  
>>>  	if (m->hw_handler_name) {
>>>  		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
>>> +		char *hw_handler = NULL;
>>>  
>>> -		r = scsi_dh_attach(q, m->hw_handler_name);
>>> +		if (strncmp(m->hw_handler_name, "default", 6))
>>> +			hw_handler = m->hw_handler_name;
>>
>> Should be: if (strncmp(m->hw_handler_name, "default", 7))
> A-hem.
> 
> Counting by hand is at times tricky.
> I'll be sending an updated patchset.

It seems you will hit the following error in parse_hw_handler().
Or is it avoided somehow?

        request_module("scsi_dh_%s", m->hw_handler_name);
        if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
                ti->error = "unknown hardware handler type";
                ret = -EINVAL;
                goto fail;
        }

Thanks,
-- 
Jun'ichi Nomura, NEC Corporation
