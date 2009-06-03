From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: blk_abort_queue on failed paths?
Date: Wed, 03 Jun 2009 16:39:09 -0500
Message-ID: <4A26ED7D.1010203@cs.wisc.edu>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Mike Anderson <andmike@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

adding linux-scsi and Mike Anderson

David Strand wrote:
> After updating to kernel 2.6.28 I found that when I performed some
> cable break testing during device i/o, I would get unwanted device or
> host resets. Ultimately I traced it back to this patch:
> 
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.29.y.git;a=commit;h=224cb3e981f1b2f9f93dbd49eaef505d17d894c2
> 
> The call to blk_abort_queue causes the block layer to call
> scsi_times_out for pending i/o, which can (or will) ultimately lead to
> device, and/or bus and/or host resets, which of course cause all the
> other devices significant disruption.
> 

What driver were you using? I just did a work around for qla4xxx for 
this (have not posted it yet). I added a scsi_times_out handler to the 
driver so that if the IO was failed to a transport problem then the eh 
does not run.

FC drivers already use fc_timed_out, but I think that will not work. The 
FC driver could fail the IO then call fc_remote_port_delete. So the 
failed IO could hit dm-mpath.c and that could call into the 
scsi_times_out (which for fc drivers call into fc_timed_out) but the 
fc_remote_port_delete has not been done yet, so the port_state is still 
online so that kicks off the scsi eh.

For transport errors I do not think blk_abort_queue is needed anymore - 
at least for scsi drivers. For FC almost every driver supports the 
terminate_rport_io call back (just mptfc does not), so you can set the 
fast io fail tmo to make sure all IO is failed quickly. For iscsi, we 
have the replacement/recovery_timeout. And for SAS, I think there is a 
timeout or the device/target/port is deleted, right?


> What was the reason for this change? I searched through my email from
> this mailing list and could not find a discussion about it.


It seems like it would only make sense to call blk_abort_queue for maybe 
some block drivers (does cciss or dasd need it) or maybe for device 
errors. But it seems to be broken for the common multipath use cases.
