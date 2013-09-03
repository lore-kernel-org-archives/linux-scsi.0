From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60758] module scsi_wait_scan not found kernel panic on boot
Date: Tue, 03 Sep 2013 15:41:23 +0000
Message-ID: <bug-60758-11613-GKfvvO0CEv@https.bugzilla.kernel.org/>
References: <bug-60758-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:49555 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676Ab3ICPl1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Sep 2013 11:41:27 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A7632203E3
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2013 15:41:25 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 4B77C20371
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2013 15:41:23 +0000 (UTC)
In-Reply-To: <bug-60758-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=60758

--- Comment #24 from Alan Bartlett <ajb@elrepo.org> ---
(1) I have critically examined the configuration files used (from 3.10 to
3.10.10) paying particular attention to 3.10.4 v 3.10.5

There is nothing untoward in the configuration that can account for this
problem.

(2) I have performed a diff (diff -Npru) between the sources of 3.10.4 and
3.10.5

Subsequent checking the output for scsi references does not show anything
obvious, to me. The output is attached, as the file diff-3.10.4-to-3.10.5.txt

(3) Grep'ing the standard RHEL 6 /etc/rc.d/rc.sysinit file shows something
interesting on line 165 but, once again, I do not think it is relevant.

[quote]
[Duo2 ~]$ grep -n -C 10 scsi /etc/rc.d/rc.sysinit
155-# Configure kernel parameters
156-update_boot_stage RCkernelparam
157-apply_sysctl
158-
159-# Set the hostname.
160-update_boot_stage RChostname
161-action $"Setting hostname ${HOSTNAME}: " hostname ${HOSTNAME}
162-[ -n "${NISDOMAIN}" ] && domainname ${NISDOMAIN}
163-
164-# Sync waiting for storage.
165:{ rmmod scsi_wait_scan ; modprobe scsi_wait_scan ; rmmod scsi_wait_scan ; }
>/dev/null 2>&1
166-
167-# Device mapper & related initialization
168-if ! __fgrep "device-mapper" /proc/devices >/dev/null 2>&1 ; then
169-       modprobe dm-mod >/dev/null 2>&1
170-fi
171-
172-if [ -f /etc/crypttab ]; then
173-    init_crypto 0
174-fi
175-
[/quote]

-- 
You are receiving this mail because:
You are the assignee for the bug.
