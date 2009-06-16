From: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: duplicated host_no
Date: Mon, 15 Jun 2009 23:05:50 -0700
Message-ID: <4A37363E.7090605@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: "devel-s9riP+hp16TNLxjTenLetw@public.gmane.org" <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, Linux SCSI Mailing List <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Cool bug.  Two SCSI devs with the same host_id.

This is with fcoe and a bunch of patches in development.

I ran a loop including creating and deleting a bunch of fcoe instances on an MP system.
After 140 some times, I see this:

[ 7250.276749] scsi148 : FCoE Driver
[ 7250.276752] device eth0 entered promiscuous mode
[ 7250.276784] scsi148 : FCoE Driver
[ 7250.277526] host148: lport ffffffff: Entered RESET state from none state
[ 7250.277530] libfc: Link up on port (     0)
[ 7250.277532] host148: lport      0: Entered FLOGI state from reset state
[ 7250.305961] ------------[ cut here ]------------
[ 7250.310653] WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xc7/0xde()
[ 7250.317096] Hardware name: X7DB8
[ 7250.320372] sysfs: cannot create duplicate filename '/bus/scsi/devices/host148'

This is unlikely to show up in real life, but it can happen in
stress tests like this, and the system doesn't work so well afterwards.

I'll submit a patch that uses atomic_inc_return for the host numbers.

	Joe
