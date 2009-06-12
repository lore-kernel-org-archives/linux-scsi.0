From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13519] New: Syntax error. Not enough parameters for macro
 'qla_printk'.
Date: Fri, 12 Jun 2009 12:25:13 GMT
Message-ID: <bug-13519-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:60737 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbZFLMZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2009 08:25:11 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n5CCPDtO030612
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2009 12:25:13 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=13519

           Summary: Syntax error. Not enough parameters for macro
                    'qla_printk'.
           Product: SCSI Drivers
           Version: 2.5
    Kernel Version: 2.6.30
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: QLOGIC QLA2XXX
        AssignedTo: scsi_drivers-qla2xxx@kernel-bugs.osdl.org
        ReportedBy: ettl.martin@gmx.de
        Regression: No


Hi,

i have detected a wrong macro call in file qla_sup.c. To detect this issue i
used the static code analysis tool cppcheck. It prints the following output:

[linux-2.6.30/drivers/scsi/qla2xxx/qla_sup.c:352]: (error) Syntax error. Not
enough parameters for macro 'qla_printk'.

Take a look at file qla_sup.c line 352 

                DEBUG9_10(qla_printk(
                    "NVRAM didn't go ready...\n"));


The maro definition is in file qla_def.h (2657):

#define qla_printk(level, ha, format, arg...) \
    dev_printk(level , &((ha)->pdev->dev) , format , ## arg)

As you can see, it needs more than one parameter.

Best regards

Ettl Martin

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
