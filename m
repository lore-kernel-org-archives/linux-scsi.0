From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Tue, 22 Mar 2016 18:36:03 +0100
Message-ID: <56F18283.2000000@suse.de>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
 <56EC797A.8000104@sandisk.com> <56ED6DB1.1050202@suse.de>
 <56EF4D4A.6050000@sandisk.com> <56EF9F7E.2010300@suse.de>
 <1709049972.24310562.1458592857261.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020107080006020807030000"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36806 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbcCVRgF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2016 13:36:05 -0400
In-Reply-To: <1709049972.24310562.1458592857261.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------020107080006020807030000
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 03/21/2016 09:40 PM, Laurence Oberman wrote:
> Hello Hannes
> 
> Please share latest scripts and an example of how you are using them.
> I have some scripts from last November, that you posted but I am sure they have changed.
> If not then I will modify them as appropriate, just let me know.
> 
> I have added the patches and booted the system set to async, so before I boot with
> scsi_mod.scan=manual want to prepare my test system.
> This feature may be a very useful feature we would want to include in RHEL as we
> struggle with large LUN boot configurations all the time.

Oh, really? Hardly a surprise.
In fact, I'm constantly surprised that RHEL ships with systemd
enabled, apparently without any issues.
Especially in large machines.
As we found to our dismay; I spent about a year to get things
running smoothly.
Or, to be precise, running at all.

Anyway.

Attached is the original patch to dracut; please check if it's the
correct version (I've changed the 'disabled' to 'manual' for
upstream submission).

