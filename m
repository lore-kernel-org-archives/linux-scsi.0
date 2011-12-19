From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH 02/24] workqueue: defer work to a draining queue
Date: Mon, 19 Dec 2011 14:25:54 -0800
Message-ID: <CABE8wwsnf7vWnsNVQAur=5wqQOKVW_byq-uyFW3-Znf5xGKDiw@mail.gmail.com>
References: <20111217022912.15036.85808.stgit@localhost6.localdomain6>
	<20111217023318.15036.77389.stgit@localhost6.localdomain6>
	<20111219214924.GA6256@google.com>
	<CAA9_cmffHn0tqjF55ZAYi_xG=JakwK28QP=Vj=irP9MwoqWBSw@mail.gmail.com>
	<20111219220841.GB6256@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20111219220841.GB6256@google.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 19, 2011 at 2:08 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On Mon, Dec 19, 2011 at 02:01:47PM -0800, Dan Williams wrote:
>> > Dan, as I replied before, I'm not a big fan of this approach.
>>
>> Sorry I must have missed it, I can't seem to find a reply in the arc=
hives?
>
> Yeah, I can't find it either. =A0I definitely remember writing it.
> Hmmm... weird. =A0Either I'm finally losing my mind or it didn't get =
out
> for some reason. =A0Sorry. :)

As long as it's you losing your mind and not me :-).

>> > For
>> > now, I think it would be best to add private wrapper in libsas to
>> > support deferring unchained work items while draining.
>>
>> Ok, a form of this was nak'd by James before [1], but I can try agai=
n
>> with pushing this chained submission checking down into scsi.
>
> The issues I see with the proposed change is,
>
> * There doesn't seem to be high demand for it.
>
> * It isn't implemented the right way - it introduces unnecessary and
> =A0hidden ordering between chained work items being drained and newly
> =A0queued unchained ones. =A0We can try to do it properly without
> =A0affecting new unchained work items but I'm not sure the added
> =A0complexity is justified given the first issue.

=46air enough.

> I don't think adding a wrapper which defers queueing while draining i=
s
> going on would be too complex, right?

No, I think it should be pretty straightforward to teach libsas not to
throw anything else at the queue while a drain is pending.

Thanks,
Dan
