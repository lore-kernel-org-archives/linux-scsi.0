From: "Lee Xing" <lxing@Crossroads.com>
Subject: Help - memory leak issue in SCSI stack
Date: Fri, 27 Aug 2004 17:59:52 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <519672568F040C41B6FAC21ADF51B18FF0B6@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email.crossroads.com ([65.68.235.6]:61481 "HELO
	email.crossroads.com") by vger.kernel.org with SMTP id S266511AbUH0W7x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 18:59:53 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I think the following issue is memory leak related but not sure how to narrow it down.  Your help and suggestion would be helpful.

- Test Environment
    - RH Linux 9.0 (lk2.4) with patch 2.4.20-30.9
    - Dell 1U server with 2 SCSI disks.  The first
      one hold OS and utilities, while the 2nd one
      (Seagate ST318453LC) is the target iometer
      sends I/O to.
    - 2GB memory
    - Linux 'Hardware Browser' -> 'SCSI devices'
      shows "LSI 53c1030, Driver: mptscsih".  This
      is probably the built-in SCSI HBA but I'm not
      100% sure.  I can double check if some one
      tells me how.
    - iometer (v. 2003.12.16) and dynamo (v. 2003.12.16)

- Symptom
    run iometer on a different Windows machine, and 
    dynamo (the iometer client for Linux) on the Dell
    server.  Use 'top' utility on Linux to trace the
    memory usage.  Here is what I observed:

    Time (min)       Used Memory (MB)
        0                 305
        1                 461
        2                 589
        3                 679
        4                 787
        5                 894
        6                 898
        7                 973
       10                 1087
       15                 1087
       20                 1087
       30                 1087

- Question
Can we say there is a memory leak somewhere based on the above table?  If not, then why the amount of used memory keeps increasing within a certain period of time?  If so, why the amount of used memory stops increasing after 10 mins, and how I can trace which layer or component causes it?  

If I understand right, the following layers/components are involved in this I/O test:

    - Linux upper-level (sd) driver
    - Linux mid-lever driver
    - LSI low-level driver mptscsih (if the
      built-in SCSI HBA does come from LSI).
    - Linux libs, etc.
    - iometer

Any suggestion and idea would be appreciated.

Have a nice weekend!


Lee
