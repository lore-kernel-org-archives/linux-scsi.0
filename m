From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Wed, 22 Dec 2010 18:26:22 +0300
Message-ID: <4D12189E.8000007@vlnb.net>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>	 <1292599364.2820.21.camel@mulgrave.site>  <4D0B8975.1040206@vlnb.net>	 <1292602908.2820.41.camel@mulgrave.site>  <4D0BBE40.6030000@vlnb.net>	 <1292617658.2820.80.camel@mulgrave.site>  <4D0BD79B.2010600@vlnb.net>	 <1292628398.16209.25.camel@mulgrave.site>  <4D0CD04E.30806@vlnb.net> <1292690462.16209.54.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1292690462.16209.54.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>, scst-devel <scst-devel@lists.sourceforge.net>
List-Id: linux-scsi@vger.kernel.org

James Bottomley, on 12/18/2010 07:41 PM wrote:
> This is a slightly prismatic view of history. Firstly, LIO had wanted
> into the kernel from way back in the PyX days and secondly, both code
> bases (LIO and STGT) were impenetrably dense, had unacceptable /proc
> interfaces plus a whole host of other nasties. The decision to choose a
> smaller (by an order of magnitutde) and more flexible implementation
> that was in accord with all of the basic Linux necessities was a pretty
> obvious one.

Sorry, James, but your view is even more prismatic.

On the PyX days LIO didn't even exist. Those days it was an iSCSI target
and only iSCSI target, like IET, without any sign of be generic and
support other transports.

Regarding "dense" SCST code. This is exactly what I meant writing that
for me apparent that reviewers were not fully understanding the tasks
SCST was solving. If you don't understand tasks to solve, code solving
them would be terribly hard to read, correct? For instance, if a person
believes that for pass-through the only needed is to pass incoming
requests to backend SCSI hardware and responses from it to the sender,
for him code emulating multi-nexus functionality by intercepting
requests and responses would look like a huge overkill and impenetrably
dense to read.

Regarding unacceptable /proc interface. LIO still has it, but it doesn't
prevent you accepting it. Several days passed since we pointed on it,
but you have not requested to remove it.

Regarding the "host of other nasties". Nobody ever reported them. Maybe,
they didn't exist?

>> Then suddenly NicholasB appeared with his LIO and suddenly what I was
>> writing for years was acknowledged correct: STGT isn't good enough and
>> must be replaced by the fully in-kernel approach.
> 
> I'm not sure where you read that.  I said, for performance, adding
> in-kernel components to STGT would be OK ... keeping the user space
> flexibility is still equally (or more) important.

Well, the fact is that LIO and SCST have fundamentally the same
architecture (LIO is just a worsened SCST several years back), so
accepting LIO now you are confirming that SCST should have been accepted
instead of STGT years ago.

Let's summarize what we have for people not fully following our discussion.

1. Linux kernel is believed to be a place gathering the best code and
the best talents. New people believe that if they do the best writing
the best code, it will be appreciated.

2. Choosing target mode subsystem you declare that neither code quality,
nor advance of implementation, nor features set, nor users base, nor
community size are important for you, hence considered. You believe that
everything can be implemented somewhen in the future. What to do users
while what they need not implemented yet is outside of scope of your
consideration.

3. The only thing matters for you is personality of who submitted the
code. Namely, you like Nicholas A. Bellinger and have chosen him. Hence,
you have chosen LIO. (BTW, rumors suggest you have long standing close
relationship with NicholasB since the PyX times at least.)

4. What was strong requirements few years ago against SCST (no /proc
interface and must have user space backend) for LIO not required. You
can accept it without those requirements satisfied.

5. To make your decision legitimate on the closed invitation-only
storage summit, where there were only people you control and nobody from
the SCST community, those people voted for LIO.

No other result could be expected, because, for instance, Mike Christie
clearly specified in https://bugzilla.redhat.com/show_bug.cgi?id=592147
that he will choose whatever you choose.

Another key person you are referring to, FUJITA Tomonori, also many
times has written that he will do only what you approve to do.

Who else voted for LIO?

6. Now you are referring on that as it was not your decision. Your
community decided it for you.

James, doesn't it smell fishy?

All those instead of an OPEN and FAIR comparison of all aspects of
subsystems to choose the best one.

Sorry, but the next logical step would be merge into the kernel for sale?

Vlad

P.S. Regarding personality of Nicholas A. Bellinger and methods he is
considering acceptable. Page
http://www.linux-iscsi.org/index.php/Main_Page is the most crying
deliberate lie about SCST I've ever seen.

Particularly statement: "SCST [...] is an improved version of IET. It
has been developed by a team in Russia and has made Linux usable as an
IP storage operating system."

At first, SCST has no relation to IET. At all. NicholasB has been
following SCST development sufficiently long to know that IET-derived
iSCSI-SCST target driver was added relatively recently when SCST already
well working with other target drivers (qla2x00t and ib_srpt, for instance).

Second, I'm the only person from Russia in the SCST community. This is
obvious from scst-devel@ mailing list on which NicholasB has been
subscribed for many years. Moreover, for what is mentioning nationality
in this context at all? Attempt to negatively affect SCST by exploiting
not too good image Russia has at the moment in some Western countries?

Third, SCST "makes Linux usable" as ANY SCSI-speaking storage, including
Fibre Channel, SAS, etc. NicholasB knows it very well.

It's also very nice to see on that page SCST declared "legacy" :).

Regarding the comparison page, it has always been inaccurate about SCST
and always in the direction to discredit it. Everybody are people and
everybody make mistakes. But if attempts to point out on them ignored,
mistakes become deliberate cheating. I several times e-mailed NicholasB
explaining those mistakes, but all the times my messages were ignored. I
also was blocked sending messages to the LIO mailing list. (Correct
values for the comparison page you can find on
http://scst.sourceforge.net/comparison.html page).

Such cheating attempts to discredit SCST we have been constantly feeling
since we first time heard NicholasB's name.

Thus, James apparently thinks that the kernel community is too purified,
so it will be good to add to it some sense of undercover intrigues to
make it closer to real life ;)
