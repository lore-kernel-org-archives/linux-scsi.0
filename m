From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15341] Load goes up very high when we traverse the large tree
Date: Fri, 19 Feb 2010 13:23:21 GMT
Message-ID: <201002191323.o1JDNLxO015642@demeter.kernel.org>
References: <bug-15341-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:34824 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0BSNXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Feb 2010 08:23:22 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o1JDNLdV015643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 19 Feb 2010 13:23:21 GMT
In-Reply-To: <bug-15341-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15341





--- Comment #4 from Frederic MASSOT <frederic@juliana-multimedia.com>  2010-02-19 13:22:55 ---
Hi,

There are tons of process in "D" state, over there and load up.

Below is the list of processes when the load rises during an rsync backup

Regards.

$ ps auxf |grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       606  0.0  0.0      0     0 ?        D    Feb15   0:13  \_
[kjournald]
root      1306  0.0  0.0      0     0 ?        D    Feb15   0:02  \_
[flush-8:0]
root      1706  0.0  0.0   3164   980 ?        Ds   Feb15   0:11 /sbin/syslogd
backuppc  1635  0.0  0.0   1824   412 ?        Ss   05:38   0:00  |       \_
dash -c nice -n 19 /usr/bin/sudo /usr/bin/rsync --server --sender --numeric-ids
--perms --owner --group -D --links --hard-links --times --block-size=2048
--recursive --ignore-times . /
root      1636  3.3  2.0  71600 64240 ?        D    05:38  10:18  |          
\_ /usr/bin/rsync --server --sender --numeric-ids --perms --owner --group -D
--links --hard-links --times --block-size=2048 --recursive --ignore-times . /
fredo    14179  0.0  0.0   3604   648 pts/0    D+   10:48   0:00             
\_ grep D
root     14168  3.3  0.0      0     0 ?        D    10:48   0:00          \_
[php]
root     14171  0.0  0.0      0     0 ?        D    10:48   0:00  \_ [watchdog]
www-data 13817  0.0  0.6  80096 20424 ?        D    10:40   0:00  \_
/usr/sbin/apache2 -k start
www-data 13821  0.2  1.1  91192 36468 ?        D    10:40   0:01  \_
/usr/sbin/apache2 -k start
www-data 13829  0.2  1.3  86168 42340 ?        D    10:40   0:01  \_
/usr/sbin/apache2 -k start
www-data 13842  0.1  0.8  82024 27228 ?        D    10:40   0:00  \_
/usr/sbin/apache2 -k start
www-data 13852  0.0  0.6  80140 19396 ?        D    10:40   0:00  \_
/usr/sbin/apache2 -k start
www-data 13903  0.6  1.3  89280 41788 ?        D    10:42   0:02  \_
/usr/sbin/apache2 -k start
www-data 13920  0.5  1.4  92652 45708 ?        D    10:43   0:01  \_
/usr/sbin/apache2 -k start
www-data 13939  0.3  1.2  90192 39556 ?        D    10:43   0:01  \_
/usr/sbin/apache2 -k start
www-data 13944  0.1  0.7  80024 23992 ?        D    10:43   0:00  \_
/usr/sbin/apache2 -k start
www-data 13948  0.1  0.7  83484 22368 ?        D    10:43   0:00  \_
/usr/sbin/apache2 -k start
www-data 13965  0.0  0.6  81632 18832 ?        D    10:44   0:00  \_
/usr/sbin/apache2 -k start
www-data 13977  0.0  0.5  79876 18608 ?        D    10:44   0:00  \_
/usr/sbin/apache2 -k start
www-data 13983  0.0  0.5  79984 18132 ?        D    10:44   0:00  \_
/usr/sbin/apache2 -k start
www-data 13997  0.2  0.6  81928 20724 ?        D    10:44   0:00  \_
/usr/sbin/apache2 -k start
www-data 13999  0.1  0.5  81708 18588 ?        D    10:44   0:00  \_
/usr/sbin/apache2 -k start
www-data 14025  0.0  0.5  79928 17952 ?        D    10:45   0:00  \_
/usr/sbin/apache2 -k start
www-data 14028  0.1  0.7  83372 22508 ?        D    10:45   0:00  \_
/usr/sbin/apache2 -k start
www-data 14035  0.1  0.6  81596 20956 ?        D    10:45   0:00  \_
/usr/sbin/apache2 -k start
www-data 14038  0.0  0.5  81644 17464 ?        D    10:45   0:00  \_
/usr/sbin/apache2 -k start
www-data 14040  0.0  0.6  80016 19324 ?        D    10:45   0:00  \_
/usr/sbin/apache2 -k start
www-data 14060  0.0  0.6  82048 19060 ?        D    10:45   0:00  \_
/usr/sbin/apache2 -k start
www-data 14063  1.3  1.5  93604 46796 ?        D    10:45   0:02  \_
/usr/sbin/apache2 -k start
www-data 14072  0.0  0.5  79664 16804 ?        D    10:45   0:00  \_
/usr/sbin/apache2 -k start
www-data 14085  0.0  0.5  79388 16976 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14093  0.1  0.5  79872 18176 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14095  0.0  0.5  79636 15648 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14098  0.0  0.5  79768 18396 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14105  0.0  0.5  79404 18332 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14106  0.1  0.5  81876 18008 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14108  0.0  0.5  81520 16980 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14109  0.1  0.5  81256 17484 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14110  0.0  0.5  79848 17104 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14112  0.0  0.5  81688 17316 ?        D    10:46   0:00  \_
/usr/sbin/apache2 -k start
www-data 14127  0.0  0.5  79520 15980 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14128  0.0  0.4  79144 13084 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14132  0.0  0.4  79484 13220 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14135  0.0  0.4  79504 13292 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14136  0.0  0.4  79144 12748 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14137  0.0  0.4  79144 12748 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14138  0.0  0.4  79144 12748 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14139  0.0  0.4  79504 13292 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14140  0.0  0.4  79504 13296 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14142  0.0  0.4  79504 13292 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14149  0.0  0.4  79172 12944 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14151  0.0  0.5  79840 15740 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14152  5.5  1.2  89856 39336 ?        D    10:47   0:01  \_
/usr/sbin/apache2 -k start
www-data 14154  0.0  0.4  79172 12944 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14155  0.0  0.4  79180 12944 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14156  0.0  0.5  79840 15728 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14157  0.0  0.4  79648 13336 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14159  0.0  0.3  79344 12132 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14160  0.4  0.5  81264 17420 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14163  0.1  0.5  79312 16396 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14164  0.0  0.4  79144 13016 ?        D    10:47   0:00  \_
/usr/sbin/apache2 -k start
www-data 14170  0.0  0.4  79504 13268 ?        D    10:48   0:00  \_
/usr/sbin/apache2 -k start
www-data 14173  0.0  0.3  79120 12048 ?        D    10:48   0:00  \_
/usr/sbin/apache2 -k start
www-data 14177  0.0  0.4  79504 13268 ?        D    10:48   0:00  \_
/usr/sbin/apache2 -k start

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug.
