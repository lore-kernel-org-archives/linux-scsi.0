From: Joel Becker <Joel.Becker@oracle.com>
Subject: qla2300 & mptscsih refcount, or lack thereof
Date: Fri, 30 Dec 2005 15:50:30 -0800
Message-ID: <20051230235030.GX18439@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.122.30]:57481 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S964970AbVL3Xup (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2005 18:50:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Folks,
	I've run into an interesting problem.  The qla2300 and
mptspi drivers don't get refcounted for active users, but they are
absolutely required.  Thus, you can do, eg, "rmmod qla2300" with mounted
filesystems, and your system happily removes all child devices.
Hello, EIO!
	Now, I know we're well into "Doctor, it hurts when I do this,"
territory here.  But we generally try not to allow this sort of mistake.
You can't remove a network card while the interface is up, you can't
remove sd_mod while a disk is in use, etc.
	Has this been seen before?  Is there any plan to make qla2300
and mptspi respect the use count of the objects they present to the
system?  Thoughts?

Joel

-- 

Life's Little Instruction Book #222

	"Think twice before burdening a friend with a secret."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
