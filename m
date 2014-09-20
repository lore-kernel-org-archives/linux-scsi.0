From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
Date: Fri, 19 Sep 2014 17:40:32 -0700
Message-ID: <lviie0$bh5$2@ger.gmane.org>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com> <1410822750-10717-5-git-send-email-agrover@redhat.com> <1411161279.23258.26.camel@haakon3.risingtidesystems.com> <lvi81j$ud8$2@ger.gmane.org> <1411169965.23258.45.camel@haakon3.risingtidesystems.com> <lvifie$emi$3@ger.gmane.org> <541CCBD1.8050606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andy Grover wrote:

> On 09/19/2014 04:51 PM, Alex Elsayed wrote:
> 
>>> Not sure I follow..  How does the proposed passthrough mode prevent
>>> someone from emulating OSDs, media changers, optical disks or anything
>>> else in userspace with TCMU..?
>>>
>>> The main thing that the above comments highlight is why attempting to
>>> combine the existing in-kernel emulation with a userspace backend
>>> providing it's own emulation can open up a number of problems with
>>> mismatched state between the two.
>>
>> It doesn't prevent it, but it _does_ put it in the exact same place as
>> PSCSI regarding the warnings on the wiki. It means that if someone wants
>> to implement (say) the optical disc or OSD CDBs, they then lose out on
>> ALUA &co unless they implement it themselves - which seems unnecessary
>> and painful, since those should really be disjoint. In particular, an OSD
>> backed by RADOS objects could be a very nice thing indeed, _and_ could
>> really benefit from ALUA.
> 
> Some possible solutions:
> 
> 1) The first time TCMU sees an opcode it passes it up and notes whether
> it is handled or not. If it was handled then future cmds with that
> opcode are passed up but not retried in the kernel. If it was not
> handled then it and all future commands with that opcode are handled by
> the kernel and not passed up.
> 
> 2) Same as #1 but TCMU operates on SCSI spec granularity - e.g. handling
> any SSC opcode means userspace must handle all SSC commands.
> 
> 3) Like #2 but define opcode groupings that must all be implemented
> together, independent of the specifications.
> 
> 4) Have passthrough mode set at creation, but with more than two modes,
> either grouped by SCSI spec or our own groupings.
> 
> 5) Never pass up certain opcodes, like the ALUA ones or whatever.
> 
> 
> Have a good weekend -- Andy

I think 4 would probably be best, and if defining more modes is backwards-
compatible then we don't really even have to decide between 2 and 3. I do 
think 3 is the more useful one, but it's likely also more effort to figure 
out a usable set than 2 would be.

Also, it might be good to allow more than one grouping, and just union them.
