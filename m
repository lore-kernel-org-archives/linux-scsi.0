From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] scsi: storvsc: Fix a race in sub-channel creation that
 can cause panic
Date: Mon, 26 Nov 2018 00:39:19 -0500
Message-ID: <20181126053919.GB34679@sasha-vm>
References: <20181126002617.7398-1-kys@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181126002617.7398-1-kys@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kys@microsoft.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, James.Bottomley@HansenPartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com, martin.petersen@oracle.com, hare@suse.de, Dexuan Cui <decui@microsoft.com>, stable@vger.kernel.org, Long Li <longli@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Nov 26, 2018 at 12:26:17AM +0000, kys@linuxonhyperv.com wrote:
>From: Dexuan Cui <decui@microsoft.com>
>
>We can concurrently try to open the same sub-channel from 2 paths:
>
>path #1: vmbus_onoffer() -> vmbus_process_offer() -> handle_sc_creation().
>path #2: storvsc_probe() -> storvsc_connect_to_vsp() ->
>	 -> storvsc_channel_init() -> handle_multichannel_storage() ->
>	 -> vmbus_are_subchannels_present() -> handle_sc_creation().
>
>They conflict with each other, but it was not an issue before the recent
>commit ae6935ed7d42 ("vmbus: split ring buffer allocation from open"),
>because at the beginning of vmbus_open() we checked newchannel->state so
>only one path could succeed, and the other would return with -EINVAL.
>
>After ae6935ed7d42, the failing path frees the channel's ringbuffer by
>vmbus_free_ring(), and this causes a panic later.
>
>Commit ae6935ed7d42 itself is good, and it just reveals the longstanding
>race. We can resolve the issue by removing path #2, i.e. removing the
>second vmbus_are_subchannels_present() in handle_multichannel_storage().
>
>BTW, the comment "Check to see if sub-channels have already been created"
>in handle_multichannel_storage() is incorrect: when we unload the driver,
>we first close the sub-channel(s) and then close the primary channel, next
>the host sends rescind-offer message(s) so primary->sc_list will become
>empty. This means the first vmbus_are_subchannels_present() in
>handle_multichannel_storage() is never useful.
>
>Fixes: ae6935ed7d42 ("vmbus: split ring buffer allocation from open")
>Cc: stable@vger.kernel.org
>Cc: Long Li <longli@microsoft.com>
>Cc: Stephen Hemminger <sthemmin@microsoft.com>
>Cc: K. Y. Srinivasan <kys@microsoft.com>
>Cc: Haiyang Zhang <haiyangz@microsoft.com>
>Signed-off-by: Dexuan Cui <decui@microsoft.com>
>Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Just a heads-up: ae6935ed7d42 ("vmbus: split ring buffer allocation from
open") was merged in the 4.20 merge window, so this fix won't actually
apply to any of the current stable trees.

However, it's good to have tags (fixes + cc: stable) here since this fix
might end up (for whatever reason) getting merged only for 4.21, which
will then make these tags relevant.

--
Thanks,
Sasha
