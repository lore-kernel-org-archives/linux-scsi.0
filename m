From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.14-rc1 0/13] ieee1394: fixes and cleanups
Date: Sun, 18 Sep 2005 01:08:33 +0200 (CEST)
Message-ID: <200509172308.j8HN8ZcH030215@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
Cc: Ben Collins <bcollins@debian.org>, Jody McIntyre <scjody@steamballoon.com>, Dan Dennedy <dan@dennedy.org>, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org

Hi all,

the following posts contain patches to the ieee1394 subsystem that are
suggested for Linux 2.6.14. If there are no objections I'd like to send
them upstream to the 2.6 maintainers next week, probably on Thursday.

Most of the stuff is taken from the currently defunct svn.linux1394.org
repo. Alas I don't have all of the repo's changelog available, therefore
I might have gotten the Signed-off-by's wrong. Please correct me where I
missed someone or included a wrong person. (I hope I did not.)

I will post only the sbp2 related patches to linux-scsi, the rest is
going to linux1394-devel only.

One big chunk of sbp2 updates is not included in this series of patches:
The move of RBC handling into the scsi subsystem's command set layer.
("[SCSI] TYPE_RBC cache fixes (sbp2.c affected)" plus Ben's additional
cleanups.) I will post a separate updated patch with these changes soon
which could go back again into -mm for public exposure. The huge delay
for these changes has several reasons; one of them being the chronic
breakage of sbp2 unplugging/unloading which basically made any tests of
other code changes in sbp2 impossible.

Comments on single patches:

3/13 ieee1394/sbp2: fixes for hot-unplug and module unloading

If you test it on 2.6.14-rc1, it will actually not show the desired
effect due to other, new breakage in the scsi core. I think I will post
a variation of this patch for Linux 2.6.13.x due to its importance for
all sbp2 users, and in order to demonstrate that these fixes work
indeed. :-) Precursors of this patch were successfully tested by several
people on 2.6.12 and 2.6.13-rcX. I hope the scsi core's issues in
2.6.14-rc1 get sorted out eventually. Maybe they are already?

4/13 ieee1394/sbp2: safer default parameter

See the current discussion of an evergreen in "Firewire HD Enclosure
using Genesys chip" at linux1394-devel.

5/13 ieee1394: fix for device detection

Probably only a workaround, not the real fix. The problem can be
reproduced whenever the bus has to be reset to enforce a CMC root node,
e.g. by first joining two or more nodes, then adding the Linux node as
the last one to the bus. I'd like to get this workaround out there since
it is better than instructing users to "modprobe ieee1394
disable_irm=1". I hope to be able to spend time on search for a real fix
next month. However this patch has no negative side effects AFAICS,
unlike the disable_irm workaround.

Patches 7...13/13 (and most of 3/13) are backlog from svn.linux1394.org.
-- 
Stefan Richter
-=====-=-=-= =--= =--=-
http://arcgraph.de/sr/



-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
