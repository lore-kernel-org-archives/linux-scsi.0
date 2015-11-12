From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/2] scsi_transport_fc: LUN masking
Date: Thu, 12 Nov 2015 15:00:11 +0100
Message-ID: <56449B6B.5030903@suse.de>
References: <1447238080-109942-1-git-send-email-hare@suse.de> <56449526.5090405@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020003010009020209090404"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37501 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbbKLOAN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Nov 2015 09:00:13 -0500
In-Reply-To: <56449526.5090405@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@odin.com>

This is a multi-part message in MIME format.
--------------020003010009020209090404
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 11/12/2015 02:33 PM, Steffen Maier wrote:
> Hi Hannes,
> 
> On 11/11/2015 11:34 AM, Hannes Reinecke wrote:
>> having been subjected to the pain of trying to bootstrap a really
>> large machine with systemd I decided to implement LUN masking in
> 
> This is very interesting.
> 
> I also thought about initiator-based LUN masking a while ago.
> While scsi_transport_fc would be sufficient to allow zfcp to get rid
> of its own implementation, I wonder why we wouldn't do it in the
> midlayer's scsi_scan.c. This would provide initiator-based LUN
> masking for any and all transports and LLDDs?
> 
> (I also thought about initiator-based zoning, and that would indeed
> be something for scsi_transport_fc because it is inherently
> transport specific.)
> 
Well, it's not _that_ easy.

The one problem you're facing here is addressing; at one point
you'll have to identify which LUNs you'd like to unmask.
While it's true that the LUN itself is stable, the (logical) target
number from the SCSI-ID is not (disregarding SCSI parallel, of course).
The same goes for the 'bus' and 'host' number.

So how would you go about identifying them from the SCSI midlayer?

Hence my approach of moving the addressing into the transport layer,
where we _can_ identify the targets and hosts uniquely.

>> scsi_transport_fc.
>> The principle is simple: disallow the automated LUN scanning when
>> discovering a rport, and create udev rules which selectively
>> enable individual LUNs by echoing the relevant values in the 'scan'
>> attribute of the SCSI host.
> 
> I imagined exactly the same existing user space interface.
> 
> Now we "only" need some user-friendly user space tooling, which
> provides transport specific user arguments automatically translated
> into the midlayer naming scheme, such as converting FC SAN
> addressing (HBA device bus-ID,WWPN,FCPLUN) into scsi_device names
> (Scsi_Host,0,scsi_id,scsi_lun),
> and some persistency mechanism (such as managing udev rules).
> 
Oh, that's easy.
Attached is a simple dracut module which will enable LUN-masking
during booting.

