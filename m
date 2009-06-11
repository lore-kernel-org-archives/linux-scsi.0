From: Mike Christie <michaelc@cs.wisc.edu>
Subject: RFC: Adding new block layer error codes
Date: Thu, 11 Jun 2009 16:16:57 -0500
Message-ID: <4A317449.4040602@cs.wisc.edu>
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
To: linux-fsdevel <linux-fsdevel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Jens
List-Id: linux-scsi@vger.kernel.org

Hi,

Sorry to cc so many FS guys. I am a lowly SCSI guy :), so I have no idea 
what lists you guys normally hang out on.

The problem is dm-multipath needs more information about why a IO is 
being failed. If it gets a error because a cable went bad, then we want 
to retry a new path right away. If it gets a error because the device is 
dead, then we want to fail it upwards.

Block layer drivers currently return a errno.h type of error code like 
-EIO or -EOPNOTSUPP to blk_end_request/blk_end_request_all and friends. 
So a long time ago, I tried to just add new errno values for the block 
layer to use (http://marc.info/?l=linux-kernel&m=107715299008231&w=2). 
People did not like this for various reasons.

Next, I tried adding new block layer error codes 
(http://marc.info/?l=linux-kernel&m=107961883915068&w=2  and again here 
http://marc.info/?l=linux-scsi&m=112487427230642&w=2 and actually I 
modified those again a couple times but cannot find the links). My 
concern with the approach in these patches is that while they work well 
for errors that dm-multipath needs to handle, I have no idea what File 
Systems devs need. Also I think this would be useful for RAID.

Now, at work I have lots of bugzillas so I can finally spend some time 
at work to finish this up, and I want to know what developers need. If 
the lower layers can tell you what failed (device or connection to a 
device or driver) and if the lower layers thought the problem was 
retryable or not from its perspective is that good enough. Something 
like this http://marc.info/?l=linux-scsi&m=112487427230642&w=2 ?
