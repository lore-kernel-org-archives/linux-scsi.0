From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: [PATCH 4/4] target: Add a user-passthrough backstore
Date: Fri, 19 Sep 2014 16:51:41 -0700
Message-ID: <lvifie$emi$3@ger.gmane.org>
References: <1410822750-10717-1-git-send-email-agrover@redhat.com> <1410822750-10717-5-git-send-email-agrover@redhat.com> <1411161279.23258.26.camel@haakon3.risingtidesystems.com> <lvi81j$ud8$2@ger.gmane.org> <1411169965.23258.45.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Nicholas A. Bellinger wrote:

> On Fri, 2014-09-19 at 14:43 -0700, Alex Elsayed wrote:
>> Nicholas A. Bellinger wrote:
>> 
>> <snip>
>> > So the idea of allowing the in-kernel CDB emulation to run after
>> > user-space has returned unsupported opcode is problematic for a couple
>> > of different reasons.
>> > 
>> > First, if the correct feature bits in standard INQUIRY + EVPD INQUIRY,
>> > etc are not populated by user-space to match what in-kernel CDB
>> > emulation actually supports, this can result in potentially undefined
>> > results initiator side.
>> > 
>> > Also for example, if user-space decided to emulate only a subset of PR
>> > operations, and leaves the rest of it up to the in-kernel emulation,
>> > there's not really a way to sync current state between the two, which
>> > also can end up with undefined results.
>> > 
>> > So that said, I think a saner approach would be two define two modes of
>> > operation for TCMU:
>> > 
>> >    *) Passthrough Mode: All CDBs are passed to user-space, and no
>> >       in-kernel emulation is done in the event of an unsupported
>> >       opcode response.
>> > 
>> >    *) I/O Mode: I/O related CDBs are passed into user-space, but
>> >       all control CDBs continue to be processed by in-kernel emulation.
>> >       This effectively limits operation to TYPE_DISK, but with this
>> >       mode it's probably OK to assume this.
>> > 
>> > This seems like the best trade-off between flexibility when everything
>> > should be handled by user-space, vs. functionality when only block
>> > remapping of I/O is occurring in user-space code.
>> 
>> The problem there is that the first case has all the issues of pscsi and
>> simply becomes a performance optimization over tgt+iscsi client+pscsi and
>> the latter case excludes the main use cases I'm interested in - OSDs,
>> media changers, optical discs (the biggest thing for me), and so forth.
>> 
>> One of the main things I want to do with this is hook up a plugin that
>> uses libmirage to handle various optical disc image formats.
>> 
> 
> Not sure I follow..  How does the proposed passthrough mode prevent
> someone from emulating OSDs, media changers, optical disks or anything
> else in userspace with TCMU..?
> 
> The main thing that the above comments highlight is why attempting to
> combine the existing in-kernel emulation with a userspace backend
> providing it's own emulation can open up a number of problems with
> mismatched state between the two.

It doesn't prevent it, but it _does_ put it in the exact same place as PSCSI 
regarding the warnings on the wiki. It means that if someone wants to 
implement (say) the optical disc or OSD CDBs, they then lose out on ALUA &co 
unless they implement it themselves - which seems unnecessary and painful, 
since those should really be disjoint. In particular, an OSD backed by RADOS 
objects could be a very nice thing indeed, _and_ could really benefit from 
ALUA.
