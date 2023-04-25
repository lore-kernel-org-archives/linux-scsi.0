Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C0DC77B76
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 11:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbjDYLs3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 07:48:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233942AbjDYLsZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 07:48:25 -0400
Received: from wnew1-smtp.messagingengine.com (wnew1-smtp.messagingengine.com [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3C54EF1;
        Tue, 25 Apr 2023 04:48:12 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 11CA42B066FB;
        Tue, 25 Apr 2023 07:48:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 25 Apr 2023 07:48:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1682423291; x=
        1682423891; bh=3o57Vu+6cMoSzzSV06r+8NKcwF7Yj7YTR1aMvfIynN0=; b=L
        HV0Ab1C/A26Sp/b7iTkvrPEmChQs6oWfcD5R5Ynptc5++Wj3/g8m63w96iqmn9LP
        befD0eoRZn6mH6SxzgsXlI+vKAUdiDx+A/khwnQ2JOL1A5zJvSPUsDAsh2R64LFR
        8nXdKn7VPtRS71ct/xnEHBQ7xDJvlGTekoyUdeyG4a1H0UC17awoiquSWa0khid9
        JJVwxNvviGNb2CjIZnf/nu1SO+lYGjMQYbQWgPixtmGJ8FiSemVW1lFRzGjm3NsG
        gEPhRFEESAwgCp7rbdD8Tk/YkGImPIaa/jmLLgjn6L2dwE8FCzJqjKXnEs9ppTSO
        NKHdlkC+mY3Fd00KLYNYA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1682423291; x=1682423891; bh=3o57Vu+6cMoSzzSV06r+8NKcwF7Yj7YTR1a
        MvfIynN0=; b=RvXDoIhGq5LyCC9C1F67F+1gp8GMwZp+VxZeqsRDIOvDpaO1Qjn
        if36CI2R3CsxwpXO84ivMf+RncvtOABKirBxcMUvB6v4XdZoeo5FR/WPtOWsevBJ
        2wf2hnI+ss3+LPmsEvCK5OsRhkHv2IOuOf9H2DBUQadZI0nhqjT/OJjjk7gtZGD2
        uWYYJc90XilqHOjYRX4ZuXxUJ4WCzQrjdawx6FWZ5YgMje78IzyhyTlKabRA5TTE
        qQeZQMYfpoTrVnHjq0zl/lhat5DplVOHwb1P1OcAya5Cf3cF3BtwL5kr9WDCbUvI
        33BslNlfMteJvq7bBv4EPtC1cTOeMrdxAnw==
X-ME-Sender: <xms:-71HZC6xJxFUmFZP2si5tmXMmdDt_P6wpYPQsbsBV7RExj2dTox7WQ>
    <xme:-71HZL7gc3mTrupor2vNovy26wcQH4uJ71zXwAe1DJSM2BjgFto6I_ifCbcMKHQj6
    zTNm-KVgVN-1WG_3wA>
X-ME-Received: <xmr:-71HZBe9ybx8O9LYFZVVehYSYQRFuYsMxB14q5rphLaBg0KUKQNAa93NvJBP6VnoiRzK97HZSDGu5A17ZadTgB6buU-0Czw_4vQh6omR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeduvddggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhhihhn
    kdhitghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrg
    hilhdrtghomheqnecuggftrfgrthhtvghrnhepgffggeffjeegfeeuteegueekvdfhledu
    hfehffdtiedthfetleeifeeihfeukeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtgho
    mh
X-ME-Proxy: <xmx:-71HZPKY3ykwcQ_CAywSAESLA6oQpNx9x-s3ZHYANTBYl1N33AyAzA>
    <xmx:-71HZGJP-c57Q8AqmZW0VxzM_BYv3n41Ihg6ZMVxEGrgYS-gGxeA3w>
    <xmx:-71HZAx1t8jIpJHnTMMbHV2m4dY8M3sctmGwfnovls4nTk9q8FG7dg>
    <xmx:-71HZC3wvBWxvYNVHv5s2PSq5_ccaia4WGB_wRK-YtAY3KK8t3HATuANnVjp2wNJ>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 25 Apr 2023 07:48:09 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Chaitanya Kulkarni <kch@nvidia.com>,
        Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests v2 4/6] common/scsi_debug: introduce _configure_scsi_debug
Date:   Tue, 25 Apr 2023 20:47:43 +0900
Message-Id: <20230425114745.376322-5-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425114745.376322-1-shinichiro@fastmail.com>
References: <20230425114745.376322-1-shinichiro@fastmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

To set up scsi_debug devices with built-in scsi_debug module, introduce
a new helper function _configure_scsi_debug. It works in similar manner
as _init_scsi_debug which sets up scsi_debug devices with loadable
scsi_debug module.

_configure_scsi_debug takes parameters of scsi_debug devices in format
of 'key=value' as its arguments. It calls another new helper function
_scsi_debug_key_path to find sysfs files corresponding to the keys in
/sys/bus/pseudo/drivers/scsi_debug or /sys/module/scsi_debug/parameters.
When the file is found, write the value to the file.

Before setting the parameters through sysfs files, save current values
of scsi_debug parameters in ORIG_SCSI_DEBUG_PARAMS. Use the saved values
to restore parameters in _exit_scsi_debug. Do this value restore not
only for the parameters modified in _configure_scsi_debug but also for
the parameters modified by test cases.

Among the parameters, 'add_host' has special meaning to add new hosts.
Then handle it separately so that it is set at last in
_configure_scsi_debug, and restored at first in _exit_scsi_debug.

Also record the hosts which exist before _configure_scsi_debug in the
array ORIG_SCSI_DEBUG_HOSTS. Those hosts should not be used for testing,
then do not add them to SCSI_DEBUG_HOSTS.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 common/scsi_debug | 112 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 111 insertions(+), 1 deletion(-)

diff --git a/common/scsi_debug b/common/scsi_debug
index 0bf768a..3d83d8a 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -8,16 +8,51 @@ _have_scsi_debug() {
 	_have_driver scsi_debug
 }
 
+SD_PSEUDO_PATH=/sys/bus/pseudo/drivers/scsi_debug
+SD_PARAM_PATH=/sys/module/scsi_debug/parameters
+
+_scsi_debug_key_path() {
+	local key=${1}
+
+	path="${SD_PSEUDO_PATH}/$key"
+	if [[ ! -e $path ]]; then
+		path="${SD_PARAM_PATH}/$key"
+	fi
+	if [[ ! -w $path ]]; then
+		return 1
+	fi
+
+	echo "$path"
+}
+
+declare -a SCSI_DEBUG_HOSTS
+declare -a SCSI_DEBUG_TARGETS
+declare -a SCSI_DEBUG_DEVICES
+declare -a ORIG_SCSI_DEBUG_HOSTS
+declare -A ORIG_SCSI_DEBUG_PARAMS
+declare SCSI_DEBUG_ADD_HOST_RESTORE_VALUE
+
 _setup_scsi_debug_vars() {
 	local host_sysfs host target_sysfs target
+	local -i i
+
 	SCSI_DEBUG_HOSTS=()
 	SCSI_DEBUG_TARGETS=()
 	SCSI_DEBUG_DEVICES=()
+
 	for host_sysfs in /sys/class/scsi_host/*; do
 		if [[ "$(cat "${host_sysfs}/proc_name")" = scsi_debug ]]; then
 			host="${host_sysfs#/sys/class/scsi_host/host}"
+			local orig_host=0
+			for ((i=0;i<${#ORIG_SCSI_DEBUG_HOSTS[@]};i++)); do
+				if (( host == ORIG_SCSI_DEBUG_HOSTS[i])); then
+					orig_host=1
+				fi
+			done
+			((orig_host)) && continue
 			SCSI_DEBUG_HOSTS+=("$host")
 			for target_sysfs in /sys/class/scsi_device/"$host":*; do
+				[[ ! -e $target_sysfs ]] && break
 				target="${target_sysfs#/sys/class/scsi_device/}"
 				SCSI_DEBUG_TARGETS+=("$target")
 				SCSI_DEBUG_DEVICES+=("$(ls "$target_sysfs/device/block")")
@@ -59,10 +94,85 @@ _init_scsi_debug() {
 	_setup_scsi_debug_vars
 }
 
+_configure_scsi_debug() {
+	local -a args=("$@")
+	local -a values
+	local key value path add_host_value=1
+	local -i i
+
+	udevadm settle
+
+	# fall back to _init_scsi_debug because scsi_debug is loadable
+	if _module_file_exists scsi_debug; then
+		_init_scsi_debug "${args[@]}"
+		return
+	fi
+
+	# zoned device is not yet configurable due to read-only zbc parameter
+	if (( RUN_FOR_ZONED )) && ! _have_module scsi_debug; then
+		return 1
+	fi
+
+	# List SCSI_DEBUG_HOSTS before configuration
+	ORIG_SCSI_DEBUG_HOSTS=()
+	_setup_scsi_debug_vars >& /dev/null
+	ORIG_SCSI_DEBUG_HOSTS=("${SCSI_DEBUG_HOSTS[@]}")
+
+	# Save current values of all scsi_debug parameters except add_host
+	ORIG_SCSI_DEBUG_PARAMS=()
+	for path in "$SD_PSEUDO_PATH"/* "$SD_PARAM_PATH"/*; do
+		if [[ -f $path && ! $path =~ add_host ]] &&
+			   [[ $(stat -c "%A" "$path") =~ rw ]]; then
+			ORIG_SCSI_DEBUG_PARAMS["$path"]="$(<"$path")"
+		fi
+	done
+
+	# Modify parameters specifeid with key=value arguments
+	for o in "$@"; do
+		key=${o%=*}
+		value=${o#*=}
+		values+=("${value}")
+		if ! path=$(_scsi_debug_key_path "$key"); then
+			echo "sysfs to write $key is not avaialbe"
+			return 1
+		fi
+		if [[ $key == add_host ]]; then
+			add_host_value=${value}
+		else
+			echo "restore $path" >> /tmp/debug
+			echo -n "$value" > "$path"
+		fi
+	done
+
+	echo "${add_host_value}" > ${SD_PSEUDO_PATH}/add_host
+	SCSI_DEBUG_ADD_HOST_RESTORE_VALUE="-${add_host_value}"
+
+	udevadm settle
+
+	_setup_scsi_debug_vars
+}
+
 _exit_scsi_debug() {
+	local path value
+
 	unset SCSI_DEBUG_HOSTS
 	unset SCSI_DEBUG_TARGETS
 	unset SCSI_DEBUG_DEVICES
 	udevadm settle
-	modprobe -r scsi_debug
+
+	if _module_file_exists scsi_debug; then
+		modprobe -r scsi_debug
+		return
+	fi
+
+	echo "${SCSI_DEBUG_ADD_HOST_RESTORE_VALUE}" > ${SD_PSEUDO_PATH}/add_host
+
+	# Restore parameters modified in _configure_scsi_debug or during test
+	for path in "${!ORIG_SCSI_DEBUG_PARAMS[@]}"; do
+		value=${ORIG_SCSI_DEBUG_PARAMS[$path]}
+		if [[ "$value" != $(<"$path") ]]; then
+			echo -n "$value" > "$path"
+		fi
+	done
+	unset ORIG_SCSI_DEBUG_PARAMS
 }
-- 
2.40.0

