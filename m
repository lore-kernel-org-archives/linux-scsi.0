From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15688] mptsas & poor performance
Date: Thu, 29 Apr 2010 08:36:13 GMT
Message-ID: <201004290836.o3T8aDJ9006885@demeter.kernel.org>
References: <bug-15688-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:40848 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039Ab0D3Rbr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Apr 2010 13:31:47 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o3T8aJFi006903
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 29 Apr 2010 08:36:19 GMT
In-Reply-To: <bug-15688-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=15688


Albert Strasheim <fullung@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |fullung@gmail.com




--- Comment #7 from Albert Strasheim <fullung@gmail.com>  2010-04-29 08:35:27 ---
I've been seeing a similar issue with a LSI 1068 connected to a Sun J4400 JBOD.
Solaris can drive a single 4-port PHY (12Gb/s) at about 1000 MB/sec but Linux
maxes out at 830 MB/sec running 2.6.32 included with RHEL 6 beta.

As I write to more disks at the same time, the throughput (MB/sec) per disk
starts dropping after the 7th disk:

#disks  thruput  tpdelta  tp/disk expected tp
1     82     0     82.00    82
2     165    83    82.50    164
3     248    83    82.67    246
4     331    83    82.75    328
5     413    82    82.60    410
6     494    81    82.33    492
7     578    84    82.57    574
8     623    45    77.88    656
9     643    20    71.44    738
10    659    16    65.90    820
11    671    12    61.00    902
12    681    10    56.75    984 

I'll do some tests with 4.22.00.00 now.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
