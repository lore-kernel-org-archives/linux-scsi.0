From: Jeremy Filizetti <jeremy.filizetti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: SRP over high-latency IB link
Date: Sun, 13 Nov 2011 11:52:47 -0500
Message-ID: <4EBFF5DF.6050303@gmail.com>
References: <CAO+b5-oo2oUz9GOneM+eoawjgCsdMGSFghrKRkcmVbhmcnm3-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oo2oUz9GOneM+eoawjgCsdMGSFghrKRkcmVbhmcnm3-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

You don't really mention what your seeing for performance or the layout
of your demo (number of LUNs, number target ports your connected to,
file system used, etc).  In the past over 10 Gbps links I haven't had
much success with "good performance" at far lower distances (~1200 fiber
miles).  I'd guess 7000 fiber miles is around ~180 ms RTT latency and
given a 40 Gbps link you have a pretty high BDP for good performance.

Each LUN is going to have limits on the number of commands outstanding
to it.  Your IO size is probably less then 1020 kb unless your using a
new SRP initiator and supporting target.   The number of queue pairs
used will be equivalent to the number of target ports used.  The block
device read ahead might need tuning.  All of these will be factors in
affecting your throughput.

There is a reason we rely on Lustre to handle WAN streaming IO instead
of using SRP.  The performance for sequential IO is pretty reasonable
with read-ahead and write-behind.  You also get the benefit of
read-ahead on the file instead of the block devices so you should have
all cache hits instead of high latency cache misses.

Jeremy

On 11/13/2011 07:12 AM, Bart Van Assche wrote:
> On Sun, Nov 13, 2011 at 5:18 AM, Bill Boas <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
>> At SC we are running a video streaming demo across a 7000 mile fiber
>> distance using IB extension boxes from Bay Microsystems at 40 Gbps. The
>> video streaming app uses SRP to transmit the streams across this long
>> distance link. Performance is not all what we would have hoped. We think
>> that because SRP uses RC mode between initiator and target that it is the RC
>> behavior over this distance that is impacting performance. Are any of you
>> aware of an SRP implementation that uses UC mode.
> What numbers are reported by ib_write_bw and ib_write_lat for that IB
> link ? Do these numbers match the bandwidth and latency requirements
> of the video playback application ? Which operating system was the
> initiator system running ? How was read-ahead configured ? I'm not
> sure it would be a good idea to try to run SRP over UC.
>
> Bart.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
