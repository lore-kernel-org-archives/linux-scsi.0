From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH 07/14] scsi_transport_srp: Add transport layer error handling
Date: Mon, 17 Jun 2013 12:13:41 +0200
Message-ID: <51BEE155.1000609@profitbricks.com>
References: <51B87501.4070005@acm.org> <51B8777B.5050201@acm.org> <51BA20ED.6040200@mellanox.com> <51BB1857.7040802@acm.org> <51BB5A04.3080901@mellanox.com> <51BC3945.9030900@acm.org> <51BEAA40.9070908@suse.de> <51BEB4FF.9000607@acm.org> <51BEB770.9030305@suse.de> <51BEBAEA.4080202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51BEBAEA.4080202-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Bottomley <jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 17.06.2013 09:29, Bart Van Assche wrote:
> On 06/17/13 09:14, Hannes Reinecke wrote:
>> On 06/17/2013 09:04 AM, Bart Van Assche wrote:
>>> I agree that the value of fast_io_fail_tmo should be kept small.
>>> Although as you explained changing the SCSI device state into
>>> SDEV_BLOCK doesn't help for I/O that has already been queued on a
>>> failed path, I think it's still useful for I/O that is queued after
>>> the fast_io_fail timer has been started and before that timer has
>>> expired.
>>
>> Why, but of course.
>>
>> The typical scenario would be:
>> -> detect link-loss
>> -> call scsi_block_request()
>> -> start dev_loss_tmo and fast_io_fail_tmo
>>
>> -> When fast_io_fail_tmo triggers:
>>     -> Abort all outstanding requests
>>
>> -> When dev_loss_tmo triggers:
>>     -> Abort all outstanding requests
>>     -> Remove/disable the I_T nexus
>>     -> call scsi_unblock_request()
>>
>> However, if and whether multipath detects SDEV_BLOCK doesn't
>> guarantee a fast failover; in fact is was only added rather recently
>> as it's not a big win in most cases.
> 
> Even if setting the state SDEV_BLOCK doesn't help much with improving
> failover time, it still has the advantage over using
> scsi_block_requests() that it can be overridden by a user via sysfs.

In my opinion that SDEV_BLOCK can help the reconnect. The only reason
for high fast_io_fail_tmo is that you don't use multipath at all and
hope that the connection becomes available again before that timeout.
You place the reconnects in between so that there is a chance that the
reconnect succeeds and the transport layer error work can be canceled.

But I have to look at all of your patches first to see how you
implemented the big picture.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
