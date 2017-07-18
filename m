From: Jason L Tibbitts III <tibbs@math.uh.edu>
Subject: [REGRESSION] 28676d869bbb (scsi: sg: check for valid direction before starting the request) breaks mtx tape library control
Date: Mon, 17 Jul 2017 19:44:50 -0500
Message-ID: <ufafudubmkd.fsf@epithumia.math.uh.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jthumshirn@suse.de, dvyukov@google.com, hare@suse.comjthumshirn@suse.de, hch@lst.de, martin.petersen@oracle.com
List-Id: linux-scsi@vger.kernel.org

After updating my tape backup server to 4.12 I found that mtx had issues
controlling the tape library.  Good behavior:

[root@backup2 ~]# mtx -f /dev/sg7 next 0
Unloading drive 0 into Storage Element 4...done
Loading media from Storage Element 5 into drive 0...done

Bad behavior:

[root@backup2 ~]# mtx -f /dev/sg7 next 0
Unloading drive 0 into Storage Element 46...mtx: Request Sense: Long
Report=yes
mtx: Request Sense: Valid Residual=no
mtx: Request Sense: Error Code=0 (Unknown?!)
mtx: Request Sense: Sense Key=No Sense
mtx: Request Sense: FileMark=no
mtx: Request Sense: EOM=no
mtx: Request Sense: ILI=no
mtx: Request Sense: Additional Sense Code = 00
mtx: Request Sense: Additional Sense Qualifier = 00
mtx: Request Sense: BPV=no
mtx: Request Sense: Error in CDB=no
mtx: Request Sense: SKSV=no
MOVE MEDIUM from Element Address 1 to 1046 Failed

This was seen on a machine running Fedora 25 as well as an Ubuntu
machine.  Relevant tickets:
  https://bugzilla.redhat.com/show_bug.cgi?id=1471302
  http://bugzilla.kernel.org/show_bug.cgi?id=196375
  https://bugs.launchpad.net/bugs/1704512

mtx in all cases is 1.3.12; in the Fedora case that's
mtx-1.3.12-14.fc24.x86_64.  I see this with an Overland Neo T48s library
but the Ubuntu user had a Dell ML6000 and we both have completely
different HBAs and cabling (LSI3008 SAS and qla2462 FC).

I bisected this down to:

commit 28676d869bbb5257b5f14c0c95ad3af3a7019dd5
Author: Johannes Thumshirn <jthumshirn@suse.de>
Date:   Fri Apr 7 09:34:15 2017 +0200

    scsi: sg: check for valid direction before starting the request
    
    Check for a valid direction before starting the request, otherwise we
    risk running into an assertion in the scsi midlayer checking for valid
    requests.
    
    [mkp: fixed typo]
    
    Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
    Link: http://www.spinics.net/lists/linux-scsi/msg104400.html
    Reported-by: Dmitry Vyukov <dvyukov@google.com>
    Signed-off-by: Hannes Reinecke <hare@suse.com>
    Tested-by: Johannes Thumshirn <jthumshirn@suse.de>
    Reviewed-by: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

and confirmed that clean unpatched 4.12 shows the problem, while
reverting just that patch fixes the issue.  Unfortunately I don't know
enough to actually fix this, but I can easily test patches.

 - J<
