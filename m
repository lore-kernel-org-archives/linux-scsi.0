Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48D1FC77B70
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 12:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbjDQMs2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 08:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjDQMsY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 08:48:24 -0400
Received: from wnew3-smtp.messagingengine.com (wnew3-smtp.messagingengine.com [64.147.123.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB35459DD;
        Mon, 17 Apr 2023 05:48:01 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 0130C2B067AA;
        Mon, 17 Apr 2023 08:48:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 17 Apr 2023 08:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1681735680; x=
        1681736280; bh=R9QFYCJR9t4JE3rzfKuFGqladYR/WcBQuAHqEYVgryA=; b=T
        4oSUiC5oTaDoCPbdIL/ZOOLIKlX8lY5SLepV7cKDIpU2wwbUDE6D22oW3/Sis7io
        Vs4jQsG6wPYEROzOS+dUxLL2R493RT0flfZ6an1x0WU7Z2F3GKegV8Et+6eCmxL5
        2SKxG997oFLhEC5TwNUXlQMDe+7eQTzFgAznvX/SZN8/EfE4lzvl3IDs8sHPPzk7
        wKVlmK3DBmKJfXNOv/lwOGZ6nbiUpjse6aHsM6o/Vx91UB1rIwcvLELMFoj9h+DE
        o70vS4Kalsu7yT1RTYHAd6xH+pxcyFGSkpbaLY/WV6xVZdNfcgRRWNns1rqmi85U
        s5FMMUVyEVPgv9WwVshcQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3; t=
        1681735680; x=1681736280; bh=R9QFYCJR9t4JE3rzfKuFGqladYR/WcBQuAH
        qEYVgryA=; b=V6BqtLBh1+SPg7ae/AjYvvqSOBS3fcdczdED/0vbSlF5je8p8qI
        i9Ukpl1x67YxNBpIU08ofarU04aTzP1Hx4tutloGEnzb9Z5M8IsNzOAUiCankvXE
        XEfnT2rf+TT8LkD1l7PzI0Tqu1aqwVdTvIPQzD/GRXwj+JSXUXw5kFoL16NJqf5w
        sPIctOiKwfb8cZyLqgkiRCsoQ6tr28qmVZmcBWvByc0Wa+mo4mbVaIW6u/WQxnyY
        fTKjM5Qgi3SW2gXXIQdsgXJaDrLJQDpquJFdmTmdTC1IjwgsrH4a0h8YBSPLyzVq
        vTxSp331Q1q7YE7hqLnGsqRn7l5izweBW1g==
X-ME-Sender: <xms:AEA9ZCWtOc_IC1hT382tZN1AoD8SPEkWZ0LSLgxNap6q7BEw-FbbbA>
    <xme:AEA9ZOkSMAkRpCeESs1w4vH2E9_RihzIUBz_6qrr24HoNdhys4WmQWjAtsBJB0keZ
    XVz6atg9duFQkZhw4k>
X-ME-Received: <xmr:AEA9ZGa7oY5U1NPqUT1AWhV9RFRTaOTbWyqZVMZJx9q5gZ_V70ozU5M5D_AO7whX6OImukZ8wdxXJo2hP4mwDLMyZVRy7TLkph90H-DR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefuhhhinhdkihgthhhirhhoucfmrgifrghsrghkihcuoehs
    hhhinhhitghhihhrohesfhgrshhtmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpe
    fggfegffejgeefueetgeeukedvhfeludfhhefftdeitdfhteelieefiefhueekgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehshhhinhhitg
    hhihhrohesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:AEA9ZJXaJYT207nbBB4R5IxKsomGEzdNS2e6-KxJwgopSHYUgHyIvQ>
    <xmx:AEA9ZMmzHzoGwIBfdhWxH3ET3XZknpOqhW2pbMxtKwBYgaA5E3sX-w>
    <xmx:AEA9ZOe-OMdYbFeHa6fS-w7I1wa7cHNnj5oBVuBLJOe6tIUT20uAvQ>
    <xmx:AEA9ZBwRmL6ffGtND2YjjvwhtCCsZuLGCcwoVWchw6QwMNNQRoaQqLn03lwff5-F>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 08:47:58 -0400 (EDT)
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Shin'ichiro Kawasaki <shinichiro@fastmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH blktests 4/9] common/scsi_debug: introduce _configure_scsi_debug
Date:   Mon, 17 Apr 2023 21:47:23 +0900
Message-Id: <20230417124728.458630-5-shinichiro@fastmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230417124728.458630-1-shinichiro@fastmail.com>
References: <20230417124728.458630-1-shinichiro@fastmail.com>
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
_scsi_debug_key_path to search sysfs files corresponding to the keys in
/sys/bus/pseudo/drivers/scsi_debug or /sys/module/scsi_debug/parameters.
When it finds the file, it writes the value to the file. The original
values of the files are kept in the global array SCSI_DEBUG_VALUES and
restored by _exit_scsi_debug.

Among the parameters, 'add_host' has special meaning to add new hosts.
Then it is handled separately so that it is set at last in
_configure_scsi_debug, and restored at first in _exit_scsi_debug. Also,
record the hosts which exist before _configure_scsi_debug in the array
ORIG_SCSI_DEBUG_HOSTS. Those hosts should not be used for testing, then
do not add them to SCSI_DEBUG_HOSTS.

Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 common/scsi_debug | 113 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/common/scsi_debug b/common/scsi_debug
index 0bf768a..ee9edac 100644
--- a/common/scsi_debug
+++ b/common/scsi_debug
@@ -8,16 +8,49 @@ _have_scsi_debug() {
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
@@ -59,10 +92,88 @@ _init_scsi_debug() {
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
+	SCSI_DEBUG_KEYS=()
+	SCSI_DEBUG_VALUES=()
+	for o in "$@"; do
+		key=${o%=*}
+		value=${o#*=}
+		SCSI_DEBUG_KEYS+=("${key}")
+		values+=("${value}")
+		if ! path=$(_scsi_debug_key_path "${key}"); then
+			echo "sysfs to write $key is not avaialbe"
+			return 1
+		fi
+		if [[ $key == add_host ]]; then
+			SCSI_DEBUG_VALUES+=("-${value}")
+			add_host_value=${value}
+		else
+			SCSI_DEBUG_VALUES+=("$(<"${path}")")
+			echo -n "${value}" > "${path}"
+		fi
+	done
+
+	echo "${add_host_value}" > ${SD_PSEUDO_PATH}/add_host
+
+	udevadm settle
+
+	_setup_scsi_debug_vars
+}
+
 _exit_scsi_debug() {
+	local i key path add_host_value=-1
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
+	for ((i = 0; i < ${#SCSI_DEBUG_KEYS[@]}; i++)); do
+		key=${SCSI_DEBUG_KEYS[i]}
+		if [[ $key == add_host ]]; then
+			add_host_value=${SCSI_DEBUG_VALUES[i]}
+		fi
+	done
+	echo "${add_host_value}" > ${SD_PSEUDO_PATH}/add_host
+
+	for ((i = 0; i < ${#SCSI_DEBUG_KEYS[@]}; i++)); do
+		key=${SCSI_DEBUG_KEYS[i]}
+		if ! path=$(_scsi_debug_key_path "${key}"); then
+			echo "sysfs to write $key is not avaialbe"
+			return 1
+		fi
+		if [[ $key != add_host ]]; then
+			echo -n "${SCSI_DEBUG_VALUES[i]}" > "${path}"
+		fi
+	done
+	unset SCSI_DEBUG_KEYS
+	unset SCSI_DEBUG_VALUES
 }
-- 
2.39.2

