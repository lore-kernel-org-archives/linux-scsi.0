From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: dm-multipath test scripts
Date: Wed, 7 Oct 2015 05:39:24 +0000
Message-ID: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:34481 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbbJGFlt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2015 01:41:49 -0400
Content-Language: ja-JP
Content-ID: <6005C285E26FBE459B7ED079B202C6D1@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

This is a set of scripts for kernel-side dm-multipath testing. Current
set of scripts are stress testing of extreme situation and its coverage
is limited. But recently found dm-mpath regressions should be detectable
with this. I hope this helps people working on dm-multipath related code
as a regression test set.

Though this is created as a patch for linux kernel source, it's just for
convenience of kernel developers (I don't have a place to host this kind
of scripts). If there are better place to contribute this, please let me know.

Please check README for how-to-run and possible improvements you could
contribute in future.

---
 Documentation/device-mapper/mptest/COPYING         | 345 +++++++++++++++++++++
 Documentation/device-mapper/mptest/README          |  61 ++++
 .../device-mapper/mptest/lib/backend_generic       |  28 ++
 .../device-mapper/mptest/lib/backend_scsidebug     |  43 +++
 .../device-mapper/mptest/lib/backend_tcmloop       |  51 +++
 .../device-mapper/mptest/lib/failpath_dm_message   |  43 +++
 .../device-mapper/mptest/lib/failpath_sdev_delete  |  51 +++
 .../device-mapper/mptest/lib/failpath_sdev_offline |  46 +++
 .../device-mapper/mptest/lib/fio_validate          |  41 +++
 .../device-mapper/mptest/lib/mpath_generic         | 119 +++++++
 .../device-mapper/mptest/lib/switchpg_dm_message   |  37 +++
 Documentation/device-mapper/mptest/runtest         |  32 ++
 .../device-mapper/mptest/tests/test_00_no_failure  |  30 ++
 .../mptest/tests/test_01_sdev_offline              |  33 ++
 .../device-mapper/mptest/tests/test_02_sdev_delete |  33 ++
 .../device-mapper/mptest/tests/test_03_dm_failpath |  33 ++
 .../device-mapper/mptest/tests/test_04_dm_switchpg |  33 ++
 17 files changed, 1059 insertions(+)
 create mode 100644 Documentation/device-mapper/mptest/COPYING
 create mode 100644 Documentation/device-mapper/mptest/README
 create mode 100755 Documentation/device-mapper/mptest/lib/backend_generic
 create mode 100755 Documentation/device-mapper/mptest/lib/backend_scsidebug
 create mode 100755 Documentation/device-mapper/mptest/lib/backend_tcmloop
 create mode 100755 Documentation/device-mapper/mptest/lib/failpath_dm_message
 create mode 100755 Documentation/device-mapper/mptest/lib/failpath_sdev_delete
 create mode 100755 Documentation/device-mapper/mptest/lib/failpath_sdev_offline
 create mode 100755 Documentation/device-mapper/mptest/lib/fio_validate
 create mode 100755 Documentation/device-mapper/mptest/lib/mpath_generic
 create mode 100755 Documentation/device-mapper/mptest/lib/switchpg_dm_message
 create mode 100755 Documentation/device-mapper/mptest/runtest
 create mode 100755 Documentation/device-mapper/mptest/tests/test_00_no_failure
 create mode 100755 Documentation/device-mapper/mptest/tests/test_01_sdev_offline
 create mode 100755 Documentation/device-mapper/mptest/tests/test_02_sdev_delete
 create mode 100755 Documentation/device-mapper/mptest/tests/test_03_dm_failpath
 create mode 100755 Documentation/device-mapper/mptest/tests/test_04_dm_switchpg

