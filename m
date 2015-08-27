From: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH v1 14/15] scsi: ufs: commit descriptors before setting the doorbell
Date: Thu, 27 Aug 2015 12:02:46 -0500
Message-ID: <CAL_JsqL9+oVFu3Gty1UaCLRR3P4jfDZKaf5oEkfMjp=-J5TQdw@mail.gmail.com>
References: <1440194989-28835-1-git-send-email-ygardi@codeaurora.org>
 <1440194989-28835-15-git-send-email-ygardi@codeaurora.org>
 <CAL_JsqJELy5jKpkN6GRJqAEVK-rvRxttUg4aLQhFjjkhPxxo8g@mail.gmail.com>
 <1408ea96f7b8f33aef73e0f84abd8792.squirrel@www.codeaurora.org> <de3d715f3d469c1799a3c9ff0f00291c.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <de3d715f3d469c1799a3c9ff0f00291c.squirrel@www.codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-arm-msm <linux-arm-msm@vger.kernel.org>, linux-scsi@vger.kernel.org, Dolev Raviv <draviv@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, linux-scsi-owner@vger.kernel.org, Jej B <james.bottomley@hansenpartnership.com>, Santosh Y <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, hch@infradead.org, Paul Bolle <pebolle@tiscali.nl>, "James E.J. Bottomley" <jbottomley@odin.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Aug 27, 2015 at 7:28 AM,  <ygardi@codeaurora.org> wrote:
>>> On Aug 21, 2015 3:10 PM, "Yaniv Gardi" <ygardi@codeaurora.org> wrote:
>>>>
>>>> Add a write memory barrier to make sure descriptors prepared are
>>>> actually
>>>> written to memory before ringing the doorbell. We have also added the
>>>> write memory barrier after ringing the doorbell register so that
>>>> controller sees the new request immediately.

[...]

>>>> +       /* Make sure descriptors are ready before ringing the doorbell
>>>> */
>>>> +       wmb();
>>>
>>> The writel for the doorbell will do a barrier first. (I didn't check
>>> what exactly ufshcd_writel does, but that is why I don't like these
>>> private access wrappers.)
>
> the barrier here is important and a must.
> before it we prepare descriptors.
> after it we write to DOOR-BELL.
> (and after the DOOR-BELL we have another one.)
> if we remove it, we might get the DOOR-BELL written, before the
> descriptors written.

If you dig into what writel does, you will see that what the code here
ends up being is:

descriptor setup
wmb()
__iomwb() -> wmb on arm64
doorbell register write

So explain why you need 2 barriers.

Barriers in a driver are a red flag. Usually they are not needed, but
sometimes they are. You have to be able to explain why if they are.
Pretty much every descriptor based DMA device works as you describe
and has the ordering problem. Because of that, the core code takes
care of this.

Rob