>> With that I'm able to boot an arbitrary large machine without
>> running into any udev or systemd imposed timeout.
>> To _disable_ LUN masking and restoring the original behaviour
>> I've noticed that the 'scan' sysfs attribute is actually synchronous,
>> ie the calling process will be blocked until the entire LUN scan
>> is completed.
>> So I've added another module parameter 'async_user_scan' to
>> move the scanning onto the existing scan workqueue, and unblock
>> the calling process.
> 
> Just curious: Which means would a user of async_user_scan have to
> sync against the completion?
> Or is this only meant for user space--I currently cannot
> imagine--which does not care about the appearance of what was
> (newly) discovered?
> 
The problem I've been running into is that I have a machine where
LUN enumeration alone take 1800s (and no, that's not a typo).
So with the current implementation of 'scan' the calling process
would be stuck for that time, too.
If you were to try to rescan all LUNs during startup with say a
systemd service it would be killed halfway through as the
initialisation would take too long.
Plus any sanely defined service requiring any of those disks would
only startup once all disks are discovered, so there is no need to
wait for the discovery to finish.

Or that's the hope, at least :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

--------------020003010009020209090404
Content-Type: text/x-patch;
 name="0001-95lunmask-Add-module-to-handle-LUN-masking.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-95lunmask-Add-module-to-handle-LUN-masking.patch"

=46rom 1784a28f26011ff0dd29b1c40494cadfa71df564 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Wed, 11 Nov 2015 12:20:33 +0100
Subject: [PATCH] 95lunmask: Add module to handle LUN masking

Using the module option 'scsi_transport_fc.disable_target_scan'
this implements LUN masking by selectively enable only those
devices required for booting.

References: bsc#954600

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 modules.d/95lunmask/fc_transport_scan_lun.sh | 26 +++++++++++++
 modules.d/95lunmask/module-setup.sh          | 55 ++++++++++++++++++++++=
++++++
 modules.d/95lunmask/parse-lunmask.sh         | 28 ++++++++++++++
 3 files changed, 109 insertions(+)
 create mode 100755 modules.d/95lunmask/fc_transport_scan_lun.sh
 create mode 100755 modules.d/95lunmask/module-setup.sh
 create mode 100755 modules.d/95lunmask/parse-lunmask.sh

diff --git a/modules.d/95lunmask/fc_transport_scan_lun.sh b/modules.d/95l=
unmask/fc_transport_scan_lun.sh
new file mode 100755
index 0000000..d9f84a3
--- /dev/null
+++ b/modules.d/95lunmask/fc_transport_scan_lun.sh
@@ -0,0 +1,26 @@
+#!/bin/bash
+#
+# fc_transport_lun_scan
+#
+# Selectively enable individual LUNs behind an FC remote port
+#
+# ACTION=3D=3D"add", SUBSYSTEM=3D=3D"fc_transport", ATTR{port_name}=3D=3D=
"wwpn", \
+#    PROGRAM=3D"fc_transport_lun_scan lun"
+#
+
+[ -z $DEVPATH ] && exit 1
+
+if [ -n "$1" ] ; then
+    LUN=3D$1
+else
+    LUN=3D-
+fi
+ID=3D${DEVPATH##*/rport-}
+HOST=3D${ID%%:*}
+CHANNEL=3D${ID%%-*}
+CHANNEL=3D${CHANNEL#*:}
+if [ -f /sys$DEVPATH/scsi_target_id ] ; then
+    TARGET=3D$(cat /sys$DEVPATH/scsi_target_id)
+fi
+[ -z "$TARGET" ] && exit 1
+echo $CHANNEL $TARGET $LUN > /sys/class/scsi_host/host$HOST/scan
diff --git a/modules.d/95lunmask/module-setup.sh b/modules.d/95lunmask/mo=
dule-setup.sh
new file mode 100755
index 0000000..d8d559b
--- /dev/null
+++ b/modules.d/95lunmask/module-setup.sh
@@ -0,0 +1,55 @@
+#!/bin/bash
+# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-=

+# ex: ts=3D8 sw=3D4 sts=3D4 et filetype=3Dsh
+
+# called by dracut
+cmdline() {
+    get_lunmask() {
+        local _dev=3D$1
+        local _devpath=3D$(cd -P /sys/dev/block/$_dev ; echo $PWD)
+        local _sdev _lun _rport _classdev _wwpn
+
+        [ "${_devpath#*/sd}" =3D=3D "$_devpath" ] && return 1
+        _sdev=3D"${_devpath%%/block/*}"
+        _lun=3D"${_sdev##*:}"
+        _rport=3D"${_devpath##*/rport-}"
+        [ "$_rport" =3D=3D "$_devpath" ] && return 1
+        _rport=3D"${_rport%%/*}"
+        _classdev=3D"/sys/class/fc_remote_ports/rport-${_rport}"
+        [ -d "$_classdev" ] || return 1
+        _wwpn=3D$(cat ${_classdev}/port_name)
+        echo "rd.lunmask=3D${_wwpn},${_lun}"
+        return 0
+    }
+    [[ $hostonly ]] || [[ $mount_needs ]] && {
+        for_each_host_dev_and_slaves_all get_lunmask
+    } | sort | uniq
+}
+
+# called by dracut
+check() {
+    [[ $hostonly ]] || [[ $mount_needs ]] && {
+        [ -f /sys/module/scsi_transport_fc/parameters/disable_target_sca=
n ] \
+            && return 0
+        return 255
+    }
+    return 0
+}
+
+# called by dracut
+depends() {
+    return 0
+}
+
+# called by dracut
+install() {
+    inst_script "$moddir/fc_transport_scan_lun.sh" /usr/lib/udev/fc_tran=
sport_scan_lun.sh
+    inst_hook cmdline 30 "$moddir/parse-lunmask.sh"
+    if [[ $hostonly_cmdline =3D=3D "yes" ]] ; then
+        local _lunmask
+
+        for _lunmask in $(cmdline) ; do
+            printf "%s\n" "$_lunmask" >> "${initdir}/etc/cmdline.d/95lun=
mask.conf"
+        done
+    fi
+}
diff --git a/modules.d/95lunmask/parse-lunmask.sh b/modules.d/95lunmask/p=
arse-lunmask.sh
new file mode 100755
index 0000000..af990dd
--- /dev/null
+++ b/modules.d/95lunmask/parse-lunmask.sh
@@ -0,0 +1,28 @@
+#!/bin/sh
+# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-=

+# ex: ts=3D8 sw=3D4 sts=3D4 et filetype=3Dsh
+
+create_udev_rule() {
+    local wwpn=3D$1
+    local lun=3D$2
+    local _rule=3D/etc/udev/rules.d/51-fc-lunmask-${wwpn}.rules
+    local _cu_type _dev_type
+
+    [ -e ${_rule} ] && return 0
+
+    if [ ! -f "$_rule" ] ; then
+        cat > $_rule <<EOF
+ACTION=3D=3D"add", SUBSYSTEM=3D=3D"fc_remote_ports", ATTR{port_name}=3D=3D=
"$wwpn", PROGRAM=3D"fc_transport_scan_lun.sh $lun"
+EOF
+    fi
+}
+
+for zfcp_arg in $(getargs rd.lunmask); do
+    (
+        local OLDIFS=3D"$IFS"
+        local IFS=3D","
+        set $zfcp_arg
+        IFS=3D"$OLDIFS"
+        create_udev_rule $1 $2
+    )
+done
--=20
1.8.4.5


--------------020003010009020209090404--
