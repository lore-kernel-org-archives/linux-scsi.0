From: Matt <mdm@iinet.net.au>
Subject: Re: SCSI oops on USB disconnect, was: Issues with xHCI and USB 3.0
Date: Sun, 20 Nov 2011 15:52:20 +1100
Message-ID: <4EC88784.7020901@iinet.net.au>
References: <4EA54EBF.80905@iinet.net.au> <20111025072957.GA5821@xanatos> <4EA68418.9000504@iinet.net.au> <20111025113458.GA4590@xanatos> <4EA6B3FC.9010808@iinet.net.au> <20111027112831.GB4790@xanatos> <20111102190224.GB29845@xanatos> <4EB24040.1060208@iinet.net.au> <20111103202258.GA3585@xanatos> <4EB32928.6000901@iinet.net.au> <20111104144840.GA3079@xanatos> <CAO+b5-oY8qnhL=6tR2TO3HC1NJKEx_2x4SOTqFW5ZSnbf48Urg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:54773
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235Ab1KTEw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Nov 2011 23:52:29 -0500
In-Reply-To: <CAO+b5-oY8qnhL=6tR2TO3HC1NJKEx_2x4SOTqFW5ZSnbf48Urg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Matt <mdm@iinet.net.au>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On 18/11/2011 10:31 PM, Bart Van Assche wrote:
>
>> [  325.497799] Call Trace:
>> [  325.499007]  [<ffffffff8122c4eb>] ? blk_peek_request+0x3f/0x1d2
>> [  325.500236]  [<ffffffff813148e3>] scsi_request_fn+0x48/0x409
>> [  325.501461]  [<ffffffff811163d4>] ? kmem_cache_free+0x72/0xab
>> [  325.502685]  [<ffffffff81227338>] __blk_run_queue+0x1b/0x1d
>> [  325.503906]  [<ffffffff8131428a>] scsi_run_queue+0x1c0/0x22d
>> [  325.505126]  [<ffffffff813153d4>] scsi_next_command+0x39/0x49
>> [  325.506337]  [<ffffffff81315895>] scsi_io_completion+0x45d/0x4d7
>> [  325.507552]  [<ffffffff8130dc14>] scsi_finish_command+0xe4/0xed
>> [  325.508761]  [<ffffffff81312a3e>] scsi_eh_flush_done_q+0xfc/0x124
>> [  325.509971]  [<ffffffff8131310e>] scsi_error_handler+0x383/0x591
>> [  325.511175]  [<ffffffff81312d8b>] ? scsi_eh_get_sense+0x183/0x183
>> [  325.512380]  [<ffffffff81072a17>] kthread+0x84/0x8c
>> [  325.513580]  [<ffffffff814b01f4>] kernel_thread_helper+0x4/0x10
>> [  325.514782]  [<ffffffff81072993>] ? kthread_worker_fn+0x148/0x148
>>
>> Hopefully the SCSI folks will be able to help you with that.  James?
> Might be the same issue as this one:
> http://www.spinics.net/lists/linux-scsi/msg55497.html.
>
> Bart.
>

Thanks Bart -- your suggested patch fixed the oops I was experiencing.

However I am still experiencing some much more minor problems with the 
attaching of these disks.  I experience a significant pause (some sort 
of timeout perhaps?) when initially accessing the disks which seems to 
take about thirty to sixty seconds.  The delay is coupled with dmesg 
output similar to:

[  254.478693] xhci_hcd 0000:03:00.0: WARN: Stalled endpoint
[  254.478984] sd 5:0:0:1: [sdc] No Caching mode page present
[  254.479016] sd 5:0:0:1: [sdc] Assuming drive cache: write through
[  254.479050] sd 5:0:0:1: [sdc] Attached SCSI disk
[  255.549968] hub 3-0:1.0: hub_suspend
[  255.549976] usb usb3: bus auto-suspend
[  284.618187] usb 4-1: reset SuperSpeed USB device number 2 using xhci_hcd
[  284.628892] xhci_hcd 0000:03:00.0: WARN: short transfer on control ep
[  284.628908] xhci_hcd 0000:03:00.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff880135f88900
[  284.628911] xhci_hcd 0000:03:00.0: xHCI xhci_drop_endpoint called 
with disabled ep ffff880135f88940
[  284.629867] usb 4-1: Successful Endpoint Configure command

The full dmesg is uploaded here: http://pastebin.com/raw.php?i=39B9mdPR

(Sarah: I disabled the verbose xHCI debugging on my last kernel compile 
-- please let me know if you require it to be switched on again)

After a few resets, the drives become active and will happily transfer 
at approximately 100MB/sec which I'm quite comfortable with.

I'm not sure to whom I should pose the question as it's a storage 
question over USB so please forgive the crosspost.

As always, I am happy to debug and retrieve whatever information is 
required to investigate the issue; just let me know what you need.

Thanks once again.

Cheers,

Matt.