diff --git a/Documentation/device-mapper/mptest/COPYING b/Documentation/device-mapper/mptest/COPYING
new file mode 100644
index 0000000..1114411
--- /dev/null
+++ b/Documentation/device-mapper/mptest/COPYING
@@ -0,0 +1,345 @@
+		    GNU GENERAL PUBLIC LICENSE
+		       Version 2, June 1991
+
+ Copyright (C) 1989, 1991 Free Software Foundation, Inc.
+     59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ Everyone is permitted to copy and distribute verbatim copies
+ of this license document, but changing it is not allowed.
+
+			    Preamble
+
+  The licenses for most software are designed to take away your
+freedom to share and change it.  By contrast, the GNU General Public
+License is intended to guarantee your freedom to share and change free
+software--to make sure the software is free for all its users.  This
+General Public License applies to most of the Free Software
+Foundation's software and to any other program whose authors commit to
+using it.  (Some other Free Software Foundation software is covered by
+the GNU Library General Public License instead.)  You can apply it to
+your programs, too.
+
+  When we speak of free software, we are referring to freedom, not
+price.  Our General Public Licenses are designed to make sure that you
+have the freedom to distribute copies of free software (and charge for
+this service if you wish), that you receive source code or can get it
+if you want it, that you can change the software or use pieces of it
+in new free programs; and that you know you can do these things.
+
+  To protect your rights, we need to make restrictions that forbid
+anyone to deny you these rights or to ask you to surrender the rights.
+These restrictions translate to certain responsibilities for you if you
+distribute copies of the software, or if you modify it.
+
+  For example, if you distribute copies of such a program, whether
+gratis or for a fee, you must give the recipients all the rights that
+you have.  You must make sure that they, too, receive or can get the
+source code.  And you must show them these terms so they know their
+rights.
+
+  We protect your rights with two steps: (1) copyright the software, and
+(2) offer you this license which gives you legal permission to copy,
+distribute and/or modify the software.
+
+  Also, for each author's protection and ours, we want to make certain
+that everyone understands that there is no warranty for this free
+software.  If the software is modified by someone else and passed on, we
+want its recipients to know that what they have is not the original, so
+that any problems introduced by others will not reflect on the original
+authors' reputations.
+
+  Finally, any free program is threatened constantly by software
+patents.  We wish to avoid the danger that redistributors of a free
+program will individually obtain patent licenses, in effect making the
+program proprietary.  To prevent this, we have made it clear that any
+patent must be licensed for everyone's free use or not licensed at all.
+
+  The precise terms and conditions for copying, distribution and
+modification follow.
+
+
+		    GNU GENERAL PUBLIC LICENSE
+   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
+
+  0. This License applies to any program or other work which contains
+a notice placed by the copyright holder saying it may be distributed
+under the terms of this General Public License.  The "Program", below,
+refers to any such program or work, and a "work based on the Program"
+means either the Program or any derivative work under copyright law:
+that is to say, a work containing the Program or a portion of it,
+either verbatim or with modifications and/or translated into another
+language.  (Hereinafter, translation is included without limitation in
+the term "modification".)  Each licensee is addressed as "you".
+
+Activities other than copying, distribution and modification are not
+covered by this License; they are outside its scope.  The act of
+running the Program is not restricted, and the output from the Program
+is covered only if its contents constitute a work based on the
+Program (independent of having been made by running the Program).
+Whether that is true depends on what the Program does.
+
+  1. You may copy and distribute verbatim copies of the Program's
+source code as you receive it, in any medium, provided that you
+conspicuously and appropriately publish on each copy an appropriate
+copyright notice and disclaimer of warranty; keep intact all the
+notices that refer to this License and to the absence of any warranty;
+and give any other recipients of the Program a copy of this License
+along with the Program.
+
+You may charge a fee for the physical act of transferring a copy, and
+you may at your option offer warranty protection in exchange for a fee.
+
+  2. You may modify your copy or copies of the Program or any portion
+of it, thus forming a work based on the Program, and copy and
+distribute such modifications or work under the terms of Section 1
+above, provided that you also meet all of these conditions:
+
+    a) You must cause the modified files to carry prominent notices
+    stating that you changed the files and the date of any change.
+
+    b) You must cause any work that you distribute or publish, that in
+    whole or in part contains or is derived from the Program or any
+    part thereof, to be licensed as a whole at no charge to all third
+    parties under the terms of this License.
+
+    c) If the modified program normally reads commands interactively
+    when run, you must cause it, when started running for such
+    interactive use in the most ordinary way, to print or display an
+    announcement including an appropriate copyright notice and a
+    notice that there is no warranty (or else, saying that you provide
+    a warranty) and that users may redistribute the program under
+    these conditions, and telling the user how to view a copy of this
+    License.  (Exception: if the Program itself is interactive but
+    does not normally print such an announcement, your work based on
+    the Program is not required to print an announcement.)
+
+
+These requirements apply to the modified work as a whole.  If
+identifiable sections of that work are not derived from the Program,
+and can be reasonably considered independent and separate works in
+themselves, then this License, and its terms, do not apply to those
+sections when you distribute them as separate works.  But when you
+distribute the same sections as part of a whole which is a work based
+on the Program, the distribution of the whole must be on the terms of
+this License, whose permissions for other licensees extend to the
+entire whole, and thus to each and every part regardless of who wrote it.
+
+Thus, it is not the intent of this section to claim rights or contest
+your rights to work written entirely by you; rather, the intent is to
+exercise the right to control the distribution of derivative or
+collective works based on the Program.
+
+In addition, mere aggregation of another work not based on the Program
+with the Program (or with a work based on the Program) on a volume of
+a storage or distribution medium does not bring the other work under
+the scope of this License.
+
+  3. You may copy and distribute the Program (or a work based on it,
+under Section 2) in object code or executable form under the terms of
+Sections 1 and 2 above provided that you also do one of the following:
+
+    a) Accompany it with the complete corresponding machine-readable
+    source code, which must be distributed under the terms of Sections
+    1 and 2 above on a medium customarily used for software interchange; or,
+
+    b) Accompany it with a written offer, valid for at least three
+    years, to give any third party, for a charge no more than your
+    cost of physically performing source distribution, a complete
+    machine-readable copy of the corresponding source code, to be
+    distributed under the terms of Sections 1 and 2 above on a medium
+    customarily used for software interchange; or,
+
+    c) Accompany it with the information you received as to the offer
+    to distribute corresponding source code.  (This alternative is
+    allowed only for noncommercial distribution and only if you
+    received the program in object code or executable form with such
+    an offer, in accord with Subsection b above.)
+
+The source code for a work means the preferred form of the work for
+making modifications to it.  For an executable work, complete source
+code means all the source code for all modules it contains, plus any
+associated interface definition files, plus the scripts used to
+control compilation and installation of the executable.  However, as a
+special exception, the source code distributed need not include
+anything that is normally distributed (in either source or binary
+form) with the major components (compiler, kernel, and so on) of the
+operating system on which the executable runs, unless that component
+itself accompanies the executable.
+
+If distribution of executable or object code is made by offering
+access to copy from a designated place, then offering equivalent
+access to copy the source code from the same place counts as
+distribution of the source code, even though third parties are not
+compelled to copy the source along with the object code.
+
+
+  4. You may not copy, modify, sublicense, or distribute the Program
+except as expressly provided under this License.  Any attempt
+otherwise to copy, modify, sublicense or distribute the Program is
+void, and will automatically terminate your rights under this License.
+However, parties who have received copies, or rights, from you under
+this License will not have their licenses terminated so long as such
+parties remain in full compliance.
+
+  5. You are not required to accept this License, since you have not
+signed it.  However, nothing else grants you permission to modify or
+distribute the Program or its derivative works.  These actions are
+prohibited by law if you do not accept this License.  Therefore, by
+modifying or distributing the Program (or any work based on the
+Program), you indicate your acceptance of this License to do so, and
+all its terms and conditions for copying, distributing or modifying
+the Program or works based on it.
+
+  6. Each time you redistribute the Program (or any work based on the
+Program), the recipient automatically receives a license from the
+original licensor to copy, distribute or modify the Program subject to
+these terms and conditions.  You may not impose any further
+restrictions on the recipients' exercise of the rights granted herein.
+You are not responsible for enforcing compliance by third parties to
+this License.
+
+  7. If, as a consequence of a court judgment or allegation of patent
+infringement or for any other reason (not limited to patent issues),
+conditions are imposed on you (whether by court order, agreement or
+otherwise) that contradict the conditions of this License, they do not
+excuse you from the conditions of this License.  If you cannot
+distribute so as to satisfy simultaneously your obligations under this
+License and any other pertinent obligations, then as a consequence you
+may not distribute the Program at all.  For example, if a patent
+license would not permit royalty-free redistribution of the Program by
+all those who receive copies directly or indirectly through you, then
+the only way you could satisfy both it and this License would be to
+refrain entirely from distribution of the Program.
+
+If any portion of this section is held invalid or unenforceable under
+any particular circumstance, the balance of the section is intended to
+apply and the section as a whole is intended to apply in other
+circumstances.
+
+It is not the purpose of this section to induce you to infringe any
+patents or other property right claims or to contest validity of any
+such claims; this section has the sole purpose of protecting the
+integrity of the free software distribution system, which is
+implemented by public license practices.  Many people have made
+generous contributions to the wide range of software distributed
+through that system in reliance on consistent application of that
+system; it is up to the author/donor to decide if he or she is willing
+to distribute software through any other system and a licensee cannot
+impose that choice.
+
+This section is intended to make thoroughly clear what is believed to
+be a consequence of the rest of this License.
+
+
+  8. If the distribution and/or use of the Program is restricted in
+certain countries either by patents or by copyrighted interfaces, the
+original copyright holder who places the Program under this License
+may add an explicit geographical distribution limitation excluding
+those countries, so that distribution is permitted only in or among
+countries not thus excluded.  In such case, this License incorporates
+the limitation as if written in the body of this License.
+
+  9. The Free Software Foundation may publish revised and/or new versions
+of the General Public License from time to time.  Such new versions will
+be similar in spirit to the present version, but may differ in detail to
+address new problems or concerns.
+
+Each version is given a distinguishing version number.  If the Program
+specifies a version number of this License which applies to it and "any
+later version", you have the option of following the terms and conditions
+either of that version or of any later version published by the Free
+Software Foundation.  If the Program does not specify a version number of
+this License, you may choose any version ever published by the Free Software
+Foundation.
+
+  10. If you wish to incorporate parts of the Program into other free
+programs whose distribution conditions are different, write to the author
+to ask for permission.  For software which is copyrighted by the Free
+Software Foundation, write to the Free Software Foundation; we sometimes
+make exceptions for this.  Our decision will be guided by the two goals
+of preserving the free status of all derivatives of our free software and
+of promoting the sharing and reuse of software generally.
+
+			    NO WARRANTY
+
+  11. BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
+FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
+OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
+PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
+OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
+TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
+PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
+REPAIR OR CORRECTION.
+
+  12. IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
+WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
+REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
+INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
+OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
+TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
+YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
+PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
+POSSIBILITY OF SUCH DAMAGES.
+
+		     END OF TERMS AND CONDITIONS
+
+
+	    How to Apply These Terms to Your New Programs
+
+  If you develop a new program, and you want it to be of the greatest
+possible use to the public, the best way to achieve this is to make it
+free software which everyone can redistribute and change under these terms.
+
+  To do so, attach the following notices to the program.  It is safest
+to attach them to the start of each source file to most effectively
+convey the exclusion of warranty; and each file should have at least
+the "copyright" line and a pointer to where the full notice is found.
+
+    <one line to give the program's name and a brief idea of what it does.>
+    Copyright (C) <year>  <name of author>
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+    You should have received a copy of the GNU General Public License
+    along with this program; if not, write to the Free Software
+    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+
+Also add information on how to contact you by electronic and paper mail.
+
+If the program is interactive, make it output a short notice like this
+when it starts in an interactive mode:
+
+    Gnomovision version 69, Copyright (C) year  name of author
+    Gnomovision comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
+    This is free software, and you are welcome to redistribute it
+    under certain conditions; type `show c' for details.
+
+The hypothetical commands `show w' and `show c' should show the appropriate
+parts of the General Public License.  Of course, the commands you use may
+be called something other than `show w' and `show c'; they could even be
+mouse-clicks or menu items--whatever suits your program.
+
+You should also get your employer (if you work as a programmer) or your
+school, if any, to sign a "copyright disclaimer" for the program, if
+necessary.  Here is a sample; alter the names:
+
+  Yoyodyne, Inc., hereby disclaims all copyright interest in the program
+  `Gnomovision' (which makes passes at compilers) written by James Hacker.
+
+  <signature of Ty Coon>, 1 April 1989
+  Ty Coon, President of Vice
+
+This General Public License does not permit incorporating your program into
+proprietary programs.  If your program is a subroutine library, you may
+consider it more useful to permit linking proprietary applications with the
+library.  If this is what you want to do, use the GNU Library General
+Public License instead of this License.
diff --git a/Documentation/device-mapper/mptest/README b/Documentation/device-mapper/mptest/README
new file mode 100644
index 0000000..b2de27c
--- /dev/null
+++ b/Documentation/device-mapper/mptest/README
@@ -0,0 +1,61 @@
+Test scripts for dm-multipath
+=============================
+
+How to run
+----------
+  # cd mptest
+  # ./runtest
+  ..
+  (verbose outputs)
+  ..
+  ** summary **
+  PASSED:  test_00_no_failure test_02_sdev_delete test_03_dm_failpath
+  FAILED:  test_01_sdev_offline
+
+  Or './runtest tests/test_01_sdev_offline', for example, to run a
+  specific test.
+
+
+Required tools
+--------------
+  - dmsetup
+  - fio
+  - targetcli (if MULTIPATH_BACKEND_MODULE=tcmloop)
+  - scsi_debug.ko (if MULTIPATH_BACKEND_MODULE=scsidebug)
+
+
+Improvements needed
+-------------------
+  - More realistic ALUA setups
+      * Multiple TPGs
+      * Optimized/Non-optimized groups
+      * Prefered bit
+  - More realistic transports and failure modes
+      * iSCSI
+      * FC
+  - More varieties of I/Os
+      * blk pcs
+  - Validation tests of dm table/status
+      * whether dm-mpath.ko can handle various dm table pattern correctly
+      * whether dm-mpath.ko outputs dm status correctly
+  - Better udev avoidance
+      * a lot of uevents are generated during the test, that unintendedly
+        ends up with stress testing of udev subsystem
+      * dmsetup might fail and/or stall if the avoidance is not done
+        correctly
+  - Integration test with udev and multipath-tools
+      * for realistic testing, tests involving udev and multipathd are
+        also necessary
+
+Issues
+------
+  - When run from non-interactive mode, targetcli might emit python
+    exception when called:
+      Traceback (most recent call last):
+        File "/usr/bin/targetcli", line 121, in <module>
+          main()
+        File "/usr/bin/targetcli", line 111, in main
+          shell.run_interactive()
+        File "/usr/lib/python2.7/site-packages/configshell_fb/shell.py", line 899, in run_interactive
+          readline.set_completer(old_completer)
+      NameError: global name 'readline' is not defined
diff --git a/Documentation/device-mapper/mptest/lib/backend_generic b/Documentation/device-mapper/mptest/lib/backend_generic
new file mode 100755
index 0000000..ac7843d
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/backend_generic
@@ -0,0 +1,28 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+if [ -z "${MULTIPATH_BACKEND_MODULE}" ]; then
+	echo "MULTIPATH_BACKEND_MODULE should be defined"
+	exit 1
+fi
+if [ ! -e "$LIB/backend_${MULTIPATH_BACKEND_MODULE}" ]; then
+	echo "backend_${MULTIPATH_BACKEND_MODULE} does not exist"
+	exit 1
+fi
+
+. $LIB/backend_${MULTIPATH_BACKEND_MODULE}
diff --git a/Documentation/device-mapper/mptest/lib/backend_scsidebug b/Documentation/device-mapper/mptest/lib/backend_scsidebug
new file mode 100755
index 0000000..ed41d21
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/backend_scsidebug
@@ -0,0 +1,43 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+backend_all_paths ()
+{
+        grep -l scsi_debug /sys/block/sd*/device/model | \
+		awk -F/ '{print $4}'
+}
+
+backend_all_hosts ()
+{
+        grep -l scsi_debug /sys/class/scsi_host/host*/proc_name | \
+		awk -F/ '{print $5}'
+}
+
+backend_create_device ()
+{
+	modprobe -r scsi_debug
+	modprobe scsi_debug vpd_use_hostno=0 \
+		dev_size_mb=1024 add_host=4 max_luns=1 \
+		delay=1
+}
+
+backend_delete_device ()
+{
+	rmmod scsi_debug
+}
+
diff --git a/Documentation/device-mapper/mptest/lib/backend_tcmloop b/Documentation/device-mapper/mptest/lib/backend_tcmloop
new file mode 100755
index 0000000..769ee18
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/backend_tcmloop
@@ -0,0 +1,51 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+backend_all_paths ()
+{
+        grep -l LIO-ORG /sys/block/sd*/device/vendor | \
+		awk -F/ '{print $4}'
+}
+
+backend_all_hosts ()
+{
+        grep -l tcm_loopback /sys/class/scsi_host/host*/proc_name | \
+		awk -F/ '{print $5}'
+}
+
+backend_create_device ()
+{
+	targetcli <<EOF || exit 1
+clearconfig confirm=True
+/backstores/ramdisk create rd 1G
+/loopback create naa.5001401111111111
+/loopback create naa.5001402222222222
+/loopback create naa.5001403333333333
+/loopback create naa.5001404444444444
+/loopback/naa.5001401111111111/luns create /backstores/ramdisk/rd
+/loopback/naa.5001402222222222/luns create /backstores/ramdisk/rd
+/loopback/naa.5001403333333333/luns create /backstores/ramdisk/rd
+/loopback/naa.5001404444444444/luns create /backstores/ramdisk/rd
+EOF
+}
+
+backend_delete_device ()
+{
+	echo 'clearconfig confirm=True' | targetcli
+}
+
diff --git a/Documentation/device-mapper/mptest/lib/failpath_dm_message b/Documentation/device-mapper/mptest/lib/failpath_dm_message
new file mode 100755
index 0000000..1a3bcf8
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/failpath_dm_message
@@ -0,0 +1,43 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+stopfile=stop.failpath_dm_message
+
+start_failpath_dm_message () {
+	[ -z "$MPNAME" ] && exit 1
+	local d
+	local m
+	local devs=$(mpath_all_paths)
+	local majs=$(for d in $devs; do cat /sys/block/$d/dev; done)
+
+	rm -f $stopfile
+	while [ ! -f $stopfile ]; do
+		for m in $majs; do
+			dmsetup message $MPNAME 0 "fail_path $m"
+		done
+		for m in $majs; do
+			dmsetup message $MPNAME 0 "reinstate_path $m"
+		done
+	done &
+}
+
+stop_failpath_dm_message ()
+{
+	touch $stopfile
+	wait
+}
diff --git a/Documentation/device-mapper/mptest/lib/failpath_sdev_delete b/Documentation/device-mapper/mptest/lib/failpath_sdev_delete
new file mode 100755
index 0000000..117378b
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/failpath_sdev_delete
@@ -0,0 +1,51 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+stopfile=stop.failpath_sdev_delete
+
+_reload_mpath_table () {
+        local table="$(mpath_table)"
+        echo "$table" | dmsetup load $MPNAME && \
+	dmsetup suspend --nolockfs --noflush $MPNAME && \
+	dmsetup resume $MPNAME
+}
+
+start_failpath_sdev_delete () {
+	[ -z "$MPNAME" ] && exit 1
+	local d
+	local h
+	rm -f $stopfile
+	while [ ! -f $stopfile ]; do
+		for d in $(mpath_all_paths); do
+			echo 1 > /sys/block/${d}/device/delete
+		done
+		#sleep 1
+		for h in $(mpath_all_hosts); do
+			echo '- - -' > /sys/class/scsi_host/${h}/scan
+		done
+		#sleep 1
+		_reload_mpath_table
+	done &
+}
+
+stop_failpath_sdev_delete ()
+{
+	touch $stopfile
+	wait
+	sleep 3
+}
diff --git a/Documentation/device-mapper/mptest/lib/failpath_sdev_offline b/Documentation/device-mapper/mptest/lib/failpath_sdev_offline
new file mode 100755
index 0000000..1a185b2
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/failpath_sdev_offline
@@ -0,0 +1,46 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+stopfile=stop.failpath_sdev_offline
+
+start_failpath_sdev_offline () {
+	[ -z "$MPNAME" ] && exit 1
+	local d
+	local m
+	local devs=$(mpath_all_paths)
+	local majs=$(for d in $devs; do cat /sys/block/$d/dev; done)
+
+	rm -f $stopfile
+	while [ ! -f $stopfile ]; do
+		for d in $devs; do
+			echo offline > /sys/block/${d}/device/state
+		done
+		for d in $devs; do
+			echo running > /sys/block/${d}/device/state
+		done
+		for m in $majs; do
+			dmsetup message $MPNAME 0 "reinstate_path $m"
+		done
+	done &
+}
+
+stop_failpath_sdev_offline ()
+{
+	touch $stopfile
+	wait
+}
diff --git a/Documentation/device-mapper/mptest/lib/fio_validate b/Documentation/device-mapper/mptest/lib/fio_validate
new file mode 100755
index 0000000..9a79034
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/fio_validate
@@ -0,0 +1,41 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+if [ -z "${FIO_VALIDATE_OPT}" ]; then
+	FIO_VALIDATE_OPT="--time_based --runtime=300 --size=100G"
+fi
+
+run_fio_validate ()
+{
+	if [ -z "$MPNAME" ] || [ ! -b "/dev/mapper/$MPNAME" ]; then
+		echo "FAILED TO START"
+		return 1
+	fi
+
+	fio --bs=512k --rw=randwrite --direct=1 --iodepth=2 --ioengine=libaio \
+	    --filename=/dev/mapper/$MPNAME ${FIO_VALIDATE_OPT} \
+	    --do_verify=1 --verify=meta --verify_dump=1 --verify_fatal=1 \
+	    --name=test1
+	if [ $? -ne 0 ]; then
+		echo "FAILED"
+		return 1
+	else
+		echo "SUCCESS"
+		return 0
+	fi
+}
diff --git a/Documentation/device-mapper/mptest/lib/mpath_generic b/Documentation/device-mapper/mptest/lib/mpath_generic
new file mode 100755
index 0000000..c67fd5d
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/mpath_generic
@@ -0,0 +1,119 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+if [ -z "$MPNAME" ]; then
+	echo "MPNAME should be defined"
+	exit 1
+fi
+if dmsetup info $MPNAME >&/dev/null; then
+	echo "dm device $MPNAME already exists"
+	exit 1
+fi
+
+mpath_all_paths ()
+{
+	backend_all_paths
+}
+
+mpath_all_hosts ()
+{
+	backend_all_hosts
+}
+
+mpath_table ()
+{
+	# dm-mpath parameters
+	local _feature="2 queue_if_no_path retain_attached_hw_handler"
+	local _hwhandler="0"
+	local _initialpg="1"
+	local _selector="queue-length 0"
+	#
+	local str=
+	local _pgs=0
+	#
+	local _paths=0
+	local pgstr=
+	# group by 2-paths
+	for d in $(mpath_all_paths); do
+		local sz=$(blockdev --getsz /dev/$d)
+		if [ -z "$sz" ] || [ "$sz" = "0" ]; then
+			continue
+		fi
+		size=$sz
+		pgstr="$pgstr /dev/${d} 1"
+		_paths=$((_paths + 1))
+		if [ ${_paths} -eq 2 ]; then
+			str="$str ${_selector} ${_paths} 1 $pgstr"
+			pgstr=
+			_paths=0
+			_pgs=$((_pgs + 1))
+		fi
+	done
+	if [ ${_paths} -gt 0 ]; then
+		str="$str ${_selector} ${_paths} 1 $pgstr"
+		pgstr=
+		_paths=0
+		_pgs=$((_pgs + 1))
+	fi
+	if [ ${_pgs} -eq 0 ]; then
+		_initialpg=0
+	fi
+
+	echo "0 $size multipath ${_feature} ${_hwhandler} ${_pgs} ${_initialpg} ${str}"
+}
+
+create_mpath ()
+{
+	# avoid interference with multipathd
+	service multipathd stop
+
+	#
+	# Create multipath backend
+	#
+	backend_create_device
+	# ...wait for sdev become visible
+	sleep 1
+
+	#
+	# Create DM device
+	#
+	local table="$(mpath_table)"
+	echo "Initial table: $table"
+	dmsetup create $MPNAME --table "$table" || exit 1
+	# ...wait for mpdev become visible and udev activities settle
+	sleep 3
+}
+
+delete_mpath ()
+{
+	# ...wait for any processes touching mpdev to finish
+	sleep 3
+
+	# Remove mpath device
+	size=$(dmsetup status $MPNAME | awk '{print $2}')
+	echo "0 $size error" | dmsetup load $MPNAME && \
+	dmsetup suspend --nolockfs --noflush $MPNAME && \
+	dmsetup resume $MPNAME
+	#udevadm settle
+	dmsetup remove $MPNAME
+
+	# ...wait for any processes touching sdev to finish
+	sleep 1
+	backend_delete_device
+}
+
diff --git a/Documentation/device-mapper/mptest/lib/switchpg_dm_message b/Documentation/device-mapper/mptest/lib/switchpg_dm_message
new file mode 100755
index 0000000..e53808a
--- /dev/null
+++ b/Documentation/device-mapper/mptest/lib/switchpg_dm_message
@@ -0,0 +1,37 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+stopfile=stop.switchpg_dm_message
+
+start_switchpg_dm_message () {
+	[ -z "$MPNAME" ] && exit 1
+
+	rm -f $stopfile
+	while [ ! -f $stopfile ]; do
+		dmsetup message $MPNAME 0 "disable_group 1"
+		sleep 1
+		dmsetup message $MPNAME 0 "enable_group 1"
+		sleep 1
+	done &
+}
+
+stop_switchpg_dm_message ()
+{
+	touch $stopfile
+	wait
+}
diff --git a/Documentation/device-mapper/mptest/runtest b/Documentation/device-mapper/mptest/runtest
new file mode 100755
index 0000000..114184a
--- /dev/null
+++ b/Documentation/device-mapper/mptest/runtest
@@ -0,0 +1,32 @@
+#!/bin/bash
+
+export MPNAME="mp"
+export LIB=./lib
+
+# Select backend device type
+export MULTIPATH_BACKEND_MODULE="tcmloop"
+#export MULTIPATH_BACKEND_MODULE="scsidebug"
+
+# Uncomment this if you want shorter test
+#export FIO_VALIDATE_OPT="--time_based --runtime=30 --size=10G"
+
+TESTS="./tests/*"
+if [ "$*" ]; then
+	TESTS=$*
+fi
+
+PASSED=
+FAILED=
+for t in $TESTS; do
+	echo "** Running: $t"
+	$t
+	if [ $? -eq 0 ]; then
+		PASSED="$PASSED $(basename $t)"
+	else
+		FAILED="$FAILED $(basename $t)"
+	fi
+done
+
+echo "** summary **"
+echo "PASSED: $PASSED"
+echo "FAILED: $FAILED"
diff --git a/Documentation/device-mapper/mptest/tests/test_00_no_failure b/Documentation/device-mapper/mptest/tests/test_00_no_failure
new file mode 100755
index 0000000..3324bf6
--- /dev/null
+++ b/Documentation/device-mapper/mptest/tests/test_00_no_failure
@@ -0,0 +1,30 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+. ${LIB}/backend_generic
+. ${LIB}/mpath_generic
+. ${LIB}/fio_validate
+
+create_mpath
+
+run_fio_validate
+ret=$?
+
+delete_mpath
+
+exit $ret
diff --git a/Documentation/device-mapper/mptest/tests/test_01_sdev_offline b/Documentation/device-mapper/mptest/tests/test_01_sdev_offline
new file mode 100755
index 0000000..33291e2
--- /dev/null
+++ b/Documentation/device-mapper/mptest/tests/test_01_sdev_offline
@@ -0,0 +1,33 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+. ${LIB}/backend_generic
+. ${LIB}/mpath_generic
+. ${LIB}/failpath_sdev_offline
+. ${LIB}/fio_validate
+
+create_mpath
+start_failpath_sdev_offline
+
+run_fio_validate
+ret=$?
+
+stop_failpath_sdev_offline
+delete_mpath
+
+exit $ret
diff --git a/Documentation/device-mapper/mptest/tests/test_02_sdev_delete b/Documentation/device-mapper/mptest/tests/test_02_sdev_delete
new file mode 100755
index 0000000..44d0ff8
--- /dev/null
+++ b/Documentation/device-mapper/mptest/tests/test_02_sdev_delete
@@ -0,0 +1,33 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+. ${LIB}/backend_generic
+. ${LIB}/mpath_generic
+. ${LIB}/failpath_sdev_delete
+. ${LIB}/fio_validate
+
+create_mpath
+start_failpath_sdev_delete
+
+run_fio_validate
+ret=$?
+
+stop_failpath_sdev_delete
+delete_mpath
+
+exit $ret
diff --git a/Documentation/device-mapper/mptest/tests/test_03_dm_failpath b/Documentation/device-mapper/mptest/tests/test_03_dm_failpath
new file mode 100755
index 0000000..f8938fb
--- /dev/null
+++ b/Documentation/device-mapper/mptest/tests/test_03_dm_failpath
@@ -0,0 +1,33 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+. ${LIB}/backend_generic
+. ${LIB}/mpath_generic
+. ${LIB}/failpath_dm_message
+. ${LIB}/fio_validate
+
+create_mpath
+start_failpath_dm_message
+
+run_fio_validate
+ret=$?
+
+stop_failpath_dm_message
+delete_mpath
+
+exit $ret
diff --git a/Documentation/device-mapper/mptest/tests/test_04_dm_switchpg b/Documentation/device-mapper/mptest/tests/test_04_dm_switchpg
new file mode 100755
index 0000000..4086e28
--- /dev/null
+++ b/Documentation/device-mapper/mptest/tests/test_04_dm_switchpg
@@ -0,0 +1,33 @@
+#!/bin/bash
+#
+# Copyright (C) 2015 NEC Corporation.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+
+. ${LIB}/backend_generic
+. ${LIB}/mpath_generic
+. ${LIB}/switchpg_dm_message
+. ${LIB}/fio_validate
+
+create_mpath
+start_switchpg_dm_message
+
+run_fio_validate
+ret=$?
+
+stop_switchpg_dm_message
+delete_mpath
+
+exit $ret
-- 
2.1.0
