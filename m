From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
Date: Sun, 07 Nov 2010 11:54:22 -0500
Message-ID: <4CD6D9BE.3030206@garzik.org>
References: <20101105002409.GA21714@havoc.gtf.org> <4CD52059.7010503@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4CD52059.7010503@s5r6.in-berlin.de>
Sender: linux-ide-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/06/2010 05:31 AM, Stefan Richter wrote:
> Jeff Garzik wrote:
>> An alternate arrangement, not presented by this patch, might
>> be preferred:  in order to make it clear that queuecommand
>> locking has changed, one could s/queuecommand/queuecommand_nl/ in
>> Scsi_Host_Template, in order to guarantee that drivers are either
>> (a) upgraded or (b) broken at compile time.  Compile-time detection of
>> new locking may be desirable, and I'll volunteer to change my patch to
>> do that, if community members prefer that route instead of below.
>
> I followed only a fraction of the related discussion.  Thus I wonder why a
> renaming of scsi_host_template.queuecommand was not part of these attempts
> from the very outset.
>
> Given the choice between compile-time breakage of unconverted drivers and
> silent invalidation of potential locking assumptions at runtime, the
> preferable way forward is quite clear IMO.

I am leaning towards a rename, but wanted to see what others thought.


> (Since no coexistence period of .queuecommand and .queuecommand_nl or
> .unlocked_queuecommand is planned, how about you rename it to .queue_command?
> Follows Linux naming conventions more closely.)

To me, that name lacks a clear "locking changed" signal, for a random 
engineer who simply stumbles upon the queuecommand -> queue_command 
rename change one day.

	Jeff


