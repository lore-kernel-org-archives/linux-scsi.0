From: Mike Christie <michaelc@cs.wisc.edu>
Subject: LSF: Multipathing and path checking question
Date: Thu, 16 Apr 2009 17:59:17 -0500
Message-ID: <49E7B845.70400@cs.wisc.edu>
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
To: device-mapper development <dm-devel@redhat.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hey,

For this topic:

-----------------------
Next-Gen Multipathing
---------------------
Dr. Hannes Reinecke

......

Should path checkers use sd->state to check for errors or availability?
----------------------

What was decided?

Could this problem be fixed or helped if multipath tools always sets the 
fast io fail tmo for FC or the replacement_timeout for iscsi?

If those are set then IO in the blocked queue and in the driver will get 
failed after fast io fail tmo/replacement_timeout seconds (driver has to 
implement a terminate rport IO callback and only mptfc does not now). So 
at this time, do we want to fail the path?

Or are people thinking that we want to fail the path when the problem is 
initially detected like when the LLD deletes the rport for fc for example?



Also for this one:
-----------------------
How to communication device went away:
1) send event to udev (uses netlink)
-----------------------

Is this an event when dev_loss_tmo fires or when the LLD first detects 
something like a link down (or any event it might block the rport for), 
or would it be for when the fast fail io tmo fires (when the fc class is 
going to fail running IO and incoming IO), or would we have events for 
all of them?