I haven't included the systemd service; that's actually quite
trivial: reset the scan mode (as it's now writeable) and call
rescan-scsi-bus.sh or equivalent.

But please add a 'Tested-by' or equivalent to the upstream patch, to
add a bit more urgency to it.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

--------------020107080006020807030000
Content-Type: text/x-patch;
 name="0001-95lunmask-Add-module-to-handle-LUN-masking.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-95lunmask-Add-module-to-handle-LUN-masking.patch"

=46rom 1d427bcf3527ba96828a4bd5231409967ff096b4 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Wed, 11 Nov 2015 12:20:33 +0100
Subject: [PATCH] 95lunmask: Add module to handle LUN masking

Using the module option 'scsi_mod.scan=3Ddisabled'
this implements LUN masking by selectively enable only those
devices required for booting.

References: bsc#954600

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 modules.d/95lunmask/fc_transport_scan_lun.sh  | 26 ++++++++++
 modules.d/95lunmask/module-setup.sh           | 70 +++++++++++++++++++++=
++++++
 modules.d/95lunmask/parse-lunmask.sh          | 40 +++++++++++++++
 modules.d/95lunmask/sas_transport_scan_lun.sh | 26 ++++++++++
 4 files changed, 162 insertions(+)
 create mode 100755 modules.d/95lunmask/fc_transport_scan_lun.sh
 create mode 100755 modules.d/95lunmask/module-setup.sh
 create mode 100755 modules.d/95lunmask/parse-lunmask.sh
 create mode 100755 modules.d/95lunmask/sas_transport_scan_lun.sh

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
index 0000000..c88b1c0
--- /dev/null
+++ b/modules.d/95lunmask/module-setup.sh
@@ -0,0 +1,70 @@
+#!/bin/bash
+# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-=

+# ex: ts=3D8 sw=3D4 sts=3D4 et filetype=3Dsh
+
+# called by dracut
+cmdline() {
+    get_lunmask() {
+        local _dev=3D$1
+        local _devpath=3D$(cd -P /sys/dev/block/$_dev ; echo $PWD)
+        local _sdev _lun _rport _end_device _classdev _wwpn _sas_address=

+
+        [ "${_devpath#*/sd}" =3D=3D "$_devpath" ] && return 1
+        _sdev=3D"${_devpath%%/block/*}"
+        _lun=3D"${_sdev##*:}"
+        # Check for FibreChannel
+        _rport=3D"${_devpath##*/rport-}"
+        if [ "$_rport" !=3D "$_devpath" ] ; then
+            _rport=3D"${_rport%%/*}"
+            _classdev=3D"/sys/class/fc_remote_ports/rport-${_rport}"
+            [ -d "$_classdev" ] || return 1
+            _wwpn=3D$(cat ${_classdev}/port_name)
+            echo "rd.lunmask=3Dfc,${_wwpn},${_lun}"
+            return 0
+        fi
+        # Check for SAS
+        _end_device=3D"${_devpath##*/end_device-}"
+        if [ "$_end_device" !=3D "$_devpath" ] ; then
+            _end_device=3D"${_end_device%%/*}"
+            _classdev=3D"/sys/class/sas_device/end_device-${_end_device}=
"
+            [ -e "$_classdev" ] || return 1
+            _sas_address=3D$(cat ${_classdev}/sas_address)
+            echo "rd.lunmask=3Dsas,${_sas_address},${_lun}"
+            return 0
+        fi
+        return 1
+    }
+    [[ $hostonly ]] || [[ $mount_needs ]] && {
+        for_each_host_dev_and_slaves_all get_lunmask
+    } | sort | uniq
+}
+
+# called by dracut
+check() {
+    [[ $hostonly ]] || [[ $mount_needs ]] && {
+        [ -w /sys/module/scsi_mod/parameters/scan ] || return 255
+        scan_type=3D$(cat /sys/module/scsi_mod/parameters/scan)
+        [ "$scan_type" =3D "disabled" ] && return 0
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
+    inst_script "$moddir/sas_transport_scan_lun.sh" /usr/lib/udev/sas_tr=
ansport_scan_lun.sh
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
index 0000000..81dc412
--- /dev/null
+++ b/modules.d/95lunmask/parse-lunmask.sh
@@ -0,0 +1,40 @@
+#!/bin/sh
+# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-=

+# ex: ts=3D8 sw=3D4 sts=3D4 et filetype=3Dsh
+
+create_udev_rule() {
+    local transport=3D$1
+    local tgtid=3D$2
+    local lun=3D$3
+    local _rule=3D/etc/udev/rules.d/51-${transport}-lunmask-${tgtid}.rul=
es
+    local _cu_type _dev_type
+
+    [ -e ${_rule} ] && return 0
+
+    if [ ! -f "$_rule" ] ; then
+        if [ "$transport" =3D "fc" ] ; then
+            cat > $_rule <<EOF
+ACTION=3D=3D"add", SUBSYSTEM=3D=3D"fc_remote_ports", ATTR{port_name}=3D=3D=
"$tgtid", PROGRAM=3D"fc_transport_scan_lun.sh $lun"
+EOF
+        elif [ "$transport" =3D "sas" ] ; then
+            cat > $_rule <<EOF
+ACTION=3D=3D"add", SUBSYSTEM=3D=3D"sas_device", ATTR{sas_address}=3D=3D"=
$tgtid", PROGRAM=3D"sas_transport_scan_lun.sh $lun"
+EOF
+        fi
+    fi
+}
+
+for lunmask_arg in $(getargs rd.lunmask); do
+    (
+        local OLDIFS=3D"$IFS"
+        local IFS=3D","
+        set $lunmask_arg
+        IFS=3D"$OLDIFS"
+        if [ -d /sys/module/scsi_mod ] ; then
+            echo -n "disabled" > /sys/module/scsi_mod/parameters/scan
+        elif [ ! -f /etc/modprobe.d/95lunmask.conf ] ; then
+            echo "options scsi_mod scan=3Ddisabled" > /etc/modprobe.d/95=
lunmask.conf
+        fi
+        create_udev_rule $1 $2 $3
+    )
+done
diff --git a/modules.d/95lunmask/sas_transport_scan_lun.sh b/modules.d/95=
lunmask/sas_transport_scan_lun.sh
new file mode 100755
index 0000000..f7702f8
--- /dev/null
+++ b/modules.d/95lunmask/sas_transport_scan_lun.sh
@@ -0,0 +1,26 @@
+#!/bin/bash
+#
+# sas_transport_lun_scan
+#
+# Selectively enable individual LUNs behind a SAS end device
+#
+# ACTION=3D=3D"add", SUBSYSTEM=3D=3D"sas_transport", ATTR{sas_address}=3D=
=3D"sas_addr", \
+#    PROGRAM=3D"sas_transport_lun_scan lun"
+#
+
+[ -z $DEVPATH ] && exit 1
+
+if [ -n "$1" ] ; then
+    LUN=3D$1
+else
+    LUN=3D-
+fi
+ID=3D${DEVPATH##*/end_device-}
+HOST=3D${ID%%:*}
+CHANNEL=3D${ID%%-*}
+CHANNEL=3D${CHANNEL#*:}
+if [ -f /sys$DEVPATH/scsi_target_id ] ; then
+    TARGET=3D$(cat /sys$DEVPATH/scsi_target_id)
+fi
+[ -z "$TARGET" ] && exit 1
+echo 0 $TARGET $LUN > /sys/class/scsi_host/host$HOST/scan
--=20
2.6.2


--------------020107080006020807030000--
