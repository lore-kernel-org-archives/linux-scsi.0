From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: [PATCH 00/11] First pass at merging Bart's HA work
Date: Wed, 28 Nov 2012 05:10:32 +1100
Message-ID: <CAOzFzEg7ytycGcLqN4rOyLBUMC_spw+qaHxfHRzNCn4eOH8cUA@mail.gmail.com>
References: <cover.1353903448.git.dillowda@ornl.gov>
	<50B4EBA3.7070400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50B4EBA3.7070400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 28 November 2012 03:34, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 11/26/12 05:44, David Dillow wrote:
>>
>> Here is a first, UNTESTED, pass at preparing a merge of Bart's SRP HA
>> work to upstream. It is not complete, as I have not yet added the
>> transport layer error handling and related patches. It is also currently
>> missing the patch to maintain a single connection for an I_T nexus.
>>
>> I swapped Ishai's code to recreate QP/CQs for each connection, as that
>> adds recovery from fatal hardware errors, and reduces the code needed to
>> avoid stale completions. Similarly, Vu's patch slightly reduces reconnect
>> times.
>>
>> Target blocking/unblocking hasn't been added from Bart's patch that
>> removes the SRP_TARGET_CONNECTING state; I think it is probably the right
>> thing to do, but want to think it over a bit more.
>>
>> Similarly, I'm looking for a clean way to start the reconnection effort
>> as soon as we get an error through the CQ -- we know that any pending
>> commands are lost to us at that point, so we should be able to kick them
>> back upstream quickly. This should allow multipath to reissue them on one
>> of the remaining good paths.
>>
>> This series compiles, but is otherwise UNTESTED. I'll be working on that
>> over the next few days, with an eye on getting as much of Bart's work
>> into 3.8 as possible.
>
>
> Thanks Dave for doing all this work. A reworked and retested patch series
> that should address all comments that have been posted so far can be found
> here: http://github.com/bvanassche/linux/srp-ha. I can repost the entire
> patch series if you want. The changes compared to the previous time this
> patch series was posted are:
> * Integrated Ishai's and Vu's patches for recreating the QP and the CQs.
> * Took advantage of SCSI core changes that make scsi_remove_host() wait
>   until device removal and error handling finished (will post these
>   shortly).
>
> Bart.

This is grreat news, would be really good to see this merged for 3.8

Bart - I will test the new srp-ha branch in our environment.

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
