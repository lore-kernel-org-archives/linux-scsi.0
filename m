From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Is the possible cross-talking between unrelated file-descriptors on
 bsg-device by design?
Date: Tue, 19 Sep 2017 16:56:32 +0200
Message-ID: <20170919145632.GB28979@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello linux-block,

I wrote some tests recently to test patches against bsg.c and bsg-lib.c,
and while writing those I noticed something strange:

When you use the write() and read() call on multiple file-descriptors
for a single bsg-device (FC or SCSI), it is possible that you get
cross-talk between those different file-descriptors.

E.g.: You have two independent processes open a FD on /dev/bsg/fc_host0
and you send commands via write() in both processes, when they both do
read() later on - to read the response for the commands they send before
-, it is possible that process A gets the response (Sense-Data,
FC-Protocol-Data, ...) for a command that process B wrote and vis-a-vis.

I noticed this because in my tests I 'tag' each command I send with
write() via a value I write into the usr_ptr field of sg_io_v4. When I
later user read() to receive responses I check for this tag in a
hash-table and so can look up the original command. When I used this and
spawned multiple processes with the same target bsg-device, I got
responses for commands I don't have tags for in my hash-table, so they
were written by an other process. This never happend when I only spawn
one test-process.

This seems awfully contra-productive.. so much that I don't see any
point in allowing users to open more than one FD per bsg-device, because
that would inevitably lead to very hard to debug 'bugs'. And I wonder if
this is really by design or some regression that happend over time.

I looked at the code in bsg.c and yes, it seems this is what is coded
right now. We have a hash-table which manages all 'struct bsg_device's
who are indexed by device-minors, so one hash-table entry per
device-node.

So eh, long talk short question, is that intended?



                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
