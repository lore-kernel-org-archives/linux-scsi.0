From: Luben Tuikov <luben@splentec.com>
Subject: Re: [RFC][PATCH] scsi-misc-2.5 software enqueue when can_queue reached
Date: Tue, 04 Mar 2003 00:48:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E643E1B.9080608@splentec.com>
References: <20030228111924.A32018@beaverton.ibm.com> <3E627037.9060809@splentec.com> <20030303125254.A30662@beaverton.ibm.com> <3E63D9FB.1010602@splentec.com> <20030303154119.A31562@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030303154119.A31562@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> Luben -
> 
> Well they are just names, the important issue is that we understand how
> the code uses them.
> 
> It is a struct list_head, you can call it a queue but it is coded as a
> list_head. Adding _q or _queue does not change anything, or make the code
> easier to understand.

Ah, Patrick, mea culpa.  I see your point of view.

The reason I'm so finicky on names/labels/designators is because
I subscribe to the theory that symbols themselves carry meaning,
rather than the opposing camp of thought, where the claim is that
symbols just label ideas.

The saying ``it's just semantics'' stems from the second
school of thought, which is in recess, after the first one
(cf. Platonism) made its point in the latter 20th century, mainly
through math and philosophy.
Also, the second one gets into infinite regression when/if trying to
explain ``meaning'' itself.

I've mentioned this a few times and given examples of
how hard it is doing arithmetic in Roman numerals, as opposed
to Arabic numerals, which *are* the numbers.

So for this reason I try to name things as closely as possible
so that their names (which is they, themselves) represent what they
are used for or stand for -- which is again they themselves.

If something doesn't have a name, like this object:


then it doesn't really exist. :-)

Else we might just give names like 
	struct list_head c3po;   /* queue of done commands */
which would hardly be appropriate.

BTW, long time ago I used to be one of those ppl that didn't really
care for what the names were -- then I got converted.
 
> There is not much difference between "pending" and "deferred" (damn I
> actually had to go look those up in a dictionary),

(I love reading the dictionary.)

Anyway, something pending is always deferred, but something
deferred doesn't have to be pending.

So in your case, your pending commands may never get executed
if the LUN had died in due time, because the host was buggy
when it's queue limit got hit.  So put them in a deferred_q.

But all commands submitted to the LLDDs, via queuecommand()
are pending for their execution status via scsi_done().

> though SAM-3 references
> pending, I don't see any SAM references to deferred.

Forget about SAM-3.  The queuing model there is for a
different purpose, and we're talking about a [SCSI kernel]
subsystem here. What I'm trying to say is, do what makes sense.
 
> The name can always be modified via future patches.

Theoretically, yes.  Practially, I don't think anyone has
the time and/or desire -- well, maybe Christoph. ;-)

But really, whatever goes in now, will stay there for a
long, long time, so I say, just as we think throughout
the logic, might as well do the same for the names.

-- 
Luben
P.S. Meet the man behind the keyboard, last week, Le Massif, Quebec:
http://www.splentec.com/~luben/dsc00091-re.jpg



