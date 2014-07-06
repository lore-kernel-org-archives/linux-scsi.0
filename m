From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3.15 099/139] libiscsi, iser: Adjust data_length to include
 protection information
Date: Sun, 06 Jul 2014 15:27:35 +0300
Message-ID: <53B940B7.8050204@dev.mellanox.co.il>
References: <20140628174605.352098823@linuxfoundation.org>	 <20140628174609.930049472@linuxfoundation.org>	 <1404339330.1862.69.camel@ul30vt.home> <53B48B37.4000608@cs.wisc.edu>	 <1404341555.16066.19.camel@dabdike> <20140703060548.GB17456@infradead.org>	 <1404395645.1949.2.camel@jarvis.lan> <20140703162748.GA24758@kroah.com>	 <20140703163310.GA21213@infradead.org> <1404410407.5091.9.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1404410407.5091.9.camel@jarvis>
Sender: stable-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Mike Christie <michaelc@cs.wisc.edu>, Alex Williamson <alex.williamson@redhat.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 7/3/2014 9:00 PM, James Bottomley wrote:
> On Thu, 2014-07-03 at 09:33 -0700, Christoph Hellwig wrote:
>> On Thu, Jul 03, 2014 at 09:27:48AM -0700, Greg Kroah-Hartman wrote:
>>> I copy everyone on the patch.  You were not on that patch as it doesn't
>>> look like it went through your tree at all.
>> It went through the target tree despite exclusive touching scsi
>> initiator side code.  I'm still not sure how this happened, but we
>> should take care to avoid this in the future.  In addition to this
>> regression due to a complete lack of testing it also caused various
>> merge issues.
> OK, Nic cc'd
>
> Please explain how this commit:
>
> commit d77e65350f2d82dfa0557707d505711f5a43c8fd
> Author: Sagi Grimberg <sagig@mellanox.com>
> Date:   Wed Jun 11 12:09:58 2014 +0300
>
>      libiscsi, iser: Adjust data_length to include protection information
>      
>      In case protection information exists over the wire
>      iscsi header data length is required to include it.
>      Use protection information aware scsi helpers to set
>      the correct transfer length.
>      
>      In order to avoid breakage, remove iser transfer length
>      checks for each task as they are not always true and
>      somewhat redundant anyway.
>      
>      Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
>      Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
>      Acked-by: Mike Christie <michaelc@cs.wisc.edu>
>      Cc: stable@vger.kernel.org # 3.15+
>      Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
>
>   drivers/infiniband/ulp/iser/iser_initiator.c | 34 ++++++++--------------------
>   drivers/scsi/libiscsi.c                      | 18 +++++++--------
>
> Came to go through the target tree even though it's initiator only and
> how come it was tagged for stable?

Hey James,

I think it's because of the cover-letter comment I gave in my initial 
patchset:
"Although these patches involve 3 subsystems with different maintainers 
(scsi, iser, target) I would prefer seeing these patches included together."
The set involved initiator-target wire protocol dependency.

I removed this comment in v1, v2 due to Roland's comment:
"Why? Because they break wire compatibility? I hate to say it but even 
if they're merged at the same time,
you can't guarantee that targets and initiators will be updated together."

So I guess Nic just followed up on my request in order to avoid 
wire-protocol breakage.
I assume the stable tag was there for the same reason.

Anyway, Sorry for all the fuss... I'll try to avoid such mistakes in the 
future.

Sagi.
