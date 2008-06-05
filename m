From: Mike Christie <michaelc@cs.wisc.edu>
Subject: mpath: don't fail paths on first error
Date: Thu, 05 Jun 2008 12:25:31 -0500
Message-ID: <4848218B.3090404@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070800010905090700030600"
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

This is a multi-part message in MIME format.
--------------070800010905090700030600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The problem we see a lot at Red Hat is that if drivers fail a command 
with DID_BUS_BUSY or DID_ERROR for something like underrun or even for 
transient path problems, we can normally recover from this pretty 
quickly and we do not need to switch path groups.

queue_if_no_path/no_path_retry will prevent IO from being fail upwards, 
but just switching paths can cause a lot of strain on the target, so we 
might want to prevent path switching when we do not need to. If we are 
using a box that requires manual failover or a box that does not use 
manual failover but still has to shift resources between storage 
controllers when switching paths, we most likely do not want to mark 
paths failed for these transient errors.

The attached patch allows us to wait X seconds before marking a path as 
failed. If within X seconds from seeing the first IO error, we do not 
see a IO complete successfully then we mark a path as failed. This patch 
work best with the fail fast enhancements ones where for a lot of path 
problems the fast io fail / recovery timeout will fail io quickly to us 
and the test IOs do not get stuck, and where some errors like DID_ERROR 
are not even failed fast.

The patch should apply over linus's tree or scsi-misc.

--------------070800010905090700030600
Content-Type: text/x-patch;
	name="0001-dm-mpath-don-t-fail-paths-on-first-error.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="0001-dm-mpath-don-t-fail-paths-on-first-error.patch"


--------------070800010905090700030600
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070800010905090700030600--
