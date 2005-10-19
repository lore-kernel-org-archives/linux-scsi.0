From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [ANNOUNCE] block layer (request based) multipath v1
Date: Wed, 19 Oct 2005 01:20:44 -0500
Message-ID: <4355E5BC.60701@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@suse.de, dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Version 1 and maybe the only version :)

I have pretty much completely convert dm-multipath to blk_mpath. I 
converted the hw handlers (including the out of tree hp-sw and 
engenio-rdac ones) and implemented the emc sense code for Read/Write 
errors. The next task would be to completely convert the open source 
Engenio driver which I had started doing for dm-multipath and the eroro 
code patches but ended up having problems with the sense decoding.

The large patch is here
http://www.cs.wisc.edu/~michaelc/block/blk_mpath/blk_mpath3.patch

I think the only items I have left to convert are some of the dm ioctls, 
but that is trivial and the defaults are ok for usage. For example I 
have not implemted a sysfs attr to read/write queue_if_no_path and a 
timeout attr so we do not have to wait forever on it.

Comments???? Should I work with Christophe to convert the userspace tools?



Changed since last post:

- Fixed partial completion code to support existing scenarios
(for example SCSI MEDIUM ERRORS where the head is completed ok but the 
end could end up failed or ok)
- converted dm-hw_handler code
- Completely converted dm-emc.c including adding RW error sense code
- Added hp-sw and engenio rdac code for failover. I will send sense code 
support when finished gettitng access from OSDL and can test that code, 
but it should basically work but just not so effeciently and when doing 
snapshots or backups or firmware upgrades or other features. Maybe 
Engenio could just implement this now since all the pieces are there, 
except maybe controller representation, or at least give me some docs so 
I do not have to guess about some of the code in the GPL driver :)
- Added a path state sysfs attr for onlining paths. Userspace can online 
a path and do failback now.
