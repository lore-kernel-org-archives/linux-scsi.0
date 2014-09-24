From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 85101] hpsa + P410 does not show connected HP SAS port
 expanders
Date: Wed, 24 Sep 2014 18:22:25 +0000
Message-ID: <bug-85101-11613-jK5RZ9LkvH@https.bugzilla.kernel.org/>
References: <bug-85101-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:58256 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994AbaIXSWa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 14:22:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D428820253
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 18:22:28 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 8ECBA20279
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2014 18:22:25 +0000 (UTC)
In-Reply-To: <bug-85101-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=85101

Robert Elliott <elliott@hp.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |elliott@hp.com

--- Comment #1 from Robert Elliott <elliott@hp.com> ---
Smart Array P410 is a RAID controller that does not expose anything about the
SAS fabric (expanders or physical drives) to the OS; it just presents logical
drives.  You need to use HP management tools to download firmware to expanders
and drives behind the controller.

If you attach the expander to an HBA, then you can use sg_write_buffer to
download microcode.  Version 1.39 added a --bpw option to download in small
chunks - an expander might require a small chunk size like 4 KiB (see
http://sg.danny.cz/sg for the latest sg3_utils code).

Although they sound like DOS programs, .scexe files from HP are really linux
executable scripts that you can view in a text editor (at least the first
part).  You can do this to extract the files:
mkdir tmp
./CPxyzzy.scexe --unpack=tmp

One of those is the binary image that can be sent with sg_write_buffer.

BTW, use lsscsi -g to see the /dev/sgNN paths for all the devices presented by
the LLD, including expanders.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
